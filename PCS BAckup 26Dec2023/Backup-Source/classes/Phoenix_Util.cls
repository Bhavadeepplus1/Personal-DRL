/**
* @description       :
* @author            : Surender Patel (Dhruvsoft)
* @group             :
* @last modified on  : 18-10-2021
* @last modified by  : Surender Patel (Dhruvsoft)
* Modifications Log
* Ver   Date         Author                       Modification
* 1.0   18-11-2020   Surender Patel (Dhruvsoft)   Initial Version
**/
public class Phoenix_Util {
        public static Boolean sendBackEmailsBoolean = False;

    public static string format(Decimal amount) {
        return String.valueOf(amount.setScale(0)).replaceAll('(\\d)(?=(\\d{3})+(?!\\d))', '$1,');
    }
    
    
    public static String nprDataFields {
        get {
            if (nprDataFields == null) return getsObjectFieds('Phoenix_NPR_Data__c');            else return nprDataFields;
        }
    }
    public static String bidLinePriceHistFields {
        get {
            if (bidLinePriceHistFields == null) return getsObjectFieds('Phoenix_Bid_Line_Item_Price_History__c');
            else return bidLinePriceHistFields;
        }
    }
    public static String bidActionItemsFields {
        get {
            if (bidActionItemsFields == null) return getsObjectFieds('Phoenix_Bid_Action_Item__c');
            else return bidActionItemsFields;
        }
    }
    public static String customerResponseFields {
        get {
            if (customerResponseFields == null) return getsObjectFieds('Phoenix_Customer_Response__c');            else return customerResponseFields;
        }
    }
    public static String customerResponseItemFields {
        get {
            if (customerResponseItemFields == null) return getsObjectFieds('Phoenix_Customer_Response_Line__c');            else return customerResponseItemFields;
        }
    }
    
    public static String contractFields {
        get {
            if (contractFields == null) return getsObjectFieds('Phoenix_Contract__c');            else return contractFields;
        }
    }
    public static String productFields {
        get {
            if (productFields == null) return getsObjectFieds('Product2');            else return productFields;
        }
    }
    public static String customerFields {
        get {
            if (customerFields == null) return getsObjectFieds('Account');            else return customerFields;
        }
    }
    public static String sapNPRStagingFields {
        get {
            if (sapNPRStagingFields == null) return getsObjectFieds('Phoenix_SAP_NPR_Staging__c');            else return sapNPRStagingFields;
        }
    }
    
    public static String nprVolumeFields {
        get {
            if (nprVolumeFields == null) return getsObjectFieds('Phoenix_NPR_Volume__c');            else return nprVolumeFields;
        }
    }
    
    public static String bidFields {
        get {
            if (bidFields == null) return getsObjectFieds('Phoenix_Bid__c');            else return bidFields;
        }
    }
    public static String bidlineitemFields {
        get {
            if (bidlineitemFields == null) return getsObjectFieds('Phoenix_Bid_Line_Item__c');            else return bidlineitemFields;
        }
    }
    public static String RCAIPAFields {
        get {
            if (RCAIPAFields == null) return getsObjectFieds('Phoenix_RCA_IPA_LINE__c');            else return RCAIPAFields;
        }
    }
    public static String userApprovalMatrixFields {
        get {
            if (userApprovalMatrixFields == null) return getsObjectFieds('Phoenix_User_Approval_Matrix__c');            else return userApprovalMatrixFields;
        }
    }
    
    public static String approvalGridFields {
        get {
            if (approvalGridFields == null) return getsObjectFieds('Phoenix_Approval_Grid__c');            else return approvalGridFields;
        }
    }
    
    public static String approvalMatrixFields {
        get {
            if (approvalMatrixFields == null) return getsObjectFieds('Phoenix_Approval_Matrix__c');            else return approvalMatrixFields;
        }
    }
    
    public static String approvalProcessStepFields {
        get {
            if (approvalProcessStepFields == null) return getsObjectFieds('Phoenix_Approval_Process_Step__c');            else return approvalProcessStepFields;
        }
    }
    
    public static String bidProcessStepFields {
        get {
            if (bidProcessStepFields == null) return getsObjectFieds('Phoenix_Bid_Process_Steps__c');            else return bidProcessStepFields;
        }
    }
    
    public static String ndcChangeFields {
        get {
            if (ndcChangeFields == null) return getsObjectFieds('Phoenix_NDC_Change__c');            else return ndcChangeFields;
        }
    }
    
    
    
