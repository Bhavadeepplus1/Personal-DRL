public class VisionExceptionProductsReportCls {
    @AuraEnabled
    public static finalWrapper getData(Date startDate, Date endDate, List<String> selectionList){
        List<Phoenix_Bid_Line_Item__c> bidLineItems = [SELECT Phoenix_Bid__r.Name, Phoenix_Product__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c >=: startDate AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c <=: endDate];
        Set<Id> productIds = new Set<Id>();
        for(Phoenix_Bid_Line_Item__c item: bidLineItems){
            productIds.add(item.Phoenix_Product__c);
        }
        List<Product2> otcProducts = new List<Product2>();
        if(selectionList.indexOf('OTC') != -1){
            selectionList.remove(selectionList.indexOf('OTC'));
            otcProducts = [SELECT Id, Name, Family, Product_Family__r.Name, Product_Family__c, ProductCode, Phoenix_Rx_SRx_OTC__c, Phoenix_Finished_Goods_Mfactured_Country__c, Phoenix_Finished_Goods_Supplier_Name__c, Phoenix_API_Manufactured_Country__c, Phoenix_API_Supplier_Name__c FROM Product2 WHERE Phoenix_Is_Exclude_Bid__c = false AND IsActive=true AND Id NOT IN: productIds AND Phoenix_Rx_SRx_OTC__c = 'OTC' AND Phoenix_Is_Control_Label__c=true ORDER BY Product_Family__r.Name ASC NULLS LAST];
        }
        //List<Product2> products = [SELECT Id, Name, Family, ProductCode, Phoenix_Rx_SRx_OTC__c, Phoenix_Finished_Goods_Mfactured_Country__c, Phoenix_Finished_Goods_Supplier_Name__c, Phoenix_API_Manufactured_Country__c, Phoenix_API_Supplier_Name__c FROM Product2 WHERE Phoenix_Is_Exclude_Bid__c = false AND IsActive=true AND Id NOT IN: productIds AND Phoenix_Rx_SRx_OTC__c IN: selectionList AND Phoenix_Is_Private_Label_OTC__c=false AND Phoenix_Is_Control_Label__c=true ORDER BY Family ASC NULLS LAST];
        List<Product2> products = [SELECT Id, Name, Family, Product_Family__r.Name, Product_Family__c, ProductCode, Phoenix_Rx_SRx_OTC__c, Phoenix_Finished_Goods_Mfactured_Country__c, Phoenix_Finished_Goods_Supplier_Name__c, Phoenix_API_Manufactured_Country__c, Phoenix_API_Supplier_Name__c FROM Product2 WHERE Phoenix_Is_Exclude_Bid__c = false AND IsActive=true AND Id NOT IN: productIds AND Phoenix_Rx_SRx_OTC__c IN: selectionList ORDER BY Product_Family__r.Name ASC NULLS LAST];
        products.addAll(otcProducts);
        Set<Id> noBidProducts = new Set<Id>();
        Map<String, innerWrapper> familyMap = new Map<String, innerWrapper>();
        Map<String, Phoenix_Bid__c> bidMap = new Map<String, Phoenix_Bid__c>();
        Integer rxCount = 0; Integer srxCount = 0; Integer otcCount=0;
        for(Product2 item: products){
            Wrapper wrap = new Wrapper();
            wrap.product = item;
            wrap.showDrawer = false;
            wrap.isLastBidNull = true;
            wrap.daysSinceLastBid = 0;
            noBidProducts.add(item.Id);
            if(familyMap.containsKey(item.Product_Family__r.Name)){
                innerWrapper innerWrap = familyMap.get(item.Product_Family__r.Name);
                List<Wrapper> wrapper = innerWrap.wrapper;
                Map<String, Decimal> summaryMap = new Map<String, Decimal>();
                summaryMap.put('salesSummary', 0);
                wrapper.add(wrap);
                innerWrap.wrapper = wrapper;
                innerWrap.summaryMap = summaryMap;
                innerWrap.family = item.Product_Family__r.Name;
                innerWrap.familyId = item.Product_Family__c;
                innerWrap.isSalesNull = true;
                familyMap.put(item.Product_Family__r.Name, innerWrap);
            } else{
                List<Wrapper> wrapper = new List<Wrapper>();
                Map<String, Decimal> summaryMap = new Map<String, Decimal>();
                summaryMap.put('salesSummary', 0);
                innerWrapper innerWrap = new innerWrapper();
                wrapper.add(wrap);
                innerWrap.wrapper = wrapper;
                innerWrap.summaryMap = summaryMap;
                innerWrap.family = item.Product_Family__r.Name;
                innerWrap.isSalesNull = true;
                innerWrap.familyId = item.Product_Family__c;
                familyMap.put(item.Product_Family__r.Name, innerWrap);
            }
        }
        rxCount = [SELECT count() FROM Product2 WHERE Phoenix_Is_Exclude_Bid__c = false AND Id NOT IN: productIds AND IsActive=true AND Phoenix_Rx_SRx_OTC__c = 'Rx'];
        srxCount = [SELECT count() FROM Product2 WHERE Phoenix_Is_Exclude_Bid__c = false AND Id NOT IN: productIds AND IsActive=true AND Phoenix_Rx_SRx_OTC__c = 'SRx'];
        otcCount = [SELECT count() FROM Product2 WHERE Phoenix_Is_Exclude_Bid__c = false AND Id NOT IN: productIds AND IsActive=true AND Phoenix_Rx_SRx_OTC__c = 'OTC' AND Phoenix_Is_Control_Label__c=true];
        List<Phoenix_Bid_Line_Item__c> lastBidLineItems = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Bid__c, Phoenix_Product__c, Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Product__c IN: noBidProducts AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c <: startDate ORDER BY Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c DESC];
        for(Phoenix_Bid_Line_Item__c item: lastBidLineItems){
            if(!bidMap.containsKey(item.Phoenix_Product__c)){
                bidMap.put(item.Phoenix_Product__c, item.Phoenix_Bid__r);
            }
        }
        
        for(String key: familyMap.keySet()){
            innerWrapper innerWrap = familyMap.get(key);
            for(Wrapper wrap: innerWrap.wrapper){
                if(bidMap.containsKey(wrap.product.Id)){
                    wrap.bid = bidMap.get(wrap.product.Id);
                    wrap.daysSinceLastBid = (bidMap.get(wrap.product.Id).Phoenix_Sent_to_Customer_Date__c).daysBetween(Date.valueOf(system.today()));
                    wrap.isLastBidNull = false;
                }
            }
            familyMap.put(key, innerWrap);
        }
        
        Map<Id, GCP_100PCT_Analysis_SKU__c> actualsMap = new Map<Id, GCP_100PCT_Analysis_SKU__c>();
        List<GCP_100PCT_Analysis_SKU__c> marketShareRecords = [SELECT Id, Name, Vision_Product__c, Vision_Product__r.Family, Product_Family__r.Name, Product_Family__c, Vision_Product__r.Name, Vision_Product__r.ProductCode, drl_act_volume_eu__c, DRL_Act_Sales__c, DRL_Act_Price__c, DRL_Act_Tpt__c, DRL_Act_Tpt_Pct__c FROM GCP_100PCT_Analysis_SKU__c WHERE Vision_Product__c IN: noBidProducts];
        Map<String, Map<String, Decimal>> summaryMap = new Map<String, Map<String, Decimal>>();
        for(AggregateResult agg: [SELECT Product_Family__r.Name family, SUM(drl_act_volume_eu__c) vol, SUM(DRL_Act_Sales__c) sales,  SUM(DRL_Act_Tpt__c) tpt FROM GCP_100PCT_Analysis_SKU__c WHERE Vision_Product__c IN: noBidProducts GROUP BY Product_Family__r.Name]){
            Map<String, Decimal> innerMap = new Map<String, Decimal>();
            innerMap.put('volumeSummary', (Decimal)agg.get('vol'));
            innerMap.put('salesSummary', (Decimal)agg.get('sales'));
            innerMap.put('tptDollarSummary', (Decimal)agg.get('tpt'));
            innerMap.put('tptPercentSummary', ((Decimal)agg.get('tpt')/(Decimal)agg.get('sales')));
            summaryMap.put(String.valueOf(agg.get('family')), innerMap);
        }
        for(GCP_100PCT_Analysis_SKU__c item: marketShareRecords){
            if(familyMap.containsKey(item.Product_Family__r.Name)){
                innerWrapper innerWrap = familyMap.get(item.Product_Family__r.Name);
                for(Wrapper wrap: innerWrap.wrapper){
                    if(wrap.product.Id == item.Vision_Product__c){
                        wrap.marketShareRecord = item;
                    }
                }
                if(summaryMap.containsKey(item.Product_Family__r.Name)){
                 	innerWrap.summaryMap = summaryMap.get(item.Product_Family__r.Name);
                }
                innerWrap.isSalesNull = false;
                familyMap.put(item.Product_Family__r.Name, innerWrap);
            }
        }     
        finalWrapper finalWrap = new finalWrapper();
        finalWrap.familyMap = familyMap;
        finalWrap.productsCount = noBidProducts.size();
        finalWrap.rxCount = rxCount;
        finalWrap.srxCount = srxCount;
        finalWrap.otcCount = otcCount;
        return finalWrap;
    }
    
    public class Wrapper {
        @AuraEnabled public Product2 product;
        @AuraEnabled public Phoenix_Bid__c bid;
        @AuraEnabled public GCP_100PCT_Analysis_SKU__c marketShareRecord;
        @AuraEnabled public boolean showDrawer;
        @AuraEnabled public Integer daysSinceLastBid;
        @AuraEnabled public Boolean isLastBidNull;
    }    
    
    public class innerWrapper{
        @AuraEnabled public List<Wrapper> wrapper;
        @AuraEnabled public Map<String, Decimal> summaryMap;
        @AuraEnabled public String family;
        @AuraEnabled public String familyId;
        @AuraEnabled public Boolean isSalesNull;
    }
    
    public class finalWrapper{
        @AuraEnabled public Map<String, innerWrapper> familyMap;
        @AuraEnabled public Integer productsCount;
        @AuraEnabled public Integer rxCount;
        @AuraEnabled public Integer srxCount;
        @AuraEnabled public Integer otcCount;
    }
}