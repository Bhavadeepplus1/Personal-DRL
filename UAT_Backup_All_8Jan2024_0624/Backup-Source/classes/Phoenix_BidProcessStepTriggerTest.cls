/**
 * @description       : 
 * @author            : Madhavi K (Dhruvsoft)
 * @group             : 
 * @last modified on  : 07-09-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 **/
@isTest
public class Phoenix_BidProcessStepTriggerTest {
    static testmethod void AddNDCProductMethod() {
        List < Phoenix_User_Approval_Matrix__c > approvalGroups = new List < Phoenix_User_Approval_Matrix__c > ();
        List < Phoenix_User_Approval_Matrix__c > approvalUsers = new List < Phoenix_User_Approval_Matrix__c > ();
        List < User > users = new List < User > ();
        List < Phoenix_Approval_Matrix__c > bidMatrixList = new List < Phoenix_Approval_Matrix__c > ();
        list < Product2 > prodList = new list < Product2 > ();
        list < string > selectedProducts = new list < string > ();
        String sortField = 'Name';
        Boolean isAsc = true;
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2', Phoenix_Rx_SRx_OTC__c = 'SRx', Phoenix_Special_Product__c = true, Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3', Phoenix_Rx_SRx_OTC__c = 'OTC', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE);

        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;

        selectedProducts.add(prod1.Id);
        selectedProducts.add(prod2.Id);
        selectedProducts.add(prod3.Id);
        selectedProducts.add(prod4.Id);

        Phoenix_NDC_Change__c testNDC = new Phoenix_NDC_Change__c();
        testNDC.Phoenix_Approval_Status__c = 'Draft';
        testNDC.Phoenix_NDC_Change_Name__c = 'testRecord';
        testNDC.Phoenix_Current_Product_Family__c = prodList[0].Family;
        testNDC.Phoenix_Proposed_Product_Family__c = prodList[1].Family;
        insert testNDC;

        Phoenix_NDC_Change__c testNDC1 = new Phoenix_NDC_Change__c();
        testNDC1.Phoenix_Approval_Status__c = 'Draft';
        testNDC1.Phoenix_NDC_Change_Name__c = 'testRecord';
        testNDC1.Phoenix_Current_Product_Family__c = prodList[0].Family;
        testNDC1.Phoenix_Proposed_Product_Family__c = prodList[1].Family;
        insert testNDC1;

        Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
        Cntrct.name = 'test contract';
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

        list < Phoenix_NDC_Change_Product__c > ndcProductList = new list < Phoenix_NDC_Change_Product__c > ();
        list < Phoenix_NDC_Change_Product__c > ndcProductList1 = new list < Phoenix_NDC_Change_Product__c > ();
        Phoenix_NDC_Change_Product__c ndcChangeProduct = new Phoenix_NDC_Change_Product__c();
        ndcChangeProduct.Phoenix_NDC_Change_Name__c = testNDC.Id;
        ndcChangeProduct.Phoenix_Current_Product__c = prod1.Id;
        ndcChangeProduct.Phoenix_Proposed_Product__c = prod2.Id;
        insert ndcChangeProduct;

        Phoenix_NDC_Change_Product__c ndcChangeProduct1 = new Phoenix_NDC_Change_Product__c();
        ndcChangeProduct1.Phoenix_NDC_Change_Name__c = testNDC1.Id;
        ndcChangeProduct1.Phoenix_Current_Product__c = prod1.Id;
        ndcChangeProduct1.Phoenix_Proposed_Product__c = prod2.Id;
        insert ndcChangeProduct1;

        list < Phoenix_NDC_Change_Line_Item__c > lineItemsList = new list < Phoenix_NDC_Change_Line_Item__c > ();
        list < Phoenix_NDC_Change_Line_Item__c > lineItemsList1 = new list < Phoenix_NDC_Change_Line_Item__c > ();
        Phoenix_NDC_Change_Line_Item__c pbl1 = new Phoenix_NDC_Change_Line_Item__c();
        pbl1.Phoenix_NDC_Change__c = testNDC.Id;
        pbl1.Phoenix_NDC_Change_Product__c = ndcChangeProduct.Id;
        pbl1.Phoenix_Current_Product__c = prod1.id;
        pbl1.Phoenix_Proposed_Product__c = prod2.id;

        Phoenix_NDC_Change_Line_Item__c pbl11 = new Phoenix_NDC_Change_Line_Item__c();
        pbl11.Phoenix_NDC_Change__c = testNDC1.Id;
        pbl11.Phoenix_NDC_Change_Product__c = ndcChangeProduct1.Id;
        pbl11.Phoenix_Current_Product__c = prod1.id;
        pbl11.Phoenix_Proposed_Product__c = prod2.id;
        pbl11.Phoenix_Final_Status__c = 'Not Approved';
        lineItemsList1.add(pbl11);
        lineItemsList.add(pbl1);
        Phoenix_NDC_Change_Line_Item__c pbl2 = new Phoenix_NDC_Change_Line_Item__c();
        pbl2.Phoenix_NDC_Change__c = testNDC.Id;
        pbl2.Phoenix_NDC_Change_Product__c = ndcChangeProduct.Id;
        pbl2.Phoenix_Current_Product__c = prod1.id;
        pbl2.Phoenix_Proposed_Product__c = prod2.id;
        lineItemsList.add(pbl2);

        Phoenix_NDC_Change_Line_Item__c pbl21 = new Phoenix_NDC_Change_Line_Item__c();
        pbl21.Phoenix_NDC_Change__c = testNDC1.Id;
        pbl21.Phoenix_NDC_Change_Product__c = ndcChangeProduct1.Id;
        pbl21.Phoenix_Current_Product__c = prod1.id;
        pbl21.Phoenix_Proposed_Product__c = prod2.id;
        pbl21.Phoenix_Final_Status__c = 'Not Approved';
        lineItemsList1.add(pbl21);

        insert lineItemsList;
        insert lineItemsList1;

        list < string > lineItemIds = new list < string > ();
        lineItemIds.add(pbl2.Id);
        Phoenix_NDCChangeEditor.getActiveBidProductFamilies();
        Phoenix_NDCChangeEditor.getProductsInfo(prodList[0].Family, prodList[1].Family);
        Phoenix_NDCChangeEditor.getProducts(selectedProducts, prodList[1].Family);
        Phoenix_NDCChangeEditor.getProposedProductInfo(prodList[1].Id);
        Phoenix_NDCChangeEditor.getNDCChangeInfo(testNDC.Id);
        Phoenix_NDCChangeEditor.getNDCLineItems(testNDC.Id);
        Phoenix_NDCChangeEditor.saveNDCChangeLineItems(lineItemsList);
        Phoenix_NDCChangeEditor.updateNDCChangeLineItems(lineItemsList, testNDC.Id);
        Phoenix_NDCChangeEditor.saveNDCChangeProducts(ndcProductList);
        Phoenix_NDCChangeEditor.getNDCChangeProductInfo(ndcChangeProduct.Id);
        Phoenix_NDCChangeEditor.getNPRData(new list < string > {
            prod1.Id
        }, new list < string > {
            nprdat.Id
        });
        Phoenix_NDCChangeEditor.fetchSortResults(sortField, isAsc, lineItemsList);
        Phoenix_NDCChangeEditor.getSearch('Test Product', testNDC.Id, lineItemsList);




        Phoenix_NDCChangeEditor.getupdatedforExport(testNDC.Id);
        Phoenix_NDCChangeEditor.getRelatedList(testNDC.Id);

