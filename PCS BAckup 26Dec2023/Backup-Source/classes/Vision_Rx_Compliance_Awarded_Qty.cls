public class Vision_Rx_Compliance_Awarded_Qty {
  /*  @AuraEnabled(cacheable=true) 
    public static MainWrapper getComplianceData(String customerId){
        MainWrapper mainWrap = new MainWrapper();
        String query = '';
       // String strFields = Phoenix_Util.rxExternalObjFields;
       String SobjectApiName = 'Rx_Compliance_External__c';
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
        query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from Rx_Compliance_External__c  WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Total_Value_Compliance__c <= 100 order by Vision_Product__r.Name';
        List < Rx_Compliance_External__c > rxComplianceList = Database.query(query);
        System.debug('rxComplianceList1'+ rxComplianceList);
        List<Rx_Compliance_External__c> complianceMonthList=[SELECT Month1__c,Month2__c,Month3__c,Month4__c,Month5__c,Month6__c,Month7__c,Month8__c,Month__c FROM Rx_Compliance_External__c where Month2__c !=null and Month3__c !=null and Month4__c !=null and Month5__c !=null and Month6__c !=null and Month7__c !=null Limit 1];
        
        
        
        if(complianceMonthList.size()>0){
            System.debug('rxComplianceList2'+ rxComplianceList);
            mainWrap.Month1 = complianceMonthList[0].Month2__c;    
            mainWrap.Month2 = complianceMonthList[0].Month3__c;    
            mainWrap.Month3 = complianceMonthList[0].Month4__c;    
            mainWrap.Month4 = complianceMonthList[0].Month5__c;    
            mainWrap.Month5 = complianceMonthList[0].Month6__c;    
            mainWrap.Month6 = complianceMonthList[0].Month7__c;    
        }
        
        mainWrap.noOfRecords = rxComplianceList.size();  
        mainWrap.rxComplianceList = rxComplianceList;
        system.debug('mainwrap-----'+mainwrap);
        
        return mainwrap;
    }
    @AuraEnabled(cacheable=true) 
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
    @AuraEnabled(cacheable=true) 
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
    @AuraEnabled(cacheable=true) 
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
    @AuraEnabled//(cacheable=true) 
    public static MainWrapper getOnlyComplianceData(String customerId,Boolean showAll,Boolean isQuantityValue, Boolean isDirect, Boolean isIndirect, Boolean isTotal){
        MainWrapper mainWrap = new MainWrapper();
        String query = '';
       // String strFields = Phoenix_Util.rxExternalObjFields;
         String SobjectApiName = 'Rx_Compliance_External__c';
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
                        query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null';

        if(isDirect){
          
       
         if(!showAll && isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Direct_Value_Compliance__c <= 100 and Vision_Is_Direct__c = true order by Vision_Product__r.Name';
        }  
            else if(!showAll && !isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Direct_Compliance__c <= 100 and Vision_Is_Direct__c = true order by Vision_Product__r.Name';
                
            }
              else if(showAll && isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and Vision_Is_Direct__c = true order by Vision_Product__r.Name';
        }  
            else if(showAll && !isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and Vision_Is_Direct__c = true order by Vision_Product__r.Name';
                
            }
        }
        else if(isIndirect){
          
       
         if(!showAll && isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Indirect_Value_Compliance__c <= 100 and vision_Is_Indirect__c = true order by Vision_Product__r.Name';
        }  
            else if(!showAll && !isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Indirect_Compliance__c <= 100 and vision_Is_Indirect__c = true order by Vision_Product__r.Name';
                
            }
              else if(showAll && isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and vision_Is_Indirect__c = true order by Vision_Product__r.Name';
        }  
            else if(showAll && !isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and vision_Is_Indirect__c = true order by Vision_Product__r.Name';
                
            }
        }
        else if(isTotal){
          
       
         if(!showAll && isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Total_Value_Compliance__c <= 100 and vision_Is_Indirect__c = true order by Vision_Product__r.Name';
        }  
            else if(!showAll && !isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Total_Compliance__c <= 100 and vision_Is_Indirect__c = true order by Vision_Product__r.Name';
                
            }
              else if(showAll && isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null order by Vision_Product__r.Name';
        }  
            else if(showAll && !isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null order by Vision_Product__r.Name';
                
            }
        }
        
        List < Rx_Compliance_External__c > rxComplianceList = Database.query(query);
        System.debug('rxComplianceList3'+ rxComplianceList);
        List<Rx_Compliance_External__c> complianceMonthList=[SELECT Month1__c,Month2__c,Month3__c,Month4__c,Month5__c,Month6__c,Month7__c,Month8__c,Month__c FROM Rx_Compliance_External__c where Month2__c !=null and Month3__c !=null and Month4__c !=null and Month5__c !=null and Month6__c !=null and Month7__c !=null Limit 1];
        if(complianceMonthList.size()>0){
            System.debug('rxComplianceList2'+ rxComplianceList);
            mainWrap.Month1 = complianceMonthList[0].Month2__c;    
            mainWrap.Month2 = complianceMonthList[0].Month3__c;    
            mainWrap.Month3 = complianceMonthList[0].Month4__c;    
            mainWrap.Month4 = complianceMonthList[0].Month5__c;    
            mainWrap.Month5 = complianceMonthList[0].Month6__c;    
            mainWrap.Month6 = complianceMonthList[0].Month7__c; 
            mainWrap.Month7 = complianceMonthList[0].Month8__c;
        } 
        mainWrap.noOfRecords = rxComplianceList.size();  
        mainWrap.rxComplianceList = rxComplianceList;
        system.debug('mainwrap-----'+mainwrap);
        
        return mainwrap;
    }
    @AuraEnabled(cacheable=true)  
    public static MainWrapper getOnlyComplianceDataHistoricalSales(String customerId,Boolean showAll,Boolean isQuantityValue, Boolean isDirect, Boolean isIndirect, Boolean isTotal){
        MainWrapper mainWrap = new MainWrapper();
        String query = '';
       // String strFields = Phoenix_Util.rxExternalObjFields;
       String SobjectApiName = 'Rx_Compliance_External__c';
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
             if(isDirect){
          
       
         if(!showAll && isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Direct_Avg_Value_Compliance__c <= 100 and Vision_Is_Direct__c = true order by Vision_Product__r.Name';
        }  
            else if(!showAll && !isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Direct_Avg_Qty_Compliance__c <= 100 and Vision_Is_Direct__c = true order by Vision_Product__r.Name';
                
            }
              else if(showAll && isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and Vision_Is_Direct__c = true order by Vision_Product__r.Name';
        }  
            else if(showAll && !isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and Vision_Is_Direct__c = true order by Vision_Product__r.Name';
                
            }
        }
        else if(isIndirect){
          
       
         if(!showAll && isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Indirect_Avg_Value_Compliance__c <= 100 and vision_Is_Indirect__c = true order by Vision_Product__r.Name';
        }  
            else if(!showAll && !isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Indirect_Avg_Qty_Compliance__c <= 100 and vision_Is_Indirect__c = true order by Vision_Product__r.Name';
                
            }
              else if(showAll && isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and vision_Is_Indirect__c = true order by Vision_Product__r.Name';
        }  
            else if(showAll && !isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and vision_Is_Indirect__c = true order by Vision_Product__r.Name';
                
            }
        }
        else if(isTotal){
          
       
         if(!showAll && isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Total_Avg_Sales_Compliance__c <= 100 and vision_Is_Indirect__c = true order by Vision_Product__r.Name';
        }  
            else if(!showAll && !isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Total_Avg_Qty_Compliance__c <= 100 and vision_Is_Indirect__c = true order by Vision_Product__r.Name';
                
            }
              else if(showAll && isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null order by Vision_Product__r.Name';
        }  
            else if(showAll && !isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null order by Vision_Product__r.Name';
                
            }
        }
    
        List < Rx_Compliance_External__c > rxComplianceList = Database.query(query);
        System.debug('rxComplianceList3'+ rxComplianceList);
        List<Rx_Compliance_External__c> complianceMonthList=[SELECT Month1__c,Month2__c,Month3__c,Month4__c,Month5__c,Month6__c,Month7__c,Month8__c,Month__c FROM Rx_Compliance_External__c where Month2__c !=null and Month3__c !=null and Month4__c !=null and Month5__c !=null and Month6__c !=null and Month7__c !=null Limit 1];
        
        
        
        if(complianceMonthList.size()>0){
            System.debug('rxComplianceList2'+ rxComplianceList);
            mainWrap.Month1 = complianceMonthList[0].Month2__c;    
            mainWrap.Month2 = complianceMonthList[0].Month3__c;    
            mainWrap.Month3 = complianceMonthList[0].Month4__c;    
            mainWrap.Month4 = complianceMonthList[0].Month5__c;    
            mainWrap.Month5 = complianceMonthList[0].Month6__c;    
            mainWrap.Month6 = complianceMonthList[0].Month7__c;    
        }
        
        mainWrap.noOfRecords = rxComplianceList.size();  
        mainWrap.rxComplianceList = rxComplianceList;
        system.debug('mainwrap-----'+mainwrap);
        
        return mainwrap;
    }
    @AuraEnabled(cacheable=true) 
    public static MainWrapper getOnlyComplianceDataHistoricalsales(String customerId,Boolean showAll,Boolean isQuantityValue){
        MainWrapper mainWrap = new MainWrapper();
        String query = '';
        //String strFields = Phoenix_Util.rxExternalObjFields;
        String SobjectApiName = 'Rx_Compliance_External__c';
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
            
            query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null order by Vision_Product__r.Name';
            
        }
        else{
            if(isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Total_Avg_Sales_Compliance__c <= 100 order by Vision_Product__r.Name';
                
            } 
            else{
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Total_Avg_Qty_Compliance__c <= 100 order by Vision_Product__r.Name';
                
            }
            
            
        }
        List < Rx_Compliance_External__c > rxComplianceList = Database.query(query);
        System.debug('rxComplianceList3'+ rxComplianceList);
        
        List<Rx_Compliance_External__c> complianceMonthList=[SELECT Month1__c,Month2__c,Month3__c,Month4__c,Month5__c,Month6__c,Month7__c,Month8__c,Month__c FROM Rx_Compliance_External__c where Month2__c !=null and Month3__c !=null and Month4__c !=null and Month5__c !=null and Month6__c !=null and Month7__c !=null Limit 1];
        
        
        
  
        mainWrap.noOfRecords = rxComplianceList.size();  
        mainWrap.rxComplianceList = rxComplianceList;
        system.debug('mainwrap-----'+mainwrap);
        
        return mainwrap;
    }
    @AuraEnabled(cacheable=true) 
    public static MainWrapper awardedfetchSortResults(string sortField,boolean isAsc,List< Rx_Compliance_External__c >  productList,String customerId,Boolean showAll,Boolean isQuantityValue){
        set < Id > prodIds = new set < Id > ();
        System.debug('productList>>>'+productList);
        MainWrapper mainWrap = new MainWrapper();
        
        String query = '';
       // String strFields = Phoenix_Util.rxExternalObjFields;
         String SobjectApiName = 'Rx_Compliance_External__c';
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
        
         List < Rx_Compliance_External__c > wrlist = new List < Rx_Compliance_External__c > ();
     //  String SobjectApiName = 'Rx_Compliance_External__c';
     //   Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
     //   Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
       
        

        for (Rx_Compliance_External__c w: productList) {
            system.debug('Product:: '+w);
            prodIds.add(w.Id);
            
        }
        
        System.debug('prodIds'+ prodIds.size());
        System.debug('prodIds'+ prodIds);
        
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
       
        if(showAll){
            
            query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and Id=:prodIds ';
            
        }
        else{
            if(isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Total_Value_Compliance__c <= 100 and Id=:prodIds ';
                
            } 
            else{
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Total_Compliance__c <= 100 and Id=:prodIds ';
                
            }
            
            
        }
        
        if (sortField != null && sortField != '') {
            System.debug('sort');
            query += ' order by ' + sortField;
            
            if (isAsc) {
                System.debug('asc');
                query += ' ASC NULLS LAST';
            } else {
                System.debug('asc else');
                query += ' DESC NULLS LAST';
            }
            
        }
        system.debug('query-----'+query);
        List < Rx_Compliance_External__c > rxComplianceList = Database.query(query);
        System.debug('rxComplianceList4'+ rxComplianceList);
    
         for (Rx_Compliance_External__c pr: rxComplianceList) {
            for (Rx_Compliance_External__c wr: productList) {
                if (wr.Id == pr.Id) {
                    wrlist.add(wr);
                    
                }
            }
        }
        mainWrap.noOfRecords = rxComplianceList.size();  
        mainWrap.rxComplianceList = rxComplianceList;
        system.debug('mainwrap-----'+mainwrap);
        
        return mainwrap;
    } 
    @AuraEnabled(cacheable=true) 
    public static MainWrapper historcialfetchSortResults(string sortField,boolean isAsc,List< Rx_Compliance_External__c >  productList,String customerId,Boolean showAll,Boolean isQuantityValue){
        set < Id > prodIds = new set < Id > ();
        System.debug('productList>>>'+productList);
        MainWrapper mainWrap = new MainWrapper();
        
        String query = '';
       // String strFields = Phoenix_Util.rxExternalObjFields;
         String SobjectApiName = 'Rx_Compliance_External__c';
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
        List < Rx_Compliance_External__c > wrlist = new List < Rx_Compliance_External__c > ();
    //    String SobjectApiName = 'Rx_Compliance_External__c';
      //  Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe(); 
     //   Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
       
        
        for (Rx_Compliance_External__c w: productList) {
            system.debug('Product:: '+w);
            prodIds.add(w.Id);
            
        }
        
        System.debug('prodIds'+ prodIds.size());
        System.debug('prodIds'+ prodIds);
        
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        
        if(showAll){
            
            query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and Id=:prodIds';
            
        }
        else{
            if(isQuantityValue){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M1_Total_Avg_Sales_Compliance__c <= 100 and Id=:prodIds';
                
            } 
            else{
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from Rx_Compliance_External__c WHERE Vision_Account__c =:customerId and Vision_Product__r.Name != null and M2_Total_Avg_Qty_Compliance__c <= 100 and Id=:prodIds';
                
            }
            
            
        }
        
        if (sortField != null && sortField != '') {
            System.debug('sort');
            query += ' order by ' + sortField;
            
            if (isAsc) {
                System.debug('asc');
                query += ' ASC NULLS LAST';
            } else {
                System.debug('asc else');
                query += ' DESC NULLS LAST';
            }
            
        }
        system.debug('query-----'+query);
        List < Rx_Compliance_External__c > rxComplianceList = Database.query(query);
        System.debug('rxComplianceList4'+ rxComplianceList);
        
      List<Rx_Compliance_External__c> complianceMonthList=[SELECT Month1__c,Month2__c,Month3__c,Month4__c,Month5__c,Month6__c,Month7__c,Month8__c,Month__c FROM Rx_Compliance_External__c where Month2__c !=null and Month3__c !=null and Month4__c !=null and Month5__c !=null and Month6__c !=null and Month7__c !=null Limit 1];
        
        
        
        if(complianceMonthList.size()>0){
            System.debug('rxComplianceList2'+ rxComplianceList);
            mainWrap.Month1 = complianceMonthList[0].Month2__c;    
            mainWrap.Month2 = complianceMonthList[0].Month3__c;    
            mainWrap.Month3 = complianceMonthList[0].Month4__c;    
            mainWrap.Month4 = complianceMonthList[0].Month5__c;    
            mainWrap.Month5 = complianceMonthList[0].Month6__c;    
            mainWrap.Month6 = complianceMonthList[0].Month7__c;    
        }
        
        System.debug('Month1-->'+ complianceMonthList[0].Month2__c);
         for (Rx_Compliance_External__c pr: rxComplianceList) {
            for (Rx_Compliance_External__c wr: productList) {
                if (wr.Id == pr.Id) {
                    wrlist.add(wr);
                    
                }
            }
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
        @AuraEnabled public String Month7 ;
        @AuraEnabled public String ProdName;
        @AuraEnabled public String Ndc;
        @AuraEnabled public List<Rx_Compliance_External__c> rxComplianceList;    
        @AuraEnabled public List<Vision_Customer_Product_Tracker__c> awardedPositionList; 
        //    @AuraEnabled public List<GCP_SFDC_Direct_Sales__c> rxDirectComplianceList;  
        //   @AuraEnabled public List<GCP_SFDC_Indirect_Sales__c> rxIndirectComplianceList;    
        //  @AuraEnabled public List<ProductWrapper> ProductWrapperList;      
        MainWrapper(){
            //   ProductWrapperList = new List<ProductWrapper>();
            rxComplianceList = new List<Rx_Compliance_External__c>();
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
    public static string fieldApiList(String SobjectApiName){
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String bidLineStrFields = '';
        
        for (String fieldName: fieldMap.keyset()) {
            if (bidLineStrFields == null || bidLineStrFields == '') {
                bidLineStrFields = fieldName;
            } else {
                bidLineStrFields = bidLineStrFields + ' , ' + fieldName;
            }
        }
        return bidLineStrFields;
    }
    @AuraEnabled(cacheable=true) 
    public static Wrapper saveComment(String newComment, String selectedLineId ,String Account, String Product){
        Wrapper wrapObj = new Wrapper();
        try{
            GCP_Comment__c gcpCmntObj = new GCP_Comment__c();
            gcpCmntObj.Comment__c = newComment;
            //gcpCmntObj.Rx_Compliance_External__c = selectedLineId;
            gcpCmntObj.Comment_Type__c = 'Vision';
            gcpCmntObj.Account__c = Account;
            gcpCmntObj.Product__c = Product;
            insert gcpCmntObj;
            wrapObj.isErrorFromServer = false;
            wrapObj.errorMessageFromServer = 'SUCCESS!';
        }
        catch(exception e){
            wrapObj.isErrorFromServer = true;
            wrapObj.errorMessageFromServer = 'Exception while saving the comment. Exception : '+e.getMessage()+' Line: '+e.getLineNumber();
        }
        return wrapObj;
    }
    
    @AuraEnabled(cacheable=true) 
    public static list<Wrapper> getProdBidLineItemComments(String ProductId, String AccountId){
        List<Wrapper> wrapList = new List<Wrapper>();
        //string prodFamilyName = gcpLineItem.Phoenix_Product_Family__c != null ? gcpLineItem.Phoenix_Product_Family__c : '';
        //gcpLineItem.GCP_Product_Family__c != null ? gcpLineItem.GCP_Product_Family__c : '';
    
        Product2 prdObj = [select id,Name,Family from Product2 where Id=:ProductId];
          string prodFamilyName = prdObj.Family != null ? prdObj.Family : '';
        prodFamilyName = '%'+prodFamilyName+'%';
        system.debug('prodFamilyName-----'+prodFamilyName);
        String panoramaString = 'Panorama';
        string gcpCommentQuery = 'SELECT '+fieldApiList('GCP_Comment__c')+' FROM GCP_Comment__c WHERE Comment_Type__c =: panoramaString '+
            +'AND Product_Family__c LIKE \''+prodFamilyName+'\' ORDER BY Comment_Date__c Desc';
        List<GCP_Comment__c> visionGcpCmntsList = database.query(gcpCommentQuery);
        if(visionGcpCmntsList.size()>0)
        {  
            Wrapper wrapObj = new Wrapper();
            List<cmntWrapper> cmntWrapList = new List<cmntWrapper>();
            wrapObj.cmntCat =  'Panorama Comments';
            wrapObj.cmntWrapList = new List<cmntWrapper>();
            for(GCP_Comment__c gcpCmntObj : visionGcpCmntsList){
                system.debug('Comment__c-----'+gcpCmntObj.Comment__c);
                cmntWrapper cmntObj = new cmntWrapper();
                cmntObj.userName = gcpCmntObj.Author__c;
                //cmntObj.userId = gcpCmntObj.CreatedById;
                cmntObj.cmntDate = String.valueOf(gcpCmntObj.Comment_Date__c);
                cmntObj.cmntString = gcpCmntObj.Comment__c;
                cmntObj.profilePicUrl = '/docs/component-library/app/images/examples/avatar1.jpg';
                cmntObj.gcpCmntObj = gcpCmntObj;
                wrapObj.cmntWrapList.add(cmntObj);
            }
            wrapList.add(wrapObj);
        }
        
        String visionString = 'Vision';
        List<GCP_Comment__c> gcpCmntsList = [SELECT Id, Name, GCP_Opportunity_Tracker__c, CreatedById, Comment__c,
                                             createdDate, CreatedBy.Name, CreatedBy.SmallPhotoUrl FROM GCP_Comment__c
                                             WHERE Comment_Type__c=: visionString and Account__c =: AccountId and Product__c =: ProductId ORDER By createdDate Desc];
        if(gcpCmntsList.size()>0){
            Wrapper wrapObj = new Wrapper();
            List<cmntWrapper> cmntWrapList = new List<cmntWrapper>();
            wrapObj.cmntCat = 'Vision Comments';
            wrapObj.cmntWrapList = new List<cmntWrapper>();
            for(GCP_Comment__c gcpCmntObj : gcpCmntsList){
                cmntWrapper cmntObj = new cmntWrapper();
                cmntObj.userName = gcpCmntObj.CreatedBy.Name;
                cmntObj.userId = gcpCmntObj.CreatedById;
                cmntObj.cmntDate = String.valueOf(gcpCmntObj.createdDate);
                cmntObj.cmntString = gcpCmntObj.Comment__c;
                cmntObj.profilePicUrl = gcpCmntObj.CreatedBy.SmallPhotoUrl;
                cmntObj.gcpCmntObj = gcpCmntObj;
                wrapObj.cmntWrapList.add(cmntObj);
            }
            wrapList.add(wrapObj);
        }
        
        String accId = AccountId;
        string product = ProductId;
        String query = 'SELECT Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, '+fieldApiList('Phoenix_Bid_Line_Item__c')+' FROM Phoenix_Bid_Line_Item__c '+
            +'WHERE Phoenix_Bid__r.Phoenix_Customer__c =: accId AND Phoenix_Product__c =: product ORDER BY CreatedDate ASC';
        List<Phoenix_Bid_Line_Item__c> bidLineItemList = Database.query(query);
        
        
        
        List<Map<String,Map<String,String>>> commentList = new List<Map<String,Map<String,String>>>();
        Map<String,Map<String,String>> commentMap = new Map<String,Map<String,String>>();
        Map<String,String> subMap = new Map<String,String>();
        Map<String,String> considerMap = new Map<String,String>();
        
        if(bidLineItemList.size()>0){
            List<Id> bidIds = new List<Id>(); List<Id> bidLineIds = new List<Id>();
            for(Phoenix_Bid_Line_Item__c bidLineItemObj : bidLineItemList){
                bidIds.add(bidLineItemObj.Phoenix_Bid__c);bidLineIds.add(bidLineItemObj.Id); 
            }
            List<Phoenix_Bid_Process_Steps__c> bidProcessSteps = new List<Phoenix_Bid_Process_Steps__c>();
            bidProcessSteps = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, 
                               Phoenix_Status__c, Phoenix_Approver_Team__c, LastModifiedDate, LastModifiedBy.Name, 
                               LastModifiedById, LastModifiedBy.SmallPhotoUrl 
                               FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c IN: bidIds order by Phoenix_Step__c];
            Map<String, list<Phoenix_Bid_Process_Steps__c>> processStepsByBid = new Map<String, list<Phoenix_Bid_Process_Steps__c>>();
            for(Phoenix_Bid_Process_Steps__c bpObj : bidProcessSteps){
                if(!processStepsByBid.containsKey(bpObj.Phoenix_Bid__c))
                    processStepsByBid.put(bpObj.Phoenix_Bid__c,new List<Phoenix_Bid_Process_Steps__c>());
                processStepsByBid.get(bpObj.Phoenix_Bid__c).add(bpObj);
            }
            
            
            
            Wrapper wrapObj = new Wrapper();
            List<cmntWrapper> cmntWrapList = new List<cmntWrapper>();
            wrapObj.cmntCat = 'Bright Comments';
            wrapObj.cmntWrapList = new List<cmntWrapper>();
            wrapObj.cmntWrapMap = new Map<String,list<cmntWrapper>>();
            for(Phoenix_Bid_Line_Item__c bidLineItemObj : bidLineItemList){
                if(processStepsByBid.containsKey(bidLineItemObj.Phoenix_Bid__c)){
                    
                    List<cmntWrapper> cmntWrapObjList = new List<cmntWrapper>();
                    
                    List<Phoenix_Bid_Process_Steps__c> bidSteps = new List<Phoenix_Bid_Process_Steps__c>();
                    Map<string, Phoenix_Bid_Process_Steps__c> bidStageMap = new Map<String, Phoenix_Bid_Process_Steps__c>();
                    for(Phoenix_Bid_Process_Steps__c processStep : processStepsByBid.get(bidLineItemObj.Phoenix_Bid__c)){
                        if(processStep.Phoenix_Approver_Team__c == '')
                            bidStageMap.put('Sales',processStep);
                        if(processStep.Phoenix_Approver_Team__c == 'Marketing' || processStep.Phoenix_Approver_Team__c == 'Marketing Lead Rx' 
                           || processStep.Phoenix_Approver_Team__c == 'Marketing Lead SRx'
                           || processStep.Phoenix_Approver_Team__c == 'Marketing Lead OTC' || processStep.Phoenix_Approver_Team__c == 'Marketing Head')
                            bidStageMap.put('Marketing',processStep);
                        if(processStep.Phoenix_Approver_Team__c == 'Supply Chain')
                            bidStageMap.put('Supply Chain',processStep);
                        if(processStep.Phoenix_Approver_Team__c == 'Contracts')
                            bidStageMap.put('Contracts',processStep);
                        if(processStep.Phoenix_Approver_Team__c == 'Finance')
                            bidStageMap.put('Finance',processStep);
                        if(processStep.Phoenix_Approver_Team__c == 'Customer Service')
                            bidStageMap.put('Customer Service',processStep);
                        if(processStep.Phoenix_Approver_Team__c == 'Home Office')
                            bidStageMap.put('Vistex',processStep);
                    }
                    
                    if(bidLineItemObj.Phoenix_Comments__c !=  null 
                       && bidLineItemObj.Phoenix_Comments__c != '' 
                       && bidStageMap.containsKey('Sales')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Sales');
                           cmntWrapper cmntWrapObj = new cmntWrapper();
                           cmntWrapObj.userName = stepObj.LastModifiedBy.Name;
                           cmntWrapObj.userId = stepObj.LastModifiedById;
                           cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate);
                           cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Comments__c;
                           cmntWrapObj.cmntAprvlStage = 'Sales';
                           cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;
                           cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                           cmntWrapObjList.add(cmntWrapObj);
                       }
                    if(bidLineItemObj.Phoenix_Initial_Stocking_Order_Comments__c !=  null 
                       && bidLineItemObj.Phoenix_Initial_Stocking_Order_Comments__c != ''
                       && bidStageMap.containsKey('Sales')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Sales');
                           cmntWrapper cmntWrapObj = new cmntWrapper();
                           cmntWrapObj.userName = stepObj.LastModifiedBy.Name;
                           cmntWrapObj.userId = stepObj.LastModifiedById;
                           cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate);
                           cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Initial_Stocking_Order_Comments__c;
                           cmntWrapObj.cmntAprvlStage = 'Initial Stocking Order';
                           cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;
                           cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                           cmntWrapObjList.add(cmntWrapObj);                         
                       }
                    if(bidLineItemObj.Phoenix_Marketing_Notes__c !=  null 
                       && bidLineItemObj.Phoenix_Marketing_Notes__c != ''
                       && bidStageMap.containsKey('Marketing')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Marketing');
                           cmntWrapper cmntWrapObj = new cmntWrapper();
                           cmntWrapObj.userName = stepObj.LastModifiedBy.Name;
                           cmntWrapObj.userId = stepObj.LastModifiedById;
                           cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate);
                           cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Marketing_Notes__c;
                           cmntWrapObj.cmntAprvlStage = 'Marketing';
                           cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;
                           cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                           cmntWrapObjList.add(cmntWrapObj);
                           
                       }
                    if(bidLineItemObj.Phoenix_SCM_Notes__c !=  null 
                       && bidLineItemObj.Phoenix_SCM_Notes__c != ''
                       && bidStageMap.containsKey('Supply Chain')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Supply Chain');
                           cmntWrapper cmntWrapObj = new cmntWrapper();
                           cmntWrapObj.userName = stepObj.LastModifiedBy.Name;
                           cmntWrapObj.userId = stepObj.LastModifiedById;
                           cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate);
                           cmntWrapObj.cmntString = bidLineItemObj.Phoenix_SCM_Notes__c;
                           cmntWrapObj.cmntAprvlStage = 'Supply Chain';
                           cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;
                           cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                           cmntWrapObjList.add(cmntWrapObj);
                           
                       }
                    if(bidLineItemObj.Phoenix_Finance_Comments__c !=  null 
                       && bidLineItemObj.Phoenix_Finance_Comments__c != ''
                       && bidStageMap.containsKey('Finance')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Finance');
                           cmntWrapper cmntWrapObj = new cmntWrapper();
                           cmntWrapObj.userName = stepObj.LastModifiedBy.Name;
                           cmntWrapObj.userId = stepObj.LastModifiedById;
                           cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate);
                           cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Finance_Comments__c;
                           cmntWrapObj.cmntAprvlStage = 'Finance';
                           cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;
                           cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                           cmntWrapObjList.add(cmntWrapObj);
                           
                       }
                    if(bidLineItemObj.Phoenix_Contract_Comments__c !=  null 
                       && bidLineItemObj.Phoenix_Contract_Comments__c != ''
                       && bidStageMap.containsKey('Contracts')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Contracts');
                           cmntWrapper cmntWrapObj = new cmntWrapper();
                           cmntWrapObj.userName = stepObj.LastModifiedBy.Name;
                           cmntWrapObj.userId = stepObj.LastModifiedById;
                           cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate);
                           cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Contract_Comments__c;
                           cmntWrapObj.cmntAprvlStage = 'Contracts';
                           cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;
                           cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                           cmntWrapObjList.add(cmntWrapObj);
                           
                       }
                    if(bidLineItemObj.Phoenix_Vistex_Comments__c !=  null 
                       && bidLineItemObj.Phoenix_Vistex_Comments__c != ''
                       && bidStageMap.containsKey('Vistex')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Vistex');
                           cmntWrapper cmntWrapObj = new cmntWrapper();
                           cmntWrapObj.userName = stepObj.LastModifiedBy.Name;
                           cmntWrapObj.userId = stepObj.LastModifiedById;
                           cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate);
                           cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Vistex_Comments__c;
                           cmntWrapObj.cmntAprvlStage = 'Vistex Update';
                           cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;
                           cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                           cmntWrapObjList.add(cmntWrapObj);
                       }
                    if(bidLineItemObj.Phoenix_Customer_Service_Comments__c !=  null && bidLineItemObj.Phoenix_Customer_Service_Comments__c != ''&& bidStageMap.containsKey('Customer Service')){
                        Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Customer Service');
                        cmntWrapper cmntWrapObj = new cmntWrapper();
                        cmntWrapObj.userName = stepObj.LastModifiedBy.Name;
                        cmntWrapObj.userId = stepObj.LastModifiedById;
                        cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate);
                        cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Customer_Service_Comments__c;
                        cmntWrapObj.cmntAprvlStage = 'Customer Service';
                        cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;
                        cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                        
                        cmntWrapObjList.add(cmntWrapObj);
                        
                    }
                    if(!wrapObj.cmntWrapMap.containsKey(bidLineItemObj.Phoenix_Bid__r.Name))
                        wrapObj.cmntWrapMap.put(bidLineItemObj.Phoenix_Bid__r.Name+' - '+bidLineItemObj.Phoenix_Bid__r.Phoenix_Bid_Type__c, new List<cmntWrapper>());
                    wrapObj.cmntWrapMap.get(bidLineItemObj.Phoenix_Bid__r.Name+' - '+bidLineItemObj.Phoenix_Bid__r.Phoenix_Bid_Type__c).addAll(cmntWrapObjList);
                }
            }
            wrapList.add(wrapObj);
        }
        return wrapList;//considerMap;
    }
    
    Public class Wrapper{
        @auraEnabled
        public Decimal EstAcctSales;
        @auraEnabled
        public Decimal custActualSales;
        @auraEnabled
        public Decimal custOptySales;
        @auraEnabled
        public Decimal cxActVol;
        @auraEnabled
        public Decimal actTotal;
        @auraEnabled
        public Decimal shareOfWallet;
        @auraEnabled
        public Decimal drlAccVol;
        @auraEnabled
        public Decimal drlAccSales;
        @auraEnabled
        public Decimal drlAccPrice;
        @auraEnabled
        public Decimal drlAccTpt;
        @auraEnabled
        public Decimal totalMktVol;
        @auraEnabled
        public Decimal totalMktShares;
        @auraEnabled
        public Decimal custActVol;
        @auraEnabled
        public Decimal custActMktShare;
        @auraEnabled
        public Decimal custActOppTpt;
        @auraEnabled
        public String userSegment;
        @auraEnabled
        public List<String> segmentList;
        @auraEnabled
        public Account accObj;
        @auraEnabled
        public List<Phoenix_GCP_Opportunity_Tracker__c> gcpList;
        @auraEnabled
        public boolean isErrorFromServer = false;
        @auraEnabled 
        public string errorMessageFromServer;
        @auraEnabled
        public String cmntCat;
        @auraEnabled
        public string bidNumber;
        @auraEnabled
        public List<cmntWrapper> cmntWrapList;
        @auraEnabled
        public Map<String,List<cmntWrapper>> cmntWrapMap;
        @auraEnabled
        public Decimal awardedTotalSales = 0;
        @auraEnabled
        public Decimal inBidTotalSales = 0;
        
    }
    public class cmntWrapper{
        @auraEnabled
        public GCP_Comment__c gcpCmntObj;
        @auraEnabled
        public String userName;
        @auraEnabled
        public String userId;
        @auraEnabled
        public string bidId;
        @auraEnabled
        public String cmntDate;
        @auraEnabled
        public String cmntString;
        @auraEnabled
        public String cmntAprvlStage;
        @auraEnabled
        public string profilePicUrl;
    } */
}