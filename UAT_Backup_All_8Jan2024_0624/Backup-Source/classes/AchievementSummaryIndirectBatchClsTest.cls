@isTest
public class AchievementSummaryIndirectBatchClsTest {
    
    @isTest
    public static void test1(){
        
        list<IDN_Charge_Back__c> idnlist = new list<IDN_Charge_Back__c>{};
        IDN_Charge_Back__c idn1 = new IDN_Charge_Back__c();
        idn1.Sales_Rep_Territory__c='Heather Harris';
        idn1.Contract_Sales_Indirect_Price__c=33.72;
        idn1.Exclude_Flag__c = 'N';
        idn1.Settlement_Paid_Date__c = system.today();
        idnlist.add(idn1);
        
        IDN_Charge_Back__c idn2 = new IDN_Charge_Back__c();
        idn2.Sales_Rep_Territory__c='Andre White';
        idn2.Contract_Sales_Indirect_Price__c=165.9;
        idn2.Exclude_Flag__c = 'N';
        idn2.Settlement_Paid_Date__c = system.today().addmonths(-1);
        idnlist.add(idn2);
        
        IDN_Charge_Back__c idn4 = new IDN_Charge_Back__c();
        idn4.Sales_Rep_Territory__c='Michael Alfino';
        idn4.Contract_Sales_Indirect_Price__c=165.9;
        idn4.Exclude_Flag__c = 'N';
        idn4.Settlement_Paid_Date__c = system.today().addmonths(-1);
        insert idn4;
        
        IDN_Charge_Back__c idn5 = new IDN_Charge_Back__c();
        idn5.Sales_Rep_Territory__c='Eric Sutherland';
        idn5.Contract_Sales_Indirect_Price__c=165.9;
        idn5.Exclude_Flag__c = 'N';
        idn5.Settlement_Paid_Date__c = system.today().addmonths(-1);
        insert idn5;
        
        IDN_Charge_Back__c idn6 = new IDN_Charge_Back__c();
        idn6.Sales_Rep_Territory__c='William Toupe';
        idn6.Contract_Sales_Indirect_Price__c=165.9;
        idn6.Exclude_Flag__c = 'N';
        idn6.Settlement_Paid_Date__c = system.today().addmonths(-1);
        insert idn6;
        
        IDN_Charge_Back__c idn7 = new IDN_Charge_Back__c();
        idn7.Sales_Rep_Territory__c='Nathan Cumme';
        idn7.Contract_Sales_Indirect_Price__c=165.9;
        idn7.Exclude_Flag__c = 'N';
        idn7.Settlement_Paid_Date__c = system.today().addmonths(-1);
        insert idn7;
        
        IDN_Charge_Back__c idn8 = new IDN_Charge_Back__c();
        idn8.Sales_Rep_Territory__c='Angela Hattaway';
        idn8.Contract_Sales_Indirect_Price__c=165.9;
        idn8.Exclude_Flag__c = 'N';
        idn8.Settlement_Paid_Date__c = system.today().addmonths(-1);
        insert idn8;
        
        IDN_Charge_Back__c idn9 = new IDN_Charge_Back__c();
        idn9.Sales_Rep_Territory__c='Erica Bass';
        idn9.Contract_Sales_Indirect_Price__c=165.9;
        idn9.Exclude_Flag__c = 'N';
        idn9.Settlement_Paid_Date__c = system.today().addmonths(-1);
        insert idn9;
        
        IDN_Charge_Back__c idn10 = new IDN_Charge_Back__c();
        idn10.Sales_Rep_Territory__c='Heather Harris';
        idn10.Contract_Sales_Indirect_Price__c=165.9;
        idn10.Exclude_Flag__c = 'N';
        idn10.Settlement_Paid_Date__c = system.today().addmonths(-1);
        insert idn10;
        
        IDN_Charge_Back__c idn11 = new IDN_Charge_Back__c();
        idn11.Sales_Rep_Territory__c='Doris Hartell';
        idn11.Contract_Sales_Indirect_Price__c=165.9;
        idn11.Exclude_Flag__c = 'N';
        idn11.Settlement_Paid_Date__c = system.today().addmonths(-1);
        insert idn11;
        
        insert idnlist;
        
        Achievement_Summary_Table__c ac1 = new Achievement_Summary_Table__c();
        ac1.Name = 'CB-1200491';
        ac1.Sales_Rep_Name__c= 'Andre White';
        ac1.Direct_Sales_Billing_Date__c = date.newinstance(2023, 04, 14);
        ac1.Direct_Sales__c= 1608199.82;
        ac1.Indirect_Sales__c = 1413629.43;
        ac1.Unique_Identifier__c = 'Doris Hartell_2022_12';
        insert ac1;
        
        Achievement_Summary_Table__c ac3 = new Achievement_Summary_Table__c();
        ac3.Name = 'CB-120491';
        ac3.Sales_Rep_Name__c= 'Dave Smith';
        ac3.Direct_Sales_Billing_Date__c = date.newinstance(2023, 04, 14);
        ac3.Direct_Sales__c= 160199.82;
        ac3.Indirect_Sales__c = 1413629.43;
        ac3.Unique_Identifier__c = 'Dave Smith_2022_12';
        insert ac3;
        
        Achievement_Summary_Table__c ac4 = new Achievement_Summary_Table__c();
        ac4.Name = 'CB-120491';
        ac4.Sales_Rep_Name__c= 'Kristi Dodge';
        ac4.Direct_Sales_Billing_Date__c = date.newinstance(2023, 04, 14);
        ac4.Direct_Sales__c= 160199.82;
        ac4.Indirect_Sales__c = 1413629.43;
        ac4.Unique_Identifier__c = 'Kristi Dodge_2022_12';
        insert ac4;
        
        
        
        Achievement_Summary_Table__c ac2 = new Achievement_Summary_Table__c();
        ac2.Name = 'CB-1200491';
        ac2.Sales_Rep_Name__c= 'Nathan Cumme';
        ac2.Direct_Sales_Billing_Date__c = date.newinstance(2023, 09, 11);
        ac2.Direct_Sales__c= 16082.82;
        ac2.Indirect_Sales__c = 145629.43;
        ac2.Unique_Identifier__c = 'Nathan Cumme_2023_3';
        insert ac2;
        
        
        
        AchievementSummaryIndirectBatchCls batchjob = new AchievementSummaryIndirectBatchCls();
        DataBase.executeBatch(batchjob); 
        
        AchievementSummaryIndirectBatchCls batchjob1 = new AchievementSummaryIndirectBatchCls();
        DataBase.executeBatch(batchjob1); 
        
    }
    
