@istest
public class OptBasedContractPrdStatusBatchclstest {
    static testmethod void testsetup(){
        //Account Data
        Account A=new Account();
        a.name='test';
        insert a;
        
        Account b=new Account();
        b.name='test';
        insert b;
        
        //Contact Data
        Contact c=new Contact();
        c.lastname='test1';
        c.AccountId=a.Id;
        
        insert c;
        
        //Opportunity Data
        List<Opportunity> oplist=new List<Opportunity>();
        Opportunity op=new opportunity();
        op.AccountId=a.id;
        //op.Contact__c=c.id;
        op.Vision_Reference_Contract__c='350001213,1234567';
		op.Name='test1';
        op.StageName = 'Closed Won';
        op.CloseDate = System.today();
        oplist.add(op);
        
        insert oplist;
        
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
        
        
        List <Product_Opportunity__c> prdOptyList = new List<Product_Opportunity__c>();
        //Contract Data
        Phoenix_Contract__c ct=new Phoenix_Contract__c();
        ct.Name='123';
        ct.Phoenix_Customer__c=a.Id;
        ct.Phoenix_Contract_Number__c = '350001213';
        insert ct;
        //Product Opportunity Data
        Product_Opportunity__c po=new Product_Opportunity__c();
        po.Opportunity__c=op.Id;
        po.Product__c=p.id;
        po.Contract__c=ct.id;
        prdOptyList.add(po);
        
        Product_Opportunity__c prodopty1 = new Product_Opportunity__c(Name = 'Test Product opty', 
                                                                      NDC_11__c = '12345678902', Product_Family__c = 'Test Family',Vision_Bid_on_Highest_Pack_Size__c = true,
                                                                      GPI_Generic_Product_Identifier__c = '222222',Status__c = 'Matched',SKU_Number__c='123566',
                                                                      Opportunity__c=op.Id,GSN__c='666666',Vision_Opportunity_Value__c=10,Product__c=p.id
                                                                     );
        prdOptyList.add(prodopty1);
        insert prdOptyList;
        //Customer Product Tracker Data
        List<Vision_Customer_Product_Tracker__c> cpotlist= new List<Vision_Customer_Product_Tracker__c>();
        Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
        cpt1.Vision_Account__c=a.Id;
        cpt1.Vision_Contract__c=ct.Id;
        cpt1.Vision_Contract_Product_Status__c='In Opportunity';
        cpt1.Vision_Product__c=p.Id;
        cpt1.Vision_Product_Code__c='123566';
        cpt1.Vision_Contract_Number__c = '351001213';
        cpt1.Vision_Opportunity__c=op.Id;
        cpt1.Vision_In_Opportunity__c=true;
        cpotlist.add(cpt1);
        
        Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
        cpt.Vision_Account__c=b.Id;
        cpt.Vision_Contract__c=ct.Id;
        cpt.Vision_Contract_Product_Status__c='In Opportunity';
        cpt.Vision_Product__c=p1.Id;
        cpt.Vision_Product_Code__c='123566';
        cpt.Vision_Contract_Number__c = '350001213';
        cpt.Vision_Product_Opportunity__c = prodopty1.Id;
        cpt.Vision_In_Opportunity__c = true;
        cpt.Vision_Opportunity__c=op.Id;
      
        cpotlist.add(cpt);
        insert cpotlist;
        
      //  system.debug('CONTRACT '+ct.Id);
      //  system.debug('OPTY '+op.Id);
      //  system.debug('PRD OPTY '+prodopty1.Id);
       // system.debug('CUS PRD 1 '+cpt.Id);
       // system.debug('CUS PRD 2 '+cpt1.Id);
        
      //  map<String, Product_Opportunity__c> UniqueIdsMap = new map<String, Product_Opportunity__c>{'555555_350001213,1234567'=>prodopty1};
        
        test.startTest();
        OptyBasedContractPrdStatusBatchCls bl= new OptyBasedContractPrdStatusBatchCls();
        database.executeBatch(bl);
        test.stopTest();
        
    }
}