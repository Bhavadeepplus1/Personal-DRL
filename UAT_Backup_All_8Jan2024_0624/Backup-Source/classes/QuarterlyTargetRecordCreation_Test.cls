@isTest
public class QuarterlyTargetRecordCreation_Test 
{
  @isTest
    public static void testData(){
        Target_Achieved_Approval__c trgt = new Target_Achieved_Approval__c();
        trgt.Financial_Year__c = '2024';
        trgt.Quarter__c = 'Q2';
        trgt.Name = 'Test Target';
        trgt.Initiator_Status__c = 'Completed';
        trgt.Marketing_Head_Status__c = 'Not Initiated';
        trgt.SRx_Head_Status__c = 'Not Initiated';
        trgt.Approval_Status__c= 'RSM Head';
        trgt.RSM_Head_Status__c = 'In Process';
        trgt.RSM_West_Head_Status__c = 'In Process';
        trgt.Intial_Approver__c = 'Automatic BRIGHT';
       
        insert trgt;
        
        String cronExpression = '0 42 17 * * ? 2023';
        String jobId = System.schedule('QuarterlyTargetRecordCreation_Test', cronExpression, new QuarterlyTargetRecordCreation());
        
        CronTrigger cronTrigger = [SELECT Id, CronExpression, CronJobDetail.Name FROM CronTrigger WHERE Id = :jobId LIMIT 1];
        System.assertEquals(cronExpression, cronTrigger.CronExpression);
        //System.assertEquals('QuarterlyTargetRecordCreation', cronTrigger.CronJobDetail.Name);
    }
}