/**
* @description       : 
* @author            : Surender Patel (Dhruvsoft)
* @group             : 
* @last modified on  : 25-05-2021
* @last modified by  : Surender Patel (Dhruvsoft)
* Modifications Log 
* Ver   Date         Author                       Modification
* 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
@isTest
public class Phoenix_OfferGenerationInfoClsTest {
    @isTest static void test() {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'Volume Review Only';
        pb.Phoenix_Approval_Status__c = 'Draft';
        insert pb;
        Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
        p2.Phoenix_Product_Director__c = UserInfo.getUserId();
        p2.Phoenix_Marketing_Lead__c=UserInfo.getUserId();
        insert p2;
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
        p3.Phoenix_Product_Director__c = UserInfo.getUserId();
        p3.Phoenix_Marketing_Lead__c=UserInfo.getUserId();
        insert p3;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Product_Code1__c = '300029858';
        bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = p2.Id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl.Phoenix_Marketing_Final_Approval__c = true;
        insert bl;
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert bl1;
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Final_Status__c = 'Approved';
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = p3.Id;
        bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bl2.Phoenix_Marketing_Final_Approval__c = true;
        insert bl2;
        ApexPages.currentPage().getParameters().put('BidId', pb.Id);
        ApexPages.currentPage().getParameters().put('productFamily', 'All');
        Phoenix_OfferGenerationInfoCls offergen = new Phoenix_OfferGenerationInfoCls();
        
    }
    
    @isTest static void test1() {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Approval_Status__c = 'Draft';
        insert pb;
        Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
        p2.Phoenix_Product_Director__c = UserInfo.getUserId();
        p2.Phoenix_Marketing_Lead__c=UserInfo.getUserId();
        insert p2;
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
        p3.Phoenix_Product_Director__c = UserInfo.getUserId();
        p3.Phoenix_Marketing_Lead__c=UserInfo.getUserId();
        insert p3;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Product_Code1__c = '300029858';
        bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = p2.Id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl.Phoenix_Marketing_Final_Approval__c = true;
        insert bl;
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert bl1;
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Final_Status__c = 'Approved';
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = p3.Id;
        bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bl2.Phoenix_Marketing_Final_Approval__c = true;
        insert bl2;
        ApexPages.currentPage().getParameters().put('BidId', pb.Id);
        ApexPages.currentPage().getParameters().put('productFamily', p3.Family);
        Phoenix_OfferGenerationInfoCls offergen = new Phoenix_OfferGenerationInfoCls();
        
    }
    @isTest static void test2() {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'Volume Review Only';
        pb.Phoenix_Approval_Status__c = 'Draft';
        insert pb;
        Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
        p2.Phoenix_Product_Director__c = UserInfo.getUserId();
        p2.Phoenix_Marketing_Lead__c=UserInfo.getUserId();
        insert p2;
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
        p3.Phoenix_Product_Director__c = UserInfo.getUserId();
        p3.Phoenix_Marketing_Lead__c=UserInfo.getUserId();
        insert p3;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Product_Code1__c = '300029858';
        bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = p2.Id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl.Phoenix_Marketing_Final_Approval__c = true;
        
        bl.Phoenix_Estimated_Lead_Time_Days__c='0';
        insert bl;
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        bl1.Phoenix_Estimated_Lead_Time_Days__c='7';
        insert bl1;
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Final_Status__c = 'Approved';
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = p3.Id;
        bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bl2.Phoenix_Marketing_Final_Approval__c = true;
        bl2.Phoenix_Estimated_Lead_Time_Days__c='0';
        insert bl2;
        ApexPages.currentPage().getParameters().put('BidId', pb.Id);
        ApexPages.currentPage().getParameters().put('productFamily', 'All');
        Phoenix_OfferGenerationInfoCls offergen = new Phoenix_OfferGenerationInfoCls();
        
    }
    
    @isTest static void test3() {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        
        Phoenix_Contract__c Cntrct1 = new Phoenix_Contract__c();
        Cntrct1.name = 'taest cntrct1';
        Cntrct1.Phoenix_Contract_Number__c = '1000000449';
        insert Cntrct1;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'Volume Review Only';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Reference_Contracts__c = Cntrct1.id;
        insert pb;
        
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
        p3.Phoenix_Product_Director__c = UserInfo.getUserId();
        p3.Phoenix_Marketing_Lead__c=UserInfo.getUserId();
        insert p3;
        
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        bl1.Phoenix_Estimated_Lead_Time_Days__c='7';
        insert bl1;
        
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Final_Status__c = 'Approved';
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = p3.Id;
        bl2.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl2.Phoenix_Marketing_Final_Approval__c = true;
        bl2.Phoenix_Estimated_Lead_Time_Days__c='0';
        insert bl2;
        ApexPages.currentPage().getParameters().put('BidId', pb.Id);
        ApexPages.currentPage().getParameters().put('productFamily', 'All');
        Phoenix_OfferGenerationInfoCls offergen = new Phoenix_OfferGenerationInfoCls();
        
    }
    
    @isTest static void test4() {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        
        Phoenix_Contract__c Cntrct1 = new Phoenix_Contract__c();
        Cntrct1.name = 'taest cntrct1';
        Cntrct1.Phoenix_Contract_Number__c = '1000000449';
        insert Cntrct1;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'ROSS';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Reference_Contracts__c = Cntrct1.id;
        insert pb;
        
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
        p3.Phoenix_Product_Director__c = UserInfo.getUserId();
        p3.Phoenix_Marketing_Lead__c=UserInfo.getUserId();
        insert p3;
        
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        bl1.Phoenix_Estimated_Lead_Time_Days__c='7';
        insert bl1;
        
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Final_Status__c = 'Approved';
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = p3.Id;
        bl2.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl2.Phoenix_Marketing_Final_Approval__c = true;
        bl2.Phoenix_Estimated_Lead_Time_Days__c='0';
        insert bl2;
        ApexPages.currentPage().getParameters().put('BidId', pb.Id);
        ApexPages.currentPage().getParameters().put('productFamily', 'All');
        Phoenix_OfferGenerationInfoCls offergen = new Phoenix_OfferGenerationInfoCls();
        
    }
    @isTest static void test5() {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        
        Phoenix_Contract__c Cntrct1 = new Phoenix_Contract__c();
        Cntrct1.name = 'taest cntrct1';
        Cntrct1.Phoenix_Contract_Number__c = '1000000449';
        insert Cntrct1;
        
        Phoenix_NDC_Change__c ndcs = new Phoenix_NDC_Change__c();
        
        insert ndcs;
        
        Phoenix_NDC_Change_Line_Item__c ndclines = new Phoenix_NDC_Change_Line_Item__c();
        ndclines.Phoenix_Account__c = testAccount.id;
        insert ndclines;
        Phoenix_NDC_Change_Line_Item__c ndclines2 = new Phoenix_NDC_Change_Line_Item__c();
        ndclines2.Phoenix_Account__c = testAccount.id;
        insert ndclines2;
        
        
        
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
        p3.Phoenix_Product_Director__c = UserInfo.getUserId();
        p3.Phoenix_Marketing_Lead__c=UserInfo.getUserId();
        insert p3;
        
        
        
        ApexPages.currentPage().getParameters().put('BidId', ndcs.Id);
        ApexPages.currentPage().getParameters().put('relatedTo', 'NDC Change');
        ApexPages.currentPage().getParameters().put('productFamily', 'All');
        ApexPages.currentPage().getParameters().put('customerId', 'All');
        ApexPages.currentPage().getParameters().put('customerId', '');
        
        Phoenix_OfferGenerationInfoCls offergen = new Phoenix_OfferGenerationInfoCls();
    }
    
     @isTest static void test55() {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        
        Phoenix_Contract__c Cntrct1 = new Phoenix_Contract__c();
        Cntrct1.name = 'taest cntrct1';
        Cntrct1.Phoenix_Contract_Number__c = '1000000449';
        insert Cntrct1;
        
        Phoenix_NDC_Change__c ndcs = new Phoenix_NDC_Change__c();
        
        insert ndcs;
        
        Phoenix_NDC_Change_Line_Item__c ndclines = new Phoenix_NDC_Change_Line_Item__c();
        ndclines.Phoenix_Account__c = testAccount.id;
        insert ndclines;
        Phoenix_NDC_Change_Line_Item__c ndclines2 = new Phoenix_NDC_Change_Line_Item__c();
        ndclines2.Phoenix_Account__c = testAccount.id;
        insert ndclines2;
        
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
        p3.Phoenix_Product_Director__c = UserInfo.getUserId();
        p3.Phoenix_Marketing_Lead__c=UserInfo.getUserId();
        insert p3;
        
        ApexPages.currentPage().getParameters().put('BidId', ndcs.Id);
        ApexPages.currentPage().getParameters().put('relatedTo', 'NDC Change');
        ApexPages.currentPage().getParameters().put('productFamily', 'All');
        ApexPages.currentPage().getParameters().put('customerId', 'All');
        
        Phoenix_OfferGenerationInfoCls offergen = new Phoenix_OfferGenerationInfoCls();
    }
    
    @isTest static void test6() {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        
        Phoenix_Contract__c Cntrct1 = new Phoenix_Contract__c();
        Cntrct1.name = 'taest cntrct1';
        Cntrct1.Phoenix_Contract_Number__c = '1000000449';
        insert Cntrct1;
        
        Phoenix_NDC_Change__c ndcs = new Phoenix_NDC_Change__c();
        
        insert ndcs;
        
        Phoenix_NDC_Change_Line_Item__c ndclines = new Phoenix_NDC_Change_Line_Item__c();
        ndclines.Phoenix_Account__c = testAccount.id;
        insert ndclines;
        Phoenix_NDC_Change_Line_Item__c ndclines2 = new Phoenix_NDC_Change_Line_Item__c();
        ndclines2.Phoenix_Account__c = testAccount.id;
        insert ndclines2;
        
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
        p3.Phoenix_Product_Director__c = UserInfo.getUserId();
        p3.Phoenix_Marketing_Lead__c=UserInfo.getUserId();
        insert p3;
        
        ApexPages.currentPage().getParameters().put('BidId', ndcs.Id);
        ApexPages.currentPage().getParameters().put('relatedTo', 'NDC Change');
        ApexPages.currentPage().getParameters().put('productFamily', '');
        ApexPages.currentPage().getParameters().put('customerId', 'All');
        Phoenix_OfferGenerationInfoCls offergen = new Phoenix_OfferGenerationInfoCls();
    }
    
        @isTest static void test66() {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        
        Phoenix_Contract__c Cntrct1 = new Phoenix_Contract__c();
        Cntrct1.name = 'taest cntrct1';
        Cntrct1.Phoenix_Contract_Number__c = '1000000449';
        insert Cntrct1;
        
        Phoenix_NDC_Change__c ndcs = new Phoenix_NDC_Change__c();
        
        insert ndcs;
        
        Phoenix_NDC_Change_Line_Item__c ndclines = new Phoenix_NDC_Change_Line_Item__c();
        ndclines.Phoenix_Account__c = testAccount.id;
        insert ndclines;
        Phoenix_NDC_Change_Line_Item__c ndclines2 = new Phoenix_NDC_Change_Line_Item__c();
        ndclines2.Phoenix_Account__c = testAccount.id;
        insert ndclines2;
        
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
        p3.Phoenix_Product_Director__c = UserInfo.getUserId();
        p3.Phoenix_Marketing_Lead__c=UserInfo.getUserId();
        insert p3;
        
        
        ApexPages.currentPage().getParameters().put('BidId', ndcs.Id);
        ApexPages.currentPage().getParameters().put('relatedTo', 'NDC Change');
        ApexPages.currentPage().getParameters().put('productFamily', '');
        ApexPages.currentPage().getParameters().put('customerId', '');
        
        Phoenix_OfferGenerationInfoCls offergen = new Phoenix_OfferGenerationInfoCls();
    }
    
}