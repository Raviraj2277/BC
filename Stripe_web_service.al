/// <summary>
/// This codeunit procedures used as web services for creating payment entries of stripe portal
/// </summary>
codeunit 50123 Stripe
{
    procedure CreatePaymentJournal(customerStripeId: Text[100]; repayDate: Date; paymentId: Text[100]; amount: Decimal; documentType: Text[100]): Text
    var
        Rec_Gen: Record "Gen. Journal Line";
        JnlBatch: Code[30];
        Rec_StripeSetup: Record StripeSetup;
        Rec_Cust: Record Customer;
        CustNo: Code[20];
        WebActionContext: WebServiceActionContext;
        CU_NoSeriesMgmt: Codeunit NoSeriesManagement;
        Code_GenJnPost: Codeunit "Gen. Jnl.-Post Batch";
        Code_GenJnPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        Rec_StripeSetup.Get();
        Rec_Cust.Reset();
        Clear(Rec_Cust);
        Rec_Cust.SetRange("Stripe Id", CustomerStripeId);
        If Rec_Cust.FindFirst() then
            CustNo := Rec_Cust."No.";

        Clear(Rec_Gen);
        Rec_Gen.Init();
        Rec_Gen.Validate("Line No.", Rec_Gen.GetNewLineNo(Rec_StripeSetup."Journal template name", Rec_StripeSetup."Journal Batch"));
        Rec_Gen.Validate("Posting Date", repayDate);
        Rec_Gen.Validate("Journal Template Name", Rec_StripeSetup."Journal template name");
        Rec_Gen.Validate("Journal Batch Name", Rec_StripeSetup."Journal Batch");
        case documentType of
            'Payment':
                Rec_Gen.Validate("Document Type", Rec_Gen."Document Type"::Payment);
            'Refund':
                Rec_Gen.Validate("Document Type", Rec_Gen."Document Type"::Refund);
        end;
        Rec_Gen.Validate("Account Type", Rec_Gen."Account Type"::Customer);
        Rec_Gen.Validate("Account No.", CustNo);
        Rec_Gen.Validate("Document No.", CU_NoSeriesMgmt.DoGetNextNo(Rec_StripeSetup.NoSeries, 0D, TRUE, TRUE));
        Rec_Gen.Validate(Comment, customerStripeId);
        Rec_Gen.Validate("Bal. Account Type", Rec_Gen."Bal. Account Type"::"G/L Account");
        Rec_Gen.Validate("Bal. Account No.", Rec_StripeSetup."Bal. Account no.");
        Rec_Gen.Validate(Amount, Round(amount / 100, 0.01, '>'));
        Rec_Gen.Validate("Due Date", CalcDate('CM', repayDate));
        Rec_Gen.Validate(Memo, PaymentId);
        If Code_GenJnPostLine.RunWithCheck(Rec_Gen) = 0 then
            Error('Payment did not posted.');
        Commit();
        exit('Payment journal created and Posted');
    end;
}
