public class SRxAchievEmailNotifySendCls {
    @future
    public static void sendEmailAlert(String bidId, String content2, list<String> toAddress, list<string> ccaddress, String subject, String title, Boolean isFooterTextAlterRequired){
        System.debug('subject test==>'+subject.length());
        String content1 = '';
        String delimiter = '==>';
        String subject2 = subject;
        
        //  string brightLogoEncode = getBase64Image('BRIGHT_Logo_Email');
        //  string visionLogoEncode = getBase64Image('VISION_Logo_Email');
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        list < messaging.Email > mailsList = new list < messaging.email > ();
        Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Marketing_Approval_Email_Template', bidId);
        String templateBody = emailWrapper.mailHtmlBody;
        if(subject.contains('==>Approve through email'))
        {
            email.setReplyTo(Label.Bright_Approval_Inbound_Email);
            // subject = subject.split('-');
            
            subject = subject.substringBefore(delimiter);
            
        }
        //String subject = emailWrapper.mailSubject;
        String header ='';
        content1 += header;
        content1 += content2;
        System.debug('content2 ===>'+content2);
        System.debug('content1 in all emails ====>'+content1);
        System.debug('tmeplateBody ====>'+templateBody);
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:4px 8px 0px 8px;">Best Regards,</td></tr>';
        content1 += '<tr><td style="width: 24px;"></td><td style="padding: 0px 8px;">BRIGHT Support Team.</td></tr>';
        if(isFooterTextAlterRequired){
            content1 += '<tr><td style="width: 24px;"></td><td style="padding: 12px 8px;"><i>[This is an auto-generated mail from BRIGHT]</i></td></tr>';   
        } else{
            content1 += '<tr><td style="width: 24px;"></td><td style="padding: 12px 8px;"><i>[This is an auto-generated mail from BRIGHT, please do not reply to this email]</i></td></tr>';
        }
        content1 += '</table>';
        String objName = String.valueOf(Id.valueOf(bidId).getsObjectType());
        List<String> testTo = new List<String>();
        List<String> testCC = new List<String>();
        if (Label.toAddressUAT != null) testTo.addAll(Label.toAddressUAT.split(','));
	   if (Label.ccAddressUAT != null) testCC.addAll(Label.ccAddressUAT.split(','));
        if (Label.toAddressUAT != null){
        email.setToAddresses(testTo); //replace with toaddress after testing  toaddress//toAddress
        }else{
            email.setToAddresses(toAddress);
        }
        if (Label.ccAddressUAT != null){
            email.setCcAddresses(testCC);
        }else{
          email.setCcAddresses(ccaddress);  
        }
        //testTo.addAll(toAddress);
        
       
        //ccaddress.addAll(ccaddress);
        
        email.setToAddresses(testTo); //replace with toaddress after testing  toaddress//toAddress
        email.setCcAddresses(ccaddress); //uncomment this after testing
        if(content1 != null){
            // templateBody = templateBody.replace('LOGO_BODY', content1);
            System.debug('Display templateBody without content ===>'+templateBody);
            templateBody = templateBody.replace('LOGO_BODY', content1);
            System.debug('Display templateBody with content ===>'+templateBody);
            templateBody = templateBody.replace('TITLE_TEXT', title);
            System.debug('Display templateBody ===>'+templateBody);
        }
        else{
            System.debug('templateBody or content1 is null');
        }
        email.setHtmlBody(templateBody);
        email.setSubject(subject);
        email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
        mailsList.add(email);
        if(subject.length() > 1){
            messaging.sendEmail(mailsList);
        }
    }
}