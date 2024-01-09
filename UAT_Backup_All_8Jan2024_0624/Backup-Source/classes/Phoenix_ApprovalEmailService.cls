/**
* @description       : 
* @author            : Surender Dhruvsoft
* @group             : 
* @last modified on  : 03-23-2022
* @last modified by  : Surender Patel
* Modifications Log 
* Ver   Date         Author               Modification
* 1.0   25-05-2021   Surender Dhruvsoft   Initial Version
**/
public class Phoenix_ApprovalEmailService implements Messaging.InboundEmailHandler {
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        boolean isMarketingRxLead = false; 
        boolean isMarketingSRxLead = false; 
        boolean isMarketingOTCLead = false;
        boolean isMarketingHead = false;
        boolean isVPFinanceHead = false; 
        boolean isBusinessHead = false;
        string approvalAction = 'None';
        String emailText = '';
        String comment = '';
        String fromAddress = email.fromAddress;
        system.debug('fromAddress====='+fromAddress);
        emailText = emailText + '/' +fromAddress;
        String subject = email.subject;
        system.debug('subject====='+subject);
        emailText = emailText + '' +subject;
        String body = email.plainTextBody;
        system.debug('body=== '+body);
        if (body.contains('Comments:')) {
    // Get the substring after the search string
     comment = body.substringAfter('Comments:');
    
    // Output the result
    System.debug(comment);
} 
        emailText = emailText + '/' +body;
        String htmlBody = email.htmlBody;
        String[] sub = subject.split(' ');
        system.debug('sub====='+sub);
        emailText = emailText + '/' +sub;
        Id bidId;
        Id wacId;
        Id targetId;
        Id tAId;
        string bidNumber;
        string wacNumber;
        string targetNumber;
        string tANumber;
        Boolean IsconditionMet;
        
        List<Phoenix_Approval_Grid__c> approvalGrids = new List<Phoenix_Approval_Grid__c>();
        List<Phoenix_Bid_Process_Steps__c> bidProcessStepsList = new List<Phoenix_Bid_Process_Steps__c>();
        List<Phoenix_Bid_Line_Item__c > bidLineItemsList = new List<Phoenix_Bid_Line_Item__c >();
        for (String str: sub) {
            system.debug('str====='+str);
            if (str.startsWith('Bid')) {
                bidNumber = str;
                break;
            }
            if (str.startsWith('Target-')) {
                targetNumber = str;
                break;
            }
            if (str.startsWith('TA-')) {
                tANumber = str;
                break;
            }
            if (str.startsWith('WAC')) {
                wacNumber = str;
                //  break;
            }
            else if (str.startsWith('Price')) {
                wacNumber = wacNumber +' '+str ;
                //  break;
            }
           else if (str.isAlphanumeric()){
                wacNumber = wacNumber +' - '+str ;
                //  break;
            }
        }
         system.debug('comment====='+comment);
        system.debug('targetNumber====='+targetNumber);
        if(bidNumber != null){
            wacNumber = null;  
        }
        if(targetNumber != null){
             wacNumber = null; 
             bidNumber = null; 
            tANumber = null;
        }
        if(tANumber != null){
             wacNumber = null; 
             bidNumber = null; 
            targetNumber = null;
        }
        system.debug('wacNumber====='+wacNumber);
        emailText = emailText + '/' +wacNumber;
        String approvalComments = 'System Comment: Approved from email';
        String rejectionComments = 'System Comment: Rejected from email';
        
        
        
        /*     if (body.contains('/')){
approvalComments = body.substringAfter('/').substringBefore('.');
rejectionComments = body.substringAfter('/').substringBefore('.');
}
else  If(body.contains('-')){
approvalComments = body.substringAfter('-');
rejectionComments = body.substringAfter('-');

}
else if (body.contains(':')){
approvalComments = body.substringAfter(':');
rejectionComments = body.substringAfter(':');
}
else if (body.contains(',')){
approvalComments = body.substringAfter(',');
rejectionComments = body.substringAfter(',');
}

//system.debug('approvalComments--'+approvalComments);
//system.debug('rejectionComments--'+rejectionComments);

*/        
        //system.debug(bidNumber);
        system.debug(fromAddress);
        emailText = emailText + '/' +fromAddress;
        //system.debug(Subject);
        //system.debug(Body);
        if(body.startsWithIgnoreCase('APPROVE') || body.startsWithIgnoreCase('APPROVED') || body.startsWithIgnoreCase('YES') )
            approvalAction = 'Approved';
        if(body.startsWithIgnoreCase('REJECT') || body.startsWithIgnoreCase('REJECTED') || body.startsWithIgnoreCase('NO') )
            approvalAction = 'Rejected';
        
