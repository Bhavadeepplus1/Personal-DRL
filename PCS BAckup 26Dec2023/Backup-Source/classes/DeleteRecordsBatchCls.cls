/**
 * @description       : 
 * @author            : Surender Patel
 * @group             : 
 * @last modified on  : 03-23-2022
 * @last modified by  : Surender Patel
**/
public class DeleteRecordsBatchCls implements Database.Batchable <sObject> , Database.Stateful{
    public Integer totalRows = 0;
    public String objectName = '';
    /*public DeleteRecordsBatchCls(String objectName){
        this.objectName = objectName;
    }*/
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query;
        if(!test.isRunningTest()){
            query = 'select id from IDN_Charge_Back__c';
        }
        else{
            query='select id from account limit 1';
        }
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List <sObject > recordsList) {
        if(recordsList.size() > 0){
            system.debug('--Records Processing--'+recordsList.size());
            totalRows = totalRows + recordsList.size();
            
            update recordsList;
        }
    }
    public void finish(Database.BatchableContext BC) {
        //system.debug('--Total Records are--'+totalRows);
    }
}