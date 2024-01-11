/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 18-10-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 **/
@isTest
public class UserTriggerTest {
   @isTest
   static void setupTestData() {
      Profile prof = [select id from profile where name LIKE '%System Admin%'
         limit 1
      ];
        Profile prof1 = [select id from profile where name LIKE '%System Admin%'
         limit 1
      ];
      User testuser = new User();
      testuser.firstName = 'Alan';
      testuser.lastName = 'McCarthy';
      testuser.profileId = prof.id;
      testuser.username = 'testUser@drreddys.com' + System.now().getTime();
      testuser.email = 'msgjlkblllllllllllll@gmail.com' + System.now().getTime();
      testuser.EmailEncodingKey = 'ISO-8859-1';
      testuser.TimeZoneSidKey = 'America/Los_Angeles';
      testuser.LocaleSidKey = 'en_US';
      testuser.Alias = 'hjbh';
      testuser.LanguageLocaleKey = 'en_US';
      insert testuser;
      User user = new User();
      user.firstName = 'Alan';
      user.lastName = 'McCarthy';
      user.profileId = prof.id;
      user.username = 'testUser@drreddys.com' + System.now().getTime();
      user.email = 'msgjlkblllllllllllll@gmail.com' + System.now().getTime();
      user.EmailEncodingKey = 'ISO-8859-1';
      user.TimeZoneSidKey = 'America/Los_Angeles';
      user.LocaleSidKey = 'en_US';
      user.Alias = 'hjbh';
      user.LanguageLocaleKey = 'en_US';
      insert user;
      user.Phoenix_Delegation_Start_Time__c = system.now();
      user.Phoenix_Delegation_End_Time__c = system.now()+4;
      user.Phoenix_Delegated_Approver__c = testuser.Id;
      update user;
       User userOld = new User();
      userOld.firstName = 'Alan1';
      userOld.lastName = 'McCarthy1';
      userOld.profileId = prof1.id;
      userOld.username = 'testUser@drreddys1.com' + System.now().getTime();
      userOld.email = 'msgjlkbllllllllllll1l@gmail.com' + System.now().getTime();
      userOld.EmailEncodingKey = 'ISO-8859-1';
      userOld.TimeZoneSidKey = 'America/Los_Angeles';
      userOld.LocaleSidKey = 'en_US';
      userOld.Alias = 'hjbh';
      userOld.LanguageLocaleKey = 'en_US';
      insert userOld;
      userOld.Phoenix_Delegation_Start_Time__c = system.now();
      userOld.Phoenix_Delegation_End_Time__c = system.now()+5;
      userOld.Phoenix_Delegated_Approver__c = testuser.Id;
      update userOld;
       Phoenix_Approval_Delegation_History__c PDH = new Phoenix_Approval_Delegation_History__c();
       PDH.Phoenix_Delegation_Start_Time__c = system.now();
       PDH.Phoenix_Delegation_End_Time__c = system.now() +5 ;
       PDH.Phoenix_Delegated_Approver__c = userOld.Id;
       PDH.Phoenix_User__c = userOld.Id;
       PDH.Phoenix_Is_Active_delegator__c = true;
       insert PDH;
        Phoenix_Approval_Delegation_History__c PDH1 = new Phoenix_Approval_Delegation_History__c();
       PDH1.Phoenix_Delegation_Start_Time__c = system.now();
       PDH1.Phoenix_Delegation_End_Time__c = system.now() +1 ;
       PDH1.Phoenix_Delegated_Approver__c = Userinfo.getUserId();
       PDH1.Phoenix_User__c = Userinfo.getUserId();
       PDH1.Phoenix_Is_Active_delegator__c = true;
       insert PDH1;
       PDH1.Phoenix_Delegation_End_Time__c = system.now() +3 ;
       List<String> PDHIds = new List<String>();
       PDHIds.add(Userinfo.getUserId());
       List<User> existingDeligationHistory = [SELECT Id, Phoenix_Delegated_Approver__c, Phoenix_Delegation_Start_Time__c, Phoenix_Delegation_End_Time__c FROM User Where Id=:PDHIds];
       for(User AprDelHis : existingDeligationHistory){
           AprDelHis.Phoenix_Delegation_Start_Time__c= null;
           AprDelHis.Phoenix_Delegation_End_Time__c =null;
           AprDelHis.Phoenix_Delegated_Approver__c = null;
       }
       system.debug('existingDeligationHistory--->'+existingDeligationHistory);
       Phoenix_SubmitBidForApprovalCtrl.DelegationEmailAlert(user.Id);
       update existingDeligationHistory;
       

   }
}