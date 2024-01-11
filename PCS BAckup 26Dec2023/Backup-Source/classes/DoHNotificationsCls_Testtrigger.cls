@isTest	(SeeAllData=true)
public class DoHNotificationsCls_Testtrigger {

    static testMethod void testnotifyusers(){
        
        List<GCP_DOH_Trade_Partner_NDC__c> doHNewRecords = new List<GCP_DOH_Trade_Partner_NDC__c>(
        
        );
        
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
        //doHw41SRx.Vision_Gcp_W4_QOH__c = 10000;
        doHw41SRx.vision_gcp_wac_price__c = 10000;
      // doHw41SRx.Value_W4__c=100000;
        doHNewRecords.add(doHw41SRx);
         GCP_DOH_Trade_Partner_NDC__c doHw41SRx1 = new GCP_DOH_Trade_Partner_NDC__c();
        doHw41SRx1.Vision_GCP_W4_DOH__c = 35;
        doHw41SRx1.vision_gcp_w4_day__c = system.today()+46;
		doHw41SRx1.Product__c = productSrx.Id;      
       doHw41SRx1.Vision_Gcp_W4_QOH__c = 42;
        doHw41SRx1.vision_gcp_wac_price__c = 1;
      // doHw41SRx.Value_W4__c=100000;
        doHNewRecords.add(doHw41SRx1);

        //Vision_Gcp_W4_QOH__c * vision_gcp_wac_price__c

        insert doHNewRecords;
         Phoenix_Bright_Exceptions__c cc= new  Phoenix_Bright_Exceptions__c();
        cc.Phoenix_Error_Message__c='';
        cc.Phoenix_Method_Name__c='';
        cc.Phoenix_Stack_Trace__c='';
        cc.Phoenix_Class__c='jdud';
        insert cc;
       

        
    }
}