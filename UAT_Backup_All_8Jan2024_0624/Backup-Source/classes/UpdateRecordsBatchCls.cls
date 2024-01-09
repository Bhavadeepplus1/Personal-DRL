public class UpdateRecordsBatchCls implements Database.Batchable <sObject> , Database.Stateful{
    public Integer totalRows = 0;
    public String objectName = '';
    public string fieldApi = '';
    public string itemValue = '';
    public string itemDataType = '';
    public UpdateRecordsBatchCls(String objectName, String fieldApi, String itemValue, String itemDataType){
        this.objectName = objectName;
        this.fieldApi = fieldApi;
        this.itemValue = itemValue;
        this.itemDataType = itemDataType;
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'select '+Phoenix_Util.getsObjectFieds(''+objectName)+' from '+objectName;
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List <sObject > recordsList) {
        if(recordsList.size() > 0){
            try{
                totalRows = totalRows + recordsList.size();
                for(Integer i=0;i<recordsList.size();i++){
                    if(itemDataType == 'boolean')
                        recordsList[i].put(fieldApi, boolean.valueOf(itemValue));
                    else if(itemDataType == 'date')
                        recordsList[i].put(fieldApi, date.valueOf(itemValue));
                    else if(itemDataType == 'Integer')
                        recordsList[i].put(fieldApi, Integer.valueOf(itemValue));
                    else if(itemDataType == 'decimal')
                        recordsList[i].put(fieldApi, decimal.valueOf(itemValue));
                    else if(itemDataType == 'datetime')
                        recordsList[i].put(fieldApi, datetime.valueOf(itemValue));
                    else 
                        recordsList[i].put(fieldApi, itemValue);
                }
                update recordsList;
            }
            Catch(Exception e) {            
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'UpdateRecordsBatchCls', Phoenix_Error_Message__c = e.getMessage()+' '+e.getLineNumber(),Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(),Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');            
                insert exp;
            }
        }
    }
    public void finish(Database.BatchableContext BC) {
        
    }
}