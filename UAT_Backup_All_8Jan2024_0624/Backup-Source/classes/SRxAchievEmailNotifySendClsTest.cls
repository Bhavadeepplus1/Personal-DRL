@isTest
public class SRxAchievEmailNotifySendClsTest {
    
    @isTest
    public static void test1()
    {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
       
        String content2='Test Content';
       
        String toAddressStr = [SELECT Email FROM User WHERE Id = :UserInfo.getUserId()].Email;

       	List<String> toAddress = new List<String>();
		toAddress.add(toAddressStr);
        
        String subject='Subject ==>Approve through email';
        String title ='Title';
        Boolean isFooterTextAlterRequired=true;
        
        SRxAchievEmailNotifySendCls.sendEmailAlert(pb.Id,content2,toAddress,toAddress,subject,title,isFooterTextAlterRequired);
    }

}