global with sharing class SurveyOperations {
	
	webservice static Survey__c getServeys(String month, String year, String contactId) {
		if (contactId == null || contactId.trim().equals('')) {
			// contact id should not be null
			return null;
		}
		
		String queryStr = 'SELECT s.question5__c, s.question4__c, s.question3__c, s.question2__c,' + 
		's.question1__c, s.Year__c, s.SystemModstamp, s.Name, s.Months__c, s.LastModifiedDate,' +
		's.LastModifiedById, s.LastActivityDate, s.IsDeleted, s.Id, s.CreatedDate, s.CreatedById,' + 
		's.Contact__c, s.Avarage__c From Survey__c s WHERE s.Contact__c = :contactId';
		
		Integer monthNumber = getMonthNumber(month);
		
		if(monthNumber > 0 && monthNumber < 13) {
			queryStr  = queryStr + ' AND s.Months__c = :month';
		}
		
		if (year != null && !year.trim().equals('') && Integer.valueOf(year) >= 2008 && Integer.valueOf(year) <= 2020) {
			
			queryStr = queryStr + ' AND s.Year__c = :year';
		}
		
		System.debug('+++++++++++++++++++++++++++++++++++ string-> ' + queryStr + '++++++++++++++');
		
		List<Survey__c> surveys = Database.query(queryStr);
		
		System.debug('++++++++++++++++++++++ size' + surveys.size()+'+++++++++++++++++++');
		
		// The instance of Survey t	o return as a result.
		Survey__c surveyToReturn = null;
		try {
			if (surveys.size() > 0) {
				Survey__c result = surveys[0];
				Survey__c survey;
				for (Integer i = 1; i < surveys.size(); i++) {
					survey = surveys.get(i);
					if (Integer.valueOf(survey.Year__c) >  Integer.valueOf(result.Year__c)) {
						result = survey;
					}else if (Integer.valueOf(survey.Year__c) == Integer.valueOf(result.Year__c)) {
						if (getMonthNumber(survey.Months__c) > getMonthNumber(result.Months__c)) {
							result = survey;
						}
					}
				}
				surveyToReturn = result;
			}
		} catch(TypeException e) {
			throw e;
		}
		
		return surveyToReturn;
	}
	
	webservice static void addSurvey (String contactId, String name, String month, String year, String question1, 
							String question2, String question3, String question4, String question5) {
		// contact id should not be null.
		if (contactId == null || contactId.trim().equals('')) {
			return;
		}
		
		if (getMonthNumber(month) == -1) {
			// month is not valid.
			return;
		}
		
		if (Integer.valueOf(year) < 2008 || Integer.valueOf(year) > 2020) {
			// year is not valid.
			return;
		}
		
		Contact contact = [Select Id from Contact con where con.Id =:contactId];
		if (contact == null) {
			// contact does not exist for give contact id.
			return;
		}
		
		Survey__c surveyToAdd = new Survey__c();
		surveyToAdd.Contact__c = contactId;
		surveyToAdd.name = name;
		surveyToAdd.Months__c = month;
		surveyToAdd.Year__c = year;
		surveyToAdd.question1__c = question1;
		surveyToAdd.question2__c = question2;
		surveyToAdd.question3__c = question3;
		surveyToAdd.question4__c = question4;
		surveyToAdd.question5__c = question5;
		
		try {
			insert surveyToAdd;
		}catch (Exception e) {
			throw e;
		}
	}
	
	webservice static Boolean hasRecordForThisMonth() {
		
		DateTime d = datetime.now();
		String month= d.format('MMMMM');
		System.debug('++++++++++++++++++++++++++++' + month + '+++++++++++++++++++++++++++++');
		
		List<Survey__c> surveys = [Select s.Id From Survey__c s where s.Months__c = :month];
		return (surveys.size() > 0);
	}
	
	public static Integer getMonthNumber(String month) {
		Integer monthNumber = -1;
		
		Map<String, Integer> monthsMap = new Map<String, Integer>();

		monthsMap.put('January', 1);
		monthsMap.put('February', 2);
		monthsMap.put('March', 3);
		monthsMap.put('April', 4);
		monthsMap.put('May', 5);
		monthsMap.put('June', 6);
		monthsMap.put('July', 7);
		monthsMap.put('August', 8);
		monthsMap.put('September', 9);
		monthsMap.put('October', 10);
		monthsMap.put('November', 11);
		monthsMap.put('December', 12);
		
		if (month != null && !month.trim().equals('') && monthsMap.containsKey(month)) {
			monthNumber = monthsMap.get(month);
		}
		return monthNumber;
	}
}