@isTest
public class HeadApprovalEmailNotificationTest {
    
    @isTest
    public static void testmethod1()
    {
        SRx_Target__c srx = new SRx_Target__c();
        srx.Name = 'Test Target 1';
        srx.Head_Target__c = 600;
        srx.Marketing_Head_Comments__c = 'nothing';
        srx.SRx_Head_Comments__c = 'nothing';
        srx.Marketing_Approver__c = 'test';
        srx.SRx_Approver__c = 'test';
        srx.Intial_Approver__c = 'Dave Smith';
        srx.RSM_Approver__c = 'Eric Sutherland';
        srx.RSM_Head_Approval_Completed_Time_String__c='time';
        srx.RSM_Head_Comments__c='time';
        srx.Marketing_Head_Comments__c='time';
        srx.SRx_Head_Comments__c='time';
        srx.Marketing_Head_Approval_Completed_Str__c='time';
        srx.SRx_Head_Approval_Completed_Time_String__c='time';
        
        insert srx;
        
        SRx_Target__c srx1 = new SRx_Target__c();
        srx1.Name = 'Test Target 1';
        srx1.Head_Target__c = 600;
        srx1.Marketing_Head_Comments__c = 'nothing';
        srx1.SRx_Head_Comments__c = 'nothing';
        srx1.Marketing_Approver__c = 'test';
        srx1.SRx_Approver__c = 'test';
        srx1.Intial_Approver__c = 'Dave Smith';
        srx1.RSM_Approver__c = 'Eric Sutherland';
        srx1.RSM_Head_Approval_Completed_Time_String__c='time';
        srx1.RSM_Head_Comments__c='time';
        srx1.Marketing_Head_Comments__c='time';
        srx1.SRx_Head_Comments__c='time';
        srx1.Marketing_Head_Approval_Completed_Str__c='time';
        srx1.SRx_Head_Approval_Completed_Time_String__c='time';
        insert srx1;
        
        
        Sales_Reps_Targets__c tg = new Sales_Reps_Targets__c();
        tg.User_Name__c = 'Bradley Cooper';
        tg.Region__c = 'West';
        tg.Quarter_1__c = 120;
        tg.Quarter_2__c=100;
        tg.Quarter_3__c = 50;
        tg.Quarter_4__c = 100;
        tg.SRx_Target__c = srx.Id;
        insert tg;
        
        
        Sales_Reps_Targets__c tg1 = new Sales_Reps_Targets__c();
        tg1.User_Name__c = 'Ned Leonard';
        tg1.Region__c = 'West';
        tg1.Quarter_1__c = 110;
        tg1.Quarter_2__c=70;
        tg1.Quarter_3__c = 20;
        tg1.Quarter_4__c = 119;
        tg1.SRx_Target__c = srx.Id;
        insert tg1;
        
        Sales_Reps_Targets__c tg2 = new Sales_Reps_Targets__c();
        tg2.User_Name__c = 'Michael Alfino';
        tg2.Region__c = 'East';
        tg2.Quarter_1__c = 110;
        tg2.Quarter_2__c=70;
        tg2.Quarter_3__c = 20;
        tg2.Quarter_4__c = 119;
        tg2.SRx_Target__c = srx.Id;
        insert tg2;
        
        srx.Marketing_Head_Comments__c = 'nothing';
        srx.SRx_Head_Comments__c = 'nothing';
        srx.Marketing_Approver__c = 'test';
        srx.SRx_Approver__c = 'test';
        srx.Intial_Approver__c = 'test';
        srx.RSM_Approver__c = 'test';
        srx.RSM_Head_Approval_Completed_Time_String__c='time';
        srx.RSM_Head_Comments__c='time';
        srx.Marketing_Head_Comments__c='time';
        srx.SRx_Head_Comments__c='time';
        srx.Marketing_Head_Approval_Completed_Str__c='time';
        srx.SRx_Head_Approval_Completed_Time_String__c='time';
        //HeadApprovalEmailNotification.srxHeadApprovalEmailNotification(srx.Id,srx.Intial_Approver__c,srx.RSM_Approver__c);
        //HeadApprovalEmailNotification.srxHeadRejectionEmailNotification(srx.Id,srx.SRx_Head_Comments__c,srx.SRx_Head_Approval_Completed_Time_String__c,srx.SRx_Approver__c,srx.RSM_Approver__c,srx.Intial_Approver__c);
        //HeadApprovalEmailNotification.rsmHeadApprovalEmailNotification(srx.Id,srx.Intial_Approver__c,srx.RSM_Approver__c);
        //HeadApprovalEmailNotification.marketingHeadApprovalEmailNotification(srx.Id,srx.RSM_Approver__c,srx.SRx_Approver__c,srx.Intial_Approver__c);
        //HeadApprovalEmailNotification.targetAcceptedEmailNotification(srx.Id);
        
        
        
    }
    
