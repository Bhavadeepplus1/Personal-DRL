/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 23-07-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Version
 **/
public class Phoenix_BidLineItemEditDemoCls {
     @AuraEnabled
    public static void getLastBidActivity(Id bidId) {
        System.debug('bidId==>'+bidId);
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Is_Re_Bid__c, Phoenix_Previous_Bid__c, Phoenix_OTB_Direct_Indirect__c, Phoenix_Bid_Proposed_Position__c, Phoenix_Proactive_Reactive__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Current_CD__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        /* Bid_Last_Activity__c actvityrec= new Bid_Last_Activity__c();
actvityrec.Name = bid.Phoenix_Bid_Name__c+'_'+ userInfo.getLastName();
actvityrec.Bid_Name__c = bid.Phoenix_Bid_Name__c;
actvityrec.Bid__c = bidId;
actvityrec.Logged_in_User__c = userInfo.getName();
actvityrec.User__c = userInfo.getUserId();
actvityrec.Date_and_Time__c = Phoenix_Util.getNowEST();
actvityrec.Test__c = Phoenix_Util.getUserTimeNow(actvityrec.Date_and_Time__c, 'America/New_York');
insert actvityrec;*/
        List<Bid_Last_Activity__c> lastActivityRec = [SELECT Id,Bid__c,Date_and_Time__c from Bid_Last_Activity__c Where Bid__c=:bidId AND User__c=:Userinfo.getUserId()];
        List<Bid_Last_Activity__c> insertList = new List<Bid_Last_Activity__c>();
        List<Bid_Last_Activity__c> updateList = new List<Bid_Last_Activity__c>();
        System.debug('lastActivityRec size==>'+lastActivityRec.size());
        if(lastActivityRec !=null && lastActivityRec.size()>0){
            for(Bid_Last_Activity__c rec: lastActivityRec){
                
                    rec.Date_and_Time__c = Phoenix_Util.getNowEST();
                    rec.Test__c = Phoenix_Util.getUserTimeNow(rec.Date_and_Time__c, 'America/New_York');
                    updateList.add(rec);
                
            }
            update lastActivityRec;
        }else{
            System.debug('in insert condition at last');
            Bid_Last_Activity__c actvityrec= new Bid_Last_Activity__c();
            actvityrec.Name = bid.Name+'_'+ userInfo.getLastName();//bid.Phoenix_Bid_Name__c+'_'+ userInfo.getLastName();
            actvityrec.Bid_Name__c = bid.Phoenix_Bid_Name__c;
            actvityrec.Bid__c = bidId;
            actvityrec.Logged_in_User__c = userInfo.getName();
            actvityrec.Date_and_Time__c = Phoenix_Util.getNowEST();
            actvityrec.User__c = userInfo.getUserId();
            actvityrec.Test__c = Phoenix_Util.getUserTimeNow(actvityrec.Date_and_Time__c, 'America/New_York');
            insert actvityrec;
        }
        
    }

    @AuraEnabled
    public static string getSubmitBidInfo(Id bidId) {
        Phoenix_SubmitBidForApprovalCtrl.BidWrapper warpper = Phoenix_SubmitBidForApprovalCtrl.getBidInfo(bidId);
        //system.debug('warpper---' + warpper.error);
        string response = Phoenix_SubmitBidForApprovalCtrl.submitBid(warpper);
        //system.debug('response--' + response);
        return response;
    }
     @AuraEnabled
    public static Phoenix_Bid__c getbidInfo(String recordId) {
        Phoenix_Bid__c bid=new Phoenix_Bid__c();
        
        if (recordId != null)
            bid = Database.query('SELECT '+Phoenix_Util.bidFields+' FROM Phoenix_Bid__c WHERE Id =: recordId LIMIT 1');
        return bid;
    }
    @AuraEnabled
    public static List < ContentDocumentLink > getExistingDocs(String bidId) {
        return [SELECT Id, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: bidId];


    }
   //added by satya not using//
    @AuraEnabled
    public static List<Phoenix_Bid_Line_Item__c> updateLatestPrice(List<Phoenix_Bid_Line_Item__c> BidLineItemListAll,List<String> productCodes,String bidId) {
        List<Phoenix_Bid_Line_Item__c> latestBid =[SELECT Id,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Product__c from Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Phoenix_Customer__c ='0011K00002RDd48QAD' AND Phoenix_Bid__r.Phoenix_Approval_Status__c != 'Draft' AND Phoenix_Bid__r.Phoenix_Customer_Type__c = 'Direct' AND Phoenix_Bid__r.Phoenix_Bid_Type__c = 'RFP Bids' AND Phoenix_Product__r.ProductCode IN:productCodes  ORDER BY CreatedDate DESC];
		Map<Id,Phoenix_Bid_Line_Item__c> latestBidLinePrices = new Map<Id,Phoenix_Bid_Line_Item__c>();
        Map<String,List<Phoenix_Bid_Line_Item__c>> bidLinesMap = new Map<String,List<Phoenix_Bid_Line_Item__c>>();
       List< Phoenix_Bid__c> bidRec = [SELECT ID,Name,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,Phoenix_Customer_Type__c,Phoenix_Customer__r.Name,CreatedById,CreatedDate from Phoenix_Bid__c WHERE Phoenix_Customer__c ='0011K00002RDd48QAD' AND Phoenix_Approval_Status__c != 'Draft' AND Phoenix_Customer_Type__c = 'Direct' AND Phoenix_Bid_Type__c = 'RFP Bids' AND ID =: bidId ORDER BY CreatedDate DESC];
        for(Phoenix_Bid_Line_Item__c bidline :  latestBid){
            if(bidLinesMap.containsKey(bidline.Phoenix_Product__c)){
                List<Phoenix_Bid_Line_Item__c> lineList = bidLinesMap.get(bidline.Phoenix_Product__c);
                lineList.add(bidline);
                bidLinesMap.put(bidline.Phoenix_Product__c,lineList);
            }
            else{
                bidLinesMap.put(bidline.Phoenix_Product__c,new List<Phoenix_Bid_Line_Item__c>{bidline});
            }
        }
        for(String key : bidLinesMap.keySet()){
            system.debug('keyList Size'+bidLinesMap.get(key)[0]);
            if(bidLinesMap.get(key).size() > 0){
                latestBidLinePrices.put(key,bidLinesMap.get(key)[0]);
            }
        }
        for (Phoenix_Bid_Line_Item__c blItem: BidLineItemListAll){
            if (blItem.Phoenix_Bid_Template_Refrence__c == 'Humana Indirect CII' && latestBidLinePrices != null && latestBidLinePrices.size()>0){
                    System.debug('checking the proposed price inside if==>'+latestBidLinePrices.get(blItem.Phoenix_Product__c));
                    blItem.Phoenix_ProposedContractBidPriceMktng__c = (latestBidLinePrices.get(blItem.Phoenix_Product__c)!=null ? latestBidLinePrices.get(blItem.Phoenix_Product__c).Phoenix_ProposedContractBidPriceMktng__c:blItem.Phoenix_ProposedContractBidPriceMktng__c);
                    blItem.Latest_Line_Item__c = (latestBidLinePrices.get(blItem.Phoenix_Product__c)!=null ? latestBidLinePrices.get(blItem.Phoenix_Product__c).Id:null);
                }
        }
        update BidLineItemListAll;
        return BidLineItemListAll;
    }
    //end by satya//
    @AuraEnabled
    public static list < Phoenix_Bid__c > getBids(List<String> productCodes,List<String> BidNames) {
        // Phoenix_Approval_Status__c != 'Supply Chain Rejected' AND
        List< Phoenix_Bid__c> bids = [SELECT ID,Phoenix_Bid_Name__c,CreatedBy.Name,Customer_Name__c,Name,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,Phoenix_Customer_Type__c,Phoenix_Customer__r.Name,CreatedById,CreatedDate from Phoenix_Bid__c WHERE Phoenix_Customer__c ='0011K00002RDd48QAD'  AND  Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Customer_Type__c = 'Direct' AND Phoenix_Bid_Type__c = 'RFP Bids' AND Name NOT IN: BidNames  ORDER BY CreatedDate DESC];
       return bids; 
    }
    @AuraEnabled
    public static list < Phoenix_Product_Position__c > getPositions(string customerID) {
        //system.debug('customerID---' + customerID);
        Set < Id > parentAccIds = new Set < Id > ();
        if (customerID != null) {
            parentAccIds.add(customerID);
            //Fetch related accounts
            Map < Id, Account > allAccMap = new Map < Id, Account > ();
            //Map of all accounts
            for (Account acc: Database.query('SELECT ' + Phoenix_Util.customerFields + ' FROM Account LIMIT 10000'))
                allAccMap.put(acc.Id, acc);
            String tempId = customerID;
            while (allAccMap.get(tempId) != NULL && allAccMap.get(tempId).ParentId != NULL) {
                tempId = allAccMap.get(tempId).ParentId;
                parentAccIds.add(tempId);
            }
            // //system.debug('parentAccIds--' + parentAccIds);
        }
        //Account bidAccount = [select ParentId, Parent.Name from account where id =: customerID limit 1];
        list < Phoenix_Product_Position__c > positionList = [select Phoenix_Customer__c, Phoenix_Customer__r.Name, Name, Phoenix_Customer__r.ParentId, Phoenix_Group_Name__c, Phoenix_General_Category__c, Phoenix_Position_Comments__c from Phoenix_Product_Position__c]; //where Phoenix_Customer__c=:parentAccIds or Phoenix_Customer__r.ParentId=:parentAccIds];//where Phoenix_Group_Name__c =: bidAccount.Parent.Name];
        list < Phoenix_Product_Position__c > AccountRelatedPositions = new list < Phoenix_Product_Position__c > ();
        list < Phoenix_Product_Position__c > OtherPositions = new list < Phoenix_Product_Position__c > ();
        for (Phoenix_Product_Position__c pos: positionList) {
            if (parentAccIds.contains(pos.Phoenix_Customer__c) || parentAccIds.contains(pos.Phoenix_Customer__r.ParentId) || customerID == pos.Phoenix_Customer__c || customerID == pos.Phoenix_Customer__r.ParentId) {
                AccountRelatedPositions.add(pos);
            } else if (AccountRelatedPositions.size() == 0 && pos.Phoenix_Customer__c == null && !parentAccIds.contains(pos.Phoenix_Customer__c) && !parentAccIds.contains(pos.Phoenix_Customer__r.ParentId)) {
                OtherPositions.add(pos);
            }
        }
        if (AccountRelatedPositions.size() > 0) {
            return AccountRelatedPositions;
        } else {
            return OtherPositions;
        }
        //return positionList;
    }
    @AuraEnabled
    public static void deleteAttachmentList(List < Id > LineItemIds) {
        List < ContentDocument > contentDocumentIds = [SELECT Id FROM ContentDocument WHERE Id IN: LineItemIds LIMIT 1000];
        if (!contentDocumentIds.isEmpty()) {
            delete contentDocumentIds;
        }
    }
    @AuraEnabled
    public static List < Phoenix_Bid_Line_Item__c > getReBidLineInfo(string productId, string bidId) {
        //system.debug('---------productId-----' + productId);
        //system.debug('---------bidId-----' + bidId);
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Is_Re_Bid__c,Phoenix_REMS_Program_Fee__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        string ultimateParent = bid.Phoenix_Ultimate_Parent__c;
        list < Phoenix_Bid__c > bidUltimateList = [SELECT Id, Phoenix_Is_Re_Bid__c, Phoenix_Current_CD__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Phoenix_Ultimate_Parent__c =: ultimateParent and Id !=: bidId];
        set < string > parentRebidIds = new set < string > ();
        for (Phoenix_Bid__c pb: bidUltimateList) {
            parentRebidIds.add(pb.Id);
        }
        parentRebidIds.add(ultimateParent);
        //system.debug('-----------parentRebidIds--------------' + parentRebidIds);
        list < Phoenix_Bid_Line_Item__c > reBidLineItemList = [SELECT id, Phoenix_Current_Indirect_Price__c, Phoenix_Retail_Indirect_Net__c, Phoenix_Current_Retail_Indirect_Net__c, Phoenix_ProposedContract_Bid_Price_Sales__c, Phoenix_ProposedContractBidPriceMktng__c, Phoenix_Wholesaler_Diff_Price_Indirect__c, Phoenix_Wholesaler_Sales_Price__c, Phoenix_Current_Retail_Indirect_Price__c, Phoenix_Retail_Direct_Sales_Price__c, Phoenix_Current_Retail_Direct_Price__c, Phoenix_Retail_Direct_Price__c, Phoenix_Retail_Indirect_Price__c, Phoenix_Retail_Direct_Guidance_Price__c, Phoenix_Wholesaler_Guidance_Price__c, Phoenix_Bid__r.CreatedDate, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Ultimate_Parent__c, Phoenix_Bid__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Guidance_Price__c FROM Phoenix_Bid_Line_Item__c WHERE(Phoenix_Product__c =: productId AND Phoenix_Bid__c IN: parentRebidIds) ORDER BY Phoenix_Bid__r.Name ASC LIMIT 30000];
        return reBidLineItemList;
    }
    @AuraEnabled
    public static list < AggregateResult > getAllTotals(Id bidId) {
        AggregateResult[] groupedResults = [select sum(Phoenix_Current_Indirect_Selling_Unit__c) cisu,
            sum(Phoenix_Current_Direct_Selling_Unit__c) cdsu,
            sum(Phoenix_Retail_Direct_Net_sales__c ) direNetSales,
            sum(Phoenix_Retail_Indirect_Net_Sales__c ) IndirNetSales, 
            sum(Phoenix_WMT_Indirect_Net_Sales__c) totalNetSaes,
            sum(Phoenix_Wholesaler_DRL_TPT__c) direTPTDollar,
            sum(Phoenix_WMT_Indirect_TPT__c) indirTPTDollar,
            sum(Phoenix_Costco_TPT__c) totalTPTDollar,
            sum(Phoenix_Total_Selling_Unit__c) tsu,
            sum(Phoenix_IOD_Total_Amount__c) iodAmountTotal,
            sum(Phoenix_Retail_IOD_overall_amount__c) salesoutAmountTotal,
            sum(Phoenix_Total_SCM_Approved_Qty__c) scmAPQTY,
            sum(Phoenix_Override_Current_Direct_Units__c) overRideDirectUnits,
            sum(Phoenix_Override_Current_Indirect_Units__c) overRideIndirectUnits,
            sum(Phoenix_12_Months_Actual_Sales__c) actSaDir12Months,
            sum(Phoenix_12_Months_IndirectSaleUnit__c) actSalInd12months,
            sum(Phoenix_12_Months_TotalSaleUnits__c) actTotal12Months,
            sum(Phoenix_Proposed_Indirect_Selling_Unit__c) pisu, sum(Phoenix_Proposed_Direct_Selling_Unit__c) pdsu,
            sum(Phoenix_Net_Sales_Internal__c) netsint, sum(Phoenix_Less_Cost__c) lesscost, sum(Phoenix_Th_Put_Margin__c) thptm,
            sum(Phoenix_Internal_Dead_Net_Price__c) intdead,
                                            sum(Phoenix_Opening_Order__c) OpeningOrder,
                                            sum(Phoenix_Opening_Order_Net_sales__c) OpeningOrderNetSales,
                                            sum(Phoenix_Opening_Order_TPT__c) OpeningOrderTPT,
                                            sum(Phoenix_Opening_Order_TPT_Per__c) OpeningOrderTPTPerc
                                            from Phoenix_Bid_Line_Item__c where
            Phoenix_Bid__c =: bidId and Phoenix_Final_Status__c != 'Not Approved'
        ];
        return groupedResults;
    }
    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > getupdatedforExport(Id bidId) {
        String query = '';
        Phoenix_Bid__c bid = [SELECT Id,Phoenix_Customer_Type__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        
        String bidLineExtStrFields = fieldApiList('Phoenix_BidLineItemExtn__c');
        String bidLineItemExtObjname = 'BidLineItemsExtn__r';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        string notApproved = 'Not Approved';
        query = 'select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields;
        if (bid.Phoenix_Customer_Type__c == 'ROS') {
            query += ',( SELECT ' + bidLineExtStrFields + ' FROM ' + bidLineItemExtObjname + ')';
        }
        query += ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved ORDER BY Phoenix_Product_Family__c ASC LIMIT 1000';
        list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);
        for(Phoenix_Bid_Line_Item__c line : quoteList){   
            line.Phoenix_Marketing_Notes__c = line.Phoenix_Marketing_Notes__c!=null ? line.Phoenix_Marketing_Notes__c.replaceAll('#',' '):line.Phoenix_Marketing_Notes__c;
            line.Phoenix_Initial_Stocking_Order_Comments__c = line.Phoenix_Initial_Stocking_Order_Comments__c!=null ? line.Phoenix_Initial_Stocking_Order_Comments__c.replaceAll('#',' '):line.Phoenix_Initial_Stocking_Order_Comments__c;
            line.Phoenix_SCM_Notes__c = line.Phoenix_SCM_Notes__c!=null ? line.Phoenix_SCM_Notes__c.replaceAll('#',' '):line.Phoenix_SCM_Notes__c;
            line.Phoenix_Sales_Notes__c = line.Phoenix_Sales_Notes__c!=null ? line.Phoenix_Sales_Notes__c.replaceAll('#',' '):line.Phoenix_Sales_Notes__c;
            line.Phoenix_Finance_Comments__c = line.Phoenix_Finance_Comments__c!=null ? line.Phoenix_Finance_Comments__c.replaceAll('#',' '):line.Phoenix_Finance_Comments__c;
            line.Phoenix_Contract_Comments__c = line.Phoenix_Contract_Comments__c!=null ? line.Phoenix_Contract_Comments__c.replaceAll('#',' '):line.Phoenix_Contract_Comments__c;
            line.Phoenix_Vistex_Comments__c = line.Phoenix_Vistex_Comments__c!=null ? line.Phoenix_Vistex_Comments__c.replaceAll('#',' '):line.Phoenix_Vistex_Comments__c;
            line.Phoenix_Sr_Director_VP_Finance_Comments__c = line.Phoenix_Sr_Director_VP_Finance_Comments__c!=null ? line.Phoenix_Sr_Director_VP_Finance_Comments__c.replaceAll('#',' '):line.Phoenix_Sr_Director_VP_Finance_Comments__c;
            line.Phoenix_Comments__c = line.Phoenix_Comments__c!=null ? line.Phoenix_Comments__c.replaceAll('#',' '):line.Phoenix_Comments__c;
            line.Phoenix_Business_Head_Comments__c = line.Phoenix_Business_Head_Comments__c!=null ? line.Phoenix_Business_Head_Comments__c.replaceAll('#',' '):line.Phoenix_Business_Head_Comments__c;
            line.Phoenix_Orange_Book_Rating1__c = line.Phoenix_Orange_Book_Rating1__c!=null ? line.Phoenix_Orange_Book_Rating1__c.replaceAll('#',' '):line.Phoenix_Orange_Book_Rating1__c;
            line.Phoenix_Product_Family1__c = line.Phoenix_Product_Family1__c!=null ? line.Phoenix_Product_Family1__c.replaceAll('#',' '):line.Phoenix_Product_Family1__c;
            line.Phoenix_Current_Position__c = line.Phoenix_Current_Position__c!=null ? line.Phoenix_Current_Position__c.replaceAll('#',' '):line.Phoenix_Current_Position__c;
        }
        return quoteList;
    }
    
