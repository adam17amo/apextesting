@isTest
public with sharing class OpportunityTests {
    @testSetup
    static void createData() {
        TestFactory.createOpportunities(5, true);
    }

    @isTest
    static void endToEndOppTest() {
        Opportunity o = new Opportunity();
        o.Name = 'My Opp0';
        o.StageName = 'Prospecting';
        o.CloseDate = Date.today().addDays(30);
        insert o;

        Opportunity newOpp = [SELECT Duplicate__c FROM Opportunity WHERE ID = :o.Id];
        System.assertEquals(true, newOpp.Duplicate__c, 'This Opp should be marked as a Duplicate');
    }

    @isTest
    static void unitTestGetNewOppNames() {
        List<Opportunity> testDataOpps = [SELECT Name FROM Opportunity];
        Set<String> oppNames = OpportunityHandler.getNewOppNames(testDataOpps);
        
        System.assert(oppNames.contains('My Opp0'), 'My Opp0 should be included');
        System.assert(oppNames.contains('My Opp1'), 'My Opp1 should be included');
        System.assert(oppNames.contains('My Opp2'), 'My Opp2 should be included');
        System.assert(oppNames.contains('My Opp3'), 'My Opp3 should be included');
        System.assert(oppNames.contains('My Opp4'), 'My Opp4 should be included');
    }

    @isTest
    static void unitTestGetExistingOppNames() {
        Opportunity o = new Opportunity(Name='My Opp0');
        Set<String> oppNames = OpportunityHandler.getExistingOppNames(new Set<String>{o.Name});

        System.assertEquals(1, oppNames.size(), 'One Opp should be returned');
        System.assert(oppNames.contains('My Opp0'), 'The newly created Opp should match the testSetup Opp');
    }

    @isTest
    static void unitTestDuplicateFlag() {
        List<Opportunity> newOpps = new List<Opportunity>();
        newOpps.add(new Opportunity(Name='My Opp0'));
        newOpps.add(new Opportunity(Name='My Opp1'));

        Set<String> existingOppNames = new Set<String>{'My Opp0'};

        List<Opportunity> dupeProcessedOpps = OpportunityHandler.setDuplicateFlags(newOpps, existingOppNames);
        System.assertEquals(true, dupeProcessedOpps[0].Duplicate__c, 'This Opp should be a duplicate');
        System.assertEquals(false, dupeProcessedOpps[1].Duplicate__c, 'This Opp should not be a duplicate');
    }
}
