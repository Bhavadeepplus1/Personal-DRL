public class Vision_SendToBrightCtrl {
    
    @future
    public static void syncUnitsToAnalysis(String optyProdIds){
        try{
            /*List<String> lineIds = optyLineIds.split(',');
            String query = 'SELECT Product__r.Name, Product__r.Product_Family__c, Opportunity__r.AccountId, '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c WHERE Id IN: lineIds';
            List<Product_Opportunity__c> optyLineList = Database.query(query);
            Map<String, Integer> prodFamTotalunits = new Map<String, Integer>();
            map<string, Integer> prodToalUnitsMap = new Map<String, Integer>();
            List<String> prodFamIds = new List<String>();
            for(Product_Opportunity__c prd: optyLineList){
                prd.Vision_Total_Annual_Units__c = prd.Proposed_Direct_Selling_Units__c+prd.Proposed_Indirect_Selling_Units__c+prd.Vision_Proposed_OS_Units__c+prd.Vision_Proposed_RAD_Units__c+prd.Vision_Proposed_WMT_Units__c
                    +prd.Vision_Proposed_BASE_Units__c+prd.Vision_Proposed_DSH_Units__c+prd.Vision_Proposed_AutoSub_Units__c+prd.Vision_Proposed_Smith_Drug_Units__c+prd.Vision_Proposed_Anda_Units__c
                    +prd.Vision_Proposed_DirectAholdDelhaizeUnits__c+prd.Vision_Proposed_Direct_Gaint_Eagle_Units__c+prd.Vision_Proposed_TotalRetailIndirectUnits__c+prd.Vision_Proposed_Direct_ESI_Units__c
                    +prd.Vision_Proposed_Indirect_ESI_Units__c+prd.Vision_Proposed_Direct_Kroger_Units__c+prd.Vision_Proposed_Indirect_Kroger_Units__c+prd.Vision_Proposed_Direct_Rx_Outreach_Units__c
                    +prd.Vision_Proposed_IndirectRxOutreach_Units__c+prd.Vision_Proposed_Direct_Supervalu_Units__c+prd.Vision_Proposed_Indirect_Supervalu_Units__c+prd.Vision_Proposed_Direct_Cordant_Units__c
                    +prd.Vision_Proposed_Indirect_Cordant_Units__c+prd.Vision_Proposed_Direct_Accerodo_Units__c+prd.Vision_Proposed_Indirect_Accerodo_Units__c+prd.Vision_Proposed_CVS_Direct_Units__c
                    +prd.Vision_Proposed_CVS_Indirect_Units__c+prd.Vision_Proposed_Cardinal_Units__c+prd.Vision_Proposed_Major_Units__c+prd.Vision_Proposed_Indirect_Cigna_Units__c+prd.Vision_Proposed_Direct_Cigna_Units__c;
                prodToalUnitsMap.put(prd.Product__c,Integer.valueOf(prd.Vision_Total_Annual_Units__c));
                if(prd.Product__r.Product_Family__c != null){
                    String famId = prd.Product__r.Product_Family__c;
                    if(!prodFamIds.contains(famId))
                        prodFamIds.add(famId);
                    if(prodFamTotalunits.containsKey(famId)){
                        Integer totalUnits = prodFamTotalunits.get(famId);
                        prodFamTotalunits.put(famId, Integer.valueOf(totalUnits+prd.Vision_Total_Annual_Units__c));
                    }
                    else
                        prodFamTotalunits.put(famId, Integer.valueOf(prd.Vision_Total_Annual_Units__c));
                }
            }
            String accId = optyLineList[0].Opportunity__r.AccountId;
            List<Phoenix_GCP_Opportunity_Tracker__c> gcpList = [SELECT Id, Vision_isRelevance__c, Vision_Inline_RFP_Units__c, Product_Family__c, Phoenix_Est_Acct_Vol_Method__c FROM Phoenix_GCP_Opportunity_Tracker__c WHERE Phoenix_Customer__c =: accId AND Product_Family__c =: prodFamIds];
            for(Phoenix_GCP_Opportunity_Tracker__c gcpObj:gcpList){
                if(prodFamTotalunits.containsKey(gcpObj.Product_Family__c)){
                    gcpObj.Vision_Inline_RFP_Units__c = prodFamTotalunits.get(gcpObj.Product_Family__c);
                    gcpObj.Vision_isRelevance__c = true;
                    gcpObj.Phoenix_Est_Acct_Vol_Method__c = 'Use Proposed Total Selling Units (BRIGHT)';
                }
            }
            update gcpList;*/
            
            List<String> lineIds = optyProdIds.split(',');
            
            Map<String, Integer> prodFamTotalunits = new Map<String, Integer>();
            List<String> prodFamIds = new List<String>();
            Map<String, Integer> prodTotalUnitsMap = new Map<String, Integer>();
            List<Product_Opportunity__c> optyProdList = Database.query('SELECT Product__r.Product_Family__r.Name, Product__r.Product_Family__c, '+ Phoenix_Util.getsObjectFieds('Product_Opportunity__c') +' FROM Product_Opportunity__c WHERE Id IN: lineIds');
            Opportunity oppObj = [SELECT Id, AccountId FROM Opportunity WHERE Id=:optyProdList[0].Opportunity__c];
            String accId = oppObj.AccountId;
            Account acc = [SELECT Id, Name FROM Account WHERE Id =: accId];
            for(Product_Opportunity__c prd:optyProdList){
                prodFamIds.add(prd.Product__r.Product_Family__c);
                if(!acc.Name.contains('OTC Private Label')){
                    prd.Vision_Total_Annual_Units__c = prd.Proposed_Direct_Selling_Units__c+prd.Proposed_Indirect_Selling_Units__c+prd.Vision_Proposed_OS_Units__c+prd.Vision_Proposed_RAD_Units__c+prd.Vision_Proposed_WMT_Units__c
                        +prd.Vision_Proposed_BASE_Units__c+prd.Vision_Proposed_DSH_Units__c+prd.Vision_Proposed_AutoSub_Units__c+prd.Vision_Proposed_Smith_Drug_Units__c+prd.Vision_Proposed_Anda_Units__c
                        +prd.Vision_Proposed_DirectAholdDelhaizeUnits__c+prd.Vision_Proposed_Direct_Gaint_Eagle_Units__c+prd.Vision_Proposed_TotalRetailIndirectUnits__c+prd.Vision_Proposed_Direct_ESI_Units__c
                        +prd.Vision_Proposed_Indirect_ESI_Units__c+prd.Vision_Proposed_Direct_Kroger_Units__c+prd.Vision_Proposed_Indirect_Kroger_Units__c+prd.Vision_Proposed_Direct_Rx_Outreach_Units__c
                        +prd.Vision_Proposed_IndirectRxOutreach_Units__c+prd.Vision_Proposed_Direct_Supervalu_Units__c+prd.Vision_Proposed_Indirect_Supervalu_Units__c+prd.Vision_Proposed_Direct_Cordant_Units__c
                        +prd.Vision_Proposed_Indirect_Cordant_Units__c+prd.Vision_Proposed_Direct_Accerodo_Units__c+prd.Vision_Proposed_Indirect_Accerodo_Units__c+prd.Vision_Proposed_CVS_Direct_Units__c
                        +prd.Vision_Proposed_CVS_Indirect_Units__c+prd.Vision_Proposed_Cardinal_Units__c+prd.Vision_Proposed_Major_Units__c+prd.Vision_Proposed_Indirect_Cigna_Units__c+prd.Vision_Proposed_Direct_Cigna_Units__c;
                }
                else
                    prd.Vision_Total_Annual_Units__c = prd.Vision_Proposed_Units__c * (prd.Vision_Proposed_Share_Percentage__c/100);
                prodTotalUnitsMap.put(prd.Product__c,Integer.valueOf(prd.Vision_Total_Annual_Units__c));
            }
            
            String childQuery = 'SELECT Vision_Customer__r.Name, Vision_Customer__r.Vision_is_SRx_Account__c,Vision_Product__r.Product_Family__c, Vision_Product__r.Id,Vision_Product__r.Name, Vision_Product__r.Phoenix_NDC_11__c, Vision_Product__r.isActive,Vision_Product__r.Phoenix_Pkg_Size__c, '+
                +' Vision_Customer__r.Phoenix_Account_Cooling_Period__c, '+Phoenix_Util.getsObjectFieds('GCP_SFDC_100pct_Analysis_SKU__c')+' FROM GCP_SFDC_100pct_Analysis_SKU__c'+
                +' WHERE Vision_Customer__c =: accId AND Vision_Product__r.Product_Family__c IN: prodFamIds AND Vision_Product__c != null AND Vision_Product__r.isActive = true '+
                +' AND (Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = false OR (Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = true AND Vision_Product__r.OTC_Customer__c = : accId AND Vision_Product__r.Phoenix_Is_Control_Label__c = false))'+
                +' AND Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false ORDER BY Vision_Product__r.Name';//GCP_Product_Family__c =: prodFamilyName/Product_Family__c =: famId( OR 
            List<GCP_SFDC_100pct_Analysis_SKU__c> gcpNdcList = Database.query(childQuery);
            List<GCP_SFDC_100pct_Analysis_SKU__c> updateList = new List<GCP_SFDC_100pct_Analysis_SKU__c>();
            
            List<Id> prodIds = new List<Id>();
            for(GCP_SFDC_100pct_Analysis_SKU__c ndcObj : gcpNdcList){
                if(prodTotalUnitsMap.containsKey(ndcObj.Vision_Product__c))
                    ndcObj.Vision_Estimate_Account_Total_Vol_EU__c = prodTotalUnitsMap.get(ndcObj.Vision_Product__c);
                prodIds.add(ndcObj.Vision_Product__c);
                updateList.add(ndcObj);
            }
            update updateList;
            
            String query = 'SELECT Vision_Product__r.Product_Family__c, '+Phoenix_Util.getsObjectFieds('GCP_100PCT_Analysis_SKU__c')+' FROM GCP_100PCT_Analysis_SKU__c WHERE Vision_Product__r.Product_Family__c IN: prodFamIds '+//GCP_Product_Family__c =: prodFamilyName '+
                +' AND (Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = false OR (Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = true AND Vision_Product__r.OTC_Customer__c = : accId AND Vision_Product__r.Phoenix_Is_Control_Label__c = false))'+
                +' AND Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false  AND Vision_Product__r.isActive = true';
            List<GCP_100PCT_Analysis_SKU__c> uniqList = Database.query(query);
            List<GCP_SFDC_100pct_Analysis_SKU__c> newSkuList = new List<GCP_SFDC_100pct_Analysis_SKU__c>();
            for(GCP_100PCT_Analysis_SKU__c uniObj : uniqList){
                if(!prodIds.contains(uniObj.Vision_Product__c)){
                    prodIds.add(uniObj.Vision_Product__c);
                    GCP_SFDC_100pct_Analysis_SKU__c newObj = new GCP_SFDC_100pct_Analysis_SKU__c();
                    newObj.Vision_Customer__c = accId;
                    newObj.Vision_Update_Date__c = uniObj.Vision_Updated_date__c;
                    newObj.Vision_Product__c = uniObj.Vision_Product__c;
                    newObj.Vision_Drl_Act_Price__c = uniObj.DRL_Act_Price__c;
                    newObj.Vision_Drl_Act_Sales__c = uniObj.DRL_Act_Sales__c;
                    newObj.Vision_DRL_Act_Volume_Eu__c = uniObj.drl_act_volume_eu__c;
                    newObj.Vision_DRL_Act_Tpt__c = uniObj.DRL_Act_Tpt__c;
                    newObj.GCP_Product_Family__c = uniObj.GCP_Product_Family__c;
                    newObj.Vision_Drl_Act_Tpt_Pct__c = uniObj.DRL_Act_Tpt_Pct__c;
                    newObj.Product_Family__c = uniObj.Vision_Product__r.Product_Family__c != null ? uniObj.Vision_Product__r.Product_Family__c : null;
                    if(prodTotalUnitsMap.containsKey(newObj.Vision_Product__c))
                        newObj.Vision_Estimate_Account_Total_Vol_EU__c = prodTotalUnitsMap.get(newObj.Vision_Product__c);
                    else
                        newObj.Vision_Estimate_Account_Total_Vol_EU__c = 0;
                    newSkuList.add(newObj);
                }
            }
            List<Product2> prodList = [SELECT Id, Name, Product_Family__c, Product_Family__r.Name FROM Product2 WHERE Product_Family__c IN: prodFamIds AND Id NOT IN: prodIds
                                       AND (Phoenix_Is_Private_Label_OTC__c = false OR (Phoenix_Is_Private_Label_OTC__c = true AND OTC_Customer__c = : accId))
                                       AND isActive = true AND Phoenix_Is_Exclude_Bid__c = false];
            for(Product2 prodObj : prodList){
                GCP_SFDC_100pct_Analysis_SKU__c newObj = new GCP_SFDC_100pct_Analysis_SKU__c();
                newObj.Vision_Customer__c = accId;
                newObj.Vision_Product__c = prodObj.Id;
                newObj.GCP_Product_Family__c = prodObj.Product_Family__r.Name;
                newObj.Product_Family__c = prodObj.Product_Family__c;
                if(prodTotalUnitsMap.containsKey(newObj.Vision_Product__c))
                    newObj.Vision_Estimate_Account_Total_Vol_EU__c = prodTotalUnitsMap.get(newObj.Vision_Product__c);
                else
                    newObj.Vision_Estimate_Account_Total_Vol_EU__c = 0;
                newSkuList.add(newObj);
            }
            if(newSkuList.size()>0)
                upsert newSkuList;
            gcpNdcList = Database.query(childQuery);
            for(GCP_SFDC_100pct_Analysis_SKU__c prd : gcpNdcList){
                
                /*if(prodTotalUnitsMap.containsKey(obj.Vision_Product__c)){
                    Product_Opportunity__c prd = prodTotalUnitsMap.get(obj.Vision_Product__c);
                    if(acc.Name == 'Red Oak Sourcing'){
                        obj.Vision_CVS_Share_Vol__c = (prd.Vision_Proposed_CVS_Direct_Units__c != null ? prd.Vision_Proposed_CVS_Direct_Units__c : (prd.Vision_Proposed_CVS_Indirect_Units__c !=null ? prd.Vision_Proposed_CVS_Indirect_Units__c : 0));
                        obj.Vision_Contract_Type__c = (prd.Vision_Proposed_CVS_Direct_Units__c != null ? 'Direct' : (prd.Vision_Proposed_CVS_Indirect_Units__c !=null ? 'Indirect' : 'Direct'));
                        obj.Vision_Cardinal_Share_Vol__c = prd.Vision_Proposed_Cardinal_Units__c;
                        obj.Vision_Major_Share_Vol__c = prd.Vision_Proposed_Major_Units__c;
                        obj.Vision_CVS_VolShare_Percent__c = ((obj.Vision_CVS_Share_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                        obj.Vision_Cardinal_VolShare_Percent__c = ((obj.Vision_Cardinal_Share_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                        obj.Vision_Major_VolShare_Percent__c = ((obj.Vision_Major_Share_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                    }
                    else if(acc.AccountNumber == '153363'){
                        obj.Vision_McKesson_Vol__c = prd.Vision_Proposed_OS_Units__c;
                        obj.Vision_Rite_Aid_Vol__c = prd.Vision_Proposed_RAD_Units__c;
                        obj.Vision_WalMart_Vol__c = prd.Vision_Proposed_WMT_Units__c;
                        obj.Vision_McKesson_Vol_Share__c = ((obj.Vision_McKesson_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                        obj.Vision_Rite_Aid_Vol_Share__c = ((obj.Vision_Rite_Aid_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                        obj.Vision_WalMart_Vol_Share__c = ((obj.Vision_WalMart_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                        obj.Vision_NorthStar_Vol_Share__c = ((obj.Vision_NorthStar_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                    }
                    obj.Vision_Estimate_Account_Total_Vol_EU__c = prd.Vision_Total_Annual_Units__c + (obj.Vision_NorthStar_Vol__c!= null ? obj.Vision_NorthStar_Vol__c : 0);
                }
                else{
                    obj.Vision_Contract_Type__c = 'Direct';
                    obj.Vision_CVS_Share_Vol__c = 0;
                    obj.Vision_Cardinal_Share_Vol__c = 0;
                    obj.Vision_Major_Share_Vol__c = 0;
                    obj.Vision_McKesson_Vol__c = 0;
                    obj.Vision_Rite_Aid_Vol__c = 0;
                    obj.Vision_WalMart_Vol__c = 0;
                    obj.Vision_CVS_VolShare_Percent__c = 0;
                    obj.Vision_Cardinal_VolShare_Percent__c = 0;
                    obj.Vision_Major_VolShare_Percent__c = 0;
                    obj.Vision_McKesson_Vol_Share__c = 0;
                    obj.Vision_Rite_Aid_Vol_Share__c = 0;
                    obj.Vision_WalMart_Vol_Share__c = 0;
                    obj.Vision_Estimate_Account_Total_Vol_EU__c = 0;
                }    
                obj.Vision_Update_date__c = system.today();*/
                
                if(prd.Vision_Product__r.Product_Family__c != null){
                    string famId = prd.Vision_Product__r.Product_Family__c;
                    if(prodFamTotalunits.containsKey(famId)){
                        Integer totalUnits = prodFamTotalunits.get(famId);
                        prodFamTotalunits.put(famId, totalUnits+Integer.valueOf(prd.Vision_Estimate_Account_Total_Vol_EU__c));
                    }
                    else
                        prodFamTotalunits.put(famId, Integer.valueOf(prd.Vision_Estimate_Account_Total_Vol_EU__c));
                }
            }
            
            List<Phoenix_GCP_Opportunity_Tracker__c> gcpList = [SELECT Id, Vision_isRelevance__c, Vision_Inline_RFP_Units__c, Product_Family__c, Product_Family__r.Name, Phoenix_Est_Acct_Vol_Method__c, Vision_Sum_of_Sku_est_vol__c 
                                                                FROM Phoenix_GCP_Opportunity_Tracker__c WHERE Phoenix_Customer__c =: accId AND Product_Family__c != null];
            List<Phoenix_GCP_Opportunity_Tracker__c> updateGcpList = new List<Phoenix_GCP_Opportunity_Tracker__c>();
            for(Phoenix_GCP_Opportunity_Tracker__c gcpObj : gcpList){
                string famId = gcpObj.Product_Family__c;
                if(prodFamTotalunits.containsKey(famId)){
                    gcpObj.Vision_isRelevance__c = true;
                    //if(.contains()){
                    //    gcpObj.Vision_Sum_of_Sku_est_vol__c = prodFamTotalunits.get(famId);
                    //    gcpObj.Phoenix_Est_Acct_Vol_Method__c = 'Use Sum of all SKUs estimate volume';
                    //}
                    //else{
                        gcpObj.Vision_Inline_RFP_Units__c = prodFamTotalunits.get(famId);
                        gcpObj.Phoenix_Est_Acct_Vol_Method__c = 'Use Proposed Total Selling Units (BRIGHT)';
                    //}
                }
                else
                    gcpObj.Vision_isRelevance__c = false;
                updateGcpList.add(gcpObj);
            }
            update updateGcpList;
            
            /*List<String> prodIds = new List<String>();
            
            List<GCP_SFDC_100pct_Analysis_SKU__c> gcpSkuList = database.query('SELECT Vision_Product__r.Product_Family__c,'+Phoenix_Util.getsObjectFieds('GCP_SFDC_100pct_Analysis_SKU__c')+' FROM GCP_SFDC_100pct_Analysis_SKU__c WHERE Vision_Customer__c =: accId AND Vision_Product__r.Product_Family__c IN:prodFamIds');
            for(GCP_SFDC_100pct_Analysis_SKU__c prd : gcpSkuList){
                prodIds.add(prd.Vision_Product__c);
            }
            
            for(Product_Opportunity__c prd: optyProdList){
                if(!acc.Name.contains('OTC Private Label')){
                    prd.Vision_Total_Annual_Units__c = prd.Proposed_Direct_Selling_Units__c+prd.Proposed_Indirect_Selling_Units__c+prd.Vision_Proposed_OS_Units__c+prd.Vision_Proposed_RAD_Units__c+prd.Vision_Proposed_WMT_Units__c
                        +prd.Vision_Proposed_BASE_Units__c+prd.Vision_Proposed_DSH_Units__c+prd.Vision_Proposed_AutoSub_Units__c+prd.Vision_Proposed_Smith_Drug_Units__c+prd.Vision_Proposed_Anda_Units__c
                        +prd.Vision_Proposed_DirectAholdDelhaizeUnits__c+prd.Vision_Proposed_Direct_Gaint_Eagle_Units__c+prd.Vision_Proposed_TotalRetailIndirectUnits__c+prd.Vision_Proposed_Direct_ESI_Units__c
                        +prd.Vision_Proposed_Indirect_ESI_Units__c+prd.Vision_Proposed_Direct_Kroger_Units__c+prd.Vision_Proposed_Indirect_Kroger_Units__c+prd.Vision_Proposed_Direct_Rx_Outreach_Units__c
                        +prd.Vision_Proposed_IndirectRxOutreach_Units__c+prd.Vision_Proposed_Direct_Supervalu_Units__c+prd.Vision_Proposed_Indirect_Supervalu_Units__c+prd.Vision_Proposed_Direct_Cordant_Units__c
                        +prd.Vision_Proposed_Indirect_Cordant_Units__c+prd.Vision_Proposed_Direct_Accerodo_Units__c+prd.Vision_Proposed_Indirect_Accerodo_Units__c+prd.Vision_Proposed_CVS_Direct_Units__c
                        +prd.Vision_Proposed_CVS_Indirect_Units__c+prd.Vision_Proposed_Cardinal_Units__c+prd.Vision_Proposed_Major_Units__c+prd.Vision_Proposed_Indirect_Cigna_Units__c+prd.Vision_Proposed_Direct_Cigna_Units__c;
                }
                else
                    prd.Vision_Total_Annual_Units__c = prd.Vision_Proposed_Units__c * (prd.Vision_Proposed_Share_Percentage__c/100);
                prodTotalUnitsMap.put(prd.Product__c,prd);
                prodIds.add(prd.Product__c);
                String famId = prd.Product__r.Product_Family__c;
                if(!prodFamIds.contains(famId))
                    prodFamIds.add(famId);
            }
            
            
            for(GCP_SFDC_100pct_Analysis_SKU__c prd : gcpSkuList){
                if(prd.Product__r.Product_Family__c != null){
                    if(prodFamTotalunits.containsKey(famId)){
                        Integer totalUnits = prodFamTotalunits.get(famId);
                        prodFamTotalunits.put(famId, totalUnits+Integer.valueOf(prd.Vision_Total_Annual_Units__c));
                    }
                    else
                        prodFamTotalunits.put(famId, Integer.valueOf(prd.Vision_Total_Annual_Units__c));
                }
            }
            
            List<Phoenix_GCP_Opportunity_Tracker__c> gcpList = [SELECT Id, Vision_isRelevance__c, Vision_Inline_RFP_Units__c, Product_Family__c, Product_Family__r.Name, Phoenix_Est_Acct_Vol_Method__c, Vision_Sum_of_Sku_est_vol__c 
                                                                FROM Phoenix_GCP_Opportunity_Tracker__c WHERE Phoenix_Customer__c =: accountId AND Product_Family__c IN: prodFamIds];
            List<GCP_SFDC_100pct_Analysis_SKU__c> gcpSkuList = database.query('SELECT Vision_Product__r.Product_Family__c,'+Phoenix_Util.getsObjectFieds('GCP_SFDC_100pct_Analysis_SKU__c')+' FROM GCP_SFDC_100pct_Analysis_SKU__c WHERE Vision_Customer__c =: accountId AND Vision_Product__r.Product_Family__c IN:prodFamIds');
            Map<String, List<GCP_SFDC_100pct_Analysis_SKU__c>> skuMap = new Map<String, List<GCP_SFDC_100pct_Analysis_SKU__c>>();
            if(acc.Name == 'Red Oak Sourcing' || acc.AccountNumber == '153363'){
                for(GCP_SFDC_100pct_Analysis_SKU__c obj:gcpSkuList){
                    String famId = obj.Vision_Product__r.Product_Family__c;
                    if(!skuMap.containsKey(famId))
                        skuMap.put(famId, New List<GCP_SFDC_100pct_Analysis_SKU__c>());
                    skuMap.get(famId).add(obj);
                }
            }
            List<GCP_SFDC_100pct_Analysis_SKU__c> updateSkuList = new List<GCP_SFDC_100pct_Analysis_SKU__c>();
            List<Phoenix_GCP_Opportunity_Tracker__c> updategcpList = new List<Phoenix_GCP_Opportunity_Tracker__c>(); 
            for(Phoenix_GCP_Opportunity_Tracker__c gcpObj:gcpList){
                String famId = gcpObj.Product_Family__c;
                if(prodFamTotalunits.containsKey(famId)){
                    if(skuMap.containsKey(famId)){
                        List<GCP_SFDC_100pct_Analysis_SKU__c> skuList = skuMap.get(famId);
                        Decimal totalVolSku = 0;
                        for(GCP_SFDC_100pct_Analysis_SKU__c obj:skuList){
                            if(prodTotalUnitsMap.containsKey(obj.Vision_Product__c)){
                                Product_Opportunity__c prd = prodTotalUnitsMap.get(obj.Vision_Product__c);
                                if(acc.Name == 'Red Oak Sourcing'){
                                    obj.Vision_CVS_Share_Vol__c = (prd.Vision_Proposed_CVS_Direct_Units__c != null ? prd.Vision_Proposed_CVS_Direct_Units__c : (prd.Vision_Proposed_CVS_Indirect_Units__c !=null ? prd.Vision_Proposed_CVS_Indirect_Units__c : 0));
                                    obj.Vision_Contract_Type__c = (prd.Vision_Proposed_CVS_Direct_Units__c != null ? 'Direct' : (prd.Vision_Proposed_CVS_Indirect_Units__c !=null ? 'Indirect' : 'Direct'));
                                    obj.Vision_Cardinal_Share_Vol__c = prd.Vision_Proposed_Cardinal_Units__c;
                                    obj.Vision_Major_Share_Vol__c = prd.Vision_Proposed_Major_Units__c;
                                    obj.Vision_CVS_VolShare_Percent__c = ((obj.Vision_CVS_Share_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                                    obj.Vision_Cardinal_VolShare_Percent__c = ((obj.Vision_Cardinal_Share_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                                    obj.Vision_Major_VolShare_Percent__c = ((obj.Vision_Major_Share_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                                }
                                else if(acc.AccountNumber == '153363'){
                                    obj.Vision_McKesson_Vol__c = prd.Vision_Proposed_OS_Units__c;
                                    obj.Vision_Rite_Aid_Vol__c = prd.Vision_Proposed_RAD_Units__c;
                                    obj.Vision_WalMart_Vol__c = prd.Vision_Proposed_WMT_Units__c;
                                    obj.Vision_McKesson_Vol_Share__c = ((obj.Vision_McKesson_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                                    obj.Vision_Rite_Aid_Vol_Share__c = ((obj.Vision_Rite_Aid_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                                    obj.Vision_WalMart_Vol_Share__c = ((obj.Vision_WalMart_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                                    obj.Vision_NorthStar_Vol_Share__c = ((obj.Vision_NorthStar_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                                }
                                obj.Vision_Estimate_Account_Total_Vol_EU__c = prd.Vision_Total_Annual_Units__c + (obj.Vision_NorthStar_Vol__c!= null ? obj.Vision_NorthStar_Vol__c : 0);
                            }
                            else{
                                obj.Vision_Contract_Type__c = 'Direct';
                                obj.Vision_CVS_Share_Vol__c = 0;
                                obj.Vision_Cardinal_Share_Vol__c = 0;
                                obj.Vision_Major_Share_Vol__c = 0;
                                obj.Vision_McKesson_Vol__c = 0;
                                obj.Vision_Rite_Aid_Vol__c = 0;
                                obj.Vision_WalMart_Vol__c = 0;
                                obj.Vision_CVS_VolShare_Percent__c = 0;
                                obj.Vision_Cardinal_VolShare_Percent__c = 0;
                                obj.Vision_Major_VolShare_Percent__c = 0;
                                obj.Vision_McKesson_Vol_Share__c = 0;
                                obj.Vision_Rite_Aid_Vol_Share__c = 0;
                                obj.Vision_WalMart_Vol_Share__c = 0;
                                obj.Vision_Estimate_Account_Total_Vol_EU__c = 0;
                            }    
                            obj.Vision_Update_date__c = system.today();
                            totalVolSku += obj.Vision_Estimate_Account_Total_Vol_EU__c; 
                            updateSkuList.add(obj);
                        }
                        gcpObj.Vision_Sum_of_Sku_est_vol__c = totalVolSku;
                        gcpObj.Phoenix_Est_Acct_Vol_Method__c = 'Use Sum of all SKUs estimate volume';
                    }
                    else
                        gcpObj.Phoenix_Est_Acct_Vol_Method__c = 'Use Proposed Total Selling Units (BRIGHT)';
                    
                    gcpObj.Vision_Inline_RFP_Units__c = prodFamTotalunits.get(famId);
                    gcpObj.Vision_isRelevance__c = true;
                    updategcpList.add(gcpObj);
                }
            }
            update updategcpList;update updateSkuList;*/
            
        }
        catch(exception e){
            Phoenix_Util.recordException(e,'Vision_SendToBrightCtrl','syncUnitsToAnalysis',''+' line Number : '+e.getLineNumber()); 
        }
    }
  /*  @auraEnabled
    public static Product_Opportunity__c saveCustomers(String secondaryList, String optyProdId,String optyId){
           system.debug('secondaryList=='+secondaryList);
      List<SecondaryListcls> secList = (List<SecondaryListcls>) JSON.deserialize(secondaryList, List<SecondaryListcls>.class);
        system.debug('secList=='+secList);
           system.debug('optyProdId=='+optyProdId);
          system.debug('optyId=='+optyId);
     
        Product_Opportunity__c opp = [SELECT Id,Secondary_Backup_Exclusion_Customers__c,Final_Exclusion_Customers__c FROM Product_Opportunity__c where Id =: optyProdId];
        for(SecondaryListcls item:secList){
            if(item.isSelected){
                if( opp.Final_Exclusion_Customers__c != null){
                    if(!opp.Final_Exclusion_Customers__c.contains(item.custName)){
                    opp.Final_Exclusion_Customers__c = opp.Final_Exclusion_Customers__c+','+item.custName;   
                    }
                   
                }
                else{
                    opp.Final_Exclusion_Customers__c = item.custName;
                }
            }else{
               // string temp = opp.Final_Exclusion_Customers__c;
               // string temp2 = item.custName;
               //  opp.Final_Exclusion_Customers__c = temp.replace(temp2,'');
                
                String originalString = opp.Final_Exclusion_Customers__c;
                String[] parts = originalString.split(','); // Split the string into an array of words
                
                String substringToRemove = item.custName; // Define the substring to remove
                String resultString = '';
                system.debug('parts=='+parts);
                 system.debug('substringToRemove=='+substringToRemove);
                for (String part : parts) {
                    if (!part.equals(substringToRemove)) {
                              system.debug('resultString=='+resultString);
          
                        if(resultString==''){
                            resultString = part;   
                        }
                        else{
                            system.debug(' notresultString=='+resultString);
                            resultString = resultString + ', ' + part; // Reconstruct the string without the substring
                            
                        }
                    }
                }
                system.debug('resultString=='+resultString);
                opp.Final_Exclusion_Customers__c = resultString.trim(); // Remove trailing spaces

            }
        }
        update opp;
        return opp;
    }*/
      @auraEnabled
    public static Product_Opportunity__c saveCustomers(List<String> custNameList,List<String> notSelectedcustNameList, String optyProdId,String optyId){
        system.debug('custNameList=='+custNameList);
        system.debug('notSelectedcustNameList=='+notSelectedcustNameList);
        system.debug('optyId=='+optyId);
        List<Phoenix_Inclusion_Contract_Pharmabid__c> InclusionContractsList= new List<Phoenix_Inclusion_Contract_Pharmabid__c>();
        List<Phoenix_Inclusion_Contract_Pharmabid__c> notSelectedExclusionList= new List<Phoenix_Inclusion_Contract_Pharmabid__c>();
        Product_Opportunity__c opp = [SELECT Id,Secondary_Backup_Exclusion_Customers__c,Final_Exclusion_Customers__c FROM Product_Opportunity__c where Id =: optyProdId];
       if(custNameList.size() > 0)
        InclusionContractsList= [SELECT Id, Customer_Number__c, Name, Group_Customer_Name__r.Name,Customer_Name__r.Name, Group_Customer_Number__c, Contract_Number__c FROM Phoenix_Inclusion_Contract_Pharmabid__c where Group_Customer_Name__r.Name IN:custNameList OR Customer_Name__r.Name IN:custNameList];
       if(notSelectedcustNameList.size() > 0)
        notSelectedExclusionList= [SELECT Id, Customer_Number__c, Name, Group_Customer_Name__r.Name,Customer_Name__r.Name, Group_Customer_Number__c, Contract_Number__c FROM Phoenix_Inclusion_Contract_Pharmabid__c where Group_Customer_Name__r.Name IN:notSelectedcustNameList OR Customer_Name__r.Name IN:notSelectedcustNameList];
        if(InclusionContractsList.size() > 0){
        for(Phoenix_Inclusion_Contract_Pharmabid__c con:InclusionContractsList){
            if(custNameList.contains(con.Group_Customer_Name__r.Name)){
              String name='All members of '+con.Group_Customer_Name__r.Name;
                opp.Final_Exclusion_Customers__c = (opp.Final_Exclusion_Customers__c == null) ? 'All members of '+con.Group_Customer_Name__r.Name : (opp.Final_Exclusion_Customers__c != null && !opp.Final_Exclusion_Customers__c.contains(name)) ? opp.Final_Exclusion_Customers__c+', '+'All members of '+con.Group_Customer_Name__r.Name : opp.Final_Exclusion_Customers__c;
              //  if(opp.Final_Exclusion_Customers__c != null && !opp.Final_Exclusion_Customers__c.contains(name))
                  //    opp.Final_Exclusion_Customers__c = opp.Final_Exclusion_Customers__c != null && !opp.Final_Exclusion_Customers__c.contains(name) ? opp.Final_Exclusion_Customers__c+', '+'All members of '+con.Group_Customer_Name__r.Name : 'All members of '+con.Group_Customer_Name__r.Name;
           //     opp.Final_Exclusion_Customers__c = opp.Final_Exclusion_Customers__c == null ? 'All members of '+con.Group_Customer_Name__r.Name :opp.Final_Exclusion_Customers__c+', '+'All members of '+con.Group_Customer_Name__r.Name;
            }
            else{
             opp.Final_Exclusion_Customers__c = opp.Final_Exclusion_Customers__c == null ? con.Customer_Name__r.Name : (opp.Final_Exclusion_Customers__c != null && !opp.Final_Exclusion_Customers__c.contains(con.Customer_Name__r.Name)) ? opp.Final_Exclusion_Customers__c+', '+con.Customer_Name__r.Name : opp.Final_Exclusion_Customers__c;
            }
        }
        }
        if(notSelectedExclusionList.size() > 0 && notSelectedcustNameList != custNameList){
        for(Phoenix_Inclusion_Contract_Pharmabid__c con:notSelectedExclusionList){
            String name='';
            if(notSelectedcustNameList.contains(con.Group_Customer_Name__r.Name)){
                name='All members of '+con.Group_Customer_Name__r.Name;
            }
            else{
                name=con.Customer_Name__r.Name;
            }
            system.debug('name=='+name);
                String originalString = opp.Final_Exclusion_Customers__c;
                String[] parts = originalString.split(','); // Split the string into an array of words
            opp.Final_Exclusion_Customers__c = originalString.replace(name,'');
            opp.Final_Exclusion_Customers__c = opp.Final_Exclusion_Customers__c.replace(',,',',');
                /*    String substringToRemove = name; // Define the substring to remove
                String resultString = '';
                system.debug('parts=='+parts);
                 system.debug('substringToRemove=='+substringToRemove);
                for (String part : parts) {
                                            system.debug('part name=='+part);
                                            system.debug('substringToRemove=='+substringToRemove);
                    if(part.trim() != substringToRemove.trim()){
                        system.debug('part inside=='+part);
                       if(resultString==''){
                            resultString = part;   
                        }
                        else{
                            system.debug(' notresultString=='+resultString);
                            resultString = resultString + ', ' + part; // Reconstruct the string without the substring
                            
                        } 
                        
                    }
                     system.debug('resultString=='+resultString);*/
                 /*   if (!part.equals(substringToRemove)) {
                              system.debug('resultString=='+resultString);
          
                        if(resultString==''){
                            resultString = part;   
                        }
                        else{
                            system.debug(' notresultString=='+resultString);
                            resultString = resultString + ', ' + part; // Reconstruct the string without the substring
                            
                        }
                    }*/
                    
               
               
               // opp.Final_Exclusion_Customers__c = resultString.trim(); // Remove trailing spaces

            }
        }
        update opp;
        return opp;
    }
   
    public class SecondaryListcls{
        @auraEnabled
        public boolean isSelected;
        @auraEnabled
        public string custName;
    }
    @auraEnabled
    public static string updateInAnalysisClass(List<Product_Opportunity__c> optyProdList,boolean isFullLineRfp){
        try{
            Map<String, Integer> prodFamTotalunits = new Map<String, Integer>();
            List<String> prodFamIds = new List<String>();
            Map<String, Product_Opportunity__c> prodTotalUnitsMap = new Map<String, Product_Opportunity__c>();
            //List<Product_Opportunity__c> optyProdList = Database.query('SELECT Product__r.Product_Family__r.Name, Product__r.Product_Family__c, '+ Phoenix_Util.getsObjectFieds('Product_Opportunity__c') +' FROM Product_Opportunity__c WHERE Id IN: lineIds');
            //Opportunity oppObj = [SELECT Id, AccountId FROM Opportunity WHERE Id=:optyProdList[0].Opportunity__c];
            /*added by satya*/
            Opportunity oppObj = new Opportunity();
            oppObj = optyProdList != null ? [SELECT Id, AccountId FROM Opportunity WHERE Id=:optyProdList[0].Opportunity__c] : null;
            /*end by satya*/
            String accId = oppObj.AccountId;
            Account acc = [SELECT Id, Name, AccountNumber FROM Account WHERE Id =: accId];
            for(Product_Opportunity__c prd:optyProdList){
                prodFamIds.add(prd.Product__r.Product_Family__c);
                if(!acc.Name.contains('OTC Private Label')){
                    prd.Vision_Total_Annual_Units__c = prd.Proposed_Direct_Selling_Units__c+prd.Proposed_Indirect_Selling_Units__c+prd.Vision_Proposed_OS_Units__c+prd.Vision_Proposed_RAD_Units__c+prd.Vision_Proposed_WMT_Units__c+prd.Vision_Proposed_BASE_Units__c+prd.Vision_Proposed_DSH_Units__c+prd.Vision_Proposed_AutoSub_Units__c+prd.Vision_Proposed_Smith_Drug_Units__c+prd.Vision_Proposed_Anda_Units__c+prd.Vision_Proposed_DirectAholdDelhaizeUnits__c+prd.Vision_Proposed_Direct_Gaint_Eagle_Units__c+prd.Vision_Proposed_TotalRetailIndirectUnits__c+prd.Vision_Proposed_Direct_ESI_Units__c+prd.Vision_Proposed_Indirect_ESI_Units__c+prd.Vision_Proposed_Direct_Kroger_Units__c+prd.Vision_Proposed_Indirect_Kroger_Units__c+prd.Vision_Proposed_Direct_Rx_Outreach_Units__c+prd.Vision_Proposed_IndirectRxOutreach_Units__c+prd.Vision_Proposed_Direct_Supervalu_Units__c+prd.Vision_Proposed_Indirect_Supervalu_Units__c+prd.Vision_Proposed_Direct_Cordant_Units__c+prd.Vision_Proposed_Indirect_Cordant_Units__c+prd.Vision_Proposed_Direct_Accerodo_Units__c+prd.Vision_Proposed_Indirect_Accerodo_Units__c+prd.Vision_Proposed_CVS_Direct_Units__c+prd.Vision_Proposed_CVS_Indirect_Units__c+prd.Vision_Proposed_Cardinal_Units__c+prd.Vision_Proposed_Major_Units__c+prd.Vision_Proposed_Indirect_Cigna_Units__c+prd.Vision_Proposed_Direct_Cigna_Units__c;
                }
                else
                    prd.Vision_Total_Annual_Units__c = prd.Vision_Proposed_Units__c * (prd.Vision_Proposed_Share_Percentage__c/100);
                prodTotalUnitsMap.put(prd.Product__c,prd);
            }
            system.debug(prodFamIds);
            String childQuery = 'SELECT Vision_Customer__r.Name, Vision_Customer__r.Vision_is_SRx_Account__c,Vision_Product__r.Product_Family__c, Vision_Product__r.Id,Vision_Product__r.Name, Vision_Product__r.Phoenix_NDC_11__c, Vision_Product__r.isActive,Vision_Product__r.Phoenix_Pkg_Size__c, '+
                +' Vision_Customer__r.Phoenix_Account_Cooling_Period__c, '+Phoenix_Util.getsObjectFieds('GCP_SFDC_100pct_Analysis_SKU__c')+' FROM GCP_SFDC_100pct_Analysis_SKU__c'+
                +' WHERE Vision_Customer__c =: accId AND Vision_Product__r.Product_Family__c IN: prodFamIds AND Vision_Product__c != null AND Vision_Product__r.isActive = true '+
                +' AND (Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = false OR (Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = true AND Vision_Product__r.OTC_Customer__c = : accId AND Vision_Product__r.Phoenix_Is_Control_Label__c = false))'+
                +' AND Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false ORDER BY Vision_Product__r.Name';//GCP_Product_Family__c =: prodFamilyName/Product_Family__c =: famId( OR 
            List<GCP_SFDC_100pct_Analysis_SKU__c> gcpNdcList = Database.query(childQuery);
            List<GCP_SFDC_100pct_Analysis_SKU__c> updateList = new List<GCP_SFDC_100pct_Analysis_SKU__c>();
            List<Id> prodIds = new List<Id>();
            for(GCP_SFDC_100pct_Analysis_SKU__c obj : gcpNdcList){
                if(prodTotalUnitsMap.containsKey(obj.Vision_Product__c)){
                    Product_Opportunity__c prd = prodTotalUnitsMap.get(obj.Vision_Product__c);
                    prd.Vision_Total_Annual_Units__c = prd.Vision_Total_Annual_Units__c;//*obj.Vision_Product__r.Phoenix_Pkg_Size__c;
                    if(acc.AccountNumber == '153363'){
                        obj.Vision_McKesson_Vol__c = prd.Vision_Proposed_OS_Units__c;//*obj.Vision_Product__r.Phoenix_Pkg_Size__c;
                        obj.Vision_Rite_Aid_Vol__c = prd.Vision_Proposed_RAD_Units__c;//*obj.Vision_Product__r.Phoenix_Pkg_Size__c;
                        obj.Vision_WalMart_Vol__c = prd.Vision_Proposed_WMT_Units__c;//*obj.Vision_Product__r.Phoenix_Pkg_Size__c;
                        obj.Vision_McKesson_Vol_Share__c = ((obj.Vision_McKesson_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                        obj.Vision_Rite_Aid_Vol_Share__c = ((obj.Vision_Rite_Aid_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                        obj.Vision_WalMart_Vol_Share__c = ((obj.Vision_WalMart_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                        obj.Vision_NorthStar_Vol_Share__c = (obj.Vision_NorthStar_Vol__c!= null ? ((obj.Vision_NorthStar_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2) : 0);
                        obj.Vision_Estimate_Account_Total_Vol_EU__c = prd.Vision_Total_Annual_Units__c + obj.Vision_NorthStar_Vol__c;
                    }
                    else{
                        obj.Vision_Estimate_Account_Total_Vol_EU__c = prd.Vision_Total_Annual_Units__c;
                        if(acc.Name == 'Red Oak Sourcing'){
                            obj.Vision_CVS_Share_Vol__c = (prd.Vision_Proposed_CVS_Direct_Units__c != null ? prd.Vision_Proposed_CVS_Direct_Units__c : (prd.Vision_Proposed_CVS_Indirect_Units__c !=null ? prd.Vision_Proposed_CVS_Indirect_Units__c : 0));//*obj.Vision_Product__r.Phoenix_Pkg_Size__c;
                            obj.Vision_Contract_Type__c = (prd.Vision_Proposed_CVS_Direct_Units__c != null ? 'Direct' : (prd.Vision_Proposed_CVS_Indirect_Units__c !=null ? 'Indirect' : 'Direct'));
                            obj.Vision_Cardinal_Share_Vol__c = prd.Vision_Proposed_Cardinal_Units__c;//*obj.Vision_Product__r.Phoenix_Pkg_Size__c;
                            obj.Vision_Major_Share_Vol__c = prd.Vision_Proposed_Major_Units__c;//*obj.Vision_Product__r.Phoenix_Pkg_Size__c;
                            obj.Vision_CVS_VolShare_Percent__c = ((obj.Vision_CVS_Share_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                            obj.Vision_Cardinal_VolShare_Percent__c = ((obj.Vision_Cardinal_Share_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                            obj.Vision_Major_VolShare_Percent__c = ((obj.Vision_Major_Share_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                        }
                    }
                    obj.Vision_Estimate_Vol_Method__c = 'Full Line Volume';
                }
                else 
                    obj.Vision_Estimate_Account_Total_Vol_EU__c = obj.Vision_Estimate_Account_Total_Vol_EU__c != null ? obj.Vision_Estimate_Account_Total_Vol_EU__c : 0;
                prodIds.add(obj.Vision_Product__c);
                updateList.add(obj);
            }
            update updateList;
            
            String query = 'SELECT Vision_Product__r.Product_Family__c, Vision_Product__r.Phoenix_Pkg_Size__c, '+Phoenix_Util.getsObjectFieds('GCP_100PCT_Analysis_SKU__c')+' FROM GCP_100PCT_Analysis_SKU__c WHERE Vision_Product__r.Product_Family__c IN: prodFamIds '+//GCP_Product_Family__c =: prodFamilyName '+
                +' AND (Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = false OR (Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = true AND Vision_Product__r.OTC_Customer__c = : accId AND Vision_Product__r.Phoenix_Is_Control_Label__c = false))'+
                +' AND Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false  AND Vision_Product__r.isActive = true';
            List<GCP_100PCT_Analysis_SKU__c> uniqList = Database.query(query);
            List<GCP_SFDC_100pct_Analysis_SKU__c> newSkuList = new List<GCP_SFDC_100pct_Analysis_SKU__c>();
            for(GCP_100PCT_Analysis_SKU__c uniObj : uniqList){
                if(!prodIds.contains(uniObj.Vision_Product__c)){
                    prodIds.add(uniObj.Vision_Product__c);
                    GCP_SFDC_100pct_Analysis_SKU__c newObj = new GCP_SFDC_100pct_Analysis_SKU__c();
                    newObj.Vision_Customer__c = accId;
                    newObj.Vision_Update_Date__c = uniObj.Vision_Updated_date__c;
                    newObj.Vision_Product__c = uniObj.Vision_Product__c;
                    newObj.Vision_Drl_Act_Price__c = uniObj.DRL_Act_Price__c;
                    newObj.Vision_Drl_Act_Sales__c = uniObj.DRL_Act_Sales__c;
                    newObj.Vision_DRL_Act_Volume_Eu__c = uniObj.drl_act_volume_eu__c;
                    newObj.Vision_DRL_Act_Tpt__c = uniObj.DRL_Act_Tpt__c;
                    newObj.GCP_Product_Family__c = uniObj.GCP_Product_Family__c;
                    newObj.Vision_Drl_Act_Tpt_Pct__c = uniObj.DRL_Act_Tpt_Pct__c;
                    newObj.Product_Family__c = uniObj.Vision_Product__r.Product_Family__c != null ? uniObj.Vision_Product__r.Product_Family__c : null;
                    if(prodTotalUnitsMap.containsKey(newObj.Vision_Product__c)){
                        Product_Opportunity__c prd = prodTotalUnitsMap.get(newObj.Vision_Product__c);
                        prd.Vision_Total_Annual_Units__c = prd.Vision_Total_Annual_Units__c;//*uniObj.Vision_Product__r.Phoenix_Pkg_Size__c;
                        if(acc.AccountNumber == '153363'){
                            newObj.Vision_McKesson_Vol__c = prd.Vision_Proposed_OS_Units__c;//*uniObj.Vision_Product__r.Phoenix_Pkg_Size__c;
                            newObj.Vision_Rite_Aid_Vol__c = prd.Vision_Proposed_RAD_Units__c;//*uniObj.Vision_Product__r.Phoenix_Pkg_Size__c;
                            newObj.Vision_WalMart_Vol__c = prd.Vision_Proposed_WMT_Units__c;//*uniObj.Vision_Product__r.Phoenix_Pkg_Size__c;
                            newObj.Vision_McKesson_Vol_Share__c = ((newObj.Vision_McKesson_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                            newObj.Vision_Rite_Aid_Vol_Share__c = ((newObj.Vision_Rite_Aid_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                            newObj.Vision_WalMart_Vol_Share__c = ((newObj.Vision_WalMart_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                            newObj.Vision_NorthStar_Vol_Share__c = ((newObj.Vision_NorthStar_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                            newObj.Vision_Estimate_Account_Total_Vol_EU__c = prd.Vision_Total_Annual_Units__c + (newObj.Vision_NorthStar_Vol__c!= null ? newObj.Vision_NorthStar_Vol__c : 0);
                        }
                        else{
                            newObj.Vision_Estimate_Account_Total_Vol_EU__c = prd.Vision_Total_Annual_Units__c;
                            if(acc.Name == 'Red Oak Sourcing'){
                                newObj.Vision_CVS_Share_Vol__c = (prd.Vision_Proposed_CVS_Direct_Units__c != null ? prd.Vision_Proposed_CVS_Direct_Units__c : (prd.Vision_Proposed_CVS_Indirect_Units__c !=null ? prd.Vision_Proposed_CVS_Indirect_Units__c : 0));//*uniObj.Vision_Product__r.Phoenix_Pkg_Size__c;
                                newObj.Vision_Contract_Type__c = (prd.Vision_Proposed_CVS_Direct_Units__c != null ? 'Direct' : (prd.Vision_Proposed_CVS_Indirect_Units__c !=null ? 'Indirect' : 'Direct'));
                                newObj.Vision_Cardinal_Share_Vol__c = prd.Vision_Proposed_Cardinal_Units__c;//*uniObj.Vision_Product__r.Phoenix_Pkg_Size__c;
                                newObj.Vision_Major_Share_Vol__c = prd.Vision_Proposed_Major_Units__c;//*uniObj.Vision_Product__r.Phoenix_Pkg_Size__c;
                                newObj.Vision_CVS_VolShare_Percent__c = ((newObj.Vision_CVS_Share_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                                newObj.Vision_Cardinal_VolShare_Percent__c = ((newObj.Vision_Cardinal_Share_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                                newObj.Vision_Major_VolShare_Percent__c = ((newObj.Vision_Major_Share_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                            }
                        }
                    }
                    else
                        newObj.Vision_Estimate_Account_Total_Vol_EU__c = 0;
                    newSkuList.add(newObj);
                }
            }
            List<Product2> prodList = [SELECT Id, Name, Product_Family__c, Product_Family__r.Name, Phoenix_Pkg_Size__c FROM Product2 WHERE Product_Family__c IN: prodFamIds AND Id NOT IN: prodIds
                                       AND (Phoenix_Is_Private_Label_OTC__c = false OR (Phoenix_Is_Private_Label_OTC__c = true AND OTC_Customer__c = : accId))
                                       AND isActive = true AND Phoenix_Is_Exclude_Bid__c = false];
            system.debug(prodList);
            for(Product2 prodObj : prodList){
                GCP_SFDC_100pct_Analysis_SKU__c newObj = new GCP_SFDC_100pct_Analysis_SKU__c();
                newObj.Vision_Customer__c = accId;
                newObj.Vision_Product__c = prodObj.Id;
                newObj.GCP_Product_Family__c = prodObj.Product_Family__r.Name;
                newObj.Product_Family__c = prodObj.Product_Family__c;
                if(prodTotalUnitsMap.containsKey(newObj.Vision_Product__c)){
                    Product_Opportunity__c prd = prodTotalUnitsMap.get(newObj.Vision_Product__c);
                    prd.Vision_Total_Annual_Units__c = prd.Vision_Total_Annual_Units__c;//*prodObj.Phoenix_Pkg_Size__c;
                    if(acc.AccountNumber == '153363'){
                        newObj.Vision_McKesson_Vol__c = prd.Vision_Proposed_OS_Units__c;//*prodObj.Phoenix_Pkg_Size__c;
                        newObj.Vision_Rite_Aid_Vol__c = prd.Vision_Proposed_RAD_Units__c;//*prodObj.Phoenix_Pkg_Size__c;
                        newObj.Vision_WalMart_Vol__c = prd.Vision_Proposed_WMT_Units__c;//*prodObj.Phoenix_Pkg_Size__c;
                        newObj.Vision_McKesson_Vol_Share__c = ((newObj.Vision_McKesson_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                        newObj.Vision_Rite_Aid_Vol_Share__c = ((newObj.Vision_Rite_Aid_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                        newObj.Vision_WalMart_Vol_Share__c = ((newObj.Vision_WalMart_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                        newObj.Vision_NorthStar_Vol_Share__c = ((newObj.Vision_NorthStar_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                        newObj.Vision_Estimate_Account_Total_Vol_EU__c = prd.Vision_Total_Annual_Units__c + (newObj.Vision_NorthStar_Vol__c!= null ? newObj.Vision_NorthStar_Vol__c : 0);
                    }
                    else{
                        newObj.Vision_Estimate_Account_Total_Vol_EU__c = prd.Vision_Total_Annual_Units__c;
                        if(acc.Name == 'Red Oak Sourcing'){
                            newObj.Vision_CVS_Share_Vol__c = (prd.Vision_Proposed_CVS_Direct_Units__c != null ? prd.Vision_Proposed_CVS_Direct_Units__c : (prd.Vision_Proposed_CVS_Indirect_Units__c !=null ? prd.Vision_Proposed_CVS_Indirect_Units__c : 0));//*prodObj.Phoenix_Pkg_Size__c;
                            newObj.Vision_Contract_Type__c = (prd.Vision_Proposed_CVS_Direct_Units__c != null ? 'Direct' : (prd.Vision_Proposed_CVS_Indirect_Units__c !=null ? 'Indirect' : 'Direct'));
                            newObj.Vision_Cardinal_Share_Vol__c = prd.Vision_Proposed_Cardinal_Units__c;//*prodObj.Phoenix_Pkg_Size__c;
                            newObj.Vision_Major_Share_Vol__c = prd.Vision_Proposed_Major_Units__c;//*prodObj.Phoenix_Pkg_Size__c;
                            newObj.Vision_CVS_VolShare_Percent__c = ((newObj.Vision_CVS_Share_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                            newObj.Vision_Cardinal_VolShare_Percent__c = ((newObj.Vision_Cardinal_Share_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                            newObj.Vision_Major_VolShare_Percent__c = ((newObj.Vision_Major_Share_Vol__c/prd.Vision_Total_Annual_Units__c)*100).setScale(2);
                        }
                    }
                }
                else
                    newObj.Vision_Estimate_Account_Total_Vol_EU__c = 0;
                newSkuList.add(newObj);
            }
            if(newSkuList.size()>0)
                upsert newSkuList;
            gcpNdcList = Database.query(childQuery);
            for(GCP_SFDC_100pct_Analysis_SKU__c prd : gcpNdcList){
                if(prd.Vision_Product__r.Product_Family__c != null){
                    string famId = prd.Vision_Product__r.Product_Family__c;
                    prd.Vision_Estimate_Account_Total_Vol_EU__c = prd.Vision_Estimate_Account_Total_Vol_EU__c != null? prd.Vision_Estimate_Account_Total_Vol_EU__c : 0;
                    prd.Vision_User_Input_Estimate_Vol__c = prd.Vision_User_Input_Estimate_Vol__c != null? prd.Vision_User_Input_Estimate_Vol__c : 0;
                    prd.Vision_Estimate_Vol_Method__c = (prd.Vision_Estimate_Vol_Method__c != null ? prd.Vision_Estimate_Vol_Method__c : 'Full Line Volume');
                   //satya checked not null for prd.Vision_Estimate_Vol_Method__c,prd.Vision_Estimate_Account_Total_Vol_EU__c,prd.Vision_User_Input_Estimate_Vol__c
                    Integer totalVal = Integer.valueOf(((prd.Vision_Estimate_Vol_Method__c != null && prd.Vision_Estimate_Vol_Method__c == 'Full Line Volume') ? (prd.Vision_Estimate_Account_Total_Vol_EU__c != null ? prd.Vision_Estimate_Account_Total_Vol_EU__c :prd.Vision_Estimate_Account_Total_Vol_EU__c) : (prd.Vision_User_Input_Estimate_Vol__c != null ?prd.Vision_User_Input_Estimate_Vol__c :0 ))*prd.Vision_Product__r.Phoenix_Pkg_Size__c);
                    if(prodFamTotalunits.containsKey(famId)){
                        Integer totalUnits = prodFamTotalunits.get(famId);
                        prodFamTotalunits.put(famId, totalUnits+totalVal);
                    }
                    else
                        prodFamTotalunits.put(famId, totalVal);
                }
            }
            
            List<Phoenix_GCP_Opportunity_Tracker__c> gcpList = [SELECT Id, Vision_isRelevance__c, Vision_Inline_RFP_Units__c, Product_Family__c, Product_Family__r.Name, Phoenix_Est_Acct_Vol_Method__c, Vision_Sum_of_Sku_est_vol__c 
                                                                FROM Phoenix_GCP_Opportunity_Tracker__c WHERE Phoenix_Customer__c =: accId AND Product_Family__c != null];
            List<Phoenix_GCP_Opportunity_Tracker__c> updateGcpList = new List<Phoenix_GCP_Opportunity_Tracker__c>();
            for(Phoenix_GCP_Opportunity_Tracker__c gcpObj : gcpList){
                string famId = gcpObj.Product_Family__c;
                if(prodFamTotalunits.containsKey(famId)){
                    gcpObj.Vision_isRelevance__c = true;
                    gcpObj.Vision_Inline_RFP_Units__c = prodFamTotalunits.get(famId);
                    gcpObj.Phoenix_Est_Acct_Vol_Method__c = 'Use Proposed Total Selling Units (BRIGHT)';
                }
                else if(isFullLineRfp)
                    gcpObj.Vision_isRelevance__c = false;
                updateGcpList.add(gcpObj);
            }
            update updateGcpList;
            return 'SUCCESS';
        }
        catch(exception e){
            Phoenix_Util.recordException(e,'Vision_SendToBrightCtrl','updateInAnalysisClass',''+' line Number : '+e.getLineNumber()); 
            return 'ERROR: e --> '+e.getMessage()+' | Line: '+e.getLineNumber();
        }
    }
    
    public class wrapperBidCheck{
        @auraEnabled
        public boolean isError = false;
        @auraEnabled
        public string errorMessage;
        @auraEnabled
        public String bidId;
        @auraEnabled
        public Opportunity oppObj;
        @auraEnabled
        public Product_Opportunity__c optyProdObj;
        @auraEnabled
        public boolean isSelected=false;
        @auraEnabled
        public boolean hasBidLineItem = false;
        @auraEnabled
        public List<Phoenix_Contract__c> refContractList;
        @auraEnabled
        public List<Product_Opportunity__c> optyProdList;
        @auraEnabled
        public boolean isAwarded = false;
        @auraEnabled
        public boolean showAddToBidButton = false;
        @auraEnabled
        public boolean isPanMove = false;
    }
    
    @auraEnabled
    public static Opportunity updateOptyCmnt(Opportunity optyObj){
        update optyObj;
        return optyObj;
    }
    
    @auraEnabled
    public static wrapperBidCheck getOptyLinesAndCon(Id opportunityId){
        wrapperBidCheck wrapObj = new wrapperBidCheck();
        try{
            List<Phoenix_Contract__c> conractList = new List<Phoenix_Contract__c>();
            String query = 'SELECT Account.AccountNumber,Account.Name, Account.Phoenix_Is_OTC_Customer__c, '+Phoenix_Util.getsObjectFieds('Opportunity')+' FROM Opportunity WHERE Id=: opportunityId';
            Opportunity optyObj = Database.query(query);
            wrapObj.oppObj = optyObj;
            query = 'SELECT GCP_Product_Family__r.Name,Product__r.Id, Product__r.Name, Product__r.ProductCode, Product__r.Phoenix_NDC_11__c, Product__r.Family, Product__r.Phoenix_Is_New_Product__c, '+
                +'Product__r.Phoenix_Lowest_Price_SKU__c, Product__r.Phoenix_Strength__c, Product__r.Phoenix_Pkg_Size__c, Product__r.Phoenix_Is_Private_Label_OTC__c, Product__r.Phoenix_Rx_SRx_OTC__c,'+
                +' Product__r.Phoenix_WAC__c, Product__r.Phoenix_Product_Director__r.Name, Vision_Bid_Line_Item__r.Phoenix_Bid__r.Id, Product__r.Phoenix_Is_Control_Label__c,'+
                +' Vision_Bid_Line_Item__r.Phoenix_Bid__r.Name, Vision_Bid_Line_Item__r.Phoenix_Bid__r.Phoenix_Bid_Name__c, Market_Share_Expansion__r.Task_Status__c,'+
                +' Vision_Bid__r.Phoenix_Bid_Name__c, Vision_Bid__r.Name, '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c'+
                +' WHERE (Status__c = \'Matched\' or Status__c = \'Deleted in Bright\' or Status__c = \'Dropped\') and vision_is_discrepancy_product__c = false and  Opportunity__c =: opportunityId ORDER BY Name';
            List<Product_Opportunity__c> optyProdList = Database.query(query);
            
            wrapObj.optyProdList = optyProdList;
            String selContracts = optyObj.Vision_Reference_Contract__c;
            List<String> cntrNumList = new List<String>();
            if(String.isNotBlank(selContracts)){
                for(String cntr : selContracts.split(',')){
                    cntrNumList.add(cntr);
                }
            }
             //code added by srimayee for pharmabid start
          
           
            //code added by srimayee for pharmabid end
            
            if(cntrNumList.size() > 0){
                String query1 = 'SELECT Id,Name,Phoenix_Contract_Number__c FROM Phoenix_Contract__c WHERE Phoenix_Contract_Number__c=: cntrNumList';
                conractList = database.query(query1);
                wrapObj.refContractList = conractList;
            }
            wrapObj.isError = false;
            return wrapObj;
        }
        catch(exception e){
            wrapObj.isError = true;
            wrapObj.errorMessage = 'Exception while fetching data : '+e.getMessage()+' | Line: '+e.getLineNumber();
            return wrapObj;
        }
    }
   /* @auraEnabled
    public static List<showSecondaryCustWrapper> showSecondaryCustomers(Id prodId){
        system.debug('prodId=='+prodId);
        set<String> conNos = new set<String>();
        Map<String,String> contractsMap = new Map<String,String>();
        //  Map<Id,List<Phoenix_NPR_Data__c>> nprDataMap = new Map<Id,List<Phoenix_NPR_Data__c>>();
        Map<String,String> cptMap = new Map<String,String>();
        List<Phoenix_Inclusion_Contract_Pharmabid__c> InclusionContractsList= [SELECT Id, Customer_Number__c, Name, Group_Customer_Name__r.Name,Customer_Name__r.Name, Group_Customer_Number__c, Contract_Number__c FROM Phoenix_Inclusion_Contract_Pharmabid__c];
        for(Phoenix_Inclusion_Contract_Pharmabid__c con : InclusionContractsList){
            conNos.add(con.Contract_Number__c);
            contractsMap.put(con.Contract_Number__c,con.Customer_Name__r.Name);
        }
        set<String> uniqueNPRList =new set<String>();
        List<Phoenix_NPR_Data__c> nprData = [SELECT Id,Phoenix_Account__r.Name,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_Product__c,Phoenix_Contract_Number__c,Phoenix_Contract_Price__c,Phoenix_Awarded_Position__c,Phoenix_Product_Position__c, Phoenix_Material_Number__c  
                                             from Phoenix_NPR_Data__c where Phoenix_Product__c =: prodId AND Phoenix_Contract_Number__c IN:conNos AND Phoenix_NPR_Status__c ='Active'];
        system.debug('nprData=='+nprData.size());
        for(Phoenix_NPR_Data__c npr:nprData){
            String identifier = npr.Phoenix_Material_Number__c+'_'+npr.Phoenix_Contract_Number__c;
            system.debug('identifier=='+identifier);
            uniqueNPRList.add(identifier);
            
        }
        List<Vision_Customer_Product_Tracker__c> cptList = [SELECT Id, General_Category__c,Vision_Current_Product_Position__c,category__c,Vision_Unique_Identifier__c,Vision_Product_Code__c,Vision_Contract_Number__c from Vision_Customer_Product_Tracker__c where Vision_Unique_Identifier__c IN:uniqueNPRList];
        for(Vision_Customer_Product_Tracker__c cpt : cptList){
            system.debug('Vision_Unique_Identifier__c=='+cpt.Vision_Unique_Identifier__c);
            system.debug('General_Category__c=='+cpt.General_Category__c);
            cptMap.put(cpt.Vision_Unique_Identifier__c,cpt.General_Category__c);
        }
        List<showSecondaryCustWrapper> wrapperList = new List<showSecondaryCustWrapper>();
        //added by srimayee end
        
        for(Phoenix_NPR_Data__c npr : nprData){
            String identifier = npr.Phoenix_Material_Number__c+'_'+npr.Phoenix_Contract_Number__c;
                system.debug('cust====='+contractsMap.get(npr.Phoenix_Contract_Number__c)+'=='+cptMap.get(identifier));

            
            if(cptMap.get(identifier) == 'Secondary'){
                showSecondaryCustWrapper wrap = new showSecondaryCustWrapper();
                system.debug('cp=='+npr.Phoenix_Contract_Price__c);
                system.debug('npr.Phoenix_Account__r.Name=='+npr.Phoenix_Account__r.Name);
                system.debug('npr.Phoenix_Account__r.Name=='+npr.Phoenix_Account__r.Name);
                
                wrap.CustName = contractsMap.get(npr.Phoenix_Contract_Number__c); 
                system.debug('wrap.CustName=='+wrap.CustName);
                wrap.contractPrice = (npr.Phoenix_Account__r.Name ==  wrap.CustName && wrap.contractPrice < npr.Phoenix_Contract_Price__c) ? npr.Phoenix_Contract_Price__c :wrap.contractPrice ;
                system.debug('wrap cp=='+wrap.contractPrice);
                wrap.units = (npr.Phoenix_Account__r.Name ==  wrap.CustName && wrap.units < npr.Phoenix_12Months_Actual_Sales_Unit__c) ? npr.Phoenix_12Months_Actual_Sales_Unit__c :wrap.units;
                wrapperList.add(wrap);
            }
        }
        system.debug('wrapperList=='+wrapperList);
        for(showSecondaryCustWrapper wrap : wrapperList){
            system.debug('wrap=='+wrap);
        }
        return wrapperList;
    }*/
      @auraEnabled
    public static List<Phoenix_NPR_Data__c> showSecondaryCustomers(Id prodId){
        system.debug('prodId=='+prodId);
        set<String> conNos = new set<String>();
        Map<String,String> contractsMap = new Map<String,String>();
        //  Map<Id,List<Phoenix_NPR_Data__c>> nprDataMap = new Map<Id,List<Phoenix_NPR_Data__c>>();
        Map<String,String> cptMap = new Map<String,String>();
        List<Phoenix_Inclusion_Contract_Pharmabid__c> InclusionContractsList= [SELECT Id, Customer_Number__c, Name, Group_Customer_Name__r.Name,Customer_Name__r.Name, Group_Customer_Number__c, Contract_Number__c FROM Phoenix_Inclusion_Contract_Pharmabid__c];
        for(Phoenix_Inclusion_Contract_Pharmabid__c con : InclusionContractsList){
            conNos.add(con.Contract_Number__c);
            contractsMap.put(con.Contract_Number__c,con.Customer_Name__r.Name);
        }
        set<String> uniqueNPRList =new set<String>();
        List<Phoenix_NPR_Data__c> nprData = [SELECT Id,Phoenix_Account__r.Name,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_12Months_Sales_Unit__c,Phoenix_Product__c,Phoenix_Contract_Number__c,Phoenix_Contract_Price__c,Phoenix_Awarded_Position__c,Phoenix_Product_Position__c, Phoenix_Material_Number__c  
                                             from Phoenix_NPR_Data__c where Phoenix_Product__c =: prodId AND Phoenix_Contract_Number__c IN:conNos AND Phoenix_NPR_Status__c ='Active'];
        system.debug('nprData=='+nprData.size());
        for(Phoenix_NPR_Data__c npr:nprData){
            String identifier = npr.Phoenix_Material_Number__c+'_'+npr.Phoenix_Contract_Number__c;
            uniqueNPRList.add(identifier);
            
        }
        List<Vision_Customer_Product_Tracker__c> cptList = [SELECT Id, General_Category__c,Vision_Current_Product_Position__c,category__c,Vision_Unique_Identifier__c,Vision_Product_Code__c,Vision_Contract_Number__c from Vision_Customer_Product_Tracker__c where Vision_Unique_Identifier__c IN:uniqueNPRList];
        for(Vision_Customer_Product_Tracker__c cpt : cptList){
            cptMap.put(cpt.Vision_Unique_Identifier__c,cpt.General_Category__c);
        }

        //added by srimayee end
        List<Phoenix_NPR_Data__c> finalList= new List<Phoenix_NPR_Data__c>();
        for(Phoenix_NPR_Data__c npr : nprData){
            String identifier = npr.Phoenix_Material_Number__c+'_'+npr.Phoenix_Contract_Number__c;

            
            if(cptMap.get(identifier) == 'Secondary'){
                finalList.add(npr);
            }
        }
      
        return finalList;
    }
  
   /* public class showSecondaryCustWrapper{
        @AuraEnabled
        public String CustName;
        @AuraEnabled
        public Decimal contractPrice = 0;
        @AuraEnabled
        public Decimal units = 0;
        @AuraEnabled
        public Boolean isSelected;
        @AuraEnabled public List<showSecondaryCustWrapper> secondaryList;
        showSecondaryCustWrapper(){
            secondaryList = new List<showSecondaryCustWrapper>();
        }
    }*/
    @auraEnabled
    public static list<wrapperBidCheck> getOptyProd(Id opportunityId){
        list<wrapperBidCheck> wrapList = new List<wrapperBidCheck>();
        try{
            List<Phoenix_Contract__c> conractList = new List<Phoenix_Contract__c>();
            String query = 'SELECT Account.Name,Account.AccountNumber, Account.Phoenix_Is_OTC_Customer__c, '+Phoenix_Util.getsObjectFieds('Opportunity')+' FROM Opportunity WHERE Id=: opportunityId';
            Opportunity optyObj = Database.query(query);
            Boolean isPanMove = false;
            if(optyObj.Name.contains('MSEmove'))
                isPanMove = true;
            String selContracts = optyObj.Vision_Reference_Contract__c;
            query = 'SELECT GCP_Product_Family__r.Name, Product__r.Name, Product__r.ProductCode, Product__r.Phoenix_NDC_11__c, Product__r.Family, Product__r.Phoenix_Is_New_Product__c, Product__r.Product_Family__c, Product__r.Product_Family__r.Name, '+
                +'Product__r.Phoenix_Lowest_Price_SKU__c, Product__r.Phoenix_Strength__c, Product__r.Phoenix_Pkg_Size__c, Product__r.Phoenix_Is_Private_Label_OTC__c, Product__r.Phoenix_Rx_SRx_OTC__c,'+
                +' Product__r.Phoenix_WAC__c, Product__r.Phoenix_Product_Director__r.Name, Vision_Bid_Line_Item__r.Phoenix_Bid__r.Id, Product__r.Phoenix_Is_Control_Label__c,'+
                +' Vision_Bid_Line_Item__r.Phoenix_Bid__r.Name, Vision_Bid_Line_Item__r.Phoenix_Bid__r.Phoenix_Bid_Name__c, Market_Share_Expansion__r.Task_Status__c,'+
                +' Vision_Bid__r.Phoenix_Bid_Name__c, Vision_Bid__r.Name, '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c'+
                +' WHERE (Status__c = \'Matched\' or Status__c = \'Deleted in Bright\' or Status__c = \'Dropped\') and vision_is_discrepancy_product__c = false and  Opportunity__c =: opportunityId ORDER BY Name';
            List<Product_Opportunity__c> optyProdList = Database.query(query);
            Map<Id,Product_Opportunity__c> optyMap = new Map<Id, Product_Opportunity__c>();
            list<Id> prodIdList = new List<Id>();
            if(optyProdList.size()>0){
                List<Product_Opportunity__c> updateList = new List<Product_Opportunity__c>();
                Integer totalOptyVal = 0;
                for(Product_Opportunity__c optyProdObj : optyProdList){
                    optyProdObj.Proposed_Direct_Selling_Units__c = (optyProdObj.Proposed_Direct_Selling_Units__c != 0 && optyProdObj.Proposed_Direct_Selling_Units__c != null) ? optyProdObj.Proposed_Direct_Selling_Units__c : 0;
                    optyProdObj.Proposed_Indirect_Selling_Units__c = (optyProdObj.Proposed_Indirect_Selling_Units__c != 0 && optyProdObj.Proposed_Indirect_Selling_Units__c != null) ? optyProdObj.Proposed_Indirect_Selling_Units__c : 0;
                    optyProdObj.Vision_Proposed_OS_Units__c = (optyProdObj.Vision_Proposed_OS_Units__c != 0 && optyProdObj.Vision_Proposed_OS_Units__c != null) ? optyProdObj.Vision_Proposed_OS_Units__c : 0;
                    optyProdObj.Vision_Proposed_RAD_Units__c = (optyProdObj.Vision_Proposed_RAD_Units__c != 0 && optyProdObj.Vision_Proposed_RAD_Units__c != null) ? optyProdObj.Vision_Proposed_RAD_Units__c : 0;
                    optyProdObj.Vision_Proposed_WMT_Units__c = (optyProdObj.Vision_Proposed_WMT_Units__c != 0 && optyProdObj.Vision_Proposed_WMT_Units__c != null) ? optyProdObj.Vision_Proposed_WMT_Units__c : 0;
                    optyProdObj.Vision_Proposed_BASE_Units__c = (optyProdObj.Vision_Proposed_BASE_Units__c != 0 && optyProdObj.Vision_Proposed_BASE_Units__c != null) ? optyProdObj.Vision_Proposed_BASE_Units__c : 0;
                    optyProdObj.Vision_Proposed_DSH_Units__c = (optyProdObj.Vision_Proposed_DSH_Units__c != 0 && optyProdObj.Vision_Proposed_DSH_Units__c != null) ? optyProdObj.Vision_Proposed_DSH_Units__c : 0;
                    optyProdObj.Vision_Proposed_AutoSub_Units__c = (optyProdObj.Vision_Proposed_AutoSub_Units__c != 0 && optyProdObj.Vision_Proposed_AutoSub_Units__c != null) ? optyProdObj.Vision_Proposed_AutoSub_Units__c : 0;
                    optyProdObj.Vision_Proposed_Smith_Drug_Units__c = (optyProdObj.Vision_Proposed_Smith_Drug_Units__c != 0 && optyProdObj.Vision_Proposed_Smith_Drug_Units__c != null) ? optyProdObj.Vision_Proposed_Smith_Drug_Units__c : 0;
                    optyProdObj.Vision_Proposed_Anda_Units__c = (optyProdObj.Vision_Proposed_Anda_Units__c != 0 && optyProdObj.Vision_Proposed_Anda_Units__c != null) ? optyProdObj.Vision_Proposed_Anda_Units__c : 0;
                    optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c = (optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c != 0 && optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c != null) ? optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c : 0;
                    optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c = (optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c != 0 && optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c != null) ? optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c : 0;
                    optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c = (optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c != 0 && optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c != null) ? optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c : 0;
                    
                    optyProdObj.Vision_Proposed_Direct_ESI_Units__c = (optyProdObj.Vision_Proposed_Direct_ESI_Units__c != 0 && optyProdObj.Vision_Proposed_Direct_ESI_Units__c != null) ? optyProdObj.Vision_Proposed_Direct_ESI_Units__c : 0;
                    optyProdObj.Vision_Proposed_Indirect_ESI_Units__c = (optyProdObj.Vision_Proposed_Indirect_ESI_Units__c != 0 && optyProdObj.Vision_Proposed_Indirect_ESI_Units__c != null) ? optyProdObj.Vision_Proposed_Indirect_ESI_Units__c : 0;
                    optyProdObj.Vision_Proposed_Direct_Kroger_Units__c = (optyProdObj.Vision_Proposed_Direct_Kroger_Units__c != 0 && optyProdObj.Vision_Proposed_Direct_Kroger_Units__c != null) ? optyProdObj.Vision_Proposed_Direct_Kroger_Units__c : 0;
                    optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c = (optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c != 0 && optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c != null) ? optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c : 0;
                    optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c = (optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c != 0 && optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c != null) ? optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c : 0;
                    optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c = (optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c != 0 && optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c != null) ? optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c : 0;
                    optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c = (optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c != 0 && optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c != null) ? optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c : 0;
                    optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c = (optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c != 0 && optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c != null) ? optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c : 0;
                    optyProdObj.Vision_Proposed_Direct_Cordant_Units__c = (optyProdObj.Vision_Proposed_Direct_Cordant_Units__c != 0 && optyProdObj.Vision_Proposed_Direct_Cordant_Units__c != null) ? optyProdObj.Vision_Proposed_Direct_Cordant_Units__c : 0;
                    optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c = (optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c != 0 && optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c != null) ? optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c : 0;
                    optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c = (optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c != 0 && optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c != null) ? optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c : 0;
                    optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c = (optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c != 0 && optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c != null) ? optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c : 0;
                    
                    optyProdObj.Vision_Proposed_CVS_Direct_Units__c = (optyProdObj.Vision_Proposed_CVS_Direct_Units__c != 0 && optyProdObj.Vision_Proposed_CVS_Direct_Units__c != null) ? optyProdObj.Vision_Proposed_CVS_Direct_Units__c : 0;
                    optyProdObj.Vision_Proposed_CVS_Indirect_Units__c = (optyProdObj.Vision_Proposed_CVS_Indirect_Units__c != 0 && optyProdObj.Vision_Proposed_CVS_Indirect_Units__c != null) ? optyProdObj.Vision_Proposed_CVS_Indirect_Units__c : 0;
                    optyProdObj.Vision_Proposed_Cardinal_Units__c = (optyProdObj.Vision_Proposed_Cardinal_Units__c != 0 && optyProdObj.Vision_Proposed_Cardinal_Units__c != null) ? optyProdObj.Vision_Proposed_Cardinal_Units__c : 0;
                    optyProdObj.Vision_Proposed_Major_Units__c = (optyProdObj.Vision_Proposed_Major_Units__c != 0 && optyProdObj.Vision_Proposed_Major_Units__c != null) ? optyProdObj.Vision_Proposed_Major_Units__c : 0;
                    
                    optyProdObj.Vision_Total_Annual_Units__c =  optyProdObj.Proposed_Direct_Selling_Units__c+optyProdObj.Proposed_Indirect_Selling_Units__c+optyProdObj.Vision_Proposed_OS_Units__c+optyProdObj.Vision_Proposed_RAD_Units__c+optyProdObj.Vision_Proposed_WMT_Units__c+optyProdObj.Vision_Proposed_BASE_Units__c+optyProdObj.Vision_Proposed_DSH_Units__c+optyProdObj.Vision_Proposed_AutoSub_Units__c+optyProdObj.Vision_Proposed_Smith_Drug_Units__c+optyProdObj.Vision_Proposed_Anda_Units__c+optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c+optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c+optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c+optyProdObj.Vision_Proposed_Direct_ESI_Units__c+optyProdObj.Vision_Proposed_Indirect_ESI_Units__c+optyProdObj.Vision_Proposed_Direct_Kroger_Units__c+optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c+optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c+optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c+optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c+optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c+optyProdObj.Vision_Proposed_Direct_Cordant_Units__c+optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c+optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c+optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c+optyProdObj.Vision_Proposed_CVS_Direct_Units__c+optyProdObj.Vision_Proposed_CVS_Indirect_Units__c+optyProdObj.Vision_Proposed_Cardinal_Units__c+optyProdObj.Vision_Proposed_Major_Units__c;
                    Decimal totalOptyCal = 0;
                    //if(isPanMove)
                    //    totalOptyCal = (optyProdObj.Vision_Panorama_Target_Price__c != null && optyProdObj.Vision_Panorama_Target_Price__c != 0) ? optyProdObj.Vision_Panorama_Target_Price__c :
                    //((optyProdObj.Vision_Guidance_Price__c != null && optyProdObj.Vision_Guidance_Price__c != 0) ? optyProdObj.Vision_Guidance_Price__c : (optyProdObj.Product__r.Phoenix_Lowest_Price_SKU__c != null ? optyProdObj.Product__r.Phoenix_Lowest_Price_SKU__c : 0));
                    //   else
                    totalOptyCal = (optyProdObj.Vision_Guidance_Price__c != null && optyProdObj.Vision_Guidance_Price__c != 0) ? optyProdObj.Vision_Guidance_Price__c : (optyProdObj.Product__r.Phoenix_Lowest_Price_SKU__c != null ? optyProdObj.Product__r.Phoenix_Lowest_Price_SKU__c : 0);
                        optyProdObj.Vision_Opportunity_Value__c = optyProdObj.Vision_Total_Annual_Units__c * totalOptyCal;
                    totalOptyVal += Integer.valueOf(optyProdObj.Vision_Opportunity_Value__c);
                    updateList.add(optyProdObj);
                }
                update updateList;
                optyObj.Vision_Opportunity_Value__c = totalOptyVal;
                update optyObj;
                for(Product_Opportunity__c optyProdObj : updateList){
                    wrapperBidCheck wrapObj = new wrapperBidCheck();
                   /* if(optyObj.Account.AccountNumber == '164498'){
                       wrapObj.isSelected = true; 
                    }else{*/
                        wrapObj.isSelected = false;
                   // }
                    
                    if(optyProdObj.Vision_Bid_Line_Item__c != null || optyProdObj.Vision_Bid__c != null)
                    //if(optyProdObj.Status__c == 'Deleted in Bright')
                        wrapObj.hasBidLineItem = true;  
                    wrapObj.optyProdObj = optyProdObj;
                    wrapList.add(wrapObj);
                }
                List<String> cntrNumList = new List<String>();
                if(String.isNotBlank(selContracts)){
                    for(String cntr : selContracts.split(',')){
                        cntrNumList.add(cntr);
                    }
                }
                if(cntrNumList.size() > 0){
                    String query1 = 'SELECT Id,Name,Phoenix_Contract_Number__c FROM Phoenix_Contract__c WHERE Phoenix_Contract_Number__c=: cntrNumList';
                    conractList = database.query(query1);
                    wrapList[0].refContractList = conractList;
                }
                List<Phoenix_Bid__c> bidList = [SELECT Id, Name,Phoenix_OTB_Direct_Indirect__c 
                                                FROM Phoenix_Bid__c
                                                WHERE Phoenix_Customer__c =: optyObj.AccountId 
                                                AND Phoenix_Approval_Status__c = 'Draft'];
                if(bidList.size() > 0)
                    wrapList[0].showAddToBidButton = true;
            }
            else{
                wrapperBidCheck wrapObj = new wrapperBidCheck();
                wrapObj.isError = true;
                wrapObj.errorMessage = 'Products are not added to this Opportunity.';
                wrapList.add(wrapObj);
            }
            wrapList[0].oppObj = optyObj;
            wrapList[0].isError = false;
            wrapList[0].isPanMove = isPanMove;
            return wrapList;
        }
        catch(exception e){
            wrapperBidCheck wrapObj = new wrapperBidCheck();
            wrapObj.isError = true;
            wrapObj.errorMessage = 'Exception while fetching data : '+e.getMessage()+' | Line: '+e.getLineNumber();
            wrapList.add(wrapObj);
            return wrapList;
        }
    }
    
    @auraEnabled
    public static string fetchNprtData(list<Product_Opportunity__c> optyProdList, List<Phoenix_Contract__c> contractList, String templateType){//list<Product_Opportunity__c>
        try{
            set<String> selectrcs = new set<String>();
            for(Phoenix_Contract__c conObj : contractList){
                selectrcs.add(conObj.Id);
            }
            list < Phoenix_NPR_Data__c > NPRDataLines = [select id, Name, Phoenix_Contract_Number__c, Phoenix_Contract_Type__c, Phoenix_12Months_Actual_Sales_Unit__c, Phoenix_12Mt_Sales_Ut_Actual__c, Phoenix_Product_Position__c, Phoenix_Net_Sales_Internal__c, Phoenix_Dead_Net_Tracking_GR__c,
                                                         Phoenix_Contract_Price__c, Phoenix_Product__c, Phoenix_Product__r.ProductCode, Phoenix_Product__r.Name, Phoenix_12Months_Sales_Unit__c, Phoenix_12Months_Net_Sales__c, Phoenix_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Rebate__c, Phoenix_Rebate_G_N_Indicator__c,
                                                         Phoenix_Bonafied_G_N_Indicator__c, Phoenix_Fee_Bonafied_Fee__c, Phoenix_Per_Unit_Bonfied_Fee__c, Phoenix_CD__c, Phoenix_GR_TrackingTier__c
                                                         from Phoenix_NPR_Data__c where Phoenix_Contract__c IN: selectrcs and Phoenix_NPR_Status__c = 'Active'];
            map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
            for (Phoenix_NPR_Data__c NPRLine: NPRDataLines) {
                if (!productCodeToNPRLineMap.containsKey(NPRLine.Phoenix_Product__c))
                    productCodeToNPRLineMap.put(NPRLine.Phoenix_Product__c, new list < Phoenix_NPR_Data__c > ());
                productCodeToNPRLineMap.get(NPRLine.Phoenix_Product__c).add(NPRLine);
            }
            list<Product_Opportunity__c> updateList = new list<Product_Opportunity__c>();
            for(Product_Opportunity__c prodObj : optyProdList){
                if(productCodeToNPRLineMap.containsKey(prodObj.Product__c) && 
                   prodObj.Vision_Bid_Line_Item__c == null && prodObj.Vision_Bid__c == null ){
                       prodObj.X3Months_Annualized_Indirect_Selling_Uni__c = 0;
                       prodObj.X3_Months_Annualized_Direct_Selling_Unit__c = 0;
                       prodObj.X3_Months_Annualized_OS_And_RAD_Units__c = 0;
                       prodObj.X3_Months_Annualized_WMT_Direct_Units__c = 0;
                       prodObj.X3_Months_Annualized_WMT_Indirect_Units__c = 0;
                       prodObj.Vision_Current_Wholesaler_Units__c = 0;
                       prodObj.Vision_Current_Anda_Units__c = 0;
                       prodObj.Current_Retail_Indirect_Units__c = 0;
                       prodObj.Current_Retail_Direct_Units__c = 0;
                       prodObj.X3MonthAnnualCurrent_BASE_Selling_unit__c = 0;
                       prodObj.X3MonthAnnualCurrentDSHSellingUnit__c = 0;
                       prodObj.X3MonthAnnualCurrentAutoSubSellingUnit__c = 0;
                       prodObj.X3Months_AnnualizedCVS_DirectSelling_Uni__c = 0;
                       prodObj.X3MonthsAnnualizedCVSIndirectSelling_uni__c = 0;
                       prodObj.X3_Months_Annualized_Major_Selling_Unit__c = 0;
                       prodObj.X3Months_Annualized_Cardinal_Selling_Uni__c = 0;
                       
                       for(Phoenix_NPR_Data__c NPRLine:productCodeToNPRLineMap.get(prodObj.Product__c)){
                           if(templateType=='otcCx')
                               prodObj.X3_Months_Annualized_Direct_Selling_Unit__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                           else if((templateType=='Indirect' || templateType=='Direct and Indirect' || templateType=='Walgreens' || templateType=='ABC Progen' || templateType=='Econdisc'|| templateType== 'Costco' || templateType== 'Sams Club' || templateType== 'Net Indirect Pricing' || templateType== 'Government Pricing'|| templateType == 'Humana Indirect retail' || templateType == 'Humana Indirect CII') && NPRLine.Phoenix_Contract_Type__c=='Indirect')
                               prodObj.X3Months_Annualized_Indirect_Selling_Uni__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                           else if (templateType == 'ABC Pharmagen' && NPRLine.Phoenix_Contract_Type__c == 'Indirect' && NPRLine.Phoenix_Contract_Number__c == '3000000957')
                               prodObj.X3Months_Annualized_Indirect_Selling_Uni__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                           else if ((templateType == 'Direct' || templateType == 'Direct and Indirect' || templateType == 'Econdisc' || templateType == 'Net Indirect Pricing') && NPRLine.Phoenix_Contract_Type__c == 'Direct')
                                   prodObj.X3_Months_Annualized_Direct_Selling_Unit__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                           else if (templateType == 'ClarusOne') {
                               if (NPRLine.Phoenix_Contract_Number__c == '3000001263' || NPRLine.Phoenix_Contract_Number__c == '3000000224' || NPRLine.Phoenix_Contract_Number__c == '3000000418' || NPRLine.Phoenix_Contract_Number__c == '3000000047' || NPRLine.Phoenix_Contract_Number__c == '3000000071')
                                   prodObj.X3_Months_Annualized_OS_And_RAD_Units__c += (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                               if (NPRLine.Phoenix_Contract_Number__c == '1000000120')
                                   prodObj.X3_Months_Annualized_WMT_Direct_Units__c += (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                               if (NPRLine.Phoenix_Contract_Number__c == '3000000143')
                                   prodObj.X3_Months_Annualized_WMT_Indirect_Units__c += (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                           }
                           else if (templateType == 'RXSS') {
                               if (NPRLine.Phoenix_Contract_Type__c == 'Indirect') {
                                   if (NPRLine.Phoenix_Contract_Number__c == '3000000733')
                                       prodObj.Vision_Current_Wholesaler_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                                   if (NPRLine.Phoenix_Contract_Number__c == '3000001332')
                                       prodObj.Vision_Current_Anda_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                                   if (NPRLine.Phoenix_Contract_Number__c == '3000000734' || NPRLine.Phoenix_Contract_Number__c == '3000001173')
                                       prodObj.Current_Retail_Indirect_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                               }
                               if (NPRLine.Phoenix_Contract_Type__c == 'Direct' && NPRLine.Phoenix_Contract_Number__c == '1000000627')
                                   prodObj.Current_Retail_Direct_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                           }
                           else if (templateType == 'BASE/DSH') {
                               String baseContracts = System.Label.Base_Contracts;
                               String DSHContracts = System.Label.DSH_Contracts;
                               String autoSubContracts = System.Label.Auto_Sub_Contracts;
                               if (baseContracts.contains(NPRLine.Phoenix_Contract_Number__c))
                                   prodObj.X3MonthAnnualCurrent_BASE_Selling_unit__c += NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0;
                               if (DSHContracts.contains(NPRLine.Phoenix_Contract_Number__c))
                                   prodObj.X3MonthAnnualCurrentDSHSellingUnit__c += NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0;
                               if (autoSubContracts.contains(NPRLine.Phoenix_Contract_Number__c))
                                   prodObj.X3MonthAnnualCurrentAutoSubSellingUnit__c += NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0;
                           }
                           else if (templateType == 'ROS') {
                               if (NPRLine.Phoenix_Contract_Number__c == '1000000449') 
                                   prodObj.X3Months_AnnualizedCVS_DirectSelling_Uni__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                               if (NPRLine.Phoenix_Contract_Number__c == '3000000489')
                                   prodObj.X3Months_Annualized_Cardinal_Selling_Uni__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                               if (NPRLine.Phoenix_Contract_Number__c == '3000000753') 
                                   prodObj.X3_Months_Annualized_Major_Selling_Unit__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                               if (NPRLine.Phoenix_Contract_Number__c == '3000000485' || NPRLine.Phoenix_Contract_Number__c == '3000000484' 
                                   || NPRLine.Phoenix_Contract_Number__c == '3000000483')
                                   prodObj.X3MonthsAnnualizedCVSIndirectSelling_uni__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                           }
                       }
                   }
                else if(prodObj.Vision_Bid_Line_Item__c == null && prodObj.Vision_Bid__c == null){
                    prodObj.X3Months_Annualized_Indirect_Selling_Uni__c = 0;
                    prodObj.X3_Months_Annualized_Direct_Selling_Unit__c = 0;
                    prodObj.X3_Months_Annualized_OS_And_RAD_Units__c = 0;
                    prodObj.X3_Months_Annualized_WMT_Direct_Units__c = 0;
                    prodObj.X3_Months_Annualized_WMT_Indirect_Units__c = 0;
                    prodObj.Vision_Current_Wholesaler_Units__c = 0;
                    prodObj.Vision_Current_Anda_Units__c = 0;
                    prodObj.Current_Retail_Indirect_Units__c = 0;
                    prodObj.Current_Retail_Direct_Units__c = 0;
                    prodObj.X3MonthAnnualCurrent_BASE_Selling_unit__c = 0;
                    prodObj.X3MonthAnnualCurrentDSHSellingUnit__c = 0;
                    prodObj.X3MonthAnnualCurrentAutoSubSellingUnit__c = 0;
                    prodObj.X3Months_AnnualizedCVS_DirectSelling_Uni__c = 0;
                    prodObj.X3MonthsAnnualizedCVSIndirectSelling_uni__c = 0;
                    prodObj.X3_Months_Annualized_Major_Selling_Unit__c = 0;
                    prodObj.X3Months_Annualized_Cardinal_Selling_Uni__c = 0;
                }
                updateList.add(prodObj);
            }
            update updateList;
            return 'SUCCESS';//updateList;
        }
        catch(exception e){
            system.debug('ERROR --> '+e.getMessage()+' Line : '+e.getLineNumber());
            return 'ERROR --> '+e.getMessage()+' Line : '+e.getLineNumber();
        }
    }
    
    
    @auraEnabled
    public Static string deleteOptyProd(String optyProdId){
        String returnString = '';
        try{
            Product_Opportunity__c prodOpty = [SELECT Id, Name FROM Product_Opportunity__c WHERE Id=: optyProdId];
            delete prodOpty;
            return 'SUCCESS : Product has been removed!';
        }
        catch(exception e){
            return 'ERROR : Unable to Delete the Product. Exception : '+e.getMessage();
        }
    }
    
    @auraEnabled
    public static List<Phoenix_Bid__c> getOpenBids(String customerId, String bidType){
        List<Phoenix_Bid__c> bidList = [SELECT Id, Name, Phoenix_Bid_Name__c, Phoenix_Approval_Status__c,Phoenix_Bid_Type__c,Phoenix_OTB_Direct_Indirect__c,
                                        CreatedDate, createdBy.Name FROM Phoenix_Bid__c 
                                        WHERE Phoenix_Customer__c =: customerId 
                                        AND Phoenix_Approval_Status__c = 'Draft' AND Phoenix_Bid_Type__c =: bidType ORDER BY CreatedDate DESC];
        return bidList;
    }
    
    @AuraEnabled
    public static Phoenix_Bid__c sendToBrightExistingBid(Id opportunityId, Id selectedBidId ,string wraplist){
        list<wrapperBidCheck> wrapperList = (List<wrapperBidCheck>) JSON.deserialize(wraplist,List<wrapperBidCheck>.class);
        if(opportunityId != null && wrapperList.size()>0){
            BidWrapper bwr = new BidWrapper();
            List<Id> matchedPrdIds = new List<Id>();
            String query = 'SELECT Account.Phoenix_Customer_Class_Bid_Template__c, Account.Phoenix_Is_Bid_Account__c, '+Phoenix_Util.getsObjectFieds('Opportunity')+' FROM Opportunity WHERE Id=: opportunityId';
            Opportunity opp = Database.query(query);
            query = 'SELECT '+Phoenix_Util.getsObjectFieds('Phoenix_Bid__c')+' FROM Phoenix_Bid__c WHERE Id=: selectedBidId';
            Phoenix_Bid__c bidRec = database.query(query);
            return bidRec;
        }
        else
            return null;//'Opportunity Id is null';
    }
    
    @AuraEnabled
    public static Phoenix_Bid__c sendToBrightFunc(Id opportunityId, string wraplist, String bidType, boolean isOtcProdFam){
        try{
            list<wrapperBidCheck> wrapperList = (List<wrapperBidCheck>) JSON.deserialize(wraplist,List<wrapperBidCheck>.class);
            if(opportunityId != null && wrapperList.size()>0)
            {
                BidWrapper bwr = new BidWrapper();
                List<Id> matchedPrdIds = new List<Id>();
                String query = 'SELECT Account.Phoenix_Customer_Class_Bid_Template__c, Account.Phoenix_Is_Bid_Account__c,  Account.Phoenix_Is_OTC_Customer__c, Account.ownerid, '+Phoenix_Util.getsObjectFieds('Opportunity')+' FROM Opportunity WHERE Id=: opportunityId';
                Opportunity opp = Database.query(query);
                if(opp.Account.Phoenix_Is_Bid_Account__c==true){
                    bwr.bid.Phoenix_Bid_Name__c = opp.Name;
                    bwr.bid.Phoenix_Proactive_Reactive__c = opp.Vision_Type__c;
                    bwr.bid.Phoenix_Internal_Target_Date__c = opp.Vision_Internal_Closing_Date__c;
                    bwr.bid.Phoenix_Bid_Deadline_Date__c = opp.Vision_Customer_Closing_Date__c;
                    bwr.bid.Phoenix_Customer__c = opp.AccountId;
                    bwr.bid.Phoenix_Contact__c = opp.Contact__c;
                    bwr.bid.Phoenix_Comments__c = opp.Vision_Comments__c != null ? opp.Vision_Comments__c : '';
                    if(opp.Vision_Previous_Bid__c != null){
                        Phoenix_Bid__c bidRec = [SELECT Id, Name,Phoenix_OTB_Direct_Indirect__c, Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =: opp.Vision_Previous_Bid__c];
                        bwr.bid.Phoenix_Previous_Bid__c = opp.Vision_Previous_Bid__c;
                        bwr.bid.Phoenix_Is_Re_Bid__c = true;
                        bwr.bid.Phoenix_Bid_Type__c = bidRec.Phoenix_Bid_Type__c;
                    }
                    else{
                        if(bidType == 'RFP')
                            bidType = 'RFP Bids';
                        else if(bidType == 'Volume Review')
                            bidType = 'Volume Review Only';
                        bwr.bid.Phoenix_Bid_Type__c = bidType;
                    }
                    if(isOtcProdFam){
                        bwr.bid.Phoenix_is_OTC_Bid__c = true;
                        bwr.bid.Phoenix_Customer_Type__c = 'OTC Customer';
                        //if(bidType.contains('RFP'))
                        //    bwr.bid.Phoenix_Bid_Type__c = 'OTC RFP';
                        // else
                        //   bwr.bid.Phoenix_Bid_Type__c = bidType.contains('Launch') ? 'OTC New Product' : 'OTC '+bidType;
                    }
                    else{
                        bwr.bid.Phoenix_Customer_Type__c = opp.Vision_Bid_Template__c;
                        if(opp.Account.Phoenix_Customer_Class_Bid_Template__c == 'Direct or Indirect')
                            bwr.bid.Phoenix_Template_Type_GSMS__c = opp.Vision_Bid_Template__c == 'Direct' ? 'Direct' : 'Indirect';
                        else if(opp.Account.Phoenix_Customer_Class_Bid_Template__c == 'Humana')
                            bwr.bid.Phoenix_Template_Type_Humana__c = opp.Vision_Bid_Template__c;
                        else if(opp.Account.Phoenix_Customer_Class_Bid_Template__c == 'ROS')
                            bwr.bid.Phoenix_Template_Type_ROS__c = opp.Vision_Bid_Template__c;
                        else if(opp.Account.Phoenix_Customer_Class_Bid_Template__c == 'ABC Progen' || opp.Account.Phoenix_Customer_Class_Bid_Template__c == 'ABC Pharmagen')
                            bwr.bid.Phoenix_Template_Type__c = opp.Vision_Bid_Template__c;
                    }
                    bwr.bid.Phoenix_OTB_Marketing_Approver__c = UserInfo.getUserId();
                    bwr.bid.Phoenix_OTB_Direct_Indirect__c = opp.Vision_Bid_Template__c != null ? opp.Vision_Bid_Template__c : '';
                    bwr.bid.Phoenix_Reference_Contracts__c = opp.Vision_Reference_Contract__c != null ? opp.Vision_Reference_Contract__c : '';
                    bwr.bid.Opportunity__c = opp.Id;
                    bwr.bid.Phoenix_Salesperson__c = opp.Account.ownerid;
                    list < RecordType > rectypes = [select Id, Name from RecordType where sObjectType = 'Phoenix_Bid__C'];
                    Id recId;
                    for(RecordType recType : rectypes){
                        if(recId == null && (recType.Name.toLowercase() == bwr.bid.Phoenix_Bid_Type__c.toLowercase()))
                            recId = recType.Id;
                    }
                    if(recId != null)
                        bwr.bid.RecordTypeId = recId;
                    insert bwr.bid;
                    bwr.isBidCreated = true;
                    List < string > selectrcs = new List < string >();
                    opp.StageName = 'Sent to BRIGHT';
                    opp.Bid__c = bwr.bid.Id;
                    update opp;
                    return bwr.bid;
                }
                else
                    return null;//JSON.serialize(new Map<String,Id>{'BidId' => null});
            }
            else
                return null;
        }
        catch(exception e){
            Phoenix_Util.recordException(e,'Vision_SendToBrightCtrl','sendToBrightFunc',''+' line Number : '+e.getLineNumber()); 
            return null;
        }
    }
    
    @AuraEnabled
    public static string addBidLinesToBid(Phoenix_Bid__c bidRec, List<Product_Opportunity__c> optyProdList, String bidType, boolean syncToAnalysis){
        try{
            List<Id> matchedPrdIds = new List<Id>();
            Map<Id,Product_Opportunity__c> prdOptyItems = new Map<Id,Product_Opportunity__c>();
            List<String> optyProdIds = new List<String>();
            for(Product_Opportunity__c prdOpty : optyProdList){
                optyProdIds.add(prdOpty.Id);
                matchedPrdIds.add(prdOpty.Product__c);
                prdOptyItems.put(prdOpty.Product__c,prdOpty);
            }
            list < Product2 > prodList = [select Id, Product_Family__c, Phoenix_NDC_11_Dashes__c,Phoenix_NDC_11__c,ProductCode,Phoenix_Pkg_Size__c,Phoenix_Case_Pack__c, Phoenix_Minimum_Order_Quantity__c,Family,Phoenix_Direct_Order_Price__c,Phoenix_Compare_to_Brand_Name__c,
                                          Phoenix_Approved_Lowest_Price_SKU__c,Phoenix_Product_Director__c,Phoenix_Product_Director__r.FirstName, Phoenix_Product_Director__r.LastName,Phoenix_Orange_Book_Rating__c,Phoenix_Throughput_cost__c,
                                          Phoenix_WAC__c,Phoenix_Current_Budgeted_ASP__c,Phoenix_Lowest_Price_SKU__c,Phoenix_Comm_Exps__c, Phoenix_PS_Partner_1_Name__r.Name,Phoenix_PS_Partner_1__c,Phoenix_PS_Partner_2_Name__r.Name,
                                          Phoenix_PS_Partner_2__c,Phoenix_Royalty_Partner_Name__r.Name ,Phoenix_Royalty__c,Phoenix_Per_Unit_Profit_Partner_2__c, Phoenix_Per_Unit_Profit_Partner_1__c,Phoenix_UPC_Universal_Product_Code__c,Phoenix_IPA_Floor_Price__c,
                                          Phoenix_Latest_Estimate__c,Phoenix_REMS__c,Phoenix_Medicaid_Per_Unit__c,Phoenix_Return_Per_Unit__c, Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Supply_Chain_Planner__c from Product2 where Id in: matchedPrdIds];
            list < Phoenix_Bid_Line_Item__c > newItems = new list < Phoenix_Bid_Line_Item__c > ();
            list < Phoenix_Bid_Fee_Master__c > feeList = new list < Phoenix_Bid_Fee_Master__c > ();
            list < Phoenix_Bid_Fee_Master__c > feeListRos = new list < Phoenix_Bid_Fee_Master__c > ();
            list < Phoenix_Bid_Fee_Master__c > feeListForRos = new list < Phoenix_Bid_Fee_Master__c > ();
            list<Phoenix_BidLineItemExtn__c> bidLineItemExtList = new List<Phoenix_BidLineItemExtn__c> ();
            list<String> shareExpanIds = new list<String>();
            string bidId = bidRec.Id;
            Id accountId = bidRec.Phoenix_Customer__c;
            Account acc=new Account();
            String templateType = bidRec.Phoenix_Customer_Type__c;
            if (accountId != null) {
                acc = database.query('SELECT '+Phoenix_Util.getsObjectFieds('Account')+' FROM Account WHERE Id =: accountId');
                feeList = [select Id, Phoenix_Customer_Type__c, Phoenix_Fee__c, Phoenix_Preferred_Wholesaler__c, Phoenix_Fee_Type__c, Phoenix_Product_Type_for_CM_Fee__c from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c =: acc.Phoenix_Preferred_Wholesaler__c limit 30000];
            }
            if(templateType == 'ROS')
                feeListRos = [select Id, Phoenix_Customer_Type__c, Phoenix_Fee__c, Phoenix_Preferred_Wholesaler__c, Phoenix_Fee_Type__c, Phoenix_Product_Type_for_CM_Fee__c
                              from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c = 'McKesson' limit 30000];
            if(templateType == 'ROS' || acc.AccountNumber == '370337')
                feeListForRos = [select Id, Phoenix_Customer_Type__c, Phoenix_Fee__c, Phoenix_Preferred_Wholesaler__c, Phoenix_Fee_Type__c, Phoenix_Product_Type_for_CM_Fee__c from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c = 'Cardinal' AND Phoenix_Fee_Type__c = 'RDC/NLC %' limit 30000];
            for (Product2 prd: prodList) {
                prd.Phoenix_WAC__c = prd.Phoenix_WAC__c != null ? prd.Phoenix_WAC__c : 0;
                Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c();
                pbl.Phoenix_Bid__c = bidId;
                pbl.Phoenix_Product__c = prd.Id;
                pbl.Phoenix_NDC__c = prd.Phoenix_NDC_11_Dashes__c;
                pbl.Phoenix_NDC_Without_Dashes__c = prd.Phoenix_NDC_11__c;
                pbl.Phoenix_Product_Code1__c = prd.ProductCode;
                pbl.Phoenix_Pkg_Size1__c = prd.Phoenix_Pkg_Size__c;
                pbl.Phoenix_Case_Pack1__c = prd.Phoenix_Case_Pack__c;
                pbl.Phoenix_MOQ1__c = prd.Phoenix_Minimum_Order_Quantity__c;
                pbl.Phoenix_Product_Family1__c = prd.Family;
                pbl.Product_Family__c = prd.Product_Family__c;
                pbl.Phoenix_Direct_Order_Price1__c = prd.Phoenix_Direct_Order_Price__c;
                pbl.Phoenix_Compare_To_Brand_Name1__c = prd.Phoenix_Compare_to_Brand_Name__c;
                pbl.Phoenix_Approved_Lowest_Price_SKU__c = prd.Phoenix_Approved_Lowest_Price_SKU__c;
                pbl.Phoenix_Supply_Chain_Planner__c = prd.Phoenix_Supply_Chain_Planner__c;
                if(prdOptyItems.containsKey(prd.Id)){
                    Product_Opportunity__c prdOptyItem = prdOptyItems.get(prd.Id);
                    pbl.Vision_UOM__c = prdOptyItem.Vision_UOM__c;
                    pbl.Phoenix_Comments__c = prdOptyItem.Vision_Customer_Comments__c;
                    pbl.Product_Opportunity__c = prdOptyItem.Id;
                    pbl.Phoenix_Sales_Notes__c = prdOptyItem.Sales_Notes__c;
                    
                    
                    //Fields Added by BV
                     pbl.Vision_scm_manager__c = prdOptyItem.Vision_scm_manager__c;
                     pbl.Vision_scm_approved_date__c = prdOptyItem.Vision_scm_approved_date__c;
                     pbl.Vision_supply_requirement__c = prdOptyItem.Vision_supply_requirement__c;
                     pbl.Vision_confidence_level__c = prdOptyItem.Vision_confidence_level__c;
                     pbl.Vision_customer_expectation_lead_time__c = prdOptyItem.Vision_customer_expectation_lead_time__c;
                     pbl.Vision_supply_effectivedate_SCM__c = prdOptyItem.Vision_supply_effectivedate_SCM__c;
                     pbl.Vision_remarks_by_pm__c = prdOptyItem.Vision_remarks_by_pm__c;
                     pbl.Vision_remarks_by_scm__c = prdOptyItem.Vision_remarks_by_scm__c;
                     pbl.Vision_total_incremental_volume_by_scm__c = prdOptyItem.Vision_total_incremental_volume_by_scm__c;
                     pbl.Vision_total_initial_order_quantity_by_s__c = prdOptyItem.Vision_total_initial_order_quantity_by_s__c;
                     pbl.Vision_supply_duration_scm__c = prdOptyItem.Vision_supply_duration_scm__c;
                     pbl.Vision_sku_split_flag__c = prdOptyItem.Vision_sku_split_flag__c;
                     pbl.Vision_incremental_volume_by_scm__c = prdOptyItem.Vision_incremental_volume_by_scm__c;
                     pbl.Vision_initialorder_volume_by_scm__c = prdOptyItem.Vision_initialorder_volume_by_scm__c;
                   // Vision_initialorder_volume_by_scm__c = Vision_initialorder_volume_by_scm__c
                     pbl.Vision_india_scm_approved_by__c = prdOptyItem.Vision_india_scm_approved_by__c;
                     pbl.Vision_india_scm_approved_on_date__c = prdOptyItem.Vision_india_scm_approved_on_date__c;
                     pbl.Vision_india_scm_remarks__c = prdOptyItem.Vision_india_scm_remarks__c;
                     pbl.Vision_ext_mfg_scm_approved_by__c = prdOptyItem.Vision_ext_mfg_scm_approved_by__c;
                     pbl.Vision_ext_mfg_scm_approved_on_date__c = prdOptyItem.Vision_ext_mfg_scm_approved_on_date__c;
                     pbl.Vision_ext_mfg_scm_remarks__c = prdOptyItem.Vision_ext_mfg_scm_remarks__c;
                    //Fields Ended By BV
                   
                    
                    
                    if(bidRec.Phoenix_Customer_Type__c == 'ClarusOne'){
                        pbl.Phoenix_Proposed_OS_Units__c = prdOptyItem.Vision_Proposed_OS_Units__c;
                        pbl.Phoenix_Proposed_RAD_Units__c = prdOptyItem.Vision_Proposed_RAD_Units__c;
                        pbl.Phoenix_Proposed_WMT_Units__c = prdOptyItem.Vision_Proposed_WMT_Units__c;
                    }
                    else if(bidRec.Phoenix_Customer_Type__c == 'BASE/DSH'){
                        pbl.Phoenix_Proposed_Smith_Drug_Units__c = prdOptyItem.Vision_Proposed_BASE_Units__c;
                        pbl.Phoenix_Proposed_Anda_Units__c = prdOptyItem.Vision_Proposed_DSH_Units__c;
                        pbl.Phoenix_ProposedDirectAholdDelhaizeUnits__c = prdOptyItem.Vision_Proposed_AutoSub_Units__c;
                    }
                    else if(bidRec.Phoenix_Customer_Type__c == 'RXSS'){
                        pbl.Phoenix_Proposed_Smith_Drug_Units__c = prdOptyItem.Vision_Proposed_Smith_Drug_Units__c;
                        pbl.Phoenix_Proposed_Anda_Units__c = prdOptyItem.Vision_Proposed_Anda_Units__c;
                        pbl.Phoenix_ProposedDirectAholdDelhaizeUnits__c = prdOptyItem.Vision_Proposed_DirectAholdDelhaizeUnits__c;
                        pbl.Phoenix_ProposedDirectGaintEagleUnits__c = prdOptyItem.Vision_Proposed_Direct_Gaint_Eagle_Units__c;
                        pbl.Phoenix_ProposedIndirectAholdDelhaizeUni__c = prdOptyItem.Vision_Proposed_TotalRetailIndirectUnits__c;
                        pbl.Phoenix_Others_Direct__c = prdOptyItem.Proposed_Direct_Selling_Units__c != null ? prdOptyItem.Proposed_Direct_Selling_Units__c :0;
                        pbl.Phoenix_Others_Indirect__c = prdOptyItem.Proposed_Indirect_Selling_Units__c != null ? prdOptyItem.Proposed_Indirect_Selling_Units__c :0;
                    }
                    else if(bidRec.Phoenix_Customer_Type__c == 'Econdisc'){
                        pbl.Phoenix_Direct_ESI__c = prdOptyItem.Vision_Proposed_Direct_ESI_Units__c;
                        pbl.Phoenix_Indirect_ESI__c = prdOptyItem.Vision_Proposed_Indirect_ESI_Units__c;
                        pbl.Phoenix_Direct_Kroger__c = prdOptyItem.Vision_Proposed_Direct_Kroger_Units__c;
                        pbl.Phoenix_Indirect_Kroger__c = prdOptyItem.Vision_Proposed_Indirect_Kroger_Units__c;
                        pbl.Phoenix_Direct_Rx_Outreach__c = prdOptyItem.Vision_Proposed_Direct_Rx_Outreach_Units__c;
                        pbl.Phoenix_Indirect_Rx_Outreach__c = prdOptyItem.Vision_Proposed_IndirectRxOutreach_Units__c;
                        pbl.Phoenix_Direct_Supervalu__c = prdOptyItem.Vision_Proposed_Direct_Supervalu_Units__c;
                        pbl.Phoenix_Indirect_Supervalu__c = prdOptyItem.Vision_Proposed_Indirect_Supervalu_Units__c;
                        pbl.Phoenix_Direct_Cordant__c = prdOptyItem.Vision_Proposed_Direct_Cordant_Units__c;
                        pbl.Phoenix_Indirect_Cordant__c = prdOptyItem.Vision_Proposed_Indirect_Cordant_Units__c;
                        pbl.Phoenix_Direct_Cigna__c = prdOptyItem.Vision_Proposed_Direct_Cigna_Units__c;
                        pbl.Phoenix_Indirect_Cigna__c = prdOptyItem.Vision_Proposed_Indirect_Cigna_Units__c;
                        pbl.Phoenix_Indirect_Accerodo__c = prdOptyItem.Vision_Proposed_Indirect_Accerodo_Units__c;
                        pbl.Phoenix_Direct_Accerodo__c = prdOptyItem.Vision_Proposed_Direct_Accerodo_Units__c;
                        pbl.Phoenix_Others_Direct__c = prdOptyItem.Proposed_Direct_Selling_Units__c != null ? prdOptyItem.Proposed_Direct_Selling_Units__c :0;
                        pbl.Phoenix_Others_Indirect__c = prdOptyItem.Proposed_Indirect_Selling_Units__c != null ? prdOptyItem.Proposed_Indirect_Selling_Units__c :0;
                    }
                    else if(bidRec.Phoenix_Customer_Type__c == 'OTC Customer'){
                        pbl.Phoenix_12_Months_IndirectSaleUnit__c = prdOptyItem.Vision_Proposed_Units__c;
                        pbl.Phoenix_Date_Fee__c = prdOptyItem.Vision_Proposed_Share_Percentage__c;
                    }
                    else{
                        pbl.Phoenix_Proposed_Indirect_Selling_Unit__c = prdOptyItem.Proposed_Indirect_Selling_Units__c != null ? prdOptyItem.Proposed_Indirect_Selling_Units__c :0;
                        pbl.Phoenix_Proposed_Direct_Selling_Unit__c = prdOptyItem.Proposed_Direct_Selling_Units__c != null ? prdOptyItem.Proposed_Direct_Selling_Units__c :0;
                    }
                    pbl.Phoenix_Guidance_Price__c = prdOptyItem.Vision_Guidance_Price__c;
                    if(bidRec.Phoenix_Bid_Type__c == 'Platform OTB'){
                        pbl.Final_Exclusion_Customers__c = prdOptyItem.Final_Exclusion_Customers__c;
                        pbl.Primary_Exclusion_Customers__c = prdOptyItem.Primary_Exclusion_Customers__c;
                        pbl.Secondary_Backup_Exclusion_Customers__c = prdOptyItem.Secondary_Backup_Exclusion_Customers__c;
                        pbl.Minimum_Order_Quantity__c= prdOptyItem.Minimum_Order_Quantity__c;
                        pbl.Phoenix_Batch_Number__c= prdOptyItem.Batch_Number__c;
                        if(prdOptyItem.Expiry_Date__c != null)
                        pbl.Phoenix_Expiry_Date__c= Date.parse(prdOptyItem.Expiry_Date__c);
                        if(prdOptyItem.Vision_Guidance_Price__c != null)
                        pbl.Phoenix_Marketing_Approval__c = 'Approved';
                    }
                    if(bidRec.Phoenix_OTB_Direct_Indirect__c == 'Direct'){
                        pbl.Phoenix_ProposedContractBidPriceMktng__c = prdOptyItem.Vision_Guidance_Price__c;    
                    }else{
                        pbl.Phoenix_Wholesaler_Diff_Price_Indirect__c = prdOptyItem.Vision_Guidance_Price__c > 0 ? prdOptyItem.Vision_Guidance_Price__c:null;// checked >0 by satya
                        
                    }
                    pbl.Phoenix_Retail_Direct_Guidance_Price__c = prdOptyItem.Vision_Guidance_Price__c;
                    if(prdOptyItem.Market_Share_Expansion__c != null)
                        shareExpanIds.add(prdOptyItem.Market_Share_Expansion__c);
                }
                pbl.Phoenix_Is_Re_Bid_Line_Item__c = bidRec.Phoenix_Is_Re_Bid__c != null ? bidRec.Phoenix_Is_Re_Bid__c : false;
                if (prd.Phoenix_Product_Director__c != null)
                    pbl.Phoenix_Product_Director1__c = prd.Phoenix_Product_Director__r.FirstName + ' ' + prd.Phoenix_Product_Director__r.LastName;
                pbl.Phoenix_Orange_Book_Rating1__c = prd.Phoenix_Orange_Book_Rating__c;
                if (prd.Phoenix_Throughput_cost__c != null) pbl.Phoenix_Throughput_Cost1__c = prd.Phoenix_Throughput_cost__c.setScale(2);
                pbl.Phoenix_WAC1__c = prd.Phoenix_WAC__c;
                pbl.Phoenix_Budgeted_ASP1__c = prd.Phoenix_Current_Budgeted_ASP__c;
                pbl.Phoenix_Lowest_Price_SKU1__c = prd.Phoenix_Lowest_Price_SKU__c;
                pbl.Phoenix_Comm_Exps1__c = prd.Phoenix_Comm_Exps__c;
                if (prd.Phoenix_PS_Partner_1_Name__r.Name != null)
                    pbl.Phoenix_PS_Partner_11__c = prd.Phoenix_PS_Partner_1_Name__r.Name;
                pbl.Phoenix_PS_Partner_1percent__c = prd.Phoenix_PS_Partner_1__c;
                if (prd.Phoenix_PS_Partner_2_Name__r.Name != null)
                    pbl.Phoenix_PS_Partner_21__c = prd.Phoenix_PS_Partner_2_Name__r.Name;
                pbl.Phoenix_PS_Partner_2percent__c = prd.Phoenix_PS_Partner_2__c;
                if (prd.Phoenix_Royalty_Partner_Name__r.Name != null)
                    pbl.Phoenix_Royalty_Partner_Name1__c = prd.Phoenix_Royalty_Partner_Name__r.Name;
                pbl.Phoenix_Royaltypercent__c = prd.Phoenix_Royalty__c;
                pbl.Phoenix_Min_profit_share_Partner_21__c = prd.Phoenix_Per_Unit_Profit_Partner_2__c;
                pbl.Phoenix_Min_profit_share_Partner_11__c = prd.Phoenix_Per_Unit_Profit_Partner_1__c;
                pbl.Phoenix_UPC_Universal_Product_Code__c = prd.Phoenix_UPC_Universal_Product_Code__c;
                pbl.Phoenix_IPA_Floor_Price1__c = prd.Phoenix_IPA_Floor_Price__c;
                pbl.Phoenix_UPC_Universal_Product_Code__c = prd.Phoenix_UPC_Universal_Product_Code__c;
                pbl.Phoenix_Latest_Estimate__c= prd.Phoenix_Latest_Estimate__c!=null?prd.Phoenix_Latest_Estimate__c.setScale(2):0;
                pbl.Phoenix_REMS__c = prd.Phoenix_REMS__c;
                decimal mediciadReturns = prd.Phoenix_Medicaid_Per_Unit__c != null ? prd.Phoenix_Medicaid_Per_Unit__c : 0;
                decimal returnPerUnit = prd.Phoenix_Return_Per_Unit__c != null ? prd.Phoenix_Return_Per_Unit__c : 0;
                pbl.Phoenix_Estimated_Medicaid_Returns__c = mediciadReturns.setScale(2) + returnPerUnit.setScale(2);
                if (bidRec.Phoenix_Bid_Type__c == 'Short Dated OTB' || bidRec.Phoenix_Bid_Type__c == 'Good Dated OTB')
                    pbl.Phoenix_Estimated_Medicaid_Returns__c = mediciadReturns;
                if (accountId != null) {
                    pbl.Phoenix_Current_Rebate__c = acc.Phoenix_Rebates__c;
                    pbl.Phoenix_Rebate_G_N__c = acc.Rebate_Type__c;
                    pbl.Phoenix_Fee_G_N__c= acc.Fee_Type__c;
                }
                if (templateType == 'ROS' && feeListRos.size() > 0) {
                    for(Phoenix_Bid_Fee_Master__c pbf: feeListRos){
                        if(pbf.Phoenix_Fee_Type__c=='RDC/NLC %'){
                            pbl.Phoenix_RDC_NLC__c = pbf.Phoenix_Fee__c !=null ? prd.Phoenix_WAC__c * (pbf.Phoenix_Fee__c/100) : 0;
                            if(feeListForRos.size()!=0){
                                pbl.Phoenix_NLC__c = feeListForRos[0].Phoenix_Fee__c !=null ? prd.Phoenix_WAC__c * (feeListForRos[0].Phoenix_Fee__c/100) : 0;
                                pbl.Phoenix_Proposed_Current_Rebate__c = feeListForRos[0].Phoenix_Fee__c;
                            }
                        }
                    }
                }
                if (feeList.size() > 0) {
                    for(Phoenix_Bid_Fee_Master__c pbf: feeList){
                        if(prd.Phoenix_Product_Type_for_CM_Fee__c==pbf.Phoenix_Product_Type_for_CM_Fee__c && pbf.Phoenix_Fee_Type__c=='CM Fee%' && (acc.Phoenix_Is_Govt_Customer__c==true && pbf.Phoenix_Customer_Type__c=='Govt business')){
                            pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c= pbf.Phoenix_Fee__c ;
                            if(templateType == 'ClarusOne') pbl.Phoenix_Local_VIP__c=pbf.Phoenix_Fee__c; // Fee % for C1
                        }
                        if(prd.Phoenix_Product_Type_for_CM_Fee__c==pbf.Phoenix_Product_Type_for_CM_Fee__c && pbf.Phoenix_Fee_Type__c=='CM Fee%' && (acc.Phoenix_Is_Govt_Customer__c==false && pbf.Phoenix_Customer_Type__c=='Non Govt business')){
                            pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c= pbf.Phoenix_Fee__c ;
                            if(templateType == 'ClarusOne')pbl.Phoenix_Local_VIP__c=pbf.Phoenix_Fee__c; // Fee % for C1
                        }
                        
                        if(pbf.Phoenix_Fee_Type__c=='RDC/NLC %'){
                            if(templateType != 'ROS' && pbf.Phoenix_Preferred_Wholesaler__c != 'McKesson')
                                pbl.Phoenix_RDC_NLC__c=pbf.Phoenix_Fee__c;
                            if(templateType == 'ClarusOne' && pbf.Phoenix_Preferred_Wholesaler__c == 'McKesson')
                                pbl.Phoenix_Proposed_Current_Rebate__c=pbf.Phoenix_Fee__c; // RDC % for C1
                        }
                        if( (bidRec.Phoenix_Bid_Type__c == 'Good Dated OTB' || bidRec.Phoenix_Bid_Type__c == 'Short Dated OTB') && acc.Name=='Walgreen Company'){
                            if(acc.Phoenix_CM_Fees__c == null){
                                pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c=((pbf.Phoenix_Fee__c !=null ? pbf.Phoenix_Fee__c:0))>0 ? ((pbf.Phoenix_Fee__c !=null ? pbf.Phoenix_Fee__c:0)) : pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c ;
                                decimal va=pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c;
                            }
                            else{
                                pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c=(acc.Phoenix_CM_Fees__c !=null ? acc.Phoenix_CM_Fees__c:0);
                                decimal va=pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c;
                            }
                        }
                    }
                }
                if(templateType == 'Indirect' && acc.AccountNumber == '370337'){
                    if(feeListForRos.size()!=0)
                        pbl.Phoenix_RDC_NLC__c=feeListForRos[0].Phoenix_Fee__c;
                }
                if (templateType == 'Walgreens' || templateType == 'ABC Progen' || templateType == 'Econdisc'
                    || templateType == 'RXSS' || templateType == 'ClarusOne' || templateType == 'Net Indirect Pricing'
                    || templateType == 'ABC Pharmagen'  || templateType == 'Sams Club'
                    || templateType == 'BASE/DSH'|| templateType == 'Government Pricing' || templateType == 'ROS'
                   ) {
                       pbl.Phoenix_Fee_G_N__c = 'Net';
                       if (templateType != 'ClarusOne' && templateType != 'Costco' && templateType != 'ABC Pharmagen' && templateType != 'ROS')
                           pbl.Phoenix_Proposed_Current_Rebate__c=acc.Phoenix_Rebates__c;
                       pbl.Phoenix_Current_Rebate__c=acc.Phoenix_Rebates__c;
                   }
                if(templateType == 'Costco'){
                    pbl.Phoenix_Proposed_Current_Rebate__c=0;
                    pbl.Phoenix_Current_Rebate__c=0;
                    
                }
                if(templateType == 'ABC Pharmagen'){
                    pbl.Phoenix_Proposed_Current_Rebate__c=acc.Phoenix_Rebate_Pharmagen__c;
                    pbl.Phoenix_Current_Rebate__c=acc.Phoenix_Rebate_Pharmagen__c;
                    
                }
                if (templateType != 'ClarusOne'){
                    pbl.Phoenix_Current_Admin_Fee__c = acc.Phoenix_Fee__c;
                    pbl.Phoenix_RDC_NLC__c = pbl.Phoenix_RDC_NLC__c!=null?pbl.Phoenix_RDC_NLC__c:acc.Phoenix_RDC_NLC__c ;
                    pbl.Phoenix_Cash_Terms__c = acc.Cash_Terms__c;
                    if(templateType == 'Walgreens')
                        pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c = pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c!=null?pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c-acc.Phoenix_Order_Analytics_Fee__c:acc.Phoenix_CM_Fees__c-acc.Phoenix_Order_Analytics_Fee__c ;
                    else
                        pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c = pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c!=null?pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c:acc.Phoenix_CM_Fees__c ;
                    
                    if (templateType != 'BASE/DSH' ){
                        if(acc.Phoenix_Local_VIP__c != null)
                            pbl.Phoenix_Local_VIP__c = acc.Phoenix_Local_VIP__c ;
                        pbl.Phoenix_Indirect_CD_Per__c=(acc.Phoenix_Indirect_Cash_Discount__c!=null && acc.Phoenix_Indirect_Cash_Discount__c>0) ?acc.Phoenix_Indirect_Cash_Discount__c:acc.Phoenix_Cash_Discount__c;
                    }
                    else{
                        //pbl.Phoenix_Local_VIP__c = bidRec.Phoenix_Proposed_Value_Est_VIP__c ;
                        //pbl.Phoenix_Indirect_CD_Per__c=bidRec.Phoenix_Current_CD__c ;
                    }
                    if (bidRec.Phoenix_Bid_Type__c == 'Short Dated OTB' || bidRec.Phoenix_Bid_Type__c == 'Good Dated OTB')
                        pbl.Phoenix_Indirect_CD_Per__c=bidRec.Phoenix_Current_CD__c ;
                    if (bidRec.Phoenix_Template_Type__c == 'Indirect' && acc.AccountNumber == '370337'){
                        pbl.Phoenix_Proposed_Current_Rebate__c = acc.Phoenix_Rebate_Secondary_Template__c;
                        pbl.Phoenix_Current_Admin_Fee__c = acc.Phoenix_Admin_Fee_Sec_Template__c;
                        pbl.Phoenix_Current_Rebate__c = acc.Phoenix_Rebate_Secondary_Template__c;
                    }
                }
                /*Added by satya*/
                if (bidRec.Phoenix_Bid_Type__c == 'Short Dated OTB' || bidRec.Phoenix_Bid_Type__c == 'Good Dated OTB' || bidRec.Phoenix_Bid_Type__c == 'Platform OTB' || bidRec.Phoenix_Bid_Type__c == 'Platform PO OTB'){
                    if(acc.AccountNumber == '117866')
                        pbl.Phoenix_Proposed_Current_Rebate__c = acc.Phoenix_Fee__c;
                }
                if(bidRec.Phoenix_Bid_Type__c == 'Platform OTB' || bidRec.Phoenix_Bid_Type__c == 'Platform PO OTB'){
                    if(acc.AccountNumber != '117866')
                        pbl.Phoenix_Proposed_Current_Rebate__c = acc.Phoenix_Rebates__c;
                }
                newItems.add(pbl);
            }
            if (newItems.size() > 0)
                insert newItems;
            if(shareExpanIds.size() > 0){
                List<Vision_Market_Share_Expansion__c> expanList = [SELECT Id, Name, Task_Status__c FROM Vision_Market_Share_Expansion__c WHERE Id IN: shareExpanIds];
                List<Vision_Market_Share_Expansion__c> expanUpdateList = new List<Vision_Market_Share_Expansion__c>();
                for(Vision_Market_Share_Expansion__c expanObj : expanList){
                    expanObj.Task_Status__c = 'Sent to BRIGHT';
                    expanUpdateList.add(expanObj);
                }
                update expanUpdateList;
            }
            
            String query = '';
            String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
            query = 'select ' + Phoenix_Util.getsObjectFieds('Phoenix_Bid_Line_Item__c') + ' from ' + SobjectApiName + ' where Id = : newItems ORDER BY Product_Family_Name__c ASC';
            
            List < Phoenix_Bid_Line_Item__c > bidLineItemsList = Database.query(query);
            List < Phoenix_Bid_Line_Item__c > bidlinesList = new List < Phoenix_Bid_Line_Item__c > ();
            Map<Id,Id> prdOptyBidItemMap = new Map<Id, Id>();
            Decimal Annualized_TP_Impact = 0;
            Map < String, List < Phoenix_Bid_Line_Item__c > > productFamilyLines = new Map < String, List < Phoenix_Bid_Line_Item__c > > ();
            for (Phoenix_Bid_Line_Item__c bidline: bidLineItemsList) {
                if(bidline.Product_Opportunity__c != null)
                    prdOptyBidItemMap.put(bidline.Product_Opportunity__c,bidline.Id);
            }
            List<Product_Opportunity__c> syncPrdOpBidItemIds = new List<Product_Opportunity__c>();
            List<String> idsList = new List<String>(); 
            for(Product_Opportunity__c prdop : [select Id, Vision_Bid_Line_Item__c,vision_isSentToBright__c from Product_Opportunity__c where Id = : prdOptyBidItemMap.keyset()]){
                idsList.add(prdop.Id);
                if(prdOptyBidItemMap.containsKey(prdop.Id)){
                    prdop.Vision_Bid_Line_Item__c = prdOptyBidItemMap.get(prdop.Id);
                    prdop.vision_isSentToBright__c = true; prdop.Vision_Bid_Type__c = bidType; prdop.Vision_Bid__c = bidId;
                    syncPrdOpBidItemIds.add(prdop);
                }
            }
            if(syncPrdOpBidItemIds.size() > 0)
                update syncPrdOpBidItemIds;
            if (templateType == 'ROS'){
                for(Phoenix_Bid_Line_Item__c itemObj : bidLineItemsList){
                    Phoenix_BidLineItemExtn__c bidLineItemExtObj = new Phoenix_BidLineItemExtn__c();
                    bidLineItemExtObj.Phoenix_Bid_Line_Item__c = itemObj.Id;
                    bidLineItemExtObj.Phoenix_Preferred_Cardinal_Rebate_per__c = acc.Phoenix_Rebates__c;
                    bidLineItemExtObj.Phoenix_Major_Rebate_per__c = acc.Phoenix_Rebates__c;
                    if(prdOptyItems.containsKey(itemObj.Phoenix_Product__c)){
                        Product_Opportunity__c prdOptyItem = prdOptyItems.get(itemObj.Phoenix_Product__c);
                        bidLineItemExtObj.Phoenix_Proposed_Cardinal_Units__c = prdOptyItem.Vision_Proposed_Cardinal_Units__c;
                        bidLineItemExtObj.Phoenix_Proposed_CVS_DirSellingUnits__c = prdOptyItem.Vision_Proposed_CVS_Direct_Units__c;
                        bidLineItemExtObj.Phoenix_Proposed_CVS_IndirSellingUnits__c = prdOptyItem.Vision_Proposed_CVS_Indirect_Units__c;
                        bidLineItemExtObj.Phoenix_Proposed_Major_Units__c = prdOptyItem.Vision_Proposed_Major_Units__c;
                        //bidLineItemExtObj.Phoenix_PropMarktCvsCardinalAcquisitCost__c = prdOptyItem.Vision_Panorama_Target_Price__c;
                    }
                    bidLineItemExtList.add(bidLineItemExtObj);
                }
                if (bidLineItemExtList.size() > 0)
                    insert bidLineItemExtList;
            }
            String selectedContNames = bidRec.Phoenix_Reference_Contracts__c;
            if (templateType == 'Walgreens' || templateType == 'ABC Progen' || templateType == 'Econdisc' || templateType == 'Costco' || templateType == 'Sams Club' || templateType == 'Government Pricing')
                Phoenix_WalgreensCls.getNPRData(selectedContNames.split(','), bidRec.Id, templateType);
            else if(templateType == 'Net Indirect Pricing')
                Phoenix_NetIndirectCls.getNPRData(selectedContNames.split(','), bidRec.Id, templateType);
            else if (templateType == 'RXSS')
                Phoenix_WalgreensCls.getNPRDataRXSS(selectedContNames.split(','), bidRec.Id, templateType);
            else if (templateType == 'ClarusOne')
                Phoenix_ClarusOneCls.getNPRData(selectedContNames.split(','), bidRec.Id, templateType);
            else if (templateType == 'ROS')
                Phoenix_RosController.getNPRData(selectedContNames.split(','), bidRec.Id, templateType);
            //added by Srimayee
            //else if (bidType == 'Platform OTB')
            //    Phoenix_OTB_PharmaBidCls.getNPRData(selectedContNames.split(','), bidRec.Id, templateType);
            else
                Phoenix_BidLineItemEditDemoCls.getNPRData(selectedContNames.split(','), bidRec.Id, templateType);
                
            return 'SUCCESS : Bid Line Items Created Successfully!';
        }
        catch(exception e){
            Phoenix_Util.recordException(e,'Vision_SendToBrightCtrl','addBidLinesToBid',''+' line Number : '+e.getLineNumber()); 
            return 'ERROR: Unable to save bid line items. Exception : '+e.getMessage()+' Line-'+e.getLineNumber();
        }
    }
    
    public class BidWrapper
    {
        @AuraEnabled
        public Phoenix_Bid__c bid;
        @AuraEnabled
        public Boolean isBidCreated;
        public BidWrapper() {
            bid = new Phoenix_Bid__c();
        }
    }
    
    @auraEnabled
    public static Opportunity saveOptyWithContracts(list < string > selectrcs, String optyId){
        String query = 'SELECT Account.Name, Account.Phoenix_Is_OTC_Customer__c, '+Phoenix_Util.getsObjectFieds('Opportunity')+' FROM Opportunity WHERE Id=: optyId';
        Opportunity optyObj = Database.query(query);
        optyObj.Vision_Reference_Contract__c = String.join(selectrcs, ',');
        update optyObj;
        return optyObj;
    }
    
    @AuraEnabled
    public static list < Phoenix_Contract__c > getContracts(string customerID) {
        string act = 'Active';
        string query = 'select name,Phoenix_Customer__r.Name,Phoenix_Contract_Number__c,Phoenix_Contract_Internal_Description__c,Phoenix_Contract_External_Description__c from Phoenix_Contract__c where Phoenix_Contract_Status__c=:act';
        if (customerID != null) {
            Set < Id > parentAccIds = new Set < Id > ();
            parentAccIds.add(customerID);
            Map < Id, Account > allAccMap = new Map < Id, Account > ();
            for (Account acc: database.query('SELECT ' + Phoenix_Util.customerFields + ' FROM Account LIMIT 10000'))
                allAccMap.put(acc.Id, acc);
            String tempId = customerID;
            while (allAccMap.get(tempId) != NULL && allAccMap.get(tempId).ParentId != NULL) {
                tempId = allAccMap.get(tempId).ParentId;
                parentAccIds.add(tempId);
            }
             for(Account acc: allAccMap.values()){
                if(acc.ParentId != null && (acc.ParentId == tempId || (allAccMap.get(acc.ParentId) != null && allAccMap.get(acc.ParentId).ParentId != null && allAccMap.get(acc.ParentId).ParentId == tempId)) )
                    parentAccIds.add(acc.Id);
            }
            query += ' and (Phoenix_Customer__c=:parentAccIds)';
        }
        
        list < Phoenix_Contract__c > cntList = Database.query(query);
        return cntList;
    }
    
    
    @auraEnabled
    public static Integer saveOptyDetPageChanges(Id optyId,Product_Opportunity__c prodOptyRec){
        update prodOptyRec;
        Opportunity optyObj = [SELECT Id, Name, Vision_Opportunity_Value__c FROM Opportunity WHERE Id =: optyId];
        List<Product_Opportunity__c> optyProdList = [SELECT Id, GCP_Product_Family__r.Name, GCP_Product_Family__c, Name, Vision_Opportunity_Value__c FROM Product_Opportunity__c WHERE Opportunity__c =: optyId];
        Decimal optyVal = 0;
        for(Product_Opportunity__c productOpportunity : optyProdList){
            optyVal = optyVal + (productOpportunity.Vision_Opportunity_Value__c != null ? productOpportunity.Vision_Opportunity_Value__c : 0);
        }
        optyObj.Vision_Opportunity_Value__c = optyVal;
        update optyObj;
        
        return Integer.valueOf(optyVal);
    }
}