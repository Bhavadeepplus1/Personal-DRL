public class PreventOpportunityCls {
    @AuraEnabled
    public static wrapperClass getOpportunityProductsList(String opptyId){
        wrapperClass wrapperClsObj = new wrapperClass();
        Opportunity oppObj = [SELECT Id, Name, StageName FROM Opportunity WHERE Id =: opptyId];
        List<Product_Opportunity__c> opportunityProducts = [SELECT Opportunity__r.StageName,Vision_Annual_Wmt_Units__c,Vision_Total_Annual_Units__c, 
                                                            Is_GSN_Pack_Size_Matched__c, Is_GPI_Pack_Size_Matched__c, Is_GCN_Pack_Size_Matched__c,
                                                            Is_GCN_Matched__c,Is_NDC_Matched__c, Id, Status__c FROM Product_Opportunity__c Where Opportunity__c=:opptyId]; 
        //List<ListView> listviews = [SELECT Id, Name FROM ListView WHERE SobjectType = 'Opportunity'];
        String opportunityStage;
        for(Product_Opportunity__c opty : opportunityProducts){
            if(opty.Status__c == 'Matched')
                wrapperClsObj.matchedProducts++;
            else if(opty.Status__c == 'Unmatched')
                wrapperClsObj.unmatchedProducts++;
            else if(opty.Status__c == 'discrepant')
                wrapperClsObj.discrepencyProducts++;
            /*opportunityStage = opty.Opportunity__r.StageName; 
            if((opty.Is_GSN_Pack_Size_Matched__c || opty.Is_GPI_Pack_Size_Matched__c || opty.Is_GCN_Pack_Size_Matched__c || opty.Is_GCN_Matched__c || opty.Is_NDC_Matched__c) && opty.Vision_Total_Annual_Units__c!=0){
                wrapperClsObj.matchedProducts = (wrapperClsObj.matchedProducts !=null? wrapperClsObj.matchedProducts:0)+1;
            }else if(opty.Vision_Total_Annual_Units__c==0 && (opty.Is_GSN_Pack_Size_Matched__c || opty.Is_GPI_Pack_Size_Matched__c || opty.Is_GCN_Pack_Size_Matched__c || opty.Is_GCN_Matched__c || opty.Is_NDC_Matched__c)){
                wrapperClsObj.discrepencyProducts = (wrapperClsObj.discrepencyProducts !=null? wrapperClsObj.discrepencyProducts:0)+1;
            }else{
                wrapperClsObj.unmatchedProducts = (wrapperClsObj.unmatchedProducts !=null? wrapperClsObj.unmatchedProducts:0)+1;
            }
            */
        }
        wrapperClsObj.totalProducts = opportunityProducts.size();
		 wrapperClsObj.opportunityStage = oppObj.StageName;
        //wrapperClsObj.listviews=listviews;
        return wrapperClsObj;
    }
    @AuraEnabled
    public static void deleteOpportunity(String opptyId){
        List<Opportunity> opty = [SELECT Id,(SELECT Id FROM Product_Opportunity__r) FROM Opportunity WHERE Id=:opptyId];
        if(opty !=null && opty.size()>0){
            delete opty;
            if(opty[0].Product_Opportunity__r !=null && opty[0].Product_Opportunity__r.size()>0){
                List<Product_Opportunity__c> productListtoDelte = new List<Product_Opportunity__c>();
                productListtoDelte.addAll(opty[0].Product_Opportunity__r);
                delete productListtoDelte;
            }
        }
    }
    public class wrapperClass{
        @AuraEnabled public Integer matchedProducts = 0;
        @AuraEnabled public Integer unmatchedProducts = 0;
        @AuraEnabled public Integer totalProducts = 0;
        @AuraEnabled public Integer discrepencyProducts = 0;
        @AuraEnabled public String opportunityStage;
        @AuraEnabled public List<ListView> listviews;
        wrapperClass(){
            listviews=new List<ListView>();
        }
    }
}