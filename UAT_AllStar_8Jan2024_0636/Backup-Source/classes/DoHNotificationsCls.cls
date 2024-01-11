public class DoHNotificationsCls {
    public static void notifyUsers(Map<String, Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>> mapOfAllDoH, String recordId, String keyString) {
        // Get the Id for our custom notification type
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Custom_Email_Notification'];
        String pgRef = '{type: "standard__navItemPage",attributes: {apiName: "DoH_Report"}}';
        String labels = System.Label.Core_Team_Ids;
        Set<String> teamIds = new Set<String>(labels.split(','));
        String emails = System.Label.Core_Team_Emails;
        List<String> teamEmails = new List<String>(emails.split(','));
        //String pgRef = '{type: "standard__namedPage",attributes: {pageName: "home"}}';
        Map<String, List<GCP_DOH_Trade_Partner_NDC__c>> emailMap = new Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>();
        for(String key: mapOfAllDoH.keySet()){
            try{
                List<GCP_DOH_Trade_Partner_NDC__c> totalList = new List<GCP_DOH_Trade_Partner_NDC__c>();
                Map<String,List<GCP_DOH_Trade_Partner_NDC__c>> dataList = mapOfAllDoH.get(key);
                if(dataList.containsKey('SRx')){
                    List<GCP_DOH_Trade_Partner_NDC__c> SRxList = dataList.get('SRx');
                    totalList.addAll(SRxList);
                    set<string> recipientsIds =new set<string>{SRxList[0].Account_Manager__c};
                        Messaging.CustomNotification notification = new Messaging.CustomNotification();
                    string bodyContent = ''; string low='';
                    if(keyString == 'Low Inventory'){
                        low+='<b>SRx Low Inventory</b><br><br>';
                        notification.setTitle('SRx Low Inventory');
                        bodyContent = 'There are '+SRxList.size()+' Product(s) with Low Inventory for '+key;
                        low+=bodyContent+'<br><a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/DoH_Report'+ +'">Click to view Details.</a>';
                        low = low.replaceAll('"','\'');                        
                    } else if(keyString == 'High Inventory'){
                        low+='<b>SRx High Inventory</b><br><br>';
                        notification.setTitle('SRx High Inventory');
                        bodyContent = 'There are '+SRxList.size()+' Product(s) with High Inventory for '+key;
                        low+=bodyContent+'<br><a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/DoH_Report'+ +'">Click to view Details.</a>';
                        low = low.replaceAll('"','\'');                        
                    } else if(keyString == 'High Value'){
                        low+='<b>SRx High Value</b><br><br>';
                        notification.setTitle('SRx High Value');
                        bodyContent = 'There are '+SRxList.size()+' Product(s) with High Value for '+key;
                        low+=bodyContent+'<br><a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/DoH_Report'+ +'">Click to view Details.</a>';
                        low = low.replaceAll('"','\'');                        
                    }
                    notification.setBody(bodyContent);
                    // Set the notification type and target
                    notification.setNotificationTypeId(notificationType.Id);
                    notification.setTargetPageRef(pgRef);
                    // Send the notification
                    try {
                        notification.send(teamIds);
                        
                        //System.debug('Email Id SRX '+SRxList[0].Account_Manager__r.Email);
                        //Teams_Integration.triggersendMessage(SRxList[0].Account_Manager__r.Email,low);
                        
                        //Teams_Integration.triggersendMessage('ramyabandari@drreddys.com',low);
                        //Teams_Integration.triggersendMessage('surenderpatel@drreddys.com',low);
                        
                        
                        
                        
                    }
                    catch (Exception e) {
                        String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
                        Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'DoHNotificationsCls', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'afterInsertUpdate', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Remarks__c ='' , Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                        insert exp;
                    }   
                }
                if(dataList.containsKey('Rx')){
                    system.debug('Rx');
                    List<GCP_DOH_Trade_Partner_NDC__c> RxList = dataList.get('Rx'); 
                    totalList.addAll(RxList);
                    Messaging.CustomNotification notification2 = new Messaging.CustomNotification();
                    set<string> recipientsIds = new set<string>{RxList[0].Account_Manager__c};
                        // Set the contents for the notification RxList[0].Account_Manager__c
                        string bodyContent2 = ''; string low='';
                    
                    if(keyString == 'Low Inventory'){
                        low+='<b>Rx Low Inventory</b><br><br>';
                        notification2.setTitle('Rx Low Inventory');
                        bodyContent2 = 'There are '+RxList.size()+' Product(s) with Low Inventory for '+key;
                        low+=bodyContent2+'<br><a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/DoH_Report'+ +'">Click to view Details.</a>';
                        low = low.replaceAll('"','\'');
                    } else if(keyString == 'High Inventory'){
                        low+='<b>Rx High Inventory</b><br><br>';
                        notification2.setTitle('Rx High Inventory');
                        bodyContent2 = 'There are '+RxList.size()+' Product(s) with High Inventory for '+key;
                        low+=bodyContent2+'<br><a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/DoH_Report'+ +'">Click to view Details.</a>';
                        low = low.replaceAll('"','\'');                        
                    } else if(keyString == 'High Value'){
                        low+='<b>Rx High Value</b><br><br>';
                        notification2.setTitle('Rx High Value');
                        bodyContent2 = 'There are '+RxList.size()+' Product(s) with High Value for '+key;
                        low+=bodyContent2+'<br><a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/DoH_Report'+ +'">Click to view Details.</a>';
                        low = low.replaceAll('"','\'');
                    }
                    notification2.setBody(bodyContent2);
                    // Set the notification type and target
                    notification2.setNotificationTypeId(notificationType.Id);
                    notification2.setTargetPageRef(pgRef);
                    // Send the notification
                    try {
                        notification2.send(teamIds);            
                    }
                    catch (Exception e) {
                        String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
                        Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'DoHNotificationsCls', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'afterInsertUpdate', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Remarks__c ='' , Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                        insert exp;
                    }   
                }
                emailMap.put(key, totalList);
                
            } catch (Exception e){
                String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'DoHNotificationsCls', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'afterInsertUpdate', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Remarks__c ='' , Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
        }
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Map<String, List<GCP_DOH_Trade_Partner_NDC__c>> finalMap = new Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>();
        //String id=UserInfo.getUserId();
        //List<String> managers = new List<String>{'0057A000003tZadQAE'};
        //List<String> managers = new List<String>{id};
        
        List<GCP_DOH_Trade_Partner_NDC__c> productList = new List<GCP_DOH_Trade_Partner_NDC__c>();
        List<String> types = new List<String> {'Rx', 'SRx'};
            map<string,List<GCP_DOH_Trade_Partner_NDC__c>> lowInventoryMap =new  map<string,List<GCP_DOH_Trade_Partner_NDC__c>>();
        map<string,List<GCP_DOH_Trade_Partner_NDC__c>> highInventoryMap =new  map<string,List<GCP_DOH_Trade_Partner_NDC__c>>();
        map<string,List<GCP_DOH_Trade_Partner_NDC__c>> highValueMap =new  map<string,List<GCP_DOH_Trade_Partner_NDC__c>>();
        //List<GCP_DOH_Trade_Partner_NDC__c> list1 = new List<GCP_DOH_Trade_Partner_NDC__c>();
        for(GCP_DOH_Trade_Partner_NDC__c rec:[SELECT Id, Account_Manager__r.Email, Product__r.Name, vision_gcp_w4_day__c, Vision_GCP_W4_DOH__c, Account_Manager__c, vision_gcp_trade_partner_name__c, Product__r.Phoenix_Rx_SRx_OTC__c FROM GCP_DOH_Trade_Partner_NDC__c WHERE  Vision_GCP_W4_DOH__c <= 12  AND Product__r.Name != null AND Product__r.Phoenix_Rx_SRx_OTC__c IN: types and Account_Manager__c!=null ORDER By Vision_GCP_W4_DOH__c ASC LIMIT 5]){
            if(lowInventoryMap.containskey(rec.vision_gcp_trade_partner_name__c)){
                lowInventoryMap.get(rec.vision_gcp_trade_partner_name__c).add(rec);
            }
            else{
                lowInventoryMap.put(rec.vision_gcp_trade_partner_name__c, new list<GCP_DOH_Trade_Partner_NDC__c>{rec});
            }
        }
        for(GCP_DOH_Trade_Partner_NDC__c rec1:[SELECT Id, Account_Manager__r.Email, Product__r.Name, vision_gcp_w4_day__c, Vision_GCP_W4_DOH__c, Account_Manager__c, vision_gcp_trade_partner_name__c, Product__r.Phoenix_Rx_SRx_OTC__c FROM GCP_DOH_Trade_Partner_NDC__c WHERE  Vision_GCP_W4_DOH__c >=45   AND Product__r.Name != null AND Product__r.Phoenix_Rx_SRx_OTC__c IN: types and Account_Manager__c!=null ORDER By Vision_GCP_W4_DOH__c desc LIMIT 5]){
            if(highInventoryMap.containskey(rec1.vision_gcp_trade_partner_name__c)) highInventoryMap.get(rec1.vision_gcp_trade_partner_name__c).add(rec1);
             else highInventoryMap.put(rec1.vision_gcp_trade_partner_name__c, new list<GCP_DOH_Trade_Partner_NDC__c>{rec1});
        }
        for(GCP_DOH_Trade_Partner_NDC__c rec2:[SELECT Id, Account_Manager__r.Email, Product__r.Name, vision_gcp_w4_day__c, Vision_GCP_W4_DOH__c, Account_Manager__c, vision_gcp_trade_partner_name__c, Product__r.Phoenix_Rx_SRx_OTC__c FROM GCP_DOH_Trade_Partner_NDC__c WHERE  Value_W4__c >= 100000  AND Product__r.Name != null AND Product__r.Phoenix_Rx_SRx_OTC__c IN: types and Account_Manager__c!=null ORDER By Vision_GCP_W4_DOH__c desc LIMIT 5]){
            if(highValueMap.containskey(rec2.vision_gcp_trade_partner_name__c)) highValueMap.get(rec2.vision_gcp_trade_partner_name__c).add(rec2);
            else highValueMap.put(rec2.vision_gcp_trade_partner_name__c, new list<GCP_DOH_Trade_Partner_NDC__c>{rec2});
        }
        system.debug('email map...'+emailMap.keySet());
        
        for(String key: emailMap.keySet()){
            if(keyString == 'Low Inventory'){
                if(lowInventoryMap.containskey(key)) productList=lowInventoryMap.get(key);
            } else if(keyString == 'High Inventory'){
                if(highInventoryMap.containskey(key)) productList=highInventoryMap.get(key);  
            } else if(keyString == 'High Value'){
                if(highValueMap.containskey(key)) productList=highValueMap.get(key);
            }
            
            if(productList.size() > 0){
                if(finalMap.containsKey(productList[0].Account_Manager__r.Email)){
                    List<GCP_DOH_Trade_Partner_NDC__c> tempList = finalMap.get(productList[0].Account_Manager__r.Email);
                    tempList.addAll(productList);
                    finalMap.put(productList[0].Account_Manager__r.Email, tempList);
                } else finalMap.put(productList[0].Account_Manager__r.Email, productList); 
            }         
        }
        Map<String, Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>> finalData = new Map<String, Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>>();
        for(String key: finalMap.keySet()){
            List<GCP_DOH_Trade_Partner_NDC__c> tempList = finalMap.get(key);
            Map<String, List<GCP_DOH_Trade_Partner_NDC__c>> custMap =  new Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>();
            for(GCP_DOH_Trade_Partner_NDC__c doh: tempList){
                if(custMap.containsKey(doh.vision_gcp_trade_partner_name__c)){
                    List<GCP_DOH_Trade_Partner_NDC__c> temp = custMap.get(doh.vision_gcp_trade_partner_name__c);
                    temp.add(doh);
                    custMap.put(doh.vision_gcp_trade_partner_name__c, temp);
                } else custMap.put(doh.vision_gcp_trade_partner_name__c, new List<GCP_DOH_Trade_Partner_NDC__c> {doh});
            }
            finalData.put(key, custMap);
        }
        Map<String,User> userMap = new Map<String,User>();
        List<Document> lstDocument = New List<Document>();
        Set<Id> lstDocumentIds = New Set<Id>();
        for(User usr : [SELECT Id,Email,Name FROM User WHERE IsActive=True]){
            userMap.put(usr.Email,usr);
        }
        lstDocument = [SELECT Id FROM Document WHERE Id in : lstDocumentIds];
        String instanceName=[Select InstanceName FROM Organization limit 1].InstanceName;
        system.debug('final datalkey'+finalData.keySet());
        try{
        for(String key: finalData.keySet()){
            system.debug('final data...' );
            User u = new User();
            if(userMap.containsKey(key)) u = userMap.get(key);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('DoH_Low_Inventory', recordId);
            String templateBody = emailWrapper.mailHtmlBody;
            String subject = 'DoH Report for ';
            if(keyString == 'Low Inventory') subject += 'Low Inventory';
            else if(keyString == 'High Inventory') subject += 'High Inventory';
            else if(keyString == 'High Value') subject += 'High Value';
            String tableData = '';
            for(Document doc : lstDocument){
                if(doc.DeveloperName =='Vision_Logo') lstDocumentIds.add(doc.Id);
            }
            String strOrgId = UserInfo.getOrganizationId();
            //String strLogoUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id='+lstDocument[0].Id + '&oid=' + strOrgId;
            //String header= '<div style="width: 691px;max-width: 691px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #6900EF; text-align: left; color: white; font-size: 20px;">DoH Report ('+keyString+')<img src="'+strLogoUrl+'" width="60" height="25" align="right" style="padding-right:15px;padding-bottom:7px;padding-top:1px;"alt="Logo"</img></div><br/><br/>';
            String header= '<div style="width: 691px;max-width: 691px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #6900EF; text-align: left; color: white; font-size: 20px;">DoH Report ('+keyString+')</div><br/><br/>';
            Map<String, List<GCP_DOH_Trade_Partner_NDC__c>> tempMap = finalData.get(key);
            for(String k: tempMap.keySet()){
                system.debug('entered ehere');
                List<GCP_DOH_Trade_Partner_NDC__c> tempList = tempMap.get(k);
                if(tempList.size() > 0){
                    tableData += '<table style="width: 700px; border-collapse: collapse;"><thead><tr><th style="width: 500px; padding: 2px 8px; color:white;border: 1px solid black; text-align: left;background-color:#257CFF;">'+k+'</th><th style="width: 200px;padding: 2px 8px; color:white;background-color: #FEB343;border: 1px solid black; text-align: right;">DoH ('+tempList[0].vision_gcp_w4_day__c.month() + '-' + tempList[0].vision_gcp_w4_day__c.day() + '-' + tempList[0].vision_gcp_w4_day__c.year()+')</th></tr></thead><tbody>';
                    for (GCP_DOH_Trade_Partner_NDC__c doh: tempList) {
                        tableData += '<tr><td style="padding: 2px 8px;border: 1px solid black;">' + doh.Product__r.Name + '</td>';
                        tableData += '<td style="padding: 2px 8px;border: 1px solid black; text-align: right;">' + doh.Vision_GCP_W4_DOH__c + '</td></tr>';
                    }
                    tableData += '</tbody></table></br><div style="width: 700px;max-width: 700px;text-align: right;"><a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/DoH_Report">More Details</a></div></br>';
                }
            }
            templateBody = templateBody.replace('DOH_TABLE', tableData).replace('ACCOUNT_MANAGER', u.Name).replace('HEADER', header);
            email.setHtmlBody(templateBody);
            email.setSubject(subject);
            system.debug('teamemails...'+teamEmails);
            email.setToAddresses(teamEmails);//key
            mails.add(email);
        }
            system.debug('mails,,,,'+mails);
            messaging.sendEmail(mails);
            
        }
       
        catch(exception e){
            system.debug('email catch...'+e.getMessage()+'....'+e.getLineNumber());
        }
        
    }
    public static void sendDataUpdateNotification(String featureType, String bodyContent, String title){
        String labels = System.Label.Core_Team_Ids;
        Set<String> teamIds = new Set<String>(labels.split(','));
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Custom_Email_Notification'];
        String pgRef = '{type: "standard__navItemPage",attributes: {apiName: featureType}}';
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle(title);
        notification.setBody(bodyContent);
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetPageRef(pgRef);
        notification.send(teamIds);
    }
}