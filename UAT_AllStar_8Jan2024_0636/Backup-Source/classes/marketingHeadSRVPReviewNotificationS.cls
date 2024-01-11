public class marketingHeadSRVPReviewNotificationS {
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
    public static void reviewNotificationsMarketingHead(Id objId, List < Phoenix_Bid_Process_Steps__c > nextSteps) {
        String priceChangedeviationTable = '';String deviationTable = '';String marketingHeadAdditionTable = '';
        Phoenix_Bid__c bid = [Select Id,CreatedDate,Phoenix_Customer_Bid_Deadline__c,Owner.Name,CreatedBy.Name,Phoenix_Customer__r.Name, Phoenix_Bid_Owner__r.Name,Phoenix_Salesperson__r.Name, Phoenix_Approval_Status__c, Phoenix_Bid_Name__c, Phoenix_Comments__c, Phoenix_is_OTC_Bid__c, Name, Owner.Email,Phoenix_Bid_Type__c, Phoenix_Bid_Deadline_Date__c, Phoenix_Sales_Person_2__c, Phoenix_Sales_Person_2__r.Email, Phoenix_Salesperson__c, Phoenix_Salesperson__r.Email, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Bid_Created_Behalf_of__r.Email, Phoenix_Internal_Target_Date__c, Phoenix_Customer_Bid_Deadline_Date_Time__c FROM Phoenix_Bid__c Where Id =: objId];
        
        list < Phoenix_Approval_Grid__c > approvalGridList = [Select Id, Phoenix_Product_Family__c, Phoenix_Is_New_Low__c, Phoenix_Annualized_TP__c, Phoenix_Annualized_TP_Impact__c,
                                                              Phoenix_Annualized_TP_Impact_Limit__c, Phoenix_TP__c, Phoenix_TP_Limit__c, Phoenix_Annualized_GM__c,
                                                              Phoenix_Annualized_GM_Impact__c, Phoenix_Annualized_GM_Impact_Limit__c, Phoenix_Revenue__c, Phoenix_Revenue_Limit__c,
                                                              Phoenix_GM__c, Phoenix_GM_Limit__c, Phoenix_Marketing_Lead_Rx__c, Phoenix_Marketing_Lead_SRx__c, Phoenix_Marketing_Lead_OTC__c,
                                                              Phoenix_Business_Head_Comments__c, Phoenix_Approval__c, Phoenix_Comments__c, Phoenix_Sr_Director_VP__c,
                                                              Phoenix_Is_SVP_Notification_Required__c,Phoenix_Is_Mkg_Head_Noti_Required__c,
                                                              Phoenix_Sr_Director_VP_Finance_Comments__c, Phoenix_Is_partner_product__c FROM Phoenix_Approval_Grid__c WHERE Phoenix_Bid__c =: objId
                                                             ];
        if (!bid.Phoenix_is_OTC_Bid__c || bid.Phoenix_is_OTC_Bid__c) {
            priceChangedeviationTable += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"> <thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;width:40px;">S No.</th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Family</th> <th rowspan="2" style="border: 1px solid black;padding:8px;width:10%;text-align:left;background-color:#d4bdf8;">Setting New Low</th>';
            priceChangedeviationTable += '<th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;width:18%;">TPT Impact</th><th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">TPT %</th><th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">GM %</th></tr>';
            priceChangedeviationTable += '<tr> <th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th>';
            priceChangedeviationTable += '<th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th>';
            priceChangedeviationTable += '<th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th></tr></thead>';
            
            deviationTable += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"> <thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;width:40px;">S No.</th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Family</th> <th rowspan="2" style="border: 1px solid black;padding:8px;width:10%;text-align:left;background-color:#d4bdf8;">Setting New Low</th>';
            deviationTable += '<th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;width:18%;">Revenue</th><th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">TPT %</th><th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">GM %</th></tr>';
            deviationTable += '<tr> <th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th>';
            deviationTable += '<th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th>';
            deviationTable += '<th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th></tr></thead>';
            
        }
        priceChangedeviationTable +=  '<tbody>';
        deviationTable += '<tbody>';
        Integer  sNo = 0;
        marketingHeadAdditionTable += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"> <thead style="background-color:#d4bdf8"> <tr> <th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;min-width: 40px;">S No.</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Family</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Setting New Low</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized TP</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized TP Impact</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized TP Impact Limit</th>';
        marketingHeadAdditionTable += '<th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized GM</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized GM Impact</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized GM Impact Limit</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Marketing Lead Rx</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Marketing Lead SRx</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Marketing Lead OTC</th>';
        marketingHeadAdditionTable += '</tr></thead><tbody>';
        
        for (Phoenix_Approval_Grid__c grid: approvalGridList) {
            String revenue = AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Revenue__c).setScale(0));
            String tptImpact = AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_TP_Impact__c).setScale(0));
            String gmImpact = AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_GM_Impact__c).setScale(0));
            
            Decimal gmPerc = grid.Phoenix_GM__c != null ? grid.Phoenix_GM__c.setScale(0, RoundingMode.HALF_UP)  : 0;
            Decimal tptPerc = grid.Phoenix_TP__c != null ? grid.Phoenix_TP__c.setScale(0, RoundingMode.HALF_UP)  : 0;
            sNo++;
            marketingHeadAdditionTable += '<tr><td style="width: 26px;"></td>';
            marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align:center;padding:8px;">' + sNo + '</td>';
            marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align:left;padding:8px;">' + grid.Phoenix_Product_Family__c + '</td>';
            
            deviationTable += '<tr><td style="width: 26px;"></td>';
            deviationTable += '<td style="border: 1px solid black;text-align:center;;padding:8px;">' + sNo + '</td>';
            deviationTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + grid.Phoenix_Product_Family__c + '</td>';
            
            priceChangedeviationTable +=  '<tr><td style="width: 26px;"></td>';
            priceChangedeviationTable += '<td style="border: 1px solid black;text-align:center;;padding:8px;">' + sNo + '</td>';
            priceChangedeviationTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + grid.Phoenix_Product_Family__c + '</td>';
            if (grid.Phoenix_Is_New_Low__c == True) {
                marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align:left;background-color:Yellow;padding:8px;">' + 'Yes' + '</td>';
                deviationTable += '<td style="border: 1px solid black;text-align:left;;background-color:Yellow;padding:8px;">' + 'Yes' + '</td>';
                if(revenue != null)	deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' +revenue + '</td>';
                else deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' +revenue + '</td>';
                
                deviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 40%' + '</td>';
                if(tptPerc != null)	deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' + tptPerc+'%' + '</td>';
                else deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + tptPerc+'%' + '</td>';
                
                deviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 25%' + '</td>';
                if(gmPerc != null)	deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' + gmPerc +'%' +'</td>';
                else deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + gmPerc +'%' +'</td>';
                
                priceChangedeviationTable += '<td style="border: 1px solid black;text-align:left;;background-color:Yellow;padding:8px;">' + 'Yes' + '</td>';
                priceChangedeviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + '$1 Mn < x'  + '</td>';
                
                if(tptImpact != null)	priceChangedeviationTable +='<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' +tptImpact + '</td>';
                else priceChangedeviationTable +='<td style="border: 1px solid black;text-align:right;padding: 8px;">' +tptImpact + '</td>';
                
                priceChangedeviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 40%' + '</td>';
                if(tptPerc != null)	priceChangedeviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' + tptPerc+'%' + '</td>';
                else priceChangedeviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + tptPerc+'%' + '</td>';
                
                priceChangedeviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 25%' + '</td>';
                if(gmPerc != null)	priceChangedeviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' + gmPerc +'%' +'</td>';
                else	priceChangedeviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + gmPerc +'%' +'</td>';
                
            }
            else if (grid.Phoenix_Is_New_Low__c == False) {
                marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align:left;padding:8px;">' + 'No' + '</td>';
                deviationTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + 'No' + '</td>';
                deviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + '2Mn < x' + '</td>';
                if(revenue != null)	deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' +revenue + '</td>';
                else	deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' +revenue + '</td>';
                
                deviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 40%' + '</td>';
                if(tptPerc != null)	deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' + tptPerc+'%' + '</td>';
                else deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + tptPerc+'%' + '</td>';
                
                deviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 25%' + '</td>';
                if(gmPerc != null)	deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' + gmPerc +'%' +'</td>';
                else deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + gmPerc +'%' +'</td>';
                priceChangedeviationTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + 'No' + '</td>';
                priceChangedeviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + '$1 Mn < x'  + '</td>';
                if(tptImpact != null)	priceChangedeviationTable +='<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' +tptImpact + '</td>';
                else priceChangedeviationTable +='<td style="border: 1px solid black;text-align:right;padding: 8px;">' +tptImpact + '</td>';
                
                priceChangedeviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 40%' + '</td>';
                if(tptPerc != null)	priceChangedeviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' + tptPerc+'%' + '</td>';
                else priceChangedeviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + tptPerc+'%' + '</td>';
                
                priceChangedeviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 25%' + '</td>';
                if(gmPerc != null)	priceChangedeviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' + gmPerc +'%' +'</td>';
                else	priceChangedeviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + gmPerc +'%' +'</td>';	
                
            }
            else {
                marketingHeadAdditionTable += '<td style="border: 1px solid black;padding: 8px;text-align:center;">' + '' + '</td>';
                deviationTable += '<td style="border: 1px solid black;padding: 8px;text-align:center;">' + '' + '</td>';
                deviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + '2Mn < x' + '</td>';
                deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' +'' + '</td>';
                deviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 40%' + '</td>';
                deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + '' + '</td>';
                deviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 25%' + '</td>';
                deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' +  '' +'</td>';
                
                priceChangedeviationTable += '<td style="border: 1px solid black;padding: 8px;text-align:center;">' + '' + '</td>';
                
            }
            if (grid.Phoenix_Is_partner_product__c == false) {
                if (grid.Phoenix_Annualized_TP__c != Null) {
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align:right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_TP__c).setScale(0))+ '</td>';
                }else{
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                }
                if (grid.Phoenix_Annualized_TP_Impact__c != Null) {
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align:right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_TP_Impact__c).setScale(0))+ '</td>';
                    
                }else{
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                }
                if (grid.Phoenix_Annualized_TP_Impact_Limit__c != Null) {
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;padding:8px">' + grid.Phoenix_Annualized_TP_Impact_Limit__c + '</td>';
                    
                }else{
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                }
            }else{
                marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td>';
                
            }
            if (grid.Phoenix_Is_partner_product__c == True) {
                if (grid.Phoenix_Annualized_GM__c != Null) {
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align: right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_GM__c).setScale(0))+ '</td>';
                    
                }else{
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                    
                }
                if (grid.Phoenix_Annualized_GM_Impact__c != Null) {
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align: right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_GM_Impact__c).setScale(0))+ '</td>';
                    
                }else{
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                    
                }
                if (grid.Phoenix_Annualized_GM_Impact_Limit__c != Null) {
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;padding:8px">' + grid.Phoenix_Annualized_GM_Impact_Limit__c + '</td>';
                    
                }else{
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                    
                }
            }else{
                marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td>';
                
            }
            if (!bid.Phoenix_is_OTC_Bid__c || bid.Phoenix_is_OTC_Bid__c) {
                if (grid.Phoenix_Marketing_Lead_Rx__c != Null) {
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align:left;padding:8px">' + grid.Phoenix_Marketing_Lead_Rx__c + '</td>';
                    
                }else{
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                    
                }
                if (grid.Phoenix_Marketing_Lead_SRx__c != Null) {
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Marketing_Lead_SRx__c + '</td>';
                    
                }else{
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                    
                }
                if (grid.Phoenix_Marketing_Lead_OTC__c != Null) {
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align:left;padding:8px">' + grid.Phoenix_Marketing_Lead_OTC__c + '</td>';
                    
                }else{
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                    
                }
            }
            marketingHeadAdditionTable += '</tr>';
            priceChangedeviationTable += '</tr>';
            deviationTable += '</tr>';
            
            
        }
        priceChangedeviationTable += '</tbody></table>';
        marketingHeadAdditionTable += '</tbody></table>';
        deviationTable += '</tbody></table>';
        /*added by satya*/
        String stepName,step_name,approverName;
        
        List<Phoenix_Bid_Process_Steps__c> bidProcessSteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
                                                              Phoenix_Approver__r.Email,Phoenix_Process_Step__r.Name,Phoenix_Approver_Email__c, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c =: objId ];
        List<String> parallelSteps = new List<String>();
        for (Phoenix_Bid_Process_Steps__c step: bidProcessSteps) {
            if(step.Phoenix_Status__c == 'In Process'){
                stepname = step.Phoenix_Process_Step__r.Name;
                step_name = step.Phoenix_Process_Step__r.Name;
                parallelSteps.add(stepname);
                approverName = step.Phoenix_Approver__r.Name;
            }
        }
        
        boolean isSVPNotificationRequired,isMkngHeadNotificationRequired ;
        for(Phoenix_Approval_Grid__c rec: approvalGridList){
            if(stepname == 'Finance Approval' && rec.Phoenix_Is_Mkg_Head_Noti_Required__c == true){
                isMkngHeadNotificationRequired = true;
            }
            if(stepname == 'Contract Team\'s Action' && rec.Phoenix_Is_SVP_Notification_Required__c == true){
                isSVPNotificationRequired = true;
            }
            
        }
        /*end by satya*/ 
        
        
        User creatByName = new User();
        String creatBy_Name;
        String bidNumber = bid.Name;
        String bidName = bid.Phoenix_Bid_Name__c != null ? bid.Phoenix_Bid_Name__c : '';
        String bidType = bid.Phoenix_Bid_Type__c != null ? bid.Phoenix_Bid_Type__c : '';
        String custName = bid.Phoenix_Customer__r.Name != null ? bid.Phoenix_Customer__r.Name : '';
        creatByName = bid.CreatedBy;
        creatBy_Name = creatByName.Name;
        String salesPerson = bid.Phoenix_Salesperson__r.Name != null ? bid.Phoenix_Salesperson__r.Name : '';
        String currentStage = bid.Phoenix_Approval_Status__c != null ? bid.Phoenix_Approval_Status__c : '';
        Date internalDeadline ;Date customerDeadline;
        if(bid.Phoenix_Internal_Target_Date__c != null){
            internalDeadline = bid.Phoenix_Internal_Target_Date__c;
        }
        if(bid.Phoenix_Bid_Deadline_Date__c != null){
            customerDeadline = bid.Phoenix_Bid_Deadline_Date__c;
        }
        String summaryText = '';
        if(bid.Phoenix_Comments__c != null && bid.Phoenix_Comments__c != '') {
            summaryText = bid.Phoenix_Comments__c.replaceAll('<p>', '').replaceAll('</p>', '');
        }
        String content = '';String title = '';String subject = ''; 
        String approvalStatus =   bid.Phoenix_Approval_Status__c;
        Integer countOfProducts = 0;
        string tableData = '';
        DateTime internalTarget;
        DateTime custDeadline;
        DateTime createdDate;
        if (bid.Phoenix_Internal_Target_Date__c != null) 
            internalTarget = DateTime.newInstance(bid.Phoenix_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0));
        if (bid.Phoenix_Bid_Deadline_Date__c != null) 
            custDeadline = DateTime.newInstance(bid.Phoenix_Bid_Deadline_Date__c, Time.newInstance(0, 0, 0, 0));
        if (bid.CreatedDate != null) 
            createdDate = DateTime.newInstance(date.newinstance(bid.CreatedDate.year(), bid.CreatedDate.month(), bid.CreatedDate.day()), Time.newInstance(0, 0, 0, 0));
        
        if(isMkngHeadNotificationRequired == true && (stepname != 'Marketing Lead Rx Approval' && stepname != 'Marketing Lead SRx Approval'&& stepname != 'Marketing Lead OTC Approval' && stepname != 'Marketing Approval') && (step_name == 'Marketing Head' ||step_name == ' Marketing Head Approval' || step_name == 'Finance Approval')){
            
            List<String> newAddress = new List<String>();
            List<String> CCAddress = new List<String>();
            String mktHeadName = '';
            list < Phoenix_User_Approval_Matrix__c > mkgHeadMatrixList = [Select Id, Phoenix_Approver__c, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Is_Approval_Process_User__c, Phoenix_Approver__r.Email,Phoenix_Approver__r.Name
                                                                          From Phoenix_User_Approval_Matrix__c where User_Group__r.Phoenix_Approver_Group_Name__c = 'Marketing Head'
                                                                          and Phoenix_Is_Approval_Process_User__c = true
                                                                         ];
            for (Phoenix_User_Approval_Matrix__c matrix: mkgHeadMatrixList) {
                if (matrix.Phoenix_Approver__c != null) newAddress.add(matrix.Phoenix_Approver__r.Email);
                mktHeadName = matrix.Phoenix_Approver__r.Name;
            }
            CCAddress.addAll(Label.Phoenix_Contracts_DL.split(','));
            subject = 'Review Deviation in '+bidType+' - '+bidNumber+' - '+custName;
            title = 'Management Notification (Deviation)';
            String marketingHeadTable = '';
            marketingHeadTable = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 0px 8px;">Dear '+mktHeadName+',</td></tr></table>';
            marketingHeadTable += '<table><tr><td style="width: 24px;"></td><td style="padding: 4px 8px 8px 8px;"><span style="font-size: 14px;font-family: Sans-Serif">'+creatBy_Name+' has raised '+bid.Phoenix_Bid_Type__c+' Bid as one or more of the products listed below have deviation(s). There is <b><u>No Action Required from you</u></b> but we are sending this for your information only.</span> </td></tr></table>';
            marketingHeadTable += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:0px 8px 8px 8px;"><b>Deviation(s):</b></td></tr></table>';
            if(bidType == 'Price Change' || bidType == 'Customer Rebate Change' ||bidType == 'Sales Out Rebate'){
                marketingHeadTable += priceChangedeviationTable;
            }else{
                marketingHeadTable += deviationTable;//SrVPFinanceTable;
            }
            marketingHeadTable += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;"><b>Bid Details:</b></td></tr></table>';
            marketingHeadTable  += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+objId+'">'+bidNumber+'</a></th></tr>';
            marketingHeadTable += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bidName+'</td></tr>';
            marketingHeadTable += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bidType+'</td></tr>';
            marketingHeadTable += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+custName+'</td></tr>';
            marketingHeadTable += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+creatBy_Name+'</td></tr>';
            marketingHeadTable += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Sales Person</th><td style="border: 1px solid black;padding: 8px;">'+salesPerson+'</td></tr>';
            marketingHeadTable += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+currentStage+'</td></tr>';
            marketingHeadTable += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Internal Deadline</th><td style="border: 1px solid black;padding: 8px;">'+internalTarget.format('MMM d yyyy') +'</td></tr>';
            if(customerDeadline !=null){
                marketingHeadTable += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Bid Deadline</th><td style="border: 1px solid black;padding: 8px;">'+custDeadline.format('MMM d yyyy')+'</td></tr>';
            }else{
                marketingHeadTable += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Bid Deadline</th><td style="border: 1px solid black;padding: 8px;">'+''+'</td></tr>';
                
            }
            marketingHeadTable += '</thead></table>';
            
            marketingHeadTable += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;"><b>Bid Comments:</b></td></tr></table>';
            marketingHeadTable += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+creatBy_Name+' ('+createdDate+'): ';
            if(summaryText != null)	marketingHeadTable += summaryText+'</td></tr></table>';
            else marketingHeadTable += '</td></tr></table>';
            
            
            marketingHeadTable += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>Additional Details:</b></td></tr></table>';
            marketingHeadTable += marketingHeadAdditionTable;//SrVPFinanceAdditionTable;
            marketingHeadTable += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To review the bid line items, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+objId+'">'+bidNumber+'</a></b>.</td></tr></table>';
            // marketingHeadTable += 'To review the bid line items, refer to this link <b><a href="'+System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+objId+'">'+bidNumber+'</a></b>.<br/><br/>' ;
            Boolean isFooterTextAlterRequired = true;
            
            AllEmailNotificationsSenderCls.sendEmailAlert(objId, marketingHeadTable, new List<String> (newAddress), new List<String> (CCAddress), subject, title, isFooterTextAlterRequired);
            
        }
    }
    
    public static void reviewNotificationsSrVpFinance(Id objId, List < Phoenix_Bid_Process_Steps__c > nextSteps) {
        String priceChangeSrVPFinanceTable = ''; String SrVPFinanceTable = ''; String SrVPFinanceAdditionTable = '';
        Set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
        set < String > toAddress = new set < String > ();
        Set < string > ccEmailIds = new Set < string > ();
        String approverName;
        Map < Id, User > usersMap = new Map < Id, User > ([SELECT Id, Name, Email,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegated_Approver__r.Email FROM User]);
        
        Phoenix_Bid__c bid = [Select Id,CreatedDate,Phoenix_Customer_Bid_Deadline__c,Owner.Name,CreatedBy.Name,Phoenix_Customer__r.Name, Phoenix_Bid_Owner__r.Name,Phoenix_Salesperson__r.Name, Phoenix_Approval_Status__c, Phoenix_Bid_Name__c, Phoenix_Comments__c, Phoenix_is_OTC_Bid__c, Name, Owner.Email,Phoenix_Bid_Type__c, Phoenix_Bid_Deadline_Date__c, Phoenix_Sales_Person_2__c, Phoenix_Sales_Person_2__r.Email, Phoenix_Salesperson__c, Phoenix_Salesperson__r.Email, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Bid_Created_Behalf_of__r.Email, Phoenix_Internal_Target_Date__c, Phoenix_Customer_Bid_Deadline_Date_Time__c FROM Phoenix_Bid__c Where Id =: objId];
        User creatByName = new User();
        String creatBy_Name;
        String bidNumber = bid.Name;
        String bidName = bid.Phoenix_Bid_Name__c != null ? bid.Phoenix_Bid_Name__c : '';
        String bidType = bid.Phoenix_Bid_Type__c != null ? bid.Phoenix_Bid_Type__c : '';
        String custName = bid.Phoenix_Customer__r.Name != null ? bid.Phoenix_Customer__r.Name : '';
        creatByName = bid.CreatedBy;
        creatBy_Name = creatByName.Name;
        String salesPerson = bid.Phoenix_Salesperson__r.Name != null ? bid.Phoenix_Salesperson__r.Name : '';
        String currentStage = bid.Phoenix_Approval_Status__c != null ? bid.Phoenix_Approval_Status__c : '';
        Date internalDeadline ;Date customerDeadline;
        if(bid.Phoenix_Internal_Target_Date__c != null){
            internalDeadline = bid.Phoenix_Internal_Target_Date__c;
        }
        if(bid.Phoenix_Bid_Deadline_Date__c != null){
            customerDeadline = bid.Phoenix_Bid_Deadline_Date__c;
        }
        String summaryText = '';
        if(bid.Phoenix_Comments__c != null && bid.Phoenix_Comments__c != '') {
            summaryText = bid.Phoenix_Comments__c.replaceAll('<p>', '').replaceAll('</p>', '');
        }
        String content = '';String title = '';String subject = ''; 
        String approvalStatus =   bid.Phoenix_Approval_Status__c;
        Integer countOfProducts = 0;
        string tableData = '';
        DateTime internalTarget;
        DateTime custDeadline;
        DateTime createdDate;
        if (bid.Phoenix_Internal_Target_Date__c != null) 
            internalTarget = DateTime.newInstance(bid.Phoenix_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0));
        if (bid.Phoenix_Bid_Deadline_Date__c != null) 
            custDeadline = DateTime.newInstance(bid.Phoenix_Bid_Deadline_Date__c, Time.newInstance(0, 0, 0, 0));
        if (bid.CreatedDate != null) 
            createdDate = DateTime.newInstance(date.newinstance(bid.CreatedDate.year(), bid.CreatedDate.month(), bid.CreatedDate.day()), Time.newInstance(0, 0, 0, 0));
        
        for (Phoenix_Bid_Process_Steps__c step: [SELECT Id, Name, Phoenix_Approver__c, Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Status__c, Phoenix_Approver__r.Email
                                                 FROM Phoenix_Bid_Process_Steps__c
                                                 WHERE Phoenix_Is_Criteria_Step__c = false AND Phoenix_Status__c != 'Not Applicable'
                                                 AND(Phoenix_Bid__c =: objId OR Phoenix_NDC_Change__c =: objId OR Phoenix_PHS_Price_Change__c =: objId OR Phoenix_New_Product_WAC_Pricing__c =: objId OR Phoenix_WAC_Change__c =: objId)
                                                ]) {
                                                    if (step.Phoenix_Approver__c != null) {
                                                        allPeopleInvolvedEmailsSet.add(usersMap.get(step.Phoenix_Approver__c).Email);
                                                        if(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__c!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Name!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email!=null){
                                                            allPeopleInvolvedEmailsSet.add(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email);    
                                                            
                                                        }
                                                    }
                                                }
        for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
            if (step.Phoenix_Status__c == 'In Process' && step.Phoenix_Approver__c == null && step.Phoenix_Approver_Team__c != null) { //Means team
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
                
                
            } 
            else if (step.Phoenix_Status__c == 'In Process' && step.Phoenix_Approver__c != null) { //Means individuals
                
                if(usersMap.get(step.Phoenix_Approver__c) != null){     
                    toAddress.add(usersMap.get(step.Phoenix_Approver__c).Email);
                    if(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Name!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__c!=null){
                        toAddress.add(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email);
                    }
                }
                
                if(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Name!=null){
                    approverName = usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Name;
                }
                else{
                    approverName = usersMap.get(step.Phoenix_Approver__c).Name;
                }
                
                
            }
        }
        if (Label.Phoenix_Contracts_DL != null) ccEmailIds.addAll(Label.Phoenix_Contracts_DL.split(','));
        ccEmailIds.addAll(allPeopleInvolvedEmailsSet);
        for (string emailId: toAddress) {
            if (ccEmailIds.contains(emailId))
                ccEmailIds.remove(emailId);
        }
        
        If(ccEmailIds != null && ccEmailIds.contains('mkalawadia@drreddys.com'))ccEmailIds.remove('mkalawadia@drreddys.com');
        ccEmailIds.addAll(allPeopleInvolvedEmailsSet); 
        list < Phoenix_Approval_Grid__c > approvalGridList = [Select Id, Phoenix_Product_Family__c, Phoenix_Is_New_Low__c, Phoenix_Annualized_TP__c, Phoenix_Annualized_TP_Impact__c,
                                                              Phoenix_Annualized_TP_Impact_Limit__c, Phoenix_TP__c, Phoenix_TP_Limit__c, Phoenix_Annualized_GM__c,
                                                              Phoenix_Annualized_GM_Impact__c, Phoenix_Annualized_GM_Impact_Limit__c, Phoenix_Revenue__c, Phoenix_Revenue_Limit__c,
                                                              Phoenix_GM__c, Phoenix_GM_Limit__c, Phoenix_Marketing_Lead_Rx__c, Phoenix_Marketing_Lead_SRx__c, Phoenix_Marketing_Lead_OTC__c,
                                                              Phoenix_Business_Head_Comments__c, Phoenix_Approval__c, Phoenix_Comments__c, Phoenix_Sr_Director_VP__c,
                                                              Phoenix_Is_SVP_Notification_Required__c,Phoenix_Is_Mkg_Head_Noti_Required__c,
                                                              Phoenix_Sr_Director_VP_Finance_Comments__c, Phoenix_Is_partner_product__c FROM Phoenix_Approval_Grid__c WHERE Phoenix_Bid__c =: objId
                                                             ];
        /*added by satya*/
        String step_name,stepname;
        
        List<Phoenix_Bid_Process_Steps__c> bidProcessSteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
                                                              Phoenix_Approver__r.Email,Phoenix_Process_Step__r.Name,Phoenix_Approver_Email__c, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c =: objId ];
        List<String> parallelSteps = new List<String>();
        for (Phoenix_Bid_Process_Steps__c step: bidProcessSteps) {
            if(step.Phoenix_Status__c == 'In Process'){
                stepname = step.Phoenix_Process_Step__r.Name;
                step_name = step.Phoenix_Process_Step__r.Name;
                parallelSteps.add(stepname);
                approverName = step.Phoenix_Approver__r.Name;
            }
        }
        
        boolean isSVPNotificationRequired,isMkngHeadNotificationRequired ;
        for(Phoenix_Approval_Grid__c rec: approvalGridList){
            if(stepname == 'Finance Approval' && rec.Phoenix_Is_Mkg_Head_Noti_Required__c == true){
                isMkngHeadNotificationRequired = true;
            }
            if(stepname == 'Contract Team\'s Action' && rec.Phoenix_Is_SVP_Notification_Required__c == true){
                isSVPNotificationRequired = true;
            }
            
        }
        /*end by satya*/
        String marketingHeadAdditionTable = '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"> <thead style="background-color:#d4bdf8"> <tr> <th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;min-width: 40px;">S No.</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Family</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Setting New Low</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized TP</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized TP Impact</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized TP Impact Limit</th>';
        marketingHeadAdditionTable += '<th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized GM</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized GM Impact</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized GM Impact Limit</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Marketing Lead Rx</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Marketing Lead SRx</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Marketing Lead OTC</th>';
        SrVPFinanceAdditionTable = marketingHeadAdditionTable;
        SrVPFinanceAdditionTable += '<th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Marketing Head</th>';
        SrVPFinanceAdditionTable += '</tr></thead><tbody>';
        if (!bid.Phoenix_is_OTC_Bid__c || bid.Phoenix_is_OTC_Bid__c) {
            priceChangeSrVPFinanceTable += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"> <thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;width:40px;">S No.</th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Family</th> <th rowspan="2" style="border: 1px solid black;padding:8px;width:10%;text-align:left;background-color:#d4bdf8;">Setting New Low</th>';
            priceChangeSrVPFinanceTable += '<th rowspan="2" style="border: 1px solid black;padding:8px;;text-align:left;background-color:#d4bdf8;">Marketing Lead Comments</th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Marketing Head Comments</th>';
            priceChangeSrVPFinanceTable += '<th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">GM Impact</th><th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">TPT Impact</th><th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">TPT %</th><th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">GM %</th></tr>';
            priceChangeSrVPFinanceTable += '<th style="width: 36px;background-color:white""></th><th style="border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th>';
            priceChangeSrVPFinanceTable += '</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th>';
            priceChangeSrVPFinanceTable += '<th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th>';
            priceChangeSrVPFinanceTable += '<th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th></tr></thead>';
            
            SrVPFinanceTable += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"> <thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">S No.</th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Family</th> <th rowspan="2" style="border: 1px solid black;padding:8px;width:10%;text-align:left;background-color:#d4bdf8;">Setting New Low</th>';
            SrVPFinanceTable += '<th rowspan="2" style="border: 1px solid black;padding:8px;;text-align:left;background-color:#d4bdf8;">Marketing Lead Comments</th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Marketing Head Comments</th>';
            SrVPFinanceTable += '<th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">Revenue</th><th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">TPT %</th><th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">GM %</th></tr>';
            SrVPFinanceTable += '<th style="width: 36px;background-color:white""></th><th style="border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th>';
            SrVPFinanceTable += '<th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th>';
            SrVPFinanceTable += '<th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th></tr></thead>';

        }
        priceChangeSrVPFinanceTable += '<tbody>';
        SrVPFinanceTable += '<tbody>';
        integer sNo = 0;
        for (Phoenix_Approval_Grid__c grid: approvalGridList) {
            String revenue = AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Revenue__c).setScale(0));
            String tptImpact = AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_TP_Impact__c).setScale(0));
            String gmImpact = AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_GM_Impact__c).setScale(0));
            
            Decimal gmPerc = grid.Phoenix_GM__c != null ? grid.Phoenix_GM__c.setScale(0, RoundingMode.HALF_UP)  : 0;
            Decimal tptPerc = grid.Phoenix_TP__c != null ? grid.Phoenix_TP__c.setScale(0, RoundingMode.HALF_UP)  : 0;
         
            sNo++;
            SrVPFinanceAdditionTable += '<tr><td style="width: 26px;"></td>';
            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:center;;padding:8px;">' + sNo + '</td>';
            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + grid.Phoenix_Product_Family__c + '</td>';
            
           SrVPFinanceTable += '<tr><td style="width: 26px;"></td>';
           SrVPFinanceTable += '<td style="border: 1px solid black;text-align:center;;padding:8px;">' + sNo + '</td>';
			SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + grid.Phoenix_Product_Family__c + '</td>';	

            priceChangeSrVPFinanceTable += '<tr><td style="width: 26px;"></td>';
            priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:center;;padding:8px;">' + sNo + '</td>';
            priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + grid.Phoenix_Product_Family__c + '</td>';
            
            if (grid.Phoenix_Is_New_Low__c == True) {
                SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:left;;background-color:Yellow;padding:8px;">' + 'Yes' + '</td>';
                
                SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;background-color:Yellow;padding:8px;">' + 'Yes' + '</td>';
                priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;background-color:Yellow;padding:8px;">' + 'Yes' + '</td>';
                
            }else if(grid.Phoenix_Is_New_Low__c == False){
                SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + 'No' + '</td>';
               SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + 'No' + '</td>';

                priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + 'No' + '</td>';
                
            }else{
                SrVPFinanceAdditionTable += '<td style="border: 1px solid black;padding: 8px;text-align:center;">' + '' + '</td>';
                SrVPFinanceTable += '<td style="border: 1px solid black;padding: 8px;text-align:center;">' + '' + '</td>';

                priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;padding: 8px;text-align:center;">' + '' + '</td>';
                
            }
            if (grid.Phoenix_Is_partner_product__c == false) {
                if (grid.Phoenix_Annualized_TP__c != Null) {
                    SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_TP__c).setScale(0))+ '</td>';
                    
                }else{
                    SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                    
                }
                if (grid.Phoenix_Annualized_TP_Impact__c != Null) {
                    SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_TP_Impact__c).setScale(0))+ '</td>';
                    
                }else{
                    SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                    
                }
                if (grid.Phoenix_Annualized_TP_Impact_Limit__c != Null) {
                    SrVPFinanceAdditionTable += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;;padding:8px">' + grid.Phoenix_Annualized_TP_Impact_Limit__c + '</td>';
                    
                }else{
                    SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                    
                }
            }else{
                SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td>';
                
            }
            if (grid.Phoenix_Is_partner_product__c == True) {
                if (grid.Phoenix_Annualized_GM__c != Null) {
                    SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align: right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_GM__c).setScale(0))+ '</td>';
                    
                }else{
                    SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                    
                }
                if (grid.Phoenix_Annualized_GM_Impact__c != Null) {
                    SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align: right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_GM_Impact__c).setScale(0))+ '</td>';
                    
                }else{
                    SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                    
                }
                if (grid.Phoenix_Annualized_GM_Impact_Limit__c != Null) {
                    SrVPFinanceAdditionTable += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;padding:8px">' + grid.Phoenix_Annualized_GM_Impact_Limit__c + '</td>';
                    
                }else{
                    SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                    
                }
            }else{
                SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td>';
                
            }
            if (!bid.Phoenix_is_OTC_Bid__c || bid.Phoenix_is_OTC_Bid__c) {
                if (grid.Phoenix_Marketing_Lead_Rx__c != Null) {
                    SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Marketing_Lead_Rx__c + '</td>';
                    
                }else{
                    SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                    
                }
                if (grid.Phoenix_Marketing_Lead_SRx__c != Null) {
                    SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Marketing_Lead_SRx__c + '</td>';
                    
                }else{
                    SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                    
                }
                
            }
            if (grid.Phoenix_Marketing_Lead_OTC__c != Null) {
                SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Marketing_Lead_OTC__c + '</td>';
                
            }else{
                SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                
            }
            
            if (grid.Phoenix_Business_Head_Comments__c != Null) {
               SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Business_Head_Comments__c + '</td>';

                priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Business_Head_Comments__c + '</td>';
                
            }else{
                SrVPFinanceTable += '<td style="border: 1px solid black;">' + '' + '</td>';

                priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                
            }
            if (grid.Phoenix_Comments__c != Null) {
                priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Comments__c + '</td>';
                SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Comments__c + '</td>';

                SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Comments__c + '</td>';
                
            }else{
               SrVPFinanceTable += '<td style="border: 1px solid black;">' + '' + '</td>';

                priceChangeSrVPFinanceTable +=  '<td style="border: 1px solid black;">' + '' + '</td>';
                SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                
            }
            SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + '2Mn < x' + '</td>';
            if(revenue != null) SrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red;">'+ revenue + '</td>';
            else SrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">'+ '' + '</td>';
            SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 40%' + '</td>';
            if(tptPerc != null)	SrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red;">' + tptPerc+'%'+ '</td>';
            else SrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + ''+ '</td>';
            SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 25%' + '</td>';
            if(tptPerc != null)	SrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red;">' + gmPerc + '%</td>';
            else SrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + gmPerc + '%</td>';

            priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + '$1 Mn < x' + '</td>';
            if (grid.Phoenix_Is_partner_product__c == True) {
                if(gmImpact != null) priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red;">'+ gmImpact + '</td>';
                priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + '$1 Mn < x' + '</td>';
                if(tptImpact != null) priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red;">'+ '' + '</td>';
                else priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">'+ '' + '</td>';
                
            }
            if (grid.Phoenix_Is_partner_product__c == False) {
                if(gmImpact != null) priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red;">'+ '' + '</td>';
                priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + '$1 Mn < x' + '</td>';
                if(tptImpact != null) priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red;">'+ tptImpact + '</td>';
                else priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">'+ '' + '</td>';
            }
            priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 40%' + '</td>';
            if(tptPerc != null && grid.Phoenix_Is_partner_product__c == False)	priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red;">' + tptPerc+'%'+ '</td>';
            else priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + ''+ '</td>';
            priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 25%' + '</td>';
            if(gmPerc != null && grid.Phoenix_Is_partner_product__c == True)	priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red;">' + gmPerc + '%</td>';
            else priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + ''+'</td>';
            priceChangeSrVPFinanceTable +=  '</tr>';
             SrVPFinanceTable += '</tr>';
            SrVPFinanceAdditionTable += '</tr>';
             
        }
         SrVPFinanceTable += '</tbody></table>';
        priceChangeSrVPFinanceTable += '</tbody></table>';
        SrVPFinanceAdditionTable += '</tbody></table>';
        
        String SrVpFinanceReview = '';
        SrVpFinanceReview = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 0px 8px;">Dear Finance Team,</td></tr></table>';
        SrVpFinanceReview += '<table><tr><td style="width: 24px;"></td><td style="padding: 4px 8px 8px 8px;"><span style="font-size: 14px;font-family: Sans-Serif">'+creatBy_Name+' has raised '+bid.Phoenix_Bid_Type__c+' Bid as one or more of the products listed below have deviation(s). There is <b><u>No Action Required from you</u></b> but we are sending this for your information only.</span> </td></tr></table>';
        
        SrVpFinanceReview += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:0px 8px 8px 8px;"><b>Deviation(s):</b></td></tr></table>';
        if(bidType == 'Price Change' || bidType == 'Customer Rebate Change' || bidType == 'Sales Out Rebate'){
            SrVpFinanceReview +=priceChangeSrVPFinanceTable ;
        }else{
            SrVpFinanceReview += SrVPFinanceTable;
        }
        SrVpFinanceReview += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;"><b>Bid Details:</b></td></tr></table>';
        SrVpFinanceReview += '<table style="border-collapse: collapse;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+objId+'">'+bidNumber+'</a></th></tr>';
        SrVpFinanceReview += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bidName+'</td></tr>';
        SrVpFinanceReview += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bidType+'</td></tr>';
        SrVpFinanceReview += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+custName+'</td></tr>';
        SrVpFinanceReview += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+creatBy_Name+'</td></tr>';
        SrVpFinanceReview += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Sales Person</th><td style="border: 1px solid black;padding: 8px;">'+salesPerson+'</td></tr>';
        SrVpFinanceReview += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+currentStage+'</td></tr>';
        SrVpFinanceReview += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Internal Deadline</th><td style="border: 1px solid black;padding: 8px;">'+internalTarget.format('MMM d yyyy')+'</td></tr>';
        if(customerDeadline !=null){
            SrVpFinanceReview += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Bid Deadline</th><td style="border: 1px solid black;padding: 8px;">'+custDeadline.format('MMM d yyyy')+'</td></tr>';
        }else{
            SrVpFinanceReview += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Bid Deadline</th><td style="border: 1px solid black;padding: 8px;">'+''+'</td></tr>';
            
        }					
        SrVpFinanceReview += '</thead></table>';
        
        SrVpFinanceReview += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;"><b>Bid Comments:</b></td></tr></table>';
        SrVpFinanceReview += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+creatBy_Name+' ('+createdDate+'): ';
        if(summaryText != null)	SrVpFinanceReview += summaryText+'</td></tr></table>';
        else SrVpFinanceReview += '</td></tr></table>';
        
        SrVpFinanceReview += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>Additional Details:</b></td></tr></table>';
        SrVpFinanceReview += SrVPFinanceAdditionTable;
        SrVpFinanceReview += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To review the bid line items, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+objId+'">'+bidNumber+'</a></b>.</td></tr></table>';
        title = bidType+' Bid Approval Notification (Deviation)';
        subject = 'Review Deviation in '+bidType+' - '+bidNumber+' - '+custName;
        Boolean isFooterTextAlterRequired = true;
        AllEmailNotificationsSenderCls.sendEmailAlert(objId, SrVpFinanceReview, new List<String> (toAddress), new List<String> (ccEmailIds), subject, title, isFooterTextAlterRequired);
        
    }
}