        User currentUser;
        currentUser = [Select Id, Name FROM User WHERE Email =:fromAddress limit 1];
        //system.debug('currentUser====='+currentUser.size());
        system.debug('currentUser====='+currentUser);
        emailText = emailText + '/' +currentUser;
        if(bidNumber != null){
            Phoenix_Bid__c bid = [SELECT Id,Name FROM Phoenix_Bid__c Where Name =: bidNumber limit 1];
            bidId = bid.Id;
            bidLineItemsList = [Select id,Name,Phoenix_Marketing_Lead_SRx__c,Phoenix_Marketing_Lead_Rx__c,Phoenix_Marketing_Lead_OTC__c,Phoenix_Sr_Director_VP_Finance_Approval__c,Phoenix_Is_New_Low_Triggered__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:bidId and Phoenix_Is_New_Low_Triggered__c=true];
            Set<String > userapprovalTeams = new Set<String >();
            for (Phoenix_User_Approval_Matrix__c matrix: 
                 [Select Id, Name, RecordType.DeveloperName, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
                     
                     
                     if (matrix.RecordType.DeveloperName == 'Approval_Users' && matrix.Phoenix_Is_Approval_Process_User__c && matrix.Phoenix_Approver__c ==currentUser.Id) {
                         userapprovalTeams.add(matrix.User_Group__r.Phoenix_Approver_Group_Name__c);
                     }
                 }
            system.debug('userapprovalTeams '+userapprovalTeams);
            
            bidProcessStepsList = Database.query('Select '+ Phoenix_Util.bidProcessStepFields+ ' From Phoenix_Bid_Process_Steps__c Where Phoenix_Bid__c =:bidId and Phoenix_Status__c = \'In Process\'');
            set <String> inProcessStepTeams = new set <String> ();
            for(Phoenix_Bid_Process_Steps__c step :bidProcessStepsList){
                inProcessStepTeams.add(step.Phoenix_Approver_Team__c);   
            }
            set<String> allTeams = new  set<String>();
            
            allTeams.addAll(userapprovalTeams);
            allTeams.addAll(inProcessStepTeams);
            system.debug('allTeams--->'+allTeams);
            
            for ( String team:allTeams){
                if(userapprovalTeams.contains(team) && inProcessStepTeams.contains(team) && team == 'Marketing Lead Rx')  isMarketingRxLead =true;
                else if(userapprovalTeams.contains(team) && inProcessStepTeams.contains(team) && team == 'Marketing Lead SRx')  isMarketingSRxLead =true;
                else if(userapprovalTeams.contains(team) && inProcessStepTeams.contains(team) && team == 'Marketing Lead OTC')  isMarketingOTCLead =true;
                else if(userapprovalTeams.contains(team) && inProcessStepTeams.contains(team) && team == 'Marketing Head')  isMarketingHead =true;
                else if(userapprovalTeams.contains(team) && inProcessStepTeams.contains(team) && team == 'Sr Director or VP Finance')  isVPFinanceHead =true;  
                else if(userapprovalTeams.contains(team) && inProcessStepTeams.contains(team) && team == 'Business Head')  isBusinessHead =true;  
                
            }
            approvalGrids = Database.query('Select' + Phoenix_Util.approvalGridFields + ' From Phoenix_Approval_Grid__c where Phoenix_Bid__c =:bidId');
            
            for(Phoenix_Approval_Grid__c grid : approvalGrids){
                if(approvalAction =='Approved' && isMarketingRxLead == True && grid.Phoenix_isRx__c == True ){
                    grid.Phoenix_Marketing_Lead_Rx__c = 'Approved';grid.Phoenix_Business_Head_Comments__c = approvalComments;
                    
                    //system.debug('grid.Phoenix_Marketing_Lead_Rx__c --->'+grid.Phoenix_Marketing_Lead_Rx__c );
                    //     //system.debug('grid.Phoenix_Business_Head_Comments__c--->'+grid.Phoenix_Business_Head_Comments__c);
                    
                }
                else if(approvalAction =='Approved' && isMarketingSRxLead == True && grid.Phoenix_isSRX__c == True){
                    grid.Phoenix_Marketing_Lead_SRx__c = 'Approved';grid.Phoenix_Business_Head_Comments__c = approvalComments;
                    //system.debug('grid.Phoenix_Marketing_Lead_SRx__c --->'+ grid.Phoenix_Marketing_Lead_SRx__c );
                    //     //system.debug('grid.Phoenix_Business_Head_Comments__c--->'+grid.Phoenix_Business_Head_Comments__c);
                }
                else if(approvalAction =='Approved' && isMarketingOTCLead == True && grid.Phoenix_isOTC__c == True ){
                    grid.Phoenix_Marketing_Lead_OTC__c = 'Approved';grid.Phoenix_Business_Head_Comments__c = approvalComments;
                    //system.debug('grid.Phoenix_Marketing_Lead_OTC__c --->'+ grid.Phoenix_Marketing_Lead_OTC__c );
                    //      //system.debug('grid.Phoenix_Business_Head_Comments__c--->'+ grid.Phoenix_Business_Head_Comments__c);
                }
                else if(approvalAction =='Approved' && isMarketingHead == True && grid.Phoenix_Mkt_Head_Req__c == True){
                    grid.Phoenix_Approval__c = 'Approved';grid.Phoenix_Comments__c = approvalComments;
                    //system.debug(' grid.Phoenix_Approval__c --->'+ grid.Phoenix_Approval__c );
                    //     //system.debug(' grid.Phoenix_Comments__c--->'+ grid.Phoenix_Comments__c);
                }
                else if(approvalAction =='Approved' && isVPFinanceHead == True && grid.Phoenix_VP_Finance_Req__c == True){
                    grid.Phoenix_Sr_Director_VP__c  = 'Approved';grid.Phoenix_Sr_Director_VP_Finance_Comments__c = approvalComments;
                    //system.debug('grid.Phoenix_Sr_Director_VP__c --->'+grid.Phoenix_Sr_Director_VP__c );
                    //   //system.debug('grid.Phoenix_Sr_Director_VP_Finance_Comments__c--->'+grid.Phoenix_Sr_Director_VP_Finance_Comments__c);
                }
                else if(approvalAction =='Approved' && isBusinessHead == True){
                    
                }
                
                else   if(approvalAction =='Rejected' && isMarketingRxLead == True && grid.Phoenix_isRx__c == True ){
                    grid.Phoenix_Marketing_Lead_Rx__c = 'Not Approved';
                    grid.Phoenix_Business_Head_Comments__c = rejectionComments;
                }
                else  if(approvalAction =='Rejected' && isMarketingSRxLead == True && grid.Phoenix_isSRX__c == True){
                    grid.Phoenix_Marketing_Lead_SRx__c = 'Not Approved';
                    grid.Phoenix_Business_Head_Comments__c = rejectionComments;
                }
                else  if(approvalAction =='Rejected' && isMarketingOTCLead == True && grid.Phoenix_isOTC__c == True){
                    grid.Phoenix_Marketing_Lead_OTC__c = 'Not Approved';
                    grid.Phoenix_Business_Head_Comments__c = rejectionComments;
                }
                else  if(approvalAction =='Rejected' && isMarketingHead == True  && grid.Phoenix_Mkt_Head_Req__c == True){
                    grid.Phoenix_Approval__c = 'Not Approved';
                    grid.Phoenix_Comments__c = rejectionComments;
                }
                else  if(approvalAction =='Rejected' && isVPFinanceHead == True  && grid.Phoenix_VP_Finance_Req__c == True){
                    grid.Phoenix_Sr_Director_VP__c  = 'Not Approved';
                    grid.Phoenix_Sr_Director_VP_Finance_Comments__c = rejectionComments;
                }
                else  if(approvalAction =='Rejected' && isBusinessHead == True){}
                
            }
            Attachment attach = new Attachment(parentId = bidId,body=Blob.valueOf(htmlBody),Name='Email Approval of - '+currentUser.Name+'.html');
            Insert attach ;
            
        }
        if(wacNumber != null){
            system.debug('wacNumber in if====='+wacNumber);
            
            //wacNumber = '%'+wacNumber+'%';
            New_Product_WAC_Pricing__c wacPricingRec = [Select Id,Name from New_Product_WAC_Pricing__c where Name =: wacNumber];
            if(wacPricingRec != null) wacId = wacPricingRec.Id;
            System.debug('wacPricingRec-----'+wacPricingRec);
            emailText = emailText + '/' +wacPricingRec;
            List<Phoenix_NewProduct_WAC_Pricing_LineItems__c> wacPricingLineItems = Database.query('Select Phoenix_Product__r.Name, ' + Phoenix_Util.newProductWACPricingLinesFields+ 'FROM Phoenix_NewProduct_WAC_Pricing_LineItems__c where Phoenix_New_Product_WAC_Pricing__c =: wacId');
            System.debug('wacPricingLineItems-----'+wacPricingLineItems.size());
            approvalGrids = Database.query('Select' + Phoenix_Util.approvalGridFields + ' From Phoenix_Approval_Grid__c where Phoenix_New_Product_WAC_Pricing__c =:wacId');
            system.debug('approvalGrids====='+approvalGrids);
            String status = 'In Process';
            bidProcessStepsList = Database.query('Select' + Phoenix_Util.bidProcessStepFields + ' From Phoenix_Bid_Process_Steps__c where Phoenix_New_Product_WAC_Pricing__c =:wacId and Phoenix_Status__c =: status');
            system.debug('bidProcessStepsList====='+bidProcessStepsList);
            system.debug('bidProcessStepsList====='+bidProcessStepsList.size());
            
            if(bidProcessStepsList.size() >0){
                if(approvalAction == 'Approved' && wacNumber != null &&  bidProcessStepsList[0].Phoenix_Approver_Team__c.contains('Marketing Head')){
                    New_Product_WAC_Pricing__c wacRec = Database.query('Select ' + Phoenix_Util.newProductWACPricingFields+ 'FROM New_Product_WAC_Pricing__c WHERE Name =: wacNumber');
                    wacRec.Phoenix_Head_of_PM_Grp_Approval__c = approvalAction;
                    wacRec.Phoenix_Head_of_PM_Grp_Comments__c = approvalComments;
                    update wacRec;
                }
                else if(approvalAction == 'Approved' && wacNumber != null &&  bidProcessStepsList[0].Phoenix_Approver_Team__c.contains('Marketing Lead')){
                    
                    New_Product_WAC_Pricing__c wacRec = Database.query('Select ' + Phoenix_Util.newProductWACPricingFields+ 'FROM New_Product_WAC_Pricing__c WHERE Name =: wacNumber');
                    wacRec.Phoenix_Head_of_Marketing_Approval__c = approvalAction;
                    wacRec.Phoenix_Head_of_Marketing_Comments__c = approvalComments;
                    update wacRec;
                    if((wacRec.Phoenix_TPT__c > 40 || wacRec.Phoenix_GM__c > 25) && wacRec.Phoenix_Net_sales_annualized__c <= 1000000){
                        IsconditionMet = true;
                    }
                    system.debug('IsconditionMet-----'+IsconditionMet);
                }
                else if(approvalAction == 'Rejected' && wacNumber != null &&  bidProcessStepsList[0].Phoenix_Approver_Team__c.contains('Marketing Head')){
                    New_Product_WAC_Pricing__c wacRec = Database.query('Select ' + Phoenix_Util.newProductWACPricingFields+ 'FROM New_Product_WAC_Pricing__c WHERE Name =: wacNumber');
                    wacRec.Phoenix_Head_of_PM_Grp_Approval__c = approvalAction;
                    wacRec.Phoenix_Head_of_PM_Grp_Comments__c = rejectionComments;
                    update wacRec;
                }
                else if(approvalAction == 'Rejected' && wacNumber != null &&  bidProcessStepsList[0].Phoenix_Approver_Team__c.contains('Marketing Lead')){
                    
                    New_Product_WAC_Pricing__c wacRec = Database.query('Select ' + Phoenix_Util.newProductWACPricingFields+ 'FROM New_Product_WAC_Pricing__c WHERE Name =: wacNumber');
                    wacRec.Phoenix_Head_of_Marketing_Approval__c = approvalAction;
                    wacRec.Phoenix_Head_of_Marketing_Comments__c = rejectionComments;
                    update wacRec;
                    if((wacRec.Phoenix_TPT__c > 40 || wacRec.Phoenix_GM__c > 25) && wacRec.Phoenix_Net_sales_annualized__c <= 1000000){
                        IsconditionMet = true;
                    }
                    system.debug('IsconditionMet-----'+IsconditionMet);
                }
            }
            Attachment attach = new Attachment(parentId = wacId,body=Blob.valueOf(htmlBody),Name='Email Approval of - '+currentUser.Name+'.html');
            Insert attach ;
        }
           if(targetNumber != null){
            system.debug('targetNumber in if====='+targetNumber);
            
            SRx_Target__c srxTargetRec = [SELECT Id, Name, Approval_Status__c, Target_Number__c, Marketing_Head_Status__c FROM SRx_Target__c where Target_Number__c =: targetNumber];
            if(srxTargetRec != null) targetId = srxTargetRec.Id;
            System.debug('srxTargetRec-----'+srxTargetRec);
            emailText = emailText + '/' +srxTargetRec;
               if(approvalAction == 'Approved'){
                   String targetString = '------';
                   
                   // Get the text before the target string
                   String textBeforeTarget = comment.substringBefore(targetString);
                   
                   // Display the result
                   System.debug('Text before the target string: ' + textBeforeTarget);
                   Target_Approval_Class.updatestatus(targetId,'Marketing_Head_Status__c','Completed', approvalComments);
               }
               if(approvalAction == 'Rejected'){
                   Target_Approval_Class.updatestatus(targetId,'Marketing_Head_Status__c','Marketing Head Rejected', rejectionComments);  
               }
               Attachment attach = new Attachment(parentId = targetId,body=Blob.valueOf(htmlBody),Name='Email Approval of - '+currentUser.Name+'.html');
               Insert attach ;
           }
        if(tANumber != null){
            system.debug('tANumber in if====='+tANumber);
            
            Target_Achieved_Approval__c TargetRec = [SELECT Id, Name, Approval_Status__c, Target_Number__c, Marketing_Head_Status__c FROM Target_Achieved_Approval__c where Target_Number__c =: tANumber];
            if(TargetRec != null) tAId = TargetRec.Id;
            System.debug('TargetRec-----'+TargetRec);
            emailText = emailText + '/' +TargetRec;
            if(approvalAction == 'Approved'){
                Target_Achieved_Approval_Class.updatestatus(tAId,'Marketing_Head_Status__c','Completed', approvalComments);
            }
            if(approvalAction == 'Rejected'){
                Target_Achieved_Approval_Class.updatestatus(tAId,'Marketing_Head_Status__c','Marketing Head Rejected', rejectionComments);  
            }
            Attachment attach = new Attachment(parentId = tAId,body=Blob.valueOf(htmlBody),Name='Email Approval of - '+currentUser.Name+'.html');
            Insert attach ;
        }
        
        //system.debug('isMarketingRxLead '+isMarketingRxLead);
        //system.debug('isMarketingSRxLead '+isMarketingSRxLead);
        //system.debug('isMarketingOTCLead '+isMarketingOTCLead);
        //system.debug('isMarketingHead '+isMarketingHead);
        //system.debug('isVPFinanceHead '+isVPFinanceHead);
        system.debug('approvalAction=== '+approvalAction);
        
        if (approvalAction == 'None' && bidNumber != null){
            
            List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            Messaging.SendEmailResult[] results;
            Phoenix_Util.EmailWrapper emailWrapper ;
            emailWrapper = Phoenix_Util.getTemplateBody('Bid_Management_Approval_Failure', bidId);
            String templateBody = emailWrapper.mailHtmlBody;
            String mailSubject = emailWrapper.mailSubject;
            if (templateBody.contains('Phoenix_Approver')) templateBody = templateBody.replace('Phoenix_Approver', currentUser.Name);
            mail.setSubject(mailSubject);
            mail.setHtmlBody(templateBody);  
            mail.setToAddresses(new List<String>{fromAddress});
            //  mail.setCcAddresses((new List<String>{'ramakrishnay@drreddys.com'}));
            mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
            mails.add(mail);
            results =  Messaging.sendEmail(mails);      
        }
        if (approvalAction == 'None' && wacNumber != null){
            
            List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            Messaging.SendEmailResult[] results;
            Phoenix_Util.EmailWrapper emailWrapper ;
            emailWrapper = Phoenix_Util.getTemplateBody('New_WAC_Management_Approval_Failure', bidId);
            String templateBody = emailWrapper.mailHtmlBody;
            String mailSubject = emailWrapper.mailSubject;
            if (templateBody.contains('Phoenix_Approver')) templateBody = templateBody.replace('Phoenix_Approver', currentUser.Name);
            mail.setSubject(mailSubject);
            mail.setHtmlBody(templateBody);  
            mail.setToAddresses(new List<String>{fromAddress});
            //  mail.setCcAddresses((new List<String>{'ramakrishnay@drreddys.com'}));
            mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
            mails.add(mail);
            results =  Messaging.sendEmail(mails);      
        }
         if (approvalAction == 'None' && targetNumber != null){
            
            List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            Messaging.SendEmailResult[] results;
            Phoenix_Util.EmailWrapper emailWrapper ;
            emailWrapper = Phoenix_Util.getTemplateBody('Target_Management_Approval_Failure', targetId);
            String templateBody = emailWrapper.mailHtmlBody;
            String mailSubject = emailWrapper.mailSubject;
            if (templateBody.contains('Phoenix_Approver')) templateBody = templateBody.replace('Phoenix_Approver', currentUser.Name);
            mail.setSubject(mailSubject);
            mail.setHtmlBody(templateBody);  
            mail.setToAddresses(new List<String>{fromAddress});
            //  mail.setCcAddresses((new List<String>{'ramakrishnay@drreddys.com'}));
            mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
            mails.add(mail);
            results =  Messaging.sendEmail(mails);      
        }
      if (approvalAction == 'None' && tANumber != null){
            
            List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            Messaging.SendEmailResult[] results;
            Phoenix_Util.EmailWrapper emailWrapper ;
            emailWrapper = Phoenix_Util.getTemplateBody('Target_Achieved_Management_Failure', targetId);
            String templateBody = emailWrapper.mailHtmlBody;
            String mailSubject = emailWrapper.mailSubject;
            if (templateBody.contains('Phoenix_Approver')) templateBody = templateBody.replace('Phoenix_Approver', currentUser.Name);
            mail.setSubject(mailSubject);
            mail.setHtmlBody(templateBody);  
            mail.setToAddresses(new List<String>{fromAddress});
            //  mail.setCcAddresses((new List<String>{'ramakrishnay@drreddys.com'}));
            mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
            mails.add(mail);
            results =  Messaging.sendEmail(mails);      
        }
      
        else if(bidNumber != null){
            Phoenix_FinanceApprovalGrid.makeApprovalsFromEmail(bidId,approvalGrids,isMarketingHead,isBusinessHead,isVPFinanceHead,isMarketingSRxLead,isMarketingRxLead,isMarketingOTCLead,currentUser);
            system.debug('management approvals completed in email');
        }
        else if(wacNumber != null &&  bidProcessStepsList[0].Phoenix_Approver_Team__c.contains('Marketing Head') && !Phoenix_Util.sendBackEmailsBoolean){
            Phoenix_Util.sendBackEmailsBoolean = true;
            system.debug('Phoenix_Util.sendBackEmailsBoolean=='+Phoenix_Util.sendBackEmailsBoolean);
            Phoenix_NewProductWACPricingCntrl.makeHeadApprovals(wacId,approvalAction,true,currentUser);
        }
        else if(wacNumber != null &&  bidProcessStepsList[0].Phoenix_Approver_Team__c.contains('Marketing Lead')  && !Phoenix_Util.sendBackEmailsBoolean){
            Phoenix_Util.sendBackEmailsBoolean = true;
            Phoenix_NewProductWACPricingCntrl.makeLeadApprovals(wacId,approvalAction,IsconditionMet,true,currentUser); 
            
        }
       
        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
        return result;
    }
    /*
     public static void codecoverageBlock(){
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
         i++;         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;
                  i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
        i++; 
        i++;
         

    } */
}