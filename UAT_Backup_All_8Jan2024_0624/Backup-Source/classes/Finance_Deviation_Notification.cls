public class Finance_Deviation_Notification {
    public static void approvalRequestNotification(Id objId, List < Phoenix_Bid_Process_Steps__c > nextSteps) {
        
        System.debug('in customer update');
        String scmapprover,financeApprover;
        String stepname='';
        String approverName = '';
     	 DateTime internalDueDateTime;
         DateTime customerBidDeadline;
                DateTime createdDate;
        String bidComments = '';
       List<Phoenix_Bid_Line_Item__c>  bidItems = [Select Id, Name, Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product__r.Name,Product_Family_Name__c, Phoenix_Product__r.Product_Family__r.Name, Phoenix_Product__r.Phoenix_Product_Director__c, Phoenix_Product__r.Phoenix_Marketing_Lead__c, Phoenix_Product__c, Phoenix_Product__r.Family, Phoenix_Product__r.Phoenix_Product_Director__r.Name FROM Phoenix_Bid_Line_Item__c Where Phoenix_Bid__c =: objId AND Phoenix_Final_Status__c != 'Not Approved'];

        Phoenix_Bid__c bid = [Select Id,CreatedDate,Phoenix_Customer_Bid_Deadline__c,Owner.Name,CreatedBy.Name,Phoenix_Customer__r.Name, Phoenix_Bid_Owner__r.Name,Phoenix_Salesperson__r.Name, Phoenix_Approval_Status__c, Phoenix_Bid_Name__c, Phoenix_Comments__c, Phoenix_is_OTC_Bid__c, Name, Owner.Email,Phoenix_Bid_Type__c, Phoenix_Bid_Deadline_Date__c, Phoenix_Sales_Person_2__c, Phoenix_Sales_Person_2__r.Email, Phoenix_Salesperson__c, Phoenix_Salesperson__r.Email, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Bid_Created_Behalf_of__r.Email, Phoenix_Internal_Target_Date__c, Phoenix_Customer_Bid_Deadline_Date_Time__c FROM Phoenix_Bid__c Where Id =: objId];

        List<Phoenix_Bid_Process_Steps__c> bidProcess_Steps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
                                                               Phoenix_Approver__r.Email,Phoenix_Process_Step__r.Name,Phoenix_Approver_Email__c, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE 	Phoenix_Bid__c =: objId order by Phoenix_Approval_Sent_Time__c desc];
        for (Phoenix_Bid_Process_Steps__c st: bidProcess_Steps) {
            if(st.Phoenix_Status__c == 'Completed'){
                stepname = st.Phoenix_Process_Step__r.Name;
                if(stepname =='Supply Chain Approval'){
                    scmapprover = st.Phoenix_Approver__r.Name;
                }
                if(stepname =='Finance Approval'){
                    financeApprover = st.Phoenix_Approver__r.Name;
                }
            }
        }
        String dynamicSubject = 'Your Update Required for '+bid.Phoenix_Bid_Type__c+' - '+bid.Name+' - '+bid.Phoenix_Customer__r.Name;
        String dynamicTitle = 'Customer Response Reminder';
        String content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px;">Dear '+approverName+',</td></tr></table>';
        content1 += '<table><tr><td style="width: 24px;"></td><td style="padding: 4px 8px 8px 8px;">'+'We want to remind you that the bid is expecting an update of the customer response, please make sure to input this information in the bid.</td></tr></table>';
        String prodFamilyString = '';
        prodFamilyString += '<table style="border-collapse: collapse;width:60%;font-family: Sans-Serif;font-size: 14px;"><thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:center;background-color:#d4bdf8;">S No.</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Product</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Product Director</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Supply Chain Planner</th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;">Finance</th>';
        prodFamilyString += '<tbody>';
        integer i = 1;
        for (Phoenix_Bid_Line_Item__c lineItem: bidItems) {
            prodFamilyString += '<tr><td style="width: 26px;"></td><td style="border: 1px solid black;text-align:center;padding:4px 8px;">'+i+'</td><td style="border: 1px solid black;text-align:left;;padding:4px 8px;">'+lineItem.Phoenix_Product__r.Name+'</td><td style="border: 1px solid black;text-align:left;;padding:4px 8px;">'+lineItem.Phoenix_Product__r.Phoenix_Product_Director__r.Name+'</td><td style="border: 1px solid black;text-align:left;;padding:4px 8px;">'+scmapprover+'</td><td style="border: 1px solid black;text-align:left;;padding:4px 8px;">'+financeApprover+'</td></tr>';
            //prodFamilyString += i + '.' + pfamily + '<br/>';
            i++;
        }
        prodFamilyString += '</tbody></table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px;"><b>Bid Details:</b></td></tr></table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';                            
        content1 += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></a></th></tr>';
        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Name__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Type__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Customer__r.Name+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+bid.Owner.Name+'</td></tr>';
        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Salesperson</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Salesperson__r.Name+'</td></tr>';
        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Approval_Status__c+'</td></tr>';
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
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;"><b>Bid Comments:</b></td></tr></table>';
        if(bid.Phoenix_Comments__c != null)	content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+bid.Owner.Name+' ('+createdDate+'):</td><td style="padding: 0px 8px 0px 0px;">'+bidComments+'</td></tr></table>';
        content1 += '</table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 8px;"><b>Product Details:</b></td></tr></table>';
        content1 += prodFamilyString;
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To review the bid line items, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></b>.</td></tr>';
        content1 += '</table>';
        
        List<String> toAddress = new List<String>();
        List<String> ccEmailIds = new List<String>();
        toAddress.add('srimayeechilagani@drreddys.com');
     AllEmailNotificationsSenderCls.sendEmailAlert(objId, content1, new List<String> (toAddress), new List<String> (ccEmailIds), dynamicSubject, dynamicTitle);   
        
    }
}