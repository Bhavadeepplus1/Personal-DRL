@isTest
public class AchievedSalesSmryHREmailNotificationTest {
    
    @isTest
    public static void testmethod1()
    {
        
        Target_Achieved_Approval__c app = new Target_Achieved_Approval__c();
        app.Name = 'Test Target Rejection 2';
        app.RSM_Head_Status__c = 'Completed';
        app.RSM_Head_Comments__c = 'Test RSM';
        app.RSM_Head_Approval_Sent_Time_String__c = 'Dec 4 2023 08:59 AM EST';
        app.RSM_Head_Approval_Sent_Time__c = system.today();
        app.RSM_Head_Approval_Completed_Time_String__c = 'Dec 4 2023 08:48 AM EST';
        app.RSM_Head_Approval_Completed_Time__c = system.today();
        app.RSM_Approver__c = 'Dave Smith';
        app.Approval_Status__c = 'Completed';
        app.Financial_Year__c = 'FY 24';
        app.Marketing_Approver__c = 'Milan Kalawadia';
        app.Intial_Approver__c = 'Eric Sutherland';
        //app.SRx_Approver__c = '';
        app.Initiator_Status__c = 'Completed';
        app.SRx_Head_Status__c = 'Completed';
        app.Marketing_Head_Status__c = 'Completed';
        app.SRx_Head_Comments__c = '';
        app.Marketing_Head_Comments__c ='Test Marketing Head';
        app.Initiator_Approval_Sent_Time_String__c = 'Dec 4 2023 06:56 AM EST';
        app.Initiator_Approval_Completed_Time_String__c = 'Dec 4 2023 08:57 AM EST';
        app.Initiator_Approval_Completed_Time__c = system.today();
        app.Marketing_Head_Approval_Completed_Str__c = 'Dec 4 2023 08:57 AM EST';
        app.Marketing_Head_Approval_Completed_Time__c = system.today();
        app.Marketing_Head_Approval_Sent_Time_String__c = 'Dec 4 2023 08:48 AM EST';
        app.Marketing_Head_Approval_Sent_Time__c= system.today();
        app.SRx_Head_Approval_Completed_Time_String__c = 'Dec 4 2023 08:48 AM EST';
        insert app;
        
        
		Achievement_Summary_Table__c ac1 = new Achievement_Summary_Table__c();
        ac1.Name = 'CB-1200491';
        ac1.Sales_Rep_Name__c= 'Doris Hartell';
        ac1.Direct_Sales_Billing_Date__c = Date.newInstance(2023, 01, 27);
        ac1.Direct_Sales__c= 1608199.82;
        ac1.soldToRebatePercent__c='155781';
        ac1.Region__c='West';
        ac1.DateToConsider__c=Date.newInstance(2023, 07, 27);
        ac1.Indirect_Sales__c=12;
            
        insert ac1;

        Achievement_Summary_Table__c ac2 = new Achievement_Summary_Table__c();
        ac2.Name = 'CB-1200491';
        ac2.Sales_Rep_Name__c= 'Doris Hartell';
        ac2.Direct_Sales_Billing_Date__c = Date.newInstance(2023, 12, 27);
        ac2.Direct_Sales__c= 1608199.82;
        ac2.soldToRebatePercent__c='1234';
        ac2.Region__c='East';
        ac2.DateToConsider__c=Date.newInstance(2023, 01, 27);
        ac2.Indirect_Sales__c=12;
        
        insert ac2;
        
        
        Achievement_Summary_Table__c ac3 = new Achievement_Summary_Table__c();
        ac3.Name = 'CB-1200491';
        ac3.Sales_Rep_Name__c= 'Heather Harris';
        ac3.Direct_Sales_Billing_Date__c = Date.newInstance(2023, 04, 27);
        ac3.Direct_Sales__c= 1608199.82;
        ac3.soldToRebatePercent__c='1234';
        ac3.Region__c='East';
        ac3.DateToConsider__c=Date.newInstance(2023, 03, 15);
        ac3.Indirect_Sales__c=12;
        
        insert ac3;
        
        Achievement_Summary_Table__c ac4 = new Achievement_Summary_Table__c();
        ac4.Name = 'CB-1200491';
        ac4.Sales_Rep_Name__c= 'Mike Alfino';
        ac4.Direct_Sales_Billing_Date__c = Date.newInstance(2023, 07, 27);
        ac4.Direct_Sales__c= 1608199.82;
        ac4.soldToRebatePercent__c='1234';
        ac4.Region__c='East';
        ac4.DateToConsider__c=Date.newInstance(2023, 09, 10);
        ac4.Indirect_Sales__c=12;
        
        insert ac4;
        
        
        
        SRx_Target__c st=new SRx_Target__c();
        st.Financial_Year__c='FY24';
        st.Approval_Status__c='Accepted';
        
        insert st;
        
        Sales_Reps_Targets__c srt=new Sales_Reps_Targets__c();
        srt.SRx_Target__c=st.Id;
        srt.Quarter_4__c=1;
       	srt.Quarter_3__c=2;
        srt.Quarter_2__c=3;
        srt.Quarter_1__c=4;
        srt.Region__c='West';
            
        insert srt;
        
        Phoenix_SRx_Direct_Sales_Data__c  srx1 = new Phoenix_SRx_Direct_Sales_Data__c();
        //srx1.Sales__c = 1260;
        //srx1.Billing_Date__c = Date.newInstance(2023, 04, 7);
        srx1.Phoenix_Sales_Rep__c = 'Nathan Cumme';
        srx1.Phoenix_Billing_Date__c = '2023-04-07';
        srx1.Phoenix_Sold_To_Rebate_Recipient__c = '155781';
        srx1.Phoenix_Gross__c = '20000';
        insert srx1;
        
        Phoenix_SRx_Direct_Sales_Data__c  srx2 = new Phoenix_SRx_Direct_Sales_Data__c();
        //srx1.Sales__c = 1260;
        //srx1.Billing_Date__c = Date.newInstance(2023, 04, 7);
        srx2.Phoenix_Sales_Rep__c = 'Andre White';
        srx2.Phoenix_Billing_Date__c = '2023-10-21';
        srx2.Phoenix_Sold_To_Rebate_Recipient__c = '166462';
        srx1.Phoenix_Gross__c = '2000';
        insert srx2;        
        
        
        //AchievedSalesSummaryHREmailNotification.captureWrapperData();
        //AchievedSalesSummaryHREmailNotification.SendEmail(app.Id);
        AchievedSalesSummaryHREmailNotification.percentCalculate(100,1000);
        AchievedSalesSummaryHREmailNotification.employeeDetails('Andre White');
        AchievedSalesSummaryHREmailNotification.achievedTargetData(app.Id);
        AchievedSalesSummaryHREmailNotification.reduceDecimal(90.20);
        //AchievedSalesSummaryHREmailNotification.salesRepTargetData();
    }

}