@istest
public class Target_Achieved_Approval_Test_Class {
    @isTest
    Public static void testData(){
        Target_Achieved_Approval__c achievedRec = new Target_Achieved_Approval__c();
        achievedRec.Financial_Year__c = '2024';
        achievedRec.Name = 'test';
        achievedRec.Marketing_Head_Status__c = 'Not Initiated';
        achievedRec.SRx_Head_Status__c = 'Not Initiated';
        achievedRec.RSM_Head_Status__c = 'In Process';
        achievedRec.Initiator_Status__c = 'Completed';
        achievedRec.RSM_Head_Status__c = 'In Process';
        achievedRec.Approval_Status__c= 'RSM Head';
        achievedRec.RSM_West_Head_Status__c='Completed';
        insert achievedRec;
        
        Target_Achieved_Approval__c achievedRec1 = new Target_Achieved_Approval__c();
        achievedRec1.Financial_Year__c = '2024';
        achievedRec1.Name = 'test';
        achievedRec1.Marketing_Head_Status__c = 'Not Initiated';
        achievedRec1.SRx_Head_Status__c = 'Not Initiated';
        achievedRec1.RSM_Head_Status__c = 'In Process';
        achievedRec1.Initiator_Status__c = 'Completed';
        achievedRec1.RSM_Head_Status__c = 'In Process';
        achievedRec1.Approval_Status__c= 'RSM Head';
        achievedRec1.RSM_West_Head_Status__c='Completed';
        achievedRec1.RSM_West_Head_Comments__c = 'test';
        insert achievedRec1;
       
         Target_Achieved_Approval__c achievedRec2 = new Target_Achieved_Approval__c();
        achievedRec2.Financial_Year__c = '2024';
        achievedRec2.Name = 'test';
        achievedRec2.Marketing_Head_Status__c = 'Completed';
        achievedRec2.SRx_Head_Status__c = 'Not Initiated';
        achievedRec2.RSM_Head_Status__c = 'In Process';
        achievedRec2.Initiator_Status__c = 'Completed';
        achievedRec2.RSM_Head_Status__c = 'In Process';
        achievedRec2.Approval_Status__c= 'Completed';
        achievedRec2.Marketing_Head_Comments__c = 'test';
        achievedRec2.Marketing_Approver__c = 'Dave Smith';
        insert achievedRec2;
       
        Target_Achieved_Approval_Class.getRecords();
        Target_Achieved_Approval_Class.getLastLoggedIn('Dave Smith');
        Target_Achieved_Approval_Class.viewTarget(achievedRec.Id);
        Target_Achieved_Approval_Class.updatestatus(achievedRec.id, 'RSM_Head_Status__c', 'Completed', 'test');
        Target_Achieved_Approval_Class.updatestatus(achievedRec1.id, 'RSM_West_Head_Status__c', 'Completed', 'test');
        Target_Achieved_Approval_Class.updatestatus(achievedRec2.id, 'Marketing_Head_Status__c', 'Completed', 'test');
        
        Target_Achieved_Approval_Class.getLastLoggedIn('Eric Sutherland');
        
    }
    @isTest
    public static void testData1(){
        Target_Achieved_Approval__c achievedRec3 = new Target_Achieved_Approval__c();
        achievedRec3.Financial_Year__c = '2024';
        achievedRec3.Name = 'test';
        achievedRec3.Marketing_Head_Status__c = 'Not Initiated';
        achievedRec3.SRx_Head_Status__c = 'Not Initiated';
        achievedRec3.Initiator_Status__c = 'Completed';
        achievedRec3.RSM_Head_Status__c = 'East RSM Rejected';
        achievedRec3.Approval_Status__c= 'RSM Rejected';
        achievedRec3.Marketing_Head_Comments__c = 'test';
        achievedRec3.RSM_Head_Comments__c = 'test';
        achievedRec3.RSM_Approver__c = 'Dave Smith';
        insert achievedRec3;
        Target_Achieved_Approval_Class.updatestatus(achievedRec3.id, 'RSM_Head_Status__c', 'East RSM Rejected', 'test');
    }
    @isTest
    public static void testData2(){
                 
        Target_Achieved_Approval__c achievedRec4 = new Target_Achieved_Approval__c();
        achievedRec4.Financial_Year__c = '2024';
        achievedRec4.Name = 'test';
        achievedRec4.Initiator_Status__c = 'Completed';
        achievedRec4.Marketing_Head_Status__c = 'Not Initiated';
        achievedRec4.SRx_Head_Status__c = 'Not Initiated';
        achievedRec4.RSM_West_Head_Status__c = 'West RSM Rejected';
        achievedRec4.Approval_Status__c= 'RSM Rejected';
        achievedRec4.RSM_West_Head_Comments__c = 'test';
        achievedRec4.RSM_Approver__c = 'Dave Smith';
        insert achievedRec4;
        Target_Achieved_Approval_Class.updatestatus(achievedRec4.id, 'RSM_West_Head_Status__c', 'West RSM Rejected', 'test');
    }
      @isTest
    public static void testData3(){
         Target_Achieved_Approval__c achievedRec5 = new Target_Achieved_Approval__c();
        achievedRec5.Financial_Year__c = '2024';
        achievedRec5.Name = 'test';
        achievedRec5.Marketing_Head_Status__c = 'Not Initiated';
        achievedRec5.SRx_Head_Status__c = 'SRx Head Rejected';
        achievedRec5.RSM_Head_Status__c = 'In Process';
        achievedRec5.Approval_Status__c= 'SRx Head Rejected';
        achievedRec5.Initiator_Status__c = 'Completed';
        achievedRec5.RSM_West_Head_Status__c = 'West RSM Rejected';
        achievedRec5.RSM_West_Head_Comments__c = 'test';
        achievedRec5.RSM_Approver__c = 'Dave Smith';
        insert achievedRec5;
        Target_Achieved_Approval_Class.updatestatus(achievedRec5.id, 'SRx_Head_Status__c', 'SRx Head Rejected', 'test'); 
    }
      @isTest
    public static void testData4(){
        
        Target_Achieved_Approval__c achievedRec6 = new Target_Achieved_Approval__c();
        achievedRec6.Financial_Year__c = '2024';
        achievedRec6.Name = 'test';
        achievedRec6.Marketing_Head_Status__c = 'Marketing Head Rejected';
        achievedRec6.SRx_Head_Status__c = 'Completed';
        achievedRec6.RSM_Head_Status__c = 'Completed';
        achievedRec6.Approval_Status__c= 'Marketing Head Rejected';
        achievedRec6.Initiator_Status__c = 'Completed';
        achievedRec6.RSM_West_Head_Status__c = 'Completed';
        achievedRec6.Marketing_Head_Comments__c = 'test';
        achievedRec6.RSM_Approver__c = 'Milan Kalwadia';
        insert achievedRec6;
        Target_Achieved_Approval_Class.updatestatus(achievedRec6.id, 'Marketing_Head_Status__c', 'Marketing Head Rejected', 'test');
    }
}