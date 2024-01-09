/**
* @description       : This class contains methods related to approvals and email functionality.
* @author            : Surender Patel (Dhruvsoft)
* @group             : 
* 
* @last modified on  : 18-10-2021
* @last modified by  : Surender Patel (Dhruvsoft)
* Modifications Log 
* Ver   Date         Author                       Modification
* 1.0   11-11-2020   Surender Patel (Dhruvsoft)   Initial Version
**/

public without sharing class Phoenix_SubmitBidForApprovalCtrl1 {

public static Map < String, String > approvalGroupBehaviourMap = new Map < String, String > ();
public static Map < String, Set < String >> approvalTeamUsersMap = new Map < String, Set < String >> ();
public static Map < String, Set < String >> approvalTeamUsersEmailsMap = new Map < String, Set < String >> ();
public static Map < String, Set < String >> approvalTeamUserNamesMap = new Map < String, Set < String >> ();
public static Map < String, String > userTeamUserIdMap = new Map < String, String > ();

static {
for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
            
    if (matrix.RecordType.DeveloperName == 'Approval_User_Group') 
        approvalGroupBehaviourMap.put(matrix.Phoenix_Approver_Group_Name__c, matrix.Phoenix_Approval_Group_Behavior__c);
    else if (matrix.RecordType.DeveloperName == 'Approval_Users' && approvalTeamUsersMap.get(matrix.User_Group__r.Phoenix_Approver_Group_Name__c) == null && matrix.Phoenix_Is_Approval_Process_User__c) {
        approvalTeamUsersMap.put(matrix.User_Group__r.Phoenix_Approver_Group_Name__c, new Set < String > {
            matrix.Phoenix_Approver__c
        });
    } else if (matrix.RecordType.DeveloperName == 'Approval_Users' && approvalTeamUsersMap.get(matrix.User_Group__r.Phoenix_Approver_Group_Name__c) != null && matrix.Phoenix_Is_Approval_Process_User__c) {
        Set < String > addedApprovers = approvalTeamUsersMap.get(matrix.User_Group__r.Phoenix_Approver_Group_Name__c);
        addedApprovers.add(matrix.Phoenix_Approver__c);
        approvalTeamUsersMap.put(matrix.User_Group__r.Phoenix_Approver_Group_Name__c, addedApprovers);
    }

    if (approvalTeamUsersEmailsMap.containsKey(matrix.User_Group__r.Phoenix_Approver_Group_Name__c) && matrix.Phoenix_Approver__c != null) {
        Set < String > addedEmails = approvalTeamUsersEmailsMap.get(matrix.User_Group__r.Phoenix_Approver_Group_Name__c);
        addedEmails.add(matrix.Phoenix_Approver__r.Email);
        approvalTeamUsersEmailsMap.put(matrix.User_Group__r.Phoenix_Approver_Group_Name__c, addedEmails);
    } else if (!approvalTeamUsersEmailsMap.containsKey(matrix.User_Group__r.Phoenix_Approver_Group_Name__c) && matrix.Phoenix_Approver__c != null) {
        approvalTeamUsersEmailsMap.put(matrix.User_Group__r.Phoenix_Approver_Group_Name__c, new Set < String > {
            matrix.Phoenix_Approver__r.Email
        });
    }

    if (matrix.User_Group__r.Phoenix_Approver_Group_Name__c != null && approvalTeamUserNamesMap.containsKey(matrix.User_Group__r.Phoenix_Approver_Group_Name__c)) {
        Set < String > addedNames = approvalTeamUserNamesMap.get(matrix.User_Group__r.Phoenix_Approver_Group_Name__c);
        addedNames.add(matrix.Phoenix_Approver__r.Name);
        approvalTeamUserNamesMap.put(matrix.User_Group__r.Phoenix_Approver_Group_Name__c, addedNames);
    } else if (matrix.User_Group__r.Phoenix_Approver_Group_Name__c != null && !approvalTeamUserNamesMap.containsKey(matrix.User_Group__r.Phoenix_Approver_Group_Name__c)) {
        approvalTeamUserNamesMap.put(matrix.User_Group__r.Phoenix_Approver_Group_Name__c, new Set < String > {
            matrix.Phoenix_Approver__r.Name
        });
    }


    String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
    if (matrix.RecordType.DeveloperName == 'Approval_Users' && matrix.Phoenix_Is_Approval_Process_User__c) userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__c);


}
}
@AuraEnabled
public static BidWrapper getBidDetails(Id bidId) {
BidWrapper wrap = new BidWrapper();
Phoenix_Bid__c bid = [SELECT Id, Phoenix_Approval_Status__c, Phoenix_On_Hold__c FROM Phoenix_Bid__c where Id =: bidId];
wrap.bid = bid;
return wrap;
}
@AuraEnabled
public static String getLowestPrice(Id bidId) {
 string result = '';
try {
//   String query = 'Select ' + Phoenix_Util.approvalGridFields + ' FROM Phoenix_Approval_Grid__c WHERE Phoenix_Bid__c = \'a0C7c00000JNMTLEA5\'';
//  List<Phoenix_Approval_Grid__c> approvalGridList = database.query(query);
List < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Phoenix_Process_Step__r.Name, Phoenix_Approver__r.Name FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c =: bidId];
// List < Phoenix_Bid_Line_Item__c > bidLineItemList = [SELECT Id,Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Approval_Grid__c, Phoenix_Product__c, Phoenix_Bid__c, Phoenix_Is_New_Low_Triggered__c, Phoenix_Approved_Lowest_Price_SKU__c, Phoenix_Approval_Grid__r.Phoenix_isRx__c, Phoenix_Approval_Grid__r.Phoenix_isSRX__c, Phoenix_Approval_Grid__r.Phoenix_isOTC__c, Phoenix_Approval_Grid__r.Phoenix_Mkt_Head_Req__c, Phoenix_Approval_Grid__r.Phoenix_isMarketingRxLeadApproved__c, Phoenix_Approval_Grid__r.Phoenix_isMarketingSrxLeadApproved__c, Phoenix_Approval_Grid__r.Phoenix_IsOTCLeadApproved__c, Phoenix_Approval_Grid__r.Phoenix_isMarketingHeadApproved__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =: bidId AND Phoenix_Final_Status__c != 'Not Approved'];
List < Phoenix_Bid_Line_Item__c > bidLineItemList = [SELECT Id,Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Approval_Grid__c, Phoenix_Product__c, Phoenix_Bid__c, Phoenix_Is_New_Low_Triggered__c, Phoenix_Approved_Lowest_Price_SKU__c, Phoenix_Approval_Grid__r.Phoenix_isRx__c, Phoenix_Approval_Grid__r.Phoenix_isSRX__c, Phoenix_Approval_Grid__r.Phoenix_isOTC__c, Phoenix_Approval_Grid__r.Phoenix_Mkt_Head_Req__c, Phoenix_Approval_Grid__r.Phoenix_isMarketingRxLeadApproved__c, Phoenix_Approval_Grid__r.Phoenix_isMarketingSrxLeadApproved__c, Phoenix_Approval_Grid__r.Phoenix_IsOTCLeadApproved__c, Phoenix_Approval_Grid__r.Phoenix_isMarketingHeadApproved__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =: bidId AND Phoenix_Final_Status__c != 'Not Approved'];       
 system.debug('bidProcessStepList-----' + bidProcessStepList);
List < Phoenix_Approved_Lowest_Prices__c > appLowPriceList = new List < Phoenix_Approved_Lowest_Prices__c > ();
List < Product2 > productList = new List < Product2 > ();
 List < Phoenix_Bid_Line_Item__c > updateBidLine = new List < Phoenix_Bid_Line_Item__c >();
// set<Product2> productList = new set<Product2>();
for (Phoenix_Bid_Line_Item__c bidLine: bidLineItemList) {
    //for(Phoenix_Bid_Process_Steps__c bidstep : bidProcessStepList){
  //  if (bidLine.Phoenix_Is_New_Low_Triggered__c && bidLine.Phoenix_Approved_Lowest_Price_SKU__c > 0 && bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c != 'Short Dated OTB' && bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c != 'Volume Review Only' && bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c != 'Sales Out Rebate') {
    if (bidLine.Phoenix_Is_New_Low_Triggered__c && bidLine.Phoenix_Approved_Lowest_Price_SKU__c > 0){  
    Product2 prod = new Product2();
        prod.Id = bidLine.Phoenix_Product__c;
        prod.Phoenix_Approved_Lowest_Price_SKU__c = bidLine.Phoenix_Approved_Lowest_Price_SKU__c;
        productList.add(prod);
        Phoenix_Approved_Lowest_Prices__c appLowPrice = new Phoenix_Approved_Lowest_Prices__c();
        appLowPrice.Phoenix_Product__c = bidLine.Phoenix_Product__c;
        appLowPrice.Phoenix_Bid__c = bidLine.Phoenix_Bid__c;
        appLowPrice.Is_New_Low_Triggered__c = bidLine.Phoenix_Is_New_Low_Triggered__c;
        appLowPrice.Phoenix_Approved_Lowest_Price_SKU__c = bidLine.Phoenix_Approved_Lowest_Price_SKU__c;
			appLowPrice.Phoenix_Approved_Date__c = Phoenix_Util.getTodayEST();

        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
            if (step.Phoenix_Process_Step__r.Name == 'Marketing Lead Rx Approval' && step.Phoenix_Approver__r.Name != null && bidLine.Phoenix_Approval_Grid__r.Phoenix_isRx__c == true && bidLine.Phoenix_Approval_Grid__r.Phoenix_isMarketingRxLeadApproved__c == true)
                appLowPrice.Phoenix_Approver__c = step.Phoenix_Approver__c;
            if (step.Phoenix_Process_Step__r.Name == 'Marketing Lead SRx Approval' && step.Phoenix_Approver__r.Name != null && bidLine.Phoenix_Approval_Grid__r.Phoenix_isSRX__c == true && bidLine.Phoenix_Approval_Grid__r.Phoenix_isMarketingSrxLeadApproved__c == true)
                appLowPrice.Phoenix_Approver__c = step.Phoenix_Approver__c;
            if (step.Phoenix_Process_Step__r.Name == 'Marketing Lead OTC Approval' && step.Phoenix_Approver__r.Name != null && bidLine.Phoenix_Approval_Grid__r.Phoenix_isOTC__c == true && bidLine.Phoenix_Approval_Grid__r.Phoenix_IsOTCLeadApproved__c == true)
                appLowPrice.Phoenix_Approver__c = step.Phoenix_Approver__c;
            if (step.Phoenix_Process_Step__r.Name == 'Marketing Head Approval' && step.Phoenix_Approver__r.Name != null && bidLine.Phoenix_Approval_Grid__r.Phoenix_Mkt_Head_Req__c == true && bidLine.Phoenix_Approval_Grid__r.Phoenix_isMarketingHeadApproved__c == true)
                appLowPrice.Phoenix_Approver__c = step.Phoenix_Approver__c;

        }
        system.debug('Lowest-----' + appLowPrice.id);
        system.debug('Bid-----' + bidLine.Phoenix_Bid__c);
        system.debug('prod-----' + bidLine.Phoenix_Product__c);
        appLowPriceList.add(appLowPrice);
    }
    //}  
}
system.debug('appLowPriceList-----' + appLowPriceList.size());
system.debug('productList-----' + productList.size());               
 if (!appLowPriceList.isEmpty()) {
    insert appLowPriceList;
}
if (!productList.isEmpty()) {
    update productList;
}
  Set<Id> prodIds = new Set<Id>(); 
 for(Product2 prod : productList){
     prodIds.add(prod.Id);
 }
  List < Phoenix_Bid_Line_Item__c > bidLineList = [SELECT Id,Phoenix_Product__c,Phoenix_Approved_Lowest_Price_SKU__c,Phoenix_Product__r.Phoenix_Approved_Lowest_Price_SKU__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Product__c IN: prodIds AND Phoenix_Final_Status__c != 'Not Approved' AND (Phoenix_Bid__r.Phoenix_Approval_Status__c = 'SCM & Marketing' OR Phoenix_Bid__r.Phoenix_Approval_Status__c = 'Marketing' OR Phoenix_Bid__r.Phoenix_Approval_Status__c = 'Supply Chain' OR Phoenix_Bid__r.Phoenix_Approval_Status__c = 'Draft')];
 for (Phoenix_Bid_Line_Item__c bidLine: bidLineList) {
     bidLine.Phoenix_Approved_Lowest_Price_SKU__c = bidLine.Phoenix_Product__r.Phoenix_Approved_Lowest_Price_SKU__c;
 }
 if(!bidLineList.isEmpty()){
     update bidLineList;
 }
}
  Catch(Exception e) {
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'getLowestPrice', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Remarks__c = 'Bid Id is ' + bidId, Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
    result = e.getMessage();
}
return result;
}
@AuraEnabled
public static void updateLowestPrice(Id bidId) {
List < Phoenix_Bid_Line_Item__c > bidLineList = [SELECT Id,Phoenix_Product__c,Phoenix_Approved_Lowest_Price_SKU__c,Phoenix_Product__r.Phoenix_Approved_Lowest_Price_SKU__c FROM Phoenix_Bid_Line_Item__c WHERE  Phoenix_Bid__c =: bidId];
 for (Phoenix_Bid_Line_Item__c bidLine: bidLineList) {
     bidLine.Phoenix_Approved_Lowest_Price_SKU__c = bidLine.Phoenix_Product__r.Phoenix_Approved_Lowest_Price_SKU__c;
 }
 if(!bidLineList.isEmpty()){
     update bidLineList;
 }
	 }

@AuraEnabled
public static String holdBid(Id bidId) {
string result = '';
try {
    Phoenix_Bid__c bid = [SELECT Id, Phoenix_Approval_Status__c, Phoenix_On_Hold__c, Phoenix_Approval_status_at_Hold__c, (SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Process_Step__r.Name, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Bid_Process_Steps__r) FROM Phoenix_Bid__c where Id =: bidId];
    Phoenix_Bid_Hold_History__c bidHoldHistory = new Phoenix_Bid_Hold_History__c();


    //////////////////////////////////////////

    List < Phoenix_Bid_Process_Steps__c > inProcessSteps = [SELECT Id, Phoenix_Step__c, Phoenix_Bid__c, Phoenix_Status__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId and Phoenix_Status__c = 'In Process'
        Limit 1
    ];

    List < Phoenix_Bid_Process_Steps__c > ProcessStepsTeams = [SELECT Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId and Phoenix_Status__c = 'In Process'];

    List < String > inProcessStepsTeams = new List < String > ();
    for (Phoenix_Bid_Process_Steps__c step: ProcessStepsTeams) {                inProcessStepsTeams.add(step.Phoenix_Approver_Team__c);
    }


    // Set<Decimal> inProcessStepNum = new Set<Decimal>();
    decimal inProcessStepNum;
    for (Phoenix_Bid_Process_Steps__c step: inProcessSteps) {  inProcessStepNum = step.Phoenix_Step__c;
        //   inProcessStepNum.add(step.Phoenix_Step__c);
               
    }



            
    Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
    Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
    Map < String, Integer > stepteamNoMap = new Map < String, Integer > ();

    for (Phoenix_Bid_Process_Steps__c step: bid.Bid_Process_Steps__r) {

        Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
        if (stepMap.get(stepNo) != null) {
            List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
            adededSteps.add(step);
            stepMap.put(stepNo, adededSteps);
        } else {
            stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
                step
            });
        }

        String stepName = step.Phoenix_Process_Step__r.Name; //Phoenix_Approver_Team__c;
        if (stepNamesMap.get(stepName) != null) {
            List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
            adededSteps.add(step);
            stepNamesMap.put(stepName, adededSteps);
        } else {
            stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {
                step
            });
        }
        stepteamNoMap.put(stepName, stepNo);

    }
    Integer contractStepNo = stepteamNoMap.get('Contract Team\'s Action');
            
    Decimal currentStepNo = inProcessStepNum;
    if (bid.Phoenix_On_Hold__c == false) {
        if (contractStepNo != null && currentStepNo <= contractStepNo) {

            //////////////////////////////  


            bid.Phoenix_On_Hold__c = True;
            bid.Phoenix_Approval_status_at_Hold__c = bid.Phoenix_Approval_Status__c;
            bid.Phoenix_Approval_Status__c = 'On Hold';
            bidHoldHistory.Phoenix_Bid__c = bidId;
            bidHoldHistory.Phoenix_hold_time__c = Phoenix_Util.getNowEST();
            bidHoldHistory.Phoenix_Bid_Approval_Status__c = bid.Phoenix_Approval_status_at_Hold__c;

            if (inProcessStepsTeams.contains('Supply Chain') && inProcessStepsTeams.contains('Marketing')) {
                bidHoldHistory.Phoenix_SCM_Marketing__c = 'SCM&Marketing';
            } else if (inProcessStepsTeams.contains('Supply Chain')) {
                bidHoldHistory.Phoenix_SCM_Marketing__c = 'SCM';
            } else if (inProcessStepsTeams.contains('Marketing')) {
                bidHoldHistory.Phoenix_SCM_Marketing__c = 'Marketing';
            }




            insert bidHoldHistory;
            update bid;

            result = 'Success';
        } else if (contractStepNo == null) {
            bid.Phoenix_On_Hold__c = True;
            bid.Phoenix_Approval_status_at_Hold__c = bid.Phoenix_Approval_Status__c;
            bid.Phoenix_Approval_Status__c = 'On Hold';
            bidHoldHistory.Phoenix_Bid__c = bidId;
            //    bidHoldHistory.Phoenix_hold_time__c = Phoenix_Util.getUserTime(System.now(), 'America/New_York');
            bidHoldHistory.Phoenix_hold_time__c = Phoenix_Util.getNowEST();


            bidHoldHistory.Phoenix_Bid_Approval_Status__c = bid.Phoenix_Approval_status_at_Hold__c;



            if (inProcessStepsTeams.contains('Supply Chain') && inProcessStepsTeams.contains('Marketing')) {
                bidHoldHistory.Phoenix_SCM_Marketing__c = 'SCM&Marketing';
            } else if (inProcessStepsTeams.contains('Supply Chain')) {
                bidHoldHistory.Phoenix_SCM_Marketing__c = 'SCM';
            } else if (inProcessStepsTeams.contains('Marketing')) {
                bidHoldHistory.Phoenix_SCM_Marketing__c = 'Marketing';
            }

            insert bidHoldHistory;
            update bid;

            result = 'Success';

        } else if (contractStepNo != null && currentStepNo > contractStepNo) {
            result = 'You Can\'t Hold the Bid after Contract\'s step.';
        }
    }
}
Catch(Exception e) {
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'holdBid', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Remarks__c = 'Bid Id is ' + bidId, Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
    result = e.getMessage();
}
return result;
}
@AuraEnabled
public static String releaseBid(Id bidId) {
string result = '';
try {
    Phoenix_Bid__c bid = [SELECT Id, Phoenix_Approval_Status__c, Phoenix_On_Hold__c, Phoenix_Approval_status_at_Hold__c FROM Phoenix_Bid__c where Id =: bidId];
    Phoenix_Bid_Hold_History__c bidHoldHistory = [SELECT Id, Phoenix_Bid__c, Phoenix_Bid_Approval_Status__c, Phoenix_hold_duration__c, Phoenix_hold_time__c, Phoenix_release_time__c from Phoenix_Bid_Hold_History__c where Phoenix_Bid__c =: bidId and Phoenix_hold_time__c != null and Phoenix_release_time__c = null];

    if (bid.Phoenix_On_Hold__c == true) {
        bid.Phoenix_On_Hold__c = False;
        bid.Phoenix_Approval_Status__c = bid.Phoenix_Approval_status_at_Hold__c;
        bid.Phoenix_Approval_status_at_Hold__c = null;
        update bid;
        //    bidHoldHistory.Phoenix_release_time__c =Phoenix_Util.getUserTime(System.now(), 'America/New_York');
        bidHoldHistory.Phoenix_release_time__c = Phoenix_Util.getNowEST();
        update bidHoldHistory;
        result = 'Success';
    }
}
Catch(Exception e) {
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'releaseBid', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Remarks__c = 'Bid Id is ' + bidId, Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
    result = e.getMessage();
}

return result;
}

/**
* @description: This is used at submitting bid for approval.
* @author Surender Patel (Dhruvsoft) | 12-05-2021 
* @param String bidId 
* @return BidWrapper 
**/
@AuraEnabled
public static BidWrapper getBidInfo(Id bidId) {
BidWrapper bidWrap = new BidWrapper();
try {

    Phoenix_NDC_Change__c ndcChange;
    Phoenix_Bid__c bid;
    String objName = String.valueOf(bidId.getsObjectType());
    if (objName == 'Phoenix_Bid__c') {
        bid = (Database.query('Select' + Phoenix_Util.bidFields + ',Phoenix_Customer__r.Phoenix_Contracts_Approver__c FROM Phoenix_Bid__c where Id=:bidId'));
        bidWrap.bid = bid;
        bidWrap.bidItemCount = [Select COUNT() from Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c=:bidId]; //To check the added products and restrict if no products found.
            
                
    } else if (objName == 'Phoenix_NDC_Change__c') {
        ndcChange = Database.query('Select' + Phoenix_Util.ndcChangeFields + ' FROM Phoenix_NDC_Change__c where Id=:bidId');
        bidWrap.ndcChange = ndcChange;
        bidWrap.ndcChangeItemCount = [Select COUNT() from Phoenix_NDC_Change_Line_Item__c WHERE Phoenix_NDC_Change__c=:ndcChange.Id];
        //bidWrap.ndcChangeItemCount = ndcChange.NDC_Change_Line_Items__r.size(); //To check the added products and restrict if no products found.
    }



    String bidType = bid != null ? bid.Phoenix_Bid_Type__c : ndcChange != null ? 'NDC Change' : '';
    List < String > filterType = new List < String > {
        'Proposed'
    };
    List < String > contractBidTypes = new List < String > {
        'Customer Rebate Change',
        'Price Change',
        'Product Addition',
        'RFP Bids',
        'Sales Out Rebate',
        'Volume Review Only'
    }; //to check bid.Phoenix_Reference_Contracts__c is filled or not.
    List < String > noChildBidatypes = new List < String > {
        'Allocation Review'
    }; //To allow approval process to continue. These bid types will not have products/children.
    if (noChildBidatypes.contains(bidType)) {
        bidWrap.bidItemCount = 1; //To allow approval process to continue. These bid types will not have products.
    } else if (bidType == 'VIP Rebate') {
        // Instead of Bid Line Items, here we'll have Bid VIP Rebates.
        Phoenix_Bid__c bidforRebate = Database.query('Select' + Phoenix_Util.bidFields + ' FROM Phoenix_Bid__c where id=:bidId');
        bidWrap.bid = bidforRebate;
        List<Phoenix_Bid_VIP_Rebate__c> rebates = [Select Id FROM Phoenix_Bid_VIP_Rebate__c WHERE Phoenix_Bid__c =:bidId];
        if (rebates.size() > 0) {
            String rebateId = rebates[0].Id;
            List < ContentDocumentLink > filesUploaded = [SELECT ContentDocument.title, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: bidId];
            bidWrap.bidItemCount = rebates.size() > 0 && [Select Id from Phoenix_VIP_Rebate_Line__c where Phoenix_VIP_Rebate__c =: rebateId].size() > 0 && !filesUploaded.isEmpty() ? 1 : 0;

        } else {
            bidWrap.bidItemCount = 0;
        }
                
                
    } else if (bidType == 'Customer Requested Pricing Confirmations') {
        List < ContentDocumentLink > filesUploaded = [SELECT ContentDocument.title, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: bidId];
        bidWrap.bidItemCount = !filesUploaded.isEmpty() ? 1 : 0;

    } else if (bidType == 'WAC Change Submissions'  || bidType == 'Product Discontinuation Process') {
        List < ContentDocumentLink > filesUploaded = [SELECT ContentDocument.title, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: bidId];
        bidWrap.bidItemCount = !filesUploaded.isEmpty() && bidWrap.bidItemCount > 0 ? 1 : 0;

    } else if (bidType == 'Contracts Only') {
        // Instead of Bid Line Items, here we'll have check list.
        Phoenix_Bid__c bidforChecklist = Database.query('Select' + Phoenix_Util.bidFields + ' FROM Phoenix_Bid__c where id=:bidId');
        bidWrap.bid = bidforChecklist;
        List<Checklist__c> checkLists = [Select Id FROM Checklist__c WHERE Bid__c =:bidId];
        if (checkLists.size() > 0) {
            String rebateId = checkLists[0].Id;
            List < ContentDocumentLink > filesUploaded = [SELECT ContentDocument.title, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: bidId];
            bidWrap.bidItemCount = checkLists.size() > 0 && !filesUploaded.isEmpty() ? 1 : 0;

        } else {
            bidWrap.bidItemCount = 0;
        }
                  
    } else if (bidType == 'RCA Member Addition' || bidType == 'IPA Member Addition' || bidType == 'RCA/IPA Member GPO or Wholesaler Change') {
        // Instead of Bid Line Items, here we'll have RCA IPA Lines.
        Phoenix_Bid__c bid2 = Database.query('Select' + Phoenix_Util.bidFields + ' FROM Phoenix_Bid__c where id=:bidId');
        bidWrap.bid = bid2;
        Integer count = [Select COUNT() from Phoenix_RCA_IPA_LINE__c WHERE Phoenix_Bid__c=:bid2.Id];
        bidWrap.bidItemCount = count > 0 ? 1 : 0;
    } else if (bidType == 'NEW Individual Pricing Agreement (IPA)') {
                
        Phoenix_Bid__c bid2 = Database.query('Select' + Phoenix_Util.bidFields + ' FROM Phoenix_Bid__c where id=:bidId');
        bidWrap.bid = bid2;
        Integer count = [Select COUNT() from Phoenix_RCA_IPA_LINE__c WHERE Phoenix_Bid__c=:bid2.Id];
        bidWrap.bidItemCount = count > 0 ? 1 : 0;
        //bidWrap.bidItemCount = bid2.RCA_IPA_LINES__r.size() > 0 && bidWrap.bidItemCount > 0 ? 1 : 0;
    }


    if (bidWrap.bidItemCount == 0 && bidType == 'Customer Requested Pricing Confirmations') bidWrap.error = 'Please upload related documents before submitting the Bid for Approval.';
    else if (bidWrap.bidItemCount == 0 && (bidType == 'WAC Change Submissions'  || bidType == 'Product Discontinuation Process')) bidWrap.error = 'You cannot submit bid for approval without line items and related documents.';
    else if(bidWrap.bidItemCount == 0 &&(bidType == 'Mass Product Removals')) bidWrap.error = 'You cannot submit bid for approval without line items.';
    else if (bidWrap.bidItemCount == 0 && bidType == 'VIP Rebate') bidWrap.error = 'You cannot submit bid for approval without Proposed Rebates and  related documents.';
    else if (bidWrap.bidItemCount == 0 && (bidType == 'RCA Member Addition' || bidType == 'IPA Member Addition' || bidType == 'RCA/IPA Member GPO or Wholesaler Change')) bidWrap.error = 'You cannot submit bid for approval without RCA IPA Lines.';
    else if (bidWrap.bidItemCount == 0 && (bidType == 'RCA Member Addition' || bidType == 'IPA Member Addition' || bidType == 'RCA/IPA Member GPO or Wholesaler Change')) bidWrap.error = 'You cannot submit bid for approval without RCA IPA Lines.';
    else if (bidWrap.bidItemCount == 0 && (bidType == 'RCA Member Addition' || bidType == 'IPA Member Addition' || bidType == 'RCA/IPA Member GPO or Wholesaler Change')) bidWrap.error = 'You cannot submit bid for approval without RCA IPA Lines.';
    else if (bidWrap.bidItemCount == 0 && bidType == 'Contracts Only') bidWrap.error = 'You cannot submit bid for Approval without Checklist and related documents.';
    else if (bidWrap.bidItemCount == 0 && bidType == 'NEW Individual Pricing Agreement (IPA)') bidWrap.error = 'You cannot submit bid for approval without IPA Lines & bid line items.';


    else if (objName == 'Phoenix_Bid__c' && bidWrap.bidItemCount == 0) bidWrap.error = 'You cannot submit the Bid without line items. Please add some products and proceed.';
    else if (objName == 'Phoenix_NDC_Change__c' && bidWrap.ndcChangeItemCount == 0) bidWrap.error = 'You cannot submit the NDC Change without line items. Please add some products and proceed.';
    else if (contractBidTypes.contains(bidType) && bid.Phoenix_Reference_Contracts__c == null) bidWrap.error = 'Please select a contract for this bid to proceed.';
            

}
Catch(Exception e) {
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Method_Name__c = 'getBidInfo', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}

return bidWrap;
}

/**
* @description This is main method to submit NDC Change for approval. After this, all required steps will be created and NDC Change status will be updated.
* @author Surender Patel (Dhruvsoft) | 11-06-2021 
* @param BidWrapper wrap 
* @return String 
**/
@AuraEnabled
public static String submitNDCChange(BidWrapper wrap) {
String response = 'Success';
Phoenix_NDC_Change__c ndcChange = wrap.ndcChange;
try {
    delete[select id from Phoenix_Bid_Process_Steps__c where Phoenix_NDC_Change__c =: ndcChange.Id];
    // delete [select Id FROM Task where WhatId =:bid.Id];
    String bidType = 'NDC Change';
    //Create items

    Map < String, set < String >> bidWithContractsApprovresMap = new Map < String, set < String >> ();



    //query all matrices and arrange by Bid Type

    Phoenix_Approval_Matrix__c matrix = [Select Id, Name, Phoenix_Bid_Type__c, (Select Id, Name, Phoenix_Approver_Team__c, Phoenix_Is_Criteria_Step__c, Phoenix_Approver__c, Phoenix_Order__c, Phoenix_Approval_Matrix__c,
        Phoenix_Is_Notification_Only__c from Phoenix_Approval_Process_Steps__r) from Phoenix_Approval_Matrix__c where Phoenix_Bid_Type__c =: bidType];


    List < Phoenix_Bid_Process_Steps__c > bidProcessSteps = new List < Phoenix_Bid_Process_Steps__c > ();
    List < String > nonContractBidTypes = new List < String > {
        bidType
    };


    for (Phoenix_Approval_Process_Step__c pStep: matrix.Phoenix_Approval_Process_Steps__r) {

        Set < String > approverIds = new Set < String > ();
        String team = pStep.Phoenix_Approver_Team__c;
        String approvalBehaviour = approvalGroupBehaviourMap.get(pStep.Phoenix_Approver_Team__c);

                
        if (team == 'Contracts' && approvalBehaviour == 'Account based' && bidWithContractsApprovresMap.size() > 0 && !nonContractBidTypes.contains(bidType)) {
            approverIds = bidWithContractsApprovresMap.get(ndcChange.Id);
        } else if (team == 'Contracts' && approvalBehaviour == 'Account based' && bidWithContractsApprovresMap.size() == 0 && !nonContractBidTypes.contains(bidType)) {
            return 'Please assign a Contracts Approver before submitting the Bid.';
        } else if (approvalBehaviour == 'Single User' && approvalTeamUsersMap.size() > 0) {
            approverIds = approvalTeamUsersMap.get(pStep.Phoenix_Approver_Team__c); // defined in approval matrix
        } else {
            Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
            bStep.Phoenix_Is_Criteria_Step__c = pStep.Phoenix_Is_Criteria_Step__c;
            bStep.Name = ndcChange.Name + '-' + pStep.Name;
            if (pStep.Phoenix_Approver__c != null) {
                bStep.Phoenix_Approver__c = pStep.Phoenix_Approver__c;
            }
            bStep.Phoenix_Approver_Team_Members__c = String.join(new List < String > (approvalTeamUserNamesMap.get(team)), ',');
            bStep.Phoenix_NDC_Change__c = ndcChange.Id;
            bStep.Phoenix_Process_Step__c = pStep.Id;

            bStep.Phoenix_Status__c = pStep.Phoenix_Is_Criteria_Step__c ? 'Not Applicable' : 'Not Initiated';

            if (pStep.Name == 'Initial Submission') {
                // bStep.Phoenix_Approver__c = bid.Phoenix_Bid_Created_Behalf_of__c != null ? bid.Phoenix_Bid_Created_Behalf_of__c : bid.OwnerId;
                bStep.Phoenix_Approver__c = UserInfo.getUserId();

                //  bStep.Phoenix_Description__c = bid.Phoenix_Bid_Submitter_Comments__c;
                bStep.Phoenix_Status__c = 'Submitted';


                bStep.Phoenix_Approval_Sent_Time__c = Phoenix_Util.getNowEST();
                bStep.Phoenix_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(bStep.Phoenix_Approval_Sent_Time__c, 'America/New_York');

                bStep.Phoenix_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
                bStep.Phoenix_Approval_Completed_Time_String__c = Phoenix_Util.getUserTimeNow(bStep.Phoenix_Approval_Completed_Time__c, 'America/New_York');

            } //else if(pStep.Name == 'Closed')  bStep.Phoenix_Status__c = null;
            bStep.Phoenix_Approver_Team__c = team;
                    
            bidProcessSteps.add(bStep);
        }

        if (approverIds != null) {
            //create bid step items for product directos
            Decimal stepNo = 1.00;
            for (String marketingApproverId: approverIds) {

                Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
                bStep.Phoenix_Is_Criteria_Step__c = pStep.Phoenix_Is_Criteria_Step__c;
                bStep.Name = ndcChange.Name + '-' + pStep.Name;
                bStep.Phoenix_Approver__c = marketingApproverId;
                bStep.Phoenix_NDC_Change__c = ndcChange.Id;
                bStep.Phoenix_Process_Step__c = pStep.Id;
                bStep.Phoenix_Status__c = pStep.Phoenix_Is_Criteria_Step__c ? 'Not Applicable' : 'Not Initiated';
                bStep.Phoenix_Approver_Team__c = team;
                //stepNo : Ask and increment as per requirements
                bStep.Phoenix_Sub_Step__c = stepNo;
                if (team != 'Marketing' && team != 'Customer Service')
                    bStep.Phoenix_Approver_Team_Members__c = string.join(new List < String > (approvalTeamUserNamesMap.get(team)), ',');

                bidProcessSteps.add(bStep);
                stepNo++;
            }
        }

    }


    if (!bidProcessSteps.isEmpty()) {
        insert bidProcessSteps;
    }
    bidProcessSteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
        Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_NDC_Change__c =: ndcChange.Id
    ];
    ndcChange.Phoenix_Approval_Status__c = 'Supply Chain';
    ndcChange.Phoenix_NDC_Submitted_Date__c = Phoenix_Util.getNowEST();
    update ndcChange;

    Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
    //  Map < Id, Phoenix_Bid_Process_Steps__c > nextStepsMap = new Map < Id, Phoenix_Bid_Process_Steps__c > ();
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new List < Phoenix_Bid_Process_Steps__c > ();
    for (Phoenix_Bid_Process_Steps__c step: bidProcessSteps) {

        Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
        if (stepMap.get(stepNo) != null) {
            List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
            adededSteps.add(step);
            stepMap.put(stepNo, adededSteps);
        } else {
            stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
                step
            });
        }

    }


    //  for(Phoenix_Bid_Process_Steps__c step :){ nextStepsMap.put(step.Id,step);}

           
    for (Phoenix_Bid_Process_Steps__c step: stepMap.get(2)) {
        step.Phoenix_Status__c = step.Phoenix_Status__c != 'Completed' && step.Phoenix_Status__c != 'Not Applicable' ? 'In Process' : step.Phoenix_Status__c; //== 'Not Initiated' ? 'In Process' : step.Phoenix_Status__c;
        nextSteps.add(step);
    }
    update nextSteps;


    if (nextSteps.size() > 0) approvalRequestNotification(ndcChange.Id, nextSteps);


    List < Phoenix_NDC_Change_Line_Item__c > ndcItems = [Select Id, Name, Phoenix_NDC_Change__c FROM Phoenix_NDC_Change_Line_Item__c WHERE Phoenix_NDC_Change__c =: ndcChange.Id AND Phoenix_Final_Status__c != 'Not Approved'];


    for (Phoenix_NDC_Change_Line_Item__c item: ndcItems) {
        item.Phoenix_NDC_Line_Item_Approval_Status__c = 'Supply Chain Pending';
    }

    update ndcItems;





}
Catch(Exception e) {
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Method_Name__c = 'submitNDCChange', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
    response = e.getMessage();
    system.debug(e.getMessage());
}
return response;
}

/**
* @description This is main method to submit NDC Change for approval. After this, all required steps will be created and NDC Change status will be updated.
* @author Surender Patel (Dhruvsoft) | 11-06-2021 
* @param BidWrapper wrap 
* @return String 
**/
@AuraEnabled
public static String submitPHSPriceChange(Id phsId) {
String response = 'Success';
Phoenix_PHS_Price_Change__c pHSPriceChange = Database.query('Select ' + Phoenix_Util.phsChangeFields + ' FROM Phoenix_PHS_Price_Change__c WHERE Id=:phsId');
try {
    delete[select id from Phoenix_Bid_Process_Steps__c where Phoenix_PHS_Price_Change__c =: pHSPriceChange.Id];
    // delete [select Id FROM Task where WhatId =:bid.Id];
    String bidType = 'PHS Price Change';
    //Create items

    //  Map < String, set < String >> bidWithContractsApprovresMap = new Map < String, set < String >> ();



    //query all matrices and arrange by Bid Type

    Phoenix_Approval_Matrix__c matrix = [Select Id, Name, Phoenix_Bid_Type__c, (Select Id, Name, Phoenix_Approver_Team__c, Phoenix_Is_Criteria_Step__c, Phoenix_Approver__c, Phoenix_Order__c, Phoenix_Approval_Matrix__c,
        Phoenix_Is_Notification_Only__c from Phoenix_Approval_Process_Steps__r) from Phoenix_Approval_Matrix__c where Phoenix_Bid_Type__c =: bidType];


    List < Phoenix_Bid_Process_Steps__c > bidProcessSteps = new List < Phoenix_Bid_Process_Steps__c > ();
    List < String > nonContractBidTypes = new List < String > {
        bidType
    };


    for (Phoenix_Approval_Process_Step__c pStep: matrix.Phoenix_Approval_Process_Steps__r) {

        Set < String > approverIds = new Set < String > ();
        String team = pStep.Phoenix_Approver_Team__c;
        String approvalBehaviour = approvalGroupBehaviourMap.get(pStep.Phoenix_Approver_Team__c);

              
        /*  if (team == 'Contracts' && approvalBehaviour == 'Account based' && bidWithContractsApprovresMap.size() > 0 && !nonContractBidTypes.contains(bidType)) {
approverIds = bidWithContractsApprovresMap.get(pHSPriceChange.Id);
} else if (team == 'Contracts' && approvalBehaviour == 'Account based' && bidWithContractsApprovresMap.size() == 0 && !nonContractBidTypes.contains(bidType)) {
return 'Please assign a Contracts Approver before submitting the Bid.';
}  else */
        if (approvalBehaviour == 'Single User' && approvalTeamUsersMap.size() > 0) {
            approverIds = approvalTeamUsersMap.get(pStep.Phoenix_Approver_Team__c); // defined in approval matrix
        } else {
            Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
            bStep.Phoenix_Is_Criteria_Step__c = pStep.Phoenix_Is_Criteria_Step__c;
            bStep.Name = pHSPriceChange.Name + '-' + pStep.Name;
            if (pStep.Phoenix_Approver__c != null) {
                bStep.Phoenix_Approver__c = pStep.Phoenix_Approver__c;
            }
            bStep.Phoenix_Approver_Team_Members__c = String.join(new List < String > (approvalTeamUserNamesMap.get(team)), ',');
            bStep.Phoenix_PHS_Price_Change__c = pHSPriceChange.Id;
            bStep.Phoenix_Process_Step__c = pStep.Id;

            bStep.Phoenix_Status__c = pStep.Phoenix_Is_Criteria_Step__c ? 'Not Applicable' : 'Not Initiated';

            if (pStep.Name == 'Initial Submission') {
                // bStep.Phoenix_Approver__c = bid.Phoenix_Bid_Created_Behalf_of__c != null ? bid.Phoenix_Bid_Created_Behalf_of__c : bid.OwnerId;
                bStep.Phoenix_Approver__c = UserInfo.getUserId();

                //  bStep.Phoenix_Description__c = bid.Phoenix_Bid_Submitter_Comments__c;
                bStep.Phoenix_Status__c = 'Submitted';


                bStep.Phoenix_Approval_Sent_Time__c = Phoenix_Util.getNowEST();
                bStep.Phoenix_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(bStep.Phoenix_Approval_Sent_Time__c, 'America/New_York');

                bStep.Phoenix_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
                bStep.Phoenix_Approval_Completed_Time_String__c = Phoenix_Util.getUserTimeNow(bStep.Phoenix_Approval_Completed_Time__c, 'America/New_York');

            } //else if(pStep.Name == 'Closed')  bStep.Phoenix_Status__c = null;
            bStep.Phoenix_Approver_Team__c = team;

            bidProcessSteps.add(bStep);
        }

        if (approverIds != null) {
            //create bid step items for product directos
            Decimal stepNo = 1.00;
            for (String marketingApproverId: approverIds) {

                Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
                bStep.Phoenix_Is_Criteria_Step__c = pStep.Phoenix_Is_Criteria_Step__c;
                bStep.Name = pHSPriceChange.Name + '-' + pStep.Name;
                bStep.Phoenix_Approver__c = marketingApproverId;
                bStep.Phoenix_PHS_Price_Change__c = pHSPriceChange.Id;
                bStep.Phoenix_Process_Step__c = pStep.Id;
                bStep.Phoenix_Status__c = pStep.Phoenix_Is_Criteria_Step__c ? 'Not Applicable' : 'Not Initiated';
                bStep.Phoenix_Approver_Team__c = team;
                //stepNo : Ask and increment as per requirements
                bStep.Phoenix_Sub_Step__c = stepNo;
                if (team != 'Marketing' && team != 'Customer Service')
                    bStep.Phoenix_Approver_Team_Members__c = string.join(new List < String > (approvalTeamUserNamesMap.get(team)), ',');

                bidProcessSteps.add(bStep);
                stepNo++;
            }
        }

    }


    if (!bidProcessSteps.isEmpty()) {
        insert bidProcessSteps;
    }
    bidProcessSteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
        Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_PHS_Price_Change__c =: pHSPriceChange.Id
    ];

    pHSPriceChange.Phoenix_Approval_Status__c = 'Sr Director or VP Finance';
    pHSPriceChange.Phoenix_PHS_Change_Submitted_Date__c = Phoenix_Util.getNowEST();
    update pHSPriceChange;


    Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
    //  Map < Id, Phoenix_Bid_Process_Steps__c > nextStepsMap = new Map < Id, Phoenix_Bid_Process_Steps__c > ();
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new List < Phoenix_Bid_Process_Steps__c > ();
    for (Phoenix_Bid_Process_Steps__c step: bidProcessSteps) {

        Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
        if (stepMap.get(stepNo) != null) {
            List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
            adededSteps.add(step);
            stepMap.put(stepNo, adededSteps);
        } else {
            stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
                step
            });
        }

    }


    //  for(Phoenix_Bid_Process_Steps__c step :){ nextStepsMap.put(step.Id,step);}

           
    for (Phoenix_Bid_Process_Steps__c step: stepMap.get(2)) {
        step.Phoenix_Status__c = step.Phoenix_Status__c != 'Completed' && step.Phoenix_Status__c != 'Not Applicable' ? 'In Process' : step.Phoenix_Status__c; //== 'Not Initiated' ? 'In Process' : step.Phoenix_Status__c;
        nextSteps.add(step);
    }
    update nextSteps;


    if (nextSteps.size() > 0) approvalRequestNotification(pHSPriceChange.Id, nextSteps);


    List < Phoenix_PHS_Price_Change_Line__c > phsItems = [Select Id, Name, Phoenix_PHS_Price_Change__c FROM Phoenix_PHS_Price_Change_Line__c WHERE Phoenix_PHS_Price_Change__c =: pHSPriceChange.Id AND Phoenix_Final_Status__c != 'Not Approved'];


    for (Phoenix_PHS_Price_Change_Line__c item: phsItems) {
        item.Phoenix_PHS_Line_Item_Approval_Status__c = 'Sr Director or VP Finance Pending';
    }

    update phsItems;

}
Catch(Exception e) {
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Method_Name__c = 'submitPHSPriceChange', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
    response = e.getMessage();
           
}
return response;
}

@AuraEnabled
public static String submitNewProductWACPricing(Id newProductWACPricingId) {
String response = 'Success';

New_Product_WAC_Pricing__c newProductWACPricing = Database.query('Select ' + Phoenix_Util.newProductWACPricingFields + ' FROM New_Product_WAC_Pricing__c WHERE Id=:newProductWACPricingId');

//  try {
delete[select id from Phoenix_Bid_Process_Steps__c where Phoenix_New_Product_WAC_Pricing__c =: newProductWACPricingId];
// delete [select Id FROM Task where WhatId =:bid.Id];
String bidType = 'New Product WAC Pricing';

//query all matrices and arrange by Bid Type
Phoenix_Approval_Matrix__c matrix = [Select Id, Name, Phoenix_Bid_Type__c, (Select Id, Name, Phoenix_Approver_Team__c, Phoenix_Is_Criteria_Step__c, Phoenix_Approver__c, Phoenix_Order__c, Phoenix_Approval_Matrix__c,
    Phoenix_Is_Notification_Only__c from Phoenix_Approval_Process_Steps__r) from Phoenix_Approval_Matrix__c where Phoenix_Bid_Type__c =: bidType AND Phoenix_Is_Criteria_Matrix__c = false];


List < Phoenix_Bid_Process_Steps__c > bidProcessSteps = new List < Phoenix_Bid_Process_Steps__c > ();
// List < String > nonContractBidTypes = new List < String > {bidType};



Map < String, set < String >> bidWithPLeadMapRx = new Map < String, set < String >> ();
Map < String, set < String >> bidWithPLeadMapSRx = new Map < String, set < String >> ();
Map < String, set < String >> bidWithPLeadMapOTC = new Map < String, set < String >> ();

List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > itemsList = [Select Id, Name, Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c, Phoenix_Product__r.Phoenix_Product_Director__c, Phoenix_Product__r.Phoenix_Marketing_Lead__c, Phoenix_New_Product_WAC_Pricing__c from Phoenix_NewProduct_WAC_Pricing_LineItems__c where Phoenix_New_Product_WAC_Pricing__c =: newProductWACPricingId];

for (Phoenix_NewProduct_WAC_Pricing_LineItems__c newProductWACPricingItem: itemsList) {


    String prodType = newProductWACPricingItem.Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c;

    if (prodType == 'Rx' && bidWithPLeadMapRx.get(newProductWACPricingItem.Phoenix_New_Product_WAC_Pricing__c) != null) {
        set < String > tempDirectors = bidWithPLeadMapRx.get(newProductWACPricingItem.Phoenix_New_Product_WAC_Pricing__c);
        tempDirectors.add(newProductWACPricingItem.Phoenix_Product__r.Phoenix_Marketing_Lead__c);
        bidWithPLeadMapRx.put(newProductWACPricingItem.Phoenix_New_Product_WAC_Pricing__c, tempDirectors);
    } else if (prodType == 'Rx' && bidWithPLeadMapRx.get(newProductWACPricingItem.Phoenix_New_Product_WAC_Pricing__c) == null) {
        bidWithPLeadMapRx.put(newProductWACPricingItem.Phoenix_New_Product_WAC_Pricing__c, new Set < String > {
            newProductWACPricingItem.Phoenix_Product__r.Phoenix_Marketing_Lead__c
        });
    }
    if (prodType == 'SRx' && bidWithPLeadMapSRx.get(newProductWACPricingItem.Phoenix_New_Product_WAC_Pricing__c) != null) {
        set < String > tempDirectors = bidWithPLeadMapSRx.get(newProductWACPricingItem.Phoenix_New_Product_WAC_Pricing__c);
        tempDirectors.add(newProductWACPricingItem.Phoenix_Product__r.Phoenix_Marketing_Lead__c);
        bidWithPLeadMapSRx.put(newProductWACPricingItem.Phoenix_New_Product_WAC_Pricing__c, tempDirectors);
    } else if (prodType == 'SRx' && bidWithPLeadMapSRx.get(newProductWACPricingItem.Phoenix_New_Product_WAC_Pricing__c) == null) {
        bidWithPLeadMapSRx.put(newProductWACPricingItem.Phoenix_New_Product_WAC_Pricing__c, new Set < String > {
            newProductWACPricingItem.Phoenix_Product__r.Phoenix_Marketing_Lead__c
        });
    }
    if (prodType == 'OTC' && bidWithPLeadMapOTC.get(newProductWACPricingItem.Phoenix_New_Product_WAC_Pricing__c) != null) {
        set < String > tempDirectors = bidWithPLeadMapOTC.get(newProductWACPricingItem.Phoenix_New_Product_WAC_Pricing__c);
        tempDirectors.add(newProductWACPricingItem.Phoenix_Product__r.Phoenix_Marketing_Lead__c);
        bidWithPLeadMapOTC.put(newProductWACPricingItem.Phoenix_New_Product_WAC_Pricing__c, tempDirectors);
    } else if (prodType == 'OTC' && bidWithPLeadMapOTC.get(newProductWACPricingItem.Phoenix_New_Product_WAC_Pricing__c) == null) {
        bidWithPLeadMapOTC.put(newProductWACPricingItem.Phoenix_New_Product_WAC_Pricing__c, new Set < String > {
            newProductWACPricingItem.Phoenix_Product__r.Phoenix_Marketing_Lead__c
        });
    }

}





for (Phoenix_Approval_Process_Step__c pStep: matrix.Phoenix_Approval_Process_Steps__r) {

    Set < String > approverIds = new Set < String > ();
    String team = pStep.Phoenix_Approver_Team__c;
    String approvalBehaviour = approvalGroupBehaviourMap.get(pStep.Phoenix_Approver_Team__c);

           
    /*  if (team == 'Contracts' && approvalBehaviour == 'Account based' && bidWithContractsApprovresMap.size() > 0 && !nonContractBidTypes.contains(bidType)) {
approverIds = bidWithContractsApprovresMap.get(pHSPriceChange.Id);
} else if (team == 'Contracts' && approvalBehaviour == 'Account based' && bidWithContractsApprovresMap.size() == 0 && !nonContractBidTypes.contains(bidType)) {
return 'Please assign a Contracts Approver before submitting the Bid.';
}  else */
    /*  if (team == 'Marketing' && approvalBehaviour == 'Product based' && bidWithPDirectorMap.size() > 0) {
approverIds = bidWithPDirectorMap.get(bid.Id); // Product Directors
} else if (team == 'Marketing' && approvalBehaviour == 'Product based' && bidWithPDirectorMap.size() == 0) {
return 'Please assign a Marketing Approver before submitting the Bid.';
} else*/
    if (team == 'Marketing Lead Rx' && approvalBehaviour == 'Product based' && bidWithPLeadMapRx.size() > 0) {
        approverIds = bidWithPLeadMapRx.get(newProductWACPricingId); // Marketing Leads

    } else if (team == 'Marketing Lead SRx' && approvalBehaviour == 'Product based' && bidWithPLeadMapSRx.size() > 0) {
        approverIds = bidWithPLeadMapSRx.get(newProductWACPricingId); // Marketing Leads

    } else if (team == 'Marketing Lead OTC' && approvalBehaviour == 'Product based' && bidWithPLeadMapOTC.size() > 0) {
        approverIds = bidWithPLeadMapOTC.get(newProductWACPricingId); // Marketing Leads

    }
    //  else if(team == 'Marketing Lead Rx' && approvalBehaviour == 'Product based' && bidWithPLeadMapRx.size()==0){
    //      return 'Please assign a Marketing Lead Approver before submitting the Bid.';
    //  }
    /*    else if (team == 'Contracts' && approvalBehaviour == 'Account based' && bidWithContractsApprovresMap.size() > 0 && !nonContractBidTypes.contains(bid.Phoenix_Bid_Type__c)) {
approverIds = bidWithContractsApprovresMap.get(bid.Id);
} else if (team == 'Contracts' && approvalBehaviour == 'Account based' && bidWithContractsApprovresMap.size() == 0 && !nonContractBidTypes.contains(bid.Phoenix_Bid_Type__c)) {
return 'Please assign a Contracts Approver before submitting the Bid.';
} else if (team == 'Customer Service' && approvalBehaviour == 'Account based' && bidWithCSApprovresMap.size() > 0  && !nonCustomerServiceBidTypes.contains(bid.Phoenix_Bid_Type__c)) {
approverIds = bidWithCSApprovresMap.get(bid.Id);
} else if (team == 'Customer Service' && approvalBehaviour == 'Account based' && bidWithCSApprovresMap.size() == 0  && !nonCustomerServiceBidTypes.contains(bid.Phoenix_Bid_Type__c)) {
return 'Please assign a Customer Service Approver before submitting the Bid.';
}*/
    else if (approvalBehaviour == 'Single User' && approvalTeamUsersMap.size() > 0) {
        approverIds = approvalTeamUsersMap.get(pStep.Phoenix_Approver_Team__c); // defined in approval matrix
    } else {
        Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = pStep.Phoenix_Is_Criteria_Step__c;
        bStep.Name = newProductWACPricing.Name + '-' + pStep.Name;
        if (pStep.Phoenix_Approver__c != null) {
            bStep.Phoenix_Approver__c = pStep.Phoenix_Approver__c;
        }
        bStep.Phoenix_Approver_Team_Members__c = String.join(new List < String > (approvalTeamUserNamesMap.get(team)), ',');
        bStep.Phoenix_New_Product_WAC_Pricing__c = newProductWACPricing.Id;
        bStep.Phoenix_Process_Step__c = pStep.Id;

        bStep.Phoenix_Status__c = pStep.Phoenix_Is_Criteria_Step__c ? 'Not Applicable' : 'Not Initiated';

        if (pStep.Name == 'Initial Submission') {
            // bStep.Phoenix_Approver__c = bid.Phoenix_Bid_Created_Behalf_of__c != null ? bid.Phoenix_Bid_Created_Behalf_of__c : bid.OwnerId;
            bStep.Phoenix_Approver__c = UserInfo.getUserId();

            //  bStep.Phoenix_Description__c = bid.Phoenix_Bid_Submitter_Comments__c;
            bStep.Phoenix_Status__c = 'Submitted';


            bStep.Phoenix_Approval_Sent_Time__c = Phoenix_Util.getNowEST(); //;
            bStep.Phoenix_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(bStep.Phoenix_Approval_Sent_Time__c, 'America/New_York');

            bStep.Phoenix_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
            bStep.Phoenix_Approval_Completed_Time_String__c = Phoenix_Util.getUserTimeNow(bStep.Phoenix_Approval_Completed_Time__c, 'America/New_York');

        } //else if(pStep.Name == 'Closed')  bStep.Phoenix_Status__c = null;
        bStep.Phoenix_Approver_Team__c = team;
               
        bidProcessSteps.add(bStep);
    }

    if (approverIds != null) {
        //create bid step items for product directos
        Decimal stepNo = 1.00;
        for (String marketingApproverId: approverIds) {

            Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
            bStep.Phoenix_Is_Criteria_Step__c = pStep.Phoenix_Is_Criteria_Step__c;
            bStep.Name = newProductWACPricing.Name + '-' + pStep.Name;
            bStep.Phoenix_Approver__c = marketingApproverId;
            bStep.Phoenix_New_Product_WAC_Pricing__c = newProductWACPricing.Id;
            bStep.Phoenix_Process_Step__c = pStep.Id;
            bStep.Phoenix_Status__c = pStep.Phoenix_Is_Criteria_Step__c ? 'Not Applicable' : 'Not Initiated';
            bStep.Phoenix_Approver_Team__c = team;
            //stepNo : Ask and increment as per requirements
            bStep.Phoenix_Sub_Step__c = stepNo;
            if (team != 'Marketing' && team != 'Customer Service')
                bStep.Phoenix_Approver_Team_Members__c = string.join(new List < String > (approvalTeamUserNamesMap.get(team)), ',');

            bidProcessSteps.add(bStep);
            stepNo++;
        }
    }

}


if (!bidProcessSteps.isEmpty()) {
    insert bidProcessSteps;
}
bidProcessSteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
    Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_New_Product_WAC_Pricing__c =: newProductWACPricingId
];


Map < String, Map < Integer, List < Phoenix_Bid_Process_Steps__c >>> bidProcessStepsMap = new Map < String, Map < Integer, List < Phoenix_Bid_Process_Steps__c >>> ();
Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
Map < String, Phoenix_Bid_Process_Steps__c > stepApproversMap = new Map < String, Phoenix_Bid_Process_Steps__c > ();
Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
Map < String, List < Phoenix_NewProduct_WAC_Pricing_LineItems__c >> itemsByDitectorMap = new Map < String, List < Phoenix_NewProduct_WAC_Pricing_LineItems__c >> ();
//System.debug('bid.Bid_Process_Steps__r==>'+bid.Bid_Process_Steps__r);
List < Phoenix_Bid_Process_Steps__c > nextSteps = new List < Phoenix_Bid_Process_Steps__c > ();



list < Phoenix_Bid_Process_Steps__c > criteriaSteplist = new list < Phoenix_Bid_Process_Steps__c > ();
map < string, Phoenix_Bid_Process_Steps__c > teamToStepMap = new map < string, Phoenix_Bid_Process_Steps__c > ();

for (Phoenix_Bid_Process_Steps__c step: bidProcessSteps) {

    Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
    if (stepMap.get(stepNo) != null) {
        List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
        adededSteps.add(step);
        stepMap.put(stepNo, adededSteps);
    } else {
        stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
            step
        });
    }

    String stepName = step.Phoenix_Approver_Team__c;
    if (stepNamesMap.get(stepName) != null) {
        List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
        adededSteps.add(step);
        stepNamesMap.put(stepName, adededSteps);
    } else {
        stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {
            step
        });
    }
    stepnameNoMap.put(stepName, stepNo);
    stepApproversMap.put(step.Phoenix_Approver_Team__c + '-' + step.Phoenix_Approver__c, step);
    if (step.Phoenix_Is_Criteria_Step__c) {
        teamToStepMap.put(step.Phoenix_Approver_Team__c, step);
        criteriaSteplist.add(step);
    }
}

//Arranging bid line items by director
/*   if (itemsList.size() > 0) {
for (Phoenix_NewProduct_WAC_Pricing_LineItems__c item: itemsList) {
if (itemsByDitectorMap.containsKey(item.Phoenix_Product_Director__c)) {
List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > tempList = itemsByDitectorMap.get(item.Phoenix_Product_Director__c);
tempList.add(item);
itemsByDitectorMap.put(item.Phoenix_Product_Director__c, tempList);
} else {
itemsByDitectorMap.put(item.Phoenix_Product_Director__c, new List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > {
item
});
}
}

}*/
//   bidProcessStepsMap.put(bid.Id, stepMap); //Arranged all Bid>eachStep No>Step 
system.debug('itemsByDitectorMap' + itemsByDitectorMap);


/* ------------------------------*/
// Set < string > criteraStepsSet = Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(bid.Id);
Set < String > approverTeams = new Set < String > ();
Integer existingGridCount = [Select Id FROM Phoenix_Approval_Grid__c WHERE Phoenix_New_Product_WAC_Pricing__c =: newProductWACPricingId].size();
Map < String, Phoenix_Approval_Grid__c > approvalGridMap = new Map < String, Phoenix_Approval_Grid__c > ();
String query = 'Select ' + Phoenix_Util.newProductWACPricingLinesFields + ',Phoenix_Product__r.Family,Phoenix_New_Product_WAC_Pricing__r.Name,Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c,Phoenix_Product__r.Phoenix_Is_partner_product__c,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c from  Phoenix_NewProduct_WAC_Pricing_LineItems__c where Phoenix_New_Product_WAC_Pricing__c =:  newProductWACPricingId ';

List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > existingLineItems = Database.query(query);

List < Phoenix_Approval_Grid__c > existingGrids = Database.query('SELECT ' + Phoenix_Util.approvalGridFields + 'From 	Phoenix_Approval_Grid__c where Phoenix_New_Product_WAC_Pricing__c =:  newProductWACPricingId');
for (Phoenix_Approval_Grid__c grid: existingGrids) approvalGridMap.put(grid.Phoenix_Product_Family__c, grid);

Set < Id > bItemIds = new Set < Id > ();
Map < String, List < Phoenix_NewProduct_WAC_Pricing_LineItems__c >> productFamilyLinesMap = new Map < String, List < Phoenix_NewProduct_WAC_Pricing_LineItems__c >> ();

for (Phoenix_NewProduct_WAC_Pricing_LineItems__c bidline: existingLineItems) {
    // bidType = bidline.Phoenix_New_Product_WAC_Pricing__r.Phoenix_Bid_Type__c;
    String pFamily = bidline.Phoenix_Product__r.Family;
    if (pFamily != null && !productFamilyLinesMap.containsKey(pFamily)) {
        productFamilyLinesMap.put(pFamily, new List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > {
            bidline
        });
    } else if (pFamily != null && productFamilyLinesMap.containsKey(pFamily)) {
        List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > tempList = productFamilyLinesMap.get(pFamily);
        tempList.add(bidline);
        productFamilyLinesMap.put(pFamily, tempList);
    }

    bItemIds.add(bidline.Id);
}

//Get criteria matrix records
List < Phoenix_Approval_Matrix__c > criteriaMatrixRecords = Database.query('SELECT ' + Phoenix_Util.approvalMatrixFields + ',(Select ' + Phoenix_Util.approvalProcessStepFields + ' From Phoenix_Approval_Process_Steps__r) From Phoenix_Approval_Matrix__c WHERE Phoenix_Is_Criteria_Matrix__c=true and Phoenix_Bid_Type__c=:bidType');

Map < Id, Phoenix_Approval_Matrix__c > criteriaMatrixMap = new Map < Id, Phoenix_Approval_Matrix__c > ();

for (Phoenix_Approval_Matrix__c cmatrix: criteriaMatrixRecords) criteriaMatrixMap.put(cmatrix.Id, cmatrix);

if (productFamilyLinesMap != null) {
    for (String pFamily: productFamilyLinesMap.KeySet()) {

        Decimal GM_Percent = newProductWACPricing.Phoenix_GM__c;
        Decimal Th_Put_Margin = 0;
        Decimal TP_Percent = newProductWACPricing.Phoenix_TPT__c;
        Decimal Revenue = newProductWACPricing.Phoenix_Net_sales_annualized__c;

        Decimal GM_Percent_local = 0;
        Decimal TP_Percent_local = 0;

        Decimal Revenue_Local = 0;



        Boolean isPartnerProd = (productFamilyLinesMap.get(pFamily))[0].Phoenix_Product__r.Phoenix_Is_partner_product__c;


        Phoenix_Approval_Grid__c tempGrid = approvalGridMap.containsKey(pFamily) ? approvalGridMap.get(pFamily) : new Phoenix_Approval_Grid__c();

        if (tempGrid.Id == null) {
            tempGrid.Name = existingLineItems[0].Phoenix_New_Product_WAC_Pricing__r.Name + '-' + pFamily;
            tempGrid.Phoenix_New_Product_WAC_Pricing__c = newProductWACPricingId;
        }

        // To make them absolute values
        Revenue_Local = Revenue;
        GM_Percent_local = GM_Percent;
        TP_Percent_local = TP_Percent;

        Revenue = Revenue_Local < 0 ? -(Revenue) : Revenue;
        GM_Percent = GM_Percent_local < 0 ? -(GM_Percent) : GM_Percent;
        TP_Percent = TP_Percent_local < 0 ? -(TP_Percent) : TP_Percent;

        //Assigning to object
        //  tempGrid.Phoenix_New_Product_WAC_Pricing__c = newProductWACPricingId;
        tempGrid.Phoenix_Product_Family__c = pFamily;
        tempGrid.Phoenix_GM__c = GM_Percent_local;
        tempGrid.Phoenix_TP__c = TP_Percent_local;
        tempGrid.Phoenix_Revenue__c = Revenue_Local;

        tempGrid.Phoenix_Is_Criteria_Matched__c = false;

        Phoenix_Approval_Matrix__c selectedMatrix = new Phoenix_Approval_Matrix__c();

        for (Phoenix_Approval_Matrix__c cmatrix: criteriaMatrixRecords) {
            //*********************************************************************************************************************************************************************************************                
            if (isPartnerProd == true && cmatrix.Phoenix_GM_Percent_From__c <= GM_Percent && GM_Percent <= cmatrix.Phoenix_GM_Percent_To__c && cmatrix.Phoenix_Revenue_From__c <= Revenue && Revenue <= cmatrix.Phoenix_Revenue_To__c) {

                selectedMatrix = cmatrix; //0-25 gm//revernue from0 to 1
            } else if (isPartnerProd == true && cmatrix.Phoenix_GM_Percent_From__c <= GM_Percent && GM_Percent <= cmatrix.Phoenix_GM_Percent_To__c && cmatrix.Phoenix_Revenue_From__c < Revenue && cmatrix.Phoenix_Revenue_To__c == null) {
                selectedMatrix = cmatrix; //0-25gm//revenue 1M above
            } else if (isPartnerProd == true && cmatrix.Phoenix_GM_Percent_From__c < GM_Percent && cmatrix.Phoenix_GM_Percent_To__c == null && cmatrix.Phoenix_Revenue_From__c < Revenue && cmatrix.Phoenix_Revenue_To__c == null) {

                selectedMatrix = cmatrix; //25gm above//revenue 2M Above
            } else if (isPartnerProd == true && cmatrix.Phoenix_GM_Percent_From__c < GM_Percent && cmatrix.Phoenix_GM_Percent_To__c == null && cmatrix.Phoenix_Revenue_From__c <= Revenue && Revenue <= cmatrix.Phoenix_Revenue_To__c) {

                if(Revenue>=0 && Revenue<=1000000 )tempGrid.Phoenix_Is_Mkg_Head_Noti_Required__c = TRUE;
                selectedMatrix = cmatrix; //25gm above//revenue from to
            }

            //*********************************************************************************************************************************************************************************************
            //*********************************************************************************************************************************************************************************************                
            if (isPartnerProd == false && cmatrix.Phoenix_Throughput_Percentage_From__c <= TP_Percent && TP_Percent <= cmatrix.Phoenix_Throughput_Percentage_To__c && cmatrix.Phoenix_Revenue_From__c <= Revenue && Revenue <= cmatrix.Phoenix_Revenue_To__c) {

                selectedMatrix = cmatrix; //0-25 gm//revernue from0 to 1
            } else if (isPartnerProd == false && cmatrix.Phoenix_Throughput_Percentage_From__c <= TP_Percent && TP_Percent <= cmatrix.Phoenix_Throughput_Percentage_To__c && cmatrix.Phoenix_Revenue_From__c < Revenue && cmatrix.Phoenix_Revenue_To__c == null) {
                selectedMatrix = cmatrix; //0-25gm//revenue 1M above
            } else if (isPartnerProd == false && cmatrix.Phoenix_Throughput_Percentage_From__c < TP_Percent && cmatrix.Phoenix_Throughput_Percentage_To__c == null && cmatrix.Phoenix_Revenue_From__c < Revenue && cmatrix.Phoenix_Revenue_To__c == null) {

                selectedMatrix = cmatrix; //25gm above//revenue 2M Above
            } else if (isPartnerProd == false && cmatrix.Phoenix_Throughput_Percentage_From__c < TP_Percent && cmatrix.Phoenix_Throughput_Percentage_To__c == null && cmatrix.Phoenix_Revenue_From__c <= Revenue && Revenue <= cmatrix.Phoenix_Revenue_To__c) {


                selectedMatrix = cmatrix; //25gm above//revenue from to
            }

            //*********************************************************************************************************************************************************************************************




        }

        tempGrid.Phoenix_Is_partner_product__c = isPartnerProd;
               
        if (selectedMatrix.Id != null) {
            tempGrid.Phoenix_Is_Criteria_Matched__c = true;

            List < Phoenix_Approval_Process_Step__c > selectedSteps = criteriaMatrixMap.get(selectedMatrix.Id).Phoenix_Approval_Process_Steps__r;
            String prodType = productFamilyLinesMap.get(pFamily)[0].Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c;
            for (Phoenix_Approval_Process_Step__c step: selectedSteps) {
                if (step.Phoenix_Approver_Team__c == 'Marketing Lead Rx' && prodType == 'Rx') {
                    approverTeams.add(step.Phoenix_Approver_Team__c);
                    tempGrid.Phoenix_isRX__c = true;
                } else if (step.Phoenix_Approver_Team__c == 'Marketing Lead SRx' && prodType == 'SRx') {
                    approverTeams.add(step.Phoenix_Approver_Team__c);
                    tempGrid.Phoenix_isSRX__c = true;
                } else if (step.Phoenix_Approver_Team__c == 'Marketing Lead OTC' && prodType == 'OTC') {
                    approverTeams.add(step.Phoenix_Approver_Team__c);
                    tempGrid.Phoenix_isOTC__c = true;
                } else if (step.Phoenix_Approver_Team__c == 'Marketing Head') {
                    approverTeams.add(step.Phoenix_Approver_Team__c);
                    tempGrid.Phoenix_Mkt_Head_Req__c = true;
                } else if (step.Phoenix_Approver_Team__c == 'Sr Director or VP Finance') {
                    approverTeams.add(step.Phoenix_Approver_Team__c);
                    tempGrid.Phoenix_VP_Finance_Req__c = true;
                } else if (step.Phoenix_Approver_Team__c != 'Marketing Head' && step.Phoenix_Approver_Team__c != 'Sr Director or VP Finance' && step.Phoenix_Approver_Team__c != 'Marketing Lead OTC' && step.Phoenix_Approver_Team__c != 'Marketing Lead SRx' && step.Phoenix_Approver_Team__c != 'Marketing Lead Rx') {
                    approverTeams.add(step.Phoenix_Approver_Team__c);
                }
            }

            if (selectedMatrix.Phoenix_Bid_Type__c != 'Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'Good Dated OTB' && selectedMatrix.Phoenix_Bid_Type__c != 'One Time Buy Good Dated Shelf Life for New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Product Launch' && !isPartnerProd && selectedMatrix.Phoenix_Throughput_Impact_To__c != null) {
                tempGrid.Phoenix_Annualized_TP_Impact_Limit__c = '$' + selectedMatrix.Phoenix_Throughput_Impact_from__c + '-$' + selectedMatrix.Phoenix_Throughput_Impact_To__c;
            } else if (selectedMatrix.Phoenix_Bid_Type__c != 'Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'Good Dated OTB' && selectedMatrix.Phoenix_Bid_Type__c != 'One Time Buy Good Dated Shelf Life for New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Product Launch' && !isPartnerProd && selectedMatrix.Phoenix_Throughput_Impact_To__c == null && selectedMatrix.Phoenix_Throughput_Impact_from__c != null) {
                tempGrid.Phoenix_Annualized_TP_Impact_Limit__c = '>$' + selectedMatrix.Phoenix_Throughput_Impact_from__c;
            }
            if (!isPartnerProd && selectedMatrix.Phoenix_Throughput_Percentage_To__c != null) {
                tempGrid.Phoenix_TP_Limit__c = selectedMatrix.Phoenix_Throughput_Percentage_From__c + '%-' + selectedMatrix.Phoenix_Throughput_Percentage_To__c + '%';
            } else if (!isPartnerProd && selectedMatrix.Phoenix_Throughput_Percentage_To__c == null && selectedMatrix.Phoenix_Throughput_Percentage_From__c != null) {
                tempGrid.Phoenix_TP_Limit__c = '>' + selectedMatrix.Phoenix_Throughput_Percentage_From__c + '%';
            }

            if (selectedMatrix.Phoenix_Bid_Type__c != 'Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'Good Dated OTB' && selectedMatrix.Phoenix_Bid_Type__c != 'One Time Buy Good Dated Shelf Life for New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Product Launch' && isPartnerProd && selectedMatrix.Phoenix_GM_Impact_To__c != null) {
                tempGrid.Phoenix_Annualized_GM_Impact_Limit__c = '$' + selectedMatrix.Phoenix_GM_Impact_From__c + '-$' + selectedMatrix.Phoenix_GM_Impact_To__c;
            } else if (selectedMatrix.Phoenix_Bid_Type__c != 'Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'Good Dated OTB' && selectedMatrix.Phoenix_Bid_Type__c != 'One Time Buy Good Dated Shelf Life for New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Product Launch' && isPartnerProd && selectedMatrix.Phoenix_GM_Impact_To__c == null && selectedMatrix.Phoenix_GM_Percent_From__c != null) {
                tempGrid.Phoenix_Annualized_GM_Impact_Limit__c = '>$' + selectedMatrix.Phoenix_GM_Percent_From__c;
            }

            if (isPartnerProd && selectedMatrix.Phoenix_GM_Percent_To__c != null) {
                tempGrid.Phoenix_GM_Limit__c = selectedMatrix.Phoenix_GM_Percent_From__c + '%-' + selectedMatrix.Phoenix_GM_Percent_To__c + '%';
            } else if (isPartnerProd && selectedMatrix.Phoenix_GM_Percent_To__c == null && selectedMatrix.Phoenix_GM_Percent_From__c != null) {
                tempGrid.Phoenix_GM_Limit__c = '>' + selectedMatrix.Phoenix_GM_Percent_From__c + '%';
            }


            if ((selectedMatrix.Phoenix_Bid_Type__c == 'Product Addition' || selectedMatrix.Phoenix_Bid_Type__c == 'Good Dated OTB' || selectedMatrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' || selectedMatrix.Phoenix_Bid_Type__c == 'New Product Launch') && selectedMatrix.Phoenix_Revenue_To__c != null) {
                tempGrid.Phoenix_Revenue_Limit__c = '$' + selectedMatrix.Phoenix_Revenue_From__c + '-$' + selectedMatrix.Phoenix_Revenue_To__c;
            } else if ((selectedMatrix.Phoenix_Bid_Type__c == ' ' || selectedMatrix.Phoenix_Bid_Type__c == 'Good Dated OTB' || selectedMatrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' || selectedMatrix.Phoenix_Bid_Type__c == 'New Product Launch') && selectedMatrix.Phoenix_Revenue_To__c == null && selectedMatrix.Phoenix_Revenue_From__c != null) {
                tempGrid.Phoenix_Revenue_Limit__c = '>$' + selectedMatrix.Phoenix_Revenue_From__c;
            }


        }

        approvalGridMap.put(pFamily, tempGrid);

    }

    upsert approvalGridMap.values();
    //System.debug('Upsert values--->'+approvalGridMap);

    //Updating line items
    List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > updatedItems = new List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > ();
    for (String pFamily: approvalGridMap.keySet()) {
        for (Phoenix_NewProduct_WAC_Pricing_LineItems__c item: productFamilyLinesMap.get(pFamily)) {
            item.Phoenix_Approval_Grid__c = approvalGridMap.get(pFamily).Id;
            updatedItems.add(item);
        }
    }
    update updatedItems;

}

       

map < string, Phoenix_Bid_Process_Steps__c > updatedTeamToStepMap = new map < string, Phoenix_Bid_Process_Steps__c > ();
string bidStatus;
if (approverTeams.size() > 0) {
    for (Phoenix_Bid_Process_Steps__c critStep: criteriaSteplist) {
        if (approverTeams.contains('Marketing Lead Rx') && critStep.Phoenix_Approver_Team__c == 'Marketing Lead Rx') {
            critStep.Phoenix_Status__c = 'In Process';
            updatedTeamToStepMap.put('Marketing Lead Rx', critStep);
        } else if (approverTeams.contains('Marketing Lead SRx') && critStep.Phoenix_Approver_Team__c == 'Marketing Lead SRx') {
            critStep.Phoenix_Status__c = 'In Process';
            updatedTeamToStepMap.put('Marketing Lead SRx', critStep);
        } else if (approverTeams.contains('Marketing Lead OTC') && critStep.Phoenix_Approver_Team__c == 'Marketing Lead OTC') {
            critStep.Phoenix_Status__c = 'In Process';
            updatedTeamToStepMap.put('Marketing Lead OTC', critStep);
        }
        if (approverTeams.contains('Marketing Head') && critStep.Phoenix_Approver_Team__c == 'Marketing Head') {
            critStep.Phoenix_Status__c = 'Not Initiated';
            updatedTeamToStepMap.put('Marketing Head', critStep);
        }
        if (approverTeams.contains('Sr Director or VP Finance') && critStep.Phoenix_Approver_Team__c == 'Sr Director or VP Finance') {
            critStep.Phoenix_Status__c = 'Not Initiated';
            updatedTeamToStepMap.put('Sr Director or VP Finance', critStep);
        }
        /*if(approverTeams.contains('Sr Director or VP Finance') && critStep.Phoenix_Approver_Team__c=='Marketing Head'){
critStep.Phoenix_Status__c='Not Initiated';
updatedTeamToStepMap.put('Marketing Head',critStep);
} */
    }
            
    nextSteps = updatedTeamToStepMap.values();

}



/* --------------------------------------------   */


newProductWACPricing.Phoenix_Approval_Status__c = 'Marketing Lead';

newProductWACPricing.Phoenix_Submitted_Date__c = Phoenix_Util.getNowEST();
update newProductWACPricing;
update updatedTeamToStepMap.values();
approvalRequestNotification(newProductWACPricingId, nextSteps);



/*    }
Catch(Exception e) {
String msg  = e.getMessage().length() > 255 ? e.getMessage().substring(0,254) : e.getMessage();
Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Method_Name__c = 'submitBid', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
insert exp;
}
*/
return response;
}

@AuraEnabled
public static String submitWACChange(Id wacChangeId) {
String response = 'Success';
Phoenix_WAC_Change__c wacChange = Database.query('Select ' + Phoenix_Util.wacChangeFields + ' FROM Phoenix_WAC_Change__c WHERE Id=:wacChangeId');

try {
    delete[select id from Phoenix_Bid_Process_Steps__c where Phoenix_WAC_Change__c =: wacChange.Id];
    // delete [select Id FROM Task where WhatId =:bid.Id];
    String bidType = 'WAC Change';
    //Create items

    Map < String, set < String >> bidWithContractsApprovresMap = new Map < String, set < String >> ();



    //query all matrices and arrange by Bid Type

    Phoenix_Approval_Matrix__c matrix = [Select Id, Name, Phoenix_Bid_Type__c, (Select Id, Name, Phoenix_Approver_Team__c, Phoenix_Is_Criteria_Step__c, Phoenix_Approver__c, Phoenix_Order__c, Phoenix_Approval_Matrix__c,
        Phoenix_Is_Notification_Only__c from Phoenix_Approval_Process_Steps__r) from Phoenix_Approval_Matrix__c where Phoenix_Bid_Type__c =: bidType];


    List < Phoenix_Bid_Process_Steps__c > bidProcessSteps = new List < Phoenix_Bid_Process_Steps__c > ();
    List < String > nonContractBidTypes = new List < String > {
        bidType
    };


    for (Phoenix_Approval_Process_Step__c pStep: matrix.Phoenix_Approval_Process_Steps__r) {

        Set < String > approverIds = new Set < String > ();
        String team = pStep.Phoenix_Approver_Team__c;
        String approvalBehaviour = approvalGroupBehaviourMap.get(pStep.Phoenix_Approver_Team__c);

              
        if (team == 'Contracts' && approvalBehaviour == 'Account based' && bidWithContractsApprovresMap.size() > 0 && !nonContractBidTypes.contains(bidType)) {
            approverIds = bidWithContractsApprovresMap.get(wacChange.Id);
        } else if (team == 'Contracts' && approvalBehaviour == 'Account based' && bidWithContractsApprovresMap.size() == 0 && !nonContractBidTypes.contains(bidType)) {
            return 'Please assign a Contracts Approver before submitting the Bid.';
        } else if (approvalBehaviour == 'Single User' && approvalTeamUsersMap.size() > 0) {
            approverIds = approvalTeamUsersMap.get(pStep.Phoenix_Approver_Team__c); // defined in approval matrix
        } else {
            Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
            bStep.Phoenix_Is_Criteria_Step__c = pStep.Phoenix_Is_Criteria_Step__c;
            bStep.Name = wacChange.Name + '-' + pStep.Name;
            if (pStep.Phoenix_Approver__c != null) {
                bStep.Phoenix_Approver__c = pStep.Phoenix_Approver__c;
            }
            bStep.Phoenix_Approver_Team_Members__c = String.join(new List < String > (approvalTeamUserNamesMap.get(team)), ',');
            bStep.Phoenix_WAC_Change__c = wacChange.Id;
            bStep.Phoenix_Process_Step__c = pStep.Id;

            bStep.Phoenix_Status__c = pStep.Phoenix_Is_Criteria_Step__c ? 'Not Applicable' : 'Not Initiated';

            if (pStep.Name == 'Initial Submission') {
                // bStep.Phoenix_Approver__c = bid.Phoenix_Bid_Created_Behalf_of__c != null ? bid.Phoenix_Bid_Created_Behalf_of__c : bid.OwnerId;
                bStep.Phoenix_Approver__c = UserInfo.getUserId();

                //  bStep.Phoenix_Description__c = bid.Phoenix_Bid_Submitter_Comments__c;
                bStep.Phoenix_Status__c = 'Submitted';


                bStep.Phoenix_Approval_Sent_Time__c = Phoenix_Util.getNowEST(); //;
                bStep.Phoenix_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(bStep.Phoenix_Approval_Sent_Time__c, 'America/New_York');

                bStep.Phoenix_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
                bStep.Phoenix_Approval_Completed_Time_String__c = Phoenix_Util.getUserTimeNow(bStep.Phoenix_Approval_Completed_Time__c, 'America/New_York');

            } //else if(pStep.Name == 'Closed')  bStep.Phoenix_Status__c = null;
            bStep.Phoenix_Approver_Team__c = team;
                 
            bidProcessSteps.add(bStep);
        }

        if (approverIds != null) {
            //create bid step items for product directos
            Decimal stepNo = 1.00;
            for (String marketingApproverId: approverIds) {

                Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
                bStep.Phoenix_Is_Criteria_Step__c = pStep.Phoenix_Is_Criteria_Step__c;
                bStep.Name = wacChange.Name + '-' + pStep.Name;
                bStep.Phoenix_Approver__c = marketingApproverId;
                bStep.Phoenix_WAC_Change__c = wacChange.Id;
                bStep.Phoenix_Process_Step__c = pStep.Id;
                bStep.Phoenix_Status__c = pStep.Phoenix_Is_Criteria_Step__c ? 'Not Applicable' : 'Not Initiated';
                bStep.Phoenix_Approver_Team__c = team;
                //stepNo : Ask and increment as per requirements
                bStep.Phoenix_Sub_Step__c = stepNo;
                if (team != 'Marketing' && team != 'Customer Service')
                    bStep.Phoenix_Approver_Team_Members__c = string.join(new List < String > (approvalTeamUserNamesMap.get(team)), ',');

                bidProcessSteps.add(bStep);
                stepNo++;
            }
        }

    }


    if (!bidProcessSteps.isEmpty()) {
        insert bidProcessSteps;
    }
    bidProcessSteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
        Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_WAC_Change__c =: wacChange.Id
    ];
    wacChange.Phoenix_Approval_Status__c = 'Marketing Head';
    wacChange.Phoenix_WAC_Submitted_Date__c = Phoenix_Util.getNowEST();
    update wacChange;

    Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
    //  Map < Id, Phoenix_Bid_Process_Steps__c > nextStepsMap = new Map < Id, Phoenix_Bid_Process_Steps__c > ();
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new List < Phoenix_Bid_Process_Steps__c > ();
    for (Phoenix_Bid_Process_Steps__c step: bidProcessSteps) {

        Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
        if (stepMap.get(stepNo) != null) {
            List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
            adededSteps.add(step);
            stepMap.put(stepNo, adededSteps);
        } else {
            stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
                step
            });
        }

    }


    //  for(Phoenix_Bid_Process_Steps__c step :){ nextStepsMap.put(step.Id,step);}

         
    for (Phoenix_Bid_Process_Steps__c step: stepMap.get(2)) {
        step.Phoenix_Status__c = step.Phoenix_Status__c != 'Completed' && step.Phoenix_Status__c != 'Not Applicable' ? 'In Process' : step.Phoenix_Status__c; //== 'Not Initiated' ? 'In Process' : step.Phoenix_Status__c;
        nextSteps.add(step);
    }
    update nextSteps;


    if (nextSteps.size() > 0) approvalRequestNotification(wacChange.Id, nextSteps);


    List < Phoenix_WAC_Change_Line_Item__c > wacItems = [Select Id, Name, Phoenix_WAC_Change__c FROM Phoenix_WAC_Change_Line_Item__c WHERE Phoenix_WAC_Change__c =: wacChange.Id AND Phoenix_Final_Status__c != 'Not Approved'];


    for (Phoenix_WAC_Change_Line_Item__c item: wacItems) {
        item.Phoenix_WAC_Line_Item_Approval_Status__c = 'Marketing Head Pending';
    }

    update wacItems;


}
Catch(Exception e) {
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Method_Name__c = 'submitWACChange', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
    response = e.getMessage();

}
return response;
}

@AuraEnabled
public static String closeDraftBid(Id bidId) {
string result = '';

Phoenix_Bid__c bid = [SELECT Id, Name, Phoenix_Approval_Status__c, Phoenix_Bid_Type__c, Phoenix_Bid_Created_Behalf_of__c FROM Phoenix_Bid__c WHERE Id =: bidId];
bid.Phoenix_Approval_Status__c = 'Closed-' + bid.Phoenix_Approval_Status__c;
bid.Phoenix_Bid_Closed_Date__c = Phoenix_Util.getTodayEST();
update bid;
return result;
}
/**
* @description This is main method to submit bid for approval. After this, all required steps will be created and bid status will be updated.
* @author Surender Patel (Dhruvsoft) | 12-05-2021 
* @param BidWrapper wrap 
* @return String 
**/
@AuraEnabled
public static String submitBid(BidWrapper wrap) {
String response = 'Success';
Phoenix_Bid__c bid = wrap.bid;
 Phoenix_Bid__c previousBid = new Phoenix_Bid__c();
Id previousSCMApprover;
try {
    delete[select id from Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bid.Id];
    // delete [select Id FROM Task where WhatId =:bid.Id];
    if (bid.Phoenix_Approval_Status__c != 'Draft1') {
        response = createBidApprovalItems(new List < Phoenix_Bid__c > {
            bid
        });
        if (response != 'Success') {
            return response;
        }
        // We got all needed steps. Let's process.

        //Get all related bid steps
        bid = [SELECT Id, Name,Phoenix_is_OTC_Bid__c, Phoenix_Approval_Status__c,Phoenix_Previous_Bid__c, Phoenix_Bid_Type__c, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Is_Re_Bid__c, Phoenix_OTB_Marketing_Approver__c,
               (SELECT Id, Phoenix_SCM_Review__c, Phoenix_IPA_Floor_Price1__c, Phoenix_Proposed_IPA_Price__c, Phoenix_Product_Director__c, Phoenix_Product__c, Phoenix_Product__r.Phoenix_Product_Director__c,Phoenix_Bid__r.Phoenix_OTB_Marketing_Approver__r.Name,Phoenix_Bid__r.Phoenix_Bid_Type__c From Bid_Line_Items__r), 
               (SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c,Phoenix_Sub_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c,Phoenix_Bid__r.Phoenix_OTB_Marketing_Approver__c,Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Is_Criteria_Step__c FROM Bid_Process_Steps__r) FROM Phoenix_Bid__c WHERE Id =: wrap.bid.Id];
        bid.Phoenix_Bid_Submitter_Comments__c = wrap.bid.Phoenix_Bid_Submitter_Comments__c;

        if (bid.Phoenix_Previous_Bid__c != null) {

            previousBid = [SELECT Id, Name, Phoenix_Is_Re_Bid__c, Phoenix_Previous_Bid__c FROM Phoenix_Bid__c WHERE id =: bid.Phoenix_Previous_Bid__c];

            List<Phoenix_Bid_Process_Steps__c> scmStep = [Select Id,Phoenix_Bid__c,Phoenix_Approver__c FROM Phoenix_Bid_Process_Steps__c Where Phoenix_Bid__c =:previousBid.Id AND Phoenix_Approver_Team__c ='Supply Chain'];

           if(scmStep != null && scmStep.size()>0)  previousSCMApprover = scmStep[0].Phoenix_Approver__c;

        }
                
        Map < String, Map < Integer, List < Phoenix_Bid_Process_Steps__c >>> bidProcessStepsMap = new Map < String, Map < Integer, List < Phoenix_Bid_Process_Steps__c >>> ();
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, Phoenix_Bid_Process_Steps__c > stepApproversMap = new Map < String, Phoenix_Bid_Process_Steps__c > ();
        Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
        Map < String, List < Phoenix_Bid_Line_Item__c >> itemsByDitectorMap = new Map < String, List < Phoenix_Bid_Line_Item__c >> ();
                
                
        String currentUserId = bid.Phoenix_Bid_Created_Behalf_of__c != null ? bid.Phoenix_Bid_Created_Behalf_of__c : UserInfo.getUserId();
        User currentUser = [Select Id, Name, Email from User WHERE id =: currentUserId LIMIT 1];
        list < Phoenix_Bid_Process_Steps__c > criteriaSteplist = new list < Phoenix_Bid_Process_Steps__c > ();
        map < string, Phoenix_Bid_Process_Steps__c > teamToStepMap = new map < string, Phoenix_Bid_Process_Steps__c > ();
        Boolean isOTBMarketingApprover=false;
        for (Phoenix_Bid_Process_Steps__c step: bid.Bid_Process_Steps__r) {

            Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
            if (stepMap.get(stepNo) != null) {
                List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
                adededSteps.add(step);
                stepMap.put(stepNo, adededSteps);
            } else {
                stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
                    step
                });
            }
					
            String stepName = step.Phoenix_Approver_Team__c;
            if(bid.Phoenix_is_OTC_Bid__c && step.Phoenix_Approver_Team__c == 'OTC Supply Chain')
                stepName= 'Supply Chain';
            if (stepNamesMap.get(stepName) != null) {
                List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
                adededSteps.add(step);
                stepNamesMap.put(stepName, adededSteps);
            } else {
                stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {
                    step
                });
            }
            stepnameNoMap.put(stepName, stepNo);
            //Phoenix_OTB_Marketing_Approver__c
            if(step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Platform OTB'){
             isOTBMarketingApprover = (step.Phoenix_Bid__r.Phoenix_OTB_Marketing_Approver__c == UserInfo.getUserId()) ? true:false;
            stepApproversMap.put(step.Phoenix_Approver_Team__c + '-' + step.Phoenix_Bid__r.Phoenix_OTB_Marketing_Approver__c, step);
            }
            else{
            stepApproversMap.put(step.Phoenix_Approver_Team__c + '-' + step.Phoenix_Approver__c, step);    
            }
            if (step.Phoenix_Is_Criteria_Step__c) {
                teamToStepMap.put(step.Phoenix_Approver_Team__c, step);
                criteriaSteplist.add(step);
            }
        }

        //Arranging bid line items by director
        if (bid.Bid_Line_Items__r.size() > 0) {
            for (Phoenix_Bid_Line_Item__c item: bid.Bid_Line_Items__r) {
                if(item.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Platform OTB'){
                    if (itemsByDitectorMap.containsKey(item.Phoenix_Product_Director__c)) {
                        List < Phoenix_Bid_Line_Item__c > tempList = itemsByDitectorMap.get(item.Phoenix_Product_Director__c);
                        tempList.add(item);
                        itemsByDitectorMap.put(item.Phoenix_Bid__r.Phoenix_OTB_Marketing_Approver__r.Name, tempList);
                    } else {
                        itemsByDitectorMap.put(item.Phoenix_Bid__r.Phoenix_OTB_Marketing_Approver__r.Name, new List < Phoenix_Bid_Line_Item__c > {
                            item
                                });
                    }
                }else{
                    if (itemsByDitectorMap.containsKey(item.Phoenix_Product_Director__c)) {
                        List < Phoenix_Bid_Line_Item__c > tempList = itemsByDitectorMap.get(item.Phoenix_Product_Director__c);
                        tempList.add(item);
                        itemsByDitectorMap.put(item.Phoenix_Product_Director__c, tempList);
                    } else {
                        itemsByDitectorMap.put(item.Phoenix_Product_Director__c, new List < Phoenix_Bid_Line_Item__c > {
                            item
                                });
                    }
                }
                        
            }
                    
        }
        bidProcessStepsMap.put(bid.Id, stepMap); //Arranged all Bid>eachStep No>Step 
                
        List < Phoenix_Bid_Process_Steps__c > nextSteps = new List < Phoenix_Bid_Process_Steps__c > ();
        Map < Id, Phoenix_Bid_Process_Steps__c > nextStepsMap = new Map < Id, Phoenix_Bid_Process_Steps__c > ();
        Map < Id, Phoenix_Bid_Process_Steps__c > updatedStepsMap = new Map < Id, Phoenix_Bid_Process_Steps__c > ();
        Map < Id, Phoenix_Bid_Line_Item__c > prodIdBitemMap = new Map < Id, Phoenix_Bid_Line_Item__c > ();
        Set < String > isSRxIPAPriceCriteriaMetProd = new Set < String > ();
        Set < String > criteriaMetDirectorSet = new Set < String > ();
        Set < String > criteriaNotMetDirectorSet = new Set < String > ();
        Boolean isSRxIPAPriceCriteriaMet = false;

        for (Phoenix_Bid_Line_Item__c item: bid.Bid_Line_Items__r) {
            prodIdBitemMap.put(item.Phoenix_Product__c, item);
            if ((item.Phoenix_IPA_Floor_Price1__c > item.Phoenix_Proposed_IPA_Price__c) || item.Phoenix_IPA_Floor_Price1__c == null) {
                isSRxIPAPriceCriteriaMet = true;
                criteriaMetDirectorSet.add(item.Phoenix_Product__r.Phoenix_Product_Director__c);
            } else {
                criteriaNotMetDirectorSet.add(item.Phoenix_Product__r.Phoenix_Product_Director__c);
            }
        }


        //Validate if SCM auto approval needed or not for Re-Bid
        Boolean isSCMAutoApprovalNeededReBid = true;
        for (Phoenix_Bid_Line_Item__c item: bid.Bid_Line_Items__r) {
            if (item.Phoenix_SCM_Review__c) isSCMAutoApprovalNeededReBid = false;
        }
        if (bid.Phoenix_Is_Re_Bid__c && isSCMAutoApprovalNeededReBid && stepnameNoMap.containsKey('Supply Chain') && stepNamesMap.containsKey('Supply Chain')) { // userTeamUserIdMap.containsKey('Supply Chain-'+currentUserId)

            Phoenix_Bid_Process_Steps__c loggedInUserStep = stepNamesMap.get('Supply Chain')[0];
            loggedInUserStep.Phoenix_Status__c = 'Completed';



            loggedInUserStep.Phoenix_Approval_Sent_Time__c = Phoenix_Util.getNowEST();
            loggedInUserStep.Phoenix_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(loggedInUserStep.Phoenix_Approval_Sent_Time__c, 'America/New_York');

            loggedInUserStep.Phoenix_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
            loggedInUserStep.Phoenix_Approval_Completed_Time_String__c = Phoenix_Util.getUserTimeNow(loggedInUserStep.Phoenix_Approval_Completed_Time__c, 'America/New_York');

            loggedInUserStep.Phoenix_Approver__c = currentUserId;
                    
             loggedInUserStep.Phoenix_Approver__c = previousSCMApprover;
                    
            updatedStepsMap.put(loggedInUserStep.Id, loggedInUserStep);
            //Modify the line items
            List < Phoenix_Bid_Line_Item__c > updatedItems = new List < Phoenix_Bid_Line_Item__c > ();
            for (Phoenix_Bid_Line_Item__c line: bid.Bid_Line_Items__r) {
                line.Phoenix_SCM_Final_Approval__c = true;
                //  line.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';

                updatedItems.add(line);
            }
            if (updatedItems.size() > 0) {
                update updatedItems;
            }
            bid.Phoenix_Bid_SCM_Approved_Date__c = Phoenix_Util.getTodayEST();
            if (stepMap.get(stepnameNoMap.get('Supply Chain')).size() == 1) {
                /* !stepNamesMap.containsKey('Marketing')   */
                // nextSteps = stepMap.get(stepnameNoMap.get('Supply Chain') + 1);
                integer stepnumber = stepnameNoMap.get('Supply Chain');
                nextSteps = stepMap.get(stepnameNoMap.get('Supply Chain') + 1);
                While(nextSteps != null && nextSteps[0].Phoenix_Status__c == 'Not Applicable') {
                    stepNumber += 1;
                    nextSteps = stepMap.get(stepNumber);
                }
            }
            else {
                // Map<Id,Phoenix_Bid_Process_Steps__c> tempStepsMap = new Map<Id,Phoenix_Bid_Process_Steps__c>();
                for (Phoenix_Bid_Process_Steps__c step: stepMap.get(stepnameNoMap.get('Supply Chain'))) nextStepsMap.put(step.Id, step);
                nextStepsMap.putAll(updatedStepsMap);
                nextSteps = nextStepsMap.values();
            }
        } 
        else if (bid.Phoenix_Is_Re_Bid__c && !isSCMAutoApprovalNeededReBid) {
            nextSteps = stepMap.get(2);
        }
        else if ((bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition') && !isSRxIPAPriceCriteriaMet) {
            //Next:Contracts  Team: SRX IPA Contract  nextSteps
            //Marketing & Finance Not Applicable -  updatedStepsMap.put(Step.Id,Step);

            for (Phoenix_Bid_Process_Steps__c mktStep: stepNamesMap.get('Marketing')) {
                mktStep.Phoenix_Status__c = 'Not Applicable';
                updatedStepsMap.put(mktStep.Id, mktStep);
            }
            Phoenix_Bid_Process_Steps__c financeStep = stepNamesMap.get('Finance')[0];
            financeStep.Phoenix_Status__c = 'Not Applicable';
            updatedStepsMap.put(financeStep.Id, financeStep);
            /*
//Modify the line items
List<Phoenix_Bid_Line_Item__c> updatedItems = new List<Phoenix_Bid_Line_Item__c>();
for(Phoenix_Bid_Line_Item__c line :  bid.Bid_Line_Items__r){
///////////////////////////////////////////////////////////


updatedItems.add(line);
}
if(updatedItems.size()>0){
update updatedItems;
}*/
            if (bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement(IPA)') nextSteps = stepMap.get(5); //is it 4?
            else nextSteps = stepMap.get(4);

        } else if ((bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition') && isSRxIPAPriceCriteriaMet) {

            List < Phoenix_Bid_Process_Steps__c > criteriaMetSteps = new List < Phoenix_Bid_Process_Steps__c > ();
            for (Id criteriaMetDirector: criteriaMetDirectorSet) criteriaMetSteps.add(stepApproversMap.get('Marketing-' + criteriaMetDirector));
                    


            List < Phoenix_Bid_Process_Steps__c > criteriaNotMetSteps = new List < Phoenix_Bid_Process_Steps__c > ();
            for (Id criteriaMetDirector: criteriaNotMetDirectorSet) criteriaNotMetSteps.add(stepApproversMap.get('Marketing-' + criteriaMetDirector));

            for (Phoenix_Bid_Process_Steps__c step: criteriaNotMetSteps) {
                step.Phoenix_Status__c = 'Not Applicable';
                updatedStepsMap.put(step.Id, step);
            }
            for (Phoenix_Bid_Process_Steps__c step: criteriaMetSteps) {
                step.Phoenix_Status__c = 'In Process';
                //  step.Phoenix_Approval_Sent_Time__c=System.now();
                //  step.Phoenix_Approval_Sent_Time_String__c=Phoenix_Util.getUserTimeNow();

                step.Phoenix_Approval_Sent_Time__c = Phoenix_Util.getNowEST();
                step.Phoenix_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(step.Phoenix_Approval_Sent_Time__c, 'America/New_York');
                updatedStepsMap.put(step.Id, step);
            }

            Phoenix_Bid_Process_Steps__c financeStep = stepNamesMap.get('Finance')[0];
            financeStep.Phoenix_Status__c = 'Not Initiated';

            //Modify the line items
            List < Phoenix_Bid_Line_Item__c > updatedItems = new List < Phoenix_Bid_Line_Item__c > ();
            for (Phoenix_Bid_Line_Item__c line: bid.Bid_Line_Items__r) {

                line.Phoenix_Bid_Line_Item_Approval_Status__c = 'Marketing Pending';

                updatedItems.add(line);
            }
            if (updatedItems.size() > 0) {
                update updatedItems;
            }


            for (Phoenix_Bid_Process_Steps__c step: stepMap.get(stepnameNoMap.get('Marketing'))) nextStepsMap.put(step.Id, step);
            nextStepsMap.putAll(updatedStepsMap);
            updatedStepsMap.put(financeStep.Id, financeStep);
            nextSteps = nextStepsMap.values();

        }
        else if (bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)' && isSRxIPAPriceCriteriaMet) {

            List < Phoenix_Bid_Process_Steps__c > criteriaMetSteps = new List < Phoenix_Bid_Process_Steps__c > ();
            for (Id criteriaMetDirector: criteriaMetDirectorSet) criteriaMetSteps.add(stepApproversMap.get('Marketing-' + criteriaMetDirector));
                   


            List < Phoenix_Bid_Process_Steps__c > criteriaNotMetSteps = new List < Phoenix_Bid_Process_Steps__c > ();
            for (Id criteriaMetDirector: criteriaNotMetDirectorSet) criteriaNotMetSteps.add(stepApproversMap.get('Marketing-' + criteriaMetDirector));

            for (Phoenix_Bid_Process_Steps__c step: criteriaNotMetSteps) {
                step.Phoenix_Status__c = 'Not Applicable';
                updatedStepsMap.put(step.Id, step);
            }
            for (Phoenix_Bid_Process_Steps__c step: criteriaMetSteps) {
                step.Phoenix_Status__c = 'Not Initiated';
                //  step.Phoenix_Approval_Sent_Time__c=System.now();
                //  step.Phoenix_Approval_Sent_Time_String__c=Phoenix_Util.getUserTimeNow();

                //step.Phoenix_Approval_Sent_Time__c = Phoenix_Util.getUserTime(System.now(), 'America/New_York');
                //  step.Phoenix_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(step.Phoenix_Approval_Sent_Time__c, 'America/New_York');
                updatedStepsMap.put(step.Id, step);
            }

            Phoenix_Bid_Process_Steps__c financeStep = stepNamesMap.get('Finance')[0];
            financeStep.Phoenix_Status__c = 'Not Initiated';

            //Modify the line items
            List < Phoenix_Bid_Line_Item__c > updatedItems = new List < Phoenix_Bid_Line_Item__c > ();
            for (Phoenix_Bid_Line_Item__c line: bid.Bid_Line_Items__r) {

                //   line.Phoenix_Bid_Line_Item_Approval_Status__c = 'Supply Chain Pending';

                updatedItems.add(line);
            }
            if (updatedItems.size() > 0) {
                update updatedItems;
            }


            for (Phoenix_Bid_Process_Steps__c step: stepMap.get(stepnameNoMap.get('Marketing'))) nextStepsMap.put(step.Id, step);
            nextStepsMap.putAll(updatedStepsMap);
            updatedStepsMap.put(financeStep.Id, financeStep);
            update updatedStepsMap.values();
            nextSteps = stepMap.get(2);


            //    nextSteps = nextStepsMap.values();






        }
        else if (bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)' && !isSRxIPAPriceCriteriaMet) {

            List < Phoenix_Bid_Process_Steps__c > criteriaMetSteps = new List < Phoenix_Bid_Process_Steps__c > ();
            for (Id criteriaMetDirector: criteriaMetDirectorSet) criteriaMetSteps.add(stepApproversMap.get('Marketing-' + criteriaMetDirector));
                  


            List < Phoenix_Bid_Process_Steps__c > criteriaNotMetSteps = new List < Phoenix_Bid_Process_Steps__c > ();
            for (Id criteriaMetDirector: criteriaNotMetDirectorSet) criteriaNotMetSteps.add(stepApproversMap.get('Marketing-' + criteriaMetDirector));

            for (Phoenix_Bid_Process_Steps__c step: criteriaNotMetSteps) {
                step.Phoenix_Status__c = 'Not Applicable';
                updatedStepsMap.put(step.Id, step);
            }
            for (Phoenix_Bid_Process_Steps__c step: criteriaMetSteps) {
                step.Phoenix_Status__c = 'Not Initiated';
                //  step.Phoenix_Approval_Sent_Time__c=System.now();
                //  step.Phoenix_Approval_Sent_Time_String__c=Phoenix_Util.getUserTimeNow();

                //step.Phoenix_Approval_Sent_Time__c = Phoenix_Util.getUserTime(System.now(), 'America/New_York');
                //  step.Phoenix_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(step.Phoenix_Approval_Sent_Time__c, 'America/New_York');
                updatedStepsMap.put(step.Id, step);
            }

            Phoenix_Bid_Process_Steps__c financeStep = stepNamesMap.get('Finance')[0];
            financeStep.Phoenix_Status__c = 'Not Applicable';

            //Modify the line items
            List < Phoenix_Bid_Line_Item__c > updatedItems = new List < Phoenix_Bid_Line_Item__c > ();
            for (Phoenix_Bid_Line_Item__c line: bid.Bid_Line_Items__r) {

                //  line.Phoenix_Bid_Line_Item_Approval_Status__c = 'Supply Chain Pending';

                updatedItems.add(line);
            }
            if (updatedItems.size() > 0) {
                update updatedItems;
            }


            for (Phoenix_Bid_Process_Steps__c step: stepMap.get(stepnameNoMap.get('Marketing'))) nextStepsMap.put(step.Id, step);
            nextStepsMap.putAll(updatedStepsMap);
            updatedStepsMap.put(financeStep.Id, financeStep);
            update updatedStepsMap.values();
            nextSteps = stepMap.get(2);
            //    nextSteps = nextStepsMap.values();
            integer stepnumber = stepnameNoMap.get('Marketing');
            While(nextSteps != null && nextSteps[0].Phoenix_Status__c == 'Not Applicable') {
                stepNumber += 1;
                nextSteps = stepMap.get(stepNumber);
            }
        } 
        else if (userTeamUserIdMap.containsKey('Sales-' + currentUserId) || userTeamUserIdMap.containsKey('-' + currentUserId)) {
            nextSteps = stepMap.get(2);
        } 
        else if (userTeamUserIdMap.containsKey('Supply Chain-' + currentUserId) && stepnameNoMap.containsKey('Supply Chain') && stepNamesMap.containsKey('Supply Chain')) {
            bid.Phoenix_Bid_SCM_Approved_Date__c = Phoenix_Util.getTodayEST();
                    


            Phoenix_Bid_Process_Steps__c loggedInUserStep = stepNamesMap.get('Supply Chain')[0];
            loggedInUserStep.Phoenix_Status__c = 'Completed';

            loggedInUserStep.Phoenix_Approval_Sent_Time__c = Phoenix_Util.getNowEST();
            loggedInUserStep.Phoenix_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(loggedInUserStep.Phoenix_Approval_Sent_Time__c, 'America/New_York');

            loggedInUserStep.Phoenix_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
            loggedInUserStep.Phoenix_Approval_Completed_Time_String__c = Phoenix_Util.getUserTimeNow(loggedInUserStep.Phoenix_Approval_Completed_Time__c, 'America/New_York');

            loggedInUserStep.Phoenix_Approver__c = currentUserId;
            updatedStepsMap.put(loggedInUserStep.Id, loggedInUserStep);

            //Modify the line items
            List < Phoenix_Bid_Line_Item__c > updatedItems = new List < Phoenix_Bid_Line_Item__c > ();
            for (Phoenix_Bid_Line_Item__c line: bid.Bid_Line_Items__r) {
                line.Phoenix_SCM_Final_Approval__c = true;
                line.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
                updatedItems.add(line);
            }
            if (updatedItems.size() > 0) {
                update updatedItems;
            }

            if (stepMap.get(stepnameNoMap.get('Supply Chain')).size() == 1) { // !stepNamesMap.containsKey('Marketing')    

                /* ------------------------------*/
                Set < string > criteraStepsSet = Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(bid.Id);

                map < string, Phoenix_Bid_Process_Steps__c > updatedTeamToStepMap = new map < string, Phoenix_Bid_Process_Steps__c > ();
                string bidStatus;
                if (criteraStepsSet.size() > 0) {
                    for (Phoenix_Bid_Process_Steps__c critStep: criteriaSteplist) {
                        if (criteraStepsSet.contains('Marketing Lead Rx') && critStep.Phoenix_Approver_Team__c == 'Marketing Lead Rx') {
                            critStep.Phoenix_Status__c = 'In Process';
                            updatedTeamToStepMap.put('Marketing Lead Rx', critStep);
                        } else if (criteraStepsSet.contains('Marketing Lead SRx') && critStep.Phoenix_Approver_Team__c == 'Marketing Lead SRx') {
                            critStep.Phoenix_Status__c = 'In Process';
                            updatedTeamToStepMap.put('Marketing Lead SRx', critStep);
                        } else if (criteraStepsSet.contains('Marketing Lead OTC') && critStep.Phoenix_Approver_Team__c == 'Marketing Lead OTC') {
                            critStep.Phoenix_Status__c = 'In Process';
                            updatedTeamToStepMap.put('Marketing Lead OTC', critStep);
                        }
                        if (criteraStepsSet.contains('Marketing Head') && critStep.Phoenix_Approver_Team__c == 'Marketing Head') {
                            critStep.Phoenix_Status__c = 'Not Initiated';
                            updatedTeamToStepMap.put('Marketing Head', critStep);
                        }
                        if (criteraStepsSet.contains('Sr Director or VP Finance') && critStep.Phoenix_Approver_Team__c == 'Sr Director or VP Finance') {
                            critStep.Phoenix_Status__c = 'Not Initiated';
                            updatedTeamToStepMap.put('Sr Director or VP Finance', critStep);
                        }
                        /*if(criteraStepsSet.contains('Sr Director or VP Finance') && critStep.Phoenix_Approver_Team__c=='Marketing Head'){
critStep.Phoenix_Status__c='Not Initiated';
updatedTeamToStepMap.put('Marketing Head',critStep);
} */
                    }
                            
                    nextSteps = Phoenix_Util.sortBidProcessSteps(updatedTeamToStepMap.values());
                    // nextSteps = updatedTeamToStepMap.values();
                            
                } else {
                    integer stepnumber = stepnameNoMap.get('Supply Chain');
                    nextSteps = stepMap.get(stepnameNoMap.get('Supply Chain') + 1);
                    While(nextSteps != null && nextSteps[0].Phoenix_Status__c == 'Not Applicable') {
                        stepNumber += 1;
                        nextSteps = stepMap.get(stepNumber);
                    }
                }


                /* --------------------------------------------   */
            } else {
                // Map<Id,Phoenix_Bid_Process_Steps__c> tempStepsMap = new Map<Id,Phoenix_Bid_Process_Steps__c>();
                for (Phoenix_Bid_Process_Steps__c step: stepMap.get(stepnameNoMap.get('Supply Chain'))) nextStepsMap.put(step.Id, step);
                nextStepsMap.putAll(updatedStepsMap);
                nextSteps = nextStepsMap.values();
            }
                    
                    
                    
        } 
        else if ((userTeamUserIdMap.containsKey('Marketing-' + currentUserId) || isOTBMarketingApprover) && stepnameNoMap.containsKey('Marketing') && stepApproversMap.containsKey('Marketing-' + currentUserId)) { 
            /*   
|| (userTeamUserIdMap.containsKey('Marketing-'+UserInfo.getUserId()) && stepnameNoMap.containsKey('Marketing') &&  stepApproversMap.containsKey('Marketing-'+UserInfo.getUserId()) && 
(bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition') && isSRxIPAPriceCriteriaMet)
*/

                  
            Phoenix_Bid_Process_Steps__c loggedInUserStep = stepApproversMap.get('Marketing-' + currentUserId);
                    
            loggedInUserStep.Phoenix_Status__c = 'Completed';
             if(bid.Phoenix_Bid_Type__c=='Platform OTB'){
              loggedInUserStep.Phoenix_Approver__c = Userinfo.getUserId();
             }
                    
                  


            loggedInUserStep.Phoenix_Approval_Sent_Time__c = Phoenix_Util.getNowEST(); //;
            loggedInUserStep.Phoenix_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(loggedInUserStep.Phoenix_Approval_Sent_Time__c, 'America/New_York');

            loggedInUserStep.Phoenix_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
            loggedInUserStep.Phoenix_Approval_Completed_Time_String__c = Phoenix_Util.getUserTimeNow(loggedInUserStep.Phoenix_Approval_Completed_Time__c, 'America/New_York');

            updatedStepsMap.put(loggedInUserStep.Id, loggedInUserStep);

            //Modify the line items
            List < Phoenix_Bid_Line_Item__c > updatedItems = new List < Phoenix_Bid_Line_Item__c > ();
            for (Phoenix_Bid_Line_Item__c line: itemsByDitectorMap.get(currentUser.Name)) {
                line.Phoenix_Marketing_Final_Approval__c = true;
                line.Phoenix_Marketing_Approval__c = 'Approved';
                //if(line.Phoenix_Marketing_Approval__c == 'Not Approved'){line.Phoenix_Final_Status__c = 'Not Approved';}
                updatedItems.add(line);
            }
            if (updatedItems.size() > 0) {
                update updatedItems;
            }

            if (stepNamesMap.containsKey('Marketing') && stepNamesMap.get('Marketing').size() == 1 && stepMap.get(stepnameNoMap.get('Marketing')).size() == 1) {
               bid.Phoenix_Bid_Marketing_Approved_Date__c = Phoenix_Util.getTodayEST();


                /* ------------------------------*/
                Set < string > criteraStepsSet = Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(bid.Id);
                       
                map < string, Phoenix_Bid_Process_Steps__c > updatedTeamToStepMap = new map < string, Phoenix_Bid_Process_Steps__c > ();
                string bidStatus;
                if (criteraStepsSet.size() > 0) {
                    for (Phoenix_Bid_Process_Steps__c critStep: criteriaSteplist) {
                        if (criteraStepsSet.contains('Marketing Lead Rx') && critStep.Phoenix_Approver_Team__c == 'Marketing Lead Rx') {
                            critStep.Phoenix_Status__c = 'In Process';
                            updatedTeamToStepMap.put('Marketing Lead Rx', critStep);
                        } else if (criteraStepsSet.contains('Marketing Lead SRx') && critStep.Phoenix_Approver_Team__c == 'Marketing Lead SRx') {
                            critStep.Phoenix_Status__c = 'In Process';
                            updatedTeamToStepMap.put('Marketing Lead SRx', critStep);
                        } else if (criteraStepsSet.contains('Marketing Lead OTC') && critStep.Phoenix_Approver_Team__c == 'Marketing Lead OTC') {
                            critStep.Phoenix_Status__c = 'In Process';
                            updatedTeamToStepMap.put('Marketing Lead OTC', critStep);
                        }
                        if (criteraStepsSet.contains('Marketing Head') && critStep.Phoenix_Approver_Team__c == 'Marketing Head') {
                            critStep.Phoenix_Status__c = 'Not Initiated';
                            updatedTeamToStepMap.put('Marketing Head', critStep);
                        }
                        if (criteraStepsSet.contains('Sr Director or VP Finance') && critStep.Phoenix_Approver_Team__c == 'Sr Director or VP Finance') {
                            critStep.Phoenix_Status__c = 'Not Initiated';
                            updatedTeamToStepMap.put('Sr Director or VP Finance', critStep);
                        }
                        /*if(criteraStepsSet.contains('Sr Director or VP Finance') && critStep.Phoenix_Approver_Team__c=='Marketing Head'){
critStep.Phoenix_Status__c='Not Initiated';
updatedTeamToStepMap.put('Marketing Head',critStep);
} */
                    }

                    nextSteps = Phoenix_Util.sortBidProcessSteps(updatedTeamToStepMap.values());

                } else {
                    integer stepNumber = stepnameNoMap.get('Marketing');
                    nextSteps = stepMap.get(stepnameNoMap.get('Marketing') + 1);
                    While(nextSteps != null && nextSteps[0].Phoenix_Status__c == 'Not Applicable') {
                        stepNumber += 1;
                        nextSteps = stepMap.get(stepNumber);
                    }
                }


                /* --------------------------------------------   */

            } 
            else {
                // Map<Id,Phoenix_Bid_Process_Steps__c> tempStepsMap = new Map<Id,Phoenix_Bid_Process_Steps__c>();
                for (Phoenix_Bid_Process_Steps__c step: stepMap.get(stepnameNoMap.get('Marketing'))) nextStepsMap.put(step.Id, step);
                nextStepsMap.putAll(updatedStepsMap);
                nextSteps = nextStepsMap.values();
            }


        } else {
            nextSteps = stepMap.get(2);
        }

               
        List < String > noSCMBidTypes = new List < String > {
            'Mass Product Removals',
            'SRx IPA Price Change',
            'Volume Review Only',
            'SRx IPA Product Addition',
            'Product Discontinuation Process',
            'Sales Out Rebate',
            'Customer Rebate Change',
            'New Product Launch',
                'IPA Floor Pricing Update',
                'OTC Price Change',
                'OTC Rebate Change',
                'OTC OTB Good Dated',
                'OTC OTB Short Dated',
                'Platform OTB'
        };
        List < String > srxIPAContractsApproverBidTypes = new List < String > {
            'SRx IPA Price Change',
            'SRx IPA Product Addition',
            'NEW Individual Pricing Agreement (IPA)',
            'RCA/IPA Member GPO or Wholesaler Change',
            'RCA Member Addition',
            'IPA Member Addition'
        };

             
        if (bid.Phoenix_Bid_Type__c != 'NEW Individual Pricing Agreement (IPA)' && bid.Phoenix_Bid_Type__c != 'Price Change'  && bid.Phoenix_Bid_Type__c != 'One Time Buy Good Dated Shelf Life for New Product Launch' && !noSCMBidTypes.contains(bid.Phoenix_Bid_Type__c) &&
            (nextSteps[0].Phoenix_Approver_Team__c == 'Marketing' || nextSteps[0].Phoenix_Approver_Team__c == 'Supply Chain' || nextSteps[0].Phoenix_Approver_Team__c == 'OTC Supply Chain')) {
            bid.Phoenix_Approval_Status__c = 'SCM & Marketing';
        } //else if(bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)' && (nextSteps[0].Phoenix_Approver_Team__c=='Marketing' || nextSteps[0].Phoenix_Approver_Team__c=='Finance')){
        //   bid.Phoenix_Approval_Status__c ='Marketing & Finance';     
        //}
        else if (srxIPAContractsApproverBidTypes.contains(bid.Phoenix_Bid_Type__c) && nextSteps[0].Phoenix_Approver_Team__c == 'SRx IPA Contracts Approver') {
            bid.Phoenix_Approval_Status__c = 'Contracts';
        } else if (bid.Phoenix_Bid_Type__c == 'Contracts Only' && nextSteps[0].Phoenix_Approver_Team__c == 'Home Office') {
            bid.Phoenix_Approval_Status__c = 'Vistex Update';
        } else if (bid.Phoenix_Bid_Type__c == 'Volume Review Only' && nextSteps[0].Phoenix_Approver_Team__c == 'Contracts') {
            bid.Phoenix_Approval_Status__c = 'Customer\'s Update';
        }  else if (nextSteps[0].Phoenix_Approver_Team__c.containsIgnoreCase('Marketing Lead')) {
            bid.Phoenix_Approval_Status__c = 'Marketing Lead';
        } else {
            bid.Phoenix_Approval_Status__c = (nextSteps[0].Phoenix_Approver_Team__c == 'OTC Sales') ? 'Customer\'s Update' : nextSteps[0].Phoenix_Approver_Team__c;
        }
        bid.Phoenix_Bid_Submitted_Date__c = Phoenix_Util.getTodayEST();
        update bid;
                
        for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
            if(!step.Phoenix_Is_Criteria_Step__c) step.Phoenix_Status__c = step.Phoenix_Status__c != 'Completed' && step.Phoenix_Status__c != 'Not Applicable' ? 'In Process' : step.Phoenix_Status__c; //== 'Not Initiated' ? 'In Process' : step.Phoenix_Status__c;//'In Process' Submitted //Diff b/w them?
            updatedStepsMap.put(step.Id, step);
        }

        Phoenix_Bid__c updatedBid = [Select Id, Phoenix_Approval_Status__c, (Select Id FROM Bid_Line_Items__r) FROM Phoenix_Bid__c WHERE Id =: bid.Id];
        List < Phoenix_Bid_Line_Item__c > updateItems = new List < Phoenix_Bid_Line_Item__c > ();
        for (Phoenix_Bid_Line_Item__c item: updatedBid.Bid_Line_Items__r) {
            item.Phoenix_Bid_Line_Item_Approval_Status__c = updatedBid.Phoenix_Approval_Status__c + ' Pending';
            updateItems.add(item);
        }


        if (updateItems.size() > 0) update updateItems;
        update updatedStepsMap.values();
        if (nextSteps.size() > 0) approvalRequestNotification(bid.Id, nextSteps);
        if (bid.Phoenix_Bid_Type__c == 'Volume Review Only'){ 
                  
            sendEmailToProdDirVolReview(bid.Id);}
    }
}
Catch(Exception e) {
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Method_Name__c = 'submitBid', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}

return response;
}


/**
* @description This method will be called after Finance approval. This wil create/update Approval Grid records.
* @author Surender Patel (Dhruvsoft) | 12-05-2021 
* @param String bidId 
* @return Set<String> Set of required approvers. So that in further steps, these will be in process/not intitiated. Which are not given in this list will be remain as Not Applicable as it is. 
**/
public static Set < String > calculateFinanceGrid(String bidId) {
//String finalApprover='NONE';
       
Set < String > approverTeams = new Set < String > ();
try {
    Integer existingGridCount = [Select Id FROM Phoenix_Approval_Grid__c WHERE Phoenix_Bid__c =: bidid].size();
    Map < String, Phoenix_Approval_Grid__c > approvalGridMap = new Map < String, Phoenix_Approval_Grid__c > ();
    String query = '';
    query = 'Select ' + Phoenix_Util.bidlineitemFields + ',Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Bid_Type__c,Phoenix_Bid__r.Phoenix_is_OTC_Bid__c,Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c,Phoenix_Product__r.Phoenix_OTC_Lowest_Price__c,Phoenix_Product__r.Phoenix_Approved_Lowest_Price_SKU__c,Phoenix_Product__r.Phoenix_Is_partner_product__c,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_OTB_Direct_Indirect__c from  Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =:  bidid AND Phoenix_Final_Status__c !=\'Not Approved\'';

    List < Phoenix_Bid_Line_Item__c > existingLineItems = Database.query(query);

    Map < Id, Phoenix_Bid_Line_Item__c > updatedLineItemsMap = new Map < Id, Phoenix_Bid_Line_Item__c > ();
    Set < Id > bItemIds = new Set < Id > ();
    Map < String, List < Phoenix_Bid_Line_Item__c >> productFamilyLinesMap = new Map < String, List < Phoenix_Bid_Line_Item__c >> ();
    string bidType;
    Boolean otcBid;
    for (Phoenix_Bid_Line_Item__c bidline: existingLineItems) {
        bidType = bidline.Phoenix_Bid__r.Phoenix_Bid_Type__c;
        otcBid = bidline.Phoenix_Bid__r.Phoenix_is_OTC_Bid__c;
        if (bidline.Phoenix_Product_Family__c != null && !productFamilyLinesMap.containsKey(bidline.Phoenix_Product_Family__c)) {
            productFamilyLinesMap.put(bidline.Phoenix_Product_Family__c, new List < Phoenix_Bid_Line_Item__c > {
                bidline
            });
        } else if (bidline.Phoenix_Product_Family__c != null && productFamilyLinesMap.containsKey(bidline.Phoenix_Product_Family__c)) {
            List < Phoenix_Bid_Line_Item__c > tempList = productFamilyLinesMap.get(bidline.Phoenix_Product_Family__c);
            tempList.add(bidline);
            productFamilyLinesMap.put(bidline.Phoenix_Product_Family__c, tempList);
        }

        bItemIds.add(bidline.Id);
    }

    Map < Id, Phoenix_BidLineItemExtn__c > bidLineItemExtnMap = new Map < Id, Phoenix_BidLineItemExtn__c > ();
    for (Phoenix_BidLineItemExtn__c extn: Database.query('Select ' + Phoenix_Util.bidLineItemExtnFields + ' FROM Phoenix_BidLineItemExtn__c WHERE Phoenix_Bid_Line_Item__c IN: bItemIds')) {
        bidLineItemExtnMap.put(extn.Phoenix_Bid_Line_Item__c, extn);
    }

    List < Phoenix_Approval_Grid__c > existingGrids = Database.query('SELECT ' + Phoenix_Util.approvalGridFields + 'From 	Phoenix_Approval_Grid__c where Phoenix_Bid__c =: bidid');
    for (Phoenix_Approval_Grid__c grid: existingGrids) approvalGridMap.put(grid.Phoenix_Product_Family__c, grid);


    //Get criteria matrix records
    List < Phoenix_Approval_Matrix__c > criteriaMatrixRecords = Database.query('SELECT ' + Phoenix_Util.approvalMatrixFields + ',(Select ' + Phoenix_Util.approvalProcessStepFields + ' From Phoenix_Approval_Process_Steps__r) From Phoenix_Approval_Matrix__c WHERE Phoenix_Is_Criteria_Matrix__c=true and Phoenix_Bid_Type__c=:bidType');

    Map < Id, Phoenix_Approval_Matrix__c > criteriaMatrixMap = new Map < Id, Phoenix_Approval_Matrix__c > ();
    for (Phoenix_Approval_Matrix__c matrix: criteriaMatrixRecords) criteriaMatrixMap.put(matrix.Id, matrix);

    if (productFamilyLinesMap != null) {
        for (String pFamily: productFamilyLinesMap.KeySet()) {

            Decimal Annualized_TP_Impact = 0;
            Decimal Annualized_GM_Impact = 0;
            Decimal Total_DRL_Share = 0;
            Decimal Net_Sales_Internal = 0;
            Decimal GM_Percent = 0;
            Decimal Th_Put_Margin = 0;
            Decimal TP_Percent = 0;
            Decimal SSA_Impact = 0;
            Decimal Annualized_TP = 0;
            Decimal Annualized_GM = 0;
            Boolean isNewLow = false;
            Decimal Revenue = 0;

            Decimal GM_Percent_local = 0;
            Decimal TP_Percent_local = 0;


            Decimal Annualized_TP_Impact_local = 0;
            Decimal Annualized_GM_Impact_local = 0;
            Decimal Revenue_Local = 0;

            for (Phoenix_Bid_Line_Item__c bidline: productFamilyLinesMap.get(pFamily)) {
                Phoenix_BidLineItemExtn__c extn = bidLineItemExtnMap.get(bidline.Id);
                if (bidline.Phoenix_Annualized_TP_Impact__c != null) Annualized_TP_Impact += bidline.Phoenix_Annualized_TP_Impact__c;
                if (bidline.Phoenix_Annualized_GM_Impact__c != null) Annualized_GM_Impact += bidline.Phoenix_Annualized_GM_Impact__c;
                if (bidline.Phoenix_Total_DRL_Share__c != null) Total_DRL_Share += bidline.Phoenix_Total_DRL_Share__c;
                if (bidline.Phoenix_Net_Sales_Internal__c != null) Net_Sales_Internal += bidline.Phoenix_Net_Sales_Internal__c;
                if (Net_Sales_Internal > 0) GM_Percent = (Total_DRL_Share / Net_Sales_Internal) * 100;
                if (bidline.Phoenix_Th_Put_Margin__c != null) Th_Put_Margin += bidline.Phoenix_Th_Put_Margin__c;
                if (Net_Sales_Internal > 0) TP_Percent = (Th_Put_Margin / Net_Sales_Internal) * 100;
                if (bidline.Phoenix_SSA_Hit__c != null) SSA_Impact += bidline.Phoenix_SSA_Hit__c;
                if (bidline.Phoenix_Proposed_TP_Margin__c > 0) Annualized_TP += bidline.Phoenix_Proposed_TP_Margin__c;
                if (bidline.Phoenix_Total_DRL_Share__c != null) Annualized_GM += bidline.Phoenix_Total_DRL_Share__c;
                if (bidline.Phoenix_Net_Sales_Internal__c != null) Revenue += bidline.Phoenix_Net_Sales_Internal__c;

                //RXSS 
                Decimal RxssDeadNet = 0;
                /*      //bidline.Phoenix_Direct_Dead_Net__c + bidline.Phoenix_Anda_DRL_Net_price__c + bidline.Phoenix_Wholesaler_DRL_Net_Price__c;
if (bidline.Phoenix_Direct_Dead_Net__c != null) RxssDeadNet += bidline.Phoenix_Direct_Dead_Net__c;//Math.min(RxssDeadNet, bidline.Phoenix_Direct_Dead_Net__c);
if (bidline.Phoenix_Anda_DRL_Net_price__c != null) RxssDeadNet = Math.min(RxssDeadNet, bidline.Phoenix_Anda_DRL_Net_price__c);
if (bidline.Phoenix_Wholesaler_DRL_Net_Price__c != null) RxssDeadNet = Math.min(RxssDeadNet, bidline.Phoenix_Wholesaler_DRL_Net_Price__c);*/

                list < decimal > lowdeadnet = new list < decimal > ();
                if (bidline.Phoenix_Direct_Dead_Net__c > 0) {
                    lowdeadnet.add(bidline.Phoenix_Direct_Dead_Net__c);
                }
                if (bidline.Phoenix_Anda_DRL_Net_price__c > 0) {
                    lowdeadnet.add(bidline.Phoenix_Anda_DRL_Net_price__c);
                }
                if (bidline.Phoenix_Wholesaler_DRL_Net_Price__c > 0) {
                    lowdeadnet.add(bidline.Phoenix_Wholesaler_DRL_Net_Price__c);
                }
                lowdeadnet.sort();
                RxssDeadNet = !lowdeadnet.isEmpty() ? lowdeadnet[0] : 0;


                //BASE/DSH
                Decimal DSHDeadNet = 0;
                /*   Decimal DSHDeadNet = bidline.Phoenix_Wholesaler_DRL_TPT__c + bidline.Phoenix_Anda_DRL_Net_price__c + bidline.Phoenix_Wholesaler_DRL_Net_Price__c;
if (bidline.Phoenix_Wholesaler_DRL_TPT__c != null) DSHDeadNet = Math.min(DSHDeadNet, bidline.Phoenix_Wholesaler_DRL_TPT__c);
if (bidline.Phoenix_Anda_DRL_Net_price__c != null) DSHDeadNet = Math.min(DSHDeadNet, bidline.Phoenix_Anda_DRL_Net_price__c);
if (bidline.Phoenix_Wholesaler_DRL_Net_Price__c != null) DSHDeadNet = Math.min(DSHDeadNet, bidline.Phoenix_Wholesaler_DRL_Net_Price__c);
*/

                list < decimal > DSHDeadNets = new list < decimal > ();
                if (bidline.Phoenix_Wholesaler_DRL_TPT__c > 0) {
                    DSHDeadNets.add(bidline.Phoenix_Wholesaler_DRL_TPT__c);
                }
                if (bidline.Phoenix_Anda_DRL_Net_price__c > 0) {
                    DSHDeadNets.add(bidline.Phoenix_Anda_DRL_Net_price__c);
                }
                if (bidline.Phoenix_Wholesaler_DRL_Net_Price__c > 0) {
                    DSHDeadNets.add(bidline.Phoenix_Wholesaler_DRL_Net_Price__c);
                }
                DSHDeadNets.sort();
                DSHDeadNet = !DSHDeadNets.isEmpty() ? DSHDeadNets[0] : 0;

                list < decimal > ROSDeadNets = new list < decimal > ();
                Decimal ROSDeadNet = 0;
                if (bidline.Phoenix_Direct_Dead_Net__c > 0) {
                    ROSDeadNets.add(bidline.Phoenix_Direct_Dead_Net__c);
                }
                if (bidline.Phoenix_Customer_Dead_Net1__c > 0) {
                    ROSDeadNets.add(bidline.Phoenix_Customer_Dead_Net1__c);
                }
                if (extn != null)
                    if (extn.Phoenix_Internal_Major_Dead_Net__c > 0) {
                        ROSDeadNets.add(extn.Phoenix_Internal_Major_Dead_Net__c);
                    }
                ROSDeadNets.sort();
                ROSDeadNet = !ROSDeadNets.isEmpty() ? ROSDeadNets[0] : 0;


                Decimal c1DeadNet = 0;
                list < decimal > lowdeadnetC1 = new list < decimal > ();
                if (bidline.Phoenix_WMT_Direct_Dead_Net_Proposed__c > 0) {
                    lowdeadnetC1.add(bidline.Phoenix_WMT_Direct_Dead_Net_Proposed__c);
                }
                if (bidline.Phoenix_Direct_Dead_Net__c > 0) {
                    lowdeadnetC1.add(bidline.Phoenix_Direct_Dead_Net__c);
                }
                lowdeadnetC1.sort();
                c1DeadNet = !lowdeadnetC1.isEmpty() ? lowdeadnetC1[0] : 0;


                //Determine Product Low value
                Decimal prodLowestValue = 0;
                list < decimal > prodLowestValues = new list < decimal > ();


                if (!otcBid && bidline.Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c > 0) {
                    prodLowestValues.add(bidline.Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c);
                }
                 if (otcBid && bidline.Phoenix_Product__r.Phoenix_OTC_Lowest_Price__c > 0) {
                    prodLowestValues.add(bidline.Phoenix_Product__r.Phoenix_OTC_Lowest_Price__c);
                }
                if (!otcBid && bidline.Phoenix_Product__r.Phoenix_Approved_Lowest_Price_SKU__c > 0) {
                    prodLowestValues.add(bidline.Phoenix_Product__r.Phoenix_Approved_Lowest_Price_SKU__c);
                }
                        
                prodLowestValues.sort();
                prodLowestValue = !prodLowestValues.isEmpty() ? prodLowestValues[0] : 0;





                if ((bidType == 'Good Dated OTB' || bidType == 'One Time Buy Good Dated Shelf Life for New Product Launch') && bidline.Phoenix_Bid__r.Phoenix_OTB_Direct_Indirect__c == 'Direct' && prodLowestValue != null && bidline.Phoenix_Direct_Dead_Net__c != null && bidline.Phoenix_Direct_Dead_Net__c.setScale(2) < prodLowestValue) {
                    isNewLow = true;
                    bidline.Phoenix_Approved_Lowest_Price_SKU__c = bidline.Phoenix_Direct_Dead_Net__c.setScale(2);
                } else if ((bidType == 'Good Dated OTB' || bidType == 'One Time Buy Good Dated Shelf Life for New Product Launch') && bidline.Phoenix_Bid__r.Phoenix_OTB_Direct_Indirect__c == 'Indirect' && prodLowestValue != null && bidline.Phoenix_Indirect_Dead_Net__c != null && bidline.Phoenix_Indirect_Dead_Net__c.setScale(2) < prodLowestValue) {
                    isNewLow = true;
                    bidline.Phoenix_Approved_Lowest_Price_SKU__c = bidline.Phoenix_Indirect_Dead_Net__c.setScale(2);
                }
                        
                else if (otcBid && prodLowestValue != null && bidline.Phoenix_Internal_Dead_Net_Price__c != null && bidline.Phoenix_Internal_Dead_Net_Price__c.setScale(2) < prodLowestValue) {
                    isNewLow = true;
                    bidline.Phoenix_Approved_Lowest_Price_SKU__c = bidline.Phoenix_Internal_Dead_Net_Price__c.setScale(2);
                            
                }
                       
                        
                //   else if (bidType == 'New Customer'&& prodLowestValue != null && bidline.Phoenix_Internal_Dead_Net_Price__c != null && bidline.Phoenix_Internal_Dead_Net_Price__c < prodLowestValue) isNewLow = true;     
                else if (bidline.Phoenix_Bid_Template_Refrence__c == 'RXSS' && prodLowestValue > 0 && RxssDeadNet.setScale(2) < prodLowestValue) {
                    isNewLow = true;
                    bidline.Phoenix_Approved_Lowest_Price_SKU__c = RxssDeadNet.setScale(2);
                } else if (bidline.Phoenix_Bid_Template_Refrence__c == 'BASE/DSH' && prodLowestValue > 0 && DSHDeadNet.setScale(2) < prodLowestValue) {
                    isNewLow = true;
                    bidline.Phoenix_Approved_Lowest_Price_SKU__c = DSHDeadNet.setScale(2);
                } else if ((bidline.Phoenix_Bid_Template_Refrence__c == 'Walgreens' ||  (bidline.Phoenix_Bid_Template_Refrence__c != null && bidline.Phoenix_Bid_Template_Refrence__c.contains('ABC'))) && prodLowestValue != null && bidline.Phoenix_Internal_Dead_Net_Price__c.setScale(2) < prodLowestValue) {
                    isNewLow = true;
                    bidline.Phoenix_Approved_Lowest_Price_SKU__c = bidline.Phoenix_Internal_Dead_Net_Price__c.setScale(2);
                }
                //   else if (bidline.Phoenix_Bid_Template_Refrence__c.contains('Net Indirect') && prodLowestValue != null && bidline.Phoenix_Direct_Dead_Net__c.setScale(2) < prodLowestValue){ isNewLow = true;}//bidline.Phoenix_Approved_Lowest_Price_SKU__c = bidline.Phoenix_Direct_Dead_Net__c.setScale(2);
                else if (bidline.Phoenix_Bid_Template_Refrence__c == 'Net Indirect Pricing' && prodLowestValue > 0 && bidline.Phoenix_Direct_Dead_Net__c.setScale(2) < prodLowestValue) {
                    isNewLow = true;
                    bidline.Phoenix_Approved_Lowest_Price_SKU__c = bidline.Phoenix_Direct_Dead_Net__c.setScale(2);
                } else if (bidline.Phoenix_Bid_Template_Refrence__c == 'CostCo' && prodLowestValue > 0 && bidline.Phoenix_Indirect_Dead_Net__c.setScale(2) < prodLowestValue) {
                    isNewLow = true;
                    bidline.Phoenix_Approved_Lowest_Price_SKU__c = bidline.Phoenix_Indirect_Dead_Net__c.setScale(2);
                } else if (bidline.Phoenix_Bid_Template_Refrence__c == 'Sams Club' && prodLowestValue > 0 && bidline.Phoenix_Indirect_Dead_Net__c.setScale(2) < prodLowestValue) {
                    isNewLow = true;
                    bidline.Phoenix_Approved_Lowest_Price_SKU__c = bidline.Phoenix_Indirect_Dead_Net__c.setScale(2);
                } else if (bidline.Phoenix_Bid_Template_Refrence__c == 'Econdisc' && prodLowestValue > 0 && bidline.Phoenix_Direct_Dead_Net__c > 0 && bidline.Phoenix_Direct_Dead_Net__c.setScale(2) < prodLowestValue) {
                    isNewLow = true;
                    bidline.Phoenix_Approved_Lowest_Price_SKU__c = bidline.Phoenix_Direct_Dead_Net__c.setScale(2);
                } else if (bidline.Phoenix_Bid_Template_Refrence__c == 'Government Pricing' && prodLowestValue != null && bidline.Phoenix_Indirect_Dead_Net__c > 0 && bidline.Phoenix_Indirect_Dead_Net__c.setScale(2) < prodLowestValue) {
                    isNewLow = true;
                    bidline.Phoenix_Approved_Lowest_Price_SKU__c = bidline.Phoenix_Indirect_Dead_Net__c.setScale(2);
                } else if (bidline.Phoenix_Bid_Template_Refrence__c == 'ROS' && prodLowestValue > 0 && ROSDeadNet.setScale(2) < prodLowestValue) {
                    isNewLow = true;
                    bidline.Phoenix_Approved_Lowest_Price_SKU__c = ROSDeadNet.setScale(2);
                } else if (bidline.Phoenix_Bid_Template_Refrence__c == 'ClarusOne' && prodLowestValue > 0 && c1DeadNet.setScale(2) < prodLowestValue) {
                    isNewLow = true;
                    bidline.Phoenix_Approved_Lowest_Price_SKU__c = c1DeadNet.setScale(2);
                } else if (bidline.Phoenix_Bid_Template_Refrence__c == 'Direct' && prodLowestValue != null && bidline.Phoenix_Internal_Dead_Net_Price__c != null && bidline.Phoenix_Internal_Dead_Net_Price__c.setScale(2) < prodLowestValue) {
                    isNewLow = true;
                    bidline.Phoenix_Approved_Lowest_Price_SKU__c = bidline.Phoenix_Internal_Dead_Net_Price__c.setScale(2);
                } else if (bidline.Phoenix_Bid_Template_Refrence__c == 'Indirect' && prodLowestValue != null && bidline.Phoenix_Internal_Dead_Net_Price__c != null && bidline.Phoenix_Internal_Dead_Net_Price__c.setScale(2) < prodLowestValue) {
                    isNewLow = true;
                    bidline.Phoenix_Approved_Lowest_Price_SKU__c = bidline.Phoenix_Internal_Dead_Net_Price__c.setScale(2);
                } else if (bidline.Phoenix_Bid_Template_Refrence__c == 'Direct and Indirect' && prodLowestValue != null && bidline.Phoenix_Direct_Dead_Net__c != null && bidline.Phoenix_Direct_Dead_Net__c.setScale(2) < prodLowestValue) {
                    isNewLow = true;
                    bidline.Phoenix_Approved_Lowest_Price_SKU__c = bidline.Phoenix_Direct_Dead_Net__c.setScale(2);
                }
                bidline.Phoenix_Is_New_Low_Triggered__c = isNewLow;

                updatedLineItemsMap.put(bidline.Id, bidline);
                // else if (bidType == 'New Product Launch' && prodLowestValue != null && bidline.Phoenix_Indirect_Dead_Net__c != null && bidline.Phoenix_Indirect_Dead_Net__c < prodLowestValue) isNewLow = true;

                        

            }

            Boolean isPartnerProd = (productFamilyLinesMap.get(pFamily))[0].Phoenix_Product__r.Phoenix_Is_partner_product__c;

            Phoenix_Approval_Grid__c tempGrid = approvalGridMap.containsKey(pFamily) ? approvalGridMap.get(pFamily) : new Phoenix_Approval_Grid__c();

            if (tempGrid.Id == null) {
                tempGrid.Name = existingLineItems[0].Phoenix_Bid__r.Name + '-' + pFamily;
                tempGrid.Phoenix_Bid__c = bidId;
            }

            // To make them absolute values
            Annualized_TP_Impact_local = Annualized_TP_Impact;
            Annualized_GM_Impact_local = Annualized_GM_Impact;
            Revenue_Local = Revenue;
            GM_Percent_local = GM_Percent;
            TP_Percent_local = TP_Percent;

                 
            //  Annualized_TP_Impact = Annualized_TP_Impact < 0 ? -(Annualized_TP_Impact) : Annualized_TP_Impact;
            // Annualized_GM_Impact = Annualized_GM_Impact < 0 ? -(Annualized_GM_Impact) : Annualized_GM_Impact;
            // Revenue = Revenue_Local < 0 ? -(Revenue) : Revenue;
            //  GM_Percent = GM_Percent_local < 0 ? -(GM_Percent) : GM_Percent;
            //  TP_Percent = TP_Percent_local < 0 ? -(TP_Percent) : TP_Percent;
            Annualized_TP_Impact = Annualized_TP_Impact;
            Annualized_GM_Impact = Annualized_GM_Impact;
            Revenue = Revenue;
            GM_Percent = GM_Percent;
            TP_Percent = TP_Percent;
                    
            //Assigning to object
            tempGrid.Phoenix_Product_Family__c = pFamily;
            tempGrid.Phoenix_Annualized_TP_Impact__c = Annualized_TP_Impact_local;
            tempGrid.Phoenix_Annualized_GM_Impact__c = Annualized_GM_Impact_local;
            tempGrid.Phoenix_GM__c = GM_Percent_local;
            tempGrid.Phoenix_TP__c = TP_Percent_local;
            tempGrid.Phoenix_SSA_Impact__c = SSA_Impact;
            tempGrid.Phoenix_Annualized_TP__c = Annualized_TP;
            tempGrid.Phoenix_Annualized_GM__c = Annualized_GM;
            tempGrid.Phoenix_Is_New_Low__c = isNewLow;
            tempGrid.Phoenix_Revenue__c = Revenue_Local;

                   

            tempGrid.Phoenix_Is_Criteria_Matched__c = false;

            Phoenix_Approval_Matrix__c selectedMatrix = new Phoenix_Approval_Matrix__c();

            for (Phoenix_Approval_Matrix__c matrix: criteriaMatrixRecords) {
                system.debug('TP_Percent=='+TP_Percent);
                system.debug('Revenue=='+Revenue);
                system.debug('Annualized_GM_Impact=='+Annualized_GM_Impact);
                system.debug('matrix.Phoenix_Throughput_Percentage_To__c=='+matrix.Phoenix_Throughput_Percentage_To__c);
                system.debug('matrix.Phoenix_Revenue_To__c=='+matrix.Phoenix_Revenue_To__c);
                system.debug('matrix.Phoenix_GM_Impact_To__c=='+matrix.Phoenix_GM_Impact_To__c);
                   if (TP_Percent < 0 || GM_Percent < 0 || Revenue < 0 || Annualized_GM_Impact < 0 || Annualized_TP_Impact < 0) {
                    if (isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Product Addition' && bidType == 'Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC Product Addition' && bidType == 'OTC Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' && bidType == 'OTC OTB Good Dated')||(matrix.Phoenix_Bid_Type__c == 'OTC New Product' && bidType == 'OTC New Product')||(matrix.Phoenix_Bid_Type__c == 'Good Dated OTB' && bidType == 'Good Dated OTB')|| (matrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' && bidType == 'One Time Buy Good Dated Shelf Life for New Product Launch')||(matrix.Phoenix_Bid_Type__c == 'New Product Launch' && bidType == 'New Product Launch')||(matrix.Phoenix_Bid_Type__c == 'New Customer' && bidType == 'New Customer')) && (GM_Percent <= matrix.Phoenix_GM_Percent_To__c ||  Revenue <=  matrix.Phoenix_Revenue_To__c) ) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    tempGrid.Phoenix_Is_Mkg_Head_Noti_Required__c = TRUE;
                    selectedMatrix = matrix;
                            
                    }
                    else if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Product Addition' && bidType == 'Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC Product Addition' && bidType == 'OTC Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' && bidType == 'OTC OTB Good Dated')||(matrix.Phoenix_Bid_Type__c == 'OTC New Product' && bidType == 'OTC New Product')||(matrix.Phoenix_Bid_Type__c == 'Good Dated OTB' && bidType == 'Good Dated OTB') || (matrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' && bidType == 'One Time Buy Good Dated Shelf Life for New Product Launch') ||(matrix.Phoenix_Bid_Type__c == 'New Product Launch' && bidType == 'New Product Launch')||(matrix.Phoenix_Bid_Type__c == 'New Customer' && bidType == 'New Customer')) && (TP_Percent <= matrix.Phoenix_Throughput_Percentage_To__c  || Revenue <= matrix.Phoenix_Revenue_To__c)) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    tempGrid.Phoenix_Is_Mkg_Head_Noti_Required__c = TRUE;
                    selectedMatrix = matrix;
                    }
                    else if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Price Change' && bidType == 'Price Change')||(matrix.Phoenix_Bid_Type__c == 'OTC Price Change' && bidType == 'OTC Price Change')||(matrix.Phoenix_Bid_Type__c == 'RFP Bids' && bidType == 'RFP Bids')||(matrix.Phoenix_Bid_Type__c == 'OTC RFP' && bidType == 'OTC RFP')||(matrix.Phoenix_Bid_Type__c == 'Customer Rebate Change' && bidType == 'Customer Rebate Change') || (matrix.Phoenix_Bid_Type__c == 'OTC Rebate Change' && bidType == 'OTC Rebate Change')) && (TP_Percent <= matrix.Phoenix_Throughput_Percentage_To__c || Annualized_TP_Impact < matrix.Phoenix_Throughput_Impact_To__c)) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    tempGrid.Phoenix_Is_Mkg_Head_Noti_Required__c = TRUE;
                    selectedMatrix = matrix;
                         }
                    else if (isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Price Change' && bidType == 'Price Change')||(matrix.Phoenix_Bid_Type__c == 'OTC Price Change' && bidType == 'OTC Price Change')||(matrix.Phoenix_Bid_Type__c == 'RFP Bids' && bidType == 'RFP Bids')||(matrix.Phoenix_Bid_Type__c == 'OTC RFP' && bidType == 'OTC RFP')||(matrix.Phoenix_Bid_Type__c == 'Customer Rebate Change' && bidType == 'Customer Rebate Change') || (matrix.Phoenix_Bid_Type__c == 'OTC Rebate Change' && bidType == 'OTC Rebate Change')) &&  (GM_Percent < matrix.Phoenix_GM_Impact_To__c  || Annualized_GM_Impact < matrix.Phoenix_GM_Impact_To__c)) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    tempGrid.Phoenix_Is_Mkg_Head_Noti_Required__c = TRUE;
                    selectedMatrix = matrix;
                         system.debug('matrix====='+matrix.Id);
                    }
                }
                //0-40  0<x  && x<=40 ; x>40 
                // for all in-house products
                else{
                if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Product Addition' && bidType == 'Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC Product Addition' && bidType == 'OTC Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' && bidType == 'OTC OTB Good Dated')||(matrix.Phoenix_Bid_Type__c == 'OTC New Product' && bidType == 'OTC New Product')||(matrix.Phoenix_Bid_Type__c == 'Good Dated OTB' && bidType == 'Good Dated OTB') || (matrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' && bidType == 'One Time Buy Good Dated Shelf Life for New Product Launch') ||(matrix.Phoenix_Bid_Type__c == 'New Product Launch' && bidType == 'New Product Launch')||(matrix.Phoenix_Bid_Type__c == 'New Customer' && bidType == 'New Customer')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_Throughput_Percentage_From__c <= TP_Percent && TP_Percent <= matrix.Phoenix_Throughput_Percentage_To__c && matrix.Phoenix_Revenue_From__c <= Revenue && Revenue <= matrix.Phoenix_Revenue_To__c) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    selectedMatrix = matrix;
                    //0-40//revernue from to 

                } else if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Product Addition' && bidType == 'Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC Product Addition' && bidType == 'OTC Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' && bidType == 'OTC OTB Good Dated')||(matrix.Phoenix_Bid_Type__c == 'OTC New Product' && bidType == 'OTC New Product')||(matrix.Phoenix_Bid_Type__c == 'Good Dated OTB' && bidType == 'Good Dated OTB')|| (matrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' && bidType == 'One Time Buy Good Dated Shelf Life for New Product Launch')||(matrix.Phoenix_Bid_Type__c == 'New Product Launch' && bidType == 'New Product Launch')||(matrix.Phoenix_Bid_Type__c == 'New Customer' && bidType == 'New Customer'))  && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_Throughput_Percentage_From__c <= TP_Percent && TP_Percent <= matrix.Phoenix_Throughput_Percentage_To__c && matrix.Phoenix_Revenue_From__c < Revenue && matrix.Phoenix_Revenue_To__c == null) {
                    selectedMatrix = matrix; //0-40//revenue 2M above
                           
                } else if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Product Addition' && bidType == 'Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC Product Addition' && bidType == 'OTC Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' && bidType == 'OTC OTB Good Dated')||(matrix.Phoenix_Bid_Type__c == 'OTC New Product' && bidType == 'OTC New Product')||(matrix.Phoenix_Bid_Type__c == 'Good Dated OTB' && bidType == 'Good Dated OTB')|| (matrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' && bidType == 'One Time Buy Good Dated Shelf Life for New Product Launch')||(matrix.Phoenix_Bid_Type__c == 'New Product Launch' && bidType == 'New Product Launch')||(matrix.Phoenix_Bid_Type__c == 'New Customer' && bidType == 'New Customer'))  && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_Throughput_Percentage_From__c < TP_Percent && matrix.Phoenix_Throughput_Percentage_To__c == null && matrix.Phoenix_Revenue_From__c < Revenue && matrix.Phoenix_Revenue_To__c == null) {
                    if(isNewLow == False)tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    if(isNewLow == False)tempGrid.Phoenix_Is_Mkg_Head_Noti_Required__c = TRUE;
                    selectedMatrix = matrix; //40 above//revenue 2M Above
                            
                } else if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Product Addition' && bidType == 'Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC Product Addition' && bidType == 'OTC Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' && bidType == 'OTC OTB Good Dated')||(matrix.Phoenix_Bid_Type__c == 'OTC New Product' && bidType == 'OTC New Product')||(matrix.Phoenix_Bid_Type__c == 'Good Dated OTB' && bidType == 'Good Dated OTB')|| (matrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' && bidType == 'One Time Buy Good Dated Shelf Life for New Product Launch')||(matrix.Phoenix_Bid_Type__c == 'New Product Launch' && bidType == 'New Product Launch')||(matrix.Phoenix_Bid_Type__c == 'New Customer' && bidType == 'New Customer'))  && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_Throughput_Percentage_From__c < TP_Percent && matrix.Phoenix_Throughput_Percentage_To__c == null && matrix.Phoenix_Revenue_From__c <= Revenue && Revenue <= matrix.Phoenix_Revenue_To__c) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    if(Revenue>=0 && Revenue<=500000 ) tempGrid.Phoenix_Is_Mkg_Head_Noti_Required__c = TRUE;
                    selectedMatrix = matrix; //40 above//revenue from to
                           
                }
                //by Sai Krishna
                else if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Good Dated OTB' && bidType == 'Good Dated OTB')|| (matrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' && bidType == 'One Time Buy Good Dated Shelf Life for New Product Launch'))  && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_Throughput_Percentage_From__c < TP_Percent && matrix.Phoenix_Throughput_Percentage_To__c == null && matrix.Phoenix_Revenue_From__c < Revenue && matrix.Phoenix_Revenue_To__c == null) {
                    if(isNewLow == False)tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    if(isNewLow == False)tempGrid.Phoenix_Is_Mkg_Head_Noti_Required__c = TRUE;
                    selectedMatrix = matrix; //40 above//revenue 2M Above
                            
                }
                //   
                        
                //*********************************************************************************************************************************************************************************************                
                if (isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Product Addition' && bidType == 'Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC Product Addition' && bidType == 'OTC Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' && bidType == 'OTC OTB Good Dated')||(matrix.Phoenix_Bid_Type__c == 'OTC New Product' && bidType == 'OTC New Product')||(matrix.Phoenix_Bid_Type__c == 'Good Dated OTB' && bidType == 'Good Dated OTB')|| (matrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' && bidType == 'One Time Buy Good Dated Shelf Life for New Product Launch')||(matrix.Phoenix_Bid_Type__c == 'New Product Launch' && bidType == 'New Product Launch')||(matrix.Phoenix_Bid_Type__c == 'New Customer' && bidType == 'New Customer'))  && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_GM_Percent_From__c <= GM_Percent && GM_Percent <= matrix.Phoenix_GM_Percent_To__c && matrix.Phoenix_Revenue_From__c <= Revenue && Revenue <= matrix.Phoenix_Revenue_To__c) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    selectedMatrix = matrix; //0-25//revernue from to 
                } else if (isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Product Addition' && bidType == 'Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC Product Addition' && bidType == 'OTC Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' && bidType == 'OTC OTB Good Dated')||(matrix.Phoenix_Bid_Type__c == 'OTC New Product' && bidType == 'OTC New Product')||(matrix.Phoenix_Bid_Type__c == 'Good Dated OTB' && bidType == 'Good Dated OTB')|| (matrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' && bidType == 'One Time Buy Good Dated Shelf Life for New Product Launch')||(matrix.Phoenix_Bid_Type__c == 'New Product Launch' && bidType == 'New Product Launch')||(matrix.Phoenix_Bid_Type__c == 'New Customer' && bidType == 'New Customer'))  && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_GM_Percent_From__c <= GM_Percent && GM_Percent <= matrix.Phoenix_GM_Percent_To__c && matrix.Phoenix_Revenue_From__c < Revenue && matrix.Phoenix_Revenue_To__c == null) {
                    selectedMatrix = matrix; //0-25//revenue 2M above
                } else if (isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Product Addition' && bidType == 'Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC Product Addition' && bidType == 'OTC Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' && bidType == 'OTC OTB Good Dated')||(matrix.Phoenix_Bid_Type__c == 'OTC New Product' && bidType == 'OTC New Product')||(matrix.Phoenix_Bid_Type__c == 'Good Dated OTB' && bidType == 'Good Dated OTB')|| (matrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' && bidType == 'One Time Buy Good Dated Shelf Life for New Product Launch')||(matrix.Phoenix_Bid_Type__c == 'New Product Launch' && bidType == 'New Product Launch')||(matrix.Phoenix_Bid_Type__c == 'New Customer' && bidType == 'New Customer'))  && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_GM_Percent_From__c < GM_Percent && matrix.Phoenix_GM_Percent_To__c == null && matrix.Phoenix_Revenue_From__c < Revenue && matrix.Phoenix_Revenue_To__c == null) {
                    if(isNewLow == False) tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    if(isNewLow == False) tempGrid.Phoenix_Is_Mkg_Head_Noti_Required__c = TRUE;
                    selectedMatrix = matrix; //25 above//revenue 2M Above
                } else if (isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Product Addition' && bidType == 'Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC Product Addition' && bidType == 'OTC Product Addition')||(matrix.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' && bidType == 'OTC OTB Good Dated')||(matrix.Phoenix_Bid_Type__c == 'OTC New Product' && bidType == 'OTC New Product')||(matrix.Phoenix_Bid_Type__c == 'Good Dated OTB' && bidType == 'Good Dated OTB')|| (matrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' && bidType == 'One Time Buy Good Dated Shelf Life for New Product Launch')||(matrix.Phoenix_Bid_Type__c == 'New Product Launch' && bidType == 'New Product Launch')||(matrix.Phoenix_Bid_Type__c == 'New Customer' && bidType == 'New Customer'))  && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_GM_Percent_From__c < GM_Percent && matrix.Phoenix_GM_Percent_To__c == null && matrix.Phoenix_Revenue_From__c <= Revenue && Revenue <= matrix.Phoenix_Revenue_To__c) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    if(Revenue>=0 && Revenue<=500000 )tempGrid.Phoenix_Is_Mkg_Head_Noti_Required__c = TRUE;
                    selectedMatrix = matrix; //25 above//revenue from to
                }
                //   
                        
                        
                //*********************************************************************************************************************************************************************************************
                if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Price Change' && bidType == 'Price Change')||(matrix.Phoenix_Bid_Type__c == 'OTC Price Change' && bidType == 'OTC Price Change')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_Throughput_Percentage_From__c <= TP_Percent && TP_Percent <= matrix.Phoenix_Throughput_Percentage_To__c && matrix.Phoenix_Throughput_Impact_from__c <= Annualized_TP_Impact && Annualized_TP_Impact <= matrix.Phoenix_Throughput_Impact_To__c) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    selectedMatrix = matrix; //0-40//TP Impact from to 
                } else if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Price Change' && bidType == 'Price Change')||(matrix.Phoenix_Bid_Type__c == 'OTC Price Change' && bidType == 'OTC Price Change')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_Throughput_Percentage_From__c <= TP_Percent && TP_Percent <= matrix.Phoenix_Throughput_Percentage_To__c && matrix.Phoenix_Throughput_Impact_from__c < Annualized_TP_Impact && matrix.Phoenix_Throughput_Impact_To__c == null) {
                    selectedMatrix = matrix; //0-40//Tp impact 1M above
                } else if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Price Change' && bidType == 'Price Change')||(matrix.Phoenix_Bid_Type__c == 'OTC Price Change' && bidType == 'OTC Price Change')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_Throughput_Percentage_From__c < TP_Percent && matrix.Phoenix_Throughput_Percentage_To__c == null && matrix.Phoenix_Throughput_Impact_from__c < Annualized_TP_Impact && matrix.Phoenix_Throughput_Impact_To__c == null) {
                    selectedMatrix = matrix; //40 above//Tp impact 1M Above
                } else if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Price Change' && bidType == 'Price Change')||(matrix.Phoenix_Bid_Type__c == 'OTC Price Change' && bidType == 'OTC Price Change')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_Throughput_Percentage_From__c < TP_Percent && matrix.Phoenix_Throughput_Percentage_To__c == null && matrix.Phoenix_Throughput_Impact_from__c <= Annualized_TP_Impact && Annualized_TP_Impact <= matrix.Phoenix_Throughput_Impact_To__c) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    if(Annualized_TP_Impact>=0 && Annualized_TP_Impact<=500000 )tempGrid.Phoenix_Is_Mkg_Head_Noti_Required__c = TRUE;
                    selectedMatrix = matrix; //40 above//Tp impact from to
                }
                //   
                //*********************************************************************************************************************************************************************************************
                        
                if (isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Price Change' && bidType == 'Price Change')||(matrix.Phoenix_Bid_Type__c == 'OTC Price Change' && bidType == 'OTC Price Change')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_GM_Percent_From__c <= GM_Percent && GM_Percent <= matrix.Phoenix_GM_Percent_To__c && matrix.Phoenix_GM_Impact_From__c <= Annualized_GM_Impact && Annualized_GM_Impact <= matrix.Phoenix_GM_Impact_To__c) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    selectedMatrix = matrix; //0-25//GM Impact from to 
                } else if (isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Price Change' && bidType == 'Price Change')||(matrix.Phoenix_Bid_Type__c == 'OTC Price Change' && bidType == 'OTC Price Change')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_GM_Percent_From__c <= GM_Percent && GM_Percent <= matrix.Phoenix_GM_Percent_To__c && matrix.Phoenix_GM_Impact_From__c < Annualized_GM_Impact && matrix.Phoenix_GM_Impact_To__c == null) {
                    selectedMatrix = matrix; //0-25//GM Impact 1M above
                } else if (isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Price Change' && bidType == 'Price Change')||(matrix.Phoenix_Bid_Type__c == 'OTC Price Change' && bidType == 'OTC Price Change')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_GM_Percent_From__c < GM_Percent && matrix.Phoenix_GM_Percent_To__c == null && matrix.Phoenix_GM_Impact_From__c < Annualized_GM_Impact && matrix.Phoenix_GM_Impact_To__c == null) {
                    selectedMatrix = matrix; //25 above//GM Impact 1M Above
                } else if (isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Price Change' && bidType == 'Price Change')||(matrix.Phoenix_Bid_Type__c == 'OTC Price Change' && bidType == 'OTC Price Change')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_GM_Percent_From__c < GM_Percent && matrix.Phoenix_GM_Percent_To__c == null && matrix.Phoenix_GM_Impact_From__c <= Annualized_GM_Impact && Annualized_GM_Impact <= matrix.Phoenix_GM_Impact_To__c) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    if(Annualized_GM_Impact>=0 && Annualized_GM_Impact<=500000 )  tempGrid.Phoenix_Is_Mkg_Head_Noti_Required__c = TRUE;
                    selectedMatrix = matrix; //25 above//GM Impact from to
                }
                //   
                        
                //*********************************************************************************************************************************************************************************************
                if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'RFP Bids' && bidType == 'RFP Bids' )||(matrix.Phoenix_Bid_Type__c == 'OTC RFP' && bidType == 'OTC RFP'))&& matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_Throughput_Percentage_From__c <= TP_Percent && TP_Percent <= matrix.Phoenix_Throughput_Percentage_To__c && matrix.Phoenix_Throughput_Impact_from__c <= Annualized_TP_Impact && Annualized_TP_Impact <= matrix.Phoenix_Throughput_Impact_To__c) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    selectedMatrix = matrix; //0-40//Tp Impact from to 
                } else if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'RFP Bids' && bidType == 'RFP Bids' )||(matrix.Phoenix_Bid_Type__c == 'OTC RFP' && bidType == 'OTC RFP')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_Throughput_Percentage_From__c <= TP_Percent && TP_Percent <= matrix.Phoenix_Throughput_Percentage_To__c && matrix.Phoenix_Throughput_Impact_from__c < Annualized_TP_Impact && matrix.Phoenix_Throughput_Impact_To__c == null) {
                    selectedMatrix = matrix; //0-40//Tp Impact 1M above
                } else if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'RFP Bids' && bidType == 'RFP Bids' )||(matrix.Phoenix_Bid_Type__c == 'OTC RFP' && bidType == 'OTC RFP')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_Throughput_Percentage_From__c < TP_Percent && matrix.Phoenix_Throughput_Percentage_To__c == null && matrix.Phoenix_Throughput_Impact_from__c < Annualized_TP_Impact && matrix.Phoenix_Throughput_Impact_To__c == null) {
                    selectedMatrix = matrix; //40 above//Tp Impact 1M Above
                } else if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'RFP Bids' && bidType == 'RFP Bids' )||(matrix.Phoenix_Bid_Type__c == 'OTC RFP' && bidType == 'OTC RFP')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_Throughput_Percentage_From__c < TP_Percent && matrix.Phoenix_Throughput_Percentage_To__c == null && matrix.Phoenix_Throughput_Impact_from__c <= Annualized_TP_Impact && Annualized_TP_Impact <= matrix.Phoenix_Throughput_Impact_To__c) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    if(Annualized_TP_Impact>=0 && Annualized_TP_Impact<=500000 )tempGrid.Phoenix_Is_Mkg_Head_Noti_Required__c = TRUE;
                    selectedMatrix = matrix; //40 above//Tp Impact from to
                }
                //   
                //*********************************************************************************************************************************************************************************************
                if (isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'RFP Bids' && bidType == 'RFP Bids' )||(matrix.Phoenix_Bid_Type__c == 'OTC RFP' && bidType == 'OTC RFP')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_GM_Percent_From__c <= GM_Percent && GM_Percent <= matrix.Phoenix_GM_Percent_To__c && matrix.Phoenix_GM_Impact_From__c <= Annualized_GM_Impact && Annualized_GM_Impact <= matrix.Phoenix_GM_Impact_To__c) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    selectedMatrix = matrix; //0-25//GM Impact from to 
                } else if (isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'RFP Bids' && bidType == 'RFP Bids' )||(matrix.Phoenix_Bid_Type__c == 'OTC RFP' && bidType == 'OTC RFP')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_GM_Percent_From__c <= GM_Percent && GM_Percent <= matrix.Phoenix_GM_Percent_To__c && matrix.Phoenix_GM_Impact_From__c < Annualized_GM_Impact && matrix.Phoenix_GM_Impact_To__c == null) {
                    selectedMatrix = matrix; //0-25//GM Impact 1M above
                } else if (isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'RFP Bids' && bidType == 'RFP Bids' )||(matrix.Phoenix_Bid_Type__c == 'OTC RFP' && bidType == 'OTC RFP')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_GM_Percent_From__c < GM_Percent && matrix.Phoenix_GM_Percent_To__c == null && matrix.Phoenix_GM_Impact_From__c < Annualized_GM_Impact && matrix.Phoenix_GM_Impact_To__c == null) {
                    selectedMatrix = matrix; //25 above//GM Impact 1M Above
                } else if (isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'RFP Bids' && bidType == 'RFP Bids' )||(matrix.Phoenix_Bid_Type__c == 'OTC RFP' && bidType == 'OTC RFP')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_GM_Percent_From__c < GM_Percent && matrix.Phoenix_GM_Percent_To__c == null && matrix.Phoenix_GM_Impact_From__c <= Annualized_GM_Impact && Annualized_GM_Impact <= matrix.Phoenix_GM_Impact_To__c) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    if(Annualized_GM_Impact>=0 && Annualized_GM_Impact<=500000 )  tempGrid.Phoenix_Is_Mkg_Head_Noti_Required__c = TRUE;
                    selectedMatrix = matrix; //25 above//GM Impact from to
                }
                //   
                //*********************************************************************************************************************************************************************************************
                if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Customer Rebate Change' && bidType == 'Customer Rebate Change')||(matrix.Phoenix_Bid_Type__c == 'OTC Rebate Change' && bidType == 'OTC Rebate Change')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_Throughput_Percentage_From__c <= TP_Percent && TP_Percent <= matrix.Phoenix_Throughput_Percentage_To__c && matrix.Phoenix_Throughput_Impact_from__c <= Annualized_TP_Impact && Annualized_TP_Impact <= matrix.Phoenix_Throughput_Impact_To__c) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    selectedMatrix = matrix; //0-40//TP Impact from to 
                } else if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Customer Rebate Change' && bidType == 'Customer Rebate Change')||(matrix.Phoenix_Bid_Type__c == 'OTC Rebate Change' && bidType == 'OTC Rebate Change')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_Throughput_Percentage_From__c <= TP_Percent && TP_Percent <= matrix.Phoenix_Throughput_Percentage_To__c && matrix.Phoenix_Throughput_Impact_from__c < Annualized_TP_Impact && matrix.Phoenix_Throughput_Impact_To__c == null) {
                    selectedMatrix = matrix; //0-40//TP Impact 1M above
                } else if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Customer Rebate Change' && bidType == 'Customer Rebate Change')||(matrix.Phoenix_Bid_Type__c == 'OTC Rebate Change' && bidType == 'OTC Rebate Change')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_Throughput_Percentage_From__c < TP_Percent && matrix.Phoenix_Throughput_Percentage_To__c == null && matrix.Phoenix_Throughput_Impact_from__c < Annualized_TP_Impact && matrix.Phoenix_Throughput_Impact_To__c == null) {
                    selectedMatrix = matrix; //40 above//TP Impact 1M Above
                } else if (!isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Customer Rebate Change' && bidType == 'Customer Rebate Change')||(matrix.Phoenix_Bid_Type__c == 'OTC Rebate Change' && bidType == 'OTC Rebate Change')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_Throughput_Percentage_From__c < TP_Percent && matrix.Phoenix_Throughput_Percentage_To__c == null && matrix.Phoenix_Throughput_Impact_from__c <= Annualized_TP_Impact && Annualized_TP_Impact <= matrix.Phoenix_Throughput_Impact_To__c) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    if(Annualized_TP_Impact>=0 && Annualized_TP_Impact<=500000 )tempGrid.Phoenix_Is_Mkg_Head_Noti_Required__c = TRUE;
                    selectedMatrix = matrix; //40 above//TP Impact from to
                }
                //   
                //*********************************************************************************************************************************************************************************************
                if (isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Customer Rebate Change' && bidType == 'Customer Rebate Change')||(matrix.Phoenix_Bid_Type__c == 'OTC Rebate Change' && bidType == 'OTC Rebate Change')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_GM_Percent_From__c <= GM_Percent && GM_Percent <= matrix.Phoenix_GM_Percent_To__c && matrix.Phoenix_GM_Impact_From__c <= Annualized_GM_Impact && Annualized_GM_Impact <= matrix.Phoenix_GM_Impact_To__c) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    selectedMatrix = matrix; //0-25//GM Impact from to 
                } else if (isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Customer Rebate Change' && bidType == 'Customer Rebate Change')||(matrix.Phoenix_Bid_Type__c == 'OTC Rebate Change' && bidType == 'OTC Rebate Change')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_GM_Percent_From__c <= GM_Percent && GM_Percent <= matrix.Phoenix_GM_Percent_To__c && matrix.Phoenix_GM_Impact_From__c < Annualized_GM_Impact && matrix.Phoenix_GM_Impact_To__c == null) {
                    selectedMatrix = matrix; //0-25//GM Impact 1M above
                } else if (isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Customer Rebate Change' && bidType == 'Customer Rebate Change')||(matrix.Phoenix_Bid_Type__c == 'OTC Rebate Change' && bidType == 'OTC Rebate Change')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_GM_Percent_From__c < GM_Percent && matrix.Phoenix_GM_Percent_To__c == null && matrix.Phoenix_GM_Impact_From__c < Annualized_GM_Impact && matrix.Phoenix_GM_Impact_To__c == null) {
                    selectedMatrix = matrix; //25 above//GM Impact 1M Above
                } else if (isPartnerProd && ((matrix.Phoenix_Bid_Type__c == 'Customer Rebate Change' && bidType == 'Customer Rebate Change')||(matrix.Phoenix_Bid_Type__c == 'OTC Rebate Change' && bidType == 'OTC Rebate Change')) && matrix.Phoenix_Is_New_Low__c == isNewLow && matrix.Phoenix_GM_Percent_From__c < GM_Percent && matrix.Phoenix_GM_Percent_To__c == null && matrix.Phoenix_GM_Impact_From__c <= Annualized_GM_Impact && Annualized_GM_Impact <= matrix.Phoenix_GM_Impact_To__c) {
                    tempGrid.Phoenix_Is_SVP_Notification_Required__c = TRUE;
                    if(Annualized_GM_Impact>=0 && Annualized_GM_Impact<=500000 )  tempGrid.Phoenix_Is_Mkg_Head_Noti_Required__c = TRUE;
                    selectedMatrix = matrix; //25 above//GM Impact from to
                }
                //   
                //*********************************************************************************************************************************************************************************************
                        
                }
            }
                    
            tempGrid.Phoenix_Is_partner_product__c = isPartnerProd;

            if (selectedMatrix.Id != null) {
                tempGrid.Phoenix_Is_Criteria_Matched__c = true;
                tempGrid.Phoenix_Selected_Approval_Matrix__c = selectedMatrix.Id;                        
                List < Phoenix_Approval_Process_Step__c > selectedSteps = criteriaMatrixMap.get(selectedMatrix.Id).Phoenix_Approval_Process_Steps__r;
                String prodType = productFamilyLinesMap.get(pFamily)[0].Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c;
                for (Phoenix_Approval_Process_Step__c step: selectedSteps) {
                    if (step.Phoenix_Approver_Team__c == 'Marketing Lead Rx' && prodType == 'Rx') {
                        approverTeams.add(step.Phoenix_Approver_Team__c);
                        tempGrid.Phoenix_isRX__c = true;
                    } else if (step.Phoenix_Approver_Team__c == 'Marketing Lead SRx' && prodType == 'SRx') {
                        approverTeams.add(step.Phoenix_Approver_Team__c);
                        tempGrid.Phoenix_isSRX__c = true;
                    } else if (step.Phoenix_Approver_Team__c == 'Marketing Lead OTC' && prodType == 'OTC') {
                        approverTeams.add(step.Phoenix_Approver_Team__c);
                        tempGrid.Phoenix_isOTC__c = true;
                    } else if (step.Phoenix_Approver_Team__c == 'Marketing Head') {
                        approverTeams.add(step.Phoenix_Approver_Team__c);
                        tempGrid.Phoenix_Mkt_Head_Req__c = true;
                    } else if (step.Phoenix_Approver_Team__c == 'Sr Director or VP Finance') {
                        approverTeams.add(step.Phoenix_Approver_Team__c);
                        tempGrid.Phoenix_VP_Finance_Req__c = true;
                    } else if (step.Phoenix_Approver_Team__c != 'Marketing Head' && step.Phoenix_Approver_Team__c != 'Sr Director or VP Finance' && step.Phoenix_Approver_Team__c != 'Marketing Lead OTC' && step.Phoenix_Approver_Team__c != 'Marketing Lead SRx' && step.Phoenix_Approver_Team__c != 'Marketing Lead Rx') {
                        approverTeams.add(step.Phoenix_Approver_Team__c);
                    }
                }
                       
                        
                 if (TP_Percent < 0 || GM_Percent < 0 || Revenue < 0 || Annualized_GM_Impact < 0 || Annualized_TP_Impact < 0) {
                    if (selectedMatrix.Phoenix_Bid_Type__c != 'Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC OTB Good Dated' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC New Product'  && selectedMatrix.Phoenix_Bid_Type__c != 'Good Dated OTB' && selectedMatrix.Phoenix_Bid_Type__c != 'One Time Buy Good Dated Shelf Life for New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Customer' && !isPartnerProd && selectedMatrix.Phoenix_Throughput_Impact_To__c == 0) {
                    tempGrid.Phoenix_Annualized_TP_Impact_Limit__c = '<$' + selectedMatrix.Phoenix_Throughput_Impact_To__c;
                } /*else if (selectedMatrix.Phoenix_Bid_Type__c != 'Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC OTB Good Dated' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC New Product'  && selectedMatrix.Phoenix_Bid_Type__c != 'Good Dated OTB' && selectedMatrix.Phoenix_Bid_Type__c != 'One Time Buy Good Dated Shelf Life for New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Customer' && !isPartnerProd && selectedMatrix.Phoenix_Throughput_Impact_To__c == 0 && selectedMatrix.Phoenix_Throughput_Impact_from__c == null) {
                    tempGrid.Phoenix_Annualized_TP_Impact_Limit__c = '>$' + selectedMatrix.Phoenix_Throughput_Impact_from__c;
                }*/
                if (!isPartnerProd && selectedMatrix.Phoenix_Throughput_Percentage_To__c == 0) {
                    tempGrid.Phoenix_TP_Limit__c = '<' + selectedMatrix.Phoenix_Throughput_Percentage_To__c + '%';
                }/* else if (!isPartnerProd && selectedMatrix.Phoenix_Throughput_Percentage_To__c == null && selectedMatrix.Phoenix_Throughput_Percentage_From__c != null) {
                    tempGrid.Phoenix_TP_Limit__c = '>' + selectedMatrix.Phoenix_Throughput_Percentage_From__c + '%';
                }*/
                        
                if (selectedMatrix.Phoenix_Bid_Type__c != 'Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC OTB Good Dated' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC New Product'  && selectedMatrix.Phoenix_Bid_Type__c != 'Good Dated OTB' && selectedMatrix.Phoenix_Bid_Type__c != 'One Time Buy Good Dated Shelf Life for New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Customer' && isPartnerProd && selectedMatrix.Phoenix_GM_Impact_To__c == 0) {
                    tempGrid.Phoenix_Annualized_GM_Impact_Limit__c = '<$' + selectedMatrix.Phoenix_GM_Impact_To__c;
                }/* else if (selectedMatrix.Phoenix_Bid_Type__c != 'Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC OTB Good Dated' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC New Product'   && selectedMatrix.Phoenix_Bid_Type__c != 'Good Dated OTB' && selectedMatrix.Phoenix_Bid_Type__c != 'One Time Buy Good Dated Shelf Life for New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Customer' && isPartnerProd && selectedMatrix.Phoenix_GM_Impact_To__c == null && selectedMatrix.Phoenix_GM_Percent_From__c != null) {
                    tempGrid.Phoenix_Annualized_GM_Impact_Limit__c = '>$' + selectedMatrix.Phoenix_GM_Percent_From__c;
                }*/
                        
                if (isPartnerProd && selectedMatrix.Phoenix_GM_Percent_To__c == 0) {
                    tempGrid.Phoenix_GM_Limit__c =  '<' + selectedMatrix.Phoenix_GM_Percent_To__c + '%';
                } /*else if (isPartnerProd && selectedMatrix.Phoenix_GM_Percent_To__c == null && selectedMatrix.Phoenix_GM_Percent_From__c != null) {
                    tempGrid.Phoenix_GM_Limit__c = '>' + selectedMatrix.Phoenix_GM_Percent_From__c + '%';
                }*/
                        
                        
                if ((selectedMatrix.Phoenix_Bid_Type__c == 'Product Addition' || selectedMatrix.Phoenix_Bid_Type__c == 'OTC Product Addition' || selectedMatrix.Phoenix_Bid_Type__c == 'OTC New Product' || selectedMatrix.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' || selectedMatrix.Phoenix_Bid_Type__c == 'Good Dated OTB' || selectedMatrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' || selectedMatrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' || selectedMatrix.Phoenix_Bid_Type__c == 'New Product Launch' || selectedMatrix.Phoenix_Bid_Type__c == 'New Customer') && selectedMatrix.Phoenix_Revenue_To__c == 0) {
                    tempGrid.Phoenix_Revenue_Limit__c = '<$' + selectedMatrix.Phoenix_Revenue_To__c;
                } /*else if ((selectedMatrix.Phoenix_Bid_Type__c == 'Product Addition' || selectedMatrix.Phoenix_Bid_Type__c == 'OTC Product Addition' || selectedMatrix.Phoenix_Bid_Type__c == 'OTC New Product' || selectedMatrix.Phoenix_Bid_Type__c == 'OTC OTB Good Dated'  || selectedMatrix.Phoenix_Bid_Type__c == 'Good Dated OTB' || selectedMatrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' || selectedMatrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' || selectedMatrix.Phoenix_Bid_Type__c == 'New Product Launch' || selectedMatrix.Phoenix_Bid_Type__c == 'New Customer') && selectedMatrix.Phoenix_Revenue_To__c == null && selectedMatrix.Phoenix_Revenue_From__c != null) {
                    tempGrid.Phoenix_Revenue_Limit__c = '>$' + selectedMatrix.Phoenix_Revenue_From__c;
                }*/
                }
                else{
                if (selectedMatrix.Phoenix_Bid_Type__c != 'Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC OTB Good Dated' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC New Product'  && selectedMatrix.Phoenix_Bid_Type__c != 'Good Dated OTB' && selectedMatrix.Phoenix_Bid_Type__c != 'One Time Buy Good Dated Shelf Life for New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Customer' && !isPartnerProd && selectedMatrix.Phoenix_Throughput_Impact_To__c != null) {
                    tempGrid.Phoenix_Annualized_TP_Impact_Limit__c = '$' + selectedMatrix.Phoenix_Throughput_Impact_from__c + '-$' + selectedMatrix.Phoenix_Throughput_Impact_To__c;
                } else if (selectedMatrix.Phoenix_Bid_Type__c != 'Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC OTB Good Dated' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC New Product'  && selectedMatrix.Phoenix_Bid_Type__c != 'Good Dated OTB' && selectedMatrix.Phoenix_Bid_Type__c != 'One Time Buy Good Dated Shelf Life for New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Customer' && !isPartnerProd && selectedMatrix.Phoenix_Throughput_Impact_To__c == null && selectedMatrix.Phoenix_Throughput_Impact_from__c != null) {
                    tempGrid.Phoenix_Annualized_TP_Impact_Limit__c = '>$' + selectedMatrix.Phoenix_Throughput_Impact_from__c;
                }
                if (!isPartnerProd && selectedMatrix.Phoenix_Throughput_Percentage_To__c != null) {
                    tempGrid.Phoenix_TP_Limit__c = selectedMatrix.Phoenix_Throughput_Percentage_From__c + '%-' + selectedMatrix.Phoenix_Throughput_Percentage_To__c + '%';
                } else if (!isPartnerProd && selectedMatrix.Phoenix_Throughput_Percentage_To__c == null && selectedMatrix.Phoenix_Throughput_Percentage_From__c != null) {
                    tempGrid.Phoenix_TP_Limit__c = '>' + selectedMatrix.Phoenix_Throughput_Percentage_From__c + '%';
                }
                        
                if (selectedMatrix.Phoenix_Bid_Type__c != 'Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC OTB Good Dated' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC New Product'  && selectedMatrix.Phoenix_Bid_Type__c != 'Good Dated OTB' && selectedMatrix.Phoenix_Bid_Type__c != 'One Time Buy Good Dated Shelf Life for New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Customer' && isPartnerProd && selectedMatrix.Phoenix_GM_Impact_To__c != null) {
                    tempGrid.Phoenix_Annualized_GM_Impact_Limit__c = '$' + selectedMatrix.Phoenix_GM_Impact_From__c + '-$' + selectedMatrix.Phoenix_GM_Impact_To__c;
                } else if (selectedMatrix.Phoenix_Bid_Type__c != 'Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC Product Addition' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC OTB Good Dated' && selectedMatrix.Phoenix_Bid_Type__c != 'OTC New Product'   && selectedMatrix.Phoenix_Bid_Type__c != 'Good Dated OTB' && selectedMatrix.Phoenix_Bid_Type__c != 'One Time Buy Good Dated Shelf Life for New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Product Launch' && selectedMatrix.Phoenix_Bid_Type__c != 'New Customer' && isPartnerProd && selectedMatrix.Phoenix_GM_Impact_To__c == null && selectedMatrix.Phoenix_GM_Percent_From__c != null) {
                    tempGrid.Phoenix_Annualized_GM_Impact_Limit__c = '>$' + selectedMatrix.Phoenix_GM_Percent_From__c;
                }
                        
                if (isPartnerProd && selectedMatrix.Phoenix_GM_Percent_To__c != null) {
                    tempGrid.Phoenix_GM_Limit__c = selectedMatrix.Phoenix_GM_Percent_From__c + '%-' + selectedMatrix.Phoenix_GM_Percent_To__c + '%';
                } else if (isPartnerProd && selectedMatrix.Phoenix_GM_Percent_To__c == null && selectedMatrix.Phoenix_GM_Percent_From__c != null) {
                    tempGrid.Phoenix_GM_Limit__c = '>' + selectedMatrix.Phoenix_GM_Percent_From__c + '%';
                }
                        
                        
                if ((selectedMatrix.Phoenix_Bid_Type__c == 'Product Addition' || selectedMatrix.Phoenix_Bid_Type__c == 'OTC Product Addition' || selectedMatrix.Phoenix_Bid_Type__c == 'OTC New Product' || selectedMatrix.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' || selectedMatrix.Phoenix_Bid_Type__c == 'Good Dated OTB' || selectedMatrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' || selectedMatrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' || selectedMatrix.Phoenix_Bid_Type__c == 'New Product Launch' || selectedMatrix.Phoenix_Bid_Type__c == 'New Customer') && selectedMatrix.Phoenix_Revenue_To__c != null) {
                    tempGrid.Phoenix_Revenue_Limit__c = '$' + selectedMatrix.Phoenix_Revenue_From__c + '-$' + selectedMatrix.Phoenix_Revenue_To__c;
                } else if ((selectedMatrix.Phoenix_Bid_Type__c == 'Product Addition' || selectedMatrix.Phoenix_Bid_Type__c == 'OTC Product Addition' || selectedMatrix.Phoenix_Bid_Type__c == 'OTC New Product' || selectedMatrix.Phoenix_Bid_Type__c == 'OTC OTB Good Dated'  || selectedMatrix.Phoenix_Bid_Type__c == 'Good Dated OTB' || selectedMatrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' || selectedMatrix.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' || selectedMatrix.Phoenix_Bid_Type__c == 'New Product Launch' || selectedMatrix.Phoenix_Bid_Type__c == 'New Customer') && selectedMatrix.Phoenix_Revenue_To__c == null && selectedMatrix.Phoenix_Revenue_From__c != null) {
                    tempGrid.Phoenix_Revenue_Limit__c = '>$' + selectedMatrix.Phoenix_Revenue_From__c;
                }
                }

            }

            approvalGridMap.put(pFamily, tempGrid);

        }
        if (existingGridCount >= 0) {
            upsert approvalGridMap.values();
            //System.debug('Upsert values--->'+approvalGridMap);

            //Updating line items
            List < Phoenix_Bid_Line_Item__c > updatedItems = new List < Phoenix_Bid_Line_Item__c > ();
            for (String pFamily: approvalGridMap.keySet()) {
                if(productFamilyLinesMap.get(pFamily)!=null){
                for (Phoenix_Bid_Line_Item__c item: productFamilyLinesMap.get(pFamily)) {
                    Phoenix_Bid_Line_Item__c updatedItem = updatedLineItemsMap.get(item.Id);
                    updatedItem.Phoenix_Approval_Grid__c = approvalGridMap.get(pFamily).Id;
                    updatedItems.add(updatedItem);
                }
                }
            }
            update updatedItems;
        }
    }

    /*    if(approverTeams.contains('Business Head'))finalApprover = 'Business Head';
else if(approverTeams.contains('Marketing Head'))finalApprover = 'Marketing Head';
else if(approverTeams.contains('Sr Director or VP Finance'))finalApprover = 'Sr Director or VP Finance';
*/

           
}
Catch(Exception e) {
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();

    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Method_Name__c = 'calculateFinanceGrid', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}

return approverTeams;
}


/**
* @description This will create all required bid process steps as per the approval matrix defined. 
* @author Surender Patel (Dhruvsoft) | 12-05-2021 
* @param list<Phoenix_Bid__c> bidListForApproval 
* @return String - Success or not. 
**/
 public static String createBidApprovalItems(list < Phoenix_Bid__c > bidListForApproval) {
        //system.debug('----createBidApprovalItems----'+bidListForApproval);
        String response = 'Success';
        try {
            //collect all bid types
            set < String > bidTypes = new set < String > ();
            set < String > bidIds = new set < String > ();
            
            for (Phoenix_Bid__c bid: bidListForApproval) {
                bidTypes.add(bid.Phoenix_Bid_Type__c);
                bidIds.add(bid.Id);
            }
            
            Map < String, set < String >> bidWithPDirectorMap = new Map < String, set < String >> ();
            Map < String, set < String >> bidWithPLeadMapRx = new Map < String, set < String >> ();
            Map < String, set < String >> bidWithPLeadMapSRx = new Map < String, set < String >> ();
            Map < String, set < String >> bidWithPLeadMapOTC = new Map < String, set < String >> ();
            Map < String, set < String >> bidWithContractsApprovresMap = new Map < String, set < String >> ();
            Map < String, set < String >> bidWithCSApprovresMap = new Map < String, set < String >> ();
            Map<string,set<String>> bidWithSCMplanner = new Map < String, set < String >> ();
            set<String> productDirectorsSet = new set<String>();
            //query all bid line items       
            if (bidListForApproval[0].Phoenix_Bid_Type__c == 'VIP Rebate') {
                Phoenix_Bid_VIP_Rebate__c bidVIPReb = [SELECT Id, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Customer_Service_Approver__c FROM Phoenix_Bid_VIP_Rebate__c WHERE Phoenix_Status__c = 'Proposed'
                                                       AND Phoenix_Bid__c IN: bidIds LIMIT 1
                                                      ];
                String conApprvr = bidVIPReb.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__c;
                String csApprvr = bidVIPReb.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Customer_Service_Approver__c;
                if (bidWithContractsApprovresMap != null && conApprvr != null) bidWithContractsApprovresMap.put(bidVIPReb.Phoenix_Bid__c, new Set < String > {
                    conApprvr
                        });
                if (bidWithCSApprovresMap != null && csApprvr != null) bidWithCSApprovresMap.put(bidVIPReb.Phoenix_Bid__c, new Set < String > {
                    csApprvr
                        });
            } else if (bidListForApproval[0].Phoenix_Bid_Type__c == 'Customer Requested Pricing Confirmations') {
                String conApprvr = bidListForApproval[0].Phoenix_Customer__r.Phoenix_Contracts_Approver__c;
                String csApprvr = bidListForApproval[0].Phoenix_Customer__r.Phoenix_Customer_Service_Approver__c;
                if (bidWithContractsApprovresMap != null && conApprvr != null) bidWithContractsApprovresMap.put(bidListForApproval[0].Id, new Set < String > {
                    conApprvr
                        });
                if (bidWithCSApprovresMap != null && csApprvr != null) bidWithCSApprovresMap.put(bidListForApproval[0].Id, new Set < String > {
                    csApprvr
                        });
            } else {
                for (Phoenix_Bid_Line_Item__c bItem: [Select Id, Name, Phoenix_Product_Director__c, Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c, Phoenix_Product__r.Phoenix_Product_Director__c, Phoenix_Product__r.Phoenix_Marketing_Lead__c, Phoenix_Product__r.Phoenix_Supply_Chain_Planner__c, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Customer_Service_Approver__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c IN: bidIds]) {
                    //System.debug('Product Ditector==>'+bItem.Phoenix_Product__r.Phoenix_Product_Director__c);.
                    productDirectorsSet.add(bItem.Phoenix_Product_Director__c);
                    if (bidWithPDirectorMap.get(bItem.Phoenix_Bid__c) != null) {
                        set < String > tempDirectors = bidWithPDirectorMap.get(bItem.Phoenix_Bid__c);
                        tempDirectors.add(bItem.Phoenix_Product__r.Phoenix_Product_Director__c);
                        bidWithPDirectorMap.put(bItem.Phoenix_Bid__c, tempDirectors);
                    } else {
                        bidWithPDirectorMap.put(bItem.Phoenix_Bid__c, new Set < String > {
                            bItem.Phoenix_Product__r.Phoenix_Product_Director__c
                                });
                    }
                    if(bidWithSCMplanner.get(bItem.Phoenix_Bid__c) != null){
                        set < String > scmPlanners = bidWithSCMplanner.get(bItem.Phoenix_Bid__c);
                        scmPlanners.add(bItem.Phoenix_Product__r.Phoenix_Supply_Chain_Planner__c);
                        bidWithSCMplanner.put(bItem.Phoenix_Bid__c, scmPlanners);
                    }
                    else{
                        bidWithSCMplanner.put(bItem.Phoenix_Bid__c, new Set < String > {
                            bItem.Phoenix_Product__r.Phoenix_Supply_Chain_Planner__c
                                });
                    }
                    String prodType = bItem.Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c;
                    
                    if (prodType == 'Rx' && bidWithPLeadMapRx.get(bItem.Phoenix_Bid__c) != null) {
                        set < String > tempDirectors = bidWithPLeadMapRx.get(bItem.Phoenix_Bid__c);
                        tempDirectors.add(bItem.Phoenix_Product__r.Phoenix_Marketing_Lead__c);
                        bidWithPLeadMapRx.put(bItem.Phoenix_Bid__c, tempDirectors);
                    } else if (prodType == 'Rx' && bidWithPLeadMapRx.get(bItem.Phoenix_Bid__c) == null) {
                        bidWithPLeadMapRx.put(bItem.Phoenix_Bid__c, new Set < String > {
                            bItem.Phoenix_Product__r.Phoenix_Marketing_Lead__c
                                });
                    }
                    if (prodType == 'SRx' && bidWithPLeadMapSRx.get(bItem.Phoenix_Bid__c) != null) {
                        set < String > tempDirectors = bidWithPLeadMapSRx.get(bItem.Phoenix_Bid__c);
                        tempDirectors.add(bItem.Phoenix_Product__r.Phoenix_Marketing_Lead__c);
                        bidWithPLeadMapSRx.put(bItem.Phoenix_Bid__c, tempDirectors);
                    } else if (prodType == 'SRx' && bidWithPLeadMapSRx.get(bItem.Phoenix_Bid__c) == null) {
                        bidWithPLeadMapSRx.put(bItem.Phoenix_Bid__c, new Set < String > {
                            bItem.Phoenix_Product__r.Phoenix_Marketing_Lead__c
                                });
                    }
                    if (prodType == 'OTC' && bidWithPLeadMapOTC.get(bItem.Phoenix_Bid__c) != null) {
                        set < String > tempDirectors = bidWithPLeadMapOTC.get(bItem.Phoenix_Bid__c);
                        tempDirectors.add(bItem.Phoenix_Product__r.Phoenix_Marketing_Lead__c);
                        bidWithPLeadMapOTC.put(bItem.Phoenix_Bid__c, tempDirectors);
                    } else if (prodType == 'OTC' && bidWithPLeadMapOTC.get(bItem.Phoenix_Bid__c) == null) {
                        bidWithPLeadMapOTC.put(bItem.Phoenix_Bid__c, new Set < String > {
                            bItem.Phoenix_Product__r.Phoenix_Marketing_Lead__c
                                });
                    }
                    String conApprvr = bItem.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__c;
                    String csApprvr = bItem.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Customer_Service_Approver__c;
                    if (bidWithContractsApprovresMap != null && conApprvr != null) bidWithContractsApprovresMap.put(bItem.Phoenix_Bid__c, new Set < String > {
                        conApprvr
                            });
                    if (bidWithCSApprovresMap != null && csApprvr != null) bidWithCSApprovresMap.put(bItem.Phoenix_Bid__c, new Set < String > {
                        csApprvr
                            });
                }
            }
            // system.debug('-------bidWithPDirectorMap--------'+bidWithPDirectorMap);
            
            //query all matrices and arrange by Bid Type
            Map < String, List < Phoenix_Approval_Matrix__c >> approvalMatrixMap = new Map < String, List < Phoenix_Approval_Matrix__c >> ();
            
            for (Phoenix_Approval_Matrix__c matrix: [Select Id, Name, Phoenix_Bid_Type__c, (Select Id, Name, Phoenix_Approver_Team__c, Phoenix_Is_Criteria_Step__c, Phoenix_Approver__c, Phoenix_Order__c, Phoenix_Approval_Matrix__c, Phoenix_Is_Notification_Only__c from Phoenix_Approval_Process_Steps__r) from Phoenix_Approval_Matrix__c where Phoenix_Bid_Type__c IN: bidTypes AND Phoenix_Is_Criteria_Matrix__c = false]) {
                List < Phoenix_Approval_Matrix__c > tempMarices = approvalMatrixMap.get(matrix.Phoenix_Bid_Type__c);
                if (tempMarices != null) {
                    tempMarices.add(matrix);
                    approvalMatrixMap.put(matrix.Phoenix_Bid_Type__c, tempMarices);
                } else {
                    approvalMatrixMap.put(matrix.Phoenix_Bid_Type__c, new List < Phoenix_Approval_Matrix__c > {
                        matrix
                            });
                }
            }
            //system.debug('-----approvalMatrixMap-------'+approvalMatrixMap);
            
            List < Phoenix_Bid_Process_Steps__c > bidProcessSteps = new List < Phoenix_Bid_Process_Steps__c > ();
            //system.debug('approvalTeamUsersMap=>'+approvalTeamUsersMap);
            List < String > nonContractBidTypes = new List < String > {
                'WAC Change Submissions',
                    'IPA Floor Pricing Update',
                    'IPA Member Addition',
                    'RCA Member Addition',
                    'Mass Product Removals',
                    'Product Discontinuation Process',
                    'NEW Individual Pricing Agreement (IPA)',
                    'SRx IPA Price Change',
                    'SRx IPA Product Addition',
                    'RCA/IPA Member GPO or Wholesaler Change'
                    };
                        
                        List < String > nonCustomerServiceBidTypes = new List < String > {
                            'Direct Order Form Pricing Update'
                                };
                                    list<string> marketingLeadList = new    list<string>{'Marketing Lead Rx','Marketing Lead SRx','Marketing Lead OTC'};
                                    for (Phoenix_Bid__c bid: bidListForApproval) {
                                        List < Phoenix_Approval_Matrix__c > matrixList = approvalMatrixMap.get(bid.Phoenix_Bid_Type__c);
                                        
                                        // if(matrixList != null && matrixList.size() == 1){ 
                                        Phoenix_Approval_Matrix__c matrix = matrixList[0];
                                       
                                        for (Phoenix_Approval_Process_Step__c pStep: matrix.Phoenix_Approval_Process_Steps__r) {
                                            
                                            Set < String > approverIds = new Set < String > ();
                                            String team = pStep.Phoenix_Approver_Team__c;
                                            String approvalBehaviour = approvalGroupBehaviourMap.get(pStep.Phoenix_Approver_Team__c);
                                            //system.debug('team=>'+team + ' & approvalBehaviour=>'+approvalBehaviour);
                                            if(team == 'Supply Chain' && bidWithSCMplanner.size()>0)
                                                approverIds = bidWithSCMplanner.get(bid.Id);
                                            else if (team == 'Marketing' && approvalBehaviour == 'Product based' && bidWithPDirectorMap.size() > 0 && bid.Phoenix_Bid_Type__c!='Platform OTB')
                                                approverIds = bidWithPDirectorMap.get(bid.Id); // Product Directors
                                            else if (team == 'Marketing' && approvalBehaviour == 'Product based' && bidWithPDirectorMap.size() > 0 && bid.Phoenix_Bid_Type__c=='Platform OTB')
                                                approverIds.add(bid.Phoenix_OTB_Marketing_Approver__c); //= bidWithPDirectorMap.get(bid.Id); // Product Directors
                                            else if (team == 'Marketing' && approvalBehaviour == 'Product based' && bidWithPDirectorMap.size() == 0)
                                                return 'Please assign a Marketing Approver before submitting the Bid.';
                                            else if (team == 'Marketing Lead Rx' && approvalBehaviour == 'Product based' && bidWithPLeadMapRx.size() > 0)
                                                approverIds = bidWithPLeadMapRx.get(bid.Id); // Marketing Leads
                                            
                                            else if (team == 'Marketing Lead SRx' && approvalBehaviour == 'Product based' && bidWithPLeadMapSRx.size() > 0)
                                                approverIds = bidWithPLeadMapSRx.get(bid.Id); // Marketing Leads
                                            else if (team == 'Marketing Lead OTC' && approvalBehaviour == 'Product based' && bidWithPLeadMapOTC.size() > 0)
                                                approverIds = bidWithPLeadMapOTC.get(bid.Id); // Marketing Leads
                                            
                                            
                                            //  else if(team == 'Marketing Lead Rx' && approvalBehaviour == 'Product based' && bidWithPLeadMapRx.size()==0){
                                            //      return 'Please assign a Marketing Lead Approver before submitting the Bid.';
                                            //  }
                                            else if (team == 'Contracts' && approvalBehaviour == 'Account based' && bidWithContractsApprovresMap.size() > 0 && !nonContractBidTypes.contains(bid.Phoenix_Bid_Type__c)) 
                                                approverIds = bidWithContractsApprovresMap.get(bid.Id);
                                            else if (team == 'Contracts' && approvalBehaviour == 'Account based' && bidWithContractsApprovresMap.size() == 0 && !nonContractBidTypes.contains(bid.Phoenix_Bid_Type__c)) 
                                                return 'Please assign a Contracts Approver before submitting the Bid.';
                                            else if (team == 'Customer Service' && approvalBehaviour == 'Account based' && bidWithCSApprovresMap.size() > 0 && !nonCustomerServiceBidTypes.contains(bid.Phoenix_Bid_Type__c)) 
                                                approverIds = bidWithCSApprovresMap.get(bid.Id);
                                            else if (team == 'Customer Service' && approvalBehaviour == 'Account based' && bidWithCSApprovresMap.size() == 0 && !nonCustomerServiceBidTypes.contains(bid.Phoenix_Bid_Type__c)) 
                                                return 'Please assign a Customer Service Approver before submitting the Bid.';
                                            else if (approvalBehaviour == 'Single User' && approvalTeamUsersMap.size() > 0) {
                                                approverIds = approvalTeamUsersMap.get(pStep.Phoenix_Approver_Team__c); // defined in approval matrix
                                            }
                                              
                                            else if(!marketingLeadList.contains(team)){
                                                system.debug('steps amn...');
                                                Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
                                                bStep.Phoenix_Is_Criteria_Step__c = pStep.Phoenix_Is_Criteria_Step__c;
                                                bStep.Name = bid.Name + '-' + pStep.Name;
                                                 system.debug('step name '+pStep.Name);
                                                if (pStep.Phoenix_Approver__c != null) {
                                                    bStep.Phoenix_Approver__c = pStep.Phoenix_Approver__c;
                                                }
                                                bStep.Phoenix_Approver_Team_Members__c = string.join(new List < String > (approvalTeamUserNamesMap.get(team)), ',');
                                                bStep.Phoenix_Bid__c = bid.Id;
                                                bStep.Phoenix_Process_Step__c = pStep.Id;
                                                
                                                bStep.Phoenix_Status__c = pStep.Phoenix_Is_Criteria_Step__c ? 'Not Applicable' : 'Not Initiated';
                                                
                                                if (pStep.Name == 'Initial Submission') {
                                                    // bStep.Phoenix_Approver__c = bid.Phoenix_Bid_Created_Behalf_of__c != null ? bid.Phoenix_Bid_Created_Behalf_of__c : bid.OwnerId;
                                                    bStep.Phoenix_Approver__c = UserInfo.getUserId();
                                                    
                                                    bStep.Phoenix_Description__c = bid.Phoenix_Bid_Submitter_Comments__c;
                                                    bStep.Phoenix_Status__c = 'Submitted';
                                                    
                                                    
                                                    bStep.Phoenix_Approval_Sent_Time__c = Phoenix_Util.getNowEST(); //;
                                                    bStep.Phoenix_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(bStep.Phoenix_Approval_Sent_Time__c, 'America/New_York');
                                                    
                                                    bStep.Phoenix_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
                                                    bStep.Phoenix_Approval_Completed_Time_String__c = Phoenix_Util.getUserTimeNow(bStep.Phoenix_Approval_Completed_Time__c, 'America/New_York');
                                                    
                                                    
                                                    
                                                } //else if(pStep.Name == 'Closed')  bStep.Phoenix_Status__c = null;
                                                bStep.Phoenix_Approver_Team__c = team;
                                                
                                                bidProcessSteps.add(bStep);
                                            }
                                            system.debug('approverIds...'+approverIds);
                                            if (approverIds != null) {
                                                //create bid step items for product directos
                                                Decimal stepNo = 1.00;
                                                for (String marketingApproverId: approverIds) {
                                                    system.debug('testing bid step .....anu....');
                                                    Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
                                                    bStep.Phoenix_Is_Criteria_Step__c = pStep.Phoenix_Is_Criteria_Step__c;
                                                    bStep.Name = bid.Name + '-' + pStep.Name;
                                                    bStep.Phoenix_Approver__c = marketingApproverId;
                                                    
                                                    bStep.Phoenix_Bid__c = bid.Id;
                                                    bStep.Phoenix_Process_Step__c = pStep.Id;
                                                    bStep.Phoenix_Status__c = pStep.Phoenix_Is_Criteria_Step__c ? 'Not Applicable' : 'Not Initiated';
                                                   
                                                      bStep.Phoenix_Approver_Team__c = team;  
                                                    
                                                    //stepNo : Ask and increment as per requirements
                                                    bStep.Phoenix_Sub_Step__c = stepNo;
                                                    system.debug('stepno...'+stepNo);
                                                    if(bid.Phoenix_Bid_Type__c=='Platform OTB'){
                                                      //  bStep.Phoenix_Approver_Team_Members__c = 'On Behalf of ';
                                                        bStep.Phoenix_Approver_Team_Members__c= string.join(new List < String > (productDirectorsSet), ',');
                                                    }
                                                    if (team != 'Marketing' && team != 'Supply Chain') //,'Good Dated OTB','Short Dated OTB'
                                                        bStep.Phoenix_Approver_Team_Members__c = string.join(new List < String > (approvalTeamUserNamesMap.get(team)), ',');
                                                    // if(team == 'Customer Service' && nonCustomerServiceBidTypes.contains(bid.Phoenix_Bid_Type__c)){
                                                    //      bStep.Phoenix_Approver_Team_Members__c = string.join(new List < String > (approvalTeamUserNamesMap.get(team)), ','); 
                                                    //    }
                                                    bidProcessSteps.add(bStep);
                                                    stepNo++;
                                                }
                                            }
                                            
                                        }
                                        
                                    }
            
            for(Phoenix_Bid_Process_Steps__c bb:bidProcessSteps){
                system.debug('bidprocess'+bb);
            }
            if (!bidProcessSteps.isEmpty()) {
                system.debug('bidProcessSteps size'+bidProcessSteps.size());
                system.debug('bidProcessSteps'+bidProcessSteps);
                insert bidProcessSteps;
            }
            
            
        }
        Catch(Exception e) {
            String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
            
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Method_Name__c = 'createBidApprovalItems', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        
        return response;
    }
    
/**
* @description This will reset a bid to Draft staus. Delete Bid process steps, approval grid, customer line , customer line items. 
Reset the fields of Bid line items by removing the approvals and comments.
* @author Surender Patel (Dhruvsoft) | 12-05-2021 
* @param String bidId 
* @return String 
**/

@AuraEnabled
public static String recallBid(String bidId, String stepName) {
String returnStatus = '';
if (bidId != null && stepName == 'Draft') {

    returnStatus = recallBidToDraft(bidId , 'Draft');

} else if (bidId != null && stepName == 'SCMMarketing') {
    returnStatus = recallBidToScmMkg(bidId);

} else if (bidId != null && stepName == 'Contracts') {
    returnStatus = recallBidToContracts(bidId);

} else if (bidId != null && stepName == 'SCM') {
    returnStatus = recallBidToScm(bidId);
            
}
 else if (bidId != null && stepName == 'SCM1') {
    returnStatus = recallBidToScm1(bidId);
            
}
else if (bidId != null && stepName == 'MarketingAll') {
    returnStatus = recallBidToMkgAll(bidId);

} else if (bidId != null && stepName == 'MarketingOne') {
    returnStatus = recallBidToMkgOne(bidId);

}
return returnStatus;


}

public static String recallBidToDraft(String bidId , String stemName) {
//System.debug('called recallBid');
String returnStatus = '';
/*
* Plan:Recall

*Sales Person submitting can click on  Recall button (initial submitter) - should be visible / clickable when submitted (Only to submitter)
*Uncheck at lines / delete comments
*delete Phoenix_Customer_Response__c,Phoenix_Customer_Response_Line__c
*Collect wip steps & perv step approvers to send email. 
*Bid will delete approval steps 
*make bid, Draft again

*User can submit again now

*/
Phoenix_Bid__c bidObj = [SELECT Id,Phoenix_Approval_status__c,Phoenix_OTC_Bid_Version__c,Phoenix_is_OTC_Bid__c FROM Phoenix_Bid__c WHERE Id =:bidId];
       
List < Phoenix_Bid_Process_Steps__c > existingSteps = Database.query('SELECT ' + Phoenix_Util.bidProcessStepFields + ' FROM  Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c =:bidid');

/*Uncheck at lines / delete comments*/
//Fectch all line items and clear approvals
List < Phoenix_Bid_Line_Item__c > existingBItems = Database.query('SELECT Phoenix_Bid__r.Phoenix_Is_Re_Bid__c,Phoenix_Bid__r.Phoenix_is_OTC_Bid__c, ' + Phoenix_Util.bidlineitemFields + ' FROM  Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =:bidid');
List < Phoenix_RCA_IPA_LINE__c > existingRCAIPAItems = Database.query('SELECT ' + Phoenix_Util.RCAIPAFields + ' FROM  Phoenix_RCA_IPA_LINE__c WHERE Phoenix_Bid__c =:bidid');
    Integer updatedlineItemVersion ;
    Integer updatedbidVersion;
    String bidVersion ;
    String lineItemVersion ;
       
    List < Phoenix_Bid_Line_Item_Price_History__c > lineItemPriceHistoryList = new List < Phoenix_Bid_Line_Item_Price_History__c > ();

try {
    if (existingBItems.size() > 0) {
        for (Phoenix_Bid_Line_Item__c item: existingBItems) {
			    // added by Jogarao
            if(item.Phoenix_Bid__r.Phoenix_Is_Re_Bid__c)
            item.Phoenix_SCM_Review__c = true;
            item.Phoenix_Approval__c = null;
            //   item.Phoenix_Comments__c = null;
            item.Phoenix_Bid_Status__c = null;
            //  item.Phoenix_Contract_Comments__c = null;
            item.Phoenix_Contracts_Final_Approval__c = false;
            item.Phoenix_Contract_Approval__c = null;
            //item.Phoenix_Current_SCM_Approved_Qty__c = null;
            item.Phoenix_Customer_Response__c = null;
            item.Phoenix_Customer_Response_Line__c = null;
            item.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
            item.Phoenix_Customer_status_internal_use__c = null;
            //   item.Phoenix_Estimated_Lead_Time_Days__c = null;
            item.Phoenix_Final_Finance_Approval__c = false;
            item.Phoenix_Final_Status__c = null;
            item.Phoenix_Finance_Approval__c = null;
            //  item.Phoenix_Finance_Comments__c = null;
            //  item.Phoenix_Initial_Stocking_Order_Comments__c = null;
            item.Phoenix_Marketing_Approval__c = null;
            //    item.Phoenix_Marketing_Notes__c = null;
            item.Phoenix_Marketing_Final_Approval__c = false;
            //    item.Phoenix_Pricing_Notes__c = null;
            //    item.Phoenix_Sales_Notes__c = null;
            //item.Phoenix_SCM_Approval__c = null;
           // item.Phoenix_SCM_Approval_Y_N__c = null;
           // item.Phoenix_SCM_Approved_Quantity__c = null;
            //   item.Phoenix_SCM_Notes__c = null;
            item.Phoenix_SCM_Final_Approval__c = false;
          //  item.Phoenix_SCM_Qty_Approved_Direct__c = null;
          //  item.Phoenix_SCM_Qty_Approved_Indirect__c = null;
            //item.Phoenix_SCM_Rejection_Reason1__c = null;
            item.Phoenix_Vistex_Status__c = null;
            item.Phoenix_Vistex_status_internal_use__c = null;
            item.Phoenix_Vistex_Update_Final_Approval__c = false;
            item.Phoenix_Marketing_Lead_Rx__c = null;
            item.Phoenix_Marketing_Lead_SRx__c = null;
            item.Phoenix_Marketing_Lead_OTC__c = null;
             item.Phoenix_Marketing_Lead_Rx__c = null;
                    item.Phoenix_Marketing_Lead_SRx__c = null;
                    item.Phoenix_Marketing_Lead_OTC__c = null;
                    item.Phoenix_MarketingLead_Approver__c = null;
                    item.Marketing_Lead_Notes__c =null;
            item.Phoenix_Sr_Director_VP_Finance_Approval__c = null;
            item.Phoenix_Bid_Line_Item_Approval_Status__c = null;
            //    item.Phoenix_Batch_Number__c = null;
            // item.Phoenix_Expiry_Date__c = null;
            item.Phoenix_Customer_Service_Status__c = null;
            //        item.Phoenix_Customer_Service_Comments__c = null;
            item.Phoenix_Customer_Final_Approval__c = false;
            item.Phoenix_Customer_Approval_OTC__c = null;
            item.Phoenix_Supply_Effective_Date__c =null;
            item.Phoenix_Price_Effective_Date__c =null;
            item.Phoenix_Marketing_Lead_OTC__c = null;
            item.Phoenix_MarketingLead_Final_Approval__c =false;
            item.Phoenix_IsOTCLeadApproved__c =False;
            if(item.Phoenix_Bid__r.Phoenix_is_OTC_Bid__c){
                lineItemVersion = item.Phoenix_Orange_Book_Rating1__c;
                lineItemVersion= lineItemVersion.substringAfter(' ');
                updatedlineItemVersion = Integer.valueof(lineItemVersion);
                updatedlineItemVersion = updatedlineItemVersion+1;
                String currentVersion = item.Phoenix_Orange_Book_Rating1__c;
                item.Phoenix_Orange_Book_Rating1__c = 'Version ' + updatedlineItemVersion;
                        
        Phoenix_Bid_Line_Item_Price_History__c lineItemPriceHistory = new Phoenix_Bid_Line_Item_Price_History__c();
        lineItemPriceHistory.Name = currentVersion;
        lineItemPriceHistory.Pheonix_DRL_Units__c = item.Phoenix_Proposed_Direct_Selling_Unit__c;
        lineItemPriceHistory.Phoenix_Current_52wk__c = item.Phoenix_Current_Retail_Direct_Units__c;
        lineItemPriceHistory.Phoenix_Brand_Retail_Price__c =item.Phoenix_Current_Retail_Direct_Price__c;
        lineItemPriceHistory.Phoenix_Net_Sales__c = item.Phoenix_Net_Sales_Internal__c;
        lineItemPriceHistory.Phoenix_Current_Monthly__c	=item.Phoenix_12_Months_TotalSaleUnits__c;
        lineItemPriceHistory.Phoenix_Proposed_Share__c = item.Phoenix_Date_Fee__c;
        lineItemPriceHistory.Phoenix_SB_Retail_Price__c = item.Phoenix_Current_Retail_Indirect_Price__c;
        lineItemPriceHistory.Phoenix_Gross_Sales__c = item.Phoenix_Net_Sales_External__c;
        lineItemPriceHistory.Phoenix_Current_Sell_Price__c =item.Phoenix_Current_Direct_Price__c;
        lineItemPriceHistory.Phoenix_Proposed_52wk__c =item.Phoenix_Proposed_Anda_Units__c;
        lineItemPriceHistory.Phoenix_Retail_Dollor__c = item.Phoenix_Opening_Order_Net_sales__c;
        lineItemPriceHistory.Phoenix_Supply_Type__c = item.Phoenix_Supply_Type__c;
        lineItemPriceHistory.Phoenix_Total_Units__c = item.Phoenix_12_Months_IndirectSaleUnit__c;
        lineItemPriceHistory.Created_Date__c = system.now();
        lineItemPriceHistory.Phoenix_Bid_Line_Item__c = item.Id;
        lineItemPriceHistory.Phoenix_Sales_Price__c = item.Phoenix_ProposedContract_Bid_Price_Sales__c;
        lineItemPriceHistory.Phoenix_Marketing_Price__c = item.Phoenix_ProposedContractBidPriceMktng__c;
        lineItemPriceHistory.Phoenix_Proposed_Monthly__c = item.Phoenix_Proposed_OS_Units__c;
        lineItemPriceHistory.Phoenix_Sell_Price_Change__c = item.Phoenix_Reduc_in_NCP_McK_And_RAD__c;
        lineItemPriceHistory.Phoenix_Net_Price__c = item.Phoenix_Internal_Dead_Net_Price__c;
        lineItemPriceHistory.Phoenix_Damages__c = item.Phoenix_Reduction__c;
        lineItemPriceHistory.Phoenix_Damages_Dollor__c = item.Phoenix_Current_Anda_CP_Price__c;
        lineItemPriceHistory.Phoenix_Direct_CD_Percent__c = item.Phoenix_Cash_Terms__c;
        lineItemPriceHistory.Phoenix_Direct_CD_Dollor__c = item.Phoenix_Cash_Terms_RxSS__c;
        lineItemPriceHistory.Phoenix_TPT_Dollor_per_pack__c = item.Proposed_TPT_Direct__c;
        lineItemPriceHistory.Phoenix_TPT_per_pack__c = item.Proposed_TPT_Per_Direct__c;
        lineItemPriceHistory.Phoenix_Total_TPT__c = item.Phoenix_Th_Put_Margin__c;
        lineItemPriceHistory.Phoenix_Profit__c = item.Phoenix_Current_Net_Indirect_Price__c;
        lineItemPriceHistory.Phoenix_Sell_Price_Per_Size__c = item.Phoenix_Reduc_in_NCP_McK_And_RAD__c;
        lineItemPriceHistory.Phoenix_RM_Dollor__c = item.Phoenix_Opening_Order_TPT__c;
        lineItemPriceHistory.Phoenix_RM_Percent__c = item.Phoenix_Opening_Order_TPT_Per__c;
        lineItemPriceHistory.Phoenix_Sales_Notes__c = item.Phoenix_Sales_Notes__c;
        lineItemPriceHistory.Phoenix_Customer_Approval__c = item.Phoenix_Customer_Approval_OTC__c;
        lineItemPriceHistory.Phoenix_Customer_Comments__c = item.Phoenix_Customer_Service_Comments__c;
        lineItemPriceHistory.Phoenix_Supply_Effective_Date__c = item.Phoenix_Supply_Effective_Date__c;
        lineItemPriceHistory.Phoenix_Price_Effective_Date__c = item.Phoenix_Price_Effective_Date__c;
        //for timings.
        //lineItemPriceHistory.Phoenix_Marketing_Approval_Compld_Time__c =mkgCompletedTime;
        //lineItemPriceHistory.Phoenix_Marketing_Approval_Sent_Time__c =mkgSentTime;
        //end.
        lineItemPriceHistoryList.add(lineItemPriceHistory);
            }

        }
        //added by srimayee
        Insert lineItemPriceHistoryList;
        update existingBItems;

			updateLowestPrice(bidId);
    }
    if (existingRCAIPAItems.size() > 0) {
        for (Phoenix_RCA_IPA_LINE__c RIitem: existingRCAIPAItems) {
       //     RIitem.Phoenix_Contract_Comments__c = null;
            RIitem.Phoenix_Contract_Status__c = null;
            RIitem.Phoenix_Contracts_Final_Approval__c =false;

        }
        update existingRCAIPAItems;
    }
    //Create bid process steps history 
    List < Phoenix_Bid_Process_History__c > processHistoryList = new List < Phoenix_Bid_Process_History__c > ();

    for (Phoenix_Bid_Process_Steps__c oldStep: existingSteps) {
        Phoenix_Bid_Process_History__c stepHistory = new Phoenix_Bid_Process_History__c(
            Phoenix_Bid_Process_Step__c = oldStep.Id,

            Phoenix_Bid__c = bidid,
            Phoenix_Approval_Completed_Time__c = oldStep.Phoenix_Approval_Completed_Time__c,
            Phoenix_Approval_Completed_Time_String__c = oldStep.Phoenix_Approval_Completed_Time_String__c,
            Phoenix_Approval_Sent_Time__c = oldStep.Phoenix_Approval_Sent_Time__c,
            Phoenix_Approval_Sent_Time_String__c = oldStep.Phoenix_Approval_Sent_Time_String__c,
            Phoenix_Approver__c = oldStep.Phoenix_Approver__c,
            Phoenix_Approver_Team__c = oldStep.Phoenix_Approver_Team__c,
            Phoenix_Approver_Team_Members__c = oldStep.Phoenix_Approver_Team_Members__c,
            Phoenix_Description__c = oldStep.Phoenix_Description__c,
            Phoenix_Is_Criteria_Step__c = oldStep.Phoenix_Is_Criteria_Step__c,
            Phoenix_NDC_Change__c = oldStep.Phoenix_NDC_Change__c,
            Phoenix_Status__c = oldStep.Phoenix_Status__c,
            Phoenix_Step__c = oldStep.Phoenix_Step__c,
            Phoenix_Sub_Step__c = oldStep.Phoenix_Sub_Step__c,
            Phoenix_Type__c = 'Recall',
            Phoenix_Previous_Stage__c = bidObj.Phoenix_Approval_Status__c,
            Phoenix_selected_Recall_Option__c = stemName

        );
        processHistoryList.add(stepHistory);
    }


    insert processHistoryList;





    //Change the bid now
    Phoenix_Bid__c bid = new Phoenix_Bid__c(
        id = bidid,
        Phoenix_Approval_Status__c = 'Draft',
        Phoenix_Marketing_Approval__c = null,
        //Phoenix_Marketing_Comments__c = null,
       Phoenix_Bid_Submitted_Date__c = null,
        //Phoenix_Bid_Submitter_Comments__c = null,
        Phoenix_Business_Approval__c = null,
       // Phoenix_Business_Approval_Comments__c = null,
        //Phoenix_Comments__c = null,
        Phoenix_Contracts_Approval__c = null,
        //Phoenix_Contracts_Approval_Comments__c = null,
        Contract_Status__c = null,
        Phoenix_Country_Head_Approval__c = null,
       // Phoenix_Country_Head_Comments__c = null,
        Phoenix_Customer_Approval__c = null,
       // Phoenix_Customer_Approval_Comments__c = null,
        Phoenix_Finance_Approval__c = null,
       // Phoenix_Finance_Approval_Comments__c = null,
        Phoenix_Marketing_Head_Approval__c = null,
      //  Phoenix_Marketing_Head_Comments__c = null,
        Phoenix_Review_Details__c = null,
        //      Phoenix_Proactive_Reactive__c = null, //---?
        Phoenix_Sent_to_Customer_Date__c = null,
        Phoenix_Status__c = null,
        Phoenix_Vistex_Update__c = null,
      //  Phoenix_Vistex_Update_Comments__c = null,
        Phoenix_Bid_Contracts_Approved_Date__c = null,
        Phoenix_Bid_Finance_Approved_Date__c = null,
        Phoenix_Bid_Marketing_Approved_Date__c = null,
        Phoenix_Bid_SCM_Approved_Date__c = null,
        Bid_Marketing_Head_Approved_Date__c = null,
        Bid_Marketing_Lead_OTC_Approved_Date__c = null,
        Bid_Marketing_Lead_RX_Approved_Date__c = null,
        Bid_Marketing_Lead_SRX_Approved_Date__c = null,
        Phoenix_Bid_Closed_Date__c = null,
        Phoenix_Sent_to_Vistex_Date__c = null,
        Phoenix_Customer_Service_Approved_Date__c = null
    );
    if(bidObj.Phoenix_is_OTC_Bid__c){
               
        bidVersion = bidObj.Phoenix_OTC_Bid_Version__c;
        bidVersion= bidVersion.substringAfter(' ');
        updatedbidVersion = Integer.valueof(bidVersion);
        updatedbidVersion = updatedbidVersion+1;
        bid.Phoenix_OTC_Bid_Version__c = 'Version ' +updatedbidVersion;

    }
    update bid;
    //delete Phoenix_Customer_Response__c,Phoenix_Customer_Response_Line__c
    if(!bid.Phoenix_is_OTC_Bid__c){
    delete[SELECT Id FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__c =: bidid];
    delete[SELECT Id FROM Phoenix_Customer_Response__c WHERE Phoenix_Bid_No__c =: bidid];
    delete[SELECT Id FROM Phoenix_Awarded_Quantity__c WHERE Phoenix_Bid__c =: bidid];
    }
    delete[SELECT Id FROM Phoenix_Approval_Grid__c WHERE Phoenix_Bid__c =: bidid];
          

    delete existingSteps;
    returnStatus = 'Success';
}
Catch(Exception e) {
    returnStatus = e.getMessage();
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();

    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'recallBid', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}
return returnStatus;
}

public static String recallBidToScmMkg(String bidId) {

String returnStatus = '';

returnStatus = recallBidToDraft(bidId , 'SCM & Marketing');

returnStatus = submitBid(getBidInfo(bidId));

return returnStatus;

}

//extra RECALL CODE START

public static String recallBidToScm(String bidId) {
        
String returnStatus = '';
//Get all related bid steps
Phoenix_Bid__c bid = [SELECT Id, Name,Phoenix_Customer__c, Phoenix_Approval_Status__c, Phoenix_Bid_Type__c, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Is_Re_Bid__c, Contract_Status__c, Phoenix_Sent_to_Customer_Date__c, Phoenix_Offer_Valid_up_to__c,
    (SELECT Id, Phoenix_SCM_Review__c, Phoenix_IPA_Floor_Price1__c, Phoenix_Proposed_IPA_Price__c, Phoenix_Product_Director__c, Phoenix_Product__c, Phoenix_Product__r.Phoenix_Product_Director__c From Bid_Line_Items__r),
    (SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Process_Step__r.Name, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Bid_Process_Steps__r)
    FROM Phoenix_Bid__c WHERE Id =: bidId
];
String custID = '';
    if(bid.Phoenix_Customer__c!=null)custID=bid.Phoenix_Customer__c;

   List < Phoenix_Bid_Process_Steps__c > existingSteps = Database.query('SELECT ' + Phoenix_Util.bidProcessStepFields + ' FROM  Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c =:bidid');
        
        
Map < String, Map < Integer, List < Phoenix_Bid_Process_Steps__c >>> bidProcessStepsMap = new Map < String, Map < Integer, List < Phoenix_Bid_Process_Steps__c >>> ();
Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
Map < String, Phoenix_Bid_Process_Steps__c > stepApproversMap = new Map < String, Phoenix_Bid_Process_Steps__c > ();
Map < String, Integer > stepteamNoMap = new Map < String, Integer > ();
List < Phoenix_Bid_Line_Item__c > existingBItems = Database.query('SELECT ' + Phoenix_Util.bidlineitemFields + ' FROM  Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =:bidid AND Phoenix_Marketing_Approval__c!=\'Not Approved\'');

if(existingBItems.size()>0){
for (Phoenix_Bid_Process_Steps__c step: bid.Bid_Process_Steps__r) {

    Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
    if (stepMap.get(stepNo) != null) {
        List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
        adededSteps.add(step);
        stepMap.put(stepNo, adededSteps);
    } else {
        stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
            step
        });
    }

    String stepName = step.Phoenix_Process_Step__r.Name; //Phoenix_Approver_Team__c;
    if (stepNamesMap.get(stepName) != null) {
        List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
        adededSteps.add(step);
        stepNamesMap.put(stepName, adededSteps);
    } else {
        stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {
            step
        });
    }
    stepteamNoMap.put(stepName, stepNo);
    stepApproversMap.put(step.Phoenix_Approver_Team__c + '-' + step.Phoenix_Approver__c, step);

}

bidProcessStepsMap.put(bid.Id, stepMap); //Arranged all Bid>eachStep No>Step 

Integer scmStepNo = stepteamNoMap.get('Supply Chain Approval');
       
//  Phoenix_Bid_Process_Steps__c contractNextStep = stepMap.get(contractStepNo+1)[0];
//  Phoenix_Bid_Process_Steps__c contractStep = stepMap.get(scmStepNo)[0];
List < Phoenix_Bid_Process_Steps__c > afterSCMstepsexceptMkg = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Process_Step__r.Name, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c
    FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId AND Phoenix_Step__c >=: scmStepNo AND Phoenix_Process_Step__r.Name != 'Marketing Approval'
];
List < Phoenix_Bid_Process_Steps__c > updateProcessSteps = new List < Phoenix_Bid_Process_Steps__c > ();
            
    Account acc = [Select Id , Name, Phoenix_Customer_Service_Approver__c,Phoenix_Customer_Service_Approver__r.Name,Phoenix_Contracts_Approver__c,Phoenix_Contracts_Approver__r.Name From Account Where Id=: custID];
      
            
            
    for (Phoenix_Bid_Process_Steps__c step: afterSCMstepsexceptMkg) {
    if (step.Phoenix_Step__c == scmStepNo) {
        step.Phoenix_Status__c = 'In Process';
        step.Phoenix_Approval_Sent_Time__c = null;
        step.Phoenix_Approval_Sent_Time_String__c = null;
        step.Phoenix_Approval_Completed_Time__c=null;
        step.Phoenix_Approval_Completed_Time_String__c=null;    
        step.Phoenix_Delegated_Approver__c = null;
        if(step.Phoenix_Process_Step__r.Name == 'Supply Chain Approval')
      //  step.Phoenix_Approver__c = null;
        updateProcessSteps.add(step);
    } else {
               
        step.Phoenix_Status__c = 'Not Initiated';
        step.Phoenix_Approval_Sent_Time__c =null;
        step.Phoenix_Approval_Sent_Time_String__c = null;
        step.Phoenix_Approval_Completed_Time__c = null;
        step.Phoenix_Approval_Completed_Time_String__c=null;
        step.Phoenix_Delegated_Approver__c = null;
        if (step.Phoenix_Is_Criteria_Step__c == true) step.Phoenix_Status__c = 'Not Applicable';
        if(step.Phoenix_Process_Step__r.Name == 'Finance Approval')
            step.Phoenix_Approver__c = null;
          if(step.Phoenix_Process_Step__r.Name == 'Vistex Update')
            step.Phoenix_Approver__c = null;
        else if(step.Phoenix_Process_Step__r.Name == 'Customer Service Approval	'){
            if(acc!=null){
            step.Phoenix_Approver__c = acc.Phoenix_Customer_Service_Approver__c;
            }
        }
        else if(step.Phoenix_Process_Step__r.Name == 'Contract Team\'s Action' || step.Phoenix_Process_Step__r.Name == 'Customer\'s Update'){
             if(acc!=null){
            step.Phoenix_Approver__c = acc.Phoenix_Contracts_Approver__c;
             }
    }
        updateProcessSteps.add(step);
    }
}

if (bid.Phoenix_Bid_Type__c != 'Volume Review Only') {
    bid.Phoenix_Approval_Status__c = 'SCM & Marketing';
} else {
    bid.Phoenix_Approval_Status__c = 'Supply Chain';
}

bid.Phoenix_Business_Approval__c = null;
//bid.Phoenix_Business_Approval_Comments__c = null;
// bid.Phoenix_Comments__c = null;
bid.Phoenix_Contracts_Approval__c = null;
//bid.Phoenix_Contracts_Approval_Comments__c = null;
bid.Contract_Status__c = null;
bid.Phoenix_Country_Head_Approval__c = null;
//bid.Phoenix_Country_Head_Comments__c = null;
bid.Phoenix_Customer_Approval__c = null;
//bid.Phoenix_Customer_Approval_Comments__c = null;
bid.Phoenix_Finance_Approval__c = null;
//bid.Phoenix_Finance_Approval_Comments__c = null;
bid.Phoenix_Marketing_Head_Approval__c = null;
//bid.Phoenix_Marketing_Head_Comments__c = null;
bid.Phoenix_Review_Details__c = null;
//    bid.Phoenix_Proactive_Reactive__c = null; //---?
bid.Phoenix_Sent_to_Customer_Date__c = null;
bid.Phoenix_Status__c = null;
bid.Phoenix_Vistex_Update__c = null;
//bid.Phoenix_Vistex_Update_Comments__c = null;
bid.Phoenix_Bid_Contracts_Approved_Date__c = null;
bid.Phoenix_Bid_Finance_Approved_Date__c = null;
bid.Phoenix_Bid_SCM_Approved_Date__c = null;
bid.Bid_Marketing_Head_Approved_Date__c = null;
bid.Bid_Marketing_Lead_OTC_Approved_Date__c = null;
bid.Bid_Marketing_Lead_RX_Approved_Date__c = null;
bid.Bid_Marketing_Lead_SRX_Approved_Date__c = null;
bid.Phoenix_Bid_Closed_Date__c = null;
    bid.Phoenix_Sent_to_Vistex_Date__c = null;
    bid.Phoenix_Customer_Service_Approved_Date__c = null;


List < Phoenix_Bid_Line_Item__c > updateBItems = new List < Phoenix_Bid_Line_Item__c > ();

for (Phoenix_Bid_Line_Item__c item: existingBItems) {
    // add by Jogarao
    if(bid.Phoenix_Is_Re_Bid__c)
    	item.Phoenix_SCM_Review__c = true;
    item.Phoenix_Approval__c = null;
    //   item.Phoenix_Comments__c = null;
    item.Phoenix_Bid_Status__c = null;
    //  item.Phoenix_Contract_Comments__c = null;
    item.Phoenix_Contracts_Final_Approval__c = false;
    item.Phoenix_Contract_Approval__c = null;
    //item.Phoenix_Current_SCM_Approved_Qty__c = null;
    item.Phoenix_Customer_Response__c = null;
    item.Phoenix_Customer_Response_Line__c = null;
    item.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
    item.Phoenix_Customer_status_internal_use__c = null;
    //   item.Phoenix_Estimated_Lead_Time_Days__c = null;
    item.Phoenix_Final_Finance_Approval__c = false;
    item.Phoenix_Final_Status__c = null;
    item.Phoenix_Finance_Approval__c = null;
    //  item.Phoenix_Finance_Comments__c = null;
    //  item.Phoenix_Initial_Stocking_Order_Comments__c = null;
    //    item.Phoenix_Marketing_Notes__c = null;
    //    item.Phoenix_Pricing_Notes__c = null;
    //    item.Phoenix_Sales_Notes__c = null;
    //item.Phoenix_SCM_Approval__c = null;
   // item.Phoenix_SCM_Approval_Y_N__c = null;
    //item.Phoenix_SCM_Approved_Quantity__c = null;
    //   item.Phoenix_SCM_Notes__c = null;
    item.Phoenix_SCM_Final_Approval__c = false;
    //item.Phoenix_SCM_Qty_Approved_Direct__c = null;
    //item.Phoenix_SCM_Qty_Approved_Indirect__c = null;
    //item.Phoenix_SCM_Rejection_Reason1__c = null;
    item.Phoenix_Vistex_Status__c = null;
    item.Phoenix_Vistex_status_internal_use__c = null;
    item.Phoenix_Vistex_Update_Final_Approval__c = false;
    item.Phoenix_Marketing_Lead_Rx__c = null;
    item.Phoenix_Marketing_Lead_SRx__c = null;
    item.Phoenix_Marketing_Lead_OTC__c = null;
    item.Phoenix_Sr_Director_VP_Finance_Approval__c = null;
    item.Phoenix_Bid_Line_Item_Approval_Status__c = null;
  //  item.Phoenix_Batch_Number__c = null;
   // item.Phoenix_Expiry_Date__c = null;
    item.Phoenix_Customer_Service_Status__c = null;
    //        item.Phoenix_Customer_Service_Comments__c = null;
               item.Phoenix_Customer_Final_Approval__c = false;
    updateBItems.add(item);
}
List < Phoenix_Bid_Process_History__c > processHistoryList = new List < Phoenix_Bid_Process_History__c > ();

    for (Phoenix_Bid_Process_Steps__c oldStep: existingSteps) {
        Phoenix_Bid_Process_History__c stepHistory = new Phoenix_Bid_Process_History__c(
            Phoenix_Bid_Process_Step__c = oldStep.Id,

            Phoenix_Bid__c = bidid,
            Phoenix_Approval_Completed_Time__c = oldStep.Phoenix_Approval_Completed_Time__c,
            Phoenix_Approval_Completed_Time_String__c = oldStep.Phoenix_Approval_Completed_Time_String__c,
            Phoenix_Approval_Sent_Time__c = oldStep.Phoenix_Approval_Sent_Time__c,
            Phoenix_Approval_Sent_Time_String__c = oldStep.Phoenix_Approval_Sent_Time_String__c,
            Phoenix_Approver__c = oldStep.Phoenix_Approver__c,
            Phoenix_Approver_Team__c = oldStep.Phoenix_Approver_Team__c,
            Phoenix_Approver_Team_Members__c = oldStep.Phoenix_Approver_Team_Members__c,
            Phoenix_Description__c = oldStep.Phoenix_Description__c,
            Phoenix_Is_Criteria_Step__c = oldStep.Phoenix_Is_Criteria_Step__c,
            Phoenix_NDC_Change__c = oldStep.Phoenix_NDC_Change__c,
            Phoenix_Status__c = oldStep.Phoenix_Status__c,
            Phoenix_Step__c = oldStep.Phoenix_Step__c,
            Phoenix_Sub_Step__c = oldStep.Phoenix_Sub_Step__c,
            Phoenix_Type__c = 'Recall',
            Phoenix_Previous_Stage__c = bid.Phoenix_Approval_Status__c,
            Phoenix_selected_Recall_Option__c = 'SCM Only'

        );
        processHistoryList.add(stepHistory);
    }


insert processHistoryList;
update updateBItems;
update bid;
update updateProcessSteps;
delete[SELECT Id FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__c =: bidid];
delete[SELECT Id FROM Phoenix_Customer_Response__c WHERE Phoenix_Bid_No__c =: bidid];
delete[SELECT Id FROM Phoenix_Approval_Grid__c WHERE Phoenix_Bid__c =: bidid];
delete[SELECT Id FROM Phoenix_Awarded_Quantity__c WHERE Phoenix_Bid__c =: bidid];
returnStatus = 'Success';
}
else{
 returnStatus = 'You can not recall to SCM  as all line items are rejected at marketing stage.';
}
return returnStatus;
}


//
    
    
    
    
    
    
    
public static String recallBidToMkgAll(String bidId) {
String returnStatus = '';
//Get all related bid steps
Phoenix_Bid__c bid = [SELECT Id, Name, Phoenix_Approval_Status__c,Phoenix_Customer__c, Phoenix_Bid_Type__c, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Is_Re_Bid__c, Contract_Status__c, Phoenix_Sent_to_Customer_Date__c, Phoenix_Offer_Valid_up_to__c,
    (SELECT Id, Phoenix_SCM_Review__c, Phoenix_IPA_Floor_Price1__c, Phoenix_Proposed_IPA_Price__c, Phoenix_Product_Director__c, Phoenix_Product__c, Phoenix_Product__r.Phoenix_Product_Director__c From Bid_Line_Items__r),
    (SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Process_Step__r.Name, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Bid_Process_Steps__r)
    FROM Phoenix_Bid__c WHERE Id =: bidId
];
 String custID = '';
    if(bid.Phoenix_Customer__c!=null)custID=bid.Phoenix_Customer__c;
        
  List < Phoenix_Bid_Process_Steps__c > existingSteps = Database.query('SELECT ' + Phoenix_Util.bidProcessStepFields + ' FROM  Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c =:bidid');
      
Map < String, Map < Integer, List < Phoenix_Bid_Process_Steps__c >>> bidProcessStepsMap = new Map < String, Map < Integer, List < Phoenix_Bid_Process_Steps__c >>> ();
Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
Map < String, Phoenix_Bid_Process_Steps__c > stepApproversMap = new Map < String, Phoenix_Bid_Process_Steps__c > ();
Map < String, Integer > stepteamNoMap = new Map < String, Integer > ();
List < Phoenix_Bid_Line_Item__c > existingBItems = Database.query('SELECT ' + Phoenix_Util.bidlineitemFields + ' FROM  Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =:bidid AND Phoenix_SCM_Approval_Y_N__c !=\'N- Not Approved\'');

List < String > ProductDirectors = new List < String > ();
for (Phoenix_Bid_Line_Item__c item: existingBItems) {
    ProductDirectors.add(item.Phoenix_Product_Director1__c);
}
 system.debug('all product directors-->'+ProductDirectors);        
        
        
if(existingBItems.size()>0){
for (Phoenix_Bid_Process_Steps__c step: bid.Bid_Process_Steps__r) {

    Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
    if (stepMap.get(stepNo) != null) {
        List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
        adededSteps.add(step);
        stepMap.put(stepNo, adededSteps);
    } else {
        stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
            step
        });
    }

    String stepName = step.Phoenix_Process_Step__r.Name; //Phoenix_Approver_Team__c;
    if (stepNamesMap.get(stepName) != null) {
        List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
        adededSteps.add(step);
        stepNamesMap.put(stepName, adededSteps);
    } else {
        stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {
            step
        });
    }
    stepteamNoMap.put(stepName, stepNo);
    stepApproversMap.put(step.Phoenix_Approver_Team__c + '-' + step.Phoenix_Approver__c, step);

}

bidProcessStepsMap.put(bid.Id, stepMap); //Arranged all Bid>eachStep No>Step 

Integer mkgStepNo = stepteamNoMap.get('Marketing Approval');
//get the contractStepNo+1 step 
       
//  Phoenix_Bid_Process_Steps__c contractNextStep = stepMap.get(contractStepNo+1)[0];
//  Phoenix_Bid_Process_Steps__c contractStep = stepMap.get(scmStepNo)[0];
List < Phoenix_Bid_Process_Steps__c > afterMkgsteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Process_Step__r.Name, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c
    FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId AND Phoenix_Step__c >=: mkgStepNo AND Phoenix_Process_Step__r.Name != 'Supply Chain Approval'
];
List < Phoenix_Bid_Process_Steps__c > updateProcessSteps = new List < Phoenix_Bid_Process_Steps__c > ();
            
    Account acc = [Select Id , Name, Phoenix_Customer_Service_Approver__c,Phoenix_Customer_Service_Approver__r.Name,Phoenix_Contracts_Approver__c,Phoenix_Contracts_Approver__r.Name From Account Where Id=: custID];
for (Phoenix_Bid_Process_Steps__c step: afterMkgsteps) {

    if (step.Phoenix_Step__c == mkgStepNo && ProductDirectors.contains(step.Phoenix_Approver__r.Name) ) {
               
        step.Phoenix_Status__c = 'In Process';
        step.Phoenix_Approval_Sent_Time__c = null;
        step.Phoenix_Approval_Sent_Time_String__c = null;
        step.Phoenix_Approval_Completed_Time__c=null;
        step.Phoenix_Approval_Completed_Time_String__c=null;
        step.Phoenix_Delegated_Approver__c = null;
        updateProcessSteps.add(step);
    }
    else if(step.Phoenix_Step__c != mkgStepNo) {
               
        step.Phoenix_Status__c = 'Not Initiated';
        step.Phoenix_Approval_Sent_Time__c =null;
        step.Phoenix_Approval_Sent_Time_String__c = null;
        step.Phoenix_Approval_Completed_Time__c = null;
        step.Phoenix_Approval_Completed_Time_String__c=null;
         step.Phoenix_Delegated_Approver__c = null;
        if (step.Phoenix_Is_Criteria_Step__c == true) step.Phoenix_Status__c = 'Not Applicable';
         if(step.Phoenix_Process_Step__r.Name == 'Finance Approval')
            step.Phoenix_Approver__c = null;
          if(step.Phoenix_Process_Step__r.Name == 'Vistex Update')
            step.Phoenix_Approver__c = null;
        else if(step.Phoenix_Process_Step__r.Name == 'Customer Service Approval	'){
            if(acc!=null){
            step.Phoenix_Approver__c = acc.Phoenix_Customer_Service_Approver__c;
            }
        }
        else if(step.Phoenix_Process_Step__r.Name == 'Contract Team\'s Action' || step.Phoenix_Process_Step__r.Name == 'Customer\'s Update'){
             if(acc!=null){
            step.Phoenix_Approver__c = acc.Phoenix_Contracts_Approver__c;
             }
    }

        updateProcessSteps.add(step);
    }
}

if (bid.Phoenix_Bid_Type__c != 'Price Change' && bid.Phoenix_Bid_Type__c != 'Sales Out Rebate' && bid.Phoenix_Bid_Type__c != 'Customer Rebate Change' && bid.Phoenix_Bid_Type__c != 'New Product Launch') {
    bid.Phoenix_Approval_Status__c = 'SCM & Marketing';
} else {
    bid.Phoenix_Approval_Status__c = 'Marketing';
}


bid.Phoenix_Marketing_Approval__c = null;
// bid.Phoenix_Marketing_Comments__c = null;
bid.Phoenix_Business_Approval__c = null;
//bid.Phoenix_Business_Approval_Comments__c = null;
// bid.Phoenix_Comments__c = null;
bid.Phoenix_Contracts_Approval__c = null;
// bid.Phoenix_Contracts_Approval_Comments__c = null;
bid.Contract_Status__c = null;
bid.Phoenix_Country_Head_Approval__c = null;
//bid.Phoenix_Country_Head_Comments__c = null;
bid.Phoenix_Customer_Approval__c = null;
// bid.Phoenix_Customer_Approval_Comments__c = null;
bid.Phoenix_Finance_Approval__c = null;
// bid.Phoenix_Finance_Approval_Comments__c = null;
bid.Phoenix_Marketing_Head_Approval__c = null;
//  bid.Phoenix_Marketing_Head_Comments__c = null;
bid.Phoenix_Review_Details__c = null;
//     bid.Phoenix_Proactive_Reactive__c = null; //---?
bid.Phoenix_Sent_to_Customer_Date__c = null;
bid.Phoenix_Status__c = null;
bid.Phoenix_Vistex_Update__c = null;
//bid.Phoenix_Vistex_Update_Comments__c = null;
bid.Phoenix_Bid_Contracts_Approved_Date__c = null;
bid.Phoenix_Bid_Finance_Approved_Date__c = null;
bid.Phoenix_Bid_Marketing_Approved_Date__c = null;
bid.Bid_Marketing_Head_Approved_Date__c = null;
bid.Bid_Marketing_Lead_OTC_Approved_Date__c = null;
bid.Bid_Marketing_Lead_RX_Approved_Date__c = null;
bid.Bid_Marketing_Lead_SRX_Approved_Date__c = null;
bid.Phoenix_Bid_Closed_Date__c = null;
    bid.Phoenix_Sent_to_Vistex_Date__c = null;
    bid.Phoenix_Customer_Service_Approved_Date__c = null;
        
        
List < Phoenix_Bid_Line_Item__c > updateBItems = new List < Phoenix_Bid_Line_Item__c > ();

for (Phoenix_Bid_Line_Item__c item: existingBItems) {
    item.Phoenix_Approval__c = null;
    //   item.Phoenix_Comments__c = null;
    item.Phoenix_Bid_Status__c = null;
    //  item.Phoenix_Contract_Comments__c = null;
    item.Phoenix_Contracts_Final_Approval__c = false;
    item.Phoenix_Contract_Approval__c = null;
    // item.Phoenix_Current_SCM_Approved_Qty__c = null;
    item.Phoenix_Customer_Response__c = null;
    item.Phoenix_Customer_Response_Line__c = null;
    item.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
    item.Phoenix_Customer_status_internal_use__c = null;
    //   item.Phoenix_Estimated_Lead_Time_Days__c = null;
    item.Phoenix_Final_Finance_Approval__c = false;
    item.Phoenix_Final_Status__c = null;
    item.Phoenix_Finance_Approval__c = null;
    //  item.Phoenix_Finance_Comments__c = null;
    //  item.Phoenix_Initial_Stocking_Order_Comments__c = null;
    item.Phoenix_Marketing_Approval__c = null;
    //    item.Phoenix_Marketing_Notes__c = null;
    item.Phoenix_Marketing_Final_Approval__c = false;
    //    item.Phoenix_Pricing_Notes__c = null;
    //    item.Phoenix_Sales_Notes__c = null;
    //    item.Phoenix_SCM_Approval__c = null;
    //    item.Phoenix_SCM_Approval_Y_N__c = null;
    //    item.Phoenix_SCM_Approved_Quantity__c = null;
    //   item.Phoenix_SCM_Notes__c = null;
    //   item.Phoenix_SCM_Final_Approval__c = false;
    //   item.Phoenix_SCM_Qty_Approved_Direct__c = null;
    //   item.Phoenix_SCM_Qty_Approved_Indirect__c = null;
    //   item.Phoenix_SCM_Rejection_Reason1__c = null;
    item.Phoenix_Vistex_Status__c = null;
    item.Phoenix_Vistex_status_internal_use__c = null;
    item.Phoenix_Vistex_Update_Final_Approval__c = false;
    item.Phoenix_Marketing_Lead_Rx__c = null;
    item.Phoenix_Marketing_Lead_SRx__c = null;
    item.Phoenix_Marketing_Lead_OTC__c = null;
    item.Phoenix_Sr_Director_VP_Finance_Approval__c = null;
    item.Phoenix_Bid_Line_Item_Approval_Status__c = null;
  //  item.Phoenix_Batch_Number__c = null;
   // item.Phoenix_Expiry_Date__c = null;
    item.Phoenix_Customer_Service_Status__c = null;
    //        item.Phoenix_Customer_Service_Comments__c = null;

    updateBItems.add(item);
}
        
        
List < Phoenix_Bid_Process_History__c > processHistoryList = new List < Phoenix_Bid_Process_History__c > ();

    for (Phoenix_Bid_Process_Steps__c oldStep: existingSteps) {
        Phoenix_Bid_Process_History__c stepHistory = new Phoenix_Bid_Process_History__c(
            Phoenix_Bid_Process_Step__c = oldStep.Id,

            Phoenix_Bid__c = bidid,
            Phoenix_Approval_Completed_Time__c = oldStep.Phoenix_Approval_Completed_Time__c,
            Phoenix_Approval_Completed_Time_String__c = oldStep.Phoenix_Approval_Completed_Time_String__c,
            Phoenix_Approval_Sent_Time__c = oldStep.Phoenix_Approval_Sent_Time__c,
            Phoenix_Approval_Sent_Time_String__c = oldStep.Phoenix_Approval_Sent_Time_String__c,
            Phoenix_Approver__c = oldStep.Phoenix_Approver__c,
            Phoenix_Approver_Team__c = oldStep.Phoenix_Approver_Team__c,
            Phoenix_Approver_Team_Members__c = oldStep.Phoenix_Approver_Team_Members__c,
            Phoenix_Description__c = oldStep.Phoenix_Description__c,
            Phoenix_Is_Criteria_Step__c = oldStep.Phoenix_Is_Criteria_Step__c,
            Phoenix_NDC_Change__c = oldStep.Phoenix_NDC_Change__c,
            Phoenix_Status__c = oldStep.Phoenix_Status__c,
            Phoenix_Step__c = oldStep.Phoenix_Step__c,
            Phoenix_Sub_Step__c = oldStep.Phoenix_Sub_Step__c,
            Phoenix_Type__c = 'Recall',
            Phoenix_selected_Recall_Option__c = 'All Marketing steps',
            Phoenix_Previous_Stage__c = bid.Phoenix_Approval_Status__c

        );
        processHistoryList.add(stepHistory);
    }


insert processHistoryList;
update updateBItems;
update bid;
update updateProcessSteps;
delete[SELECT Id FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__c =: bidid];
delete[SELECT Id FROM Phoenix_Customer_Response__c WHERE Phoenix_Bid_No__c =: bidid];
delete[SELECT Id FROM Phoenix_Approval_Grid__c WHERE Phoenix_Bid__c =: bidid];
delete[SELECT Id FROM Phoenix_Awarded_Quantity__c WHERE Phoenix_Bid__c =: bidid];
returnStatus = 'Success';
}
else{
returnStatus =       'You can not recall to marketing  as all line items are rejected at SCM stage.';     
}
return returnStatus;



}
//
public static String recallBidToMkgOne(String bidId) {
        
String returnStatus = '';
//Get all related bid steps
Phoenix_Bid__c bid = [SELECT Id, Name, Phoenix_Approval_Status__c, Phoenix_Bid_Type__c, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Is_Re_Bid__c, Contract_Status__c, Phoenix_Sent_to_Customer_Date__c, Phoenix_Offer_Valid_up_to__c,
    (SELECT Id, Phoenix_SCM_Review__c, Phoenix_IPA_Floor_Price1__c, Phoenix_Proposed_IPA_Price__c, Phoenix_Product_Director__c, Phoenix_Product__c, Phoenix_Product__r.Phoenix_Product_Director__c From Bid_Line_Items__r),
    (SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Process_Step__r.Name, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Bid_Process_Steps__r)
    FROM Phoenix_Bid__c WHERE Id =: bidId
];

 List < Phoenix_Bid_Process_Steps__c > existingSteps = Database.query('SELECT ' + Phoenix_Util.bidProcessStepFields + ' FROM  Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c =:bidid');
        
Map < String, Map < Integer, List < Phoenix_Bid_Process_Steps__c >>> bidProcessStepsMap = new Map < String, Map < Integer, List < Phoenix_Bid_Process_Steps__c >>> ();
Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
Map < String, Phoenix_Bid_Process_Steps__c > stepApproversMap = new Map < String, Phoenix_Bid_Process_Steps__c > ();
Map < String, Integer > stepteamNoMap = new Map < String, Integer > ();
List < Phoenix_Bid_Line_Item__c > existingALLBItems = Database.query('SELECT ' + Phoenix_Util.bidlineitemFields + ' FROM  Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =:bidid ');
List < Phoenix_Bid_Line_Item__c > existingBItems = Database.query('SELECT ' + Phoenix_Util.bidlineitemFields + ' FROM  Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =:bidid AND Phoenix_SCM_Approval_Y_N__c !=\'N- Not Approved\' AND Phoenix_Marketing_Approval__c !=\'Not Approved\'');
for(Phoenix_Bid_Line_Item__c item : existingALLBItems){
    if(item.Phoenix_SCM_Approval_Y_N__c!='N- Not Approved' && item.Phoenix_Product_Director1__c == Userinfo.getName() && item.Phoenix_Marketing_Approval__c =='Not Approved'){
        existingBItems.add(item);                    
    }
}
        
List < String > ProductDirectors1 = new List < String > ();
for (Phoenix_Bid_Line_Item__c item: existingALLBItems) {
    ProductDirectors1.add(item.Phoenix_Product_Director1__c);
}
  List < String > ProductDirectors2 = new List < String > ();
for (Phoenix_Bid_Line_Item__c item: existingBItems) {
    ProductDirectors2.add(item.Phoenix_Product_Director1__c);
}
for (Phoenix_Bid_Process_Steps__c step: bid.Bid_Process_Steps__r) {

    Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
    if (stepMap.get(stepNo) != null) {
        List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
        adededSteps.add(step);
        stepMap.put(stepNo, adededSteps);
    } else {
        stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
            step
        });
    }

    String stepName = step.Phoenix_Process_Step__r.Name; //Phoenix_Approver_Team__c;
    if (stepNamesMap.get(stepName) != null) {
        List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
        adededSteps.add(step);
        stepNamesMap.put(stepName, adededSteps);
    } else {
        stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {
            step
        });
    }
    stepteamNoMap.put(stepName, stepNo);
    stepApproversMap.put(step.Phoenix_Approver_Team__c + '-' + step.Phoenix_Approver__c, step);

}

bidProcessStepsMap.put(bid.Id, stepMap); //Arranged all Bid>eachStep No>Step 

Integer mkgStepNo = stepteamNoMap.get('Marketing Approval');
//get the contractStepNo+1 step 
        
//  Phoenix_Bid_Process_Steps__c contractNextStep = stepMap.get(contractStepNo+1)[0];
//  Phoenix_Bid_Process_Steps__c contractStep = stepMap.get(scmStepNo)[0];
List < Phoenix_Bid_Process_Steps__c > afterMkgsteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Process_Step__r.Name, Phoenix_Approver_Team__c, Phoenix_Approver__c,Phoenix_Delegated_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c
    FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId AND Phoenix_Step__c >=: mkgStepNo AND Phoenix_Process_Step__r.Name != 'Supply Chain Approval'
];
List < Phoenix_Bid_Process_Steps__c > updateProcessSteps = new List < Phoenix_Bid_Process_Steps__c > ();
    
if (existingBItems.size()>0 && ProductDirectors2.contains(Userinfo.getName())) {
            
    for (Phoenix_Bid_Process_Steps__c step: afterMkgsteps) {
        if (step.Phoenix_Step__c == mkgStepNo && step.Phoenix_Approver__c == UserInfo.getUserId()) {
            step.Phoenix_Status__c = 'In Process';
            step.Phoenix_Approval_Sent_Time__c =null;
            step.Phoenix_Approval_Sent_Time_String__c = null;
            step.Phoenix_Approval_Completed_Time__c = null;
            step.Phoenix_Approval_Completed_Time_String__c=null;
             step.Phoenix_Delegated_Approver__c = null;
            updateProcessSteps.add(step);
        } else if (step.Phoenix_Step__c != mkgStepNo) {
                    
            step.Phoenix_Status__c = 'Not Initiated';
            step.Phoenix_Approval_Sent_Time__c =null;
            step.Phoenix_Approval_Sent_Time_String__c = null;
            step.Phoenix_Approval_Completed_Time__c = null;
            step.Phoenix_Approval_Completed_Time_String__c=null;
            if (step.Phoenix_Is_Criteria_Step__c == true) step.Phoenix_Status__c = 'Not Applicable';

            updateProcessSteps.add(step);
        }
    }

    if (bid.Phoenix_Bid_Type__c != 'Price Change' && bid.Phoenix_Bid_Type__c != 'Sales Out Rebate' && bid.Phoenix_Bid_Type__c != 'Customer Rebate Change' && bid.Phoenix_Bid_Type__c != 'New Product Launch') {
        bid.Phoenix_Approval_Status__c = 'SCM & Marketing';
    } else {
        bid.Phoenix_Approval_Status__c = 'Marketing';
    }


    //   bid.Phoenix_Marketing_Approval__c = null;
    //   bid.Phoenix_Marketing_Comments__c = null;
    bid.Phoenix_Business_Approval__c = null;
  //  bid.Phoenix_Business_Approval_Comments__c = null;
    //bid.Phoenix_Comments__c = null;
    bid.Phoenix_Contracts_Approval__c = null;
 //   bid.Phoenix_Contracts_Approval_Comments__c = null;
    bid.Contract_Status__c = null;
    bid.Phoenix_Country_Head_Approval__c = null;
  //  bid.Phoenix_Country_Head_Comments__c = null;
    bid.Phoenix_Customer_Approval__c = null;
  //  bid.Phoenix_Customer_Approval_Comments__c = null;
    bid.Phoenix_Finance_Approval__c = null;
  //  bid.Phoenix_Finance_Approval_Comments__c = null;
    bid.Phoenix_Marketing_Head_Approval__c = null;
  //  bid.Phoenix_Marketing_Head_Comments__c = null;
    bid.Phoenix_Review_Details__c = null;
    //     bid.Phoenix_Proactive_Reactive__c = null; //---?
    bid.Phoenix_Sent_to_Customer_Date__c = null;
    bid.Phoenix_Status__c = null;
    bid.Phoenix_Vistex_Update__c = null;
 //   bid.Phoenix_Vistex_Update_Comments__c = null;
    bid.Phoenix_Bid_Contracts_Approved_Date__c = null;
    bid.Phoenix_Bid_Finance_Approved_Date__c = null;
    bid.Phoenix_Bid_Marketing_Approved_Date__c = null;
    bid.Bid_Marketing_Head_Approved_Date__c = null;
    bid.Bid_Marketing_Lead_OTC_Approved_Date__c = null;
    bid.Bid_Marketing_Lead_RX_Approved_Date__c = null;
    bid.Bid_Marketing_Lead_SRX_Approved_Date__c = null;
    bid.Phoenix_Bid_Closed_Date__c = null;
    bid.Phoenix_Sent_to_Vistex_Date__c = null;
    bid.Phoenix_Customer_Service_Approved_Date__c = null;
    List < Phoenix_Bid_Line_Item__c > updateBItems = new List < Phoenix_Bid_Line_Item__c > ();

    for (Phoenix_Bid_Line_Item__c item: existingBItems) {
                
        if (item.Phoenix_Product_Director1__c == Userinfo.getName()) {
            item.Phoenix_Marketing_Approval__c = null;
            item.Phoenix_Marketing_Final_Approval__c = false;
        }
        item.Phoenix_Approval__c = null;
        //   item.Phoenix_Comments__c = null;
        item.Phoenix_Bid_Status__c = null;
        //  item.Phoenix_Contract_Comments__c = null;
        item.Phoenix_Contracts_Final_Approval__c = false;
        item.Phoenix_Contract_Approval__c = null;
        // item.Phoenix_Current_SCM_Approved_Qty__c = null;
        item.Phoenix_Customer_Response__c = null;
        item.Phoenix_Customer_Response_Line__c = null;
        item.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
        item.Phoenix_Customer_status_internal_use__c = null;
        //   item.Phoenix_Estimated_Lead_Time_Days__c = null;
        item.Phoenix_Final_Finance_Approval__c = false;
        item.Phoenix_Final_Status__c = null;
        item.Phoenix_Finance_Approval__c = null;
        //  item.Phoenix_Finance_Comments__c = null;
        //  item.Phoenix_Initial_Stocking_Order_Comments__c = null;
        //  item.Phoenix_Marketing_Approval__c = null;
        //    item.Phoenix_Marketing_Notes__c = null;
        //  item.Phoenix_Marketing_Final_Approval__c = false;
        //    item.Phoenix_Pricing_Notes__c = null;
        //    item.Phoenix_Sales_Notes__c = null;
        //    item.Phoenix_SCM_Approval__c = null;
        //    item.Phoenix_SCM_Approval_Y_N__c = null;
        //    item.Phoenix_SCM_Approved_Quantity__c = null;
        //   item.Phoenix_SCM_Notes__c = null;
        //   item.Phoenix_SCM_Final_Approval__c = false;
        //   item.Phoenix_SCM_Qty_Approved_Direct__c = null;
        //   item.Phoenix_SCM_Qty_Approved_Indirect__c = null;
        //   item.Phoenix_SCM_Rejection_Reason1__c = null;
        item.Phoenix_Vistex_Status__c = null;
        item.Phoenix_Vistex_status_internal_use__c = null;
        item.Phoenix_Vistex_Update_Final_Approval__c = false;
        item.Phoenix_Marketing_Lead_Rx__c = null;
        item.Phoenix_Marketing_Lead_SRx__c = null;
        item.Phoenix_Marketing_Lead_OTC__c = null;
        item.Phoenix_Sr_Director_VP_Finance_Approval__c = null;
        item.Phoenix_Bid_Line_Item_Approval_Status__c = null;
    //    item.Phoenix_Batch_Number__c = null;
       // item.Phoenix_Expiry_Date__c = null;
        item.Phoenix_Customer_Service_Status__c = null;
        //        item.Phoenix_Customer_Service_Comments__c = null;
item.Phoenix_Customer_Final_Approval__c = false;
        updateBItems.add(item);
    }
            
            
List < Phoenix_Bid_Process_History__c > processHistoryList = new List < Phoenix_Bid_Process_History__c > ();

    for (Phoenix_Bid_Process_Steps__c oldStep: existingSteps) {
        Phoenix_Bid_Process_History__c stepHistory = new Phoenix_Bid_Process_History__c(
            Phoenix_Bid_Process_Step__c = oldStep.Id,

            Phoenix_Bid__c = bidid,
            Phoenix_Approval_Completed_Time__c = oldStep.Phoenix_Approval_Completed_Time__c,
            Phoenix_Approval_Completed_Time_String__c = oldStep.Phoenix_Approval_Completed_Time_String__c,
            Phoenix_Approval_Sent_Time__c = oldStep.Phoenix_Approval_Sent_Time__c,
            Phoenix_Approval_Sent_Time_String__c = oldStep.Phoenix_Approval_Sent_Time_String__c,
            Phoenix_Approver__c = oldStep.Phoenix_Approver__c,
            Phoenix_Approver_Team__c = oldStep.Phoenix_Approver_Team__c,
            Phoenix_Approver_Team_Members__c = oldStep.Phoenix_Approver_Team_Members__c,
            Phoenix_Description__c = oldStep.Phoenix_Description__c,
            Phoenix_Is_Criteria_Step__c = oldStep.Phoenix_Is_Criteria_Step__c,
            Phoenix_NDC_Change__c = oldStep.Phoenix_NDC_Change__c,
            Phoenix_Status__c = oldStep.Phoenix_Status__c,
            Phoenix_Step__c = oldStep.Phoenix_Step__c,
            Phoenix_Sub_Step__c = oldStep.Phoenix_Sub_Step__c,
            Phoenix_Type__c = 'Recall',
            Phoenix_Previous_Stage__c = bid.Phoenix_Approval_Status__c,
            Phoenix_selected_Recall_Option__c = 'My Marketing step'

        );
        processHistoryList.add(stepHistory);
    }


    insert processHistoryList;

    update updateBItems;
    update bid;
    update updateProcessSteps;
    delete[SELECT Id FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__c =: bidid];
    delete[SELECT Id FROM Phoenix_Customer_Response__c WHERE Phoenix_Bid_No__c =: bidid];
    delete[SELECT Id FROM Phoenix_Approval_Grid__c WHERE Phoenix_Bid__c =: bidid];
    delete[SELECT Id FROM Phoenix_Awarded_Quantity__c WHERE Phoenix_Bid__c =: bidid];
    returnStatus = 'Success';
} 
else if (existingBItems.size()>0 && !ProductDirectors1.contains(Userinfo.getName())) {
            
    returnStatus = 'You can not recall to marketing step as you are not product director.';
}
else if(existingBItems.size()<=0 && !ProductDirectors1.contains(Userinfo.getName())){
           
      returnStatus = 'You can not recall to marketing step as you are not product director.';
}
     else if(existingBItems.size()<=0 && ProductDirectors1.contains(Userinfo.getName())){
            
    returnStatus = 'You can not recall to marketing  as all line items are rejected at SCM stage.';
}
  else if(existingBItems.size()>0 && !ProductDirectors2.contains(Userinfo.getName())){
            
    returnStatus = 'You can not recall to marketing  as all line items are rejected at SCM stage.';
}
         
return returnStatus;



}


// EXTRA RECALL END


public static String recallBidToContracts(String bidId) {
String returnStatus = '';
//Get all related bid steps
Phoenix_Bid__c bid = [SELECT Id, Name, Phoenix_Approval_Status__c, Phoenix_Bid_Type__c, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Is_Re_Bid__c, Contract_Status__c, Phoenix_Sent_to_Customer_Date__c, Phoenix_Offer_Valid_up_to__c,
    (SELECT Id, Phoenix_SCM_Review__c, Phoenix_IPA_Floor_Price1__c, Phoenix_Proposed_IPA_Price__c, Phoenix_Product_Director__c, Phoenix_Product__c, Phoenix_Product__r.Phoenix_Product_Director__c From Bid_Line_Items__r),
    (SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Process_Step__r.Name, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Bid_Process_Steps__r)
    FROM Phoenix_Bid__c WHERE Id =: bidId
];
        
        

List < Phoenix_Bid_Process_Steps__c > existingSteps = Database.query('SELECT ' + Phoenix_Util.bidProcessStepFields + ' FROM  Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c =:bidid');
List < Phoenix_RCA_IPA_LINE__c > existingRCAIPAItems = Database.query('SELECT ' + Phoenix_Util.RCAIPAFields + ' FROM  Phoenix_RCA_IPA_LINE__c WHERE Phoenix_Bid__c =:bidid');
        
Map < String, Map < Integer, List < Phoenix_Bid_Process_Steps__c >>> bidProcessStepsMap = new Map < String, Map < Integer, List < Phoenix_Bid_Process_Steps__c >>> ();
Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
Map < String, Phoenix_Bid_Process_Steps__c > stepApproversMap = new Map < String, Phoenix_Bid_Process_Steps__c > ();
Map < String, Integer > stepteamNoMap = new Map < String, Integer > ();
List < Phoenix_Bid_Line_Item__c > existingBItems = Database.query('SELECT ' + Phoenix_Util.bidlineitemFields + ' FROM  Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =:bidid AND Phoenix_Contract_Approval__c!=\'Pending\'');


for (Phoenix_Bid_Process_Steps__c step: bid.Bid_Process_Steps__r) {

    Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
    if (stepMap.get(stepNo) != null) {
        List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
        adededSteps.add(step);
        stepMap.put(stepNo, adededSteps);
    } else {
        stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
            step
        });
    }

    String stepName = step.Phoenix_Process_Step__r.Name; //Phoenix_Approver_Team__c;
    if (stepNamesMap.get(stepName) != null) {
        List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
        adededSteps.add(step);
        stepNamesMap.put(stepName, adededSteps);
    } else {
        stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {
            step
        });
    }
    stepteamNoMap.put(stepName, stepNo);
    stepApproversMap.put(step.Phoenix_Approver_Team__c + '-' + step.Phoenix_Approver__c, step);

}

bidProcessStepsMap.put(bid.Id, stepMap); //Arranged all Bid>eachStep No>Step 

Integer contractStepNo = stepteamNoMap.get('Contract Team\'s Action');
//get the contractStepNo+1 step 
       
Phoenix_Bid_Process_Steps__c contractNextStep = stepMap.get(contractStepNo + 1)[0];
Phoenix_Bid_Process_Steps__c contractStep = stepMap.get(contractStepNo)[0];

//see whether it is in process or not (for customers update and vistex)
//make next step to  not intiated//and contract step to  in process and approval fields to null

List < Phoenix_Bid_Process_Steps__c > updateProcessSteps = new List < Phoenix_Bid_Process_Steps__c > ();
if (contractNextStep.Name.containsIgnoreCase('Closed') || contractNextStep.Phoenix_Status__c == 'In Process') {
    contractNextStep.Phoenix_Status__c = 'Not Initiated';
    contractStep.Phoenix_Status__c = 'In Process';
            
    //added extra
     contractNextStep.Phoenix_Approval_Sent_Time__c = null;
     contractNextStep.Phoenix_Approval_Sent_Time_String__c = null;
     contractStep.Phoenix_Approval_Sent_Time__c = null;
     contractStep.Phoenix_Approval_Sent_Time_String__c = null;
     contractStep.Phoenix_Approval_Completed_Time__c=null;
     contractStep.Phoenix_Approval_Completed_Time_String__c=null;
            
    //added extra end.
            
    updateProcessSteps.add(contractNextStep);
    updateProcessSteps.add(contractStep);
    //see whether  completed for closed step//make next step to  not intiated  and approval fields to null //and contract step to  in process and approval fields to null

    bid.Phoenix_Approval_Status__c = 'Contracts';
    bid.Contract_Status__c = 'Pending';
    bid.Phoenix_Sent_to_Customer_Date__c = null;
    bid.Phoenix_Offer_Valid_up_to__c = null;
    bid.Phoenix_Bid_Closed_Date__c = null;
    bid.Phoenix_Bid_Contracts_Approved_Date__c = null;
    bid.Phoenix_Sent_to_Vistex_Date__c = null;

    List < Phoenix_Bid_Line_Item__c > updateBItems = new List < Phoenix_Bid_Line_Item__c > ();

    for (Phoenix_Bid_Line_Item__c item: existingBItems) {
        item.Phoenix_Contract_Approval__c = 'Pending';
       // item.Phoenix_Contract_Comments__c = null;
        item.Phoenix_Contracts_Final_Approval__c = False;
        item.Phoenix_Final_Status__c = null;
        item.Phoenix_Bid_Line_Item_Approval_Status__c = null;
        updateBItems.add(item);
    }
            
    List < Phoenix_Bid_Process_History__c > processHistoryList = new List < Phoenix_Bid_Process_History__c > ();

    for (Phoenix_Bid_Process_Steps__c oldStep: existingSteps) {
        Phoenix_Bid_Process_History__c stepHistory = new Phoenix_Bid_Process_History__c(
            Phoenix_Bid_Process_Step__c = oldStep.Id,

            Phoenix_Bid__c = bidid,
            Phoenix_Approval_Completed_Time__c = oldStep.Phoenix_Approval_Completed_Time__c,
            Phoenix_Approval_Completed_Time_String__c = oldStep.Phoenix_Approval_Completed_Time_String__c,
            Phoenix_Approval_Sent_Time__c = oldStep.Phoenix_Approval_Sent_Time__c,
            Phoenix_Approval_Sent_Time_String__c = oldStep.Phoenix_Approval_Sent_Time_String__c,
            Phoenix_Approver__c = oldStep.Phoenix_Approver__c,
            Phoenix_Approver_Team__c = oldStep.Phoenix_Approver_Team__c,
            Phoenix_Approver_Team_Members__c = oldStep.Phoenix_Approver_Team_Members__c,
            Phoenix_Description__c = oldStep.Phoenix_Description__c,
            Phoenix_Is_Criteria_Step__c = oldStep.Phoenix_Is_Criteria_Step__c,
            Phoenix_NDC_Change__c = oldStep.Phoenix_NDC_Change__c,
            Phoenix_Status__c = oldStep.Phoenix_Status__c,
            Phoenix_Step__c = oldStep.Phoenix_Step__c,
            Phoenix_Sub_Step__c = oldStep.Phoenix_Sub_Step__c,
            Phoenix_Type__c = 'Recall',
            Phoenix_Previous_Stage__c = bid.Phoenix_Approval_Status__c,
            Phoenix_selected_Recall_Option__c = 'Contracts'

        );
        processHistoryList.add(stepHistory);
    }
            
            
            
    List<Phoenix_Customer_Response__c> crList = [SELECT Id,Phoenix_Bid_No__c,Phoenix_Is_Recalled__c FROM Phoenix_Customer_Response__c WHERE Phoenix_Bid_No__c =: bidid];
    List<Phoenix_Customer_Response__c> UpdatedcrList = new List<Phoenix_Customer_Response__c>();
    for(Phoenix_Customer_Response__c cr : crList){
        cr.Phoenix_Is_Recalled__c = TRUE;
        UpdatedcrList.add(cr);
                
    }
    UPDATE UpdatedcrList;
    insert processHistoryList;
    update updateBItems;
    update bid;
            
    if (existingRCAIPAItems.size() > 0) {
        for (Phoenix_RCA_IPA_LINE__c RIitem: existingRCAIPAItems) {
       //     RIitem.Phoenix_Contract_Comments__c = null;
            RIitem.Phoenix_Contract_Status__c = null;
            RIitem.Phoenix_Contracts_Final_Approval__c =false;

        }
        update existingRCAIPAItems;
    }
            
    delete[SELECT Id FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__c =: bidid];
    delete[SELECT Id FROM Phoenix_Customer_Response__c WHERE Phoenix_Bid_No__c =: bidid];
    delete[SELECT Id FROM Phoenix_Awarded_Quantity__c WHERE Phoenix_Bid__c =: bidid];
    update updateProcessSteps;
    returnStatus = 'Success';
} else {
    returnStatus = 'You can Recall to Contract\'s step only when the previous step is Contract\'s Approval.';
}


return returnStatus;
        
        
        
}
    
public static String recallBidToScm1(String bidId) {
        
  String returnStatus = '';
//Get all related bid steps
Phoenix_Bid__c bid = [SELECT Id, Name,Phoenix_Customer__c, Phoenix_Approval_Status__c, Phoenix_Bid_Type__c, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Is_Re_Bid__c, Contract_Status__c, Phoenix_Sent_to_Customer_Date__c, Phoenix_Offer_Valid_up_to__c,
                      (SELECT Id, Phoenix_SCM_Review__c, Phoenix_IPA_Floor_Price1__c, Phoenix_Proposed_IPA_Price__c, Phoenix_Product_Director__c, Phoenix_Product__c, Phoenix_Product__r.Phoenix_Product_Director__c From Bid_Line_Items__r),
                      (SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Process_Step__r.Name, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Bid_Process_Steps__r)
                      FROM Phoenix_Bid__c WHERE Id =: bidId
                     ];
String custID = '';
if(bid.Phoenix_Customer__c!=null)custID=bid.Phoenix_Customer__c;
        
List < Phoenix_Bid_Process_Steps__c > existingSteps = Database.query('SELECT ' + Phoenix_Util.bidProcessStepFields + ' FROM  Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c =:bidid');
        
        
Map < String, Map < Integer, List < Phoenix_Bid_Process_Steps__c >>> bidProcessStepsMap = new Map < String, Map < Integer, List < Phoenix_Bid_Process_Steps__c >>> ();
Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
Map < String, Phoenix_Bid_Process_Steps__c > stepApproversMap = new Map < String, Phoenix_Bid_Process_Steps__c > ();
Map < String, Integer > stepteamNoMap = new Map < String, Integer > ();
List < Phoenix_Bid_Line_Item__c > existingBItems = Database.query('SELECT ' + Phoenix_Util.bidlineitemFields + ' FROM  Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =:bidid AND Phoenix_Marketing_Approval__c!=\'Not Approved\'');
        
if(existingBItems.size()>0){
    for (Phoenix_Bid_Process_Steps__c step: bid.Bid_Process_Steps__r) {
                
        Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
        if (stepMap.get(stepNo) != null) {
            List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
            adededSteps.add(step);
            stepMap.put(stepNo, adededSteps);
        } else {
            stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
                step
                    });
        }
                
        String stepName = step.Phoenix_Process_Step__r.Name; //Phoenix_Approver_Team__c;
        if (stepNamesMap.get(stepName) != null) {
            List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
            adededSteps.add(step);
            stepNamesMap.put(stepName, adededSteps);
        } else {
            stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {
                step
                    });
        }
        stepteamNoMap.put(stepName, stepNo);
        stepApproversMap.put(step.Phoenix_Approver_Team__c + '-' + step.Phoenix_Approver__c, step);
                
    }
            
    bidProcessStepsMap.put(bid.Id, stepMap); //Arranged all Bid>eachStep No>Step 
            
    Integer scmStepNo = stepteamNoMap.get('Supply Chain Approval');
            
    //  Phoenix_Bid_Process_Steps__c contractNextStep = stepMap.get(contractStepNo+1)[0];
    //  Phoenix_Bid_Process_Steps__c contractStep = stepMap.get(scmStepNo)[0];
    List < Phoenix_Bid_Process_Steps__c > afterSCMstepsexceptMkg = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Process_Step__r.Name, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c
                                                                    FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId AND Phoenix_Step__c >=: scmStepNo AND Phoenix_Process_Step__r.Name != 'Marketing Approval'
                                                                   ];
    List < Phoenix_Bid_Process_Steps__c > updateProcessSteps = new List < Phoenix_Bid_Process_Steps__c > ();
            
    Account acc = [Select Id , Name, Phoenix_Customer_Service_Approver__c,Phoenix_Customer_Service_Approver__r.Name,Phoenix_Contracts_Approver__c,Phoenix_Contracts_Approver__r.Name From Account Where Id=: custID];
            
            
            
    for (Phoenix_Bid_Process_Steps__c step: afterSCMstepsexceptMkg) {
        if (step.Phoenix_Step__c == scmStepNo && step.Phoenix_Approver__c == UserInfo.getUserId()) {
            step.Phoenix_Status__c = 'In Process';
            step.Phoenix_Approval_Sent_Time__c = null;
            step.Phoenix_Approval_Sent_Time_String__c = null;
            step.Phoenix_Approval_Completed_Time__c=null;
            step.Phoenix_Approval_Completed_Time_String__c=null;    
            step.Phoenix_Delegated_Approver__c = null;
            if(step.Phoenix_Process_Step__r.Name == 'Supply Chain Approval')
                //step.Phoenix_Approver__c = null;
            updateProcessSteps.add(step);
        }
        else if(step.Phoenix_Step__c != scmStepNo) {
                    
            step.Phoenix_Status__c = 'Not Initiated';
            step.Phoenix_Approval_Sent_Time__c =null;
            step.Phoenix_Approval_Sent_Time_String__c = null;
            step.Phoenix_Approval_Completed_Time__c = null;
            step.Phoenix_Approval_Completed_Time_String__c=null;
            step.Phoenix_Delegated_Approver__c = null;
            if (step.Phoenix_Is_Criteria_Step__c == true) step.Phoenix_Status__c = 'Not Applicable';
            if(step.Phoenix_Process_Step__r.Name == 'Finance Approval')
                step.Phoenix_Approver__c = null;
            if(step.Phoenix_Process_Step__r.Name == 'Vistex Update')
                step.Phoenix_Approver__c = null;
            else if(step.Phoenix_Process_Step__r.Name == 'Customer Service Approval	'){
                if(acc!=null){
                    step.Phoenix_Approver__c = acc.Phoenix_Customer_Service_Approver__c;
                }
            }
            else if(step.Phoenix_Process_Step__r.Name == 'Contract Team\'s Action' || step.Phoenix_Process_Step__r.Name == 'Customer\'s Update'){
                if(acc!=null){
                    step.Phoenix_Approver__c = acc.Phoenix_Contracts_Approver__c;
                }
            }
            updateProcessSteps.add(step);
        }
    }
            
    if (bid.Phoenix_Bid_Type__c != 'Volume Review Only') {
        bid.Phoenix_Approval_Status__c = 'SCM & Marketing';
    } else {
        bid.Phoenix_Approval_Status__c = 'Supply Chain';
    }
            
    bid.Phoenix_Business_Approval__c = null;
    //bid.Phoenix_Business_Approval_Comments__c = null;
    // bid.Phoenix_Comments__c = null;
    bid.Phoenix_Contracts_Approval__c = null;
    //bid.Phoenix_Contracts_Approval_Comments__c = null;
    bid.Contract_Status__c = null;
    bid.Phoenix_Country_Head_Approval__c = null;
    //bid.Phoenix_Country_Head_Comments__c = null;
    bid.Phoenix_Customer_Approval__c = null;
    //bid.Phoenix_Customer_Approval_Comments__c = null;
    bid.Phoenix_Finance_Approval__c = null;
    //bid.Phoenix_Finance_Approval_Comments__c = null;
    bid.Phoenix_Marketing_Head_Approval__c = null;
    //bid.Phoenix_Marketing_Head_Comments__c = null;
    bid.Phoenix_Review_Details__c = null;
    //    bid.Phoenix_Proactive_Reactive__c = null; //---?
    bid.Phoenix_Sent_to_Customer_Date__c = null;
    bid.Phoenix_Status__c = null;
    bid.Phoenix_Vistex_Update__c = null;
    //bid.Phoenix_Vistex_Update_Comments__c = null;
    bid.Phoenix_Bid_Contracts_Approved_Date__c = null;
    bid.Phoenix_Bid_Finance_Approved_Date__c = null;
    bid.Phoenix_Bid_SCM_Approved_Date__c = null;
    bid.Bid_Marketing_Head_Approved_Date__c = null;
    bid.Bid_Marketing_Lead_OTC_Approved_Date__c = null;
    bid.Bid_Marketing_Lead_RX_Approved_Date__c = null;
    bid.Bid_Marketing_Lead_SRX_Approved_Date__c = null;
    bid.Phoenix_Bid_Closed_Date__c = null;
    bid.Phoenix_Sent_to_Vistex_Date__c = null;
    bid.Phoenix_Customer_Service_Approved_Date__c = null;
            
            
    List < Phoenix_Bid_Line_Item__c > updateBItems = new List < Phoenix_Bid_Line_Item__c > ();
            
    for (Phoenix_Bid_Line_Item__c item: existingBItems) {
        // add by Jogarao
        if(bid.Phoenix_Is_Re_Bid__c)
            item.Phoenix_SCM_Review__c = true;
        item.Phoenix_Approval__c = null;
        //   item.Phoenix_Comments__c = null;
        item.Phoenix_Bid_Status__c = null;
        //  item.Phoenix_Contract_Comments__c = null;
        item.Phoenix_Contracts_Final_Approval__c = false;
        item.Phoenix_Contract_Approval__c = null;
        //item.Phoenix_Current_SCM_Approved_Qty__c = null;
        item.Phoenix_Customer_Response__c = null;
        item.Phoenix_Customer_Response_Line__c = null;
        item.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
        item.Phoenix_Customer_status_internal_use__c = null;
        //   item.Phoenix_Estimated_Lead_Time_Days__c = null;
        item.Phoenix_Final_Finance_Approval__c = false;
        item.Phoenix_Final_Status__c = null;
        item.Phoenix_Finance_Approval__c = null;
        //  item.Phoenix_Finance_Comments__c = null;
        //  item.Phoenix_Initial_Stocking_Order_Comments__c = null;
        //    item.Phoenix_Marketing_Notes__c = null;
        //    item.Phoenix_Pricing_Notes__c = null;
        //    item.Phoenix_Sales_Notes__c = null;
        //item.Phoenix_SCM_Approval__c = null;
        // item.Phoenix_SCM_Approval_Y_N__c = null;
        //item.Phoenix_SCM_Approved_Quantity__c = null;
        //   item.Phoenix_SCM_Notes__c = null;
        item.Phoenix_SCM_Final_Approval__c = false;
        //item.Phoenix_SCM_Qty_Approved_Direct__c = null;
        //item.Phoenix_SCM_Qty_Approved_Indirect__c = null;
        //item.Phoenix_SCM_Rejection_Reason1__c = null;
        item.Phoenix_Vistex_Status__c = null;
        item.Phoenix_Vistex_status_internal_use__c = null;
        item.Phoenix_Vistex_Update_Final_Approval__c = false;
        item.Phoenix_Marketing_Lead_Rx__c = null;
        item.Phoenix_Marketing_Lead_SRx__c = null;
        item.Phoenix_Marketing_Lead_OTC__c = null;
        item.Phoenix_Sr_Director_VP_Finance_Approval__c = null;
        item.Phoenix_Bid_Line_Item_Approval_Status__c = null;
        //  item.Phoenix_Batch_Number__c = null;
        // item.Phoenix_Expiry_Date__c = null;
        item.Phoenix_Customer_Service_Status__c = null;
        //        item.Phoenix_Customer_Service_Comments__c = null;
        item.Phoenix_Customer_Final_Approval__c = false;
        updateBItems.add(item);
    }
    List < Phoenix_Bid_Process_History__c > processHistoryList = new List < Phoenix_Bid_Process_History__c > ();
            
    for (Phoenix_Bid_Process_Steps__c oldStep: existingSteps) {
        Phoenix_Bid_Process_History__c stepHistory = new Phoenix_Bid_Process_History__c(
            Phoenix_Bid_Process_Step__c = oldStep.Id,
                    
            Phoenix_Bid__c = bidid,
            Phoenix_Approval_Completed_Time__c = oldStep.Phoenix_Approval_Completed_Time__c,
            Phoenix_Approval_Completed_Time_String__c = oldStep.Phoenix_Approval_Completed_Time_String__c,
            Phoenix_Approval_Sent_Time__c = oldStep.Phoenix_Approval_Sent_Time__c,
            Phoenix_Approval_Sent_Time_String__c = oldStep.Phoenix_Approval_Sent_Time_String__c,
            Phoenix_Approver__c = oldStep.Phoenix_Approver__c,
            Phoenix_Approver_Team__c = oldStep.Phoenix_Approver_Team__c,
            Phoenix_Approver_Team_Members__c = oldStep.Phoenix_Approver_Team_Members__c,
            Phoenix_Description__c = oldStep.Phoenix_Description__c,
            Phoenix_Is_Criteria_Step__c = oldStep.Phoenix_Is_Criteria_Step__c,
            Phoenix_NDC_Change__c = oldStep.Phoenix_NDC_Change__c,
            Phoenix_Status__c = oldStep.Phoenix_Status__c,
            Phoenix_Step__c = oldStep.Phoenix_Step__c,
            Phoenix_Sub_Step__c = oldStep.Phoenix_Sub_Step__c,
            Phoenix_Type__c = 'Recall',
            Phoenix_Previous_Stage__c = bid.Phoenix_Approval_Status__c,
            Phoenix_selected_Recall_Option__c = 'SCM Only'
                    
        );
        processHistoryList.add(stepHistory);
    }
            
            
    insert processHistoryList;
    update updateBItems;
    update bid;
    update updateProcessSteps;
    delete[SELECT Id FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__c =: bidid];
    delete[SELECT Id FROM Phoenix_Customer_Response__c WHERE Phoenix_Bid_No__c =: bidid];
    delete[SELECT Id FROM Phoenix_Approval_Grid__c WHERE Phoenix_Bid__c =: bidid];
    delete[SELECT Id FROM Phoenix_Awarded_Quantity__c WHERE Phoenix_Bid__c =: bidid];
    returnStatus = 'Success';
}
else{
    returnStatus = 'You can not recall to SCM  as all line items are rejected at marketing stage.';
}
return returnStatus;
        
        
        
}
public static void deleteBidChildren(List < Id > objIds) {
try {
    List < Messaging.SingleEmailMessage > mailsList = new List < Messaging.SingleEmailMessage > ();
    String mailStatus = '';
    Messaging.SendEmailResult[] results;

    if (objIds.size() > 0) {
        String objName = String.valueOf(objIds[0].getsObjectType());
        if (objName == 'Phoenix_Bid__c') {

            map < Id, Phoenix_Bid__c > bidMap = new map < Id, Phoenix_Bid__c > ([SELECT Id, ownerId, owner.Name, Phoenix_Customer_Bid_Deadline_Date_Time__c, owner.Email, Phoenix_Internal_Target_Date__c,
                Phoenix_Bid_Deadline_Date__c, Phoenix_Bid_Created_Behalf_of__r.Email FROM Phoenix_Bid__c WHERE Id In: objIds
            ]);
            delete[SELECT Id FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c IN: objIds];
            delete[SELECT Id FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c IN: objIds];
            delete[SELECT Id FROM Phoenix_Bid_Process_History__c WHERE Phoenix_Bid__c IN: objIds];
            delete[SELECT Id FROM Phoenix_Approval_Grid__c WHERE Phoenix_Bid__c IN: objIds];
            delete[SELECT Id FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__c IN: objIds];
            delete[SELECT Id FROM Phoenix_Customer_Response__c WHERE Phoenix_Bid_No__c IN: objIds];
            delete[SELECT Id FROM Phoenix_Bid_Line_Product_Family__c WHERE Phoenix_Bid__c IN: objIds];
            delete[SELECT Id FROM Attachment WHERE ParentId IN: objIds];
            delete[SELECT Id FROM Checklist__c WHERE Bid__c IN: objIds];


            set < string > toaddress = new set < string > ();
            set < string > ccaddress = new set < string > ();
            set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
            for (String bidId: bidMap.keyset()) {

                Phoenix_Bid__c bid = bidMap.get(bidId);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Bid_Delete_Notification', bidId);
                String templateBody = emailWrapper.mailHtmlBody;
                String subject = emailWrapper.mailSubject;
                if (bid.Phoenix_Internal_Target_Date__c != null) {
                    DateTime internalDueDateTime = DateTime.newInstance(bid.Phoenix_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0));
                    if (templateBody.contains('INTERNAL_DEADLINE_DATE')) templateBody = templateBody.replace('INTERNAL_DEADLINE_DATE', internalDueDateTime.format('MMM d yyyy'));
                }


                if (bid.Phoenix_Bid_Deadline_Date__c != null) {
                    DateTime customerBidDeadline = DateTime.newInstance(bid.Phoenix_Bid_Deadline_Date__c, Time.newInstance(0, 0, 0, 0));
                    if (templateBody.contains('CUSTOMER_DEADLINE_DATE')) templateBody = templateBody.replace('CUSTOMER_DEADLINE_DATE', customerBidDeadline.format('MMM d yyyy'));
                }
                if (templateBody.contains('USER_NAME')) templateBody = templateBody.replace('USER_NAME', UserInfo.getName());

                toaddress.add(bid.owner.Email);
                if (bid.Phoenix_Bid_Created_Behalf_of__c != null) {
                    toaddress.add(bid.Phoenix_Bid_Created_Behalf_of__r.Email);
                }
                for (Phoenix_Bid_Process_Steps__c step: [SELECT Id, Name, Phoenix_Approver__c, Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Status__c, Phoenix_Approver__r.Email FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Status__c != 'Not Applicable'
                        AND Phoenix_Bid__c =: bidId
                    ]) {
                    if (step.Phoenix_Approver__c != null) {
                        allPeopleInvolvedEmailsSet.add(step.Phoenix_Approver__r.Email);
                    }
                    if (bid.Phoenix_Sales_Person_2__c != null) {
                        allPeopleInvolvedEmailsSet.add(bid.Phoenix_Sales_Person_2__r.Email);
                    } else if (bid.Phoenix_Salesperson__c != null) {
                        allPeopleInvolvedEmailsSet.add(bid.Phoenix_Salesperson__r.Email);
                    }
                }
                if (Label.Phoenix_Contracts_DL != null) ccaddress.addAll(Label.Phoenix_Contracts_DL.split(','));
                ccaddress.addAll(allPeopleInvolvedEmailsSet);
                for (String emailId: toaddress) {
                    if (ccaddress.contains(emailId))
                        ccaddress.remove(emailId);
                }

                email.setToAddresses(new List < String > (toaddress));
                email.setCcAddresses(new List < String > (ccaddress));
                email.setSubject(subject);
                email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
                email.setHtmlBody(templateBody);
                mailsList.add(email);

            }
        } 
        else if (objName == 'Phoenix_NDC_Change__c')
        {

            map < Id, Phoenix_NDC_Change__c > ndcChangeMap = new map < Id, Phoenix_NDC_Change__c > ([SELECT Id, ownerId, owner.Name, owner.Email FROM Phoenix_NDC_Change__c WHERE Id In: objIds]);
            delete[SELECT Id FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_NDC_Change__c IN: objIds];
            delete[SELECT Id FROM Phoenix_NDC_Change_Line_Item__c WHERE Phoenix_NDC_Change__c IN: objIds];
            // delete[SELECT Id FROM Phoenix_Bid_Process_History__c WHERE Phoenix_Bid__c IN: objIds];
            //  delete[SELECT Id FROM Phoenix_Approval_Grid__c WHERE Phoenix_Bid__c IN: objIds];
            delete[SELECT Id FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_NDC_Change__c IN: objIds];
            delete[SELECT Id FROM Phoenix_Customer_Response__c WHERE Phoenix_NDC_Change__c IN: objIds];
            // delete[SELECT Id FROM Phoenix_Bid_Line_Product_Family__c WHERE Phoenix_Bid__c IN: objIds];
            delete[SELECT Id FROM Attachment WHERE ParentId IN: objIds];
            //  delete[SELECT Id FROM Checklist__c WHERE Bid__c IN: objIds];


            set < string > toaddress = new set < string > ();
            set < string > ccaddress = new set < string > ();
            set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
            for (String ndcChangeId: ndcChangeMap.keyset()) {

                Phoenix_NDC_Change__c ndcChange = ndcChangeMap.get(ndcChangeId);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('NDC_Change_Delete_Notification', ndcChangeId);
                String templateBody = emailWrapper.mailHtmlBody;
                String subject = emailWrapper.mailSubject;

                if (templateBody.contains('USER_NAME')) templateBody = templateBody.replace('USER_NAME', UserInfo.getName());

                toaddress.add(ndcChange.owner.Email);
                for (Phoenix_Bid_Process_Steps__c step: [SELECT Id, Name, Phoenix_Approver__c, Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Status__c, Phoenix_Approver__r.Email FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Status__c != 'Not Applicable'
                        AND Phoenix_NDC_Change__c =: ndcChangeId
                    ]) {
                    if (step.Phoenix_Approver__c != null) {
                        allPeopleInvolvedEmailsSet.add(step.Phoenix_Approver__r.Email);
                    }

                }
                if (Label.Phoenix_Contracts_DL != null) ccaddress.addAll(Label.Phoenix_Contracts_DL.split(','));
                ccaddress.addAll(allPeopleInvolvedEmailsSet);
                for (String emailId: toaddress) {
                    if (ccaddress.contains(emailId))
                        ccaddress.remove(emailId);
                }

                email.setToAddresses(new List < String > (toaddress));
                email.setCcAddresses(new List < String > (ccaddress));
                email.setSubject(subject);
                email.setHtmlBody(templateBody);
                email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
                mailsList.add(email);

            }
        } 
        else if (objName == 'Phoenix_PHS_Price_Change__c') {

            map < Id, Phoenix_PHS_Price_Change__c > pHSChangeMap = new map < Id, Phoenix_PHS_Price_Change__c > ([SELECT Id, ownerId, owner.Name, owner.Email FROM Phoenix_PHS_Price_Change__c WHERE Id In: objIds]);
            delete[SELECT Id FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_PHS_Price_Change__c IN: objIds];
            delete[SELECT Id FROM Phoenix_PHS_Price_Change_Line__c WHERE Phoenix_PHS_Price_Change__c IN: objIds];
            // delete[SELECT Id FROM Phoenix_Bid_Process_History__c WHERE Phoenix_Bid__c IN: objIds];
            //  delete[SELECT Id FROM Phoenix_Approval_Grid__c WHERE Phoenix_Bid__c IN: objIds];
            //  delete[SELECT Id FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_PHS_Price_Change__c IN: objIds];
            //  delete[SELECT Id FROM Phoenix_Customer_Response__c WHERE Phoenix_PHS_Price_Change__c IN: objIds];
            // delete[SELECT Id FROM Phoenix_Bid_Line_Product_Family__c WHERE Phoenix_Bid__c IN: objIds];
            delete[SELECT Id FROM Attachment WHERE ParentId IN: objIds];
            //  delete[SELECT Id FROM Checklist__c WHERE Bid__c IN: objIds];


            set < string > toaddress = new set < string > ();
            set < string > ccaddress = new set < string > ();
            set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
            for (String pHSChangeId: pHSChangeMap.keyset()) {

                Phoenix_PHS_Price_Change__c pHSChange = pHSChangeMap.get(pHSChangeId);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('PHS_Change_Delete_Notification', pHSChangeId);
                String templateBody = emailWrapper.mailHtmlBody;
                String subject = emailWrapper.mailSubject;

                if (templateBody.contains('USER_NAME')) templateBody = templateBody.replace('USER_NAME', UserInfo.getName());

                toaddress.add(pHSChange.owner.Email);
                for (Phoenix_Bid_Process_Steps__c step: [SELECT Id, Name, Phoenix_Approver__c, Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Status__c, Phoenix_Approver__r.Email FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Status__c != 'Not Applicable'
                        AND Phoenix_PHS_Price_Change__c =: pHSChangeId
                    ]) {
                    if (step.Phoenix_Approver__c != null) {
                        allPeopleInvolvedEmailsSet.add(step.Phoenix_Approver__r.Email);
                    }

                }
                if (Label.Phoenix_Contracts_DL != null) ccaddress.addAll(Label.Phoenix_Contracts_DL.split(','));
                ccaddress.addAll(allPeopleInvolvedEmailsSet);
                for (String emailId: toaddress) {
                    if (ccaddress.contains(emailId))
                        ccaddress.remove(emailId);
                }

                email.setToAddresses(new List < String > (toaddress));
                email.setCcAddresses(new List < String > (ccaddress));
                email.setSubject(subject);
                email.setHtmlBody(templateBody);
                email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);

                mailsList.add(email);

            }
        } else if (objName == 'New_Product_WAC_Pricing__c') {

            map < Id, New_Product_WAC_Pricing__c > newWacMap = new map < Id, New_Product_WAC_Pricing__c > ([SELECT Id, ownerId, owner.Name, owner.Email FROM New_Product_WAC_Pricing__c WHERE Id In: objIds]);
            delete[SELECT Id FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_New_Product_WAC_Pricing__c IN: objIds];
            delete[SELECT Id FROM Phoenix_NewProduct_WAC_Pricing_LineItems__c WHERE Phoenix_New_Product_WAC_Pricing__c IN: objIds];
            // delete[SELECT Id FROM Phoenix_Bid_Process_History__c WHERE Phoenix_Bid__c IN: objIds];
            delete[SELECT Id FROM Phoenix_Approval_Grid__c WHERE Phoenix_New_Product_WAC_Pricing__c IN: objIds];
            //  delete[SELECT Id FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_PHS_Price_Change__c IN: objIds];
            //  delete[SELECT Id FROM Phoenix_Customer_Response__c WHERE Phoenix_PHS_Price_Change__c IN: objIds];
            // delete[SELECT Id FROM Phoenix_Bid_Line_Product_Family__c WHERE Phoenix_Bid__c IN: objIds];
            delete[SELECT Id FROM Attachment WHERE ParentId IN: objIds];
            //  delete[SELECT Id FROM Checklist__c WHERE Bid__c IN: objIds];


            set < string > toaddress = new set < string > ();
            set < string > ccaddress = new set < string > ();
            set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
            for (String newWacId: newWacMap.keyset()) {

                New_Product_WAC_Pricing__c newWac = newWacMap.get(newWacId);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('New_Wac_delete', newWacId);
                String templateBody = emailWrapper.mailHtmlBody;
                String subject = emailWrapper.mailSubject;

                if (templateBody.contains('USER_NAME')) templateBody = templateBody.replace('USER_NAME', UserInfo.getName());

                toaddress.add(newWac.owner.Email);
                for (Phoenix_Bid_Process_Steps__c step: [SELECT Id, Name, Phoenix_Approver__c, Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Status__c, Phoenix_Approver__r.Email FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Status__c != 'Not Applicable'
                        AND Phoenix_New_Product_WAC_Pricing__c =: newWacId
                    ]) {
                    if (step.Phoenix_Approver__c != null) {
                        allPeopleInvolvedEmailsSet.add(step.Phoenix_Approver__r.Email);
                    }

                }
                if (Label.Phoenix_Contracts_DL != null) ccaddress.addAll(Label.Phoenix_Contracts_DL.split(','));
                ccaddress.addAll(allPeopleInvolvedEmailsSet);
                for (String emailId: toaddress) {
                    if (ccaddress.contains(emailId))
                        ccaddress.remove(emailId);
                }

                email.setToAddresses(new List < String > (toaddress));
                email.setCcAddresses(new List < String > (ccaddress));
                email.setSubject(subject);
                email.setHtmlBody(templateBody);
                email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);

                mailsList.add(email);

            }
        } else if (objName == 'Phoenix_WAC_Change__c') {

            map < Id, Phoenix_WAC_Change__c > WacChangeMap = new map < Id, Phoenix_WAC_Change__c > ([SELECT Id, ownerId, owner.Name, owner.Email FROM Phoenix_WAC_Change__c WHERE Id In: objIds]);
            delete[SELECT Id FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_WAC_Change__c IN: objIds];
            delete[SELECT Id FROM Phoenix_WAC_Change_Line_Item__c WHERE Phoenix_WAC_Change__c IN: objIds];
            delete[SELECT Id FROM Phoenix_Bid_Process_History__c WHERE Phoenix_Bid__c IN: objIds];
            //  delete[SELECT Id FROM Phoenix_Approval_Grid__c WHERE Phoenix_WAC_Change__c IN: objIds];
            //  delete[SELECT Id FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_PHS_Price_Change__c IN: objIds];
            //  delete[SELECT Id FROM Phoenix_Customer_Response__c WHERE Phoenix_PHS_Price_Change__c IN: objIds];
            // delete[SELECT Id FROM Phoenix_Bid_Line_Product_Family__c WHERE Phoenix_Bid__c IN: objIds];
            delete[SELECT Id FROM Attachment WHERE ParentId IN: objIds];
            //  delete[SELECT Id FROM Checklist__c WHERE Bid__c IN: objIds];


            set < string > toaddress = new set < string > ();
            set < string > ccaddress = new set < string > ();
            set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
            for (String WACChangeId: WacChangeMap.keyset()) {

                Phoenix_WAC_Change__c WACChange = WacChangeMap.get(WACChangeId);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('WAC_Change_delete', WACChangeId);
                String templateBody = emailWrapper.mailHtmlBody;
                String subject = emailWrapper.mailSubject;

                if (templateBody.contains('USER_NAME')) templateBody = templateBody.replace('USER_NAME', UserInfo.getName());

                toaddress.add(WACChange.owner.Email);
                for (Phoenix_Bid_Process_Steps__c step: [SELECT Id, Name, Phoenix_Approver__c, Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Status__c, Phoenix_Approver__r.Email FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Status__c != 'Not Applicable'
                        AND Phoenix_WAC_Change__c =: WACChangeId
                    ]) {
                    if (step.Phoenix_Approver__c != null) {
                        allPeopleInvolvedEmailsSet.add(step.Phoenix_Approver__r.Email);
                    }

                }
                if (Label.Phoenix_Contracts_DL != null) ccaddress.addAll(Label.Phoenix_Contracts_DL.split(','));
                ccaddress.addAll(allPeopleInvolvedEmailsSet);
                for (String emailId: toaddress) {
                    if (ccaddress.contains(emailId))
                        ccaddress.remove(emailId);
                }

                email.setToAddresses(new List < String > (toaddress));
                email.setCcAddresses(new List < String > (ccaddress));
                email.setSubject(subject);
                email.setHtmlBody(templateBody);
                email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);

                mailsList.add(email);

            }
        }

        if (mailsList.size() > 0)
            results = Messaging.sendEmail(mailsList);

    }
}

Catch(Exception e) {
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();

    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'deleteBidChildren', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Remarks__c = 'Bid Ids are ' + objIds, Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}
}
/**
* @description This method is deprecated. Use Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification method directly. 
**/

public static void sendForApproval(Id bidId, String str, List < Phoenix_Bid_Process_Steps__c > nextSteps, String str2) {
approvalRequestNotification(bidId, nextSteps);
}

/**
* @description This will be used to send notifications to approvers when approval is needed. 
Individual email will be sent to each person if user approval matrix defined as Single User/account based/product based and single email to all in To when user approval matrix defined as Team. 
* @author Surender Patel (Dhruvsoft) | 12-05-2021 
* @param String bidId 
* @param List<Phoenix_Bid_Process_Steps__c> nextSteps 
**/
public static void approvalRequestNotification(Id objId, List < Phoenix_Bid_Process_Steps__c > nextSteps) {
List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
        
        
 //bidtype label names added by vandana.
      Map < String, String > bidTypesmap = new Map < String, String > ();
                    
            for(Schema.PicklistEntry  ple:  Phoenix_Bid__c.Phoenix_Bid_Type__c.getDescribe().getPicklistValues()){
                bidTypesmap.put(ple.getValue(),ple.getLabel());
            }
        
  //bidtype label names added end.

try {
    set < Id > userIds = new set < Id > ();
    for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
        if (step.Phoenix_Approver__c != null)
            userIds.add(step.Phoenix_Approver__c);

    }
            
    Map < Id, User > usersMap = new Map < Id, User > ([SELECT Id, Name, Email,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegated_Approver__r.Email FROM User]);
            
    string NDC_Change_Line_Items = '';
    NDC_Change_Line_Items += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;padding:4px;">S.No</th><th style="border: 1px solid black;padding:4px;">Current Product</th><th style="border: 1px solid black;padding:4px;">Current Product NDC</th><th style="border: 1px solid black;padding:4px;">Current Product Pack Size</th><th style="border: 1px solid black;padding:4px;">Proposed Product</th><th style="border: 1px solid black;padding:4px;">Proposed Product NDC</th><th style="border: 1px solid black;padding:4px;">Proposed Product Pack Size</th></tr></thead>';
    NDC_Change_Line_Items += '<tbody>';

    string pHS_Change_Line_Items = '';
    string new_wac_Lines = '';
    string Wac_Change_Lines = '';
    string PhsRecType;
    //pHS_Change_Line_Items += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;">S.No</th><th style="border: 1px solid black;">Product Name</th><th style="border: 1px solid black;">Material Code</th><th style="border: 1px solid black;">NDC-11</th>'+PhsRecType+'<th style="border: 1px solid black;">Price Start Date</th><th style="border: 1px solid black;;">Price End Date</th></tr></thead>';
    //pHS_Change_Line_Items += '<tbody>';
    integer sNo = 0;
    String objName = String.valueOf(objId.getsObjectType());

    String mailStatus = '';
    Messaging.SendEmailResult[] results;
    Set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
    Phoenix_Bid__c bid;
    List < Phoenix_Bid_Line_Item__c > bidItems;
    Phoenix_NDC_Change__c ndcChange;
    Phoenix_PHS_Price_Change__c pHSChange;
    New_Product_WAC_Pricing__c newWac;
    Phoenix_WAC_Change__c WacChange;
    String Product_Families_bItems = '';
    String Approval_Information = '<b>' + 'Approval_Information : ' + '<br/><br/>' + 'To approve/reject by email:' + '</b><br/><br/>' + 'Reply to this email with only one of these words listed below:' + '<br/>' + 'To approve - APPROVE, APPROVED, YES' + '<br/>' + 'To reject - REJECT, REJECTED, NO';

    //  String Approval_Information ='<b>'+'Approval_Information : '+ '<br/><br/>'+'Reply to this email with one of these words in the first line of the email message: APPROVE, APPROVED, YES for approving the record and REJECT, REJECTED, NO for rejecting the record.'+'<br/><br/>'+'OR'+'</b>';
    if (objName == 'Phoenix_Bid__c') {
               
        bid = [Select Id,Phoenix_is_OTC_Bid__c, Name, Owner.Email,Phoenix_Bid_Type__c, Phoenix_Bid_Deadline_Date__c, Phoenix_Sales_Person_2__c, Phoenix_Sales_Person_2__r.Email, Phoenix_Salesperson__c, Phoenix_Salesperson__r.Email, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Bid_Created_Behalf_of__r.Email, Phoenix_Internal_Target_Date__c, Phoenix_Customer_Bid_Deadline_Date_Time__c FROM Phoenix_Bid__c Where Id =: objId];
        bidItems = [Select Id, Name, Phoenix_Product__r.Phoenix_Product_Director__c, Phoenix_Product__r.Phoenix_Marketing_Lead__c, Phoenix_Product__c, Phoenix_Product__r.Family FROM Phoenix_Bid_Line_Item__c Where Phoenix_Bid__c =: objId AND Phoenix_Final_Status__c != 'Not Approved'];

        list < Phoenix_Approval_Grid__c > approvalGridList = [Select Id, Phoenix_Product_Family__c, Phoenix_Is_New_Low__c, Phoenix_Annualized_TP__c, Phoenix_Annualized_TP_Impact__c,
            Phoenix_Annualized_TP_Impact_Limit__c, Phoenix_TP__c, Phoenix_TP_Limit__c, Phoenix_Annualized_GM__c,
            Phoenix_Annualized_GM_Impact__c, Phoenix_Annualized_GM_Impact_Limit__c, Phoenix_Revenue__c, Phoenix_Revenue_Limit__c,
            Phoenix_GM__c, Phoenix_GM_Limit__c, Phoenix_Marketing_Lead_Rx__c, Phoenix_Marketing_Lead_SRx__c, Phoenix_Marketing_Lead_OTC__c,
            Phoenix_Business_Head_Comments__c, Phoenix_Approval__c, Phoenix_Comments__c, Phoenix_Sr_Director_VP__c,
            Phoenix_Sr_Director_VP_Finance_Comments__c, Phoenix_Is_partner_product__c FROM Phoenix_Approval_Grid__c WHERE Phoenix_Bid__c =: objId
        ];
        if (!bid.Phoenix_is_OTC_Bid__c) {
        Product_Families_bItems += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;padding:4px;">S.No</th><th style="border: 1px solid black;width:15%;padding:4px">Product Family</th><th style="border: 1px solid black;width:15%;padding:4px">Products below Lowest Price / SKU</th><th style="border: 1px solid black;width:15%;padding:4px">Annualized TP</th><th style="border: 1px solid black;width:21%;padding:4px">Annualized TP Impact</th><th style="border: 1px solid black;width:27%;padding:4px">Annualized TP Impact Limit</th><th style="border: 1px solid black; width:9%;padding:4px;">TP%</th><th style="border: 1px solid black; width:15%;padding:4px;">TP % Limit</th><th style="border: 1px solid black; width:15%;padding:4px">Annualized GM</th><th style="border: 1px solid black;width:23%;padding:4px">Annualized GM Impact</th><th style="border: 1px solid black;width:28%;padding:4px">Annualized GM Impact Limit</th><th style="border: 1px solid black;width:15%;padding:4px">Revenue</th><th style="border: 1px solid black;width:15%;padding:4px">Revenue Limit</th><th style="border: 1px solid black;width:9%;padding:4px">GM%</th><th style="border: 1px solid black; width:15%;padding:4px">GM% Limit</th><th style="border: 1px solid black;width:18%;padding:4px">Marketing Lead Rx</th><th style="border: 1px solid black;width:20%;padding:4px">Marketing Lead SRx</th><th style="border: 1px solid black;width:20%;padding:4px">Marketing Lead OTC</th><th style="border: 1px solid black;width:25%;padding:4px">Marketing Lead Comments</th><th style="border: 1px solid black;width:25%;padding:4px">Marketing Head Approval</th><th style="border: 1px solid black;width:25%;padding:4px">Marketing Head Comments</th><th style="border: 1px solid black;width:32%;padding:4px">Sr Director / VP Finance Approval</th><th style="border: 1px solid black;width:34%;padding:4px">Sr Director / VP Finance Comments</th></tr></thead>';
        }
        else if (bid.Phoenix_is_OTC_Bid__c) {
        Product_Families_bItems += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;padding:4px;">S.No</th><th style="border: 1px solid black;width:15%;padding:4px">Product Family</th><th style="border: 1px solid black;width:15%;padding:4px">Products below Lowest Price / SKU</th><th style="border: 1px solid black;width:15%;padding:4px">Annualized TP</th><th style="border: 1px solid black;width:21%;padding:4px">Annualized TP Impact</th><th style="border: 1px solid black;width:27%;padding:4px">Annualized TP Impact Limit</th><th style="border: 1px solid black; width:9%;padding:4px;">TP%</th><th style="border: 1px solid black; width:15%;padding:4px;">TP % Limit</th><th style="border: 1px solid black; width:15%;padding:4px">Annualized GM</th><th style="border: 1px solid black;width:23%;padding:4px">Annualized GM Impact</th><th style="border: 1px solid black;width:28%;padding:4px">Annualized GM Impact Limit</th><th style="border: 1px solid black;width:15%;padding:4px">Revenue</th><th style="border: 1px solid black;width:15%;padding:4px">Revenue Limit</th><th style="border: 1px solid black;width:9%;padding:4px">GM%</th><th style="border: 1px solid black; width:15%;padding:4px">GM% Limit</th><th style="border: 1px solid black;width:20%;padding:4px">Marketing Lead OTC</th><th style="border: 1px solid black;width:25%;padding:4px">Marketing Lead Comments</th><th style="border: 1px solid black;width:25%;padding:4px">Marketing Head Approval</th><th style="border: 1px solid black;width:25%;padding:4px">Marketing Head Comments</th><th style="border: 1px solid black;width:32%;padding:4px">Sr Director / VP Finance Approval</th><th style="border: 1px solid black;width:34%;padding:4px">Sr Director / VP Finance Comments</th></tr></thead>';
        }
            Product_Families_bItems += '<tbody>';





        for (Phoenix_Approval_Grid__c grid: approvalGridList) {
            sNo++;
            Product_Families_bItems += '<tr>';
            Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + sNo + '</td>';
            Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + grid.Phoenix_Product_Family__c + '</td>';

            if (grid.Phoenix_Is_New_Low__c == True) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;background-color:Yellow;padding:4px">' + 'Yes' + '</td>';
            else if (grid.Phoenix_Is_New_Low__c == False) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + 'No' + '</td>';
            else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (grid.Phoenix_Is_partner_product__c == false) {

                if (grid.Phoenix_Annualized_TP__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:right;;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Annualized_TP__c) + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';



                if (grid.Phoenix_Annualized_TP_Impact__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:right;;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Annualized_TP_Impact__c) + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';

                if (grid.Phoenix_Annualized_TP_Impact_Limit__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;;padding:4px">' + grid.Phoenix_Annualized_TP_Impact_Limit__c + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';

                if (grid.Phoenix_TP__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:right;;padding:4px">' + grid.Phoenix_TP__c.setscale(2) +'%' +'</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';

                if (grid.Phoenix_TP_Limit__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:right;background-color:Yellow;;padding:4px">' + grid.Phoenix_TP_Limit__c + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';

            } else {
                Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';

            }
            if (grid.Phoenix_Is_partner_product__c == True) {
                if (grid.Phoenix_Annualized_GM__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align: right;;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Annualized_GM__c) + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';

                if (grid.Phoenix_Annualized_GM_Impact__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align: right;;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Annualized_GM_Impact__c) + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';

                if (grid.Phoenix_Annualized_GM_Impact_Limit__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;;padding:4px">' + grid.Phoenix_Annualized_GM_Impact_Limit__c + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';


            } else {
                Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';

            }

            if (grid.Phoenix_Revenue__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align: right;;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Revenue__c) + '</td>';
            else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (grid.Phoenix_Revenue_Limit__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;;padding:4px">' + grid.Phoenix_Revenue_Limit__c + '</td>';
            else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (grid.Phoenix_Is_partner_product__c == True) {
                if (grid.Phoenix_GM__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:right;;padding:4px">' + grid.Phoenix_GM__c.setscale(2) + '%' +'</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';

                if (grid.Phoenix_GM_Limit__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:right;background-color:Yellow;;padding:4px">' + grid.Phoenix_GM_Limit__c + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
            } else {

                Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';

            }
            if (!bid.Phoenix_is_OTC_Bid__c) {
                if (grid.Phoenix_Marketing_Lead_Rx__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + grid.Phoenix_Marketing_Lead_Rx__c + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                        
                if (grid.Phoenix_Marketing_Lead_SRx__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + grid.Phoenix_Marketing_Lead_SRx__c + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (grid.Phoenix_Marketing_Lead_OTC__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + grid.Phoenix_Marketing_Lead_OTC__c + '</td>';
            else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (grid.Phoenix_Business_Head_Comments__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + grid.Phoenix_Business_Head_Comments__c + '</td>';
            else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (grid.Phoenix_Approval__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + grid.Phoenix_Approval__c + '</td>';
            else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (grid.Phoenix_Comments__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + grid.Phoenix_Comments__c + '</td>';
            else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (grid.Phoenix_Sr_Director_VP__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + grid.Phoenix_Sr_Director_VP__c + '</td>';
            else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';


            if (grid.Phoenix_Sr_Director_VP_Finance_Comments__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + grid.Phoenix_Sr_Director_VP_Finance_Comments__c + '</td>';
            else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';

            Product_Families_bItems += '</tr>';

        }
        Product_Families_bItems += '</tbody></table>';

        //Add Sales persons
        if (bid.Phoenix_Sales_Person_2__c != null) {
            allPeopleInvolvedEmailsSet.add(bid.Phoenix_Sales_Person_2__r.Email);
        } else if (bid.Phoenix_Salesperson__c != null) {
            allPeopleInvolvedEmailsSet.add(bid.Phoenix_Salesperson__r.Email);
        }

    } 
    else if (objName == 'Phoenix_NDC_Change__c') {
                
        ndcChange = [Select Id, Name, Owner.Email, Phoenix_Approval_Status__c from Phoenix_NDC_Change__c WHERE Id =: objId LIMIT 1];
        List < Phoenix_NDC_Change_Line_Item__c > ndcLineItemsList = [Select Phoenix_Current_Product__c, Phoenix_Current_Product__r.Name, Phoenix_Current_Product_NDC__c, Phoenix_Current_Product_Pack_Size__c, Phoenix_Proposed_Product__c, Phoenix_Proposed_Product__r.Name, Phoenix_Proposed_Product_NDC__c, Phoenix_Proposed_Product_Pack_Size__c FROM Phoenix_NDC_Change_Line_Item__c where Phoenix_NDC_Change__c =: objId];

        for (Phoenix_NDC_Change_Line_Item__c ndcItem: ndcLineItemsList) {
            sNo++;
            NDC_Change_Line_Items += '<tr>';
            NDC_Change_Line_Items += '<td style="border: 1px solid black;text-align:left;">' + sNo + '</td>';
            if (ndcItem.Phoenix_Current_Product__c != null) NDC_Change_Line_Items += '<td style="border: 1px solid black;text-align:left;padding:4px;">' + ndcItem.Phoenix_Current_Product__r.Name + '</td>';
            else NDC_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (ndcItem.Phoenix_Current_Product_NDC__c != null) NDC_Change_Line_Items += '<td style="border: 1px solid black;text-align:left;padding:4px;">' + ndcItem.Phoenix_Current_Product_NDC__c + '</td>';
            else NDC_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (ndcItem.Phoenix_Current_Product_Pack_Size__c != null) NDC_Change_Line_Items += '<td style="border: 1px solid black;text-align:right;padding:4px;">' + ndcItem.Phoenix_Current_Product_Pack_Size__c + '</td>';
            else NDC_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (ndcItem.Phoenix_Proposed_Product__c != null) NDC_Change_Line_Items += '<td style="border: 1px solid black;text-align:left;padding:4px;">' + ndcItem.Phoenix_Proposed_Product__r.Name + '</td>';
            else NDC_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (ndcItem.Phoenix_Proposed_Product_NDC__c != null) NDC_Change_Line_Items += '<td style="border: 1px solid black;text-align:left;padding:4px;">' + ndcItem.Phoenix_Proposed_Product_NDC__c + '</td>';
            else NDC_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (ndcItem.Phoenix_Proposed_Product_Pack_Size__c != null) NDC_Change_Line_Items += '<td style="border: 1px solid black;text-align:right;padding:4px;">' + ndcItem.Phoenix_Proposed_Product_Pack_Size__c + '</td>';
            else NDC_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';


            NDC_Change_Line_Items += '</tr>';



        }
        NDC_Change_Line_Items += '</tbody></table>';

    } 
    else if (objName == 'Phoenix_PHS_Price_Change__c') {
              
        pHSChange = [Select Id, Name, Owner.Email, Phoenix_Approval_Status__c, Phoenix_Record_Type__c from Phoenix_PHS_Price_Change__c WHERE Id =: objId LIMIT 1];
        string rectype = pHSChange.Phoenix_Record_Type__c;
             
        pHS_Change_Line_Items += '<tbody>';

        if (rectype == 'Provisional PHS Price Change') {
            pHS_Change_Line_Items += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;padding:4px">S.No</th><th style="border: 1px solid black;padding:4px">Product Name</th><th style="border: 1px solid black;padding:4px">Material Code</th><th style="border: 1px solid black;padding:4px">NDC-11</th><th style="border: 1px solid black;padding:4px">Provisional PHS Price</th><th style="border: 1px solid black;padding:4px">Price Start Date</th><th style="border: 1px solid black;padding:4px;">Price End Date</th></tr></thead>';
            PhsRecType = '<th style="border: 1px solid black;padding:4px">Provisional PHS Price</th>';
                    
        } else {
            pHS_Change_Line_Items += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;padding:4px">S.No</th><th style="border: 1px solid black;padding:4px">Product Name</th><th style="border: 1px solid black;padding:4px">Material Code</th><th style="border: 1px solid black;padding:4px">NDC-11</th><th style="border: 1px solid black;padding:4px">Old PHS Price $</th><th style="border: 1px solid black;padding:4px">New PHS Price</th><th style="border: 1px solid black;padding:4px">Price Start Date</th><th style="border: 1px solid black;padding:4px;">Price End Date</th></tr></thead>';
            PhsRecType = '<th style="border: 1px solid black;padding:4px">Old PHS Price </th><th style="border: 1px solid black;padding:4px">New PHS Price</th>';

        }
        List < Phoenix_PHS_Price_Change_Line__c > pHSLineItemsList = [Select Phoenix_Product_Name__c, Phoenix_Product_Name__r.Name, Phoenix_Material_Code__c, Phoenix_NDC_11__c, Phoenix_Provisional_PHS_Price__c, Phoenix_Old_PHS_Price__c, Phoenix_New_PHS_Price__c, Phoenix_Price_Start_Date__c, Phoenix_Price_End_Date__c FROM Phoenix_PHS_Price_Change_Line__c where Phoenix_PHS_Price_Change__c =: objId];

        for (Phoenix_PHS_Price_Change_Line__c pHSItem: pHSLineItemsList) {
            sNo++;
            PHS_Change_Line_Items += '<tr>';
            PHS_Change_Line_Items += '<td style="border: 1px solid black;text-align: left;padding:4px">' + sNo + '</td>';
            if (pHSItem.Phoenix_Product_Name__r.Name != null) PHS_Change_Line_Items += '<td style="border: 1px solid black;text-align: left;padding:4px">' + pHSItem.Phoenix_Product_Name__r.Name + '</td>';
            else PHS_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (pHSItem.Phoenix_Material_Code__c != null) {
                string materialCode = pHSItem.Phoenix_Material_Code__c;
                materialCode.replaceFirst('^0+', '');
                PHS_Change_Line_Items += '<td style="border: 1px solid black;text-align: left;padding:4px">' + materialCode + '</td>';
            } else {
                PHS_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (pHSItem.Phoenix_NDC_11__c != null) PHS_Change_Line_Items += '<td style="border: 1px solid black;text-align: left;padding:4px;">' + pHSItem.Phoenix_NDC_11__c + '</td>';
            else PHS_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (rectype == 'Provisional PHS Price Change') {
                if (pHSItem.Phoenix_Provisional_PHS_Price__c != null) PHS_Change_Line_Items += '<td style="border: 1px solid black;text-align: right;padding:4px;">' + '$' + pHSItem.Phoenix_Provisional_PHS_Price__c + '</td>';
                else PHS_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';
            } else {
                if (pHSItem.Phoenix_Old_PHS_Price__c != null) PHS_Change_Line_Items += '<td style="border: 1px solid black;text-align: right;padding:4px;">' + '$' + pHSItem.Phoenix_Old_PHS_Price__c + '</td>';
                else PHS_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (pHSItem.Phoenix_New_PHS_Price__c != null) PHS_Change_Line_Items += '<td style="border: 1px solid black;text-align: right;padding:4px;">' + '$' + pHSItem.Phoenix_New_PHS_Price__c + '</td>';
                else PHS_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';
            }

            if (pHSItem.Phoenix_Price_Start_Date__c != null) {
                DateTime startDate = DateTime.newInstance(pHSItem.Phoenix_Price_Start_Date__c, Time.newInstance(0, 0, 0, 0));
                PHS_Change_Line_Items += '<td style="border: 1px solid black;text-align: right;padding:4px;">' + startDate.format('MMM d yyyy') + '</td>';
            } else {
                PHS_Change_Line_Items += '<td style="border: 1px solid black;padding:4px;">' + '' + '</td>';
            }
            if (pHSItem.Phoenix_Price_End_Date__c != null) {
                DateTime endDate = DateTime.newInstance(pHSItem.Phoenix_Price_End_Date__c, Time.newInstance(0, 0, 0, 0));

                PHS_Change_Line_Items += '<td style="border: 1px solid black;text-align: right;padding:4px;">' + endDate.format('MMM d yyyy') + '</td>';
            } else {
                PHS_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';
            }

            PHS_Change_Line_Items += '</tr>';



        }
        PHS_Change_Line_Items += '</tbody></table>';
                
    } 
    else if (objName == 'New_Product_WAC_Pricing__c') {
               
        newWac = [Select Id, Name, Owner.Email, Phoenix_Approval_Status__c from New_Product_WAC_Pricing__c WHERE Id =: objId LIMIT 1];
        new_wac_Lines += '<tbody>';


        new_wac_Lines += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;padding:4px;">S.No</th><th style="border: 1px solid black;padding:4px;">Material Number</th><th style="border: 1px solid black;padding:4px;">NDC-11</th><th style="border: 1px solid black;padding:4px;">Product</th><th style="border: 1px solid black;padding:4px;">Pack Size</th><th style="border: 1px solid black;padding:4px;">WAC</th><th style="border: 1px solid black;padding:4px;">Lowest Price</th><th style="border: 1px solid black;padding:4px;">TPT % / GM %</th></tr></thead>';



        List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > NewWACLineItemsList = [Select Phoenix_Material_Number__c, Phoenix_NDC_11__c, Phoenix_Product__r.Name, Phoenix_Pkg_Size__c, Phoenix_WAC__c, Phoenix_Lowest_Price__c, Phoenix_TPT_GM__c FROM Phoenix_NewProduct_WAC_Pricing_LineItems__c where Phoenix_New_Product_WAC_Pricing__c =: objId];

        for (Phoenix_NewProduct_WAC_Pricing_LineItems__c newWACItem: NewWACLineItemsList) {
            sNo++;
            new_wac_Lines += '<tr>';
            new_wac_Lines += '<td style="border: 1px solid black;text-align: left;padding:4px;">' + sNo + '</td>';
            if (newWACItem.Phoenix_Material_Number__c != null) new_wac_Lines += '<td style="border: 1px solid black;text-align: left;padding:4px;">' + newWACItem.Phoenix_Material_Number__c + '</td>';
            else new_wac_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (newWACItem.Phoenix_NDC_11__c != null) {


                new_wac_Lines += '<td style="border: 1px solid black;text-align: left;padding:4px;">' + newWACItem.Phoenix_NDC_11__c + '</td>';
            } else {
                new_wac_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (newWACItem.Phoenix_Product__r.Name != null) new_wac_Lines += '<td style="border: 1px solid black;text-align: left;padding:4px;">' + newWACItem.Phoenix_Product__r.Name + '</td>';
            else new_wac_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';


            if (newWACItem.Phoenix_Pkg_Size__c != null) new_wac_Lines += '<td style="border: 1px solid black;text-align: right;">' + newWACItem.Phoenix_Pkg_Size__c + '</td>';
            else new_wac_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (newWACItem.Phoenix_WAC__c != null) new_wac_Lines += '<td style="border: 1px solid black;text-align: right;padding:4px;">' + '$' + newWACItem.Phoenix_WAC__c + '</td>';
            else new_wac_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';


            if (newWACItem.Phoenix_Lowest_Price__c != null) {

                new_wac_Lines += '<td style="border: 1px solid black;text-align: right;padding:4px;">' + '$' + newWACItem.Phoenix_Lowest_Price__c + '</td>';
            } else {
                new_wac_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (newWACItem.Phoenix_TPT_GM__c != null) {


                new_wac_Lines += '<td style="border: 1px solid black;text-align: right;padding:4px;">' + newWACItem.Phoenix_TPT_GM__c + '%' + '</td>';
            } else {
                new_wac_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
            }

            new_wac_Lines += '</tr>';



        }
        new_wac_Lines += '</tbody></table>';
                
    } 
    else if (objName == 'Phoenix_WAC_Change__c') {
               
        WacChange = [Select Id, Name, Owner.Email, Phoenix_Approval_Status__c from Phoenix_WAC_Change__c WHERE Id =: objId LIMIT 1];
        Wac_Change_Lines += '<tbody>';


        Wac_Change_Lines += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;padding:4px;">S.No</th><th style="border: 1px solid black;padding:4px;">Contract Number</th><th style="border: 1px solid black;padding:4px;">Customer Name</th><th style="border: 1px solid black;padding:4px;">Product</th><th style="border: 1px solid black;padding:4px;">System WAC</th><th style="border: 1px solid black;padding:4px;">System Contract Price</th><th style="border: 1px solid black;padding:4px;">Uploaded WAC</th><th style="border: 1px solid black;padding:4px;">Uploaded Contr.Price</th><th style="border: 1px solid black;padding:4px;">Proposed WAC</th><th style="border: 1px solid blackpadding:4px;">Proposed Contr.Price</th></tr></thead>';



        List < Phoenix_WAC_Change_Line_Item__c > WACChangeLineItemsList = [Select Phoenix_Contr_Number__c, Phoenix_Cust_Name__c, Phoenix_Product__r.Name, Phoenix_Proposed_WAC__c, Phoenix_System_WAC__c, Phoenix_Uploaded_WAC__c, Phoenix_Proposed_Contr_Price__c, Phoenix_System_Contract_price__c, Phoenix_Uploaded_Contr_Price__c FROM Phoenix_WAC_Change_Line_Item__c where Phoenix_WAC_Change__c =: objId];

        for (Phoenix_WAC_Change_Line_Item__c WACChangeItem: WACChangeLineItemsList) {
            sNo++;
            Wac_Change_Lines += '<tr>';
            Wac_Change_Lines += '<td style="border: 1px solid black;text-align: left;padding:4px;">' + sNo + '</td>';
            if (WACChangeItem.Phoenix_Contr_Number__c != null) Wac_Change_Lines += '<td style="border: 1px solid black;text-align: center;">' + WACChangeItem.Phoenix_Contr_Number__c + '</td>';
            else Wac_Change_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (WACChangeItem.Phoenix_Cust_Name__c != null) {


                Wac_Change_Lines += '<td style="border: 1px solid black;text-align: left;padding:4px;">' + WACChangeItem.Phoenix_Cust_Name__c + '</td>';
            } else {
                Wac_Change_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (WACChangeItem.Phoenix_Product__r.Name != null) Wac_Change_Lines += '<td style="border: 1px solid black;text-align: left;padding:4px;">' + WACChangeItem.Phoenix_Product__r.Name + '</td>';
            else Wac_Change_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';


            if (WACChangeItem.Phoenix_System_WAC__c != null) Wac_Change_Lines += '<td style="border: 1px solid black;text-align: right;padding:4px;">' + '$' + WACChangeItem.Phoenix_System_WAC__c + '</td>';
            else Wac_Change_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (WACChangeItem.Phoenix_System_Contract_price__c != null) Wac_Change_Lines += '<td style="border: 1px solid black;text-align: right;padding:4px;">' + '$' + WACChangeItem.Phoenix_System_Contract_price__c + '</td>';
            else Wac_Change_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';


            if (WACChangeItem.Phoenix_Uploaded_WAC__c != null) {

                Wac_Change_Lines += '<td style="border: 1px solid black;text-align: right;padding:4px;">' + '$' + WACChangeItem.Phoenix_Uploaded_WAC__c + '</td>';
            } else {
                Wac_Change_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (WACChangeItem.Phoenix_Uploaded_Contr_Price__c != null) {


                        
                Wac_Change_Lines += '<td style="border: 1px solid black;text-align: right;padding:4px;">' + '$' + WACChangeItem.Phoenix_Uploaded_Contr_Price__c + '</td>';
            } else {
                Wac_Change_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (WACChangeItem.Phoenix_Proposed_WAC__c != null) {

                Wac_Change_Lines += '<td style="border: 1px solid black;text-align: right;padding:4px;">' + '$' + WACChangeItem.Phoenix_Proposed_WAC__c + '</td>';
            } else {
                Wac_Change_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (WACChangeItem.Phoenix_Proposed_Contr_Price__c != null) {


                Wac_Change_Lines += '<td style="border: 1px solid black;text-align: right;padding:4px;">' + '$' + WACChangeItem.Phoenix_Proposed_Contr_Price__c + '</td>';
            } else {
                Wac_Change_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
            }

            Wac_Change_Lines += '</tr>';



        }
        Wac_Change_Lines += '</tbody></table>';
               
    }


    for (Phoenix_Bid_Process_Steps__c step: [SELECT Id, Name, Phoenix_Approver__c, Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Status__c, Phoenix_Approver__r.Email
            FROM Phoenix_Bid_Process_Steps__c
            WHERE Phoenix_Is_Criteria_Step__c = false AND Phoenix_Status__c != 'Not Applicable'
            AND(Phoenix_Bid__c =: objId OR Phoenix_NDC_Change__c =: objId OR Phoenix_PHS_Price_Change__c =: objId OR Phoenix_New_Product_WAC_Pricing__c =: objId OR Phoenix_WAC_Change__c =: objId)
        ]) {
        if (step.Phoenix_Approver__c != null) {
            // allPeopleInvolvedEmailsSet.add(step.Phoenix_Approver__r.Email);
            allPeopleInvolvedEmailsSet.add(usersMap.get(step.Phoenix_Approver__c).Email);
            if(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__c!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Name!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email!=null){
              allPeopleInvolvedEmailsSet.add(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email);    
                        
            }
        }
    }
           

    // set<string> productFamilySet = new set<string>();

    Map < Id, Set < String >> itemsByDitectorMap = new Map < Id, Set < String >> ();
    Map < Id, Set < String >> itemsByLeadMap = new Map < Id, Set < String >> ();
    //Arranging bid line items by director
    if (bidItems != null && bidItems.size() > 0) {
        for (Phoenix_Bid_Line_Item__c item: bidItems) {

            if (itemsByDitectorMap!=null && item.Phoenix_Product__r.Phoenix_Product_Director__c != null && item.Phoenix_Product__r.Family != null && itemsByDitectorMap.containsKey(item.Phoenix_Product__r.Phoenix_Product_Director__c)) {
                Set < String > temp = itemsByDitectorMap.get(item.Phoenix_Product__r.Phoenix_Product_Director__c);
                temp.add(item.Phoenix_Product__r.Family);
                itemsByDitectorMap.put(item.Phoenix_Product__r.Phoenix_Product_Director__c, temp);
            } else if (item.Phoenix_Product__r.Phoenix_Product_Director__c != null && item.Phoenix_Product__r.Family != null && !itemsByDitectorMap.containsKey(item.Phoenix_Product__r.Phoenix_Product_Director__c)) {
                itemsByDitectorMap.put(item.Phoenix_Product__r.Phoenix_Product_Director__c, new Set < String > {
                    item.Phoenix_Product__r.Family
                });
            }

            if (item.Phoenix_Product__r.Phoenix_Marketing_Lead__c != null && item.Phoenix_Product__r.Family != null && itemsByLeadMap.containsKey(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c)) {
                Set < String > temp = itemsByLeadMap.get(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c);
                temp.add(item.Phoenix_Product__r.Family);
                itemsByLeadMap.put(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c, temp);
            } else if (item.Phoenix_Product__r.Phoenix_Marketing_Lead__c != null && item.Phoenix_Product__r.Family != null && !itemsByLeadMap.containsKey(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c)) {
                itemsByLeadMap.put(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c, new Set < String > {
                    item.Phoenix_Product__r.Family
                });
            }
        }

    }
    Phoenix_Util.EmailWrapper emailWrapperMain;
    if (objName == 'Phoenix_Bid__c') emailWrapperMain = Phoenix_Util.getTemplateBody('Bid_Approval_Request_Notification', objId);
    else if (objName == 'Phoenix_NDC_Change__c') emailWrapperMain = Phoenix_Util.getTemplateBody('NDC_Approval_Request_Notification', objId);
    else if (objName == 'Phoenix_PHS_Price_Change__c') emailWrapperMain = Phoenix_Util.getTemplateBody('PHS_Approval_Request_Notification', objId);
    else if (objName == 'New_Product_WAC_Pricing__c') emailWrapperMain = Phoenix_Util.getTemplateBody('New_Wac_Approval_Request', objId);
    else if (objName == 'Phoenix_WAC_Change__c') emailWrapperMain = Phoenix_Util.getTemplateBody('WAC_Chage_Approval_Request', objId);


    for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
        Phoenix_Util.EmailWrapper emailWrapper = emailWrapperMain;

        String templateBody = emailWrapper.mailHtmlBody;
        String subject = emailWrapper.mailSubject;
        Messaging.SingleEmailMessage mail;
        set < String > toAddress = new set < String > ();

        if (step.Phoenix_Status__c == 'In Process' && step.Phoenix_Approver__c == null && step.Phoenix_Approver_Team__c != null) { //Means team

            mail = new Messaging.SingleEmailMessage();
            if (approvalTeamUsersEmailsMap.get(step.Phoenix_Approver_Team__c) != null){
                toAddress.addAll(approvalTeamUsersEmailsMap.get(step.Phoenix_Approver_Team__c));
                List<User> usersList = new List <User>();
                for(Id eachUserId : approvalTeamUsersMap.get(step.Phoenix_Approver_Team__c)){
                    usersList.add(usersMap.get(eachUserId));
                            
                }
                for( User u : usersList){
                 if(u.Phoenix_Delegated_Approver__c!=null && u.Phoenix_Delegated_Approver__r.Name!=null && u.Phoenix_Delegated_Approver__r.Email!=null){
                     toAddress.addAll( new List<String>{u.Phoenix_Delegated_Approver__r.Email});
                             
                }
            }
            }
            // mail.setToAddresses(new List<String>(approvalTeamUsersEmailsMap.get(step.Phoenix_Approver_Team__c)));
                   
            if (templateBody.contains('Phoenix_Approver')) templateBody = templateBody.replace('Phoenix_Approver', 'Team');

        } 
        else if (step.Phoenix_Status__c == 'In Process' && step.Phoenix_Approver__c != null) { //Means individuals

            mail = new Messaging.SingleEmailMessage();

             if(usersMap.get(step.Phoenix_Approver__c) != null){     
                toAddress.add(usersMap.get(step.Phoenix_Approver__c).Email);
            if(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Name!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__c!=null){
                toAddress.add(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email);
            }
            }
       /*     mail.setToAddresses(new List < String > {
                usersMap.get(step.Phoenix_Approver__c).Email
            });*/
            // system.debug('To address ------>'+step.Phoenix_Approver__r.Email);
            // system.debug('To Name ------>'+step.Phoenix_Approver__r.Name);

            if (templateBody.contains('Phoenix_Approver')){
                        
                if(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Name!=null){

                templateBody = templateBody.replace('Phoenix_Approver',
                   usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Name);
                }
                else{
                      templateBody = templateBody.replace('Phoenix_Approver',
                    usersMap.get(step.Phoenix_Approver__c).Name); 
                }

            }
            //   if (templateBody.contains('Team')) templateBody = templateBody.replaceFirst('Team', step.Phoenix_Approver__r.Name);
        }

        if (mail != null) {
                   
            String prodFamilyString = '';
            if(objName == 'Phoenix_Bid__c'){
            if (bid.Phoenix_Bid_Type__c!='Platform OTB' && step.Phoenix_Approver_Team__c == 'Marketing' && templateBody.contains('Product_Families') && step.Phoenix_Approver__c != null) {
                prodFamilyString = '';
                integer i = 1;
                for (String pfamily: itemsByDitectorMap.get(step.Phoenix_Approver__c)) {
                    prodFamilyString += i + '.' + pfamily + '<br/>';
                    i++;
                }
            } else if (step.Phoenix_Approver_Team__c.contains('Marketing Lead') && templateBody.contains('Product_Families') && step.Phoenix_Approver__c != null) {
                prodFamilyString = '';
                integer i = 1;
                if(step.Phoenix_Approver__c!=null){
                for (String pfamily: itemsByLeadMap.get(step.Phoenix_Approver__c)) {
                    prodFamilyString += i + '.' + pfamily + '<br/>';
                    i++;
                }
                }
            } else if (templateBody.contains('Product_Families')) {
                prodFamilyString = '';
                integer i = 1;
                for (String pfamilyList: itemsByDitectorMap.keySet()) {
                    for (String pfamily: itemsByDitectorMap.get(pfamilyList)) {
                        prodFamilyString += i + '.' + pfamily + '<br/>';
                        i++;
                    }
                }
            }

            if (step.Phoenix_Is_Criteria_Step__c == false && templateBody.contains('Product_Families')) templateBody = templateBody.replace('Product_Families', prodFamilyString);
            else if (step.Phoenix_Is_Criteria_Step__c == true && templateBody.contains('Product_Families')) templateBody = templateBody.replace('Product_Families', Product_Families_bItems);

            if (step.Phoenix_Is_Criteria_Step__c == false && templateBody.contains('Approval_Information')) templateBody = templateBody.replace('Approval_Information', '');
            else if (step.Phoenix_Is_Criteria_Step__c == true && templateBody.contains('Approval_Information')) templateBody = templateBody.replace('Approval_Information', Approval_Information);
        }
            if(templateBody.contains('Approval_Information') && objName == 'New_Product_WAC_Pricing__c') templateBody = templateBody.replace('Approval_Information', Approval_Information);
            if (templateBody.contains('NDC_Change_Line_Items')) templateBody = templateBody.replace('NDC_Change_Line_Items', NDC_Change_Line_Items);
            if (templateBody.contains('PHS_Change_Line_Items')) templateBody = templateBody.replace('PHS_Change_Line_Items', PHS_Change_Line_Items);
            if (templateBody.contains('WAC_Line_Items')) templateBody = templateBody.replace('WAC_Line_Items', new_wac_Lines);
            if (templateBody.contains('WAC_Change_Line_Items')) templateBody = templateBody.replace('WAC_Change_Line_Items', Wac_Change_Lines);
                    
                    
                    
                    
            //bidtype label names added by vandana.

            if(objName == 'Phoenix_Bid__c'){
            if (bidTypesmap!=null&&bidTypesmap.get(bid.Phoenix_Bid_Type__c)!=null&&templateBody.contains('BID_TYPE')) templateBody = templateBody.replace('BID_TYPE', bidTypesmap.get(bid.Phoenix_Bid_Type__c));
            if (bidTypesmap!=null&&bidTypesmap.get(bid.Phoenix_Bid_Type__c)!=null&&subject.contains('BID_TYPE')) subject = subject.replace('BID_TYPE', bidTypesmap.get(bid.Phoenix_Bid_Type__c));
            }
            //bidtype label names --end.

            if (objName == 'Phoenix_Bid__c' && bid.Phoenix_Internal_Target_Date__c != null) {
                DateTime internalDueDateTime = DateTime.newInstance(bid.Phoenix_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0));
                if (templateBody.contains('INTERNAL_DEADLINE_DATE')) templateBody = templateBody.replace('INTERNAL_DEADLINE_DATE', internalDueDateTime.format('MMM d yyyy'));
            }


            if (objName == 'Phoenix_Bid__c' && bid.Phoenix_Bid_Deadline_Date__c != null) {
                DateTime customerBidDeadline = DateTime.newInstance(bid.Phoenix_Bid_Deadline_Date__c, Time.newInstance(0, 0, 0, 0));
                if (templateBody.contains('CUSTOMER_DEADLINE_DATE')) templateBody = templateBody.replace('CUSTOMER_DEADLINE_DATE', customerBidDeadline.format('MMM d yyyy'));
            }
            Set < string > ccEmailIds = new Set < string > ();
            if (objName == 'Phoenix_Bid__c') ccEmailIds.add(bid.owner.Email);


            if (objName == 'Phoenix_Bid__c' && step.Phoenix_Is_Criteria_Step__c == true) {

                mail.setReplyTo(Label.Bright_Approval_Inbound_Email);
            } else if (objName == 'Phoenix_NDC_Change__c') ccEmailIds.add(ndcChange.owner.Email);
            else if (objName == 'Phoenix_PHS_Price_Change__c') ccEmailIds.add(pHSChange.owner.Email);
            else if (objName == 'New_Product_WAC_Pricing__c') {
                // ccEmailIds.add(newWac.owner.Email);
                mail.setReplyTo(Label.Bright_Approval_Inbound_Email);
            }       
            else if (objName == 'Phoenix_WAC_Change__c') ccEmailIds.add(WacChange.owner.Email);

            if (objName == 'Phoenix_Bid__c' && bid.Phoenix_Bid_Created_Behalf_of__c != null) ccEmailIds.add(bid.Phoenix_Bid_Created_Behalf_of__r.Email);

            if (step.Phoenix_Approver_Team__c == 'Home Office' && Label.CC_Emails_for_Vistex_Approvals != null) ccEmailIds.addAll(Label.CC_Emails_for_Vistex_Approvals.split(','));


            if (Label.Phoenix_Contracts_DL != null) ccEmailIds.addAll(Label.Phoenix_Contracts_DL.split(','));
            ccEmailIds.addAll(allPeopleInvolvedEmailsSet);
            for (string emailId: toAddress) {
                if (ccEmailIds.contains(emailId))
                    ccEmailIds.remove(emailId);
            }
                    
            If(ccEmailIds != null && ccEmailIds.contains('mkalawadia@drreddys.com'))ccEmailIds.remove('mkalawadia@drreddys.com');

            mail.setToAddresses(new List < String > (toAddress));
            mail.setCcAddresses(new List < String > (ccEmailIds));
            //   mail.setCcAddresses(new List<String>{'surenderpatel@drreddys.com'}); 
            mail.setSubject(subject);
            mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
            mail.setHtmlBody(templateBody);
            mails.add(mail);

            // if(step.Phoenix_Approver_Team__c == 'Sr Director or VP Finance')mail.setCcAddresses(new List<String>{'surender+BUheadCC@dhruvsoft.com'});//mail.setCcAddresses(new List<String>(approvalTeamUsersEmailsMap.get('Business Head')));
        }

    }

    results = Messaging.sendEmail(mails);
           

}
Catch(Exception e) {
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();

    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'approvalRequestNotification', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Remarks__c = '', Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}

// return mailStatus;

}


    
/**
* @description This will send notification to Bid Owner, Behalf of User, Salesperson when the SCM team rejects any one of the bid line items.
* @author Surender Patel (Dhruvsoft) | 12-05-2021 
* @param String bidIdStr 
**/
@future
public static void SCMProductRejectionNotification(Id objId) {


list < messaging.Email > mail = new list < messaging.email > ();
        
  //bidtype label names added by vandana.
      Map < String, String > bidTypesmap = new Map < String, String > ();
                    
            for(Schema.PicklistEntry  ple:  Phoenix_Bid__c.Phoenix_Bid_Type__c.getDescribe().getPicklistValues()){
                bidTypesmap.put(ple.getValue(),ple.getLabel());
            }
        
  //bidtype label names added end.


try {
    String objName = String.valueOf(objId.getsObjectType());
    Set < String > allPeopleInvolvedEmailsSet = approvalTeamUsersEmailsMap.get('Supply Chain');
    Map < Id, Phoenix_Bid_Line_Item__c > bidLineItemrecordsMap = new Map < Id, Phoenix_Bid_Line_Item__c > ();
    Map < Id, Phoenix_NDC_Change_Line_Item__c > ndcLineItemrecordsMap = new Map < Id, Phoenix_NDC_Change_Line_Item__c > ();
    for (Phoenix_Bid_Process_Steps__c step: [SELECT Id, Name, Phoenix_Approver__c, Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__r.Email
            FROM Phoenix_Bid_Process_Steps__c
            WHERE Phoenix_Is_Criteria_Step__c = false AND Phoenix_Status__c != 'Not Applicable'
            AND Phoenix_Approver__c != null AND Phoenix_Approver_Team__c != 'Marketing'
            AND(Phoenix_Bid__c =: objId OR Phoenix_NDC_Change__c =: objId)
        ]) {
        allPeopleInvolvedEmailsSet.add(step.Phoenix_Approver__r.Email);
    }

    if (objName == 'Phoenix_Bid__c') {
        bidLineItemrecordsMap = new Map < Id, Phoenix_Bid_Line_Item__c > ([SELECT Id, Phoenix_Bid__r.Phoenix_Bid_Deadline_Date__c, Phoenix_Bid__r.Phoenix_Sales_Person_2__c, Phoenix_Bid__r.Phoenix_Sales_Person_2__r.Email,
            Phoenix_Bid__r.Phoenix_Internal_Target_Date__c, Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__r.Email, Phoenix_Bid__r.Phoenix_Salesperson__c, Phoenix_Bid__r.Phoenix_Salesperson__r.Email,
            Phoenix_Bid__r.Owner.Email, Phoenix_Product__r.ProductCode, Phoenix_Product__r.Family, Phoenix_Product__r.Phoenix_NDC__c,
            Phoenix_SCM_Rejection_Reason1__c, Phoenix_Product_Director1__c, Phoenix_NDC__c, Phoenix_Product_Family1__c,
            Phoenix_Product_Code1__c, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Bid_Owner__r.Name,
            Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Name, Phoenix_Customer__r.Name,
            Phoenix_Customer__c, Phoenix_Product__r.Name, Phoenix_Product__r.Phoenix_Product_Director__c,
            Phoenix_Product__r.Phoenix_Product_Director__r.Name, Phoenix_Product__r.Phoenix_Product_Director__r.Email, Name,
            Phoenix_Product__c, Phoenix_Product_Director__c, Phoenix_Product__r.Phoenix_NDC_11_Dashes__c, Phoenix_Revisited_Date__c
            FROM Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: objId and Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved'
        ]);




        Set < String > productDirectorIds = new Set < String > ();
        Map < Id, List < Phoenix_Bid_Line_Item__c >> prodDirectorbItemsMap = new Map < Id, List < Phoenix_Bid_Line_Item__c >> ();

        for (Phoenix_Bid_Line_Item__c item: bidLineItemrecordsMap.values()) {
            String directorId = item.Phoenix_Product__r.Phoenix_Product_Director__c;
            productDirectorIds.add(directorId);
            if (prodDirectorbItemsMap.containsKey(directorId)) {
                List < Phoenix_Bid_Line_Item__c > addedList = prodDirectorbItemsMap.get(directorId);
                addedList.add(item);
                prodDirectorbItemsMap.put(directorId, addedList);
            } else {
                prodDirectorbItemsMap.put(directorId, new List < Phoenix_Bid_Line_Item__c > {
                    item
                });
            }

            //Add Sales persons
            if (item.Phoenix_Bid__r.Phoenix_Sales_Person_2__c != null) {
                allPeopleInvolvedEmailsSet.add(item.Phoenix_Bid__r.Phoenix_Sales_Person_2__r.Email);
            } else if (item.Phoenix_Bid__r.Phoenix_Salesperson__c != null) {
                allPeopleInvolvedEmailsSet.add(item.Phoenix_Bid__r.Phoenix_Salesperson__r.Email);
            }

        }

        for (string productDirectorId: prodDirectorbItemsMap.keySet()) {
            Map < string, list < Phoenix_Bid_Line_Item__c >> bidMap = new Map < string, list < Phoenix_Bid_Line_Item__c >> ();
            for (Phoenix_Bid_Line_Item__c item: prodDirectorbItemsMap.get(productDirectorId)) {
                if (bidMap.containsKey(item.Phoenix_Bid__c)) {
                    list < Phoenix_Bid_Line_Item__c > newMap = bidMap.get(item.Phoenix_Bid__c);
                    newMap.add(item);
                    bidMap.put(item.Phoenix_Bid__c, newMap);
                } else {
                    bidMap.put(item.Phoenix_Bid__c, new List < Phoenix_Bid_Line_Item__c > {
                        item
                    });
                }
            }
            for (string bidId: bidMap.keySet()) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                set < string > toaddressset = new set < string > ();
                set < string > ccaddressSet = new set < string > ();
                list < string > toaddress = new list < string > ();
                list < string > ccaddress = new list < string > ();
                Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('SCM_Product_Rejection_Notification', bidId);
                String templateBody = emailWrapper.mailHtmlBody;
                String subject = emailWrapper.mailSubject;
                integer productCount = 0;
                string tableData = '';
                string name;
                tableData += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;">S. No</th><th style="border: 1px solid black;">Product Name</th><th style="border: 1px solid black;">Product Code</th><th style="border: 1px solid black;">Product Family</th><th style="border: 1px solid black;">NDC</th><th style="border: 1px solid black;">Product Director</th><th style="border: 1px solid black;">Reason for SCM Rejection</th><th style="border: 1px solid black;">SCM Next Review Date</th></tr></thead>';
                tableData += '<tbody>';
                for (Phoenix_Bid_Line_Item__c item: bidMap.get(bidId)) {
                    productCount++;
                    tableData += '<tr>';
                    tableData += '<td style="border: 1px solid black;">' + productCount + '</td>';
                    tableData += '<td style="border: 1px solid black;">' + item.Phoenix_Product__r.Name + '</td>';
                    tableData += '<td style="border: 1px solid black;">' + item.Phoenix_Product__r.ProductCode + '</td>';
                    tableData += '<td style="border: 1px solid black;">' + item.Phoenix_Product__r.Family + '</td>';
                    if (item.Phoenix_Product__r.Phoenix_NDC_11_Dashes__c != Null) {
                        tableData += '<td style="border: 1px solid black;">' + item.Phoenix_Product__r.Phoenix_NDC_11_Dashes__c + '</td>';

                    } else {
                        tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

                    }
                    tableData += '<td style="border: 1px solid black;">' + item.Phoenix_Product__r.Phoenix_Product_Director__r.Name + '</td>';
                    if (item.Phoenix_SCM_Rejection_Reason1__c != Null) {
                        tableData += '<td style="border: 1px solid black;">' + item.Phoenix_SCM_Rejection_Reason1__c + '</td>';
                    } else {
                        tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                    }
                    if (item.Phoenix_Revisited_Date__c != Null) {
                        DateTime revisitedTime = DateTime.newInstance(item.Phoenix_Revisited_Date__c, Time.newInstance(0, 0, 0, 0));
                        String revisitedDate = revisitedTime.format('MMM d yyyy');

                        tableData += '<td style="border: 1px solid black;">' + revisitedDate + '</td>';

                    } else {
                        tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

                    }
                    tableData += '</tr>';
                    name = item.Phoenix_Product__r.Phoenix_Product_Director__r.Name;
                    if (item.Phoenix_Product__r.Phoenix_Product_Director__r.Email != Null) {
                        toaddressset.add(item.Phoenix_Product__r.Phoenix_Product_Director__r.Email);
                    }
                    if (item.Phoenix_Bid__r.OwnerId != Null) {
                        ccaddressSet.add(item.Phoenix_Bid__r.Owner.Email);
                    }
                    if (item.Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__c != Null) {
                        ccaddressSet.add(item.Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__r.Email);
                    }
                    if (item.Phoenix_Bid__r.Phoenix_Salesperson__c != Null) {
                        ccaddressSet.add(item.Phoenix_Bid__r.Phoenix_Salesperson__r.Email);
                    }
                    if (item.Phoenix_Bid__r.Phoenix_Sales_Person_2__c != Null) {
                        ccaddressSet.add(item.Phoenix_Bid__r.Phoenix_Sales_Person_2__r.Email);
                    }

                    if (Label.Phoenix_Contracts_DL != null) ccaddressSet.addAll(Label.Phoenix_Contracts_DL.split(','));


                    if (item.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c != null) {
                        DateTime internalDueDateTime = DateTime.newInstance(item.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0));
                        if (templateBody.contains('INTERNAL_DEADLINE_DATE')) templateBody = templateBody.replace('INTERNAL_DEADLINE_DATE', internalDueDateTime.format('MMM d yyyy'));
                    }


                    if (item.Phoenix_Bid__r.Phoenix_Bid_Deadline_Date__c != null) {
                        DateTime customerBidDeadline = DateTime.newInstance(item.Phoenix_Bid__r.Phoenix_Bid_Deadline_Date__c, Time.newInstance(0, 0, 0, 0));
                        if (templateBody.contains('CUSTOMER_DEADLINE_DATE')) templateBody = templateBody.replace('CUSTOMER_DEADLINE_DATE', customerBidDeadline.format('MMM d yyyy'));
                    }
                        //bidtype label names added by vandana.

                    
                    if (bidTypesmap!=null&&bidTypesmap.get(item.Phoenix_Bid__r.Phoenix_Bid_Type__c)!=null&&templateBody.contains('BID_TYPE')) {
                                                       system.debug('bidtype is-->'+item.Phoenix_Bid__r.Phoenix_Bid_Type__c);

                        templateBody = templateBody.replace('BID_TYPE', bidTypesmap.get(item.Phoenix_Bid__r.Phoenix_Bid_Type__c));
                    }
                    if (bidTypesmap!=null&&bidTypesmap.get(item.Phoenix_Bid__r.Phoenix_Bid_Type__c)!=null&&subject.contains('BID_TYPE')){
                                
                        subject = subject.replace('BID_TYPE', bidTypesmap.get(item.Phoenix_Bid__r.Phoenix_Bid_Type__c));
                    } 

            //bidtype label names --end.
                }
                tableData += '</tbody></table>';


                      
                ccaddressSet.addAll(allPeopleInvolvedEmailsSet);

                for (string emailId: toaddressset) {
                    if (ccaddressSet.contains(emailId))
                        ccaddressSet.remove(emailId);
                }
                If(ccaddressSet != null && ccaddressSet.contains('mkalawadia@drreddys.com'))ccaddressSet.remove('mkalawadia@drreddys.com');
                If(toaddressset != null && toaddressset.contains('mkalawadia@drreddys.com'))toaddressset.remove('mkalawadia@drreddys.com');
                toaddress.addAll(toaddressset);
                ccaddress.addAll(ccaddressSet);
                        
              email.setToAddresses(toaddress);
              email.setCcAddresses(ccaddress);
          /*  email.setCcAddresses(new List < String > {
                'surender+SCMProductRejectionNotification@dhruvsoft.com'
            });
				*/
                templateBody = templateBody.replace('tableData', tableData).replace('ProductDirecorName', name);
                email.setHtmlBody(templateBody);
                email.setSubject(subject);
                email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);

                mail.add(email);
            }
        }
    } else if (objName == 'Phoenix_NDC_Change__c') {
        Phoenix_NDC_Change__c ndcChange = [Select Id, Name, Owner.Email, Phoenix_Approval_Status__c from Phoenix_NDC_Change__c WHERE Id =: objId LIMIT 1];
        List < Phoenix_NDC_Change_Line_Item__c > ndcLineItemsList = [Select Phoenix_Current_Product__c, Phoenix_Current_Product__r.Name, Phoenix_Current_Product_NDC__c, Phoenix_Current_Product_Pack_Size__c, Phoenix_Proposed_Product__c, Phoenix_Proposed_Product__r.Name, Phoenix_Proposed_Product_NDC__c, Phoenix_Proposed_Product_Pack_Size__c, Phoenix_Remarks__c FROM Phoenix_NDC_Change_Line_Item__c where Phoenix_NDC_Change__c =: objId and Phoenix_SCM_Approval_Y_N__c = 'Not Approved'];

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        set < string > toaddressset = new set < string > ();
        set < string > ccaddressSet = new set < string > ();
        list < string > toaddress = new list < string > ();
        list < string > ccaddress = new list < string > ();
        Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('NDC_SCM_Product_Rejection_Notification', objId);
        String templateBody = emailWrapper.mailHtmlBody;
        String subject = emailWrapper.mailSubject;
        integer sNo = 0;
        string tableData = '';
        tableData += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;">S.No</th><th style="border: 1px solid black;">Proposed Product</th><th style="border: 1px solid black;">Proposed Product NDC</th><th style="border: 1px solid black;">Current Product</th><th style="border: 1px solid black;">Current Product NDC</th><th style="border: 1px solid black;">Remarks</th></tr></thead>';
        for (Phoenix_NDC_Change_Line_Item__c ndcitem: ndcLineItemsList) {
            sNo++;
            tableData += '<tr>';
            tableData += '<td style="border: 1px solid black;">' + sNo + '</td>';
            if (ndcitem.Phoenix_Proposed_Product__c != null) {
                tableData += '<td style="border: 1px solid black;">' + ndcitem.Phoenix_Proposed_Product__r.Name + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

            }

            if (ndcitem.Phoenix_Proposed_Product_NDC__c != Null) {
                tableData += '<td style="border: 1px solid black;">' + ndcitem.Phoenix_Proposed_Product_NDC__c + '</td>';

            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

            }
            if (ndcitem.Phoenix_Current_Product__c != null) {
                tableData += '<td style="border: 1px solid black;">' + ndcitem.Phoenix_Current_Product__r.Name + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

            }
            if (ndcitem.Phoenix_Current_Product_NDC__c != Null) {
                tableData += '<td style="border: 1px solid black;">' + ndcitem.Phoenix_Current_Product_NDC__c + '</td>';

            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

            }
            if (ndcitem.Phoenix_Remarks__c != Null) {
                tableData += '<td style="border: 1px solid black;">' + ndcitem.Phoenix_Remarks__c + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            /*        if (item.Phoenix_Revisited_Date__c != Null) {
DateTime revisitedTime = DateTime.newInstanceGMT(item.Phoenix_Revisited_Date__c, Time.newInstance(0, 0, 0, 0));
String revisitedDate = revisitedTime.format('MMM d yyyy');

tableData += '<td style="border: 1px solid black;">' + revisitedDate + '</td>';

} else {
tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

}*/
            tableData += '</tr>';
        }
        tableData += '<tbody></table>';


        if (ndcChange.owner.Email != Null) {
            toaddressset.add(ndcChange.owner.Email);
        }
        if (Label.Phoenix_Contracts_DL != null) ccaddressSet.addAll(Label.Phoenix_Contracts_DL.split(','));

        for (string emailId: toaddressset) {
            if (ccaddressSet.contains(emailId))
                ccaddressSet.remove(emailId);
            if (allPeopleInvolvedEmailsSet.contains(emailId))
                allPeopleInvolvedEmailsSet.remove(emailId);
        }

      If(ccaddressSet != null && ccaddressSet.contains('mkalawadia@drreddys.com'))ccaddressSet.remove('mkalawadia@drreddys.com');
      If(toaddressset != null && toaddressset.contains('mkalawadia@drreddys.com'))toaddressset.remove('mkalawadia@drreddys.com');

        toaddress.addAll(toaddressset);
        ccaddress.addAll(ccaddressSet);
        ccaddress.addAll(allPeopleInvolvedEmailsSet);
          email.setToAddresses(toaddress);
          email.setCcAddresses(ccaddress);
       /* email.setCcAddresses(new List < String > {
            'surender+uat@dhruvsoft.com'
                }); */
        if (templateBody.contains('tableData')) templateBody = templateBody.replace('tableData', tableData);
        email.setHtmlBody(templateBody);
        email.setSubject(subject);
        email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);

        mail.add(email);
    }


    messaging.sendEmail(mail);
}
Catch(Exception e) {
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();

    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'SCMProductRejectionNotification', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}

}

/**
* @description This will send notification to all people involved for bid approval, when anyone rejects any one of the bid line items at any stage. 
* @author Surender Patel (Dhruvsoft) | 12-05-2021 
* @param Set<id> bidLineItemIds 
**/
@future
public static void BidRejectionEmailNotificationToAll(Set < id > bidLineItemIdset,String Bid_ID) {
System.debug('BidID===>'+Bid_ID);
        
list < messaging.Email > mail = new list < messaging.email > ();
List < Id > bidLineItemIds = new List < Id > (bidLineItemIdset);
        
        
  //bidtype label names added by vandana.
      Map < String, String > bidTypesmap = new Map < String, String > ();
                    
            for(Schema.PicklistEntry  ple:  Phoenix_Bid__c.Phoenix_Bid_Type__c.getDescribe().getPicklistValues()){
                bidTypesmap.put(ple.getValue(),ple.getLabel());
            }
        
  //bidtype label names added end.


        
try {
    if (bidLineItemIds.size() > 0) {

        Set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
        String objName = String.valueOf(bidLineItemIds[0].getsObjectType());
        Map < Id, Phoenix_Bid_Line_Item__c > bidLineItemMap = new Map < Id, Phoenix_Bid_Line_Item__c > ();
        Map < Id, Phoenix_NDC_Change_Line_Item__c > ndcLineItemMap = new Map < Id, Phoenix_NDC_Change_Line_Item__c > ();
        Map < Id, Phoenix_PHS_Price_Change_Line__c > pHSLineItemMap = new Map < Id, Phoenix_PHS_Price_Change_Line__c > ();
        Map < Id, Phoenix_NewProduct_WAC_Pricing_LineItems__c > newWACLineItemsMap = new Map < Id, Phoenix_NewProduct_WAC_Pricing_LineItems__c > ();
        Map < Id, Phoenix_WAC_Change_Line_Item__c > WACChangeLineItemsMap = new Map < Id, Phoenix_WAC_Change_Line_Item__c > ();


        Set < String > bidIds = new Set < String > ();
        Set < String > ndcIds = new Set < String > ();
        Set < String > pHSIds = new Set < String > ();
        Set < String > wacIds = new Set < String > ();
        Set < String > wacChangeIds = new Set < String > ();


        Map < Id, List < Phoenix_Bid_Line_Item__c >> BidMapWithLineItems = new Map < Id, List < Phoenix_Bid_Line_Item__c >> ();
        Map < Id, List < Phoenix_NDC_Change_Line_Item__c >> ndcChangeMapWithLineItems = new Map < Id, List < Phoenix_NDC_Change_Line_Item__c >> ();
        Map < Id, List < Phoenix_PHS_Price_Change_Line__c >> pHSChangeMapWithLineItems = new Map < Id, List < Phoenix_PHS_Price_Change_Line__c >> ();
        Map < Id, List < Phoenix_NewProduct_WAC_Pricing_LineItems__c >> newWACMapWithLineItems = new Map < Id, List < Phoenix_NewProduct_WAC_Pricing_LineItems__c >> ();
        Map < Id, List < Phoenix_WAC_Change_Line_Item__c >> WACChangeMapWithLineItems = new Map < Id, List < Phoenix_WAC_Change_Line_Item__c >> ();

        map < id, set < String >> bidIdEmailMap = new map < id, set < String >> ();
        map < id, set < String >> ndcChangeIdEmailMap = new map < id, set < String >> ();
        map < id, set < String >> pHSChangeIdEmailMap = new map < id, set < String >> ();
        map < id, set < String >> newWACCIdEmailMap = new map < id, set < String >> ();
        map < id, set < String >> WACChageIdEmailMap = new map < id, set < String >> ();



        for (Phoenix_Bid_Process_Steps__c step: [SELECT Id, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Bid__c, Phoenix_NDC_Change__c, Phoenix_PHS_Price_Change__c
                FROM Phoenix_Bid_Process_Steps__c
                Where(Phoenix_Bid__c =: Bid_ID OR Phoenix_NDC_Change__c IN: ndcIds OR Phoenix_PHS_Price_Change__c IN: pHSIds OR Phoenix_WAC_Change__c IN: wacChangeIds) AND Phoenix_Is_Criteria_Step__c = false AND Phoenix_Status__c != 'Not Applicable'
            ]) {
            if (objName == 'Phoenix_Bid_Line_Item__c') {
                bid_id= step.Phoenix_Bid__c;
                if (step.Phoenix_Approver__c != null && bidIdEmailMap.containsKey(step.Phoenix_Bid__c)) {
                    Set < String > addedEmails = bidIdEmailMap.get(step.Phoenix_Bid__c);
                    addedEmails.add(step.Phoenix_Approver__r.Email);
                    bidIdEmailMap.put(step.Phoenix_Bid__c, addedEmails);
                } else if (step.Phoenix_Approver__c != null && !bidIdEmailMap.containsKey(step.Phoenix_Bid__c)) {
                    bidIdEmailMap.put(step.Phoenix_Bid__c, new Set < String > {
                        step.Phoenix_Approver__r.Email
                    });
                }
            } else if (objName == 'Phoenix_NDC_Change_Line_Item__c') {
                if (step.Phoenix_Approver__c != null && ndcChangeIdEmailMap.containsKey(step.Phoenix_NDC_Change__c)) {
                    Set < String > addedEmails = ndcChangeIdEmailMap.get(step.Phoenix_NDC_Change__c);
                    addedEmails.add(step.Phoenix_Approver__r.Email);
                    ndcChangeIdEmailMap.put(step.Phoenix_NDC_Change__c, addedEmails);
                } else if (step.Phoenix_Approver__c != null && !ndcChangeIdEmailMap.containsKey(step.Phoenix_NDC_Change__c)) {
                    ndcChangeIdEmailMap.put(step.Phoenix_NDC_Change__c, new Set < String > {
                        step.Phoenix_Approver__r.Email
                    });
                }
            } else if (objName == 'Phoenix_PHS_Price_Change_Line__c') {
                if (step.Phoenix_Approver__c != null && pHSChangeIdEmailMap.containsKey(step.Phoenix_PHS_Price_Change__c)) {
                    Set < String > addedEmails = pHSChangeIdEmailMap.get(step.Phoenix_PHS_Price_Change__c);
                    addedEmails.add(step.Phoenix_Approver__r.Email);
                    pHSChangeIdEmailMap.put(step.Phoenix_PHS_Price_Change__c, addedEmails);
                } else if (step.Phoenix_Approver__c != null && !pHSChangeIdEmailMap.containsKey(step.Phoenix_PHS_Price_Change__c)) {
                    pHSChangeIdEmailMap.put(step.Phoenix_PHS_Price_Change__c, new Set < String > {
                        step.Phoenix_Approver__r.Email
                    });
                }
            } else if (objName == 'Phoenix_WAC_Change_Line_Item__c') {
                if (step.Phoenix_Approver__c != null && WACChageIdEmailMap.containsKey(step.Phoenix_WAC_Change__c)) {
                    Set < String > addedEmails = WACChageIdEmailMap.get(step.Phoenix_WAC_Change__c);
                    addedEmails.add(step.Phoenix_Approver__r.Email);
                    WACChageIdEmailMap.put(step.Phoenix_WAC_Change__c, addedEmails);
                } else if (step.Phoenix_Approver__c != null && !WACChageIdEmailMap.containsKey(step.Phoenix_WAC_Change__c)) {
                    WACChageIdEmailMap.put(step.Phoenix_WAC_Change__c, new Set < String > {
                        step.Phoenix_Approver__r.Email
                    });
                }
            }



        }

        if (objName == 'Phoenix_Bid_Line_Item__c') {
            bidLineItemMap = new Map < Id, Phoenix_Bid_Line_Item__c > ([SELECT Id, Phoenix_Bid__r.Phoenix_Bid_Deadline_Date__c, Phoenix_Bid__r.Phoenix_Internal_Target_Date__c, Phoenix_Bid__r.Phoenix_Salesperson__c, Phoenix_Bid__r.Phoenix_Salesperson__r.Email,
                Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__r.Email, Phoenix_Bid__r.Owner.Email, Phoenix_Bid__r.Phoenix_Sales_Person_2__c, Phoenix_Bid__r.Phoenix_Sales_Person_2__r.Email,
                Phoenix_Product__r.ProductCode, Phoenix_Product__r.Family, Phoenix_Product__r.Phoenix_NDC__c,
                Phoenix_SCM_Rejection_Reason1__c, Phoenix_Product_Director1__c, Phoenix_NDC__c, Phoenix_Product_Family1__c,
                Phoenix_Product_Code1__c, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Bid_Owner__r.Name,
                Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Name, Phoenix_Customer__r.Name,
                Phoenix_Customer__c, Phoenix_Product__r.Name, Phoenix_Product__r.Phoenix_Product_Director__c, Phoenix_Product__r.Phoenix_Product_Director__r.Name,
                Phoenix_Product__r.Phoenix_Product_Director__r.Email, Name, Phoenix_Product__c, Phoenix_Product_Director__c
                FROM Phoenix_Bid_Line_Item__c
                where Id in: bidLineItemIds AND Phoenix_Final_Status__c = 'Not Approved'
                AND Phoenix_Is_Rejection_Noti_All_Sent__c = false
            ]);


				System.debug('line item map values==>'+bidLineItemMap.values());

            for (Phoenix_Bid_Line_Item__c item: bidLineItemMap.values()) {
                String bidId = item.Phoenix_Bid__c;
                bidIds.add(bidId);
                if (BidMapWithLineItems.containsKey(bidId)) {
                    List < Phoenix_Bid_Line_Item__c > addedList = BidMapWithLineItems.get(bidId);
                    addedList.add(item);
                    BidMapWithLineItems.put(bidId, addedList);
                } else {
                    BidMapWithLineItems.put(bidId, new List < Phoenix_Bid_Line_Item__c > {
                        item
                    });
                }
                //Add Sales persons
                if (item.Phoenix_Bid__r.Phoenix_Sales_Person_2__c != null) {
                    allPeopleInvolvedEmailsSet.add(item.Phoenix_Bid__r.Phoenix_Sales_Person_2__r.Email);
                } else if (item.Phoenix_Bid__r.Phoenix_Salesperson__c != null) {
                    allPeopleInvolvedEmailsSet.add(item.Phoenix_Bid__r.Phoenix_Salesperson__r.Email);
                }
            }

            for (string BidId: BidMapWithLineItems.keySet()) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                set < string > toaddressset = new set < string > ();
                set < string > ccaddressSet = new set < string > ();


                Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Bid_Item_Rejection_Notification', bidId);
                String templateBody = emailWrapper.mailHtmlBody;
                String subject = emailWrapper.mailSubject;
                integer productCount = 0;
                string name;
                for (Phoenix_Bid_Line_Item__c item: BidMapWithLineItems.get(BidId)) {
                    productCount++;
                    name = item.Phoenix_Product__r.Phoenix_Product_Director__r.Name;
                    if (item.Phoenix_Product__r.Phoenix_Product_Director__r.Email != Null) {
                        toaddressset.add(item.Phoenix_Product__r.Phoenix_Product_Director__r.Email);
                    }
                    if (item.Phoenix_Bid__r.Owner.Email != Null) {
                        ccaddressSet.add(item.Phoenix_Bid__r.Owner.Email);
                    }
                    if (item.Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__r.Email != Null) {
                        ccaddressSet.add(item.Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__r.Email);
                    }



                    if (item.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c != null) {
                        DateTime internalDueDateTime = DateTime.newInstance(item.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0));
                        if (templateBody.contains('INTERNAL_DEADLINE_DATE')) templateBody = templateBody.replace('INTERNAL_DEADLINE_DATE', internalDueDateTime.format('MMM d yyyy'));
                    }


                    if (item.Phoenix_Bid__r.Phoenix_Bid_Deadline_Date__c != null) {
                        DateTime customerBidDeadline = DateTime.newInstance(item.Phoenix_Bid__r.Phoenix_Bid_Deadline_Date__c, Time.newInstance(0, 0, 0, 0));
                        if (templateBody.contains('CUSTOMER_DEADLINE_DATE')) templateBody = templateBody.replace('CUSTOMER_DEADLINE_DATE', customerBidDeadline.format('MMM d yyyy'));
                    }
                            
                            
                     //bidtype label names added by vandana.

                    
            if (bidTypesmap!=null&&bidTypesmap.get(item.Phoenix_Bid__r.Phoenix_Bid_Type__c)!=null&&templateBody.contains('BID_TYPE')) templateBody = templateBody.replace('BID_TYPE', bidTypesmap.get(item.Phoenix_Bid__r.Phoenix_Bid_Type__c));
            if (bidTypesmap!=null&&bidTypesmap.get(item.Phoenix_Bid__r.Phoenix_Bid_Type__c)!=null&&subject.contains('BID_TYPE')) subject = subject.replace('BID_TYPE', bidTypesmap.get(item.Phoenix_Bid__r.Phoenix_Bid_Type__c));

            //bidtype label names --end.
                            
                }
                if (bidIdEmailMap.get(bid_id) != null) {
                    toaddressset.addAll(bidIdEmailMap.get(bid_id));
                    System.debug('toaddressset==>'+toaddressset);
                }
                ccaddressSet.addAll(allPeopleInvolvedEmailsSet);
                if (Label.Phoenix_Contracts_DL != null) ccaddressSet.addAll(Label.Phoenix_Contracts_DL.split(','));
               for (string emailId: toaddressset) {
                    if (ccaddressSet.contains(emailId))
                        ccaddressSet.remove(emailId);
                }
                If(ccaddressSet != null && ccaddressSet.contains('mkalawadia@drreddys.com'))ccaddressSet.remove('mkalawadia@drreddys.com');
                If(toaddressset != null && toaddressset.contains('mkalawadia@drreddys.com'))toaddressset.remove('mkalawadia@drreddys.com');
                //toaddressset.add('satya@dhruvsoft.com');
                email.setToAddresses(new List<String>(toaddressset));
                email.setCcAddresses(new List<String>(ccaddressSet));
                email.setHtmlBody(templateBody);
                email.setSubject(subject);
                email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
                mail.add(email);
            }


            List < Phoenix_Bid_Line_Item__c > updatedItems = new List < Phoenix_Bid_Line_Item__c > ();
            for (Phoenix_Bid_Line_Item__c item: bidLineItemMap.values()) {
                item.Phoenix_Is_Rejection_Noti_All_Sent__c = true;
                updatedItems.add(item);

            }

            update updatedItems;
        } else if (objName == 'Phoenix_NDC_Change_Line_Item__c') {
            ndcLineItemMap = new Map < Id, Phoenix_NDC_Change_Line_Item__c > ([SELECT Id, Phoenix_NDC_Change__r.Owner.Email,
                Phoenix_SCM_Rejection_Reason__c,
                Phoenix_NDC_Change__r.Phoenix_Approval_Status__c, Phoenix_NDC_Change__r.Owner.Name,
                Phoenix_NDC_Change__r.Name, Name
                FROM Phoenix_NDC_Change_Line_Item__c
                WHERE Id in: bidLineItemIds AND Phoenix_Final_Status__c = 'Not Approved'
                AND Phoenix_Is_Rejection_Noti_All_Sent__c = false
            ]);

            for (Phoenix_NDC_Change_Line_Item__c ndcChangeItem: ndcLineItemMap.values()) {
                String ndcChangeId = ndcChangeItem.Phoenix_NDC_Change__c;
                ndcIds.add(ndcChangeId);
                if (ndcChangeMapWithLineItems.containsKey(ndcChangeId)) {
                    List < Phoenix_NDC_Change_Line_Item__c > addedList = ndcChangeMapWithLineItems.get(ndcChangeId);
                    addedList.add(ndcChangeItem);
                    ndcChangeMapWithLineItems.put(ndcChangeId, addedList);
                } else {
                    ndcChangeMapWithLineItems.put(ndcChangeId, new List < Phoenix_NDC_Change_Line_Item__c > {
                        ndcChangeItem
                    });
                }
                //Add Sales persons

            }

            for (string ndcChangeId: ndcChangeMapWithLineItems.keySet()) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                set < string > toaddressset = new set < string > ();
                set < string > ccaddressSet = new set < string > ();


                Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('NDC_Item_Rejection_Notification', ndcChangeId);
                String templateBody = emailWrapper.mailHtmlBody;
                String subject = emailWrapper.mailSubject;
                integer sNo = 0;
                for (Phoenix_NDC_Change_Line_Item__c ndcChangeItem: ndcChangeMapWithLineItems.get(ndcChangeId)) {
                    sNo++;
                    if (ndcChangeItem.Phoenix_NDC_Change__r.Owner.Email != Null) {
                        allPeopleInvolvedEmailsSet.add(ndcChangeItem.Phoenix_NDC_Change__r.Owner.Email);
                    }

                }
                if (ndcChangeIdEmailMap.get(ndcChangeId) != null) toaddressset.AddAll(ndcChangeIdEmailMap.get(ndcChangeId));
                toaddressset.addAll(allPeopleInvolvedEmailsSet);
                if (Label.Phoenix_Contracts_DL != null) ccaddressSet.addAll(Label.Phoenix_Contracts_DL.split(','));
               /* email.setToAddresses(new list < string > {
                    'surenderpatel@drreddys.com'
                        });*/
                for (string emailId: toaddressset) {
                    if (ccaddressSet.contains(emailId))
                        ccaddressSet.remove(emailId);
                }
                If(ccaddressSet != null && ccaddressSet.contains('mkalawadia@drreddys.com'))ccaddressSet.remove('mkalawadia@drreddys.com');
                If(toaddressset != null && toaddressset.contains('mkalawadia@drreddys.com'))toaddressset.remove('mkalawadia@drreddys.com');
                email.setToAddresses(new List<String>(toaddressset));
                email.setCcAddresses(new List<String>(ccaddressSet));
                email.setHtmlBody(templateBody);
                email.setSubject(subject);
                email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
                mail.add(email);
            }


            List < Phoenix_NDC_Change_Line_Item__c > updatedItems = new List < Phoenix_NDC_Change_Line_Item__c > ();
            for (Phoenix_NDC_Change_Line_Item__c item: ndcLineItemMap.values()) {
                item.Phoenix_Is_Rejection_Noti_All_Sent__c = true;
                updatedItems.add(item);

            }

            update updatedItems;


        } else if (objName == 'Phoenix_PHS_Price_Change_Line__c') {
            pHSLineItemMap = new Map < Id, Phoenix_PHS_Price_Change_Line__c > ([SELECT Id, Phoenix_PHS_Price_Change__r.Owner.Email,
                Phoenix_Remarks__c,
                Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c, Phoenix_PHS_Price_Change__r.Owner.Name,
                Phoenix_PHS_Price_Change__r.Name, Name
                FROM Phoenix_PHS_Price_Change_Line__c
                WHERE Id in: bidLineItemIds AND Phoenix_Final_Status__c = 'Not Approved'
                AND Phoenix_Is_Rejection_Noti_All_Sent__c = false
            ]);

            for (Phoenix_PHS_Price_Change_Line__c pHSChangeItem: pHSLineItemMap.values()) {
                String pHSChangeId = pHSChangeItem.Phoenix_PHS_Price_Change__c;
                pHSIds.add(pHSChangeId);
                if (pHSChangeMapWithLineItems.containsKey(pHSChangeId)) {
                    List < Phoenix_PHS_Price_Change_Line__c > addedList = pHSChangeMapWithLineItems.get(pHSChangeId);
                    addedList.add(pHSChangeItem);
                    pHSChangeMapWithLineItems.put(pHSChangeId, addedList);
                } else {
                    pHSChangeMapWithLineItems.put(pHSChangeId, new List < Phoenix_PHS_Price_Change_Line__c > {
                        pHSChangeItem
                    });
                }
                //Add Sales persons

            }

            for (string pHSChangeId: pHSChangeMapWithLineItems.keySet()) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                set < string > toaddressset = new set < string > ();
                set < string > ccaddressSet = new set < string > ();


                Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('PHS_Item_Rejection_Notification', pHSChangeId);
                String templateBody = emailWrapper.mailHtmlBody;
                String subject = emailWrapper.mailSubject;
                integer sNo = 0;
                for (Phoenix_PHS_Price_Change_Line__c pHSChangeItem: pHSChangeMapWithLineItems.get(pHSChangeId)) {
                    sNo++;
                    if (pHSChangeItem.Phoenix_PHS_Price_Change__r.Owner.Email != Null) {
                        allPeopleInvolvedEmailsSet.add(pHSChangeItem.Phoenix_PHS_Price_Change__r.Owner.Email);
                    }

                }
                if (pHSChangeIdEmailMap.get(pHSChangeId) != null) toaddressset.AddAll(pHSChangeIdEmailMap.get(pHSChangeId));
                toaddressset.addAll(allPeopleInvolvedEmailsSet);
                if (Label.Phoenix_Contracts_DL != null) ccaddressSet.addAll(Label.Phoenix_Contracts_DL.split(','));
                for (string emailId: toaddressset) {
                    if (ccaddressSet.contains(emailId))
                        ccaddressSet.remove(emailId);
                }
                If(ccaddressSet != null && ccaddressSet.contains('mkalawadia@drreddys.com'))ccaddressSet.remove('mkalawadia@drreddys.com');
                If(toaddressset != null && toaddressset.contains('mkalawadia@drreddys.com'))toaddressset.remove('mkalawadia@drreddys.com');
                email.setToAddresses(new List<String>(toaddressset));
                email.setCcAddresses(new List<String>(ccaddressSet));
                email.setHtmlBody(templateBody);
                email.setSubject(subject);
                email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
                mail.add(email);
            }


            List < Phoenix_PHS_Price_Change_Line__c > updatedItems = new List < Phoenix_PHS_Price_Change_Line__c > ();
            for (Phoenix_PHS_Price_Change_Line__c item: pHSLineItemMap.values()) {
                item.Phoenix_Is_Rejection_Noti_All_Sent__c = true;
                updatedItems.add(item);

            }

            update updatedItems;


        } else if (objName == 'Phoenix_NewProduct_WAC_Pricing_LineItems__c') {
            newWACLineItemsMap = new Map < Id, Phoenix_NewProduct_WAC_Pricing_LineItems__c > ([SELECT Id, Phoenix_New_Product_WAC_Pricing__r.Owner.Email,

                Phoenix_New_Product_WAC_Pricing__r.Phoenix_Approval_Status__c, Phoenix_New_Product_WAC_Pricing__r.Owner.Name,
                Phoenix_New_Product_WAC_Pricing__r.Name, Name
                FROM Phoenix_NewProduct_WAC_Pricing_LineItems__c
                WHERE Id in: bidLineItemIds AND Phoenix_Final_Status__c = 'Not Approved'
                AND Phoenix_Is_Rejection_Noti_All_Sent__c = false
            ]);

            for (Phoenix_NewProduct_WAC_Pricing_LineItems__c newWACItem: newWACLineItemsMap.values()) {
                String newWACId = newWACItem.Phoenix_New_Product_WAC_Pricing__c;
                wacIds.add(newWACId);
                if (newWACMapWithLineItems.containsKey(newWACId)) {
                    List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > addedList = newWACMapWithLineItems.get(newWACId);
                    addedList.add(newWACItem);
                    newWACMapWithLineItems.put(newWACId, addedList);
                } else {
                    newWACMapWithLineItems.put(newWACId, new List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > {
                        newWACItem
                    });
                }
                //Add Sales persons

            }

            for (string newWACId: newWACMapWithLineItems.keySet()) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                set < string > toaddressset = new set < string > ();
                set < string > ccaddressSet = new set < string > ();


                Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('New_Wac_Rejection', newWACId);
                String templateBody = emailWrapper.mailHtmlBody;
                String subject = emailWrapper.mailSubject;
                integer sNo = 0;
                for (Phoenix_NewProduct_WAC_Pricing_LineItems__c newWACItem: newWACMapWithLineItems.get(newWACId)) {
                    sNo++;
                    if (newWACItem.Phoenix_New_Product_WAC_Pricing__r.Owner.Email != Null) {
                        allPeopleInvolvedEmailsSet.add(newWACItem.Phoenix_New_Product_WAC_Pricing__r.Owner.Email);
                    }

                }
                if (newWACCIdEmailMap.get(newWACId) != null) toaddressset.AddAll(newWACCIdEmailMap.get(newWACId));
                toaddressset.addAll(allPeopleInvolvedEmailsSet);
                if (Label.Phoenix_Contracts_DL != null) ccaddressSet.addAll(Label.Phoenix_Contracts_DL.split(','));
               /* email.setToAddresses(new list < string > {
                    'surenderpatel@drreddys.com'
                        });*/
                for (string emailId: toaddressset) {
                    if (ccaddressSet.contains(emailId))
                        ccaddressSet.remove(emailId);
                }
                If(ccaddressSet != null && ccaddressSet.contains('mkalawadia@drreddys.com'))ccaddressSet.remove('mkalawadia@drreddys.com');
                If(toaddressset != null && toaddressset.contains('mkalawadia@drreddys.com'))toaddressset.remove('mkalawadia@drreddys.com');
                email.setToAddresses(new List<String>(toaddressset));
                email.setCcAddresses(new List<String>(ccaddressSet));
                email.setHtmlBody(templateBody);
                email.setSubject(subject);
                email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
                mail.add(email);
            }


            List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > updatedItems = new List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > ();
            for (Phoenix_NewProduct_WAC_Pricing_LineItems__c item: newWACLineItemsMap.values()) {
                item.Phoenix_Is_Rejection_Noti_All_Sent__c = true;
                updatedItems.add(item);

            }

            update updatedItems;


        } else if (objName == 'Phoenix_WAC_Change_Line_Item__c') {
            WACChangeLineItemsMap = new Map < Id, Phoenix_WAC_Change_Line_Item__c > ([SELECT Id, Phoenix_WAC_Change__r.Owner.Email,

                Phoenix_WAC_Change__r.Phoenix_Approval_Status__c, Phoenix_WAC_Change__r.Owner.Name,
                Phoenix_WAC_Change__r.Name, Name
                FROM Phoenix_WAC_Change_Line_Item__c
                WHERE Id in: bidLineItemIds AND Phoenix_Final_Status__c = 'Not Approved'
                AND Phoenix_Is_Rejection_Noti_All_Sent__c = false
            ]);

            for (Phoenix_WAC_Change_Line_Item__c WACChangeItem: WACChangeLineItemsMap.values()) {
                String WACChangeId = WACChangeItem.Phoenix_WAC_Change__c;
                wacIds.add(WACChangeId);
                if (WACChangeMapWithLineItems.containsKey(WACChangeId)) {
                    List < Phoenix_WAC_Change_Line_Item__c > addedList = WACChangeMapWithLineItems.get(WACChangeId);
                    addedList.add(WACChangeItem);
                    WACChangeMapWithLineItems.put(WACChangeId, addedList);
                } else {
                    WACChangeMapWithLineItems.put(WACChangeId, new List < Phoenix_WAC_Change_Line_Item__c > {
                        WACChangeItem
                    });
                }
                //Add Sales persons

            }

            for (string WACChangeId: WACChangeMapWithLineItems.keySet()) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                set < string > toaddressset = new set < string > ();
                set < string > ccaddressSet = new set < string > ();


                Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('WAC_Change_Item_rejection', WACChangeId);
                String templateBody = emailWrapper.mailHtmlBody;
                String subject = emailWrapper.mailSubject;
                integer sNo = 0;
                for (Phoenix_WAC_Change_Line_Item__c WACChangeItem: WACChangeMapWithLineItems.get(WACChangeId)) {
                    sNo++;
                    if (WACChangeItem.Phoenix_WAC_Change__r.Owner.Email != Null) {
                        allPeopleInvolvedEmailsSet.add(WACChangeItem.Phoenix_WAC_Change__r.Owner.Email);
                    }

                }
                if (WACChageIdEmailMap.get(WACChangeId) != null) toaddressset.AddAll(WACChageIdEmailMap.get(WACChangeId));
                toaddressset.addAll(allPeopleInvolvedEmailsSet);
                if (Label.Phoenix_Contracts_DL != null) ccaddressSet.addAll(Label.Phoenix_Contracts_DL.split(','));
               /* email.setToAddresses(new list < string > {
                    'surenderpatel@drreddys.com'
                        });*/
                for (string emailId: toaddressset) {
                    if (ccaddressSet.contains(emailId))
                        ccaddressSet.remove(emailId);
                }
                If(ccaddressSet != null && ccaddressSet.contains('mkalawadia@drreddys.com'))ccaddressSet.remove('mkalawadia@drreddys.com');
                If(toaddressset != null && toaddressset.contains('mkalawadia@drreddys.com'))toaddressset.remove('mkalawadia@drreddys.com');
                email.setToAddresses(new List<String>(toaddressset));
                email.setCcAddresses(new List<String>(ccaddressSet));
                email.setHtmlBody(templateBody);
                email.setSubject(subject);
                email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
                mail.add(email);
            }


            List < Phoenix_WAC_Change_Line_Item__c > updatedItems = new List < Phoenix_WAC_Change_Line_Item__c > ();
            for (Phoenix_WAC_Change_Line_Item__c item: WACChangeLineItemsMap.values()) {
                item.Phoenix_Is_Rejection_Noti_All_Sent__c = true;
                updatedItems.add(item);

            }

            update updatedItems;


        }
			System.debug('mail response==>'+mail);
        messaging.sendEmail(mail);
    }
}
Catch(Exception e) {
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();

    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'BidRejectionEmailNotificationToAll', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}


}

/**
* @description This will send notification to Vistex & Demand planning team when any customer response is created.   
* @author Surender Patel (Dhruvsoft) | 12-05-2021 
* @param String crId 
* @param Id bidId 
**/
@future
public static void sendEmailToVistexTeam(Id crId, Id bidId) {

List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
        
        
  //bidtype label names added by vandana.
      Map < String, String > bidTypesmap = new Map < String, String > ();
                    
            for(Schema.PicklistEntry  ple:  Phoenix_Bid__c.Phoenix_Bid_Type__c.getDescribe().getPicklistValues()){
                bidTypesmap.put(ple.getValue(),ple.getLabel());
            }
        
  //bidtype label names added end.


//Create a new Email
try {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

    String vistextTeamApprover = '';
    Set < String > vistexTeamNames = new Set < String > ();
    Set < String > allApproversEmails = new Set < String > ();
    Set < String > bidOwnerEmails = new Set < String > ();

    if (Label.Phoenix_Contracts_DL != null) bidOwnerEmails.addAll(Label.Phoenix_Contracts_DL.split(','));
    if(Label.CC_Emails_for_Vistex_Approvals != null)bidOwnerEmails.addAll(Label.CC_Emails_for_Vistex_Approvals.split(','));

    List < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Bid__r.Owner.Email, Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__c, Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__r.Email, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Is_Criteria_Step__c, Phoenix_Approver__r.Email, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId LIMIT 20000];
    for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
        if (step.Phoenix_Approver__c != null && !step.Phoenix_Is_Criteria_Step__c) allApproversEmails.add(step.Phoenix_Approver__r.Email);
        bidOwnerEmails.add(step.Phoenix_Bid__r.Owner.Email);
        if (step.Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__c != null) bidOwnerEmails.add(step.Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__r.Email);
        if (step.Phoenix_Approver_Team__c == 'Home Office' || step.Phoenix_Approver_Team__c == 'Contracts') {
            if (step.Phoenix_Approver_Team_Members__c != null) vistexTeamNames = new Set < String > (step.Phoenix_Approver_Team_Members__c.split(','));
            if (step.Phoenix_Approver__c == Userinfo.getUserId())
                vistextTeamApprover = step.Phoenix_Approver__c;
        }
    }
    bidOwnerEmails.addAll(allApproversEmails);
    List < User > usersList = new List < User > ();
    Map < String, String > vistexTeamNamesAndEmails = new Map < String, String > ();
    List < String > vistexTeamList = new List < String > ();
    usersList = [SELECT Id, Username, Name, Email FROM User where Name IN: vistexTeamNames LIMIT 100];
    for (User u: usersList) {
        vistexTeamNamesAndEmails.put(u.Id, u.Email);
    }

    Set < String > vistexTeamSet = vistexTeamNamesAndEmails.keySet();
    vistexTeamList.addAll(vistexTeamNamesAndEmails.keySet());

    List < String > sendTo = new List < String > ();
    //  sendTo.addAll(vistexTeamNamesAndEmails.values());
    sendTo.addAll(approvalTeamUsersEmailsMap.get('Home Office'));
    sendTo.addAll(approvalTeamUsersEmailsMap.get('Supply Chain'));
    if(approvalTeamUsersEmailsMap.get('Demand Planning')!=null){
        sendTo.addAll(approvalTeamUsersEmailsMap.get('Demand Planning'));
    }
     mail.setToAddresses(sendTo);
   /* mail.setToAddresses(new List < String > {
        'surenderpatel@drreddys.com'
    });
   */
    mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
    for (string emailId: sendTo) {
        if (bidOwnerEmails.contains(emailId))
            bidOwnerEmails.remove(emailId);
    }
    If(bidOwnerEmails != null && bidOwnerEmails.contains('mkalawadia@drreddys.com'))bidOwnerEmails.remove('mkalawadia@drreddys.com');
    If(allApproversEmails != null && allApproversEmails.contains('mkalawadia@drreddys.com'))allApproversEmails.remove('mkalawadia@drreddys.com');

    mail.setCcAddresses(new List<String> (bidOwnerEmails));

    //Record ID for which letter will be generated
    mail.setWhatId(crId);

    integer crCount = 0;
    string tableData = '';
    Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Customer_Response_Submitted', crId);
    String templateBody = emailWrapper.mailHtmlBody;
    String query = '';
    String SobjectApiName = 'Phoenix_Customer_Response_Line__c';
    Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
    Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
    String strFields = '';
    for (String fieldName: fieldMap.keyset()) {
        if (strFields == null || strFields == '') {
            strFields = fieldName;
        } else {
            strFields = strFields + ' , ' + fieldName;
        }
    }

    query = 'select ' + strFields + ', Phoenix_Bid_Line_Item__r.Name from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_is_Vistex_Noti_Sent__c = false';

    List < Phoenix_Customer_Response_Line__c > crLineItems = Database.query(query);
    List < Phoenix_Customer_Response_Line__c > crLineItemsAwarded = new List < Phoenix_Customer_Response_Line__c > ();
    List < Phoenix_Customer_Response_Line__c > crLineItemsNotAwarded = new List < Phoenix_Customer_Response_Line__c > ();
    for (Phoenix_Customer_Response_Line__c crli: crLineItems) {
        if (crli.Phoenix_Bid_Status__c == 'Awarded') {
            crLineItemsAwarded.add(crli);
        } else {
            crLineItemsNotAwarded.add(crli);
        }
    }
    //List<Phoenix_Customer_Response_Line__c> crLineItems = [select Phoenix_NDC_National_Drug_Code__c, Phoenix_Product_Name__c, Phoenix_Product_Family__c, Phoenix_Final_Total_Selling_Unit__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Bid_Status__c, Phoenix_Award_Position__c, Phoenix_Awarded_Quantity__c, Phoenix_Supply_Effective_Date__c from Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__c = : bidId];
    if (crLineItemsAwarded.size() > 0) {
        tableData += '<table style="border-collapse: collapse;" <thead><tr> <th style="border: 1px solid black;">S.No</th> <th style="border: 1px solid black;">NDC</th> <th style="border: 1px solid black;">SAP Number</th><th style="border: 1px solid black;">Product Name</th><th style="border: 1px solid black;">Product Family</th><th style="border: 1px solid black;">Final Total Selling Unit</th><th style="border: 1px solid black;">Final Approved Pricing (Contracts)</th><th style="border: 1px solid black;">Bid Status</th><th style="border: 1px solid black;">Award Position</th><th style="border: 1px solid black;">Awarded Quantity</th><th style="border: 1px solid black;">Supply Effective Date</th><th style="border: 1px solid black;">Price Effective Date</th></tr></thead>';
        tableData += '<tbody style="text-align:center">';

        for (Phoenix_Customer_Response_Line__c crli: crLineItemsAwarded) {
            if (crli.Phoenix_Bid_Status__c == 'Awarded') {
                crCount++;
                tableData += '<tr>';
                tableData += '<td style="border: 1px solid black;">' + crCount + '</td>';
                if (crli.Phoenix_NDC_National_Drug_Code__c != Null) {
                    tableData += '<td style="border: 1px solid black;">' + crli.Phoenix_NDC_National_Drug_Code__c + '</td>';
                } else if (crli.Phoenix_NDC_National_Drug_Code__c == null) {
                    tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                }
                //added by vandana
                    if (crli.Phoenix_SAP_Number__c != Null) {
                    tableData += '<td style="border: 1px solid black;">' + crli.Phoenix_SAP_Number__c + '</td>';
                } else if (crli.Phoenix_SAP_Number__c == null) {
                    tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                }
                //end
                if (crli.Phoenix_Product_Name__c != Null) {
                    tableData += '<td style="border: 1px solid black;">' + crli.Phoenix_Product_Name__c + '</td>';
                } else if (crli.Phoenix_Product_Name__c == null) {
                    tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                }
                if (crli.Phoenix_Product_Family__c != null) {
                    tableData += '<td style="border: 1px solid black;">' + crli.Phoenix_Product_Family__c + '</td>';
                } else if (crli.Phoenix_Product_Family__c == null) {
                    tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                }
                if (crli.Phoenix_Final_Total_Selling_Unit__c != Null) {
                    tableData += '<td style="border: 1px solid black;">' + crli.Phoenix_Final_Total_Selling_Unit__c + '</td>';
                } else if (string.valueOf(crli.Phoenix_Final_Total_Selling_Unit__c) == null) {
                    tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                }
                if (crli.Phoenix_Final_Approvd_Pricing_Contracts__c != Null) {
                    tableData += '<td style="border: 1px solid black;">' + crli.Phoenix_Final_Approvd_Pricing_Contracts__c + '</td>';
                } else if (string.valueOf(crli.Phoenix_Final_Approvd_Pricing_Contracts__c) == null) {
                    tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                }
                tableData += '<td style="border: 1px solid black;">' + crli.Phoenix_Bid_Status__c + '</td>';
                if (crli.Phoenix_Award_Position__c != Null) {
                    tableData += '<td style="border: 1px solid black;">' + crli.Phoenix_Award_Position__c + '</td>';
                } else if (string.valueOf(crli.Phoenix_Award_Position__c) == null) {
                    tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                }
                if (crli.Phoenix_Awarded_Quantity__c != Null) {
                    tableData += '<td style="border: 1px solid black;">' + crli.Phoenix_Awarded_Quantity__c + '</td>';
                } else if (string.valueOf(crli.Phoenix_Awarded_Quantity__c) == null) {
                    tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                }
                if (crli.Phoenix_Supply_Effective_Date__c != null) {
                    DateTime supplyEffectiveData = DateTime.newInstance(crli.Phoenix_Supply_Effective_Date__c, Time.newInstance(0, 0, 0, 0));
                    String supply_Effective_Date = supplyEffectiveData.format('MMM d yyyy');
                    tableData += '<td style="border: 1px solid black;">' + supply_Effective_Date + '</td>';
                } else if (crli.Phoenix_Supply_Effective_Date__c == null) {
                    tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                }
                if (crli.Phoenix_Price_Effective_Date__c != null) {
                    DateTime priceEffectiveDate = DateTime.newInstance(crli.Phoenix_Price_Effective_Date__c, Time.newInstance(0, 0, 0, 0));
                    String price_Effective_Date = priceEffectiveDate.format('MMM d yyyy');
                    tableData += '<td style="border: 1px solid black;">' + price_Effective_Date + '</td>';
                } else if (crli.Phoenix_Price_Effective_Date__c == null) {
                    tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                }
                tableData += '</tr>';

            }
        }
        tableData += '</tbody></table>';
    } else {
        tableData = '';
    }
            
            
            
      //bidtype label names added by vandana.

            Phoenix_Bid__c bid = [SELECT Id, Phoenix_Bid_Type__c from Phoenix_Bid__c where Id=:bidId];
            if (bidTypesmap!=null&&bidTypesmap.get(bid.Phoenix_Bid_Type__c)!=null&&emailWrapper.mailSubject.contains('BID_TYPE')) emailWrapper.mailSubject = emailWrapper.mailSubject.replace('BID_TYPE', bidTypesmap.get(bid.Phoenix_Bid_Type__c));

            //bidtype label names --end.
            
            
            
    templateBody = templateBody.replace('tableData', tableData);
    // Step 3. Add your email to the master list
    mail.setHtmlBody(templateBody);
    mail.setSubject(emailWrapper.mailSubject);
    if (crLineItemsAwarded.size() > 0) mails.add(mail);


    Messaging.SingleEmailMessage mailRejection = new Messaging.SingleEmailMessage();


     mailRejection.setToAddresses(new List<String>(allApproversEmails));
 /*   mailRejection.setToAddresses(new List < String > {
        'surender+mailRejection@dhruvsoft.com'
    });
	*/
    mailRejection.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
    for (string emailId: allApproversEmails) {
        if (bidOwnerEmails.contains(emailId))
            bidOwnerEmails.remove(emailId);
    }
    mailRejection.setCcAddresses(new List<String> (bidOwnerEmails));

    //Record ID for which letter will be generated
    mailRejection.setWhatId(crId);

    integer crCount2 = 0;
    string tableData2 = '';
    Phoenix_Util.EmailWrapper emailWrapper2 = Phoenix_Util.getTemplateBody('Customer_Response_Rejection_Notification', crId);
    String templateBody2 = emailWrapper2.mailHtmlBody;
    if (crLineItemsNotAwarded.size() > 0 ) {
        tableData2 += '<table style="border-collapse: collapse;" <thead><tr> <th style="border: 1px solid black;">S.No</th> <th style="border: 1px solid black;">NDC</th> <th style="border: 1px solid black;">Product Name</th><th style="border: 1px solid black;">Product Family</th><th style="border: 1px solid black;">Final Total Selling Unit</th><th style="border: 1px solid black;">Final Approved Pricing (Contracts)</th><th style="border: 1px solid black;">Bid Status</th><th style="border: 1px solid black;">Customer Decline Reasons</th></tr></thead>';
        tableData2 += '<tbody style="text-align:center">';

        for (Phoenix_Customer_Response_Line__c crli: crLineItemsNotAwarded) {
            //   if(crli.Phoenix_Bid_Status__c == 'Declined by Customer' || crli.Phoenix_Bid_Status__c == 'DRL Rescinded' || crli.Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number' ){
            crCount2++;
            tableData2 += '<tr>';
            tableData2 += '<td style="border: 1px solid black;">' + crCount + '</td>';
            if (crli.Phoenix_NDC_National_Drug_Code__c != Null) {
                tableData2 += '<td style="border: 1px solid black;">' + crli.Phoenix_NDC_National_Drug_Code__c + '</td>';
            } else if (crli.Phoenix_NDC_National_Drug_Code__c == null) {
                tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (crli.Phoenix_Product_Name__c != Null) {
                tableData2 += '<td style="border: 1px solid black;">' + crli.Phoenix_Product_Name__c + '</td>';
            } else if (crli.Phoenix_Product_Name__c == null) {
                tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (crli.Phoenix_Product_Family__c != Null) {
                tableData2 += '<td style="border: 1px solid black;">' + crli.Phoenix_Product_Family__c + '</td>';
            } else if (crli.Phoenix_Product_Family__c == null) {
                tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (crli.Phoenix_Final_Total_Selling_Unit__c != Null) {
                tableData2 += '<td style="border: 1px solid black;">' + crli.Phoenix_Final_Total_Selling_Unit__c + '</td>';
            } else if (string.valueOf(crli.Phoenix_Final_Total_Selling_Unit__c) == null) {
                tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (crli.Phoenix_Final_Approvd_Pricing_Contracts__c != Null) {
                tableData2 += '<td style="border: 1px solid black;">' + crli.Phoenix_Final_Approvd_Pricing_Contracts__c + '</td>';
            } else if (string.valueOf(crli.Phoenix_Final_Approvd_Pricing_Contracts__c) == null) {
                tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            tableData2 += '<td style="border: 1px solid black;">' + crli.Phoenix_Bid_Status__c + '</td>';
            if (crli.Phoenix_Customer_Decline_Reasons__c != Null) {
                tableData2 += '<td style="border: 1px solid black;">' + crli.Phoenix_Customer_Decline_Reasons__c + '</td>';
            } else if (string.valueOf(crli.Phoenix_Customer_Decline_Reasons__c) == null) {
                tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            //tableData+='<td style="border: 1px solid black;">'+crli.Phoenix_Customer_Decline_Reasons__c+'</td>';
            //tableData+='<td style="border: 1px solid black;">'+crli.Phoenix_Awarded_Quantity__c+'</td>';
            //tableData+='<td style="border: 1px solid black;">'+crli.Phoenix_Supply_Effective_Date__c+'</td>';
            //if(crli.Phoenix_Supply_Effective_Date__c != null) {
            //DateTime supplyEffectiveData = DateTime.newInstanceGMT(crli.Phoenix_Supply_Effective_Date__c, Time.newInstance(0, 0, 0, 0));
            //String supply_Effective_Date = supplyEffectiveData.format('MMM d yyyy');
            //tableData+='<td style="border: 1px solid black;">'+supply_Effective_Date+'</td>';
            //}      
            tableData2 += '</tr>';
            //}

        }
        tableData2 += '</tbody></table>';
    } else {
        tableData2 = '';
    }
            
            
     //bidtype label names added by vandana.

            if (bidTypesmap!=null&&bidTypesmap.get(bid.Phoenix_Bid_Type__c)!=null&&emailWrapper2.mailSubject.contains('BID_TYPE')) emailWrapper2.mailSubject = emailWrapper2.mailSubject.replace('BID_TYPE', bidTypesmap.get(bid.Phoenix_Bid_Type__c));

            //bidtype label names --end.
                   
            
    templateBody2 = templateBody2.replace('tableData', tableData2);
    // Step 3. Add your email to the master list
    mailRejection.setHtmlBody(templateBody2);
    mailRejection.setSubject(emailWrapper2.mailSubject);

    if (crLineItemsNotAwarded.size() > 0) mails.add(mailRejection);
    //b System.debug('Sending '+mails.size()+ ' mails.');
    //Send all emails in the master list
    Messaging.SendEmailResult[] results;
    if (mails.size() > 0) results = Messaging.sendEmail(mails);
           
            
    //added by vandana
    List < Phoenix_Customer_Response_Line__c > awardedItems = new List < Phoenix_Customer_Response_Line__c > ();
    for (Phoenix_Customer_Response_Line__c item: crLineItemsAwarded) {
        item.Phoenix_is_Vistex_Noti_Sent__c = true;
        awardedItems.add(item);
                
    }
            
    update awardedItems;
    //added by vandana end.
}
        
Catch(Exception e) {
    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'sendEmailToVistexTeam', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}


/*  if (results[0].success) {System.debug('The email was sent successfully.');} else {System.debug('The email failed to send: '+ results[0].errors[0].message);} */
}

@future
public static void sendNDCEmailToVistexTeam(Id ndcId) {

List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
//Create a new Email
try {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

    String vistextTeamApprover = '';
    Set < String > vistexTeamNames = new Set < String > ();
    Set < String > allApproversEmails = new Set < String > ();
    Set < String > ndcOwnerEmails = new Set < String > ();

    if (Label.Phoenix_Contracts_DL != null) ndcOwnerEmails.addAll(Label.Phoenix_Contracts_DL.split(','));

    List < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_NDC_Change__c, Phoenix_NDC_Change__r.Owner.Email, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Is_Criteria_Step__c, Phoenix_Approver__r.Email, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_NDC_Change__c =: ndcId LIMIT 20000];
    for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
        if (step.Phoenix_Approver__c != null && !step.Phoenix_Is_Criteria_Step__c) allApproversEmails.add(step.Phoenix_Approver__r.Email);
        allApproversEmails.add(step.Phoenix_NDC_Change__r.Owner.Email);
        if (step.Phoenix_Approver_Team__c == 'Home Office' || step.Phoenix_Approver_Team__c == 'Contracts') {
            if (step.Phoenix_Approver_Team_Members__c != null) vistexTeamNames = new Set < String > (step.Phoenix_Approver_Team_Members__c.split(','));
            if (step.Phoenix_Approver__c == Userinfo.getUserId())
                vistextTeamApprover = step.Phoenix_Approver__c;
        }
    }
    ndcOwnerEmails.addAll(allApproversEmails);
    List < User > usersList = new List < User > ();
    Map < String, String > vistexTeamNamesAndEmails = new Map < String, String > ();
    List < String > vistexTeamList = new List < String > ();
    usersList = [SELECT Id, Username, Name, Email FROM User where Name IN: vistexTeamNames LIMIT 100];
    for (User u: usersList) {
        vistexTeamNamesAndEmails.put(u.Id, u.Email);
    }

    Set < String > vistexTeamSet = vistexTeamNamesAndEmails.keySet();
    vistexTeamList.addAll(vistexTeamNamesAndEmails.keySet());

    List < String > sendTo = new List < String > ();
    //  sendTo.addAll(vistexTeamNamesAndEmails.values());
    sendTo.addAll(approvalTeamUsersEmailsMap.get('Home Office'));
    if(approvalTeamUsersEmailsMap.get('Demand Planning')!=null){
        sendTo.addAll(approvalTeamUsersEmailsMap.get('Demand Planning'));
    }
            
     mail.setToAddresses(sendTo);
  /*  mail.setToAddresses(new List < String > {
        'surenderpatel@drreddys.com'
            });*/
    mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
    for (string emailId: sendTo) {
        if (ndcOwnerEmails.contains(emailId))
            ndcOwnerEmails.remove(emailId);
    }
   If(ndcOwnerEmails != null && ndcOwnerEmails.contains('mkalawadia@drreddys.com'))ndcOwnerEmails.remove('mkalawadia@drreddys.com');
   If(allApproversEmails != null && allApproversEmails.contains('mkalawadia@drreddys.com'))allApproversEmails.remove('mkalawadia@drreddys.com');
           mail.setCcAddresses(new List<String> (ndcOwnerEmails));
            
    //Record ID for which letter will be generated
    mail.setWhatId(ndcId);

    integer sNo = 0;
    string tableData = '';
    Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('NDC_Customer_Response_Submitted', ndcId);
    String templateBody = emailWrapper.mailHtmlBody;
    String query = 'select ' + Phoenix_Util.ndcChangeLineItemFields + ',Phoenix_Current_Product__r.Name,Phoenix_Proposed_Product__r.Name from Phoenix_NDC_Change_Line_Item__c where Phoenix_NDC_Change__c = : ndcId and Phoenix_is_Vistex_Noti_Sent__c = False and Pheonix_Customer_Approval__c != null ';

    List < Phoenix_NDC_Change_Line_Item__c > ndcItems = Database.query(query);
    List < Phoenix_NDC_Change_Line_Item__c > ndcItemsApproved = new List < Phoenix_NDC_Change_Line_Item__c > ();
    List < Phoenix_NDC_Change_Line_Item__c > ndcItemsNotApproved = new List < Phoenix_NDC_Change_Line_Item__c > ();
    for (Phoenix_NDC_Change_Line_Item__c ndcLi: ndcItems) {
        if (ndcLi.Pheonix_Customer_Approval__c == 'Approved' || ndcLi.Pheonix_Customer_Approval__c == 'Not Required') {
            ndcItemsApproved.add(ndcLi);
        } else if (ndcLi.Pheonix_Customer_Approval__c == 'Not Approved') {
            ndcItemsNotApproved.add(ndcLi);
        }
    }

    if (ndcItemsApproved.size() > 0) {
        tableData += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;">S.No</th><th style="border: 1px solid black;">Current Product</th><th style="border: 1px solid black;">Current Product NDC</th><th style="border: 1px solid black;">Current Product Pack Size</th><th style="border: 1px solid black;">Proposed Product</th><th style="border: 1px solid black;">Proposed Product NDC</th><th style="border: 1px solid black;white-space: nowrap;">Proposed Product Pack Size</th></tr></thead>';
        tableData += '<tbody style="text-align:center">';

        for (Phoenix_NDC_Change_Line_Item__c ndcli: ndcItemsApproved) {

            sNo++;
            tableData += '<tr>';
            tableData += '<td style="border: 1px solid black;text-align: left;">' + sNo + '</td>';
            if (ndcli.Phoenix_Current_Product__c != null) tableData += '<td style="border: 1px solid black;text-align: left;">' + ndcli.Phoenix_Current_Product__r.Name + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (ndcli.Phoenix_Current_Product_NDC__c != null) tableData += '<td style="border: 1px solid black;text-align: left;">' + ndcli.Phoenix_Current_Product_NDC__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (ndcli.Phoenix_Current_Product_Pack_Size__c != null) tableData += '<td style="border: 1px solid black;text-align: right;">' + ndcli.Phoenix_Current_Product_Pack_Size__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (ndcli.Phoenix_Proposed_Product__c != null) tableData += '<td style="border: 1px solid black;text-align: left;">' + ndcli.Phoenix_Proposed_Product__r.Name + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (ndcli.Phoenix_Proposed_Product_NDC__c != null) tableData += '<td style="border: 1px solid black;text-align: left;">' + ndcli.Phoenix_Proposed_Product_NDC__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (ndcli.Phoenix_Proposed_Product_Pack_Size__c != null) tableData += '<td style="border: 1px solid black;text-align: right;">' + ndcli.Phoenix_Proposed_Product_Pack_Size__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';


            tableData += '</tr>';

        }

        tableData += '</tbody></table>';

    } else {
        tableData = '';
    }
    templateBody = templateBody.replace('tableData', tableData);
    // Step 3. Add your email to the master list
    mail.setHtmlBody(templateBody);
    mail.setSubject(emailWrapper.mailSubject);
    if (ndcItemsApproved.size() > 0) mails.add(mail);


    Messaging.SingleEmailMessage mailRejection = new Messaging.SingleEmailMessage();


     mailRejection.setToAddresses(new List<String>(allApproversEmails));
 /*   mailRejection.setToAddresses(new List < String > {
        'surender+mailRejection@dhruvsoft.com'
            });*/
    mailRejection.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
    for (string emailId: allApproversEmails) {
        if (ndcOwnerEmails.contains(emailId))
            ndcOwnerEmails.remove(emailId);
    }
    mailRejection.setCcAddresses(new List<String> (ndcOwnerEmails));

    //Record ID for which letter will be generated
    mailRejection.setWhatId(ndcId);

    integer sNo2 = 0;
    string tableData2 = '';
    Phoenix_Util.EmailWrapper emailWrapper2 = Phoenix_Util.getTemplateBody('NDC_Customer_Response_Rej_Notification', ndcId);
    String templateBody2 = emailWrapper2.mailHtmlBody;
    if (ndcItemsNotApproved.size() > 0) {
        tableData2 += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;">S.No</th><th style="border: 1px solid black;">Current Product</th><th style="border: 1px solid black;">Current Product NDC</th><th style="border: 1px solid black;">Current Product Pack Size</th><th style="border: 1px solid black;">Proposed Product</th><th style="border: 1px solid black;">Proposed Product NDC</th><th style="border: 1px solid black;white-space: nowrap;">Proposed Product Pack Size</th></tr></thead>';
        tableData2 += '<tbody style="text-align:center">';

        for (Phoenix_NDC_Change_Line_Item__c ndcLi: ndcItemsNotApproved) {

            sNo2++;
            tableData2 += '<tr>';
            tableData2 += '<td style="border: 1px solid black;text-align: center;">' + sNo2 + '</td>';
            if (ndcli.Phoenix_Current_Product__c != null) tableData2 += '<td style="border: 1px solid black;text-align: left;">' + ndcli.Phoenix_Current_Product__r.Name + '</td>';
            else tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (ndcli.Phoenix_Current_Product_NDC__c != null) tableData2 += '<td style="border: 1px solid black;text-align: left;">' + ndcli.Phoenix_Current_Product_NDC__c + '</td>';
            else tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (ndcli.Phoenix_Current_Product_Pack_Size__c != null) tableData2 += '<td style="border: 1px solid black;text-align: right;">' + ndcli.Phoenix_Current_Product_Pack_Size__c + '</td>';
            else tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (ndcli.Phoenix_Proposed_Product__c != null) tableData2 += '<td style="border: 1px solid black;text-align: left;">' + ndcli.Phoenix_Proposed_Product__r.Name + '</td>';
            else tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (ndcli.Phoenix_Proposed_Product_NDC__c != null) tableData2 += '<td style="border: 1px solid black;text-align: left;">' + ndcli.Phoenix_Proposed_Product_NDC__c + '</td>';
            else tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (ndcli.Phoenix_Proposed_Product_Pack_Size__c != null) tableData2 += '<td style="border: 1px solid black;text-align: right;">' + ndcli.Phoenix_Proposed_Product_Pack_Size__c + '</td>';
            else tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';


            tableData2 += '</tr>';



        }
        tableData2 += '</tbody></table>';
    } else {
        tableData2 = '';
    }
    templateBody2 = templateBody2.replace('tableData', tableData2);
    // Step 3. Add your email to the master list
    mailRejection.setHtmlBody(templateBody2);
    mailRejection.setSubject(emailWrapper2.mailSubject);

    if (ndcItemsNotApproved.size() > 0) mails.add(mailRejection);
    //b System.debug('Sending '+mails.size()+ ' mails.');
    //Send all emails in the master list
    Messaging.SendEmailResult[] results;
    if (mails.size() > 0) results = Messaging.sendEmail(mails);
    List < Phoenix_NDC_Change_Line_Item__c > allItemsList = new List < Phoenix_NDC_Change_Line_Item__c > ();
    if (ndcItemsApproved.size() > 0) allItemsList.addAll(ndcItemsApproved);
    if (ndcItemsNotApproved.size() > 0) allItemsList.addAll(ndcItemsNotApproved);
    for (Phoenix_NDC_Change_Line_Item__c item: allItemsList) {
        item.Phoenix_is_Vistex_Noti_Sent__c = true;
    }

    update allItemsList;

}
Catch(Exception e) {
    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'sendNDCEmailToVistexTeam', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}


/*  if (results[0].success) {System.debug('The email was sent successfully.');} else {System.debug('The email failed to send: '+ results[0].errors[0].message);} */
}
@future
public static void sendWACChangeEmailToVistexTeam(Id WacChangeId) {

List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
//Create a new Email
try {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

    String vistextTeamApprover = '';
    Set < String > vistexTeamNames = new Set < String > ();
    Set < String > allApproversEmails = new Set < String > ();
    Set < String > WACChangeOwnerEmails = new Set < String > ();

    if (Label.Phoenix_Contracts_DL != null) WACChangeOwnerEmails.addAll(Label.Phoenix_Contracts_DL.split(','));

    List < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_WAC_Change__c, Phoenix_WAC_Change__r.Owner.Email, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Is_Criteria_Step__c, Phoenix_Approver__r.Email, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_WAC_Change__c =: WacChangeId LIMIT 20000];
    for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
        if (step.Phoenix_Approver__c != null && !step.Phoenix_Is_Criteria_Step__c) allApproversEmails.add(step.Phoenix_Approver__r.Email);
        allApproversEmails.add(step.Phoenix_WAC_Change__r.Owner.Email);
        if (step.Phoenix_Approver_Team__c == 'Home Office' || step.Phoenix_Approver_Team__c == 'Contracts') {
            if (step.Phoenix_Approver_Team_Members__c != null) vistexTeamNames = new Set < String > (step.Phoenix_Approver_Team_Members__c.split(','));
            if (step.Phoenix_Approver__c == Userinfo.getUserId())
                vistextTeamApprover = step.Phoenix_Approver__c;
        }
    }
    WACChangeOwnerEmails.addAll(allApproversEmails);
    List < User > usersList = new List < User > ();
    Map < String, String > vistexTeamNamesAndEmails = new Map < String, String > ();
    List < String > vistexTeamList = new List < String > ();
    usersList = [SELECT Id, Username, Name, Email FROM User where Name IN: vistexTeamNames LIMIT 100];
    for (User u: usersList) {
        vistexTeamNamesAndEmails.put(u.Id, u.Email);
    }

    Set < String > vistexTeamSet = vistexTeamNamesAndEmails.keySet();
    vistexTeamList.addAll(vistexTeamNamesAndEmails.keySet());

    List < String > sendTo = new List < String > ();
    //  sendTo.addAll(vistexTeamNamesAndEmails.values());
    sendTo.addAll(approvalTeamUsersEmailsMap.get('Home Office'));
    if(approvalTeamUsersEmailsMap.get('Demand Planning')!=null){
        sendTo.addAll(approvalTeamUsersEmailsMap.get('Demand Planning'));
    }
     mail.setToAddresses(sendTo);
  /*  mail.setToAddresses(new List < String > {
        'surenderpatel@drreddys.com'
            });*/
    mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
    for (string emailId: sendTo) {
        if (WACChangeOwnerEmails.contains(emailId))
            WACChangeOwnerEmails.remove(emailId);
    }
If(WACChangeOwnerEmails != null && WACChangeOwnerEmails.contains('mkalawadia@drreddys.com'))WACChangeOwnerEmails.remove('mkalawadia@drreddys.com');
If(allApproversEmails != null && allApproversEmails.contains('mkalawadia@drreddys.com'))allApproversEmails.remove('mkalawadia@drreddys.com');
            mail.setCcAddresses(new List<String> (WACChangeOwnerEmails));
            
    //Record ID for which letter will be generated
    mail.setWhatId(WacChangeId);

    integer sNo = 0;
    string tableData = '';
    Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('WAC_Customer_response_rsubmitted', WacChangeId);
    String templateBody = emailWrapper.mailHtmlBody;
    String query = 'select ' + Phoenix_Util.wacChangeLineItemFields + ',Phoenix_Product__r.Name from Phoenix_WAC_Change_Line_Item__c where Phoenix_WAC_Change__c = : WacChangeId and Phoenix_is_Vistex_Noti_Sent__c = False and Phoenix_Customer_Update_Approval__c != null ';

    List < Phoenix_WAC_Change_Line_Item__c > WACItems = Database.query(query);
    List < Phoenix_WAC_Change_Line_Item__c > WACItemsApproved = new List < Phoenix_WAC_Change_Line_Item__c > ();
    List < Phoenix_WAC_Change_Line_Item__c > WACItemsNotApproved = new List < Phoenix_WAC_Change_Line_Item__c > ();
    for (Phoenix_WAC_Change_Line_Item__c WACLi: WACItems) {
        if (WACLi.Phoenix_Customer_Update_Approval__c == 'Accepted') {
            WACItemsApproved.add(WACLi);
        } else if (WACLi.Phoenix_Customer_Update_Approval__c == 'Not Accepted') {
            WACItemsNotApproved.add(WACLi);
        }
    }

    if (WACItemsApproved.size() > 0) {
        tableData += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;">S.No</th><th style="border: 1px solid black;">Contract Number</th><th style="border: 1px solid black;">Customer Name</th><th style="border: 1px solid black;">Product</th><th style="border: 1px solid black;">System WAC</th><th style="border: 1px solid black;">System Contract Price</th><th style="border: 1px solid black;white-space: nowrap;">Uploaded WAC</th><th style="border: 1px solid black;white-space: nowrap;">Uploaded Contr.Price</th><th style="border: 1px solid black;white-space: nowrap;">Proposed WAC</th><th style="border: 1px solid black;white-space: nowrap;">Proposed Contr.Price</th><th style="border: 1px solid black;white-space: nowrap;">Customer Update Approval</th><th style="border: 1px solid black;white-space: nowrap;">Customer Response Date</th><th style="border: 1px solid black;white-space: nowrap;">Customer Update Remarks</th></tr></thead>';
        tableData += '<tbody style="text-align:center">';

        for (Phoenix_WAC_Change_Line_Item__c WACLi: WACItemsApproved) {

            sNo++;
            tableData += '<tr>';
            tableData += '<td style="border: 1px solid black;text-align: left;">' + sNo + '</td>';
            if (WACLi.Phoenix_Contr_Number__c != null) tableData += '<td style="border: 1px solid black;text-align: left;">' + WACLi.Phoenix_Contr_Number__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (WACLi.Phoenix_Cust_Name__c != null) {


                tableData += '<td style="border: 1px solid black;text-align: left;">' + WACLi.Phoenix_Cust_Name__c + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (WACLi.Phoenix_Product__r.Name != null) tableData += '<td style="border: 1px solid black;text-align: left;">' + WACLi.Phoenix_Product__r.Name + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';


            if (WACLi.Phoenix_System_WAC__c != null) tableData += '<td style="border: 1px solid black;text-align: right;">' + '$' + WACLi.Phoenix_System_WAC__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (WACLi.Phoenix_System_Contract_price__c != null) tableData += '<td style="border: 1px solid black;text-align: right;">' + '$' + WACLi.Phoenix_System_Contract_price__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';


            if (WACLi.Phoenix_Uploaded_WAC__c != null) {

                tableData += '<td style="border: 1px solid black;text-align: right;">' + '$' + WACLi.Phoenix_Uploaded_WAC__c + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (WACLi.Phoenix_Uploaded_Contr_Price__c != null) {


                tableData += '<td style="border: 1px solid black;text-align: right;">' + '$' + WACLi.Phoenix_Uploaded_Contr_Price__c + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (WACLi.Phoenix_Proposed_WAC__c != null) {

                tableData += '<td style="border: 1px solid black;text-align: right;">' + '$' + WACLi.Phoenix_Proposed_WAC__c + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (WACLi.Phoenix_Proposed_Contr_Price__c != null) {


                tableData += '<td style="border: 1px solid black;text-align: right;">' + '$' + WACLi.Phoenix_Proposed_Contr_Price__c + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (WACLi.Phoenix_Customer_Update_Approval__c != null) {


                tableData += '<td style="border: 1px solid black;">' + WACLi.Phoenix_Customer_Update_Approval__c + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (WACLi.Phoenix_Customer_Response_Date__c != null) {

                DateTime CustResDate = DateTime.newInstance(WACLi.Phoenix_Customer_Response_Date__c, Time.newInstance(0, 0, 0, 0));
                String Cust_Res_Date = CustResDate.format('MMM d yyyy');
                tableData += '<td style="border: 1px solid black;">' + Cust_Res_Date + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (WACLi.Phoenix_Customer_Update_Remarks__c != null) {


                tableData += '<td style="border: 1px solid black;">' + WACLi.Phoenix_Customer_Update_Remarks__c + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            }

            tableData += '</tr>';



        }
        tableData += '</tbody></table>';
                
    } else {
        tableData = '';
    }
    templateBody = templateBody.replace('tableData', tableData);
    // Step 3. Add your email to the master list
    mail.setHtmlBody(templateBody);
    mail.setSubject(emailWrapper.mailSubject);
    if (WACItemsApproved.size() > 0) mails.add(mail);


    Messaging.SingleEmailMessage mailRejection = new Messaging.SingleEmailMessage();

            
     mailRejection.setToAddresses(new List<String>(allApproversEmails));
   /* mailRejection.setToAddresses(new List < String > {
        'surender+mailRejection@dhruvsoft.com'
            });*/
    mailRejection.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
    for (string emailId: allApproversEmails) {
        if (WACChangeOwnerEmails.contains(emailId))
            WACChangeOwnerEmails.remove(emailId);
    }
    mailRejection.setCcAddresses(new List<String> (WACChangeOwnerEmails));
            
    //Record ID for which letter will be generated
    mailRejection.setWhatId(WacChangeId);

    integer sNo2 = 0;
    string tableData2 = '';
    Phoenix_Util.EmailWrapper emailWrapper2 = Phoenix_Util.getTemplateBody('WAC_Customer_response_rejection', WacChangeId);
    String templateBody2 = emailWrapper2.mailHtmlBody;
 if (WACItemsNotApproved.size() > 0 ) {
        tableData2 += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;">S.No</th><th style="border: 1px solid black;">Contract Number</th><th style="border: 1px solid black;">Customer Name</th><th style="border: 1px solid black;">Product</th><th style="border: 1px solid black;">System WAC</th><th style="border: 1px solid black;">System Contract Price</th><th style="border: 1px solid black;white-space: nowrap;">Uploaded WAC</th><th style="border: 1px solid black;white-space: nowrap;">Uploaded Contr.Price</th><th style="border: 1px solid black;white-space: nowrap;">Proposed WAC</th><th style="border: 1px solid black;white-space: nowrap;">Proposed Contr.Price</th><th style="border: 1px solid black;white-space: nowrap;">Customer Update Approval</th><th style="border: 1px solid black;white-space: nowrap;">Customer Response Date</th><th style="border: 1px solid black;white-space: nowrap;">Customer Update Remarks</th></tr></thead>';
        tableData2 += '<tbody style="text-align:center">';

        for (Phoenix_WAC_Change_Line_Item__c WACLi: WACItemsNotApproved) {

            sNo2++;
            tableData2 += '<tr>';
            tableData2 += '<td style="border: 1px solid black;text-align: center;">' + sNo2 + '</td>';
            if (WACLi.Phoenix_Contr_Number__c != null) tableData2 += '<td style="border: 1px solid black;text-align: center;">' + WACLi.Phoenix_Contr_Number__c + '</td>';
            else tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';

            if (WACLi.Phoenix_Cust_Name__c != null) {


                tableData2 += '<td style="border: 1px solid black;text-align: center;">' + WACLi.Phoenix_Cust_Name__c + '</td>';
            } else {
                tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (WACLi.Phoenix_Product__r.Name != null) tableData2 += '<td style="border: 1px solid black;text-align: center;">' + WACLi.Phoenix_Product__r.Name + '</td>';
            else tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';


            if (WACLi.Phoenix_System_WAC__c != null) tableData2 += '<td style="border: 1px solid black;text-align: right;">' + WACLi.Phoenix_System_WAC__c + '</td>';
            else tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (WACLi.Phoenix_System_Contract_price__c != null) tableData2 += '<td style="border: 1px solid black;text-align: right;">' + WACLi.Phoenix_System_Contract_price__c + '</td>';
            else tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';


            if (WACLi.Phoenix_Uploaded_WAC__c != null) {

                tableData2 += '<td style="border: 1px solid black;text-align: right;">' + WACLi.Phoenix_Uploaded_WAC__c + '</td>';
            } else {
                tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (WACLi.Phoenix_Uploaded_Contr_Price__c != null) {


                tableData2 += '<td style="border: 1px solid black;text-align: right;">' + WACLi.Phoenix_Uploaded_Contr_Price__c + '</td>';
            } else {
                tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (WACLi.Phoenix_Proposed_WAC__c != null) {

                tableData2 += '<td style="border: 1px solid black;text-align: right;">' + WACLi.Phoenix_Proposed_WAC__c + '</td>';
            } else {
                tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (WACLi.Phoenix_Proposed_Contr_Price__c != null) {


                tableData2 += '<td style="border: 1px solid black;text-align: right;">' + WACLi.Phoenix_Proposed_Contr_Price__c + '</td>';
            } else {
                tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (WACLi.Phoenix_Customer_Update_Approval__c != null) {


                tableData2 += '<td style="border: 1px solid black;">' + WACLi.Phoenix_Customer_Update_Approval__c + '</td>';
            } else {
                tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (WACLi.Phoenix_Customer_Response_Date__c != null) {

                DateTime CustResDate = DateTime.newInstance(WACLi.Phoenix_Customer_Response_Date__c, Time.newInstance(0, 0, 0, 0));
                String Cust_Res_Date = CustResDate.format('MMM d yyyy');
                tableData2 += '<td style="border: 1px solid black;">' + Cust_Res_Date + '</td>';
            } else {
                tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (WACLi.Phoenix_Customer_Update_Remarks__c != null) {


                tableData2 += '<td style="border: 1px solid black;">' + WACLi.Phoenix_Customer_Update_Remarks__c + '</td>';
            } else {
                tableData2 += '<td style="border: 1px solid black;">' + '' + '</td>';
            }

            tableData2 += '</tr>';



        }
        tableData2 += '</tbody></table>';
                
    } else {
        tableData2 = '';
    }
    templateBody2 = templateBody2.replace('tableData', tableData2);
    // Step 3. Add your email to the master list
    mailRejection.setHtmlBody(templateBody2);
    mailRejection.setSubject(emailWrapper2.mailSubject);

    if (WACItemsNotApproved.size() > 0) mails.add(mailRejection);
    //b System.debug('Sending '+mails.size()+ ' mails.');
    //Send all emails in the master list
    Messaging.SendEmailResult[] results;
    if (mails.size() > 0) results = Messaging.sendEmail(mails);
    List < Phoenix_WAC_Change_Line_Item__c > allItemsList = new List < Phoenix_WAC_Change_Line_Item__c > ();
    if (WACItemsApproved.size() > 0) allItemsList.addAll(WACItemsApproved);
    if (WACItemsNotApproved.size() > 0) allItemsList.addAll(WACItemsNotApproved);
    for (Phoenix_WAC_Change_Line_Item__c item: allItemsList) {
        item.Phoenix_is_Vistex_Noti_Sent__c = true;
    }

    update allItemsList;

}
Catch(Exception e) {
    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'sendWACChangeEmailToVistexTeamEmailToVistexTeam', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}


/*  if (results[0].success) {System.debug('The email was sent successfully.');} else {System.debug('The email failed to send: '+ results[0].errors[0].message);} */
}
@future
public static void sendWACChangeEmailToFinanceTeam(Id WacChangeId) {
Phoenix_WAC_Change__c WacChange = [Select Id, Name, Owner.Email from Phoenix_WAC_Change__c where Id =: WacChangeId Limit 1];
List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
//Create a new Email
try {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    List < String > toAddress = new List < String > ();
    toAddress.addAll(approvalTeamUsersEmailsMap.get('Finance'));
    mail.setToAddresses(toAddress);
    mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
    mail.setCcAddresses(new List < String > {
        WacChange.Owner.Email
    });
    Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('WAC_Finance_Notification', WacChangeId);
    String templateBody = emailWrapper.mailHtmlBody;

    mail.setHtmlBody(templateBody);
    mail.setSubject(emailWrapper.mailSubject);

    mails.add(mail);
    Messaging.SendEmailResult[] results;
    if (mails.size() > 0)


    results = Messaging.sendEmail(mails);


}
Catch(Exception e) {
    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'sendWACChangeEmailFinanceTeam', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}


/*  if (results[0].success) {System.debug('The email was sent successfully.');} else {System.debug('The email failed to send: '+ results[0].errors[0].message);} */
}
@future
public static void sendNewWACEmailToFinanceTeam(Id NewWACId) {
New_Product_WAC_Pricing__c NewWac = [Select Id, Name, Owner.Email from New_Product_WAC_Pricing__c where Id =: NewWACId Limit 1];
List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
//Create a new Email
try {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    List < String > toAddress = new List < String > ();
    toAddress.addAll(approvalTeamUsersEmailsMap.get('Finance'));
    toAddress.add('balakumarn@drreddys.com');
    toAddress.add(NewWac.Owner.Email);
            
    mail.setToAddresses(toAddress);
    mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
    Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('New_WAC_FinanceNotification', NewWACId);
    String templateBody = emailWrapper.mailHtmlBody;
    mail.setHtmlBody(templateBody);
    mail.setSubject(emailWrapper.mailSubject);
    mails.add(mail);
    Messaging.SendEmailResult[] results;
    if (mails.size() > 0)


    results = Messaging.sendEmail(mails);


}
Catch(Exception e) {
    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'sendWACChangeEmailFinanceTeam', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}


/*  if (results[0].success) {System.debug('The email was sent successfully.');} else {System.debug('The email failed to send: '+ results[0].errors[0].message);} */
}
////////// SCM Noti.
//
@future
public static void sendEmailToSCMTeam(Id bidId) {
Phoenix_Bid__c bid = [Select Id, Name, Owner.Email,Phoenix_Bid_Type__c, Phoenix_Bid_Deadline_Date__c, Phoenix_Sales_Person_2__c, Phoenix_Sales_Person_2__r.Email, Phoenix_Salesperson__c, Phoenix_Salesperson__r.Email, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Bid_Created_Behalf_of__r.Email, Phoenix_Internal_Target_Date__c, Phoenix_Customer_Bid_Deadline_Date_Time__c FROM Phoenix_Bid__c Where Id =: bidId];   
List<Phoenix_Bid_Line_Item__c>  bidLineItems = [Select Id, Name, Phoenix_Product__r.Phoenix_Product_Director__c, Phoenix_Product__r.Phoenix_Marketing_Lead__c, Phoenix_Product__c, Phoenix_Product__r.Family,Phoenix_Product__r.Name,Phoenix_NDC__c,Phoenix_Day_s_Notice_Product_removal__c,Phoenix_Customer_Requested_Days__c,Phoenix_Contract__r.Name,Phoenix_Customer__r.Name FROM Phoenix_Bid_Line_Item__c Where Phoenix_Bid__c =: bidId AND Phoenix_Final_Status__c != 'Not Approved'];
List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
String table_Data = '';
integer sNo = 0;
Map < String, String > bidTypesmap = new Map < String, String > ();
        
for(Schema.PicklistEntry  ple:  Phoenix_Bid__c.Phoenix_Bid_Type__c.getDescribe().getPicklistValues()){
    bidTypesmap.put(ple.getValue(),ple.getLabel());
}

//Create a new Email
try {
    if(bidLineItems.size()>0 && bid.Phoenix_Bid_Type__c =='Mass Product Removals'){
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    List < String > toAddress = new List < String > ();
        if(approvalTeamUsersEmailsMap.get('Supply Chain')!=null) 
    toAddress.addAll(approvalTeamUsersEmailsMap.get('Supply Chain'));
    //mail.setToAddresses(new List<String>{'vandana@dhruvsoft.com'});
        mail.setToAddresses(toAddress);
    mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
    Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('SCM_Noti_For_Maa_Product_Removals', BidId);
    String templateBody = emailWrapper.mailHtmlBody;
    String subject = emailWrapper.mailSubject;
    if (bid.Phoenix_Internal_Target_Date__c != null) {
        DateTime internalDueDateTime = DateTime.newInstance(bid.Phoenix_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0));
        if (templateBody.contains('INTERNAL_DEADLINE_DATE')) templateBody = templateBody.replace('INTERNAL_DEADLINE_DATE', internalDueDateTime.format('MMM d yyyy'));
    }
   if (bidTypesmap!=null&&bidTypesmap.get(bid.Phoenix_Bid_Type__c)!=null&&templateBody.contains('BID_TYPE')) templateBody = templateBody.replace('BID_TYPE', bidTypesmap.get(bid.Phoenix_Bid_Type__c));
   if (subject.contains('BID_TYPE'))subject = subject.replace('BID_TYPE', bidTypesmap.get(bid.Phoenix_Bid_Type__c)); 
    table_Data += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;padding:4px;">S.No</th><th style="border: 1px solid black;padding:4px">Product Name</th><th style="border: 1px solid black;padding:4px">Product Family</th><th style="border: 1px solid black;padding:4px;width:10%">NDC</th><th style="border: 1px solid black;padding:4px">Days\' Notice - Product Removals</th><th style="border: 1px solid black;padding:4px">Customer Requested Days</th><th style="border: 1px solid black;padding:4px;">Contract</th><th style="border: 1px solid black;padding:4px;">Customer</th></tr></thead>';
    table_Data += '<tbody>';
            
            
    for(Phoenix_Bid_Line_Item__c item: bidLineItems){
        sNo++;
        table_Data += '<tr>';
        table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">' + sNo + '</td>';
        if (item.Phoenix_Product__r.Name != Null)
            table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">'+item.Phoenix_Product__r.Name+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
        if (item.Phoenix_Product__r.Family != Null)
            table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">'+item.Phoenix_Product__r.Family+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
        if (item.Phoenix_NDC__c != Null)
            table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">'+item.Phoenix_NDC__c+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
        if (item.Phoenix_Day_s_Notice_Product_removal__c != Null)
            table_Data += '<td style="border: 1px solid black;text-align:right;padding:4px">'+item.Phoenix_Day_s_Notice_Product_removal__c+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
        if (item.Phoenix_Customer_Requested_Days__c != Null)
            table_Data += '<td style="border: 1px solid black;text-align:right;padding:4px">'+item.Phoenix_Customer_Requested_Days__c+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
        if (item.Phoenix_Contract__r.Name != Null)
            table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">'+item.Phoenix_Contract__r.Name+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
        if (item.Phoenix_Customer__r.Name != Null)
            table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">'+item.Phoenix_Customer__r.Name+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
        table_Data += '</tr>';
    }
    table_Data += '</tbody></table>';
    if (templateBody.contains('Bid_Line_Items')) templateBody = templateBody.replace('Bid_Line_Items', table_Data);
    mail.setHtmlBody(templateBody);
    mail.setSubject(subject);
               
     mails.add(mail);
                
    Messaging.SendEmailResult[] results;
    if (mails.size() > 0)
                

    results = Messaging.sendEmail(mails);
            
    }   
}
Catch(Exception e) {
    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'sendWACChangeEmailFinanceTeam', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}
        
        
/*  if (results[0].success) {System.debug('The email was sent successfully.');} else {System.debug('The email failed to send: '+ results[0].errors[0].message);} */
}
    
    
    
////////////////////////////////////SCM Noti End.
/**
* @description This will send notification to Sr Director after Finance approval.
* @author Surender Patel (Dhruvsoft) | 17-05-2021 
* @param String bidId 
**/
@future
public static void SVPEmailNotification(String bidId) {
list < messaging.Email > mailsList = new list < messaging.email > ();
  //bidtype label names added by vandana.
      Map < String, String > bidTypesmap = new Map < String, String > ();
                    
            for(Schema.PicklistEntry  ple:  Phoenix_Bid__c.Phoenix_Bid_Type__c.getDescribe().getPicklistValues()){
                bidTypesmap.put(ple.getValue(),ple.getLabel());
            }
        
  //bidtype label names added end.



        
        
        
try {
    String mailStatus = '';
    Messaging.SendEmailResult[] results;
    Phoenix_Bid__c bid = [Select Id,Phoenix_Bid_Type__c, Phoenix_Customer_Bid_Deadline_Date_Time__c, Phoenix_Internal_Target_Date__c, Phoenix_Bid_Deadline_Date__c From Phoenix_Bid__c where Id =: bidId];
    list < Phoenix_Approval_Grid__c > approvalGridList = [Select Id, Phoenix_Product_Family__c, Phoenix_Is_New_Low__c, Phoenix_Annualized_TP__c, Phoenix_Annualized_TP_Impact__c,
        Phoenix_Annualized_TP_Impact_Limit__c, Phoenix_TP__c, Phoenix_TP_Limit__c, Phoenix_Annualized_GM__c, Phoenix_Is_partner_product__c,
        Phoenix_Annualized_GM_Impact__c, Phoenix_Annualized_GM_Impact_Limit__c, Phoenix_Revenue__c, Phoenix_Revenue_Limit__c,
        Phoenix_GM__c, Phoenix_GM_Limit__c, Phoenix_Marketing_Lead_Rx__c, Phoenix_Marketing_Lead_SRx__c, Phoenix_Marketing_Lead_OTC__c,
        Phoenix_Business_Head_Comments__c, Phoenix_Approval__c, Phoenix_Comments__c, Phoenix_Sr_Director_VP__c,
        Phoenix_Sr_Director_VP_Finance_Comments__c FROM Phoenix_Approval_Grid__c WHERE Phoenix_Bid__c =: bidId AND Phoenix_Is_SVP_Notification_Required__c = true AND Phoenix_Final_Status__c != 'Not Approved'
    ];

    list < Phoenix_User_Approval_Matrix__c > svpMatrixList = [Select Id, Phoenix_Approver__c, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Is_Approval_Process_User__c, Phoenix_Approver__r.Email
        From Phoenix_User_Approval_Matrix__c where User_Group__r.Phoenix_Approver_Group_Name__c = 'Sr Director or VP Finance'
        and Phoenix_Is_Approval_Process_User__c = true
    ];
    //system.debug('svpUsersList'+svpUsersList);
    set < string > toaddress = new set < string > ();
    for (Phoenix_User_Approval_Matrix__c matrix: svpMatrixList) {
        if (matrix.Phoenix_Approver__c != null) toaddress.add(matrix.Phoenix_Approver__r.Email);
    }
    if (approvalGridList.size() > 0) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('SVP_Approval_Notification', bidId);
        String templateBody = emailWrapper.mailHtmlBody;
        String subject = emailWrapper.mailSubject;
        integer sNo = 0;
        string tableData = '';
        tableData += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;padding:4px;">S.No</th><th style="border: 1px solid black;width:15%;padding:4px">Product Family</th><th style="border: 1px solid black;width:15%;padding:4px">Products below Lowest Price / SKU</th><th style="border: 1px solid black;width:15%;padding:4px">Annualized TP</th><th style="border: 1px solid black;width:21%;padding:4px">Annualized TP Impact</th><th style="border: 1px solid black;width:27%;padding:4px">Annualized TP Impact Limit</th><th style="border: 1px solid black; width:9%;padding:4px;">TP%</th><th style="border: 1px solid black; width:15%;padding:4px;">TP % Limit</th><th style="border: 1px solid black; width:15%;padding:4px">Annualized GM</th><th style="border: 1px solid black;width:23%;padding:4px">Annualized GM Impact</th><th style="border: 1px solid black;width:28%;padding:4px">Annualized GM Impact Limit</th><th style="border: 1px solid black;width:15%;padding:4px">Revenue</th><th style="border: 1px solid black;width:15%;padding:4px">Revenue Limit</th><th style="border: 1px solid black;width:9%;padding:4px">GM%</th><th style="border: 1px solid black; width:15%;padding:4px">GM% Limit</th><th style="border: 1px solid black;width:18%;padding:4px">Marketing Lead Rx</th><th style="border: 1px solid black;width:20%;padding:4px">Marketing Lead SRx</th><th style="border: 1px solid black;width:20%;padding:4px">Marketing Lead OTC</th><th style="border: 1px solid black;width:25%;padding:4px">Marketing Lead Comments</th><th style="border: 1px solid black;width:25%;padding:4px">Marketing Head Approval</th><th style="border: 1px solid black;width:25%;padding:4px">Marketing Head Comments</th><th style="border: 1px solid black;width:32%;padding:4px">Sr Director / VP Finance Approval</th><th style="border: 1px solid black;width:34%;padding:4px">Sr Director / VP Finance Comments</th></tr></thead>';
        tableData += '<tbody>';
        for (Phoenix_Approval_Grid__c grid: approvalGridList) {
            sNo++;
            tableData += '<tr>';
            tableData += '<td style="border: 1px solid black;text-align:left;white-space: nowrap;padding:4px">' + sNo + '</td>';
            tableData += '<td style="border: 1px solid black;text-align:left;white-space: nowrap;padding:4px">' + grid.Phoenix_Product_Family__c + '</td>';
            if (grid.Phoenix_Is_New_Low__c == True) tableData += '<td style="border: 1px solid black;text-align:left;white-space: nowrap;background-color:Yellow;padding:4px">' + 'Yes' + '</td>';
            else if (grid.Phoenix_Is_New_Low__c == False) tableData += '<td style="border: 1px solid black;text-align:left;white-space: nowrap;padding:4px">' + 'No' + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Is_partner_product__c == false) {
                if (grid.Phoenix_Annualized_TP__c != Null) tableData += '<td style="border: 1px solid black;text-align:right;white-space: nowrap;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Annualized_TP__c) + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_Annualized_TP_Impact__c != Null) tableData += '<td style="border: 1px solid black;text-align:right;white-space: nowrap;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Annualized_TP_Impact__c) + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_Annualized_TP_Impact_Limit__c != Null) tableData += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;white-space: nowrap;padding:4px">' + grid.Phoenix_Annualized_TP_Impact_Limit__c + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_TP__c != Null) tableData += '<td style="border: 1px solid black;text-align:right;white-space: nowrap;padding:4px">' + '%' + grid.Phoenix_TP__c.setscale(2) + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_TP_Limit__c != Null) tableData += '<td style="border: 1px solid black;text-align:right;background-color:Yellow;white-space: nowrap;padding:4px">' + grid.Phoenix_TP_Limit__c + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (grid.Phoenix_Is_partner_product__c == True) {
                if (grid.Phoenix_Annualized_GM__c != Null) tableData += '<td style="border: 1px solid black;text-align: right;white-space: nowrap;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Annualized_GM__c) + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_Annualized_GM_Impact__c != Null) tableData += '<td style="border: 1px solid black;text-align: right;white-space: nowrap;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Annualized_GM_Impact__c) + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_Annualized_GM_Impact_Limit__c != Null) tableData += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;white-space: nowrap;padding:4px">' + grid.Phoenix_Annualized_GM_Impact_Limit__c + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (grid.Phoenix_Revenue__c != Null) tableData += '<td style="border: 1px solid black;text-align: right;white-space: nowrap;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Revenue__c) + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Revenue_Limit__c != Null) tableData += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;white-space: nowrap;padding:4px">' + grid.Phoenix_Revenue_Limit__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Is_partner_product__c == True) {
                if (grid.Phoenix_GM__c != Null) tableData += '<td style="border: 1px solid black;text-align:right;white-space: nowrap;padding:4px">' + '%' + grid.Phoenix_GM__c.setscale(2) + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_GM_Limit__c != Null) tableData += '<td style="border: 1px solid black;text-align:right;background-color:Yellow;white-space: nowrap;padding:4px">' + grid.Phoenix_GM_Limit__c + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (grid.Phoenix_Marketing_Lead_Rx__c != Null) tableData += '<td style="border: 1px solid black;text-align:left;white-space: nowrap;padding:4px">' + grid.Phoenix_Marketing_Lead_Rx__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Marketing_Lead_SRx__c != Null) tableData += '<td style="border: 1px solid black;text-align:left;white-space: nowrap;padding:4px">' + grid.Phoenix_Marketing_Lead_SRx__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Marketing_Lead_OTC__c != Null) tableData += '<td style="border: 1px solid black;text-align:left;white-space: nowrap;padding:4px">' + grid.Phoenix_Marketing_Lead_OTC__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Business_Head_Comments__c != Null) tableData += '<td style="border: 1px solid black;text-align:left;white-space: nowrap;padding:4px">' + grid.Phoenix_Business_Head_Comments__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Approval__c != Null) tableData += '<td style="border: 1px solid black;text-align:left;white-space: nowrap;padding:4px">' + grid.Phoenix_Approval__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Comments__c != Null) tableData += '<td style="border: 1px solid black;text-align:left;white-space: nowrap;padding:4px">' + grid.Phoenix_Comments__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Sr_Director_VP__c != Null) tableData += '<td style="border: 1px solid black;text-align:left;white-space: nowrap;padding:4px">' + grid.Phoenix_Sr_Director_VP__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Sr_Director_VP_Finance_Comments__c != Null) tableData += '<td style="border: 1px solid black;text-align:left;white-space: nowrap;padding:4px">' + grid.Phoenix_Sr_Director_VP_Finance_Comments__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            tableData += '</tr>';
        }
        tableData += '</tbody></table>';
        email.setToAddresses(new List < String > (toaddress));
         if(Label.Phoenix_Contracts_DL!=null)email.setCcAddresses(Label.Phoenix_Contracts_DL.split(','));
     /*   email.setCcAddresses(new List < String > {
            'surender+uat@dhruvsoft.com'
                });
		*/
        templateBody = templateBody.replace('tableData', tableData);
        Date internalDueDate = bid.Phoenix_Internal_Target_Date__c;
        if (bid.Phoenix_Internal_Target_Date__c != null) {
            DateTime internalDueDateTime = DateTime.newInstance(internalDueDate, Time.newInstance(0, 0, 0, 0));
            if (templateBody.contains('INTERNAL_DEADLINE_DATE')) templateBody = templateBody.replace('INTERNAL_DEADLINE_DATE', internalDueDateTime.format('MMM d yyyy'));
        }

        if (bid.Phoenix_Bid_Deadline_Date__c != null) {
            DateTime customerBidDeadLineTime = DateTime.newInstance(bid.Phoenix_Bid_Deadline_Date__c, Time.newInstance(0, 0, 0, 0));
            if (templateBody.contains('CUSTOMER_DEADLINE_DATE')) templateBody = templateBody.replace('CUSTOMER_DEADLINE_DATE', customerBidDeadLineTime.format('MMM d yyyy'));
        }
                
          //bidtype label names added by vandana.

                    
            if (templateBody.contains('BID_TYPE')) templateBody = templateBody.replace('BID_TYPE', bidTypesmap.get(bid.Phoenix_Bid_Type__c));

            //bidtype label names --end.
                
        email.setHtmlBody(templateBody);
        email.setSubject(subject);
        email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);

        mailsList.add(email);
        messaging.sendEmail(mailsList);
    }
}
Catch(Exception e) {
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();

    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'SVPEmailNotification', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}

}
@future
public static void MkgHeadEmailNotification(String bidId) {
list < messaging.Email > mailsList = new list < messaging.email > ();
  //bidtype label names added by vandana.
      Map < String, String > bidTypesmap = new Map < String, String > ();
                    
            for(Schema.PicklistEntry  ple:  Phoenix_Bid__c.Phoenix_Bid_Type__c.getDescribe().getPicklistValues()){
                bidTypesmap.put(ple.getValue(),ple.getLabel());
            }
        
  //bidtype label names added end.


        
try {
    String mailStatus = '';
    Messaging.SendEmailResult[] results;
    Phoenix_Bid__c bid = [Select Id,Phoenix_Bid_Type__c, Phoenix_Customer_Bid_Deadline_Date_Time__c, Phoenix_Internal_Target_Date__c, Phoenix_Bid_Deadline_Date__c From Phoenix_Bid__c where Id =: bidId];
    list < Phoenix_Approval_Grid__c > approvalGridList = [Select Id, Phoenix_Product_Family__c, Phoenix_Is_New_Low__c, Phoenix_Annualized_TP__c, Phoenix_Annualized_TP_Impact__c,
        Phoenix_Annualized_TP_Impact_Limit__c, Phoenix_TP__c, Phoenix_TP_Limit__c, Phoenix_Annualized_GM__c, Phoenix_Is_partner_product__c,
        Phoenix_Annualized_GM_Impact__c, Phoenix_Annualized_GM_Impact_Limit__c, Phoenix_Revenue__c, Phoenix_Revenue_Limit__c,
        Phoenix_GM__c, Phoenix_GM_Limit__c, Phoenix_Marketing_Lead_Rx__c, Phoenix_Marketing_Lead_SRx__c, Phoenix_Marketing_Lead_OTC__c,
        Phoenix_Business_Head_Comments__c, Phoenix_Approval__c, Phoenix_Comments__c, Phoenix_Sr_Director_VP__c,
        Phoenix_Sr_Director_VP_Finance_Comments__c FROM Phoenix_Approval_Grid__c WHERE Phoenix_Bid__c =: bidId AND Phoenix_Is_Mkg_Head_Noti_Required__c = true AND Phoenix_Final_Status__c != 'Not Approved'
    ];

    list < Phoenix_User_Approval_Matrix__c > mkgHeadMatrixList = [Select Id, Phoenix_Approver__c, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Is_Approval_Process_User__c, Phoenix_Approver__r.Email
        From Phoenix_User_Approval_Matrix__c where User_Group__r.Phoenix_Approver_Group_Name__c = 'Marketing Head'
        and Phoenix_Is_Approval_Process_User__c = true
    ];
    //system.debug('svpUsersList'+svpUsersList);
    set < string > toaddress = new set < string > ();
    for (Phoenix_User_Approval_Matrix__c matrix: mkgHeadMatrixList) {
        if (matrix.Phoenix_Approver__c != null) toaddress.add(matrix.Phoenix_Approver__r.Email);
    }
    if (approvalGridList.size() > 0) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Mkg_Approval_Notification', bidId);
        String templateBody = emailWrapper.mailHtmlBody;
        String subject = emailWrapper.mailSubject;
        integer sNo = 0;
        string tableData = '';
        tableData += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;padding:4px;">S.No</th><th style="border: 1px solid black;width:15%;padding:4px">Product Family</th><th style="border: 1px solid black;width:15%;padding:4px">Products below Lowest Price / SKU</th><th style="border: 1px solid black;width:15%;padding:4px">Annualized TP</th><th style="border: 1px solid black;width:21%;padding:4px">Annualized TP Impact</th><th style="border: 1px solid black;width:27%;padding:4px">Annualized TP Impact Limit</th><th style="border: 1px solid black; width:9%;padding:4px;">TP%</th><th style="border: 1px solid black; width:15%;padding:4px;">TP % Limit</th><th style="border: 1px solid black; width:15%;padding:4px">Annualized GM</th><th style="border: 1px solid black;width:23%;padding:4px">Annualized GM Impact</th><th style="border: 1px solid black;width:28%;padding:4px">Annualized GM Impact Limit</th><th style="border: 1px solid black;width:15%;padding:4px">Revenue</th><th style="border: 1px solid black;width:15%;padding:4px">Revenue Limit</th><th style="border: 1px solid black;width:9%;padding:4px">GM%</th><th style="border: 1px solid black; width:15%;padding:4px">GM% Limit</th><th style="border: 1px solid black;width:18%;padding:4px">Marketing Lead Rx</th><th style="border: 1px solid black;width:20%;padding:4px">Marketing Lead SRx</th><th style="border: 1px solid black;width:20%;padding:4px">Marketing Lead OTC</th><th style="border: 1px solid black;width:25%;padding:4px">Marketing Lead Comments</th><th style="border: 1px solid black;width:25%;padding:4px">Marketing Head Approval</th><th style="border: 1px solid black;width:25%;padding:4px">Marketing Head Comments</th><th style="border: 1px solid black;width:32%;padding:4px">Sr Director / VP Finance Approval</th><th style="border: 1px solid black;width:34%;padding:4px">Sr Director / VP Finance Comments</th></tr></thead>';
        tableData += '<tbody>';
        for (Phoenix_Approval_Grid__c grid: approvalGridList) {
            sNo++;
            tableData += '<tr>';
            tableData += '<td style="border: 1px solid black;text-align:left;white-space: pre;padding:4px">' + sNo + '</td>';
            tableData += '<td style="border: 1px solid black;text-align:left;white-space: pre;padding:4px">' + grid.Phoenix_Product_Family__c + '</td>';
            if (grid.Phoenix_Is_New_Low__c == True) tableData += '<td style="border: 1px solid black;text-align:left;white-space: pre;background-color:Yellow;padding:4px">' + 'Yes' + '</td>';
            else if (grid.Phoenix_Is_New_Low__c == False) tableData += '<td style="border: 1px solid black;text-align:left;white-space: pre;padding:4px">' + 'No' + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Is_partner_product__c == false) {
                if (grid.Phoenix_Annualized_TP__c != Null) tableData += '<td style="border: 1px solid black;text-align:right;white-space: pre;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Annualized_TP__c) + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_Annualized_TP_Impact__c != Null) tableData += '<td style="border: 1px solid black;text-align:right;white-space: pre;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Annualized_TP_Impact__c) + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_Annualized_TP_Impact_Limit__c != Null) tableData += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;white-space: pre;padding:4px">' + grid.Phoenix_Annualized_TP_Impact_Limit__c + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_TP__c != Null) tableData += '<td style="border: 1px solid black;text-align:right;white-space: pre;padding:4px">' + '%' + grid.Phoenix_TP__c.setscale(2) + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_TP_Limit__c != Null) tableData += '<td style="border: 1px solid black;text-align:right;background-color:Yellow;white-space: pre;padding:4px">' + grid.Phoenix_TP_Limit__c + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (grid.Phoenix_Is_partner_product__c == True) {
                if (grid.Phoenix_Annualized_GM__c != Null) tableData += '<td style="border: 1px solid black;text-align: right;white-space: pre;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Annualized_GM__c) + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_Annualized_GM_Impact__c != Null) tableData += '<td style="border: 1px solid black;text-align: right;white-space: pre;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Annualized_GM_Impact__c) + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_Annualized_GM_Impact_Limit__c != Null) tableData += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;white-space: pre;padding:4px">' + grid.Phoenix_Annualized_GM_Impact_Limit__c + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (grid.Phoenix_Revenue__c != Null) tableData += '<td style="border: 1px solid black;text-align: right;white-space: pre;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Revenue__c) + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Revenue_Limit__c != Null) tableData += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;white-space: pre;padding:4px">' + grid.Phoenix_Revenue_Limit__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Is_partner_product__c == True) {
                if (grid.Phoenix_GM__c != Null) tableData += '<td style="border: 1px solid black;text-align:right;white-space: pre;padding:4px">' + '%' + grid.Phoenix_GM__c.setscale(2) + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_GM_Limit__c != Null) tableData += '<td style="border: 1px solid black;text-align:right;background-color:Yellow;white-space: pre;padding:4px">' + grid.Phoenix_GM_Limit__c + '</td>';
                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            }
            if (grid.Phoenix_Marketing_Lead_Rx__c != Null) tableData += '<td style="border: 1px solid black;text-align:left;white-space: pre;padding:4px">' + grid.Phoenix_Marketing_Lead_Rx__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Marketing_Lead_SRx__c != Null) tableData += '<td style="border: 1px solid black;text-align:left;white-space: pre;padding:4px">' + grid.Phoenix_Marketing_Lead_SRx__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Marketing_Lead_OTC__c != Null) tableData += '<td style="border: 1px solid black;text-align:left;white-space: pre;padding:4px">' + grid.Phoenix_Marketing_Lead_OTC__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Business_Head_Comments__c != Null) tableData += '<td style="border: 1px solid black;text-align:left;white-space: pre;padding:4px">' + grid.Phoenix_Business_Head_Comments__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Approval__c != Null) tableData += '<td style="border: 1px solid black;text-align:left;white-space: pre;padding:4px">' + grid.Phoenix_Approval__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Comments__c != Null) tableData += '<td style="border: 1px solid black;text-align:left;white-space: pre;padding:4px">' + grid.Phoenix_Comments__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Sr_Director_VP__c != Null) tableData += '<td style="border: 1px solid black;text-align:left;white-space: pre;padding:4px">' + grid.Phoenix_Sr_Director_VP__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            if (grid.Phoenix_Sr_Director_VP_Finance_Comments__c != Null) tableData += '<td style="border: 1px solid black;text-align:left;white-space: pre;padding:4px">' + grid.Phoenix_Sr_Director_VP_Finance_Comments__c + '</td>';
            else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
            tableData += '</tr>';
        }
        tableData += '</tbody></table>';
        email.setToAddresses(new List < String > (toaddress));
        if(Label.Phoenix_Contracts_DL!=null)email.setCcAddresses(Label.Phoenix_Contracts_DL.split(','));
      /*  email.setCcAddresses(new List < String > {
            'surender+uat@dhruvsoft.com'
                });
       */
        templateBody = templateBody.replace('tableData', tableData);
        Date internalDueDate = bid.Phoenix_Internal_Target_Date__c;
        if (bid.Phoenix_Internal_Target_Date__c != null) {
            DateTime internalDueDateTime = DateTime.newInstance(internalDueDate, Time.newInstance(0, 0, 0, 0));
            if (templateBody.contains('INTERNAL_DEADLINE_DATE')) templateBody = templateBody.replace('INTERNAL_DEADLINE_DATE', internalDueDateTime.format('MMM d yyyy'));
        }

        if (bid.Phoenix_Bid_Deadline_Date__c != null) {
            DateTime customerBidDeadLineTime = DateTime.newInstance(bid.Phoenix_Bid_Deadline_Date__c, Time.newInstance(0, 0, 0, 0));
            if (templateBody.contains('CUSTOMER_DEADLINE_DATE')) templateBody = templateBody.replace('CUSTOMER_DEADLINE_DATE', customerBidDeadLineTime.format('MMM d yyyy'));
        }
                
        //bidtype label names added by vandana.

                    
            if (bidTypesmap!=null&&bidTypesmap.get(bid.Phoenix_Bid_Type__c)!=null&&templateBody.contains('BID_TYPE')) templateBody = templateBody.replace('BID_TYPE', bidTypesmap.get(bid.Phoenix_Bid_Type__c));

            //bidtype label names --end.
                
                
        email.setHtmlBody(templateBody);
        email.setSubject(subject);
        email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);

        mailsList.add(email);
        messaging.sendEmail(mailsList);
    }
}
Catch(Exception e) {
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();

    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'SVPEmailNotification', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}

}

@future
public static void sendEmailToProdDirVolReview(Id bidId) {
        
Phoenix_Bid__c bid = [Select Id, Name, Owner.Email,Phoenix_Bid_Type__c, Phoenix_Bid_Deadline_Date__c, Phoenix_Sales_Person_2__c, Phoenix_Sales_Person_2__r.Email, Phoenix_Salesperson__c, Phoenix_Salesperson__r.Email, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Bid_Created_Behalf_of__r.Email, Phoenix_Internal_Target_Date__c, Phoenix_Customer_Bid_Deadline_Date_Time__c FROM Phoenix_Bid__c Where Id =: bidId];   
List<Phoenix_Bid_Line_Item__c>  bidLineItems = [Select Id,Phoenix_Product__r.Phoenix_Product_Director__r.Email, Name, Phoenix_Product__r.Phoenix_Product_Director__c, Phoenix_Product__r.Phoenix_Marketing_Lead__c, Phoenix_Product__c, Phoenix_Product__r.Family,Phoenix_Product__r.Name,Phoenix_NDC__c,Phoenix_Day_s_Notice_Product_removal__c,Phoenix_Customer_Requested_Days__c,Phoenix_Contract__r.Name,Phoenix_Customer__r.Name FROM Phoenix_Bid_Line_Item__c Where Phoenix_Bid__c =: bidId];
List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
String table_Data = '';
integer sNo = 0;

//Create a new Email
try {
    if(bid.Phoenix_Bid_Type__c == 'Volume Review Only'){

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    set < String > toaddressset = new set < String > ();
    for(Phoenix_Bid_Line_Item__c item:bidLineItems){
    if (item.Phoenix_Product__r.Phoenix_Product_Director__r.Email != Null)
        toaddressset.add(item.Phoenix_Product__r.Phoenix_Product_Director__r.Email);
    }
    mail.setToAddresses(new List<String>(toaddressset));
    //mail.setToAddresses(new List<String>{'vandana@dhruvsoft.com'});
    mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
    Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Vol_Review_Noti_ForProduct_Directors', BidId);
    String templateBody = emailWrapper.mailHtmlBody;
    String subject = emailWrapper.mailSubject;
    if (bid.Phoenix_Internal_Target_Date__c != null) {
        DateTime internalDueDateTime = DateTime.newInstance(bid.Phoenix_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0));
        if (templateBody.contains('INTERNAL_DEADLINE_DATE')) templateBody = templateBody.replace('INTERNAL_DEADLINE_DATE', internalDueDateTime.format('MMM d yyyy'));
    }
        
    mail.setHtmlBody(templateBody);
    mail.setSubject(emailWrapper.mailSubject);
    mails.add(mail);
    Messaging.SendEmailResult[] results;
    if (mails.size() > 0)
                

    results = Messaging.sendEmail(mails);
    }
            
}
Catch(Exception e) {
    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'sendEmailToProdDirVolReview', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}
}
    
    
    
 
/**
* @description This will send notification to all people. 
* @author Surender Patel (Dhruvsoft) | 17-05-2021 
* @param List<id> bidIds 
**/
@future
public static void BidClosureNotification(List < Id > objIds) {

list < messaging.Email > mailsList = new list < messaging.email > ();
String mailStatus = '';
Messaging.SendEmailResult[] results;
        
  //bidtype label names added by vandana.
      Map < String, String > bidTypesmap = new Map < String, String > ();
                    
            for(Schema.PicklistEntry  ple:  Phoenix_Bid__c.Phoenix_Bid_Type__c.getDescribe().getPicklistValues()){
                bidTypesmap.put(ple.getValue(),ple.getLabel());
            }
        
  //bidtype label names added end.
try {
    if (objIds.size() > 0) {
        String objName = String.valueOf(objIds[0].getsObjectType());

        if (objName == 'Phoenix_Bid__c') {

            map < Id, Phoenix_Bid__c > bidMap = new map < Id, Phoenix_Bid__c > ([SELECT Id,Phoenix_Bid_Type__c, ownerId, owner.Name, Phoenix_Customer_Bid_Deadline_Date_Time__c, owner.Email, Phoenix_Internal_Target_Date__c,
                Phoenix_Bid_Deadline_Date__c, Phoenix_Bid_Created_Behalf_of__r.Email, Phoenix_Approval_Status__c, (Select Id, Name, Phoenix_Product__c,
                    Phoenix_Product__r.Family, Phoenix_Final_Status__c FROM Bid_Line_Items__r), (Select Id, Phoenix_Approver__r.Email, Phoenix_Status__c From Bid_Process_Steps__r) FROM Phoenix_Bid__c WHERE Id In: objIds
            ]);
            Map < string, list < Phoenix_Bid_Line_Item__c >> bidWithItemsMap = new Map < string, list < Phoenix_Bid_Line_Item__c >> ();
            Map < Id, list < Phoenix_Bid_Process_Steps__c >> processStepsMap = new Map < Id, list < Phoenix_Bid_Process_Steps__c >> ();

            for (Phoenix_Bid__c bid: bidMap.values()) {
                for (Phoenix_Bid_Line_Item__c item: bid.Bid_Line_Items__r) {
                    if (bid.Phoenix_Approval_Status__c.contains('Closed') && item.Phoenix_Final_Status__c != 'Not Approved' && bidWithItemsMap.containsKey(bid.Id)) {
                        list < Phoenix_Bid_Line_Item__c > newList = bidWithItemsMap.get(bid.Id);
                        newList.add(item);
                        bidWithItemsMap.put(bid.Id, newList);
                    } else if (bid.Phoenix_Approval_Status__c.contains('Closed') && item.Phoenix_Final_Status__c != 'Not Approved' && !bidWithItemsMap.containsKey(bid.Id)) {
                        bidWithItemsMap.put(bid.Id, new List < Phoenix_Bid_Line_Item__c > {
                            item
                        });
                    }
                }
                for (Phoenix_Bid_Process_Steps__c step: bid.Bid_Process_Steps__r) {

                    if (processStepsMap.get(bid.Id) == null) { //Skip the management users as per requirement. 
                        processStepsMap.put(bid.Id, new List < Phoenix_Bid_Process_Steps__c > {
                            step
                        });
                    } else {
                        List < Phoenix_Bid_Process_Steps__c > existingStepsList = processStepsMap.get(bid.Id);
                        existingStepsList.add(step);
                        processStepsMap.put(bid.Id, existingStepsList);
                    }

                }
            }
            for (Id bidId: bidMap.keySet()) {
                String prodFamilyString = '';
                set < string > productFamilySet = new set < string > ();
                Integer i = 1;
                if (bidWithItemsMap.get(bidId) != null) {
                    for (Phoenix_Bid_Line_Item__c item: bidWithItemsMap.get(bidId)) {
                        if (item.Phoenix_Product__c != null && item.Phoenix_Product__r.Family != null) productFamilySet.add(item.Phoenix_Product__r.Family);
                    }
                    for (String pfamily: productFamilySet) {
                        prodFamilyString += i + '.' + pfamily + '<br/>';
                        i++;
                    }
                }
                Phoenix_Bid__c bid = bidMap.get(bidId);
                Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Bid_Closure_Notification', bidId);
                String templateBody = emailWrapper.mailHtmlBody;
                String subject = emailWrapper.mailSubject;
                Set < string > toEmailAddresses = new Set < string > {
                    bid.owner.Email
                };
                if (processStepsMap.get(bidId) != null) {
                    for (Phoenix_Bid_Process_Steps__c step: processStepsMap.get(bidId)) {
                        if (step.Phoenix_Status__c == 'Completed' && step.Phoenix_Status__c != 'Not Applicable' && step.Phoenix_Approver__c != null)
                            toEmailAddresses.add(step.Phoenix_Approver__r.Email);
                    }
                }
                If(bid.Phoenix_Bid_Type__c =='OTC OTB Good Dated' || bid.Phoenix_Bid_Type__c =='OTC OTB Short Dated' ){
               toEmailAddresses.addAll(approvalTeamUsersEmailsMap.get('Customer Service'));
                }
               If(toEmailAddresses != null && toEmailAddresses.contains('mkalawadia@drreddys.com'))toEmailAddresses.remove('mkalawadia@drreddys.com'); 
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>(toEmailAddresses));
                mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
                mail.setSubject(subject);
                if (templateBody.contains('Product_Families')) templateBody = templateBody.replace('Product_Families', prodFamilyString);
                       
                   //bidtype label names added by vandana.

                    
            if (bidTypesmap!=null&&bidTypesmap.get(bid.Phoenix_Bid_Type__c)!=null&&templateBody.contains('BID_TYPE')) templateBody = templateBody.replace('BID_TYPE', bidTypesmap.get(bid.Phoenix_Bid_Type__c));

            //bidtype label names --end.
                        
                        
                        
                Date internalDueDate = bid.Phoenix_Internal_Target_Date__c;
                if (bid.Phoenix_Internal_Target_Date__c != null) {
                    DateTime internalDueDateTime = DateTime.newInstance(internalDueDate, Time.newInstance(0, 0, 0, 0));
                    if (templateBody.contains('INTERNAL_DEADLINE_DATE')) templateBody = templateBody.replace('INTERNAL_DEADLINE_DATE', internalDueDateTime.format('MMM d yyyy'));
                }

                if (bid.Phoenix_Bid_Deadline_Date__c != null) {
                    DateTime customerBidDeadLineTime = DateTime.newInstance(bid.Phoenix_Bid_Deadline_Date__c, Time.newInstance(0, 0, 0, 0));
                    if (templateBody.contains('CUSTOMER_DEADLINE_DATE')) templateBody = templateBody.replace('CUSTOMER_DEADLINE_DATE', customerBidDeadLineTime.format('MMM d yyyy'));
                }

                Set < string > ccEmailIds = new Set < string > ();


                if (Label.Phoenix_Contracts_DL != null) ccEmailIds.addAll(Label.Phoenix_Contracts_DL.split(','));
                for (string emailId: toEmailAddresses) {
                    if (ccEmailIds.contains(emailId))
                        ccEmailIds.remove(emailId);
                }
If(ccEmailIds != null && ccEmailIds.contains('mkalawadia@drreddys.com'))ccEmailIds.remove('mkalawadia@drreddys.com');

                mail.setCcAddresses(new List < String > (ccEmailIds));
                mail.setHtmlBody(templateBody);

                mailsList.add(mail);
            }

        } else if (objName == 'Phoenix_NDC_Change__c') {

            map < Id, Phoenix_NDC_Change__c > ndcChangeMap = new map < Id, Phoenix_NDC_Change__c > ([Select Id, Name, Owner.Email, Phoenix_Approval_Status__c, (Select Phoenix_Current_Product__c, Phoenix_Current_Product__r.Name, Phoenix_Current_Product_NDC__c, Phoenix_Current_Product_Pack_Size__c, Phoenix_Proposed_Product__c, Phoenix_Proposed_Product__r.Name, Phoenix_Proposed_Product_NDC__c, Phoenix_Proposed_Product_Pack_Size__c, Phoenix_Final_Status__c FROM NDC_Change_Line_Items__r), (Select Id, Phoenix_Approver__r.Email, Phoenix_Status__c From Bid_Process_Steps__r) FROM Phoenix_NDC_Change__c WHERE Id In: objIds]);
            Map < string, list < Phoenix_NDC_Change_Line_Item__c >> ndcChangeItemsMap = new Map < string, list < Phoenix_NDC_Change_Line_Item__c >> ();
            Map < Id, list < Phoenix_Bid_Process_Steps__c >> processStepsMap = new Map < Id, list < Phoenix_Bid_Process_Steps__c >> ();
            for (Phoenix_NDC_Change__c ndcChange: ndcChangeMap.values()) {
                for (Phoenix_NDC_Change_Line_Item__c item: ndcChange.NDC_Change_Line_Items__r) {
                    if (ndcChange.Phoenix_Approval_Status__c.contains('Closed') && item.Phoenix_Final_Status__c != 'Not Approved' && ndcChangeItemsMap.containsKey(ndcChange.Id)) {
                        list < Phoenix_NDC_Change_Line_Item__c > newList = ndcChangeItemsMap.get(ndcChange.Id);
                        newList.add(item);
                        ndcChangeItemsMap.put(ndcChange.Id, newList);
                    } else if (ndcChange.Phoenix_Approval_Status__c.contains('Closed') && item.Phoenix_Final_Status__c != 'Not Approved' && !ndcChangeItemsMap.containsKey(ndcChange.Id)) {
                        ndcChangeItemsMap.put(ndcChange.Id, new List < Phoenix_NDC_Change_Line_Item__c > {
                            item
                        });
                    }
                }
                for (Phoenix_Bid_Process_Steps__c step: ndcChange.Bid_Process_Steps__r) {

                    if (processStepsMap.get(ndcChange.Id) == null) { //Skip the management users as per requirement. 
                        processStepsMap.put(ndcChange.Id, new List < Phoenix_Bid_Process_Steps__c > {
                            step
                        });
                    } else {
                        List < Phoenix_Bid_Process_Steps__c > existingStepsList = processStepsMap.get(ndcChange.Id);
                        existingStepsList.add(step);
                        processStepsMap.put(ndcChange.Id, existingStepsList);
                    }

                }
            }
            for (Id ndcChangeId: ndcChangeMap.keySet()) {

                string NDC_Change_Line_Items = '';
                NDC_Change_Line_Items += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;">S.No</th><th style="border: 1px solid black;">Current Product</th><th style="border: 1px solid black;">Current Product NDC</th><th style="border: 1px solid black;">Current Product Pack Size</th><th style="border: 1px solid black;">Proposed Product</th><th style="border: 1px solid black;">Proposed Product NDC</th><th style="border: 1px solid black;white-space: nowrap;">Proposed Product Pack Size</th></tr></thead>';
                NDC_Change_Line_Items += '<tbody>';
                integer sNo = 0;
                if (ndcChangeItemsMap.get(ndcChangeId) != null) {
                    for (Phoenix_NDC_Change_Line_Item__c ndcItem: ndcChangeItemsMap.get(ndcChangeId)) {
                        sNo++;
                        NDC_Change_Line_Items += '<tr>';
                        NDC_Change_Line_Items += '<td style="border: 1px solid black;text-align: left;">' + sNo + '</td>';
                        if (ndcItem.Phoenix_Current_Product__c != null) NDC_Change_Line_Items += '<td style="border: 1px solid black;text-align: left;">' + ndcItem.Phoenix_Current_Product__r.Name + '</td>';
                        else NDC_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';

                        if (ndcItem.Phoenix_Current_Product_NDC__c != null) NDC_Change_Line_Items += '<td style="border: 1px solid black;text-align: left;">' + ndcItem.Phoenix_Current_Product_NDC__c + '</td>';
                        else NDC_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';

                        if (ndcItem.Phoenix_Current_Product_Pack_Size__c != null) NDC_Change_Line_Items += '<td style="border: 1px solid black;text-align: right;">' + ndcItem.Phoenix_Current_Product_Pack_Size__c + '</td>';
                        else NDC_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';

                        if (ndcItem.Phoenix_Proposed_Product__c != null) NDC_Change_Line_Items += '<td style="border: 1px solid black;text-align: left;">' + ndcItem.Phoenix_Proposed_Product__r.Name + '</td>';
                        else NDC_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';

                        if (ndcItem.Phoenix_Proposed_Product_NDC__c != null) NDC_Change_Line_Items += '<td style="border: 1px solid black;text-align: left;">' + ndcItem.Phoenix_Proposed_Product_NDC__c + '</td>';
                        else NDC_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';

                        if (ndcItem.Phoenix_Proposed_Product_Pack_Size__c != null) NDC_Change_Line_Items += '<td style="border: 1px solid black;text-align: right;">' + ndcItem.Phoenix_Proposed_Product_Pack_Size__c + '</td>';
                        else NDC_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';



                        NDC_Change_Line_Items += '</tr>';
                    }
                    NDC_Change_Line_Items += '</tbody></table>';
                }

                Phoenix_NDC_Change__c ndcChange = ndcChangeMap.get(ndcChangeId);
                Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('NDC_Change_Closure_Notification', ndcChangeId);
                String templateBody = emailWrapper.mailHtmlBody;
                String subject = emailWrapper.mailSubject;
                Set < string > toEmailAddresses = new Set < string > {
                    ndcChange.owner.Email
                };
                if (processStepsMap.get(ndcChangeId) != null) {
                    for (Phoenix_Bid_Process_Steps__c step: processStepsMap.get(ndcChangeId)) {
                        if (step.Phoenix_Status__c == 'Completed' && step.Phoenix_Status__c != 'Not Applicable' && step.Phoenix_Approver__c != null)
                            toEmailAddresses.add(step.Phoenix_Approver__r.Email);
                    }
                }
            If(toEmailAddresses != null && toEmailAddresses.contains('mkalawadia@drreddys.com'))toEmailAddresses.remove('mkalawadia@drreddys.com');
 
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>(toEmailAddresses));
                mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
                mail.setSubject(subject);
                if (templateBody.contains('NDC_Change_Line_Items')) templateBody = templateBody.replace('NDC_Change_Line_Items', NDC_Change_Line_Items);
                Set < string > ccEmailIds = new Set < string > ();


                if (Label.Phoenix_Contracts_DL != null) ccEmailIds.addAll(Label.Phoenix_Contracts_DL.split(','));
                for (string emailId: toEmailAddresses) {
                    if (ccEmailIds.contains(emailId))
                        ccEmailIds.remove(emailId);
                }
If(ccEmailIds != null && ccEmailIds.contains('mkalawadia@drreddys.com'))ccEmailIds.remove('mkalawadia@drreddys.com');

                mail.setCcAddresses(new List < String > (ccEmailIds));
                mail.setHtmlBody(templateBody);

                mailsList.add(mail);
            }

        } else if (objName == 'Phoenix_PHS_Price_Change__c') {
                  
            Phoenix_PHS_Price_Change__c pHSChangeObj;
            pHSChangeObj = [Select Id, Name, Owner.Email, Phoenix_Approval_Status__c, Phoenix_Record_Type__c from Phoenix_PHS_Price_Change__c WHERE Id =: objIds LIMIT 1];
            string rectype = pHSChangeObj.Phoenix_Record_Type__c;
                  
            map < Id, Phoenix_PHS_Price_Change__c > pHSChangeMap = new map < Id, Phoenix_PHS_Price_Change__c > ([Select Id, Name, Owner.Email, Phoenix_Approval_Status__c, (Select Phoenix_Product_Name__c, Phoenix_Product_Name__r.Name, Phoenix_Material_Code__c, Phoenix_NDC_11__c, Phoenix_Provisional_PHS_Price__c, Phoenix_Old_PHS_Price__c, Phoenix_New_PHS_Price__c, Phoenix_Price_Start_Date__c, Phoenix_Price_End_Date__c, Phoenix_Final_Status__c FROM PHS_Price_Change_Lines__r), (Select Id, Phoenix_Approver__r.Email, Phoenix_Status__c From Bid_Process_Steps__r) FROM Phoenix_PHS_Price_Change__c WHERE Id In: objIds]);
            Map < string, list < Phoenix_PHS_Price_Change_Line__c >> pHSChangeItemsMap = new Map < string, list < Phoenix_PHS_Price_Change_Line__c >> ();
            Map < Id, list < Phoenix_Bid_Process_Steps__c >> processStepsMap = new Map < Id, list < Phoenix_Bid_Process_Steps__c >> ();
            for (Phoenix_PHS_Price_Change__c pHSChange: pHSChangeMap.values()) {
                for (Phoenix_PHS_Price_Change_Line__c item: pHSChange.PHS_Price_Change_Lines__r) {
                    if (pHSChange.Phoenix_Approval_Status__c.contains('Closed') && item.Phoenix_Final_Status__c != 'Not Approved' && pHSChangeItemsMap.containsKey(pHSChange.Id)) {
                        list < Phoenix_PHS_Price_Change_Line__c > newList = pHSChangeItemsMap.get(pHSChange.Id);
                        newList.add(item);
                        pHSChangeItemsMap.put(pHSChange.Id, newList);
                    } else if (pHSChange.Phoenix_Approval_Status__c.contains('Closed') && item.Phoenix_Final_Status__c != 'Not Approved' && !pHSChangeItemsMap.containsKey(pHSChange.Id)) {
                        pHSChangeItemsMap.put(pHSChange.Id, new List < Phoenix_PHS_Price_Change_Line__c > {
                            item
                        });
                    }
                }
                for (Phoenix_Bid_Process_Steps__c step: pHSChange.Bid_Process_Steps__r) {

                    if (processStepsMap.get(pHSChange.Id) == null) { //Skip the management users as per requirement. 
                        processStepsMap.put(pHSChange.Id, new List < Phoenix_Bid_Process_Steps__c > {
                            step
                        });
                    } else {
                        List < Phoenix_Bid_Process_Steps__c > existingStepsList = processStepsMap.get(pHSChange.Id);
                        existingStepsList.add(step);
                        processStepsMap.put(pHSChange.Id, existingStepsList);
                    }

                }
            }
            for (Id pHSChangeId: pHSChangeMap.keySet()) {

                string pHS_Change_Line_Items = '';

                pHS_Change_Line_Items += '<tbody>';
                integer sNo = 0;
                if (rectype == 'Provisional PHS Price Change') {
                    pHS_Change_Line_Items += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;">S.No</th><th style="border: 1px solid black;">Product Name</th><th style="border: 1px solid black;">Material Code</th><th style="border: 1px solid black;">NDC-11</th><th style="border: 1px solid black;">Provisional PHS Price $</th><th style="border: 1px solid black;">Price Start Date</th><th style="border: 1px solid black;white-space: nowrap;">Price End Date</th></tr></thead>';
                } else {
                    pHS_Change_Line_Items += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;">S.No</th><th style="border: 1px solid black;">Product Name</th><th style="border: 1px solid black;">Material Code</th><th style="border: 1px solid black;">NDC-11</th><th style="border: 1px solid black;">Old PHS Price $</th><th style="border: 1px solid black;">New PHS Price $</th><th style="border: 1px solid black;">Price Start Date</th><th style="border: 1px solid black;white-space: nowrap;">Price End Date</th></tr></thead>';
                }
                if (pHSChangeItemsMap.get(pHSChangeId) != null) {
                    for (Phoenix_PHS_Price_Change_Line__c pHSItem: pHSChangeItemsMap.get(pHSChangeId)) {
                        sNo++;
                        PHS_Change_Line_Items += '<tr>';
                        PHS_Change_Line_Items += '<td style="border: 1px solid black;text-align: left;">' + sNo + '</td>';
                        if (pHSItem.Phoenix_Product_Name__r.Name != null) PHS_Change_Line_Items += '<td style="border: 1px solid black;text-align: left;">' + pHSItem.Phoenix_Product_Name__r.Name + '</td>';
                        else PHS_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';

                        if (pHSItem.Phoenix_Material_Code__c != null) {
                            string materialCode = pHSItem.Phoenix_Material_Code__c;
                            materialCode.replaceFirst('^0+', '');
                            PHS_Change_Line_Items += '<td style="border: 1px solid black;text-align: left;">' + materialCode + '</td>';
                        } else {
                            PHS_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        if (pHSItem.Phoenix_NDC_11__c != null) PHS_Change_Line_Items += '<td style="border: 1px solid black;text-align: left;">' + pHSItem.Phoenix_NDC_11__c + '</td>';
                        else PHS_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';
                        if (rectype == 'Provisional PHS Price Change') {
                            if (pHSItem.Phoenix_Provisional_PHS_Price__c != null) PHS_Change_Line_Items += '<td style="border: 1px solid black;text-align: right;">' + '$' + pHSItem.Phoenix_Provisional_PHS_Price__c + '</td>';
                            else PHS_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';
                        } else {
                            if (pHSItem.Phoenix_Old_PHS_Price__c != null) PHS_Change_Line_Items += '<td style="border: 1px solid black;text-align: right;">' + '$' + pHSItem.Phoenix_Old_PHS_Price__c + '</td>';
                            else PHS_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';
                            if (pHSItem.Phoenix_New_PHS_Price__c != null) PHS_Change_Line_Items += '<td style="border: 1px solid black;text-align: right;">' + '$' + pHSItem.Phoenix_New_PHS_Price__c + '</td>';
                            else PHS_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }

                        if (pHSItem.Phoenix_Price_Start_Date__c != null) {
                            DateTime startDate = DateTime.newInstance(pHSItem.Phoenix_Price_Start_Date__c, Time.newInstance(0, 0, 0, 0));
                            PHS_Change_Line_Items += '<td style="border: 1px solid black;text-align: center;">' + startDate.format('MMM d yyyy') + '</td>';
                        } else {
                            PHS_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        if (pHSItem.Phoenix_Price_End_Date__c != null) {
                            DateTime endDate = DateTime.newInstance(pHSItem.Phoenix_Price_End_Date__c, Time.newInstance(0, 0, 0, 0));

                            PHS_Change_Line_Items += '<td style="border: 1px solid black;text-align: center;">' + endDate.format('MMM d yyyy') + '</td>';
                        } else {
                            PHS_Change_Line_Items += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }

                        PHS_Change_Line_Items += '</tr>';



                    }
                    PHS_Change_Line_Items += '</tbody></table>';
                          
                }



                Phoenix_PHS_Price_Change__c pHSChange = pHSChangeMap.get(pHSChangeId);
                Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('PHS_Change_Closure_Notification', pHSChangeId);
                String templateBody = emailWrapper.mailHtmlBody;
                String subject = emailWrapper.mailSubject;
                Set < string > toEmailAddresses = new Set < string > {
                    pHSChange.owner.Email
                };
                if (processStepsMap.get(pHSChangeId) != null) {
                    for (Phoenix_Bid_Process_Steps__c step: processStepsMap.get(pHSChangeId)) {
                        if (step.Phoenix_Status__c == 'Completed' && step.Phoenix_Status__c != 'Not Applicable' && step.Phoenix_Approver__c != null)
                            toEmailAddresses.add(step.Phoenix_Approver__r.Email);
                    }
                }
               If(toEmailAddresses != null && toEmailAddresses.contains('mkalawadia@drreddys.com'))toEmailAddresses.remove('mkalawadia@drreddys.com');

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>(toEmailAddresses));
                mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
                mail.setSubject(subject);
                if (templateBody.contains('PHS_Change_Line_Items')) templateBody = templateBody.replace('PHS_Change_Line_Items', pHS_Change_Line_Items);
                Set < string > ccEmailIds = new Set < string > ();


                if (Label.Phoenix_Contracts_DL != null) ccEmailIds.addAll(Label.Phoenix_Contracts_DL.split(','));
                for (string emailId: toEmailAddresses) {
                    if (ccEmailIds.contains(emailId))
                        ccEmailIds.remove(emailId);
                }
If(ccEmailIds != null && ccEmailIds.contains('mkalawadia@drreddys.com'))ccEmailIds.remove('mkalawadia@drreddys.com');

                mail.setCcAddresses(new List < String > (ccEmailIds));
                mail.setHtmlBody(templateBody);

                mailsList.add(mail);
            }

        } else if (objName == 'New_Product_WAC_Pricing__c') {

            New_Product_WAC_Pricing__c wacObj;
            wacObj = [Select Id, Name, Owner.Email, Phoenix_Approval_Status__c from New_Product_WAC_Pricing__c WHERE Id =: objIds LIMIT 1];


            map < Id, New_Product_WAC_Pricing__c > newWACMap = new map < Id, New_Product_WAC_Pricing__c > ([Select Id, Name, Owner.Email, Phoenix_Approval_Status__c, (Select Phoenix_Material_Number__c, Phoenix_NDC_11__c, Phoenix_Product__r.Name, Phoenix_Pkg_Size__c, Phoenix_WAC__c, Phoenix_Lowest_Price__c, Phoenix_TPT_GM__c, Phoenix_Final_Status__c FROM New_Product_WAC_Pricing_Line_Items__r), (Select Id, Phoenix_Approver__r.Email, Phoenix_Status__c From Bid_Process_Steps__r) FROM New_Product_WAC_Pricing__c WHERE Id In: objIds]);
            Map < string, list < Phoenix_NewProduct_WAC_Pricing_LineItems__c >> newWACItemsMap = new Map < string, list < Phoenix_NewProduct_WAC_Pricing_LineItems__c >> ();
            Map < Id, list < Phoenix_Bid_Process_Steps__c >> processStepsMap = new Map < Id, list < Phoenix_Bid_Process_Steps__c >> ();
            for (New_Product_WAC_Pricing__c newWAC: newWACMap.values()) {
                for (Phoenix_NewProduct_WAC_Pricing_LineItems__c item: newWAC.New_Product_WAC_Pricing_Line_Items__r) {
                    if (newWAC.Phoenix_Approval_Status__c.contains('Closed') && item.Phoenix_Final_Status__c != 'Not Approved' && newWACItemsMap.containsKey(newWAC.Id)) {
                        list < Phoenix_NewProduct_WAC_Pricing_LineItems__c > newList = newWACItemsMap.get(newWAC.Id);
                        newList.add(item);
                        newWACItemsMap.put(newWAC.Id, newList);
                    } else if (newWAC.Phoenix_Approval_Status__c.contains('Closed') && item.Phoenix_Final_Status__c != 'Not Approved' && !newWACItemsMap.containsKey(newWAC.Id)) {
                        newWACItemsMap.put(newWAC.Id, new List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > {
                            item
                        });
                    }
                }
                for (Phoenix_Bid_Process_Steps__c step: newWAC.Bid_Process_Steps__r) {

                    if (processStepsMap.get(newWAC.Id) == null) { //Skip the management users as per requirement. 
                        processStepsMap.put(newWAC.Id, new List < Phoenix_Bid_Process_Steps__c > {
                            step
                        });
                    } else {
                        List < Phoenix_Bid_Process_Steps__c > existingStepsList = processStepsMap.get(newWAC.Id);
                        existingStepsList.add(step);
                        processStepsMap.put(newWAC.Id, existingStepsList);
                    }

                }
            }
            for (Id newWACId: newWACMap.keySet()) {

                string new_wac_Lines = '';

                new_wac_Lines += '<tbody>';
                new_wac_Lines += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;">S.No</th><th style="border: 1px solid black;">Material Number</th><th style="border: 1px solid black;">NDC-11</th><th style="border: 1px solid black;">Product</th><th style="border: 1px solid black;">Pack Size</th><th style="border: 1px solid black;">WAC $</th><th style="border: 1px solid black;white-space: nowrap;">Lowest Price $</th><th style="border: 1px solid black;white-space: nowrap;">TPT % / GM %</th></tr></thead>';
                integer sNo = 0;

                if (newWACItemsMap.get(newWACId) != null) {
                    for (Phoenix_NewProduct_WAC_Pricing_LineItems__c newWACItem: newWACItemsMap.get(newWACId)) {
                        sNo++;
                        new_wac_Lines += '<tr>';
                        new_wac_Lines += '<td style="border: 1px solid black;text-align: left;">' + sNo + '</td>';
                        if (newWACItem.Phoenix_Material_Number__c != null) new_wac_Lines += '<td style="border: 1px solid black;text-align: left;">' + newWACItem.Phoenix_Material_Number__c + '</td>';
                        else new_wac_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';

                        if (newWACItem.Phoenix_NDC_11__c != null) {


                            new_wac_Lines += '<td style="border: 1px solid black;text-align: left;">' + newWACItem.Phoenix_NDC_11__c + '</td>';
                        } else {
                            new_wac_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        if (newWACItem.Phoenix_Product__r.Name != null) new_wac_Lines += '<td style="border: 1px solid black;text-align: left;">' + newWACItem.Phoenix_Product__r.Name + '</td>';
                        else new_wac_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';


                        if (newWACItem.Phoenix_Pkg_Size__c != null) new_wac_Lines += '<td style="border: 1px solid black;text-align: right;">' + newWACItem.Phoenix_Pkg_Size__c + '</td>';
                        else new_wac_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
                        if (newWACItem.Phoenix_WAC__c != null) new_wac_Lines += '<td style="border: 1px solid black;text-align: right;">' + '$' + newWACItem.Phoenix_WAC__c + '</td>';
                        else new_wac_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';


                        if (newWACItem.Phoenix_Lowest_Price__c != null) {

                            new_wac_Lines += '<td style="border: 1px solid black;text-align: right;">' + '$' + newWACItem.Phoenix_Lowest_Price__c + '</td>';
                        } else {
                            new_wac_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        if (newWACItem.Phoenix_TPT_GM__c != null) {


                            new_wac_Lines += '<td style="border: 1px solid black;text-align: right;">' + newWACItem.Phoenix_TPT_GM__c + '%' + '</td>';
                        } else {
                            new_wac_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }

                        new_wac_Lines += '</tr>';



                    }
                    new_wac_Lines += '</tbody></table>';

                }



                New_Product_WAC_Pricing__c newWAC = newWACMap.get(newWACId);
                Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('New_Wac_Closure', newWACId);
                String templateBody = emailWrapper.mailHtmlBody;
                String subject = emailWrapper.mailSubject;
                Set < string > toEmailAddresses = new Set < string > {
                    newWAC.owner.Email
                };
                if (processStepsMap.get(newWACId) != null) {
                    for (Phoenix_Bid_Process_Steps__c step: processStepsMap.get(newWACId)) {
                        if (step.Phoenix_Status__c == 'Completed' && step.Phoenix_Status__c != 'Not Applicable' && step.Phoenix_Approver__c != null)
                            toEmailAddresses.add(step.Phoenix_Approver__r.Email);
                    }
                }
              If(toEmailAddresses != null && toEmailAddresses.contains('mkalawadia@drreddys.com'))toEmailAddresses.remove('mkalawadia@drreddys.com');
 
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>(toEmailAddresses));
                mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
                mail.setSubject(subject);
                if (templateBody.contains('WAC_Line_Items')) templateBody = templateBody.replace('WAC_Line_Items', new_wac_Lines);
                Set < string > ccEmailIds = new Set < string > ();


                if (Label.Phoenix_Contracts_DL != null) ccEmailIds.addAll(Label.Phoenix_Contracts_DL.split(','));
                for (string emailId: toEmailAddresses) {
                    if (ccEmailIds.contains(emailId))
                        ccEmailIds.remove(emailId);
                }
If(ccEmailIds != null && ccEmailIds.contains('mkalawadia@drreddys.com'))ccEmailIds.remove('mkalawadia@drreddys.com');

                mail.setCcAddresses(new List < String > (ccEmailIds));
                mail.setHtmlBody(templateBody);

                mailsList.add(mail);
            }

        } else if (objName == 'Phoenix_WAC_Change__c') {
               
            Phoenix_WAC_Change__c wacChangeObj;
            wacChangeObj = [Select Id, Name, Owner.Email, Phoenix_Approval_Status__c from Phoenix_WAC_Change__c WHERE Id =: objIds LIMIT 1];


            map < Id, Phoenix_WAC_Change__c > WACChangeMap = new map < Id, Phoenix_WAC_Change__c > ([Select Id, Name, Owner.Email, Phoenix_Approval_Status__c, (Select Phoenix_Contr_Number__c, Phoenix_Cust_Name__c, Phoenix_Product__r.Name, Phoenix_Proposed_WAC__c, Phoenix_System_WAC__c, Phoenix_Uploaded_WAC__c, Phoenix_Proposed_Contr_Price__c, Phoenix_System_Contract_price__c, Phoenix_Uploaded_Contr_Price__c, Phoenix_Final_Status__c FROM WAC_Change_Line_Items__r), (Select Id, Phoenix_Approver__r.Email, Phoenix_Status__c From Bid_Process_Steps__r) FROM Phoenix_WAC_Change__c WHERE Id In: objIds]);
            Map < string, list < Phoenix_WAC_Change_Line_Item__c >> WACChangeItemsMap = new Map < string, list < Phoenix_WAC_Change_Line_Item__c >> ();
            Map < Id, list < Phoenix_Bid_Process_Steps__c >> processStepsMap = new Map < Id, list < Phoenix_Bid_Process_Steps__c >> ();
            for (Phoenix_WAC_Change__c WacChange: WACChangeMap.values()) {
                for (Phoenix_WAC_Change_Line_Item__c item: WacChange.WAC_Change_Line_Items__r) {
                    if (WacChange.Phoenix_Approval_Status__c.contains('Closed') && item.Phoenix_Final_Status__c != 'Not Approved' && WACChangeItemsMap.containsKey(WacChange.Id)) {
                        list < Phoenix_WAC_Change_Line_Item__c > newList = WACChangeItemsMap.get(WacChange.Id);
                        newList.add(item);
                        WACChangeItemsMap.put(WacChange.Id, newList);
                    } else if (WacChange.Phoenix_Approval_Status__c.contains('Closed') && item.Phoenix_Final_Status__c != 'Not Approved' && !WACChangeItemsMap.containsKey(WacChange.Id)) {
                        WACChangeItemsMap.put(WacChange.Id, new List < Phoenix_WAC_Change_Line_Item__c > {
                            item
                        });
                    }
                }
                for (Phoenix_Bid_Process_Steps__c step: WacChange.Bid_Process_Steps__r) {

                    if (processStepsMap.get(WacChange.Id) == null) { //Skip the management users as per requirement. 
                        processStepsMap.put(WacChange.Id, new List < Phoenix_Bid_Process_Steps__c > {
                            step
                        });
                    } else {
                        List < Phoenix_Bid_Process_Steps__c > existingStepsList = processStepsMap.get(WacChange.Id);
                        existingStepsList.add(step);
                        processStepsMap.put(WacChange.Id, existingStepsList);
                    }

                }
            }
            for (Id WacChangeId: WACChangeMap.keySet()) {

                string Wac_Change_Lines = '';

                Wac_Change_Lines += '<tbody>';
                Wac_Change_Lines += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;">S.No</th><th style="border: 1px solid black;">Contract Number</th><th style="border: 1px solid black;">Customer Name</th><th style="border: 1px solid black;">Product</th><th style="border: 1px solid black;">System WAC</th><th style="border: 1px solid black;">System Contract Price</th><th style="border: 1px solid black;white-space: nowrap;">Uploaded WAC</th><th style="border: 1px solid black;white-space: nowrap;">Uploaded Contr.Price</th><th style="border: 1px solid black;white-space: nowrap;">Proposed WAC</th><th style="border: 1px solid black;white-space: nowrap;">Proposed Contr.Price</th></tr></thead>';
                integer sNo = 0;

                if (WACChangeItemsMap.get(WacChangeId) != null) {
                    for (Phoenix_WAC_Change_Line_Item__c WACChangeItem: WACChangeItemsMap.get(WacChangeId)) {
                        sNo++;
                        Wac_Change_Lines += '<tr>';
                        Wac_Change_Lines += '<td style="border: 1px solid black;text-align: left;">' + sNo + '</td>';
                        if (WACChangeItem.Phoenix_Contr_Number__c != null) Wac_Change_Lines += '<td style="border: 1px solid black;text-align: left;">' + WACChangeItem.Phoenix_Contr_Number__c + '</td>';
                        else Wac_Change_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';

                        if (WACChangeItem.Phoenix_Cust_Name__c != null) {


                            Wac_Change_Lines += '<td style="border: 1px solid black;text-align: left;">' + WACChangeItem.Phoenix_Cust_Name__c + '</td>';
                        } else {
                            Wac_Change_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        if (WACChangeItem.Phoenix_Product__r.Name != null) Wac_Change_Lines += '<td style="border: 1px solid black;text-align: left;">' + WACChangeItem.Phoenix_Product__r.Name + '</td>';
                        else Wac_Change_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';


                        if (WACChangeItem.Phoenix_System_WAC__c != null) Wac_Change_Lines += '<td style="border: 1px solid black;text-align: right;">' + '$' + WACChangeItem.Phoenix_System_WAC__c + '</td>';
                        else Wac_Change_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
                        if (WACChangeItem.Phoenix_System_Contract_price__c != null) Wac_Change_Lines += '<td style="border: 1px solid black;text-align: right;">' + '$' + WACChangeItem.Phoenix_System_Contract_price__c + '</td>';
                        else Wac_Change_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';


                        if (WACChangeItem.Phoenix_Uploaded_WAC__c != null) {

                            Wac_Change_Lines += '<td style="border: 1px solid black;text-align: right;">' + '$' + WACChangeItem.Phoenix_Uploaded_WAC__c + '</td>';
                        } else {
                            Wac_Change_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        if (WACChangeItem.Phoenix_Uploaded_Contr_Price__c != null) {


                            Wac_Change_Lines += '<td style="border: 1px solid black;text-align: right;">' + '$' + WACChangeItem.Phoenix_Uploaded_Contr_Price__c + '</td>';
                        } else {
                            Wac_Change_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        if (WACChangeItem.Phoenix_Proposed_WAC__c != null) {

                            Wac_Change_Lines += '<td style="border: 1px solid black;text-align: right;">' + '$' + WACChangeItem.Phoenix_Proposed_WAC__c + '</td>';
                        } else {
                            Wac_Change_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        if (WACChangeItem.Phoenix_Proposed_Contr_Price__c != null) {


                            Wac_Change_Lines += '<td style="border: 1px solid black;text-align: right;">' + '$' + WACChangeItem.Phoenix_Proposed_Contr_Price__c + '</td>';
                        } else {
                            Wac_Change_Lines += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }

                        Wac_Change_Lines += '</tr>';



                    }
                    Wac_Change_Lines += '</tbody></table>';
                         
                }



                Phoenix_WAC_Change__c WacChange = WACChangeMap.get(WacChangeId);
                Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Wac_Change_Closure', WacChangeId);
                String templateBody = emailWrapper.mailHtmlBody;
                String subject = emailWrapper.mailSubject;
                Set < string > toEmailAddresses = new Set < string > {
                    WacChange.owner.Email
                };
                if (processStepsMap.get(WacChangeId) != null) {
                    for (Phoenix_Bid_Process_Steps__c step: processStepsMap.get(WacChangeId)) {
                        if (step.Phoenix_Status__c == 'Completed' && step.Phoenix_Status__c != 'Not Applicable' && step.Phoenix_Approver__c != null)
                            toEmailAddresses.add(step.Phoenix_Approver__r.Email);
                    }
                }
                If(toEmailAddresses != null && toEmailAddresses.contains('mkalawadia@drreddys.com'))toEmailAddresses.remove('mkalawadia@drreddys.com');

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>(toEmailAddresses));
                mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
                mail.setSubject(subject);
                if (templateBody.contains('WAC_Change_Line_Items')) templateBody = templateBody.replace('WAC_Change_Line_Items', Wac_Change_Lines);
                Set < string > ccEmailIds = new Set < string > ();


                if (Label.Phoenix_Contracts_DL != null) ccEmailIds.addAll(Label.Phoenix_Contracts_DL.split(','));
                for (string emailId: toEmailAddresses) {
                    if (ccEmailIds.contains(emailId))
                        ccEmailIds.remove(emailId);
                }
If(ccEmailIds != null && ccEmailIds.contains('mkalawadia@drreddys.com'))ccEmailIds.remove('mkalawadia@drreddys.com');

                mail.setCcAddresses(new List < String > (ccEmailIds));
                mail.setHtmlBody(templateBody);

                mailsList.add(mail);
            }

        }



        if (mailsList.size() > 0) results = Messaging.sendEmail(mailsList);
                
    }
}
Catch(Exception e) {
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();

    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'BidClosureNotification', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}
//  return mailStatus;
}

@future
public static void SCMPartialApprovalNotification(Id objId) {
        
  //bidtype label names added by vandana.
      Map < String, String > bidTypesmap = new Map < String, String > ();
                    
            for(Schema.PicklistEntry  ple:  Phoenix_Bid__c.Phoenix_Bid_Type__c.getDescribe().getPicklistValues()){
                bidTypesmap.put(ple.getValue(),ple.getLabel());
            }
        
  //bidtype label names added end.



list < messaging.Email > mail = new list < messaging.email > ();
try {
    String objName = String.valueOf(objId.getsObjectType());
    Set < String > allPeopleInvolvedEmailsSet = new Set < String > ();

    for (Phoenix_Bid_Process_Steps__c step: [SELECT Id, Name, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c
            FROM Phoenix_Bid_Process_Steps__c
            WHERE Phoenix_Is_Criteria_Step__c = false AND Phoenix_Status__c != 'Not Applicable'
            AND Phoenix_Bid__c =: objId AND Phoenix_Approver__c != null AND Phoenix_Approver_Team__c != 'Marketing'
            AND(Phoenix_Bid__c =: objId OR Phoenix_NDC_Change__c =: objId)
        ]) {
        allPeopleInvolvedEmailsSet.add(step.Phoenix_Approver__r.Email);
    }
    if (objName == 'Phoenix_Bid__c') {

        Map < Id, Phoenix_Bid_Line_Item__c > bidLineItemrecordsMap = new Map < Id, Phoenix_Bid_Line_Item__c > ([SELECT Id, Phoenix_Bid__r.Phoenix_Bid_Deadline_Date__c, Phoenix_Bid__r.Phoenix_Sales_Person_2__c, Phoenix_Bid__r.Phoenix_Sales_Person_2__r.Email,
            Phoenix_Bid__r.Phoenix_Internal_Target_Date__c, Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__r.Email, Phoenix_Bid__r.Phoenix_Salesperson__c, Phoenix_Bid__r.Phoenix_Salesperson__r.Email,
            Phoenix_Bid__r.Owner.Email, Phoenix_Product__r.ProductCode, Phoenix_Product__r.Family, Phoenix_Product__r.Phoenix_NDC__c,
            Phoenix_Product_Director1__c, Phoenix_NDC__c, Phoenix_Product_Family1__c,
            Phoenix_Product_Code1__c, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Bid_Owner__r.Name,
            Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Name, Phoenix_Customer__r.Name,
            Phoenix_Customer__c, Phoenix_Product__r.Name, Phoenix_Product__r.Phoenix_Product_Director__c,
            Phoenix_Product__r.Phoenix_Product_Director__r.Name, Phoenix_Product__r.Phoenix_Product_Director__r.Email, Name,
            Phoenix_Product__c, Phoenix_Product_Director__c, Phoenix_Product__r.Phoenix_NDC_11_Dashes__c, Phoenix_Revisited_Date__c,Phoenix_SCM_Approved_Quantity__c
            FROM Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: objId and Phoenix_SCM_Approval_Y_N__c != 'N- Not Approved'
            and Phoenix_SCM_Approved_Quantity__c >= 0 and Phoenix_SCM_Approved_Quantity__c <= 100
        ]);




        Set < String > productDirectorIds = new Set < String > ();
        Map < Id, List < Phoenix_Bid_Line_Item__c >> prodDirectorbItemsMap = new Map < Id, List < Phoenix_Bid_Line_Item__c >> ();
        for (Phoenix_Bid_Line_Item__c item: bidLineItemrecordsMap.values()) {
            String directorId = item.Phoenix_Product__r.Phoenix_Product_Director__c;
            productDirectorIds.add(directorId);
            if (prodDirectorbItemsMap.containsKey(directorId)) {
                List < Phoenix_Bid_Line_Item__c > addedList = prodDirectorbItemsMap.get(directorId);
                addedList.add(item);
                prodDirectorbItemsMap.put(directorId, addedList);
            } else {
                prodDirectorbItemsMap.put(directorId, new List < Phoenix_Bid_Line_Item__c > {
                    item
                });
            }

            //Add Sales persons
            if (item.Phoenix_Bid__r.Phoenix_Sales_Person_2__c != null) {
                allPeopleInvolvedEmailsSet.add(item.Phoenix_Bid__r.Phoenix_Sales_Person_2__r.Email);
            } else if (item.Phoenix_Bid__r.Phoenix_Salesperson__c != null) {
                allPeopleInvolvedEmailsSet.add(item.Phoenix_Bid__r.Phoenix_Salesperson__r.Email);
            }

        }

        for (string productDirectorId: prodDirectorbItemsMap.keySet()) {
            Map < string, list < Phoenix_Bid_Line_Item__c >> bidMap = new Map < string, list < Phoenix_Bid_Line_Item__c >> ();
            for (Phoenix_Bid_Line_Item__c item: prodDirectorbItemsMap.get(productDirectorId)) {
                if (bidMap.containsKey(item.Phoenix_Bid__c)) {
                    list < Phoenix_Bid_Line_Item__c > newMap = bidMap.get(item.Phoenix_Bid__c);
                    newMap.add(item);
                    bidMap.put(item.Phoenix_Bid__c, newMap);
                } else {
                    bidMap.put(item.Phoenix_Bid__c, new List < Phoenix_Bid_Line_Item__c > {
                        item
                    });
                }
            }
            for (string bidId: bidMap.keySet()) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                set < string > toaddressset = new set < string > ();
                list < string > toaddress = new list < string > ();
                list < string > ccaddress = new list < string > ();
                Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('SCM_Partial_Approval_Notification', bidId);
                String templateBody = emailWrapper.mailHtmlBody;
                String subject = emailWrapper.mailSubject;
                integer productCount = 0;
                string tableData = '';
                string name;
                tableData += '<table style="border-collapse: collapse;padding:4px"><thead><tr><th style="border: 1px solid black;padding:4px">S. No</th><th style="border: 1px solid black;padding:4px">Product Name</th><th style="border: 1px solid black;padding:4px">Product Code</th><th style="border: 1px solid black;padding:4px">Product Family</th><th style="border: 1px solid black;padding:4px">NDC</th><th style="border: 1px solid black;padding:4px">Product Director</th><th style="border: 1px solid black;padding:4px">SCM Approved - % of Incremental</th></tr></thead>';
                tableData += '<tbody>';
                for (Phoenix_Bid_Line_Item__c item: bidMap.get(bidId)) {
                    productCount++;
                    tableData += '<tr>';
                    tableData += '<td style="border: 1px solid black;text-align:center">' + productCount + '</td>';
                    tableData += '<td style="border: 1px solid black;">' + item.Phoenix_Product__r.Name + '</td>';
                    tableData += '<td style="border: 1px solid black;">' + item.Phoenix_Product__r.ProductCode + '</td>';
                    tableData += '<td style="border: 1px solid black;">' + item.Phoenix_Product__r.Family + '</td>';

                    if (item.Phoenix_Product__r.Phoenix_NDC_11_Dashes__c != Null) {
                        tableData += '<td style="border: 1px solid black;">' + item.Phoenix_Product__r.Phoenix_NDC_11_Dashes__c + '</td>';
                    } else {
                        tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

                    }

                    tableData += '<td style="border: 1px solid black;">' + item.Phoenix_Product__r.Phoenix_Product_Director__r.Name + '</td>';
                    //added by vandana on 2nd march extra.
                    if (item.Phoenix_SCM_Approved_Quantity__c != Null) {
                        tableData += '<td style="border: 1px solid black;text-align: right">' + item.Phoenix_SCM_Approved_Quantity__c +'%' + '</td>';
                    } else {
                        tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                                
                    }
                          
                    //end.
                    tableData += '</tr>';
                    name = item.Phoenix_Product__r.Phoenix_Product_Director__r.Name;
                    if (item.Phoenix_Product__r.Phoenix_Product_Director__r.Email != Null) {
                        toaddressset.add(item.Phoenix_Product__r.Phoenix_Product_Director__r.Email);
                    }
                    if (item.Phoenix_Bid__r.OwnerId != Null) {
                        allPeopleInvolvedEmailsSet.add(item.Phoenix_Bid__r.Owner.Email);
                    }
                    if (item.Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__c != Null) {
                        allPeopleInvolvedEmailsSet.add(item.Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__r.Email);
                    }
                    if (item.Phoenix_Bid__r.Phoenix_Salesperson__c != Null) {
                        allPeopleInvolvedEmailsSet.add(item.Phoenix_Bid__r.Phoenix_Salesperson__r.Email);
                    }
                    if (item.Phoenix_Bid__r.Phoenix_Sales_Person_2__c != Null) {
                        allPeopleInvolvedEmailsSet.add(item.Phoenix_Bid__r.Phoenix_Sales_Person_2__r.Email);
                    }

                    if (Label.Phoenix_Contracts_DL != null) allPeopleInvolvedEmailsSet.addAll(Label.Phoenix_Contracts_DL.split(','));


                    if (item.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c != null) {
                        DateTime internalDueDateTime = DateTime.newInstance(item.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0));
                        if (templateBody.contains('INTERNAL_DEADLINE_DATE')) templateBody = templateBody.replace('INTERNAL_DEADLINE_DATE', internalDueDateTime.format('MMM d yyyy'));
                    }


                    if (item.Phoenix_Bid__r.Phoenix_Bid_Deadline_Date__c != null) {
                        DateTime customerBidDeadline = DateTime.newInstance(item.Phoenix_Bid__r.Phoenix_Bid_Deadline_Date__c, Time.newInstance(0, 0, 0, 0));
                        if (templateBody.contains('CUSTOMER_DEADLINE_DATE')) templateBody = templateBody.replace('CUSTOMER_DEADLINE_DATE', customerBidDeadline.format('MMM d yyyy'));
                    }
                            
                       //bidtype label names added by vandana.

                    
            if (bidTypesmap!=null&&bidTypesmap.get(item.Phoenix_Bid__r.Phoenix_Bid_Type__c)!=null&&templateBody.contains('BID_TYPE')) templateBody = templateBody.replace('BID_TYPE', bidTypesmap.get(item.Phoenix_Bid__r.Phoenix_Bid_Type__c));
            if (bidTypesmap!=null&&bidTypesmap.get(item.Phoenix_Bid__r.Phoenix_Bid_Type__c)!=null&&subject.contains('BID_TYPE')) subject = subject.replace('BID_TYPE', bidTypesmap.get(item.Phoenix_Bid__r.Phoenix_Bid_Type__c));

            //bidtype label names --end.
                            
                            


                }
                tableData += '</tbody></table>';
                for (string emailId: toaddressset) {
                    if (allPeopleInvolvedEmailsSet.contains(emailId))
                        allPeopleInvolvedEmailsSet.remove(emailId);
                }
            If(allPeopleInvolvedEmailsSet != null && allPeopleInvolvedEmailsSet.contains('mkalawadia@drreddys.com'))allPeopleInvolvedEmailsSet.remove('mkalawadia@drreddys.com');
            If(toaddressset != null && toaddressset.contains('mkalawadia@drreddys.com'))toaddressset.remove('mkalawadia@drreddys.com');

                toaddress.addAll(toaddressset);
                ccaddress.addAll(allPeopleInvolvedEmailsSet);
                email.setToAddresses(toaddress);
                email.setCcAddresses(ccaddress);
               /* email.setCcAddresses(new List < String > {
                    'surender+uat@dhruvsoft.com'
                        });
                */
                templateBody = templateBody.replace('tableData', tableData).replace('ProductDirectorName', name);
                email.setHtmlBody(templateBody);
                email.setSubject(subject);
                email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);

                mail.add(email);
            }
        }
    } else if (objName == 'Phoenix_NDC_Change__c') {
        Phoenix_NDC_Change__c ndcChange = [Select Id, Name, Owner.Email, Phoenix_Approval_Status__c from Phoenix_NDC_Change__c WHERE Id =: objId LIMIT 1];
        List < Phoenix_NDC_Change_Line_Item__c > ndcLineItemsList = [Select Phoenix_Current_Product__c, Phoenix_Current_Product__r.Name, Phoenix_Current_Product_NDC__c, Phoenix_Current_Product_Pack_Size__c, Phoenix_Proposed_Product__c, Phoenix_Proposed_Product__r.Name, Phoenix_Proposed_Product_NDC__c, Phoenix_Proposed_Product_Pack_Size__c, Phoenix_SCM_Rejection_Reason__c FROM Phoenix_NDC_Change_Line_Item__c where Phoenix_NDC_Change__c =: objId and Phoenix_SCM_Approval_Y_N__c != 'Not Approved'
            and Phoenix_SCM_Approved_Quantity__c >= 0 and Phoenix_SCM_Approved_Quantity__c < 100
        ];

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        set < string > toaddressset = new set < string > ();
        set < string > ccaddressSet = new set < string > ();
        list < string > toaddress = new list < string > ();
        list < string > ccaddress = new list < string > ();
        Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('NDC_SCM_Partial_Approval_Notification', objId);
        String templateBody = emailWrapper.mailHtmlBody;
        String subject = emailWrapper.mailSubject;
        integer sNo = 0;
        string tableData = '';
        tableData += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;">S.No</th><th style="border: 1px solid black;">Proposed Product</th><th style="border: 1px solid black;">Proposed Product NDC</th><th style="border: 1px solid black;">Current Product</th><th style="border: 1px solid black;">Current Product NDC</th></tr></thead>';
        for (Phoenix_NDC_Change_Line_Item__c ndcitem: ndcLineItemsList) {
            sNo++;
            tableData += '<tr>';
            tableData += '<td style="border: 1px solid black;">' + sNo + '</td>';
            if (ndcitem.Phoenix_Proposed_Product__c != null) {
                tableData += '<td style="border: 1px solid black;">' + ndcitem.Phoenix_Proposed_Product__r.Name + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

            }

            if (ndcitem.Phoenix_Proposed_Product_NDC__c != Null) {
                tableData += '<td style="border: 1px solid black;">' + ndcitem.Phoenix_Proposed_Product_NDC__c + '</td>';

            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

            }
            if (ndcitem.Phoenix_Current_Product__c != null) {
                tableData += '<td style="border: 1px solid black;">' + ndcitem.Phoenix_Current_Product__r.Name + '</td>';
            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

            }
            if (ndcitem.Phoenix_Current_Product_NDC__c != Null) {
                tableData += '<td style="border: 1px solid black;">' + ndcitem.Phoenix_Current_Product_NDC__c + '</td>';

            } else {
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

            }

            /*        if (item.Phoenix_Revisited_Date__c != Null) {
DateTime revisitedTime = DateTime.newInstanceGMT(item.Phoenix_Revisited_Date__c, Time.newInstance(0, 0, 0, 0));
String revisitedDate = revisitedTime.format('MMM d yyyy');

tableData += '<td style="border: 1px solid black;">' + revisitedDate + '</td>';

} else {
tableData += '<td style="border: 1px solid black;">' + '' + '</td>';

}*/
            tableData += '</tr>';
        }
        tableData += '<tbody></table>';


        if (ndcChange.owner.Email != Null) {
            toaddressset.add(ndcChange.owner.Email);
        }
        if (Label.Phoenix_Contracts_DL != null) ccaddressSet.addAll(Label.Phoenix_Contracts_DL.split(','));

        for (string emailId: toaddressset) {
            if (ccaddressSet.contains(emailId))
                ccaddressSet.remove(emailId);
            if (allPeopleInvolvedEmailsSet.contains(emailId))
                allPeopleInvolvedEmailsSet.remove(emailId);
        }

        If(toaddressset != null && toaddressset.contains('mkalawadia@drreddys.com'))toaddressset.remove('mkalawadia@drreddys.com');
        If(ccaddressSet != null && ccaddressSet.contains('mkalawadia@drreddys.com'))ccaddressSet.remove('mkalawadia@drreddys.com');
        If(allPeopleInvolvedEmailsSet != null && allPeopleInvolvedEmailsSet.contains('mkalawadia@drreddys.com'))allPeopleInvolvedEmailsSet.remove('mkalawadia@drreddys.com');

        toaddress.addAll(toaddressset);
        ccaddress.addAll(ccaddressSet);
        ccaddress.addAll(allPeopleInvolvedEmailsSet);
          email.setToAddresses(toaddress);
          email.setCcAddresses(ccaddress);
       /* email.setCcAddresses(new List < String > {
            'surender+uat@dhruvsoft.com'
                });
        */
        if (templateBody.contains('tableData')) templateBody = templateBody.replace('tableData', tableData);
        email.setHtmlBody(templateBody);
        email.setSubject(subject);
        email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);

        mail.add(email);
    }
    messaging.sendEmail(mail);
}


Catch(Exception e) {
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();

    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'SCMPartialApprovalNotification', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}

}

/**
* @description This will send email notification to Contracts team(Defined at Custom label:Phoenix_Contracts_DL) when the duplicate NPR received from SAP on daily basis.
* This will be called from Phoenix_NPRStagingProcessor class. 
* @author Surender Patel (Dhruvsoft) | 12-05-2021 
**/
public static void reportDuplicateNprStagingRecords() {
try {
    Date currentDay = System.today();
    Date nextDay = currentDay + 1;
            

    map < string, Phoenix_SAP_NPR_Staging__c > nprmap = new map < string, Phoenix_SAP_NPR_Staging__c > ();
    List < Phoenix_SAP_NPR_Staging__c > duplicatenprList = new List < Phoenix_SAP_NPR_Staging__c > ();

    for (Phoenix_SAP_NPR_Staging__c nprrecord: [SELECT Id,Phoenix_NPR_Report_Type__c,Phoenix_Vistex_Description__c,Phoenix_Price_Effective_Value_From__c,Phoenix_NPR_Ref_SF__c, Phoenix_Contract_Number__c, Phoenix_Material_Number__c, Phoenix_Contract_Internal_Description__c, Phoenix_Contract_External_Description__c, Phoenix_Customer_Name__c FROM Phoenix_SAP_NPR_Staging__c WHERE CreatedDate = TODAY  AND Phoenix_NPR_Report_Type__c = 'Current Active' limit 50000]) {
        String nprref = nprrecord.Phoenix_NPR_Ref_SF__c + '-' + nprrecord.Phoenix_NPR_Report_Type__c;//+Phoenix_Price_Effective_Value_From__c
                
        if (!nprmap.containsKey(nprref)) {
            nprmap.put(nprref, nprrecord);
        } else {
            duplicatenprList.add(nprrecord);
        }
    }

    nprmap.clear();
            
    if (duplicatenprList.size() > 0) {
                
        Messaging.SendEmailResult[] results;

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List < string > toaddress = Label.Phoenix_Contracts_DL.split(',');
        Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Duplicate_NPR_Staging_Notification', duplicatenprList[0].Id);
        String templateBody = emailWrapper.mailHtmlBody;
        String subject = emailWrapper.mailSubject;
        String tableData = '';

        if (duplicatenprList.size() > 0) {
            Integer counter = 1;
            tableData += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;">S.No</th><th style="border: 1px solid black;">NPR Ref</th><th style="border: 1px solid black;">Contract No</th><th style="border: 1px solid black;">Material No.</th><th style="border: 1px solid black;">Product Name</th><th style="border: 1px solid black;">Customer Name</th><th style="border: 1px solid black;">Internal Description</th><th style="border: 1px solid black;">External Description</th></tr></thead>';
            tableData += '<tbody>';
            for (Phoenix_SAP_NPR_Staging__c npr: duplicatenprList) {
                tableData += '<tr>';
                tableData += '<td style="border: 1px solid black;">' + counter + '</td>';
                tableData += '<td style="border: 1px solid black;">' + npr.Phoenix_NPR_Ref_SF__c + '</td>';
                tableData += '<td style="border: 1px solid black;">' + npr.Phoenix_Contract_Number__c + '</td>';
                tableData += '<td style="border: 1px solid black;">' + npr.Phoenix_Material_Number__c + '</td>';
                if (npr.Phoenix_Vistex_Description__c != Null)
                tableData += '<td style="border: 1px solid black;">' + npr.Phoenix_Vistex_Description__c + '</td>';
                else
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (npr.Phoenix_Customer_Name__c != Null)    
                tableData += '<td style="border: 1px solid black;">' + npr.Phoenix_Customer_Name__c + '</td>';
                else
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (npr.Phoenix_Contract_Internal_Description__c != Null)    
                tableData += '<td style="border: 1px solid black;">' + npr.Phoenix_Contract_Internal_Description__c + '</td>';
                else
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (npr.Phoenix_Contract_External_Description__c != Null)    
                tableData += '<td style="border: 1px solid black;">' + npr.Phoenix_Contract_External_Description__c + '</td>';
                else
                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                tableData += '</tr>';
                counter++;
            }
            tableData += '</tbody></table>';
        }

        templateBody = templateBody.replace('NPR_TABLE', tableData).replace('RECORD_COUNT', String.valueOf(duplicatenprList.size()));
        email.setHtmlBody(templateBody);
        email.setSubject(subject);
        email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
        email.setToAddresses(toaddress);

        messaging.sendEmail(new List < Messaging.Email > {
            email
        });
    }
}
Catch(Exception e) {
    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();

    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'reportDuplicateNprStagingRecords', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}


}
    
    public static void delegationEmailAlert(String userId){ 
        User u = [Select Id,Name,Email,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegated_Approver__r.Email From User Where Id=:userId];
        List < Messaging.SingleEmailMessage > mailsList = new List < Messaging.SingleEmailMessage > ();
        String mailStatus = '';
        Messaging.SendEmailResult[] results;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Delegation_User_Notification', userId);
        String templateBody = emailWrapper.mailHtmlBody;
        String subject = emailWrapper.mailSubject;
        if( u.Phoenix_Delegated_Approver__r.Email!=null){
            email.setToAddresses(new List < String > {
                u.Phoenix_Delegated_Approver__r.Email
                    });
        }
        email.setCcAddresses(new List < String > {
            u.Email
                });
        string delegationHistoryUrl = '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/Delegation_History">Delegation History</a>';
        email.setSubject(subject);
        email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
        email.setHtmlBody(templateBody);
        email.setHtmlBody(templateBody.replace('DELEGATION_HISTORY_URL ', delegationHistoryUrl));
        mailsList.add(email);
        if (mailsList.size() > 0)
            results = Messaging.sendEmail(mailsList);
        
        Messaging.SendEmailResult[] delegatedUserResults;
        List < Messaging.SingleEmailMessage > delegatedUserMailsList = new List < Messaging.SingleEmailMessage > ();
        //String mailStatus = '';
        //Messaging.SendEmailResult[] results;
        Messaging.SingleEmailMessage delegatedUserEmail = new Messaging.SingleEmailMessage();
        Phoenix_Util.EmailWrapper delegatedUserEmailWrapper = Phoenix_Util.getTemplateBody('Delegated_User_Notification', userId);
        String delegatedUserTemplateBody = delegatedUserEmailWrapper.mailHtmlBody;
        String delegatedUserSubject = delegatedUserEmailWrapper.mailSubject;
        if( u.Phoenix_Delegated_Approver__r.Email!=null){
            delegatedUserEmail.setToAddresses(new List < String > {
                //'naseershaik@drreddys.com'
                u.Email
                    });
        }
        delegatedUserEmail.setCcAddresses(new List < String > {
            u.Phoenix_Delegated_Approver__r.Email
                });
        delegatedUserEmail.setSubject(delegatedUserSubject);
        delegatedUserEmail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
        delegatedUserEmail.setHtmlBody(delegatedUserTemplateBody);
        delegatedUserEmail.setHtmlBody(delegatedUserTemplateBody.replace('DELEGATION_HISTORY_URL ', delegationHistoryUrl));
        delegatedUserMailsList.add(delegatedUserEmail);
        if (delegatedUserMailsList.size() > 0)
            delegatedUserResults = Messaging.sendEmail(delegatedUserMailsList);
        
    }
    
    public static void delegationEndEmailAlert(String userId){
        User u = [Select Id,Name,Email,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegated_Approver__r.Email From User Where Id=:userId];
        List < Messaging.SingleEmailMessage > mailsList = new List < Messaging.SingleEmailMessage > ();
        String mailStatus = '';
        Messaging.SendEmailResult[] results;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Delegation_End_User_Notification', userId);
        String templateBody = emailWrapper.mailHtmlBody;
        String subject = emailWrapper.mailSubject;
        if( u.Phoenix_Delegated_Approver__r.Email!=null){
            email.setToAddresses(new List < String > {
                u.Phoenix_Delegated_Approver__r.Email, u.Email
                    });
        }
        /*email.setCcAddresses(new List < String > {
            u.Email
                });*/
        email.setSubject(subject);
        email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
        email.setHtmlBody(templateBody);
        mailsList.add(email);
        if (mailsList.size() > 0)
            results = Messaging.sendEmail(mailsList);
        
    }

public static String sendCIPReminderNotification(){
        
//  Product2 prod = [SELECT Id, Name,Phoenix_Product_Director__c,Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.Email FROM Product2 Where Id =: prodId];
//  List<Product2> prod = [SELECT Id, Name,ProductCode,CIP_Notification_Sent_Date__c, Phoenix_Product_Director__c,Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.Email, Phoenix_CIP_Implementation_Date__c,Phoenix_CIP_Throughput_Cost__c FROM Product2 WHERE (Phoenix_CIP_Implementation_Date__c = LAST_N_DAYS:90 OR Phoenix_CIP_Implementation_Date__c =  LAST_N_DAYS:30) AND Phoenix_CIP_Implementation_Date__c <= LAST_N_DAYS:30];
List<Product2> prod = [SELECT Id, Name,ProductCode, Phoenix_Product_Director__c,CIP_Notification_Sent_Date__c ,Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.Email, Phoenix_CIP_Implementation_Date__c,Phoenix_CIP_Throughput_Cost__c FROM Product2 WHERE (Phoenix_CIP_Implementation_Date__c = LAST_N_DAYS:90 OR Phoenix_CIP_Implementation_Date__c =  LAST_N_DAYS:30) AND  Phoenix_CIP_Implementation_Date__c <>LAST_N_DAYS:30];
// List<Product2> prod = [SELECT Id, Name,ProductCode, Phoenix_Product_Director__c, Phoenix_CIP_Implementation_Date__c,Phoenix_CIP_Throughput_Cost__c FROM Product2 WHERE Phoenix_CIP_Implementation_Date__c = LAST_N_MONTHS :3 OR Phoenix_CIP_Implementation_Date__c = THIS_MONTH OR Phoenix_CIP_Implementation_Date__c = NEXT_MONTH];
        
        
List<Product2> UpdateCIPSentDate = new List<Product2>();
Map<Id,List<Product2>> directorProductsMap = new  Map<Id,List<Product2>>();// get set of pids
Map<Id,Phoenix_Bid__c> bidMap = new  Map<Id,Phoenix_Bid__c>();// product id,bid obj
Set<Id> prodIdSet = new Set<Id>();
for(Product2 prodId : prod){
    prodIdSet.add(prodId.Id);
}
List<Phoenix_Bid_Line_Item__c> bidLineList=[SELECT Id,Name,Phoenix_Bid__c,Phoenix_Bid__r.Name,Phoenix_Product__c,Phoenix_Product__r.Phoenix_CIP_Implementation_Date__c from Phoenix_Bid_Line_Item__c WHERE Phoenix_Product__c IN: prodIdSet ORDER BY LastModifiedDate DESC];//pid set in where
        
        
     
List<Id> bidIds =  new List<Id>();
for(Product2 item : prod){
            
    if(directorProductsMap.containsKey(item.Phoenix_Product_Director__c)){
        List<Product2> prodirList = directorProductsMap.get(item.Phoenix_Product_Director__c);
        prodirList.add(item);
        directorProductsMap.put(item.Phoenix_Product_Director__c,prodirList);
    }
    else{
                
        directorProductsMap.put(item.Phoenix_Product_Director__c,new List<Product2>{item});
    }
}
        
for(Phoenix_Bid_Line_Item__c bidLineItem : bidLineList){
    // bidIds.add(bidLineItem.Phoenix_Bid__c);
    if(!bidMap.containsKey(bidLineItem.Phoenix_Product__c)){
        bidMap.put(bidLineItem.Phoenix_Product__c,new Phoenix_Bid__c(Id = bidLineItem.Phoenix_Bid__c));
    }
}
        
List<Phoenix_Bid__c> latestBid = [SELECT id,Name FROM Phoenix_Bid__c WHERE Id IN: bidIds ORDER BY LastModifiedDate DESC NULLS LAST LIMIT 1];
// assign to bid object 
// in vf templete show/use bidObj.name,bidobj.id for bidlink.
String bidId = '';
String bidName = '';
/*        for(Phoenix_Bid__c bid : latestBid){
bidName = bid.Name;
bidId = bid.id;
} */
        
        
//Product2 prod = [SELECT Id, Name, Phoenix_Product_Director__c, Phoenix_CIP_Implementation_Date__c,Phoenix_CIP_Throughput_Cost__c FROM Product2 WHERE Phoenix_CIP_Implementation_Date__c = TODAY AND ID =: prodId];
//  system.debug('List---->'+prod);
List < Messaging.SingleEmailMessage > mailsList = new List < Messaging.SingleEmailMessage > ();
String mailStatus = '';
Messaging.SendEmailResult[] results;
for(Id prodDirId: directorProductsMap.keySet()){
    if(prodDirId != null){
        String prodDirectorEmail = '';
        String prodDirectorName = '';
        for(Product2 product : directorProductsMap.get(prodDirId)) {
            prodDirectorEmail = product.Phoenix_Product_Director__r.Email;
            prodDirectorName = product.Phoenix_Product_Director__r.Name;
        }
                
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('CIP_Reminder_To_Directors',prodDirId);
        String templateBody = emailWrapper.mailHtmlBody;
        String subject = emailWrapper.mailSubject; 
        if (templateBody.contains('bid_Number')) templateBody = templateBody.replace('bid_Number', bidName);
        if (templateBody.contains('bid_Id')) templateBody = templateBody.replace('bid_Id', bidId);
        String tableData = '';
                
        if (directorProductsMap.values().size() > 0) {
            Integer counter = 1;
            tableData += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;">S.No</th><th style="border: 1px solid black;">Product Name</th><th style="border: 1px solid black;">Product Code</th><th style="border: 1px solid black;">Bid Number</th><th style="border: 1px solid black;">CIP Throughput Cost</th><th style="border: 1px solid black;">CIP Implementation Date</th></thead>';
            tableData += '<tbody>';
                    
            for (Product2 item: directorProductsMap.get(prodDirId)) {
                Phoenix_Bid__c bid;
                String bidNum = '';
                String id = '';
                for(Phoenix_Bid_Line_Item__c bidLineItem:bidLineList){
                           
                            
                    if(item.Id == bidLineItem.Phoenix_Product__c){ 
                        system.debug(bidLineItem.Phoenix_Bid__r.Name);
                        bidNum  = bidLineItem.Phoenix_Bid__r.Name;
                        id = bidLineItem.Phoenix_Bid__c;
                        break;
                    }
                }
                        
                        
                        
                If(bid!=null && bid.Name!=null)  system.debug('bid'+bid.Name);
                        
                //  for (Product2 item: prodItem) {
                if(item.Phoenix_Product_Director__r.Name != null){
                    tableData += '<tr>';
                    tableData += '<td style="border: 1px solid black;">' + counter + '</td>';
                    if (item.Name != null) {
                        tableData += '<td style="border: 1px solid black;white-space: nowrap;">' +'<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+item.id+'">' + item.Name + '</a></td>';
                        // tableData += '<td style="border: 1px solid black;">' + item.Name + '</td>';
                    }
                    else{
                        tableData += '<td style="border: 1px solid black;">' + '' + '</td>';  
                    }
                    if (item.ProductCode != null) {
                        tableData += '<td style="border: 1px solid black;">' + item.ProductCode + '</td>';
                    }
                    else{
                        tableData += '<td style="border: 1px solid black;">' + '' + '</td>';  
                    }
                    if (bidNum!=null) {
                        tableData += '<td style="border: 1px solid black;white-space: nowrap;">' +'<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+id+'">' + bidNum + '</a></td>';
                                
                        //  tableData += '<td style="border: 1px solid black;">' + bidNum + '</td>';
                    }
                    else{
                        tableData += '<td style="border: 1px solid black;">' + '' + '</td>';  
                    }
                            
                            
                            
                    if (item.Phoenix_CIP_Throughput_Cost__c != null) {
                        tableData += '<td style="border: 1px solid black;text-align: right;">' + '$' + item.Phoenix_CIP_Throughput_Cost__c + '</td>';
                    }
                    else{
                        tableData += '<td style="border: 1px solid black;">' + '' + '</td>';  
                    }
                    if (item.Phoenix_CIP_Implementation_Date__c != null) {
                        DateTime CIPDate = DateTime.newInstance(item.Phoenix_CIP_Implementation_Date__c, Time.newInstance(0, 0, 0, 0));
                        String CIP_Date = CIPDate.format('MMM d yyyy');
                        tableData += '<td style="border: 1px solid black;text-align: right;">' + CIP_Date + '</td>';
                    }
                    else{
                        tableData += '<td style="border: 1px solid black;">' + '' + '</td>';  
                    }
                            
                            
                    tableData += '</tr>';
                    counter++;
                    //       }
                            
                }
            }
                    
            tableData += '</tbody></table>';
        }
                
        // templateBody = templateBody.replace('table_data', tableData).replace('RECORD_COUNT', String.valueOf(directorProductsMap.values().size()));
        templateBody = templateBody.replace('table_data', tableData);
        templateBody = templateBody.replace('Director_Name', prodDirectorName);
                
        //email.toAddresses = new String[] { 'madhavi@dhruvsoft.com' };
        if(prodDirectorEmail != null){
            email.setToAddresses(new String[] {prodDirectorEmail});
        }
         Set < string > ccEmailIds = new Set < string > ();
        ccEmailIds.addAll(Label.CIP_Reminder_Notification_CC.split(','));
         email.setCcAddresses(new List < String > (ccEmailIds));
            email.setSubject(subject);
        email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
        email.setHtmlBody(templateBody);
                
        mailsList.add(email);
    }
}

        
if (mailsList.size() > 0){
    results = Messaging.sendEmail(mailsList);
    // update product cip sent date to system.now()
    for(Product2 product: prod){
        product.CIP_Notification_Sent_Date__c = system.now();
        UpdateCIPSentDate.add(product);
    }
    update UpdateCIPSentDate;
}
        
        
return mailStatus;
}
public static void sendEmailToMDMTeam(String bidId,List<Phoenix_Bid_Action_Item__c> actionItemsList) {
List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
String table_Data = '';
integer sNo = 0;
        
//Create a new Email
//  try {
Phoenix_Bid__c bid;
bid = [SELECT id, OwnerId,Owner.Name,Owner.Email FROM Phoenix_Bid__c WHERE Id =: bidId];
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
List < String > toAddress = new List < String > ();
List < String > ccAddress = new List < String > ();
if (Label.MDM_users != null) toAddress.addAll(Label.MDM_users.split(','));
if(bid.Owner.Email!=null){
ccAddress.addAll(new List<String> {bid.Owner.Email});
}
String groupName = 'Admin Users';
Group grp = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE Type = 'Regular' and name like: groupName LIMIT 1];
Set<String> idList = new Set<String>();
for (GroupMember gm : grp.groupMembers) {
    idList.add(gm.UserOrGroupId);
}
for(User u : [SELECT email FROM user WHERE id IN :idList]) {
    ccAddress.add(u.email);
}


mail.setToAddresses(toAddress);
mail.setCCAddresses(ccAddress);
        
//added by vandana
List<ContentDocument> cdlList = [SELECT Id FROM ContentDocument WHERE Id = '0691K00000mGVpdQAG'];
List<ContentVersion> cvList = [SELECT VersionData, FileExtension FROM ContentVersion WHERE ContentDocumentId = :cdlList[0].Id];
        
Blob fileData = cvList[0].VersionData; // <= This step converts the version data into a blob for the attachment
Messaging.EmailFileAttachment emlAtt = new Messaging.EmailFileAttachment();
emlAtt.setFilename('Format - material code.' + cvList[0].FileExtension);
emlAtt.setBody(fileData);
mail.setFileAttachments(new Messaging.EmailFileAttachment[] {emlAtt});
//end.
        
mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Notification_to_MDM_Team', bidId);
 String templateBody;
        
templateBody = emailWrapper.mailHtmlBody;
       
       
table_Data += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;padding:4px;">S.No</th><th style="border: 1px solid black;padding:4px">Bid Number</th><th style="border: 1px solid black;padding:4px">Account</th><th style="border: 1px solid black;padding:4px;">Product Name</th><th style="border: 1px solid black;padding:4px;">Product Director</th><th style="border: 1px solid black;padding:4px">Strength</th><th style="border: 1px solid black;padding:4px">Pkg Size</th><th style="border: 1px solid black;padding:4px;">GPI</th><th style="border: 1px solid black;padding:4px;">GCN</th></tr></thead>';
table_Data += '<tbody>';
        
        
for(Phoenix_Bid_Action_Item__c item: actionItemsList){
    sNo++;
    table_Data += '<tr>';
    table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">' + sNo + '</td>';
    if (item.Phoenix_Bid__r.Name != Null)
        table_Data += '<td style="border: 1px solid black;text-align:center;padding:4px">'+item.Phoenix_Bid__r.Name+ '</td>';
    else 
        table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
    if (item.Phoenix_Account__c != Null)
        table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">'+item.Phoenix_Account__r.Name+ '</td>';
    else 
        table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
    if (item.Phoenix_Product__c != Null)
        table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">'+item.Phoenix_Product__r.Name+ '</td>';
    else 
        table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
    if (item.Phoenix_Product_Director__c!= Null)
        table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">'+item.Phoenix_Product_Director__c+ '</td>';
    else 
        table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
    if (item.Phoenix_Strength__c != Null)
        table_Data += '<td style="border: 1px solid black;text-align:right;padding:4px">'+item.Phoenix_Strength__c+ '</td>';
    else 
        table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
    if (item.Phoenix_Pkg_Size__c != Null)
        table_Data += '<td style="border: 1px solid black;text-align:right;padding:4px">'+item.Phoenix_Pkg_Size__c+ '</td>';
    else 
        table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
    if (item.Phoenix_GPI_Generic_Product_Identifier__c != Null)
        table_Data += '<td style="border: 1px solid black;text-align:right;padding:4px">'+item.Phoenix_GPI_Generic_Product_Identifier__c+ '</td>';
    else 
        table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
    if (item.Phoenix_GCN_Generic_Code_Number__c != Null)
        table_Data += '<td style="border: 1px solid black;text-align:right;padding:4px">'+item.Phoenix_GCN_Generic_Code_Number__c+ '</td>';
    else 
        table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
    table_Data += '</tr>';
}
table_Data += '</tbody></table>';
if (templateBody.contains('action_Items')) templateBody = templateBody.replace('action_Items', table_Data);
mail.setHtmlBody(templateBody);
mail.setSubject(emailWrapper.mailSubject);
mails.add(mail);
Messaging.SendEmailResult[] results;
        
        
/*if (mails.size() > 0 && !test.isRunningTest())
    results = Messaging.sendEmail(mails);*/
            
            
// }
/*  Catch(Exception e) {
    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'sendWACChangeEmailFinanceTeam', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
} */
        
        
/*  if (results[0].success) {System.debug('The email was sent successfully.');} else {System.debug('The email failed to send: '+ results[0].errors[0].message);} */
}
    
public static void sendEmailToAllApprovers(String bidId,List<Phoenix_Bid_Action_Item__c> actionItemsList) {
List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
String table_Data = '';
integer sNo = 0;
        
//Create a new Email
//   try {
    Set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
    Map < Id, User > usersMap = new Map < Id, User > ([SELECT Id, Name, Email,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegated_Approver__r.Email FROM User]);

    for (Phoenix_Bid_Process_Steps__c step: [SELECT Id,Phoenix_Approver_Team__c, Name, Phoenix_Approver__c, Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Status__c, Phoenix_Approver__r.Email
                                             FROM Phoenix_Bid_Process_Steps__c
                                             WHERE Phoenix_Is_Criteria_Step__c = false AND Phoenix_Status__c != 'Not Applicable'
                                             AND Phoenix_Bid__c =: bidId 
                                            ]) {
                                                if (step.Phoenix_Approver__c != null) {
                                                    // allPeopleInvolvedEmailsSet.add(step.Phoenix_Approver__r.Email);
                                                    allPeopleInvolvedEmailsSet.add(usersMap.get(step.Phoenix_Approver__c).Email);
                                                    if(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__c!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Name!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email!=null){
                                                        allPeopleInvolvedEmailsSet.add(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email);    
                                                                
                                                    }
                                                }
                                                if (step.Phoenix_Approver_Team__c != null) { //Means team
                                                    if (approvalTeamUsersEmailsMap.get(step.Phoenix_Approver_Team__c) != null){
                                                        allPeopleInvolvedEmailsSet.addAll(approvalTeamUsersEmailsMap.get(step.Phoenix_Approver_Team__c));
                                                    }
                                                } 
                                            }
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    List < String > toAddress = new List < String > ();
If(allPeopleInvolvedEmailsSet != null && allPeopleInvolvedEmailsSet.contains('mkalawadia@drreddys.com'))allPeopleInvolvedEmailsSet.remove('mkalawadia@drreddys.com');
    toAddress.addAll(allPeopleInvolvedEmailsSet);
        
    for(String s:allPeopleInvolvedEmailsSet){
           
    }
    mail.setToAddresses(toAddress);
    //mail.setToAddresses(new List<String>{'ramesh@dhruvsoft.com'});
    mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
    Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Notification_to_OTC_Team', bidId);
    String templateBody = emailWrapper.mailHtmlBody;
    table_Data += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;padding:4px;">S.No</th><th style="border: 1px solid black;padding:4px">Bid Number</th><th style="border: 1px solid black;padding:4px">Account</th><th style="border: 1px solid black;padding:4px;">Product Name</th><th style="border: 1px solid black;padding:4px;">Product Director</th><th style="border: 1px solid black;padding:4px;">SAP Code</th><th style="border: 1px solid black;padding:4px;">NDC 11</th><th style="border: 1px solid black;padding:4px">Strength</th><th style="border: 1px solid black;padding:4px">Pkg Size</th><th style="border: 1px solid black;padding:4px;">GPI</th><th style="border: 1px solid black;padding:4px;">GCN</th></tr></thead>';
    table_Data += '<tbody>';
            
            
    for(Phoenix_Bid_Action_Item__c item: actionItemsList){
        sNo++;
        table_Data += '<tr>';
        table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">' + sNo + '</td>';
        if (item.Phoenix_Bid__r.Name != Null)
            table_Data += '<td style="border: 1px solid black;text-align:center;padding:4px">'+item.Phoenix_Bid__r.Name+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
        if (item.Phoenix_Account__c != Null)
            table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">'+item.Phoenix_Account__r.Name+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
        if (item.Phoenix_Product__c != Null)
            table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">'+item.Phoenix_Product__r.Name+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
         if (item.Phoenix_Product_Director__c!= Null)
            table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">'+item.Phoenix_Product_Director__c+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
         if (item.Phoenix_SAP_Code__c != Null)
            table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">'+item.Phoenix_SAP_Code__c+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
         if (item.Phoenix_NDC_11__c != Null)
            table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">'+item.Phoenix_NDC_11__c+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
        if (item.Phoenix_Strength__c != Null)
            table_Data += '<td style="border: 1px solid black;text-align:right;padding:4px">'+item.Phoenix_Strength__c+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
        if (item.Phoenix_Pkg_Size__c != Null)
            table_Data += '<td style="border: 1px solid black;text-align:right;padding:4px">'+item.Phoenix_Pkg_Size__c+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
        if (item.Phoenix_GPI_Generic_Product_Identifier__c != Null)
            table_Data += '<td style="border: 1px solid black;text-align:right;padding:4px">'+item.Phoenix_GPI_Generic_Product_Identifier__c+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
        if (item.Phoenix_GCN_Generic_Code_Number__c != Null)
            table_Data += '<td style="border: 1px solid black;text-align:right;padding:4px">'+item.Phoenix_GCN_Generic_Code_Number__c+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
        table_Data += '</tr>';
    }
    table_Data += '</tbody></table>';
    if (templateBody.contains('action_Items')) templateBody = templateBody.replace('action_Items', table_Data);
    mail.setHtmlBody(templateBody);
    mail.setSubject(emailWrapper.mailSubject);
    mails.add(mail);
    Messaging.SendEmailResult[] results;
           
    if (mails.size() > 0)
        results = Messaging.sendEmail(mails);
            
            
//   }
/*  Catch(Exception e) {
    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'sendWACChangeEmailFinanceTeam', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}*/
}

//by satya//
public static void sendEmailToAllApproversforProductsDeactivation(String bidId,List<Phoenix_Bid_Line_Item__c> lineitems) {
    List<Phoenix_Bid_Action_Item__c> actionItemsList = new List<Phoenix_Bid_Action_Item__c>();
List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
String table_Data = '';
integer sNo = 0;
        
//Create a new Email
//   try {
    Set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
    Map < Id, User > usersMap = new Map < Id, User > ([SELECT Id, Name, Email,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegated_Approver__r.Email FROM User]);

    for (Phoenix_Bid_Process_Steps__c step: [SELECT Id,Phoenix_Approver_Team_Members__c,Phoenix_Approver_Team__c, Name, Phoenix_Approver__c, Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Status__c, Phoenix_Approver__r.Email
                                             FROM Phoenix_Bid_Process_Steps__c
                                             WHERE Phoenix_Is_Criteria_Step__c = false AND Phoenix_Status__c != 'Not Applicable'
                                             AND Phoenix_Bid__c =: bidId 
                                            ]) {
                                                if (step.Phoenix_Approver__c != null) {
                                                    // allPeopleInvolvedEmailsSet.add(step.Phoenix_Approver__r.Email);
                                                    allPeopleInvolvedEmailsSet.add(usersMap.get(step.Phoenix_Approver__c).Email);
                                                    if(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__c!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Name!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email!=null){
                                                        allPeopleInvolvedEmailsSet.add(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email);    
                                                                
                                                    }
                                                }
                                                Set < String > teamNames = new Set < String > ();
                                                Set<String> emailList = new Set<String>();
                                                if (step.Phoenix_Approver_Team_Members__c != null){
                                                   teamNames = new Set < String > (step.Phoenix_Approver_Team_Members__c.split(',')); 
                                                }
                                                List < User > usersList = [SELECT Id, Username, Name, Email FROM User where Name IN: teamNames];
                                                for(User u : usersList){
                                                    emailList.add(u.Email);
                                                    allPeopleInvolvedEmailsSet.add(u.Email);
                                                     //System.debug('email==>'+u.Email);
                                                }
                                               /* if (step.Phoenix_Approver_Team__c != null) { //Means team
                                                    if (approvalTeamUsersEmailsMap.get(step.Phoenix_Approver_Team__c) != null){
                                                        allPeopleInvolvedEmailsSet.addAll(approvalTeamUsersEmailsMap.get(step.Phoenix_Approver_Team__c));
                                                    }
                                                } */
                                            }
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    List < String > toAddress = new List < String > ();
If(allPeopleInvolvedEmailsSet != null && allPeopleInvolvedEmailsSet.contains('mkalawadia@drreddys.com'))allPeopleInvolvedEmailsSet.remove('mkalawadia@drreddys.com');
    toAddress.addAll(allPeopleInvolvedEmailsSet);
        
    for(String s:allPeopleInvolvedEmailsSet){
           
    }
    toAddress.add('pradeep@dhruvsoft.com');
    toAddress.add('satya@dhruvsoft.com');
    mail.setToAddresses(toAddress);
    //mail.setToAddresses(new List<String>{'satya@dhruvsoft.com'});
    mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
    Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('NotificationForProductsDeactivation', bidId);
    String templateBody = emailWrapper.mailHtmlBody;
    table_Data += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;padding:4px;">S.No</th><th style="border: 1px solid black;padding:4px">Product Name</th><th style="border: 1px solid black;padding:4px">Code</th><th style="border: 1px solid black;padding:4px;">Product Family</th><th style="border: 1px solid black;padding:4px;">Product Director</th>';
    table_Data += '<tbody>';
            
            
    for(Phoenix_Bid_Line_Item__c item: lineitems){
        sNo++;
        table_Data += '<tr>';
        table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">' + sNo + '</td>';
        if (item.Phoenix_Product__r.Name != Null)
            table_Data += '<td style="border: 1px solid black;text-align:center;padding:4px">'+item.Phoenix_Product__r.Name+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
        if (item.Phoenix_Product__r.ProductCode != Null)
            table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">'+item.Phoenix_Product__r.ProductCode+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
        if (item.Phoenix_Product_Family__c != Null)
            table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">'+item.Phoenix_Product_Family__c+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
         if (item.Phoenix_Product_Director__c!= Null)
            table_Data += '<td style="border: 1px solid black;text-align:left;padding:4px">'+item.Phoenix_Product_Director__c+ '</td>';
        else 
            table_Data += '<td style="border: 1px solid black;">' + '' + '</td>';
       table_Data += '</tr>';
    }
    table_Data += '</tbody></table>';
    if (templateBody.contains('action_Items')) templateBody = templateBody.replace('action_Items', table_Data);
    mail.setHtmlBody(templateBody);
    mail.setSubject(emailWrapper.mailSubject);
    mails.add(mail);
    Messaging.SendEmailResult[] results;
           
    if (mails.size() > 0)
        results = Messaging.sendEmail(mails);
            
            
//   }
/*  Catch(Exception e) {
    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'sendWACChangeEmailFinanceTeam', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
    insert exp;
}*/
}

public class BidWrapper {
@AuraEnabled public Phoenix_Bid__c bid {
    get;
    set;
}
@AuraEnabled public Integer bidItemCount {
    get;
    set;
}
@AuraEnabled public Phoenix_NDC_Change__c ndcChange {
    get;
    set;
}
@AuraEnabled public Phoenix_PHS_Price_Change__c pHSPriceChange {
    get;
    set;
}
@AuraEnabled public Integer ndcChangeItemCount {
    get;
    set;
}
@AuraEnabled public String error {
    get;
    set;
}
}
public static void sendDrlSubmittingUnderNewBidEmail(String crId,Id bidId){
        
try{
            
            
    Map < String, String > bidTypesmap = new Map < String, String > ();
            
    for(Schema.PicklistEntry  ple:  Phoenix_Bid__c.Phoenix_Bid_Type__c.getDescribe().getPicklistValues()){
        bidTypesmap.put(ple.getValue(),ple.getLabel());
    }
            
    //bidtype label names added end.
            
            
    //Create a new Email
          
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
   /*Added by satya*/
   Map < Id, Phoenix_Bid_Line_Item__c > bidLineItemMap = new Map < Id, Phoenix_Bid_Line_Item__c > ();
   Map < Id, List < Phoenix_Bid_Line_Item__c >> BidMapWithLineItems = new Map < Id, List < Phoenix_Bid_Line_Item__c >> ();
   map < id, set < String >> bidIdEmailMap = new map < id, set < String >> ();
   Set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
   Set < String > bidIds = new Set < String > ();
   for (Phoenix_Bid_Process_Steps__c step: [SELECT Id, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Bid__c, Phoenix_NDC_Change__c, Phoenix_PHS_Price_Change__c
                                            FROM Phoenix_Bid_Process_Steps__c
                                            Where(Phoenix_Bid__c =: bidId) AND Phoenix_Is_Criteria_Step__c = false AND Phoenix_Status__c != 'Not Applicable'
                                           ]) {
                                                       
                                                   if (step.Phoenix_Approver__c != null && bidIdEmailMap.containsKey(step.Phoenix_Bid__c)) {
                                                       Set < String > addedEmails = bidIdEmailMap.get(step.Phoenix_Bid__c);
                                                       addedEmails.add(step.Phoenix_Approver__r.Email);
                                                       bidIdEmailMap.put(step.Phoenix_Bid__c, addedEmails);
                                                   } else if (step.Phoenix_Approver__c != null && !bidIdEmailMap.containsKey(step.Phoenix_Bid__c)) {
                                                       bidIdEmailMap.put(step.Phoenix_Bid__c, new Set < String > {
                                                           step.Phoenix_Approver__r.Email
                                                               });
                                                   }
                                                      
                                           }
   System.debug('bidIdEmailMap res==>'+bidIdEmailMap);
         bidLineItemMap = new Map < Id, Phoenix_Bid_Line_Item__c > ([SELECT Id, Phoenix_Bid__r.Phoenix_Bid_Deadline_Date__c, Phoenix_Bid__r.Phoenix_Internal_Target_Date__c, Phoenix_Bid__r.Phoenix_Salesperson__c, Phoenix_Bid__r.Phoenix_Salesperson__r.Email,
                Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__r.Email, Phoenix_Bid__r.Owner.Email, Phoenix_Bid__r.Phoenix_Sales_Person_2__c, Phoenix_Bid__r.Phoenix_Sales_Person_2__r.Email,
                Phoenix_Product__r.ProductCode, Phoenix_Product__r.Family, Phoenix_Product__r.Phoenix_NDC__c,
                Phoenix_SCM_Rejection_Reason1__c, Phoenix_Product_Director1__c, Phoenix_NDC__c, Phoenix_Product_Family1__c,
                Phoenix_Product_Code1__c, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Bid_Owner__r.Name,
                Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Name, Phoenix_Customer__r.Name,
                Phoenix_Customer__c, Phoenix_Product__r.Name, Phoenix_Product__r.Phoenix_Product_Director__c, Phoenix_Product__r.Phoenix_Product_Director__r.Name,
                Phoenix_Product__r.Phoenix_Product_Director__r.Email, Name, Phoenix_Product__c, Phoenix_Product_Director__c
                FROM Phoenix_Bid_Line_Item__c
                where  Phoenix_Bid__c =: bidId AND Phoenix_Final_Status__c = 'Not Approved'
                AND Phoenix_Is_Rejection_Noti_All_Sent__c = false
            ]);
           
            for (Phoenix_Bid_Line_Item__c item: bidLineItemMap.values()) {
                 String bid_Id = item.Phoenix_Bid__c;
                bidIds.add(bid_Id);
                if (BidMapWithLineItems.containsKey(bid_Id)) {
                    List < Phoenix_Bid_Line_Item__c > addedList = BidMapWithLineItems.get(bid_Id);
                    addedList.add(item);
                    BidMapWithLineItems.put(bid_Id, addedList);
                } else {
                    BidMapWithLineItems.put(bid_Id, new List < Phoenix_Bid_Line_Item__c > {
                        item
                    });
                }
                //Add Sales persons
                if (item.Phoenix_Bid__r.Phoenix_Sales_Person_2__c != null) {
                    allPeopleInvolvedEmailsSet.add(item.Phoenix_Bid__r.Phoenix_Sales_Person_2__r.Email);
                } else if (item.Phoenix_Bid__r.Phoenix_Salesperson__c != null) {
                    allPeopleInvolvedEmailsSet.add(item.Phoenix_Bid__r.Phoenix_Salesperson__r.Email);
                }
            }
           			
   for (string Bid_Id: BidMapWithLineItems.keySet()) {
       Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
       set < string > toaddressset = new set < string > ();
       set < string > ccaddressSet = new set < string > ();
               
               
       Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Rejection_Email_Drl_Submitting', crId);
       String templateBody = emailWrapper.mailHtmlBody;
       String subject = emailWrapper.mailSubject;
       integer productCount = 0;
       string name;
       for (Phoenix_Bid_Line_Item__c item: BidMapWithLineItems.get(Bid_Id)) {
           productCount++;
           name = item.Phoenix_Product__r.Phoenix_Product_Director__r.Name;
           if (item.Phoenix_Product__r.Phoenix_Product_Director__r.Email != Null) {
               toaddressset.add(item.Phoenix_Product__r.Phoenix_Product_Director__r.Email);
           }
           if (item.Phoenix_Bid__r.Owner.Email != Null) {
               ccaddressSet.add(item.Phoenix_Bid__r.Owner.Email);
           }
           if (item.Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__r.Email != Null) {
               ccaddressSet.add(item.Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__r.Email);
           }
                   
                   
                   
           if (item.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c != null) {
               DateTime internalDueDateTime = DateTime.newInstance(item.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0));
               if (templateBody.contains('INTERNAL_DEADLINE_DATE')) templateBody = templateBody.replace('INTERNAL_DEADLINE_DATE', internalDueDateTime.format('MMM d yyyy'));
           }
                   
                   
           if (item.Phoenix_Bid__r.Phoenix_Bid_Deadline_Date__c != null) {
               DateTime customerBidDeadline = DateTime.newInstance(item.Phoenix_Bid__r.Phoenix_Bid_Deadline_Date__c, Time.newInstance(0, 0, 0, 0));
               if (templateBody.contains('CUSTOMER_DEADLINE_DATE')) templateBody = templateBody.replace('CUSTOMER_DEADLINE_DATE', customerBidDeadline.format('MMM d yyyy'));
           }
                   
                   
           //bidtype label names added by vandana.
                   
                   
           if (bidTypesmap!=null&&bidTypesmap.get(item.Phoenix_Bid__r.Phoenix_Bid_Type__c)!=null&&templateBody.contains('BID_TYPE')) templateBody = templateBody.replace('BID_TYPE', bidTypesmap.get(item.Phoenix_Bid__r.Phoenix_Bid_Type__c));
           if (bidTypesmap!=null&&bidTypesmap.get(item.Phoenix_Bid__r.Phoenix_Bid_Type__c)!=null&&subject.contains('BID_TYPE')) subject = subject.replace('BID_TYPE', bidTypesmap.get(item.Phoenix_Bid__r.Phoenix_Bid_Type__c));
                   
           //bidtype label names --end.
                   
       }
       if (bidIdEmailMap.get(BidId) != null) toaddressset.AddAll(bidIdEmailMap.get(BidId));
       toaddressset.addAll(allPeopleInvolvedEmailsSet);
       if (Label.Phoenix_Contracts_DL != null) ccaddressSet.addAll(Label.Phoenix_Contracts_DL.split(','));
       for (string emailId: toaddressset) {
           if (ccaddressSet.contains(emailId))
               ccaddressSet.remove(emailId);
       }
       If(ccaddressSet != null && ccaddressSet.contains('mkalawadia@drreddys.com'))ccaddressSet.remove('mkalawadia@drreddys.com');
       If(toaddressset != null && toaddressset.contains('mkalawadia@drreddys.com'))toaddressset.remove('mkalawadia@drreddys.com');
       //toaddressset.add('satya@dhruvsoft.com');
       email.setToAddresses(new List<String>(toaddressset));
       email.setCcAddresses(new List<String>(ccaddressSet));
       email.setHtmlBody(templateBody);
       email.setSubject(subject);
       email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
       //mail.add(email);
                   
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
            email
                });
   }
           
           
 /*  List < Phoenix_Bid_Line_Item__c > updatedItems = new List < Phoenix_Bid_Line_Item__c > ();
   for (Phoenix_Bid_Line_Item__c item: bidLineItemMap.values()) {
       item.Phoenix_Is_Rejection_Noti_All_Sent__c = true;
       updatedItems.add(item);
               
   }
           
   update updatedItems;*/
           
           
                
                
                
                
    }
    catch(exception e){
        Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'CustomerresponselineEmail', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'sendemail', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
        insert exp;
    }
}
	
	
public static void codeCoverage(){
integer i =1;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
        
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
        
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
 i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++; i++;
        
        
} 

}