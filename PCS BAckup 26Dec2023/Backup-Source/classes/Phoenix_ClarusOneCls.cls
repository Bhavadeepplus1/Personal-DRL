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
public class Phoenix_ClarusOneCls {
     @AuraEnabled
    public static void getLastBidActivity(Id bidId) {
        System.debug('bidId==>'+bidId);
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Is_Re_Bid__c, Phoenix_Previous_Bid__c, Phoenix_OTB_Direct_Indirect__c, Phoenix_Bid_Proposed_Position__c, Phoenix_Proactive_Reactive__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Current_CD__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
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
    public static list < AggregateResult > getAllTotals(Id bidId) {
        AggregateResult[] groupedResults = [
            select sum(Phoenix_OS_and_RAD_Cur_Direct_Units_C__c) osRadUnits,
            sum(Phoenix_WMT_Current_Direct_Units__c) wmtcurDirUnit,
            sum(Phoenix_Proposed_OS_Units__c) propOS,
            sum(Phoenix_Proposed_RAD_Units__c) propRAD,
            sum(Phoenix_Proposed_WMT_Units__c) propWMT,
            sum(Phoenix_ProposedIndirectAholdDelhaizeUni__c) scmOSUnits,
            sum(Phoenix_Proposed_IndirectGaintEagleUnits__c) scmRADUnits,
            sum(Phoenix_Final_Direct_Selling_Units__c) scmWMTUnits,
            sum(Phoenix_WMT_Current_Indirect_Units__c) wmtCurIndUnit,
            sum(Phoenix_Override_Current_Direct_Units__c) overRideOSRAD,
            sum(Phoenix_Override_Current_Indirect_Units__c) overRideWMTIndi,
            sum(Phoenix_Proposed_Smith_Drug_Units__c) overrideWMTDire,
            sum(Proposed_Net_Sales_Direct__c) MacRadNetSales,

            sum(Phoenix_Current_Anda_Net_Model_Units__c) totalWMTNetSales,
            sum(Phoenix_Current_Anda_Units__c) TotalWMTTPT,
            sum(Phoenix_Less_Cost__c) lesscost,
            sum(Phoenix_Th_Put_Margin__c) thptm,
            sum(Phoenix_Retail_Indirect_Net_Sales__c) wmtDirectNetSales,
            sum(Phoenix_WMT_Indirect_Net_Sales__c) wmtIndirectnetSales,
            sum(Proposed_Net_Sales_Indirect__c) pnsInd,
            sum(Phoenix_12_Months_Actual_Sales__c) twlveMonRAADSales,
            sum(Phoenix_12_Months_IndirectSaleUnit__c) twlveMonWMTIndiSales,
            sum(Phoenix_3_Months_Actual_Sales__c) twlveMonWMTDIiSales,
            sum(Phoenix_Retail_Indirect_Net_Sales__c) WMTDirNetSales,
            sum(Phoenix_Wholesaler_DRL_TPT__c) WMTDirTPTDollr,
            sum(Phoenix_WMT_Indirect_TPT__c) WMTIndirTPTDolar,
            sum(Phoenix_Wholesaler_Net_Sales__c) CurMckNetSales,
            sum(Phoenix_Retail_Direct_Net_sales__c) CurWMTDirNetSales,
            sum(Proposed_Net_Sales_Indirect__c) CurWMTIndirNetSales,
            sum(Phoenix_ProposedDirectAholdDelhaizeUnits__c) totalTPTDollar,
            sum(Phoenix_ProposedDirectGaintEagleUnits__c) totalNetSalesCom,
            sum(Phoenix_ANDA_IOD_Overall_Amount__c) MckStokingOvrAmt,
            sum(Phoenix_Total_SCM_Approved_Qty__c) scmQty,
            sum(Phoenix_WMT_Stck_Allowance_Overall_Amnt__c) WMTStokingOvrAmt,
            sum(Proposed_TPT_Indirect__c) macRADTPT,
            sum(Phoenix_Opening_Order__c) mckOpeningOrder,
            sum(Phoenix_Anda_Net_Model_Sales__c) mckNetsales,
            sum(Phoenix_Wholesaler_Customer_Net_Price__c) mcktptdl,
            sum(Phoenix_Opening_Order_WMTTPT__c) mcktptperc,
            sum(Phoenix_Direct_Accerodo__c) wmtOpeningOrder,
            sum(Phoenix_Opening_Order_Net_sales__c) wmtNetSales,
            sum(Phoenix_Opening_Order_TPT__c) wmtOpeningOrderTPTdl,
            sum(Phoenix_Costco_TPTPer__c) wmtTPTPerc
            from Phoenix_Bid_Line_Item__c where
            Phoenix_Bid__c =: bidId and Phoenix_Final_Status__c != 'Not Approved'
        ];
        return groupedResults;
    }
    
    @AuraEnabled
    public static List < Phoenix_Bid_Line_Item__c > getUpdatedList(String bidId) {
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
        query = 'select Product_Family__r.Name, Phoenix_Bid__r.Phoenix_Is_Re_Bid__c,Phoenix_Previous_Bid__r.Name,Phoenix_Previous_LineItem__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c,Phoenix_Bid__r.Phoenix_WMT_Direct_Rebate__c,Phoenix_Bid__r.Phoenix_Mck_RAD_Rebate__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved  ORDER BY Product_Family_Name__c ASC';
        list < Phoenix_Bid_Line_Item__c > bidLines = Database.query(query);
        
        for(Phoenix_Bid_Line_Item__c bidLine : bidLines){
            //system.debug('bidLine.Phoenix_Proposed_RAD_Units__c====>'+bidLine.Phoenix_Proposed_RAD_Units__c);
            //system.debug('bidLine.Phoenix_Proposed_OS_Units__c====>'+bidLine.Phoenix_Proposed_OS_Units__c);
            //system.debug('bidLine.Phoenix_Proposed_WMT_Units__c====>'+bidLine.Phoenix_Proposed_WMT_Units__c);
            if(bidLine.Phoenix_Proposed_RAD_Units__c == null){
              bidLine.Phoenix_Proposed_RAD_Units__c = 0;  
                
            }
            if(bidLine.Phoenix_Proposed_OS_Units__c == null){
              bidLine.Phoenix_Proposed_OS_Units__c = 0;  
            }
            if(bidLine.Phoenix_Proposed_WMT_Units__c == null){
              bidLine.Phoenix_Proposed_WMT_Units__c = 0;  
            }
        }
        update bidLines;
        return bidLines;
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
        query = 'select Product_Family__r.Name, Phoenix_Previous_LineItem__r.Name,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved  ORDER BY Product_Family_Name__c ASC';
        list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);
        for(Phoenix_Bid_Line_Item__c line : quoteList){
            line.Phoenix_Marketing_Notes__c = line.Phoenix_Marketing_Notes__c!=null ? line.Phoenix_Marketing_Notes__c.replace('#',' '):line.Phoenix_Marketing_Notes__c;
        }
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
    public static Wrapper getRelatedList(Id bidId) {
         getLastBidActivity(bidId);
        Wrapper wrapperObject = new Wrapper();
        //String query = 'SELECT Name,Phoenix_Product__c,Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Net_Price_after_RebatesbeforeVIP__c, Phoenix_Bid__c,Phoenix_Case_Pack__c,Phoenix_Pkg_Size__c,Phoenix_Product_Family__c,Phoenix_NDC_National_Drug_Code__c,Phoenix_Product_Code__c,Phoenix_Compare_to_Brand_Name__c,Phoenix_Product_Director__c,Phoenix_Orange_Book_Rating__c,Phoenix_Throughput_cost__c,Phoenix_WAC__c,Phoenix_Current_Indirect_Selling_Unit__c	,Phoenix_Current_Direct_Selling_Unit__c,Phoenix_Total_Selling_Unit__c,Phoenix_Doses__c , Phoenix_Proposed_Indirect_Selling_Unit__c,Phoenix_Proposed_Direct_Selling_Unit__c, Phoenix_Final_Indirect_Selling_Units__c,Phoenix_Final_Direct_Selling_Units__c, Phoenix_Final_Total_Selling_Unit__c, Phoenix_Final_Annual_Extended_Units__c, Phoenix_Wholesaler_Diff_Price_Indirect__c, Phoenix_Current_Direct_Price__c, Phoenix_Current_Indirect_Price__c,  Phoenix_ProposedContract_Bid_Price_Sales__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Proposed_Current_Rebate__c, Phoenix_Current_Rebate__c, Phoenix_Proposed_Per_Unit_Rebate__c,Phoenix_Current_Per_Unit_Rebate__c, Phoenix_Gross_Contract_Sales__c, Phoenix_Value_Rebate__c,Phoenix_Value_Per_Unit_Rebate__c,Phoenix_Value_Admin_Fee__c	,Phoenix_Current_Admin_Fee__c,Phoenix_Value_Est_VIP__c,Phoenix_Sales_Out_Promotion__c,Phoenix_Initial_Order_Discount__c, Phoenix_Cash_Terms_Non_Weighted__c, Phoenix_Net_Sales_External__c ,Phoenix_Net_Sales_Internal__c ,Phoenix_Cash_Terms_Weighted__c, Phoenix_Estimated_Medicaid_Returns__c,Phoenix_Contr_Management_Fee_Wholesaler__c, Phoenix_Less_Cost__c, Phoenix_Th_Put_Margin__c, Phoenix_Net_Price_afterRebates_after_VIP__c,Phoenix_Net_Price_after_Rebates_Terms__c, Phoenix_Internal_Dead_Net_Price__c,Phoenix_TP_Margin__c, Phoenix_Budgeted_ASP_Q1_FY21__c,Phoenix_Sales_Notes__c, Phoenix_SCM_Notes__c, Phoenix_Pricing_Notes__c,Phoenix_Marketing_Notes__c,Phoenix_WAC_Check__c ,Phoenix_SSA_Hit__c   FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =: bidId limit 1000';
        ////system.debug('query'+query);
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
        query = 'select Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Controlled_Substance__c,Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Refrigerated__c,Phoenix_Product__r.Phoenix_Limited_Distribution__c,Phoenix_Bid__r.Phoenix_Is_Re_Bid__c,Phoenix_Previous_Bid__r.Name,Phoenix_Previous_LineItem__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c,Phoenix_Bid__r.Phoenix_WMT_Direct_Rebate__c,Phoenix_Bid__r.Phoenix_Mck_RAD_Rebate__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved  ORDER BY Product_Family_Name__c ASC';
        list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);
        //system.debug('quoteList--->' + quoteList);
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_WMT_Direct_Rebate__c, Phoenix_Mck_RAD_Rebate__c, Phoenix_Customer__r.Phoenix_ABS__c, Phoenix_Customer__r.Phoenix_Rebates__c, Phoenix_Proposed_Position__c, Phoenix_Bid_Proposed_Position__c, Phoenix_Customer__r.Phoenix_Cash_Discount__c, Phoenix_Customer__r.Phoenix_Fee__c, Phoenix_Customer__r.Phoenix_RDC_NLC__c, Phoenix_Customer__r.Cash_Terms__c, Phoenix_Customer__r.Phoenix_CM_Fees__c, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Is_Re_Bid__c, Phoenix_Previous_Bid__c, Phoenix_Proactive_Reactive__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Current_CD__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c,Phoenix_Controlled_Substance__c,Phoenix_Required_Cold_Storage__c,Phoenix_Controlled_Distribution__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        User cuurentUser;
        if (bid.Phoenix_Bid_Created_Behalf_of__c != null && bid.Phoenix_Approval_Status__c == 'Draft') {
            cuurentUser = [SELECT id, Name FROM User WHERE Id =: bid.Phoenix_Bid_Created_Behalf_of__c LIMIT 1];
        } else {
            cuurentUser = [SELECT id, Name FROM User WHERE Id =: userinfo.getUserId() LIMIT 1];
        }
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Delegated_Approver__r.Name,Phoenix_User__r.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
        String delegatedUsers = cuurentUser.Name;
        if(deligatorApprover !=null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c aprHisDel : deligatorApprover){
                delegatedUsers = delegatedUsers + ',' + aprHisDel.Phoenix_User__r.Name;
            }
        }
        
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
        for (Phoenix_Bid_Line_Item__c lineItem: quoteList) {
            if (!productFamilyList.contains(lineItem.Product_Family_Name__c)) {
                // Columns column = new Columns();
                // column.label = string.valueof(lineItem.Phoenix_Product_Family__c) ;
                // column.value = string.valueof(lineItem.Phoenix_Product_Family__c) + 's';
                // columnsList.add(column);
                productFamilyList.add(lineItem.Product_Family_Name__c);
            }
            if (lineItem.Phoenix_Product_Director__c != null && !productDirectorList.contains(lineItem.Phoenix_Product_Director__c)) {
                productDirectorList.add(lineItem.Phoenix_Product_Director__c);
            }
            if (lineItem.Phoenix_Product_Director__c != null && (lineItem.Phoenix_Product_Director__c == userInfo.getName() || (delegatedUsers!=null && delegatedUsers.contains(lineItem.Phoenix_Product_Director__c))) && lineItem.Phoenix_Marketing_Final_Approval__c == false) {
                //system.debug('Has Prdouct Director');
                hasDirectorLines = true;
            }
            if (lineItem.Phoenix_Marketing_Final_Approval__c == true && lineItem.Phoenix_Product_Director__c == userinfo.getName()) {
                showProceedBtn = false;
            }
        }
        // //system.debug('productDirectorList--->'+productDirectorList);
        ////system.debug(UserInfo.getName());
        if(hasDirectorLines){
            showProceedBtn = true;
        }
        
