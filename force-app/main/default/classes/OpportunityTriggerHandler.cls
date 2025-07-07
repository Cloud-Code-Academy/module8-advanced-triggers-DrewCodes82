public with sharing class OpportunityTriggerHandler extends TriggerHandler {
    
    private List<Opportunity> newOppsList;
    private Map<Id, Opportunity> newOppsMap;
    private List<Opportunity> oldOppsList;
    private Map<Id, Opportunity> oldOppsMap;

    public OpportunityTriggerHandler(){
        this.newOppsList = (List<Opportunity>)Trigger.new;
        this.newOppsMap = (Map<Id,Opportunity>)Trigger.newMap;
        this.oldOppsList = (List<Opportunity>)Trigger.old;
        this.oldOppsMap = (Map<Id,Opportunity>)Trigger.oldMap;
    }

    public override void beforeInsert(){ 
        
    }

}