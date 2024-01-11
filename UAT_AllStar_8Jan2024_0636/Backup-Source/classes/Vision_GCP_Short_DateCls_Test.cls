@isTest
public class Vision_GCP_Short_DateCls_Test {
      static testmethod void  test(){
        //GCP_Trade_Partner_DOH_Report__c tradeDoH= new GCP_Trade_Partner_DOH_Report__c(Trade_Partner_Name__c='test Trade',Package_Description__c='testProduct');
    //insert tradeDoH;
    Vision_GCP_Short_Date__c visionShort=new Vision_GCP_Short_Date__c(GCP_Customer_Name__c='test');
          insert visionShort;
        Vision_GCP_Short_DateCls.getAccountGroups();
        Vision_GCP_Short_DateCls.getShortDateData('test');
         Vision_GCP_Short_DateCls.getFiltershortDate('test','test');
    }

}