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
public class Phoenix_OfferGenerationDocumentClsTest {
    @isTest static void testMethod1() {
        list < Product2 > prodList = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2', Phoenix_Rx_SRx_OTC__c = 'SRx', Phoenix_Special_Product__c = true, Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3', Phoenix_Rx_SRx_OTC__c = 'OTC', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;   
        
        
        Phoenix_WAC_Change__c testWAC = new Phoenix_WAC_Change__c();
        testWAC.Phoenix_WAC_Change_Name__c = 'Test WAC';
        testWAC.Phoenix_Product_Family__c = 'Test Family';
        testWAC.Phoenix_Sales_Increase__c = 10;
        testWAC.Phoenix_Medicaid_release__c = 20;
        testWAC.Phoenix_PHS_hit__c = 30;
        testWAC.Phoenix_WAC_finance_impact__c = 40;
        testWAC.Working_capital_benefit__c = 50;
     //   testWAC.Phoenix_Approval_Status__c = 'Marketing Head Rejected';
        insert testWAC;
        
        list < Phoenix_WAC_Change_Line_Item__c > lineItemsList = new list < Phoenix_WAC_Change_Line_Item__c > ();
        Phoenix_WAC_Change_Line_Item__c pbl1=new Phoenix_WAC_Change_Line_Item__c();
        pbl1.Phoenix_WAC_Change__c=testWAC.Id;
        pbl1.Phoenix_Product__c=prod1.Id;
        //pbl1.Phoenix_Final_Status__c = 'Approved';
        lineItemsList.add(pbl1);
        
        Phoenix_WAC_Change_Line_Item__c pbl2=new Phoenix_WAC_Change_Line_Item__c();
        pbl2.Phoenix_WAC_Change__c=testWAC.Id;
        pbl2.Phoenix_Product__c=prod2.Id;
		//pbl2.Phoenix_Final_Status__c = 'Approved'; 
        
        lineItemsList.add(pbl2);
        
        insert lineItemsList;
        
        Phoenix_NDC_Change__c testNDC=new Phoenix_NDC_Change__c();
        testNDC.Phoenix_Approval_Status__c='Draft';   
        testNDC.Phoenix_NDC_Change_Name__c    ='testRecord';
        testNDC.Phoenix_Current_Product_Family__c=prodList[0].Family;
        testNDC.Phoenix_Proposed_Product_Family__c=prodList[1].Family;
        insert testNDC;
        
         Phoenix_NDC_Change__c testNDC1=new Phoenix_NDC_Change__c();
        testNDC1.Phoenix_Approval_Status__c='Draft';   
        testNDC1.Phoenix_NDC_Change_Name__c    ='testRecord';
        testNDC1.Phoenix_Current_Product_Family__c=prodList[0].Family;
        testNDC1.Phoenix_Proposed_Product_Family__c=prodList[1].Family;
        insert testNDC1;
        
        list<Phoenix_NDC_Change_Product__c>ndcProductList=new list<Phoenix_NDC_Change_Product__c>();
        list<Phoenix_NDC_Change_Product__c>ndcProductList1=new list<Phoenix_NDC_Change_Product__c>();
        Phoenix_NDC_Change_Product__c ndcChangeProduct=new Phoenix_NDC_Change_Product__c();
        ndcChangeProduct.Phoenix_NDC_Change_Name__c=testNDC.Id;
        ndcChangeProduct.Phoenix_Current_Product__c=prod1.Id;
        ndcChangeProduct.Phoenix_Proposed_Product__c=prod2.Id;
        insert ndcChangeProduct;
        
        Phoenix_NDC_Change_Product__c ndcChangeProduct1=new Phoenix_NDC_Change_Product__c();
        ndcChangeProduct1.Phoenix_NDC_Change_Name__c=testNDC1.Id;
        ndcChangeProduct1.Phoenix_Current_Product__c=prod1.Id;
        ndcChangeProduct1.Phoenix_Proposed_Product__c=prod2.Id;
        insert ndcChangeProduct1;
        
        list < Phoenix_NDC_Change_Line_Item__c > lineItemsList2 = new list < Phoenix_NDC_Change_Line_Item__c > ();
        list < Phoenix_NDC_Change_Line_Item__c > lineItemsList3 = new list < Phoenix_NDC_Change_Line_Item__c > ();
        Phoenix_NDC_Change_Line_Item__c ndcpbl1=new Phoenix_NDC_Change_Line_Item__c();
        ndcpbl1.Phoenix_NDC_Change__c=testNDC.Id;
        ndcpbl1.Phoenix_NDC_Change_Product__c=ndcChangeProduct.Id;
        ndcpbl1.Phoenix_Current_Product__c = prod1.id;
        ndcpbl1.Phoenix_Proposed_Product__c = prod2.id;
        
        Phoenix_NDC_Change_Line_Item__c ndcpbl11=new Phoenix_NDC_Change_Line_Item__c();
        ndcpbl11.Phoenix_NDC_Change__c=testNDC1.Id;
        ndcpbl11.Phoenix_NDC_Change_Product__c=ndcChangeProduct1.Id;
        ndcpbl11.Phoenix_Current_Product__c = prod1.id;
        ndcpbl11.Phoenix_Proposed_Product__c = prod2.id;
        ndcpbl11.Phoenix_Final_Status__c = 'Not Approved';
        lineItemsList2.add(ndcpbl11);
        lineItemsList3.add(ndcpbl1);
        Phoenix_NDC_Change_Line_Item__c ndcpbl2=new Phoenix_NDC_Change_Line_Item__c();
        ndcpbl2.Phoenix_NDC_Change__c=testNDC.Id;
        ndcpbl2.Phoenix_NDC_Change_Product__c=ndcChangeProduct.Id;
        ndcpbl2.Phoenix_Current_Product__c = prod1.id;
        ndcpbl2.Phoenix_Proposed_Product__c = prod2.id;
        lineItemsList2.add(ndcpbl2);
        
        Phoenix_NDC_Change_Line_Item__c ndcpbl21=new Phoenix_NDC_Change_Line_Item__c();
        ndcpbl21.Phoenix_NDC_Change__c=testNDC1.Id;
        ndcpbl21.Phoenix_NDC_Change_Product__c=ndcChangeProduct1.Id;
        ndcpbl21.Phoenix_Current_Product__c = prod1.id;
        ndcpbl21.Phoenix_Proposed_Product__c = prod2.id;
        ndcpbl21.Phoenix_Final_Status__c = 'Not Approved';
        lineItemsList3.add(ndcpbl21);
        
        insert lineItemsList2;
        insert lineItemsList3;
        
        
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Approval_Status__c = 'Draft';
        insert pb;
        Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
        insert p2;
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
        p3.Phoenix_Product_Director__c = UserInfo.getUserId();
        insert p3;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Product_Code1__c = '300029858';
        bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = p2.Id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl.Phoenix_Marketing_Final_Approval__c = true;
        insert bl;
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert bl1;
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Final_Status__c = 'Approved';
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = p3.Id;
        bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bl2.Phoenix_Marketing_Final_Approval__c = true;
        insert bl2;
        Boolean isCustSpecific = true;
        Phoenix_OfferGenerationDocumentCls.generateDocument(pb.Id, 'bidTemplate', 'Offer-Bid-0002150-AmerisourceBergen Drug Corp.-RFP Bids-8/5/2021', 'All','Bid Template',pb.Phoenix_Customer__r.Id);
        Phoenix_OfferGenerationDocumentCls.generateDocument(pb.Id, 'bidTemplate', 'Offer-Bid-0002150-AmerisourceBergen Drug Corp.-RFP Bids-8/5/2021', 'All','NDC Change',pb.Phoenix_Customer__r.Id);
        
        Phoenix_OfferGenerationDocumentCls.getOfferTemplates(pb.Phoenix_Customer__r.Id, pb.Id);
      
        Phoenix_OfferGenerationDocumentCls.getNDCOfferTemplates(testNDC.Id);    
        
        
    }
}