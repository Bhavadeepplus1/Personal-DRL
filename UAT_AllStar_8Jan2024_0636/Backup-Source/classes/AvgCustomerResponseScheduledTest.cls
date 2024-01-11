/**
* @description       : This test class contains Avg Customer Response Date & Internal Approval values map into another Object (Response Time).create the record every day at 12AM
* @Class Name        : AvgCustomerResponseScheduled
* @author            : Ramakrishna Y
* @Created on        : 26-10-2021
* @last modified on  : 27-10-2021
* @last modified by  : Ramakrishna Y
**/
@isTest(SeeAllData=true)
private class AvgCustomerResponseScheduledTest
{
   public static testMethod void testRunAs() 
    {  
        // Create your test data
        Response_Time__c rt=new Response_Time__c();
        rt.Response_Date__c=System.today();
        rt.Avg_Customer_Response__c = 9.25;
        rt.Benchmark_1__c=10;
        rt.Avg_Internal_Approval__c = 10.12;
        rt.Benchmark_2__c=5;
        insert rt;
        
    
        Test.StartTest();
        AvgCustomerResponseScheduled testsche = new AvgCustomerResponseScheduled();
        String sch = '0 0 23 * * ?';
      //  system.schedule('Test status Check', sch, testsche );
	testsche.execute(null);
        Test.stopTest();
         
         
    }
}