     @isTest
    public static void test3(){
        
        IDN_Charge_Back__c idn1 = new IDN_Charge_Back__c();
        idn1.Sales_Rep_Territory__c='Dave Smith';
        idn1.Contract_Sales_Indirect_Price__c=33.72;
        idn1.Exclude_Flag__c = 'N';
        idn1.Settlement_Paid_Date__c = system.today();
        insert idn1;
        
        IDN_Charge_Back__c idn2 = new IDN_Charge_Back__c();
        idn2.Sales_Rep_Territory__c='Andre White';
        idn2.Contract_Sales_Indirect_Price__c=165.9;
        idn2.Exclude_Flag__c = 'N';
        idn2.Settlement_Paid_Date__c = system.today().addmonths(-2);
        insert idn2;
        
        IDN_Charge_Back__c idn3 = new IDN_Charge_Back__c();
        idn3.Sales_Rep_Territory__c='Andre White';
        idn3.Contract_Sales_Indirect_Price__c=195.9;
        idn3.Exclude_Flag__c = 'N';
        idn3.Settlement_Paid_Date__c = system.today().addmonths(-2);
        insert idn3;
        
        Achievement_Summary_Table__c ac3 = new Achievement_Summary_Table__c();
        ac3.Name = 'CB-120491';
        ac3.Sales_Rep_Name__c= 'Dave Smith';
        ac3.Direct_Sales_Billing_Date__c = date.newinstance(2023, 04, 14);
        ac3.Direct_Sales__c= 160199.82;
        ac3.Indirect_Sales__c = 1413629.43;
        ac3.Unique_Identifier__c = 'Dave Smith_2022_12';
        insert ac3;
        
        AchievementSummaryIndirectBatchCls batchjob = new AchievementSummaryIndirectBatchCls();
        DataBase.executeBatch(batchjob); 
        
    }
    
