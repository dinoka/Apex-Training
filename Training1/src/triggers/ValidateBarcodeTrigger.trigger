/**
* The trigger to execute before insert Barcord object. 
* Barcord should not consist of more than 20 records and it should not be an empty.
* If all validations are passed then changed the start barcord flag to false.
*
* Author : Inoka Dissanayaka.
* Date   : 08/05/2012
*/
trigger ValidateBarcodeTrigger on Barcode__c (before insert) {

	for (Barcode__c code : Trigger.new) {
		// mandatory check.
		if(code.Barcode__c == null || code.Barcode__c.trim().equals('')) {
			code.addError('Code has empty barcode value');
			return;
		}	
		// check for maximum of 20 records.
		if(code.Barcode__c.split(',', 0).size() > 20) {
			code.addError('Code should not have more than 20 barcords.');
			return;
		}
		// change the flag to false before saving.
		code.Start_barcord_flag__c =  false;
		
	}
}