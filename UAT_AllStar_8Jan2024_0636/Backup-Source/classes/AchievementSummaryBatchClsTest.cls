@isTest
public class AchievementSummaryBatchClsTest {
    
    @isTest
    public static void test1()
    {
        list<Phoenix_SRx_Direct_Sales_Data__c> directsaleslist = new list<Phoenix_SRx_Direct_Sales_Data__c>{};
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata1 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata1.Phoenix_Sales_Rep__c = 'Eric Sutherland';
        Date today = System.today();
		DateTime todayDateTime = DateTime.newInstance(today.year(), today.month(), today.day());
		String todayString = todayDateTime.format('yyyy-MM-dd');
        salesdata1.Phoenix_Billing_Date__c = todayString;
        salesdata1.Phoenix_Gross__c = '1260.0';
        salesdata1.Phoenix_Sold_To_Rebate_Recipient__c='370617';
        salesdata1.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata1);
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata2 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata2.Phoenix_Sales_Rep__c = 'Dave Smith';
        Date today1 = System.today();
		DateTime todayDateTime1 = DateTime.newInstance(today1.year(), today1.month(), today1.day());
		String todayString1 = todayDateTime1.format('yyyy-MM-dd');
        salesdata2.Phoenix_Billing_Date__c = todayString1;
        salesdata2.Phoenix_Gross__c = '2520.0';
        salesdata2.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata2.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata2);
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata3 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata3.Phoenix_Sales_Rep__c = 'Erica Bass';
        Date today3 = System.today();
		DateTime todayDateTime3 = DateTime.newInstance(today3.year(), today3.month(), today3.day());
		String todayString3 = todayDateTime3.format('yyyy-MM-dd');
        salesdata3.Phoenix_Billing_Date__c = todayString1;
        salesdata3.Phoenix_Gross__c = '2520.0';
        salesdata3.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata3.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata3);
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata4 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata4.Phoenix_Sales_Rep__c = 'Susan Belleavoine';
        Date today4 = System.today();
		DateTime todayDateTime4 = DateTime.newInstance(today4.year(), today4.month(), today4.day());
		String todayString4 = todayDateTime4.format('yyyy-MM-dd');
        salesdata4.Phoenix_Billing_Date__c = todayString4;
        salesdata4.Phoenix_Gross__c = '2520.0';
        salesdata4.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata4.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata4);
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata5 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata5.Phoenix_Sales_Rep__c = 'Michael Alfino';
        Date today5 = System.today();
		DateTime todayDateTime5 = DateTime.newInstance(today5.year(), today5.month(), today5.day());
		String todayString5 = todayDateTime5.format('yyyy-MM-dd');
        salesdata5.Phoenix_Billing_Date__c = todayString5;
        salesdata5.Phoenix_Gross__c = '2520.0';
        salesdata5.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata5.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata5);
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata6 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata6.Phoenix_Sales_Rep__c = 'Nathan Cumme';
        Date today6 = System.today();
		DateTime todayDateTime6 = DateTime.newInstance(today6.year(), today6.month(), today6.day());
		String todayString6 = todayDateTime6.format('yyyy-MM-dd');
        salesdata6.Phoenix_Billing_Date__c = todayString6;
        salesdata6.Phoenix_Gross__c = '2620.0';
        salesdata6.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata6.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata6);
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata7 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata7.Phoenix_Sales_Rep__c = 'Kristi Dodge';
        Date today7 = System.today();
		DateTime todayDateTime7 = DateTime.newInstance(today7.year(), today7.month(), today7.day());
		String todayString7 = todayDateTime7.format('yyyy-MM-dd');
        salesdata7.Phoenix_Billing_Date__c = todayString7;
        salesdata7.Phoenix_Gross__c = '2720.0';
        salesdata7.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata7.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata7);
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata8 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata8.Phoenix_Sales_Rep__c = 'Angela Hattaway';
        Date today8 = System.today();
		DateTime todayDateTime8 = DateTime.newInstance(today8.year(), today8.month(), today8.day());
		String todayString8 = todayDateTime8.format('yyyy-MM-dd');
        salesdata8.Phoenix_Billing_Date__c = todayString8;
        salesdata8.Phoenix_Gross__c = '2820.0';
        salesdata8.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata8.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata8);
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata9 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata9.Phoenix_Sales_Rep__c = 'William Toupe';
        Date today9 = System.today();
		DateTime todayDateTime9 = DateTime.newInstance(today9.year(), today9.month(), today9.day());
		String todayString9 = todayDateTime9.format('yyyy-MM-dd');
        salesdata9.Phoenix_Billing_Date__c = todayString9;
        salesdata9.Phoenix_Gross__c = '2920.0';
        salesdata9.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata9.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata9);
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata10 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata10.Phoenix_Sales_Rep__c = 'Zachary McClard';
        Date today10 = System.today();
		DateTime todayDateTime10 = DateTime.newInstance(today10.year(), today10.month(), today10.day());
		String todayString10 = todayDateTime10.format('yyyy-MM-dd');
        salesdata10.Phoenix_Billing_Date__c = todayString10;
        salesdata10.Phoenix_Gross__c = '21020.0';
        salesdata10.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata10.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata10);
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata11 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata11.Phoenix_Sales_Rep__c = 'Andre White';
        Date today11 = System.today();
		DateTime todayDateTime11 = DateTime.newInstance(today11.year(), today11.month(), today11.day());
		String todayString11 = todayDateTime11.format('yyyy-MM-dd');
        salesdata11.Phoenix_Billing_Date__c = todayString11;
        salesdata11.Phoenix_Gross__c = '21120.0';
        salesdata11.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata11.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata11);
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata12 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata12.Phoenix_Sales_Rep__c = 'Brenda Kern';
        Date today12 = System.today();
		DateTime todayDateTime12 = DateTime.newInstance(today12.year(), today12.month(), today12.day());
		String todayString12 = todayDateTime12.format('yyyy-MM-dd');
        salesdata12.Phoenix_Billing_Date__c = todayString12;
        salesdata12.Phoenix_Gross__c = '21220.0';
        salesdata12.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata12.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata12);
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata13 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata13.Phoenix_Sales_Rep__c = 'Heather Harris';
        Date today13 = System.today();
		DateTime todayDateTime13 = DateTime.newInstance(today13.year(), today13.month(), today13.day());
		String todayString13 = todayDateTime13.format('yyyy-MM-dd');
        salesdata13.Phoenix_Billing_Date__c = todayString13;
        salesdata13.Phoenix_Gross__c = '21320.0';
        salesdata13.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata13.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata13);
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata14 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata14.Phoenix_Sales_Rep__c = 'Doris Hartell';
        Date today14 = System.today();
		DateTime todayDateTime14 = DateTime.newInstance(today14.year(), today14.month(), today14.day());
		String todayString14 = todayDateTime14.format('yyyy-MM-dd');
        salesdata14.Phoenix_Billing_Date__c = todayString14;
        salesdata14.Phoenix_Gross__c = '21420.0';
        salesdata14.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata14.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata14);
        
        insert directsaleslist;
        
        
        
        List<id> existingIds = new List<id>();
        Achievement_Summary_Table__c ac1 = new Achievement_Summary_Table__c();
        ac1.Name = 'CB-1200491';
        ac1.Sales_Rep_Name__c= 'Doris Hartell';
        ac1.Direct_Sales_Billing_Date__c = date.newinstance(2023, 04, 27);
        ac1.Direct_Sales__c= 1608199.82;
        insert ac1;
        existingIds.add(ac1.Id);
        
        Achievement_Summary_Table__c ac2 = new Achievement_Summary_Table__c();
        ac2.Name = 'CB-1207172';
        ac2.Sales_Rep_Name__c= 'Erica Bass';
        ac2.Direct_Sales_Billing_Date__c = date.newinstance(2023, 04, 28);
        ac2.Direct_Sales__c= 63263.91;
        insert ac2;
        existingIds.add(ac2.Id);
       
        DataBase.executeBatch(new AchievementSummaryBatchCls()); 
        AchievementSummaryBatchCls.coverageBlock();     
    }
    
    @isTest
    public static void testmethod2(){
        list<Phoenix_SRx_Direct_Sales_Data__c> directsaleslist = new list<Phoenix_SRx_Direct_Sales_Data__c>{};
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata2 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata2.Phoenix_Sales_Rep__c = 'Dave Smith';
        Date today1 = System.today().addmonths(-2);
		DateTime todayDateTime1 = DateTime.newInstance(today1.year(), today1.month(), today1.day());
		String todayString1 = todayDateTime1.format('yyyy-MM-dd');
        salesdata2.Phoenix_Billing_Date__c = todayString1;
        salesdata2.Phoenix_Gross__c = '2700.0';
        salesdata2.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata2.Phoenix_Exclude_Flag__c='NO';
        insert salesdata2;
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata3 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata3.Phoenix_Sales_Rep__c = 'Dave Smith';
        Date today2 = System.today().addmonths(-3);
		DateTime todayDateTime2 = DateTime.newInstance(today2.year(), today2.month(), today2.day());
		String todayString2 = todayDateTime2.format('yyyy-MM-dd');
        salesdata3.Phoenix_Billing_Date__c = todayString2;
        salesdata3.Phoenix_Gross__c = '2700.0';
        salesdata3.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata3.Phoenix_Exclude_Flag__c='NO';
        insert salesdata3;
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata4 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata4.Phoenix_Sales_Rep__c = 'Dave Smith';
        Date today3 = System.today().addmonths(-3);
		DateTime todayDateTime3 = DateTime.newInstance(today3.year(), today3.month(), today3.day());
		String todayString3 = todayDateTime3.format('yyyy-MM-dd');
        salesdata4.Phoenix_Billing_Date__c = todayString3;
        salesdata4.Phoenix_Gross__c = '2300.0';
        salesdata4.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata4.Phoenix_Exclude_Flag__c='NO';
        insert salesdata4;
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata5 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata5.Phoenix_Sales_Rep__c = 'Michael Alfino';
        Date today5 = System.today().addmonths(-2);
		DateTime todayDateTime5 = DateTime.newInstance(today5.year(), today5.month(), today5.day());
		String todayString5 = todayDateTime5.format('yyyy-MM-dd');
        salesdata5.Phoenix_Billing_Date__c = todayString5;
        salesdata5.Phoenix_Gross__c = '2520.0';
        salesdata5.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata5.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata5);
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata6 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata6.Phoenix_Sales_Rep__c = 'Michael Alfino';
        Date today6 = System.today().addmonths(-3);
		DateTime todayDateTime6 = DateTime.newInstance(today6.year(), today6.month(), today6.day());
		String todayString6 = todayDateTime6.format('yyyy-MM-dd');
        salesdata6.Phoenix_Billing_Date__c = todayString6;
        salesdata6.Phoenix_Gross__c = '2620.0';
        salesdata6.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata6.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata6);
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata7 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata7.Phoenix_Sales_Rep__c = 'Michael Alfino';
        Date today7 = System.today().addmonths(-3);
		DateTime todayDateTime7 = DateTime.newInstance(today7.year(), today7.month(), today7.day());
		String todayString7 = todayDateTime7.format('yyyy-MM-dd');
        salesdata7.Phoenix_Billing_Date__c = todayString7;
        salesdata7.Phoenix_Gross__c = '2720.0';
        salesdata7.Phoenix_Sold_To_Rebate_Recipient__c='370718';
        salesdata7.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata7);
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata14 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata14.Phoenix_Sales_Rep__c = 'Doris Hartell';
        Date today14 = System.today().addmonths(-3);
		DateTime todayDateTime14 = DateTime.newInstance(today14.year(), today14.month(), today14.day());
		String todayString14 = todayDateTime14.format('yyyy-MM-dd');
        salesdata14.Phoenix_Billing_Date__c = todayString14;
        salesdata14.Phoenix_Gross__c = '21420.0';
        salesdata14.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata14.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata14);
        
        //insert directsaleslist;
        
        List<id> existingIds = new List<id>();
        Achievement_Summary_Table__c ac1 = new Achievement_Summary_Table__c();
        ac1.Name = 'CB-1200491';
        ac1.Sales_Rep_Name__c= 'Doris Hartell';
        ac1.Direct_Sales_Billing_Date__c = date.newinstance(2024, 04, 27);
        ac1.Direct_Sales__c= 1602339.82;
        insert ac1;
        existingIds.add(ac1.Id);
        
        Achievement_Summary_Table__c ac2 = new Achievement_Summary_Table__c();
        ac2.Name = 'CB-1207172';
        ac2.Sales_Rep_Name__c= 'Erica Bass';
        ac2.Direct_Sales_Billing_Date__c = date.newinstance(2024, 04, 28);
        ac2.Direct_Sales__c= 292123.91;
        insert ac2;
        existingIds.add(ac2.Id);
        
        Database.executeBatch(new AchievementSummaryBatchCls());
        
        
    }
    
   

}