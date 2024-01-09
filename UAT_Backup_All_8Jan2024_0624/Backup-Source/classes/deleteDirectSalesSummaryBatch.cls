public class deleteDirectSalesSummaryBatch implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts{
	public void execute(SchedulableContext sc) {
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select '+Phoenix_Util.getsObjectFieds('SRx_DirectSales_SummaryTable__c')+' from SRx_DirectSales_SummaryTable__c ';
        return Database.getQueryLocator(query);
     }
    public void execute(Database.BatchableContext BC, List < SRx_DirectSales_SummaryTable__c > salesData) {
        delete salesData;
            //[Select Id FROM Achievement_Summary_Table__c];
    }
    public void finish(Database.BatchableContext BC) {
        Database.executeBatch(new SRxDirectSalesSummaryBatchCls());
    }
}