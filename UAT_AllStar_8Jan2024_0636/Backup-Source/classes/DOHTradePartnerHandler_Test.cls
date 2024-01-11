@istest
public class DOHTradePartnerHandler_Test {
    static testmethod void test(){
        GCP_DOH_Trade_Partner_NDC__c testvar= new GCP_DOH_Trade_Partner_NDC__c();
         GCP_DOH_Trade_Partner_NDC__c testvar1= new GCP_DOH_Trade_Partner_NDC__c();
         GCP_DOH_Trade_Partner_NDC__c testvar2= new GCP_DOH_Trade_Partner_NDC__c();
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
        p.Phoenix_Rx_SRx_OTC__c='Rx';
        insert p;
        /* Product2 p2=new Product2();
        p2p3.Name='abc pharma';
        p2.Phoenix_NDC_11__c='23364848';
        p2.ProductCode='123566';
        p2.Phoenix_NDC__c='5555555';
        p2.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p2.Family = 'Test Family';
        p2.Phoenix_Throughput_cost__c=10.23456576;
        p2.Phoenix_GCN_Sequence_Number__c='666666';
        p2.Phoenix_Pkg_Size__c=25.0;
        p2.Phoenix_Rx_SRx_OTC__c='Rx';
        insert p2;*/
           Product2 p3=new Product2();
        p3.Name='abc pharma';
        p3.Phoenix_NDC_11__c='23364848';
        p3.ProductCode='123566';
        p3.Phoenix_NDC__c='5555555';
        p3.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p3.Family = 'Test Family';
        p3.Phoenix_Throughput_cost__c=10.23456576;
        p3.Phoenix_GCN_Sequence_Number__c='666666';
        p3.Phoenix_Pkg_Size__c=25.0;
        p3.Phoenix_Rx_SRx_OTC__c='SRx';
        insert p3;
         Product2 p2=new Product2();
        p2.Name='abc pharma';
        p2.Phoenix_NDC_11__c='23364848';
        p2.ProductCode='123566';
        p2.Phoenix_NDC__c='5555555';
        p2.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p2.Family = 'Test Family';
        p2.Phoenix_Throughput_cost__c=10.23456576;
        p2.Phoenix_GCN_Sequence_Number__c='666666';
        p2.Phoenix_Pkg_Size__c=25.0;
        p2.Phoenix_Rx_SRx_OTC__c='Rx';
        insert p2;
        user u =[select id from user where id=: UserInfo.getUserId()];
        /*testvar.Product__c=p.id;
        testvar.Vision_GCP_W4_DOH__c=11;
        testvar.Account_Manager__c=u.id;
        
        testvar.vision_gcp_trade_partner_name__c='test';
        insert testvar;
        testvar1.Product__c=p1.id;
        testvar1.Vision_GCP_W4_DOH__c=11;
        testvar1.Account_Manager__c=u.id;
        
        
        testvar1.vision_gcp_trade_partner_name__c='test1';
        insert testvar1;*/
        List<GCP_DOH_Trade_Partner_NDC__c> gcpList=new List<GCP_DOH_Trade_Partner_NDC__c>();
                List<GCP_DOH_Trade_Partner_NDC__c> gcpList1=new List<GCP_DOH_Trade_Partner_NDC__c>();
        // Vision_Gcp_W4_QOH__c * vision_gcp_wac_price__c

        GCP_DOH_Trade_Partner_NDC__c ndcDOH = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=12,Product__c=p2.id,Account_Manager__c=UserInfo.getUserId(),vision_gcp_w4_day__c=System.today(),Vision_Gcp_W4_QOH__c=25,vision_gcp_wac_price__c=4000);
        System.debug('ndcDOOH>>>'+ndcDOH);
                GCP_DOH_Trade_Partner_NDC__c ndcDOH9 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=12,Product__c=p3.id,Account_Manager__c=UserInfo.getUserId(),vision_gcp_w4_day__c=System.today(),Vision_Gcp_W4_QOH__c=25,vision_gcp_wac_price__c=4000);
                GCP_DOH_Trade_Partner_NDC__c ndcDOH10 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=45,Product__c=p3.id,Account_Manager__c=UserInfo.getUserId(),vision_gcp_w4_day__c=System.today(),Vision_Gcp_W4_QOH__c=25,vision_gcp_wac_price__c=4000);
                GCP_DOH_Trade_Partner_NDC__c ndcDOH11 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=45,Product__c=p.id,Account_Manager__c=UserInfo.getUserId(),vision_gcp_w4_day__c=System.today(),Vision_Gcp_W4_QOH__c=25,vision_gcp_wac_price__c=4000);
                GCP_DOH_Trade_Partner_NDC__c ndcDOH12 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=15,Product__c=p3.id,Account_Manager__c=UserInfo.getUserId(),vision_gcp_w4_day__c=System.today(),Vision_Gcp_W4_QOH__c=25,vision_gcp_wac_price__c=4000);
                GCP_DOH_Trade_Partner_NDC__c ndcDOH13 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=15,Product__c=p.id,Account_Manager__c=UserInfo.getUserId(),vision_gcp_w4_day__c=System.today(),Vision_Gcp_W4_QOH__c=25,vision_gcp_wac_price__c=4000);
                GCP_DOH_Trade_Partner_NDC__c ndcDOH14 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=5,Product__c=p2.id,Account_Manager__c=UserInfo.getUserId(),vision_gcp_w4_day__c=System.today(),Vision_Gcp_W4_QOH__c=25,vision_gcp_wac_price__c=4000);

                GCP_DOH_Trade_Partner_NDC__c ndcDOH8 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=45,Product__c=p.id,Account_Manager__c=UserInfo.getUserId(),vision_gcp_w4_day__c=System.today(),Vision_Gcp_W4_QOH__c=25,vision_gcp_wac_price__c=4000);

        //insert ndcDOH;
        GCP_DOH_Trade_Partner_NDC__c ndcDOH1 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=45,Product__c=p2.id);
        // GCP_DOH_Trade_Partner_NDC__c ndcDOH3 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=45,Product__c=p1.id);
