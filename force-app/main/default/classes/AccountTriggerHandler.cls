public with sharing class AccountTriggerHandler extends TriggerHandler { 

    private List<Account> newAccsList = new List<Account>();
    private Map<Id, Account> newAccsMap = new Map<Id, Account>();
    private List<Account> oldAccsList = new List<Account>();
    private Map<Id, Account> oldAccsMap = new Map<Id, Account>();

}