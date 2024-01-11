public class VisionPanoramaNotificationCls {
    public static void notifyUsers(Map<String, Map<String, List<Vision_Market_Share_Expansion__c>>> mapOfMktExp) {
        //Teams_Integration.sendMessage('ramyabandari@drreddys.com','Sending messege from Salesforce by Ramya at GMT '+System.now());
        
        // Get the Id for our custom notification type
        CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             WHERE DeveloperName='Custom_Email_Notification'];
        //String pgRef = '{type: "standard__namedPage",attributes: {pageName: "home"}}';
        
        //Map<CustomerId, Map<Family, List<MktExp>>>
        // try{
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Vision_Market_Share_Expansion__c expRec = [SELECT Id FROM Vision_Market_Share_Expansion__c LIMIT 1];
        Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Market_Share_Expansion_Email', expRec.Id);
        String instanceName=[Select InstanceName FROM Organization limit 1].InstanceName;
        //String subject = emailWrapper.mailSubject;
        list<Document> lstDocument = [SELECT Id FROM Document WHERE DeveloperName = 'Vision_Logo'];
        String strOrgId = UserInfo.getOrganizationId();
        
        String strLogoUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + 
            '/servlet/servlet.ImageServer?id='+lstDocument[0].Id +
            '&oid=' + strOrgId;
        //String header= '<div style="width: 591px;max-width: 591px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #6900EF; text-align: left; color: white; font-size: 20px;">Product Pipeline<img src="https://CS194.salesforce.com/servlet/servlet.ImageServer?id=01501000000Hpvr&oid=00D010000008q6f&lastMod=1647927437000" width="60" height="25" align="right" style="padding-right:15px;padding-bottom:7px;padding-top:1px;"alt="Logo"</img></div><br/><br/>';
        
        //String header= '<div style="width: 691px;max-width: 691px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #6900EF; text-align: left; color: white; font-size: 20px;">PANORAMA TASK</div><br/><br/>';
        String header= '<div style="width: 691px;max-width: 691px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #6900EF; text-align: left; color: white; font-size: 20px;">PANORAMA TASK<img src="'+strLogoUrl+'" width="55" height="25" align="right" style="padding-right:15px;padding-bottom:7px;padding-top:1px;"alt="Logo"</img></div><br/><br/>';
        
        for(String customerId: mapOfMktExp.keySet()){
             String pgRef = '{ type: "standard__recordPage",attributes:{recordId:' +  customerId+ ',objectApiName: "Account",actionName: "view"} }';
            
            
            for(String family: mapOfMktExp.get(customerId).keySet()){
                List<Vision_Market_Share_Expansion__c> mktExpList = mapOfMktExp.get(customerId).get(family);
                Id owner=[Select id,OwnerId From Account Where ID=:customerId].OwnerId;
                String ownerId=owner;
                 //set<string> recipientsIds =new set<string>{'0057c000007DPNUAA4'}; //Replace with Customer Id
                set<string> recipientsIds =new set<string>{ownerId}; //Replace with Customer Id
                    Messaging.CustomNotification notification = new Messaging.CustomNotification();
                // Set the contents for the notification
                string bodyContent = 'A new task has been created for '+family;
                notification.setBody(bodyContent);
                String panorama='';
                panorama+='<b>New Panorama Task</b><br><br>';
                panorama+=bodyContent+'<br> <a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+customerId+'">Click to view Details</a>';
                //panorama+=' <a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+customerId+'">More Details</a>';
                panorama = panorama.replaceAll('"','\'');
                //panorama = panorama.replaceAll('"','\\"');
               //String  panorama1=URL.getSalesforceBaseUrl().toExternalForm()+'/'+customerId;
                 notification.setTitle('New Panorama Task');
                // Set the notification type and target
                notification.setNotificationTypeId(notificationType.Id);
                notification.setTargetPageRef(pgRef);
                // Send the notification
                try {
                    notification.send(recipientsIds);
                    //Teams_Integration.triggersendMessage(mktExpList[0].Vision_Customer__r.Owner.Email,''+panorama);
                    //Teams_Integration.triggersendMessage('surenderpatel@drreddys.com',''+panorama);
                    // Teams_Integration.triggersendMessage('ramyabandari@drreddys.com',''+panorama);
                    
                    
                    
                }
                catch (Exception e) {
                  
                }
                //Teams_Integration.sendMessage('ramyabandari@drreddys.com','Sending messege from Salesforce by Ramya at GMT '+System.now());
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                String templateBody = emailWrapper.mailHtmlBody;
                //String subject = emailWrapper.mailSubject;
                String subject = 'New Task has been created - '+mktExpList[0].Move_Ident__c;
                String tableData = '';
                String customer = '';
                
                DateTime dT = mktExpList[0].Plan_Contract_Effective_Date__c;
                String myDate = dt.format('MM/dd/yyyy');
                if(mktExpList[0].Plan_Contract_Effective_Date__c != null){
                    customer = 'Target Date: '+myDate+'<br/><br/><b>'+mktExpList[0].Vision_Customer__r.Name+'</b>';   
                } else{
                    customer = '<b>'+mktExpList[0].Vision_Customer__r.Name+'</b>';   
                }
                //String header = '<div style="width: 692px;max-width: 692px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #3f2585; text-align: left; color: white; font-size: 20px;">PANORAMA TASK</div>';
                tableData += '<table style="width: 700px; border-collapse: collapse;"><thead><tr><th style="width: 500px; padding: 2px 8px; color:white;border: 1px solid black; text-align: left;background-color:#257CFF;">'+family+'</th><th style="width: 200px;padding: 2px 8px; color:white;background-color: #FEB343;border: 1px solid black; text-align: right;">NDC</th><th style="width: 200px;padding: 2px 8px; color:white;background-color: #FEB343;border: 1px solid black; text-align: right;">Target Volume</th></tr></thead>'; //<th style="width: 200px;padding: 2px 8px; color:white;background-color: #FEB343;border: 1px solid black; text-align: right;">Target Date</th>
                tableData += '<tbody>';
                for (Vision_Market_Share_Expansion__c mkt: mktExpList) {
                    tableData += '<tr>';
                    tableData += '<td style="padding: 2px 8px;border: 1px solid black;">' + mkt.Vision_Product__r.Name + '</td><td style="padding: 2px 8px;border: 1px solid black; text-align: right;">'+mkt.Vision_Product__r.Phoenix_NDC_11__c+'</td>';
                    if(mkt.Target_Volume__c != null){
                        tableData += '<td style="padding: 2px 8px;border: 1px solid black; text-align: right;">' + mkt.Target_Volume__c.round() + '</td>';   
                    } else{
                        tableData += '<td style="padding: 2px 8px;border: 1px solid black; text-align: right;"></td>';
                    }
                    tableData += '</tr>';
                }
                tableData += '</tbody></table></br><div style="width: 700px;max-width: 700px;text-align: right;"><a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+customerId+'">More Details</a></div></br>';
                templateBody = templateBody.replace('EXPANSION_TABLE', tableData).replace('CUSTOMER', customer).replace('HEADER', header).replace('ACCOUNT_OWNER', mktExpList[0].Vision_Customer__r.Owner.Name);
                email.setHtmlBody(templateBody);
                email.setSubject(subject);
                //email.setToAddresses(new List<String>{'ramyabandari@drreddys.com'});  //mktExpList[0].Vision_Customer__r.Owner.Email,
                
                email.setToAddresses(new List<String>{mktExpList[0].Vision_Customer__r.Owner.Email});  //mktExpList[0].Vision_Customer__r.Owner.Email,
                //mktExpList[0].Vision_Product__r.Phoenix_Product_Director__r.Email
                //email.setCcAddresses(new List<String>{mktExpList[0].Vision_Panorama_Submitter_Email__c});
                mails.add(email);   
            }
        }   
        Messaging.sendEmail(mails);
        //} //catch (Exception e){
        //String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
        //Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'VisionPanoramaNotificationCls', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'notifyUsers', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
        //insert exp;
        //}
    }
}