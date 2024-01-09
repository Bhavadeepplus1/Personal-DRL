public class Phoenix_AwardedQtycontroller {
    @AuraEnabled
    public static  list<Phoenix_Awarded_Quantity__c> getPositions(string custresId) {
        /*Map<Id,Phoenix_Contract__c> bidLineItemrecordsMap =new Map<Id,Phoenix_Contract__c>([SELECT Id,Phoenix_Contract_Internal_Description__c,Phoenix_Contract_Number__c from Phoenix_Contract__c]);
        Map<String,Id> ContractNumwithIdMap = new Map<String,Id>();
        Map<String,String> ContractDeswithNumMap = new Map<String,String>();
        for(Phoenix_Contract__c item : bidLineItemrecordsMap.values() ){
            ContractNumwithIdMap.put(item.Phoenix_Contract_Number__c,item.Id);
            ContractDeswithNumMap.put(item.Phoenix_Contract_Number__c,item.Phoenix_Contract_Internal_Description__c);
        } */
        list<Phoenix_Awarded_Quantity__c> AwardedQtyListRec = new list<Phoenix_Awarded_Quantity__c>(); 
        AwardedQtyListRec=[select Id,GCP_Product_Family__c, GCP_Product_Family__r.Name, Customer_Name__c,Phoenix_Product__r.ProductCode,Contract_Internal_Description__c,Phoenix_Awarded_Quantity__c,Phoenix_Awarded_Position__c,Phoenix_Contract_Number__c,Phoenix_Bid_Line_Item__c,Phoenix_Effective_Date__c,Phoenix_Supply_Effective_Date__c,Phoenix_Customer__c,Customer_Response_Line__c from Phoenix_Awarded_Quantity__c where Customer_Response_Line__c=:custresId];
        if(AwardedQtyListRec.Size() == 0){
            Phoenix_Customer_Response_Line__c cr=[Select id,Product_Family__c, Product_Family__r.Name,Phoenix_Bid_Line_Item__r.Phoenix_Product__r.ProductCode,Phoenix_Bid_Line_Item__r.Phoenix_Product__c,Phoenix_Bid__c,Phoenix_Bid_Line_Item__c,Phoenix_Customer_Response__c,Phoenix_Award_Position__c,Phoenix_Price_Effective_Date__c,Phoenix_Supply_Effective_Date__c,Phoenix_Awarded_Quantity__c,Phoenix_Customer_Response__r.Phoenix_Customer__r.Name,Phoenix_Customer_Response__r.Phoenix_Customer__c,Phoenix_Customer_Response__r.Phoenix_Affected_Contract_s__c from Phoenix_Customer_Response_Line__c where id=:custresId];
            string awardPos = cr.Phoenix_Award_Position__c;
            if(awardPos.contains(','))
                awardPos = awardPos.split(',')[0];
            string ContractNumbers= '';
            ContractNumbers = cr.Phoenix_Customer_Response__r.Phoenix_Affected_Contract_s__c != null ? 
                cr.Phoenix_Customer_Response__r.Phoenix_Affected_Contract_s__c : '';
            Decimal qtyforRec = cr.Phoenix_Awarded_Quantity__c != null ? cr.Phoenix_Awarded_Quantity__c : null;
            /*Decimal qtyforRec;
            if(res != null && res.size() == 1){
                qtyforRec=cr.Phoenix_Awarded_Quantity__c;
            }
            else{
                qtyforRec=null;
            }*/
            if(ContractNumbers != ''){
                List<String> res;
                if(ContractNumbers != null){
                    res = ContractNumbers.split(',');
                }
                if(res != null && res.size() == 1){
                    qtyforRec=cr.Phoenix_Awarded_Quantity__c;
                }
                else{
                    qtyforRec=null;
                }
                List<Phoenix_Contract__c> contractList = [SELECT Id, Name, Phoenix_Contract_Internal_Description__c,Phoenix_Contract_Number__c 
                                                          FROM Phoenix_Contract__c
                                                         WHERE Phoenix_Contract_Number__c IN: res];
                Map<String,Id> ContractNumwithIdMap = new Map<String,Id>();
                Map<String,String> ContractDeswithNumMap = new Map<String,String>();
                for(Phoenix_Contract__c contractObj : contractList){
                    ContractNumwithIdMap.put(contractObj.Phoenix_Contract_Number__c,contractObj.Id);
                    ContractDeswithNumMap.put(contractObj.Phoenix_Contract_Number__c,contractObj.Phoenix_Contract_Internal_Description__c);
                }
                
                for(String rec:res){
                    string rec1=rec;
                    Phoenix_Awarded_Quantity__c awaQtyRec = new Phoenix_Awarded_Quantity__c();
                    awaQtyRec.Phoenix_Awarded_Quantity__c=qtyforRec;
                    awaQtyRec.Phoenix_Awarded_Position__c=awardPos;//cr.Phoenix_Award_Position__c,
                    if(ContractNumwithIdMap.containsKey(rec1)){
                        awaQtyRec.Contract_Internal_Description__c=ContractDeswithNumMap.get(rec1);
                        awaQtyRec.Phoenix_Contract__c=ContractNumwithIdMap.get(rec1);
                    }
                    awaQtyRec.Phoenix_Contract_Number__c=rec1;
                    awaQtyRec.GCP_Product_Family__c = cr.Product_Family__c;
                    awaQtyRec.Phoenix_Product__c=cr.Phoenix_Bid_Line_Item__r.Phoenix_Product__c;
                    awaQtyRec.Phoenix_Bid__c=cr.Phoenix_Bid__c;
                    awaQtyRec.Customer_Response_Line__c=cr.id;
                    awaQtyRec.Phoenix_Bid_Line_Item__c=cr.Phoenix_Bid_Line_Item__c;
                    awaQtyRec.Phoenix_Customer_Response__c=cr.Phoenix_Customer_Response__c;
                    awaQtyRec.Phoenix_Effective_Date__c=cr.Phoenix_Price_Effective_Date__c;
                    awaQtyRec.Phoenix_Supply_Effective_Date__c=cr.Phoenix_Supply_Effective_Date__c;//This line added by Rama
                    awaQtyRec.Phoenix_Customer__c=cr.Phoenix_Customer_Response__r.Phoenix_Customer__c;
                    awaQtyRec.Customer_Name__c=cr.Phoenix_Customer_Response__r.Phoenix_Customer__r.Name;
                      awaQtyRec.Phoenix_Material_Code__c=cr.Phoenix_Bid_Line_Item__r.Phoenix_Product__r.ProductCode;
                 
                    AwardedQtyListRec.add(awaQtyRec);
                }
            }
            else{
                Phoenix_Awarded_Quantity__c awaQtyRec = new Phoenix_Awarded_Quantity__c(
                    Phoenix_Awarded_Quantity__c=qtyforRec,
                    Phoenix_Awarded_Position__c=awardPos,//cr.Phoenix_Award_Position__c,
                    //Contract_Internal_Description__c=ContractDeswithNumMap.get(rec1),
                    //Phoenix_Contract__c=ContractNumwithIdMap.get(rec1),
                    //Phoenix_Contract_Number__c=rec1,
                    Phoenix_Product__c=cr.Phoenix_Bid_Line_Item__r.Phoenix_Product__c,
                    Phoenix_Bid__c=cr.Phoenix_Bid__c,
                    Customer_Response_Line__c=cr.id,
                    Phoenix_Bid_Line_Item__c=cr.Phoenix_Bid_Line_Item__c,
                    GCP_Product_Family__c = cr.Product_Family__c,
                    Phoenix_Customer_Response__c=cr.Phoenix_Customer_Response__c,
                    Phoenix_Effective_Date__c=cr.Phoenix_Price_Effective_Date__c,
                    Phoenix_Supply_Effective_Date__c=cr.Phoenix_Supply_Effective_Date__c,//This line added by Rama
                    Phoenix_Customer__c=cr.Phoenix_Customer_Response__r.Phoenix_Customer__c,
                    Customer_Name__c=cr.Phoenix_Customer_Response__r.Phoenix_Customer__r.Name,
                    Phoenix_Material_Code__c=cr.Phoenix_Bid_Line_Item__r.Phoenix_Product__r.ProductCode
                );
                AwardedQtyListRec.add(awaQtyRec);
            }
        }
        return AwardedQtyListRec;
    }
    @AuraEnabled
    public static void updateAccount(List<Phoenix_Awarded_Quantity__c> AwardedQtyRec){
        system.debug('AwardedQtyRec'+AwardedQtyRec);
        if(AwardedQtyRec != null){
            Upsert AwardedQtyRec;
        }
        
    }
    @AuraEnabled
    public static  AwardedQuantityWrapper getTotalQtyData(string custresId) {
        AwardedQuantityWrapper AQwrap=new AwardedQuantityWrapper();
        Phoenix_Customer_Response_Line__c cr=[Select Phoenix_Awarded_Quantity__c,Product_Family__c, Product_Family__r.Name,Phoenix_Bid_Line_Item__r.Phoenix_Product__c,Phoenix_Product_Name__c from Phoenix_Customer_Response_Line__c where id=:custresId];
        decimal total = cr.Phoenix_Awarded_Quantity__c; 
        string prodName=cr.Phoenix_Product_Name__c;
        string ProdId=cr.Phoenix_Bid_Line_Item__r.Phoenix_Product__c;
        if(total == null )
        {
            total=0;
        }
        AQwrap.awardQty=total;
        AQwrap.prodName=prodName;
        AQwrap.ProdId=ProdId;
        return AQwrap;
    }
    @AuraEnabled
    public static  List<String> getPicklistValues(string custresId) {
        Phoenix_Customer_Response_Line__c cr=[Select Phoenix_Award_Position__c from Phoenix_Customer_Response_Line__c where id=:custresId];
        String total = cr.Phoenix_Award_Position__c; 
        system.debug('total'+total);
        List<String> res;
        if(total != null){
            res= total.split(',');
        } 
        
        return res;
    }
    
    public class AwardedQuantityWrapper{
        @AuraEnabled public String ConNo {get;set;}
        @AuraEnabled public String prodName {get;set;}
        @AuraEnabled public String BidLineItemNo {get;set;}
        @AuraEnabled public Phoenix_Customer_Response_Line__c CustomerResList {get;set;}
        @AuraEnabled public String awardPosition {get;set;}
        @AuraEnabled public Decimal awardQty {get;set;}
        @AuraEnabled public String CustomerName {get;set;}
        @AuraEnabled public String CustomerId {get;set;}
        @AuraEnabled public String ProdId {get;set;}
        
        
    }
}