    public static String ndcChangeLineItemFields {
        get {
            if (ndcChangeLineItemFields == null) return getsObjectFieds('Phoenix_NDC_Change_Line_Item__c');            else return ndcChangeLineItemFields;
        }
    }
    
    public static String ndcChangeProductFields {
        get {
            if (ndcChangeProductFields == null) return getsObjectFieds('Phoenix_NDC_Change_Product__c');            else return ndcChangeProductFields;
        }
    }
    
    public static String wacChangeFields {
        get {
            if (wacChangeFields == null) return getsObjectFieds('Phoenix_WAC_Change__c');            else return wacChangeFields;
        }
    }
    
    public static String wacChangeLineItemFields {
        get {
            if (wacChangeLineItemFields == null) return getsObjectFieds('Phoenix_WAC_Change_Line_Item__c');            else return wacChangeLineItemFields;
        }
    }
    
    public static String phsChangeFields {
        get {
            if (phsChangeFields == null) return getsObjectFieds('Phoenix_PHS_Price_Change__c');            else return phsChangeFields;
        }
    }
    
    public static String phsChangeLineFields {
        get {
            if (phsChangeLineFields == null) return getsObjectFieds('Phoenix_PHS_Price_Change_Line__c');            else return phsChangeLineFields;
        }
    }
    
    public static String newProductWACPricingFields {
        get {
            if (newProductWACPricingFields == null) return getsObjectFieds('New_Product_WAC_Pricing__c');            else return newProductWACPricingFields;
        }
    }
    
    public static String newProductWACPricingLinesFields {
        get {
            if (newProductWACPricingLinesFields == null) return getsObjectFieds('Phoenix_NewProduct_WAC_Pricing_LineItems__c');            else return newProductWACPricingLinesFields;
        }
    }
    
    public static String bidLineItemExtnFields {
        get {
            if (bidLineItemExtnFields == null) return getsObjectFieds('Phoenix_BidLineItemExtn__c');            else return bidLineItemExtnFields;
        }
    }
    
    public static String awardedQuantityFields {
        get {
            if (awardedQuantityFields == null) return getsObjectFieds('Phoenix_Awarded_Quantity__c');            else return awardedQuantityFields;
        }
    }
    public static String futureNPRDataFields {
        get {
            if (futureNPRDataFields == null) return getsObjectFieds('Phoenix_Future_NPR_Data__c');            else return futureNPRDataFields;
        }
    }
    public static String orgWideEmailId {
        get {
            if (orgWideEmailId == null) return [SELECT Address, DisplayName, Id FROM OrgWideEmailAddress WHERE Address =: Label.Phoenix_Org_Wide_Email Limit 1].Id;            else return orgWideEmailId;
        }
    }
    
    
    public static String nprSnapShotFields {
        get {
            if (nprSnapShotFields == null) return getsObjectFieds('Phoenix_NPR_Snapshot__c');            else return nprSnapShotFields;
        }
    }
    
    
    public static Boolean avoidBidProcessStepTrigger;
    public static Boolean runAQTrigger;
    
    static {
        avoidBidProcessStepTrigger = false;
        runAQTrigger = true;
    }
    
    /**
* @description This method gives all fields with comma, to use in query. Don't add fields again. Just add reference fields if needed.
* @author Surender Patel (Dhruvsoft) | 17-11-2020
* @param String obj - Object Name
* @return String - all fields with comma, to use in query.
**/
    public static String getsObjectFieds(String obj) {
        // System.debug('Called for ' + obj);
        String allFieldsStr = ' ';
        List < String > allFieldsList = new List < String > ();
        
        for (Schema.SObjectField field: ((sObject) Type.forName(obj).newInstance()).getSObjectType().getDescribe().fields.getMap().values()) {
            if (field.getDescribe().isAccessible() || field.getDescribe().isCustom()) {
                allFieldsList.add(String.valueOf(field));
            }
            
        }
        
        allFieldsStr = ' ' + String.join(allFieldsList, ',') + ' ';
        
        return allFieldsStr;
    }
    
    public static Boolean blnAlreadyDone = false;
    public static Boolean blnNPRDone = false;
    
    public static Boolean hasAlreadyDone() {
        return blnAlreadyDone;
    }
    
