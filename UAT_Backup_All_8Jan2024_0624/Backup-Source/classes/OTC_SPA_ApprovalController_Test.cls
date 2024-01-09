@isTest
public class OTC_SPA_ApprovalController_Test {

    @testSetup static void setupTestData() {
    
        Account[] accList = new Account[]{
            new Account(Name = 'Test Account 01', Type = 'Customer', Sales_Territory__c = 'OTC', Vendor_Credentialing__c = 'VCS'),
            new Account(Name = 'Test Account 02', Type = 'Customer', Sales_Territory__c = 'OTC', Vendor_Credentialing__c = 'VCS')
        };
        insert accList;
        
        Opportunity[] oppList = new Opportunity[]{
            new Opportunity(
                AccountId = accList[0].Id, Name = 'Test Opportunity 01', StageName = 'Qualification', 
                CloseDate = Date.today().addDays(30)
            ),
            new Opportunity(
                AccountId = accList[1].Id, Name = 'Test Opportunity 02', StageName = 'Needs Analysis', 
                CloseDate = Date.today().addDays(60)
            )
        };
        insert oppList;
        
        Product2[] productList = new Product2[]{
            new Product2(Name = 'Test Product 01', ProductCode = 'TEST-001', IsActive = true, Count__c = 10, Family = 'Ranitidine 75mg'),
            new Product2(Name = 'Test Product 02', ProductCode = 'TEST-002', IsActive = true, Count__c = 20, Family = 'Ranitidine 150mg'),
            new Product2(Name = 'Test Product 03', ProductCode = 'TEST-003', IsActive = true, Count__c = 30, Family = 'Esomeprazole'),
            new Product2(Name = 'Test Product 04', ProductCode = 'TEST-004', IsActive = true, Count__c = 40, Family = 'Guaifenesin')
        };
        insert productList;
        
        OTC_SPA__c[] otcList = new OTC_SPA__c[]{
            new OTC_SPA__c(
                OPT__c = oppList[0].Id, Product__c = productList[0].Id, Price_Intelligence__c = 'Test 1', 
                Estimate_in_DC_Date__c = Date.today()
            ),
            new OTC_SPA__c(OPT__c = oppList[0].Id, Product__c = productList[1].Id, Price_Intelligence__c = 'Test 2', Estimate_in_DC_Date__c = Date.today().addDays(1)),
            new OTC_SPA__c(OPT__c = oppList[1].Id, Product__c = productList[2].Id, Price_Intelligence__c = 'Test 3', Estimate_in_DC_Date__c = Date.today().addDays(2)),
            new OTC_SPA__c(OPT__c = oppList[1].Id, Product__c = productList[3].Id, Price_Intelligence__c = 'Test 4', Estimate_in_DC_Date__c = Date.today().addDays(3)),
            new OTC_SPA__c(OPT__c = oppList[1].Id, Product__c = productList[2].Id, Estimate_in_DC_Date__c = Date.today().addDays(2)),
            new OTC_SPA__c(OPT__c = oppList[1].Id, Price_Intelligence__c = 'Test 4', Estimate_in_DC_Date__c = Date.today().addDays(3))
        
        };
        insert otcList;
    }
    
    public static testmethod void test_OTC_SPA_ApprovalController() {
    
        OTC_SPA_ApprovalController otc = new OTC_SPA_ApprovalController();
        Opportunity[] oppList1 = [SELECT Id, Name FROM Opportunity WHERE Name LIKE 'Test Opportunity%' LIMIT 2];
        OTC_SPA_ApprovalController.validateOTCSPAs(oppList1[0].Id);
        OTC_SPA_ApprovalController.submitForApproval(oppList1[0].Id);  
        
        List<OTC_SPA__c> otcList1 = new List<OTC_SPA__c>();
        otcList1 = [SELECT Id, Approval_Status__c, OPT__c FROM OTC_SPA__c WHERE OPT__c = :oppList1[0].Id];
        
        System.assertEquals('Sales-Submitted', otcList1[0].Approval_Status__c);  
        
        OTC_SPA_ApprovalController.validateOTCSPAs(oppList1[1].Id);
        
    }
}