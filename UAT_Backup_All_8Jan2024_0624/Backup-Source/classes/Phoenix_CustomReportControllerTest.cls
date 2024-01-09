@isTest
public class Phoenix_CustomReportControllerTest {
    static testmethod void controllerMethod(){
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        Phoenix_Bid__c pb1 = new Phoenix_Bid__c();
        pb1.Phoenix_Status__c = 'New';
        pb1.Phoenix_Comments__c = 'Test Comments';
        pb1.Phoenix_Customer__c = testAccount.Id;
        pb1.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb1.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb1.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb1.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb1.Phoenix_Bid_Deadline_Date__c = System.today();
        pb1.Phoenix_Bid_Type__c = 'RFP Bids';
        pb1.Phoenix_Approval_Status__c = 'Closed';
        pb1.Phoenix_Bid_Submitted_Date__c = system.today()-1;// DateTime.now()-1;
        insert pb1;
        
        Phoenix_Bid__c pb2 = new Phoenix_Bid__c();
        pb2.Phoenix_Status__c = 'New';
        pb2.Phoenix_Comments__c = 'Test Comments';
        pb2.Phoenix_Customer__c = testAccount.Id;
        pb2.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb2.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb2.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb2.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb2.Phoenix_Bid_Deadline_Date__c = System.today();
        pb2.Phoenix_Bid_Type__c = 'RFP Bids';
        pb2.Phoenix_Approval_Status__c = 'Closed';
        pb2.Phoenix_Bid_Submitted_Date__c = system.today()-1;// DateTime.now()-1;
        insert pb2;
        
        Phoenix_Bid__c pb3 = new Phoenix_Bid__c();
        pb3.Phoenix_Status__c = 'New';
        pb3.Phoenix_Comments__c = 'Test Comments';
        pb3.Phoenix_Customer__c = testAccount.Id;
        pb3.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb3.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb3.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb3.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb3.Phoenix_Bid_Deadline_Date__c = System.today();
        pb3.Phoenix_Bid_Type__c = 'RFP Bids';
        pb3.Phoenix_Approval_Status__c = 'Closed';
     //   pb1.Phoenix_Bid_Submitted_Date__c = DateTime.now()-1;
        insert pb3;
        
        Phoenix_Bid__c pb4 = new Phoenix_Bid__c();
        pb4.Phoenix_Status__c = 'New';
        pb4.Phoenix_Comments__c = 'Test Comments';
        pb4.Phoenix_Customer__c = testAccount.Id;
        pb4.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb4.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb4.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb4.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb2.Phoenix_Bid_Deadline_Date__c = System.today();
        pb4.Phoenix_Bid_Type__c = 'RFP Bids';
        pb4.Phoenix_Approval_Status__c = 'Closed';
        pb4.Phoenix_Bid_Submitted_Date__c = system.today()-1;// DateTime.now()-1;
        insert pb4;
        
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
        
        Phoenix_Bid_Line_Item__c pb1bl = new Phoenix_Bid_Line_Item__c();
        pb1bl.Phoenix_Bid__c = pb1.Id;
        pb1bl.Phoenix_Current_Direct_Price__c = 10;
        pb1bl.Phoenix_Product_Code1__c = '300029858';
        pb1bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        pb1bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        pb1bl.Phoenix_Product__c = p2.Id;
        pb1bl.Phoenix_Final_Status__c = 'Approved';
        pb1bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        pb1bl.Phoenix_Marketing_Final_Approval__c = true;
        insert pb1bl;
        
        Phoenix_Bid_Line_Item__c pb1bl1 = new Phoenix_Bid_Line_Item__c();
        pb1bl1.Phoenix_Bid__c = pb1.Id;
        pb1bl1.Phoenix_Final_Status__c = 'Approved';
        pb1bl1.Phoenix_Current_Direct_Price__c = 10;
        pb1bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        pb1bl1.Phoenix_Product__c = p3.Id;
        pb1bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        pb1bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert pb1bl1;
        
        Phoenix_Bid_Line_Item__c pb1bl2 = new Phoenix_Bid_Line_Item__c();
        pb1bl2.Phoenix_Bid__c = pb1.Id;
        pb1bl2.Phoenix_Final_Status__c = 'Approved';
        pb1bl2.Phoenix_Current_Direct_Price__c = 10;
        pb1bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        pb1bl2.Phoenix_Product__c = p3.Id;
        pb1bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        pb1bl2.Phoenix_Marketing_Final_Approval__c = true;
        insert pb1bl2;
        
        Phoenix_Bid_Line_Item__c pb2bl = new Phoenix_Bid_Line_Item__c();
        pb2bl.Phoenix_Bid__c = pb2.Id;
        pb2bl.Phoenix_Current_Direct_Price__c = 10;
        pb2bl.Phoenix_Product_Code1__c = '300029858';
        pb2bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        pb2bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        pb2bl.Phoenix_Product__c = p2.Id;
        pb2bl.Phoenix_Final_Status__c = 'Approved';
        pb2bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        pb2bl.Phoenix_Marketing_Final_Approval__c = true;
        insert pb2bl;
        
        Phoenix_Bid_Line_Item__c pb2bl1 = new Phoenix_Bid_Line_Item__c();
        pb2bl1.Phoenix_Bid__c = pb2.Id;
        pb2bl1.Phoenix_Final_Status__c = 'Approved';
        pb2bl1.Phoenix_Current_Direct_Price__c = 10;
        pb2bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        pb2bl1.Phoenix_Product__c = p3.Id;
        pb2bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        pb2bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert pb2bl1;
        
        Phoenix_Bid_Line_Item__c pb2bl2 = new Phoenix_Bid_Line_Item__c();
        pb2bl2.Phoenix_Bid__c = pb2.Id;
        pb2bl2.Phoenix_Final_Status__c = 'Approved';
        pb2bl2.Phoenix_Current_Direct_Price__c = 10;
        pb2bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        pb2bl2.Phoenix_Product__c = p3.Id;
        pb2bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        pb2bl2.Phoenix_Marketing_Final_Approval__c = true;
        insert pb2bl2;
        
        Phoenix_Bid_Line_Item__c pb3bl = new Phoenix_Bid_Line_Item__c();
        pb3bl.Phoenix_Bid__c = pb3.Id;
        pb3bl.Phoenix_Current_Direct_Price__c = 10;
        pb3bl.Phoenix_Product_Code1__c = '300029858';
        pb3bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        pb3bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        pb3bl.Phoenix_Product__c = p2.Id;
        pb3bl.Phoenix_Final_Status__c = 'Approved';
        pb3bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        pb3bl.Phoenix_Marketing_Final_Approval__c = true;
        insert pb3bl;
        
        Phoenix_Bid_Line_Item__c pb3bl1 = new Phoenix_Bid_Line_Item__c();
        pb3bl1.Phoenix_Bid__c = pb3.Id;
        pb3bl1.Phoenix_Final_Status__c = 'Approved';
        pb3bl1.Phoenix_Current_Direct_Price__c = 10;
        pb3bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        pb3bl1.Phoenix_Product__c = p3.Id;
        pb3bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        pb3bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert pb3bl1;
        
        Phoenix_Bid_Line_Item__c pb3bl2 = new Phoenix_Bid_Line_Item__c();
        pb3bl2.Phoenix_Bid__c = pb3.Id;
        pb3bl2.Phoenix_Final_Status__c = 'Approved';
        pb3bl2.Phoenix_Current_Direct_Price__c = 10;
        pb3bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        pb3bl2.Phoenix_Product__c = p3.Id;
        pb3bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        pb3bl2.Phoenix_Marketing_Final_Approval__c = true;
        insert pb3bl2;
        
        Phoenix_Bid_Line_Item__c pb4bl = new Phoenix_Bid_Line_Item__c();
        pb4bl.Phoenix_Bid__c = pb4.Id;
        pb4bl.Phoenix_Current_Direct_Price__c = 10;
        pb4bl.Phoenix_Product_Code1__c = '300029858';
        pb4bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        pb4bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        pb4bl.Phoenix_Product__c = p2.Id;
        pb4bl.Phoenix_Final_Status__c = 'Approved';
        pb4bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        pb4bl.Phoenix_Marketing_Final_Approval__c = true;
        insert pb4bl;
        
        Phoenix_Bid_Line_Item__c pb4bl1 = new Phoenix_Bid_Line_Item__c();
        pb4bl1.Phoenix_Bid__c = pb4.Id;
        pb4bl1.Phoenix_Final_Status__c = 'Approved';
        pb4bl1.Phoenix_Current_Direct_Price__c = 10;
        pb4bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        pb4bl1.Phoenix_Product__c = p3.Id;
        pb4bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        pb4bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert pb4bl1;
        
        Phoenix_Bid_Line_Item__c pb4bl2 = new Phoenix_Bid_Line_Item__c();
        pb4bl2.Phoenix_Bid__c = pb4.Id;
        pb4bl2.Phoenix_Final_Status__c = 'Approved';
        pb4bl2.Phoenix_Current_Direct_Price__c = 10;
        pb4bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        pb4bl2.Phoenix_Product__c = p3.Id;
        pb4bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        pb4bl2.Phoenix_Marketing_Final_Approval__c = true;
        insert pb4bl2;
        
        Date dt1 = System.today()-1;
        Date dt2 = System.today();
        Date dt3 = System.today()-2;
        Date dt4 = System.today()-1;
        Phoenix_CustomReportController.getRelatedList(dt1, dt2);
        Phoenix_CustomReportController.getRelatedList(dt3, dt4);
    }
}