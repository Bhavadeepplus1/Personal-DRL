/**
* @description       : 
* @author            : Surender Patel (Dhruvsoft)
* @group             : 
* @last modified on  : 25-05-2021
* @last modified by  : Surender Patel (Dhruvsoft)
* Modifications Log 
* Ver   Date         Author                       Modification
* 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
@isTest
public class Phoenix_EditIPABidMainPageClsTest {
    
    
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
        Phoenix_EditIPABidMainPageCls.makeApprovalsIPAContracts(pb.Id, 'Comments', 'Processed');
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
        
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324',Phoenix_Product_Director__c = UserInfo.getUserId() ,Phoenix_Marketing_Lead__c = UserInfo.getUserId());
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
        bl.Phoenix_Marketing_Approval__c= 'Not Approved';
        insert bl;
        
        Phoenix_Approval_Matrix__c am = new Phoenix_Approval_Matrix__c();
        am.Name = 'test';
        insert am;
        
        Phoenix_Approval_Process_Step__c ap = new Phoenix_Approval_Process_Step__c();
        ap.Phoenix_Approval_Matrix__c = am.id;
        ap.Phoenix_Order__c = 11;
        insert ap;
        
        List < Phoenix_Bid_Process_Steps__c >  bidprocess= new List < Phoenix_Bid_Process_Steps__c >();
        
        for(Integer i=0;i<5;i++)
        {
            Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
            bisp.Name = 'closed'+i;
            bisp.Phoenix_Process_Step__c = ap.id;
            bisp.Phoenix_Bid__c = pb.Id;
            bisp.Phoenix_Approver__c = Userinfo.getUserId();
            bisp.Phoenix_Approver_Team__c = 'Marketing';
            bisp.Phoenix_Status__c = 'In Process';
            bidprocess.add(bisp);
            
        }
        insert bidprocess; 
        Phoenix_EditIPABidMainPageCls.makeApprovals(pb.id,new list<Phoenix_Bid_Line_Item__c>{bl},false);
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
        
        List < Phoenix_Bid_Process_Steps__c >  bidprocess= new List < Phoenix_Bid_Process_Steps__c >();
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
        
        for(Integer i=0;i<5;i++)
        {
            /*Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
bisp.Name = 'Customer Service'+i;
bisp.Phoenix_Process_Step__c = ap.id;
bisp.Phoenix_Bid__c = pb.Id;
bisp.Phoenix_Approver__c = Userinfo.getUserId();
bisp.Phoenix_Approver_Team__c = 'Contracts';
bisp.Phoenix_Status__c = 'In Process';*/
            
            Phoenix_Bid_Process_Steps__c bisp1 = new Phoenix_Bid_Process_Steps__c();
            bisp1.Name = 'closed' + i ;
            bisp1.Phoenix_Process_Step__c = ap2.id;
            bisp1.Phoenix_Bid__c = pb.Id;
            bisp1.Phoenix_Approver__c = Userinfo.getUserId();
            bisp1.Phoenix_Approver_Team__c = 'Finance';
            bidprocess.add(bisp1);
        }
        insert bidprocess;
        for(Phoenix_Bid_Process_Steps__c cmp : bidprocess)
        {
            stepMap.put(integer.valueof(cmp.Phoenix_Step__c), new List<Phoenix_Bid_Process_Steps__c>{cmp}); 
            stepnameNoMap.put(cmp.Phoenix_Approver_Team__c, integer.valueof(cmp.Phoenix_Step__c));
        }
        Phoenix_EditIPABidMainPageCls.updateNextFinanceProcessSteps(pb.Id, pb.Name, bidprocess);
        Phoenix_EditIPABidMainPageCls.updateNextContractsProcessSteps(pb.Id, pb.Name, bidprocess);
        
    }
    
}