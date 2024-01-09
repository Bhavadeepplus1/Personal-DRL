@isTest
public class DepartmentWise_Custom_Report_Test_Class 
{
    
    public static testmethod void controllerMethod1() 
    {
        
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
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
        pb2.Phoenix_Bid_Submitted_Date__c = system.today()-1;//DateTime.now()-1;
        pb2.Phoenix_Bid_SCM_Approved_Date__c = system.today()+1;
        insert pb2;
        
        Phoenix_Bid_Hold_History__c holdhsty = new Phoenix_Bid_Hold_History__c();
        holdhsty.Phoenix_Bid__c = pb2.id;
        holdhsty.Phoenix_hold_time__c = system.today();
        holdhsty.Phoenix_release_time__c = system.today().addDays(3);
        holdhsty.Phoenix_SCM_Marketing__c = 'SCM';
        holdhsty.Phoenix_Bid_Approval_Status__c = 'SCM & Marketing';
        insert holdhsty;
        
        Phoenix_Bid_Hold_History__c holdhsty2 = new Phoenix_Bid_Hold_History__c();
        holdhsty2.Phoenix_Bid__c = pb2.id;
        holdhsty2.Phoenix_hold_time__c = system.today();
        holdhsty2.Phoenix_release_time__c = system.today().addDays(3);
        holdhsty2.Phoenix_SCM_Marketing__c = 'SCM';
        holdhsty2.Phoenix_Bid_Approval_Status__c = 'SCM & Marketing';
        insert holdhsty2;
        
        DepartmentWise_Custom_Report.getSCM(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Type__c);
        DepartmentWise_Custom_Report.getSCM(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,null);
        DepartmentWise_Custom_Report.getSCM(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,'All');
    }
    
    public static testmethod void controllerMethod2() 
    {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
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
        pb2.Phoenix_Bid_Submitted_Date__c = system.today()-1;//DateTime.now()-1;
        pb2.Phoenix_Bid_SCM_Approved_Date__c = system.today()+4;
        insert pb2;
        
        DepartmentWise_Custom_Report.getSCM(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Type__c);
        DepartmentWise_Custom_Report.getSCM(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,null);
        DepartmentWise_Custom_Report.getSCM(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,'All'); 
    }
    
    public static testmethod void controllerMethod3() 
    {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
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
        pb2.Phoenix_Bid_Submitted_Date__c = system.today()-1;//DateTime.now()-1;
        pb2.Phoenix_Bid_SCM_Approved_Date__c = system.today()+10;
        insert pb2;
        DepartmentWise_Custom_Report.getSCM(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Type__c);
        DepartmentWise_Custom_Report.getSCM(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,null);
        DepartmentWise_Custom_Report.getSCM(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,'All'); 
    }
        
    public static testmethod void controllerMethod4() 
    {
        
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        
        Phoenix_Bid__c pb2 = new Phoenix_Bid__c();
        pb2.Phoenix_Status__c = 'New';
        pb2.Phoenix_Comments__c = 'Test Comments';
        pb2.Phoenix_Customer__c = testAccount.Id;
        pb2.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb2.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb2.Phoenix_Bid_Deadline_Date__c = System.today();
        pb2.Phoenix_Bid_Type__c = 'RFP Bids';
        pb2.Phoenix_Approval_Status__c = 'Marketing';
        pb2.Phoenix_Bid_Submitted_Date__c = system.today();//DateTime.now()-1;
        pb2.Phoenix_Bid_Marketing_Approved_Date__c = system.today().addDays(4);
        /*  pb2.Bid_Marketing_Head_Approved_Date__c = system.today()+2;
pb2.Bid_Marketing_Lead_OTC_Approved_Date__c = system.today()+2;
pb2.Bid_Marketing_Lead_RX_Approved_Date__c = system.today()+2;
pb2.Bid_Marketing_Lead_SRX_Approved_Date__c = system.today()+2;*/
        insert pb2;
        
                Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
        ps.Phoenix_Approver__c = UserInfo.getUserId();
        ps.Phoenix_Bid__c = pb2.Id;
        ps.Phoenix_Approver_Team__c = 'Marketing';
        ps.Phoenix_Approval_Sent_Time__c = system.now();
        ps.Phoenix_Approval_Completed_Time__c = Datetime.now().addDays(4);
        ps.Phoenix_Status__c = 'Completed' ;
        insert ps;
        
        Phoenix_Bid_Hold_History__c holdhsty = new Phoenix_Bid_Hold_History__c();
        holdhsty.Phoenix_Bid__c = pb2.id;
        holdhsty.Phoenix_hold_time__c = system.now();
        holdhsty.Phoenix_release_time__c = system.now().addSeconds(60);
        holdhsty.Phoenix_SCM_Marketing__c = 'Marketing';
        holdhsty.Phoenix_Bid_Approval_Status__c = 'SCM & Marketing';
        insert holdhsty;
        
        Phoenix_Bid_Hold_History__c holdhsty2 = new Phoenix_Bid_Hold_History__c();
        holdhsty2.Phoenix_Bid__c = pb2.id;
        holdhsty2.Phoenix_hold_time__c = system.now();
        holdhsty2.Phoenix_release_time__c = system.now().addSeconds(60);
        holdhsty2.Phoenix_SCM_Marketing__c = 'Marketing';
        holdhsty2.Phoenix_Bid_Approval_Status__c = 'SCM & Marketing';
        insert holdhsty2;
        DepartmentWise_Custom_Report.getMarketing(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Type__c);
    }
    
