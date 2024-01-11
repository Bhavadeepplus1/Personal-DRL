@isTest(seeAllData=true)
public class Vision_DoH_High_Inventory_cls_Test {
    static testmethod void  test(){
        

        
        GCP_DOH_Trade_Partner_NDC__c tradeDoH= new GCP_DOH_Trade_Partner_NDC__c();
        tradeDoH.vision_gcp_trade_partner_name__c='test Trade';
        tradeDOH.Vision_GCP_W4_DOH__c=50;  
        insert tradeDoH;
        
        GCP_DOH_Trade_Partner_NDC__c ndcDOH= new GCP_DOH_Trade_Partner_NDC__c();
        ndcDOH.vision_gcp_trade_partner_name__c='test Trade';
        ndcDOH.Vision_GCP_W4_DOH__c=50;
        ndcDoH.vision_gcp_package_description__c='abc';
        insert ndcDOH;
        
        List<GCP_DOH_Trade_Partner_NDC__c> ndcList = new List<GCP_DOH_Trade_Partner_NDC__c>{ndcDOH};
            
        doh_report_dates_info__c dohRepinfo = new  doh_report_dates_info__c(Vision_Update_Date__c ='2022-02-11', Name='Test');
        insert dohRepinfo;
        string customer = 'test';
        
        List<String> productType=new List<String> {'Rx','SRx','OTC'};
        List<String> productType1=new List<String> ();    
            
            Vision_DoH_High_Inventory_cls.getAccountGroups();
        
        Vision_DoH_High_Inventory_cls.getDoHData('test Trade',productType,true, true);
        Vision_DoH_High_Inventory_cls.getDoHData('test Trade',productType,true, false);
        Vision_DoH_High_Inventory_cls.getDoHData('test Trade',productType,false, true);   
        Vision_DoH_High_Inventory_cls.getDoHData('test Trade',productType,false, false);
        
        Vision_DoH_High_Inventory_cls.getDoHData('test Trade',productType1,true, true);
        Vision_DoH_High_Inventory_cls.getDoHData('test Trade',productType1,true, false);
        Vision_DoH_High_Inventory_cls.getDoHData('test Trade',productType1,false, true);   
        Vision_DoH_High_Inventory_cls.getDoHData('test Trade',productType1,false, false);
        
        Vision_DoH_High_Inventory_cls.getFilterDoHData('test Trade','abc',productType,true,true);
        Vision_DoH_High_Inventory_cls.getFilterDoHData('test Trade','abc',productType,true,false); 
        Vision_DoH_High_Inventory_cls.getFilterDoHData('test Trade','abc',productType,false,true); 
        Vision_DoH_High_Inventory_cls.getFilterDoHData('test Trade','abc',productType,false,false); 
        
        Vision_DoH_High_Inventory_cls.getFilterDoHData('test Trade','abc',productType1,true,true);
        Vision_DoH_High_Inventory_cls.getFilterDoHData('test Trade','abc',productType1,true,false); 
        Vision_DoH_High_Inventory_cls.getFilterDoHData('test Trade','abc',productType1,false,true); 
        Vision_DoH_High_Inventory_cls.getFilterDoHData('test Trade','abc',productType1,false,false); 
        
        
        
        Vision_DoH_High_Inventory_cls.fetchSortResults('vision_gcp_trade_partner_name__c', 'abc',true,ndcList,'tradePartnerName',productType,true,true);
         Vision_DoH_High_Inventory_cls.fetchSortResults('vision_gcp_trade_partner_name__c', 'abc',true,ndcList,'tradePartnerName',productType,true,false); 
        Vision_DoH_High_Inventory_cls.fetchSortResults('vision_gcp_trade_partner_name__c', 'abc',true,ndcList,'tradePartnerName',productType,false,true);
         Vision_DoH_High_Inventory_cls.fetchSortResults('vision_gcp_trade_partner_name__c', 'abc',true,ndcList,'tradePartnerName',productType,false,false);
        
        Vision_DoH_High_Inventory_cls.fetchSortResults('vision_gcp_trade_partner_name__c', 'abc',true,ndcList,'tradePartnerName',productType1,true,true);
         Vision_DoH_High_Inventory_cls.fetchSortResults('vision_gcp_trade_partner_name__c', 'abc',true,ndcList,'tradePartnerName',productType1,true,false); 
        Vision_DoH_High_Inventory_cls.fetchSortResults('vision_gcp_trade_partner_name__c', 'abc',true,ndcList,'tradePartnerName',productType1,false,true);
         Vision_DoH_High_Inventory_cls.fetchSortResults('vision_gcp_trade_partner_name__c', 'abc',true,ndcList,'tradePartnerName',productType1,false,false);
    }
    
