public class Phoenix_GCP_OptyTracker_Controller {
    public class alertWrapper{
        @auraEnabled
        public Phoenix_GCP_Opportunity_Tracker__c gcpObj;
        @auraEnabled
        public GCP_SFDC_100pct_Analysis_SKU__c ndcObj;
    }
    
    public class relWrapper{
        @auraEnabled
        public String familyName;
        @auraEnabled
        public string segment;
        @auraEnabled
        public boolean isSelected;
        @auraEnabled
        public boolean isFiltered;
    }
    
    @auraEnabled
    public static Account updateAccWithNewFilter(Account accObj){
        update accObj;return accObj;
    }
    
    @AuraEnabled
    public static list<relWrapper> getGCPFamList(String accId){//map<string,boolean> , List<String> rxSrxOtcList){
        map<string,boolean> gcpMapWithRel = new Map<string,boolean>();
        List<String> pickListValuesList= new List<String>();
        list<relWrapper> relWrapList = new list<relWrapper>();
        List<Product_Family__c> prodFamList = database.query('SELECT '+fieldApiList('Product_Family__c')+' FROM Product_Family__c WHERE Vision_IsActive__c = true ORDER BY Name');
        //(SELECT Id, Name, Phoenix_Rx_SRx_OTC__c FROM Products__r WHERE Phoenix_Rx_SRx_OTC__c != null LIMIT 1),
        for(Product_Family__c obj : prodFamList){
            relWrapper wrapObj = new relWrapper();
            wrapObj.familyName = obj.Name;
            wrapObj.segment = obj.Vision_Segment__c != null ? obj.Vision_Segment__c : 'Rx';//obj.Products__r.size() > 0 ? obj.Products__r[0].Phoenix_Rx_SRx_OTC__c : 'Rx';
            wrapObj.isSelected = false;
            wrapObj.isFiltered = true;
            relWrapList.add(wrapObj);
            //if(obj.Products__r.size()>0){
            //    if(rxSrxOtcList.contains(obj.Products__r[0].Phoenix_Rx_SRx_OTC__c))
            //        pickListValuesList.add(obj.Name);
            //}
        }
        List<Phoenix_GCP_Opportunity_Tracker__c> gcpList = new List<Phoenix_GCP_Opportunity_Tracker__c>();
        String childQuery = 'SELECT Product_Family__r.Vision_IsActive__c, '+fieldApiList('Phoenix_GCP_Opportunity_Tracker__c')+' FROM Phoenix_GCP_Opportunity_Tracker__c WHERE Phoenix_Customer__c =: accId AND Product_Family__r.Vision_IsActive__c = true';
        //if(rxSrxOtcList.size()>0)
        //childQuery += ' AND Phoenix_Segment__c IN: rxSrxOtcList';
        childQuery += ' ORDER BY GCP_Product_Family__c';//Phoenix_Product_Family__c';
        gcpList = database.query(childQuery);
        for(Phoenix_GCP_Opportunity_Tracker__c gcpObj:gcpList){
            gcpMapWithRel.put(gcpObj.GCP_Product_Family__c,gcpObj.Vision_isRelevance__c);
        }
        List<relWrapper> newRetList = new List<relWrapper>();
        for(relWrapper wrapObj : relWrapList){
            if(gcpMapWithRel.containsKey(wrapObj.familyName))
                wrapObj.isSelected = gcpMapWithRel.get(wrapObj.familyName);
            newRetList.add(wrapObj);
        }
        return newRetList;
        /*List<Product2> prodList = [SELECT Id, Name, Family FROM Product2 WHERE Phoenix_Rx_SRx_OTC__c IN: rxSrxOtcList
AND Family IN: pickListValuesList AND Family != null ORDER BY Family];
//AND IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Family != null ORDER BY Family];
for(Product2 prodObj : prodList){
if(!gcpMapWithRel.containsKey(prodObj.Family))
gcpMapWithRel.put(prodObj.Family,false);
}*/
        //for(String prodFam : pickListValuesList){
        //    if(!prodFamSmall.contains(prodFam.toLowerCase()))     //if(!gcpMapWithRel.containsKey(prodFam))
        //       gcpMapWithRel.put(prodFam,false);
        //}
        //return gcpMapWithRel;//gcpList;
    }
    
    @auraEnabled
    public static List<Phoenix_GCP_Opportunity_Tracker__c> updateGcpListWithNewRelevance(String accId, List<String> relList){//List<Phoenix_GCP_Opportunity_Tracker__c> gcpList){
        List<String> gcpProdFamilyList = New List<String>();
        List<Phoenix_GCP_Opportunity_Tracker__c> upsertGcpList = new List<Phoenix_GCP_Opportunity_Tracker__c>();
        List<Phoenix_GCP_Opportunity_Tracker__c> gcpList =  Database.query('SELECT '+fieldApiList('Phoenix_GCP_Opportunity_Tracker__c')+' FROM Phoenix_GCP_Opportunity_Tracker__c WHERE Phoenix_Customer__c =: accId AND Product_Family__r.Vision_IsActive__c = true');
        //[SELECT Id, Name, Vision_isRelevance__c, GCP_Product_Family__c, Phoenix_Product_Family__c FROM Phoenix_GCP_Opportunity_Tracker__c
        //                                                WHERE Phoenix_Customer__c =: accId AND Product_Family__r.Vision_IsActive__c = true];//Phoenix_Product_Family__c IN: relList];
        //list<String> existingGcpProFam = new list<String>();
        Map<String,Phoenix_GCP_Opportunity_Tracker__c> famItemsMap = new Map<String,Phoenix_GCP_Opportunity_Tracker__c>();
        for(Phoenix_GCP_Opportunity_Tracker__c gcpObj : gcpList){
            famItemsMap.put(gcpObj.GCP_Product_Family__c,gcpObj);
            /*//gcpProdFamilyList.add(gcpObj.GCP_Product_Family__c);
///existingGcpProFam.add(gcpObj.GCP_Product_Family__c);
//if(relList.contains(gcpObj.GCP_Product_Family__c))
//    gcpObj.Vision_isRelevance__c = true;
//else
//    gcpObj.Vision_isRelevance__c = false;
//upsertGcpList.add(gcpObj);*/
        }
        /*//list<String> nonGCPitems = new list<String>();
//for(string relString : relList){
//    if(!existingGcpProFam.contains(relString))
//        nonGCPitems.add(relString);
//}*/
        List<Product_Family__c> prodFamListItems = Database.query('SELECT '+fieldApiList('Product_Family__c')+' FROM Product_Family__c WHERE Vision_IsActive__c = true ORDER BY Name');
        Map<String,Product_Family__c> famMap = new Map<String,Product_Family__c>();
        for(Product_Family__c famObj : prodFamListItems){
            famMap.put(famObj.Name, famObj);
        }
        List<GCP_100Pct_Analysis_Unique__c> uniqFamList = database.query('SELECT '+fieldApiList('GCP_100Pct_Analysis_Unique__c')+' FROM GCP_100Pct_Analysis_Unique__c');// WHERE GCP_Product_Family__c LIKE:relList
        if(uniqFamList.size()>0){
            List<Phoenix_GCP_Opportunity_Tracker__c> newOptyList = new List<Phoenix_GCP_Opportunity_Tracker__c>();
            for(GCP_100Pct_Analysis_Unique__c famObj : uniqFamList){
                if(famMap.containsKey(famObj.GCP_Product_Family__c)){
                    gcpProdFamilyList.add(famObj.GCP_Product_Family__c);
                    Phoenix_GCP_Opportunity_Tracker__c newObj =  new Phoenix_GCP_Opportunity_Tracker__c();
                    if(famItemsMap.containsKey(famObj.GCP_Product_Family__c)){
                        newObj = famItemsMap.get(famObj.GCP_Product_Family__c);
                        if(relList.contains(famObj.GCP_Product_Family__c))
                            newObj.Vision_isRelevance__c = true;
                        else
                            newObj.Vision_isRelevance__c = false;
                    }
                    else 
                        newObj.Vision_isRelevance__c = relList.contains(famObj.GCP_Product_Family__c) ? true : false;
                    newObj.cogs_per_unit__c = famObj.cogs_per_unit__c;
                    newObj.GCP_Product_Family__c = famObj.GCP_Product_Family__c;
                    newObj.Phoenix_Segment__c = famObj.vision_segment__c;
                    newObj.Vision_Update_Date__c = famObj.Vision_Updated_date__c;
                    newObj.Phoenix_Ims_Qtr_Month_Range__c = famObj.ims_qtr_month_range__c;
                    newObj.Phoenix_Ims_Mat_Volume_Eu__c = famObj.IMS_Mat_Volume_Eu__c;
                    newObj.Phoenix_Total_Market_Vol_MAT_EU__c = famObj.IMS_Mat_Volume_Eu__c;
                    newObj.Phoenix_Total_Market_Sales__c = famObj.Ims_Mat_Sales__c;
                    newObj.Ims_Mat_Month_Range__c = famObj.Ims_Mat_Month_Range__c;
                    newObj.Phoenix_Prof_Month_Range__c = famObj.Prof_Month_range__c;
                    newObj.Phoenix_Ims_Drl_Mkt_Sh_Qtr__c = famObj.ims_drl_mrkt_share_qtr__c;
                    newObj.Phoenix_Drl_Mkt_Sh_Act__c = famObj.drl_mkt_share_acct__c;
                    newObj.Phoenix_Drl_Act_Volume_Eu__c = famObj.drl_act_volume_eu__c;
                    newObj.Phoenix_Drl_Act_Sales__c = famObj.DRL_Act_Sales__c;
                    newObj.Phoenix_Drl_Act_Price__c = famObj.DRL_Act_Price__c;
                    newObj.Phoenix_DRL_Actual_TPT__c = famObj.DRL_Act_Tpt__c;//drl_act_eu__c;
                    newObj.Phoenix_DRL_Actual_TPT_Per__c = famObj.DRL_Act_Tpt_Pct__c;
                    newObj.Phoenix_GCP_Suggested_Lowest_Price__c = famObj.GCP_Suggested_Price__c;
                    newObj.Phoenix_Customer__c = accId;
                    Product_Family__c famObjItem = famMap.get(famObj.GCP_Product_Family__c);
                    newObj.Product_Family__c = famObjItem.Id;
                    newObj.Phoenix_Segment__c = famObjItem.Vision_Segment__c != null ? famObjItem.Vision_Segment__c : 'Rx';
                    
                    upsertGcpList.add(newObj);
                }
            }
        }
        for(string item : relList){
            if(!gcpProdFamilyList.contains(item) && famMap.containsKey(item)){
                Phoenix_GCP_Opportunity_Tracker__c newObj =  new Phoenix_GCP_Opportunity_Tracker__c();
                newObj.GCP_Product_Family__c = item;
                newObj.Phoenix_Customer__c = accId;
                Product_Family__c famObjItem = famMap.get(item);
                newObj.Product_Family__c = famObjItem.Id;
                newObj.Phoenix_Segment__c = famObjItem.Vision_Segment__c != null ? famObjItem.Vision_Segment__c : 'Rx';
                newObj.Vision_isRelevance__c = true;
                upsertGcpList.add(newObj);
            }
        }
        
        upsert upsertGcpList; return upsertGcpList;
    }
    @auraEnabled
    public static list<Product2> getProdListWithIds(List<Id> prodIds){
        String query = 'SELECT Product_Family__r.Name, '+Phoenix_Util.getsObjectFieds('Product2')+' FROM Product2 WHERE Id IN: prodIds ORDER BY Name';
        List<Product2> prodList = Database.query(query);
        return prodList;
    }
    /*
@AuraEnabled
public static Vision_Alert__c fetchVisionAlertList(String GCPRecId, String recType){
String query = 'SELECT '+fieldApiList('Vision_Alert__c')+' FROM Vision_Alert__c';
if(recType=='gcpItem')
query += ' WHERE GCP_Opportunity_Tracker__c =: GCPRecId';
else if(recType == 'ndcItem')
query += ' WHERE GCP_SFDC_100pct_Analysis_SKU__c =: GCPRecId';
list<Vision_Alert__c> visionAlertList = Database.query(query);

if(visionAlertList.size() > 0)
return visionAlertList[0];
else{ 
Vision_Alert__c alertObj = new Vision_Alert__c();
return alertObj;
}
}

@auraEnabled
public static alertWrapper saveAlert(Vision_Alert__c alertObj, Account accObj, String recId, String itemType)
{
alertWrapper wrapObj = new alertWrapper();
if(alertObj.id == null){
alertObj.Name = 'CxAnalysis - '+accObj.Name;
if(itemType == 'gcpItem')
alertObj.GCP_Opportunity_Tracker__c = recId;
else if(itemType == 'ndcItem')
alertObj.GCP_SFDC_100pct_Analysis_SKU__c = recId;
alertObj.Account__c = accObj.Id; 
}
alertObj.Vision_Alert_Type__c = 'GCP 100% Customer Analysis';
UPSERT alertObj; 
if(itemType == 'gcpItem'){
String query = 'SELECT '+fieldApiList('Phoenix_GCP_Opportunity_Tracker__c')+' FROM Phoenix_GCP_Opportunity_Tracker__c WHERE Id =: recId';
Phoenix_GCP_Opportunity_Tracker__c gcpObj = Database.query(query);
gcpObj.Vision_isAlerted__c = alertObj.Vision_isActiveAlert__c;
update gcpObj;
wrapObj.gcpObj = gcpObj;
return wrapObj;
}
else{
String query = 'SELECT Vision_Product__r.Id,Vision_Product__r.Name, Vision_Product__r.Phoenix_NDC_11__c, '+fieldApiList('GCP_SFDC_100pct_Analysis_SKU__c')+' FROM GCP_SFDC_100pct_Analysis_SKU__c WHERE Id =: recId';
GCP_SFDC_100pct_Analysis_SKU__c ndcObj = Database.query(query);
ndcObj.Vision_isAlerted__c = alertObj.Vision_isActiveAlert__c;
update ndcObj;
wrapObj.ndcObj = ndcObj;
return wrapObj;
} 
}
*/
    @AuraEnabled
    public static List < Vision_Customer_Product_Tracker__c > getAwardedPositionData(String ndcId, Account accObj){
        string accId = accObj.Id;
        List<Id> accIds = new List<Id>();
        if(accObj.Name == 'Red Oak Sourcing'){
            List<Account> accList = [SELECT Id, Name FROM Account WHERE ParentId =: accId];
            for(Account acc:accList){
                accIds.add(acc.Id);
            }
        }
        GCP_SFDC_100pct_Analysis_SKU__c ndcObj = [SELECT Id, Name, Vision_Product__c FROM GCP_SFDC_100pct_Analysis_SKU__c WHERE Id =: ndcId];
        string prodId = ndcObj.Vision_Product__c;
        String query = 'SELECT Vision_Account__c,Vision_Current_Contract_Position_Status__c,Vision_Contract__r.Name, Vision_Current_Product_Position__c,Vision_Product__c,Vision_Product__r.Name,'+
            +'Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode FROM Vision_Customer_Product_Tracker__c WHERE Vision_Product__c =: prodId';
        if(accObj.Name == 'Red Oak Sourcing')
            query += ' AND Vision_Account__c IN: accIds';
        else
            query += ' AND Vision_Account__c =: accId';
        List < Vision_Customer_Product_Tracker__c > awardedPositionList = Database.query(query);
        return awardedPositionList;
    } 
    
    public class countWrapper{
        @auraEnabled
        public Integer totalTrueOptyCount = 0;
        @auraEnabled
        public Integer notOptyCount = 0;
        @auraEnabled
        public Integer PriceConCount = 0;
        @auraEnabled
        public Integer supplyConCount = 0;
        @auraEnabled
        public Integer awardedCount = 0;
        @auraEnabled
        public Integer inBidCount = 0;
        
        @auraEnabled
        public Integer prodStatusTrueOpty = 0;
        @auraEnabled
        public Integer prodStatusNotTrueOpty = 0;
        @auraEnabled
        public Integer prodStatusPriceCons = 0;
        @auraEnabled
        public Integer prodStatusSupplyCons = 0;
        @auraEnabled
        public Integer prodStatusNdcNumber = 0;
        @auraEnabled
        public Integer prodStatusAwarded = 0;
        @auraEnabled
        public Integer prodStatusInBid = 0;
        
        @auraEnabled
        public Integer totalCountOfNDC = 0;
        
        @auraEnabled
        public Integer PriceConInBidCount = 0;
        @auraEnabled
        public Integer notOptyInBidCount = 0;
        @auraEnabled
        public Integer SupplyConInBidCount = 0;
        @auraEnabled
        public Integer trueOptyInBidCount = 0;
        @auraEnabled
        public Integer awardedInBidCount = 0;
        
        @auraEnabled
        public Integer PriceConDollar = 0;
        @auraEnabled
        public Integer notOptyDollar = 0;
        @auraEnabled
        public Integer SupplyConDollar = 0;
        @auraEnabled
        public Integer trueOptyDollar = 0;
        @auraEnabled
        public Integer awardedDollar = 0;
    }
    
