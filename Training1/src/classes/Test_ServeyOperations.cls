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
private class Test_ServeyOperations {

    static testMethod void myUnitTest() {
    
     	Test.startTest();
     	Contact contact1 = new Contact(FirstName = 'Pradeep', LastName = 'Nadeem', Email = 'inokas@teamwork.lk');
     	insert contact1;
     	
  		Survey__c servey1 = new Survey__c(Name = 'My Servey', Months__c = 'March', Year__c = '2009', Active__c = true, Contact__c = contact1.Id, question1__c = '10%', question2__c = '10%', question3__c = '10%', question4__c = '10%', question5__c = '10%');
  		insert servey1;
  		
  		Survey__c servey2 = new Survey__c(Name = 'My Servey1', Months__c = 'May', Year__c = '2009', Active__c = true, Contact__c = contact1.Id, question1__c = '10%', question2__c = '10%', question3__c = '10%', question4__c = '10%', question5__c = '10%');
  		insert servey2;
  		
  		Survey__c servey3 = new Survey__c(Name = 'My Servey2', Months__c = 'March', Year__c = '2010', Active__c = true, Contact__c = contact1.Id, question1__c = '10%', question2__c = '10%', question3__c = '10%', question4__c = '10%', question5__c = '10%');
  		insert servey3;
  		
  		Survey__c servey4 = new Survey__c(Name = 'My Servey3', Months__c = 'December', Year__c = '2009', Active__c = true, Contact__c = contact1.Id, question1__c = '10%', question2__c = '10%', question3__c = '10%', question4__c = '10%', question5__c = '10%');
  		insert servey4;
  		
        Survey__c aServey = SurveyOperations.getServeys('', '2009', contact1.Id);
  		System.assert( null !=aServey);
  		
  		SurveyOperations.addSurvey(contact1.Id, 'name1', 'January', '2009', '10%', '10%', '10%', '10%', '10%');
  		List<Survey__c> listSurveys = [SELECT s.Id from Survey__c s WHERE s.Contact__c = :contact1.Id];
  	
 		System.assert(listSurveys.size() == 5);
  		
        Test.stopTest();
    }
    
    static testMethod void testHasRecordForThisMonth() {
   		Test.startTest();
     	Contact contact1 = new Contact(FirstName = 'Pradeep', LastName = 'Nadeem', Email = 'inokas@teamwork.lk');
     	insert contact1;
     	
  		Survey__c servey1 = new Survey__c(Name = 'wrong servey', Active__c = true, Months__c = 'February', Year__c = '2014', 
  						Contact__c = contact1.Id, question1__c = '10%', question2__c = '10%', 
  						question3__c = '10%', question4__c = '10%', question5__c = '10%');
  						
  		insert servey1;
  		
  		System.assert(SurveyOperations.hasRecordForThisMonth() == false);
  		
  		DateTime d = datetime.now();
		String month= d.format('MMMMM');
  		
  		Survey__c servey2 = new Survey__c(Name = 'This month servey', Active__c = true, Months__c = month, Year__c = '2014', 
  						Contact__c = contact1.Id, question1__c = '10%', question2__c = '10%', 
  						question3__c = '10%', question4__c = '10%', question5__c = '10%');
  						
  		insert servey2;
  						
  		System.assert(SurveyOperations.hasRecordForThisMonth() == true);
  		Test.stopTest();
  						
  						
    }
}