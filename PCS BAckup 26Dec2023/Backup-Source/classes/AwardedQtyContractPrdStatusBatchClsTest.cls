@istest
public class AwardedQtyContractPrdStatusBatchClsTest {
    static testmethod void testsetup(){
        //Product data
        list<Product2> plist = new list<product2>(); 
        Product2 prd = new Product2();
        prd.Name = 'Test Product';
        prd.ProductCode = '300027884';
        plist.add(prd);
        insert plist;
        //Account Data
        list<Account> alist= new list<account>();
        Account acc = new Account(Name='Test Account');
        alist.add(acc);
        insert alist;
        //Phoenix contract Data
        Phoenix_Contract__c ctr = new Phoenix_Contract__c();
        ctr.Name = 'Test Contract';
        ctr.Phoenix_Contract_Number__c = '46579';
        ctr.Phoenix_Customer__c = acc.Id;
        insert ctr;
        system.debug(ctr.id);
        //contact data
        contact c = new contact();
        c.lastname='test';
        insert c;
        //Opportunity Data
        List<Opportunity> oplist=new List<Opportunity>();
        Opportunity op=new opportunity();
        op.AccountId=acc.id;
        op.Contact__c=c.id;
        op.Vision_Reference_Contract__c='46579';
        op.Name='test1';
        op.StageName = 'Closed Won';
        op.CloseDate=system.today();
        oplist.add(op);
        insert oplist;
        // Bid Data
        list<Phoenix_Bid__c> blist = new list<Phoenix_Bid__c>();
        Phoenix_Bid__c bidtest = new  Phoenix_Bid__c();
        bidtest.Phoenix_Approval_Status__c='New';
        bidtest.Phoenix_Contact__c= c.Id;
        bidtest.Opportunity__c=op.Id;
        
        bidtest.Phoenix_Customer_Type__c='New';
        bidtest.Phoenix_Bid_Type__c='New Customer';
        blist.add(bidtest);
        insert blist;
          Phoenix_Customer_Response__c cr = new Phoenix_Customer_Response__c();
        cr.Phoenix_Affected_Contract_s__c='46579';
        insert cr;
       
      
        
        
        //Bidline Data
        list<Phoenix_Bid_Line_Item__c> bllist = new list<Phoenix_Bid_Line_Item__c>();
        for(Phoenix_Bid__c bb :blist){
            Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
            bidLine.Phoenix_Product__c = prd.Id;
            system.debug(prd.id);
            system.debug(plist[0].id);
            bidLine.Phoenix_Contract__c = ctr.Id;
            
            
            bidline.Phoenix_Bid__c=bidtest.Id;
            bllist.add(bidline);
            //Customer product tracker data
            
        }
        
        insert bllist;
         Phoenix_Customer_Response_Line__c crline = new Phoenix_Customer_Response_Line__c();
        crline.Phoenix_Customer_Response__c=cr.id;
        
        crline.Phoenix_Bid__c=bidtest.id;
        crline.Phoenix_Bid_Status__c='Awarded';
        crline.Phoenix_Bid_Line_Item__c=bllist[0].id;
        insert crline;
          Phoenix_Awarded_Quantity__c aq= new Phoenix_Awarded_Quantity__c();
        aq.Customer_Response_Line__c=crline.id;
        aq.Phoenix_Awarded_Quantity__c=22.0;
        aq.Phoenix_Contract__c=ctr.id;
        aq.Phoenix_Material_Code__c='12345';
        aq.Phoenix_Contract_Number__c='46579';
        insert aq;
        //customer response line data
        Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
            cpt1.Vision_Account__c=acc.Id;
            cpt1.Vision_Contract__c=ctr.Id;
            cpt1.Vision_Contract_Product_Status__c='Awarded';
            cpt1.Vision_Product__c=prd.Id;
            cpt1.Vision_Product_Code__c='300027884';
            cpt1.Vision_Contract_Number__c='46579';
            cpt1.Vision_Is_In_Awarded__c=true;
            cpt1.Vision_Cus_Response_Lines_Created_Date__c=system.now();
            cpt1.Vision_Customer_Response__c=cr.id;
            cpt1.Vision_Customer_Response_Created_Date__c=system.now();
            cpt1.Vision_Customer_Response_Name__c='cr';
            cpt1.Vision_In_Customer_Response_Lines__c=true;
            cpt1.Customer_Response_Effective_Date__c=system.today();
            cpt1.Customer_Response_Line__c=crline.id;
            cpt1.Vision_Awarded_Volume__c=23.0;
            cpt1.Vision_Previous_Volume__c=23.0;
            cpt1.Vision_Internal_DeadNet__c=25;
            cpt1.Vision_Previous_DeadNet__c=23;
            
            
            
            insert cpt1;
      
        test.startTest();
        AwardedQtyContractPrdStatusBatchCls b = new  AwardedQtyContractPrdStatusBatchCls();
        database.executeBatch(b);
        test.stopTest();
    }
}