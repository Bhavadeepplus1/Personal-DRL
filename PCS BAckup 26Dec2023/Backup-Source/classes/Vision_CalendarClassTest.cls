@isTest
public class Vision_CalendarClassTest {
    
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
        
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.AccountId  = testAccount.Id;
        testOpp.Vision_Internal_Closing_Date__c = Date.today();
        testOpp.Vision_Customer_Closing_Date__c = Date.today();
        testOpp.closeDate = Date.today();
        testOpp.StageName = 'Opportunity in progress';
        testOpp.Vision_Products_Source__c = 'Manual';
        testOpp.Bid_Type__c = 'RFP';
        testOpp.Type = 'Reactive';
        insert testOpp;
	
        
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
        
        Vision_Alert__c testAlert = new Vision_Alert__c();
        testAlert.Name = 'Call';
        testAlert.Vision_Alert_Type__c = 'Net Sales';
        testAlert.Vision_Notification_Due_Date__c = Date.today();
        testAlert.Account__c= testAccount.Id;
        //testAlert.EndDateTime = Date.today();
        //testAlert.WhoId = testCon.Id;
        //testAlert.WhatId = testAccount.Id;
        insert testAlert;
        
      /*  Vision_Market_Share_Expansion__c testPanorama = new Vision_Market_Share_Expansion__c();
        testPanorama.Plan_Contract_Effective_Date__c =  Date.today();
        testPanorama.Task_Status__c ='New';
       	testPanorama.Vision_Customer__c = testAccount.Id;
         insert testPanorama;*/
    }
    
    @isTest
    public static void fetchOpportunitiesAndBidsTest(){
        Test.startTest();
        Account acc = [Select Id, Name from Account LIMIT 1];
        Phoenix_Contract__c con= new Phoenix_Contract__c();
        con.Phoenix_Customer__c = acc.Id;
        Vision_CalenderClass.getAccObj(acc.Id);
        Vision_CalenderClass.fetchOpportunitiesAndBids(acc.Id,'bids');
        Vision_CalenderClass.fetchOpportunitiesAndBids(acc.Id,'all');
        Vision_CalenderClass.fetchOpportunitiesAndBids(acc.Id,'opps');
        Vision_CalenderClass.fetchOpportunitiesAndBids(acc.Id,'panorama');
        Vision_CalenderClass.fetchOpportunitiesAndBids(acc.Id,'task');
        Vision_CalenderClass.fetchOpportunitiesAndBids(acc.Id,'event');
        Vision_CalenderClass.fetchOpportunitiesAndBids(acc.Id,'contract');
           Vision_AllCustomer_Calendar_Cls.getAccObj();
        Vision_AllCustomer_Calendar_Cls.fetchOpportunitiesAndBids();
    
        Test.stopTest();
    }
    
  /*  @isTest
    public static void getContactScoresTest(){
        Test.startTest();
        Account acc = [Select Id, Name from Account LIMIT 1];
        Vision_CalenderClass.getContactScores(acc.Id);
        Test.stopTest();
    }*/
}