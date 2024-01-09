public class Phoenix_FinanceApprovalGrid {
    @AuraEnabled
    public static FinanceApprovalGridWrapper viewApprovalGrid(Id bidId){
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_is_OTC_Bid__c FROM Phoenix_Bid__c where Id =:bidId];
        String query ='';
        String SobjectApiName = 'Phoenix_Approval_Grid__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for(String fieldName : fieldMap.keyset() )
        {
            if(strFields == null || strFields == '')
            {
                strFields = fieldName;
            }else{
                strFields = strFields + ' , ' + fieldName;
            }
        }
        string notApproved = 'Not Approved';
        query = 'select Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Selected_Approval_Matrix__r.Phoenix_Quadrant__c,Phoenix_Bid__r.Phoenix_is_OTC_Bid__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Final_Status__c!=:notApproved and Phoenix_Bid__c = : bidId ORDER BY Phoenix_Product_Family__c ASC'  ;
        List<Phoenix_Approval_Grid__c> listOfGrids = Database.query(query);
        system.debug('listOfGrids---'+listOfGrids);
        FinanceApprovalGridWrapper gridWrapper = new FinanceApprovalGridWrapper();
        for(Phoenix_Approval_Grid__c eachGrid : listOfGrids){
            eachGrid.Phoenix_Sr_Director_VP_Finance_Comments__c = (eachGrid.Phoenix_Sr_Director_VP_Finance_Comments__c!=null && eachGrid.Phoenix_Sr_Director_VP_Finance_Comments__c != 'undefined') ? eachGrid.Phoenix_Sr_Director_VP_Finance_Comments__c.replaceAll('#',' '):eachGrid.Phoenix_Sr_Director_VP_Finance_Comments__c;
            eachGrid.Phoenix_Comments__c = (eachGrid.Phoenix_Comments__c!=null && eachGrid.Phoenix_Comments__c!='undefined') ? eachGrid.Phoenix_Comments__c.replaceAll('#',' '):eachGrid.Phoenix_Comments__c;
            eachGrid.Phoenix_Business_Head_Comments__c = (eachGrid.Phoenix_Business_Head_Comments__c!=null && eachGrid.Phoenix_Business_Head_Comments__c!= 'undefined') ? eachGrid.Phoenix_Business_Head_Comments__c.replaceAll('#',' '):eachGrid.Phoenix_Business_Head_Comments__c;
        }
        gridWrapper.approvalGridList = listOfGrids;
        gridWrapper.isOTCBid = bid.Phoenix_is_OTC_Bid__c;

        //for(Phoenix_Approval_Grid__c grid : listOfGrids)System.debug(grid.Phoenix_Annualized_TP_Impact_Limit__c); 
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
         //added by jogarao for approval
        boolean isBHDelegationPerson=false;
        boolean isMHDelegationPerson=false;
        boolean isSRXDelegationPerson=false;
        boolean isRXDelegationPerson=false;
        boolean isOTCDelegationPerson=false;
        boolean isSrVIPDelegationPerson =false;
        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c where Phoenix_Is_Active_User__c=true limit 1000]) {
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__c);
        }
        if(deligatorApprover !=null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c aprHisDel : deligatorApprover){
                if(userTeamUserIdMap.containsKey('Business Head-'+aprHisDel.Phoenix_User__c)){
                    isBHDelegationPerson = true;
                }
                if(userTeamUserIdMap.containsKey('Marketing Head-'+aprHisDel.Phoenix_User__c)){
                    isMHDelegationPerson = true;
                }
                if(userTeamUserIdMap.containsKey('Marketing Lead Rx-'+aprHisDel.Phoenix_User__c)){
                    isRXDelegationPerson = true;
                }
                if(userTeamUserIdMap.containsKey('Marketing Lead SRx-'+aprHisDel.Phoenix_User__c)){
                    isSRXDelegationPerson = true;
                }
                if(userTeamUserIdMap.containsKey('Marketing Lead OTC-'+aprHisDel.Phoenix_User__c)){
                    isOTCDelegationPerson = true;
                }
                if(userTeamUserIdMap.containsKey('Sr Director or VP Finance-'+aprHisDel.Phoenix_User__c)){
                    isSrVIPDelegationPerson = true;
                }
            }
        }
        if(!listOfGrids.isEmpty()){           
            for(Phoenix_User_Approval_Matrix__c matrix : [SELECT Id, Name, User_Group__c,User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approver_Group_Name__c, Phoenix_Approver__c FROM Phoenix_User_Approval_Matrix__c] ){
                if(matrix.User_Group__r.Phoenix_Approver_Group_Name__c == 'Business Head' && (matrix.Phoenix_Approver__c == UserInfo.getUserId() || isBHDelegationPerson) && listOfGrids != null && listOfGrids[0].Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Business Head'){                gridWrapper.isBusinessHead = true;
                                                                                                                                                                                                                                                      }
                if(matrix.User_Group__r.Phoenix_Approver_Group_Name__c == 'Marketing Head' && (matrix.Phoenix_Approver__c == UserInfo.getUserId() || isMHDelegationPerson)  && listOfGrids != null && listOfGrids[0].Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Marketing Head'){                gridWrapper.isMarketingHead = true;
                                                                                                                                                                                                                                                         }
                
                if(matrix.User_Group__r.Phoenix_Approver_Group_Name__c == 'Marketing Lead Rx' && (matrix.Phoenix_Approver__c == UserInfo.getUserId() || isRXDelegationPerson)  && listOfGrids != null && listOfGrids[0].Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Marketing Lead'){                gridWrapper.isMarketingRxLead  = true;
                                                                                                                                                                                                                                                            }
                if(matrix.User_Group__r.Phoenix_Approver_Group_Name__c == 'Marketing Lead SRx' && (matrix.Phoenix_Approver__c == UserInfo.getUserId() || isSRXDelegationPerson)  && listOfGrids != null && listOfGrids[0].Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Marketing Lead'){                gridWrapper.isMarketingSRxLead = true;
                                                                                                                                                                                                                                                             }
                if(matrix.User_Group__r.Phoenix_Approver_Group_Name__c == 'Marketing Lead OTC' && (matrix.Phoenix_Approver__c == UserInfo.getUserId() || isOTCDelegationPerson)  && listOfGrids != null && (listOfGrids[0].Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Marketing Lead' || (listOfGrids[0].Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Marketing Lead OTC' && listOfGrids[0].Phoenix_Bid__r.Phoenix_is_OTC_Bid__c))){  
                    system.debug('isMarketing Lead');
                    gridWrapper.isMarketingOTCLead = true;
                                                                                                                                                                                                                                                             }
                if(matrix.User_Group__r.Phoenix_Approver_Group_Name__c == 'Sr Director or VP Finance' && (matrix.Phoenix_Approver__c == UserInfo.getUserId() || isSrVIPDelegationPerson)   && listOfGrids != null && listOfGrids[0].Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Sr Director or VP Finance'){                gridWrapper.isVPFinanceHead = true;
                                                                                                                                                                                                                                                                               }
            }
        }
        /*Set<String> SRxOtc = new Set<String>();
for(Phoenix_Approval_Grid__c grid : listOfGrids){
for(Phoenix_Bid_Line_Item__c bidLine : grid.Bid_Line_Items__r){
system.debug('lineItems--->'+grid.Bid_Line_Items__r);
if(bidLine.Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c != null)
SRxOtc.add(bidLine.Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c);
}
if(SRxOtc != null && SRxOtc.size()==1 && SRxOtc.contains('SRx')){
grid.Phoenix_isSRX__c = true; 
}
if(SRxOtc != null && SRxOtc.size()==1 && SRxOtc.contains('Rx')){
grid.Phoenix_isRX__c = true; 
}
if(SRxOtc != null && SRxOtc.size()==1 && SRxOtc.contains('OTC')){
grid.Phoenix_isOTC__c = true; 
}
SRxOtc = new Set<String>();
}*/
        // where Phoenix_Approver_Group_Name__c = 'Business Head' OR Phoenix_Approver_Group_Name__c = 'Sales & Marketing' OR Phoenix_Approver_Group_Name__c = 'Sales & Marketing' Head Sr Director or VP Finance
        
        return gridWrapper;
        
    } 
    
    @auraEnabled
    public static FinanceApprovalGridWrapper updateLineItems(String bidId, Map<String,String> approvalMap , Map<String,String> commentsMap,Map<String,String> ApprovalBUMap , Map<String,String> commentsBUMap,Map<String,String> approvalSrDirMap , Map<String,String> commentsSrDirMap,Map<String,String> SrxApprovalMap,Map<String,String> RxApprovalMap,Map<String,String> OTCApprovalMap){
        List<String> productFamilyList = new List<String>();
        if(approvalMap != null)            productFamilyList.addAll(approvalMap.keySet());
        if(commentsMap != null)            productFamilyList.addAll(commentsMap.keySet());
        if(ApprovalBUMap != null)            productFamilyList.addAll(ApprovalBUMap.keySet());
        if(commentsBUMap != null)            productFamilyList.addAll(commentsBUMap.keySet());
        if(approvalSrDirMap != null)            productFamilyList.addAll(approvalSrDirMap.keySet());
        if(commentsSrDirMap != null)            productFamilyList.addAll(commentsSrDirMap.keySet());
        if(SrxApprovalMap != null)            productFamilyList.addAll(SrxApprovalMap.keySet());
        if(RxApprovalMap != null)            productFamilyList.addAll(RxApprovalMap.keySet());
        if(OTCApprovalMap != null)            productFamilyList.addAll(OTCApprovalMap.keySet());
        string notApprovedGid = 'Not Approved';
        string query = 'SELECT Id,Phoenix_Annualized_GM__c,Phoenix_Approval__c,Phoenix_Comments__c,Phoenix_VP_Finance_Req__c,Phoenix_Mkt_Head_Req__c,Phoenix_Annualized_GM_Impact__c,Phoenix_Annualized_GM_Impact_Limit__c,Phoenix_Annualized_GM_Limit__c,Phoenix_Annualized_TP__c,Phoenix_Annualized_TP_Impact__c,Phoenix_Annualized_TP_Impact_Limit__c,Phoenix_Annualized_TP_Limit__c,Name,Phoenix_Bid__c,Phoenix_GM__c,Phoenix_GM_Limit__c,Phoenix_Product_Family__c,Phoenix_SSA_Impact__c,	Phoenix_SSA_Impact_Limit__c,Phoenix_TP__c,Phoenix_TP_Limit__c,Phoenix_Sr_Director_VP_Finance_Comments__c,Phoenix_Business_Head_Comments__c,Phoenix_Revenue_Limit__c FROM Phoenix_Approval_Grid__c Where Phoenix_Final_Status__c!=:notApprovedGid and Phoenix_Bid__c =:bidId';
        List<Phoenix_Approval_Grid__c> allApprovalGridList = Database.query(query);
        system.debug('allApprovalGridList--->'+allApprovalGridList);
        system.debug('approvalMap--->'+approvalMap);
        for(Phoenix_Approval_Grid__c eachGrid : allApprovalGridList){
            if(approvalMap != null && approvalMap.containsKey(eachGrid.Id)){                eachGrid.Phoenix_Approval__c = approvalMap.get(eachGrid.Id);
                                                                           }
            if(commentsMap != null && commentsMap.containsKey(eachGrid.Id)){                eachGrid.Phoenix_Comments__c = commentsMap.get(eachGrid.Id);
                                                                           }
            if(ApprovalBUMap != null && ApprovalBUMap.containsKey(eachGrid.Id)){                eachGrid.Phoenix_Business_Head_Approval__c = ApprovalBUMap.get(eachGrid.Id);
                                                                               }
            if(commentsBUMap != null && commentsBUMap.containsKey(eachGrid.Id)){                eachGrid.Phoenix_Business_Head_Comments__c = commentsBUMap.get(eachGrid.Id);
                                                                               }
            if(approvalSrDirMap != null && approvalSrDirMap.containsKey(eachGrid.Id)){                eachGrid.Phoenix_Sr_Director_VP__c = approvalSrDirMap.get(eachGrid.Id);
                                                                                     }
            if(commentsSrDirMap != null && commentsSrDirMap.containsKey(eachGrid.Id)){                eachGrid.Phoenix_Sr_Director_VP_Finance_Comments__c = commentsSrDirMap.get(eachGrid.Id);
                                                                                     }
            if(SrxApprovalMap != null && SrxApprovalMap.containsKey(eachGrid.Id)){                eachGrid.Phoenix_Marketing_Lead_SRx__c = SrxApprovalMap.get(eachGrid.Id);
                                                                                 }
            if(RxApprovalMap != null && RxApprovalMap.containsKey(eachGrid.Id)){                eachGrid.Phoenix_Marketing_Lead_Rx__c = RxApprovalMap.get(eachGrid.Id);
                                                                               }
            if(OTCApprovalMap != null && OTCApprovalMap.containsKey(eachGrid.Id)){                eachGrid.Phoenix_Marketing_Lead_OTC__c = OTCApprovalMap.get(eachGrid.Id);
                                                                                 }
            
            
            
            
        }
        if(allApprovalGridList != null && allApprovalGridList.size()>0){            update allApprovalGridList;
                                                                       }
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for(String fieldName : fieldMap.keyset() )
        {
            if(strFields == null || strFields == '')
            {
                strFields = fieldName;
            }else{
                strFields = strFields + ' , ' + fieldName;
            }
        }
        string notApproved = 'Not Approved';
        query = 'select Phoenix_Approval_Grid__r.Id,' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved AND Phoenix_Approval_Grid__c =:productFamilyList ORDER BY Phoenix_Product_Family__c ASC'  ;
        List<Phoenix_Bid_Line_Item__c> bidLineItemsList = Database.query(query);
        for(Phoenix_Bid_Line_Item__c bidLine :bidLineItemsList){
            
            if(approvalMap != null && approvalMap.containsKey(bidLine.Phoenix_Approval_Grid__r.Id))            	bidLine.Phoenix_Approval__c = approvalMap.get(bidLine.Phoenix_Approval_Grid__r.Id);
            if(commentsMap != null && commentsMap.containsKey(bidLine.Phoenix_Approval_Grid__r.Id))            	bidLine.Phoenix_Comments__c = commentsMap.get(bidLine.Phoenix_Approval_Grid__r.Id);
            if(ApprovalBUMap != null && ApprovalBUMap.containsKey(bidLine.Phoenix_Approval_Grid__r.Id)){                bidLine.Phoenix_Business_Head_Approval__c = ApprovalBUMap.get(bidLine.Phoenix_Approval_Grid__r.Id);
                                                                                                       }
            if(commentsBUMap != null && commentsBUMap.containsKey(bidLine.Phoenix_Approval_Grid__r.Id)){                bidLine.Phoenix_Business_Head_Comments__c = commentsBUMap.get(bidLine.Phoenix_Approval_Grid__r.Id);
                                                                                                       }
            if(approvalSrDirMap != null && approvalSrDirMap.containsKey(bidLine.Phoenix_Approval_Grid__r.Id)){                bidLine.Phoenix_Sr_Director_VP_Finance_Approval__c = approvalSrDirMap.get(bidLine.Phoenix_Approval_Grid__r.Id);
                                                                                                             }
            if(commentsSrDirMap != null && commentsSrDirMap.containsKey(bidLine.Phoenix_Approval_Grid__r.Id)){                bidLine.Phoenix_Sr_Director_VP_Finance_Comments__c = commentsSrDirMap.get(bidLine.Phoenix_Approval_Grid__r.Id);
                                                                                                             }
            if(SrxApprovalMap != null && SrxApprovalMap.containsKey(bidLine.Phoenix_Approval_Grid__r.Id)){                bidLine.Phoenix_Marketing_Lead_SRx__c = SrxApprovalMap.get(bidLine.Phoenix_Approval_Grid__r.Id);
                                                                                                         }
            if(RxApprovalMap != null && RxApprovalMap.containsKey(bidLine.Phoenix_Approval_Grid__r.Id)){                bidLine.Phoenix_Marketing_Lead_Rx__c = RxApprovalMap.get(bidLine.Phoenix_Approval_Grid__r.Id);
                                                                                                       }
            if(OTCApprovalMap != null && OTCApprovalMap.containsKey(bidLine.Phoenix_Approval_Grid__r.Id)){                bidLine.Phoenix_Marketing_Lead_OTC__c = OTCApprovalMap.get(bidLine.Phoenix_Approval_Grid__r.Id);
                                                                                                         }
            
        }
        if(bidLineItemsList != null && bidLineItemsList.size()>0){            update bidLineItemsList;
                                                                 }
        
        return viewApprovalGrid(bidId);
    }
    
    public class FinanceApprovalGridWrapper{
        @AuraEnabled public List<Phoenix_Approval_Grid__c> approvalGridList;
        @AuraEnabled public String loggedInUser;
        @AuraEnabled public boolean isMarketingHead;
        @AuraEnabled public boolean isBusinessHead;
        @AuraEnabled public boolean isVPFinanceHead;
        @AuraEnabled public boolean isMarketingHeadAppicable;
        @AuraEnabled public boolean isBusinessHeadApplicable;
        @AuraEnabled public boolean isVPFinanceHeadApplicable;
        @AuraEnabled public boolean isMarketingSRxLead;
        @AuraEnabled public boolean isMarketingRxLead;
        @AuraEnabled public boolean isMarketingOTCLead;
        @AuraEnabled public boolean isSRxFamily;
        @AuraEnabled public boolean isRxFamily;
        @AuraEnabled public boolean isOTCFamily;
        @AuraEnabled public boolean isOTCBid;
        @AuraEnabled public Phoenix_Bid__c budRecord;
        
        FinanceApprovalGridWrapper(){
            approvalGridList = new List<Phoenix_Approval_Grid__c>();
            loggedInUser = UserInfo.getUserId();
            isMarketingHead=false; 
            isBusinessHead=false; 
            isVPFinanceHead=false;
            isMarketingHeadAppicable=false; 
            isBusinessHeadApplicable=false;
            isVPFinanceHeadApplicable=false;
            isMarketingSRxLead =false;
            isMarketingRxLead = false;
            isMarketingOTCLead = false;
            isSRxFamily= false;
            isRxFamily = false;
            isOTCFamily =false;
            
            
        }
        
    }
    @AuraEnabled
    public static void makeApprovals(String bidId,List<Phoenix_Approval_Grid__c> approvalGrids,boolean isMarketingHead,boolean isBusinessHead,boolean isVPFinanceHead, boolean isMarketingSRxLead,boolean isMarketingRxLead,boolean isMarketingOTCLead){
        System.debug('isMarketingRxLead==>'+isMarketingRxLead);
        System.debug('approvalGrids==>'+approvalGrids);
        String query ='';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for(String fieldName : fieldMap.keyset() )
        {
            if(strFields == null || strFields == '')
            {
                strFields = fieldName;
            }else{
                strFields = strFields + ' , ' + fieldName;
            }
        }
        string notApproved = 'Not Approved';
        Boolean isLineRejected = false;
        Boolean isOTCLineRejected = false;
        Boolean isSRxLineRejected = false;
        Boolean isRxLineRejected = false;
        query = 'select ' + strFields + ', Product_Family__r.Name, Phoenix_Product__r.name from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Approval_Grid__c=:approvalGrids AND Phoenix_Final_Status__c !=: notApproved  ORDER BY Product_Family_Name__c ASC'  ;
        List<Phoenix_Bid_Line_Item__c> bidLineItemsList = Database.query(query);
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name,Phoenix_Process_Step__r.Name, Phoenix_Bid__c,Phoenix_Approver_Team_Members__c, Phoenix_Process_Step__c,Phoenix_Is_Criteria_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Name,Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:bidId ORDER BY Phoenix_Step__c ASC ];
        Map <String, List<Phoenix_Bid_Process_Steps__c>> criteriaStepsMap = new Map<String, List<Phoenix_Bid_Process_Steps__c>>();
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name,Phoenix_Delegated_Approver__r.Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
        Map<Id, Id> delegationApproverMap = new Map<Id,Id>();
        delegationApproverMap.put(UserInfo.getUserId(),UserInfo.getUserId());
        if(deligatorApprover != null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c ADH: deligatorApprover){
                delegationApproverMap.put(ADH.Phoenix_User__c,ADH.Phoenix_Delegated_Approver__c);
            }
        }
        boolean isCreateriaDone = false;
        list<String> criteriaApprovers = new list<String>();
        Integer stepNumber=30;
        string vpFinanceTeam='';
        for(Phoenix_Bid_Process_Steps__c step : bidProcessStepList){ 
            if(step.Phoenix_Is_Criteria_Step__c && (step.Phoenix_Status__c == 'In Process')){
                if(stepNumber> step.Phoenix_Step__c){
                    stepNumber=Integer.valueOf(step.Phoenix_Step__c);
                }          
                if(step.Phoenix_Approver_Team__c=='Sr Director or VP Finance'){
                    if(deligatorApprover != null && deligatorApprover.size()>0){
                        vpFinanceTeam=step.Phoenix_Approver_Team_Members__c + ',' +deligatorApprover[0].Phoenix_Delegated_Approver__r.Name;
                    }else{
                        vpFinanceTeam=step.Phoenix_Approver_Team_Members__c;
                    }
                    
                    system.debug('team members--'+step.Phoenix_Approver_Team_Members__c);
                    criteriaStepsMap.put('Sr Director or VP Finance',new List<Phoenix_Bid_Process_Steps__c>{step}); 
                }else{
                    if(deligatorApprover != null && delegationApproverMap != null && delegationApproverMap.get(step.Phoenix_Approver__c) != null){
                        if(criteriaStepsMap.containskey(delegationApproverMap.get(step.Phoenix_Approver__c))){
                            List<Phoenix_Bid_Process_Steps__c> stepsList = criteriaStepsMap.get(delegationApproverMap.get(step.Phoenix_Approver__c));
                            stepsList.add(step);
                            criteriaStepsMap.put(delegationApproverMap.get(step.Phoenix_Approver__c), stepsList);
                        }else{
                            criteriaStepsMap.put(delegationApproverMap.get(step.Phoenix_Approver__c),new List<Phoenix_Bid_Process_Steps__c>{step});
                        }
                        
                    }else{
                        criteriaStepsMap.put(step.Phoenix_Approver__c,new List<Phoenix_Bid_Process_Steps__c>{step});
                    }
                    
                } 
            }
        }
        system.debug('isMarketingRxLead--->'+isMarketingRxLead);
        set<string> gridIdset=new set<string>();
        boolean isMarketingHeadEmailReq = false;
        String bidApprovalStatus ='';
        if(isMarketingHead)
            bidApprovalStatus = 'Marketing Head Rejected';  
        if(isVPFinanceHead) 
            bidApprovalStatus ='Sr Director or VP Finance Rejected'; 
        if(isMarketingOTCLead || isMarketingRxLead || isMarketingSRxLead)
            bidApprovalStatus ='Marketing Lead Rejected';
        
       system.debug('bidApprovalStatus=='+bidApprovalStatus);
        for(Phoenix_Approval_Grid__c grid : approvalGrids){
            system.debug('grid----->'+grid);
            system.debug('grid.Phoenix_Approval__c----->'+grid.Phoenix_Approval__c);
            system.debug('grid MarketingSrx----->'+grid.Phoenix_isMarketingSrxLeadApproved__c);
            system.debug('grid.Phoenix_Is_Mkg_Head_Noti_Required__c--->'+grid.Phoenix_Is_Mkg_Head_Noti_Required__c);
            if(grid.Phoenix_Is_Mkg_Head_Noti_Required__c){
                isMarketingHeadEmailReq =true;
            }
            else if(isMarketingHead){      
                grid.Phoenix_isMarketingHeadApproved__c = true;               
                if(grid.Phoenix_Approval__c == 'Not Approved'){
                    isLineRejected = true;
                    gridIdset.add(grid.Id);
                    grid.Phoenix_Final_Status__c = 'Not Approved';
                }
            }  
            else if(isBusinessHead){
                grid.Phoenix_isBusinessHeadApproved__c = true;
                //gridId= grid.Id;                
            }
            else if(isVPFinanceHead){ 
                grid.Phoenix_isFinanceVPApproved__c = true;               
                if(grid.Phoenix_Sr_Director_VP__c == 'Not Approved'){
                     gridIdset.add(grid.Id);grid.Phoenix_Final_Status__c = 'Not Approved';
                }
            }
            else if(isMarketingSRxLead){
                grid.Phoenix_isMarketingSrxLeadApproved__c =true;               
                if(grid.Phoenix_Marketing_Lead_SRx__c == 'Not Approved'){
                    isSRxLineRejected = true;
                     gridIdset.add(grid.Id);grid.Phoenix_Final_Status__c = 'Not Approved';
                }
            }
            else if(isMarketingRxLead){
                System.debug('in else');
                grid.Phoenix_isMarketingRxLeadApproved__c =true;
                System.debug('value of Phoenix_Marketing_Lead_Rx__c==>'+grid.Phoenix_Marketing_Lead_Rx__c);
                
                if(grid.Phoenix_Marketing_Lead_Rx__c == 'Not Approved'){
                    isRxLineRejected = true;
                    System.debug('value of Phoenix_Marketing_Lead_Rx__c==>'+grid.Phoenix_Marketing_Lead_Rx__c);
                    gridIdset.add(grid.Id);grid.Phoenix_Final_Status__c = 'Not Approved';
                }
            }
            system.debug('isMarketingOTCLead---->'+isMarketingOTCLead);
            if(isMarketingOTCLead){
                grid.Phoenix_IsOTCLeadApproved__c =true;               
                if(grid.Phoenix_Marketing_Lead_OTC__c == 'Not Approved'){
                    isOTCLineRejected = true;
                      gridIdset.add(grid.Id);grid.Phoenix_Final_Status__c = 'Not Approved';
                }
            }
        }
        List<Phoenix_Bid_Line_Item__c> LineItemsList = new List<Phoenix_Bid_Line_Item__c>(); 
        system.debug('bidLineItemsList---'+bidLineItemsList.size());
        for(Phoenix_Bid_Line_Item__c lineItem : bidLineItemsList){ 
            system.debug('lineItem--'+lineItem);     
            system.debug('gridIdset--'+gridIdset); 
            system.debug('lineItem.Phoenix_Approval_Grid__c--'+lineItem.Phoenix_Approval_Grid__c); 
            if(gridIdset != null && gridIdset.contains(lineItem.Phoenix_Approval_Grid__c)){
                lineItem.Phoenix_Final_Status__c = 'Not Approved';LineItemsList.add(lineItem);
            }
            
        }
        system.debug('isloggedUser-->'+criteriaStepsMap.containsKey(UserInfo.getUserId()));
        if((criteriaStepsMap != null && criteriaStepsMap.containsKey(UserInfo.getUserId())) || vpFinanceTeam.contains(UserInfo.getName())){  
            system.debug('current approve step-->'+criteriaStepsMap.get(UserInfo.getUserId())); 
            if(vpFinanceTeam.contains(UserInfo.getName())){
                List<Phoenix_Bid_Process_Steps__c> stepsList = criteriaStepsMap.get('Sr Director or VP Finance');
                if(stepsList != null && stepsList.size()>0){
                    for(Phoenix_Bid_Process_Steps__c step : stepsList){
                        step.Phoenix_Status__c = 'Completed';  
                        step.Phoenix_Approver__c = userinfo.getuserid();
                    }
                }
                update stepsList;  
            }else{
                List<Phoenix_Bid_Process_Steps__c> stepsList = criteriaStepsMap.get(UserInfo.getUserId());
                if(stepsList != null && stepsList.size()>0){
                    for(Phoenix_Bid_Process_Steps__c step : stepsList){
                        step.Phoenix_Status__c = 'Completed';  
                        step.Phoenix_Approver__c = userinfo.getuserid();
                    }
                }
                update stepsList;  
            }
            update approvalGrids; 
            system.debug('LineItemsList=='+LineItemsList);
            if(LineItemsList != null && LineItemsList.size() > 0)
                update LineItemsList;
            if(criteriaStepsMap.size()==1)
                updateNextProcessSteps(bidId, bidProcessStepList,stepNumber,LineItemsList,isMarketingHeadEmailReq,bidApprovalStatus);
        }
        for(Phoenix_Bid_Process_Steps__c step : bidProcessStepList){ 
            if(bidApprovalStatus == 'Marketing Lead Rejected' && isRxLineRejected){
            if(step.Phoenix_Process_Step__r.Name == 'Marketing Head Approval'){
                step.Phoenix_Status__c = 'Not Applicable';
            }
            if(step.Phoenix_Process_Step__r.Name == 'Sr Director or VP Finance Approval'){
                step.Phoenix_Status__c = 'Not Applicable';
            }
            if(step.Phoenix_Process_Step__r.Name == 'Finance Approval'){
                step.Phoenix_Status__c = 'Not Applicable';
            } 
                if(step.Phoenix_Process_Step__r.Name == 'Contract Team'+ '\''+'s Action'){
                step.Phoenix_Status__c = 'In Process';
            } 
            }
             if(bidApprovalStatus == 'Marketing Head Rejected' && isLineRejected){
            
            if(step.Phoenix_Process_Step__r.Name == 'Sr Director or VP Finance Approval'){
                step.Phoenix_Status__c = 'Not Applicable';
            }
                 if(step.Phoenix_Process_Step__r.Name == 'Finance Approval'){
                step.Phoenix_Status__c = 'Not Applicable';
            }  
            }
        }
        update bidProcessStepList;
