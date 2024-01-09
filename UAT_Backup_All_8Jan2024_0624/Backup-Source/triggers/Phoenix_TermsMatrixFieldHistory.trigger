trigger Phoenix_TermsMatrixFieldHistory on Phoenix_Terms_Matrix__c (after update) {
    Map<String, Schema.SObjectField> allTermMatrixFields = Schema.SObjectType.Phoenix_Terms_Matrix__c.fields.getMap();
    Map<String, Schema.DescribeFieldResult> termsFieldsToTrack = new Map<String, Schema.DescribeFieldResult>();
    List<Phoenix_Terms_Matrix_History__c> listTermsMatrix = new List<Phoenix_Terms_Matrix_History__c>();
    
    for(Schema.SObjectField termsField : allTermMatrixFields.values()){
        Schema.DescribeFieldResult describeResult = termsField.getDescribe();
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
            describeResult.getType() == Schema.DisplayType.ID ||            describeResult.getType() == Schema.DisplayType.URL) 
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
                termsFieldsToTrack.put(describeResult.getName(), describeResult);
            }
        }
        
    }
    
    
    if(trigger.isAfter && trigger.isUpdate && !Phoenix_Util.hasAlreadyDone()){
        for(Phoenix_Terms_Matrix__c termMatrix : trigger.new){
            Phoenix_Terms_Matrix__c oldTerm = Trigger.oldMap.get(termMatrix.Id);
            for (Schema.DescribeFieldResult fieldDescribe : termsFieldsToTrack.values()) {
                boolean isTrue = oldTerm.get(fieldDescribe.getName()) != termMatrix.get(fieldDescribe.getName()) ? true :false ;
                boolean isDependent = (String.valueOf(termMatrix.get(fieldDescribe.getName())) == null && String.valueOf(oldTerm.get(fieldDescribe.getName())) == 'N/A') ? false : true ;
                if (isDependent && isTrue && String.valueOf(termMatrix.get(fieldDescribe.getName())) != 'N/A') {
                    Phoenix_Terms_Matrix_History__c termsHistory = createUpdateHistory(fieldDescribe, oldTerm, termMatrix);
                    if(fieldDescribe.getType() != Schema.DisplayType.REFERENCE){
                        termsHistory.Phoenix_Original_Value__c =  String.valueOf(oldTerm.get(fieldDescribe.getName()));
                        termsHistory.Phoenix_Current_Value__c =   String.valueOf(termMatrix.get(fieldDescribe.getName()));
                    }
                    
                      else{  string oldrecordId = String.valueOf(oldTerm.get(fieldDescribe.getName()));
                        string newrecordId = String.valueOf(termMatrix.get(fieldDescribe.getName()));
                        if(oldrecordId != null && oldrecordId.startsWith('001')){    String oldName = [SELECT Id, Name FROM Account WHERE Id =:oldrecordId LIMIT 1 ].Name;    termsHistory.Phoenix_Original_Value__c =  oldName;
                            
                        }if(newrecordId !=null && newrecordId.startsWith('001')){   String NewName = [SELECT Id, Name FROM Account WHERE Id =:newrecordId LIMIT 1 ].Name;   termsHistory.Phoenix_Current_Value__c =   NewName;
                        } if(oldrecordId != null && oldrecordId.startsWith('005')){    String oldName = [SELECT Id, Name FROM USER WHERE Id =:oldrecordId LIMIT 1 ].Name;    termsHistory.Phoenix_Original_Value__c =  oldName;
                        }if(newrecordId !=null && newrecordId.startsWith('005')){    String NewName = [SELECT Id, Name FROM USER WHERE Id =:newrecordId LIMIT 1 ].Name;    termsHistory.Phoenix_Current_Value__c =   NewName;
                            
                        }
                        
                        
                    }
                    listTermsMatrix.add(termsHistory);
                    system.debug('fieldDescribe.getType()---->'+fieldDescribe.getType());
                }
            }
            
        }
        Phoenix_Util.setAlreadyDone();
        
        if (!listTermsMatrix.isEmpty()) {
            //remove duplicate history entries
            List<Phoenix_Terms_Matrix_History__c> historiesToInsertWithoutDuplicates = new List<Phoenix_Terms_Matrix_History__c>();
            Set<Phoenix_Terms_Matrix_History__c> historiesSet = new Set<Phoenix_Terms_Matrix_History__c>();
            historiesSet.addAll(listTermsMatrix);
            historiesToInsertWithoutDuplicates.addAll(historiesSet);
            system.debug('historiesToInsertWithoutDuplicates-->'+historiesToInsertWithoutDuplicates);
            //insert the rest
            insert historiesToInsertWithoutDuplicates;
        }
        
        
    }
    else if(trigger.isAfter && trigger.isUpdate){
        system.debug('Terms Name in -->');
        for(Phoenix_Terms_Matrix__c termMatrix : trigger.new){
            Phoenix_Terms_Matrix__c oldTerm = Trigger.oldMap.get(termMatrix.Id);
            for (Schema.DescribeFieldResult fieldDescribe : termsFieldsToTrack.values()) {
                boolean isTrue = oldTerm.get(fieldDescribe.getName()) != termMatrix.get(fieldDescribe.getName()) ? true :false ;
                boolean isDependent = (String.valueOf(termMatrix.get(fieldDescribe.getName())) == null && String.valueOf(oldTerm.get(fieldDescribe.getName())) == 'N/A') ? false : true ;
                system.debug('fieldDescribe.getLabel()--->'+fieldDescribe.getLabel());
                if (isDependent && isTrue && fieldDescribe.getLabel() == 'Term Matrix Name') {
                    system.debug('fieldDescribe.getLabel()--->'+fieldDescribe.getLabel());
                    //Phoenix_Terms_Matrix_History__c termsHistory = createUpdateHistory(fieldDescribe, oldTerm, termMatrix);
                    Phoenix_Terms_Matrix_History__c termsHistory = new Phoenix_Terms_Matrix_History__c();
                    termsHistory.Phoenix_Terms_Matrix__c = termMatrix.Id;
                    termsHistory.Phoenix_Field_Name__c = fieldDescribe.getLabel();
                    termsHistory.Phoenix_User__c = UserInfo.getUserId();
                    termsHistory.Phoenix_Original_Value__c =  String.valueOf(oldTerm.get(fieldDescribe.getName()));
                    termsHistory.Phoenix_Current_Value__c =   String.valueOf(termMatrix.get(fieldDescribe.getName()));
                    termsHistory.Phoenix_Date__c = System.now();
                    insert termsHistory;
                }
            }
        }
        
        
    }
    
    private Phoenix_Terms_Matrix_History__c createUpdateHistory(Schema.DescribeFieldResult field, Phoenix_Terms_Matrix__c oldTerm, Phoenix_Terms_Matrix__c termMatrix) {
        Phoenix_Terms_Matrix_History__c termsHistory = new Phoenix_Terms_Matrix_History__c();
        termsHistory.Phoenix_Terms_Matrix__c = termMatrix.Id;
        termsHistory.Phoenix_Field_Name__c = field.getLabel();
        termsHistory.Phoenix_User__c = UserInfo.getUserId();
        // shorten strings that are longer than 255 characters (can happen if the field has the type textArea)
        termsHistory.Phoenix_Date__c = System.now();
        return termsHistory;
    }
    
    
    
}