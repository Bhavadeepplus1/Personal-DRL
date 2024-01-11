public class Scheduled_Job_Calendar_Class {   
@auraEnabled
    public static List<Job_Calendar__c> getApeSyncObjAll(){
       List<Job_Calendar__c> asyncApeList = [SELECT ApexClass_Name__c,CompletedDate__c,CreatedById,CreatedDate,CreatedDate__c,Id,IsDeleted,JobItemsProcessed__c,JobType__c,Job_Name__c,Job_Run_By__c,Job_Run_By__r.Name,Job_Description__c,LastActivityDate,LastModifiedById,LastModifiedDate,Name,OwnerId,Status__c,SystemModstamp,TotalJobItems__c,Job_Start_Date__c,Job_Completed_Date__c,Job_Source__c,Job_Destination__c,TotalJobBatches__c,Job_Used_For__c,Job_Duration__c FROM Job_Calendar__c WHERE JobType__c = 'BatchApex' AND ApexClass_Name__c != '' ORDER BY CreatedDate__c ASC];
        return asyncApeList;
    }
 @auraEnabled
    public static List<Job_Calendar__c> getApeSyncObjCompleted(){
        List<Job_Calendar__c> asyncApeList = [SELECT ApexClass_Name__c,CompletedDate__c,CreatedById,CreatedDate,CreatedDate__c,Id,IsDeleted,JobItemsProcessed__c,JobType__c,Job_Name__c,Job_Run_By__c,Job_Run_By__r.Name,Job_Description__c,LastActivityDate,LastModifiedById,LastModifiedDate,Name,OwnerId,Status__c,SystemModstamp,TotalJobItems__c,Job_Start_Date__c,Job_Completed_Date__c,Job_Source__c,Job_Destination__c,TotalJobBatches__c,Job_Used_For__c,Job_Duration__c FROM Job_Calendar__c WHERE JobType__c = 'BatchApex' AND ApexClass_Name__c != '' AND Status__c='Completed' ORDER BY CreatedDate__c ASC];
        return asyncApeList;
    }
@auraEnabled
    public static List<Job_Calendar__c> getApeSyncObjFailed(){
        List<Job_Calendar__c> asyncApeList = [SELECT ApexClass_Name__c,CompletedDate__c,CreatedById,CreatedDate,CreatedDate__c,Id,IsDeleted,JobItemsProcessed__c,JobType__c,Job_Name__c,Job_Run_By__c,Job_Run_By__r.Name,Job_Description__c,LastActivityDate,LastModifiedById,LastModifiedDate,Name,OwnerId,Status__c,SystemModstamp,TotalJobItems__c,Job_Start_Date__c,Job_Completed_Date__c,Job_Source__c,Job_Destination__c,TotalJobBatches__c,Job_Used_For__c,Job_Duration__c FROM Job_Calendar__c WHERE JobType__c = 'BatchApex' AND ApexClass_Name__c != '' AND Status__c='Failed' ORDER BY CreatedDate__c ASC];
        return asyncApeList;
    }
@auraEnabled
    public static List<Job_Calendar__c> getApeSyncObjPending(){
        List<Job_Calendar__c> asyncApeList = [SELECT ApexClass_Name__c,CompletedDate__c,CreatedById,CreatedDate,CreatedDate__c,Id,IsDeleted,JobItemsProcessed__c,JobType__c,Job_Name__c,Job_Run_By__c,Job_Run_By__r.Name,Job_Description__c,LastActivityDate,LastModifiedById,LastModifiedDate,Name,OwnerId,Status__c,SystemModstamp,TotalJobItems__c,Job_Start_Date__c,Job_Completed_Date__c,Job_Source__c,Job_Destination__c,TotalJobBatches__c,Job_Used_For__c,Job_Duration__c FROM Job_Calendar__c WHERE JobType__c = 'BatchApex' AND ApexClass_Name__c != ''AND Status__c='Processing' ORDER BY CreatedDate__c ASC];
        return asyncApeList;
    }
@auraEnabled
    public static List<Job_Calendar__c> getApeSyncObjAborted(){
        List<Job_Calendar__c> asyncApeList = [SELECT ApexClass_Name__c,CompletedDate__c,CreatedById,CreatedDate,CreatedDate__c,Id,IsDeleted,JobItemsProcessed__c,JobType__c,Job_Name__c,Job_Run_By__c,Job_Run_By__r.Name,Job_Description__c,LastActivityDate,LastModifiedById,LastModifiedDate,Name,OwnerId,Status__c,SystemModstamp,TotalJobItems__c,Job_Start_Date__c,Job_Completed_Date__c,Job_Source__c,Job_Destination__c,TotalJobBatches__c,Job_Used_For__c,Job_Duration__c FROM Job_Calendar__c WHERE JobType__c = 'BatchApex' AND ApexClass_Name__c != ''AND Status__c='Aborted' ORDER BY CreatedDate__c ASC];
        return asyncApeList;
    }
}