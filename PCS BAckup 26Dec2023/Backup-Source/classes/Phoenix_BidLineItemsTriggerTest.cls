@isTest
public class Phoenix_BidLineItemsTriggerTest {
     @testSetup static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'Walgreens');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'IPA Floor Pricing Update';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
         prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
         
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
         bl.Phoenix_Current_Direct_Price__c = 10;
         bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
         bl.Phoenix_Product__c = prod1.id;
         bl.Phoenix_Final_Status__c = 'Approved';
         bl.Phoenix_SCM_Final_Approval__c = true;
         bl.Phoenix_Proposed_Indirect_Selling_Unit__c=10;
         bl.Phoenix_Proposed_Direct_Selling_Unit__c=10;
         //bl.Phoenix_Total_SCM_Approved_Qty__c=10;
         insert bl;
         
     }
    
    static testmethod void getBid() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved' LIMIT 1];
        bl.Phoenix_Current_Direct_Selling_Unit__c = 10;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        
        update bl;
         PhoenixBidTriggerHandler.codeCoverage();
    }
    static testmethod void getBid1() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved' LIMIT 1];
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 12;
        // bl.Phoenix_Bid_Template_Refrence__c='ABC Progen';
        //bl.Phoenix_Proposed_Indirect_Selling_Unit__c=10;
         bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = true;
        bl.Phoenix_Proposed_Direct_Selling_Unit__c=10;
        //update bl;
        
    }
    static testmethod void getBid2() {
       // Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'ClarusOne');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'IPA Floor Pricing Update';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Customer_Type__c = 'ClarusOne';
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
         prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
         
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
         bl.Phoenix_Current_Direct_Price__c = 10;
         bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
         bl.Phoenix_Final_Status__c = 'Approved';
         bl.Phoenix_SCM_Final_Approval__c = true;
         bl.Phoenix_Proposed_Indirect_Selling_Unit__c=10;
         bl.Phoenix_Proposed_Direct_Selling_Unit__c=10;
         bl.Phoenix_SCM_Qty_Approved_Indirect__c=9;
        bl.Phoenix_Proposed_OS_Units__c = 30;
        bl.Phoenix_Proposed_RAD_Units__c = 50;
        bl.Phoenix_Proposed_WMT_Units__c = 40;
         //bl.Phoenix_Total_SCM_Approved_Qty__c=10;
         insert bl;
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 10;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
      
        update bl;
    }
   static testmethod void getBid3() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 10;
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c=10;
        bl.Phoenix_Proposed_Direct_Selling_Unit__c=10;
        update bl;
    }
    static testmethod void getBid4() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 10;
        bl.Phoenix_SCM_Qty_Approved_Indirect__c=9;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        update bl;
    }
    static testmethod void getBid5() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 10;
        
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        update bl;
    }
    static testmethod void getBid50() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 0;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        update bl;
        
    }
    static testmethod void getBid55() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
         bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
       bl.Phoenix_Direct_ESI__c = 100;
        bl.Phoenix_Direct_Supervalu__c =100;
        bl.Phoenix_Indirect_ESI__c=100;
        bl.Phoenix_Indirect_Kroger__c=100;
        bl.Phoenix_Override_Current_Direct_Units__c =100;
        bl.Phoenix_SCM_Final_Approval__c = true;
        bl.Phoenix_SCM_Approved_Quantity__c =20;
        update bl;
    }
    static testmethod void getBid6() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_SCM_Final_Approval__c = false;
        //  bl.Phoenix_Gross_Contract_Sales__c=10;
        //  bl.Phoenix_Value_Rebate__c=10;
        update bl;
    }
    
    static testmethod void getBid8() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'ABC Progen');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'IPA Floor Pricing Update';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'ABC Progen';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
        prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 2;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = true;
        insert bl;
    }
    static testmethod void getBid9() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'Econdisc');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Econdisc';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
         prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = true;
        bl.Phoenix_Final_Direct_Selling_Units_Calc__c = 10;
        bl.Phoenix_Final_Indirect_Selling_Units_Cal__c = 10;
          bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl;
    }
    static testmethod void getBid30() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'ABC Progen');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'ABC Progen';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
         prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = true;
        bl.Phoenix_Final_Direct_Selling_Units_Calc__c = 10;
        bl.Phoenix_Final_Indirect_Selling_Units_Cal__c = 10;
        //  bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl;
    }
    static testmethod void getBid10() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'RXSS');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'IPA Floor Pricing Update';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'RXSS';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
         prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = true;
        bl.Phoenix_Final_Direct_Selling_Units_Calc__c = 10;
        bl.Phoenix_Final_Indirect_Selling_Units_Cal__c = 10;
        bl.Phoenix_Proposed_Smith_Drug_Units__c=10;
        //  bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl;
    }
    
    static testmethod void getBid11() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'Net Indirect Pricing');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'IPA Floor Pricing Update';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Net Indirect Pricing';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
         prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = false;
        bl.Phoenix_Final_Direct_Selling_Units_Calc__c = 10;
        bl.Phoenix_Final_Indirect_Selling_Units_Cal__c = 10;
        bl.Phoenix_Estimated_Medicaid_Returns__c = 120.0;
        //  bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl;
    } 
    static testmethod void getBid12() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'Sams Club');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'IPA Floor Pricing Update';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Sams Club';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
         prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = false;
        bl.Phoenix_Final_Direct_Selling_Units_Calc__c = 10;
        bl.Phoenix_Final_Indirect_Selling_Units_Cal__c = 10;
        bl.Phoenix_Estimated_Medicaid_Returns__c = 120.0;
        //  bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl;
        
    }
    static testmethod void getBid13() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'Costco');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Costco';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
         prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = false;
        bl.Phoenix_Final_Direct_Selling_Units_Calc__c = 10;
        bl.Phoenix_Final_Indirect_Selling_Units_Cal__c = 10;
        bl.Phoenix_Estimated_Medicaid_Returns__c = 120.0;
        //  bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl;
        
    }
    static testmethod void getBid14() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'Short Dated OTB';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Proposed_Cash_Terms__c=10;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        //  pb.Phoenix_Customer_Type__c = 'OneTime';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
         prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = false;
        bl.Phoenix_Final_Direct_Selling_Units_Calc__c = 10;
        bl.Phoenix_Final_Indirect_Selling_Units_Cal__c = 10;
        bl.Phoenix_Estimated_Medicaid_Returns__c = 120.0;
        bl.Phoenix_WAC1__c=10;
        bl.Phoenix_Proposed_Cash_Terms__c=10;
        //  bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl;
        
    }
    static testmethod void getBid15() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'ABC Pharmagen');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'ABC Pharmagen';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
         prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = true;
        bl.Phoenix_Final_Direct_Selling_Units_Calc__c = 10;
        bl.Phoenix_Final_Indirect_Selling_Units_Cal__c = 10;
        bl.Phoenix_Estimated_Medicaid_Returns__c = 120.0;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
           insert bl;
        
    }
    
    static testmethod void getBid16() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'BASE/DSH');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'BASE/DSH';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
         prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = false;
        bl.Phoenix_Final_Direct_Selling_Units_Calc__c = 10;
        bl.Phoenix_Final_Indirect_Selling_Units_Cal__c = 10;
        bl.Phoenix_Estimated_Medicaid_Returns__c = 120.0;
        //  bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl;
        
    }
    static testmethod void getBid18() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'Government Pricing');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Government Pricing';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
         prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = false;
        bl.Phoenix_Final_Direct_Selling_Units_Calc__c = 10;
        bl.Phoenix_Final_Indirect_Selling_Units_Cal__c = 10;
        bl.Phoenix_Estimated_Medicaid_Returns__c = 120.0;
        //  bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl;
        
    } 
    
    
    static testmethod void getBid20() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'Direct');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
         prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = false;
        bl.Phoenix_Final_Direct_Selling_Units_Calc__c = 10;
        bl.Phoenix_Final_Indirect_Selling_Units_Cal__c = 10;
        bl.Phoenix_Estimated_Medicaid_Returns__c = 120.0;
        //  bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl;
        
    } 
    
    static testmethod void getBid21() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'Indirect');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'Volume Review Only';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
         prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = false;
        bl.Phoenix_Final_Direct_Selling_Units_Calc__c = 10;
        bl.Phoenix_Final_Indirect_Selling_Units_Cal__c = 10;
        bl.Phoenix_Estimated_Medicaid_Returns__c = 120.0;
        //  bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl;
        
    } 
    
    static testmethod void getBid22() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'Direct and Indirect');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
         prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = false;
        bl.Phoenix_Final_Direct_Selling_Units_Calc__c = 10;
        bl.Phoenix_Final_Indirect_Selling_Units_Cal__c = 10;
        bl.Phoenix_Estimated_Medicaid_Returns__c = 120.0;
        bl.Phoenix_Direct_Dead_Net__c = 120.0;
        bl.Phoenix_Indirect_Dead_Net__c = 120.0;
        //  bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl;
        
    } 
    
    static testmethod void getBid19() {
        try{
            Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'ClarusOne');
            insert testAccount;
            Phoenix_Bid__c pb = new Phoenix_Bid__c();
            pb.Phoenix_Status__c = 'New';
            pb.Phoenix_Bid_Type__c = 'RFP Bids';
            pb.Phoenix_Comments__c = 'Test Comments';
            pb.Phoenix_Customer__c = testAccount.Id;
            //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
            pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
            pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
            pb.Phoenix_Customer_Type__c = 'ClarusOne';
            pb.Phoenix_Bid_Deadline_Date__c = System.today();
            insert pb;
            Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
            prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
            prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
            insert prod1;
            Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
            bl.Phoenix_Bid__c = pb.Id;
            // bl.Phoenix_Current_Direct_Price__c = 10;
            // bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
            bl.Phoenix_Product__c = prod1.id;
            bl.Phoenix_Final_Status__c = 'Approved';
            bl.Phoenix_SCM_Final_Approval__c = false;
            bl.Phoenix_Final_Direct_Selling_Units_Calc__c = 10;
            bl.Phoenix_Final_Indirect_Selling_Units_Cal__c = 10;
            bl.Phoenix_Estimated_Medicaid_Returns__c = 120.0;
            bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
            insert bl;
        }catch(exception ex){
            
        }
        
    } 
    
    
    static testmethod void getBid31() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'RXSS');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'IPA Floor Pricing Update';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Net Indirect Pricing';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
         prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = false;
        bl.Phoenix_Final_Direct_Selling_Units_Calc__c = 10;
        bl.Phoenix_Final_Indirect_Selling_Units_Cal__c = 10;
        bl.Phoenix_Estimated_Medicaid_Returns__c = 120.0;
          bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl;
    }
     /*static testmethod void getBid51() {
         Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'Walgreens');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'IPA Floor Pricing Update';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
         prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
         
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
         bl.Phoenix_Current_Direct_Price__c = 10;
         bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
         bl.Phoenix_Product__c = prod1.id;
         bl.Phoenix_Final_Status__c = 'Approved';
         bl.Phoenix_SCM_Final_Approval__c = true;
         bl.Phoenix_Proposed_Indirect_Selling_Unit__c=10;
         bl.Phoenix_Proposed_Direct_Selling_Unit__c=10;
         //bl.Phoenix_Total_SCM_Approved_Qty__c=10;
         insert bl;
        Phoenix_Bid_Line_Item__c b = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        b.Phoenix_Proposed_Indirect_Selling_Unit__c = 0;
        b.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        update b;
    }*/
    static testmethod void getBid32() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 10;
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c=20;
        //bl.Phoenix_Total_SCM_Approved_Qty__c=30;
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c=45;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        update bl;
    }
    static testmethod void getBid40() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 10;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        update bl;
    }
    static testmethod void getBid51() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 0;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        update bl;
        
    }
    static testmethod void getBid56() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
         bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
       bl.Phoenix_Direct_ESI__c = 100;
        bl.Phoenix_Direct_Supervalu__c =100;
        bl.Phoenix_Indirect_ESI__c=100;
        bl.Phoenix_Indirect_Kroger__c=100;
        bl.Phoenix_Override_Current_Direct_Units__c =100;
        bl.Phoenix_SCM_Final_Approval__c = true;
        bl.Phoenix_SCM_Approved_Quantity__c =20;
        update bl;
    }
    static testmethod void getBid60() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_SCM_Final_Approval__c = false;
        //  bl.Phoenix_Gross_Contract_Sales__c=10;
        //  bl.Phoenix_Value_Rebate__c=10;
        update bl;
    }
   
    
    
}