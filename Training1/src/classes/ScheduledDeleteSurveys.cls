global with sharing class ScheduledDeleteSurveys implements Schedulable {
	
	global void execute(SchedulableContext sc) {
		DeleteInactiveSurveys deleteServey = new DeleteInactiveSurveys();
		Database.executeBatch(deleteServey);
	}

}