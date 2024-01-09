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

public without sharing class approvalRequestNotificationClass {
    
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
    /**
* @description This will be used to send notifications to approvers when approval is needed. 
Individual email will be sent to each person if user approval matrix defined as Single User/account based/product based and single email to all in To when user approval matrix defined as Team. 
* @author Surender Patel (Dhruvsoft) | 12-05-2021 
* @param String bidId 
* @param List<Phoenix_Bid_Process_Steps__c> nextSteps 
**/
    public static void approvalRequestNotification(Id objId, List < Phoenix_Bid_Process_Steps__c > nextSteps) {
        List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
        List < Messaging.SingleEmailMessage > mailsList = new List < Messaging.SingleEmailMessage > ();
        
        
        //bidtype label names added by vandana.
        Map < String, String > bidTypesmap = new Map < String, String > ();
        
        for(Schema.PicklistEntry  ple:  Phoenix_Bid__c.Phoenix_Bid_Type__c.getDescribe().getPicklistValues()){
            bidTypesmap.put(ple.getValue(),ple.getLabel());
        }
        
        //bidtype label names added end.
        
        try {
            String ndcId,content,title,subject;
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
            Messaging.SendEmailResult[] results1;
            Set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
            Phoenix_Bid__c bid;
            List < Phoenix_Bid_Line_Item__c > bidItems;
            Phoenix_NDC_Change__c ndcChange;
            Phoenix_PHS_Price_Change__c pHSChange;
            New_Product_WAC_Pricing__c newWac;
            Phoenix_WAC_Change__c WacChange;
            String Product_Families_bItems = '';  String priceChangedeviationTable = '';String deviationTable = ''; String additionTable = ''; String marketingHeadAdditionTable = ''; String priceChangeSrVPFinanceTable = ''; String SrVPFinanceTable = ''; String SrVPFinanceAdditionTable = '';
            String Approval_Information = '<b>' + 'Approval_Information : ' + '<br/><br/>' + 'To approve/reject by email:' + '</b><br/><br/>' + 'Reply to this email with only one of these words listed below:' + '<br/>' + 'To approve - APPROVE, APPROVED, YES' + '<br/>' + 'To reject - REJECT, REJECTED, NO';
            
            //  String Approval_Information ='<b>'+'Approval_Information : '+ '<br/><br/>'+'Reply to this email with one of these words in the first line of the email message: APPROVE, APPROVED, YES for approving the record and REJECT, REJECTED, NO for rejecting the record.'+'<br/><br/>'+'OR'+'</b>';
            String step_name = '';
            if (objName == 'Phoenix_Bid__c') {
                
                ndcId = objId;
                bid = [Select Id,CreatedDate,Phoenix_Customer_Bid_Deadline__c,Owner.Name,CreatedBy.Name,Phoenix_Customer__r.Name, Phoenix_Bid_Owner__r.Name,Phoenix_Salesperson__r.Name, Phoenix_Approval_Status__c, Phoenix_Bid_Name__c, Phoenix_Comments__c, Phoenix_is_OTC_Bid__c, Name, Owner.Email,Phoenix_Bid_Type__c, Phoenix_Bid_Deadline_Date__c, Phoenix_Sales_Person_2__c, Phoenix_Sales_Person_2__r.Email, Phoenix_Salesperson__c, Phoenix_Salesperson__r.Email, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Bid_Created_Behalf_of__r.Email, Phoenix_Internal_Target_Date__c, Phoenix_Customer_Bid_Deadline_Date_Time__c FROM Phoenix_Bid__c Where Id =: objId];
                bidItems = [Select Id, Name, Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product__r.Name,Product_Family_Name__c, Phoenix_Product__r.Product_Family__r.Name, Phoenix_Product__r.Phoenix_Product_Director__c, Phoenix_Product__r.Phoenix_Marketing_Lead__c, Phoenix_Product__c, Phoenix_Product__r.Family, Phoenix_Product__r.Phoenix_Product_Director__r.Name FROM Phoenix_Bid_Line_Item__c Where Phoenix_Bid__c =: objId AND Phoenix_Final_Status__c != 'Not Approved'];
                
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
                
                list < Phoenix_Approval_Grid__c > approvalGridList = [Select Id, Phoenix_Product_Family__c, Phoenix_Is_New_Low__c, Phoenix_Annualized_TP__c, Phoenix_Annualized_TP_Impact__c,
                                                                      Phoenix_Annualized_TP_Impact_Limit__c, Phoenix_TP__c, Phoenix_TP_Limit__c, Phoenix_Annualized_GM__c,
                                                                      Phoenix_Annualized_GM_Impact__c, Phoenix_Annualized_GM_Impact_Limit__c, Phoenix_Revenue__c, Phoenix_Revenue_Limit__c,
                                                                      Phoenix_GM__c, Phoenix_GM_Limit__c, Phoenix_Marketing_Lead_Rx__c, Phoenix_Marketing_Lead_SRx__c, Phoenix_Marketing_Lead_OTC__c,
                                                                      Phoenix_Business_Head_Comments__c, Phoenix_Approval__c, Phoenix_Comments__c, Phoenix_Sr_Director_VP__c,
                                                                      Phoenix_Is_SVP_Notification_Required__c,Phoenix_Is_Mkg_Head_Noti_Required__c,
                                                                      Phoenix_Sr_Director_VP_Finance_Comments__c, Phoenix_Is_partner_product__c FROM Phoenix_Approval_Grid__c WHERE Phoenix_Bid__c =: objId
                                                                     ];
                /*added by satya*/
                String stepName,approverName;
                
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
                
                if (!bid.Phoenix_is_OTC_Bid__c || bid.Phoenix_is_OTC_Bid__c) {
                    
                    Product_Families_bItems += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;text-align: center;padding:4px;">S.No</th><th style="border: 1px solid black;padding:4px;text-align: left;">Product Family</th><th style="border: 1px solid black;padding:4px;text-align: left;">Products below Lowest Price / SKU</th><th style="border: 1px solid black;padding:4px;text-align: right;">Annualized TP</th><th style="border: 1px solid black;padding:4px;text-align: right;">Annualized TP Impact</th><th style="border: 1px solid black;padding:4px;text-align: right;">Annualized TP Impact Limit</th><th style="border: 1px solid black;padding:4px;text-align: right;">TP%</th><th style="border: 1px solid black;padding:4px;text-align: right;">TP % Limit</th><th style="border: 1px solid black;padding:4px;text-align: right;">Annualized GM</th><th style="border: 1px solid black;padding:4px;text-align: right;">Annualized GM Impact</th><th style="border: 1px solid black;padding:4px;text-align: right;">Annualized GM Impact Limit</th><th style="border: 1px solid black;padding:4px;text-align: right;">Revenue</th><th style="border: 1px solid black;padding:4px;text-align: right;">Revenue Limit</th><th style="border: 1px solid black;padding:4px;text-align: right;">GM%</th><th style="border: 1px solid black; padding:4px;text-align: right;">GM% Limit</th><th style="border: 1px solid black;padding:4px;text-align: left;">Marketing Lead Rx</th><th style="border: 1px solid black;padding:4px;text-align: left;">Marketing Lead SRx</th><th style="border: 1px solid black;padding:4px;text-align: left;">Marketing Lead OTC</th><th style="border: 1px solid black;padding:4px;text-align: left;">Marketing Lead Comments</th><th style="border: 1px solid black;padding:4px;text-align: left;">Marketing Head Approval</th><th style="border: 1px solid black;padding:4px;text-align: left;">Marketing Head Comments</th><th style="border: 1px solid black;padding:4px;text-align: left;">Sr Director / VP Finance Approval</th><th style="border: 1px solid black;padding:4px;text-align: left;">Sr Director / VP Finance Comments</th></tr></thead>';
                    priceChangedeviationTable += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"> <thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">S No.</th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Family</th> <th rowspan="2" style="border: 1px solid black;padding:8px;width:10%;text-align:left;background-color:#d4bdf8;">Setting New Low</th>';
                    priceChangedeviationTable += '<th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;width:18%;">TPT Impact</th><th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">TPT %</th><th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">GM %</th></tr>';
                    priceChangedeviationTable += '<tr> <th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th>';
                    priceChangedeviationTable += '<th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th>';
                    priceChangedeviationTable += '<th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th></tr></thead>';
                    
                    deviationTable += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"> <thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">S No.</th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Family</th> <th rowspan="2" style="border: 1px solid black;padding:8px;width:10%;text-align:left;background-color:#d4bdf8;">Setting New Low</th>';
                    
                    deviationTable += '<th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;width:18%;">Revenue</th><th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">TPT %</th><th colspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">GM %</th></tr>';
                    deviationTable += '<tr> <th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th>';
                    deviationTable += '<th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th>';
                    deviationTable += '<th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Threshold</th><th style="width:80px;border: 1px solid black;padding:8px;text-align:left;background-color: #d0e2f7;">Actual</th></tr></thead>';
                    priceChangeSrVPFinanceTable += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"> <thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">S No.</th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Family</th> <th rowspan="2" style="border: 1px solid black;padding:8px;width:10%;text-align:left;background-color:#d4bdf8;">Setting New Low</th>';
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
               /* else if (bid.Phoenix_is_OTC_Bid__c) {
                    Product_Families_bItems += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;padding:4px;text-align: center;">S.No</th><th style="border: 1px solid black;padding:4px;text-align: left;">Product Family</th><th style="border: 1px solid black;padding:4px;text-align: left;">Products below Lowest Price / SKU</th><th style="border: 1px solid black;padding:4px;text-align: right;">Annualized TP</th><th style="border: 1px solid black;padding:4px;text-align: right;">Annualized TP Impact</th><th style="border: 1px solid black;padding:4px;text-align: right;">Annualized TP Impact Limit</th><th style="border: 1px solid black; padding:4px;text-align: right;">TP%</th><th style="border: 1px solid black; padding:4px;text-align: right;">TP % Limit</th><th style="border: 1px solid black; padding:4px;text-align: right;">Annualized GM</th><th style="border: 1px solid black;padding:4px;text-align: right;">Annualized GM Impact</th><th style="border: 1px solid black;padding:4px;text-align: right;">Annualized GM Impact Limit</th><th style="border: 1px solid black;padding:4px;text-align: right;">Revenue</th><th style="border: 1px solid black;padding:4px;text-align: right;">Revenue Limit</th><th style="border: 1px solid black;padding:4px;text-align: right;">GM%</th><th style="border: 1px solid black; padding:4px;text-align: right;">GM% Limit</th><th style="border: 1px solid black;padding:4px;text-align: left;">Marketing Lead OTC</th><th style="border: 1px solid black;padding:4px;text-align: left;">Marketing Lead Comments</th><th style="border: 1px solid black;padding:4px;text-align: left;">Marketing Head Approval</th><th style="border: 1px solid black;padding:4px;text-align: left;">Marketing Head Comments</th><th style="border: 1px solid black;padding:4px;text-align: left;">Sr Director / VP Finance Approval</th><th style="border: 1px solid black;padding:4px;text-align: left;">Sr Director / VP Finance Comments</th></tr></thead>';
                    deviationTable += '<table style="border-collapse: collapse;width:100%"><thead><tr><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">S No.</th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Family</th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Setting New Low</th>';
                    SrVPFinanceTable += deviationTable;
                    SrVPFinanceTable += '<th rowspan="2" style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Marketing Lead Comments</th><th rowspan="2" style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Marketing Head Comments</th>';
                    deviationTable += '<th colspan="2" style="border: 1px solid black;padding:8px;text-align:right;background-color:#d4bdf8;">Revenue</th><th colspan="2" style="border: 1px solid black;padding:8px;text-align:right;background-color:#d4bdf8;">TPT %</th><th colspan="2" style="border: 1px solid black;padding:8px;text-align:right;background-color:#d4bdf8;">GM %</th></tr>';
                    deviationTable += '<tr><th style="border: 1px solid black;padding:8px;text-align:right;background-color: #d0e2f7;">Threshold</th><th style="border: 1px solid black;padding:8px;text-align:right;background-color: #d0e2f7;">Actual</th>';
                    deviationTable += '<th style="border: 1px solid black;padding:8px;text-align:right;background-color: #d0e2f7;">Threshold</th><th style="border: 1px solid black;padding:8px;text-align:right;background-color: #d0e2f7;">Actual</th>';
                    deviationTable += '<th style="border: 1px solid black;padding:8px;text-align:right;background-color: #d0e2f7;">Threshold</th><th style="border: 1px solid black;padding:8px;text-align:right;background-color: #d0e2f7;">Actual</th></tr></thead>';
                    SrVPFinanceTable += '<th colspan="2" style="border: 1px solid black;padding:8px;text-align:right;background-color:#d4bdf8;">Revenue</th><th colspan="2" style="border: 1px solid black;padding:8px;text-align:right;background-color:#d4bdf8;">TPT %</th><th colspan="2" style="border: 1px solid black;padding:8px;text-align:right;background-color:#d4bdf8;">GM %</th></tr>';
                    SrVPFinanceTable += '<tr><th style="border: 1px solid black;padding:8px;text-align:right;background-color: #d0e2f7;">Threshold</th><th style="border: 1px solid black;padding:8px;text-align:right;background-color: #d0e2f7;">Actual</th>';
                    SrVPFinanceTable += '<th style="width:80px;border: 1px solid black;padding:8px;text-align:right;background-color: #d0e2f7;">Threshold</th><th style="width:80px;border: 1px solid black;padding:8px;text-align:right;background-color: #d0e2f7;">Actual</th>';
                    SrVPFinanceTable += '<th style="width:80px;border: 1px solid black;padding:8px;text-align:right;background-color: #d0e2f7;">Threshold</th><th style="width:80px;border: 1px solid black;padding:8px;text-align:right;background-color: #d0e2f7;">Actual</th></tr></thead>';
                }*/
                
                Product_Families_bItems += '<tbody>';
                priceChangedeviationTable +=  '<tbody>';
                deviationTable += '<tbody>';
                priceChangeSrVPFinanceTable += '<tbody>';
                SrVPFinanceTable += '<tbody>';
                
                additionTable += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"><thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;">S No.</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Family</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Setting New Low</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized TP</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized TP Impact</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized TP Impact Limit</th>';
                additionTable += '<th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized GM</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized GM Impact</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized GM Impact Limit</th></tr></thead><tbody>';
                
                marketingHeadAdditionTable += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"> <thead style="background-color:#d4bdf8"> <tr> <th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;min-width: 40px;">S No.</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Family</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Setting New Low</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized TP</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized TP Impact</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized TP Impact Limit</th>';
                marketingHeadAdditionTable += '<th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized GM</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized GM Impact</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Annualized GM Impact Limit</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Marketing Lead Rx</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Marketing Lead SRx</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Marketing Lead OTC</th>';
                SrVPFinanceAdditionTable = marketingHeadAdditionTable;
                SrVPFinanceAdditionTable += '<th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Marketing Head</th>';
                
                if(isMkngHeadNotificationRequired != true){
                }
                marketingHeadAdditionTable += '</tr></thead><tbody>';
                SrVPFinanceAdditionTable += '</tr></thead><tbody>';
                
                
                for (Phoenix_Approval_Grid__c grid: approvalGridList) {
                    //Decimal toround = 3.14159265;
                    //Decimal rounded = toRound.setScale(2, RoundingMode.HALF_UP);
                    
                    //Decimal revenue =  grid.Phoenix_Revenue__c != null ? grid.Phoenix_Revenue__c.setScale(2, RoundingMode.HALF_UP)  : 0;
                    //revenue =   revenue != null ? revenue.setScale(2, RoundingMode.HALF_UP) : 0;
                    String revenue = AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Revenue__c).setScale(0));
                    String tptImpact = AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_TP_Impact__c).setScale(0));
                    String gmImpact = AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_GM_Impact__c).setScale(0));

                    Decimal gmPerc = grid.Phoenix_GM__c != null ? grid.Phoenix_GM__c.setScale(0, RoundingMode.HALF_UP)  : 0;
                    Decimal tptPerc = grid.Phoenix_TP__c != null ? grid.Phoenix_TP__c.setScale(0, RoundingMode.HALF_UP)  : 0;
                    sNo++;
                    Product_Families_bItems += '<tr>';
                    priceChangedeviationTable +=  '<tr><td style="width: 26px;"></td>';
                    deviationTable += '<tr><td style="width: 26px;"></td>';
                    additionTable += '<tr><td style="width: 26px;"></td>';
                    priceChangeSrVPFinanceTable += '<tr><td style="width: 26px;"></td>';
                    SrVPFinanceTable += '<tr><td style="width: 26px;"></td>';
                    marketingHeadAdditionTable += '<tr><td style="width: 26px;"></td>';
                    SrVPFinanceAdditionTable += '<tr><td style="width: 26px;"></td>';
                    Product_Families_bItems += '<td style="border: 1px solid black;text-align:center;;padding:8px;">' + sNo + '</td>';
                    priceChangedeviationTable += '<td style="border: 1px solid black;text-align:center;;padding:8px;">' + sNo + '</td>';
                    deviationTable += '<td style="border: 1px solid black;text-align:center;;padding:8px;">' + sNo + '</td>';
                    additionTable += '<td style="border: 1px solid black;text-align:center;;padding:8px;">' + sNo + '</td>';
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align:center;padding:8px;">' + sNo + '</td>';
                    SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:center;;padding:8px;">' + sNo + '</td>';
                    priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:center;;padding:8px;">' + sNo + '</td>';
                    SrVPFinanceTable += '<td style="border: 1px solid black;text-align:center;;padding:8px;">' + sNo + '</td>';
                    Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Product_Family__c + '</td>';
                    priceChangedeviationTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + grid.Phoenix_Product_Family__c + '</td>';
                    deviationTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + grid.Phoenix_Product_Family__c + '</td>';
                    additionTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + grid.Phoenix_Product_Family__c + '</td>';
                    marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align:left;padding:8px;">' + grid.Phoenix_Product_Family__c + '</td>';
                    SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + grid.Phoenix_Product_Family__c + '</td>';
                    priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + grid.Phoenix_Product_Family__c + '</td>';
                    SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + grid.Phoenix_Product_Family__c + '</td>';	
                    if (grid.Phoenix_Is_New_Low__c == True) {
                        priceChangedeviationTable += '<td style="border: 1px solid black;text-align:left;;background-color:Yellow;padding:8px;">' + 'Yes' + '</td>';
                        deviationTable += '<td style="border: 1px solid black;text-align:left;;background-color:Yellow;padding:8px;">' + 'Yes' + '</td>';
                        additionTable += '<td style="border: 1px solid black;text-align:left;background-color:Yellow;padding:8px;">' + 'Yes' + '</td>'; 
                        marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align:left;background-color:Yellow;padding:8px;">' + 'Yes' + '</td>';
                        SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:left;;background-color:Yellow;padding:8px;">' + 'Yes' + '</td>';
                        Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;background-color:Yellow;padding:8px">' + 'Yes' + '</td>';
                        priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;background-color:Yellow;padding:8px;">' + 'Yes' + '</td>';
                        SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;background-color:Yellow;padding:8px;">' + 'Yes' + '</td>';
                    }
                    else if (grid.Phoenix_Is_New_Low__c == False) {
                        priceChangedeviationTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + 'No' + '</td>';
                        deviationTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + 'No' + '</td>';
                        Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + 'No' + '</td>';
                        additionTable += '<td style="border: 1px solid black;text-align:left;padding:8px;">' + 'No' + '</td>';  
                        marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align:left;padding:8px;">' + 'No' + '</td>';
                        SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + 'No' + '</td>';
                        priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + 'No' + '</td>';
                        SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;padding:8px;">' + 'No' + '</td>';
                    }
                    else {
                        Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                        priceChangedeviationTable += '<td style="border: 1px solid black;padding: 8px;text-align:center;">' + '' + '</td>';
                        deviationTable += '<td style="border: 1px solid black;padding: 8px;text-align:center;">' + '' + '</td>';
                        additionTable += '<td style="border: 1px solid black;padding: 8px;text-align:center;">' + '' + '</td>'; 
                        marketingHeadAdditionTable += '<td style="border: 1px solid black;padding: 8px;text-align:center;">' + '' + '</td>';
                        SrVPFinanceAdditionTable += '<td style="border: 1px solid black;padding: 8px;text-align:center;">' + '' + '</td>';
                        priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;padding: 8px;text-align:center;">' + '' + '</td>';
                        SrVPFinanceTable += '<td style="border: 1px solid black;padding: 8px;text-align:center;">' + '' + '</td>';
                    }
                    if (grid.Phoenix_Is_New_Low__c == True) {
                        deviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + '2Mn < x' + '</td>';
                        if(revenue != null)	deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' +revenue + '</td>';
                        else deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' +revenue + '</td>';
                        
                        deviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 40%' + '</td>';
                        if(tptPerc != null)	deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' + tptPerc+'%' + '</td>';
                        else deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + tptPerc+'%' + '</td>';
                        
                        deviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 25%' + '</td>';
                        if(gmPerc != null)	deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' + gmPerc +'%' +'</td>';
                        else deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + gmPerc +'%' +'</td>';
                        
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
                        deviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + '2Mn < x' + '</td>';
                        if(revenue != null)	deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' +revenue + '</td>';
                        else	deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' +revenue + '</td>';
                        
                        deviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 40%' + '</td>';
                        if(tptPerc != null)	deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' + tptPerc+'%' + '</td>';
                        else deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + tptPerc+'%' + '</td>';
                        
                        deviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 25%' + '</td>';
                        if(gmPerc != null)	deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' + gmPerc +'%' +'</td>';
                        else deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + gmPerc +'%' +'</td>';
						priceChangedeviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + '$1 Mn < x'  + '</td>';
                        if(tptImpact != null)	priceChangedeviationTable +='<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' +tptImpact + '</td>';
                        else priceChangedeviationTable +='<td style="border: 1px solid black;text-align:right;padding: 8px;">' +tptImpact + '</td>';
                        
                        priceChangedeviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 40%' + '</td>';
                        if(tptPerc != null)	priceChangedeviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' + tptPerc+'%' + '</td>';
                        else priceChangedeviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + tptPerc+'%' + '</td>';
                        
                        priceChangedeviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 25%' + '</td>';
                        if(gmPerc != null)	priceChangedeviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red">' + gmPerc +'%' +'</td>';
                        else	priceChangedeviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + gmPerc +'%' +'</td>';	
                   
                    }else{
                        deviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + '2Mn < x' + '</td>';
                        deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' +'' + '</td>';
                        deviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 40%' + '</td>';
                        deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + '' + '</td>';
                        deviationTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 25%' + '</td>';
                        deviationTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' +  '' +'</td>';
						
                    }
                    if (grid.Phoenix_Is_partner_product__c == false) {
                        
                        if (grid.Phoenix_Annualized_TP__c != Null) {
                            Product_Families_bItems += '<td style="border: 1px solid black;text-align:right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_TP__c).setScale(0))+ '</td>';
                            additionTable += '<td style="border: 1px solid black;text-align:right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_TP__c).setScale(0))+ '</td>';
                            marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align:right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_TP__c).setScale(0))+ '</td>';
                            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_TP__c).setScale(0))+ '</td>';
                        }
                        else {
                            Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                            additionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                            marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        
                        
                        
                        if (grid.Phoenix_Annualized_TP_Impact__c != Null) {
                            Product_Families_bItems += '<td style="border: 1px solid black;text-align:right;;padding:8px">'+ AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_TP_Impact__c).setScale(0))+ '</td>';
                            additionTable += '<td style="border: 1px solid black;text-align:right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_TP_Impact__c).setScale(0))+ '</td>';
                            marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align:right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_TP_Impact__c).setScale(0))+ '</td>';
                            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_TP_Impact__c).setScale(0))+ '</td>';
                        }
                        else {
                            Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                            additionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                            marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        
                        if (grid.Phoenix_Annualized_TP_Impact_Limit__c != Null) {
                            Product_Families_bItems += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;;padding:8px">' + grid.Phoenix_Annualized_TP_Impact_Limit__c + '</td>';
                            additionTable += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;;padding:8px">' + grid.Phoenix_Annualized_TP_Impact_Limit__c + '</td>';
                            marketingHeadAdditionTable += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;padding:8px">' + grid.Phoenix_Annualized_TP_Impact_Limit__c + '</td>';
                            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;;padding:8px">' + grid.Phoenix_Annualized_TP_Impact_Limit__c + '</td>';
                        }
                        else {
                            Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                            additionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                            marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        
                        if (grid.Phoenix_TP__c != Null) {
                            Product_Families_bItems += '<td style="border: 1px solid black;text-align:right;padding:8px">' + grid.Phoenix_TP__c.setscale(2) +'%' +'</td>';
                        }
                        else {
                            Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        
                        if (grid.Phoenix_TP_Limit__c != Null) {
                            Product_Families_bItems += '<td style="border: 1px solid black;text-align:right;background-color:Yellow;padding:8px">' + grid.Phoenix_TP_Limit__c + '</td>';
                        }
                        else {
                            Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        
                    } else {
                        additionTable += '<td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td>';
                        marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td>';
                        SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td>';
                        Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td>';
                        
                    }
                    if (grid.Phoenix_Is_partner_product__c == True) {
                        if (grid.Phoenix_Annualized_GM__c != Null) {
                            Product_Families_bItems += '<td style="border: 1px solid black;text-align: right;;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_GM__c).setScale(0))+ '</td>';
                            additionTable += '<td style="border: 1px solid black;text-align: right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_GM__c).setScale(0))+ '</td>';
                            marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align: right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_GM__c).setScale(0))+ '</td>';
                            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align: right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_GM__c).setScale(0))+ '</td>';
                        }
                        else {
                            Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                            additionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                            marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        
                        if (grid.Phoenix_Annualized_GM_Impact__c != Null) {
                            Product_Families_bItems += '<td style="border: 1px solid black;text-align: right;;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_GM_Impact__c).setScale(0))+ '</td>';
                            additionTable += '<td style="border: 1px solid black;text-align: right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_GM_Impact__c).setScale(0))+ '</td>';
                            marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align: right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_GM_Impact__c).setScale(0))+ '</td>';
                            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align: right;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Annualized_GM_Impact__c).setScale(0))+ '</td>';
                        }
                        else {
                            Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                            additionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                            marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        
                        if (grid.Phoenix_Annualized_GM_Impact_Limit__c != Null) {
                            Product_Families_bItems += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;;padding:8px">' + grid.Phoenix_Annualized_GM_Impact_Limit__c + '</td>';
                            additionTable += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;padding:8px">' + grid.Phoenix_Annualized_GM_Impact_Limit__c + '</td>';
                            marketingHeadAdditionTable += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;padding:8px">' + grid.Phoenix_Annualized_GM_Impact_Limit__c + '</td>';
                            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;padding:8px">' + grid.Phoenix_Annualized_GM_Impact_Limit__c + '</td>';
                        }
                        else {
                            Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                            additionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                            marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        
                        
                    } else {
                        Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td>';
                        additionTable += '<td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td>';
                        marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td>';
                        SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td><td style="border: 1px solid black;">' + '' + '</td>';
                    }
                    
                    if (grid.Phoenix_Revenue__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align: right;;padding:8px">' + AllEmailNotificationsSenderCls.getCurrencyFormatted((grid.Phoenix_Revenue__c).setScale(0))+ '</td>';
                    else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    
                    if (grid.Phoenix_Revenue_Limit__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;;padding:8px">' + grid.Phoenix_Revenue_Limit__c + '</td>';
                    else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    
                    if (grid.Phoenix_Is_partner_product__c == True) {
                        if (grid.Phoenix_GM__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:right;;padding:8px">' + grid.Phoenix_GM__c.setscale(2) + '%' +'</td>';
                        else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                        
                        if (grid.Phoenix_GM_Limit__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:right;background-color:Yellow;;padding:8px">' + grid.Phoenix_GM_Limit__c + '</td>';
                        else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    } else {
                        
                        Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                        Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                        
                    }
                    if (!bid.Phoenix_is_OTC_Bid__c || bid.Phoenix_is_OTC_Bid__c) {
                        if (grid.Phoenix_Marketing_Lead_Rx__c != Null) {
                            Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Marketing_Lead_Rx__c + '</td>';
                            marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align:left;padding:8px">' + grid.Phoenix_Marketing_Lead_Rx__c + '</td>';
                            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Marketing_Lead_Rx__c + '</td>';
                        }
                        else {
                            Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                            marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        
                        if (grid.Phoenix_Marketing_Lead_SRx__c != Null) {
                            Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;padding:8px">' + grid.Phoenix_Marketing_Lead_SRx__c + '</td>';
                            marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Marketing_Lead_SRx__c + '</td>';
                            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Marketing_Lead_SRx__c + '</td>';
                        }
                        else {
                            Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                            marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                    }
                    if (grid.Phoenix_Marketing_Lead_OTC__c != Null) {
                        Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Marketing_Lead_OTC__c + '</td>';
                        marketingHeadAdditionTable += '<td style="border: 1px solid black;text-align:left;padding:8px">' + grid.Phoenix_Marketing_Lead_OTC__c + '</td>';
                        SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Marketing_Lead_OTC__c + '</td>';
                    }
                    else {
                        Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                        marketingHeadAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                        SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                    }
                    // if(isMkngHeadNotificationRequired !=true){
                    if (grid.Phoenix_Business_Head_Comments__c != Null) {
                        Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Business_Head_Comments__c + '</td>';
                        priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Business_Head_Comments__c + '</td>';
                        SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Business_Head_Comments__c + '</td>';
                    }
                    else {
                        Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                        priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                        SrVPFinanceTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                    }
                    //}
                    
                    if (grid.Phoenix_Approval__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Approval__c + '</td>';
                    else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    if(isMkngHeadNotificationRequired !=true){ 
                        if (grid.Phoenix_Comments__c != Null) {
                            Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Comments__c + '</td>';
                            priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Comments__c + '</td>';
                            SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Comments__c + '</td>';
                            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Comments__c + '</td>';
                        }
                        else {
                            Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                            priceChangeSrVPFinanceTable +=  '<td style="border: 1px solid black;">' + '' + '</td>';
                            SrVPFinanceTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                            SrVPFinanceAdditionTable += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                    }
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
                    //priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">'+ tptImpact + '</td>';
                    SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + '2Mn < x' + '</td>';
                    if(revenue != null) SrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red;">'+ revenue + '</td>';
                    else SrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">'+ '' + '</td>';
                    
  					
                    priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 40%' + '</td>';
                    
                    if(tptPerc != null && grid.Phoenix_Is_partner_product__c == False)	priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red;">' + tptPerc+'%'+ '</td>';
                    else priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + ''+ '</td>';
                    priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 25%' + '</td>';
                    if(gmPerc != null && grid.Phoenix_Is_partner_product__c == True)	priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red;">' + gmPerc + '%</td>';
                    else priceChangeSrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + ''+'</td>';
                    
                    SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 40%' + '</td>';
                    if(tptPerc != null)	SrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red;">' + tptPerc+'%'+ '</td>';
                    else SrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + ''+ '</td>';
                    SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 25%' + '</td>';
                    if(tptPerc != null)	SrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;color:red;">' + gmPerc + '%</td>';
                    else SrVPFinanceTable += '<td style="border: 1px solid black;text-align:right;padding: 8px;">' + gmPerc + '%</td>';
                    
                    /*   SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 4px;">' + '2Mn < x' + '</td>';
SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 4px;">' + grid.Phoenix_Revenue__c + '</td>';
SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 4px;">' + 'x < 40%' + '</td>';
SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 4px;">' + grid.Phoenix_TP__c + '</td>';
SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 4px;">' + 'x < 25%' + '</td>';
SrVPFinanceTable += '<td style="border: 1px solid black;text-align:left;padding: 4px;">' + grid.Phoenix_GM__c + '</td>';*/
                    
                    if (grid.Phoenix_Sr_Director_VP__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Sr_Director_VP__c + '</td>';
                    else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    
                    
                    if (grid.Phoenix_Sr_Director_VP_Finance_Comments__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:8px">' + grid.Phoenix_Sr_Director_VP_Finance_Comments__c + '</td>';
                    else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    
                    Product_Families_bItems += '</tr>';
                    priceChangedeviationTable += '</tr>';
                    deviationTable += '</tr>';
                    additionTable += '</tr>';
                    priceChangeSrVPFinanceTable +=  '</tr>';
                    SrVPFinanceTable += '</tr>';
                    marketingHeadAdditionTable += '</tr>';
                    SrVPFinanceAdditionTable += '</tr>';
                    
                }
                Product_Families_bItems += '</tbody></table>';
                priceChangedeviationTable += '</tbody></table>';
                deviationTable += '</tbody></table>';
                additionTable += '</tbody></table>';
                priceChangeSrVPFinanceTable += '</tbody></table>';
                SrVPFinanceTable += '</tbody></table>';
                marketingHeadAdditionTable += '</tbody></table>';
                SrVPFinanceAdditionTable += '</tbody></table>';
                
                
                //Add Sales persons
                if (bid.Phoenix_Sales_Person_2__c != null) {
                    allPeopleInvolvedEmailsSet.add(bid.Phoenix_Sales_Person_2__r.Email);
                } else if (bid.Phoenix_Salesperson__c != null) {
                    allPeopleInvolvedEmailsSet.add(bid.Phoenix_Salesperson__r.Email);
                }
                
                set < string > newAddress = new set < string > ();
                set < string > CCAddress = new set < string > ();
                
                /*this is for Sr VP Notification*/
               // System.debug('step_name in bid ==>'+step_name)
               // isSVPNotificationRequired =true;
               // if(isSVPNotificationRequired == true){
                if(isSVPNotificationRequired == true && (step_name == 'Sr Director or VP Finance Approval' || step_name == 'Contract Team\'s Action')){
                    marketingHeadSRVPReviewNotificationS.reviewNotificationsSrVpFinance(objId,nextSteps);

                    /*  set < String > toAddress = new set < String > ();
                    Set < string > ccEmailIds = new Set < string > ();
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
                    String SrVpFinanceReview = '';
                    SrVpFinanceReview = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 0px 8px;">Dear Team,</td></tr></table>';
                    SrVpFinanceReview += '<table><tr><td style="width: 24px;"></td><td style="padding: 4px 8px 8px 8px;"><span style="font-size: 14px;font-family: Sans-Serif">'+creatBy_Name+' has raised '+bid.Phoenix_Bid_Type__c+' Bid as one or more of the products listed below have deviation(s). There is <b>No Action Required from you</b> but we are sending this for your information only.</span> </td></tr></table>';
                    
                    SrVpFinanceReview += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:0px 8px 8px 8px;"><b>Deviation(s):</b></td></tr></table>';
                    if(bidType == 'Price Change' || bidType == 'Customer Rebate Change'){
                        SrVpFinanceReview +=priceChangeSrVPFinanceTable ;
                    }else{
                        SrVpFinanceReview += SrVPFinanceTable;
                    }
                    SrVpFinanceReview += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;"><b>Bid Details:</b></td></tr></table>';
                    SrVpFinanceReview += '<table style="border-collapse: collapse;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+objId+'">'+bidNumber+'</a></th></tr>';
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
                    */
                }
                /* end for Sr VP Notification*/
                
                /*this is for marketing head*/
                //System.debug('step_name==>'+step_name);
                //isMkngHeadNotificationRequired =true;
                //if(isMkngHeadNotificationRequired == true){
                if(isMkngHeadNotificationRequired == true && (stepname != 'Marketing Lead Rx Approval' && stepname != 'Marketing Lead SRx Approval'&& stepname != 'Marketing Lead OTC Approval' && stepname != 'Marketing Approval') && (step_name == 'Marketing Head' ||step_name == 'Marketing Head Approval' || step_name == 'Finance Approval')){
                  /*  String mktHeadName = '';
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
                    marketingHeadTable += '<table><tr><td style="width: 24px;"></td><td style="padding: 4px 8px 8px 8px;"><span style="font-size: 14px;font-family: Sans-Serif">'+creatBy_Name+' has raised '+bid.Phoenix_Bid_Type__c+' Bid as one or more of the products listed below have deviation(s). There is <b>No Action Required from you</b> but we are sending this for your information only.</span> </td></tr></table>';
                    
                    
                    marketingHeadTable += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:0px 8px 8px 8px;"><b>Deviation(s):</b></td></tr></table>';
                    if(bidType == 'Price Change' || bidType == 'Customer Rebate Change'){
                        marketingHeadTable += priceChangedeviationTable;
                    }else{
                        marketingHeadTable += deviationTable;//SrVPFinanceTable;
                    }
                    marketingHeadTable += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;"><b>Bid Details:</b></td></tr></table>';
                    marketingHeadTable  += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+objId+'">'+bidNumber+'</a></th></tr>';
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
                    Boolean isFooterTextAlterRequired = true;
                    AllEmailNotificationsSenderCls.sendEmailAlert(objId, marketingHeadTable, new List<String> (newAddress), new List<String> (CCAddress), subject, title, isFooterTextAlterRequired);*/
                    marketingHeadSRVPReviewNotificationS.reviewNotificationsMarketingHead(objId,nextSteps);
                }
                
                /*end for marketing head*/
                
                
                
                /* end for Sr VP of Finance review Deviation */
                
                
            } 
            else if (objName == 'Phoenix_NDC_Change__c') {
                System.debug('in ndc change');
                 emailApprovalNotificationsforNDCChange.approvalEmails(objId, nextSteps);
              /*  try{
                    User creatByName = new User();
                    String ndcChangeName,currentPrdFamily,proposedPrdFamily,description,approvalStatus,creatBy_Name;
                    ndcChange = [Select Id, Name,CreatedBy.Name,Phoenix_Description__c,Phoenix_Current_Product_Family__c,Phoenix_Proposed_Product_Family__c, Owner.Email, Phoenix_Approval_Status__c from Phoenix_NDC_Change__c WHERE Id =: objId LIMIT 1];
                    if(ndcChange != null){
                        ndcChangeName = ndcChange.Name != null ? ndcChange.Name : '';
                        currentPrdFamily = ndcChange.Phoenix_Current_Product_Family__c != null ? ndcChange.Phoenix_Current_Product_Family__c : '';
                        proposedPrdFamily = ndcChange.Phoenix_Proposed_Product_Family__c != null ? ndcChange.Phoenix_Proposed_Product_Family__c : '';
                        description = ndcChange.Phoenix_Description__c != null ? ndcChange.Phoenix_Description__c : '';
                        ndcId = ndcChange.Id;
                        approvalStatus = ndcChange.Phoenix_Approval_Status__c != null ? ndcChange.Phoenix_Approval_Status__c :'';
                        creatByName = ndcChange.CreatedBy;
                        creatBy_Name = creatByName.Name;
                        
                    }
                 
                    String stepName,approverName,approver,approverEmail;
                    String initiator ='';
                    List<Phoenix_Bid_Process_Steps__c> bidProcSteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
                                                                       Phoenix_Approver__r.Email,Phoenix_Process_Step__r.Name,Phoenix_Approver_Email__c, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE 	Phoenix_NDC_Change__c =: objId];
                    for (Phoenix_Bid_Process_Steps__c step: bidProcSteps) {
                        if(step.Phoenix_Status__c == 'In Process'){
                            approverName = step.Phoenix_Approver__r.Name;
                            approverEmail = step.Phoenix_Approver_Email__c;
                            stepName = step.Phoenix_Process_Step__r.Name;
                        }
                        if(step.Phoenix_Status__c == 'Completed'){
                            approver = step.Phoenix_Approver__r.Name;
                            initiator = step.Phoenix_Approver__r.Name;
                           
                            
                        }
                    }
                    
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
                    set < String > toAddress = new set < String > ();
                    Set < string > ccEmailIds = new Set < string > ();
                    for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                        String approver_Name = '';
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
                                
                                approver_Name = usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Name;
                            }
                            else{
                                
                                approver_Name = usersMap.get(step.Phoenix_Approver__c).Name;
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
                   
                    
                    List < Phoenix_NDC_Change_Line_Item__c > ndcLineItemsList = [Select Phoenix_Account__r.Name,Phoenix_Contract__r.Name,Phoenix_Current_Product__c, Phoenix_Current_Product__r.Name, Phoenix_Current_Product_NDC__c, Phoenix_Current_Product_Pack_Size__c, Phoenix_Proposed_Product__c, Phoenix_Proposed_Product__r.Name, Phoenix_Proposed_Product_NDC__c, Phoenix_Proposed_Product_Pack_Size__c FROM Phoenix_NDC_Change_Line_Item__c where Phoenix_NDC_Change__c =: objId AND  Phoenix_Final_Status__c != 'Not Approved'];
                    string tableData = '';
                  
                    integer countOfProducts = 0;
                    if(stepName  != 'Supply Chain Approval' && stepName  != 'Finance Approval' &&stepName  != 'Vistex Update'){
                        tableData += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>NDC Change Line Item(s):</b></td></tr></table>';
                        
                    }
                    
                    if(stepName  == 'Finance Approval' ||stepName  == 'Vistex Update'){
                        tableData += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>NDC Line Item(s):</b></td></tr></table>';
                        
                    }
                    if(stepName  == 'Supply Chain Approval'){
                        tableData += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>NDC Product(s):</b></td></tr></table>';
                        
                    }
                    tableData += '<table style="border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;"><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;min-width:40px;" rowspan="2">S. No</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left" rowspan="2">Account</th><th style="border: 1px solid black;padding:4px 8px;background-color: #d4bdf8;text-align:left" rowspan="2">Contract</th><th style="border: 1px solid black;padding:4px; background-color: #B8D0F8;text-align:center" colspan = "3">Current</th><th style="border: 1px solid black;padding:4px; background-color: #FAD385;text-align:center" colspan = "3">Proposed</th></tr>';
                    tableData += '<tr><th style="width: 36px;"><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Current Product</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left">Current Product NDC</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left">Current Product Pack Size</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left">Proposed Product</th><th  style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Proposed Product NDC</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Proposed Product Pack Size</th></tr></thead>';
                    tableData += '<tbody>';
                    for (Phoenix_NDC_Change_Line_Item__c ndcItem: ndcLineItemsList) {
                        countOfProducts += 1;
                        sNo++;
                        tableData += '<tr>';
                        tableData += '<td style="width: 26px;"></td>';
                        tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + sNo + '</td>';
                        if (ndcItem.Phoenix_Account__r.Name != null) tableData += '<td style="border: 1px solid black;text-align:left;padding: 4px 8px;">' + ndcItem.Phoenix_Account__r.Name + '</td>';
                        else tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        if (ndcItem.Phoenix_Contract__r.Name != null) {
                            tableData += '<td style="border: 1px solid black;text-align:left;padding: 4px 8px;">' + ndcItem.Phoenix_Contract__r.Name + '</td>';
                        } else {
                            tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        }
                        
                        if (ndcItem.Phoenix_Current_Product__r.Name != null) tableData += '<td style="border: 1px solid black;text-align:left;padding: 4px 8px;">' + ndcItem.Phoenix_Current_Product__r.Name + '</td>';
                        else tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        if (ndcItem.Phoenix_Current_Product_NDC__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding: 4px 8px;">'+ ndcItem.Phoenix_Current_Product_NDC__c + '</td>';
                        else tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        if (ndcItem.Phoenix_Current_Product_Pack_Size__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding: 4px 8px;">' + ndcItem.Phoenix_Current_Product_Pack_Size__c + '</td>';
                        else tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        if (ndcItem.Phoenix_Proposed_Product__r.Name != null) tableData += '<td style="border: 1px solid black;text-align:left;padding: 4px 8px;">' + ndcItem.Phoenix_Proposed_Product__r.Name + '</td>';
                        else tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        if (ndcItem.Phoenix_Proposed_Product_NDC__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding: 4px 8px;">' + ndcItem.Phoenix_Proposed_Product_NDC__c + '</td>';
                        else tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        if (ndcItem.Phoenix_Proposed_Product_Pack_Size__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding: 4px 8px;">' + ndcItem.Phoenix_Proposed_Product_Pack_Size__c + '</td>';
                        else tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        
                        tableData += '</tr>';
                        
                    }
                    tableData += '</tbody></table>';
                    if(stepName == 'Supply Chain Approval'){
                        content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear Supply Planner Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">'+creatBy_Name+' requires your approval of NDC change for the below mentioned Products in BRIGHT '+ndcChangeName+'. </td></tr></table>';
                        content += '<table align="center" style="background-color:#d4bdf8;border-radius: 15px;padding:20px;font-size: 18px;font-family: Sans-Serif;"><tr><th>'+countOfProducts+' NDC Line Items Need Approval</b></th></tr></table>';
                        
                    }
                    
                    if(stepName == 'Contract Team\'s Action'){
                        content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear Contracts Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">'+creatBy_Name+' submitted a '+ndcChangeName+' which has completed the NDC Change approval workflow on BRIGHT. Below are the details of the NDC Change for your review and further processing. You will now be able to generate a Proposal for submission and notify the Customer. </td></tr></table>';
                        
                    }
                    if(stepName == 'Customer\'s Update'){
                        content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear VISTEX Team / Demand Planning Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;"> We want to inform you that the Contracts Team has submitted the new customer response for NDC Change '+ndcChangeName+'. Please review and process the item(s) in the tables below and update the NDC Change information in VISTEX. </td></tr></table>';
                        
                    }
                    if(stepName == 'Finance Approval'){
                        content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear Finance Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;"> '+creatBy_Name+ ' requires your approval of NDC change for the below mentioned Products in BRIGHT '+ndcChangeName+'. </td></tr></table>';
                        content += '<table align="center" style="background-color:#d4bdf8;border-radius: 15px;padding:20px;font-size: 18px;font-family: Sans-Serif;"><tr><th>'+countOfProducts+' NDC Line Items Need Approval</b></th></tr></table>';
                        
                    }
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:2px 4px 4px 8px;"><b>NDC Change Details:</b></td></tr></table>';
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr>';
                    content += '<td>';
                    content  += '<table style="border-collapse: collapse;padding-left:26px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">NDC Change Name</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+ndcId+'">'+ndcChangeName+'</a></th></tr>';
                    content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Product Family</th><td style="border: 1px solid black;padding: 8px;">'+currentPrdFamily+'</td></tr>';
                    content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Proposed Product Family</th><td style="border: 1px solid black;padding: 8px;">'+proposedPrdFamily+'</td></tr>';
                    
                    content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Description</th><td style="border: 1px solid black;padding: 8px;">'+description+'</td></tr>';
                    content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+approvalStatus+'</td></tr>';
                    
                    content += '</thead></table>';
                    content += '</td></tr></table>';
                    content += tableData;
                    if(stepName == 'Contract Team\'s Action' || stepName == 'Customer\'s Update' ){
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To view the NDC line items, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+ndcId+'">'+ndcChangeName+'</a></b>.</td></tr></table>';
                        
                    }
                    if(stepName == 'Finance Approval' || stepName == 'Supply Chain Approval'){
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To approve, modify or reject the NDC Change line items, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+ndcId+'">'+ndcChangeName+'</a></b>.</td></tr></table>';
                        
                    }
                    if(stepName == 'Contract Team\'s Action'){
                        subject = 'Your Action Required: Customer Proposal Request for NDC Change - '+ ndcChangeName;
                        title ='<span style="font-weight:200">NDC Change Proposal Request</span>';
                    }
                    if(stepName == 'Customer\'s Update'){
                        subject = 'Your Update Required for NDC Change - '+ ndcChangeName;
                        title ='<span style="font-weight:200">New Customer Response</span>';
                    }
                    if(stepName == 'Finance Approval'){
                        subject = 'Your Approval Required for NDC Change - '+ ndcChangeName;
                        title ='<span style="font-weight:200">NDC Change Approval Request</span>';
                    }
                    if(stepName == 'Supply Chain Approval'){
                        subject = 'Your Approval Required for NDC Change - '+ ndcChangeName;
                        title ='<span style="font-weight:200">Volume Approval Request</span>';
                    }
                    Boolean isFooterTextAlterRequired = false;
                    AllEmailNotificationsSenderCls.sendEmailAlert(ndcId, content, new List<String> (toAddress), new List<String> (ccEmailIds), subject, title,isFooterTextAlterRequired); 
                    
                    
                }
                Catch(Exception e) {
                    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
                    
                }
                */
            } 
            else if (objName == 'Phoenix_PHS_Price_Change__c') {
                emailApprovalNotificationsforNDCChange.approvalEmailsPHSPriceChange(objId, nextSteps);

               /* try{
                    User creatByName = new User();
                    String initiatorName = '';
                    String creatBy_Name='';
                    pHSChange = [Select Id, Name,owner.Email,Phoenix_PHS_Price_Change_Name__c,Phoenix_PHS_Price_Change_Description__c,CreatedBy.Name,owner.Name, Phoenix_Approval_Status__c, Phoenix_Record_Type__c from Phoenix_PHS_Price_Change__c WHERE Id =: objId LIMIT 1];
                    string approvalStatus = pHSChange.Phoenix_Approval_Status__c != null ? pHSChange.Phoenix_Approval_Status__c : '';
                    string rectype = pHSChange.Phoenix_Record_Type__c != null ? pHSChange.Phoenix_Record_Type__c : '';
                    String phsPriceChangeName = pHSChange.Name != null ? pHSChange.Name : '';
                    String phsId = pHSChange.Id;
                    String phsPriceName = pHSChange.Phoenix_PHS_Price_Change_Name__c != null ? pHSChange.Phoenix_PHS_Price_Change_Name__c : '';
                    String pHSPriceChangeType = pHSChange.Phoenix_Record_Type__c;
                    String Description = pHSChange.Phoenix_PHS_Price_Change_Description__c != null ? pHSChange.Phoenix_PHS_Price_Change_Description__c : '';
                    creatByName = pHSChange.CreatedBy;
                    creatBy_Name = creatByName.Name;
                    initiatorName = pHSChange.owner.Name != null ? pHSChange.owner.Name : '' ;
                    String vpFinanceApprover;
                    string tableData = '';
                    List<Phoenix_Bid_Process_Steps__c> bidProcessSteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
                                                                          Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE 	Phoenix_PHS_Price_Change__c =: objId];
                    for (Phoenix_Bid_Process_Steps__c step: bidProcessSteps) {
                        if(step.Phoenix_Status__c == 'Completed'){
                            vpFinanceApprover = step.Phoenix_Approver__r.Name;
                        }
                    }
                    tableData += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>PHS Price Change Line Item(s):</b></td></tr></table>';
                    if (rectype == 'Provisional PHS Price Change') {
                        tableData += '<table style="border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;"></th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;min-width:40px;">S. No</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Product Name</th><th style="border: 1px solid black;padding:4px 8px;background-color: #d4bdf8;text-align:left;">Material Code</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">NDC-11</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Provisional PHS Price</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Price Start Date</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Price End Date</th></tr></thead>';
                        
                    } else {
                        tableData += '<table style="border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;"></th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;min-width:40px;">S. No</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Product Name</th><th style="border: 1px solid black;padding:4px 8px;background-color: #d4bdf8;text-align:left;">Material Code</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">NDC-11</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Old PHS Price $</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">New PHS Price $</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">% Change in Price</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Last 90 days PHS Unit</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Sales Difference </th></tr></thead>';
                        
                    }
                    tableData += '<tbody>';
                    integer countOfProducts = 0;
                    List < Phoenix_PHS_Price_Change_Line__c > pHSLineItemsList = [Select Phoenix_Product_Name__c, Phoenix_Product_Name__r.Name, Phoenix_Material_Code__c, Phoenix_NDC_11__c, Phoenix_Provisional_PHS_Price__c, Phoenix_Old_PHS_Price__c, Phoenix_New_PHS_Price__c,	Phoenix_Change_in_Price__c,	Phoenix_Last_90_days_PHS_Units__c,	Phoenix_Sales_Difference__c, Phoenix_Price_Start_Date__c, Phoenix_Price_End_Date__c FROM Phoenix_PHS_Price_Change_Line__c where Phoenix_PHS_Price_Change__c =: objId and Phoenix_Final_Status__c != 'Not Approved'];
                    
                    for (Phoenix_PHS_Price_Change_Line__c pHSItem: pHSLineItemsList) {
                        sNo++;
                        countOfProducts = countOfProducts+1;
                        tableData += '<tr>';
                        tableData += '<td style="width: 26px;"></td>';
                        tableData += '<td style="border: 1px solid black;text-align:center;padding:4px 8px;">' + sNo + '</td>';
                        if (pHSItem.Phoenix_Product_Name__r.Name != null) tableData += '<td style="border: 1px solid black;text-align:left;padding:4px 8px;">' + pHSItem.Phoenix_Product_Name__r.Name + '</td>';
                        else tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        
                        if (pHSItem.Phoenix_Material_Code__c != null) {
                            tableData += '<td style="border: 1px solid black;text-align:right;padding:4px 8px;">' + pHSItem.Phoenix_Material_Code__c + '</td>';
                        } else {
                            tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        }
                        if (pHSItem.Phoenix_NDC_11__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding:4px 8px;">' + pHSItem.Phoenix_NDC_11__c + '</td>';
                        else tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        if (rectype == 'Provisional PHS Price Change') {
                            String provPhsPrice = AllEmailNotificationsSenderCls.getCurrencyFormatted(pHSItem.Phoenix_Provisional_PHS_Price__c);
                            if (pHSItem.Phoenix_Provisional_PHS_Price__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding:4px 8px;">' +provPhsPrice + '</td>';
                            else tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                            if (pHSItem.Phoenix_Price_Start_Date__c != null){
                                DateTime startDate = DateTime.newInstance(pHSItem.Phoenix_Price_Start_Date__c, Time.newInstance(0, 0, 0, 0));
                                tableData += '<td style="border: 1px solid black;text-align:left;padding:4px 8px;">' + startDate.format('MMM d yyyy') + '</td>';
                            }
                            else{
                                tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                            }
                            if (pHSItem.Phoenix_Price_End_Date__c != null) {
                                DateTime endDate = DateTime.newInstance(pHSItem.Phoenix_Price_End_Date__c, Time.newInstance(0, 0, 0, 0));
                                
                                tableData += '<td style="border: 1px solid black;text-align: left;padding:4px 8px;">' + endDate.format('MMM d yyyy') + '</td>';
                            } else {
                                tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                            }
                        }
                        else{
                            if (pHSItem.Phoenix_Old_PHS_Price__c != null){ 
                                String oldPhsPrice = AllEmailNotificationsSenderCls.getCurrencyFormatted(pHSItem.Phoenix_Old_PHS_Price__c);
                                tableData += '<td style="border: 1px solid black;text-align:right;padding:4px 8px;">' +oldPhsPrice + '</td>';
                            }else{
                                tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                            }
                            if (pHSItem.Phoenix_New_PHS_Price__c != null){
                                String newPhsPrice = AllEmailNotificationsSenderCls.getCurrencyFormatted(pHSItem.Phoenix_New_PHS_Price__c);
                                tableData += '<td style="border: 1px solid black;text-align:right;padding:4px 8px;">' +newPhsPrice + '</td>';
                            }else {
                                tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                            }
                            if (pHSItem.Phoenix_Change_in_Price__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding:4px 8px;">' + String.valueOf((pHSItem.Phoenix_Change_in_Price__c).format()) +'%'+ '</td>';
                            else tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                            if (pHSItem.Phoenix_Last_90_days_PHS_Units__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding:4px 8px;">' + String.valueOf((pHSItem.Phoenix_Last_90_days_PHS_Units__c).format()) + '</td>';
                            else tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                            if (pHSItem.Phoenix_Sales_Difference__c != null){
                                String salesDifference = AllEmailNotificationsSenderCls.getCurrencyFormatted(pHSItem.Phoenix_Sales_Difference__c);
                                
                                tableData += '<td style="border: 1px solid black;text-align:right;padding:4px 8px;">' + salesDifference + '</td>';
                            }
                            else{
                                tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                            }
                        }
                        tableData += '</tr>';                    
                    }
                    tableData += '</tbody></table>';
                    if(approvalStatus == 'Sr Director or VP Finance'){
                        content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">'+initiatorName+' requires your approval of the PHS Price Change for the below mentioned products in BRIGHT '+phsPriceChangeName+'. </td></tr></table>';
                        content += '<table align="center" style="background-color:#d4bdf8;border-radius: 15px;padding:20px;font-size: 18px;font-family: Sans-Serif;"><tr><th>'+countOfProducts+' Product(s) Need Approval</b></th></tr></table>';
                        
                    }
                    if(approvalStatus == 'Vistex Update'){
                        content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear VISTEX Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">We want to inform you that the '+vpFinanceApprover+' has approved the PHS Price Change. You can now update the information in VISTEX.</td></tr></table>';
                        content += '<table align="center" style="background-color:#d4bdf8;border-radius: 15px;padding:20px;font-size: 18px;font-family: Sans-Serif;"><tr><th>'+countOfProducts+' Product(s) Approved</b></th></tr></table>';
                        
                    }
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;"><b>PHS Price Change Details:</b></td></tr></table>';
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr>';
                    content += '<td>';
                    content  += '<table style="border-collapse: collapse;padding-left:26px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">PHS Price Change Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+phsId+'">'+phsPriceChangeName+'</a></th></tr>';
                    content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">PHS Price Change Name</th><td style="border: 1px solid black;padding: 8px;">'+phsPriceName+'</td></tr>';
                    content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">PHS Price Change Type</th><td style="border: 1px solid black;padding: 8px;">'+pHSPriceChangeType+'</td></tr>';
                    content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Description</th><td style="border: 1px solid black;padding: 8px;">'+Description+'</td></tr>';
                    content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+approvalStatus+'</td></tr>';
                    
                    content += '</thead></table>';
                    content += '</td></tr></table>';
                    content += tableData;
                    if(approvalStatus == 'Sr Director or VP Finance'){
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To approve, modify or reject the PHS Price Change line items, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+phsId+'">'+phsPriceChangeName+'</a></b>.</td></tr></table>';
                    } 
                    if(approvalStatus == 'Vistex Update'){
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To view the PHS Price Change line items, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+phsId+'">'+phsPriceChangeName+'</a></b>.</td></tr></table>';
                        
                    }
                    if (rectype == 'Provisional PHS Price Change') {
                        
                        if(approvalStatus == 'Sr Director or VP Finance'){
                            title = '<span style="font-weight:200">Provisional PHS Price Change Approval Request</span>';
                            subject = 'Your Approval Required for '+ rectype +' - '+phsPriceChangeName;
                        }
                        if(approvalStatus == 'Vistex Update'){
                            title = '<span style="font-weight:200">Provisional PHS Price Change Update Request</span>';  
                            subject ='Your Update Required for '+ rectype +' - '+phsPriceChangeName;               
                        }
                        
                    }
                    else{
                        if(approvalStatus == 'Sr Director or VP Finance'){
                            title = '<span style="font-weight:200">Quarterly PHS Price Change Approval Request</span>';  
                            subject = 'Your Approval Required for '+ rectype +' - '+phsPriceChangeName;
                        }
                        if(approvalStatus == 'Vistex Update'){
                            title = '<span style="font-weight:200">Quarterly PHS Price Change Update Request</span>';  
                            subject ='Your Update Required for '+ rectype +' - '+phsPriceChangeName;               
                        }
                    }
                    
                    set < String > toAddress = new set < String > ();
                    set < String > ccEmailIds = new set < String > ();
                    
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
                        }
                    }
                    ccEmailIds.add(pHSChange.owner.Email);
                    if (Label.Phoenix_Contracts_DL != null) ccEmailIds.addAll(Label.Phoenix_Contracts_DL.split(','));
                    ccEmailIds.addAll(allPeopleInvolvedEmailsSet);
                    for (string emailId: toAddress) {
                        if (ccEmailIds.contains(emailId))
                            ccEmailIds.remove(emailId);
                    }
                    
                    If(ccEmailIds != null && ccEmailIds.contains('mkalawadia@drreddys.com'))ccEmailIds.remove('mkalawadia@drreddys.com');
                    Boolean isFooterTextAlterRequired = false;
                    AllEmailNotificationsSenderCls.sendEmailAlert(phsId, content, new List<String>(toAddress), new List < String > (ccEmailIds), subject, title,isFooterTextAlterRequired);
                }
                Catch(Exception e) {
                    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
                    
                }
                */
            } 
            else if (objName == 'New_Product_WAC_Pricing__c') {
                emailApprovalNotificationsforNDCChange.approvalEmailsNewProductWAC(objId, nextSteps);

               /* try{
                    String initiator = '';
                    List<New_Product_WAC_Pricing__c> recs = [SELECT  Ownerid,owner.Name from New_Product_WAC_Pricing__c where id=:objId];
                    for(New_Product_WAC_Pricing__c rec: recs){
                        initiator = rec.owner.Name;
                        
                    }
                    
                    User creatByName = new User();
                    String newWacPricingName,prodFamily,productType,approvalStatus,creatBy_Name,summaryText;
                    Decimal netSales,tptPerc,gmPerc;
                    newWac = [Select Id, Name,	Phoenix_Summary__c, Owner.Email,CreatedBy.Name,Phoenix_TPT__c,Phoenix_GM__c,Product_Family__c,Product_Family__r.Name,Phoenix_Product_Type__c,Phoenix_Net_sales_annualized__c, Phoenix_Approval_Status__c from New_Product_WAC_Pricing__c WHERE Id =: objId LIMIT 1];
                    newWacPricingName = newWac.Name != null ? newWac.Name :'';
                    prodFamily = newWac.Product_Family__r.Name != null ? newWac.Product_Family__r.Name : '';
                    productType = newWac.Phoenix_Product_Type__c != null ? newWac.Phoenix_Product_Type__c :'';
                    approvalStatus = newWac.Phoenix_Approval_Status__c != null ? newWac.Phoenix_Approval_Status__c : '';
                    netSales = newWac.Phoenix_Net_sales_annualized__c != null ? newWac.Phoenix_Net_sales_annualized__c : 0;
                    tptPerc = 	newWac.Phoenix_TPT__c != null ? newWac.Phoenix_TPT__c : 0;
                    gmPerc = newWac.Phoenix_GM__c != null ? newWac.Phoenix_GM__c : 0;
                    creatByName = newWac.CreatedBy;
                    creatBy_Name = creatByName.Name;
                    summaryText = newWac.Phoenix_Summary__c != null ? newWac.Phoenix_Summary__c : '';
                    
                    List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > NewWACLineItemsList = [Select Phoenix_Material_Number__c, Phoenix_NDC_11__c, Phoenix_Product__r.Name, Phoenix_Pkg_Size__c, Phoenix_WAC__c,Phoenix_Brand_WAC__c, Phoenix_Lowest_Price__c, Phoenix_TPT_GM__c FROM Phoenix_NewProduct_WAC_Pricing_LineItems__c where Phoenix_New_Product_WAC_Pricing__c =: objId AND  Phoenix_Final_Status__c != 'Not Approved'];
                    string tableData = '';
                    tableData += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:0px 8px 8px 8px;"><b>Additional Details:</b></td></tr></table>';
                    tableData += '<table style="border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;"></th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;min-width:40px;">S. No</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Material Number</th><th style="border: 1px solid black;padding:4px 8px;background-color: #d4bdf8;text-align:left;">NDC-11</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Product Name</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Pack Size</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">WAC</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Brand WAC</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:Left;">Lowest Price</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:Left;">TPT% / GM%</th></tr></thead>';
                    
                    tableData += '<tbody>';
                    for (Phoenix_NewProduct_WAC_Pricing_LineItems__c newWACItem: NewWACLineItemsList) {
                        sNo++;
                        tableData += '<tr>';
                        tableData += '<td style="width: 26px;"></td>';
                        tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + sNo + '</td>';
                        if (newWACItem.Phoenix_Material_Number__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding: 4px 8px;">' + newWACItem.Phoenix_Material_Number__c + '</td>';
                        else tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        if (newWACItem.Phoenix_NDC_11__c != null) tableData += '<td style="border: 1px solid black;text-align:right;right: 4px 8px;">' + newWACItem.Phoenix_NDC_11__c + '</td>';
                        else tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        if (newWACItem.Phoenix_Product__r.Name != null) tableData += '<td style="border: 1px solid black;text-align:left;padding: 4px 8px;">' + newWACItem.Phoenix_Product__r.Name + '</td>';
                        else tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        if (newWACItem.Phoenix_Pkg_Size__c != null) tableData += '<td style="border: 1px solid black;text-align:right;padding: 4px 8px;">' + newWACItem.Phoenix_Pkg_Size__c + '</td>';
                        else tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        if (newWACItem.Phoenix_WAC__c != null) {
                            String wac = AllEmailNotificationsSenderCls.getCurrencyFormatted(newWACItem.Phoenix_WAC__c);
                            tableData += '<td style="border: 1px solid black;text-align;right; padding:4px 8px;">' +wac+ '</td>';
                        } else{ 
                            tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        }
                        if (newWACItem.Phoenix_Brand_WAC__c != null){
                            String brandwac = AllEmailNotificationsSenderCls.getCurrencyFormatted(newWACItem.Phoenix_WAC__c);
                            tableData += '<td style="border: 1px solid black;text-align:right;padding:4px 8px;">' + brandwac + '</td>';
                        }
                        else {
                            tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        if (newWACItem.Phoenix_Lowest_Price__c != null){
                            String lowestPrice = AllEmailNotificationsSenderCls.getCurrencyFormatted(newWACItem.Phoenix_Lowest_Price__c);
                            tableData += '<td style="border: 1px solid black;text-align:right;padding:4px 8px;">' + lowestPrice + '</td>';
                        }
                        else {
                            tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                        }
                        if (newWACItem.Phoenix_TPT_GM__c != null) tableData += '<td style="border: 1px solid black;text-align: right;padding:4px 8px;">'  + String.valueOf((newWACItem.Phoenix_TPT_GM__c).format()) +'%'+ '</td>';
                        else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                        
                        tableData += '</tr>';
                    }
                    tableData += '</tbody></table>';
                    String approver = '';
                    set < String > toAddress = new set < String > ();
                    set < String > ccEmailIds = new set < String > ();
                    String stepName,content1,approverEmail,mrkLeadapproverName;
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
                    
                    String approverName = '';
                    for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                        
                        stepName = step.Phoenix_Process_Step__r.Name;
                        approverEmail = step.Phoenix_Approver_Email__c;
                        
                        approverName = step.Phoenix_Approver__r.Name;
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
                        if(newWac.owner.Email != null){
                            ccEmailIds.add(newWac.owner.Email);      
                        }
                        if (Label.Phoenix_Contracts_DL != null) ccEmailIds.addAll(Label.Phoenix_Contracts_DL.split(','));
                        ccEmailIds.addAll(allPeopleInvolvedEmailsSet);
                        for (string emailId: toAddress) {
                            if (ccEmailIds.contains(emailId))
                                ccEmailIds.remove(emailId);
                        }
                        
                        If(ccEmailIds != null && ccEmailIds.contains('mkalawadia@drreddys.com'))ccEmailIds.remove('mkalawadia@drreddys.com');
                    }
                    if(stepName == 'Marketing Lead Rx Approval' || stepName == 'Marketing Lead OTC Approval' ||stepName == 'Marketing Lead SRx Approval'){
                        content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear '+approverName+',</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">'+initiator+' requires your attention to the New Product WAC Pricing proposal. Below are details for your review and approval. </td></tr></table>';
                        
                    }else if(stepName == 'Marketing Head Approval'){
                        content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear '+approverName+',</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">'+initiator+' requires your attention to the New Product WAC Pricing Bid as the product family has a deviation. Below is the deviation mentioned and you are requested to provide your approval / rejection to the proposal. </td></tr></table>';
                        
                    }
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 8px;"><b>Product Family Details:</b></td></tr></table>';
                    content += '<table style="border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left; background-color: #d4bdf8;" rowspan="2" >Product Family</th><th style="border: 1px solid black;padding:4px;text-align:center; background-color: #d4bdf8;" colspan="2">Revenue</th><th style="border: 1px solid black;padding:4px;text-align:center;background-color: #d4bdf8;" colspan="2">TP%</th><th style="border: 1px solid black;padding:4px;text-align:center; background-color: #d4bdf8;" colspan="2">GM%</th></tr>';
                    content += '<tr><th style="width: 36px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left; background-color: #A7D0F8;">Threshold</th><th style="border: 1px solid black;padding:4px 8px;text-align:left; background-color: #A7D0F8;">Actual</th><th style="border: 1px solid black;padding:4px 8px;text-align:left; background-color: #A7D0F8;">Threshold</th><th style="border: 1px solid black;padding:4px 8px;text-align:left; background-color: #A7D0F8;">Actual</th><th style="border: 1px solid black;padding:4px 8px;text-align:left; background-color: #A7D0F8;">Threshold</th><th style="border: 1px solid black;padding:4px 8px;text-align:left; background-color: #A7D0F8;">Actual</th></tr></thead>';
                    
                    content += '<tr>';
                    content += '<td style="width: 26px;"></td>';
                    content += '<td style="border: 1px solid black;text-align:left;padding: 4px 8px;">' + prodFamily + '</td>';     
                    content += '<td style="border: 1px solid black;text-align:left;padding: 4px 8px;">' + 'x < 1 Mn' + '</td>'; 
                     String net_Sales = newWac.Phoenix_Net_sales_annualized__c != null ? AllEmailNotificationsSenderCls.getCurrencyFormatted(newWac.Phoenix_Net_sales_annualized__c) : '';
					Decimal tpt_Perc = newWac.Phoenix_TPT__c != null ? AllEmailNotificationsSenderCls.getPercentFormatted(newWac.Phoenix_TPT__c) :0;
               		Decimal gm_Perc = newWac.Phoenix_GM__c != null ? AllEmailNotificationsSenderCls.getPercentFormatted(newWac.Phoenix_GM__c) : 0 ;

                    content += '<td style="border: 1px solid black;text-align:right;padding: 4px 8px;color:red;">' + net_Sales + '</td>';     
                    content += '<td style="border: 1px solid black;text-align:left;padding: 4px 8px;">' + 'x < 40%' + '</td>';     
                    content += '<td style="border: 1px solid black;text-align:right;padding: 4px 8px;color:red;">' + tpt_Perc+'%' + '</td>';     
                    content += '<td style="border: 1px solid black;text-align:left;padding: 8px;">' + 'x < 25%' + '</td>';     
                    content += '<td style="border: 1px solid black;text-align:right;padding: 4px 8px;color:red;">' + gm_Perc+'%' + '</td>';     
                    
                    content += '</tr>';
                    content += '</tbody></table>';
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;"><b>WAC Price Details:</b></td></tr></table>';
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr>';
                    content += '<td>';
                    content  += '<table style="border-collapse: collapse;padding-left:26px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">New Product WAC Pricing Name</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+objId+'">'+newWacPricingName+'</a></th></tr>';
                    content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Product Family</th><td style="border: 1px solid black;padding: 8px;">'+prodFamily+'</td></tr>';
                    content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Product Type</th><td style="border: 1px solid black;padding: 8px;">'+productType+'</td></tr>';
                    content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Approval Status</th><td style="border: 1px solid black;padding: 8px;">'+approvalStatus+'</td></tr>';
                    content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Net Sales</th><td style="border: 1px solid black;padding: 8px;">'+'$'+String.valueOf(netSales.format())+'</td></tr>';
                    content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">TP%</th><td style="border: 1px solid black;padding: 8px;">'+String.valueOf(tptPerc.format())+'%'+'</td></tr>';
                    content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+approvalStatus+'</td></tr>';
                    
                    
                    content += '</thead></table>';
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 4px;"><b>Summary Details:</b></td></tr></table>';
                    
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 4px;">'+initiator+':</td><td style="padding: 0px 8px 0px 0px;">'+summaryText+'</td></tr></table>';
                    content += '</thead></table>';
                    content += '</td></tr></table>';
                    content += tableData;
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To approve, modify or reject the New Product WAC Pricing, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+objId+'">'+newWacPricingName+'</a></b>.</td></tr></table>';
                    
                    if(stepName == 'Marketing Lead Rx Approval' || stepName == 'Marketing Lead OTC Approval' ||stepName == 'Marketing Lead SRx Approval'){
                        subject = 'Your Action Required: Approve New Product WAC Pricing - '+newWacPricingName;
                        title ='<span style="font-weight:200">Management Approval Request</span>';
                    }else{
                        subject = 'Your Action Required : Approve Deviation for New Product WAC Pricing - '+newWacPricingName;
                        title ='<span style="font-weight:200">Management Approval Request (Deviation)</span>';
                    }
                  
                   
                    Boolean isFooterTextAlterRequired = false;
                    AllEmailNotificationsSenderCls.sendEmailAlert(objId, content, new List<String> (toAddress), new List<String> (ccEmailIds), subject, title, isFooterTextAlterRequired);
                }
                Catch(Exception e) {
                    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
                }   
                */
            } 
            else if (objName == 'Phoenix_WAC_Change__c') {
                  emailApprovalNotificationsforNDCChange.approvalEmailsWACChange(objId, nextSteps);
              /*  try{
                    set < String > toAddress = new set < String > ();
                    set < String > ccEmailIds = new set < String > ();
                    String approverName,approverEmail,stepName,initiator_name;
                    List<Phoenix_Bid_Process_Steps__c> bidProcessSteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
                                                                          Phoenix_Approver__r.Email,Phoenix_Process_Step__r.Name,Phoenix_Approver_Email__c, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE 	Phoenix_WAC_Change__c =: objId];
                    for (Phoenix_Bid_Process_Steps__c step: bidProcessSteps) {
                        
                        if(step.Phoenix_Status__c == 'In Process'){
                            approverName = step.Phoenix_Approver__r.Name;
                            stepName = step.Phoenix_Process_Step__r.Name;
                            
                        }
                        if(step.Phoenix_Status__c == 'Completed'){
                            initiator_name = step.Phoenix_Approver__r.Name;
                        }
                    }
                    User creatByName = new User();
                    String wacChangeName,prodFamily,creatBy_Name,summaryText;
                    date effectiveDate;
                    decimal salesIncrease,wacFinancialBenifit,medicaidRelease,workCapBenifit,phsBenifit,totalNetBenifit;
                    WacChange = [Select Id, Phoenix_Total_Net_Benefit__c,Name,Phoenix_Product_Family__c,Phoenix_Summary__c,CreatedBy.Name,Phoenix_Medicaid_release__c,Working_capital_benefit__c,Phoenix_Total_Net_Benefit_Impact__c,Phoenix_PHS_hit__c,Phoenix_WAC_finance_impact__c,Product_Family__r.Name,Phoenix_Effective_Date__c,Phoenix_Sales_Increase__c, Owner.Email, Phoenix_Approval_Status__c from Phoenix_WAC_Change__c WHERE Id =: objId LIMIT 1];
                    wacChangeName = WacChange.Name ;
                    prodFamily = WacChange.Phoenix_Product_Family__c != null ? WacChange.Phoenix_Product_Family__c :'';
                    if(WacChange.Phoenix_Effective_Date__c !=null){
                        effectiveDate = WacChange.Phoenix_Effective_Date__c;
                    }
                    salesIncrease = WacChange.Phoenix_Sales_Increase__c != null ? WacChange.Phoenix_Sales_Increase__c : 0;
                    wacFinancialBenifit = WacChange.Phoenix_WAC_finance_impact__c != null ? WacChange.Phoenix_WAC_finance_impact__c : 0;
                    medicaidRelease = WacChange.Phoenix_Medicaid_release__c != null ? WacChange.Phoenix_Medicaid_release__c : 0;
                    workCapBenifit = WacChange.Working_capital_benefit__c != null ? WacChange.Working_capital_benefit__c :0;
                    phsBenifit = WacChange.Phoenix_PHS_hit__c != null ? WacChange.Phoenix_PHS_hit__c :0;
                    totalNetBenifit = 	WacChange.Phoenix_Total_Net_Benefit__c != null ? WacChange.Phoenix_Total_Net_Benefit__c : 0;
                    creatByName = WacChange.CreatedBy;
                    creatBy_Name = creatByName.Name;
                    summaryText = WacChange.Phoenix_Summary__c != null ? WacChange.Phoenix_Summary__c : '';
                    
                    
                    string tableData = '';
                    integer countOfProducts = 0;
                    tableData += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>WAC Change Summary:</b></td></tr></table>';
                    tableData += '<table style="border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;"></th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;min-width:40px;">S. No</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Material Number</th><th style="border: 1px solid black;padding:4px 8px;background-color: #d4bdf8;text-align:left;">Product Name</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">NDC11</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">System WAC</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Proposed WAC</th></tr></thead>';
                    
                    tableData += '<tbody>';
                    List < Phoenix_WAC_Change_Line_Item__c > WACChangeLineItemsList = [Select Phoenix_Matl_No__c,Phoenix_NDC11__c,Phoenix_Contr_Number__c, Phoenix_Cust_Name__c, Phoenix_Product__r.Name, Phoenix_Proposed_WAC__c, Phoenix_System_WAC__c, Phoenix_Uploaded_WAC__c, Phoenix_Proposed_Contr_Price__c, Phoenix_System_Contract_price__c, Phoenix_Uploaded_Contr_Price__c FROM Phoenix_WAC_Change_Line_Item__c where Phoenix_WAC_Change__c =: objId];
                    
                    Map<String,list<Phoenix_WAC_Change_Line_Item__c>> maplist = new map<String,list<Phoenix_WAC_Change_Line_Item__c>>();
                    for(Phoenix_WAC_Change_Line_Item__c item: WACChangeLineItemsList){
                        if(maplist.containskey(item.Phoenix_Matl_No__c)){
                            List<Phoenix_WAC_Change_Line_Item__c> templist = maplist.get(item.Phoenix_Matl_No__c);
                            tempList.add(item);
                            maplist.put(item.Phoenix_Matl_No__c,tempList);
                        } else{
                            maplist.put(item.Phoenix_Matl_No__c,new List<Phoenix_WAC_Change_Line_Item__c> {item}); 
                        }
                    }
                    for(String forId : maplist.keySet()){
                         sNo++;
                        for(Phoenix_WAC_Change_Line_Item__c WACChangeItem: maplist.get(forId)){
                       
                        countOfProducts =countOfProducts+1;
                        tableData += '<tr>';
                        tableData += '<td style="width: 26px;"></td>';
                        tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + sNo + '</td>';
                        if (WACChangeItem.Phoenix_Matl_No__c != null) tableData += '<td style="border: 1px solid black;padding: 4px;text-align: right;">' + WACChangeItem.Phoenix_Matl_No__c + '</td>';
                        else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                        if (WACChangeItem.Phoenix_Product__r.Name != null) tableData += '<td style="border: 1px solid black;padding: 4px 8px;text-align: left;">' + WACChangeItem.Phoenix_Product__r.Name + '</td>';
                        else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                        if (WACChangeItem.Phoenix_NDC11__c != null) tableData += '<td style="border: 1px solid black;padding: 4px 8px;text-align: right;">' + WACChangeItem.Phoenix_NDC11__c + '</td>';
                        else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                        if (WACChangeItem.Phoenix_System_WAC__c != null){
                            String systemWac = AllEmailNotificationsSenderCls.getCurrencyFormatted(WACChangeItem.Phoenix_System_WAC__c);
                            tableData += '<td style="border: 1px solid black;padding: 4px;text-align: right;">' +systemWac + '</td>';
                        }
                        else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                        if (WACChangeItem.Phoenix_Proposed_WAC__c != null){
                            String proposedWac = AllEmailNotificationsSenderCls.getCurrencyFormatted(WACChangeItem.Phoenix_Proposed_WAC__c);
                            tableData += '<td style="border: 1px solid black;padding: 4px;text-align: right;">' +proposedWac+ '</td>';
                        }
                        else tableData += '<td style="border: 1px solid black;">' + '' + '</td>';
                        tableData += '</tr>';
                            break;
                    }
                    }
                    tableData += '</tbody></table>';
                    DateTime endDate = DateTime.newInstance(WacChange.Phoenix_Effective_Date__c, Time.newInstance(0, 0, 0, 0));
                    if(stepName == 'Marketing Head Approval'){
                        content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear '+approverName+',</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">'+creatBy_Name+' requires your attention to the proposed WAC change on the below mentioned Product family. Below are details for your review and approval.</td></tr></table>';
                        
                    }
                    if(stepName == 'Contract Team\'s Action'){
                        
                        content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear Contracts Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">We want to inform you that the approval phase of  WAC Change '+WacChangeName+' for the below mentioned product by '+initiator_name+' is completed.</td></tr></table>';
                        content += '<table align="center" style="background-color:#d4bdf8;border-radius: 15px;padding:20px;font-size: 18px;font-family: Sans-Serif;"><tr><th>'+countOfProducts+' Product(s) WAC Change(s)</b></th></tr></table>';
                        
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">You are now ready to generate a proposal for submission to the customer.</th></tr></table>';
                        
                    }
                    if(stepName == 'Vistex Update'){
                        content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">We want to inform you that the approval phase for '+WacChangeName+' is completed. You can now update the WAC Change information in VISTEX.</td></tr></table>';
                        
                    }
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;"><b>WAC Change Impact Details:</b></td></tr></table>';
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr>';
                    content += '<td>';
                    content  += '<table style="border-collapse: collapse;padding-left:26px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">WAC Change Name</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+objId+'">'+WacChangeName+'</a></th></tr>';
                    content += '<tr><th style="width: 26px;"><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Product Family</th><td style="border: 1px solid black;padding: 8px;">'+prodFamily+'</td></tr><tr><th style="width: 26px;"><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Effective Date</th><td style="border: 1px solid black;padding: 8px;">'+endDate.format('MMM d yyyy')+'</td></tr>';
                    String netSales = '';String wacFinanceImpact = '';
                    if(WacChange.Phoenix_Sales_Increase__c != null){
                    	netSales = AllEmailNotificationsSenderCls.getCurrencyFormatted((WacChange.Phoenix_Sales_Increase__c).setScale(2));
                    }else{
                        netSales = '';
                    }
                    content += '<tr><th style="width: 26px;"><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Sales Increase</th><td style="border: 1px solid black;padding: 8px;">'+netSales+'</td></tr>';
                    content += '<tr><th style="width: 26px;"><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">WAC Financial Benefit</th><td style="border: 1px solid black;padding: 8px;">'+'$'+String.valueOf(wacFinancialBenifit.format())+'</td></tr>';
                    content += '<tr><th style="width: 26px;"><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Medicaid Release</th><td style="border: 1px solid black;padding: 8px;">'+'$'+String.valueOf(medicaidRelease.format())+'</td></tr>';
                    content += '<tr><th style="width: 26px;"><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Working Capital Benefit</th><td style="border: 1px solid black;padding: 8px;">'+'$'+String.valueOf(workCapBenifit.format())+'</td></tr>';
                    content += '<tr><th style="width: 26px;"><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">PHS Benefit</th><td style="border: 1px solid black;padding: 8px;">'+'$'+String.valueOf(phsBenifit.format())+'</td></tr>';
                    content += '<tr><th style="width: 26px;"><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Total Net Benefit</th><td style="border: 1px solid black;padding: 8px;">'+'$'+String.valueOf(totalNetBenifit.format())+'</td></tr>';
                    content += '<tr><th style="width: 26px;"><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+stepName+'</td></tr>';
                    
                    content += '</thead></table>';
                    content += '</td></tr></table>';
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;"><b>Summary Details:</b></td></tr></table>';
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+creatBy_Name+':</td><td style="padding: 0px 8px 0px 0px;">'+summaryText+'</td></tr></table>';
                    
                    content += tableData;
                    
                    if(stepName == 'Marketing Head Approval'){
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To approve, modify or reject the WAC Change, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+objId+'">'+wacChangeName+'</a></b>.</td></tr></table>';
                        
                    }
                    if(stepName == 'Contract Team\'s Action' || stepName == 'Vistex Update'){
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To view the WAC Change line items, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+objId+'">'+wacChangeName+'</a></b>.</td></tr></table>';
                        
                    }
                    
                    String approver = '';
                    
                    if(stepName == 'Marketing Head Approval'){
                        subject = 'Your Approval Required for WAC Change - '+wacChangeName;
                        title ='<span style="font-weight:200">WAC Change Approval Request</span>';
                    }
                    if(stepName == 'Contract Team\'s Action'){
                        subject = 'Your Action Required: Update WAC Change - '+wacChangeName;
                        title ='<span style="font-weight:200">Generate WAC Change Proposal</span>';
                    }
                    if(stepName == 'Vistex Update'){
                        title ='<span style="font-weight:200">WAC Change Update Request</span>';
                        subject = 'Your Action Required: Update WAC Change - '+wacChangeName;
                    }
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
                            
                            
                        }
                        
                        ccEmailIds.add(WacChange.owner.Email);       
                        if (Label.Phoenix_Contracts_DL != null) ccEmailIds.addAll(Label.Phoenix_Contracts_DL.split(','));
                        ccEmailIds.addAll(allPeopleInvolvedEmailsSet);
                        for (string emailId: toAddress) {
                            if (ccEmailIds.contains(emailId))
                                ccEmailIds.remove(emailId);
                        }
                        
                        If(ccEmailIds != null && ccEmailIds.contains('mkalawadia@drreddys.com'))ccEmailIds.remove('mkalawadia@drreddys.com');
                        
                    }
                    if(stepName !='Customer\'s Update'){
                        Boolean isFooterTextAlterRequired = false;
                        AllEmailNotificationsSenderCls.sendEmailAlert(objId, content, new List<String> (toAddress), new List<String> (ccEmailIds), subject, title,isFooterTextAlterRequired);
                    }
                }
                Catch(Exception e) {
                    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
                    
                } */
                
            }
            
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
            
            
            
            Map < Id, Set < String >> itemsByDitectorMap = new Map < Id, Set < String >> ();
            Map < Id, Set < String >> itemsByLeadMap = new Map < Id, Set < String >> ();
            Map < Id, List < Phoenix_Bid_Line_Item__c >> lineItemsByDirectorMap = new Map < Id, List < Phoenix_Bid_Line_Item__c >> ();
            Map < Id, List < Phoenix_Bid_Line_Item__c >> lineItemsByLeadMap = new Map < Id, List < Phoenix_Bid_Line_Item__c >> ();
            if (bidItems != null && bidItems.size() > 0) {
                for (Phoenix_Bid_Line_Item__c item: bidItems) {
                    if(item.Phoenix_Product__r.Phoenix_Product_Director__c != null && lineItemsByDirectorMap.containsKey(item.Phoenix_Product__r.Phoenix_Product_Director__c)){
                        List<Phoenix_Bid_Line_Item__c> tempList = lineItemsByDirectorMap.get(item.Phoenix_Product__r.Phoenix_Product_Director__c);
                        tempList.add(item);
                        lineItemsByDirectorMap.put(item.Phoenix_Product__r.Phoenix_Product_Director__c, tempList);
                    } else{
                        lineItemsByDirectorMap.put(item.Phoenix_Product__r.Phoenix_Product_Director__c, new List<Phoenix_Bid_Line_Item__c>{item});
                    }
                    if(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c != null && lineItemsByLeadMap.containsKey(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c)){
                        List<Phoenix_Bid_Line_Item__c> tempList = lineItemsByLeadMap.get(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c);
                        tempList.add(item);
                        lineItemsByLeadMap.put(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c, tempList);
                    } else{
                        lineItemsByLeadMap.put(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c, new List<Phoenix_Bid_Line_Item__c>{item});
                    }
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
            
            set < String > toAddress = new set < String > ();
            Set < string > ccEmailIds = new Set < string > ();
            List<Phoenix_Bid_Process_Steps__c> bidProcessSteps = [SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,
                               Phoenix_Approver__r.Email,Phoenix_Process_Step__r.Name,Phoenix_Approver_Email__c, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c WHERE 	Phoenix_Bid__c =: objId order by Phoenix_Approval_Sent_Time__c desc];
            List < Phoenix_Bid_Process_Steps__c > nextSteps1 = new List < Phoenix_Bid_Process_Steps__c > ();
            for (Phoenix_Bid_Process_Steps__c step1: bidProcessSteps) {
                if(step1.Phoenix_Status__c == 'In Process'){
                    nextSteps1.add(step1) ;
                }
            }
          	Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('Marketing_Approval_Email_Template', bid.Id);
            for (Phoenix_Bid_Process_Steps__c step: nextSteps1) {
                 System.debug('before call util');
                String templateBody = emailWrapperMain.mailHtmlBody;
                System.debug('templateBody==>'+templateBody);
                String newTemplateBody = emailWrapper.mailHtmlBody;
                String subject1 = emailWrapper.mailSubject;
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String approverName = '';
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
                    
                    if (templateBody.contains('Phoenix_Approver')) {
                        templateBody = templateBody.replace('Phoenix_Approver', 'Team');
                        approverName = 'Team';
                    }
                    
                } 
                else if (step.Phoenix_Status__c == 'In Process' && step.Phoenix_Approver__c != null) { //Means individuals
                    mail = new Messaging.SingleEmailMessage();
                    toAddress = new Set<String>();
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
                            approverName = usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Name;
                        }
                        else{
                            templateBody = templateBody.replace('Phoenix_Approver',
                                                                usersMap.get(step.Phoenix_Approver__c).Name);
                            approverName = usersMap.get(step.Phoenix_Approver__c).Name;
                        }
                        
                    }
                    //   if (templateBody.contains('Team')) templateBody = templateBody.replaceFirst('Team', step.Phoenix_Approver__r.Name);
                }
                String emailData = 'Dear,<br /><br />';
                Boolean isFooterTextAlterRequired = false;
                String bidComments = '';
                if(bid.Phoenix_Comments__c != null && bid.Phoenix_Comments__c != '') {
                    bidComments = bid.Phoenix_Comments__c.replaceAll('<p>', '').replaceAll('</p>', '');
                }
                String salesPersonName = (bid.Phoenix_Salesperson__r.Name != null) ? bid.Phoenix_Salesperson__r.Name:'';
                String prodFamilyString = ''; string content1 = ''; String createdDate; DateTime internalDueDateTime; DateTime customerBidDeadline; String dynamicSubject = ''; String dynamicTitle = ''; Integer productsCount = 0;
                Time commentedTime;
                if (bid.Phoenix_Internal_Target_Date__c != null) 
                    internalDueDateTime = DateTime.newInstance(bid.Phoenix_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0));                        
                if (bid.Phoenix_Bid_Deadline_Date__c != null) 
                    customerBidDeadline = DateTime.newInstance(bid.Phoenix_Bid_Deadline_Date__c, Time.newInstance(0, 0, 0, 0));
                if (bid.CreatedDate != null) 
                    createdDate = Phoenix_Util.getUserTimeNow(bid.CreatedDate,'America/New_York');
                //createdDate = DateTime.newInstance(date.newinstance(bid.CreatedDate.year(), bid.CreatedDate.month(), bid.CreatedDate.day()), Time.newInstance(0, 0, 0, 0));
                if(objName == 'Phoenix_Bid__c'){
                    boolean  donotSend  = false;
                   System.debug('step.Phoenix_Approver_Team__c==>'+step.Phoenix_Approver_Team__c);
                    if (Phoenix_SubmitBidForApprovalCtrl.financeNotApplicableBool) {
                        System.debug('srimayee test financeNotApplicableBool');
                        prodFamilyString = '';
                        integer i = 1;
                        if(step.Phoenix_Approver__c!=null){
                            dynamicSubject = 'Your Approval Required for '+bid.Phoenix_Bid_Type__c+' - '+bid.Name+' - '+bid.Phoenix_Customer__r.Name;
                            dynamicTitle = bid.Phoenix_Bid_Type__c+' Bid Approval Notification (Deviation)';//'Management Approval Request (Deviation)';
                            //content1 = '<div style="color: black; margin: 20px 0px -10px 0px;padding:20px 40px 10px 40px;background-color: white;">Dear '+approverName+',<br /><br />';
                            //content1 += bid.Owner.Name+' requires your attention to the '+bid.Phoenix_Bid_Type__c+' Bid as one or more of the products listed below have deviation(s). Below are the deviation(s) mentioned and you are requested to provide your approval / rejection.<br/><br/>';
                            
                            content1 = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style=" padding:12px 8px 0px 8px;">Dear Finance Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;"><span style="font-size: 14px;font-family: Sans-Serif;">'+bid.Owner.Name+' has raised '+bid.Phoenix_Bid_Type__c+' Bid and one or more of the products listed below have deviation(s).There is <b><u>No Action Required from you</u></b> but we are sending this for your information only.</span> </td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:0px 8px 8px 8px"><b>Deviation(s):</b></td></tr></table>';
                            content1 += deviationTable;
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:8px;"><b>Bid Details:</b></td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';                            
                            content1 += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></a></th></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Name__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Type__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Customer__r.Name+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+bid.Owner.Name+'</td></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Salesperson</th><td style="border: 1px solid black;padding: 8px;">'+salesPersonName+'</td></tr>';
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
                            String created_Date = Phoenix_Util.getUserTimeNow(bid.CreatedDate,'America/New_York');
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;"><b>Bid Comments:</b></td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+bid.Owner.Name+' ('+createdDate+'): ';
                            if(bid.Phoenix_Comments__c != null)	content1 += bidComments+'</td></tr></table>';
                            else content1 += '</td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>Additional Details:</b></td></tr></table>';
                            content1 += marketingHeadAdditionTable;
                            /* content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 8px;"><b>For Approval / Rejection through email, reply to this email with:</b></td></tr></table>';
content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 8px;"><b>To Approve: </b>"APPROVE" or "APPROVED" or "YES".</td></tr></table>';
content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 8px;"><b>To Reject: </b>"REJECT" or "REJECTED" or "NO".</td></tr></table>';
content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 8px;"><b>For Approval / Rejection on BRIGHT:</b></td></tr></table>';*/
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 8px;">To review the bid line items, Refer to the link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a>.</b></td></tr></table>';
                            toAddress.addAll(approvalTeamUsersEmailsMap.get('Finance'));
                        }
                        AllEmailNotificationsSenderCls.sendEmailAlert(ndcId, content1, new List<String> (toAddress), new List<String> (ccEmailIds), dynamicSubject, dynamicTitle, isFooterTextAlterRequired);
                    }
                    /*if(bid.Phoenix_Bid_Type__c== 'Volume Review Only'){
dynamicSubject = 'Volume Review of Bid Line Items in '+bid.Phoenix_Bid_Type__c+' - '+bid.Name+' - '+bid.Phoenix_Customer__r.Name;
dynamicTitle = 'Volume Review';
content1 = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;"><b>Bid Details:</b></td></tr></table>';
content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';    
content1 += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></th></tr>';
content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Name__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Type__c+'</td></tr><tr><th style="width: 34px;"></th></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+bid.Owner.Name+'</td></tr>';
content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Approval_Status__c+'</td></tr>';
content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Internal Deadline</th>';
if (internalDueDateTime != null) {
content1 += '<td style="border: 1px solid black;padding: 8px;">'+internalDueDateTime.format('MMM d yyyy')+'</td></tr>';
} else{
content1 += '<td style="border: 1px solid black;"></td></tr></thead></table><br/>';
}
content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;"><b>Bid Comments:</b></td></tr></table>';
content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+bid.Owner.Name+' ('+createdDate+'): ';
if(bid.Phoenix_Comments__c != null)	content1 += bidComments+'</td></tr></table>';
else content1 += '</td></tr></table>';
content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To view this item, refer to the link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></b>.</td></tr></table>';

}*/
                    if ((bid.Phoenix_Bid_Type__c =='Product Discontinuation Process'||bid.Phoenix_Bid_Type__c=='Mass Product Removals') && (step.Phoenix_Approver_Team__c.contains('Marketing') || step.Phoenix_Approver_Team__c.contains('Marketing Lead') || step_name == 'Marketing Approval')){
                        //list < Phoenix_Bid_Line_Item__c > lineitems = [select id,Phoenix_Product__c,Phoenix_NDC__c,Phoenix_Product__r.Name,Phoenix_Product_Family__c,Phoenix_Product_Director__c,Phoenix_Product__r.Phoenix_Product_Director__r.Name,Phoenix_Customer__r.Name,Phoenix_Contract__r.Name,Phoenix_Customer__r.owner.name, Phoenix_Final_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: objId ];
                        list < Phoenix_Bid_Line_Item__c> lineitems = lineItemsByDirectorMap.get(step.Phoenix_Approver__c);
                        if(step_name == 'Marketing Approval'){
                        emailsforProductDisc_MasPrdctRemoval.sendEmailToAllApproversforProductDiscontinuation(objId,lineitems,approverName,new List<String> (toAddress),new List<String> (ccEmailIds));
                        }
                       
                        
                    }
                    else if (bid.Phoenix_Bid_Type__c !='Product Discontinuation Process' && bid.Phoenix_Bid_Type__c!='Mass Product Removals' && bid.Phoenix_Bid_Type__c!='Platform OTB' && step.Phoenix_Approver_Team__c == 'Marketing' && templateBody.contains('Product_Families') && step.Phoenix_Approver__c != null) {
                        //bid.Phoenix_Bid_Type__c
                        prodFamilyString = '';
                        dynamicSubject = 'Your Approval Required for '+bidTypesmap.get(bid.Phoenix_Bid_Type__c)+' - '+bid.Name+' - '+bid.Phoenix_Customer__r.Name;
                        dynamicTitle = 'Product Pricing Input/ Approval Request';
                        content1 = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 0px 8px;">Dear '+approverName+',</td></tr></table>';
                        content1 += '<table><tr><td style="width: 24px;"></td><td style="padding: 4px 8px 4px 8px;"><span style ="font-size: 14px;font-family: Sans-Serif;">'+bid.Owner.Name+' requires your approval to incorporate '+lineItemsByDirectorMap.get(step.Phoenix_Approver__c).size()+' products into the recently submitted '+bid.Phoenix_Bid_Type__c+' Bid. You\'ve been included in this Bid as the recognized Marketing Director for the Products mentioned below.</span> </td></tr></table>';
                        prodFamilyString = '';
                        prodFamilyString += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"><thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;min-width: 40px;">S No.</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Director</th>';
                        prodFamilyString += '<tbody>';
                        integer i=1;
                        for (Phoenix_Bid_Line_Item__c lineItem: lineItemsByDirectorMap.get(step.Phoenix_Approver__c)) {
                            prodFamilyString += '<tr><td style="width: 26px;"></td><td style="border: 1px solid black;text-align:center;;padding:8px;">'+i+'</td><td style="border: 1px solid black;text-align:left;padding:8px;">'+lineItem.Phoenix_Product__r.Name+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Product__r.Phoenix_Product_Director__r.Name+'</td></tr>';
                            i++;
                        }
                        prodFamilyString += '</tbody></table>';
                        
                        content1 += '<table align="center" style="background-color:#d4bdf8;border-radius: 15px;padding:20px;font-size: 18px;font-family: Sans-Serif;"><tr><th>'+lineItemsByDirectorMap.get(step.Phoenix_Approver__c).size()+' Product(s) Need Price Approval</b></th></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;"><b>Bid Details:</b></td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';    
                        content1 += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></th></tr>';
                        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Name__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Type__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Customer__r.Name+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+bid.Owner.Name+'</td></tr>';
                        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Salesperson</th><td style="border: 1px solid black;padding: 8px;">'+salesPersonName+'</td></tr>';
                        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Approval_Status__c+'</td></tr>';
                        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Internal Deadline</th>';
                        if (internalDueDateTime != null) {
                            content1 += '<td style="border: 1px solid black;padding: 8px;">'+internalDueDateTime.format('MMM d yyyy')+'</td></tr>';
                        } else{
                            content1 += '<td style="border: 1px solid black;"></td></tr></thead></table><br/>';
                        }
                        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Bid Deadline</th>';
                        if (customerBidDeadline != null) {
                            content1 += '<td style="border: 1px solid black;padding: 8px;">'+customerBidDeadline.format('MMM d yyyy')+'</td></tr></thead></table>';   
                        } else{
                            content1 += '<td style="border: 1px solid black;"></td></tr></thead></table>';
                        }
                        content1 += '</td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;"><b>Bid Comments:</b></td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+bid.Owner.Name+' ('+createdDate+'): ';
                        if(bid.Phoenix_Comments__c != null)	content1 += bidComments+'</td></tr></table>';
                        else content1 += '</td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>Product Details:</b></td></tr></table>';
                        content1 += prodFamilyString;
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To approve, modify or reject the bid line items, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></b>.</td></tr></table>';
                    } 
                    else if (bid.Phoenix_Bid_Type__c!='Product Discontinuation Process' && bid.Phoenix_Bid_Type__c!='Mass Product Removals' && step.Phoenix_Approver_Team__c.contains('Marketing Lead') && templateBody.contains('Product_Families') && step.Phoenix_Approver__c != null) {
                        prodFamilyString = '';
                        integer i = 1;
                        if(step.Phoenix_Approver__c!=null){
                            //bid.Phoenix_Bid_Type__c
                            dynamicSubject = 'Your Approval Required for '+bidTypesmap.get(bid.Phoenix_Bid_Type__c)+' - '+bid.Name+' - '+bid.Phoenix_Customer__r.Name;
                            dynamicTitle = 'Management Approval Request (Deviation)';
                            content1 = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 0px 8px;">Dear '+approverName+',</td></tr></table>';
                            content1 += '<table><tr><td style="width: 24px;"></td><td style="padding: 4px 8px 8px 8px;"><span style="font-size: 14px;font-family: Sans-Serif">'+bid.Owner.Name+' requires your attention to the '+bid.Phoenix_Bid_Type__c+' Bid as one or more of the products listed below have deviation(s). Below are the deviation(s) mentioned and you are requested to provide your approval / rejection.</span> </td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:0px 8px 8px 8px;"><b>Deviation(s):</b></td></tr></table>';
                            if(bid.Phoenix_Bid_Type__c == 'Price Change' || bid.Phoenix_Bid_Type__c == 'OTC Price Change' || bid.Phoenix_Bid_Type__c == 'Customer Rebate Change' ||bid.Phoenix_Bid_Type__c == 'OTC Rebate Change' || bid.Phoenix_Bid_Type__c == 'RFP Bids' || bid.Phoenix_Bid_Type__c == 'OTC RFP'){
                                content1 += pricechangedeviationTable;
                            }else{
                                content1 += deviationTable;
                            }
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;"><b>Bid Details:</b></td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';                            
                            content1 += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></a></th></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Name__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Type__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Customer__r.Name+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+bid.Owner.Name+'</td></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Salesperson</th><td style="border: 1px solid black;padding: 8px;">'+salesPersonName+'</td></tr>';
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
                            String created_Date = Phoenix_Util.getUserTimeNow(bid.CreatedDate,'America/New_York');
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;"><b>Bid Comments:</b></td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+bid.Owner.Name+' ('+createdDate+'): ';
                            if(bid.Phoenix_Comments__c != null)	content1 += bidComments+'</td></tr></table>';
                            else content1 += '</td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>Additional Details:</b></td></tr></table>';
                            content1 += additionTable;
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;"><b>For Approval / Rejection through email, reply to this email with:</b></td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 0px 8px;"><b>To Approve: </b>"APPROVE" or "APPROVED" or "YES".</td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 8px;"><b>To Reject: </b>"REJECT" or "REJECTED" or "NO".</td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 0px 8px;"><b>For Approval / Rejection on BRIGHT:</b></td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 8px;">Refer to the link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a>.</b></td></tr></table>';
                            isFooterTextAlterRequired = true;
                        }
                    } 
                    else if (step.Phoenix_Approver_Team__c.contains('Marketing Head') && templateBody.contains('Product_Families') && step.Phoenix_Approver__c != null) {
                        prodFamilyString = '';
                        integer i = 1;
                        if(step.Phoenix_Approver__c!=null){
                            //bid.Phoenix_Bid_Type__c
                            dynamicSubject = 'Your Approval Required for Deviation in '+bidTypesmap.get(bid.Phoenix_Bid_Type__c)+' - '+bid.Name+' - '+bid.Phoenix_Customer__r.Name;
                            dynamicTitle = 'Management Approval Request (Deviation)';
                            //content1 = '<div style="color: black; margin: 20px 0px -10px 0px;padding:20px 40px 10px 40px;background-color: white;">Dear '+approverName+',<br /><br />';
                            //content1 += bid.Owner.Name+' requires your attention to the '+bid.Phoenix_Bid_Type__c+' Bid as one or more of the products listed below have deviation(s). Below are the deviation(s) mentioned and you are requested to provide your approval / rejection.<br/><br/>';
                            
                            content1 = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style=" padding:12px 8px 0px 8px;">Dear '+approverName+',</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;"><span style="font-size: 14px;font-family: Sans-Serif;">'+bid.Owner.Name+' requires your attention to the '+bid.Phoenix_Bid_Type__c+' Bid as one or more of the products listed below have deviation(s). Below are the deviation(s) mentioned and you are requested to provide your approval / rejection.</span> </td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:0px 8px 8px 8px"><b>Deviation(s):</b></td></tr></table>';
                            if(bid.Phoenix_Bid_Type__c == 'Price Change'){
                                content1 += pricechangedeviationTable;
                                donotSend  =false;
                                 isFooterTextAlterRequired = true;
                            }else{
                                content1 += deviationTable;
                                isFooterTextAlterRequired = true;
                            }
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:8px;"><b>Bid Details:</b></td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';                            
                            content1 += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></a></th></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Name__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Type__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Customer__r.Name+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+bid.Owner.Name+'</td></tr>';
                            content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Salesperson</th><td style="border: 1px solid black;padding: 8px;">'+salesPersonName+'</td></tr>';
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
                            String created_Date = Phoenix_Util.getUserTimeNow(bid.CreatedDate,'America/New_York');
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;"><b>Bid Comments:</b></td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+bid.Owner.Name+' ('+createdDate+'): ';
                            if(bid.Phoenix_Comments__c != null)	content1 += bidComments+'</td></tr></table>';
                            else content1 += '</td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>Additional Details:</b></td></tr></table>';
                            content1 += marketingHeadAdditionTable;
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;"><b>For Approval / Rejection through email, reply to this email with:</b></td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 0px 8px;"><b>To Approve: </b>"APPROVE" or "APPROVED" or "YES".</td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 8px;"><b>To Reject: </b>"REJECT" or "REJECTED" or "NO".</td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 0px 8px;"><b>For Approval / Rejection on BRIGHT:</b></td></tr></table>';
                            content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 8px;">Refer to the link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a>.</b></td></tr></table>';
                            
                        }
                    }
                    
                    else if (bid.Phoenix_Bid_Type__c !='Product Discontinuation Process' && bid.Phoenix_Bid_Type__c!='Mass Product Removals' && step.Phoenix_Approver_Team__c == 'Finance' && templateBody.contains('Product_Families')) {
                       	//bid.Phoenix_Bid_Type__c
                        dynamicSubject = 'Your Approval Required for '+bidTypesmap.get(bid.Phoenix_Bid_Type__c)+' - '+bid.Name+' - '+bid.Phoenix_Customer__r.Name;
                        dynamicTitle = bidTypesmap.get(bid.Phoenix_Bid_Type__c)+' Bid Approval Request';
                        
                        content1 = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 0px 8px;">Dear Finance Team,</td></tr></table>';
                        content1 += '<table><tr><td style="width: 24px;"></td><td style="padding: 4px 8px 8px 8px;"><span style="font-size: 14px;font-family: Sans-Serif">'+bid.Owner.Name+' has recently submitted '+bid.Phoenix_Bid_Type__c+' Bid for your approval. </span></td></tr></table>';
                        
                        string tableCount = '';
                        tableCount += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"><thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;min-width: 40px;">S No.</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Director</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Supply Chain Planner</th>';
                        tableCount += '<tbody>';
                        
                        integer i = 1; integer productCount = 0;
                        for (String pfamilyList: lineItemsByDirectorMap.keySet()) {
                            productsCount = lineItemsByDirectorMap.get(pfamilyList).size();
                            for (Phoenix_Bid_Line_Item__c lineItem: lineItemsByDirectorMap.get(pfamilyList)) {
                                tableCount += '<tr><td style="width: 26px;"></td><td style="border: 1px solid black;text-align:center;padding:8px;">'+i+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Product__r.Name+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Product__r.Phoenix_Product_Director__r.Name+'</td>';
                                if(lineItem.Phoenix_Supply_Chain_Planner__r.Name != null) tableCount += '<td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Supply_Chain_Planner__r.Name+'</td></tr>';
                                else tableCount += '<td style="border: 1px solid black;text-align:left;;padding:4px 8px;"></td></tr>';
                                //content1 += '<tr><td style="border: 1px solid black;text-align:center;;padding:4px;">'+i+'</td><td style="border: 1px solid black;text-align:center;;padding:4px;">'+lineItem.Phoenix_Product__r.Name+'</td><td style="border: 1px solid black;text-align:center;padding:4px;">'+lineItem.Phoenix_Product__r.Phoenix_Product_Director__r.Name+'</td><td style="border: 1px solid black;text-align:center;padding:4px;">'+lineItem.Phoenix_Supply_Chain_Planner__r.Name+'</td></tr>';
                                //prodFamilyString += i + '.' + pfamily + '<br/>';
                                i++;
                                productCount++;
                            }
                            
                        }
                        tableCount += '</tbody></table>';
                        content1 += '<table align="center" style="background-color:#d4bdf8;border-radius: 15px;padding:20px;font-size: 18px;font-family: Sans-Serif;"><tr><th>'+productCount+' Product(s)</b></th></tr></table>';
                        //content1 += '<div style="color: black; margin: 20px 0px -10px 0px;padding:10px 40px 10px 0px;background-color: white;"><div style="margin: auto;border-radius: 15px;min-width: 200px;max-width: 250px;text-align: center;padding: 20px;background-color: #d4bdf8;"><span style="background-color: #d4bdf8;"><b>'+lineItemsByDirectorMap.keySet().size()+' Product Families</b></span></div><br/>';
                        
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;"><b>Bid Details:</b></td></tr></table>';
                        
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';                            
                        content1 += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></a></th></tr>';
                        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Name__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Type__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Customer__r.Name+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+bid.Owner.Name+'</td></tr>';
                        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Salesperson</th><td style="border: 1px solid black;padding: 8px;">'+salesPersonName+'</td></tr>';
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
                        String created_Date = Phoenix_Util.getUserTimeNow(bid.CreatedDate,'America/New_York');
                        
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;"><b>Bid Comments:</b></td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+bid.Owner.Name+' ('+createdDate+'): ';
                        if(bid.Phoenix_Comments__c != null)	content1 += bidComments+'</td></tr></table>';
                        else content1 += '</td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>Product Details:</b></td></tr></table>';
                        content1 += tableCount;
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To approve, modify or reject the bid line items, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a>.</b></td></tr></table>';
                        
                        // content1 += '<br/>To approve, modify or reject the bid line items, refer to this link <a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a>.<br/><br/>';
                    }
                    else if (step.Phoenix_Approver_Team__c == 'Sr Director or VP Finance' && templateBody.contains('Product_Families')) {
                        //bid.Phoenix_Bid_Type__c
                        dynamicSubject = 'Your Approval Required for Deviation in '+bidTypesmap.get(bid.Phoenix_Bid_Type__c)+' - '+bid.Name+' - '+bid.Phoenix_Customer__r.Name;
                        dynamicTitle = bidTypesmap.get(bid.Phoenix_Bid_Type__c)+' Bid Approval Request (Deviation)';
                        //content1 = '<div style="color: black; margin: 20px 0px -10px 0px;padding:20px 40px 10px 40px;background-color: white;">Dear '+approverName+',<br /><br />';
                        //content1 += bid.Owner.Name+' requires your attention to the '+bid.Phoenix_Bid_Type__c+' Bid as one or more of the products listed below have deviation(s). Below are the deviation(s) mentioned and you are requested to provide your approval / rejection.<br/><br/>';                            
                        content1 = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 0px 8px;">Dear Finance Team,</td></tr></table>';
                        content1 += '<table><tr><td style="width: 24px;"></td><td style="padding: 4px 8px 8px 8px;"><span style="font-size: 14px;font-family: Sans-Serif">'+bid.Owner.Name+' requires your attention to the '+bid.Phoenix_Bid_Type__c+' Bid as one or more of the products listed below have deviation(s). Below are the deviation(s) mentioned and you are requested to provide your approval / rejection.</span></td></tr></table>';
                        
                        //content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;">Dear Team'+',</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">'+bid.Owner.Name+' has recently submitted '+bid.Phoenix_Bid_Type__c+' Bid for your approval. </td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 8px;"><b>Deviation(s):</b></td></tr></table>';
                        if(bid.Phoenix_Bid_Type__c == 'Price Change'){
                            content1 += priceChangeSrVPFinanceTable;
                        }else{
                            content1 += SrVPFinanceTable;
                            donotSend  = true;
                        }
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;"><b>Bid Details:</b></td></tr></table>';
                        //content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;"><b>Bid Details:</b></td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';                            
                        content1 += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></a></th></tr>';
                        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Name__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Type__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Customer__r.Name+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+bid.Owner.Name+'</td></tr>';
                        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Salesperson</th><td style="border: 1px solid black;padding: 8px;">'+salesPersonName+'</td></tr>';
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
                        String created_Date = Phoenix_Util.getUserTimeNow(bid.CreatedDate,'America/New_York');
                        
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;"><b>Bid Comments:</b></td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+bid.Owner.Name+' ('+createdDate+'): ';
                        if(bid.Phoenix_Comments__c != null)	content1 += bidComments+'</td></tr></table>';
                        else content1 += '</td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;"><b>Additional Details:</b></td></tr></table>';
                        content1 += SrVPFinanceAdditionTable;
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;"><b>For Approval / Rejection through email, reply to this email with:</b></td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 0px 8px;"><b>To Approve: </b>"APPROVE" or "APPROVED" or "YES".</td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 8px;"><b>To Reject: </b>"REJECT" or "REJECTED" or "NO".</td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 0px 8px;"><b>For Approval / Rejection on BRIGHT:</b></td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 8px;">Refer to the link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a>.</b></td></tr></table>';
                        isFooterTextAlterRequired = true;
                    }
                    //bid.Phoenix_Bid_Type__c != 'Volume Review Only' &&
                    else if ( step.Phoenix_Approver_Team__c == 'Supply Chain' &&templateBody.contains('Product_Families')) {
                        //bid.Phoenix_Bid_Type__c
                        dynamicSubject = 'Your Approval Required for '+bidTypesmap.get(bid.Phoenix_Bid_Type__c)+' - '+bid.Name+' - '+bid.Phoenix_Customer__r.Name;
                        dynamicTitle = 'Volume Approval Request';
                        content1 = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 0px 8px;">Dear '+approverName+',</td></tr></table>';
                        content1 += '<table><tr><td style="width: 24px;"></td><td style="padding: 4px 8px 8px 8px;"><span style="font-size: 14px;font-family: Sans-Serif">'+bid.Owner.Name+' requires your approval to incorporate '+bidItems.size()+' products into the recently submitted '+bid.Phoenix_Bid_Type__c+' Bid. You\'ve been included in this Bid as the recognized Supply Chain Planner for the Products mentioned below.</span> </td></tr></table>';
                        //content1 += bid.Owner.Name+' requires your approval to incorporate '+bidItems.size()+' products into the recently submitted '+bid.Phoenix_Bid_Type__c+' Bid. You\'ve been included in this Bid as the recognized Supply Chain Planner for the Products mentioned below.';
                        prodFamilyString = '';
                        prodFamilyString += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"><thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;min-width: 40px;">S No.</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Director</th>';
                        prodFamilyString += '<tbody>';
                        
                        integer i = 1;
                        for (Phoenix_Bid_Line_Item__c lineItem: bidItems) {
                            prodFamilyString += '<tr><td style="width: 26px;"></td><td style="border: 1px solid black;text-align:center;padding:8px;">'+i+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Product__r.Name+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Product__r.Phoenix_Product_Director__r.Name+'</td></tr>';
                            //prodFamilyString += i + '.' + pfamily + '<br/>';
                            i++;
                        }
                        prodFamilyString += '</tbody></table>';
                        content1 += '<table align="center" style="background-color:#d4bdf8;border-radius: 15px;padding:20px;font-size: 18px;font-family: Sans-Serif;"><tr><th>'+bidItems.size()+' Product(s) Need Volume Approval</b></th></tr></table>';
                        //content1 += '<div style="color: black; margin: 20px 0px -10px 0px;padding:10px 40px 10px 0px;background-color: white;"><div style="margin: auto;border-radius: 15px;min-width:200px;max-width: 250px;text-align: center;padding: 20px;background-color: #d4bdf8;"><span style="background-color: #d4bdf8;"><b>'+productsCount+' Product(s) Need Volume Approval</b></span></div><br/>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;"><b>Bid Details:</b></td></tr></table>';
                        //content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;"><b>Bid Details:</b></td></tr></table>';
                        
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';                            
                        content1 += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></a></th></tr>';
                        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Name__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Type__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Customer__r.Name+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+bid.Owner.Name+'</td></tr>';
                        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Salesperson</th><td style="border: 1px solid black;padding: 8px;">'+salesPersonName+'</td></tr>';
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
                        
                        //datetime created_Date = bid.LastModifiedDate;
                        //String created_Date =(bid.CreatedDate).format('MM/dd/yyyy HH:mm:ssZ', 'EST');
                        
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;"><b>Bid Comments:</b></td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+bid.Owner.Name+' ('+createdDate+'): ';
                        if(bid.Phoenix_Comments__c != null)	content1 += bidComments+'</td></tr></table>';
                        else content1 += '</td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>Product Details:</b></td></tr></table>';
                        content1 += prodFamilyString;
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To approve, modify or reject the bid line items, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></b>.</td></tr>';
                        content1 += '</table>';
                    }
                    else if (bid.Phoenix_Bid_Type__c !='Product Discontinuation Process' && bid.Phoenix_Bid_Type__c!='Mass Product Removals' && step.Phoenix_Approver_Team__c == 'Contracts' &&templateBody.contains('Product_Families') && step_name != 'Customer\'s Update') {
                        String scmapprover,financeApprover;
                        String stepname='';
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
                        //bid.Phoenix_Bid_Type__c
                        dynamicSubject = 'Your Action Required: Customer Proposal Request for '+bidTypesmap.get(bid.Phoenix_Bid_Type__c)+' - '+bid.Name+' - '+bid.Phoenix_Customer__r.Name;
                        dynamicTitle = bidTypesmap.get(bid.Phoenix_Bid_Type__c)+' Bid Customer Proposal';
                        content1 = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear '+approverName+',</td></tr></table>';
                        content1 += '<table><tr><td style="width: 24px;"></td><td style="padding: 4px 8px 8px 8px;"><span style"font-size: 14px;font-family: Sans-Serif;>'+bid.Owner.Name+' submitted a '+bid.Phoenix_Bid_Type__c+' Bid which has completed the bid approval workflow. Below are the details of the bid for your review and further processing. You will now be able to generate a Proposal for submission to the Customer.</span> </td></tr></table>';
                        prodFamilyString = '';
                        prodFamilyString += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"><thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;min-width: 40px;">S No.</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Director</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Supply Chain Planner</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Finance</th>';
                        prodFamilyString += '<tbody>';
                        integer i = 1;
                        for (Phoenix_Bid_Line_Item__c lineItem: bidItems) {
                            prodFamilyString += '<tr><td style="width: 26px;"></td><td style="border: 1px solid black;text-align:center;padding:8px;">'+i+'</td>';
                            prodFamilyString += '<td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Product__r.Name+'</td>';
                            prodFamilyString += '<td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Product__r.Phoenix_Product_Director__r.Name+'</td>';
                            if(bid.Phoenix_Bid_Type__c == 'Platform OTB' || bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch'){
                               String scmPlanner = lineItem.Phoenix_Supply_Chain_Planner__r.Name != null ? lineItem.Phoenix_Supply_Chain_Planner__r.Name :  '';
                               prodFamilyString += '<td style="border: 1px solid black;text-align:left;;padding:8px;">'+scmPlanner+'</td>';
                            }else{
                             	if(scmapprover != null) prodFamilyString += '<td style="border: 1px solid black;text-align:left;;padding:8px;">'+scmapprover+'</td>';
                            	else prodFamilyString += '<td style="border: 1px solid black;text-align:left;;padding:8px;"></td>';

                            }
                            prodFamilyString += '<td style="border: 1px solid black;text-align:left;;padding:8px;">'+financeApprover+'</td></tr>';
                            //prodFamilyString += i + '.' + pfamily + '<br/>';
                            i++;
                        }
                        prodFamilyString += '</tbody></table>';
                        content1 += '<table align="center" style="background-color:#d4bdf8;border-radius: 15px;padding:20px;font-size: 18px;font-family: Sans-Serif;"><tr><th>'+bidItems.size()+' Products Approved</b></th></tr></table>';
                        //content1 += '<div style="color: black; margin: 20px 0px -10px 0px;padding:10px 40px 10px 0px;background-color: white;"><div style="margin: auto;border-radius: 15px;min-width:200px;max-width: 250px;text-align: center;padding: 20px;background-color: #d4bdf8;"><span style="background-color: #d4bdf8;"><b>'+productsCount+' Product(s) Need Volume Approval</b></span></div><br/>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px;"><b>Bid Details:</b></td></tr></table>';
                        
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';                            
                        content1 += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></a></th></tr>';
                        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Name__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Type__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Customer__r.Name+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+bid.Owner.Name+'</td></tr>';
                        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Salesperson</th><td style="border: 1px solid black;padding: 8px;">'+salesPersonName+'</td></tr>';
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
                        
                        //datetime created_Date = bid.LastModifiedDate;
                        //String created_Date =(bid.CreatedDate).format('MM/dd/yyyy HH:mm:ssZ', 'EST');
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;"><b>Bid Comments:</b></td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+bid.Owner.Name+' ('+createdDate+'): ';
                        if(bid.Phoenix_Comments__c != null)	content1 += bidComments+'</td></tr></table>';
                        else content1 += '</td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>Product Details:</b></td></tr></table>';
                        content1 += prodFamilyString;
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To approve, modify or reject the bid line items, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></b>.</td></tr>';
                        content1 += '</table>';
                    }
                    else if(step_name == 'Customer\'s Update' && templateBody.contains('Product_Families')){
                        String scmapprover,financeApprover;
                        String stepname='';
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
                        //bid.Phoenix_Bid_Type__c
                        dynamicSubject = 'Your Update Required for '+bidTypesmap.get(bid.Phoenix_Bid_Type__c)+' - '+bid.Name+' - '+bid.Phoenix_Customer__r.Name;
                        dynamicTitle = 'Customer Response Reminder';
                        content1 = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 0px 8px;">Dear '+approverName+',</td></tr></table>';
                        content1 += '<table><tr><td style="width: 24px;"></td><td style="padding: 4px 8px 8px 8px;">'+'<span style = "font-size: 14px;font-family: Sans-Serif;">We want to remind you that the bid is expecting an update of the customer response, please make sure to input this information in the bid.</span></td></tr></table>';
                        prodFamilyString = '';
                        prodFamilyString += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"><thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;min-width: 40px;">S No.</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Director</th><th style="border: 1px solid black;padding: 8px;text-align:left;background-color:#d4bdf8;">Supply Chain Planner</th>';//<th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Finance</th>
                        prodFamilyString += '<tbody>';
                        integer i = 1;
                        for (Phoenix_Bid_Line_Item__c lineItem: bidItems) {
                            if(bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch'){
                            	String supplychainPlanner = lineItem.Phoenix_Supply_Chain_Planner__r.Name != null ? lineItem.Phoenix_Supply_Chain_Planner__r.Name : '';
                                prodFamilyString += '<tr><td style="width: 26px;"></td><td style="border: 1px solid black;text-align:center;padding:8px;">'+i+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Product__r.Name+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Product__r.Phoenix_Product_Director__r.Name+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+supplychainPlanner+'</td></tr>'; //<td style="border: 1px solid black;text-align:left;;padding:8px;">'+financeApprover+'</td>
                            }else{
                          		prodFamilyString += '<tr><td style="width: 26px;"></td><td style="border: 1px solid black;text-align:center;padding:8px;">'+i+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Product__r.Name+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Product__r.Phoenix_Product_Director__r.Name+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+scmapprover+'</td></tr>'; //<td style="border: 1px solid black;text-align:left;;padding:8px;">'+financeApprover+'</td>
      
                            }
                            i++;
                        }
                        prodFamilyString += '</tbody></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 8px;"><b>Bid Details:</b></td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';                            
                        content1 += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></a></th></tr>';
                        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Name__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Type__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Customer__r.Name+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+bid.Owner.Name+'</td></tr>';
                        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Salesperson</th><td style="border: 1px solid black;padding: 8px;">'+salesPersonName+'</td></tr>';
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
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 4px 8px;"><b>Bid Comments:</b></td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+bid.Owner.Name+' ('+createdDate+'): ';
                        if(bid.Phoenix_Comments__c != null)	content1 += bidComments+'</td></tr></table>';
                        else content1 += '</td></tr></table>';
                        content1 += '</table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>Product Details:</b></td></tr></table>';
                        content1 += prodFamilyString;
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To review the bid line items, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></b>.</td></tr>';
                        content1 += '</table>';
                    }
                    else if(bid.Phoenix_Bid_Type__c !='Product Discontinuation Process' && bid.Phoenix_Bid_Type__c!='Mass Product Removals' && step_name == 'Vistex Update' && templateBody.contains('Product_Families')){
                       //bid.Phoenix_Bid_Type__c
                        dynamicSubject = 'Your Update Required for '+bidTypesmap.get(bid.Phoenix_Bid_Type__c)+' - '+bid.Name+' - '+bid.Phoenix_Customer__r.Name;
                        dynamicTitle = 'VISTEX Update Request';
                        content1 = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 26px;"></td><td style="padding: 12px 8px 0px 8px;">Dear VISTEX Team,</td></tr></table>';
                        content1 += '<table><tr><td style="width: 26px;"></td><td style="padding: 4px 8px 8px 8px;">'+'<span style="font-size: 14px;font-family: Sans-Serif;" >We want to inform you that the customer’s update by the Contracts Team on BRIGHT is completed. Please make sure the customer response(s) are updated in VISTEX.</span></td></tr></table>';
                        prodFamilyString = '';
                        prodFamilyString += '<table style="border-collapse: collapse;font-family: Sans-Serif;font-size: 14px;"><thead style="background-color:#d4bdf8"><tr><th style="width: 36px;background-color:white;"></th><th style="border: 1px solid black;padding:8px;text-align:center;background-color:#d4bdf8;min-width: 40px;">S No.</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product</th><th style="border: 1px solid black;padding:8px;text-align:left;background-color:#d4bdf8;">Product Director</th>';
                        prodFamilyString += '<tbody>';
                        integer i = 1;
                        for (Phoenix_Bid_Line_Item__c lineItem: bidItems) {
                            prodFamilyString += '<tr><td style="width: 26px;"></td><td style="border: 1px solid black;text-align:center;padding:8px;">'+i+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Product__r.Name+'</td><td style="border: 1px solid black;text-align:left;;padding:8px;">'+lineItem.Phoenix_Product__r.Phoenix_Product_Director__r.Name+'</td></tr>';
                            //prodFamilyString += i + '.' + pfamily + '<br/>';
                            i++;
                        }
                        prodFamilyString += '</tbody></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 8px 8px 10px;"><b>Bid Details:</b></td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td>';                            
                        content1 += '<table style="border-collapse: collapse;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></a></th></tr>';
                        content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Name__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Type__c+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Customer__r.Name+'</td></tr><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Approval_Status__c+'</td></tr><tr><th style="width: 34px;"></th></tr>';
                        //content1 += '<tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Approval_Status__c+'</td></tr>';
                        
                        content1 += '</td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 26px;"></td><td style="padding: 8px 8px 4px 6px;"><b>Bid Comments:</b></td></tr></table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 0px 0px 0px 8px;">'+bid.Owner.Name+' ('+createdDate+'): ';
                        if(bid.Phoenix_Comments__c != null)	content1 += bidComments+'</td></tr></table>';
                        else content1 += '</td></tr></table>';
                        content1 += '</table>';
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>Product Details:</b></td></tr></table>';
                        content1 += prodFamilyString;
                        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To view the bid line items, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></b>.</td></tr>';
                        content1 += '</table>';
                    }
                  /*  else if (templateBody.contains('Product_Families' )) {
                        dynamicSubject = 'Your Approval Required for '+bid.Phoenix_Bid_Type__c+' - '+bid.Name+' - '+bid.Phoenix_Customer__r.Name;
                        dynamicTitle = 'Volume Approval Request';
                        content1 = '<div style="color: black; margin: 20px 0px -10px 0px;padding:20px 40px 10px 40px;background-color: white;font-family: Sans-Serif;">Dear '+approverName+',<br /><br />';
                        content1 += bid.Owner.Name+' requires your approval to incorporate '+bidItems.size()+' products into the recently submitted '+bid.Phoenix_Bid_Type__c+' Bid. You\'ve been included in this Bid as the recognized Supply Chain Planner for the Products mentioned below.';
                        prodFamilyString = '';
                        prodFamilyString += '<table style="border-collapse: collapse;font-family: Sans-Serif;"><thead style="background-color:#d4bdf8"><tr><th style="border: 1px solid black;padding:4px 8px;text-align:center;background-color:#d4bdf8;min-width: 40px;">S No.</th><th style="border: 1px solid black;padding:4px 8px;text-align:center;background-color:#d4bdf8;">Product</th><th style="border: 1px solid black;padding:4px 8px;text-align:center;background-color:#d4bdf8;">Product Director</th>';
                        prodFamilyString += '<tbody>';
                        
                        integer i = 1;
                        for (String pfamilyList: lineItemsByDirectorMap.keySet()) {
                            productsCount = lineItemsByDirectorMap.get(pfamilyList).size();
                            for (Phoenix_Bid_Line_Item__c lineItem: lineItemsByDirectorMap.get(pfamilyList)) {
                                prodFamilyString += '<tr><td style="border: 1px solid black;text-align:center;;padding:4px;">'+i+'</td><td style="border: 1px solid black;text-align:center;;padding:4px;">'+lineItem.Phoenix_Product__r.Name+'</td><td style="border: 1px solid black;text-align:center;;padding:4px;">'+lineItem.Phoenix_Product__r.Phoenix_Product_Director__r.Name+'</td></tr>';
                                //prodFamilyString += i + '.' + pfamily + '<br/>';
                                i++;
                            }
                        }
                        prodFamilyString += '</tbody></table><br/>';
                        content1 += '<table align="center" style="background-color:#d4bdf8;border-radius: 15px;margin-top: 8px;padding:20px;font-size: 18px;font-family: Sans-Serif;"><tr><th>'+productsCount+' Product(s) Need Volume Approval</b></th></tr></table>';
                        content1 += '<b style="font-family: Sans-Serif;">Bid Details:</b><br/><br/>';
                        content1 += '<table style="border-collapse: collapse;width:50%;font-family: Sans-Serif;"><thead><tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Number</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></a></th></tr>';
                        content1 += '<tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Name__c+'</td></tr><tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Type</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Bid_Type__c+'</td></tr><tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Name</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Customer__r.Name+'</td></tr><tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Bid Initiator</th><td style="border: 1px solid black;padding: 8px;">'+bid.Owner.Name+'</td></tr>';
                        content1 += '<tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Salesperson</th><td style="border: 1px solid black;padding: 8px;">'+salesPersonName+'</td></tr>';
                        content1 += '<tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+bid.Phoenix_Approval_Status__c+'</td></tr>';
                        content1 += '<tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Internal Deadline</th>';
                        if (internalDueDateTime != null) {
                            content1 += '<td style="border: 1px solid black;padding: 8px;">'+internalDueDateTime.format('MMM d yyyy')+'</td></tr>';
                        } else{
                            content1 += '<td style="border: 1px solid black;"></td></tr></thead></table><br/>';
                        }
                        content1 += '<tr><th style="border: 1px solid black;padding:4px 8px;width:50%;text-align:left;background-color:#d4bdf8;padding: 8px;">Customer Bid Deadline</th>';
                        if (customerBidDeadline != null) {
                            content1 += '<td style="border: 1px solid black;padding: 8px;">'+customerBidDeadline.format('MMM d yyyy')+'</td></tr></thead></table>';   
                        } else{
                            content1 += '<td style="border: 1px solid black;"></td></tr></thead></table>';
                        }
                        if(bid.Phoenix_Comments__c != null)	content1 += '<div><div style="font-family: Sans-Serif;"><b>Bid Comments: </b></div><div style="font-family:Sans-Serif; font-size:14px !important;">'+bidComments+'</div></div></br>';   
                        else content1 += '<div><div style="font-family: Sans-Serif;"><b>Bid Comments: </b></div><div style="font-family:Sans-Serif; font-size:16px;"></div></div></br>';
                        content1 += '<b style="font-family: Sans-Serif;">Product Details:</b><br/><br/>';
                        content1 += prodFamilyString;
                        content1 += '<span style="font-family: Sans-Serif;">To approve, modify or reject the bid line items, refer to this link <a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a></span>.<br/><br/>';
                    }
                    */
                    if (step.Phoenix_Is_Criteria_Step__c == false && templateBody.contains('Product_Families')) templateBody = templateBody.replace('Product_Families', content1); 
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
                    if (bidTypesmap!=null&&bidTypesmap.get(bid.Phoenix_Bid_Type__c)!=null&&subject1.contains('BID_TYPE')) subject1 = subject1.replace('BID_TYPE', bidTypesmap.get(bid.Phoenix_Bid_Type__c));
                }
                //bidtype label names --end.
                
                if (objName == 'Phoenix_Bid__c' && bid.Phoenix_Internal_Target_Date__c != null) {
                    internalDueDateTime = DateTime.newInstance(bid.Phoenix_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0));
                    if (templateBody.contains('INTERNAL_DEADLINE_DATE')) templateBody = templateBody.replace('INTERNAL_DEADLINE_DATE', internalDueDateTime.format('MMM d yyyy'));
                }
                
                
                if (objName == 'Phoenix_Bid__c' && bid.Phoenix_Bid_Deadline_Date__c != null) {
                    customerBidDeadline = DateTime.newInstance(bid.Phoenix_Bid_Deadline_Date__c, Time.newInstance(0, 0, 0, 0));
                    if (templateBody.contains('CUSTOMER_DEADLINE_DATE')) templateBody = templateBody.replace('CUSTOMER_DEADLINE_DATE', customerBidDeadline.format('MMM d yyyy'));
                }
                
                if (objName == 'Phoenix_Bid__c'){
                    ccEmailIds.add(bid.owner.Email);
                }
                if (objName == 'Phoenix_Bid__c' && step.Phoenix_Is_Criteria_Step__c == true) {
                    
                    mail.setReplyTo(Label.Bright_Approval_Inbound_Email);
                } 
                else if (objName == 'Phoenix_NDC_Change__c'){
                    ccEmailIds.add(ndcChange.owner.Email);
                }
                else if (objName == 'Phoenix_PHS_Price_Change__c'){ 
                    
                    ccEmailIds.add(pHSChange.owner.Email);
                    isFooterTextAlterRequired = false;
                    AllEmailNotificationsSenderCls.sendEmailAlert(ndcId, content, new List<String> (toAddress), new List<String> (ccEmailIds), subject, title, isFooterTextAlterRequired); 
                }
                else if (objName == 'New_Product_WAC_Pricing__c') {
                    // ccEmailIds.add(newWac.owner.Email);
                    mail.setReplyTo(Label.Bright_Approval_Inbound_Email);
                }       
                else if (objName == 'Phoenix_WAC_Change__c'){ ccEmailIds.add(WacChange.owner.Email);
                                                            }
                
                if (objName == 'Phoenix_Bid__c' && bid.Phoenix_Bid_Created_Behalf_of__c != null) {
                    ccEmailIds.add(bid.Phoenix_Bid_Created_Behalf_of__r.Email);
                }
                
                if (step.Phoenix_Approver_Team__c == 'Home Office' && Label.CC_Emails_for_Vistex_Approvals != null) ccEmailIds.addAll(Label.CC_Emails_for_Vistex_Approvals.split(','));
                
                if (Label.Phoenix_Contracts_DL != null) ccEmailIds.addAll(Label.Phoenix_Contracts_DL.split(','));
                ccEmailIds.addAll(allPeopleInvolvedEmailsSet);
                for (string emailId: toAddress) {
                    if (ccEmailIds.contains(emailId))
                        ccEmailIds.remove(emailId);
                }
                
                If(ccEmailIds != null && ccEmailIds.contains('mkalawadia@drreddys.com'))ccEmailIds.remove('mkalawadia@drreddys.com');
                //ccEmailIds.add('srimayeechilagani@drreddys.com');
                
                subject = dynamicSubject;title =dynamicTitle; content = content1;toAddress=toAddress;ccEmailIds=ccEmailIds;
                //toAddress.add('naseershaik@drreddys.com');
                //sendEmailAlert(ndcId, content1, new List<String> (toAddress), new List<String> (ccEmailIds), dynamicSubject, dynamicTitle);
                List<String> testTo = new List<String>();
                 testTo.add('satyakalyala@drreddys.com');
        		testTo.add('pradeepkumarmutyala@drreddys.com');
                mail.setToAddresses(testTo); //replace with toaddress after testing//new List<String> (toAddress)
                //mail.setCcAddresses(new List<String> (ccEmailIds)); //uncomment this after testing
                content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:4px 8px 0px 8px;">Best Regards,</td></tr>';
                content1 += '<tr><td style="width: 24px;"></td><td style="padding: 0px 8px;">BRIGHT Support Team.</td></tr>';
                if(isFooterTextAlterRequired){
                    content1 += '<tr><td style="width: 24px;"></td><td style="padding: 12px 8px;"><i>[This is an auto-generated mail from BRIGHT]</i></td></tr>';   
                } else{
                    content1 += '<tr><td style="width: 24px;"></td><td style="padding: 12px 8px;"><i>[This is an auto-generated mail from BRIGHT, please do not reply to this email]</i></td></tr>';
                }
                content1 += '</table>';
                newTemplateBody = newTemplateBody.replace('LOGO_BODY', content1);
                newTemplateBody = newTemplateBody.replace('TITLE_TEXT', title);
                mail.setHtmlBody(newTemplateBody);
                mail.setSubject(subject);
                mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
                
                mailsList.add(mail);
                //messaging.sendEmail(mailsList);
                //AllEmailNotificationsSenderCls.sendEmailAlert(ndcId, content1, new List<String> (toAddress), new List<String> (ccEmailIds), dynamicSubject, dynamicTitle, isFooterTextAlterRequired);
                
                
                // if(step.Phoenix_Approver_Team__c == 'Sr Director or VP Finance')mail.setCcAddresses(new List<String>{'surender+BUheadCC@dhruvsoft.com'});//mail.setCcAddresses(new List<String>(approvalTeamUsersEmailsMap.get('Business Head')));
            }
             System.debug('mailsList size==>'+mailsList.size());
            if(mailsList.size() > 0 &&  subject.length() > 1) {
                System.debug('in mails list==>');
                 //sendEmailBatchClass batchInstance = new sendEmailBatchClass(mailsList);
                //Database.executeBatch(batchInstance,10);
                messaging.sendEmail(mailsList);
            }
            //results1 = messaging.sendEmail(mailsList);
            //results = Messaging.sendEmail(mails);
            if(objName != 'Phoenix_Bid__c'){
                Boolean isFooterTextAlterRequired = false;
               // AllEmailNotificationsSenderCls.sendEmailAlert(ndcId, content, new List<String> (toAddress), new List<String> (ccEmailIds), subject, title, isFooterTextAlterRequired); 
            }	
            
        }
        Catch(Exception e) {
            String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
            
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'approvalRequestNotification', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Remarks__c = '', Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        
        // return mailStatus;
        
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
    
    /*public static void codeCoverageBlock(){
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
    }*/
}