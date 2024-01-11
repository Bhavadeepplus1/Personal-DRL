public class PipelineNotificationCls {
    public static void notifyUsers(Integer Records) {
        //Teams_Integration.batchsendMessage('ramyabandari@drreddys.com','Sending messege from Salesforce by User at GMT '+System.now());
        
        //try{
        // Get the Id for our custom notification type
        CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             WHERE DeveloperName='Alert_Notification'];
        Group g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name='Vision Sales Team' and type='Regular' LIMIT 1];
        Set<String> idList = new Set<String>();
        //Declaring to Store Active Users 
        set<String> ActiveUsersIDlist=new Set<String>();
        //urlProductPipeline='';
        String ProductUrl='<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/Product_Pipeline'+ +'">'+ URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/Product_Pipeline'+ +'</a>';
        String sfUrl='<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/Product_Pipeline';
        
        // String url1='<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/Product_Pipeline'+ +'">'Click to view details</a>';
        String urlProductPipeline ='<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/Product_Pipeline'+ +'">Click to view details</a>';
        System.debug('urlProductPipeline'+urlProductPipeline);
        for (GroupMember gm : g.groupMembers) {
            //Teams_Integration.batchsendMessage('ramyabandari@drreddys.com','Sending messege from Salesforce by User at GMT '+System.now());
            System.debug('times');
            //idList.add('0057A000003tZadQAE');
            //idList.add('0051K000009PiwNQAS');
            
            idList.add(gm.userOrGroupId);   
        }
        Set<String> emailAddressList = new Set<String>();
        List<String> userNameList = new List<String>();
        String y='';
        String panorama='';
        panorama+='<b>Product Pipeline</b><br><br>';
        panorama+='There is an update available.<br><br>';
        //panorama+=sfUrl;
        
        string pipelineContent='';
        pipelineContent += '<b>Product Pipeline</b><br><br>';
        String bodyValue='There is an update available';
                            //pipelineContent+=bodyValue+'<br> <a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/Product_Pipeline''">Click to view Details</a>';

                            pipelineContent+=bodyValue+'<br><a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/Product_Pipeline'+ +'">Click to view Details.</a>';

        
                            //pipelineContent+=bodyValue+'<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/Product_Pipeline>Click to view Details</a>';

        //pipelineContent+='There is an update available.<br><br>';
                           // pipelineContent+='There is an update available.<br>''<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/Product_Pipeline>Click to view Details</a>';

       // pipelineContent+=urlProductPipeline;
                            pipelineContent = pipelineContent.replaceAll('"','\'');

        for(User u : [SELECT Name,email,id FROM user  WHERE IsActive = true and id IN :idList]) {
            emailAddressList.add(u.email);
            ActiveUsersIDlist.add(u.id);
            
            //emailAddressList.add('pradeep@dhruvsoft.com');
            //Teams_Integration.triggersendMessage(u.email,body);
                        //Teams_Integration.batchsendMessage(u.email,pipelineContent);

            
           // Teams_Integration.batchsendMessage('surenderpatel@drreddys.com',pipelineContent);
             //Teams_Integration.batchsendMessage('ramyabandari@drreddys.com',pipelineContent);

            
            //emailAddressList.add('ramyabandari@drreddys.com');
            //emailAddressList.add('pradeep@dhruvsoft.com');
            //emailAddressList.add('ramuchiluka@drreddys.com');
            
            
            userNameList.add(u.Name);
            
        }
        System.debug('idList>>>'+idList);
        System.debug('emailAddressList>>>'+emailAddressList);
        
        //String pgRef = '{type: "standard__namedPage",attributes: {pageName: "home"}}';
        String pgRef = '{type: "standard__navItemPage",attributes: {apiName: "Product_Pipeline"}}';
        
        System.debug('pgRef>>>'+pgRef);
        set<string> groupIds=new  set<string>();
        
        set<string> recipientsIds =ActiveUsersIDlist;
        
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        // Set the contents for the notification
        string bodyContent = '';
        notification.setTitle('Product Pipeline');
        
        bodyContent = 'There is an update available.Click to view details  '; 
        notification.setBody(bodyContent);
        // Set the notification type and target
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetPageRef(pgRef);
        // Send the notification
        try {
            notification.send(recipientsIds);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'PipelineNotificationCls', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        } 
        
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Product_Pipeline__c  productPipeline=[Select Id from Product_Pipeline__c limit 1];
        Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Product_Pipeline', productPipeline.Id);
        String templateBody = emailWrapper.mailHtmlBody;
        String subject = emailWrapper.mailSubject;
        //String subject = 'Product Pipeline';
        //String header = '<div style="width: 692px;max-width: 692px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #3f2585; text-align: left; color: white; font-size: 20px;">Product Pipeline</div>';
        //header= '<div style="width: 692px;max-width: 692px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #6900EF; text-align: left; color: white; font-size: 20px;">Opportunities with No Bids<img src="https://drreddysnag--doh--c.documentforce.com/servlet/servlet.ImageServer?id=0152h000000FOOz&oid=00D2h0000000O9g&lastMod=1647864446000" width="60" height="25" align="right" style="padding-right:15px;padding-bottom:7px;padding-top:1px;"alt="Logo"</img></div><br/><br/>';
        
        // String homeUrl=URL.getSalesforceBaseUrl().toExternalForm();
        //https://drreddysnag--visiondev--c.documentforce.com/servlet/servlet.ImageServer?id=01501000000Hpvr&oid=00D010000008q6f&lastMod=1647927437000
        //	CS194
        String instanceName=[Select InstanceName FROM Organization limit 1].InstanceName;
        //String subject = emailWrapper.mailSubject;
        list<Document> lstDocument = [SELECT Id FROM Document WHERE DeveloperName = 'Vision_Logo'];
        String strOrgId = UserInfo.getOrganizationId();
        
        String strLogoUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + 
            '/servlet/servlet.ImageServer?id='+lstDocument[0].Id +
            '&oid=' + strOrgId;
        System.debug('strLogoUrl>>>'+strLogoUrl);
        //String header= '<div style="width: 591px;max-width: 591px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #6900EF; text-align: left; color: white; font-size: 20px;">Product Pipeline<img src="https://CS194.salesforce.com/servlet/servlet.ImageServer?id=01501000000Hpvr&oid=00D010000008q6f&lastMod=1647927437000" width="60" height="25" align="right" style="padding-right:15px;padding-bottom:7px;padding-top:1px;"alt="Logo"</img></div><br/><br/>';
        
        //String header= '<div style="width: 591px;max-width: 591px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #6900EF; text-align: left; color: white; font-size: 20px;">Product Pipeline</div><br/><br/>';
        String header= '<div style="width: 591px;max-width: 591px; font-weight: bold; padding: 12px 0px 12px 8px; background-color: #6900EF; text-align: left; color: white; font-size: 20px;">Product Pipeline<img src="'+strLogoUrl+'" width="60" height="25" align="right" style="padding-right:15px;padding-bottom:7px;padding-top:1px;"alt="Logo"</img></div><br/><br/>';
        
        System.debug('instanceName>>>>'+instanceName);
        //String url='<a href="URL.getSalesforceBaseUrl().toExternalForm()">More Details</a>';
        // ='<a href="+ URL.getSalesforceBaseUrl().toExternalForm()+"';
        System.debug('url>>'+ProductUrl);
        String recordValue=String.valueof(Records);
        templateBody = templateBody.replace('RECORDS', recordValue).replace('HEADER', header).replace('URL',ProductUrl);
        for (String user:userNameList){
            templateBody = templateBody.replace('USERNAME',user); 
            
        }
        email.setHtmlBody(templateBody);
        email.setSubject(subject);
        //email.setToAddresses(emailAddressList);
        email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
        email.setToAddresses(new List < String > (emailAddressList));//key
        
        //email.setToAddresses(new List<String>{'bramya@dhruvsoft.com'});//key
        mails.add(email);
        if(mails.size()>0){
            system.debug('mail>>>');
            //try {
            Messaging.sendEmail(mails);
            //}
            /*catch (Exception e) {
System.debug('Problem sending notification: ' + e.getMessage());
Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'PipelineNotificationCls', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
insert exp;
}*/ 
        }
        //}
        /*catch (Exception e) {
System.debug('Problem sending notification: ' + e.getMessage());
Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'PipelineNotificationCls', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
insert exp;
}*/
    }
}