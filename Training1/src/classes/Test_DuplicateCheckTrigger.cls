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
private class Test_DuplicateCheckTrigger {

    static testMethod void testDuplicateCheck() {
        Test.startTest();
     	Contact contact1 = new Contact(FirstName = 'Pradeep', LastName = 'Nadeem', Email = 'inokas@teamwork.lk');
     	insert contact1;
     	
  		Survey__c servey1 = new Survey__c(Name = 'wrong servey', Active__c = true, Months__c = 'February', Year__c = '2014', 
  						Contact__c = contact1.Id, question1__c = '10%', question2__c = '10%', 
  						question3__c = '10%', question4__c = '10%', question5__c = '10%');
  						
  		insert servey1;
  		
  		Survey__c servey2 = new Survey__c(Name = 'duplicate servey', Active__c = true, Months__c = 'February', Year__c = '2014', 
  						Contact__c = contact1.Id, question1__c = '10%', question2__c = '10%', 
  						question3__c = '10%', question4__c = '10%', question5__c = '10%');
  		
  		Boolean flag = false;
  		
  		try {
  			insert servey2;
  		}catch (Dmlexception e) {
  			// should comes here since it returns a Dmlexception due to duplicate;
  			System.assert(e.getMessage().contains('Duplicate survey found.'));
  		}	
  		
  		Survey__c servey3 = new Survey__c(Name = 'not duplicate servey', Active__c = true, Months__c = 'March', Year__c = '2014', 
  						Contact__c = contact1.Id, question1__c = '10%', question2__c = '10%', 
  						question3__c = '10%', question4__c = '10%', question5__c = '10%');
  		insert servey3;
  		List<Survey__c> surveyList = [SELECT s.Id from Survey__c s WHERE s.Contact__c = :contact1.Id];
  		
  		// should increase no of serveys since it's not duplicate.
  		System.assert(surveyList.size() == 2);
  					
  		Test.stopTest();
    }
}