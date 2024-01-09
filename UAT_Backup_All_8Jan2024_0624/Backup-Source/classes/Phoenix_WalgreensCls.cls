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
public class Phoenix_WalgreensCls {
    @AuraEnabled
    public static void getLastBidActivity(Id bidId) {
        try{
        System.debug('bidId==>'+bidId);
        List<Phoenix_Bid__c> bid = [SELECT Id, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Is_Re_Bid__c, Phoenix_Previous_Bid__c, Phoenix_OTB_Direct_Indirect__c, Phoenix_Bid_Proposed_Position__c, Phoenix_Proactive_Reactive__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Current_CD__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        if(bid != null){
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
        }
            else{
            System.debug('in insert condition at last');
            Bid_Last_Activity__c actvityrec= new Bid_Last_Activity__c();
            actvityrec.Name = bid[0].Name+'_'+ userInfo.getLastName();//bid.Phoenix_Bid_Name__c+'_'+ userInfo.getLastName();
            actvityrec.Bid_Name__c = bid[0].Phoenix_Bid_Name__c;
            actvityrec.Bid__c = bidId;
            actvityrec.Logged_in_User__c = userInfo.getName();
            actvityrec.Date_and_Time__c = Phoenix_Util.getNowEST();
            actvityrec.User__c = userInfo.getUserId();
            actvityrec.Test__c = Phoenix_Util.getUserTimeNow(actvityrec.Date_and_Time__c, 'America/New_York');
            insert actvityrec;
        }
        } 
        }
          Catch(Exception e) {
                    String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
                    System.debug('msg in last bid activity==>'+msg);
                } 
    }
    @AuraEnabled
    public static string getSubmitBidInfo(Id bidId) {
        Phoenix_SubmitBidForApprovalCtrl.BidWrapper warpper = Phoenix_SubmitBidForApprovalCtrl.getBidInfo(bidId);
        system.debug('warpper---' + warpper.error);
        string response = Phoenix_SubmitBidForApprovalCtrl.submitBid(warpper);
        system.debug('response--' + response);
        return response;
    }
    @AuraEnabled
    public static list < AggregateResult > getAllTotals(Id bidId) {
        AggregateResult[] groupedResults = [select sum(Phoenix_Current_Indirect_Selling_Unit__c) cisu,
                                            sum(Phoenix_Current_Direct_Selling_Unit__c) cdsu,
                                            sum(Phoenix_Total_Selling_Unit__c) tsu,
                                            sum(Phoenix_Final_Direct_Selling_Units_Calc__c) fdsu,
                                            sum(Phoenix_Net_Sales_Internal__c) netsint,
                                            sum(Phoenix_Final_Indirect_Selling_Units_Cal__c) fisu,
                                            sum(Phoenix_Final_Total_Selling_Unit__c) ftsu,
                                            sum(Phoenix_Final_Annual_Extended_Units__c) finalAnulUnits,                               
                                            sum(Phoenix_Internal_Dead_Net_Price__c) intdead,
                                            sum(Phoenix_Retail_Direct_Guidance_Price__c) retaildirguidesales,
                                            sum(Phoenix_Wholesaler_Guidance_Price__c) whslGuidesales,
                                            sum(Phoenix_Retail_Direct_Sales_Price__c) retailguidesales,
                                            sum(Phoenix_Wholesaler_Sales_Price__c) whslsales,
                                            sum(Phoenix_Current_Retail_Indirect_Net__c) currentDSHP,
                                            sum(Phoenix_Retail_Indirect_Net__c) proposedDSHP,
                                            sum(Phoenix_12_Months_TotalSaleUnits__c) ActualTotalUnits,
                                            sum(Phoenix_Override_Current_Units__c) OverrideTotalUnits,
                                            sum(Phoenix_Override_Current_Direct_Units__c) overRideDirectUnits,                                
                                            sum(Phoenix_Override_Current_Indirect_Units__c) overRideIndirectUnits,                                
                                            sum(Phoenix_Retail_Direct_Price__c) retailmarketing,
                                            sum(Phoenix_Wholesaler_DRL_Net_Price__c)  BASEDRLNetP,
                                            sum(Phoenix_Anda_DRL_Net_price__c) DSHDRLNetP,
                                            sum(Phoenix_Wholesaler_DRL_TPT__c) AutoSubDRLNetP,
                                            sum(Phoenix_Indirect_Dead_Net__c) indirectDeadNet,
                                            sum(Phoenix_Retail_Indirect_Price__c) retailIndirectmrket,
                                            sum(Proposed_Net_Sales_Direct__c) netSaleDir,
                                            sum(Proposed_Net_Sales_Indirect__c) netSaleIndir,
                                            sum(Phoenix_TP_Margin__c)TputMarginPer,
                                            sum(Proposed_TPT_Direct__c) tptDir,
                                            sum(Proposed_TPT_Indirect__c) tptIndir,
                                            sum(Phoenix_Th_Put_Margin__c) TputMargin,
                                            sum(Phoenix_Proposed_TPMargin__c) TPMarginPerc,
                                            sum(Indirect_TP__c) IndirectTP,
                                            sum(Phoenix_Override_Total_units__c )OverrideUnits,
                                            sum(Phoenix_12_Months_Actual_Sales__c)actualsales,
                                            sum(Phoenix_Total_SCM_Approved_Qty__c) scmAPQTY, 
                                            sum(Phoenix_Others_Indirect__c )BASEMonthlyUnits,
                                            sum(Phoenix_Others_Direct__c )otherDirectUnits,
                                            sum(Phoenix_Proposed_TPMargin__c)DRLTPTPercent,
                                            sum(Phoenix_Retail_Direct_Net_sales__c)retailDirNetSales,	
                                            sum(Phoenix_Retail_Indirect_Net_Sales__c)retailInDirNetSales,	
                                            sum(Phoenix_Anda_Net_Model_Sales__c)AndaNetModelSales,	
                                            sum(Phoenix_Wholesaler_Net_Sales__c)WHLSNetSales,	
                                            sum(Phoenix_12_Months_Actual_Sales__c)actSaDir12Months,	
                                            sum(Phoenix_12_Months_IndirectSaleUnit__c)actSalInd12months,	
                                            sum(Phoenix_12_Months_TotalSaleUnits__c)actTotal12Months,	
                                            sum(Phoenix_Proposed_Direct_Selling_Unit__c)proDirUnits,	
                                            sum(Phoenix_Proposed_Indirect_Selling_Unit__c)proIndUnits,	
                                            sum(Phoenix_ProposedContractBidPriceMktng__c)proDirMark,	
                                            sum(Phoenix_Wholesaler_Diff_Price_Indirect__c)proIndiMark,	
                                            sum(Phoenix_Customer_Dead_net__c)netIndirPrice,
                                            sum(Phoenix_ProposedIndirectAholdDelhaizeUni__c) BASEAnnualUsage,
                                            sum(Phoenix_Retail_IOD_overall_amount__c) BASEAnnualNetSales,
                                            sum(Phoenix_ANDA_IOD_Overall_Amount__c) BASECOGS,
                                            sum(Phoenix_Wholesaler_IOD_overall_amount__c) BASETPbeforePS,
                                            sum(Phoenix_Proposed_IndirectGaintEagleUnits__c )DSHMonthlyUnits,
                                            sum(Phoenix_Current_Retail_Indirect_Units__c) DSHAnnualUsage,
                                            sum(Phoenix_Retail_Direct_Net_sales__c) DSHAnnualNetSales,
                                            sum(Phoenix_Retail_Indirect_Net_Sales__c) DSHCOGS,
                                            sum(Phoenix_Anda_Net_Model_Sales__c) DSHTPbeforePS,
                                            sum(Phoenix_Current_Indirect_Gaint_EagleUnit__c )AutoSubMonthlyUnits,
                                            sum(Phoenix_Current_Anda_Net_Model_Units__c) AUTOSUBAnnualUsage,
                                            sum(Phoenix_Wholesaler_Net_Sales__c) AUTOSUBAnnualNetSales,
                                            sum(Phoenix_Retail_Indirect_WAC_NLC_Fee__c) AUTOSUBCOGS,
                                            sum(Phoenix_Wholesaler_Guidance_Price__c) AUTOSUBTPbeforePS,
                                            sum(Phoenix_IOD_Total_Amount__c) IODTotalAmount,
                                            sum(Phoenix_IDN_Usage__c) baseSCMQty,
                                            sum(Phoenix_Costco_TPT__c) TPTPerUnit,
                                            sum(Phoenix_Days_Notice_Product_Discontinuat__c) DSHSCMQty,
                                            sum(Phoenix_Day_s_Notice_Product_removal__c) AutoSubSCMQty,
                                            
                                            sum(Phoenix_Proposed_Smith_Drug_Units__c )proposedBase,
                                            sum(Phoenix_Proposed_Anda_Units__c )proposedDSH,
                                            sum(Phoenix_ProposedDirectAholdDelhaizeUnits__c )proposedAutoSub,
                                            
                                            
                                            sum(Phoenix_Override_Current_Direct_Units__c )OverrideDirUnits,
                                            sum(Phoenix_Override_Current_Indirect_Units__c )OverrideInDirUnits,
                                            sum(Phoenix_Override_Current_Units__c )OverUnits,
                                            sum(Phoenix_Current_Wholesaler_Units__c) currentwholesalerUnits,
                                            sum(Phoenix_Current_Anda_Units__c) currentAndaUnits,
                                            sum(Phoenix_Current_Retail_Direct_Units__c) currentRetailDirectUnits,
                                            
                                            sum(Phoenix_ProposedDirectGaintEagleUnits__c) proposedDirGiantUnits,
                                            sum(Phoenix_Proposed_TP_Margin__c) propoTPmargin,
                                            sum(Phoenix_Opening_Order__c) OpeningOrder,
                                            sum(Phoenix_Opening_Order_Net_sales__c) OpeningOrderNetSales,
                                            sum(Phoenix_Opening_Order_TPT__c) OpeningOrderTPT,
                                            sum(Phoenix_Opening_Order_TPT_Per__c) OpeningOrderTPTPerc,
                                            sum(Phoenix_Direct_Accerodo__c) OpeningOrderAnda,
                                            sum(Proposed_Net_Sales_Direct__c) OpeningOrderNetSalesAnda,
                                            sum(Proposed_Net_Sales_Indirect__c) OpeningOrderTPTAnda,
                                            sum(Phoenix_Current_Anda_Net_Model_Units__c) OpeningOrderWholesaler,
                                            sum(Phoenix_WMT_Indirect_Net_Sales__c) OpeningOrderNetSalesWholesaler,
                                            sum(Phoenix_Costco_TPT__c) OpeningOrderTPTWholesaler
                                            from Phoenix_Bid_Line_Item__c where
                                            Phoenix_Bid__c =: bidId and Phoenix_Final_Status__c != 'Not Approved'
                                           ];
        return groupedResults;
    }
    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > getupdatedforExport(Id bidId) {
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
        query = 'select Phoenix_Bid__r.Phoenix_Proposed_Initial_Order_Discount__c,Phoenix_Product__r.Winnability__c,Phoenix_Previous_LineItem__r.Name,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved ORDER BY Product_Family_Name__c ASC';
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
    @AuraEnabled
    public static Wrapper getRelatedList(Id bidId) {
        getLastBidActivity(bidId);
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Is_Re_Bid__c, Phoenix_Previous_Bid__c, Phoenix_OTB_Direct_Indirect__c, Phoenix_Bid_Proposed_Position__c, Phoenix_Proactive_Reactive__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Current_CD__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        
        Wrapper wrapperObject = new Wrapper();
        //String query = 'SELECT Name,Phoenix_Product__c,Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Net_Price_after_RebatesbeforeVIP__c, Phoenix_Bid__c,Phoenix_Case_Pack__c,Phoenix_Pkg_Size__c,Phoenix_Product_Family__c,Phoenix_NDC_National_Drug_Code__c,Phoenix_Product_Code__c,Phoenix_Compare_to_Brand_Name__c,Phoenix_Product_Director__c,Phoenix_Orange_Book_Rating__c,Phoenix_Throughput_cost__c,Phoenix_WAC__c,Phoenix_Current_Indirect_Selling_Unit__c	,Phoenix_Current_Direct_Selling_Unit__c,Phoenix_Total_Selling_Unit__c,Phoenix_Doses__c , Phoenix_Proposed_Indirect_Selling_Unit__c,Phoenix_Proposed_Direct_Selling_Unit__c, Phoenix_Final_Indirect_Selling_Units__c,Phoenix_Final_Direct_Selling_Units__c, Phoenix_Final_Total_Selling_Unit__c, Phoenix_Final_Annual_Extended_Units__c, Phoenix_Wholesaler_Diff_Price_Indirect__c, Phoenix_Current_Direct_Price__c, Phoenix_Current_Indirect_Price__c,  Phoenix_ProposedContract_Bid_Price_Sales__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Proposed_Current_Rebate__c, Phoenix_Current_Rebate__c, Phoenix_Proposed_Per_Unit_Rebate__c,Phoenix_Current_Per_Unit_Rebate__c, Phoenix_Gross_Contract_Sales__c, Phoenix_Value_Rebate__c,Phoenix_Value_Per_Unit_Rebate__c,Phoenix_Value_Admin_Fee__c	,Phoenix_Current_Admin_Fee__c,Phoenix_Value_Est_VIP__c,Phoenix_Sales_Out_Promotion__c,Phoenix_Initial_Order_Discount__c, Phoenix_Cash_Terms_Non_Weighted__c, Phoenix_Net_Sales_External__c ,Phoenix_Net_Sales_Internal__c ,Phoenix_Cash_Terms_Weighted__c, Phoenix_Estimated_Medicaid_Returns__c,Phoenix_Contr_Management_Fee_Wholesaler__c, Phoenix_Less_Cost__c, Phoenix_Th_Put_Margin__c, Phoenix_Net_Price_afterRebates_after_VIP__c,Phoenix_Net_Price_after_Rebates_Terms__c, Phoenix_Internal_Dead_Net_Price__c,Phoenix_TP_Margin__c, Phoenix_Budgeted_ASP_Q1_FY21__c,Phoenix_Sales_Notes__c, Phoenix_SCM_Notes__c, Phoenix_Pricing_Notes__c,Phoenix_Marketing_Notes__c,Phoenix_WAC_Check__c ,Phoenix_SSA_Hit__c   FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =: bidId limit 1000';
        //System.debug('query'+query);
        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '')
                strFields = fieldName;
            else
                strFields = strFields + ' , ' + fieldName;
        }
        string notApproved = 'Not Approved';
        query = 'select Phoenix_Product__r.Product_Family__r.Name, Phoenix_Product__r.Winnability__c,Phoenix_Product__r.Id,Phoenix_Bid__r.Phoenix_Is_Re_Bid__c,Phoenix_Product__r.Phoenix_WAC__c,Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c,Phoenix_Previous_Bid__r.Name,Phoenix_Previous_LineItem__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved ORDER BY Product_Family_Name__c ASC';
        list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);
        system.debug('quoteList--->' + quoteList);
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
        boolean hasDirectorLines = false;
        User cuurentUser;
        if (bid.Phoenix_Bid_Created_Behalf_of__c != null && bid.Phoenix_Approval_Status__c == 'Draft')
            cuurentUser = [SELECT id, Name FROM User WHERE Id =: bid.Phoenix_Bid_Created_Behalf_of__c LIMIT 1];
        else
            cuurentUser = [SELECT id, Name FROM User WHERE Id =: userinfo.getUserId() LIMIT 1];
        
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Delegated_Approver__r.Name,Phoenix_User__r.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
        String delegatedUsers = cuurentUser.Name;
        if(deligatorApprover !=null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c aprHisDel : deligatorApprover){
                delegatedUsers = delegatedUsers + ',' + aprHisDel.Phoenix_User__r.Name;
            }
        }
        List<String> prodIds = new List<String>();//for analysis
        for (Phoenix_Bid_Line_Item__c lineItem: quoteList) {
            prodIds.add(lineItem.Phoenix_Product__c);//for analysis
            if (!productFamilyList.contains(lineItem.Product_Family_Name__c)) {
                // Columns column = new Columns();
                // column.label = string.valueof(lineItem.Phoenix_Product_Family__c) ;
                // column.value = string.valueof(lineItem.Phoenix_Product_Family__c) + 's';
                // columnsList.add(column);
                productFamilyList.add(lineItem.Product_Family_Name__c);
            }
            if (lineItem.Phoenix_Product_Director__c != null && !productDirectorList.contains(lineItem.Phoenix_Product_Director__c))
                productDirectorList.add(lineItem.Phoenix_Product_Director__c);
            if (lineItem.Phoenix_Product_Director__c != null && (lineItem.Phoenix_Product_Director__c == userInfo.getName() || (delegatedUsers!=null && delegatedUsers.contains(lineItem.Phoenix_Product_Director__c))) && lineItem.Phoenix_Marketing_Final_Approval__c == false) 
                hasDirectorLines = true;
            if (lineItem.Phoenix_Marketing_Final_Approval__c == true && lineItem.Phoenix_Product_Director__c == userinfo.getName()) 
                showProceedBtn = false;
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
                lineItem.Vision_Analysis_Volume__c = prodEstimateVolMap.get(lineItem.Phoenix_Product__c);//*lineItem.Phoenix_Pkg_Size__c;
            newItem.add(lineItem);
        }
        update newItem;
        //for analysis ends
        if(hasDirectorLines){
            showProceedBtn = true;
        }
        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, Phoenix_Approver__r.Name, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__r.Name);
        }
        string isMarketingApprovePerson;
        boolean isContractsApprovePerson;
        boolean isDelegationPerson=false;
        boolean isMarketingDelegationPerson = false;
        wrapperObject.deligatedUserName = delegatedUsers;
        if(deligatorApprover !=null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c aprHisDel : deligatorApprover){
                if(userTeamUserIdMap.containsKey('Contracts-'+aprHisDel.Phoenix_User__c)){
                    isDelegationPerson = true;
                }
                if(userTeamUserIdMap.containsKey('Marketing-'+aprHisDel.Phoenix_User__c)){
                    isMarketingDelegationPerson = true;
                    //wrapperObject.deligatedUserName  = wrapperObject.deligatedUserName + aprHisDel.Phoenix_User__r.Name;
                }
            }
        }
        if (userTeamUserIdMap.containsKey('Marketing-' + cuurentUser.Id) && hasDirectorLines && cuurentUser.Name == userInfo.getName() ) {
            isMarketingApprovePerson = userTeamUserIdMap.get(('Marketing-' + cuurentUser.Id));
        }else if(isMarketingDelegationPerson && hasDirectorLines && cuurentUser.Name == userInfo.getName()){
            isMarketingApprovePerson=cuurentUser.Name;
        }else{
            isMarketingApprovePerson=null;
        }
        if (userTeamUserIdMap.containsKey('Contracts-' + cuurentUser.Id) || isDelegationPerson) {
            isContractsApprovePerson = true;
        }
        
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
    public static List < Phoenix_Bid_Line_Item__c > getReBidLineInfo(string productId, string bidId) {
        system.debug('---------productId-----' + productId);
        system.debug('---------bidId-----' + bidId);
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Is_Re_Bid__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        string ultimateParent = bid.Phoenix_Ultimate_Parent__c;
        list < Phoenix_Bid__c > bidUltimateList = [SELECT Id, Phoenix_Is_Re_Bid__c, Phoenix_Current_CD__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Phoenix_Ultimate_Parent__c =: ultimateParent and Id !=: bidId];
        set < string > parentRebidIds = new set < string > ();
        for (Phoenix_Bid__c pb: bidUltimateList) {
            parentRebidIds.add(pb.Id);
        }
        parentRebidIds.add(ultimateParent);
        system.debug('-----------parentRebidIds--------------' + parentRebidIds);
        list < Phoenix_Bid_Line_Item__c > reBidLineItemList = [SELECT id,Phoenix_Current_Direct_Price__c,Phoenix_Current_Indirect_Price__c,Phoenix_Retail_Indirect_Net__c,Phoenix_Current_Retail_Indirect_Net__c, Phoenix_ProposedContract_Bid_Price_Sales__c, Phoenix_ProposedContractBidPriceMktng__c, Phoenix_Wholesaler_Diff_Price_Indirect__c, Phoenix_Wholesaler_Sales_Price__c, Phoenix_Current_Retail_Indirect_Price__c, Phoenix_Retail_Direct_Sales_Price__c, Phoenix_Current_Retail_Direct_Price__c, Phoenix_Retail_Direct_Price__c, Phoenix_Retail_Indirect_Price__c, Phoenix_Retail_Direct_Guidance_Price__c, Phoenix_Wholesaler_Guidance_Price__c, Phoenix_Bid__r.CreatedDate, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Ultimate_Parent__c, Phoenix_Bid__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Guidance_Price__c FROM Phoenix_Bid_Line_Item__c WHERE(Phoenix_Product__c =: productId AND Phoenix_Bid__c IN: parentRebidIds) ORDER BY Phoenix_Bid__r.Name ASC LIMIT 30000];
        return reBidLineItemList;
    }
    @AuraEnabled
    public static void updateRelatedList(List < Phoenix_Bid_Line_Item__c > lineItemsList) {
        if (lineItemsList != null && lineItemsList.size() > 0) {
            update lineItemsList;
        }
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
        
        @AuraEnabled
        public Product2 prdlist {
            get;
            set;
        }
        
        @AuraEnabled
        public List < Phoenix_Bid__c > bidList {
            get;
            set;
        }
        
        @AuraEnabled
        public Phoenix_NPR_Data__c nprRec {
            get;
            set;
        }
        
        @AuraEnabled
        
        public Phoenix_Bid_Line_Item__c qlItem {
            get;
            set;
        }
        
        
        
        Wrapper() {
            columnList = new List < Columns > ();
            lineItemsList = new List < Phoenix_Bid_Line_Item__c > ();
            productfamilyList = new List < String > ();
            productDirectorList = new List < String > ();
            loggedInUserName = '';
            isMarketingApprovePerson = '';
            isContractsApprovePerson = false;
        }
    }
    @AuraEnabled
    public static Phoenix_Bid__c saveLineItems(List < Phoenix_Bid_Line_Item__c > LineItemList, Id LineItemId, string rebateHeader, string feeHeader,string cdHeader , string contractApproval,boolean isCashTermChanged, boolean isRebateChanged, boolean isFeeChanged, boolean isApprovalChanged, String marketingHeader, boolean isMarketingChanged, string productPositions,String vipHeader, boolean isVipChanged) {
        List < Phoenix_Bid_Line_Item__c > lineList = [select id, name,Phoenix_Bid__r.Phoenix_Customer_Type__c,Phoenix_Bid__r.Phoenix_Rebate__c, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Product_Director1__c, Phoenix_Marketing_Approval__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: LineItemId];
        List < Phoenix_Bid_Line_Item__c > productDirectorLineItems = new List < Phoenix_Bid_Line_Item__c > ();
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Is_Re_Bid__c, Phoenix_Current_CD__c, Phoenix_Proactive_Reactive__c, Phoenix_Previous_Bid__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: lineList[0].Phoenix_Bid__c];
        if (lineList != null && lineList.size() > 0 && rebateHeader != '' || feeHeader != null || marketingHeader != '') {
            String currentUser = [SELECT id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].Name;
            for (Phoenix_Bid_Line_Item__c lineItem: lineList) {
                if (lineItem.Phoenix_Product_Director1__c == currentUser && isMarketingChanged && marketingHeader != '') {
                    lineItem.Phoenix_Marketing_Approval__c = marketingHeader;
                }
                if (cdHeader != '' && isCashTermChanged == true)
                    lineItem.Phoenix_Cash_Discount_NPR__c = decimal.valueOf(cdHeader);
                if (rebateHeader != '' && isRebateChanged == true)
                    lineItem.Phoenix_Rebate_G_N__c = rebateHeader;
                if (feeHeader != '' && isFeeChanged == true)
                    lineItem.Phoenix_Fee_G_N__c = feeHeader;
                system.debug('vipHeader==='+vipHeader);
                 system.debug('isVipChanged==='+isVipChanged);
                 if (vipHeader != '' && isVipChanged == true)
                    lineItem.Phoenix_Proposed_Est_VIP__c = decimal.valueOf(vipHeader);
                if (contractApproval != '' && isApprovalChanged == true) lineItem.Phoenix_Contract_Approval__c = contractApproval;
                if ((lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change' || lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate') && isRebateChanged) {
                    
                    if(lineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c=='BASE/DSH'){
                        lineItem.Phoenix_Current_Rebate__c = lineItem.Phoenix_Bid__r.Phoenix_Rebate__c; 
                    }
                    else{
                        lineItem.Phoenix_Proposed_Current_Rebate__c = lineItem.Phoenix_Bid__r.Phoenix_Rebate__c;
                        
                    }
                    
                }
                /*Product Positions logic*/
                // if (String.isNotBlank(productPositions)) {
                lineItem.Phoenix_Proposed_Position__c = productPositions;
                //}
            }
        }
        update lineList;
        return bid;
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
        query = 'select Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Bid__r.Phoenix_Is_Re_Bid__c,Phoenix_Product__r.Phoenix_WAC__c,Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c,Phoenix_Previous_Bid__r.Name,Phoenix_Previous_LineItem__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
        list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);
        system.debug('quoteList--->' + quoteList); 
        String currentUser = [SELECT id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].Name;
        system.debug('currentUser--->' + currentUser);
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
        System.debug('delegatedUsers--->'+delegatedUsers);
        //End for Delegation
        for (Phoenix_Bid_Line_Item__c lineItem: quoteList) {
            if(lineItem.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Draft'){
                lineItem.Phoenix_Lowest_Price_SKU1__c = lineItem.Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c;
                lineItem.Phoenix_WAC1__c = lineItem.Phoenix_Product__r.Phoenix_WAC__c; 
            }
            if(lineItem.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'SCM & Marketing' || lineItem.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Marketing' ){
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
    public static void getselectOptions(sObject objObject, string fld) {}
    @AuraEnabled
    public static void deleteLineItems(String LineItemId) {
        if (LineItemId != null) {
            Phoenix_Bid_Line_Item__c deletedLineItem = [SELECT Id FROM Phoenix_Bid_Line_Item__c WHERE Id =: LineItemId];
            delete deletedLineItem;
        }
    }
    @AuraEnabled
    public static Phoenix_Bid_Line_Item__c getCalcs(Phoenix_Bid_Line_Item__c LineItem, Id LineItemId, string currentValue, string fieldLabel) {
        Phoenix_Bid_Line_Item__c beforeUpdateLineItem = [SELECT Id, Phoenix_Wholesaler_Guidance_Price__c, Phoenix_Retail_Direct_Sales_Price__c, Phoenix_Bid_Template_Refrence__c, Phoenix_ProposedContractBidPriceMktng__c, Phoenix_Retail_Direct_Guidance_Price__c, Phoenix_Retail_Direct_Price__c, Phoenix_Retail_Indirect_Price__c, Phoenix_Marketing_Approval__c, Phoenix_Guidance_Price__c,Phoenix_Bid__r.Phoenix_Reference_Contracts__c FROM Phoenix_Bid_Line_Item__c WHERE Id =: LineItem.Id];
        if (currentValue != 'No Change' && fieldLabel == 'rebateType') {
            LineItem.Phoenix_Rebate_G_N__c = currentValue;
        }
        if (currentValue != 'No Change' && fieldLabel == 'feeType') {
            LineItem.Phoenix_Fee_G_N__c = currentValue;
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
        
        
        
        
        if (beforeUpdateLineItem.Phoenix_Bid_Template_Refrence__c == 'RXSS') {
            
            if ((LineItem.Phoenix_Retail_Direct_Price__c != null && LineItem.Phoenix_Retail_Direct_Price__c > 0) && (LineItem.Phoenix_Retail_Indirect_Price__c != null && LineItem.Phoenix_Retail_Indirect_Price__c > 0)) {
                system.debug('true in retail direct');
                if(beforeUpdateLineItem.Phoenix_Marketing_Approval__c ==null)
                    LineItem.Phoenix_Marketing_Approval__c = 'Approved';
                
            }
            
            if(LineItem.Phoenix_Retail_Direct_Guidance_Price__c != null && LineItem.Phoenix_Retail_Direct_Sales_Price__c == null){ 
                
                LineItem.Phoenix_Retail_Direct_Sales_Price__c = LineItem.Phoenix_Retail_Direct_Guidance_Price__c;
            }
            
            if(LineItem.Phoenix_Wholesaler_Guidance_Price__c != null && LineItem.Phoenix_Wholesaler_Sales_Price__c == null){
                
                LineItem.Phoenix_Wholesaler_Sales_Price__c = LineItem.Phoenix_Wholesaler_Guidance_Price__c;
            }
            
            
        }  
        
        else if(beforeUpdateLineItem.Phoenix_Bid_Template_Refrence__c=='BASE/DSH'){
            //string contracts = beforeUpdateLineItem.Phoenix_Bid__r.Phoenix_Reference_Contracts__c;
            //list<string>ContractList=contracts.split(',');
            if((LineItem.Phoenix_Retail_Direct_Price__c != null && LineItem.Phoenix_Retail_Direct_Price__c > 0)||(LineItem.Phoenix_Retail_Indirect_Price__c != null &&  LineItem.Phoenix_Retail_Indirect_Price__c > 0)){           
                
                LineItem.Phoenix_Marketing_Approval__c = 'Approved';
                
            }
            
        }
        else{
            
            if (LineItem.Phoenix_ProposedContractBidPriceMktng__c != null && LineItem.Phoenix_ProposedContractBidPriceMktng__c != beforeUpdateLineItem.Phoenix_ProposedContractBidPriceMktng__c && LineItem.Phoenix_ProposedContractBidPriceMktng__c > 0) {
                LineItem.Phoenix_Marketing_Approval__c = 'Approved';
            }
            
            
            
            if (LineItem.Phoenix_Guidance_Price__c != null && LineItem.Phoenix_Guidance_Price__c != beforeUpdateLineItem.Phoenix_Guidance_Price__c && LineItem.Phoenix_ProposedContract_Bid_Price_Sales__c == null) {
                LineItem.Phoenix_ProposedContract_Bid_Price_Sales__c = LineItem.Phoenix_Guidance_Price__c;
            }
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
        query = 'select Phoenix_Previous_LineItem__r.Name,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c, ' + strFields + ' from ' + SobjectApiName + ' where id = :LineItemId limit 1';
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
        query = 'select Phoenix_Previous_LineItem__r.Name,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : lineItemId AND Phoenix_Final_Status__c !=: notApproved';
        if (searchKey != null && searchKey.size() > 0) {
            query = query + ' AND Product_Family_Name__c =: searchKey';
        }
        if (sRxOtcList != null && sRxOtcList.size() > 0) {
            query = query + ' AND Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =: sRxOtcList';
        }
        if (searchPDList != null && searchPDList.size() > 0) {
            query = query + ' AND Phoenix_Product_Director__c =: searchPDList';
        }
        query = query + ' ORDER BY Product_Family_Name__c ASC LIMIT 1000';
        List < Phoenix_Bid_Line_Item__c > lineItemsList = Database.query(query);
        // system.debug(lineItemsList);
        return lineItemsList;
    }
    @AuraEnabled
    public static list < Phoenix_Contract__c > getContracts(string customerID, string searchInput,String templateType) {
        system.debug('customerID---' + customerID);
        string act = 'Active';
        boolean isExcludeContract = false;
        string query;
        if(templateType == 'Econdisc'){
            query = 'select name,Phoenix_Customer__r.Name,Phoenix_Contract_Number__c,Phoenix_Contract_Internal_Description__c,Phoenix_Contract_External_Description__c from Phoenix_Contract__c where Phoenix_Contract_Status__c=:act AND Phoenix_Is_Exclude_Contract__c=:isExcludeContract';
        }else{
            query = 'select name,Phoenix_Customer__r.Name,Phoenix_Contract_Number__c,Phoenix_Contract_Internal_Description__c,Phoenix_Contract_External_Description__c from Phoenix_Contract__c where Phoenix_Contract_Status__c=:act';
        }
        
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
            system.debug('parentAccIds--' + parentAccIds);
            query += ' and (Phoenix_Customer__c=:parentAccIds)'; // or Phoenix_Customer__r.ParentId=:parentAccIds
        }
        if (string.isNotBlank(searchInput)) {
            query += ' and ( name like \'%' + searchInput + '%\' or Phoenix_Contract_Number__c like \'%' + searchInput + '%\' or Phoenix_Customer__r.Name like \'%' + searchInput + '%\' or Phoenix_Contract_Internal_Description__c like \'%' + searchInput + '%\' or Phoenix_Contract_External_Description__c like  \'%' + searchInput + '%\')';
        }
        list < Phoenix_Contract__c > cntList = Database.query(query);
        return cntList;
    }
    @AuraEnabled
    public static list < Phoenix_Product_Position__c > getPositions(string customerID) {
        system.debug('customerID---' + customerID);
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
            // system.debug('parentAccIds--' + parentAccIds);
        }
        //Account bidAccount = [select ParentId, Parent.Name from account where id =: customerID limit 1];
        list < Phoenix_Product_Position__c > positionList = [select Phoenix_Customer__c, Phoenix_Customer__r.Name, Name,Phoenix_Customer__r.ParentId, Phoenix_Group_Name__c, Phoenix_General_Category__c, Phoenix_Position_Comments__c from Phoenix_Product_Position__c]; //where Phoenix_Customer__c=:parentAccIds or Phoenix_Customer__r.ParentId=:parentAccIds];//where Phoenix_Group_Name__c =: bidAccount.Parent.Name];
        list<Phoenix_Product_Position__c> AccountRelatedPositions=new list<Phoenix_Product_Position__c>();
        list<Phoenix_Product_Position__c> OtherPositions=new list<Phoenix_Product_Position__c>();
        for(Phoenix_Product_Position__c pos:positionList){
            if(parentAccIds.contains(pos.Phoenix_Customer__c) ||  parentAccIds.contains(pos.Phoenix_Customer__r.ParentId) || customerID==pos.Phoenix_Customer__c || customerID==pos.Phoenix_Customer__r.ParentId){
                AccountRelatedPositions.add(pos);
            }
            else if(AccountRelatedPositions.size()==0 && pos.Phoenix_Customer__c==null && !parentAccIds.contains(pos.Phoenix_Customer__c) && !parentAccIds.contains(pos.Phoenix_Customer__r.ParentId)){
                OtherPositions.add(pos);
            }
        }
        if(AccountRelatedPositions.size()>0){
            return AccountRelatedPositions;
        }else{
            return  OtherPositions;
        }
        //return positionList;
    }
    @AuraEnabled
    public static void getNPRData(list < string > selectrcs, Id BidId, string templateType) {
        list < Phoenix_Bid_Line_Item__c > bildLines = [select id, name,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Proposed_Cash_Terms__c, Phoenix_Medicaid_Returns_Per_Unit_in__c,Phoenix_Product__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Others_Indirect__c, Phoenix_Others_Direct__c, Phoenix_12_Months_Actual_Sales__c, Phoenix_Current_Position__c, Phoenix_Product__r.Name, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Fee__c, Phoenix_Bid__r.Phoenix_Customer__r.Rebate_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Cash_Discount__c, Phoenix_Bid__r.Phoenix_Customer__r.Fee_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebates__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_VIP__c, Phoenix_Current_Net_Sales_Internal__c, Phoenix_DeadNet_TrckGR__c, Phoenix_Product__r.ProductCode, Phoenix_Current_Direct_Selling_Unit__c, Phoenix_Current_Indirect_Selling_Unit__c, Phoenix_Current_Indirect_Price__c, Phoenix_Current_Direct_Price__c, Phoenix_Current_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Current_Rebate__c, Phoenix_Rebate_G_N__c, Phoenix_Fee_G_N__c, Phoenix_Current_Admin_Fee__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: BidId];
        String bidTye= (bildLines !=null && bildLines.size()>0) ? bildLines[0].Phoenix_Bid__r.Phoenix_Bid_Type__c:'';
        if(bidTye != 'New Product Launch'){
            list < Phoenix_NPR_Data__c > NPRDataLines = [select id, Name, Phoenix_Contract_Type__c, Phoenix_12Months_Actual_Sales_Unit__c, Phoenix_12Mt_Sales_Ut_Actual__c, Phoenix_Product_Position__c, Phoenix_Net_Sales_Internal__c, Phoenix_Dead_Net_Tracking_GR__c, Phoenix_Contract_Price__c, Phoenix_Product__c, Phoenix_Product__r.ProductCode, Phoenix_12Months_Sales_Unit__c, Phoenix_12Months_Net_Sales__c, Phoenix_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Rebate__c, Phoenix_Rebate_G_N_Indicator__c, Phoenix_Bonafied_G_N_Indicator__c, Phoenix_Fee_Bonafied_Fee__c, Phoenix_Per_Unit_Bonfied_Fee__c, Phoenix_CD__c, Phoenix_GR_TrackingTier__c from Phoenix_NPR_Data__c where Phoenix_Contract_Number__c in: selectrcs and Phoenix_NPR_Status__c = 'Active'];
            map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
            for (Phoenix_NPR_Data__c NPRLine: NPRDataLines) {
                if (productCodeToNPRLineMap.containsKey(NPRLine.Phoenix_Product__r.ProductCode)) {
                    productCodeToNPRLineMap.get(NPRLine.Phoenix_Product__r.ProductCode).add(NPRLine);
                } else {
                    list < Phoenix_NPR_Data__c > NPRList = new list < Phoenix_NPR_Data__c > ();
                    NPRList.add(NPRLine);
                    productCodeToNPRLineMap.put(NPRLine.Phoenix_Product__r.ProductCode, NPRList);
                }
            }
            map < Phoenix_Bid_Line_Item__c, list < Phoenix_NPR_Data__c >> bidToNPRMap = new map < Phoenix_Bid_Line_Item__c, list < Phoenix_NPR_Data__c >> ();
            decimal cashDiscount;
            decimal currentVip;
            for (Phoenix_Bid_Line_Item__c bidLine: bildLines) {
                bidLine.Phoenix_Current_Indirect_Selling_Unit__c = 0;
                bidLine.Phoenix_Current_Direct_Selling_Unit__c = 0;
                bidLine.Phoenix_Current_Indirect_Price__c = 0;
                bidLine.Phoenix_Current_Direct_Price__c = 0;
                bidLine.Phoenix_Current_Per_Unit_Rebate__c = 0;
                bidLine.Phoenix_ZITD_Value__c = 0;
                bidLine.Phoenix_12_Months_Actual_Sales__c = 0;
                bidLine.Phoenix_12_Months_IndirectSaleUnit__c = 0;
                bidLine.Finance_Current_Sales__c = 0;
            
            /* if((bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Product Addition' || bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='RFP Bids') && templateType=='Econdisc'){
bidLine.Phoenix_Others_Direct__c=bidLine.Phoenix_Others_Direct__c!=null?bidLine.Phoenix_Others_Direct__c:1;
bidLine.Phoenix_Others_Indirect__c=bidLine.Phoenix_Others_Indirect__c!=null?bidLine.Phoenix_Others_Indirect__c:1;
}     */
                //bidLine.Phoenix_Current_Rebate__c=0;
                //bidLine.Phoenix_Current_Admin_Fee__c=0;
                //bidLine.Phoenix_Rebate_G_N__c='';
                // bidLine.Phoenix_Fee_G_N__c='';
                list < Decimal > directPriceList = new list < Decimal > ();
                list < Decimal > indirectPriceList = new list < Decimal > ();
                list < Decimal > perUnitRebateList = new list < Decimal > ();
                list < Decimal > deadNetTrackList = new list < Decimal > ();
                list < Decimal > NetSalesList = new List < Decimal > ();
                list < Decimal > ZITDList = new List < Decimal > ();
                list < Decimal > RebateList = new List < Decimal > ();
                list < Decimal > VipList = new list < Decimal > ();
                //added by satya on 29/12/2023
                list < Decimal > indirectDeadNet = new List < Decimal > ();
                list < Decimal > directDeadnet = new List < Decimal > ();
                //end by satya on 29/12/2023
                Set < String > currentPositionSet = new Set< String > ();
                if(productCodeToNPRLineMap.keyset().contains(bidLine.Phoenix_Product__r.ProductCode)){
                    bidLine.Phoenix_Current_Position__c = '';
                    
                    for(Phoenix_NPR_Data__c NPRLine:productCodeToNPRLineMap.get(bidLine.Phoenix_Product__r.ProductCode)){
                        system.debug('track tier===='+NPRLine.Phoenix_GR_TrackingTier__c);
                         VipList.add(NPRLine.Phoenix_GR_TrackingTier__c);
                          system.debug('VipList===='+VipList);
                        // bidLine.Phoenix_Current_Position__c = (NPRLine.Phoenix_Product_Position__c != null ?NPRLine.Phoenix_Product_Position__c + ', ' : '' ) + (bidLine.Phoenix_Current_Position__c != null? bidLine.Phoenix_Current_Position__c : '');
                        currentPositionSet.add(NPRLine.Phoenix_Product_Position__c != null ? NPRLine.Phoenix_Product_Position__c + '' : '');
                        if(templateType=='Indirect' || templateType=='Direct and Indirect' || templateType=='Walgreens' || templateType=='ABC Progen' || templateType=='Econdisc' || templateType== 'Costco' || templateType== 'Sams Club' || templateType== 'Net Indirect Pricing' || templateType== 'Government Pricing'){
                            if(NPRLine.Phoenix_Contract_Type__c=='Indirect'){
                                bidLine.Phoenix_Current_Indirect_Selling_Unit__c+=NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                                if(templateType!='Econdisc' && templateType!= 'Net Indirect Pricing'){
                                    bidLine.Phoenix_12_Months_Actual_Sales__c = (bidLine.Phoenix_12_Months_Actual_Sales__c != null ? bidLine.Phoenix_12_Months_Actual_Sales__c : 0) + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                                }
                                bidLine.Phoenix_12_Months_IndirectSaleUnit__c = (bidLine.Phoenix_12_Months_IndirectSaleUnit__c !=null ? bidLine.Phoenix_12_Months_IndirectSaleUnit__c : 0 )+ (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                                //by satya 
                                indirectDeadNet.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);//bidLine.Current_CVS_Indirect_DeadNet__c = NPRLine.Phoenix_Dead_Net_Tracking_GR__c;
                                //end by satya
                                indirectPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                                ZITDList.add(NPRLine.Phoenix_ZITD_Value__c);
                               // VipList.add(NPRLine.Phoenix_GR_TrackingTier__c);
                                //cashDiscount=NPRLine.Phoenix_CD__c;
                                //currentVip=NPRLine.Phoenix_GR_TrackingTier__c;
                            }
                            perUnitRebateList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                            deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
                            NetSalesList.add(NPRLine.Phoenix_Net_Sales_Internal__c);
                            
                            //bidLine.Phoenix_ZITD_Value__c=NPRLine.Phoenix_ZITD_Value__c;
                        //RebateList.add(NPRLine.Phoenix_Rebate__c);
                        //bidLine.Phoenix_Current_Rebate__c=NPRLine.Phoenix_Rebate__c;
                        //bidLine.Phoenix_Current_Admin_Fee__c=NPRLine.Phoenix_Fee_Bonafied_Fee__c;
                        // if(string.isNotBlank(NPRLine.Phoenix_Rebate_G_N_Indicator__c)){
                        // string rbInd=NPRLine.Phoenix_Rebate_G_N_Indicator__c.deleteWhitespace();
                        // decimal Net=decimal.valueOf(rbInd.substringBefore('N'));
                        // decimal Gross=decimal.valueOf(rbInd.substringBetween('+','G'));
                        // bidLine.Phoenix_Rebate_G_N__c=Gross==0?'Net':'Gross';
                        // }
                        //if(string.isNotBlank(NPRLine.Phoenix_Bonafied_G_N_Indicator__c)){
                        //  string bnFInd=NPRLine.Phoenix_Bonafied_G_N_Indicator__c.deleteWhitespace();
                        // decimal Net=decimal.valueOf(bnFInd.substringBefore('N'));
                        // decimal Gross=decimal.valueOf(bnFInd.substringBetween('+','G'));
                        //bidLine.Phoenix_Fee_G_N__c=Gross==0?'Net':'Gross';
                        // }
                    }
                    /* if(templateType=='Indirect' || templateType=='Direct and Indirect' || templateType=='Costco'){
if(NPRLine.Phoenix_Contract_Type__c=='Indirect'){
bidLine.Phoenix_Current_Indirect_Selling_Unit__c+=NPRLine.Phoenix_SalesUnit_90__c != null ? NPRLine.Phoenix_SalesUnit_90__c : 0;
bidLine.Phoenix_12_Months_Actual_Sales__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
indirectPriceList.add(NPRLine.Phoenix_Contract_Price__c);

}
perUnitRebateList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
NetSalesList.add(NPRLine.Phoenix_Net_Sales_Internal__c);
ZITDList.add(NPRLine.Phoenix_ZITD_Value__c);
}*/
                        if (templateType == 'Direct' || templateType == 'Direct and Indirect' || templateType == 'Econdisc' || templateType == 'Net Indirect Pricing') {
                            if (NPRLine.Phoenix_Contract_Type__c == 'Direct') {
                                bidLine.Phoenix_Current_Direct_Selling_Unit__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                                bidLine.Phoenix_12_Months_Actual_Sales__c = (bidLine.Phoenix_12_Months_Actual_Sales__c != null ? bidLine.Phoenix_12_Months_Actual_Sales__c : 0) + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                                directPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                                //by satya
                                directDeadnet.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c); //bidLine.Current_CVS_DeadNet__c = NPRLine.Phoenix_Dead_Net_Tracking_GR__c;
                                //end by satya
                                // cashDiscount=NPRLine.Phoenix_CD__c;
                                // currentVip=NPRLine.Phoenix_GR_TrackingTier__c;
                            }
                            perUnitRebateList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                            deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
                            NetSalesList.add(NPRLine.Phoenix_Net_Sales_Internal__c);
                            ZITDList.add(NPRLine.Phoenix_ZITD_Value__c);
                           // VipList.add(NPRLine.Phoenix_GR_TrackingTier__c);
                            // bidLine.Phoenix_ZITD_Value__c=NPRLine.Phoenix_ZITD_Value__c;
                        // RebateList.add(NPRLine.Phoenix_Rebate__c);
                        // bidLine.Phoenix_Current_Rebate__c=NPRLine.Phoenix_Rebate__c;
                        //bidLine.Phoenix_Current_Admin_Fee__c=NPRLine.Phoenix_Fee_Bonafied_Fee__c;
                        // if(string.isNotBlank(NPRLine.Phoenix_Rebate_G_N_Indicator__c)){
                        //  string rbInd=NPRLine.Phoenix_Rebate_G_N_Indicator__c.deleteWhitespace();
                        // decimal Net=decimal.valueOf(rbInd.substringBefore('N'));
                        // decimal Gross=decimal.valueOf(rbInd.substringBetween('+','G'));
                        // bidLine.Phoenix_Rebate_G_N__c=Gross==0?'Net':'Gross';
                        //}
                        //if(string.isNotBlank(NPRLine.Phoenix_Bonafied_G_N_Indicator__c)){
                        //   string bnFInd=NPRLine.Phoenix_Bonafied_G_N_Indicator__c.deleteWhitespace();
                        // decimal Net=decimal.valueOf(bnFInd.substringBefore('N'));
                        // decimal Gross=decimal.valueOf(bnFInd.substringBetween('+','G'));
                        // bidLine.Phoenix_Fee_G_N__c=Gross==0?'Net':'Gross';
                        //}
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
                if( currentPositionSet.size() >0 ) {
                    List<String> currentPositionList = new List<String>(currentPositionSet);
                    bidLine.Phoenix_Current_Position__c = string.join(currentPositionList, ', ');
                }
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
                 //take Max of all  VIP
                    if (!VipList.isEmpty()) {
                        VipList.sort();
                        system.debug('VipList sort=='+VipList);
                        system.debug('templateType=='+templateType);
                        system.debug('vip=='+VipList[VipList.size() - 1]);
                            bidLine.Phoenix_Proposed_Est_VIP__c = VipList[VipList.size() - 1];      
                    }
                    //take Max of all  NPR rebate
                    if (perUnitRebateList.size() > 0) {
                        perUnitRebateList.sort();
                        bidLine.Phoenix_Current_Per_Unit_Rebate__c = perUnitRebateList[perUnitRebateList.size() - 1];
                        bidLine.Phoenix_Proposed_Per_Unit_Rebate__c = perUnitRebateList[perUnitRebateList.size() - 1];
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
                    
                //if(RebateList.size()>0){
                // RebateList.sort();
                //bidLine.Phoenix_Current_Rebate__c=RebateList[RebateList.size()-1];
                //bidLine.Phoenix_Proposed_Current_Rebate__c=RebateList[RebateList.size()-1];
                // }
            } else {
                      
                    bidLine.Phoenix_Proposed_Est_VIP__c = bidLine.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c;
                //bidLine.Phoenix_Current_Admin_Fee__c=bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Fee__c;
                //bidLine.Phoenix_Current_Rebate__c=bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebates__c;
                //bidLine.Phoenix_Proposed_Current_Rebate__c=bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebates__c;
                //currentVip=currentVip!=null?currentVip:bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_VIP__c;
                //cashDiscount=cashDiscount!=null?cashDiscount:bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Cash_Discount__c;
                //bidLine.Phoenix_Rebate_G_N__c=bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Rebate_Type__c;
                //bidLine.Phoenix_Fee_G_N__c=bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Fee_Type__c;
            }
        }
        // cashDiscount = currentCd != null ? currentCd : cashDiscount;
        //system.debug('cashDiscount'+cashDiscount);
        //system.debug('currentVip'+currentVip);
        /*Phoenix_Bid__c bid=new Phoenix_Bid__c(id=bidid,Phoenix_Current_CD__c=cashDiscount,Phoenix_Current_Value_Est_VIP__c=currentVip,Phoenix_Proposed_Value_Est_VIP__c=currentVip);
update bid;*/
        //system.debug('finalbidlines--'+bildLines);
        update bildLines;
    }
    }
    
    @AuraEnabled
    public static void getNPRDataABCPharmagen(list < string > selectrcs, Id BidId, string templateType) {
        list < Phoenix_Bid_Line_Item__c > bildLines = [select id, name, Finance_Current_Sales__c,Phoenix_Medicaid_Returns_Per_Unit_in__c,Phoenix_Product__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Others_Indirect__c, Phoenix_Others_Direct__c, Phoenix_12_Months_Actual_Sales__c, Phoenix_Current_Position__c, Phoenix_Product__r.Name, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Fee__c, Phoenix_Bid__r.Phoenix_Customer__r.Rebate_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Cash_Discount__c, Phoenix_Bid__r.Phoenix_Customer__r.Fee_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebates__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_VIP__c, Phoenix_Current_Net_Sales_Internal__c, Phoenix_DeadNet_TrckGR__c, Phoenix_Product__r.ProductCode, Phoenix_Current_Direct_Selling_Unit__c, Phoenix_Current_Indirect_Selling_Unit__c, Phoenix_Current_Indirect_Price__c, Phoenix_Current_Direct_Price__c, Phoenix_Current_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Current_Rebate__c, Phoenix_Rebate_G_N__c, Phoenix_Fee_G_N__c, Phoenix_Current_Admin_Fee__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: BidId];
        String bidTye= (bildLines !=null && bildLines.size()>0) ? bildLines[0].Phoenix_Bid__r.Phoenix_Bid_Type__c:'';
        //if(bidTye != 'New Product Launch'){
        list < Phoenix_NPR_Data__c > NPRDataLines = [select id, Name, Phoenix_Contract_Type__c, Phoenix_Contract_Number__c,Phoenix_12Months_Actual_Sales_Unit__c, Phoenix_12Mt_Sales_Ut_Actual__c, Phoenix_Product_Position__c, Phoenix_Net_Sales_Internal__c, Phoenix_Dead_Net_Tracking_GR__c, Phoenix_Contract_Price__c, Phoenix_Product__c, Phoenix_Product__r.ProductCode, Phoenix_12Months_Sales_Unit__c, Phoenix_12Months_Net_Sales__c, Phoenix_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Rebate__c, Phoenix_Rebate_G_N_Indicator__c, Phoenix_Bonafied_G_N_Indicator__c, Phoenix_Fee_Bonafied_Fee__c, Phoenix_Per_Unit_Bonfied_Fee__c, Phoenix_CD__c, Phoenix_GR_TrackingTier__c from Phoenix_NPR_Data__c where Phoenix_Contract_Number__c in: selectrcs and Phoenix_NPR_Status__c = 'Active'];
        map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
        for (Phoenix_NPR_Data__c NPRLine: NPRDataLines) {
            if (productCodeToNPRLineMap.containsKey(NPRLine.Phoenix_Product__r.ProductCode)) {
                productCodeToNPRLineMap.get(NPRLine.Phoenix_Product__r.ProductCode).add(NPRLine);
            } else {
                list < Phoenix_NPR_Data__c > NPRList = new list < Phoenix_NPR_Data__c > ();
                NPRList.add(NPRLine);
                productCodeToNPRLineMap.put(NPRLine.Phoenix_Product__r.ProductCode, NPRList);
            }
        }
        map < Phoenix_Bid_Line_Item__c, list < Phoenix_NPR_Data__c >> bidToNPRMap = new map < Phoenix_Bid_Line_Item__c, list < Phoenix_NPR_Data__c >> ();
        decimal cashDiscount;
        decimal currentVip;
        for (Phoenix_Bid_Line_Item__c bidLine: bildLines) {
            bidLine.Phoenix_Current_Indirect_Selling_Unit__c = 0;
            bidLine.Phoenix_Current_Wholesaler_Price__c = 0;
            bidLine.Phoenix_Current_Direct_Selling_Unit__c = 0;
            bidLine.Phoenix_Current_Indirect_Price__c = 0;
            bidLine.Phoenix_Current_Direct_Price__c = 0;
            bidLine.Phoenix_Current_Per_Unit_Rebate__c = 0;
            bidLine.Phoenix_ZITD_Value__c = 0;
            bidLine.Phoenix_12_Months_Actual_Sales__c = 0;
            
            list < Decimal > directPriceList = new list < Decimal > ();
            list < Decimal > indirectPriceList = new list < Decimal > ();
            list < Decimal > abcindirectPriceList = new list < Decimal > ();
            list < Decimal > perUnitRebateList = new list < Decimal > ();
            list < Decimal > deadNetTrackList = new list < Decimal > ();
            list < Decimal > NetSalesList = new List < Decimal > ();
            list < Decimal > ZITDList = new List < Decimal > ();
            list < Decimal > RebateList = new List < Decimal > ();
            //by satya
            list < Decimal > indirectDeadNet = new List < Decimal > ();
            list < Decimal > directDeadnet = new List < Decimal > ();
            //end by satya
            Set < String > currentPositionSet = new Set< String > ();
            Set < String > currentPositionSet2 = new Set< String > ();
            if (productCodeToNPRLineMap.keyset().contains(bidLine.Phoenix_Product__r.ProductCode)) {
                bidLine.Phoenix_Current_Position__c = '';
                bidLine.Phoenix_Current_MCK_Position__c = '';
                for (Phoenix_NPR_Data__c NPRLine: productCodeToNPRLineMap.get(bidLine.Phoenix_Product__r.ProductCode)) {
                    if (templateType == 'ABC Pharmagen') {
                        if (NPRLine.Phoenix_Contract_Type__c == 'Indirect') {
                            //for Pharmagen prices
                            if(bidTye != 'New Product Launch'){
                                if (NPRLine.Phoenix_Contract_Number__c == '3000000957') {
                                    
                                    bidLine.Phoenix_Current_Indirect_Selling_Unit__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                                    bidLine.Phoenix_12_Months_Actual_Sales__c = (bidLine.Phoenix_12_Months_Actual_Sales__c != null ? bidLine.Phoenix_12_Months_Actual_Sales__c : 0) + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                                    
                                    indirectPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                                    //bidLine.Phoenix_Current_Position__c = (NPRLine.Phoenix_Product_Position__c != null ? NPRLine.Phoenix_Product_Position__c + ', ' : '') + (bidLine.Phoenix_Current_Position__c != null ? bidLine.Phoenix_Current_Position__c : '');
                                    currentPositionSet.add(NPRLine.Phoenix_Product_Position__c != null ? NPRLine.Phoenix_Product_Position__c + '' : '');
                                    //by satya
                                   	directDeadnet.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c); // bidLine.Current_CVS_DeadNet__c= NPRLine.Phoenix_Dead_Net_Tracking_GR__c!= NULL? NPRLine.Phoenix_Dead_Net_Tracking_GR__c:0;
                                    //end by satya
                                    bidLine.Finance_Current_Sales__c += (NPRLine.Phoenix_12Months_Sales_Unit__c * NPRLine.Phoenix_Dead_Net_Tracking_GR__c) - (bidLine.Phoenix_Medicaid_Returns_Per_Unit_in__c * NPRLine.Phoenix_12Months_Sales_Unit__c);// New Line added by satya for Currentsales NDC View
                                }
                            }
                            //for ABC Progen price
                            if (NPRLine.Phoenix_Contract_Number__c == '3000000551') {
                                
                                abcindirectPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                                //bidLine.Phoenix_Current_MCK_Position__c = (NPRLine.Phoenix_Product_Position__c != null ? NPRLine.Phoenix_Product_Position__c + ', ' : '') + (bidLine.Phoenix_Current_MCK_Position__c != null ? bidLine.Phoenix_Current_MCK_Position__c : '');
                                currentPositionSet2.add(NPRLine.Phoenix_Product_Position__c != null ? NPRLine.Phoenix_Product_Position__c + '' : '');
                            }
                            
                            
                            ZITDList.add(NPRLine.Phoenix_ZITD_Value__c);
                            //cashDiscount=NPRLine.Phoenix_CD__c;
                            //currentVip=NPRLine.Phoenix_GR_TrackingTier__c;
                        }
                        perUnitRebateList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                        deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
                        NetSalesList.add(NPRLine.Phoenix_Net_Sales_Internal__c);
                        
                        
                    }
                    
                    
                }
                //by satya
                 if(directDeadnet.size() > 0){
                        directDeadnet.sort();
                        bidLine.Current_CVS_DeadNet__c = directDeadnet[0];
                    }
                //end by satya
                if( currentPositionSet.size() >0 ) {
                    List<String> currentPositionList = new List<String>(currentPositionSet);
                    bidLine.Phoenix_Current_Position__c = string.join(currentPositionList, ', ');
                }
                if( currentPositionSet2.size() >0 ) {
                    List<String> currentPositionList2 = new List<String>(currentPositionSet2);
                    bidLine.Phoenix_Current_MCK_Position__c = string.join(currentPositionList2, ', ');
                }
                //take minimum of all indeirect NPR prices
                if (indirectPriceList.size() > 0) {
                    indirectPriceList.sort();
                    bidLine.Phoenix_Current_Indirect_Price__c = indirectPriceList[0];
                }
                //take minimum of all indeirect NPR prices
                if (abcindirectPriceList.size() > 0) {
                    abcindirectPriceList.sort();
                    bidLine.Phoenix_Current_Wholesaler_Price__c = abcindirectPriceList[0];
                }
                //take minimum of all deirect NPR prices
                if (directPriceList.size() > 0) {
                    directPriceList.sort();
                    bidLine.Phoenix_Current_Direct_Price__c = directPriceList[0];
                }
                //take Max of all  NPR rebate
                if (perUnitRebateList.size() > 0) {
                    perUnitRebateList.sort();
                    bidLine.Phoenix_Current_Per_Unit_Rebate__c = perUnitRebateList[perUnitRebateList.size() - 1];
                    bidLine.Phoenix_Proposed_Per_Unit_Rebate__c = perUnitRebateList[perUnitRebateList.size() - 1];
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
                //if(RebateList.size()>0){
                // RebateList.sort();
                //bidLine.Phoenix_Current_Rebate__c=RebateList[RebateList.size()-1];
                //bidLine.Phoenix_Proposed_Current_Rebate__c=RebateList[RebateList.size()-1];
                // }
            } else {
                //bidLine.Phoenix_Current_Admin_Fee__c=bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Fee__c;
                //bidLine.Phoenix_Current_Rebate__c=bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebates__c;
                //bidLine.Phoenix_Proposed_Current_Rebate__c=bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebates__c;
                //currentVip=currentVip!=null?currentVip:bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_VIP__c;
                //cashDiscount=cashDiscount!=null?cashDiscount:bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Cash_Discount__c;
                //bidLine.Phoenix_Rebate_G_N__c=bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Rebate_Type__c;
                //bidLine.Phoenix_Fee_G_N__c=bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Fee_Type__c;
            }
        }
        //  cashDiscount = currentCd != null ? currentCd : cashDiscount;
        //system.debug('cashDiscount'+cashDiscount);
        //system.debug('currentVip'+currentVip);
        //Phoenix_Bid__c bid=new Phoenix_Bid__c(id=bidid,Phoenix_Current_CD__c=cashDiscount,Phoenix_Current_Value_Est_VIP__c=currentVip,Phoenix_Proposed_Value_Est_VIP__c=currentVip);
        //update bid;
        //system.debug('finalbidlines--'+bildLines);
        update bildLines;
        
        //}
    }
    @AuraEnabled
    public static void getNPRDataRXSS(list < string > selectrcs, Id BidId, string templateType) {
        list < Phoenix_Bid_Line_Item__c > bildLines = [select id,Finance_Current_Sales__c, Phoenix_Medicaid_Returns_Per_Unit_in__c,Phoenix_Current_Retail_Direct_Price__c, Phoenix_Current_Anda_Invoice_Price__c, Phoenix_Current_Retail_Indirect_Price__c, Phoenix_Current_Wholesaler_Price__c, Phoenix_Current_Anda_CP_Price__c, Phoenix_Current_Wholesaler_Units__c, Phoenix_Current_Anda_Net_Model_Units__c, Phoenix_Current_Retail_Direct_Units__c, Phoenix_Current_Indirect_Gaint_EagleUnit__c, Phoenix_Current_Anda_Units__c, Phoenix_Current_Retail_Indirect_Units__c, name, Phoenix_Product__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Current_CD__c, Phoenix_Others_Indirect__c, Phoenix_Others_Direct__c, Phoenix_12_Months_Actual_Sales__c, Phoenix_Current_Position__c, Phoenix_Product__r.Name, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Fee__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Customer__r.Rebate_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Cash_Discount__c, Phoenix_Bid__r.Phoenix_Customer__r.Fee_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebates__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_VIP__c, Phoenix_Current_Net_Sales_Internal__c, Phoenix_DeadNet_TrckGR__c, Phoenix_Product__r.ProductCode, Phoenix_Current_Direct_Selling_Unit__c, Phoenix_Current_Indirect_Selling_Unit__c, Phoenix_Current_Indirect_Price__c, Phoenix_Current_Direct_Price__c, Phoenix_Current_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Current_Rebate__c, Phoenix_Rebate_G_N__c, Phoenix_Fee_G_N__c, Phoenix_Current_Admin_Fee__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: BidId];
        String bidTye= (bildLines !=null && bildLines.size()>0) ? bildLines[0].Phoenix_Bid__r.Phoenix_Bid_Type__c:'';
        if(bidTye != 'New Product Launch'){
            list < Phoenix_NPR_Data__c > NPRDataLines = [select id, Name, Phoenix_Contract_Type__c, Phoenix_Contract_Number__c, Phoenix_12Months_Actual_Sales_Unit__c, Phoenix_12Mt_Sales_Ut_Actual__c, Phoenix_Product_Position__c, Phoenix_Net_Sales_Internal__c, Phoenix_Dead_Net_Tracking_GR__c, Phoenix_Contract_Price__c, Phoenix_Product__c, Phoenix_Product__r.ProductCode, Phoenix_12Months_Sales_Unit__c, Phoenix_12Months_Net_Sales__c, Phoenix_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Rebate__c, Phoenix_Rebate_G_N_Indicator__c, Phoenix_Bonafied_G_N_Indicator__c, Phoenix_Fee_Bonafied_Fee__c, Phoenix_Per_Unit_Bonfied_Fee__c, Phoenix_CD__c, Phoenix_GR_TrackingTier__c from Phoenix_NPR_Data__c where Phoenix_Contract_Number__c in: selectrcs and Phoenix_NPR_Status__c = 'Active'];
            map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
            for (Phoenix_NPR_Data__c NPRLine: NPRDataLines) {
                if (productCodeToNPRLineMap.containsKey(NPRLine.Phoenix_Product__r.ProductCode)) {
                    productCodeToNPRLineMap.get(NPRLine.Phoenix_Product__r.ProductCode).add(NPRLine);
                } else {
                    list < Phoenix_NPR_Data__c > NPRList = new list < Phoenix_NPR_Data__c > ();
                    NPRList.add(NPRLine);
                    productCodeToNPRLineMap.put(NPRLine.Phoenix_Product__r.ProductCode, NPRList);
                }
            }
            map < Phoenix_Bid_Line_Item__c, list < Phoenix_NPR_Data__c >> bidToNPRMap = new map < Phoenix_Bid_Line_Item__c, list < Phoenix_NPR_Data__c >> ();
            decimal cashDiscount;
            decimal currentVip;
            for (Phoenix_Bid_Line_Item__c bidLine: bildLines) {
                bidLine.Phoenix_Current_Indirect_Selling_Unit__c = 0;
                bidLine.Phoenix_Current_Direct_Selling_Unit__c = 0;
                bidLine.Phoenix_Current_Indirect_Price__c = 0;
                bidLine.Phoenix_Current_Direct_Price__c = 0;
                
                bidLine.Phoenix_Current_Per_Unit_Rebate__c = 0;
                bidLine.Phoenix_Proposed_Per_Unit_Rebate__c = 0;
                bidLine.Phoenix_ZITD_Value__c = 0;
                bidLine.Phoenix_DeadNet_TrckGR__c=0;
                bidLine.Phoenix_12_Months_Actual_Sales__c = 0;
                bidLine.Phoenix_Current_Wholesaler_Units__c = 0;
                bidLine.Phoenix_Current_Anda_Units__c = 0;
                bidLine.Phoenix_Current_Retail_Indirect_Units__c = 0;
                bidLine.Phoenix_Current_Retail_Direct_Units__c = 0;
                bidLine.Finance_Current_Sales__c=0;
                bidLine.Phoenix_Current_Retail_Direct_Price__c=0;
                // bidLine.Phoenix_Current_Anda_Invoice_Price__c=0;
                bidLine.Phoenix_Current_Retail_Indirect_Price__c=0;
                //bidLine.Phoenix_Current_Wholesaler_Price__c=0;
                //bidLine.Phoenix_Current_Anda_CP_Price__c=0;
                //bidLine.Phoenix_Current_Anda_Net_Model_Units__c=0;
            
                list < Decimal > retaildirectPriceList = new list < Decimal > ();
                list < Decimal > andadirectPriceList = new list < Decimal > ();
                list < Decimal > retailindirectPriceList = new list < Decimal > ();
                list < Decimal > wholesalerindirectPriceList = new list < Decimal > ();
                list < Decimal > andaCPindirectPriceList = new list < Decimal > ();
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
                Set < String > currentPositionSet = new Set< String > ();
                if (productCodeToNPRLineMap.keyset().contains(bidLine.Phoenix_Product__r.ProductCode)) {
                    bidLine.Phoenix_Current_Position__c = '';
                    for (Phoenix_NPR_Data__c NPRLine: productCodeToNPRLineMap.get(bidLine.Phoenix_Product__r.ProductCode)) {
                        // bidLine.Phoenix_Current_Position__c = (NPRLine.Phoenix_Product_Position__c != null ? NPRLine.Phoenix_Product_Position__c + ', ' : '') + (bidLine.Phoenix_Current_Position__c != null ? bidLine.Phoenix_Current_Position__c : '');
                        currentPositionSet.add(NPRLine.Phoenix_Product_Position__c != null ? NPRLine.Phoenix_Product_Position__c + '' : '');
                        
                        if (templateType == 'RXSS') {
                            if (NPRLine.Phoenix_Contract_Number__c != '1000000870' && NPRLine.Phoenix_Contract_Number__c != '1000000910') {
                                bidLine.Phoenix_12_Months_Actual_Sales__c = (bidLine.Phoenix_12_Months_Actual_Sales__c != null ? bidLine.Phoenix_12_Months_Actual_Sales__c : 0) + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                            }
                            if (NPRLine.Phoenix_Contract_Type__c == 'Indirect') {
                                if (NPRLine.Phoenix_Contract_Number__c == '3000000733') {
                                    //by satya
                                    directDeadnet.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);//bidLine.Current_CVS_DeadNet__c = NPRLine.Phoenix_Dead_Net_Tracking_GR__c; //Wholesaler
                                    //end by satya
                                    bidLine.Phoenix_Current_Wholesaler_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                                    
                                    wholesalerindirectPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                                    Decimal currentWholeSalerUnits = (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                                    Decimal deadNetTracker = (NPRLine.Phoenix_Dead_Net_Tracking_GR__c !=null ? NPRLine.Phoenix_Dead_Net_Tracking_GR__c:0);
                                    bidLine.Finance_Current_Sales__c += ((currentWholeSalerUnits*deadNetTracker)- (currentWholeSalerUnits *bidLine.Phoenix_Medicaid_Returns_Per_Unit_in__c));
                                    system.debug('product--->'+bidLine.Phoenix_Product__r.ProductCode+'--currentWholeSalerUnits-->'+currentWholeSalerUnits+'--deadNetTracker-->'+deadNetTracker+'--Sales--->'+bidLine.Finance_Current_Sales__c);                                
                                    
                                }
                                if (NPRLine.Phoenix_Contract_Number__c == '3000001332') {
                                    //by satya
                                    indirectDeadNet.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);//bidLine.Current_CVS_Indirect_DeadNet__c = NPRLine.Phoenix_Dead_Net_Tracking_GR__c; //Anda
                                    //end by satya
                                    bidLine.Phoenix_Current_Anda_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                                    Decimal currentAndaUnits = (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                                    Decimal deadNetTracker = (NPRLine.Phoenix_Dead_Net_Tracking_GR__c !=null ? NPRLine.Phoenix_Dead_Net_Tracking_GR__c:0);
                                    bidLine.Finance_Current_Sales__c += ((currentAndaUnits*deadNetTracker)- (currentAndaUnits *bidLine.Phoenix_Medicaid_Returns_Per_Unit_in__c));
                                    system.debug('product--->'+bidLine.Phoenix_Product__r.ProductCode+'--currentAndaUnits-->'+currentAndaUnits+'--deadNetTracker-->'+deadNetTracker+'--Sales--->'+bidLine.Finance_Current_Sales__c);
                                    andaCPindirectPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                                }
                                if (NPRLine.Phoenix_Contract_Number__c == '3000000734' || NPRLine.Phoenix_Contract_Number__c == '3000001173') {
                                    
                                    bidLine.Current_Cardinal_DeadNet__c = NPRLine.Phoenix_Dead_Net_Tracking_GR__c; // Retail Indirect
                                    bidLine.Phoenix_Current_Retail_Indirect_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                                    Decimal currentWholeSalerUnits = (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                                    Decimal deadNetTracker = (NPRLine.Phoenix_Dead_Net_Tracking_GR__c !=null ? NPRLine.Phoenix_Dead_Net_Tracking_GR__c:0);
                                    bidLine.Finance_Current_Sales__c += ((currentWholeSalerUnits*deadNetTracker)- (currentWholeSalerUnits *bidLine.Phoenix_Medicaid_Returns_Per_Unit_in__c));
                                    system.debug('product--->'+bidLine.Phoenix_Product__r.ProductCode+'--currentRINdUnits-->'+currentWholeSalerUnits+'--deadNetTracker-->'+deadNetTracker+'--Sales--->'+bidLine.Finance_Current_Sales__c);
                                    retailindirectPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                                }
                                
                                
                                
                            }
                            if (NPRLine.Phoenix_Contract_Type__c == 'Direct') {
                                if (NPRLine.Phoenix_Contract_Number__c == '1000000627') {
                                    
                                    bidLine.Current_Major_DeadNet__c = NPRLine.Phoenix_Dead_Net_Tracking_GR__c;
                                    bidLine.Phoenix_Current_Retail_Direct_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                                    
                                    Decimal currentRetailDirectUnits = (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                                    Decimal deadNetTracker = (NPRLine.Phoenix_Dead_Net_Tracking_GR__c !=null ? NPRLine.Phoenix_Dead_Net_Tracking_GR__c:0);
                                    bidLine.Finance_Current_Sales__c += ((currentRetailDirectUnits*deadNetTracker)- (currentRetailDirectUnits *bidLine.Phoenix_Medicaid_Returns_Per_Unit_in__c));
                                    system.debug('product--->'+bidLine.Phoenix_Product__r.ProductCode+'--currentRetailDirectUnits-->'+currentRetailDirectUnits+'--deadNetTracker-->'+deadNetTracker+'--Sales--->'+bidLine.Finance_Current_Sales__c);
                                    retaildirectPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                                    
                                }
                                if (NPRLine.Phoenix_Contract_Number__c == '1000000870' || NPRLine.Phoenix_Contract_Number__c == '1000000910') {
                                    
                                    bidLine.Current_Major_DeadNet__c = NPRLine.Phoenix_Dead_Net_Tracking_GR__c;
                                    //bidLine.Phoenix_Current_Anda_Net_Model_Units__c+=NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                                    
                                    andadirectPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                                    system.debug('bidLine.Phoenix_Current_Anda_Net_Model_Units__c-----' + bidLine.Phoenix_Current_Anda_Net_Model_Units__c);
                                }
                            }
                            perUnitRebateList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                            deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
                            ZITDList.add(NPRLine.Phoenix_ZITD_Value__c);
                            VipList.add(NPRLine.Phoenix_GR_TrackingTier__c);     

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
                if( currentPositionSet.size() >0 ) {
                    List<String> currentPositionList = new List<String>(currentPositionSet);
                    bidLine.Phoenix_Current_Position__c = string.join(currentPositionList, ', ');
                }
                //take minimum of all indeirect NPR prices
                if (retaildirectPriceList.size() > 0) {
                    retaildirectPriceList.sort();
                    bidLine.Phoenix_Current_Retail_Direct_Price__c = retaildirectPriceList[0];
                }
                  //take Max of all  VIP
                    if (!VipList.isEmpty()) {
                        VipList.sort();
                        bidLine.Phoenix_Proposed_Est_VIP__c = VipList[VipList.size() - 1];
                    }
                    //take minimum of all deirect NPR prices
                    if (andadirectPriceList.size() > 0) {
                        andadirectPriceList.sort();
                        //bidLine.Phoenix_Current_Anda_Invoice_Price__c = andadirectPriceList[0];
                    }
                    if (retailindirectPriceList.size() > 0) {
                        retailindirectPriceList.sort();
                        bidLine.Phoenix_Current_Retail_Indirect_Price__c = retailindirectPriceList[0];
                    }
                    //take minimum of all deirect NPR prices
                    if (wholesalerindirectPriceList.size() > 0) {
                        wholesalerindirectPriceList.sort();
                        //bidLine.Phoenix_Current_Wholesaler_Price__c = wholesalerindirectPriceList[0];
                    }
                    if (andaCPindirectPriceList.size() > 0) {
                        andaCPindirectPriceList.sort();
                        //bidLine.Phoenix_Current_Anda_CP_Price__c = andaCPindirectPriceList[0];
                    }
                    
                    //take Max of all  NPR rebate
                    if (perUnitRebateList.size() > 0) {
                        perUnitRebateList.sort();
                        bidLine.Phoenix_Current_Per_Unit_Rebate__c = perUnitRebateList[perUnitRebateList.size() - 1];
                        bidLine.Phoenix_Proposed_Per_Unit_Rebate__c = perUnitRebateList[perUnitRebateList.size() - 1];
                    }
                    //take minimum of all  NPR Dead net track
                    if (deadNetTrackList.size() > 0) {
                        deadNetTrackList.sort();
                        bidLine.Phoenix_DeadNet_TrckGR__c = deadNetTrackList[0];
                    }
                    
                    //take minimum of all zitd sales internal
                    if (ZITDList.size() > 0) {
                        ZITDList.sort();
                        bidLine.Phoenix_ZITD_Value__c = ZITDList[0];
                    }
                
                } else {
              bidLine.Phoenix_Proposed_Est_VIP__c = bidLine.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c;  
            }
        }
        
        update bildLines;
    }
    	}
    @AuraEnabled
    public static void getNPRDataDSH(list < string > selectrcs, Id BidId, string templateType) {
        system.debug('selectrcs--------' + selectrcs);
        system.debug('BidId--------' + BidId);
        system.debug('templateType--------' + templateType);
        list < Phoenix_Bid_Line_Item__c > bildLines = [select id, Phoenix_Medicaid_Returns_Per_Unit_in__c,Phoenix_Current_Retail_Direct_Price__c, Phoenix_Current_Anda_Invoice_Price__c, Phoenix_Current_Retail_Indirect_Price__c, Phoenix_Current_Wholesaler_Price__c, Phoenix_Current_Anda_CP_Price__c, Phoenix_Current_Wholesaler_Units__c, Phoenix_Current_Anda_Net_Model_Units__c, Phoenix_Current_Retail_Direct_Units__c, Phoenix_Current_Indirect_Gaint_EagleUnit__c, Phoenix_Current_Anda_Units__c, Phoenix_Current_Retail_Indirect_Units__c, name, Phoenix_Product__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Current_CD__c, Phoenix_Others_Indirect__c, Phoenix_Others_Direct__c, Phoenix_12_Months_Actual_Sales__c, Phoenix_Current_Position__c, Phoenix_Product__r.Name, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Fee__c, Phoenix_Bid__r.Phoenix_Customer__r.Rebate_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Cash_Discount__c, Phoenix_Bid__r.Phoenix_Customer__r.Fee_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebates__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_VIP__c, Phoenix_Current_Net_Sales_Internal__c, Phoenix_DeadNet_TrckGR__c, Phoenix_Product__r.ProductCode, Phoenix_Current_Direct_Selling_Unit__c, Phoenix_Current_Indirect_Selling_Unit__c, Phoenix_Current_Indirect_Price__c, Phoenix_Current_Direct_Price__c, Phoenix_Current_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Current_Rebate__c, Phoenix_Rebate_G_N__c, Phoenix_Fee_G_N__c, Phoenix_Current_Admin_Fee__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: BidId];
        String bidTye= (bildLines !=null && bildLines.size()>0) ? bildLines[0].Phoenix_Bid__r.Phoenix_Bid_Type__c:'';
        if(bidTye != 'New Product Launch' && bidTye != 'New Customer' ){
            list < Phoenix_NPR_Data__c > NPRDataLines = [select id, Name, Phoenix_Contract_Type__c, Phoenix_Contract_Number__c, Phoenix_12Months_Actual_Sales_Unit__c, Phoenix_12Mt_Sales_Ut_Actual__c, Phoenix_Product_Position__c, Phoenix_Net_Sales_Internal__c, Phoenix_Dead_Net_Tracking_GR__c, Phoenix_Contract_Price__c, Phoenix_Product__c, Phoenix_Product__r.ProductCode, Phoenix_12Months_Sales_Unit__c, Phoenix_12Months_Net_Sales__c, Phoenix_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Rebate__c, Phoenix_Rebate_G_N_Indicator__c, Phoenix_Bonafied_G_N_Indicator__c, Phoenix_Fee_Bonafied_Fee__c, Phoenix_Per_Unit_Bonfied_Fee__c, Phoenix_CD__c, Phoenix_GR_TrackingTier__c from Phoenix_NPR_Data__c where Phoenix_Contract_Number__c in: selectrcs and Phoenix_NPR_Status__c = 'Active'];
            map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
            for (Phoenix_NPR_Data__c NPRLine: NPRDataLines) {
                if (productCodeToNPRLineMap.containsKey(NPRLine.Phoenix_Product__r.ProductCode)) {
                    productCodeToNPRLineMap.get(NPRLine.Phoenix_Product__r.ProductCode).add(NPRLine);
                } else {
                    list < Phoenix_NPR_Data__c > NPRList = new list < Phoenix_NPR_Data__c > ();
                    NPRList.add(NPRLine);
                    productCodeToNPRLineMap.put(NPRLine.Phoenix_Product__r.ProductCode, NPRList);
                }
            }
            map < Phoenix_Bid_Line_Item__c, list < Phoenix_NPR_Data__c >> bidToNPRMap = new map < Phoenix_Bid_Line_Item__c, list < Phoenix_NPR_Data__c >> ();
            decimal cashDiscount;
            decimal currentVip;
            for (Phoenix_Bid_Line_Item__c bidLine: bildLines) {
                //bidLine.Phoenix_Current_Indirect_Selling_Unit__c = 0;
                // bidLine.Phoenix_Current_Direct_Selling_Unit__c = 0;
                //bidLine.Phoenix_Current_Indirect_Price__c = 0;
                // bidLine.Phoenix_Current_Direct_Price__c = 0;
                
                bidLine.Phoenix_ZITD_Value__c = 0;
                bidLine.Phoenix_DeadNet_TrckGR__c=0;
                bidLine.Phoenix_12_Months_Actual_Sales__c = 0;
                bidLine.Phoenix_12_Months_IndirectSaleUnit__c = 0;
                bidLine.Phoenix_ProposedDirectGaintEagleUnits__c = 0;
                
                
                bidLine.Phoenix_Current_Wholesaler_Units__c = 0;
                bidLine.Phoenix_Current_Anda_Units__c = 0;
                //bidLine.Phoenix_Current_Retail_Indirect_Units__c = 0;
                bidLine.Phoenix_Current_Retail_Direct_Units__c = 0;
                bidLine.Phoenix_Current_Retail_Direct_Price__c=0;
                bidLine.Phoenix_Current_Retail_Indirect_Net__c=0;
                bidLine.Phoenix_Current_Retail_Indirect_Price__c=0;
                bidLine.Phoenix_Current_Per_Unit_Rebate__c=0;
                bidLine.Phoenix_Wholesaler_IOD_per_unit__c=0;
                bidLine.Phoenix_Current_Anda_Acquisition_Costs__c=0;
                
                list < Decimal > retaildirectPriceList = new list < Decimal > ();
                list < Decimal > andadirectPriceList = new list < Decimal > ();
                list < Decimal > retailindirectPriceList = new list < Decimal > ();
                //list < Decimal > wholesalerindirectPriceList = new list < Decimal > ();
                //list < Decimal > andaCPindirectPriceList = new list < Decimal > ();
                list < Decimal > perUnitRebateList = new list < Decimal > ();
                list < Decimal > perUnitRebateList1 = new list < Decimal > (); 
                list < Decimal > perUnitRebateList2 = new list < Decimal > ();
                list < Decimal > deadNetTrackList = new list < Decimal > ();
                //list < Decimal > NetSalesList = new List < Decimal > ();
                list < Decimal > ZITDList = new List < Decimal > ();
                // list < Decimal > RebateList = new List < Decimal > ();
                // by satya
                list < Decimal > indirectDeadNet = new List < Decimal > ();
                list < Decimal > directDeadnet = new List < Decimal > ();
                // end by satya
                Set < String > currentPositionSet = new Set< String > ();
                if (productCodeToNPRLineMap.keyset().contains(bidLine.Phoenix_Product__r.ProductCode)) {
                    bidLine.Phoenix_Current_Position__c = '';
                    for (Phoenix_NPR_Data__c NPRLine: productCodeToNPRLineMap.get(bidLine.Phoenix_Product__r.ProductCode)) {
                        //bidLine.Phoenix_Current_Position__c = (NPRLine.Phoenix_Product_Position__c != null ? NPRLine.Phoenix_Product_Position__c + ', ' : '') + (bidLine.Phoenix_Current_Position__c != null ? bidLine.Phoenix_Current_Position__c : '');
                        currentPositionSet.add(NPRLine.Phoenix_Product_Position__c != null ? NPRLine.Phoenix_Product_Position__c + '' : '');
                        
                        // if (templateType == 'BASE/DSH') {
                        if (NPRLine.Phoenix_Contract_Number__c == '3000000762' ||NPRLine.Phoenix_Contract_Number__c == '3000000634' ||NPRLine.Phoenix_Contract_Number__c == '3000000929' || NPRLine.Phoenix_Contract_Number__c == '3000000911' || NPRLine.Phoenix_Contract_Number__c == '3000001344' || NPRLine.Phoenix_Contract_Number__c == '3000000746' || NPRLine.Phoenix_Contract_Number__c == '3000000448' || NPRLine.Phoenix_Contract_Number__c == '3000000440'|| NPRLine.Phoenix_Contract_Number__c == '3000000963' || NPRLine.Phoenix_Contract_Number__c == '3000000468'  || NPRLine.Phoenix_Contract_Number__c == '3000000351'  || NPRLine.Phoenix_Contract_Number__c == '3000000652'  || NPRLine.Phoenix_Contract_Number__c == '3000000859' || NPRLine.Phoenix_Contract_Number__c == '3000000383'  || NPRLine.Phoenix_Contract_Number__c == '3000001690' || NPRLine.Phoenix_Contract_Number__c == '3000001343') {
                            bidLine.Phoenix_12_Months_IndirectSaleUnit__c = (bidLine.Phoenix_12_Months_IndirectSaleUnit__c != null ? bidLine.Phoenix_12_Months_IndirectSaleUnit__c : 0) + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                            bidLine.Phoenix_Current_Wholesaler_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                            retaildirectPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                            perUnitRebateList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                        }
                        if (NPRLine.Phoenix_Contract_Number__c == '3000000352' || NPRLine.Phoenix_Contract_Number__c == '3000000441' || NPRLine.Phoenix_Contract_Number__c == '3000000447' || NPRLine.Phoenix_Contract_Number__c == '3000000469' || NPRLine.Phoenix_Contract_Number__c == '3000000653' || NPRLine.Phoenix_Contract_Number__c == '3000000763' || NPRLine.Phoenix_Contract_Number__c == '3000000767' || NPRLine.Phoenix_Contract_Number__c == '3000000912'||NPRLine.Phoenix_Contract_Number__c == '3000000964' || NPRLine.Phoenix_Contract_Number__c == '3000001088'||NPRLine.Phoenix_Contract_Number__c == '3000001310' || NPRLine.Phoenix_Contract_Number__c == '3000001541' ||NPRLine.Phoenix_Contract_Number__c == '3000001548' || NPRLine.Phoenix_Contract_Number__c == '3000001691' || NPRLine.Phoenix_Contract_Number__c == '3000000419') {
                            bidLine.Phoenix_12_Months_Actual_Sales__c = (bidLine.Phoenix_12_Months_Actual_Sales__c != null ? bidLine.Phoenix_12_Months_Actual_Sales__c : 0) + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                            bidLine.Phoenix_Current_Anda_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                            perUnitRebateList1.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                            andadirectPriceList.add(NPRLine.Phoenix_Contract_Price__c);                        
                        }
                        if (NPRLine.Phoenix_Contract_Number__c == '3000000589') {
                            bidLine.Phoenix_ProposedDirectGaintEagleUnits__c = (bidLine.Phoenix_ProposedDirectGaintEagleUnits__c != null ? bidLine.Phoenix_ProposedDirectGaintEagleUnits__c : 0) + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                            bidLine.Phoenix_Current_Retail_Direct_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                            retailindirectPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                            perUnitRebateList2.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                        }
                        
                        
                        
                        
                        
                        deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
                        ZITDList.add(NPRLine.Phoenix_ZITD_Value__c);
                        
                        //RebateList.add(NPRLine.Phoenix_Rebate__c);
                        
                    }                   
                    if( currentPositionSet.size() >0 ) {
                        List<String> currentPositionList = new List<String>(currentPositionSet);
                        bidLine.Phoenix_Current_Position__c = string.join(currentPositionList, ', ');
                    }
                    //take minimum of all indeirect NPR prices
                    if (retaildirectPriceList.size() > 0) {
                        retaildirectPriceList.sort();
                        bidLine.Phoenix_Current_Retail_Direct_Price__c = retaildirectPriceList[0];
                    }
                    //take minimum of all deirect NPR prices
                    if (andadirectPriceList.size() > 0) {
                        andadirectPriceList.sort();
                        bidLine.Phoenix_Current_Retail_Indirect_Net__c = andadirectPriceList[0];
                    }
                    if (retailindirectPriceList.size() > 0) {
                        retailindirectPriceList.sort();
                        bidLine.Phoenix_Current_Retail_Indirect_Price__c = retailindirectPriceList[0];
                    }
                    
                    
                    //take Max of all  NPR rebate
                    if (perUnitRebateList.size() > 0) {
                        perUnitRebateList.sort();
                        bidLine.Phoenix_Current_Per_Unit_Rebate__c = perUnitRebateList[perUnitRebateList.size() - 1];
                        //bidLine.Phoenix_Proposed_Per_Unit_Rebate__c = perUnitRebateList[perUnitRebateList.size() - 1];
                    }
                    //take Max of all  NPR rebate
                    if (perUnitRebateList1.size() > 0) {
                        perUnitRebateList1.sort();
                        bidLine.Phoenix_Wholesaler_IOD_per_unit__c = perUnitRebateList1[perUnitRebateList1.size() - 1];
                        //bidLine.Phoenix_Proposed_Per_Unit_Rebate__c = perUnitRebateList1[perUnitRebateList1.size() - 1];
                    }
                    //take Max of all  NPR rebate
                    if (perUnitRebateList2.size() > 0) {
                        perUnitRebateList2.sort();
                        bidLine.Phoenix_Current_Anda_Acquisition_Costs__c = perUnitRebateList2[perUnitRebateList2.size() - 1];
                        //bidLine.Phoenix_Proposed_Per_Unit_Rebate__c = perUnitRebateList2[perUnitRebateList2.size() - 1];
                    }
                    //take minimum of all  NPR Dead net track
                    if (deadNetTrackList.size() > 0) {
                        deadNetTrackList.sort();
                        bidLine.Phoenix_DeadNet_TrckGR__c = deadNetTrackList[0];
                    }
                    
                    //take minimum of all zitd sales internal
                    if (ZITDList.size() > 0) {
                        ZITDList.sort();
                        bidLine.Phoenix_ZITD_Value__c = ZITDList[0];
                    }
                    
                    
                }
                else {
                    
                }
            }
            
            update bildLines;
        }
    }
    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > submitToProceddStep(string bidId, boolean isContracts,boolean ismarketingDeligator, string deligatedUserName) {
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
        
        query = 'select Phoenix_Previous_LineItem__r.Name,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
        if (isContracts != true && ismarketingDeligator != true) {
            query += ' and Phoenix_Product_Director__c=:loggerUserName';
        }else if(ismarketingDeligator){
            query += ' and Phoenix_Product_Director__c=:directorNames';
        }
        
        list < Phoenix_Bid_Line_Item__c > bidLinesList = Database.query(query);
        return bidLinesList;
    }
    /*@AuraEnabled 
public static  list<Phoenix_Bid_Process_Steps__c> makeApprovalsContracts(String bidId,List<Phoenix_Bid_Line_Item__c> bidlines,boolean approveStatusFlag,boolean isContracts){
String bidType = [SELECT id , Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =: bidId LIMIT 1].Phoenix_Bid_Type__c;
for(Phoenix_Bid_Line_Item__c line :  bidlines){
line.Phoenix_Contracts_Final_Approval__c = true;
if(line.Phoenix_Contract_Approval__c == 'Line Error- Not Sent'){                line.Phoenix_Final_Status__c = 'Not Approved';
}
}
if(bidlines.size()>0){
update bidlines;
}
list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:bidId ];
list<Phoenix_Bid_Process_Steps__c> contractsStepLsit=new list<Phoenix_Bid_Process_Steps__c>();
for(Phoenix_Bid_Process_Steps__c step:bidProcessStepList){
if(step.Phoenix_Process_Step__r.Name=='Contracts' && step.Phoenix_Approver__c==Userinfo.getUserId()){                step.Phoenix_Status__c='Completed';/*approveStatusFlag==true?'Completed':'Do Not Bid'; /               contractsStepLsit.add(step);
}else if(step.Phoenix_Process_Step__r.Name=='Contracts' && bidType == 'IPA Floor Pricing Update'){                step.Phoenix_Status__c='Completed';/*approveStatusFlag==true?'Completed':'Do Not Bid';/                contractsStepLsit.add(step);
}
}
if(!contractsStepLsit.isEmpty()){            update contractsStepLsit;
}
return bidProcessStepList;
}*/
    @AuraEnabled
    public static WrapperForNextSteps makeApprovals(String bidId, List < Phoenix_Bid_Line_Item__c > bidlines, boolean approveStatusFlag) {
        List<string> productDirectorsNames = new List<string>();
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
        
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
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
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Delegated_Approver__c,Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c,Phoenix_Process_Step__r.Name, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Approver__r.Name,Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId order by Phoenix_Step__c];
        if (isAllRejectedCaseFound) {
            //close the bid other step not applicable
            integer currentStepNum;
            for (Phoenix_Bid_Process_Steps__c prcsStep: bidProcessStepList) {
                if (prcsStep.Phoenix_Approver_Team__c == 'Marketing') {
                    currentStepNum = integer.valueOf(prcsStep.Phoenix_Step__c);
                }
            }
            for (Phoenix_Bid_Process_Steps__c prcsStep: bidProcessStepList) {
                if (prcsStep.Phoenix_Status__c != 'Completed' && prcsStep.Phoenix_Approver_Team__c == 'Marketing' && (prcsStep.Phoenix_Approver__c == Userinfo.getUserId() || (deligatorApprover.size()>0 && productDirectorsNames.contains(prcsStep.Phoenix_Approver__r.Name) ))) {
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
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Marketing Rejected');//Closed
            update bid;
            wrapSteps.updateProcessStepList = bidProcessStepList;
            wrapSteps.flagSCMStop = true;
            wrapSteps.flagMarketStop = true;
        } else {
            list < Phoenix_Bid_Process_Steps__c > marketStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
            boolean flagSCMStop = false;
            boolean flagMarketStop = false;
            for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
                if (step.Phoenix_Status__c != 'Completed' && step.Phoenix_Approver_Team__c == 'Marketing' && (step.Phoenix_Approver__c == Userinfo.getUserId() || (deligatorApprover.size()>0 && productDirectorsNames.contains(step.Phoenix_Approver__r.Name) ))) {
                    step.Phoenix_Status__c = 'Completed'; //approveStatusFlag==true?'Completed':'Do Not Bid';
                    // step.Phoenix_Status__c=approveStatusFlag==true?'Completed':'';
                    if(deligatorApprover.size()>0 && productDirectorsNames.contains(step.Phoenix_Approver__r.Name)){
                        step.Phoenix_Delegated_Approver__c =  Userinfo.getUserId();
                    }else{
                        step.Phoenix_Approver__c = Userinfo.getUserId();
                    }
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
       Phoenix_Bid_Process_Steps__c financeStep;//added for purple grid
        if (flagSCMStop == false && flagMarketStop == false && !processStepLsit.isEmpty()) {
            Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
            list < Phoenix_Bid_Process_Steps__c > criteriaSteplist = new list < Phoenix_Bid_Process_Steps__c > ();
            map < string, Phoenix_Bid_Process_Steps__c > teamToStepMap = new map < string, Phoenix_Bid_Process_Steps__c > ();
            for (Phoenix_Bid_Process_Steps__c step: processStepLsit) {
                //added for purple grid
                if(step.Phoenix_Process_Step__r.Name == 'Finance Approval' &&  !Phoenix_SubmitBidForApprovalCtrl.financeApplicableBool){
                    financeStep =  new Phoenix_Bid_Process_Steps__c(Id=step.Id,Phoenix_Status__c='Not Applicable');
                }
                //added for purple grid end
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
            system.debug(stepnameNoMap.get('Marketing'));
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
              
                system.debug('updated steps--' + updatedTeamToStepMap.values());
              /*  List<Phoenix_Bid_Process_Steps__c > updatedStepList = updatedTeamToStepMap.values();
                 if(Phoenix_SubmitBidForApprovalCtrl.financeNotApplicableBool && financeStep != null){
                 updatedStepList.add(financeStep);    
                } 
                system.debug('updatedTeamToStepMap.values()=='+updatedTeamToStepMap.values());
                system.debug('updatedStepList=='+updatedStepList);*/
                update updatedTeamToStepMap.values();
                //update criteriaSteplist;
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Marketing Lead');
                update bid;
                Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId, updatedTeamToStepMap.values());
            } 
            else {
                
                //if(criteriaSteplist != null && criteriaSteplist.size() > 0) 
                //   stepMap.get(stepnameNoMap.get('Marketing')+criteriaSteplist.size()+1);
                //   //added for purple grid
                integer stepnumber = (Phoenix_SubmitBidForApprovalCtrl.financeNotApplicableBool && !Phoenix_SubmitBidForApprovalCtrl.financeApplicableBool) ? stepnameNoMap.get('Finance') : stepnameNoMap.get('Marketing')  ;
                List < Phoenix_Bid_Process_Steps__c > nextSteps = stepMap.get(stepnumber + 1);
                system.debug('nextSteps--->' + nextSteps);
               
                While(nextSteps != null && nextSteps[0].Phoenix_Status__c == 'Not Applicable') {
                    stepNumber += 1;
                    nextSteps = stepMap.get(stepNumber);
                }
                for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                   // if(step.Phoenix_Process_Step__r.Name == 'Finance Approval'){
                  //  step.Phoenix_Status__c = 'Not Applicable';    
                 //   }
                    step.Phoenix_Status__c = 'In Process';
                    
                }
                system.debug('financeStep=='+financeStep);
                system.debug('financeNotApplicableBool=='+Phoenix_SubmitBidForApprovalCtrl.financeNotApplicableBool);
                //added for purple grid
                if(Phoenix_SubmitBidForApprovalCtrl.financeNotApplicableBool && financeStep != null && !Phoenix_SubmitBidForApprovalCtrl.financeApplicableBool){
                    nextSteps.add(financeStep);    
                    system.debug('nextSteps=='+nextSteps);
                } 
                //added for purple grid end
                if (!nextSteps.isEmpty()) {
                    update nextSteps;
                    Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = nextSteps[0].Phoenix_Approver_Team__c);
                    update bid;
                    Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId, nextSteps);
                    //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bidName,nextSteps,'Bid_Approval');
                }
                //}
            }
        }
    }
    @AuraEnabled
    public static void updateNextContractProcessSteps(string bidId, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit) {
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
        // system.debug('stepnamemap--'+stepnameNoMap.get('Contracts')+1);
        //system.debug('stepnamemap--'+stepMap.get(stepnameNoMap.get('Contracts')+1));
        List < Phoenix_Bid_Process_Steps__c > nextSteps = new List < Phoenix_Bid_Process_Steps__c > ();
        if (stepnameNoMap.get('Contracts') != null) stepMap.get(stepnameNoMap.get('Contracts') + 1);
        for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
            if (step.Name.contains('Closed')) {
                step.Phoenix_Status__c = 'Completed';
            } else {
                step.Phoenix_Status__c = 'In Process';
            } //'In Process' Submitted //Diff b/w them
        }
        if (!nextSteps.isEmpty()) {
            update nextSteps;
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = nextSteps[0].Phoenix_Approver_Team__c);
            update bid;
            system.debug('Hi Email');
            Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId, nextSteps);
        } else {
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
            update bid;
        }
    }
    //Added Code by Rama
    
    @AuraEnabled 
    public static user fetchUser(){  
        return CompetitorInfoCLS.fetchUser();
    }
    
    //End Code by Rama
}