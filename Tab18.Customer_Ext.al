tableextension 50102 Table18 extends Customer
{
    fields
    {
        field(50066; "Stripe Id"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50067; StripeCustomer; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}
