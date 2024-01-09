/**
* @description       :
* @author            : Surender Patel (Dhruvsoft)
* @group             :
* @last modified on  : 01-07-2021
* @last modified by  : Surender Patel (Dhruvsoft)
* Modifications Log
* Ver   Date         Author                       Modification
* 1.0   18-11-2020   Surender Patel (Dhruvsoft)   Initial Version
**/
@istest(seeAllData=true)
public class Phoenix_Unit_Tests {
    
    static testmethod void testUtil() {
        String accFields = Phoenix_Util.nprDataFields;
        String accFields1 = Phoenix_Util.contractFields;
        String accFields2 = Phoenix_Util.productFields;
        String accFields3 = Phoenix_Util.customerFields;
        String accFields4 = Phoenix_Util.sapNPRStagingFields;
        String accFields5 = Phoenix_Util.nprVolumeFields;
        String accFields6 = Phoenix_Util.bidFields;
        String accFields15 = Phoenix_Util.bidlineitemFields;
        String accFields16 = Phoenix_Util.userApprovalMatrixFields;
        String accFields17 = Phoenix_Util.approvalMatrixFields;
        String accFields18 = Phoenix_Util.approvalProcessStepFields;
        Boolean accFields19 = Phoenix_Util.hasAlreadyDone();
        String approvalGridFields = Phoenix_Util.approvalGridFields;
        String accFields25 = Phoenix_Util.bidProcessStepFields;
        String accFields26 = Phoenix_Util.ndcChangeFields;
        String accFields27 = Phoenix_Util.wacChangeFields;
        String accFields28 = Phoenix_Util.ndcChangeLineItemFields;
        String accFields29 = Phoenix_Util.ndcChangeProductFields;
        String accFields30 = Phoenix_Util.bidLineItemExtnFields;
        
        Phoenix_Util.setAlreadyDone();
        String orgEmail = Phoenix_Util.orgWideEmailId;
        String SShotFields = Phoenix_Util.nprSnapShotFields;
        String QuantityFields = Phoenix_Util.awardedQuantityFields;
        String NPRDataFields = Phoenix_Util.futureNPRDataFields;
        
        String accFields8 = Phoenix_Util.nprDataFields;
        String accFields9 = Phoenix_Util.contractFields;
        String accFields10 = Phoenix_Util.productFields;
        String accFields11 = Phoenix_Util.customerFields;
        String accFields12 = Phoenix_Util.sapNPRStagingFields;
        String accFields13 = Phoenix_Util.nprVolumeFields;
        String accFields14 = Phoenix_Util.bidFields;
        String accFields20 = Phoenix_Util.bidlineitemFields;
        String accFields21 = Phoenix_Util.userApprovalMatrixFields;
        String accFields22 = Phoenix_Util.approvalMatrixFields;
        String accFields23 = Phoenix_Util.approvalProcessStepFields;
        Boolean accFields24 = Phoenix_Util.hasAlreadyDone();
        String approvalGridFields2 = Phoenix_Util.approvalGridFields;
        String orgEmail2 = Phoenix_Util.orgWideEmailId;
        String tm = Phoenix_Util.getUserTimeNow(System.now(), 'America/New_York');
        Phoenix_Util.getUserTime(System.now(), 'America/New_York');
        String tm2 = Phoenix_Util.getTimezoneShortName('America/New_York');
        Phoenix_Util.getTimezoneShortName('TEST');
        Phoenix_Util.removeSymbolsFromString('IPA St.Lukeâ€\'\'s Hosp.-Upper Bucks Campus');
        
        Phoenix_Util.getNowEST();
        Phoenix_Util.getTodayEST();
        test.starttest();
        Phoenix_Util.sendBatchJobCompletionEmail('testjobname',  'testcomments');
        Phoenix_Util.getTemplateBody('Batch_Completion_Notification', UserInfo.getUserId());
        test.stopTest();

        String org3 = Phoenix_Util.orgWideEmailId;
        
        System.assertEquals(true, accFields.containsIgnoreCase('Id'));
    }
    
