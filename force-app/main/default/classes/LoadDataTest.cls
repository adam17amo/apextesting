@isTest
public with sharing class LoadDataTest {
    @isTest
    static void testLoadedData() {
        List<sObject> accounts = Test.loadData(Account.sObjectType, 'accountData');
        System.debug('Account size is ' + accounts.size());

        List<sObject> contacts = Test.loadData(Contact.sObjectType, 'contactData');
        System.debug('Contact size is ' + contacts.size());

        List<Account> insertedAccounts = [SELECT Id, Name FROM Account];
        for(Account a : insertedAccounts) {
            System.debug('Account is ' + a);
        }
        Integer contactsUnderAccount = 0;
        List<Contact> insertedContacts = [SELECT Id, Name, AccountId FROM Contact];
        for(Contact c : insertedContacts) {
            System.debug('Contact is ' + c);
            if(c.AccountId == insertedAccounts[0].Id) {
                contactsUnderAccount++;
            }
        }
        System.assertEquals(insertedContacts.size(), contactsUnderAccount,
                'All Contacts should be under the created Account');
    }
}