//insert ndcDOH1;
        // GCP_DOH_Trade_Partner_NDC__c ndcDOH2 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=4,Product__c=p1.id);
        //GCP_DOH_Trade_Partner_NDC__c ndcDOH4 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=4,Product__c=p3.id);
//insert ndcDOH2;
  user s=[select id from user where id =: userinfo.getuserid()];
 GCP_DOH_Trade_Partner_NDC__c ndcDOH5 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=45,Product__c=p3.id);
// GCP_DOH_Trade_Partner_NDC__c ndcDOH6 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_Gcp_W4_QOH__c =100,vision_gcp_wac_price__c=10000,Product__c=p1.id);
   //GCP_DOH_Trade_Partner_NDC__c ndcDOH7 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=45,Vision_Gcp_W4_QOH__c =100,vision_gcp_wac_price__c=10000,Product__c=p3.id);      
        String id=UserInfo.getUserId();
       //ndcDOH7.Account_Manager__c=id;//'00501000001y3nGAAQ';
        //ndcDOH7.vision_gcp_w4_day__c=system.today();
        gcpList.add(ndcDOH);
        gcpList.add(ndcDOH9);
                gcpList.add(ndcDOH12);
         gcpList.add(ndcDOH13);
        gcpList.add(ndcDOH14);

        //gcpList.add(ndcDOH8);
        //gcpList.add(ndcDOH2);
         //gcpList.add(ndcDOH3);
       // gcpList.add(ndcDOH4);
       // gcpList.add(ndcDOH5);
        //gcpList.add(ndcDOH6);
           //gcpList.add(ndcDOH7);
        
        insert gcpList;
         gcpList1.add(ndcDOH8);
                 gcpList1.add(ndcDOH10);

        //gcpList.add(ndcDOH2);
         //gcpList.add(ndcDOH3);
       // gcpList.add(ndcDOH4);
       // gcpList.add(ndcDOH5);
        //gcpList.add(ndcDOH6);
           //gcpList.add(ndcDOH7);
        
        insert gcpList1;
        
         //system.debug('testvar1>>>'+testvar1);
        system.debug('gcpList>>>'+gcpList);
        /*testvar2.Product__c=p2.id;
        testvar2.Vision_GCP_W4_DOH__c=11;
        testvar2.Account_Manager__c=u.id;
        
        testvar2.vision_gcp_trade_partner_name__c='test2';
        insert testvar2;*/
         //DOHTradePartnerHander c= new  DOHTradePartnerHander();
        // c.afterInsert();
         
         //DOHTradePartnerHander b= new  DOHTradePartnerHander();
         //TriggerHandler t= new TriggerHandler();
        // t.run();
        // Vision_Gcp_W4_QOH__c * vision_gcp_wac_price__c

         Map<String, List<GCP_DOH_Trade_Partner_NDC__c>> prdOptyMap = new Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>{'Rx' => gcpList};
                      Map<String, List<GCP_DOH_Trade_Partner_NDC__c>> prdOptyMap6 = new Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>{'SRx' => gcpList};
                      Map<String, List<GCP_DOH_Trade_Partner_NDC__c>> prdOptyMap8 = new Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>{'SRx' => gcpList1};

             Map<String, List<GCP_DOH_Trade_Partner_NDC__c>> prdOptyMap2 = new Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>{'Rx' => gcpList1};
                 Map<String, Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>> mapOfLowInventory = new Map<String, Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>>{'test' => prdOptyMap};

   Map<String,Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>>  prdOptyMap1 = new Map<String, Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>>{'test' => prdOptyMap};
   Map<String,Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>>  prdOptyMap3 = new Map<String, Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>>{'test' => prdOptyMap2};
          Map<String,Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>>  prdOptyMap5 = new Map<String, Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>>{'test' => prdOptyMap6};
          Map<String,Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>>  prdOptyMap7 = new Map<String, Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>>{'test' => prdOptyMap8};

String u1=UserInfo.getUserId();
        System.debug('prdOptyMap1>>>'+prdOptyMap1);
         //DoHNotificationsCls.notifyUsers(prdOptyMap1,u1,'Low Inventory');
                // DoHNotificationsCls.notifyUsers(prdOptyMap5,u1,'Low Inventory');

        //DoHNotificationsCls.notifyUsers(prdOptyMap3,u1,'Low Inventory');
       // DoHNotificationsCls.notifyUsers(prdOptyMap7,u1,'High Inventory');
       // DoHNotificationsCls.notifyUsers(prdOptyMap5,u1,'High Value');
         //DoHNotificationsCls.notifyUsers(prdOptyMap1,u1,'High Inventory');
      
       
         
       
        
        
        
    }

}