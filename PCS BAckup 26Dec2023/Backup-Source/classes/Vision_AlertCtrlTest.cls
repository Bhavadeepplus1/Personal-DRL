@istest
public class Vision_AlertCtrlTest {
    static testmethod void setup(){
        account a = new account();
        a.name='test';
        insert a;
        Phoenix_GCP_Opportunity_Tracker__c  op = new Phoenix_GCP_Opportunity_Tracker__c();
        insert op;
        Product2 p = new Product2();
        p.Name='Abc';
        p.Phoenix_NDC_11__c='12345';
        insert p;
        GCP_SFDC_100pct_Analysis_SKU__c sku = new  GCP_SFDC_100pct_Analysis_SKU__c();
        sku.Vision_Customer__c=a.id;
        sku.Vision_Product__c=p.id;
        insert sku;
        Vision_Alert__c alert = new Vision_Alert__c();
        alert.Account__c=a.id;
        alert.GCP_Opportunity_Tracker__c =op.id;
       insert alert;
        
        Vision_Alert__c alertnull = new Vision_Alert__c();
        alert.Account__c=null;
        alert.GCP_Opportunity_Tracker__c =null;
       insert alertnull;
        
        string rid= string.valueof(sku.id);
        string rid1=string.valueof(op.id);
        Vision_AlertCtrl.fetchVisionAlertList(rid1, 'gcpItem', a.id);
        Vision_AlertCtrl.fetchVisionAlertList(rid, 'ndcItem', a.id);
        Vision_AlertCtrl.fetchVisionAlertList(rid, 'accCalendar', a.id);
        Vision_AlertCtrl.saveAlert(alert, a, rid1, 'gcpitem');
        Vision_AlertCtrl.saveAlert(alert, a, rid, 'ndcitem');
        Vision_AlertCtrl.saveAlert(alert, a, null, 'accCalendar');
   
    }
}