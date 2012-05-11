/**
* The stateful apex batch class to deactivate all active barcords.
*
* Author : Inoka Dissanayaka.
* Date   : 08/05/2012
*/
global with sharing class BarcordsInactivateBatch implements Database.Batchable<sObject>, Database.Stateful {
	List<Barcode__c> updatedBarcords = new List<Barcode__c>();
	
	global Database.QueryLocator start(Database.BatchableContext BC){
    	return Database.getQueryLocator([SELECT b.Id, b.Employee__r.Employee_Name__c, b.Barcode__c FROM Barcode__c b WHERE 
    												b.Start_barcord_flag__c = false]);
   	}
   	
   	global void execute(Database.BatchableContext BC, List<Barcode__c> barcords){
  
   		for (Barcode__c barcord : barcords) {
   			barcord.Start_barcord_flag__c = true;
   		}
   		
	    update barcords;
	    this.updatedBarcords = barcords;
   	}
   	
   	global void finish(Database.BatchableContext BC){
   		Messaging.reserveSingleEmailCapacity(2);
   		
   		Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
   		String[] toAddress = new String[]{'diskino@gmail.com'};
   		String[] ccAddress = new String[]{'inoka_dissanayaka@yahoo.com'};
   		
   		mail.setToAddresses(toAddress);
   		mail.setCcAddresses(ccAddress);
   		mail.setSenderDisplayName('Inoka Dissanayaka on Salesforce');
   		mail.setSubject('Barcords are deactivated...');
   		mail.setUseSignature(false);
   		
   		String text = '';
   		if(updatedBarcords != null && !updatedBarcords.isEmpty()) {
   			for (Barcode__c code : updatedBarcords) {
	   			text += code.Employee__r.Employee_Name__c + ' -> \n';
	   			
	   			String[] barcords = code.Barcode__c.split(',');
	   			
	   			for (String str : barcords) {
	   				text += str + '\n';
	   			}
   			} 
   			mail.setPlainTextBody('Follwoing barcords are deactivated. \n' + text);
   		} else {
   			mail.setPlainTextBody('No Active barcords to deactivate.');
   		}
   		
   		Messaging.sendEmail(new Messaging.Singleemailmessage[] {mail});
   	}
}