public class UpdateOptyTrackerCurrentPositionBatchCls implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public void execute(SchedulableContext sc) {
        //Database.executeBatch(new UpdateOptyTrackerCurrentPositionBatchCls () );
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        
        String query = 'Select  ' +Phoenix_Util.getsObjectFieds('Phoenix_GCP_Opportunity_Tracker__c')+' from Phoenix_GCP_Opportunity_Tracker__c';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List <Phoenix_GCP_Opportunity_Tracker__c> OptyTrackerRecords) {
        try{
            if(OptyTrackerRecords.size() > 0){
                List<Phoenix_GCP_Opportunity_Tracker__c> OppTracker = new List<Phoenix_GCP_Opportunity_Tracker__c>();
                Map<String,Phoenix_GCP_Opportunity_Tracker__c> OptyTracker = new Map<String,Phoenix_GCP_Opportunity_Tracker__c>();
                for(Phoenix_GCP_Opportunity_Tracker__c PGOT:OptyTrackerRecords){
                    OptyTracker.put(PGOT.GCP_Product_Family__c,PGOT);  
                }
                
                for(Vision_Customer_Product_Tracker__c VCPT:[select Vision_Product_Family__c from Vision_Customer_Product_Tracker__c where Vision_Product_Family__c in : OptyTracker.keyset()]){
                    OptyTracker.get(VCPT.Vision_Product_Family__c).current_position__c=VCPT.Vision_Current_Product_Position__c;
                    OppTracker.add(OptyTracker.get(VCPT.Vision_Product_Family__c));
                }
                
               
                if(OppTracker.size()>0){
                    Update OppTracker; 
                }
                
            }
            
        }

        
        
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'UpdateOptyTrackerCurrentPositionBatchCls', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
        public void finish(Database.BatchableContext bc){
                    /*  Integer Records=[select count() from Phoenix_GCP_Opportunity_Tracker__c];
                string RecordsCount= String.valueOf(Records);
                
                Phoenix_Util.sendBatchJobCompletionEmail('GCP Opportunity Tracker current position ', 'RecordsCount');*/
            
        
    }
}