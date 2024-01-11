/**
* @description       : 
* @author            : Surender Patel (Dhruvsoft)
* @group             : 
* @last modified on  : 14-07-2021
* @last modified by  : Surender Patel (Dhruvsoft)
* Modifications Log 
* Ver   Date         Author                       Modification
* 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
public class Phoenix_FutureNPRDataActiveChecker implements Database.Batchable < sObject > , Database.Stateful, Schedulable {
    public Map < String, Product2 > newlyCreatedProdsMap = new Map < String, Product2 > ();
    
    public Phoenix_FutureNPRDataActiveChecker() {}
    
    //schedule controller
    public void execute(SchedulableContext sc) {
        database.executeBatch(new Phoenix_FutureNPRDataActiveChecker(), 200);
    }
    
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        // DateTime today10AM = DateTime.newInstanceGMT(System.today(), Time.newInstance(5, 0, 0, 0));
        DateTime today10AM = DateTime.newInstanceGMT(Date.newInstance(System.now().year(), System.now().monthGmt(), System.now().dayGmt()), Time.newInstance(5, 0, 0, 0));
        
        String query = 'SELECT Id,LastModifiedDate FROM Phoenix_Future_NPR_Data__c ';
        
        if (Test.isRunningTest()) {
            query += ' Limit 1';
        } else {
              query += ' WHERE LastModifiedDate < TODAY'; //' WHERE LastModifiedDate < :today10AM';
        }
        return Database.getQueryLocator(query);
    }
    
    
    public void execute(Database.BatchableContext BC, List < Phoenix_Future_NPR_Data__c > nprList) {
        List < Phoenix_Future_NPR_Data__c > updatedNPRs = new List < Phoenix_Future_NPR_Data__c > ();
        
        for (Phoenix_Future_NPR_Data__c npr: nprList) {
            npr.Phoenix_NPR_Status__c = 'In Active';
            updatedNPRs.add(npr);
        }
        
        update updatedNPRs;
        
    }
    
    public void finish(Database.BatchableContext BC) {
        // Phoenix_SubmitBidForApprovalCtrl.reportDuplicateNprStagingRecords();
        
    }
}