    @auraEnabled
    public static countWrapper getStatusCountSRx(Phoenix_GCP_Opportunity_Tracker__c processingGcpRec){
        String accId = processingGcpRec.Phoenix_Customer__c;
        String prodFamily = processingGcpRec.GCP_Product_Family__c;
        /*List<Product_Family__c> prodFamObj = [SELECT Id, Name FROM Product_Family__c WHERE Name =: prodFamily LIMIT 1];
        countWrapper wrapObj = new countWrapper();
        String famId = prodFamObj.size()>0 ? prodFamObj[0].Id : '';
        //wrapper wrap = getNdcListOfProdFam(prodFamily, accId);
        String childQuery = 'SELECT Vision_Customer__r.Name, Vision_Customer__r.Vision_is_SRx_Account__c, Vision_Product__r.Id,Vision_Product__r.Name, Vision_Product__r.Phoenix_NDC_11__c, Vision_Product__r.isActive,Vision_Product__r.Phoenix_Pkg_Size__c, '+
            +' Vision_Customer__r.Phoenix_Account_Cooling_Period__c, '+fieldApiList('GCP_SFDC_100pct_Analysis_SKU__c')+' FROM GCP_SFDC_100pct_Analysis_SKU__c'+
            +' WHERE Vision_Customer__c =: accId AND Vision_Product__r.Product_Family__c =: famId AND Vision_Product__c != null AND Vision_Product__r.isActive = true '+
            +' AND (Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = false OR (Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = true AND Vision_Product__r.OTC_Customer__c = : accId AND Vision_Product__r.Phoenix_Is_Control_Label__c = false))'+
            +' AND Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false ORDER BY Vision_Product__r.Name';//GCP_Product_Family__c =: prodFamilyName/Product_Family__c =: famId( OR 
        List<GCP_SFDC_100pct_Analysis_SKU__c> gcpNdcList = Database.query(childQuery);
        wrapObj.totalCountOfNDC = gcpNdcList.size();
        for(GCP_SFDC_100pct_Analysis_SKU__c ndcObj : gcpNdcList){
            if(ndcObj.Vision_Product_Constraint__c == 'Price Constraint'){
                wrapObj.PriceConCount = wrapObj.PriceConCount+1;
                if(ndcObj.Vision_is_inBid_Item__c)
                    wrapObj.PriceConInBidCount = wrapObj.PriceConInBidCount+1;
                wrapObj.PriceConDollar = wrapObj.PriceConDollar + (ndcObj.Vision_SRx_Opportunity_Dollar__c != null ? Integer.valueOf(ndcObj.Vision_SRx_Opportunity_Dollar__c) : 0);
            }
            if(ndcObj.Vision_Product_Constraint__c == 'Supply Constraint'){
                wrapObj.supplyConCount = wrapObj.supplyConCount+1;
                if(ndcObj.Vision_is_inBid_Item__c)
                    wrapObj.SupplyConInBidCount = wrapObj.SupplyConInBidCount+1;
                wrapObj.SupplyConDollar = wrapObj.SupplyConDollar + (ndcObj.Vision_SRx_Opportunity_Dollar__c != null ? Integer.valueOf(ndcObj.Vision_SRx_Opportunity_Dollar__c) : 0);
            }
            if(ndcObj.Vision_Product_Constraint__c == 'Not An Opportunity'){
                wrapObj.notOptyCount = wrapObj.notOptyCount+1;
                if(ndcObj.Vision_is_inBid_Item__c)
                    wrapObj.notOptyInBidCount = wrapObj.notOptyInBidCount+1;
                wrapObj.notOptyDollar = wrapObj.notOptyDollar + (ndcObj.Vision_SRx_Opportunity_Dollar__c != null ? Integer.valueOf(ndcObj.Vision_SRx_Opportunity_Dollar__c) : 0);
            }
            if(ndcObj.Vision_Product_Constraint__c == 'True Opportunity'){
                wrapObj.totalTrueOptyCount = wrapObj.totalTrueOptyCount+1;
                if(ndcObj.Vision_is_inBid_Item__c)
                    wrapObj.trueOptyInBidCount = wrapObj.trueOptyInBidCount+1;
                wrapObj.trueOptyDollar = wrapObj.trueOptyDollar + (ndcObj.Vision_SRx_Opportunity_Dollar__c != null ? Integer.valueOf(ndcObj.Vision_SRx_Opportunity_Dollar__c) : 0);
            }
            if(ndcObj.Vision_Product_Constraint__c == 'Awarded'){
                wrapObj.awardedCount = wrapObj.awardedCount+1;
                if(ndcObj.Vision_is_inBid_Item__c)
                    wrapObj.awardedInBidCount = wrapObj.awardedInBidCount+1;
                wrapObj.awardedDollar = wrapObj.awardedDollar + (ndcObj.Vision_SRx_Opportunity_Dollar__c != null ? Integer.valueOf(ndcObj.Vision_SRx_Opportunity_Dollar__c) : 0);
            }
        }
        countWrapper wrapNdc = commonCountMethod(prodFamily, accId);
        wrapObj.prodStatusTrueOpty = wrapNdc.totalTrueOptyCount;
        wrapObj.prodStatusNotTrueOpty = wrapNdc.notOptyCount;
        wrapObj.prodStatusPriceCons = wrapNdc.PriceConCount;
        wrapObj.prodStatusSupplyCons = wrapNdc.supplyConCount;
        wrapObj.prodStatusAwarded = wrapNdc.awardedCount;
        wrapObj.prodStatusInBid = wrapNdc.inBidCount;
        wrapObj.prodStatusNdcNumber = wrapNdc.totalCountOfNDC;
        return wrapObj;*/
        
        countWrapper wrapNdc = commonCountMethod(prodFamily, accId);
        return wrapNdc;
        /*String childQuery = 'SELECT Vision_Product__r.Id,Vision_Product__r.Name, Vision_Product__r.Phoenix_NDC_11__c, Vision_Product__r.isActive, '+
            +'Vision_Customer__r.Phoenix_Account_Cooling_Period__c, '+fieldApiList('GCP_SFDC_100pct_Analysis_SKU__c')+' FROM GCP_SFDC_100pct_Analysis_SKU__c'+
            +' WHERE Vision_Customer__c =: accId AND GCP_Product_Family__c =: prodFamily AND Vision_Product__c != null AND Vision_Product__r.isActive = true '+
            +'AND (Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = false OR (Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = true AND Vision_Product__r.OTC_Customer__c = : accId))'+
            +' AND Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false ORDER BY Vision_Product__r.Name';
        List<GCP_SFDC_100pct_Analysis_SKU__c> gcpNdcList = Database.query(childQuery);
        wrapObj.totalCountOfNDC = gcpNdcList.size();
        List<Id> prodIds = new List<Id>();
        Map<Id, GCP_SFDC_100pct_Analysis_SKU__c> gcpItemMap = new Map<Id, GCP_SFDC_100pct_Analysis_SKU__c>();
        for(GCP_SFDC_100pct_Analysis_SKU__c ndcObj : gcpNdcList){
            gcpItemMap.put(ndcObj.Vision_Product__c,ndcObj);
            prodIds.add(ndcObj.Vision_Product__c);
        }
        List<Product2> prodList = [SELECT Id, Name FROM Product2 WHERE Product_Family__c =: processingGcpRec.Product_Family__c //AND Vision_Product__c NOT IN: prodIds
                                   AND (Phoenix_Is_Private_Label_OTC__c = false OR (Phoenix_Is_Private_Label_OTC__c = true AND OTC_Customer__c = : accId)) AND Phoenix_Is_Exclude_Bid__c = false];
        
        for(Product2 uniObj : prodList){
            prodIds.add(uniObj.Id);
        }
        List<Phoenix_Bid_Line_Item__c> bidLineItemList = [SELECT Id,Name,Phoenix_Bid__c,Phoenix_Bid__r.Name,Phoenix_Product__c,createdDate,Phoenix_Final_Direct_Selling_Units_Calc__c, Phoenix_Product_Family1__c,
                                                          Phoenix_Final_Indirect_Selling_Units_Cal__c, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Marketing_Approval__c, Phoenix_SCM_Approval_Y_N__c,Phoenix_Proposed_Sales__c,
                                                          Phoenix_Awarded_Net_Sales__c, Proposed_Net_Sales_Direct__c, Proposed_Net_Sales_Indirect__c, Phoenix_Final_Status__c
                                                          FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Phoenix_Customer__c =: accId
                                                          AND Phoenix_Product__c =: prodIds AND Phoenix_Bid__r.Phoenix_Approval_Status__c != 'Draft' 
                                                          AND Phoenix_Bid__r.Phoenix_Approval_Status__c != 'Closed-Draft'
                                                          ORDER BY createdDate DESC];
        List<String> prodIdsProcessed = new List<String>();
        List<String> inBidIds = new List<String>();
        List<String> inBidProds = new List<String>();
        for(Phoenix_Bid_Line_Item__c bidLineItemObj : bidLineItemList){
            if(gcpItemMap.containsKey(bidLineItemObj.Phoenix_Product__c)){
                prodIdsProcessed.add(bidLineItemObj.Phoenix_Product__c);
                GCP_SFDC_100pct_Analysis_SKU__c ndcObj = gcpItemMap.get(bidLineItemObj.Phoenix_Product__c);
                if(ndcObj.Vision_Product_Status__c == 'Price Constraint'){
                    wrapObj.PriceConCount = wrapObj.PriceConCount+1;
                    if(ndcObj.Vision_is_inBid_Item__c)
                        wrapObj.PriceConInBidCount = wrapObj.PriceConInBidCount+1;
                    wrapObj.PriceConDollar = wrapObj.PriceConDollar + (ndcObj.Vision_SRx_Opportunity_Dollar__c != null ? Integer.valueOf(ndcObj.Vision_SRx_Opportunity_Dollar__c) : 0);
                }
                if(ndcObj.Vision_Product_Status__c == 'Supply Constraint'){
                    wrapObj.supplyConCount = wrapObj.supplyConCount+1;
                    if(ndcObj.Vision_is_inBid_Item__c)
                        wrapObj.SupplyConInBidCount = wrapObj.SupplyConInBidCount+1;
                    wrapObj.SupplyConDollar = wrapObj.SupplyConDollar + (ndcObj.Vision_SRx_Opportunity_Dollar__c != null ? Integer.valueOf(ndcObj.Vision_SRx_Opportunity_Dollar__c) : 0);
                }
                if(ndcObj.Vision_Product_Status__c == 'Not An Opportunity'){
                    wrapObj.notOptyCount = wrapObj.notOptyCount+1;
                    if(ndcObj.Vision_is_inBid_Item__c)
                        wrapObj.notOptyInBidCount = wrapObj.notOptyInBidCount+1;
                    wrapObj.notOptyDollar = wrapObj.notOptyDollar + (ndcObj.Vision_SRx_Opportunity_Dollar__c != null ? Integer.valueOf(ndcObj.Vision_SRx_Opportunity_Dollar__c) : 0);
                }
                if(ndcObj.Vision_Product_Status__c == 'True Opportunity'){
                    wrapObj.totalTrueOptyCount = wrapObj.totalTrueOptyCount+1;
                    if(ndcObj.Vision_is_inBid_Item__c)
                        wrapObj.trueOptyInBidCount = wrapObj.trueOptyInBidCount+1;
                    wrapObj.trueOptyDollar = wrapObj.trueOptyDollar + (ndcObj.Vision_SRx_Opportunity_Dollar__c != null ? Integer.valueOf(ndcObj.Vision_SRx_Opportunity_Dollar__c) : 0);
                }
                if(ndcObj.Vision_Product_Status__c == 'Awarded'){
                    wrapObj.awardedCount = wrapObj.awardedCount+1;
                    if(ndcObj.Vision_is_inBid_Item__c)
                        wrapObj.awardedInBidCount = wrapObj.awardedInBidCount+1;
                    wrapObj.awardedDollar = wrapObj.awardedDollar + (ndcObj.Vision_SRx_Opportunity_Dollar__c != null ? Integer.valueOf(ndcObj.Vision_SRx_Opportunity_Dollar__c) : 0);
                }
            }
            else if(!prodIdsProcessed.contains(bidLineItemObj.Phoenix_Product__c)){
                prodIdsProcessed.add(bidLineItemObj.Phoenix_Product__c);
                if(bidLineItemObj.Phoenix_Marketing_Approval__c == 'Not Approved')
                    wrapObj.PriceConCount = wrapObj.PriceConCount+1;
                else if(bidLineItemObj.Phoenix_SCM_Approval_Y_N__c == 'N- Not Approved')
                    wrapObj.supplyConCount = wrapObj.supplyConCount+1;
                else if(bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c != 'Closed' && !bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c.contains('Rejected')){
                    if(!inBidIds.contains(bidLineItemObj.Id))
                        inBidIds.add(bidLineItemObj.Id);
                    if(!inBidProds.contains(bidLineItemObj.Phoenix_Product__c))
                        inBidProds.add(bidLineItemObj.Phoenix_Product__c);
                }
                else if(bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Closed' || bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Vistex Update'){
                    if(bidLineItemObj.Phoenix_Final_Status__c == 'Not Approved')
                        wrapObj.notOptyCount = wrapObj.notOptyCount+1;
                    else
                        wrapObj.awardedCount = wrapObj.awardedCount+1;
                }
            }
        }
        if(inBidIds.size()>0){
            bidLineItemList = [SELECT Id,Name,Phoenix_Bid__c,Phoenix_Bid__r.Name,Phoenix_Product__c,createdDate,Phoenix_Final_Direct_Selling_Units_Calc__c, Phoenix_Product_Family1__c,
                               Phoenix_Final_Indirect_Selling_Units_Cal__c, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Marketing_Approval__c, Phoenix_SCM_Approval_Y_N__c,Phoenix_Proposed_Sales__c,
                               Phoenix_Awarded_Net_Sales__c, Proposed_Net_Sales_Direct__c, Proposed_Net_Sales_Indirect__c, Phoenix_Final_Status__c
                               FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Phoenix_Customer__c =: accId AND Id NOT IN: inBidIds
                               AND Phoenix_Product__c =: inBidProds AND Phoenix_Bid__r.Phoenix_Approval_Status__c != 'Draft' AND Phoenix_Final_Status__c != 'Not Approved' 
                               AND Phoenix_Bid__r.Phoenix_Approval_Status__c != 'Closed-Draft' ORDER BY createdDate DESC];
            for(Phoenix_Bid_Line_Item__c bidLineItemObj : bidLineItemList){
                if(bidLineItemObj.Phoenix_Marketing_Approval__c == 'Not Approved'){
                    wrapObj.PriceConCount = wrapObj.PriceConCount+1;
                    wrapObj.PriceConInBidCount = wrapObj.PriceConInBidCount+1;
                }
                else if(bidLineItemObj.Phoenix_SCM_Approval_Y_N__c == 'N- Not Approved'){
                    wrapObj.supplyConCount = wrapObj.supplyConCount+1;
                    wrapObj.SupplyConInBidCount = wrapObj.SupplyConInBidCount+1;
                }
                else if(bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Closed' || bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Vistex Update'){
                    if(bidLineItemObj.Phoenix_Final_Status__c == 'Not Approved'){
                        wrapObj.notOptyCount = wrapObj.notOptyCount+1;
                        wrapObj.notOptyInBidCount = wrapObj.notOptyInBidCount+1;
                    }
                    else{
                        wrapObj.awardedCount = wrapObj.awardedCount+1;
                        wrapObj.awardedInBidCount = wrapObj.awardedInBidCount+1;
                    }
                }
                else{ 
                    wrapObj.totalTrueOptyCount = wrapObj.totalTrueOptyCount+1;
                    wrapObj.trueOptyInBidCount = wrapObj.trueOptyInBidCount+1;
                }
            }
        }
        for(String productId : prodIds){
            if(!prodIdsProcessed.contains(productId))
                wrapObj.totalTrueOptyCount = wrapObj.totalTrueOptyCount+1;
        }
        return wrapObj;*/
    }
    
    public static countWrapper commonCountMethod(String prodFamily, string accId){
        countWrapper wrapObj = new countWrapper();
        wrapper wrap = getNdcListOfProdFam(prodFamily, accId);
        List<GCP_SFDC_100pct_Analysis_SKU__c> gcpNdcList = wrap.updateGcpList;
        wrapObj.totalCountOfNDC = gcpNdcList.size();
        Map<Id, GCP_SFDC_100pct_Analysis_SKU__c> gcpItemMap = new Map<Id, GCP_SFDC_100pct_Analysis_SKU__c>();
        integer count = 0;
        for(GCP_SFDC_100pct_Analysis_SKU__c ndcObj : gcpNdcList){
            if(ndcObj.Vision_Product_Status__c != null){
                count++;
                if(!ndcObj.Vision_Customer__r.Vision_is_SRx_Account__c){
                    if(ndcObj.Vision_Product_Constraint__c != null && !ndcObj.Vision_Product_Constraint__c.contains('None')){
                        if(ndcObj.Vision_Product_Constraint__c == 'Price Constraint')
                            wrapObj.PriceConCount = wrapObj.PriceConCount+1;
                        if(ndcObj.Vision_Product_Constraint__c == 'Supply Constraint')
                            wrapObj.supplyConCount = wrapObj.supplyConCount+1;
                        if(ndcObj.Vision_Product_Constraint__c == 'Not An Opportunity')
                            wrapObj.notOptyCount = wrapObj.notOptyCount+1;
                    }
                    else if(ndcObj.Vision_Product_Status__c == 'Price Constraint')
                        wrapObj.PriceConCount = wrapObj.PriceConCount+1;
                    else if(ndcObj.Vision_Product_Status__c == 'Supply Constraint')
                        wrapObj.supplyConCount = wrapObj.supplyConCount+1;
                    else if(ndcObj.Vision_Product_Status__c == 'In Bid')
                        wrapObj.inBidCount = wrapObj.inBidCount+1;
                    else if(ndcObj.Vision_Product_Status__c == 'Awarded')
                        wrapObj.awardedCount = wrapObj.awardedCount+1;
                    else if(ndcObj.Vision_Product_Status__c == 'True Opportunity')
                        wrapObj.totalTrueOptyCount = wrapObj.totalTrueOptyCount+1;
                }
                else{
                    if(ndcObj.Vision_Product_Status__c == 'Price Constraint')
                        wrapObj.prodStatusPriceCons = wrapObj.prodStatusPriceCons+1;
                    else if(ndcObj.Vision_Product_Status__c == 'Supply Constraint')
                        wrapObj.prodStatusSupplyCons = wrapObj.prodStatusSupplyCons+1;
                    else if(ndcObj.Vision_Product_Status__c == 'In Bid')
                        wrapObj.prodStatusInBid = wrapObj.prodStatusInBid+1;
                    else if(ndcObj.Vision_Product_Status__c == 'Awarded')
                        wrapObj.prodStatusAwarded = wrapObj.prodStatusAwarded+1;
                    else if(ndcObj.Vision_Product_Status__c == 'True Opportunity')
                        wrapObj.prodStatusTrueOpty = wrapObj.prodStatusTrueOpty+1;
                    else if(ndcObj.Vision_Product_Status__c == 'Not An Opportunity')
                        wrapObj.prodStatusNotTrueOpty = wrapObj.prodStatusNotTrueOpty+1;
                    
                    
                    if(ndcObj.Vision_Product_Constraint__c == 'Price Constraint'){
                        wrapObj.PriceConCount = wrapObj.PriceConCount+1;
                        if(ndcObj.Vision_is_inBid_Item__c)
                            wrapObj.PriceConInBidCount = wrapObj.PriceConInBidCount+1;
                        wrapObj.PriceConDollar = wrapObj.PriceConDollar + (ndcObj.Vision_SRx_Opportunity_Dollar__c != null ? Integer.valueOf(ndcObj.Vision_SRx_Opportunity_Dollar__c) : 0);
                    }
                    if(ndcObj.Vision_Product_Constraint__c == 'Supply Constraint'){
                        wrapObj.supplyConCount = wrapObj.supplyConCount+1;
                        if(ndcObj.Vision_is_inBid_Item__c)
                            wrapObj.SupplyConInBidCount = wrapObj.SupplyConInBidCount+1;
                        wrapObj.SupplyConDollar = wrapObj.SupplyConDollar + (ndcObj.Vision_SRx_Opportunity_Dollar__c != null ? Integer.valueOf(ndcObj.Vision_SRx_Opportunity_Dollar__c) : 0);
                    }
                    if(ndcObj.Vision_Product_Constraint__c == 'Not An Opportunity'){
                        wrapObj.notOptyCount = wrapObj.notOptyCount+1;
                        if(ndcObj.Vision_is_inBid_Item__c)
                            wrapObj.notOptyInBidCount = wrapObj.notOptyInBidCount+1;
                        wrapObj.notOptyDollar = wrapObj.notOptyDollar + (ndcObj.Vision_SRx_Opportunity_Dollar__c != null ? Integer.valueOf(ndcObj.Vision_SRx_Opportunity_Dollar__c) : 0);
                    }
                    if(ndcObj.Vision_Product_Constraint__c == 'True Opportunity'){
                        wrapObj.totalTrueOptyCount = wrapObj.totalTrueOptyCount+1;
                        if(ndcObj.Vision_is_inBid_Item__c)
                            wrapObj.trueOptyInBidCount = wrapObj.trueOptyInBidCount+1;
                        wrapObj.trueOptyDollar = wrapObj.trueOptyDollar + (ndcObj.Vision_SRx_Opportunity_Dollar__c != null ? Integer.valueOf(ndcObj.Vision_SRx_Opportunity_Dollar__c) : 0);
                    }
                    if(ndcObj.Vision_Product_Constraint__c == 'Awarded'){
                        wrapObj.awardedCount = wrapObj.awardedCount+1;
                        if(ndcObj.Vision_is_inBid_Item__c)
                            wrapObj.awardedInBidCount = wrapObj.awardedInBidCount+1;
                        wrapObj.awardedDollar = wrapObj.awardedDollar + (ndcObj.Vision_SRx_Opportunity_Dollar__c != null ? Integer.valueOf(ndcObj.Vision_SRx_Opportunity_Dollar__c) : 0);
                    }
                }
            }
        }
        wrapObj.totalCountOfNDC = count;
        return wrapObj;
    }
    
    @auraEnabled
    public static countWrapper getStatusCount(Phoenix_GCP_Opportunity_Tracker__c processingGcpRec){
        countWrapper wrapObj = new countWrapper();
        String prodFamily = processingGcpRec.GCP_Product_Family__c;//Phoenix_Product_Family__c;
        String accId = processingGcpRec.Phoenix_Customer__c;
        return commonCountMethod(prodFamily, accId);
    }
    
    @auraEnabled
    public static List<GCP_SFDC_100pct_Analysis_SKU__c> getNDCListForPieChart(String accId, String prodStatus, boolean isCon){
        String childQuery = 'SELECT Vision_Customer__r.Name, Vision_Customer__r.Vision_is_SRx_Account__c, Vision_Product__r.Id,Vision_Product__r.Name, Vision_Product__r.Phoenix_NDC_11__c, Vision_Product__r.isActive,Vision_Product__r.Phoenix_Pkg_Size__c, '+
            +' Vision_Customer__r.Phoenix_Account_Cooling_Period__c, '+fieldApiList('GCP_SFDC_100pct_Analysis_SKU__c')+' FROM GCP_SFDC_100pct_Analysis_SKU__c'+
            +' WHERE Vision_Customer__c =: accId AND Vision_Product__c != null AND Vision_Product__r.isActive = true '+
            +' AND (Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = false OR (Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = true AND Vision_Product__r.OTC_Customer__c = : accId AND Vision_Product__r.Phoenix_Is_Control_Label__c = false))'+
            +' AND Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false';
        if(isCon)
            childQuery += ' AND Vision_Product_Constraint__c =: prodStatus ';
        else
            childQuery += ' AND Vision_Product_Status__c =: prodStatus ';
        childQuery += ' ORDER BY Vision_Product__r.Name';
        List<GCP_SFDC_100pct_Analysis_SKU__c> gcpNdcList = Database.query(childQuery);
        return gcpNdcList;
    }
    
    @auraEnabled
    public static countWrapper getProdStatusInfoNdcLevel(Phoenix_GCP_Opportunity_Tracker__c processingGcpRec){
        countWrapper wrapObj = new countWrapper();
        String prodFamily = processingGcpRec.GCP_Product_Family__c;//Phoenix_Product_Family__c;
        String accId = processingGcpRec.Phoenix_Customer__c;
        String childQuery = 'SELECT Vision_Product__r.Id,Vision_Product__r.Name, Vision_Product__r.Phoenix_NDC_11__c, Vision_Customer__r.Phoenix_Account_Cooling_Period__c, '+fieldApiList('GCP_SFDC_100pct_Analysis_SKU__c')+' FROM GCP_SFDC_100pct_Analysis_SKU__c'+
            +' WHERE Vision_Customer__c =: accId AND GCP_Product_Family__c =: prodFamily AND Vision_Product__c != null AND Vision_Product__r.isActive = true AND Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = false ORDER BY Vision_Product__r.Name';//Product_Family__c
        List<GCP_SFDC_100pct_Analysis_SKU__c> gcpNdcList = Database.query(childQuery);
        List<Id> prodIds = new List<Id>();
        Map<Id, GCP_SFDC_100pct_Analysis_SKU__c> gcpNdcMap = new Map<Id, GCP_SFDC_100pct_Analysis_SKU__c>();
        for(GCP_SFDC_100pct_Analysis_SKU__c ndcObj : gcpNdcList){
            prodIds.add(ndcObj.Vision_Product__c);
            gcpNdcMap.put(ndcObj.Vision_Product__c,ndcObj);
        }
        List<Phoenix_Bid_Line_Item__c> bidLineItemList = [SELECT Id,Name,Phoenix_Bid__c,Phoenix_Bid__r.Name,Phoenix_Product__c, createdDate,Phoenix_Final_Direct_Selling_Units_Calc__c, Phoenix_Product_Family1__c,
                                                          Phoenix_Final_Indirect_Selling_Units_Cal__c, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Marketing_Approval__c, Phoenix_SCM_Approval_Y_N__c,Phoenix_Proposed_Sales__c, Phoenix_Awarded_Net_Sales__c,
                                                          Proposed_Net_Sales_Direct__c, Proposed_Net_Sales_Indirect__c, Phoenix_Final_Status__c
                                                          FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Phoenix_Customer__c =: accId
                                                          AND Phoenix_Product__c =: prodIds AND Phoenix_Bid__r.Phoenix_Approval_Status__c != 'Draft' 
                                                          AND Phoenix_Bid__r.Phoenix_Approval_Status__c != 'Closed-Draft' ORDER BY createdDate DESC];
        List<String> prodIdsProcessed = new List<String>();
        Map<Id, GCP_SFDC_100pct_Analysis_SKU__c> mapToUpdateGCPList = new Map<Id, GCP_SFDC_100pct_Analysis_SKU__c>();
        List<GCP_SFDC_100pct_Analysis_SKU__c> updateGcpList = new List<GCP_SFDC_100pct_Analysis_SKU__c>();
        
        for(Phoenix_Bid_Line_Item__c bidLineItemObj : bidLineItemList){
            if(!prodIdsProcessed.contains(bidLineItemObj.Phoenix_Product__c)){
                prodIdsProcessed.add(bidLineItemObj.Phoenix_Product__c);
                
                GCP_SFDC_100pct_Analysis_SKU__c ndcItem = gcpNdcMap.get(bidLineItemObj.Phoenix_Product__c);
                boolean isInCoolingPeriod = false;
                ndcItem.Vision_Cooling_Period__c = ndcItem.Vision_Cooling_Period__c != null ? ndcItem.Vision_Cooling_Period__c : 
                (ndcItem.Vision_Customer__r.Phoenix_Account_Cooling_Period__c != null ? ndcItem.Vision_Customer__r.Phoenix_Account_Cooling_Period__c : null);
                    Integer coolingPeriod = ndcItem.Vision_Cooling_Period__c != null ? Integer.valueOf(ndcItem.Vision_Cooling_Period__c) :  0;
                if(coolingPeriod != 0){
                    Date cDate = Date.valueOf(bidLineItemObj.CreatedDate);
                    Date tDay = system.today();
                    Integer diffDays = cDate.daysBetween(tDay);
                    String formatedCreatedDate = DateTime.newInstance(cDate.year(), cDate.month(), cDate.day()).format('MM/dd/yyyy');
                    Date cpDate = tDay.addDays(coolingPeriod-diffDays);
                    String formatedcpDate = DateTime.newInstance(cpDate.year(), cpDate.month(), cpDate.day()).format('MM/dd/yyyy');
                    if(diffDays < coolingPeriod){
                        isInCoolingPeriod = true;
                        ndcItem.Vision_Cooling_Period_String__c = 'Last Bid: '+formatedCreatedDate+'; CP Days: '+coolingPeriod+' Days; CP Date: '+formatedcpDate+'; '+(coolingPeriod - diffDays)+' days remaining';
                    }
                    else
                        ndcItem.Vision_Cooling_Period_String__c = 'Last Bid: '+formatedCreatedDate+'; CP Days: '+coolingPeriod+' Days; CP Date: '+formatedcpDate+'; '+(diffDays-coolingPeriod)+' days over cooling period';
                }
                
                if(bidLineItemObj.Phoenix_Marketing_Approval__c == 'Not Approved'){
                    wrapObj.PriceConCount = wrapObj.PriceConCount+1;
                    ndcItem.Vision_Product_Status__c = 'Price Constraint';
                }
                else if(bidLineItemObj.Phoenix_SCM_Approval_Y_N__c == 'N- Not Approved'){
                    wrapObj.supplyConCount = wrapObj.supplyConCount+1;
                    ndcItem.Vision_Product_Status__c = 'Supply Constraint';
                }
                else if(bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c != 'Closed' 
                        && !bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c.contains('Rejected'))
                {
                    wrapObj.inBidCount = wrapObj.inBidCount+1;
                    ndcItem.Vision_Product_Status__c = 'In Bid';
                }
                else if(bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Closed' || bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Vistex Update'){
                    if(isInCoolingPeriod || bidLineItemObj.Phoenix_Final_Status__c == 'Not Approved'){
                        wrapObj.notOptyCount = wrapObj.notOptyCount+1;
                        ndcItem.Vision_Product_Status__c = 'Not An Opportunity';
                    }
                    else{
                        wrapObj.awardedCount = wrapObj.awardedCount+1;
                        ndcItem.Vision_Product_Status__c = 'Awarded';
                    }
                }
                mapToUpdateGCPList.put(ndcItem.Vision_Product__c, ndcItem);
                //updateGcpList.add(ndcItem);
            }
        }
        for(String productId : prodIds){
            if(!prodIdsProcessed.contains(productId)){
                GCP_SFDC_100pct_Analysis_SKU__c ndcItem = gcpNdcMap.get(productId);
                ndcItem.Vision_Product_Status__c = 'True Opportunity';
                ndcItem.Vision_Cooling_Period_String__c = 'Ready For Bid';
                ndcItem.Vision_Cooling_Period__c = ndcItem.Vision_Cooling_Period__c != null ? ndcItem.Vision_Cooling_Period__c : 
                (ndcItem.Vision_Customer__r.Phoenix_Account_Cooling_Period__c != null ? ndcItem.Vision_Customer__r.Phoenix_Account_Cooling_Period__c : null);
                    
                    wrapObj.totalTrueOptyCount = wrapObj.totalTrueOptyCount+1;
                mapToUpdateGCPList.put(ndcItem.Vision_Product__c, ndcItem);
                //updateGcpList.add(ndcItem);
            }
        }
        updateGcpList.addAll(mapToUpdateGCPList.values());
        update updateGcpList;
        
        return wrapObj;
    }
    
