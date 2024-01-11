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
public class Phoenix_BidCreator {

    @AuraEnabled
    public static AccountListWrapperClass getcustomerOwner(Id custID) {
        Account accRec = [select ownerID,Name,AccountNumber, Phoenix_Customer_Class_Bid_Template__c from Account where id =: custID];
        list < string > accountRec = new list < string > ();
        AccountListWrapperClass accWrpObj=new AccountListWrapperClass();
        accWrpObj.template=accRec.Phoenix_Customer_Class_Bid_Template__c;
        accWrpObj.Ownerid=accRec.ownerID;
        accWrpObj.AccName=accRec.Name;
	    accWrpObj.AccNumber=accRec.AccountNumber;        
        set < string > parentAccIds = new set < string > (); 
        List < string > parentAccIdsList = new List < string > (); 
        if (custID != null) {             
            //parentAccIds.add(custID);
            //Fetch related accounts
            Map < Id, Account > allAccMap = new Map < Id, Account > ();
            //Map of all accounts
            for (Account acc: Database.query('SELECT id,ParentId  FROM Account where Phoenix_Is_Bid_Account__c=true LIMIT 3000'))
                allAccMap.put(acc.Id, acc);
            String tempId = custID;
            while (allAccMap.get(tempId) != NULL && allAccMap.get(tempId).ParentId != NULL) {
                tempId = allAccMap.get(tempId).ParentId;
                //parentAccIds.add(tempId);
            }
              list < Account > AccHierarchyList = new list < Account > ([SELECT id FROM Account where Phoenix_Is_Bid_Account__c=true and ParentId=:tempId LIMIT 3000]); 
            for(Account acc:AccHierarchyList){
                parentAccIds.add(acc.Id);
            }
            parentAccIds.add(tempId);
            // system.debug('parentAccIds--' + parentAccIds);
        }
       // accountRec.add(parentAccIds.toString());
        parentAccIdsList.addAll(parentAccIds);
        accWrpObj.Acchirarchy=parentAccIdsList;
        return accWrpObj;
    }
     public class AccountListWrapperClass {
        @AuraEnabled public string template;
        @AuraEnabled public string Ownerid;
        @AuraEnabled public string AccName;
         @AuraEnabled public string AccNumber;
        @AuraEnabled public List<string> Acchirarchy;     
        public AccountListWrapperClass() {
          Acchirarchy = new List<string>(); 
        }
    }
    @AuraEnabled
    public static void createContentDCLink(Id crId, List < Id > contentDCIdList) {
        List < ContentDocumentLink > contentDCLinks = new List < ContentDocumentLink > ();
        for (Id conDCId: contentDCIdList) {
            ContentDocumentLink conDCLink = new ContentDocumentLink();
            conDCLink.LinkedEntityId = crId;
            conDCLink.ContentDocumentId = conDCId;
            contentDCLinks.add(conDCLink);
        } 
        if (!contentDCLinks.isEmpty()) {
            upsert contentDCLinks;
        }
    }

