public class VisionPanoramaNotificationCls {
    public static void notifyUsers(Map<String, Map<String, List<Vision_Market_Share_Expansion__c>>> mapOfMktExp) {
        // Get the Id for our custom notification type
        CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             WHERE DeveloperName='Custom_Email_Notification'];
        String pgRef = '{type: "standard__namedPage",attributes: {pageName: "home"}}';
        
        //Map<CustomerId, Map<Family, List<MktExp>>>
        try{
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Vision_Market_Share_Expansion__c expRec = [SELECT Id FROM Vision_Market_Share_Expansion__c LIMIT 1];
            Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Market_Share_Expansion_Email', expRec.Id);
            for(String customerId: mapOfMktExp.keySet()){
                for(String family: mapOfMktExp.get(customerId).keySet()){
                    List<Vision_Market_Share_Expansion__c> mktExpList = mapOfMktExp.get(customerId).get(family);
                    //set<string> recipientsIds =new set<string>{'0057c000007DPNUAA4'}; //Replace with Customer Id
                    set<string> recipientsIds =new set<string>{customerId}; //Replace with Customer Id
                        
                        Messaging.CustomNotification notification = new Messaging.CustomNotification();
                    // Set the contents for the notification
                    string bodyContent = 'A new task has been created for '+family;
                    notification.setBody(bodyContent);
                    notification.setTitle('New Panorama Task');
                    // Set the notification type and target
                    notification.setNotificationTypeId(notificationType.Id);
                    notification.setTargetPageRef(pgRef);
                    // Send the notification
                    try {
                        system.debug('notification');
                        //notification.send(recipientsIds);
                    }
                    catch (Exception e) {
                        System.debug('Problem sending notification: ' + e.getMessage());
                    }
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    
                    // String templateBody = emailWrapper.mailHtmlBody;
                    //String subject = emailWrapper.mailSubject;
                    String subject = 'New Task has been created - '+mktExpList[0].Move_Ident__c;
                    String tableData = '';
                    String customer = '';
                    
                    DateTime dt;
                    String myDate;
                    if(mktExpList[0].Plan_Contract_Effective_Date__c != null)
                        dt = mktExpList[0].Plan_Contract_Effective_Date__c;
                    if(dt != null)
                        myDate = dt.format('MM/dd/yyyy');
                    if(mktExpList[0].Plan_Contract_Effective_Date__c != null){
                        customer = 'Target Date: '+myDate+'<br/><br/><b>'+mktExpList[0].Vision_Customer__r.Name+'</b>';   
                    } else{
                        customer = '<b>'+mktExpList[0].Vision_Customer__r.Name+'</b>';   
                    }
                    String title='Panorama Task';
                    String sub = 'New Panorama Task for You in VISION';
                    DateTime internalTargetDate; String taskComment = ''; String createdDate = ''; String ownerName = '';
                    if (mktExpList[0].Vision_Internal_Target_Date__c != null) 
                        internalTargetDate = DateTime.newInstance(mktExpList[0].Vision_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0)); 
                    
                    if(mktExpList[0].Task_Comment__c != null && mktExpList[0].Task_Comment__c != '') {
                        taskComment = mktExpList[0].Task_Comment__c.replaceAll('<p>', '').replaceAll('</p>', '');
                    }
                    String baseLineVolume = mktExpList[0].Baseline_Volume__c != null ? String.valueOf(mktExpList[0].Baseline_Volume__c.format()) : '';
                    String directVolume = mktExpList[0].Target_Volume__c != null ? String.valueOf(mktExpList[0].Target_Volume__c.format()) : '';

                    String content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 0px 8px;">Dear '+mktExpList[0].Vision_Customer__r.Owner.Name+',</td></tr></table>';
                    content += '<table><tr><td style="width: 24px;"></td><td style="padding: 4px 8px 8px 8px;"><span style="font-size: 14px;font-family: Sans-Serif">We want to inform you that we have received a new Panorama task for a share expansion move.</td></tr></table>';
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:0px 8px 8px 8px;"><b>Share Expansion Details:</b></td></tr></table>';
                    
                    content += '<table style="min-width: 50%;border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 50%;">';   //first table start                         
                    content += '<table style="width: 100%;border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer</th><td style="border: 1px solid black;text-align: left;padding: 8px;">'+mktExpList[0].Vision_Customer__r.Name+'</a></td></tr>';
                    content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Product Family</th><td style="border: 1px solid black;padding: 8px;">'+mktExpList[0].Vision_Product_Family__c+'</td></tr>';
                    content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Product Director</th><td style="border: 1px solid black;padding: 8px;">'+mktExpList[0].Vision_Product__r.Phoenix_Product_Director__r.Name+'</td></tr>';
                    content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Target Date</th>';
                    if(internalTargetDate != null) content += '<td style="border: 1px solid black;padding: 8px;">'+internalTargetDate.format('MMM d yyyy')+'</td></tr>';
                    else content += '<td style="border: 1px solid black;padding: 8px;"></td></tr>';
                    content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;padding: 8px;">NDC</th><td style="border: 1px solid black;padding: 8px;">'+mktExpList[0].Vision_Product__r.Phoenix_NDC_11__c+'</td></tr>';
                    content += '</thead></table></td>';//first table end
                    content += '<td style="width: 50%;">'; //second table start                           
                    content += '<table style="width: 100%;border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Baseline Volume</th><td style="border: 1px solid black;text-align: left;padding: 8px;">'+baseLineVolume+'</a></td></tr>';
                    content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Baseline Dollar</th><td style="border: 1px solid black;padding: 8px;">'+AllEmailNotificationsSenderCls.getCurrencyFormatted(mktExpList[0].Baseline_Dollar__c)+'</td></tr>';
                    content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Target Volume</th><td style="border: 1px solid black;padding: 8px;">'+mktExpList[0].Target_Volume__c+'</td></tr>';
                    content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Target Dollar</th><td style="border: 1px solid black;padding: 8px;">'+AllEmailNotificationsSenderCls.getCurrencyFormatted(mktExpList[0].Target_Dollar__c)+'</td></tr>';
                    content += '<tr><th style="width: 34px;"></th><th style="padding:8px;text-align:left;">&nbsp;</th><td style="padding: 8px;">&nbsp;</td></tr>';
                    content += '</thead></table></td>';//second table end
                    content += '</tr></table>';//total end
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;"><b>Task Comments:</b></td></tr></table>';
                    
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+mktExpList[0].Vision_Product__r.Phoenix_Product_Director__r.Name+': ';
                    if(taskComment != null)	content += taskComment+'</td></tr></table>';
                    else content += '</td></tr></table>';
                    //content = '<div style="color: black; margin: 20px 0px -10px 0px;padding:50px 40px 10px 40px;background-color: white;">Dear '+mktExpList[0].Vision_Customer__r.Owner.Name+',<br /><br />';
                    //content += 'We want to inform you that we have received a new Panorama task for a share expansion move.<br/><br/>';
                    //content += '<b>Share Expansion Details:</b></br><br/>';
                    /*content += '<table ><tr valign="top" ><td style="padding-right:100px;"><div><table style=" border: 1px solid black;border-collapse: collapse;"><tr style=" border: 1px solid black;border-collapse: collapse;"><td style=" border: 1px solid black;border-collapse: collapse;background-color:#d4bdf8;font-weight:bold;padding:8px;">Customer</td><td style=" border: 1px solid black;border-collapse: collapse;padding:8px;">'+mktExpList[0].Vision_Customer__r.Name+'</td></tr>';
content += '<tr><td style=" border: 1px solid black;border-collapse: collapse;background-color:#d4bdf8;font-weight:bold;padding:8px;">Product Family</td><td style=" border: 1px solid black;border-collapse: collapse;padding:8px;">'+mktExpList[0].Vision_Product_Family__c+'</td></tr>';
content += '<tr><td style=" border: 1px solid black;border-collapse: collapse;background-color:#d4bdf8;font-weight:bold;padding:8px;">Product Director</td><td style=" border: 1px solid black;border-collapse: collapse;padding:8px;">'+mktExpList[0].Vision_Product__r.Phoenix_Product_Director__r.Name+'</td></tr>';
content += '<tr><td style=" border: 1px solid black;border-collapse: collapse;background-color:#d4bdf8;font-weight:bold;padding:8px;">Target Date</td><td style=" border: 1px solid black;border-collapse: collapse;padding:8px;">'+mktExpList[0].Vision_Internal_Target_Date__c+'</td></tr>';
content += '<tr><td style=" border: 1px solid black;border-collapse: collapse;background-color:#d4bdf8;font-weight:bold;padding:8px;">NDC</td><td style=" border: 1px solid black;border-collapse: collapse;padding:8px;">'+mktExpList[0].Vision_Product__r.Phoenix_NDC_11__c+'</td></tr>';
content += '</table></div></td><td style="padding-left:100px;"><div>'; 
content += '<table style=" border: 1px solid black;border-collapse: collapse;"><tr style=" border: 1px solid black;border-collapse: collapse;"><td style=" border: 1px solid black;border-collapse: collapse;background-color:#d4bdf8;font-weight:bold;padding:8px;">Baseline Volume</td><td style=" border: 1px solid black;border-collapse: collapse;padding:8px;">'+mktExpList[0].Baseline_Volume__c+'</td></tr>';
content += '<tr><td style=" border: 1px solid black;border-collapse: collapse;background-color:#d4bdf8;font-weight:bold;padding:8px;">Baseline Dollar</td><td style=" border: 1px solid black;border-collapse: collapse;padding:8px;">'+mktExpList[0].Baseline_Dollar__c+'</td></tr>';
content += '<tr><td style=" border: 1px solid black;border-collapse: collapse;background-color:#d4bdf8;font-weight:bold;padding:8px;">Target Volume</td><td style=" border: 1px solid black;border-collapse: collapse;padding:8px;">'+mktExpList[0].Target_Volume__c+'</td></tr>';
content += '<tr><td style=" border: 1px solid black;border-collapse: collapse;background-color:#d4bdf8;font-weight:bold;padding:8px;">Target Dollar</td><td style=" border: 1px solid black;border-collapse: collapse;padding:8px;">'+mktExpList[0].Target_Dollar__c+'</td></tr>';
content += '<tr></tr></table></div></td></tr></table><br/>';*/
                    
                    
                    
                    /*    content += '<table style="border-collapse: collapse;width:50%"><thead><tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer</th><td style="border: 1px solid black;padding: 8px;">'+customer+'</td></tr><tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Product Family</th><td style="border: 1px solid black;padding: 8px;">'+mktExpList[0].Vision_Product_Family__c+'</td></tr>';
content += '<tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Product Director</th><td style="border: 1px solid black;padding: 8px;">'+mktExpList[0].Vision_Product__r.Phoenix_Product_Director__r.Name+'</td></tr><tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Target Date</th><td style="border: 1px solid black;padding: 8px;">'+mktExpList[0].Vision_Internal_Target_Date__c+'</td></tr>';
content += '<tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">NDC</th><td style="border: 1px solid black;padding: 8px;">'+mktExpList[0].Vision_Product__r.Phoenix_NDC_11__c+'</td></tr><tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Baseline Volume</th><td style="border: 1px solid black;padding: 8px;">'+mktExpList[0].Baseline_Volume__c+'</td></tr>';
content += '<tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Baseline Dollar</th><td style="border: 1px solid black;padding: 8px;">'+mktExpList[0].Baseline_Dollar__c+'</td></tr><tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Target Volume</th><td style="border: 1px solid black;padding: 8px;">'+mktExpList[0].Target_Volume__c+'</td></tr>';
content += '<tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Target Dollar</th><td style="border: 1px solid black;padding: 8px;">'+mktExpList[0].Target_Dollar__c+'</td></tr>';
content += '</thead></table><br/>';*/
                    /*content += '<b>Task Comments:</b></br><br/>';
content += mktExpList[0].Vision_Product__r.Phoenix_Product_Director__r.Name+': '+mktExpList[0].Task_Comment__c+'</br><br/><br/>';*/
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;">To create an opportunity or reject the Panorama Task, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+mktExpList[0].Id+'">'+mktExpList[0].Name+'</a>.</b></td></tr></table>';
                    //content += 'To create an opportunity or reject the Panorama Task, refer to this link <a href="'+System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+mktExpList[0].Id+'">'+mktExpList[0].Name+'</a>.<br/><br/>'; 
                    
                    //added by satya//
                    List<String> sendTo = new List<String>();
                    if(mktExpList[0].Vision_Customer__r.Owner.Email != null){
                        sendTo.add(mktExpList[0].Vision_Customer__r.Owner.Email);
                    }
                    if(mktExpList[0].Vision_Product__r.Phoenix_Product_Director__r.Email != null){
                        sendTo.add(mktExpList[0].Vision_Product__r.Phoenix_Product_Director__r.Email);
                    }
                    email.setToAddresses(sendTo);
                    //end by satya//
                    List<String>ccaddress= new List<String>();
                    sendEmailAlert(customerId, content,sendTo,sendTo,sub,title);
                    
                    /*   String header = '<div style="width: 692px;max-width: 692px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #3f2585; text-align: left; color: white; font-size: 20px;">PANORAMA TASK</div>';
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

//email.setCcAddresses(new List<String>{mktExpList[0].Vision_Panorama_Submitter_Email__c});
mails.add(email);     */
                }
            }   
            Messaging.sendEmail(mails);
        } catch (Exception e){
            String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'VisionPanoramaNotificationCls', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'notifyUsers', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
    public static void sendEmailAlert(String bidId, String content2, list<String> toAddress, list<string> ccaddress, String subject, String title){
        String content1 = '';
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        list < messaging.Email > mailsList = new list < messaging.email > ();
        Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Panorama_Task_Email_Template', bidId);
        String templateBody = emailWrapper.mailHtmlBody;
        String header ='';
        content1 += header;
        content1 += content2;
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:4px 8px 0px 8px;">Best Regards,</td></tr>';
        content1 += '<tr><td style="width: 24px;"></td><td style="padding: 0px 8px;">BRIGHT Support Team.</td></tr>';
        content1 += '<tr><td style="width: 24px;"></td><td style="padding: 12px 8px;"><i>[This is an auto-generated mail from BRIGHT, please do not reply to this email]</i></td></tr>';
        content1 += '</table>';
            String objName = String.valueOf(Id.valueOf(bidId).getsObjectType());
        email.setToAddresses(toAddress); //replace with toaddress after testing
        email.setCcAddresses(ccaddress); //uncomment this after testing
        templateBody = templateBody.replace('LOGO_BODY', content1);
        templateBody = templateBody.replace('TITLE_TEXT', title);
        email.setHtmlBody(templateBody);
        email.setSubject(subject);
        email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
        
        mailsList.add(email);
        messaging.sendEmail(mailsList);
    }
}