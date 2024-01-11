@istest
public class VisionPanoramaNotificationClsTest {
    static testmethod void test(){
       // Account acc = new Account();
       // acc.Vision_Customer__r.Owner.Name = 'Bha';
        Vision_Market_Share_Expansion__c obj = new Vision_Market_Share_Expansion__c();
        obj.Plan_Contract_Effective_Date__c = system.today();
        list<Vision_Market_Share_Expansion__c> l1 = new list<Vision_Market_Share_Expansion__c>(
        
        
        
        );
        l1.add(obj);
        insert l1;
    /*    Map<String, Map<String, List<Vision_Market_Share_Expansion__c>>> mapOfMktExp = new Map<String, Map<String, List<Vision_Market_Share_Expansion__c>>>();
        Map<String, List<Vision_Market_Share_Expansion__c>> mapOfMktExp1 = new  Map<String, List<Vision_Market_Share_Expansion__c>>();
        mapOfMktExp1.put('0057c000007DPNUAA4',l1);

        mapOfMktExp.put('0057c000007DPNUAA5',mapOfMktExp1);
        VisionPanoramaNotificationCls.notifyUsers(mapOfMktExp);
        
       */ 
        
    }

}