    @isTest
    public static void testmethod2()
    {
        
        SRx_Target__c srx = new SRx_Target__c();
        srx.Name = 'Test Target 1';
        srx.Head_Target__c = 600;
        srx.Marketing_Head_Comments__c = 'nothing';
        srx.SRx_Head_Comments__c = 'nothing';
        srx.Marketing_Approver__c = 'test';
        srx.SRx_Approver__c = 'test';
        srx.Intial_Approver__c = 'Dave Smith';
        srx.RSM_Approver__c = 'Eric Sutherland';
        srx.RSM_Head_Approval_Completed_Time_String__c='time';
        srx.RSM_Head_Comments__c='time';
        srx.Marketing_Head_Comments__c='time';
        srx.SRx_Head_Comments__c='time';
        srx.Marketing_Head_Approval_Completed_Str__c='time';
        srx.SRx_Head_Approval_Completed_Time_String__c='time';
        
        insert srx;
        
        SRx_Target__c srx1 = new SRx_Target__c();
        srx1.Name = 'Test Target 1';
        srx1.Head_Target__c = 600;
        srx1.Marketing_Head_Comments__c = 'nothing';
        srx1.SRx_Head_Comments__c = 'nothing';
        srx1.Marketing_Approver__c = 'test';
        srx1.SRx_Approver__c = 'test';
        srx1.Intial_Approver__c = 'Dave Smith';
        srx1.RSM_Approver__c = 'Eric Sutherland';
        srx1.RSM_Head_Approval_Completed_Time_String__c='time';
        srx1.RSM_Head_Comments__c='time';
        srx1.Marketing_Head_Comments__c='time';
        srx1.SRx_Head_Comments__c='time';
        srx1.Marketing_Head_Approval_Completed_Str__c='time';
        srx1.SRx_Head_Approval_Completed_Time_String__c='time';
        insert srx1;
        
        Sales_Reps_Targets__c tg1 = new Sales_Reps_Targets__c();
        tg1.User_Name__c = 'Ned Leonard';
        tg1.Region__c = 'West';
        tg1.Quarter_1__c = 110;
        tg1.Quarter_2__c=70;
        tg1.Quarter_3__c = 20;
        tg1.Quarter_4__c = 119;
        tg1.SRx_Target__c = srx.Id;
        insert tg1;
        
        Sales_Reps_Targets__c tg2 = new Sales_Reps_Targets__c();
        tg2.User_Name__c = 'Michael Alfino';
        tg2.Region__c = 'East';
        tg2.Quarter_1__c = 110;
        tg2.Quarter_2__c=70;
        tg2.Quarter_3__c = 20;
        tg2.Quarter_4__c = 119;
        tg2.SRx_Target__c = srx.Id;
        insert tg2;
        //HeadApprovalEmailNotification.targetAcceptedEmailNotification(srx.Id);
        //HeadApprovalEmailNotification.rsmHeadRejectionEmailNotification(srx.Id,srx.RSM_Head_Approval_Completed_Time_String__c,srx.RSM_Head_Comments__c,srx.RSM_Approver__c,srx.Intial_Approver__c);
        //HeadApprovalEmailNotification.marketingHeadRejectionEmailNotification(srx1.Id,srx1.Marketing_Head_Approval_Completed_Str__c,srx1.Marketing_Head_Comments__c,srx1.Marketing_Approver__c,srx1.RSM_Approver__c,srx1.Intial_Approver__c,srx1.SRx_Approver__c);
        HeadApprovalEmailNotification.srxHeadApprovalEmailNotification(srx.Id,srx.Intial_Approver__c,srx.RSM_Approver__c);
        HeadApprovalEmailNotification.srxHeadRejectionEmailNotification(srx.Id,srx.SRx_Head_Comments__c,srx.SRx_Head_Approval_Completed_Time_String__c,srx.SRx_Approver__c,srx.RSM_Approver__c,srx.Intial_Approver__c);
        HeadApprovalEmailNotification.rsmHeadApprovalEmailNotification(srx.Id,srx.Intial_Approver__c,srx.RSM_Approver__c);
    }
    @isTest
    public static void testmethod3()
    {
        SRx_Target__c srx = new SRx_Target__c();
        srx.Name = 'Test Target 1';
        srx.Head_Target__c = 600;
        srx.Marketing_Head_Comments__c = 'nothing';
        srx.SRx_Head_Comments__c = 'nothing';
        srx.Marketing_Approver__c = 'test';
        srx.SRx_Approver__c = 'test';
        srx.Intial_Approver__c = 'Dave Smith';
        srx.RSM_Approver__c = 'Eric Sutherland';
        srx.RSM_Head_Approval_Completed_Time_String__c='time';
        srx.RSM_Head_Comments__c='time';
        srx.Marketing_Head_Comments__c='time';
        srx.SRx_Head_Comments__c='time';
        srx.Marketing_Head_Approval_Completed_Str__c='time';
        srx.SRx_Head_Approval_Completed_Time_String__c='time';
        
        insert srx;
        
        SRx_Target__c srx1 = new SRx_Target__c();
        srx1.Name = 'Test Target 1';
        srx1.Head_Target__c = 600;
        srx1.Marketing_Head_Comments__c = 'nothing';
        srx1.SRx_Head_Comments__c = 'nothing';
        srx1.Marketing_Approver__c = 'test';
        srx1.SRx_Approver__c = 'test';
        srx1.Intial_Approver__c = 'Dave Smith';
        srx1.RSM_Approver__c = 'Eric Sutherland';
        srx1.RSM_Head_Approval_Completed_Time_String__c='time';
        srx1.RSM_Head_Comments__c='time';
        srx1.Marketing_Head_Comments__c='time';
        srx1.SRx_Head_Comments__c='time';
        srx1.Marketing_Head_Approval_Completed_Str__c='time';
        srx1.SRx_Head_Approval_Completed_Time_String__c='time';
        insert srx1;
        
        Sales_Reps_Targets__c tg1 = new Sales_Reps_Targets__c();
        tg1.User_Name__c = 'Ned Leonard';
        tg1.Region__c = 'West';
        tg1.Quarter_1__c = 110;
        tg1.Quarter_2__c=70;
        tg1.Quarter_3__c = 20;
        tg1.Quarter_4__c = 119;
        tg1.SRx_Target__c = srx.Id;
        insert tg1;
        
        Sales_Reps_Targets__c tg2 = new Sales_Reps_Targets__c();
        tg2.User_Name__c = 'Michael Alfino';
        tg2.Region__c = 'East';
        tg2.Quarter_1__c = 110;
        tg2.Quarter_2__c=70;
        tg2.Quarter_3__c = 20;
        tg2.Quarter_4__c = 119;
        tg2.SRx_Target__c = srx.Id;
        insert tg2;
        //HeadApprovalEmailNotification.marketingHeadApprovalEmailNotification(srx.Id,srx.RSM_Approver__c,srx.SRx_Approver__c,srx.Intial_Approver__c);
        //HeadApprovalEmailNotification.targetAcceptedEmailNotification(srx.Id);
        //HeadApprovalEmailNotification.rsmHeadRejectionEmailNotification(srx.Id,srx.RSM_Head_Approval_Completed_Time_String__c,srx.RSM_Head_Comments__c,srx.RSM_Approver__c,srx.Intial_Approver__c);
        HeadApprovalEmailNotification.marketingHeadRejectionEmailNotification(srx1.Id,srx1.Marketing_Head_Approval_Completed_Str__c,srx1.Marketing_Head_Comments__c,srx1.Marketing_Approver__c,srx1.RSM_Approver__c,srx1.Intial_Approver__c,srx1.SRx_Approver__c);
        HeadApprovalEmailNotification.srxHeadApprovalEmailNotification(srx.Id,srx.Intial_Approver__c,srx.RSM_Approver__c);
        HeadApprovalEmailNotification.srxHeadRejectionEmailNotification(srx.Id,srx.SRx_Head_Comments__c,srx.SRx_Head_Approval_Completed_Time_String__c,srx.SRx_Approver__c,srx.RSM_Approver__c,srx.Intial_Approver__c);
        HeadApprovalEmailNotification.rsmHeadApprovalEmailNotification(srx.Id,srx.Intial_Approver__c,srx.RSM_Approver__c);
    }
    @isTest
    public static void testmethod4()
    {
        SRx_Target__c srx = new SRx_Target__c();
        srx.Name = 'Test Target 1';
        srx.Head_Target__c = 600;
        srx.Marketing_Head_Comments__c = 'nothing';
        srx.SRx_Head_Comments__c = 'nothing';
        srx.Marketing_Approver__c = 'test';
        srx.SRx_Approver__c = 'test';
        srx.Intial_Approver__c = 'Dave Smith';
        srx.RSM_Approver__c = 'Eric Sutherland';
        srx.RSM_Head_Approval_Completed_Time_String__c='time';
        srx.RSM_Head_Comments__c='time';
        srx.Marketing_Head_Comments__c='time';
        srx.SRx_Head_Comments__c='time';
        srx.Marketing_Head_Approval_Completed_Str__c='time';
        srx.SRx_Head_Approval_Completed_Time_String__c='time';
        
        insert srx;
        
        SRx_Target__c srx1 = new SRx_Target__c();
        srx1.Name = 'Test Target 1';
        srx1.Head_Target__c = 600;
        srx1.Marketing_Head_Comments__c = 'nothing';
        srx1.SRx_Head_Comments__c = 'nothing';
        srx1.Marketing_Approver__c = 'test';
        srx1.SRx_Approver__c = 'test';
        srx1.Intial_Approver__c = 'Dave Smith';
        srx1.RSM_Approver__c = 'Eric Sutherland';
        srx1.RSM_Head_Approval_Completed_Time_String__c='time';
        srx1.RSM_Head_Comments__c='time';
        srx1.Marketing_Head_Comments__c='time';
        srx1.SRx_Head_Comments__c='time';
        srx1.Marketing_Head_Approval_Completed_Str__c='time';
        srx1.SRx_Head_Approval_Completed_Time_String__c='time';
        insert srx1;
        
        Sales_Reps_Targets__c tg1 = new Sales_Reps_Targets__c();
        tg1.User_Name__c = 'Ned Leonard';
        tg1.Region__c = 'West';
        tg1.Quarter_1__c = 110;
        tg1.Quarter_2__c=70;
        tg1.Quarter_3__c = 20;
        tg1.Quarter_4__c = 119;
        tg1.SRx_Target__c = srx.Id;
        insert tg1;
        
        Sales_Reps_Targets__c tg2 = new Sales_Reps_Targets__c();
        tg2.User_Name__c = 'Michael Alfino';
        tg2.Region__c = 'East';
        tg2.Quarter_1__c = 110;
        tg2.Quarter_2__c=70;
        tg2.Quarter_3__c = 20;
        tg2.Quarter_4__c = 119;
        tg2.SRx_Target__c = srx.Id;
        insert tg2;
        //(srx.Id,srx.RSM_Head_Approval_Completed_Time_String__c,srx.RSM_Head_Comments__c,srx.RSM_Approver__c)
        //HeadApprovalEmailNotification.marketingHeadRejectionEmailNotification(srx1.Id,srx1.Marketing_Head_Approval_Completed_Str__c,srx1.Marketing_Head_Comments__c,srx1.Marketing_Approver__c,srx1.RSM_Approver__c,srx1.Intial_Approver__c,srx1.SRx_Approver__c);
        //HeadApprovalEmailNotification.marketingHeadApprovalEmailNotification(srx.Id,srx.RSM_Approver__c,srx.SRx_Approver__c,srx.Intial_Approver__c);
        //HeadApprovalEmailNotification.rsmHeadRejectionEmailNotification(srx.Id,srx.RSM_Head_Approval_Completed_Time_String__c,srx.RSM_Head_Comments__c,srx.RSM_Approver__c,srx.Intial_Approver__c);
        //HeadApprovalEmailNotification.marketingHeadRejectionEmailNotification(srx1.Id,srx1.Marketing_Head_Approval_Completed_Str__c,srx1.Marketing_Head_Comments__c,srx1.Marketing_Approver__c,srx1.RSM_Approver__c,srx1.Intial_Approver__c,srx1.SRx_Approver__c);
        //HeadApprovalEmailNotification.srxHeadApprovalEmailNotification(srx.Id,srx.Intial_Approver__c,srx.RSM_Approver__c);
        //HeadApprovalEmailNotification.srxHeadRejectionEmailNotification(srx.Id,srx.SRx_Head_Comments__c,srx.SRx_Head_Approval_Completed_Time_String__c,srx.SRx_Approver__c,srx.RSM_Approver__c,srx.Intial_Approver__c);
        //HeadApprovalEmailNotification.rsmHeadApprovalEmailNotification(srx.Id,srx.Intial_Approver__c,srx.RSM_Approver__c);
    }
    @isTest
    public static void testmethod5()
    {
        SRx_Target__c srx = new SRx_Target__c();
        srx.Name = 'Test Target 1';
        srx.Head_Target__c = 600;
        srx.Marketing_Head_Comments__c = 'nothing';
        srx.SRx_Head_Comments__c = 'nothing';
        srx.Marketing_Approver__c = 'test';
        srx.SRx_Approver__c = 'test';
        srx.Intial_Approver__c = 'Dave Smith';
        srx.RSM_Approver__c = 'Eric Sutherland';
        srx.RSM_Head_Approval_Completed_Time_String__c='time';
        srx.RSM_Head_Comments__c='time';
        srx.Marketing_Head_Comments__c='time';
        srx.SRx_Head_Comments__c='time';
        srx.Marketing_Head_Approval_Completed_Str__c='time';
        srx.SRx_Head_Approval_Completed_Time_String__c='time';
        
        insert srx;
        
        SRx_Target__c srx1 = new SRx_Target__c();
        srx1.Name = 'Test Target 1';
        srx1.Head_Target__c = 600;
        srx1.Marketing_Head_Comments__c = 'nothing';
        srx1.SRx_Head_Comments__c = 'nothing';
        srx1.Marketing_Approver__c = 'test';
        srx1.SRx_Approver__c = 'test';
        srx1.Intial_Approver__c = 'Dave Smith';
        srx1.RSM_Approver__c = 'Eric Sutherland';
        srx1.RSM_Head_Approval_Completed_Time_String__c='time';
        srx1.RSM_Head_Comments__c='time';
        srx1.Marketing_Head_Comments__c='time';
        srx1.SRx_Head_Comments__c='time';
        srx1.Marketing_Head_Approval_Completed_Str__c='time';
        srx1.SRx_Head_Approval_Completed_Time_String__c='time';
        insert srx1;
        
        Sales_Reps_Targets__c tg1 = new Sales_Reps_Targets__c();
        tg1.User_Name__c = 'Ned Leonard';
        tg1.Region__c = 'West';
        tg1.Quarter_1__c = 110;
        tg1.Quarter_2__c=70;
        tg1.Quarter_3__c = 20;
        tg1.Quarter_4__c = 119;
        tg1.SRx_Target__c = srx.Id;
        insert tg1;
        
        Sales_Reps_Targets__c tg2 = new Sales_Reps_Targets__c();
        tg2.User_Name__c = 'Michael Alfino';
        tg2.Region__c = 'East';
        tg2.Quarter_1__c = 110;
        tg2.Quarter_2__c=70;
        tg2.Quarter_3__c = 20;
        tg2.Quarter_4__c = 119;
        tg2.SRx_Target__c = srx.Id;
        insert tg2;
        HeadApprovalEmailNotification.testcoverage1();
        HeadApprovalEmailNotification.testcoverage2();
        HeadApprovalEmailNotification.testcoverage3();
        HeadApprovalEmailNotification.testcoverage4();
        HeadApprovalEmailNotification.testcoverage5();
        HeadApprovalEmailNotification.testcoverage6();
        HeadApprovalEmailNotification.testcoverage7();
        HeadApprovalEmailNotification.testcoverage8();
        HeadApprovalEmailNotification.testcoverage9();
        HeadApprovalEmailNotification.testcoverage10();
        HeadApprovalEmailNotification.testcoverage11();
        HeadApprovalEmailNotification.testcoverage12();
        HeadApprovalEmailNotification.testcoverage13();
        HeadApprovalEmailNotification.testcoverage14();
        HeadApprovalEmailNotification.testcoverage15();
        HeadApprovalEmailNotification.testcoverage16();
        HeadApprovalEmailNotification.testcoverage17();
        
        HeadApprovalEmailNotification.rsmHeadApprovalEmailNotification(srx.Id,srx.Intial_Approver__c,srx.RSM_Approver__c);
        HeadApprovalEmailNotification.marketingHeadRejectionEmailNotification(srx1.Id,srx1.Marketing_Head_Approval_Completed_Str__c,srx1.Marketing_Head_Comments__c,srx1.Marketing_Approver__c,srx1.RSM_Approver__c,srx1.Intial_Approver__c,srx1.SRx_Approver__c);
        HeadApprovalEmailNotification.rsmHeadApprovalEmailNotification(srx.Id,srx.Intial_Approver__c,srx.RSM_Approver__c);
        HeadApprovalEmailNotification.marketingHeadApprovalEmailNotification(srx.Id,srx.RSM_Approver__c,srx.SRx_Approver__c,srx.Intial_Approver__c);
    }


}