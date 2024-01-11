trigger Phoenix_ProductPlaybookFieldHistory on Phoenix_Product_Playbook__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    Map<Id,Product2> productMap = new Map<Id,Product2>((List<Product2>)Database.query('SELECT Id,Name FROM Product2'));
    Map<String, Schema.SObjectField> allProductPlaybookFields = Schema.SObjectType.Phoenix_Product_Playbook__c.fields.getMap();
    Map<String, Schema.DescribeFieldResult> productPalybookFieldsToTrack = new Map<String, Schema.DescribeFieldResult>();
    List<Phoenix_Product_Playbook_History__c> productPbList = new List<Phoenix_Product_Playbook_History__c>();
    for(Schema.SObjectField proField : allProductPlaybookFields.values()){
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
                productPalybookFieldsToTrack.put(describeResult.getName(), describeResult);
            }
        }
        
    }
    if(trigger.isAfter && trigger.isUpdate && !Phoenix_Util.hasAlreadyDone()){
        
        
        for(Phoenix_Product_Playbook__c pb : trigger.new){
            Phoenix_Product_Playbook__c oldPb = Trigger.oldMap.get(pb.Id);
            for (Schema.DescribeFieldResult fieldDescribe : productPalybookFieldsToTrack.values()) {
                boolean isTrue = oldPb.get(fieldDescribe.getName()) != pb.get(fieldDescribe.getName()) ? true :false ;
                boolean isDependent = (String.valueOf(pb.get(fieldDescribe.getName())) == null && String.valueOf(oldPb.get(fieldDescribe.getName())) == 'N/A') ? false : true ;
                if (isDependent && isTrue && String.valueOf(pb.get(fieldDescribe.getName())) != 'N/A') {
                    Phoenix_Product_Playbook_History__c pbHistory = createUpdateHistory(fieldDescribe, oldPb, pb);
                    if(fieldDescribe.getType() != Schema.DisplayType.REFERENCE)
                    {
                        pbHistory.Phoenix_Previous_Value__c =  String.valueOf(oldPb.get(fieldDescribe.getName()));
                        pbHistory.Phoenix_New_Value__c =   String.valueOf(pb.get(fieldDescribe.getName()));
                    }
                     else{
                        Id oldRecordId = String.valueOf(oldPb.get(fieldDescribe.getName()));
                        Id newRecordId = String.valueOf(pb.get(fieldDescribe.getName()));
                        system.debug('------oldRecordId------'+oldRecordId);
                        system.debug('------newRecordId------'+newRecordId);
                            Schema.SObjectType oldObjType= oldRecordId.getSobjectType();
                            pbHistory.Phoenix_Previous_Value__c =  getNameValue(oldRecordId);
                            pbHistory.Phoenix_New_Value__c =   getNameValue(newRecordId);
                      
                    }
                    productPbList.add(pbHistory);
                    system.debug('fieldDescribe.getType()---->'+fieldDescribe.getType());
                }
            }
        }
        Phoenix_Util.setAlreadyDone();
        if (!productPbList.isEmpty())
        {
            //remove duplicate history entries
            List<Phoenix_Product_Playbook_History__c> historiesToInsertWithoutDuplicates = new List<Phoenix_Product_Playbook_History__c>();
            Set<Phoenix_Product_Playbook_History__c> historiesSet = new Set<Phoenix_Product_Playbook_History__c>();
            historiesSet.addAll(productPbList);
            historiesToInsertWithoutDuplicates.addAll(historiesSet);
            system.debug('historiesToInsertWithoutDuplicates-->'+historiesToInsertWithoutDuplicates);
            //insert the rest
            insert historiesToInsertWithoutDuplicates;
        }
        
        
    }
  private String getNameValue(Id objId){
        String sObjTypeStr = String.valueOf(objId.getSobjectType());
       // if(sObjTypeStr == 'Account') return accMap.get(objId).Name;
       // else if(sObjTypeStr == 'User') return userMap.get(objId).Name;
       // else if(sObjTypeStr == 'Phoenix_Partner__c') return partnerMap.get(objId).Name;
         if(sObjTypeStr == 'Product2') return productMap.get(objId).Name;
        else return '';
        
    }  
    private Phoenix_Product_Playbook_History__c createUpdateHistory(Schema.DescribeFieldResult field, Phoenix_Product_Playbook__c oldPb, Phoenix_Product_Playbook__c pb) {
        Phoenix_Product_Playbook_History__c pbHistory = new Phoenix_Product_Playbook_History__c();
        pbHistory.Phoenix_Product_Playbook__c = pb.Id;
        pbHistory.Phoenix_Field_Name__c = field.getLabel();
        pbHistory.Phoenix_Modified_by_User__c = UserInfo.getUserId();
        pbHistory.Phoenix_Modified_Date__c = System.now();
        return pbHistory;
    }
}