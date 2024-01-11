@isTest
public class Phoneix_CIPNotificationTest {

    static testmethod void test1() {
        Test.startTest();
        Phoneix_CIPNotification MyPendingschedule = new Phoneix_CIPNotification();
        MyPendingschedule.execute(null);
        Test.stopTest();
    }
}