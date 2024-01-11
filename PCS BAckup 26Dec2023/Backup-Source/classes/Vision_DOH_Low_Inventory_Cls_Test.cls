@isTest(seeAllData=true)
public class Vision_DOH_Low_Inventory_Cls_Test {
 static testmethod void  test(){
        GCP_Trade_Partner_DOH_Report__c tradeDoH= new GCP_Trade_Partner_DOH_Report__c(Trade_Partner_Name__c='test Trade',Package_Description__c='testProduct',W3_DOH__c=2,Vision_GCP_Update_Date__c ='2022-02-11');
        insert tradeDoH;
        GCP_DOH_Trade_Partner_NDC__c ndcDOH = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test');
        insert ndcDOH;
        List<GCP_DOH_Trade_Partner_NDC__c> ndcList = new List<GCP_DOH_Trade_Partner_NDC__c>{ndcDOH};
            
            
            doh_report_dates_info__c dohRepinfo = new  doh_report_dates_info__c(Vision_Update_Date__c ='2022-02-11', Name='Test');
        insert dohRepinfo;
        string customer = 'test';
        List<String> productType=new List<String> {}; 
            
            
            
            Vision_DOH_Low_Inventory_Cls.getAccountGroups();
        Vision_DOH_Low_Inventory_Cls.getDoHData('test Trade',productType, true, false);
        Vision_DOH_Low_Inventory_Cls.getFilterDoHData('test Trade','abc',productType,false,true);  
        Vision_DOH_Low_Inventory_Cls.fetchSortResults('vision_gcp_trade_partner_name__c', 'abc',false,ndcList,'test',productType,false,true);
        
        
    }
    static testmethod void  test1(){
        GCP_Trade_Partner_DOH_Report__c tradeDoH= new GCP_Trade_Partner_DOH_Report__c(Trade_Partner_Name__c='test Trade',Package_Description__c='testProduct',W3_DOH__c=2,Vision_GCP_Update_Date__c ='2022-02-11');
        insert tradeDoH;
        GCP_DOH_Trade_Partner_NDC__c ndcDOH = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test small');
        insert ndcDOH;
        List<GCP_DOH_Trade_Partner_NDC__c> ndcList = new List<GCP_DOH_Trade_Partner_NDC__c>{ndcDOH};
            
            doh_report_dates_info__c dohRepinfo = new  doh_report_dates_info__c(Vision_Update_Date__c ='2022-02-11', Name='Test');
        insert dohRepinfo;
        string customer = 'test';
        List<String> productType=new List<String> {}; 
            
            Vision_DOH_Low_Inventory_Cls.getAccountGroups();
        Vision_DOH_Low_Inventory_Cls.getDoHData('test Trade',productType, false, false);
        Vision_DOH_Low_Inventory_Cls.getFilterDoHData('test Trade','abc',productType,false,false);  
        Vision_DOH_Low_Inventory_Cls.fetchSortResults('vision_gcp_trade_partner_name__c', 'abc',true,ndcList,'test',productType,false,false);
        
    }
    static testmethod void  test3(){
        GCP_Trade_Partner_DOH_Report__c tradeDoH= new GCP_Trade_Partner_DOH_Report__c(Trade_Partner_Name__c='test Trade',Package_Description__c='testProduct',W3_DOH__c=2,Vision_GCP_Update_Date__c ='2022-02-11');
        insert tradeDoH;
        GCP_DOH_Trade_Partner_NDC__c ndcDOH = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test small');
        insert ndcDOH;
        List<GCP_DOH_Trade_Partner_NDC__c> ndcList = new List<GCP_DOH_Trade_Partner_NDC__c>{ndcDOH};
            
            doh_report_dates_info__c dohRepinfo = new  doh_report_dates_info__c(Vision_Update_Date__c ='2022-02-11', Name='Test');
        insert dohRepinfo;
        string customer = 'test';
        List<String> productType=new List<String> {'test','test'}; 
            Vision_DOH_Low_Inventory_Cls.getAccountGroups();
        Vision_DOH_Low_Inventory_Cls.getDoHData('test Trade',productType, true, true);
        Vision_DOH_Low_Inventory_Cls.getFilterDoHData('test Trade','abc',productType,false,false);  
        Vision_DOH_Low_Inventory_Cls.fetchSortResults('vision_gcp_trade_partner_name__c', 'abc',true,ndcList,'test',productType,false,false);
    }
    
