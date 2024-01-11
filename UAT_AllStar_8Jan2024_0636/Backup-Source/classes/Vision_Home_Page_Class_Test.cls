@isTest
public class Vision_Home_Page_Class_Test {
    @isTest static void Test(){
        Account acc = new Account();
        acc.Name = 'Test acc';
        Insert acc;
        Phoenix_Contract__c cont = new Phoenix_Contract__c();
        cont.Name = '1234567';
        Insert cont;
        Product2 prod = new Product2();
        prod.Name ='test';
        prod.Phoenix_Pkg_Size__c=23;
        prod.Phoenix_NDC__c='2345';
        prod.Phoenix_Throughput_cost__c=45;
        insert prod;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = acc.Id;
        //  pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'VIP Rebate';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Bid_Name__c ='Test Bid';
        pb.Phoenix_Bid_Owner__c = userInfo.getUserId();
        pb.Phoenix_Internal_Target_Date__c = System.today()-5;
        insert pb;
        Phoenix_Bid__c pb1 = new Phoenix_Bid__c();
        pb1.Phoenix_Status__c = 'New';
        pb1.Phoenix_Comments__c = 'Test Comments';
        pb1.Phoenix_Customer__c = acc.Id;
        //  pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb1.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb1.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb1.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb1.Phoenix_Bid_Deadline_Date__c = System.today()-2;
        pb1.Phoenix_Bid_Type__c = 'VIP Rebate';
        pb1.Phoenix_Approval_Status__c = 'Draft';
        pb1.Phoenix_Bid_Name__c ='Test Bid';
        pb1.Phoenix_Internal_Target_Date__c = System.today()-5;
        pb1.Phoenix_Bid_Owner__c = userInfo.getUserId();
        
        insert pb1;
        Vision_Home_Page_Class.getRecentOpportunities();
        Vision_Home_Page_Class.getBidActions();
        
    }
    
    
}