        if (approvalGroups.size() == 0) {
            Phoenix_User_Approval_Matrix__c group1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Sales', Phoenix_Approval_Group_Behavior__c = 'Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Supply Chain', Phoenix_Approval_Group_Behavior__c = 'Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Marketing', Phoenix_Approval_Group_Behavior__c = 'Product based');
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




        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c = 'NDC Change');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;

        List < Phoenix_Approval_Process_Step__c > stepsList = new List < Phoenix_Approval_Process_Step__c > ();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for (Phoenix_Approval_Matrix__c matrix: bidMatrixList) {
            Phoenix_Approval_Process_Step__c rfpStep1 = new Phoenix_Approval_Process_Step__c(Name = 'Initial Submission', Phoenix_Order__c = 1, Phoenix_Is_Notification_Only__c = false, Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep1);
            Phoenix_Approval_Process_Step__c rfpStep3 = new Phoenix_Approval_Process_Step__c(Name = 'Supply Chain', Phoenix_Order__c = 2, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Supply Chain', Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep3);
            //Phoenix_Approval_Process_Step__c rfpStep2 = new Phoenix_Approval_Process_Step__c(Name = 'Marketing', Phoenix_Order__c = 3, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Marketing', Phoenix_Approval_Matrix__c = matrix.Id, Phoenix_Approver__c = UserInfo.getUserId());
            //stepsList.add(rfpStep2);



            Phoenix_Approval_Process_Step__c rfpStep5 = new Phoenix_Approval_Process_Step__c(Name = 'Finance', Phoenix_Order__c = 3, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Finance', Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep5);
            Phoenix_Approval_Process_Step__c rfpStep6 = new Phoenix_Approval_Process_Step__c(Name = 'Contracts', Phoenix_Order__c = 4, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Contracts', Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep6);
            Phoenix_Approval_Process_Step__c rfpStep8 = new Phoenix_Approval_Process_Step__c(Name = 'Customer\'s Update', Phoenix_Order__c = 5, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Contracts', Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep8);
            Phoenix_Approval_Process_Step__c rfpStep7 = new Phoenix_Approval_Process_Step__c(Name = 'Vistex Update', Phoenix_Order__c = 6, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Home Office', Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep7);

            Phoenix_Approval_Process_Step__c rfpStep9 = new Phoenix_Approval_Process_Step__c(Name = 'Closed', Phoenix_Order__c = 7, Phoenix_Is_Notification_Only__c = false, Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep9);
        }
        insert stepsList;
        list < Phoenix_Bid_Process_Steps__c > processList = new list < Phoenix_Bid_Process_Steps__c > ();
        list < Phoenix_Bid_Process_Steps__c > processList1 = new list < Phoenix_Bid_Process_Steps__c > ();
        Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c = stepsList[0].Id;
        system.debug('stepsList[0].Id---------------' + stepsList[0].Id);
        bStep.Name = testNDC.Name + '-' + 'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_NDC_Change__c = testNDC.Id;

        bStep.Phoenix_Status__c = 'Submitted';

        bStep.Phoenix_Sub_Step__c = 1;
        processList.add(bStep);

        Phoenix_Bid_Process_Steps__c bStep11 = new Phoenix_Bid_Process_Steps__c();
        bStep11.Phoenix_Is_Criteria_Step__c = false;
        bStep11.Phoenix_Process_Step__c = stepsList[0].Id;
        system.debug('stepsList[0].Id---------------' + stepsList[0].Id);
        bStep11.Name = testNDC.Name + '-' + 'Intial Submission';
        bStep11.Phoenix_Approver__c = UserInfo.getUserId();
        bStep11.Phoenix_NDC_Change__c = testNDC1.Id;

        bStep11.Phoenix_Status__c = 'Submitted';

        bStep11.Phoenix_Sub_Step__c = 1;
        processList1.add(bStep11);


        Phoenix_Bid_Process_Steps__c bStep1 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep1.Name = testNDC.Name + '-' + 'Supply Chain Approval';
        bStep1.Phoenix_Approver__c = UserInfo.getUserId();
        bStep1.Phoenix_NDC_Change__c = testNDC.Id;
        bStep1.Phoenix_Process_Step__c = stepsList[1].Id;

        bStep1.Phoenix_Status__c = 'In Process';
        bStep1.Phoenix_Approver_Team__c = 'Supply Chain';

        bStep1.Phoenix_Sub_Step__c = 1;
        processList.add(bStep1);
        /*Phoenix_Bid_Process_Steps__c bStep2 = new Phoenix_Bid_Process_Steps__c();
bStep2.Phoenix_Is_Criteria_Step__c = false;
bStep2.Name = testNDC.Name + '-' + 'Marketing Approval';
bStep2.Phoenix_NDC_Change__c = UserInfo.getUserId();
bStep2.Phoenix_NDC_Change__c = testNDC.Id;
bStep2.Phoenix_Process_Step__c = stepsList[2].Id;

bStep2.Phoenix_Approver_Team__c = 'Marketing';

bStep2.Phoenix_Sub_Step__c = 1;
processList.add(bStep2);*/
        Phoenix_Bid_Process_Steps__c bStep12 = new Phoenix_Bid_Process_Steps__c();
        bStep12.Phoenix_Is_Criteria_Step__c = false;
        bStep12.Name = testNDC.Name + '-' + 'Supply Chain Approval';
        bStep12.Phoenix_Approver__c = UserInfo.getUserId();
        bStep12.Phoenix_NDC_Change__c = testNDC1.Id;
        bStep12.Phoenix_Process_Step__c = stepsList[1].Id;

        bStep12.Phoenix_Status__c = 'In Process';
        bStep12.Phoenix_Approver_Team__c = 'Supply Chain';

        bStep12.Phoenix_Sub_Step__c = 1;
        processList1.add(bStep12);


        Phoenix_Bid_Process_Steps__c bStep3 = new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name = testNDC.Name + '-' + 'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_NDC_Change__c = testNDC.Id;
        bStep3.Phoenix_Process_Step__c = stepsList[2].Id;

        bStep3.Phoenix_Approver_Team__c = 'Finance';

        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);

        Phoenix_Bid_Process_Steps__c bStep31 = new Phoenix_Bid_Process_Steps__c();
        bStep31.Phoenix_Is_Criteria_Step__c = false;
        bStep31.Name = testNDC.Name + '-' + 'Finance Approval';
        bStep31.Phoenix_Approver__c = UserInfo.getUserId();
        bStep31.Phoenix_NDC_Change__c = testNDC1.Id;
        bStep31.Phoenix_Process_Step__c = stepsList[2].Id;

        bStep31.Phoenix_Approver_Team__c = 'Finance';

        bStep31.Phoenix_Sub_Step__c = 1;
        processList1.add(bStep31);

        Phoenix_Bid_Process_Steps__c bStep4 = new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name = testNDC.Name + '-' + 'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_NDC_Change__c = testNDC.Id;
        bStep4.Phoenix_Process_Step__c = stepsList[3].Id;

        bStep4.Phoenix_Approver_Team__c = 'Contracts';

        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        Phoenix_Bid_Process_Steps__c bStep6 = new Phoenix_Bid_Process_Steps__c();
        bStep6.Phoenix_Is_Criteria_Step__c = false;
        bStep6.Name = testNDC.Name + '-' + 'Customer\'s Update';
        bStep6.Phoenix_Approver__c = UserInfo.getUserId();
        bStep6.Phoenix_NDC_Change__c = testNDC.Id;
        bStep6.Phoenix_Process_Step__c = stepsList[4].Id;

        bStep6.Phoenix_Status__c = 'In Process';
        bStep6.Phoenix_Approver_Team__c = 'Contracts';

        bStep6.Phoenix_Sub_Step__c = 1;
        processList.add(bStep6);
        Phoenix_Bid_Process_Steps__c bStep5 = new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name = testNDC.Name + '-' + 'Vistex Update';
        bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_NDC_Change__c = testNDC.Id;
        bStep5.Phoenix_Process_Step__c = stepsList[5].Id;

        bStep5.Phoenix_Status__c = 'In Process';
        bStep5.Phoenix_Approver_Team__c = 'Home Office';

        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);

        Phoenix_Bid_Process_Steps__c bStep7 = new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name = testNDC.Name + '-' + 'Closed';
        bStep7.Phoenix_Process_Step__c = stepsList[6].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_NDC_Change__c = testNDC.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
        
        Phoenix_Bid_Process_Steps__c bStep8 = new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name = testNDC.Name + '-' + 'Closed';
        bStep7.Phoenix_Process_Step__c = stepsList[6].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_NDC_Change__c = testNDC.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep8);
        insert processList;
        insert processList1;
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_NDC_Change__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_NDC_Change__c =: testNDC.Id];
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList1 = [SELECT Id, Name, Phoenix_NDC_Change__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_NDC_Change__c =: testNDC1.Id];
        system.debug('---bidProcessStepList---' + bidProcessStepList.size());
        system.debug('---bidProcessStepList---' + bidProcessStepList1.size());
        Phoenix_NDCChangeEditor.getApprovals(testNDC.Id);
        Phoenix_NDCChangeEditor.submitToProceddStep1(testNDC.Id);



        Phoenix_NDCChangeEditor.makeApprovals(testNDC.Id, lineItemsList, true, true, false, false, false, false);
        Phoenix_NDCChangeEditor.makeApprovals(testNDC.Id, lineItemsList, true, false, true, false, false, false);
        Phoenix_NDCChangeEditor.makeApprovals(testNDC.Id, lineItemsList, true, false, false, true, false, false);
        Phoenix_NDCChangeEditor.makeApprovals(testNDC.Id, lineItemsList, true, false, false, false, true, false);
        Phoenix_NDCChangeEditor.makeApprovals(testNDC.Id, lineItemsList, true, false, false, false, false, true);
        Phoenix_NDCChangeEditor.updateNextProcesSteps(testNDC.Id, 'testRecord', bidProcessStepList, false, false, false, false, false, true);
        Phoenix_NDCChangeEditor.updateNextProcesSteps(testNDC.Id, 'testRecord', bidProcessStepList, true, false, false, false, false, true);
        Phoenix_NDCChangeEditor.updateNextProcesSteps(testNDC1.Id, 'testRecord', bidProcessStepList1, true, false, false, false, false, true);
        Phoenix_NDCChangeEditor.updateNextProcesSteps(testNDC1.Id, 'testRecord', bidProcessStepList1, true, true, true, true, false, true);

        list < Phoenix_NDC_Change_Line_Item__c > linelist = [select id, Phoenix_Final_Status__c from Phoenix_NDC_Change_Line_Item__c where Phoenix_NDC_Change__c =: testNDC.Id];
        for (Phoenix_NDC_Change_Line_Item__c ndc: linelist) {
            ndc.Phoenix_Contracts_Approval__c = 'No';
            ndc.Phoenix_Final_Status__c = 'Not Approved';


        }
        //update linelist;
        Phoenix_NDCChangeEditor.updateNextProcesSteps(testNDC.Id, 'testRecord', bidProcessStepList, false, true, false, false, false, false);



        pbl1.Phoenix_Contracts_Approval__c = 'Yes';
        pbl1.Phoenix_Final_Finance_Approval__c = true;
        pbl1.Phoenix_Contracts_Final_Approval__c = false;
        pbl2.Phoenix_Contracts_Approval__c = 'Yes';
        pbl2.Phoenix_Final_Finance_Approval__c = true;
        pbl2.Phoenix_Contracts_Final_Approval__c = false;
        list < Phoenix_NDC_Change_Line_Item__c > linelist1 = new list < Phoenix_NDC_Change_Line_Item__c > ();
        linelist1.add(pbl1);
        linelist1.add(pbl2);
        update linelist1;
        Phoenix_NDCChangeEditor.makeContractsApprovals(testNDC.Id, lineItemsList, true);
        pbl1.Phoenix_Contracts_Approval__c = 'No';
        pbl1.Phoenix_Final_Finance_Approval__c = true;
        pbl1.Phoenix_Contracts_Final_Approval__c = false;
        update pbl1;

        Phoenix_NDCChangeEditor.makeContractsApprovals(testNDC.Id, lineItemsList, true);
        pbl1.Pheonix_Customer_Approval__c = 'Approved';
        pbl1.Phoenix_Customer_Final_Approval__c = false;
        pbl1.Phoenix_Contracts_Final_Approval__c = true;

        pbl2.Pheonix_Customer_Approval__c = 'Not Approved';
        pbl2.Phoenix_Customer_Final_Approval__c = false;
        pbl2.Phoenix_Contracts_Final_Approval__c = true;
        list < Phoenix_NDC_Change_Line_Item__c > linelist2 = new list < Phoenix_NDC_Change_Line_Item__c > ();
        linelist2.add(pbl1);
        linelist2.add(pbl2);
        update linelist2;
        Phoenix_NDCChangeEditor.makeContractsApprovals(testNDC.Id, lineItemsList, true);
        pbl1.Phoenix_Vistex_Approval__c = 'Updated';
        pbl1.Phoenix_Customer_Final_Approval__c = true;
        pbl1.Phoenix_Vistex_Final_Approval__c = false;
        update pbl1;
        Phoenix_NDCChangeEditor.makeContractsApprovals(testNDC.Id, lineItemsList, true);
        pbl1.Phoenix_Vistex_Approval__c = 'Pending';
        pbl1.Phoenix_Customer_Final_Approval__c = true;
        pbl1.Phoenix_Vistex_Final_Approval__c = false;
        update pbl1;
        Phoenix_NDCChangeEditor.makeContractsApprovals(testNDC.Id, lineItemsList, true);
        pbl1.Pheonix_Customer_Approval__c = 'Not Required';
        pbl2.Pheonix_Customer_Approval__c = 'Not Required';
        list < Phoenix_NDC_Change_Line_Item__c > linelist3 = new list < Phoenix_NDC_Change_Line_Item__c > ();
        linelist3.add(pbl1);
        linelist3.add(pbl2);
        update linelist3;

        Phoenix_NDCChangeEditor.updateNDCChangeLineItems(lineItemsList, testNDC.Id);

        Phoenix_NDCChangeEditor.getLineItemIdsToDelete(ndcChangeProduct.Id);
        Phoenix_NDCChangeEditor.deleteNDCProduct(ndcChangeProduct.Id);
        Phoenix_NDCChangeEditor.deleteLineItems(pbl1.Id);
        Phoenix_NDCChangeEditor.deleteNDCLineItems(lineItemIds);

    }
    static testmethod void Phoenix_RCAWholesalerEditLineClsMethod() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
        list < Phoenix_RCA_IPA_LINE__c > lineItemsList = new list < Phoenix_RCA_IPA_LINE__c > ();
        for (Integer i = 0; i < 4; i++) {
            Phoenix_RCA_IPA_LINE__c pbl = new Phoenix_RCA_IPA_LINE__c(Phoenix_Bid__c = pb.Id);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        Phoenix_RCAWholesalerEditLineCls.getRelatedList(pb.Id);
        Phoenix_RCAWholesalerEditLineCls.deleteLineItems(lineItemsList[0].Id);
        list < Phoenix_RCA_IPA_LINE__c > lineItemsList1 = [select Id, Phoenix_New_GPO__c, Phoenix_Wholesaler__c, Phoenix_Wholesaler_Location__c from Phoenix_RCA_IPA_LINE__c where Phoenix_Bid__c =: pb.Id];
        Phoenix_RCAWholesalerEditLineCls.saveLineItems(lineItemsList1);
        Phoenix_RCAWholesalerEditLineCls.getDependentPicklist();
        Phoenix_RCAWholesalerEditLineCls.saveTobid(pb.Id, 'Comments', 'Processed');
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        testData.generateApprovalMatrix();
        //Phoenix_SubmitBidForApprovalCtrl.createBidApprovalItems(new List<Phoenix_Bid__c>{pb});
        Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Name = pb.Name + '-' + 'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep.Phoenix_Status__c = 'Submitted';
        bStep.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep.Phoenix_Sub_Step__c = 1;
        insert bStep;
        Phoenix_Bid_Process_Steps__c bStep1 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep1.Name = pb.Name + '-' + 'Contracts';
        bStep1.Phoenix_Approver__c = UserInfo.getUserId();
        bStep1.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep1.Phoenix_Status__c = 'In Process';
        bStep1.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep1.Phoenix_Sub_Step__c = 1;
        insert bStep1;
        Phoenix_Bid_Process_Steps__c bStep2 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name = pb.Name + '-' + 'Closed';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        //bStep2.Phoenix_Status__c =  '';
        bStep2.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep2.Phoenix_Sub_Step__c = 1;
        insert bStep2;
       // Phoenix_RCAWholesalerEditLineCls.makeApprovalsIPAContracts(pb.Id, 'Comments', 'Processed');
        //Phoenix_RCAWholesalerEditLineCls.makeApprovalsIPAContracts(pb.Id,'Comments','Not Processed');
    }
    static testmethod void Phoenix_EditRCALinesClsMethod() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
        list < Phoenix_RCA_IPA_LINE__c > lineItemsList = new list < Phoenix_RCA_IPA_LINE__c > ();
        for (Integer i = 0; i < 4; i++) {
            Phoenix_RCA_IPA_LINE__c pbl = new Phoenix_RCA_IPA_LINE__c(Phoenix_Bid__c = pb.Id);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        Phoenix_EditRCALinesCls.getRelatedList(pb.Id);
        Phoenix_EditRCALinesCls.deleteLineItems(lineItemsList[0].Id);
        list < Phoenix_RCA_IPA_LINE__c > lineItemsList1 = [select Id, Phoenix_New_GPO__c, Phoenix_Wholesaler__c, Phoenix_Wholesaler_Location__c from Phoenix_RCA_IPA_LINE__c where Phoenix_Bid__c =: pb.Id];
        Phoenix_EditRCALinesCls.saveLineItems(lineItemsList1);
        Phoenix_EditRCALinesCls.getDependentPicklist();
        Phoenix_EditRCALinesCls.saveTobid(pb.Id, 'Comments', 'Processed');
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        testData.generateApprovalMatrix();
        //Phoenix_SubmitBidForApprovalCtrl.createBidApprovalItems(new List<Phoenix_Bid__c>{pb});
        Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Name = pb.Name + '-' + 'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep.Phoenix_Status__c = 'Submitted';
        bStep.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep.Phoenix_Sub_Step__c = 1;
        insert bStep;
        Phoenix_Bid_Process_Steps__c bStep1 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep1.Name = pb.Name + '-' + 'Contracts';
        bStep1.Phoenix_Approver__c = UserInfo.getUserId();
        bStep1.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep1.Phoenix_Status__c = 'In Process';
        bStep1.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep1.Phoenix_Sub_Step__c = 2;
        insert bStep1;
        Phoenix_Bid_Process_Steps__c bStep2 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name = pb.Name + '-' + 'Closed';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        //bStep2.Phoenix_Status__c =  '';
        bStep2.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep2.Phoenix_Sub_Step__c = 3;
        insert bStep2;
     //   Phoenix_EditRCALinesCls.makeApprovalsIPAContracts(pb.Id, 'Comments', 'Processed');
        //Phoenix_EditRCALinesCls.makeApprovalsIPAContracts(pb.Id,'Comments','Not Processed');
    }
    static testmethod void Phoenix_EditIPALinesClsMethod() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Contracts_Approver__c = UserInfo.getUserId());
        insert testAccount;

        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
        list < Phoenix_RCA_IPA_LINE__c > lineItemsList = new list < Phoenix_RCA_IPA_LINE__c > ();
        for (Integer i = 0; i < 4; i++) {
            Phoenix_RCA_IPA_LINE__c pbl = new Phoenix_RCA_IPA_LINE__c(Phoenix_Bid__c = pb.Id, Phoenix_Contract_Status__c = 'Sent to Customer');
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        Phoenix_EditIPALinesCls.getRelatedList(pb.Id);
        Phoenix_EditIPALinesCls.deleteLineItems(lineItemsList[0].Id);
        list < Phoenix_RCA_IPA_LINE__c > lineItemsList1 = [select Id, Phoenix_New_GPO__c, Phoenix_Wholesaler__c, Phoenix_Wholesaler_Location__c, Phoenix_Contract_Status__c from Phoenix_RCA_IPA_LINE__c where Phoenix_Bid__c =: pb.Id];
        Phoenix_EditIPALinesCls.saveLineItems(lineItemsList1);
        Phoenix_EditIPALinesCls.getDependentPicklist();
        Phoenix_EditIPALinesCls.submitToProceddStep1(pb.Id);
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        testData.generateApprovalMatrix();
        //Phoenix_SubmitBidForApprovalCtrl.createBidApprovalItems(new List<Phoenix_Bid__c>{pb});
        list < Phoenix_Bid_Process_Steps__c > processList = new list < Phoenix_Bid_Process_Steps__c > ();
        Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Name = pb.Name + '-' + 'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep.Phoenix_Status__c = 'Submitted';
        bStep.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep.Phoenix_Sub_Step__c = 1;
        insert bStep;
        Phoenix_Bid_Process_Steps__c bStep1 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep1.Name = pb.Name + '-' + 'Contracts';
        bStep1.Phoenix_Approver__c = UserInfo.getUserId();
        bStep1.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep1.Phoenix_Status__c = 'In Process';
        bStep1.Phoenix_Approver_Team__c = 'Contracts';
        //stepNo : Ask and increment as per requirements
        bStep1.Phoenix_Sub_Step__c = 1;
        insert bStep1;
        Phoenix_Bid_Process_Steps__c bStep2 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name = pb.Name + '-' + 'Home Office';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        //bStep2.Phoenix_Status__c =  '';
        bStep2.Phoenix_Approver_Team__c = 'Home Office';
        //stepNo : Ask and increment as per requirements
        bStep2.Phoenix_Sub_Step__c = 1;
        insert bStep2;
        processList.add(bStep);
        processList.add(bStep1);
        processList.add(bStep2);
        Phoenix_EditIPALinesCls.makeApprovalsContracts(pb.Id, lineItemsList1, true);
        Phoenix_EditIPALinesCls.updateNextContractsProcessSteps(pb.Id, pb.Name, processList, true);
    }
    static testmethod void Phoenix_EditIPAMemberLineClsMethod() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
        list < Phoenix_RCA_IPA_LINE__c > lineItemsList = new list < Phoenix_RCA_IPA_LINE__c > ();
        for (Integer i = 0; i < 4; i++) {
            Phoenix_RCA_IPA_LINE__c pbl = new Phoenix_RCA_IPA_LINE__c(Phoenix_Bid__c = pb.Id);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        Phoenix_EditIPAMemberLineCls.getRelatedList(pb.Id);
        Phoenix_EditIPAMemberLineCls.deleteLineItems(lineItemsList[0].Id);
        list < Phoenix_RCA_IPA_LINE__c > lineItemsList1 = [select Id, Phoenix_New_GPO__c, Phoenix_Wholesaler__c, Phoenix_Wholesaler_Location__c from Phoenix_RCA_IPA_LINE__c where Phoenix_Bid__c =: pb.Id];
        Phoenix_EditIPAMemberLineCls.saveLineItems(lineItemsList1);
        Phoenix_EditIPAMemberLineCls.getDependentPicklist();
        Phoenix_EditIPAMemberLineCls.saveTobid(pb.Id, 'Comments', 'Processed');
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        testData.generateApprovalMatrix();
        //Phoenix_SubmitBidForApprovalCtrl.createBidApprovalItems(new List<Phoenix_Bid__c>{pb});
        Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Name = pb.Name + '-' + 'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep.Phoenix_Status__c = 'Submitted';
        bStep.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep.Phoenix_Sub_Step__c = 1;
        insert bStep;
        Phoenix_Bid_Process_Steps__c bStep1 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep1.Name = pb.Name + '-' + 'Contracts';
        bStep1.Phoenix_Approver__c = UserInfo.getUserId();
        bStep1.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep1.Phoenix_Status__c = 'In Process';
        bStep1.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep1.Phoenix_Sub_Step__c = 2;
        insert bStep1;
        Phoenix_Bid_Process_Steps__c bStep2 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name = pb.Name + '-' + 'Closed';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        //bStep2.Phoenix_Status__c =  '';
        bStep2.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep2.Phoenix_Sub_Step__c = 3;
        insert bStep2;
   //     Phoenix_EditIPAMemberLineCls.makeApprovalsIPAContracts(pb.Id, 'Comments', 'Processed');
        //Phoenix_EditIPAMemberLineCls.makeApprovalsIPAContracts(pb.Id,'Comments','Not Processed');
    }
    static testmethod void testFinanceView() {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Approval_Status__c = 'Draft';
        insert pb;
        Product2 p2 = new Product2();
        p2.Family = 'Allopurinol';
        p2.Name = 'Test';
        insert p2;
        Phoenix_Approval_Delegation_History__c PDH = new Phoenix_Approval_Delegation_History__c();
        PDH.Phoenix_Delegation_Start_Time__c = system.now();
        PDH.Phoenix_Delegation_End_Time__c = system.now() + 1;
        PDH.Phoenix_Delegated_Approver__c = UserInfo.getUserId();
        PDH.Phoenix_Is_Active_delegator__c = true;
        insert PDH;

        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = p2.Id;
        bl.Phoenix_Throughput_Cost1__c = 100;
        bl.Phoenix_WAC1__c = 120;
        bl.Phoenix_Budgeted_ASP1__c = 120;
        bl.Phoenix_Product_Family1__c = 'Allopurinol';
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 1000;
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 1550;
        Map < String, String > financeApprovalMap = new Map < String, String > ();
        Map < String, String > financeCommentMap = new Map < String, String > ();
        financeApprovalMap.put('Daptomycin Inj 500mg US', 'Approved');
        financeCommentMap.put('Daptomycin Inj 500mg US', 'test');
        insert bl;
        Phoenix_Approval_Delegation_History__c deleHistory = new Phoenix_Approval_Delegation_History__c();
        deleHistory.Phoenix_Delegation_Start_Time__c = system.now();
        deleHistory.Phoenix_Delegation_End_Time__c = datetime.newInstance(2023, 9, 15, 12, 30, 0);
        deleHistory.Phoenix_Delegated_Approver__c = userInfo.getUserId();
        deleHistory.Phoenix_Is_Active_delegator__c = True;
        insert deleHistory;
        Phoenix_FinanceViewCls.getProductFamlilyRollups(pb.id);
        Phoenix_FinanceViewCls.updateLineItems(pb.id, financeApprovalMap, financeCommentMap, 'Approved', true);
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        //testData.generateBids();
        Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
        wrap.bid = pb;

        testData.generateApprovalMatrix();

        System.runAs(testData.users[0]) {
            Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
            Phoenix_FinanceViewCls.makeApprovals(wrap.bid.id);
        }
    }

    static testmethod void Phoenix_EditIPABidMainPageClsMethod() {
        List < Phoenix_User_Approval_Matrix__c > approvalGroups = new List < Phoenix_User_Approval_Matrix__c > ();
        List < Phoenix_User_Approval_Matrix__c > approvalUsers = new List < Phoenix_User_Approval_Matrix__c > ();
        List < User > users = new List < User > ();

        List < Phoenix_Bid__c > bidItemList = new List < Phoenix_Bid__c > ();
        List < Product2 > productList = new List < Product2 > ();
        List < Phoenix_Approval_Matrix__c > bidMatrixList = new List < Phoenix_Approval_Matrix__c > ();
        List < Phoenix_Bid__c > bidsList = new List < Phoenix_Bid__c > ();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list < Product2 > prodList = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2', Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3', Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE);

        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Contracts_Approval__c = 'Processed';
        pb.Phoenix_Contracts_Approval_Comments__c = 'Comments';
        insert pb;
        list < Phoenix_Bid_Line_Item__c > lineItemsList = new list < Phoenix_Bid_Line_Item__c > ();
        for (Integer i = 0; i < prodList.size(); i++) {
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Vistex_Status__c = 'Updated', Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved', Phoenix_Contract_Approval__c = 'Sent to Customer', Phoenix_Marketing_Approval__c = 'Approved', Phoenix_Bid__c = pb.Id, Phoenix_Product_Director1__c = UserInfo.getUserId(), Phoenix_Product__c = prodList[i].Id, Phoenix_Proposed_IPA_Price__c = 100, Phoenix_IDN_Usage__c = 10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;

        if (approvalGroups.size() == 0) {
            Phoenix_User_Approval_Matrix__c group1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Sales', Phoenix_Approval_Group_Behavior__c = 'Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Supply Chain', Phoenix_Approval_Group_Behavior__c = 'Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Marketing', Phoenix_Approval_Group_Behavior__c = 'Product based');
            approvalGroups.add(group3);

            Phoenix_User_Approval_Matrix__c group4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Finance', Phoenix_Approval_Group_Behavior__c = 'Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Contracts', Phoenix_Approval_Group_Behavior__c = 'Account based');
            approvalGroups.add(group5);
            Phoenix_User_Approval_Matrix__c group6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'SRx IPA Contracts Approver', Phoenix_Approval_Group_Behavior__c = 'Single User');
            approvalGroups.add(group6);

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
            Phoenix_User_Approval_Matrix__c userApp7 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(), Phoenix_Is_Approval_Process_User__c = true, Phoenix_Approver__c = UserInfo.getUserId(), User_Group__c = approvalGroups[5].Id);
            approvalUsers.add(userApp7);

            insert approvalUsers;
        }




        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c = 'NEW Individual Pricing Agreement (IPA)');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;

        List < Phoenix_Approval_Process_Step__c > stepsList = new List < Phoenix_Approval_Process_Step__c > ();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for (Phoenix_Approval_Matrix__c matrix: bidMatrixList) {
            Phoenix_Approval_Process_Step__c rfpStep1 = new Phoenix_Approval_Process_Step__c(Name = 'Initial Submission', Phoenix_Order__c = 1, Phoenix_Is_Notification_Only__c = false, Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep1);
            //Phoenix_Approval_Process_Step__c rfpStep3 = new  Phoenix_Approval_Process_Step__c(Name='Supply Chain',Phoenix_Order__c = 2,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Supply Chain',Phoenix_Approval_Matrix__c=matrix.Id);
            // stepsList.add(rfpStep3);
            Phoenix_Approval_Process_Step__c rfpStep2 = new Phoenix_Approval_Process_Step__c(Name = 'Marketing', Phoenix_Order__c = 2, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Marketing', Phoenix_Approval_Matrix__c = matrix.Id, Phoenix_Approver__c = UserInfo.getUserId());
            stepsList.add(rfpStep2);



            Phoenix_Approval_Process_Step__c rfpStep5 = new Phoenix_Approval_Process_Step__c(Name = 'Finance', Phoenix_Order__c = 3, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Finance', Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep5);
            Phoenix_Approval_Process_Step__c rfpStep6 = new Phoenix_Approval_Process_Step__c(Name = 'Contracts', Phoenix_Order__c = 4, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'SRx IPA Contracts Approver', Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep6);
            Phoenix_Approval_Process_Step__c rfpStep7 = new Phoenix_Approval_Process_Step__c(Name = 'Vistex Update', Phoenix_Order__c = 5, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Home Office', Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep7);
            //Phoenix_Approval_Process_Step__c rfpStep8 = new  Phoenix_Approval_Process_Step__c(Name='Customer Service',Phoenix_Order__c = 7,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Customer Service',Phoenix_Approval_Matrix__c=matrix.Id);
            // stepsList.add(rfpStep8);
            Phoenix_Approval_Process_Step__c rfpStep9 = new Phoenix_Approval_Process_Step__c(Name = 'Closed', Phoenix_Order__c = 6, Phoenix_Is_Notification_Only__c = false, Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep9);
        }
        insert stepsList;
        list < Phoenix_Bid_Process_Steps__c > processList = new list < Phoenix_Bid_Process_Steps__c > ();
        Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c = stepsList[0].Id;
        system.debug('stepsList[0].Id---------------' + stepsList[0].Id);
        bStep.Name = pb.Name + '-' + 'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;

        bStep.Phoenix_Status__c = 'Submitted';

        bStep.Phoenix_Sub_Step__c = 1;
        processList.add(bStep);

        Phoenix_Bid_Process_Steps__c bStep2 = new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name = pb.Name + '-' + 'Marketing Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        bStep2.Phoenix_Process_Step__c = stepsList[1].Id;

        bStep2.Phoenix_Approver_Team__c = 'Marketing';

        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
        Phoenix_Bid_Process_Steps__c bStep3 = new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name = pb.Name + '-' + 'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb.Id;
        bStep3.Phoenix_Process_Step__c = stepsList[2].Id;

        bStep3.Phoenix_Approver_Team__c = 'Finance';

        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        Phoenix_Bid_Process_Steps__c bStep4 = new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name = pb.Name + '-' + 'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb.Id;
        bStep4.Phoenix_Process_Step__c = stepsList[3].Id;
        bStep4.Phoenix_Status__c = 'In Process';
        bStep4.Phoenix_Approver_Team__c = 'SRx IPA Contracts Approver';

        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);

        Phoenix_Bid_Process_Steps__c bStep5 = new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name = pb.Name + '-' + 'Vistex Update';
        bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c = stepsList[4].Id;

        bStep5.Phoenix_Status__c = 'In Process';
        bStep5.Phoenix_Approver_Team__c = 'Home Office';

        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);

        Phoenix_Bid_Process_Steps__c bStep7 = new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name = pb.Name + '-' + 'Closed';
        bStep7.Phoenix_Process_Step__c = stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
        insert processList;
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: pb.Id];
        system.debug('---bidProcessStepList---' + bidProcessStepList.size());
        list < Phoenix_Bid_Line_Item__c > lineItemsList1 = [select Id, Phoenix_Vistex_Status__c, Phoenix_Finance_Approval__c, Phoenix_Product_Director1__c, Phoenix_SCM_Final_Approval__c, Phoenix_SCM_Approval_Y_N__c, Phoenix_Contracts_Final_Approval__c, Phoenix_Contract_Approval__c, Phoenix_Product_Director__c, Phoenix_Marketing_Final_Approval__c, Phoenix_Marketing_Approval__c, Phoenix_Final_Status__c, Phoenix_Proposed_IPA_Price__c, Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: pb.Id];

        Phoenix_EditIPABidMainPageCls.getRelatedList(pb.Id);

        // list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        Phoenix_EditIPABidMainPageCls.saveLineItems(lineItemsList1);
        Phoenix_EditIPABidMainPageCls.saveTobid(pb.Id, 'comments', 'Processed');
     //   Phoenix_EditIPABidMainPageCls.makeApprovalsIPAContracts(pb.Id, 'Comments', 'Processed');
        //Phoenix_EditIPABidMainPageCls.makeApprovalsIPAContracts(pb.Id, 'Comments', 'Not Processed');
        Phoenix_EditIPABidMainPageCls.submitToProceddStep1(pb.Id, true, false, false);
        Phoenix_EditIPABidMainPageCls.submitToProceddStep1(pb.Id, false, true, false);
        Phoenix_EditIPABidMainPageCls.submitToProceddStep1(pb.Id, false, false, true);
        Phoenix_EditIPABidMainPageCls.submitToProceedVistex(pb.Id);
        Phoenix_EditIPABidMainPageCls.makeApprovals(pb.Id, lineItemsList1, true);
        Phoenix_EditIPABidMainPageCls.makeApprovalsVistex(pb.Id, lineItemsList1, true);
        Phoenix_EditIPABidMainPageCls.updateNextMarketingProcessSteps(pb.Id, pb.Name, bidProcessStepList, false);
        Phoenix_EditIPABidMainPageCls.updateNextVistexProcessSteps(pb.Id, pb.Name, bidProcessStepList, false);
        Phoenix_EditIPABidMainPageCls.makeApprovalsContracts(pb.Id, lineItemsList1, true, true, false);
        Phoenix_EditIPABidMainPageCls.makeApprovalsContracts(pb.Id, lineItemsList1, true, false, true);
        Phoenix_EditIPABidMainPageCls.updateNextFinanceProcessSteps(pb.Id, pb.Name, bidProcessStepList);
        Phoenix_EditIPABidMainPageCls.updateNextContractsProcessSteps(pb.Id, pb.Name, bidProcessStepList);
        Phoenix_EditIPABidMainPageCls.deleteLineItems(lineItemsList[0].Id);


    }
    static testmethod void Phoenix_EditIPABidMainPageClsMethod1() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();

        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Contracts_Approval__c = 'Processed';
        pb.Phoenix_Contracts_Approval_Comments__c = 'Comments';
        insert pb;

        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324', Phoenix_Product_Director__c = UserInfo.getUserId(), Phoenix_Marketing_Lead__c = UserInfo.getUserId());
        insert prod1;

        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_Product_Family1__c = 'Habitrol';
        bl.Phoenix_Product_Director1__c = UserInfo.getUserId();
        bl.Phoenix_Marketing_Final_Approval__c = true;
        bl.Phoenix_Marketing_Approval__c = 'Not Approved';
        insert bl;

        Phoenix_Approval_Matrix__c am = new Phoenix_Approval_Matrix__c();
        am.Name = 'test';
        insert am;

        Phoenix_Approval_Process_Step__c ap = new Phoenix_Approval_Process_Step__c();
        ap.Phoenix_Approval_Matrix__c = am.id;
        ap.Phoenix_Order__c = 11;
        insert ap;

        List < Phoenix_Bid_Process_Steps__c > bidprocess = new List < Phoenix_Bid_Process_Steps__c > ();

        for (Integer i = 0; i < 5; i++) {
            Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
            bisp.Name = 'closed' + i;
            bisp.Phoenix_Process_Step__c = ap.id;
            bisp.Phoenix_Bid__c = pb.Id;
            bisp.Phoenix_Approver__c = Userinfo.getUserId();
            bisp.Phoenix_Approver_Team__c = 'Marketing';
            bisp.Phoenix_Status__c = 'In Process';
            bidprocess.add(bisp);

        }
        insert bidprocess;
        Phoenix_EditIPABidMainPageCls.makeApprovals(pb.id, new list < Phoenix_Bid_Line_Item__c > {
            bl
        }, false);
    }
    static testmethod void Phoenix_EditIPABidMainPageClsMethod2() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;

        Phoenix_Approval_Matrix__c am = new Phoenix_Approval_Matrix__c();
        am.Name = 'test';
        insert am;
        Phoenix_Approval_Process_Step__c ap = new Phoenix_Approval_Process_Step__c();
        ap.Phoenix_Approval_Matrix__c = am.id;
        ap.Phoenix_Order__c = 11;
        insert ap;
        System.assertEquals(11, ap.Phoenix_Order__c);
        Phoenix_Approval_Process_Step__c ap2 = new Phoenix_Approval_Process_Step__c();
        ap2.Phoenix_Approval_Matrix__c = am.id;
        ap2.Phoenix_Order__c = 21;
        insert ap2;

        List < Phoenix_Bid_Process_Steps__c > bidprocess = new List < Phoenix_Bid_Process_Steps__c > ();
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();

        for (Integer i = 0; i < 5; i++) {
            /*Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
bisp.Name = 'Customer Service'+i;
bisp.Phoenix_Process_Step__c = ap.id;
bisp.Phoenix_Bid__c = pb.Id;
bisp.Phoenix_Approver__c = Userinfo.getUserId();
bisp.Phoenix_Approver_Team__c = 'Contracts';
bisp.Phoenix_Status__c = 'In Process';*/

            Phoenix_Bid_Process_Steps__c bisp1 = new Phoenix_Bid_Process_Steps__c();
            bisp1.Name = 'closed' + i;
            bisp1.Phoenix_Process_Step__c = ap2.id;
            bisp1.Phoenix_Bid__c = pb.Id;
            bisp1.Phoenix_Approver__c = Userinfo.getUserId();
            bisp1.Phoenix_Approver_Team__c = 'Finance';
            bidprocess.add(bisp1);
        }
        insert bidprocess;
        for (Phoenix_Bid_Process_Steps__c cmp: bidprocess) {
            stepMap.put(integer.valueof(cmp.Phoenix_Step__c), new List < Phoenix_Bid_Process_Steps__c > {
                cmp
            });
            stepnameNoMap.put(cmp.Phoenix_Approver_Team__c, integer.valueof(cmp.Phoenix_Step__c));
        }
        Phoenix_EditIPABidMainPageCls.updateNextFinanceProcessSteps(pb.Id, pb.Name, bidprocess);
        Phoenix_EditIPABidMainPageCls.updateNextContractsProcessSteps(pb.Id, pb.Name, bidprocess);

    }
 static testmethod void Phoenix_EditIPABidMainPageClsMethodLead() {
        List < Phoenix_User_Approval_Matrix__c > approvalGroups = new List < Phoenix_User_Approval_Matrix__c > ();
        List < Phoenix_User_Approval_Matrix__c > approvalUsers = new List < Phoenix_User_Approval_Matrix__c > ();
        List < User > users = new List < User > ();

        List < Phoenix_Bid__c > bidItemList = new List < Phoenix_Bid__c > ();
        List < Product2 > productList = new List < Product2 > ();
        List < Phoenix_Approval_Matrix__c > bidMatrixList = new List < Phoenix_Approval_Matrix__c > ();
        List < Phoenix_Bid__c > bidsList = new List < Phoenix_Bid__c > ();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list < Product2 > prodList = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2', Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3', Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE);

        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Contracts_Approval__c = 'Processed';
        pb.Phoenix_Contracts_Approval_Comments__c = 'Comments';
        insert pb;
        list < Phoenix_Bid_Line_Item__c > lineItemsList = new list < Phoenix_Bid_Line_Item__c > ();
        for (Integer i = 0; i < prodList.size(); i++) {
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Vistex_Status__c = 'Updated', Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved', Phoenix_Contract_Approval__c = 'Sent to Customer', Phoenix_Marketing_Approval__c = 'Approved', Phoenix_Bid__c = pb.Id, Phoenix_Product_Director1__c = UserInfo.getUserId(), Phoenix_Product__c = prodList[i].Id, Phoenix_Proposed_IPA_Price__c = 100, Phoenix_IDN_Usage__c = 10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;

        if (approvalGroups.size() == 0) {
            Phoenix_User_Approval_Matrix__c group1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Sales', Phoenix_Approval_Group_Behavior__c = 'Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Supply Chain', Phoenix_Approval_Group_Behavior__c = 'Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Marketing', Phoenix_Approval_Group_Behavior__c = 'Product based');
            approvalGroups.add(group3);

            Phoenix_User_Approval_Matrix__c group4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Finance', Phoenix_Approval_Group_Behavior__c = 'Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Contracts', Phoenix_Approval_Group_Behavior__c = 'Account based');
            approvalGroups.add(group5);
            Phoenix_User_Approval_Matrix__c group6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'SRx IPA Contracts Approver', Phoenix_Approval_Group_Behavior__c = 'Single User');
            approvalGroups.add(group6);

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
            Phoenix_User_Approval_Matrix__c userApp7 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(), Phoenix_Is_Approval_Process_User__c = true, Phoenix_Approver__c = UserInfo.getUserId(), User_Group__c = approvalGroups[5].Id);
            approvalUsers.add(userApp7);

            insert approvalUsers;
        }




        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c = 'NEW Individual Pricing Agreement (IPA)');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;

        List < Phoenix_Approval_Process_Step__c > stepsList = new List < Phoenix_Approval_Process_Step__c > ();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for (Phoenix_Approval_Matrix__c matrix: bidMatrixList) {
            Phoenix_Approval_Process_Step__c rfpStep1 = new Phoenix_Approval_Process_Step__c(Name = 'Initial Submission', Phoenix_Order__c = 1, Phoenix_Is_Notification_Only__c = false, Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep1);
            //Phoenix_Approval_Process_Step__c rfpStep3 = new  Phoenix_Approval_Process_Step__c(Name='Supply Chain',Phoenix_Order__c = 2,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Supply Chain',Phoenix_Approval_Matrix__c=matrix.Id);
            // stepsList.add(rfpStep3);
            Phoenix_Approval_Process_Step__c rfpStep2 = new Phoenix_Approval_Process_Step__c(Name = 'Marketing', Phoenix_Order__c = 2, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Marketing', Phoenix_Approval_Matrix__c = matrix.Id, Phoenix_Approver__c = UserInfo.getUserId());
            stepsList.add(rfpStep2);



            Phoenix_Approval_Process_Step__c rfpStep5 = new Phoenix_Approval_Process_Step__c(Name = 'Finance', Phoenix_Order__c = 3, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Finance', Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep5);
            Phoenix_Approval_Process_Step__c rfpStep6 = new Phoenix_Approval_Process_Step__c(Name = 'Contracts', Phoenix_Order__c = 4, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'SRx IPA Contracts Approver', Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep6);
            Phoenix_Approval_Process_Step__c rfpStep7 = new Phoenix_Approval_Process_Step__c(Name = 'Vistex Update', Phoenix_Order__c = 5, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Home Office', Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep7);
            //Phoenix_Approval_Process_Step__c rfpStep8 = new  Phoenix_Approval_Process_Step__c(Name='Customer Service',Phoenix_Order__c = 7,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Customer Service',Phoenix_Approval_Matrix__c=matrix.Id);
            // stepsList.add(rfpStep8);
            Phoenix_Approval_Process_Step__c rfpStep9 = new Phoenix_Approval_Process_Step__c(Name = 'Closed', Phoenix_Order__c = 6, Phoenix_Is_Notification_Only__c = false, Phoenix_Approval_Matrix__c = matrix.Id);
            stepsList.add(rfpStep9);
        }
        insert stepsList;
        list < Phoenix_Bid_Process_Steps__c > processList = new list < Phoenix_Bid_Process_Steps__c > ();
        Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c = stepsList[0].Id;
        system.debug('stepsList[0].Id---------------' + stepsList[0].Id);
        bStep.Name = pb.Name + '-' + 'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;

        bStep.Phoenix_Status__c = 'Submitted';

        bStep.Phoenix_Sub_Step__c = 1;
        processList.add(bStep);

        Phoenix_Bid_Process_Steps__c bStep2 = new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name = pb.Name + '-' + 'Marketing Lead Rx Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        bStep2.Phoenix_Process_Step__c = stepsList[1].Id;

        bStep2.Phoenix_Approver_Team__c = 'Marketing';

        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
     
       Phoenix_Bid_Process_Steps__c bStepSRX = new Phoenix_Bid_Process_Steps__c();
        bStepSRX.Phoenix_Is_Criteria_Step__c = false;
        bStepSRX.Name = pb.Name + '-' + 'Marketing Lead SRx Approval';
        bStepSRX.Phoenix_Approver__c = UserInfo.getUserId();
        bStepSRX.Phoenix_Bid__c = pb.Id;
        bStepSRX.Phoenix_Process_Step__c = stepsList[1].Id;

        bStepSRX.Phoenix_Approver_Team__c = 'Marketing';

        bStepSRX.Phoenix_Sub_Step__c = 1;
        processList.add(bStepSRX);
     
      Phoenix_Bid_Process_Steps__c bStepOTC = new Phoenix_Bid_Process_Steps__c();
        bStepOTC.Phoenix_Is_Criteria_Step__c = false;
        bStepOTC.Name = pb.Name + '-' + 'Marketing Lead OTC Approval';
        bStepOTC.Phoenix_Approver__c = UserInfo.getUserId();
        bStepOTC.Phoenix_Bid__c = pb.Id;
        bStepOTC.Phoenix_Process_Step__c = stepsList[1].Id;

        bStepOTC.Phoenix_Approver_Team__c = 'Marketing';

        bStepOTC.Phoenix_Sub_Step__c = 1;
        processList.add(bStepOTC);
     
      Phoenix_Bid_Process_Steps__c bStepHead = new Phoenix_Bid_Process_Steps__c();
        bStepHead.Phoenix_Is_Criteria_Step__c = false;
        bStepHead.Name = pb.Name + '-' + 'Marketing Head Approval';
        bStepHead.Phoenix_Approver__c = UserInfo.getUserId();
        bStepHead.Phoenix_Bid__c = pb.Id;
        bStepHead.Phoenix_Process_Step__c = stepsList[1].Id;

        bStepHead.Phoenix_Approver_Team__c = 'Marketing';

        bStepHead.Phoenix_Sub_Step__c = 1;
        processList.add(bStepHead);
     
        Phoenix_Bid_Process_Steps__c bStep3 = new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name = pb.Name + '-' + 'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb.Id;
        bStep3.Phoenix_Process_Step__c = stepsList[2].Id;

        bStep3.Phoenix_Approver_Team__c = 'Finance';

        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        Phoenix_Bid_Process_Steps__c bStep4 = new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name = pb.Name + '-' + 'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb.Id;
        bStep4.Phoenix_Process_Step__c = stepsList[3].Id;
        bStep4.Phoenix_Status__c = 'In Process';
        bStep4.Phoenix_Approver_Team__c = 'SRx IPA Contracts Approver';

        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);

        Phoenix_Bid_Process_Steps__c bStep5 = new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name = pb.Name + '-' + 'Vistex Update';
        bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c = stepsList[4].Id;

        bStep5.Phoenix_Status__c = 'In Process';
        bStep5.Phoenix_Approver_Team__c = 'Home Office';

        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);

        Phoenix_Bid_Process_Steps__c bStep7 = new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name = pb.Name + '-' + 'Closed';
        bStep7.Phoenix_Process_Step__c = stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
        insert processList;
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: pb.Id];
        system.debug('---bidProcessStepList---' + bidProcessStepList.size());
        list < Phoenix_Bid_Line_Item__c > lineItemsList1 = [select Id, Phoenix_Vistex_Status__c, Phoenix_Finance_Approval__c, Phoenix_Product_Director1__c, Phoenix_SCM_Final_Approval__c, Phoenix_SCM_Approval_Y_N__c, Phoenix_Contracts_Final_Approval__c, Phoenix_Contract_Approval__c, Phoenix_Product_Director__c, Phoenix_Marketing_Final_Approval__c, Phoenix_Marketing_Approval__c, Phoenix_Final_Status__c, Phoenix_Proposed_IPA_Price__c, Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: pb.Id];

        Phoenix_EditIPABidMainPageCls.getRelatedList(pb.Id);

        // list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        Phoenix_EditIPABidMainPageCls.saveLineItems(lineItemsList1);
        Phoenix_EditIPABidMainPageCls.saveTobid(pb.Id, 'comments', 'Processed');
     //   Phoenix_EditIPABidMainPageCls.makeApprovalsIPAContracts(pb.Id, 'Comments', 'Processed');
        //Phoenix_EditIPABidMainPageCls.makeApprovalsIPAContracts(pb.Id, 'Comments', 'Not Processed');
        Phoenix_EditIPABidMainPageCls.submitToProceddStep1(pb.Id, true, false, false);
        Phoenix_EditIPABidMainPageCls.submitToProceddStep1(pb.Id, false, true, false);
        Phoenix_EditIPABidMainPageCls.submitToProceddStep1(pb.Id, false, false, true);
        Phoenix_EditIPABidMainPageCls.submitToProceedVistex(pb.Id);
        Phoenix_EditIPABidMainPageCls.makeApprovals(pb.Id, lineItemsList1, true);
        Phoenix_EditIPABidMainPageCls.makeApprovalsVistex(pb.Id, lineItemsList1, true);
        Phoenix_EditIPABidMainPageCls.updateNextMarketingProcessSteps(pb.Id, pb.Name, bidProcessStepList, false);
        Phoenix_EditIPABidMainPageCls.updateNextVistexProcessSteps(pb.Id, pb.Name, bidProcessStepList, false);
        Phoenix_EditIPABidMainPageCls.makeApprovalsContracts(pb.Id, lineItemsList1, true, true, false);
        Phoenix_EditIPABidMainPageCls.makeApprovalsContracts(pb.Id, lineItemsList1, true, false, true);
        Phoenix_EditIPABidMainPageCls.updateNextFinanceProcessSteps(pb.Id, pb.Name, bidProcessStepList);
        Phoenix_EditIPABidMainPageCls.updateNextContractsProcessSteps(pb.Id, pb.Name, bidProcessStepList);
        Phoenix_EditIPABidMainPageCls.deleteLineItems(lineItemsList[0].Id);


    }
}