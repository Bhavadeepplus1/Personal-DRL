/**
 * @Apex Class      : ScheduleJobCalendarClass
 * @description       : To fetch the all job calendar class
 * @author            : Ramakrishna Y
 * @group             : 
 * @last modified on  : 13-13-2022
 * @last modified by  : Ramakrishna Y
 * Modifications Loag 
**/
@isTest(SeeAllData=true)
private class Scheduled_Job_Calendar_ClassTest
{
   public static testMethod void ScheduledJobClassMethod() 
    {  
        // Create your test data
        Job_Calendar__c rt=new Job_Calendar__c();
        rt.ApexClass_Name__c='Test Apex';
        
        
    
        Test.StartTest();
        Scheduled_Job_Calendar_Class.getApeSyncObjAll();
        Scheduled_Job_Calendar_Class.getApeSyncObjCompleted();
        Scheduled_Job_Calendar_Class.getApeSyncObjFailed();
        Scheduled_Job_Calendar_Class.getApeSyncObjPending();
        Scheduled_Job_Calendar_Class.getApeSyncObjAborted();
        //testsche.getApeSyncObjAll();
        Test.stopTest();
         
         
    }
}