    @isTest
    public static void test4(){
        
        IDN_Charge_Back__c idn1 = new IDN_Charge_Back__c();
        idn1.Sales_Rep_Territory__c='Kristi Dodge';
        idn1.Contract_Sales_Indirect_Price__c=33.72;
        idn1.Exclude_Flag__c = 'N';
        idn1.Settlement_Paid_Date__c = system.today();
        insert idn1;
        
        IDN_Charge_Back__c idn2 = new IDN_Charge_Back__c();
        idn2.Sales_Rep_Territory__c='Andre White';
        idn2.Contract_Sales_Indirect_Price__c=165.9;
        idn2.Exclude_Flag__c = 'N';
        idn2.Settlement_Paid_Date__c = system.today().addmonths(-2);
        insert idn2;
        
        IDN_Charge_Back__c idn3 = new IDN_Charge_Back__c();
        idn3.Sales_Rep_Territory__c='Andre White';
        idn3.Contract_Sales_Indirect_Price__c=195.9;
        idn3.Exclude_Flag__c = 'N';
        idn3.Settlement_Paid_Date__c = system.today().addmonths(-2);
        insert idn3;
        
        Achievement_Summary_Table__c ac4 = new Achievement_Summary_Table__c();
        ac4.Name = 'CB-120491';
        ac4.Sales_Rep_Name__c= 'Kristi Dodge';
        ac4.Direct_Sales_Billing_Date__c = date.newinstance(2023, 04, 14);
        ac4.Direct_Sales__c= 160199.82;
        ac4.Indirect_Sales__c = 1413629.43;
        ac4.Unique_Identifier__c = 'Kristi Dodge_2022_12';
        insert ac4;
        
        AchievementSummaryIndirectBatchCls batchjob = new AchievementSummaryIndirectBatchCls();
        DataBase.executeBatch(batchjob); 
    }
    
    @isTest
    public static void test5()
    {
        IDN_Charge_Back__c idn1 = new IDN_Charge_Back__c();
        idn1.Sales_Rep_Territory__c='Susan Belleavoine';
        idn1.Contract_Sales_Indirect_Price__c=33.72;
        idn1.Exclude_Flag__c = 'N';
        idn1.Settlement_Paid_Date__c = system.today();
        insert idn1;
        
        IDN_Charge_Back__c idn2 = new IDN_Charge_Back__c();
        idn2.Sales_Rep_Territory__c='Andre White';
        idn2.Contract_Sales_Indirect_Price__c=165.9;
        idn2.Exclude_Flag__c = 'N';
        idn2.Settlement_Paid_Date__c = system.today().addmonths(-2);
        insert idn2;
        
        IDN_Charge_Back__c idn3 = new IDN_Charge_Back__c();
        idn3.Sales_Rep_Territory__c='Andre White';
        idn3.Contract_Sales_Indirect_Price__c=195.9;
        idn3.Exclude_Flag__c = 'N';
        idn3.Settlement_Paid_Date__c = system.today().addmonths(-2);
        insert idn3;
        
        Achievement_Summary_Table__c ac4 = new Achievement_Summary_Table__c();
        ac4.Name = 'CB-120491';
        ac4.Sales_Rep_Name__c= 'Susan Belleavoine';
        ac4.Direct_Sales_Billing_Date__c = date.newinstance(2023, 04, 14);
        ac4.Direct_Sales__c= 160199.82;
        ac4.Indirect_Sales__c = 1413629.43;
        ac4.Unique_Identifier__c = 'Susan Belleavoine_2022_12';
        insert ac4;
        
        AchievementSummaryIndirectBatchCls batchjob = new AchievementSummaryIndirectBatchCls();
        DataBase.executeBatch(batchjob); 
    }
    
