trigger DuplicateCheck on Survey__c (before insert, before update) {
	
	Set<Id> contacts = new Set<Id>();
	Set<String> months = new Set<String>();
	Set<String> years = new Set<String>();
	
	List<Survey__c> surveysToUpdate = new List<Survey__c>();
	
	for (Survey__c survey : System.Trigger.new) {
		months.add(survey.Months__c);
		years.add(survey.Year__c);
		contacts.add(survey.Contact__c);
	}
	
	List<Survey__c> existingSurveys = [SELECT Months__c, Year__c, Contact__c FROM Survey__c WHERE 
										Survey__c.Contact__c IN:contacts AND Survey__c.Months__c IN:months 
										AND Survey__c.Year__c IN:years AND Id NOT IN:Trigger.new];
					
	for (Survey__c currentSurvey : System.Trigger.new) {
		for (Survey__c existingSurvey : existingSurveys) {
			if (currentSurvey.Months__c == existingSurvey.Months__c &&
				currentSurvey.Year__c == existingSurvey.Year__c &&
				currentSurvey.Contact__c == existingSurvey.Contact__c){
				// duplicate found. adding error.
				currentSurvey.addError('Duplicate survey found.');		
			}
		}
				
		Double total = 0;
		Integer questionCount = 0;
			   
		if (currentSurvey.question1__c != null) {
		   	total = Integer.valueOf(currentSurvey.question1__c.replace('%', ''));
		
		   	questionCount++;
		}
			    
		if	(currentSurvey.question2__c != null) {
		   	total += Integer.valueOf(currentSurvey.question2__c.replace('%', ''));
		   	questionCount++;
		}
			    
		if	(currentSurvey.question3__c != null) {
		   	total += Integer.valueOf(currentSurvey.question3__c.replace('%', ''));
		   	questionCount++;
		}
			    
		if	(currentSurvey.question4__c != null) {
		   	total += Integer.valueOf(currentSurvey.question4__c.replace('%', ''));
		   	questionCount++;
		}
			    
		if	(currentSurvey.question5__c != null) {
		   	total += Integer.valueOf(currentSurvey.question5__c.replace('%', ''));
		   	questionCount++;
		}
		// Average is calculated based on the number of questions answered.
		if (questionCount > 0) {
			currentSurvey.Avarage__c = total / questionCount;
		}

		surveysToUpdate.add(currentSurvey);
	}
}