public with sharing class AccountTriggerHandler extends TriggerHandler { 

    private List<Account> newAccsList;
    private Map<Id, Account> newAccsMap;
    private List<Account> oldAccsList;
    private Map<Id, Account> oldAccsMap;

    public AccountTriggerHandler(){
        this.newAccsList = (List<Account>)Trigger.new;
        this.newAccsMap = (Map<Id,Account>)Trigger.newMap;
        this.oldAccsList = (List<Account>)Trigger.old;
        this.oldAccsMap = (Map<Id,Account>)Trigger.oldMap;
        this.setMaxLoopCount(1);
    }

    public override void beforeInsert(){ 

        AccountHelper.setTypeProspect(newAccsList);
        AccountHelper.addressCopy(newAccsList);
        AccountHelper.setRating(newAccsList);
    }

    public override void afterInsert(){ 
        
        AccountHelper.defaultContact(newAccsList);
    }

    /* public override void beforeUpdate(){ 
        
        
    }

    public override void afterUpdate(){ 
        
        
    }

    public override void beforeDelete(){ 
        
        
    }

    public override void afterDelete(){ 
        
        
    }

    public override void afterUndelete(){ 
        
        
    } */

}