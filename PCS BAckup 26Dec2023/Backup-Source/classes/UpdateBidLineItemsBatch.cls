public class UpdateBidLineItemsBatch implements Database.Batchable < sObject > {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Name, Phoenix_Product_Family__c, Product_Family__c FROM Phoenix_Approval_Grid__c WHERE Product_Family__c = null LIMIT 50';
        if(Test.isRunningTest())query += ' LIMIT 1';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List <Phoenix_Approval_Grid__c> lineItemsList) {
        try{
            if(lineItemsList.size() > 0){
                system.debug('LineItems Size: '+lineItemsList.size());
                List<Product_Family__c> familiesList = [SELECT Old_Reference_Name__c, Name from Product_Family__c WHERE Old_Reference_Name__c != null LIMIT 50];
                system.debug('familiesList Size: '+familiesList.size());
                Map<String, String> mapOfFamilies = new Map<String, String>();
                for(Product_Family__c fam: familiesList){
                    mapOfFamilies.put(fam.Old_Reference_Name__c, fam.Id);
                }
                system.debug('mapOfFamilies: '+mapOfFamilies);
                for(Phoenix_Approval_Grid__c lineItem: lineItemsList){
                    if(mapOfFamilies.containsKey(lineItem.Phoenix_Product_Family__c)){
                     	lineItem.Product_Family__c = mapOfFamilies.get(lineItem.Phoenix_Product_Family__c);   
                    }
                }
                update lineItemsList;
            }
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'UpdateBidLineItemsBatch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
    public void finish(Database.BatchableContext BC) {
        
    }
}