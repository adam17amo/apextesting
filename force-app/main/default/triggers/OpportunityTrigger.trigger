trigger OpportunityTrigger on Opportunity (before insert) {
    OpportunityHandler.handleOpportunities(Trigger.new);

    if(!Test.isRunningTest()) {
        OpportunityHandler.makeExternalCallout();
    } else {
        OpportunityHandler.makeTestCallout();
    }
}