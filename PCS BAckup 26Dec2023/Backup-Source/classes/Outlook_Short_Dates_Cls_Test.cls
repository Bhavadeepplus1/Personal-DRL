@isTest
public class Outlook_Short_Dates_Cls_Test {
    static testmethod void  test(){
        Account acc = new Account();
        acc.Name = 'Walgreen Company';
        insert acc;
        String accId = acc.Id;
        Vision_GCP_Short_Date__c  sd =new Vision_GCP_Short_Date__c();
        sd.Vision_Customer__c = acc.Id;
        sd.GCP_Customer_Name__c = 'Amazon';
        sd.GCP_Product_Family__c = 'Leo';
        // sd.Last_Month_Written_Off_Cost__c = 345
        sd.Vision_M1_Potential_Write_Off__c =33;
        sd.Vision_M2_Potential_Write_Off__c =33;
        sd.Vision_M3_Potential_Write_Off__c =33;
        insert sd;
        Vision_GCP_Short_Date__c  sd1 =new Vision_GCP_Short_Date__c();
        sd1.Vision_Customer__c = acc.Id;
        sd1.GCP_Customer_Name__c = 'Amazon';
        sd1.GCP_Product_Family__c = 'Leo';
        // sd.Last_Month_Written_Off_Cost__c = 345;
        sd1.Vision_M1_Potential_Write_Off__c = 23;
        insert sd1;
        Outlook_Short_Dates_Cls.getAccountGroups();
        Outlook_Short_Dates_Cls.getShortDateData('Amazon');
        // Vision_GCP_Short_DateCls.getFiltershortDate('test','test');
    }
    
}