    public static testmethod void controllerMethod6() 
    {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        
        Phoenix_Bid__c pb2 = new Phoenix_Bid__c();
        pb2.Phoenix_Status__c = 'New';
        pb2.Phoenix_Comments__c = 'Test Comments';
        pb2.Phoenix_Customer__c = testAccount.Id;
        pb2.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb2.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb2.Phoenix_Bid_Deadline_Date__c = System.today();
        pb2.Phoenix_Bid_Type__c = 'RFP Bids';
        pb2.Phoenix_Approval_Status__c = 'Finance';
        pb2.Phoenix_Bid_Submitted_Date__c = system.today();//DateTime.now()-1;
        pb2.Phoenix_Bid_Marketing_Approved_Date__c = system.today().addDays(1);
        /* pb2.Bid_Marketing_Head_Approved_Date__c = system.today().addDays(1);
pb2.Bid_Marketing_Lead_OTC_Approved_Date__c = system.today().addDays(1);
pb2.Bid_Marketing_Lead_RX_Approved_Date__c = system.today().addDays(1);
pb2.Bid_Marketing_Lead_SRX_Approved_Date__c = system.today().addDays(1);*/
        pb2.Phoenix_Bid_Finance_Approved_Date__c = system.today().addDays(8);
        insert pb2;
        
        Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
        ps.Phoenix_Approver__c = UserInfo.getUserId();
        ps.Phoenix_Bid__c = pb2.Id;
        ps.Phoenix_Approver_Team__c = 'Marketing';
          ps.Phoenix_Approval_Completed_Time__c = Datetime.now().addDays(1);
        ps.Phoenix_Status__c = 'Completed' ;
        insert ps;
        
         Phoenix_Bid_Hold_History__c holdhsty = new Phoenix_Bid_Hold_History__c();
        holdhsty.Phoenix_Bid__c = pb2.id;
        holdhsty.Phoenix_hold_time__c = system.now();
        holdhsty.Phoenix_release_time__c = system.now().addSeconds(60);
        holdhsty.Phoenix_Bid_Approval_Status__c = 'Finance';
        insert holdhsty;
        
        Phoenix_Bid_Hold_History__c holdhsty2 = new Phoenix_Bid_Hold_History__c();
        holdhsty2.Phoenix_Bid__c = pb2.id;
        holdhsty2.Phoenix_hold_time__c = system.now();
        holdhsty2.Phoenix_release_time__c = system.now().addSeconds(60);
        holdhsty2.Phoenix_Bid_Approval_Status__c = 'Finance';
        insert holdhsty2;
       
        
        
        DepartmentWise_Custom_Report.getFinance(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Type__c);
       /*DepartmentWise_Custom_Report.getFinance(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,null);
    DepartmentWise_Custom_Report.getFinance(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,'All');*/
    }
    
   
    
