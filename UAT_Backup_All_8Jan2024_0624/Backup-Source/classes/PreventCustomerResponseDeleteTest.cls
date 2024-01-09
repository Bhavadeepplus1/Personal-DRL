@isTest
public class PreventCustomerResponseDeleteTest {
    static testmethod void holdandrelesebid() {
        Profile prof = [select id from profile where name  LIKE '%supply%'
                        limit 1
                       ];
        Phoenix_Customer_Response__c cr = new Phoenix_Customer_Response__c();
        cr.Phoenix_Is_Recalled__c = False;
        insert cr;
        delete cr;
    }
}