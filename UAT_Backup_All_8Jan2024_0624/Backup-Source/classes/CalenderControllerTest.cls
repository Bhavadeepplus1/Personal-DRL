@isTest
public class CalenderControllerTest {
    
    @testSetup
    public static void createData(){
        
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        testAccount.RecordTypeId =  Schema.sObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        testAccount.Phoenix_Is_Bid_Account__c = true;
        insert testAccount;
        
        Contact testCon = new Contact();
        testCon.FirstName = 'Test';
        testCon.LastName = 'Con';
        testCon.Influence_Score__c = 1;
        testCon.Affinity_Score__c = 2;
        testCon.AccountId = testAccount.Id;
        insert testCon;
        
        /*
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.AccountId  = testAccount.Id;
        testOpp.Internal_Closing_Date__c = Date.today();
        testOpp.Customer_Closing_Date__c = Date.today();
        testOpp.closeDate = Date.today();
        testOpp.StageName = 'Opportunity in progress';
        testOpp.Products_Source__c = 'Manual';
        testOpp.Bid_Type__c = 'RFP';
        testOpp.Type = 'Reactive';
        insert testOpp;
	*/
        
        Phoenix_Bid__c testBid = new Phoenix_Bid__c();  
        testBid.Phoenix_Bid_Name__c = 'Test Bid';
        testBid.Phoenix_Bid_Type__c = 'RFP Bids';
        testBid.Phoenix_Approval_Status__c = 'Draft';
        testBid.Phoenix_Internal_Target_Date__c = Date.today();
        testBid.Phoenix_Customer__c = testAccount.Id;
        insert testBid;
        
        Task testTask = new Task();
        testTask.Subject = 'Call';
        testTask.ActivityDate = Date.today();
        testTask.WhoId = testCon.Id;
        testTask.WhatId = testAccount.Id;
        insert testTask;
        
        Event testEvent = new Event();
        testEvent.Subject = 'Call';
        testEvent.StartDateTime = Date.today();
        testEvent.EndDateTime = Date.today();
        testEvent.WhoId = testCon.Id;
        testEvent.WhatId = testAccount.Id;
        insert testEvent;
    }
    
    @isTest
    public static void fetchOpportunitiesAndBidsTest(){
        Test.startTest();
        Account acc = [Select Id, Name from Account LIMIT 1];
        CalenderController.fetchOpportunitiesAndBids(acc.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void getContactScoresTest(){
        Test.startTest();
        Account acc = [Select Id, Name from Account LIMIT 1];
        CalenderController.getContactScores(acc.Id);
        Test.stopTest();
    }
}