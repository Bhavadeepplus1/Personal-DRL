/**
 * @description       : 
 * @author            : Surender Dhruvsoft
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Dhruvsoft
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   25-05-2021   Surender Dhruvsoft   Initial Version
**/
public class Phoenix_TestDataCreator {
    public List < Phoenix_User_Approval_Matrix__c > approvalGroups = new List < Phoenix_User_Approval_Matrix__c > ();
    public List < Phoenix_User_Approval_Matrix__c > approvalUsers = new List < Phoenix_User_Approval_Matrix__c > ();
    public List < User > users = new List < User > ();
    public List < Phoenix_Bid__c > bidsList = new List < Phoenix_Bid__c > ();
    public List < Phoenix_Bid__c > bidItemList = new List < Phoenix_Bid__c > ();
    public List < Product2 > productList = new List < Product2 > ();
    public List < Phoenix_Approval_Matrix__c > bidMatrixList = new List < Phoenix_Approval_Matrix__c > ();


    public Phoenix_TestDataCreator() {

    }

    public void generateApprovalMatrix() {
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
            generateUsers();
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

        if (bidMatrixList.size() == 0) {

            Phoenix_Approval_Matrix__c matrixRFP = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c = 'RFP Bids', Phoenix_Is_Criteria_Matrix__c = false);
            bidMatrixList.add(matrixRFP);
            Phoenix_Approval_Matrix__c matrix2 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c = 'VIP Rebate', Phoenix_Is_Criteria_Matrix__c = false);
            bidMatrixList.add(matrix2);
            Phoenix_Approval_Matrix__c matrix3 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c = 'Customer Requested Pricing Confirmations', Phoenix_Is_Criteria_Matrix__c = false);
            bidMatrixList.add(matrix3);
            Phoenix_Approval_Matrix__c matrix4 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c = 'RCA Member Addition', Phoenix_Is_Criteria_Matrix__c = false);
            bidMatrixList.add(matrix4);
            Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c = 'NEW Individual Pricing Agreement (IPA)', Phoenix_Is_Criteria_Matrix__c = false);
            bidMatrixList.add(matrix5);
            insert bidMatrixList;

            List < Phoenix_Approval_Process_Step__c > stepsList = new List < Phoenix_Approval_Process_Step__c > ();
            // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
            for (Phoenix_Approval_Matrix__c matrix: bidMatrixList) {
                Phoenix_Approval_Process_Step__c rfpStep1 = new Phoenix_Approval_Process_Step__c(Name = 'Initial Submission', Phoenix_Order__c = 1, Phoenix_Is_Notification_Only__c = false, Phoenix_Approval_Matrix__c = matrix.Id);
                stepsList.add(rfpStep1);
                Phoenix_Approval_Process_Step__c rfpStep2 = new Phoenix_Approval_Process_Step__c(Name = 'Supply Chain', Phoenix_Order__c = 2, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Supply Chain', Phoenix_Approval_Matrix__c = matrix.Id, Phoenix_Approver__c = UserInfo.getUserId());
                stepsList.add(rfpStep2);
                Phoenix_Approval_Process_Step__c rfpStep3 = new Phoenix_Approval_Process_Step__c(Name = 'Marketing', Phoenix_Order__c = 3, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Marketing', Phoenix_Approval_Matrix__c = matrix.Id);
                stepsList.add(rfpStep3);
                Phoenix_Approval_Process_Step__c rfpStep4 = new Phoenix_Approval_Process_Step__c(Name = 'Business Head', Phoenix_Order__c = 4, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Business Head', Phoenix_Is_Criteria_Step__c = true, Phoenix_Approval_Matrix__c = matrix.Id);
                stepsList.add(rfpStep4);

                Phoenix_Approval_Process_Step__c rfpStep5 = new Phoenix_Approval_Process_Step__c(Name = 'Finance', Phoenix_Order__c = 5, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Finance', Phoenix_Approval_Matrix__c = matrix.Id);
                stepsList.add(rfpStep5);
                Phoenix_Approval_Process_Step__c rfpStep6 = new Phoenix_Approval_Process_Step__c(Name = 'Contracts', Phoenix_Order__c = 6, Phoenix_Is_Notification_Only__c = false, Phoenix_Approver_Team__c = 'Contracts', Phoenix_Approval_Matrix__c = matrix.Id);
                stepsList.add(rfpStep6);
                Phoenix_Approval_Process_Step__c rfpStep7 = new Phoenix_Approval_Process_Step__c(Name = 'Closed', Phoenix_Order__c = 7, Phoenix_Is_Notification_Only__c = false, Phoenix_Approval_Matrix__c = matrix.Id);
                stepsList.add(rfpStep7);
            }



            insert stepsList;















        }
    }

    public void generateBids() {
        if (bidsList.size() == 0) {

            Phoenix_Bid__c bid1 = new Phoenix_Bid__c(Phoenix_Bid_Type__c = 'RFP Bids', Phoenix_Approval_Status__c = 'Draft');
            bidsList.add(bid1);
            Phoenix_Bid__c bid2 = new Phoenix_Bid__c(Phoenix_Bid_Type__c = 'VIP Rebate', Phoenix_Approval_Status__c = 'Draft');
            bidsList.add(bid2);
            Phoenix_Bid__c bid3 = new Phoenix_Bid__c(Phoenix_Bid_Type__c = 'Customer Requested Pricing Confirmations', Phoenix_Approval_Status__c = 'Draft');
            bidsList.add(bid3);
            Phoenix_Bid__c bid4 = new Phoenix_Bid__c(Phoenix_Bid_Type__c = 'RCA Member Addition', Phoenix_Approval_Status__c = 'Draft');
            bidsList.add(bid4);
            Phoenix_Bid__c bid5 = new Phoenix_Bid__c(Phoenix_Bid_Type__c = 'NEW Individual Pricing Agreement (IPA)', Phoenix_Approval_Status__c = 'Draft');
            bidsList.add(bid5);

            insert bidsList;
        }
        generateProducts();
        List < Phoenix_Bid_Line_Item__c > bItems = new List < Phoenix_Bid_Line_Item__c > ();
        Phoenix_Bid_Line_Item__c item1 = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = bidsList[0].Id, Phoenix_Product__c = productList[0].Id, Phoenix_Product_Family1__c = 'Levocetrizine');
        Phoenix_Bid_Line_Item__c item2 = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = bidsList[0].Id, Phoenix_Product__c = productList[1].Id, Phoenix_Product_Family1__c = 'Levocetrizine2');
        Phoenix_Bid_Line_Item__c item3 = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = bidsList[0].Id, Phoenix_Product__c = productList[2].Id, Phoenix_Product_Family1__c = 'Levocetrizine');
        bItems.addAll(new List < Phoenix_Bid_Line_Item__c > {
            item1,
            item2,
            item3
        });
        insert bItems;

    }

    public void generateProducts() {
        generateUsers();
        if (productList.size() == 0) {
            Product2 prod1 = new Product2(Name = 'Product1', ProductCode = '1234', Phoenix_Product_Director__c = users[0].Id,Phoenix_Marketing_Lead__c = UserInfo.getUserId());
            Product2 prod2 = new Product2(Name = 'Product1', ProductCode = '12345', Phoenix_Product_Director__c = UserInfo.getUserId(),Phoenix_Marketing_Lead__c = UserInfo.getUserId());
            Product2 prod3 = new Product2(Name = 'Product1', ProductCode = '123456', Phoenix_Product_Director__c = UserInfo.getUserId(),Phoenix_Marketing_Lead__c = UserInfo.getUserId());
            productList.addAll(new List < Product2 > {
                prod1,
                prod2,
                prod3
            });
            insert productList;
        }
    }

    public void generateUsers() {
        if (users.size() == 0) {
            Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
            String uid = ('Phoenix' + System.now().getTime()).SubString(0, 8);
            User u1 = new User(Alias = uid, Email = uid + '@phoenix.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/New_York', UserName = uid + '@phoenix.com');


            users.add(u1);


            insert users;
        }
    }
}