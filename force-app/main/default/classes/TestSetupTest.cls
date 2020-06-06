@isTest
public with sharing class TestSetupTest {
    @testSetup
    static void testSetup() {
        Account a = new Account();
        a.Name = 'My Account';
        a.BillingStreet = '4 Privet Drive';
        a.BillingCity = 'Little Whinging';
        a.BillingState = 'Surrey';
        a.BillingCountry = 'UK';
        a.BillingPostalCode = 'SW1A 1AA';
        a.Match_Billing_Address__c = false;
        insert a;

        Integer contactsToCreate = 10;
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < contactsToCreate; i++) {
            Contact c = new Contact();
            c.FirstName = 'Adam';
            c.LastName = 'Contact'+i;
            c.AccountId = a.Id;
            c.Email = 'adam@adamtoarchitect.com';
            contacts.add(c);
        }
        insert contacts;
    }

    @isTest
    static void testSetup1() {
        List<Account> accounts = [SELECT Match_Billing_Address__c FROM Account];
        Integer contactCount = [SELECT count() FROM Contact];
        List<Contact> accountContacts = [SELECT ID FROM Contact
                                        WHERE AccountId = :accounts[0].Id];

        System.assertEquals(contactCount, accountContacts.size(),
                    'All contacts should be under the Account');
    }

    @isTest
    static void testSetup2() {
        List<Account> accounts = [SELECT Match_Billing_Address__c FROM Account];
        accounts[0].Match_Billing_Address__c = true;
        update accounts[0];
        Integer contactCount = [SELECT count() FROM Contact];
        List<Contact> accountContacts = [SELECT ID FROM Contact WHERE AccountId = :accounts[0].Id];

        System.assertEquals(contactCount, accountContacts.size(),
                    'All contacts should be under the Account');
    }
}
