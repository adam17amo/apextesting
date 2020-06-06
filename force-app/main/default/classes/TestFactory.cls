@isTest
public with sharing class TestFactory {
    public static List<Account> createAccounts(Integer count, Boolean performDml) {
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < count; i++) {
            Account a = new Account();
            a.Name = 'My Account'+i;
            a.BillingStreet = '4 Privet Drive';
            a.BillingCity = 'Little Whinging';
            a.BillingState = 'Surrey';
            a.BillingCountry = 'UK';
            a.BillingPostalCode = 'SW1A 1AA';
            a.Match_Billing_Address__c = false;
            accounts.add(a);
        }
        if(performDml) {
            insert accounts;
        }
        return accounts;
    }

    public static List<Contact> createContacts(Integer count, Boolean performDml, Id accountId) {
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < count; i++) {
            Contact c = new Contact();
            c.FirstName = 'Adam';
            c.LastName = 'Contact'+i;
            c.AccountId = accountId;
            c.Email = 'adam@adamtoarchitect.com';
            contacts.add(c);
        }
        if(performDml) {
            insert contacts;
        }
        return contacts;
    }

    public static List<Opportunity> createOpportunities(Integer count, Boolean performDml) {
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Integer i = 0; i < count; i++) {
            Opportunity o = new Opportunity();
            o.Name = 'My Opp'+i;
            o.StageName = 'Prospecting';
            o.CloseDate = Date.today().addDays(30);
            opportunities.add(o);
        }
        if(performDml) {
            insert opportunities;
        }
        return opportunities;
    }

    public static List<Case> createCases(Integer count, Boolean performDml) {
        List<Case> cases = new List<Case>();
        for(Integer i = 0; i < count; i++) {
            Case c = new Case();
            c.Subject = 'My New Case';
            c.Origin = 'Web';
            cases.add(c);
        }
        if(performDml) {
            insert cases;
        }
        return cases;
    }

    public static List<User> createUsers(Integer count, Boolean performDml, String profileName,
                                        String firstName, String lastName, String email) {
        List<User> users = new List<User>();
        Profile p = [SELECT ID FROM Profile WHERE Name = :profileName];
        for(Integer i = 0; i < count; i++) {
            User u = new User();
            u.FirstName = firstName;
            u.LastName = lastName;
            u.ProfileId = p.Id;
            u.Email = email;
            u.Alias = 'test17';
            u.Username = firstName+lastName+i+'@test.com';
            u.CommunityNickname = 'test17';
            u.LocaleSidKey = 'en_US';
            u.TimeZoneSidKey = 'GMT';
            u.LanguageLocaleKey = 'en_US';
            u.EmailEncodingKey = 'UTF-8';
            users.add(u);
        }
        if(performDml) {
            insert users;
        }
        return users;
    }
}
