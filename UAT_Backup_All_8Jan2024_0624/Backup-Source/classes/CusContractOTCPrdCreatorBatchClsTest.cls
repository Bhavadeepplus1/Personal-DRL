@istest
public class CusContractOTCPrdCreatorBatchClsTest {
    static testmethod void setup(){
         Account acc =new Account();
        acc.name='test';
        acc.Phoenix_Contract_Number__c='945673';
        acc.AccountNumber='1234';
        
        insert acc;

        user u=[select id from user where id =: userinfo.getUserId()];
       list<Product2> plist = new list<Product2>();
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.OTC_Customer__c=acc.id;
        p.IsActive=true;
        p.Phoenix_Is_Exclude_Bid__c=false;
        p.Vision_Is_CPT_Batch_Executed__c=false;
        p.Phoenix_Is_Private_Label_OTC__c=true;
       // p.Phoenix_NDC_11__c='23364348';
       // p.ProductCode='123567';
        // p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='123566';
        p.Phoenix_Product_Director__c=u.id;
     //  p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        plist.add(p);
        account a= new account ();
        a.name='test1';
        a.Phoenix_Contract_Number__c='334533';
        insert a;
         user u1=[select id from user where id =: userinfo.getUserId()];
        Product2 p1=new Product2();
        p1.Name='abc pharma1';
       p1.OTC_Customer__c=a.id;
        p1.IsActive=true;
        p1.Phoenix_Is_Exclude_Bid__c=false;
        p1.Vision_Is_CPT_Batch_Executed__c=false;
        p1.Phoenix_Is_Private_Label_OTC__c=true;
      // p1.Phoenix_NDC_11__c='2362848';
        p1.ProductCode='125662';
        
        
        p1.Phoenix_Product_Director__c=u1.id;
      //  p1.Phoenix_NDC__c='5455355';
        p1.Phoenix_GPI_Generic_Product_Identifier__c = '12111';
        p1.Family = 'Test Family1';
        //p1.Phoenix_Throughput_cost__c=11.23456576;
        //p1.Phoenix_GCN_Sequence_Number__c='6666661';
        //p1.Phoenix_Pkg_Size__c=24.0;
        plist.add(p1);
        insert plist;
          Contact con=new Contact();
        con.LastName='Test';
        con.AccountId=acc.Id;
          insert con;
        Phoenix_Bid__c bidtest = new  Phoenix_Bid__c();
        bidtest.Phoenix_Approval_Status__c='New';
        bidtest.Phoenix_Contact__c= con.Id;
        bidtest.Phoenix_Customer_Type__c='New';
        bidtest.Phoenix_Bid_Type__c='New Customer';
        
        insert bidtest;
          Phoenix_Bid_Line_Item__c bdl= new Phoenix_Bid_Line_Item__c();
         bdl.Phoenix_Bid_Status__c='Awarded';
        bdl.Phoenix_DeadNet_TrckGR__c=1;
        bdl.Phoenix_Bid__c=bidtest.Id;
        bdl.Phoenix_Final_Status__c ='Approved';
        bdl.Phoenix_Bid_Line_Item_Approval_Status__c='Closed-Contracts';
        bdl.Phoenix_Bid_Line_Type__c='Product Addition';
        insert bdl;
         Phoenix_Contract__c ctr = new Phoenix_Contract__c();
        ctr.Name = 'Test Contract';
        ctr.Phoenix_Customer__c = acc.Id;
        ctr.Phoenix_Contract_Number__c='1234';
        ctr.Phoenix_Contract_Start_Date__c=system.today();
        ctr.Phoenix_Contract_End_Date__c=date.newInstance(2023, 12, 23);
        
        
        //ctr.Phoenix_Contract_Status__c='Active';
        insert ctr;
         Vision_Customer_Product_Tracker__c ct= new Vision_Customer_Product_Tracker__c();
        ct.Bid_Line_Item__c=bdl.id;
        ct.Vision_Contract__c=ctr.id;
        ct.Vision_Account__c=acc.id;
        ct.Vision_Product__c=p.id;
        ct.Vision_Bid__c=bidtest.id;
        ct.Vision_Customer_Code__c='12345676';
        ct.Vision_Customer_Name__c='test';
        ct.Vision_Product_Code__c='125662';
        
        ct.Vision_Contract_Number__c='1234';
        insert ct;
         Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
          //  cpt1.Vision_Account__c=acc.Id;
            cpt1.Vision_Contract__c=ctr.Id;
            cpt1.Vision_Contract_Product_Status__c='In Opportunity';
          //  cpt1.Vision_Product__c=p1.Id;
            cpt1.Vision_Product_Code__c='1235786';
            cpt1.Vision_Contract_Number__c='30000';
            cpt1.Vision_Customer_Code__c='12345';
           
        //    cpt1.Bid_Line_Item__c=bdl.id;
            
            
            insert cpt1;
         Vision_Customer_Product_Tracker__c cusPrdTrk = new Vision_Customer_Product_Tracker__c();
        insert cusPrdTrk;
       
       
       // list<Vision_Customer_Product_Tracker__c> ct= new list<Vision_Customer_Product_Tracker__c>();
       
        test.startTest();
        CustomerContractOTCPrdCreatorBatchCls b= new CustomerContractOTCPrdCreatorBatchCls();
        database.executeBatch(b);
        test.stopTest();
        
    }
}