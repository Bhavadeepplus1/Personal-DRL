@istest
public class Vision_Order_Stauts_test {
    static testmethod void test(){
        Vision_GCP_SFDC_Order_Status__c cc= new Vision_GCP_SFDC_Order_Status__c();
        cc.Vision_SAP_Created_DateTime__c=system.today();
        cc.PRISM_SAP_Created_Time__c='00:00:00';
        cc.Vision_Created_Date__c=system.now();
        cc.PRISM_SAP_Created_Date__c=system.today();
        cc.Vision_GCP_Update_Date__c=system.today();
        insert cc;
    }
}