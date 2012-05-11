global with sharing class DeleteInactiveSurveys implements Database.Batchable<sObject> {
	
	global Database.QueryLocator start(Database.BatchableContext BC){
    	return Database.getQueryLocator([Select s.Id From Survey__c s WHERE s.CreatedDate 
    						!= LAST_n_DAYS:2 and s.Active__c = false]);
   	}
   	
   	global void execute(Database.BatchableContext BC, List<Survey__c> surveys){
	    //delete surveys;
   	}
   	
   	global void finish(Database.BatchableContext BC){
   		Messaging.reserveSingleEmailCapacity(2);
   		
   		Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
   		String[] toAddress = new String[]{'diskino@gmail.com'};
   		String[] ccAddress = new String[]{'inoka_dissanayaka@yahoo.com'};
   		
   		mail.setToAddresses(toAddress);
   		mail.setCcAddresses(ccAddress);
   		mail.setSenderDisplayName('Inoka Dissanayaka on Salesforce');
   		mail.setSubject('Surveys which are not activate and older than 2days have deleted...');
   		mail.setUseSignature(false);
   		mail.setPlainTextBody('Surveys has been deleted.');
   		
   		Messaging.sendEmail(new Messaging.Singleemailmessage[] {mail});
   	}
}