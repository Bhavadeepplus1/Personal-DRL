public class Vision_Rx_Compliance_Awarded_Qty {
    @AuraEnabled
    public static MainWrapper getComplianceData(String customerId){
        MainWrapper mainWrap = new MainWrapper();
        String query = '';
        String SobjectApiName = 'Rx_Compliance_Summary__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from ' + SobjectApiName + ' WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Total_Value_Compliance__c <= 100 order by Vision_Product__r.Name';
        List < Rx_Compliance_Summary__c > rxComplianceList = Database.query(query);
        System.debug('rxComplianceList1'+ rxComplianceList);
        
        
        
        
        if(rxComplianceList.size()>0){
            System.debug('rxComplianceList2'+ rxComplianceList);
            mainWrap.Month1 = rxComplianceList[0].Month1__c;    
            mainWrap.Month2 = rxComplianceList[0].Month2__c;    
            mainWrap.Month3 = rxComplianceList[0].Month3__c;    
            mainWrap.Month4 = rxComplianceList[0].Month4__c;    
            mainWrap.Month5 = rxComplianceList[0].Month5__c;    
            mainWrap.Month6 = rxComplianceList[0].Month6__c;    
        }
        
        mainWrap.noOfRecords = rxComplianceList.size();  
        mainWrap.rxComplianceList = rxComplianceList;
        system.debug('mainwrap-----'+mainwrap);
        
        return mainwrap;
    }
   @AuraEnabled
    public static MainWrapper getAwardedPositionData(String customerId, string ProductCode){
        MainWrapper mainWrap = new MainWrapper();
        system.debug('customerId---'+customerId);
        system.debug('ProductId---'+ProductCode);
       List < Vision_Customer_Product_Tracker__c > awardedPositionList = [SELECT Vision_Account__c,Vision_Contract__r.Name,Vision_Current_Product_Position__c,Vision_Product__c,Vision_Product__r.Name,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode FROM Vision_Customer_Product_Tracker__c where Vision_Account__c =: customerId and Vision_Product__r.ProductCode =: ProductCode];
      system.debug('awardedPositionList---'+awardedPositionList.size());
        
        mainwrap.awardedPositionList = awardedPositionList;
        if(awardedPositionList.size() > 0){
        mainwrap.ProdName = awardedPositionList[0].Vision_Product__r.Name;
         mainwrap.Ndc = awardedPositionList[0].Vision_Product__r.Phoenix_NDC_11__c; 
       
    }
    return mainwrap;
    } 
     @AuraEnabled
    public static MainWrapper getDirectAwardedPositionData(String customerId, string ProductCode){
        MainWrapper mainWrap = new MainWrapper();
        system.debug('customerId---'+customerId);
        system.debug('ProductId---'+ProductCode);
       List < Vision_Customer_Product_Tracker__c > awardedPositionList = [SELECT Vision_Account__c,Vision_Contract__r.Name,Vision_Current_Product_Position__c,Vision_Product__c,Vision_Product__r.Name,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode FROM Vision_Customer_Product_Tracker__c where Vision_Account__c =: customerId and Vision_Product__r.ProductCode =: ProductCode AND Vision_Contract_Type__c = 'Direct'];
      system.debug('awardedPositionList---'+awardedPositionList.size());
        
        mainwrap.awardedPositionList = awardedPositionList;
        if(awardedPositionList.size() > 0){
        mainwrap.ProdName = awardedPositionList[0].Vision_Product__r.Name;
         mainwrap.Ndc = awardedPositionList[0].Vision_Product__r.Phoenix_NDC_11__c; 
       
    }
    return mainwrap;
    } 
         @AuraEnabled
    public static MainWrapper getIndirectAwardedPositionData(String customerId, string ProductCode){
        MainWrapper mainWrap = new MainWrapper();
        system.debug('customerId---'+customerId);
        system.debug('ProductId---'+ProductCode);
       List < Vision_Customer_Product_Tracker__c > awardedPositionList = [SELECT Vision_Account__c,Vision_Contract__r.Name,Vision_Current_Product_Position__c,Vision_Product__c,Vision_Product__r.Name,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode FROM Vision_Customer_Product_Tracker__c where Vision_Account__c =: customerId and Vision_Product__r.ProductCode =: ProductCode AND Vision_Contract_Type__c = 'Indirect'];
      system.debug('awardedPositionList---'+awardedPositionList.size());
        
        mainwrap.awardedPositionList = awardedPositionList;
        if(awardedPositionList.size() > 0){
        mainwrap.ProdName = awardedPositionList[0].Vision_Product__r.Name;
         mainwrap.Ndc = awardedPositionList[0].Vision_Product__r.Phoenix_NDC_11__c; 
       
    }
    return mainwrap;
    }
    @AuraEnabled
    public static MainWrapper getOnlyComplianceData(String customerId,Boolean showAll,Boolean isQuantityValue){
        MainWrapper mainWrap = new MainWrapper();
        String query = '';
        String SobjectApiName = 'Rx_Compliance_Summary__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        
        if(showAll){
            
            query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from ' + SobjectApiName + ' WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null order by Vision_Product__r.Name';
            
        }
        else{
            if(isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from ' + SobjectApiName + ' WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Total_Value_Compliance__c <= 100 order by Vision_Product__r.Name';
                
            } 
            else{
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from ' + SobjectApiName + ' WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Total_Compliance__c <= 100 order by Vision_Product__r.Name';
                
            }
            
            
        }
        List < Rx_Compliance_Summary__c > rxComplianceList = Database.query(query);
        System.debug('rxComplianceList3'+ rxComplianceList);
        
        
        
        if(rxComplianceList.size()>0){
            System.debug('rxComplianceList4'+ rxComplianceList);
            mainWrap.Month1 = rxComplianceList[0].Month1__c;    
            mainWrap.Month2 = rxComplianceList[0].Month2__c;    
            mainWrap.Month3 = rxComplianceList[0].Month3__c;    
            mainWrap.Month4 = rxComplianceList[0].Month4__c;    
            mainWrap.Month5 = rxComplianceList[0].Month5__c;    
            mainWrap.Month6 = rxComplianceList[0].Month6__c;    
        }
        
        mainWrap.noOfRecords = rxComplianceList.size();  
        mainWrap.rxComplianceList = rxComplianceList;
        system.debug('mainwrap-----'+mainwrap);
        
        return mainwrap;
    }
     @AuraEnabled
    public static MainWrapper getOnlyComplianceDataHistoricalsales(String customerId,Boolean showAll,Boolean isQuantityValue){
        MainWrapper mainWrap = new MainWrapper();
        String query = '';
        String SobjectApiName = 'Rx_Compliance_Summary__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        
        if(showAll){
            
            query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from ' + SobjectApiName + ' WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null order by Vision_Product__r.Name';
            
        }
        else{
            if(isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from ' + SobjectApiName + ' WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M1_Total_Avg_Sales_Compliance__c <= 100 order by Vision_Product__r.Name';
                
            } 
            else{
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from ' + SobjectApiName + ' WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Total_Avg_Qty_Compliance__c <= 100 order by Vision_Product__r.Name';
                
            }
            
            
        }
        List < Rx_Compliance_Summary__c > rxComplianceList = Database.query(query);
        System.debug('rxComplianceList3'+ rxComplianceList);
        
        
        
        if(rxComplianceList.size()>0){
            System.debug('rxComplianceList4'+ rxComplianceList);
            mainWrap.Month1 = rxComplianceList[0].Month1__c;    
            mainWrap.Month2 = rxComplianceList[0].Month2__c;    
            mainWrap.Month3 = rxComplianceList[0].Month3__c;    
            mainWrap.Month4 = rxComplianceList[0].Month4__c;    
            mainWrap.Month5 = rxComplianceList[0].Month5__c;    
            mainWrap.Month6 = rxComplianceList[0].Month6__c;    
        }
        
        mainWrap.noOfRecords = rxComplianceList.size();  
        mainWrap.rxComplianceList = rxComplianceList;
        system.debug('mainwrap-----'+mainwrap);
        
        return mainwrap;
    }
    public class MainWrapper{
        @AuraEnabled public Integer noOfRecords;
        @AuraEnabled public String Month1;
        @AuraEnabled public String Month2;
        @AuraEnabled public String Month3;
        @AuraEnabled public String Month4;
        @AuraEnabled public String Month5;
        @AuraEnabled public String Month6;
         @AuraEnabled public String ProdName;
         @AuraEnabled public String Ndc;
        @AuraEnabled public List<Rx_Compliance_Summary__c> rxComplianceList;    
            @AuraEnabled public List<Vision_Customer_Product_Tracker__c> awardedPositionList; 
    //    @AuraEnabled public List<GCP_SFDC_Direct_Sales__c> rxDirectComplianceList;  
     //   @AuraEnabled public List<GCP_SFDC_Indirect_Sales__c> rxIndirectComplianceList;    
      //  @AuraEnabled public List<ProductWrapper> ProductWrapperList;      
        MainWrapper(){
         //   ProductWrapperList = new List<ProductWrapper>();
            rxComplianceList = new List<Rx_Compliance_Summary__c>();
            awardedPositionList = new List<Vision_Customer_Product_Tracker__c>();
         //   rxDirectComplianceList = new List<GCP_SFDC_Direct_Sales__c>();
         //   rxIndirectComplianceList = new List<GCP_SFDC_Indirect_Sales__c>();
        }
    }
    Public Class ProductWrapper{
        @AuraEnabled public String skuCode;
        @AuraEnabled public String prodDescription;
        @AuraEnabled public Decimal pkgSize=0;
        @AuraEnabled public Decimal DirectAwardedValue,DirectAwardedQuantity,M1DAQ,M2DAQ,M3DAQ,M4DAQ,M5DAQ, M6DAQ,M1DAV,M2DAV, M3DAV,M4DAV,M5DAV,M6DAV,week1DAQ,week2DAQ,week3DAQ,week4DAQ,week1DAV,week2DAV,week3DAV,week4DAV,IndirectAwardedValue,IndirectAwardedQuantity,M1IAQ,M2IAQ,M3IAQ,M4IAQ,M5IAQ,M6IAQ,M1IAV,M2IAV,M3IAV,M4IAV,M5IAV,M6IAV,week1IAQ,week2IAQ,week3IAQ,week4IAQ,week1IAV,week2IAV,week3IAV,week4IAV=0;
        @AuraEnabled public Decimal TotalAwardedValue,TotalAwardedQuantity,M1TAQ,M2TAQ,M3TAQ,M4TAQ,M5TAQ,M6TAQ,M1TAV,M2TAV,M3TAV,M4TAV,M5TAV,M6TAV,week1TAQ,week2TAQ,week3TAQ,week4TAQ,week1TAV,week2TAV,week3TAV,week4TAV=0;
    }
}