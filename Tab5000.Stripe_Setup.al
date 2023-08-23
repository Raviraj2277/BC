table 5000 StripeSetup
{
    Caption = 'StripeSetup';
    DataClassification = ToBeClassified;
    Access = Public;

    fields
    {
        field(50000; PK; Code[10])
        {
            Caption = 'PK';
            DataClassification = ToBeClassified;
        }
        field(50001; "Base URL"; Text[240])
        {
            Caption = 'Base URL';
            DataClassification = ToBeClassified;
        }
        field(50002; Token; Text[2048])
        {
            Caption = 'Token';
            DataClassification = ToBeClassified;
        }
        field(50003; "Journal Batch"; Code[10])
        {
            Caption = 'Journal Batch';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(50004; "GL/Account No."; Code[10])
        {
            Caption = 'GL/Account No.';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Line"."Account No.";
        }
        field(50005; "Bal. Account Type"; Enum "Gen. Journal Account Type")
        {
            DataClassification = CustomerContent;
        }
        field(50006; "Bal. Account no."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                    Blocked = CONST(false))
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Bal. Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Bal. Account Type" = CONST(Employee)) Employee;
        }
        field(50007; "Account Type"; Enum "Gen. Journal Account Type")
        {
            DataClassification = CustomerContent;
        }
        field(50008; "Journal template name"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
        }
        field(50009; "FTL stripe payment endpoint"; Text[240])
        {
            DataClassification = CustomerContent;
        }
        field(50010; "Post Journal automatically"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50011; "Enable customer intergration"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50012; NoSeries; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(50013; "Dispute fees account no."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                    Blocked = CONST(false))
            ELSE
            IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Bal. Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Bal. Account Type" = CONST(Employee)) Employee;
        }
        field(50014; "Dispute fees"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; PK)
        {
            Clustered = true;
        }
    }
}