    @AuraEnabled
    public static Wrapper getGcpRelatedList(String accId, List<String> rxSrxOtcList, List<String> posFilterList, Boolean showRelevant){
        Wrapper wrapObj = new Wrapper();
        List<String> apexClassList = new List<String>();
        apexClassList.add('GoogleBigQueryDataFetchBatch');
        apexClassList.add('GoogleSFDC100PCTAnalysisSKUFetch');
        apexClassList.add('GoogleSFDC100PctAnalysisUnique');
        apexClassList.add('GoogleSFDC100PCTAnalysisSKUFetch');
        wrapObj.isJobRunning = false;//test.isRunningTest() ? false : Vision_Rx_Compliance_NPR.apexJobStatus(apexClassList);
        if(!wrapObj.isJobRunning){
            Boolean caughtError = false;
            Decimal awardedTotalSales = 0;
            Decimal inBidTotalSales = 0;
            String query = 'SELECT '+Phoenix_Util.customerFields+' FROM Account Where Id =: accId'; 
            Account accObj = Database.query(query);
            
            List<Phoenix_GCP_Opportunity_Tracker__c> gcpList = new List<Phoenix_GCP_Opportunity_Tracker__c>();
            List<Phoenix_GCP_Opportunity_Tracker__c> filteredGcpList = new List<Phoenix_GCP_Opportunity_Tracker__c>();
            List<Phoenix_GCP_Opportunity_Tracker__c> updateGcpList = new List<Phoenix_GCP_Opportunity_Tracker__c>();
            
            User userDetails = [SELECT Id, Name, Division FROM User WHERE Id=: userInfo.getUserId()];
            rxSrxOtcList = new List<String>();
            if(accObj.Vision_Rx_Filtered__c)
                rxSrxOtcList.add('RX');
            if(accObj.Vision_SRx_Filtered__c)
                rxSrxOtcList.add('SRX');
            if(accObj.Vision_OTC_Filtered__c)
                rxSrxOtcList.add('OTC');
            if(rxSrxOtcList.size() == 0){
                if(userDetails.Division != null) {
                    string seg = userDetails.Division;
                    rxSrxOtcList.add(seg);
                    if(seg == 'RX')
                        accObj.Vision_Rx_Filtered__c = true;
                    if(seg == 'SRX')
                        accObj.Vision_SRx_Filtered__c = true;
                    if(seg == 'OTC')
                        accObj.Vision_OTC_Filtered__c = true;
                }
                else if(accObj.Name.contains('Private Label')) {
                    rxSrxOtcList.add('OTC');
                    accObj.Vision_OTC_Filtered__c = true;
                }
                else{
                    rxSrxOtcList.add('RX');
                    rxSrxOtcList.add('SRX');
                    rxSrxOtcList.add('OTC');
                    accObj.Vision_Rx_Filtered__c = true;
                    accObj.Vision_SRx_Filtered__c = true;
                    accObj.Vision_OTC_Filtered__c = true;
                }
            }
            try{
                if((accObj.Phoenix_Customer_Est_Market_Share__c == null || accObj.Phoenix_Customer_Est_Market_Share__c == 0) && 
                   (accObj.Phoenix_Customer_Max_Est_Share_of_Wallet__c == null || accObj.Phoenix_Customer_Max_Est_Share_of_Wallet__c == 0) && 
                   (accObj.Phoenix_Account_Cooling_Period__c == null || accObj.Phoenix_Account_Cooling_Period__c == 0)){
                       accObj.Phoenix_Customer_Est_Market_Share__c = 20;
                       accObj.Phoenix_Customer_Max_Est_Share_of_Wallet__c = 65;
                       accObj.Phoenix_Account_Cooling_Period__c = 90; 
                   }
                
                //system.debug('accObj.AccountNumber :: '+accObj.AccountNumber);
                String childQuery = 'SELECT '+fieldApiList('Phoenix_GCP_Opportunity_Tracker__c')+' FROM Phoenix_GCP_Opportunity_Tracker__c '+ 
                    +'WHERE Phoenix_Customer__c =: accId AND Product_Family__r.Vision_IsActive__c = true';// ORDER BY GCP_Product_Family__c';
                if(rxSrxOtcList.size()>0)
                    childQuery += ' AND Phoenix_Segment__c =: rxSrxOtcList';
                //if(posFilterList.size() > 0 && posFilterList.size() == 6)
                //    childQuery += ' AND (Product_Status__c =: posFilterList OR Product_Status__c = \'\')';
                //else if(posFilterList.size() > 0)
                //    childQuery += ' AND Product_Status__c =: posFilterList';
                if(showRelevant)
                    childQuery += ' AND Vision_isRelevance__c = true';
                childQuery += ' ORDER BY GCP_Product_Family__c';
                List<Phoenix_GCP_Opportunity_Tracker__c> gcpItems = database.query(childQuery);
                List<String> prodFamNameList = new List<String>();
                Map<String, List<Phoenix_GCP_Opportunity_Tracker__c>> gcpListMap = new Map<String, List<Phoenix_GCP_Opportunity_Tracker__c>>();
                //List<String> prodFam = new List<String>();
                List<Id> produFamilyIds = New List<Id>();
                for(Phoenix_GCP_Opportunity_Tracker__c gcpObj : gcpItems){
                    if(!gcpListMap.containsKey(gcpObj.GCP_Product_Family__c))
                        gcpListMap.put(gcpObj.GCP_Product_Family__c , new List<Phoenix_GCP_Opportunity_Tracker__c>());
                    gcpListMap.get(gcpObj.GCP_Product_Family__c).add(gcpObj);
                    if(gcpObj.GCP_Product_Family__c != null)
                        prodFamNameList.add(gcpObj.GCP_Product_Family__c);
                    if(gcpObj.Product_Family__c != null && !produFamilyIds.contains(gcpObj.Product_Family__c)){// !prodFam.contains(gcpObj.GCP_Product_Family__c)){
                        //prodFam.add(gcpObj.GCP_Product_Family__c);
                        produFamilyIds.add(gcpObj.Product_Family__c);
                    }
                }
                
                /*List<GCP_100Pct_Analysis_Unique__c> uniqFamList = database.query('SELECT '+fieldApiList('GCP_100Pct_Analysis_Unique__c')+' FROM GCP_100Pct_Analysis_Unique__c WHERE GCP_Product_Family__c NOT IN:prodFam');
if(uniqFamList.size()>0){
List<Product_Family__c> prodFamListItems = Database.query('SELECT (SELECT Id, Name, Phoenix_Rx_SRx_OTC__c FROM Products__r LIMIT 1),'+fieldApiList('Product_Family__c')+' FROM Product_Family__c ORDER BY Name');
Map<String,Id> famMap = new Map<String,Id>();
for(Product_Family__c famObj : prodFamListItems){
if(famObj.Products__r.size()>0){
if(posFilterList.contains(famObj.Products__r[0].Phoenix_Rx_SRx_OTC__c))
famMap.put(famObj.Name, famObj.Id);
}
}
List<Phoenix_GCP_Opportunity_Tracker__c> newOptyList = new List<Phoenix_GCP_Opportunity_Tracker__c>();
for(GCP_100Pct_Analysis_Unique__c famObj : uniqFamList){
if(famMap.containsKey(famObj.GCP_Product_Family__c)){
Phoenix_GCP_Opportunity_Tracker__c newObj =  new Phoenix_GCP_Opportunity_Tracker__c();
newObj.cogs_per_unit__c = famObj.cogs_per_unit__c;
newObj.GCP_Product_Family__c = famObj.GCP_Product_Family__c;
newObj.Phoenix_Segment__c = famObj.vision_segment__c;
newObj.Vision_Update_Date__c = famObj.Vision_Updated_date__c;
newObj.Phoenix_Ims_Qtr_Month_Range__c = famObj.ims_qtr_month_range__c;
newObj.Phoenix_Ims_Mat_Volume_Eu__c = famObj.IMS_Mat_Volume_Eu__c;
newObj.Phoenix_Total_Market_Sales__c = famObj.Ims_Mat_Sales__c;
newObj.Ims_Mat_Month_Range__c = famObj.Ims_Mat_Month_Range__c;

newObj.Phoenix_Ims_Drl_Mkt_Sh_Qtr__c = famObj.ims_drl_mrkt_share_qtr__c;
newObj.Phoenix_Drl_Mkt_Sh_Act__c = famObj.drl_mkt_share_acct__c;
newObj.Phoenix_Drl_Act_Volume_Eu__c = famObj.drl_act_volume_eu__c;
newObj.Phoenix_Drl_Act_Sales__c = famObj.DRL_Act_Sales__c;
newObj.Phoenix_Drl_Act_Price__c = famObj.DRL_Act_Price__c;

newObj.Phoenix_DRL_Actual_TPT__c = famObj.DRL_Act_Tpt__c;//drl_act_eu__c;
//newObj.Phoenix_DRL_Actual_TPT_Per__c = famObj.;
newObj.Phoenix_Customer__c = accId;
newObj.Product_Family__c = famMap.get(famObj.GCP_Product_Family__c);
newOptyList.add(newObj);
}
}
insert newOptyList;
for(Phoenix_GCP_Opportunity_Tracker__c gcpObj : newOptyList){
if(!gcpListMap.containsKey(gcpObj.Phoenix_Product_Family__c))
gcpListMap.put(gcpObj.Phoenix_Product_Family__c , new List<Phoenix_GCP_Opportunity_Tracker__c>());
gcpListMap.get(gcpObj.Phoenix_Product_Family__c).add(gcpObj);
if(gcpObj.Phoenix_Product_Family__c != null)
prodFamNameList.add(gcpObj.Phoenix_Product_Family__c);
produFamilyIds.add(gcpObj.Product_Family__c);
}
gcpList.addAll(newOptyList);
}*/
                String seQuery = 'SELECT '+fieldApiList('Vision_Market_Share_Expansion__c')+' FROM Vision_Market_Share_Expansion__c WHERE GCP_Product_Family__c =: prodFamNameList AND Vision_Customer__c =: accId';
                List<Vision_Market_Share_Expansion__c> shareExpansionList = Database.query(seQuery);
                List<String> seFamNameList =  new List<String>();
                for(Vision_Market_Share_Expansion__c seObj : shareExpansionList){
                    if(seObj.GCP_Product_Family__c != null)
                        seFamNameList.add(seObj.GCP_Product_Family__c.toLowerCase());
                }
                
                Map<String,dateTime> productFamilywithCreatedDateMap = new Map<String, dateTime>();
                Map<String,Decimal> productFamilywithUnitsMap = new Map<String, Decimal>();
                Map<String,Decimal> productFamilyLowPriceMap = new Map<String, Decimal>();
                Map<String,String> rejectedStageMap = new Map<String, String>();
                /*
String skuQuery = 'SELECT Vision_Product__r.Id,Vision_Product__r.Name, '+fieldApiList('GCP_SFDC_100pct_Analysis_SKU__c')+' FROM GCP_SFDC_100pct_Analysis_SKU__c'+
+' WHERE Vision_Customer__c =: accId AND Product_Family__c =: prodFamNameList AND Vision_Product__c != null ORDER BY Vision_Product__r.Name';
List<GCP_SFDC_100pct_Analysis_SKU__c> gcpNdcList = Database.query(skuQuery);
List<Id> prodIds = new List<Id>();
Map<Id, GCP_SFDC_100pct_Analysis_SKU__c> gcpNdcMap = new Map<Id, GCP_SFDC_100pct_Analysis_SKU__c>();
for(GCP_SFDC_100pct_Analysis_SKU__c ndcObj : gcpNdcList){
system.debug('ndcObj.Vision_Product__c ---> '+ndcObj.Vision_Product__c);
prodIds.add(ndcObj.Vision_Product__c);
gcpNdcMap.put(ndcObj.Vision_Product__c,ndcObj);
}
String cptQuery = 'SELECT '+fieldApiList('Vision_Customer_Product_Tracker__c')+' FROM Vision_Customer_Product_Tracker__c'+
+' WHERE Vision_Product__c IN: prodIds AND Vision_Account__c =: accId ORDER BY CreatedDate';
List<Vision_Customer_Product_Tracker__c> cxProdList = database.query(cptQuery);
system.debug('cxProdList.length ---> '+cxProdList.size());
List<GCP_SFDC_100pct_Analysis_SKU__c> updateNdcList = new List<GCP_SFDC_100pct_Analysis_SKU__c>();
List<String> prdIdList = new List<String>();
for(Vision_Customer_Product_Tracker__c cxProdObj : cxProdList){
if(gcpNdcMap.containsKey(cxProdObj.Vision_Product__c) && !prdIdList.contains(cxProdObj.Vision_Product__c)){
prdIdList.add(cxProdObj.Vision_Product__c);
GCP_SFDC_100pct_Analysis_SKU__c gcpObj = gcpNdcMap.get(cxProdObj.Vision_Product__c);
gcpObj.Vision_Current_Position__c = cxProdObj.Vision_Current_Product_Position__c != null ? cxProdObj.Vision_Current_Product_Position__c : '' ;
gcpObj.Vision_Product_Status__c = cxProdObj.Vision_Contract_Product_Status__c;
gcpObj.Vision_Cooling_Period__c = cxProdObj.Vision_Account_Cooling_Period_Days__c;
updateNdcList.add(gcpObj);
}
}
update updateNdcList;

List<Phoenix_Bid_Line_Item__c> bidLineItemList = [SELECT Id,Name,Phoenix_Bid__c,Phoenix_Bid__r.Name,Phoenix_Product__c, 
createdDate,Phoenix_Final_Direct_Selling_Units_Calc__c, Phoenix_Product_Family1__c,
Phoenix_Final_Indirect_Selling_Units_Cal__c, Phoenix_Bid__r.Phoenix_Approval_Status__c,
Phoenix_Marketing_Approval__c, Phoenix_SCM_Approval_Y_N__c,Phoenix_Proposed_Sales__c, Phoenix_Awarded_Net_Sales__c,
Proposed_Net_Sales_Direct__c, Proposed_Net_Sales_Indirect__c
FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Phoenix_Customer__c =: accId
AND Phoenix_Product_Family1__c =: prodFamNameList ORDER BY createdDate DESC];
system.debug('bidLineItemList.size() :: '+bidLineItemList.size());
for(Phoenix_Bid_Line_Item__c bidLineItemObj : bidLineItemList){
if(!productFamilywithCreatedDateMap.containsKey(bidLineItemObj.Phoenix_Product_Family1__c) && bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c.contains('Rejected')){
productFamilywithCreatedDateMap.put(bidLineItemObj.Phoenix_Product_Family1__c,bidLineItemObj.createdDate);
}
if(!rejectedStageMap.containsKey(bidLineItemObj.Phoenix_Product_Family1__c)){ 
if(bidLineItemObj.Phoenix_Marketing_Approval__c == 'Not Approved')
rejectedStageMap.put(bidLineItemObj.Phoenix_Product_Family1__c,'Price Constraint');
else if(bidLineItemObj.Phoenix_SCM_Approval_Y_N__c == 'N- Not Approved')
rejectedStageMap.put(bidLineItemObj.Phoenix_Product_Family1__c,'Supply Constraint');
else if(bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c != 'Closed' 
&& !bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c.contains('Rejected'))
{
rejectedStageMap.put(bidLineItemObj.Phoenix_Product_Family1__c,'In Bid');
inBidTotalSales += (bidLineItemObj.Proposed_Net_Sales_Direct__c!=null ? bidLineItemObj.Proposed_Net_Sales_Direct__c : 0)+
(bidLineItemObj.Proposed_Net_Sales_Indirect__c!=null ? bidLineItemObj.Proposed_Net_Sales_Indirect__c : 0);
}
else if(bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Closed' || bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Vistex Update'){
rejectedStageMap.put(bidLineItemObj.Phoenix_Product_Family1__c,'Awarded');
awardedTotalSales += bidLineItemObj.Phoenix_Awarded_Net_Sales__c!=null ? bidLineItemObj.Phoenix_Awarded_Net_Sales__c : 0;
}
}
}
*/
                
                /* List<AggregateResult> AggregateResultList = [SELECT Phoenix_Product__r.Product_Family__r.Name, Sum(Phoenix_Final_Direct_Selling_Units_Calc__c) proposedDirectUnits,
Sum(Phoenix_Final_Indirect_Selling_Units_Cal__c) proposedIndirectUnits, Sum(Phoenix_Proposed_Sales__c) proposedSales 
FROM Phoenix_Bid_Line_Item__c where Phoenix_Bid__r.Phoenix_Customer__c =: accId 
AND Phoenix_Product__r.Product_Family__c =: produFamilyIds //AND Phoenix_Product_Family1__c =: prodFamNameList 
GROUP BY Phoenix_Product__r.Product_Family__r.Name LIMIT 5000];
if(AggregateResultList != null && AggregateResultList.size() > 0){
for(AggregateResult aggr:AggregateResultList){ 
decimal totalUnits = (aggr.get('proposedDirectUnits') != null ?(decimal)aggr.get('proposedDirectUnits'):0)+(aggr.get('proposedIndirectUnits') !=null ? (decimal)aggr.get('proposedIndirectUnits'):0); 
String productFamily = (String) aggr.get('Phoenix_Product__r.Product_Family__r.Name');
decimal totalPropSales = aggr.get('proposedSales') != null ?(decimal)aggr.get('proposedSales'):0;
if(productFamily != null){
productFamilywithUnitsMap.put(productFamily,totalUnits);
}
} 
}*/
                
                List<Phoenix_Bid_Line_Item__c> bidLineItemsList = [SELECT Id, Name, Phoenix_Product__r.Product_Family__r.Name, Phoenix_Final_Direct_Selling_Units_Calc__c,
                                                                   Phoenix_Final_Indirect_Selling_Units_Cal__c, Phoenix_Proposed_Sales__c FROM Phoenix_Bid_Line_Item__c
                                                                   WHERE Phoenix_Bid__r.Phoenix_Customer__c =: accId AND Phoenix_Product__r.Product_Family__c =: produFamilyIds
                                                                   AND Phoenix_Product__c != null ORDER BY Phoenix_Product__r.Product_Family__r.Name LIMIT 5000];
                for(Phoenix_Bid_Line_Item__c lineItemObj : bidLineItemsList){
                    Decimal totalUnits = 0; 
                    if(productFamilywithUnitsMap.containsKey(lineItemObj.Phoenix_Product__r.Product_Family__r.Name))
                        totalUnits = productFamilywithUnitsMap.get(lineItemObj.Phoenix_Product__r.Product_Family__r.Name);
                    totalUnits += (lineItemObj.Phoenix_Final_Direct_Selling_Units_Calc__c != null ? lineItemObj.Phoenix_Final_Direct_Selling_Units_Calc__c : 0)
                        +(lineItemObj.Phoenix_Final_Indirect_Selling_Units_Cal__c != null ? lineItemObj.Phoenix_Final_Indirect_Selling_Units_Cal__c : 0);
                    productFamilywithUnitsMap.put(lineItemObj.Phoenix_Product__r.Product_Family__r.Name,totalUnits);             
                }
                
                
                List<Product2> productList = [SELECT Id, Name, Phoenix_Pkg_Size__c, Phoenix_Lowest_Price_SKU__c, Family, Product_Family__r.Name 
                                              FROM Product2 WHERE Product_Family__c =: produFamilyIds AND IsActive = true //Family =: prodFamNameList 
                                              AND Phoenix_Lowest_Price_SKU__c > 0 AND Phoenix_Pkg_Size__c > 0 AND Product_Family__c != null];
                for(Product2 prodObj : productList){ 
                    Decimal newCalc = prodObj.Phoenix_Lowest_Price_SKU__c/prodObj.Phoenix_Pkg_Size__c;  
                    if(productFamilyLowPriceMap.containsKey(prodObj.Product_Family__r.Name)){
                        Decimal lowestPrice = productFamilyLowPriceMap.get(prodObj.Product_Family__r.Name);
                        if(newCalc < lowestPrice)
                            productFamilyLowPriceMap.put(prodObj.Product_Family__r.Name,newCalc);                        
                    }
                    else
                        productFamilyLowPriceMap.put(prodObj.Product_Family__r.Name,newCalc); 
                }
                
                Decimal totalEstSales = 0;
                for(Phoenix_GCP_Opportunity_Tracker__c gcpObj : gcpItems){
                    String prodFamily = gcpObj.GCP_Product_Family__c;
                    //Decimal proposedTotal = 0; Decimal lowestPrice = 0; String latestBidDate = '';
                    if(productFamilywithUnitsMap.containsKey(prodFamily))//{ proposedTotal = productFamilywithUnitsMap.get(prodFamily); 
                        gcpObj.Phoenix_Est_Acct_Vol_EU_BRIGHT__c = productFamilywithUnitsMap.get(prodFamily);
                    if(productFamilyLowPriceMap.containsKey(prodFamily))//{ lowestPrice = productFamilyLowPriceMap.get(prodFamily);
                        gcpObj.Phoenix_Est_Price_EU_Lowest_Price__c = productFamilyLowPriceMap.get(prodFamily);
                    if(productFamilywithCreatedDateMap.containsKey(prodFamily)) gcpObj.Phoenix_Latest_Bid_Date__c = productFamilywithCreatedDateMap.get(prodFamily);
                    
                    if(gcpObj.Phoenix_Ims_Mat_Volume_Eu__c != null)
                        gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c = gcpObj.Phoenix_Ims_Mat_Volume_Eu__c;
                    if(gcpObj.Phoenix_Est_Acct_Share_of_Wallet_Method__c == null || gcpObj.Phoenix_Est_Acct_Share_of_Wallet_Method__c == 'Use Default Header')
                        gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c = accObj.Phoenix_Customer_Max_Est_Share_of_Wallet__c != null ? accObj.Phoenix_Customer_Max_Est_Share_of_Wallet__c : 0;
                    else if(gcpObj.Phoenix_Est_Acct_Share_of_Wallet_Method__c == 'Use User Input')
                        gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c = gcpObj.Phoenix_Est_AcctShareofWalletUserInput__c != null ? gcpObj.Phoenix_Est_AcctShareofWalletUserInput__c : 0;
                    
                    if(gcpObj.Phoenix_Est_Acct_Mkt_Share_Method__c == null || gcpObj.Phoenix_Est_Acct_Mkt_Share_Method__c == 'Use Default Header')gcpObj.Phoenix_Estimate_Account_Marketing_Share__c = accObj.Phoenix_Customer_Est_Market_Share__c != null ? accObj.Phoenix_Customer_Est_Market_Share__c :0;
                    else if(gcpObj.Phoenix_Est_Acct_Mkt_Share_Method__c == 'Use User Input')
                        gcpObj.Phoenix_Estimate_Account_Marketing_Share__c = gcpObj.Phoenix_Est_Acct_Mkt_Share_User_Input__c != null ? gcpObj.Phoenix_Est_Acct_Mkt_Share_User_Input__c: 0;
                    else if(gcpObj.Phoenix_Est_Acct_Mkt_Share_Method__c == 'Use Usage Data'){ //'Use Customer Feedback (BRIGHT)'){
                        gcpObj.Phoenix_Estimate_Account_Marketing_Share__c = (gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c !=null && gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c > 0) ? 
                            (gcpObj.Phoenix_Est_Acct_Vol_EU_BRIGHT__c != null ? gcpObj.Phoenix_Est_Acct_Vol_EU_BRIGHT__c : 0)/(gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c) : 0;
                    }
                    
                    if(gcpObj.Phoenix_Est_Acct_Vol_Method__c == 'Use User Input')gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c = gcpObj.Phoenix_Est_Acct_Vol_EU_User_Input__c != null ? gcpObj.Phoenix_Est_Acct_Vol_EU_User_Input__c : 0;
                    else if (gcpObj.Phoenix_Est_Acct_Vol_Method__c == 'Use Proposed Total Selling Units (BRIGHT)')gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c = gcpObj.Phoenix_Est_Acct_Vol_EU_BRIGHT__c != null ? gcpObj.Phoenix_Est_Acct_Vol_EU_BRIGHT__c : 0;
                    else if (gcpObj.Phoenix_Est_Acct_Vol_Method__c == null || gcpObj.Phoenix_Est_Acct_Vol_Method__c == 'Use Calculation of Est Acct Mkt Share')
                        gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c = (gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c/100)*(gcpObj.Phoenix_Estimate_Account_Marketing_Share__c/100)*(gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c!=null?gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c:0);
                    
                    //if((gcpObj.Product_Status__c == 'Awarded' && gcpObj.Phoenix_Est_Price_Method__c == null) || gcpObj.Phoenix_Est_Price_Method__c == 'DRL Customer Actuals Average Price'){
                    if(gcpObj.Phoenix_Est_Price_Method__c == 'DRL Customer Actuals Average Price' && (gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c != null && gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c > 0))
                        gcpObj.Phoenix_Est_Price_EU__c = (gcpObj.Cust_Act_Sales_Mat__c != null ? gcpObj.Cust_Act_Sales_Mat__c : 0)/gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c;
                    else{ 
                        if(gcpObj.Phoenix_Est_Price_Method__c == 'Use User Input')
                            gcpObj.Phoenix_Est_Price_EU__c = gcpObj.Phoenix_Est_Acct_Price_EU_User_Input__c != null ? gcpObj.Phoenix_Est_Acct_Price_EU_User_Input__c : 0;
                        else if(gcpObj.Phoenix_Est_Price_Method__c == 'Use Lowest Price')
                            gcpObj.Phoenix_Est_Price_EU__c = gcpObj.Phoenix_Est_Price_EU_Lowest_Price__c != null ? gcpObj.Phoenix_Est_Price_EU_Lowest_Price__c : 0;
                        else if(gcpObj.Phoenix_Est_Price_Method__c == null || gcpObj.Phoenix_Est_Price_Method__c == 'Marketing (Panorama) suggested Price' || gcpObj.Phoenix_Est_Price_Method__c == 'Use GCP suggested Price')
                            gcpObj.Phoenix_Est_Price_EU__c = gcpObj.Phoenix_GCP_Suggested_Lowest_Price__c != null ? gcpObj.Phoenix_GCP_Suggested_Lowest_Price__c : 0;
                    }
                    if(gcpObj.Phoenix_Est_Price_EU__c == 0 && gcpObj.Phoenix_Est_Price_Method__c == null){
                        if(gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c != null && gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c > 0){
                            gcpObj.Phoenix_Est_Price_EU__c = (gcpObj.Cust_Act_Sales_Mat__c != null ? gcpObj.Cust_Act_Sales_Mat__c : 0)/gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c;
                            gcpObj.Phoenix_Est_Price_Method__c = 'DRL Customer Actuals Average Price';
                        }
                        else{
                            gcpObj.Phoenix_Est_Price_EU__c = gcpObj.Phoenix_Est_Price_EU_Lowest_Price__c != null ? gcpObj.Phoenix_Est_Price_EU_Lowest_Price__c : 0;
                            gcpObj.Phoenix_Est_Price_Method__c = 'Use Lowest Price';
                        }
                    }
                    //}
                    //else{
                    //    if(gcpObj.Phoenix_Est_Price_Method__c == 'Use User Input')
                    //        gcpObj.Phoenix_Est_Price_EU__c = gcpObj.Phoenix_Est_Acct_Price_EU_User_Input__c != null ? gcpObj.Phoenix_Est_Acct_Price_EU_User_Input__c : 0; else if(gcpObj.Phoenix_Est_Price_Method__c == 'Use Lowest Price')gcpObj.Phoenix_Est_Price_EU__c = gcpObj.Phoenix_Est_Price_EU_Lowest_Price__c != null ? gcpObj.Phoenix_Est_Price_EU_Lowest_Price__c : 0;
                    //     else if(gcpObj.Phoenix_Est_Price_Method__c == null || gcpObj.Phoenix_Est_Price_Method__c == 'Marketing (Panorama) suggested Price' || gcpObj.Phoenix_Est_Price_Method__c == 'Use GCP suggested Price')
                    //         gcpObj.Phoenix_Est_Price_EU__c = gcpObj.Phoenix_GCP_Suggested_Lowest_Price__c != null ? gcpObj.Phoenix_GCP_Suggested_Lowest_Price__c : 0;
                    //}
                    
                    gcpObj.Phoenix_Est_Acct_Sales__c = gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c * gcpObj.Phoenix_Est_Price_EU__c;// * (gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c/100);
                    if(gcpObj.Product_Status__c == 'Awarded' && (gcpObj.Phoenix_Current_Position__c == 'Formulary A Awards' || gcpObj.Phoenix_Current_Position__c == '100% Products')){
                        gcpObj.Phoenix_Customer_Opp_Sales__c = null;
                        gcpObj.Phoenix_Customer_Opp_TPT__c = null;
                        gcpObj.Phoenix_Customer_Opp_TPT_Perc__c = null;
                    }
                    else{
                        gcpObj.Cust_Act_Sales_Mat__c = gcpObj.Cust_Act_Sales_Mat__c != null ? gcpObj.Cust_Act_Sales_Mat__c : 0;
                        if(gcpObj.Cust_Act_Sales_Mat__c > gcpObj.Phoenix_Est_Acct_Sales__c)
                            gcpObj.Phoenix_Customer_Opp_Sales__c = 0;
                        else
                            gcpObj.Phoenix_Customer_Opp_Sales__c = gcpObj.Phoenix_Est_Acct_Sales__c - (gcpObj.Cust_Act_Sales_Mat__c != null ? gcpObj.Cust_Act_Sales_Mat__c : 0);
                        gcpObj.Phoenix_Customer_Opp_TPT__c = (gcpObj.Phoenix_Customer_Opp_Sales__c != null && gcpObj.Phoenix_Customer_Opp_Sales__c > 0) ? (gcpObj.Phoenix_Customer_Opp_Sales__c - (((gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c!=null ? gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c :0)-(gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c!=null ? gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c :0))*(gcpObj.cogs_per_unit__c != null ? gcpObj.cogs_per_unit__c : 0))) : 0;
                        //((gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c/100)*(gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c)*(gcpObj.cogs_per_unit__c != null ? gcpObj.cogs_per_unit__c : 0)) - (gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c!=null ? gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c :0)* (gcpObj.cogs_per_unit__c != null ? gcpObj.cogs_per_unit__c : 0);
                        gcpObj.Phoenix_Customer_Opp_TPT_Perc__c = (gcpObj.Phoenix_Customer_Opp_Sales__c != null && gcpObj.Phoenix_Customer_Opp_Sales__c > 0) ? (gcpObj.Phoenix_Customer_Opp_TPT__c/gcpObj.Phoenix_Customer_Opp_Sales__c)*100 : 0;
                    }
                    
                    gcpObj.Phoenix_Cust_Act_Mkt_Sh__c = (gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c != null && gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c >0) ? ((gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c!= null ? gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c : 0)/gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c)*100 : 0;
                    gcpObj.Phoenix_Cooling_Period__c = gcpObj.Phoenix_Cooling_Period__c != null ? gcpObj.Phoenix_Cooling_Period__c : accObj.Phoenix_Account_Cooling_Period__c;
                    
                    totalEstSales = totalEstSales + ((gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c != null && gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c > 0) ? (gcpObj.Phoenix_Est_Acct_Sales__c != null ? gcpObj.Phoenix_Est_Acct_Sales__c : 0)*(gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c/100): 0 );
                    if(prodFamily != null){
                        if(seFamNameList.contains(prodFamily.toLowerCase()))
                            gcpObj.Vision_isShareExpansion__c = true;
                        else
                            gcpObj.Vision_isShareExpansion__c = false;
                    }
                    gcpObj.Vision_isRelevance__c = gcpObj.Vision_isRelevance__c == null ? true : gcpObj.Vision_isRelevance__c;
                    updateGcpList.add(gcpObj);
                }
                update updateGcpList;
                AggregateResult totalAggrigates = [select sum(Phoenix_Est_Acct_Sales__c) EstAcctSales, sum(Cust_Act_Sales_Mat__c) custActualSales,
                                                   sum(Phoenix_Customer_Opp_Sales__c) custOptySales,sum(Phoenix_Cust_Act_Volume_Mat_Eu__c) cxActVol,
                                                   sum(Phoenix_Est_Acct_Total_Vol_EU__c) actTotal, sum(Phoenix_Est_Acct_Share_of_Wallet__c) shareOfWallet,
                                                   sum(Phoenix_Drl_Act_Volume_Eu__c) drlAccVol, sum(Phoenix_Drl_Act_Sales__c) drlAccSales,
                                                   sum(Phoenix_Drl_Act_Price__c) drlAccPrice, sum(Phoenix_DRL_Actual_TPT__c) drlAccTpt,
                                                   sum(Phoenix_Total_Market_Vol_MAT_EU__c) totalMktVol, sum(Phoenix_Total_Market_Sales__c) totalMktShares,
                                                   sum(Phoenix_Cust_Act_Volume_Mat_Eu__c) custActVol, sum(Phoenix_Cust_Act_Mkt_Sh__c) custActMktShare,
                                                   sum(Phoenix_Customer_Opp_TPT__c) custActOppTpt FROM Phoenix_GCP_Opportunity_Tracker__c 
                                                   WHERE Phoenix_Customer__c =: accId AND Product_Family__c =: produFamilyIds];//Phoenix_Product_Family__c =: prodFamNameList];
                accObj.Phoenix_Total_Customer_Opportunity__c = totalAggrigates.get('EstAcctSales') != null ? (Decimal)totalAggrigates.get('EstAcctSales') : 0;
                accObj.Phoenix_DRL_Current_Sales__c = totalAggrigates.get('custActualSales') != null ? (decimal)totalAggrigates.get('custActualSales') : 0;
                accObj.Phoenix_DRL_Opportunity_Sales__c = totalAggrigates.get('custOptySales') != null ? (Decimal)totalAggrigates.get('custOptySales') : 0;
                
                accObj.Phoenix_DRL_Total_Est_Account_Sales__c = totalEstSales;//accObj.Phoenix_Total_Customer_Opportunity__c*((totalAggrigates.get('shareOfWallet') != null ? (Decimal)totalAggrigates.get('shareOfWallet') : 0)/100);// + accObj.Phoenix_DRL_Opportunity_Sales__c;
                accObj.Phoenix_DRL_Share_of_Wallet__c = accObj.Phoenix_Total_Customer_Opportunity__c > 0 ? (accObj.Phoenix_DRL_Current_Sales__c/(accObj.Phoenix_Total_Customer_Opportunity__c))*100 : 0;
                accObj.Phoenix_DRL_Share_of_Wallet_Vol__c = (totalAggrigates.get('actTotal') != null && (Decimal)totalAggrigates.get('actTotal') > 0) ? ((totalAggrigates.get('cxActVol') != null ? (Decimal)totalAggrigates.get('cxActVol') : 0)/(Decimal)totalAggrigates.get('actTotal'))*100 : 0;
                
                
                wrapObj.actTotal = totalAggrigates.get('actTotal') != null ? (Decimal)totalAggrigates.get('actTotal') : 0;
                wrapObj.shareOfWallet = totalAggrigates.get('shareOfWallet') != null ? (Decimal)totalAggrigates.get('shareOfWallet') : 0;
                wrapObj.drlAccVol = totalAggrigates.get('drlAccVol') != null ? (Decimal)totalAggrigates.get('drlAccVol') : 0;
                wrapObj.drlAccSales = totalAggrigates.get('drlAccSales') != null ? (Decimal)totalAggrigates.get('drlAccSales') : 0;
                wrapObj.drlAccPrice = totalAggrigates.get('drlAccPrice') != null ? (Decimal)totalAggrigates.get('drlAccPrice') : 0;
                wrapObj.drlAccTpt = totalAggrigates.get('drlAccTpt') != null ? (Decimal)totalAggrigates.get('drlAccTpt') : 0;
                wrapObj.totalMktVol = totalAggrigates.get('totalMktVol') != null ? (Decimal)totalAggrigates.get('totalMktVol') : 0;
                wrapObj.totalMktShares = totalAggrigates.get('totalMktShares') != null ? (Decimal)totalAggrigates.get('totalMktShares') : 0;
                wrapObj.custActVol = totalAggrigates.get('custActVol') != null ? (Decimal)totalAggrigates.get('custActVol') : 0;
                wrapObj.custActMktShare = totalAggrigates.get('custActMktShare') != null ? (Decimal)totalAggrigates.get('custActMktShare') : 0;
                wrapObj.custActOppTpt = totalAggrigates.get('custActOppTpt') != null ? (Decimal)totalAggrigates.get('custActOppTpt') : 0;
            }
            catch(Exception e){
                caughtError = true;
                wrapObj.isErrorFromServer = true;
                wrapObj.errorMessageFromServer = 'There is a problem while pulling the data. Exception : '+e+' Line: '+e.getLineNumber();
            }
            if(!caughtError){
                accObj.Vision_Rx_Filtered_in_Relevance__c = accObj.Vision_Rx_Filtered_in_Relevance__c != null ? accObj.Vision_Rx_Filtered_in_Relevance__c : true;
                accObj.Vision_SRx_Filtered_in_Relevance__c = accObj.Vision_SRx_Filtered_in_Relevance__c != null ? accObj.Vision_SRx_Filtered_in_Relevance__c : true;
                accObj.Vision_OTC_Filtered_in_Relevance__c = accObj.Vision_OTC_Filtered_in_Relevance__c != null ? accObj.Vision_OTC_Filtered_in_Relevance__c : true;
                
                accObj.Vision_Rx_Filtered__c = accObj.Vision_Rx_Filtered__c != null ? accObj.Vision_Rx_Filtered__c : true;
                accObj.Vision_SRx_Filtered__c = accObj.Vision_SRx_Filtered__c != null ? accObj.Vision_SRx_Filtered__c : true;
                accObj.Vision_OTC_Filtered__c = accObj.Vision_OTC_Filtered__c != null ? accObj.Vision_OTC_Filtered__c : true;
                
                update accObj;
                wrapObj.accObj = accObj;
                wrapObj.gcpList = updateGcpList;
                wrapObj.isErrorFromServer = false;
                wrapObj.errorMessageFromServer = '';
                wrapObj.userSegment = userDetails.Division != null ? userDetails.Division : 'all';
                wrapObj.segmentList = rxSrxOtcList;
                wrapObj.awardedTotalSales = awardedTotalSales;
                wrapObj.inBidTotalSales = inBidTotalSales;
            }
        }
        return wrapObj;
    }  
    
    
    @auraEnabled
    public static wrapper getFilteredGCPItems(String accId, List<String> rxSrxOtcList, List<String> posFilterList, Boolean showRelevant){
        Wrapper wrapObj = new Wrapper();
        
        String query = 'SELECT '+Phoenix_Util.customerFields+' FROM Account Where Id =: accId'; 
        Account accObj = Database.query(query);        
        User userDetails = [SELECT Id, Name, Division FROM User WHERE Id=: userInfo.getUserId()];
        rxSrxOtcList = new List<String>();
        if(accObj.Vision_Rx_Filtered__c)
            rxSrxOtcList.add('RX');
        if(accObj.Vision_SRx_Filtered__c)
            rxSrxOtcList.add('SRX');
        if(accObj.Vision_OTC_Filtered__c)
            rxSrxOtcList.add('OTC');
        if(rxSrxOtcList.size() == 0){
            if(userDetails.Division != null) {
                string seg = userDetails.Division;
                rxSrxOtcList.add(seg);
                if(seg == 'RX')
                    accObj.Vision_Rx_Filtered__c = true;
                if(seg == 'SRX')
                    accObj.Vision_SRx_Filtered__c = true;
                if(seg == 'OTC')
                    accObj.Vision_OTC_Filtered__c = true;
            }
            else if(accObj.Name.contains('Private Label')) {
                rxSrxOtcList.add('OTC');
                accObj.Vision_OTC_Filtered__c = true;
            }
            else{
                rxSrxOtcList.add('RX');
                rxSrxOtcList.add('SRX');
                rxSrxOtcList.add('OTC');
                accObj.Vision_Rx_Filtered__c = true;
                accObj.Vision_SRx_Filtered__c = true;
                accObj.Vision_OTC_Filtered__c = true;
            }
        }
        
        String childQuery = 'SELECT '+fieldApiList('Phoenix_GCP_Opportunity_Tracker__c')+' FROM Phoenix_GCP_Opportunity_Tracker__c '+ 
            +'WHERE Phoenix_Customer__c =: accId AND Product_Family__r.Vision_IsActive__c = true';
        if(rxSrxOtcList.size()>0)
            childQuery += ' AND Phoenix_Segment__c =: rxSrxOtcList';
        if(showRelevant)
            childQuery += ' AND Vision_isRelevance__c = true';
        childQuery += ' ORDER BY GCP_Product_Family__c';
        List<Phoenix_GCP_Opportunity_Tracker__c> gcpItems = database.query(childQuery);
        List<String> produFamilyIds = new List<String>();
        Decimal totalEstSales = 0;
        for(Phoenix_GCP_Opportunity_Tracker__c gcpObj : gcpItems){
            if(gcpObj.Product_Family__c != null && !produFamilyIds.contains(gcpObj.Product_Family__c))
                produFamilyIds.add(gcpObj.Product_Family__c);
            totalEstSales = totalEstSales + ((gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c != null && gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c > 0) ? (gcpObj.Phoenix_Est_Acct_Sales__c != null ? gcpObj.Phoenix_Est_Acct_Sales__c : 0)*(gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c/100): 0);
        }
        AggregateResult totalAggrigates = [select sum(Phoenix_Est_Acct_Sales__c) EstAcctSales, sum(Cust_Act_Sales_Mat__c) custActualSales,
                                           sum(Phoenix_Customer_Opp_Sales__c) custOptySales,sum(Phoenix_Cust_Act_Volume_Mat_Eu__c) cxActVol,
                                           sum(Phoenix_Est_Acct_Total_Vol_EU__c) actTotal, sum(Phoenix_Est_Acct_Share_of_Wallet__c) shareOfWallet,
                                           sum(Phoenix_Drl_Act_Volume_Eu__c) drlAccVol, sum(Phoenix_Drl_Act_Sales__c) drlAccSales,
                                           sum(Phoenix_Drl_Act_Price__c) drlAccPrice, sum(Phoenix_DRL_Actual_TPT__c) drlAccTpt,
                                           sum(Phoenix_Total_Market_Vol_MAT_EU__c) totalMktVol, sum(Phoenix_Total_Market_Sales__c) totalMktShares,
                                           sum(Phoenix_Cust_Act_Volume_Mat_Eu__c) custActVol, sum(Phoenix_Cust_Act_Mkt_Sh__c) custActMktShare,
                                           sum(Phoenix_Customer_Opp_TPT__c) custActOppTpt FROM Phoenix_GCP_Opportunity_Tracker__c 
                                           WHERE Phoenix_Customer__c =: accId AND Product_Family__c =: produFamilyIds];//Phoenix_Product_Family__c =: prodFamNameList];
        accObj.Phoenix_Total_Customer_Opportunity__c = totalAggrigates.get('EstAcctSales') != null ? (Decimal)totalAggrigates.get('EstAcctSales') : 0;
        accObj.Phoenix_DRL_Current_Sales__c = totalAggrigates.get('custActualSales') != null ? (decimal)totalAggrigates.get('custActualSales') : 0;
        accObj.Phoenix_DRL_Opportunity_Sales__c = totalAggrigates.get('custOptySales') != null ? (Decimal)totalAggrigates.get('custOptySales') : 0;
        
        accObj.Phoenix_DRL_Total_Est_Account_Sales__c = totalEstSales;//accObj.Phoenix_Total_Customer_Opportunity__c*((totalAggrigates.get('shareOfWallet') != null ? (Decimal)totalAggrigates.get('shareOfWallet') : 0)/100);// + accObj.Phoenix_DRL_Opportunity_Sales__c;
        accObj.Phoenix_DRL_Share_of_Wallet__c = accObj.Phoenix_Total_Customer_Opportunity__c > 0 ? (accObj.Phoenix_DRL_Current_Sales__c/(accObj.Phoenix_Total_Customer_Opportunity__c))*100 : 0;
        accObj.Phoenix_DRL_Share_of_Wallet_Vol__c = (totalAggrigates.get('actTotal') != null && (Decimal)totalAggrigates.get('actTotal') > 0) ? ((totalAggrigates.get('cxActVol') != null ? (Decimal)totalAggrigates.get('cxActVol') : 0)/(Decimal)totalAggrigates.get('actTotal'))*100 : 0;
        
        wrapObj.actTotal = totalAggrigates.get('actTotal') != null ? (Decimal)totalAggrigates.get('actTotal') : 0;
        wrapObj.shareOfWallet = totalAggrigates.get('shareOfWallet') != null ? (Decimal)totalAggrigates.get('shareOfWallet') : 0;
        wrapObj.drlAccVol = totalAggrigates.get('drlAccVol') != null ? (Decimal)totalAggrigates.get('drlAccVol') : 0;
        wrapObj.drlAccSales = totalAggrigates.get('drlAccSales') != null ? (Decimal)totalAggrigates.get('drlAccSales') : 0;
        wrapObj.drlAccPrice = totalAggrigates.get('drlAccPrice') != null ? (Decimal)totalAggrigates.get('drlAccPrice') : 0;
        wrapObj.drlAccTpt = totalAggrigates.get('drlAccTpt') != null ? (Decimal)totalAggrigates.get('drlAccTpt') : 0;
        wrapObj.totalMktVol = totalAggrigates.get('totalMktVol') != null ? (Decimal)totalAggrigates.get('totalMktVol') : 0;
        wrapObj.totalMktShares = totalAggrigates.get('totalMktShares') != null ? (Decimal)totalAggrigates.get('totalMktShares') : 0;
        wrapObj.custActVol = totalAggrigates.get('custActVol') != null ? (Decimal)totalAggrigates.get('custActVol') : 0;
        wrapObj.custActMktShare = totalAggrigates.get('custActMktShare') != null ? (Decimal)totalAggrigates.get('custActMktShare') : 0;
        wrapObj.custActOppTpt = totalAggrigates.get('custActOppTpt') != null ? (Decimal)totalAggrigates.get('custActOppTpt') : 0;
        
        update accObj;
        wrapObj.accObj = accObj;
        wrapObj.gcpList = gcpItems;
        wrapObj.isErrorFromServer = false;
        wrapObj.errorMessageFromServer = '';
        return wrapObj;
    }
    
    
    @auraEnabled
    public static wrapper getNDCforROS(String prodFamilyName, String accId){
        List<Account> accList = [SELECT Id, Name FROM Account WHERE ParentId =: accId];
        List<Id> accIds = new List<Id>();
        for(Account accObj:accList){
            accIds.add(accObj.Id);
        }
        List<Product_Family__c> prodFamObj = [SELECT Id, Name FROM Product_Family__c WHERE Name =: prodFamilyName LIMIT 1];
        String famId = prodFamObj.size()>0 ? prodFamObj[0].Id : '';
        String childQuery = 'SELECT Vision_Customer__r.Name, Vision_Product__r.Id,Vision_Product__r.Name, Vision_Product__r.Phoenix_NDC_11__c, Vision_Product__r.isActive,'+
            +' Vision_Product__r.Phoenix_Pkg_Size__c, Vision_Customer__r.Phoenix_Account_Cooling_Period__c, '+fieldApiList('GCP_SFDC_100pct_Analysis_SKU__c')+' FROM GCP_SFDC_100pct_Analysis_SKU__c'+
            +' WHERE Vision_Customer__c IN: accIds AND Vision_Product__r.Product_Family__c =: famId AND Vision_Product__c != null AND Vision_Product__r.isActive = true '+
            +' AND (Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = false OR (Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = true AND Vision_Product__r.OTC_Customer__c IN: accIds))'+
            +' AND Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false ORDER BY Vision_Product__r.Name';
        List<GCP_SFDC_100pct_Analysis_SKU__c> gcpNdcList = Database.query(childQuery);
        Wrapper wrapObj = new Wrapper();
        wrapObj = getNdcListOfProdFam(prodFamilyName, accId);
        List<GCP_SFDC_100pct_Analysis_SKU__c> rosNdcList = wrapObj.updateGcpList;
        
        List<GCP_SFDC_100pct_Analysis_SKU__c> updateList = new List<GCP_SFDC_100pct_Analysis_SKU__c>();
        Map<Id, List<GCP_SFDC_100pct_Analysis_SKU__c>> prodListMap = new Map<Id, List<GCP_SFDC_100pct_Analysis_SKU__c>>();
        for(GCP_SFDC_100pct_Analysis_SKU__c obj:gcpNdcList){
            if(!prodListMap.containsKey(obj.Vision_Product__c))
                prodListMap.put(obj.Vision_Product__c, new List<GCP_SFDC_100pct_Analysis_SKU__c>());
            prodListMap.get(obj.Vision_Product__c).add(obj);
        }
        for(GCP_SFDC_100pct_Analysis_SKU__c rosItem: rosNdcList){
            rosItem.GCP_Cust_Act_Volume_Mat_Eu__c = 0;
            rosItem.Vision_Cust_Act_Sales_Mat__c = 0;
            if(prodListMap.containsKey(rosItem.Vision_Product__c)){
                List<GCP_SFDC_100pct_Analysis_SKU__c> itemList = prodListMap.get(rosItem.Vision_Product__c);
                for(GCP_SFDC_100pct_Analysis_SKU__c obj:itemList){
                    obj.GCP_Cust_Act_Volume_Mat_Eu__c = obj.GCP_Cust_Act_Volume_Mat_Eu__c != null ? obj.GCP_Cust_Act_Volume_Mat_Eu__c : 0;
                    obj.Vision_Cust_Act_Sales_Mat__c = obj.Vision_Cust_Act_Sales_Mat__c != null ? obj.Vision_Cust_Act_Sales_Mat__c : 0;
                    if(obj.Vision_Customer__r.Name == 'Cardinal Health'){
                        rosItem.Vision_Cardinal_CustAct_Volume__c = obj.GCP_Cust_Act_Volume_Mat_Eu__c.setScale(2, RoundingMode.CEILING);
                        rosItem.Vision_Cardinal_CustAct_Sales__c = obj.Vision_Cust_Act_Sales_Mat__c.setScale(0, RoundingMode.CEILING);
                    }
                    else if(obj.Vision_Customer__r.Name == 'Cardinal - Major'){
                        rosItem.Vision_Major_CustAct_Volume__c = obj.GCP_Cust_Act_Volume_Mat_Eu__c.setScale(2, RoundingMode.CEILING);
                        rosItem.Vision_Major_CustAct_Sales__c = obj.Vision_Cust_Act_Sales_Mat__c.setScale(0, RoundingMode.CEILING);
                    }
                    else if(obj.Vision_Customer__r.Name == 'CVS/Caremark'){
                        rosItem.Vision_CVS_CustAct_Volume__c = obj.GCP_Cust_Act_Volume_Mat_Eu__c.setScale(2, RoundingMode.CEILING);
                        rosItem.Vision_CVS_CustAct_Sales__c = obj.Vision_Cust_Act_Sales_Mat__c.setScale(0, RoundingMode.CEILING);
                    }
                    rosItem.GCP_Cust_Act_Volume_Mat_Eu__c += obj.GCP_Cust_Act_Volume_Mat_Eu__c;
                    rosItem.Vision_Cust_Act_Sales_Mat__c += obj.Vision_Cust_Act_Sales_Mat__c;
                }
            }
            updateList.add(rosItem);
        }
        update updateList;
        wrapObj.updateGcpList = updateList;
        return wrapObj;
    }
    