    public static void recordException(Exception e,String className, String methodName,String remarks) {
        //  System.debug('The current Class from Util is '+String.valueOf(this).substring(0, String.valueOf(this).indexOf(':')));
        //System.debug('The current Class from Util is '+String.valueOf(currentClass).substring(0, String.valueOf(currentClass).indexOf(':'))); 
        String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
        Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = className, Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = methodName, Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Remarks__c = remarks, Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
        insert exp;
    }
    
    public static void setAlreadyDone() {
        blnAlreadyDone = true;
    }
    
    /**
* @description This will replace all symbols in the data anywhere in the Salesforce. This is written for SAP data. 
* @author Surender Patel (Dhruvsoft) | 01-07-2021 
* @param String str - Input string which to be converted
* @return String - String after removal. 
**/
    public static String removeSymbolsFromString(String str) {
        //® – ™  ©
        
        // â€“ double hyphen
        str = str.replaceAll('â€“', '–');
        str = str.replaceAll('â€\'\'', '–');
        //â€™    apospstophe 
        str = str.replaceAll('â€™', '\'');
        
        
        return str;
    }
    
    public static String getUserTimeNow(DateTime dtTime, String tz) {
        //'America/New_York'
        dtTime = dtTime.addSeconds((Timezone.getTimeZone(tz).getOffset(dtTime)) / 1000);
        return dtTime.formatGMT('MMM d yyyy hh:mm a') + ' ' + Phoenix_Util.getTimezoneShortName(tz);
    }
    
    public static DateTime getUserTime(DateTime dtTime, String tz) {
        
        return dtTime.addSeconds((Timezone.getTimeZone(tz).getOffset(dtTime)) / 1000);
    }
    
    public static DateTime getNowEST() {
        DateTime dtTime = System.now();
        return dtTime.addSeconds((Timezone.getTimeZone('GMT').getOffset(dtTime)) / 1000);
    }
    
