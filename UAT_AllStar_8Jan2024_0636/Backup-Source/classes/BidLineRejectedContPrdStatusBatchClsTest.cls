@istest
public class BidLineRejectedContPrdStatusBatchClsTest {
    static testmethod void setup(){
               //Account Data
        Account A=new Account();
        a.name='test';
        a.Phoenix_Account_Cooling_Period__c=20;
        insert a;
        
        Account b=new Account();
        b.name='test';
        b.Phoenix_Customer_Cooling_Period_Days__c=20;
        insert b;
        
        //Contact Data
        Contact c=new Contact();
        c.lastname='test1';
        c.AccountId=a.Id;
        
        insert c;
      
        

        //Product Data
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
        p.Phoenix_Is_Exclude_Bid__c = false;
        plist.add(p);
        
         Product2 p1=new Product2();
        p1.Name='abc pharma';
        p1.Phoenix_NDC_11__c='23364848';
        p1.ProductCode='123566';
        p1.Phoenix_NDC__c='5555555';
        p1.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p1.Family = 'Test Family';
        p1.Phoenix_Throughput_cost__c=10.23456576;
        p1.Phoenix_GCN_Sequence_Number__c='666666';
        p1.Phoenix_Pkg_Size__c=25.0;
        p1.IsActive=true;
        p1.Phoenix_Is_Exclude_Bid__c = false;
        plist.add(p1);
        insert plist;
 
     
        // Phoenix Contract Data
        Phoenix_Contract__c ctr = new Phoenix_Contract__c();
        ctr.Name = 'Test Contract';
        ctr.Phoenix_Contract_Number__c = '46579';
        ctr.Phoenix_Customer__c = a.Id;
        insert ctr;
        
       
        
        // bid data
        list<Phoenix_Bid__c> blist = new list<Phoenix_Bid__c>();
        Phoenix_Bid__c bidtest = new  Phoenix_Bid__c();
        bidtest.Phoenix_Approval_Status__c='New';
        bidtest.Phoenix_Contact__c= c.Id;
        bidtest.Phoenix_Customer_Type__c='New';
        bidtest.Phoenix_Bid_Type__c='New Customer';
        bidtest.Phoenix_Reference_Contracts__c='46579';
        bidtest.Phoenix_Customer__c=a.Id;
        blist.add(bidtest);
        insert blist;
        
        // Bid line item data
        list<Phoenix_Bid_Line_Item__c> bllist = new list<Phoenix_Bid_Line_Item__c>();
        
            Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
            bidLine.Phoenix_Product__c =p1.Id;
            bidLine.Phoenix_Contract__c = ctr.Id;
            bidline.Phoenix_Final_Status__c = 'Not Approved';
            bidline.Phoenix_Bid_Line_Item_Approval_Status__c ='SCM Rejected';            
            bidline.Phoenix_Bid__c=bidtest.Id;
            bidline.Phoenix_Customer__c=a.id;
            bllist.add(bidline);
            
            Phoenix_Bid_Line_Item__c bidLine1 = new Phoenix_Bid_Line_Item__c();
            bidLine1.Phoenix_Product__c =p1.Id;
            bidLine1.Phoenix_Contract__c = ctr.Id;
            bidline1.Phoenix_Final_Status__c = 'Not Approved';
            bidline1.Phoenix_Bid_Line_Item_Approval_Status__c ='Marketing Rejected';            
            bidline1.Phoenix_Bid__c=bidtest.Id;
            bidline1.Phoenix_Customer__c=a.id;
            bllist.add(bidline1);
        
            insert bllist;
        
            Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
            cpt.Vision_Account__c=a.Id;
            cpt.Vision_Contract__c=ctr.Id;
            cpt.Vision_Contract_Product_Status__c='Supply Constraint';
            cpt.Vision_Product__c=p.Id;
            cpt.Vision_Product_Code__c='123566';
            cpt.Vision_Contract_Number__c='46579';
            cpt.Vision_In_Cooling_Period__c=True;
            cpt.Vision_Account_Cooling_Period_Days__c=20;
            cpt.Vision_In_Bid__c=true;
            cpt.Vision_Is_Price_Constraint__c=true;
            cpt.Vision_Is_Supply_Constraint__c=true;
            cpt.Bid_Line_Created_Date__c= system.today();
            cpt.Vision_Bid_Created_Date__c=system.today();
            cpt.Vision_Bid_Name__c='My bid';
            cpt.Bid_Line_Item__c=bidline1.id;
            insert cpt;
            
        Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
            cpt1.Vision_Account__c=b.Id;
            cpt1.Vision_Contract__c=ctr.Id;
            cpt1.Vision_Contract_Product_Status__c='In Opportunity';
            cpt1.Vision_Product__c=p.Id;
            cpt1.Vision_Product_Code__c='300027884';
            cpt1.Vision_Contract_Number__c='46579';
            cpt1.Vision_In_Cooling_Period__c=True;
            cpt1.Vision_Account_Cooling_Period_Days__c=20;
            cpt1.Vision_In_Bid__c=true;
            cpt1.Vision_Is_Price_Constraint__c=true;
            cpt1.Vision_Is_Supply_Constraint__c=true;
            cpt1.Vision_Contract_Product_Status__c='my test data';
            cpt1.Bid_Line_Created_Date__c= system.today();
            cpt1.Vision_Bid_Created_Date__c=system.today();
            cpt1.Vision_Bid_Name__c='My bid';
         cpt1.Bid_Line_Item__c=bidline.id;
          
            insert cpt1;
        
       
        test.startTest();
        BidLineRejectedContractPrdStatusBatchCls blrcpsbc = new BidLineRejectedContractPrdStatusBatchCls();
        database.executeBatch(blrcpsbc);
        
        test.stopTest();
    }
}