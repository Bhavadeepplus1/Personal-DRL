@isTest
public class Phoenix_NDCChangeEditorTest {
    static testmethod void AddNDCProductMethod() {
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
        list <string> selectedProducts = new list <string> ();
        String sortField = 'Name';
        Boolean isAsc = true;
        Product2 prod1 = new Product2(Name = 'Test Product', Product_Family__c=pf.Id, Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Product_Family__c=pf1.Id, Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2', Product_Family__c=pf2.Id, Phoenix_Rx_SRx_OTC__c = 'SRx', Phoenix_Special_Product__c = true, Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3', Product_Family__c=pf2.Id, Phoenix_Rx_SRx_OTC__c = 'OTC', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;    
        
        selectedProducts.add(prod1.Id);
        selectedProducts.add(prod2.Id);
        selectedProducts.add(prod3.Id);
        selectedProducts.add(prod4.Id);
        
        Phoenix_NDC_Change__c testNDC=new Phoenix_NDC_Change__c();
        testNDC.Phoenix_Approval_Status__c='Draft';   
        testNDC.Phoenix_NDC_Change_Name__c    ='testRecord';
        testNDC.Phoenix_Current_Product_Family__c=prodList[0].Family;
        testNDC.Phoenix_Proposed_Product_Family__c=prodList[1].Family;
        insert testNDC;
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
        
        list<Phoenix_NDC_Change_Product__c>ndcProductList=new list<Phoenix_NDC_Change_Product__c>();
        Phoenix_NDC_Change_Product__c ndcChangeProduct=new Phoenix_NDC_Change_Product__c();
        ndcChangeProduct.Phoenix_NDC_Change_Name__c=testNDC.Id;
        ndcChangeProduct.Phoenix_Current_Product__c=prod1.Id;
        ndcChangeProduct.Phoenix_Proposed_Product__c=prod2.Id;
        insert ndcChangeProduct;
        
        list < Phoenix_NDC_Change_Line_Item__c > lineItemsList = new list < Phoenix_NDC_Change_Line_Item__c > ();
        Phoenix_NDC_Change_Line_Item__c pbl1=new Phoenix_NDC_Change_Line_Item__c();
        pbl1.Phoenix_NDC_Change__c=testNDC.Id;
        pbl1.Phoenix_NDC_Change_Product__c=ndcChangeProduct.Id;
        pbl1.Phoenix_Current_Product__c = prod1.id;
        pbl1.Phoenix_Proposed_Product__c = prod2.id;
        
        lineItemsList.add(pbl1);
        Phoenix_NDC_Change_Line_Item__c pbl2=new Phoenix_NDC_Change_Line_Item__c();
        pbl2.Phoenix_NDC_Change__c=testNDC.Id;
        pbl2.Phoenix_NDC_Change_Product__c=ndcChangeProduct.Id;
        pbl2.Phoenix_Current_Product__c = prod1.id;
        pbl2.Phoenix_Proposed_Product__c = prod2.id;
        lineItemsList.add(pbl2);
        insert lineItemsList;
        
        list<string>lineItemIds=new list<string>();    
        lineItemIds.add(pbl2.Id);
        Phoenix_NDCChangeEditor.getActiveBidProductFamilies();
        Phoenix_NDCChangeEditor.getProductsInfo(prodList[0].Family,prodList[1].Family);
        Phoenix_NDCChangeEditor.getProducts(selectedProducts, prodList[1].Family);
        Phoenix_NDCChangeEditor.getProposedProductInfo(prodList[1].Id);
        Phoenix_NDCChangeEditor.getNDCChangeInfo(testNDC.Id);
        Phoenix_NDCChangeEditor.getNDCLineItems(testNDC.Id);
        Phoenix_NDCChangeEditor.saveNDCChangeLineItems(lineItemsList);
        Phoenix_NDCChangeEditor.updateNDCChangeLineItems(lineItemsList,testNDC.Id);
        Phoenix_NDCChangeEditor.saveNDCChangeProducts(ndcProductList);
        Phoenix_NDCChangeEditor.getNDCChangeProductInfo(ndcChangeProduct.Id);
        Phoenix_NDCChangeEditor.getNPRData(new list < string > { prod1.Id },new list < string > { nprdat.Id });
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
        
        Phoenix_Bid_Process_Steps__c bStep3 = new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name = testNDC.Name + '-' + 'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_NDC_Change__c = testNDC.Id;
        bStep3.Phoenix_Process_Step__c = stepsList[2].Id;
        
        bStep3.Phoenix_Approver_Team__c = 'Finance';
        
        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
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
        insert processList;
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_NDC_Change__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_NDC_Change__c =: testNDC.Id];
        system.debug('---bidProcessStepList---' + bidProcessStepList.size());
        Phoenix_NDCChangeEditor.getApprovals(testNDC.Id);
        Phoenix_NDCChangeEditor.submitToProceddStep1(testNDC.Id);
        
          
        
        Phoenix_NDCChangeEditor.makeApprovals(testNDC.Id,lineItemsList,true,true,false,false,false,false);
        Phoenix_NDCChangeEditor.makeApprovals(testNDC.Id,lineItemsList,true,false,true,false,false,false);
        Phoenix_NDCChangeEditor.makeApprovals(testNDC.Id,lineItemsList,true,false,false,true,false,false);
        Phoenix_NDCChangeEditor.makeApprovals(testNDC.Id,lineItemsList,true,false,false,false,true,false);
        Phoenix_NDCChangeEditor.makeApprovals(testNDC.Id,lineItemsList,true,false,false,false,false,true);
        Phoenix_NDCChangeEditor.updateNextProcesSteps(testNDC.Id,'testRecord',bidProcessStepList,false,false,false,false,false,true);
        Phoenix_NDCChangeEditor.updateNextProcesSteps(testNDC.Id,'testRecord',bidProcessStepList,true,false,false,false,false,true);
     
         list<Phoenix_NDC_Change_Line_Item__c>linelist=[select id, Phoenix_Final_Status__c from Phoenix_NDC_Change_Line_Item__c where Phoenix_NDC_Change__c =: testNDC.Id];
        for(Phoenix_NDC_Change_Line_Item__c ndc: linelist){
              ndc.Phoenix_Contracts_Approval__c='No';
            ndc.Phoenix_Final_Status__c='Not Approved';
           
            
        }
        //update linelist;
         Phoenix_NDCChangeEditor.updateNextProcesSteps(testNDC.Id,'testRecord',bidProcessStepList,true,false,false,false,false,true);
         pbl1.Phoenix_Contracts_Approval__c='Yes';
         pbl1.Phoenix_Final_Finance_Approval__c=true;
         pbl1.Phoenix_Contracts_Final_Approval__c=false;
        pbl2.Phoenix_Contracts_Approval__c='Yes';
         pbl2.Phoenix_Final_Finance_Approval__c=true;
         pbl2.Phoenix_Contracts_Final_Approval__c=false;
        list<Phoenix_NDC_Change_Line_Item__c>linelist1=new list<Phoenix_NDC_Change_Line_Item__c>();
        linelist1.add(pbl1);
         linelist1.add(pbl2);
        update linelist1;
          Phoenix_NDCChangeEditor.makeContractsApprovals(testNDC.Id,lineItemsList,true);
           pbl1.Phoenix_Contracts_Approval__c='No';
         pbl1.Phoenix_Final_Finance_Approval__c=true;
         pbl1.Phoenix_Contracts_Final_Approval__c=false;
        update pbl1;
        
          Phoenix_NDCChangeEditor.makeContractsApprovals(testNDC.Id,lineItemsList,true);
         pbl1.Pheonix_Customer_Approval__c='Approved';
         pbl1.Phoenix_Customer_Final_Approval__c=false;
         pbl1.Phoenix_Contracts_Final_Approval__c=true;
       
         pbl2.Pheonix_Customer_Approval__c='Not Approved';
         pbl2.Phoenix_Customer_Final_Approval__c=false;
         pbl2.Phoenix_Contracts_Final_Approval__c=true;
           list<Phoenix_NDC_Change_Line_Item__c>linelist2=new list<Phoenix_NDC_Change_Line_Item__c>();
        linelist2.add(pbl1);
         linelist2.add(pbl2);
                      update linelist2;
                         Phoenix_NDCChangeEditor.makeContractsApprovals(testNDC.Id,lineItemsList,true);
         pbl1.Phoenix_Vistex_Approval__c='Updated';
         pbl1.Phoenix_Customer_Final_Approval__c=true;
         pbl1.Phoenix_Vistex_Final_Approval__c=false;
        update pbl1;
          Phoenix_NDCChangeEditor.makeContractsApprovals(testNDC.Id,lineItemsList,true);
          pbl1.Phoenix_Vistex_Approval__c='Pending';
         pbl1.Phoenix_Customer_Final_Approval__c=true;
         pbl1.Phoenix_Vistex_Final_Approval__c=false;
        update pbl1;
         Phoenix_NDCChangeEditor.makeContractsApprovals(testNDC.Id,lineItemsList,true);
        pbl1.Pheonix_Customer_Approval__c='Not Required';
       pbl2.Pheonix_Customer_Approval__c='Not Required';
        list<Phoenix_NDC_Change_Line_Item__c>linelist3=new list<Phoenix_NDC_Change_Line_Item__c>();
         linelist3.add(pbl1);
         linelist3.add(pbl2);
                      update linelist3;
        
        Phoenix_NDCChangeEditor.updateNDCChangeLineItems(lineItemsList,testNDC.Id);
        
        Phoenix_NDCChangeEditor.getLineItemIdsToDelete(ndcChangeProduct.Id);
        Phoenix_NDCChangeEditor.deleteNDCProduct(ndcChangeProduct.Id);
        Phoenix_NDCChangeEditor.deleteLineItems(pbl1.Id);
        Phoenix_NDCChangeEditor.deleteNDCLineItems(lineItemIds);
        
    }
}