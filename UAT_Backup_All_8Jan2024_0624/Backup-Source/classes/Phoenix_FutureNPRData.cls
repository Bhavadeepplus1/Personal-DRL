public class Phoenix_FutureNPRData {
    @AuraEnabled
    public static FutureNPRWrapper futureNPR(String productId){
        FutureNPRWrapper nprwrap = new FutureNPRWrapper();
        String prodName;
        String prodId;  
        String nprStatus = 'Active';
        String nprDataQuery = 'Select Phoenix_Account__r.Name, Phoenix_Contract__r.Name, Phoenix_Product__r.Phoenix_NDC__c, Phoenix_Product__r.Name, Phoenix_Product__r.Phoenix_Pkg_Size__c, Phoenix_Product__r.Phoenix_Throughput_cost__c, ' + Phoenix_Util.futureNPRDataFields + ' FROM Phoenix_Future_NPR_Data__c WHERE Phoenix_NPR_Status__c =: nprStatus AND Phoenix_Product__c =: ProductId';
        List<Phoenix_Future_NPR_Data__c> nprDataList = Database.query(nprDataQuery); 
        for(Phoenix_Future_NPR_Data__c npr : nprDataList){
            prodName = npr.Phoenix_Product__r.Name;           
            prodId = npr.Phoenix_Product__r.Id;                 
        }               
        nprwrap.nprDataList = nprDataList;
       // nprwrap.nprDataList = null;
        nprwrap.prodName = prodName;    
        nprwrap.prodId = prodId;
        system.debug('Data----'+prodId);
        system.debug('Data----'+nprDataList.size());
        return nprwrap;
    }
    public class FutureNPRWrapper{
        @AuraEnabled public List<Phoenix_Future_NPR_Data__c> nprDataList;      
        @AuraEnabled public String prodName;
        @AuraEnabled public String prodId;
        FutureNPRWrapper(){
            nprDataList = new List<Phoenix_Future_NPR_Data__c>();
            
        }
    }
}