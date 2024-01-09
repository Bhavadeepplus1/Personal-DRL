@isTest
public class IndirectSalesDataClsTest {
    
    @isTest
    public static void test1()
    {
        String salesRepName = 'TestSalesRep';
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            UserName = 'testuser@example.com',
            Alias = 'TUser',
            CommunityNickname = 'testuser',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );

        //insert testUser;
        //String userId = DirectSalesDataCls.getuser(salesRepName);
        //System.assertNotEquals('', userId, 'User ID should not be empty');
        
        //String userName = DirectSalesDataCls.getuserName(testUser.Id);
        //System.assertNotEquals('', userName, 'User Name should not be empty');
        
        
        
        
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
        
        SRx_IndirectSales_Summary_Table__c s1 = new SRx_IndirectSales_Summary_Table__c();
        s1.Sales_Rep_Name__c = 'Brenda Kern';
        s1.Hospital_Name__c = 'FRESNO COMM MC MAIL ORDER PHY (SAP)';
        //s1.Customer_Name__c ='HC Pharmacy Central INC';
        s1.Product_Family__c = 'Palonosetron Hydrochloride';
        s1.Product__c = 'Palonosetron HCL Inj 0.25mg/5ml USA 505j';
        s1.Sales__c=1660.8;
        s1.Units__c = 240;
        s1.Contract__c = 'Test1';
        s1.Contract_Number__c = '380991';
        s1.Settlement_Paid_Date__c = date.newinstance(2023,10,11);
        s1.Region__c = 'East';
        insert s1;
        
        SRx_IndirectSales_Summary_Table__c s2 = new SRx_IndirectSales_Summary_Table__c();
        s2.Sales_Rep_Name__c = 'Heather Harris';
        s2.Hospital_Name__c = 'MERCY HEALTH CENTER PHCY (SAP)';
        //s2.Customer_Name__c ='Pinnacle Distribution, Inc';
        s2.Product_Family__c = 'Ertapenem';
        s2.Product__c = 'Ertapenem for Inj. 1g/vial 10s';
        s2.Sales__c=140400;
        s2.Units__c = 7200;
        s2.Contract__c = 'Test1';
        s2.Contract_Number__c = '380991';
        s2.Settlement_Paid_Date__c = date.newinstance(2023,04,28);
        s2.Region__c = 'East';
        insert s2;
        
        SRx_IndirectSales_Summary_Table__c s3 = new SRx_IndirectSales_Summary_Table__c();
        s3.Sales_Rep_Name__c = 'Brenda Kern';
        s3.Hospital_Name__c = 'THE JOHN M & SALLY B THORNTON (SAP)';
        //s3.Customer_Name__c ='HC Pharmacy Central INC';
        s3.Product_Family__c = 'Bivalirudin';
        s3.Product__c = 'Bivalirudin Injection 250mg/Vial 10s USA';
        s3.Sales__c=19680;
        s3.Units__c = 480;
        s3.Contract__c = 'Test1';
        s3.Contract_Number__c = '380991';
        s3.Settlement_Paid_Date__c = date.newinstance(2023,07,11);
        s3.Region__c = 'East';
        insert s3;
        
        list<String> customerlist = new list<string>{'FRESNO COMM MC MAIL ORDER PHY (SAP)','THE JOHN M & SALLY B THORNTON (SAP)'};
        list<String> productList = new list<string>{'Ertapenem for Inj. 1g/vial 10s','Bivalirudin Injection 250mg/Vial 10s USA'};
        List<String> contracts = new List<String>{'Test1','Test2'};
        //List<WrapperClass> result= DirectSalesDataCls.getDirectSalesList('Brenda Kern','HC Pharmacy Central INC');
        IndirectSalesDataCls.CustomerSpecific_getIndirectSalesList('Test1','FRESNO COMM MC MAIL ORDER PHY (SAP)','Brenda Kern',contracts,customerlist,productList);
        IndirectSalesDataCls.productFamily_getIndirectSalesList('Test1','THE JOHN M & SALLY B THORNTON (SAP)','Bivalirudin','Brenda Kern',contracts,customerlist,productList);
        IndirectSalesDataCls.ContractSpecific_getIndirectSalesList('Test1','Brenda Kern',contracts,customerlist,productList);
        
        IndirectSalesDataCls.getIndirectSalesList(contracts,'Brenda Kern',customerlist,productList);
        IndirectSalesDataCls.getProductNames('Brenda Kern');
        IndirectSalesDataCls.getCustomerNames('Brenda Kern');
        IndirectSalesDataCls.getContracts();
        
    }

}