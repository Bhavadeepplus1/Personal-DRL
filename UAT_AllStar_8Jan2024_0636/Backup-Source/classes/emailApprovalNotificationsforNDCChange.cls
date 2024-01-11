public without sharing class emailApprovalNotificationsforNDCChange {
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
    public static void approvalEmails(Id objId, List < Phoenix_Bid_Process_Steps__c > nextSteps){
        	  try{
                  System.debug('in approvalEmails');
                   Set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
                   Map < Id, User > usersMap = new Map < Id, User > ([SELECT Id, Name, Email,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegated_Approver__r.Email FROM User]);
                  Integer sNo =0;String content = '';String title = '';String subject = ''; 
                  User creatByName = new User();
                    String ndcChangeName,currentPrdFamily,proposedPrdFamily,description,approvalStatus,creatBy_Name;
                   	Phoenix_NDC_Change__c ndcChange = [Select Id, Name,CreatedBy.Name,Phoenix_Description__c,Phoenix_Current_Product_Family__c,Phoenix_Proposed_Product_Family__c, Owner.Email, Phoenix_Approval_Status__c from Phoenix_NDC_Change__c WHERE Id =: objId LIMIT 1];
                    if(ndcChange != null){
                        ndcChangeName = ndcChange.Name != null ? ndcChange.Name : '';
                        currentPrdFamily = ndcChange.Phoenix_Current_Product_Family__c != null ? ndcChange.Phoenix_Current_Product_Family__c : '';
                        proposedPrdFamily = ndcChange.Phoenix_Proposed_Product_Family__c != null ? ndcChange.Phoenix_Proposed_Product_Family__c : '';
                        description = ndcChange.Phoenix_Description__c != null ? ndcChange.Phoenix_Description__c : '';
                        //ndcId = ndcChange.Id;
                        approvalStatus = ndcChange.Phoenix_Approval_Status__c != null ? ndcChange.Phoenix_Approval_Status__c :'';
                        creatByName = ndcChange.CreatedBy;
                        creatBy_Name = creatByName.Name;
                        
                    }
                    /* adding to address*/
                    //set < String > toAddress = new set < String > ();
                    //set < String > ccEmailIds = new set < String > ();
                    //List<String> approverList = new List<String>();
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
                            //approverList.add(step.Phoenix_Approver__r.Name);
                            
                        }
                    }
                    /*to and cc address*/
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
                            
                            
                            //   if (templateBody.contains('Team')) templateBody = templateBody.replaceFirst('Team', step.Phoenix_Approver__r.Name);
                        }
                    }
                    if (Label.Phoenix_Contracts_DL != null) ccEmailIds.addAll(Label.Phoenix_Contracts_DL.split(','));
                    ccEmailIds.addAll(allPeopleInvolvedEmailsSet);
                    for (string emailId: toAddress) {
                        if (ccEmailIds.contains(emailId))
                            ccEmailIds.remove(emailId);
                    }
                    
                    If(ccEmailIds != null && ccEmailIds.contains('mkalawadia@drreddys.com'))ccEmailIds.remove('mkalawadia@drreddys.com');
                    //ccEmailIds.add('naseershaik@drreddys.com');
                    /* end to and cc address*/
                    
                    List < Phoenix_NDC_Change_Line_Item__c > ndcLineItemsList = [Select Phoenix_Account__r.Name,Phoenix_Contract__r.Name,Phoenix_Current_Product__c, Phoenix_Current_Product__r.Name, Phoenix_Current_Product_NDC__c, Phoenix_Current_Product_Pack_Size__c, Phoenix_Proposed_Product__c, Phoenix_Proposed_Product__r.Name, Phoenix_Proposed_Product_NDC__c, Phoenix_Proposed_Product_Pack_Size__c FROM Phoenix_NDC_Change_Line_Item__c where Phoenix_NDC_Change__c =: objId AND  Phoenix_Final_Status__c != 'Not Approved'];
                    string tableData = '';
                    //String content,subject,title ;
                    integer countOfProducts = 0;
                    if(stepName  != 'Supply Chain Approval' && stepName  != 'Finance Approval' &&stepName  != 'Vistex Update'){
                        //tableData += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 8px 8px;"><b>NDC Change Line Item(s):</b></td></tr></table>';
                        tableData += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>NDC Change Line Item(s):</b></td></tr></table>';
                        
                    }
                    
                    if(stepName  == 'Finance Approval' ||stepName  == 'Vistex Update'){
                        //tableData += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 8px 8px;"><b>NDC Line Item(s):</b></td></tr></table>';
                        tableData += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>NDC Line Item(s):</b></td></tr></table>';
                        
                    }
                    if(stepName  == 'Supply Chain Approval'){
                        tableData += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 12px 8px;"><b>NDC Product(s):</b></td></tr></table>';
                        
                        //tableData += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 8px 8px;"><b>NDC Product(s):</b></td></tr></table>';
                    }
                    tableData += '<table style="border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 36px;"><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;min-width:40px;" rowspan="2">S. No</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left" rowspan="2">Account</th><th style="border: 1px solid black;padding:4px 8px;background-color: #d4bdf8;text-align:left" rowspan="2">Contract</th><th style="border: 1px solid black;padding:4px; background-color: #B8D0F8;text-align:center" colspan = "3">Current</th><th style="border: 1px solid black;padding:4px; background-color: #FAD385;text-align:center" colspan = "3">Proposed</th></tr>';
                    tableData += '<tr><th style="width: 36px;"><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Current Product</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left">Current Product NDC</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left">Current Product Pack Size</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left">Proposed Product</th><th  style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Proposed Product NDC</th><th style="border: 1px solid black;padding:4px 8px; background-color: #d4bdf8;text-align:left;">Proposed Product Pack Size</th></tr></thead>';
                    //tableData += '<table style="border-collapse: collapse;padding:4px"><thead><tr><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 6%;">S. No</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 10%;">Account</th><th style="border: 1px solid black;padding:4px;background-color: #d4bdf8;width: 10%;">Contract</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 14%;">Current Product</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 14%;">Current Product NDC</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 14%;">Current Product Pack Size</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width:14%;">Proposed Product</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 14%;">Proposed Product NDC</th><th style="border: 1px solid black;padding:4px; background-color: #d4bdf8;width: 14%;">Proposed Product Pack Size</th></tr></thead>';
                    tableData += '<tbody>';
                    // integer sNo = 0;
                    System.debug('in above for loop'+ndcLineItemsList.size());
                    for (Phoenix_NDC_Change_Line_Item__c ndcItem: ndcLineItemsList) {
                        System.debug('ndcItem.Phoenix_Account__r.Name==>'+ndcItem.Phoenix_Account__r.Name);
                        System.debug('ndcItem.Phoenix_Contract__r.Name== '+ndcItem.Phoenix_Contract__r.Name );
                        System.debug('ndcItem.Phoenix_Current_Product__r.Name '+ndcItem.Phoenix_Current_Product__r.Name );
                        System.debug('ndcItem.Phoenix_Current_Product_NDC__c== '+ndcItem.Phoenix_Current_Product_NDC__c );
                      	System.debug('ndcItem.Phoenix_Current_Product_Pack_Size__c '+ndcItem.Phoenix_Current_Product_Pack_Size__c);
                      	System.debug('ndcItem.Phoenix_Proposed_Product__r.Name '+ndcItem.Phoenix_Proposed_Product__r.Name);
                      	System.debug('ndcItem.Phoenix_Proposed_Product_NDC__c '+ndcItem.Phoenix_Proposed_Product_NDC__c);
                      	System.debug('ndcItem.Phoenix_Proposed_Product_Pack_Size__c== '+ndcItem.Phoenix_Proposed_Product_Pack_Size__c);

                        countOfProducts += 1;
                        sNo++;
                        tableData += '<tr>';
                        tableData += '<td style="width: 26px;"></td>';
                        tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + sNo + '</td>';
                        if (ndcItem.Phoenix_Account__r.Name != null){
                            tableData += '<td style="border: 1px solid black;text-align:left;padding: 4px 8px;">' + ndcItem.Phoenix_Account__r.Name + '</td>';
                        }
                        else {
                            tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        }
                        if (ndcItem.Phoenix_Contract__r.Name != null) {
                            tableData += '<td style="border: 1px solid black;text-align:left;padding: 4px 8px;">' + ndcItem.Phoenix_Contract__r.Name + '</td>';
                        } else {
                            tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        }
                        
                        if (ndcItem.Phoenix_Current_Product__r.Name != null){
                            tableData += '<td style="border: 1px solid black;text-align:left;padding: 4px 8px;">' + ndcItem.Phoenix_Current_Product__r.Name + '</td>';
                        }
                        else{
                            tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        }
                        if (ndcItem.Phoenix_Current_Product_NDC__c != null){
                            tableData += '<td style="border: 1px solid black;text-align:right;padding: 4px 8px;">'+ ndcItem.Phoenix_Current_Product_NDC__c + '</td>';
                        }
                        else{
                            tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        }
                        if (ndcItem.Phoenix_Current_Product_Pack_Size__c != null){
                            tableData += '<td style="border: 1px solid black;text-align:right;padding: 4px 8px;">' + ndcItem.Phoenix_Current_Product_Pack_Size__c + '</td>';
                        }
                        else{
                            tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        }
                        if (ndcItem.Phoenix_Proposed_Product__r.Name != null) {
                            tableData += '<td style="border: 1px solid black;text-align:left;padding: 4px 8px;">' + ndcItem.Phoenix_Proposed_Product__r.Name + '</td>';
                        }
                        else {
                            tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        }
                        if (ndcItem.Phoenix_Proposed_Product_NDC__c != null){
                            tableData += '<td style="border: 1px solid black;text-align:right;padding: 4px 8px;">' + ndcItem.Phoenix_Proposed_Product_NDC__c + '</td>';
                        }
                        else{
                            tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        }
                        if (ndcItem.Phoenix_Proposed_Product_Pack_Size__c != null) {
                            tableData += '<td style="border: 1px solid black;text-align:right;padding: 4px 8px;">' + ndcItem.Phoenix_Proposed_Product_Pack_Size__c + '</td>';
                        }
                        else {
                            tableData += '<td style="border: 1px solid black;text-align:center;padding: 4px;">' + '' + '</td>';
                        }
                        tableData += '</tr>';
                        
                    }
                    tableData += '</tbody></table>';
                   
                    if(stepName == 'Supply Chain Approval'){
                        System.debug('Supply Chain Approval');
                        //content = '<div style="color: black; margin: 20px 0px -10px 0px;padding:20px 40px 10px 40px;background-color: white;font-family:Sans-Serif;font-size:15px;">Dear Supply Planner Team,<br /><br />';
                        //content += creatBy_Name+'  <span style="">requires your approval of NDC change for the below mentioned Products in BRIGHT </span>'+ndcChangeName+'.<br/><br/>';
                        //content += '<div style="color: black; margin: 20px 0px -10px 0px;padding:10px 40px 10px 0px;background-color: white;"><div style="margin: auto;border-radius: 15px;width: 350px;text-align: center;padding: 20px;background-color: #d4bdf8;"><span style="background-color: #d4bdf8;font-size:22px"><b style="">'+countOfProducts+' <span style = "">NDC Line Items Need Approval</b></span></div><br/>';
                        content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear Supply Planner Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">'+creatBy_Name+' requires your approval of NDC change for the below mentioned Products in BRIGHT '+ndcChangeName+'. </td></tr></table>';
                        content += '<table align="center" style="background-color:#d4bdf8;border-radius: 15px;padding:20px;font-size: 18px;font-family: Sans-Serif;"><tr><th>'+countOfProducts+' NDC Line Items Need Approval</b></th></tr></table>';
                        
                    }
                    
                    if(stepName == 'Contract Team\'s Action'){
                        //initiator if creatBy_Name wrong use initiator
                        // content = '<div style="color: black; margin: 20px 0px -10px 0px;padding:20px 40px 10px 40px;background-color: white;font-family:Sans-Serif;font-size:15px;">Dear Contracts Team,<br /><br />';
                        // content += creatBy_Name+' <span style="">submitted a </span>'+ndcChangeName+' <span style ="">which has completed the NDC Change approval workflow on BRIGHT. Below are the details of the NDC Change for your review and further processing. You will now be able to generate a Proposal for submission and notify the Customer.</span><br/><br/>';
                        content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear Contracts Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;">'+creatBy_Name+' submitted a '+ndcChangeName+' which has completed the NDC Change approval workflow on BRIGHT. Below are the details of the NDC Change for your review and further processing. You will now be able to generate a Proposal for submission and notify the Customer. </td></tr></table>';
                        
                    }
                    if(stepName == 'Customer\'s Update'){
                        //content = '<div style="color: black; margin: 20px 0px -10px 0px;padding:20px 40px 10px 40px;background-color: white;font-family:Sans-Serif;font-size:15px;">Dear VISTEX Team / Demand Planning Team,<br /><br />';
                        //content +=  '<span style="">We want to inform you that the Contracts Team has submitted the new customer response for NDC Change </span>'+ndcChangeName+'. <span style="">Please review and process the item(s) in the tables below and update the NDC Change information in VISTEX.</span><br/><br/>';
                        content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear VISTEX Team / Demand Planning Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;"> We want to inform you that the Contracts Team has submitted the new customer response for NDC Change '+ndcChangeName+'. Please review and process the item(s) in the tables below and update the NDC Change information in VISTEX. </td></tr></table>';
                        
                    }
                    if(stepName == 'Finance Approval'){
                        //content = '<div style="color: black; margin: 20px 0px -10px 0px;padding:20px 40px 10px 40px;background-color: white;font-family:Sans-Serif;font-size:15px;">Dear Finance Team,<br /><br />';
                        //content += creatBy_Name+' <span style ="">requires your approval of NDC change for the below mentioned Products in BRIGHT </span>'+ndcChangeName+'.<br /><br />';
                        //content += '<div style="color: black; margin: 20px 0px -10px 0px;padding:10px 40px 10px 0px;background-color: white;"><div style="margin: auto;border-radius: 15px;width: 350px;text-align: center;padding: 20px;background-color: #d4bdf8;"><span style="background-color: #d4bdf8;"><b>'+countOfProducts+' <span style="">NDC Line Items Need Approval</b></span></div><br/>';
                        content = '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:12px 8px 0px 8px;">Dear Finance Team,</td></tr><tr><td style="width: 24px;"></td><td style="padding: 8px;"> '+creatBy_Name+ ' requires your approval of NDC change for the below mentioned Products in BRIGHT '+ndcChangeName+'. </td></tr></table>';
                        content += '<table align="center" style="background-color:#d4bdf8;border-radius: 15px;padding:20px;font-size: 18px;font-family: Sans-Serif;"><tr><th>'+countOfProducts+' NDC Line Items Need Approval</b></th></tr></table>';
                        
                    }
                    // content += '<b style="">NDC Change Details:</b></br></br>';
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:2px 4px 4px 8px;"><b>NDC Change Details:</b></td></tr></table>';
                    content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr>';
                    content += '<td>';
                    content  += '<table style="border-collapse: collapse;padding-left:26px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">NDC Change Name</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+objId+'">'+ndcChangeName+'</a></th></tr>';
                    content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Product Family</th><td style="border: 1px solid black;padding: 8px;">'+currentPrdFamily+'</td></tr>';
                    content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Proposed Product Family</th><td style="border: 1px solid black;padding: 8px;">'+proposedPrdFamily+'</td></tr>';
                    
                    content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Description</th><td style="border: 1px solid black;padding: 8px;">'+description+'</td></tr>';
                    content += '<tr><th style="width: 26px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">Current Stage</th><td style="border: 1px solid black;padding: 8px;">'+approvalStatus+'</td></tr>';
                    
                    content += '</thead></table>';
                    content += '</td></tr></table>';
                    content += tableData;
                    if(stepName == 'Contract Team\'s Action' || stepName == 'Customer\'s Update' ){
                        // content += '<span style="">To view the NDC line items, refer to this link </span><b><a href="'+System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+ndcId+'">'+ndcChangeName+'</a></b>.<br/><br/>'; 
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To view the NDC line items, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+objId+'">'+ndcChangeName+'</a></b>.</td></tr></table>';
                        
                    }
                    if(stepName == 'Finance Approval' || stepName == 'Supply Chain Approval'){
                        //content += '<span style = "">To approve, modify or reject the NDC Change line items, refer to this link </span><b><a href="'+System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+ndcId+'">'+ndcChangeName+'</a></b>.<br/><br/>'; 
                        content += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding: 12px 8px 4px 8px;">To approve, modify or reject the NDC Change line items, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+objId+'">'+ndcChangeName+'</a></b>.</td></tr></table>';
                        
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
                  System.debug('in approvalEmails last');
                    Boolean isFooterTextAlterRequired = false;
                    AllEmailNotificationsSenderCls.sendEmailAlert(objId, content, new List<String> (toAddress), new List<String> (ccEmailIds), subject, title,isFooterTextAlterRequired); 
                    
                    
                }
                Catch(Exception e) {
                    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
                    System.debug('msg==>'+msg);
                }
        }
	public static void approvalEmailsPHSPriceChange(Id objId, List < Phoenix_Bid_Process_Steps__c > nextSteps){
        	 try{
                 System.debug('objId==>'+objId);
                  System.debug('nextSteps==>'+nextSteps);
                   Set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
                   Map < Id, User > usersMap = new Map < Id, User > ([SELECT Id, Name, Email,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegated_Approver__r.Email FROM User]);

                  Integer sNo = 0;String content = '';String title = '';String subject = ''; 
                    User creatByName = new User();
                    String initiatorName = '';
                    String creatBy_Name='';
                    Phoenix_PHS_Price_Change__c pHSChange = [Select Id, Name,owner.Email,Phoenix_PHS_Price_Change_Name__c,Phoenix_PHS_Price_Change_Description__c,CreatedBy.Name,owner.Name, Phoenix_Approval_Status__c, Phoenix_Record_Type__c from Phoenix_PHS_Price_Change__c WHERE Id =: objId LIMIT 1];
                 System.debug('pHSChange==>'+pHSChange);  
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
                 System.debug('bidProcessSteps==>'+bidProcessSteps);     
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
                        System.debug('in for loop==>');  
                         System.debug('pHSItem.Phoenix_Product_Name__r.Name==>'+pHSItem.Phoenix_Product_Name__r.Name);  
                        System.debug('pHSItem.Phoenix_Material_Code__c'+pHSItem.Phoenix_Material_Code__c);  
                        System.debug('pHSItem.Phoenix_NDC_11__c'+pHSItem.Phoenix_NDC_11__c);  
                        System.debug('pHSItem.Phoenix_Provisional_PHS_Price__c'+pHSItem.Phoenix_Provisional_PHS_Price__c);  
                        System.debug('pHSItem.Phoenix_Price_Start_Date__c'+pHSItem.Phoenix_Price_Start_Date__c);  
                        System.debug('pHSItem.Phoenix_Price_End_Date__c'+pHSItem.Phoenix_Price_End_Date__c);  


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
                   System.debug('approvalStatus==>'+approvalStatus);
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
                 System.debug('phsId==>'+phsId);
                  System.debug('content==>'+content);
                 System.debug('subject==>'+subject);
                 System.debug('title==>'+title);
                    AllEmailNotificationsSenderCls.sendEmailAlert(phsId, content, new List<String>(toAddress), new List < String > (ccEmailIds), subject, title,isFooterTextAlterRequired);
                }
                Catch(Exception e) {
                    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
					System.debug('msg for phs==>'+msg)    ;  
                    System.debug('Exception Line Number: ' + e.getLineNumber());
                }
        }
	public static void approvalEmailsWACChange(Id objId, List < Phoenix_Bid_Process_Steps__c > nextSteps){
        	 try{
                   Set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
                   Map < Id, User > usersMap = new Map < Id, User > ([SELECT Id, Name, Email,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegated_Approver__r.Email FROM User]);
                   Integer sNo = 0;String content = '';String title = '';String subject = ''; 
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
                   Phoenix_WAC_Change__c WacChange = [Select Id, Phoenix_Total_Net_Benefit__c,Name,Phoenix_Product_Family__c,Phoenix_Summary__c,CreatedBy.Name,Phoenix_Medicaid_release__c,Working_capital_benefit__c,Phoenix_Total_Net_Benefit_Impact__c,Phoenix_PHS_hit__c,Phoenix_WAC_finance_impact__c,Product_Family__r.Name,Phoenix_Effective_Date__c,Phoenix_Sales_Increase__c, Owner.Email, Phoenix_Approval_Status__c from Phoenix_WAC_Change__c WHERE Id =: objId LIMIT 1];
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
                    content  += '<table style="border-collapse: collapse;padding-left:26px;font-size: 14px;font-family: Sans-Serif;"><thead><tr><th style="width: 34px;"></th><th style="border: 1px solid black;padding:4px 8px;text-align:left;background-color:#d4bdf8;padding: 8px;">WAC Change Name</th><th style="border: 1px solid black;text-align: left;padding: 8px;"><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/'+objId+'">'+WacChangeName+'</a></th></tr>';
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
                    
                } 
        }
    public static void approvalEmailsNewProductWAC(Id objId, List < Phoenix_Bid_Process_Steps__c > nextSteps){
        	try{
                Set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
                   Map < Id, User > usersMap = new Map < Id, User > ([SELECT Id, Name, Email,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegated_Approver__r.Email FROM User]);
                   Integer sNo = 0;String content = '';String title = '';String subject = ''; 
                    String initiator = '';
                    List<New_Product_WAC_Pricing__c> recs = [SELECT  Ownerid,owner.Name from New_Product_WAC_Pricing__c where id=:objId];
                    for(New_Product_WAC_Pricing__c rec: recs){
                        initiator = rec.owner.Name;
                        
                    }
                    
                    User creatByName = new User();
                    String newWacPricingName,prodFamily,productType,approvalStatus,creatBy_Name,summaryText;
                    Decimal netSales,tptPerc,gmPerc;
                    New_Product_WAC_Pricing__c newWac = [Select Id, Name,	Phoenix_Summary__c, Owner.Email,CreatedBy.Name,Phoenix_TPT__c,Phoenix_GM__c,	Phoenix_Product_Family__c,Phoenix_Product_Type__c,Phoenix_Net_sales_annualized__c, Phoenix_Approval_Status__c from New_Product_WAC_Pricing__c WHERE Id =: objId LIMIT 1];
                    newWacPricingName = newWac.Name != null ? newWac.Name :'';
                    prodFamily = 	newWac.Phoenix_Product_Family__c != null ?newWac.Phoenix_Product_Family__c  : ''; //newWac.Product_Family__r.Name != null ? newWac.Product_Family__r.Name : '';
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
        }
    
    
    /*
    Public static void updateListItems(){
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
	*/
}