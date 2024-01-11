global class QuarterlyTargetRecordCreation implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Date currentDate = System.today();
        Integer fiscalYearStartMonth = 4; // Assuming the fiscal year starts in April, change this according to your organization's settings
        
        Integer currentYear = currentDate.year();
        Integer fiscalYear;
        
        
        fiscalYear = (currentYear+1);
        String FY = String.valueOf(fiscalYear);
        System.debug('Fiscal Year: ' + fiscalYear);
        list<string> quarter1=new list<string>{'Apr','May','Jun'};
            list<string> quarter2=new list<string>{'Jul','Aug','Sep'};
                list<string> quarter3=new list<string>{'Oct','Nov','Dec'};
                    list<string> quarter4=new list<string>{'Jan','Feb','Mar'};
                        String month = DateTime.now().format('MMM');
        String quarter = quarter1.contains(month)?'Q1':quarter2.contains(month)?'Q2':quarter3.contains(month)?'Q3':'Q4';
        if(quarter == 'Q1'){
            quarter='Q4';
        }
        if(quarter == 'Q2'){
            quarter='Q1';
        }
        if(quarter == 'Q3'){
            quarter='Q2';
        }
        if(quarter == 'Q4'){
            quarter='Q3';
        }
        Target_Achieved_Approval__c targetApprovalRec = new Target_Achieved_Approval__c();
        targetApprovalRec.Financial_Year__c = 'FY 24';
        targetApprovalRec.Quarter__c = quarter;
        targetApprovalRec.Name = targetApprovalRec.Financial_Year__c + ' '+quarter+' '+'Target Achievement Approval';
        targetApprovalRec.Marketing_Head_Status__c = 'Not Initiated';
        targetApprovalRec.SRx_Head_Status__c = 'Not Initiated';
        targetApprovalRec.RSM_Head_Status__c = 'In Process';
        targetApprovalRec.RSM_West_Head_Status__c = 'In Process';
        targetApprovalRec.Approval_Status__c= 'RSM Head';
        targetApprovalRec.Initiator_Status__c = 'Completed';
        targetApprovalRec.RSM_Head_Status__c = 'In Process';
        targetApprovalRec.Intial_Approver__c = 'Automatic BRIGHT';
        targetApprovalRec.RSM_Approver__c = 'Eric Sutherland';
        targetApprovalRec.RSM_West_Approver__c = 'Dave Smith';
        targetApprovalRec.Initiator_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
        targetApprovalRec.Initiator_Approval_Completed_Time_String__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.Initiator_Approval_Completed_Time__c, 'America/New_York');
        targetApprovalRec.Initiator_Approval_Sent_Time__c = Phoenix_Util.getNowEST();
        targetApprovalRec.Initiator_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.Initiator_Approval_Sent_Time__c, 'America/New_York');
        targetApprovalRec.RSM_Head_Approval_Sent_Time__c = Phoenix_Util.getNowEST();
        targetApprovalRec.RSM_Head_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.RSM_Head_Approval_Sent_Time__c, 'America/New_York');
        targetApprovalRec.RSM_West_Head_Approval_Sent_Time__c = Phoenix_Util.getNowEST();
        targetApprovalRec.RSM_West_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.RSM_West_Head_Approval_Sent_Time__c, 'America/New_York');
        targetApprovalRec.Approval_Status__c= 'RSM Head';
        
        insert targetApprovalRec;
        HeadAchievedSalesSummaryNotify.rsmWestHeadApprovalAchievedSalesSummaryNotify(targetApprovalRec.Id,'Eric Sutherland');
        HeadAchievedSalesSummaryNotify.rsmEastHeadApprovalAchievedSalesSummaryNotify(targetApprovalRec.Id,'Dave Smith');
        
    }    
}