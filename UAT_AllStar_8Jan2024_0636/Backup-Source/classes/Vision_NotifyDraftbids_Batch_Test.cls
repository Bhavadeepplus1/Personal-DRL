@IsTest
private class Vision_NotifyDraftbids_Batch_Test {
    static testmethod void setup(){
         // Product Data
      
        // Account Data
        list<Account> alist= new list<account>();
        Account acc = new Account(Name='Test Account');
        alist.add(acc);
        insert alist;
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
        insert plist;
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
        bidtest.Phoenix_Approval_Status__c='Customer\'s Update';
        bidtest.Phoenix_Contact__c= c.Id;
        bidtest.Opportunity__c=op.Id;
        bidtest.Phoenix_Customer__c=alist[0].id;
        bidtest.Phoenix_Reference_Contracts__c='46579';
        bidtest.Phoenix_Bid_Name__c='test';
        bidtest.Phoenix_Customer_Type__c='New';
        bidtest.Phoenix_Bid_Type__c='New Customer';
        blist.add(bidtest);
        insert blist;
        // Bidline item data
        list<Phoenix_Bid_Line_Item__c> bllist = new list<Phoenix_Bid_Line_Item__c>();
        for(Phoenix_Bid__c bb :blist){
            Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
            bidLine.Phoenix_Product__c = plist[0].Id;
            bidLine.Phoenix_Contract__c = ctr.Id;
            
            
            bidline.Phoenix_Bid__c=bidtest.Id;
            bllist.add(bidline);
            Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
            cpt1.Vision_Account__c=acc.Id;
            cpt1.Vision_Contract__c=ctr.Id;
            cpt1.Vision_Contract_Product_Status__c='In Opportunity';
            cpt1.Vision_Product__c=plist[0].Id;
            cpt1.Vision_Product_Code__c='300027884';
            cpt1.Vision_Contract_Number__c='46579';
            
            
            insert cpt1;
        }
        
        insert bllist;
        Phoenix_Approval_Matrix__c mm= new Phoenix_Approval_Matrix__c();
        insert mm;
        Phoenix_Approval_Process_Step__c n= new Phoenix_Approval_Process_Step__c();
        n.name= 'Customer\'s Update';
        n.Phoenix_Approval_Matrix__c = mm.id;
        insert n;
           Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
        ps.Phoenix_Approver__c = UserInfo.getUserId();
        ps.Phoenix_Bid__c = blist[0].Id;
        ps.Phoenix_Approval_Sent_Time__c = system.now().adddays(-30);
        ps.Phoenix_Process_Step__c = n.id;
        ps.Phoenix_Status__c='In Process';
        //ps.Phoenix_Approval_Matrix__c = mm.id;
        insert ps;
        
        test.startTest();
        list<Document> lstDocument = [SELECT Id FROM Document WHERE DeveloperName = 'Vision_Logo'];
        Vision_NotifyDraftbids_Batch b= new Vision_NotifyDraftbids_Batch();
        database.executeBatch(b);
        //b.codecoverageBlock();
        test.stopTest();
        
    }
}