@isTest
public with sharing class TestingTypes {
    @testSetup
    static void makeData(){
        TestFactory.createOpportunities(5, true);
    }

    @isTest
    static void positiveTest() {
        Opportunity oppBefore = [SELECT Id FROM Opportunity WHERE Name = 'My Opp0'];
        Decimal oppAmount = 100.0;
        Boolean success = OpportunityHandler.setAmount(oppBefore.Id, oppAmount);
        System.assertEquals(true, success, 'Update should have been successful');

        Opportunity oppAfter = [SELECT Amount FROM Opportunity WHERE Id = :oppBefore.Id];
        System.assertEquals(oppAmount, oppAfter.Amount, 'The Amount should have been set');
    }

    @isTest
    static void negativeTest() {
        Opportunity oppBefore = [SELECT Id FROM Opportunity WHERE Name = 'My Opp0'];
        Decimal oppAmount = -100.0;
        Boolean success = OpportunityHandler.setAmount(oppBefore.Id, oppAmount);
        System.assertEquals(false, success, 'The update should have failed');

        Opportunity oppAfter = [SELECT Amount FROM Opportunity WHERE Id = :oppBefore.Id];
        System.assertEquals(null, oppAfter.Amount, 'The Amount should not have been set');
    }

    @isTest
    static void testAsStandardUser() {
        List<User> standardUsers = TestFactory.createUsers(1, true, 'Standard User', 'Adam',
                                                        'Tester', 'adam@adamtoarchitect.com');

        List<Opportunity> adminOpps = [SELECT ID FROM Opportunity];
        System.assertEquals(5, adminOpps.size(), 'All Opps should be accounted for');

        // Opportunity has a private sharing model so a new user shouldn't be able to see records
        System.runAs(standardUsers[0]) {
            List<Opportunity> standardUserOpps = [SELECT ID FROM Opportunity];
            System.assertEquals(0, standardUserOpps.size(), 'No Opps should be accounted for');
        }
    }
}
