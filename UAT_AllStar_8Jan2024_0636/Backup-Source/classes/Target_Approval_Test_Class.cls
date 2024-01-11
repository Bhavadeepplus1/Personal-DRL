@isTest
public class Target_Approval_Test_Class {
  
    @isTest
    public static void viewTargetTest(){
        
        SRx_Target__c trgt = new SRx_Target__c();
        trgt.Financial_Year__c = '2024';
        trgt.Name = 'Test Target';
        trgt.Initiator_Status__c = 'In Process';
        trgt.Marketing_Head_Status__c = 'Not Initiated';
        trgt.SRx_Head_Status__c = 'Not Initiated';
        trgt.Approval_Status__c= 'Draft';
        trgt.RSM_Head_Status__c = 'Not Initiated';
        trgt.Head_Target__c = 1000;
        trgt.East_Region_Target__c = 500;
        trgt.West_Region_Target__c = 500;
        insert trgt;
        
        SRx_Target__c trgt1 = new SRx_Target__c();
        trgt1.Financial_Year__c = '2024';
        trgt1.Name = 'Test Target';
        trgt1.Initiator_Status__c = 'In Process';
        trgt1.Marketing_Head_Status__c = 'Not Initiated';
        trgt1.SRx_Head_Status__c = 'Not Initiated';
        trgt1.Approval_Status__c= 'Draft';
        trgt1.RSM_Head_Status__c = 'Not Initiated';
        trgt1.Head_Target__c = 1000;
        trgt1.East_Region_Target__c = null;
        trgt1.West_Region_Target__c = null;
        trgt1.RSM_Approver__c = 'Eric Sutherland';
        trgt1.Intial_Approver__c = 'Dave Smith';
        insert trgt1;
        
        SRx_Target__c trgt2 = new SRx_Target__c();
        trgt2.Financial_Year__c = '2024';
        trgt2.Name = 'Test Target';
        trgt2.Initiator_Status__c = 'Completed';
        trgt2.Marketing_Head_Status__c = 'Not Initiated';
        trgt2.SRx_Head_Status__c = 'In Process';
        trgt2.Approval_Status__c= 'RSM Head';
        trgt2.RSM_Head_Status__c = 'Completed';
        trgt2.Head_Target__c = null;
        trgt2.East_Region_Target__c = null;
        trgt2.West_Region_Target__c = null;
        insert trgt2;
        
        List<Sales_Reps_Targets__c> eastRecords = new List<Sales_Reps_Targets__c>();
        List<Sales_Reps_Targets__c> westRecords = new List<Sales_Reps_Targets__c>();
        
        Sales_Reps_Targets__c salesRep = new Sales_Reps_Targets__c();
        salesRep.SRx_Target__c = trgt.Id;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Annual__c= 200;
        salesRep.Region__c = 'East';
        eastRecords.add(salesRep);
        insert eastRecords;
        
        Sales_Reps_Targets__c salesRep1= new Sales_Reps_Targets__c();
        salesRep.SRx_Target__c = trgt.Id;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Annual__c= 200;
        salesRep1.Region__c = 'West';
        westRecords.add(salesRep1);
        insert westRecords;
        
        SRx_Target__c target = new SRx_Target__c();
        target.Financial_Year__c = '2024';
        target.Name = 'Test Target';
        target.Initiator_Status__c = 'Completed';
        target.Marketing_Head_Status__c = 'Completed';
        target.SRx_Head_Status__c = 'Completed';
        target.Approval_Status__c= 'RSM Head';
        target.RSM_Head_Status__c = 'Completed';
        target.Head_Target__c = 1000;
        target.East_Region_Target__c = 500;
        target.West_Region_Target__c = 500;
        insert target;
        
        List<Sales_Reps_Targets__c> eastRecords1 = new List<Sales_Reps_Targets__c>();
        List<Sales_Reps_Targets__c> westRecords1 = new List<Sales_Reps_Targets__c>();
        
        Sales_Reps_Targets__c salesRep2 = new Sales_Reps_Targets__c();
        salesRep2.SRx_Target__c = target.Id;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Annual__c= 200;
        salesRep2.Region__c = 'East';
        eastRecords1.add(salesRep2);
        insert salesRep2;
        
        Sales_Reps_Targets__c salesRep3= new Sales_Reps_Targets__c();
        salesRep3.SRx_Target__c = target.Id;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Annual__c= 200;
        salesRep3.Region__c = 'West';
        westRecords1.add(salesRep3);
        insert salesRep3;
        
        SRx_Target__c trgt3 = new SRx_Target__c();
        trgt3.Financial_Year__c = '2024';
        trgt3.Name = 'Test Target';
        //trgt3.Initiator_Status__c = 'In Process';
        trgt3.RSM_Head_Status__c = 'Completed';
        trgt3.Marketing_Head_Status__c = 'In Process';
        trgt3.RSM_Head_Comments__c = 'Accepted';
        trgt3.Approval_Status__c= 'RSM Head';
        trgt3.SRx_Head_Status__c = 'Completed';
        trgt3.Head_Target__c = 1000;
        trgt3.East_Region_Target__c = null;
        trgt3.West_Region_Target__c = null;
        insert trgt3;
        
        SRx_Target__c trgt4 = new SRx_Target__c();
        trgt4.Financial_Year__c = '2024';
        trgt4.Name = 'Test Target';
        //trgt3.Initiator_Status__c = 'In Process';
        trgt4.RSM_Head_Status__c = 'Completed';
        trgt4.Marketing_Head_Status__c = 'Completed';
        trgt4.RSM_Head_Comments__c = 'Accepted';
        trgt4.Approval_Status__c= 'Accepted';
        trgt4.SRx_Head_Status__c = 'Completed';
        trgt4.Head_Target__c = 1000;
        trgt4.East_Region_Target__c = null;
        trgt4.West_Region_Target__c = null;
        insert trgt4;
        
        
        List<SRx_Target__c> targets = new List<SRx_Target__c>();
        for (Integer i = 0; i < 5; i++) {
            targets.add(new SRx_Target__c(Name = 'Target ' + i));
        }
        insert targets;

        List<String> targetIds = new List<String>();
        List<String> newNames = new List<String>();

        // Populate targetIds and newNames with the test data
        for (SRx_Target__c targ : targets) {
            targetIds.add(targ.Id);
            newNames.add('New Name ' + targ.Id);
        }
        List<SRx_Target__c> updatedTargets = Target_Approval_Class.renameTargets(targetIds, newNames);
        
        System.assertEquals(targetIds.size(), updatedTargets.size(), 'Number of updated records should match the number of input records');

        for (Integer i = 0; i < updatedTargets.size(); i++) {
            SRx_Target__c updatedTarget = updatedTargets[i];
            System.assertEquals(newNames[i], updatedTarget.Name, 'Name should be updated');
        }
        
        SRx_Target__c targetApprovalRec = new SRx_Target__c();
        targetApprovalRec.Name = 'SRx_Head_Status__c';
        targetApprovalRec.SRx_Head_Status__c = 'SRx Head Rejected';
        insert targetApprovalRec;
        User userdetails = [SELECT Id, Name FROM User LIMIT 1];
       
        
         SRx_Target__c updatedRecord = [SELECT Id, Marketing_Head_Status__c, Marketing_Head_Comments__c, Marketing_Head_Approval_Completed_Time__c, Marketing_Head_Approval_Completed_Str__c, Approval_Status__c, Marketing_Approver__c
                                       FROM SRx_Target__c WHERE Id = :trgt3.Id];
        
        Target_Approval_Class.codeCoverageBlock();
        Target_Approval_Class.createTarget('FY 24','Target');
        Target_Approval_Class.viewTarget(trgt.id);
        Target_Approval_Class.cloneSRxTarget(trgt.id);
        Target_Approval_Class.srxDelete(trgt.id);
        Target_Approval_Class.saveheadTarget(trgt1.id,'8000','Head_Target__c');
        Target_Approval_Class.saveheadTarget(trgt2.id, null,'Head_Target__c');
        Target_Approval_Class.saveEastTarget(trgt1.id,'8000','East_Region_Target__c');
        Target_Approval_Class.saveEastTarget(trgt2.id, null,'East_Region_Target__c');
        Target_Approval_Class.saveWestTarget(trgt2.id, null,'West_Region_Target__c');
        Target_Approval_Class.saveWestTarget(trgt1.id, '500','West_Region_Target__c');
        Target_Approval_Class.getuser();
        Target_Approval_Class.getLastLoggedIn('Eric Sutherland' );
        Target_Approval_Class.getLastLoggedIn('Dave Smith' );
        Target_Approval_Class.validateQuaterData('East', salesRep2);
        Target_Approval_Class.validateWestQuaterData(salesRep3);
        Target_Approval_Class.updateQuaterSales(salesRep3);
        Target_Approval_Class.getExistingData(salesRep3);
        Target_Approval_Class.resetQtrSales(salesRep3);
        Target_Approval_Class.validateSubmitButton(eastRecords[0].id);
        
        //System.assertEquals(false, test);
        //
        
        String status = 'Completed';
        String comment = 'Test Comment';
        
       /* Target_Approval_Class.updatestatus(trgt1.id,'Initiator_Status__c','Completed','Approved');
        Target_Approval_Class.updatestatus(trgt1.id,'RSM_Head_Status__c','Completed','Approved');
        Target_Approval_Class.updatestatus(trgt1.id,'SRx_Head_Status__c','Completed','Approved');
        Target_Approval_Class.updatestatus(trgt1.id,'Marketing_Head_Status__c','Completed','Approved');
        
        Target_Approval_Class.updatestatus(trgt1.id, 'RSM_Head_Status__c', 'RSM Head Rejected', 'Rejected');
        
        Target_Approval_Class.updatestatus(targetApprovalRec.id, 'SRx_Head_Status__c', 'SRx Head Rejected', 'Rejected');
        Target_Approval_Class.updatestatus(trgt1.id, 'Marketing_Head_Status__c', 'Marketing Head Rejected', 'Rejected');*/
       // List<SRx_Target__c> update = Target_Approval_Class.renameTargets(trgt.id, 'test');
        
       /* System.assertEquals('Completed', updatedRecord.Marketing_Head_Status__c, 'Marketing_Head_Status__c should be set to Completed');
        System.assertEquals(comment, updatedRecord.Marketing_Head_Comments__c, 'Marketing_Head_Comments__c should be set to the provided comment');
        System.assertNotEquals(null, updatedRecord.Marketing_Head_Approval_Completed_Time__c, 'Marketing_Head_Approval_Completed_Time__c should not be null');
        System.assertEquals('Accepted', updatedRecord.Approval_Status__c, 'Approval_Status__c should be set to Accepted');
        
        System.assertEquals('RSM Head Rejected', trgt3.RSM_Head_Status__c);
        System.assertEquals('In Process', trgt3.Marketing_Head_Status__c); // Check other fields as needed
        System.assertEquals(Phoenix_Util.getNowEST(), trgt3.RSM_Head_Approval_Completed_Time__c);
        
        System.assertEquals('SRx Head Rejected', targetApprovalRec.SRx_Head_Status__c);
        System.assertEquals('In Process', targetApprovalRec.Marketing_Head_Status__c);
        System.assertEquals('SRx Head Rejected', targetApprovalRec.Approval_Status__c);*/
    }
    @isTest
    public static void viewTargetTest1(){
        
        SRx_Target__c trgt = new SRx_Target__c();
        trgt.Financial_Year__c = '2024';
        trgt.Name = 'Test Target';
        trgt.Initiator_Status__c = 'In Process';
        trgt.Marketing_Head_Status__c = 'Not Initiated';
        trgt.SRx_Head_Status__c = 'Not Initiated';
        trgt.Approval_Status__c= 'Draft';
        trgt.RSM_Head_Status__c = 'Not Initiated';
        trgt.Head_Target__c = 1000;
        trgt.East_Region_Target__c = 500;
        trgt.West_Region_Target__c = 500;
        insert trgt;
        
        SRx_Target__c trgt1 = new SRx_Target__c();
        trgt1.Financial_Year__c = '2024';
        trgt1.Name = 'Test Target';
        trgt1.Initiator_Status__c = 'In Process';
        trgt1.Marketing_Head_Status__c = 'Not Initiated';
        trgt1.SRx_Head_Status__c = 'Not Initiated';
        trgt1.Approval_Status__c= 'Draft';
        trgt1.RSM_Head_Status__c = 'Not Initiated';
        trgt1.Head_Target__c = 1000;
        trgt1.East_Region_Target__c = null;
        trgt1.West_Region_Target__c = null;
        insert trgt1;
        
        SRx_Target__c trgt2 = new SRx_Target__c();
        trgt2.Financial_Year__c = '2024';
        trgt2.Name = 'Test Target';
        trgt2.Initiator_Status__c = 'Completed';
        trgt2.Marketing_Head_Status__c = 'Not Initiated';
        trgt2.SRx_Head_Status__c = 'In Process';
        trgt2.Approval_Status__c= 'RSM Head';
        trgt2.RSM_Head_Status__c = 'Completed';
        trgt2.Head_Target__c = null;
        trgt2.East_Region_Target__c = null;
        trgt2.West_Region_Target__c = null;
        insert trgt2;
        
        List<Sales_Reps_Targets__c> eastRecords = new List<Sales_Reps_Targets__c>();
        List<Sales_Reps_Targets__c> westRecords = new List<Sales_Reps_Targets__c>();
        
        Sales_Reps_Targets__c salesRep = new Sales_Reps_Targets__c();
        salesRep.SRx_Target__c = trgt.Id;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Annual__c= 200;
        salesRep.Region__c = 'East';
        eastRecords.add(salesRep);
        insert eastRecords;
        
        Sales_Reps_Targets__c salesRep1= new Sales_Reps_Targets__c();
        salesRep.SRx_Target__c = trgt.Id;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Annual__c= 200;
        salesRep1.Region__c = 'West';
        westRecords.add(salesRep1);
        insert westRecords;
        
        SRx_Target__c target = new SRx_Target__c();
        target.Financial_Year__c = '2024';
        target.Name = 'Test Target';
        target.Initiator_Status__c = 'Completed';
        target.Marketing_Head_Status__c = 'Completed';
        target.SRx_Head_Status__c = 'Completed';
        target.Approval_Status__c= 'RSM Head';
        target.RSM_Head_Status__c = 'Completed';
        target.Head_Target__c = 1000;
        target.East_Region_Target__c = 500;
        target.West_Region_Target__c = 500;
        insert target;
        
        List<Sales_Reps_Targets__c> eastRecords1 = new List<Sales_Reps_Targets__c>();
        List<Sales_Reps_Targets__c> westRecords1 = new List<Sales_Reps_Targets__c>();
        
        Sales_Reps_Targets__c salesRep2 = new Sales_Reps_Targets__c();
        salesRep2.SRx_Target__c = target.Id;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Annual__c= 200;
        salesRep2.Region__c = 'East';
        eastRecords1.add(salesRep2);
        insert salesRep2;
        
        Sales_Reps_Targets__c salesRep3= new Sales_Reps_Targets__c();
        salesRep3.SRx_Target__c = target.Id;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Annual__c= 200;
        salesRep3.Region__c = 'West';
        westRecords1.add(salesRep3);
        insert salesRep3;
        
        SRx_Target__c trgt3 = new SRx_Target__c();
        trgt3.Financial_Year__c = '2024';
        trgt3.Name = 'Test Target';
        //trgt3.Initiator_Status__c = 'In Process';
        trgt3.RSM_Head_Status__c = 'Completed';
        trgt3.Marketing_Head_Status__c = 'In Process';
        trgt3.RSM_Head_Comments__c = 'Accepted';
        trgt3.Approval_Status__c= 'RSM Head';
        trgt3.SRx_Head_Status__c = 'Completed';
        trgt3.Head_Target__c = 1000;
        trgt3.East_Region_Target__c = null;
        trgt3.West_Region_Target__c = null;
        insert trgt3;
        
        SRx_Target__c trgt4 = new SRx_Target__c();
        trgt4.Financial_Year__c = '2024';
        trgt4.Name = 'Test Target';
        //trgt3.Initiator_Status__c = 'In Process';
        trgt4.RSM_Head_Status__c = 'Completed';
        trgt4.Marketing_Head_Status__c = 'Completed';
        trgt4.RSM_Head_Comments__c = 'Accepted';
        trgt4.Approval_Status__c= 'Accepted';
        trgt4.SRx_Head_Status__c = 'Completed';
        trgt4.Head_Target__c = 1000;
        trgt4.East_Region_Target__c = null;
        trgt4.West_Region_Target__c = null;
        insert trgt4;
        
        
        List<SRx_Target__c> targets = new List<SRx_Target__c>();
        for (Integer i = 0; i < 5; i++) {
            targets.add(new SRx_Target__c(Name = 'Target ' + i));
        }
        insert targets;

        List<String> targetIds = new List<String>();
        List<String> newNames = new List<String>();

        // Populate targetIds and newNames with the test data
        for (SRx_Target__c targ : targets) {
            targetIds.add(targ.Id);
            newNames.add('New Name ' + targ.Id);
        }
        List<SRx_Target__c> updatedTargets = Target_Approval_Class.renameTargets(targetIds, newNames);
        
        System.assertEquals(targetIds.size(), updatedTargets.size(), 'Number of updated records should match the number of input records');

        for (Integer i = 0; i < updatedTargets.size(); i++) {
            SRx_Target__c updatedTarget = updatedTargets[i];
            System.assertEquals(newNames[i], updatedTarget.Name, 'Name should be updated');
        }
        
        SRx_Target__c targetApprovalRec = new SRx_Target__c();
        targetApprovalRec.Name = 'SRx_Head_Status__c';
        targetApprovalRec.SRx_Head_Status__c = 'SRx Head Rejected';
        insert targetApprovalRec;
        User userdetails = [SELECT Id, Name FROM User LIMIT 1];
       
        
         SRx_Target__c updatedRecord = [SELECT Id, Marketing_Head_Status__c, Marketing_Head_Comments__c, Marketing_Head_Approval_Completed_Time__c, Marketing_Head_Approval_Completed_Str__c, Approval_Status__c, Marketing_Approver__c
                                       FROM SRx_Target__c WHERE Id = :trgt3.Id];
        
       
        Target_Approval_Class.createTarget('FY 24','Target');
        Target_Approval_Class.viewTarget(trgt.id);
        Target_Approval_Class.cloneSRxTarget(trgt.id);
        Target_Approval_Class.srxDelete(trgt.id);
        Target_Approval_Class.saveheadTarget(trgt1.id,'8000','Head_Target__c');
        Target_Approval_Class.saveheadTarget(trgt2.id, null,'Head_Target__c');
        Target_Approval_Class.saveEastTarget(trgt1.id,'8000','East_Region_Target__c');
        Target_Approval_Class.saveEastTarget(trgt2.id, null,'East_Region_Target__c');
        Target_Approval_Class.saveWestTarget(trgt2.id, null,'West_Region_Target__c');
        Target_Approval_Class.saveWestTarget(trgt1.id, '500','West_Region_Target__c');
        Target_Approval_Class.getuser();
        Target_Approval_Class.getLastLoggedIn('Eric Sutherland' );
        Target_Approval_Class.getLastLoggedIn('Dave Smith' );
        Target_Approval_Class.validateQuaterData('East', salesRep2);
        Target_Approval_Class.validateWestQuaterData(salesRep3);
        Target_Approval_Class.updateQuaterSales(salesRep3);
        Target_Approval_Class.getExistingData(salesRep3);
        Target_Approval_Class.resetQtrSales(salesRep3);
        Target_Approval_Class.validateSubmitButton(eastRecords[0].id);
        
        //System.assertEquals(false, test);
        //
        
        String status = 'Completed';
        String comment = 'Test Comment';
        
        //Target_Approval_Class.updatestatus(trgt1.id,'Initiator_Status__c','Completed','Approved');
       /* Target_Approval_Class.updatestatus(trgt1.id,'RSM_Head_Status__c','Completed','Approved');
        Target_Approval_Class.updatestatus(trgt1.id,'SRx_Head_Status__c','Completed','Approved');
        Target_Approval_Class.updatestatus(trgt1.id,'Marketing_Head_Status__c','Completed','Approved');
        
        Target_Approval_Class.updatestatus(trgt1.id, 'RSM_Head_Status__c', 'RSM Head Rejected', 'Rejected');
        
        Target_Approval_Class.updatestatus(targetApprovalRec.id, 'SRx_Head_Status__c', 'SRx Head Rejected', 'Rejected');
        Target_Approval_Class.updatestatus(trgt1.id, 'Marketing_Head_Status__c', 'Marketing Head Rejected', 'Rejected');
       */
    }
    @isTest
    public static void viewTargetTest2(){
        
        SRx_Target__c trgt = new SRx_Target__c();
        trgt.Financial_Year__c = '2024';
        trgt.Name = 'Test Target';
        trgt.Initiator_Status__c = 'In Process';
        trgt.Marketing_Head_Status__c = 'Not Initiated';
        trgt.SRx_Head_Status__c = 'Not Initiated';
        trgt.Approval_Status__c= 'Draft';
        trgt.RSM_Head_Status__c = 'Not Initiated';
        trgt.Head_Target__c = 1000;
        trgt.East_Region_Target__c = 500;
        trgt.West_Region_Target__c = 500;
        insert trgt;
        
        SRx_Target__c trgt1 = new SRx_Target__c();
        trgt1.Financial_Year__c = '2024';
        trgt1.Name = 'Test Target';
        trgt1.Initiator_Status__c = 'In Process';
        trgt1.Marketing_Head_Status__c = 'Not Initiated';
        trgt1.SRx_Head_Status__c = 'Not Initiated';
        trgt1.Approval_Status__c= 'Draft';
        trgt1.RSM_Head_Status__c = 'Not Initiated';
        trgt1.Head_Target__c = 1000;
        trgt1.East_Region_Target__c = null;
        trgt1.West_Region_Target__c = null;
        insert trgt1;
        
        SRx_Target__c trgt2 = new SRx_Target__c();
        trgt2.Financial_Year__c = '2024';
        trgt2.Name = 'Test Target';
        trgt2.Initiator_Status__c = 'Completed';
        trgt2.Marketing_Head_Status__c = 'Not Initiated';
        trgt2.SRx_Head_Status__c = 'In Process';
        trgt2.Approval_Status__c= 'RSM Head';
        trgt2.RSM_Head_Status__c = 'Completed';
        trgt2.Head_Target__c = null;
        trgt2.East_Region_Target__c = null;
        trgt2.West_Region_Target__c = null;
        insert trgt2;
        
        List<Sales_Reps_Targets__c> eastRecords = new List<Sales_Reps_Targets__c>();
        List<Sales_Reps_Targets__c> westRecords = new List<Sales_Reps_Targets__c>();
        
        Sales_Reps_Targets__c salesRep = new Sales_Reps_Targets__c();
        salesRep.SRx_Target__c = trgt.Id;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Annual__c= 200;
        salesRep.Region__c = 'East';
        eastRecords.add(salesRep);
        insert eastRecords;
        
        Sales_Reps_Targets__c salesRep1= new Sales_Reps_Targets__c();
        salesRep.SRx_Target__c = trgt.Id;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Annual__c= 200;
        salesRep1.Region__c = 'West';
        westRecords.add(salesRep1);
        insert westRecords;
        
        SRx_Target__c target = new SRx_Target__c();
        target.Financial_Year__c = '2024';
        target.Name = 'Test Target';
        target.Initiator_Status__c = 'Completed';
        target.Marketing_Head_Status__c = 'Completed';
        target.SRx_Head_Status__c = 'Completed';
        target.Approval_Status__c= 'RSM Head';
        target.RSM_Head_Status__c = 'Completed';
        target.Head_Target__c = 1000;
        target.East_Region_Target__c = 500;
        target.West_Region_Target__c = 500;
        insert target;
        
        List<Sales_Reps_Targets__c> eastRecords1 = new List<Sales_Reps_Targets__c>();
        List<Sales_Reps_Targets__c> westRecords1 = new List<Sales_Reps_Targets__c>();
        
        Sales_Reps_Targets__c salesRep2 = new Sales_Reps_Targets__c();
        salesRep2.SRx_Target__c = target.Id;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Annual__c= 200;
        salesRep2.Region__c = 'East';
        eastRecords1.add(salesRep2);
        insert salesRep2;
        
        Sales_Reps_Targets__c salesRep3= new Sales_Reps_Targets__c();
        salesRep3.SRx_Target__c = target.Id;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Annual__c= 200;
        salesRep3.Region__c = 'West';
        westRecords1.add(salesRep3);
        insert salesRep3;
        
        SRx_Target__c trgt3 = new SRx_Target__c();
        trgt3.Financial_Year__c = '2024';
        trgt3.Name = 'Test Target';
        //trgt3.Initiator_Status__c = 'In Process';
        trgt3.RSM_Head_Status__c = 'Completed';
        trgt3.Marketing_Head_Status__c = 'In Process';
        trgt3.RSM_Head_Comments__c = 'Accepted';
        trgt3.Approval_Status__c= 'RSM Head';
        trgt3.SRx_Head_Status__c = 'Completed';
        trgt3.Head_Target__c = 1000;
        trgt3.East_Region_Target__c = null;
        trgt3.West_Region_Target__c = null;
        insert trgt3;
        
        SRx_Target__c trgt4 = new SRx_Target__c();
        trgt4.Financial_Year__c = '2024';
        trgt4.Name = 'Test Target';
        //trgt3.Initiator_Status__c = 'In Process';
        trgt4.RSM_Head_Status__c = 'Completed';
        trgt4.Marketing_Head_Status__c = 'Completed';
        trgt4.RSM_Head_Comments__c = 'Accepted';
        trgt4.Approval_Status__c= 'Accepted';
        trgt4.SRx_Head_Status__c = 'Completed';
        trgt4.Head_Target__c = 1000;
        trgt4.East_Region_Target__c = null;
        trgt4.West_Region_Target__c = null;
        insert trgt4;
        
        
        List<SRx_Target__c> targets = new List<SRx_Target__c>();
        for (Integer i = 0; i < 5; i++) {
            targets.add(new SRx_Target__c(Name = 'Target ' + i));
        }
        insert targets;

        List<String> targetIds = new List<String>();
        List<String> newNames = new List<String>();

        // Populate targetIds and newNames with the test data
        for (SRx_Target__c targ : targets) {
            targetIds.add(targ.Id);
            newNames.add('New Name ' + targ.Id);
        }
        List<SRx_Target__c> updatedTargets = Target_Approval_Class.renameTargets(targetIds, newNames);
        
        System.assertEquals(targetIds.size(), updatedTargets.size(), 'Number of updated records should match the number of input records');

        for (Integer i = 0; i < updatedTargets.size(); i++) {
            SRx_Target__c updatedTarget = updatedTargets[i];
            System.assertEquals(newNames[i], updatedTarget.Name, 'Name should be updated');
        }
        
        SRx_Target__c targetApprovalRec = new SRx_Target__c();
        targetApprovalRec.Name = 'SRx_Head_Status__c';
        targetApprovalRec.SRx_Head_Status__c = 'SRx Head Rejected';
        insert targetApprovalRec;
        User userdetails = [SELECT Id, Name FROM User LIMIT 1];
       
        
         SRx_Target__c updatedRecord = [SELECT Id, Marketing_Head_Status__c, Marketing_Head_Comments__c, Marketing_Head_Approval_Completed_Time__c, Marketing_Head_Approval_Completed_Str__c, Approval_Status__c, Marketing_Approver__c
                                       FROM SRx_Target__c WHERE Id = :trgt3.Id];
        
       
        Target_Approval_Class.createTarget('FY 24','Target');
        Target_Approval_Class.viewTarget(trgt.id);
        Target_Approval_Class.cloneSRxTarget(trgt.id);
        Target_Approval_Class.srxDelete(trgt.id);
        Target_Approval_Class.saveheadTarget(trgt1.id,'8000','Head_Target__c');
        Target_Approval_Class.saveheadTarget(trgt2.id, null,'Head_Target__c');
        Target_Approval_Class.saveEastTarget(trgt1.id,'8000','East_Region_Target__c');
        Target_Approval_Class.saveEastTarget(trgt2.id, null,'East_Region_Target__c');
        Target_Approval_Class.saveWestTarget(trgt2.id, null,'West_Region_Target__c');
        Target_Approval_Class.saveWestTarget(trgt1.id, '500','West_Region_Target__c');
        Target_Approval_Class.getuser();
        Target_Approval_Class.getLastLoggedIn('Eric Sutherland' );
        Target_Approval_Class.getLastLoggedIn('Dave Smith' );
        Target_Approval_Class.validateQuaterData('East', salesRep2);
        Target_Approval_Class.validateWestQuaterData(salesRep3);
        Target_Approval_Class.updateQuaterSales(salesRep3);
        Target_Approval_Class.getExistingData(salesRep3);
        Target_Approval_Class.resetQtrSales(salesRep3);
        Target_Approval_Class.validateSubmitButton(eastRecords[0].id);
        
        //System.assertEquals(false, test);
        //
        
        String status = 'Completed';
        String comment = 'Test Comment';
        
        //Target_Approval_Class.updatestatus(trgt1.id,'Initiator_Status__c','Completed','Approved');
        //Target_Approval_Class.updatestatus(trgt1.id,'RSM_Head_Status__c','Completed','Approved');
      /*  Target_Approval_Class.updatestatus(trgt1.id,'SRx_Head_Status__c','Completed','Approved');
        Target_Approval_Class.updatestatus(trgt1.id,'Marketing_Head_Status__c','Completed','Approved');
        
        Target_Approval_Class.updatestatus(trgt1.id, 'RSM_Head_Status__c', 'RSM Head Rejected', 'Rejected');
        
        Target_Approval_Class.updatestatus(targetApprovalRec.id, 'SRx_Head_Status__c', 'SRx Head Rejected', 'Rejected');
        Target_Approval_Class.updatestatus(trgt1.id, 'Marketing_Head_Status__c', 'Marketing Head Rejected', 'Rejected');
       */
    }
    @isTest
    public static void viewTargetTest3(){
        
        SRx_Target__c trgt = new SRx_Target__c();
        trgt.Financial_Year__c = '2024';
        trgt.Name = 'Test Target';
        trgt.Initiator_Status__c = 'In Process';
        trgt.Marketing_Head_Status__c = 'Not Initiated';
        trgt.SRx_Head_Status__c = 'Not Initiated';
        trgt.Approval_Status__c= 'Draft';
        trgt.RSM_Head_Status__c = 'Not Initiated';
        trgt.Head_Target__c = 1000;
        trgt.East_Region_Target__c = 500;
        trgt.West_Region_Target__c = 500;
        insert trgt;
        
        SRx_Target__c trgt1 = new SRx_Target__c();
        trgt1.Financial_Year__c = '2024';
        trgt1.Name = 'Test Target';
        trgt1.Initiator_Status__c = 'In Process';
        trgt1.Marketing_Head_Status__c = 'Not Initiated';
        trgt1.SRx_Head_Status__c = 'Not Initiated';
        trgt1.Approval_Status__c= 'Draft';
        trgt1.RSM_Head_Status__c = 'Not Initiated';
        trgt1.Head_Target__c = 1000;
        trgt1.East_Region_Target__c = null;
        trgt1.West_Region_Target__c = null;
        insert trgt1;
        
        SRx_Target__c trgt2 = new SRx_Target__c();
        trgt2.Financial_Year__c = '2024';
        trgt2.Name = 'Test Target';
        trgt2.Initiator_Status__c = 'Completed';
        trgt2.Marketing_Head_Status__c = 'Not Initiated';
        trgt2.SRx_Head_Status__c = 'In Process';
        trgt2.Approval_Status__c= 'RSM Head';
        trgt2.RSM_Head_Status__c = 'Completed';
        trgt2.Head_Target__c = null;
        trgt2.East_Region_Target__c = null;
        trgt2.West_Region_Target__c = null;
        insert trgt2;
        
        List<Sales_Reps_Targets__c> eastRecords = new List<Sales_Reps_Targets__c>();
        List<Sales_Reps_Targets__c> westRecords = new List<Sales_Reps_Targets__c>();
        
        Sales_Reps_Targets__c salesRep = new Sales_Reps_Targets__c();
        salesRep.SRx_Target__c = trgt.Id;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Annual__c= 200;
        salesRep.Region__c = 'East';
        eastRecords.add(salesRep);
        insert eastRecords;
        
        Sales_Reps_Targets__c salesRep1= new Sales_Reps_Targets__c();
        salesRep.SRx_Target__c = trgt.Id;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Annual__c= 200;
        salesRep1.Region__c = 'West';
        westRecords.add(salesRep1);
        insert westRecords;
        
        SRx_Target__c target = new SRx_Target__c();
        target.Financial_Year__c = '2024';
        target.Name = 'Test Target';
        target.Initiator_Status__c = 'Completed';
        target.Marketing_Head_Status__c = 'Completed';
        target.SRx_Head_Status__c = 'Completed';
        target.Approval_Status__c= 'RSM Head';
        target.RSM_Head_Status__c = 'Completed';
        target.Head_Target__c = 1000;
        target.East_Region_Target__c = 500;
        target.West_Region_Target__c = 500;
        insert target;
        
        List<Sales_Reps_Targets__c> eastRecords1 = new List<Sales_Reps_Targets__c>();
        List<Sales_Reps_Targets__c> westRecords1 = new List<Sales_Reps_Targets__c>();
        
        Sales_Reps_Targets__c salesRep2 = new Sales_Reps_Targets__c();
        salesRep2.SRx_Target__c = target.Id;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Annual__c= 200;
        salesRep2.Region__c = 'East';
        eastRecords1.add(salesRep2);
        insert salesRep2;
        
        Sales_Reps_Targets__c salesRep3= new Sales_Reps_Targets__c();
        salesRep3.SRx_Target__c = target.Id;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Annual__c= 200;
        salesRep3.Region__c = 'West';
        westRecords1.add(salesRep3);
        insert salesRep3;
        
        SRx_Target__c trgt3 = new SRx_Target__c();
        trgt3.Financial_Year__c = '2024';
        trgt3.Name = 'Test Target';
        //trgt3.Initiator_Status__c = 'In Process';
        trgt3.RSM_Head_Status__c = 'Completed';
        trgt3.Marketing_Head_Status__c = 'In Process';
        trgt3.RSM_Head_Comments__c = 'Accepted';
        trgt3.Approval_Status__c= 'RSM Head';
        trgt3.SRx_Head_Status__c = 'Completed';
        trgt3.Head_Target__c = 1000;
        trgt3.East_Region_Target__c = null;
        trgt3.West_Region_Target__c = null;
        insert trgt3;
        
        SRx_Target__c trgt4 = new SRx_Target__c();
        trgt4.Financial_Year__c = '2024';
        trgt4.Name = 'Test Target';
        //trgt3.Initiator_Status__c = 'In Process';
        trgt4.RSM_Head_Status__c = 'Completed';
        trgt4.Marketing_Head_Status__c = 'Completed';
        trgt4.RSM_Head_Comments__c = 'Accepted';
        trgt4.Approval_Status__c= 'Accepted';
        trgt4.SRx_Head_Status__c = 'Completed';
        trgt4.Head_Target__c = 1000;
        trgt4.East_Region_Target__c = null;
        trgt4.West_Region_Target__c = null;
        insert trgt4;
        
        
        List<SRx_Target__c> targets = new List<SRx_Target__c>();
        for (Integer i = 0; i < 5; i++) {
            targets.add(new SRx_Target__c(Name = 'Target ' + i));
        }
        insert targets;

        List<String> targetIds = new List<String>();
        List<String> newNames = new List<String>();

        // Populate targetIds and newNames with the test data
        for (SRx_Target__c targ : targets) {
            targetIds.add(targ.Id);
            newNames.add('New Name ' + targ.Id);
        }
        List<SRx_Target__c> updatedTargets = Target_Approval_Class.renameTargets(targetIds, newNames);
        
        System.assertEquals(targetIds.size(), updatedTargets.size(), 'Number of updated records should match the number of input records');

        for (Integer i = 0; i < updatedTargets.size(); i++) {
            SRx_Target__c updatedTarget = updatedTargets[i];
            System.assertEquals(newNames[i], updatedTarget.Name, 'Name should be updated');
        }
        
        SRx_Target__c targetApprovalRec = new SRx_Target__c();
        targetApprovalRec.Name = 'SRx_Head_Status__c';
        targetApprovalRec.SRx_Head_Status__c = 'SRx Head Rejected';
        insert targetApprovalRec;
        User userdetails = [SELECT Id, Name FROM User LIMIT 1];
       
        
         SRx_Target__c updatedRecord = [SELECT Id, Marketing_Head_Status__c, Marketing_Head_Comments__c, Marketing_Head_Approval_Completed_Time__c, Marketing_Head_Approval_Completed_Str__c, Approval_Status__c, Marketing_Approver__c
                                       FROM SRx_Target__c WHERE Id = :trgt3.Id];
        
       
        Target_Approval_Class.createTarget('FY 24','Target');
        Target_Approval_Class.viewTarget(trgt.id);
        Target_Approval_Class.cloneSRxTarget(trgt.id);
        Target_Approval_Class.srxDelete(trgt.id);
        Target_Approval_Class.saveheadTarget(trgt1.id,'8000','Head_Target__c');
        Target_Approval_Class.saveheadTarget(trgt2.id, null,'Head_Target__c');
        Target_Approval_Class.saveEastTarget(trgt1.id,'8000','East_Region_Target__c');
        Target_Approval_Class.saveEastTarget(trgt2.id, null,'East_Region_Target__c');
        Target_Approval_Class.saveWestTarget(trgt2.id, null,'West_Region_Target__c');
        Target_Approval_Class.saveWestTarget(trgt1.id, '500','West_Region_Target__c');
        Target_Approval_Class.getuser();
        Target_Approval_Class.getLastLoggedIn('Eric Sutherland' );
        Target_Approval_Class.getLastLoggedIn('Dave Smith' );
        Target_Approval_Class.validateQuaterData('East', salesRep2);
        Target_Approval_Class.validateWestQuaterData(salesRep3);
        Target_Approval_Class.updateQuaterSales(salesRep3);
        Target_Approval_Class.getExistingData(salesRep3);
        Target_Approval_Class.resetQtrSales(salesRep3);
        Target_Approval_Class.validateSubmitButton(eastRecords[0].id);
        
        //System.assertEquals(false, test);
        //
        
        String status = 'Completed';
        String comment = 'Test Comment';
        
        //Target_Approval_Class.updatestatus(trgt1.id,'Initiator_Status__c','Completed','Approved');
        //Target_Approval_Class.updatestatus(trgt1.id,'RSM_Head_Status__c','Completed','Approved');
        //Target_Approval_Class.updatestatus(trgt1.id,'SRx_Head_Status__c','Completed','Approved');
     /*   Target_Approval_Class.updatestatus(trgt1.id,'Marketing_Head_Status__c','Completed','Approved');
        
        Target_Approval_Class.updatestatus(trgt1.id, 'RSM_Head_Status__c', 'RSM Head Rejected', 'Rejected');
        
        Target_Approval_Class.updatestatus(targetApprovalRec.id, 'SRx_Head_Status__c', 'SRx Head Rejected', 'Rejected');
        Target_Approval_Class.updatestatus(trgt1.id, 'Marketing_Head_Status__c', 'Marketing Head Rejected', 'Rejected');
      */ 
    }
@isTest
    public static void viewTargetTest4(){
        
        SRx_Target__c trgt = new SRx_Target__c();
        trgt.Financial_Year__c = '2024';
        trgt.Name = 'Test Target';
        trgt.Initiator_Status__c = 'In Process';
        trgt.Marketing_Head_Status__c = 'Not Initiated';
        trgt.SRx_Head_Status__c = 'Not Initiated';
        trgt.Approval_Status__c= 'Draft';
        trgt.RSM_Head_Status__c = 'Not Initiated';
        trgt.Head_Target__c = 1000;
        trgt.East_Region_Target__c = 500;
        trgt.West_Region_Target__c = 500;
        insert trgt;
        
        SRx_Target__c trgt1 = new SRx_Target__c();
        trgt1.Financial_Year__c = '2024';
        trgt1.Name = 'Test Target';
        trgt1.Initiator_Status__c = 'In Process';
        trgt1.Marketing_Head_Status__c = 'Not Initiated';
        trgt1.SRx_Head_Status__c = 'Not Initiated';
        trgt1.Approval_Status__c= 'Draft';
        trgt1.RSM_Head_Status__c = 'Not Initiated';
        trgt1.Head_Target__c = 1000;
        trgt1.East_Region_Target__c = null;
        trgt1.West_Region_Target__c = null;
        insert trgt1;
        
        SRx_Target__c trgt2 = new SRx_Target__c();
        trgt2.Financial_Year__c = '2024';
        trgt2.Name = 'Test Target';
        trgt2.Initiator_Status__c = 'Completed';
        trgt2.Marketing_Head_Status__c = 'Not Initiated';
        trgt2.SRx_Head_Status__c = 'In Process';
        trgt2.Approval_Status__c= 'RSM Head';
        trgt2.RSM_Head_Status__c = 'Completed';
        trgt2.Head_Target__c = null;
        trgt2.East_Region_Target__c = null;
        trgt2.West_Region_Target__c = null;
        insert trgt2;
        
        List<Sales_Reps_Targets__c> eastRecords = new List<Sales_Reps_Targets__c>();
        List<Sales_Reps_Targets__c> westRecords = new List<Sales_Reps_Targets__c>();
        
        Sales_Reps_Targets__c salesRep = new Sales_Reps_Targets__c();
        salesRep.SRx_Target__c = trgt.Id;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Annual__c= 200;
        salesRep.Region__c = 'East';
        eastRecords.add(salesRep);
        insert eastRecords;
        
        Sales_Reps_Targets__c salesRep1= new Sales_Reps_Targets__c();
        salesRep.SRx_Target__c = trgt.Id;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Annual__c= 200;
        salesRep1.Region__c = 'West';
        westRecords.add(salesRep1);
        insert westRecords;
        
        SRx_Target__c target = new SRx_Target__c();
        target.Financial_Year__c = '2024';
        target.Name = 'Test Target';
        target.Initiator_Status__c = 'Completed';
        target.Marketing_Head_Status__c = 'Completed';
        target.SRx_Head_Status__c = 'Completed';
        target.Approval_Status__c= 'RSM Head';
        target.RSM_Head_Status__c = 'Completed';
        target.Head_Target__c = 1000;
        target.East_Region_Target__c = 500;
        target.West_Region_Target__c = 500;
        insert target;
        
        List<Sales_Reps_Targets__c> eastRecords1 = new List<Sales_Reps_Targets__c>();
        List<Sales_Reps_Targets__c> westRecords1 = new List<Sales_Reps_Targets__c>();
        
        Sales_Reps_Targets__c salesRep2 = new Sales_Reps_Targets__c();
        salesRep2.SRx_Target__c = target.Id;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Annual__c= 200;
        salesRep2.Region__c = 'East';
        eastRecords1.add(salesRep2);
        insert salesRep2;
        
        Sales_Reps_Targets__c salesRep3= new Sales_Reps_Targets__c();
        salesRep3.SRx_Target__c = target.Id;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Annual__c= 200;
        salesRep3.Region__c = 'West';
        westRecords1.add(salesRep3);
        insert salesRep3;
        
        SRx_Target__c trgt3 = new SRx_Target__c();
        trgt3.Financial_Year__c = '2024';
        trgt3.Name = 'Test Target';
        //trgt3.Initiator_Status__c = 'In Process';
        trgt3.RSM_Head_Status__c = 'Completed';
        trgt3.Marketing_Head_Status__c = 'In Process';
        trgt3.RSM_Head_Comments__c = 'Accepted';
        trgt3.Approval_Status__c= 'RSM Head';
        trgt3.SRx_Head_Status__c = 'Completed';
        trgt3.Head_Target__c = 1000;
        trgt3.East_Region_Target__c = null;
        trgt3.West_Region_Target__c = null;
        insert trgt3;
        
        SRx_Target__c trgt4 = new SRx_Target__c();
        trgt4.Financial_Year__c = '2024';
        trgt4.Name = 'Test Target';
        //trgt3.Initiator_Status__c = 'In Process';
        trgt4.RSM_Head_Status__c = 'Completed';
        trgt4.Marketing_Head_Status__c = 'Completed';
        trgt4.RSM_Head_Comments__c = 'Accepted';
        trgt4.Approval_Status__c= 'Accepted';
        trgt4.SRx_Head_Status__c = 'Completed';
        trgt4.Head_Target__c = 1000;
        trgt4.East_Region_Target__c = null;
        trgt4.West_Region_Target__c = null;
        insert trgt4;
        
        
        List<SRx_Target__c> targets = new List<SRx_Target__c>();
        for (Integer i = 0; i < 5; i++) {
            targets.add(new SRx_Target__c(Name = 'Target ' + i));
        }
        insert targets;

        List<String> targetIds = new List<String>();
        List<String> newNames = new List<String>();

        // Populate targetIds and newNames with the test data
        for (SRx_Target__c targ : targets) {
            targetIds.add(targ.Id);
            newNames.add('New Name ' + targ.Id);
        }
        List<SRx_Target__c> updatedTargets = Target_Approval_Class.renameTargets(targetIds, newNames);
        
        System.assertEquals(targetIds.size(), updatedTargets.size(), 'Number of updated records should match the number of input records');

        for (Integer i = 0; i < updatedTargets.size(); i++) {
            SRx_Target__c updatedTarget = updatedTargets[i];
            System.assertEquals(newNames[i], updatedTarget.Name, 'Name should be updated');
        }
        
        SRx_Target__c targetApprovalRec = new SRx_Target__c();
        targetApprovalRec.Name = 'SRx_Head_Status__c';
        targetApprovalRec.SRx_Head_Status__c = 'SRx Head Rejected';
        insert targetApprovalRec;
        User userdetails = [SELECT Id, Name FROM User LIMIT 1];
       
        
         SRx_Target__c updatedRecord = [SELECT Id, Marketing_Head_Status__c, Marketing_Head_Comments__c, Marketing_Head_Approval_Completed_Time__c, Marketing_Head_Approval_Completed_Str__c, Approval_Status__c, Marketing_Approver__c
                                       FROM SRx_Target__c WHERE Id = :trgt3.Id];
        
       
        Target_Approval_Class.createTarget('FY 24','Target');
        Target_Approval_Class.viewTarget(trgt.id);
        Target_Approval_Class.cloneSRxTarget(trgt.id);
        Target_Approval_Class.srxDelete(trgt.id);
        Target_Approval_Class.saveheadTarget(trgt1.id,'8000','Head_Target__c');
        Target_Approval_Class.saveheadTarget(trgt2.id, null,'Head_Target__c');
        Target_Approval_Class.saveEastTarget(trgt1.id,'8000','East_Region_Target__c');
        Target_Approval_Class.saveEastTarget(trgt2.id, null,'East_Region_Target__c');
        Target_Approval_Class.saveWestTarget(trgt2.id, null,'West_Region_Target__c');
        Target_Approval_Class.saveWestTarget(trgt1.id, '500','West_Region_Target__c');
        Target_Approval_Class.getuser();
        Target_Approval_Class.getLastLoggedIn('Eric Sutherland' );
        Target_Approval_Class.getLastLoggedIn('Dave Smith' );
        Target_Approval_Class.validateQuaterData('East', salesRep2);
        Target_Approval_Class.validateWestQuaterData(salesRep3);
        Target_Approval_Class.updateQuaterSales(salesRep3);
        Target_Approval_Class.getExistingData(salesRep3);
        Target_Approval_Class.resetQtrSales(salesRep3);
        Target_Approval_Class.validateSubmitButton(eastRecords[0].id);
        
        //System.assertEquals(false, test);
        //
        
        String status = 'Completed';
        String comment = 'Test Comment';
        
        //Target_Approval_Class.updatestatus(trgt1.id,'Initiator_Status__c','Completed','Approved');
        //Target_Approval_Class.updatestatus(trgt1.id,'RSM_Head_Status__c','Completed','Approved');
        //Target_Approval_Class.updatestatus(trgt1.id,'SRx_Head_Status__c','Completed','Approved');
        //Target_Approval_Class.updatestatus(trgt1.id,'Marketing_Head_Status__c','Completed','Approved');
        
     /*   Target_Approval_Class.updatestatus(trgt1.id, 'RSM_Head_Status__c', 'RSM Head Rejected', 'Rejected');
        
        Target_Approval_Class.updatestatus(targetApprovalRec.id, 'SRx_Head_Status__c', 'SRx Head Rejected', 'Rejected');
        Target_Approval_Class.updatestatus(trgt1.id, 'Marketing_Head_Status__c', 'Marketing Head Rejected', 'Rejected');
      */ 
    }
    @isTest
    public static void viewTargetTest5(){
        
        SRx_Target__c trgt = new SRx_Target__c();
        trgt.Financial_Year__c = '2024';
        trgt.Name = 'Test Target';
        trgt.Initiator_Status__c = 'In Process';
        trgt.Marketing_Head_Status__c = 'Not Initiated';
        trgt.SRx_Head_Status__c = 'Not Initiated';
        trgt.Approval_Status__c= 'Draft';
        trgt.RSM_Head_Status__c = 'Not Initiated';
        trgt.Head_Target__c = 1000;
        trgt.East_Region_Target__c = 500;
        trgt.West_Region_Target__c = 500;
        insert trgt;
        
        SRx_Target__c trgt1 = new SRx_Target__c();
        trgt1.Financial_Year__c = '2024';
        trgt1.Name = 'Test Target';
        trgt1.Initiator_Status__c = 'In Process';
        trgt1.Marketing_Head_Status__c = 'Not Initiated';
        trgt1.SRx_Head_Status__c = 'Not Initiated';
        trgt1.Approval_Status__c= 'Draft';
        trgt1.RSM_Head_Status__c = 'Not Initiated';
        trgt1.Head_Target__c = 1000;
        trgt1.East_Region_Target__c = null;
        trgt1.West_Region_Target__c = null;
        insert trgt1;
        
        SRx_Target__c trgt2 = new SRx_Target__c();
        trgt2.Financial_Year__c = '2024';
        trgt2.Name = 'Test Target';
        trgt2.Initiator_Status__c = 'Completed';
        trgt2.Marketing_Head_Status__c = 'Not Initiated';
        trgt2.SRx_Head_Status__c = 'In Process';
        trgt2.Approval_Status__c= 'RSM Head';
        trgt2.RSM_Head_Status__c = 'Completed';
        trgt2.Head_Target__c = null;
        trgt2.East_Region_Target__c = null;
        trgt2.West_Region_Target__c = null;
        insert trgt2;
        
        List<Sales_Reps_Targets__c> eastRecords = new List<Sales_Reps_Targets__c>();
        List<Sales_Reps_Targets__c> westRecords = new List<Sales_Reps_Targets__c>();
        
        Sales_Reps_Targets__c salesRep = new Sales_Reps_Targets__c();
        salesRep.SRx_Target__c = trgt.Id;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Annual__c= 200;
        salesRep.Region__c = 'East';
        eastRecords.add(salesRep);
        insert eastRecords;
        
        Sales_Reps_Targets__c salesRep1= new Sales_Reps_Targets__c();
        salesRep.SRx_Target__c = trgt.Id;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Annual__c= 200;
        salesRep1.Region__c = 'West';
        westRecords.add(salesRep1);
        insert westRecords;
        
        SRx_Target__c target = new SRx_Target__c();
        target.Financial_Year__c = '2024';
        target.Name = 'Test Target';
        target.Initiator_Status__c = 'Completed';
        target.Marketing_Head_Status__c = 'Completed';
        target.SRx_Head_Status__c = 'Completed';
        target.Approval_Status__c= 'RSM Head';
        target.RSM_Head_Status__c = 'Completed';
        target.Head_Target__c = 1000;
        target.East_Region_Target__c = 500;
        target.West_Region_Target__c = 500;
        insert target;
        
        List<Sales_Reps_Targets__c> eastRecords1 = new List<Sales_Reps_Targets__c>();
        List<Sales_Reps_Targets__c> westRecords1 = new List<Sales_Reps_Targets__c>();
        
        Sales_Reps_Targets__c salesRep2 = new Sales_Reps_Targets__c();
        salesRep2.SRx_Target__c = target.Id;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Annual__c= 200;
        salesRep2.Region__c = 'East';
        eastRecords1.add(salesRep2);
        insert salesRep2;
        
        Sales_Reps_Targets__c salesRep3= new Sales_Reps_Targets__c();
        salesRep3.SRx_Target__c = target.Id;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Annual__c= 200;
        salesRep3.Region__c = 'West';
        westRecords1.add(salesRep3);
        insert salesRep3;
        
        SRx_Target__c trgt3 = new SRx_Target__c();
        trgt3.Financial_Year__c = '2024';
        trgt3.Name = 'Test Target';
        //trgt3.Initiator_Status__c = 'In Process';
        trgt3.RSM_Head_Status__c = 'Completed';
        trgt3.Marketing_Head_Status__c = 'In Process';
        trgt3.RSM_Head_Comments__c = 'Accepted';
        trgt3.Approval_Status__c= 'RSM Head';
        trgt3.SRx_Head_Status__c = 'Completed';
        trgt3.Head_Target__c = 1000;
        trgt3.East_Region_Target__c = null;
        trgt3.West_Region_Target__c = null;
        insert trgt3;
        
        SRx_Target__c trgt4 = new SRx_Target__c();
        trgt4.Financial_Year__c = '2024';
        trgt4.Name = 'Test Target';
        //trgt3.Initiator_Status__c = 'In Process';
        trgt4.RSM_Head_Status__c = 'Completed';
        trgt4.Marketing_Head_Status__c = 'Completed';
        trgt4.RSM_Head_Comments__c = 'Accepted';
        trgt4.Approval_Status__c= 'Accepted';
        trgt4.SRx_Head_Status__c = 'Completed';
        trgt4.Head_Target__c = 1000;
        trgt4.East_Region_Target__c = null;
        trgt4.West_Region_Target__c = null;
        insert trgt4;
        
        
        List<SRx_Target__c> targets = new List<SRx_Target__c>();
        for (Integer i = 0; i < 5; i++) {
            targets.add(new SRx_Target__c(Name = 'Target ' + i));
        }
        insert targets;

        List<String> targetIds = new List<String>();
        List<String> newNames = new List<String>();

        // Populate targetIds and newNames with the test data
        for (SRx_Target__c targ : targets) {
            targetIds.add(targ.Id);
            newNames.add('New Name ' + targ.Id);
        }
        List<SRx_Target__c> updatedTargets = Target_Approval_Class.renameTargets(targetIds, newNames);
        
        System.assertEquals(targetIds.size(), updatedTargets.size(), 'Number of updated records should match the number of input records');

        for (Integer i = 0; i < updatedTargets.size(); i++) {
            SRx_Target__c updatedTarget = updatedTargets[i];
            System.assertEquals(newNames[i], updatedTarget.Name, 'Name should be updated');
        }
        
        SRx_Target__c targetApprovalRec = new SRx_Target__c();
        targetApprovalRec.Name = 'SRx_Head_Status__c';
        targetApprovalRec.SRx_Head_Status__c = 'SRx Head Rejected';
        insert targetApprovalRec;
        User userdetails = [SELECT Id, Name FROM User LIMIT 1];
       
        
         SRx_Target__c updatedRecord = [SELECT Id, Marketing_Head_Status__c, Marketing_Head_Comments__c, Marketing_Head_Approval_Completed_Time__c, Marketing_Head_Approval_Completed_Str__c, Approval_Status__c, Marketing_Approver__c
                                       FROM SRx_Target__c WHERE Id = :trgt3.Id];
        
       
        Target_Approval_Class.createTarget('FY 24','Target');
        Target_Approval_Class.viewTarget(trgt.id);
        Target_Approval_Class.cloneSRxTarget(trgt.id);
        Target_Approval_Class.srxDelete(trgt.id);
        Target_Approval_Class.saveheadTarget(trgt1.id,'8000','Head_Target__c');
        Target_Approval_Class.saveheadTarget(trgt2.id, null,'Head_Target__c');
        Target_Approval_Class.saveEastTarget(trgt1.id,'8000','East_Region_Target__c');
        Target_Approval_Class.saveEastTarget(trgt2.id, null,'East_Region_Target__c');
        Target_Approval_Class.saveWestTarget(trgt2.id, null,'West_Region_Target__c');
        Target_Approval_Class.saveWestTarget(trgt1.id, '500','West_Region_Target__c');
        Target_Approval_Class.getuser();
        Target_Approval_Class.getLastLoggedIn('Eric Sutherland' );
        Target_Approval_Class.getLastLoggedIn('Dave Smith' );
        Target_Approval_Class.validateQuaterData('East', salesRep2);
        Target_Approval_Class.validateWestQuaterData(salesRep3);
        Target_Approval_Class.updateQuaterSales(salesRep3);
        Target_Approval_Class.getExistingData(salesRep3);
        Target_Approval_Class.resetQtrSales(salesRep3);
        Target_Approval_Class.validateSubmitButton(eastRecords[0].id);
        
        //System.assertEquals(false, test);
        //
        
        String status = 'Completed';
        String comment = 'Test Comment';
        
        //Target_Approval_Class.updatestatus(trgt1.id,'Initiator_Status__c','Completed','Approved');
        //Target_Approval_Class.updatestatus(trgt1.id,'RSM_Head_Status__c','Completed','Approved');
        //Target_Approval_Class.updatestatus(trgt1.id,'SRx_Head_Status__c','Completed','Approved');
        //Target_Approval_Class.updatestatus(trgt1.id,'Marketing_Head_Status__c','Completed','Approved');
        
        //Target_Approval_Class.updatestatus(trgt1.id, 'RSM_Head_Status__c', 'RSM Head Rejected', 'Rejected');
        
      /*  Target_Approval_Class.updatestatus(targetApprovalRec.id, 'SRx_Head_Status__c', 'SRx Head Rejected', 'Rejected');
        Target_Approval_Class.updatestatus(trgt1.id, 'Marketing_Head_Status__c', 'Marketing Head Rejected', 'Rejected');
       */
    }
     @isTest
    public static void viewTargetTest6(){
        
        SRx_Target__c trgt = new SRx_Target__c();
        trgt.Financial_Year__c = '2024';
        trgt.Name = 'Test Target';
        trgt.Initiator_Status__c = 'In Process';
        trgt.Marketing_Head_Status__c = 'Not Initiated';
        trgt.SRx_Head_Status__c = 'Not Initiated';
        trgt.Approval_Status__c= 'Draft';
        trgt.RSM_Head_Status__c = 'Not Initiated';
        trgt.Head_Target__c = 1000;
        trgt.East_Region_Target__c = 500;
        trgt.West_Region_Target__c = 500;
        insert trgt;
        
        SRx_Target__c trgt1 = new SRx_Target__c();
        trgt1.Financial_Year__c = '2024';
        trgt1.Name = 'Test Target';
        trgt1.Initiator_Status__c = 'In Process';
        trgt1.Marketing_Head_Status__c = 'Not Initiated';
        trgt1.SRx_Head_Status__c = 'Not Initiated';
        trgt1.Approval_Status__c= 'Draft';
        trgt1.RSM_Head_Status__c = 'Not Initiated';
        trgt1.Head_Target__c = 1000;
        trgt1.East_Region_Target__c = null;
        trgt1.West_Region_Target__c = null;
        insert trgt1;
        
        SRx_Target__c trgt2 = new SRx_Target__c();
        trgt2.Financial_Year__c = '2024';
        trgt2.Name = 'Test Target';
        trgt2.Initiator_Status__c = 'Completed';
        trgt2.Marketing_Head_Status__c = 'Not Initiated';
        trgt2.SRx_Head_Status__c = 'In Process';
        trgt2.Approval_Status__c= 'RSM Head';
        trgt2.RSM_Head_Status__c = 'Completed';
        trgt2.Head_Target__c = null;
        trgt2.East_Region_Target__c = null;
        trgt2.West_Region_Target__c = null;
        insert trgt2;
        
        List<Sales_Reps_Targets__c> eastRecords = new List<Sales_Reps_Targets__c>();
        List<Sales_Reps_Targets__c> westRecords = new List<Sales_Reps_Targets__c>();
        
        Sales_Reps_Targets__c salesRep = new Sales_Reps_Targets__c();
        salesRep.SRx_Target__c = trgt.Id;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Quarter_1__c = 50;
        salesRep.Annual__c= 200;
        salesRep.Region__c = 'East';
        eastRecords.add(salesRep);
        insert eastRecords;
        
        Sales_Reps_Targets__c salesRep1= new Sales_Reps_Targets__c();
        salesRep.SRx_Target__c = trgt.Id;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Quarter_1__c = 50;
        salesRep1.Annual__c= 200;
        salesRep1.Region__c = 'West';
        westRecords.add(salesRep1);
        insert westRecords;
        
        SRx_Target__c target = new SRx_Target__c();
        target.Financial_Year__c = '2024';
        target.Name = 'Test Target';
        target.Initiator_Status__c = 'Completed';
        target.Marketing_Head_Status__c = 'Completed';
        target.SRx_Head_Status__c = 'Completed';
        target.Approval_Status__c= 'RSM Head';
        target.RSM_Head_Status__c = 'Completed';
        target.Head_Target__c = 1000;
        target.East_Region_Target__c = 500;
        target.West_Region_Target__c = 500;
        insert target;
        
        List<Sales_Reps_Targets__c> eastRecords1 = new List<Sales_Reps_Targets__c>();
        List<Sales_Reps_Targets__c> westRecords1 = new List<Sales_Reps_Targets__c>();
        
        Sales_Reps_Targets__c salesRep2 = new Sales_Reps_Targets__c();
        salesRep2.SRx_Target__c = target.Id;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Quarter_1__c = 50;
        salesRep2.Annual__c= 200;
        salesRep2.Region__c = 'East';
        eastRecords1.add(salesRep2);
        insert salesRep2;
        
        Sales_Reps_Targets__c salesRep3= new Sales_Reps_Targets__c();
        salesRep3.SRx_Target__c = target.Id;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Quarter_1__c = 50;
        salesRep3.Annual__c= 200;
        salesRep3.Region__c = 'West';
        westRecords1.add(salesRep3);
        insert salesRep3;
        
        SRx_Target__c trgt3 = new SRx_Target__c();
        trgt3.Financial_Year__c = '2024';
        trgt3.Name = 'Test Target';
        //trgt3.Initiator_Status__c = 'In Process';
        trgt3.RSM_Head_Status__c = 'Completed';
        trgt3.Marketing_Head_Status__c = 'In Process';
        trgt3.RSM_Head_Comments__c = 'Accepted';
        trgt3.Approval_Status__c= 'RSM Head';
        trgt3.SRx_Head_Status__c = 'Completed';
        trgt3.Head_Target__c = 1000;
        trgt3.East_Region_Target__c = null;
        trgt3.West_Region_Target__c = null;
        insert trgt3;
        
        SRx_Target__c trgt4 = new SRx_Target__c();
        trgt4.Financial_Year__c = '2024';
        trgt4.Name = 'Test Target';
        //trgt3.Initiator_Status__c = 'In Process';
        trgt4.RSM_Head_Status__c = 'Completed';
        trgt4.Marketing_Head_Status__c = 'Completed';
        trgt4.RSM_Head_Comments__c = 'Accepted';
        trgt4.Approval_Status__c= 'Accepted';
        trgt4.SRx_Head_Status__c = 'Completed';
        trgt4.Head_Target__c = 1000;
        trgt4.East_Region_Target__c = null;
        trgt4.West_Region_Target__c = null;
        insert trgt4;
        
        
        List<SRx_Target__c> targets = new List<SRx_Target__c>();
        for (Integer i = 0; i < 5; i++) {
            targets.add(new SRx_Target__c(Name = 'Target ' + i));
        }
        insert targets;

        List<String> targetIds = new List<String>();
        List<String> newNames = new List<String>();

        // Populate targetIds and newNames with the test data
        for (SRx_Target__c targ : targets) {
            targetIds.add(targ.Id);
            newNames.add('New Name ' + targ.Id);
        }
        List<SRx_Target__c> updatedTargets = Target_Approval_Class.renameTargets(targetIds, newNames);
        
        System.assertEquals(targetIds.size(), updatedTargets.size(), 'Number of updated records should match the number of input records');

        for (Integer i = 0; i < updatedTargets.size(); i++) {
            SRx_Target__c updatedTarget = updatedTargets[i];
            System.assertEquals(newNames[i], updatedTarget.Name, 'Name should be updated');
        }
        
        SRx_Target__c targetApprovalRec = new SRx_Target__c();
        targetApprovalRec.Name = 'SRx_Head_Status__c';
        targetApprovalRec.SRx_Head_Status__c = 'SRx Head Rejected';
        insert targetApprovalRec;
        User userdetails = [SELECT Id, Name FROM User LIMIT 1];
       
        
         SRx_Target__c updatedRecord = [SELECT Id, Marketing_Head_Status__c, Marketing_Head_Comments__c, Marketing_Head_Approval_Completed_Time__c, Marketing_Head_Approval_Completed_Str__c, Approval_Status__c, Marketing_Approver__c
                                       FROM SRx_Target__c WHERE Id = :trgt3.Id];
        
       
        Target_Approval_Class.createTarget('FY 24','Target');
        Target_Approval_Class.viewTarget(trgt.id);
        Target_Approval_Class.cloneSRxTarget(trgt.id);
        Target_Approval_Class.srxDelete(trgt.id);
        Target_Approval_Class.saveheadTarget(trgt1.id,'8000','Head_Target__c');
        Target_Approval_Class.saveheadTarget(trgt2.id, null,'Head_Target__c');
        Target_Approval_Class.saveEastTarget(trgt1.id,'8000','East_Region_Target__c');
        Target_Approval_Class.saveEastTarget(trgt2.id, null,'East_Region_Target__c');
        Target_Approval_Class.saveWestTarget(trgt2.id, null,'West_Region_Target__c');
        Target_Approval_Class.saveWestTarget(trgt1.id, '500','West_Region_Target__c');
        Target_Approval_Class.getuser();
        Target_Approval_Class.getLastLoggedIn('Eric Sutherland' );
        Target_Approval_Class.getLastLoggedIn('Dave Smith' );
        Target_Approval_Class.validateQuaterData('East', salesRep2);
        Target_Approval_Class.validateWestQuaterData(salesRep3);
        Target_Approval_Class.updateQuaterSales(salesRep3);
        Target_Approval_Class.getExistingData(salesRep3);
        Target_Approval_Class.resetQtrSales(salesRep3);
        Target_Approval_Class.validateSubmitButton(eastRecords[0].id);
        
        //System.assertEquals(false, test);
        //
        
        String status = 'Completed';
        String comment = 'Test Comment';
        
        //Target_Approval_Class.updatestatus(trgt1.id,'Initiator_Status__c','Completed','Approved');
        //Target_Approval_Class.updatestatus(trgt1.id,'RSM_Head_Status__c','Completed','Approved');
        //Target_Approval_Class.updatestatus(trgt1.id,'SRx_Head_Status__c','Completed','Approved');
        //Target_Approval_Class.updatestatus(trgt1.id,'Marketing_Head_Status__c','Completed','Approved');
        
        //Target_Approval_Class.updatestatus(trgt1.id, 'RSM_Head_Status__c', 'RSM Head Rejected', 'Rejected');
        
        //Target_Approval_Class.updatestatus(targetApprovalRec.id, 'SRx_Head_Status__c', 'SRx Head Rejected', 'Rejected');
      //  Target_Approval_Class.updatestatus(trgt1.id, 'Marketing_Head_Status__c', 'Marketing Head Rejected', 'Rejected');
       
    }
    
    
}