        // //system.debug('productDirectorList--->'+productDirectorList);
        ////system.debug(UserInfo.getName());
        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, Phoenix_Approver__r.Name, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__r.Name);
        }
        string isMarketingApprovePerson;
        boolean isContractsApprovePerson;
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
        // Phoenix_Bid__c bid = [SELECT Id,Phoenix_Is_Re_Bid__c,Phoenix_Previous_Bid__c,Phoenix_Proactive_Reactive__c, Phoenix_Salesperson__c,  Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c,Name,Phoenix_Customer__c,Phoenix_Customer__r.Name,Phoenix_Customer_Type__c,Phoenix_Bid_Name__c,Phoenix_Reference_Contracts__c,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        //wrapperObject.columnList = columnsList;
        wrapperObject.lineItemsList = quoteList;
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
        //system.debug('---------productId-----' + productId);
        //system.debug('---------bidId-----' + bidId);
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Is_Re_Bid__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        string ultimateParent = bid.Phoenix_Ultimate_Parent__c;
        list < Phoenix_Bid__c > bidUltimateList = [SELECT Id, Phoenix_Is_Re_Bid__c, Phoenix_Current_CD__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Phoenix_Ultimate_Parent__c =: ultimateParent and Id !=: bidId];
        set < string > parentRebidIds = new set < string > ();
        for (Phoenix_Bid__c pb: bidUltimateList) {
            parentRebidIds.add(pb.Id);
        }
        parentRebidIds.add(ultimateParent);
        //system.debug('-----------parentRebidIds--------------' + parentRebidIds);
        list < Phoenix_Bid_Line_Item__c > reBidLineItemList = [SELECT id, Phoenix_Final_Approved_Pricing_Contracts__c, Phoenix_Bid__r.CreatedDate, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Ultimate_Parent__c, Phoenix_Bid__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Proposed_McK_OS_And_RAD_NCP__c, Phoenix_Proposed_WMT_Direct_NCP__c, Phoenix_Proposed_WMT_Indirect_NCP__c, Phoenix_Sales_Proposed_NCP_McK_And_RAD__c, Phoenix_ProposedContract_Bid_Price_Sales__c, Phoenix_Guidance_Price__c FROM Phoenix_Bid_Line_Item__c WHERE(Phoenix_Product__c =: productId AND Phoenix_Bid__c IN: parentRebidIds) ORDER BY Phoenix_Bid__r.Name ASC LIMIT 30000];
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
    public static Phoenix_Bid__c saveLineItems(List < Phoenix_Bid_Line_Item__c > LineItemList, Id LineItemId, string rebateHeader, string feeHeader, string contractApproval, boolean isRebateChanged, boolean isFeeChanged, boolean isApprovalChanged, String marketingHeader, boolean isMarketingChanged, string productPositions, string productMCKPositions) {
        List < Phoenix_Bid_Line_Item__c > lineList = [select id, name, Phoenix_Current_Position__c, Phoenix_Bid__r.Phoenix_Rebate__c, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Product_Director1__c, Phoenix_Marketing_Approval__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: LineItemId ORDER BY Product_Family_Name__c ASC];
        List < Phoenix_Bid_Line_Item__c > productDirectorLineItems = new List < Phoenix_Bid_Line_Item__c > ();
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Mck_RAD_Rebate__c, Phoenix_WMT_Direct_Rebate__c, Phoenix_Customer__r.Phoenix_ABS__c, Phoenix_Customer__r.Phoenix_Rebates__c, Phoenix_Proposed_Position__c, Phoenix_Bid_Proposed_Position__c, Phoenix_Customer__r.Phoenix_Cash_Discount__c, Phoenix_Customer__r.Phoenix_Fee__c, Phoenix_Customer__r.Phoenix_RDC_NLC__c, Phoenix_Customer__r.Cash_Terms__c, Phoenix_Customer__r.Phoenix_CM_Fees__c, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Is_Re_Bid__c, Phoenix_Previous_Bid__c, Phoenix_Proactive_Reactive__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Current_CD__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: LineItemId];
        if (lineList != null && lineList.size() > 0 && rebateHeader != '' || feeHeader != null || marketingHeader != '') {
            String currentUser = [SELECT id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].Name;
            //system.debug('currentUser--->' + currentUser);
            for (Phoenix_Bid_Line_Item__c lineItem: lineList) {
                if (lineItem.Phoenix_Product_Director1__c == currentUser && isMarketingChanged && marketingHeader != '') {
                    lineItem.Phoenix_Marketing_Approval__c = marketingHeader;
                }
                if (rebateHeader != '' && isRebateChanged == true)
                    lineItem.Phoenix_Rebate_G_N__c = rebateHeader;
                if (feeHeader != '' && isFeeChanged == true)
                    lineItem.Phoenix_Fee_G_N__c = feeHeader;
                if (contractApproval != '' && isApprovalChanged == true) lineItem.Phoenix_Contract_Approval__c = contractApproval;
                if ((lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change' || lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate') && isRebateChanged) {
                    lineItem.Phoenix_Opening_Order_TPT_Per__c = lineItem.Phoenix_Bid__r.Phoenix_Rebate__c;
                }
                lineItem.Phoenix_Proposed_Position__c = productPositions;
                lineItem.Phoenix_Current_Position__c = productMCKPositions;
            }
        }
        update lineList;
        return bid;
    }
    @AuraEnabled
    public static List < Phoenix_Bid_Line_Item__c > saveLineItemsNewPL(Id bidId, List < Phoenix_Bid_Line_Item__c > LineItemList) {
        // List < Phoenix_Bid_Line_Item__c > lineList = [select id, name,Phoenix_Lowest_Price_SKU1__c,Phoenix_WAC1__c,Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c,Phoenix_Product__r.Phoenix_WAC__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
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
        query = 'select Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Bid__r.Phoenix_Is_Re_Bid__c,Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c,Phoenix_Product__r.Phoenix_WAC__c,Phoenix_Previous_Bid__r.Name,Phoenix_Previous_LineItem__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c,Phoenix_Bid__r.Phoenix_WMT_Direct_Rebate__c,Phoenix_Bid__r.Phoenix_Mck_RAD_Rebate__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved  ORDER BY Product_Family_Name__c ASC';
        list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);
        //system.debug('quoteList--->' + quoteList);
        String currentUser = [SELECT id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].Name;
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
        Phoenix_Bid_Line_Item__c beforeUpdateLineItem = [SELECT Id, Phoenix_ProposedContractBidPriceMktng__c, Phoenix_Marketing_Approval__c, Phoenix_Guidance_Price__c FROM Phoenix_Bid_Line_Item__c WHERE Id =: LineItem.Id];
        if (currentValue != 'No Change' && fieldLabel == 'OpportunityBidding') {
            LineItem.Phoenix_New_Opportunities_Bidding__c = currentValue;
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
        //system.debug('LineItem.Phoenix_ProposedContractBidPriceMktng__c --->' + LineItem.Phoenix_Proposed_WMT_Direct_NCP__c);
        //system.debug('beforeUpdateLineItem.Phoenix_ProposedContractBidPriceMktng__c--->' + beforeUpdateLineItem.Phoenix_ProposedContractBidPriceMktng__c);
        if (LineItem.Phoenix_Proposed_WMT_Indirect_NCP__c == null && LineItem.Phoenix_Proposed_WMT_Direct_NCP__c != null) {
            LineItem.Phoenix_Proposed_WMT_Indirect_NCP__c = LineItem.Phoenix_Proposed_WMT_Direct_NCP__c;
        }
        if (((LineItem.Phoenix_Proposed_WMT_Direct_NCP__c != null && LineItem.Phoenix_Proposed_WMT_Direct_NCP__c > 0 )|| (LineItem.Phoenix_Proposed_WMT_Indirect_NCP__c != null && LineItem.Phoenix_Proposed_WMT_Indirect_NCP__c > 0) || (LineItem.Phoenix_Proposed_McK_OS_And_RAD_NCP__c != null && LineItem.Phoenix_Proposed_McK_OS_And_RAD_NCP__c > 0)) && beforeUpdateLineItem.Phoenix_Marketing_Approval__c == null) {
            LineItem.Phoenix_Marketing_Approval__c = 'Approved';
        }

        //Update Opty Bidding New Values
        Decimal mcKOSDeadNet = LineItem.Phoenix_Direct_Dead_Net__c != null ? LineItem.Phoenix_Direct_Dead_Net__c : 0;
        Decimal WMTDirectDeadNet = LineItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c != null ? LineItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c : 0;
        Decimal ProposedOSUnits = LineItem.Phoenix_Proposed_OS_Units__c != null ? LineItem.Phoenix_Proposed_OS_Units__c : 0;
        Decimal ProposedRadUnits = LineItem.Phoenix_Proposed_RAD_Units__c != null ? LineItem.Phoenix_Proposed_RAD_Units__c : 0;
        Decimal ProposedWMTUnits = LineItem.Phoenix_Proposed_WMT_Units__c != null ? LineItem.Phoenix_Proposed_WMT_Units__c : 0;
        //system.debug('mcKOSDeadNet-->' + mcKOSDeadNet);
        //system.debug('ProposedOSUnits-->' + ProposedOSUnits);
        //system.debug('type-->' + LineItem.Phoenix_New_Opportunities_Bidding__c);
        if (LineItem.Phoenix_New_Opportunities_Bidding__c == 'OneStop') {
            LineItem.Phoenix_New_Opportunities_Value__c = mcKOSDeadNet * ProposedOSUnits;
        } else if (LineItem.Phoenix_New_Opportunities_Bidding__c == 'RAD') {
            LineItem.Phoenix_New_Opportunities_Value__c = mcKOSDeadNet * ProposedRadUnits;
        } else if (LineItem.Phoenix_New_Opportunities_Bidding__c == 'WMT') {
            LineItem.Phoenix_New_Opportunities_Value__c = WMTDirectDeadNet * ProposedWMTUnits;
        } else if (LineItem.Phoenix_New_Opportunities_Bidding__c == 'OneStop And RAD') {
            LineItem.Phoenix_New_Opportunities_Value__c = mcKOSDeadNet * ProposedOSUnits + mcKOSDeadNet * ProposedRadUnits;
        } else if (LineItem.Phoenix_New_Opportunities_Bidding__c == 'OneStop And WMT') {
            LineItem.Phoenix_New_Opportunities_Value__c = mcKOSDeadNet * ProposedOSUnits + WMTDirectDeadNet * ProposedWMTUnits;
        } else if (LineItem.Phoenix_New_Opportunities_Bidding__c == 'RAD And WMT') {
            LineItem.Phoenix_New_Opportunities_Value__c = mcKOSDeadNet * ProposedRadUnits + WMTDirectDeadNet * ProposedWMTUnits;
        } else if (LineItem.Phoenix_New_Opportunities_Bidding__c == 'OneStop And RAD And WMT') {
            LineItem.Phoenix_New_Opportunities_Value__c = mcKOSDeadNet * ProposedRadUnits + WMTDirectDeadNet * ProposedWMTUnits + mcKOSDeadNet * ProposedOSUnits;
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
        query = 'select Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Controlled_Substance__c,Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Refrigerated__c,Phoenix_Product__r.Phoenix_Limited_Distribution__c,Phoenix_Previous_LineItem__r.Name,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c,Phoenix_Bid__r.Phoenix_WMT_Direct_Rebate__c,Phoenix_Bid__r.Phoenix_Mck_RAD_Rebate__c, ' + strFields + ' from ' + SobjectApiName + ' where id = :LineItemId limit 1';
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
        // //system.debug(lineItemsList);
        return lineItemsList;
    }
    @AuraEnabled
    public static list < Phoenix_Contract__c > getContracts(string customerID, string searchInput) {
        //system.debug('customerID---' + customerID);
        string act = 'Active';
        boolean isExcludeContract = false;
        string query = 'select name,Phoenix_Customer__r.Name,Phoenix_Contract_Number__c,Phoenix_Contract_Internal_Description__c,Phoenix_Contract_External_Description__c from Phoenix_Contract__c where Phoenix_Contract_Status__c=:act AND Phoenix_Is_Exclude_Contract__c=:isExcludeContract';
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
        string query;
        string notApproved = 'Not Approved';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        query = 'select Phoenix_Previous_LineItem__r.Name,Phoenix_Product__r.ProductCode,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Bid_Type__c, ' + Phoenix_Util.bidlineitemFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : BidId AND Phoenix_Final_Status__c !=: notApproved';
        list < Phoenix_Bid_Line_Item__c > bildLines = new list < Phoenix_Bid_Line_Item__c > (); //=[select id,name,Phoenix_Product__c,Phoenix_OS_RAD_CP__c,Phoenix_WMT_Direct_CP__c,Phoenix_Bid__r.Phoenix_Bid_Type__c,Phoenix_Others_Indirect__c,Phoenix_Others_Direct__c,Phoenix_12_Months_Actual_Sales__c,Phoenix_Current_Position__c,Phoenix_Product__r.Name,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Fee__c,Phoenix_Bid__r.Phoenix_Customer__r.Rebate_Type__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Cash_Discount__c,Phoenix_Bid__r.Phoenix_Customer__r.Fee_Type__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebates__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_VIP__c, Phoenix_Current_Net_Sales_Internal__c,Phoenix_DeadNet_TrckGR__c,Phoenix_Product__r.ProductCode,Phoenix_Current_Direct_Selling_Unit__c,Phoenix_Current_Indirect_Selling_Unit__c,Phoenix_Current_Indirect_Price__c,Phoenix_Current_Direct_Price__c,Phoenix_Current_Per_Unit_Rebate__c,Phoenix_ZITD_Value__c,Phoenix_Current_Rebate__c,Phoenix_Rebate_G_N__c,Phoenix_Fee_G_N__c,Phoenix_Current_Admin_Fee__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:BidId];
        bildLines = Database.query(query);
        String bidTye = (bildLines != null && bildLines.size() > 0) ? bildLines[0].Phoenix_Bid__r.Phoenix_Bid_Type__c : '';
        if (bidTye != 'New Product Launch') {
            list < Phoenix_NPR_Data__c > NPRDataLines = [select id, Name, Phoenix_CM_Fee__c, Phoenix_Contract_Type__c, Phoenix_ABS__c, Phoenix_Contract_Number__c, Phoenix_Product__r.ProductCode, Phoenix_12Months_Actual_Sales_Unit__c, Phoenix_12Mt_Sales_Ut_Actual__c, Phoenix_Product_Position__c, Phoenix_Net_Sales_Internal__c, Phoenix_Dead_Net_Tracking_GR__c, Phoenix_Contract_Price__c, Phoenix_Product__c, Phoenix_12Months_Sales_Unit__c, Phoenix_12Months_Net_Sales__c, Phoenix_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Rebate__c, Phoenix_Rebate_G_N_Indicator__c, Phoenix_Bonafied_G_N_Indicator__c, Phoenix_Fee_Bonafied_Fee__c, Phoenix_Per_Unit_Bonfied_Fee__c, Phoenix_CD__c, Phoenix_RDC_NLC__c, Phoenix_GR_TrackingTier__c from Phoenix_NPR_Data__c where Phoenix_Contract_Number__c in: selectrcs and Phoenix_NPR_Status__c = 'Active'];
            map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
            for (Phoenix_NPR_Data__c NPRLine: NPRDataLines) {
                if ('a0C0m000001iKhlEAE' == NPRLine.Id){ 
                    //system.debug('ContainsNewNpr');
                    }
                if (productCodeToNPRLineMap.containsKey(NPRLine.Phoenix_Product__r.ProductCode))

                {
                    productCodeToNPRLineMap.get(NPRLine.Phoenix_Product__r.ProductCode).add(NPRLine);
                    if ('a0C0m000001iKhlEAE' == NPRLine.Id)
                    {
                        //system.debug('ContainsNewNpr1');
                    }
                } else {
                    list < Phoenix_NPR_Data__c > NPRList = new list < Phoenix_NPR_Data__c > ();
                    NPRList.add(NPRLine);
                    productCodeToNPRLineMap.put(NPRLine.Phoenix_Product__r.ProductCode, NPRList);
                    if ('a0C0m000001iKhlEAE' == NPRLine.Id) {
                        //system.debug('ContainsNewNpr2');
                        }
                }
            }

            map < Phoenix_Bid_Line_Item__c, list < Phoenix_NPR_Data__c >> bidToNPRMap = new map < Phoenix_Bid_Line_Item__c, list < Phoenix_NPR_Data__c >> ();
            decimal cashDiscount;
            decimal currentVip;
            for (Phoenix_Bid_Line_Item__c bidLine: bildLines) {
                bidLine.Phoenix_OS_RAD_CP__c = 0;
                bidLine.Phoenix_WMT_Direct_CP__c = 0;
                bidLine.Phoenix_WMT_Indirect_CP__c = 0;
                bidLine.Phoenix_OS_RAD_PUR__c = 0;
                bidLine.Phoenix_WMT_Direct_PUR__c = 0;
                bidLine.Phoenix_WMT_Indirect_PUR__c = 0;
                bidLine.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c = 0;
                bidLine.Phoenix_WMT_Current_Indirect_Units__c = 0;
                bidLine.Phoenix_WMT_Current_Direct_Units__c = 0;
                bidLine.Phoenix_Current_Per_Unit_Rebate__c = 0;
                bidLine.Phoenix_ZITD_Value__c = 0;
                bidLine.Phoenix_Cash_Terms__c = 0;
                bidLine.Phoenix_Date_Fee__c = 0;
                bidLine.Phoenix_RDC_NLC__c = 0;
                bidLine.Phoenix_Current_Rebate__c = 0;
                bidLine.Phoenix_Current_Admin_Fee__c = 0;
                bidLine.Phoenix_Contract_Mngment_Fee_Wholesaler__c = 0;
                // Last three months annualized units OS RAD Units
                bidLine.Phoenix_12_Months_Actual_Sales__c = 0;
                //Last three months annualized WMT Direct UNits
                bidLine.Phoenix_12_Months_IndirectSaleUnit__c = 0;
                //Last three months annualized WMT Indirect Units
                bidLine.Phoenix_3_Months_Actual_Sales__c = 0;
                bidLine.Phoenix_Current_WMT_Position__c = '';
                //WMT Inirect CM Fee
                bidLine.Phoenix_Retail_Indirect_Wholesaler_Fee__c = 0;
                //WMT Direct CM Fee
                bidLine.Phoenix_Wholesaler_Price_Percent__c = 0;
                //Rebate % WMT direct 
                bidLine.Phoenix_Invoice_Allowance__c = 0;
                //Rebate % WMT Inirect
                bidLine.Phoenix_Reduction__c = 0;

                list < Decimal > oneStopAndRADCpList = new list < Decimal > ();
                list < Decimal > WMTDirectCpList = new list < Decimal > ();
                list < Decimal > WMTIndirectCpList = new list < Decimal > ();
                list < Decimal > oneStopAndRADPURList = new list < Decimal > ();
                list < Decimal > WMTDirectPURList = new list < Decimal > ();
                list < Decimal > WMTIndirectPURList = new list < Decimal > ();

                list < Decimal > perUnitRebateList = new list < Decimal > ();
                list < Decimal > deadNetTrackList = new list < Decimal > ();
                list < Decimal > NetSalesList = new List < Decimal > ();
                list < Decimal > ZITDList = new List < Decimal > ();
                list < Decimal > RebateList = new List < Decimal > ();
                Set < String > currentWMTPositionSet = new Set < String > ();
                Set < String > currentMCkTPositionSet = new Set < String > ();

                if (productCodeToNPRLineMap.keyset().contains(bidLine.Phoenix_Product__r.ProductCode)) {

                    for (Phoenix_NPR_Data__c NPRLine: productCodeToNPRLineMap.get(bidLine.Phoenix_Product__r.ProductCode)) {
                        //system.debug('contractnumber-->' + NPRLine.Phoenix_Contract_Number__c);
                        //system.debug('productCode---->' + bidLine.Phoenix_Product__r.ProductCode);
                            bidLine.Phoenix_Proposed_Est_VIP__c = NPRLine.Phoenix_GR_TrackingTier__c;

                        if (templateType == 'ClarusOne') {

                            if (NPRLine.Phoenix_Contract_Number__c == '3000001263' || NPRLine.Phoenix_Contract_Number__c == '3000000224' || NPRLine.Phoenix_Contract_Number__c == '3000000418' || NPRLine.Phoenix_Contract_Number__c == '3000000047' || NPRLine.Phoenix_Contract_Number__c == '3000000071') {
                                //system.debug('OS and RAD Units');
                                if (NPRLine.Phoenix_ABS__c != null && NPRLine.Phoenix_ABS__c > bidLine.Phoenix_Date_Fee__c) {
                                    bidLine.Phoenix_Date_Fee__c = (NPRLine.Phoenix_ABS__c != null ? NPRLine.Phoenix_ABS__c : 0);
                                }
                                bidLine.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c = bidLine.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c != null ? bidLine.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c : 0;
                                bidLine.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c += (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                                /*-- 3 Months Sales --*/
                                bidLine.Phoenix_12_Months_Actual_Sales__c = (bidLine.Phoenix_12_Months_Actual_Sales__c != null ? bidLine.Phoenix_12_Months_Actual_Sales__c : 0) + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                                //system.debug('=NPRLine.Phoenix_12Months_Sales_Unit__c--->' + bidLine.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c);
                                //system.debug('Product Family--->' + bidLine.Phoenix_Product_Family1__c);
                                //system.debug('=NPRLine.Phoenix_12Months_Sales_Unit__c--->' + NPRLine.Phoenix_12Months_Sales_Unit__c);
                                //system.debug('NPRLine.Phoenix_Contract_Price__c----->' + NPRLine.Phoenix_Contract_Price__c);
                                if (NPRLine.Phoenix_Contract_Price__c != null)
                                    oneStopAndRADCpList.add(NPRLine.Phoenix_Contract_Price__c);
                                if (NPRLine.Phoenix_Per_Unit_Rebate__c != null)
                                    oneStopAndRADPURList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                                if (NPRLine.Phoenix_CD__c != null && NPRLine.Phoenix_CD__c > bidLine.Phoenix_Cash_Terms__c) {
                                    bidLine.Phoenix_Cash_Terms__c = NPRLine.Phoenix_CD__c;
                                }
                                if (NPRLine.Phoenix_Rebate__c != null && NPRLine.Phoenix_Rebate__c > bidLine.Phoenix_Current_Rebate__c) {
                                    bidLine.Phoenix_Current_Rebate__c = NPRLine.Phoenix_Rebate__c;
                                }
                                if (NPRLine.Phoenix_RDC_NLC__c != null && NPRLine.Phoenix_RDC_NLC__c > bidLine.Phoenix_RDC_NLC__c) {
                                    bidLine.Phoenix_RDC_NLC__c = NPRLine.Phoenix_RDC_NLC__c;
                                }
                                if (NPRLine.Phoenix_Fee_Bonafied_Fee__c != null && NPRLine.Phoenix_Fee_Bonafied_Fee__c > bidLine.Phoenix_Current_Admin_Fee__c) {
                                    bidLine.Phoenix_Current_Admin_Fee__c = NPRLine.Phoenix_Fee_Bonafied_Fee__c;
                                }
                                if (NPRLine.Phoenix_CM_Fee__c != null && NPRLine.Phoenix_CM_Fee__c > bidLine.Phoenix_Contract_Mngment_Fee_Wholesaler__c) {
                                    bidLine.Phoenix_Contract_Mngment_Fee_Wholesaler__c = NPRLine.Phoenix_CM_Fee__c;
                                }
                                deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
                                NetSalesList.add(NPRLine.Phoenix_Net_Sales_Internal__c);
                                String curPosition = NPRLine.Phoenix_Product_Position__c != null ? NPRLine.Phoenix_Product_Position__c : '';
                                currentMCkTPositionSet.add(curPosition);

                            }
                            if (NPRLine.Phoenix_Contract_Number__c == '1000000120') {
                                if (NPRLine.Phoenix_ABS__c != null && NPRLine.Phoenix_ABS__c > bidLine.Phoenix_Date_Fee__c) {
                                    bidLine.Phoenix_Date_Fee__c = (NPRLine.Phoenix_ABS__c != null ? NPRLine.Phoenix_ABS__c : 0);
                                }
                                bidLine.Phoenix_WMT_Current_Direct_Units__c = bidLine.Phoenix_WMT_Current_Direct_Units__c != null ? bidLine.Phoenix_WMT_Current_Direct_Units__c : 0;
                                //system.debug('bidLine.Phoenix_WMT_Current_Direct_Units__c' + bidLine.Phoenix_WMT_Current_Direct_Units__c);
                                bidLine.Phoenix_WMT_Current_Direct_Units__c += (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                                //system.debug('bidLine.Phoenix_WMT_Current_Direct_Units__c' + bidLine.Phoenix_WMT_Current_Direct_Units__c);
                                //system.debug('Product Family--->' + bidLine.Phoenix_Product_Family1__c);
                                //system.debug('12months sales' + NPRLine.Phoenix_12Months_Sales_Unit__c);
                                bidLine.Phoenix_12_Months_IndirectSaleUnit__c = (bidLine.Phoenix_12_Months_IndirectSaleUnit__c != null ? bidLine.Phoenix_12_Months_IndirectSaleUnit__c : 0) + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                                if (NPRLine.Phoenix_Contract_Price__c != null)
                                    WMTDirectCpList.add(NPRLine.Phoenix_Contract_Price__c);
                                if (NPRLine.Phoenix_Per_Unit_Rebate__c != null)
                                    WMTDirectPURList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                                if (NPRLine.Phoenix_CD__c != null && NPRLine.Phoenix_CD__c > bidLine.Phoenix_Cash_Terms__c) {
                                    bidLine.Phoenix_Cash_Terms__c = NPRLine.Phoenix_CD__c;
                                }
                                if (NPRLine.Phoenix_Rebate__c != null && NPRLine.Phoenix_Rebate__c > bidLine.Phoenix_Invoice_Allowance__c) {
                                    bidLine.Phoenix_Invoice_Allowance__c = NPRLine.Phoenix_Rebate__c;
                                    //system.debug('rebate---->' + bidLine.Phoenix_Current_Rebate__c);
                                }
                                if (NPRLine.Phoenix_RDC_NLC__c != null && NPRLine.Phoenix_RDC_NLC__c > bidLine.Phoenix_RDC_NLC__c) {
                                    bidLine.Phoenix_RDC_NLC__c = NPRLine.Phoenix_RDC_NLC__c;
                                }
                                if (NPRLine.Phoenix_Fee_Bonafied_Fee__c != null && NPRLine.Phoenix_Fee_Bonafied_Fee__c > bidLine.Phoenix_Current_Admin_Fee__c) {
                                    bidLine.Phoenix_Current_Admin_Fee__c = NPRLine.Phoenix_Fee_Bonafied_Fee__c;
                                }
                                if (NPRLine.Phoenix_CM_Fee__c != null && NPRLine.Phoenix_CM_Fee__c > bidLine.Phoenix_Wholesaler_Price_Percent__c) {
                                    bidLine.Phoenix_Wholesaler_Price_Percent__c = NPRLine.Phoenix_CM_Fee__c;
                                }
                                deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
                                NetSalesList.add(NPRLine.Phoenix_Net_Sales_Internal__c);
                                String curPosition = NPRLine.Phoenix_Product_Position__c != null ? NPRLine.Phoenix_Product_Position__c : '';
                                currentWMTPositionSet.add(curPosition);

                            }
                            if (NPRLine.Phoenix_Contract_Number__c == '3000000143') {
                                if (NPRLine.Phoenix_ABS__c != null && NPRLine.Phoenix_ABS__c > bidLine.Phoenix_Date_Fee__c) {
                                    bidLine.Phoenix_Date_Fee__c = (NPRLine.Phoenix_ABS__c != null ? NPRLine.Phoenix_ABS__c : 0);
                                }
                                bidLine.Phoenix_WMT_Current_Indirect_Units__c = bidLine.Phoenix_WMT_Current_Indirect_Units__c != null ? bidLine.Phoenix_WMT_Current_Indirect_Units__c : 0;
                                bidLine.Phoenix_WMT_Current_Indirect_Units__c += (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                                bidLine.Phoenix_3_Months_Actual_Sales__c = (bidLine.Phoenix_3_Months_Actual_Sales__c != null ? bidLine.Phoenix_3_Months_Actual_Sales__c : 0) + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                                if (NPRLine.Phoenix_Contract_Price__c != null)
                                    WMTIndirectCpList.add(NPRLine.Phoenix_Contract_Price__c);
                                if (NPRLine.Phoenix_Per_Unit_Rebate__c != null)
                                    WMTIndirectPURList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                                if (NPRLine.Phoenix_CD__c != null && NPRLine.Phoenix_CD__c > bidLine.Phoenix_Cash_Terms__c) {
                                    bidLine.Phoenix_Cash_Terms__c = NPRLine.Phoenix_CD__c;
                                }
                                if (NPRLine.Phoenix_Rebate__c != null && NPRLine.Phoenix_Rebate__c > bidLine.Phoenix_Reduction__c) {
                                    bidLine.Phoenix_Reduction__c = NPRLine.Phoenix_Rebate__c;
                                }
                                if (NPRLine.Phoenix_RDC_NLC__c != null && NPRLine.Phoenix_RDC_NLC__c > bidLine.Phoenix_RDC_NLC__c) {
                                    bidLine.Phoenix_RDC_NLC__c = NPRLine.Phoenix_RDC_NLC__c;
                                }
                                if (NPRLine.Phoenix_Fee_Bonafied_Fee__c != null && NPRLine.Phoenix_Fee_Bonafied_Fee__c > bidLine.Phoenix_Current_Admin_Fee__c) {
                                    bidLine.Phoenix_Current_Admin_Fee__c = NPRLine.Phoenix_Fee_Bonafied_Fee__c;
                                }
                                if (NPRLine.Phoenix_CM_Fee__c != null && NPRLine.Phoenix_CM_Fee__c > bidLine.Phoenix_Retail_Indirect_Wholesaler_Fee__c) {
                                    bidLine.Phoenix_Retail_Indirect_Wholesaler_Fee__c = NPRLine.Phoenix_CM_Fee__c;
                                }
                                deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
                                NetSalesList.add(NPRLine.Phoenix_Net_Sales_Internal__c);

                            }


                        }

                    }
                    //take minimum of all oneStopAndRADCpList NPR prices
                    if (oneStopAndRADCpList.size() > 0) {
                        oneStopAndRADCpList.sort();
                        bidLine.Phoenix_OS_RAD_CP__c = oneStopAndRADCpList[0];
                    }
                    //take minimum of all deirect NPR prices
                    if (WMTDirectCpList.size() > 0) {
                        WMTDirectCpList.sort();
                        bidLine.Phoenix_WMT_Direct_CP__c = WMTDirectCpList[0];
                    }
                    //take minimum of all deirect NPR prices
                    if (WMTIndirectCpList.size() > 0) {
                        WMTIndirectCpList.sort();
                        bidLine.Phoenix_WMT_Indirect_CP__c = WMTIndirectCpList[0];
                    }

                    //take Max of all  NPR rebate
                    if (oneStopAndRADPURList.size() > 0) {
                        oneStopAndRADPURList.sort();
                        bidLine.Phoenix_OS_RAD_PUR__c = oneStopAndRADPURList[oneStopAndRADPURList.size() - 1];

                    }
                    if (currentMCkTPositionSet.size() > 0) {
                        List < String > currentPositionList = new List < String > (currentMCkTPositionSet);
                        bidLine.Phoenix_Current_MCK_Position__c = string.join(currentPositionList, ', ');
                    }
                    if (currentWMTPositionSet.size() > 0) {
                        List < String > currentPositionList = new List < String > (currentWMTPositionSet);
                        bidLine.Phoenix_Current_WMT_Position__c = string.join(currentPositionList, ', ');
                    }
                    if (WMTDirectPURList.size() > 0) {
                        WMTDirectPURList.sort();
                        bidLine.Phoenix_WMT_Direct_PUR__c = WMTDirectPURList[WMTDirectPURList.size() - 1];

                    }
                    if (WMTIndirectPURList.size() > 0) {
                        WMTIndirectPURList.sort();
                        bidLine.Phoenix_WMT_Indirect_PUR__c = WMTIndirectPURList[WMTIndirectPURList.size() - 1];

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
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Delegated_Approver__c,Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId order by Phoenix_Step__c];
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
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Marketing Rejected');
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
        if (flagSCMStop == false && flagMarketStop == false && !processStepLsit.isEmpty()) {
            Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
            list < Phoenix_Bid_Process_Steps__c > criteriaSteplist = new list < Phoenix_Bid_Process_Steps__c > ();
            map < string, Phoenix_Bid_Process_Steps__c > teamToStepMap = new map < string, Phoenix_Bid_Process_Steps__c > ();
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
            //system.debug('criteraStepsSet---' + criteraStepsSet);
            //system.debug('criteriaSteplist---' + criteriaSteplist.size());
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
                integer stepnumber = stepnameNoMap.get('Marketing');
                List < Phoenix_Bid_Process_Steps__c > nextSteps = stepMap.get(stepnumber + 1);
                //system.debug('nextSteps--->' + nextSteps);
                While(nextSteps != null && nextSteps[0].Phoenix_Status__c == 'Not Applicable') {
                    stepNumber += 1;
                    nextSteps = stepMap.get(stepNumber);
                }
                for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                    step.Phoenix_Status__c = 'In Process';
                }
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
   /* @AuraEnabled
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
        // //system.debug('stepnamemap--'+stepnameNoMap.get('Contracts')+1);
        ////system.debug('stepnamemap--'+stepMap.get(stepnameNoMap.get('Contracts')+1));
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
            Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId, nextSteps);
        } else {
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
            update bid;
        }
    }*/
    //Added Code by Rama
    
    @AuraEnabled 
    public static user fetchUser(){  
        return CompetitorInfoCLS.fetchUser();
    }

    //End Code by Rama
}