     static testmethod void  test1(){
         
  GCP_DOH_Trade_Partner_NDC__c tradeDoH= new GCP_DOH_Trade_Partner_NDC__c();
        tradeDoH.vision_gcp_trade_partner_name__c='test Trade';
        tradeDOH.Vision_GCP_W4_DOH__c=50;  
        insert tradeDoH;
        
        GCP_DOH_Trade_Partner_NDC__c ndcDOH= new GCP_DOH_Trade_Partner_NDC__c();
        ndcDOH.vision_gcp_trade_partner_name__c='test Trade';
        ndcDOH.Vision_GCP_W4_DOH__c=50;
        ndcDoH.vision_gcp_package_description__c='abc';
        insert ndcDOH;
        
        List<GCP_DOH_Trade_Partner_NDC__c> ndcList = new List<GCP_DOH_Trade_Partner_NDC__c>{ndcDOH};
            
        doh_report_dates_info__c dohRepinfo = new  doh_report_dates_info__c(Vision_Update_Date__c ='2022-02-11', Name='Test');
        insert dohRepinfo;
        string customer = 'test';
        
        List<String> productType=new List<String> {'Rx','SRx','OTC'};
        List<String> productType1=new List<String> ();    
         
        /* Vision_DoH_High_Inventory_cls.getFilterDoHData('test Trade','',productType,true,true);
        Vision_DoH_High_Inventory_cls.getFilterDoHData('test Trade','',productType,true,false); 
        Vision_DoH_High_Inventory_cls.getFilterDoHData('test Trade','',productType,false,true); 
        Vision_DoH_High_Inventory_cls.getFilterDoHData('test Trade','',productType,false,false);
        
        Vision_DoH_High_Inventory_cls.getFilterDoHData('test Trade','',productType1,true,true);
        Vision_DoH_High_Inventory_cls.getFilterDoHData('test Trade','',productType1,true,false); 
        Vision_DoH_High_Inventory_cls.getFilterDoHData('test Trade','',productType1,false,true); 
        Vision_DoH_High_Inventory_cls.getFilterDoHData('test Trade','',productType1,false,false); */
         
          Vision_DoH_High_Inventory_cls.fetchSortResults('vision_gcp_trade_partner_name__c', '',true,ndcList,'tradePartnerName',productType,true,true);
         Vision_DoH_High_Inventory_cls.fetchSortResults('vision_gcp_trade_partner_name__c', '',true,ndcList,'tradePartnerName',productType,true,false); 
        Vision_DoH_High_Inventory_cls.fetchSortResults('vision_gcp_trade_partner_name__c', '',true,ndcList,'tradePartnerName',productType,false,true);
         Vision_DoH_High_Inventory_cls.fetchSortResults('vision_gcp_trade_partner_name__c', '',true,ndcList,'tradePartnerName',productType,false,false);
        
        Vision_DoH_High_Inventory_cls.fetchSortResults('vision_gcp_trade_partner_name__c', '',true,ndcList,'tradePartnerName',productType1,true,true);
         Vision_DoH_High_Inventory_cls.fetchSortResults('vision_gcp_trade_partner_name__c', '',true,ndcList,'tradePartnerName',productType1,true,false); 
        Vision_DoH_High_Inventory_cls.fetchSortResults('vision_gcp_trade_partner_name__c', '',true,ndcList,'tradePartnerName',productType1,false,true);
         Vision_DoH_High_Inventory_cls.fetchSortResults('vision_gcp_trade_partner_name__c', '',true,ndcList,'tradePartnerName',productType1,false,false);
     }
    
}