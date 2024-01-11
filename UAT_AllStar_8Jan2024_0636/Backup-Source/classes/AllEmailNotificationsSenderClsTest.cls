@isTest
public class AllEmailNotificationsSenderClsTest {
    
    @isTest
    public static void testMethod1(){
        
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
        
        String subject='Subject';
        String title ='Title';
        Boolean isFooterTextAlterRequired=true;
        
        AllEmailNotificationsSenderCls.sendEmailAlert(pb.Id,content2,toAddress,toAddress,subject,title,isFooterTextAlterRequired);
        
    }
     @isTest
    public static void testMethod2(){
        
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
        
        String subject='Subject';
        String title ='Title';
        Boolean isFooterTextAlterRequired=false;
       	
        Decimal value=1200;
        
        AllEmailNotificationsSenderCls.sendEmailAlert(pb.Id,content2,toAddress,toAddress,subject,title,isFooterTextAlterRequired);
    }
    @isTest
    public static void testGetCurrencyFormatted() {
      
        Decimal positiveValue = 100.50;
        String result = AllEmailNotificationsSenderCls.getCurrencyFormatted(positiveValue);
   
        Decimal negativeValue = -50.75;
        result = AllEmailNotificationsSenderCls.getCurrencyFormatted(negativeValue);
      
    }

    @isTest
    public static void testGetRoundedCurrencyFormatted() {
     
        Decimal positiveValue = 100.50;
        String result = AllEmailNotificationsSenderCls.getRoundedCurrencyFormatted(positiveValue);
        
        Decimal negativeValue = -50.75;
        result = AllEmailNotificationsSenderCls.getRoundedCurrencyFormatted(negativeValue);
       
    }

    @isTest
    public static void testGetPercentFormatted() {
     
        Decimal positiveValue = 0.1234;
        Decimal result = AllEmailNotificationsSenderCls.getPercentFormatted(positiveValue);
       
        Decimal negativeValue = -0.5678;
        result = AllEmailNotificationsSenderCls.getPercentFormatted(negativeValue);
 
    }

}