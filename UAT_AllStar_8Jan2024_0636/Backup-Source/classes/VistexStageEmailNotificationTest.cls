@isTest
public class VistexStageEmailNotificationTest {
    
    @isTest
    public static void testmethod1()
    {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Bid_Name__c= 'ABC Progen - Febuxostat Volume review';
        pb.Phoenix_Comments__c = '<p>SCM team - current awarded annual usage on 80mg - 30,690 bottles. The increment annual usage request from customer was 1,620 bottles.</p>';
        pb.Phoenix_Approval_Status__c = 'Closed';
        pb.Phoenix_Internal_Target_Date__c = date.newinstance(2021,04,16);
        insert pb;
        
        
        Phoenix_Bid__c pb1 = new Phoenix_Bid__c();
        pb1.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb1.Phoenix_Comments__c = 'Test Comments';
        pb1.Phoenix_Customer__c = testAccount.Id;
        pb1.Phoenix_Bid_Name__c= 'ABC Progen - Febuxostat Volume review';
        pb1.Phoenix_Comments__c = '<p>SCM team - current awarded annual usage on 80mg - 30,690 bottles. The increment annual usage request from customer was 1,620 bottles.</p>';
        pb1.Phoenix_Approval_Status__c = 'Closed';
        pb1.Phoenix_Internal_Target_Date__c = date.newinstance(2021,04,16);
        insert pb1;
        
        VistexStageEmailNotification.vistexEmailNotification(pb.Id);
        
    }

}