@isTest 
public class Phoenix_BidItemHandlerOTBTest {
    @testSetup static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'Sams Club');
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
        pb.Phoenix_Bid_Type__c = 'Good Dated OTB';
        pb.Phoenix_OTB_Direct_Indirect__c='Direct';
        insert pb;
        Phoenix_Bid__c pb1 = new Phoenix_Bid__c();
        pb1.Phoenix_Status__c = 'New';
        pb1.Phoenix_Bid_Type__c = 'RFP Bids';
        pb1.Phoenix_Comments__c = 'Test Comments';
        pb1.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb1.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb1.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb1.Phoenix_Customer_Type__c = 'ABC Progen';
        pb1.Phoenix_Bid_Deadline_Date__c = System.today();
        pb1.Phoenix_Bid_Type__c = 'Good Dated OTB';
        pb1.Phoenix_OTB_Direct_Indirect__c='Indirect';
        insert pb1;
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
        //bl.Proposed_Net_Sales_Direct__c=2;
        // bl.Phoenix_ProposedContractBidPriceMktng__c=5;
        bl.Phoenix_ProposedContractBidPriceMktng__c=10;
        bl.Proposed_TPT_Indirect__c=100;
        bl.Proposed_Net_Sales_Indirect__c = 15;
        //bl.Phoenix_Wholesaler_Diff_Price_Indirect__c=5;
        
        //  bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl;
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
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 10;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        update bl;
    }
    /* static testmethod void getBid3() {
Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
bl.Phoenix_Proposed_Direct_Selling_Unit__c = 10;
bl.Phoenix_Proposed_Indirect_Selling_Unit__c=10;
bl.Phoenix_Proposed_Direct_Selling_Unit__c=10;
//update bl;
}
*/static testmethod void getBid4() {
    Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
    bl.Phoenix_Proposed_Direct_Selling_Unit__c = 10;
    bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
    update bl;
}
    static testmethod void getBid5() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        update bl;
    }
    static testmethod void getBid6() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_SCM_Final_Approval__c = false;
        //  bl.Phoenix_Gross_Contract_Sales__c=10;
        //  bl.Phoenix_Value_Rebate__c=10;
        update bl;
    }
     static testmethod void getBid7(){   
        Phoenix_Bid__c pb1 = new Phoenix_Bid__c();
        pb1.Phoenix_Bid_Type__c = 'Good Dated OTB';
        pb1.Phoenix_Proactive_Reactive__c = 'Proactive';    
        pb1.Phoenix_Customer_Type__c = 'ROS';       
        pb1.Phoenix_Approval_Status__c = 'Closed';
        pb1.Phoenix_Approval_Status__c = 'Internally Rejected';
        insert pb1;
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb1.Id;
        bl1.Phoenix_Proposed_Sales__c =100; 
        bl1.Phoenix_Internal_Dead_Net_Price__c = 100;
        bl1.Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c = 10;
        bl1.Phoenix_Wholesaler_DRL_Net_Price__c = 106;
        bl1.Phoenix_Direct_Dead_Net__c = 12;
        bl1.Phoenix_Budgeted_ASP1__c = 12;
        insert bl1;
          
       // Phoenix_BidItemHandlerOTB.getBidData(system.today()-6,system.today());
       // Phoenix_BidItemHandlerOTB.getBidData(null,null);
    }
    static testmethod void getBid8(){   
        Phoenix_Bid__c pb1 = new Phoenix_Bid__c();
        pb1.Phoenix_Bid_Type__c = 'Platform OTB';
        pb1.Phoenix_Proactive_Reactive__c = 'Proactive';    
        pb1.Phoenix_Customer_Type__c = 'ROS';       
        pb1.Phoenix_Approval_Status__c = 'Closed';
        pb1.Phoenix_Approval_Status__c = 'Internally Rejected';
        insert pb1;
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb1.Id;
        bl1.Phoenix_Proposed_Sales__c =100; 
        bl1.Phoenix_Internal_Dead_Net_Price__c = 100;
        bl1.Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c = 10;
        bl1.Phoenix_Wholesaler_DRL_Net_Price__c = 106;
        bl1.Phoenix_Direct_Dead_Net__c = 12;
        bl1.Phoenix_Budgeted_ASP1__c = 12;
        insert bl1;
          
       // Phoenix_BidItemHandlerOTB.getBidData(system.today()-6,system.today());
       // Phoenix_BidItemHandlerOTB.getBidData(null,null);
    }
    static testmethod void getBid9(){   
        Phoenix_Bid__c pb1 = new Phoenix_Bid__c();
        pb1.Phoenix_Bid_Type__c = 'Platform PO OTB';
        pb1.Phoenix_Proactive_Reactive__c = 'Proactive';    
        pb1.Phoenix_Customer_Type__c = 'ROS';       
        pb1.Phoenix_Approval_Status__c = 'Closed';
        pb1.Phoenix_Approval_Status__c = 'Internally Rejected';
        insert pb1;
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb1.Id;
        bl1.Phoenix_Proposed_Sales__c =100; 
        bl1.Phoenix_Internal_Dead_Net_Price__c = 100;
        bl1.Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c = 10;
        bl1.Phoenix_Wholesaler_DRL_Net_Price__c = 106;
        bl1.Phoenix_Direct_Dead_Net__c = 12;
        bl1.Phoenix_Budgeted_ASP1__c = 12;
        insert bl1;
          
       // Phoenix_BidItemHandlerOTB.getBidData(system.today()-6,system.today());
       // Phoenix_BidItemHandlerOTB.getBidData(null,null);
    }
}