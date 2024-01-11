@istest
public class NPRBasedContractProductUpdateBatchtest {
    static testmethod void testsetup(){
        // Account Data
        List<Account> Acclist = new  List<Account>();
        Account acc =new Account();
        acc.name='test';
        Acclist.add(acc);
        insert Acclist;
        // Contract Data
        List<Phoenix_Contract__c> Ctlist  = new List<Phoenix_Contract__c>();
        Phoenix_Contract__c ct = new Phoenix_Contract__c ();
        ct.Phoenix_Contract_Number__c='12345678';
        ct.Phoenix_Contract_Start_Date__c=Date.newInstance(2022, 02, 23);
        ct.Phoenix_Contract_End_Date__c=system.today()+365;
        Ctlist.add(ct);
        insert Ctlist;
        // Product Data
        list<Product2> plist = new list  < Product2>();
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
        plist.add(p);
        insert plist;
        // NPR Data
        List<Phoenix_NPR_Data__c> nprdtlist = new  List<Phoenix_NPR_Data__c>();
        Phoenix_NPR_Data__c  npdata = new Phoenix_NPR_Data__c();
        npdata.Phoenix_Account__c=acc.Id;
        npdata.Phoenix_Contract__c=ctlist[0].id;
        npdata.Phoenix_Product__c=plist[0].id;
        npdata.Phoenix_12Months_Actual_Sales_Unit__c=20.00;
        npdata.Phoenix_12Months_Net_Sales__c=250.00;
        npdata.Phoenix_12Months_Sales_Unit__c=25.00;
        npdata.Phoenix_12Mt_Sales_Ut_Actual__c=22.0;
        npdata.Phoenix_NPR_Status__c='Active';
        nprdtlist.add(npdata);
        insert nprdtlist;
        
        List<Vision_Customer_Product_Log__c> ploglist = new List<Vision_Customer_Product_Log__c>();
        List<Vision_Customer_Product_Tracker__c> cpotlist= new List<Vision_Customer_Product_Tracker__c>();
        // Customer Product Log Data
        Vision_Customer_Product_Log__c plog = new Vision_Customer_Product_Log__c();
        plog.Phoenix_Contract__c=ct.Id;
        plog.Phoenix_Customer__c=acc.Id;
        plog.Phoenix_NPR_Data__c=npdata.Id;
        plog.Phoenix_Product__c=p.Id;
        plog.Phoenix_Previous_Deadnet_Price__c=25;
        plog.Phoenix_Previous_Volume__c=250.0;
        plog.Phoenix_Price_Effective_Value_From__c=Date.newInstance(2022, 02, 21);
        plog.Phoenix_Price_Effective_Value_To__c=Date.newInstance(2022, 02, 24);
        ploglist.add(plog);
        // Customer Product Tracker Data
        Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
        cpt.Vision_Account__c=acc.Id;
        cpt.Vision_Contract__c=ct.Id;
        cpt.Vision_NPR_Data__c=npdata.Id;
        cpt.Vision_Product__c=p.Id;
        cpt.Vision_Product_Code__c= '123566';
        cpt.Vision_Contract_Number__c='12345678';
        cpotlist.add(cpt);
        
        insert ploglist;
        insert cpotlist;
        
        test.startTest();
        NPRBasedContractProductUpdateBatchCls nprupdate = new NPRBasedContractProductUpdateBatchCls();
        database.executeBatch(nprupdate);
        test.stopTest();
    }    
    
}