@istest
public class Updateposandcategoryresponseline_test {
    
    public static testmethod  void main(){
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
        
        bidtest.Phoenix_Customer_Type__c='ClarusOne';
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
            bidline.Phoenix_Current_Position__c='Primary';
            
            bidline.Phoenix_Current_MCK_Position__c='primary';
            bidline.Phoenix_Current_WMT_Position__c='primary';
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
        Phoenix_Product_Position__c pp= new Phoenix_Product_Position__c();
        pp.name='primary';
      
        pp.Phoenix_General_Category__c='primary';
        insert pp;
       // ===============================================================================================================
       list<Product2> plist1 = new list<product2>(); 
        Product2 prd1 = new Product2();
        prd1.Name = 'Test Product';
        prd1.ProductCode = '300027884';
        plist1.add(prd1);
        insert plist1;
        //Account Data
        list<Account> alist1= new list<account>();
        Account acc1 = new Account(Name='Test Acc3ount');
        alist1.add(acc1);
        insert alist1;
        //Phoenix contract Data
        Phoenix_Contract__c ctr1 = new Phoenix_Contract__c();
        ctr1.Name = 'Test Contract';
        ctr1.Phoenix_Contract_Number__c = '46579';
        ctr1.Phoenix_Customer__c = acc.Id;
        insert ctr1;
        //system.debug(ctr.id);
        //contact data
        contact c1 = new contact();
        c1.lastname='test';
        insert c1;
        //Opportunity Data
        List<Opportunity> oplist1=new List<Opportunity>();
        Opportunity op1=new opportunity();
        op1.AccountId=acc.id;
        op1.Contact__c=c.id;
        op1.Vision_Reference_Contract__c='46579';
        op1.Name='test1';
        op1.StageName = 'Closed Won';
        op1.CloseDate=system.today();
        oplist1.add(op1);
        insert oplist1;
        // Bid Data
        list<Phoenix_Bid__c> blist1 = new list<Phoenix_Bid__c>();
        Phoenix_Bid__c bidtest1 = new  Phoenix_Bid__c();
        bidtest1.Phoenix_Approval_Status__c='New';
        bidtest1.Phoenix_Contact__c= c.Id;
        bidtest1.Opportunity__c=op.Id;
        
        bidtest1.Phoenix_Customer_Type__c='new';
        bidtest1.Phoenix_Bid_Type__c='New Customer';
        blist1.add(bidtest1);
        insert blist1;
          Phoenix_Customer_Response__c cr1 = new Phoenix_Customer_Response__c();
        cr1.Phoenix_Affected_Contract_s__c='46579';
        insert cr1;
       
      
        
        
        //Bidline Data
        list<Phoenix_Bid_Line_Item__c> bllist1 = new list<Phoenix_Bid_Line_Item__c>();
        for(Phoenix_Bid__c bb1 :blist1){
            Phoenix_Bid_Line_Item__c bidLine1 = new Phoenix_Bid_Line_Item__c();
            bidLine1.Phoenix_Product__c = prd.Id;
           
            bidLine1.Phoenix_Contract__c = ctr.Id;
            bidline1.Phoenix_Current_Position__c='sECONDARY,';
            
            bidline1.Phoenix_Current_MCK_Position__c='primary';
            bidline1.Phoenix_Current_WMT_Position__c='primary';
            bidline1.Phoenix_Bid__c=bidtest.Id;
            bllist1.add(bidline1);
            
            //Customer product tracker data
            
        }
         Phoenix_Bid_Line_Item__c bidLine2 = new Phoenix_Bid_Line_Item__c();
            bidLine2.Phoenix_Product__c = prd.Id;
           
            bidLine2.Phoenix_Contract__c = ctr.Id;
            bidline2.Phoenix_Current_Position__c='Formulary,';
            
            bidline2.Phoenix_Current_MCK_Position__c='primary';
            bidline2.Phoenix_Current_WMT_Position__c='primary';
            bidline2.Phoenix_Bid__c=bidtest.Id;
            bllist1.add(bidline2);
            
        
        
        
        
        insert bllist1;
          Phoenix_Customer_Response_Line__c crline1 = new Phoenix_Customer_Response_Line__c();
        crline1.Phoenix_Customer_Response__c=cr.id;
        
        crline1.Phoenix_Bid__c=bidtest.id;
        crline1.Phoenix_Bid_Status__c='Awarded';
        crline1.Phoenix_Bid_Line_Item__c=bllist[0].id;
        
        insert crline1;
      
        Phoenix_Product_Position__c pp1= new Phoenix_Product_Position__c();
        pp1.name='secondary';
      
        pp1.Phoenix_General_Category__c='secondary';
        insert pp1;
          Phoenix_Product_Position__c pp2= new Phoenix_Product_Position__c();
        pp2.name='Formulary';
      
        pp2.Phoenix_General_Category__c='primary';
        insert pp2;
         
       test.startTest();
       Database.executeBatch(new UpdatePositionandCategoryinCusResLine());
        test.stopTest();

        
    }

    
    
    
    
    
    
    
}