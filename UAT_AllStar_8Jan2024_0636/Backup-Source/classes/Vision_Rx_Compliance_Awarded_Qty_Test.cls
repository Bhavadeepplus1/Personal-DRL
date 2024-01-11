@isTest
public class Vision_Rx_Compliance_Awarded_Qty_Test {
    static testmethod void  test(){
        Product2 pro = new Product2();
        pro.Name ='test product';
        pro.Phoenix_Pkg_Size__c = 1;
        pro.Phoenix_NDC_11__c = '1532468';
        pro.ProductCode ='test code';
        insert pro;
        
        Account acc = new Account();
        acc.Name= 'Walgreen Company';
        insert acc;
        
        
        
        Rx_Compliance_Summary__c summaryObj = new Rx_Compliance_Summary__c();
        summaryObj.Vision_Product__c = pro.Id;
        summaryObj.Vision_Account__c = acc.Id;
        summaryObj.Vision_Package_Size__c = pro.Phoenix_Pkg_Size__c;
        summaryObj.Vision_NDC__c = pro.Phoenix_NDC_11__c;
        summaryObj.M1_Direct_Quantity__c = 10;
        summaryObj.M2_Direct_Quantity__c = 15;
        summaryObj.Is_Initial_Order__c = False;
        summaryObj.Month1__c = 'Oct 21';
        summaryObj.Month2__c = 'Nov 21';
        summaryObj.Month3__c = 'Dec 21';
        summaryObj.Month3__c = 'Jan 22';
        summaryObj.Month3__c = 'Feb 22';
        summaryObj.Month3__c = 'Mar 22';
        //summaryObj.M2_Direct_Value_Compliance__c = 10;
        //summaryObj.M2_Indirect_Value_Compliance__c = 10;
        summaryObj.M1_Direct_Net_Dollar__c = 10000;
        summaryObj.Vision_Direct_Awarded_Qty__c = 50;
        //summaryObj.M2_Total_Compliance__c = 10;
        summaryObj.Vision_Direct_Awarded_Value__c = 0;
        //summaryObj.Vision_Direct_Awarded_Value_Monthly__c = 0;
        summaryObj.Vision_Indirect_Awarded_Value__c = 1772;
        //summaryObj.Vision_Indirect_Awarded_Value_Monthly__c = 148;
        //summaryObj.Vision_Total_Awarded_Value__c = 1772;
        //summaryObj.Vision_Total_Awarded_Value_Monthly__c = 148;
        
        insert summaryObj;
        
        //String customerId='Walgreen Company';
        
        Vision_Rx_Compliance_Awarded_Qty.getComplianceData(acc.Id);
        Vision_Rx_Compliance_Awarded_Qty.getAwardedPositionData(acc.Id, pro.ProductCode);
          Vision_Rx_Compliance_Awarded_Qty.getDirectAwardedPositionData(acc.Id, pro.ProductCode);
          Vision_Rx_Compliance_Awarded_Qty.getIndirectAwardedPositionData(acc.Id, pro.ProductCode);
        Vision_Rx_Compliance_Awarded_Qty.getOnlyComplianceData(acc.Id, true, false);              
        Vision_Rx_Compliance_Awarded_Qty.getOnlyComplianceData(acc.Id, true, true); 
        Vision_Rx_Compliance_Awarded_Qty.getOnlyComplianceDataHistoricalsales(acc.Id, true, false);
        Vision_Rx_Compliance_Awarded_Qty.getOnlyComplianceDataHistoricalsales(acc.Id, true, true);
    }

}