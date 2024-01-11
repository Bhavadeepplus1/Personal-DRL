trigger PreventCustomerResponseDelete on Phoenix_Customer_Response__c (before delete) {
	Id profileId = Userinfo.getProfileId();
    String profileName = [SELECT Id, Name FROM Profile WHERE Id =:profileId].Name;
    
    for(Phoenix_Customer_Response__c custResponse : trigger.old){
        if(profileName != 'System Administrator' && !custResponse.Phoenix_Is_Recalled__c){
            system.debug('called.');
            custResponse.addError('You are not allowed to delete customer response!');
        }   
    }
}