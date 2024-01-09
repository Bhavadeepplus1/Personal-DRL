public without sharing class BidRejectionEmailNotificationToAllOld  {
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
                
                
                //String bid_id;
                /* Map < Id, Phoenix_Bid_Line_Item__c > LineItemMap = new Map < Id, Phoenix_Bid_Line_Item__c >();
LineItemMap = new Map < Id, Phoenix_Bid_Line_Item__c > ([SELECT Id, Phoenix_Bid__c FROM Phoenix_Bid_Line_Item__c where Id in: bidLineItemIds AND Phoenix_Final_Status__c = 'Not Approved'
AND Phoenix_Is_Rejection_Noti_All_Sent__c = false
]);


for (Phoenix_Bid_Line_Item__c item: LineItemMap.values()) {
bid_Id = item.Phoenix_Bid__c;
}*/
                System.debug('outer for loop');
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
                                                            /*  else if (objName == 'Phoenix_NDC_Change_Line_Item__c') {
if (step.Phoenix_Approver__c != null && ndcChangeIdEmailMap.containsKey(step.Phoenix_NDC_Change__c)) {
Set < String > addedEmails = ndcChangeIdEmailMap.get(step.Phoenix_NDC_Change__c);
addedEmails.add(step.Phoenix_Approver__r.Email);
ndcChangeIdEmailMap.put(step.Phoenix_NDC_Change__c, addedEmails);
} else if (step.Phoenix_Approver__c != null && !ndcChangeIdEmailMap.containsKey(step.Phoenix_NDC_Change__c)) {
ndcChangeIdEmailMap.put(step.Phoenix_NDC_Change__c, new Set < String > {
step.Phoenix_Approver__r.Email
});
}
} */
                                                            else if (objName == 'Phoenix_PHS_Price_Change_Line__c') {
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
                                                                                Phoenix_Product__r.ProductCode, Phoenix_Product__r.Product_Family__r.Name, Phoenix_Product__r.Family, Phoenix_Product__r.Phoenix_NDC__c,
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
    /*public static void codeCoverage(){
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
        
                      
   }*/

}