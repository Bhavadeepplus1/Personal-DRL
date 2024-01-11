public class CustomerresponselineEmail {
    
    public static void sendemail(Set<String> bidOwnerEmails, Set<String> allApproversEmails, String crId){
        
        try{
            
            
            list<Phoenix_Customer_Response__c> customerresponselinelist=[select id,Phoenix_Bid_No__c,(select id,Phoenix_Bid__c,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Bid__r.Phoenix_Internal_Target_Date__c,Phoenix_Bid__r.Phoenix_Bid_Deadline_Date__c,Phoenix_Bid_Line_Item__c,Phoenix_Bid_Status__c,Phoenix_Customer_Response__c from Customer_Response_Lines__r where Phoenix_Bid_Status__c='DRL submitting under New Bid Number' ) from Phoenix_Customer_Response__c where id=:crid];
            
                 
                 Phoenix_Util.EmailWrapper emailWrapper=Phoenix_Util.getTemplateBody('Rejection_Email_Drl_Submitting',customerresponselinelist[0].id );
           
            string templatebody=emailWrapper.mailHtmlBody;
            // system.debug('Email Wrapper..'+emailWrapper);
            
            system.debug('template body...'+templateBody);
            
            
            
            
            Messaging.reserveSingleEmailCapacity(1);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           /* String[] toAddresses = new String[] {
                'sumanthreddy.kanthala@dhruvsoft.com'
                    };*/
            allApproversEmails.add('sumanthreddy.kanthala@dhruvsoft.com');
             mail.setToAddresses(new List<String>(allApproversEmails));
            mail.setCcAddresses(new List<String>(bidOwnerEmails));
           // mail.setTargetObjectId(UserInfo.getUserId());
           mail.setSubject(emailWrapper.mailSubject);
            mail.setWhatId(customerresponselinelist[0].id);
            
            mail.setHtmlBody(templateBody);      
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                mail
                    });
         
            
           
            
        }
        catch(exception e){
           Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'CustomerresponselineEmail', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'sendemail', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
}