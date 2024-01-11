/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
@isTest
public class Phoenix_BidCreatorTest {
    
    static testmethod void BidCreatorOverrideMethod() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Bid_Deadline_Date__c = system.today();
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        insert pb;


        Phoenix_BidCreator.WrapperClass pbWrapper = new Phoenix_BidCreator.WrapperClass();
        Phoenix_BidCreator.getcustomerOwner(testAccount.Id);
        pbWrapper = Phoenix_BidCreator.getbidInfo(pb.Id);
        Phoenix_BidCreator.getRecordTypeDetails();
        pb.Phoenix_Bid_Deadline_Date__c = system.today();
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'EST';
        update pb;
    }
    
        static testmethod void BidCreatorOverrideMethod1() {
         Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Bid_Deadline_Date__c = system.today();
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
            pb.Phoenix_Bid_Type__c = 'RCA/IPA Member GPO or Wholesaler Change';
        insert pb;
          Phoenix_BidCreatorCtrl.codeCoverage();
       
           Phoenix_BidCreator.getbidInfo(pb.id);
            
        }

}