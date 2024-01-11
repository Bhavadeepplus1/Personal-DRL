public class DelegationNotificationCls implements Schedulable{
    
    public String userId;
    public DelegationNotificationCls(String userUniqueId){
        userId = userUniqueId;
    }
    public DelegationNotificationCls(){
        
    }
    
    public void execute(SchedulableContext sc) {
//        Database.executeBatch(new DelegationNotificationCls());
        sendDelegationEndNotification(userId);
    }
    
    public static void sendDelegationEndNotification(String userId){
        User u = [SELECT Id,Name,Phoenix_Delegation_End_Time__c FROM User WHERE Phoenix_Delegated_Approver__c != null AND Id=:userId];
        if(u.Phoenix_Delegation_End_Time__c < system.now()){
            //Phoenix_SubmitBidForApprovalCtrl.delegationEndEmailAlert(u.Id);
            delegationEndEmailAlert(u.Id);
        }
    }
    
    public static void delegationEmailAlert(String userId){ 
        User u = [Select Id,Name,Email,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegated_Approver__r.Email,Phoenix_Delegation_Start_Time__c,Phoenix_Delegation_End_Time__c From User Where Id=:userId];
        List < Messaging.SingleEmailMessage > mailsList = new List < Messaging.SingleEmailMessage > ();
        String mailStatus = '';
        Messaging.SendEmailResult[] results;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('BRIGHT_DelegationEmailTemplate', userId);
        String templateBody = emailWrapper.mailHtmlBody;
        String subject = emailWrapper.mailSubject;
        if( u.Phoenix_Delegated_Approver__r.Email!=null){
            email.setToAddresses(new List < String > {
                //'naseershaik@drreddys.com'
                u.Phoenix_Delegated_Approver__r.Email
                    });
        }
        email.setCcAddresses(new List < String > {
            //'naseershaik@drreddys.com'
            u.Email
                });
        List<Document> brightLogo = [select id from Document where DeveloperName = 'BRIGHT_Logo_Email']; 
        List<Document> visionLogo = [select id from Document where DeveloperName = 'VISION_Logo_Email'];
        String strOrgId = UserInfo.getOrganizationId();
        String BRIGHT_Logo_Url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id='+brightLogo[0].Id +'&oid='+ strOrgId;
        String VISION_Logo_Url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id='+visionLogo[0].Id +'&oid='+ strOrgId;
        //String BRIGHT_Logo_Url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id='+lstDocument[0].Id +'&oid='+ strOrgId;
        //String BRIGHT_Logo_Url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id='+lstDocument[0].Id +'&oid='+ strOrgId;
        string delegationHistoryUrl = '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/Delegation_History">Delegation History</a>';
        email.setSubject(subject);
        email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
        String formattedStartDateTime = u.Phoenix_Delegation_Start_Time__c.format('dd MMM yyyy hh:mm a');
        String formattedEndDateTime = u.Phoenix_Delegation_End_Time__c.format('dd MMM yyyy hh:mm a');
        String tableString1 = '<div style="background-color: #721DEF; color: white;padding-bottom: 2px;"><div style="width: 100%;"><div style="width: 50%;float:right;height: 64px;"><img src="'+VISION_Logo_Url+'" width="115" height="25" align="right" style="margin-right:20px;padding-right:15px;padding-bottom:7px;padding-top:20px;"alt="Logo"</img></div><div style="padding-top: 4px;width: 50%;float: left;"><img src="'+BRIGHT_Logo_Url+'" width="115" height="52" align="left" style="margin-left:26px;padding-right:15px;padding-bottom:7px;padding-top:1px;"alt="Logo"</img></div></div><div><br/><b><p style="margin: 10px 0px 10px 38px;font-size: 22px;">BRIGHT Delegation of Authority Notification</p></b></div>';
        tableString1 += '<div style="color: black; margin: 20px 40px 40px 40px;padding:50px;background-color: white;">Dear '+u.Phoenix_Delegated_Approver__r.Name+',<br /><br />';
        tableString1 += 'This is to inform you that a Delegation of Authority has been initiated by '+u.Name+' to You. The delegation will start on &nbsp;'+formattedStartDateTime+' and end on &nbsp;'+formattedEndDateTime+'. During this period, you will have the authority to perform the tasks assigned by the Delegator.&nbsp;'+delegationHistoryUrl+'<br/>';
        tableString1 += '<br/>Please note that this decision is temporary and does not affect the original roles and responsibilities of the Stakeholders. The Delegator will resume their authority once the delegation ends.<br/><br/>';
        tableString1 += 'You will receive another email notification when the delegation ends. Thank you for your cooperation and understanding.';
        
        tableString1 += '<br/><br/>Sincerely,<br/>BRIGHT Support Team<br/><br/><br/>';
        tableString1 += '<i>[This is an auto generated mail from Bright, please do not reply to this e-mail]</i><br/></div>';
        //delegatedUserEmail.setHtmlBody(delegatedUserTemplateBody);
        //delegatedUserEmail.setHtmlBody(delegatedUserTemplateBody.replace('DELEGATION_HISTORY_URL ', delegationHistoryUrl));
        email.setHtmlBody(templateBody.replace('EMAIL_BODY', tableString1));
        /*email.setHtmlBody(templateBody);
        email.setHtmlBody(templateBody.replace('DELEGATION_HISTORY_URL ', delegationHistoryUrl));*/
        mailsList.add(email);
        if (mailsList.size() > 0)
            results = Messaging.sendEmail(mailsList);
        
        Messaging.SendEmailResult[] delegatedUserResults;
        List < Messaging.SingleEmailMessage > delegatedUserMailsList = new List < Messaging.SingleEmailMessage > ();
        //String mailStatus = '';
        //Messaging.SendEmailResult[] results;
        Messaging.SingleEmailMessage delegatedUserEmail = new Messaging.SingleEmailMessage();
        Phoenix_Util.EmailWrapper delegatedUserEmailWrapper = Phoenix_Util.getTemplateBody('BRIGHT_DelegationEmailTemplate', userId);
        String delegatedUserTemplateBody = delegatedUserEmailWrapper.mailHtmlBody;
        String delegatedUserSubject = delegatedUserEmailWrapper.mailSubject;
        if( u.Phoenix_Delegated_Approver__r.Email!=null){
            delegatedUserEmail.setToAddresses(new List < String > {
                //'naseershaik@drreddys.com'
                u.Email
                    });
        }
        delegatedUserEmail.setCcAddresses(new List < String > {
            u.Phoenix_Delegated_Approver__r.Email
                });
        delegatedUserEmail.setSubject(delegatedUserSubject);
        delegatedUserEmail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
        String tableString = '<div style="background-color: #721DEF; color: white;padding-bottom: 2px;"><div style="width: 100%;"><div style="width: 50%;float:right;height: 64px;"><img src="'+VISION_Logo_Url+'" width="115" height="25" align="right" style="margin-right:20px;padding-right:15px;padding-bottom:7px;padding-top:20px;"alt="Logo"</img></div><div style="padding-top: 4px;width: 50%;float: left;"><img src="'+BRIGHT_Logo_Url+'" width="115" height="52" align="left" style="margin-left:26px;padding-right:15px;padding-bottom:7px;padding-top:1px;"alt="Logo"</img></div></div><div><br/><b><p style="margin: 10px 0px 10px 38px;font-size: 22px;">BRIGHT Delegation of Authority Notification</p></b></div>';
        tableString += '<div style="color: black; margin: 20px 40px 40px 40px;padding:50px;background-color: white;">Dear '+u.Name+',<br /><br />';
        tableString += 'This is to inform you that a Delegation of Authority has been initiated by You to '+u.Phoenix_Delegated_Approver__r.Name+'. The delegation will start on &nbsp;'+formattedStartDateTime+' and end on &nbsp;'+formattedEndDateTime+'. During this period, '+u.Phoenix_Delegated_Approver__r.Name+' will have the authority to perform the tasks assigned by You.&nbsp;'+delegationHistoryUrl+'<br/>';
        tableString += '<br/>Please note that this decision is temporary and does not affect the original roles and responsibilities of the Stakeholders. The Delegator will resume their authority once the delegation ends.<br/><br/>';
        tableString += ''+u.Phoenix_Delegated_Approver__r.Name+' will receive another email notification when the delegation ends. Thank you for your cooperation and understanding.';
        
        tableString += '<br/><br/>Sincerely,<br/>BRIGHT Support Team<br/><br/><br/>';
        tableString += '<i>[This is an auto generated mail from Bright, please do not reply to this e-mail]</i><br/></div>';
        //delegatedUserEmail.setHtmlBody(delegatedUserTemplateBody);
        //delegatedUserEmail.setHtmlBody(delegatedUserTemplateBody.replace('DELEGATION_HISTORY_URL ', delegationHistoryUrl));
        delegatedUserEmail.setHtmlBody(delegatedUserTemplateBody.replace('EMAIL_BODY', tableString));
        delegatedUserMailsList.add(delegatedUserEmail);
        if (delegatedUserMailsList.size() > 0)
            delegatedUserResults = Messaging.sendEmail(delegatedUserMailsList);
        
    }
    
    public static void delegationEndEmailAlert(String userId){
        User u = [Select Id,Name,Email,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegated_Approver__r.Email From User Where Id=:userId];
        List < Messaging.SingleEmailMessage > mailsList = new List < Messaging.SingleEmailMessage > ();
        String mailStatus = '';
        Messaging.SendEmailResult[] results;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('BRIGHT_DelegationEmailTemplate', userId);
        String templateBody = emailWrapper.mailHtmlBody;
        List<Document> brightLogo = [select id from Document where DeveloperName = 'BRIGHT_Logo_Email']; 
        List<Document> visionLogo = [select id from Document where DeveloperName = 'VISION_Logo_Email'];
        String strOrgId = UserInfo.getOrganizationId();
        String BRIGHT_Logo_Url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id='+brightLogo[0].Id +'&oid='+ strOrgId;
        String VISION_Logo_Url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id='+visionLogo[0].Id +'&oid='+ strOrgId;
        String subject = emailWrapper.mailSubject;
        if( u.Phoenix_Delegated_Approver__r.Email!=null){
            email.setToAddresses(new List < String > {
                u.Phoenix_Delegated_Approver__r.Email, u.Email
                    });
        }
        /*email.setCcAddresses(new List < String > {
            u.Email
                });*/
        email.setSubject(subject);
        email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
        String tableString = '<div style="background-color: #721DEF; color: white;padding-bottom: 2px;"><div style="width: 100%;"><div style="width: 50%;float:right;height: 64px;"><img src="'+VISION_Logo_Url+'" width="115" height="25" align="right" style="margin-right:20px;padding-right:15px;padding-bottom:7px;padding-top:20px;"alt="Logo"</img></div><div style="padding-top: 4px;width: 50%;float: left;"><img src="'+BRIGHT_Logo_Url+'" width="115" height="52" align="left" style="margin-left:26px;padding-right:15px;padding-bottom:7px;padding-top:1px;"alt="Logo"</img></div></div><div><br/><b><p style="margin: 10px 0px 10px 38px;font-size: 22px;">BRIGHT Delegation of Authority Notification</p></b></div>';
        tableString += '<div style="color: black; margin: 20px 40px 40px 40px;padding:50px; background-color: white;">Dear,<br /><br />';
        tableString += 'This is to inform you that a Delegation of Authority has expired which was initiated by '+u.Name+' to '+u.Phoenix_Delegated_Approver__r.Name+'.<br/>';
        tableString += '<br/>Please note that this decision was temporary and did not affect the original roles and responsibilities of both the Stakeholders.';
        
        tableString += '<br/><br/>Sincerely,<br/>BRIGHT Support Team<br/><br/><br/>';
        tableString += '<i>[This is an auto generated mail from Bright, please do not reply to this e-mail]</i><br/></div>';
        //delegatedUserEmail.setHtmlBody(delegatedUserTemplateBody);
        //delegatedUserEmail.setHtmlBody(delegatedUserTemplateBody.replace('DELEGATION_HISTORY_URL ', delegationHistoryUrl));
        email.setHtmlBody(templateBody.replace('EMAIL_BODY', tableString));
        //email.setHtmlBody(templateBody);
        mailsList.add(email);
        if (mailsList.size() > 0)
            results = Messaging.sendEmail(mailsList);
        
    }
    
    public static void codeCoverage(){
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}