    static testmethod void controllerMethod9() 
    {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        
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
        pb2.Phoenix_Bid_Submitted_Date__c = system.today();//DateTime.now()-1;
        pb2.Phoenix_Bid_Finance_Approved_Date__c = system.today()+1;
        pb2.Phoenix_Bid_Contracts_Approved_Date__c = system.today()+1;
        insert pb2;
        
         Phoenix_Bid_Hold_History__c holdhsty = new Phoenix_Bid_Hold_History__c();
        holdhsty.Phoenix_Bid__c = pb2.id;
        holdhsty.Phoenix_hold_time__c = system.today();
        holdhsty.Phoenix_release_time__c = system.today();
        holdhsty.Phoenix_Bid_Approval_Status__c = 'Contracts';
        insert holdhsty;
        
        Phoenix_Bid_Hold_History__c holdhsty2 = new Phoenix_Bid_Hold_History__c();
        holdhsty2.Phoenix_Bid__c = pb2.id;
        holdhsty2.Phoenix_hold_time__c = system.today();
        holdhsty2.Phoenix_release_time__c = system.today();
        holdhsty2.Phoenix_Bid_Approval_Status__c = 'Contracts';
        insert holdhsty2;
        
        /*   Product2 p2 = new Product2();
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
insert pb2bl1;*/
        
        DepartmentWise_Custom_Report.getContract(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Type__c);
        DepartmentWise_Custom_Report.getContract(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,null);
        DepartmentWise_Custom_Report.getContract(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,'All');
    }
    static testmethod void controllerMethod10() 
    {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        
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
        pb2.Phoenix_Bid_Submitted_Date__c = system.today()-1;//DateTime.now()-1;
        pb2.Phoenix_Bid_Finance_Approved_Date__c = system.today().addDays(1);
        pb2.Phoenix_Bid_Contracts_Approved_Date__c = system.today().addDays(4);
        insert pb2;
        
        DepartmentWise_Custom_Report.getContract(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Type__c);
        DepartmentWise_Custom_Report.getContract(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,null);
        DepartmentWise_Custom_Report.getContract(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,'All');
    }
    static testmethod void controllerMethod11() 
    {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        
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
        pb2.Phoenix_Bid_Submitted_Date__c = system.today()-1;//DateTime.now()-1;
        pb2.Phoenix_Bid_Finance_Approved_Date__c = system.today().addDays(1);
        pb2.Phoenix_Bid_Contracts_Approved_Date__c = system.today().addDays(8);
        insert pb2;
        
        DepartmentWise_Custom_Report.getContract(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Type__c);
        DepartmentWise_Custom_Report.getContract(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,null);
        DepartmentWise_Custom_Report.getContract(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,'All');
    }
    
    static testmethod void controllerMethod12() 
    {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        
        Phoenix_Bid__c pb2 = new Phoenix_Bid__c();
        pb2.Phoenix_Status__c = 'New';
        pb2.Phoenix_Comments__c = 'Test Comments';
        pb2.Phoenix_Customer__c = testAccount.Id;
        pb2.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb2.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb2.Phoenix_Bid_Deadline_Date__c = System.today();
        pb2.Phoenix_Bid_Type__c = 'RFP Bids';
        pb2.Phoenix_Bid_Submitted_Date__c = system.today();//DateTime.now()-1;
        pb2.Phoenix_Bid_Finance_Approved_Date__c = system.today();
        pb2.Phoenix_Bid_Contracts_Approved_Date__c = system.today();
        insert pb2;
        
         Phoenix_Bid_Hold_History__c holdhsty = new Phoenix_Bid_Hold_History__c();
        holdhsty.Phoenix_Bid__c = pb2.id;
        holdhsty.Phoenix_hold_time__c = System.now();
        holdhsty.Phoenix_release_time__c = System.now().addSeconds(60);
        holdhsty.Phoenix_Bid_Approval_Status__c = 'Contracts';
        insert holdhsty;
        
        Phoenix_Bid_Hold_History__c holdhsty2 = new Phoenix_Bid_Hold_History__c();
        holdhsty2.Phoenix_Bid__c = pb2.id;
        holdhsty2.Phoenix_hold_time__c = System.now();
        holdhsty2.Phoenix_release_time__c = System.now().addSeconds(120);
        holdhsty2.Phoenix_Bid_Approval_Status__c = 'Contracts';
        insert holdhsty2;
                
        DepartmentWise_Custom_Report.getContract(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Type__c);
        DepartmentWise_Custom_Report.getContract(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,null);
        DepartmentWise_Custom_Report.getContract(pb2.Phoenix_Bid_Submitted_Date__c,pb2.Phoenix_Bid_Submitted_Date__c,'All');
    }
}