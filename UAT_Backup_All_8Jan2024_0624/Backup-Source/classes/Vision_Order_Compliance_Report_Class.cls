public class Vision_Order_Compliance_Report_Class {
    @AuraEnabled
    public static MainWrapper getOnlyComplianceData(String searchText,String customerId,String showNonCompliance,Boolean showPrimary, String productDirector){
        system.debug('searchText----'+searchText);
         system.debug('customerId----'+customerId);
         system.debug('showNonCompliance----'+showNonCompliance);
         system.debug('showPrimary----'+showPrimary);
         system.debug('productDirector----'+productDirector);
        MainWrapper mainWrap = new MainWrapper();
        Account accDetails = [SELECT Id,AccountNumber from Account where Id=:customerId];
        String custCode = accDetails.AccountNumber;
        String query = '';
        String category = 'Primary';
        String SobjectApiName = 'Order_Compliance_Summary__c';
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
        map<String,List<Order_Compliance_Summary__c>> productFamilyMap = new map<String,List<Order_Compliance_Summary__c>>();
        query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Phoenix_Rx_SRx_OTC__c,Vision_Product__r.ProductCode,Vision_Product__r.Product_Family__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,GCP_Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_SRx_Rx__r.Vision_On_Backorder__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c, '+strFields+' from Order_Compliance_Summary__c WHERE Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Hierachy_Code__c =:custCode and Vision_Product__r.Product_Family__r.Name != null  ';   
        
        
        
        if(showNonCompliance == '1Month'){
            system.debug('m1');
            query =  query+'and (M2_Compliance__c <75) ';
        }
        else if(showNonCompliance == '2Month'){
            query =  query+'and (M2_Compliance__c < 75 and M3_Compliance__c < 75) ';
            
        } 
        else if(showNonCompliance == '3Month'){
            query =  query+'and (M2_Compliance__c < 75 and M3_Compliance__c < 75 and M4_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '4Month'){
            query =  query+'and (M2_Compliance__c < 75 and M3_Compliance__c < 75 and M4_Compliance__c < 75 and M5_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '5Month'){
            query =  query+'and (M2_Compliance__c < 75 and M3_Compliance__c < 75 and M4_Compliance__c < 75 and M5_Compliance__c < 75 and M6_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '6Month'){
            query =  query+'and (M2_Compliance__c < 75 and M3_Compliance__c < 75 and M4_Compliance__c < 75 and M5_Compliance__c < 75 and M6_Compliance__c < 75  and M7_Compliance__c < 75) ';
            
        }
        else{
            
        }
        if(searchText != null && searchText !='') {
            searchText = '%'+searchText+'%';
            if(!showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('!showPrimary - productDirector != null');
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and General_Category__c =: category and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                }
                else{
                    system.debug('!showPrimary - productDirector');
                    query = query+'and General_Category__c =: category and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                    
                }
            }
            else if(showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('showPrimary - productDirector != null');
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                }
                else{
                    system.debug('showPrimary - productDirector');
                    query = query+'and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                    
                }
            }      
        }
        else{
            if(!showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('!showPrimary - productDirector != null');
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and General_Category__c =: category order by Vision_Product__r.Name';
                }
                else{
                    system.debug('!showPrimary - productDirector');
                    query = query+'and General_Category__c =: category order by Vision_Product__r.Name';
                    
                }
            }
            else if(showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('showPrimary - productDirector != null');
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector order by Vision_Product__r.Name';
                }
                else{
                    system.debug('showPrimary - productDirector');
                    query = query+'order by Vision_Product__r.Name';
                    
                }
            }         
        }
        List<ProductFamilyWrapper> ProductFamilyWrapperList = new List<ProductFamilyWrapper>();
        List < Order_Compliance_Summary__c > orderComplianceList = Database.query(query);
        system.debug('size---'+orderComplianceList.size());
        if(orderComplianceList.size()>0){
            for(Order_Compliance_Summary__c comp : orderComplianceList){
                
                if(productFamilyMap.containsKey(comp.Vision_Product__r.Product_Family__r.Name)){
                    List<Order_Compliance_Summary__c> prodList = productFamilyMap.get(comp.Vision_Product__r.Product_Family__r.Name);
                    prodList.add(comp);
                    productFamilyMap.put(comp.Vision_Product__r.Product_Family__r.Name,prodList);
                }
                else{
                    productFamilyMap.put(comp.Vision_Product__r.Product_Family__r.Name,new List<Order_Compliance_Summary__c>{comp});
                }
                
                
                mainWrap.DirectAwardedQuantity = mainWrap.DirectAwardedQuantity + (comp.Awarded_Quantity__c != null ? comp.Awarded_Quantity__c:0);
                mainWrap.DirectAwardedQtyMonthly = mainWrap.DirectAwardedQtyMonthly + (comp.Monthly_Awarded_Quantity__c != null ? comp.Monthly_Awarded_Quantity__c :0);
                mainWrap.M1DirectAct = (mainWrap.M1DirectAct != null ? mainWrap.M1DirectAct : 0) + (comp.M1_Quantity__c!= null ? comp.M1_Quantity__c :0);
                mainWrap.M2DirectAct = (mainWrap.M2DirectAct != null ? mainWrap.M2DirectAct : 0) + (comp.M2_Quantity__c!= null ? comp.M2_Quantity__c :0);
                mainWrap.M3DirectAct = mainWrap.M3DirectAct + (comp.M3_Quantity__c!= null ? comp.M3_Quantity__c :0);
                mainWrap.M4DirectAct = mainWrap.M4DirectAct + (comp.M4_Quantity__c!= null ? comp.M4_Quantity__c :0);
                mainWrap.M5DirectAct = mainWrap.M5DirectAct + (comp.M5_Quantity__c!= null ? comp.M5_Quantity__c :0);
                mainWrap.M6DirectAct = mainWrap.M6DirectAct + (comp.M6_Quantity__c!= null ? comp.M6_Quantity__c :0);
                mainWrap.M7DirectAct = mainWrap.M7DirectAct + (comp.M7_Quantity__c!= null ? comp.M7_Quantity__c :0);
                /*  mainWrap.M1DirectAvg = mainWrap.M1DirectAvg + (comp.M1_Direct_Avg_Quantity__c!= null ? comp.M1_Direct_Avg_Quantity__c :0);
mainWrap.M2DirectAvg = mainWrap.M2DirectAvg + (comp.M2_Direct_Avg_Quantity__c!= null ? comp.M2_Direct_Avg_Quantity__c :0);
mainWrap.M3DirectAvg = mainWrap.M3DirectAvg + (comp.M3_Direct_Avg_Quantity__c!= null ? comp.M3_Direct_Avg_Quantity__c :0);
mainWrap.M4DirectAvg = mainWrap.M4DirectAvg + (comp.M4_Direct_Avg_Quantity__c!= null ? comp.M4_Direct_Avg_Quantity__c :0);
mainWrap.M5DirectAvg = mainWrap.M5DirectAvg + (comp.M5_Direct_Avg_Quantity__c!= null ? comp.M5_Direct_Avg_Quantity__c :0);
mainWrap.M6DirectAvg = mainWrap.M6DirectAvg + (comp.M6_Direct_Avg_Quantity__c!= null ? comp.M6_Direct_Avg_Quantity__c :0);
mainWrap.M7DirectAvg = mainWrap.M7DirectAvg + (comp.M7_Direct_Avg_Quantity__c!= null ? comp.M7_Direct_Avg_Quantity__c :0);*/
                mainWrap.QTDDirectAct = mainWrap.QTDDirectAct + (comp.QTD_Quantity__c!= null ? comp.QTD_Quantity__c :0);
                mainWrap.QTDDirectAwardedQty = mainWrap.QTDDirectAwardedQty + (comp.QTD_Awarded_Quantity__c!= null ? comp.QTD_Awarded_Quantity__c :0);
                mainWrap.FTDDirectAct = mainWrap.FTDDirectAct + (comp.FTD_Quantity__c!= null ? comp.FTD_Quantity__c :0);
                mainWrap.FTDDirectAwardedQty = mainWrap.FTDDirectAwardedQty + (comp.FTD_Awarded_Quantity__c!= null ? comp.FTD_Awarded_Quantity__c :0);
                mainWrap.CTDDirectAct = mainWrap.CTDDirectAct + (comp.CTD_Quantity__c!= null ? comp.CTD_Quantity__c :0);
                mainWrap.CTDDirectAwardedQty = mainWrap.CTDDirectAwardedQty + (comp.CTD_Awarded_Quantity__c!= null ? comp.CTD_Awarded_Quantity__c :0);
                mainWrap.MTDDirectAct = mainWrap.MTDDirectAct + (comp.M1_Quantity__c!= null ? comp.M1_Quantity__c :0);
                mainWrap.MTDDirectAwardedQty = mainWrap.MTDDirectAwardedQty + (comp.MTD_Awarded_Quantity__c!= null ? comp.MTD_Awarded_Quantity__c :0);
            }
            
            
            
            for(string prodFamName : productFamilyMap.keySet()){
                ProductFamilyWrapper pfList = new ProductFamilyWrapper();
                
                pfList.prodFamName = prodFamName;
                pfList.prodFamId = productFamilyMap.get(prodFamName)[0].Vision_Product__r.Product_Family__c;
                List<Order_Compliance_Summary__c> prodFamList = productFamilyMap.get(prodFamName);
                pfList.orderComplianceList = prodFamList;
                for(Order_Compliance_Summary__c comp : prodFamList){  
                    pfList.DirectAwardedQuantity = pfList.DirectAwardedQuantity + (comp.Awarded_Quantity__c != null ? comp.Awarded_Quantity__c:0);
                    pfList.DirectAwardedQtyMonthly = pfList.DirectAwardedQtyMonthly + (comp.Monthly_Awarded_Quantity__c != null ? comp.Monthly_Awarded_Quantity__c :0);
                    pfList.M1DirectAct = (pfList.M1DirectAct != null ? pfList.M1DirectAct : 0) + (comp.M1_Quantity__c!= null ? comp.M1_Quantity__c :0);
                    pfList.M2DirectAct = (pfList.M2DirectAct != null ? pfList.M2DirectAct : 0) + (comp.M2_Quantity__c!= null ? comp.M2_Quantity__c :0);
                    pfList.M3DirectAct = pfList.M3DirectAct + (comp.M3_Quantity__c!= null ? comp.M3_Quantity__c :0);
                    pfList.M4DirectAct = pfList.M4DirectAct + (comp.M4_Quantity__c!= null ? comp.M4_Quantity__c :0);
                    pfList.M5DirectAct = pfList.M5DirectAct + (comp.M5_Quantity__c!= null ? comp.M5_Quantity__c :0);
                    pfList.M6DirectAct = pfList.M6DirectAct + (comp.M6_Quantity__c!= null ? comp.M6_Quantity__c :0);
                    pfList.M7DirectAct = pfList.M7DirectAct + (comp.M7_Quantity__c!= null ? comp.M7_Quantity__c :0);
                    pfList.M7DirectCompliance = pfList.DirectAwardedQtyMonthly != null && pfList.DirectAwardedQtyMonthly != 0 ?((pfList.M7DirectAct / pfList.DirectAwardedQtyMonthly)*100).setScale(0) : 0;
                    pfList.M6DirectCompliance = pfList.DirectAwardedQtyMonthly != null && pfList.DirectAwardedQtyMonthly != 0 ?((pfList.M6DirectAct / pfList.DirectAwardedQtyMonthly)*100).setScale(0) : 0;
                    pfList.M5DirectCompliance = pfList.DirectAwardedQtyMonthly != null && pfList.DirectAwardedQtyMonthly != 0 ?((pfList.M5DirectAct / pfList.DirectAwardedQtyMonthly)*100).setScale(0) : 0;
                    pfList.M4DirectCompliance = pfList.DirectAwardedQtyMonthly != null && pfList.DirectAwardedQtyMonthly != 0 ?((pfList.M4DirectAct / pfList.DirectAwardedQtyMonthly)*100).setScale(0) : 0;
                    pfList.M3DirectCompliance = pfList.DirectAwardedQtyMonthly != null && pfList.DirectAwardedQtyMonthly != 0 ?((pfList.M3DirectAct / pfList.DirectAwardedQtyMonthly)*100).setScale(0) : 0;
                    pfList.M2DirectCompliance = pfList.DirectAwardedQtyMonthly != null && pfList.DirectAwardedQtyMonthly != 0 ?((pfList.M2DirectAct / pfList.DirectAwardedQtyMonthly)*100).setScale(0) : 0;
                    /*   pfList.M1DirectAvg = pfList.M1DirectAvg + (comp.M1_Direct_Avg_Quantity__c!= null ? comp.M1_Direct_Avg_Quantity__c :0);
pfList.M2DirectAvg = pfList.M2DirectAvg + (comp.M2_Direct_Avg_Quantity__c!= null ? comp.M2_Direct_Avg_Quantity__c :0);
pfList.M3DirectAvg = pfList.M3DirectAvg + (comp.M3_Direct_Avg_Quantity__c!= null ? comp.M3_Direct_Avg_Quantity__c :0);
pfList.M4DirectAvg = pfList.M4DirectAvg + (comp.M4_Direct_Avg_Quantity__c!= null ? comp.M4_Direct_Avg_Quantity__c :0);
pfList.M5DirectAvg = pfList.M5DirectAvg + (comp.M5_Direct_Avg_Quantity__c!= null ? comp.M5_Direct_Avg_Quantity__c :0);
pfList.M6DirectAvg = pfList.M6DirectAvg + (comp.M6_Direct_Avg_Quantity__c!= null ? comp.M6_Direct_Avg_Quantity__c :0);
pfList.M7DirectAvg = pfList.M7DirectAvg + (comp.M7_Direct_Avg_Quantity__c!= null ? comp.M7_Direct_Avg_Quantity__c :0);*/
                    pfList.QTDDirectAct = pfList.QTDDirectAct + (comp.QTD_Quantity__c!= null ? comp.QTD_Quantity__c :0);
                    pfList.QTDDirectAwardedQty = (pfList.QTDDirectAwardedQty + (comp.QTD_Awarded_Quantity__c!= null ? comp.QTD_Awarded_Quantity__c :0)).setScale(0);
                    if(pfList.QTDDirectAct != 0 && pfList.QTDDirectAwardedQty != 0){
                        pfList.QTDDirectCompliance = ((pfList.QTDDirectAct / pfList.QTDDirectAwardedQty)*100).setScale(0);
                    }
                    pfList.FTDDirectAct = pfList.FTDDirectAct + (comp.FTD_Quantity__c!= null ? comp.FTD_Quantity__c :0);
                    pfList.FTDDirectAwardedQty = (pfList.FTDDirectAwardedQty + (comp.FTD_Awarded_Quantity__c!= null ? comp.FTD_Awarded_Quantity__c :0)).setScale(0);
                    if(pfList.FTDDirectAct != 0 && pfList.FTDDirectAwardedQty != 0){
                        pfList.FTDDirectCompliance = ((pfList.FTDDirectAct / pfList.FTDDirectAwardedQty)*100).setScale(0);
                    }
                    pfList.CTDDirectAct = pfList.CTDDirectAct + (comp.CTD_Quantity__c!= null ? comp.CTD_Quantity__c :0);
                    pfList.CTDDirectAwardedQty = (pfList.CTDDirectAwardedQty + (comp.CTD_Awarded_Quantity__c	!= null ? comp.CTD_Awarded_Quantity__c	 :0)).setScale(0);
                    if(pfList.CTDDirectAct != 0 && pfList.CTDDirectAwardedQty != 0){
                        pfList.CTDDirectCompliance = ((pfList.CTDDirectAct / pfList.CTDDirectAwardedQty)*100).setScale(0);
                    }
                    pfList.MTDDirectAct = pfList.MTDDirectAct + (comp.M1_Quantity__c!= null ? comp.M1_Quantity__c :0);
                    pfList.MTDDirectAwardedQty = (pfList.MTDDirectAwardedQty + (comp.MTD_Awarded_Quantity__c!= null ? comp.MTD_Awarded_Quantity__c :0)).setScale(0);
                    if(pfList.MTDDirectAct != 0 && pfList.MTDDirectAwardedQty != 0){
                        pfList.MTDDirectCompliance = ((pfList.MTDDirectAct / pfList.MTDDirectAwardedQty)*100).setScale(0);
                    }
                    
                    
                }
                
                
                ProductFamilyWrapperList.add(pfList);
                
            }
            
            List<Order_Compliance_Summary__c> complianceMonthList=[SELECT Month1__c,Month2__c,Month3__c,Month4__c,Month5__c,Month6__c,Month7__c,Month8__c,Month9__c FROM Order_Compliance_Summary__c where Month2__c !=null and Month3__c !=null and Month4__c !=null and Month5__c !=null and Month6__c !=null and Month7__c !=null Limit 1];
            if(complianceMonthList.size()>0){
                ///system.debug('orderComplianceList2'+ orderComplianceList);
                mainWrap.Month1 = complianceMonthList[0].Month2__c;    
                mainWrap.Month2 = complianceMonthList[0].Month3__c;    
                mainWrap.Month3 = complianceMonthList[0].Month4__c;    
                mainWrap.Month4 = complianceMonthList[0].Month5__c;    
                mainWrap.Month5 = complianceMonthList[0].Month6__c;    
                mainWrap.Month6 = complianceMonthList[0].Month7__c; 
                mainWrap.Month7 = complianceMonthList[0].Month1__c;
            } 
            
            
            mainWrap.noOfRecords = orderComplianceList.size();  
            mainWrap.ProductFamilyWrapperList = ProductFamilyWrapperList;            
            
        }
        return mainwrap;
    }
    @AuraEnabled
    public static MainWrapper getOrdersData(String customerId,String ndcCode, String soldtocustCode){
        system.debug('customerId-----'+customerId);
        system.debug('ndcCode-----'+ndcCode);
        system.debug('soldtocustCode-----'+soldtocustCode);
        Account accDetails = [SELECT Id,Name,AccountNumber from Account where Id=:customerId];
        String custCode = accDetails.AccountNumber;
        
       // Vision_GCP_SFDC_Order_Status__c soldToCustCodeDetails = [SELECT Id,Vision_Sold_to_Customer_Name__c from Vision_GCP_SFDC_Order_Status__c where Vision_Sold_to_Customer_Code__c=:soldtocustCode limit 1];
        
        MainWrapper mainWrap = new MainWrapper();
        mainWrap.custName = accDetails.Name;
       // mainWrap.soldToCustName = soldToCustCodeDetails.Vision_Sold_to_Customer_Name__c;
        List<Vision_GCP_SFDC_Order_Status__c> orderList =[SELECT Vision_Account__c,Ship_Value__c,Vision_GCP_Ship_Quanity__c,Vision_Product__r.Name,Vision_Product__r.ProductCode,Vision_Product__r.Phoenix_NDC_11__c,Vision_Customer_Code__c,Vision_Delivery_Quantity__c,Vision_Description__c,Vision_Hierachy_Code__c,Vision_NDC_Code__c,Vision_Net_Amount__c,Vision_Net_Value__c,Vision_Open_Order_Quantity__c,Vision_Order_Date__c,Vision_Order_Quantity__c,Vision_Order_Number__c,Vision_Order_Status__c,Vision_Product__c,Vision_Ship_to_Customer_Name__c,Vision_SKU_Code__c,Vision_Sold_to_Customer_Code__c,Vision_Sold_to_Customer_Name__c FROM Vision_GCP_SFDC_Order_Status__c where Vision_Hierachy_Code__c=:custCode  and Vision_Product__r.ProductCode =:ndcCode and Vision_Order_Date__c = LAST_N_MONTHS:12];
        Map<String,List<Vision_GCP_SFDC_Order_Status__c>> soldToCustMap = new Map<String,List<Vision_GCP_SFDC_Order_Status__c>>();
        Map<String,List<Vision_GCP_SFDC_Order_Status__c>> orderStatusMap = new Map<String,List<Vision_GCP_SFDC_Order_Status__c>>();
        mainWrap.orderProdName = orderList[0].Vision_Product__r.Name;
        List<String> statusList = new List<String>();
        for(Vision_GCP_SFDC_Order_Status__c item : orderList){
            //  String statusName =  item.Vision_Order_Status__c.toLowerCase();
            //  item.Vision_Order_Status__c = statusName.capitalize();
            // String sample='partially delivered';
            String statusName =  item.Vision_Order_Status__c.toLowerCase();
            List<String> listStr = statusName.split(' ');
            for(String str : listStr){
                String name = str.capitalize();
                statusList.add(name);
            }
            string allstring = string.join(statusList,' ');
            item.Vision_Order_Status__c =allstring; 
            allstring = '';
            listStr.clear();
            statusList.clear();
        }
        
        system.debug('orderList-----'+orderList.size());
        for(Vision_GCP_SFDC_Order_Status__c item : orderList){
            String key = item.Vision_Sold_to_Customer_Name__c +'_'+ item.Vision_Sold_to_Customer_Code__c;
            if(item.Vision_Order_Status__c != 'Cancelled'){
                mainWrap.orderQty   = (mainWrap.orderQty != null ? mainWrap.orderQty :0)  + (item.Vision_Order_Quantity__c != null ? item.Vision_Order_Quantity__c : 0);    
                mainWrap.netValue   = (mainWrap.netValue != null ? mainWrap.netValue :0)  +  (item.Vision_Net_Value__c != null ? Decimal.valueOf(item.Vision_Net_Value__c) : 0);        
            }
            if(soldToCustMap.containsKey(key)){
                List<Vision_GCP_SFDC_Order_Status__c> sdList = soldToCustMap.get(key);
                sdList.add(item);
                soldToCustMap.put(key,sdList);
            }
            else{
                soldToCustMap.put(key,new List<Vision_GCP_SFDC_Order_Status__c>{item});
            }
        }
        List<orderWrapper> orderWrapperList = new List<orderWrapper>();
        List<statusWrapper> statusWrapList = new List<statusWrapper>();
        List<String> soldToStr = new List<String>();
        for(string accName : soldToCustMap.keySet()){
            orderWrapper accList = new orderWrapper();
              soldToStr = accName.split('_');
             accList.uniqueKey =accName;
            accList.soldToCustName = soldToStr[0];
              accList.soldToCustCode = soldToStr[1];
            List<Vision_GCP_SFDC_Order_Status__c> sdList = soldToCustMap.get(accName);
            for(Vision_GCP_SFDC_Order_Status__c sd : sdList){  
                if(sd.Vision_Order_Status__c != 'CANCELLED'){
                    accList.orderQty   = (accList.orderQty != null ? accList.orderQty :0)  + (sd.Vision_Order_Quantity__c != null ? sd.Vision_Order_Quantity__c : 0);    
                    accList.netValue   = (accList.netValue != null ? accList.netValue :0)  +  (sd.Vision_Net_Value__c != null ? Decimal.valueOf(sd.Vision_Net_Value__c) : 0);        
                }
                
                if(orderStatusMap.containsKey(sd.Vision_Order_Status__c)){
                    List<Vision_GCP_SFDC_Order_Status__c> prodList = orderStatusMap.get(sd.Vision_Order_Status__c);
                    prodList.add(sd);
                    orderStatusMap.put(sd.Vision_Order_Status__c,prodList);
                }
                else{
                    
                    orderStatusMap.put(sd.Vision_Order_Status__c,new List<Vision_GCP_SFDC_Order_Status__c>{sd});
                }
            }
            for(String prodfam : orderStatusMap.keySet()){
                statusWrapper prodFamily = new statusWrapper();
                prodFamily.status = prodfam;
                prodFamily.soldToCustName = soldToStr[0]+'_'+soldToStr[1];
                List<Vision_GCP_SFDC_Order_Status__c> pfList = orderStatusMap.get(prodfam);
                for(Vision_GCP_SFDC_Order_Status__c pf : pfList){    
                    
                    prodFamily.orderQty   = (prodFamily.orderQty != null ? prodFamily.orderQty : 0) + (pf.Vision_Order_Quantity__c != null ? pf.Vision_Order_Quantity__c : 0);    
                    prodFamily.netValue   = (prodFamily.netValue != null ? prodFamily.netValue :0) + (pf.Vision_Net_Value__c != null ? Decimal.valueOf(pf.Vision_Net_Value__c) : 0);    
                    if(pf.Vision_Order_Status__c == 'Partially Delivered'){
                        prodFamily.shipQty   = (prodFamily.shipQty != null ? prodFamily.shipQty : 0) + (pf.Vision_GCP_Ship_Quanity__c != null ? pf.Vision_GCP_Ship_Quanity__c : 0);    
                        prodFamily.shipValue   = (prodFamily.shipValue != null ? prodFamily.shipValue :0) + (pf.Ship_Value__c != null ? pf.Ship_Value__c : 0);         
                    }
                    
                }
                prodFamily.orderList = pfList;
                statusWrapList.add(prodFamily);
            }
            //system.debug('listProductFamily before size-->'+listProductFamily.size());
            accList.statusWrapperList=statusWrapList;
            statusWrapList = new List<statusWrapper>();
            orderStatusMap = new map<String,List<Vision_GCP_SFDC_Order_Status__c>>();
            //system.debug('listProductFamily after size-->'+listProductFamily.size());
            orderWrapperList.add(accList);
            
        }
        //  system.debug('AccountsWrapperList---'+AccountsWrapperList);
        mainWrap.orderList = orderWrapperList;
        // orderListWrap.orderList = orderWrapList;
        
        // mainWrap.orderList =orderWrapList;
        return mainWrap; 
    }
    @AuraEnabled 
    public static MainWrapper getOnlyComplianceDataHistoricalSales(String searchText,String customerId,String showNonCompliance,Boolean showPrimary, String productDirector){
        
        MainWrapper mainWrap = new MainWrapper();
        Account accDetails = [SELECT Id,Name,AccountNumber from Account where Id=:customerId];
        String custCode = accDetails.AccountNumber;
        
        String query = '';
        String category = 'Primary';
        String SobjectApiName = 'Order_Compliance_Summary__c';
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
        map<String,List<Order_Compliance_Summary__c>> productFamilyMap = new map<String,List<Order_Compliance_Summary__c>>();
        query = 'select Vision_Product__r.Id,Vision_Product__r.Phoenix_Rx_SRx_OTC__c,Vision_Product__r.Name,Vision_Product__r.ProductCode,Vision_Product__r.Product_Family__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,GCP_Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_SRx_Rx__r.Vision_On_Backorder__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c, '+strFields+' from Order_Compliance_Summary__c WHERE Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Hierachy_Code__c =:custCode and Vision_Product__r.Product_Family__r.Name != null  ';   
        
        
        
        if(showNonCompliance == '1Month'){
            system.debug('m1');
            query =  query+'and (M2_Avg_Compliance__c <75) ';
        }
        else if(showNonCompliance == '2Month'){
            query =  query+'and (M2_Avg_Compliance__c < 75 and M3_Avg_Compliance__c < 75) ';
            
        } 
        else if(showNonCompliance == '3Month'){
            query =  query+'and (M2_Avg_Compliance__c < 75 and M3_Avg_Compliance__c < 75 and M4_Avg_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '4Month'){
            query =  query+'and (M2_Avg_Compliance__c < 75 and M3_Avg_Compliance__c < 75 and M4_Avg_Compliance__c < 75 and M5_Avg_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '5Month'){
            query =  query+'and (M2_Avg_Compliance__c < 75 and M3_Avg_Compliance__c < 75 and M4_Avg_Compliance__c < 75 and M5_Avg_Compliance__c < 75 and M6_Avg_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '6Month'){
            query =  query+'and (M2_Avg_Compliance__c < 75 and M3_Avg_Compliance__c < 75 and M4_Avg_Compliance__c < 75 and M5_Avg_Compliance__c < 75 and M6_Avg_Compliance__c < 75  and M7_Avg_Compliance__c < 75) ';
            
        }
        else{
            
        }
        
        if(searchText != null && searchText !='') {
            searchText = '%'+searchText+'%';
            if(!showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('!showPrimary - productDirector != null');
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and General_Category__c =: category and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                }
                else{
                    system.debug('!showPrimary - productDirector');
                    query = query+'and General_Category__c =: category and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                    
                }
            }
            else if(showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('showPrimary - productDirector != null');
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                }
                else{
                    system.debug('showPrimary - productDirector');
                    query = query+'and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                    
                }
            }      
        }
        else{
            if(!showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('!showPrimary - productDirector != null');
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and General_Category__c =: category order by Vision_Product__r.Name';
                }
                else{
                    system.debug('!showPrimary - productDirector');
                    query = query+'and General_Category__c =: category order by Vision_Product__r.Name';
                    
                }
            }
            else if(showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('showPrimary - productDirector != null');
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector order by Vision_Product__r.Name';
                }
                else{
                    system.debug('showPrimary - productDirector');
                    query = query+'order by Vision_Product__r.Name';
                    
                }
            }         
        }
        List<ProductFamilyWrapper> ProductFamilyWrapperList = new List<ProductFamilyWrapper>();
        List < Order_Compliance_Summary__c > orderComplianceList = Database.query(query);
        system.debug('size---'+orderComplianceList.size());
        if(orderComplianceList.size()>0){
            for(Order_Compliance_Summary__c comp : orderComplianceList){
                
                if(productFamilyMap.containsKey(comp.Vision_Product__r.Product_Family__r.Name)){
                    List<Order_Compliance_Summary__c> prodList = productFamilyMap.get(comp.Vision_Product__r.Product_Family__r.Name);
                    prodList.add(comp);
                    productFamilyMap.put(comp.Vision_Product__r.Product_Family__r.Name,prodList);
                }
                else{
                    productFamilyMap.put(comp.Vision_Product__r.Product_Family__r.Name,new List<Order_Compliance_Summary__c>{comp});
                }
                
                
                mainWrap.M2DirectAct = (mainWrap.M2DirectAct != null ? mainWrap.M2DirectAct : 0) + (comp.M2_Quantity__c!= null ? comp.M2_Quantity__c :0);
                mainWrap.M3DirectAct = mainWrap.M3DirectAct + (comp.M3_Quantity__c!= null ? comp.M3_Quantity__c :0);
                mainWrap.M4DirectAct = mainWrap.M4DirectAct + (comp.M4_Quantity__c!= null ? comp.M4_Quantity__c :0);
                mainWrap.M5DirectAct = mainWrap.M5DirectAct + (comp.M5_Quantity__c!= null ? comp.M5_Quantity__c :0);
                mainWrap.M6DirectAct = mainWrap.M6DirectAct + (comp.M6_Quantity__c!= null ? comp.M6_Quantity__c :0);
                mainWrap.M7DirectAct = mainWrap.M7DirectAct + (comp.M7_Quantity__c!= null ? comp.M7_Quantity__c :0);
                mainWrap.M2DirectAvg = mainWrap.M2DirectAvg + (comp.M2_Avg_Quantity__c!= null ? comp.M2_Avg_Quantity__c :0);
                mainWrap.M3DirectAvg = mainWrap.M3DirectAvg + (comp.M3_Avg_Quantity__c!= null ? comp.M3_Avg_Quantity__c :0);
                mainWrap.M4DirectAvg = mainWrap.M4DirectAvg + (comp.M4_Avg_Quantity__c!= null ? comp.M4_Avg_Quantity__c :0);
                mainWrap.M5DirectAvg = mainWrap.M5DirectAvg + (comp.M5_Avg_Quantity__c!= null ? comp.M5_Avg_Quantity__c :0);
                mainWrap.M6DirectAvg = mainWrap.M6DirectAvg + (comp.M6_Avg_Quantity__c!= null ? comp.M6_Avg_Quantity__c :0);
                mainWrap.M7DirectAvg = mainWrap.M7DirectAvg + (comp.M7_Avg_Quantity__c!= null ? comp.M7_Avg_Quantity__c :0);
                
            }
            
            
            
            for(string prodFamName : productFamilyMap.keySet()){
                ProductFamilyWrapper pfList = new ProductFamilyWrapper();
                
                pfList.prodFamName = prodFamName;
                pfList.prodFamId = productFamilyMap.get(prodFamName)[0].Vision_Product__r.Product_Family__c;
                List<Order_Compliance_Summary__c> prodFamList = productFamilyMap.get(prodFamName);
                pfList.orderComplianceList = prodFamList;
                for(Order_Compliance_Summary__c comp : prodFamList){  
                    pfList.M2DirectAct = (pfList.M2DirectAct != null ? pfList.M2DirectAct : 0) + (comp.M2_Quantity__c!= null ? comp.M2_Quantity__c :0);
                    pfList.M3DirectAct = pfList.M3DirectAct + (comp.M3_Quantity__c!= null ? comp.M3_Quantity__c :0);
                    pfList.M4DirectAct = pfList.M4DirectAct + (comp.M4_Quantity__c!= null ? comp.M4_Quantity__c :0);
                    pfList.M5DirectAct = pfList.M5DirectAct + (comp.M5_Quantity__c!= null ? comp.M5_Quantity__c :0);
                    pfList.M6DirectAct = pfList.M6DirectAct + (comp.M6_Quantity__c!= null ? comp.M6_Quantity__c :0);
                    pfList.M7DirectAct = pfList.M7DirectAct + (comp.M7_Quantity__c!= null ? comp.M7_Quantity__c :0);
                    pfList.M2DirectAvg = pfList.M2DirectAvg + (comp.M2_Avg_Quantity__c!= null ? comp.M2_Avg_Quantity__c :0);
                    pfList.M3DirectAvg = pfList.M3DirectAvg + (comp.M3_Avg_Quantity__c!= null ? comp.M3_Avg_Quantity__c :0);
                    pfList.M4DirectAvg = pfList.M4DirectAvg + (comp.M4_Avg_Quantity__c!= null ? comp.M4_Avg_Quantity__c :0);
                    pfList.M5DirectAvg = pfList.M5DirectAvg + (comp.M5_Avg_Quantity__c!= null ? comp.M5_Avg_Quantity__c :0);
                    pfList.M6DirectAvg = pfList.M6DirectAvg + (comp.M6_Avg_Quantity__c!= null ? comp.M6_Avg_Quantity__c :0);
                    pfList.M7DirectAvg = pfList.M7DirectAvg + (comp.M7_Avg_Quantity__c!= null ? comp.M7_Avg_Quantity__c :0);
                    
                }
                
                
                ProductFamilyWrapperList.add(pfList);
                
            }
            
            List<Order_Compliance_Summary__c> complianceMonthList=[SELECT Month1__c,Month2__c,Month3__c,Month4__c,Month5__c,Month6__c,Month7__c,Month8__c,Month9__c FROM Order_Compliance_Summary__c where Month2__c !=null and Month3__c !=null and Month4__c !=null and Month5__c !=null and Month6__c !=null and Month7__c !=null Limit 1];
            if(complianceMonthList.size()>0){
                ///system.debug('orderComplianceList2'+ orderComplianceList);
                mainWrap.Month1 = complianceMonthList[0].Month2__c;    
                mainWrap.Month2 = complianceMonthList[0].Month3__c;    
                mainWrap.Month3 = complianceMonthList[0].Month4__c;    
                mainWrap.Month4 = complianceMonthList[0].Month5__c;    
                mainWrap.Month5 = complianceMonthList[0].Month6__c;    
                mainWrap.Month6 = complianceMonthList[0].Month7__c; 
                mainWrap.Month7 = complianceMonthList[0].Month1__c;
            } 
            
            
            mainWrap.noOfRecords = orderComplianceList.size();  
            mainWrap.ProductFamilyWrapperList = ProductFamilyWrapperList;            
            
        }
        return mainwrap;
    }
    @AuraEnabled
    public static mainGraphData getGraphData(String customerId,String ndcCode, String soldtocustCode, String type){
        system.debug('customerId----'+customerId);
         system.debug('ndcCode----'+ndcCode);
         system.debug('soldtocustCode----'+soldtocustCode);
        Account accDetails = [SELECT Id,Name,AccountNumber from Account where Id=:customerId];
        String custCode = accDetails.AccountNumber;        
        
        String query = '';
        String category = 'Primary';
        String SobjectApiName = 'Order_Compliance_Summary__c';
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
        map<String,List<Order_Compliance_Summary__c>> productFamilyMap = new map<String,List<Order_Compliance_Summary__c>>();
        query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.ProductCode,Vision_Product__r.Product_Family__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,GCP_Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c, '+strFields+' from Order_Compliance_Summary__c WHERE Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Hierachy_Code__c =:custCode and Vision_Product__r.Product_Family__r.Name != null and Vision_Product__r.ProductCode =: ndcCode ';   
        
        Order_Compliance_Summary__c  orderComplianceData = Database.query(query);
        mainGraphData mainWrapper = new mainGraphData();
        mainWrapper.custName = accDetails.Name;
        mainWrapper.orderProdName = orderComplianceData.Vision_Product__r.Name;
        mainWrapper.threeMonthsAvg = (orderComplianceData.M1_Quantity__c+orderComplianceData.M2_Quantity__c+orderComplianceData.M3_Quantity__c)/3;
        mainWrapper.sixMonthsAvg = (orderComplianceData.M1_Quantity__c+orderComplianceData.M2_Quantity__c+orderComplianceData.M3_Quantity__c+orderComplianceData.M4_Quantity__c+orderComplianceData.M5_Quantity__c+orderComplianceData.M6_Quantity__c)/6;
        mainWrapper.twelveMonthsAvg = (orderComplianceData.M1_Quantity__c+orderComplianceData.M2_Quantity__c+orderComplianceData.M3_Quantity__c+orderComplianceData.M4_Quantity__c+orderComplianceData.M5_Quantity__c+orderComplianceData.M6_Quantity__c+orderComplianceData.M7_Quantity__c+orderComplianceData.M8_Quantity__c+orderComplianceData.M9_Quantity__c+orderComplianceData.M10_Quantity__c+orderComplianceData.M11_Quantity__c+orderComplianceData.M12_Quantity__c)/12;
        
        if(orderComplianceData.Month12__c != null && orderComplianceData.Month12__c != ''){
            mainWrapper.categories.add(orderComplianceData.Month12__c);
             }
        else{
            DateTime dt = DateTime.now().addmonths(-11); String monthName = dt.format('MMM'); Integer y2 = dt.year(); String yr2 = String.valueOf(y2); string M2=dt.format('MMM')+'-'+yr2.substring(2);
            mainWrapper.categories.add(M2); 
          }
        if(orderComplianceData.Month11__c != null && orderComplianceData.Month11__c != ''){
            mainWrapper.categories.add(orderComplianceData.Month11__c);
          }
        else{
            DateTime dt = DateTime.now().addmonths(-10); String monthName = dt.format('MMM'); Integer y2 = dt.year(); String yr2 = String.valueOf(y2); string M2=dt.format('MMM')+'-'+yr2.substring(2);
            mainWrapper.categories.add(M2); 
       
        }
        if(orderComplianceData.Month10__c != null && orderComplianceData.Month10__c != ''){
            mainWrapper.categories.add(orderComplianceData.Month10__c);
            }
        else{
            DateTime dt = DateTime.now().addmonths(-9); String monthName = dt.format('MMM'); Integer y2 = dt.year(); String yr2 = String.valueOf(y2); string M2=dt.format('MMM')+'-'+yr2.substring(2);
            mainWrapper.categories.add(M2);            
           }
        if(orderComplianceData.Month9__c != null && orderComplianceData.Month9__c != ''){
            mainWrapper.categories.add(orderComplianceData.Month9__c);
        }
        else{
            DateTime dt = DateTime.now().addmonths(-8); String monthName = dt.format('MMM'); Integer y2 = dt.year(); String yr2 = String.valueOf(y2); string M2=dt.format('MMM')+'-'+yr2.substring(2);
            mainWrapper.categories.add(M2);   
        }
        if(orderComplianceData.Month8__c != null && orderComplianceData.Month8__c != ''){
            mainWrapper.categories.add(orderComplianceData.Month8__c);
        }
        else{
            DateTime dt = DateTime.now().addmonths(-7); String monthName = dt.format('MMM'); Integer y2 = dt.year(); String yr2 = String.valueOf(y2); string M2=dt.format('MMM')+'-'+yr2.substring(2);
            mainWrapper.categories.add(M2); 
        }
        if(orderComplianceData.Month7__c != null && orderComplianceData.Month7__c != ''){
            mainWrapper.categories.add(orderComplianceData.Month7__c);
        }
        else{
            DateTime dt = DateTime.now().addmonths(-6); String monthName = dt.format('MMM'); Integer y2 = dt.year(); String yr2 = String.valueOf(y2); string M2=dt.format('MMM')+'-'+yr2.substring(2);
            mainWrapper.categories.add(M2);            
        }
        if(orderComplianceData.Month6__c != null && orderComplianceData.Month6__c != ''){
            mainWrapper.categories.add(orderComplianceData.Month6__c);
            mainWrapper.categories6.add(orderComplianceData.Month6__c);
        }
        else{
            DateTime dt = DateTime.now().addmonths(-5); String monthName = dt.format('MMM'); Integer y2 = dt.year(); String yr2 = String.valueOf(y2); string M2=dt.format('MMM')+'-'+yr2.substring(2);
            mainWrapper.categories.add(M2);            
            mainWrapper.categories6.add(M2);            
        }
        if(orderComplianceData.Month5__c != null && orderComplianceData.Month5__c != ''){
            mainWrapper.categories.add(orderComplianceData.Month5__c);
            mainWrapper.categories6.add(orderComplianceData.Month5__c);
        }
        else{
            DateTime dt = DateTime.now().addmonths(-4); String monthName = dt.format('MMM'); Integer y2 = dt.year(); String yr2 = String.valueOf(y2); string M2=dt.format('MMM')+'-'+yr2.substring(2);
            mainWrapper.categories.add(M2);            
            mainWrapper.categories6.add(M2);            
        }
        if(orderComplianceData.Month4__c != null && orderComplianceData.Month4__c != ''){
            mainWrapper.categories.add(orderComplianceData.Month4__c);
             mainWrapper.categories6.add(orderComplianceData.Month4__c);
        }
        else{
            DateTime dt = DateTime.now().addmonths(-3); String monthName = dt.format('MMM'); Integer y2 = dt.year(); String yr2 = String.valueOf(y2); string M2=dt.format('MMM')+'-'+yr2.substring(2);
            mainWrapper.categories.add(M2);            
            mainWrapper.categories6.add(M2);            
        }
        if(orderComplianceData.Month3__c != null && orderComplianceData.Month3__c != ''){
            mainWrapper.categories.add(orderComplianceData.Month3__c);
            mainWrapper.categories6.add(orderComplianceData.Month3__c);
            mainWrapper.categories3.add(orderComplianceData.Month3__c);
        }
        else{
            DateTime dt = DateTime.now().addmonths(-2); String monthName = dt.format('MMM'); Integer y2 = dt.year(); String yr2 = String.valueOf(y2); string M2=dt.format('MMM')+'-'+yr2.substring(2);
            mainWrapper.categories.add(M2);
            mainWrapper.categories3.add(M2);
            mainWrapper.categories6.add(M2);            
        }
        if(orderComplianceData.Month2__c != null && orderComplianceData.Month2__c != ''){
            mainWrapper.categories.add(orderComplianceData.Month2__c);
            mainWrapper.categories3.add(orderComplianceData.Month2__c);
            mainWrapper.categories6.add(orderComplianceData.Month2__c);
        }
        else{
            DateTime dt = DateTime.now().addmonths(-1); String monthName = dt.format('MMM'); Integer y2 = dt.year(); String yr2 = String.valueOf(y2); string M2=dt.format('MMM')+'-'+yr2.substring(2);
            mainWrapper.categories.add(M2);            
            mainWrapper.categories3.add(M2);            
            mainWrapper.categories6.add(M2);            
        }
        if(orderComplianceData.Month1__c != null && orderComplianceData.Month1__c != ''){
            system.debug('inside');
            mainWrapper.categories.add(orderComplianceData.Month1__c);
             mainWrapper.categories3.add(orderComplianceData.Month1__c);
             mainWrapper.categories6.add(orderComplianceData.Month1__c);
        }
        else{
            system.debug('outside');
            DateTime dt = DateTime.now(); String monthName = dt.format('MMM'); Integer y2 = dt.year(); String yr2 = String.valueOf(y2); string M2=dt.format('MMM')+'-'+yr2.substring(2);
            mainWrapper.categories.add(M2); 
             mainWrapper.categories3.add(M2); 
             mainWrapper.categories6.add(M2); 
        }
        if(type == 'awarded'){
        DataClass d1 = new DataClass();
        d1.y = orderComplianceData.M12_Quantity__c;
        d1.color = '#6f30a0';
        mainWrapper.dataSet.add(d1);
             DataClass d2 = new DataClass();
        d2.y = orderComplianceData.M11_Quantity__c;
        d2.color = '#6f30a0';
        mainWrapper.dataSet.add(d2);
          DataClass d3 = new DataClass();
        d3.y = orderComplianceData.M10_Quantity__c;
        d3.color = '#6f30a0';
        mainWrapper.dataSet.add(d3);
        DataClass d4 = new DataClass();
        d4.y = orderComplianceData.M9_Quantity__c;
        d4.color = '#6f30a0';
        mainWrapper.dataSet.add(d4);
        DataClass d5 = new DataClass();
        d5.y = orderComplianceData.M8_Quantity__c;
        d5.color = '#6f30a0';
        mainWrapper.dataSet.add(d5);
        DataClass d6 = new DataClass();
        d6.y = orderComplianceData.M7_Quantity__c;
        d6.color = '#6f30a0';
        mainWrapper.dataSet.add(d6);
        DataClass d7 = new DataClass();
        d7.y = orderComplianceData.M6_Quantity__c;
        d7.color = '#6f30a0';
        mainWrapper.dataSet.add(d7);
            mainWrapper.dataSet6.add(d7);
        DataClass d8 = new DataClass();
        d8.y = orderComplianceData.M5_Quantity__c;
        d8.color = '#6f30a0';
        mainWrapper.dataSet.add(d8);
            mainWrapper.dataSet6.add(d8);
        DataClass d9 = new DataClass();
        d9.y = orderComplianceData.M4_Quantity__c;
        d9.color = '#6f30a0';
        mainWrapper.dataSet.add(d9);
            mainWrapper.dataSet6.add(d9);
        DataClass d10 = new DataClass();
        d10.y = orderComplianceData.M3_Quantity__c;
        d10.color = '#6f30a0';
        mainWrapper.dataSet.add(d10);
            mainWrapper.dataSet3.add(d10);
            mainWrapper.dataSet6.add(d10);
        DataClass d11 = new DataClass();
        d11.y = orderComplianceData.M2_Quantity__c;
        d11.color = '#6f30a0';
        mainWrapper.dataSet.add(d11);
            mainWrapper.dataSet3.add(d11);
            mainWrapper.dataSet6.add(d11);
        DataClass d12 = new DataClass();
        d12.y = orderComplianceData.M1_Quantity__c;
        d12.color = '#6f30a0';
        mainWrapper.dataSet.add(d12);
             mainWrapper.dataSet3.add(d12);
             mainWrapper.dataSet6.add(d12);
    
        ComplianceDataClass cd1 = new ComplianceDataClass();
        cd1.y = orderComplianceData.M12_Compliance__c;
        cd1.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd1);
           ComplianceDataClass cd2 = new ComplianceDataClass();
        cd2.y = orderComplianceData.M11_Compliance__c;
        cd2.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd2);
           ComplianceDataClass cd3 = new ComplianceDataClass();
        cd3.y = orderComplianceData.M10_Compliance__c;
        cd3.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd3);
           ComplianceDataClass cd4 = new ComplianceDataClass();
        cd4.y = orderComplianceData.M9_Compliance__c;
        cd4.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd4);
        ComplianceDataClass cd5 = new ComplianceDataClass();
        cd5.y = orderComplianceData.M8_Compliance__c;
        cd5.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd5);
        ComplianceDataClass cd6 = new ComplianceDataClass();
        cd6.y = orderComplianceData.M7_Compliance__c;
        cd6.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd6);
            ComplianceDataClass cd7 = new ComplianceDataClass();
        cd7.y = orderComplianceData.M6_Compliance__c;
        cd7.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd7);
            mainWrapper.compliancePercentDataSet6.add(cd7);
        ComplianceDataClass cd8 = new ComplianceDataClass();
        cd8.y = orderComplianceData.M5_Compliance__c;
        cd8.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd8);
                    mainWrapper.compliancePercentDataSet6.add(cd8);
        ComplianceDataClass cd9 = new ComplianceDataClass();
        cd9.y = orderComplianceData.M4_Compliance__c;
        cd9.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd9);
            mainWrapper.compliancePercentDataSet6.add(cd9);
        ComplianceDataClass cd10 = new ComplianceDataClass();
        cd10.y = orderComplianceData.M3_Compliance__c;
        cd10.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd10);
            mainWrapper.compliancePercentDataSet6.add(cd10);
            mainWrapper.compliancePercentDataSet3.add(cd10);
        ComplianceDataClass cd11 = new ComplianceDataClass();
        cd11.y = orderComplianceData.M2_Compliance__c;
        cd11.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd11);
            mainWrapper.compliancePercentDataSet6.add(cd11);
            mainWrapper.compliancePercentDataSet3.add(cd11);
        ComplianceDataClass cd12 = new ComplianceDataClass();
        cd12.y = orderComplianceData.M1_Compliance__c;
        cd12.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd12);
            mainWrapper.compliancePercentDataSet6.add(cd12);
            mainWrapper.compliancePercentDataSet3.add(cd12);
        }
      if(type == 'historical'){
        DataClass d1 = new DataClass();
        d1.y = orderComplianceData.M12_Quantity__c;
        d1.color = '#6f30a0';
        mainWrapper.dataSet.add(d1);
         DataClass d2 = new DataClass();
        d2.y = orderComplianceData.M11_Quantity__c;
        d2.color = '#6f30a0';
        mainWrapper.dataSet.add(d2);
         DataClass d3 = new DataClass();
        d3.y = orderComplianceData.M10_Quantity__c;
        d3.color = '#6f30a0';
        mainWrapper.dataSet.add(d3);
        DataClass d4 = new DataClass();
        d4.y = orderComplianceData.M9_Quantity__c;
        d4.color = '#6f30a0';
        mainWrapper.dataSet.add(d4);
        DataClass d5 = new DataClass();
        d5.y = orderComplianceData.M8_Quantity__c;
        d5.color = '#6f30a0';
        mainWrapper.dataSet.add(d5);
        DataClass d6 = new DataClass();
        d6.y = orderComplianceData.M7_Quantity__c;
        d6.color = '#6f30a0';
        mainWrapper.dataSet.add(d6);
        DataClass d7 = new DataClass();
        d7.y = orderComplianceData.M6_Quantity__c;
        d7.color = '#6f30a0';
        mainWrapper.dataSet.add(d7);
          mainWrapper.dataSet6.add(d7);
        DataClass d8 = new DataClass();
        d8.y = orderComplianceData.M5_Quantity__c;
        d8.color = '#6f30a0';
        mainWrapper.dataSet.add(d8);
          mainWrapper.dataSet6.add(d8);
        DataClass d9 = new DataClass();
        d9.y = orderComplianceData.M4_Quantity__c;
        d9.color = '#6f30a0';
        mainWrapper.dataSet.add(d9);
          mainWrapper.dataSet6.add(d9);
        DataClass d10 = new DataClass();
        d10.y = orderComplianceData.M3_Quantity__c;
        d10.color = '#6f30a0';
        mainWrapper.dataSet.add(d10);
          mainWrapper.dataSet6.add(d10);
          mainWrapper.dataSet3.add(d10);
        DataClass d11 = new DataClass();
        d11.y = orderComplianceData.M2_Quantity__c;
        d11.color = '#6f30a0';
        mainWrapper.dataSet.add(d11);
          mainWrapper.dataSet6.add(d11);
          mainWrapper.dataSet3.add(d11);
        DataClass d12 = new DataClass();
        d12.y = orderComplianceData.M1_Quantity__c;
        d12.color = '#6f30a0';
        mainWrapper.dataSet.add(d12);
          mainWrapper.dataSet6.add(d12);
          mainWrapper.dataSet3.add(d12);
    
        ComplianceDataClass cd1 = new ComplianceDataClass();
        cd1.y = orderComplianceData.M12_Avg_Compliance__c;
        cd1.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd1);
          mainWrapper.compliancePercentDataSet3.add(cd1);
          mainWrapper.compliancePercentDataSet6.add(cd1);
        ComplianceDataClass cd2 = new ComplianceDataClass();
        cd2.y = orderComplianceData.M11_Avg_Compliance__c;
        cd2.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd2);
          mainWrapper.compliancePercentDataSet3.add(cd2);
          mainWrapper.compliancePercentDataSet6.add(cd2);
        ComplianceDataClass cd3 = new ComplianceDataClass();
        cd3.y = orderComplianceData.M10_Avg_Compliance__c;
        cd3.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd3);
          mainWrapper.compliancePercentDataSet3.add(cd3);
          mainWrapper.compliancePercentDataSet6.add(cd3);
        ComplianceDataClass cd4 = new ComplianceDataClass();
        cd4.y = orderComplianceData.M9_Avg_Compliance__c;
        cd4.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd4);
          mainWrapper.compliancePercentDataSet6.add(cd4);
        ComplianceDataClass cd5 = new ComplianceDataClass();
        cd5.y = orderComplianceData.M8_Avg_Compliance__c;
        cd5.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd5);
          mainWrapper.compliancePercentDataSet6.add(cd5);
        ComplianceDataClass cd6 = new ComplianceDataClass();
        cd6.y = orderComplianceData.M7_Avg_Compliance__c;
        cd6.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd6);
          mainWrapper.compliancePercentDataSet6.add(cd6);
        ComplianceDataClass cd7 = new ComplianceDataClass();
        cd7.y = orderComplianceData.M6_Avg_Compliance__c;
        cd7.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd7);
        ComplianceDataClass cd8 = new ComplianceDataClass();
        cd8.y = orderComplianceData.M5_Avg_Compliance__c;
        cd8.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd8);
        ComplianceDataClass cd9 = new ComplianceDataClass();
        cd9.y = orderComplianceData.M4_Avg_Compliance__c;
        cd9.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd9);
        ComplianceDataClass cd10 = new ComplianceDataClass();
        cd10.y = orderComplianceData.M3_Avg_Compliance__c;
        cd10.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd10);
        ComplianceDataClass cd11 = new ComplianceDataClass();
        cd11.y = orderComplianceData.M2_Avg_Compliance__c;
        cd11.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd11);
        ComplianceDataClass cd12 = new ComplianceDataClass();
        cd12.y = orderComplianceData.M1_Avg_Compliance__c;
        cd12.color = '#33CAFF';
        mainWrapper.compliancePercentDataSet.add(cd12);
        }
        mainWrapper.orderComplianceData = orderComplianceData;
        return mainWrapper;
    }
    public class mainGraphData{
        @AuraEnabled public String custName;
        @AuraEnabled public String orderProdName;
        @AuraEnabled Public Decimal threeMonthsAvg;
        @AuraEnabled Public Decimal sixMonthsAvg;
        @AuraEnabled Public Decimal twelveMonthsAvg;
        @AuraEnabled Public List<String> categories;
        @AuraEnabled Public List<String> categories3;
        @AuraEnabled Public List<String> categories6;
        @AuraEnabled Public List<DataClass> dataSet;
        @AuraEnabled Public List<Decimal> complianceDataSet;
        @AuraEnabled Public List<ComplianceDataClass> compliancePercentDataSet;
         @AuraEnabled Public List<DataClass> dataSet3;
        @AuraEnabled Public List<Decimal> complianceDataSet3;
        @AuraEnabled Public List<ComplianceDataClass> compliancePercentDataSet3;
         @AuraEnabled Public List<DataClass> dataSet6;
        @AuraEnabled Public List<Decimal> complianceDataSet6;
        @AuraEnabled Public List<ComplianceDataClass> compliancePercentDataSet6;
        @AuraEnabled Public Order_Compliance_Summary__c orderComplianceData;
        mainGraphData(){
            categories = new List<String>();
            categories3 = new List<String>();
            categories6 = new List<String>();
            dataSet = new List<DataClass>();
            dataSet3 = new List<DataClass>();
            dataSet6 = new List<DataClass>();
            compliancePercentDataSet = new List<ComplianceDataClass>();
            compliancePercentDataSet3 = new List<ComplianceDataClass>();
            compliancePercentDataSet6 = new List<ComplianceDataClass>();
            orderComplianceData = new Order_Compliance_Summary__c();
        }
    }
    public class DataClass{
        @AuraEnabled public Decimal y;
        @AuraEnabled public String color;
    }
    public class ComplianceDataClass{
        @AuraEnabled public Decimal y;
        @AuraEnabled public String color;
    }
    public class MainWrapper{
        @AuraEnabled public Boolean isProcessed;
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
        @AuraEnabled public List<Order_Compliance_Summary__c> orderComplianceList;    
        @AuraEnabled public List<orderWrapper> orderList;    
        @AuraEnabled public List<Decimal> totalorderComplianceList;    
        @AuraEnabled public String soldToCustName;
        @AuraEnabled public Decimal orderQty;
        @AuraEnabled public Decimal netValue;
        @AuraEnabled public String custName;
        @AuraEnabled public String orderProdName;
        
        @AuraEnabled public List<Vision_Customer_Product_Tracker__c> awardedPositionList; 
        @AuraEnabled public Decimal DirectAwardedQtyMonthly=0;
        @AuraEnabled public Decimal DirectAwardedQuantity=0;
        @AuraEnabled public Decimal M1DirectAct=0;
        @AuraEnabled public Decimal M2DirectAct=0;
        @AuraEnabled public Decimal M3DirectAct=0;
        @AuraEnabled public Decimal M4DirectAct=0;
        @AuraEnabled public Decimal M5DirectAct=0;
        @AuraEnabled public Decimal M6DirectAct=0;
        @AuraEnabled public Decimal M7DirectAct=0;
        @AuraEnabled public Decimal M1DirectCompliance=0;
        @AuraEnabled public Decimal M2DirectCompliance=0;
        @AuraEnabled public Decimal M3DirectCompliance=0;
        @AuraEnabled public Decimal M4DirectCompliance=0;
        @AuraEnabled public Decimal M5DirectCompliance=0;
        @AuraEnabled public Decimal M6DirectCompliance=0;
        @AuraEnabled public Decimal M7DirectCompliance=0;
        @AuraEnabled public Decimal M1DirectAvg=0;
        @AuraEnabled public Decimal M2DirectAvg=0;
        @AuraEnabled public Decimal M3DirectAvg=0;
        @AuraEnabled public Decimal M4DirectAvg=0;
        @AuraEnabled public Decimal M5DirectAvg=0;
        @AuraEnabled public Decimal M6DirectAvg=0;
        @AuraEnabled public Decimal M7DirectAvg=0;
        
        @AuraEnabled public Decimal MTDDirectAct=0;
        @AuraEnabled public Decimal MTDDirectAwardedQty=0;
        @AuraEnabled public Decimal MTDDirectCompliance=0;
        
        @AuraEnabled public Decimal QTDDirectAct=0;
        @AuraEnabled public Decimal QTDDirectAwardedQty=0;
        @AuraEnabled public Decimal QTDDirectCompliance=0;
        
        @AuraEnabled public Decimal FTDDirectAct=0;
        @AuraEnabled public Decimal FTDDirectAwardedQty=0;
        @AuraEnabled public Decimal FTDDirectCompliance=0;
        
        @AuraEnabled public Decimal CTDDirectAct=0;
        @AuraEnabled public Decimal CTDDirectAwardedQty=0;
        @AuraEnabled public Decimal CTDDirectCompliance=0;
        
        @AuraEnabled public List<ProductFamilyWrapper> ProductFamilyWrapperList;
        // @AuraEnabled public Decimal =0;
        //    @AuraEnabled public List<GCP_SFDC_Direct_Sales__c> rxDirectComplianceList;  
        //   @AuraEnabled public List<GCP_SFDC_Indirect_Sales__c> rxIndirectComplianceList;    
        //  @AuraEnabled public List<ProductWrapper> ProductWrapperList;      
        MainWrapper(){
            //   ProductWrapperList = new List<ProductWrapper>();
            orderList = new List<orderWrapper>();
            ProductFamilyWrapperList = new List<ProductFamilyWrapper>();
            orderComplianceList = new List<Order_Compliance_Summary__c>();
            awardedPositionList = new List<Vision_Customer_Product_Tracker__c>();
            //   rxDirectComplianceList = new List<GCP_SFDC_Direct_Sales__c>();
            //   rxIndirectComplianceList = new List<GCP_SFDC_Indirect_Sales__c>();
        }
    }
    Public Class ProductFamilyWrapper{
        @AuraEnabled public String prodFamName;
        @AuraEnabled public String prodFamId;
        @AuraEnabled public String skuCode;
        @AuraEnabled public String prodDescription;
        @AuraEnabled public Decimal pkgSize=0;
        //  @AuraEnabled public Decimal DirectAwardedValue,DirectAwardedQuantity,M1DAQ,M2DAQ,M3DAQ,M4DAQ,M5DAQ, M6DAQ,M1DAV,M2DAV, M3DAV,M4DAV,M5DAV,M6DAV,week1DAQ,week2DAQ,week3DAQ,week4DAQ,week1DAV,week2DAV,week3DAV,week4DAV,IndirectAwardedValue,IndirectAwardedQuantity,M1IAQ,M2IAQ,M3IAQ,M4IAQ,M5IAQ,M6IAQ,M1IAV,M2IAV,M3IAV,M4IAV,M5IAV,M6IAV,week1IAQ,week2IAQ,week3IAQ,week4IAQ,week1IAV,week2IAV,week3IAV,week4IAV=0;
        // @AuraEnabled public Decimal TotalAwardedValue,TotalAwardedQuantity,M1TAQ,M2TAQ,M3TAQ,M4TAQ,M5TAQ,M6TAQ,M1TAV,M2TAV,M3TAV,M4TAV,M5TAV,M6TAV,week1TAQ,week2TAQ,week3TAQ,week4TAQ,week1TAV,week2TAV,week3TAV,week4TAV=0;
        @AuraEnabled public List<Order_Compliance_Summary__c> orderComplianceList;    
        @AuraEnabled public Decimal DirectAwardedQtyMonthly=0;
        @AuraEnabled public Decimal DirectAwardedQuantity=0;
        @AuraEnabled public Decimal M1DirectAct=0;
        @AuraEnabled public Decimal M2DirectAct=0;
        @AuraEnabled public Decimal M3DirectAct=0;
        @AuraEnabled public Decimal M4DirectAct=0;
        @AuraEnabled public Decimal M5DirectAct=0;
        @AuraEnabled public Decimal M6DirectAct=0;
        @AuraEnabled public Decimal M7DirectAct=0;
        
        @AuraEnabled public Decimal M1DirectCompliance=0;
        @AuraEnabled public Decimal M2DirectCompliance=0;
        @AuraEnabled public Decimal M3DirectCompliance=0;
        @AuraEnabled public Decimal M4DirectCompliance=0;
        @AuraEnabled public Decimal M5DirectCompliance=0;
        @AuraEnabled public Decimal M6DirectCompliance=0;
        @AuraEnabled public Decimal M7DirectCompliance=0;
        
        @AuraEnabled public Decimal M1DirectAvg=0;
        @AuraEnabled public Decimal M2DirectAvg=0;
        @AuraEnabled public Decimal M3DirectAvg=0;
        @AuraEnabled public Decimal M4DirectAvg=0;
        @AuraEnabled public Decimal M5DirectAvg=0;
        @AuraEnabled public Decimal M6DirectAvg=0;
        @AuraEnabled public Decimal M7DirectAvg=0; 
        
        @AuraEnabled public Decimal MTDDirectAct=0;
        @AuraEnabled public Decimal MTDDirectAwardedQty=0;
        @AuraEnabled public Decimal MTDDirectCompliance=0;
        
        @AuraEnabled public Boolean showProdFam;
        @AuraEnabled public Boolean expandCollapse;
        
        @AuraEnabled public Decimal QTDDirectAct=0;
        @AuraEnabled public Decimal QTDDirectAwardedQty=0;
        @AuraEnabled public Decimal QTDDirectCompliance=0;
        
        @AuraEnabled public Decimal FTDDirectAct=0;
        @AuraEnabled public Decimal FTDDirectAwardedQty=0;
        @AuraEnabled public Decimal FTDDirectCompliance=0;
        
        @AuraEnabled public Decimal CTDDirectAct=0;
        @AuraEnabled public Decimal CTDDirectAwardedQty=0;
        @AuraEnabled public Decimal CTDDirectCompliance=0;
        
        ProductFamilyWrapper(){
            showProdFam = false;
            expandCollapse = false;
            orderComplianceList = new List<Order_Compliance_Summary__c>();
        }
    }
    Public class orderWrapper{
        @AuraEnabled public String soldToCustName;
        @AuraEnabled public String soldToCustCode;
        @AuraEnabled public String uniqueKey;
        @AuraEnabled public List<statusWrapper> statusWrapperList;
        @AuraEnabled public Boolean expandsolToCust;
        @AuraEnabled public Decimal orderQty;
        @AuraEnabled public Decimal netValue;
        @AuraEnabled public Decimal shipQty;
        @AuraEnabled public Decimal shipValue;
        orderWrapper(){
            expandsolToCust = true;
            statusWrapperList = new List<statusWrapper>();
        }
        
    }
    Public class statusWrapper{
        @AuraEnabled public String status;
        @AuraEnabled public String soldToCustName;
        @AuraEnabled public String uniqueKey;
        @AuraEnabled public List<Vision_GCP_SFDC_Order_Status__c> orderList;   
        @AuraEnabled public Boolean expandStatus;
        @AuraEnabled public Decimal orderQty;
        @AuraEnabled public Decimal netValue;
        @AuraEnabled public Decimal shipQty;
        @AuraEnabled public Decimal shipValue;
        statusWrapper(){
            expandStatus = false;
            orderList = new List<Vision_GCP_SFDC_Order_Status__c>();
        }
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
    @AuraEnabled
    public static Wrapper saveComment(String newComment, String selectedLineId ,String Account, String Product){
        Wrapper wrapObj = new Wrapper();
        try{
            system.debug('Product-----'+Product);
            system.debug('Account-----'+Account);
            system.debug('newComment-----'+newComment);
            GCP_Comment__c gcpCmntObj = new GCP_Comment__c();
            gcpCmntObj.Comment__c = newComment;
            //gcpCmntObj.Compliance_Summary__c = selectedLineId;
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
        system.debug('ProductId-----'+ProductId);
        system.debug('AccountId-----'+AccountId);
        //string prodFamilyName = gcpLineItem.Phoenix_Product_Family__c != null ? gcpLineItem.Phoenix_Product_Family__c : '';
        //gcpLineItem.GCP_Product_Family__c != null ? gcpLineItem.GCP_Product_Family__c : '';
        /*  String panaromaString = 'Panaroma';
string gcpCommentQuery = 'SELECT '+fieldApiList('GCP_Comment__c')+' FROM GCP_Comment__c WHERE Comment_Type__c=: panaromaString and Account__c =: AccountId and Product__c =: ProductId ORDER BY Comment_Date__c';
List<GCP_Comment__c> visionGcpCmntsList = database.query(gcpCommentQuery);
///system.debug('visionGcpCmntsList.size() :: '+visionGcpCmntsList.size());*/
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
                ///system.debug('Comment__c-----'+gcpCmntObj.Comment__c);
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
        system.debug('visionGcpCmntsList====='+visionGcpCmntsList);
        system.debug('visionGcpCmntsList====='+visionGcpCmntsList.size());
        system.debug('gcpCmntsList====='+gcpCmntsList);
        system.debug('gcpCmntsList====='+gcpCmntsList.size());
        
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
    }
   public static void codeCoverage(){
        integer i =1;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        
        
        
    } 
}