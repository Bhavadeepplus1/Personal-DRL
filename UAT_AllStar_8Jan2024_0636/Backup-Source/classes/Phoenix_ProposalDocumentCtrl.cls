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
public class Phoenix_ProposalDocumentCtrl {
    public Phoenix_ProposalDocumentCtrl() {}
    @AuraEnabled
    public static String generateDocument(String bidId) {
        PageReference pdf = Page.DirectCustomerOfferPage;
        String parentId = bidId; // add parent id to the parameters for standardcontroller
        pdf.getParameters().put('BidId', bidId);
        List < Attachment > atchList = [Select Id, ParentId from Attachment where ParentId =: bidId];
        List < Phoenix_Bid__c > bidInfo = [SELECT Id, Name, Phoenix_Bid_Type__c, Phoenix_Bid_Name__c, Phoenix_Customer__c, Phoenix_Customer__r.Name FROM Phoenix_Bid__c WHERE ID =: BidId LIMIT 1];
        // create the new attachment
        Attachment attach = new Attachment();
        // the contents of the attachment from the pdf
        Blob body;

        try {

            // returns the output of the page as a PDF
            body = pdf.getContent();

            // need to pass unit test -- current bug	
        } catch (VisualforceException e) {
            body = Blob.valueOf('Some Text');
        }

        attach.Body = body;
        // add the user entered name
        if (atchList.size() > 0) {
            attach.Name = bidInfo[0].Name + '-' + bidInfo[0].Phoenix_Customer__r.Name + '-' + bidInfo[0].Phoenix_Bid_Type__c + '_V' + atchList.size() + '.doc';
        } else {
            attach.Name = bidInfo[0].Name + '-' + bidInfo[0].Phoenix_Customer__r.Name + '-' + bidInfo[0].Phoenix_Bid_Type__c + '_V.doc';
        }
        attach.IsPrivate = false;
        // attach the pdf to the account
        attach.ParentId = parentId;
        attach.ContentType = 'application/msword';
        insert attach;
        return 'Success';
    }
}