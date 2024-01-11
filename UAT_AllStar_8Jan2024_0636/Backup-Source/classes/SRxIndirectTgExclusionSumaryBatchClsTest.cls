@isTest
public class SRxIndirectTgExclusionSumaryBatchClsTest {
    @isTest
    public static void testmethod1()
    {
        list<IDN_Charge_Back__c> idnlist = new list<IDN_Charge_Back__c>{};
        IDN_Charge_Back__c idn1 = new IDN_Charge_Back__c();
        idn1.Sales_Rep_Territory__c='Heather Harris';
        idn1.Contract_Sales_Indirect_Price__c=33.72;
        idn1.Exclude_Flag__c = 'Y';
        idn1.Settlement_Paid_Date__c = system.today();
        idn1.Sold_to_Name__c = 'CARDINAL HEALTH';
        idn1.Sold_to_Number__c = '370251';
        idn1.revised_product_family__c = 'Methylprednisolone SodSuc';
        idn1.Material_Number__c = '300036946';
        idn1.contract_units_paid_qty__c = 3;
        idn1.material_description__c = 'Methylprednisolone SodSuc Inj 1g, 1ct';
        idnlist.add(idn1);
        
        IDN_Charge_Back__c idn2 = new IDN_Charge_Back__c();
        idn2.Sales_Rep_Territory__c='Andre White';
        idn2.Contract_Sales_Indirect_Price__c=165.9;
        idn2.Exclude_Flag__c = 'Y';
        idn2.Settlement_Paid_Date__c = system.today().addmonths(-1);
        idn1.Sold_to_Name__c = 'MORRIS & DICKSON CO.,LLC';
        idn1.Sold_to_Number__c = '370617';
        idn1.revised_product_family__c = 'Methylprednisolone SodSuc';
        idn1.Material_Number__c = '300036946';
        idn1.contract_units_paid_qty__c = 3;
        idn1.material_description__c = 'Methylprednisolone SodSuc Inj 1g, 1ct';
        idnlist.add(idn2);
        
        insert idnlist;
        Database.executeBatch(new SRxIndirectTgExclusionSummaryBatchCls());
        
    }
    @isTest
    public static void testmethod2()
    {
        list<IDN_Charge_Back__c> idnlist = new list<IDN_Charge_Back__c>{};
        IDN_Charge_Back__c idn1 = new IDN_Charge_Back__c();
        idn1.Sales_Rep_Territory__c='Heather Harris';
        idn1.Contract_Sales_Indirect_Price__c=33.72;
        idn1.Exclude_Flag__c = 'Y';
        idn1.Settlement_Paid_Date__c = system.today();
        idn1.Sold_to_Name__c = 'CARDINAL HEALTH';
        idn1.Sold_to_Number__c = '370251';
        idn1.revised_product_family__c = 'Methylprednisolone SodSuc';
        idn1.Material_Number__c = '300036946';
        idn1.contract_units_paid_qty__c = 3;
        idn1.material_description__c = 'Methylprednisolone SodSuc Inj 1g, 1ct';
        idnlist.add(idn1);
        
        IDN_Charge_Back__c idn2 = new IDN_Charge_Back__c();
        idn2.Sales_Rep_Territory__c='Andre White';
        idn2.Contract_Sales_Indirect_Price__c=165.9;
        idn2.Exclude_Flag__c = 'Y';
        idn2.Settlement_Paid_Date__c = system.today().addmonths(-2);
        idn1.Sold_to_Name__c = 'MORRIS & DICKSON CO.,LLC';
        idn1.Sold_to_Number__c = '370617';
        idn1.revised_product_family__c = 'Methylprednisolone SodSuc';
        idn1.Material_Number__c = '300036946';
        idn1.contract_units_paid_qty__c = 3;
        idn1.material_description__c = 'Methylprednisolone SodSuc Inj 1g, 1ct';
        idnlist.add(idn2);
        
        IDN_Charge_Back__c idn3 = new IDN_Charge_Back__c();
        idn3.Sales_Rep_Territory__c='Andre White';
        idn3.Contract_Sales_Indirect_Price__c=195.9;
        idn3.Exclude_Flag__c = 'Y';
        idn3.Settlement_Paid_Date__c = system.today().addmonths(-2);
        idn1.Sold_to_Name__c = 'MORRIS & DICKSON CO.,LLC';
        idn1.Sold_to_Number__c = '370617';
        idn1.revised_product_family__c = 'Methylprednisolone SodSuc';
        idn1.Material_Number__c = '300036946';
        idn1.contract_units_paid_qty__c = 3;
        idn1.material_description__c = 'Methylprednisolone SodSuc Inj 1g, 1ct';
        idnlist.add(idn3);
        
        IDN_Charge_Back__c idn4 = new IDN_Charge_Back__c();
        idn4.Sales_Rep_Territory__c='Andre White';
        idn4.Contract_Sales_Indirect_Price__c=165.9;
        idn4.Exclude_Flag__c = 'Y';
        idn4.Settlement_Paid_Date__c = system.today().addmonths(-3);
        idn1.Sold_to_Name__c = 'MORRIS & DICKSON CO.,LLC';
        idn1.Sold_to_Number__c = '370617';
        idn1.revised_product_family__c = 'Methylprednisolone SodSuc';
        idn1.Material_Number__c = '300036946';
        idn1.contract_units_paid_qty__c = 3;
        idn1.material_description__c = 'Methylprednisolone SodSuc Inj 1g, 1ct';
        idnlist.add(idn4);
        
        insert idnlist;
        
        Database.executeBatch(new SRxIndirectTgExclusionSummaryBatchCls());
    }

}