    @isTest
    public static void test6()
    {
        IDN_Charge_Back__c idn1 = new IDN_Charge_Back__c();
        idn1.Sales_Rep_Territory__c='Erica Bass';
        idn1.Contract_Sales_Indirect_Price__c=33.72;
        idn1.Exclude_Flag__c = 'N';
        idn1.Settlement_Paid_Date__c = system.today();
        insert idn1;
        
        IDN_Charge_Back__c idn2 = new IDN_Charge_Back__c();
        idn2.Sales_Rep_Territory__c='Andre White';
        idn2.Contract_Sales_Indirect_Price__c=165.9;
        idn2.Exclude_Flag__c = 'N';
        idn2.Settlement_Paid_Date__c = system.today().addmonths(-2);
        insert idn2;
        
                
        Achievement_Summary_Table__c ac4 = new Achievement_Summary_Table__c();
        ac4.Name = 'CB-120491';
        ac4.Sales_Rep_Name__c= 'Erica Bass';
        ac4.Direct_Sales_Billing_Date__c = date.newinstance(2023, 04, 14);
        ac4.Direct_Sales__c= 160199.82;
        ac4.Indirect_Sales__c = 1413629.43;
        ac4.Unique_Identifier__c = 'Erica Bass_2022_12';
        insert ac4;
        
        AchievementSummaryIndirectBatchCls batchjob = new AchievementSummaryIndirectBatchCls();
        DataBase.executeBatch(batchjob); 
    }
    
    public static void test7()
    {
        IDN_Charge_Back__c idn1 = new IDN_Charge_Back__c();
        idn1.Sales_Rep_Territory__c='Eric Sutherland';
        idn1.Contract_Sales_Indirect_Price__c=33.72;
        idn1.Exclude_Flag__c = 'N';
        idn1.Settlement_Paid_Date__c = system.today();
        insert idn1;
        
        IDN_Charge_Back__c idn2 = new IDN_Charge_Back__c();
        idn2.Sales_Rep_Territory__c='Andre White';
        idn2.Contract_Sales_Indirect_Price__c=165.9;
        idn2.Exclude_Flag__c = 'N';
        idn2.Settlement_Paid_Date__c = system.today().addmonths(-2);
        insert idn2;
        
        
        
        Achievement_Summary_Table__c ac4 = new Achievement_Summary_Table__c();
        ac4.Name = 'CB-120491';
        ac4.Sales_Rep_Name__c= 'Eric Sutherland';
        ac4.Direct_Sales_Billing_Date__c = date.newinstance(2023, 04, 14);
        ac4.Direct_Sales__c= 160199.82;
        ac4.Indirect_Sales__c = 1413629.43;
        ac4.Unique_Identifier__c = 'Eric Sutherland_2022_12';
        insert ac4;
        
        AchievementSummaryIndirectBatchCls batchjob = new AchievementSummaryIndirectBatchCls();
        DataBase.executeBatch(batchjob); 
    }
    
