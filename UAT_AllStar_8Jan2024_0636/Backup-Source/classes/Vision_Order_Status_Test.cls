@isTest
public class Vision_Order_Status_Test {
    static testmethod void  test(){
        //Date.newInstance( 2021, 11, 30 );
        Date d1=Date.newInstance(2021,01,01);
        Date d2=Date.newInstance(2021,12,31);
        Date d3=Date.newInstance(2021,01,01);
        Date d4=Date.newInstance(2021,02,01);
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.OwnerId = userInfo.getUserId();
        insert acc;
        String option='Order Date';
        List<String> selection= new List<String>();
        selection.add('Received');
        selection.add('Created');
        selection.add('Shipped');
        selection.add('Delivered');
        
        Product2 p2 = new Product2();
        p2.Family = 'Allopurinol';
        p2.Name = 'Test';
        insert p2;
        
        System.debug('product>>>'+p2);
        Vision_GCP_SFDC_Order_Status__c testOrder= new Vision_GCP_SFDC_Order_Status__c();
        testOrder.Vision_Account__c=acc.Id;
        testOrder.Vision_Order_Number__c='2134';
        testOrder.Vision_PO_Date__c=Date.newInstance( 2021, 11, 30 );
        testOrder.Vision_Delivery_Number__c= null;
        testOrder.Vision_Order_Date__c=Date.newInstance( 2021, 12, 20 );
        //testOrder.Vision_Is_OTIF__c=true;
        testOrder.Vision_PGI_Date__c=d1;
        testOrder.Vision_Product__c=p2.Id;
        testOrder.Vision_PO_Number__c = '12';
        testOrder.Vision_PGI_Date__c=Date.newInstance( 2021, 11, 30 );
        testOrder.Vision_GCP_Ship_Date__c=Date.newInstance( 2021, 11, 30 );
        testOrder.Vision_PGI_Date__c=Date.newInstance( 2021, 12, 10 );
        testOrder.Vision_Requested_Delivery_Date__c = Date.newInstance( 2021, 11, 10 );
        insert testOrder;
        
        Vision_GCP_SFDC_Order_Status__c testOrder2= new Vision_GCP_SFDC_Order_Status__c();
        testOrder2.Vision_Account__c=acc.Id;
        testOrder2.Vision_Order_Number__c='21';
        testOrder2.Vision_PO_Date__c=Date.newInstance( 2021, 11, 30 );
        testOrder2.Vision_Delivery_Number__c='21';
        testOrder.Vision_PGI_Date__c=d1;
        testOrder2.Vision_Product__c=p2.Id;
        testOrder2.Vision_PO_Number__c = '12';
        //testOrder2.Vision_Delivery_Date_Internal_Use__c=Date.newInstance( 2021, 11, 30 );
        testOrder2.Vision_GCP_Ship_Date__c=Date.newInstance( 2021, 11, 30 );
        testOrder2.Vision_PGI_Date__c=Date.newInstance( 2021, 12, 10 );
        testOrder2.Vision_Requested_Delivery_Date__c = Date.newInstance( 2021, 11, 10 );
        
        insert testOrder2;
        
        Vision_GCP_SFDC_Order_Status__c testOrder3= new Vision_GCP_SFDC_Order_Status__c();
        testOrder3.Vision_Product__c=p2.Id;
        testOrder3.Vision_Account__c=acc.Id;
        testOrder3.Vision_Order_Number__c='21';
        testOrder3.Vision_PO_Date__c=d1;//Date.newInstance( 2021, 11, 30 );
        testOrder3.Vision_Delivery_Number__c='123';
        //testOrder.Vision_Delivery_Date_Internal_Use__c=d1;
        testOrder3.Vision_Product__c=p2.Id;
        testOrder3.Vision_PO_Number__c = '12';
        //testOrder3.Vision_Delivery_Date_Internal_Use__c=Date.newInstance( 2021, 11, 30 );
        testOrder3.Vision_GCP_Ship_Date__c=Date.newInstance( 2021, 11, 30 );
        testOrder3.Vision_PGI_Date__c= d1;
        testOrder3.Vision_Requested_Delivery_Date__c = Date.newInstance( 2021, 11, 10 );
        
        insert testOrder3;
        Vision_GCP_SFDC_Order_Status__c testOrder4= new Vision_GCP_SFDC_Order_Status__c();
        testOrder4.Vision_Product__c=p2.Id;
        testOrder4.Vision_Account__c=acc.Id;
        testOrder4.Vision_Order_Number__c='21';
        testOrder4.Vision_PO_Date__c=d1;//Date.newInstance( 2021, 11, 30 );
        testOrder4.Vision_Delivery_Number__c='123';
        //testOrder.Vision_Delivery_Date_Internal_Use__c=d1;
        testOrder4.Vision_Product__c=p2.Id;
        testOrder4.Vision_PO_Number__c = '12';
        //testOrder3.Vision_Delivery_Date_Internal_Use__c=Date.newInstance( 2021, 11, 30 );
        testOrder4.Vision_GCP_Ship_Date__c=Date.newInstance( 2021, 11, 30 );
        testOrder4.Vision_PGI_Date__c= d1;
        testOrder4.Vision_Requested_Delivery_Date__c = Date.newInstance( 2022, 11, 10 );
        
        insert testOrder4;
        cus_ord_trend_dates_info__c dohRepinfo = new  cus_ord_trend_dates_info__c(Vision_GCP_Update_Date__c ='2022-02-11',Vision_Update_Date__c='2022-02-11', Name='Test');
        insert dohRepinfo;
        
        List<Vision_GCP_SFDC_Order_Status__c> testOrderList= new List<Vision_GCP_SFDC_Order_Status__c>();
        testOrderList.add(testOrder);
        testOrderList.add(testOrder2);
        testOrderList.add(testOrder3);
        List<Vision_GCP_SFDC_Order_Status__c> testOrderList1= new List<Vision_GCP_SFDC_Order_Status__c>();
        testOrderList1.add(testOrder4);
        
        //testOrderList.add(dohRepinfo);
        //insert testOrderList;
        System.debug('testOrder>>>'+testOrder);
        System.debug('testOrderList>>>'+testOrderList);
        System.debug('testOrderList SIze>>>'+testOrderList.size());
        System.debug('testOrderList1 SIze>>>'+testOrderList1.size());
        
        
        Map<String,List<Vision_GCP_SFDC_Order_Status__c>>  mapOrdersListFinal = new Map<String,List<Vision_GCP_SFDC_Order_Status__c>>();
        mapOrdersListFinal.put(p2.Name,testOrderList);
        mapOrdersListFinal.put(testOrder3.Vision_Order_Number__c,testorderlist);
        
        
        
        
        //Boolean OpenDelay=false;
        Phoenix_Contract__c contractTest=new Phoenix_Contract__c();
        contractTest.Phoenix_Contract_Number__c='12345';
        insert contractTest;
        
        Vision_Customer_Product_Tracker__c custProd= new Vision_Customer_Product_Tracker__c();
        custProd.Vision_Account__c=acc.Id;
        custProd.Vision_Contract__c=contractTest.Id;
        custProd.Is_Initial_Order__c = true;
        insert custProd;
        List<Vision_Customer_Product_Tracker__c> custProdList= new List<Vision_Customer_Product_Tracker__c>();
        custProdList.add(custProd);
        //cus_ord_trend_dates_info__c cusinfo = new  cus_ord_trend_dates_info__c(Vision_Update_Date__c ='2022-02-11',Vision_GCP_Update_Date__c='2022-03-20', Name='Test');
        // insert cusinfo;
        Map<String, List<Vision_GCP_SFDC_Order_Status__c>> innerMap = new Map<String, List<Vision_GCP_SFDC_Order_Status__c>>();
        innermap.put('21', testorderlist);
        Map<String, List<Vision_GCP_SFDC_Order_Status__c>> mapOrdersList = new Map<String, List<Vision_GCP_SFDC_Order_Status__c>>();
        mapOrdersList.put('21', testorderlist);
        
        
        String searchText = 'Allopurinol';
        String searchCustText = 'Cardinal';
        
        Vision_Order_Status.getCustomerOrdersData(acc.Id,option,Date.newInstance( 2021, 11, 30 ),Date.newInstance( 2021, 11, 30 ),'Vision_Delivery_Date_Internal_Use__c',selection,'Allop','Cardinal','First','302302302', '302302310', true);
        Vision_Order_Status.getCustomerOrdersData(acc.Id,option,Date.newInstance( 2021, 11, 30 ),Date.newInstance( 2021, 11, 30 ),'Vision_Delivery_Date_Internal_Use__c',selection,'Allop','Cardinal','Next','302302302', '302302310', true);
        Vision_Order_Status.getCustomerOrdersData(acc.Id,option,Date.newInstance( 2021, 11, 30 ),Date.newInstance( 2021, 11, 30 ),'Vision_Delivery_Date_Internal_Use__c',selection,'Allop','Cardinal','Previous','302302302', '302302310', true);
        Vision_Order_Status.getCustomerOrdersData(acc.Id,option,Date.newInstance( 2021, 11, 30 ),Date.newInstance( 2021, 11, 30 ),'Vision_Delivery_Date_Internal_Use__c',selection,'Allop','Cardinal','Last','302302302', '302302310', true);
        Vision_Order_Status.getCustomerOrdersData(acc.Id,option,d1,d2,'Vision_PO_Date__c',selection,'Allop','Cardinal','First','302302302', '302302310', false);
        Vision_Order_Status.getCustomerOrdersData(acc.Id,option,d1,d2,'Vision_PO_Date__c',selection,'Allop','Cardinal','Next','302302302', '302302310', false);
        Vision_Order_Status.getCustomerOrdersData(acc.Id,option,d1,d2,'Vision_PO_Date__c',selection,'Allop','Cardinal','Previous','302302302', '302302310', false);
        Vision_Order_Status.getCustomerOrdersData(acc.Id,option,d1,d2,'Vision_PO_Date__c',selection,'Allop','Cardinal','Last','302302302', '302302310', false);
        Vision_Order_Status.getCustomerOrdersData(acc.Id,option,d1,d2,'Vision_Order_Date__c',selection,'Allop','Cardinal','First','302302302', '302302310', false);
        Vision_Order_Status.getCustomerOrdersData(acc.Id,option,d1,d2,'Vision_Order_Date__c',selection,'Allop','Cardinal','Next','302302302', '302302310', false);
        Vision_Order_Status.getCustomerOrdersData(acc.Id,option,d1,d2,'Vision_Order_Date__c',selection,'Allop','Cardinal','Previous','302302302', '302302310', false);
        Vision_Order_Status.getCustomerOrdersData(acc.Id,option,d1,d2,'Vision_Order_Date__c',selection,'Allop','Cardinal','Last','302302302', '302302310', false);
        Vision_Order_Status.getCustomerOrdersData(acc.Id,option,d1,d2,'Vision_GCP_Ship_Date__c',selection,'Allop','Cardinal','First','302302302', '302302310', true);
        Vision_Order_Status.getCustomerOrdersData(acc.Id,option,d1,d2,'Vision_GCP_Ship_Date__c',selection,'Allop','Cardinal','Next','302302302', '302302310', true);
        Vision_Order_Status.getCustomerOrdersData(acc.Id,option,d1,d2,'Vision_GCP_Ship_Date__c',selection,'Allop','Cardinal','Previous','302302302', '302302310', true);
        Vision_Order_Status.getCustomerOrdersData(acc.Id,option,d1,d2,'Vision_GCP_Ship_Date__c',selection,'Allop','Cardinal','Last','302302302', '302302310', true);
        
        Vision_Order_Status.getOTIFData(acc.Id,d1,d2,'Vision_Delivery_Date_Internal_Use__c','Allop','Cardinal','First','302302302', '302302310');
        Vision_Order_Status.getOTIFData(acc.Id,d1,d2,'Vision_Delivery_Date_Internal_Use__c','Allop','Cardinal','Next','302302302', '302302310');
        Vision_Order_Status.getOTIFData(acc.Id,d1,d2,'Vision_Delivery_Date_Internal_Use__c','Allop','Cardinal','Previous','302302302', '302302310');
        Vision_Order_Status.getOTIFData(acc.Id,d1,d2,'Vision_Delivery_Date_Internal_Use__c','Allop','Cardinal','Last','302302302', '302302310');
        Vision_Order_Status.getOTIFData(acc.Id,d1,d2,'Vision_PO_Date__c','Allop','Cardinal','First','302302302', '302302310');
        Vision_Order_Status.getOTIFData(acc.Id,d1,d2,'Vision_PO_Date__c','Allop','Cardinal','Next','302302302', '302302310');
        Vision_Order_Status.getOTIFData(acc.Id,d1,d2,'Vision_PO_Date__c','Allop','Cardinal','Previous','302302302', '302302310');
        Vision_Order_Status.getOTIFData(acc.Id,d1,d2,'Vision_PO_Date__c','Allop','Cardinal','Last','302302302', '302302310');
        Vision_Order_Status.getOTIFData(acc.Id,d1,d2,'Vision_Order_Date__c','Allop','Cardinal','First','302302302', '302302310');
        Vision_Order_Status.getOTIFData(acc.Id,d1,d2,'Vision_Order_Date__c','Allop','Cardinal','Next','302302302', '302302310');
        Vision_Order_Status.getOTIFData(acc.Id,d1,d2,'Vision_Order_Date__c','Allop','Cardinal','Previous','302302302', '302302310');
        Vision_Order_Status.getOTIFData(acc.Id,d1,d2,'Vision_Order_Date__c','Allop','Cardinal','Last','302302302', '302302310');
        Vision_Order_Status.getOTIFData(acc.Id,d1,d2,'Vision_GCP_Ship_Date__c','Allop','Cardinal','First','302302302', '302302310');
        Vision_Order_Status.getOTIFData(acc.Id,d1,d2,'Vision_GCP_Ship_Date__c','Allop','Cardinal','Next','302302302', '302302310');
        Vision_Order_Status.getOTIFData(acc.Id,d1,d2,'Vision_GCP_Ship_Date__c','Allop','Cardinal','Previous','302302302', '302302310');
        Vision_Order_Status.getOTIFData(acc.Id,d1,d2,'Vision_GCP_Ship_Date__c','Allop','Cardinal','Last','302302302', '302302310');
    }    
    static testmethod void  test1(){
        //Date.newInstance( 2021, 11, 30 );
        Date d1=Date.newInstance(2021,01,01);
        Date d2=Date.newInstance(2021,12,31);
        Date d3=Date.newInstance(2021,01,01);
        Date d4=Date.newInstance(2021,02,01);
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.OwnerId = userInfo.getUserId();
        insert acc;
        String option='Order Date';
        List<String> selection= new List<String>();
        selection.add('Received');
        selection.add('Created');
        selection.add('Shipped');
        selection.add('Delivered');
        
        Product2 p2 = new Product2();
        p2.Family = 'Allopurinol';
        p2.Name = 'Test';
        insert p2;
        
        System.debug('product>>>'+p2);
        Vision_GCP_SFDC_Order_Status__c testOrder= new Vision_GCP_SFDC_Order_Status__c();
        testOrder.Vision_Account__c=acc.Id;
        testOrder.Vision_Order_Number__c='2134';
        testOrder.Vision_PO_Date__c=Date.newInstance( 2021, 11, 30 );
        testOrder.Vision_Delivery_Number__c= null;
        testOrder.Vision_Order_Date__c=Date.newInstance( 2021, 12, 20 );
        //testOrder.Vision_Is_OTIF__c=true;
        testOrder.Vision_PGI_Date__c=d1;
        testOrder.Vision_Product__c=p2.Id;
        testOrder.Vision_PO_Number__c = '12';
        testOrder.Vision_PGI_Date__c=Date.newInstance( 2021, 11, 30 );
        testOrder.Vision_GCP_Ship_Date__c=Date.newInstance( 2021, 11, 30 );
        testOrder.Vision_PGI_Date__c=Date.newInstance( 2021, 12, 10 );
        testOrder.Vision_Requested_Delivery_Date__c = Date.newInstance( 2021, 11, 10 );
        insert testOrder;
        
        Vision_GCP_SFDC_Order_Status__c testOrder2= new Vision_GCP_SFDC_Order_Status__c();
        testOrder2.Vision_Account__c=acc.Id;
        testOrder2.Vision_Order_Number__c='21';
        testOrder2.Vision_PO_Date__c=Date.newInstance( 2021, 11, 30 );
        testOrder2.Vision_Delivery_Number__c='21';
        testOrder.Vision_PGI_Date__c=d1;
        testOrder2.Vision_Product__c=p2.Id;
        testOrder2.Vision_PO_Number__c = '12';
        //testOrder2.Vision_Delivery_Date_Internal_Use__c=Date.newInstance( 2021, 11, 30 );
        testOrder2.Vision_GCP_Ship_Date__c=Date.newInstance( 2021, 11, 30 );
        testOrder2.Vision_PGI_Date__c=Date.newInstance( 2021, 12, 10 );
        testOrder2.Vision_Requested_Delivery_Date__c = Date.newInstance( 2021, 11, 10 );
        
        insert testOrder2;
        
        Vision_GCP_SFDC_Order_Status__c testOrder3= new Vision_GCP_SFDC_Order_Status__c();
        testOrder3.Vision_Product__c=p2.Id;
        testOrder3.Vision_Account__c=acc.Id;
        testOrder3.Vision_Order_Number__c='21';
        testOrder3.Vision_PO_Date__c=d1;//Date.newInstance( 2021, 11, 30 );
        testOrder3.Vision_Delivery_Number__c='123';
        //testOrder.Vision_Delivery_Date_Internal_Use__c=d1;
        testOrder3.Vision_Product__c=p2.Id;
        testOrder3.Vision_PO_Number__c = '12';
        //testOrder3.Vision_Delivery_Date_Internal_Use__c=Date.newInstance( 2021, 11, 30 );
        testOrder3.Vision_GCP_Ship_Date__c=Date.newInstance( 2021, 11, 30 );
        testOrder3.Vision_PGI_Date__c= d1;
        testOrder3.Vision_Requested_Delivery_Date__c = Date.newInstance( 2021, 11, 10 );
        
        insert testOrder3;
        Vision_GCP_SFDC_Order_Status__c testOrder4= new Vision_GCP_SFDC_Order_Status__c();
        testOrder4.Vision_Product__c=p2.Id;
        testOrder4.Vision_Account__c=acc.Id;
        testOrder4.Vision_Order_Number__c='21';
        testOrder4.Vision_PO_Date__c=d1;//Date.newInstance( 2021, 11, 30 );
        testOrder4.Vision_Delivery_Number__c='123';
        //testOrder.Vision_Delivery_Date_Internal_Use__c=d1;
        testOrder4.Vision_Product__c=p2.Id;
        testOrder4.Vision_PO_Number__c = '12';
        //testOrder3.Vision_Delivery_Date_Internal_Use__c=Date.newInstance( 2021, 11, 30 );
        testOrder4.Vision_GCP_Ship_Date__c=Date.newInstance( 2021, 11, 30 );
        testOrder4.Vision_PGI_Date__c= d1;
        testOrder4.Vision_Requested_Delivery_Date__c = Date.newInstance( 2022, 11, 10 );
        
        insert testOrder4;
        cus_ord_trend_dates_info__c dohRepinfo = new  cus_ord_trend_dates_info__c(Vision_GCP_Update_Date__c ='2022-02-11',Vision_Update_Date__c='2022-02-11', Name='Test');
        insert dohRepinfo;
        
        List<Vision_GCP_SFDC_Order_Status__c> testOrderList= new List<Vision_GCP_SFDC_Order_Status__c>();
        testOrderList.add(testOrder);
        testOrderList.add(testOrder2);
        testOrderList.add(testOrder3);
        List<Vision_GCP_SFDC_Order_Status__c> testOrderList1= new List<Vision_GCP_SFDC_Order_Status__c>();
        testOrderList1.add(testOrder4);
        
        //testOrderList.add(dohRepinfo);
        //insert testOrderList;
        System.debug('testOrder>>>'+testOrder);
        System.debug('testOrderList>>>'+testOrderList);
        System.debug('testOrderList SIze>>>'+testOrderList.size());
        System.debug('testOrderList1 SIze>>>'+testOrderList1.size());
        
        
        Map<String,List<Vision_GCP_SFDC_Order_Status__c>>  mapOrdersListFinal = new Map<String,List<Vision_GCP_SFDC_Order_Status__c>>();
        mapOrdersListFinal.put(p2.Name,testOrderList);
        mapOrdersListFinal.put(testOrder3.Vision_Order_Number__c,testorderlist);
        
        
        
        
        //Boolean OpenDelay=false;
        Phoenix_Contract__c contractTest=new Phoenix_Contract__c();
        contractTest.Phoenix_Contract_Number__c='12345';
        insert contractTest;
        
        Vision_Customer_Product_Tracker__c custProd= new Vision_Customer_Product_Tracker__c();
        custProd.Vision_Account__c=acc.Id;
        custProd.Vision_Contract__c=contractTest.Id;
        custProd.Is_Initial_Order__c = true;
        insert custProd;
        List<Vision_Customer_Product_Tracker__c> custProdList= new List<Vision_Customer_Product_Tracker__c>();
        custProdList.add(custProd);
        //cus_ord_trend_dates_info__c cusinfo = new  cus_ord_trend_dates_info__c(Vision_Update_Date__c ='2022-02-11',Vision_GCP_Update_Date__c='2022-03-20', Name='Test');
        // insert cusinfo;
        Map<String, List<Vision_GCP_SFDC_Order_Status__c>> innerMap = new Map<String, List<Vision_GCP_SFDC_Order_Status__c>>();
        innermap.put('21', testorderlist);
        Map<String, List<Vision_GCP_SFDC_Order_Status__c>> mapOrdersList = new Map<String, List<Vision_GCP_SFDC_Order_Status__c>>();
        mapOrdersList.put('21', testorderlist);
        
        Vision_Order_Status.getDelayedOrderData(acc.Id,d1,d2,'Vision_PO_Date__c','Allop','Cardinal',true,'First','302302302', '302302310');
        Vision_Order_Status.getDelayedOrderData(acc.Id,d1,d2,'Vision_PO_Date__c','Allop','Cardinal',false,'Next','302302302', '302302310');
        Vision_Order_Status.getDelayedOrderData(acc.Id,d1,d2,'Vision_Order_Date__c','Allop','Cardinal',true,'Previous','302302302', '302302310');
        Vision_Order_Status.getDelayedOrderData(acc.Id,d1,d2,'Vision_Order_Date__c','Allop','Cardinal',false,'Last','302302302', '302302310');
        Vision_Order_Status.getDelayedOrderData(acc.Id,d1,d2,'Vision_GCP_Ship_Date__c','Allop','Cardinal',true,'First','302302302', '302302310');
        Vision_Order_Status.getDelayedOrderData(acc.Id,d1,d2,'Vision_GCP_Ship_Date__c','Allop','Cardinal',false,'Next','302302302', '302302310');
        Vision_Order_Status.getDelayedOrderData(acc.Id,d1,d2,'Vision_Delivery_Date_Internal_Use__c','Allop','Cardinal',true,'','302302302', '302302310');
        // Vision_Order_Status.getIntitalOrders(contractTest.Id,acc.Id,true,'Vision_Awarded_Volume__c');
        Vision_Order_Status.getRelatedOrders('OpenDelayed', '2134', acc.Id,d3,d4,'Vision_PO_Date__c','Allop','Test',true,true);
        Vision_Order_Status.getRelatedOrders('OpenDelayed', '2134', acc.Id,d3,d4,'Vision_PO_Date__c','Allop','Test',false,false);
        Vision_Order_Status.getRelatedOrders('OpenDelayed', '2134', acc.Id,d3,d4,'Vision_Order_Date__c','Allop','Test',true,true);
        Vision_Order_Status.getRelatedOrders('OpenDelayed', '2134', acc.Id,d3,d4,'Vision_Order_Date__c','Allop','Test',false,false);
        Vision_Order_Status.getRelatedOrders('OpenDelayed', '2134', acc.Id,d3,d4,'Vision_GCP_Ship_Date__c','Allop','Test',true,true);
        Vision_Order_Status.getRelatedOrders('OpenDelayed', '2134', acc.Id,d3,d4,'Vision_GCP_Ship_Date__c','Allop','Test',false,false);
        Vision_Order_Status.getRelatedOrders('OpenDelayed', '2134', acc.Id,d3,d4,'Vision_Delivery_Date_Internal_Use__c','Allop','Test',true,true);
        Vision_Order_Status.getRelatedOrders('OpenDelayed', '2134', acc.Id,d3,d4,'Vision_Delivery_Date_Internal_Use__c','Allop','Test',false,false);
        Vision_Order_Status.getRelatedOrders('OTIF', '2134', acc.Id,d3,d4,'Vision_PO_Date__c','Allop','Test',true,true);
        Vision_Order_Status.getRelatedOrders('OTIF', '2134', acc.Id,d3,d4,'Vision_PO_Date__c','Allop','Test',false,false);
        Vision_Order_Status.getRelatedOrders('OTIF', '2134', acc.Id,d3,d4,'Vision_Order_Date__c','Allop','Test',true,true);
        Vision_Order_Status.getRelatedOrders('OTIF', '2134', acc.Id,d3,d4,'Vision_Order_Date__c','Allop','Test',false,false);
        Vision_Order_Status.getRelatedOrders('OTIF', '2134', acc.Id,d3,d4,'Vision_GCP_Ship_Date__c','Allop','Test',true,true);
        Vision_Order_Status.getRelatedOrders('OTIF', '2134', acc.Id,d3,d4,'Vision_GCP_Ship_Date__c','Allop','Test',false,false);
        Vision_Order_Status.getRelatedOrders('OTIF', '2134', acc.Id,d3,d4,'Vision_Delivery_Date_Internal_Use__c','Allop','Test',true,true);
        Vision_Order_Status.getRelatedOrders('OTIF', '2134', acc.Id,d3,d4,'Vision_Delivery_Date_Internal_Use__c','Allop','Test',false,false);
        Vision_Order_Status.getRelatedOrders('Analysis', '2134', acc.Id,d3,d4,'Vision_PO_Date__c','Allop','Test',true,true);
        Vision_Order_Status.getRelatedOrders('Analysis', '2134', acc.Id,d3,d4,'Vision_PO_Date__c','Allop','Test',false,false);
        Vision_Order_Status.getRelatedOrders('Analysis', '2134', acc.Id,d3,d4,'Vision_Order_Date__c','Allop','Test',true,true);
        Vision_Order_Status.getRelatedOrders('Analysis', '2134', acc.Id,d3,d4,'Vision_Order_Date__c','Allop','Test',false,false);
        Vision_Order_Status.getRelatedOrders('Analysis', '2134', acc.Id,d3,d4,'Vision_GCP_Ship_Date__c','Allop','Test',true,true);
        Vision_Order_Status.getRelatedOrders('Analysis', '2134', acc.Id,d3,d4,'Vision_GCP_Ship_Date__c','Allop','Test',false,false);
        Vision_Order_Status.getRelatedOrders('Analysis', '2134', acc.Id,d3,d4,'Vision_Delivery_Date_Internal_Use__c','Allop','Test',true,true);
        Vision_Order_Status.getRelatedOrders('Analysis', '2134', acc.Id,d3,d4,'Vision_Delivery_Date_Internal_Use__c','Allop','Test',false,false);
        Vision_Order_Status.updateInitialOrderComments('Test Comment', custProd);
        Vision_Order_Status.updateInitialOrderComments(null, custProd);
    }
}