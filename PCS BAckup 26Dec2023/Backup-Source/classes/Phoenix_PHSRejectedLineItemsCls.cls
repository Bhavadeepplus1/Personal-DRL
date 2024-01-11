public class Phoenix_PHSRejectedLineItemsCls {

   @AuraEnabled
    public static Wrapper getRelatedList(Id bidId) {
        Wrapper wrapperObject = new Wrapper();

        String query = '';
        String SobjectApiName = 'Phoenix_PHS_Price_Change_Line__c';
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
        query = 'select Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c,Phoenix_Product_Name__r.Name, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_PHS_Price_Change__c = : bidId and Phoenix_Final_Status__c =: notApproved';

        list < Phoenix_PHS_Price_Change_Line__c > quoteList = Database.query(query);
        Phoenix_PHS_Price_Change__c bid = [SELECT Id, Name,RecordType.Name,Phoenix_Approval_Status__c FROM Phoenix_PHS_Price_Change__c WHERE Id =: bidId];

        wrapperObject.lineItemsList = quoteList;
        wrapperObject.bidRecord = bid;

        return wrapperObject;

    }

    public class Wrapper {

        @AuraEnabled public List < Phoenix_PHS_Price_Change_Line__c > lineItemsList;
        @AuraEnabled public Phoenix_PHS_Price_Change__c bidRecord;
        @AuraEnabled public string loggedInUserName;
        @AuraEnabled public string isContractsApprovePerson;
        @AuraEnabled public boolean showProceedBtn;
        Wrapper() {

            lineItemsList = new List < Phoenix_PHS_Price_Change_Line__c > ();
            bidRecord = new Phoenix_PHS_Price_Change__c();
            loggedInUserName = '';
            isContractsApprovePerson = '';
        }
    }
    @AuraEnabled
    public static void deleteLineItems(String LineItemId) {
        if (LineItemId != null) {
            Phoenix_PHS_Price_Change_Line__c deletedLineItem = [SELECT Id FROM Phoenix_PHS_Price_Change_Line__c WHERE Id =: LineItemId];
            delete deletedLineItem;
        }
    }
    
    @AuraEnabled
    public static list < Phoenix_PHS_Price_Change_Line__c > getupdatedforExport(Id bidId) {
        String query = '';
        String SobjectApiName = 'Phoenix_PHS_Price_Change_Line__c';
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
        query = 'select Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c,Phoenix_Product_Name__r.Name,  ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_PHS_Price_Change__c = : bidId AND Phoenix_Final_Status__c =: notApproved';
        list < Phoenix_PHS_Price_Change_Line__c > quoteList = Database.query(query);
        return quoteList;
    }
    
    @AuraEnabled
    public static list < Phoenix_PHS_Price_Change_Line__c > saveLineItems(List < Phoenix_PHS_Price_Change_Line__c > LineItemList) {

        update LineItemList;
        return LineItemList;
    }

   


}