    @isTest
    public static void test2()
    {
        
        list<IDN_Charge_Back__c> idnlist = new list<IDN_Charge_Back__c>{};
        IDN_Charge_Back__c idn1 = new IDN_Charge_Back__c();
        idn1.Sales_Rep_Territory__c='Heather Harris';
        idn1.Contract_Sales_Indirect_Price__c=33.72;
        idn1.Exclude_Flag__c = 'N';
        idn1.Settlement_Paid_Date__c = system.today();
        idnlist.add(idn1);
        
        IDN_Charge_Back__c idn2 = new IDN_Charge_Back__c();
        idn2.Sales_Rep_Territory__c='Andre White';
        idn2.Contract_Sales_Indirect_Price__c=165.9;
        idn2.Exclude_Flag__c = 'N';
        idn2.Settlement_Paid_Date__c = system.today().addmonths(-2);
        idnlist.add(idn2);
        
        IDN_Charge_Back__c idn3 = new IDN_Charge_Back__c();
        idn3.Sales_Rep_Territory__c='Andre White';
        idn3.Contract_Sales_Indirect_Price__c=195.9;
        idn3.Exclude_Flag__c = 'N';
        idn3.Settlement_Paid_Date__c = system.today().addmonths(-2);
        idnlist.add(idn3);
        
        IDN_Charge_Back__c idn4 = new IDN_Charge_Back__c();
        idn4.Sales_Rep_Territory__c='Andre White';
        idn4.Contract_Sales_Indirect_Price__c=165.9;
        idn4.Exclude_Flag__c = 'N';
        idn4.Settlement_Paid_Date__c = system.today().addmonths(-3);
        idnlist.add(idn4);
        
        
        IDN_Charge_Back__c idn6 = new IDN_Charge_Back__c();
        idn6.Sales_Rep_Territory__c='William Toupe';
        idn6.Contract_Sales_Indirect_Price__c=195.9;
        idn6.Exclude_Flag__c = 'N';
        idn6.Settlement_Paid_Date__c = system.today().addmonths(-2);
        idnlist.add(idn6);
        
        IDN_Charge_Back__c idn7 = new IDN_Charge_Back__c();
        idn7.Sales_Rep_Territory__c='William Toupe';
        idn7.Contract_Sales_Indirect_Price__c=165.9;
        idn7.Exclude_Flag__c = 'N';
        idn7.Settlement_Paid_Date__c = system.today().addmonths(-3);
        idnlist.add(idn7);
        
        IDN_Charge_Back__c idn8 = new IDN_Charge_Back__c();
        idn8.Sales_Rep_Territory__c='Eric Sutherland';
        idn8.Contract_Sales_Indirect_Price__c=195.9;
        idn8.Exclude_Flag__c = 'N';
        idn8.Settlement_Paid_Date__c = system.today().addmonths(-2);
        idnlist.add(idn8);
        
        IDN_Charge_Back__c idn9 = new IDN_Charge_Back__c();
        idn9.Sales_Rep_Territory__c='Eric Sutherland';
        idn9.Contract_Sales_Indirect_Price__c=165.9;
        idn9.Exclude_Flag__c = 'N';
        idn9.Settlement_Paid_Date__c = system.today().addmonths(-3);
        idnlist.add(idn9);
        
        IDN_Charge_Back__c idn10 = new IDN_Charge_Back__c();
        idn10.Sales_Rep_Territory__c='Michael Alfino';
        idn10.Contract_Sales_Indirect_Price__c=195.9;
        idn10.Exclude_Flag__c = 'N';
        idn10.Settlement_Paid_Date__c = system.today().addmonths(-2);
        idnlist.add(idn10);
        
        IDN_Charge_Back__c idn11 = new IDN_Charge_Back__c();
        idn11.Sales_Rep_Territory__c='Michael Alfino';
        idn11.Contract_Sales_Indirect_Price__c=165.9;
        idn11.Exclude_Flag__c = 'N';
        idn11.Settlement_Paid_Date__c = system.today().addmonths(-3);
        idnlist.add(idn11);
        
        IDN_Charge_Back__c idn12 = new IDN_Charge_Back__c();
        idn12.Sales_Rep_Territory__c='Nathan Cumme';
        idn12.Contract_Sales_Indirect_Price__c=195.9;
        idn12.Exclude_Flag__c = 'N';
        idn12.Settlement_Paid_Date__c = system.today().addmonths(-2);
        idnlist.add(idn12);
        
        IDN_Charge_Back__c idn13 = new IDN_Charge_Back__c();
        idn13.Sales_Rep_Territory__c='Nathan Cumme';
        idn13.Contract_Sales_Indirect_Price__c=165.9;
        idn13.Exclude_Flag__c = 'N';
        idn13.Settlement_Paid_Date__c = system.today().addmonths(-3);
        idnlist.add(idn13);
        
        IDN_Charge_Back__c idn14 = new IDN_Charge_Back__c();
        idn14.Sales_Rep_Territory__c='Angela Hattaway';
        idn14.Contract_Sales_Indirect_Price__c=195.9;
        idn14.Exclude_Flag__c = 'N';
        idn14.Settlement_Paid_Date__c = system.today().addmonths(-2);
        idnlist.add(idn14);
        
        IDN_Charge_Back__c idn15 = new IDN_Charge_Back__c();
        idn15.Sales_Rep_Territory__c='Angela Hattaway';
        idn15.Contract_Sales_Indirect_Price__c=165.9;
        idn15.Exclude_Flag__c = 'N';
        idn15.Settlement_Paid_Date__c = system.today().addmonths(-3);
        idnlist.add(idn15);
        
        IDN_Charge_Back__c idn16 = new IDN_Charge_Back__c();
        idn16.Sales_Rep_Territory__c='Erica Bass';
        idn16.Contract_Sales_Indirect_Price__c=195.9;
        idn16.Exclude_Flag__c = 'N';
        idn16.Settlement_Paid_Date__c = system.today().addmonths(-2);
        idnlist.add(idn16);
        
        IDN_Charge_Back__c idn17 = new IDN_Charge_Back__c();
        idn17.Sales_Rep_Territory__c='Erica Bass';
        idn17.Contract_Sales_Indirect_Price__c=165.9;
        idn17.Exclude_Flag__c = 'N';
        idn17.Settlement_Paid_Date__c = system.today().addmonths(-3);
        idnlist.add(idn17);
        
        IDN_Charge_Back__c idn18 = new IDN_Charge_Back__c();
        idn18.Sales_Rep_Territory__c='Heather Harris';
        idn18.Contract_Sales_Indirect_Price__c=195.9;
        idn18.Exclude_Flag__c = 'N';
        idn18.Settlement_Paid_Date__c = system.today().addmonths(-2);
        idnlist.add(idn18);
        
        IDN_Charge_Back__c idn19 = new IDN_Charge_Back__c();
        idn19.Sales_Rep_Territory__c='Heather Harris';
        idn19.Contract_Sales_Indirect_Price__c=165.9;
        idn19.Exclude_Flag__c = 'N';
        idn19.Settlement_Paid_Date__c = system.today().addmonths(-3);
        idnlist.add(idn19);
        
        IDN_Charge_Back__c idn20 = new IDN_Charge_Back__c();
        idn20.Sales_Rep_Territory__c='Doris Hartell';
        idn20.Contract_Sales_Indirect_Price__c=195.9;
        idn20.Exclude_Flag__c = 'N';
        idn20.Settlement_Paid_Date__c = system.today().addmonths(-2);
        idnlist.add(idn20);
        
        IDN_Charge_Back__c idn21 = new IDN_Charge_Back__c();
        idn21.Sales_Rep_Territory__c='Doris Hartell';
        idn21.Contract_Sales_Indirect_Price__c=195.9;
        idn21.Exclude_Flag__c = 'N';
        idn21.Settlement_Paid_Date__c = system.today().addmonths(-2);
        idnlist.add(idn21);

        
        IDN_Charge_Back__c idn5 = new IDN_Charge_Back__c();
        idn5.Sales_Rep_Territory__c='Susan Belleavoine';
        idn5.Contract_Sales_Indirect_Price__c=33.72;
        idn5.Exclude_Flag__c = 'N';
        idn5.Settlement_Paid_Date__c = system.today();
        idnlist.add(idn5);
        
        insert idnlist;
        
        Achievement_Summary_Table__c ac1 = new Achievement_Summary_Table__c();
        ac1.Name = 'CB-1200491';
        ac1.Sales_Rep_Name__c= 'Andre White';
        ac1.Direct_Sales_Billing_Date__c = date.newinstance(2023, 05, 14);
        ac1.Direct_Sales__c= 1608199.82;
        ac1.Indirect_Sales__c = 1413629.43;
        ac1.Unique_Identifier__c = 'Doris Hartell_2022_12';
        insert ac1;
        
        Achievement_Summary_Table__c ac4 = new Achievement_Summary_Table__c();
        ac4.Name = 'CB-120491';
        ac4.Sales_Rep_Name__c= 'Susan Belleavoine';
        ac4.Direct_Sales_Billing_Date__c = date.newinstance(2023, 04, 14);
        ac4.Direct_Sales__c= 160199.82;
        ac4.Indirect_Sales__c = 1413629.43;
        ac4.Unique_Identifier__c = 'Susan Belleavoine_2022_12';
        insert ac4;
        
        Achievement_Summary_Table__c ac2 = new Achievement_Summary_Table__c();
        ac2.Name = 'CB-1200491';
        ac2.Sales_Rep_Name__c= 'Nathan Cumme';
        ac2.Direct_Sales_Billing_Date__c = date.newinstance(2023, 08, 11);
        ac2.Direct_Sales__c= 16082.82;
        ac2.Indirect_Sales__c = 145629.43;
        ac2.Unique_Identifier__c = 'Nathan Cumme_2023_3';
        insert ac2;
        
        Achievement_Summary_Table__c ac3 = new Achievement_Summary_Table__c();
        ac3.Name = 'CB-120491';
        ac3.Sales_Rep_Name__c= 'Dave Smith';
        ac3.Direct_Sales_Billing_Date__c = date.newinstance(2023, 04, 14);
        ac3.Direct_Sales__c= 160199.82;
        ac3.Indirect_Sales__c = 1413629.43;
        ac3.Unique_Identifier__c = 'Dave Smith_2022_12';
        insert ac3;
        
        Achievement_Summary_Table__c ac5 = new Achievement_Summary_Table__c();
        ac5.Name = 'CB-120491';
        ac5.Sales_Rep_Name__c= 'Kristi Dodge';
        ac5.Direct_Sales_Billing_Date__c = date.newinstance(2023, 09, 14);
        ac5.Direct_Sales__c= 160199.82;
        ac5.Indirect_Sales__c = 1413629.43;
        ac5.Unique_Identifier__c = 'Kristi Dodge_2022_12';
        insert ac5;
        
        Achievement_Summary_Table__c ac6 = new Achievement_Summary_Table__c();
        ac6.Name = 'CB-120491';
        ac6.Sales_Rep_Name__c= 'Susan Belleavoine';
        ac6.Direct_Sales_Billing_Date__c = date.newinstance(2023, 08, 14);
        ac6.Direct_Sales__c= 160199.82;
        ac6.Indirect_Sales__c = 1413629.43;
        ac6.Unique_Identifier__c = 'Susan Belleavoine_2022_12';
        insert ac6;

        AchievementSummaryIndirectBatchCls batchjob = new AchievementSummaryIndirectBatchCls();
        DataBase.executeBatch(batchjob); 
        
        AchievementSummaryIndirectBatchCls batchjob1 = new AchievementSummaryIndirectBatchCls();
        DataBase.executeBatch(batchjob1); 
        
    }

}