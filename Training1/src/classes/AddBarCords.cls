/**
 * This controller class of the addbarcord page.
 * 
 * Author : Inoka Dissanayaka
 * Date : 08/05/2012
 */
public with sharing class AddBarCords {
	public Employee__c employee{set;get;}
    public Barcode__c barcord{set;get;}
    public String barcords{set;get;}
    public List<Selectoption> currentCities;
    public Employee__c searchEmp{set;get;}
    public Boolean empFound{set;get;}
    
    public List<Selectoption> getcurrentCities(){
    	return getCitiList(employee.Country__c);
    }
    
    public void setcurrentCities(List<Selectoption> cities) {
    	this.currentCities = cities;
    }
    
    public AddBarCords() {
    	searchEmp = new Employee__c();
    }

	public AddBarCords(ApexPages.StandardController stdController){
    }
    
    /** 
    *The controller method to validate the search input values.
    */
    public void validate() {
    	List<Employee__c> empList = [SELECT e.Name, e.Id, e.IPN__c, e.Employee_Name__c, e.Country__c, 
    			e.City__c, e.BIR__c FROM Employee__c e WHERE e.BIR__c = :searchEmp.BIR__c 
    			AND e.IPN__c = :searchEmp.IPN__c limit 1];
    	
    	if(empList != null && empList.size() > 0) {
    		this.employee = empList[0];
    		empFound = true;
    	} else {
    		empFound = false;
    	}
    }
    
    /** 
    * The controller method to clear barcord area.
    */
    public void clearBarcordArea() {
    	this.barcords = null;
    }
    
    /**
    * The controller method to execute when user press the save button in the page.
    */
    public void saveBarcords() {
    	this.barcords = barcords.replace('\n',',');
    	Barcode__c brToSave = new Barcode__c();
    	brToSave.Barcode__c = barcords;
    	brToSave.Employee__c = employee.Id;
    	
    	System.Savepoint initPoint = Database.setSavepoint();
    	
    	try {
    		update employee;
    		insert brToSave;
    	}catch(DMLException e) {
    		// In case if fail to complete transaction.
    		Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
    		Database.rollback(initPoint);
    	}
    	// clear barcords area.
    	barcords = null;
    	Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, 'Barcords added successfully...'));
    }
    
    /**
    * Populate cities based on the selected country.
    */
    public void changeCities() {
    	currentCities = getCitiList(this.employee.Country__c);
    }
    
    /**
    * A convenient method to change city list based on the selected country.
    */
    List<Selectoption> getCitiList(String country) {
    	List<Selectoption> cities = new List<Selectoption>();
    	
    	/**Schema.DescribeFieldResult c = Employee__c.City__c.getDescribe();
    	List <Schema.PicklistEntry> cityPickList = c.getPicklistValues();
    	
    	for( Schema.PicklistEntry f : cityPickList) {
    		cities.add(new SelectOption(f.getLabel(), f.getValue()));
   		}    
    	**/
    	if(country == 'Sri Lanka') {
    		cities.add(new Selectoption('Colombo', 'Colombo'));
    		cities.add(new Selectoption('Kandy', 'Kandy'));
    	}else if(country == 'Australia') {
    		cities.add(new Selectoption('Sydney', 'Sydney'));
    		cities.add(new Selectoption('Melbourne', 'Melbourne'));
    	}else if (country == 'US'){
    		cities.add(new Selectoption('New York', 'New York'));
    		cities.add(new Selectoption('Los Angeles', 'Los Angeles'));
    	}else if (country == 'England') {
    		cities.add(new Selectoption('London', 'London'));
    		cities.add(new Selectoption('Cambridge', 'Cambridge'));
    	}else {
    		cities.add(new Selectoption('None', 'None'));
    	}
    	
    	return cities;
    }
}