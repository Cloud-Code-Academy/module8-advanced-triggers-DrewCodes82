/*
AnotherOpportunityTrigger Overview

This trigger was initially created for handling various events on the Opportunity object. It was developed by a prior developer and has since been noted to cause some issues in our org.

IMPORTANT:
- This trigger does not adhere to Salesforce best practices.
- It is essential to review, understand, and refactor this trigger to ensure maintainability, performance, and prevent any inadvertent issues.

ISSUES:
Avoid nested for loop - 1 instance
Avoid DML inside for loop - 1 instance
Bulkify Your Code - 1 instance
Avoid SOQL Query inside for loop - 2 instances
Stop recursion - 1 instance

RESOURCES: 
https://www.salesforceben.com/12-salesforce-apex-best-practices/
https://developer.salesforce.com/blogs/developer-relations/2015/01/apex-best-practices-15-apex-commandments
*/
trigger AnotherOpportunityTrigger on Opportunity (before insert, after insert, before update, after update, before delete, after delete, after undelete) { 
    /* if (Trigger.isBefore){
        if (Trigger.isInsert){
            // Set default Type for new Opportunities
            for(Opportunity opp : Trigger.new){
                if (opp.Type == null){
                    opp.Type = 'New Customer';
                }
            }   
        }  */

        /* if (Trigger.isDelete){
            // Prevent deletion of closed Opportunities
            for (Opportunity oldOpp : Trigger.old){
                if (oldOpp.IsClosed){
                    oldOpp.addError('Cannot delete closed opportunity');
                }
            }
        } */
 /*    } */

   /*  if (Trigger.isAfter){ */
        /* if (Trigger.isInsert){
            // Create a new Task for newly inserted Opportunities
            List<Task> newTasks = new List<Task>();
            for (Opportunity opp : Trigger.new){
                Task tsk = new Task();
                tsk.Subject = 'Call Primary Contact';
                tsk.WhatId = opp.Id;
                tsk.WhoId = opp.Primary_Contact__c;
                tsk.OwnerId = opp.OwnerId;
                tsk.ActivityDate = Date.today().addDays(3);
                newTasks.add(tsk);
            }
            insert newTasks;
        }  */
        
       /*  if (Trigger.isUpdate){ */
            // Append Stage changes in Opportunity Description
            /* List<Opportunity> oppsToUpdate = new List<Opportunity>();
            for (Opportunity opp : Trigger.new){
                for (Opportunity oldOpp : Trigger.old){
                    if (opp.StageName != null && opp.StageName != oldOpp.StageName){
                        opp.Description += '\n Stage Change:' + opp.StageName + ':' + DateTime.now().format();
                        oppsToUpdate.add(opp);
                    }
                }                
            }
            update oppsToUpdate; */
/*         }
        // Send email notifications when an Opportunity is deleted 
        if (Trigger.isDelete){
            notifyOwnersOpportunityDeleted(Trigger.old);
        } 
        // Assign the primary contact to undeleted Opportunities
        if (Trigger.isUndelete){
            assignPrimaryContact(Trigger.newMap);
        }
    } */

    /*
    notifyOwnersOpportunityDeleted:
    - Sends an email notification to the owner of the Opportunity when it gets deleted.
    - Uses Salesforce's Messaging.SingleEmailMessage to send the email.
    */
    /* private static void notifyOwnersOpportunityDeleted(List<Opportunity> opps) {
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
 */
    /*
    assignPrimaryContact:
    - Assigns a primary contact with the title of 'VP Sales' to undeleted Opportunities.
    - Only updates the Opportunities that don't already have a primary contact.
    */
    /* private static void assignPrimaryContact(Map<Id,Opportunity> oppNewMap) {        
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
    } */
} 