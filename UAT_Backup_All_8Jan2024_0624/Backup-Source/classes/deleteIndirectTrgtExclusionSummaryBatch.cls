public class deleteIndirectTrgtExclusionSummaryBatch implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts{
	public void execute(SchedulableContext sc) {
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select '+Phoenix_Util.getsObjectFieds('Indirect_TargetExclusion_Summary__c')+' from Indirect_TargetExclusion_Summary__c ';
        return Database.getQueryLocator(query);
     }
    public void execute(Database.BatchableContext BC, List < Indirect_TargetExclusion_Summary__c > salesData) {
        delete salesData;
            //[Select Id FROM Achievement_Summary_Table__c];
    }
    public void finish(Database.BatchableContext BC) {
        Database.executeBatch(new SRxIndirectTgExclusionSummaryBatchCls());
    }
}