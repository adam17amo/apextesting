@isTest
public with sharing class TestFactoryTests {
    @testSetup
    static void makeData(){
        List<Account> accounts = TestFactory.createAccounts(1, true);
        List<Contact> contacts = TestFactory.createContacts(10, true, accounts[0].Id);
    }

    @isTest
    static void testFactory1() {
        List<Account> accounts = [SELECT ID FROM Account];
        List<Contact> contacts = [SELECT ID FROM Contact];
        List<Contact> accountContacts = [SELECT ID FROM Contact WHERE AccountId = :accounts[0].Id];

        System.assertEquals(contacts.size(), accountContacts.size(),
                    'All contacts should be under the Account');
    }

    @isTest
    static void testFactory2() {
        List<Account> accounts = [SELECT Match_Billing_Address__c
                                    FROM Account LIMIT 1];
        accounts[0].Match_Billing_Address__c = true;
        update accounts[0];

        List<Contact> contacts = [SELECT ID FROM Contact];
        List<Account> updatedAccounts = [SELECT Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode,
                                                ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode
                                        FROM Account];
        List<Contact> accountContacts = [SELECT ID FROM Contact WHERE AccountId = :accounts[0].Id];

        System.assertEquals(contacts.size(), accountContacts.size(),
                    'All contacts should be under the Account');
    
        System.assertEquals(updatedAccounts[0].BillingStreet, updatedAccounts[0].ShippingStreet, 'Street should match');
        System.assertEquals(updatedAccounts[0].BillingCity, updatedAccounts[0].ShippingCity, 'City should match');
        System.assertEquals(updatedAccounts[0].BillingState, updatedAccounts[0].ShippingState, 'State should match');
        System.assertEquals(updatedAccounts[0].BillingCountry, updatedAccounts[0].ShippingCountry, 'Country should match');
        System.assertEquals(updatedAccounts[0].BillingPostalCode, updatedAccounts[0].ShippingPostalCode, 'Postal Code should match');
    
    }
}
