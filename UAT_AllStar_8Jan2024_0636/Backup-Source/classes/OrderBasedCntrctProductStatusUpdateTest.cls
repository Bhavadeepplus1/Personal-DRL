@istest
public class OrderBasedCntrctProductStatusUpdateTest {
    static testmethod void setup(){
         Account acc =new Account();
        acc.name='test';
        insert acc;
         Product2 p=new Product2();
        p.Name='abc pharma';
        p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='1235678';
        p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        insert p;
         Phoenix_Contract__c ctr = new Phoenix_Contract__c();
        ctr.Name = 'Test Contract';
        ctr.Phoenix_Contract_Number__c = '46579';
        ctr.Phoenix_Customer__c = acc.Id;
        ctr.Phoenix_Contract_Start_Date__c=date.newInstance(2022,02,25);
        ctr.Phoenix_Contract_End_Date__c=date.newInstance(2022,03,25);
       // ctr.Phoenix_Contract_Status__c='Active';
        insert ctr;
         List<Phoenix_NPR_Data__c> nprdtlist = new  List<Phoenix_NPR_Data__c>();
        Phoenix_NPR_Data__c  npdata = new Phoenix_NPR_Data__c();
        npdata.Phoenix_Account__c=acc.Id;
        npdata.Phoenix_Contract__c=ctr.id;
        npdata.Phoenix_Product__c=p.id;
        npdata.Phoenix_12Months_Actual_Sales_Unit__c=20.00;
        npdata.Phoenix_12Months_Net_Sales__c=250.00;
        npdata.Phoenix_12Months_Sales_Unit__c=25.00;
        npdata.Phoenix_12Mt_Sales_Ut_Actual__c=22.0;
        npdata.Phoenix_Price_Effective_Value_From__c=date.newInstance(2022,02,23);
        npdata.Phoenix_Price_Effective_Value_To__c=system.today();
        npdata.Phoenix_Dead_Net_Tracking_GR__c=2500;
        npdata.Phoenix_Contract_Type__c='Direct';
        nprdtlist.add(npdata);
        insert nprdtlist;
          Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
            cpt1.Vision_Account__c=acc.Id;
            cpt1.Vision_Contract__c=ctr.Id;
            cpt1.Vision_Contract_Product_Status__c='Awarded';
            cpt1.Vision_Product__c=p.Id;
           cpt1.Vision_NPR_Data__c=npdata.id;
            cpt1.Vision_Product_Code__c='1235678';
            cpt1.Vision_Contract_Number__c='46579';
            cpt1.Vision_Current_Product_Position__c='New';
            cpt1.Vision_Internal_DeadNet__c=2500;
            cpt1.Is_Initial_Order__c=true;
            
            insert cpt1;
         Vision_GCP_SFDC_Order_Status__c ordStatus = new Vision_GCP_SFDC_Order_Status__c();
             ordstatus.Vision_Account__c=acc.id;
             ordStatus.Vision_Customer_Code__c= '12345';
             ordStatus.Vision_SKU_Code__c='1235678';
             ordStatus.Vision_Product__c = p.Id;
             ordstatus.Vision_Order_Date__c=system.today();
             insert ordstatus;
        test.startTest();
        OrderBasedCntrctProductStatusUpdate b= new OrderBasedCntrctProductStatusUpdate();
        database.executeBatch(b);
        test.stopTest();
         
    }

}