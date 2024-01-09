@IsTest
public class Phoenix_AwardedQtycontrollerTest {
    
    Public static testMethod void validateSampleApex() {
        try {
            list < id > BidLineId = new list < id > ();
            list < id > bidLIIdList = new list < id > ();
            list < id > idlist = new list < id > ();
            set < id > idSet = new set < id > ();
            set < id > newId = new set < id > ();

            Phoenix_Bid__c bid = new Phoenix_Bid__c();
            bid.Phoenix_Bid_Type__c = 'Customer Rebate Change';
            insert bid;
            Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
            ps.Phoenix_Approver__c = userInfo.getUserId();
            ps.Phoenix_Bid__c = bid.Id;
            insert ps;

            Phoenix_Customer_Response__c cures = new Phoenix_Customer_Response__c();
            cures.Phoenix_Bid_No__c = bid.Id;
            cures.Phoenix_Affected_Contract_s__c='100,200,300';
            insert cures;

            list < Phoenix_Bid_Line_Item__c > crliAddedBidLIIdSet = new list < Phoenix_Bid_Line_Item__c > ();
            Phoenix_Customer_Response_Line__c rec1 = new Phoenix_Customer_Response_Line__c();
            rec1.Phoenix_Awarded_Quantity__c = 5999;
            //rec1.Phoenix_Customer_Response__c = bid.Id;
            insert rec1;
            idlist.add(rec1.Id);


            Phoenix_Customer_Response_Line__c rec2 = new Phoenix_Customer_Response_Line__c();
            rec2.Phoenix_Awarded_Quantity__c = 210;
            rec1.Phoenix_Customer_Response__c = bid.Id;
            insert rec2;
            idlist.add(rec2.Id);

            Phoenix_Customer_Response_Line__c rec3 = new Phoenix_Customer_Response_Line__c();
            rec3.Phoenix_Awarded_Quantity__c = 99;
            rec3.Phoenix_Customer_Response__c=cures.id;
            rec3.Phoenix_Award_Position__c='Primary';
            insert rec3;
            idlist.add(rec3.Id);

            Phoenix_Customer_Response_Line__c rec4 = new Phoenix_Customer_Response_Line__c();
            rec4.Phoenix_Awarded_Quantity__c = 499;
            insert rec4;
            idlist.add(rec4.Id);

            Phoenix_Customer_Response_Line__c rec5 = new Phoenix_Customer_Response_Line__c();
            rec5.Phoenix_Awarded_Quantity__c = 08;
            insert rec5;
            bidLIIdList.add(rec5.Id);

            Phoenix_Customer_Response_Line__c rec6 = new Phoenix_Customer_Response_Line__c();
            rec6.Phoenix_Awarded_Quantity__c = 09;
            insert rec6;
            bidLIIdList.add(rec6.Id);

            Phoenix_Bid_Line_Item__c rec7 = new Phoenix_Bid_Line_Item__c();
            rec7.Phoenix_Current_Indirect_Selling_Unit__c = 00;
            rec7.Phoenix_Bid__c = bid.Id;
            insert rec7;
            //BidLineId.add(rec7.Id);     



            Account acc = new Account();
            Test.StartTest();



            //Phoenix_CustomerResponseViewController.deleteSelectedLineItems(bidLIIdList);
            list < Phoenix_Bid_Line_Item__c > bidLineRecords = [select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name, Phoenix_Bid__r.Phoenix_Bid_Name__c from Phoenix_Bid_Line_Item__c WHERE  Phoenix_Bid__c =:bid.Id];
            list < Phoenix_Customer_Response_Line__c > listRes = [select id, Name, Phoenix_Awarded_Quantity__c from Phoenix_Customer_Response_Line__c];
            list < Phoenix_Customer_Response_Line__c > recordList = [select id, Name, Phoenix_Awarded_Quantity__c from Phoenix_Customer_Response_Line__c where Phoenix_Awarded_Quantity__c = 210];
            //Phoenix_CustomerResponseViewController.createCRLineItems(bidLineRecords, rec6.Id);
            //Phoenix_CustomerResponseViewController.isCustomerResponseSubmitted(rec6.Id);
            //list<Phoenix_Customer_Response_Line__c> CustomerResponseList=[select id,Name,Phoenix_Awarded_Quantity__c from Phoenix_Customer_Response_Line__c where Id IN : idlist];
            //Phoenix_CustomerResponseViewController.updateCRLIRealatedBidLI(CustomerResponseList,rec7.Id);




            string uniqueId = rec2.id;
            idSet.add(uniqueId);
            list < Phoenix_Customer_Response_Line__c > responseList = [select id, Name, Phoenix_Awarded_Quantity__c from Phoenix_Customer_Response_Line__c where Phoenix_Awarded_Quantity__c = 499];
            list<Phoenix_Awarded_Quantity__c> lst;
            
         /*   Phoenix_Awarded_Quantity__c aq=new Phoenix_Awarded_Quantity__c();
            aq.Phoenix_Awarded_Quantity__c=100;
            lst.add(aq);
            insert aq;
          */  
            
            Phoenix_AwardedQtycontroller.getPositions(rec3.id);
            //Phoenix_AwardedQtycontroller.updateAccount(lst);
            Phoenix_AwardedQtycontroller.getTotalQtyData(rec3.id);
            Phoenix_AwardedQtycontroller.getPicklistValues(rec3.id);
            //Phoenix_CustomerResponseViewController.updateCRLIRealatedBidLI(responseList,rec7.Id);
           // Phoenix_AwardedQtycontroller.updateAccount(new List<Phoenix_Awarded_Quantity__c>{aq});
            Test.StopTest();
        } catch (Exception e) {
            system.debug('Exception ' + e);
            system.debug('Exception Line Number' + e.getLineNumber());
            system.debug('Exception cause' + e.getCause());
        }

    }
  Public static testMethod void validateSampleApex2() {
        try {
            list < id > BidLineId = new list < id > ();
            list < id > bidLIIdList = new list < id > ();
            list < id > idlist = new list < id > ();
            set < id > idSet = new set < id > ();
            set < id > newId = new set < id > ();

            Phoenix_Bid__c bid = new Phoenix_Bid__c();
            bid.Phoenix_Bid_Type__c = 'Customer Rebate Change';
            insert bid;
            Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
            ps.Phoenix_Approver__c = userInfo.getUserId();
            ps.Phoenix_Bid__c = bid.Id;
            insert ps;

            Phoenix_Customer_Response__c cures = new Phoenix_Customer_Response__c();
            cures.Phoenix_Bid_No__c = bid.Id;
           // cures.Phoenix_Affected_Contract_s__c='100,200,300';
            insert cures;

            list < Phoenix_Bid_Line_Item__c > crliAddedBidLIIdSet = new list < Phoenix_Bid_Line_Item__c > ();
            Phoenix_Customer_Response_Line__c rec1 = new Phoenix_Customer_Response_Line__c();
            rec1.Phoenix_Awarded_Quantity__c = 5999;
            //rec1.Phoenix_Customer_Response__c = bid.Id;
            insert rec1;
            idlist.add(rec1.Id);


            Phoenix_Customer_Response_Line__c rec2 = new Phoenix_Customer_Response_Line__c();
            rec2.Phoenix_Awarded_Quantity__c = 210;
            rec1.Phoenix_Customer_Response__c = bid.Id;
            insert rec2;
            idlist.add(rec2.Id);

            Phoenix_Customer_Response_Line__c rec3 = new Phoenix_Customer_Response_Line__c();
            rec3.Phoenix_Awarded_Quantity__c = 99;
            rec3.Phoenix_Customer_Response__c=cures.id;
            rec3.Phoenix_Award_Position__c='Primary';
            insert rec3;
            idlist.add(rec3.Id);

            Phoenix_Customer_Response_Line__c rec4 = new Phoenix_Customer_Response_Line__c();
            rec4.Phoenix_Awarded_Quantity__c = 499;
            insert rec4;
            idlist.add(rec4.Id);

            Phoenix_Customer_Response_Line__c rec5 = new Phoenix_Customer_Response_Line__c();
            rec5.Phoenix_Awarded_Quantity__c = 08;
            insert rec5;
            bidLIIdList.add(rec5.Id);

            Phoenix_Customer_Response_Line__c rec6 = new Phoenix_Customer_Response_Line__c();
            rec6.Phoenix_Awarded_Quantity__c = 09;
            insert rec6;
            bidLIIdList.add(rec6.Id);

            Phoenix_Bid_Line_Item__c rec7 = new Phoenix_Bid_Line_Item__c();
            rec7.Phoenix_Current_Indirect_Selling_Unit__c = 00;
            rec7.Phoenix_Bid__c = bid.Id;
            //rec7.ConNo='test';
            
            insert rec7;
            //BidLineId.add(rec7.Id);     



            Account acc = new Account();
            Test.StartTest();



            //Phoenix_CustomerResponseViewController.deleteSelectedLineItems(bidLIIdList);
            list < Phoenix_Bid_Line_Item__c > bidLineRecords = [select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name, Phoenix_Bid__r.Phoenix_Bid_Name__c from Phoenix_Bid_Line_Item__c WHERE  Phoenix_Bid__c =:bid.Id];
            list < Phoenix_Customer_Response_Line__c > listRes = [select id, Name, Phoenix_Awarded_Quantity__c from Phoenix_Customer_Response_Line__c];
            list < Phoenix_Customer_Response_Line__c > recordList = [select id, Name, Phoenix_Awarded_Quantity__c from Phoenix_Customer_Response_Line__c where Phoenix_Awarded_Quantity__c = 210];
            //Phoenix_CustomerResponseViewController.createCRLineItems(bidLineRecords, rec6.Id);
            //Phoenix_CustomerResponseViewController.isCustomerResponseSubmitted(rec6.Id);
            //list<Phoenix_Customer_Response_Line__c> CustomerResponseList=[select id,Name,Phoenix_Awarded_Quantity__c from Phoenix_Customer_Response_Line__c where Id IN : idlist];
            //Phoenix_CustomerResponseViewController.updateCRLIRealatedBidLI(CustomerResponseList,rec7.Id);




            string uniqueId = rec2.id;
            idSet.add(uniqueId);
            list < Phoenix_Customer_Response_Line__c > responseList = [select id, Name, Phoenix_Awarded_Quantity__c from Phoenix_Customer_Response_Line__c where Phoenix_Awarded_Quantity__c = 499];
            list<Phoenix_Awarded_Quantity__c> lst;
            
         /*   Phoenix_Awarded_Quantity__c aq=new Phoenix_Awarded_Quantity__c();
            aq.Phoenix_Awarded_Quantity__c=100;
            lst.add(aq);
            insert aq;
          */  
            
            Phoenix_AwardedQtycontroller.getPositions(rec3.id);
            //Phoenix_AwardedQtycontroller.updateAccount(lst);
            Phoenix_AwardedQtycontroller.getTotalQtyData(rec3.id);
            Phoenix_AwardedQtycontroller.getPicklistValues(rec3.id);
            //Phoenix_CustomerResponseViewController.updateCRLIRealatedBidLI(responseList,rec7.Id);
            Phoenix_AwardedQtycontroller.updateAccount(new List<Phoenix_Awarded_Quantity__c>{});
            
            Test.StopTest();
        } catch (Exception e) {
            system.debug('Exception ' + e);
            system.debug('Exception Line Number' + e.getLineNumber());
            system.debug('Exception cause' + e.getCause());
        }

    }

}