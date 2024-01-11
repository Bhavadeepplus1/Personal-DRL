@isTest(SeeAllData=true)
public class Phoenix_OTCMDMViewClsTest {
    @isTest static void testMDMView() {
        Account acc = new Account();
        acc.Name = 'test account';
        insert acc;
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c ='test bid';
        bid.Phoenix_Customer__c= acc.Id;
        insert bid;
        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Bid__c= bid.Id;
        insert bidLine;
        Phoenix_Bid_Action_Item__c actionItem = new Phoenix_Bid_Action_Item__c();
        actionItem.Phoenix_Account__c = acc.Id;
        actionItem.Phoenix_Bid_Line_Item__c=bidLine.Id;
        actionItem.Phoenix_Bid__c=bid.id;
        insert actionItem;
        Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
        bisp.Name = 'Customer\'s Update';
        bisp.Phoenix_Bid__c = bid.Id;
        bisp.Phoenix_Approver__c = Userinfo.getUserId();
        bisp.Phoenix_Approver_Team__c = 'OTC Sales';
        //bisp.Phoenix_Process_Step__c = approvalSteps[0].Id;
        insert bisp;
		Group grp = new Group();
        grp.Type = 'Regular';
        grp.Name ='admin Users';
        Insert grp;
        Phoenix_OTCMDMViewCls.getBidActionItems(bid.Id);
        Phoenix_OTCMDMViewCls.submitProductCodes(bid.Id);
        Phoenix_OTCMDMViewCls.updateLineItem(actionItem,bid.Id);
    }

}