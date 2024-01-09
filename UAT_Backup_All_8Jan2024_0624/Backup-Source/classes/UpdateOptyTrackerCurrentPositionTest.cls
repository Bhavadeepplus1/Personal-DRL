@IsTest
public class UpdateOptyTrackerCurrentPositionTest {
    @IsTest
    public static void UpdateOptyTrackerCurrentPositionBatchClsTestMethod(){
        Account A=new Account();
        a.name='test';
        insert a;
         Product2 p=new Product2();
        p.Name='abc pharma';
        p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='123566';
        p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        p.IsActive=true;
        p.Phoenix_Is_Exclude_Bid__c = false;
        insert p;
         Phoenix_Contract__c ct=new Phoenix_Contract__c();
        ct.Name='123';
        ct.Phoenix_Customer__c=a.Id;
        ct.Phoenix_Contract_Number__c = '350001213';
        insert ct;
        //GCP Opportunity Tracker data
        Phoenix_GCP_Opportunity_Tracker__c trk = new Phoenix_GCP_Opportunity_Tracker__c();
         trk.Phoenix_Customer__c=a.id;
       // trk.Vision_Contract__c=ct.id;
     //   trk.Vision_Product__c=p.id;
        trk.Phoenix_Product_Family__c='Test1';
        trk.GCP_Product_Family__c='Test';
        insert trk;
        //Vision_Customer_Product_Tracker__c
        Vision_Customer_Product_Tracker__c ptrk = new Vision_Customer_Product_Tracker__c();
        
        ptrk.Vision_Product_Family__c='Test';
        insert ptrk;
        Test.startTest();
        
        UpdateOptyTrackerCurrentPositionBatchCls obj = new UpdateOptyTrackerCurrentPositionBatchCls();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }

}