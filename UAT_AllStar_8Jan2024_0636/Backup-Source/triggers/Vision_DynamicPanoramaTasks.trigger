trigger Vision_DynamicPanoramaTasks on Vision_Market_Share_Expansion__c (before insert, before update) {
    if(trigger.isInsert){
        List<String> productCodes = new List<String>();
        //Map<String, List<Vision_Market_Share_Expansion__c>> expMoveMap = new Map<String, List<Vision_Market_Share_Expansion__c>>();
        for(Vision_Market_Share_Expansion__c obj : trigger.new){
            if(obj.GCP_Product_Code__c != null){
                string prodCode = obj.GCP_Product_Code__c;
                if(!productCodes.contains(prodCode))
                    productCodes.add(prodCode);
                //if(!expMoveMap.containsKey(prodCode))
                //    expMoveMap.put(prodCode, New List<Vision_Market_Share_Expansion__c>());
                //expMoveMap.get(prodCode).add(obj);
            }
        }
        Map<String, string> prodCodeMap = new Map<String, String>();
        if(productCodes.size()>0){
            List<Product2> prodList = [SELECT Id, Name, productCode FROM Product2 WHERE productCode IN: productCodes];
            for(Product2 prod : prodList){
                string prodCode = prod.productCode;
                if(!prodCodeMap.containsKey(prodCode))
                    prodCodeMap.put(prodCode,prod.Id);
                /*if(expMoveMap.containsKey(prodCode)){
                    List<Vision_Market_Share_Expansion__c> moveList = new List<Vision_Market_Share_Expansion__c>(); 
                    for(Vision_Market_Share_Expansion__c obj:moveList){
                        obj.Vision_Product__c = prod.Id;
                    }
                }*/
            }
        }
        for(Vision_Market_Share_Expansion__c obj : trigger.new){
            if(obj.Task_Status__c == 'not_started' || obj.Task_Status__c == 'in_progress')
                obj.Task_Status__c = 'New';
            else if(obj.Task_Status__c == 'dropped')
                obj.Task_Status__c = 'Dropped';
            if(obj.GCP_Product_Code__c != null){
                string prodCode = obj.GCP_Product_Code__c;
                if(prodCodeMap.containsKey(prodCode))
                    obj.Vision_Product__c = prodCodeMap.get(prodCode);
            }
        }
    }
    else if(trigger.isUpdate){
        List<Id> itemIds =  new List<Id>();
        for(Vision_Market_Share_Expansion__c obj : trigger.new){
            itemIds.add(obj.Id);
        }
        String query = 'SELECT Vision_Product__r.Phoenix_Pkg_Size__c, Vision_Product__r.Name,'+
            +' Vision_Customer__r.Name, Vision_Customer__r.OwnerId, Vision_Customer__r.Owner.Name,'+
            +' Vision_Customer__r.Owner.Email, '+Phoenix_Util.getsObjectFieds('Vision_Market_Share_Expansion__c')+' FROM Vision_Market_Share_Expansion__c WHERE Id IN: itemIds';
        List<Vision_Market_Share_Expansion__c> itemList = Database.query(query);
        Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Vision_DynamicPanoramaTasks', itemList[0].Id);
        
        Map<Id,Vision_Market_Share_Expansion__c> objMap = new Map<Id,Vision_Market_Share_Expansion__c>();
        for(Vision_Market_Share_Expansion__c obj : itemList){
            objMap.put(obj.Id,obj);//.Vision_Product__r.Phoenix_Pkg_Size__c != null ? obj.Vision_Product__r.Phoenix_Pkg_Size__c : 1);
        }
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        list<Document> lstDocument = [SELECT Id FROM Document WHERE DeveloperName = 'Vision_Logo'];
        String strOrgId = UserInfo.getOrganizationId();
        
        String strLogoUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + 
            '/servlet/servlet.ImageServer?id='+lstDocument[0].Id +'&oid='+ strOrgId;
        String header= '<div style="width: 691px;max-width: 691px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #6900EF; text-align: left; color: white; font-size: 20px;">PANORAMA TASK<img src="'+strLogoUrl+'" width="55" height="25" align="right" style="padding-right:15px;padding-bottom:7px;padding-top:1px;"alt="Logo"</img></div><br/><br/>';
        
        Map<String, List<Vision_Market_Share_Expansion__c>> droppedMap = new Map<String, List<Vision_Market_Share_Expansion__c>>();
        
        for(Vision_Market_Share_Expansion__c obj : trigger.new){
            Vision_Market_Share_Expansion__c oldObj = Trigger.oldMap.get(obj.ID);
            List<String> updatedItems = New List<String>();
            List<String> updatedOldValues = New List<String>();
            List<String> updatedValues = New List<String>();
            if(obj.Task_Status__c == 'Dropped' || obj.Task_Status__c == 'dropped'){
                if(!droppedMap.containsKey(obj.Task_Ident__c))
                    droppedMap.put(obj.Task_Ident__c, new List<Vision_Market_Share_Expansion__c>());
                droppedMap.get(obj.Task_Ident__c).add(obj);
            }
            else{
                if(oldObj.Target_Price__c != obj.Target_Price__c && obj.Target_Price__c != null){
                    obj.Vision_Old_Target_Price__c = oldObj.Target_Price__c;
                    updatedItems.add('Target Price');updatedOldValues.add(''+oldObj.Target_Price__c);updatedValues.add(''+obj.Target_Price__c);
                    
                    if(obj.Task_Status__c == 'New' || obj.Task_Status__c == 'not_started' || obj.Task_Status__c == 'in_progress'){
                        obj.Proposed_Direct_Selling_Units__c = obj.Proposed_Direct_Selling_Units__c != null ?  obj.Proposed_Direct_Selling_Units__c : 0;
                        obj.Proposed_Indirect_Selling_Units__c = obj.Proposed_Indirect_Selling_Units__c != null ?  obj.Proposed_Indirect_Selling_Units__c : 0;
                        obj.Vision_Proposed_OS_Units__c = obj.Vision_Proposed_OS_Units__c != null ?  obj.Vision_Proposed_OS_Units__c : 0;
                        obj.Vision_Proposed_RAD_Units__c = obj.Vision_Proposed_RAD_Units__c != null ?  obj.Vision_Proposed_RAD_Units__c : 0;
                        obj.Vision_Proposed_WMT_Units__c = obj.Vision_Proposed_WMT_Units__c != null ?  obj.Vision_Proposed_WMT_Units__c : 0;
                        obj.Vision_Proposed_BASE_Units__c = obj.Vision_Proposed_BASE_Units__c != null ?  obj.Vision_Proposed_BASE_Units__c : 0;
                        obj.Vision_Proposed_DSH_Units__c = obj.Vision_Proposed_DSH_Units__c != null ?  obj.Vision_Proposed_DSH_Units__c : 0;
                        obj.Vision_Proposed_AutoSub_Units__c = obj.Vision_Proposed_AutoSub_Units__c != null ?  obj.Vision_Proposed_AutoSub_Units__c : 0;
                        obj.Vision_Proposed_Smith_Drug_Units__c = obj.Vision_Proposed_Smith_Drug_Units__c != null ?  obj.Vision_Proposed_Smith_Drug_Units__c : 0;
                        obj.Vision_Proposed_Anda_Units__c = obj.Vision_Proposed_Anda_Units__c != null ?  obj.Vision_Proposed_Anda_Units__c : 0;
                        obj.Vision_Proposed_DirectAholdDelhaizeUnits__c = obj.Vision_Proposed_DirectAholdDelhaizeUnits__c != null ?  obj.Vision_Proposed_DirectAholdDelhaizeUnits__c : 0;
                        obj.Vision_Proposed_Direct_Gaint_Eagle_Units__c = obj.Vision_Proposed_Direct_Gaint_Eagle_Units__c != null ?  obj.Vision_Proposed_Direct_Gaint_Eagle_Units__c : 0;
                        obj.Vision_Proposed_TotalRetailIndirectUnits__c = obj.Vision_Proposed_TotalRetailIndirectUnits__c != null ?  obj.Vision_Proposed_TotalRetailIndirectUnits__c : 0;
                        
                        obj.Vision_Proposed_Direct_ESI_Units__c = obj.Vision_Proposed_Direct_ESI_Units__c != null ?  obj.Vision_Proposed_Direct_ESI_Units__c : 0;
                        obj.Vision_Proposed_Indirect_ESI_Units__c = obj.Vision_Proposed_Indirect_ESI_Units__c != null ?  obj.Vision_Proposed_Indirect_ESI_Units__c : 0;
                        obj.Vision_Proposed_Direct_Kroger_Units__c = obj.Vision_Proposed_Direct_Kroger_Units__c != null ?  obj.Vision_Proposed_Direct_Kroger_Units__c : 0;
                        obj.Vision_Proposed_Indirect_Kroger_Units__c = obj.Vision_Proposed_Indirect_Kroger_Units__c != null ?  obj.Vision_Proposed_Indirect_Kroger_Units__c : 0;
                        obj.Vision_Proposed_Direct_Rx_Outreach_Units__c = obj.Vision_Proposed_Direct_Rx_Outreach_Units__c != null ?  obj.Vision_Proposed_Direct_Rx_Outreach_Units__c : 0;
                        obj.Vision_Proposed_IndirectRxOutreach_Units__c = obj.Vision_Proposed_IndirectRxOutreach_Units__c != null ?  obj.Vision_Proposed_IndirectRxOutreach_Units__c : 0;
                        obj.Vision_Proposed_Direct_Supervalu_Units__c = obj.Vision_Proposed_Direct_Supervalu_Units__c != null ?  obj.Vision_Proposed_Direct_Supervalu_Units__c : 0;
                        obj.Vision_Proposed_Indirect_Supervalu_Units__c = obj.Vision_Proposed_Indirect_Supervalu_Units__c != null ?  obj.Vision_Proposed_Indirect_Supervalu_Units__c : 0;
                        obj.Vision_Proposed_Direct_Cigna_Units__c = obj.Vision_Proposed_Direct_Cigna_Units__c != null ?  obj.Vision_Proposed_Direct_Cigna_Units__c : 0;
                        obj.Vision_Proposed_Indirect_Cigna_Units__c = obj.Vision_Proposed_Indirect_Cigna_Units__c != null ?  obj.Vision_Proposed_Indirect_Cigna_Units__c : 0;
                        obj.Vision_Proposed_Direct_Cordant_Units__c = obj.Vision_Proposed_Direct_Cordant_Units__c != null ?  obj.Vision_Proposed_Direct_Cordant_Units__c : 0;
                        obj.Vision_Proposed_Direct_Accerodo_Units__c = obj.Vision_Proposed_Direct_Accerodo_Units__c != null ?  obj.Vision_Proposed_Direct_Accerodo_Units__c : 0;
                        obj.Vision_Proposed_Indirect_Accerodo_Units__c = obj.Vision_Proposed_Indirect_Accerodo_Units__c != null ?  obj.Vision_Proposed_Indirect_Accerodo_Units__c : 0;
                        obj.Vision_Proposed_Indirect_Cordant_Units__c = obj.Vision_Proposed_Indirect_Cordant_Units__c != null ?  obj.Vision_Proposed_Indirect_Cordant_Units__c : 0;
                        obj.Vision_Total_Proposed_Units_EU__c = obj.Vision_Total_Proposed_Units_EU__c != null ?  obj.Vision_Total_Proposed_Units_EU__c : 0;
                        obj.Vision_Proposed_Value_EA__c = obj.Vision_Proposed_Value_EA__c != null ?  obj.Vision_Proposed_Value_EA__c : 0;
                        
                        obj.Vision_Proposed_CVS_Direct_Units__c = obj.Vision_Proposed_CVS_Direct_Units__c != null ?  obj.Vision_Proposed_CVS_Direct_Units__c : 0;
                        obj.Vision_Proposed_CVS_Indirect_Units__c = obj.Vision_Proposed_CVS_Indirect_Units__c != null ?  obj.Vision_Proposed_CVS_Indirect_Units__c : 0;
                        obj.Vision_Proposed_Cardinal_Units__c = obj.Vision_Proposed_Cardinal_Units__c != null ?  obj.Vision_Proposed_Cardinal_Units__c : 0;
                        obj.Vision_Proposed_Major_Units__c = obj.Vision_Proposed_Major_Units__c != null ?  obj.Vision_Proposed_Major_Units__c : 0;
                        obj.Vision_Proposed_Volume__c = obj.Vision_Proposed_Volume__c != null ?  obj.Vision_Proposed_Volume__c : 0;
                        obj.Vision_Proposed_Share_Percentage__c = obj.Vision_Proposed_Share_Percentage__c != null ?  obj.Vision_Proposed_Share_Percentage__c : 0;
                        Decimal totalProposedUnits = obj.Proposed_Direct_Selling_Units__c+obj.Proposed_Indirect_Selling_Units__c+obj.Vision_Proposed_OS_Units__c+
                            +obj.Vision_Proposed_RAD_Units__c+obj.Vision_Proposed_WMT_Units__c+obj.Vision_Proposed_BASE_Units__c+obj.Vision_Proposed_DSH_Units__c+
                            +obj.Vision_Proposed_AutoSub_Units__c+obj.Vision_Proposed_Smith_Drug_Units__c+obj.Vision_Proposed_Anda_Units__c+obj.Vision_Proposed_DirectAholdDelhaizeUnits__c+
                            +obj.Vision_Proposed_Direct_Gaint_Eagle_Units__c+obj.Vision_Proposed_TotalRetailIndirectUnits__c+obj.Vision_Proposed_Direct_ESI_Units__c+
                            +obj.Vision_Proposed_Indirect_ESI_Units__c+obj.Vision_Proposed_Direct_Kroger_Units__c+obj.Vision_Proposed_Indirect_Kroger_Units__c+
                            +obj.Vision_Proposed_Direct_Rx_Outreach_Units__c+obj.Vision_Proposed_IndirectRxOutreach_Units__c+obj.Vision_Proposed_Direct_Supervalu_Units__c+
                            +obj.Vision_Proposed_Indirect_Supervalu_Units__c+obj.Vision_Proposed_Direct_Cigna_Units__c+obj.Vision_Proposed_Indirect_Cigna_Units__c+
                            +obj.Vision_Proposed_Direct_Cordant_Units__c+obj.Vision_Proposed_Indirect_Cordant_Units__c+obj.Vision_Proposed_Direct_Accerodo_Units__c+
                            +obj.Vision_Proposed_Indirect_Accerodo_Units__c+obj.Vision_Proposed_CVS_Direct_Units__c+obj.Vision_Proposed_CVS_Indirect_Units__c+obj.Vision_Proposed_Cardinal_Units__c+obj.Vision_Proposed_Major_Units__c;
                        Decimal pkgSize = objMap.get(obj.Id).Vision_Product__r.Phoenix_Pkg_Size__c;//obj.Vision_Product__r.Phoenix_Pkg_Size__c != null ? obj.Vision_Product__r.Phoenix_Pkg_Size__c : 1;
                        obj.Vision_Total_Proposed_Units_EU__c = (pkgSize != null ? pkgSize : 1) * totalProposedUnits;
                        obj.Vision_Proposed_Value_EA__c = obj.Vision_Total_Proposed_Units_EU__c * obj.Target_Price__c;
                    }
                }
                if(oldObj.Target_Volume__c != obj.Target_Volume__c && obj.Target_Volume__c != null){
                    obj.Vision_Old_Target_Volume__c = oldObj.Target_Volume__c;
                    updatedItems.add('Target Volume');updatedOldValues.add(''+oldObj.Target_Volume__c);updatedValues.add(''+obj.Target_Volume__c);
                }
                if(oldObj.Task_Type__c != obj.Task_Type__c && obj.Task_Type__c != null){
                    obj.Vision_Old_Task_Type__c = oldObj.Task_Type__c;
                    updatedItems.add('Task Type');updatedOldValues.add(''+oldObj.Task_Type__c);updatedValues.add(''+obj.Task_Type__c);
                }
                if(oldObj.Target_Dollar__c != obj.Target_Dollar__c && obj.Target_Dollar__c != null){
                    obj.Vision_Old_Target_Dollar__c = oldObj.Target_Dollar__c;
                    updatedItems.add('Target Dollar');updatedOldValues.add(''+oldObj.Target_Dollar__c);updatedValues.add(''+obj.Target_Dollar__c);
                }
                
                if(updatedItems.size()>0){
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    String templateBody = emailWrapper.mailHtmlBody;
                    Vision_Market_Share_Expansion__c item = objMap.get(obj.Id);
                    String tableString = '<table style="width: 700px; border-collapse: collapse;"><thead><tr><th style="width: 500px; padding: 2px 8px; color:white;border: 1px solid black; text-align: left;background-color:#257CFF;">Name</th><th style="width: 200px;padding: 2px 8px; color:white;background-color: #FEB343;border: 1px solid black; text-align: right;">Old Value</th><th style="width: 200px;padding: 2px 8px; color:white;background-color: #FEB343;border: 1px solid black; text-align: right;">Updated Value</th></tr></thead>';
                    tableString += '<tbody>';
                    for(Integer i=0;i<updatedItems.size();i++){
                        tableString += '<tr>';
                        tableString += '<td style="padding: 2px 8px;border: 1px solid black;">'+updatedItems[i]+'</td>'+
                            +'<td style="padding: 2px 8px;border: 1px solid black; text-align: right;">'+updatedOldValues[i]+'</td>'+
                            +'<td style="padding: 2px 8px;border: 1px solid black; text-align: right;">' +updatedValues[i]+ '</td>'; 
                        tableString += '</tr>';
                    }
                    tableString += '</tbody></table></br><div style="width: 700px;max-width: 700px;text-align: right;"><a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+item.Vision_Customer__c+'">Click Here</a>&nbsp;&nbsp; to view the Account for more details.</div></br>';
                    
                    templateBody = templateBody.replace('HEADER',header)
                        .replace('ACCOUNT_OWNER', item.Vision_Customer__r.Owner.Name)
                        .replace('PROD_NAME', item.Vision_Product__r.Name)
                        .replace('ITEM_TABLE', tableString);
                    email.setHtmlBody(templateBody);
                    email.setSubject('Panorama Task has been updated');
                    List<String> emailList = new List<String>{'ashok@dhruvsoft.com'};//{item.Vision_Customer__r.Owner.Email};
                        email.setToAddresses(emailList);//{'pradeep@dhruvsoft.com'});//
                    mails.add(email);
                }
            }
            if(obj.Task_Status__c == 'not_started' || obj.Task_Status__c == 'in_progress')
                obj.Task_Status__c = 'New';
            else if(obj.Task_Status__c == 'dropped')
                obj.Task_Status__c = 'Dropped';
        }
        for(String idItem:droppedMap.keySet()){
            List<Vision_Market_Share_Expansion__c> sharelist = droppedMap.get(idItem);
            String templateBody = emailWrapper.mailHtmlBody;
            List<String> prodList = new List<String>();
            string customerOwnerName = '', ownerEmail = '';
            for(Vision_Market_Share_Expansion__c item : sharelist){
                Vision_Market_Share_Expansion__c obj = objMap.get(item.Id);
                prodList.add(obj.Vision_Product__r.Name);
                if(customerOwnerName == '')
                    customerOwnerName = obj.Vision_Customer__r.Owner.Name;
                if(ownerEmail == '')
                    ownerEmail = obj.Vision_Customer__r.Owner.Email;
            }
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            templateBody = templateBody.replace('HEADER',header)
                .replace('ACCOUNT_OWNER', customerOwnerName)
                .replace('Panorama Task for PROD_NAME has been updated as follows.', 'Panorama Task has been dropped.<br/> Here is the list of products which are Dropped.')
                .replace('ITEM_TABLE', ''+string.join(prodList, ','));
            email.setHtmlBody(templateBody);
            email.setSubject('Panorama Task has been Dropped.');
            List<String> emailList = new List<String>{ownerEmail};//{'ashok@dhruvsoft.com'};//
                email.setToAddresses(emailList);//{'pradeep@dhruvsoft.com'});//
            mails.add(email);
        }
        
        if(mails.size()>0)
            Messaging.sendEmail(mails);
    }
}