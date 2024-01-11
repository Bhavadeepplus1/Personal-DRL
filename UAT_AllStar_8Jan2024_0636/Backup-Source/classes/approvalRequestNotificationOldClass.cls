public without sharing class approvalRequestNotificationOldClass  {
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
                bidItems = [Select Id, Name, Product_Family_Name__c, Phoenix_Product__r.Product_Family__r.Name, Phoenix_Product__r.Phoenix_Product_Director__c, Phoenix_Product__r.Phoenix_Marketing_Lead__c, Phoenix_Product__c, Phoenix_Product__r.Family FROM Phoenix_Bid_Line_Item__c Where Phoenix_Bid__c =: objId AND Phoenix_Final_Status__c != 'Not Approved'];
                
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
                    
                    if (itemsByDitectorMap!=null && item.Phoenix_Product__r.Phoenix_Product_Director__c != null && item.Phoenix_Product__r.Product_Family__r.Name != null && itemsByDitectorMap.containsKey(item.Phoenix_Product__r.Phoenix_Product_Director__c)) {
                        Set < String > temp = itemsByDitectorMap.get(item.Phoenix_Product__r.Phoenix_Product_Director__c);
                        temp.add(item.Phoenix_Product__r.Product_Family__r.Name);
                        itemsByDitectorMap.put(item.Phoenix_Product__r.Phoenix_Product_Director__c, temp);
                    } else if (item.Phoenix_Product__r.Phoenix_Product_Director__c != null && item.Phoenix_Product__r.Product_Family__r.Name != null && !itemsByDitectorMap.containsKey(item.Phoenix_Product__r.Phoenix_Product_Director__c)) {
                        itemsByDitectorMap.put(item.Phoenix_Product__r.Phoenix_Product_Director__c, new Set < String > {
                            item.Phoenix_Product__r.Product_Family__r.Name
                                });
                    }
                    
                    if (item.Phoenix_Product__r.Phoenix_Marketing_Lead__c != null && item.Phoenix_Product__r.Product_Family__r.Name != null && itemsByLeadMap.containsKey(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c)) {
                        Set < String > temp = itemsByLeadMap.get(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c);
                        temp.add(item.Phoenix_Product__r.Product_Family__r.Name);
                        itemsByLeadMap.put(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c, temp);
                    } else if (item.Phoenix_Product__r.Phoenix_Marketing_Lead__c != null && item.Phoenix_Product__r.Product_Family__r.Name != null && !itemsByLeadMap.containsKey(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c)) {
                        itemsByLeadMap.put(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c, new Set < String > {
                            item.Phoenix_Product__r.Product_Family__r.Name
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
            
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'approvalRequestNotification', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Remarks__c = 'ObjectId is '+objID, Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        
        // return mailStatus;
        
    }
	/*Public static void codeCoverageBlock(){
        integer i=1;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
          i++;
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
    }*/
}