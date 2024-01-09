public without sharing class BidRejectionEmailNotificationToAllNew  {
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
    
    public static void BidRejectionEmailNotificationToAll(Set < id > bidLineItemIdset,String Bid_ID) {
        System.debug('bidLineItemIdset==>'+bidLineItemIdset);
        System.debug('BidID===>'+Bid_ID);
        
        list < messaging.Email > mail = new list < messaging.email > ();
        List < Id > bidLineItemIds = new List < Id > (bidLineItemIdset);
        System.debug('bidLineItemIds===>'+bidLineItemIds);
        
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
                System.debug('objName==>'+objName);
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
                String rejectionApprover = '';
                
                
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
                                                            }
                                                            else if (objName == 'Phoenix_NDC_Change_Line_Item__c') {
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
                    /*added by satya*/
                    System.debug('in  bid rejection');
                    DateTime internalDueDateTime; DateTime customerBidDeadline;
                    Phoenix_Bid__c bid = [Select Id,Phoenix_Bid_Name__c,CreatedBy.Name,Phoenix_Comments__c,Phoenix_Approval_Status__c,Phoenix_Salesperson__r.Name,Phoenix_Customer__r.Name,Phoenix_is_OTC_Bid__c, Name, Owner.Email,Phoenix_Bid_Type__c, Phoenix_Bid_Deadline_Date__c, Phoenix_Sales_Person_2__c, Phoenix_Sales_Person_2__r.Email, Phoenix_Salesperson__c, Phoenix_Salesperson__r.Email, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Bid_Created_Behalf_of__r.Email, Phoenix_Internal_Target_Date__c, Phoenix_Customer_Bid_Deadline_Date_Time__c FROM Phoenix_Bid__c Where Id =: Bid_ID];
                    User creatByName = new User();
                    String creatBy_Name;
                    String bidNumber = bid.Name;
                    String bid_Name = bid.Phoenix_Bid_Name__c != null ? bid.Phoenix_Bid_Name__c : '';
                    String bid_Type = bid.Phoenix_Bid_Type__c != null ? bid.Phoenix_Bid_Type__c : '';
                    String custName = bid.Phoenix_Customer__r.Name != null ? bid.Phoenix_Customer__r.Name : '';
                    creatByName = bid.CreatedBy;
                    creatBy_Name = creatByName.Name;
                    String sales_Person = bid.Phoenix_Salesperson__r.Name != null ? bid.Phoenix_Salesperson__r.Name : '';
                    String current_Stage = bid.Phoenix_Approval_Status__c != null ? bid.Phoenix_Approval_Status__c : '';
                    Date internalDeadline = bid.Phoenix_Internal_Target_Date__c;
                    DateTime customerDeadline = bid.Phoenix_Customer_Bid_Deadline_Date_Time__c;
                    String summaryText = bid.Phoenix_Comments__c != null ? bid.Phoenix_Comments__c : '';
                    String approvalStatus =   bid.Phoenix_Approval_Status__c != null ?  bid.Phoenix_Approval_Status__c : '';
                    Integer countOfProducts = 0;
                    if (bid.Phoenix_Internal_Target_Date__c != null) 
                        internalDueDateTime = DateTime.newInstance(bid.Phoenix_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0));                        
                    if (bid.Phoenix_Bid_Deadline_Date__c != null) 
                        customerBidDeadline = DateTime.newInstance(bid.Phoenix_Bid_Deadline_Date__c, Time.newInstance(0, 0, 0, 0));
                    
                    /* end by satya*/
                    try{
                        //satya removed  AND Phoenix_Is_Rejection_Noti_All_Sent__c = false
                        System.debug('in try');
                        System.debug('bidLineItemIds==>'+bidLineItemIds);
                        bidLineItemMap = new Map < Id, Phoenix_Bid_Line_Item__c > ([SELECT Id, Phoenix_Bid__r.Phoenix_Bid_Deadline_Date__c, Phoenix_Bid__r.Phoenix_Internal_Target_Date__c, Phoenix_Bid__r.Phoenix_Salesperson__c, Phoenix_Bid__r.Phoenix_Salesperson__r.Email,
                                                                                    Phoenix_SCM_Rejection_Reason__c,Phoenix_Revisited_Date__c,Phoenix_Contract_Comments__c,Marketing_Lead_Notes__c,Phoenix_Finance_Comments__c,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__r.Email, Phoenix_Bid__r.Owner.Email, Phoenix_Bid__r.Phoenix_Sales_Person_2__c, Phoenix_Bid__r.Phoenix_Sales_Person_2__r.Email,
                                                                                    Phoenix_Product__r.ProductCode, Phoenix_Product__r.Family, Phoenix_Product__r.Phoenix_NDC__c,
                                                                                    Phoenix_SCM_Rejection_Reason1__c, Phoenix_Product_Director1__c, Phoenix_NDC__c, Phoenix_Product_Family1__c,
                                                                                    Phoenix_Product_Code1__c, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Bid_Owner__r.Name,
                                                                                    Phoenix_Bid__r.Phoenix_Salesperson__r.Name,Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Bid__r.Phoenix_Customer__r.Name, Phoenix_Customer__r.Name,
                                                                                    Phoenix_Product__r.Phoenix_Marketing_Lead__r.Name,Phoenix_Marketing_Notes__c,Phoenix_Bid__r.Phoenix_Comments__c, Phoenix_Customer__c, Phoenix_Product__r.Name, Phoenix_Product__r.Phoenix_Product_Director__c, Phoenix_Product__r.Phoenix_Product_Director__r.Name,
                                                                                    Phoenix_Bid_Line_Item_Approval_Status__c,Phoenix_Product__r.Phoenix_NDC_11_Dashes__c,Phoenix_Product__r.Phoenix_Product_Director__r.Email, Name, Phoenix_Product__c, Phoenix_Product_Director__c,
                                                                                    Phoenix_Marketing_Lead_Rx__c,Phoenix_Is_Rejection_Noti_All_Sent__c,Phoenix_Business_Head_Comments__c,Phoenix_Final_Total_Selling_Unit__c,	Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Customer_Decline_Reasons__c,
                                                                                    Phoenix_Bid_Status__c,Phoenix_Customer_Approval_OTC__c,Phoenix_Marketing_Approval__c
                                                                                    FROM Phoenix_Bid_Line_Item__c
                                                                                    where Id in: bidLineItemIds AND (Phoenix_Final_Status__c = 'Not Approved' OR Phoenix_Marketing_Lead_Rx__c  = 'Not Approved' OR Phoenix_Customer_Approval_OTC__c = 'Not Approved' OR Phoenix_Marketing_Approval__c = 'Not Approved')
                                                                                    
                                                                                   ]);
                        List<Phoenix_Bid_Line_Item__c> awardedItems = new List<Phoenix_Bid_Line_Item__c>();
                        List<Phoenix_Bid_Line_Item__c> rejectedItems = new List<Phoenix_Bid_Line_Item__c>();
                        System.debug('bid type is==>'+bid_Type);
                       
                        if(bid_Type != 'OTC Product Addition' && bid_Type != 'OTC Price Change' && bid_Type != 'OTC RFP' && bid_Type != 'OTC Rebate Change' && bid_Type != 'OTC Volume Review' && bid_Type != 'OTC New Product' && bid_Type != 'OTC OTB Good Dated' && bid_Type != 'OTC OTB Short Date' ){
                        List<String> rejectedStatus = new List<String> {'Declined by Customer', 'DRL Rescinded', 'DRL submitting under New Bid Number'};
                       		 awardedItems = [SELECT Id,Phoenix_Supply_Effective_Date__c, Phoenix_Product__r.Name,Phoenix_Product__r.ProductCode,Phoenix_Final_Total_Selling_Unit__c,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Awarded_Quantity__c,Phoenix_Customer_Response_Line__r.Phoenix_Supply_Effective_Date__c,Phoenix_Customer_Response_Line__r.Phoenix_Price_Effective_Date__c,Phoenix_Bid_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =:Bid_ID AND Phoenix_Bid_Status__c = 'Awarded'];
                        	 rejectedItems = [SELECT Id, Phoenix_Supply_Effective_Date__c,Phoenix_Product__r.Name,Phoenix_Product__r.ProductCode,Phoenix_Final_Total_Selling_Unit__c,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Awarded_Quantity__c,Phoenix_Customer_Decline_Reasons__c,Phoenix_Bid_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =:Bid_ID AND Phoenix_Bid_Status__c IN:rejectedStatus];
                        }
                    if(bid_Type == 'OTC Product Addition' || bid_Type == 'OTC Price Change' || bid_Type == 'OTC RFP' || bid_Type == 'OTC Rebate Change' || bid_Type == 'OTC Volume Review' || bid_Type == 'OTC New Product' || bid_Type == 'OTC OTB Good Dated' || bid_Type == 'OTC OTB Short Date' ){
                    	 awardedItems = [SELECT Id, Phoenix_Product__r.Name,Phoenix_Product__r.ProductCode,Phoenix_Final_Total_Selling_Unit__c,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Awarded_Quantity__c,Phoenix_Customer_Response_Line__r.Phoenix_Supply_Effective_Date__c,Phoenix_Customer_Response_Line__r.Phoenix_Price_Effective_Date__c,Phoenix_Bid_Status__c,Phoenix_Supply_Effective_Date__c,Phoenix_Price_Effective_Date__c,Phoenix_Customer_Service_Comments__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =:Bid_ID AND Phoenix_Customer_Approval_OTC__c =: 'Approved'];
                        	 rejectedItems = [SELECT Id,Phoenix_Product__r.Name,Phoenix_Product__r.ProductCode,Phoenix_Final_Total_Selling_Unit__c,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Awarded_Quantity__c,Phoenix_Customer_Decline_Reasons__c,Phoenix_Bid_Status__c,Phoenix_Supply_Effective_Date__c,Phoenix_Price_Effective_Date__c,Phoenix_Customer_Service_Comments__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =:Bid_ID AND Phoenix_Customer_Approval_OTC__c =: 'Not Approved'];
                    }
                        System.debug('bidLineItemMap==>' +bidLineItemMap.values());
                        /*added by satya*/
                        String approver,rejection_Approver;
                        List<String> rejectionApproverList = new List<String>();
                        List<Phoenix_Bid_Process_Steps__c> bidProcessSteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
                                                                              Phoenix_Approver__r.Email,Phoenix_Process_Step__r.Name,Phoenix_Approver_Email__c, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__C =: Bid_ID order by Phoenix_Approval_Sent_Time__c desc];
                        List < Phoenix_Bid_Process_Steps__c > nextSteps = new List < Phoenix_Bid_Process_Steps__c > ();
                        for (Phoenix_Bid_Process_Steps__c step: bidProcessSteps) {
                            if(step.Phoenix_Status__c == 'In Process'){
                                approver = step.Phoenix_Approver__c;
                            }
                            if(step.Phoenix_Status__c == 'Completed'){
                                rejectionApproverList.add(step.Phoenix_Approver__r.Name);
                            }
                        }
                        if(rejectionApproverList != null){
                            if(rejectionApproverList[0] != null){
                            rejection_Approver = rejectionApproverList[0];
                            }else{
                                rejection_Approver = rejectionApproverList[1];
                            }
                        }
                        String statusName = '';
                        string tableData = '';
                        Integer sNo = 0;
                        String content = '';
                        String subject,title;
                        Boolean isMarktLeadRxRejected = false;
                        Boolean isCustResRejected = false;
                       
                        List<Phoenix_Bid_Line_Item__c> bid_LineItems =new List<Phoenix_Bid_Line_Item__c>();
                        bid_LineItems.addAll(bidLineItemMap.values());
                        if(bid_LineItems.size() > 0){
                            statusName =  bid_LineItems[0].Phoenix_Bid_Line_Item_Approval_Status__c;
                            if(bid_LineItems[0].Phoenix_Marketing_Lead_Rx__c  == 'Not Approved'){
                                System.debug('in market lead rx rejected' +isMarktLeadRxRejected);
                                //isMarktLeadRxRejected = true;
                            }
                            if(bid_LineItems[0].Phoenix_Customer_Approval_OTC__c == 'Not Approved'){
                                isCustResRejected = true;
                            }
                        } 
                        List<Phoenix_Approval_Grid__c> grids = [select id,Phoenix_Marketing_Lead_Rx__c,Phoenix_Marketing_Lead_OTC__c,Phoenix_Marketing_Lead_SRx__c from Phoenix_Approval_Grid__c where 	Phoenix_Bid__c =: Bid_ID AND (Phoenix_Marketing_Lead_Rx__c =: 'Not Approved' OR Phoenix_Marketing_Lead_OTC__c =: 'Not Approved' OR Phoenix_Marketing_Lead_SRx__c =: 'Not Approved')];
                        if(grids.size()>0){
                            isMarktLeadRxRejected = true;
                        }
                         /*for platform otb*/
                         System.debug('bidLineItemMap size==>'+bidLineItemMap.values().size());
                        Boolean otbMarketingRejection = false;
                        if(bid_Type == 'Platform OTB'){
                            if(bid_LineItems.size() > 0){
                                if(bid_LineItems[0].Phoenix_Marketing_Approval__c == 'Not Approved'){
                                    otbMarketingRejection = true; 
                                }
                            }
                        }
                        System.debug('otbMarketingRejection==>'+otbMarketingRejection);
                        /*end for platform otb*/
                        String dynamicSubject = '';  String dynamicTitle = '';String content1 = '';String table_Data = '';
                        /*for marketing rejection*/
                        //rejection_Approver
                        if(bid_Type != 'Product Discontinuation Process' && bid_Type != 'Mass Product Removals' && (statusName == 'Marketing Rejected' || otbMarketingRejection)){
                             String prodDirector = '';
                            for (Phoenix_Bid_Line_Item__c lineItem: bidLineItemMap.values()) {
                                prodDirector = lineItem.Phoenix_Product__r.Phoenix_Product_Director__r.Name;
                            }
                            //bid.Phoenix_Bid_Type__c
                            dynamicSubject = 'Marketing Rejection of '+bidTypesmap.get(bid.Phoenix_Bid_Type__c)+' - '+bid.Name+' - '+bid.Phoenix_Customer__r.Name;
                            dynamicTitle = 'Marketing Rejection of Bid Products';
                            content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style=" padding:4px 8px 4px 8px;">Dear Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 8px;"><span style="font-size: 14px;font-family: Sans-Serif;">We want to inform you that '+prodDirector+' has rejected the following bid line item(s). Please refer to the tables displayed below for an overview of rejected bid line item(s).</span> </td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:0px 8px 8px 8px"><b>Bid details:</b></td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';                            
                            content1 += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+BID_ID+'">'+bidNumber+'</a></a></th></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid_Name+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bid_Type+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+custName+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+creatBy_Name+'</td></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Salesperson</th><td style="border: 1px solid black;padding: 8px;">'+sales_Person+'</td></tr>';
                            //content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Approval_Status__c+'</td></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Internal Deadline</th>';
                            if (internalDueDateTime != null) {
                                content1 += '<td style="border: 1px solid black;padding: 8px;">'+internalDueDateTime.format('MMM d yyyy')+'</td></tr>';
                            } else{
                                content1 += '<td style="border: 1px solid black;"></td></tr></thead></table><br/>';
                            }
                            content1 += '<tr><th style="width: 34px;"><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Bid Deadline</th>';
                            if (customerBidDeadline != null) {
                                content1 += '<td style="border: 1px solid black;padding: 8px;">'+customerBidDeadline.format('MMM d yyyy')+'</td></tr></thead></table>';   
                            } else{
                                content1 += '<td style="border: 1px solid black;"></td></tr></thead></table>';
                            }
                            content1 += '</td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 4px 8px 8px 8px;"><b>Rejection Details:</b></td></tr></table>';
                            content1 += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"><thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">S No.</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Name</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Code</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Marketing Director</th><th style="border: 1px solid black;padding: 8px;text-align:left;background-color:#d4bdf8;">Reason for Rejection</th>';
                            content1 += '<tbody>';
                            integer i = 1;
                            for (Phoenix_Bid_Line_Item__c lineItem: bidLineItemMap.values()) {
                                String marketingcomments = lineItem.Phoenix_Marketing_Notes__c != null ? lineItem.Phoenix_Marketing_Notes__c :  '';
                                content1 += '<tr><td style="width: 26px;"></td><td style="border: 1px solid black;text-align:center;padding:8px;">'+i+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Product__r.Name+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Product__r.ProductCode+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Product__r.Phoenix_Product_Director__r.Name+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+ marketingcomments+'</td></tr>';
                                //prodFamilyString += i + '.' + pfamily + '<br/>';
                                i++;
                            }
                            content1 += '</tbody></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 8px 8px;">To review the rejected bid line item(s), refer to the link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a>.</b></td></tr></table>';
                            
                        }
                        /*end for marketing rejection*/
                        /* marketing lead rejected*/
                        if( bid_Type != 'Product Discontinuation Process' && bid_Type != 'Mass Product Removals' && statusName == 'Marketing Lead Rx Rejected'){//for marketing lead rejection//Marketing Head Pending
                            List<String> approvernames= new List<String>();
                            String mktLeadRejctnApprover = '';
                           
                            List<Phoenix_Bid_Process_Steps__c> bid_ProcessSteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
                                                                                   Phoenix_Approver__r.Email,Phoenix_Process_Step__r.Name,Phoenix_Approver_Email__c, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE 	Phoenix_Bid__c =: Bid_ID order by Phoenix_Approval_Sent_Time__c desc];
                            for (Phoenix_Bid_Process_Steps__c step: bid_ProcessSteps) {
                                if(step.Phoenix_Status__c == 'Completed'){
                                    approvernames.add(step.Phoenix_Approver__r.Name);
                                }
                            }
                            if(approvernames != null){
                                mktLeadRejctnApprover =   approvernames[0];
                            }
                            //bid.Phoenix_Bid_Type__c
                            dynamicSubject = 'Marketing Lead Rejection of '+bidTypesmap.get(bid.Phoenix_Bid_Type__c)+' - '+bid.Name+' - '+bid.Phoenix_Customer__r.Name;
                            dynamicTitle = 'Marketing Lead Rejection of Bid Products';
                            content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style=" padding:8px 8px 0px 8px;">Dear '+rejection_Approver+',</td></tr><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 4px 8px;"><span style="font-size: 14px;font-family: Sans-Serif;">We want to inform you that '+mktLeadRejctnApprover+' has rejected the following bid line item(s) where you have provided your inputs on pricing. Please refer to the tables displayed below for an overview of rejected Bid line items.</span> </td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:0px 8px 4px 8px"><b>Bid Details:</b></td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';                            
                            content1 += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+BID_ID+'">'+bidNumber+'</a></a></th></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid_Name+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bid_Type+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+custName+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+creatBy_Name+'</td></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Salesperson</th><td style="border: 1px solid black;padding: 8px;">'+sales_Person+'</td></tr>';
                            //content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Approval_Status__c+'</td></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Internal Deadline</th>';
                            if (internalDueDateTime != null) {
                                content1 += '<td style="border: 1px solid black;padding: 8px;">'+internalDueDateTime.format('MMM d yyyy')+'</td></tr>';
                            } else{
                                content1 += '<td style="border: 1px solid black;"></td></tr></thead></table><br/>';
                            }
                            content1 += '<tr><th style="width: 34px;"><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Bid Deadline</th>';
                            if (customerBidDeadline != null) {
                                content1 += '<td style="border: 1px solid black;padding: 8px;">'+customerBidDeadline.format('MMM d yyyy')+'</td></tr></thead></table>';   
                            } else{
                                content1 += '<td style="border: 1px solid black;"></td></tr></thead></table>';
                            }
                            content1 += '</td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 2px 8px 8px 8px;"><b>Rejection Details:</b></td></tr></table>';
                            content1 += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"><thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">S No.</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Name</th><th style="border: 1px solid black;padding: 8px;text-align:left;background-color:#d4bdf8;">Product Code</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Marketing Lead</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Reason for Rejection</th>';
                            content1 += '<tbody>';
                            
                            integer i = 1;
                            for (Phoenix_Bid_Line_Item__c lineItem: bidLineItemMap.values()) {
                                content1 += '<tr><td style="width: 26px;"></td><td style="border: 1px solid black;text-align:center;padding:8px;">'+i+'</td><td style="border: 1px solid black;text-align:left;;padding: 8px;">'+lineItem.Phoenix_Product__r.Name+'</td><td style="border: 1px solid black;text-align:right;;padding: 8px;">'+lineItem.Phoenix_Product__r.ProductCode+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Product__r.Phoenix_Product_Director__r.Name+'</td>';
                                if(lineItem.Phoenix_Business_Head_Comments__c != null){
                                	content1 += '<td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Business_Head_Comments__c+'</td></tr>';
                                    }else{
                                      content1 += '<td style="border: 1px solid black;text-align:left;;padding:8px;">'+''+'</td></tr>';
  
                                    }
                                //prodFamilyString += i + '.' + pfamily + '<br/>';
                                i++;
                            }
                            content1 += '</tbody></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 8px 8px;">To review the rejected bid line item(s), refer to the link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a>.</b></td></tr></table>';
                            
                        }
                        /*end for marketing lead rejeted*/
                        /* for finance rejection*/
                        if(bid_Type != 'Product Discontinuation Process' && bid_Type != 'Mass Product Removals' && statusName == 'Finance Rejected'){
                           //bid.Phoenix_Bid_Type__c
                            dynamicSubject = 'Finance Rejection of '+bidTypesmap.get(bid.Phoenix_Bid_Type__c)+' - '+bid.Name+' - '+bid.Phoenix_Customer__r.Name;
                            dynamicTitle = 'Finance Rejection of Bid Product';
                            content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style=" padding:8px 8px 0px 8px;">Dear Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 8px;"><span style="font-size: 14px;font-family: Sans-Serif;">We want to inform you that '+rejection_Approver+' has rejected the following bid line item(s). Please refer to the tables displayed below for an overview of rejected bid line item(s).</span> </td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:0px 8px 4px 8px"><b>Bid details:</b></td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';                            
                            content1 += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+BID_ID+'">'+bidNumber+'</a></a></th></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid_Name+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bid_Type+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+custName+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+creatBy_Name+'</td></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Salesperson</th><td style="border: 1px solid black;padding: 8px;">'+sales_Person+'</td></tr>';
                            //content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Approval_Status__c+'</td></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Internal Deadline</th>';
                            if (internalDueDateTime != null) {
                                content1 += '<td style="border: 1px solid black;padding: 8px;">'+internalDueDateTime.format('MMM d yyyy')+'</td></tr>';
                            } else{
                                content1 += '<td style="border: 1px solid black;"></td></tr></thead></table><br/>';
                            }
                            content1 += '<tr><th style="width: 34px;"><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Bid Deadline</th>';
                            if (customerBidDeadline != null) {
                                content1 += '<td style="border: 1px solid black;padding: 8px;">'+customerBidDeadline.format('MMM d yyyy')+'</td></tr></thead></table>';   
                            } else{
                                content1 += '<td style="border: 1px solid black;"></td></tr></thead></table>';
                            }
                            content1 += '</td></tr></table>';
                            //content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;width:50%"></td><td style="padding: 4px 8px 8px 8px;"><b>Rejection Details:</b></td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 4px 8px 8px 8px;"><b>Rejection Details:</b></td></tr></table>';

                            content1 += '<table style="border-collapse: collapse;width:60%;font-family: Sans-Serif;font-size: 14px;"><thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:center;background-color:#d4bdf8;">S No.</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Product Name</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Product Code</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Finance Planner</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Reason for Rejection</th>';
                            content1 += '<tbody>';
                            
                            integer i = 1;
                            for (Phoenix_Bid_Line_Item__c lineItem: bidLineItemMap.values()) {
                                content1 += '<tr><td style="width: 26px;"></td><td style="border: 1px solid black;text-align:center;padding:4px 8px;">'+i+'</td><td style="border: 1px solid black;text-align:left;;padding:4px 8px;">'+lineItem.Phoenix_Product__r.Name+'</td><td style="border: 1px solid black;text-align:left;;padding:4px 8px;">'+lineItem.Phoenix_Product__r.ProductCode+'</td><td style="border: 1px solid black;text-align:left;;padding:4px 8px;">'+rejection_Approver+'</td><td style="border: 1px solid black;text-align:left;;padding:4px 8px;">'+lineItem.Phoenix_Finance_Comments__c+'</td></tr>';
                                //prodFamilyString += i + '.' + pfamily + '<br/>';
                                i++;
                            }
                            content1 += '</tbody></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 8px 8px;">To review the rejected bid line item(s), refer to the link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a>.</b></td></tr></table>';
                        }
                        /*end for finance rejection*/
                        /*for contracts rejection*/
                        if(bid_Type != 'Product Discontinuation Process' && bid_Type != 'Mass Product Removals' && statusName == 'Contracts Rejected'){ 
                            //bid.Phoenix_Bid_Type__c
                            dynamicSubject = 'Contracts Rejection of '+bidTypesmap.get(bid.Phoenix_Bid_Type__c)+' - '+bid.Name+' - '+bid.Phoenix_Customer__r.Name;
                            dynamicTitle = 'Contracts Rejection of Bid Product';
                            content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style=" padding:8px 8px 0px 8px;">Dear Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 4px 8px;"><span style="font-size: 14px;font-family: Sans-Serif;">We want to inform you that '+rejection_Approver+' has rejected the following bid line item(s). Please refer to the tables displayed below for an overview of rejected bid line item(s).</span> </td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:0px 8px 8px 8px"><b>Bid details:</b></td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';                            
                            content1 += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+BID_ID+'">'+bidNumber+'</a></a></th></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid_Name+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bid_Type+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+custName+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+creatBy_Name+'</td></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Salesperson</th><td style="border: 1px solid black;padding: 8px;">'+sales_Person+'</td></tr>';
                            //content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Approval_Status__c+'</td></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Internal Deadline</th>';
                            if (internalDueDateTime != null) {
                                content1 += '<td style="border: 1px solid black;padding: 8px;">'+internalDueDateTime.format('MMM d yyyy')+'</td></tr>';
                            } else{
                                content1 += '<td style="border: 1px solid black;"></td></tr></thead></table><br/>';
                            }
                            content1 += '<tr><th style="width: 34px;"><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Bid Deadline</th>';
                            if (customerBidDeadline != null) {
                                content1 += '<td style="border: 1px solid black;padding: 8px;">'+customerBidDeadline.format('MMM d yyyy')+'</td></tr></thead></table>';   
                            } else{
                                content1 += '<td style="border: 1px solid black;"></td></tr></thead></table>';
                            }
                            content1 += '</td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 2px 8px 8px 8px;"><b>Rejection Details:</b></td></tr></table>';
                            content1 += '<table style="border-collapse: collapse;width:60%;font-family: Sans-Serif;font-size: 14px;"><thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:center;background-color:#d4bdf8;">S No.</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Product Name</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Product Code</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Contracts User</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Reason for Rejection</th>';
                            content1 += '<tbody>';
                            
                            integer i = 1;
                            for (Phoenix_Bid_Line_Item__c lineItem: bidLineItemMap.values()) {
                                content1 += '<tr><td style="width: 26px;"></td><td style="border: 1px solid black;text-align:center;padding:4px 8px;">'+i+'</td><td style="border: 1px solid black;text-align:left;;padding:4px 8px;">'+lineItem.Phoenix_Product__r.Name+'</td><td style="border: 1px solid black;text-align:left;;padding:4px 8px;">'+lineItem.Phoenix_Product__r.ProductCode+'</td><td style="border: 1px solid black;text-align:left;;padding:4px 8px;">'+rejection_Approver+'</td><td style="border: 1px solid black;text-align:left;;padding:4px 8px;">'+lineItem.Phoenix_Contract_Comments__c+'</td></tr>';
                                //prodFamilyString += i + '.' + pfamily + '<br/>';
                                i++;
                            }
                            content1 += '</tbody></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;">To review the rejected bid line item(s), refer to the link <a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a>.</td></tr></table>';
                            
                        }
                        /*end for contracts rejection*/
                        /* for customer rejected*/
                        if(bid_Type != 'Product Discontinuation Process' && bid_Type != 'Mass Product Removals' && (statusName == 'Customer Rejected' || isCustResRejected)){
                            Integer totalCount = awardedItems.size()+rejectedItems.size();
                            //bid.Phoenix_Bid_Type__c
                            dynamicSubject = 'Customer Response line items Rejection in '+bidTypesmap.get(bid.Phoenix_Bid_Type__c)+' - '+bid.Name+' - '+bid.Phoenix_Customer__r.Name;
                            dynamicTitle = 'Customer Response of Bid Line Items';
                            content1 = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style=" padding:8px 8px 4px 8px;">Dear Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 4px 8px 8px 8px;"><span style="font-size: 14px;font-family: Sans-Serif;">We want to inform you that '+rejection_Approver+' has updated the below listed bid line item(s). Please refer to the tables displayed below for an overview of the bid line item(s).</span> </td></tr></table>';
                            content1 += '<table align="center" style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;min-width: 70%;"> <tr><td style="width: 30%;padding-right: 10px;">';
                            content1 += '<table align="center" style="width: 100%;background-color:#d4bdf8;border-radius: 15px;padding:20px;font-size: 18px;font-family: Sans-Serif;"><tr><th> '+totalCount+' Total Items</b></th></tr></table>';
                            content1 += '</td>';
                            content1 += '<td style="padding-left: 10px;padding-right: 10px;width: 30%;"> <table align="center" style="width: 100%;background-color:#d4bdf8;border-radius: 15px;padding:20px;font-size: 18px;font-family: Sans-Serif;"><tr><th> '+awardedItems.size()+' Item(s) Awarded</b></th></tr></table>';
                            content1 += '</td>';
                            content1 += '<td style="padding-left: 10px;padding-right: 10px;width: 30%;"> <table align="center" style="width: 100%;background-color:#d4bdf8;border-radius: 15px;padding:20px;font-size: 18px;font-family: Sans-Serif;"><tr><th> ' +rejectedItems.size()+' Item(s) Rejected</b></th></tr></table>';
                            content1 += '</td>';
                            content1 += '</tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:8px;"><b>Bid Details:</b></td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';                            
                            content1 += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+BID_ID+'">'+bidNumber+'</a></a></th></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid_Name+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bid_Type+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+custName+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+creatBy_Name+'</td></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Salesperson</th><td style="border: 1px solid black;padding: 8px;">'+sales_Person+'</td></tr>';
                            //content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Approval_Status__c+'</td></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Internal Deadline</th>';
                            if (internalDueDateTime != null) {
                                content1 += '<td style="border: 1px solid black;padding: 8px;">'+internalDueDateTime.format('MMM d yyyy')+'</td></tr>';
                            } else{
                                content1 += '<td style="border: 1px solid black;"></td></tr></thead></table><br/>';
                            }
                            content1 += '<tr><th style="width: 34px;"><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Bid Deadline</th>';
                            if (customerBidDeadline != null) {
                                content1 += '<td style="border: 1px solid black;padding: 8px;">'+customerBidDeadline.format('MMM d yyyy')+'</td></tr></thead></table>';   
                            } else{
                                content1 += '<td style="border: 1px solid black;"></td></tr></thead></table>';
                            }
                            content1 += '</td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 8px 8px;"><b>Awarded Items:</b></td></tr></table>';
                          
                            content1 += '<table style="width: 100%;border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"><thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:center;background-color:#d4bdf8;">S No.</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Product Name</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Product Code</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Final Total Selling Unit(s)</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Final Approved Pricing</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Awarded Quantity</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Supply Effective Date</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Price Effective Date</th>';
                            content1 += '<tbody>';
                            integer j = 1;
                            for (Phoenix_Bid_Line_Item__c lineItem: awardedItems) {
                                DateTime effectiveDate;DateTime otcEffectiveDate;
                                if (lineItem.Phoenix_Customer_Response_Line__r.Phoenix_Supply_Effective_Date__c != null) 
                                    effectiveDate = DateTime.newInstance(lineItem.Phoenix_Customer_Response_Line__r.Phoenix_Supply_Effective_Date__c, Time.newInstance(0, 0, 0, 0));  
                                else if(lineItem.Phoenix_Customer_Response_Line__r.Phoenix_Price_Effective_Date__c != null) 
                                    effectiveDate = DateTime.newInstance(lineItem.Phoenix_Customer_Response_Line__r.Phoenix_Price_Effective_Date__c, Time.newInstance(0, 0, 0, 0)); 
                                if(lineItem.Phoenix_Supply_Effective_Date__c != null){
                                   otcEffectiveDate =  DateTime.newInstance(lineItem.Phoenix_Supply_Effective_Date__c, Time.newInstance(0, 0, 0, 0));
                                }
                                content1 += '<tr><td style="width: 26px;"></td><td style="border: 1px solid black;text-align:center;padding:8px;">'+j+'</td><td style="border: 1px solid black;text-align:left;padding:8px;">'+lineItem.Phoenix_Product__r.Name+'</td><td style="border: 1px solid black;text-align:right;;padding:8px;">'+lineItem.Phoenix_Product__r.ProductCode+'</td>';
                                if(lineItem.Phoenix_Final_Total_Selling_Unit__c != null){
                                 String finalTotalSellingUnits = lineItem.Phoenix_Final_Total_Selling_Unit__c != null ? lineItem.Phoenix_Final_Total_Selling_Unit__c.format() : '';
                                	content1 += '<td style="border: 1px solid black;text-align:right;;padding:8px;">'+finalTotalSellingUnits+'</td>';
                                }
                                else content1 += '<td style="border: 1px solid black;text-align:left;;padding:8px;">&nbsp;</td>';
                                if(lineItem.Phoenix_ProposedContractBidPriceMktng__c != null){
                                   String finalApprovedPricing = AllEmailNotificationsSenderCls.getCurrencyFormatted((lineItem.Phoenix_ProposedContractBidPriceMktng__c).setScale(0));
                                    content1 += '<td style="border: 1px solid black;text-align:right;;padding:8px;">'+finalApprovedPricing+'</td>';
                                }
                                else content1 += '<td style="border: 1px solid black;text-align:left;;padding:8px;">&nbsp;</td>';
                                if(lineItem.Phoenix_Awarded_Quantity__c != null){
                                     String awarededQuantity = lineItem.Phoenix_Awarded_Quantity__c != null ? lineItem.Phoenix_Awarded_Quantity__c.format() : '';
                                    content1 += '<td style="border: 1px solid black;text-align:right;;padding:8px;">'+awarededQuantity+'</td>';
                                }
                                else content1 += '<td style="border: 1px solid black;text-align:left;;padding:8px;">&nbsp;</td>';
                             if(bid_Type != 'OTC Product Addition' && bid_Type != 'OTC Price Change' && bid_Type != 'OTC RFP' && bid_Type != 'OTC Rebate Change' && bid_Type != 'OTC Volume Review' && bid_Type != 'OTC New Product' && bid_Type != 'OTC OTB Good Dated' && bid_Type != 'OTC OTB Short Date' ){

                                if (effectiveDate != null) {
                                    content1 += '<td style="border: 1px solid black;text-align:left;;padding:8px;">'+effectiveDate.format('MMM d yyyy')+'</td>';   
                                } else{
                                    content1 += '<td style="border: 1px solid black;text-align:left;;padding:8px;">&nbsp;</td>';
                                }
                               DateTime priceeffectiveDate = lineItem.Phoenix_Customer_Response_Line__r.Phoenix_Price_Effective_Date__c;
                                if (priceeffectiveDate != null) {
                                    content1 += '<td style="border: 1px solid black;text-align:left;;padding:8px;">'+priceeffectiveDate.format('MMM d yyyy')+'</td>';   
                                } else{
                                    content1 += '<td style="border: 1px solid black;text-align:left;;padding:8px;">&nbsp;</td>';
                                }
                             }
                             if(bid_Type == 'OTC Product Addition' || bid_Type == 'OTC Price Change' || bid_Type == 'OTC RFP' || bid_Type == 'OTC Rebate Change' || bid_Type == 'OTC Volume Review' || bid_Type == 'OTC New Product' || bid_Type == 'OTC OTB Good Dated' || bid_Type == 'OTC OTB Short Date' ){
                           		if (otcEffectiveDate != null) {
                                    content1 += '<td style="border: 1px solid black;text-align:left;;padding:8px;">'+otcEffectiveDate.format('MMM d yyyy')+'</td>';   
                                } else{
                                    content1 += '<td style="border: 1px solid black;text-align:left;;padding:8px;">&nbsp;</td>';
                                }
                               DateTime otcPriceEffectiveDate = lineItem.Phoenix_Price_Effective_Date__c;
                                if (otcPriceEffectiveDate != null) {
                                    content1 += '<td style="border: 1px solid black;text-align:left;;padding:8px;">'+otcPriceEffectiveDate.format('MMM d yyyy')+'</td>';   
                                } else{
                                    content1 += '<td style="border: 1px solid black;text-align:left;;padding:8px;">&nbsp;</td>';
                                }
                             }
                             
                                /*if(lineItem.Phoenix_Customer_Decline_Reasons__c != null) content1 += '<td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Customer_Decline_Reasons__c+'</td>';
                                else content1 += '<td style="border: 1px solid black;text-align:left;;padding:8px;">&nbsp;</td>';*/
                                //prodFamilyString += i + '.' + pfamily + '<br/>';
                                j++;
                            }
                          
                            content1 += '</tbody></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 8px 8px;"><b>Rejected Items:</b></td></tr></table>';
                            content1 += '<table style="width: 100%;border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"><thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:center;background-color:#d4bdf8;">S No.</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Product Name</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Product Code</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Proposed Selling Unit(s)</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Final Proposed Pricing</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Bid Status</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Customer Decline Reasons</th>';
                            content1 += '<tbody>';
                            
                            integer i = 1;
                            for (Phoenix_Bid_Line_Item__c lineItem: rejectedItems) {
                                content1 += '<tr><td style="width: 26px;"></td><td style="border: 1px solid black;text-align:center;padding:4px 8px;">'+i+'</td><td style="border: 1px solid black;text-align:left;;padding:4px 8px;">'+lineItem.Phoenix_Product__r.Name+'</td><td style="border: 1px solid black;text-align:right;;padding:4px 8px;">'+lineItem.Phoenix_Product__r.ProductCode+'</td>';
                                if(lineItem.Phoenix_Final_Total_Selling_Unit__c != null) {
                                   String proposedSellingUnits = lineItem.Phoenix_Final_Total_Selling_Unit__c != null ? lineItem.Phoenix_Final_Total_Selling_Unit__c.format() : '';
                                    content1 += '<td style="border: 1px solid black;text-align:right;padding:4px 8px;">'+ proposedSellingUnits+'</td>';
                                }
                                else content1 += '<td style="border: 1px solid black;text-align:left;;padding:4px 8px;"></td>';
                                if(lineItem.Phoenix_ProposedContractBidPriceMktng__c != null) {
                                   String finalApprovedPricing = AllEmailNotificationsSenderCls.getCurrencyFormatted((lineItem.Phoenix_ProposedContractBidPriceMktng__c).setScale(0));
                                    content1 += '<td style="border: 1px solid black;text-align:right;;padding:4px 8px;">'+ finalApprovedPricing+'</td>';
                                }
                                else content1 += '<td style="border: 1px solid black;text-align:left;;padding:4px 8px;"></td>';
                                if(lineItem.Phoenix_Bid_Status__c != null)  content1 += '<td style="border: 1px solid black;text-align:left;;padding:4px 8px;">'+ lineItem.Phoenix_Bid_Status__c+'</td>';
                                else content1 += '<td style="border: 1px solid black;text-align:left;;padding:4px 8px;"></td>';
                                if(bid_Type != 'OTC Product Addition' && bid_Type != 'OTC Price Change' && bid_Type != 'OTC RFP' && bid_Type != 'OTC Rebate Change' && bid_Type != 'OTC Volume Review' && bid_Type != 'OTC New Product' && bid_Type != 'OTC OTB Good Dated' && bid_Type != 'OTC OTB Short Date' ){

                                if(lineItem.Phoenix_Customer_Decline_Reasons__c != null)  content1 += '<td style="border: 1px solid black;text-align:left;;padding:4px 8px;">'+ lineItem.Phoenix_Customer_Decline_Reasons__c+'</td>';
                                else content1 += '<td style="border: 1px solid black;text-align:left;;padding:4px 8px;"></td>';
                                }
                                if(bid_Type == 'OTC Product Addition' || bid_Type == 'OTC Price Change' || bid_Type == 'OTC RFP' || bid_Type == 'OTC Rebate Change' || bid_Type == 'OTC Volume Review' || bid_Type == 'OTC New Product' || bid_Type == 'OTC OTB Good Dated' || bid_Type == 'OTC OTB Short Date' ){
									if(lineItem.Phoenix_Customer_Service_Comments__c != null)  content1 += '<td style="border: 1px solid black;text-align:left;;padding:4px 8px;">'+ lineItem.Phoenix_Customer_Service_Comments__c+'</td>';
                                	else content1 += '<td style="border: 1px solid black;text-align:left;;padding:4px 8px;"></td>';
                                }
                                //prodFamilyString += i + '.' + pfamily + '<br/>';
                                i++;
                            }
                            content1 += '</tbody></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 8px 8px;">To review the customer response, refer to the link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a>.</b></td></tr></table>';
                            
                        }
                        /*end for customer rejected*/
                        
                        
                        //statusName == 'Marketing Lead Rx Rejected' || statusName == 'Marketing Lead SRx Rejected' || statusName == 'Marketing Lead OTC Rejected'
                        if(bid_Type != 'Product Discontinuation Process' && bid_Type != 'Mass Product Removals' && isMarktLeadRxRejected){
                            System.debug('isMarktLeadRxRejected==>' +isMarktLeadRxRejected);
                            tableData += '<table style="border-collapse: collapse;padding:4px"><thead><tr><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 6%;">S. No</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 24%;">Product Name</th><th style="border: 1px solid black;padding:4px;background-color: #d4bdf8;width: 14%;">Product Code</th><th style="border: 1px solid black;padding:4px;background-color: #d4bdf8;width: 14%;">Marketing Lead</th><th style="border: 1px solid black;padding:4px;background-color: #d4bdf8;width: 14%;">Reason for Rejection</th>';   
                        }
                        //if(statusName == 'Marketing Lead Rx Rejected' || statusName == 'Marketing Lead SRx Rejected' || statusName == 'Marketing Lead OTC Rejected'){
                        if(bid_Type != 'Product Discontinuation Process' && bid_Type != 'Mass Product Removals' && isMarktLeadRxRejected){
                            //content = '<div style="color: black; margin: 20px 0px -10px 0px;padding:50px 40px 10px 40px;background-color: white;">Dear '+approver+',<br /><br />';
                            //content +=  'We want to inform you that <Marketing Lead Name> has rejected the following bid line item(s) where you have provided your inputs on pricing. Please refer to the tables displayed below for an overview of rejected Bid line items.<br/><br/>';
                            content = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;">Dear '+approver+',</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;"><span style="font-size: 14px;font-family: Sans-Serif;">We want to inform you that Marketin Lead has rejected. the following bid line item(s) where you have provided your inputs on pricing. Please refer to the tables displayed below for an overview of rejected Bid line items. </span></td></tr></table>';
                            
                        }
                        
                        if(bid_Type != 'Product Discontinuation Process' && bid_Type != 'Mass Product Removals' &&(statusName == 'Customer Rejected' || isCustResRejected)){
                            content = '<div style="color: black; margin: 20px 0px -10px 0px;padding:50px 40px 10px 40px;background-color: white;">Dear Team,<br /><br />';
                            content +=  'We want to inform you that <Contracts user name> has updated the below listed bid line item(s). Please refer to the tables displayed below for an overview of the bid line item(s).<br/><br/>';
                        }
                        
                        //if(statusName == 'Marketing Lead Rx Rejected' || statusName == 'Marketing Lead SRx Rejected' || statusName == 'Marketing Lead OTC Rejected'){
                        if(bid_Type != 'Product Discontinuation Process' && bid_Type != 'Mass Product Removals' && isMarktLeadRxRejected){
                            //content += 'To review the rejected bid line item(s), refer to the link <a href="'+System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+Bid_ID+'">'+bidNumber+'</a><br/><br/>'; 
                            content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To review the rejected bid line item(s), refer to the link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a>.</b></td></tr>';
                            
                            subject = 'Test Marketing Lead Rejection of '+bid_Type+' - '+bidNumber+' - '+custName;
                            title ='Marketing Lead Rejection of Bid Products';
                        }
                        
                        if(bid_Type != 'Product Discontinuation Process' && bid_Type != 'Mass Product Removals' && (statusName == 'Customer Rejected' || isCustResRejected)){
                            content += 'To review the customer response, refer to the link <a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+Bid_ID+'">'+bidNumber+'</a><br/><br/>'; 
                           //bid_Type
                            subject = 'Customer Response line items Rejection in '+bidTypesmap.get(bid.Phoenix_Bid_Type__c)+' - '+bidNumber+' - '+custName;
                            title ='Customer Response of Bid Line Item';
                        }
                        
                        
                        
                        /*end added by satya*/
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
                            System.debug('current_Stage==>'+current_Stage);
                            //Add Sales persons
                            if (item.Phoenix_Bid__r.Phoenix_Sales_Person_2__c != null) {
                                allPeopleInvolvedEmailsSet.add(item.Phoenix_Bid__r.Phoenix_Sales_Person_2__r.Email);
                            } else if (item.Phoenix_Bid__r.Phoenix_Salesperson__c != null) {
                                allPeopleInvolvedEmailsSet.add(item.Phoenix_Bid__r.Phoenix_Salesperson__r.Email);
                            }
                        }
                        /* add to and cc address*/
                        set < string > toaddressset = new set < string > ();
                        set < string > ccaddressSet = new set < string > ();
                        for (string BidId: BidMapWithLineItems.keySet()) {
                            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
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
                            
                        }
                        /* END to and cc address*/
                        
                        
                        List < Phoenix_Bid_Line_Item__c > updatedItems = new List < Phoenix_Bid_Line_Item__c > ();
                        for (Phoenix_Bid_Line_Item__c item: bidLineItemMap.values()) {
                            item.Phoenix_Is_Rejection_Noti_All_Sent__c = true;
                            updatedItems.add(item);
                            
                        }
                        
                        update updatedItems;
                        
                        
                        Boolean isFooterTextAlterRequired = false;
                        AllEmailNotificationsSenderCls.sendEmailAlert(Bid_ID, content1, new List<String> (toaddressset), new List<String> (ccaddressSet), dynamicSubject, dynamicTitle,isFooterTextAlterRequired);
                        System.debug('after sendemail');
                    } Catch(Exception e) {
                        String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
                        System.debug('msg in bid rejection==>'+msg);
                    }
                } 
                else if (objName == 'Phoenix_NDC_Change_Line_Item__c') {
                    try{
                        //AND Phoenix_Is_Rejection_Noti_All_Sent__c = false
                        String ndcChangeName,currentPrdFamily,proposedPrdFamily,ndcId,description,creatBy_Name,prodDirector;
                        ndcLineItemMap = new Map < Id, Phoenix_NDC_Change_Line_Item__c > ([SELECT Id, Phoenix_NDC_Change__r.Owner.Email,
                                                                                           Phoenix_NDC_Line_Item_Approval_Status__c,Phoenix_Remarks__c,Phoenix_SCM_Rejection_Reason__c,	Phoenix_Finance_Approval_Remarks__c,Phoenix_Contracts_Approval_Remarks__c,
                                                                                           Phoenix_NDC_Change__r.Phoenix_Approval_Status__c, Phoenix_NDC_Change__r.Owner.Name,
                                                                                           Phoenix_NDC_Change__r.Name, Name,
                                                                                           Phoenix_NDC_Change__r.Phoenix_Current_Product_Family__c,Phoenix_NDC_Change__r.Phoenix_Proposed_Product_Family__c,Phoenix_NDC_Change__r.Phoenix_Description__c,
                                                                                           Phoenix_Account__r.Name,	Phoenix_Contract__r.Name,Phoenix_Current_Product__r.Name,	Phoenix_Current_Product_NDC__c,	Phoenix_Current_Product_Pack_Size__c,	Phoenix_Proposed_Product__r.Name,Phoenix_Proposed_Product_NDC__c,	Phoenix_Proposed_Product_Pack_Size__c
                                                                                           FROM Phoenix_NDC_Change_Line_Item__c
                                                                                           WHERE Id in: bidLineItemIds AND Phoenix_Final_Status__c =: 'Not Approved'
                                                                                           
                                                                                          ]);
                        System.debug('ndcLineItemMap values==>'+ndcLineItemMap.values().size());
                        for (Phoenix_NDC_Change_Line_Item__c ndcChangeItem: ndcLineItemMap.values()) {
                          
                            String ndcChangeId = ndcChangeItem.Phoenix_NDC_Change__c;
                            //stepName = ndcChangeItem.Phoenix_NDC_Change__r.Phoenix_Approval_Status__c;
                            ndcId = ndcChangeItem.Phoenix_NDC_Change__c;
                            ndcChangeName = ndcChangeItem.Phoenix_NDC_Change__r.Name;
                            currentPrdFamily = ndcChangeItem.Phoenix_NDC_Change__r.Phoenix_Current_Product_Family__c;
                            proposedPrdFamily = ndcChangeItem.Phoenix_NDC_Change__r.Phoenix_Proposed_Product_Family__c;
                            description = ndcChangeItem.Phoenix_NDC_Change__r.Phoenix_Description__c;
                            prodDirector = 'Test Prodct Director';
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
                        String stepName,approver;
                        List<Phoenix_NDC_Change_Line_Item__c> ndc_LineItems =new List<Phoenix_NDC_Change_Line_Item__c>();
                        for (Phoenix_NDC_Change_Line_Item__c ndcChangeItem: ndcLineItemMap.values()) {
                        ndc_LineItems.add(ndcChangeItem);
                        }
                       
                        if(ndc_LineItems.size() > 0){
                            stepName =  ndc_LineItems[0].Phoenix_NDC_Line_Item_Approval_Status__c;
                        } 
                        
                        
                        List<String> stepnames= new List<String>();
                        List<String> approvernames= new List<String>();
                        List<Phoenix_Bid_Process_Steps__c> bidProcSteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
                                                                           Phoenix_Approver__r.Email,Phoenix_Process_Step__r.Name,Phoenix_Approver_Email__c, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE 	Phoenix_NDC_Change__c =: ndcId order by Phoenix_Approval_Sent_Time__c desc];
                         System.debug('approvernames==>'+approvernames);
                        for (Phoenix_Bid_Process_Steps__c step: bidProcSteps) {
                           
                            if(step.Phoenix_Status__c == 'Completed'){
                                // approver = step.Phoenix_Approver__r.Name;
                                //stepName = 	step.Phoenix_Process_Step__r.Name;
                                stepnames.add(step.Phoenix_Process_Step__r.Name);
                                approvernames.add(step.Phoenix_Approver__r.Name);
                                //approverList.add(step.Phoenix_Approver__r.Name);
                                
                            }
                            
                        }
                        /* if(stepnames != null){
stepName = stepnames[0];  
}*/
                        
                        if(approvernames != null){
                            approver =   approvernames[0];
                        }
                        //System.debug('stepName===>'+stepName);
                        string tableData = '';
                        //  tableData += '<b>Rejection Details:</b><br/><br/>';
                        tableData += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>Rejection Details:</b></td></tr></table>';
                        
                        if(stepName == 'Finance Rejected'){
                            tableData += '<table style="border-collapse: collapse;padding:8px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;" rowspan = "2"></th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;min-width:40px;" rowspan="2" >S. No</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;" rowspan="2">Account</th><th style="border: 1px solid black;padding:8px;background-color: #d4bdf8;text-align:left;" rowspan="2">Contract</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;" rowspan="2">Finance Planner</th><th style="border: 1px solid black;padding: 8px; background-color: #d4bdf8; text-align:left;"  rowspan="2">Reason for Rejection</th><th style="border: 1px solid black;padding:8px; background-color: #B8D0F8; text-align:center;" colspan = "3">Current</th><th style="border: 1px solid black;padding:8px; background-color: #FAD385;text-align:center;" colspan = "3">Proposed</th></tr>';
                            tableData += '<tr><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Current Product</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Current Product NDC</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Current Product Pack Size</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Proposed Product</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Proposed Product NDC</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Proposed Product Pack Size</th></tr></thead>';
                            
                            //tableData += '<table style="border-collapse: collapse;padding:4px"><thead><tr><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 6%;">S. No</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 14%;">Account</th><th style="border: 1px solid black;padding:4px;background-color: #d4bdf8;width: 32%;">Contract</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 15%;">Finance Planner</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 15%;">Reason for Rejection</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 15%;">Current Product</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 12%;">Current Product NDC</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 12%;">Current Product Pack Size</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 12%;">Proposed Product</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 12%;">Proposed Product NDC</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 12%;">Proposed Product Pack Size</th></tr></thead>';
                        }
                        if(stepName == 'SCM Rejected'){
                            tableData += '<table style="border-collapse: collapse;padding:8px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;" rowspan = "2"><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;min-width:40px;" rowspan="2">S. No</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;" rowspan="2">Account</th><th style="border: 1px solid black;padding:4px 8px;background-color: #d4bdf8;text-align:left;" rowspan="2">Contract</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;" rowspan="2">SCM Planner</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;"  rowspan="2">Reason for Rejection</th><th style="border: 1px solid black;padding:8px; background-color: #B8D0F8;text-align:center;" colspan = "3">Current</th><th style="border: 1px solid black;padding:8px; background-color: #FAD385;text-align:center;" colspan = "3">Proposed</th></tr>';
                            tableData += '<tr><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Current Product</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Current Product NDC</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Current Product Pack Size</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Proposed Product</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Proposed Product NDC</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Proposed Product Pack Size</th></tr></thead>';
                            
                            //tableData += '<table style="border-collapse: collapse;padding:4px"><thead><tr><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 6%;">S. No</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 14%;">Account</th><th style="border: 1px solid black;padding:4px;background-color: #d4bdf8;width: 32%;">Contract</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 15%;">SCM Planner</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 15%;">Reason for Rejection</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 15%;">Current Product</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 12%;">Current Product NDC</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 12%;">Current Product Pack Size</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 12%;">Proposed Product</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 12%;">Proposed Product NDC</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 12%;">Proposed Product Pack Size</th></tr></thead>';
                        }
                        if(stepName == 'Contracts Pending'){
                            tableData += '<table style="border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;" rowspan = "2"><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;min-width:40px;" rowspan="2">S. No</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;" rowspan="2">Account</th><th style="border: 1px solid black;padding:8px;background-color: #d4bdf8;text-align:left;" rowspan="2">Contract</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;" rowspan="2">Contracts Planner</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;"  rowspan="2">Reason for Rejection</th><th style="border: 1px solid black;padding:8px; background-color: #B8D0F8;text-align:center;" colspan = "3">Current</th><th style="border: 1px solid black;padding:8px; background-color: #FAD385;text-align:center;" colspan = "3">Proposed</th></tr>';
                            tableData += '<tr><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Current Product</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Current Product NDC</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Current Product Pack Size</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Proposed Product</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Proposed Product NDC</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Proposed Product Pack Size</th></tr></thead>';
                            
                            //tableData += '<table style="border-collapse: collapse;padding:4px"><thead><tr><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 6%;">S. No</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 14%;">Account</th><th style="border: 1px solid black;padding:4px;background-color: #d4bdf8;width: 32%;">Contract</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 15%;">Contracts Planner</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 15%;">Reason for Rejection</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 15%;">Current Product</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 12%;">Current Product NDC</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 12%;">Current Product Pack Size</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 12%;">Proposed Product</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 12%;">Proposed Product NDC</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 12%;">Proposed Product Pack Size</th></tr></thead>';
                            
                        }
                        tableData += '<tbody>';
                        integer sNo = 0;
                        for (string ndcChangeId: ndcChangeMapWithLineItems.keySet()) {
                            for (Phoenix_NDC_Change_Line_Item__c ndcChangeItem: ndcChangeMapWithLineItems.get(ndcChangeId)) {
                                sNo++;
                                tableData += '<tr>';
                                tableData += '<td style="width: 26px;"></td>';
                                tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + sNo + '</td>';
                                if (ndcChangeItem.Phoenix_Account__r.Name != null) tableData += '<td style="border: 1px solid black;text-align:left;padding:8px;">' + ndcChangeItem.Phoenix_Account__r.Name + '</td>';
                                else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                
                                if (ndcChangeItem.Phoenix_Contract__r.Name != null) {
                                    tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + ndcChangeItem.Phoenix_Contract__r.Name + '</td>';
                                } else {
                                    tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                }
                                if(stepName == 'SCM Rejected'){
                                    if (approver!= null) {
                                        tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + approver + '</td>';
                                    } else {
                                        tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                    }
                                    if (ndcChangeItem.Phoenix_Remarks__c != null) {
                                        tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + ndcChangeItem.Phoenix_Remarks__c + '</td>';
                                    } else {
                                        tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                    }
                                }
                                if(stepName == 'Finance Rejected'){
                                    if (approver != null) {
                                        tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + approver + '</td>';
                                    } else {
                                        tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                    }
                                    if (ndcChangeItem.Phoenix_Finance_Approval_Remarks__c != null) {
                                        tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + ndcChangeItem.Phoenix_Finance_Approval_Remarks__c + '</td>';
                                    } else {
                                        tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                    }
                                }
                                if(stepName == 'Contracts Pending'){
                                    if (approver != null) {
                                        tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + approver + '</td>';
                                    } else {
                                        tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                    }
                                    if (ndcChangeItem.Phoenix_Contracts_Approval_Remarks__c != null) {
                                        tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + ndcChangeItem.Phoenix_Contracts_Approval_Remarks__c + '</td>';
                                    } else {
                                        tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                    }
                                }
                                //tableData += '<td style="width: 26px;">';
                                if (ndcChangeItem.Phoenix_Current_Product__r.Name != null) tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + ndcChangeItem.Phoenix_Current_Product__r.Name + '</td>';
                                else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                
                                
                                if (ndcChangeItem.Phoenix_Current_Product_NDC__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding: 8px;">'+ ndcChangeItem.Phoenix_Current_Product_NDC__c + '</td>';
                                else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                if (ndcChangeItem.Phoenix_Current_Product_Pack_Size__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + ndcChangeItem.Phoenix_Current_Product_Pack_Size__c + '</td>';
                                else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                if (ndcChangeItem.Phoenix_Proposed_Product__r.Name != null) tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + ndcChangeItem.Phoenix_Proposed_Product__r.Name + '</td>';
                                else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                if (ndcChangeItem.Phoenix_Proposed_Product_NDC__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + ndcChangeItem.Phoenix_Proposed_Product_NDC__c + '</td>';
                                else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                if (ndcChangeItem.Phoenix_Proposed_Product_Pack_Size__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + ndcChangeItem.Phoenix_Proposed_Product_Pack_Size__c + '</td>';
                                else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                
                                tableData += '</tr>'; 
                                
                            }
                            tableData += '</tbody></table>';
                        }
                        String content = '';
                        //String content = '<div style="color: black; margin: 20px 0px -10px 0px;padding:20px 40px 10px 40px;background-color: white;">Dear Team,<br /><br />';
                        if(stepName == 'Finance Rejected'){
                            //content += 'We are informing you that the NDC Change approval request for the below mentioned items has been rejected by '+approver+'. To view further details and the reason for rejection, please refer to the tables below.<br/><br/>';
                            content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">We are informing you that the NDC Change approval request for the below mentioned items has been rejected by '+approver+'. To view further details and the reason for rejection, please refer to the tables below. </td></tr></table>';
                            
                        }
                        if(stepName == 'Contracts Pending'){
                            // content += 'We are informing you that the NDC Change approval request for the below mentioned items has been rejected by '+approver+'. To view further details and the reason for rejection, please refer to the tables below.<br/><br/>';
                            content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">We are informing you that the NDC Change approval request for the below mentioned items has been rejected by '+approver+'. To view further details and the reason for rejection, please refer to the tables below. </td></tr></table>';
                            
                        }
                        if(stepName == 'SCM Rejected'){
                            // content += 'We are informing you that the NDC Change approval request for the below mentioned items has been rejected by '+approver+'. To view further details and the reason for rejection, please refer to the tables below.<br/><br/>';
                            content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">We are informing you that the NDC Change approval request for the below mentioned items has been rejected by '+approver+'. To view further details and the reason for rejection, please refer to the tables below. </td></tr></table>';
                            
                        }
                        //content += '<b>NDC Change Details:</b></br></br>';
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding:0px 8px 8px 8px;"><b>NDC Change Details:</b></td></tr></table>';
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr>';
                        content += '<td>';
                        content  += '<table style="border-collapse: collapse;padding-left:26px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">NDC Change Name</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+ndcId+'">'+ndcChangeName+'</a></th></tr>';
                        content += '<tr><th style="width: 26px;"><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Product Family</th><td style="border: 1px solid black;padding: 8px;">'+currentPrdFamily+'</td></tr><tr><th style="width: 26px;"><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Proposed Product Family</th><td style="border: 1px solid black;padding: 8px;">'+proposedPrdFamily+'</td></tr>';
                        content += '<tr><th style="width: 26px;"><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Description</th><td style="border: 1px solid black;padding: 8px;">'+description+'</td></tr>';
                        //content += '<tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Product Director</th><td style="border: 1px solid black;padding: 8px;">'+'No Product Director'+'</td></tr>';
                        //content += '<tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Product Director</th><td style="border: 1px solid black;padding: 8px;">'+'Current Stage'+'</td></tr>';
                        
                        content += '</thead></table>';
                        content += '</td></tr></table>';
                        content += tableData;
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To review the rejected item(s), refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+ndcId+'">'+ndcChangeName+'</a></b>.</td></tr></table>';
                        
                        //content += 'To review the rejected item(s), refer to this link <b><a href="'+System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+ndcId+'">'+ndcChangeName+'</a></b>.<br/><br/>';
                        String subject,title;
                        if(stepName == 'Finance Rejected'){
                            subject = 'Finance Rejection of NDC Change - '+ndcChangeName;//'test subject';
                            title ='<span style="font-weight:200">Finance Rejection of '+ndcChangeName+'</span>';
                        }
                        if(stepName == 'Contracts Pending'){
                            subject = 'Contracts Rejection of NDC Change - '+ndcChangeName;//'test subject';
                            title ='<span style="font-weight:200">Contracts Rejection of '+ndcChangeName+'</span>';  
                        }
                        if(stepName == 'SCM Rejected'){
                            subject = 'SCM Rejection of NDC Change - '+ndcChangeName;//'test subject';
                            title ='<span style="font-weight:200">SCM Rejection of '+ndcChangeName+'</span>';  
                        }
                        
                        /*to address*/
                        set < string > toaddressset = new set < string > ();
                        set < string > ccaddressSet = new set < string > ();
                        for (string ndcChangeId: ndcChangeMapWithLineItems.keySet()) {
                            for (Phoenix_NDC_Change_Line_Item__c ndcChangeItem: ndcChangeMapWithLineItems.get(ndcChangeId)) {
                                if (ndcChangeItem.Phoenix_NDC_Change__r.Owner.Email != Null) {
                                    allPeopleInvolvedEmailsSet.add(ndcChangeItem.Phoenix_NDC_Change__r.Owner.Email);
                                }
                                if (ndcChangeIdEmailMap.get(ndcChangeId) != null) toaddressset.AddAll(ndcChangeIdEmailMap.get(ndcChangeId));
                                toaddressset.addAll(allPeopleInvolvedEmailsSet);
                                if (Label.Phoenix_Contracts_DL != null) ccaddressSet.addAll(Label.Phoenix_Contracts_DL.split(','));
                                
                                for (string emailId: toaddressset) {
                                    if (ccaddressSet.contains(emailId))
                                        ccaddressSet.remove(emailId);
                                }
                                If(ccaddressSet != null && ccaddressSet.contains('mkalawadia@drreddys.com'))ccaddressSet.remove('mkalawadia@drreddys.com');
                                If(toaddressset != null && toaddressset.contains('mkalawadia@drreddys.com'))toaddressset.remove('mkalawadia@drreddys.com');
                                
                            }
                        }
                        
                        /*end to address*/
                        if(stepName == 'SCM Rejected' || stepName == 'Contracts Pending' || stepName == 'Finance Rejected'){
                            Boolean isFooterTextAlterRequired = false;
                            AllEmailNotificationsSenderCls.sendEmailAlert(ndcId, content, new List<String> (toaddressset), new List<String> (ccaddressSet), subject, title, isFooterTextAlterRequired);
                        }
                        
                        List < Phoenix_NDC_Change_Line_Item__c > updatedItems = new List < Phoenix_NDC_Change_Line_Item__c > ();
                        for (Phoenix_NDC_Change_Line_Item__c item: ndcLineItemMap.values()) {
                            item.Phoenix_Is_Rejection_Noti_All_Sent__c = true;
                            updatedItems.add(item);
                            
                        }
                        
                        update updatedItems;
                        
                    }
                    Catch(Exception e) {
                        String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
                        System.debug('msg in ndc change rejection==>'+msg);
                    }
                    
                    
                } 
                else if (objName == 'Phoenix_PHS_Price_Change_Line__c') {
                    try{
                        string rectype='';   
                        String content = '';
                        //removed AND Phoenix_Is_Rejection_Noti_All_Sent__c = false
                        pHSLineItemMap = new Map < Id, Phoenix_PHS_Price_Change_Line__c > ([SELECT Id, Phoenix_PHS_Price_Change__r.Owner.Email,
                                                                                            Phoenix_Remarks__c,Phoenix_Product_Name__r.Name,Phoenix_Material_Code__c,Phoenix_NDC_11__c,
                                                                                            Phoenix_Provisional_PHS_Price__c,Phoenix_Finance_Approval_Remarks__c,
                                                                                            Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c, Phoenix_PHS_Price_Change__r.Owner.Name,
                                                                                            Phoenix_PHS_Price_Change__r.Name, Name,Phoenix_PHS_Price_Change__r.Phoenix_PHS_Price_Change_Name__c,
                                                                                            Phoenix_PHS_Price_Change__r.Phoenix_Record_Type__c,Phoenix_PHS_Price_Change__r.Phoenix_PHS_Price_Change_Description__c,
                                                                                            Phoenix_Old_PHS_Price__c,Phoenix_New_PHS_Price__c,Phoenix_Change_in_Price__c,Phoenix_Last_90_days_PHS_Units__c,Phoenix_Sales_Difference__c
                                                                                            FROM Phoenix_PHS_Price_Change_Line__c
                                                                                            WHERE Id in: bidLineItemIds AND Phoenix_Final_Status__c = 'Not Approved'
                                                                                            
                                                                                           ]);
                        String phsId,phsPriceChangeName,phsPriceName,pHSPriceChangeType,Description;
                        for (Phoenix_PHS_Price_Change_Line__c pHSChangeItem: pHSLineItemMap.values()) {
                            String pHSChangeId = pHSChangeItem.Phoenix_PHS_Price_Change__c;
                            phsId = pHSChangeItem.Phoenix_PHS_Price_Change__c;
                            phsPriceName = pHSChangeItem.Phoenix_PHS_Price_Change__r.Phoenix_PHS_Price_Change_Name__c;
                            phsPriceChangeName = pHSChangeItem.Phoenix_PHS_Price_Change__r.Name;
                            pHSPriceChangeType = pHSChangeItem.Phoenix_PHS_Price_Change__r.Phoenix_Record_Type__c;
                            Description = pHSChangeItem.Phoenix_PHS_Price_Change__r.Phoenix_PHS_Price_Change_Description__c;
                            rectype = pHSChangeItem.Phoenix_PHS_Price_Change__r.Phoenix_Record_Type__c;
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
                        set < string > toaddressset = new set < string > ();
                        set < string > ccaddressSet = new set < string > ();
                        string tableData = '';
                        String subject = '';
                        String title ='';
                        List<Phoenix_Bid_Process_Steps__c> bidProcessSteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
                                                                              Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE 	Phoenix_PHS_Price_Change__c =: Bid_ID];
                        System.debug('bidProcessSteps==>'+bidProcessSteps);
                        List<String> approvers = new List<String>();
                        for (Phoenix_Bid_Process_Steps__c step: bidProcessSteps) {
                            if(step.Phoenix_Status__c == 'Completed'){
                                approvers.add(step.Phoenix_Approver__r.Name);
                            }
                        }
                        rejectionApprover = approvers[0];
                        // tableData += '<b>Rejected Item(s):</b><br/><br/>';
                        tableData += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>Rejected Item(s):</b></td></tr></table>';
                        
                        if (rectype == 'Provisional PHS Price Change') {
                            //tableData += '<table style="border-collapse: collapse;padding:4px"><thead><tr><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8; text-align:left;">S. No</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Product Name</th><th style="border: 1px solid black;padding:4px;background-color: #d4bdf8;text-align:right;">Material Code</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;text-align:right;">NDC-11</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;text-align:right;">Provisional PHS Price</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Sr VP of Finance</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Reason for Rejection</th></tr></thead>';
                            tableData += '<table style="border-collapse: collapse;padding:8px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;"></th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;min-width:40px;">S. No</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Product Name</th><th style="border: 1px solid black;padding:8px;background-color: #d4bdf8;text-align:left;">Material Code</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">NDC-11</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Provisional PHS Price</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Sr VP of Finance</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Reason for Rejection</th></tr></thead>';
                            
                        }else{
                            //tableData += '<table style="border-collapse: collapse;padding:4px"><thead><tr><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;;text-align:left;">S. No</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;;text-align:left">Product Name</th><th style="border: 1px solid black;padding:4px;background-color: #d4bdf8;text-align:right;">Material Code</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;;text-align:right">NDC-11</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;;text-align:right">Old PHS Price $</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;text-align:right;">New PHS Price $</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;text-align:right;">% Change in Price</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;text-align:right;">Last 90 days PHS Units</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;;text-align:right">Sales Difference $</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;;text-align:left">Sr VP of Finance</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;;text-align:left">Reason for Rejection</th></tr></thead>';
                            tableData += '<table style="border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;"></th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;min-width:40px;">S. No</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Product Name</th><th style="border: 1px solid black;padding:8px;background-color: #d4bdf8;text-align:left;">Material Code</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">NDC-11</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Old PHS Price $</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">New PHS Price $</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">% Change in Price</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Last 90 days PHS Unit</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Sales Difference $ </th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Sr VP of Finance </th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Reason for Rejection </th></tr></thead>';
                            
                        }
                        tableData += '<tbody>';
                        for (string pHSChangeId: pHSChangeMapWithLineItems.keySet()) {
                            integer sNo = 0;
                            for (Phoenix_PHS_Price_Change_Line__c pHSChangeItem: pHSChangeMapWithLineItems.get(pHSChangeId)) {
                                sNo++;
                                tableData += '<tr>';
                                tableData += '<td style="width: 26px;"></td>';
                                tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + sNo + '</td>';
                                if (pHSChangeItem.Phoenix_Product_Name__r.Name != null) tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + pHSChangeItem.Phoenix_Product_Name__r.Name + '</td>';
                                else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                
                                if (pHSChangeItem.Phoenix_Material_Code__c != null) {
                                    tableData += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + pHSChangeItem.Phoenix_Material_Code__c + '</td>';
                                } else {
                                    tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                }
                                if (pHSChangeItem.Phoenix_NDC_11__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + pHSChangeItem.Phoenix_NDC_11__c + '</td>';
                                else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                if (rectype == 'Provisional PHS Price Change') {
                                    if (pHSChangeItem.Phoenix_Provisional_PHS_Price__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' +'$'+String.valueOf((pHSChangeItem.Phoenix_Provisional_PHS_Price__c).format()) + '</td>';
                                    else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                    
                                }
                                else{
                                    if (pHSChangeItem.Phoenix_Old_PHS_Price__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' +'$'+ String.valueOf((pHSChangeItem.Phoenix_Old_PHS_Price__c).format()) + '</td>';
                                    else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                    if (pHSChangeItem.Phoenix_New_PHS_Price__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' +'$'+String.valueOf((pHSChangeItem.Phoenix_New_PHS_Price__c).format())  + '</td>';
                                    else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                    if (pHSChangeItem.Phoenix_Change_in_Price__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + String.valueOf((pHSChangeItem.Phoenix_Change_in_Price__c).format()) +'%'+ '</td>';
                                    else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                    if (pHSChangeItem.Phoenix_Last_90_days_PHS_Units__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding:8px;">' + String.valueOf((pHSChangeItem.Phoenix_Last_90_days_PHS_Units__c).format()) + '</td>';
                                    else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                    if (pHSChangeItem.Phoenix_Sales_Difference__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' +'$'+ String.valueOf((pHSChangeItem.Phoenix_Sales_Difference__c).format()) + '</td>';
                                    else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                }
                                if (rejectionApprover != null) tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + rejectionApprover + '</td>';
                                else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                if (pHSChangeItem.Phoenix_Finance_Approval_Remarks__c != null) tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + pHSChangeItem.Phoenix_Finance_Approval_Remarks__c + '</td>';
                                else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                tableData += '</tr>';
                                if (pHSChangeItem.Phoenix_PHS_Price_Change__r.Owner.Email != Null) {
                                    allPeopleInvolvedEmailsSet.add(pHSChangeItem.Phoenix_PHS_Price_Change__r.Owner.Email);
                                }
                                
                            }
                            tableData += '</tbody></table>';
                            if (pHSChangeIdEmailMap.get(pHSChangeId) != null) toaddressset.AddAll(pHSChangeIdEmailMap.get(pHSChangeId));
                            toaddressset.addAll(allPeopleInvolvedEmailsSet);
                            if (Label.Phoenix_Contracts_DL != null) ccaddressSet.addAll(Label.Phoenix_Contracts_DL.split(','));
                            for (string emailId: toaddressset) {
                                if (ccaddressSet.contains(emailId))
                                    ccaddressSet.remove(emailId);
                            }
                            If(ccaddressSet != null && ccaddressSet.contains('mkalawadia@drreddys.com'))ccaddressSet.remove('mkalawadia@drreddys.com');
                            If(toaddressset != null && toaddressset.contains('mkalawadia@drreddys.com'))toaddressset.remove('mkalawadia@drreddys.com');
                            
                        }
                        
                        
                        List < Phoenix_PHS_Price_Change_Line__c > updatedItems = new List < Phoenix_PHS_Price_Change_Line__c > ();
                        for (Phoenix_PHS_Price_Change_Line__c item: pHSLineItemMap.values()) {
                            item.Phoenix_Is_Rejection_Noti_All_Sent__c = true;
                            updatedItems.add(item);
                            
                        }
                        
                        update updatedItems;
                        //content = '<div style="color: black; margin: 20px 0px -10px 0px;padding:20px 40px 10px 40px;background-color: white;">Dear Team,<br /><br />';
                        if (rectype == 'Provisional PHS Price Change') {
                            //content += 'We are informing you that the PHS Price Change approval request for the below mentioned items has been rejected by '+rejectionApprover+'. To view further details and the reason for rejection, please refer to the tables below.<br/><br/>';
                            content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">We are informing you that the PHS Price Change approval request for the below mentioned items has been rejected by '+rejectionApprover+'. To view further details and the reason for rejection, please refer to the tables below.</td></tr></table>';
                            
                        }else{
                            //content += 'We are informing you that the PHS Price Change '+phsPriceChangeName+' has been rejected by '+rejectionApprover+'. To view further details of the rejected PHS Price Change line items, please refer to the table below.<br/><br/>';
                            content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">We are informing you that the PHS Price Change '+phsPriceChangeName+' has been rejected by '+rejectionApprover+'. To view further details of the rejected PHS Price Change line items, please refer to the table below.</td></tr></table>';
                            
                        }
                        //content += '<b>PHS Price Change Details:</b></br></br>';
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 2px 8px 8px 8px;"><b>PHS Price Change Details:</b></td></tr></table>';
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr>';
                        content += '<td>';
                        content  += '<table style="border-collapse: collapse;padding-left:26px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">PHS Price Change Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+phsId+'">'+phsPriceChangeName+'</a></th></tr>';
                        content += '<tr><th style="width: 26px;"><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">PHS Price Change Name</th><td style="border: 1px solid black;padding: 8px;">'+phsPriceName+'</td></tr>';
                        content += '<tr><th style="width: 26px;"><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">PHS Price Change Type</th><td style="border: 1px solid black;padding: 8px;">'+pHSPriceChangeType+'</td></tr>';
                        content += '<tr><th style="width: 26px;"><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Description</th><td style="border: 1px solid black;padding: 8px;">'+Description+'</td></tr>';
                        
                        content += '</thead></table>';
                        content += '</td></tr></table>';
                        content += tableData;
                        //  content += 'To review the rejected item(s), refer to this link <b><a href="'+System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+phsId+'">'+phsPriceChangeName+'</a></b>.<br/><br/>'; 
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To review the rejected item(s), refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+phsId+'">'+phsPriceChangeName+'</a></b>.</td></tr></table>';
                        
                        if (rectype == 'Provisional PHS Price Change') {
                            title = '<span style="font-weight:200">Finance Rejection of PHS Price Change</span>';  
                        }else{
                            title = '<span style="font-weight:200">Sr VP of Finance Rejection of PHS Price Change</span>'; 
                        }
                        subject = 'Finance Rejection of '+pHSPriceChangeType+' PHS Price Change - '+phsPriceChangeName;
                        
                        Boolean isFooterTextAlterRequired = false;
                        AllEmailNotificationsSenderCls.sendEmailAlert(phsId, content, new List<String>(toaddressset), new List < String > (ccaddressSet), subject, title, isFooterTextAlterRequired);
                    }
                    Catch(Exception e) {
                        String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
                        System.debug('msg in phs price change rejection==>'+msg);
                    }
                    
                }
                else if (objName == 'Phoenix_NewProduct_WAC_Pricing_LineItems__c') {
                    try{
                        System.debug('in new wac');
                        //removed  AND Phoenix_Is_Rejection_Noti_All_Sent__c = false
                        String initiator = '';
                        String summaryText,heaofmrktComments,mktLead,newWacPricingName,prdFamily,prodType,approvalStatus,newWacPricingId,summary,creatBy_Name;
                        Decimal netSales,tptPerc,gmPerc;
                        User creatByName = new User();
                        New_Product_WAC_Pricing__c newWac = [SELECT  Ownerid,owner.Name,Name,Phoenix_Head_of_Marketing_Comments__c,Phoenix_Marketing_Lead__r.Name,	Phoenix_Summary__c, Owner.Email,CreatedBy.Name,Phoenix_TPT__c,Phoenix_GM__c,	Phoenix_Product_Family__c,Phoenix_Product_Type__c,Phoenix_Net_sales_annualized__c, Phoenix_Approval_Status__c from New_Product_WAC_Pricing__c where id=:Bid_ID];
                        newWacPricingId =newWac.Id; 
                        newWacPricingName = newWac.Name;
                        prdFamily = newWac.Phoenix_Product_Family__c != null ? newWac.Phoenix_Product_Family__c : '';// newWac.Product_Family__r.Name != null ? newWac.Product_Family__r.Name : '';
                        mktLead = newWac.Phoenix_Marketing_Lead__r.Name != null ? newWac.Phoenix_Marketing_Lead__r.Name : '';
                        //netSales = newWac.Phoenix_Net_sales_annualized__c;
                       // tptPerc = newWac.Phoenix_TPT__c;
                       // gmPerc = newWac.Phoenix_GM__c;
                        heaofmrktComments = newWac.Phoenix_Head_of_Marketing_Comments__c != null ? newWac.Phoenix_Head_of_Marketing_Comments__c : '';
                        initiator = newWac.owner.Name; 
                        summaryText = newWac.Phoenix_Summary__c != null ? newWac.Phoenix_Summary__c : '';
                        newWACLineItemsMap = new Map < Id, Phoenix_NewProduct_WAC_Pricing_LineItems__c > ([SELECT Id, Phoenix_New_Product_WAC_Pricing__r.Owner.Email,
                                                                                                           
                                                                                                           Phoenix_New_Product_WAC_Pricing__r.Phoenix_Approval_Status__c, Phoenix_New_Product_WAC_Pricing__r.Owner.Name,
                                                                                                           Phoenix_New_Product_WAC_Pricing__r.Name,Phoenix_New_Product_WAC_Pricing__r.Phoenix_Product_Family__c,Phoenix_New_Product_WAC_Pricing__r.Phoenix_Marketing_Lead__r.Name,Phoenix_New_Product_WAC_Pricing__r.Phoenix_Net_sales_annualized__c,
                                                                                                           Phoenix_New_Product_WAC_Pricing__r.Phoenix_TPT__c,Phoenix_New_Product_WAC_Pricing__r.Phoenix_GM__c,	Phoenix_Marketing_Head_Comments__c,	Phoenix_New_Product_WAC_Pricing__r.Phoenix_Head_of_Marketing_Comments__c,
                                                                                                           Name,Phoenix_Material_Number__c, Phoenix_NDC_11__c, Phoenix_Product__r.Name, Phoenix_Pkg_Size__c, Phoenix_WAC__c,Phoenix_Brand_WAC__c, Phoenix_Lowest_Price__c, Phoenix_TPT_GM__c
                                                                                                           FROM Phoenix_NewProduct_WAC_Pricing_LineItems__c
                                                                                                           
                                                                                                           WHERE Id in: bidLineItemIds AND Phoenix_Final_Status__c = 'Not Approved'
                                                                                                           
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
                        List<Phoenix_Bid_Process_Steps__c> bidProcessSteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
                                                                              Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_New_Product_WAC_Pricing__c =: Bid_ID];
                        System.debug('bidProcessSteps==>'+bidProcessSteps);
                        List<String> approvers = new List<String>();
                        String stepName;
                        for (Phoenix_Bid_Process_Steps__c step: bidProcessSteps) {
                            if(step.Phoenix_Status__c == 'Completed'){
                                approvers.add(step.Phoenix_Approver__r.Name);
                            }
                            if(step.Phoenix_Status__c == 'In Process'){
                                stepName = step.Phoenix_Process_Step__r.Name;
                            }
                        }
                        if(approvers != null){
                            rejectionApprover = approvers[0];
                        }
                        string tableData = '';
                        // tableData += '<b>Rejection Details:</b><br/><br/>';
                        tableData += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>Rejection Details:</b></td></tr></table>';
                        
                        //tableData += '<table style="border-collapse: collapse;padding:4px"><thead><tr><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left">S. No</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;text-align:right;">Material Number</th><th style="border: 1px solid black;padding:4px;background-color: #d4bdf8;text-align:right;">NDC-11</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Product Name</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;text-align:right;">Pack Size</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;text-align:right;">WAC</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;text-align:right;">Brand WAC</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;text-align:right;">Lowest Price</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">TPT% / GM%</th></tr></thead>';
                        tableData += '<table style="border-collapse: collapse;padding:8px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;"></th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;min-width:40px;">S. No</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Material Number</th><th style="border: 1px solid black;padding:8px;background-color: #d4bdf8;text-align:left;">NDC-11</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Product Name</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Pack Size</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">WAC</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Brand WAC</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Lowest Price</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">TPT% / GM%</th></tr></thead>';
                        
                        tableData += '<tbody>';
                        System.debug('test1');
                        for (string newWACId: newWACMapWithLineItems.keySet()) {
                            integer sNo = 0;
                            for (Phoenix_NewProduct_WAC_Pricing_LineItems__c newWACItem: newWACMapWithLineItems.get(newWACId)) {
                                sNo++;
                                tableData += '<tr>';
                                tableData += '<td style="width: 26px;"></td>';
                                tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + sNo + '</td>';
                                if (newWACItem.Phoenix_Material_Number__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + newWACItem.Phoenix_Material_Number__c + '</td>';
                                else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                if (newWACItem.Phoenix_NDC_11__c != null) tableData += '<td style="border: 1px solid black;text-align:right;right: 8px;">' + newWACItem.Phoenix_NDC_11__c + '</td>';
                                else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                if (newWACItem.Phoenix_Product__r.Name != null) tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + newWACItem.Phoenix_Product__r.Name + '</td>';
                                else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                if (newWACItem.Phoenix_Pkg_Size__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + newWACItem.Phoenix_Pkg_Size__c + '</td>';
                                else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                if (newWACItem.Phoenix_WAC__c != null){
                                   String wac = AllEmailNotificationsSenderCls.getCurrencyFormatted((newWACItem.Phoenix_WAC__c).setScale(2));
                                    tableData += '<td style="border: 1px solid black;text-align;right; padding:8px;">' + wac + '</td>';
                                }
                                else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                if (newWACItem.Phoenix_Brand_WAC__c != null){
                                   String brandWac = AllEmailNotificationsSenderCls.getCurrencyFormatted((newWACItem.Phoenix_Brand_WAC__c).setScale(2));
                                    tableData += '<td style="border: 1px solid black;text-align:right;padding:8px;">' + brandWac + '</td>';
                                }
                                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                                if (newWACItem.Phoenix_Lowest_Price__c != null) {
                                   String lowestPrice = AllEmailNotificationsSenderCls.getCurrencyFormatted((newWACItem.Phoenix_Lowest_Price__c).setScale(2));
                                    tableData += '<td style="border: 1px solid black;text-align:right;padding:8px;">' + lowestPrice + '</td>';
                                }
                                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                                if (newWACItem.Phoenix_TPT_GM__c != null){
                                   Decimal tpt_gm_perc = AllEmailNotificationsSenderCls.getPercentFormatted((newWACItem.Phoenix_Lowest_Price__c).setScale(2));
                                   tableData += '<td style="border: 1px solid black;text-align: right;padding:8px;">' +tpt_gm_perc+'%'  + '</td>';
                                }
                                else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                                tableData += '</tr>';
                                
                            }
                            
                        }
                         System.debug('test2');
                        tableData += '</tbody></table>';
                        // String content = '<div style="color: black; margin: 20px 0px -10px 0px;padding:20px 40px 10px 40px;background-color: white;">Dear Team,<br /><br />';
                        // content += 'We are informing you that the New Product WAC Pricing '+newWacPricingName+' has been rejected by the '+rejectionApprover+'. To view further details of the New Product WAC Pricing, please refer to the table below.<br/><br/>';
                        String content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">We are informing you that the New Product WAC Pricing '+newWacPricingName+' has been rejected by the '+rejectionApprover+'. To view further details of the New Product WAC Pricing, please refer to the table below. </td></tr></table>';
                        
                        //content += '<b>New Product WAC Pricing Details:</b></br></br>';
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px;"><b>New Product WAC Pricing Details:</b></td></tr></table>';
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr>';
                        content += '<td>';
                        content  += '<table style="border-collapse: collapse;padding-left:26px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Name</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+newWacPricingId+'">'+newWacPricingName+'</a></th></tr>';
                        content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Product Family</th><td style="border: 1px solid black;padding: 8px;">'+prdFamily+'</td></tr>';
                        content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Marketing Lead</th><td style="border: 1px solid black;padding: 8px;">'+mktLead+'</td></tr>';
                        //content += '<tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Approval Status</th><td style="border: 1px solid black;padding: 8px;">'+mktLead+'</td></tr>';
                        content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Reason for Rejection</th><td style="border: 1px solid black;padding: 8px;">'+heaofmrktComments+'</td></tr>';
                       
                        String net_Sales ; Decimal tpt_Perc;Decimal gm_Perc;
                        if(newWac.Phoenix_Net_sales_annualized__c != null) net_Sales  = AllEmailNotificationsSenderCls.getCurrencyFormatted((newWac.Phoenix_Net_sales_annualized__c).setScale(0));
                        else net_Sales = '';
                        if(newWac.Phoenix_TPT__c != null)  tpt_Perc = AllEmailNotificationsSenderCls.getPercentFormatted((newWac.Phoenix_TPT__c).setScale(0));
						else tpt_Perc = 0;
                        if(newWac.Phoenix_GM__c != null) gm_Perc = AllEmailNotificationsSenderCls.getPercentFormatted((newWac.Phoenix_GM__c).setScale(0));
						else gm_Perc = 0;
                        content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Net Sales</th><td style="border: 1px solid black;padding: 8px;">'+net_Sales+'</td></tr>';
                        content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">TPT%</th><td style="border: 1px solid black;padding: 8px;">'+tpt_Perc+'%'+'</td></tr>';
                        content += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">GM%</th><td style="border: 1px solid black;padding: 8px;">'+gm_Perc+'%'+'</td></tr>';
                        content += '</thead></table>';
                        content += '</td></tr></table>';
                        //content += '<b>Summary Details:</b><br/><br/>';
                        //content += '<tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">'+initiator+': </th><td style="border: 1px solid black;padding: 8px;">'+summaryText+'</td></tr><br/><br/>';
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;"><b>Summary Details:</b></td></tr></table>';
                        
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+initiator+':</td><td style="padding: 0px 8px 0px 0px;">'+summaryText+'</td></tr></table>';
                        content += tableData;
                        //content += 'To review the rejected item(s), refer to this link <b><a href="'+System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+Bid_ID+'">'+newWacPricingName+'</a></b>.<br/><br/>'; 
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To review the rejected item(s), refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+Bid_ID+'">'+newWacPricingName+'</a></b>.</td></tr></table>';
                       
                        String title ='<span style="font-weight:200">Marketing Lead Rejection of New Product WAC Pricing '+newWacPricingName+'</span>';
                        String subject = 'Marketing Lead Rejection of New Product WAC Pricing - '+newWacPricingName;//'test subject';
                        Set < string > toEmailAddresses = new Set < string >();
                        Set < string > ccEmailIds = new Set < string >();
                         System.debug('test3');
                        List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > updatedItems = new List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > ();
                        for (Phoenix_NewProduct_WAC_Pricing_LineItems__c item: newWACLineItemsMap.values()) {
                            item.Phoenix_Is_Rejection_Noti_All_Sent__c = true;
                            updatedItems.add(item);
                            
                        }
                        System.debug('newWacPricingId==>'+newWacPricingId);
                        System.debug('content==>'+content);
                        System.debug('toEmailAddresses==>'+toEmailAddresses);
                         System.debug('ccEmailIds==>'+ccEmailIds);
                           System.debug('subject==>'+subject);
                         System.debug('title==>'+title);
                        update updatedItems;
                        Boolean isFooterTextAlterRequired = false;
                        AllEmailNotificationsSenderCls.sendEmailAlert(newWacPricingId, content, new List < String > (toEmailAddresses), new List < String > (ccEmailIds), subject, title, isFooterTextAlterRequired);
                    }
                    Catch(Exception e) {
                        String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
                        System.debug('msg in new product wac rejection==>'+msg);
                    } 
                    
                } 
                else if (objName == 'Phoenix_WAC_Change_Line_Item__c') {
                    try{
                        //removed AND Phoenix_Is_Rejection_Noti_All_Sent__c = false
                        System.debug(' in wac change rejection');
                        String wacChangeName,prodFamily,creatBy_Name,summaryText;
                        date effectiveDate;
                        DateTime endDate;
                        decimal salesIncrease,wacFinancialBenifit,medicaidRelease,workCapBenifit,phsBenifit,totalNetBenifit;
                        WACChangeLineItemsMap = new Map < Id, Phoenix_WAC_Change_Line_Item__c > ([SELECT Id, Phoenix_WAC_Change__r.Owner.Email,	Phoenix_Contracts_Approval_Remarks__c,	Phoenix_Product_Family__c,
                                                                                                  
                                                                                                  Phoenix_WAC_Change__r.Phoenix_Approval_Status__c, Phoenix_WAC_Change__r.Owner.Name,
                                                                                                  Phoenix_WAC_Change__r.Name, Name,Phoenix_Head_of_PM_Comments__c,
                                                                                                  Phoenix_WAC_Change__r.Phoenix_Product_Family__c,Phoenix_WAC_Change__r.Phoenix_Effective_Date__c,Phoenix_WAC_Change__r.Phoenix_Summary__c,
                                                                                                  Phoenix_WAC_Change__r.Phoenix_Sales_Increase__c,Phoenix_WAC_Change__r.Phoenix_WAC_finance_impact__c,Phoenix_WAC_Change__r.Phoenix_Medicaid_release__c,
                                                                                                  Phoenix_WAC_Change__r.Working_capital_benefit__c,Phoenix_WAC_Change__r.Phoenix_PHS_hit__c,Phoenix_WAC_Change__r.Phoenix_Total_Net_Benefit_Impact__c,
                                                                                                  Phoenix_WAC_Line_Item_Approval_Status__c,Phoenix_WAC_Change__r.Phoenix_Total_Net_Benefit__c,	Phoenix_Customer_Update_Remarks__c,	Phoenix_Contracts_Comments__c,Phoenix_Contracts_Approval__c,
                                                                                                  Phoenix_Matl_No__c,Phoenix_Head_of_PM_Group_Approval__c
                                                                                                  FROM Phoenix_WAC_Change_Line_Item__c
                                                                                                  WHERE Id in: bidLineItemIds AND Phoenix_Final_Status__c = 'Not Approved'
                                                                                                  
                                                                                                 ]);
                        
                        String stepName,approvalStatus;
                        List<Phoenix_WAC_Change_Line_Item__c> wacChange_LineItems =new List<Phoenix_WAC_Change_Line_Item__c>();
                        System.debug('values==>'+WACChangeLineItemsMap.values().size());
                        wacChange_LineItems.addAll(WACChangeLineItemsMap.values());
                        System.debug('wacChange_LineItems siez==>'+wacChange_LineItems.size());
                        boolean isContractsApproved = false,ismarketingHeadApproved =false;
                        if(wacChange_LineItems.size() > 0){
                            if(wacChange_LineItems[0].Phoenix_Contracts_Approval__c == 'Not processed'){
                               isContractsApproved = true; 
                            }
                            if(wacChange_LineItems[0].Phoenix_Head_of_PM_Group_Approval__c == 'Not Approved'){
                                ismarketingHeadApproved = true;
                            }	
                            stepName =  wacChange_LineItems[0].Phoenix_WAC_Line_Item_Approval_Status__c;
                        } 
                    Map<String,list<Phoenix_WAC_Change_Line_Item__c>> maplist = new map<String,list<Phoenix_WAC_Change_Line_Item__c>>();
                    for(Phoenix_WAC_Change_Line_Item__c item: wacChange_LineItems){
                        if(maplist.containskey(item.Phoenix_Matl_No__c)){
                            List<Phoenix_WAC_Change_Line_Item__c> templist = maplist.get(item.Phoenix_Matl_No__c);
                            tempList.add(item);
                            maplist.put(item.Phoenix_Matl_No__c,tempList);
                        } else{
                            maplist.put(item.Phoenix_Matl_No__c,new List<Phoenix_WAC_Change_Line_Item__c> {item}); 
                        }
                    }

                        for (Phoenix_WAC_Change_Line_Item__c WACChangeItem: WACChangeLineItemsMap.values()) {
                            String WACChangeId = WACChangeItem.Phoenix_WAC_Change__c;
                            wacChangeName = WACChangeItem.Phoenix_WAC_Change__r.Name != null ? WACChangeItem.Phoenix_WAC_Change__r.Name : '';
                            prodFamily = WACChangeItem.Phoenix_WAC_Change__r.Phoenix_Product_Family__c != null ? WACChangeItem.Phoenix_WAC_Change__r.Phoenix_Product_Family__c : '';
                            if(WACChangeItem.Phoenix_WAC_Change__r.Phoenix_Effective_Date__c != null){
                                effectiveDate =  WACChangeItem.Phoenix_WAC_Change__r.Phoenix_Effective_Date__c;
                            }
                            if(WACChangeItem.Phoenix_WAC_Change__r.Phoenix_Effective_Date__c != null){
                                endDate = DateTime.newInstance(WACChangeItem.Phoenix_WAC_Change__r.Phoenix_Effective_Date__c, Time.newInstance(0, 0, 0, 0));
                            }
                            summaryText = WACChangeItem.Phoenix_WAC_Change__r.Phoenix_Summary__c != null ? WACChangeItem.Phoenix_WAC_Change__r.Phoenix_Summary__c : '';
                            salesIncrease = WACChangeItem.Phoenix_WAC_Change__r.Phoenix_Sales_Increase__c != null ? WACChangeItem.Phoenix_WAC_Change__r.Phoenix_Sales_Increase__c : 0;
                            wacFinancialBenifit = WACChangeItem.Phoenix_WAC_Change__r.Phoenix_WAC_finance_impact__c != null ? WACChangeItem.Phoenix_WAC_Change__r.Phoenix_WAC_finance_impact__c : 0;
                            medicaidRelease = WACChangeItem.Phoenix_WAC_Change__r.Phoenix_Medicaid_release__c != null ?WACChangeItem.Phoenix_WAC_Change__r.Phoenix_Medicaid_release__c : 0;
                            workCapBenifit = WACChangeItem.Phoenix_WAC_Change__r.Working_capital_benefit__c != null ? WACChangeItem.Phoenix_WAC_Change__r.Working_capital_benefit__c : 0;
                            phsBenifit = WACChangeItem.Phoenix_WAC_Change__r.Phoenix_PHS_hit__c != null ? WACChangeItem.Phoenix_WAC_Change__r.Phoenix_PHS_hit__c : 0;
                            totalNetBenifit = WACChangeItem.Phoenix_WAC_Change__r.Phoenix_Total_Net_Benefit__c != null ? WACChangeItem.Phoenix_WAC_Change__r.Phoenix_Total_Net_Benefit__c : 0;
                            approvalStatus = WACChangeItem.Phoenix_WAC_Change__r.Phoenix_Approval_Status__c != null ? WACChangeItem.Phoenix_WAC_Change__r.Phoenix_Approval_Status__c : '';
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
                        String approver,step_Name;
                        List<String> stepnames= new List<String>();
                        List<String> approverNames= new List<String>();
                        List<Phoenix_Bid_Process_Steps__c> bidProcessSteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
                                                                              Phoenix_Approver__r.Email,Phoenix_Process_Step__r.Name,Phoenix_Approver_Email__c, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_WAC_Change__c =: Bid_ID order by Phoenix_Approval_Sent_Time__c desc];
                        for (Phoenix_Bid_Process_Steps__c step: bidProcessSteps) {
                            if(step.Phoenix_Status__c == 'Completed'){
                                //approver = step.Phoenix_Approver__r.Name;
                                //step_Name = step.Phoenix_Process_Step__r.Name;
                                stepnames.add(step.Phoenix_Process_Step__r.Name);
                                approverNames.add(step.Phoenix_Approver__r.Name);
                            }
                        }
                        if(stepnames != null){
                            step_Name =stepnames[0];
                        }
                        if(approverNames != null){
                            approver =approverNames[0];
                        }
                        
                        string tableData = '';
                        //tableData += '<b>Rejection Details:</b><br/><br/>';
                        tableData += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>Rejection Details:</b></td></tr></table>';
                        
                        if(step_Name =='Marketing Head Approval'|| ismarketingHeadApproved){//THIS IS for marketing rejection
                            //tableData += '<table style="border-collapse: collapse;padding:4px"><thead><tr><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;min-width:40px;">S. No</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Product Family</th><th style="border: 1px solid black;padding:4px 8px;background-color: #d4bdf8;text-align:left;">Marketing User</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Reason for Rejection</th></tr></thead>';
                            tableData += '<table style="border-collapse: collapse;padding:8px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;"></th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">S. No</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Product Family</th><th style="border: 1px solid black;padding:8px;background-color: #d4bdf8;text-align:left;">Marketing User</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Reason for Rejection</th></tr></thead>';
                            
                        }
                        if( step_Name == 'Contract Team\'s Action'){//this is for contract's rejection
                            //tableData += '<table style="border-collapse: collapse;padding:4px"><thead><tr><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;min-width:40px;">S. No</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Product Family</th><th style="border: 1px solid black;padding:4px 8px;background-color: #d4bdf8;text-align:left;">Contracts User</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Reason for Rejection</th></tr></thead>';
                            tableData += '<table style="border-collapse: collapse;padding:8px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;"></th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">S. No</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Product Family</th><th style="border: 1px solid black;padding:8px;background-color: #d4bdf8;text-align:left;">Contracts User</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Reason for Rejection</th></tr></thead>';
                            
                        }
                        if( step_Name == 'Customer\'s Update' ){//this is for customer's rejection
                            // tableData += '<table style="border-collapse: collapse;padding:4px"><thead><tr><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;min-width:40px;">S. No</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Product Family</th><th style="border: 1px solid black;padding:4px 8px;background-color: #d4bdf8;text-align:left;">Customer\'s Update User</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Reason for Rejection</th></tr></thead>';
                            tableData += '<table style="border-collapse: collapse;padding:8px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;"></th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">S. No</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Product Family</th><th style="border: 1px solid black;padding:8px;background-color: #d4bdf8;text-align:left;">Customer\'s Update User</th><th style="border: 1px solid black;padding:8px; background-color: #d4bdf8;text-align:left;">Reason for Rejection</th></tr></thead>';
                            
                        }
                        tableData += '<tbody>';
                          integer sNo = 0;
                        System.debug('outer loop==>');
                        for(String forId : maplist.keySet()){
                            System.debug('inner loop==>');
                               sNo++;
                            for(Phoenix_WAC_Change_Line_Item__c WACChangeItem: maplist.get(forId)){
                            //for (Phoenix_WAC_Change_Line_Item__c WACChangeItem: WACChangeMapWithLineItems.get(WACChangeId)) {
                                tableData += '<tr>';
                                 tableData += '<td style="width: 26px;"></td>';
                                tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + sNo + '</td>';
                                if (WACChangeItem.Phoenix_Product_Family__c != null) tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + WACChangeItem.Phoenix_Product_Family__c + '</td>';
                                else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                if(step_Name =='Marketing Head Approval' || ismarketingHeadApproved){//this is for marketing rejection
                                    if (approver != null) tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + approver + '</td>';
                                    else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                    
                                    if (WACChangeItem.Phoenix_Head_of_PM_Comments__c != null) tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' +WACChangeItem.Phoenix_Head_of_PM_Comments__c + '</td>';
                                    else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                }
                               

                                if(isContractsApproved){
                               // if( step_Name == 'Contract Team\'s Action'){//this for contract's rejection
                                    if (approver != null) tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + approver + '</td>';
                                    else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                    if (WACChangeItem.Phoenix_Contracts_Comments__c != null) tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + WACChangeItem.Phoenix_Contracts_Comments__c + '</td>';
                                    else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                    
                                }
                                
                                if( step_Name == 'Customer\'s Update' ){//this is for customer's rejection
                                    if (approver != null) tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + approver + '</td>';
                                    else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                    
                                    if (WACChangeItem.Phoenix_Customer_Update_Remarks__c != null) tableData += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + WACChangeItem.Phoenix_Customer_Update_Remarks__c + '</td>';
                                    else tableData += '<td style="border: 1px solid black;text-align:center;padding: 8px;">' + '' + '</td>';
                                    
                                }
                                tableData += '</tr>';
                                break;
                            }
                            tableData += '</tbody></table>';
                            
                            
                        }
                         System.debug('after outer loop==>');
                        String content,subject,title;
                          if(isContractsApproved  || step_Name == 'Customer\'s Update'){
                        //if( step_Name == 'Contract Team\'s Action' || step_Name == 'Customer\'s Update'){
                            //content = '<div style="color: black; margin: 20px 0px -10px 0px;padding:20px 40px 10px 40px;background-color: white;">Dear Team,<br /><br />';
                            //content += 'We are informing you that the '+wacChangeName+' has been rejected by '+approver+'. To view further details, please refer to the tables below.<br/><br/>';
                            content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">We are informing you that the '+wacChangeName+' has been rejected by '+approver+'. To view further details, please refer to the tables below. </td></tr></table>';
                            
                        }
                        if(step_Name == 'Marketing Head Approval' || ismarketingHeadApproved){
                            //content = '<div style="color: black; margin: 20px 0px -10px 0px;padding:20px 40px 10px 40px;background-color: white;">Dear Team,<br /><br />';
                            //content += 'We are informing you that the '+wacChangeName+' has been rejected by '+approver+'. To view further details, please refer to the tables below.<br/><br/>';
                            content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">We are informing you that the '+wacChangeName+' has been rejected by '+approver+'. To view further details, please refer to the tables below. </td></tr></table>';
                            
                        }
                        //content += '<b>WAC Change Impact Details:</b></br></br>';
                        String sales_Increase = AllEmailNotificationsSenderCls.getCurrencyFormatted(salesIncrease);
                        String wac_Financial_Benifit = AllEmailNotificationsSenderCls.getCurrencyFormatted(wacFinancialBenifit);
                        String medicaid_Release = AllEmailNotificationsSenderCls.getCurrencyFormatted(medicaidRelease);
                        String work_Cap_Benifit = AllEmailNotificationsSenderCls.getCurrencyFormatted(workCapBenifit);
                        String phs_Benifit = AllEmailNotificationsSenderCls.getCurrencyFormatted(phsBenifit);
                        String total_Net_Benifit = AllEmailNotificationsSenderCls.getCurrencyFormatted(totalNetBenifit);
                        
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 8px;"><b>WAC Change Impact Details:</b></td></tr></table>';
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr>';
                        content += '<td>';
                        content  += '<table style="border-collapse: collapse;padding-left:26px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">WAC Change Name</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+Bid_ID+'">'+WacChangeName+'</a></th></tr>';
                        content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Product Family</th><td style="border: 1px solid black;padding: 8px;">'+prodFamily+'</td></tr><tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Effective Date</th><td style="border: 1px solid black;padding: 8px;">'+endDate.format('MMM d yyyy')+'</td></tr>';
                        content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Sales Increase</th><td style="border: 1px solid black;padding: 8px;">'+sales_Increase+'</td></tr>';
                        content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">WAC Financial Benefit</th><td style="border: 1px solid black;padding: 8px;">'+wac_Financial_Benifit+'</td></tr>';
                        content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Medicaid Release</th><td style="border: 1px solid black;padding: 8px;">'+medicaid_Release+'</td></tr>';
                        content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Working Capital Benefit</th><td style="border: 1px solid black;padding: 8px;">'+work_Cap_Benifit+'</td></tr>';
                        content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">PHS Benefit</th><td style="border: 1px solid black;padding: 8px;">'+phs_Benifit+'</td></tr>';
                        content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Total Net Benefit</th><td style="border: 1px solid black;padding: 8px;">'+total_Net_Benifit+'</td></tr>';
                        //content += '<tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+stepName+'</td></tr>';
                        
                        content += '</thead></table>';
                        content += '</td></tr></table>';
                        content += tableData;
                        //content += 'To review the rejected item(s), refer to this link <b><a href="'+System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+Bid_ID+'">'+wacChangeName+'</a></b>.<br/><br/>'; 
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To review the rejected item(s), refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+Bid_ID+'">'+wacChangeName+'</a></b>.</td></tr></table>';
                        if(isContractsApproved){
                        //if( step_Name == 'Contract Team\'s Action'){//this for contract's rejection
                            subject = 'Contracts Rejection of WAC Change - '+wacChangeName;
                        }
                        if(step_Name == 'Marketing Head Approval' || ismarketingHeadApproved){
                            subject = 'Marketing Head Rejection of WAC Change - '+wacChangeName;
                        }
                        if( step_Name == 'Customer\'s Update' ){//this is for customer's rejection
                            subject = 'Customer\'s Update Rejection of WAC Change - '+wacChangeName;
                        }
                        title ='<span style="font-weight:200">WAC Change Rejected</span>';
                        /* to address*/
                        set < string > toaddressset = new set < string > ();
                        set < string > ccaddressSet = new set < string > ();
                        for (string WACChangeId: WACChangeMapWithLineItems.keySet()) {
                            for (Phoenix_WAC_Change_Line_Item__c WACChangeItem: WACChangeMapWithLineItems.get(WACChangeId)) {
                                if (WACChangeItem.Phoenix_WAC_Change__r.Owner.Email != Null) {
                                    allPeopleInvolvedEmailsSet.add(WACChangeItem.Phoenix_WAC_Change__r.Owner.Email);
                                }
                                if (WACChageIdEmailMap.get(WACChangeId) != null) toaddressset.AddAll(WACChageIdEmailMap.get(WACChangeId));
                                toaddressset.addAll(allPeopleInvolvedEmailsSet);
                                if (Label.Phoenix_Contracts_DL != null) ccaddressSet.addAll(Label.Phoenix_Contracts_DL.split(','));
                                
                                for (string emailId: toaddressset) {
                                    if (ccaddressSet.contains(emailId))
                                        ccaddressSet.remove(emailId);
                                }
                                If(ccaddressSet != null && ccaddressSet.contains('mkalawadia@drreddys.com'))ccaddressSet.remove('mkalawadia@drreddys.com');
                                If(toaddressset != null && toaddressset.contains('mkalawadia@drreddys.com'))toaddressset.remove('mkalawadia@drreddys.com');
                                
                            }
                        }
                        
                        /*end to address*/
                        List < Phoenix_WAC_Change_Line_Item__c > updatedItems = new List < Phoenix_WAC_Change_Line_Item__c > ();
                        for (Phoenix_WAC_Change_Line_Item__c item: WACChangeLineItemsMap.values()) {
                            item.Phoenix_Is_Rejection_Noti_All_Sent__c = true;
                            updatedItems.add(item);
                            
                        }
                        
                        update updatedItems;
                        Boolean isFooterTextAlterRequired = false;
                        AllEmailNotificationsSenderCls.sendEmailAlert(Bid_ID, content, new List<String> (toaddressset), new List<String> (ccaddressSet), subject, title, isFooterTextAlterRequired);
                        
                    }
                    Catch(Exception e) {
                        String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
                        System.debug('msg in wac change rejection==>'+msg);
                    } 
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
    
    
    
   /* public static void testCoverageBlock()
    {
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;

        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;

        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
       
        



    }*/
}