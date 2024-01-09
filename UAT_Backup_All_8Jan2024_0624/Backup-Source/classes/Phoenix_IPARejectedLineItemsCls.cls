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
public class Phoenix_IPARejectedLineItemsCls {
    @AuraEnabled
    public static Wrapper getRelatedList(Id bidId) {
        Wrapper wrapperObject = new Wrapper();

        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();

        String strFields = '';

        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        string notApproved = 'Not Approved';
        query = 'select Phoenix_Contract__r.Name,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,Phoenix_Contract__r.Id,Phoenix_Customer__r.Name,Phoenix_Customer__r.Id, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId and Phoenix_Product__r.Phoenix_Is_IPA_Product__c=true and Phoenix_Final_Status__c =: notApproved ORDER BY Phoenix_Product__r.Name ASC ';

        list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);
        Phoenix_Bid__c bid = [SELECT Id, Name, Phoenix_Approval_Status__c, Phoenix_Customer__r.Name, Phoenix_Bid_Name__c, Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =: bidId];

        wrapperObject.lineItemsList = quoteList;
        wrapperObject.bidRecord = bid;

        return wrapperObject;

    }

    public class Wrapper {

        @AuraEnabled public List < Phoenix_Bid_Line_Item__c > lineItemsList;
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        @AuraEnabled public string loggedInUserName;
        @AuraEnabled public string isContractsApprovePerson;
        @AuraEnabled public boolean showProceedBtn;
        Wrapper() {

            lineItemsList = new List < Phoenix_Bid_Line_Item__c > ();
            bidRecord = new Phoenix_Bid__c();
            loggedInUserName = '';
            isContractsApprovePerson = '';
        }
    }
    @AuraEnabled
    public static void deleteLineItems(String LineItemId) {
        if (LineItemId != null) {
            Phoenix_Bid_Line_Item__c deletedLineItem = [SELECT Id FROM Phoenix_Bid_Line_Item__c WHERE Id =: LineItemId];
            delete deletedLineItem;
        }
    }
    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > saveLineItems(List < Phoenix_Bid_Line_Item__c > LineItemList) {

        update LineItemList;
        return LineItemList;
    }
}