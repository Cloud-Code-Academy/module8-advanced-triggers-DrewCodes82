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
    }

    public override void beforeInsert(){ 
        
        for (Account acc : newAccsList) {
            if (acc.Type == null) {
                acc.Type = 'Prospect';
            }
        }
    }

}