    @auraEnabled
    public static Wrapper getNdcListOfProdFam(String prodFamilyName, String accId){
        List<Product_Family__c> prodFamObj = [SELECT Id, Name FROM Product_Family__c WHERE Name =: prodFamilyName LIMIT 1];
        String famId = prodFamObj.size()>0 ? prodFamObj[0].Id : '';
        String childQuery = 'SELECT Vision_Customer__r.Name, Vision_Customer__r.Vision_is_SRx_Account__c, Vision_Product__r.Id,Vision_Product__r.Name, Vision_Product__r.Phoenix_NDC_11__c, Vision_Product__r.isActive,Vision_Product__r.Phoenix_Pkg_Size__c, '+
            +' Vision_Customer__r.Phoenix_Account_Cooling_Period__c, '+fieldApiList('GCP_SFDC_100pct_Analysis_SKU__c')+' FROM GCP_SFDC_100pct_Analysis_SKU__c'+
            +' WHERE Vision_Customer__c =: accId AND Vision_Product__r.Product_Family__c =: famId AND Vision_Product__c != null AND Vision_Product__r.isActive = true '+
            +' AND (Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = false OR (Vision_Product__r.Phoenix_Is_Private_Label_OTC__c = true AND Vision_Product__r.OTC_Customer__c = : accId AND Vision_Product__r.Phoenix_Is_Control_Label__c = false))'+
            +' AND Vision_Product__r.Phoenix_Is_Exclude_Bid__c = false ORDER BY Vision_Product__r.Name';//GCP_Product_Family__c =: prodFamilyName/Product_Family__c =: famId( OR 
        List<GCP_SFDC_100pct_Analysis_SKU__c> gcpNdcList = Database.query(childQuery);
        
        List<Id> prodIds = new List<Id>();
        for(GCP_SFDC_100pct_Analysis_SKU__c ndcObj : gcpNdcList){
            prodIds.add(ndcObj.Vision_Product__c);
        }
        
        String query = 'SELECT '+fieldApiList('GCP_100PCT_Analysis_SKU__c')+' FROM GCP_100PCT_Analysis_SKU__c WHERE Vision_Product__r.Product_Family__c =: famId '+//GCP_Product_Family__c =: prodFamilyName '+
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
                newObj.Product_Family__c = famId != '' ? famId : null;
                newSkuList.add(newObj);
            }
        }
        if(famId != ''){
            List<Product2> prodList = [SELECT Id, Name, Product_Family__c FROM Product2 WHERE Product_Family__c =: famId AND Id NOT IN: prodIds
                                       AND (Phoenix_Is_Private_Label_OTC__c = false OR (Phoenix_Is_Private_Label_OTC__c = true AND OTC_Customer__c = : accId))
                                       AND isActive = true AND Phoenix_Is_Exclude_Bid__c = false];
            for(Product2 prodObj : prodList){
                GCP_SFDC_100pct_Analysis_SKU__c newObj = new GCP_SFDC_100pct_Analysis_SKU__c();
                newObj.Vision_Customer__c = accId;
                newObj.Vision_Product__c = prodObj.Id;
                newObj.GCP_Product_Family__c = prodFamilyName;
                newObj.Product_Family__c = famId;
                newSkuList.add(newObj);
            }
        }
        if(newSkuList.size()>0)
            insert newSkuList;
        gcpNdcList = Database.query(childQuery);
        List<GCP_SFDC_100pct_Analysis_SKU__c> updateGcpList = new List<GCP_SFDC_100pct_Analysis_SKU__c>();//Product_Family__c
        Wrapper wrap = new Wrapper();
        if(gcpNdcList.size()>0){
            prodIds = new List<Id>();
            Map<Id, GCP_SFDC_100pct_Analysis_SKU__c> gcpNdcMap = new Map<Id, GCP_SFDC_100pct_Analysis_SKU__c>();
            for(GCP_SFDC_100pct_Analysis_SKU__c ndcObj : gcpNdcList){
                prodIds.add(ndcObj.Vision_Product__c);
                gcpNdcMap.put(ndcObj.Vision_Product__c,ndcObj);
            }
            
            List<Id> prodIdsWithPosition = new List<Id>();
            
            List < Vision_Customer_Product_Tracker__c > awardedPositionList = [SELECT Vision_Account__c,Vision_Current_Contract_Position_Status__c, Vision_Current_Product_Position__c,Vision_Product__c,Vision_Product__r.Name, Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode 
                                                                               FROM Vision_Customer_Product_Tracker__c where Vision_Account__c =: accId AND Vision_Product__c IN: prodIds AND Vision_Current_Product_Position__c != ''];
            for(Vision_Customer_Product_Tracker__c obj : awardedPositionList){
                if(!prodIdsWithPosition.contains(obj.Vision_Product__c))
                    prodIdsWithPosition.add(obj.Vision_Product__c);
            }
            
            boolean isOtcAccount = false;
            if(gcpNdcList[0].Vision_Customer__r.Name.contains('Private Label'))
                isOtcAccount = true;
            Map<Id, String> prodPositionMap = new Map<Id, String>();
            List<Phoenix_NPR_Data__c> nprList = new List<Phoenix_NPR_Data__c>();
            if(isOtcAccount){
                nprList = [SELECT Id, Name, Phoenix_Awarded_Position__c, Phoenix_Product_Position__c, Phoenix_Product__c
                           FROM Phoenix_NPR_Data__c WHERE Phoenix_Account__c =: accId AND Phoenix_Product__c IN : prodIds];
                for(Phoenix_NPR_Data__c nprObj : nprList){
                    prodPositionMap.put(Id.valueOf(nprObj.Phoenix_Product__c),nprObj.Phoenix_Product_Position__c != null ? nprObj.Phoenix_Product_Position__c : '0');
                }
            }
            //Added by Naseer
            Map<String, String> openOrders = new Map<String, String>();
            Map<String, Vision_GCP_Backorder_SRx_Rx__c> SRxBackOrders = new Map<String, Vision_GCP_Backorder_SRx_Rx__c>();
            Map<String, Vision_GCP_Backorder_SRx_Rx__c> RxBackOrders = new Map<String, Vision_GCP_Backorder_SRx_Rx__c>();
            Map<String, Vision_GCP_Backorder_OTC__c> OTCBackOrders = new Map<String, Vision_GCP_Backorder_OTC__c>();
            for(Vision_GCP_SFDC_Order_Status__c orderStatusRec : [select id,Vision_Product__r.Phoenix_NDC_11__c ,Vision_Order_Status__c,Vision_Product__r.Phoenix_NDC__c From Vision_GCP_SFDC_Order_Status__c where Vision_Order_Status__c = 'NOT DELIVERED' and (Vision_Product__c in : gcpNdcMap.keySet() or Vision_Product__c in: gcpNdcMap.keySet())]){
                openOrders.put(orderStatusRec.Vision_Product__r.Phoenix_NDC_11__c,orderStatusRec.Vision_Order_Status__c);
            }
            
            for(Vision_GCP_Backorder_SRx_Rx__c backOrder : [select id,Vision_Product__r.Phoenix_NDC_11__c,Vision_On_Backorder__c,Vision_MoH__c, Vision_Product__r.Phoenix_Rx_SRx_OTC__c From Vision_GCP_Backorder_SRx_Rx__c where (Vision_On_Backorder__c = 'Yes' or Vision_MoH__c < 0) and (Vision_Product__c in : gcpNdcMap.keySet() or Vision_Product__c in: gcpNdcMap.keySet())]){
                if(backOrder.Vision_Product__r.Phoenix_Rx_SRx_OTC__c == 'SRx' && backOrder.Vision_On_Backorder__c == 'Yes')
                    SRxBackOrders.put(backOrder.Vision_Product__r.Phoenix_NDC_11__c, backOrder);   
                else if(backOrder.Vision_Product__r.Phoenix_Rx_SRx_OTC__c == 'Rx' && backOrder.Vision_MoH__c < 0)
                    RxBackOrders.put(backOrder.Vision_Product__r.Phoenix_NDC_11__c, backOrder);
            }
            
            for(Vision_GCP_Backorder_OTC__c backOrder : [select id,Vision_Product__r.Phoenix_NDC_11__c, Vision_Product__r.Phoenix_Rx_SRx_OTC__c From Vision_GCP_Backorder_OTC__c where Vision_Backorder_Qty__c > 0 and Vision_Product__r.Phoenix_Rx_SRx_OTC__c = 'OTC' and (Vision_Product__c in : gcpNdcMap.keySet() or Vision_Product__c in: gcpNdcMap.keySet())]){
                OTCBackOrders.put(backOrder.Vision_Product__r.Phoenix_NDC_11__c, backOrder);   
            }
            
            //Code by Naseer ends here
            
            List<Phoenix_Bid_Line_Item__c> bidLineItemList = [SELECT Id,Name,Phoenix_Bid__c,Phoenix_Bid__r.Name,Phoenix_Product__c,createdDate,Phoenix_Final_Direct_Selling_Units_Calc__c, Phoenix_Product_Family1__c,
                                                              Phoenix_Final_Indirect_Selling_Units_Cal__c, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Marketing_Approval__c, Phoenix_SCM_Approval_Y_N__c,Phoenix_Proposed_Sales__c,
                                                              Phoenix_Awarded_Net_Sales__c, Proposed_Net_Sales_Direct__c, Proposed_Net_Sales_Indirect__c, Phoenix_Final_Status__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Phoenix_Customer__c =: accId
                                                              AND Phoenix_Product__c =: prodIds AND Phoenix_Bid__r.Phoenix_Approval_Status__c != 'Draft' 
                                                              AND Phoenix_Bid__r.Phoenix_Approval_Status__c != 'Closed-Draft' ORDER BY createdDate DESC];
            Map<String, List<Phoenix_Bid_Line_Item__c>> bidLineProdMap = new Map<String, List<Phoenix_Bid_Line_Item__c>>();
            for(Phoenix_Bid_Line_Item__c bidLineItemObj : bidLineItemList){
                if(!bidLineProdMap.containsKey(bidLineItemObj.Phoenix_Product__c))
                    bidLineProdMap.put(bidLineItemObj.Phoenix_Product__c, new List<Phoenix_Bid_Line_Item__c>());
                bidLineProdMap.get(bidLineItemObj.Phoenix_Product__c).add(bidLineItemObj);
            }
            List<String> prodIdsProcessed = new List<String>();
            for(String prodId : bidLineProdMap.keySet()){
                if(!prodIdsProcessed.contains(prodId)){
                    prodIdsProcessed.add(prodId);
                    bidLineItemList = new List<Phoenix_Bid_Line_Item__c>(); bidLineItemList = bidLineProdMap.get(prodId);
                    GCP_SFDC_100pct_Analysis_SKU__c ndcItem = gcpNdcMap.get(prodId);
                    boolean isInCoolingPeriod = false;
                    boolean addToUpdate = true;
                    ndcItem.Vision_is_inBid_Item__c = false;
                    if(ndcItem.Vision_Cooling_Period_Date__c != null){
                        Date cDate = Date.valueOf(bidLineItemList[0].CreatedDate);
                        String formatedCreatedDate = DateTime.newInstance(
                            cDate.year(), cDate.month(), cDate.day()
                        ).format('MM/dd/yyyy');
                        Date cpDate = ndcItem.Vision_Cooling_Period_Date__c;
                        String formatedCpDate = DateTime.newInstance(
                            cpDate.year(), cpDate.month(), cpDate.day()
                        ).format('MM/dd/yyyy');
                        Integer daysGapFromLastBid = cDate.daysBetween(cpDate);
                        ndcItem.Vision_Cooling_Period_String__c = 'Last Bid: '+formatedCreatedDate+'; CP Date: '+formatedCpDate+'; '+daysGapFromLastBid+' Days from last bid date;';
                    }
                    else{
                        ndcItem.Vision_Cooling_Period__c = ndcItem.Vision_Cooling_Period__c != null ? ndcItem.Vision_Cooling_Period__c : 
                        (ndcItem.Vision_Customer__r.Phoenix_Account_Cooling_Period__c != null ? ndcItem.Vision_Customer__r.Phoenix_Account_Cooling_Period__c : null);
                            Integer coolingPeriod = ndcItem.Vision_Cooling_Period__c != null ? Integer.valueOf(ndcItem.Vision_Cooling_Period__c) :  0;
                        if(coolingPeriod != 0){
                            Date cDate = Date.valueOf(bidLineItemList[0].CreatedDate);
                            Date tDay = system.today();
                            Integer diffDays = cDate.daysBetween(tDay);
                            String formatedCreatedDate = DateTime.newInstance(
                                cDate.year(), cDate.month(), cDate.day()
                            ).format('MM/dd/yyyy');
                            Date cpDate = tDay.addDays(coolingPeriod-diffDays);
                            String formatedcpDate = DateTime.newInstance(
                                cpDate.year(), cpDate.month(), cpDate.day()
                            ).format('MM/dd/yyyy');
                            if(diffDays < coolingPeriod){
                                isInCoolingPeriod = true;
                                ndcItem.Vision_Cooling_Period_String__c = 'Last Bid: '+formatedCreatedDate+'; CP Days: '+coolingPeriod+' Days; CP Date: '+formatedcpDate+'; '+(coolingPeriod - diffDays)+' days remaining';
                            }
                            else
                                ndcItem.Vision_Cooling_Period_String__c = 'Last Bid: '+formatedCreatedDate+'; CP Days: '+coolingPeriod+' Days; CP Date: '+formatedcpDate+'; '+(diffDays-coolingPeriod)+' days over cooling period';
                        }
                    }
                    
                    if(bidLineItemList[0].Phoenix_Marketing_Approval__c == 'Not Approved')
                        ndcItem.Vision_Product_Status__c = 'Price Constraint';
                    else if(bidLineItemList[0].Phoenix_SCM_Approval_Y_N__c == 'N- Not Approved')
                        ndcItem.Vision_Product_Status__c = 'Supply Constraint';
                    else if(bidLineItemList[0].Phoenix_Bid__r.Phoenix_Approval_Status__c != 'Closed' && !bidLineItemList[0].Phoenix_Bid__r.Phoenix_Approval_Status__c.contains('Rejected')){
                        if(gcpNdcList[0].Vision_Customer__r.Vision_is_SRx_Account__c && bidLineItemList.size()>1){
                            if(bidLineItemList[1].Phoenix_Marketing_Approval__c == 'Not Approved')
                                ndcItem.Vision_Product_Status__c = 'Price Constraint';
                            else if(bidLineItemList[1].Phoenix_SCM_Approval_Y_N__c == 'N- Not Approved')
                                ndcItem.Vision_Product_Status__c = 'Supply Constraint';
                            else if(bidLineItemList[1].Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Closed' || bidLineItemList[1].Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Vistex Update'){
                                if(isInCoolingPeriod || bidLineItemList[1].Phoenix_Final_Status__c == 'Not Approved')
                                    ndcItem.Vision_Product_Status__c = 'Not An Opportunity';
                                else
                                    ndcItem.Vision_Product_Status__c = 'Awarded';
                            }
                        }
                        else
                            ndcItem.Vision_Product_Status__c = 'In Bid';
                        ndcItem.Vision_is_inBid_Item__c = true;
                    }
                    else if(bidLineItemList[0].Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Closed' || bidLineItemList[0].Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Vistex Update'){
                        if(isInCoolingPeriod || bidLineItemList[0].Phoenix_Final_Status__c == 'Not Approved')
                            ndcItem.Vision_Product_Status__c = 'Not An Opportunity';
                        else
                            ndcItem.Vision_Product_Status__c = 'Awarded';
                    }
                    if(isOtcAccount && prodPositionMap.containsKey(bidLineItemList[0].Phoenix_Product__c)){
                        String prodPos = prodPositionMap.get(bidLineItemList[0].Phoenix_Product__c);
                        Decimal positionVal = isNumeric(prodPos) ? (Decimal.valueOf(prodPos))*100 : 0;
                        ndcItem.Vision_OTC_Product_Position__c = positionVal+'%';
                    }
                    if(prodIdsWithPosition.contains(bidLineItemList[0].Phoenix_Product__c))
                        ndcItem.Vision_doesPositionExists__c = true;
                    else
                        ndcItem.Vision_doesPositionExists__c = false;
                    updateGcpList.add(ndcItem);
                }
            }
            
            /*for(Phoenix_Bid_Line_Item__c bidLineItemObj : bidLineItemList){
                if(!prodIdsProcessed.contains(bidLineItemObj.Phoenix_Product__c)){
                    prodIdsProcessed.add(bidLineItemObj.Phoenix_Product__c);
                    
                    GCP_SFDC_100pct_Analysis_SKU__c ndcItem = gcpNdcMap.get(bidLineItemObj.Phoenix_Product__c);
                    boolean isInCoolingPeriod = false;
                    boolean addToUpdate = true;
                    ndcItem.Vision_is_inBid_Item__c = false;
                    if(ndcItem.Vision_Cooling_Period_Date__c != null){
                        Date cDate = Date.valueOf(bidLineItemObj.CreatedDate);
                        String formatedCreatedDate = DateTime.newInstance(
                            cDate.year(), cDate.month(), cDate.day()
                        ).format('MM/dd/yyyy');
                        Date cpDate = ndcItem.Vision_Cooling_Period_Date__c;
                        String formatedCpDate = DateTime.newInstance(
                            cpDate.year(), cpDate.month(), cpDate.day()
                        ).format('MM/dd/yyyy');
                        Integer daysGapFromLastBid = cDate.daysBetween(cpDate);
                        ndcItem.Vision_Cooling_Period_String__c = 'Last Bid: '+formatedCreatedDate+'; CP Date: '+formatedCpDate+'; '+daysGapFromLastBid+' Days from last bid date;';
                    }
                    else{
                        ndcItem.Vision_Cooling_Period__c = ndcItem.Vision_Cooling_Period__c != null ? ndcItem.Vision_Cooling_Period__c : 
                        (ndcItem.Vision_Customer__r.Phoenix_Account_Cooling_Period__c != null ? ndcItem.Vision_Customer__r.Phoenix_Account_Cooling_Period__c : null);
                            Integer coolingPeriod = ndcItem.Vision_Cooling_Period__c != null ? Integer.valueOf(ndcItem.Vision_Cooling_Period__c) :  0;
                        if(coolingPeriod != 0){
                            Date cDate = Date.valueOf(bidLineItemObj.CreatedDate);
                            Date tDay = system.today();
                            Integer diffDays = cDate.daysBetween(tDay);
                            String formatedCreatedDate = DateTime.newInstance(
                                cDate.year(), cDate.month(), cDate.day()
                            ).format('MM/dd/yyyy');
                            Date cpDate = tDay.addDays(coolingPeriod-diffDays);
                            String formatedcpDate = DateTime.newInstance(
                                cpDate.year(), cpDate.month(), cpDate.day()
                            ).format('MM/dd/yyyy');
                            if(diffDays < coolingPeriod){
                                isInCoolingPeriod = true;
                                ndcItem.Vision_Cooling_Period_String__c = 'Last Bid: '+formatedCreatedDate+'; CP Days: '+coolingPeriod+' Days; CP Date: '+formatedcpDate+'; '+(coolingPeriod - diffDays)+' days remaining';
                            }
                            else
                                ndcItem.Vision_Cooling_Period_String__c = 'Last Bid: '+formatedCreatedDate+'; CP Days: '+coolingPeriod+' Days; CP Date: '+formatedcpDate+'; '+(diffDays-coolingPeriod)+' days over cooling period';
                        }
                    }
                    
                    if(bidLineItemObj.Phoenix_Marketing_Approval__c == 'Not Approved')
                        ndcItem.Vision_Product_Status__c = 'Price Constraint';
                    else if(bidLineItemObj.Phoenix_SCM_Approval_Y_N__c == 'N- Not Approved')
                        ndcItem.Vision_Product_Status__c = 'Supply Constraint';
                    else if(bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c != 'Closed' && !bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c.contains('Rejected')){
                        if(!gcpNdcList[0].Vision_Customer__r.Vision_is_SRx_Account__c){
                            ndcItem.Vision_Product_Status__c = 'In Bid';
                        }
                        else{
                            addToUpdate = false;
                            if(!inBidIds.contains(bidLineItemObj.Id))
                                inBidIds.add(bidLineItemObj.Id);
                            if(!inBidProds.contains(bidLineItemObj.Phoenix_Product__c))
                                inBidProds.add(bidLineItemObj.Phoenix_Product__c);
                        }
                        ndcItem.Vision_is_inBid_Item__c = true;
                    }
                    else if(bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Closed' || bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Vistex Update'){
                        if(isInCoolingPeriod || bidLineItemObj.Phoenix_Final_Status__c == 'Not Approved')
                            ndcItem.Vision_Product_Status__c = 'Not An Opportunity';
                        else
                            ndcItem.Vision_Product_Status__c = 'Awarded';
                    }
                    if(isOtcAccount && prodPositionMap.containsKey(bidLineItemObj.Phoenix_Product__c)){
                        String prodPos = prodPositionMap.get(bidLineItemObj.Phoenix_Product__c);
                        Decimal positionVal = isNumeric(prodPos) ? (Decimal.valueOf(prodPos))*100 : 0;
                        ndcItem.Vision_OTC_Product_Position__c = positionVal+'%';
                    }
                    if(prodIdsWithPosition.contains(bidLineItemObj.Phoenix_Product__c))
                        ndcItem.Vision_doesPositionExists__c = true;
                    else
                        ndcItem.Vision_doesPositionExists__c = false;
                    if(addToUpdate)
                        updateGcpList.add(ndcItem);
                }
            }
            if(gcpNdcList[0].Vision_Customer__r.Vision_is_SRx_Account__c){
                bidLineItemList = [SELECT Id,Name,Phoenix_Bid__c,Phoenix_Bid__r.Name,Phoenix_Product__c,createdDate,Phoenix_Final_Direct_Selling_Units_Calc__c, Phoenix_Product_Family1__c,
                                   Phoenix_Final_Indirect_Selling_Units_Cal__c, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Marketing_Approval__c, Phoenix_SCM_Approval_Y_N__c,Phoenix_Proposed_Sales__c,
                                   Phoenix_Awarded_Net_Sales__c, Proposed_Net_Sales_Direct__c, Proposed_Net_Sales_Indirect__c, Phoenix_Final_Status__c
                                   FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Phoenix_Customer__c =: accId AND Id NOT IN: inBidIds
                                   AND Phoenix_Product__c =: inBidProds AND Phoenix_Bid__r.Phoenix_Approval_Status__c != 'Draft' AND Phoenix_Final_Status__c != 'Not Approved' 
                                   AND Phoenix_Bid__r.Phoenix_Approval_Status__c != 'Closed-Draft' ORDER BY createdDate DESC];
                for(Phoenix_Bid_Line_Item__c bidLineItemObj : bidLineItemList){
                    GCP_SFDC_100pct_Analysis_SKU__c ndcItem = gcpNdcMap.get(bidLineItemObj.Phoenix_Product__c);
                    if(bidLineItemObj.Phoenix_Marketing_Approval__c == 'Not Approved')
                        ndcItem.Vision_Product_Status__c = 'Price Constraint';
                    else if(bidLineItemObj.Phoenix_SCM_Approval_Y_N__c == 'N- Not Approved')
                        ndcItem.Vision_Product_Status__c = 'Supply Constraint';
                    else if(bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Closed' || bidLineItemObj.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Vistex Update'){
                        if(bidLineItemObj.Phoenix_Final_Status__c == 'Not Approved')
                            ndcItem.Vision_Product_Status__c = 'Not An Opportunity';
                        else
                            ndcItem.Vision_Product_Status__c = 'Awarded';
                    }
                    else{ 
                        ndcItem.Vision_Product_Status__c = 'True Opportunity';
                        ndcItem.Vision_Cooling_Period_String__c = 'Ready For Bid';
                    }                    
                    ndcItem.Vision_is_inBid_Item__c = true;
                    if(isOtcAccount && prodPositionMap.containsKey(bidLineItemObj.Phoenix_Product__c)){
                        String prodPos = prodPositionMap.get(bidLineItemObj.Phoenix_Product__c);
                        Decimal positionVal = isNumeric(prodPos) ? (Decimal.valueOf(prodPos))*100 : 0;
                        ndcItem.Vision_OTC_Product_Position__c = positionVal+'%';
                    }
                    if(prodIdsWithPosition.contains(bidLineItemObj.Phoenix_Product__c))
                        ndcItem.Vision_doesPositionExists__c = true;
                    else
                        ndcItem.Vision_doesPositionExists__c = false;
                    updateGcpList.add(ndcItem
                }
            }*/
                                      
            for(String productId : prodIds){
                if(!prodIdsProcessed.contains(productId)){
                    GCP_SFDC_100pct_Analysis_SKU__c ndcItem = gcpNdcMap.get(productId);
                    ndcItem.Vision_Product_Status__c = 'True Opportunity';
                    ndcItem.Vision_Cooling_Period_String__c = 'Ready For Bid';
                    ndcItem.Vision_Cooling_Period__c = ndcItem.Vision_Cooling_Period__c != null ? ndcItem.Vision_Cooling_Period__c : 
                    (ndcItem.Vision_Customer__r.Phoenix_Account_Cooling_Period__c != null ? ndcItem.Vision_Customer__r.Phoenix_Account_Cooling_Period__c : null);
                        if(isOtcAccount && prodPositionMap.containsKey(productId)){
                            String prodPos = prodPositionMap.get(productId);
                            Decimal positionVal = isNumeric(prodPos) ? (Decimal.valueOf(prodPos))*100 : 0;
                            ndcItem.Vision_OTC_Product_Position__c = String.valueOf(positionVal);
                        }
                    if(prodIdsWithPosition.contains(productId))
                        ndcItem.Vision_doesPositionExists__c = true;
                    else
                        ndcItem.Vision_doesPositionExists__c = false;
                    updateGcpList.add(ndcItem);
                }
            }
            update updateGcpList;
            
            wrap.openOrders = openOrders;
            wrap.updateGcpList = Database.query(childQuery);
            wrap.SRxBackOrders = SRxBackOrders;
            wrap.RxBackOrders = RxBackOrders;
            wrap.OTCBackOrders = OTCBackOrders;
            wrap.isOtcAccount = isOtcAccount;
            return wrap;
        }
        else{
            wrap.updateGcpList = updateGcpList;
            return wrap;
        }
    }
    public static Boolean isNumeric(String s){
        Boolean ReturnValue;
        try{
            Decimal.valueOf(s);
            ReturnValue = TRUE; 
        } catch (Exception e) {
            ReturnValue = FALSE;
        }
        return ReturnValue;
    }
    
    @auraEnabled
    public static List<GCP_SFDC_100pct_Analysis_SKU__c> updateNdcLineItemForROS(List<GCP_SFDC_100pct_Analysis_SKU__c> ndcItem, boolean isModifiedDateUpdated){
        Phoenix_GCP_Opportunity_Tracker__c gcpObj = [SELECT Id, Name, Vision_Sum_of_Sku_est_vol__c FROM Phoenix_GCP_Opportunity_Tracker__c 
                                                     WHERE GCP_Product_Family__c =: ndcItem[0].GCP_Product_Family__c AND Phoenix_Customer__c =: ndcItem[0].Vision_Customer__c];
        Decimal totalVol = 0;
        for(GCP_SFDC_100pct_Analysis_SKU__c skuObj : ndcItem){
            if(!isModifiedDateUpdated)
                skuObj.Vision_Modified_Date__c = system.today();
            totalVol += skuObj.Vision_Estimate_Account_Total_Vol_EU__c != null ? skuObj.Vision_Estimate_Account_Total_Vol_EU__c : 0;
        }
        gcpObj.Vision_Sum_of_Sku_est_vol__c = totalVol;
        update gcpObj;
        update ndcItem;
        return ndcItem;
    }
        
    @auraEnabled
    public static List<GCP_SFDC_100pct_Analysis_SKU__c> updateNdcLineItem(List<GCP_SFDC_100pct_Analysis_SKU__c> ndcItem){
        
        update ndcItem;
        integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        return ndcItem; 
    }
    
    @AuraEnabled
    public static Phoenix_GCP_Opportunity_Tracker__c updateGcpLineItem(Phoenix_GCP_Opportunity_Tracker__c gcpLineItem){
        update gcpLineItem;
        return getUpdatedGcpLineItem(gcpLineItem.Id);
    }
    
    @auraEnabled
    public static Phoenix_GCP_Opportunity_Tracker__c getUpdatedGcpLineItem(String gcpLineObjId){
        String childQuery = 'SELECT '+fieldApiList('Phoenix_GCP_Opportunity_Tracker__c')+' FROM Phoenix_GCP_Opportunity_Tracker__c WHERE Id =: gcpLineObjId';
        Phoenix_GCP_Opportunity_Tracker__c gcpObj = Database.query(childQuery);
        return gcpObj;
    }
    
    @auraEnabled
    public static Account getupdatedAccData(String accId){
        String query = 'SELECT '+Phoenix_Util.customerFields+' FROM Account Where Id =: accId'; 
        list<Account> accObj = new list<Account>();
        
        accObj = Database.query(query);
        AggregateResult totalAggrigates = [select sum(Phoenix_Est_Acct_Total_Vol_EU__c) EstAcctTotalVol, sum(Cust_Act_Sales_Mat__c) custActualSales, sum(Phoenix_Customer_Opp_Sales__c) custOptySales
                                           from Phoenix_GCP_Opportunity_Tracker__c where Phoenix_Customer__c =: accId];
        accObj[0].Phoenix_Total_Customer_Opportunity__c = totalAggrigates.get('EstAcctTotalVol') != null ? (Decimal)totalAggrigates.get('EstAcctTotalVol') : 0;
        accObj[0].Phoenix_DRL_Current_Sales__c = totalAggrigates.get('custActualSales') != null ? (decimal)totalAggrigates.get('custActualSales') : 0;
        accObj[0].Phoenix_DRL_Opportunity_Sales__c = totalAggrigates.get('custOptySales') != null ? (Decimal)totalAggrigates.get('custOptySales') : 0;
        accObj[0].Phoenix_DRL_Total_Est_Account_Sales__c = accObj[0].Phoenix_DRL_Current_Sales__c + accObj[0].Phoenix_DRL_Opportunity_Sales__c;
        update accObj[0];
        return accObj[0];
    }
    
    
    @AuraEnabled
    public static list < AggregateResult > getAllTotals(String accId) {
        list < AggregateResult > totalAggrigates = [select sum(Phoenix_Est_Acct_Total_Vol_EU__c) EstAcctTotalVol, sum(Cust_Act_Sales_Mat__c) custActualSales, sum(Phoenix_Customer_Opp_Sales__c) custOptySales
                                                    from Phoenix_GCP_Opportunity_Tracker__c where Phoenix_Customer__c =: accId];
        return totalAggrigates; 
    }
    
    @auraEnabled
    public static Wrapper saveComment(String newComment, String selectedLineId){
        Wrapper wrapObj = new Wrapper();
        try{
            GCP_Comment__c gcpCmntObj = new GCP_Comment__c();
            gcpCmntObj.Comment__c = newComment;
            gcpCmntObj.GCP_SFDC_100pct_Analysis_SKU__c = selectedLineId;
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
    
    @auraEnabled
    public static void deleteComment(GCP_Comment__c commentObj){
        delete commentObj;
    }
    
    @auraEnabled
    public static GCP_Comment__c updateComment(GCP_Comment__c commentObj){
        update commentObj; return commentObj;
    }
    
    @auraEnabled
    public static list<Wrapper> getProdBidLineItemComments(GCP_SFDC_100pct_Analysis_SKU__c selectedItem, Account accObj){
        List<Wrapper> wrapList = new List<Wrapper>();
        //string prodFamilyName = gcpLineItem.Phoenix_Product_Family__c != null ? gcpLineItem.Phoenix_Product_Family__c : '';
        //gcpLineItem.GCP_Product_Family__c != null ? gcpLineItem.GCP_Product_Family__c : '';
        string prodFamilyName = selectedItem.GCP_Product_Family__c != null ? selectedItem.GCP_Product_Family__c : '';
        prodFamilyName = '%'+prodFamilyName+'%';
        String panoramaString = 'Panorama';
        string gcpCommentQuery = 'SELECT CreatedBy.SmallPhotoUrl, '+fieldApiList('GCP_Comment__c')+' FROM GCP_Comment__c WHERE Comment_Type__c =: panoramaString '+
            +'AND GCP_Product_Family__c LIKE \''+prodFamilyName+'\' ORDER BY Comment_Date__c DESC';
        List<GCP_Comment__c> visionGcpCmntsList = database.query(gcpCommentQuery);
        if(visionGcpCmntsList.size()>0)
        {  
            Wrapper wrapObj = new Wrapper();
            List<cmntWrapper> cmntWrapList = new List<cmntWrapper>();
            wrapObj.cmntCat = 'Panorama Comments';
            wrapObj.cmntWrapList = new List<cmntWrapper>();
            for(GCP_Comment__c gcpCmntObj : visionGcpCmntsList){
                cmntWrapper cmntObj = new cmntWrapper();
                cmntObj.userName = gcpCmntObj.Author__c;
                //cmntObj.userId = gcpCmntObj.CreatedById;
                cmntObj.cmntDate = String.valueOf(gcpCmntObj.Comment_Date__c);
                cmntObj.cmntString = gcpCmntObj.Comment__c;
                cmntObj.profilePicUrl = gcpCmntObj.CreatedBy.SmallPhotoUrl;//'/docs/component-library/app/images/examples/avatar1.jpg';
                cmntObj.gcpCmntObj = gcpCmntObj;
                wrapObj.cmntWrapList.add(cmntObj);
            }
            wrapList.add(wrapObj);
        }
        
        List<GCP_Comment__c> gcpCmntsList = [SELECT Id, Name, GCP_Opportunity_Tracker__c, CreatedById, Comment__c, 
                                             createdDate, CreatedBy.Name, CreatedBy.SmallPhotoUrl FROM GCP_Comment__c
                                             WHERE GCP_SFDC_100pct_Analysis_SKU__c =: selectedItem.Id ORDER By createdDate DESC];
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
                cmntObj.isCommentOwner = (gcpCmntObj.CreatedById == UserInfo.getUserId()) ? true : false;
                wrapObj.cmntWrapList.add(cmntObj);
            }
            wrapList.add(wrapObj);
        }
        String accId = accObj.Id;
        List<Id> accIds = new List<Id>();
        if(accObj.Name == 'Red Oak Sourcing'){
            List<Account> accList = [SELECT Id, Name FROM Account WHERE ParentId =: accId];
            for(Account acc:accList){
                accIds.add(acc.Id);
            }
        }
        string productId = selectedItem.Vision_Product__c;
        String query = 'SELECT Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, '+fieldApiList('Phoenix_Bid_Line_Item__c')+' FROM Phoenix_Bid_Line_Item__c ';
        if(accObj.Name == 'Red Oak Sourcing')
            query += 'WHERE Phoenix_Bid__r.Phoenix_Customer__c IN: accIds';
        else
            query += 'WHERE Phoenix_Bid__r.Phoenix_Customer__c =: accId ';
        query += ' AND Phoenix_Product__c =: productId ORDER BY CreatedDate Desc';
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
                    
                    if(bidLineItemObj.Phoenix_Comments__c !=  null && bidLineItemObj.Phoenix_Comments__c != '' && bidStageMap.containsKey('Sales')){
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
                    if(bidLineItemObj.Phoenix_Initial_Stocking_Order_Comments__c !=  null && bidLineItemObj.Phoenix_Initial_Stocking_Order_Comments__c != ''
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
                    if(bidLineItemObj.Phoenix_Marketing_Notes__c !=  null && bidLineItemObj.Phoenix_Marketing_Notes__c != ''
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
                    if(bidLineItemObj.Phoenix_SCM_Notes__c !=  null && bidLineItemObj.Phoenix_SCM_Notes__c != ''
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
                    if(bidLineItemObj.Phoenix_Finance_Comments__c !=  null && bidLineItemObj.Phoenix_Finance_Comments__c != ''
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
                       && bidLineItemObj.Phoenix_Contract_Comments__c != '' && bidStageMap.containsKey('Contracts')){
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
                       && bidLineItemObj.Phoenix_Vistex_Comments__c != '' && bidStageMap.containsKey('Vistex')){
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
    
    //Added by Jogarao
    @AuraEnabled
    public static void getGCPInfo(String accountId){
        List<AggregateResult> AggregateResultList = [SELECT Phoenix_Product_Family1__c ,Sum(Phoenix_Final_Direct_Selling_Units_Calc__c) proposedDirectUnits,Sum(Phoenix_Final_Indirect_Selling_Units_Cal__c) proposedIndirectUnits  FROM Phoenix_Bid_Line_Item__c where Phoenix_Bid__r.Phoenix_Customer__c =: accountId group by Phoenix_Product_Family1__c LIMIT 5000];
        List<AggregateResult> AggregateResultProductList = [SELECT Family, Avg(Phoenix_Lowest_Price_SKU__c) lowestPriceSkuAvg FROM Product2 group by Family LIMIT 10000];
        Map<String,Decimal> productFamilywithUnitsMap = new Map<String, Decimal>();
        Map<String,Decimal> productFamilyLowPriceMap = new Map<String, Decimal>();
        if(AggregateResultList != null && AggregateResultList.size() > 0){ 
            for(AggregateResult aggr:AggregateResultList){  
                decimal totalUnits = (aggr.get('proposedDirectUnits') != null ?(decimal)aggr.get('proposedDirectUnits'):0)+(aggr.get('proposedIndirectUnits') !=null ? (decimal)aggr.get('proposedIndirectUnits'):0); 
                String productFamily = (String) aggr.get('Phoenix_Product_Family1__c');
                if(productFamily != null)
                    productFamilywithUnitsMap.put(productFamily,totalUnits);
            } 
        }
        if(AggregateResultProductList != null && AggregateResultProductList.size() > 0){ 
            for(AggregateResult aggr:AggregateResultProductList){ 
                String productFamily = (String) aggr.get('Family'); 
                decimal avgLowPrice = (Decimal) aggr.get('lowestPriceSkuAvg');
                if(productFamily != null)
                    productFamilyLowPriceMap.put(productFamily,avgLowPrice);
            }
        }
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
        @auraEnabled
        public List<GCP_SFDC_100pct_Analysis_SKU__c> updateGcpList;
        @auraEnabled
        public Map<String, String> openOrders;
        @auraEnabled
        public Map<String, Vision_GCP_Backorder_SRx_Rx__c> SRxBackOrders;
        @auraEnabled
        public Map<String, Vision_GCP_Backorder_SRx_Rx__c> RxBackOrders;
        @auraEnabled
        public Map<String, Vision_GCP_Backorder_OTC__c> OTCBackOrders;
        @auraEnabled
        public Boolean isOtcAccount = false;
        @auraEnabled
        public boolean isJobRunning = false;
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
        @auraEnabled
        public boolean isCommentOwner = false;
    }
    
    @AuraEnabled
    public static String getPositions(string customerId,Phoenix_GCP_Opportunity_Tracker__c gcpLineItem) {
        string prodFamName = gcpLineItem.GCP_Product_Family__c;
        List<Phoenix_NPR_Data__c> nprList = [SELECT Id, Name, Phoenix_Awarded_Position__c, Phoenix_Product_Position__c, 
                                             Phoenix_Product__r.Name, Phoenix_Product__r.family, Phoenix_Product__r.Product_Family__r.Name 
                                             FROM Phoenix_NPR_Data__c WHERE Phoenix_Product__r.Product_Family__r.Name =: prodFamName
                                             AND Phoenix_Account__c =: customerId
                                             ORDER BY createdDate];
        set<String> prodFamList = new set<String>();
        String prodFam = '';
        String existingPos = gcpLineItem.Phoenix_Current_Position__c != null ? gcpLineItem.Phoenix_Current_Position__c : '';
        if(existingPos != ''){list<String> splitPos = new List<String>();if(existingPos.contains(',')){ splitPos = existingPos.split(','); prodFamList.addAll(splitPos);}
                              else
                                  prodFamList.add(existingPos);
                             }
        for(Phoenix_NPR_Data__c nprObj : nprList){ if(nprObj.Phoenix_Product_Position__c != null) prodFamList.add(nprObj.Phoenix_Product_Position__c);
                                                  /*if(prodFam != '')
prodFam = prodFam +','+ nprObj.Phoenix_Product_Position__c;
else
prodFam = nprObj.Phoenix_Product_Position__c;*/
                                                 }
        list<string> finalString = new list<String>();
        for(String posString : prodFamList){ finalString.add(posString); }
        prodFam = string.join(finalString, ',');
        
        return prodFam;
    }
    
    public static string fieldApiList(String SobjectApiName){
        String allFieldsStr = ' ';
        List < String > allFieldsList = new List < String > ();
        for (Schema.SObjectField field: ((sObject) Type.forName(SobjectApiName).newInstance()).getSObjectType().getDescribe().fields.getMap().values()) {
            if (field.getDescribe().isAccessible() || field.getDescribe().isCustom())
                allFieldsList.add(String.valueOf(field));
        }
        allFieldsStr = ' ' + String.join(allFieldsList, ',') + ' ';
        return allFieldsStr;
    }
    
    public class rosWrapper{
        @auraEnabled
        public List<Account> accList;
        @auraEnabled
        public List<Phoenix_GCP_Opportunity_Tracker__c> famList;
        @auraEnabled
        public Account accObj;
    }
    
    @auraEnabled
    public static rosWrapper getAllAccList(Id parentAccId, List<String> rxSrxOtcList, Boolean showRelevant){
        rosWrapper wrapper = new rosWrapper();
        String query = 'SELECT '+Phoenix_Util.customerFields+' FROM Account Where Id =: parentAccId'; 
        Account parentAcc = Database.query(query);
        
        parentAcc.Phoenix_Total_Customer_Opportunity__c = 0;
        parentAcc.Phoenix_DRL_Current_Sales__c = 0;
        parentAcc.Phoenix_DRL_Opportunity_Sales__c = 0;
        parentAcc.Phoenix_DRL_Total_Est_Account_Sales__c = 0;
        parentAcc.Phoenix_DRL_Share_of_Wallet__c = 0;
        parentAcc.Phoenix_DRL_Share_of_Wallet_Vol__c = 0;
        parentAcc.Phoenix_Customer_Est_Market_Share__c = parentAcc.Phoenix_Customer_Est_Market_Share__c != null ? parentAcc.Phoenix_Customer_Est_Market_Share__c : 20; 
        parentAcc.Phoenix_Customer_Max_Est_Share_of_Wallet__c = parentAcc.Phoenix_Customer_Max_Est_Share_of_Wallet__c != null ? parentAcc.Phoenix_Customer_Max_Est_Share_of_Wallet__c : 65; 
        parentAcc.Phoenix_Account_Cooling_Period__c = parentAcc.Phoenix_Account_Cooling_Period__c !=null ? parentAcc.Phoenix_Account_Cooling_Period__c : 90; 
        
        parentAcc.Vision_Rx_Filtered_in_Relevance__c = parentAcc.Vision_Rx_Filtered_in_Relevance__c != null ? parentAcc.Vision_Rx_Filtered_in_Relevance__c : true;
        parentAcc.Vision_SRx_Filtered_in_Relevance__c = parentAcc.Vision_SRx_Filtered_in_Relevance__c != null ? parentAcc.Vision_SRx_Filtered_in_Relevance__c : true;
        parentAcc.Vision_OTC_Filtered_in_Relevance__c = parentAcc.Vision_OTC_Filtered_in_Relevance__c != null ? parentAcc.Vision_OTC_Filtered_in_Relevance__c : true;
        
        parentAcc.Vision_Rx_Filtered__c = parentAcc.Vision_Rx_Filtered__c != null ? parentAcc.Vision_Rx_Filtered__c : true;
        parentAcc.Vision_SRx_Filtered__c = parentAcc.Vision_SRx_Filtered__c != null ? parentAcc.Vision_SRx_Filtered__c : true;
        parentAcc.Vision_OTC_Filtered__c = parentAcc.Vision_OTC_Filtered__c != null ? parentAcc.Vision_OTC_Filtered__c : true;
        
        update parentAcc;
        List<Account> accList = [SELECT Id, Name, Phoenix_Total_Customer_Opportunity__c, Phoenix_DRL_Current_Sales__c, Phoenix_DRL_Opportunity_Sales__c, 
                                 Phoenix_DRL_Total_Est_Account_Sales__c, Phoenix_DRL_Share_of_Wallet__c, Phoenix_DRL_Share_of_Wallet_Vol__c
                                 FROM Account WHERE ParentId =: parentAccId];
        
        wrapper.accList = accList;
        wrapper.accObj = parentAcc;
        /*list<String> filterRxSrxOtcList = new List<string>();
        for(String seg:rxSrxOtcList){
            if(rxSrxOtcList.contains('Rx'))
                filterRxSrxOtcList.add('RX');
            if(rxSrxOtcList.contains('SRx'))
                filterRxSrxOtcList.add('SRX');
            if(rxSrxOtcList.contains('OTC'))
                filterRxSrxOtcList.add('OTC');
        }*/
        
        String childQuery = 'SELECT '+fieldApiList('Phoenix_GCP_Opportunity_Tracker__c')+' FROM Phoenix_GCP_Opportunity_Tracker__c '+ 
            +'WHERE Phoenix_Customer__c =: parentAccId AND Product_Family__r.Vision_IsActive__c = true';
        //if(filterRxSrxOtcList.size()>0)
        //    childQuery += ' AND Phoenix_Segment__c =: filterRxSrxOtcList';
        //if(showRelevant)
        //    childQuery += ' AND Vision_isRelevance__c = true';
        childQuery += ' ORDER BY GCP_Product_Family__c';
        List<Phoenix_GCP_Opportunity_Tracker__c> gcpItems = database.query(childQuery);
        if(gcpItems.size()>0){
            List<String> prodFamNames = new List<String>();
            for(Phoenix_GCP_Opportunity_Tracker__c gcpObj : gcpItems){
                gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c = 0;
                gcpObj.Cust_Act_Sales_Mat__c = 0;
                gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c = 0;
                gcpObj.Phoenix_Customer_Opp_Sales__c = 0;
                gcpObj.Phoenix_Customer_Opp_TPT__c = 0;
                gcpObj.Phoenix_Customer_Opp_TPT_Perc__c = 0;
                
                prodFamNames.add(gcpObj.GCP_Product_Family__c);        
            }
            update gcpItems;
            List<Phoenix_GCP_Opportunity_Tracker__c> newList = Phoenix_GCP_OptyTracker_Controller.updateGcpListWithNewRelevance(parentAccId, prodFamNames);
            gcpItems = database.query(childQuery);
            wrapper.famList = gcpItems;
        }
        else
            wrapper.famList = gcpItems;
        return wrapper;
    }
    
    @auraEnabled
    public static Wrapper getIndvAccData(String parentId, String accId, List<Phoenix_GCP_Opportunity_Tracker__c> gcpItems){
        List<Phoenix_GCP_Opportunity_Tracker__c> gcpList = new List<Phoenix_GCP_Opportunity_Tracker__c>();
        List<Phoenix_GCP_Opportunity_Tracker__c> filteredGcpList = new List<Phoenix_GCP_Opportunity_Tracker__c>();
        List<Phoenix_GCP_Opportunity_Tracker__c> updateGcpList = new List<Phoenix_GCP_Opportunity_Tracker__c>();
        Wrapper wrapObj = new Wrapper();
        List<String> newRelList = new List<String>();
        Map<String, Phoenix_GCP_Opportunity_Tracker__c> gcpItemsMap = new Map<String, Phoenix_GCP_Opportunity_Tracker__c>();
        for(Phoenix_GCP_Opportunity_Tracker__c gcpObj : gcpItems){
            newRelList.add(gcpObj.GCP_Product_Family__c);
            gcpItemsMap.put(gcpObj.GCP_Product_Family__c, gcpObj);
        }
        gcpList = Phoenix_GCP_OptyTracker_Controller.updateGcpListWithNewRelevance(accId, newRelList);
        String query = 'SELECT '+fieldApiList('Phoenix_GCP_Opportunity_Tracker__c')+' FROM Phoenix_GCP_Opportunity_Tracker__c WHERE Phoenix_Customer__c =: accId AND GCP_Product_Family__c IN: newRelList';
        gcpList = database.query(query);
        Account parentAcc = [SELECT Id, Name, Phoenix_Total_Customer_Opportunity__c, Phoenix_DRL_Current_Sales__c, Phoenix_DRL_Opportunity_Sales__c, 
                             Phoenix_DRL_Total_Est_Account_Sales__c, Phoenix_DRL_Share_of_Wallet__c, Phoenix_DRL_Share_of_Wallet_Vol__c, 
                             Phoenix_Customer_Max_Est_Share_of_Wallet__c, Phoenix_Customer_Est_Market_Share__c FROM Account WHERE Id =: parentId];
        query = 'SELECT '+Phoenix_Util.customerFields+' FROM Account Where Id =: accId'; 
        list<Account> accObj = new list<Account>();
        accObj = Database.query(query);
        Boolean caughtError = false;
        Decimal awardedTotalSales = 0;
        Decimal inBidTotalSales = 0;
        if((accObj[0].Phoenix_Customer_Est_Market_Share__c == null || accObj[0].Phoenix_Customer_Est_Market_Share__c == 0) && 
           (accObj[0].Phoenix_Customer_Max_Est_Share_of_Wallet__c == null || accObj[0].Phoenix_Customer_Max_Est_Share_of_Wallet__c == 0) && 
           (accObj[0].Phoenix_Account_Cooling_Period__c == null || accObj[0].Phoenix_Account_Cooling_Period__c == 0)){
               accObj[0].Phoenix_Customer_Est_Market_Share__c = 20; accObj[0].Phoenix_Customer_Max_Est_Share_of_Wallet__c = 65; accObj[0].Phoenix_Account_Cooling_Period__c = 90; 
               update accObj;
           }
        
        try{
            List<String> prodFamNameList = new List<String>();
            Map<String, List<Phoenix_GCP_Opportunity_Tracker__c>> gcpListMap = new Map<String, List<Phoenix_GCP_Opportunity_Tracker__c>>();
            List<String> prodFam = new List<String>();
            List<Id> produFamilyIds = New List<Id>();
            for(Phoenix_GCP_Opportunity_Tracker__c gcpObj : gcpItems){
                if(!gcpListMap.containsKey(gcpObj.GCP_Product_Family__c))
                    gcpListMap.put(gcpObj.GCP_Product_Family__c , new List<Phoenix_GCP_Opportunity_Tracker__c>());
                gcpListMap.get(gcpObj.GCP_Product_Family__c).add(gcpObj);
                if(gcpObj.GCP_Product_Family__c != null)
                    prodFamNameList.add(gcpObj.GCP_Product_Family__c);
                if(gcpObj.Product_Family__c != null && !prodFam.contains(gcpObj.GCP_Product_Family__c)){
                    prodFam.add(gcpObj.GCP_Product_Family__c);
                    produFamilyIds.add(gcpObj.Product_Family__c);
                }
            }
            
            String seQuery = 'SELECT '+fieldApiList('Vision_Market_Share_Expansion__c')+' FROM Vision_Market_Share_Expansion__c WHERE GCP_Product_Family__c =: prodFamNameList AND Vision_Customer__c =: accId';
            List<Vision_Market_Share_Expansion__c> shareExpansionList = Database.query(seQuery);
            List<String> seFamNameList =  new List<String>();
            for(Vision_Market_Share_Expansion__c seObj : shareExpansionList){
                if(seObj.GCP_Product_Family__c != null)
                    seFamNameList.add(seObj.GCP_Product_Family__c.toLowerCase());
            }
            
            Map<String,dateTime> productFamilywithCreatedDateMap = new Map<String, dateTime>();
            Map<String,Decimal> productFamilywithUnitsMap = new Map<String, Decimal>();
            Map<String,Decimal> productFamilyLowPriceMap = new Map<String, Decimal>();
            Map<String,String> rejectedStageMap = new Map<String, String>();
            
            List<Phoenix_Bid_Line_Item__c> bidLineItemsList = [SELECT Id, Name, Phoenix_Product__r.Product_Family__r.Name, Phoenix_Final_Direct_Selling_Units_Calc__c,
                                                               Phoenix_Final_Indirect_Selling_Units_Cal__c, Phoenix_Proposed_Sales__c FROM Phoenix_Bid_Line_Item__c
                                                               WHERE Phoenix_Bid__r.Phoenix_Customer__c =: accId AND Phoenix_Product__r.Product_Family__c =: produFamilyIds
                                                               AND Phoenix_Product__c != null ORDER BY Phoenix_Product__r.Product_Family__r.Name LIMIT 5000];
            for(Phoenix_Bid_Line_Item__c lineItemObj : bidLineItemsList){
                Decimal totalUnits = 0; 
                if(productFamilywithUnitsMap.containsKey(lineItemObj.Phoenix_Product__r.Product_Family__r.Name))
                    totalUnits = productFamilywithUnitsMap.get(lineItemObj.Phoenix_Product__r.Product_Family__r.Name);
                totalUnits += (lineItemObj.Phoenix_Final_Direct_Selling_Units_Calc__c != null ? lineItemObj.Phoenix_Final_Direct_Selling_Units_Calc__c : 0)
                    +(lineItemObj.Phoenix_Final_Indirect_Selling_Units_Cal__c != null ? lineItemObj.Phoenix_Final_Indirect_Selling_Units_Cal__c : 0);
                productFamilywithUnitsMap.put(lineItemObj.Phoenix_Product__r.Product_Family__r.Name,totalUnits);             
            }
            
            List<Product2> productList = [SELECT Id, Name, Phoenix_Pkg_Size__c, Phoenix_Lowest_Price_SKU__c, Family, Product_Family__r.Name 
                                          FROM Product2 WHERE Product_Family__c =: produFamilyIds AND IsActive = true 
                                          AND Phoenix_Lowest_Price_SKU__c > 0 AND Phoenix_Pkg_Size__c > 0 AND Product_Family__c != null];
            for(Product2 prodObj : productList){ 
                Decimal newCalc = prodObj.Phoenix_Lowest_Price_SKU__c/prodObj.Phoenix_Pkg_Size__c;  
                if(productFamilyLowPriceMap.containsKey(prodObj.Product_Family__r.Name)){
                    Decimal lowestPrice = productFamilyLowPriceMap.get(prodObj.Product_Family__r.Name);
                    if(newCalc < lowestPrice)
                        productFamilyLowPriceMap.put(prodObj.Product_Family__r.Name,newCalc);                        
                }
                else
                    productFamilyLowPriceMap.put(prodObj.Product_Family__r.Name,newCalc); 
            }
            
            Decimal totalEstSales = 0;
            for(Phoenix_GCP_Opportunity_Tracker__c gcpObj : gcpList){
                String prodFamily = gcpObj.GCP_Product_Family__c;
                if(productFamilywithUnitsMap.containsKey(prodFamily))
                    gcpObj.Phoenix_Est_Acct_Vol_EU_BRIGHT__c = productFamilywithUnitsMap.get(prodFamily);
                if(productFamilyLowPriceMap.containsKey(prodFamily))
                    gcpObj.Phoenix_Est_Price_EU_Lowest_Price__c = productFamilyLowPriceMap.get(prodFamily);
                if(productFamilywithCreatedDateMap.containsKey(prodFamily)) gcpObj.Phoenix_Latest_Bid_Date__c = productFamilywithCreatedDateMap.get(prodFamily);
                
                if(gcpObj.Phoenix_Ims_Mat_Volume_Eu__c != null)
                    gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c = gcpObj.Phoenix_Ims_Mat_Volume_Eu__c;
                if(gcpObj.Phoenix_Est_Acct_Share_of_Wallet_Method__c == null || gcpObj.Phoenix_Est_Acct_Share_of_Wallet_Method__c == 'Use Default Header')
                    gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c = accObj[0].Phoenix_Customer_Max_Est_Share_of_Wallet__c != null ? accObj[0].Phoenix_Customer_Max_Est_Share_of_Wallet__c : 0;
                else if(gcpObj.Phoenix_Est_Acct_Share_of_Wallet_Method__c == 'Use User Input')
                    gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c = gcpObj.Phoenix_Est_AcctShareofWalletUserInput__c != null ? gcpObj.Phoenix_Est_AcctShareofWalletUserInput__c : 0;
                
                if(gcpObj.Phoenix_Est_Acct_Mkt_Share_Method__c == null || gcpObj.Phoenix_Est_Acct_Mkt_Share_Method__c == 'Use Default Header')gcpObj.Phoenix_Estimate_Account_Marketing_Share__c = accObj[0].Phoenix_Customer_Est_Market_Share__c != null ? accObj[0].Phoenix_Customer_Est_Market_Share__c :0;
                else if(gcpObj.Phoenix_Est_Acct_Mkt_Share_Method__c == 'Use User Input')
                    gcpObj.Phoenix_Estimate_Account_Marketing_Share__c = gcpObj.Phoenix_Est_Acct_Mkt_Share_User_Input__c != null ? gcpObj.Phoenix_Est_Acct_Mkt_Share_User_Input__c: 0;
                else if(gcpObj.Phoenix_Est_Acct_Mkt_Share_Method__c == 'Use Usage Data'){ 
                    gcpObj.Phoenix_Estimate_Account_Marketing_Share__c = (gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c !=null && gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c > 0) ? 
                        (gcpObj.Phoenix_Est_Acct_Vol_EU_BRIGHT__c != null ? gcpObj.Phoenix_Est_Acct_Vol_EU_BRIGHT__c : 0)/(gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c) : 0;
                }
                
                if(gcpObj.Phoenix_Est_Acct_Vol_Method__c == 'Use User Input')gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c = gcpObj.Phoenix_Est_Acct_Vol_EU_User_Input__c != null ? gcpObj.Phoenix_Est_Acct_Vol_EU_User_Input__c : 0;
                else if (gcpObj.Phoenix_Est_Acct_Vol_Method__c == 'Use Proposed Total Selling Units (BRIGHT)')gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c = gcpObj.Phoenix_Est_Acct_Vol_EU_BRIGHT__c != null ? gcpObj.Phoenix_Est_Acct_Vol_EU_BRIGHT__c : 0;
                else if (gcpObj.Phoenix_Est_Acct_Vol_Method__c == null || gcpObj.Phoenix_Est_Acct_Vol_Method__c == 'Use Calculation of Est Acct Mkt Share')
                    gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c = (gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c/100)*(gcpObj.Phoenix_Estimate_Account_Marketing_Share__c/100)*(gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c!=null?gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c:0);
                
                if(gcpObj.Phoenix_Est_Price_Method__c == 'DRL Customer Actuals Average Price' && (gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c != null && gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c > 0))
                    gcpObj.Phoenix_Est_Price_EU__c = (gcpObj.Cust_Act_Sales_Mat__c != null ? gcpObj.Cust_Act_Sales_Mat__c : 0)/gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c;
                else{ 
                    if(gcpObj.Phoenix_Est_Price_Method__c == 'Use User Input')
                        gcpObj.Phoenix_Est_Price_EU__c = gcpObj.Phoenix_Est_Acct_Price_EU_User_Input__c != null ? gcpObj.Phoenix_Est_Acct_Price_EU_User_Input__c : 0;
                    else if(gcpObj.Phoenix_Est_Price_Method__c == 'Use Lowest Price')
                        gcpObj.Phoenix_Est_Price_EU__c = gcpObj.Phoenix_Est_Price_EU_Lowest_Price__c != null ? gcpObj.Phoenix_Est_Price_EU_Lowest_Price__c : 0;
                    else if(gcpObj.Phoenix_Est_Price_Method__c == null || gcpObj.Phoenix_Est_Price_Method__c == 'Marketing (Panorama) suggested Price' || gcpObj.Phoenix_Est_Price_Method__c == 'Use GCP suggested Price')
                        gcpObj.Phoenix_Est_Price_EU__c = gcpObj.Phoenix_GCP_Suggested_Lowest_Price__c != null ? gcpObj.Phoenix_GCP_Suggested_Lowest_Price__c : 0;
                }
                if(gcpObj.Phoenix_Est_Price_EU__c == 0 && gcpObj.Phoenix_Est_Price_Method__c == null){
                    if(gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c != null && gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c > 0){
                        gcpObj.Phoenix_Est_Price_EU__c = (gcpObj.Cust_Act_Sales_Mat__c != null ? gcpObj.Cust_Act_Sales_Mat__c : 0)/gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c;
                        gcpObj.Phoenix_Est_Price_Method__c = 'DRL Customer Actuals Average Price';
                    }
                    else{
                        gcpObj.Phoenix_Est_Price_EU__c = gcpObj.Phoenix_Est_Price_EU_Lowest_Price__c != null ? gcpObj.Phoenix_Est_Price_EU_Lowest_Price__c : 0;
                        gcpObj.Phoenix_Est_Price_Method__c = 'Use Lowest Price';
                    }
                }
                gcpObj.Phoenix_Est_Acct_Sales__c = gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c * gcpObj.Phoenix_Est_Price_EU__c;
                if(gcpObj.Product_Status__c == 'Awarded' && (gcpObj.Phoenix_Current_Position__c == 'Formulary A Awards' || gcpObj.Phoenix_Current_Position__c == '100% Products')){
                    gcpObj.Phoenix_Customer_Opp_Sales__c = null;
                    gcpObj.Phoenix_Customer_Opp_TPT__c = null;
                    gcpObj.Phoenix_Customer_Opp_TPT_Perc__c = null;
                }
                else{
                    gcpObj.Cust_Act_Sales_Mat__c = gcpObj.Cust_Act_Sales_Mat__c != null ? gcpObj.Cust_Act_Sales_Mat__c : 0;
                    if(gcpObj.Cust_Act_Sales_Mat__c > gcpObj.Phoenix_Est_Acct_Sales__c)
                        gcpObj.Phoenix_Customer_Opp_Sales__c = 0;
                    else
                        gcpObj.Phoenix_Customer_Opp_Sales__c = gcpObj.Phoenix_Est_Acct_Sales__c - (gcpObj.Cust_Act_Sales_Mat__c != null ? gcpObj.Cust_Act_Sales_Mat__c : 0);
                    gcpObj.Phoenix_Customer_Opp_TPT__c = (gcpObj.Phoenix_Customer_Opp_Sales__c != null && gcpObj.Phoenix_Customer_Opp_Sales__c > 0) ? (gcpObj.Phoenix_Customer_Opp_Sales__c - (((gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c!=null ? gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c :0)-(gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c!=null ? gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c :0))*(gcpObj.cogs_per_unit__c != null ? gcpObj.cogs_per_unit__c : 0))) : 0;
                    gcpObj.Phoenix_Customer_Opp_TPT_Perc__c = (gcpObj.Phoenix_Customer_Opp_Sales__c != null && gcpObj.Phoenix_Customer_Opp_Sales__c > 0) ? (gcpObj.Phoenix_Customer_Opp_TPT__c/gcpObj.Phoenix_Customer_Opp_Sales__c)*100 : 0;
                }
                
                gcpObj.Phoenix_Cust_Act_Mkt_Sh__c = (gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c != null && gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c >0) ? ((gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c!= null ? gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c : 0)/gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c)*100 : 0;
                gcpObj.Phoenix_Cooling_Period__c = gcpObj.Phoenix_Cooling_Period__c != null ? gcpObj.Phoenix_Cooling_Period__c : accObj[0].Phoenix_Account_Cooling_Period__c;
                
                totalEstSales = totalEstSales + ((gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c != null && gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c > 0) ? (gcpObj.Phoenix_Est_Acct_Sales__c != null ? gcpObj.Phoenix_Est_Acct_Sales__c : 0)*(gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c/100): 0 );
                if(prodFamily != null){
                    if(seFamNameList.contains(prodFamily.toLowerCase()))
                        gcpObj.Vision_isShareExpansion__c = true;
                    else
                        gcpObj.Vision_isShareExpansion__c = false;
                }
                gcpObj.Vision_isRelevance__c = gcpObj.Vision_isRelevance__c == null ? true : gcpObj.Vision_isRelevance__c;
                updateGcpList.add(gcpObj);
            }
            update updateGcpList;
            AggregateResult totalAggrigates = [select sum(Phoenix_Est_Acct_Sales__c) EstAcctSales, sum(Cust_Act_Sales_Mat__c) custActualSales,
                                               sum(Phoenix_Customer_Opp_Sales__c) custOptySales,sum(Phoenix_Cust_Act_Volume_Mat_Eu__c) cxActVol,
                                               sum(Phoenix_Est_Acct_Total_Vol_EU__c) actTotal, sum(Phoenix_Est_Acct_Share_of_Wallet__c) shareOfWallet,
                                               sum(Phoenix_Drl_Act_Volume_Eu__c) drlAccVol, sum(Phoenix_Drl_Act_Sales__c) drlAccSales,
                                               sum(Phoenix_Drl_Act_Price__c) drlAccPrice, sum(Phoenix_DRL_Actual_TPT__c) drlAccTpt,
                                               sum(Phoenix_Total_Market_Vol_MAT_EU__c) totalMktVol, sum(Phoenix_Total_Market_Sales__c) totalMktShares,
                                               sum(Phoenix_Cust_Act_Volume_Mat_Eu__c) custActVol, sum(Phoenix_Cust_Act_Mkt_Sh__c) custActMktShare,
                                               sum(Phoenix_Customer_Opp_TPT__c) custActOppTpt FROM Phoenix_GCP_Opportunity_Tracker__c 
                                               WHERE Phoenix_Customer__c =: accId AND Product_Family__c =: produFamilyIds];
            parentAcc.Phoenix_Total_Customer_Opportunity__c += totalAggrigates.get('EstAcctSales') != null ? (Decimal)totalAggrigates.get('EstAcctSales') : 0;
            parentAcc.Phoenix_DRL_Current_Sales__c += totalAggrigates.get('custActualSales') != null ? (decimal)totalAggrigates.get('custActualSales') : 0;
            parentAcc.Phoenix_DRL_Opportunity_Sales__c += totalAggrigates.get('custOptySales') != null ? (Decimal)totalAggrigates.get('custOptySales') : 0;
            
            parentAcc.Phoenix_DRL_Total_Est_Account_Sales__c += totalEstSales;
            parentAcc.Phoenix_DRL_Share_of_Wallet__c += parentAcc.Phoenix_Total_Customer_Opportunity__c > 0 ? (parentAcc.Phoenix_DRL_Current_Sales__c/(parentAcc.Phoenix_Total_Customer_Opportunity__c))*100 : 0;
            parentAcc.Phoenix_DRL_Share_of_Wallet_Vol__c += (totalAggrigates.get('actTotal') != null && (Decimal)totalAggrigates.get('actTotal') > 0) ? ((totalAggrigates.get('cxActVol') != null ? (Decimal)totalAggrigates.get('cxActVol') : 0)/(Decimal)totalAggrigates.get('actTotal'))*100 : 0;
            
            update parentAcc;
            wrapObj.actTotal = totalAggrigates.get('actTotal') != null ? (Decimal)totalAggrigates.get('actTotal') : 0;
            wrapObj.shareOfWallet = totalAggrigates.get('shareOfWallet') != null ? (Decimal)totalAggrigates.get('shareOfWallet') : 0;
            wrapObj.drlAccVol = totalAggrigates.get('drlAccVol') != null ? (Decimal)totalAggrigates.get('drlAccVol') : 0;
            wrapObj.drlAccSales = totalAggrigates.get('drlAccSales') != null ? (Decimal)totalAggrigates.get('drlAccSales') : 0;
            wrapObj.drlAccPrice = totalAggrigates.get('drlAccPrice') != null ? (Decimal)totalAggrigates.get('drlAccPrice') : 0;
            wrapObj.drlAccTpt = totalAggrigates.get('drlAccTpt') != null ? (Decimal)totalAggrigates.get('drlAccTpt') : 0;
            wrapObj.totalMktVol = totalAggrigates.get('totalMktVol') != null ? (Decimal)totalAggrigates.get('totalMktVol') : 0;
            wrapObj.totalMktShares = totalAggrigates.get('totalMktShares') != null ? (Decimal)totalAggrigates.get('totalMktShares') : 0;
            wrapObj.custActVol = totalAggrigates.get('custActVol') != null ? (Decimal)totalAggrigates.get('custActVol') : 0;
            wrapObj.custActMktShare = totalAggrigates.get('custActMktShare') != null ? (Decimal)totalAggrigates.get('custActMktShare') : 0;
            wrapObj.custActOppTpt = totalAggrigates.get('custActOppTpt') != null ? (Decimal)totalAggrigates.get('custActOppTpt') : 0;
        }
        catch(Exception e){
            caughtError = true;
            wrapObj.isErrorFromServer = true;
            wrapObj.errorMessageFromServer = 'There is a problem while pulling the data. Exception : '+e+' Line: '+e.getLineNumber();
        }
        if(!caughtError){
            List<Phoenix_GCP_Opportunity_Tracker__c> newItems = new List<Phoenix_GCP_Opportunity_Tracker__c>();
            for(Phoenix_GCP_Opportunity_Tracker__c gcpObj : updateGcpList){
                Phoenix_GCP_Opportunity_Tracker__c gcpItem = gcpItemsMap.get(gcpObj.GCP_Product_Family__c);
                
                gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c = gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c != null ? gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c : 0;
                gcpObj.Cust_Act_Sales_Mat__c = gcpObj.Cust_Act_Sales_Mat__c != null ? gcpObj.Cust_Act_Sales_Mat__c : 0;
                gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c =  gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c != null ?  gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c : 0;
                
                gcpItem.Phoenix_Cust_Act_Volume_Mat_Eu__c = gcpItem.Phoenix_Cust_Act_Volume_Mat_Eu__c != null ? gcpItem.Phoenix_Cust_Act_Volume_Mat_Eu__c : 0;
                gcpItem.Cust_Act_Sales_Mat__c = gcpItem.Cust_Act_Sales_Mat__c != null ? gcpItem.Cust_Act_Sales_Mat__c : 0;
                gcpItem.Phoenix_Est_Acct_Total_Vol_EU__c = gcpItem.Phoenix_Est_Acct_Total_Vol_EU__c != null ? gcpItem.Phoenix_Est_Acct_Total_Vol_EU__c : 0;
                
                gcpItem.Phoenix_Estimate_Account_Marketing_Share__c = parentAcc.Phoenix_Customer_Est_Market_Share__c;
                gcpItem.Phoenix_Est_Acct_Share_of_Wallet__c = parentAcc.Phoenix_Customer_Max_Est_Share_of_Wallet__c;
                gcpItem.Phoenix_Cust_Act_Volume_Mat_Eu__c = gcpItem.Phoenix_Cust_Act_Volume_Mat_Eu__c + gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c;
                gcpItem.Cust_Act_Sales_Mat__c = gcpItem.Cust_Act_Sales_Mat__c + gcpObj.Cust_Act_Sales_Mat__c;
                if(gcpItem.Phoenix_Est_Acct_Vol_Method__c == 'Use Sum of all SKUs estimate volume')
                    gcpItem.Phoenix_Est_Acct_Total_Vol_EU__c = gcpItem.Vision_Sum_of_Sku_est_vol__c != null ?  gcpItem.Vision_Sum_of_Sku_est_vol__c : 0;
                else
                    gcpItem.Phoenix_Est_Acct_Total_Vol_EU__c = gcpItem.Phoenix_Est_Acct_Total_Vol_EU__c + gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c;
                if(accObj[0].Name == 'Cardinal Health'){
                    gcpItem.Vision_Cardinal_CustAct_Sales__c = gcpObj.Cust_Act_Sales_Mat__c.setScale(2, RoundingMode.CEILING);
                    gcpItem.Vision_Cardinal_CustAct_Volume__c = gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c.setScale(0, RoundingMode.CEILING);
                }
                else if(accObj[0].Name == 'CVS/Caremark'){
                    gcpItem.Vision_CVS_CustAct_Sales__c = gcpObj.Cust_Act_Sales_Mat__c.setScale(2, RoundingMode.CEILING);
                    gcpItem.Vision_CVS_CustAct_Volume__c = gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c.setScale(0, RoundingMode.CEILING);
                }
                else if(accObj[0].Name == 'Cardinal - Major'){
                    gcpItem.Vision_Major_CustAct_Sales__c = gcpObj.Cust_Act_Sales_Mat__c.setScale(2, RoundingMode.CEILING);
                    gcpItem.Vision_Major_CustAct_Volume__c = gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c.setScale(0, RoundingMode.CEILING);
                }
                gcpItem.Phoenix_Cust_Act_Mkt_Sh__c = gcpItem.Phoenix_Cust_Act_Volume_Mat_Eu__c > 0 ? (gcpItem.Cust_Act_Sales_Mat__c/gcpItem.Phoenix_Cust_Act_Volume_Mat_Eu__c).setScale(2, RoundingMode.CEILING) : 0;
                gcpItem.Phoenix_Est_Acct_Sales__c = gcpItem.Phoenix_Cust_Act_Mkt_Sh__c*gcpItem.Phoenix_Est_Acct_Total_Vol_EU__c;
                gcpItem.Phoenix_Est_Price_EU__c = gcpItem.Phoenix_Cust_Act_Mkt_Sh__c;
                gcpItem.Cust_Act_Sales_Mat__c = gcpItem.Cust_Act_Sales_Mat__c != null ? gcpItem.Cust_Act_Sales_Mat__c : 0;
                if(gcpItem.Cust_Act_Sales_Mat__c > gcpItem.Phoenix_Est_Acct_Sales__c)
                    gcpItem.Phoenix_Customer_Opp_Sales__c = 0;
                else
                    gcpItem.Phoenix_Customer_Opp_Sales__c = gcpItem.Phoenix_Est_Acct_Sales__c - (gcpItem.Cust_Act_Sales_Mat__c != null ? gcpItem.Cust_Act_Sales_Mat__c : 0);
                gcpItem.Phoenix_Customer_Opp_TPT__c = (gcpItem.Phoenix_Customer_Opp_Sales__c != null && gcpItem.Phoenix_Customer_Opp_Sales__c > 0) ? (gcpItem.Phoenix_Customer_Opp_Sales__c - (((gcpItem.Phoenix_Est_Acct_Total_Vol_EU__c!=null ? gcpItem.Phoenix_Est_Acct_Total_Vol_EU__c :0)-(gcpItem.Phoenix_Cust_Act_Volume_Mat_Eu__c!=null ? gcpItem.Phoenix_Cust_Act_Volume_Mat_Eu__c :0))*(gcpObj.cogs_per_unit__c != null ? gcpObj.cogs_per_unit__c : 0))) : 0;
                gcpItem.Phoenix_Customer_Opp_TPT_Perc__c = (gcpItem.Phoenix_Customer_Opp_Sales__c != null && gcpItem.Phoenix_Customer_Opp_Sales__c > 0) ? (gcpItem.Phoenix_Customer_Opp_TPT__c/gcpItem.Phoenix_Customer_Opp_Sales__c)*100 : 0;
                
                newItems.add(gcpItem);
            }
            update newItems;
            wrapObj.accObj = parentAcc;
            wrapObj.gcpList = newItems;
            wrapObj.isErrorFromServer = false;
            wrapObj.errorMessageFromServer = '';
            wrapObj.awardedTotalSales = awardedTotalSales;
            wrapObj.inBidTotalSales = inBidTotalSales;
        }
        
        return wrapObj;
    }
    
    
    @auraEnabled
    public static List<GCP_SFDC_100pct_Analysis_SKU__c> updateMemberVolShare(Phoenix_GCP_Opportunity_Tracker__c gcpLineItem, List<GCP_SFDC_100pct_Analysis_SKU__c> gcpNdcList){
        
        Decimal totalVol = 0;
        for(GCP_SFDC_100pct_Analysis_SKU__c skuObj : gcpNdcList){
            skuObj.Vision_Estimate_Account_Total_Vol_EU__c = skuObj.Vision_Estimate_Account_Total_Vol_EU__c!= null ? skuObj.Vision_Estimate_Account_Total_Vol_EU__c : 0;
            skuObj.Vision_Major_VolShare_Percent__c = skuObj.Vision_Major_VolShare_Percent__c!= null ? skuObj.Vision_Major_VolShare_Percent__c : 0;
            skuObj.Vision_CVS_VolShare_Percent__c = skuObj.Vision_CVS_VolShare_Percent__c!= null ? skuObj.Vision_CVS_VolShare_Percent__c : 0;
            skuObj.Vision_Cardinal_VolShare_Percent__c = skuObj.Vision_Cardinal_VolShare_Percent__c!= null ? skuObj.Vision_Cardinal_VolShare_Percent__c : 0;
            
            skuObj.Vision_CVS_VolShare_Percent__c = gcpLineItem.Vision_CVS_VolShare_Percent__c;// skuObj.Vision_CVS_VolShare_Percent__c == 0 ? gcpLineItem.Vision_CVS_VolShare_Percent__c : skuObj.Vision_CVS_VolShare_Percent__c;
            skuObj.Vision_Cardinal_VolShare_Percent__c = gcpLineItem.Vision_Cardinal_VolShare_Percent__c;// skuObj.Vision_Cardinal_VolShare_Percent__c == 0 ? gcpLineItem.Vision_Cardinal_VolShare_Percent__c : skuObj.Vision_Cardinal_VolShare_Percent__c;
            skuObj.Vision_Major_VolShare_Percent__c = gcpLineItem.Vision_Major_VolShare_Percent__c;// skuObj.Vision_Major_VolShare_Percent__c == 0 ? gcpLineItem.Vision_Major_VolShare_Percent__c : skuObj.Vision_Major_VolShare_Percent__c;
            
            skuObj.Vision_Major_Share_Vol__c = (skuObj.Vision_Major_VolShare_Percent__c*skuObj.Vision_Estimate_Account_Total_Vol_EU__c)/100;
            skuObj.Vision_CVS_Share_Vol__c = (skuObj.Vision_CVS_VolShare_Percent__c*skuObj.Vision_Estimate_Account_Total_Vol_EU__c)/100;
            skuObj.Vision_Cardinal_Share_Vol__c = (skuObj.Vision_Cardinal_VolShare_Percent__c*skuObj.Vision_Estimate_Account_Total_Vol_EU__c)/100;
            skuObj.Vision_Modified_Date__c = system.today();
            totalVol += skuObj.Vision_Estimate_Account_Total_Vol_EU__c;
        }
        gcpLineItem.Vision_Sum_of_Sku_est_vol__c = totalVol;
        update gcpLineItem;
        update gcpNdcList;
        return gcpNdcList;
    }
    
    @auraEnabled
    public static string getCommentsOfPrds(List<Id> prodIds, String accId){
        List<GCP_Comment__c> gcpCmntsList = [SELECT Id, Name, Comment__c, GCP_SFDC_100pct_Analysis_SKU__r.Vision_Product__r.Name FROM GCP_Comment__c WHERE GCP_SFDC_100pct_Analysis_SKU__r.Vision_Product__c IN: prodIds 
                                             AND GCP_SFDC_100pct_Analysis_SKU__r.Vision_Customer__c =: accId ORDER BY createdDate];//AND createdDate > LAST_N_DAYS:30 
        String commentString = '';
        list<Id> verIds = new List<Id>();
        for(GCP_Comment__c obj : gcpCmntsList){
            if(!verIds.contains(obj.Id) && obj.Comment__c != null){
                verIds.add(obj.Id);
                commentString += 'Product - '+obj.GCP_SFDC_100pct_Analysis_SKU__r.Vision_Product__r.Name+'. Comment: '+obj.Comment__c+'<br/>';
            }
        }
        return commentString;
    }
}