public class Phoenix_FinanceApprovalGridView {
    @AuraEnabled 
    public static List<ScmWrapper> getScmData(String bidId){
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
        query = 'select ' + strFields + ', Product_Family__r.Name, Phoenix_Product__r.name from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved  ORDER BY Product_Family_Name__c ASC'  ;
        List<Phoenix_Bid_Line_Item__c> bidLineItemsList = Database.query(query);
        List<ScmWrapper> scmWrapperList = new List<ScmWrapper>();
        Decimal copyofMonthlyDamand = 0;
        
        //Approvals logic for readonlys
         Map<String, String> userTeamUserIdMap = new Map<String, String>();
         for(Phoenix_User_Approval_Matrix__c matrix : [Select Id, Name,RecordType.DeveloperName,User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c,Phoenix_Approver__c,Phoenix_Approver__r.Email,Phoenix_Approver_Group_Name__c,Phoenix_Is_Active_User__c,Phoenix_Is_Approval_Process_User__c,User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]){
         String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c+'-'+ matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__c);
         }
        boolean isSCMApprovePerson=false;
       
        if(userTeamUserIdMap.containsKey('Supply Chain-'+UserInfo.getUserId())){
            isSCMApprovePerson=true;
        }
        List<String> productDirectorList = new List<String>();
       //end of Approvals logic for readonlys
        Phoenix_Bid__c bid = [SELECT Id, Name, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE ID =: bidId];
        for(Phoenix_Bid_Line_Item__c bidLineItem : bidLineItemsList){
            if(bidLineItem.Phoenix_Product_Director__c!=null && !productDirectorList.contains(bidLineItem.Phoenix_Product_Director__c)){                productDirectorList.add(bidLineItem.Phoenix_Product_Director__c);
            }
           // if(bidLineItem.Phoenix_Product_Family__c != null && bidLineItem.Phoenix_Product_Code__c != null){
                ScmWrapper scmWrapperObj = new ScmWrapper();
            scmWrapperObj.sapNumber = bidLineItem.Phoenix_Product_Code__c ;
            scmWrapperObj.productName = bidLineItem.Phoenix_Product__r.Name;
            scmWrapperObj.productFamily = bidLineItem.Product_Family_Name__c ;
            scmWrapperObj.casePack = bidLineItem.Phoenix_Pkg_Size__c ;
            if(bidLineItem.Phoenix_Total_Selling_Unit__c != null)
            	scmWrapperObj.monthlyDemand = bidLineItem.Phoenix_Total_Selling_Unit__c / 12 ;
            else                 scmWrapperObj.monthlyDemand = null;
            copyofMonthlyDamand = scmWrapperObj.monthlyDemand == null ? copyofMonthlyDamand : scmWrapperObj.monthlyDemand;
            if(bidLineItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null && bidLineItem.Phoenix_Proposed_Direct_Selling_Unit__c != null)            	scmWrapperObj.totalRevisedReq = (bidLineItem.Phoenix_Proposed_Indirect_Selling_Unit__c + bidLineItem.Phoenix_Proposed_Direct_Selling_Unit__c) / 12 ;
            else                 scmWrapperObj.totalRevisedReq = null;
            if(scmWrapperObj.totalRevisedReq != null && scmWrapperObj.monthlyDemand != null)           		 scmWrapperObj.additionalReq = scmWrapperObj.totalRevisedReq - scmWrapperObj.monthlyDemand ;
            scmWrapperObj.scmApproval = bidLineItem.Phoenix_SCM_Approval_Y_N__c ;
            scmWrapperObj.scmAprQtyPercent = bidLineItem.Phoenix_SCM_Approved_Quantity__c ;
            if(scmWrapperObj.totalRevisedReq != null) 	scmWrapperObj.dollarValue = scmWrapperObj.totalRevisedReq *  bidLineItem.Phoenix_Internal_Dead_Net_Price__c;
            else
                scmWrapperObj.dollarValue = null;
            //if(scmWrapperObj.totalRevisedReq != null && bidLineItem.Phoenix_SCM_Approved_Quantity__c != null)
            	//scmWrapperObj.totalRevisedReq = scmWrapperObj.totalRevisedReq * bidLineItem.Phoenix_SCM_Approved_Quantity__c ;
            if(bidLineItem.Phoenix_SCM_Approved_Quantity__c != null && scmWrapperObj.scmAprQtyPercent != null && scmWrapperObj.additionalReq != null)            	scmWrapperObj.scmAprQty = (copyofMonthlyDamand + (bidLineItem.Phoenix_SCM_Approved_Quantity__c / 100 ) * scmWrapperObj.additionalReq);
            else
                scmWrapperObj.scmAprQty = copyofMonthlyDamand;
            scmWrapperObj.estimatedTime = bidLineItem.Phoenix_Estimated_Lead_Time_Days__c ;
            scmWrapperObj.scmrejectionReason = bidLineItem.Phoenix_SCM_Rejection_Reason1__c;
            scmWrapperObj.scmcomments = bidLineItem.Phoenix_SCM_Notes__c;
            scmWrapperObj.currentRecordId = bidLineItem.Id;
            scmWrapperObj.initialStockingOrderVolume =  bidLineItem.Phoenix_Initial_Stocking_Order_Volume__c ; 
            scmWrapperObj.initialStockingOrderComments =  bidLineItem.Phoenix_Initial_Stocking_Order_Comments__c ; 
            scmWrapperObj.finalSCMApproval = bidLineItem.Phoenix_SCM_Final_Approval__c;
            scmWrapperObj.bidRecord = bid;
            scmWrapperObj.isSCMApprovePerson=isSCMApprovePerson;//added by hari for aaprovals
            scmWrapperList.add(scmWrapperObj);
           
                
           // }
            
           
        }
      //  system.debug('scmWrapperListSize----->'+scmWrapperList.size());
       // system.debug('scmWrapperList----->'+scmWrapperList);
        return scmWrapperList;
        
    }
    
    public class ScmWrapper{
        @AuraEnabled Public String sapNumber;
        @AuraEnabled Public String productName;
        @AuraEnabled Public String productFamily;
        @AuraEnabled Public decimal casePack;
        @AuraEnabled Public decimal monthlyDemand;
        @AuraEnabled Public decimal additionalReq;
        @AuraEnabled Public decimal totalRevisedReq;
        @AuraEnabled Public decimal dollarValue;
        @AuraEnabled Public String scmApproval;
        @AuraEnabled Public decimal scmAprQtyPercent;
        @AuraEnabled Public decimal scmAprQty;
        @AuraEnabled Public String estimatedTime;
        @AuraEnabled Public String scmrejectionReason;
        @AuraEnabled Public String scmcomments;
        @AuraEnabled Public String currentRecordId;
        @AuraEnabled Public decimal initialStockingOrderVolume;
        @AuraEnabled Public string initialStockingOrderComments;
        @AuraEnabled Public boolean finalSCMApproval;
       @AuraEnabled public Phoenix_Bid__c bidRecord;
       @AuraEnabled public boolean isSCMApprovePerson;
       @AuraEnabled public List<String> productDirectorList;
        
        
        ScmWrapper(){
            bidRecord = new Phoenix_Bid__c();
            isSCMApprovePerson=false;
            productDirectorList = new List<String>();
        }
       
        
        
    }
    @AuraEnabled
    public static List<ScmWrapper> updateLineItems(String bidId , Map<String, Map<String,String> > scmApprovalMap, Map<String, Map<String,String> > scmApprovalQtyMap,Map<String, Map<String,String> > estimatedDaysMap, Map<String, Map<String,String> > scmRejReason,Map<String, Map<String,String> > scmCommentsMap,Map<String, Map<String,String> > initialVolumeMap, Map<String, Map<String,String> > initialCommentsMap, string scmApproval , boolean isSCMApproved){
        String query = '';
        List<String> idsList = new List<String>();
        if(scmApprovalMap != null)
            idsList.addAll(scmApprovalMap.keySet());
        if(scmApprovalQtyMap != null)            idsList.addAll(scmApprovalQtyMap.keySet());
        if(estimatedDaysMap != null)            idsList.addAll(estimatedDaysMap.keySet());
        if(scmRejReason != null)
            idsList.addAll(scmRejReason.keySet());
        if(scmCommentsMap != null)
            idsList.addAll(scmCommentsMap.keySet());
        if(initialVolumeMap != null)            idsList.addAll(initialVolumeMap.keySet());
        if(initialCommentsMap != null)            idsList.addAll(initialCommentsMap.keySet());
                                                        
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
        List<Phoenix_Bid_Line_Item__c> bidLineItemsList = new List<Phoenix_Bid_Line_Item__c>();
        if(isSCMApproved == true){
            string notApproved = 'Not Approved';
            string query1 = 'select ' + strFields + ',Product_Family__r.Name, Phoenix_Product__r.name from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved  ORDER BY Product_Family_Name__c ASC'  ;
            List<Phoenix_Bid_Line_Item__c> allbidLineItemsList = Database.query(query1);
            for(Phoenix_Bid_Line_Item__c bidline : allbidLineItemsList){
                bidline.Phoenix_SCM_Approval_Y_N__c = scmApproval;
                if(scmApproval == 'Y- Only Current Monthly Demand Approved')
                   bidline.Phoenix_SCM_Approved_Quantity__c = 0 ; 
                if(scmApproval == 'Y- Current + Inc Demand Approved')                   bidline.Phoenix_SCM_Approved_Quantity__c = 100 ; 
                if(scmApproval == 'N- Not Approved')                   bidline.Phoenix_SCM_Approved_Quantity__c = null ; 
            }
        	update allbidLineItemsList;
        }
        if(idsList != null){
            query = 'select ' + strFields + ',Product_Family__r.Name, Phoenix_Product__r.name from ' + SobjectApiName + ' where Id = : idsList ORDER BY Product_Family_Name__c ASC'  ;
            bidLineItemsList = Database.query(query);
      
        }
        if(bidLineItemsList != null && bidLineItemsList.size() > 0){
            for(Phoenix_Bid_Line_Item__c bidLineItem : bidLineItemsList){
                
                if(scmApprovalMap != null){
                    for(String lineItemId : scmApprovalMap.keySet()){
                        if(lineItemId == bidLineItem.Id){
                             bidLineItem.Phoenix_SCM_Approval_Y_N__c =  scmApprovalMap.get(bidLineItem.Id).get('SCM Approval') == 'None' ? null : scmApprovalMap.get(bidLineItem.Id).get('SCM Approval');
                           
                        }
                        
                    }
                   
                }
                if(scmApprovalQtyMap != null){
                    for(String lineItemId : scmApprovalQtyMap.keySet()){
                        if(lineItemId == bidLineItem.Id && scmApprovalQtyMap.get(bidLineItem.Id).get('SCM Approved % Quantity') != null && scmApprovalQtyMap.get(bidLineItem.Id).get('SCM Approved % Quantity') != '' && scmApprovalQtyMap.get(bidLineItem.Id).get('SCM Approved % Quantity') != 'notValid'){
                          //  system.debug('scm values-->'+scmApprovalQtyMap.get(bidLineItem.Id).get('SCM Approved % Quantity')); 
                            bidLineItem.Phoenix_SCM_Approved_Quantity__c =  decimal.valueOf(scmApprovalQtyMap.get(bidLineItem.Id).get('SCM Approved % Quantity'));
                        }else if(lineItemId == bidLineItem.Id) {
                            bidLineItem.Phoenix_SCM_Approved_Quantity__c = null;
                        }
                        
                    }
                   
                }
                if(initialVolumeMap != null){
                    for(String lineItemId : initialVolumeMap.keySet()){
                        if(lineItemId == bidLineItem.Id && initialVolumeMap.get(bidLineItem.Id).get('Initial Stocking Order Volume') != null && initialVolumeMap.get(bidLineItem.Id).get('Initial Stocking Order Volume') != ''){
                           // system.debug('scm values-->'+initialVolumeMap.get(bidLineItem.Id).get('Initial Stocking Order Volume')); 
                            bidLineItem.Phoenix_Initial_Stocking_Order_Volume__c =  decimal.valueOf(initialVolumeMap.get(bidLineItem.Id).get('Initial Stocking Order Volume'));
                        }else if(lineItemId == bidLineItem.Id) {
                            bidLineItem.Phoenix_Initial_Stocking_Order_Volume__c = null;
                        }
                        
                    }
                   
                }
                if(estimatedDaysMap != null){
                    for(String lineItemId : estimatedDaysMap.keySet()){
                        if(lineItemId == bidLineItem.Id){
                             bidLineItem.Phoenix_Estimated_Lead_Time_Days__c =  estimatedDaysMap.get(bidLineItem.Id).get('Estimated Lead Time');
                        }
                        
                    }
                   
                }
                if(scmRejReason != null){
                    for(String lineItemId : scmRejReason.keySet()){
                        if(lineItemId == bidLineItem.Id){
                             bidLineItem.Phoenix_SCM_Rejection_Reason1__c =  scmRejReason.get(bidLineItem.Id).get('SCM Rejection Reason') == 'None' ? null : scmRejReason.get(bidLineItem.Id).get('SCM Rejection Reason');
                        }
                        
                    }
                   
                }if(scmCommentsMap != null){
                    for(String lineItemId : scmCommentsMap.keySet()){
                        if(lineItemId == bidLineItem.Id){
                             bidLineItem.Phoenix_SCM_Notes__c =  scmCommentsMap.get(bidLineItem.Id).get('SCM Comments');
                          //  system.debug('scmcomments---->'+scmCommentsMap.get(bidLineItem.Id).get('SCM Comments'));
                        }
                        
                    }
                   
                }
                if(initialCommentsMap != null){
                    for(String lineItemId : initialCommentsMap.keySet()){
                        if(lineItemId == bidLineItem.Id){
                             bidLineItem.Phoenix_Initial_Stocking_Order_Comments__c =  initialCommentsMap.get(bidLineItem.Id).get('Initial Stocking Order Comments');
                          //  system.debug('initialcomments---->'+initialCommentsMap.get(bidLineItem.Id).get('Initial Stocking Order Comments'));
                        }
                        
                    }
                   
                }
            }
        }
        if(bidLineItemsList != null && bidLineItemsList.size() > 0) 
            update bidLineItemsList;
       return getScmData(bidId);
        
            
    }
    
    @AuraEnabled
    public static void makeApprovals(String bidId){
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
        query = 'select ' + strFields + ',Product_Family__r.Name, Phoenix_Product__r.name , Phoenix_Bid__r.Phoenix_Bid_Type__c from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved  ORDER BY Product_Family_Name__c ASC'  ;
        Phoenix_Bid_Process_Steps__c updateProcessStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=: bidId AND Phoenix_Approver_Team__c  = 'Supply Chain' LIMIT 1];
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:bidId ];
        Boolean isMarketApproved = true;
        String bidType;
        if(updateProcessStep != null){
            updateProcessStep.Phoenix_Status__c = 'Completed';
            updateProcessStep.Phoenix_Approver__c = userinfo.getuserid();
            update updateProcessStep;
        }
        List<Phoenix_Bid_Line_Item__c> bidLineItemsList = Database.query(query);
        for(Phoenix_Bid_Line_Item__c line : bidLineItemsList ){
            bidType = line.Phoenix_Bid__r.Phoenix_Bid_Type__c ;
            line.Phoenix_SCM_Final_Approval__c = true;
            if(line.Phoenix_SCM_Approval_Y_N__c == 'N- Not Approved'){                  line.Phoenix_Final_Status__c = 'Not Approved';
             }
            if(line.Phoenix_Marketing_Final_Approval__c == false){                isMarketApproved = false;
            }
        }
        if(bidLineItemsList.size()>0)
            update bidLineItemsList;
        if(isMarketApproved || bidType == 'Volume Review Only'){
            updateNextProcessSteps(bidId, bidProcessStepList);
        }
        
    }
    @AuraEnabled 
    public static void updateNextProcessSteps(string bidId,list<Phoenix_Bid_Process_Steps__c> processStepLsit){
            Map<Integer,List<Phoenix_Bid_Process_Steps__c>> stepMap = new Map<Integer,List<Phoenix_Bid_Process_Steps__c>>();
            Map<String,List<Phoenix_Bid_Process_Steps__c>> stepNamesMap = new Map<String,List<Phoenix_Bid_Process_Steps__c>>();
            Map<String,Integer> stepnameNoMap = new Map<String,Integer>();
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
                    adededSteps.add(step);
                    stepNamesMap.put(stepName,adededSteps);
                }else{
                    stepNamesMap.put(stepName,new List<Phoenix_Bid_Process_Steps__c>{step});
                }
                stepnameNoMap.put(stepName, stepNo);
                
            }
            List<Phoenix_Bid_Process_Steps__c> nextSteps=stepMap.get(stepnameNoMap.get('Supply Chain')+1);
            for(Phoenix_Bid_Process_Steps__c step : nextSteps){
                step.Phoenix_Status__c = 'In Process';//'In Process' Submitted //Diff b/w them            
            }
            if(!nextSteps.isEmpty()){
                update nextSteps;
                Phoenix_Bid__c bid=new Phoenix_Bid__c(id=bidId,Phoenix_Approval_Status__c=nextSteps[0].Phoenix_Approver_Team__c);
                update bid;
                //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bid.Name,nextSteps,'Bid_Approval');
            }
        
    }

     	
}