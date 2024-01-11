public class FieldUpdateinRecordsBatchCls implements Database.Batchable <sObject> , Database.Stateful{
    public Integer totalRows = 0;
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('select Contract__r.Id, Contract__r.Phoenix_Customer__c, Account_Number__c, Account__C, Sold_to_Number__c from IDN_Charge_Back__c where Account__C=null and  Sold_to_Number__c !=null');
       // return Database.getQueryLocator('SELECT Id,Vision_Product_Family__c,Vision_Customer_Number__c,GCP_Unique_Identifier__c,Vision_Segment__c,Vision_Customer_Name__c,Vision_Month_dtls__c,Vision_NPR_Customer_Code__c,GCP_Product_Family__c FROM Vision_DRL_Sales__c');
       //  return Database.getQueryLocator('select Vision_Product_Family__c,GCP_Product_Family__c,Vision_GCP_Unique_Identifier__c,Vision_agreement_no__c,Vision_Category__c,Vision_month__c,Vision_year__c,Vision_Contract__c,Vision_customer_code__c,Vision_Customer__c,Vision_Product__c,Vision_SKU_Code__c,Vision_DIVISION_DESC__c,Vision_Processed_Month__c,Vision_Cutomer_Hierarchy_Code__c from Vision_DRL_Sales_External_Summary__c');
       // return Database.getQueryLocator('Select id,Vision_Account__c,Vision_Product__c,	GCP_Unique_Identifier__c,Vision_GCP_Unique_Identifier__c,Vision_SKU_Code__c,Vision_Customer_Code__c from Vision_GCP_SFDC_Order_Status__c');
        //return Database.getQueryLocator('Select Id,Vision_Is_Cus_Prd_Tracker_Created__c FROM Phoenix_Contract__c Where Vision_Is_Cus_Prd_Tracker_Created__c = true');
        
    }
    public void execute(Database.BatchableContext BC, List <IDN_Charge_Back__c> recordsList) {
        try{
        if(recordsList.size() > 0){
            //  map<id,string> existingRxSRxMap = new map<id,string>();
            // map<id,string> existingOTCMap = new map<id,string>();
            //system.debug('--Records Processing--'+recordsList.size());
           // map<String,Id> accMap =new map<String,Id>();
       
       // map<String,Product2> skuCodePrdMap =new Map<String,Product2>();
       /// for( Product2 prod : [select Id,name,ProductCode From Product2 where ProductCode != null]){
        //    skuCodePrdMap.put(prod.ProductCode,prod);
       // }
        //Back Order Rx map for linking
        /* map<String,Id> existingBackOrderRXMap =new Map<String,Id>();
for( Vision_GCP_Backorder_OTC__c  backOrderRx : [select id,Vision_Sku_Code__c,Vision_Backorder_Report_Date__c From Vision_GCP_Backorder_OTC__c where Vision_Sku_Code__c != null order by Vision_Backorder_Report_Date__c desc]){
if(!existingBackOrderRXMap.containskey(backOrderRx.Vision_Sku_Code__c ))
existingBackOrderRXMap.put(backOrderRx.Vision_Sku_Code__c ,backOrderRx.Id);

}
Map<String,GCP_DOH_Trade_Partner_NDC__c> finalGCPrecordsMap = new Map<String,GCP_DOH_Trade_Partner_NDC__c>();
//Back Order SRx map for linking
map<String,Id> existingBackOrderSRXMap =new Map<String,Id>();
for( Vision_GCP_Backorder_SRx_Rx__c backOrderSRx : [select id,Vision_Sku_Code__c From Vision_GCP_Backorder_SRx_Rx__c where Vision_Sku_Code__c != null order by Vision_Backorder_Report_Date__c  desc]){
if(!existingBackOrderSRXMap.containskey(backOrderSRx.Vision_Sku_Code__c))
existingBackOrderSRXMap.put(backOrderSRx.Vision_Sku_Code__c ,backOrderSRx.Id);
}*/
       
        /*	map<String,Product2> ndc11prodMap =new Map<String,Product2>();
map<String,Product2> ndc10prodMap =new Map<String,Product2>();
for( Product2 prod : [select Id,name,ProductCode,Phoenix_NDC__c , Phoenix_NDC_11__c,Phoenix_Rx_SRx_OTC__c From Product2 where Phoenix_NDC_11__c  != null ]){
ndc11prodMap.put(prod.Phoenix_NDC_11__c,prod);
ndc10prodMap.put(prod.Phoenix_NDC__c,prod);
}
Map<String,list<GCP_DOH_Trade_Partner_NDC__c>> allNDCRecs = new Map<String,list<GCP_DOH_Trade_Partner_NDC__c>>();*/
        for(IDN_Charge_Back__c rec : recordsList){
              
             // rec.Vision_GCP_Unique_Identifier__c=rec.Vision_SKU_Code__c.trim()+'_'+rec.Vision_customer_code__c.trim()+'_'+rec.Vision_Category__c.trim()+'_'+rec.Vision_Processed_Month__c.trim()+'_'+rec.Vision_Cutomer_Hierarchy_Code__c.trim()+'_'+rec.Vision_DIVISION_DESC__c.trim()+'_'+rec.Vision_agreement_no__c.trim();
             
            
            /* if(rec.vision_gcp_ndc__c != null){
//System.debug('--- Before NDC ---'+gcpSFRec.vision_gcp_ndc__c);

String ndcCode = rec.vision_gcp_ndc__c;
System.debug('--- Before NDC ---'+rec.vision_gcp_ndc__c);
// gcpSFRec.GCP_Backorder_RX__c field refering to otc object  and gcpSFRec.GCP_Backorder_SRX__c refering to srxrx object
if(ndc11prodMap.containsKey(ndcCode)){
rec.Product__c  = ndc11prodMap.get(ndcCode).Id;
rec.GCP_Backorder_RX__c = existingBackOrderRXMap.containsKey(ndc11prodMap.get(ndcCode).ProductCode) ? existingBackOrderRXMap.get(ndc11prodMap.get(ndcCode).ProductCode) : rec.GCP_Backorder_RX__c;
rec.GCP_Backorder_SRX__c = existingBackOrderSRXMap.containsKey(ndc11prodMap.get(ndcCode).ProductCode) ? existingBackOrderSRXMap.get(ndc11prodMap.get(ndcCode).ProductCode) : rec.GCP_Backorder_SRX__c;
rec.Vision_Segment__c = ndc11prodMap.get(ndcCode).Phoenix_Rx_SRx_OTC__c;
existingRxSRxmap.put( rec.GCP_Backorder_SRX__c,rec.Vision_GCP_Unique_Identifier__c);
existingOTCmap.put( rec.GCP_Backorder_RX__C,rec.Vision_GCP_Unique_Identifier__c);
}
else if(ndc10prodMap.containsKey(ndcCode)){
rec.Product__c  = ndc10prodMap.get(ndcCode).Id;
rec.GCP_Backorder_RX__c = existingBackOrderRXMap.containsKey(ndc10prodMap.get(ndcCode).ProductCode) ? existingBackOrderRXMap.get(ndc10prodMap.get(ndcCode).ProductCode) : rec.GCP_Backorder_RX__c;
rec.GCP_Backorder_SRX__c = existingBackOrderSRXMap.containsKey(ndc10prodMap.get(ndcCode).ProductCode) ? existingBackOrderSRXMap.get(ndc10prodMap.get(ndcCode).ProductCode) : rec.GCP_Backorder_SRX__c;

rec.Vision_Segment__c = ndc10prodMap.get(ndcCode).Phoenix_Rx_SRx_OTC__c;
existingRxSRxmap.put( rec.GCP_Backorder_SRX__c, rec.Vision_GCP_Unique_Identifier__c);
existingOTCmap.put( rec.GCP_Backorder_RX__C,rec.Vision_GCP_Unique_Identifier__c);
}
else{
rec.Product__c = rec.Product__c;
}

if(allNDCRecs.containskey(ndccode)){
allNDCRecs.get(ndccode).add(rec);
}
else{
allNDCRecs.put(ndccode,new list<GCP_DOH_Trade_Partner_NDC__c>{rec});
}
}*/
            //rec.Vision_Product_Family__c  = existingProductFamilyMap.containsKey(rec.GCP_Product_Family__c) ? existingProductFamilyMap.get(rec.GCP_Product_Family__c) : null;
            // rec.Vision_Update_Date__c = Phoenix_Util.getTodayEST();
            //  Rec.Vision_Customer_Name__c = accMap.containsKey(Rec.Vision_NPR_Customer_Code__c) ? accMap.get(Rec.Vision_NPR_Customer_Code__c) : Rec.Vision_Customer_Name__c;
            // Rec.GCP_Unique_Identifier__c  = Rec.GCP_Product_Family__c +'_'+ Rec.Vision_Customer_Number__c+'_'+ Rec.Vision_NPR_Customer_Code__c+'_'+Rec.Vision_Month_dtls__c;
             
//if(Rec.Vision_SKU_Code__c != null){
//Rec.Vision_Product__c = skuCodePrdMap.containsKey(Rec.Vision_SKU_Code__c) ? skuCodePrdMap.get(Rec.Vision_SKU_Code__c).Id : Rec.Vision_Product__c;
//}
         
//if(rec.Vision_agreement_no__c != null){
//rec.Vision_Contract__c = existingCntrMap.containsKey(rec.Vision_agreement_no__c) ? existingCntrMap.get(rec.Vision_agreement_no__c).Id : rec.Vision_Contract__c;
          
// if(rec.Vision_agreement_no__c != null){
//   rec.Vision_Contract__c = existingCntrMap.containsKey(rec.Vision_agreement_no__c) ? existingCntrMap.get(rec.Vision_agreement_no__c).Id : rec.Vision_Contract__c;
//}
//if(rec.GCP_Product_Family__c !=null){
// rec.Vision_Product_Family__c = existingProductFamilyMap.containsKey(rec.GCP_Product_Family__c) ? existingProductFamilyMap.get(rec.GCP_Product_Family__c) : rec.Vision_Product_Family__c;
//}
/* if(rec.Vision_customer_code__c != null){
String cusCode = rec.Vision_Customer_Code__c.replaceFirst('^0+', '');
rec.Vision_Customer__c = accMap.containsKey(cusCode) ? accMap.get(cusCode): rec.Vision_Customer__c;
}*/
//if(rec.Vision_SKU_Code__c != null){
//rec.Vision_Product__c = skuCodePrdMap.containsKey(rec.Vision_SKU_Code__c) ? skuCodePrdMap.get(rec.Vision_SKU_Code__c).Id : rec.Vision_Product__c;
//}
            /*
if(rec.Vision_agreement_no__c != null){
rec.Vision_Contract__c = existingCntrMap.containsKey(rec.Vision_agreement_no__c) ? existingCntrMap.get(rec.Vision_agreement_no__c).Id : rec.Vision_Contract__c;
}
/*if(rec.GCP_Product_Family__c !=null){
rec.Vision_Product_Family__c = existingProductFamilyMap.containsKey(rec.GCP_Product_Family__c) ? existingProductFamilyMap.get(rec.GCP_Product_Family__c) : rec.Vision_Product_Family__c;
}*/
            /*if(String.isNotBlank(Rec.NDC__c)){
System.debug('--- Before NDC ---'+Rec.NDC__c);
String ndcCode = Rec.NDC__c.replaceFirst('^0+', '');
System.debug('--- Before NDC ---'+ndcCode);
if(ndc11prodMap.containsKey(ndcCode)){
Rec.Vision_Product__c  = ndc11prodMap.get(ndcCode).Id;
}
else if(ndc10prodMap.containsKey(ndcCode)){
Rec.Vision_Product__c  = ndc10prodMap.get(ndcCode).Id;
}
else{
Rec.Vision_Product__c  = Rec.Vision_Product__c;
}*/
            // finalGCPrecordsMap.put(rec.Vision_GCP_Unique_Identifier__c,rec);
            /*if(rec.Vision_SKU_Code__c != null){

rec.Vision_Product__c = skuCodePrdMap.containsKey(rec.Vision_SKU_Code__c) ? skuCodePrdMap.get(rec.Vision_SKU_Code__c).Id : rec.Vision_Product__c;
}*/
           /* gcpSFRec.Vision_Product_Family__c  = existingProductFamilyMap.containsKey(gcpSFRec.GCP_Product_Family__c) ? existingProductFamilyMap.get(gcpSFRec.GCP_Product_Family__c) : null;
            gcpSFRec.GCP_Unique_Identifier__c  = gcpSFRec.GCP_Product_Family__c +'_'+ gcpSFRec.Vision_Customer_Number__c+'_'+gcpSFRec.Vision_Segment__c+'_'+ gcpSFRec.Vision_NPR_Customer_Code__c+'_'+gcpSFRec.Vision_Month_dtls__c;
            //gcp_unique_ids.add(gcpSFRec.GCP_Unique_Identifier__c);
            //gcpSFRec.Id = existingGCPMap.containsKey(gcpSFRec.GCP_Unique_Identifier__c) ? existingGCPMap.get(gcpSFRec.GCP_Unique_Identifier__c) : null;
           
             gcpSFRec.Vision_Customer_Name__c = accMap.containsKey(gcpSFRec.Vision_Customer_Number__c) ? accMap.get(gcpSFRec.Vision_Customer_Number__c) : gcpSFRec.Vision_Customer_Name__c;
            gcpSFRec.Vision_Update_Date__c = Phoenix_Util.getTodayEST();
            // gcpSFRec.Vision_Customer_Name__c=null;
        } */
        
        totalRows = totalRows + recordsList.size();
        update recordsList;
        /* for( Vision_GCP_SFDC_Order_Status__c orderStatusRec : [select id,Vision_Product__r.Phoenix_NDC_11__c ,Vision_Product__r.Phoenix_NDC__c From Vision_GCP_SFDC_Order_Status__c where Vision_Order_Status__c = 'NOT DELIVERED' and (Vision_Product__r.Phoenix_NDC__c   in : allNDCRecs.keySet() or Vision_Product__r.Phoenix_NDC_11__c in: allNDCRecs.keySet())])
{
system.debug('-------- orderStatusRec NDC-----------'+orderStatusRec.Vision_Product__r.Phoenix_NDC__c);
if(allNDCRecs.containsKey(orderStatusRec.Vision_Product__r.Phoenix_NDC__c))
{
for(GCP_DOH_Trade_Partner_NDC__c existingdohndcrec:allNDCRecs.get(orderStatusRec.Vision_Product__r.Phoenix_NDC__c)){
if(finalGCPrecordsMap.containsKey(existingdohndcrec.Vision_GCP_Unique_Identifier__c)){
system.debug('-------- finalGCPrecordsMap unq ID-----------'+finalGCPrecordsMap.get(existingdohndcrec.Vision_GCP_Unique_Identifier__c));
finalGCPrecordsMap.get(existingdohndcrec.Vision_GCP_Unique_Identifier__c).Vision_SFDC_Order_Status__c = orderStatusRec.id;
finalGCPrecordsMap.get(existingdohndcrec.Vision_GCP_Unique_Identifier__c).Vision_Is_In_Open_Order__c = true;
}
}
}

else if(allNDCRecs.containsKey(orderStatusRec.Vision_Product__r.Phoenix_NDC_11__c)){
for(GCP_DOH_Trade_Partner_NDC__c existingdohndcrec:allNDCRecs.get(orderStatusRec.Vision_Product__r.Phoenix_NDC_11__c)){
if(finalGCPrecordsMap.containsKey(existingdohndcrec.Vision_GCP_Unique_Identifier__c)){
system.debug('-------- finalGCPrecordsMap unq ID-----------'+finalGCPrecordsMap.get(existingdohndcrec.Vision_GCP_Unique_Identifier__c));
finalGCPrecordsMap.get(existingdohndcrec.Vision_GCP_Unique_Identifier__c).Vision_SFDC_Order_Status__c = orderStatusRec.id;
finalGCPrecordsMap.get(existingdohndcrec.Vision_GCP_Unique_Identifier__c).Vision_Is_In_Open_Order__c = true;
}
}
}
}
for(Vision_GCP_Backorder_OTC__c otcrecord:[select id,Vision_Backorder_Qty__c from Vision_GCP_Backorder_OTC__c where id in:existingOTCmap.keyset()])
{
if(otcrecord.Vision_Backorder_Qty__c>0){
finalGCPrecordsMap.get(existingOTCmap.get(otcrecord.id)).Vision_Is_In_Backorder__c =true;
}
}
for(Vision_GCP_Backorder_SRx_Rx__c srxrxrecord:[select id,Vision_MoH__c,Vision_On_Backorder__c from Vision_GCP_Backorder_SRx_Rx__c where id in:existingRxSRxmap.keyset()]){

if(finalGCPrecordsMap.get(existingRxSRxmap.get(srxrxrecord.id)).Vision_Segment__c=='Rx' && srxrxrecord.Vision_MoH__c<0){
finalGCPrecordsMap.get(existingRxSRxmap.get(srxrxrecord.id)).Vision_Is_In_Backorder__c =true;
}
if(finalGCPrecordsMap.get(existingRxSRxmap.get(srxrxrecord.id)).Vision_Segment__c=='SRx' && srxrxrecord.Vision_On_Backorder__c.toLowercase()=='yes'){
finalGCPrecordsMap.get(existingRxSRxmap.get(srxrxrecord.id)).Vision_Is_In_Backorder__c =true;
}
}
update finalGCPrecordsMap.values();
}*/
        }
        }
        }
        catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'FieldUpdateinRecordsBatchCls', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        
        
    }
    public void finish(Database.BatchableContext BC) {
        system.debug('--Total Records are--'+totalRows);
    }
}