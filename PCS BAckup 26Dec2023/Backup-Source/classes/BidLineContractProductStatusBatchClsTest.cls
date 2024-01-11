@isTest
public class BidLineContractProductStatusBatchClsTest {
    static testmethod void test() {
        // Product Data
        
        list<Product2> plist = new list<product2>(); 
        Product2 prd = new Product2();
        prd.Name = 'Test Product';
        prd.ProductCode = '300027884';
        plist.add(prd);
        insert plist;
        // Account Data
        list<Account> alist= new list<account>();
        Account acc = new Account(Name='Test Account');
        alist.add(acc);
        insert alist;
        //Phoenix Contract data
        Phoenix_Contract__c ctr = new Phoenix_Contract__c();
        ctr.Name = 'Test Contract';
        ctr.Phoenix_Contract_Number__c = '46579';
        ctr.Phoenix_Customer__c = acc.Id;
        insert ctr;
        //Contact data
        contact c= new contact();
        c.lastname='test';
        c.AccountId=acc.id;
        insert c; 
        // Opp data
        List<Opportunity> oplist=new List<Opportunity>();
        Opportunity op=new opportunity();
        op.AccountId=acc.id;
        op.Contact__c=c.id;
        op.Vision_Reference_Contract__c='46579';
        op.StageName = 'Closed Won';
        op.Name='test1';
        op.CloseDate=system.today();
        oplist.add(op);
        insert oplist;
        // Bid data
        list<Phoenix_Bid__c> blist = new list<Phoenix_Bid__c>();
        Phoenix_Bid__c bidtest = new  Phoenix_Bid__c();
        bidtest.Phoenix_Approval_Status__c='New';
        bidtest.Phoenix_Contact__c= c.Id;
        bidtest.Opportunity__c=op.Id;
        bidtest.Phoenix_Reference_Contracts__c='46579';
        
        bidtest.Phoenix_Customer_Type__c='New';
        bidtest.Phoenix_Bid_Type__c='New Customer';
        blist.add(bidtest);
        insert blist;
        // Bidline item data
        list<Phoenix_Bid_Line_Item__c> bllist = new list<Phoenix_Bid_Line_Item__c>();
        for(Phoenix_Bid__c bb :blist){
            Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
            bidLine.Phoenix_Product__c = prd.Id;
            bidLine.Phoenix_Contract__c = ctr.Id;
            
            
            bidline.Phoenix_Bid__c=bidtest.Id;
            bllist.add(bidline);
            Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
            cpt1.Vision_Account__c=acc.Id;
            cpt1.Vision_Contract__c=ctr.Id;
            cpt1.Vision_Contract_Product_Status__c='In Opportunity';
            cpt1.Vision_Product__c=prd.Id;
            cpt1.Vision_Product_Code__c='300027884';
            cpt1.Vision_Contract_Number__c='46579';
            
            
            insert cpt1;
        }
        
        insert bllist;
         
        test.startTest();
        BidLineContractProductStatusBatchCls bbclass = new BidLineContractProductStatusBatchCls();
        database.executeBatch(bbclass);
        test.stopTest();
    }
    
}