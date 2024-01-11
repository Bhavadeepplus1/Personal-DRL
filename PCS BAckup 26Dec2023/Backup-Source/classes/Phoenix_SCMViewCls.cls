public class Phoenix_SCMViewCls {
    
    public static string fieldApiList(String SobjectApiName){
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String bidLineStrFields = '';
        
        for (String fieldName: fieldMap.keyset()) {
            if (bidLineStrFields == null || bidLineStrFields == '') {
                bidLineStrFields = fieldName;
            } else {
                bidLineStrFields = bidLineStrFields + ' , ' + fieldName;
            }
        }
        return bidLineStrFields;
    }
    
    @AuraEnabled 
    public static List<ScmWrapper> getScmData(String bidId){
        Phoenix_Bid__c bid = [SELECT Id, Name,Phoenix_is_OTC_Bid__c, Phoenix_Bid_Type__c, Phoenix_Is_Re_Bid__c,Phoenix_Approval_Status__c, Phoenix_Customer_Type__c FROM Phoenix_Bid__c WHERE ID =: bidId];
        Boolean isOTCBid = bid.Phoenix_is_OTC_Bid__c; 
        String bidLineStrFields = fieldApiList('Phoenix_Bid_Line_Item__c');
        String bidLineExtStrFields = fieldApiList('Phoenix_BidLineItemExtn__c');
        string notApproved = 'Not Approved';
        String bidLineItemObjname = 'Phoenix_Bid_Line_Item__c';
        String bidLineItemExtObjname = 'BidLineItemsExtn__r';
        String query = 'select ' + bidLineStrFields + ', Phoenix_Product__r.name, Phoenix_Product__r.Phoenix_Supply_Chain_Planner__c,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product__r.Phoenix_Supply_Chain_Planner__r.Name '; 
        if(bid.Phoenix_Customer_Type__c == 'ROS')
            query += ',( SELECT '+bidLineExtStrFields+' FROM '+bidLineItemExtObjname+')';
        query += ' FROM '+ bidLineItemObjname + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved  ORDER BY Product_Family_Name__c ASC'  ;
        List<Phoenix_Bid_Line_Item__c> bidLineItemsList = Database.query(query);
        String totalList = 'select ' + bidLineStrFields + ', Phoenix_Product__r.name '; 
        totalList += ' FROM '+ bidLineItemObjname + ' where Phoenix_Bid__c = : bidId   ORDER BY Product_Family_Name__c ASC'  ;
        List<Phoenix_Bid_Line_Item__c> totalbidLineItemsList = Database.query(totalList);
        System.debug('totalbidLineItemsList===>'+totalbidLineItemsList);
        List<Phoenix_Bid__c> bidlist = [select Phoenix_Approval_Status__c from Phoenix_Bid__c where id=:bidId];
        integer skulength = 0;
        integer skurejeccount = 0;
        integer skuapprovedcount = 0;
        integer skunullcount=0;
        boolean isAllRejSKU =false;
        for(Phoenix_Bid__c bidItem : bidlist){
            if(bidItem.Phoenix_Approval_Status__c   == 'Supply Chain Rejected'){
                isAllRejSKU =true;
            }else{
                isAllRejSKU =false;
            }
        }
        for(Phoenix_Bid_Line_Item__c bidLineItem : totalbidLineItemsList){
            
            skulength = skulength+1;
            if(bidLineItem.Phoenix_SCM_Approval_Y_N__c =='N- Not Approved'){
                skurejeccount =skurejeccount+1;
            }
            if(bidLineItem.Phoenix_SCM_Approval_Y_N__c =='Y- Current + Inc Demand Approved' || bidLineItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Only Current Monthly Demand Approved'){
                skuapprovedcount =skuapprovedcount+1;
            }
            if(bidLineItem.Phoenix_SCM_Approval_Y_N__c == '' || bidLineItem.Phoenix_SCM_Approval_Y_N__c ==null ||bidLineItem.Phoenix_SCM_Approval_Y_N__c =='None'){
                skunullcount = skunullcount+1;
                System.debug('selected none');
            }
        }
        /* //For ROS Template logic
List<Phoenix_BidLineItemExtn__c> bidLineItemExtnList = new List<Phoenix_BidLineItemExtn__c>();
List<Phoenix_BidLineItemExtn__c> bidLineItemExtnUpdateList = new List<Phoenix_BidLineItemExtn__c>();
Map <Id, Phoenix_BidLineItemExtn__c> bliExtnMap = new Map<Id, Phoenix_BidLineItemExtn__c>(); 
if(bid.Phoenix_Customer_Type__c == 'ROS'){
query = '';
String SobjectApiName = 'Phoenix_BidLineItemExtn__c';
Set<Id> bidLineItemId = new Set<Id>();
for(Phoenix_Bid_Line_Item__c bidLineItem : bidLineItemsList){
bidLineItemId.add(bidLineItem.Id);
}

query = 'SELECT '+bidLineExtStrFields+' FROM '+SobjectApiName+' WHERE Phoenix_Bid_Line_Item__c IN: bidLineItemId';
bidLineItemExtnList = Database.query(query);
if(bidLineItemExtnList.size()>0){
for(Phoenix_BidLineItemExtn__c obj : bidLineItemExtnList){
bliExtnMap.put(obj.Phoenix_Bid_Line_Item__c, obj);
}
}
} 
*/
        List<ScmWrapper> scmWrapperList = new List<ScmWrapper>();
        Decimal copyofMonthlyDamand = 0;
        
        //Approvals logic for readonlys
        //Map<String, String> userTeamUserIdMap = new Map<String, String>();
        //for(Phoenix_User_Approval_Matrix__c matrix : [Select Id, Name,RecordType.DeveloperName,User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c,Phoenix_Approver__c,Phoenix_Approver__r.Email,Phoenix_Approver_Group_Name__c,Phoenix_Is_Active_User__c,Phoenix_Is_Approval_Process_User__c,User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]){
        //    String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c+'-'+ matrix.Phoenix_Approver__c;
        //    userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__c);
        //}
        //boolean isSCMApprovePerson=false;
        
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
        
        //if((userTeamUserIdMap.containsKey('Supply Chain-'+UserInfo.getUserId()) && !isOTCBid) ||  isDelegationPerson || (isOTCBid && userTeamUserIdMap.containsKey('OTC Supply Chain-'+UserInfo.getUserId())))
        //    isSCMApprovePerson=true;
        
        //List<String> productDirectorList = new List<String>();
        boolean isScMReviewed= false, readyTosubmit= false; 
        integer totalSKUs=0;
        //end of Approvals logic for readonlys
        for(Phoenix_Bid_Line_Item__c bidLineItem : bidLineItemsList){
            if(bidLineItem.Phoenix_SCM_Review__c)
                isScMReviewed=true;
                                                 
            if(bidLineItem.Phoenix_SCM_Approval_Y_N__c == 'None' || bidLineItem.Phoenix_SCM_Approval_Y_N__c == null)       
                readyTosubmit= true;
                                                                                                                    
        }
        if(! isAllRejSKU){
            for(Phoenix_Bid_Line_Item__c bidLineItem : bidLineItemsList){
                //if(bidLineItem.Phoenix_Product_Director__c!=null && !productDirectorList.contains(bidLineItem.Phoenix_Product_Director__c))               
                   // productDirectorList.add(bidLineItem.Phoenix_Product_Director__c);
                    
                // if(bidLineItem.Phoenix_Product_Family__c != null && bidLineItem.Phoenix_Product_Code__c != null){
                ScmWrapper scmWrapperObj = new ScmWrapper();
                scmWrapperObj.sapNumber = bidLineItem.Phoenix_Product_Code__c ;
                scmWrapperObj.productName = bidLineItem.Phoenix_Product__r.Name;
                scmWrapperObj.productFamily = bidLineItem.Phoenix_Product_Family__c ;
                scmWrapperObj.casePack = bidLineItem.Phoenix_Pkg_Size__c ;
                scmWrapperObj.scmApproverName = bidLineItem.Phoenix_Supply_Chain_Planner__r.Name;
                scmWrapperObj.scmApproverId = bidLineItem.Phoenix_Supply_Chain_Planner__c;//Phoenix_Product__r.Phoenix_Supply_Chain_Planner__c;
                //Added by Naseer to replace Product Family with Lookup
                scmWrapperObj.productFamilyId = bidLineItem.Product_Family__c;
                scmWrapperObj.productFamilyName = bidLineItem.Product_Family_Name__c;
                //
                boolean isDelegationPerson=false;
                if(deligatorApprover !=null && deligatorApprover.size()>0){
                    for(Phoenix_Approval_Delegation_History__c aprHisDel : deligatorApprover){
                        if(UserInfo.getUserId() == aprHisDel.Phoenix_User__c)
                            isDelegationPerson = true;
                    }
                }
                if(UserInfo.getUserId() == bidLineItem.Phoenix_Supply_Chain_Planner__c || isDelegationPerson)
                    scmWrapperObj.isSCMApprovePerson = true;
                Decimal totalsellingUnit = bidLineItem.Phoenix_Total_Selling_Unit__c != null ? bidLineItem.Phoenix_Total_Selling_Unit__c : 0;
                Decimal proposedDirectUnits = bidLineItem.Phoenix_Proposed_Direct_Selling_Unit__c != null ? bidLineItem.Phoenix_Proposed_Direct_Selling_Unit__c : 0;
                Decimal proposedIndirectUnits = bidLineItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null ? bidLineItem.Phoenix_Proposed_Indirect_Selling_Unit__c : 0;
                if(bidLineItem.Phoenix_Total_Selling_Unit__c != null)
                    scmWrapperObj.monthlyDemand = ((totalsellingUnit/ 12)>0 && (totalsellingUnit/ 12) < 1) ? 1 : (totalsellingUnit/ 12).setScale(0) ;
                else                 scmWrapperObj.monthlyDemand = null;
                copyofMonthlyDamand = scmWrapperObj.monthlyDemand == null ? copyofMonthlyDamand : scmWrapperObj.monthlyDemand;
                if(bidLineItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null && bidLineItem.Phoenix_Proposed_Direct_Selling_Unit__c != null){
                    scmWrapperObj.totalRevisedReq = ((proposedDirectUnits+proposedIndirectUnits) / 12 > 0 && (proposedDirectUnits+proposedIndirectUnits) / 12 < 1) ? 1 : ((proposedDirectUnits+proposedIndirectUnits) / 12).setScale(0) ; 
                }              
                else if(bidLineItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null) {               
                    scmWrapperObj.totalRevisedReq = ((proposedIndirectUnits) / 12 > 0 && (proposedIndirectUnits) / 12 < 1) ? 1 : ((proposedIndirectUnits) / 12).setScale(0) ; 
                }
                else if(bidLineItem.Phoenix_Proposed_Direct_Selling_Unit__c != null) {                
                    scmWrapperObj.totalRevisedReq = ((proposedDirectUnits) / 12 > 0 && (proposedDirectUnits) / 12 < 1) ? 1 : ((proposedDirectUnits) / 12).setScale(0) ; 
                }
                else{
                    scmWrapperObj.totalRevisedReq = null;
                }
                if(scmWrapperObj.totalRevisedReq != null && scmWrapperObj.monthlyDemand != null)                 scmWrapperObj.additionalReq = (scmWrapperObj.totalRevisedReq - scmWrapperObj.monthlyDemand).setScale(0) ;
                scmWrapperObj.scmApproval = bidLineItem.Phoenix_SCM_Approval_Y_N__c ;
                scmWrapperObj.scmAprQtyPercent = bidLineItem.Phoenix_SCM_Approved_Quantity__c ;
                if(scmWrapperObj.totalRevisedReq != null)                  scmWrapperObj.dollarValue = scmWrapperObj.totalRevisedReq *  bidLineItem.Phoenix_Internal_Dead_Net_Price__c;
                else
                    scmWrapperObj.dollarValue = null;
                //if(scmWrapperObj.totalRevisedReq != null && bidLineItem.Phoenix_SCM_Approved_Quantity__c != null)
                //scmWrapperObj.totalRevisedReq = scmWrapperObj.totalRevisedReq * bidLineItem.Phoenix_SCM_Approved_Quantity__c ;
                if(bidLineItem.Phoenix_SCM_Approved_Quantity__c != null && scmWrapperObj.scmAprQtyPercent != null && scmWrapperObj.additionalReq != null)                scmWrapperObj.scmAprQty = (copyofMonthlyDamand + (bidLineItem.Phoenix_SCM_Approved_Quantity__c / 100 ) * scmWrapperObj.additionalReq);
                else
                    scmWrapperObj.scmAprQty = copyofMonthlyDamand;
                //Phoenix_BidLineItemExtn__c bliExtObj = new Phoenix_BidLineItemExtn__c();
                if(bid.Phoenix_Customer_Type__c == 'ROS'){
                    //if(bliExtnMap.containskey(bidLineItem.Id)){
                    // bliExtObj = bliExtnMap.get(bidLineItem.Id);
                    scmWrapperObj.cvsAprvdDirSelunits = bidLineItem.Phoenix_Current_Anda_Units__c;//bliExtObj.Phoenix_ApprovedCVSDirSellingUnits__c!=null ? bliExtObj.Phoenix_ApprovedCVSDirSellingUnits__c : 0;
                    scmWrapperObj.cvsAprvdIndirSelunits = bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c;//bliExtObj.Phoenix_ApprovedCVSIndirSellingUnits__c!=null ? bliExtObj.Phoenix_ApprovedCVSIndirSellingUnits__c : 0;
                    scmWrapperObj.CardAprvdSelUnits = bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c;//bliExtObj.Phoenix_ApprovedCardinalSellingUnits__c!=null ? bliExtObj.Phoenix_ApprovedCardinalSellingUnits__c : 0;
                    scmWrapperObj.MajAprvdSelUnits = bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c;//bliExtObj.Phoenix_ApprovedMajorSellingUnits__c!=null ? bliExtObj.Phoenix_ApprovedMajorSellingUnits__c : 0;
                    
                    //}
                }
                /* For SKU's Count*/
                
                
                if(scmWrapperObj.scmApproval !=null && (scmWrapperObj.scmApproval == 'Y- Current + Inc Demand Approved' || scmWrapperObj.scmApproval == 'Y- Only Current Monthly Demand Approved')){
                    // totalSKUs = totalSKUs+1;
                }
                /*End For SKU's Count*/
                scmWrapperObj.estimatedTime = bidLineItem.Phoenix_Estimated_Lead_Time_Days__c ;
                scmWrapperObj.scmrejectionReason = bidLineItem.Phoenix_SCM_Rejection_Reason1__c;
                scmWrapperObj.scmcomments = bidLineItem.Phoenix_SCM_Notes__c != null ? bidLineItem.Phoenix_SCM_Notes__c.replaceAll('#',' '):bidLineItem.Phoenix_SCM_Notes__c ;
                scmWrapperObj.revisitedDate = bidLineItem.Phoenix_Revisited_Date__c;
                scmWrapperObj.currentRecordId = bidLineItem.Id;
                scmWrapperObj.initialStockingOrderVolume =  bidLineItem.Phoenix_Initial_Stocking_Order_Volume__c ; 
                scmWrapperObj.initialStockingOrderComments =  bidLineItem.Phoenix_Initial_Stocking_Order_Comments__c != null ? bidLineItem.Phoenix_Initial_Stocking_Order_Comments__c.replaceAll('#', ' '):bidLineItem.Phoenix_Initial_Stocking_Order_Comments__c ; 
                scmWrapperObj.finalSCMApproval = bidLineItem.Phoenix_SCM_Final_Approval__c;
                scmWrapperObj.bidRecord = bid;
                scmWrapperObj.isSCMReview = bidLineItem.Phoenix_SCM_Review__c;
                scmWrapperObj.isSCMReviewNeed = isSCMReviewed;
                scmWrapperObj.isReadyToSubmit = readyTosubmit;
                scmWrapperObj.finalsellingUnits = bidLineItem.Phoenix_Final_Total_Selling_Unit__c;
                scmWrapperObj.totalsellingUnits = bidLineItem.Phoenix_Total_Selling_Unit__c;
                // scmWrapperObj.nextReviewDate = bidLineItem.Phoenix_SCM_Next_Review_Date__c;
                //scmWrapperObj.isSCMApprovePerson=isSCMApprovePerson;//added by hari for aaprovals
                
                // scmWrapperObj.totalbidLineItemsList = new List<Phoenix_Bid_Line_Item__c>(totalbidLineItemsList);
                scmWrapperObj.skulength = skulength;
                scmWrapperObj.skurejeccount=skurejeccount;
                scmWrapperObj.skuapprovedcount= skuapprovedcount;
                scmWrapperObj.skunullcount= skunullcount;
                scmWrapperObj.isAllRejSKU=isAllRejSKU;
                scmWrapperList.add(scmWrapperObj);
                // }
            }
            return scmWrapperList;
        }
        else{
            
            for(Phoenix_Bid_Line_Item__c bidLineItem :totalbidLineItemsList){
                ScmWrapper scmWrapperObj = new ScmWrapper();
                scmWrapperObj.skulength = skulength;
                scmWrapperObj.skurejeccount=skurejeccount;
                scmWrapperObj.skuapprovedcount= skuapprovedcount;
                scmWrapperObj.skunullcount= skunullcount;
                scmWrapperObj.isAllRejSKU=isAllRejSKU;
                scmWrapperList.add(scmWrapperObj);
            }
            return scmWrapperList;
            
            
        }
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
        @AuraEnabled Public decimal cvsAprvdDirSelunits;
        @AuraEnabled Public decimal cvsAprvdIndirSelunits;
        @AuraEnabled Public decimal CardAprvdSelUnits;
        @AuraEnabled Public decimal MajAprvdSelUnits;
        @AuraEnabled Public String scmApproval;
        @AuraEnabled Public decimal scmAprQtyPercent;
        @AuraEnabled Public decimal scmAprQty;
        @AuraEnabled Public String estimatedTime;
        @AuraEnabled Public String scmrejectionReason;
        @AuraEnabled Public Date revisitedDate;
        @AuraEnabled Public Date nextReviewDate;
        @AuraEnabled Public String scmcomments;
        @AuraEnabled Public String currentRecordId;
        @AuraEnabled Public decimal initialStockingOrderVolume;
        @AuraEnabled Public string initialStockingOrderComments;
        @AuraEnabled Public boolean finalSCMApproval;
        @AuraEnabled Public boolean isSCMReview;
        @AuraEnabled Public boolean isSCMReviewNeed;
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        @AuraEnabled public boolean isSCMApprovePerson;
        @AuraEnabled public boolean isReadyToSubmit;
        @AuraEnabled public List<String> productDirectorList;
        @AuraEnabled public List<Phoenix_Bid_Line_Item__c> totalbidLineItemsList;
        @AuraEnabled public decimal finalsellingUnits;
        @AuraEnabled public decimal totalsellingUnits;
        @AuraEnabled public integer skulength;
        @AuraEnabled public integer skurejeccount;
        @AuraEnabled public integer skuapprovedcount;
        @AuraEnabled public integer skunullcount;
        @AuraEnabled public boolean isAllRejSKU;
        @auraEnabled public String scmApproverName;
        @auraEnabled public string scmApproverId;
        @auraEnabled public string productFamilyId;
        @auraEnabled public string productFamilyName;
        
        ScmWrapper(){
            bidRecord = new Phoenix_Bid__c();
            isSCMApprovePerson=false;
            productDirectorList = new List<String>();
            //totalbidLineItemsList = new List<Phoenix_Bid_Line_Item__c>();
        }
        
        
        
    }
    @AuraEnabled
    public static List<ScmWrapper> updateLineItems(String bidId , Map<String, Map<String,String> > scmApprovalMap, Map<String, Map<String,String> > scmApprovalQtyMap,
                                                   Map<String, Map<String,String> > estimatedDaysMap, Map<String, Map<String,String> > scmRejReason,Map<String, 
                                                   Map<String,String> > scmCommentsMap,Map<String, Map<String,String> > initialVolumeMap, Map<String, 
                                                   Map<String,String> > initialCommentsMap,Map<String, Map<String,Date> > revisitedDateMap,Map<String, 
                                                   Map<String,Date> > nextReviewDateMap , string scmApproval , boolean isSCMApproved)
    {
        String query = '';
        List<String> idsList = new List<String>();
        if(scmApprovalMap != null)            idsList.addAll(scmApprovalMap.keySet());
        if(scmApprovalQtyMap != null)            idsList.addAll(scmApprovalQtyMap.keySet());
        if(estimatedDaysMap != null)            idsList.addAll(estimatedDaysMap.keySet());
        if(scmRejReason != null)            idsList.addAll(scmRejReason.keySet());
        if(scmCommentsMap != null)            idsList.addAll(scmCommentsMap.keySet());
        if(initialVolumeMap != null)            idsList.addAll(initialVolumeMap.keySet());
        if(initialCommentsMap != null)            idsList.addAll(initialCommentsMap.keySet());
        if(revisitedDateMap != null)            idsList.addAll(revisitedDateMap.keySet());
        if(nextReviewDateMap != null)            idsList.addAll(nextReviewDateMap.keySet());
        
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
                                                       
        
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for(String fieldName : fieldMap.keyset() )
        {
            if(strFields == null || strFields == '') 
                strFields = fieldName;
            else
                strFields = strFields + ' , ' + fieldName;
        }
        List<Phoenix_Bid_Line_Item__c> bidLineItemsList = new List<Phoenix_Bid_Line_Item__c>();
        if(isSCMApproved == true){
            string notApproved = 'Not Approved';
            string query1 = 'select ' + strFields + ',Phoenix_Bid__r.Phoenix_Is_Re_Bid__c, Phoenix_Product__r.name, Phoenix_Product__r.Phoenix_Supply_Chain_Planner__c from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved  ORDER BY Product_Family_Name__c ASC'  ;
            List<Phoenix_Bid_Line_Item__c> allbidLineItemsList = Database.query(query1);
            for(Phoenix_Bid_Line_Item__c bidline : allbidLineItemsList){
                boolean isDelegationPerson=false;
                if(deligatorApprover !=null && deligatorApprover.size()>0){
                    for(Phoenix_Approval_Delegation_History__c aprHisDel : deligatorApprover){
                        if(UserInfo.getUserId() == aprHisDel.Phoenix_User__c)
                            isDelegationPerson = true;
                    }
                }
                if(UserInfo.getUserId() == bidline.Phoenix_Product__r.Phoenix_Supply_Chain_Planner__c || isDelegationPerson){
                    if(bidline.Phoenix_SCM_Review__c || !bidline.Phoenix_Bid__r.Phoenix_Is_Re_Bid__c){                    
                        bidline.Phoenix_SCM_Approval_Y_N__c = scmApproval;
                        if(scmApproval == 'Y- Only Current Monthly Demand Approved')                        bidline.Phoenix_SCM_Approved_Quantity__c = 0 ; 
                        if(scmApproval == 'Y- Current + Inc Demand Approved')                        bidline.Phoenix_SCM_Approved_Quantity__c = 100 ; 
                        if(scmApproval == 'N- Not Approved')                        bidline.Phoenix_SCM_Approved_Quantity__c = null ;
                    }
                }
            }
            update allbidLineItemsList;
        }
        if(idsList != null){
            query = 'select ' + strFields + ', Phoenix_Product__r.name from ' + SobjectApiName + ' where Id = : idsList ORDER BY Product_Family_Name__c ASC'  ;
            bidLineItemsList = Database.query(query);
            
        }
        if(bidLineItemsList != null && bidLineItemsList.size() > 0){
            for(Phoenix_Bid_Line_Item__c bidLineItem : bidLineItemsList){
                
                if(scmApprovalMap != null){
                    for(String lineItemId : scmApprovalMap.keySet()){
                        if(lineItemId == bidLineItem.Id)                            
                            bidLineItem.Phoenix_SCM_Approval_Y_N__c = scmApprovalMap.get(bidLineItem.Id).get('SCM Approval');//scmApprovalMap.get(bidLineItem.Id).get('SCM Approval') == 'None' ? null :
                    }
                    
                }
                if(scmApprovalQtyMap != null){
                    for(String lineItemId : scmApprovalQtyMap.keySet()){
                        if(lineItemId == bidLineItem.Id && scmApprovalQtyMap.get(bidLineItem.Id).get('SCM Approved % Quantity') != null && scmApprovalQtyMap.get(bidLineItem.Id).get('SCM Approved % Quantity') != '' && scmApprovalQtyMap.get(bidLineItem.Id).get('SCM Approved % Quantity') != 'notValid'){                           
                            bidLineItem.Phoenix_SCM_Approved_Quantity__c =  decimal.valueOf(scmApprovalQtyMap.get(bidLineItem.Id).get('SCM Approved % Quantity'));
                        }else if(lineItemId == bidLineItem.Id)                          
                            bidLineItem.Phoenix_SCM_Approved_Quantity__c = null;
                    }
                    
                }
                if(initialVolumeMap != null){
                    for(String lineItemId : initialVolumeMap.keySet()){
                        if(lineItemId == bidLineItem.Id && initialVolumeMap.get(bidLineItem.Id).get('Initial Stocking Order Volume') != null && initialVolumeMap.get(bidLineItem.Id).get('Initial Stocking Order Volume') != ''){   
                            bidLineItem.Phoenix_Initial_Stocking_Order_Volume__c =  decimal.valueOf(initialVolumeMap.get(bidLineItem.Id).get('Initial Stocking Order Volume'));
                        }else if(lineItemId == bidLineItem.Id)
                            bidLineItem.Phoenix_Initial_Stocking_Order_Volume__c = null;
                    }
                }
                
                if(estimatedDaysMap != null){
                    for(String lineItemId : estimatedDaysMap.keySet()){
                        if(lineItemId == bidLineItem.Id)
                            bidLineItem.Phoenix_Estimated_Lead_Time_Days__c =  estimatedDaysMap.get(bidLineItem.Id).get('Estimated Lead Time');
                    }
                }
                if(revisitedDateMap != null){
                    for(String lineItemId : revisitedDateMap.keySet()){
                        if(lineItemId == bidLineItem.Id)                            
                            bidLineItem.Phoenix_Revisited_Date__c =  revisitedDateMap.get(bidLineItem.Id).get('revisitedDate');
                    }
                }
                /*if(nextReviewDateMap != null){
for(String lineItemId : nextReviewDateMap.keySet()){
if(lineItemId == bidLineItem.Id){                             bidLineItem.Phoenix_Revisited_Date__c =  nextReviewDateMap.get(bidLineItem.Id).get('nextReviewDate');
}

}

}*/
                if(scmRejReason != null){
                    for(String lineItemId : scmRejReason.keySet()){
                        if(lineItemId == bidLineItem.Id){                             bidLineItem.Phoenix_SCM_Rejection_Reason1__c =  scmRejReason.get(bidLineItem.Id).get('SCM Rejection Reason') == 'None' ? null : scmRejReason.get(bidLineItem.Id).get('SCM Rejection Reason');
                                                        }
                        
                    }
                    
                }if(scmCommentsMap != null){
                    for(String lineItemId : scmCommentsMap.keySet()){
                        if(lineItemId == bidLineItem.Id){                             bidLineItem.Phoenix_SCM_Notes__c =  scmCommentsMap.get(bidLineItem.Id).get('SCM Comments');
                                                        }
                        
                    }
                    
                }
                if(initialCommentsMap != null){
                    for(String lineItemId : initialCommentsMap.keySet()){
                        if(lineItemId == bidLineItem.Id){                             bidLineItem.Phoenix_Initial_Stocking_Order_Comments__c =  initialCommentsMap.get(bidLineItem.Id).get('Initial Stocking Order Comments');
                                                        }
                        
                    }
                    
                }
            }
        }
        for(Phoenix_Bid_Line_Item__c bidLineItem : bidLineItemsList){
            if(bidLineItem.Phoenix_SCM_Approval_Y_N__c == 'N- Not Approved'){                bidLineItem.Phoenix_Estimated_Lead_Time_Days__c = null;
                                                                            }
            if(bidLineItem.Phoenix_SCM_Approval_Y_N__c != 'N- Not Approved'){                bidLineItem.Phoenix_Revisited_Date__c = null;
                                                                            }
            
        }
        if(bidLineItemsList != null && bidLineItemsList.size() > 0)             update bidLineItemsList;
        return getScmData(bidId);
        
        
    }
    
    @AuraEnabled
    public static void makeApprovals(String bidId){
        String query ='';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for(String fieldName : fieldMap.keyset()){
            if(strFields == null || strFields == '')
                strFields = fieldName;
            else
                strFields = strFields + ' , ' + fieldName;
        }
        string notApproved = 'Not Approved';
        //String approvalTeam;
        query = 'select ' + strFields + ', Phoenix_Product__r.Phoenix_Supply_Chain_Planner__c, Phoenix_Product__r.name , Phoenix_Bid__r.Phoenix_Customer_Type__c,Phoenix_Bid__r.Phoenix_is_OTC_Bid__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Approval_Grid__r.Phoenix_Is_Mkg_Head_Noti_Required__c from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved  ORDER BY Product_Family_Name__c ASC'  ;
        List<Phoenix_Bid_Line_Item__c> bidLineItemsList = Database.query(query);
        //if(bidLineItemsList != null && bidLineItemsList.size()>0 && bidLineItemsList[0].Phoenix_Bid__r.Phoenix_is_OTC_Bid__c)
        //    approvalTeam = 'OTC Supply Chain';
        //else
        //    approvalTeam = 'Supply Chain';
        String approvalId = '';
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
        if(deligatorApprover !=null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c aprHisDel : deligatorApprover){
                if(UserInfo.getUserId() == aprHisDel.Phoenix_User__c)
                    approvalId = aprHisDel.Phoenix_User__c;
            }
        }
        if(approvalId == '')
            approvalId = UserInfo.getUserId();
        Phoenix_Bid_Process_Steps__c updateProcessStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Name, Phoenix_Status__c,Phoenix_Approver__r.Email, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=: bidId AND Phoenix_Approver__c =:approvalId AND Phoenix_Approver_Team__c = 'Supply Chain'];// AND Phoenix_Approver_Team__c  =: approvalTeam LIMIT 1];
        //system.debug('updateProcessStep size--> '+updateProcessStep.size());
        if(updateProcessStep != null){
            system.debug('updateProcessStep is not NULL--> ');
            updateProcessStep.Phoenix_Status__c = 'Completed';
            updateProcessStep.Phoenix_Approver__c = userinfo.getuserid();
            update updateProcessStep;
        }
        
        Boolean isMarketApproved = true;
        String bidType = '';
        List<Phoenix_Bid_Line_Item__c> updateBidLineItemsList = new List<Phoenix_Bid_Line_Item__c>();
        map<string,boolean> directorToStatusMap=new map<string,boolean>();
        map<string,list<Phoenix_Bid_Line_Item__c>> directorsBidLines=new map<string,list<Phoenix_Bid_Line_Item__c>>();
        boolean stopApllicable=false;
        boolean isMkgHeadEmailRequired = false;
        List<String> bidLineIds = New List<String>();
        for(Phoenix_Bid_Line_Item__c line : bidLineItemsList ){
            boolean isDeligator = false;
            if(deligatorApprover !=null && deligatorApprover.size()>0){
                for(Phoenix_Approval_Delegation_History__c aprHisDel : deligatorApprover){
                    if(UserInfo.getUserId() == aprHisDel.Phoenix_User__c)
                        isDeligator = true;
                }
            }
            system.debug('isDeligator--> '+isDeligator);
            if(line.Phoenix_Product__r.Phoenix_Supply_Chain_Planner__c == UserInfo.getUserId() || isDeligator){
                system.debug('---inside condition---');
                bidLineIds.add(line.Id);
                bidType = line.Phoenix_Bid__r.Phoenix_Bid_Type__c ;
                line.Phoenix_SCM_Final_Approval__c = true;
                if(line.Phoenix_SCM_Approval_Y_N__c == 'N- Not Approved')         
                    line.Phoenix_Final_Status__c = 'Not Approved';
                
                /*if(line.Phoenix_Marketing_Final_Approval__c == false){
isMarketApproved = false;
}*/
                if(directorsBidLines.containsKey(line.Phoenix_Product_Director__c)){
                    directorsBidLines.get(line.Phoenix_Product_Director__c).add(line);
                }else{
                    list<Phoenix_Bid_Line_Item__c> linesList=new list<Phoenix_Bid_Line_Item__c>();
                    linesList.add(line);
                    directorsBidLines.put(line.Phoenix_Product_Director__c,linesList);
                }
                if(line.Phoenix_Approval_Grid__r.Phoenix_Is_Mkg_Head_Noti_Required__c)
                    isMkgHeadEmailRequired = true;
                updateBidLineItemsList.add(line);
            }
        }
        
        for(string directorItem:directorsBidLines.keySet()){
            for(Phoenix_Bid_Line_Item__c bidLine:directorsBidLines.get(directorItem)){
                if(bidLine.Phoenix_SCM_Approval_Y_N__c != 'N- Not Approved'){
                    directorToStatusMap.put(directorItem,false);
                    break;
                }else      
                    directorToStatusMap.put(directorItem,true);   
            }
        }
        
        if(updateBidLineItemsList.size()>0){
            update updateBidLineItemsList;
        }
        Phoenix_SubmitBidForApprovalCtrl.SCMProductRejectionNotification(bidId);
        Phoenix_SubmitBidForApprovalCtrl.SCMPartialApprovalNotification(bidId);
        map<string,Phoenix_Bid_Process_Steps__c> directrStepMap=new map<string,Phoenix_Bid_Process_Steps__c>();
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c,Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:bidId ];
        for(Phoenix_Bid_Process_Steps__c bidprcs:bidProcessStepList){
            if(bidprcs.Phoenix_Approver_Team__c=='Marketing'){
                directrStepMap.put(bidprcs.Phoenix_Approver__r.Name,bidprcs); 
            }
        }
        list<Phoenix_Bid_Process_Steps__c> bidStepsUpdateList=new list<Phoenix_Bid_Process_Steps__c>();
        for(string director:directrStepMap.keySet()){
            if(directorToStatusMap.get(director)==true && directrStepMap.get(director).get('Phoenix_Status__c')=='In Process'){ 
                directrStepMap.get(director).put('Phoenix_Status__c','Not Applicable');                
                bidStepsUpdateList.add(directrStepMap.get(director));
            }
            if(directrStepMap.get(director).get('Phoenix_Status__c')=='In Process')  
                isMarketApproved = false;
                                                                                   
        }
        if(!bidStepsUpdateList.isEmpty())    
            update bidStepsUpdateList;
                                         
        //update directrStepMap.values();
        
        if(isMarketApproved || bidType == 'Volume Review Only')
            updateNextProcessSteps(bidId, bidProcessStepList,bidType,isMkgHeadEmailRequired);
        if(bidLineIds.size()>0){
            if(bidLineItemsList[0].Phoenix_Bid__r.Phoenix_Customer_Type__c == 'ROS'){
                List<Phoenix_BidLineItemExtn__c> extnList = [SELECT Id, Name FROM Phoenix_BidLineItemExtn__c WHERE Phoenix_Bid_Line_Item__c IN: bidLineIds];
                Update extnList;
            }
        }
    }
    
    @AuraEnabled
    public static void updatedLineItems(String bidId){
        List<Phoenix_Bid_Line_Item__c> bliListToUpdate = [SELECT Id, Name, Phoenix_SCM_Notes__c 
                                                          FROM Phoenix_Bid_Line_Item__c 
                                                          WHERE Phoenix_Bid__c =: bidId];
        List<Phoenix_Bid_Line_Item__c> bliListToUpdateNewList = new List<Phoenix_Bid_Line_Item__c>();
        for(Phoenix_Bid_Line_Item__c lineObj : bliListToUpdate){
            lineObj.Phoenix_SCM_Notes__c = lineObj.Phoenix_SCM_Notes__c !=null ? lineObj.Phoenix_SCM_Notes__c+' ': ' ';
            bliListToUpdateNewList.add(lineObj);
        }
        if(bliListToUpdateNewList.size()>0)
            update bliListToUpdateNewList;
    }
    
    @AuraEnabled 
    public static void updateNextProcessSteps(string bidId,list<Phoenix_Bid_Process_Steps__c> processStepLsit,string bidType,boolean isMkgHeadEmailRequired){
        Map<Integer,List<Phoenix_Bid_Process_Steps__c>> stepMap = new Map<Integer,List<Phoenix_Bid_Process_Steps__c>>();
        Map<String,List<Phoenix_Bid_Process_Steps__c>> stepNamesMap = new Map<String,List<Phoenix_Bid_Process_Steps__c>>();
        Map<String,Integer> stepnameNoMap = new Map<String,Integer>();
        list<Phoenix_Bid_Process_Steps__c> criteriaSteplist=new list<Phoenix_Bid_Process_Steps__c>();
        //start logic for all rejected case
        list<Phoenix_Bid_Line_Item__c> bidLinesUpdate=[select id,Phoenix_Bid__r.Phoenix_is_OTC_Bid__c,Phoenix_Final_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:bidId];
        boolean isAllRejectedCaseFound=true;
        boolean isOTCbid =false;
        for(Phoenix_Bid_Line_Item__c lineItem:bidLinesUpdate){
            if(lineItem.Phoenix_Final_Status__c!='Not Approved'){
                isAllRejectedCaseFound=false;
                isOTCbid = lineItem.Phoenix_Bid__r.Phoenix_is_OTC_Bid__c;
            }
        }
        
        for(Phoenix_Bid_Process_Steps__c step : processStepLsit){
            
            Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
            if(stepMap.get(stepNo) != null){
                List<Phoenix_Bid_Process_Steps__c> adededSteps = stepMap.get(stepNo);adededSteps.add(step);stepMap.put(stepNo,adededSteps);
            }else{
                stepMap.put(stepNo,new List<Phoenix_Bid_Process_Steps__c>{step});
            }
            String stepName = step.Phoenix_Approver_Team__c;
            if(isOTCbid && step.Phoenix_Approver_Team__c == 'OTC Supply Chain')
                stepName = 'Supply Chain';
            if(stepNamesMap.get(stepName) != null){
                List<Phoenix_Bid_Process_Steps__c> adededSteps = stepNamesMap.get(stepName);
                adededSteps.add(step);
                stepNamesMap.put(stepName,adededSteps);
            }else{
                stepNamesMap.put(stepName,new List<Phoenix_Bid_Process_Steps__c>{step});
            }
            stepnameNoMap.put(stepName, stepNo);
            if(step.Phoenix_Is_Criteria_Step__c){
                criteriaSteplist.add(step);
            }
        }
        
        
        
        if(isAllRejectedCaseFound){
            //close the bid other step not applicable
            integer currentStepNum=stepnameNoMap.get('Supply Chain');
            for(Phoenix_Bid_Process_Steps__c prcsStep:processStepLsit){
                if(prcsStep.Phoenix_Approver_Team__c=='Marketing' && prcsStep.Phoenix_Status__c!='Completed' && prcsStep.Phoenix_Step__c==currentStepNum){  
                    prcsStep.Phoenix_Status__c='Not Applicable';
                }
                if(prcsStep.Phoenix_Approver_Team__c=='Supply Chain' || (isOTCbid && prcsStep.Phoenix_Approver_Team__c == 'OTC Supply Chain') ){
                    prcsStep.Phoenix_Status__c='Completed';
                    prcsStep.Phoenix_Approver__c = userinfo.getuserid();                    
                }
                if(prcsStep.Phoenix_Step__c>currentStepNum){
                    if(prcsStep.Name.contains('Closed')){                        prcsStep.Phoenix_Status__c='Completed';
                                                        }
                    else{prcsStep.Phoenix_Status__c='Not Applicable';}
                }
            }
            update processStepLsit;
            Phoenix_Bid__c bid=new Phoenix_Bid__c(id=bidId,Phoenix_Approval_Status__c='Supply Chain Rejected');
            update bid;
        }
        else{   
            set<string> criteraStepsSet=new set<string>();
            criteraStepsSet=Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(bidId);
            map<string,Phoenix_Bid_Process_Steps__c> updatedTeamToStepMap=new  map<string,Phoenix_Bid_Process_Steps__c>();
            string bidStatus;
            if(criteraStepsSet.size()>0 && !isOTCbid){ 
                for(Phoenix_Bid_Process_Steps__c critStep:criteriaSteplist){
                    if(criteraStepsSet.contains('Marketing Lead Rx') && critStep.Phoenix_Approver_Team__c=='Marketing Lead Rx'){
                        critStep.Phoenix_Status__c='In Process';updatedTeamToStepMap.put('Marketing Lead Rx',critStep);                       
                    }
                    else if(criteraStepsSet.contains('Marketing Lead SRx') && critStep.Phoenix_Approver_Team__c=='Marketing Lead SRx'){
                        critStep.Phoenix_Status__c='In Process';updatedTeamToStepMap.put('Marketing Lead SRx',critStep);                       
                    }
                    else if(criteraStepsSet.contains('Marketing Lead OTC') && critStep.Phoenix_Approver_Team__c=='Marketing Lead OTC'){
                        critStep.Phoenix_Status__c='In Process';updatedTeamToStepMap.put('Marketing Lead OTC',critStep);                      
                    }
                    if(criteraStepsSet.contains('Marketing Head') && critStep.Phoenix_Approver_Team__c=='Marketing Head'){
                        critStep.Phoenix_Status__c='Not Initiated';updatedTeamToStepMap.put('Marketing Head',critStep);
                    }
                    if(criteraStepsSet.contains('Sr Director or VP Finance') && critStep.Phoenix_Approver_Team__c=='Sr Director or VP Finance'){
                        critStep.Phoenix_Status__c='Not Initiated';updatedTeamToStepMap.put('Sr Director or VP Finance',critStep);
                    }
                    /*if(criteraStepsSet.contains('Sr Director or VP Finance') && critStep.Phoenix_Approver_Team__c=='Marketing Head'){
critStep.Phoenix_Status__c='Not Initiated';updatedTeamToStepMap.put('Marketing Head',critStep);
} */                   
                }
                update updatedTeamToStepMap.values();
                //update criteriaSteplist;
                Phoenix_Bid__c bid=new Phoenix_Bid__c(id=bidId,Phoenix_Approval_Status__c='Marketing Lead');
                update bid;
                Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId,updatedTeamToStepMap.values());
                if(isMkgHeadEmailRequired)
                    Phoenix_SubmitBidForApprovalCtrl.MkgHeadEmailNotification(bidId);
            }
            else{
                integer stepnumber=stepnameNoMap.get('Supply Chain');
                List<Phoenix_Bid_Process_Steps__c> nextSteps=stepMap.get(stepnumber+1); 
                While(nextSteps != null && nextSteps[0].Phoenix_Status__c == 'Not Applicable'){
                    stepNumber +=1;nextSteps=stepMap.get(stepNumber);
                }                
                for(Phoenix_Bid_Process_Steps__c step : nextSteps){
                    step.Phoenix_Status__c = 'In Process';//'In Process' Submitted //Diff b/w them            
                }
                if(!nextSteps.isEmpty()){
                    update nextSteps;
                    Phoenix_Bid__c bid;
                    /*if(bidType=='Volume Review Only'){
bid=new Phoenix_Bid__c(id=bidId,Phoenix_Approval_Status__c='Customer\'s Update'); 
}else{*/
                    bid=new Phoenix_Bid__c(id=bidId,Phoenix_Approval_Status__c= isOTCbid ? 'Customer\'s Update' :nextSteps[0].Phoenix_Approver_Team__c); 
                    //}
                    //Phoenix_Bid__c bid=new Phoenix_Bid__c(id=bidId,Phoenix_Approval_Status__c=nextSteps[0].Phoenix_Approver_Team__c);
                    update bid;
                    Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId,nextSteps);
                    if(isMkgHeadEmailRequired)
                        Phoenix_SubmitBidForApprovalCtrl.MkgHeadEmailNotification(bidId);
                }
            }
        }
    }
    
    public static void updateCoItems(String accId){
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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