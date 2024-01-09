@isTest
public class IndirectTargetExclusionClsTest {
    
    @isTest
    public static void indirectTargetExclustionTest()
    {
        
        Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
        p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        p2.Phoenix_Product_Director__c = UserInfo.getUserId();
        insert p2;
        
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
        p3.Phoenix_Product_Director__c = UserInfo.getUserId();
        p3.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        p3.Phoenix_Product_Director__c = UserInfo.getUserId();
        insert p3;
        
        Product_Family__c pd = new Product_Family__c();
        pd.Name = 'FLUPHENAZINE';
        pd.Family_Group__c = 'FLUPHENAZINE TABS';
        pd.Vision_Segment__c = 'Rx';
        pd.Vision_IsActive__c = true;
        insert pd;
        
        Product_Family__c pd1 = new Product_Family__c();
        pd1.Name = 'ALLOPURINOL';
        pd1.Family_Group__c = 'Allopurinol';
        pd1.Vision_Segment__c = 'Rx';
        pd1.Vision_IsActive__c = true;
        insert pd1;
        
        Indirect_TargetExclusion_Summary__c s1 = new Indirect_TargetExclusion_Summary__c();
        s1.Indirect_Sales_Rep_Name__c = 'Brenda Kern';
        s1.Indirect_Customer_Name__c = 'AmerisourceBergen Drug Corp.';
        s1.Indirect_Product_Family__c = 'Palonosetron Hydrochloride';
        s1.Indirect_Product__c = 'Palonosetron HCL Inj 0.25mg/5ml USA 505j';
        s1.Indirect_Sales__c=1660.8;
        s1.Indirect_Units__c = 240;
        s1.Contract__c = 'test1';
        s1.Contract_Number__c = '380991';
        //s1.Indirect_Sold_To_Rebate_Percent__c = '370468';
        s1.Indirect_Billing_Date__c = date.newinstance(2023,10,11);
        s1.Indirect_Region__c = 'East';
        insert s1;
        
        Indirect_TargetExclusion_Summary__c s2 = new Indirect_TargetExclusion_Summary__c();
        s2.Indirect_Sales_Rep_Name__c = 'Heather Harris';
        s2.Indirect_Customer_Name__c = 'Cardinal Health';
        s2.Indirect_Product_Family__c = 'Ertapenem';
        s2.Indirect_Product__c = 'Ertapenem for Inj. 1g/vial 10s';
        s2.Indirect_Sales__c=140400;
        s2.Indirect_Units__c = 7200;
        s2.Contract__c = 'test1';
        s2.Contract_Number__c = '380991';
        //s2.Direct_Sold_To_Rebate_Percent__c = '370182';
        s2.Indirect_Billing_Date__c = date.newinstance(2023,04,28);
        s2.Indirect_Region__c = 'East';
        insert s2;
        
        Indirect_TargetExclusion_Summary__c s3 = new Indirect_TargetExclusion_Summary__c();
        s3.Indirect_Sales_Rep_Name__c = 'Brenda Kern';
        s3.Indirect_Customer_Name__c = 'McKesson Financial Center Document';
        s3.Indirect_Product_Family__c = 'Bivalirudin';
        //s3.Direct_Sold_To_Rebate_Percent__c = '370468';
        s3.Indirect_Product__c = 'Bivalirudin Injection 250mg/Vial 10s USA';
        s3.Indirect_Sales__c=19680;
        s3.Indirect_Units__c = 480;
        s3.Contract__c = 'test1';
        s3.Contract_Number__c = '380991';
        s3.Indirect_Billing_Date__c = date.newinstance(2023,07,11);
        s3.Indirect_Region__c = 'East';
        insert s3;
        
        list<String> customerlist = new list<string>{'AmerisourceBergen Drug Corp.','McKesson Financial Center Document'};
        list<String> contracts = new list<string>{'test1','test2'};
        list<String> salesreps = new list<string>{'Brenda Kern','Heather Harris'};
        list<String> productList = new list<string>{'Ertapenem for Inj. 1g/vial 10s','Bivalirudin Injection 250mg/Vial 10s USA'};
            
        IndirectTargetExclusionCls.getIndirectSalesList(contracts,salesreps,customerlist,productList);
        IndirectTargetExclusionCls.CustomerSpecific_getDirectSalesList('380991','McKesson Financial Center Document','Brenda Kern',contracts,salesreps,customerlist,productList);
        IndirectTargetExclusionCls.ContractSpecific_getDirectSalesList('380991',contracts,salesreps,customerlist,productList);
        IndirectTargetExclusionCls.productFamily_getDirectSalesList('Bivalirudin','Brenda Kern','McKesson Financial Center Document','380991',contracts,salesreps,customerlist,productList);
        IndirectTargetExclusionCls.getProductNames();
        IndirectTargetExclusionCls.getSalesReps();
        IndirectTargetExclusionCls.getCustomerNames();
        IndirectTargetExclusionCls.getContracts();
        
        
    }

}