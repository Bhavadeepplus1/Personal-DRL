public class Phoenix_NPRDataFieldHistoryQueue implements Queueable {
    public Map<Id, Phoenix_NPR_Data__c> newMap;
    public Map<Id, Phoenix_NPR_Data__c> oldMap;
    Map<Id,Account> accMap = new Map<Id,Account>();
    Map<Id,User> userMap = new Map<Id,User>();
    Map<Id,Phoenix_Partner__c> partnerMap = new Map<Id,Phoenix_Partner__c>();
    Map<Id,Product2> productMap = new Map<Id,Product2>();
    
    public Phoenix_NPRDataFieldHistoryQueue(Map<Id, Phoenix_NPR_Data__c> newMapTrigger, Map<Id, Phoenix_NPR_Data__c> oldMapTrigger){
        this.newMap = newMapTrigger; 
        this.oldMap = oldMapTrigger;
      
        accMap = new Map<Id,Account>((List<Account>)Database.query('SELECT Id,Name FROM Account ORDER BY LastModifiedDate DESC NULLS FIRST limit 2000'));
        userMap = new Map<Id,User>((List<User>)Database.query('SELECT Id,Name FROM User WHERE IsActive = true ORDER BY LastLoginDate DESC NULLS LAST limit 1000'));
        partnerMap = new Map<Id,Phoenix_Partner__c>((List<Phoenix_Partner__c>)Database.query('SELECT Id,Name FROM Phoenix_Partner__c ORDER BY LastModifiedDate DESC NULLS FIRST limit 2500'));
        productMap = new Map<Id,Product2>((List<Product2>)Database.query('SELECT Id,Name FROM Product2 WHERE IsActive = true ORDER BY LastModifiedDate DESC NULLS FIRST limit 10000'));
        
    }
    public void execute(QueueableContext context) {
        Map<String, Schema.SObjectField> allNPRFields = Schema.SObjectType.Phoenix_NPR_Data__c.fields.getMap();
        Map<String, Schema.DescribeFieldResult> nprFieldsToTrack = new Map<String, Schema.DescribeFieldResult>();
        List<Phoenix_NPR_Data_History__c> nprList = new List<Phoenix_NPR_Data_History__c>();
        for(Schema.SObjectField nprField : allNPRFields.values()){
            Schema.DescribeFieldResult describeResult = nprField.getDescribe();
            if (describeResult.getType() == Schema.DisplayType.Boolean ||
                describeResult.getType() == Schema.DisplayType.Combobox ||
                describeResult.getType() == Schema.DisplayType.Currency ||
                describeResult.getType() == Schema.DisplayType.Date ||
                describeResult.getType() == Schema.DisplayType.DateTime ||
                describeResult.getType() == Schema.DisplayType.Double ||
                describeResult.getType() == Schema.DisplayType.Email ||
                describeResult.getType() == Schema.DisplayType.Integer ||
                describeResult.getType() == Schema.DisplayType.MultiPicklist ||
                describeResult.getType() == Schema.DisplayType.Percent ||
                describeResult.getType() == Schema.DisplayType.Phone ||
                describeResult.getType() == Schema.DisplayType.Picklist ||
                describeResult.getType() == Schema.DisplayType.String ||
                describeResult.getType() == Schema.DisplayType.TextArea ||
                describeResult.getType() == Schema.DisplayType.Time ||
                describeResult.getType() == Schema.DisplayType.REFERENCE ||
                describeResult.getType() == Schema.DisplayType.ID ||
                describeResult.getType() ==  Schema.DisplayType.Reference ||
                describeResult.getType() == Schema.DisplayType.URL) 
            {
                if (describeResult.getName() != 'CreatedDate' &&
                    describeResult.getName() != 'LastModifiedById' &&
                    describeResult.getName() != 'CreatedById' &&
                    describeResult.getName() != 'LastModifiedDate' &&
                    describeResult.getName() != 'SystemModstamp' &&
                    describeResult.isAccessible() &&
                    !describeResult.isCalculated()
                   )
                {
                    nprFieldsToTrack.put(describeResult.getName(), describeResult);
                }
            }
        }
        //  if((trigger.isAfter && trigger.isUpdate) && !Phoenix_Util.hasAlreadyDone()){
        for(Phoenix_NPR_Data__c npr : newMap.values()){//1
            Phoenix_NPR_Data__c oldNPR = oldMap.get(npr.Id);
            for (Schema.DescribeFieldResult fieldDescribe : nprFieldsToTrack.values()) {//60
                boolean isTrue = oldNPR.get(fieldDescribe.getName()) != npr.get(fieldDescribe.getName()) ? true :false ;
                boolean isDependent = (String.valueOf(npr.get(fieldDescribe.getName())) == null && String.valueOf(oldNPR.get(fieldDescribe.getName())) == 'N/A') ? false : true ;
                if (isDependent && isTrue && String.valueOf(npr.get(fieldDescribe.getName())) != 'N/A') {
                    String fieldName = fieldDescribe.getName();
                    if(fieldName != 'Phoenix_SalesUnit_90__c' &&
                       fieldName != 'Phoenix_Net_Sales_90__c' &&
                       fieldName != 'Phoenix_12Months_Sales_Unit__c' &&
                       fieldName != 'Phoenix_12Months_Net_Sales__c'){
                           Phoenix_NPR_Data_History__c nprHistory = createUpdateHistory(fieldDescribe, oldNPR, npr);
                           if(fieldDescribe.getType() != Schema.DisplayType.REFERENCE){ // Not lookups
                               nprHistory.Phoenix_Previous_Value__c =  String.valueOf(oldNPR.get(fieldDescribe.getName()));
                               nprHistory.Phoenix_New_Value__c =   String.valueOf(npr.get(fieldDescribe.getName()));
                           } 
                           else{
                               Id oldRecordId = String.valueOf(oldNPR.get(fieldDescribe.getName()));
                               Id newRecordId = String.valueOf(npr.get(fieldDescribe.getName()));
                               
                               if(newRecordId==null){
                                   nprHistory.Phoenix_Previous_Value__c = getNameValue(oldRecordId);
                                   nprHistory.Phoenix_New_Value__c = '';  
                               }
                               else if(oldRecordId==null){
                                   nprHistory.Phoenix_New_Value__c = getNameValue(newRecordId);
                                   nprHistory.Phoenix_Previous_Value__c ='';    
                               }
                               else{
                                   // Schema.SObjectType oldObjType= oldRecordId.getSobjectType();
                                   nprHistory.Phoenix_Previous_Value__c =  getNameValue(oldRecordId);//SF acc
                                   nprHistory.Phoenix_New_Value__c =   getNameValue(newRecordId);
                               }
                           }
                           nprList.add(nprHistory);
                       }
                }
            }
            
        }
        Phoenix_Util.setAlreadyDone();
        if (!nprList.isEmpty()) {
            //remove duplicate history entries
            List<Phoenix_NPR_Data_History__c> historiesToInsertWithoutDuplicates = new List<Phoenix_NPR_Data_History__c>();
            Set<Phoenix_NPR_Data_History__c> historiesSet = new Set<Phoenix_NPR_Data_History__c>();
            historiesSet.addAll(nprList);
            historiesToInsertWithoutDuplicates.addAll(historiesSet);
            //system.debug('historiesToInsertWithoutDuplicates-->'+historiesToInsertWithoutDuplicates);
            //insert the rest
            insert historiesToInsertWithoutDuplicates;
        } 
        
        //}
        
        
        
        
        
        
        
    }
    
    
    private String getNameValue(Id objId){
        String sObjTypeStr = String.valueOf(objId.getSobjectType());
        if(sObjTypeStr == 'Account') return accMap.get(objId)?.Name;
        else if(sObjTypeStr == 'User') return userMap.get(objId)?.Name;
        else if(sObjTypeStr == 'Phoenix_Partner__c') return partnerMap.get(objId)?.Name;
        else if(sObjTypeStr == 'Product2') return productMap.get(objId)?.Name;
        else return '';
        
    }
    private Phoenix_NPR_Data_History__c createUpdateHistory(Schema.DescribeFieldResult field, Phoenix_NPR_Data__c oldNPR, Phoenix_NPR_Data__c npr) {
        Phoenix_NPR_Data_History__c nprHistory = new Phoenix_NPR_Data_History__c();
        nprHistory.Phoenix_NPR_Data__c = npr.Id;
        nprHistory.Phoenix_Field_Name__c = field.getLabel();
        nprHistory.Phoenix_Modified_by_User__c = UserInfo.getUserId();
        nprHistory.Phoenix_Modified_Date__c = System.now();
        return nprHistory;
    }
}