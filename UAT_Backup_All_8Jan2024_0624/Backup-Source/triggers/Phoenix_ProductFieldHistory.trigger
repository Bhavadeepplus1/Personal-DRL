trigger Phoenix_ProductFieldHistory on Product2 (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    
    Map<Id,Account> accMap = new Map<Id,Account>();
    Map<Id,User> userMap = new Map<Id,User>();
    Map<Id,Phoenix_Partner__c> partnerMap = new Map<Id,Phoenix_Partner__c>();
    
    if(trigger.isAfter && trigger.isUpdate && !Phoenix_Util.hasAlreadyDone()){
        accMap = new Map<Id,Account>((List<Account>)Database.query('SELECT Id,Name FROM Account'));
        userMap = new Map<Id,User>((List<User>)Database.query('SELECT Id,Name FROM User'));
        partnerMap = new Map<Id,Phoenix_Partner__c>((List<Phoenix_Partner__c>)Database.query('SELECT Id,Name FROM Phoenix_Partner__c'));
        
        Map<String, Schema.SObjectField> allProductFields = Schema.SObjectType.Product2.fields.getMap();
        Map<String, Schema.DescribeFieldResult> productsFieldsToTrack = new Map<String, Schema.DescribeFieldResult>();
        List<Phoenix_Product_History__c> productList = new List<Phoenix_Product_History__c>();
        for(Schema.SObjectField proField : allProductFields.values()){
            Schema.DescribeFieldResult describeResult = proField.getDescribe();
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
                    productsFieldsToTrack.put(describeResult.getName(), describeResult);
                }
            }
        }
        
        
        for(Product2 pro : trigger.new){
            Product2 oldPro = Trigger.oldMap.get(pro.Id);
            for (Schema.DescribeFieldResult fieldDescribe : productsFieldsToTrack.values()) {
                boolean isTrue = oldPro.get(fieldDescribe.getName()) != pro.get(fieldDescribe.getName()) ? true :false ;
                boolean isDependent = (String.valueOf(pro.get(fieldDescribe.getName())) == null && String.valueOf(oldPro.get(fieldDescribe.getName())) == 'N/A') ? false : true ;
                if (isDependent && isTrue && String.valueOf(pro.get(fieldDescribe.getName())) != 'N/A') {
                    Phoenix_Product_History__c proHistory = createUpdateHistory(fieldDescribe, oldPro, pro);
                    if(fieldDescribe.getType() != Schema.DisplayType.REFERENCE && proHistory.Phoenix_Field_Name__c !='Product Playbook'){
                        
                        if(proHistory.Phoenix_Field_Name__c =='Throughput Cost' || proHistory.Phoenix_Field_Name__c =='IPA Floor Price' || proHistory.Phoenix_Field_Name__c =='WAC'){
                       proHistory.Phoenix_Previous_Value__c =  String.valueOf(oldPro.get(fieldDescribe.getName()));
                        proHistory.Phoenix_New_Value__c =   String.valueOf(pro.get(fieldDescribe.getName()));
                        proHistory.Phoenix_Cost__c=decimal.valueOf(proHistory.Phoenix_New_Value__c);     
                        }
                        else{
                         proHistory.Phoenix_Previous_Value__c =  String.valueOf(oldPro.get(fieldDescribe.getName()));
                        proHistory.Phoenix_New_Value__c =   String.valueOf(pro.get(fieldDescribe.getName()));   
                        }
                        
                        productList.add(proHistory);
                    }
                    else if(fieldDescribe.getType() == Schema.DisplayType.REFERENCE && proHistory.Phoenix_Field_Name__c !='Product Playbook'){
                        Id oldRecordId = String.valueOf(oldPro.get(fieldDescribe.getName()));
                        Id newRecordId = String.valueOf(pro.get(fieldDescribe.getName()));
                        // system.debug('------oldRecordId------'+oldRecordId);
                        // system.debug('------newRecordId------'+newRecordId);
                        if(newRecordId==null){
                            proHistory.Phoenix_Previous_Value__c = getNameValue(oldRecordId);
                            proHistory.Phoenix_New_Value__c = '';  
                        }
                        else if(oldRecordId==null){
                            proHistory.Phoenix_New_Value__c = getNameValue(newRecordId);
                            proHistory.Phoenix_Previous_Value__c ='';    
                        }
                        else{
                            Schema.SObjectType oldObjType= oldRecordId.getSobjectType();
                        if(proHistory.Phoenix_Field_Name__c =='Throughput Cost' || proHistory.Phoenix_Field_Name__c =='IPA Floor Price' || proHistory.Phoenix_Field_Name__c =='WAC'){
                             proHistory.Phoenix_Previous_Value__c =  getNameValue(oldRecordId);
                            proHistory.Phoenix_New_Value__c =   getNameValue(newRecordId);     
                            proHistory.Phoenix_Cost__c=decimal.valueOf(proHistory.Phoenix_New_Value__c);      
                              }
                            else{
                            proHistory.Phoenix_Previous_Value__c =  getNameValue(oldRecordId);
                            proHistory.Phoenix_New_Value__c =   getNameValue(newRecordId);    
                            }
                            
                        }
                        productList.add(proHistory);
                    }
                    
                }
            }
        }
        Phoenix_Util.setAlreadyDone();
        if (!productList.isEmpty()) {
            //remove duplicate history entries
            List<Phoenix_Product_History__c> historiesToInsertWithoutDuplicates = new List<Phoenix_Product_History__c>();
            Set<Phoenix_Product_History__c> historiesSet = new Set<Phoenix_Product_History__c>();
            historiesSet.addAll(productList);
            historiesToInsertWithoutDuplicates.addAll(historiesSet);
            system.debug('historiesToInsertWithoutDuplicates-->'+historiesToInsertWithoutDuplicates);
            //insert the rest
            insert historiesToInsertWithoutDuplicates;
        }
    }
    
    private String getNameValue(Id objId){
        String sObjTypeStr = String.valueOf(objId.getSobjectType());
        if(sObjTypeStr == 'Account') return accMap.get(objId).Name;
        else if(sObjTypeStr == 'User') return userMap.get(objId).Name;
        else if(sObjTypeStr == 'Phoenix_Partner__c') return partnerMap.get(objId).Name;
        else return '';
        
    }
    
    private Phoenix_Product_History__c createUpdateHistory(Schema.DescribeFieldResult field, Product2 oldPro, Product2 pro) {
        Phoenix_Product_History__c proHistory = new Phoenix_Product_History__c();
        proHistory.Phoenix_Product__c = pro.Id;
        proHistory.Phoenix_Field_Name__c = field.getLabel();
        proHistory.Phoenix_Modified_by_User__c = UserInfo.getUserId();
        proHistory.Phoenix_Modified_Date__c = System.now();
        return proHistory;
    }
}