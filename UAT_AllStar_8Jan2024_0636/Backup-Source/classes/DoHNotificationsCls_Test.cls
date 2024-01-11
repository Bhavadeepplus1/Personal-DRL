@isTest
public class DoHNotificationsCls_Test {
    static testMethod void testnotifyusers(){
        List<GCP_DOH_Trade_Partner_NDC__c> doHNewRecords = new List<GCP_DOH_Trade_Partner_NDC__c>();
        Product2 productSrx =new Product2(Name='productSRx',Phoenix_Rx_SRx_OTC__c = 'SRx');
        insert productSrx;
        Product2 productRx =new Product2(Name='productRx',Phoenix_Rx_SRx_OTC__c = 'Rx');
        insert productRx;
        GCP_DOH_Trade_Partner_NDC__c doH1Rx = new GCP_DOH_Trade_Partner_NDC__c();
        doH1Rx.Vision_GCP_W4_DOH__c = 10;
        doH1Rx.vision_gcp_w4_day__c = system.today()+10;
        doH1Rx.Product__c = productRx.Id;      
        doHNewRecords.add(doH1Rx);
        GCP_DOH_Trade_Partner_NDC__c doH1SRx = new GCP_DOH_Trade_Partner_NDC__c();
        doH1SRx.Vision_GCP_W4_DOH__c = 10;
        doH1SRx.vision_gcp_w4_day__c = system.today()+10;
        doH1SRx.Product__c = productSrx.Id;      
        doHNewRecords.add(doH1SRx);
        GCP_DOH_Trade_Partner_NDC__c doH2Rx = new GCP_DOH_Trade_Partner_NDC__c();
        doH2Rx.Vision_GCP_W4_DOH__c = 10;
        doH2Rx.vision_gcp_w4_day__c = system.today()+10;
        doH2Rx.Product__c = productRx.Id;      
        doHNewRecords.add(doH2Rx);
        GCP_DOH_Trade_Partner_NDC__c doH2SRx = new GCP_DOH_Trade_Partner_NDC__c();
        doH2SRx.Vision_GCP_W4_DOH__c = 10;
        doH2SRx.vision_gcp_w4_day__c = system.today()+10;
        doH2SRx.Product__c = productSrx.Id;      
        doHNewRecords.add(doH2SRx);
        GCP_DOH_Trade_Partner_NDC__c doH461Rx = new GCP_DOH_Trade_Partner_NDC__c();
        doH461Rx.Vision_GCP_W4_DOH__c = 46;
        doH461Rx.vision_gcp_w4_day__c = system.today()+46;
        doH461Rx.Product__c = productRx.Id;      
        doHNewRecords.add(doH461Rx);
        GCP_DOH_Trade_Partner_NDC__c doH461SRx = new GCP_DOH_Trade_Partner_NDC__c();
        doH461SRx.Vision_GCP_W4_DOH__c = 46;
        doH461SRx.vision_gcp_w4_day__c = system.today()+46;
        doH461SRx.Product__c = productSrx.Id;      
        doHNewRecords.add(doH461SRx);
        GCP_DOH_Trade_Partner_NDC__c doH462Rx = new GCP_DOH_Trade_Partner_NDC__c();
        doH462Rx.Vision_GCP_W4_DOH__c = 46;
        doH462Rx.vision_gcp_w4_day__c = system.today()+46;
        doH462Rx.Product__c = productRx.Id;      
        doHNewRecords.add(doH462Rx);
        GCP_DOH_Trade_Partner_NDC__c doH462SRx = new GCP_DOH_Trade_Partner_NDC__c();
        doH462SRx.Vision_GCP_W4_DOH__c = 46;
        doH462SRx.vision_gcp_w4_day__c = system.today()+46;
        doH462SRx.Product__c = productSrx.Id;      
        doHNewRecords.add(doH462SRx);
        GCP_DOH_Trade_Partner_NDC__c doHw41SRx = new GCP_DOH_Trade_Partner_NDC__c();
        doHw41SRx.Vision_GCP_W4_DOH__c = 46;
        doHw41SRx.vision_gcp_w4_day__c = system.today()+46;
        doHw41SRx.Product__c = productSrx.Id;      
        doHw41SRx.Vision_Gcp_W4_QOH__c = 10000;
        doHw41SRx.vision_gcp_wac_price__c = 10000;
        doHNewRecords.add(doHw41SRx);
        GCP_DOH_Trade_Partner_NDC__c doHw41SRx1 = new GCP_DOH_Trade_Partner_NDC__c();
        doHw41SRx1.Vision_GCP_W4_DOH__c = 35;
        doHw41SRx1.vision_gcp_w4_day__c = system.today()+46;
        doHw41SRx1.Product__c = productSrx.Id;      
        doHw41SRx1.Vision_Gcp_W4_QOH__c = 10000;
        doHw41SRx1.vision_gcp_wac_price__c = 100000;
        doHNewRecords.add(doHw41SRx1);
        insert doHNewRecords;
        
    }
    static testmethod void testDoHNotify(){
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
        List<GCP_DOH_Trade_Partner_NDC__c> gcpList=new List<GCP_DOH_Trade_Partner_NDC__c>();
        List<GCP_DOH_Trade_Partner_NDC__c> gcpList1=new List<GCP_DOH_Trade_Partner_NDC__c>();
        
        GCP_DOH_Trade_Partner_NDC__c ndcDOH = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=12,Product__c=p2.id,Account_Manager__c=UserInfo.getUserId(),vision_gcp_w4_day__c=System.today(),Vision_Gcp_W4_QOH__c=25,vision_gcp_wac_price__c=4000);

