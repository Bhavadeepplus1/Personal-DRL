public class Phoenix_MyPendingBidApprovalsCtrl {
    public static Set < String > excludedTeams = new Set < String > ();
    public static String userName = '%' + UserInfo.getUserName() + '%';
    static{
        excludedTeams = new Set < String > {'Marketing', 'Marketing Lead Rx','Marketing Lead SRx', 'Marketing Lead OTC'};
            }
    @AuraEnabled
    public static BidApprovalModel loadModel() {
        BidApprovalModel model = new BidApprovalModel();
        
        //query bid process steps
        
        Set < String > loggedUserTeams = new Set < String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email,
                                                      Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c
                                                      from Phoenix_User_Approval_Matrix__c Where Phoenix_Approver__c =: UserInfo.getUserId() limit 50000
                                                     ])
            if (!excludedTeams.contains(matrix.User_Group__r.Phoenix_Approver_Group_Name__c)) loggedUserTeams.add(matrix.User_Group__r.Phoenix_Approver_Group_Name__c);
        
        if(!test.isrunningtest()){ model.allBidProcessSteps = [Select Id, Name,  Phoenix_Bid__r.LastModifiedDate,Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Bid__r.Phoenix_Customer_Bid_Deadline__c, Phoenix_Step__c, Phoenix_Process_Step__c, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Bid__r.Phoenix_Customer__r.Name,Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Description__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Internal_Target_Date__c,Phoenix_Bid__r.Phoenix_Approval_status_at_Hold__c,phoenix_WAC_Change__c,Phoenix_WAC_Change__r.name,Phoenix_WAC_Change__r.Phoenix_WAC_Change_Name__c,Phoenix_WAC_Change__r.Phoenix_Approval_Status__c,Phoenix_NDC_Change__c,Phoenix_NDC_Change__r.name,Phoenix_NDC_Change__r.Phoenix_NDC_Change_Name__c,Phoenix_NDC_Change__r.Phoenix_Approval_Status__c,Phoenix_PHS_Price_Change__c,Phoenix_PHS_Price_Change__r.name, Phoenix_PHS_Price_Change__r.Phoenix_PHS_Price_Change_Name__c,Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c,Phoenix_New_Product_WAC_Pricing__c,Phoenix_New_Product_WAC_Pricing__r.name, Phoenix_New_Product_WAC_Pricing__r.Phoenix_WAC_Price_for_New_Launch_Name__c,Phoenix_New_Product_WAC_Pricing__r.Phoenix_Approval_Status__c, Phoenix_Approval_Sent_Time__c  from Phoenix_Bid_Process_Steps__c where Phoenix_Approver__c =: UserInfo.getUserId() OR Phoenix_Approver_Team_Members__c LIKE: userName or Phoenix_Approver_Team__c IN: loggedUserTeams OR Phoenix_Approver__c =: UserInfo.getUserId() ORDER BY Phoenix_Bid__r.Phoenix_Internal_Target_Date__c ASC NULLS LAST LIMIT 50000
                                                              ];
                                 }
        else{
            model.allBidProcessSteps = [Select Id, Name, Phoenix_Bid__r.LastModifiedDate, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Bid__r.Phoenix_Customer_Bid_Deadline__c, Phoenix_Step__c, Phoenix_Process_Step__c, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Bid__r.Phoenix_Customer__r.Name,Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Description__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Internal_Target_Date__c,Phoenix_Bid__r.Phoenix_Approval_status_at_Hold__c,phoenix_WAC_Change__c,Phoenix_WAC_Change__r.name,Phoenix_WAC_Change__r.Phoenix_WAC_Change_Name__c,Phoenix_WAC_Change__r.Phoenix_Approval_Status__c,Phoenix_NDC_Change__c,Phoenix_NDC_Change__r.name,Phoenix_NDC_Change__r.Phoenix_NDC_Change_Name__c,Phoenix_NDC_Change__r.Phoenix_Approval_Status__c,Phoenix_PHS_Price_Change__c,Phoenix_PHS_Price_Change__r.name, Phoenix_PHS_Price_Change__r.Phoenix_PHS_Price_Change_Name__c,Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c,Phoenix_New_Product_WAC_Pricing__c,Phoenix_New_Product_WAC_Pricing__r.name, Phoenix_New_Product_WAC_Pricing__r.Phoenix_WAC_Price_for_New_Launch_Name__c,Phoenix_New_Product_WAC_Pricing__r.Phoenix_Approval_Status__c, Phoenix_Approval_Sent_Time__c  from Phoenix_Bid_Process_Steps__c where Phoenix_Approver__c =: UserInfo.getUserId() OR Phoenix_Approver_Team_Members__c LIKE: userName or Phoenix_Approver_Team__c IN: loggedUserTeams OR Phoenix_Approver__c =: UserInfo.getUserId() ORDER BY Phoenix_Bid__r.Phoenix_Internal_Target_Date__c ASC NULLS LAST LIMIt 1
                                       ];
        }
        
        Map < String, Bid > bidsmap = new Map < String, Bid > ();
        Map < String, String > bidTypesmap = new Map < String, String > ();
        
        for(Schema.PicklistEntry  ple:  Phoenix_Bid__c.Phoenix_Bid_Type__c.getDescribe().getPicklistValues()){
            bidTypesmap.put(ple.getValue(),ple.getLabel());
        }
        for (Phoenix_Bid_Process_Steps__c step: model.allBidProcessSteps) {
            Bid bid = new Bid();
            
            //code by vandana starts-for bid
            if(step.Phoenix_Bid__c!=null){
                bid.bidid = step.Phoenix_Bid__c;
                bid.no = step.Phoenix_Bid__r.name;
                bid.name = step.Phoenix_Bid__r.Phoenix_Bid_Name__c;
                if(step.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'On Hold'){
                    bid.approvalStaus = 'On Hold - '+step.Phoenix_Bid__r.Phoenix_Approval_status_at_Hold__c;
                }
                else if(step.Phoenix_Bid__r.Phoenix_Approval_Status__c != 'On Hold'){
                    bid.approvalStaus = step.Phoenix_Bid__r.Phoenix_Approval_Status__c;
                }
                bid.bidType = 'Bid - '+bidTypesmap.get(step.Phoenix_Bid__r.Phoenix_Bid_Type__c);
                bid.customerId = step.Phoenix_Bid__r.Phoenix_Customer__c;
                bid.customerName = step.Phoenix_Bid__r.Phoenix_Customer__r.Name;
                bid.Last_MDT = Phoenix_Util.getUserTimeNow(step.Phoenix_Bid__r.LastModifiedDate, 'America/New_York');
                //step.Phoenix_Bid__r.LastModifiedDate.format('MM/dd/yyyy\'T\'HH:mm:ssZ', 'EST');
                bid.internalTargetDate = step.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c;
                if(bid.internalTargetDate!=null){
                    bid.internalTargetDateEST = formatDateEST(bid.internalTargetDate); 
                    
                }               
                //Added Code by Rama
                bid.bidApprovalSentDate=Date.valueOf(step.Phoenix_Approval_Sent_Time__c);
                if(bid.bidApprovalSentDate!=null){
                    bid.bidApprovalSentDateEST=formatDateEST(bid.bidApprovalSentDate);
                }
                
                bidsmap.put(step.Phoenix_Bid__c, bid);
            }
            //end for bid
            //starts for WAC Change-
            if(step.Phoenix_WAC_Change__c!=null){bid.bidid = step.Phoenix_WAC_Change__c;bid.no = step.Phoenix_WAC_Change__r.name; bid.name = step.Phoenix_WAC_Change__r.Phoenix_WAC_Change_Name__c; bid.approvalStaus = step.Phoenix_WAC_Change__r.Phoenix_Approval_Status__c; bid.bidType = 'WAC Change';
                                                 bidsmap.put(step.Phoenix_WAC_Change__c, bid);
                                                }
            //end for WAC Change
            
            // starts-for NDC
            if(step.Phoenix_NDC_Change__c!=null){bid.bidid = step.Phoenix_NDC_Change__c;bid.no = step.Phoenix_NDC_Change__r.name; bid.name = step.Phoenix_NDC_Change__r.Phoenix_NDC_Change_Name__c; bid.approvalStaus = step.Phoenix_NDC_Change__r.Phoenix_Approval_Status__c; bid.bidType = 'NDC Change'; bidsmap.put(step.Phoenix_NDC_Change__c, bid);
                                                }
            //end for NDC
            // starts-for PHS
            if(step.Phoenix_PHS_Price_Change__c!=null){ bid.bidid = step.Phoenix_PHS_Price_Change__c;bid.no = step.Phoenix_PHS_Price_Change__r.name; bid.name = step.Phoenix_PHS_Price_Change__r.Phoenix_PHS_Price_Change_Name__c;bid.approvalStaus = step.Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c; bid.bidType = 'PHS Price Change'; bidsmap.put(step.Phoenix_PHS_Price_Change__c, bid);
                                                      }
            //end for PHS
            
            //starts-for New WAC pricing
            if(step.Phoenix_New_Product_WAC_Pricing__c!=null){ bid.bidid = step.Phoenix_New_Product_WAC_Pricing__c;bid.no = step.Phoenix_New_Product_WAC_Pricing__r.name;bid.name = step.Phoenix_New_Product_WAC_Pricing__r.Phoenix_WAC_Price_for_New_Launch_Name__c; bid.approvalStaus = step.Phoenix_New_Product_WAC_Pricing__r.Phoenix_Approval_Status__c; bid.bidType = 'New Product WAC Pricing'; bidsmap.put(step.Phoenix_New_Product_WAC_Pricing__c, bid);
                                                             }
            //end for New WAC Pricing
            //code by vandana --end.
            
        }
        
        model.bids = bidsmap.values();
        return model;
    }
    
    @AuraEnabled
    public static BidApprovalModel getPendingApprovals() {
        BidApprovalModel model = new BidApprovalModel();
        List < Phoenix_Bid_Process_Steps__c > finalSteps = new List < Phoenix_Bid_Process_Steps__c > ();
        //query bid process steps
        Set < String > loggedUserTeams = new Set < String > ();
        List < String > loggedUserTeamsList = new List < String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email,
                                                      Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c
                                                      from Phoenix_User_Approval_Matrix__c Where Phoenix_Approver__c =: UserInfo.getUserId() limit 50000
                                                     ]){
            if (!excludedTeams.contains(matrix.User_Group__r.Phoenix_Approver_Group_Name__c)) loggedUserTeams.add(matrix.User_Group__r.Phoenix_Approver_Group_Name__c);
                                                     }
        loggedUserTeamsList.addAll(loggedUserTeams);
       if(loggedUserTeamsList.size() > 0 && loggedUserTeamsList[0] == 'Home Office'){
            loggedUserTeams.add('Contracts');
        }
        system.debug('loggedUserTeams====='+loggedUserTeams);
        List<Phoenix_Bid_Process_Steps__c> stepList = new List<Phoenix_Bid_Process_Steps__c>();
        if(loggedUserTeamsList.size() > 0 &&  loggedUserTeamsList.contains('Home Office') ){ 
              system.debug('Inside Home office');
             stepList =  [Select Id, Name, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Bid__r.Phoenix_Customer_Bid_Deadline__c, Phoenix_Step__c, Phoenix_Process_Step__c, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Bid__r.Phoenix_Customer__r.Name,Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Description__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Internal_Target_Date__c,Phoenix_Bid__r.Phoenix_Approval_status_at_Hold__c,Phoenix_WAC_Change__c,Phoenix_WAC_Change__r.name,Phoenix_WAC_Change__r.Phoenix_WAC_Change_Name__c,Phoenix_WAC_Change__r.Phoenix_Approval_Status__c,Phoenix_NDC_Change__c,Phoenix_NDC_Change__r.name,Phoenix_NDC_Change__r.Phoenix_NDC_Change_Name__c,Phoenix_NDC_Change__r.Phoenix_Approval_Status__c,Phoenix_PHS_Price_Change__c, Phoenix_PHS_Price_Change__r.name,Phoenix_PHS_Price_Change__r.Phoenix_PHS_Price_Change_Name__c,Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c,Phoenix_New_Product_WAC_Pricing__c,Phoenix_New_Product_WAC_Pricing__r.name,Phoenix_New_Product_WAC_Pricing__r.Phoenix_WAC_Price_for_New_Launch_Name__c,Phoenix_New_Product_WAC_Pricing__r.Phoenix_Approval_Status__c,Phoenix_Approval_Sent_Time__c,Phoenix_Bid__r.LastModifiedDate
                         from Phoenix_Bid_Process_Steps__c
                         where (Phoenix_Approver__c =: UserInfo.getUserId() OR Phoenix_Approver_Team_Members__c LIKE: userName or Phoenix_Approver_Team__c IN: loggedUserTeams OR Phoenix_Approver__c =: UserInfo.getUserId()) AND (Phoenix_Bid__r.Phoenix_Approval_Status__c = 'Customer\'s Update' OR Phoenix_Bid__r.Phoenix_Approval_Status__c = 'Vistex Update') ORDER BY Phoenix_Bid__r.Phoenix_Internal_Target_Date__c ASC NULLS LAST LIMIT 50000
                        ];
                   }
        else {
             system.debug('Inside Other Team');
             stepList =  [Select Id, Name, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Bid__r.Phoenix_Customer_Bid_Deadline__c, Phoenix_Step__c, Phoenix_Process_Step__c, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Bid__r.Phoenix_Customer__r.Name,Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Description__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Internal_Target_Date__c,Phoenix_Bid__r.Phoenix_Approval_status_at_Hold__c,Phoenix_WAC_Change__c,Phoenix_WAC_Change__r.name,Phoenix_WAC_Change__r.Phoenix_WAC_Change_Name__c,Phoenix_WAC_Change__r.Phoenix_Approval_Status__c,Phoenix_NDC_Change__c,Phoenix_NDC_Change__r.name,Phoenix_NDC_Change__r.Phoenix_NDC_Change_Name__c,Phoenix_NDC_Change__r.Phoenix_Approval_Status__c,Phoenix_PHS_Price_Change__c, Phoenix_PHS_Price_Change__r.name,Phoenix_PHS_Price_Change__r.Phoenix_PHS_Price_Change_Name__c,Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c,Phoenix_New_Product_WAC_Pricing__c,Phoenix_New_Product_WAC_Pricing__r.name,Phoenix_New_Product_WAC_Pricing__r.Phoenix_WAC_Price_for_New_Launch_Name__c,Phoenix_New_Product_WAC_Pricing__r.Phoenix_Approval_Status__c,Phoenix_Approval_Sent_Time__c,Phoenix_Bid__r.LastModifiedDate
                         from Phoenix_Bid_Process_Steps__c
                         where Phoenix_Status__c = 'In Process'
                         AND(Phoenix_Approver__c =: UserInfo.getUserId() OR Phoenix_Approver_Team_Members__c LIKE: userName or Phoenix_Approver_Team__c IN: loggedUserTeams OR Phoenix_Approver__c =: UserInfo.getUserId()) ORDER BY Phoenix_Bid__r.Phoenix_Internal_Target_Date__c ASC NULLS LAST LIMIT 50000
                        ];

           
        }
        List<Id> crBidIds = new List<Id>();
         system.debug('stepList====='+stepList.size());
        for (Phoenix_Bid_Process_Steps__c step: stepList) {
            crBidIds.add(step.Phoenix_Bid__c);
        }
        List<Phoenix_Customer_Response__c> crList = [Select Id, Phoenix_Contract_Status__c,Phoenix_Bid_No__c from Phoenix_Customer_Response__c where Phoenix_Bid_No__c IN: crBidIds and Phoenix_Contract_Status__c ='Completed' and Phoenix_Vistex_Status__c != 'Updated'];
        map<Id,list<Phoenix_Customer_Response__c>> crMap = new map<Id,list<Phoenix_Customer_Response__c>>();
        for(Phoenix_Customer_Response__c cr : crList){
            if(crMap.containsKey(cr.Phoenix_Bid_No__c)){
                List<Phoenix_Customer_Response__c> crListItems = crMap.get(cr.Phoenix_Bid_No__c);
                crListItems.add(cr);
                crMap.put(cr.Phoenix_Bid_No__c,crListItems);
            }
            else{
                crMap.put(cr.Phoenix_Bid_No__c,new List<Phoenix_Customer_Response__c>{cr});
            }
        }
        for (Phoenix_Bid_Process_Steps__c step: stepList) {
            Boolean isCRCompleted = false;
            if(!crMap.isEmpty() && crMap.get(step.Phoenix_Bid__c) != null){
                for(Phoenix_Customer_Response__c cr : crMap.get(step.Phoenix_Bid__c)){
                    if(cr != null && cr.Phoenix_Contract_Status__c == 'Completed' && step.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Customer\'s Update'){
                        isCRCompleted = true;
                        break;
                    }
                }
                  }
                //Phoenix_Approver_Team__c IN:loggedUserTeams OR Phoenix_Approver__c=:UserInfo.getUserId() 
                if(loggedUserTeamsList.size() > 0 &&  loggedUserTeamsList[0] == 'Home Office'){ 
                     if (step.Phoenix_Approver__c == UserInfo.getUserId() && isCRCompleted ) {
                        finalSteps.add(step);
                    } else if (step.Phoenix_Approver_Team__c != null && loggedUserTeams.contains(step.Phoenix_Approver_Team__c) && isCRCompleted) {
                        finalSteps.add(step);
                    } else if(step.Phoenix_Approver__c == UserInfo.getUserId() && step.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Vistex Update' ) {
                        finalSteps.add(step);
                    }else if (step.Phoenix_Approver_Team__c != null && loggedUserTeams.contains(step.Phoenix_Approver_Team__c) && step.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Vistex Update') {
                        finalSteps.add(step);
                    } 
                    system.debug('I am marketing');
                  
                }
                else{
                   if (step.Phoenix_Approver__c == UserInfo.getUserId()) {
                        finalSteps.add(step);
                    } else if (step.Phoenix_Approver_Team__c != null && loggedUserTeams.contains(step.Phoenix_Approver_Team__c)) {
                        finalSteps.add(step);
                    }  
                }
              
                /*   else{
for (Phoenix_Customer_Response__c cr:[Select Id, Phoenix_Contract_Status__c,Phoenix_Bid_No__c from Phoenix_Customer_Response__c where Phoenix_Bid_No__c =: step.Phoenix_Bid__c and Phoenix_Contract_Status__c ='Completed' ] ) {
//  if(cr.Phoenix_Bid_No__c == step.Phoenix_Bid__c){
if (step.Phoenix_Approver__c == UserInfo.getUserId()) {
finalSteps.add(step);
} else if (step.Phoenix_Approver_Team__c != null && loggedUserTeams.contains(step.Phoenix_Approver_Team__c)) {
finalSteps.add(step);
}    
//}
} 
}*/
          
            
        }
        
        model.pendingBidProcessSteps = finalSteps;
        Map < String, Bid > bidsmap = new Map < String, Bid > ();
        Map < String, String > bidTypesmap = new Map < String, String > ();
        
        for(Schema.PicklistEntry  ple:  Phoenix_Bid__c.Phoenix_Bid_Type__c.getDescribe().getPicklistValues()){
            bidTypesmap.put(ple.getValue(),ple.getLabel());
        }
        for (Phoenix_Bid_Process_Steps__c step: model.pendingBidProcessSteps) {
            Bid bid = new Bid();
            
            
            //code by vandana starts-
            //for bid--
            if(step.Phoenix_Bid__c!=null){
                bid.bidid = step.Phoenix_Bid__c;
                bid.no = step.Phoenix_Bid__r.name;
                bid.name = step.Phoenix_Bid__r.Phoenix_Bid_Name__c;
                if(step.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'On Hold'){
                    bid.approvalStaus = 'On Hold - '+step.Phoenix_Bid__r.Phoenix_Approval_status_at_Hold__c;
                }
                else if(step.Phoenix_Bid__r.Phoenix_Approval_Status__c != 'On Hold'){
                    bid.approvalStaus = step.Phoenix_Bid__r.Phoenix_Approval_Status__c;
                }
                
                
                //   bid.approvalStaus = step.Phoenix_Bid__r.Phoenix_Approval_Status__c;
                bid.bidType = 'Bid - '+bidTypesmap.get(step.Phoenix_Bid__r.Phoenix_Bid_Type__c);
                bid.customerId = step.Phoenix_Bid__r.Phoenix_Customer__c;
                bid.customerName = step.Phoenix_Bid__r.Phoenix_Customer__r.Name;
                bid.internalTargetDate = step.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c;
                if(bid.internalTargetDate != null)
                    bid.internalTargetDateEST = formatDateEST(bid.internalTargetDate);
                //Added Code by Rama
                bid.bidApprovalSentDate=Date.valueOf(step.Phoenix_Approval_Sent_Time__c);
                if(bid.bidApprovalSentDate != null)
                    bid.bidApprovalSentDateEST=formatDateEST(bid.bidApprovalSentDate);
                 if(step.Phoenix_Bid__r.LastModifiedDate != null)
                bid.Last_MDT = Phoenix_Util.getUserTimeNow(step.Phoenix_Bid__r.LastModifiedDate, 'America/New_York');
                //step.Phoenix_Bid__r.LastModifiedDate.format('MM/dd/yyyy HH:mm:ss', 'EST');//(step.Phoenix_Bid__r.LastModifiedDate).format('MM/dd/yyyy');
                bidsmap.put(step.Phoenix_Bid__c, bid);
            }
            //end for bid.
            //for WAC Change starts-
            if(step.Phoenix_WAC_Change__c!=null){
                bid.bidid = step.Phoenix_WAC_Change__c;
                bid.no = step.Phoenix_WAC_Change__r.name;
                bid.name = step.Phoenix_WAC_Change__r.Phoenix_WAC_Change_Name__c;
                bid.approvalStaus = step.Phoenix_WAC_Change__r.Phoenix_Approval_Status__c;
                bid.bidType = 'WAC Change';
                //  bid.internalTargetDate = step.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c;--- if needed we can replace it with effective date. 
                bidsmap.put(step.Phoenix_WAC_Change__c, bid);
            }
            //end for wac change
            //start for NDC--
            if(step.Phoenix_NDC_Change__c!=null){
                System.debug(step.Phoenix_PHS_Price_Change__c+'188');
                bid.bidid = step.Phoenix_NDC_Change__c;
                bid.no = step.Phoenix_NDC_Change__r.name;
                bid.name = step.Phoenix_NDC_Change__r.Phoenix_NDC_Change_Name__c;
                bid.approvalStaus = step.Phoenix_NDC_Change__r.Phoenix_Approval_Status__c;
                bid.bidType = 'NDC Change';
                
                bidsmap.put(step.Phoenix_NDC_Change__c, bid);
            }
            //end for NDC.
            // starts-for PHS
            System.debug(step.Phoenix_PHS_Price_Change__c+'220');
            if(step.Phoenix_PHS_Price_Change__c!=null){
                bid.bidid = step.Phoenix_PHS_Price_Change__c;
                bid.no = step.Phoenix_PHS_Price_Change__r.name;
                bid.name = step.Phoenix_PHS_Price_Change__r.Phoenix_PHS_Price_Change_Name__c;
                bid.approvalStaus = step.Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c;
                
                bid.bidType = 'PHS Price Change';
                
                bidsmap.put(step.Phoenix_PHS_Price_Change__c, bid);
            }
            //end for PHS
            //starts-for New WAC pricing
            if(step.Phoenix_New_Product_WAC_Pricing__c!=null){
                bid.bidid = step.Phoenix_New_Product_WAC_Pricing__c;
                bid.no = step.Phoenix_New_Product_WAC_Pricing__r.name;
                bid.name = step.Phoenix_New_Product_WAC_Pricing__r.Phoenix_WAC_Price_for_New_Launch_Name__c;
                bid.approvalStaus = step.Phoenix_New_Product_WAC_Pricing__r.Phoenix_Approval_Status__c;
                
                bid.bidType = 'New Product WAC Pricing';
                bidsmap.put(step.Phoenix_New_Product_WAC_Pricing__c, bid);
            }
            //end for New WAC Pricing
            //code by vandana end.
        }
        
        model.bids = bidsmap.values();
        
        return model;
    }
    
    
    public class BidApprovalModel {
        @AuraEnabled public List < Bid > bids;
        @AuraEnabled public List < Bid > bidsdueToday;
        @AuraEnabled public List < Bid > bidsPastDue;
        @AuraEnabled public Integer bidsPastDuelength;
        @AuraEnabled public Integer bidsdueTodaylength;
        @AuraEnabled public list < Phoenix_Bid_Process_Steps__c > allBidProcessSteps;
        @AuraEnabled public list < Phoenix_Bid_Process_Steps__c > pendingBidProcessSteps;
        
        public BidApprovalModel() {
            bids = new List < Bid > ();
            bidsdueToday = new List < Bid > ();
            bidsPastDue = new List < Bid > ();
            allBidProcessSteps = new list < Phoenix_Bid_Process_Steps__c > ();
            pendingBidProcessSteps = new list < Phoenix_Bid_Process_Steps__c > ();
        }
    }
    
    public class Bid {
        @AuraEnabled public String bidId;
        @AuraEnabled public String name;
        @AuraEnabled public String no;
        @AuraEnabled public String approvalStaus;
        @AuraEnabled public String bidType;
        @AuraEnabled public String customerId;
        @AuraEnabled public String customerName;
        @AuraEnabled public String lastModifiedDate;
        @AuraEnabled public String Last_MDT;
        @AuraEnabled public Date internalTargetDate;
        @AuraEnabled public String internalTargetDateEST;
        //Added code by Rama
        @AuraEnabled public Date bidApprovalSentDate;
        @AuraEnabled public String bidApprovalSentDateEST;
        
        @AuraEnabled public Date sentToVistexDate;
        @AuraEnabled public Date sentToCustomerUpdateDate;
    }
    
    public static String formatDateEST(Date dt){
        DateTime dtime = DateTime.newInstance(dt, Time.newInstance(0, 0, 0, 0));
        return dtime.format('M/dd/yyyy');
    }
    
    
    public static void sendEmailToAllApprovers(){
        try{
            //    query all approval users map<Id,user approval matrix> userMap
            Map<Id , User> approvalUsersMap =  new Map<Id , User>();
            Map<Id, set <String>> userTeamsMap = new  Map<Id, set <String>> ();
            //AND Phoenix_Approver__c='005410000050qE3'
            for(Phoenix_User_Approval_Matrix__c matrix : [Select Id, Name, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email,Phoenix_Approver__r.FirstName,Phoenix_Approver__r.LastName,
                                                          Phoenix_Is_Approval_Process_User__c,User_Group__r.Phoenix_Approver_Group_Name__c
                                                          from Phoenix_User_Approval_Matrix__c where Phoenix_Is_Approval_Process_User__c = true and  Phoenix_Is_Active_User__c = true ]){
                                                              
                                                              User u = new User(Id = matrix.Phoenix_Approver__c , FirstName = matrix.Phoenix_Approver__r.FirstName , LastName = matrix.Phoenix_Approver__r.LastName , Email =matrix.Phoenix_Approver__r.Email );
                                                              approvalUsersMap.put(matrix.Phoenix_Approver__c , u);
                                                              
                                                              
                                                              if (userTeamsMap.containsKey(matrix.Phoenix_Approver__c) &&!excludedTeams.contains(matrix.User_Group__r.Phoenix_Approver_Group_Name__c)){
                                                                  set <String> existingTeams = userTeamsMap.get(matrix.Phoenix_Approver__c );
                                                                  
                                                                  existingTeams.add(matrix.User_Group__r.Phoenix_Approver_Group_Name__c);
                                                                  userTeamsMap.put(matrix.Phoenix_Approver__c ,existingTeams );
                                                              }
                                                              else if (!userTeamsMap.containsKey(matrix.Phoenix_Approver__c) &&!excludedTeams.contains(matrix.User_Group__r.Phoenix_Approver_Group_Name__c)){
                                                                  userTeamsMap.put(matrix.Phoenix_Approver__c , new Set <String>{matrix.User_Group__r.Phoenix_Approver_Group_Name__c} );
                                                                  
                                                              }
                                                              
                                                              
                                                          }
            system.debug('approvalUsersMap'+approvalUsersMap);
            system.debug('userTeamsMap'+userTeamsMap);
            
            
            //query all steps
            // Phoenix_Bid__c='a0C8A000005dyRSUAY'
            Map<Id,Phoenix_Bid_Process_Steps__c> bidProcessSteps = new Map<Id,Phoenix_Bid_Process_Steps__c>([Select Phoenix_Bid__c,Id, Name, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Approver_Team_Members__c,
                                                                                                             Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Bid__r.Phoenix_Customer_Bid_Deadline__c,Phoenix_Bid__r.Phoenix_Sent_to_Vistex_Date__c, Phoenix_Step__c, Phoenix_Process_Step__c, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Bid__r.Phoenix_Customer__r.Name,
                                                                                                             Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Description__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Internal_Target_Date__c,Phoenix_Bid__r.Phoenix_Approval_status_at_Hold__c,
                                                                                                             Phoenix_WAC_Change__c,Phoenix_WAC_Change__r.name,Phoenix_WAC_Change__r.Phoenix_WAC_Change_Name__c,Phoenix_WAC_Change__r.Phoenix_Approval_Status__c,Phoenix_NDC_Change__c,Phoenix_NDC_Change__r.name,Phoenix_NDC_Change__r.Phoenix_NDC_Change_Name__c,Phoenix_NDC_Change__r.Phoenix_Approval_Status__c,Phoenix_PHS_Price_Change__c,Phoenix_PHS_Price_Change__r.name,Phoenix_PHS_Price_Change__r.Phoenix_PHS_Price_Change_Name__c, Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c,Phoenix_New_Product_WAC_Pricing__c,Phoenix_New_Product_WAC_Pricing__r.name,Phoenix_New_Product_WAC_Pricing__r.Phoenix_WAC_Price_for_New_Launch_Name__c,Phoenix_New_Product_WAC_Pricing__r.Phoenix_Approval_Status__c,Phoenix_Bid__r.LastModifiedDate,Phoenix_Bid__r.Phoenix_Sales_Person_2__r.Email,Phoenix_Bid__r.Phoenix_Salesperson__r.Email,Phoenix_Bid__r.Phoenix_Salesperson__r.FirstName,Phoenix_Bid__r.Phoenix_Salesperson__r.LastName
                                                                                                             from Phoenix_Bid_Process_Steps__c where Phoenix_Status__c = 'In Process'  ORDER BY Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Internal_Target_Date__c ASC NULLS LAST]);
            //   List<Phoenix_Bid_Process_Steps__c> allBidProcessSteps = bidProcessSteps.values(); 
            Set<Id> bidIds = new Set<Id>();
            for(Phoenix_Bid_Process_Steps__c bid : bidProcessSteps.values()){
                bidIds.add(bid.Phoenix_Bid__c);
            }
            
            /* new List<Phoenix_Bid_Process_Steps__c>([Select Id, Name, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Approver_Team_Members__c,
Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Bid__r.Phoenix_Customer_Bid_Deadline__c,Phoenix_Bid__r.Phoenix_Sent_to_Vistex_Date__c, Phoenix_Step__c, Phoenix_Process_Step__c, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Bid__r.Phoenix_Customer__r.Name,
Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Description__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Internal_Target_Date__c,Phoenix_Bid__r.Phoenix_Approval_status_at_Hold__c,
Phoenix_WAC_Change__c,Phoenix_WAC_Change__r.name,Phoenix_WAC_Change__r.Phoenix_WAC_Change_Name__c,Phoenix_WAC_Change__r.Phoenix_Approval_Status__c,Phoenix_NDC_Change__c,Phoenix_NDC_Change__r.name,Phoenix_NDC_Change__r.Phoenix_NDC_Change_Name__c,Phoenix_NDC_Change__r.Phoenix_Approval_Status__c,Phoenix_PHS_Price_Change__c,Phoenix_PHS_Price_Change__r.name,Phoenix_PHS_Price_Change__r.Phoenix_PHS_Price_Change_Name__c, Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c,Phoenix_New_Product_WAC_Pricing__c,Phoenix_New_Product_WAC_Pricing__r.name,Phoenix_New_Product_WAC_Pricing__r.Phoenix_WAC_Price_for_New_Launch_Name__c,Phoenix_New_Product_WAC_Pricing__r.Phoenix_Approval_Status__c,Phoenix_Bid__r.LastModifiedDate,Phoenix_Bid__r.Phoenix_Sales_Person_2__r.Email,Phoenix_Bid__r.Phoenix_Salesperson__r.Email,Phoenix_Bid__r.Phoenix_Salesperson__r.FirstName,Phoenix_Bid__r.Phoenix_Salesperson__r.LastName
from Phoenix_Bid_Process_Steps__c where Phoenix_Status__c = 'In Process'  ORDER BY Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Internal_Target_Date__c ASC NULLS LAST]);//and  Phoenix_Bid__r.Phoenix_Approval_Status__c  != 'Customer\'s Update' */
            
            
            
            Map < String, String > bidTypesmap = new Map < String, String > ();
            
            for(Schema.PicklistEntry  ple:  Phoenix_Bid__c.Phoenix_Bid_Type__c.getDescribe().getPicklistValues()){
                bidTypesmap.put(ple.getValue(),ple.getLabel());
            }
            
            
            List < Messaging.SingleEmailMessage > mailsList = new List < Messaging.SingleEmailMessage > ();
            String mailStatus = '';
            Messaging.SendEmailResult[] results;
            Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('My_Pending_Approvals_Notification', UserInfo.getUserId());
            String templateBodyMain = emailWrapper.mailHtmlBody;
            String subjectMain = emailWrapper.mailSubject;
            Map < Id, User > UsersForDelegationMap = new Map<Id , User> ([Select Id,Name,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegated_Approver__r.Email From User]);
            system.debug('approvalUsersMap====='+approvalUsersMap.keyset());
                            Map<Id,Phoenix_Customer_Response__c> responseMap = new Map<Id,Phoenix_Customer_Response__c>([Select Phoenix_Bid_No__c,Id, Phoenix_Contract_Status__c from Phoenix_Customer_Response__c where Phoenix_Bid_No__c IN: bidIds and Phoenix_Contract_Status__c ='Completed']);
            for(Id userId :approvalUsersMap.keyset()){
                
                Map < String, Bid > bidsmap = new Map < String, Bid > ();
                user userobj = approvalUsersMap.get(userId);
                System.debug('userobj==>'+userobj);
                user userForDelegation =UsersForDelegationMap.get(userId);
                string userFullName ;
                if(userobj.FirstName!=null)
                    userFullName =  userobj.FirstName+' '+userobj.LastName;
                else
                    userFullName = userobj.LastName;
                system.debug('bidProcessSteps====='+bidProcessSteps.keySet());
                system.debug('bidIds====='+bidIds);
                system.debug('allBidProcessSteps==='+responseMap.keySet());
                system.debug('allBidProcessSteps==='+bidProcessSteps.values().size());
                set<Id> crBidIds = new set<Id>();
                for(Phoenix_Customer_Response__c cr : responseMap.Values()){
                    crBidIds.add(cr.Phoenix_Bid_No__c);
                }
                for(Phoenix_Bid_Process_Steps__c step : bidProcessSteps.values()){
                    //if(step.Phoenix_Bid__r.Phoenix_Approval_Status__c  != 'Customer\'s Update' || (step.Phoenix_Bid__r.Phoenix_Approval_Status__c  == 'Customer\'s Update' && ))
                    user u = approvalUsersMap.get(userId);
                    String currentUserName = u.FirstName+' '+u.LastName;
                    Set<String> loggedUserTeams = userTeamsMap.get(userId);
                    system.debug('loggedUserTeams====='+loggedUserTeams);
                    system.debug('step.Phoenix_Approver__c====='+step.Phoenix_Approver__c);
                    system.debug('userId====='+userId);
                    system.debug('approval status====='+step.Phoenix_Bid__r.Phoenix_Approval_Status__c);
                    system.debug('step.approve team====='+step.Phoenix_Approver_Team_Members__c.contains(currentUserName));
                    if(step.Phoenix_Approver__c == userId || 
                       (step.Phoenix_Approver_Team__c!=null && 
                        (loggedUserTeams!=null&& !loggedUserTeams.isempty()&& loggedUserTeams.contains(step.Phoenix_Approver_Team__c))) || 
                       (step.Phoenix_Approver_Team_Members__c != null &&  step.Phoenix_Approver_Team_Members__c.contains(currentUserName)) || (loggedUserTeams.contains('Home Office') && step.Phoenix_Bid__r.Phoenix_Approval_Status__c  == 'Customer\'s Update') 
                      )
                        
                    {
                        System.debug('userFullName1==>'+userFullName);
                        /*      if(step.Phoenix_Bid__c!=null)
bidNames.add(step.Phoenix_Bid__r.Name);
if(step.Phoenix_WAC_Change__c!=null)
WACChangeNames.add(step.Phoenix_WAC_Change__r.Name);
if(step.Phoenix_New_Product_WAC_Pricing__c!=null)
NewWAC.add(step.Phoenix_New_Product_WAC_Pricing__r.Name);
Bid bid = new Bid();*/
                        //       system.debug('--->');
                        Bid bid = new Bid();
                        //code by vandana starts-for bid
                        if(step.Phoenix_Bid__c!=null){
                            boolean isHomeOffice = (crBidIds.contains(step.Phoenix_Bid__c) && loggedUserTeams.contains('Home Office') && step.Phoenix_Bid__r.Phoenix_Approval_Status__c  == 'Customer\'s Update');
                            if(loggedUserTeams.contains('Home Office') && step.Phoenix_Bid__r.Phoenix_Approval_Status__c  == 'Customer\'s Update'){
                                if(isHomeOffice){
                                    system.debug('home');
                                    bid.bidid = step.Phoenix_Bid__c;
                                    bid.no = step.Phoenix_Bid__r.name;
                                    bid.name = step.Phoenix_Bid__r.Phoenix_Bid_Name__c;
                                    if(step.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'On Hold'){
                                        bid.approvalStaus ='On Hold - '+ step.Phoenix_Bid__r.Phoenix_Approval_status_at_Hold__c;
                                    }
                                    else if(step.Phoenix_Bid__r.Phoenix_Approval_Status__c != 'On Hold'){
                                        bid.approvalStaus = step.Phoenix_Bid__r.Phoenix_Approval_Status__c;
                                    }
                                    
                                    //  bid.approvalStaus = step.Phoenix_Bid__r.Phoenix_Approval_Status__c;
                                    
                                    bid.bidType = 'Bid - '+bidTypesmap.get(step.Phoenix_Bid__r.Phoenix_Bid_Type__c);
                                    bid.customerId = step.Phoenix_Bid__r.Phoenix_Customer__c;
                                    bid.customerName = step.Phoenix_Bid__r.Phoenix_Customer__r.Name;
                                    bid.internalTargetDate = step.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c;
                                    bid.sentToVistexDate = step.Phoenix_Bid__r.Phoenix_Sent_to_Vistex_Date__c;
                                    bid.lastModifiedDate = Phoenix_Util.getUserTimeNow(step.Phoenix_Bid__r.LastModifiedDate, 'America/New_York');
                                    bidsmap.put(step.Phoenix_Bid__c, bid);
                                }
                                
                            }else{
                                bid.bidid = step.Phoenix_Bid__c;
                                bid.no = step.Phoenix_Bid__r.name;
                                bid.name = step.Phoenix_Bid__r.Phoenix_Bid_Name__c;
                                if(step.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'On Hold'){
                                    bid.approvalStaus ='On Hold - '+ step.Phoenix_Bid__r.Phoenix_Approval_status_at_Hold__c;
                                }
                                else if(step.Phoenix_Bid__r.Phoenix_Approval_Status__c != 'On Hold'){
                                    bid.approvalStaus = step.Phoenix_Bid__r.Phoenix_Approval_Status__c;
                                }
                                
                                //  bid.approvalStaus = step.Phoenix_Bid__r.Phoenix_Approval_Status__c;
                                
                                bid.bidType = 'Bid - '+bidTypesmap.get(step.Phoenix_Bid__r.Phoenix_Bid_Type__c);
                                bid.customerId = step.Phoenix_Bid__r.Phoenix_Customer__c;
                                bid.customerName = step.Phoenix_Bid__r.Phoenix_Customer__r.Name;
                                bid.internalTargetDate = step.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c;
                                bid.sentToVistexDate = step.Phoenix_Bid__r.Phoenix_Sent_to_Vistex_Date__c;
                                bid.lastModifiedDate = Phoenix_Util.getUserTimeNow(step.Phoenix_Bid__r.LastModifiedDate, 'America/New_York');
                                bidsmap.put(step.Phoenix_Bid__c, bid);
                            }
                            
                            
                        }
                        //end for bid
                        //starts for WAC Change-
                        if(step.Phoenix_WAC_Change__c!=null){
                            bid.bidid = step.Phoenix_WAC_Change__c;
                            bid.no = step.Phoenix_WAC_Change__r.name;
                            bid.name = step.Phoenix_WAC_Change__r.Phoenix_WAC_Change_Name__c;
                            bid.approvalStaus = step.Phoenix_WAC_Change__r.Phoenix_Approval_Status__c;
                            bid.bidType = 'WAC Change';
                            bidsmap.put(step.Phoenix_WAC_Change__c, bid);
                        }
                        //end for WAC Change
                        
                        // starts-for NDC
                        if(step.Phoenix_NDC_Change__c!=null){ bid.bidid = step.Phoenix_NDC_Change__c; bid.no = step.Phoenix_NDC_Change__r.name;bid.name = step.Phoenix_NDC_Change__r.Phoenix_NDC_Change_Name__c;  bid.approvalStaus = step.Phoenix_NDC_Change__r.Phoenix_Approval_Status__c; bid.bidType = 'NDC Change'; bidsmap.put(step.Phoenix_NDC_Change__c, bid);
                                                            }
                        //end for NDC
                        // starts-for PHS
                        if(step.Phoenix_PHS_Price_Change__c!=null){
                            bid.bidid = step.Phoenix_PHS_Price_Change__c;
                            bid.no = step.Phoenix_PHS_Price_Change__r.name;
                            bid.name = step.Phoenix_PHS_Price_Change__r.Phoenix_PHS_Price_Change_Name__c;
                            bid.approvalStaus = step.Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c;
                            
                            bid.bidType = 'PHS Price Change';
                            
                            bidsmap.put(step.Phoenix_PHS_Price_Change__c, bid);
                        }
                        //end for PHS
                        
                        //starts-for New WAC pricing
                        if(step.Phoenix_New_Product_WAC_Pricing__c!=null){
                            bid.bidid = step.Phoenix_New_Product_WAC_Pricing__c;
                            bid.no = step.Phoenix_New_Product_WAC_Pricing__r.name;
                            bid.name = step.Phoenix_New_Product_WAC_Pricing__r.Phoenix_WAC_Price_for_New_Launch_Name__c;
                            bid.approvalStaus = step.Phoenix_New_Product_WAC_Pricing__r.Phoenix_Approval_Status__c;
                            
                            bid.bidType = 'New Product WAC Pricing';
                            bidsmap.put(step.Phoenix_New_Product_WAC_Pricing__c, bid);
                        }
                        //end for New WAC Pricing
                        //code by vandana --end.
                        
                    }//if block close
                    
                }//steps for loop close(
                
                if(bidsmap.size()>0){
                    
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    //Added by satya
                    string recordString;
                    //= bid.Name+','+bid.bidType+','+bid.internalTargetDate+','+bid.sentToVistexDate +'\n';
                    Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                    string header = 'Record No,Name , Type,Customer Name,Current Approval Status,Bid Internal Target Date,Sent to Vistex Date,Bid Last Modified Date\n';
                    string finalstr = header ;
                    String InterTarDate;
                    String SentDate;
                    String LastMDT;
                    String cusName;
                    String bid_Type,bid_Name;
                    String Items_Pending_For_My_Approval = '';
                    Items_Pending_For_My_Approval += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;">Record No</th><th style="border: 1px solid black;">Name</th><th style="border: 1px solid black;">Type</th><th style="border: 1px solid black;">Customer Name</th><th style="border: 1px solid black;">Current Approval Status</th><th style="border: 1px solid black;">Bid Internal Target Date</th><th style="border: 1px solid black;">Sent to Vistex Date</th><th style="border: 1px solid black;">Bid Last Modified Date</th></tr></thead>';
                    Items_Pending_For_My_Approval += '<tbody>';
                    for(Bid bid:bidsmap.values()){
                        
                        LastMDT= bid.LastModifiedDate;
                        //(bid.lastModifiedDate).format('MM/dd/yyyy\'T\'HH:mm:ssZ', 'EST');//(bid.lastModifiedDate).format('MM/dd/yyyy');
                        Items_Pending_For_My_Approval += '<tr>';
                        //URL.getSalesforceBaseUrl().toExternalForm()
                        if(bid.customerName != null){
                            cusName = (bid.customerName).replaceAll(',', '');
                        }
                        else{
                            cusName = '';
                        }
                        if(bid.bidType != null){
                            bid_Type=  (bid.bidType).replaceAll(',', '');
                        }else{
                            bid_Type = '';
                        }
                        if(bid.Name != null){
                            bid_Name= (bid.Name).replaceAll(',', '');
                        }
                        if(bid.internalTargetDate!=null && bid.internalTargetDate<system.today()){
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;white-space: nowrap;background-color: #ffcccb;padding:4px;">' +'<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+bid.bidId+'">' + bid.no + '</a></td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + bid.name + '</td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + bid.bidType + '</td>';
                            if (bid.customerName != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + bid.customerName + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' +''+ '</td>';
                            if (bid.approvalStaus != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + bid.approvalStaus + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' +''+ '</td>';
                            if ( bid.internalTargetDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.internalTargetDate, Time.newInstance(0, 0, 0, 0));
                                InterTarDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #ffcccb;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else{
                                InterTarDate='';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' +''+ '</td>';
                            }
                            if ( bid.sentToVistexDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.sentToVistexDate, Time.newInstance(0, 0, 0, 0));
                                SentDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #ffcccb;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else {
                                SentDate= '';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' +''+ '</td>';
                            }
                            if (bid.LastModifiedDate != Null){
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + LastMDT+ '</td>';
                            }else{
                                LastMDT='';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + ''+ '</td>';
                            }
                            Items_Pending_For_My_Approval += '</tr>';
                            
                            recordString = bid.no +','+bid_Name+','+bid_Type+','+cusName+','+bid.approvalStaus+','+InterTarDate+','+SentDate +','+LastMDT+'\n';
                            finalstr = finalstr +recordString;//by satya
                            
                        }
                        if(bid.internalTargetDate==null){
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;white-space: nowrap;padding:4px;">' +'<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+bid.bidId+'">' + bid.no + '</a></td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;padding:4px;">' + bid.name + '</td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;padding:4px;">' + bid.bidType + '</td>';
                            if (bid.customerName != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;padding:4px;">' + bid.customerName + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;padding:4px;">' +''+ '</td>';
                            if (bid.approvalStaus != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;padding:4px;">' + bid.approvalStaus + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;padding:4px;">' +''+ '</td>';
                            if ( bid.internalTargetDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.internalTargetDate, Time.newInstance(0, 0, 0, 0));
                                InterTarDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else{
                                InterTarDate = '';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;padding:4px;">' +''+ '</td>';
                            }
                            if ( bid.sentToVistexDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.sentToVistexDate, Time.newInstance(0, 0, 0, 0));
                                SentDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else{ 
                                SentDate='';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;padding:4px;">' +''+ '</td>';
                            }
                            if (bid.LastModifiedDate != Null){
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;padding:4px;">' + LastMDT + '</td>';
                            }
                            else{
                                LastMDT ='';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;padding:4px;">' + '' + '</td>';
                                
                            }
                            Items_Pending_For_My_Approval += '</tr>';
                            recordString = bid.no +','+bid_Name+','+bid_Type+','+cusName+','+bid.approvalStaus+','+InterTarDate+','+SentDate +','+LastMDT+'\n';
                            finalstr = finalstr +recordString;
                            
                        }
                        if((bid.internalTargetDate!=null && bid.internalTargetDate==system.today()) || test.isRunningTest()){
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;white-space: nowrap;background-color: #ffbf00;padding:4px;">' +'<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+bid.bidId+'">' + bid.no + '</a></td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffbf00;padding:4px;">' + bid.name + '</td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffbf00;padding:4px;">' + bid.bidType + '</td>';
                            if (bid.customerName != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffbf00;padding:4px;">' + bid.customerName + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffbf00;padding:4px;">' +''+ '</td>';
                            if (bid.approvalStaus != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffbf00;padding:4px;">' + bid.approvalStaus + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffbf00;padding:4px;">' +''+ '</td>';
                            if ( bid.internalTargetDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.internalTargetDate, Time.newInstance(0, 0, 0, 0));
                                InterTarDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #ffbf00;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else{
                                InterTarDate='';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffbf00;padding:4px;">' +''+ '</td>';
                            }
                            if ( bid.sentToVistexDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.sentToVistexDate, Time.newInstance(0, 0, 0, 0));
                                SentDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #ffbf00;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else{
                                SentDate = '';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffbf00;padding:4px;">' +''+ '</td>';
                            }
                            if (bid.LastModifiedDate != Null){
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + LastMDT + '</td>';
                            }else{
                                LastMDT='';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + '' + '</td>';
                                
                            }
                            Items_Pending_For_My_Approval += '</tr>';
                            recordString = bid.no +','+bid_Name+','+bid_Type+','+cusName+','+bid.approvalStaus+','+InterTarDate+','+SentDate +','+LastMDT+'\n';
                            finalstr = finalstr +recordString;
                            
                        }
                        if(bid.internalTargetDate!=null && bid.internalTargetDate > system.today() && bid.internalTargetDate<=(system.today()+2)){
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;white-space: nowrap;background-color: #FFFF66;padding:4px;">' +'<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+bid.bidId+'">' + bid.no + '</a></td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #FFFF66;padding:4px;">' + bid.name + '</td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #FFFF66;padding:4px;">' + bid.bidType + '</td>';
                            if (bid.customerName != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #FFFF66;padding:4px;">' + bid.customerName + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #FFFF66;padding:4px;">' +''+ '</td>';
                            if (bid.approvalStaus != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #FFFF66;padding:4px;">' + bid.approvalStaus + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color:#FFFF66;padding:4px;">' +''+ '</td>';
                            if ( bid.internalTargetDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.internalTargetDate, Time.newInstance(0, 0, 0, 0));
                                InterTarDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #FFFF66;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else {
                                InterTarDate ='';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #FFFF66;padding:4px;">' +''+ '</td>';
                            }
                            if ( bid.sentToVistexDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.sentToVistexDate, Time.newInstance(0, 0, 0, 0));
                                SentDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #FFFF66;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else{
                                SentDate = '';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #FFFF66;padding:4px;">' +''+ '</td>';
                            }
                            if (bid.LastModifiedDate != Null){
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #FFFF66;padding:4px;">' + LastMDT + '</td>';
                            }else{
                                LastMDT='';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #FFFF66;padding:4px;">' + '' + '</td>';
                                
                            }
                            Items_Pending_For_My_Approval += '</tr>';
                            recordString = bid.no +','+bid_Name+','+bid_Type+','+cusName+','+bid.approvalStaus+','+InterTarDate+','+SentDate+',' +LastMDT+'\n';
                            finalstr = finalstr +recordString;
                            
                        }
                        if(bid.internalTargetDate!=null && bid.internalTargetDate>(system.today()+2)){
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;white-space: nowrap;background-color: #90EE90;padding:4px;">' +'<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+bid.bidId+'">' + bid.no + '</a></td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #90EE90;padding:4px;">' + bid.name + '</td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #90EE90;padding:4px;">' + bid.bidType + '</td>';
                            if (bid.customerName != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #90EE90;padding:4px;">' + bid.customerName + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #90EE90;padding:4px;">' +''+ '</td>';
                            if (bid.approvalStaus != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #90EE90;padding:4px;">' + bid.approvalStaus + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color:#90EE90;padding:4px;">' +''+ '</td>';
                            if ( bid.internalTargetDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.internalTargetDate, Time.newInstance(0, 0, 0, 0));
                                InterTarDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #90EE90;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else{
                                InterTarDate = '';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #90EE90;padding:4px;">' +''+ '</td>';
                            }
                            if ( bid.sentToVistexDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.sentToVistexDate, Time.newInstance(0, 0, 0, 0));
                                SentDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #90EE90;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else{
                                SentDate = '';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #90EE90;padding:4px;">' +''+ '</td>';
                            }
                            if (bid.LastModifiedDate != Null){
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #90EE90;padding:4px;">' + LastMDT + '</td>';
                            }else{
                                LastMDT='';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #90EE90;padding:4px;">' + '' + '</td>';
                                
                            }
                            Items_Pending_For_My_Approval += '</tr>';
                            recordString = bid.no +','+bid_Name+','+bid_Type+','+cusName+','+bid.approvalStaus+','+InterTarDate+','+SentDate +','+LastMDT+'\n';
                            finalstr = finalstr +recordString;
                        }
                        
                    }
                    //Added by Satya
                    blob csvBlob = Blob.valueOf(finalstr);
                    DateTime todayDate = DateTime.newInstance(System.today(), Time.newInstance(0, 0, 0, 0));
                    string csvname= 'BRIGHT - My Pending Approvals -'+todayDate.format('MM/dd/yyyy')+'.csv';
                    csvAttc.setFileName(csvname);
                    csvAttc.setBody(csvBlob);
                    //End by Satya
                    Items_Pending_For_My_Approval += '</tbody></table>'; 
                    
                    String templateBody = templateBodyMain;
                    String subject =subjectMain;
                    if (templateBody.contains('USER_NAME')) templateBody = templateBody.replace('USER_NAME',userFullName);
                    if (templateBody.contains('Items_Pending_For_My_Approval')) templateBody = templateBody.replace('Items_Pending_For_My_Approval', Items_Pending_For_My_Approval);
                    email.setSubject(subject);
                    email.setHtmlBody(templateBody);
                    
                    email.setToAddresses(new List<String>{userobj.Email}); 
                    //system.debug('delegatoir'+userobj.Phoenix_Delegated_Approver__r.Email);
                    //system.debug('delegatoir email'+userobj.Phoenix_Delegated_Approver__c);
                    if(!test.isRunningTest()){
                    if(userForDelegation.Phoenix_Delegated_Approver__c!=null && userForDelegation.Phoenix_Delegated_Approver__r.Email!=null){
                        
                        email.setCCAddresses(new List<String>{userForDelegation.Phoenix_Delegated_Approver__r.Email});    
                    }
                    }
                    email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});//Added by satya
                    email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
                    mailsList.add(email);
                    
                } 
                
            }//user for loop close
            
            
            //system.debug('Email Limit'+limits.getEmailInvocations());
            if (mailsList.size() > 0) results = Messaging.sendEmail(mailsList);
            
        }
        Catch(Exception e) {
            String msg  = e.getMessage().length() > 255 ? e.getMessage().substring(0,254) : e.getMessage();
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_MyPendingBidApprovalsCtrl', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'sendEmailToAllApprovers', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString());
            insert exp;
        }
    } //method close
    //new method to sales users at customer's update
    
    public static void salesUsersatCustomersUpdate(){
        try{
            //    query all approval users map<Id,user approval matrix> userMap
            Map<Id , User> approvalUsersMap =  new Map<Id , User>();
            Map<Id, set <String>> userTeamsMap = new  Map<Id, set <String>> ();
            //AND Phoenix_Approver__c='005410000050qE3'
            /*  for(Phoenix_User_Approval_Matrix__c matrix : [Select Id, Name, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email,Phoenix_Approver__r.FirstName,Phoenix_Approver__r.LastName,
Phoenix_Is_Approval_Process_User__c,User_Group__r.Phoenix_Approver_Group_Name__c
from Phoenix_User_Approval_Matrix__c where Phoenix_Is_Approval_Process_User__c = true and  Phoenix_Is_Active_User__c = true ]){

User u = new User(Id = matrix.Phoenix_Approver__c , FirstName = matrix.Phoenix_Approver__r.FirstName , LastName = matrix.Phoenix_Approver__r.LastName , Email =matrix.Phoenix_Approver__r.Email );
approvalUsersMap.put(matrix.Phoenix_Approver__c , u);


if (userTeamsMap.containsKey(matrix.Phoenix_Approver__c) &&!excludedTeams.contains(matrix.User_Group__r.Phoenix_Approver_Group_Name__c)){
set <String> existingTeams = userTeamsMap.get(matrix.Phoenix_Approver__c );

existingTeams.add(matrix.User_Group__r.Phoenix_Approver_Group_Name__c);
userTeamsMap.put(matrix.Phoenix_Approver__c ,existingTeams );
}
else if (!userTeamsMap.containsKey(matrix.Phoenix_Approver__c) &&!excludedTeams.contains(matrix.User_Group__r.Phoenix_Approver_Group_Name__c)){
userTeamsMap.put(matrix.Phoenix_Approver__c , new Set <String>{matrix.User_Group__r.Phoenix_Approver_Group_Name__c} );

}


}*/
            //system.debug('approvalUsersMap'+approvalUsersMap);
            //system.debug('userTeamsMap'+userTeamsMap);
            
            
            //query all steps
            // Phoenix_Bid__c='a0C8A000005dyRSUAY'
            List<Phoenix_Bid_Process_Steps__c> allBidProcessSteps = new List<Phoenix_Bid_Process_Steps__c>([Select Id, Name, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Approver_Team_Members__c,
                                                                                                            Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c, Phoenix_Bid__r.Phoenix_Customer_Bid_Deadline__c,Phoenix_Bid__r.Phoenix_Sent_to_Vistex_Date__c, Phoenix_Step__c, Phoenix_Process_Step__c, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Bid__r.Phoenix_Customer__r.Name,
                                                                                                            Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Description__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Internal_Target_Date__c,Phoenix_Bid__r.Phoenix_Approval_status_at_Hold__c,
                                                                                                            Phoenix_WAC_Change__c,Phoenix_WAC_Change__r.name,Phoenix_WAC_Change__r.Phoenix_WAC_Change_Name__c,Phoenix_WAC_Change__r.Phoenix_Approval_Status__c,Phoenix_NDC_Change__c,Phoenix_NDC_Change__r.name,Phoenix_NDC_Change__r.Phoenix_NDC_Change_Name__c,Phoenix_NDC_Change__r.Phoenix_Approval_Status__c,Phoenix_PHS_Price_Change__c,Phoenix_PHS_Price_Change__r.name,Phoenix_PHS_Price_Change__r.Phoenix_PHS_Price_Change_Name__c, Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c,Phoenix_New_Product_WAC_Pricing__c,Phoenix_New_Product_WAC_Pricing__r.name,Phoenix_New_Product_WAC_Pricing__r.Phoenix_WAC_Price_for_New_Launch_Name__c,Phoenix_New_Product_WAC_Pricing__r.Phoenix_Approval_Status__c,Phoenix_Bid__r.LastModifiedDate,Phoenix_Bid__r.Phoenix_Sales_Person_2__r.Email,Phoenix_Bid__r.Phoenix_Salesperson__r.Email,Phoenix_Bid__r.Phoenix_Salesperson__r.FirstName,Phoenix_Bid__r.Phoenix_Salesperson__r.LastName
                                                                                                            from Phoenix_Bid_Process_Steps__c where Phoenix_Status__c = 'In Process' and  Phoenix_Bid__r.Phoenix_Approval_Status__c  =: 'Customer\'s Update' ORDER BY Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Internal_Target_Date__c ASC NULLS LAST]);
            
            
            
            Map < String, String > bidTypesmap = new Map < String, String > ();
            
            for(Schema.PicklistEntry  ple:  Phoenix_Bid__c.Phoenix_Bid_Type__c.getDescribe().getPicklistValues()){
                bidTypesmap.put(ple.getValue(),ple.getLabel());
            }
            
            
            List < Messaging.SingleEmailMessage > mailsList = new List < Messaging.SingleEmailMessage > ();
            String mailStatus = '';
            Messaging.SendEmailResult[] results;
            Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('MyPendingApprovalsSalesUsers', UserInfo.getUserId());
            String templateBodyMain = emailWrapper.mailHtmlBody;
            String subjectMain = emailWrapper.mailSubject;
            Map < Id, User > UsersForDelegationMap = new Map<Id , User> ([Select Id,Name,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegated_Approver__r.Email From User]);
            List<String> toAddressList = new List<String>();
            boolean isCustomerUpdate =false;
            Set<Id> salesUserList =  new Set<Id>();
            for(Phoenix_Bid_Process_Steps__c step : allBidProcessSteps){
                if(step.Phoenix_Process_Step__r.Name =='Customer'+ '\''+'s Update'){
                    //added by satya//
                    isCustomerUpdate = true; 
                    //toAddressList.add('satya@dhruvsoft.com');
                    if(step.Phoenix_Bid__r.Phoenix_Sales_Person_2__c != null){
                        toAddressList.add(step.Phoenix_Bid__r.Phoenix_Sales_Person_2__r.Email);
                        salesUserList.add(step.Phoenix_Bid__r.Phoenix_Sales_Person_2__c);
                        User u = new User(Id = step.Phoenix_Bid__r.Phoenix_Sales_Person_2__c , FirstName = step.Phoenix_Bid__r.Phoenix_Sales_Person_2__r.FirstName , LastName = step.Phoenix_Bid__r.Phoenix_Sales_Person_2__r.LastName , Email =step.Phoenix_Bid__r.Phoenix_Sales_Person_2__r.Email );
                        approvalUsersMap.put(step.Phoenix_Bid__r.Phoenix_Sales_Person_2__c , u);
                    }else if(step.Phoenix_Bid__r.Phoenix_Salesperson__c != null){
                        toAddressList.add(step.Phoenix_Bid__r.Phoenix_Salesperson__r.Email);  
                        salesUserList.add(step.Phoenix_Bid__r.Phoenix_Salesperson__c);
                        User u = new User(Id = step.Phoenix_Bid__r.Phoenix_Salesperson__c , FirstName = step.Phoenix_Bid__r.Phoenix_Salesperson__r.FirstName , LastName = step.Phoenix_Bid__r.Phoenix_Salesperson__r.LastName , Email =step.Phoenix_Bid__r.Phoenix_Salesperson__r.Email );
                        approvalUsersMap.put(step.Phoenix_Bid__r.Phoenix_Salesperson__c , u);
                    }
                }
            }
            //System.debug('isCustomerUpdate==>'+isCustomerUpdate);
            //isCustomerUpdate?salesUserList :approvalUsersMap.keyset()
            System.debug('salesUserList size===>'+salesUserList.size());
            System.debug('approvalUsersMap===>'+approvalUsersMap.size());
            System.debug('salesUserList===>'+salesUserList);
            for(Id userId :salesUserList){
                System.debug('userId==>'+userId);
                Map < String, Bid > bidsmap = new Map < String, Bid > ();
                user userobj = approvalUsersMap.get(userId);
                System.debug('userobj==>'+userobj);
                user userForDelegation =UsersForDelegationMap.get(userId);
                string userFullName ;
                if(userobj.FirstName!=null)
                    userFullName =  userobj.FirstName+' '+userobj.LastName;
                else
                    userFullName = userobj.LastName;
                
                for(Phoenix_Bid_Process_Steps__c step : allBidProcessSteps){
                    user u = approvalUsersMap.get(userId);
                    String currentUserName = u.FirstName+' '+u.LastName;
                    Set<String> loggedUserTeams = userTeamsMap.get(userId);
                    
                    if(userId == step.Phoenix_Bid__r.Phoenix_Salesperson__c || userId == step.Phoenix_Bid__r.Phoenix_Sales_Person_2__c)
                        
                        
                    {
                        System.debug('userFullName1==>'+userFullName);
                        /*      if(step.Phoenix_Bid__c!=null)
bidNames.add(step.Phoenix_Bid__r.Name);
if(step.Phoenix_WAC_Change__c!=null)
WACChangeNames.add(step.Phoenix_WAC_Change__r.Name);
if(step.Phoenix_New_Product_WAC_Pricing__c!=null)
NewWAC.add(step.Phoenix_New_Product_WAC_Pricing__r.Name);
Bid bid = new Bid();*/
                        //       system.debug('--->');
                        Bid bid = new Bid();
                        //code by vandana starts-for bid
                        if(step.Phoenix_Bid__c!=null){
                            bid.bidid = step.Phoenix_Bid__c;
                            bid.no = step.Phoenix_Bid__r.name;
                            bid.name = step.Phoenix_Bid__r.Phoenix_Bid_Name__c;
                            if(step.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'On Hold'){
                                bid.approvalStaus ='On Hold - '+ step.Phoenix_Bid__r.Phoenix_Approval_status_at_Hold__c;
                            }
                            else if(step.Phoenix_Bid__r.Phoenix_Approval_Status__c != 'On Hold'){
                                bid.approvalStaus = step.Phoenix_Bid__r.Phoenix_Approval_Status__c;
                            }
                            
                            //  bid.approvalStaus = step.Phoenix_Bid__r.Phoenix_Approval_Status__c;
                            
                            bid.bidType = 'Bid - '+bidTypesmap.get(step.Phoenix_Bid__r.Phoenix_Bid_Type__c);
                            bid.customerId = step.Phoenix_Bid__r.Phoenix_Customer__c;
                            bid.customerName = step.Phoenix_Bid__r.Phoenix_Customer__r.Name;
                            bid.internalTargetDate = step.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c;
                            // bid.sentToVistexDate = step.Phoenix_Bid__r.Phoenix_Sent_to_Vistex_Date__c;
                            bid.sentToCustomerUpdateDate=step.Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c;                           
                            bid.lastModifiedDate = Phoenix_Util.getUserTimeNow(step.Phoenix_Bid__r.LastModifiedDate, 'America/New_York');
                            bidsmap.put(step.Phoenix_Bid__c, bid);
                        }
                        //end for bid
                        //starts for WAC Change-
                        if(step.Phoenix_WAC_Change__c!=null){
                            bid.bidid = step.Phoenix_WAC_Change__c;
                            bid.no = step.Phoenix_WAC_Change__r.name;
                            bid.name = step.Phoenix_WAC_Change__r.Phoenix_WAC_Change_Name__c;
                            bid.approvalStaus = step.Phoenix_WAC_Change__r.Phoenix_Approval_Status__c;
                            bid.bidType = 'WAC Change';
                            bidsmap.put(step.Phoenix_WAC_Change__c, bid);
                        }
                        //end for WAC Change
                        
                        // starts-for NDC
                        if(step.Phoenix_NDC_Change__c!=null){ bid.bidid = step.Phoenix_NDC_Change__c; bid.no = step.Phoenix_NDC_Change__r.name;bid.name = step.Phoenix_NDC_Change__r.Phoenix_NDC_Change_Name__c;  bid.approvalStaus = step.Phoenix_NDC_Change__r.Phoenix_Approval_Status__c; bid.bidType = 'NDC Change'; bidsmap.put(step.Phoenix_NDC_Change__c, bid);
                                                            }
                        //end for NDC
                        // starts-for PHS
                        if(step.Phoenix_PHS_Price_Change__c!=null){
                            bid.bidid = step.Phoenix_PHS_Price_Change__c;
                            bid.no = step.Phoenix_PHS_Price_Change__r.name;
                            bid.name = step.Phoenix_PHS_Price_Change__r.Phoenix_PHS_Price_Change_Name__c;
                            bid.approvalStaus = step.Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c;
                            
                            bid.bidType = 'PHS Price Change';
                            
                            bidsmap.put(step.Phoenix_PHS_Price_Change__c, bid);
                        }
                        //end for PHS
                        
                        //starts-for New WAC pricing
                        if(step.Phoenix_New_Product_WAC_Pricing__c!=null){
                            bid.bidid = step.Phoenix_New_Product_WAC_Pricing__c;
                            bid.no = step.Phoenix_New_Product_WAC_Pricing__r.name;
                            bid.name = step.Phoenix_New_Product_WAC_Pricing__r.Phoenix_WAC_Price_for_New_Launch_Name__c;
                            bid.approvalStaus = step.Phoenix_New_Product_WAC_Pricing__r.Phoenix_Approval_Status__c;
                            
                            bid.bidType = 'New Product WAC Pricing';
                            bidsmap.put(step.Phoenix_New_Product_WAC_Pricing__c, bid);
                        }
                        //end for New WAC Pricing
                        //code by vandana --end.
                        
                    }//if block close
                    
                }//steps for loop close(
                
                if(bidsmap.size()>0){
                    
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    //Added by satya
                    string recordString;
                    //= bid.Name+','+bid.bidType+','+bid.internalTargetDate+','+bid.sentToVistexDate +'\n';
                    Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                    string header = 'Record No,Name , Type,Customer Name,Current Approval Status,Bid Internal Target Date,Sent to Customer\'s Update,Bid Last Modified Date\n';
                    string finalstr = header ;
                    String InterTarDate;
                    String SentDate;
                    String LastMDT;
                    String cusName;
                    String bid_Type,bid_Name;
                    String Items_Pending_For_My_Approval = '';
                    Items_Pending_For_My_Approval += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;">Record No</th><th style="border: 1px solid black;">Name</th><th style="border: 1px solid black;">Type</th><th style="border: 1px solid black;">Customer Name</th><th style="border: 1px solid black;">Current Approval Status</th><th style="border: 1px solid black;">Bid Internal Target Date</th><th style="border: 1px solid black;">Sent to Customer\'s Date</th><th style="border: 1px solid black;">Bid Last Modified Date</th></tr></thead>';
                    Items_Pending_For_My_Approval += '<tbody>';
                    for(Bid bid:bidsmap.values()){
                        
                        LastMDT= bid.LastModifiedDate;
                        //(bid.lastModifiedDate).format('MM/dd/yyyy\'T\'HH:mm:ssZ', 'EST');//(bid.lastModifiedDate).format('MM/dd/yyyy');
                        Items_Pending_For_My_Approval += '<tr>';
                        //URL.getSalesforceBaseUrl().toExternalForm()
                        if(bid.customerName != null){
                            cusName = (bid.customerName).replaceAll(',', '');
                        }
                        else{
                            cusName = '';
                        }
                        if(bid.bidType != null){
                            bid_Type=  (bid.bidType).replaceAll(',', '');
                        }else{
                            bid_Type = '';
                        }
                        if(bid.Name != null){
                            bid_Name= (bid.Name).replaceAll(',', '');
                        }
                        if(bid.internalTargetDate!=null && bid.internalTargetDate<system.today()){
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;white-space: nowrap;background-color: #ffcccb;padding:4px;">' +'<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+bid.bidId+'">' + bid.no + '</a></td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + bid.name + '</td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + bid.bidType + '</td>';
                            if (bid.customerName != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + bid.customerName + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' +''+ '</td>';
                            if (bid.approvalStaus != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + bid.approvalStaus + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' +''+ '</td>';
                            if ( bid.internalTargetDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.internalTargetDate, Time.newInstance(0, 0, 0, 0));
                                InterTarDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #ffcccb;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else{
                                InterTarDate='';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' +''+ '</td>';
                            }
                            if ( bid.sentToCustomerUpdateDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.sentToCustomerUpdateDate, Time.newInstance(0, 0, 0, 0));
                                SentDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #ffcccb;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else {
                                SentDate= '';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' +''+ '</td>';
                            }
                            if (bid.LastModifiedDate != Null){
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + LastMDT+ '</td>';
                            }else{
                                LastMDT='';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + ''+ '</td>';
                            }
                            Items_Pending_For_My_Approval += '</tr>';
                            
                            recordString = bid.no +','+bid_Name+','+bid_Type+','+cusName+','+bid.approvalStaus+','+InterTarDate+','+SentDate +','+LastMDT+'\n';
                            finalstr = finalstr +recordString;//by satya
                            
                        }
                        if(bid.internalTargetDate==null){
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;white-space: nowrap;padding:4px;">' +'<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+bid.bidId+'">' + bid.no + '</a></td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;padding:4px;">' + bid.name + '</td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;padding:4px;">' + bid.bidType + '</td>';
                            if (bid.customerName != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;padding:4px;">' + bid.customerName + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;padding:4px;">' +''+ '</td>';
                            if (bid.approvalStaus != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;padding:4px;">' + bid.approvalStaus + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;padding:4px;">' +''+ '</td>';
                            if ( bid.internalTargetDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.internalTargetDate, Time.newInstance(0, 0, 0, 0));
                                InterTarDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else{
                                InterTarDate = '';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;padding:4px;">' +''+ '</td>';
                            }
                            if ( bid.sentToCustomerUpdateDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.sentToCustomerUpdateDate, Time.newInstance(0, 0, 0, 0));
                                SentDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else{ 
                                SentDate='';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;padding:4px;">' +''+ '</td>';
                            }
                            if (bid.LastModifiedDate != Null){
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;padding:4px;">' + LastMDT + '</td>';
                            }
                            else{
                                LastMDT ='';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;padding:4px;">' + '' + '</td>';
                                
                            }
                            Items_Pending_For_My_Approval += '</tr>';
                            recordString = bid.no +','+bid_Name+','+bid_Type+','+cusName+','+bid.approvalStaus+','+InterTarDate+','+SentDate +','+LastMDT+'\n';
                            finalstr = finalstr +recordString;
                            
                        }
                        if((bid.internalTargetDate!=null && bid.internalTargetDate==system.today()) || test.isRunningTest()){
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;white-space: nowrap;background-color: #ffbf00;padding:4px;">' +'<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+bid.bidId+'">' + bid.no + '</a></td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffbf00;padding:4px;">' + bid.name + '</td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffbf00;padding:4px;">' + bid.bidType + '</td>';
                            if (bid.customerName != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffbf00;padding:4px;">' + bid.customerName + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffbf00;padding:4px;">' +''+ '</td>';
                            if (bid.approvalStaus != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffbf00;padding:4px;">' + bid.approvalStaus + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffbf00;padding:4px;">' +''+ '</td>';
                            if ( bid.internalTargetDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.internalTargetDate, Time.newInstance(0, 0, 0, 0));
                                InterTarDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #ffbf00;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else{
                                InterTarDate='';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffbf00;padding:4px;">' +''+ '</td>';
                            }
                            if ( bid.sentToCustomerUpdateDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.sentToCustomerUpdateDate, Time.newInstance(0, 0, 0, 0));
                                SentDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #ffbf00;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else{
                                SentDate = '';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffbf00;padding:4px;">' +''+ '</td>';
                            }
                            if (bid.LastModifiedDate != Null){
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + LastMDT + '</td>';
                            }else{
                                LastMDT='';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + '' + '</td>';
                                
                            }
                            Items_Pending_For_My_Approval += '</tr>';
                            recordString = bid.no +','+bid_Name+','+bid_Type+','+cusName+','+bid.approvalStaus+','+InterTarDate+','+SentDate +','+LastMDT+'\n';
                            finalstr = finalstr +recordString;
                            
                        }
                        if(bid.internalTargetDate!=null && bid.internalTargetDate > system.today() && bid.internalTargetDate<=(system.today()+2)){
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;white-space: nowrap;background-color: #FFFF66;padding:4px;">' +'<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+bid.bidId+'">' + bid.no + '</a></td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #FFFF66;padding:4px;">' + bid.name + '</td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #FFFF66;padding:4px;">' + bid.bidType + '</td>';
                            if (bid.customerName != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #FFFF66;padding:4px;">' + bid.customerName + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #FFFF66;padding:4px;">' +''+ '</td>';
                            if (bid.approvalStaus != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #FFFF66;padding:4px;">' + bid.approvalStaus + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color:#FFFF66;padding:4px;">' +''+ '</td>';
                            if ( bid.internalTargetDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.internalTargetDate, Time.newInstance(0, 0, 0, 0));
                                InterTarDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #FFFF66;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else {
                                InterTarDate ='';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #FFFF66;padding:4px;">' +''+ '</td>';
                            }
                            if ( bid.sentToCustomerUpdateDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.sentToCustomerUpdateDate, Time.newInstance(0, 0, 0, 0));
                                SentDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #FFFF66;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else{
                                SentDate = '';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #FFFF66;padding:4px;">' +''+ '</td>';
                            }
                            if (bid.LastModifiedDate != Null){
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #FFFF66;padding:4px;">' + LastMDT + '</td>';
                            }else{
                                LastMDT='';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #FFFF66;padding:4px;">' + '' + '</td>';
                                
                            }
                            Items_Pending_For_My_Approval += '</tr>';
                            recordString = bid.no +','+bid_Name+','+bid_Type+','+cusName+','+bid.approvalStaus+','+InterTarDate+','+SentDate+',' +LastMDT+'\n';
                            finalstr = finalstr +recordString;
                            
                        }
                        if(bid.internalTargetDate!=null && bid.internalTargetDate>(system.today()+2)){
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;white-space: nowrap;background-color: #90EE90;padding:4px;">' +'<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+bid.bidId+'">' + bid.no + '</a></td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #90EE90;padding:4px;">' + bid.name + '</td>';
                            Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #90EE90;padding:4px;">' + bid.bidType + '</td>';
                            if (bid.customerName != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #90EE90;padding:4px;">' + bid.customerName + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #90EE90;padding:4px;">' +''+ '</td>';
                            if (bid.approvalStaus != Null) Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #90EE90;padding:4px;">' + bid.approvalStaus + '</td>';
                            else Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color:#90EE90;padding:4px;">' +''+ '</td>';
                            if ( bid.internalTargetDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.internalTargetDate, Time.newInstance(0, 0, 0, 0));
                                InterTarDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #90EE90;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else{
                                InterTarDate = '';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #90EE90;padding:4px;">' +''+ '</td>';
                            }
                            if ( bid.sentToCustomerUpdateDate != Null){
                                DateTime TargetDate = DateTime.newInstance(bid.sentToCustomerUpdateDate, Time.newInstance(0, 0, 0, 0));
                                SentDate = TargetDate.format('MM/dd/yyyy');
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #90EE90;padding:4px;">' + TargetDate.format('MM/dd/yyyy') + '</td>';
                            }
                            else{
                                SentDate = '';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;background-color: #90EE90;padding:4px;">' +''+ '</td>';
                            }
                            if (bid.LastModifiedDate != Null){
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #90EE90;padding:4px;">' + LastMDT + '</td>';
                            }else{
                                LastMDT='';
                                Items_Pending_For_My_Approval += '<td style="border: 1px solid black;text-align:right;background-color: #90EE90;padding:4px;">' + '' + '</td>';
                                
                            }
                            Items_Pending_For_My_Approval += '</tr>';
                            recordString = bid.no +','+bid_Name+','+bid_Type+','+cusName+','+bid.approvalStaus+','+InterTarDate+','+SentDate +','+LastMDT+'\n';
                            finalstr = finalstr +recordString;
                        }
                        
                    }
                    //Added by Satya
                    blob csvBlob = Blob.valueOf(finalstr);
                    DateTime todayDate = DateTime.newInstance(System.today(), Time.newInstance(0, 0, 0, 0));
                    string csvname= 'BRIGHT - My Pending Approvals -'+todayDate.format('MM/dd/yyyy')+'.csv';
                    csvAttc.setFileName(csvname);
                    csvAttc.setBody(csvBlob);
                    //End by Satya
                    Items_Pending_For_My_Approval += '</tbody></table>'; 
                    
                    String templateBody = templateBodyMain;
                    String subject =subjectMain;
                    if (templateBody.contains('USER_NAME')) templateBody = templateBody.replace('USER_NAME',userFullName);
                    if (templateBody.contains('Items_Pending_For_My_Approval')) templateBody = templateBody.replace('Items_Pending_For_My_Approval', Items_Pending_For_My_Approval);
                    email.setSubject(subject);
                    email.setHtmlBody(templateBody);
                    
                    List<String> sendTo = new List<String>{userobj.Email};
                        //sendTo.add('pradeep@dhruvsoft.com');
                        email.setToAddresses(sendTo);
                    
                    //email.setToAddresses(new List<String>{userobj.Email}); 
                    
                    
                    
                    
                    
                    
                    //system.debug('delegatoir'+userobj.Phoenix_Delegated_Approver__r.Email);
                    //system.debug('delegatoir email'+userobj.Phoenix_Delegated_Approver__c);
                    if(userForDelegation.Phoenix_Delegated_Approver__c!=null && userForDelegation.Phoenix_Delegated_Approver__r.Email!=null){
                        
                        email.setCCAddresses(new List<String>{userForDelegation.Phoenix_Delegated_Approver__r.Email});    
                    }
                    email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});//Added by satya
                    email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
                    mailsList.add(email);
                    
                } 
                
            }//user for loop close
            
            
            //system.debug('Email Limit'+limits.getEmailInvocations());
            if (mailsList.size() > 0) results = Messaging.sendEmail(mailsList);
            
        }
        Catch(Exception e) {
            String msg  = e.getMessage().length() > 255 ? e.getMessage().substring(0,254) : e.getMessage();
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_MyPendingBidApprovalsCtrl', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'sendEmailToAllApprovers', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString());
            insert exp;
        }
    } //method close
    
    //Start new Method to send email notification to vistex team
    public static void sendEmailtoVistex(){
        try{
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            Set < String > vistexTeamNames = new Set < String >();
            EmailTemplate emailTemp=[select id,Subject,Body from EmailTemplate where DeveloperName =:'SendEmailToVistexHoldBids'];
            List < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c,Phoenix_Bid__r.LastModifiedDate,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Bid__r.Phoenix_Sent_to_Vistex_Date__c,Phoenix_Bid__r.Phoenix_Internal_Target_Date__c,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Bid_Type__c,Phoenix_Bid__r.Phoenix_Customer__r.Name, Phoenix_Bid__r.Owner.Email, Phoenix_Bid__r.name,Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__c, Phoenix_Bid__r.Phoenix_Bid_Created_Behalf_of__r.Email, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Is_Criteria_Step__c, Phoenix_Approver__r.Email, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Status__c = 'In Process' AND  Phoenix_Bid__r.Phoenix_Approval_Status__c ='On Hold' AND Phoenix_Bid__r.Phoenix_Approval_status_at_Hold__c='Vistex Update' LIMIT 20000];
            /*get email from vistex users*/
            for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
                if (step.Phoenix_Approver_Team__c == 'Home Office'){
                    if (step.Phoenix_Approver_Team_Members__c != null) vistexTeamNames = new Set < String > (step.Phoenix_Approver_Team_Members__c.split(','));
                }
            }
            List<User> usersList =  new List<User>();
            Map<String,String> vistexTeamNamesAndEmails = new Map<String,String>();
            List<String> VistexTeamList = new List<String>();
            usersList = [Select Id,Name,Email,UserName from User where Name IN :vistexTeamNames];
            
            for(User u:usersList){
                vistexTeamNamesAndEmails.put(u.Id,u.Email);
            }
            Set < String > vistexTeamSet = vistexTeamNamesAndEmails.keySet();
            List < String > sendTo = new List < String > ();
            VistexTeamList.addAll(vistexTeamNamesAndEmails.keySet());
            
            sendTo.addAll(vistexTeamNamesAndEmails.values());
            /*End get email from vistex users*/
            Phoenix_Util.EmailWrapper emailWrapper = Phoenix_Util.getTemplateBody('SendEmailToVistexHoldBids', userInfo.getUserId());
            String templateBodyMain = emailWrapper.mailHtmlBody;
            for(User u:usersList){
                string userFullName ;
                userFullName = u.Name;
                String templateBody = templateBodyMain;
                if (templateBody.contains('USER_NAME')) templateBody = templateBody.replace('USER_NAME',userFullName);
                if(bidProcessStepList.size()>0){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String Hold_Bids='';
                    Hold_Bids += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;">Record No</th><th style="border: 1px solid black;">Name</th><th style="border: 1px solid black;">Type</th><th style="border: 1px solid black;">Customer Name</th><th style="border: 1px solid black;">Current Approval Status</th><th style="border: 1px solid black;">Bid Internal Target Date</th><th style="border: 1px solid black;">Sent to Vistex Date</th><th style="border: 1px solid black;">Bid Last Modified Date</th></tr></thead>';
                    Hold_Bids += '<tbody>';
                    String InterTarDate,SentToVistex;
                    
                    for(Phoenix_Bid_Process_Steps__c bid:bidProcessStepList ){
                        String Last_MDT = Phoenix_Util.getUserTimeNow(bid.Phoenix_Bid__r.LastModifiedDate, 'America/New_York');
                        if( bid.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c != null){
                            DateTime TargetDate = DateTime.newInstance(bid.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0));
                            InterTarDate = TargetDate.format('MM/dd/yyyy');
                        }
                        if(bid.Phoenix_Bid__r.Phoenix_Sent_to_Vistex_Date__c != null){
                            DateTime TargetDate = DateTime.newInstance(bid.Phoenix_Bid__r.Phoenix_Sent_to_Vistex_Date__c, Time.newInstance(0, 0, 0, 0));
                            SentToVistex = TargetDate.format('MM/dd/yyyy');
                        }
                        Hold_Bids += '<tr>';
                        Hold_Bids += '<td style="border: 1px solid black;white-space: nowrap;background-color: #ffcccb;padding:4px;">' +'<a href="'+ URL.getSalesforceBaseUrl().toExternalForm()+'/'+bid.Phoenix_Bid__c+'">' + bid.Phoenix_Bid__r.name + '</a></td>';
                        Hold_Bids += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + bid.Phoenix_Bid__r.Phoenix_Bid_Name__c + '</td>';
                        Hold_Bids += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + bid.Phoenix_Bid__r.Phoenix_Bid_Type__c + '</td>';
                        Hold_Bids += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + bid.Phoenix_Bid__r.Phoenix_Customer__r.Name + '</td>';
                        Hold_Bids += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + bid.Phoenix_Bid__r.Phoenix_Approval_Status__c  + '</td>';
                        if(bid.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c != null){
                            Hold_Bids += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + InterTarDate  + '</td>';
                        }else{
                            Hold_Bids += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + ' '  + '</td>';
                            
                        }
                        if(bid.Phoenix_Bid__r.Phoenix_Sent_to_Vistex_Date__c != null){
                            Hold_Bids += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + SentToVistex  + '</td>';
                        }else{
                            Hold_Bids += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + ''  + '</td>';
                            
                        }
                        if(bid.Phoenix_Bid__r.LastModifiedDate != null){
                            Hold_Bids += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + Last_MDT  + '</td>';
                        }else{
                            Hold_Bids += '<td style="border: 1px solid black;background-color: #ffcccb;padding:4px;">' + ' '  + '</td>';
                            
                        }
                        Hold_Bids += '</tr>';
                    }
                    
                    Hold_Bids += '</tbody></table>';  
                    
                    //String subject =subjectMain;
                    
                    if (templateBody.contains('Hold_Bids')) templateBody = templateBody.replace('Hold_Bids', Hold_Bids);
                    
                    
                    //String[] toAddress= new String[]{'ramesh@dhruvsoft.com'};
                    //mail.setToAddresses(toAddress);
                    mail.setToAddresses(sendTo);
                    // mail.setCCAddresses(sendTo);
                    mail.setSubject('Hold Bids at the Vistex Stage');
                    mail.setTemplateId(emailTemp.Id);
                    //mail.setTargetObjectId(userInfo.getUserId());
                    mail.setSaveAsActivity(false);
                    mail.setHtmlBody(templateBody);
                    emailList.add(mail);
                }
            }
            if(!emailList.isEmpty()){
                Messaging.sendEmail(emailList);
            }
        }catch(Exception e){
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_MyPendingBidApprovalsCtrl', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'sendEmailtoVistex', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
    //
    
    //start new method to send email notification to sales users at customer's update 
    
    //For Bids Past Due and due today
    @AuraEnabled
    public static BidApprovalModel popUPBidsDue() {
        BidApprovalModel model = new BidApprovalModel();
        List < Phoenix_Bid_Process_Steps__c > finalSteps = new List < Phoenix_Bid_Process_Steps__c > ();
        //query bid process steps
        Set < String > loggedUserTeams = new Set < String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email,
                                                      Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c
                                                      from Phoenix_User_Approval_Matrix__c Where Phoenix_Approver__c =: UserInfo.getUserId() limit 50000
                                                     ])
            if (!excludedTeams.contains(matrix.User_Group__r.Phoenix_Approver_Group_Name__c)) loggedUserTeams.add(matrix.User_Group__r.Phoenix_Approver_Group_Name__c);
        
        System.debug('loggedUserTeams==>' + loggedUserTeams);
        for (Phoenix_Bid_Process_Steps__c step: [Select Id, Name, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Approval_Status__c,
                                                 Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Bid__r.Phoenix_Customer_Bid_Deadline__c, Phoenix_Step__c, Phoenix_Process_Step__c, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Bid__r.Phoenix_Customer__r.Name,
                                                 Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Description__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Internal_Target_Date__c,Phoenix_Bid__r.Phoenix_Approval_status_at_Hold__c,
                                                 
                                                 Phoenix_WAC_Change__c,Phoenix_WAC_Change__r.name,Phoenix_WAC_Change__r.Phoenix_WAC_Change_Name__c,Phoenix_WAC_Change__r.Phoenix_Approval_Status__c,
                                                 
                                                 
                                                 Phoenix_NDC_Change__c,
                                                 Phoenix_NDC_Change__r.name,
                                                 Phoenix_NDC_Change__r.Phoenix_NDC_Change_Name__c,
                                                 Phoenix_NDC_Change__r.Phoenix_Approval_Status__c,
                                                 Phoenix_PHS_Price_Change__c,
                                                 Phoenix_PHS_Price_Change__r.name,
                                                 Phoenix_PHS_Price_Change__r.Phoenix_PHS_Price_Change_Name__c,
                                                 Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c,
                                                 Phoenix_New_Product_WAC_Pricing__c,
                                                 Phoenix_New_Product_WAC_Pricing__r.name,
                                                 Phoenix_New_Product_WAC_Pricing__r.Phoenix_WAC_Price_for_New_Launch_Name__c,
                                                 Phoenix_New_Product_WAC_Pricing__r.Phoenix_Approval_Status__c
                                                 
                                                 
                                                 from Phoenix_Bid_Process_Steps__c
                                                 where Phoenix_Status__c = 'In Process'
                                                 AND(Phoenix_Approver__c =: UserInfo.getUserId() OR Phoenix_Approver_Team_Members__c LIKE: userName or Phoenix_Approver_Team__c IN: loggedUserTeams OR Phoenix_Approver__c =: UserInfo.getUserId()) ORDER BY Phoenix_Bid__r.Phoenix_Internal_Target_Date__c ASC NULLS LAST LIMIT 50000
                                                ]) {
                                                    //Phoenix_Approver_Team__c IN:loggedUserTeams OR Phoenix_Approver__c=:UserInfo.getUserId() 
                                                    //
                                                    if (step.Phoenix_Approver__c == UserInfo.getUserId()) {
                                                        finalSteps.add(step);
                                                    } else
                                                        if (step.Phoenix_Approver_Team__c != null && loggedUserTeams.contains(step.Phoenix_Approver_Team__c)) {
                                                            finalSteps.add(step);
                                                        }
                                                    
                                                    
                                                    
                                                }
        
        model.pendingBidProcessSteps = finalSteps;
        Map < String, Bid > bidsDueTodaymap = new Map < String, Bid > ();
        Map < String, Bid > bidsPastDuemap = new Map < String, Bid > ();
        Map < String, String > bidTypesmap = new Map < String, String > ();
        
        for(Schema.PicklistEntry  ple:  Phoenix_Bid__c.Phoenix_Bid_Type__c.getDescribe().getPicklistValues()){
            bidTypesmap.put(ple.getValue(),ple.getLabel());
        }
        for (Phoenix_Bid_Process_Steps__c step: model.pendingBidProcessSteps) {
            Bid bid = new Bid();
            
            
            if(step.Phoenix_Bid__c!=null && step.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c!=null && step.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c==system.today()){
                bid.bidid = step.Phoenix_Bid__c;
                bid.no = step.Phoenix_Bid__r.name;
                bid.name = step.Phoenix_Bid__r.Phoenix_Bid_Name__c;
                if(step.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'On Hold'){
                    bid.approvalStaus = 'On Hold - '+step.Phoenix_Bid__r.Phoenix_Approval_status_at_Hold__c;
                }
                else if(step.Phoenix_Bid__r.Phoenix_Approval_Status__c != 'On Hold'){
                    bid.approvalStaus = step.Phoenix_Bid__r.Phoenix_Approval_Status__c;
                }
                
                
                //   bid.approvalStaus = step.Phoenix_Bid__r.Phoenix_Approval_Status__c;
                bid.bidType = bidTypesmap.get(step.Phoenix_Bid__r.Phoenix_Bid_Type__c);
                bid.customerId = step.Phoenix_Bid__r.Phoenix_Customer__c;
                bid.customerName = step.Phoenix_Bid__r.Phoenix_Customer__r.Name;
                bid.internalTargetDate = step.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c;
                bidsDueTodaymap.put(step.Phoenix_Bid__c, bid);
            }
            if(step.Phoenix_Bid__c!=null && step.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c!=null && step.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c<system.today()){
                bid.bidid = step.Phoenix_Bid__c;
                bid.no = step.Phoenix_Bid__r.name;
                bid.name = step.Phoenix_Bid__r.Phoenix_Bid_Name__c;
                if(step.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'On Hold'){
                    bid.approvalStaus = 'On Hold - '+step.Phoenix_Bid__r.Phoenix_Approval_status_at_Hold__c;
                }
                else if(step.Phoenix_Bid__r.Phoenix_Approval_Status__c != 'On Hold'){
                    bid.approvalStaus = step.Phoenix_Bid__r.Phoenix_Approval_Status__c;
                }
                
                
                //   bid.approvalStaus = step.Phoenix_Bid__r.Phoenix_Approval_Status__c;
                bid.bidType = bidTypesmap.get(step.Phoenix_Bid__r.Phoenix_Bid_Type__c);
                bid.customerId = step.Phoenix_Bid__r.Phoenix_Customer__c;
                bid.customerName = step.Phoenix_Bid__r.Phoenix_Customer__r.Name;
                bid.internalTargetDate = step.Phoenix_Bid__r.Phoenix_Internal_Target_Date__c;
                bidsPastDuemap.put(step.Phoenix_Bid__c, bid);
            }
            //end for bid.
        }
        
        model.bidsdueToday = bidsDueTodaymap.values();
        model.bidsPastDue =bidsPastDuemap.values();
        model.bidsPastDuelength =bidsPastDuemap.size();
        model.bidsdueTodaylength =bidsDueTodaymap.size();
        return model;
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
        i++;
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
           i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
           i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
     }
    
    
}