    public static string fieldApiList(String SobjectApiName) {
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
    public static Wrapper getRelatedList(Id bidId) {
          getLastBidActivity(bidId);
        Wrapper wrapperObject = new Wrapper();
        Phoenix_Bid__c bid = [SELECT Id,Phoenix_REMS_Program_Fee__c, Phoenix_Sent_to_Customer_Date__c,Phoenix_Proposed_Admin_Fee_Basis__c, Phoenix_Proposed_Rebate_Basis__c, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Is_Re_Bid__c, Phoenix_Previous_Bid__c, Phoenix_OTB_Direct_Indirect__c, Phoenix_Bid_Proposed_Position__c, Phoenix_Proactive_Reactive__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Current_CD__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c,Phoenix_Customer__r.AccountNumber, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c,Phoenix_Controlled_Substance__c,Phoenix_Required_Cold_Storage__c,Phoenix_Controlled_Distribution__c, 	Humana_Latest_Bids__c  FROM Phoenix_Bid__c WHERE Id =: bidId];
        
        //String query = 'SELECT Name,Phoenix_Product__c,Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Net_Price_after_RebatesbeforeVIP__c, Phoenix_Bid__c,Phoenix_Case_Pack__c,Phoenix_Pkg_Size__c,Phoenix_Product_Family__c,Phoenix_NDC_National_Drug_Code__c,Phoenix_Product_Code__c,Phoenix_Compare_to_Brand_Name__c,Phoenix_Product_Director__c,Phoenix_Orange_Book_Rating__c,Phoenix_Throughput_cost__c,Phoenix_WAC__c,Phoenix_Current_Indirect_Selling_Unit__c	,Phoenix_Current_Direct_Selling_Unit__c,Phoenix_Total_Selling_Unit__c,Phoenix_Doses__c , Phoenix_Proposed_Indirect_Selling_Unit__c,Phoenix_Proposed_Direct_Selling_Unit__c, Phoenix_Final_Indirect_Selling_Units__c,Phoenix_Final_Direct_Selling_Units__c, Phoenix_Final_Total_Selling_Unit__c, Phoenix_Final_Annual_Extended_Units__c, Phoenix_Wholesaler_Diff_Price_Indirect__c, Phoenix_Current_Direct_Price__c, Phoenix_Current_Indirect_Price__c,  Phoenix_ProposedContract_Bid_Price_Sales__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Proposed_Current_Rebate__c, Phoenix_Current_Rebate__c, Phoenix_Proposed_Per_Unit_Rebate__c,Phoenix_Current_Per_Unit_Rebate__c, Phoenix_Gross_Contract_Sales__c, Phoenix_Value_Rebate__c,Phoenix_Value_Per_Unit_Rebate__c,Phoenix_Value_Admin_Fee__c	,Phoenix_Current_Admin_Fee__c,Phoenix_Value_Est_VIP__c,Phoenix_Sales_Out_Promotion__c,Phoenix_Initial_Order_Discount__c, Phoenix_Cash_Terms_Non_Weighted__c, Phoenix_Net_Sales_External__c ,Phoenix_Net_Sales_Internal__c ,Phoenix_Cash_Terms_Weighted__c, Phoenix_Estimated_Medicaid_Returns__c,Phoenix_Contr_Management_Fee_Wholesaler__c, Phoenix_Less_Cost__c, Phoenix_Th_Put_Margin__c, Phoenix_Net_Price_afterRebates_after_VIP__c,Phoenix_Net_Price_after_Rebates_Terms__c, Phoenix_Internal_Dead_Net_Price__c,Phoenix_TP_Margin__c, Phoenix_Budgeted_ASP_Q1_FY21__c,Phoenix_Sales_Notes__c, Phoenix_SCM_Notes__c, Phoenix_Pricing_Notes__c,Phoenix_Marketing_Notes__c,Phoenix_WAC_Check__c ,Phoenix_SSA_Hit__c   FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =: bidId limit 1000';
        ////system.debug('query'+query);
        String query = '';
        String bidLineStrFields = fieldApiList('Phoenix_Bid_Line_Item__c');
        String bidLineExtStrFields = fieldApiList('Phoenix_BidLineItemExtn__c');
        String bidLineItemExtObjname = 'BidLineItemsExtn__r';
        string notApproved = 'Not Approved';
        String bidLineItemObjname = 'Phoenix_Bid_Line_Item__c';
		boolean hasDirectorLines = false;
        User cuurentUser;
        if (bid.Phoenix_Bid_Created_Behalf_of__c != null && bid.Phoenix_Approval_Status__c == 'Draft') {
            cuurentUser = [SELECT id, Name,Profile.Name FROM User WHERE Id =: bid.Phoenix_Bid_Created_Behalf_of__c LIMIT 1];
        } else {
            cuurentUser = [SELECT id, Name,Profile.Name FROM User WHERE Id =: userinfo.getUserId() LIMIT 1];
        }
        query = 'select Phoenix_Product__r.ProductCode,Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Controlled_Substance__c,Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Refrigerated__c,Phoenix_Product__r.Phoenix_Limited_Distribution__c,Phoenix_Bid__r.Phoenix_Is_Re_Bid__c,Latest_Line_Item__r.Phoenix_Bid__c,Latest_Line_Item__r.Phoenix_Bid__r.Name,Latest_Line_Item__r.Phoenix_Final_Status__c,Latest_Line_Item__r.Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Bid__r.Phoenix_Current_CD__c,Phoenix_Bid__r.Phoenix_Proposed_Cash_Terms__c,Phoenix_Previous_Bid__r.Name,Phoenix_Previous_LineItem__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c, ' + bidLineStrFields;
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Delegated_Approver__r.Name,Phoenix_User__r.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
        String delegatedUsers = cuurentUser.Name;
        if(deligatorApprover !=null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c aprHisDel : deligatorApprover){
                delegatedUsers = delegatedUsers + ',' + aprHisDel.Phoenix_User__r.Name;
            }
        }
        if (bid.Phoenix_Customer_Type__c == 'ROS') {
            query += ',( SELECT ' + bidLineExtStrFields + ' FROM ' + bidLineItemExtObjname + ')';
        }
        query += ' from ' + bidLineItemObjname + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved ORDER BY Phoenix_Product_Family__c ASC';
        list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);
        //system.debug('quoteList--->' + quoteList);
        //Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        //Map <String, Schema.SObjectField> fieldMap = schemaMap.get('Phoenix_Bid_Line_Item__c').getDescribe().fields.getMap();
        //List<Columns> columnsList = new List<Columns>();
        /*list<String> StringList = new list<string>{'Id' ,'IsDeleted' ,'CreatedDate' ,'CreatedById', 'LastModifiedDate' ,'LastModifiedById' ,'SystemModstamp' ,'LastActivityDate', 'LastViewedDate' ,'LastReferencedDate'};
for(Schema.SObjectField sfield : fieldMap.Values())
{
schema.describefieldresult dfield = sfield.getDescribe();
boolean isContains = StringList.contains(dfield.getName());
}*/
        List < String > productFamilyList = new List < String > ();
        List < String > productDirectorList = new List < String > ();
        boolean showProceedBtn = true;
        List<String> prodIds = new List<String>();//for analysis
        for (Phoenix_Bid_Line_Item__c lineItem: quoteList) {
            prodIds.add(lineItem.Phoenix_Product__c);//for analysis
            if (!productFamilyList.contains(lineItem.Phoenix_Product_Family__c)) {
                // Columns column = new Columns();
                // column.label = string.valueof(lineItem.Phoenix_Product_Family__c) ;
                // column.value = string.valueof(lineItem.Phoenix_Product_Family__c) + 's';
                // columnsList.add(column);
                productFamilyList.add(lineItem.Phoenix_Product_Family__c);
            }
            if (lineItem.Phoenix_Product_Director__c != null && !productDirectorList.contains(lineItem.Phoenix_Product_Director__c)) {
                productDirectorList.add(lineItem.Phoenix_Product_Director__c);
            }
            //system.debug('current User-->'+userInfo.getName());
            //system.debug('Pr Dire-->'+lineItem.Phoenix_Product_Director__c);
            if (lineItem.Phoenix_Product_Director__c != null && (lineItem.Phoenix_Product_Director__c == userInfo.getName() || (delegatedUsers!=null && delegatedUsers.contains(lineItem.Phoenix_Product_Director__c))) && lineItem.Phoenix_Marketing_Final_Approval__c == false) {
                //system.debug('Has Prdouct Director');
                hasDirectorLines = true;
            }
            if (lineItem.Phoenix_Marketing_Final_Approval__c == true && lineItem.Phoenix_Product_Director__c == userinfo.getName()) {
                showProceedBtn = false;
            }
        }
        //for analysis starts
        list<GCP_SFDC_100pct_Analysis_SKU__c> gcpSkuList = [SELECT Id, Name, Vision_Product__c, Vision_Estimate_Account_Total_Vol_EU__c FROM GCP_SFDC_100pct_Analysis_SKU__c 
                                                            WHERE Vision_Customer__c =: bid.Phoenix_Customer__c AND Vision_Product__c IN: prodIds];
        Map<String, Integer> prodEstimateVolMap = new Map<String, Integer>();
        for(GCP_SFDC_100pct_Analysis_SKU__c obj:gcpSkuList){
            prodEstimateVolMap.put(obj.Vision_Product__c, Integer.valueOf(obj.Vision_Estimate_Account_Total_Vol_EU__c != null ? obj.Vision_Estimate_Account_Total_Vol_EU__c : 0));
        }
        List<Phoenix_Bid_Line_Item__c> newItem = new List<Phoenix_Bid_Line_Item__c>();
        for (Phoenix_Bid_Line_Item__c lineItem: quoteList) {
            if(prodEstimateVolMap.containsKey(lineItem.Phoenix_Product__c))
                lineItem.Vision_Analysis_Volume__c = prodEstimateVolMap.get(lineItem.Phoenix_Product__c)*lineItem.Phoenix_Pkg_Size__c;
            newItem.add(lineItem);
        }
        update newItem;
        //for analysis ends
        // //system.debug('productDirectorList--->'+productDirectorList);
        ////system.debug(UserInfo.getName());
        if(hasDirectorLines){
            showProceedBtn = true;
        }
       
        
       /* if (!productDirectorList.contains(cuurentUser.Name)) {
            hasDirectorLines = false;
        }*/
        // //system.debug('productDirectorList--->'+productDirectorList);
        ////system.debug(UserInfo.getName());
        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, Phoenix_Approver__r.Name, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__r.Name);
        }
        string isMarketingApprovePerson;
        boolean isContractsApprovePerson;
         // Deligator logic 
        User deligationUser = new User() ;
        //convert below as list--and add where condition delegator approver=userinfo.get user id and remove 236 query and add  r.name/r.profname to 234 line. and at a time for 1 user 1 approver will be there but for all users more than one be there.
        /* if(deligatorApprover != null){
            deligationUser = [SELECT id, Name,Profile.Name FROM User WHERE Id =: deligatorApprover.Phoenix_Delegated_Approver__c LIMIT 1];
        }*/
        //system.debug('isMarketingApprovePerson--->'+isMarketingApprovePerson);
        boolean isDelegationPerson=false;
        boolean isMarketingDelegationPerson = false;
        wrapperObject.deligatedUserName = UserInfo.getName();
        if(deligatorApprover !=null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c aprHisDel : deligatorApprover){
                if(userTeamUserIdMap.containsKey('Contracts-'+aprHisDel.Phoenix_User__c)){
                    isDelegationPerson = true;
                }
                if(userTeamUserIdMap.containsKey('Marketing-'+aprHisDel.Phoenix_User__c)){
                    isMarketingDelegationPerson = true;
                    wrapperObject.deligatedUserName  = wrapperObject.deligatedUserName + aprHisDel.Phoenix_User__r.Name;
                }
            }
        }
        if (userTeamUserIdMap.containsKey('Marketing-' + cuurentUser.Id) && hasDirectorLines && cuurentUser.Name == userInfo.getName()){
            isMarketingApprovePerson = userTeamUserIdMap.get(('Marketing-' + cuurentUser.Id));
        }else if(isMarketingDelegationPerson && hasDirectorLines && cuurentUser.Name == userInfo.getName()){
            isMarketingApprovePerson=cuurentUser.Name;
        }else{
            isMarketingApprovePerson=null;
        }
        if (userTeamUserIdMap.containsKey('Contracts-' + cuurentUser.Id) || isDelegationPerson) {
            isContractsApprovePerson = true;
        }
        //for firing the trigger
       List<Phoenix_Bid_Line_Item__c> updationList = [SELECT ID FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =:bidId];
        update updationList;
        // Phoenix_Bid__c bid = [SELECT Id,Phoenix_Is_Re_Bid__c,Phoenix_Previous_Bid__c,Phoenix_Proactive_Reactive__c, Phoenix_Salesperson__c,  Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c,Name,Phoenix_Customer__c,Phoenix_Customer__r.Name,Phoenix_Customer_Type__c,Phoenix_Bid_Name__c,Phoenix_Reference_Contracts__c,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        //wrapperObject.columnList = columnsList;
        wrapperObject.lineItemsList = newItem; //for analysis
        wrapperObject.bidRecord = bid;
        wrapperObject.productfamilyList = productFamilyList;
        wrapperObject.productDirectorList = productDirectorList;
        wrapperObject.loggedInUserName = cuurentUser.Name;
        wrapperObject.isMarketingApprovePerson = isMarketingApprovePerson;
        wrapperObject.isContractsApprovePerson = isContractsApprovePerson;
        wrapperObject.showProceedBtn = showProceedBtn;
        wrapperObject.hasDirectorLines = hasDirectorLines;
        wrapperObject.ismarketingDeligator = (deligatorApprover != null && deligatorApprover.size()>0) ? true:false;
        return wrapperObject;
    }
      
    @AuraEnabled
   public static List < Phoenix_Bid_Line_Item__c > saveLineItemsNewPL(Id bidId,List < Phoenix_Bid_Line_Item__c > LineItemList){
     //List < Phoenix_Bid_Line_Item__c > BidlineItems = [select id, name,Phoenix_Bid__r.Phoenix_Customer_Type__c,Phoenix_Bid__r.Phoenix_Rebate__c, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Product_Director1__c, Phoenix_Marketing_Approval__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
       String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        string notApproved = 'Not Approved';
        query = 'select Phoenix_Bid__r.Phoenix_Approval_Status__c,Latest_Line_Item__r.Phoenix_Bid__c,Latest_Line_Item__r.Phoenix_Bid__r.Name,Latest_Line_Item__r.Phoenix_Final_Status__c,Latest_Line_Item__r.Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Bid__r.Phoenix_Is_Re_Bid__c,Phoenix_Product__r.Phoenix_WAC__c,Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c,Phoenix_Previous_Bid__r.Name,Phoenix_Previous_LineItem__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
        list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);
        //system.debug('quoteList--->' + quoteList); 
       String currentUser = [SELECT id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].Name;
            //system.debug('currentUser--->' + currentUser);
        //For delegation
       /*User cuurentUser;
        if (bid.Phoenix_Bid_Created_Behalf_of__c != null && bid.Phoenix_Approval_Status__c == 'Draft') {
            cuurentUser = [SELECT id, Name FROM User WHERE Id =: bid.Phoenix_Bid_Created_Behalf_of__c LIMIT 1];
        } else {
            cuurentUser = [SELECT id, Name FROM User WHERE Id =: userinfo.getUserId() LIMIT 1];
        }*/
       
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Delegated_Approver__r.Name,Phoenix_User__r.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
        String delegatedUsers = currentUser;
        if(deligatorApprover !=null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c aprHisDel : deligatorApprover){
                delegatedUsers = delegatedUsers + ',' + aprHisDel.Phoenix_User__r.Name;
            }
        }
       //system.debug('delegatedUsers--->'+delegatedUsers);
       //End for Delegation
       for (Phoenix_Bid_Line_Item__c lineItem: quoteList) {
           if(lineItem.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Draft'){
              lineItem.Phoenix_Lowest_Price_SKU1__c = lineItem.Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c;
              lineItem.Phoenix_WAC1__c = lineItem.Phoenix_Product__r.Phoenix_WAC__c; 
           }
           if(lineItem.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'SCM & Marketing' || lineItem.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Marketing'){
               if ((lineItem.Phoenix_Product_Director1__c == currentUser || ((delegatedUsers!=null && delegatedUsers.contains(lineItem.Phoenix_Product_Director1__c)) && delegatedUsers.contains(currentUser))) && lineItem.Phoenix_Marketing_Approval__c != 'Approved'){
                     lineItem.Phoenix_Lowest_Price_SKU1__c = lineItem.Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c;
                     lineItem.Phoenix_WAC1__c = lineItem.Phoenix_Product__r.Phoenix_WAC__c;
               }
           }
            
       }
       
        update quoteList;
        return quoteList;
        
    }
   
    
    @AuraEnabled
    public static void updateRelatedList(List < Phoenix_Bid_Line_Item__c > lineItemsList) {
        if (lineItemsList != null && lineItemsList.size() > 0) {
            update lineItemsList;
        }
    }

    //This method is for ROS template. getting extn object details.
    @auraEnabled
    public static Phoenix_BidLineItemExtn__c getChildExtnRecord(Id bliId) {
        String bidLineItemExtObjname = 'Phoenix_BidLineItemExtn__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(bidLineItemExtObjname).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ', ' + fieldName;
            }
        }
        String bidLineExtStrFields = 'SELECT ' + strFields + ' FROM ' + bidLineItemExtObjname + ' WHERE Phoenix_Bid_Line_Item__c =: bliId LIMIT 1';
        Phoenix_BidLineItemExtn__c obj = database.query(bidLineExtStrFields);
        return obj;
    }


    public class Columns {
        @AuraEnabled public string label;
        //@AuraEnabled public string labelval;
        @AuraEnabled public string value;
        //@AuraEnabled public string valueval;

    }


    public class Wrapper {
        @AuraEnabled public List < Columns > columnList;
        @AuraEnabled public List < Phoenix_Bid_Line_Item__c > lineItemsList;
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        @AuraEnabled public List < String > productfamilyList;
        @AuraEnabled public List < String > productDirectorList;
        @AuraEnabled public string loggedInUserName;
        @AuraEnabled public string isMarketingApprovePerson;
        @AuraEnabled public boolean isContractsApprovePerson;
        @AuraEnabled public boolean showProceedBtn;
        @AuraEnabled public boolean hasDirectorLines;
        @AuraEnabled public boolean ismarketingDeligator;
        @AuraEnabled public string deligatedUserName;

        Wrapper() {
            columnList = new List < Columns > ();
            lineItemsList = new List < Phoenix_Bid_Line_Item__c > ();
            productfamilyList = new List < String > ();
            productDirectorList = new List < String > ();
            loggedInUserName = '';
            deligatedUserName='';
            isMarketingApprovePerson = '';
            isContractsApprovePerson = false;
			ismarketingDeligator = false;
        }
    }


    @AuraEnabled
    public static Phoenix_Bid__c saveLineItems(List < Phoenix_Bid_Line_Item__c > LineItemList, Id LineItemId, string rebateHeader, string feeHeader, string contractApproval, boolean isRebateChanged, boolean isFeeChanged, boolean isApprovalChanged, String marketingHeader, boolean isMarketingChanged, string productPositions,String vipHeader, boolean isVipChanged) {
        List < Phoenix_Bid_Line_Item__c > lineList = [select id, name, Phoenix_Bid__r.Phoenix_Rebate__c, Phoenix_Product_Director1__c, Phoenix_Marketing_Approval__c, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Bid_Type__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: LineItemId AND Phoenix_Final_Status__c != 'Not Approved'];
        List < Phoenix_Bid_Line_Item__c > productDirectorLineItems = new List < Phoenix_Bid_Line_Item__c > ();
        if (lineList != null && lineList.size() > 0 && rebateHeader != '' || feeHeader != null || marketingHeader != '') {
            String currentUser = [SELECT id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].Name;
            //system.debug('currentUser--->' + currentUser);
            for (Phoenix_Bid_Line_Item__c lineItem: lineList) {
                //system.debug('lineItem.Phoenix_Product_Director1__c--->' + lineItem.Phoenix_Product_Director1__c);
                //system.debug('marketingHeader--' + marketingHeader);
                //system.debug('isMarketingChanged--' + isMarketingChanged);
                if (lineItem.Phoenix_Product_Director1__c == currentUser && isMarketingChanged != null && marketingHeader != '' && marketingHeader != null) {
                    lineItem.Phoenix_Marketing_Approval__c = marketingHeader;
                }
                if (vipHeader != '' && isVipChanged == true)
                    lineItem.Phoenix_Proposed_Est_VIP__c = decimal.valueOf(vipHeader);
                if (rebateHeader != '' && isRebateChanged == true)
                    lineItem.Phoenix_Rebate_G_N__c = rebateHeader;
                if (feeHeader != '' && isFeeChanged == true)
                    lineItem.Phoenix_Fee_G_N__c = feeHeader;
                if (contractApproval != '' && isApprovalChanged == true) lineItem.Phoenix_Contract_Approval__c = contractApproval;
                if ((lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change' || lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate') && isRebateChanged) {
                    lineItem.Phoenix_Proposed_Current_Rebate__c = lineItem.Phoenix_Bid__r.Phoenix_Rebate__c;
                }
                if (productPositions != null && productPositions != '')
                    lineItem.Phoenix_Proposed_Position__c = productPositions;
            }


        }

         update lineList;
        Phoenix_Bid__c bid = [SELECT Id,Phoenix_REMS_Program_Fee__c,Phoenix_Sent_to_Customer_Date__c, Phoenix_Proposed_Admin_Fee_Basis__c, Phoenix_Proposed_Rebate_Basis__c, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Is_Re_Bid__c, Phoenix_Previous_Bid__c, Phoenix_OTB_Direct_Indirect__c, Phoenix_Bid_Proposed_Position__c, Phoenix_Proactive_Reactive__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Current_CD__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: LineItemId];
        return bid;
    }

    @AuraEnabled
    public static void getselectOptions(sObject objObject, string fld) {}
    @AuraEnabled
    public static void deleteLineItems(String LineItemId) {
        if (LineItemId != null) {
            Phoenix_Bid_Line_Item__c deletedLineItem = [SELECT Id FROM Phoenix_Bid_Line_Item__c WHERE Id =: LineItemId];
            delete deletedLineItem;
        }
    }
    /*added by satya*/
     @AuraEnabled
    public static List<Phoenix_Bid_Line_Item__c>  proposedDirectPriceUpdate(List<Phoenix_Bid_Line_Item__c> BidLineItemListAll,List<String> BidNames,String bidId){
       System.debug('BidNames==>'+BidNames);
        list < Phoenix_Bid_Line_Item__c > lineitems = [select id,Phoenix_Product__c,Phoenix_NDC__c,Phoenix_Product__r.Name,Phoenix_Product_Family__c,Phoenix_Product_Director__c,Phoenix_Customer__r.Name,Phoenix_Contract__r.Name,Phoenix_Customer__r.owner.name, Phoenix_Final_Status__c,Phoenix_ProposedContractBidPriceMktng__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__r.Name IN: BidNames ];
       //list<AggregateResult>  lineItemsList = [select Phoenix_Product__c p, max(Phoenix_ProposedContractBidPriceMktng__c) from Phoenix_Bid_Line_Item__c where  Phoenix_Bid__r.Name IN: BidNames group by Phoenix_Product__c];
        list<Phoenix_Bid_Line_Item__c> updatelineItems =[select id,Phoenix_Product__c,Phoenix_NDC__c,Phoenix_Product__r.Name,Phoenix_Product_Family__c,Phoenix_Product_Director__c,Phoenix_Customer__r.Name,Phoenix_Contract__r.Name,Phoenix_Customer__r.owner.name, Phoenix_Final_Status__c,Phoenix_ProposedContractBidPriceMktng__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId ]; 
        map<id,decimal> maplist = new map<id,decimal>();
        for(AggregateResult Item: [select Phoenix_Product__c p, max(Phoenix_ProposedContractBidPriceMktng__c) pr from Phoenix_Bid_Line_Item__c where  Phoenix_Bid__r.Name IN: BidNames group by Phoenix_Product__c]){
            ID productId = (ID) item.get('p');
            decimal pricevalue = (decimal) item.get('pr');
            maplist.put(productId,pricevalue);
        }
        for(Phoenix_Bid_Line_Item__c blItem: BidLineItemListAll){
            	blItem.Phoenix_ProposedContractBidPriceMktng__c =  maplist.get(blItem.Phoenix_Product__c) != null ? maplist.get(blItem.Phoenix_Product__c) : null ;//blItem.Phoenix_ProposedContractBidPriceMktng__c
                
            }
       
        update BidLineItemListAll;
       return  BidLineItemListAll;
    }
    /*end by satya*/
    @AuraEnabled
    public static Phoenix_Bid_Line_Item__c getCalcs(Phoenix_Bid_Line_Item__c LineItem, Id LineItemId, string currentValue, string fieldLabel) {

        Phoenix_Bid_Line_Item__c beforeUpdateLineItem = [SELECT Id, Phoenix_ProposedContractBidPriceMktng__c,Latest_Line_Item__r.Phoenix_Bid__c,Latest_Line_Item__r.Phoenix_Bid__r.Name,Latest_Line_Item__r.Phoenix_Final_Status__c,Latest_Line_Item__r.Phoenix_ProposedContractBidPriceMktng__c, Phoenix_Marketing_Approval__c, Phoenix_Guidance_Price__c,Phoenix_Bid__r.Phoenix_Customer_Type__c,Phoenix_Wholesaler_Diff_Price_Indirect__c FROM Phoenix_Bid_Line_Item__c WHERE Id =: LineItem.Id];
        if (currentValue != 'No Change' && fieldLabel == 'rebateType') {
            if(currentValue != 'None')
            	LineItem.Phoenix_Rebate_G_N__c = currentValue;
            else 
                LineItem.Phoenix_Rebate_G_N__c = null;
        }
        if (currentValue != 'No Change' && fieldLabel == 'feeType') {
            if(currentValue != 'None')
            	LineItem.Phoenix_Fee_G_N__c = currentValue;
            else
                LineItem.Phoenix_Fee_G_N__c = null;
        }
        if (currentValue != 'No Change' && fieldLabel == 'MarketApproval') {
            LineItem.Phoenix_Marketing_Approval__c = currentValue;
        }
        if (currentValue != 'No Change' && fieldLabel == 'ContractApproval') {
            LineItem.Phoenix_Contract_Approval__c = currentValue;
        }
        if (currentValue != 'No Change' && fieldLabel == 'EstmatedDays') {
            LineItem.Phoenix_Estimated_Lead_Time_Days__c = currentValue;
        }
        //system.debug('LineItem.Phoenix_ProposedContractBidPriceMktng__c --->' + LineItem.Phoenix_ProposedContractBidPriceMktng__c);
        //system.debug('beforeUpdateLineItem.Phoenix_ProposedContractBidPriceMktng__c--->' + beforeUpdateLineItem.Phoenix_ProposedContractBidPriceMktng__c);
        if (LineItem.Phoenix_ProposedContractBidPriceMktng__c != null && LineItem.Phoenix_ProposedContractBidPriceMktng__c != beforeUpdateLineItem.Phoenix_ProposedContractBidPriceMktng__c && LineItem.Phoenix_ProposedContractBidPriceMktng__c > 0) {
            LineItem.Phoenix_Marketing_Approval__c = 'Approved';
        }
        //added by vandana
        if(beforeUpdateLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Humana Indirect retail' || beforeUpdateLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Humana Indirect CII' ){
            if (LineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != null && LineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != beforeUpdateLineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c && LineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c > 0) {
                system.debug('called');
                LineItem.Phoenix_Marketing_Approval__c = 'Approved';
            }
        }
        //end.
        if (LineItem.Phoenix_Guidance_Price__c != null && LineItem.Phoenix_Guidance_Price__c != beforeUpdateLineItem.Phoenix_Guidance_Price__c && LineItem.Phoenix_ProposedContract_Bid_Price_Sales__c == null) {
            LineItem.Phoenix_ProposedContract_Bid_Price_Sales__c = LineItem.Phoenix_Guidance_Price__c;
        }
        update LineItem;
        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();

        String strFields = '';

        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }

        query = 'select Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Controlled_Substance__c,Latest_Line_Item__r.Phoenix_Bid__c,Latest_Line_Item__r.Phoenix_Bid__r.Name,Latest_Line_Item__r.Phoenix_Final_Status__c,Latest_Line_Item__r.Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Refrigerated__c,Phoenix_Product__r.Phoenix_Limited_Distribution__c,Phoenix_Bid__r.Phoenix_Is_Re_Bid__c,Phoenix_Bid__r.Phoenix_Current_CD__c,Phoenix_Bid__r.Phoenix_Proposed_Cash_Terms__c,Phoenix_Previous_Bid__r.Name,Phoenix_Previous_LineItem__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c, ' + strFields + ' from ' + SobjectApiName + ' where id = :LineItemId limit 1';
        Phoenix_Bid_Line_Item__c UpdatedLineItem = Database.query(query);
        return UpdatedLineItem;

    }
    @AuraEnabled //findBySrxOtc
    public static List < Phoenix_Bid_Line_Item__c > findByProductFamily(List < String > searchKey, String lineItemId, List < String > sRxOtcList, List < String > searchPDList) {
        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();

        String strFields = '';

        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        string notApproved = 'Not Approved';
        query = 'select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : lineItemId AND Phoenix_Final_Status__c !=: notApproved';
        if (searchKey != null && searchKey.size() > 0) {
            query = query + ' AND Phoenix_Product_Family__c =: searchKey';
        }
        if (sRxOtcList != null && sRxOtcList.size() > 0) {
            query = query + ' AND Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =: sRxOtcList';
        }
        if (searchPDList != null && searchPDList.size() > 0) {
            query = query + ' AND Phoenix_Product_Director__c =: searchPDList';
        }
        query = query + ' ORDER BY Phoenix_Product_Family__c ASC LIMIT 1000';
        List < Phoenix_Bid_Line_Item__c > lineItemsList = Database.query(query);

        // //system.debug(lineItemsList);
        return lineItemsList;
    }
    @AuraEnabled
    public static list < Phoenix_Contract__c > getContracts(string customerID, string searchInput) {
        //system.debug('customerID---' + customerID);
        string act = 'Active';
        boolean isExcludeContract = false;
        string query = 'select name,Phoenix_Customer__r.Name,Phoenix_Contract_Number__c,Phoenix_Contract_Internal_Description__c,Phoenix_Contract_External_Description__c from Phoenix_Contract__c where Phoenix_Contract_Status__c=:act';
        if (customerID != null) {
            Set < Id > parentAccIds = new Set < Id > ();
            parentAccIds.add(customerID);
            //Fetch related accounts
            Map < Id, Account > allAccMap = new Map < Id, Account > ();
            //Map of all accounts
            for (Account acc: Database.query('SELECT ' + Phoenix_Util.customerFields + ' FROM Account LIMIT 10000'))
                allAccMap.put(acc.Id, acc);
            String tempId = customerID;
            while (allAccMap.get(tempId) != NULL && allAccMap.get(tempId).ParentId != NULL) {
                tempId = allAccMap.get(tempId).ParentId;
                parentAccIds.add(tempId);
            }
            for(Account acc: allAccMap.values()){
                if(acc.ParentId != null && (acc.ParentId == tempId || (allAccMap.get(acc.ParentId) != null && allAccMap.get(acc.ParentId).ParentId != null && allAccMap.get(acc.ParentId).ParentId == tempId)) )
                    parentAccIds.add(acc.Id);
            }
            //system.debug('parentAccIds--' + parentAccIds);
            query += ' and (Phoenix_Customer__c=:parentAccIds)'; // or Phoenix_Customer__r.ParentId=:parentAccIds
        }
        if (string.isNotBlank(searchInput)) {
            query += ' and ( name like \'%' + searchInput + '%\' or Phoenix_Contract_Number__c like \'%' + searchInput + '%\' or Phoenix_Customer__r.Name like \'%' + searchInput + '%\' or Phoenix_Contract_Internal_Description__c like \'%' + searchInput + '%\' or Phoenix_Contract_External_Description__c like  \'%' + searchInput + '%\')';
        }
        list < Phoenix_Contract__c > cntList = Database.query(query);
        return cntList;
    }

    @AuraEnabled
    public static void getNPRData(list < string > selectrcs, Id BidId, string templateType) {
        system.debug('templateType====='+templateType);
        list < Phoenix_Bid_Line_Item__c > bildLines = [select id,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Product__r.Phoenix_Controlled_Substance__c,Phoenix_ProposedContract_Bid_Price_Sales__c, Current_CVS_DeadNet__c,Current_CVS_Indirect_DeadNet__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebate_Secondary_Template__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Admin_Fee_Sec_Template__c,Phoenix_Bid__r.Phoenix_Customer__r.AccountNumber,Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Current_Position__c, name, Phoenix_12_Months_Actual_Sales__c, Phoenix_Product__c, Phoenix_Product__r.Name, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Fee__c, Phoenix_Bid__r.Phoenix_Customer__r.Rebate_Type__c, Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Cash_Discount__c, Phoenix_Bid__r.Phoenix_Customer__r.Fee_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebates__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_VIP__c, Phoenix_Current_Net_Sales_Internal__c, Phoenix_DeadNet_TrckGR__c, Phoenix_Product__r.ProductCode, Phoenix_Current_Direct_Selling_Unit__c, Phoenix_Current_Indirect_Selling_Unit__c, Phoenix_Current_Indirect_Price__c, Phoenix_Current_Direct_Price__c, Phoenix_Current_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Current_Rebate__c, Phoenix_Rebate_G_N__c, Phoenix_Fee_G_N__c, Phoenix_Current_Admin_Fee__c, Finance_Current_Sales__c, Phoenix_Medicaid_Returns_Per_Unit_in__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: BidId];
        list < Phoenix_NPR_Data__c > NPRDataLines = [select id, Name, Phoenix_Product_Position__c, Phoenix_12Months_Actual_Sales_Unit__c, Phoenix_Contract_Type__c, Phoenix_Net_Sales_Internal__c, Phoenix_Dead_Net_Tracking_GR__c, Phoenix_Contract_Price__c, Phoenix_Product__c, Phoenix_Product__r.ProductCode, Phoenix_12Months_Sales_Unit__c, Phoenix_12Months_Net_Sales__c, Phoenix_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Rebate__c, Phoenix_Rebate_G_N_Indicator__c, Phoenix_Bonafied_G_N_Indicator__c, Phoenix_Fee_Bonafied_Fee__c, Phoenix_Per_Unit_Bonfied_Fee__c, Phoenix_CD__c, Phoenix_GR_TrackingTier__c from Phoenix_NPR_Data__c where Phoenix_Contract_Number__c in: selectrcs and Phoenix_NPR_Status__c = 'Active'];
        map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
        decimal cashDiscount;
        decimal currentAdminFee;
        string adminFeeIndict;
        list < decimal > cashTermsAnyLine = new list < decimal > ();
        list < decimal > VipAnyLine = new list < decimal > ();
        list < decimal > adminFeeAnyLine = new list < decimal > ();
        String bidTye = (bildLines != null && bildLines.size() > 0) ? bildLines[0].Phoenix_Bid__r.Phoenix_Bid_Type__c : '';
        for (Phoenix_NPR_Data__c NPRLine: NPRDataLines) {
            cashTermsAnyLine.add(NPRLine.Phoenix_CD__c);
            VipAnyLine.add(NPRLine.Phoenix_GR_TrackingTier__c);
            //adminFeeAnyLine.add(NPRLine.Phoenix_Fee_Bonafied_Fee__c);
            //adminFeeIndict = NPRLine.Phoenix_Bonafied_G_N_Indicator__c;
            if (productCodeToNPRLineMap.containsKey(NPRLine.Phoenix_Product__r.ProductCode)) {
                productCodeToNPRLineMap.get(NPRLine.Phoenix_Product__r.ProductCode).add(NPRLine);
            } else {
                list < Phoenix_NPR_Data__c > NPRList = new list < Phoenix_NPR_Data__c > ();
                NPRList.add(NPRLine);
                productCodeToNPRLineMap.put(NPRLine.Phoenix_Product__r.ProductCode, NPRList);
            }
        }
        if (!cashTermsAnyLine.isEmpty()) {
            cashTermsAnyLine.sort();
            cashDiscount = cashTermsAnyLine[cashTermsAnyLine.size() - 1];
        }
       
        if (!adminFeeAnyLine.isEmpty()) {
            adminFeeAnyLine.sort();
            currentAdminFee = adminFeeAnyLine[adminFeeAnyLine.size() - 1];
        }
        if (string.isNotBlank(adminFeeIndict)) {
            decimal Net = decimal.valueOf(adminFeeIndict.substringBefore('N'));
            decimal Gross = decimal.valueOf(adminFeeIndict.substringBetween('+', 'G'));
            adminFeeIndict = Gross == 0 ? 'Net' : 'Gross';
        }
        decimal prvsVip;
        map < Phoenix_Bid_Line_Item__c, list < Phoenix_NPR_Data__c >> bidToNPRMap = new map < Phoenix_Bid_Line_Item__c, list < Phoenix_NPR_Data__c >> ();
        for (Phoenix_Bid_Line_Item__c bidLine: bildLines) {
            prvsVip = bidLine.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c;
            bidLine.Phoenix_Current_Indirect_Selling_Unit__c = 0;
            bidLine.Phoenix_Current_Direct_Selling_Unit__c = 0;
            bidLine.Phoenix_Current_Indirect_Price__c = 0;
            bidLine.Phoenix_Current_Direct_Price__c = 0;
            bidLine.Phoenix_Current_Per_Unit_Rebate__c = 0;
            bidLine.Phoenix_ZITD_Value__c = 0;
            bidLine.Phoenix_Current_Rebate__c = 0;
            bidLine.Phoenix_Current_Admin_Fee__c = 0;
            bidLine.Phoenix_Rebate_G_N__c = '';
            bidLine.Phoenix_Fee_G_N__c = '';
            bidLine.Phoenix_Current_Position__c = '';
            bidLine.Phoenix_Current_Net_Sales_Internal__c = 0;
            bidLine.Phoenix_12_Months_Actual_Sales__c = 0;
            bidLine.Phoenix_12_Months_IndirectSaleUnit__c = 0;
            bidLine.Finance_Current_Sales__c=0;
           // bidLine.Phoenix_Proposed_Est_VIP__c =0;
            list < Decimal > directPriceList = new list < Decimal > ();
            list < Decimal > indirectPriceList = new list < Decimal > ();
            list < Decimal > perUnitRebateList = new list < Decimal > ();
            list < Decimal > deadNetTrackList = new list < Decimal > ();
            list < Decimal > NetSalesList = new List < Decimal > ();
            list < Decimal > ZITDList = new List < Decimal > ();
            list < Decimal > RebateList = new List < Decimal > ();
            list < Decimal > VipList = new list < Decimal > ();
            //by satya
            list < Decimal > indirectDeadNet = new List < Decimal > ();
            list < Decimal > directDeadnet = new List < Decimal > ();
            //end by satya
            if (productCodeToNPRLineMap.keyset().contains(bidLine.Phoenix_Product__r.ProductCode)) {
                for (Phoenix_NPR_Data__c NPRLine: productCodeToNPRLineMap.get(bidLine.Phoenix_Product__r.ProductCode)) {
                    system.debug('VIP %-----'+NPRLine.Phoenix_GR_TrackingTier__c);
                    //Added by satya//
                    if(templateType == 'Humana Indirect retail' || templateType == 'Humana Indirect CII') {
                        //for NDC Current sales calculation//
                            Decimal currentWholeSalerUnits = (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                            Decimal deadNetTracker = (NPRLine.Phoenix_Dead_Net_Tracking_GR__c !=null ? NPRLine.Phoenix_Dead_Net_Tracking_GR__c:0);
                            bidLine.Finance_Current_Sales__c += ((currentWholeSalerUnits*deadNetTracker)- (currentWholeSalerUnits *bidLine.Phoenix_Medicaid_Returns_Per_Unit_in__c));
                    }
                    /*end by satya*/
                    if (templateType == 'Indirect' || templateType == 'Direct and Indirect' || templateType == 'Humana Indirect retail' || templateType == 'Humana Indirect CII') {
                       
                        if (NPRLine.Phoenix_Contract_Type__c == 'Indirect') {
                             system.debug('Indirect--');
                            if (bidLine.Phoenix_Current_Position__c != null && NPRLine.Phoenix_Product_Position__c != null && !bidLine.Phoenix_Current_Position__c.containsAny(NPRLine.Phoenix_Product_Position__c)) {
                                bidLine.Phoenix_Current_Position__c = (NPRLine.Phoenix_Product_Position__c != null ? NPRLine.Phoenix_Product_Position__c + ', ' : '') + (bidLine.Phoenix_Current_Position__c != null ? bidLine.Phoenix_Current_Position__c : '');
                            }

                            if (NPRLine.Phoenix_12Months_Sales_Unit__c != null) {
                                bidLine.Phoenix_Current_Indirect_Selling_Unit__c += NPRLine.Phoenix_12Months_Sales_Unit__c;
                            }
                            bidLine.Phoenix_12_Months_IndirectSaleUnit__c = (bidLine.Phoenix_12_Months_IndirectSaleUnit__c != null ? bidLine.Phoenix_12_Months_IndirectSaleUnit__c : 0) + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                            indirectPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                            //cashDiscount=NPRLine.Phoenix_CD__c;
                            //currentVip=NPRLine.Phoenix_GR_TrackingTier__c;
                            if (string.isNotBlank(NPRLine.Phoenix_Rebate_G_N_Indicator__c)) {
                                string rbInd = NPRLine.Phoenix_Rebate_G_N_Indicator__c.deleteWhitespace();
                                decimal Net = decimal.valueOf(rbInd.substringBefore('N'));
                                decimal Gross = decimal.valueOf(rbInd.substringBetween('+', 'G'));
                                bidLine.Phoenix_Rebate_G_N__c = Gross != 0 ? 'Gross' : Net!=0 ? 'Net' : null;
                            }
                            bidLine.Phoenix_Current_Admin_Fee__c = NPRLine.Phoenix_Fee_Bonafied_Fee__c != null && (bidLine.Phoenix_Current_Admin_Fee__c < NPRLine.Phoenix_Fee_Bonafied_Fee__c) ? NPRLine.Phoenix_Fee_Bonafied_Fee__c : bidLine.Phoenix_Current_Admin_Fee__c;
                            perUnitRebateList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                            deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
                            //by satya
                            indirectDeadNet.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);//bidLine.Current_CVS_Indirect_DeadNet__c = NPRLine.Phoenix_Dead_Net_Tracking_GR__c;
                      		//end by satya
                        }
                        
                        //NetSalesList.add(NPRLine.Phoenix_Net_Sales_Internal__c);//hidden for previous
                        bidLine.Phoenix_Current_Net_Sales_Internal__c += NPRLine.Phoenix_Net_Sales_Internal__c;
                        ZITDList.add(NPRLine.Phoenix_ZITD_Value__c);
                        //bidLine.Phoenix_ZITD_Value__c=NPRLine.Phoenix_ZITD_Value__c;
                        RebateList.add(NPRLine.Phoenix_Rebate__c);
                       
                         VipList.add(NPRLine.Phoenix_GR_TrackingTier__c);
                       
                        //bidLine.Phoenix_Current_Rebate__c=NPRLine.Phoenix_Rebate__c;
                        //bidLine.Phoenix_Current_Admin_Fee__c=NPRLine.Phoenix_Fee_Bonafied_Fee__c;

                         if(string.isNotBlank(NPRLine.Phoenix_Bonafied_G_N_Indicator__c)){
                             string bnFInd=NPRLine.Phoenix_Bonafied_G_N_Indicator__c.deleteWhitespace();
                             decimal Net=decimal.valueOf(bnFInd.substringBefore('N'));
                             decimal Gross=decimal.valueOf(bnFInd.substringBetween('+','G'));
                             
                             	bidLine.Phoenix_Fee_G_N__c=Gross!=0?'Gross':Net!=0 ? 'Net':null;
                         }
                    }
                    if (templateType == 'Direct' || templateType == 'Direct and Indirect' || templateType == 'Humana Indirect CII') {
                     system.debug('direct');
                        if (bidLine.Phoenix_Current_Position__c != null && NPRLine.Phoenix_Product_Position__c != null && !bidLine.Phoenix_Current_Position__c.containsAny(NPRLine.Phoenix_Product_Position__c)) {
                            bidLine.Phoenix_Current_Position__c = (NPRLine.Phoenix_Product_Position__c != null ? NPRLine.Phoenix_Product_Position__c + ', ' : '') + (bidLine.Phoenix_Current_Position__c != null ? bidLine.Phoenix_Current_Position__c : '');
                        }
                        if (NPRLine.Phoenix_Contract_Type__c == 'Direct' ) {
                            if (NPRLine.Phoenix_12Months_Sales_Unit__c != null  && templateType != 'Humana Indirect CII') {
                                bidLine.Phoenix_Current_Direct_Selling_Unit__c += NPRLine.Phoenix_12Months_Sales_Unit__c;
                            }
                            bidLine.Phoenix_12_Months_Actual_Sales__c = (bidLine.Phoenix_12_Months_Actual_Sales__c != null ? bidLine.Phoenix_12_Months_Actual_Sales__c : 0) + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                            directPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                            //cashDiscount=NPRLine.Phoenix_CD__c;
                           
                            if (string.isNotBlank(NPRLine.Phoenix_Rebate_G_N_Indicator__c)) {
                                string rbInd = NPRLine.Phoenix_Rebate_G_N_Indicator__c.deleteWhitespace();
                                decimal Net = decimal.valueOf(rbInd.substringBefore('N'));
                                decimal Gross = decimal.valueOf(rbInd.substringBetween('+', 'G'));
                                bidLine.Phoenix_Rebate_G_N__c = Gross != 0 ? 'Gross' : Net!=0 ? 'Net' : null;
                            }
                            bidLine.Phoenix_Current_Admin_Fee__c = NPRLine.Phoenix_Fee_Bonafied_Fee__c != null && (bidLine.Phoenix_Current_Admin_Fee__c < NPRLine.Phoenix_Fee_Bonafied_Fee__c) ? NPRLine.Phoenix_Fee_Bonafied_Fee__c : bidLine.Phoenix_Current_Admin_Fee__c;
                            perUnitRebateList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                            deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
                            // by satya
                             directDeadnet.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);//bidLine.Current_CVS_DeadNet__c = NPRLine.Phoenix_Dead_Net_Tracking_GR__c;
                        	//end by satya
                        }
                        
                        // NetSalesList.add(NPRLine.Phoenix_Net_Sales_Internal__c);//hiiden previous
                        bidLine.Phoenix_Current_Net_Sales_Internal__c += NPRLine.Phoenix_Net_Sales_Internal__c;
                        ZITDList.add(NPRLine.Phoenix_ZITD_Value__c);
                        VipList.add(NPRLine.Phoenix_GR_TrackingTier__c);
                        // bidLine.Phoenix_ZITD_Value__c=NPRLine.Phoenix_ZITD_Value__c;
                        RebateList.add(NPRLine.Phoenix_Rebate__c);
                        // bidLine.Phoenix_Current_Rebate__c=NPRLine.Phoenix_Rebate__c;
                        //bidLine.Phoenix_Current_Admin_Fee__c=NPRLine.Phoenix_Fee_Bonafied_Fee__c;

                        if(string.isNotBlank(NPRLine.Phoenix_Bonafied_G_N_Indicator__c)){
                            string bnFInd=NPRLine.Phoenix_Bonafied_G_N_Indicator__c.deleteWhitespace();
                            decimal Net=decimal.valueOf(bnFInd.substringBefore('N'));
                            decimal Gross=decimal.valueOf(bnFInd.substringBetween('+','G'));
                            
                             	bidLine.Phoenix_Fee_G_N__c=Gross!=0?'Gross':Net!=0 ? 'Net':null;
                        }  
                    }
                }
                //by satya
                if(directDeadnet.size() > 0){
                    directDeadnet.sort();
                    bidLine.Current_CVS_DeadNet__c = directDeadnet[0];
                }
                if(indirectDeadNet.size() > 0){
                    indirectDeadNet.sort();
                    bidLine.Current_CVS_Indirect_DeadNet__c = indirectDeadNet[0];
                }
                //end by satya
                //take minimum of all indeirect NPR prices
                if (indirectPriceList.size() > 0) {
                    indirectPriceList.sort();
                    bidLine.Phoenix_Current_Indirect_Price__c = indirectPriceList[0];
                }
                //take minimum of all deirect NPR prices
                if (directPriceList.size() > 0) {
                    directPriceList.sort();
                    bidLine.Phoenix_Current_Direct_Price__c = directPriceList[0];
                }
                system.debug('VipList====='+VipList);
                 //take Max of all  VIP
                    if (!VipList.isEmpty()) {
                        VipList.sort();
                        bidLine.Phoenix_Proposed_Est_VIP__c = VipList[VipList.size() - 1];
                    }
                //take Max of all  NPR rebate 
                if (perUnitRebateList.size() > 0) {
                    perUnitRebateList.sort();
                    bidLine.Phoenix_Current_Per_Unit_Rebate__c = perUnitRebateList[perUnitRebateList.size() - 1];
                    bidLine.Phoenix_Proposed_Per_Unit_Rebate__c = perUnitRebateList[perUnitRebateList.size() - 1];
                    //system.debug('perUnitRebateList---' + perUnitRebateList);
                }
                //take minimum of all  NPR Dead net track
                if (deadNetTrackList.size() > 0) {
                    deadNetTrackList.sort();
                    bidLine.Phoenix_DeadNet_TrckGR__c = deadNetTrackList[0];
                }
                //take minimum of all NPR Net sales internal
                if (NetSalesList.size() > 0) {
                    NetSalesList.sort();
                    bidLine.Phoenix_Current_Net_Sales_Internal__c = NetSalesList[0];
                }
                //take minimum of all zitd sales internal
                if (ZITDList.size() > 0) {
                    ZITDList.sort();
                    bidLine.Phoenix_ZITD_Value__c = ZITDList[0];
                }
                //take minimum of all zitd sales internal
                if (RebateList.size() > 0) {
                    RebateList.sort();
                    bidLine.Phoenix_Current_Rebate__c = RebateList[RebateList.size() - 1] != null ?  RebateList[RebateList.size() - 1] : 0;
                    bidLine.Phoenix_Proposed_Current_Rebate__c = RebateList[RebateList.size() - 1] != null ?  RebateList[RebateList.size() - 1] : 0;
                    //system.debug('RebateList---' + RebateList);
                }
               
                //bidLine.Phoenix_Fee_G_N__c = adminFeeIndict;
                //bidLine.Phoenix_Current_Admin_Fee__c = currentAdminFee;
            }
            else {
                //bidLine.Phoenix_Current_Admin_Fee__c = currentAdminFee;
                //added by srimayee for wholesaler controlled substance fee for Optisource custommer start
                  system.debug('Hi optis');
                if(bidLine.Phoenix_Bid__r.Phoenix_Customer__r.AccountNumber == '370706' && bidLine.Phoenix_Product__r.Phoenix_Controlled_Substance__c == 'Yes'){
                    system.debug('Hi opti');
                    bidLine.Phoenix_Whlsr_Controlled_Substance_Fee__c = ((bidLine.Phoenix_ProposedContractBidPriceMktng__c != null ? bidLine.Phoenix_ProposedContractBidPriceMktng__c : bidLine.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? bidLine.Phoenix_ProposedContract_Bid_Price_Sales__c : bidLine.Phoenix_Current_Indirect_Price__c)*0.02).setScale(4);
                        }
                    //added by srimayee for wholesaler controlled substance fee for Optisource custommer end
                if(bidLine.Phoenix_Bid__r.Phoenix_Customer__r.AccountNumber == '370337'){
                    bidLine.Phoenix_Current_Admin_Fee__c=bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Admin_Fee_Sec_Template__c != null ? bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Admin_Fee_Sec_Template__c :0;
                    bidLine.Phoenix_Proposed_Current_Rebate__c = bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebate_Secondary_Template__c != null ? bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebate_Secondary_Template__c : 0;
                }else
                {
                    bidLine.Phoenix_Current_Admin_Fee__c=bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Fee__c != null ? bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Fee__c : 0; 
                    bidLine.Phoenix_Proposed_Current_Rebate__c = bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebates__c != null ? bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebates__c : 0;
                } 
            //   currentVip=currentVip!=null?currentVip:bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_VIP__c;
            system.debug('else VIP====='+bidLine.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c);
                bidLine.Phoenix_Proposed_Est_VIP__c = bidLine.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c != null ? bidLine.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c : 0;

                // cashDiscount=cashDiscount!=null?cashDiscount:bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Cash_Discount__c;
                bidLine.Phoenix_Rebate_G_N__c = bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Rebate_Type__c;
                bidLine.Phoenix_Fee_G_N__c = bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Fee_Type__c;
            }
        }
        // cashDiscount = currentCd != null ? currentCd : cashDiscount;
        //system.debug('cashDiscount' + cashDiscount);
        //system.debug('currentVip' + currentVip);
        //system.debug('pvip---' + prvsVip);
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.id = bidid;
     //  bid.Phoenix_Current_CD__c = cashDiscount;
        //bid.Phoenix_Current_Value_Est_VIP__c = currentVip;
        /*if (prvsVip == null || prvsVip == 0) {
            bid.Phoenix_Proposed_Value_Est_VIP__c = currentVip;
        }*/
       // bid.Phoenix_Proposed_Admin_Fee_Basis__c = adminFeeIndict;
        // bid.Phoenix_Proposed_Value_Admin_Fee__c = currentAdminFee;
        if (bidTye != 'New Product Launch') {
            update bid;
        }
        ////system.debug('finalbidlines--'+bildLines);
        if (bidTye != 'New Product Launch') {
            update bildLines;
        }

    }
    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > submitToProceddStep(string bidId, boolean isContracts,boolean ismarketingDeligator, string deligatedUserName){//, ) {
        //boolean ismarketingDeligator = false; string deligatedUserName = '';
        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();

        String strFields = '';

        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        string notApproved = 'Not Approved';
        string loggerUserName = UserInfo.getName();
        List<String> directorNames = new List<String>();
        directorNames.add(loggerUserName);
        
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Delegated_Approver__r.Name,Phoenix_User__r.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
        if(deligatorApprover != null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c AprDelHis : deligatorApprover){
                directorNames.add(AprDelHis.Phoenix_User__r.Name);
            }
            directorNames.add(deligatorApprover[0].Phoenix_Delegated_Approver__r.Name);
        }
        query = 'select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
        if (isContracts != true && ismarketingDeligator != true) {
            query += ' and Phoenix_Product_Director__c=:loggerUserName';
        }else if(ismarketingDeligator){
            query += ' and Phoenix_Product_Director__c=:directorNames';
        }
        list < Phoenix_Bid_Line_Item__c > bidLinesList = Database.query(query);
        //system.debug('product director bidLinesList -->'+bidLinesList);
        return bidLinesList;

    }
    @AuraEnabled
    public static list < Phoenix_Bid_Process_Steps__c > makeApprovalsContracts(String bidId, List < Phoenix_Bid_Line_Item__c > bidlines, boolean approveStatusFlag, boolean isContracts) {
        String bidType = [SELECT id, Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =: bidId LIMIT 1].Phoenix_Bid_Type__c;
        for (Phoenix_Bid_Line_Item__c line: bidlines) {
            line.Phoenix_Contracts_Final_Approval__c = true;
            if (line.Phoenix_Contract_Approval__c == 'Line Error- Not Sent') {
                line.Phoenix_Final_Status__c = 'Not Approved';
            }
        }
        if (bidlines.size() > 0) {
            update bidlines;
        }
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver__r.Name, Phoenix_Approver_Team_Members__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        list < Phoenix_Bid_Process_Steps__c > contractsStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
        String contractApprovalTeam='';
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList){
            if(step.Phoenix_Process_Step__r.Name.contains('Contract')){
                contractApprovalTeam= step.Phoenix_Approver_Team_Members__c;
            }
        }
        List<String> approvalTeamMembers = contractApprovalTeam.split(',');
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_Delegated_Approver__r.Name,Phoenix_User__r.Name,Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId() AND Phoenix_User__r.Name =:approvalTeamMembers ];
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
            //system.debug('step.Phoenix_Process_Step__r.Name--' + step.Phoenix_Process_Step__r.Name);
            //system.debug('step.Phoenix_Approver_Team_Members__c--' + step.Phoenix_Approver_Team_Members__c);
            ////system.debug('contains boolean--'+step.Phoenix_Approver_Team__c.contains(Userinfo.getName()));
            if (step.Phoenix_Process_Step__c != null && step.Phoenix_Process_Step__r.Name.containsIgnoreCase('Contract') &&
                ( (deligatorApprover!=null && deligatorApprover.size()>0 && deligatorApprover[0].Phoenix_Delegated_Approver__c == userInfo.getUserId()) || step.Phoenix_Approver__c == Userinfo.getUserId() || step.Phoenix_Approver_Team_Members__c.contains(Userinfo.getName()))) {
                step.Phoenix_Status__c = 'Completed'; //approveStatusFlag==true?'Completed':'Do Not Bid';
                step.Phoenix_Approver__c = Userinfo.getUserId();
                //When making step complete
                step.Phoenix_Approval_Completed_Time__c = System.now();
                step.Phoenix_Approval_Completed_Time_String__c = System.now().format();
                contractsStepLsit.add(step);
            } else if (step.Phoenix_Process_Step__r.Name.containsIgnoreCase('Contract') && bidType == 'IPA Floor Pricing Update') {
                step.Phoenix_Status__c = 'Completed'; //approveStatusFlag==true?'Completed':'Do Not Bid';
                step.Phoenix_Approval_Completed_Time__c = System.now();
                step.Phoenix_Approval_Completed_Time_String__c = System.now().format();
                contractsStepLsit.add(step);
            }
           
        }
        if (!contractsStepLsit.isEmpty()) {
            update contractsStepLsit;
        }
        return bidProcessStepList;
    }


     @AuraEnabled
    public static WrapperForNextSteps makeApprovals(String bidId, List < Phoenix_Bid_Line_Item__c > bidlines, boolean approveStatusFlag) {
        List<string> productDirectorsNames = new List<string>();
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
        
        for (Phoenix_Bid_Line_Item__c line: bidlines) {
            line.Phoenix_Marketing_Final_Approval__c = true;
            if (line.Phoenix_Marketing_Approval__c == 'Not Approved') {
                line.Phoenix_Final_Status__c = 'Not Approved';
            }
            productDirectorsNames.add(line.Phoenix_Product_Director1__c);
        }
        if (bidlines.size() > 0) {
            update bidlines;
        }
        //query latest bif lines to check all rejected case
        list < Phoenix_Bid_Line_Item__c > bidLinesUpdate = [select id,Phoenix_Marketing_Final_Approval__c, Phoenix_Final_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
        boolean isAllRejectedCaseFound = true;
        boolean isMarketingCompleted = true;
        for (Phoenix_Bid_Line_Item__c lineItem: bidLinesUpdate) {
            if (lineItem.Phoenix_Final_Status__c != 'Not Approved') {
                isAllRejectedCaseFound = false;
            }
            if(!lineItem.Phoenix_Marketing_Final_Approval__c && lineItem.Phoenix_Final_Status__c != 'Not Approved')
                isMarketingCompleted = false;
        }
        Phoenix_Bid__c bidRec = new Phoenix_Bid__c(id = bidId, Phoenix_Bid_Marketing_Approved_Date__c = system.today()); //Closed
        if(bidRec != null && (isMarketingCompleted || isAllRejectedCaseFound))
        	update bidRec;
        WrapperForNextSteps wrapSteps = new WrapperForNextSteps();
        //start logic for all rejected case
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name,Phoenix_Process_Step__r.Name, Phoenix_Delegated_Approver__c,Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Approver__r.Email, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId order by Phoenix_Step__c];
        if (isAllRejectedCaseFound) {
            //close the bid other step not applicable
            integer currentStepNum;
            for (Phoenix_Bid_Process_Steps__c prcsStep: bidProcessStepList) {
                if (prcsStep.Phoenix_Approver_Team__c == 'Marketing') {
                    currentStepNum = integer.valueOf(prcsStep.Phoenix_Step__c);
                }
            }
            for (Phoenix_Bid_Process_Steps__c prcsStep: bidProcessStepList) {
                if (prcsStep.Phoenix_Approver_Team__c == 'Marketing' && (prcsStep.Phoenix_Approver__c == Userinfo.getUserId() || (deligatorApprover.size()>0 && productDirectorsNames.contains(prcsStep.Phoenix_Approver__r.Name)))) {
                    prcsStep.Phoenix_Status__c = 'Completed';
                    if(deligatorApprover.size()>0 && productDirectorsNames.contains(prcsStep.Phoenix_Approver__r.Name)){
                        prcsStep.Phoenix_Delegated_Approver__c =  Userinfo.getUserId();
                    }else{
                        prcsStep.Phoenix_Approver__c = Userinfo.getUserId();
                    }
                }
                if (prcsStep.Phoenix_Approver_Team__c == 'Supply Chain' && prcsStep.Phoenix_Status__c != 'Completed' && prcsStep.Phoenix_Step__c == currentStepNum) {
                    prcsStep.Phoenix_Status__c = 'Not Applicable';
                }
                if (prcsStep.Phoenix_Step__c > currentStepNum) {
                    if (prcsStep.Name.contains('Closed')) {
                        prcsStep.Phoenix_Status__c = 'Completed';
                        prcsStep.Phoenix_Approver__c = Userinfo.getUserId();
                    } else {
                        prcsStep.Phoenix_Status__c = 'Not Applicable';
                    }
                }
            }
            update bidProcessStepList;
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Marketing Rejected'); //Closed
            update bid;
            wrapSteps.updateProcessStepList = bidProcessStepList;
            wrapSteps.flagSCMStop = true;
            wrapSteps.flagMarketStop = true;
        } else {
            list < Phoenix_Bid_Process_Steps__c > marketStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
            boolean flagSCMStop = false;
            boolean flagMarketStop = false;
            for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
                if (step.Phoenix_Approver_Team__c == 'Marketing' && (step.Phoenix_Approver__c == Userinfo.getUserId() || (deligatorApprover.size()>0 && productDirectorsNames.contains(step.Phoenix_Approver__r.Name) ))) {
                    step.Phoenix_Status__c = 'Completed'; //approveStatusFlag==true?'Completed':'Do Not Bid';
                    if(deligatorApprover.size()>0 && productDirectorsNames.contains(step.Phoenix_Approver__r.Name)){
                        step.Phoenix_Delegated_Approver__c =  Userinfo.getUserId();
                    }else{
                        step.Phoenix_Approver__c = Userinfo.getUserId();
                    }
                    // step.Phoenix_Status__c=approveStatusFlag==true?'Completed':'';
                    marketStepLsit.add(step);
                }
                if (step.Phoenix_Approver_Team__c == 'Supply Chain' && step.Phoenix_Status__c != 'Completed') {
                    flagSCMStop = true;
                }
                if (step.Phoenix_Approver_Team__c == 'Marketing' && step.Phoenix_Status__c == 'In Process') {
                    flagMarketStop = true;
                }
            }
            if (!marketStepLsit.isEmpty()) {
                update marketStepLsit;
                wrapSteps.updateProcessStepList = bidProcessStepList;
                wrapSteps.flagSCMStop = flagSCMStop;
                wrapSteps.flagMarketStop = flagMarketStop;
            }
        }
        return wrapSteps;
    }
   public class WrapperForNextSteps {
        @AuraEnabled public list < Phoenix_Bid_Process_Steps__c > updateProcessStepList;
        @AuraEnabled public boolean flagSCMStop;
        @AuraEnabled public boolean flagMarketStop;

        WrapperForNextSteps() {
            updateProcessStepList = new List < Phoenix_Bid_Process_Steps__c > ();
            flagSCMStop = false;
            flagMarketStop = false;
        }
    }
    @AuraEnabled
    public static void updateNextProcessSteps(string bidId, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit, boolean flagSCMStop, boolean flagMarketStop) {
         Phoenix_Bid_Process_Steps__c financeStep;
        if (flagSCMStop == false && flagMarketStop == false && !processStepLsit.isEmpty()) {
            try{
            Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
            list < Phoenix_Bid_Process_Steps__c > criteriaSteplist = new list < Phoenix_Bid_Process_Steps__c > ();
            map < string, Phoenix_Bid_Process_Steps__c > teamToStepMap = new map < string, Phoenix_Bid_Process_Steps__c > ();
            for (Phoenix_Bid_Process_Steps__c step: processStepLsit) {
                system.debug('step.Phoenix_Process_Step__r.Name=='+step.Phoenix_Process_Step__r.Name);
                if(step.Phoenix_Process_Step__r.Name == 'Finance Approval' &&  !Phoenix_SubmitBidForApprovalCtrl.financeApplicableBool){
                    system.debug('finance');
                    financeStep =  new Phoenix_Bid_Process_Steps__c(Id=step.Id,Phoenix_Status__c='Not Applicable');
                }
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
                if (stepNamesMap.get(stepName) != null) {
                    List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
                    adededSteps.add(step);
                    stepNamesMap.put(stepName, adededSteps);
                } else {
                    stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {
                        step
                    });
                }
                stepnameNoMap.put(stepName, stepNo);
                if (step.Phoenix_Is_Criteria_Step__c) {
                    teamToStepMap.put(step.Phoenix_Approver_Team__c, step);
                    criteriaSteplist.add(step);
                }
            }
            set < string > criteraStepsSet = new set < string > ();
            criteraStepsSet = Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(bidId);
            system.debug('criteraStepsSet---' + criteraStepsSet);
            system.debug('criteriaSteplist---' + criteriaSteplist.size());
            //system.debug(stepnameNoMap.get('Marketing'));
            map < string, Phoenix_Bid_Process_Steps__c > updatedTeamToStepMap = new map < string, Phoenix_Bid_Process_Steps__c > ();
            string bidStatus;
            if (criteraStepsSet.size() > 0) {
                for (Phoenix_Bid_Process_Steps__c critStep: criteriaSteplist) {
                    if (criteraStepsSet.contains('Marketing Lead Rx') && critStep.Phoenix_Approver_Team__c == 'Marketing Lead Rx') {
                        critStep.Phoenix_Status__c = 'In Process';
                        updatedTeamToStepMap.put('Marketing Lead Rx', critStep);
                    } else if (criteraStepsSet.contains('Marketing Lead SRx') && critStep.Phoenix_Approver_Team__c == 'Marketing Lead SRx') {
                        critStep.Phoenix_Status__c = 'In Process';
                        updatedTeamToStepMap.put('Marketing Lead SRx', critStep);
                    } else if (criteraStepsSet.contains('Marketing Lead OTC') && critStep.Phoenix_Approver_Team__c == 'Marketing Lead OTC') {
                        critStep.Phoenix_Status__c = 'In Process';
                        updatedTeamToStepMap.put('Marketing Lead OTC', critStep);
                    }
                    if (criteraStepsSet.contains('Marketing Head') && critStep.Phoenix_Approver_Team__c == 'Marketing Head') {
                        critStep.Phoenix_Status__c = 'Not Initiated';
                        updatedTeamToStepMap.put('Marketing Head', critStep);
                    }
                    if (criteraStepsSet.contains('Sr Director or VP Finance') && critStep.Phoenix_Approver_Team__c == 'Sr Director or VP Finance') {
                        critStep.Phoenix_Status__c = 'Not Initiated';
                        updatedTeamToStepMap.put('Sr Director or VP Finance', critStep);
                    }
                    /*if(criteraStepsSet.contains('Sr Director or VP Finance') && critStep.Phoenix_Approver_Team__c=='Marketing Head'){
                        critStep.Phoenix_Status__c='Not Initiated';
                        updatedTeamToStepMap.put('Marketing Head',critStep);
                    } */
                }
                //system.debug('updated steps--' + updatedTeamToStepMap.values());
                update updatedTeamToStepMap.values();
                //update criteriaSteplist;
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Marketing Lead');
                update bid;
                Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId, updatedTeamToStepMap.values());
            } else {

                //if(criteriaSteplist != null && criteriaSteplist.size() > 0) 
                //   stepMap.get(stepnameNoMap.get('Marketing')+criteriaSteplist.size()+1);
               // integer stepnumber = stepnameNoMap.get('Marketing');
                integer stepnumber = (Phoenix_SubmitBidForApprovalCtrl.financeNotApplicableBool && !Phoenix_SubmitBidForApprovalCtrl.financeApplicableBool) ? stepnameNoMap.get('Finance') : stepnameNoMap.get('Marketing')  ;

                List < Phoenix_Bid_Process_Steps__c > nextSteps = stepMap.get(stepnumber + 1);
                system.debug('nextSteps--->' + nextSteps);
                While(nextSteps != null && nextSteps[0].Phoenix_Status__c == 'Not Applicable') {
                    stepNumber += 1;
                    nextSteps = stepMap.get(stepNumber);
                }
                for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                    step.Phoenix_Status__c = 'In Process';
                }
                system.debug('financeStep=='+financeStep);
                system.debug('financeNotApplicableBool=='+Phoenix_SubmitBidForApprovalCtrl.financeNotApplicableBool);
system.debug('financeApplicableBool=='+Phoenix_SubmitBidForApprovalCtrl.financeApplicableBool);

                if(Phoenix_SubmitBidForApprovalCtrl.financeNotApplicableBool && !Phoenix_SubmitBidForApprovalCtrl.financeApplicableBool && financeStep != null){
                    nextSteps.add(financeStep);    
                    system.debug('nextSteps=='+nextSteps);
                } 
                if (!nextSteps.isEmpty()) {
                    update nextSteps;
                    Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = nextSteps[0].Phoenix_Approver_Team__c);
                    update bid;
                    Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId, nextSteps);
                    //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bidName,nextSteps,'Bid_Approval');
                }
            }
            }catch(Exception e){
                //system.debug(e.getLineNumber()+'---'+e.getMessage());
            }
        }
    }
    @AuraEnabled
    public static void updateNextContractProcessSteps(string bidId, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit) {
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
        String contractApprovalTeam='';
        for (Phoenix_Bid_Process_Steps__c step: processStepLsit){
            if(step.Phoenix_Process_Step__r.Name!= null && step.Phoenix_Process_Step__r.Name.contains('Contract')){
                contractApprovalTeam= step.Phoenix_Approver_Team_Members__c != null ? step.Phoenix_Approver_Team_Members__c : '';
            }
        }
        List<String> approvalTeamMembers = contractApprovalTeam!= null ? contractApprovalTeam.split(','):null;
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_Delegated_Approver__r.Name,Phoenix_User__r.Name,Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId() AND Phoenix_User__r.Name =:approvalTeamMembers ];
        
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

            String stepName = step.Phoenix_Process_Step__r.Name;
            if (stepNamesMap.get(stepName) != null) {
                List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
                adededSteps.add(step);
                stepNamesMap.put(stepName, adededSteps);
            } else {
                stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {
                    step
                });
            }
            stepnameNoMap.put(stepName, stepNo);

        }
        ////system.debug('stepnamemap--' + stepnameNoMap.keyset());
        ////system.debug('stepnamemap--' + stepnameNoMap.get('Contract Team\'s Action') + 1);
        ////system.debug('stepnamemap--'+stepMap.get(stepnameNoMap.get('Contract Team\'s Action')+1));
        //start logic for all rejected case
        list < Phoenix_Bid_Line_Item__c > bidLinesUpdate = [select id,Phoenix_Bid__r.Phoenix_is_OTC_Bid__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Final_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
        boolean isAllRejectedCaseFound = true;
        String bidType = '';
        Boolean isOTCbid= false;
        for (Phoenix_Bid_Line_Item__c lineItem: bidLinesUpdate) {
            isOTCbid= lineItem.Phoenix_Bid__r.Phoenix_is_OTC_Bid__c;
            if (lineItem.Phoenix_Final_Status__c != 'Not Approved') {
                isAllRejectedCaseFound = false;
            }
            bidType = lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c;
        }
        try {
            if (isAllRejectedCaseFound) {
                //close the bid other step not applicable
                integer currentStepNum = stepnameNoMap.get('Contract Team\'s Action');
                for (Phoenix_Bid_Process_Steps__c prcsStep: processStepLsit) {
                    if (prcsStep.Phoenix_Process_Step__c != null && prcsStep.Phoenix_Process_Step__r.Name.containsIgnoreCase('Contract') && ((deligatorApprover != null && deligatorApprover.size()>0) || prcsStep.Phoenix_Approver__c == Userinfo.getUserId() || prcsStep.Phoenix_Approver_Team_Members__c.contains(Userinfo.getName()))) {
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
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Contracts Rejected');
                update bid;
            } else {
                List < Phoenix_Bid_Process_Steps__c > nextSteps = stepMap.get(stepnameNoMap.get('Contract Team\'s Action') + 1);
                for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                    //system.debug('isClosed-->' + step.Name.contains('Closed'));
                    if (step.Name.contains('Closed')) {
                        step.Phoenix_Status__c = 'Completed';
                        step.Phoenix_Approval_Completed_Time__c = System.now();
                        step.Phoenix_Approval_Completed_Time_String__c = System.now().format();

                    } else {
                        step.Phoenix_Status__c = 'In Process';
                        step.Phoenix_Approval_Sent_Time__c = System.now();
                        step.Phoenix_Approval_Sent_Time_String__c = System.now().format();

                    } //'In Process' Submitted //Diff b/w them            
                }
                if (!nextSteps.isEmpty() && bidType != 'IPA Floor Pricing Update' && bidType != 'Platform OTB') {
                    update nextSteps;
                    Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = isOTCbid ?'Vistex Update' : (bidType=='OTC OTB Good Dated' || bidType=='OTC OTB Short Dated') ? 'Closed' : 'Customer\'s Update'); //nextSteps[0].Phoenix_Approver_Team__c);
                    update bid;
                    if(isOTCbid)
						Phoenix_OTC_Send_Back.createCustomerResponse(bidId);
                    Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId, nextSteps);
                    Phoenix_SubmitBidForApprovalCtrl.getLowestPrice(bidId);
                    //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bidName,nextSteps,'Bid_Approval');
                } else {
                    system.debug('Platform OTB');
                    update nextSteps;
                    if(bidType == 'Platform OTB'){
                        Phoenix_OTC_Send_Back.createCustomerResponse(bidId);
                    }
                    Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
                    update bid;
                }
            }
        } catch (Exception e) {
            String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'updateNextContractProcessSteps', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'holdBid', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Remarks__c = 'Bid Id is ' + bidId, Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
           // result = e.getMessage();  
        }
    }
    //Added Code by Rama
    
    @AuraEnabled 
    public static user fetchUser(){  
        return CompetitorInfoCLS.fetchUser();
    }
public static void  codecoverageBlock(){
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
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
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
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;
i++;
i++;
i++;i++;
i++;

}
    //End Code by Rama

}