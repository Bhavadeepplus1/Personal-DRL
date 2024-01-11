@isTest
public class ReuseQuarterDataClsTest {
    
    @isTest
    public static void test1()
    {
        
        Achievement_Summary_Table__c ac1 = new Achievement_Summary_Table__c();
        ac1.Name = 'CB-1200491';
        ac1.Sales_Rep_Name__c= 'Doris Hartell';
        ac1.Direct_Sales_Billing_Date__c = Date.newInstance(2023, 01, 27);
        ac1.Direct_Sales__c= 1608199.82;
        ac1.soldToRebatePercent__c='155781';
        ac1.Region__c='West';
        ac1.DateToConsider__c=Date.newInstance(2023, 07, 27);
        ac1.Indirect_Sales__c=12;
            
        insert ac1;

        Achievement_Summary_Table__c ac2 = new Achievement_Summary_Table__c();
        ac2.Name = 'CB-1200491';
        ac2.Sales_Rep_Name__c= 'Doris Hartell';
        ac2.Direct_Sales_Billing_Date__c = Date.newInstance(2023, 12, 27);
        ac2.Direct_Sales__c= 1608199.82;
        ac2.soldToRebatePercent__c='1234';
        ac2.Region__c='East';
        ac2.DateToConsider__c=Date.newInstance(2023, 01, 27);
        ac2.Indirect_Sales__c=12;
        
        insert ac2;
        
        
        Achievement_Summary_Table__c ac3 = new Achievement_Summary_Table__c();
        ac3.Name = 'CB-1200491';
        ac3.Sales_Rep_Name__c= 'Heather Harris';
        ac3.Direct_Sales_Billing_Date__c = Date.newInstance(2023, 04, 27);
        ac3.Direct_Sales__c= 1608199.82;
        ac3.soldToRebatePercent__c='1234';
        ac3.Region__c='East';
        ac3.DateToConsider__c=Date.newInstance(2023, 03, 15);
        ac3.Indirect_Sales__c=12;
        
        insert ac3;
        
        Achievement_Summary_Table__c ac4 = new Achievement_Summary_Table__c();
        ac4.Name = 'CB-1200491';
        ac4.Sales_Rep_Name__c= 'Mike Alfino';
        ac4.Direct_Sales_Billing_Date__c = Date.newInstance(2023, 07, 27);
        ac4.Direct_Sales__c= 1608199.82;
        ac4.soldToRebatePercent__c='1234';
        ac4.Region__c='East';
        ac4.DateToConsider__c=Date.newInstance(2023, 09, 10);
        ac4.Indirect_Sales__c=12;
        
        insert ac4;
         List<AchievementSummaryTableCls.wrapperClass> westwrapData = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
         List<AchievementSummaryTableCls.wrapperClass> eastwrapData = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
        
        ReuseQuarterDataCls.percentCalculate(1100.20,10000);
        ReuseQuarterDataCls.returnQuartData1();
        ReuseQuarterDataCls.returnQuartData2();
        ReuseQuarterDataCls.returnQuartData3();
        ReuseQuarterDataCls.returnQuartData4();
    }

}