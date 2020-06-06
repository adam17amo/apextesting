@isTest
public with sharing class TestClassTests {

    @isTest
    static void testExtendedGovernorLimits() {
        List<Account> accounts = TestFactory.createAccounts(100, true);
        for(Integer i = 0; i < accounts.size(); i++) {
            Account a = [SELECT ID FROM Account WHERE Id = :accounts[i].Id];
            a.Name = 'New Name'+i;
        }
        System.assertEquals(100, Limits.getQueries(), 'There should be 100 SOQL Queries');
        System.assertEquals(Limits.getQueries(), Limits.getLimitQueries(), 'SOQL Queries should be at the limit');

        Test.startTest();
            System.assertEquals(0, Limits.getQueries(), 'The Limit should have been reset');
            for(Integer i = 0; i < 10; i++) {
                Account a = [SELECT ID FROM Account WHERE Id = :accounts[i].Id];
                a.Name = 'New Name'+i;
            }
            System.assertEquals(10, Limits.getQueries(), 'The number of queries is only counted in this block');
        Test.stopTest();
    }

    @isTest
    static void testBatchReassignment() {
        Group tempQueue = [SELECT ID FROM Group WHERE Name = 'Temp Queue'];
        Integer casesToCreate = 10;
        List<Case> newCases = TestFactory.createCases(casesToCreate, true);
        // Set the owner of all cases to the Temporary Queue
        for(Case c : newCases) {
            c.OwnerId = tempQueue.Id;
        }
        update newCases;

        Integer beforeCount = [SELECT count() FROM Case WHERE OwnerId = :tempQueue.Id];
        System.assertEquals(casesToCreate, beforeCount, 'All Cases should be owned by the queue');

        // Run the batch
        Test.startTest();
            CaseReassignmentBatch crb = new CaseReassignmentBatch(UserInfo.getUserId());
            Database.executeBatch(crb);
        Test.stopTest();

        // Confirm all cases have been reassigned to the current user
        Integer afterCount = [SELECT count() FROM Case WHERE OwnerId = :tempQueue.Id];
        System.assertEquals(0, afterCount, 'No Cases should be owned by the queue after batch');
        Integer userOwned = [SELECT count() FROM Case WHERE OwnerId = :UserInfo.getUserId()];
        System.assertEquals(casesToCreate, userOwned, 'All Cases should be owned by the user');
    }

    @isTest
    static void testOldData() {
        Account a = new Account(Name='Harry Potter First Movie');
        insert a;
        Datetime firstMovieRelease = Datetime.newInstance(2001, 11, 14, 0, 0, 0);
        Test.setCreatedDate(a.Id, firstMovieRelease);

        Account firstHpMovie = [SELECT CreatedDate FROM Account WHERE ID = :a.Id];
        System.assertEquals(firstMovieRelease, firstHpMovie.CreatedDate, 'The date should match the date in the past');
    }
}
