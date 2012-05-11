/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_Contact_Edit {

    static testMethod void testEditRecord() {
               
        Contact contact1 = new Contact(FirstName = 'Pradeep', LastName = 'Nadeem', Email = 'inokas@teamwork.lk');
     	insert contact1;
     	
     	Survey__c servey1 = new Survey__c(Name = 'A servey', Active__c = true, Months__c = 'February', Year__c = '2014', 
  						Contact__c = contact1.Id, question1__c = '10%', question2__c = '10%', 
  						question3__c = '10%', question4__c = '10%', question5__c = '10%');
  		
  		insert servey1;
  		
  		Test.startTest();
  		Pagereference pageRef = Page.Contact_Edit;
        pageRef.getParameters().put('currentSurveyId', servey1.Id);
        Test.setCurrentPageReference(pageRef);
     	Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(contact1);
     	Contact_Edit myContactEdit = new Contact_Edit(sc);
     	myContactEdit.editRecord();
     	System.assert(myContactEdit.currentSurvey != null);
     	 
     	Test.stopTest();
    }
    
    static testMethod void testDeleteRecord() {
    	Contact contact1 = new Contact(FirstName = 'Pradeep', LastName = 'Nadeem', Email = 'inokas@teamwork.lk');
     	insert contact1;
     	
     	Survey__c servey1 = new Survey__c(Name = 'A servey', Active__c = true, Months__c = 'February', Year__c = '2014', 
  						Contact__c = contact1.Id, question1__c = '10%', question2__c = '10%', 
  						question3__c = '10%', question4__c = '10%', question5__c = '10%');
  		
  		insert servey1;

  		Test.startTest();
  		Pagereference pageRef = Page.Contact_Edit;
        pageRef.getParameters().put('currentSurveyId', servey1.Id);
        Test.setCurrentPageReference(pageRef);
     	Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(contact1);
     	Contact_Edit myContactEdit = new Contact_Edit(sc);
     	myContactEdit.deleteRecord();
     	System.assert(myContactEdit.surveysToBeDeleted.size() == 1);
     	System.assert(myContactEdit.surveys.size() == 0);
     	Test.stopTest();
    }
    
	static testMethod void testAddRecord() {
    	Contact contact1 = new Contact(FirstName = 'Pradeep', LastName = 'Nadeem', Email = 'inokas@teamwork.lk');
     	insert contact1;
     	
     	Survey__c servey1 = new Survey__c(Name = 'A servey', Active__c = true, Months__c = 'February', Year__c = '2014', 
  						Contact__c = contact1.Id, question1__c = '10%', question2__c = '10%', 
  						question3__c = '10%', question4__c = '10%', question5__c = '10%');
  		
  		insert servey1;
  		
     	Survey__c servey2 = new Survey__c(Name = 'B servey', Active__c = true, Months__c = 'March', Year__c = '2014', 
  						Contact__c = contact1.Id, question1__c = '10%', question2__c = '10%', 
  						question3__c = '10%', question4__c = '10%', question5__c = '10%');
  		
  		insert servey2;
  		
  		Test.startTest();
  		
  		Pagereference pageRef = Page.Contact_Edit;
        Test.setCurrentPageReference(pageRef);
     	
     	Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(contact1);
     	Contact_Edit myContactEdit = new Contact_Edit(sc);     	
     	myContactEdit.addRecord();
  		
        pageRef.getParameters().put('currentSurveyId', servey1.Id);
        Test.setCurrentPageReference(pageRef);
     	
     	sc = new Apexpages.Standardcontroller(contact1);
     	myContactEdit = new Contact_Edit(sc);
     	     	
     	myContactEdit.editRecord();
     	myContactEdit.addRecord();
     	System.assert(myContactEdit.surveys.size() == 2);
     	
     	myContactEdit.clearForm();
     	System.assert(myContactEdit.currentSurvey.Id == null);
     	
     	Test.stopTest();
    }
    
    static testMethod void testSaveRecord() {
    	Contact contact1 = new Contact(FirstName = 'Pradeep', LastName = 'Nadeem', Email = 'inokas@teamwork.lk');
     	insert contact1;
     	
     	Survey__c servey1 = new Survey__c(Name = 'A servey', Active__c = true, Months__c = 'February', Year__c = '2014', 
  						Contact__c = contact1.Id, question1__c = '10%', question2__c = '10%', 
  						question3__c = '10%', question4__c = '10%', question5__c = '10%');
  		
  		insert servey1;
  		
  		Test.startTest();
  		Pagereference pageRef = Page.Contact_Edit;
  		
        Test.setCurrentPageReference(pageRef);
     	
     	Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(contact1);
     	Contact_Edit myContactEdit = new Contact_Edit(sc);
     	
     	myContactEdit.deleteRecord();
     	
     	Boolean flag = true;
     	
     	try {
     		Pagereference ref = myContactEdit.saveRecords();
     	}catch(DmlException e) {
     		flag = false;
     	}
     	
     	System.assert(flag);
     	
     	Test.stopTest();
	}
}