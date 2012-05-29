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
private class TestAddBarCords {

    static testMethod void testValidate() {
        Employee__c employee = new Employee__c(BIR__c = 'abc', City__c = 'Kandy', Country__c = 'Sri Lanka', Employee_Name__c = 'Inoka', IPN__c = 'xyz');
     	insert employee;
        Test.startTest();
  		Pagereference pageRef = Page.addbarcords;
    
        Test.setCurrentPageReference(pageRef);
     	//Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(contact1);
     	AddBarCords addBarCords = new AddBarCords();
     	addBarCords.validate();
     	System.assert(addBarCords.empFound == true);
     	
     	addBarCords.searchEmp.BIR__c = 'abc';
     	addBarCords.searchEmp.IPN__c = 'xyz';
     	addBarCords.validate();
     	System.assert(addBarCords.empFound == true);
     	 
     	Test.stopTest();	
    }
    
    static testMethod void testClearBarcords() {
    	Test.startTest();
    	Pagereference pageRef = Page.addbarcords;
    
        Test.setCurrentPageReference(pageRef);
     	AddBarCords addBarCords = new AddBarCords();
     	addBarCords.clearBarcordArea();
     	System.assert(addBarCords.barcords == null);
     	Test.stopTest();
    }
    
    static testMethod void testSaveBarcords() {
    	Employee__c employee = new Employee__c(BIR__c = 'abc', City__c = 'Kandy', Country__c = 'Sri Lanka', Employee_Name__c = 'Inoka', IPN__c = 'xyz');
     	insert employee;
     	
    	Test.startTest();
    	Pagereference pageRef = Page.addbarcords;
    
        Test.setCurrentPageReference(pageRef);
     	AddBarCords addBarCords = new AddBarCords();
     	
     	try {
     		addBarCords.barcords = '';
     		addBarCords.employee = employee;
     		addBarCords.saveBarcords();
     	}catch(Exception e) {
     		System.assert(e.getMessage().contains('Code has empty barcode value'));
     	}
     	
     	addBarCords.barcords = '125487986554' + '\n' + '124587986515';
     	addBarCords.employee = employee;
     	addBarCords.saveBarcords();
     	System.assert(addBarCords.barcords == null);
     	
     	List<Barcode__c> barcordsList = [Select b.Id, b.Barcode__c From Barcode__c b WHERE 
     							b.Employee__c = :employee.Id];
     							
		System.assert(barcordsList[0].Barcode__c.split(',').size() == 2);
     	     	
     	try {
     		addBarCords.barcords = '125487986554' + '\n' + '123587986515' + '\n' + '125787986554' + '\n' + '124585486515' + '\n' + '125489886554' + '\n' + '194587986515' + '\n' + '125454986554' + '\n' + '124573986515' + '\n' + '125487786554' + '\n' + '124587986515' + '\n' + '125487998554' + '\n' + '124587986515' + '\n' + '125487986554' + '\n' + '124587986515' + '\n' + '125487986554' + '\n' + '124587986515' + '125487986554' + '\n' + '124587986515' + '\n' + '125487986554' + '\n' + '124587986515' + '\n' + '125487986554' + '\n' + '124587986515' + '\n' + '125487986554' + '\n' + '124587986515';
     		addBarCords.employee = employee;
     		addBarCords.saveBarcords();
     	}catch(Exception e) {
     		System.assert(e.getMessage().contains('Code should not have more than 20 barcords.'));
     	}
     	Test.stopTest();
    }
    
    static testMethod void testChangeCity() {
    	Employee__c employee = new Employee__c(BIR__c = 'abc', City__c = 'Kandy', Country__c = 'Sri Lanka', Employee_Name__c = 'Inoka', IPN__c = 'xyz');
     	insert employee;
     	
    	Test.startTest();
    	Pagereference pageRef = Page.addbarcords;
    
        Test.setCurrentPageReference(pageRef);
     	AddBarCords addBarCords = new AddBarCords();
     	addBarCords.searchEmp.BIR__c = 'abc';
     	addBarCords.searchEmp.IPN__c = 'xyz';
     	
     	addBarCords.validate();
     	addBarCords.changeCities();
     	
     	System.assert(addBarCords.currentCities.size() == 2);
     	addBarCords.employee.Country__c = 'US';
     	addBarCords.changeCities();
     	System.assert(addBarCords.currentCities.size() == 2);
     	
     	addBarCords.employee.Country__c = 'England';
     	addBarCords.changeCities();
     	System.assert(addBarCords.currentCities.size() == 2);
     	
     	addBarCords.employee.Country__c = 'Australia';
     	addBarCords.changeCities();
     	System.assert(addBarCords.currentCities.size() == 2);
     	
     	addBarCords.employee.Country__c = 'None';
     	addBarCords.changeCities();
     	System.assert(addBarCords.currentCities.size() == 1);
     	
     	Test.stopTest();
    }
}