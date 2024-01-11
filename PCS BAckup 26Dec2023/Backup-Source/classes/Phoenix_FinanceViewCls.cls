/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
public class Phoenix_FinanceViewCls {
    @AuraEnabled
    public static List < Wrapper > getProductFamlilyRollups(String bidId) {
        List < Wrapper > wrapperList = new List < Wrapper > ();
        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
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
        query = 'select Product_Family__r.Name, Phoenix_Approval_Grid__r.Phoenix_Is_SVP_Notification_Required__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved ORDER BY Product_Family_Name__c ASC';
        List < Phoenix_Bid_Line_Item__c > bidLineItemsList = Database.query(query);
        List < String > productFamilyList = new List < String > ();
        List < String > financeApprovalList = new List < String > ();
        List < String > financeCommentsList = new List < String > ();
        List < Decimal > dataMap = new List < Decimal > ();
        Decimal totalBudgtedASP = 0;
        Boolean isApproval = true;
        Map<String, Wrapper> productFamilyRollupMap = new Map<String, Wrapper>();
        for(Phoenix_Bid_Line_Item__c bidLineItem : bidLineItemsList){
            if(bidLineItem.Phoenix_Budgeted_ASP1__c != null)
                totalBudgtedASP += bidLineItem.Phoenix_Budgeted_ASP1__c;
        }
        for(Phoenix_Bid_Line_Item__c bidLineItem : bidLineItemsList){
            if(bidLineItem.Phoenix_Final_Finance_Approval__c == false)
                isApproval = false;
            //if(bidLineItem.Phoenix_Product_Family__c != null && !productFamilyRollupMap.containsKey(bidLineItem.Phoenix_Product_Family__c)){
            if(bidLineItem.Product_Family_Name__c != null && !productFamilyRollupMap.containsKey(bidLineItem.Product_Family_Name__c)){ //Replaced Phoenix_Product_Family__c with Product_Family_Name__c as a part of replacing Product Family with Lookup
                Wrapper wrapper = new Wrapper();
                wrapper.currentBottles = (bidLineItem.Phoenix_Total_Selling_Unit__c != null ? bidLineItem.Phoenix_Total_Selling_Unit__c : 0) ;
                if (bidLineItem.Phoenix_Bid_Template_Refrence__c == 'ClarusOne') {
                    wrapper.currentsalesFinance = (bidLineItem.Phoenix_Net_Sales_External__c != null ? bidLineItem.Phoenix_Net_Sales_External__c : 0);
                } else {
                    wrapper.currentsalesFinance = bidLineItem.Finance_Current_Sales__c != null ? bidLineItem.Finance_Current_Sales__c : (bidLineItem.Phoenix_Current_Sales_Finance__c != null ? bidLineItem.Phoenix_Current_Sales_Finance__c : 0);
                }
                wrapper.productFamilyOld = bidLineItem.Phoenix_Product_Family__c;
                wrapper.productFamilyId = bidLineItem.Product_Family__c;
                wrapper.currentTPMargin = (bidLineItem.Phoenix_Current_TP_Margin__c != null ? bidLineItem.Phoenix_Current_TP_Margin__c : 0) ;
                wrapper.currentTPMarginprecent = (bidLineItem.Phoenix_Current_TP_MarginPercent__c != null ? bidLineItem.Phoenix_Current_TP_MarginPercent__c :0) ;
                wrapper.currentASPorDose = (bidLineItem.Phoenix_Current_ASP_Dose__c != null ? bidLineItem.Phoenix_Current_ASP_Dose__c : 0 );
                Decimal finalUnits = bidLineItem.Phoenix_SCM_Final_Approval__c ? bidLineItem.Phoenix_Total_SCM_Approved_Qty__c :(bidLineItem.Phoenix_Final_Total_Selling_Unit__c != null ? bidLineItem.Phoenix_Final_Total_Selling_Unit__c  : 0);
                wrapper.proposedBottles = finalUnits;
                wrapper.proposedSales = (bidLineItem.Phoenix_Proposed_Sales__c != null ?  bidLineItem.Phoenix_Proposed_Sales__c : 0);
                wrapper.proposedTPMargin = (bidLineItem.Phoenix_Proposed_TP_Margin__c != null ? bidLineItem.Phoenix_Proposed_TP_Margin__c :0);
                wrapper.proposedTPMarginpercent = (bidLineItem.Phoenix_Proposed_TPMargin__c != null ? bidLineItem.Phoenix_Proposed_TPMargin__c :0 );
                wrapper.proposedASPorDose = (bidLineItem.Phoenix_Proposed_ASP_Dose__c!=null ? bidLineItem.Phoenix_Proposed_ASP_Dose__c : 0);
                wrapper.differenceBottles = (bidLineItem.Phoenix_Difference_Bottles__c !=null ? bidLineItem.Phoenix_Difference_Bottles__c:0);
                wrapper.differenceVolume = (bidLineItem.Phoenix_Difference_Volume__c !=null ?bidLineItem.Phoenix_Difference_Volume__c :0);
                wrapper.differencePrice = (bidLineItem.Phoenix_Difference_Price__c != null ?bidLineItem.Phoenix_Difference_Price__c :0);
                wrapper.differenceSales = (bidLineItem.Phoenix_Difference_Sales__c!=null?bidLineItem.Phoenix_Difference_Sales__c:0);
                wrapper.differenceMargin = (bidLineItem.Phoenix_Difference_Margin__c!=null?bidLineItem.Phoenix_Difference_Margin__c:0);
                wrapper.differenceASPPercenttoChange = (bidLineItem.Phoenix_Difference_ASP_Change__c!=null?bidLineItem.Phoenix_Difference_ASP_Change__c:0);
                wrapper.financeApproval = bidLineItem.Phoenix_Finance_Approval__c;
                wrapper.financeComments = bidLineItem.Phoenix_Finance_Comments__c != null ? bidLineItem.Phoenix_Finance_Comments__c.replaceAll('#',' ') : bidLineItem.Phoenix_Finance_Comments__c;
                wrapper.latestEstimate = (bidLineItem.Phoenix_Latest_Estimate__c !=null ? bidLineItem.Phoenix_Latest_Estimate__c : 0);
                wrapper.ProposedASP = (bidLineItem.Phoenix_Proposed_ASP_Dose__c  !=null ? bidLineItem.Phoenix_Proposed_ASP_Dose__c  : 0);
                wrapper.ProposedBudgtedASP = (bidLineItem.Phoenix_Proposed_Budget_ASP__c  !=null ? bidLineItem.Phoenix_Proposed_Budget_ASP__c  : 0);
                wrapper.internalDeadNet = (bidLineItem.Phoenix_Internal_Dead_Net_Price__c  !=null ? bidLineItem.Phoenix_Internal_Dead_Net_Price__c  : 0);
                wrapper.directDeadNet = (bidLineItem.Phoenix_Direct_Dead_Net__c  !=null ? bidLineItem.Phoenix_Direct_Dead_Net__c  : 0);
                wrapper.indirectDeadNet = (bidLineItem.Phoenix_Indirect_Dead_Net__c  !=null ? bidLineItem.Phoenix_Indirect_Dead_Net__c  : 0);
                wrapper.WMTDeadNet = (bidLineItem.Phoenix_Proposed_ASP_Dose__c   !=null ? bidLineItem.Phoenix_Proposed_ASP_Dose__c   : 0);

                productFamilyRollupMap.put(bidLineItem.Product_Family_Name__c, wrapper);
                
            }
            else if(bidLineItem.Product_Family_Name__c != null){
                Wrapper wrap1 = productFamilyRollupMap.get(bidLineItem.Product_Family_Name__c);
                wrap1.currentBottles += (bidLineItem.Phoenix_Total_Selling_Unit__c != null ? bidLineItem.Phoenix_Total_Selling_Unit__c : 0) ;
                if (bidLineItem.Phoenix_Bid_Template_Refrence__c == 'ClarusOne') {
                    wrap1.currentsalesFinance += (bidLineItem.Phoenix_Net_Sales_External__c != null ? bidLineItem.Phoenix_Net_Sales_External__c : 0);
                } else {
                    wrap1.currentsalesFinance += bidLineItem.Finance_Current_Sales__c != null ? bidLineItem.Finance_Current_Sales__c : (bidLineItem.Phoenix_Current_Sales_Finance__c != null ? bidLineItem.Phoenix_Current_Sales_Finance__c : 0);
                }
                wrap1.currentTPMargin += (bidLineItem.Phoenix_Current_TP_Margin__c != null ? bidLineItem.Phoenix_Current_TP_Margin__c : 0) ;
                wrap1.currentTPMarginprecent += (bidLineItem.Phoenix_Current_TP_MarginPercent__c != null ? bidLineItem.Phoenix_Current_TP_MarginPercent__c :0) ;
                wrap1.currentASPorDose += (bidLineItem.Phoenix_Current_ASP_Dose__c != null ? bidLineItem.Phoenix_Current_ASP_Dose__c : 0 );
                Decimal finalUnits = bidLineItem.Phoenix_SCM_Final_Approval__c ? bidLineItem.Phoenix_Total_SCM_Approved_Qty__c :(bidLineItem.Phoenix_Final_Total_Selling_Unit__c != null ? bidLineItem.Phoenix_Final_Total_Selling_Unit__c  : 0);
                wrap1.proposedBottles += (finalUnits != null ? finalUnits  : 0);
                wrap1.proposedSales += (bidLineItem.Phoenix_Proposed_Sales__c != null ?  bidLineItem.Phoenix_Proposed_Sales__c : 0);
                wrap1.proposedTPMargin += (bidLineItem.Phoenix_Proposed_TP_Margin__c != null ? bidLineItem.Phoenix_Proposed_TP_Margin__c :0);
                wrap1.proposedTPMarginpercent += (bidLineItem.Phoenix_Proposed_TPMargin__c != null ? bidLineItem.Phoenix_Proposed_TPMargin__c :0 );
                wrap1.proposedASPorDose += (bidLineItem.Phoenix_Proposed_ASP_Dose__c!=null ? bidLineItem.Phoenix_Proposed_ASP_Dose__c : 0);
                wrap1.differenceBottles += (bidLineItem.Phoenix_Difference_Bottles__c !=null ? bidLineItem.Phoenix_Difference_Bottles__c:0);
                wrap1.differenceVolume += (bidLineItem.Phoenix_Difference_Volume__c !=null ?bidLineItem.Phoenix_Difference_Volume__c :0);
                wrap1.differencePrice += (bidLineItem.Phoenix_Difference_Price__c != null ?bidLineItem.Phoenix_Difference_Price__c :0);
                wrap1.differenceSales += (bidLineItem.Phoenix_Difference_Sales__c!=null?bidLineItem.Phoenix_Difference_Sales__c:0);
                wrap1.differenceMargin += (bidLineItem.Phoenix_Difference_Margin__c!=null?bidLineItem.Phoenix_Difference_Margin__c:0);
                wrap1.differenceASPPercenttoChange = (bidLineItem.Phoenix_Difference_ASP_Change__c!=null?bidLineItem.Phoenix_Difference_ASP_Change__c:0);
                wrap1.financeApproval = bidLineItem.Phoenix_Finance_Approval__c;
                wrap1.financeComments = bidLineItem.Phoenix_Finance_Comments__c != null ? bidLineItem.Phoenix_Finance_Comments__c.replaceAll('#',' ') : bidLineItem.Phoenix_Finance_Comments__c;
                wrap1.latestEstimate += (bidLineItem.Phoenix_Latest_Estimate__c !=null ? bidLineItem.Phoenix_Latest_Estimate__c : 0);
                wrap1.ProposedASP += (bidLineItem.Phoenix_Proposed_ASP_Dose__c  !=null ? bidLineItem.Phoenix_Proposed_ASP_Dose__c  : 0);
                wrap1.ProposedBudgtedASP += (bidLineItem.Phoenix_Proposed_Budget_ASP__c  !=null ? bidLineItem.Phoenix_Proposed_Budget_ASP__c  : 0);
                wrap1.internalDeadNet += (bidLineItem.Phoenix_Internal_Dead_Net_Price__c  !=null ? bidLineItem.Phoenix_Internal_Dead_Net_Price__c  : 0);
                wrap1.directDeadNet += (bidLineItem.Phoenix_Direct_Dead_Net__c  !=null ? bidLineItem.Phoenix_Direct_Dead_Net__c  : 0);
                wrap1.indirectDeadNet += (bidLineItem.Phoenix_Indirect_Dead_Net__c  !=null ? bidLineItem.Phoenix_Indirect_Dead_Net__c  : 0);
                wrap1.WMTDeadNet += (bidLineItem.Phoenix_Proposed_ASP_Dose__c   !=null ? bidLineItem.Phoenix_Proposed_ASP_Dose__c   : 0);
                
                productFamilyRollupMap.put(bidLineItem.Product_Family_Name__c, wrap1);
             
            }
        }
     
        Phoenix_Bid__c bid = [SELECT Id, Name, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c,Phoenix_Customer_Type__c FROM Phoenix_Bid__c WHERE ID =: bidId];
        //added by hari for approval
         Map<String, String> userTeamUserIdMap = new Map<String, String>();
        for(Phoenix_User_Approval_Matrix__c matrix : [Select Id, Name,RecordType.DeveloperName,User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c,Phoenix_Approver__c,Phoenix_Approver__r.Email,Phoenix_Approver_Group_Name__c,Phoenix_Is_Active_User__c,Phoenix_Is_Approval_Process_User__c,User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]){
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c+'-'+ matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__c);
        }
        boolean isFinanceApprovePerson = false;
		boolean isDelegationPerson=false;
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
        if(deligatorApprover !=null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c aprHisDel : deligatorApprover){
                if(userTeamUserIdMap.containsKey('Finance-'+aprHisDel.Phoenix_User__c)){
                    isDelegationPerson = true;
                }
            }
        }
        if (userTeamUserIdMap.containsKey('Finance-' + UserInfo.getUserId()) || isDelegationPerson ) {
            isFinanceApprovePerson = true;
        }

        //ended by hari
        Decimal currentSalesSum = 0, currentTPMarginSum = 0, ProposedSalesSum = 0, ProposedTPMarginSum = 0;
        Decimal diffVolumeSum = 0, diffVarianceSum = 0, diffMarginSum = 0, diffSalesSum = 0; 
        for(String productFamily : productFamilyRollupMap.keySet()){
            Wrapper wrapper = new Wrapper();
            wrapper = productFamilyRollupMap.get(productFamily);
            currentSalesSum += wrapper.currentsalesFinance;
            currentTPMarginSum += wrapper.currentTPMargin;
            ProposedSalesSum += wrapper.proposedSales;
            ProposedTPMarginSum += wrapper.proposedTPMargin;
            diffVolumeSum += wrapper.differenceVolume;
            diffVarianceSum += wrapper.differencePrice;
            diffSalesSum += wrapper.differenceSales;
            diffMarginSum += wrapper.differenceMargin;
        }
        for(String productFamily : productFamilyRollupMap.keySet()){
            Wrapper wrapper = new Wrapper();
            wrapper = productFamilyRollupMap.get(productFamily);
            wrapper.currentTPMarginprecent = (wrapper.currentsalesFinance !=0)? ((wrapper.currentTPMargin / wrapper.currentsalesFinance)*100) : 0;
            wrapper.proposedTPMarginpercent = (wrapper.proposedSales !=0)? ((wrapper.proposedTPMargin / wrapper.proposedSales)*100) : 0;
            wrapper.differenceASPPercenttoChange = (wrapper.currentASPorDose != 0)? (((wrapper.proposedASPorDose / wrapper.currentASPorDose) -1)*100) : 0;
            wrapper.ProposedBudgetPercent =  (wrapper.ProposedBudgtedASP != 0) ? (((wrapper.ProposedASP / wrapper.ProposedBudgtedASP)-1)*100) : 0;
            wrapper.productFamilyName = productFamily;
            wrapper.currentsalesFinanceTotal= currentSalesSum ;
            wrapper.currentTPMarginTotal= currentTPMarginSum;
            wrapper.proposedSalesTotal = ProposedSalesSum;
            wrapper.proposedTPMarginTotal = ProposedTPMarginSum;
            wrapper.differenceVolumeTotal = diffVolumeSum;
            wrapper.differencePriceTotal= diffVarianceSum;
            wrapper.differenceSalesTotal= diffSalesSum;
            wrapper.differenceMarginTotal= diffMarginSum;
            wrapper.bidRecord = bid;
            wrapper.currentASPorDose  = wrapper.currentBottles != 0 ? (wrapper.currentsalesFinance / wrapper.currentBottles) : 0;
            wrapper.proposedASPorDose  = wrapper.proposedBottles != 0 ? (wrapper.proposedSales / wrapper.proposedBottles) : 0;
            if(bid.Phoenix_Customer_Type__c == 'Econdisc'){
                wrapper.ProposedLatestEstimate =(wrapper.latestEstimate !=0 )? (((wrapper.directDeadNet / wrapper.latestEstimate )-1)*100) : 0;
            }
            if(bid.Phoenix_Customer_Type__c == 'Walgreens' || bid.Phoenix_Customer_Type__c == 'ABC Progen' ){
                wrapper.ProposedLatestEstimate = (wrapper.latestEstimate !=0 )? (((wrapper.internalDeadNet / wrapper.latestEstimate )-1)*100) : 0;
            }
           if(bid.Phoenix_Customer_Type__c == 'Costco' || bid.Phoenix_Customer_Type__c == 'ABC Pharmagen' || bid.Phoenix_Customer_Type__c == 'Sams Club' || bid.Phoenix_Customer_Type__c == 'Government Pricing'){
                wrapper.ProposedLatestEstimate =(wrapper.latestEstimate !=0 )? (((wrapper.indirectDeadNet / wrapper.latestEstimate)-1 )*100) : 0;
            }
            if (bid.Phoenix_Customer_Type__c == 'Net Indirect Pricing') {                wrapper.ProposedLatestEstimate = (wrapper.latestEstimate != 0) ? (((wrapper.directDeadNet / wrapper.latestEstimate) - 1) * 100) : 0;
            }
            if (bid.Phoenix_Customer_Type__c == 'ClarusOne') {                wrapper.ProposedLatestEstimate = (wrapper.latestEstimate != 0) ? (((wrapper.WMTDeadNet / wrapper.latestEstimate) - 1) * 100) : 0;
            }
            wrapper.finalApproval = isApproval;
            wrapper.isFinanceApprovePerson=isFinanceApprovePerson;
            wrapperList.add(wrapper);
        }
        return wrapperList;
        
    } 
    @AuraEnabled
    public static List<Wrapper> updateLineItems(String bidId, Map<String,String> approvalMap , Map<String,String> commentsMap, string financeApproval, boolean isFinanceApproved ){
        string query, condition='';
        List<String> productFamilyList = new List<String>();
         if(approvalMap != null)
            productFamilyList.addAll(approvalMap.keySet());
        if(commentsMap != null)
            productFamilyList.addAll(commentsMap.keySet());
        string notApproved = 'Not Approved';
        query = 'SELECT id ,Product_Family__r.Name,Product_Family_Name__c, Phoenix_Finance_Comments__c, IsDeleted,Phoenix_Bid_Line_Product_Family__c ,Phoenix_Finance_Approval__c,Phoenix_Bid__c,Phoenix_Product_Family__c   FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =: bidId AND Phoenix_Final_Status__c !=: notApproved';
        List<Phoenix_Bid_Line_Item__c> allLineItemList = Database.query(query);
        if(productFamilyList != null)
            query = query + ' AND Product_Family_Name__c =: productFamilyList FOR UPDATE';
        List<Phoenix_Bid_Line_Item__c> approvalLineItemList = Database.query(query);
        if(isFinanceApproved == true){
            for(Phoenix_Bid_Line_Item__c bidLineItem : allLineItemList){
                bidLineItem.Phoenix_Finance_Approval__c = financeApproval;
            }
            update allLineItemList;
        }
        List<String> listofIds = new List<String>();
        if(approvalMap != null || commentsMap != null){
            for(Phoenix_Bid_Line_Item__c bidLineItem : approvalLineItemList){
                 //bidLineItem.Phoenix_Bid_Line_Product_Family__c  = bidLineProductMap.get(bidLineItem.Phoenix_Product_Family__c);
                 
                 if(approvalMap != null && approvalMap.keySet().contains(bidLineItem.Product_Family_Name__c)){
                 if(approvalMap.get(bidLineItem.Product_Family_Name__c) != 'None')                    bidLineItem.Phoenix_Finance_Approval__c = approvalMap.get(bidLineItem.Product_Family_Name__c);
                else                    bidLineItem.Phoenix_Finance_Approval__c = null;
            }
            if(commentsMap != null && commentsMap.keySet().contains(bidLineItem.Product_Family_Name__c)){bidLineItem.Phoenix_Finance_Comments__c = commentsMap.get(bidLineItem.Product_Family_Name__c
                                                                                                                                                                  );
                
            }
        }
        
        }
        if(approvalLineItemList != null && approvalLineItemList.size() > 0)            update approvalLineItemList;
       
        for(Phoenix_Bid_Line_Item__c bidLineItem : approvalLineItemList){          listofIds.add(bidLineItem.Phoenix_Bid_Line_Product_Family__c);
        }
        List<Phoenix_Bid_Line_Product_Family__c> toBeDeltedBidLineProductFmly = new List<Phoenix_Bid_Line_Product_Family__c>();
        if(listofIds != null && listofIds.size() > 0)            toBeDeltedBidLineProductFmly = [SELECT Id, IsDeleted, Phoenix_Bid__c, Phoenix_Finance_Approval__c, Phoenix_Finance_Comments__c FROM Phoenix_Bid_Line_Product_Family__c WHERE Phoenix_Bid__c =:  bidId]; 
        
        
        if(toBeDeltedBidLineProductFmly != null && toBeDeltedBidLineProductFmly.size() > 0)            delete toBeDeltedBidLineProductFmly ;
        for(Phoenix_Bid_Line_Product_Family__c ProductFamilyLine : toBeDeltedBidLineProductFmly){
         }
        
        List<Wrapper> wrapperList = new List<Wrapper>();
        wrapperList =  getProductFamlilyRollups(bidId) ;
        List<Phoenix_Bid_Line_Product_Family__c> bidLineProductFamilyList = new List<Phoenix_Bid_Line_Product_Family__c>();
        for(Wrapper wrapperCls : wrapperList){
            Phoenix_Bid_Line_Product_Family__c  bidLineProductFamily = new Phoenix_Bid_Line_Product_Family__c ();
            bidLineProductFamily.Name = wrapperCls.productFamilyName ;
            bidLineProductFamily.Phoenix_Bid__c = bidId ;
            bidLineProductFamily.Phoenix_Current_Bottles__c = wrapperCls.currentBottles;
            bidLineProductFamily.Phoenix_Current_Sales__c = wrapperCls.currentBottles;
            bidLineProductFamily.Phoenix_Current_TP_Margin__c = wrapperCls.currentTPMargin;
            bidLineProductFamily.Phoenix_Current_TP_Margin_Percent__c = wrapperCls.currentTPMarginprecent;
            bidLineProductFamily.Phoenix_Current_ASP_Dose__c = wrapperCls.currentASPorDose;
            bidLineProductFamily.Phoenix_Proposed_Bottles__c = wrapperCls.proposedBottles;
            bidLineProductFamily.Phoenix_Proposed_Sales__c = wrapperCls.proposedSales;
            bidLineProductFamily.Phoenix_Proposed_TP_Margin__c = wrapperCls.proposedTPMargin;
            bidLineProductFamily.Phoenix_Proposed_TP_Margin_Percent__c = wrapperCls.proposedTPMarginpercent;
            bidLineProductFamily.Phoenix_Proposed_ASP_Dose__c = wrapperCls.proposedASPorDose;
            bidLineProductFamily.Phoenix_Difference_Bottles__c = wrapperCls.differenceBottles;
            bidLineProductFamily.Phoenix_Difference_Volume__c = wrapperCls.differenceVolume;
            bidLineProductFamily.Phoenix_Difference_Price__c = wrapperCls.differencePrice;
            bidLineProductFamily.Phoenix_Difference_Sales__c = wrapperCls.differenceSales;
            bidLineProductFamily.Phoenix_Difference_Margin__c = wrapperCls.differenceMargin;
            bidLineProductFamily.Phoenix_Difference_ASP_Change__c = wrapperCls.differenceASPPercenttoChange;
            bidLineProductFamily.Phoenix_Finance_Approval__c = wrapperCls.financeApproval;
            bidLineProductFamily.Phoenix_Finance_Comments__c = wrapperCls.financeComments;
            bidLineProductFamilyList.add(bidLineProductFamily);
              }
        if(bidLineProductFamilyList != null && bidLineProductFamilyList.size() > 0)
          insert bidLineProductFamilyList;
        Map<String , String> bidLineProductMap = new Map<String , String>();
        Integer index = 0;
        for(Wrapper wrapperCls : wrapperList){
            bidLineProductMap.put(wrapperCls.productFamilyName, bidLineProductFamilyList[index++].Id);
        }
        for(Phoenix_Bid_Line_Item__c bidLineItem : allLineItemList){
            bidLineItem.Phoenix_Bid_Line_Product_Family__c  = bidLineProductMap.get(bidLineItem.Product_Family_Name__c);
            if(approvalMap != null && approvalMap.keySet().contains(bidLineItem.Product_Family_Name__c)){                if(approvalMap.get(bidLineItem.Product_Family_Name__c) != 'None')                    bidLineItem.Phoenix_Finance_Approval__c = approvalMap.get(bidLineItem.Product_Family_Name__c);
                else                    bidLineItem.Phoenix_Finance_Approval__c = null;
                /*if(approvalMap.get(bidLineItem.Phoenix_Product_Family__c) == 'Not Approved')
                    bidLineItem.Phoenix_Final_Status__c = 'Not Approved';*/
            }
            if(commentsMap != null && commentsMap.keySet().contains(bidLineItem.Product_Family_Name__c)){                bidLineItem.Phoenix_Finance_Comments__c = commentsMap.get(bidLineItem.Product_Family_Name__c);
            }
        }
        update allLineItemList;
        
        return  getProductFamlilyRollups(bidId) ;
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
        query = 'select ' + strFields + ', Phoenix_Product__r.name, Phoenix_Approval_Grid__r.Phoenix_Is_SVP_Notification_Required__c from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved  ORDER BY Phoenix_Product_Family__c ASC';
        List < Phoenix_Bid_Line_Item__c > bidLineItemsList = Database.query(query);
        Phoenix_Bid_Process_Steps__c updateProcessStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Is_Criteria_Step__c, Phoenix_Approver__r.Email, Phoenix_Approver__r.Name, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId AND Phoenix_Approver_Team__c = 'Finance'
            LIMIT 1
        ];
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver__r.Email, Phoenix_Approver__r.Name, Phoenix_Approver_Team__c, Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        if (updateProcessStep != null) {
            updateProcessStep.Phoenix_Status__c = 'Completed';
            updateProcessStep.Phoenix_Approver__c = userinfo.getuserid();
            update updateProcessStep;
        }
        boolean isSVPEmailRequired = false;
        for (Phoenix_Bid_Line_Item__c line: bidLineItemsList) {
            line.Phoenix_Final_Finance_Approval__c = true;
            if (line.Phoenix_Finance_Approval__c == 'Not Approved') {
                line.Phoenix_Final_Status__c = 'Not Approved';
            }
            if(line.Phoenix_Approval_Grid__r.Phoenix_Is_SVP_Notification_Required__c)
                isSVPEmailRequired = true;
        }
        if (bidLineItemsList.size() > 0)
            update bidLineItemsList;
        updateNextProcessSteps(bidId, bidProcessStepList,isSVPEmailRequired);

    }
    @AuraEnabled
    public static void updateNextProcessSteps(string bidId, list < Phoenix_Bid_Process_Steps__c > processStepLsit, boolean isSVPEmailRequired) {
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
        for (Phoenix_Bid_Process_Steps__c step: processStepLsit) {

            Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
            if (stepMap.get(stepNo) != null) {
                List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
                adededSteps.add(step);
                stepMap.put(stepNo, adededSteps);
            } else {
                stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
                    step
                });
            }

            String stepName = step.Phoenix_Approver_Team__c;
            if (stepName != null && stepNamesMap.get(stepName) != null) {
                List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
                adededSteps.add(step);
                stepNamesMap.put(stepName, adededSteps);
            } else if (stepName != null) {
                stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {
                    step
                });
            }
            stepnameNoMap.put(stepName, stepNo);

        }
       //start logic for all rejected case
        list < Phoenix_Bid_Line_Item__c > bidLinesUpdate = [select id, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Final_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
        boolean isAllRejectedCaseFound = true;
        String bidType = '';
        for (Phoenix_Bid_Line_Item__c lineItem: bidLinesUpdate) {
            if (lineItem.Phoenix_Final_Status__c != 'Not Approved') {
                isAllRejectedCaseFound = false;
            }
            bidType = lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c;
        }
        if (isAllRejectedCaseFound) {
            //close the bid other step not applicable
            integer currentStepNum = stepnameNoMap.get('Finance');
            for (Phoenix_Bid_Process_Steps__c prcsStep: processStepLsit) {
                if (prcsStep.Phoenix_Approver_Team__c == 'Finance') {
                    prcsStep.Phoenix_Status__c = 'Completed';
                    prcsStep.Phoenix_Approver__c = userinfo.getuserid();
                }
                if (prcsStep.Phoenix_Step__c > currentStepNum) {
                    if (prcsStep.Name.contains('Closed')) {
                        prcsStep.Phoenix_Status__c = 'Completed';
                    } else {
                        prcsStep.Phoenix_Status__c = 'Not Applicable';
                    }
                }
            }
            update processStepLsit;
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Finance Rejected');
            update bid;
        } else {
            List < Phoenix_Bid_Process_Steps__c > nextSteps = new List < Phoenix_Bid_Process_Steps__c > ();
            if (stepnameNoMap != null && stepMap != null && stepnameNoMap.get('Finance') != null)
                nextSteps = stepMap.get(stepnameNoMap.get('Finance') + 1);
            if (nextSteps != null) {
                /* for(Phoenix_Bid_Process_Steps__c step : nextSteps){
                     step.Phoenix_Status__c = 'In Process';//'In Process' Submitted //Diff b/w them Direct Order Form Pricing Update           
                 }*/
                Integer stepNumber = stepnameNoMap.get('Finance');
                While(nextSteps != null && nextSteps[0].Phoenix_Status__c == 'Not Applicable') {
                    nextSteps = stepMap.get(++stepNumber);
                }
                nextSteps[0].Phoenix_Status__c = 'In Process';
                if(nextSteps != null && nextSteps.size()>0 && (bidType=='Direct Order Form Pricing Update' || bidType == 'IPA Floor Pricing Update')){
                    nextSteps[0].Phoenix_Status__c = 'Completed';
                }
            }

            if (nextSteps != null && !nextSteps.isEmpty()) {
                update nextSteps;
              /*  if(bidType == 'Platform OTB'){
                    Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
                    update bid;
                }
                else{*/
                    Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = ((bidType=='Direct Order Form Pricing Update' || bidType == 'IPA Floor Pricing Update') ? 'Closed' : nextSteps[0].Phoenix_Approver_Team__c));
                    update bid;
              //  }
                Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId, nextSteps);
                if(isSVPEmailRequired)
                	Phoenix_SubmitBidForApprovalCtrl.SVPEmailNotification(bidId);
                //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bid.Name,nextSteps,'Bid_Approval');
            }
        }
    }


    public class Wrapper {
		@AuraEnabled public string productFamilyOld;
        @AuraEnabled public string productFamilyName;
        @AuraEnabled public string productFamilyId;
        @AuraEnabled Public decimal currentBottles;
        @AuraEnabled Public decimal currentsalesFinance;
        @AuraEnabled Public decimal currentTPMargin;
        @AuraEnabled Public decimal currentTPMarginprecent;
        @AuraEnabled Public decimal currentASPorDose;
        @AuraEnabled Public decimal proposedBottles;
        @AuraEnabled Public decimal proposedSales;
        @AuraEnabled Public decimal proposedTPMargin;
        @AuraEnabled Public decimal proposedTPMarginpercent;
        @AuraEnabled Public decimal proposedASPorDose;
        @AuraEnabled Public decimal differenceBottles;
        @AuraEnabled Public decimal differenceVolume;
        @AuraEnabled Public decimal differencePrice;
        @AuraEnabled Public decimal differenceSales;
        @AuraEnabled Public decimal differenceMargin;
        @AuraEnabled Public decimal differenceASPPercenttoChange;
        @AuraEnabled Public decimal ProposedASP;
        @AuraEnabled Public decimal ProposedBudgtedASP;
        @AuraEnabled Public decimal ProposedBudgetPercent;
        @AuraEnabled Public decimal latestEstimate;
        @AuraEnabled Public decimal internalDeadNet;
        @AuraEnabled Public decimal directDeadNet;
        @AuraEnabled Public decimal ProposedLatestEstimate;
        @AuraEnabled Public decimal indirectDeadNet;
        @AuraEnabled Public decimal WMTDeadNet;

        //Totals
        @AuraEnabled Public decimal currentsalesFinanceTotal;
        @AuraEnabled Public decimal currentTPMarginTotal;
        @AuraEnabled Public decimal proposedSalesTotal;
        @AuraEnabled Public decimal proposedTPMarginTotal;
        @AuraEnabled Public decimal differenceVolumeTotal;
        @AuraEnabled Public decimal differencePriceTotal;
        @AuraEnabled Public decimal differenceSalesTotal;
        @AuraEnabled Public decimal differenceMarginTotal;



        @AuraEnabled public string financeApproval;
        @AuraEnabled public string financeComments;
        @AuraEnabled public boolean finalApproval;
        @AuraEnabled public boolean isFinanceApprovePerson;
        @AuraEnabled public List < decimal > dataList;
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        Wrapper() {
            dataList = new List < decimal > ();
            bidRecord = new Phoenix_Bid__c();
            isFinanceApprovePerson = false;
        }

    }
}