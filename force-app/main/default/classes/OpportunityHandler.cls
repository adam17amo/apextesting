public with sharing class OpportunityHandler {
    public class InvalidAmountException extends Exception {}

    public static void handleOpportunities(List<Opportunity> newOpps) {
        Set<String> newOppNames = getNewOppNames(newOpps);
        Set<String> existingOppNames = getExistingOppNames(newOppNames);
        setDuplicateFlags(newOpps, existingOppNames);
    }

    @TestVisible
    // Add new Opportunity names to a Set
    private static Set<String> getNewOppNames(List<Opportunity> opps) {
        Set<String> newOppNames = new Set<String>();
        for(Opportunity o : opps) {
            newOppNames.add(o.Name);
        }
        return newOppNames;
    }

    @TestVisible
    // Get the Opportunities with names that match the newly created ones
    private static Set<String> getExistingOppNames(Set<String> newOppNames) {
        List<Opportunity> existingOpps = [SELECT Name FROM Opportunity WHERE Name IN :newOppNames];
        Set<String> oppNames = new Set<String>();
        for(Opportunity o : existingOpps) {
            oppNames.add(o.Name);
        }
        return oppNames;
    }

    @TestVisible
    // Mark all duplicate Opportunities
    private static List<Opportunity> setDuplicateFlags(List<Opportunity> newOpps, Set<String> existingOppNames) {
        for(Opportunity o : newOpps) {
            if(existingOppNames.contains(o.Name)) {
                o.Duplicate__c = true;
            }
        }
        return newOpps;
    }

    public static void makeExternalCallout() {
        // Make callout here
    }

    public static void makeTestCallout() {
        // Callout for testing purposes
    }

    public static Boolean setAmount(Id oppId, Decimal amount) {
        Boolean successfulUpdate = null;
        try {
            Opportunity opp = [SELECT Amount FROM Opportunity WHERE Id = :oppId];
            if(amount > 0) {
                opp.Amount = amount;
                update opp;
                successfulUpdate = true;
            } else if(amount == 0) {
                throw new InvalidAmountException('Amount cannot be 0');
            } else if(amount < 0) {
                throw new InvalidAmountException('Amount cannot be less than 0');
            }
        } catch(Exception e) {
            System.debug('Exception was ' + e.getMessage() + ' with Id ' + oppId);
            successfulUpdate = false;
        }
        return successfulUpdate;
    }
}
