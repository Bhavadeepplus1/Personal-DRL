@isTest
public class Phoenix_WAC_Change_ControllerTest {
    static testmethod void AddWACChangeMethod(){
        List < Phoenix_User_Approval_Matrix__c > approvalGroups = new List < Phoenix_User_Approval_Matrix__c > ();
        List < Phoenix_User_Approval_Matrix__c > approvalUsers = new List < Phoenix_User_Approval_Matrix__c > ();
        List < User > users = new List < User > ();
        List < Phoenix_Approval_Matrix__c > bidMatrixList = new List < Phoenix_Approval_Matrix__c > ();
        
        list < Product2 > prodList = new list < Product2 > ();
        Product_Family__c pf = new Product_Family__c();
        pf.Name = 'Test Family';
        insert pf;
        Product_Family__c pf1 = new Product_Family__c();
        pf1.Name = 'Sample Family';
        insert pf1;
        Product_Family__c pf2 = new Product_Family__c();
        pf2.Name = 'cetirizine';
        insert pf2;
        Product2 prod1 = new Product2(Name = 'Test Product', Product_Family__c = pf.Id,Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Product_Family__c = pf1.Id,Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2', Product_Family__c = pf2.Id,Phoenix_Rx_SRx_OTC__c = 'SRx', Phoenix_Special_Product__c = true, Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3', Product_Family__c = pf2.Id,Phoenix_Rx_SRx_OTC__c = 'OTC', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;    
        
        Phoenix_WAC_Change__c testWAC = new Phoenix_WAC_Change__c();
        testWAC.Phoenix_WAC_Change_Name__c = 'Test WAC';
        testWAC.Phoenix_Product_Family__c = 'Test Family';
        testWAC.Phoenix_Sales_Increase__c = 10;
        testWAC.Phoenix_Medicaid_release__c = 20;
        testWAC.Phoenix_PHS_hit__c = 30;
        testWAC.Phoenix_WAC_finance_impact__c = 40;
        testWAC.Working_capital_benefit__c = 50;
     //   testWAC.Phoenix_Approval_Status__c = 'Marketing Head Rejected';
        insert testWAC;
        
        list < Phoenix_WAC_Change_Line_Item__c > lineItemsList = new list < Phoenix_WAC_Change_Line_Item__c > ();
        Phoenix_WAC_Change_Line_Item__c pbl1=new Phoenix_WAC_Change_Line_Item__c();
        pbl1.Phoenix_WAC_Change__c=testWAC.Id;
        pbl1.Phoenix_Product__c=prod1.Id;
        //pbl1.Phoenix_Final_Status__c = 'Approved';
        lineItemsList.add(pbl1);
        
        Phoenix_WAC_Change_Line_Item__c pbl2=new Phoenix_WAC_Change_Line_Item__c();
        pbl2.Phoenix_WAC_Change__c=testWAC.Id;
        pbl2.Phoenix_Product__c=prod2.Id;
		//pbl2.Phoenix_Final_Status__c = 'Approved'; 
        
        lineItemsList.add(pbl2);
        
        insert lineItemsList;
        
        Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
        Cntrct.name = 'taest cntrct';
        Cntrct.Phoenix_Contract_Number__c = '223';
        insert Cntrct;
        
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Type__c = 'Product Addition';
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        insert bid;
        
        list < Phoenix_Bid_Process_Steps__c > processStepsList = new list < Phoenix_Bid_Process_Steps__c > ();
        Phoenix_Bid_Process_Steps__c bidStep1 = new Phoenix_Bid_Process_Steps__c();
        bidStep1.Name = 'Test Step';
       // bidStep1.Phoenix_Status__c = 'Completed';
        //bidStep1.Phoenix_Approver__c = userinfo.getuserid();
        
        processStepsList.add(bidStep1);
        
        Phoenix_Bid_Process_Steps__c bidStep2 = new Phoenix_Bid_Process_Steps__c();
        bidStep2.Name = 'Test Step';
      //  bidStep2.Phoenix_Status__c = 'Completed';
     //   bidStep2.Phoenix_Approver__c = userinfo.getuserid();
        processStepsList.add(bidStep2);
        
        insert processStepsList;
        
        List<Phoenix_NPR_Data__c> nprList = new List<Phoenix_NPR_Data__c>();
        Phoenix_NPR_Data__c nprdat1 = new Phoenix_NPR_Data__c(Phoenix_Contract__c=Cntrct.id, Phoenix_NPR_Status__c='Active', Phoenix_Contract_Number__c= '223', Phoenix_Material_Number__c='112',
                                                            Phoenix_Product__c=prod1.Id, Phoenix_12Months_Sales_Unit__c = 200,Phoenix_Contract_Type__c='Direct',Phoenix_Rebate_G_N_Indicator__c='10N+ 0G',
                                                            Phoenix_Bonafied_G_N_Indicator__c='5N+0G');
        Phoenix_NPR_Data__c nprdat2 = new Phoenix_NPR_Data__c(Phoenix_Contract__c=Cntrct.id, Phoenix_NPR_Status__c='Active', Phoenix_Contract_Number__c= '123', Phoenix_Material_Number__c='212',
                                                            Phoenix_Product__c=prod2.Id, Phoenix_12Months_Sales_Unit__c = 200,Phoenix_Contract_Type__c='Direct',Phoenix_Rebate_G_N_Indicator__c='10N+ 0G',
                                                            Phoenix_Bonafied_G_N_Indicator__c='5N+0G');
        
        nprList.add(nprdat1);
        nprList.add(nprdat2);
        insert nprList;
        
        List<String> Material_ContractsList = new List<String>();
        Material_ContractsList.add('223_112');
        Material_ContractsList.add('123_212');
        
        List<Id> lineItemIds = new List<Id>();        
        lineItemIds.add(lineItemsList[0].Id);
        lineItemIds.add(lineItemsList[1].Id);
        
        
        Attachment attach=new Attachment();   	
    	attach.Name='Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=testWAC.Id;
        insert attach;
    	
    	List<Attachment> attachments=[select id, name from Attachment where parent.Id=:testWAC.Id];
        
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
        
        
        Phoenix_WAC_Change_Controller.getActiveBidProductFamilies();
        Phoenix_WAC_Change_Controller.getWACChangeInfo(testWAC.Id);
        Phoenix_WAC_Change_Controller.getDocs(testWAC.Id);
        Phoenix_WAC_Change_Controller.csvFileRead(contentVersionSelect.ContentDocumentId);
        Phoenix_WAC_Change_Controller.getNPRData(Material_ContractsList);
        Phoenix_WAC_Change_Controller.getWACLineItemsList(lineItemsList[0].Id);
        Phoenix_WAC_Change_Controller.updateWACLineItems(testWAC.Id, lineItemsList);
        Phoenix_WAC_Change_Controller.updateWACItems(testWAC.Id, lineItemsList);
           Phoenix_WAC_Change_Controller.getSearch('Test',testWAC.Id, lineItemsList);
       
        Phoenix_WAC_Change_Controller.getRelatedList(testWAC.Id);
         Phoenix_WAC_Change_Controller.getRelatedList1(testWAC.Id);
         String wacLineId = lineItemsList[0].Id;
    
        Phoenix_WAC_Change_Controller.getupdatedforExport(bid.Id);
       Phoenix_WAC_Change_Controller.getSubmitBidInfo(testWAC.Id);
          Phoenix_WAC_Change_Controller.submitToProceddStep1(bid.Id);
        Phoenix_WAC_Change_Controller.fetchSortResults('Phoenix_Cust_Number__c',true,lineItemsList);
        
        
         if (approvalGroups.size() == 0) {
            Phoenix_User_Approval_Matrix__c group1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Sales', Phoenix_Approval_Group_Behavior__c = 'Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Supply Chain', Phoenix_Approval_Group_Behavior__c = 'Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Marketing Head', Phoenix_Approval_Group_Behavior__c = 'Single User');
            approvalGroups.add(group3);
            
            Phoenix_User_Approval_Matrix__c group4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Finance', Phoenix_Approval_Group_Behavior__c = 'Team');
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
        
        
        
        
        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c = 'WAC Change');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;
        
        List < Phoenix_Approval_Process_Step__c > stepsList = new List < Phoenix_Approval_Process_Step__c > ();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for (Phoenix_Approval_Matrix__c matrix: bidMatrixList) {
            Phoenix_Approval_Process_Step__c rfpStep1 = new Phoenix_Approval_Process_Step__c(Name = 'Initial Submission', Phoenix_Order__c = 1, Phoenix_Is_Notification_Only__c = false, Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep1);
            Phoenix_Approval_Process_Step__c rfpStep2 = new Phoenix_Approval_Process_Step__c(Name = 'Marketing Head', Phoenix_Order__c = 2, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Marketing Head', Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep2);
           
            Phoenix_Approval_Process_Step__c rfpStep3 = new Phoenix_Approval_Process_Step__c(Name = 'Contracts', Phoenix_Order__c = 3, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Contracts', Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep3);
            Phoenix_Approval_Process_Step__c rfpStep4 = new Phoenix_Approval_Process_Step__c(Name = 'Customer\'s Update', Phoenix_Order__c = 4, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Contracts', Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep4);
            Phoenix_Approval_Process_Step__c rfpStep5 = new Phoenix_Approval_Process_Step__c(Name = 'Vistex Update', Phoenix_Order__c = 5, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Home Office', Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep5);
            
            Phoenix_Approval_Process_Step__c rfpStep6 = new Phoenix_Approval_Process_Step__c(Name = 'Closed', Phoenix_Order__c = 6, Phoenix_Is_Notification_Only__c = false, Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep6);
        }
        insert stepsList;
        list < Phoenix_Bid_Process_Steps__c > processList = new list < Phoenix_Bid_Process_Steps__c > ();
        Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c = stepsList[0].Id;
        system.debug('stepsList[0].Id---------------' + stepsList[0].Id);
        bStep.Name = testWAC.Name + '-' + 'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_WAC_Change__c = testWAC.Id;
        
        bStep.Phoenix_Status__c = 'Submitted';
        
        bStep.Phoenix_Sub_Step__c = 1;
        processList.add(bStep);
        Phoenix_Bid_Process_Steps__c bStep1 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep1.Name = testWAC.Name + '-' + 'Marketing Head Approval';
        bStep1.Phoenix_Approver__c = UserInfo.getUserId();
        bStep1.Phoenix_WAC_Change__c = testWAC.Id;
        bStep1.Phoenix_Process_Step__c = stepsList[1].Id;
        
        bStep1.Phoenix_Status__c = 'In Process';
        bStep1.Phoenix_Approver_Team__c = 'Marketing Head';
        
        bStep1.Phoenix_Sub_Step__c = 1;
        processList.add(bStep1);
       
        
        
        Phoenix_Bid_Process_Steps__c bStep4 = new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name = testWAC.Name + '-' + 'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_WAC_Change__c = testWAC.Id;
        bStep4.Phoenix_Process_Step__c = stepsList[2].Id;
        
        bStep4.Phoenix_Approver_Team__c = 'Contracts';
        
        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        Phoenix_Bid_Process_Steps__c bStep6 = new Phoenix_Bid_Process_Steps__c();
        bStep6.Phoenix_Is_Criteria_Step__c = false;
        bStep6.Name = testWAC.Name + '-' + 'Customer\'s Update';
        bStep6.Phoenix_Approver__c = UserInfo.getUserId();
        bStep6.Phoenix_WAC_Change__c = testWAC.Id;
        bStep6.Phoenix_Process_Step__c = stepsList[3].Id;
        
        bStep6.Phoenix_Status__c = 'In Process';
        bStep6.Phoenix_Approver_Team__c = 'Contracts';
        
        bStep6.Phoenix_Sub_Step__c = 1;
        processList.add(bStep6);
        Phoenix_Bid_Process_Steps__c bStep5 = new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name = testWAC.Name + '-' + 'Vistex Update';
        bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_WAC_Change__c = testWAC.Id;
        bStep5.Phoenix_Process_Step__c = stepsList[4].Id;
        
        bStep5.Phoenix_Status__c = 'In Process';
        bStep5.Phoenix_Approver_Team__c = 'Home Office';
        
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
        Phoenix_Bid_Process_Steps__c bStep7 = new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name = testWAC.Name + '-' + 'Closed';
        bStep7.Phoenix_Process_Step__c = stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_WAC_Change__c = testWAC.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
        insert processList;
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_WAC_Change__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_WAC_Change__c =: testWAC.Id];
        system.debug('---bidProcessStepList---' + bidProcessStepList.size());
        
        
     
        Phoenix_WAC_Change_Controller.makeApprovals(bid.Id,lineItemsList,true,true,false,false,false);
          Phoenix_WAC_Change_Controller.makeApprovals(bid.Id,lineItemsList,true,false,true,false,false);
          Phoenix_WAC_Change_Controller.makeApprovals(bid.Id,lineItemsList,true,false,false,true,false);
          Phoenix_WAC_Change_Controller.makeApprovals(bid.Id,lineItemsList,true,false,false,false,true);
        
         Phoenix_WAC_Change_Controller.updateNextProcesSteps(testWAC.Id,'testRecord',bidProcessStepList,false,true,false,false,false);
        Phoenix_WAC_Change_Controller.updateNextProcesSteps(testWAC.Id,'testRecord',bidProcessStepList,false,false,true,false,false);
         Phoenix_WAC_Change_Controller.updateNextProcesSteps(testWAC.Id,'testRecord',bidProcessStepList,false,false,false,true,true);
          Phoenix_WAC_Change_Controller.updateNextProcesSteps(testWAC.Id,'testRecord',bidProcessStepList,false,false,false,false,true);
        Phoenix_WAC_Change_Controller.updateNextProcesSteps(testWAC.Id,'testRecord',bidProcessStepList,true,false,false,false,true);
        
        list<Phoenix_WAC_Change_Line_Item__c>linelist=[select id, Phoenix_Final_Status__c from Phoenix_WAC_Change_Line_Item__c where Phoenix_WAC_Change__c =: testWAC.Id];
        for(Phoenix_WAC_Change_Line_Item__c ndc: linelist){
              ndc.Phoenix_Contracts_Approval__c='Not processed';
            ndc.Phoenix_Final_Status__c='Not Approved';
           
            
        }
         update linelist;
         Phoenix_WAC_Change_Controller.updateNextProcesSteps(testWAC.Id,'testRecord',bidProcessStepList,false,false,true,false,false);
          Phoenix_WAC_Change_Controller.updateNextProcesSteps(testWAC.Id,'testRecord',bidProcessStepList,false,true,false,false,false);
          Phoenix_WAC_Change_Controller.updateNextProcesSteps(testWAC.Id,'testRecord',bidProcessStepList,false,false,false,true,false);
        
        
        Phoenix_WAC_Change_Controller.deleteLineItems(lineItemsList[0].Id);
         Phoenix_WAC_Change_Controller.deleteWACLineItems(lineItemIds);
          
    }
}