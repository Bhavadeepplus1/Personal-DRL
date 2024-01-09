public class UpdateWACLineItemsBatch implements Database.Batchable < sObject > {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Name, Phoenix_Product_Family__c, Phoenix_WAC_Change__c, Phoenix_WAC_Change__r.Product_Family__c, Product_Family__c, Phoenix_Product__c, Phoenix_Product__r.Product_Family__c FROM Phoenix_WAC_Change_Line_Item__c WHERE Product_Family__c = null';
        if(Test.isRunningTest())query += ' LIMIT 1';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List <Phoenix_WAC_Change_Line_Item__c> lineItemsList) {
        try{
            if(lineItemsList.size() > 0){
                Map<String,Phoenix_WAC_Change__c> mapOfWACChangesToUpdate = new Map<String,Phoenix_WAC_Change__c>();
                List<Phoenix_WAC_Change__c> wacChangesToUpdate = new List<Phoenix_WAC_Change__c>();
                for(Phoenix_WAC_Change_Line_Item__c lineItem: lineItemsList){
                    Phoenix_WAC_Change__c wacChange = lineItem.Phoenix_WAC_Change__r;
                    lineItem.Product_Family__c = lineItem.Phoenix_Product__r.Product_Family__c;
                    wacChange.Product_Family__c = lineItem.Phoenix_Product__r.Product_Family__c;
                    mapOfWACChangesToUpdate.put(lineItem.Phoenix_WAC_Change__c, wacChange);
                }
                if(mapOfWACChangesToUpdate != null){
                    update mapOfWACChangesToUpdate.values();
                }
                update lineItemsList;
            }
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'UpdateWACLineItemsBatch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
    public void finish(Database.BatchableContext BC) {
        
    }
}