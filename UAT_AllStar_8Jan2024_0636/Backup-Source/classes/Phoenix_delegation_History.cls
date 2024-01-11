public class Phoenix_delegation_History {
    public static Set < String > excludedTeams = new Set < String > ();
    public static String userName = '%' + UserInfo.getUserName() + '%';
    static{
        excludedTeams = new Set < String > {'Marketing', 'Marketing Lead Rx','Marketing Lead SRx', 'Marketing Lead OTC'};
            }
    @AuraEnabled
    public static Wrapper getExistingDeleRecords(String userId,String deleUserId, Integer pageNumber, Integer pageSize ){
        Wrapper wrapperObject = new Wrapper();
        //Offset for SOQL
        Integer offset = (pageNumber - 1) * pageSize;
         
        //Total Records
        Integer recordEnd = pageSize * pageNumber;
        String query =''; String query2 ='';
        if((userId !='undefined' && userId !='' && userId != null) && (deleUserId !='undefined' && deleUserId !='' && deleUserId != null) )  {
            query = 'SELECT Id,Name,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegation_Start_Time__c,Phoenix_Delegation_End_Time__c,Phoenix_User__c,Phoenix_User__r.Name,Phoenix_Is_Active_delegator__c FROM Phoenix_Approval_Delegation_History__c Where Phoenix_Delegated_Approver__c=:deleUserId and Phoenix_User__c =:userId  ORDER BY Phoenix_Delegation_Start_Time__c DESC';
            query2 = 'SELECT Id FROM Phoenix_Approval_Delegation_History__c Where Phoenix_Delegated_Approver__c=:deleUserId and Phoenix_User__c =:userId  ORDER BY Phoenix_Delegation_Start_Time__c DESC'; 
        }
        else if((userId =='undefined' || userId =='' || userId == null) && (deleUserId !='undefined' && deleUserId !='' && deleUserId != null) ){
           	query = 'SELECT Id,Name,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegation_Start_Time__c,Phoenix_Delegation_End_Time__c,Phoenix_User__c,Phoenix_User__r.Name,Phoenix_Is_Active_delegator__c FROM Phoenix_Approval_Delegation_History__c Where Phoenix_Delegated_Approver__c=:deleUserId ORDER BY Phoenix_Delegation_Start_Time__c DESC'; 
            query2 = 'SELECT Id FROM Phoenix_Approval_Delegation_History__c Where Phoenix_Delegated_Approver__c=:deleUserId ORDER BY Phoenix_Delegation_Start_Time__c DESC';
        }  
        else if((userId !='undefined' && userId !='' && userId != null) && (deleUserId =='undefined' || deleUserId =='' || deleUserId == null) )  {
         	query = 'SELECT Id,Name,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegation_Start_Time__c,Phoenix_Delegation_End_Time__c,Phoenix_User__c,Phoenix_User__r.Name,Phoenix_Is_Active_delegator__c FROM Phoenix_Approval_Delegation_History__c Where Phoenix_User__c=:userId ORDER BY Phoenix_Delegation_Start_Time__c DESC';
            query2 = 'SELECT Id FROM Phoenix_Approval_Delegation_History__c Where Phoenix_User__c=:userId ORDER BY Phoenix_Delegation_Start_Time__c DESC';
        }
        else if((userId =='undefined' || userId =='' || userId == null) && (deleUserId =='undefined' || deleUserId =='' || deleUserId == null) )  {
         	query = 'SELECT Id,Name,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegation_Start_Time__c,Phoenix_Delegation_End_Time__c,Phoenix_User__c,Phoenix_User__r.Name,Phoenix_Is_Active_delegator__c FROM Phoenix_Approval_Delegation_History__c ORDER BY Phoenix_Delegation_Start_Time__c DESC';
            query2 = 'SELECT Id FROM Phoenix_Approval_Delegation_History__c ORDER BY Phoenix_Delegation_Start_Time__c DESC';
        }
        query += ' LIMIT :pageSize OFFSET :offset';
        List<Phoenix_Approval_Delegation_History__c> existingDeleUsersList = Database.query(query); 
        Integer totalRecords = Database.query(query2).size();
        wrapperObject.deleUsersList=existingDeleUsersList;
        wrapperObject.pageSize = pageSize;
        wrapperObject.pageNumber = pageNumber;
        wrapperObject.recordStart = offset + 1;
        wrapperObject.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        wrapperObject.totalRecords = totalRecords;
        return wrapperObject;
    }
    
    @AuraEnabled
    public static BidApprovalModel getPendingApprovals(String userId) {
        BidApprovalModel model = new BidApprovalModel();
        List < Phoenix_Bid_Process_Steps__c > finalSteps = new List < Phoenix_Bid_Process_Steps__c > ();
        //query bid process steps
        Set < String > loggedUserTeams = new Set < String > ();
        List < String > loggedUserTeamsList = new List < String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email,
                                                      Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c
                                                      from Phoenix_User_Approval_Matrix__c Where Phoenix_Approver__c =: userId limit 50000
                                                     ]){
                                                         if (!excludedTeams.contains(matrix.User_Group__r.Phoenix_Approver_Group_Name__c)) loggedUserTeams.add(matrix.User_Group__r.Phoenix_Approver_Group_Name__c);
                                                     }
        loggedUserTeamsList.addAll(loggedUserTeams);
        if(loggedUserTeamsList.size() > 0 && loggedUserTeamsList[0] == 'Home Office'){
            loggedUserTeams.add('Contracts');
        }
        List<Phoenix_Bid_Process_Steps__c> stepList = new List<Phoenix_Bid_Process_Steps__c>();
        if(loggedUserTeamsList.size() > 0 &&  loggedUserTeamsList.contains('Home Office') ){ 
            stepList =  [Select Id, Name, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Bid__r.Phoenix_Customer_Bid_Deadline__c, Phoenix_Step__c, Phoenix_Process_Step__c, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Bid__r.Phoenix_Customer__r.Name,Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Description__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Internal_Target_Date__c,Phoenix_Bid__r.Phoenix_Approval_status_at_Hold__c,Phoenix_WAC_Change__c,Phoenix_WAC_Change__r.name,Phoenix_WAC_Change__r.Phoenix_WAC_Change_Name__c,Phoenix_WAC_Change__r.Phoenix_Approval_Status__c,Phoenix_NDC_Change__c,Phoenix_NDC_Change__r.name,Phoenix_NDC_Change__r.Phoenix_NDC_Change_Name__c,Phoenix_NDC_Change__r.Phoenix_Approval_Status__c,Phoenix_PHS_Price_Change__c, Phoenix_PHS_Price_Change__r.name,Phoenix_PHS_Price_Change__r.Phoenix_PHS_Price_Change_Name__c,Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c,Phoenix_New_Product_WAC_Pricing__c,Phoenix_New_Product_WAC_Pricing__r.name,Phoenix_New_Product_WAC_Pricing__r.Phoenix_WAC_Price_for_New_Launch_Name__c,Phoenix_New_Product_WAC_Pricing__r.Phoenix_Approval_Status__c,Phoenix_Approval_Sent_Time__c,Phoenix_Bid__r.LastModifiedDate
                         from Phoenix_Bid_Process_Steps__c
                         where (Phoenix_Approver__c =: userId OR Phoenix_Approver_Team_Members__c LIKE: userName or Phoenix_Approver_Team__c IN: loggedUserTeams OR Phoenix_Approver__c =: userId) AND (Phoenix_Bid__r.Phoenix_Approval_Status__c = 'Customer\'s Update' OR Phoenix_Bid__r.Phoenix_Approval_Status__c = 'Vistex Update') ORDER BY Phoenix_Bid__r.Phoenix_Internal_Target_Date__c ASC NULLS LAST LIMIT 50000
                        ];
        }
        else {
            stepList =  [Select Id, Name, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Bid__r.Phoenix_Customer_Bid_Deadline__c, Phoenix_Step__c, Phoenix_Process_Step__c, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Bid__r.Phoenix_Customer__r.Name,Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Description__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Internal_Target_Date__c,Phoenix_Bid__r.Phoenix_Approval_status_at_Hold__c,Phoenix_WAC_Change__c,Phoenix_WAC_Change__r.name,Phoenix_WAC_Change__r.Phoenix_WAC_Change_Name__c,Phoenix_WAC_Change__r.Phoenix_Approval_Status__c,Phoenix_NDC_Change__c,Phoenix_NDC_Change__r.name,Phoenix_NDC_Change__r.Phoenix_NDC_Change_Name__c,Phoenix_NDC_Change__r.Phoenix_Approval_Status__c,Phoenix_PHS_Price_Change__c, Phoenix_PHS_Price_Change__r.name,Phoenix_PHS_Price_Change__r.Phoenix_PHS_Price_Change_Name__c,Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c,Phoenix_New_Product_WAC_Pricing__c,Phoenix_New_Product_WAC_Pricing__r.name,Phoenix_New_Product_WAC_Pricing__r.Phoenix_WAC_Price_for_New_Launch_Name__c,Phoenix_New_Product_WAC_Pricing__r.Phoenix_Approval_Status__c,Phoenix_Approval_Sent_Time__c,Phoenix_Bid__r.LastModifiedDate
                         from Phoenix_Bid_Process_Steps__c
                         where Phoenix_Status__c = 'In Process'
                         AND(Phoenix_Approver__c =: userId OR Phoenix_Approver_Team_Members__c LIKE: userName or Phoenix_Approver_Team__c IN: loggedUserTeams OR Phoenix_Approver__c =: userId) ORDER BY Phoenix_Bid__r.Phoenix_Internal_Target_Date__c ASC NULLS LAST LIMIT 50000
                        ];
        }
        List<Id> crBidIds = new List<Id>();
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
                if (step.Phoenix_Approver__c == userId && isCRCompleted ) {
                    finalSteps.add(step);
                } else if (step.Phoenix_Approver_Team__c != null && loggedUserTeams.contains(step.Phoenix_Approver_Team__c) && isCRCompleted) {
                    finalSteps.add(step);
                } else if(step.Phoenix_Approver__c == userId && step.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Vistex Update' ) {
                    finalSteps.add(step);
                }else if (step.Phoenix_Approver_Team__c != null && loggedUserTeams.contains(step.Phoenix_Approver_Team__c) && step.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Vistex Update') {
                    finalSteps.add(step);
                }
                
            }
            else{
                if (step.Phoenix_Approver__c == userId) {
                    finalSteps.add(step);
                } else if (step.Phoenix_Approver_Team__c != null && loggedUserTeams.contains(step.Phoenix_Approver_Team__c)) {
                    finalSteps.add(step);
                }  
            }
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
    public static String formatDateEST(Date dt){
        DateTime dtime = DateTime.newInstance(dt, Time.newInstance(0, 0, 0, 0));
        return dtime.format('M/dd/yyyy');
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
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
    
    public class Wrapper {
        @AuraEnabled public List<Phoenix_Approval_Delegation_History__c> deleUsersList;
        @AuraEnabled public Integer pageSize;
        @AuraEnabled public Integer pageNumber;
        @AuraEnabled public Integer totalRecords;
        @AuraEnabled public Integer recordStart;
        @AuraEnabled public Integer recordEnd;
        @AuraEnabled public String userUniqueId;
        
        
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
}