@istest
public class ComplianceRolluptestclass {
    static testmethod void setup(){
        account a = new account();
         a.name='test';
         a.accountnumber='123454';
    insert a;
    account a1= new account();
        a1.name='test1';
        a1.accountnumber='111111';
        insert a1;
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
     Product2 p1=new Product2();
        p1.Name='abc pharma2';
        p1.OTC_Customer__c=a1.id;
        p1.IsActive=true;
        p1.Phoenix_Is_Exclude_Bid__c=false;
        p1.Vision_Is_CPT_Batch_Executed__c=false;
        p1.Phoenix_Is_Private_Label_OTC__c=true;
        p1.Phoenix_NDC_11__c='23364347';
       // p.ProductCode='123567';
        // p.Phoenix_NDC_11__c='23364848';
        p1.ProductCode='123576';
        //p.Phoenix_Product_Director__c=u.id;
      p1.Phoenix_NDC__c='5555555';
        p1.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p1.Family = 'Test Family';
        p1.Phoenix_Throughput_cost__c=10.23456576;
        p1.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        plist.add(p1);
   
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
   // list<Phoenix_NPR_Data__c> npr1ist=[select id,Phoenix_Contract__c,Phoenix_Contract_Number__c,Phoenix_Product__c,Phoenix_Add_ABS_Value__c,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_12Months_Net_Sales__c,Phoenix_Account__c,Phoenix_Contract_Type__c,Phoenix_NPR_Status__c,Phoenix_Material_Number__c from Phoenix_NPR_Data__c limit 10000];
    //system.debug('nprlist....'+npr1ist.size());
    
       // Phoenix_NPR_Volume__c l1=[select Id,Phoenix_NPR_Data__r.Phoenix_Contract_Number__c,Phoenix_NPR_Data__r.Phoenix_Material_Number__c,Phoenix_NPR_Data__r.Phoenix_Contract_Type__c,Phoenix_NPR_Data__r.Phoenix_12Mt_Sales_Ut_Actual__c,Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC__c,Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_NPR_Data__r.Phoenix_Account__r.Accountnumber,Phoenix_NPR_Data__r.Phoenix_Account__c,Phoenix_NPR_Data__r.Phoenix_Contract__c,Phoenix_NPR_Data__r.Phoenix_Product__c,Phoenix_Month__c,Phoenix_Volume__c  from Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__r.Phoenix_NPR_Status__c=:'active' limit 1];
    Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol = new Phoenix_NPR_Volume__c();
        nprvol.Phoenix_NPR_Data__c=npr.id;
   nprvol.Phoenix_Date__c=  date.newInstance(2022, 10, 01);
       
       nprvol.Phoenix_Volume__c=23.00;
    insert nprvol;
       
       Compliance_Data__c ct= new Compliance_Data__c();
        ct.Contract_Type__c='Direct';
        ct.GCP_Backorder_OTC__c=bt.id;
        ct.Customer_Code__c='123454';
        ct.Vision_Contract__c=ctr.id;
        ct.Vision_Customer__c=a.id;
        ct.Vision_Product__c=p.id;
        ct.Product_Code__c='123566';
        ct.M1_Quantity__c=23;
        ct.M2_Quantity__c=23;
        ct.M3_Quantity__c=23;
        ct.M4_Quantity__c=23;
        ct.M5_Quantity__c=23;
        ct.M6_Quantity__c=23;
        ct.M7_Quantity__c=23;
        
            ct.M8_Quantity__c=23;
        ct.M9_Quantity__c=23;
        ct.M10_Quantity__c=23;
        ct.M11_Quantity__c=23;
        ct.M12_Quantity__c=23;
        ct.Month1__c='oct-22';
          ct.Month2__c='oct-22';
           ct.Month3__c='oct-22';
           ct.Month4__c='oct-22';
           ct.Month5__c='oct-22';
           ct.Month6__c='oct-22';
           ct.Month7__c='oct-22';
           ct.Month8__c='oct-22';
           ct.Month9__c='oct-22';
           ct.Month10__c='oct-22';
           ct.Month11__c='oct-22';
           ct.Month12__c='oct-22';
         
        
        insert ct;
           
       Compliance_Data__c ct1= new Compliance_Data__c();
        ct1.Contract_Type__c='Indirect';
        ct1.GCP_Backorder_OTC__c=bt.id;
        ct1.Customer_Code__c='123454';
        ct1.Vision_Contract__c=ctr.id;
        ct1.Vision_Customer__c=a.id;
        ct1.Vision_Product__c=p.id;
        ct1.Product_Code__c='123566';
        ct1.M1_Quantity__c=23;
        ct1.M2_Quantity__c=23;
        ct1.M3_Quantity__c=23;
        ct1.M4_Quantity__c=23;
        ct1.M5_Quantity__c=23;
        ct1.M6_Quantity__c=23;
        ct1.M7_Quantity__c=23;
        
            ct1.M8_Quantity__c=23;
        ct1.M9_Quantity__c=23;
        ct1.M10_Quantity__c=23;
        ct1.M11_Quantity__c=23;
        ct1.M12_Quantity__c=23;
        ct1.Month1__c='oct-22';
          ct1.Month2__c='oct-22';
           ct1.Month3__c='oct-22';
           ct1.Month4__c='oct-22';
           ct1.Month5__c='oct-22';
           ct1.Month6__c='oct-22';
           ct1.Month7__c='oct-22';
           ct1.Month8__c='oct-22';
           ct1.Month9__c='oct-22';
           ct1.Month10__c='oct-22';
           ct1.Month11__c='oct-22';
           ct1.Month12__c='oct-22';
         
        
        insert ct1;
         Compliance_Data__c ct2= new Compliance_Data__c();
        ct2.Contract_Type__c='Direct';
        ct2.GCP_Backorder_OTC__c=bt.id;
        ct2.Customer_Code__c='111111';
        ct2.Vision_Contract__c=ctr.id;
        ct2.Vision_Customer__c=a.id;
        ct2.Vision_Product__c=p.id;
        ct2.Product_Code__c='123566';
        ct2.M1_Quantity__c=23;
        ct2.M2_Quantity__c=23;
        ct2.M3_Quantity__c=23;
        ct2.M4_Quantity__c=23;
        ct2.M5_Quantity__c=23;
        ct2.M6_Quantity__c=23;
        ct2.M7_Quantity__c=23;
        
            ct2.M8_Quantity__c=23;
        ct2.M9_Quantity__c=23;
        ct2.M10_Quantity__c=23;
        ct2.M11_Quantity__c=23;
        ct2.M12_Quantity__c=23;
        ct2.Month1__c='oct-22';
          ct2.Month2__c='oct-22';
           ct2.Month3__c='oct-22';
           ct2.Month4__c='oct-22';
           ct2.Month5__c='oct-22';
           ct2.Month6__c='oct-22';
           ct2.Month7__c='oct-22';
           ct2.Month8__c='oct-22';
           ct2.Month9__c='oct-22';
           ct2.Month10__c='oct-22';
           ct2.Month11__c='oct-22';
           ct2.Month12__c='oct-22';
         
        
        insert ct2;
         test.startTest();
        Compliance_RollUP_Batch b= new Compliance_RollUP_Batch();
        database.executeBatch(b);
        test.stopTest();
    }
    static testmethod void setup1(){
          account a = new account();
         a.name='test';
         a.accountnumber='123454';
    insert a;
    account a1= new account();
        a1.name='test1';
        a1.accountnumber='111111';
        insert a1;
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
     Product2 p1=new Product2();
        p1.Name='abc pharma2';
        p1.OTC_Customer__c=a1.id;
        p1.IsActive=true;
        p1.Phoenix_Is_Exclude_Bid__c=false;
        p1.Vision_Is_CPT_Batch_Executed__c=false;
        p1.Phoenix_Is_Private_Label_OTC__c=true;
        p1.Phoenix_NDC_11__c='23364347';
       // p.ProductCode='123567';
        // p.Phoenix_NDC_11__c='23364848';
        p1.ProductCode='123576';
        //p.Phoenix_Product_Director__c=u.id;
      p1.Phoenix_NDC__c='5555555';
        p1.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p1.Family = 'Test Family';
        p1.Phoenix_Throughput_cost__c=10.23456576;
        p1.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        plist.add(p1);
   
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
   // list<Phoenix_NPR_Data__c> npr1ist=[select id,Phoenix_Contract__c,Phoenix_Contract_Number__c,Phoenix_Product__c,Phoenix_Add_ABS_Value__c,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_12Months_Net_Sales__c,Phoenix_Account__c,Phoenix_Contract_Type__c,Phoenix_NPR_Status__c,Phoenix_Material_Number__c from Phoenix_NPR_Data__c limit 10000];
    //system.debug('nprlist....'+npr1ist.size());
    
       // Phoenix_NPR_Volume__c l1=[select Id,Phoenix_NPR_Data__r.Phoenix_Contract_Number__c,Phoenix_NPR_Data__r.Phoenix_Material_Number__c,Phoenix_NPR_Data__r.Phoenix_Contract_Type__c,Phoenix_NPR_Data__r.Phoenix_12Mt_Sales_Ut_Actual__c,Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC__c,Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_NPR_Data__r.Phoenix_Account__r.Accountnumber,Phoenix_NPR_Data__r.Phoenix_Account__c,Phoenix_NPR_Data__r.Phoenix_Contract__c,Phoenix_NPR_Data__r.Phoenix_Product__c,Phoenix_Month__c,Phoenix_Volume__c  from Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__r.Phoenix_NPR_Status__c=:'active' limit 1];
    Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol = new Phoenix_NPR_Volume__c();
        nprvol.Phoenix_NPR_Data__c=npr.id;
   nprvol.Phoenix_Date__c=  date.newInstance(2022, 10, 01);
       
       nprvol.Phoenix_Volume__c=23.00;
    insert nprvol;
       
       Compliance_Data__c ct= new Compliance_Data__c();
        ct.Contract_Type__c='Indirect';
        ct.GCP_Backorder_OTC__c=bt.id;
        ct.Customer_Code__c='123454';
        ct.Vision_Contract__c=ctr.id;
        ct.Vision_Customer__c=a.id;
        ct.Vision_Product__c=p.id;
        ct.Product_Code__c='123566';
        ct.M1_Quantity__c=23;
        ct.M2_Quantity__c=23;
        ct.M3_Quantity__c=23;
        ct.M4_Quantity__c=23;
        ct.M5_Quantity__c=23;
        ct.M6_Quantity__c=23;
        ct.M7_Quantity__c=23;
        
            ct.M8_Quantity__c=23;
        ct.M9_Quantity__c=23;
        ct.M10_Quantity__c=23;
        ct.M11_Quantity__c=23;
        ct.M12_Quantity__c=23;
        ct.Month1__c='oct-22';
          ct.Month2__c='oct-22';
           ct.Month3__c='oct-22';
           ct.Month4__c='oct-22';
           ct.Month5__c='oct-22';
           ct.Month6__c='oct-22';
           ct.Month7__c='oct-22';
           ct.Month8__c='oct-22';
           ct.Month9__c='oct-22';
           ct.Month10__c='oct-22';
           ct.Month11__c='oct-22';
           ct.Month12__c='oct-22';
         
        
        insert ct;
           
       Compliance_Data__c ct1= new Compliance_Data__c();
        ct1.Contract_Type__c='Indirect';
        ct1.GCP_Backorder_OTC__c=bt.id;
        ct1.Customer_Code__c='123454';
        ct1.Vision_Contract__c=ctr.id;
        ct1.Vision_Customer__c=a.id;
        ct1.Vision_Product__c=p.id;
        ct1.Product_Code__c='123566';
        ct1.M1_Quantity__c=23;
        ct1.M2_Quantity__c=23;
        ct1.M3_Quantity__c=23;
        ct1.M4_Quantity__c=23;
        ct1.M5_Quantity__c=23;
        ct1.M6_Quantity__c=23;
        ct1.M7_Quantity__c=23;
        
            ct1.M8_Quantity__c=23;
        ct1.M9_Quantity__c=23;
        ct1.M10_Quantity__c=23;
        ct1.M11_Quantity__c=23;
        ct1.M12_Quantity__c=23;
        ct1.Month1__c='oct-22';
          ct1.Month2__c='oct-22';
           ct1.Month3__c='oct-22';
           ct1.Month4__c='oct-22';
           ct1.Month5__c='oct-22';
           ct1.Month6__c='oct-22';
           ct1.Month7__c='oct-22';
           ct1.Month8__c='oct-22';
           ct1.Month9__c='oct-22';
           ct1.Month10__c='oct-22';
           ct1.Month11__c='oct-22';
           ct1.Month12__c='oct-22';
         
        
        insert ct1;
         Compliance_Data__c ct2= new Compliance_Data__c();
        ct2.Contract_Type__c='Direct';
        ct2.GCP_Backorder_OTC__c=bt.id;
        ct2.Customer_Code__c='111111';
        ct2.Vision_Contract__c=ctr.id;
        ct2.Vision_Customer__c=a.id;
        ct2.Vision_Product__c=p.id;
        ct2.Product_Code__c='123566';
        ct2.M1_Quantity__c=23;
        ct2.M2_Quantity__c=23;
        ct2.M3_Quantity__c=23;
        ct2.M4_Quantity__c=23;
        ct2.M5_Quantity__c=23;
        ct2.M6_Quantity__c=23;
        ct2.M7_Quantity__c=23;
        
            ct2.M8_Quantity__c=23;
        ct2.M9_Quantity__c=23;
        ct2.M10_Quantity__c=23;
        ct2.M11_Quantity__c=23;
        ct2.M12_Quantity__c=23;
        ct2.Month1__c='oct-22';
          ct2.Month2__c='oct-22';
           ct2.Month3__c='oct-22';
           ct2.Month4__c='oct-22';
           ct2.Month5__c='oct-22';
           ct2.Month6__c='oct-22';
           ct2.Month7__c='oct-22';
           ct2.Month8__c='oct-22';
           ct2.Month9__c='oct-22';
           ct2.Month10__c='oct-22';
           ct2.Month11__c='oct-22';
           ct2.Month12__c='oct-22';
         
        
        insert ct2;
         test.startTest();
        Compliance_RollUP_Batch b= new Compliance_RollUP_Batch();
        database.executeBatch(b);
        test.stopTest();
        
    }
    static testmethod void setup3(){
        account a = new account();
         a.name='test';
         a.accountnumber='123454';
    insert a;
    account a1= new account();
        a1.name='test1';
        a1.accountnumber='111111';
        insert a1;
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
     Product2 p1=new Product2();
        p1.Name='abc pharma2';
        p1.OTC_Customer__c=a1.id;
        p1.IsActive=true;
        p1.Phoenix_Is_Exclude_Bid__c=false;
        p1.Vision_Is_CPT_Batch_Executed__c=false;
        p1.Phoenix_Is_Private_Label_OTC__c=true;
        p1.Phoenix_NDC_11__c='23364347';
       // p.ProductCode='123567';
        // p.Phoenix_NDC_11__c='23364848';
        p1.ProductCode='123576';
        //p.Phoenix_Product_Director__c=u.id;
      p1.Phoenix_NDC__c='5555555';
        p1.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p1.Family = 'Test Family';
        p1.Phoenix_Throughput_cost__c=10.23456576;
        p1.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        plist.add(p1);
   
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
   // list<Phoenix_NPR_Data__c> npr1ist=[select id,Phoenix_Contract__c,Phoenix_Contract_Number__c,Phoenix_Product__c,Phoenix_Add_ABS_Value__c,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_12Months_Net_Sales__c,Phoenix_Account__c,Phoenix_Contract_Type__c,Phoenix_NPR_Status__c,Phoenix_Material_Number__c from Phoenix_NPR_Data__c limit 10000];
    //system.debug('nprlist....'+npr1ist.size());
    
       // Phoenix_NPR_Volume__c l1=[select Id,Phoenix_NPR_Data__r.Phoenix_Contract_Number__c,Phoenix_NPR_Data__r.Phoenix_Material_Number__c,Phoenix_NPR_Data__r.Phoenix_Contract_Type__c,Phoenix_NPR_Data__r.Phoenix_12Mt_Sales_Ut_Actual__c,Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC__c,Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_NPR_Data__r.Phoenix_Account__r.Accountnumber,Phoenix_NPR_Data__r.Phoenix_Account__c,Phoenix_NPR_Data__r.Phoenix_Contract__c,Phoenix_NPR_Data__r.Phoenix_Product__c,Phoenix_Month__c,Phoenix_Volume__c  from Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__r.Phoenix_NPR_Status__c=:'active' limit 1];
    Phoenix_NPR_Volume__c testvol= new Phoenix_NPR_Volume__c();
      
     
        Phoenix_NPR_Volume__c nprvol = new Phoenix_NPR_Volume__c();
        nprvol.Phoenix_NPR_Data__c=npr.id;
   nprvol.Phoenix_Date__c=  date.newInstance(2022, 10, 01);
       
       nprvol.Phoenix_Volume__c=23.00;
    insert nprvol;
       
      Compliance_Summary__c cp= new Compliance_Summary__c();
        cp.Month1__c='Oct-22';
        cp.Month2__c='Sep-22';
        cp.Month3__c='Aug-22';
        cp.Month4__c='Jul-22';
        cp.Month5__c='Jun-22';
        cp.Month6__c='May-22';
        cp.Month7__c='Apr-22';
        cp.Month8__c='Mar-22';
        cp.Month9__c='Feb-22';
        cp.Month10__c='Jan-22';
        cp.Month11__c='Dec-21';
        cp.Month12__c='Nov-21';
        cp.M1_Quantity__c=23;
     cp.M1_Quantity__c=23;
    
         cp.M2_Quantity__c=23;
    
         cp.M3_Quantity__c=23;
    
         cp.M4_Quantity__c=23;
    
         cp.M5_Quantity__c=23;
    
         cp.M6_Quantity__c=23;
    
         cp.M7_Quantity__c=23;
    
         cp.M8_Quantity__c=23;
    
         cp.M9_Quantity__c=23;
    
         cp.M10_Quantity__c=23;
    
         cp.M11_Quantity__c=23;
        cp.M12_Quantity__c=23;
      cp.M1_Indirect_Quantity__c=23;
      cp.M2_Indirect_Quantity__c=23;  
       cp.M3_Indirect_Quantity__c=23;    
        cp.M4_Indirect_Quantity__c=23;
        cp.M5_Indirect_Quantity__c=23;
        cp.M6_Indirect_Quantity__c=23;
        cp.M7_Indirect_Quantity__c=23;
        cp.M8_Indirect_Quantity__c=23;
        cp.M9_Indirect_Quantity__c=23;
        cp.M10_Indirect_Quantity__c=23;
        cp.M11_Indirect_Quantity__c=23;
        cp.M12_Indirect_Quantity__c=23;
        cp.Awarded_Information__c=0;
        insert cp;
                 test.startTest();
        complianceCTDFTDdata b= new complianceCTDFTDdata();
        database.executeBatch(b);
        test.stopTest();
        
    }
    static testmethod void setuppp(){
        Compliance_Summary__c cp= new Compliance_Summary__c();
        cp.Month1__c='Oct-22';
        cp.Month2__c='Oct-22';
        cp.Month3__c='Aug-22';
        cp.Month4__c='Jul-22';
        cp.Month5__c='Jun-22';
        cp.Month6__c='May-22';
        cp.Month7__c='Apr-22';
        cp.Month8__c='Mar-22';
        cp.Month9__c='Feb-22';
        cp.Month10__c='Jan-22';
        cp.Month11__c='Dec-21';
        cp.Month12__c='Nov-21';
        cp.M1_Quantity__c=23;
     cp.M1_Quantity__c=23;
    
         cp.M2_Quantity__c=23;
    
         cp.M3_Quantity__c=23;
    
         cp.M4_Quantity__c=23;
    
         cp.M5_Quantity__c=23;
    
         cp.M6_Quantity__c=23;
    
         cp.M7_Quantity__c=23;
    
         cp.M8_Quantity__c=23;
    
         cp.M9_Quantity__c=23;
    
         cp.M10_Quantity__c=23;
    
         cp.M11_Quantity__c=23;
        cp.M12_Quantity__c=23;
      cp.M1_Indirect_Quantity__c=23;
      cp.M2_Indirect_Quantity__c=23;  
       cp.M3_Indirect_Quantity__c=23;    
        cp.M4_Indirect_Quantity__c=23;
        cp.M5_Indirect_Quantity__c=23;
        cp.M6_Indirect_Quantity__c=23;
        cp.M7_Indirect_Quantity__c=23;
        cp.M8_Indirect_Quantity__c=23;
        cp.M9_Indirect_Quantity__c=23;
        cp.M10_Indirect_Quantity__c=23;
        cp.M11_Indirect_Quantity__c=23;
        cp.M12_Indirect_Quantity__c=23;
        cp.Awarded_Information__c=0;
        insert cp;
                 test.startTest();
        complianceCTDFTDdata b= new complianceCTDFTDdata();
        database.executeBatch(b);
        test.stopTest();
        
    }

}