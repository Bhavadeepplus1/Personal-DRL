@isTest
public class Phoenix_PHSControllerClassTest {
    static testmethod void AddPHSMethod() {
        
         List < Phoenix_User_Approval_Matrix__c > approvalGroups = new List < Phoenix_User_Approval_Matrix__c > ();
        List < Phoenix_User_Approval_Matrix__c > approvalUsers = new List < Phoenix_User_Approval_Matrix__c > ();
        List < User > users = new List < User > ();
        List < Phoenix_Approval_Matrix__c > bidMatrixList = new List < Phoenix_Approval_Matrix__c > ();
        
        list < Product2 > prodList = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2', Phoenix_Rx_SRx_OTC__c = 'SRx', Phoenix_Special_Product__c = true, Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3', Phoenix_Rx_SRx_OTC__c = 'OTC', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;   
        Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
        Cntrct.name = 'taest cntrct';
        Cntrct.Phoenix_Contract_Number__c = '223';
        insert Cntrct;
        
         Phoenix_NPR_Data__c nprdat = new Phoenix_NPR_Data__c();
        nprdat.Phoenix_Contract__c = Cntrct.id;
        nprdat.Phoenix_NPR_Status__c = 'Active';
        nprdat.Phoenix_Contract_Number__c = '223';
        nprdat.Phoenix_Product__c = prod1.id;
        nprdat.Phoenix_12Months_Sales_Unit__c = 200;
        nprdat.Phoenix_Contract_Type__c = 'Direct';
        nprdat.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
        nprdat.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
        insert nprdat;
        
        
        Phoenix_PHS_Price_Change__c testNDC=new Phoenix_PHS_Price_Change__c();
        testNDC.Phoenix_Approval_Status__c='Draft';   
        testNDC.Phoenix_PHS_Price_Change_Name__c    ='testRecord';
        testNDC.Phoenix_Contract__c=Cntrct.iD;
        
        insert testNDC;
        
         list < Phoenix_PHS_Price_Change_Line__c > lineItemsList = new list < Phoenix_PHS_Price_Change_Line__c > ();
        Phoenix_PHS_Price_Change_Line__c pbl1=new Phoenix_PHS_Price_Change_Line__c();
        pbl1.Phoenix_PHS_Price_Change__c=testNDC.Id;
      
        pbl1.Phoenix_Product_Name__c = prod1.id;
        
        
        lineItemsList.add(pbl1);
        Phoenix_PHS_Price_Change_Line__c pbl2=new Phoenix_PHS_Price_Change_Line__c();
        pbl2.Phoenix_PHS_Price_Change__c	=testNDC.Id;
     
        pbl2.Phoenix_Product_Name__c = prod2.id;
      
        lineItemsList.add(pbl2);
        insert lineItemsList;
        
        Attachment attach=new Attachment();   	
    	attach.Name='Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=testNDC.Id;
        insert attach;
    	
    	List<Attachment> attachments=[select id, name from Attachment where parent.Id=:testNDC.Id];
        
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(documents.size(), 1);
        
        Phoenix_PHSControllerClass.fetchRecordTypeValues('Phoenix_PHS_Price_Change__c');
        Phoenix_PHSControllerClass.getDataFromCustomSettings();
          Phoenix_PHSControllerClass.getProductInfo(prod1.id);
          Phoenix_PHSControllerClass.savePriceChangeLine(testNDC.Id,lineItemsList);
          Phoenix_PHSControllerClass.getNPRData(Cntrct.Id, Cntrct.Id);
       Phoenix_PHSControllerClass.getDocs(testNDC.Id);
        Phoenix_PHSControllerClass.deleteAttachments(attachments[0].Id);
        Phoenix_PHSControllerClass.updatePHSChangeLineItems(lineItemsList);
        Phoenix_PHSControllerClass.csvFileRead(contentVersionSelect.ContentDocumentId);
        Phoenix_PHSControllerClass.getProducts(new list<string>{prod1.Id,prod2.Id,prod3.Id,prod4.Id});
        Phoenix_PHSControllerClass.getupdatedforExport(lineItemsList[1].Id);
        Phoenix_PHSControllerClass.getRelatedList(testNDC.Id);
          Phoenix_PHSControllerClass.getPriceChangeData(testNDC.Id);
          Phoenix_PHSControllerClass.getPriceChangeLineData(testNDC.Id);
            Phoenix_PHSControllerClass.getChangeLineQuarterly(testNDC.Id, testNDC.Id);
        Phoenix_PHSControllerClass.getSubmitBidInfo(testNDC.Id);
        Phoenix_PHSControllerClass.submitToProceddStep1(testNDC.Id);
         Phoenix_PHSControllerClass.makeApprovals(testNDC.Id,lineItemsList,true,true,false);
        Phoenix_PHSControllerClass.makeApprovals(testNDC.Id,lineItemsList,true,false,true);
        
        
         if (approvalGroups.size() == 0) {
            Phoenix_User_Approval_Matrix__c group1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Sales', Phoenix_Approval_Group_Behavior__c = 'Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Supply Chain', Phoenix_Approval_Group_Behavior__c = 'Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Marketing', Phoenix_Approval_Group_Behavior__c = 'Product based');
            approvalGroups.add(group3);
            
            Phoenix_User_Approval_Matrix__c group4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Sr Director or VP Finance', Phoenix_Approval_Group_Behavior__c = 'Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Contracts', Phoenix_Approval_Group_Behavior__c = 'Account based');
            approvalGroups.add(group5);
            
            insert approvalGroups;
        }
        if (approvalUsers.size() == 0) {
            if (users.size() == 0) {
                Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
                String uid = ('Phoenix' + System.now().getTime()).SubString(0, 8);
                User u1 = new User(Alias = uid, Email = uid + '@phoenix.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/New_York', UserName = uid + '@phoenix.com');
                
                
                users.add(u1);
                
                
                insert users;
            }
            Phoenix_User_Approval_Matrix__c userApp1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(), Phoenix_Is_Approval_Process_User__c = true, Phoenix_Approver__c = UserInfo.getUserId(), User_Group__c = approvalGroups[0].Id);
            approvalUsers.add(userApp1);
            Phoenix_User_Approval_Matrix__c userApp2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(), Phoenix_Is_Approval_Process_User__c = true, Phoenix_Approver__c = users[0].Id, User_Group__c = approvalGroups[2].Id);
            approvalUsers.add(userApp2);
            Phoenix_User_Approval_Matrix__c userApp3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(), Phoenix_Is_Approval_Process_User__c = true, Phoenix_Approver__c = UserInfo.getUserId(), User_Group__c = approvalGroups[1].Id);
            approvalUsers.add(userApp3);
            Phoenix_User_Approval_Matrix__c userApp4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(), Phoenix_Is_Approval_Process_User__c = true, Phoenix_Approver__c = UserInfo.getUserId(), User_Group__c = approvalGroups[2].Id);
            approvalUsers.add(userApp4);
            Phoenix_User_Approval_Matrix__c userApp5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(), Phoenix_Is_Approval_Process_User__c = true, Phoenix_Approver__c = UserInfo.getUserId(), User_Group__c = approvalGroups[3].Id);
            approvalUsers.add(userApp5);
            Phoenix_User_Approval_Matrix__c userApp6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(), Phoenix_Is_Approval_Process_User__c = true, Phoenix_Approver__c = UserInfo.getUserId(), User_Group__c = approvalGroups[4].Id);
            approvalUsers.add(userApp6);
            
            insert approvalUsers;
        }
        
        
        
        
        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c = 'PHS Price Change');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;
        
        List < Phoenix_Approval_Process_Step__c > stepsList = new List < Phoenix_Approval_Process_Step__c > ();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for (Phoenix_Approval_Matrix__c matrix: bidMatrixList) {
            Phoenix_Approval_Process_Step__c rfpStep1 = new Phoenix_Approval_Process_Step__c(Name = 'Initial Submission', Phoenix_Order__c = 1, Phoenix_Is_Notification_Only__c = false, Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep1);
            Phoenix_Approval_Process_Step__c rfpStep2 = new Phoenix_Approval_Process_Step__c(Name = 'Sr Director or VP Finance Approval', Phoenix_Order__c = 2, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Sr Director or VP Finance', Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep2);
           
             Phoenix_Approval_Process_Step__c rfpStep3 = new Phoenix_Approval_Process_Step__c(Name = 'Vistex Update', Phoenix_Order__c = 3, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Home Office', Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep3);
            
            Phoenix_Approval_Process_Step__c rfpStep4 = new Phoenix_Approval_Process_Step__c(Name = 'Closed', Phoenix_Order__c = 4, Phoenix_Is_Notification_Only__c = false, Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep4);
        }
        insert stepsList;
        list < Phoenix_Bid_Process_Steps__c > processList = new list < Phoenix_Bid_Process_Steps__c > ();
        Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c = stepsList[0].Id;
        system.debug('stepsList[0].Id---------------' + stepsList[0].Id);
        bStep.Name = testNDC.Phoenix_PHS_Price_Change_Name__c + '-' + 'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_PHS_Price_Change__c = testNDC.Id;
        
        bStep.Phoenix_Status__c = 'Submitted';
        
        bStep.Phoenix_Sub_Step__c = 1;
        processList.add(bStep);
       
       
        
      
        
     
        
      
     
        Phoenix_Bid_Process_Steps__c bStep2 = new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name = testNDC.Phoenix_PHS_Price_Change_Name__c + '-' + 'Sr Director or VP Finance Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_PHS_Price_Change__c = testNDC.Id;
        bStep2.Phoenix_Process_Step__c = stepsList[1].Id;
        
        bStep2.Phoenix_Status__c = 'In Process';
        bStep2.Phoenix_Approver_Team__c = 'Sr Director or VP Finance';
        
        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
        
        Phoenix_Bid_Process_Steps__c bStep3 = new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name = testNDC.Phoenix_PHS_Price_Change_Name__c + '-' + 'Vistex Update';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_PHS_Price_Change__c = testNDC.Id;
        bStep3.Phoenix_Process_Step__c = stepsList[2].Id;
        
        bStep3.Phoenix_Status__c = 'In Process';
        bStep3.Phoenix_Approver_Team__c = 'Home Office';
        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        
        Phoenix_Bid_Process_Steps__c bStep4 = new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name = testNDC.Phoenix_PHS_Price_Change_Name__c + '-' + 'Closed';
        bStep4.Phoenix_Process_Step__c = stepsList[3].Id;
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_PHS_Price_Change__c = testNDC.Id;
        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        insert processList;
        
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_PHS_Price_Change__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_PHS_Price_Change__c =: testNDC.Id];
        system.debug('---bidProcessStepList---' + bidProcessStepList.size());
        
        
       
         Phoenix_PHSControllerClass.updateNextProcesSteps(testNDC.Id,bidProcessStepList,false,false,true);
        Phoenix_PHSControllerClass.updateNextProcesSteps(testNDC.Id,bidProcessStepList,true,true,false);
         
        Phoenix_PHSControllerClass.deleteLineItems(lineItemsList[1].Id);
           Phoenix_PHSControllerClass.deletePHSLine(lineItemsList[0].Id);
        
    }
    
}