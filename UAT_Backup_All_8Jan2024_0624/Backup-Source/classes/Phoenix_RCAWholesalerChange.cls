public class Phoenix_RCAWholesalerChange {
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    @AuraEnabled
    public static list<Wrapper> getRCAContracts(Id bidId){
        
        list<Wrapper>wrapList=new list <Wrapper>();
        list<Phoenix_RCA_IPA_LINE__c>existingLines=[select Id,Phoenix_Bid__c,Phoenix_RCA_Change_Date__c,Phoenix_RCA_Agreement__c,Phoenix_Customer__c,Phoenix_Customer__r.Name from Phoenix_RCA_IPA_LINE__c where Phoenix_Bid__c=:bidId];
       system.debug('existingLines-----'+existingLines);
        list<Phoenix_Bid__c> bid=[select Id,Phoenix_Approval_Status__c,Phoenix_Bid_Type__c,Phoenix_RCA_Change_Date__c,Phoenix_RCA_Agreement__c,Phoenix_RCA_Agreement__r.Phoenix_Is_RCA_Contract__c,Phoenix_RCA_Agreement__r.Name,Phoenix_RCA_Agreement__r.Phoenix_Contract_Status__c from Phoenix_Bid__c where Id=:bidId limit 1];
        boolean rcaContract=bid[0].Phoenix_RCA_Agreement__r.Phoenix_Is_RCA_Contract__c;
        list<Account> RCAList=[select Id,Street_Address_1__c,State__c,City__c,Zip__c,Name,Phoenix_RCA_Agreement__c,Owner.Name,Phoenix_RCA_Agreement__r.Name,GPO1__c,Wholesaler1__c,Wholesaler_DC_1__c,OwnerId from Account where (Phoenix_RCA_Agreement__c=:bid[0].Phoenix_RCA_Agreement__c or Phoenix_IPA_Contract__c=:bid[0].Phoenix_RCA_Agreement__c) limit 20000];   
         
        if(RCAList.size()>0){ 
            for(Account acc: RCAList){
                Wrapper wrapperObject = new Wrapper();
                Phoenix_RCA_IPA_LINE__c rcItem=new Phoenix_RCA_IPA_LINE__c(Phoenix_Bid__c=bid[0].Id,Phoenix_RCA_Change_Date__c=bid[0].Phoenix_RCA_Change_Date__c,Phoenix_RCA_Agreement__c=bid[0].Phoenix_RCA_Agreement__c,Phoenix_Customer__c=acc.Id,Phoenix_Current_GPO__c=acc.GPO1__c,Phoenix_Current_Wholesaler__c=acc.Wholesaler1__c,Phoenix_RAM__c=acc.OwnerId);   
                wrapperObject.rcItem=rcItem;
                wrapperObject.accRecord=acc;
                wrapperObject.flag=false;
                //wrapperObject.rcaContract=rcaContract;
                wrapperObject.bidRecord=bid[0];
                 wrapperObject.rcItemList=existingLines;
              
                
                wrapList.add(wrapperObject);
               
            } 
        }
        else{
            Wrapper wrapperObject = new Wrapper();
            Phoenix_RCA_IPA_LINE__c rcItem=new Phoenix_RCA_IPA_LINE__c(Phoenix_Bid__c=bid[0].Id,Phoenix_RCA_Change_Date__c=bid[0].Phoenix_RCA_Change_Date__c,Phoenix_RCA_Agreement__c=bid[0].Phoenix_RCA_Agreement__c);   
            wrapperObject.rcItem=rcItem;
            wrapperObject.flag=true;
             wrapperObject.rcItemList=existingLines;
           // wrapperObject.rcaContract=rcaContract;
            wrapperObject.bidRecord=bid[0];
            wrapList.add(wrapperObject);   
        }
        
        
        
        return wrapList;
    }
    
    @AuraEnabled
    public static list<Phoenix_RCA_IPA_LINE__c> saveRCAMembers(list<Phoenix_RCA_IPA_LINE__c>memberList)
        
    { 
        
        
        list<Id>accIds=new list<Id>();
        map<Id,Account>accmap;
        
        list<Phoenix_RCA_IPA_LINE__c>memberListCopy=new list<Phoenix_RCA_IPA_LINE__c>();
        for(Phoenix_RCA_IPA_LINE__c rca:memberList){
            
            accIds.add(rca.Phoenix_Customer__c);
        }
        if(accIds.size()>0){
            accmap=new map<Id,Account>([select Id,Name,Phoenix_RCA_Agreement__c,Owner.Name,Phoenix_RCA_Agreement__r.Name,GPO1__c,Wholesaler1__c,Wholesaler_DC_1__c,OwnerId from Account where ID IN:accIds]);  
        }
        
        
        
        for(Phoenix_RCA_IPA_LINE__c rc:memberList){
            Phoenix_RCA_IPA_LINE__c rca=new Phoenix_RCA_IPA_LINE__c();
            rca=rc;
           
            if(accmap.get(rc.Phoenix_Customer__c)!=null){
                rca.Phoenix_Current_Wholesaler__c=accmap.get(rc.Phoenix_Customer__c).Wholesaler1__c;
                rca.Phoenix_Current_GPO__c=accmap.get(rc.Phoenix_Customer__c).GPO1__c;
                rca.Phoenix_RAM__c=accmap.get(rc.Phoenix_Customer__c).OwnerId;
                
            }
            
            memberListCopy.add(rca);
        }
        
        if(memberListCopy.size()>0){
            insert memberListCopy;  
            
        }
        return memberListCopy;
    }
    
    @AuraEnabled
    public static Wrapper processRCALine(Id bidId){
        
        Wrapper wr=new Wrapper();
        Phoenix_Bid__c bid=[select Id,Phoenix_Bid_Type__c,Phoenix_RCA_Change_Date__c,Phoenix_RCA_Agreement__c,Phoenix_RCA_Agreement__r.Name from Phoenix_Bid__c where Id=:bidId limit 1];
        system.debug('bid-------'+bid);
        Phoenix_RCA_IPA_LINE__c rcItem=new Phoenix_RCA_IPA_LINE__c(Phoenix_Bid__c=bid.Id,Phoenix_RCA_Change_Date__c=bid.Phoenix_RCA_Change_Date__c,Phoenix_RCA_Agreement__c=bid.Phoenix_RCA_Agreement__c);   
        
        wr.rcItem=rcItem;
        wr.bidRecord=bid;
        wr.flag=true;
        
        return wr;
        
    }
    
    @AuraEnabled
    public static Wrapper getRCAmemberInfo(string accountId,string customerLookupId){
        
        
        Wrapper wrapperObject=new Wrapper();
        
        
        
        if(string.isNotBlank(accountId)){
            
            Account accRecord=[select Id,Street_Address_1__c,State__c,City__c,DEA__c,Zip__c,Name,Phoenix_RCA_Agreement__c,Owner.Name,Phoenix_RCA_Agreement__r.Name,GPO1__c,Wholesaler1__c,Wholesaler_DC_1__c,OwnerId from Account where Id=:accountId limit 1];  
            wrapperObject.accRecord=accRecord;
            
        }
        
        if(string.isNotBlank(customerLookupId)){
            
            Account accRecord1=[select Id,Street_Address_1__c,State__c,City__c,DEA__c,Zip__c,Name,Phoenix_RCA_Agreement__c,Owner.Name,Phoenix_RCA_Agreement__r.Name,GPO1__c,Wholesaler1__c,Wholesaler_DC_1__c,OwnerId from Account where Id=:customerLookupId limit 1];  
            wrapperObject.accRecord1=accRecord1;
            
        }
        
        
        
        return wrapperObject;
    }
    @AuraEnabled 
    public static PicklistWrapper getDependentPicklist() {
        Map<String,List<String>> pickListMap = new Map<String,List<String>>();
        List<String> GPOvalues = new List<String>();
        List < String > StateValues = new List < String > ();
        PicklistWrapper pw = new PicklistWrapper();
        pw.pickListMap = pickListMap;
        
        
        
        Schema.sObjectType objType = Schema.getGlobalDescribe().get('Phoenix_RCA_IPA_LINE__c').newSObject().getSObjectType();
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
        if (!objFieldMap.containsKey('Phoenix_Wholesaler__c') || !objFieldMap.containsKey('Phoenix_Wholesaler_Location__c')){
            return pw;     
        }
        
        List<PicklistEntryWrapper> depEntries = (List<PicklistEntryWrapper>)JSON.deserialize(JSON.serialize(objFieldMap.get('Phoenix_Wholesaler_Location__c').getDescribe().getPicklistValues()), List<PicklistEntryWrapper>.class);
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : objFieldMap.get('Phoenix_Wholesaler__c').getDescribe().getPicklistValues()) {
            pickListMap.put(ple.getLabel(), new List<String>());
            controllingValues.add(ple.getLabel());
        }
        
        for (PicklistEntryWrapper plew : depEntries) {
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    pickListMap.get(controllingValues.get(i)).add(plew.label);
                }
            }
        }
        Schema.DescribeFieldResult fieldResult = Phoenix_RCA_IPA_LINE__c.Phoenix_New_GPO__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
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
        pw.GPOvalues=GPOvalues;
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
    
    public class PicklistWrapper{
        @AuraEnabled
        public Map<String, List<String>> pickListMap;
        @AuraEnabled
        public String parentFieldLabel;
        @AuraEnabled
        public String childFieldLabel;
        @AuraEnabled
        public list<String> GPOvalues ;
        @AuraEnabled
        public list < String > StateValues;
    }
    
    public class PicklistEntryWrapper{
        public String active;
        public String defaultValue;
        public String label;
        public String value;
        public String validFor;
        
    }
    
    
    public class Wrapper{
        
        @AuraEnabled public Phoenix_RCA_IPA_LINE__c rcItem ;
        @AuraEnabled public list<Phoenix_RCA_IPA_LINE__c>rcItemList;
             @AuraEnabled public list<Account>Allaccounts;
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        @AuraEnabled public Account accRecord;
          @AuraEnabled public Account accRecord1;
        @AuraEnabled public Boolean flag;
        @AuraEnabled public Boolean rcaContract;
        
        Wrapper(){
            rcItemList=new list<Phoenix_RCA_IPA_LINE__c>();
            rcItem = new Phoenix_RCA_IPA_LINE__c();
            Allaccounts=new list<Account>();
            bidRecord=new Phoenix_Bid__c();
            accRecord=new Account();
             accRecord1=new Account();
            
        }
    }
}