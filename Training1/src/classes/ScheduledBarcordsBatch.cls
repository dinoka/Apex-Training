/**
 * This shadulable class to execute the BarcordBatch.
 * 
 * Author : Inoka Dissanayaka
 * Date : 08/05/2012
 */
global with sharing class ScheduledBarcordsBatch implements Schedulable{
	
	global void execute(SchedulableContext sc) {
		BarcordsInactivateBatch scheduleBatch = new BarcordsInactivateBatch();
		Database.executeBatch(scheduleBatch);
		
	}
}