@isTest
public class SRxDirectTgtExclusionSummaryBatchClsTest {
    
    @isTest
    public static void testmethod1()
    {
        
        Phoenix_SRx_Direct_Sales_Data__c srx1 = new Phoenix_SRx_Direct_Sales_Data__c();
        Date today1 = System.today();
		DateTime todayDateTime1= DateTime.newInstance(today1.year(), today1.month(), today1.day());
		String todayString1 = todayDateTime1.format('yyyy-MM-dd');
        srx1.Phoenix_Billing_Date__c = todayString1;
        srx1.Phoenix_Sales_Rep__c = 'Kristi Dodge';
        srx1.Phoenix_Sold_To_Rebate_Recipient__c = '107486';
        srx1.Phoenix_Product_Family__c = 'Lenalidomide';
        srx1.Phoenix_Description__c = 'Lenalidomide Capsules 25mg US 21s Bottle';
        srx1.Phoenix_Gross__c = '708000.16';
        srx1.Phoenix_Quantity_In_Units__c= '1176';
        srx1.Phoenix_Customer_Recipient_Name__c = 'Kaiser Foundation Plan of Washingto';
        srx1.Phoenix_Exclude_Flag__c = 'YES';
        insert srx1;
        
        Phoenix_SRx_Direct_Sales_Data__c srx2 = new Phoenix_SRx_Direct_Sales_Data__c();
        Date today = System.today();
		DateTime todayDateTime = DateTime.newInstance(today.year(), today.month(), today.day());
		String todayString = todayDateTime.format('yyyy-MM-dd');
        srx2.Phoenix_Billing_Date__c = todayString;
        srx2.Phoenix_Sales_Rep__c = 'Heather Harris';
        srx2.Phoenix_Sold_To_Rebate_Recipient__c = '143261';
        srx2.Phoenix_Product_Family__c = 'Lenalidomide';
        srx2.Phoenix_Description__c = 'Lenalidomide Caps 15mg US 21s Bottle';
        srx2.Phoenix_Gross__c = '52168.44';
        srx2.Phoenix_Quantity_In_Units__c= '84';
        srx2.Phoenix_Customer_Recipient_Name__c = 'Accredo Health Group, Inc';
        srx2.Phoenix_Exclude_Flag__c = 'YES';
        insert srx2;
        
        Phoenix_SRx_Direct_Sales_Data__c srx3 = new Phoenix_SRx_Direct_Sales_Data__c();
        Date today2 = System.today();
		DateTime todayDateTime2 = DateTime.newInstance(today2.year(), today2.month(), today2.day());
		String todayString2 = todayDateTime2.format('yyyy-MM-dd');
        srx3.Phoenix_Billing_Date__c = todayString2;
        srx3.Phoenix_Sales_Rep__c = 'Erica Bass';
        srx3.Phoenix_Sold_To_Rebate_Recipient__c = '143261';
        srx3.Phoenix_Product_Family__c = 'Lenalidomide';
        srx3.Phoenix_Description__c = 'Lenalidomide Caps 10mg US 28s Bottle';
        srx3.Phoenix_Gross__c = '717389.47';
        srx3.Phoenix_Quantity_In_Units__c= '28';
        srx3.Phoenix_Customer_Recipient_Name__c = 'Accredo Health Group, Inc';
        srx3.Phoenix_Exclude_Flag__c = 'YES';
        insert srx3;
        
        
        
        Target_Exclusion_Summary__c s1 = new Target_Exclusion_Summary__c();
        s1.Direct_Sales_Rep_Name__c = 'Brenda Kern';
        s1.Direct_Customer_Name__c = 'AmerisourceBergen Drug Corp.';
        //s1.Customer_Name__c ='HC Pharmacy Central INC';
        s1.Direct_Product_Family__c = 'Palonosetron Hydrochloride';
        s1.Direct_Product__c = 'Palonosetron HCL Inj 0.25mg/5ml USA 505j';
        s1.Direct_Sales__c=1660.8;
        s1.Direct_Units__c = 240;
        s1.Direct_Sold_To_Rebate_Percent__c = '370468';
        s1.Direct_Billing_Date__c = date.newinstance(2023,10,11);
        s1.Direct_Region__c = 'East';
        insert s1;
        
        Target_Exclusion_Summary__c s2 = new Target_Exclusion_Summary__c();
        s2.Direct_Sales_Rep_Name__c = 'Heather Harris';
        s2.Direct_Customer_Name__c = 'Cardinal Health';
        //s2.Customer_Name__c ='Pinnacle Distribution, Inc';
        s2.Direct_Product_Family__c = 'Ertapenem';
        s2.Direct_Product__c = 'Ertapenem for Inj. 1g/vial 10s';
        s2.Direct_Sales__c=140400;
        s2.Direct_Units__c = 7200;
        s2.Direct_Sold_To_Rebate_Percent__c = '370182';
        s2.Direct_Billing_Date__c = date.newinstance(2023,04,28);
        s2.Direct_Region__c = 'East';
        insert s2;
        
        Target_Exclusion_Summary__c s3 = new Target_Exclusion_Summary__c();
        s3.Direct_Sales_Rep_Name__c = 'Brenda Kern';
        s3.Direct_Customer_Name__c = 'McKesson Financial Center Document';
        //s3.Customer_Name__c ='HC Pharmacy Central INC';
        s3.Direct_Product_Family__c = 'Bivalirudin';
        s3.Direct_Sold_To_Rebate_Percent__c = '370468';
        s3.Direct_Product__c = 'Bivalirudin Injection 250mg/Vial 10s USA';
        s3.Direct_Sales__c=19680;
        s3.Direct_Units__c = 480;
        s3.Direct_Billing_Date__c = date.newinstance(2023,07,11);
        s3.Direct_Region__c = 'East';
        insert s3;
        
        Database.executebatch(new SRxDirectTargetExclusionSummaryBatchCls());
    }
    
