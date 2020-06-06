global with sharing class CaseReassignmentBatch implements Database.Batchable<sObject> {
    global final String userId;
    global Integer casesReassigned = 0;

    global CaseReassignmentBatch(Id userId){
        this.userId = userId;
    }

    global Database.QueryLocator start(Database.BatchableContext bc){
        Group tempQueue = [SELECT ID FROM Group WHERE Name = 'Temp Queue'];
        String query = 'SELECT OwnerId FROM Case WHERE OwnerId = \'' + tempQueue.Id + '\'';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<sObject> scope){
        List<Case> queueOwnedCases = (List<Case>)scope;
        for(Case c : queueOwnedCases){
            c.OwnerId = this.userId;
            casesReassigned++;
        }      
        update queueOwnedCases;
    }

    global void finish(Database.BatchableContext bc){
        System.debug('Cases reassigned ' + casesReassigned);
    }
}