        GCP_DOH_Trade_Partner_NDC__c ndcDOH9 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=12,Product__c=p3.id,Account_Manager__c=UserInfo.getUserId(),vision_gcp_w4_day__c=System.today(),Vision_Gcp_W4_QOH__c=25,vision_gcp_wac_price__c=4000);
        GCP_DOH_Trade_Partner_NDC__c ndcDOH10 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=45,Product__c=p3.id,Account_Manager__c=UserInfo.getUserId(),vision_gcp_w4_day__c=System.today(),Vision_Gcp_W4_QOH__c=25,vision_gcp_wac_price__c=4000);
        GCP_DOH_Trade_Partner_NDC__c ndcDOH11 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=45,Product__c=p.id,Account_Manager__c=UserInfo.getUserId(),vision_gcp_w4_day__c=System.today(),Vision_Gcp_W4_QOH__c=25,vision_gcp_wac_price__c=4000);
        GCP_DOH_Trade_Partner_NDC__c ndcDOH12 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=15,Product__c=p3.id,Account_Manager__c=UserInfo.getUserId(),vision_gcp_w4_day__c=System.today(),Vision_Gcp_W4_QOH__c=25,vision_gcp_wac_price__c=4000);
        GCP_DOH_Trade_Partner_NDC__c ndcDOH13 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=15,Product__c=p.id,Account_Manager__c=UserInfo.getUserId(),vision_gcp_w4_day__c=System.today(),Vision_Gcp_W4_QOH__c=25,vision_gcp_wac_price__c=4000);
        GCP_DOH_Trade_Partner_NDC__c ndcDOH14 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=5,Product__c=p2.id,Account_Manager__c=UserInfo.getUserId(),vision_gcp_w4_day__c=System.today(),Vision_Gcp_W4_QOH__c=25,vision_gcp_wac_price__c=4000);
        
        GCP_DOH_Trade_Partner_NDC__c ndcDOH8 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=45,Product__c=p.id,Account_Manager__c=UserInfo.getUserId(),vision_gcp_w4_day__c=System.today(),Vision_Gcp_W4_QOH__c=25,vision_gcp_wac_price__c=4000);
        
        GCP_DOH_Trade_Partner_NDC__c ndcDOH1 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=45,Product__c=p2.id);
        user s=[select id from user where id =: userinfo.getuserid()];
        GCP_DOH_Trade_Partner_NDC__c ndcDOH5 = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test',Vision_GCP_W4_DOH__c=45,Product__c=p3.id);
        String id=UserInfo.getUserId();
        gcpList.add(ndcDOH);
        gcpList.add(ndcDOH9);
        gcpList.add(ndcDOH12);
        gcpList.add(ndcDOH13);
        gcpList.add(ndcDOH14);
        
        insert gcpList;
        gcpList1.add(ndcDOH8);
        gcpList1.add(ndcDOH10);
        
        insert gcpList1;
        
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
        DoHNotificationsCls.notifyUsers(prdOptyMap7,u1,'High Inventory');
    }
}