    @AuraEnabled
    public static void deleteAttachmentList(List < Id > LineItemIds) {
        List < ContentDocument > contentDocumentIds = [SELECT Id FROM ContentDocument WHERE Id IN: LineItemIds LIMIT 1000];
        if (!contentDocumentIds.isEmpty()) {
            delete contentDocumentIds;
        }
    }
    @AuraEnabled
    public static list < RecordType > getRecordTypeDetails() {
        list < RecordType > rectypes = [select Id, Name from RecordType where sObjectType = 'Phoenix_Bid__C'];
        return rectypes;
    }
    @AuraEnabled
    public static WrapperClass getbidInfo(String recordId) {
        WrapperClass wrapperCls = new WrapperClass();
        if (recordId != null) {
            
            wrapperCls.bid = [SELECT Id,Phoenix_is_OTC_Bid__c, Name,Phoenix_Customer_Type__c, Phoenix_Bid_Type__c, Phoenix_Customer__c, Phoenix_Approval_Status__c, Phoenix_RCA_Agreement__c, Phoenix_Contact__c
                FROM Phoenix_Bid__c
                WHERE Id =: recordId
                LIMIT 1
            ];
            if(wrapperCls.bid.Phoenix_Customer__c!=null){
                 wrapperCls.bidCreated = true;
            }
        }
        if(wrapperCls.bid.Phoenix_Bid_Type__c=='RCA/IPA Member GPO or Wholesaler Change' || wrapperCls.bid.Phoenix_Bid_Type__c=='RCA Member Addition' || wrapperCls.bid.Phoenix_Bid_Type__c=='IPA Member Addition' ){
           list < Phoenix_RCA_IPA_LINE__c > lineItems = [select id, Name from Phoenix_RCA_IPA_LINE__c	 where Phoenix_Bid__c =: recordId]; 
            if (!lineItems.isEmpty()) {
            wrapperCls.hasLines = true;
        }
        }
        else if(wrapperCls.bid.Phoenix_Bid_Type__c=='Contracts Only'){
             list < Checklist__c > lineItems = [select id, Name from Checklist__c where Bid__c =: recordId]; 
            if (!lineItems.isEmpty()) {
            wrapperCls.hasLines = true;
            
        }
        }
        else{
        list < Phoenix_Bid_Line_Item__c > lineItems = [select id, Name from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: recordId];
            if (!lineItems.isEmpty()) {
            wrapperCls.hasLines = true;
        }
        }
        
        //  List<String> sectionNames = new List<String>{'Phoenix_Bid_Information'};
        List < String > sectionNames = new List < String > {
            'Phoenix_Bid_Information',
            'Phoenix_Customer_Bid_Deadline_Info'
        };
        List < string > fieldSet;
        List < LayoutPage > listLayoutPage = new List < LayoutPage > ();
        for (String secName: sectionNames) {
            string section = '';
            Map < String, Schema.SObjectType > GlobalDescribeMap = Schema.getGlobalDescribe();
            Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get('Phoenix_Bid__c');
            Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
            Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(secName);
            List < Schema.FieldSetMember > fieldSetMemberList = fieldSetObj.getFields();
            fieldSet = new List < string > ();
            for (Schema.FieldSetMember fieldSetMemberObj: fieldSetMemberList) {
                fieldSet.add(fieldSetMemberObj.getFieldPath());
            }
            section = secName.replace('Phoenix_', ' ');
            LayoutPage layout = new LayoutPage(section.replace('_', ' '), fieldSet);
            listLayoutPage.add(layout);


        }
        wrapperCls.layoutList = listLayoutPage;
        return wrapperCls;
    }

    public class WrapperClass {
        @AuraEnabled
        public Phoenix_Bid__c bid;
        @AuraEnabled
        public List < LayoutPage > layoutList;
        @AuraEnabled public boolean hasLines;
         @AuraEnabled public boolean bidCreated;

        // =new List<String>{'Section 1','Payment Term','Section 2','Section 3','Section 4','Section 5','Section 6','Section 7','Section 8'};
        public WrapperClass() {
            bid = new Phoenix_Bid__c();
            layoutList = new List < LayoutPage > ();
            hasLines = false;
            bidCreated=false;
        }
    }

    public class LayoutPage {
        @AuraEnabled
        public string sectionName;
        @AuraEnabled
        public List < string > fieldSet;
        @AuraEnabled
        public List < SeperateFields > sepFields;
        public LayoutPage(String secName, List < string > fields) {
            this.sectionName = secName;
            this.fieldSet = fields;
            sepFields = new List < SeperateFields > ();
            for (Integer i = 0; i < fields.size(); i = i + 2) {
                if (i + 1 < fields.size()) {
                    SeperateFields sf = new SeperateFields(fields[i], fields[i + 1]);
                    sepFields.add(sf);
                }
            }
            if (math.mod(fields.size(), 2) == 1) {
                SeperateFields sf = new SeperateFields(fields[fields.size() - 1], null);
                sepFields.add(sf);
            }
        }
    }

    public class SeperateFields {
        @AuraEnabled
        public String firstField;
        @AuraEnabled
        public String secondField;
        public SeperateFields(String first, String second) {
            this.firstField = first;
            this.secondField = second;
        }
    }
}