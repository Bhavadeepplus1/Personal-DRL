@istest
public class NoBidsOpportunityNotification_Test {
    static testmethod void main(){
        Account a = new account();
        a.name='test';
        insert a;
        contact c= new contact();
        c.lastname='testlastname';
        insert c;
        
        Document document;

    document = new Document();
    document.Body = Blob.valueOf('Some Text');
    document.ContentType = 'application/pdf';
    document.DeveloperName = 'Vision_Logo';
    document.IsPublic = true;
    document.Name = 'My Document';
    document.FolderId = UserInfo.getUserId();//[select id from folder where name = 'My Test Docs'].id;
    insert document;
       
        
        
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
        insert p;
        Phoenix_Contract__c ctr = new Phoenix_Contract__c();
        ctr.Phoenix_Contract_Number__c='123456';
        ctr.Phoenix_Customer__c=a.id;
        insert ctr;
         opportunity o= new opportunity();
        o.Contact__c=c.id;
        o.name='test';
        o.closedate=system.today();
        o.StageName='Opportunity in progress';
        insert o;
         opportunity o1= new opportunity();
        o1.Contact__c=c.id;
        o1.name='test1';
        o1.closedate=date.newInstance(2022, 03, 25);
        o1.StageName='Opportunity in progress';
        insert o1;
        opportunity o2= new opportunity();
        o2.Contact__c=c.id;
        o2.name='test1';
        o2.closedate=system.today();//date.newInstance(2022, 04, 09);
        o2.StageName='Opportunity in progress';	
        insert o2;
       Phoenix_Bid__c bidtest = new Phoenix_Bid__c();
        bidtest.Opportunity__c=o.id;
        insert bidtest;
        Phoenix_Bid_Line_Item__c  bline = new Phoenix_Bid_Line_Item__c();
        bline.Phoenix_Bid__c=bidtest.id;

        Product_Opportunity__c op= new Product_Opportunity__c();
        op.Opportunity__c=o.id;
        op.Product__c=p.id;
        op.Product_Family__c='alt';
        op.Vision_Bid_Line_Item__c=bline.id;
        op.Vision_Product_Target_Date__c=date.newInstance(2022, 03, 25);
        
        insert op;
        Product_Opportunity__c op1= new Product_Opportunity__c();
        op1.Opportunity__c=o.id;
        op1.Product__c=p.id;
        op1.Product_Family__c='alt';
       // op.Vision_Bid_Line_Item__c=bline.id;
        op1.Vision_Product_Target_Date__c=system.today();
        
        insert op1;
        Product_Opportunity__c op2= new Product_Opportunity__c();
        op2.Opportunity__c=o2.id;
        op2.Product__c=p.id;
        op2.Product_Family__c='alt';
       // op.Vision_Bid_Line_Item__c=bline.id;
        op2.Vision_Product_Target_Date__c=system.today();
        
        insert op2;
        System.debug('op1>>'+op1);
        test.startTest();
        NoBidsOpportunityNotificationBatchCls b = new NoBidsOpportunityNotificationBatchCls();
        database.executeBatch(b);
        test.stopTest();
        
    }

}