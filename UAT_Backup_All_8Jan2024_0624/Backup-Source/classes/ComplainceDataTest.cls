@istest
public class ComplainceDataTest {
static testmethod void setup(){
     account a = new account();
         a.name='test';
         a.accountnumber='123454';
    insert a;
    
     list<Product2> plist = new list<Product2>();
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.OTC_Customer__c=a.id;
        p.IsActive=true;
        p.Phoenix_Is_Exclude_Bid__c=false;
        p.Vision_Is_CPT_Batch_Executed__c=false;
        p.Phoenix_Is_Private_Label_OTC__c=true;
        p.Phoenix_NDC_11__c='23364347';
       // p.ProductCode='123567';
        // p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='123566';
        //p.Phoenix_Product_Director__c=u.id;
      p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        plist.add(p);
   
    insert plist;
     Phoenix_Contract__c ctr = new Phoenix_Contract__c();
       ctr.Name = 'Test Contract';
        ctr.Phoenix_Customer__c = a.Id;
        ctr.Phoenix_Contract_Number__c='1234';
        ctr.Phoenix_Contract_Start_Date__c=system.today();
        ctr.Phoenix_Contract_End_Date__c=date.newInstance(2023, 12, 23);
    
        
        
        //ctr.Phoenix_Contract_Status__c='Active';
        insert ctr;
       
     Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
          //  cpt1.Vision_Account__c=acc.Id;
            cpt1.Vision_Contract__c=ctr.Id;
          //  cpt1.Vision_Contract_Product_Status__c='In Opportunity';
          //  cpt1.Vision_Product__c=p1.Id;
            cpt1.Vision_Product_Code__c='123566';
            cpt1.Vision_Contract_Number__c='1234';
            cpt1.Vision_Customer_Code__c='123456';
    cpt1.Vision_Is_In_Awarded__c=true;
            //cpt1.Vision_Price_Effective_Date__c=2022-07-19;
          // cpt1.Vision_Internal_Unique_Identifier__c='-300036391';
          //cpt1.Compliance_Unique_Identifier__c='3000001841-300036391';
          cpt1.General_Category__c='Primary';
         cpt1.Vision_Awarded_Value__c=23;
    cpt1.Vision_Awarded_Volume__c=23.0;
    cpt1.Vision_Current_Product_Position__c ='Multi-Award';
    
      
            
           
        //    cpt1.Bid_Line_Item__c=bdl.id;
            
            
            insert cpt1;
    Vision_GCP_Backorder_OTC__c bt= new Vision_GCP_Backorder_OTC__c();
    bt.Vision_Sku_Code__c='123566';
    bt.Vision_Backorder_Report_Date__c='2022-10-13';
    insert bt;
    Vision_GCP_Backorder_SRx_Rx__c srrx= new Vision_GCP_Backorder_SRx_Rx__c();
       srrx.Vision_MoH__c=23;
      srrx.Vision_SKU_Code__c='123566';
    srrx.Vision_On_Backorder__c='true';
      insert srrx;
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c = ctr.Id;
       npr.Phoenix_Contract_Number__c='1234';
        npr.Phoenix_Product__c=p.Id;
        npr.Phoenix_Add_ABS_Value__c = 2.00;
    npr.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr.Phoenix_12Months_Net_Sales__c=22.0;
    npr.Phoenix_Account__c=a.id;
    npr.Phoenix_Contract_Type__c='Indirect';
    npr.Phoenix_NPR_Status__c='Active';
   
   npr.Phoenix_Material_Number__c='123566';
        insert npr;
     Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr1.Phoenix_Contract__c = ctr.Id;
       npr1.Phoenix_Contract_Number__c='12346';
        npr1.Phoenix_Product__c=p.Id;
        npr1.Phoenix_Add_ABS_Value__c = 2.00;
    npr1.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr1.Phoenix_12Months_Net_Sales__c=22.0;
    npr1.Phoenix_Account__c=a.id;
    npr1.Phoenix_Contract_Type__c='Indirect';
    npr1.Phoenix_NPR_Status__c='Active';
   
   npr1.Phoenix_Material_Number__c='123566';
        insert npr1;
     Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr2.Phoenix_Contract__c = ctr.Id;
       npr2.Phoenix_Contract_Number__c='12345';
        npr2.Phoenix_Product__c=p.Id;
        npr2.Phoenix_Add_ABS_Value__c = 2.00;
    npr2.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr2.Phoenix_12Months_Net_Sales__c=22.0;
    npr2.Phoenix_Account__c=a.id;
    npr2.Phoenix_Contract_Type__c='Indirect';
    npr2.Phoenix_NPR_Status__c='Active';
   
   npr2.Phoenix_Material_Number__c='123566';
        insert npr2;
    list<Phoenix_NPR_Data__c> npr1ist=[select id,Phoenix_Contract__c,Phoenix_Contract_Number__c,Phoenix_Product__c,Phoenix_Add_ABS_Value__c,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_12Months_Net_Sales__c,Phoenix_Account__c,Phoenix_Contract_Type__c,Phoenix_NPR_Status__c,Phoenix_Material_Number__c from Phoenix_NPR_Data__c limit 10000];
    system.debug('nprlist....'+npr1ist.size());
    
       // Phoenix_NPR_Volume__c l1=[select Id,Phoenix_NPR_Data__r.Phoenix_Contract_Number__c,Phoenix_NPR_Data__r.Phoenix_Material_Number__c,Phoenix_NPR_Data__r.Phoenix_Contract_Type__c,Phoenix_NPR_Data__r.Phoenix_12Mt_Sales_Ut_Actual__c,Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC__c,Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_NPR_Data__r.Phoenix_Account__r.Accountnumber,Phoenix_NPR_Data__r.Phoenix_Account__c,Phoenix_NPR_Data__r.Phoenix_Contract__c,Phoenix_NPR_Data__r.Phoenix_Product__c,Phoenix_Month__c,Phoenix_Volume__c  from Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__r.Phoenix_NPR_Status__c=:'active' limit 1];
    Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol = new Phoenix_NPR_Volume__c();
        nprvol.Phoenix_NPR_Data__c=npr.id;
   nprvol.Phoenix_Date__c=  date.newInstance(2022, 10, 01);
       
       nprvol.Phoenix_Volume__c=23.00;
    insert nprvol;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol4 = new Phoenix_NPR_Volume__c();
        nprvol4.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol4.Phoenix_Date__c=  date.newInstance(2022, 09, 01);
       
       nprvol4.Phoenix_Volume__c=23.00;
    insert nprvol4;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol5 = new Phoenix_NPR_Volume__c();
        nprvol5.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol5.Phoenix_Date__c=  date.newInstance(2022, 08, 01);
       
       nprvol5.Phoenix_Volume__c=23.00;
    insert nprvol5;
   //  Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol6 = new Phoenix_NPR_Volume__c();
        nprvol6.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol6.Phoenix_Date__c=  date.newInstance(2022, 07, 01);
       
       nprvol6.Phoenix_Volume__c=23.00;
    insert nprvol6;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
       Phoenix_NPR_Volume__c nprvol7 = new Phoenix_NPR_Volume__c();
        nprvol7.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol7.Phoenix_Date__c=  date.newInstance(2022, 05, 01);
       
       nprvol7.Phoenix_Volume__c=23.00;
    insert nprvol7;
     
        Phoenix_NPR_Volume__c nprvol8 = new Phoenix_NPR_Volume__c();
        nprvol8.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol8.Phoenix_Date__c=  date.newInstance(2022, 06, 01);
       
       nprvol8.Phoenix_Volume__c=23.00;
    insert nprvol8;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol9 = new Phoenix_NPR_Volume__c();
        nprvol9.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol9.Phoenix_Date__c=  date.newInstance(2022, 04, 01);
       
       nprvol9.Phoenix_Volume__c=23.00;
    insert nprvol9;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol10 = new Phoenix_NPR_Volume__c();
        nprvol10.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol10.Phoenix_Date__c=  date.newInstance(2022, 03, 01);
       
       nprvol10.Phoenix_Volume__c=23.00;
    insert nprvol10;
    
   // Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
    
         //Vision_Customer_Product_Tracker__c cusPrdTrk = new Vision_Customer_Product_Tracker__c();
      //  insert cusPrdTrk;
   

  

    
      test.startTest();
        ComplianceRecordsNprData b= new ComplianceRecordsNprData();
        database.executeBatch(b);
        test.stopTest();
        
          //nprvol.Phoenix_Customer__c=a.id;
          //nprvol.Phoenix_Product__c=p.id;
          
        
    }
    static testmethod void setup1(){
         account a = new account();
         a.name='test';
         a.accountnumber='123454';
    insert a;
    
     list<Product2> plist = new list<Product2>();
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.OTC_Customer__c=a.id;
        p.IsActive=true;
        p.Phoenix_Is_Exclude_Bid__c=false;
        p.Vision_Is_CPT_Batch_Executed__c=false;
        p.Phoenix_Is_Private_Label_OTC__c=true;
        p.Phoenix_NDC_11__c='23364347';
       // p.ProductCode='123567';
        // p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='123566';
        //p.Phoenix_Product_Director__c=u.id;
      p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        plist.add(p);
   
    insert plist;
     Phoenix_Contract__c ctr = new Phoenix_Contract__c();
       ctr.Name = 'Test Contract';
        ctr.Phoenix_Customer__c = a.Id;
        ctr.Phoenix_Contract_Number__c='1234';
        ctr.Phoenix_Contract_Start_Date__c=system.today();
        ctr.Phoenix_Contract_End_Date__c=date.newInstance(2023, 12, 23);
    
        
        
        //ctr.Phoenix_Contract_Status__c='Active';
        insert ctr;
       
     Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
          //  cpt1.Vision_Account__c=acc.Id;
            cpt1.Vision_Contract__c=ctr.Id;
          //  cpt1.Vision_Contract_Product_Status__c='In Opportunity';
          //  cpt1.Vision_Product__c=p1.Id;
            cpt1.Vision_Product_Code__c='123566';
            cpt1.Vision_Contract_Number__c='1234';
            cpt1.Vision_Customer_Code__c='123456';
    cpt1.Vision_Is_In_Awarded__c=true;
            //cpt1.Vision_Price_Effective_Date__c=2022-07-19;
          // cpt1.Vision_Internal_Unique_Identifier__c='-300036391';
          //cpt1.Compliance_Unique_Identifier__c='3000001841-300036391';
          cpt1.General_Category__c='Primary';
         cpt1.Vision_Awarded_Value__c=23;
    cpt1.Vision_Awarded_Volume__c=23.0;
    cpt1.Vision_Current_Product_Position__c ='Multi-Award';
    
      
            
           
        //    cpt1.Bid_Line_Item__c=bdl.id;
            
            
            insert cpt1;
    Vision_GCP_Backorder_OTC__c bt= new Vision_GCP_Backorder_OTC__c();
    bt.Vision_Sku_Code__c='123566';
    bt.Vision_Backorder_Report_Date__c='2022-10-13';
    insert bt;
    Vision_GCP_Backorder_SRx_Rx__c srrx= new Vision_GCP_Backorder_SRx_Rx__c();
       srrx.Vision_MoH__c=23;
      srrx.Vision_SKU_Code__c='123566';
    srrx.Vision_On_Backorder__c='true';
      insert srrx;
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c = ctr.Id;
       npr.Phoenix_Contract_Number__c='1234';
        npr.Phoenix_Product__c=p.Id;
        npr.Phoenix_Add_ABS_Value__c = 2.00;
    npr.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr.Phoenix_12Months_Net_Sales__c=22.0;
    npr.Phoenix_Account__c=a.id;
    npr.Phoenix_Contract_Type__c='Indirect';
    npr.Phoenix_NPR_Status__c='Active';
   
   npr.Phoenix_Material_Number__c='123566';
        insert npr;
     Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr1.Phoenix_Contract__c = ctr.Id;
       npr1.Phoenix_Contract_Number__c='12346';
        npr1.Phoenix_Product__c=p.Id;
        npr1.Phoenix_Add_ABS_Value__c = 2.00;
    npr1.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr1.Phoenix_12Months_Net_Sales__c=22.0;
    npr1.Phoenix_Account__c=a.id;
    npr1.Phoenix_Contract_Type__c='Indirect';
    npr1.Phoenix_NPR_Status__c='Active';
   
   npr1.Phoenix_Material_Number__c='123566';
        insert npr1;
     Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr2.Phoenix_Contract__c = ctr.Id;
       npr2.Phoenix_Contract_Number__c='12345';
        npr2.Phoenix_Product__c=p.Id;
        npr2.Phoenix_Add_ABS_Value__c = 2.00;
    npr2.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr2.Phoenix_12Months_Net_Sales__c=22.0;
    npr2.Phoenix_Account__c=a.id;
    npr2.Phoenix_Contract_Type__c='Indirect';
    npr2.Phoenix_NPR_Status__c='Active';
   
   npr2.Phoenix_Material_Number__c='123566';
        insert npr2;
    list<Phoenix_NPR_Data__c> npr1ist=[select id,Phoenix_Contract__c,Phoenix_Contract_Number__c,Phoenix_Product__c,Phoenix_Add_ABS_Value__c,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_12Months_Net_Sales__c,Phoenix_Account__c,Phoenix_Contract_Type__c,Phoenix_NPR_Status__c,Phoenix_Material_Number__c from Phoenix_NPR_Data__c limit 10000];
    system.debug('nprlist....'+npr1ist.size());
    
       // Phoenix_NPR_Volume__c l1=[select Id,Phoenix_NPR_Data__r.Phoenix_Contract_Number__c,Phoenix_NPR_Data__r.Phoenix_Material_Number__c,Phoenix_NPR_Data__r.Phoenix_Contract_Type__c,Phoenix_NPR_Data__r.Phoenix_12Mt_Sales_Ut_Actual__c,Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC__c,Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_NPR_Data__r.Phoenix_Account__r.Accountnumber,Phoenix_NPR_Data__r.Phoenix_Account__c,Phoenix_NPR_Data__r.Phoenix_Contract__c,Phoenix_NPR_Data__r.Phoenix_Product__c,Phoenix_Month__c,Phoenix_Volume__c  from Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__r.Phoenix_NPR_Status__c=:'active' limit 1];
    Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol = new Phoenix_NPR_Volume__c();
        nprvol.Phoenix_NPR_Data__c=npr.id;
   nprvol.Phoenix_Date__c=  date.newInstance(2022, 09, 01);
       
       nprvol.Phoenix_Volume__c=23.00;
    insert nprvol;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol4 = new Phoenix_NPR_Volume__c();
        nprvol4.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol4.Phoenix_Date__c=  date.newInstance(2022, 09, 01);
       
       nprvol4.Phoenix_Volume__c=23.00;
    insert nprvol4;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol5 = new Phoenix_NPR_Volume__c();
        nprvol5.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol5.Phoenix_Date__c=  date.newInstance(2022, 08, 01);
       
       nprvol5.Phoenix_Volume__c=23.00;
    insert nprvol5;
   //  Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol6 = new Phoenix_NPR_Volume__c();
        nprvol6.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol6.Phoenix_Date__c=  date.newInstance(2022, 07, 01);
       
       nprvol6.Phoenix_Volume__c=23.00;
    insert nprvol6;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
       Phoenix_NPR_Volume__c nprvol7 = new Phoenix_NPR_Volume__c();
        nprvol7.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol7.Phoenix_Date__c=  date.newInstance(2022, 05, 01);
       
       nprvol7.Phoenix_Volume__c=23.00;
    insert nprvol7;
     
        Phoenix_NPR_Volume__c nprvol8 = new Phoenix_NPR_Volume__c();
        nprvol8.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol8.Phoenix_Date__c=  date.newInstance(2022, 06, 01);
       
       nprvol8.Phoenix_Volume__c=23.00;
    insert nprvol8;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol9 = new Phoenix_NPR_Volume__c();
        nprvol9.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol9.Phoenix_Date__c=  date.newInstance(2022, 04, 01);
       
       nprvol9.Phoenix_Volume__c=23.00;
    insert nprvol9;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol10 = new Phoenix_NPR_Volume__c();
        nprvol10.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol10.Phoenix_Date__c=  date.newInstance(2022, 03, 01);
       
       nprvol10.Phoenix_Volume__c=23.00;
    insert nprvol10;
    
   // Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
    
         //Vision_Customer_Product_Tracker__c cusPrdTrk = new Vision_Customer_Product_Tracker__c();
      //  insert cusPrdTrk;
   

  

    
      test.startTest();
        ComplianceRecordsNprData b= new ComplianceRecordsNprData();
        database.executeBatch(b);
        test.stopTest();
        
          //nprvol.Phoenix_Customer__c=a.id;
          //nprvol.Phoenix_Product__c=p.id;
          
    }
    static testmethod void setup2(){
         account a = new account();
         a.name='test';
         a.accountnumber='123454';
    insert a;
    
     list<Product2> plist = new list<Product2>();
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.OTC_Customer__c=a.id;
        p.IsActive=true;
        p.Phoenix_Is_Exclude_Bid__c=false;
        p.Vision_Is_CPT_Batch_Executed__c=false;
        p.Phoenix_Is_Private_Label_OTC__c=true;
        p.Phoenix_NDC_11__c='23364347';
       // p.ProductCode='123567';
        // p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='123566';
        //p.Phoenix_Product_Director__c=u.id;
      p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        plist.add(p);
   
    insert plist;
     Phoenix_Contract__c ctr = new Phoenix_Contract__c();
       ctr.Name = 'Test Contract';
        ctr.Phoenix_Customer__c = a.Id;
        ctr.Phoenix_Contract_Number__c='1234';
        ctr.Phoenix_Contract_Start_Date__c=system.today();
        ctr.Phoenix_Contract_End_Date__c=date.newInstance(2023, 12, 23);
    
        
        
        //ctr.Phoenix_Contract_Status__c='Active';
        insert ctr;
       
     Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
          //  cpt1.Vision_Account__c=acc.Id;
            cpt1.Vision_Contract__c=ctr.Id;
          //  cpt1.Vision_Contract_Product_Status__c='In Opportunity';
          //  cpt1.Vision_Product__c=p1.Id;
            cpt1.Vision_Product_Code__c='123566';
            cpt1.Vision_Contract_Number__c='1234';
            cpt1.Vision_Customer_Code__c='123456';
    cpt1.Vision_Is_In_Awarded__c=true;
            //cpt1.Vision_Price_Effective_Date__c=2022-07-19;
          // cpt1.Vision_Internal_Unique_Identifier__c='-300036391';
          //cpt1.Compliance_Unique_Identifier__c='3000001841-300036391';
          cpt1.General_Category__c='Primary';
         cpt1.Vision_Awarded_Value__c=23;
    cpt1.Vision_Awarded_Volume__c=23.0;
    cpt1.Vision_Current_Product_Position__c ='Multi-Award';
    
      
            
           
        //    cpt1.Bid_Line_Item__c=bdl.id;
            
            
            insert cpt1;
    Vision_GCP_Backorder_OTC__c bt= new Vision_GCP_Backorder_OTC__c();
    bt.Vision_Sku_Code__c='123566';
    bt.Vision_Backorder_Report_Date__c='2022-10-13';
    insert bt;
    Vision_GCP_Backorder_SRx_Rx__c srrx= new Vision_GCP_Backorder_SRx_Rx__c();
       srrx.Vision_MoH__c=23;
      srrx.Vision_SKU_Code__c='123566';
    srrx.Vision_On_Backorder__c='true';
      insert srrx;
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c = ctr.Id;
       npr.Phoenix_Contract_Number__c='1234';
        npr.Phoenix_Product__c=p.Id;
        npr.Phoenix_Add_ABS_Value__c = 2.00;
    npr.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr.Phoenix_12Months_Net_Sales__c=22.0;
    npr.Phoenix_Account__c=a.id;
    npr.Phoenix_Contract_Type__c='Indirect';
    npr.Phoenix_NPR_Status__c='Active';
   
   npr.Phoenix_Material_Number__c='123566';
        insert npr;
     Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr1.Phoenix_Contract__c = ctr.Id;
       npr1.Phoenix_Contract_Number__c='12346';
        npr1.Phoenix_Product__c=p.Id;
        npr1.Phoenix_Add_ABS_Value__c = 2.00;
    npr1.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr1.Phoenix_12Months_Net_Sales__c=22.0;
    npr1.Phoenix_Account__c=a.id;
    npr1.Phoenix_Contract_Type__c='Indirect';
    npr1.Phoenix_NPR_Status__c='Active';
   
   npr1.Phoenix_Material_Number__c='123566';
        insert npr1;
     Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr2.Phoenix_Contract__c = ctr.Id;
       npr2.Phoenix_Contract_Number__c='12345';
        npr2.Phoenix_Product__c=p.Id;
        npr2.Phoenix_Add_ABS_Value__c = 2.00;
    npr2.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr2.Phoenix_12Months_Net_Sales__c=22.0;
    npr2.Phoenix_Account__c=a.id;
    npr2.Phoenix_Contract_Type__c='Indirect';
    npr2.Phoenix_NPR_Status__c='Active';
   
   npr2.Phoenix_Material_Number__c='123566';
        insert npr2;
    list<Phoenix_NPR_Data__c> npr1ist=[select id,Phoenix_Contract__c,Phoenix_Contract_Number__c,Phoenix_Product__c,Phoenix_Add_ABS_Value__c,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_12Months_Net_Sales__c,Phoenix_Account__c,Phoenix_Contract_Type__c,Phoenix_NPR_Status__c,Phoenix_Material_Number__c from Phoenix_NPR_Data__c limit 10000];
    system.debug('nprlist....'+npr1ist.size());
    
       // Phoenix_NPR_Volume__c l1=[select Id,Phoenix_NPR_Data__r.Phoenix_Contract_Number__c,Phoenix_NPR_Data__r.Phoenix_Material_Number__c,Phoenix_NPR_Data__r.Phoenix_Contract_Type__c,Phoenix_NPR_Data__r.Phoenix_12Mt_Sales_Ut_Actual__c,Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC__c,Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_NPR_Data__r.Phoenix_Account__r.Accountnumber,Phoenix_NPR_Data__r.Phoenix_Account__c,Phoenix_NPR_Data__r.Phoenix_Contract__c,Phoenix_NPR_Data__r.Phoenix_Product__c,Phoenix_Month__c,Phoenix_Volume__c  from Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__r.Phoenix_NPR_Status__c=:'active' limit 1];
    Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol = new Phoenix_NPR_Volume__c();
        nprvol.Phoenix_NPR_Data__c=npr.id;
   nprvol.Phoenix_Date__c=  date.newInstance(2022, 08, 01);
       
       nprvol.Phoenix_Volume__c=23.00;
    insert nprvol;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol4 = new Phoenix_NPR_Volume__c();
        nprvol4.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol4.Phoenix_Date__c=  date.newInstance(2022, 09, 01);
       
       nprvol4.Phoenix_Volume__c=23.00;
    insert nprvol4;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol5 = new Phoenix_NPR_Volume__c();
        nprvol5.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol5.Phoenix_Date__c=  date.newInstance(2022, 08, 01);
       
       nprvol5.Phoenix_Volume__c=23.00;
    insert nprvol5;
   //  Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol6 = new Phoenix_NPR_Volume__c();
        nprvol6.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol6.Phoenix_Date__c=  date.newInstance(2022, 07, 01);
       
       nprvol6.Phoenix_Volume__c=23.00;
    insert nprvol6;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
       Phoenix_NPR_Volume__c nprvol7 = new Phoenix_NPR_Volume__c();
        nprvol7.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol7.Phoenix_Date__c=  date.newInstance(2022, 05, 01);
       
       nprvol7.Phoenix_Volume__c=23.00;
    insert nprvol7;
     
        Phoenix_NPR_Volume__c nprvol8 = new Phoenix_NPR_Volume__c();
        nprvol8.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol8.Phoenix_Date__c=  date.newInstance(2022, 06, 01);
       
       nprvol8.Phoenix_Volume__c=23.00;
    insert nprvol8;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol9 = new Phoenix_NPR_Volume__c();
        nprvol9.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol9.Phoenix_Date__c=  date.newInstance(2022, 04, 01);
       
       nprvol9.Phoenix_Volume__c=23.00;
    insert nprvol9;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol10 = new Phoenix_NPR_Volume__c();
        nprvol10.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol10.Phoenix_Date__c=  date.newInstance(2022, 03, 01);
       
       nprvol10.Phoenix_Volume__c=23.00;
    insert nprvol10;
    
   // Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
    
         //Vision_Customer_Product_Tracker__c cusPrdTrk = new Vision_Customer_Product_Tracker__c();
      //  insert cusPrdTrk;
   

  

    
      test.startTest();
        ComplianceRecordsNprData b= new ComplianceRecordsNprData();
        database.executeBatch(b);
        test.stopTest();
        
          //nprvol.Phoenix_Customer__c=a.id;
          //nprvol.Phoenix_Product__c=p.id;
          
    }
    static testmethod void setup6(){
         account a = new account();
         a.name='test';
         a.accountnumber='123454';
    insert a;
    
     list<Product2> plist = new list<Product2>();
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.OTC_Customer__c=a.id;
        p.IsActive=true;
        p.Phoenix_Is_Exclude_Bid__c=false;
        p.Vision_Is_CPT_Batch_Executed__c=false;
        p.Phoenix_Is_Private_Label_OTC__c=true;
        p.Phoenix_NDC_11__c='23364347';
       // p.ProductCode='123567';
        // p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='123566';
        //p.Phoenix_Product_Director__c=u.id;
      p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        plist.add(p);
   
    insert plist;
     Phoenix_Contract__c ctr = new Phoenix_Contract__c();
       ctr.Name = 'Test Contract';
        ctr.Phoenix_Customer__c = a.Id;
        ctr.Phoenix_Contract_Number__c='1234';
        ctr.Phoenix_Contract_Start_Date__c=system.today();
        ctr.Phoenix_Contract_End_Date__c=date.newInstance(2023, 12, 23);
    
        
        
        //ctr.Phoenix_Contract_Status__c='Active';
        insert ctr;
       
     Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
          //  cpt1.Vision_Account__c=acc.Id;
            cpt1.Vision_Contract__c=ctr.Id;
          //  cpt1.Vision_Contract_Product_Status__c='In Opportunity';
          //  cpt1.Vision_Product__c=p1.Id;
            cpt1.Vision_Product_Code__c='123566';
            cpt1.Vision_Contract_Number__c='1234';
            cpt1.Vision_Customer_Code__c='123456';
    cpt1.Vision_Is_In_Awarded__c=true;
            //cpt1.Vision_Price_Effective_Date__c=2022-07-19;
          // cpt1.Vision_Internal_Unique_Identifier__c='-300036391';
          //cpt1.Compliance_Unique_Identifier__c='3000001841-300036391';
          cpt1.General_Category__c='Primary';
         cpt1.Vision_Awarded_Value__c=23;
    cpt1.Vision_Awarded_Volume__c=23.0;
    cpt1.Vision_Current_Product_Position__c ='Multi-Award';
    
      
            
           
        //    cpt1.Bid_Line_Item__c=bdl.id;
            
            
            insert cpt1;
    Vision_GCP_Backorder_OTC__c bt= new Vision_GCP_Backorder_OTC__c();
    bt.Vision_Sku_Code__c='123566';
    bt.Vision_Backorder_Report_Date__c='2022-10-13';
    insert bt;
    Vision_GCP_Backorder_SRx_Rx__c srrx= new Vision_GCP_Backorder_SRx_Rx__c();
       srrx.Vision_MoH__c=23;
      srrx.Vision_SKU_Code__c='123566';
    srrx.Vision_On_Backorder__c='true';
      insert srrx;
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c = ctr.Id;
       npr.Phoenix_Contract_Number__c='1234';
        npr.Phoenix_Product__c=p.Id;
        npr.Phoenix_Add_ABS_Value__c = 2.00;
    npr.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr.Phoenix_12Months_Net_Sales__c=22.0;
    npr.Phoenix_Account__c=a.id;
    npr.Phoenix_Contract_Type__c='Indirect';
    npr.Phoenix_NPR_Status__c='Active';
   
   npr.Phoenix_Material_Number__c='123566';
        insert npr;
     Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr1.Phoenix_Contract__c = ctr.Id;
       npr1.Phoenix_Contract_Number__c='12346';
        npr1.Phoenix_Product__c=p.Id;
        npr1.Phoenix_Add_ABS_Value__c = 2.00;
    npr1.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr1.Phoenix_12Months_Net_Sales__c=22.0;
    npr1.Phoenix_Account__c=a.id;
    npr1.Phoenix_Contract_Type__c='Indirect';
    npr1.Phoenix_NPR_Status__c='Active';
   
   npr1.Phoenix_Material_Number__c='123566';
        insert npr1;
     Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr2.Phoenix_Contract__c = ctr.Id;
       npr2.Phoenix_Contract_Number__c='12345';
        npr2.Phoenix_Product__c=p.Id;
        npr2.Phoenix_Add_ABS_Value__c = 2.00;
    npr2.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr2.Phoenix_12Months_Net_Sales__c=22.0;
    npr2.Phoenix_Account__c=a.id;
    npr2.Phoenix_Contract_Type__c='Indirect';
    npr2.Phoenix_NPR_Status__c='Active';
   
   npr2.Phoenix_Material_Number__c='123566';
        insert npr2;
    list<Phoenix_NPR_Data__c> npr1ist=[select id,Phoenix_Contract__c,Phoenix_Contract_Number__c,Phoenix_Product__c,Phoenix_Add_ABS_Value__c,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_12Months_Net_Sales__c,Phoenix_Account__c,Phoenix_Contract_Type__c,Phoenix_NPR_Status__c,Phoenix_Material_Number__c from Phoenix_NPR_Data__c limit 10000];
    system.debug('nprlist....'+npr1ist.size());
    
       // Phoenix_NPR_Volume__c l1=[select Id,Phoenix_NPR_Data__r.Phoenix_Contract_Number__c,Phoenix_NPR_Data__r.Phoenix_Material_Number__c,Phoenix_NPR_Data__r.Phoenix_Contract_Type__c,Phoenix_NPR_Data__r.Phoenix_12Mt_Sales_Ut_Actual__c,Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC__c,Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_NPR_Data__r.Phoenix_Account__r.Accountnumber,Phoenix_NPR_Data__r.Phoenix_Account__c,Phoenix_NPR_Data__r.Phoenix_Contract__c,Phoenix_NPR_Data__r.Phoenix_Product__c,Phoenix_Month__c,Phoenix_Volume__c  from Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__r.Phoenix_NPR_Status__c=:'active' limit 1];
    Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol = new Phoenix_NPR_Volume__c();
        nprvol.Phoenix_NPR_Data__c=npr.id;
   nprvol.Phoenix_Date__c=  date.newInstance(2022, 08, 01);
       
       nprvol.Phoenix_Volume__c=23.00;
    insert nprvol;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol4 = new Phoenix_NPR_Volume__c();
        nprvol4.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol4.Phoenix_Date__c=  date.newInstance(2022, 09, 01);
       
       nprvol4.Phoenix_Volume__c=23.00;
    insert nprvol4;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol5 = new Phoenix_NPR_Volume__c();
        nprvol5.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol5.Phoenix_Date__c=  date.newInstance(2022, 08, 01);
       
       nprvol5.Phoenix_Volume__c=23.00;
    insert nprvol5;
   //  Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol6 = new Phoenix_NPR_Volume__c();
        nprvol6.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol6.Phoenix_Date__c=  date.newInstance(2022, 07, 01);
       
       nprvol6.Phoenix_Volume__c=23.00;
    insert nprvol6;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
       Phoenix_NPR_Volume__c nprvol7 = new Phoenix_NPR_Volume__c();
        nprvol7.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol7.Phoenix_Date__c=  date.newInstance(2022, 05, 01);
       
       nprvol7.Phoenix_Volume__c=23.00;
    insert nprvol7;
     
        Phoenix_NPR_Volume__c nprvol8 = new Phoenix_NPR_Volume__c();
        nprvol8.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol8.Phoenix_Date__c=  date.newInstance(2022, 06, 01);
       
       nprvol8.Phoenix_Volume__c=23.00;
    insert nprvol8;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol9 = new Phoenix_NPR_Volume__c();
        nprvol9.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol9.Phoenix_Date__c=  date.newInstance(2022, 04, 01);
       
       nprvol9.Phoenix_Volume__c=23.00;
    insert nprvol9;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol10 = new Phoenix_NPR_Volume__c();
        nprvol10.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol10.Phoenix_Date__c=  date.newInstance(2022, 03, 01);
       
       nprvol10.Phoenix_Volume__c=23.00;
    insert nprvol10;
    
   // Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
    
         //Vision_Customer_Product_Tracker__c cusPrdTrk = new Vision_Customer_Product_Tracker__c();
      //  insert cusPrdTrk;
  

  Compliance_Data__c ct= new Compliance_Data__c();
        ct.Vision_Product__c=p.id;
        ct.Awarded_Information__c=23;
        ct.Contract_Number__c='1234';
        ct.Month1__c='Oct-22';
         ct.Month2__c='Sep-22';
         ct.Month3__c='Aug-22';
         ct.Month4__c='Jul-22';
         ct.Month5__c='Jun-22';
         ct.Month6__c='May-22';
         ct.Month7__c='Apr-22';
        ct.M1_Quantity__c=1;
        ct.M2_Quantity__c=2;
        ct.M3_Quantity__c=3;
        ct.M4_Quantity__c=4;
        ct.M5_Quantity__c=5;
        ct.M6_Quantity__c=6;
        ct.M7_Quantity__c=7;
        
        ct.Vision_Unique_Identifier__c='1234-123566';
        insert ct;

    
      test.startTest();
        ComplianceRecordsNprData b= new ComplianceRecordsNprData();
        database.executeBatch(b);
        test.stopTest();
        
          //nprvol.Phoenix_Customer__c=a.id;
          //nprvol.Phoenix_Product__c=p.id;
          
    }
    static testmethod void setup56(){
        account a = new account();
         a.name='test';
         a.accountnumber='123454';
    insert a;
    
     list<Product2> plist = new list<Product2>();
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.OTC_Customer__c=a.id;
        p.IsActive=true;
        p.Phoenix_Is_Exclude_Bid__c=false;
        p.Vision_Is_CPT_Batch_Executed__c=false;
        p.Phoenix_Is_Private_Label_OTC__c=true;
        p.Phoenix_NDC_11__c='23364347';
       // p.ProductCode='123567';
        // p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='123566';
        //p.Phoenix_Product_Director__c=u.id;
      p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        plist.add(p);
   
    insert plist;
     Phoenix_Contract__c ctr = new Phoenix_Contract__c();
       ctr.Name = 'Test Contract';
        ctr.Phoenix_Customer__c = a.Id;
        ctr.Phoenix_Contract_Number__c='1234';
        ctr.Phoenix_Contract_Start_Date__c=system.today();
        ctr.Phoenix_Contract_End_Date__c=date.newInstance(2023, 12, 23);
    
        
        
        //ctr.Phoenix_Contract_Status__c='Active';
        insert ctr;
       
     Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
          //  cpt1.Vision_Account__c=acc.Id;
            cpt1.Vision_Contract__c=ctr.Id;
          //  cpt1.Vision_Contract_Product_Status__c='In Opportunity';
          //  cpt1.Vision_Product__c=p1.Id;
            cpt1.Vision_Product_Code__c='123566';
            cpt1.Vision_Contract_Number__c='1234';
            cpt1.Vision_Customer_Code__c='123456';
    cpt1.Vision_Is_In_Awarded__c=true;
            //cpt1.Vision_Price_Effective_Date__c=2022-07-19;
          // cpt1.Vision_Internal_Unique_Identifier__c='-300036391';
          //cpt1.Compliance_Unique_Identifier__c='3000001841-300036391';
          cpt1.General_Category__c='Primary';
         cpt1.Vision_Awarded_Value__c=23;
    cpt1.Vision_Awarded_Volume__c=23.0;
    cpt1.Vision_Current_Product_Position__c ='Multi-Award';
    
      
            
           
        //    cpt1.Bid_Line_Item__c=bdl.id;
            
            
            insert cpt1;
    Vision_GCP_Backorder_OTC__c bt= new Vision_GCP_Backorder_OTC__c();
    bt.Vision_Sku_Code__c='123566';
    bt.Vision_Backorder_Report_Date__c='2022-10-13';
    insert bt;
    Vision_GCP_Backorder_SRx_Rx__c srrx= new Vision_GCP_Backorder_SRx_Rx__c();
       srrx.Vision_MoH__c=23;
      srrx.Vision_SKU_Code__c='123566';
    srrx.Vision_On_Backorder__c='true';
      insert srrx;
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c = ctr.Id;
       npr.Phoenix_Contract_Number__c='1234';
        npr.Phoenix_Product__c=p.Id;
        npr.Phoenix_Add_ABS_Value__c = 2.00;
    npr.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr.Phoenix_12Months_Net_Sales__c=22.0;
    npr.Phoenix_Account__c=a.id;
    npr.Phoenix_Contract_Type__c='Indirect';
    npr.Phoenix_NPR_Status__c='Active';
   
   npr.Phoenix_Material_Number__c='123566';
        insert npr;
     Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr1.Phoenix_Contract__c = ctr.Id;
       npr1.Phoenix_Contract_Number__c='12346';
        npr1.Phoenix_Product__c=p.Id;
        npr1.Phoenix_Add_ABS_Value__c = 2.00;
    npr1.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr1.Phoenix_12Months_Net_Sales__c=22.0;
    npr1.Phoenix_Account__c=a.id;
    npr1.Phoenix_Contract_Type__c='Indirect';
    npr1.Phoenix_NPR_Status__c='Active';
   
   npr1.Phoenix_Material_Number__c='123566';
        insert npr1;
     Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr2.Phoenix_Contract__c = ctr.Id;
       npr2.Phoenix_Contract_Number__c='12345';
        npr2.Phoenix_Product__c=p.Id;
        npr2.Phoenix_Add_ABS_Value__c = 2.00;
    npr2.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr2.Phoenix_12Months_Net_Sales__c=22.0;
    npr2.Phoenix_Account__c=a.id;
    npr2.Phoenix_Contract_Type__c='Indirect';
    npr2.Phoenix_NPR_Status__c='Active';
   
   npr2.Phoenix_Material_Number__c='123566';
        insert npr2;
    list<Phoenix_NPR_Data__c> npr1ist=[select id,Phoenix_Contract__c,Phoenix_Contract_Number__c,Phoenix_Product__c,Phoenix_Add_ABS_Value__c,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_12Months_Net_Sales__c,Phoenix_Account__c,Phoenix_Contract_Type__c,Phoenix_NPR_Status__c,Phoenix_Material_Number__c from Phoenix_NPR_Data__c limit 10000];
    system.debug('nprlist....'+npr1ist.size());
    
       // Phoenix_NPR_Volume__c l1=[select Id,Phoenix_NPR_Data__r.Phoenix_Contract_Number__c,Phoenix_NPR_Data__r.Phoenix_Material_Number__c,Phoenix_NPR_Data__r.Phoenix_Contract_Type__c,Phoenix_NPR_Data__r.Phoenix_12Mt_Sales_Ut_Actual__c,Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC__c,Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_NPR_Data__r.Phoenix_Account__r.Accountnumber,Phoenix_NPR_Data__r.Phoenix_Account__c,Phoenix_NPR_Data__r.Phoenix_Contract__c,Phoenix_NPR_Data__r.Phoenix_Product__c,Phoenix_Month__c,Phoenix_Volume__c  from Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__r.Phoenix_NPR_Status__c=:'active' limit 1];
    Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol = new Phoenix_NPR_Volume__c();
        nprvol.Phoenix_NPR_Data__c=npr.id;
   nprvol.Phoenix_Date__c=  date.newInstance(2022, 07, 01);
       
       nprvol.Phoenix_Volume__c=23.00;
    insert nprvol;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol4 = new Phoenix_NPR_Volume__c();
        nprvol4.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol4.Phoenix_Date__c=  date.newInstance(2022, 09, 01);
       
       nprvol4.Phoenix_Volume__c=23.00;
    insert nprvol4;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol5 = new Phoenix_NPR_Volume__c();
        nprvol5.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol5.Phoenix_Date__c=  date.newInstance(2022, 08, 01);
       
       nprvol5.Phoenix_Volume__c=23.00;
    insert nprvol5;
   //  Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol6 = new Phoenix_NPR_Volume__c();
        nprvol6.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol6.Phoenix_Date__c=  date.newInstance(2022, 07, 01);
       
       nprvol6.Phoenix_Volume__c=23.00;
    insert nprvol6;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
       Phoenix_NPR_Volume__c nprvol7 = new Phoenix_NPR_Volume__c();
        nprvol7.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol7.Phoenix_Date__c=  date.newInstance(2022, 05, 01);
       
       nprvol7.Phoenix_Volume__c=23.00;
    insert nprvol7;
     
        Phoenix_NPR_Volume__c nprvol8 = new Phoenix_NPR_Volume__c();
        nprvol8.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol8.Phoenix_Date__c=  date.newInstance(2022, 06, 01);
       
       nprvol8.Phoenix_Volume__c=23.00;
    insert nprvol8;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol9 = new Phoenix_NPR_Volume__c();
        nprvol9.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol9.Phoenix_Date__c=  date.newInstance(2022, 04, 01);
       
       nprvol9.Phoenix_Volume__c=23.00;
    insert nprvol9;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol10 = new Phoenix_NPR_Volume__c();
        nprvol10.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol10.Phoenix_Date__c=  date.newInstance(2022, 03, 01);
       
       nprvol10.Phoenix_Volume__c=23.00;
    insert nprvol10;
    
   // Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
    
         //Vision_Customer_Product_Tracker__c cusPrdTrk = new Vision_Customer_Product_Tracker__c();
      //  insert cusPrdTrk;
  

 
    
      test.startTest();
        ComplianceRecordsNprData b= new ComplianceRecordsNprData();
        database.executeBatch(b);
        test.stopTest();
        
    }
    static testmethod void setup3484(){
        account a = new account();
         a.name='test';
         a.accountnumber='123454';
    insert a;
    
     list<Product2> plist = new list<Product2>();
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.OTC_Customer__c=a.id;
        p.IsActive=true;
        p.Phoenix_Is_Exclude_Bid__c=false;
        p.Vision_Is_CPT_Batch_Executed__c=false;
        p.Phoenix_Is_Private_Label_OTC__c=true;
        p.Phoenix_NDC_11__c='23364347';
       // p.ProductCode='123567';
        // p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='123566';
        //p.Phoenix_Product_Director__c=u.id;
      p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        plist.add(p);
   
    insert plist;
     Phoenix_Contract__c ctr = new Phoenix_Contract__c();
       ctr.Name = 'Test Contract';
        ctr.Phoenix_Customer__c = a.Id;
        ctr.Phoenix_Contract_Number__c='1234';
        ctr.Phoenix_Contract_Start_Date__c=system.today();
        ctr.Phoenix_Contract_End_Date__c=date.newInstance(2023, 12, 23);
    
        
        
        //ctr.Phoenix_Contract_Status__c='Active';
        insert ctr;
       
     Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
          //  cpt1.Vision_Account__c=acc.Id;
            cpt1.Vision_Contract__c=ctr.Id;
          //  cpt1.Vision_Contract_Product_Status__c='In Opportunity';
          //  cpt1.Vision_Product__c=p1.Id;
            cpt1.Vision_Product_Code__c='123566';
            cpt1.Vision_Contract_Number__c='1234';
            cpt1.Vision_Customer_Code__c='123456';
    cpt1.Vision_Is_In_Awarded__c=true;
            //cpt1.Vision_Price_Effective_Date__c=2022-07-19;
          // cpt1.Vision_Internal_Unique_Identifier__c='-300036391';
          //cpt1.Compliance_Unique_Identifier__c='3000001841-300036391';
          cpt1.General_Category__c='Primary';
         cpt1.Vision_Awarded_Value__c=23;
    cpt1.Vision_Awarded_Volume__c=23.0;
    cpt1.Vision_Current_Product_Position__c ='Multi-Award';
    
      
            
           
        //    cpt1.Bid_Line_Item__c=bdl.id;
            
            
            insert cpt1;
    Vision_GCP_Backorder_OTC__c bt= new Vision_GCP_Backorder_OTC__c();
    bt.Vision_Sku_Code__c='123566';
    bt.Vision_Backorder_Report_Date__c='2022-10-13';
    insert bt;
    Vision_GCP_Backorder_SRx_Rx__c srrx= new Vision_GCP_Backorder_SRx_Rx__c();
       srrx.Vision_MoH__c=23;
      srrx.Vision_SKU_Code__c='123566';
    srrx.Vision_On_Backorder__c='true';
      insert srrx;
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c = ctr.Id;
       npr.Phoenix_Contract_Number__c='1234';
        npr.Phoenix_Product__c=p.Id;
        npr.Phoenix_Add_ABS_Value__c = 2.00;
    npr.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr.Phoenix_12Months_Net_Sales__c=22.0;
    npr.Phoenix_Account__c=a.id;
    npr.Phoenix_Contract_Type__c='Indirect';
    npr.Phoenix_NPR_Status__c='Active';
   
   npr.Phoenix_Material_Number__c='123566';
        insert npr;
     Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr1.Phoenix_Contract__c = ctr.Id;
       npr1.Phoenix_Contract_Number__c='12346';
        npr1.Phoenix_Product__c=p.Id;
        npr1.Phoenix_Add_ABS_Value__c = 2.00;
    npr1.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr1.Phoenix_12Months_Net_Sales__c=22.0;
    npr1.Phoenix_Account__c=a.id;
    npr1.Phoenix_Contract_Type__c='Indirect';
    npr1.Phoenix_NPR_Status__c='Active';
   
   npr1.Phoenix_Material_Number__c='123566';
        insert npr1;
     Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr2.Phoenix_Contract__c = ctr.Id;
       npr2.Phoenix_Contract_Number__c='12345';
        npr2.Phoenix_Product__c=p.Id;
        npr2.Phoenix_Add_ABS_Value__c = 2.00;
    npr2.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr2.Phoenix_12Months_Net_Sales__c=22.0;
    npr2.Phoenix_Account__c=a.id;
    npr2.Phoenix_Contract_Type__c='Indirect';
    npr2.Phoenix_NPR_Status__c='Active';
   
   npr2.Phoenix_Material_Number__c='123566';
        insert npr2;
    list<Phoenix_NPR_Data__c> npr1ist=[select id,Phoenix_Contract__c,Phoenix_Contract_Number__c,Phoenix_Product__c,Phoenix_Add_ABS_Value__c,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_12Months_Net_Sales__c,Phoenix_Account__c,Phoenix_Contract_Type__c,Phoenix_NPR_Status__c,Phoenix_Material_Number__c from Phoenix_NPR_Data__c limit 10000];
    system.debug('nprlist....'+npr1ist.size());
    
       // Phoenix_NPR_Volume__c l1=[select Id,Phoenix_NPR_Data__r.Phoenix_Contract_Number__c,Phoenix_NPR_Data__r.Phoenix_Material_Number__c,Phoenix_NPR_Data__r.Phoenix_Contract_Type__c,Phoenix_NPR_Data__r.Phoenix_12Mt_Sales_Ut_Actual__c,Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC__c,Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_NPR_Data__r.Phoenix_Account__r.Accountnumber,Phoenix_NPR_Data__r.Phoenix_Account__c,Phoenix_NPR_Data__r.Phoenix_Contract__c,Phoenix_NPR_Data__r.Phoenix_Product__c,Phoenix_Month__c,Phoenix_Volume__c  from Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__r.Phoenix_NPR_Status__c=:'active' limit 1];
    Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol = new Phoenix_NPR_Volume__c();
        nprvol.Phoenix_NPR_Data__c=npr.id;
   nprvol.Phoenix_Date__c=  date.newInstance(2022, 07, 01);
       
       nprvol.Phoenix_Volume__c=23.00;
    insert nprvol;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol4 = new Phoenix_NPR_Volume__c();
        nprvol4.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol4.Phoenix_Date__c=  date.newInstance(2022, 09, 01);
       
       nprvol4.Phoenix_Volume__c=23.00;
    insert nprvol4;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol5 = new Phoenix_NPR_Volume__c();
        nprvol5.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol5.Phoenix_Date__c=  date.newInstance(2022, 08, 01);
       
       nprvol5.Phoenix_Volume__c=23.00;
    insert nprvol5;
   //  Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol6 = new Phoenix_NPR_Volume__c();
        nprvol6.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol6.Phoenix_Date__c=  date.newInstance(2022, 07, 01);
       
       nprvol6.Phoenix_Volume__c=23.00;
    insert nprvol6;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
       Phoenix_NPR_Volume__c nprvol7 = new Phoenix_NPR_Volume__c();
        nprvol7.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol7.Phoenix_Date__c=  date.newInstance(2022, 05, 01);
       
       nprvol7.Phoenix_Volume__c=23.00;
    insert nprvol7;
     
        Phoenix_NPR_Volume__c nprvol8 = new Phoenix_NPR_Volume__c();
        nprvol8.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol8.Phoenix_Date__c=  date.newInstance(2022, 06, 01);
       
       nprvol8.Phoenix_Volume__c=23.00;
    insert nprvol8;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol9 = new Phoenix_NPR_Volume__c();
        nprvol9.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol9.Phoenix_Date__c=  date.newInstance(2022, 04, 01);
       
       nprvol9.Phoenix_Volume__c=23.00;
    insert nprvol9;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol10 = new Phoenix_NPR_Volume__c();
        nprvol10.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol10.Phoenix_Date__c=  date.newInstance(2022, 03, 01);
       
       nprvol10.Phoenix_Volume__c=23.00;
    insert nprvol10;
    
   // Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
    
         //Vision_Customer_Product_Tracker__c cusPrdTrk = new Vision_Customer_Product_Tracker__c();
      //  insert cusPrdTrk;
  
 Compliance_Data__c ct= new Compliance_Data__c();
        ct.Vision_Product__c=p.id;
        ct.Awarded_Information__c=23;
        ct.Contract_Number__c='1234';
        ct.Month1__c='Oct-22';
         ct.Month2__c='Sep-22';
         ct.Month3__c='Aug-22';
         ct.Month4__c='Jul-22';
         ct.Month5__c='Jun-22';
         ct.Month6__c='May-22';
         ct.Month7__c='Apr-22';
        ct.M1_Quantity__c=1;
        ct.M2_Quantity__c=2;
        ct.M3_Quantity__c=3;
        ct.M4_Quantity__c=4;
        ct.M5_Quantity__c=5;
        ct.M6_Quantity__c=6;
        ct.M7_Quantity__c=7;
        
        ct.Vision_Unique_Identifier__c='1234-123566';
        insert ct;



    
      test.startTest();
        ComplianceRecordsNprData b= new ComplianceRecordsNprData();
        database.executeBatch(b);
        test.stopTest();
    }
    static testmethod void setup78(){
        account a = new account();
         a.name='test';
         a.accountnumber='123454';
    insert a;
    
     list<Product2> plist = new list<Product2>();
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.OTC_Customer__c=a.id;
        p.IsActive=true;
        p.Phoenix_Is_Exclude_Bid__c=false;
        p.Vision_Is_CPT_Batch_Executed__c=false;
        p.Phoenix_Is_Private_Label_OTC__c=true;
        p.Phoenix_NDC_11__c='23364347';
       // p.ProductCode='123567';
        // p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='123566';
        //p.Phoenix_Product_Director__c=u.id;
      p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        plist.add(p);
   
    insert plist;
     Phoenix_Contract__c ctr = new Phoenix_Contract__c();
       ctr.Name = 'Test Contract';
        ctr.Phoenix_Customer__c = a.Id;
        ctr.Phoenix_Contract_Number__c='1234';
        ctr.Phoenix_Contract_Start_Date__c=system.today();
        ctr.Phoenix_Contract_End_Date__c=date.newInstance(2023, 12, 23);
    
        
        
        //ctr.Phoenix_Contract_Status__c='Active';
        insert ctr;
       
     Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
          //  cpt1.Vision_Account__c=acc.Id;
            cpt1.Vision_Contract__c=ctr.Id;
          //  cpt1.Vision_Contract_Product_Status__c='In Opportunity';
          //  cpt1.Vision_Product__c=p1.Id;
            cpt1.Vision_Product_Code__c='123566';
            cpt1.Vision_Contract_Number__c='1234';
            cpt1.Vision_Customer_Code__c='123456';
    cpt1.Vision_Is_In_Awarded__c=true;
            //cpt1.Vision_Price_Effective_Date__c=2022-07-19;
          // cpt1.Vision_Internal_Unique_Identifier__c='-300036391';
          //cpt1.Compliance_Unique_Identifier__c='3000001841-300036391';
          cpt1.General_Category__c='Primary';
         cpt1.Vision_Awarded_Value__c=23;
    cpt1.Vision_Awarded_Volume__c=23.0;
    cpt1.Vision_Current_Product_Position__c ='Multi-Award';
    
      
            
           
        //    cpt1.Bid_Line_Item__c=bdl.id;
            
            
            insert cpt1;
    Vision_GCP_Backorder_OTC__c bt= new Vision_GCP_Backorder_OTC__c();
    bt.Vision_Sku_Code__c='123566';
    bt.Vision_Backorder_Report_Date__c='2022-10-13';
    insert bt;
    Vision_GCP_Backorder_SRx_Rx__c srrx= new Vision_GCP_Backorder_SRx_Rx__c();
       srrx.Vision_MoH__c=23;
      srrx.Vision_SKU_Code__c='123566';
    srrx.Vision_On_Backorder__c='true';
      insert srrx;
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c = ctr.Id;
       npr.Phoenix_Contract_Number__c='1234';
        npr.Phoenix_Product__c=p.Id;
        npr.Phoenix_Add_ABS_Value__c = 2.00;
    npr.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr.Phoenix_12Months_Net_Sales__c=22.0;
    npr.Phoenix_Account__c=a.id;
    npr.Phoenix_Contract_Type__c='Indirect';
    npr.Phoenix_NPR_Status__c='Active';
   
   npr.Phoenix_Material_Number__c='123566';
        insert npr;
     Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr1.Phoenix_Contract__c = ctr.Id;
       npr1.Phoenix_Contract_Number__c='12346';
        npr1.Phoenix_Product__c=p.Id;
        npr1.Phoenix_Add_ABS_Value__c = 2.00;
    npr1.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr1.Phoenix_12Months_Net_Sales__c=22.0;
    npr1.Phoenix_Account__c=a.id;
    npr1.Phoenix_Contract_Type__c='Indirect';
    npr1.Phoenix_NPR_Status__c='Active';
   
   npr1.Phoenix_Material_Number__c='123566';
        insert npr1;
     Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr2.Phoenix_Contract__c = ctr.Id;
       npr2.Phoenix_Contract_Number__c='12345';
        npr2.Phoenix_Product__c=p.Id;
        npr2.Phoenix_Add_ABS_Value__c = 2.00;
    npr2.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr2.Phoenix_12Months_Net_Sales__c=22.0;
    npr2.Phoenix_Account__c=a.id;
    npr2.Phoenix_Contract_Type__c='Indirect';
    npr2.Phoenix_NPR_Status__c='Active';
   
   npr2.Phoenix_Material_Number__c='123566';
        insert npr2;
    list<Phoenix_NPR_Data__c> npr1ist=[select id,Phoenix_Contract__c,Phoenix_Contract_Number__c,Phoenix_Product__c,Phoenix_Add_ABS_Value__c,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_12Months_Net_Sales__c,Phoenix_Account__c,Phoenix_Contract_Type__c,Phoenix_NPR_Status__c,Phoenix_Material_Number__c from Phoenix_NPR_Data__c limit 10000];
    system.debug('nprlist....'+npr1ist.size());
    
       // Phoenix_NPR_Volume__c l1=[select Id,Phoenix_NPR_Data__r.Phoenix_Contract_Number__c,Phoenix_NPR_Data__r.Phoenix_Material_Number__c,Phoenix_NPR_Data__r.Phoenix_Contract_Type__c,Phoenix_NPR_Data__r.Phoenix_12Mt_Sales_Ut_Actual__c,Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC__c,Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_NPR_Data__r.Phoenix_Account__r.Accountnumber,Phoenix_NPR_Data__r.Phoenix_Account__c,Phoenix_NPR_Data__r.Phoenix_Contract__c,Phoenix_NPR_Data__r.Phoenix_Product__c,Phoenix_Month__c,Phoenix_Volume__c  from Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__r.Phoenix_NPR_Status__c=:'active' limit 1];
    Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol = new Phoenix_NPR_Volume__c();
        nprvol.Phoenix_NPR_Data__c=npr.id;
   nprvol.Phoenix_Date__c=  date.newInstance(2022, 05, 01);
       
       nprvol.Phoenix_Volume__c=23.00;
    insert nprvol;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol4 = new Phoenix_NPR_Volume__c();
        nprvol4.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol4.Phoenix_Date__c=  date.newInstance(2022, 09, 01);
       
       nprvol4.Phoenix_Volume__c=23.00;
    insert nprvol4;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol5 = new Phoenix_NPR_Volume__c();
        nprvol5.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol5.Phoenix_Date__c=  date.newInstance(2022, 08, 01);
       
       nprvol5.Phoenix_Volume__c=23.00;
    insert nprvol5;
   //  Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol6 = new Phoenix_NPR_Volume__c();
        nprvol6.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol6.Phoenix_Date__c=  date.newInstance(2022, 07, 01);
       
       nprvol6.Phoenix_Volume__c=23.00;
    insert nprvol6;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
       Phoenix_NPR_Volume__c nprvol7 = new Phoenix_NPR_Volume__c();
        nprvol7.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol7.Phoenix_Date__c=  date.newInstance(2022, 05, 01);
       
       nprvol7.Phoenix_Volume__c=23.00;
    insert nprvol7;
     
        Phoenix_NPR_Volume__c nprvol8 = new Phoenix_NPR_Volume__c();
        nprvol8.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol8.Phoenix_Date__c=  date.newInstance(2022, 06, 01);
       
       nprvol8.Phoenix_Volume__c=23.00;
    insert nprvol8;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol9 = new Phoenix_NPR_Volume__c();
        nprvol9.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol9.Phoenix_Date__c=  date.newInstance(2022, 04, 01);
       
       nprvol9.Phoenix_Volume__c=23.00;
    insert nprvol9;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol10 = new Phoenix_NPR_Volume__c();
        nprvol10.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol10.Phoenix_Date__c=  date.newInstance(2022, 03, 01);
       
       nprvol10.Phoenix_Volume__c=23.00;
    insert nprvol10;
    
   // Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
    
         //Vision_Customer_Product_Tracker__c cusPrdTrk = new Vision_Customer_Product_Tracker__c();
      //  insert cusPrdTrk;
   

  

    
      test.startTest();
        ComplianceRecordsNprData b= new ComplianceRecordsNprData();
        database.executeBatch(b);
        test.stopTest();
    }
    static testmethod void setuperwe(){
        account a = new account();
         a.name='test';
         a.accountnumber='123454';
    insert a;
    
     list<Product2> plist = new list<Product2>();
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.OTC_Customer__c=a.id;
        p.IsActive=true;
        p.Phoenix_Is_Exclude_Bid__c=false;
        p.Vision_Is_CPT_Batch_Executed__c=false;
        p.Phoenix_Is_Private_Label_OTC__c=true;
        p.Phoenix_NDC_11__c='23364347';
       // p.ProductCode='123567';
        // p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='123566';
        //p.Phoenix_Product_Director__c=u.id;
      p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        plist.add(p);
   
    insert plist;
     Phoenix_Contract__c ctr = new Phoenix_Contract__c();
       ctr.Name = 'Test Contract';
        ctr.Phoenix_Customer__c = a.Id;
        ctr.Phoenix_Contract_Number__c='1234';
        ctr.Phoenix_Contract_Start_Date__c=system.today();
        ctr.Phoenix_Contract_End_Date__c=date.newInstance(2023, 12, 23);
    
        
        
        //ctr.Phoenix_Contract_Status__c='Active';
        insert ctr;
       
     Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
          //  cpt1.Vision_Account__c=acc.Id;
            cpt1.Vision_Contract__c=ctr.Id;
          //  cpt1.Vision_Contract_Product_Status__c='In Opportunity';
          //  cpt1.Vision_Product__c=p1.Id;
            cpt1.Vision_Product_Code__c='123566';
            cpt1.Vision_Contract_Number__c='1234';
            cpt1.Vision_Customer_Code__c='123456';
    cpt1.Vision_Is_In_Awarded__c=true;
            //cpt1.Vision_Price_Effective_Date__c=2022-07-19;
          // cpt1.Vision_Internal_Unique_Identifier__c='-300036391';
          //cpt1.Compliance_Unique_Identifier__c='3000001841-300036391';
          cpt1.General_Category__c='Primary';
         cpt1.Vision_Awarded_Value__c=23;
    cpt1.Vision_Awarded_Volume__c=23.0;
    cpt1.Vision_Current_Product_Position__c ='Multi-Award';
    
      
            
           
        //    cpt1.Bid_Line_Item__c=bdl.id;
            
            
            insert cpt1;
    Vision_GCP_Backorder_OTC__c bt= new Vision_GCP_Backorder_OTC__c();
    bt.Vision_Sku_Code__c='123566';
    bt.Vision_Backorder_Report_Date__c='2022-10-13';
    insert bt;
    Vision_GCP_Backorder_SRx_Rx__c srrx= new Vision_GCP_Backorder_SRx_Rx__c();
       srrx.Vision_MoH__c=23;
      srrx.Vision_SKU_Code__c='123566';
    srrx.Vision_On_Backorder__c='true';
      insert srrx;
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c = ctr.Id;
       npr.Phoenix_Contract_Number__c='1234';
        npr.Phoenix_Product__c=p.Id;
        npr.Phoenix_Add_ABS_Value__c = 2.00;
    npr.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr.Phoenix_12Months_Net_Sales__c=22.0;
    npr.Phoenix_Account__c=a.id;
    npr.Phoenix_Contract_Type__c='Indirect';
    npr.Phoenix_NPR_Status__c='Active';
   
   npr.Phoenix_Material_Number__c='123566';
        insert npr;
     Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr1.Phoenix_Contract__c = ctr.Id;
       npr1.Phoenix_Contract_Number__c='12346';
        npr1.Phoenix_Product__c=p.Id;
        npr1.Phoenix_Add_ABS_Value__c = 2.00;
    npr1.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr1.Phoenix_12Months_Net_Sales__c=22.0;
    npr1.Phoenix_Account__c=a.id;
    npr1.Phoenix_Contract_Type__c='Indirect';
    npr1.Phoenix_NPR_Status__c='Active';
   
   npr1.Phoenix_Material_Number__c='123566';
        insert npr1;
     Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr2.Phoenix_Contract__c = ctr.Id;
       npr2.Phoenix_Contract_Number__c='12345';
        npr2.Phoenix_Product__c=p.Id;
        npr2.Phoenix_Add_ABS_Value__c = 2.00;
    npr2.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr2.Phoenix_12Months_Net_Sales__c=22.0;
    npr2.Phoenix_Account__c=a.id;
    npr2.Phoenix_Contract_Type__c='Indirect';
    npr2.Phoenix_NPR_Status__c='Active';
   
   npr2.Phoenix_Material_Number__c='123566';
        insert npr2;
    list<Phoenix_NPR_Data__c> npr1ist=[select id,Phoenix_Contract__c,Phoenix_Contract_Number__c,Phoenix_Product__c,Phoenix_Add_ABS_Value__c,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_12Months_Net_Sales__c,Phoenix_Account__c,Phoenix_Contract_Type__c,Phoenix_NPR_Status__c,Phoenix_Material_Number__c from Phoenix_NPR_Data__c limit 10000];
    system.debug('nprlist....'+npr1ist.size());
    
       // Phoenix_NPR_Volume__c l1=[select Id,Phoenix_NPR_Data__r.Phoenix_Contract_Number__c,Phoenix_NPR_Data__r.Phoenix_Material_Number__c,Phoenix_NPR_Data__r.Phoenix_Contract_Type__c,Phoenix_NPR_Data__r.Phoenix_12Mt_Sales_Ut_Actual__c,Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC__c,Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_NPR_Data__r.Phoenix_Account__r.Accountnumber,Phoenix_NPR_Data__r.Phoenix_Account__c,Phoenix_NPR_Data__r.Phoenix_Contract__c,Phoenix_NPR_Data__r.Phoenix_Product__c,Phoenix_Month__c,Phoenix_Volume__c  from Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__r.Phoenix_NPR_Status__c=:'active' limit 1];
    Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol = new Phoenix_NPR_Volume__c();
        nprvol.Phoenix_NPR_Data__c=npr.id;
   nprvol.Phoenix_Date__c=  date.newInstance(2022, 04, 01);
       
       nprvol.Phoenix_Volume__c=23.00;
    insert nprvol;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol4 = new Phoenix_NPR_Volume__c();
        nprvol4.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol4.Phoenix_Date__c=  date.newInstance(2022, 09, 01);
       
       nprvol4.Phoenix_Volume__c=23.00;
    insert nprvol4;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol5 = new Phoenix_NPR_Volume__c();
        nprvol5.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol5.Phoenix_Date__c=  date.newInstance(2022, 08, 01);
       
       nprvol5.Phoenix_Volume__c=23.00;
    insert nprvol5;
   //  Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol6 = new Phoenix_NPR_Volume__c();
        nprvol6.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol6.Phoenix_Date__c=  date.newInstance(2022, 07, 01);
       
       nprvol6.Phoenix_Volume__c=23.00;
    insert nprvol6;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
       Phoenix_NPR_Volume__c nprvol7 = new Phoenix_NPR_Volume__c();
        nprvol7.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol7.Phoenix_Date__c=  date.newInstance(2022, 05, 01);
       
       nprvol7.Phoenix_Volume__c=23.00;
    insert nprvol7;
     
        Phoenix_NPR_Volume__c nprvol8 = new Phoenix_NPR_Volume__c();
        nprvol8.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol8.Phoenix_Date__c=  date.newInstance(2022, 06, 01);
       
       nprvol8.Phoenix_Volume__c=23.00;
    insert nprvol8;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol9 = new Phoenix_NPR_Volume__c();
        nprvol9.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol9.Phoenix_Date__c=  date.newInstance(2022, 04, 01);
       
       nprvol9.Phoenix_Volume__c=23.00;
    insert nprvol9;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol10 = new Phoenix_NPR_Volume__c();
        nprvol10.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol10.Phoenix_Date__c=  date.newInstance(2022, 03, 01);
       
       nprvol10.Phoenix_Volume__c=23.00;
    insert nprvol10;
    
   // Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
    
         //Vision_Customer_Product_Tracker__c cusPrdTrk = new Vision_Customer_Product_Tracker__c();
      //  insert cusPrdTrk;
   

  

    
      test.startTest();
        ComplianceRecordsNprData b= new ComplianceRecordsNprData();
        database.executeBatch(b);
        test.stopTest();
    }
    static testmethod void setuper23rf(){
        account a = new account();
         a.name='test';
         a.accountnumber='123454';
    insert a;
    
     list<Product2> plist = new list<Product2>();
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.OTC_Customer__c=a.id;
        p.IsActive=true;
        p.Phoenix_Is_Exclude_Bid__c=false;
        p.Vision_Is_CPT_Batch_Executed__c=false;
        p.Phoenix_Is_Private_Label_OTC__c=true;
        p.Phoenix_NDC_11__c='23364347';
       // p.ProductCode='123567';
        // p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='123566';
        //p.Phoenix_Product_Director__c=u.id;
      p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        plist.add(p);
   
    insert plist;
     Phoenix_Contract__c ctr = new Phoenix_Contract__c();
       ctr.Name = 'Test Contract';
        ctr.Phoenix_Customer__c = a.Id;
        ctr.Phoenix_Contract_Number__c='1234';
        ctr.Phoenix_Contract_Start_Date__c=system.today();
        ctr.Phoenix_Contract_End_Date__c=date.newInstance(2023, 12, 23);
    
        
        
        //ctr.Phoenix_Contract_Status__c='Active';
        insert ctr;
       
     Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
          //  cpt1.Vision_Account__c=acc.Id;
            cpt1.Vision_Contract__c=ctr.Id;
          //  cpt1.Vision_Contract_Product_Status__c='In Opportunity';
          //  cpt1.Vision_Product__c=p1.Id;
            cpt1.Vision_Product_Code__c='123566';
            cpt1.Vision_Contract_Number__c='1234';
            cpt1.Vision_Customer_Code__c='123456';
    cpt1.Vision_Is_In_Awarded__c=true;
            //cpt1.Vision_Price_Effective_Date__c=2022-07-19;
          // cpt1.Vision_Internal_Unique_Identifier__c='-300036391';
          //cpt1.Compliance_Unique_Identifier__c='3000001841-300036391';
          cpt1.General_Category__c='Primary';
         cpt1.Vision_Awarded_Value__c=23;
    cpt1.Vision_Awarded_Volume__c=23.0;
    cpt1.Vision_Current_Product_Position__c ='Multi-Award';
    
      
            
           
        //    cpt1.Bid_Line_Item__c=bdl.id;
            
            
            insert cpt1;
    Vision_GCP_Backorder_OTC__c bt= new Vision_GCP_Backorder_OTC__c();
    bt.Vision_Sku_Code__c='123566';
    bt.Vision_Backorder_Report_Date__c='2022-10-13';
    insert bt;
    Vision_GCP_Backorder_SRx_Rx__c srrx= new Vision_GCP_Backorder_SRx_Rx__c();
       srrx.Vision_MoH__c=23;
      srrx.Vision_SKU_Code__c='123566';
    srrx.Vision_On_Backorder__c='true';
      insert srrx;
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c = ctr.Id;
       npr.Phoenix_Contract_Number__c='1234';
        npr.Phoenix_Product__c=p.Id;
        npr.Phoenix_Add_ABS_Value__c = 2.00;
    npr.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr.Phoenix_12Months_Net_Sales__c=22.0;
    npr.Phoenix_Account__c=a.id;
    npr.Phoenix_Contract_Type__c='Indirect';
    npr.Phoenix_NPR_Status__c='Active';
   
   npr.Phoenix_Material_Number__c='123566';
        insert npr;
     Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr1.Phoenix_Contract__c = ctr.Id;
       npr1.Phoenix_Contract_Number__c='12346';
        npr1.Phoenix_Product__c=p.Id;
        npr1.Phoenix_Add_ABS_Value__c = 2.00;
    npr1.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr1.Phoenix_12Months_Net_Sales__c=22.0;
    npr1.Phoenix_Account__c=a.id;
    npr1.Phoenix_Contract_Type__c='Indirect';
    npr1.Phoenix_NPR_Status__c='Active';
   
   npr1.Phoenix_Material_Number__c='123566';
        insert npr1;
     Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr2.Phoenix_Contract__c = ctr.Id;
       npr2.Phoenix_Contract_Number__c='12345';
        npr2.Phoenix_Product__c=p.Id;
        npr2.Phoenix_Add_ABS_Value__c = 2.00;
    npr2.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr2.Phoenix_12Months_Net_Sales__c=22.0;
    npr2.Phoenix_Account__c=a.id;
    npr2.Phoenix_Contract_Type__c='Indirect';
    npr2.Phoenix_NPR_Status__c='Active';
   
   npr2.Phoenix_Material_Number__c='123566';
        insert npr2;
    list<Phoenix_NPR_Data__c> npr1ist=[select id,Phoenix_Contract__c,Phoenix_Contract_Number__c,Phoenix_Product__c,Phoenix_Add_ABS_Value__c,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_12Months_Net_Sales__c,Phoenix_Account__c,Phoenix_Contract_Type__c,Phoenix_NPR_Status__c,Phoenix_Material_Number__c from Phoenix_NPR_Data__c limit 10000];
    system.debug('nprlist....'+npr1ist.size());
    
       // Phoenix_NPR_Volume__c l1=[select Id,Phoenix_NPR_Data__r.Phoenix_Contract_Number__c,Phoenix_NPR_Data__r.Phoenix_Material_Number__c,Phoenix_NPR_Data__r.Phoenix_Contract_Type__c,Phoenix_NPR_Data__r.Phoenix_12Mt_Sales_Ut_Actual__c,Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC__c,Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_NPR_Data__r.Phoenix_Account__r.Accountnumber,Phoenix_NPR_Data__r.Phoenix_Account__c,Phoenix_NPR_Data__r.Phoenix_Contract__c,Phoenix_NPR_Data__r.Phoenix_Product__c,Phoenix_Month__c,Phoenix_Volume__c  from Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__r.Phoenix_NPR_Status__c=:'active' limit 1];
    Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol = new Phoenix_NPR_Volume__c();
        nprvol.Phoenix_NPR_Data__c=npr.id;
   nprvol.Phoenix_Date__c=  date.newInstance(2022, 06, 01);
       
       nprvol.Phoenix_Volume__c=23.00;
    insert nprvol;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol4 = new Phoenix_NPR_Volume__c();
        nprvol4.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol4.Phoenix_Date__c=  date.newInstance(2022, 09, 01);
       
       nprvol4.Phoenix_Volume__c=23.00;
    insert nprvol4;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol5 = new Phoenix_NPR_Volume__c();
        nprvol5.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol5.Phoenix_Date__c=  date.newInstance(2022, 08, 01);
       
       nprvol5.Phoenix_Volume__c=23.00;
    insert nprvol5;
   //  Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol6 = new Phoenix_NPR_Volume__c();
        nprvol6.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol6.Phoenix_Date__c=  date.newInstance(2022, 07, 01);
       
       nprvol6.Phoenix_Volume__c=23.00;
    insert nprvol6;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
       Phoenix_NPR_Volume__c nprvol7 = new Phoenix_NPR_Volume__c();
        nprvol7.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol7.Phoenix_Date__c=  date.newInstance(2022, 05, 01);
       
       nprvol7.Phoenix_Volume__c=23.00;
    insert nprvol7;
     
        Phoenix_NPR_Volume__c nprvol8 = new Phoenix_NPR_Volume__c();
        nprvol8.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol8.Phoenix_Date__c=  date.newInstance(2022, 06, 01);
       
       nprvol8.Phoenix_Volume__c=23.00;
    insert nprvol8;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol9 = new Phoenix_NPR_Volume__c();
        nprvol9.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol9.Phoenix_Date__c=  date.newInstance(2022, 04, 01);
       
       nprvol9.Phoenix_Volume__c=23.00;
    insert nprvol9;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol10 = new Phoenix_NPR_Volume__c();
        nprvol10.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol10.Phoenix_Date__c=  date.newInstance(2022, 03, 01);
       
       nprvol10.Phoenix_Volume__c=23.00;
    insert nprvol10;
    
   // Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
    
         //Vision_Customer_Product_Tracker__c cusPrdTrk = new Vision_Customer_Product_Tracker__c();
      //  insert cusPrdTrk;
   

  

    
      test.startTest();
        ComplianceRecordsNprData b= new ComplianceRecordsNprData();
        database.executeBatch(b);
        test.stopTest();
    }
    static testmethod void setup2435(){
        account a = new account();
         a.name='test';
         a.accountnumber='123454';
    insert a;
    
     list<Product2> plist = new list<Product2>();
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.OTC_Customer__c=a.id;
        p.IsActive=true;
        p.Phoenix_Is_Exclude_Bid__c=false;
        p.Vision_Is_CPT_Batch_Executed__c=false;
        p.Phoenix_Is_Private_Label_OTC__c=true;
        p.Phoenix_NDC_11__c='23364347';
       // p.ProductCode='123567';
        // p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='123566';
        //p.Phoenix_Product_Director__c=u.id;
      p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        plist.add(p);
   
    insert plist;
     Phoenix_Contract__c ctr = new Phoenix_Contract__c();
       ctr.Name = 'Test Contract';
        ctr.Phoenix_Customer__c = a.Id;
        ctr.Phoenix_Contract_Number__c='1234';
        ctr.Phoenix_Contract_Start_Date__c=system.today();
        ctr.Phoenix_Contract_End_Date__c=date.newInstance(2023, 12, 23);
    
        
        
        //ctr.Phoenix_Contract_Status__c='Active';
        insert ctr;
       
     Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
          //  cpt1.Vision_Account__c=acc.Id;
            cpt1.Vision_Contract__c=ctr.Id;
          //  cpt1.Vision_Contract_Product_Status__c='In Opportunity';
          //  cpt1.Vision_Product__c=p1.Id;
            cpt1.Vision_Product_Code__c='123566';
            cpt1.Vision_Contract_Number__c='1234';
            cpt1.Vision_Customer_Code__c='123456';
    cpt1.Vision_Is_In_Awarded__c=true;
            //cpt1.Vision_Price_Effective_Date__c=2022-07-19;
          // cpt1.Vision_Internal_Unique_Identifier__c='-300036391';
          //cpt1.Compliance_Unique_Identifier__c='3000001841-300036391';
          cpt1.General_Category__c='Primary';
         cpt1.Vision_Awarded_Value__c=23;
    cpt1.Vision_Awarded_Volume__c=23.0;
    cpt1.Vision_Current_Product_Position__c ='Multi-Award';
    
      
            
           
        //    cpt1.Bid_Line_Item__c=bdl.id;
            
            
            insert cpt1;
    Vision_GCP_Backorder_OTC__c bt= new Vision_GCP_Backorder_OTC__c();
    bt.Vision_Sku_Code__c='123566';
    bt.Vision_Backorder_Report_Date__c='2022-10-13';
    insert bt;
    Vision_GCP_Backorder_SRx_Rx__c srrx= new Vision_GCP_Backorder_SRx_Rx__c();
       srrx.Vision_MoH__c=23;
      srrx.Vision_SKU_Code__c='123566';
    srrx.Vision_On_Backorder__c='true';
      insert srrx;
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c = ctr.Id;
       npr.Phoenix_Contract_Number__c='1234';
        npr.Phoenix_Product__c=p.Id;
        npr.Phoenix_Add_ABS_Value__c = 2.00;
    npr.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr.Phoenix_12Months_Net_Sales__c=22.0;
    npr.Phoenix_Account__c=a.id;
    npr.Phoenix_Contract_Type__c='Indirect';
    npr.Phoenix_NPR_Status__c='Active';
   
   npr.Phoenix_Material_Number__c='123566';
        insert npr;
     Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr1.Phoenix_Contract__c = ctr.Id;
       npr1.Phoenix_Contract_Number__c='12346';
        npr1.Phoenix_Product__c=p.Id;
        npr1.Phoenix_Add_ABS_Value__c = 2.00;
    npr1.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr1.Phoenix_12Months_Net_Sales__c=22.0;
    npr1.Phoenix_Account__c=a.id;
    npr1.Phoenix_Contract_Type__c='Indirect';
    npr1.Phoenix_NPR_Status__c='Active';
   
   npr1.Phoenix_Material_Number__c='123566';
        insert npr1;
     Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr2.Phoenix_Contract__c = ctr.Id;
       npr2.Phoenix_Contract_Number__c='12345';
        npr2.Phoenix_Product__c=p.Id;
        npr2.Phoenix_Add_ABS_Value__c = 2.00;
    npr2.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr2.Phoenix_12Months_Net_Sales__c=22.0;
    npr2.Phoenix_Account__c=a.id;
    npr2.Phoenix_Contract_Type__c='Indirect';
    npr2.Phoenix_NPR_Status__c='Active';
   
   npr2.Phoenix_Material_Number__c='123566';
        insert npr2;
    list<Phoenix_NPR_Data__c> npr1ist=[select id,Phoenix_Contract__c,Phoenix_Contract_Number__c,Phoenix_Product__c,Phoenix_Add_ABS_Value__c,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_12Months_Net_Sales__c,Phoenix_Account__c,Phoenix_Contract_Type__c,Phoenix_NPR_Status__c,Phoenix_Material_Number__c from Phoenix_NPR_Data__c limit 10000];
    system.debug('nprlist....'+npr1ist.size());
    
       // Phoenix_NPR_Volume__c l1=[select Id,Phoenix_NPR_Data__r.Phoenix_Contract_Number__c,Phoenix_NPR_Data__r.Phoenix_Material_Number__c,Phoenix_NPR_Data__r.Phoenix_Contract_Type__c,Phoenix_NPR_Data__r.Phoenix_12Mt_Sales_Ut_Actual__c,Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC__c,Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_NPR_Data__r.Phoenix_Account__r.Accountnumber,Phoenix_NPR_Data__r.Phoenix_Account__c,Phoenix_NPR_Data__r.Phoenix_Contract__c,Phoenix_NPR_Data__r.Phoenix_Product__c,Phoenix_Month__c,Phoenix_Volume__c  from Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__r.Phoenix_NPR_Status__c=:'active' limit 1];
    Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol = new Phoenix_NPR_Volume__c();
        nprvol.Phoenix_NPR_Data__c=npr.id;
   nprvol.Phoenix_Date__c=  date.newInstance(2022, 03, 01);
       
       nprvol.Phoenix_Volume__c=23.00;
    insert nprvol;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol4 = new Phoenix_NPR_Volume__c();
        nprvol4.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol4.Phoenix_Date__c=  date.newInstance(2022, 09, 01);
       
       nprvol4.Phoenix_Volume__c=23.00;
    insert nprvol4;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol5 = new Phoenix_NPR_Volume__c();
        nprvol5.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol5.Phoenix_Date__c=  date.newInstance(2022, 08, 01);
       
       nprvol5.Phoenix_Volume__c=23.00;
    insert nprvol5;
   //  Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol6 = new Phoenix_NPR_Volume__c();
        nprvol6.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol6.Phoenix_Date__c=  date.newInstance(2022, 07, 01);
       
       nprvol6.Phoenix_Volume__c=23.00;
    insert nprvol6;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
       Phoenix_NPR_Volume__c nprvol7 = new Phoenix_NPR_Volume__c();
        nprvol7.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol7.Phoenix_Date__c=  date.newInstance(2022, 05, 01);
       
       nprvol7.Phoenix_Volume__c=23.00;
    insert nprvol7;
     
        Phoenix_NPR_Volume__c nprvol8 = new Phoenix_NPR_Volume__c();
        nprvol8.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol8.Phoenix_Date__c=  date.newInstance(2022, 06, 01);
       
       nprvol8.Phoenix_Volume__c=23.00;
    insert nprvol8;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol9 = new Phoenix_NPR_Volume__c();
        nprvol9.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol9.Phoenix_Date__c=  date.newInstance(2022, 04, 01);
       
       nprvol9.Phoenix_Volume__c=23.00;
    insert nprvol9;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol10 = new Phoenix_NPR_Volume__c();
        nprvol10.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol10.Phoenix_Date__c=  date.newInstance(2022, 03, 01);
       
       nprvol10.Phoenix_Volume__c=23.00;
    insert nprvol10;
    
   // Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
    
         //Vision_Customer_Product_Tracker__c cusPrdTrk = new Vision_Customer_Product_Tracker__c();
      //  insert cusPrdTrk;
   

  

    
      test.startTest();
        ComplianceRecordsNprData b= new ComplianceRecordsNprData();
        database.executeBatch(b);
        test.stopTest();
    }
    static testmethod void sr(){
        account a = new account();
         a.name='test';
         a.accountnumber='123454';
    insert a;
    
     list<Product2> plist = new list<Product2>();
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.OTC_Customer__c=a.id;
        p.IsActive=true;
        p.Phoenix_Is_Exclude_Bid__c=false;
        p.Vision_Is_CPT_Batch_Executed__c=false;
        p.Phoenix_Is_Private_Label_OTC__c=true;
        p.Phoenix_NDC_11__c='23364347';
       // p.ProductCode='123567';
        // p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='123566';
        //p.Phoenix_Product_Director__c=u.id;
      p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        plist.add(p);
   
    insert plist;
     Phoenix_Contract__c ctr = new Phoenix_Contract__c();
       ctr.Name = 'Test Contract';
        ctr.Phoenix_Customer__c = a.Id;
        ctr.Phoenix_Contract_Number__c='1234';
        ctr.Phoenix_Contract_Start_Date__c=system.today();
        ctr.Phoenix_Contract_End_Date__c=date.newInstance(2023, 12, 23);
    
        
        
        //ctr.Phoenix_Contract_Status__c='Active';
        insert ctr;
       
     Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
          //  cpt1.Vision_Account__c=acc.Id;
            cpt1.Vision_Contract__c=ctr.Id;
          //  cpt1.Vision_Contract_Product_Status__c='In Opportunity';
          //  cpt1.Vision_Product__c=p1.Id;
            cpt1.Vision_Product_Code__c='123566';
            cpt1.Vision_Contract_Number__c='1234';
            cpt1.Vision_Customer_Code__c='123456';
    cpt1.Vision_Is_In_Awarded__c=true;
            //cpt1.Vision_Price_Effective_Date__c=2022-07-19;
          // cpt1.Vision_Internal_Unique_Identifier__c='-300036391';
          //cpt1.Compliance_Unique_Identifier__c='3000001841-300036391';
          cpt1.General_Category__c='Primary';
         cpt1.Vision_Awarded_Value__c=23;
    cpt1.Vision_Awarded_Volume__c=23.0;
    cpt1.Vision_Current_Product_Position__c ='Multi-Award';
    
      
            
           
        //    cpt1.Bid_Line_Item__c=bdl.id;
            
            
            insert cpt1;
    Vision_GCP_Backorder_OTC__c bt= new Vision_GCP_Backorder_OTC__c();
    bt.Vision_Sku_Code__c='123566';
    bt.Vision_Backorder_Report_Date__c='2022-10-13';
    insert bt;
    Vision_GCP_Backorder_SRx_Rx__c srrx= new Vision_GCP_Backorder_SRx_Rx__c();
       srrx.Vision_MoH__c=23;
      srrx.Vision_SKU_Code__c='123566';
    srrx.Vision_On_Backorder__c='true';
      insert srrx;
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c = ctr.Id;
       npr.Phoenix_Contract_Number__c='1234';
        npr.Phoenix_Product__c=p.Id;
        npr.Phoenix_Add_ABS_Value__c = 2.00;
    npr.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr.Phoenix_12Months_Net_Sales__c=22.0;
    npr.Phoenix_Account__c=a.id;
    npr.Phoenix_Contract_Type__c='Indirect';
    npr.Phoenix_NPR_Status__c='Active';
   
   npr.Phoenix_Material_Number__c='123566';
        insert npr;
     Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr1.Phoenix_Contract__c = ctr.Id;
       npr1.Phoenix_Contract_Number__c='12346';
        npr1.Phoenix_Product__c=p.Id;
        npr1.Phoenix_Add_ABS_Value__c = 2.00;
    npr1.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr1.Phoenix_12Months_Net_Sales__c=22.0;
    npr1.Phoenix_Account__c=a.id;
    npr1.Phoenix_Contract_Type__c='Indirect';
    npr1.Phoenix_NPR_Status__c='Active';
   
   npr1.Phoenix_Material_Number__c='123566';
        insert npr1;
     Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr2.Phoenix_Contract__c = ctr.Id;
       npr2.Phoenix_Contract_Number__c='12345';
        npr2.Phoenix_Product__c=p.Id;
        npr2.Phoenix_Add_ABS_Value__c = 2.00;
    npr2.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr2.Phoenix_12Months_Net_Sales__c=22.0;
    npr2.Phoenix_Account__c=a.id;
    npr2.Phoenix_Contract_Type__c='Indirect';
    npr2.Phoenix_NPR_Status__c='Active';
   
   npr2.Phoenix_Material_Number__c='123566';
        insert npr2;
    list<Phoenix_NPR_Data__c> npr1ist=[select id,Phoenix_Contract__c,Phoenix_Contract_Number__c,Phoenix_Product__c,Phoenix_Add_ABS_Value__c,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_12Months_Net_Sales__c,Phoenix_Account__c,Phoenix_Contract_Type__c,Phoenix_NPR_Status__c,Phoenix_Material_Number__c from Phoenix_NPR_Data__c limit 10000];
    system.debug('nprlist....'+npr1ist.size());
    
       // Phoenix_NPR_Volume__c l1=[select Id,Phoenix_NPR_Data__r.Phoenix_Contract_Number__c,Phoenix_NPR_Data__r.Phoenix_Material_Number__c,Phoenix_NPR_Data__r.Phoenix_Contract_Type__c,Phoenix_NPR_Data__r.Phoenix_12Mt_Sales_Ut_Actual__c,Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC__c,Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_NPR_Data__r.Phoenix_Account__r.Accountnumber,Phoenix_NPR_Data__r.Phoenix_Account__c,Phoenix_NPR_Data__r.Phoenix_Contract__c,Phoenix_NPR_Data__r.Phoenix_Product__c,Phoenix_Month__c,Phoenix_Volume__c  from Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__r.Phoenix_NPR_Status__c=:'active' limit 1];
    Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol = new Phoenix_NPR_Volume__c();
        nprvol.Phoenix_NPR_Data__c=npr.id;
   nprvol.Phoenix_Date__c=  date.newInstance(2022, 02, 01);
       
       nprvol.Phoenix_Volume__c=23.00;
    insert nprvol;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol4 = new Phoenix_NPR_Volume__c();
        nprvol4.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol4.Phoenix_Date__c=  date.newInstance(2022, 09, 01);
       
       nprvol4.Phoenix_Volume__c=23.00;
    insert nprvol4;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol5 = new Phoenix_NPR_Volume__c();
        nprvol5.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol5.Phoenix_Date__c=  date.newInstance(2022, 08, 01);
       
       nprvol5.Phoenix_Volume__c=23.00;
    insert nprvol5;
   //  Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol6 = new Phoenix_NPR_Volume__c();
        nprvol6.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol6.Phoenix_Date__c=  date.newInstance(2022, 07, 01);
       
       nprvol6.Phoenix_Volume__c=23.00;
    insert nprvol6;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
       Phoenix_NPR_Volume__c nprvol7 = new Phoenix_NPR_Volume__c();
        nprvol7.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol7.Phoenix_Date__c=  date.newInstance(2022, 05, 01);
       
       nprvol7.Phoenix_Volume__c=23.00;
    insert nprvol7;
     
        Phoenix_NPR_Volume__c nprvol8 = new Phoenix_NPR_Volume__c();
        nprvol8.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol8.Phoenix_Date__c=  date.newInstance(2022, 06, 01);
       
       nprvol8.Phoenix_Volume__c=23.00;
    insert nprvol8;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol9 = new Phoenix_NPR_Volume__c();
        nprvol9.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol9.Phoenix_Date__c=  date.newInstance(2022, 04, 01);
       
       nprvol9.Phoenix_Volume__c=23.00;
    insert nprvol9;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol10 = new Phoenix_NPR_Volume__c();
        nprvol10.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol10.Phoenix_Date__c=  date.newInstance(2022, 03, 01);
       
       nprvol10.Phoenix_Volume__c=23.00;
    insert nprvol10;
    
   // Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
    
         //Vision_Customer_Product_Tracker__c cusPrdTrk = new Vision_Customer_Product_Tracker__c();
      //  insert cusPrdTrk;
   

  

    
      test.startTest();
        ComplianceRecordsNprData b= new ComplianceRecordsNprData();
        database.executeBatch(b);
        test.stopTest();
    }
    static testmethod void setup213243543(){
        account a = new account();
         a.name='test';
         a.accountnumber='123454';
    insert a;
    
     list<Product2> plist = new list<Product2>();
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.OTC_Customer__c=a.id;
        p.IsActive=true;
        p.Phoenix_Is_Exclude_Bid__c=false;
        p.Vision_Is_CPT_Batch_Executed__c=false;
        p.Phoenix_Is_Private_Label_OTC__c=true;
        p.Phoenix_NDC_11__c='23364347';
       // p.ProductCode='123567';
        // p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='123566';
        //p.Phoenix_Product_Director__c=u.id;
      p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        plist.add(p);
   
    insert plist;
     Phoenix_Contract__c ctr = new Phoenix_Contract__c();
       ctr.Name = 'Test Contract';
        ctr.Phoenix_Customer__c = a.Id;
        ctr.Phoenix_Contract_Number__c='1234';
        ctr.Phoenix_Contract_Start_Date__c=system.today();
        ctr.Phoenix_Contract_End_Date__c=date.newInstance(2023, 12, 23);
    
        
        
        //ctr.Phoenix_Contract_Status__c='Active';
        insert ctr;
       
     Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
          //  cpt1.Vision_Account__c=acc.Id;
            cpt1.Vision_Contract__c=ctr.Id;
          //  cpt1.Vision_Contract_Product_Status__c='In Opportunity';
          //  cpt1.Vision_Product__c=p1.Id;
            cpt1.Vision_Product_Code__c='123566';
            cpt1.Vision_Contract_Number__c='1234';
            cpt1.Vision_Customer_Code__c='123456';
    cpt1.Vision_Is_In_Awarded__c=true;
            //cpt1.Vision_Price_Effective_Date__c=2022-07-19;
          // cpt1.Vision_Internal_Unique_Identifier__c='-300036391';
          //cpt1.Compliance_Unique_Identifier__c='3000001841-300036391';
          cpt1.General_Category__c='Primary';
         cpt1.Vision_Awarded_Value__c=23;
    cpt1.Vision_Awarded_Volume__c=23.0;
    cpt1.Vision_Current_Product_Position__c ='Multi-Award';
    
      
            
           
        //    cpt1.Bid_Line_Item__c=bdl.id;
            
            
            insert cpt1;
    Vision_GCP_Backorder_OTC__c bt= new Vision_GCP_Backorder_OTC__c();
    bt.Vision_Sku_Code__c='123566';
    bt.Vision_Backorder_Report_Date__c='2022-10-13';
    insert bt;
    Vision_GCP_Backorder_SRx_Rx__c srrx= new Vision_GCP_Backorder_SRx_Rx__c();
       srrx.Vision_MoH__c=23;
      srrx.Vision_SKU_Code__c='123566';
    srrx.Vision_On_Backorder__c='true';
      insert srrx;
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c = ctr.Id;
       npr.Phoenix_Contract_Number__c='1234';
        npr.Phoenix_Product__c=p.Id;
        npr.Phoenix_Add_ABS_Value__c = 2.00;
    npr.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr.Phoenix_12Months_Net_Sales__c=22.0;
    npr.Phoenix_Account__c=a.id;
    npr.Phoenix_Contract_Type__c='Indirect';
    npr.Phoenix_NPR_Status__c='Active';
   
   npr.Phoenix_Material_Number__c='123566';
        insert npr;
     Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr1.Phoenix_Contract__c = ctr.Id;
       npr1.Phoenix_Contract_Number__c='12346';
        npr1.Phoenix_Product__c=p.Id;
        npr1.Phoenix_Add_ABS_Value__c = 2.00;
    npr1.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr1.Phoenix_12Months_Net_Sales__c=22.0;
    npr1.Phoenix_Account__c=a.id;
    npr1.Phoenix_Contract_Type__c='Indirect';
    npr1.Phoenix_NPR_Status__c='Active';
   
   npr1.Phoenix_Material_Number__c='123566';
        insert npr1;
     Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr2.Phoenix_Contract__c = ctr.Id;
       npr2.Phoenix_Contract_Number__c='12345';
        npr2.Phoenix_Product__c=p.Id;
        npr2.Phoenix_Add_ABS_Value__c = 2.00;
    npr2.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr2.Phoenix_12Months_Net_Sales__c=22.0;
    npr2.Phoenix_Account__c=a.id;
    npr2.Phoenix_Contract_Type__c='Indirect';
    npr2.Phoenix_NPR_Status__c='Active';
   
   npr2.Phoenix_Material_Number__c='123566';
        insert npr2;
    list<Phoenix_NPR_Data__c> npr1ist=[select id,Phoenix_Contract__c,Phoenix_Contract_Number__c,Phoenix_Product__c,Phoenix_Add_ABS_Value__c,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_12Months_Net_Sales__c,Phoenix_Account__c,Phoenix_Contract_Type__c,Phoenix_NPR_Status__c,Phoenix_Material_Number__c from Phoenix_NPR_Data__c limit 10000];
    system.debug('nprlist....'+npr1ist.size());
    
       // Phoenix_NPR_Volume__c l1=[select Id,Phoenix_NPR_Data__r.Phoenix_Contract_Number__c,Phoenix_NPR_Data__r.Phoenix_Material_Number__c,Phoenix_NPR_Data__r.Phoenix_Contract_Type__c,Phoenix_NPR_Data__r.Phoenix_12Mt_Sales_Ut_Actual__c,Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC__c,Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_NPR_Data__r.Phoenix_Account__r.Accountnumber,Phoenix_NPR_Data__r.Phoenix_Account__c,Phoenix_NPR_Data__r.Phoenix_Contract__c,Phoenix_NPR_Data__r.Phoenix_Product__c,Phoenix_Month__c,Phoenix_Volume__c  from Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__r.Phoenix_NPR_Status__c=:'active' limit 1];
    Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol = new Phoenix_NPR_Volume__c();
        nprvol.Phoenix_NPR_Data__c=npr.id;
   nprvol.Phoenix_Date__c=  date.newInstance(2022, 01, 01);
       
       nprvol.Phoenix_Volume__c=23.00;
    insert nprvol;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol4 = new Phoenix_NPR_Volume__c();
        nprvol4.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol4.Phoenix_Date__c=  date.newInstance(2022, 09, 01);
       
       nprvol4.Phoenix_Volume__c=23.00;
    insert nprvol4;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol5 = new Phoenix_NPR_Volume__c();
        nprvol5.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol5.Phoenix_Date__c=  date.newInstance(2022, 08, 01);
       
       nprvol5.Phoenix_Volume__c=23.00;
    insert nprvol5;
   //  Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol6 = new Phoenix_NPR_Volume__c();
        nprvol6.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol6.Phoenix_Date__c=  date.newInstance(2022, 07, 01);
       
       nprvol6.Phoenix_Volume__c=23.00;
    insert nprvol6;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
       Phoenix_NPR_Volume__c nprvol7 = new Phoenix_NPR_Volume__c();
        nprvol7.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol7.Phoenix_Date__c=  date.newInstance(2022, 05, 01);
       
       nprvol7.Phoenix_Volume__c=23.00;
    insert nprvol7;
     
        Phoenix_NPR_Volume__c nprvol8 = new Phoenix_NPR_Volume__c();
        nprvol8.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol8.Phoenix_Date__c=  date.newInstance(2022, 06, 01);
       
       nprvol8.Phoenix_Volume__c=23.00;
    insert nprvol8;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol9 = new Phoenix_NPR_Volume__c();
        nprvol9.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol9.Phoenix_Date__c=  date.newInstance(2022, 04, 01);
       
       nprvol9.Phoenix_Volume__c=23.00;
    insert nprvol9;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol10 = new Phoenix_NPR_Volume__c();
        nprvol10.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol10.Phoenix_Date__c=  date.newInstance(2022, 03, 01);
       
       nprvol10.Phoenix_Volume__c=23.00;
    insert nprvol10;
    
   // Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
    
         //Vision_Customer_Product_Tracker__c cusPrdTrk = new Vision_Customer_Product_Tracker__c();
      //  insert cusPrdTrk;
   

  

    
      test.startTest();
        ComplianceRecordsNprData b= new ComplianceRecordsNprData();
        database.executeBatch(b);
        test.stopTest();
        
    }
    static testmethod void setupp(){
        account a = new account();
         a.name='test';
         a.accountnumber='123454';
    insert a;
    
     list<Product2> plist = new list<Product2>();
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.OTC_Customer__c=a.id;
        p.IsActive=true;
        p.Phoenix_Is_Exclude_Bid__c=false;
        p.Vision_Is_CPT_Batch_Executed__c=false;
        p.Phoenix_Is_Private_Label_OTC__c=true;
        p.Phoenix_NDC_11__c='23364347';
       // p.ProductCode='123567';
        // p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='123566';
        //p.Phoenix_Product_Director__c=u.id;
      p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        plist.add(p);
   
    insert plist;
     Phoenix_Contract__c ctr = new Phoenix_Contract__c();
       ctr.Name = 'Test Contract';
        ctr.Phoenix_Customer__c = a.Id;
        ctr.Phoenix_Contract_Number__c='1234';
        ctr.Phoenix_Contract_Start_Date__c=system.today();
        ctr.Phoenix_Contract_End_Date__c=date.newInstance(2023, 12, 23);
    
        
        
        //ctr.Phoenix_Contract_Status__c='Active';
        insert ctr;
       
     Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
          //  cpt1.Vision_Account__c=acc.Id;
            cpt1.Vision_Contract__c=ctr.Id;
          //  cpt1.Vision_Contract_Product_Status__c='In Opportunity';
          //  cpt1.Vision_Product__c=p1.Id;
            cpt1.Vision_Product_Code__c='123566';
            cpt1.Vision_Contract_Number__c='1234';
            cpt1.Vision_Customer_Code__c='123456';
    cpt1.Vision_Is_In_Awarded__c=true;
            //cpt1.Vision_Price_Effective_Date__c=2022-07-19;
          // cpt1.Vision_Internal_Unique_Identifier__c='-300036391';
          //cpt1.Compliance_Unique_Identifier__c='3000001841-300036391';
          cpt1.General_Category__c='Primary';
         cpt1.Vision_Awarded_Value__c=23;
    cpt1.Vision_Awarded_Volume__c=23.0;
    cpt1.Vision_Current_Product_Position__c ='Multi-Award';
    
      
            
           
        //    cpt1.Bid_Line_Item__c=bdl.id;
            
            
            insert cpt1;
    Vision_GCP_Backorder_OTC__c bt= new Vision_GCP_Backorder_OTC__c();
    bt.Vision_Sku_Code__c='123566';
    bt.Vision_Backorder_Report_Date__c='2022-10-13';
    insert bt;
    Vision_GCP_Backorder_SRx_Rx__c srrx= new Vision_GCP_Backorder_SRx_Rx__c();
       srrx.Vision_MoH__c=23;
      srrx.Vision_SKU_Code__c='123566';
    srrx.Vision_On_Backorder__c='true';
      insert srrx;
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c = ctr.Id;
       npr.Phoenix_Contract_Number__c='1234';
        npr.Phoenix_Product__c=p.Id;
        npr.Phoenix_Add_ABS_Value__c = 2.00;
    npr.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr.Phoenix_12Months_Net_Sales__c=22.0;
    npr.Phoenix_Account__c=a.id;
    npr.Phoenix_Contract_Type__c='Indirect';
    npr.Phoenix_NPR_Status__c='Active';
   
   npr.Phoenix_Material_Number__c='123566';
        insert npr;
     Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr1.Phoenix_Contract__c = ctr.Id;
       npr1.Phoenix_Contract_Number__c='12346';
        npr1.Phoenix_Product__c=p.Id;
        npr1.Phoenix_Add_ABS_Value__c = 2.00;
    npr1.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr1.Phoenix_12Months_Net_Sales__c=22.0;
    npr1.Phoenix_Account__c=a.id;
    npr1.Phoenix_Contract_Type__c='Indirect';
    npr1.Phoenix_NPR_Status__c='Active';
   
   npr1.Phoenix_Material_Number__c='123566';
        insert npr1;
     Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr2.Phoenix_Contract__c = ctr.Id;
       npr2.Phoenix_Contract_Number__c='12345';
        npr2.Phoenix_Product__c=p.Id;
        npr2.Phoenix_Add_ABS_Value__c = 2.00;
    npr2.Phoenix_12Months_Actual_Sales_Unit__c=24.0;
    npr2.Phoenix_12Months_Net_Sales__c=22.0;
    npr2.Phoenix_Account__c=a.id;
    npr2.Phoenix_Contract_Type__c='Indirect';
    npr2.Phoenix_NPR_Status__c='Active';
   
   npr2.Phoenix_Material_Number__c='123566';
        insert npr2;
    list<Phoenix_NPR_Data__c> npr1ist=[select id,Phoenix_Contract__c,Phoenix_Contract_Number__c,Phoenix_Product__c,Phoenix_Add_ABS_Value__c,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_12Months_Net_Sales__c,Phoenix_Account__c,Phoenix_Contract_Type__c,Phoenix_NPR_Status__c,Phoenix_Material_Number__c from Phoenix_NPR_Data__c limit 10000];
    system.debug('nprlist....'+npr1ist.size());
    
       // Phoenix_NPR_Volume__c l1=[select Id,Phoenix_NPR_Data__r.Phoenix_Contract_Number__c,Phoenix_NPR_Data__r.Phoenix_Material_Number__c,Phoenix_NPR_Data__r.Phoenix_Contract_Type__c,Phoenix_NPR_Data__r.Phoenix_12Mt_Sales_Ut_Actual__c,Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC__c,Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_NPR_Data__r.Phoenix_Account__r.Accountnumber,Phoenix_NPR_Data__r.Phoenix_Account__c,Phoenix_NPR_Data__r.Phoenix_Contract__c,Phoenix_NPR_Data__r.Phoenix_Product__c,Phoenix_Month__c,Phoenix_Volume__c  from Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__r.Phoenix_NPR_Status__c=:'active' limit 1];
    Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol = new Phoenix_NPR_Volume__c();
        nprvol.Phoenix_NPR_Data__c=npr.id;
   nprvol.Phoenix_Date__c=  date.newInstance(2021, 12, 01);
       
       nprvol.Phoenix_Volume__c=23.00;
    insert nprvol;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol4 = new Phoenix_NPR_Volume__c();
        nprvol4.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol4.Phoenix_Date__c=  date.newInstance(2022, 09, 01);
       
       nprvol4.Phoenix_Volume__c=23.00;
    insert nprvol4;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol5 = new Phoenix_NPR_Volume__c();
        nprvol5.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol5.Phoenix_Date__c=  date.newInstance(2022, 08, 01);
       
       nprvol5.Phoenix_Volume__c=23.00;
    insert nprvol5;
   //  Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol6 = new Phoenix_NPR_Volume__c();
        nprvol6.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol6.Phoenix_Date__c=  date.newInstance(2022, 07, 01);
       
       nprvol6.Phoenix_Volume__c=23.00;
    insert nprvol6;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
       Phoenix_NPR_Volume__c nprvol7 = new Phoenix_NPR_Volume__c();
        nprvol7.Phoenix_NPR_Data__c=npr1ist[0].id;
   nprvol7.Phoenix_Date__c=  date.newInstance(2022, 05, 01);
       
       nprvol7.Phoenix_Volume__c=23.00;
    insert nprvol7;
     
        Phoenix_NPR_Volume__c nprvol8 = new Phoenix_NPR_Volume__c();
        nprvol8.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol8.Phoenix_Date__c=  date.newInstance(2022, 06, 01);
       
       nprvol8.Phoenix_Volume__c=23.00;
    insert nprvol8;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol9 = new Phoenix_NPR_Volume__c();
        nprvol9.Phoenix_NPR_Data__c=npr1ist[2].id;
   nprvol9.Phoenix_Date__c=  date.newInstance(2022, 04, 01);
       
       nprvol9.Phoenix_Volume__c=23.00;
    insert nprvol9;
    // Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol10 = new Phoenix_NPR_Volume__c();
        nprvol10.Phoenix_NPR_Data__c=npr1ist[1].id;
   nprvol10.Phoenix_Date__c=  date.newInstance(2022, 03, 01);
       
       nprvol10.Phoenix_Volume__c=23.00;
    insert nprvol10;
    
   // Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
    
         //Vision_Customer_Product_Tracker__c cusPrdTrk = new Vision_Customer_Product_Tracker__c();
      //  insert cusPrdTrk;
   

  

    
      test.startTest();
        ComplianceRecordsNprData b= new ComplianceRecordsNprData();
        database.executeBatch(b);
        test.stopTest();
        
    }
}