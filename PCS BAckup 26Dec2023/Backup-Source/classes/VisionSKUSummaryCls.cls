public class VisionSKUSummaryCls {
    public class Wrapper{
        @AuraEnabled public Phoenix_Bid__c bidRecord ;
        @AuraEnabled public string bidName{ get; set; }
        @AuraEnabled public string accName{ get; set; }
        @AuraEnabled public Id accId{ get; set; }
        @AuraEnabled public string prodName{ get; set; }
        @AuraEnabled public string ndc{ get; set; }
        @AuraEnabled public string bidId{ get; set; }
        @AuraEnabled public string bidIds{ get; set; }
        @AuraEnabled public string bidNames{ get; set; }
        @AuraEnabled public string prodId{ get; set; }
        @AuraEnabled public decimal overallMark{ get; set;}
        @AuraEnabled public decimal drlMarkShare{ get; set;}
        @AuraEnabled public decimal doses{ get; set;}
        @AuraEnabled public Decimal custVol{ get; set;}
        @AuraEnabled public String testVar{get;set;}
    }

    @AuraEnabled
    public static String getName(String userId) {
        return UserInfo.getName();
    }
    @AuraEnabled 
    public static List<Wrapper> IMSData(List<String> userRelatedLineItems){
        List<Wrapper> wrapList= new List<Wrapper>();
        for(String lineItemId: userRelatedLineItems){
            Wrapper wrap= new Wrapper();
            wrap = VisionSKUSummaryCls.getIMSMarketShare(lineItemId);
            wrap.testVar = lineItemId;
            wrapList.add(wrap);
        }   
        return wrapList;
    }
    @AuraEnabled 
    public static Wrapper getIMSMarketShare(String LineItemId){
        Phoenix_Bid_Line_Item__c bidItem=[select Phoenix_Bid__c, Product_Family__c, Product_Family_Name__c, Phoenix_Final_Total_Selling_Unit__c,Phoenix_Doses__c, Phoenix_Bid__r.Name,Phoenix_Product__c from Phoenix_Bid_Line_Item__c where Id=:LineItemId];
        Phoenix_Bid__c bid=[select Id, Phoenix_Customer__c,Phoenix_Customer__r.Name from Phoenix_Bid__c where Id=:bidItem.Phoenix_Bid__c];
        Decimal testDoses =0.0;
        Product2 prod=[select Id, Name,Phoenix_NDC_11__c,Phoenix_Overall_market__c,Phoenix_DRL_Market_Share__c,Family,Product_Family__r.Name from Product2 where Id=:bidItem.Phoenix_Product__c LIMIT 1];
        List<Phoenix_Bid_Line_Item__c> bidItemFamily=[select Product_Family__c, Product_Family_Name__c, Phoenix_Doses__c,Phoenix_Pkg_Size1__c, Phoenix_Final_Total_Selling_Unit__c,Phoenix_Bid__r.Name,Phoenix_Product__c from Phoenix_Bid_Line_Item__c 
                                                      where Product_Family_Name__c=:prod.Product_Family__r.Name AND Phoenix_Bid__c=:bid.Id];
        Decimal famDose=0.0;
        for(Phoenix_Bid_Line_Item__c bidItemFam:bidItemFamily){
            famDose=famDose+bidItemFam.Phoenix_Doses__c;
            if(bidItemFam.Phoenix_Pkg_Size1__c!=null){
                testDoses=testDoses+(bidItemFam.Phoenix_Final_Total_Selling_Unit__c*bidItemFam.Phoenix_Pkg_Size1__c);
            }
        }
        Wrapper wrap= new Wrapper();
        if(prod.Phoenix_Overall_market__c!=null){
            wrap.overallMark=prod.Phoenix_Overall_market__c;
        }
        if(prod.Phoenix_DRL_Market_Share__c!=null){
            wrap.drlMarkShare=prod.Phoenix_DRL_Market_Share__c;
        }
        wrap.prodId=prod.Id;
        wrap.prodName=prod.Name;
        wrap.ndc=prod.Phoenix_NDC_11__c;
        wrap.bidId=bidItem.Phoenix_Bid__c;
        wrap.bidName=bidItem.Phoenix_Bid__r.Name;
        wrap.accId=bid.Phoenix_Customer__c;
        wrap.accName=bid.Phoenix_Customer__r.Name;
        wrap.doses=famDose;
        wrap.custVol=testDoses/12;
        return wrap;
    }
}