    @isTest
    public static void testmethod2()
    {
        
        Phoenix_SRx_Direct_Sales_Data__c srx1 = new Phoenix_SRx_Direct_Sales_Data__c();
        Date today1 = System.today().addmonths(-1);
		DateTime todayDateTime1 = DateTime.newInstance(today1.year(), today1.month(), today1.day());
		String todayString1 = todayDateTime1.format('yyyy-MM-dd');
        srx1.Phoenix_Billing_Date__c = todayString1;
        srx1.Phoenix_Sales_Rep__c = 'Kristi Dodge';
        srx1.Phoenix_Sold_To_Rebate_Recipient__c = '107486';
        srx1.Phoenix_Product_Family__c = 'Lenalidomide';
        srx1.Phoenix_Description__c = 'Lenalidomide Capsules 25mg US 21s Bottle';
        srx1.Phoenix_Gross__c = '708000.16';
        srx1.Phoenix_Quantity_In_Units__c= '1176';
        srx1.Phoenix_Customer_Recipient_Name__c = 'Kaiser Foundation Plan of Washingto';
        srx1.Phoenix_Exclude_Flag__c = 'YES';
        insert srx1;
        
        Phoenix_SRx_Direct_Sales_Data__c srx3 = new Phoenix_SRx_Direct_Sales_Data__c();
        Date today2 = System.today().addmonths(-3);
		DateTime todayDateTime2 = DateTime.newInstance(today2.year(), today2.month(), today2.day());
		String todayString2 = todayDateTime2.format('yyyy-MM-dd');
        srx3.Phoenix_Billing_Date__c = todayString2;
        srx3.Phoenix_Sales_Rep__c = 'Kristi Dodge';
        srx3.Phoenix_Sold_To_Rebate_Recipient__c = '107486';
        srx3.Phoenix_Product_Family__c = 'Lenalidomide';
        srx3.Phoenix_Description__c = 'Lenalidomide Capsules 25mg US 21s Bottle';
        srx3.Phoenix_Gross__c = '708000.16';
        srx3.Phoenix_Quantity_In_Units__c= '1176';
        srx3.Phoenix_Customer_Recipient_Name__c = 'Kaiser Foundation Plan of Washingto';
        srx3.Phoenix_Exclude_Flag__c = 'YES';
        insert srx3;
        
        Phoenix_SRx_Direct_Sales_Data__c srx4 = new Phoenix_SRx_Direct_Sales_Data__c();
        Date today3 = System.today().addmonths(-3);
		DateTime todayDateTime3 = DateTime.newInstance(today3.year(), today3.month(), today3.day());
		String todayString3 = todayDateTime3.format('yyyy-MM-dd');
        srx4.Phoenix_Billing_Date__c = todayString3;
        srx4.Phoenix_Sales_Rep__c = 'Kristi Dodge';
        srx4.Phoenix_Sold_To_Rebate_Recipient__c = '107486';
        srx4.Phoenix_Product_Family__c = 'Lenalidomide';
        srx4.Phoenix_Description__c = 'Lenalidomide Capsules 25mg US 21s Bottle';
        srx4.Phoenix_Gross__c = '708000.16';
        srx4.Phoenix_Quantity_In_Units__c= '1176';
        srx4.Phoenix_Customer_Recipient_Name__c = 'Kaiser Foundation Plan of Washingto';
        srx4.Phoenix_Exclude_Flag__c = 'YES';
        insert srx4;
        
        Phoenix_SRx_Direct_Sales_Data__c srx2 = new Phoenix_SRx_Direct_Sales_Data__c();
        Date today4 = System.today().addmonths(-2);
		DateTime todayDateTime4 = DateTime.newInstance(today4.year(), today4.month(), today4.day());
		String todayString4 = todayDateTime4.format('yyyy-MM-dd');
        srx2.Phoenix_Billing_Date__c = todayString4;
        srx2.Phoenix_Sales_Rep__c = 'Heather Harris';
        srx2.Phoenix_Sold_To_Rebate_Recipient__c = '143261';
        srx2.Phoenix_Product_Family__c = 'Lenalidomide';
        srx2.Phoenix_Description__c = 'Lenalidomide Caps 15mg US 21s Bottle';
        srx2.Phoenix_Gross__c = '52168.44';
        srx2.Phoenix_Quantity_In_Units__c= '84';
        srx2.Phoenix_Customer_Recipient_Name__c = 'Accredo Health Group, Inc';
        srx2.Phoenix_Exclude_Flag__c = 'YES';
        insert srx2;
        
        Target_Exclusion_Summary__c s1 = new Target_Exclusion_Summary__c();
        s1.Direct_Sales_Rep_Name__c = 'Brenda Kern';
        s1.Direct_Customer_Name__c = 'AmerisourceBergen Drug Corp.';
        //s1.Customer_Name__c ='HC Pharmacy Central INC';
        s1.Direct_Product_Family__c = 'Palonosetron Hydrochloride';
        s1.Direct_Product__c = 'Palonosetron HCL Inj 0.25mg/5ml USA 505j';
        s1.Direct_Sales__c=1660.8;
        s1.Direct_Units__c = 240;
        s1.Direct_Sold_To_Rebate_Percent__c = '370468';
        s1.Direct_Billing_Date__c = date.newinstance(2023,11,11);
        s1.Direct_Region__c = 'East';
        insert s1;
        
        Target_Exclusion_Summary__c s2 = new Target_Exclusion_Summary__c();
        s2.Direct_Sales_Rep_Name__c = 'Heather Harris';
        s2.Direct_Customer_Name__c = 'Cardinal Health';
        //s2.Customer_Name__c ='Pinnacle Distribution, Inc';
        s2.Direct_Product_Family__c = 'Ertapenem';
        s2.Direct_Product__c = 'Ertapenem for Inj. 1g/vial 10s';
        s2.Direct_Sales__c=140400;
        s2.Direct_Units__c = 7200;
        s2.Direct_Sold_To_Rebate_Percent__c = '370182';
        s2.Direct_Billing_Date__c = date.newinstance(2023,06,28);
        s2.Direct_Region__c = 'East';
        insert s2;
        
        Target_Exclusion_Summary__c s3 = new Target_Exclusion_Summary__c();
        s3.Direct_Sales_Rep_Name__c = 'Brenda Kern';
        s3.Direct_Customer_Name__c = 'McKesson Financial Center Document';
        //s3.Customer_Name__c ='HC Pharmacy Central INC';
        s3.Direct_Product_Family__c = 'Bivalirudin';
        s3.Direct_Sold_To_Rebate_Percent__c = '370468';
        s3.Direct_Product__c = 'Bivalirudin Injection 250mg/Vial 10s USA';
        s3.Direct_Sales__c=19680;
        s3.Direct_Units__c = 480;
        s3.Direct_Billing_Date__c = date.newinstance(2023,03,11);
        s3.Direct_Region__c = 'East';
        insert s3;
        Database.executebatch(new SRxDirectTargetExclusionSummaryBatchCls());
        
        
    }

}