    static testmethod void  test4(){
        GCP_Trade_Partner_DOH_Report__c tradeDoH= new GCP_Trade_Partner_DOH_Report__c(Trade_Partner_Name__c='test Trade',Package_Description__c='testProduct',W3_DOH__c=2,Vision_GCP_Update_Date__c ='2022-02-11');
        insert tradeDoH;
        GCP_DOH_Trade_Partner_NDC__c ndcDOH = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test small');
        insert ndcDOH;
        List<GCP_DOH_Trade_Partner_NDC__c> ndcList = new List<GCP_DOH_Trade_Partner_NDC__c>{ndcDOH};
            
            doh_report_dates_info__c dohRepinfo = new  doh_report_dates_info__c(Vision_Update_Date__c ='2022-02-11', Name='Test');
        insert dohRepinfo;
        string customer = 'test';
        List<String> productType=new List<String> {'test','test'}; 
            
            Vision_DOH_Low_Inventory_Cls.getAccountGroups();
        Vision_DOH_Low_Inventory_Cls.getFilterDoHData('test Trade','abc',productType,false,false);  
        Vision_DOH_Low_Inventory_Cls.getDoHData('test Trade',productType, false, false);
        Vision_DOH_Low_Inventory_Cls.fetchSortResults('vision_gcp_trade_partner_name__c', 'abc',false,ndcList,'test',productType,false,true);
    }
    static testmethod void  test5(){
        GCP_Trade_Partner_DOH_Report__c tradeDoH= new GCP_Trade_Partner_DOH_Report__c(Trade_Partner_Name__c='test Trade',Package_Description__c='testProduct',W3_DOH__c=2,Vision_GCP_Update_Date__c ='2022-02-11');
        insert tradeDoH;
        GCP_DOH_Trade_Partner_NDC__c ndcDOH = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test');
        insert ndcDOH;
        List<GCP_DOH_Trade_Partner_NDC__c> ndcList = new List<GCP_DOH_Trade_Partner_NDC__c>{ndcDOH};
            
            
            doh_report_dates_info__c dohRepinfo = new  doh_report_dates_info__c(Vision_Update_Date__c ='2022-02-11', Name='Test');
        insert dohRepinfo;
        string customer = 'test';
        List<String> productType=new List<String> {'test','test'}; 
            
            
            
            Vision_DOH_Low_Inventory_Cls.getAccountGroups();
        Vision_DOH_Low_Inventory_Cls.getDoHData('test Trade',productType, true, false);
        Vision_DOH_Low_Inventory_Cls.getFilterDoHData('test Trade','abc',productType,false,true);  
        Vision_DOH_Low_Inventory_Cls.fetchSortResults('vision_gcp_trade_partner_name__c', 'abc',false,ndcList,'test',productType,false,true);
        
        
    }
    static testmethod void  test6(){
        GCP_Trade_Partner_DOH_Report__c tradeDoH= new GCP_Trade_Partner_DOH_Report__c(Trade_Partner_Name__c='test Trade',Package_Description__c='testProduct',W3_DOH__c=2,Vision_GCP_Update_Date__c ='2022-02-11');
        insert tradeDoH;
        GCP_DOH_Trade_Partner_NDC__c ndcDOH = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test small');
        insert ndcDOH;
        List<GCP_DOH_Trade_Partner_NDC__c> ndcList = new List<GCP_DOH_Trade_Partner_NDC__c>{ndcDOH};
            
            doh_report_dates_info__c dohRepinfo = new  doh_report_dates_info__c(Vision_Update_Date__c ='2022-02-11', Name='Test');
        insert dohRepinfo;
        string customer = 'test';
        List<String> productType=new List<String> {'test','test'}; 
            
            Vision_DOH_Low_Inventory_Cls.getAccountGroups();
        Vision_DOH_Low_Inventory_Cls.getDoHData('test Trade',productType, false, false);
        Vision_DOH_Low_Inventory_Cls.getFilterDoHData('test Trade','abc',productType,true,true);  
        Vision_DOH_Low_Inventory_Cls.fetchSortResults('vision_gcp_trade_partner_name__c', 'abc',true,ndcList,'test',productType,true,false);
        
    }
    
