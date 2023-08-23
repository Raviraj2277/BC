page 50000 "Stripe Setup"
{
    Caption = 'Stripe Setup';
    PageType = Card;
    SourceTable = StripeSetup;
    DeleteAllowed = false;
    InsertAllowed = false;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Payment)
            {
                Caption = 'Payment';
                field("Journal template name"; Rec."Journal template name")
                {

                }
                field("Journal Batch"; Rec."Journal Batch")
                {

                }
                field(NoSeries; Rec.NoSeries)
                {

                }
                field("Account Type"; Rec."Account Type")
                {

                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {

                }
                field("Bal. Account no."; Rec."Bal. Account no.")
                {

                }
                field("Dispute fees account no."; Rec."Dispute fees account no.")
                {

                }
                field("Dispute fees"; Rec."Dispute fees")
                {

                }


            }
            group(Controls)
            {
                Visible = AdminAccess;
                field("Post Journal automatically"; Rec."Post Journal automatically")
                {
                    ToolTip = 'Enable Post stripe journal batch automatically, please make sure Stripe auto post job que is set';
                    Visible = false;
                }
                field("Enable customer intergration"; Rec."Enable customer intergration")
                {
                    ToolTip = 'Enable Customer creation and updatation from BC to Stripe';
                }
            }
            group(Credentials)
            {
                Visible = AdminAccess;
                field("Base URL"; Rec."Base URL")
                {

                }
                field(Token; Rec.Token)
                {

                }
                field("FTL stripe payment endpoint"; Rec."FTL stripe payment endpoint")
                {

                }
            }
        }
    }
    var
        AdminAccess: Boolean;

    trigger OnOpenPage()
    var
        Rec_UserSetup: Record "User Setup";
    begin
        AdminAccess := false;
        Clear(Rec_UserSetup);
        Rec_UserSetup.Reset();
        Rec_UserSetup.SetRange("User ID", UserId);
        If Rec_UserSetup.FindFirst() then begin
            AdminAccess := Rec_UserSetup.CF_Admin;
        end;
    end;
}
