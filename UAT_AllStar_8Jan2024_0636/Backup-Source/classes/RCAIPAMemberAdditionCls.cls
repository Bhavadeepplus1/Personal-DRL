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
public class RCAIPAMemberAdditionCls {
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    @AuraEnabled
    public static Wrapper getRCAMemberList(Id bidId) {

        Wrapper wrapperObject = new Wrapper();
        String query = '';
        String SobjectApiName = 'Phoenix_RCA_IPA_LINE__c';
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
        //query = 'select' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId and Phoenix_Product__r.Phoenix_Is_IPA_Product__c=true ORDER BY Phoenix_Product__r.Name ASC'  ;

        //list<Phoenix_RCA_IPA_LINE__c> RCAMemberList =Database.query(query);
        list < Phoenix_RCA_IPA_LINE__c > RCAMemberList = new list < Phoenix_RCA_IPA_LINE__c > ();

        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Approval_Status__c, Phoenix_RCA_Change_Date__c, Name, Phoenix_Customer__r.Name, Phoenix_Bid_Name__c, Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        Phoenix_RCA_IPA_LINE__c rca = new Phoenix_RCA_IPA_LINE__c(Phoenix_RCA_Change_Date__c = bid.Phoenix_RCA_Change_Date__c, Phoenix_Bid__c = bid.Id);
        RCAMemberList.add(rca);
        list < Phoenix_RCA_IPA_LINE__c > existingLines = [select Id, Phoenix_Bid__c, Phoenix_RCA_Change_Date__c, Phoenix_RCA_Agreement__c, Phoenix_Customer__c from Phoenix_RCA_IPA_LINE__c where Phoenix_Bid__c =: bidId];

        wrapperObject.memberList = RCAMemberList;
        wrapperObject.bidRecord = bid;
        wrapperObject.rcItemList = existingLines;

        return wrapperObject;

    }


