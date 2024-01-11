@isTest
public class Phoenix_MyPendingApprovalEmailTest {
    
    static testmethod void test1() {
        Test.startTest();
        Phoenix_MyPendingApprovalEmail MyPendingschedule = new Phoenix_MyPendingApprovalEmail();
        MyPendingschedule.execute(null);
        Test.stopTest();
    }
}