    public static Date getTodayEST() {
        DateTime dtTime = System.now();
        return Date.valueOf(dtTime.addSeconds((Timezone.getTimeZone('America/New_York').getOffset(dtTime)) / 1000));
    }
    public static DateTime convertTime(datetime dtTimeSrc, string  SrcTimeZone, string targetTimeZone){
        //String SrcTimeZone = 'Asia/Kolkata';//GMT   America/New_Yor    
        //String targetTimeZone = 'GMT';
        //DateTime dtTimeSrc = DateTime.newInstanceGMT(2022, 08, 17, 12, 0, 0); 
        decimal extraSec = Timezone.getTimeZone(targetTimeZone).getOffset(dtTimeSrc); // SF USER Time zone added 
        dateTime userTime = dtTimeSrc.addSeconds(integer.valueOf(extraSec / 1000));
        DateTime dtTimeTar = userTime.addSeconds(-(Timezone.getTimeZone(SrcTimeZone).getOffset(userTime)) / 1000);
        return  dtTimeTar;
        
    }
    
    
    public static String getTimezoneShortName(String tzApiName) {
        if (tzApiName == 'Pacific/Kiritimati') return 'LINT';
        else if (tzApiName == 'Pacific/Chatham') return 'CHAST';
        else if (tzApiName == 'Pacific/Auckland') return 'NZST';
        else if (tzApiName == 'Pacific/Enderbury') return 'PHOT';
        else if (tzApiName == 'Pacific/Fiji') return 'FJT';
        else if (tzApiName == 'Pacific/Tongatapu') return 'TOT';
        else if (tzApiName == 'Asia/Kamchatka') return 'PETT';
        else if (tzApiName == 'Pacific/Norfolk') return 'NFT';
        else if (tzApiName == 'Australia/Lord_Howe') return 'LHST';
        else if (tzApiName == 'Australia/Sydney') return 'AET';
        else if (tzApiName == 'Pacific/Guadalcanal') return 'SBT';
        else if (tzApiName == 'Australia/Adelaide') return 'ACST';
        else if (tzApiName == 'Australia/Darwin') return 'ACST';
        else if (tzApiName == 'Asia/Seoul') return 'KST';
        else if (tzApiName == 'Asia/Tokyo') return 'JST';
        else if (tzApiName == 'Asia/Hong_Kong') return 'HKT ';
        else if (tzApiName == 'Asia/Kuala_Lumpur') return 'MYT';
        else if (tzApiName == 'Asia/Manila') return 'PHT';
        else if (tzApiName == 'Asia/Shanghai') return 'CST';
        else if (tzApiName == 'Asia/Singapore') return 'SGT';
        else if (tzApiName == 'Asia/Taipei') return 'CST';
        else if (tzApiName == 'Australia/Perth') return 'AWST';
        else if (tzApiName == 'Asia/Bangkok') return 'ICT';
        else if (tzApiName == 'Asia/Ho_Chi_Minh') return ' ICT';
        else if (tzApiName == 'Asia/Jakarta') return 'WIB';
        else if (tzApiName == 'Asia/Rangoon') return 'MMT';
        else if (tzApiName == 'Asia/Dhaka') return ' BST';
        else if (tzApiName == 'Asia/Yekaterinburg') return 'YEKT';
        else if (tzApiName == 'Asia/Kathmandu') return 'NPT';
        else if (tzApiName == 'Asia/Colombo') return 'IST';
        else if (tzApiName == 'Asia/Kolkata') return 'IST';
        else if (tzApiName == 'Asia/Karachi') return 'PKT';
        else if (tzApiName == 'Asia/Tashkent') return 'UZT';
        else if (tzApiName == 'Asia/Kabul') return 'AFT';
        else if (tzApiName == 'Asia/Dubai') return 'GST';
        else if (tzApiName == 'Asia/Tbilisi') return 'GET';
        else if (tzApiName == 'Europe/Moscow') return 'MSK ';
        else if (tzApiName == 'Asia/Tehran') return 'IRDT';
        else if (tzApiName == 'Africa/Nairobi') return 'EAT';
        else if (tzApiName == 'Asia/Baghdad') return 'AST';
        else if (tzApiName == 'Asia/Kuwait') return 'AST';
        else if (tzApiName == 'Asia/Riyadh') return 'AST';
        else if (tzApiName == 'Europe/Minsk') return 'MSK';
        else if (tzApiName == 'Africa/Cairo') return 'EET';
        else if (tzApiName == 'Africa/Johannesburg') return 'SAST';
        else if (tzApiName == 'Asia/Jerusalem') return 'IDT';
        else if (tzApiName == 'Europe/Athens') return 'EEST';
        else if (tzApiName == 'Europe/Bucharest') return 'EET';
        else if (tzApiName == 'Europe/Helsinki') return 'EEST';
        else if (tzApiName == 'Europe/Istanbul') return 'TRT';
        else if (tzApiName == 'Africa/Algiers') return 'CET';
        else if (tzApiName == 'Europe/Amsterdam') return 'CET';
        else if (tzApiName == 'Europe/Berlin') return 'CET';
        else if (tzApiName == 'Europe/Brussels') return 'CEST';
        else if (tzApiName == 'Europe/Paris') return 'CET';
        else if (tzApiName == 'Europe/Prague') return 'CEST';
        else if (tzApiName == 'Europe/Rome') return 'CET ';
        else if (tzApiName == 'Europe/Dublin') return 'IST ';
        else if (tzApiName == 'Europe/Lisbon') return 'WEST';
        else if (tzApiName == 'Europe/London') return 'BST';
        else if (tzApiName == 'GMT') return 'GMT';
        else if (tzApiName == 'Atlantic/Cape_Verde') return 'CVT';
        else if (tzApiName == 'America/Sao_Paulo') return 'BRT';
        else if (tzApiName == 'Atlantic/South_Georgia') return 'GST';
        else if (tzApiName == 'America/Argentina/Buenos_Aires') return 'ART';
        else if (tzApiName == 'America/Santiago') return 'CLT';
        else if (tzApiName == 'America/St_Johns') return 'NDT';
        else if (tzApiName == 'America/Halifax') return 'ADT';
        else if (tzApiName == 'America/Puerto_Rico') return 'AST';
        else if (tzApiName == 'Atlantic/Bermuda') return 'AST';
        else if (tzApiName == 'America/Caracas') return 'VET';
        else if (tzApiName == 'America/Bogota') return 'COT';
        else if (tzApiName == 'America/Indiana/Indianapolis') return 'CST';
        else if (tzApiName == 'America/Lima') return 'PET ';
        else if (tzApiName == 'America/Panama') return 'EST';
        else if (tzApiName == 'America/Chicago') return 'CDT';
        else if (tzApiName == 'America/El_Salvador') return 'CST';
        else if (tzApiName == 'America/Mexico_City') return 'CDT';
        else if (tzApiName == 'America/Denver') return 'MDT';
        else if (tzApiName == 'America/Phoenix') return 'MDT';
        else if (tzApiName == 'America/Los_Angeles') return 'PST';
        else if (tzApiName == 'America/Tijuana') return 'PT';
        else if (tzApiName == 'America/Anchorage') return 'AKDT';
        else if (tzApiName == 'Pacific/Honolulu') return 'HST';
        else if (tzApiName == 'Pacific/Niue') return 'NUT';
        else if (tzApiName == 'Pacific/Pago_Pago') return 'SST';
        else if (tzApiName == 'America/New_York') return 'EST';
        else {
            return '';
        }
        
        
    }
    