    @AuraEnabled
    public static Phoenix_RCA_IPA_LINE__c processRCAMember(Id bidId) {


        Phoenix_Bid__c bid = [SELECT Id, Phoenix_RCA_Change_Date__c, Name, Phoenix_Customer__r.Name, Phoenix_Bid_Name__c, Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        Phoenix_RCA_IPA_LINE__c rca = new Phoenix_RCA_IPA_LINE__c(Phoenix_RCA_Change_Date__c = bid.Phoenix_RCA_Change_Date__c, Phoenix_Bid__c = bid.Id);

        return rca;
    }

    @AuraEnabled
    public static list < Phoenix_RCA_IPA_LINE__c > saveRCAMembers(list < Phoenix_RCA_IPA_LINE__c > memberList)

    {

        list < Id > contIds = new list < Id > ();
        list < Id > accIds = new list < Id > ();
        map < Id, Account > accmap;
        map < Id, Contact > contmap;
        list < Phoenix_RCA_IPA_LINE__c > memberListCopy = new list < Phoenix_RCA_IPA_LINE__c > ();
        for (Phoenix_RCA_IPA_LINE__c rca: memberList) {
            contIds.add(rca.Phoenix_Contact__c);
            accIds.add(rca.Phoenix_Customer__c);
        }
        if (accIds.size() > 0) {
            accmap = new map < Id, Account > ([select Id, DEA__c, Phoenix_HIN__c, Phoenix_GLN__c, GPO1__c, Wholesaler1__c, Wholesaler_DC_1__c, Name, Street_Address_1__c, State__c, City__c, Zip__c from Account where ID IN: accIds]);
        }
        if (contIds.size() > 0) {
            contmap = new map < Id, Contact > ([select Id, Name, Email, Phone, Phoenix_Phone_External__c from Contact where ID IN: contIds]);
        }


        for (Phoenix_RCA_IPA_LINE__c rc: memberList) {
            Phoenix_RCA_IPA_LINE__c rca = new Phoenix_RCA_IPA_LINE__c();
            rca.Phoenix_Bid__c = rc.Phoenix_Bid__c;

            rca.Phoenix_RCA_Agreement__c = rc.Phoenix_RCA_Agreement__c;
            rca.Phoenix_Customer__c = rc.Phoenix_Customer__c;
            rca.Phoenix_RCA_Change_Date__c = rc.Phoenix_RCA_Change_Date__c;
            rca.Phoenix_Contact__c = rc.Phoenix_Contact__c;
            rca.Phoenix_DEA__c = rc.Phoenix_DEA__c;
            rca.Phoenix_HIN__c = rc.Phoenix_HIN__c;
            rca.Phoenix_GLN__c = rc.Phoenix_GLN__c;
            rca.Phoenix_New_GPO__c = rc.Phoenix_New_GPO__c;
            rca.Phoenix_Wholesaler__c = rc.Phoenix_Wholesaler__c;
            rca.Phoenix_Wholesaler_Location__c = rc.Phoenix_Wholesaler_Location__c;
            /*if (accmap.get(rc.Phoenix_Customer__c) != null) {
                rca.Phoenix_Street_Name__c = accmap.get(rc.Phoenix_Customer__c).Street_Address_1__c;
                rca.Phoenix_State__c = accmap.get(rc.Phoenix_Customer__c).State__c;
                rca.Phoenix_City__c = accmap.get(rc.Phoenix_Customer__c).City__c;
                rca.Phoenix_Zip__c = accmap.get(rc.Phoenix_Customer__c).Zip__c;

            }*/
              rca.Phoenix_Street_Name__c = rc.Phoenix_Street_Name__c;
                rca.Phoenix_State__c = rc.Phoenix_State__c;
                rca.Phoenix_City__c = rc.Phoenix_City__c;
                rca.Phoenix_Zip__c = rc.Phoenix_Zip__c;
            if (contmap.get(rc.Phoenix_Contact__c) != null) {

                rca.Phoenix_Contact_Email__c = contmap.get(rc.Phoenix_Contact__c).Email;
                rca.Phoenix_Contact_Phone__c = contmap.get(rc.Phoenix_Contact__c).Phone;
                rca.Phoenix_Contact_Phone_External__c = contmap.get(rc.Phoenix_Contact__c).Phoenix_Phone_External__c;
            }

            memberListCopy.add(rca);
        }

        if (memberListCopy.size() > 0) {
            insert memberListCopy;

        }
        return memberListCopy;
    }
    @AuraEnabled
    public static Wrapper getRCAmemberInfo(string accountId, string contactId) {


        Wrapper wrapperObject = new Wrapper();



        if (string.isNotBlank(accountId)) {

            Account accRecord = [select Id, DEA__c, Phoenix_HIN__c, Phoenix_GLN__c, GPO1__c, Wholesaler1__c, Wholesaler_DC_1__c, Name, Street_Address_1__c, State__c, City__c, Zip__c, Phoenix_RCA_Agreement__c, Owner.Name, Phoenix_RCA_Agreement__r.Name, OwnerId from Account where Id =: accountId limit 1];
            wrapperObject.accRecord = accRecord;

        }
        if (string.isNotBlank(contactId)) {
            Contact conRecord = [select Id, Email, Phone, Phoenix_Phone_External__c from Contact where Id =: contactId limit 1];

            wrapperObject.contRecord = conRecord;
        }


        return wrapperObject;
    }
    @AuraEnabled
    public static PicklistWrapper getDependentPicklist() {
        Map < String, List < String >> pickListMap = new Map < String, List < String >> ();
        List < String > GPOvalues = new List < String > ();
        List < String > StateValues = new List < String > ();
        PicklistWrapper pw = new PicklistWrapper();
        pw.pickListMap = pickListMap;



        Schema.sObjectType objType = Schema.getGlobalDescribe().get('Phoenix_RCA_IPA_LINE__c').newSObject().getSObjectType();
        Map < String, Schema.SObjectField > objFieldMap = objType.getDescribe().fields.getMap();

        if (!objFieldMap.containsKey('Phoenix_Wholesaler__c') || !objFieldMap.containsKey('Phoenix_Wholesaler_Location__c')) {
            return pw;
        }

        List < PicklistEntryWrapper > depEntries = (List < PicklistEntryWrapper > ) JSON.deserialize(JSON.serialize(objFieldMap.get('Phoenix_Wholesaler_Location__c').getDescribe().getPicklistValues()), List < PicklistEntryWrapper > .class);
        List < String > controllingValues = new List < String > ();

        for (Schema.PicklistEntry ple: objFieldMap.get('Phoenix_Wholesaler__c').getDescribe().getPicklistValues()) {
            pickListMap.put(ple.getLabel(), new List < String > ());
            controllingValues.add(ple.getLabel());
        }

        for (PicklistEntryWrapper plew: depEntries) {
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    pickListMap.get(controllingValues.get(i)).add(plew.label);
                }
            }
        }
        Schema.DescribeFieldResult fieldResult = Phoenix_RCA_IPA_LINE__c.Phoenix_New_GPO__c.getDescribe();
        List < Schema.PicklistEntry > pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            GPOvalues.add(p.getLabel());
        }
        
       Schema.DescribeFieldResult fieldResult1 = Phoenix_RCA_IPA_LINE__c.Phoenix_State__c.getDescribe();
        List < Schema.PicklistEntry > pList1 = fieldResult1.getPicklistValues();
        for (Schema.PicklistEntry p: pList1) {
            StateValues.add(p.getLabel());
        }
        
        pw.pickListMap = pickListMap;
        pw.parentFieldLabel = objFieldMap.get('Phoenix_Wholesaler__c').getDescribe().getLabel();
        pw.childFieldLabel = objFieldMap.get('Phoenix_Wholesaler_Location__c').getDescribe().getLabel();
        pw.GPOvalues = GPOvalues;
        pw.StateValues = StateValues;
        return pw;
    }

    //Refer from here https://salesforce.stackexchange.com/questions/4462/get-lists-of-dependent-picklist-options-in-apex
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }

    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';

        String validForBits = '';

        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }

        return validForBits;
    }

    public class PicklistWrapper {
        @AuraEnabled
        public Map < String, List < String >> pickListMap;
        @AuraEnabled
        public String parentFieldLabel;
        @AuraEnabled
        public String childFieldLabel;
        @AuraEnabled
        public list < String > GPOvalues;
        @AuraEnabled
        public list < String > StateValues;
    }

    public class PicklistEntryWrapper {
        public String active;
        public String defaultValue;
        public String label;
        public String value;
        public String validFor;

    }


    public class Wrapper {

        @AuraEnabled public List < Phoenix_RCA_IPA_LINE__c > memberList;
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        @AuraEnabled public Account accRecord;
        @AuraEnabled public list < Phoenix_RCA_IPA_LINE__c > rcItemList;
        @AuraEnabled public Contact contRecord;
        Wrapper() {

            memberList = new List < Phoenix_RCA_IPA_LINE__c > ();
            rcItemList = new List < Phoenix_RCA_IPA_LINE__c > ();
            bidRecord = new Phoenix_Bid__c();
            accRecord = new Account();
            contRecord = new Contact();
        }
    }

}