    static testmethod void parentAccountTestMethod() {
        //creating accounts
        List < Account > accList = new List < Account > ();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account parentAccount = new Account(Name = 'Parent Account', RecordTypeId = phoenixRecordTypeId);
        Account childAccount = new Account(Name = 'child Account', RecordTypeId = phoenixRecordTypeId, ParentId = parentAccount.Id);
        Account grandchildAccount = new Account(Name = 'grandchild Account', RecordTypeId = phoenixRecordTypeId, ParentId = childAccount.Id);
        accList.add(parentAccount);
        accList.add(childAccount);
        accList.add(grandchildAccount);
        insert accList;
        
        //creating Term matrixs
        List < Phoenix_Terms_Matrix__c > termMatrixList = new List < Phoenix_Terms_Matrix__c > ();
        Phoenix_Terms_Matrix__c parentTermMatrix = new Phoenix_Terms_Matrix__c(Name = 'test matrix', Phoenix_Agreement_Name__c = 'test agreeent', Phoenix_Customer_Name__c = parentAccount.Id);
        Phoenix_Terms_Matrix__c childTermMatrix = new Phoenix_Terms_Matrix__c(Name = 'test matrix2', Phoenix_Agreement_Name__c = 'test agreeent', Phoenix_Customer_Name__c = parentAccount.Id);
        Phoenix_Terms_Matrix__c grandchildTermMatrix = new Phoenix_Terms_Matrix__c(Name = 'test matrix3', Phoenix_Agreement_Name__c = 'test agreeent', Phoenix_Customer_Name__c = parentAccount.Id);
        termMatrixList.add(parentTermMatrix);
        termMatrixList.add(childTermMatrix);
        termMatrixList.add(grandchildTermMatrix);
        insert termMatrixList;
        
        Phoenix_TermsMatrixList.getTermsMatrix(parentAccount.Id);
    }
    
    static testmethod void childAccountTestMethod() {
        //creating accounts
        List < Account > accList = new List < Account > ();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account parentAccount = new Account(Name = 'Parent Account');
        Account childAccount = new Account(Name = 'child Account', RecordTypeId = phoenixRecordTypeId, ParentId = parentAccount.Id);
        Account grandchildAccount = new Account(Name = 'grandchild Account', RecordTypeId = phoenixRecordTypeId, ParentId = childAccount.Id);
        accList.add(parentAccount);
        accList.add(childAccount);
        accList.add(grandchildAccount);
        insert accList;
        //creating Term matrixs
        List < Phoenix_Terms_Matrix__c > termMatrixList = new List < Phoenix_Terms_Matrix__c > ();
        Phoenix_Terms_Matrix__c parentTermMatrix = new Phoenix_Terms_Matrix__c(Name = 'test matrix', Phoenix_Agreement_Name__c = 'test agreeent', Phoenix_Customer_Name__c = parentAccount.Id);
        Phoenix_Terms_Matrix__c childTermMatrix = new Phoenix_Terms_Matrix__c(Name = 'test matrix2', Phoenix_Agreement_Name__c = 'test agreeent', Phoenix_Customer_Name__c = parentAccount.Id);
        Phoenix_Terms_Matrix__c grandchildTermMatrix = new Phoenix_Terms_Matrix__c(Name = 'test matrix3', Phoenix_Agreement_Name__c = 'test agreeent', Phoenix_Customer_Name__c = parentAccount.Id);
        termMatrixList.add(parentTermMatrix);
        termMatrixList.add(childTermMatrix);
        termMatrixList.add(grandchildTermMatrix);
        insert termMatrixList;
        Phoenix_TermsMatrixList.getTermsMatrix(childTermMatrix.Id);
    }
    
    //Test class for TermMatrixOverride class
    static testmethod void TermMatrixOverrideMethod() {
        //creating accounts
        List < Account > accList = new List < Account > ();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account account1 = new Account(Name = 'Parent Account', RecordTypeId = phoenixRecordTypeId);
        Account account2 = new Account(Name = 'child Account', RecordTypeId = phoenixRecordTypeId, ParentId = account1.Id);
        accList.add(account1);
        accList.add(account2);
        insert accList;
        //creating Term matrixs
        List < Phoenix_Terms_Matrix__c > termMatrixList = new List < Phoenix_Terms_Matrix__c > ();
        Phoenix_Terms_Matrix__c termMatrix1 = new Phoenix_Terms_Matrix__c(Name = 'test matrix', Phoenix_Agreement_Name__c = 'test agreeent', Phoenix_Comments__c = 'test comment', Phoenix_Customer_Name__c = account2.Id, Phoenix_Is_Customer_Prepay__c = 'Yes');
        Phoenix_Terms_Matrix__c termMatrix2 = new Phoenix_Terms_Matrix__c(Name = 'test matrix2', Phoenix_Agreement_Name__c = 'test agreeent', Phoenix_Comments__c = 'test comment', Phoenix_Customer_Name__c = account2.Id, Phoenix_Is_Customer_Prepay__c = 'No', Phoenix_Check_Payment_Discount_Days__c = 8);
        Phoenix_Terms_Matrix__c termMatrix3 = new Phoenix_Terms_Matrix__c(Name = 'test matrix3', Phoenix_Agreement_Name__c = 'test agreeent', Phoenix_Comments__c = 'test comment', Phoenix_Customer_Name__c = account1.Id, Phoenix_Is_Customer_Prepay__c = 'Yes');
        termMatrixList.add(termMatrix1);
        termMatrixList.add(termMatrix2);
        termMatrixList.add(termMatrix3);
        insert termMatrixList;
        Phoenix_TermMatrixEditCtrl.getTermsMatrix(termMatrix1.Id);
        Phoenix_TermMatrixEditCtrl.getTermsMatrix(termMatrix2.Id);
        Phoenix_TermMatrixEditCtrl.getTermsMatrix(termMatrix3.Id);
    }
    