    public static EmailWrapper getTemplateBody(String template, String bidId) {
        
        EmailTemplate sendTemplate = [SELECT Id, Name FROM EmailTemplate where DeveloperName =: template LIMIT 1];
        Messaging.reserveSingleEmailCapacity(1);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {
            'sample@drreddys.com'
                };
                    mail.setToAddresses(toAddresses);
        mail.setUseSignature(false);
        mail.setSaveAsActivity(false);
        mail.setSenderDisplayName(UserInfo.getName());
        mail.setTargetObjectId(UserInfo.getUserId());
        mail.setWhatId(bidId);
        mail.setTemplateId(sendTemplate.Id);
        Savepoint sp = Database.setSavepoint();
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
            mail
                });
        Database.rollback(sp);
        EmailWrapper wrap = new EmailWrapper();
        wrap.mailTextBody = mail.getPlainTextBody();
        wrap.mailHtmlBody = mail.getHTMLBody();
        wrap.mailSubject = mail.getSubject();
        
        return wrap;
    }
    
    
    public class EmailWrapper {
        public String mailTextBody {
            get;
            set;
        }
        public String mailHtmlBody {
            get;
            set;
        }
        public String mailSubject {
            get;
            set;
        }
    }
    
    public static void sendBatchJobCompletionEmail(String jobName, String comments){
        //   User u = [Select Id,Name,Email,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegated_Approver__r.Email From User Where Id=:userId];
        List < Messaging.SingleEmailMessage > mailsList = new List < Messaging.SingleEmailMessage > ();
        String mailStatus = '';
        Messaging.SendEmailResult[] results;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Batch_Completion_Notification', UserInfo.getUserId());
        String templateBody = emailWrapper.mailHtmlBody;
        templateBody = templateBody.replace('BATCH_NAME', jobName);
        if(String.isNotBlank(comments)){
            templateBody = templateBody.replace('COMMENTS_HERE', comments); 
        }else{
            templateBody = templateBody.remove('Comments: COMMENTS_HERE'); 
        } 
        
        // System.Domain d = ;
        //templateBody = templateBody.replace('ORG_NAME', ((System.DomainParser.parse(URL.getOrgDomainUrl())).getSandboxName()).toUpperCase()); 
        templateBody = templateBody.replace('ORG_NAME', system.label.Org_Name);
        
        
        email.setToAddresses(Label.Batch_Notification_Emails.split(','));
        email.setSubject(jobName +' batch has run now.');
        email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
        email.setHtmlBody(templateBody);
        mailsList.add(email);
        if (mailsList.size() > 0)
            results = Messaging.sendEmail(mailsList);
        
    }
    Public static List<Phoenix_Bid_Process_Steps__c> sortBidProcessSteps(List<Phoenix_Bid_Process_Steps__c> steps){
        Map < Decimal,Phoenix_Bid_Process_Steps__c> updatedTeamToNextMap = new Map < Decimal, Phoenix_Bid_Process_Steps__c>();
        List < Phoenix_Bid_Process_Steps__c > nextSteps = new List < Phoenix_Bid_Process_Steps__c > ();
        List<Decimal> stepNoDecimals = new List<Decimal>();
        for(Phoenix_Bid_Process_Steps__c  step : steps){
            Decimal stepCount = step.Phoenix_Sub_Step__c != null ? step.Phoenix_Step__c+(step.Phoenix_Sub_Step__c*0.1) : step.Phoenix_Step__c;
            stepNoDecimals.add(stepCount);
            updatedTeamToNextMap.put(stepCount , step);
        }
        stepNoDecimals.sort();                
        for(Decimal stepNo : stepNoDecimals)nextSteps.add(updatedTeamToNextMap.get(stepNo));
        system.debug('nextSteps in sortBidProcessSteps are-->' + nextSteps);
        return nextSteps;
    }
}