    static testmethod void  test7(){
        GCP_Trade_Partner_DOH_Report__c tradeDoH= new GCP_Trade_Partner_DOH_Report__c(Trade_Partner_Name__c='test Trade',Package_Description__c='testProduct',W3_DOH__c=2,Vision_GCP_Update_Date__c ='2022-02-11');
        insert tradeDoH;
        GCP_DOH_Trade_Partner_NDC__c ndcDOH = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test small');
        insert ndcDOH;
        List<GCP_DOH_Trade_Partner_NDC__c> ndcList = new List<GCP_DOH_Trade_Partner_NDC__c>{ndcDOH};
            
            doh_report_dates_info__c dohRepinfo = new  doh_report_dates_info__c(Vision_Update_Date__c ='2022-02-11', Name='Test');
        insert dohRepinfo;
        string customer = 'test';
        List<String> productType=new List<String> {}; 
            Vision_DOH_Low_Inventory_Cls.getAccountGroups();
        Vision_DOH_Low_Inventory_Cls.getDoHData('test Trade',productType, true, true);
        Vision_DOH_Low_Inventory_Cls.getFilterDoHData('test Trade','abc',productType,false,false);  
        Vision_DOH_Low_Inventory_Cls.fetchSortResults('vision_gcp_trade_partner_name__c', null,false,ndcList,'test',productType,false,true);
    }
    
    static testmethod void  test8(){
        GCP_Trade_Partner_DOH_Report__c tradeDoH= new GCP_Trade_Partner_DOH_Report__c(Trade_Partner_Name__c='test Trade',Package_Description__c='testProduct',W3_DOH__c=2,Vision_GCP_Update_Date__c ='2022-02-11');
        insert tradeDoH;
        GCP_DOH_Trade_Partner_NDC__c ndcDOH = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test small');
        insert ndcDOH;
        List<GCP_DOH_Trade_Partner_NDC__c> ndcList = new List<GCP_DOH_Trade_Partner_NDC__c>{ndcDOH};
            
            doh_report_dates_info__c dohRepinfo = new  doh_report_dates_info__c(Vision_Update_Date__c ='2022-02-11', Name='Test');
        insert dohRepinfo;
        string customer = 'test';
        List<String> productType=new List<String> {}; 
            
            Vision_DOH_Low_Inventory_Cls.getAccountGroups();
        Vision_DOH_Low_Inventory_Cls.getFilterDoHData('test Trade',null,productType,true,true);  
        Vision_DOH_Low_Inventory_Cls.getDoHData('test Trade',productType, false, true);
        Vision_DOH_Low_Inventory_Cls.fetchSortResults('vision_gcp_trade_partner_name__c', null,true,ndcList,'test',productType,true,true);
        
    }
    static testmethod void  test9(){
        GCP_Trade_Partner_DOH_Report__c tradeDoH= new GCP_Trade_Partner_DOH_Report__c(Trade_Partner_Name__c='test Trade',Package_Description__c='testProduct',W3_DOH__c=2,Vision_GCP_Update_Date__c ='2022-02-11');
        insert tradeDoH;
        GCP_DOH_Trade_Partner_NDC__c ndcDOH = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test small');
        insert ndcDOH;
        List<GCP_DOH_Trade_Partner_NDC__c> ndcList = new List<GCP_DOH_Trade_Partner_NDC__c>{ndcDOH};
            
            doh_report_dates_info__c dohRepinfo = new  doh_report_dates_info__c(Vision_Update_Date__c ='2022-02-11', Name='Test');
        insert dohRepinfo;
        string customer = 'test';
        List<String> productType=new List<String> {'test','test'}; 
            
            Vision_DOH_Low_Inventory_Cls.getAccountGroups();
        Vision_DOH_Low_Inventory_Cls.getDoHData('test Trade',productType, false, false);
        Vision_DOH_Low_Inventory_Cls.getFilterDoHData('test Trade',null,productType,true,true);  
        Vision_DOH_Low_Inventory_Cls.fetchSortResults('vision_gcp_trade_partner_name__c', null,true,ndcList,'test',productType,true,true);
        
    }
    
   

}