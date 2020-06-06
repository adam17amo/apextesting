trigger AccountTrigger on Account (before insert, before update) {
    for(Account a : Trigger.new) {
        if(a.Match_Billing_Address__c) {
            if(a.BillingStreet != null) {
                a.ShippingStreet = a.BillingStreet;
            }
            if(a.BillingCity != null) {
                a.ShippingCity = a.BillingCity;
            }
            if(a.BillingState != null) {
                a.ShippingState = a.BillingCity;
            }
            if(a.BillingCountry != null) {
                a.ShippingCountry = a.BillingCountry;
            }
            if(a.BillingPostalCode != null) {
                a.ShippingPostalCode = a.BillingPostalCode;
            }
        }
    }
}