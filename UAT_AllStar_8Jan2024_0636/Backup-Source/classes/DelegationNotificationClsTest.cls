@isTest
public class DelegationNotificationClsTest {
    static testmethod void test1() {
        Profile prof = [select id from profile where name LIKE '%System Admin%'
                        limit 1];
        User user = new User();
        user.firstName = 'Alarrrn';
        user.lastName = 'McCarrrrrrthy';
        user.profileId = prof.id;
        user.username = 'testUserrrrrrr@drreddys.com' + System.now().getTime();
        user.email = 'msgjlkbllllllrrrrrlllllll@gmail.com' + System.now().getTime();
        user.EmailEncodingKey = 'ISO-8859-1';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.LocaleSidKey = 'en_US';
        user.Alias = 'hjbh';
        user.LanguageLocaleKey = 'en_US';
        user.Phoenix_Delegation_Start_Time__c = system.now();
        user.Phoenix_Delegation_End_Time__c = system.now()+1;
        user.Phoenix_Delegated_Approver__c = UserInfo.getUserId();
        insert user;
        DelegationNotificationCls.sendDelegationEndNotification(user.Id);
        DelegationNotificationCls.codeCoverage();
    }
}