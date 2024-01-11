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
@isTest
public class Phoenix_UserApprovalMatrix_Tgr_Test {
    static testmethod void test1() {
        try {
            Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
            //testData.generateUsers();
            testData.generateApprovalMatrix();
            List < Phoenix_User_Approval_Matrix__c > groups = new List < Phoenix_User_Approval_Matrix__c > ();
            Phoenix_User_Approval_Matrix__c group1 = new Phoenix_User_Approval_Matrix__c(
                Phoenix_Approver_Group_Name__c = 'Sales', Phoenix_Approval_Group_Behavior__c = 'Team'
            );
            groups.add(group1);

            Phoenix_User_Approval_Matrix__c group2 = testData.approvalGroups[0];
            group2.Phoenix_Approver_Group_Name__c = 'Marketing';
            group2.Phoenix_Approval_Group_Behavior__c = 'Team';

            groups.add(group2);

            upsert group2;

            List < Phoenix_User_Approval_Matrix__c > users = new List < Phoenix_User_Approval_Matrix__c > ();
            Phoenix_User_Approval_Matrix__c user1 = new Phoenix_User_Approval_Matrix__c(
                User_Group__c = testData.approvalGroups[0].Id, Phoenix_Approver__c = UserInfo.getUserId()
            );

            users.add(user1);

            Phoenix_User_Approval_Matrix__c user2 = testData.approvalUsers[1];
            user2.User_Group__c = testData.approvalGroups[2].Id;
            user2.Phoenix_Approver__c = UserInfo.getUserId();


            users.add(user2);

            upsert users;







        } catch (Exception ex) {}


    }
}