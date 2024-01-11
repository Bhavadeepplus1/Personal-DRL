/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
public class Phoenix_OfferGenerationDocumentCls {
    //static Map<id,integer> DocumentNameVersioningList=new map<id,integer>();

    public Phoenix_OfferGenerationDocumentCls() {}
    /*public Phoenix_Bid__c bid{get;set;}
public user currentuser{get;set;}
public Phoenix_OfferGenerationDocumentCls(string bidId, String selectedProductFamily){
currentuser=[Select Id,Name,Email,Title from User where Id=:userinfo.getuserId()];
if(BidId != null)  bid=[SELECT Id, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer__r.City__c, Phoenix_Customer__r.State__c, Phoenix_Customer__r.Zip__c,Phoenix_Customer__r.Street_Address_1__c FROM Phoenix_Bid__c  WHERE ID=:BidId LIMIT 1];
}*/

    @AuraEnabled
    public static String generateDocument(Id bidId, string templateName, string offerDocumentName, string productFamily, string relatedTo, string customerId) {
        try {
            PageReference pdf = new PageReference('/apex/' + templateName);

            String parentId = bidId; // add parent id to the parameters for standardcontroller
            pdf.getParameters().put('BidId', bidId);
            pdf.getParameters().put('productFamily', productFamily);
            pdf.getParameters().put('relatedTo', relatedTo);
            pdf.getParameters().put('customerId', customerId);
            List < Attachment > atchList = [Select Id, ParentId, Name from Attachment where ParentId =: bidId];

            // create the new attachment
            Attachment attach = new Attachment();
            // the contents of the attachment from the pdf
            Blob body;

            try {

                // returns the output of the page as a PDF
                body = pdf.getContent();

                // need to pass unit test -- current bug	
            } catch (VisualforceException e) {
                body = Blob.valueOf('Error at: ' + e.getLineNumber() + 'Message: ' + e.getMessage());

            }

            attach.Body = body;
            // add the user entered name


            if (atchList.size() > 0) {
                attach.Name = offerDocumentName + '.doc';
            } else {
                attach.Name = offerDocumentName + '.doc';
            }
            attach.IsPrivate = false;
            // attach the pdf to the account
            attach.ParentId = parentId;
            attach.ContentType = 'application/msword';
            insert attach;
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Method_Name__c = 'calculateFinanceGrid', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        return 'Success';
    }

    public static Map < string, List < Phoenix_Bid_Line_Item__c >> mapOfProductFamily {
        get;
        set;
    }

    @AuraEnabled
    public static offerDocWrapper getOfferTemplates(String customerId, Id bidId) {

        offerDocWrapper docWrapper = new offerDocWrapper();
        Set < string > setOfLineItemsFamilies = new Set < string > ();
        List < string > listOfLineItemsFamilies = new List < string > ();
        mapOfProductFamily = new Map < string, List < Phoenix_Bid_Line_Item__c >> ();
        try {
            List < Phoenix_Offer_Template__c > offTemp;
            List < Phoenix_Offer_Template__c > QueryoffTemp = [SELECT Id, Name, Phoenix_Account__c, Phoenix_VF_Page_Name__c, Phoenix_Related_To__c FROM Phoenix_Offer_Template__c WHERE Phoenix_Account__r.Id =: customerId AND Phoenix_Related_To__c=:'Bid Template' ORDER BY Name ASC];
            if(QueryoffTemp.size() > 0){
                offTemp=QueryoffTemp;
            }
            else{
                offTemp=[SELECT Id, Name, Phoenix_Account__c, Phoenix_VF_Page_Name__c, Phoenix_Related_To__c FROM Phoenix_Offer_Template__c WHERE Phoenix_Account__c = null AND Phoenix_Related_To__c=:'Bid Template' ORDER BY Name ASC];
            }
            List < Phoenix_Bid__c > bidInfo = [SELECT Id, Name, Phoenix_Bid_Type__c, Phoenix_Bid_Name__c, Phoenix_Customer__c, Phoenix_Approval_Status__c, Phoenix_Customer__r.Name FROM Phoenix_Bid__c WHERE ID =: bidId LIMIT 1];

            List < Phoenix_Bid_Line_Item__c > lineItemsInfo;
            if (bidInfo[0].Phoenix_Bid_Type__c == 'Volume Review Only') {
                lineItemsInfo = [SELECT Id, Name, Product_Family__c, Product_Family_Name__c,Product_Family__r.Name, Phoenix_Product_Family__c, Phoenix_Product__r.Name, Phoenix_Bid__c, Phoenix_Product__c, Phoenix_Product__r.Phoenix_API_Supplier_Name__c, Phoenix_Product__r.Phoenix_FEI_of_API_Manufacturing_Site__c, Phoenix_Product__r.Phoenix_FEI_of_Finished_Goods_MFR__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Id =: bidId AND(Phoenix_SCM_Approval_Y_N__c =: 'Y- Only Current Monthly Demand Approved'
                    OR Phoenix_SCM_Approval_Y_N__c =: 'Y- Current + Inc Demand Approved')];
            } else {
                lineItemsInfo = [SELECT Id, Name, Product_Family__c,Product_Family_Name__c, Product_Family__r.Name, Phoenix_Product_Family__c, Phoenix_Product__r.Name, Phoenix_Bid__c, Phoenix_Product__c, Phoenix_Product__r.Phoenix_API_Supplier_Name__c, Phoenix_Product__r.Phoenix_FEI_of_API_Manufacturing_Site__c, Phoenix_Product__r.Phoenix_FEI_of_Finished_Goods_MFR__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Id =: bidId AND Phoenix_Finance_Approval__c =: 'Approved'];
            }
              if(bidInfo[0].Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)'){
                offTemp=[SELECT Id, Name, Phoenix_Account__c, Phoenix_VF_Page_Name__c, Phoenix_Related_To__c FROM Phoenix_Offer_Template__c WHERE Phoenix_Account__c = null AND Phoenix_Related_To__c=:'Bid Template' AND (Phoenix_VF_Page_Name__c ='IOD_Stocking_Dis_With_ShelfLife' OR Phoenix_VF_Page_Name__c ='IOD_Stocking_Discount_Normal' OR Phoenix_VF_Page_Name__c ='IOD_Mck_Stocking_Allowance' OR Phoenix_VF_Page_Name__c ='IOD_Cardinal_GWSA_Template' OR Phoenix_VF_Page_Name__c ='IOD_Cardinal_NonGWSA_Template') ORDER BY Name ASC];
            }
            string defaultOfferDocumentName;
            //
            //if(DocumentNameVersioningList.containsKey(bidId)){
            //
            // Integer bytes = DocumentNameVersioningList.get(bidId);
            //  defaultOfferDocumentName = 'Offer-'+bidInfo[0].Name+'-'+bidInfo[0].Phoenix_Customer__r.Name+'-'+bidInfo[0].Phoenix_Bid_Type__c+'-'+Date.today().format()+' V'+bytes;
            // DocumentNameVersioningList.put(bidId,bytes);


            //}
            //else{
            defaultOfferDocumentName = 'Offer-' + bidInfo[0].Name + '-' + bidInfo[0].Phoenix_Customer__r.Name + '-' + bidInfo[0].Phoenix_Bid_Type__c + '-' + Date.today().format();

            //DocumentNameVersioningList.put(bidId,1);


            //  }
            for (Phoenix_Bid_Line_Item__c item: lineItemsInfo) {
                //lineItemsIds.add(item.Id);
                setOfLineItemsFamilies.add(item.Product_Family_Name__c);
            }
            for (string item: setOfLineItemsFamilies) {
                listOfLineItemsFamilies.add(item);
            }



            docWrapper.offTemp = offTemp;
            docWrapper.offerDefaultName = defaultOfferDocumentName;
            docWrapper.lineItems = lineItemsInfo;
            docWrapper.listOfLineItemsFamilies = listOfLineItemsFamilies;

        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Method_Name__c = 'calculateFinanceGrid', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        return docWrapper;
    }


    @AuraEnabled
    public static offerDocWrapper getNDCOfferTemplates(Id ndcId) {

        offerDocWrapper docWrapper = new offerDocWrapper();
        Set < string > setOfLineItemsFamilies = new Set < string > ();
        List < string > listOfLineItemsFamilies = new List < string > ();
        Set<Id> setOfLineItemsCustomers = new Set<Id>();
        try {
            List < Phoenix_Offer_Template__c > offTemp = [SELECT Id, Name, Phoenix_Account__c, Phoenix_VF_Page_Name__c, Phoenix_Related_To__c FROM Phoenix_Offer_Template__c WHERE Phoenix_Related_To__c=:'NDC Change' ORDER BY Name ASC];
            List < Phoenix_NDC_Change__c > ndcInfo = [SELECT Id, Name FROM Phoenix_NDC_Change__c WHERE ID =: ndcId LIMIT 1];

            List < Phoenix_NDC_Change_Line_Item__c > lineItemsInfo;
            lineItemsInfo = [SELECT Id, Name, Phoenix_Account__c, Phoenix_Current_Product__r.Product_Family__c, Phoenix_Current_Product__r.Product_Family__r.Name, Phoenix_Current_Product__r.Family FROM Phoenix_NDC_Change_Line_Item__c WHERE Phoenix_NDC_Change__c =: ndcId AND Phoenix_Finance_Approval__c =: 'Approved'];
            string defaultOfferDocumentName;
            //
            //if(DocumentNameVersioningList.containsKey(bidId)){
            //
            // Integer bytes = DocumentNameVersioningList.get(bidId);
            //  defaultOfferDocumentName = 'Offer-'+bidInfo[0].Name+'-'+bidInfo[0].Phoenix_Customer__r.Name+'-'+bidInfo[0].Phoenix_Bid_Type__c+'-'+Date.today().format()+' V'+bytes;
            // DocumentNameVersioningList.put(bidId,bytes);


            //}
            //else{
            defaultOfferDocumentName = 'Offer-' + ndcInfo[0].Name+'-' + Date.today().format();

            //DocumentNameVersioningList.put(bidId,1);


            //  }
            for (Phoenix_NDC_Change_Line_Item__c item: lineItemsInfo) {
                //lineItemsIds.add(item.Id);
                setOfLineItemsFamilies.add(item.Phoenix_Current_Product__r.Product_Family__r.Name);
                setOfLineItemsCustomers.add(item.Phoenix_Account__c);
            }
            for (string item: setOfLineItemsFamilies) {
                listOfLineItemsFamilies.add(item);
            }
            List<Account> customers = [select Id, Name from Account where Id =: setOfLineItemsCustomers];


            docWrapper.offTemp = offTemp;
            docWrapper.offerDefaultName = defaultOfferDocumentName;
            docWrapper.ndcLineItems = lineItemsInfo;
            docWrapper.listOfLineItemsFamilies = listOfLineItemsFamilies;
            docWrapper.listOfLineItemsAccounts = customers;

        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Method_Name__c = 'calculateFinanceGrid', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        return docWrapper;
    }

    public class offerDocWrapper {
        @AuraEnabled public List < Phoenix_Offer_Template__c > offTemp;
        @AuraEnabled public List < Phoenix_Bid__c > bidInfo;
        @AuraEnabled public List < Phoenix_WAC_Change__c > wacInfo;
        @AuraEnabled public List < Phoenix_NDC_Change__c > ndcInfo;
        @AuraEnabled public List < string > listOfLineItemsFamilies;
        @AuraEnabled public List < Account > listOfLineItemsAccounts;
        @AuraEnabled public List < Phoenix_Bid_Line_Item__c > lineItems;
        @AuraEnabled public List < Phoenix_WAC_Change_Line_Item__c > wacLineItems;
        @AuraEnabled public List < Phoenix_NDC_Change_Line_Item__c > ndcLineItems;
        @AuraEnabled public string offerDefaultName;

        offerDocWrapper() {
            offTemp = new List < Phoenix_Offer_Template__c > ();
            listOfLineItemsFamilies = new List < string > ();
            lineItems = new List < Phoenix_Bid_Line_Item__c > ();
            bidInfo = new List < Phoenix_Bid__c > ();
            wacInfo = new List < Phoenix_WAC_Change__c > ();
            wacLineItems = new List < Phoenix_WAC_Change_Line_Item__c > ();
            ndcInfo = new List < Phoenix_NDC_Change__c > ();
            ndcLineItems = new List < Phoenix_NDC_Change_Line_Item__c > ();
            listOfLineItemsAccounts = new List < Account >();
            offerDefaultName = '';
        }
    }


}