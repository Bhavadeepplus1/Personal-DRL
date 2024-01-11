@istest
public class CusCntrPrdcreatorActcontractsBatchtest {
    static testmethod void testsetup(){
         // Account data
        List<Account> Acclist = new  List<Account>();
        Account acc =new Account();
        acc.name='test';
        Acclist.add(acc);
        insert Acclist;
        // Phoenix Data
        List<Phoenix_Contract__c> Ctlist  = new List<Phoenix_Contract__c>();
        Phoenix_Contract__c ct = new Phoenix_Contract__c ();
        ct.Phoenix_Contract_Number__c='122456';
        ct.Phoenix_Contract_Start_Date__c=Date.newInstance(2022, 02, 21);
        ct.Phoenix_Contract_End_Date__c=system.today();
      
        ctlist.add(ct);
          Phoenix_Contract__c ct1 = new Phoenix_Contract__c ();
        ct1.Phoenix_Contract_Number__c=null;
        ct1.Phoenix_Contract_Start_Date__c=Date.newInstance(2022, 02, 21);
        ct1.Phoenix_Contract_End_Date__c=system.today();
      
        ctlist.add(ct1);
        Phoenix_Contract__c ct2 = new Phoenix_Contract__c ();
        ct2.Phoenix_Contract_Number__c='100002333';
        ct2.Phoenix_Contract_Start_Date__c=Date.newInstance(2022, 02, 21);
        ct2.Phoenix_Contract_End_Date__c=system.today();
      
        ctlist.add(ct2);
        insert ctlist;
        user u=[select id,name from user where id =: userinfo.getUserId()];
        
        // Product Data
        list<Product2> plist = new list  < Product2>();
        
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='123456';
        p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        p.Vision_Is_CPT_Batch_Executed__c = false;
        p.Phoenix_Is_Exclude_Bid__c = false;
        p.IsActive=true;
        p.Phoenix_Rx_SRx_OTC__c = 'Rx';
        p.Description='my testing';
        p.Phoenix_Product_Director__c=u.id;
        plist.add(p);
        insert plist;

        
        // NprData Data
        List<Phoenix_NPR_Data__c> nprdtlist = new  List<Phoenix_NPR_Data__c>();
        Phoenix_NPR_Data__c  npdata = new Phoenix_NPR_Data__c();
        npdata.Phoenix_12Months_Actual_Sales_Unit__c=20.00;
        npdata.Phoenix_12Months_Net_Sales__c=250.00;
        npdata.Phoenix_12Months_Sales_Unit__c=25.00;
        npdata.Phoenix_12Mt_Sales_Ut_Actual__c=22.0;
        npdata.Phoenix_Account__c=acc.Id;
        npdata.Phoenix_Contract__c=ct.Id;
        nprdtlist.add(npdata);
        insert nprdtlist;
        
  
        List<Vision_Customer_Product_Tracker__c> cpotlist= new List<Vision_Customer_Product_Tracker__c>();
        List<Phoenix_GCP_Opportunity_Tracker__c> optlist= new List<Phoenix_GCP_Opportunity_Tracker__c>();
        for ( Product2 pp:plist){
            Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
            cpt.Vision_Account__c=Acc.Id;
            cpt.Vision_Contract__c=ct.Id;
            
            cpt.Vision_NPR_Data__c=npdata.Id;
            cpt.Vision_Product__c=pp.Id;
            cpt.Vision_Product_Code__c='123456';
            cpt.Vision_Contract_Number__c='122456';
            Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
            cpt1.Vision_Account__c=Acc.Id;
            cpt.Vision_Contract__c=ct1.Id;
            
            cpt1.Vision_NPR_Data__c=npdata.Id;
            cpt1.Vision_Product__c=pp.Id;
            cpt1.Vision_Product_Code__c='126656';
            cpt.Vision_Contract_Number__c='133356';
            cpotlist.add(cpt1);
            Phoenix_GCP_Opportunity_Tracker__c opt = new Phoenix_GCP_Opportunity_Tracker__c();
            opt.cogs_per_unit__c=230;
            opt.GCP_Product_Family__c='rt12';
            opt.Phoenix_Customer__c=acc.Id;
            opt.Phoenix_Customer_Opp_Sales__c=25;
            opt.Phoenix_Customer_Opp_TPT__c=25;
            opt.Phoenix_Customer_Opp_TPT_Perc__c=50;
            opt.GCP_Product_Family__c='Uynn';
            optlist.add(opt);
            
        }
        insert cpotlist;
        insert optlist;
        test.startTest();
        //CustomerProductActiveContractsBatchCls Cuscnrcbatch = new CustomerProductActiveContractsBatchCls();
       // database.executeBatch(Cuscnrcbatch);
       CustomerProductActiveContractsBatchCls bl= new CustomerProductActiveContractsBatchCls();
        database.executeBatch(bl);
        bl.execute(null);
        test.stopTest();
        
    }
    
}