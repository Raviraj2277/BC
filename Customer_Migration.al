/// <summary>
/// To migrate all customers to stripe
/// </summary>
codeunit 50148 MigrateCustomersToStripe
{
    trigger OnRun()
    var
        Rec_Cust: Record Customer;
    begin
        Rec_Cust.Reset();
        Clear(Rec_Cust);
        Rec_Cust.SetRange("Stripe Id", '');
        Rec_Cust.SetRange(StripeCustomer, true);
        If Rec_Cust.FindSet() then begin
            repeat
                CreateStripeCustomer(Rec_Cust);
            until Rec_Cust.Next = 0;
        end;

    end;


    /// <summary>
    /// Creates customer in stripe portal and update stripe id to customer in BC
    /// </summary>
    procedure CreateStripeCustomer(Rec_Customer: Record Customer)
    var
        ResponseText: Text;
        WebClient: HttpClient;
        RequestContent: HttpContent;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeader: HttpHeaders;
        ContentHeader: HttpHeaders;
        JObject: JsonObject;
        JToken: JsonToken;
        ENDPOINT: Label '/v1/customers?';
        RequestContentTxt: Text;
        BodyTextBuilder: TextBuilder;
        Rec_Stripe: Record StripeSetup;
    begin
        Rec_Stripe.Get();

        //Setting up Headers for Request
        RequestMessage.Method := 'POST';

        //Create webservice header
        RequestMessage.GetHeaders(RequestHeader);

        if RequestHeader.Contains('Authorization') then
            RequestHeader.Remove('Authorization');
        RequestHeader.Add('Authorization', 'Bearer ' + Rec_Stripe.Token);

        BodyTextBuilder.Append('name=' + Rec_Customer.Name + '&');
        BodyTextBuilder.Append('email=' + Rec_Customer."E-Mail" + '&');
        BodyTextBuilder.Append('address[city]=' + Rec_Customer.City + '&');
        BodyTextBuilder.Append('address[country]=' + Rec_Customer.County + '&');
        BodyTextBuilder.Append('address[state]=' + Rec_Customer."Post Code" + '&');
        BodyTextBuilder.Append('address[postal_code]=' + Rec_Customer."Country/Region Code" + '&');
        BodyTextBuilder.Append('address[line1]=' + Rec_Customer.Address + '&');
        BodyTextBuilder.Append('address[line2]=' + Rec_Customer."Address 2");
        RequestContentTxt := BodyTextBuilder.ToText();

        RequestMessage.SetRequestUri(Rec_Stripe."Base URL" + ENDPOINT + RequestContentTxt);

        RequestContent.GetHeaders(ContentHeader);
        If ContentHeader.Contains('content-type') then
            ContentHeader.Remove('content-type');
        ContentHeader.Add('content-type', 'application/x-www-form-urlencoded');

        RequestMessage.Content := RequestContent;
        //Assign the Request Content to the Request Message
        RequestMessage.Content(RequestContent);

        //Send webservice query
        WebClient.Send(RequestMessage, ResponseMessage);

        if ResponseMessage.IsSuccessStatusCode() then begin
            ResponseMessage.Content().ReadAs(ResponseText);
            Clear(JObject);
            JObject.ReadFrom(ResponseText);
            JObject.Get('created', JToken);
            if JToken.AsValue().AsText() = '' then begin
                JObject.Get('id', JToken);
                //Throw error if the message does not say success
                Error('There was an unexpected error while creating customer! \\ ' + JToken.AsValue().AsText());
            end;

            Clear(JToken);
            JObject.Get('id', JToken);
            Rec_Customer."Stripe Id" := JToken.AsValue().AsText();
            Rec_Customer.Modify(false);
        end else
            Error('Webservice Error - Unable to create customer in stripe');
    end;
}
