public class deleteAchievementSummaryBatchClass implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts{
	public void execute(SchedulableContext sc) {
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select '+Phoenix_Util.getsObjectFieds('Achievement_Summary_Table__c')+' from Achievement_Summary_Table__c ';
        return Database.getQueryLocator(query);
     }
    public void execute(Database.BatchableContext BC, List < Achievement_Summary_Table__c > salesData) {
        delete salesData;
            //[Select Id FROM Achievement_Summary_Table__c];
    }
    public void finish(Database.BatchableContext BC) {
        Database.executeBatch(new AchievementSummaryBatchCls());
    }
}