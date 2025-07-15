public with sharing class OpportunityHelper {
    
    //BEFORE_INSERT
    public static void setDefaultType(List<Opportunity> oppList){

        for(Opportunity opp : oppList){
            if (opp.Type == null){
                opp.Type = 'New Customer';
            }
        }
    }

    //AFTER_INSERT
    public static void createNewTask(List<Opportunity> oppList){
        
        List<Task> newTasks = new List<Task>();
            for (Opportunity opp : oppList){
                Task tsk = new Task();
                tsk.Subject = 'Call Primary Contact';
                tsk.WhatId = opp.Id;
                tsk.WhoId = opp.Primary_Contact__c;
                tsk.OwnerId = opp.OwnerId;
                tsk.ActivityDate = Date.today().addDays(3);
                newTasks.add(tsk);
            }
            insert newTasks;
    }

    
    //BEFORE_UPDATE
    public static void validateAmount(List<Opportunity> oppList){
        for(Opportunity opp : oppList){
            if(opp.Amount < 5000){
                opp.addError('Opportunity amount must be greater than 5000');
            }
        }
    }
    //AFTER_UPDATE
    public static void setPrimaryContact(List<Opportunity> oppList){
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opp : oppList){
            accountIds.add(opp.AccountId);
        }
        
        Map<Id, Contact> contacts = new Map<Id, Contact>([SELECT Id, FirstName, AccountId FROM Contact WHERE AccountId IN :accountIds AND Title = 'CEO' ORDER BY FirstName ASC]);
        Map<Id, Contact> accountIdToContact = new Map<Id, Contact>();

        for (Contact cont : contacts.values()) {
            if (!accountIdToContact.containsKey(cont.AccountId)) {
                accountIdToContact.put(cont.AccountId, cont);
            }
        }

        for(Opportunity opp : oppList){
            if(opp.Primary_Contact__c == null && accountIdToContact.containsKey(opp.AccountId)){
                oppsToUpdate.add(new Opportunity(
                    Id = opp.Id,
                    Primary_Contact__c = accountIdToContact.get(opp.AccountId).Id
                ));                
            }
        }

        if(!oppsToUpdate.isEmpty()){
            update oppsToUpdate;
        }
    }


    public static void updateDescription(Map<Id, Opportunity> oldOppsMap, List<Opportunity> newOpps){
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        for (Opportunity opp : newOpps){
            Opportunity oldOpp = oldOppsMap.get(opp.Id);
            if (opp.StageName != null && opp.StageName != oldOpp.StageName){
                Opportunity updatedOpp = new Opportunity();
                updatedOpp.Id = opp.Id;
                updatedOpp.Description = (opp.Description == null ? '' : opp.Description) + 
                '\nStage Change:' + opp.StageName + ' : ' + Datetime.now().format();
                oppsToUpdate.add(updatedOpp);
                
            }                
        }
        update oppsToUpdate; 
    }
   

    //BEFORE_DELETE
    public static void preventDelete(List<Opportunity> oppList){
        
        for(Opportunity opp : oppList){
            if(opp.isClosed){
                opp.addError('Cannot delete closed opportunity');
            }
        }
    }

    //AFTER_DELETE
    public static void notifyOwnersOpportunityDeleted(List<Opportunity> opps) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        // Get OwnerIds from Opps
        Set<Id> ownerIds = new Set<Id>();
        for (Opportunity opp : opps) {
            if (opp.OwnerId != null) {
                ownerIds.add(opp.OwnerId);
            }
        }
        
        // Get the Opp Owners user records
        Map<Id, User> ownersMap = new Map<Id, User>(
            [SELECT Id, Email FROM User WHERE Id IN : ownerIds]
            );

        for (Opportunity opp : opps){
            User oppOwner = ownersMap.get(opp.OwnerId);
            if (oppOwner != null && oppOwner.Email != null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[]{ oppOwner.Email });
                mail.setSubject('Opportunity Deleted : ' + opp.Name);
                mail.setPlainTextBody('Your Opportunity: ' + opp.Name +' has been deleted.');
                mails.add(mail);
            }
            
        }        
        
        try {
            Messaging.sendEmail(mails);
        } catch (Exception e){
            System.debug('Exception: ' + e.getMessage());
        }
    }
    //AFTER_UNDELETE
    public static void assignPrimaryContact(Map<Id,Opportunity> oppNewMap) {        
        // Get Opp Account Ids
        Set<Id> oppAccountIds =  new Set<Id>();
        for (Opportunity opp : oppNewMap.values()){
            oppAccountIds.add(opp.AccountId);
        }
        // Get Accounts and their related child Contacts where Title = VP Sales
        Map<Id, Account> accMap = new Map<Id, Account>([SELECT Id, Name,
                                                        (SELECT Id FROM Contacts WHERE Title = 'VP Sales')
                                                        FROM Account
                                                        WHERE Id IN :oppAccountIds]);
        
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        
        for (Opportunity opp : oppNewMap.values()){            
            
            if (opp.Primary_Contact__c == null && !accMap.get(opp.AccountId).Contacts.isEmpty()){
                Opportunity oppToUpdate = new Opportunity(Id = opp.Id);
                oppToUpdate.Primary_Contact__c = accMap.get(opp.AccountId).Contacts[0].Id;
                oppMap.put(opp.Id, oppToUpdate);
            }
        }
        update oppMap.values();
    }


}