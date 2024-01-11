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
public class Phoenix_CompactViewTest {
    @isTest static void testCompactView() {
        Account testAccount = new Account(Name = 'Test Acc');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Approval_Status__c = 'Draft';
        insert pb;
        Product_Family__c pf = new Product_Family__c();
        pf.Name = 'Daptomycin Inj 500mg US';
        insert pf;
        Product_Family__c pf2 = new Product_Family__c();
        pf2.Name = 'Abiraterone Acetate Tab';
        insert pf2;
        Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
        p2.Product_Family__c = pf.Id;
        insert p2;
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
        p3.Product_Family__c = pf2.Id;
        insert p3;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Product__c = p2.Id;
        bl.Product_Family__c = pf.Id;
        insert bl;
        Phoenix_CompactView.getScmData(pb.id);
    }
}