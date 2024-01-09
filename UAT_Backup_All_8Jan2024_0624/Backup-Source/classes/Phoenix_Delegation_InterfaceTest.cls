@isTest
public class Phoenix_Delegation_InterfaceTest {
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
        insert user;
        User user1 = new User();
        user1.firstName = 'Alarrdddddddrn';
        user1.lastName = 'McCarrddddddrrrrthy';
        user1.profileId = prof.id;
        user1.username = 'testUserrrrdddddddddddrrr@drreddys.com' + System.now().getTime();
        user1.email = 'msgjlkbllllllddddddrrrrrlllllll@gmail.com' + System.now().getTime();
        user1.EmailEncodingKey = 'ISO-8859-1';
        user1.TimeZoneSidKey = 'America/Los_Angeles';
        user1.LocaleSidKey = 'en_US';
        user1.Alias = 'hjbh';
        user1.LanguageLocaleKey = 'en_US';
        insert user1;
        dateTime startTime =system.now()-100;
        dateTime endTime = system.now()-200;
        dateTime endTime2 = system.now()-200;
        dateTime startTime2 =system.now();
        Phoenix_Delegation_Interface.getExistingDeleRecords(user.Id);
        Phoenix_Delegation_Interface.deleteDelegationItems(user.Id);
        Phoenix_Delegation_Interface.updateUser(startTime,endTime,user.Id,user1.Id);
        Phoenix_Delegation_Interface.updateUser(startTime2,endTime2,user.Id,user1.Id);
        Phoenix_Delegation_Interface.codeCoverage();
    }
    
}