public with sharing class OpportunityTriggerHandler extends TriggerHandler {
    
    private List<Opportunity> newOppsList = new List<Opportunity>();
    private Map<Id, Opportunity> newOppsMap = new Map<Id, Opportunity>();
    private List<Opportunity> oldOppsList = new List<Opportunity>();
    private Map<Id, Opportunity> oldOppsMap = new Map<Id, Opportunity>();

}