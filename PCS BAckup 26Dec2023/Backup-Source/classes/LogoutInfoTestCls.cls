@isTest //Annotation of test class
public class LogoutInfoTestCls {
//define testmethod 
 public static testmethod void testinsert()
 {
 Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');

  u.Last_Logout__c = System.now();
  u.Last_Logout_Format__c = Phoenix_Util.getUserTimeNow(u.Last_Logout__c, 'America/New_York');
   u.Login_and_Logout__c = false;
  insert u;
  }

}