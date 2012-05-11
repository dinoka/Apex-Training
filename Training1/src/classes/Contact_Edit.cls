public with sharing class Contact_Edit {
	
    public Contact con{set;get;}
    public Survey__c currentSurvey{set;get;}
    public List<Survey__c> surveysToBeEdited = new List<Survey__c>();
    public List<Survey__c> surveysToBeDeleted = new List<Survey__c>();
    
    public List<Survey__c> surveys{set;get;}

	List<String> params = new List<String>{'FirstName', 'LastName', 'MobilePhone', 'Email'};

    public Contact_Edit(ApexPages.StandardController stdController){
    	if(!test.isRunningTest()) {
    		stdController.addFields(params);
    	}
    
    	this.con = (Contact)stdController.getRecord();
    	surveys = [Select s.question5__c, s.question4__c, s.question3__c, 
    						s.question2__c, s.question1__c, s.Year__c, s.Name, s.Months__c, s.Id, 
    						s.Contact__c, s.Avarage__c From Survey__c s WHERE s.Contact__c=:this.con.Id];
    }
    
    public void editRecord() {
    	String surveyId = Apexpages.currentPage().getParameters().get('currentSurveyId');
    	// set the current survay from list of surveys
    	for (Survey__c surv : surveys) {
    		if (surv.Id == surveyId) {
    			currentSurvey = surv;
    		}
    	}
    }
    
    public void deleteRecord() {
    	String surveyId = Apexpages.currentPage().getParameters().get('currentSurveyId');
    	Integer record = -1;
    	Integer count = 0;
    	for (Survey__c surv : surveys) {
    		if (surv.Id == surveyId) {
    			surveysToBeDeleted.add(surv);
    			record = count;
    			break;
    		}
    		count++;
    	}
    	//remove the survey from the list.
    	if (record != -1) {
    		surveys.remove(record);
    	}
    }
    
    public void addRecord() {
    	// ignore if the current survay is empty.
    	if(currentSurvey == null || null == currentSurvey.Id) {
    		return;
    	}
    	
    	Integer index = -1;
    	for (Integer i = 0; i < surveys.size() -1; i++) {
    		if	(currentSurvey.Id == surveys.get(i).Id) {
    			index = i;
    		}
    	}
    	
    	// after removing existing servey from the list add the updated one to same index.
    	if (index != -1) {
    		surveys.remove(index);
    		surveys.add(index, currentSurvey);
    	}
    }
    
    public void clearForm() {
    	// replace the current survey with new survey object.
    	currentSurvey = new Survey__c();
    }
    
    public Pagereference saveRecords() {
    	System.Savepoint initPoint = Database.setSavepoint();
    	Pagereference ref = null;
    	try {
	    	update this.con;
	    	upsert surveys;
	    	delete surveysToBeDeleted;
	    	ref = new Pagereference('/' + this.con.Id);
		} catch (DmlException e) {
	    	Database.rollback(initPoint);
		} 
		return ref;
   }
}