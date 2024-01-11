trigger VisionPanoramaTaskNotification on Vision_Market_Share_Expansion__c (after insert) {
//Map<CustId,map<Family,List<Expansion>
    Map<String, List<Vision_Market_Share_Expansion__c>> expMap = new Map<String, List<Vision_Market_Share_Expansion__c>>();
    for(Vision_Market_Share_Expansion__c mktExp: [SELECT Id, Vision_Customer__r.Name, Vision_Panorama_Submitter_Email__c, Move_Ident__c,
                                                  Plan_Contract_Effective_Date__c,Vision_Customer__r.Owner.Name, 
                                                  Vision_Customer__r.Owner.Email,Target_Volume__c,Vision_Product_Family__c,
                                                  Vision_Customer__r.OwnerId, Vision_Customer__r.Phoenix_Customer_Class_Bid_Template__c,Vision_Product__r.Name,
                                                  Vision_Product__r.Phoenix_Product_Director__r.Email, Vision_Product__r.ProductCode, Vision_Product__r.Phoenix_GPI_Generic_Product_Identifier__c, Vision_Product__r.Phoenix_GCN_Generic_Code_Number__c,Vision_Product__r.Phoenix_GCN_Sequence_Number__c, Vision_Product__r.Family,Vision_Product__r.Phoenix_Strength__c,Vision_Product__r.Phoenix_Lowest_Price_SKU__c, Vision_Product__r.Description,ProductOpportunity__r.Opportunity__r.Name,ProductOpportunity__r.Opportunity__r.Id,Vision_Product__r.Phoenix_NDC_11__c, Vision_Product__r.Phoenix_Pkg_Size__c FROM Vision_Market_Share_Expansion__c WHERE Id IN:trigger.new]){
        if(!expMap.containsKey(mktExp.Vision_Customer__c))
            expMap.put(mktExp.Vision_Customer__c, new List<Vision_Market_Share_Expansion__c>());
        expMap.get(mktExp.Vision_Customer__c).add(mktExp);
    }
    //Map<Cust, List<Exp>>
    Map<String, Map<String, List<Vision_Market_Share_Expansion__c>>> finalExpMap = new Map<String, Map<String, List<Vision_Market_Share_Expansion__c>>>();
    for(String customerId: expMap.keySet()){
        Map<String, List<Vision_Market_Share_Expansion__c>> familyMap = new Map<String, List<Vision_Market_Share_Expansion__c>>();
        for(Vision_Market_Share_Expansion__c mktExpRec: expMap.get(customerId)){
            if(!familyMap.containsKey(mktExpRec.Vision_Product_Family__c))
                familyMap.put(mktExpRec.Vision_Product_Family__c, new List<Vision_Market_Share_Expansion__c>());
            familyMap.get(mktExpRec.Vision_Product_Family__c).add(mktExpRec);
        }
        finalExpMap.put(customerId, familyMap);
    }
    //Map<Cust, Map<Fam, List<Exp>>>
    
    VisionPanoramaNotificationCls.notifyUsers(finalExpMap);
    
}