    static testmethod void BidCreatorOverrideMethod() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Phoenix_BidCreator.WrapperClass pbWrapper = new Phoenix_BidCreator.WrapperClass();
        pbWrapper = Phoenix_BidCreator.getbidInfo(pb.Id);
        
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'EST';
        update pb;
    }
    
    /*static testmethod void AddProductMethod(){
Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
Account testAccount = new Account(Name = 'Test Account');
insert testAccount;
list<Product2> prodList = new list<Product2>();
Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE);
Product2 prod2 = new Product2(Name = 'Test Product1', Family = 'Sample Family', IsActive = TRUE);
Product2 prod3 = new Product2(Name = 'Test Product2', Family = ' cetirizine', IsActive = TRUE);
prodList.add(prod1);
prodList.add(prod2);
prodList.add(prod3);
insert prodList;
Phoenix_Bid__c pb = new Phoenix_Bid__c();
pb.Phoenix_Status__c = 'New';
pb.Phoenix_Comments__c = 'Test Comments';
pb.Phoenix_Customer__c = testAccount.Id;
insert pb;
Phoenix_BidCreatorCtrl.BidWrapper pbWrapper = new Phoenix_BidCreatorCtrl.BidWrapper();
pbWrapper = Pheonix_AddQuoteLineItemsController.getBidInfo(pb.Id);


Phoenix_BidCreatorCtrl.BidWrapper pbWrapper1 = new Phoenix_BidCreatorCtrl.BidWrapper();
pbWrapper1.bid = pb;
pbWrapper1.isBidCreated = true;
Pheonix_AddQuoteLineItemsController.getproducts1(pbWrapper1);
Phoenix_BidCreatorCtrl.BidWrapper pb2= pbWrapper1;

list<Phoenix_BidCreatorCtrl.wrapperClass> wrap = new list<Phoenix_BidCreatorCtrl.wrapperClass>();
list<string> productIds = new list<string>();
for (Integer i = 0; i < prodList.size(); i++){
Phoenix_BidCreatorCtrl.wrapperClass pbw = new Phoenix_BidCreatorCtrl.wrapperClass();
pbw.prdlist = prodList[i];
pbw.isSelected = true;
pbw.currencyCode = '$';
wrap.add(pbw);
productIds.add(prodList[i].Id);

}
string search = 'test';
//	Pheonix_AddQuoteLineItemsController.getSearch(wrap, search);
Pheonix_AddQuoteLineItemsController.getSearch(wrap, search,productIds);

string searchFamily = 'test';
Pheonix_AddQuoteLineItemsController.getSearchFamily(wrap, searchFamily, productIds);
Pheonix_AddQuoteLineItemsController.getQuoteLineItems(productIds);


list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
for (Integer i = 0; i < prodList.size(); i++){
Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id);
lineItemsList.add(pbl);
}

Pheonix_AddQuoteLineItemsController.savequoteitems(wrap, pb2);
}*/
    
    static testmethod void testTermsMatrixHistory() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        List < Phoenix_Terms_Matrix__c > termMatrixList = new List < Phoenix_Terms_Matrix__c > ();
        Phoenix_Terms_Matrix__c termMatrix1 = new Phoenix_Terms_Matrix__c(Name = 'test matrix', Phoenix_Agreement_Name__c = 'test agreeent', Phoenix_Comments__c = 'test comment', Phoenix_Customer_Name__c = testAccount.Id, Phoenix_Is_Customer_Prepay__c = 'Yes');
        Phoenix_Terms_Matrix__c termMatrix2 = new Phoenix_Terms_Matrix__c(Name = 'test matrix2', Phoenix_Agreement_Name__c = 'test agreeent', Phoenix_Comments__c = 'test comment', Phoenix_Customer_Name__c = testAccount.Id, Phoenix_Is_Customer_Prepay__c = 'No', Phoenix_Check_Payment_Discount_Days__c = 8);
        Phoenix_Terms_Matrix__c termMatrix3 = new Phoenix_Terms_Matrix__c(Name = 'test matrix3', Phoenix_Agreement_Name__c = 'test agreeent', Phoenix_Comments__c = 'test comment', Phoenix_Customer_Name__c = testAccount.Id, Phoenix_Is_Customer_Prepay__c = 'Yes');
        termMatrixList.add(termMatrix1);
        termMatrixList.add(termMatrix2);
        termMatrixList.add(termMatrix3);
        insert termMatrixList;
        
        Id phoenixRecordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount1 = new Account(Name = 'Test Account');
        insert testAccount1;
        
        List < Phoenix_Terms_Matrix__c > newtermMatrixList = [SELECT Id, Phoenix_Agreement_Name__c
                                                              FROM Phoenix_Terms_Matrix__c
                                                              WHERE Id =: termMatrixList
                                                             ];
        for (Phoenix_Terms_Matrix__c termMatrix: newtermMatrixList) {
            termMatrix.Phoenix_Agreement_Name__c = 'updated agreement';
        }
        update newtermMatrixList;
        List < Phoenix_Terms_Matrix__c > newtermMatrixList1 = [SELECT Id, Phoenix_Agreement_Name__c
                                                               FROM Phoenix_Terms_Matrix__c
                                                               WHERE Id =: newtermMatrixList
                                                              ];
        for (Phoenix_Terms_Matrix__c termMatrix: newtermMatrixList1) {
            termMatrix.Phoenix_Customer_Name__c = testAccount1.Id;
            termMatrix.Phoenix_Customer_s_Agreement_Effective_D__c = system.today();
        }
        update newtermMatrixList1;
        Phoenix_Util.removeSymbolsFromString('IPA St.Lukeâ€\'\'s Hosp.-Upper Bucks Campus');
    }
    
    static testmethod void BidLineItemTrigger() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'Direct');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        insert pb;
        
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        insert bl;
    }
    
    static testmethod void BidTrigger1() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Select_Wholesaler__c = 'ABC';
        insert pb;
        Phoenix_Bid__c pb1 = [select id from Phoenix_Bid__c where Phoenix_Select_Wholesaler__c = 'ABC'];
        pb1.Phoenix_Select_Wholesaler__c = 'Cardinal';
        update pb1;
        
    }
    
    static testmethod void BidTrigger12() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Select_Wholesaler__c = 'Other';
        insert pb;
        Phoenix_Bid__c pb1 = [select id, Phoenix_Is_Re_Bid__c, Phoenix_Previous_Bid__c from Phoenix_Bid__c where Phoenix_Select_Wholesaler__c = 'Other'];
        pb1.Phoenix_Select_Wholesaler__c = 'McKesson';
        update pb1;
        
        Phoenix_Bid__c pb2 = new Phoenix_Bid__c();
        pb2.Phoenix_Status__c = 'New';
        pb2.Phoenix_Comments__c = 'Test Comments';
        pb2.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb2.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb2.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb2.Phoenix_Bid_Deadline_Date__c = System.today();
        pb2.Phoenix_Select_Wholesaler__c = 'Other';
        pb2.Phoenix_Is_Re_Bid__c = true;
        pb2.Phoenix_Previous_Bid__c = pb1.Id;
        insert pb2;
        Phoenix_Util.getTemplateBody('Bid_Approval_Request_Notification', pb1.Id);
        PhoenixBidTriggerHandler.getUltimateParent(new List < Phoenix_Bid__c > {
            pb1,
                pb2
                });
    }
    
    static testmethod void redirectClass() {
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        // pb.Phoenix_Customer__c = testAccount.Id;
        // pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Select_Wholesaler__c = 'ABC';
        insert pb;
        
        Phoenix_RedirectClass.getBid(pb.Id);
    }
    
    //method by Sai Krishna
    static testmethod void getRecordTypeDetails() {
        Phoenix_BidCreator.getRecordTypeDetails();
    }
    //method by Sai Krishna
    static testmethod void deleteAttachmentList() {
        list < id > delatableIdsList = new list < id > ();
        
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Type__c = 'Customer Rebate Change';
        insert bid;
        
        Phoenix_Bid_Line_Item__c rec = new Phoenix_Bid_Line_Item__c();
        rec.Phoenix_Current_Indirect_Selling_Unit__c = 50;
        rec.Phoenix_Bid__c = bid.Id;
        insert rec;
        delatableIdsList.add(rec.Id);
        
        
        Phoenix_BidCreator.deleteAttachmentList(delatableIdsList);
    }
    static testmethod void sortBidProcessSteps(){
        Phoenix_Util.sortBidProcessSteps([Select Id, Phoenix_Sub_Step__c, Phoenix_Step__c FROM Phoenix_Bid_Process_Steps__c limit 2]);
    }
}