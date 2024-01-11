public class Vision_Rx_Compliance_NPR {
    @AuraEnabled
    public static boolean apexJobStatus(List<String> apexClassList) {
             List<ApexClass> aC=new list<ApexClass>();
        Boolean isProcessed = true;
       // if(!test.isRunningTest()){
        aC = [SELECT Id, Name FROM ApexClass WHERE Name IN: apexClassList];
   // }
      /*  else{
           aC = [SELECT Id, Name FROM ApexClass WHERE Name IN: apexClassList limit 1 ];
        }*/
        system.debug(aC);
        List<String> classIds = new List<String>();
        for(ApexClass job : aC ){
            classIds.add(job.Id);
        }
        List<AsyncapexJob> aJ = [SELECT Id, ApexClassID FROM AsyncapexJob where Status='Processing' and ApexClassID IN: classIds];
        system.debug('aJ----'+aJ.size());
        if(aJ.size() > 0){
            isProcessed = false;
        }
        
        return isProcessed;
        
    }
    @AuraEnabled//(cacheable=true) 
    public static MainWrapper getOnlyComplianceData(String searchText,String customerId,String showNonCompliance,Boolean showPrimary, Boolean isDirect, Boolean isIndirect, Boolean isTotal, String productDirector){
        List<String> apexClassList = new List<String>();
        apexClassList.add('ComplianceRecordsNprData');
        apexClassList.add('Compliance_RollUP_Batch');
        apexClassList.add('complianceCTDFTDdata');
       
        MainWrapper mainWrap = new MainWrapper();
        mainWrap.isProcessed =  apexJobStatus(apexClassList);
        
        String query = '';
        String category = 'Primary';
        // String strFields = Phoenix_Util.rxExternalObjFields;
        String SobjectApiName = 'Compliance_Summary__c';
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
        map<String,List<Compliance_Summary__c>> productFamilyMap = new map<String,List<Compliance_Summary__c>>();
        // query = 'select Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false';
        query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Vision_Product__r.Product_Family__r.Name != null  ';   
        
        
         if(isDirect){
           
              if(showNonCompliance == '1Month'){
            query =  query+'and (M2_Direct_Qty_Compliance__c <75) ';
        }
        else if(showNonCompliance == '2Month'){
            query =  query+'and (M2_Direct_Qty_Compliance__c < 75 and M3_Direct_Qty_Compliance__c < 75) ';
            
        } 
        else if(showNonCompliance == '3Month'){
            query =  query+'and (M2_Direct_Qty_Compliance__c < 75 and M3_Direct_Qty_Compliance__c < 75 and M4_Direct_Qty_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '4Month'){
            query =  query+'and (M2_Direct_Qty_Compliance__c < 75 and M3_Direct_Qty_Compliance__c < 75 and M4_Direct_Qty_Compliance__c < 75 and M5_Direct_Qty_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '5Month'){
            query =  query+'and (M2_Direct_Qty_Compliance__c < 75 and M3_Direct_Qty_Compliance__c < 75 and M4_Direct_Qty_Compliance__c < 75 and M5_Direct_Qty_Compliance__c < 75 and M6_Direct_Qty_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '6Month'){
            query =  query+'and (M2_Direct_Qty_Compliance__c < 75 and M3_Direct_Qty_Compliance__c < 75 and M4_Direct_Qty_Compliance__c < 75 and M5_Direct_Qty_Compliance__c < 75 and M6_Direct_Qty_Compliance__c < 75  and M7_Direct_Qty_Compliance__c < 75) ';
            
        }
        else{
            
        }
            if(searchText != null && searchText !='') {
                searchText = '%'+searchText+'%';
                  if(!showPrimary ){
                    if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                        system.debug('!showPrimary - productDirector not null - search');
                        query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Is_Direct__c = true and General_Category__c =: category and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                    }
                    else{
                        system.debug('!showPrimary - productDirector null - search');
                        
                        query = query+'and Is_Direct__c = true and General_Category__c =: category and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                        
                    }
                    // query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 order by Vision_Product__r.Name';
                }
                else if(showPrimary ){
                    if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                        system.debug('showPrimary - productDirector not null - search');
                        
                        query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Is_Direct__c = true and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                    }
                    else{
                        system.debug('showPrimary - productDirector not null - search');
                        
                        query = query+'and Is_Direct__c = true and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                        
                    }
                    //     query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and  Vision_Product__r.Name != null and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 order by Vision_Product__r.Name';
                }  
            }
            else{
                if(!showPrimary ){
                    if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                        system.debug('!showPrimary - productDirector not null');
                        query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Is_Direct__c = true and General_Category__c =: category order by Vision_Product__r.Name';
                    }
                    else{
                        system.debug('!showPrimary - productDirector null');
                        
                        query = query+'and Is_Direct__c = true and General_Category__c =: category order by Vision_Product__r.Name';
                        
                    }
                    // query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 order by Vision_Product__r.Name';
                }
                else if(showPrimary ){
                    if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                        system.debug('showPrimary - productDirector not null');
                        
                        query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Is_Direct__c = true order by Vision_Product__r.Name';
                    }
                    else{
                        system.debug('showPrimary - productDirector not null');
                        
                        query = query+'and Is_Direct__c = true order by Vision_Product__r.Name';
                        
                    }
                    //     query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and  Vision_Product__r.Name != null and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 order by Vision_Product__r.Name';
                }  
                //  }
            }
       }
     
   
            else if(isIndirect){
            
              if(showNonCompliance == '1Month'){
            query =  query+'and (M2_Indirect_Qty_Compliance__c < 75) ';
        }
        else if(showNonCompliance == '2Month'){
            query =  query+'and (M2_Indirect_Qty_Compliance__c < 75 and M3_Indirect_Qty_Compliance__c < 75) ';
            
        } 
        else if(showNonCompliance == '3Month'){
            query =  query+'and (M2_Indirect_Qty_Compliance__c < 75 and M3_Indirect_Qty_Compliance__c < 75 and M4_Indirect_Qty_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '4Month'){
            query =  query+'and (M2_Indirect_Qty_Compliance__c < 75 and M3_Indirect_Qty_Compliance__c < 75 and M4_Indirect_Qty_Compliance__c < 75 and M5_Indirect_Qty_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '5Month'){
            query =  query+'and (M2_Indirect_Qty_Compliance__c < 75 and M3_Indirect_Qty_Compliance__c < 75 and M4_Indirect_Qty_Compliance__c < 75 and M5_Indirect_Qty_Compliance__c < 75 and M6_Indirect_Qty_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '6Month'){
            query =  query+'and (M2_Indirect_Qty_Compliance__c < 75 and M3_Indirect_Qty_Compliance__c < 75 and M4_Indirect_Qty_Compliance__c < 75 and M5_Indirect_Qty_Compliance__c < 75 and M6_Indirect_Qty_Compliance__c < 75 and M7_Indirect_Qty_Compliance__c < 75) ';
            
        }
        else{
            
        }
        
         if(searchText != null && searchText !='') {
                searchText = '%'+searchText+'%';
            if(!showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('!showPrimary - productDirector != null');
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and General_Category__c =: category and Is_Indirect__c = true and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                }
                else{
                    system.debug('!showPrimary - productDirector');
                    query = query+'and General_Category__c =: category and Is_Indirect__c = true and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                    
                }
                //    query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 order by Vision_Product__r.Name';
            }
            else if(showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('showPrimary - productDirector != null');
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Is_Indirect__c = true and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                }
                else{
                    
                    system.debug('showPrimary - productDirector');
                    query = query+'and Is_Indirect__c = true and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                    
                }
                // query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 order by Vision_Product__r.Name';
            }    
         }
                else{
           if(!showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('!showPrimary - productDirector != null');
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and General_Category__c =: category and Is_Indirect__c = true order by Vision_Product__r.Name';
                }
                else{
                    system.debug('!showPrimary - productDirector');
                    query = query+'and General_Category__c =: category and Is_Indirect__c = true order by Vision_Product__r.Name';
                    
                }
                //    query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 order by Vision_Product__r.Name';
            }
            else if(showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('showPrimary - productDirector != null');
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Is_Indirect__c = true order by Vision_Product__r.Name';
                }
                else{
                    
                    system.debug('showPrimary - productDirector');
                    query = query+'and Is_Indirect__c = true order by Vision_Product__r.Name';
                    
                }
                // query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 order by Vision_Product__r.Name';
            }              
                }
        }
        else if(isTotal){
               if(showNonCompliance == '1Month'){
            query =  query+'and (M2_Total_Compliance__c < 75) ';
        }
        else if(showNonCompliance == '2Month'){
            query =  query+'and (M2_Total_Compliance__c < 75 and M3_Total_Compliance__c < 75) ';
            
        } 
        else if(showNonCompliance == '3Month'){
            query =  query+'and (M2_Total_Compliance__c < 75 and M3_Total_Compliance__c < 75 and M4_Total_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '4Month'){
            query =  query+'and (M2_Total_Compliance__c < 75 and M3_Total_Compliance__c < 75 and M4_Total_Compliance__c < 75 and M5_Total_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '5Month'){
            query =  query+'and (M2_Total_Compliance__c < 75 and M3_Total_Compliance__c < 75 and M4_Total_Compliance__c < 75 and M5_Total_Compliance__c < 75 and M6_Total_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '6Month'){
            query =  query+'and (M2_Total_Compliance__c < 75 and M3_Total_Compliance__c < 75 and M4_Total_Compliance__c < 75 and M5_Total_Compliance__c < 75 and M6_Total_Compliance__c < 75 and M7_Total_Compliance__c < 75) ';
            
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
                // query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Product_Director__c,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Total_Awarded_Information__c > 0 order by Vision_Product__r.Name';
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
                //   query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Product_Director__c,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Total_Awarded_Information__c > 0 order by Vision_Product__r.Name';
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
                // query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Product_Director__c,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Total_Awarded_Information__c > 0 order by Vision_Product__r.Name';
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
                //   query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Product_Director__c,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Total_Awarded_Information__c > 0 order by Vision_Product__r.Name';
            }      
            }
        }
        List<ProductFamilyWrapper> ProductFamilyWrapperList = new List<ProductFamilyWrapper>();
        List < Compliance_Summary__c > rxComplianceList = Database.query(query);
       	system.debug('rxlist is '+rxComplianceList);
        system.debug('query3---->'+query.substring(query.length()-500, query.length()-1));
        system.debug('summer==>'+[SELECT Id,Vision_Customer__r.Name,M2_Indirect_Qty_Compliance__c,Indirect_Awarded_Information__c FROM Compliance_Summary__c]);
        system.debug('rxComplianceList02--->'+ rxComplianceList.size());
        if(rxComplianceList.size()>0){
            for(Compliance_Summary__c comp : rxComplianceList){
                if(isDirect){
                    
                    if(productFamilyMap.containsKey(comp.Vision_Product__r.Product_Family__r.Name)){
                        ///system.debug('comp.Vision_Product__r.Product_Family__r.Name==='+comp.Vision_Product__r.Product_Family__r.Name);
                        List<Compliance_Summary__c> prodList = productFamilyMap.get(comp.Vision_Product__r.Product_Family__r.Name);
                        prodList.add(comp);
                        productFamilyMap.put(comp.Vision_Product__r.Product_Family__r.Name,prodList);
                    }
                    else{
                        ///system.debug('comp==='+comp);
                        productFamilyMap.put(comp.Vision_Product__r.Product_Family__r.Name,new List<Compliance_Summary__c>{comp});
                    }
                    
                    
                    mainWrap.DirectAwardedQuantity = mainWrap.DirectAwardedQuantity + (comp.Awarded_Information__c != null ? comp.Awarded_Information__c:0);
                    mainWrap.DirectAwardedQtyMonthly = mainWrap.DirectAwardedQtyMonthly + (comp.Direct_Awarded_Quantity_Monthly__c != null ? comp.Direct_Awarded_Quantity_Monthly__c :0);
                    mainWrap.M1DirectAct = (mainWrap.M1DirectAct != null ? mainWrap.M1DirectAct : 0) + (comp.M1_Quantity__c!= null ? comp.M1_Quantity__c :0);
                    mainWrap.M2DirectAct = (mainWrap.M2DirectAct != null ? mainWrap.M2DirectAct : 0) + (comp.M2_Quantity__c!= null ? comp.M2_Quantity__c :0);
                    mainWrap.M3DirectAct = mainWrap.M3DirectAct + (comp.M3_Quantity__c!= null ? comp.M3_Quantity__c :0);
                    mainWrap.M4DirectAct = mainWrap.M4DirectAct + (comp.M4_Quantity__c!= null ? comp.M4_Quantity__c :0);
                    mainWrap.M5DirectAct = mainWrap.M5DirectAct + (comp.M5_Quantity__c!= null ? comp.M5_Quantity__c :0);
                    mainWrap.M6DirectAct = mainWrap.M6DirectAct + (comp.M6_Quantity__c!= null ? comp.M6_Quantity__c :0);
                    mainWrap.M7DirectAct = mainWrap.M7DirectAct + (comp.M7_Quantity__c!= null ? comp.M7_Quantity__c :0);
                    mainWrap.M1DirectAvg = mainWrap.M1DirectAvg + (comp.M1_Direct_Avg_Quantity__c!= null ? comp.M1_Direct_Avg_Quantity__c :0);
                    mainWrap.M2DirectAvg = mainWrap.M2DirectAvg + (comp.M2_Direct_Avg_Quantity__c!= null ? comp.M2_Direct_Avg_Quantity__c :0);
                    mainWrap.M3DirectAvg = mainWrap.M3DirectAvg + (comp.M3_Direct_Avg_Quantity__c!= null ? comp.M3_Direct_Avg_Quantity__c :0);
                    mainWrap.M4DirectAvg = mainWrap.M4DirectAvg + (comp.M4_Direct_Avg_Quantity__c!= null ? comp.M4_Direct_Avg_Quantity__c :0);
                    mainWrap.M5DirectAvg = mainWrap.M5DirectAvg + (comp.M5_Direct_Avg_Quantity__c!= null ? comp.M5_Direct_Avg_Quantity__c :0);
                    mainWrap.M6DirectAvg = mainWrap.M6DirectAvg + (comp.M6_Direct_Avg_Quantity__c!= null ? comp.M6_Direct_Avg_Quantity__c :0);
                    mainWrap.M7DirectAvg = mainWrap.M7DirectAvg + (comp.M7_Direct_Avg_Quantity__c!= null ? comp.M7_Direct_Avg_Quantity__c :0);
                    mainWrap.QTDDirectAct = mainWrap.QTDDirectAct + (comp.QTD_Direct_Quantity__c!= null ? comp.QTD_Direct_Quantity__c :0);
                    mainWrap.QTDDirectAwardedQty = mainWrap.QTDDirectAwardedQty + (comp.QTD_Direct_Awarded_Quantity__c!= null ? comp.QTD_Direct_Awarded_Quantity__c :0);
                    //   mainWrap.QTDDirectCompliance = mainWrap.QTDDirectCompliance + (comp.QTD_Direct_Compliance__c!= null ? comp.QTD_Direct_Compliance__c :0);
                    mainWrap.FTDDirectAct = mainWrap.FTDDirectAct + (comp.FTD_Direct_Quantity__c!= null ? comp.FTD_Direct_Quantity__c :0);
                    mainWrap.FTDDirectAwardedQty = mainWrap.FTDDirectAwardedQty + (comp.FTD_Direct_Awarded_Quantity__c!= null ? comp.FTD_Direct_Awarded_Quantity__c :0);
                    //   mainWrap.FTDDirectCompliance = mainWrap.FTDDirectCompliance + (comp.FTD_Direct_Compliance__c!= null ? comp.FTD_Direct_Compliance__c :0);
                    mainWrap.CTDDirectAct = mainWrap.CTDDirectAct + (comp.CTD_Direct_Quantity__c!= null ? comp.CTD_Direct_Quantity__c :0);
                    mainWrap.CTDDirectAwardedQty = mainWrap.CTDDirectAwardedQty + (comp.CTD_Direct_Awarded_Quantity__c!= null ? comp.CTD_Direct_Awarded_Quantity__c :0);
                    //  mainWrap.CTDDirectCompliance = (comp.CTD_Direct_Complaince__c!= null ? comp.CTD_Direct_Complaince__c :0);
                    mainWrap.MTDDirectAct = mainWrap.MTDDirectAct + (comp.M1_Quantity__c!= null ? comp.M1_Quantity__c :0);
                    mainWrap.MTDDirectAwardedQty = mainWrap.MTDDirectAwardedQty + (comp.MTD_Direct_Awarded_Quantity__c!= null ? comp.MTD_Direct_Awarded_Quantity__c :0);
                }
                if(isIndirect){
                    if(productFamilyMap.containsKey(comp.Vision_Product__r.Product_Family__r.Name)){
                        ///system.debug('comp.Vision_Product__r.Product_Family__r.Name==='+comp.Vision_Product__r.Product_Family__r.Name);
                        List<Compliance_Summary__c> prodList = productFamilyMap.get(comp.Vision_Product__r.Product_Family__r.Name);
                        prodList.add(comp);
                        productFamilyMap.put(comp.Vision_Product__r.Product_Family__r.Name,prodList);
                    }
                    else{
                        ///system.debug('comp==='+comp);
                        productFamilyMap.put(comp.Vision_Product__r.Product_Family__r.Name,new List<Compliance_Summary__c>{comp});
                    }
                    mainWrap.IndirectAwardedQtyMonthly = mainWrap.IndirectAwardedQtyMonthly + (comp.Indirect_Awarded_Quantity_Monthly__c!= null ? comp.Indirect_Awarded_Quantity_Monthly__c :0);
                    mainWrap.IndirectAwardedQuantity = mainWrap.IndirectAwardedQuantity + (comp.Indirect_Awarded_Information__c!= null ? comp.Indirect_Awarded_Information__c :0);
                    mainWrap.M1InDirectAct = mainWrap.M1InDirectAct + (comp.M1_Indirect_Quantity__c!= null ? comp.M1_Indirect_Quantity__c :0);
                    mainWrap.M2InDirectAct = mainWrap.M2InDirectAct + (comp.M2_Indirect_Quantity__c!= null ? comp.M2_Indirect_Quantity__c :0);
                    mainWrap.M3InDirectAct = mainWrap.M3InDirectAct + (comp.M3_Indirect_Quantity__c!= null ? comp.M3_Indirect_Quantity__c :0);
                    mainWrap.M4InDirectAct = mainWrap.M4InDirectAct + (comp.M4_Indirect_Quantity__c!= null ? comp.M4_Indirect_Quantity__c :0);
                    mainWrap.M5InDirectAct = mainWrap.M5InDirectAct + (comp.M5_Indirect_Quantity__c!= null ? comp.M5_Indirect_Quantity__c :0);
                    mainWrap.M6InDirectAct = mainWrap.M6InDirectAct + (comp.M6_Indirect_Quantity__c!= null ? comp.M6_Indirect_Quantity__c :0);
                    mainWrap.M7InDirectAct = mainWrap.M7InDirectAct + (comp.M7_Indirect_Quantity__c!= null ? comp.M7_Indirect_Quantity__c :0);
                    mainWrap.M1InDirectAvg = mainWrap.M1InDirectAvg + (comp.M1_Indirect_Avg_Quantity__c!= null ? comp.M1_Indirect_Avg_Quantity__c :0);
                    mainWrap.M2InDirectAvg = mainWrap.M2InDirectAvg + (comp.M2_Indirect_Avg_Quantity__c!= null ? comp.M2_Indirect_Avg_Quantity__c :0);
                    mainWrap.M3InDirectAvg = mainWrap.M3InDirectAvg + (comp.M3_Indirect_Avg_Quantity__c!= null ? comp.M3_Indirect_Avg_Quantity__c :0);
                    mainWrap.M4InDirectAvg = mainWrap.M4InDirectAvg + (comp.M4_Indirect_Avg_Quantity__c!= null ? comp.M4_Indirect_Avg_Quantity__c :0);
                    mainWrap.M5InDirectAvg = mainWrap.M5InDirectAvg + (comp.M5_Indirect_Avg_Quantity__c!= null ? comp.M5_Indirect_Avg_Quantity__c :0);
                    mainWrap.M6InDirectAvg = mainWrap.M6InDirectAvg + (comp.M6_Indirect_Avg_Quantity__c!= null ? comp.M6_Indirect_Avg_Quantity__c :0);
                    mainWrap.M7InDirectAvg = mainWrap.M7InDirectAvg + (comp.M7_Indirect_Avg_Quantity__c!= null ? comp.M7_Indirect_Avg_Quantity__c :0);
                    mainWrap.QTDIndirectAct = mainWrap.QTDIndirectAct + (comp.QTD_Indirect_Quantity__c!= null ? comp.QTD_Indirect_Quantity__c :0);
                    mainWrap.QTDIndirectAwardedQty = mainWrap.QTDIndirectAwardedQty + (comp.QTD_Indirect_Awarded_Quantity__c!= null ? comp.QTD_Indirect_Awarded_Quantity__c :0);
                    //  mainWrap.QTDIndirectCompliance = mainWrap.QTDIndirectCompliance + (comp.QTD_Indirect_Complaince__c!= null ? comp.QTD_Indirect_Complaince__c :0);
                    mainWrap.FTDIndirectAct = mainWrap.FTDIndirectAct + (comp.FTD_Indirect_Quantity__c!= null ? comp.FTD_Indirect_Quantity__c :0);
                    mainWrap.FTDIndirectAwardedQty = mainWrap.FTDIndirectAwardedQty + (comp.FTD_Indirect_Awarded_Quantity__c!= null ? comp.FTD_Indirect_Awarded_Quantity__c :0);
                    // mainWrap.FTDIndirectCompliance = mainWrap.FTDIndirectCompliance + (comp.FTD_Indirect_Complaince__c!= null ? comp.FTD_Indirect_Complaince__c :0);
                    mainWrap.CTDIndirectAct = mainWrap.CTDIndirectAct + (comp.CTD_Indirect_Quantity__c!= null ? comp.CTD_Indirect_Quantity__c :0);
                    mainWrap.CTDIndirectAwardedQty = mainWrap.CTDIndirectAwardedQty + (comp.CTD_Indirect_Awarded_Quantity__c!= null ? comp.CTD_Indirect_Awarded_Quantity__c :0);
                    // mainWrap.CTDIndirectCompliance = mainWrap.CTDIndirectCompliance + (comp.CTD_Indirect_Compliance__c!= null ? comp.CTD_Indirect_Compliance__c :0);
                      mainWrap.MTDIndirectAct = mainWrap.MTDIndirectAct + (comp.M1_Indirect_Quantity__c!= null ? comp.M1_Indirect_Quantity__c :0);
                    mainWrap.MTDIndirectAwardedQty = mainWrap.MTDIndirectAwardedQty + (comp.MTD_Indirect_Awarded_Quantity__c!= null ? comp.MTD_Indirect_Awarded_Quantity__c :0);
                }
                if(isTotal){
                    if(productFamilyMap.containsKey(comp.Vision_Product__r.Product_Family__r.Name)){
                        ///system.debug('comp.Vision_Product__r.Product_Family__r.Name==='+comp.Vision_Product__r.Product_Family__r.Name);
                        List<Compliance_Summary__c> prodList = productFamilyMap.get(comp.Vision_Product__r.Product_Family__r.Name);
                        prodList.add(comp);
                        productFamilyMap.put(comp.Vision_Product__r.Product_Family__r.Name,prodList);
                    }
                    else{
                        ///system.debug('comp==='+comp);
                        productFamilyMap.put(comp.Vision_Product__r.Product_Family__r.Name,new List<Compliance_Summary__c>{comp});
                    }
                    mainWrap.TotalAwardedQuantity = (mainWrap.TotalAwardedQuantity != null ? mainWrap.TotalAwardedQuantity : 0) + (comp.Total_Awarded_Information__c!= null ? comp.Total_Awarded_Information__c :0);
                    mainWrap.TotalAwardedQtyMonthly = mainWrap.TotalAwardedQtyMonthly + (comp.Total_Awarded_Information_Monthly__c != null ? comp.Total_Awarded_Information_Monthly__c :0);
                    system.debug('M3TotalAct====='+comp.Vision_Product__r.Product_Family__r.Name+'=='+mainWrap.M3TotalAct);
                    system.debug('Family====='+comp.Vision_Product__r.Product_Family__r.Name);
                    system.debug('M3_Total_Quantity__c====='+comp.Vision_Product__r.Product_Family__r.Name+'=='+comp.M3_Total_Quantity__c);
                    mainWrap.M1TotalAct = mainWrap.M1TotalAct + (comp.M1_Total_Quantity__c != null ? comp.M1_Total_Quantity__c :0);
                    mainWrap.M2TotalAct = mainWrap.M2TotalAct + (comp.M2_Total_Quantity__c != null ? comp.M2_Total_Quantity__c :0);
                    mainWrap.M3TotalAct = mainWrap.M3TotalAct + (comp.M3_Total_Quantity__c!= null ? comp.M3_Total_Quantity__c :0);
                    system.debug('M3TotalAct====='+comp.Vision_Product__r.Product_Family__r.Name+'=='+mainWrap.M3TotalAct);
                    
                    mainWrap.M4TotalAct = mainWrap.M4TotalAct + (comp.M4_Total_Quantity__c!= null ? comp.M4_Total_Quantity__c :0);
                    mainWrap.M5TotalAct = mainWrap.M5TotalAct + (comp.M5_Total_Quantity__c!= null ? comp.M5_Total_Quantity__c :0);
                    mainWrap.M6TotalAct = mainWrap.M6TotalAct + (comp.M6_Total_Quantity__c!= null ? comp.M6_Total_Quantity__c :0);
                    mainWrap.M7TotalAct = mainWrap.M7TotalAct + (comp.M7_Total_Quantity__c!= null ? comp.M7_Total_Quantity__c :0);
                    mainWrap.M1TotalAvg = mainWrap.M1TotalAvg + (comp.M1_Total_Avg_Quantity__c!= null ? comp.M1_Total_Avg_Quantity__c :0);
                    mainWrap.M2TotalAvg = mainWrap.M2TotalAvg + (comp.M2_Total_Avg_Quantity__c!= null ? comp.M2_Total_Avg_Quantity__c :0);
                    mainWrap.M3TotalAvg = mainWrap.M3TotalAvg + (comp.M3_Total_Avg_Quantity__c!= null ? comp.M3_Total_Avg_Quantity__c :0);
                    mainWrap.M4TotalAvg = mainWrap.M4TotalAvg + (comp.M4_Total_Avg_Quantity__c!= null ? comp.M4_Total_Avg_Quantity__c :0);
                    mainWrap.M5TotalAvg = mainWrap.M5TotalAvg + (comp.M5_Total_Avg_Quantity__c!= null ? comp.M5_Total_Avg_Quantity__c :0);
                    mainWrap.M6TotalAvg = mainWrap.M6TotalAvg + (comp.M6_Total_Avg_Quantity__c!= null ? comp.M6_Total_Avg_Quantity__c :0);
                    mainWrap.M7TotalAvg = mainWrap.M7TotalAvg + (comp.M7_Total_Avg_Quantity__c!= null ? comp.M7_Total_Avg_Quantity__c :0); 
                    mainWrap.QTDTotalAct = mainWrap.QTDTotalAct + (comp.QTD_Total_Quantity__c!= null ? comp.QTD_Total_Quantity__c :0);
                    mainWrap.QTDTotalAwardedQty = mainWrap.QTDTotalAwardedQty + (comp.QTD_Total_Awarded_Quantity__c!= null ? comp.QTD_Total_Awarded_Quantity__c :0);
                    //  mainWrap.QTDTotalCompliance = mainWrap.QTDTotalCompliance + (comp.QTD_Total_Complaince__c!= null ? comp.QTD_Total_Complaince__c :0);
                    mainWrap.FTDTotalAct = mainWrap.FTDTotalAct + (comp.FTD_Total_Quantity__c!= null ? comp.FTD_Total_Quantity__c :0);
                    mainWrap.FTDTotalAwardedQty = mainWrap.FTDTotalAwardedQty + (comp.FTD_Total_Awarded_Quantity__c!= null ? comp.FTD_Total_Awarded_Quantity__c :0);
                    // mainWrap.FTDTotalCompliance = mainWrap.FTDTotalCompliance + (comp.FTD_Total_Compliance__c != null ? comp.FTD_Total_Compliance__c :0);
                    mainWrap.CTDTotalAct = mainWrap.CTDTotalAct + (comp.CTD_Total_Quantity__c!= null ? comp.CTD_Total_Quantity__c :0);
                    mainWrap.CTDTotalAwardedQty = mainWrap.CTDTotalAwardedQty + (comp.CTD_Total_Awarded_Quantity__c!= null ? comp.CTD_Total_Awarded_Quantity__c :0);
                    //  mainWrap.CTDTotalCompliance = mainWrap.CTDTotalCompliance + (comp.CTD_Total_Compliance__c!= null ? comp.CTD_Total_Compliance__c :0);
                     mainWrap.MTDTotalAct = mainWrap.MTDTotalAct + (comp.M1_Total_Quantity__c!= null ? comp.M1_Total_Quantity__c :0);
                    mainWrap.MTDTotalAwardedQty = mainWrap.MTDTotalAwardedQty + (comp.MTD_Total_Awarded_Quantity__c!= null ? comp.MTD_Total_Awarded_Quantity__c :0);
                }
            }
            // ///system.debug('productFamilyMap keyset==='+productFamilyMap.keySet());
            // ///system.debug('productFamilyMap values==='+productFamilyMap.values());
            for(string prodFamName : productFamilyMap.keySet()){
                ProductFamilyWrapper pfList = new ProductFamilyWrapper();
                
                ///system.debug('prodFamName==='+prodFamName);
                pfList.prodFamName = prodFamName;
                pfList.prodFamId = productFamilyMap.get(prodFamName)[0].Vision_Product__r.Product_Family__c;
                List<Compliance_Summary__c> prodFamList = productFamilyMap.get(prodFamName);
                pfList.rxComplianceList = prodFamList;
                for(Compliance_Summary__c comp : prodFamList){  
                    if(isDirect){
                        pfList.DirectAwardedQuantity = pfList.DirectAwardedQuantity + (comp.Awarded_Information__c != null ? comp.Awarded_Information__c:0);
                        pfList.DirectAwardedQtyMonthly = pfList.DirectAwardedQtyMonthly + (comp.Direct_Awarded_Quantity_Monthly__c != null ? comp.Direct_Awarded_Quantity_Monthly__c :0);
                        pfList.M1DirectAct = (pfList.M1DirectAct != null ? pfList.M1DirectAct : 0) + (comp.M1_Quantity__c!= null ? comp.M1_Quantity__c :0);
                        pfList.M2DirectAct = (pfList.M2DirectAct != null ? pfList.M2DirectAct : 0) + (comp.M2_Quantity__c!= null ? comp.M2_Quantity__c :0);
                        pfList.M3DirectAct = pfList.M3DirectAct + (comp.M3_Quantity__c!= null ? comp.M3_Quantity__c :0);
                        pfList.M4DirectAct = pfList.M4DirectAct + (comp.M4_Quantity__c!= null ? comp.M4_Quantity__c :0);
                        pfList.M5DirectAct = pfList.M5DirectAct + (comp.M5_Quantity__c!= null ? comp.M5_Quantity__c :0);
                        pfList.M6DirectAct = pfList.M6DirectAct + (comp.M6_Quantity__c!= null ? comp.M6_Quantity__c :0);
                        pfList.M7DirectAct = pfList.M7DirectAct + (comp.M7_Quantity__c!= null ? comp.M7_Quantity__c :0);
                        if(pfList.DirectAwardedQtyMonthly > 0 ){
                          pfList.M7DirectCompliance = ((pfList.M7DirectAct / pfList.DirectAwardedQtyMonthly)*100).setScale(0);
                        pfList.M6DirectCompliance = ((pfList.M6DirectAct / pfList.DirectAwardedQtyMonthly)*100).setScale(0);
                        pfList.M5DirectCompliance = ((pfList.M5DirectAct / pfList.DirectAwardedQtyMonthly)*100).setScale(0);
                        pfList.M4DirectCompliance = ((pfList.M4DirectAct / pfList.DirectAwardedQtyMonthly)*100).setScale(0);
                        pfList.M3DirectCompliance = ((pfList.M3DirectAct / pfList.DirectAwardedQtyMonthly)*100).setScale(0);
                        pfList.M2DirectCompliance = ((pfList.M2DirectAct / pfList.DirectAwardedQtyMonthly)*100).setScale(0);   
                        }
                       
                        pfList.M1DirectAvg = pfList.M1DirectAvg + (comp.M1_Direct_Avg_Quantity__c!= null ? comp.M1_Direct_Avg_Quantity__c :0);
                        pfList.M2DirectAvg = pfList.M2DirectAvg + (comp.M2_Direct_Avg_Quantity__c!= null ? comp.M2_Direct_Avg_Quantity__c :0);
                        pfList.M3DirectAvg = pfList.M3DirectAvg + (comp.M3_Direct_Avg_Quantity__c!= null ? comp.M3_Direct_Avg_Quantity__c :0);
                        pfList.M4DirectAvg = pfList.M4DirectAvg + (comp.M4_Direct_Avg_Quantity__c!= null ? comp.M4_Direct_Avg_Quantity__c :0);
                        pfList.M5DirectAvg = pfList.M5DirectAvg + (comp.M5_Direct_Avg_Quantity__c!= null ? comp.M5_Direct_Avg_Quantity__c :0);
                        pfList.M6DirectAvg = pfList.M6DirectAvg + (comp.M6_Direct_Avg_Quantity__c!= null ? comp.M6_Direct_Avg_Quantity__c :0);
                        pfList.M7DirectAvg = pfList.M7DirectAvg + (comp.M7_Direct_Avg_Quantity__c!= null ? comp.M7_Direct_Avg_Quantity__c :0);
                        pfList.QTDDirectAct = pfList.QTDDirectAct + (comp.QTD_Direct_Quantity__c!= null ? comp.QTD_Direct_Quantity__c :0);
                        pfList.QTDDirectAwardedQty = (pfList.QTDDirectAwardedQty + (comp.QTD_Direct_Awarded_Quantity__c!= null ? comp.QTD_Direct_Awarded_Quantity__c :0)).setScale(0);
                        if(pfList.QTDDirectAct != 0 && pfList.QTDDirectAwardedQty != 0){
                            pfList.QTDDirectCompliance = ((pfList.QTDDirectAct / pfList.QTDDirectAwardedQty)*100).setScale(0);
                        }
                        pfList.FTDDirectAct = pfList.FTDDirectAct + (comp.FTD_Direct_Quantity__c!= null ? comp.FTD_Direct_Quantity__c :0);
                        pfList.FTDDirectAwardedQty = (pfList.FTDDirectAwardedQty + (comp.FTD_Direct_Awarded_Quantity__c!= null ? comp.FTD_Direct_Awarded_Quantity__c :0)).setScale(0);
                        if(pfList.FTDDirectAct != 0 && pfList.FTDDirectAwardedQty != 0){
                            pfList.FTDDirectCompliance = ((pfList.FTDDirectAct / pfList.FTDDirectAwardedQty)*100).setScale(0);
                        }
                        pfList.CTDDirectAct = pfList.CTDDirectAct + (comp.CTD_Direct_Quantity__c!= null ? comp.CTD_Direct_Quantity__c :0);
                        pfList.CTDDirectAwardedQty = (pfList.CTDDirectAwardedQty + (comp.CTD_Direct_Awarded_Quantity__c!= null ? comp.CTD_Direct_Awarded_Quantity__c :0)).setScale(0);
                        if(pfList.CTDDirectAct != 0 && pfList.CTDDirectAwardedQty != 0){
                            pfList.CTDDirectCompliance = ((pfList.CTDDirectAct / pfList.CTDDirectAwardedQty)*100).setScale(0);
                        }
                         pfList.MTDDirectAct = pfList.MTDDirectAct + (comp.M1_Quantity__c!= null ? comp.M1_Quantity__c :0);
                        pfList.MTDDirectAwardedQty = (pfList.MTDDirectAwardedQty + (comp.MTD_Direct_Awarded_Quantity__c!= null ? comp.MTD_Direct_Awarded_Quantity__c :0)).setScale(0);
                        if(pfList.MTDDirectAct != 0 && pfList.MTDDirectAwardedQty != 0){
                            pfList.MTDDirectCompliance = ((pfList.MTDDirectAct / pfList.MTDDirectAwardedQty)*100).setScale(0);
                        }


                    }
                    if(isIndirect){
                        pfList.IndirectAwardedQtyMonthly = pfList.IndirectAwardedQtyMonthly + (comp.Indirect_Awarded_Quantity_Monthly__c!= null ? comp.Indirect_Awarded_Quantity_Monthly__c :0);
                        pfList.IndirectAwardedQuantity = pfList.IndirectAwardedQuantity + (comp.Indirect_Awarded_Information__c!= null ? comp.Indirect_Awarded_Information__c :0);
                        pfList.M1InDirectAct = pfList.M1InDirectAct + (comp.M1_Indirect_Quantity__c!= null ? comp.M1_Indirect_Quantity__c :0);
                        pfList.M2InDirectAct = pfList.M2InDirectAct + (comp.M2_Indirect_Quantity__c!= null ? comp.M2_Indirect_Quantity__c :0);
                        pfList.M3InDirectAct = pfList.M3InDirectAct + (comp.M3_Indirect_Quantity__c!= null ? comp.M3_Indirect_Quantity__c :0);
                        pfList.M4InDirectAct = pfList.M4InDirectAct + (comp.M4_Indirect_Quantity__c!= null ? comp.M4_Indirect_Quantity__c :0);
                        pfList.M5InDirectAct = pfList.M5InDirectAct + (comp.M5_Indirect_Quantity__c!= null ? comp.M5_Indirect_Quantity__c :0);
                        pfList.M6InDirectAct = pfList.M6InDirectAct + (comp.M6_Indirect_Quantity__c!= null ? comp.M6_Indirect_Quantity__c :0);
                        pfList.M7InDirectAct = pfList.M7InDirectAct + (comp.M7_Indirect_Quantity__c!= null ? comp.M7_Indirect_Quantity__c :0);
                        pfList.M1InDirectAvg = pfList.M1InDirectAvg + (comp.M1_Indirect_Avg_Quantity__c!= null ? comp.M1_Indirect_Avg_Quantity__c :0);
                        pfList.M2InDirectAvg = pfList.M2InDirectAvg + (comp.M2_Indirect_Avg_Quantity__c!= null ? comp.M2_Indirect_Avg_Quantity__c :0);
                        pfList.M3InDirectAvg = pfList.M3InDirectAvg + (comp.M3_Indirect_Avg_Quantity__c!= null ? comp.M3_Indirect_Avg_Quantity__c :0);
                        pfList.M4InDirectAvg = pfList.M4InDirectAvg + (comp.M4_Indirect_Avg_Quantity__c!= null ? comp.M4_Indirect_Avg_Quantity__c :0);
                        pfList.M5InDirectAvg = pfList.M5InDirectAvg + (comp.M5_Indirect_Avg_Quantity__c!= null ? comp.M5_Indirect_Avg_Quantity__c :0);
                        pfList.M6InDirectAvg = pfList.M6InDirectAvg + (comp.M6_Indirect_Avg_Quantity__c!= null ? comp.M6_Indirect_Avg_Quantity__c :0);
                        pfList.M7InDirectAvg = pfList.M7InDirectAvg + (comp.M7_Indirect_Avg_Quantity__c!= null ? comp.M7_Indirect_Avg_Quantity__c :0); 
                        if(pfList.IndirectAwardedQtyMonthly > 0){
                        pfList.M7InDirectCompliance =  ((pfList.M7InDirectAct / pfList.IndirectAwardedQtyMonthly)*100).setScale(0);
                        pfList.M6InDirectCompliance =  ((pfList.M6InDirectAct / pfList.IndirectAwardedQtyMonthly)*100).setScale(0);
                        pfList.M5InDirectCompliance =  ((pfList.M5InDirectAct / pfList.IndirectAwardedQtyMonthly)*100).setScale(0);
                        pfList.M4InDirectCompliance =  ((pfList.M4InDirectAct / pfList.IndirectAwardedQtyMonthly)*100).setScale(0);
                        pfList.M3InDirectCompliance =  ((pfList.M3InDirectAct / pfList.IndirectAwardedQtyMonthly)*100).setScale(0);
                        pfList.M2InDirectCompliance =  ((pfList.M2InDirectAct / pfList.IndirectAwardedQtyMonthly)*100).setScale(0);
                        pfList.M1InDirectCompliance =  ((pfList.M2InDirectAct / pfList.IndirectAwardedQtyMonthly)*100).setScale(0);
                        }
                        pfList.QTDIndirectAct = pfList.QTDIndirectAct + (comp.QTD_Indirect_Quantity__c!= null ? comp.QTD_Indirect_Quantity__c :0);
                        pfList.QTDIndirectAwardedQty = (pfList.QTDIndirectAwardedQty + (comp.QTD_Indirect_Awarded_Quantity__c!= null ? comp.QTD_Indirect_Awarded_Quantity__c :0)).setScale(0);
                        if(pfList.QTDIndirectAct != 0 && pfList.QTDIndirectAwardedQty != 0){
                            pfList.QTDIndirectCompliance = ((pfList.QTDIndirectAct / pfList.QTDIndirectAwardedQty)*100).setScale(0);
                        }
                        pfList.FTDIndirectAct = pfList.FTDIndirectAct + (comp.FTD_Indirect_Quantity__c!= null ? comp.FTD_Indirect_Quantity__c :0);
                        pfList.FTDIndirectAwardedQty = (pfList.FTDIndirectAwardedQty + (comp.FTD_Indirect_Awarded_Quantity__c!= null ? comp.FTD_Indirect_Awarded_Quantity__c :0)).setScale(0);
                        if(pfList.FTDIndirectAct != 0 && pfList.FTDIndirectAwardedQty != 0){
                            pfList.FTDIndirectCompliance = ((pfList.FTDIndirectAct / pfList.FTDIndirectAwardedQty)*100).setScale(0); 
                        }
                        pfList.CTDIndirectAct = pfList.CTDIndirectAct + (comp.CTD_Indirect_Quantity__c!= null ? comp.CTD_Indirect_Quantity__c :0);
                        pfList.CTDIndirectAwardedQty = (pfList.CTDIndirectAwardedQty + (comp.CTD_Indirect_Awarded_Quantity__c!= null ? comp.CTD_Indirect_Awarded_Quantity__c :0)).setScale(0);
                        if(pfList.CTDIndirectAct != 0 && pfList.CTDIndirectAwardedQty != 0){
                            pfList.CTDIndirectCompliance = ((pfList.CTDIndirectAct / pfList.CTDIndirectAwardedQty)*100).setScale(0); 
                        }
                         pfList.MTDIndirectAct = pfList.MTDIndirectAct + (comp.M1_Indirect_Quantity__c!= null ? comp.M1_Indirect_Quantity__c :0);
                        pfList.MTDIndirectAwardedQty = (pfList.MTDIndirectAwardedQty + (comp.MTD_Indirect_Awarded_Quantity__c!= null ? comp.MTD_Indirect_Awarded_Quantity__c :0)).setScale(0);
                        if(pfList.MTDIndirectAct != 0 && pfList.MTDIndirectAwardedQty != 0){
                            pfList.MTDIndirectCompliance = ((pfList.MTDIndirectAct / pfList.MTDIndirectAwardedQty)*100).setScale(0); 
                        }
                    }
                    if(isTotal){
                        pfList.TotalAwardedQuantity = (pfList.TotalAwardedQuantity != null ? pfList.TotalAwardedQuantity : 0) + (comp.Total_Awarded_Information__c!= null ? comp.Total_Awarded_Information__c :0);
                        pfList.TotalAwardedQtyMonthly = pfList.TotalAwardedQtyMonthly + (comp.Total_Awarded_Information_Monthly__c != null ? comp.Total_Awarded_Information_Monthly__c :0);
                        pfList.M1TotalAct = pfList.M1TotalAct + (comp.M1_Total_Quantity__c!= null ? comp.M1_Total_Quantity__c :0);
                        pfList.M2TotalAct = pfList.M2TotalAct + (comp.M2_Total_Quantity__c!= null ? comp.M2_Total_Quantity__c :0);
                        pfList.M3TotalAct = pfList.M3TotalAct + (comp.M3_Total_Quantity__c!= null ? comp.M3_Total_Quantity__c :0);
                        pfList.M4TotalAct = pfList.M4TotalAct + (comp.M4_Total_Quantity__c!= null ? comp.M4_Total_Quantity__c :0);
                        pfList.M5TotalAct = pfList.M5TotalAct + (comp.M5_Total_Quantity__c!= null ? comp.M5_Total_Quantity__c :0);
                        pfList.M6TotalAct = pfList.M6TotalAct + (comp.M6_Total_Quantity__c!= null ? comp.M6_Total_Quantity__c :0);
                        pfList.M7TotalAct = pfList.M7TotalAct + (comp.M7_Total_Quantity__c!= null ? comp.M7_Total_Quantity__c :0);
                        pfList.M1TotalAvg = pfList.M1TotalAvg + (comp.M1_Total_Avg_Quantity__c!= null ? comp.M1_Total_Avg_Quantity__c :0);
                        pfList.M2TotalAvg = pfList.M2TotalAvg + (comp.M2_Total_Avg_Quantity__c!= null ? comp.M2_Total_Avg_Quantity__c :0);
                        pfList.M3TotalAvg = pfList.M3TotalAvg + (comp.M3_Total_Avg_Quantity__c!= null ? comp.M3_Total_Avg_Quantity__c :0);
                        pfList.M4TotalAvg = pfList.M4TotalAvg + (comp.M4_Total_Avg_Quantity__c!= null ? comp.M4_Total_Avg_Quantity__c :0);
                        pfList.M5TotalAvg = pfList.M5TotalAvg + (comp.M5_Total_Avg_Quantity__c!= null ? comp.M5_Total_Avg_Quantity__c :0);
                        pfList.M6TotalAvg = pfList.M6TotalAvg + (comp.M6_Total_Avg_Quantity__c!= null ? comp.M6_Total_Avg_Quantity__c :0);
                        pfList.M7TotalAvg = pfList.M7TotalAvg + (comp.M7_Total_Avg_Quantity__c!= null ? comp.M7_Total_Avg_Quantity__c :0); 
                        if(pfList.TotalAwardedQtyMonthly >0){
                             pfList.M7TotalCompliance = ((pfList.M7TotalAct / pfList.TotalAwardedQtyMonthly)*100).setScale(0);
                        pfList.M6TotalCompliance = ((pfList.M6TotalAct / pfList.TotalAwardedQtyMonthly)*100).setScale(0);
                        pfList.M5TotalCompliance = ((pfList.M5TotalAct / pfList.TotalAwardedQtyMonthly)*100).setScale(0);
                        pfList.M4TotalCompliance = ((pfList.M4TotalAct / pfList.TotalAwardedQtyMonthly)*100).setScale(0);
                        pfList.M3TotalCompliance = ((pfList.M3TotalAct / pfList.TotalAwardedQtyMonthly)*100).setScale(0);
                        pfList.M2TotalCompliance = ((pfList.M2TotalAct / pfList.TotalAwardedQtyMonthly)*100).setScale(0);
                        pfList.M1TotalCompliance = ((pfList.M1TotalAct / pfList.TotalAwardedQtyMonthly)*100).setScale(0);
                          
                        }
                     pfList.QTDTotalAct = pfList.QTDTotalAct + (comp.QTD_Total_Quantity__c!= null ? comp.QTD_Total_Quantity__c :0);
                        pfList.QTDTotalAwardedQty = (pfList.QTDTotalAwardedQty + (comp.QTD_Total_Awarded_Quantity__c!= null ? comp.QTD_Total_Awarded_Quantity__c :0)).setScale(0);
                        if(pfList.QTDTotalAct != 0 && pfList.QTDTotalAwardedQty != 0){
                            pfList.QTDTotalCompliance = ((pfList.QTDTotalAct / pfList.QTDTotalAwardedQty)*100).setScale(0);   
                        }
                        pfList.FTDTotalAct = pfList.FTDTotalAct + (comp.FTD_Total_Quantity__c!= null ? comp.FTD_Total_Quantity__c :0);
                        pfList.FTDTotalAwardedQty = (pfList.FTDTotalAwardedQty + (comp.FTD_Total_Awarded_Quantity__c!= null ? comp.FTD_Total_Awarded_Quantity__c :0)).setScale(0);
                        if(pfList.FTDTotalAct != 0 && pfList.FTDTotalAwardedQty != 0){
                            pfList.FTDTotalCompliance = ((pfList.FTDTotalAct / pfList.FTDTotalAwardedQty)*100).setScale(0);
                        }
                        pfList.CTDTotalAct = pfList.CTDTotalAct + (comp.CTD_Total_Quantity__c!= null ? comp.CTD_Total_Quantity__c :0);
                        pfList.CTDTotalAwardedQty = (pfList.CTDTotalAwardedQty + (comp.CTD_Total_Awarded_Quantity__c!= null ? comp.CTD_Total_Awarded_Quantity__c :0)).setScale(0);
                        if(pfList.CTDTotalAct != 0 && pfList.CTDTotalAwardedQty != 0){
                            pfList.CTDTotalCompliance = ((pfList.CTDTotalAct / pfList.CTDTotalAwardedQty)*100).setScale(0); 
                        }
                           pfList.MTDTotalAct = pfList.MTDTotalAct + (comp.M1_Total_Quantity__c!= null ? comp.M1_Total_Quantity__c :0);
                        pfList.MTDTotalAwardedQty = (pfList.MTDTotalAwardedQty + (comp.MTD_Total_Awarded_Quantity__c!= null ? comp.MTD_Total_Awarded_Quantity__c :0)).setScale(0);
                        if(pfList.MTDTotalAct != 0 && pfList.MTDTotalAwardedQty != 0){
                            pfList.MTDTotalCompliance = ((pfList.MTDTotalAct / pfList.MTDTotalAwardedQty)*100).setScale(0); 
                        }
                    }
                }
                ProductFamilyWrapperList.add(pfList);
                
            }
            
            List<Compliance_Summary__c> complianceMonthList=[SELECT Month1__c,Month2__c,Month3__c,Month4__c,Month5__c,Month6__c,Month7__c,Month8__c,Month9__c FROM Compliance_Summary__c where Month2__c !=null and Month3__c !=null and Month4__c !=null and Month5__c !=null and Month6__c !=null and Month7__c !=null Limit 1];
            if(complianceMonthList.size()>0){
                ///system.debug('rxComplianceList2'+ rxComplianceList);
                mainWrap.Month1 = complianceMonthList[0].Month2__c;    
                mainWrap.Month2 = complianceMonthList[0].Month3__c;    
                mainWrap.Month3 = complianceMonthList[0].Month4__c;    
                mainWrap.Month4 = complianceMonthList[0].Month5__c;    
                mainWrap.Month5 = complianceMonthList[0].Month6__c;    
                mainWrap.Month6 = complianceMonthList[0].Month7__c; 
                mainWrap.Month7 = complianceMonthList[0].Month1__c;
            } 
            
            
            mainWrap.noOfRecords = rxComplianceList.size();  
            //  mainWrap.rxComplianceList = rxComplianceList;
            mainWrap.ProductFamilyWrapperList = ProductFamilyWrapperList;
            ///system.debug('mainwrap-----'+mainwrap);
            
            
        }
        return mainwrap;
    }

    @AuraEnabled(cacheable=true)  
    public static MainWrapper getOnlyComplianceDataHistoricalSales(String searchText,String customerId,String showNonCompliance,Boolean showAll,Boolean showPrimary, Boolean isDirect, Boolean isIndirect, Boolean isTotal, String productDirector){
           List<String> apexClassList = new List<String>();
        apexClassList.add('ComplianceRecordsNprData');
        apexClassList.add('Compliance_RollUP_Batch');
        apexClassList.add('complianceCTDFTDdata');
        apexJobStatus(apexClassList);
        
        system.debug('productDirector====='+productDirector);
        system.debug('showNonComplianc====='+showNonCompliance);
        MainWrapper mainWrap = new MainWrapper();
        mainWrap.isProcessed =  apexJobStatus(apexClassList);
         system.debug('productDirector====='+productDirector);
        system.debug('showNonComplianc====='+showNonCompliance);
        String query = '';
        String category = 'Primary';
        // String strFields = Phoenix_Util.rxExternalObjFields;
        String SobjectApiName = 'Compliance_Summary__c';
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
        map<String,List<Compliance_Summary__c>> productFamilyMap = new map<String,List<Compliance_Summary__c>>();
        
       // query = 'select Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null';
        query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Vision_Product__r.Product_Family__r.Name != null ';   

         if(isDirect){
              if(showNonCompliance == '1Month'){
            query =  query+'and (M2_Direct_Avg_Qty_Compliance__c <75) ';
        }
        else if(showNonCompliance == '2Month'){
            query =  query+'and (M2_Direct_Avg_Qty_Compliance__c < 75 and M3_Direct_Avg_Qty_Compliance__c < 75) ';
            
        } 
        else if(showNonCompliance == '3Month'){
            query =  query+'and (M2_Direct_Avg_Qty_Compliance__c < 75 and M3_Direct_Avg_Qty_Compliance__c < 75 and M4_Direct_Avg_Qty_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '4Month'){
            query =  query+'and (M2_Direct_Avg_Qty_Compliance__c < 75 and M3_Direct_Avg_Qty_Compliance__c < 75 and M4_Direct_Avg_Qty_Compliance__c < 75 and M5_Direct_Avg_Qty_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '5Month'){
            query =  query+'and (M2_Direct_Avg_Qty_Compliance__c < 75 and M3_Direct_Avg_Qty_Compliance__c < 75 and M4_Direct_Avg_Qty_Compliance__c < 75 and M5_Direct_Avg_Qty_Compliance__c < 75 and M6_Direct_Avg_Qty_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '6Month'){
            query =  query+'and (M2_Direct_Avg_Qty_Compliance__c < 75 and M3_Direct_Avg_Qty_Compliance__c < 75 and M4_Direct_Avg_Qty_Compliance__c < 75 and M5_Direct_Avg_Qty_Compliance__c < 75 and M6_Direct_Avg_Qty_Compliance__c < 75  and M7_Direct_Avg_Qty_Compliance__c < 75) ';
            
        }
        else{
            
        }
                if(searchText != null && searchText !='') {
                searchText = '%'+searchText+'%';
            if(!showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('!showPrimary - productDirector not null');
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Is_Direct__c = true and General_Category__c =: category and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                }
                else{
                    system.debug('!showPrimary - productDirector null');
                    
                    query = query+'and Is_Direct__c = true and General_Category__c =: category and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                    
                }
                // query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 order by Vision_Product__r.Name';
            }
            else if(showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('showPrimary - productDirector not null');
                    
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Is_Direct__c = true and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText)  order by Vision_Product__r.Name';
                }
                else{
                    system.debug('showPrimary - productDirector not null');
                    
                    query = query+'and Is_Direct__c = true and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText)  order by Vision_Product__r.Name';
                    
                }
                //     query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and  Vision_Product__r.Name != null and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 order by Vision_Product__r.Name';
            }  
                }
               else{
                   if(!showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('!showPrimary - productDirector not null');
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Is_Direct__c = true and General_Category__c =: category order by Vision_Product__r.Name';
                }
                else{
                    system.debug('!showPrimary - productDirector null');
                    
                    query = query+'and Is_Direct__c = true and General_Category__c =: category order by Vision_Product__r.Name';
                    
                }
                // query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 order by Vision_Product__r.Name';
            }
            else if(showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('showPrimary - productDirector not null');
                    
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Is_Direct__c = true order by Vision_Product__r.Name';
                }
                else{
                    system.debug('showPrimary - productDirector not null');
                    
                    query = query+'and Is_Direct__c = true order by Vision_Product__r.Name';
                    
                }
                //     query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and  Vision_Product__r.Name != null and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 order by Vision_Product__r.Name';
            }     
               }
            //  }
        }
        else if(isIndirect){
            
              if(showNonCompliance == '1Month'){
            query =  query+'and (M2_Indirect_Avg_Qty_Compliance__c < 75) ';
        }
        else if(showNonCompliance == '2Month'){
            query =  query+'and (M2_Indirect_Avg_Qty_Compliance__c < 75 and M3_Indirect_Avg_Qty_Compliance__c < 75) ';
            
        } 
        else if(showNonCompliance == '3Month'){
            query =  query+'and (M2_Indirect_Avg_Qty_Compliance__c < 75 and M3_Indirect_Avg_Qty_Compliance__c < 75 and M4_Indirect_Avg_Qty_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '4Month'){
            query =  query+'and (M2_Indirect_Avg_Qty_Compliance__c < 75 and M3_Indirect_Avg_Qty_Compliance__c < 75 and M4_Indirect_Avg_Qty_Compliance__c < 75 and M5_Indirect_Avg_Qty_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '5Month'){
            query =  query+'and (M2_Indirect_Avg_Qty_Compliance__c < 75 and M3_Indirect_Avg_Qty_Compliance__c < 75 and M4_Indirect_Avg_Qty_Compliance__c < 75 and M5_Indirect_Avg_Qty_Compliance__c < 75 and M6_Indirect_Avg_Qty_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '6Month'){
            query =  query+'and (M2_Indirect_Avg_Qty_Compliance__c < 75 and M3_Indirect_Avg_Qty_Compliance__c < 75 and M4_Indirect_Avg_Qty_Compliance__c < 75 and M5_Indirect_Avg_Qty_Compliance__c < 75 and M6_Indirect_Avg_Qty_Compliance__c < 75 and M7_Indirect_Avg_Qty_Compliance__c < 75) ';
            
        }
        else{
            
        }
        
         if(searchText != null && searchText !='') {
                searchText = '%'+searchText+'%';
            if(!showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('!showPrimary - productDirector != null');
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and General_Category__c =: category and Is_Indirect__c = true and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                }
                else{
                    system.debug('!showPrimary - productDirector');
                    query = query+'and General_Category__c =: category and Is_Indirect__c = true and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                    
                }
                //    query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 order by Vision_Product__r.Name';
            }
            else if(showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('showPrimary - productDirector != null');
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Is_Indirect__c = true and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                }
                else{
                    
                    system.debug('showPrimary - productDirector');
                    query = query+'and Is_Indirect__c = true and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';
                    
                }
                // query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 order by Vision_Product__r.Name';
            }    
         }
            else{
                if(!showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('!showPrimary - productDirector != null');
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and General_Category__c =: category and Is_Indirect__c = true order by Vision_Product__r.Name';
                }
                else{
                    system.debug('!showPrimary - productDirector');
                    query = query+'and General_Category__c =: category and Is_Indirect__c = true order by Vision_Product__r.Name';
                    
                }
                //    query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 order by Vision_Product__r.Name';
            }
            else if(showPrimary ){
                if(productDirector != null && productDirector != '' && productDirector != 'undefined'){
                    system.debug('showPrimary - productDirector != null');
                    query = query+'and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Is_Indirect__c = true order by Vision_Product__r.Name';
                }
                else{
                    
                    system.debug('showPrimary - productDirector');
                    query = query+'and Is_Indirect__c = true order by Vision_Product__r.Name';
                    
                }
                // query = 'select Vision_Product__r.Id,Vision_Product__r.Name,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 order by Vision_Product__r.Name';
            }    
            }
        }
        else if(isTotal){
               if(showNonCompliance == '1Month'){
            query =  query+'and (M2_Total_Avg_Qty_Compliance__c < 75) ';
        }
        else if(showNonCompliance == '2Month'){
            query =  query+'and (M2_Total_Avg_Qty_Compliance__c < 75 and M3_Total_Avg_Qty_Compliance__c < 75) ';
            
        } 
        else if(showNonCompliance == '3Month'){
            query =  query+'and (M2_Total_Avg_Qty_Compliance__c < 75 and M3_Total_Avg_Qty_Compliance__c < 75 and M4_Total_Avg_Qty_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '4Month'){
            query =  query+'and (M2_Total_Avg_Qty_Compliance__c < 75 and M3_Total_Avg_Qty_Compliance__c < 75 and M4_Total_Avg_Qty_Compliance__c < 75 and M5_Total_Avg_Qty_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '5Month'){
            query =  query+'and (M2_Total_Avg_Qty_Compliance__c < 75 and M3_Total_Avg_Qty_Compliance__c < 75 and M4_Total_Avg_Qty_Compliance__c < 75 and M5_Total_Avg_Qty_Compliance__c < 75 and M6_Total_Avg_Qty_Compliance__c < 75) ';
            
        }
        else if(showNonCompliance == '6Month'){
            query =  query+'and (M2_Total_Avg_Qty_Compliance__c < 75 and M3_Total_Avg_Qty_Compliance__c < 75 and M4_Total_Avg_Qty_Compliance__c < 75 and M5_Total_Avg_Qty_Compliance__c < 75 and M6_Total_Avg_Qty_Compliance__c < 75 and M7_Total_Avg_Qty_Compliance__c < 75) ';
            
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
                // query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Product_Director__c,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Total_Awarded_Information__c > 0 order by Vision_Product__r.Name';
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
                //   query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Product_Director__c,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Total_Awarded_Information__c > 0 order by Vision_Product__r.Name';
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
                // query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Product_Director__c,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Total_Awarded_Information__c > 0 order by Vision_Product__r.Name';
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
                //   query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Product_Director__c,Vision_Product__r.Product_Family__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Vision_Product__r.Phoenix_Product_Director__c=:productDirector and Total_Awarded_Information__c > 0 order by Vision_Product__r.Name';
            }  
            }
        }
      
        List < Compliance_Summary__c > rxComplianceList = Database.query(query);
        system.debug('second rxlist is '+rxComplianceList);
        ///system.debug('rxComplianceList3'+ rxComplianceList.size());
        List<Compliance_Summary__c> complianceMonthList=[SELECT Month1__c,Month2__c,Month3__c,Month4__c,Month5__c,Month6__c,Month7__c,Month8__c,Month9__c FROM Compliance_Summary__c where Month2__c !=null and Month3__c !=null and Month4__c !=null and Month5__c !=null and Month6__c !=null and Month7__c !=null Limit 1];
        List<ProductFamilyWrapper> ProductFamilyWrapperList = new List<ProductFamilyWrapper>();
        
        if(rxComplianceList.size()>0){
            for(Compliance_Summary__c comp : rxComplianceList){
                if(isDirect){
                    if(productFamilyMap.containsKey(comp.Vision_Product__r.Product_Family__r.Name)){
                        ///system.debug('comp.Vision_Product__r.Product_Family__r.Name==='+comp.Vision_Product__r.Product_Family__r.Name);
                        List<Compliance_Summary__c> prodList = productFamilyMap.get(comp.Vision_Product__r.Product_Family__r.Name);
                        prodList.add(comp);
                        productFamilyMap.put(comp.Vision_Product__r.Product_Family__r.Name,prodList);
                    }
                    else{
                        ///system.debug('comp==='+comp);
                        productFamilyMap.put(comp.Vision_Product__r.Product_Family__r.Name,new List<Compliance_Summary__c>{comp});
                    }
                    ///system.debug('mainWrap.DirectAwardedQuantity===='+mainWrap.DirectAwardedQuantity);
                    mainWrap.DirectAwardedQuantity = mainWrap.DirectAwardedQuantity + (comp.Awarded_Information__c != null ? comp.Awarded_Information__c:0);
                    mainWrap.DirectAwardedQtyMonthly = mainWrap.DirectAwardedQtyMonthly + (comp.Direct_Awarded_Quantity_Monthly__c != null ? comp.Direct_Awarded_Quantity_Monthly__c :0);
                    mainWrap.M2DirectAct = (mainWrap.M2DirectAct != null ? mainWrap.M2DirectAct : 0) + (comp.M2_Quantity__c!= null ? comp.M2_Quantity__c :0);
                    mainWrap.M3DirectAct = mainWrap.M3DirectAct + (comp.M3_Quantity__c!= null ? comp.M3_Quantity__c :0);
                    mainWrap.M4DirectAct = mainWrap.M4DirectAct + (comp.M4_Quantity__c!= null ? comp.M4_Quantity__c :0);
                    mainWrap.M5DirectAct = mainWrap.M5DirectAct + (comp.M5_Quantity__c!= null ? comp.M5_Quantity__c :0);
                    mainWrap.M6DirectAct = mainWrap.M6DirectAct + (comp.M6_Quantity__c!= null ? comp.M6_Quantity__c :0);
                    mainWrap.M7DirectAct = mainWrap.M7DirectAct + (comp.M7_Quantity__c!= null ? comp.M7_Quantity__c :0);
                    mainWrap.M2DirectAvg = mainWrap.M2DirectAvg + (comp.M2_Direct_Avg_Quantity__c!= null ? comp.M2_Direct_Avg_Quantity__c :0);
                    mainWrap.M3DirectAvg = mainWrap.M3DirectAvg + (comp.M3_Direct_Avg_Quantity__c!= null ? comp.M3_Direct_Avg_Quantity__c :0);
                    mainWrap.M4DirectAvg = mainWrap.M4DirectAvg + (comp.M4_Direct_Avg_Quantity__c!= null ? comp.M4_Direct_Avg_Quantity__c :0);
                    mainWrap.M5DirectAvg = mainWrap.M5DirectAvg + (comp.M5_Direct_Avg_Quantity__c!= null ? comp.M5_Direct_Avg_Quantity__c :0);
                    mainWrap.M6DirectAvg = mainWrap.M6DirectAvg + (comp.M6_Direct_Avg_Quantity__c!= null ? comp.M6_Direct_Avg_Quantity__c :0);
                    mainWrap.M7DirectAvg = mainWrap.M7DirectAvg + (comp.M7_Direct_Avg_Quantity__c!= null ? comp.M7_Direct_Avg_Quantity__c :0);
                }
                if(isIndirect){
                    if(productFamilyMap.containsKey(comp.Vision_Product__r.Product_Family__r.Name)){
                        ///system.debug('comp.Vision_Product__r.Product_Family__r.Name==='+comp.Vision_Product__r.Product_Family__r.Name);
                        List<Compliance_Summary__c> prodList = productFamilyMap.get(comp.Vision_Product__r.Product_Family__r.Name);
                        prodList.add(comp);
                        productFamilyMap.put(comp.Vision_Product__r.Product_Family__r.Name,prodList);
                    }
                    else{
                        ///system.debug('comp==='+comp);
                        productFamilyMap.put(comp.Vision_Product__r.Product_Family__r.Name,new List<Compliance_Summary__c>{comp});
                    }
                    mainWrap.IndirectAwardedQtyMonthly = mainWrap.IndirectAwardedQtyMonthly + (comp.Indirect_Awarded_Quantity_Monthly__c!= null ? comp.Indirect_Awarded_Quantity_Monthly__c :0);
                    mainWrap.IndirectAwardedQuantity = mainWrap.IndirectAwardedQuantity + (comp.Indirect_Awarded_Information__c!= null ? comp.Indirect_Awarded_Information__c :0);
                    mainWrap.M2InDirectAct = mainWrap.M2InDirectAct + (comp.M2_Indirect_Quantity__c!= null ? comp.M2_Indirect_Quantity__c :0);
                    mainWrap.M3InDirectAct = mainWrap.M3InDirectAct + (comp.M3_Indirect_Quantity__c!= null ? comp.M3_Indirect_Quantity__c :0);
                    mainWrap.M4InDirectAct = mainWrap.M4InDirectAct + (comp.M4_Indirect_Quantity__c!= null ? comp.M4_Indirect_Quantity__c :0);
                    mainWrap.M5InDirectAct = mainWrap.M5InDirectAct + (comp.M5_Indirect_Quantity__c!= null ? comp.M5_Indirect_Quantity__c :0);
                    mainWrap.M6InDirectAct = mainWrap.M6InDirectAct + (comp.M6_Indirect_Quantity__c!= null ? comp.M6_Indirect_Quantity__c :0);
                    mainWrap.M7InDirectAct = mainWrap.M7InDirectAct + (comp.M7_Indirect_Quantity__c!= null ? comp.M7_Indirect_Quantity__c :0);
                    mainWrap.M2InDirectAvg = mainWrap.M2InDirectAvg + (comp.M2_Indirect_Avg_Quantity__c!= null ? comp.M2_Indirect_Avg_Quantity__c :0);
                    mainWrap.M3InDirectAvg = mainWrap.M3InDirectAvg + (comp.M3_Indirect_Avg_Quantity__c!= null ? comp.M3_Indirect_Avg_Quantity__c :0);
                    mainWrap.M4InDirectAvg = mainWrap.M4InDirectAvg + (comp.M4_Indirect_Avg_Quantity__c!= null ? comp.M4_Indirect_Avg_Quantity__c :0);
                    mainWrap.M5InDirectAvg = mainWrap.M5InDirectAvg + (comp.M5_Indirect_Avg_Quantity__c!= null ? comp.M5_Indirect_Avg_Quantity__c :0);
                    mainWrap.M6InDirectAvg = mainWrap.M6InDirectAvg + (comp.M6_Indirect_Avg_Quantity__c!= null ? comp.M6_Indirect_Avg_Quantity__c :0);
                    mainWrap.M7InDirectAvg = mainWrap.M7InDirectAvg + (comp.M7_Indirect_Avg_Quantity__c!= null ? comp.M7_Indirect_Avg_Quantity__c :0);
                }
                if(isTotal){
                    if(productFamilyMap.containsKey(comp.Vision_Product__r.Product_Family__r.Name)){
                        ///system.debug('comp.Vision_Product__r.Product_Family__r.Name==='+comp.Vision_Product__r.Product_Family__r.Name);
                        List<Compliance_Summary__c> prodList = productFamilyMap.get(comp.Vision_Product__r.Product_Family__r.Name);
                        prodList.add(comp);
                        productFamilyMap.put(comp.Vision_Product__r.Product_Family__r.Name,prodList);
                    }
                    else{
                        ///system.debug('comp==='+comp);
                        productFamilyMap.put(comp.Vision_Product__r.Product_Family__r.Name,new List<Compliance_Summary__c>{comp});
                    }
                    mainWrap.TotalAwardedQuantity = (mainWrap.TotalAwardedQuantity != null ? mainWrap.TotalAwardedQuantity : 0) + (comp.Total_Awarded_Information__c!= null ? comp.Total_Awarded_Information__c :0);
                    mainWrap.TotalAwardedQtyMonthly = mainWrap.TotalAwardedQtyMonthly + (comp.Total_Awarded_Information_Monthly__c != null ? comp.Total_Awarded_Information_Monthly__c :0);
                    mainWrap.M2TotalAct = mainWrap.M2TotalAct + (comp.M2_Total_Quantity__c!= null ? comp.M2_Total_Quantity__c :0);
                    mainWrap.M3TotalAct = mainWrap.M3TotalAct + (comp.M3_Total_Quantity__c!= null ? comp.M3_Total_Quantity__c :0);
                    mainWrap.M4TotalAct = mainWrap.M4TotalAct + (comp.M4_Total_Quantity__c!= null ? comp.M4_Total_Quantity__c :0);
                    mainWrap.M5TotalAct = mainWrap.M5TotalAct + (comp.M5_Total_Quantity__c!= null ? comp.M5_Total_Quantity__c :0);
                    mainWrap.M6TotalAct = mainWrap.M6TotalAct + (comp.M6_Total_Quantity__c!= null ? comp.M6_Total_Quantity__c :0);
                    mainWrap.M7TotalAct = mainWrap.M7TotalAct + (comp.M7_Total_Quantity__c!= null ? comp.M7_Total_Quantity__c :0);
                    mainWrap.M2TotalAvg = mainWrap.M2TotalAvg + (comp.M2_Total_Avg_Quantity__c!= null ? comp.M2_Total_Avg_Quantity__c :0);
                    mainWrap.M3TotalAvg = mainWrap.M3TotalAvg + (comp.M3_Total_Avg_Quantity__c!= null ? comp.M3_Total_Avg_Quantity__c :0);
                    mainWrap.M4TotalAvg = mainWrap.M4TotalAvg + (comp.M4_Total_Avg_Quantity__c!= null ? comp.M4_Total_Avg_Quantity__c :0);
                    mainWrap.M5TotalAvg = mainWrap.M5TotalAvg + (comp.M5_Total_Avg_Quantity__c!= null ? comp.M5_Total_Avg_Quantity__c :0);
                    mainWrap.M6TotalAvg = mainWrap.M6TotalAvg + (comp.M6_Total_Avg_Quantity__c!= null ? comp.M6_Total_Avg_Quantity__c :0);
                    mainWrap.M7TotalAvg = mainWrap.M7TotalAvg + (comp.M7_Total_Avg_Quantity__c!= null ? comp.M7_Total_Avg_Quantity__c :0); 
                }
            }
            for(string prodFamName : productFamilyMap.keySet()){
                ProductFamilyWrapper pfList = new ProductFamilyWrapper();
                
                ///system.debug('prodFamName==='+prodFamName);
                pfList.prodFamName = prodFamName;
                pfList.prodFamId = productFamilyMap.get(prodFamName)[0].Vision_Product__r.Product_Family__c;
                List<Compliance_Summary__c> prodFamList = productFamilyMap.get(prodFamName);
                pfList.rxComplianceList = prodFamList;
                for(Compliance_Summary__c comp : prodFamList){  
                    if(isDirect){
                        pfList.DirectAwardedQuantity = pfList.DirectAwardedQuantity + (comp.Awarded_Information__c != null ? comp.Awarded_Information__c:0);
                        pfList.DirectAwardedQtyMonthly = pfList.DirectAwardedQtyMonthly + (comp.Direct_Awarded_Quantity_Monthly__c != null ? comp.Direct_Awarded_Quantity_Monthly__c :0);
                        pfList.M2DirectAct = (pfList.M2DirectAct != null ? pfList.M2DirectAct : 0) + (comp.M2_Quantity__c!= null ? comp.M2_Quantity__c :0);
                        pfList.M3DirectAct = pfList.M3DirectAct + (comp.M3_Quantity__c!= null ? comp.M3_Quantity__c :0);
                        pfList.M4DirectAct = pfList.M4DirectAct + (comp.M4_Quantity__c!= null ? comp.M4_Quantity__c :0);
                        pfList.M5DirectAct = pfList.M5DirectAct + (comp.M5_Quantity__c!= null ? comp.M5_Quantity__c :0);
                        pfList.M6DirectAct = pfList.M6DirectAct + (comp.M6_Quantity__c!= null ? comp.M6_Quantity__c :0);
                        pfList.M7DirectAct = pfList.M7DirectAct + (comp.M7_Quantity__c!= null ? comp.M7_Quantity__c :0);
                        pfList.M2DirectAvg = pfList.M2DirectAvg + (comp.M2_Direct_Avg_Quantity__c!= null ? comp.M2_Direct_Avg_Quantity__c :0);
                        pfList.M3DirectAvg = pfList.M3DirectAvg + (comp.M3_Direct_Avg_Quantity__c!= null ? comp.M3_Direct_Avg_Quantity__c :0);
                        pfList.M4DirectAvg = pfList.M4DirectAvg + (comp.M4_Direct_Avg_Quantity__c!= null ? comp.M4_Direct_Avg_Quantity__c :0);
                        pfList.M5DirectAvg = pfList.M5DirectAvg + (comp.M5_Direct_Avg_Quantity__c!= null ? comp.M5_Direct_Avg_Quantity__c :0);
                        pfList.M6DirectAvg = pfList.M6DirectAvg + (comp.M6_Direct_Avg_Quantity__c!= null ? comp.M6_Direct_Avg_Quantity__c :0);
                        pfList.M7DirectAvg = pfList.M7DirectAvg + (comp.M7_Direct_Avg_Quantity__c!= null ? comp.M7_Direct_Avg_Quantity__c :0);
                        if(pfList.M7DirectAct != 0 && pfList.M7DirectAvg != 0){pfList.M7DirectCompliance = ((pfList.M7DirectAct / pfList.M7DirectAvg)*100).setScale(0);}
                        if(pfList.M6DirectAct != 0 && pfList.M6DirectAvg != 0){pfList.M6DirectCompliance = ((pfList.M6DirectAct / pfList.M6DirectAvg)*100).setScale(0);}
                        if(pfList.M5DirectAct != 0 && pfList.M5DirectAvg != 0){pfList.M5DirectCompliance = ((pfList.M5DirectAct / pfList.M5DirectAvg)*100).setScale(0);}
                        if(pfList.M4DirectAct != 0 && pfList.M4DirectAvg != 0){pfList.M4DirectCompliance = ((pfList.M4DirectAct / pfList.M4DirectAvg)*100).setScale(0);}
                        if(pfList.M3DirectAct != 0 && pfList.M3DirectAvg != 0){pfList.M3DirectCompliance = ((pfList.M3DirectAct / pfList.M3DirectAvg)*100).setScale(0);}
                        if(pfList.M2DirectAct != 0 && pfList.M2DirectAvg != 0){pfList.M2DirectCompliance = ((pfList.M2DirectAct / pfList.M2DirectAvg)*100).setScale(0);}
                    }
                    if(isIndirect){
                        pfList.IndirectAwardedQtyMonthly = pfList.IndirectAwardedQtyMonthly + (comp.Indirect_Awarded_Quantity_Monthly__c!= null ? comp.Indirect_Awarded_Quantity_Monthly__c :0);
                        pfList.IndirectAwardedQuantity = pfList.IndirectAwardedQuantity + (comp.Indirect_Awarded_Information__c!= null ? comp.Indirect_Awarded_Information__c :0);
                        pfList.M2InDirectAct = pfList.M2InDirectAct + (comp.M2_Indirect_Quantity__c!= null ? comp.M2_Indirect_Quantity__c :0);
                        pfList.M3InDirectAct = pfList.M3InDirectAct + (comp.M3_Indirect_Quantity__c!= null ? comp.M3_Indirect_Quantity__c :0);
                        pfList.M4InDirectAct = pfList.M4InDirectAct + (comp.M4_Indirect_Quantity__c!= null ? comp.M4_Indirect_Quantity__c :0);
                        pfList.M5InDirectAct = pfList.M5InDirectAct + (comp.M5_Indirect_Quantity__c!= null ? comp.M5_Indirect_Quantity__c :0);
                        pfList.M6InDirectAct = pfList.M6InDirectAct + (comp.M6_Indirect_Quantity__c!= null ? comp.M6_Indirect_Quantity__c :0);
                        pfList.M7InDirectAct = pfList.M7InDirectAct + (comp.M7_Indirect_Quantity__c!= null ? comp.M7_Indirect_Quantity__c :0);
                        pfList.M2InDirectAvg = pfList.M2InDirectAvg + (comp.M2_Indirect_Avg_Quantity__c!= null ? comp.M2_Indirect_Avg_Quantity__c :0);
                        pfList.M3InDirectAvg = pfList.M3InDirectAvg + (comp.M3_Indirect_Avg_Quantity__c!= null ? comp.M3_Indirect_Avg_Quantity__c :0);
                        pfList.M4InDirectAvg = pfList.M4InDirectAvg + (comp.M4_Indirect_Avg_Quantity__c!= null ? comp.M4_Indirect_Avg_Quantity__c :0);
                        pfList.M5InDirectAvg = pfList.M5InDirectAvg + (comp.M5_Indirect_Avg_Quantity__c!= null ? comp.M5_Indirect_Avg_Quantity__c :0);
                        pfList.M6InDirectAvg = pfList.M6InDirectAvg + (comp.M6_Indirect_Avg_Quantity__c!= null ? comp.M6_Indirect_Avg_Quantity__c :0);
                        pfList.M7InDirectAvg = pfList.M7InDirectAvg + (comp.M7_Indirect_Avg_Quantity__c!= null ? comp.M7_Indirect_Avg_Quantity__c :0);   
                        if(pfList.M7InDirectAct != 0 && pfList.M7InDirectAvg != 0){pfList.M7InDirectCompliance =  ((pfList.M7InDirectAct / pfList.M7InDirectAvg)*100).setScale(0);}
                        if(pfList.M6InDirectAct != 0 && pfList.M6InDirectAvg != 0){pfList.M6InDirectCompliance =  ((pfList.M6InDirectAct / pfList.M6InDirectAvg)*100).setScale(0);}
                        if(pfList.M5InDirectAct != 0 && pfList.M5InDirectAvg != 0){pfList.M5InDirectCompliance =  ((pfList.M5InDirectAct / pfList.M5InDirectAvg)*100).setScale(0);}
                        if(pfList.M4InDirectAct != 0 && pfList.M4InDirectAvg != 0){pfList.M4InDirectCompliance =  ((pfList.M4InDirectAct / pfList.M4InDirectAvg)*100).setScale(0);}
                        if(pfList.M3InDirectAct != 0 && pfList.M3InDirectAvg != 0){pfList.M3InDirectCompliance =  ((pfList.M3InDirectAct / pfList.M3InDirectAvg)*100).setScale(0);}
                        if(pfList.M2InDirectAct != 0 && pfList.M2InDirectAvg != 0){pfList.M2InDirectCompliance =  ((pfList.M2InDirectAct / pfList.M2InDirectAvg)*100).setScale(0);}
                    }
                    if(isTotal){
                        pfList.TotalAwardedQuantity = (pfList.TotalAwardedQuantity != null ? pfList.TotalAwardedQuantity : 0) + (comp.Total_Awarded_Information__c!= null ? comp.Total_Awarded_Information__c :0);
                        pfList.TotalAwardedQtyMonthly = pfList.TotalAwardedQtyMonthly + (comp.Total_Awarded_Information_Monthly__c != null ? comp.Total_Awarded_Information_Monthly__c :0);
                        pfList.M2TotalAct = pfList.M2TotalAct + (comp.M2_Total_Quantity__c!= null ? comp.M2_Total_Quantity__c :0);
                        pfList.M3TotalAct = pfList.M3TotalAct + (comp.M3_Total_Quantity__c!= null ? comp.M3_Total_Quantity__c :0);
                        pfList.M4TotalAct = pfList.M4TotalAct + (comp.M4_Total_Quantity__c!= null ? comp.M4_Total_Quantity__c :0);
                        pfList.M5TotalAct = pfList.M5TotalAct + (comp.M5_Total_Quantity__c!= null ? comp.M5_Total_Quantity__c :0);
                        pfList.M6TotalAct = pfList.M6TotalAct + (comp.M6_Total_Quantity__c!= null ? comp.M6_Total_Quantity__c :0);
                        pfList.M7TotalAct = pfList.M7TotalAct + (comp.M7_Total_Quantity__c!= null ? comp.M7_Total_Quantity__c :0);
                        pfList.M2TotalAvg = pfList.M2TotalAvg + (comp.M2_Total_Avg_Quantity__c!= null ? comp.M2_Total_Avg_Quantity__c :0);
                        pfList.M3TotalAvg = pfList.M3TotalAvg + (comp.M3_Total_Avg_Quantity__c!= null ? comp.M3_Total_Avg_Quantity__c :0);
                        pfList.M4TotalAvg = pfList.M4TotalAvg + (comp.M4_Total_Avg_Quantity__c!= null ? comp.M4_Total_Avg_Quantity__c :0);
                        pfList.M5TotalAvg = pfList.M5TotalAvg + (comp.M5_Total_Avg_Quantity__c!= null ? comp.M5_Total_Avg_Quantity__c :0);
                        pfList.M6TotalAvg = pfList.M6TotalAvg + (comp.M6_Total_Avg_Quantity__c!= null ? comp.M6_Total_Avg_Quantity__c :0);
                        pfList.M7TotalAvg = pfList.M7TotalAvg + (comp.M7_Total_Avg_Quantity__c!= null ? comp.M7_Total_Avg_Quantity__c :0);  
                        if(pfList.M7InDirectAct != 0 && pfList.M7InDirectAvg != 0){pfList.M7TotalCompliance = ((pfList.M7TotalAct / pfList.M7TotalAvg)*100).setScale(0);}
                        if(pfList.M7InDirectAct != 0 && pfList.M7InDirectAvg != 0){pfList.M6TotalCompliance = ((pfList.M6TotalAct / pfList.M6TotalAvg)*100).setScale(0);}
                        if(pfList.M7InDirectAct != 0 && pfList.M7InDirectAvg != 0){pfList.M5TotalCompliance = ((pfList.M5TotalAct / pfList.M5TotalAvg)*100).setScale(0);}
                        if(pfList.M7InDirectAct != 0 && pfList.M7InDirectAvg != 0){pfList.M4TotalCompliance = ((pfList.M4TotalAct / pfList.M4TotalAvg)*100).setScale(0);}
                        if(pfList.M7InDirectAct != 0 && pfList.M7InDirectAvg != 0){pfList.M3TotalCompliance = ((pfList.M3TotalAct / pfList.M3TotalAvg)*100).setScale(0);}
                        if(pfList.M7InDirectAct != 0 && pfList.M7InDirectAvg != 0){pfList.M2TotalCompliance = ((pfList.M2TotalAct / pfList.M2TotalAvg)*100).setScale(0);}
                    }
                }
                ProductFamilyWrapperList.add(pfList);
                
            }
        }
        if(complianceMonthList.size()>0){
            ///system.debug('rxComplianceList2'+ rxComplianceList);
            mainWrap.Month1 = complianceMonthList[0].Month2__c;    
            mainWrap.Month2 = complianceMonthList[0].Month3__c;    
            mainWrap.Month3 = complianceMonthList[0].Month4__c;    
            mainWrap.Month4 = complianceMonthList[0].Month5__c;    
            mainWrap.Month5 = complianceMonthList[0].Month6__c;    
            mainWrap.Month6 = complianceMonthList[0].Month7__c;    
        }
        
        mainWrap.noOfRecords = rxComplianceList.size();
        mainWrap.ProductFamilyWrapperList = ProductFamilyWrapperList;
        
        //  mainWrap.rxComplianceList = rxComplianceList;
        // ///system.debug('mainwrap-----'+mainwrap);
        
        return mainwrap;
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
        @AuraEnabled public List<Compliance_Summary__c> rxComplianceList;    
        @AuraEnabled public List<Decimal> totalrxComplianceList;    
        
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
        @AuraEnabled public Decimal IndirectAwardedQtyMonthly=0;
        @AuraEnabled public Decimal IndirectAwardedQuantity=0;
        @AuraEnabled public Decimal M1InDirectAct=0;
        @AuraEnabled public Decimal M2InDirectAct=0;
        @AuraEnabled public Decimal M3InDirectAct=0;
        @AuraEnabled public Decimal M4InDirectAct=0;
        @AuraEnabled public Decimal M5InDirectAct=0;
        @AuraEnabled public Decimal M6InDirectAct=0;
        @AuraEnabled public Decimal M7InDirectAct=0;
        @AuraEnabled public Decimal M1InDirectCompliance=0;
        @AuraEnabled public Decimal M2InDirectCompliance=0;
        @AuraEnabled public Decimal M3InDirectCompliance=0;
        @AuraEnabled public Decimal M4InDirectCompliance=0;
        @AuraEnabled public Decimal M5InDirectCompliance=0;
        @AuraEnabled public Decimal M6InDirectCompliance=0;
        @AuraEnabled public Decimal M7InDirectCompliance=0;
        @AuraEnabled public Decimal TotalAwardedQtyMonthly=0;
        @AuraEnabled public Decimal TotalAwardedQuantity=0;
        @AuraEnabled public Decimal M1TotalAct=0;
        @AuraEnabled public Decimal M2TotalAct=0;
        @AuraEnabled public Decimal M3TotalAct=0;
        @AuraEnabled public Decimal M4TotalAct=0;
        @AuraEnabled public Decimal M5TotalAct=0;
        @AuraEnabled public Decimal M6TotalAct=0;
        @AuraEnabled public Decimal M7TotalAct=0;
        @AuraEnabled public Decimal M1TotalCompliance=0;
        @AuraEnabled public Decimal M2TotalCompliance=0;
        @AuraEnabled public Decimal M3TotalCompliance=0;
        @AuraEnabled public Decimal M4TotalCompliance=0;
        @AuraEnabled public Decimal M5TotalCompliance=0;
        @AuraEnabled public Decimal M6TotalCompliance=0;
        @AuraEnabled public Decimal M7TotalCompliance=0;
        @AuraEnabled public Decimal M1DirectAvg=0;
        @AuraEnabled public Decimal M2DirectAvg=0;
        @AuraEnabled public Decimal M3DirectAvg=0;
        @AuraEnabled public Decimal M4DirectAvg=0;
        @AuraEnabled public Decimal M5DirectAvg=0;
        @AuraEnabled public Decimal M6DirectAvg=0;
        @AuraEnabled public Decimal M7DirectAvg=0;
        @AuraEnabled public Decimal M1InDirectAvg=0;
        @AuraEnabled public Decimal M2InDirectAvg=0;
        @AuraEnabled public Decimal M3InDirectAvg=0;
        @AuraEnabled public Decimal M4InDirectAvg=0;
        @AuraEnabled public Decimal M5InDirectAvg=0;
        @AuraEnabled public Decimal M6InDirectAvg=0;
        @AuraEnabled public Decimal M7InDirectAvg=0;
        @AuraEnabled public Decimal M1TotalAvg=0;
        @AuraEnabled public Decimal M2TotalAvg=0;
        @AuraEnabled public Decimal M3TotalAvg=0;
        @AuraEnabled public Decimal M4TotalAvg=0;
        @AuraEnabled public Decimal M5TotalAvg=0;
        @AuraEnabled public Decimal M6TotalAvg=0;
        @AuraEnabled public Decimal M7TotalAvg=0;
        
        @AuraEnabled public Decimal MTDDirectAct=0;
        @AuraEnabled public Decimal MTDDirectAwardedQty=0;
        @AuraEnabled public Decimal MTDDirectCompliance=0;
        @AuraEnabled public Decimal MTDIndirectAct=0;
        @AuraEnabled public Decimal MTDIndirectAwardedQty=0;
        @AuraEnabled public Decimal MTDIndirectCompliance=0;
        @AuraEnabled public Decimal MTDTotalAct=0;
        @AuraEnabled public Decimal MTDTotalAwardedQty=0;
        @AuraEnabled public Decimal MTDTotalCompliance=0;
        
        @AuraEnabled public Decimal QTDDirectAct=0;
        @AuraEnabled public Decimal QTDDirectAwardedQty=0;
        @AuraEnabled public Decimal QTDDirectCompliance=0;
        @AuraEnabled public Decimal QTDIndirectAct=0;
        @AuraEnabled public Decimal QTDIndirectAwardedQty=0;
        @AuraEnabled public Decimal QTDIndirectCompliance=0;
        @AuraEnabled public Decimal QTDTotalAct=0;
        @AuraEnabled public Decimal QTDTotalAwardedQty=0;
        @AuraEnabled public Decimal QTDTotalCompliance=0;
        
        @AuraEnabled public Decimal FTDDirectAct=0;
        @AuraEnabled public Decimal FTDDirectAwardedQty=0;
        @AuraEnabled public Decimal FTDDirectCompliance=0;
        @AuraEnabled public Decimal FTDIndirectAct=0;
        @AuraEnabled public Decimal FTDIndirectAwardedQty=0;
        @AuraEnabled public Decimal FTDIndirectCompliance=0;
        @AuraEnabled public Decimal FTDTotalAct=0;
        @AuraEnabled public Decimal FTDTotalAwardedQty=0;
        @AuraEnabled public Decimal FTDTotalCompliance=0;
        
        @AuraEnabled public Decimal CTDDirectAct=0;
        @AuraEnabled public Decimal CTDDirectAwardedQty=0;
        @AuraEnabled public Decimal CTDDirectCompliance=0;
        @AuraEnabled public Decimal CTDIndirectAct=0;
        @AuraEnabled public Decimal CTDIndirectAwardedQty=0;
        @AuraEnabled public Decimal CTDIndirectCompliance=0;
        @AuraEnabled public Decimal CTDTotalAct=0;
        @AuraEnabled public Decimal CTDTotalAwardedQty=0;
        @AuraEnabled public Decimal CTDTotalCompliance=0;
        @AuraEnabled public List<ProductFamilyWrapper> ProductFamilyWrapperList;
        // @AuraEnabled public Decimal =0;
        //    @AuraEnabled public List<GCP_SFDC_Direct_Sales__c> rxDirectComplianceList;  
        //   @AuraEnabled public List<GCP_SFDC_Indirect_Sales__c> rxIndirectComplianceList;    
        //  @AuraEnabled public List<ProductWrapper> ProductWrapperList;      
        MainWrapper(){
            //   ProductWrapperList = new List<ProductWrapper>();
            ProductFamilyWrapperList = new List<ProductFamilyWrapper>();
            rxComplianceList = new List<Compliance_Summary__c>();
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
        @AuraEnabled public List<Compliance_Summary__c> rxComplianceList;    
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
        @AuraEnabled public Decimal IndirectAwardedQtyMonthly=0;
        @AuraEnabled public Decimal IndirectAwardedQuantity=0;
        @AuraEnabled public Decimal M1InDirectAct=0;
        @AuraEnabled public Decimal M2InDirectAct=0;
        @AuraEnabled public Decimal M3InDirectAct=0;
        @AuraEnabled public Decimal M4InDirectAct=0;
        @AuraEnabled public Decimal M5InDirectAct=0;
        @AuraEnabled public Decimal M6InDirectAct=0;
        @AuraEnabled public Decimal M7InDirectAct=0;
        @AuraEnabled public Decimal M1InDirectCompliance=0;
        @AuraEnabled public Decimal M2InDirectCompliance=0;
        @AuraEnabled public Decimal M3InDirectCompliance=0;
        @AuraEnabled public Decimal M4InDirectCompliance=0;
        @AuraEnabled public Decimal M5InDirectCompliance=0;
        @AuraEnabled public Decimal M6InDirectCompliance=0;
        @AuraEnabled public Decimal M7InDirectCompliance=0;
        @AuraEnabled public Decimal TotalAwardedQtyMonthly=0;
        @AuraEnabled public Decimal TotalAwardedQuantity=0;
        @AuraEnabled public Decimal M1TotalAct=0;
        @AuraEnabled public Decimal M2TotalAct=0;
        @AuraEnabled public Decimal M3TotalAct=0;
        @AuraEnabled public Decimal M4TotalAct=0;
        @AuraEnabled public Decimal M5TotalAct=0;
        @AuraEnabled public Decimal M6TotalAct=0;
        @AuraEnabled public Decimal M7TotalAct=0;
        @AuraEnabled public Decimal M1TotalCompliance=0;
        @AuraEnabled public Decimal M2TotalCompliance=0;
        @AuraEnabled public Decimal M3TotalCompliance=0;
        @AuraEnabled public Decimal M4TotalCompliance=0;
        @AuraEnabled public Decimal M5TotalCompliance=0;
        @AuraEnabled public Decimal M6TotalCompliance=0;
        @AuraEnabled public Decimal M7TotalCompliance=0;
        @AuraEnabled public Decimal M1DirectAvg=0;
        @AuraEnabled public Decimal M2DirectAvg=0;
        @AuraEnabled public Decimal M3DirectAvg=0;
        @AuraEnabled public Decimal M4DirectAvg=0;
        @AuraEnabled public Decimal M5DirectAvg=0;
        @AuraEnabled public Decimal M6DirectAvg=0;
        @AuraEnabled public Decimal M7DirectAvg=0;
        @AuraEnabled public Decimal M1InDirectAvg=0;
        @AuraEnabled public Decimal M2InDirectAvg=0;
        @AuraEnabled public Decimal M3InDirectAvg=0;
        @AuraEnabled public Decimal M4InDirectAvg=0;
        @AuraEnabled public Decimal M5InDirectAvg=0;
        @AuraEnabled public Decimal M6InDirectAvg=0;
        @AuraEnabled public Decimal M7InDirectAvg=0;
        @AuraEnabled public Decimal M1TotalAvg=0;
        @AuraEnabled public Decimal M2TotalAvg=0;
        @AuraEnabled public Decimal M3TotalAvg=0;
        @AuraEnabled public Decimal M4TotalAvg=0;
        @AuraEnabled public Decimal M5TotalAvg=0;
        @AuraEnabled public Decimal M6TotalAvg=0;
        @AuraEnabled public Decimal M7TotalAvg=0;
        
        @AuraEnabled public Decimal MTDDirectAct=0;
        @AuraEnabled public Decimal MTDDirectAwardedQty=0;
        @AuraEnabled public Decimal MTDDirectCompliance=0;
        @AuraEnabled public Decimal MTDIndirectAct=0;
        @AuraEnabled public Decimal MTDIndirectAwardedQty=0;
        @AuraEnabled public Decimal MTDIndirectCompliance=0;
        @AuraEnabled public Decimal MTDTotalAct=0;
        @AuraEnabled public Decimal MTDTotalAwardedQty=0;
        @AuraEnabled public Decimal MTDTotalCompliance=0;
        
        @AuraEnabled public Boolean showProdFam;
        @AuraEnabled public Boolean expandCollapse;
        
        @AuraEnabled public Decimal QTDDirectAct=0;
        @AuraEnabled public Decimal QTDDirectAwardedQty=0;
        @AuraEnabled public Decimal QTDDirectCompliance=0;
        @AuraEnabled public Decimal QTDIndirectAct=0;
        @AuraEnabled public Decimal QTDIndirectAwardedQty=0;
        @AuraEnabled public Decimal QTDIndirectCompliance=0;
        @AuraEnabled public Decimal QTDTotalAct=0;
        @AuraEnabled public Decimal QTDTotalAwardedQty=0;
        @AuraEnabled public Decimal QTDTotalCompliance=0;
        
        @AuraEnabled public Decimal FTDDirectAct=0;
        @AuraEnabled public Decimal FTDDirectAwardedQty=0;
        @AuraEnabled public Decimal FTDDirectCompliance=0;
        @AuraEnabled public Decimal FTDIndirectAct=0;
        @AuraEnabled public Decimal FTDIndirectAwardedQty=0;
        @AuraEnabled public Decimal FTDIndirectCompliance=0;
        @AuraEnabled public Decimal FTDTotalAct=0;
        @AuraEnabled public Decimal FTDTotalAwardedQty=0;
        @AuraEnabled public Decimal FTDTotalCompliance=0;
        
        @AuraEnabled public Decimal CTDDirectAct=0;
        @AuraEnabled public Decimal CTDDirectAwardedQty=0;
        @AuraEnabled public Decimal CTDDirectCompliance=0;
        @AuraEnabled public Decimal CTDIndirectAct=0;
        @AuraEnabled public Decimal CTDIndirectAwardedQty=0;
        @AuraEnabled public Decimal CTDIndirectCompliance=0;
        @AuraEnabled public Decimal CTDTotalAct=0;
        @AuraEnabled public Decimal CTDTotalAwardedQty=0;
        @AuraEnabled public Decimal CTDTotalCompliance=0;
        
        ProductFamilyWrapper(){
            showProdFam = false;
            expandCollapse = false;
            rxComplianceList = new List<Compliance_Summary__c>();
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
                cmntWrapper cmntObj = new cmntWrapper(); cmntObj.userName = gcpCmntObj.Author__c; cmntObj.cmntDate = String.valueOf(gcpCmntObj.Comment_Date__c); cmntObj.cmntString = gcpCmntObj.Comment__c; cmntObj.profilePicUrl = '/docs/component-library/app/images/examples/avatar1.jpg'; cmntObj.gcpCmntObj = gcpCmntObj;
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
            for(Phoenix_Bid_Line_Item__c bidLineItemObj : bidLineItemList){   bidIds.add(bidLineItemObj.Phoenix_Bid__c);bidLineIds.add(bidLineItemObj.Id); 
            }
            List<Phoenix_Bid_Process_Steps__c> bidProcessSteps = new List<Phoenix_Bid_Process_Steps__c>();
            bidProcessSteps = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, 
                               Phoenix_Status__c, Phoenix_Approver_Team__c, LastModifiedDate, LastModifiedBy.Name, 
                               LastModifiedById, LastModifiedBy.SmallPhotoUrl 
                               FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c IN: bidIds order by Phoenix_Step__c];
            
            Map<String, list<Phoenix_Bid_Process_Steps__c>> processStepsByBid = new Map<String, list<Phoenix_Bid_Process_Steps__c>>();
            for(Phoenix_Bid_Process_Steps__c bpObj : bidProcessSteps){
                if(!processStepsByBid.containsKey(bpObj.Phoenix_Bid__c)) processStepsByBid.put(bpObj.Phoenix_Bid__c,new List<Phoenix_Bid_Process_Steps__c>());   processStepsByBid.get(bpObj.Phoenix_Bid__c).add(bpObj);
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
                           cmntWrapper cmntWrapObj = new cmntWrapper(); cmntWrapObj.userName = stepObj.LastModifiedBy.Name;  cmntWrapObj.userId = stepObj.LastModifiedById; cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate); cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Comments__c; cmntWrapObj.cmntAprvlStage = 'Sales'; cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl; cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                           cmntWrapObjList.add(cmntWrapObj);
                       }
                    if(bidLineItemObj.Phoenix_Initial_Stocking_Order_Comments__c !=  null 
                       && bidLineItemObj.Phoenix_Initial_Stocking_Order_Comments__c != ''
                       && bidStageMap.containsKey('Sales')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Sales');
                           cmntWrapper cmntWrapObj = new cmntWrapper(); cmntWrapObj.userName = stepObj.LastModifiedBy.Name; cmntWrapObj.userId = stepObj.LastModifiedById; cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate); cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Initial_Stocking_Order_Comments__c; cmntWrapObj.cmntAprvlStage = 'Initial Stocking Order'; cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl; cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c; cmntWrapObjList.add(cmntWrapObj);                         
                       }
                    if(bidLineItemObj.Phoenix_Marketing_Notes__c !=  null 
                       && bidLineItemObj.Phoenix_Marketing_Notes__c != ''
                       && bidStageMap.containsKey('Marketing')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Marketing');
                           cmntWrapper cmntWrapObj = new cmntWrapper();  cmntWrapObj.userName = stepObj.LastModifiedBy.Name; cmntWrapObj.userId = stepObj.LastModifiedById; cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate); cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Marketing_Notes__c; cmntWrapObj.cmntAprvlStage = 'Marketing'; cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl; cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                           cmntWrapObjList.add(cmntWrapObj);
                           
                       }
                    if(bidLineItemObj.Phoenix_SCM_Notes__c !=  null 
                       && bidLineItemObj.Phoenix_SCM_Notes__c != ''
                       && bidStageMap.containsKey('Supply Chain')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Supply Chain');
                           cmntWrapper cmntWrapObj = new cmntWrapper(); cmntWrapObj.userName = stepObj.LastModifiedBy.Name; cmntWrapObj.userId = stepObj.LastModifiedById; cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate); cmntWrapObj.cmntString = bidLineItemObj.Phoenix_SCM_Notes__c; cmntWrapObj.cmntAprvlStage = 'Supply Chain'; cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl; cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;  cmntWrapObjList.add(cmntWrapObj);
                           
                       }
                    if(bidLineItemObj.Phoenix_Finance_Comments__c !=  null 
                       && bidLineItemObj.Phoenix_Finance_Comments__c != ''
                       && bidStageMap.containsKey('Finance')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Finance');
                           cmntWrapper cmntWrapObj = new cmntWrapper();  cmntWrapObj.userName = stepObj.LastModifiedBy.Name;     cmntWrapObj.userId = stepObj.LastModifiedById;   cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate); cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Finance_Comments__c; cmntWrapObj.cmntAprvlStage = 'Finance';    cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;  cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;   cmntWrapObjList.add(cmntWrapObj);
                           
                       }
                    if(bidLineItemObj.Phoenix_Contract_Comments__c !=  null 
                       && bidLineItemObj.Phoenix_Contract_Comments__c != ''
                       && bidStageMap.containsKey('Contracts')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Contracts');
                           cmntWrapper cmntWrapObj = new cmntWrapper(); cmntWrapObj.userName = stepObj.LastModifiedBy.Name; cmntWrapObj.userId = stepObj.LastModifiedById;  cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate);  cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Contract_Comments__c;  cmntWrapObj.cmntAprvlStage = 'Contracts';  cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;  cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                           cmntWrapObjList.add(cmntWrapObj);
                           
                       }
                    if(bidLineItemObj.Phoenix_Vistex_Comments__c !=  null 
                       && bidLineItemObj.Phoenix_Vistex_Comments__c != ''
                       && bidStageMap.containsKey('Vistex')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Vistex');
                           cmntWrapper cmntWrapObj = new cmntWrapper(); cmntWrapObj.userName = stepObj.LastModifiedBy.Name;  cmntWrapObj.userId = stepObj.LastModifiedById;  cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate); cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Vistex_Comments__c;  cmntWrapObj.cmntAprvlStage = 'Vistex Update';  cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;  cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                           cmntWrapObjList.add(cmntWrapObj);
                       }
                    if(bidLineItemObj.Phoenix_Customer_Service_Comments__c !=  null && bidLineItemObj.Phoenix_Customer_Service_Comments__c != ''&& bidStageMap.containsKey('Customer Service')){
                        Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Customer Service');
                        cmntWrapper cmntWrapObj = new cmntWrapper();  cmntWrapObj.userName = stepObj.LastModifiedBy.Name;   cmntWrapObj.userId = stepObj.LastModifiedById;  cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate);  cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Customer_Service_Comments__c; cmntWrapObj.cmntAprvlStage = 'Customer Service';  cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;
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
    /*  @AuraEnabled
public static MainWrapper getComplianceData(String customerId){
MainWrapper mainWrap = new MainWrapper();
String query = '';
// String strFields = Phoenix_Util.rxExternalObjFields;
String SobjectApiName = 'Compliance_Summary__c';
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
query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from Compliance_Summary__c  WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and M2_Total_Value_Compliance__c < 75 order by Vision_Product__r.Name';
List < Compliance_Summary__c > rxComplianceList = Database.query(query);
///system.debug('rxComplianceList1'+ rxComplianceList);
List<Compliance_Summary__c> complianceMonthList=[SELECT Month1__c,Month2__c,Month3__c,Month4__c,Month5__c,Month6__c,Month7__c,Month8__c,Month9__c FROM Compliance_Summary__c where Month2__c !=null and Month3__c !=null and Month4__c !=null and Month5__c !=null and Month6__c !=null and Month7__c !=null Limit 1];



if(complianceMonthList.size()>0){
///system.debug('rxComplianceList2'+ rxComplianceList);
mainWrap.Month1 = complianceMonthList[0].Month2__c;    
mainWrap.Month2 = complianceMonthList[0].Month3__c;    
mainWrap.Month3 = complianceMonthList[0].Month4__c;    
mainWrap.Month4 = complianceMonthList[0].Month5__c;    
mainWrap.Month5 = complianceMonthList[0].Month6__c;    
mainWrap.Month6 = complianceMonthList[0].Month7__c;    
}

mainWrap.noOfRecords = rxComplianceList.size();  
mainWrap.rxComplianceList = rxComplianceList;
///system.debug('mainwrap-----'+mainwrap);

return mainwrap;
}*/
    /*  @AuraEnabled(cacheable=true) 
public static MainWrapper getAwardedPositionData(String customerId, string ProductCode){
MainWrapper mainWrap = new MainWrapper();
///system.debug('customerId---'+customerId);
///system.debug('ProductId---'+ProductCode);
List < Vision_Customer_Product_Tracker__c > awardedPositionList = [SELECT Vision_Account__c,Vision_Contract__r.Name,Vision_Current_Product_Position__c,Vision_Product__c,Vision_Product__r.Name,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode FROM Vision_Customer_Product_Tracker__c where Vision_Account__c =: customerId and Vision_Product__r.ProductCode =: ProductCode];
///system.debug('awardedPositionList---'+awardedPositionList.size());

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
///system.debug('customerId---'+customerId);
///system.debug('ProductId---'+ProductCode);
List < Vision_Customer_Product_Tracker__c > awardedPositionList = [SELECT Vision_Account__c,Vision_Contract__r.Name,Vision_Current_Product_Position__c,Vision_Product__c,Vision_Product__r.Name,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode FROM Vision_Customer_Product_Tracker__c where Vision_Account__c =: customerId and Vision_Product__r.ProductCode =: ProductCode AND Vision_Contract_Type__c = 'Direct'];
///system.debug('awardedPositionList---'+awardedPositionList.size());

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
///system.debug('customerId---'+customerId);
///system.debug('ProductId---'+ProductCode);
List < Vision_Customer_Product_Tracker__c > awardedPositionList = [SELECT Vision_Account__c,Vision_Contract__r.Name,Vision_Current_Product_Position__c,Vision_Product__c,Vision_Product__r.Name,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode FROM Vision_Customer_Product_Tracker__c where Vision_Account__c =: customerId and Vision_Product__r.ProductCode =: ProductCode AND Vision_Contract_Type__c = 'Indirect'];
///system.debug('awardedPositionList---'+awardedPositionList.size());

mainwrap.awardedPositionList = awardedPositionList;
if(awardedPositionList.size() > 0){
mainwrap.ProdName = awardedPositionList[0].Vision_Product__r.Name;
mainwrap.Ndc = awardedPositionList[0].Vision_Product__r.Phoenix_NDC_11__c; 

}
return mainwrap;
}*/
    /*  @AuraEnabled//(cacheable=true) 
public static MainWrapper getProductFamilyData(String customerId,Boolean showAll,Boolean showPrimary, Boolean isDirect, Boolean isIndirect, Boolean isTotal){
///system.debug('isDirect====='+isDirect);
///system.debug('showPrimary====='+showPrimary);
MainWrapper mainWrap = new MainWrapper();
String query = '';
String category = 'Primary';
// String strFields = Phoenix_Util.rxExternalObjFields;
String SobjectApiName = 'Compliance_Summary__c';
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
query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false';

if(isDirect){



if(!showAll ){
///system.debug('not show all');
if(!showPrimary ){
query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and General_Category__c =: category and M2_Direct_Qty_Compliance__c < 75 and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 order by Vision_Product__r.Name';   
}
else if(showPrimary ){
query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and M2_Direct_Qty_Compliance__c < 75 and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 order by Vision_Product__r.Name';   
} 
}
else if(showAll){
///system.debug('show all');
if(!showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 order by Vision_Product__r.Name';
}
else if(showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and  Vision_Product__r.Name != null and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 order by Vision_Product__r.Name';
}  
}
}
else if(isIndirect){


if(!showAll ){
///system.debug('indirect not show all');
if(!showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and M2_Indirect_Qty_Compliance__c < 75 and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 order by Vision_Product__r.Name';
}
else if(showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and M2_Indirect_Qty_Compliance__c < 75 and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 order by Vision_Product__r.Name';
}     
}
else if(showAll){
///system.debug('indirect show all');
if(!showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 order by Vision_Product__r.Name';
}
else if(showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 order by Vision_Product__r.Name';
}       
}
}
else if(isTotal){


if(!showAll ){
///system.debug('isTotal not show all');
if(!showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and M2_Total_Compliance__c < 75 and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Total_Awarded_Information__c > 0 order by Vision_Product__r.Name';
}
else if(showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and M2_Total_Compliance__c < 75 and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Total_Awarded_Information__c > 0 order by Vision_Product__r.Name';
}      
}
else if(showAll){
///system.debug('isTotal show all');
if(!showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Total_Awarded_Information__c > 0 order by Vision_Product__r.Name';
}
else if(showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Total_Awarded_Information__c > 0 order by Vision_Product__r.Name';
}       
}
}

List < Compliance_Summary__c > rxComplianceList = Database.query(query);
///system.debug('rxComplianceList'+ rxComplianceList.size());
if(rxComplianceList.size()>0){
for(Compliance_Summary__c comp : rxComplianceList){
if(isDirect){
// ///system.debug('mainWrap.DirectAwardedQuantity===='+mainWrap.DirectAwardedQuantity);
mainWrap.DirectAwardedQuantity = mainWrap.DirectAwardedQuantity + (comp.Awarded_Information__c != null ? comp.Awarded_Information__c:0);
mainWrap.DirectAwardedQtyMonthly = mainWrap.DirectAwardedQtyMonthly + (comp.Direct_Awarded_Quantity_Monthly__c != null ? comp.Direct_Awarded_Quantity_Monthly__c :0);
mainWrap.M2DirectAct = (mainWrap.M2DirectAct != null ? mainWrap.M2DirectAct : 0) + (comp.M2_Quantity__c!= null ? comp.M2_Quantity__c :0);
mainWrap.M3DirectAct = mainWrap.M3DirectAct + (comp.M3_Quantity__c!= null ? comp.M3_Quantity__c :0);
mainWrap.M4DirectAct = mainWrap.M4DirectAct + (comp.M4_Quantity__c!= null ? comp.M4_Quantity__c :0);
mainWrap.M5DirectAct = mainWrap.M5DirectAct + (comp.M5_Quantity__c!= null ? comp.M5_Quantity__c :0);
mainWrap.M6DirectAct = mainWrap.M6DirectAct + (comp.M6_Quantity__c!= null ? comp.M6_Quantity__c :0);
mainWrap.M7DirectAct = mainWrap.M7DirectAct + (comp.M7_Quantity__c!= null ? comp.M7_Quantity__c :0);
mainWrap.M2DirectAvg = mainWrap.M2DirectAvg + (comp.M2_Direct_Avg_Quantity__c!= null ? comp.M2_Direct_Avg_Quantity__c :0);
mainWrap.M3DirectAvg = mainWrap.M3DirectAvg + (comp.M3_Direct_Avg_Quantity__c!= null ? comp.M3_Direct_Avg_Quantity__c :0);
mainWrap.M4DirectAvg = mainWrap.M4DirectAvg + (comp.M4_Direct_Avg_Quantity__c!= null ? comp.M4_Direct_Avg_Quantity__c :0);
mainWrap.M5DirectAvg = mainWrap.M5DirectAvg + (comp.M5_Direct_Avg_Quantity__c!= null ? comp.M5_Direct_Avg_Quantity__c :0);
mainWrap.M6DirectAvg = mainWrap.M6DirectAvg + (comp.M6_Direct_Avg_Quantity__c!= null ? comp.M6_Direct_Avg_Quantity__c :0);
mainWrap.M7DirectAvg = mainWrap.M7DirectAvg + (comp.M7_Direct_Avg_Quantity__c!= null ? comp.M7_Direct_Avg_Quantity__c :0);
}
if(isIndirect){
mainWrap.IndirectAwardedQtyMonthly = mainWrap.IndirectAwardedQtyMonthly + (comp.Indirect_Awarded_Quantity_Monthly__c!= null ? comp.Indirect_Awarded_Quantity_Monthly__c :0);
mainWrap.IndirectAwardedQuantity = mainWrap.IndirectAwardedQuantity + (comp.Indirect_Awarded_Information__c!= null ? comp.Indirect_Awarded_Information__c :0);
mainWrap.M2InDirectAct = mainWrap.M2InDirectAct + (comp.M2_Indirect_Quantity__c!= null ? comp.M2_Indirect_Quantity__c :0);
mainWrap.M3InDirectAct = mainWrap.M3InDirectAct + (comp.M3_Indirect_Quantity__c!= null ? comp.M3_Indirect_Quantity__c :0);
mainWrap.M4InDirectAct = mainWrap.M4InDirectAct + (comp.M4_Indirect_Quantity__c!= null ? comp.M4_Indirect_Quantity__c :0);
mainWrap.M5InDirectAct = mainWrap.M5InDirectAct + (comp.M5_Indirect_Quantity__c!= null ? comp.M5_Indirect_Quantity__c :0);
mainWrap.M6InDirectAct = mainWrap.M6InDirectAct + (comp.M6_Indirect_Quantity__c!= null ? comp.M6_Indirect_Quantity__c :0);
mainWrap.M7InDirectAct = mainWrap.M7InDirectAct + (comp.M7_Indirect_Quantity__c!= null ? comp.M7_Indirect_Quantity__c :0);
mainWrap.M2InDirectAvg = mainWrap.M2InDirectAvg + (comp.M2_Indirect_Avg_Quantity__c!= null ? comp.M2_Indirect_Avg_Quantity__c :0);
mainWrap.M3InDirectAvg = mainWrap.M3InDirectAvg + (comp.M3_Indirect_Avg_Quantity__c!= null ? comp.M3_Indirect_Avg_Quantity__c :0);
mainWrap.M4InDirectAvg = mainWrap.M4InDirectAvg + (comp.M4_Indirect_Avg_Quantity__c!= null ? comp.M4_Indirect_Avg_Quantity__c :0);
mainWrap.M5InDirectAvg = mainWrap.M5InDirectAvg + (comp.M5_Indirect_Avg_Quantity__c!= null ? comp.M5_Indirect_Avg_Quantity__c :0);
mainWrap.M6InDirectAvg = mainWrap.M6InDirectAvg + (comp.M6_Indirect_Avg_Quantity__c!= null ? comp.M6_Indirect_Avg_Quantity__c :0);
mainWrap.M7InDirectAvg = mainWrap.M7InDirectAvg + (comp.M7_Indirect_Avg_Quantity__c!= null ? comp.M7_Indirect_Avg_Quantity__c :0);
}
if(isTotal){
mainWrap.TotalAwardedQuantity = (mainWrap.TotalAwardedQuantity != null ? mainWrap.TotalAwardedQuantity : 0) + (comp.Total_Awarded_Information__c!= null ? comp.Total_Awarded_Information__c :0);
mainWrap.TotalAwardedQtyMonthly = mainWrap.TotalAwardedQtyMonthly + (comp.Total_Awarded_Information_Monthly__c != null ? comp.Total_Awarded_Information_Monthly__c :0);
mainWrap.M2TotalAct = mainWrap.M2TotalAct + (comp.M2_Total_Quantity__c!= null ? comp.M2_Total_Quantity__c :0);
mainWrap.M3TotalAct = mainWrap.M3TotalAct + (comp.M3_Total_Quantity__c!= null ? comp.M3_Total_Quantity__c :0);
mainWrap.M4TotalAct = mainWrap.M4TotalAct + (comp.M4_Total_Quantity__c!= null ? comp.M4_Total_Quantity__c :0);
mainWrap.M5TotalAct = mainWrap.M5TotalAct + (comp.M5_Total_Quantity__c!= null ? comp.M5_Total_Quantity__c :0);
mainWrap.M6TotalAct = mainWrap.M6TotalAct + (comp.M6_Total_Quantity__c!= null ? comp.M6_Total_Quantity__c :0);
mainWrap.M7TotalAct = mainWrap.M7TotalAct + (comp.M7_Total_Quantity__c!= null ? comp.M7_Total_Quantity__c :0);
mainWrap.M2TotalAvg = mainWrap.M2TotalAvg + (comp.M2_Total_Avg_Quantity__c!= null ? comp.M2_Total_Avg_Quantity__c :0);
mainWrap.M3TotalAvg = mainWrap.M3TotalAvg + (comp.M3_Total_Avg_Quantity__c!= null ? comp.M3_Total_Avg_Quantity__c :0);
mainWrap.M4TotalAvg = mainWrap.M4TotalAvg + (comp.M4_Total_Avg_Quantity__c!= null ? comp.M4_Total_Avg_Quantity__c :0);
mainWrap.M5TotalAvg = mainWrap.M5TotalAvg + (comp.M5_Total_Avg_Quantity__c!= null ? comp.M5_Total_Avg_Quantity__c :0);
mainWrap.M6TotalAvg = mainWrap.M6TotalAvg + (comp.M6_Total_Avg_Quantity__c!= null ? comp.M6_Total_Avg_Quantity__c :0);
mainWrap.M7TotalAvg = mainWrap.M7TotalAvg + (comp.M7_Total_Avg_Quantity__c!= null ? comp.M7_Total_Avg_Quantity__c :0); 
}
}
}
List<Compliance_Summary__c> complianceMonthList=[SELECT Month1__c,Month2__c,Month3__c,Month4__c,Month5__c,Month6__c,Month7__c,Month8__c,Month9__c FROM Compliance_Summary__c where Month2__c !=null and Month3__c !=null and Month4__c !=null and Month5__c !=null and Month6__c !=null and Month7__c !=null Limit 1];
if(complianceMonthList.size()>0){
///system.debug('rxComplianceList2'+ rxComplianceList);
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
///system.debug('mainwrap-----'+mainwrap);

return mainwrap;
}
*/  
    /* public static MainWrapper getSearchResultAwardedQty(String customerId,Boolean showAll,Boolean showPrimary, Boolean isDirect, Boolean isIndirect, Boolean isTotal,String searchText){
///system.debug('searchText====='+searchText);
///system.debug('showPrimary====='+showPrimary);
MainWrapper mainWrap = new MainWrapper();
String query = '';
String category = 'Primary';
// String strFields = Phoenix_Util.rxExternalObjFields;
String SobjectApiName = 'Compliance_Summary__c';
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
query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false';

if(isDirect){
if(searchText != null && searchText !='') {
searchText = '%'+searchText+'%';
if(!showAll ){
///system.debug('not show all');
if(!showPrimary ){
query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and General_Category__c =: category and M2_Direct_Qty_Compliance__c < 75 and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';   
}
else if(showPrimary ){
query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and M2_Direct_Qty_Compliance__c < 75 and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';   
} 
}
else if(showAll){
///system.debug('show all');
if(!showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';   
}
else if(showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and  Vision_Product__r.Name != null and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';   
}  
}

}
else{
if(!showAll ){
///system.debug('not show all');
if(!showPrimary ){
query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and General_Category__c =: category and M2_Direct_Qty_Compliance__c < 75 and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 order by Vision_Product__r.Name';   
}
else if(showPrimary ){
query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and M2_Direct_Qty_Compliance__c < 75 and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 order by Vision_Product__r.Name';   
} 
}
else if(showAll){
///system.debug('show all');
if(!showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 order by Vision_Product__r.Name';
}
else if(showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and  Vision_Product__r.Name != null and Is_Direct__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Awarded_Information__c > 0 order by Vision_Product__r.Name';
}  
}

}



}
else if(isIndirect){

if(searchText != null && searchText !='') {
searchText = '%'+searchText+'%'; 
if(!showAll ){
///system.debug('indirect not show all');
if(!showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and M2_Indirect_Qty_Compliance__c < 75 and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';   
}
else if(showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and M2_Indirect_Qty_Compliance__c < 75 and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';   
}     
}
else if(showAll){
///system.debug('indirect show all');
if(!showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';   
}
else if(showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';   
}       
}
}
else{
if(!showAll ){
///system.debug('indirect not show all');
if(!showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and M2_Indirect_Qty_Compliance__c < 75 and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 order by Vision_Product__r.Name';
}
else if(showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and M2_Indirect_Qty_Compliance__c < 75 and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 order by Vision_Product__r.Name';
}     
}
else if(showAll){
///system.debug('indirect show all');
if(!showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 order by Vision_Product__r.Name';
}
else if(showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Is_Indirect__c = true and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Indirect_Awarded_Information__c > 0 order by Vision_Product__r.Name';
}       
}   
}
}
else if(isTotal){
if(searchText != null && searchText !='') {
searchText = '%'+searchText+'%';      

if(!showAll ){
///system.debug('isTotal not show all');
if(!showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and M2_Total_Compliance__c < 75 and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Total_Awarded_Information__c > 0 and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';   
}
else if(showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and M2_Total_Compliance__c < 75 and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Total_Awarded_Information__c > 0 and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';   
}      
}
else if(showAll){
///system.debug('isTotal show all');
if(!showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Total_Awarded_Information__c > 0 and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';   
}
else if(showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Total_Awarded_Information__c > 0 and (Vision_Product__r.Name like: searchText or Vision_Product__r.ProductCode like: searchText or Vision_Product__r.Phoenix_NDC_11__c like: searchText) order by Vision_Product__r.Name';   
}       
}
}
else{
if(!showAll ){
///system.debug('isTotal not show all');
if(!showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and M2_Total_Compliance__c < 75 and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Total_Awarded_Information__c > 0 order by Vision_Product__r.Name';
}
else if(showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and M2_Total_Compliance__c < 75 and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Total_Awarded_Information__c > 0 order by Vision_Product__r.Name';
}      
}
else if(showAll){
///system.debug('isTotal show all');
if(!showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and General_Category__c =: category and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Total_Awarded_Information__c > 0 order by Vision_Product__r.Name';
}
else if(showPrimary ){
query = 'select Vision_Product__r.Name,Backorder_SRx_Rx__r.Vision_MoH__c,GCP_Backorder_OTC__r.Vision_Backorder_Qty__c,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Vision_Product__r.IsActive = true and Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false and Total_Awarded_Information__c > 0 order by Vision_Product__r.Name';
}       
}   
}
}

List < Compliance_Summary__c > rxComplianceList = Database.query(query);
///system.debug('rxComplianceList'+ rxComplianceList.size());
if(rxComplianceList.size()>0){
for(Compliance_Summary__c comp : rxComplianceList){
if(isDirect){
// ///system.debug('mainWrap.DirectAwardedQuantity===='+mainWrap.DirectAwardedQuantity);
mainWrap.DirectAwardedQuantity = mainWrap.DirectAwardedQuantity + (comp.Awarded_Information__c != null ? comp.Awarded_Information__c:0);
mainWrap.DirectAwardedQtyMonthly = mainWrap.DirectAwardedQtyMonthly + (comp.Direct_Awarded_Quantity_Monthly__c != null ? comp.Direct_Awarded_Quantity_Monthly__c :0);
mainWrap.M2DirectAct = (mainWrap.M2DirectAct != null ? mainWrap.M2DirectAct : 0) + (comp.M2_Quantity__c!= null ? comp.M2_Quantity__c :0);
mainWrap.M3DirectAct = mainWrap.M3DirectAct + (comp.M3_Quantity__c!= null ? comp.M3_Quantity__c :0);
mainWrap.M4DirectAct = mainWrap.M4DirectAct + (comp.M4_Quantity__c!= null ? comp.M4_Quantity__c :0);
mainWrap.M5DirectAct = mainWrap.M5DirectAct + (comp.M5_Quantity__c!= null ? comp.M5_Quantity__c :0);
mainWrap.M6DirectAct = mainWrap.M6DirectAct + (comp.M6_Quantity__c!= null ? comp.M6_Quantity__c :0);
mainWrap.M7DirectAct = mainWrap.M7DirectAct + (comp.M7_Quantity__c!= null ? comp.M7_Quantity__c :0);
mainWrap.M2DirectAvg = mainWrap.M2DirectAvg + (comp.M2_Direct_Avg_Quantity__c!= null ? comp.M2_Direct_Avg_Quantity__c :0);
mainWrap.M3DirectAvg = mainWrap.M3DirectAvg + (comp.M3_Direct_Avg_Quantity__c!= null ? comp.M3_Direct_Avg_Quantity__c :0);
mainWrap.M4DirectAvg = mainWrap.M4DirectAvg + (comp.M4_Direct_Avg_Quantity__c!= null ? comp.M4_Direct_Avg_Quantity__c :0);
mainWrap.M5DirectAvg = mainWrap.M5DirectAvg + (comp.M5_Direct_Avg_Quantity__c!= null ? comp.M5_Direct_Avg_Quantity__c :0);
mainWrap.M6DirectAvg = mainWrap.M6DirectAvg + (comp.M6_Direct_Avg_Quantity__c!= null ? comp.M6_Direct_Avg_Quantity__c :0);
mainWrap.M7DirectAvg = mainWrap.M7DirectAvg + (comp.M7_Direct_Avg_Quantity__c!= null ? comp.M7_Direct_Avg_Quantity__c :0);
}
if(isIndirect){
mainWrap.IndirectAwardedQtyMonthly = mainWrap.IndirectAwardedQtyMonthly + (comp.Indirect_Awarded_Quantity_Monthly__c!= null ? comp.Indirect_Awarded_Quantity_Monthly__c :0);
mainWrap.IndirectAwardedQuantity = mainWrap.IndirectAwardedQuantity + (comp.Indirect_Awarded_Information__c!= null ? comp.Indirect_Awarded_Information__c :0);
mainWrap.M2InDirectAct = mainWrap.M2InDirectAct + (comp.M2_Indirect_Quantity__c!= null ? comp.M2_Indirect_Quantity__c :0);
mainWrap.M3InDirectAct = mainWrap.M3InDirectAct + (comp.M3_Indirect_Quantity__c!= null ? comp.M3_Indirect_Quantity__c :0);
mainWrap.M4InDirectAct = mainWrap.M4InDirectAct + (comp.M4_Indirect_Quantity__c!= null ? comp.M4_Indirect_Quantity__c :0);
mainWrap.M5InDirectAct = mainWrap.M5InDirectAct + (comp.M5_Indirect_Quantity__c!= null ? comp.M5_Indirect_Quantity__c :0);
mainWrap.M6InDirectAct = mainWrap.M6InDirectAct + (comp.M6_Indirect_Quantity__c!= null ? comp.M6_Indirect_Quantity__c :0);
mainWrap.M7InDirectAct = mainWrap.M7InDirectAct + (comp.M7_Indirect_Quantity__c!= null ? comp.M7_Indirect_Quantity__c :0);
mainWrap.M2InDirectAvg = mainWrap.M2InDirectAvg + (comp.M2_Indirect_Avg_Quantity__c!= null ? comp.M2_Indirect_Avg_Quantity__c :0);
mainWrap.M3InDirectAvg = mainWrap.M3InDirectAvg + (comp.M3_Indirect_Avg_Quantity__c!= null ? comp.M3_Indirect_Avg_Quantity__c :0);
mainWrap.M4InDirectAvg = mainWrap.M4InDirectAvg + (comp.M4_Indirect_Avg_Quantity__c!= null ? comp.M4_Indirect_Avg_Quantity__c :0);
mainWrap.M5InDirectAvg = mainWrap.M5InDirectAvg + (comp.M5_Indirect_Avg_Quantity__c!= null ? comp.M5_Indirect_Avg_Quantity__c :0);
mainWrap.M6InDirectAvg = mainWrap.M6InDirectAvg + (comp.M6_Indirect_Avg_Quantity__c!= null ? comp.M6_Indirect_Avg_Quantity__c :0);
mainWrap.M7InDirectAvg = mainWrap.M7InDirectAvg + (comp.M7_Indirect_Avg_Quantity__c!= null ? comp.M7_Indirect_Avg_Quantity__c :0);
}
if(isTotal){
mainWrap.TotalAwardedQuantity = (mainWrap.TotalAwardedQuantity != null ? mainWrap.TotalAwardedQuantity : 0) + (comp.Total_Awarded_Information__c!= null ? comp.Total_Awarded_Information__c :0);
mainWrap.TotalAwardedQtyMonthly = mainWrap.TotalAwardedQtyMonthly + (comp.Total_Awarded_Information_Monthly__c != null ? comp.Total_Awarded_Information_Monthly__c :0);
mainWrap.M2TotalAct = mainWrap.M2TotalAct + (comp.M2_Total_Quantity__c!= null ? comp.M2_Total_Quantity__c :0);
mainWrap.M3TotalAct = mainWrap.M3TotalAct + (comp.M3_Total_Quantity__c!= null ? comp.M3_Total_Quantity__c :0);
mainWrap.M4TotalAct = mainWrap.M4TotalAct + (comp.M4_Total_Quantity__c!= null ? comp.M4_Total_Quantity__c :0);
mainWrap.M5TotalAct = mainWrap.M5TotalAct + (comp.M5_Total_Quantity__c!= null ? comp.M5_Total_Quantity__c :0);
mainWrap.M6TotalAct = mainWrap.M6TotalAct + (comp.M6_Total_Quantity__c!= null ? comp.M6_Total_Quantity__c :0);
mainWrap.M7TotalAct = mainWrap.M7TotalAct + (comp.M7_Total_Quantity__c!= null ? comp.M7_Total_Quantity__c :0);
mainWrap.M2TotalAvg = mainWrap.M2TotalAvg + (comp.M2_Total_Avg_Quantity__c!= null ? comp.M2_Total_Avg_Quantity__c :0);
mainWrap.M3TotalAvg = mainWrap.M3TotalAvg + (comp.M3_Total_Avg_Quantity__c!= null ? comp.M3_Total_Avg_Quantity__c :0);
mainWrap.M4TotalAvg = mainWrap.M4TotalAvg + (comp.M4_Total_Avg_Quantity__c!= null ? comp.M4_Total_Avg_Quantity__c :0);
mainWrap.M5TotalAvg = mainWrap.M5TotalAvg + (comp.M5_Total_Avg_Quantity__c!= null ? comp.M5_Total_Avg_Quantity__c :0);
mainWrap.M6TotalAvg = mainWrap.M6TotalAvg + (comp.M6_Total_Avg_Quantity__c!= null ? comp.M6_Total_Avg_Quantity__c :0);
mainWrap.M7TotalAvg = mainWrap.M7TotalAvg + (comp.M7_Total_Avg_Quantity__c!= null ? comp.M7_Total_Avg_Quantity__c :0); 
}
}
}
List<Compliance_Summary__c> complianceMonthList=[SELECT Month1__c,Month2__c,Month3__c,Month4__c,Month5__c,Month6__c,Month7__c,Month8__c,Month9__c FROM Compliance_Summary__c where Month2__c !=null and Month3__c !=null and Month4__c !=null and Month5__c !=null and Month6__c !=null and Month7__c !=null Limit 1];
if(complianceMonthList.size()>0){
///system.debug('rxComplianceList2'+ rxComplianceList);
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
///system.debug('mainwrap-----'+mainwrap);

return mainwrap;
}
*/ 
    /*  @AuraEnabled(cacheable=true) 
public static MainWrapper awardedfetchSortResults(string sortField,boolean isAsc,List< Compliance_Summary__c >  productList,String customerId,Boolean showAll,Boolean isQuantityValue){
set < Id > prodIds = new set < Id > ();
///system.debug('productList>>>'+productList);
MainWrapper mainWrap = new MainWrapper();

String query = '';
// String strFields = Phoenix_Util.rxExternalObjFields;
String SobjectApiName = 'Compliance_Summary__c';
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

List < Compliance_Summary__c > wrlist = new List < Compliance_Summary__c > ();
//  String SobjectApiName = 'Compliance_Summary__c';
//   Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
//   Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();



for (Compliance_Summary__c w: productList) {
///system.debug('Product:: '+w);
prodIds.add(w.Id);

}

///system.debug('prodIds'+ prodIds.size());
///system.debug('prodIds'+ prodIds);

for (String fieldName: fieldMap.keyset()) {
if (strFields == null || strFields == '') {
strFields = fieldName;
} else {
strFields = strFields + ' , ' + fieldName;
}
}

if(showAll){

query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Id=:prodIds ';

}
else{
if(isQuantityValue){
query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and M2_Total_Value_Compliance__c < 75 and Id=:prodIds ';

} 
else{
query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and M2_Total_Compliance__c < 75 and Id=:prodIds ';

}


}

if (sortField != null && sortField != '') {
///system.debug('sort');
query += ' order by ' + sortField;

if (isAsc) {
///system.debug('asc');
query += ' ASC NULLS LAST';
} else {
///system.debug('asc else');
query += ' DESC NULLS LAST';
}

}
///system.debug('query-----'+query);
List < Compliance_Summary__c > rxComplianceList = Database.query(query);
///system.debug('rxComplianceList4'+ rxComplianceList);

for (Compliance_Summary__c pr: rxComplianceList) {
for (Compliance_Summary__c wr: productList) {
if (wr.Id == pr.Id) {
wrlist.add(wr);

}
}
}
mainWrap.noOfRecords = rxComplianceList.size();  
mainWrap.rxComplianceList = rxComplianceList;
///system.debug('mainwrap-----'+mainwrap);

return mainwrap;
} 
@AuraEnabled(cacheable=true) 
public static MainWrapper historcialfetchSortResults(string sortField,boolean isAsc,List< Compliance_Summary__c >  productList,String customerId,Boolean showAll,Boolean isQuantityValue){
set < Id > prodIds = new set < Id > ();
///system.debug('productList>>>'+productList);
MainWrapper mainWrap = new MainWrapper();

String query = '';
// String strFields = Phoenix_Util.rxExternalObjFields;
String SobjectApiName = 'Compliance_Summary__c';
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
List < Compliance_Summary__c > wrlist = new List < Compliance_Summary__c > ();
//    String SobjectApiName = 'Compliance_Summary__c';
//  Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe(); 
//   Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();


for (Compliance_Summary__c w: productList) {
///system.debug('Product:: '+w);
prodIds.add(w.Id);

}

///system.debug('prodIds'+ prodIds.size());
///system.debug('prodIds'+ prodIds);

for (String fieldName: fieldMap.keyset()) {
if (strFields == null || strFields == '') {
strFields = fieldName;
} else {
strFields = strFields + ' , ' + fieldName;
}
}

if(showAll){

query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and Id=:prodIds';

}
else{
if(isQuantityValue){
query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and M1_Total_Avg_Sales_Compliance__c < 75 and Id=:prodIds';

} 
else{
query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_Pkg_Size__c,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode, '+strFields+' from Compliance_Summary__c WHERE Vision_Customer__c =:customerId and Vision_Product__r.Name != null and M2_Total_Avg_Qty_Compliance__c < 75 and Id=:prodIds';

}


}

if (sortField != null && sortField != '') {
///system.debug('sort');
query += ' order by ' + sortField;

if (isAsc) {
///system.debug('asc');
query += ' ASC NULLS LAST';
} else {
///system.debug('asc else');
query += ' DESC NULLS LAST';
}

}
///system.debug('query-----'+query);
List < Compliance_Summary__c > rxComplianceList = Database.query(query);
///system.debug('rxComplianceList4'+ rxComplianceList);

List<Compliance_Summary__c> complianceMonthList=[SELECT Month1__c,Month2__c,Month3__c,Month4__c,Month5__c,Month6__c,Month7__c,Month8__c,Month9__c FROM Compliance_Summary__c where Month2__c !=null and Month3__c !=null and Month4__c !=null and Month5__c !=null and Month6__c !=null and Month7__c !=null Limit 1];



if(complianceMonthList.size()>0){
///system.debug('rxComplianceList2'+ rxComplianceList);
mainWrap.Month1 = complianceMonthList[0].Month2__c;    
mainWrap.Month2 = complianceMonthList[0].Month3__c;    
mainWrap.Month3 = complianceMonthList[0].Month4__c;    
mainWrap.Month4 = complianceMonthList[0].Month5__c;    
mainWrap.Month5 = complianceMonthList[0].Month6__c;    
mainWrap.Month6 = complianceMonthList[0].Month7__c;    
}

///system.debug('Month1-->'+ complianceMonthList[0].Month2__c);
for (Compliance_Summary__c pr: rxComplianceList) {
for (Compliance_Summary__c wr: productList) {
if (wr.Id == pr.Id) {
wrlist.add(wr);

}
}
}
mainWrap.noOfRecords = rxComplianceList.size();  
mainWrap.rxComplianceList = rxComplianceList;
///system.debug('mainwrap-----'+mainwrap);

return mainwrap;
} 
*/
    
/*public static void codeCoverage(){
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
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
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
        
        
    } */
}