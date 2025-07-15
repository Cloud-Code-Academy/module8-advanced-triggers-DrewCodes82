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
        //this.setMaxLoopCount(1);
    }

    public override void beforeInsert(){ 
        OpportunityHelper.setDefaultType(newOppsList);
        
    }

    public override void afterInsert(){ 
        OpportunityHelper.createNewTask(newOppsList);
        
    }

    public override void beforeUpdate(){ 
        OpportunityHelper.validateAmount(newOppsList);
        
    }

    public override void afterUpdate(){ 
        OpportunityHelper.setPrimaryContact(newOppsList);
        OpportunityHelper.updateDescription(oldOppsMap, newOppsList);
        
    }

    public override void beforeDelete(){ 
        OpportunityHelper.preventDelete(oldOppsList);
        
    }

    public override void afterDelete(){ 
        OpportunityHelper.notifyOwnersOpportunityDeleted(oldOppsList);
    }

    public override void afterUndelete(){ 
        OpportunityHelper.assignPrimaryContact(newOppsMap);
        
    }

}