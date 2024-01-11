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
public class Phoenix_IPARejectedLineItemsClsTest {
    static testmethod void Phoenix_IPARejectedLineItemsClsTestMethod() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list < Product2 > prodList = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_IPA_Floor_Price__c = 20, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2', Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3', Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE);

        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Contracts_Approval__c = 'Processed';
        pb.Phoenix_Contracts_Approval_Comments__c = 'Comments';
        insert pb;
        list < Phoenix_Bid_Line_Item__c > lineItemsList = new list < Phoenix_Bid_Line_Item__c > ();
        for (Integer i = 0; i < prodList.size(); i++) {
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Vistex_Status__c = 'Updated', Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved', Phoenix_Contract_Approval__c = 'Sent to Customer', Phoenix_Marketing_Approval__c = 'Approved', Phoenix_Bid__c = pb.Id, Phoenix_Product_Director1__c = UserInfo.getUserId(), Phoenix_Product__c = prodList[i].Id, Phoenix_Proposed_IPA_Price__c = 100, Phoenix_IDN_Usage__c = 10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        Phoenix_IPARejectedLineItemsCls.getRelatedList(pb.Id);
        Phoenix_IPARejectedLineItemsCls.saveLineItems(lineItemsList);
        Phoenix_IPARejectedLineItemsCls.deleteLineItems(lineItemsList[0].Id);


    }
}