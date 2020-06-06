@isTest
public with sharing class ManualDataTest {
    @isTest
    static void manualTest() {
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

        List<Contact> accountContacts = [SELECT ID FROM Contact WHERE AccountId = :a.Id];

        System.assertEquals(contactsToCreate, accountContacts.size(),
                    'All contacts should be under the Account');
    }

    @isTest
    static void manualTest2() {
        Account a = new Account();
        a.Name = 'My Account';
        a.BillingStreet = '4 Privet Drive';
        a.BillingCity = 'Little Whinging';
        a.BillingState = 'Surrey';
        a.BillingCountry = 'UK';
        a.BillingPostalCode = 'SW1A 1AA';
        a.Match_Billing_Address__c = true;
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

        List<Contact> accountContacts = [SELECT ID FROM Contact WHERE AccountId = :a.Id];

        System.assertEquals(contactsToCreate, accountContacts.size(),
                    'All contacts should be under the Account');
    }
}
