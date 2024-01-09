@isTest(SeeAlldata = true)
public class InsertScheduleJobTest
{

    static testmethod void schedulerTest() 
    {
        String CRON_EXP = '0 05 * * * ?';
        Test.startTest();
        String jobId = System.schedule('ScheduleBatchApexClass',CRON_EXP, new ScheduleJobInsert());     
        
        Test.stopTest();
       
    }
    static testmethod void test1() {
        try{
        Test.startTest();
        Phoenix_AllJobsMonitor monitor = new Phoenix_AllJobsMonitor();
        monitor.execute(null);
        Test.stopTest();
        }catch(Exception ex){}
    }
    
    static testmethod void test2() {
        
        Test.startTest();
        Phoenix_AllJobsMonitor monitor = new Phoenix_AllJobsMonitor();
        monitor.execute(null);
        Test.stopTest();
       
    }
    
   static testmethod void testIncrement() {
         Phoenix_AllJobsMonitor.justIncrement();
       Database.executeBatch(new InsertScheduleJob());
       
    }
    static testmethod void insertSchedulejob() {
        
       
        Phoenix_Contract__c cont = new Phoenix_Contract__c(name = 'Test contract');
        insert cont;
        Phoenix_NPR_Data__c nprData = new Phoenix_NPR_Data__c();
        nprData.Phoenix_Contract__c = cont.Id;

        insert nprData;

        Phoenix_NPR_Snapshot_Creator_Batch snapShotBatch = new Phoenix_NPR_Snapshot_Creator_Batch();
        
        
        
        Account acc = new Account();
        acc.Name = 'Test';
        acc.AccountNumber = '1234';
        insert acc;
        Product2 pro = new Product2();
        pro.Name = 'Test';
        pro.Family = 'Test';
        pro.Phoenix_Throughput_cost__c = 2;
        pro.ProductCode = '30000001';
        insert pro;


        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c = acc.Id;
        npr.Phoenix_Contract__c = cont.Id;
        npr.Phoenix_Product__c = pro.Id;
        npr.Phoenix_Add_ABS_Value__c = 2.00;
        npr.Phoenix_NPR_Status__c = 'Active';
        npr.Phoenix_Dead_Net_Tracking_GR__c = 2;
        insert npr;

        Phoenix_NPR_Volume__c nprVol = new Phoenix_NPR_Volume__c();
        nprVol.Phoenix_NPR_Data__c = npr.Id;
        nprVol.Phoenix_Volume__c = 10;
        nprVol.Phoenix_Date__c = System.today().addMonths(-1).toStartOfMonth();
        nprVol.Name = 'test';
        insert nprVol;

        Phoenix_NPR12MonthsSalesUnitRollup processProd = new Phoenix_NPR12MonthsSalesUnitRollup();
        Test.startTest();
        DataBase.executeBatch(processProd);
        snapShotBatch.execute(null);
        Database.executeBatch(new InsertScheduleJob());
        Test.stopTest();
    }
}