/*if(criteriaStepsMap.size() == 1){

}

if(updateProcessStep != null){
updateProcessStep.Phoenix_Status__c = 'Completed';
updateProcessStep.Phoenix_Approver__c = userinfo.getuserid();
update updateProcessStep;
}*/
        
        
        /*if(bidLineItemsList.size()>0)
update bidLineItemsList;*/
        
        
    }
   
    //by surender---start
        public static void makeApprovalsFromEmail(String bidId, List<Phoenix_Approval_Grid__c> approvalGrids,boolean isMarketingHead,boolean isBusinessHead,boolean isVPFinanceHead, boolean isMarketingSRxLead,boolean isMarketingRxLead,boolean isMarketingOTCLead,User currentUser){
        system.debug('makeApprovals method called from email service');
        String query ='';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for(String fieldName : fieldMap.keyset() )
        {
            if(strFields == null || strFields == '')
            {
                strFields = fieldName;
            }else{
                strFields = strFields + ' , ' + fieldName;
            }
        }
        string notApproved = 'Not Approved';
        query = 'select ' + strFields + ', Phoenix_Product__r.name from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved  ORDER BY Product_Family_Name__c ASC'  ;
        List<Phoenix_Bid_Line_Item__c> bidLineItemsList = Database.query(query);
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c,Phoenix_Approver_Team_Members__c, Phoenix_Process_Step__c,Phoenix_Is_Criteria_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Name,Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:bidId ORDER BY Phoenix_Step__c ASC ];
        Map <String, Phoenix_Bid_Process_Steps__c> criteriaStepsMap = new Map<String, Phoenix_Bid_Process_Steps__c>();
        boolean isCreateriaDone = false;
        list<String> criteriaApprovers = new list<String>();
        Integer stepNumber=30;
        string vpFinanceTeam='';
        for(Phoenix_Bid_Process_Steps__c step : bidProcessStepList){ 
            if(step.Phoenix_Is_Criteria_Step__c && (step.Phoenix_Status__c == 'In Process')){
                if(stepNumber> step.Phoenix_Step__c){stepNumber=Integer.valueOf(step.Phoenix_Step__c);}          
                if(step.Phoenix_Approver_Team__c=='Sr Director or VP Finance'){
                    vpFinanceTeam=step.Phoenix_Approver_Team_Members__c;
                    system.debug('team members--'+step.Phoenix_Approver_Team_Members__c);
                    criteriaStepsMap.put('Sr Director or VP Finance',step); 
                }else{criteriaStepsMap.put(step.Phoenix_Approver__c,step);} 
            }
        }
        system.debug('criteriaStepsMap--->'+criteriaStepsMap);
        string gridId;
        Boolean isMarketingHeadEmalReq = false;
        String bidApprovalStatus = isMarketingHead ? 'Marketing Head Rejected' : isVPFinanceHead ? 'Sr Director or VP Finance Rejected' : 'Marketing Lead Rejected';
        for(Phoenix_Approval_Grid__c grid : approvalGrids){
            system.debug('grid----->'+grid);
            system.debug('grid MarketingSrx----->'+grid.Phoenix_isMarketingSrxLeadApproved__c);
            system.debug('isMarketingSRxLead--->'+isMarketingSRxLead);
            if(grid.Phoenix_Is_Mkg_Head_Noti_Required__c){
                isMarketingHeadEmalReq =true;
            }
            if(isMarketingHead){      
                grid.Phoenix_isMarketingHeadApproved__c = true;               
                if(grid.Phoenix_Approval__c == 'Not Approved'){
                    gridId= grid.Id;
                    system.debug('grid Name-->'+grid.Name);
                    grid.Phoenix_Final_Status__c = 'Not Approved';
                }
            }  
            if(isBusinessHead){
                grid.Phoenix_isBusinessHeadApproved__c = true;
                //gridId= grid.Id;                
            }
            if(isVPFinanceHead){ 
                grid.Phoenix_isFinanceVPApproved__c = true;               
                if(grid.Phoenix_Sr_Director_VP__c == 'Not Approved'){
                    gridId= grid.Id;grid.Phoenix_Final_Status__c = 'Not Approved';
                }
            }
            if(isMarketingSRxLead){
                grid.Phoenix_isMarketingSrxLeadApproved__c =true;               
                if(grid.Phoenix_Marketing_Lead_SRx__c == 'Not Approved'){
                    gridId= grid.Id;grid.Phoenix_Final_Status__c = 'Not Approved';
                }
            }
            if(isMarketingRxLead){
                System.debug('in isMarketingRxLead');
                grid.Phoenix_isMarketingRxLeadApproved__c =true;
                
                if(grid.Phoenix_Marketing_Lead_Rx__c == 'Not Approved'){
                     System.debug('check not approved');
                    gridId= grid.Id;grid.Phoenix_Final_Status__c = 'Not Approved';
                }
            }
            if(isMarketingOTCLead){
                grid.Phoenix_IsOTCLeadApproved__c =true;               
                if(grid.Phoenix_Marketing_Lead_OTC__c == 'Not Approved'){
                    gridId= grid.Id;grid.Phoenix_Final_Status__c = 'Not Approved';
                }
            }
        }
        List<Phoenix_Bid_Line_Item__c> LineItemsList = new List<Phoenix_Bid_Line_Item__c>(); 
        for(Phoenix_Bid_Line_Item__c lineItem : bidLineItemsList){           
            if(gridId != null && lineItem.Phoenix_Approval_Grid__c == gridId){
                  System.debug('at last');
                lineItem.Phoenix_Final_Status__c = 'Not Approved';LineItemsList.add(lineItem);
            }
            
        }
        if((criteriaStepsMap != null && criteriaStepsMap.containsKey(currentUser.Id)) || vpFinanceTeam.contains(currentUser.Name)){  
            system.debug('current approve step-->'+criteriaStepsMap.get(UserInfo.getUserId())); 
            if(vpFinanceTeam.contains(currentUser.Name)){
                criteriaStepsMap.get('Sr Director or VP Finance').Phoenix_Status__c = 'Completed';  
                update criteriaStepsMap.get('Sr Director or VP Finance');  
            }else{
                criteriaStepsMap.get(currentUser.Id).Phoenix_Status__c = 'Completed';  
                update criteriaStepsMap.get(currentUser.Id);
            }
            update approvalGrids; 
            if(LineItemsList != null && LineItemsList.size() > 0)
                update LineItemsList;
            if(criteriaStepsMap.size()==1)
                updateNextProcessSteps(bidId, bidProcessStepList,stepNumber,LineItemsList,isMarketingHeadEmalReq,bidApprovalStatus);
        } /*if(criteriaStepsMap.size() == 1){

}

if(updateProcessStep != null){
updateProcessStep.Phoenix_Status__c = 'Completed';
updateProcessStep.Phoenix_Approver__c = userinfo.getuserid();
update updateProcessStep;
}*/
        
        
        /*if(bidLineItemsList.size()>0)
update bidLineItemsList;*/
        
        
    }
   // by surender---end
    
    
    @AuraEnabled 
    public static void updateNextProcessSteps(string bidId,list<Phoenix_Bid_Process_Steps__c> processStepLsit,Integer stepNumber, list<Phoenix_Bid_Line_Item__c> LineItemsList, boolean isMarketingHeadEmailReq,String bidApprovalStatus){
        Map<Integer,List<Phoenix_Bid_Process_Steps__c>> stepMap = new Map<Integer,List<Phoenix_Bid_Process_Steps__c>>();
        Map<String,List<Phoenix_Bid_Process_Steps__c>> stepNamesMap = new Map<String,List<Phoenix_Bid_Process_Steps__c>>();
        Map<String,Integer> stepnameNoMap = new Map<String,Integer>();
        list<Phoenix_Bid_Process_Steps__c> criteriaSteplist=new list<Phoenix_Bid_Process_Steps__c>();
        for(Phoenix_Bid_Process_Steps__c step : processStepLsit){
            
            Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
            if(stepMap.get(stepNo) != null){
                List<Phoenix_Bid_Process_Steps__c> adededSteps = stepMap.get(stepNo);  
                adededSteps.add(step);      
                stepMap.put(stepNo,adededSteps);
            }else{       
                stepMap.put(stepNo,new List<Phoenix_Bid_Process_Steps__c>{step});
            }
            
            String stepName = step.Phoenix_Approver_Team__c;
            if(stepNamesMap.get(stepName) != null){ 
                List<Phoenix_Bid_Process_Steps__c> adededSteps = stepNamesMap.get(stepName);  
                adededSteps.add(step);                    stepNamesMap.put(stepName,adededSteps);
            }else{       
                stepNamesMap.put(stepName,new List<Phoenix_Bid_Process_Steps__c>{step});
            }
            stepnameNoMap.put(stepName, stepNo);
            if(step.Phoenix_Is_Criteria_Step__c){
                criteriaSteplist.add(step);
            }
        }
        //start logic for all rejected case
        list<Phoenix_Bid_Line_Item__c> bidLinesUpdate=[select id,Phoenix_Final_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:bidId];
        boolean isAllRejectedCaseFound=true;
        for(Phoenix_Bid_Line_Item__c lineItem:bidLinesUpdate){
            if(lineItem.Phoenix_Final_Status__c!='Not Approved'){
                isAllRejectedCaseFound=false;
            }
        }
        if(isAllRejectedCaseFound){
            //close the bid other step not applicable
            integer currentStepNum=stepNumber;
            for(Phoenix_Bid_Process_Steps__c prcsStep:processStepLsit){
                if(prcsStep.Phoenix_Step__c==currentStepNum && prcsStep.Phoenix_Status__c=='In Process'){
                    prcsStep.Phoenix_Status__c='Completed';prcsStep.Phoenix_Approver__c = userinfo.getuserid();                    
                }
                if(prcsStep.Phoenix_Step__c>currentStepNum){
                    if(prcsStep.Name.contains('Closed')){prcsStep.Phoenix_Status__c='Completed';}
                    else{prcsStep.Phoenix_Status__c='Not Applicable';}
                }
            }
            update processStepLsit;
            Phoenix_Bid__c bid=new Phoenix_Bid__c(id=bidId,Phoenix_Approval_Status__c=bidApprovalStatus);
            update bid;
            if(isMarketingHeadEmailReq)
                Phoenix_SubmitBidForApprovalCtrl.MkgHeadEmailNotification(bidId);
        }
        else {
            
            //set<string> criteraStepsSet=new set<string>();
            //criteraStepsSet=Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(bidId);
            //system.debug('criteraStepsSet---'+criteraStepsSet);system.debug('criteriaSteplist---'+criteriaSteplist);
            //map<string,Phoenix_Bid_Process_Steps__c> updatedTeamToStepMap=new  map<string,Phoenix_Bid_Process_Steps__c>();
            string bidStatus;string approverTeam;
            //  if(criteraStepsSet.size()>0){ 
            boolean noMarketHead;boolean noVPFinance;   
            /*for(Phoenix_Bid_Process_Steps__c critStep:criteriaSteplist){
                if(!criteraStepsSet.contains('Marketing Head') && critStep.Phoenix_Approver_Team__c=='Marketing Head' && critStep.Phoenix_Status__c!='Completed'){
                    //no head 
                    noMarketHead=true;critStep.Phoenix_Status__c='Not Applicable';updatedTeamToStepMap.put('Marketing Head',critStep);
                }
                if(!criteraStepsSet.contains('Sr Director or VP Finance') && critStep.Phoenix_Approver_Team__c=='Sr Director or VP Finance' && critStep.Phoenix_Status__c!='Completed'){
                    //no vp
                    noVPFinance=true;critStep.Phoenix_Status__c='Not Applicable';updatedTeamToStepMap.put('Sr Director or VP Finance',critStep);
                }
            }
            system.debug('updated steps--'+updatedTeamToStepMap.values());
            if(updatedTeamToStepMap.values().size()>0){update updatedTeamToStepMap.values();} */
            /*if(noMarketHead==true && noVPFinance==true){
Phoenix_FinanceApprovalGrid.moveTonextStep(bidId,stepNumber,stepMap);
}else{*/
            Phoenix_FinanceApprovalGrid.moveTonextStep(bidId,stepNumber,stepMap,isMarketingHeadEmailReq);
            //}
            
            // }
            
            
        }
    }
    
    public static void moveTonextStep(string bidId,integer stepNumber,Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap, Boolean isMarketingHeadEmailReq){
      
        List < Phoenix_Bid_Process_Steps__c > nextSteps = stepMap.get(stepNumber + 1);
        system.debug('nextSteps--->' + nextSteps);
        While(nextSteps != null && nextSteps[0].Phoenix_Status__c == 'Not Applicable') {
            stepNumber += 1;
            nextSteps = stepMap.get(stepNumber);
        }
        
        if (nextSteps != null) {
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {step.Phoenix_Status__c = 'In Process'; //'In Process' Submitted //Diff b/w them            
                                                               }
        }
                if (nextSteps != null && !nextSteps.isEmpty()) {
            update nextSteps;
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = nextSteps[0].Phoenix_Approver_Team__c);
            update bid;
            Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId, nextSteps);
            if(isMarketingHeadEmailReq)
                Phoenix_SubmitBidForApprovalCtrl.MkgHeadEmailNotification(bidId);
            //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bid.Name,nextSteps,'Bid_Approval');
        }
    }
}