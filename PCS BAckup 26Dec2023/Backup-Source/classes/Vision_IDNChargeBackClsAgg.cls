public class Vision_IDNChargeBackClsAgg{
    @AuraEnabled(Cacheable=true)
    public static list<string> getHospitalNames(){
        set<string> hospitalnames = new set<string>();
      //  system.debug('hospitalname---'+hospitalname);
        //if(hospitalname == null){
        string name1  = UserInfo.getName();
       // list<string> names =[select name from User where id =:userid];
        list<AggregateResult > chargebackList = [select Hospital_Name__c ,count(ID) from  IDN_Charge_Back__c where Sales_Rep_Territory__c = : name1 Group by Hospital_Name__c ];
           list<IDN_Charge_Back__c > chargebackList11 = [select Hospital_Name__c  from  IDN_Charge_Back__c where Sales_Rep_Territory__c = : name1];  
        for(AggregateResult  ss:chargebackList){
           hospitalnames.add((String)ss.get('Hospital_Name__c'));
       }
       // }
       // else {
    // AggregateResult[] results = [SELECT count(Id), Hospital_Name__c  FROM IDN_Charge_Back__c GROUP BY Hospital_Name__c limit 10000];
//List<String> uniqueNames = new List<String>();
//for (IDN_Charge_Back__c result : results) {
///uniqueNames.add((String)result.get('Hospital_Name__c'));
//}
system.debug(hospitalnames.size());
        system.debug(hospitalnames);
        List<String> hospitalnameslist = new List<String>(hospitalnames);
         system.debug(hospitalnameslist);
        return hospitalnameslist;
    }
}