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
public class Phoenix_DirectOrderPriceUpdate {


    @AuraEnabled
    public static Wrapper getRelatedList(Id bidId) {
        Wrapper wrapperObject = new Wrapper();
        //String query = 'SELECT Name,Phoenix_Product__c,Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Net_Price_after_RebatesbeforeVIP__c, Phoenix_Bid__c,Phoenix_Case_Pack__c,Phoenix_Pkg_Size__c,Phoenix_Product_Family__c,Phoenix_NDC_National_Drug_Code__c,Phoenix_Product_Code__c,Phoenix_Compare_to_Brand_Name__c,Phoenix_Product_Director__c,Phoenix_Orange_Book_Rating__c,Phoenix_Throughput_cost__c,Phoenix_WAC__c,Phoenix_Current_Indirect_Selling_Unit__c	,Phoenix_Current_Direct_Selling_Unit__c,Phoenix_Total_Selling_Unit__c,Phoenix_Doses__c , Phoenix_Proposed_Indirect_Selling_Unit__c,Phoenix_Proposed_Direct_Selling_Unit__c, Phoenix_Final_Indirect_Selling_Units__c,Phoenix_Final_Direct_Selling_Units__c, Phoenix_Final_Total_Selling_Unit__c, Phoenix_Final_Annual_Extended_Units__c, Phoenix_Wholesaler_Diff_Price_Indirect__c, Phoenix_Current_Direct_Price__c, Phoenix_Current_Indirect_Price__c,  Phoenix_ProposedContract_Bid_Price_Sales__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Proposed_Current_Rebate__c, Phoenix_Current_Rebate__c, Phoenix_Proposed_Per_Unit_Rebate__c,Phoenix_Current_Per_Unit_Rebate__c, Phoenix_Gross_Contract_Sales__c, Phoenix_Value_Rebate__c,Phoenix_Value_Per_Unit_Rebate__c,Phoenix_Value_Admin_Fee__c	,Phoenix_Current_Admin_Fee__c,Phoenix_Value_Est_VIP__c,Phoenix_Sales_Out_Promotion__c,Phoenix_Initial_Order_Discount__c, Phoenix_Cash_Terms_Non_Weighted__c, Phoenix_Net_Sales_External__c ,Phoenix_Net_Sales_Internal__c ,Phoenix_Cash_Terms_Weighted__c, Phoenix_Estimated_Medicaid_Returns__c,Phoenix_Contr_Management_Fee_Wholesaler__c, Phoenix_Less_Cost__c, Phoenix_Th_Put_Margin__c, Phoenix_Net_Price_afterRebates_after_VIP__c,Phoenix_Net_Price_after_Rebates_Terms__c, Phoenix_Internal_Dead_Net_Price__c,Phoenix_TP_Margin__c, Phoenix_Budgeted_ASP_Q1_FY21__c,Phoenix_Sales_Notes__c, Phoenix_SCM_Notes__c, Phoenix_Pricing_Notes__c,Phoenix_Marketing_Notes__c,Phoenix_WAC_Check__c ,Phoenix_SSA_Hit__c   FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =: bidId limit 1000';
        //System.debug('query'+query);
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
        query = 'select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';

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
            if (lineItem.Phoenix_Marketing_Final_Approval__c == true && lineItem.Phoenix_Product_Director__c == userinfo.getName()) {
                showProceedBtn = false;
            }
        }
        boolean hasDirectorLines = true;
        if (!productDirectorList.contains(userinfo.getName())) {
            hasDirectorLines = false;
        }

        // system.debug('productDirectorList--->'+productDirectorList);

        //system.debug(UserInfo.getName());
        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, Phoenix_Approver__r.Name, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__r.Name);
        }
        string isMarketingApprovePerson;
        string isContractsApprovePerson;
        if (userTeamUserIdMap.containsKey('Marketing-' + UserInfo.getUserId())) {
            isMarketingApprovePerson = userTeamUserIdMap.get(('Marketing-' + UserInfo.getUserId()));
        }
        if (userTeamUserIdMap.containsKey('Contracts-' + UserInfo.getUserId())) {
            isContractsApprovePerson = userTeamUserIdMap.get(('Contracts-' + UserInfo.getUserId()));
        }
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        //wrapperObject.columnList = columnsList;
        wrapperObject.lineItemsList = quoteList;
        wrapperObject.bidRecord = bid;
        wrapperObject.productfamilyList = productFamilyList;
        wrapperObject.productDirectorList = productDirectorList;
        wrapperObject.loggedInUserName = UserInfo.getName();
        wrapperObject.isMarketingApprovePerson = isMarketingApprovePerson;
        wrapperObject.isContractsApprovePerson = isContractsApprovePerson;
        wrapperObject.showProceedBtn = showProceedBtn;
        wrapperObject.hasDirectorLines = hasDirectorLines;
        return wrapperObject;

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
        @AuraEnabled public string isContractsApprovePerson;
        @AuraEnabled public boolean showProceedBtn;
        @AuraEnabled public boolean hasDirectorLines;

        Wrapper() {
            columnList = new List < Columns > ();
            lineItemsList = new List < Phoenix_Bid_Line_Item__c > ();
            productfamilyList = new List < String > ();
            productDirectorList = new List < String > ();
            loggedInUserName = '';
            isMarketingApprovePerson = '';
            isContractsApprovePerson = '';

        }
    }


    @AuraEnabled
    public static void saveLineItems(List < Phoenix_Bid_Line_Item__c > LineItemList, Id LineItemId, string rebateHeader, string feeHeader, boolean isRebateChanged, boolean isFeeChanged) {
        List < Phoenix_Bid_Line_Item__c > lineList = [select id, name from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: LineItemId];
        if (lineList != null && lineList.size() > 0 && rebateHeader != '' || feeHeader != null) {
            for (Phoenix_Bid_Line_Item__c lineItem: lineList) {
                if (rebateHeader != '' && isRebateChanged == true)
                    lineItem.Phoenix_Rebate_G_N__c = rebateHeader;
                if (feeHeader != '' && isFeeChanged == true)
                    lineItem.Phoenix_Fee_G_N__c = feeHeader;
            }
        }

        update lineList;
    }

    @AuraEnabled
    public static void getselectOptions(sObject objObject, string fld) {
        /* List < String > allOpts = new list < String > ();
Schema.sObjectType objType = objObject.getSObjectType();
Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
MAP < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
List < Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();
for (Schema.PicklistEntry a: values) {
allOpts.add(a.getValue());
}
allOpts.sort();*/
        //return allOpts;
    }
    @AuraEnabled
    public static void deleteLineItems(String LineItemId) {
        if (LineItemId != null) {
            delete [SELECT Id FROM Phoenix_Bid_Line_Item__c WHERE Id =: LineItemId];
        }
    }
    @AuraEnabled
    public static Phoenix_Bid_Line_Item__c getCalcs(Phoenix_Bid_Line_Item__c LineItem, Id LineItemId, string currentValue, string fieldLabel) {
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
        if (currentValue != 'No Change' && fieldLabel == 'Dating') {
            LineItem.Phoenix_Current_MCK_Position__c = currentValue;
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
        query = 'select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where id = :LineItemId limit 1';
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
        query = 'select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : lineItemId';
        if (searchKey != null && searchKey.size() > 0) {
            query = query + ' AND Product_Family_Name__c =: searchKey';
        }
        if (sRxOtcList != null && sRxOtcList.size() > 0) {
            query = query + ' AND Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =: sRxOtcList';
        }
        if (searchPDList != null && searchPDList.size() > 0) {
            query = query + ' AND Phoenix_Product_Director__c =: searchPDList';
        }
        query = query + ' LIMIT 1000';
        List < Phoenix_Bid_Line_Item__c > lineItemsList = Database.query(query);

        // system.debug(lineItemsList);
        return lineItemsList;
    }
    @AuraEnabled
    public static list < Phoenix_Contract__c > getContracts(string customerID, string searchInput) {
        string act = 'Active';
        string query = 'select name,Phoenix_Contract_Internal_Description__c,Phoenix_Contract_External_Description__c from Phoenix_Contract__c where Phoenix_Contract_Status__c=:act';
        if (customerID != null) {
            query += ' and Phoenix_Customer__c=:customerID';
        }
        if (string.isNotBlank(searchInput)) {
            query += ' and ( name like \'%' + searchInput + '%\' or Phoenix_Contract_Internal_Description__c like \'%' + searchInput + '%\' or Phoenix_Contract_External_Description__c like  \'%' + searchInput + '%\')';
        }
        list < Phoenix_Contract__c > cntList = Database.query(query);
        return cntList;
    }

    @AuraEnabled
    public static void getNPRData(list < string > selectrcs, Id BidId, string templateType) {
        list < Phoenix_Bid_Line_Item__c > bildLines = [select id, name, Phoenix_Product__c, Phoenix_Product__r.Name, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Fee__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Cash_Discount__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebates__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_VIP__c, Phoenix_Current_Net_Sales_Internal__c, Phoenix_DeadNet_TrckGR__c, Phoenix_Product__r.ProductCode, Phoenix_Current_Direct_Selling_Unit__c, Phoenix_Current_Indirect_Selling_Unit__c, Phoenix_Current_Indirect_Price__c, Phoenix_Current_Direct_Price__c, Phoenix_Current_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Current_Rebate__c, Phoenix_Rebate_G_N__c, Phoenix_Fee_G_N__c, Phoenix_Current_Admin_Fee__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: BidId];
        list < Phoenix_NPR_Data__c > NPRDataLines = [select id, Name, Phoenix_Contract_Type__c, Phoenix_Net_Sales_Internal__c, Phoenix_Dead_Net_Tracking_GR__c, Phoenix_Contract_Price__c, Phoenix_Product__c, Phoenix_Product__r.ProductCode, Phoenix_12Months_Sales_Unit__c, Phoenix_12Months_Net_Sales__c, Phoenix_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Rebate__c, Phoenix_Rebate_G_N_Indicator__c, Phoenix_Bonafied_G_N_Indicator__c, Phoenix_Fee_Bonafied_Fee__c, Phoenix_Per_Unit_Bonfied_Fee__c, Phoenix_CD__c, Phoenix_GR_TrackingTier__c from Phoenix_NPR_Data__c where Phoenix_Contract_Number__c in: selectrcs];
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
        decimal cashDiscount = 0;
        decimal currentVip = 0;
        for (Phoenix_Bid_Line_Item__c bidLine: bildLines) {
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
            list < Decimal > directPriceList = new list < Decimal > ();
            list < Decimal > indirectPriceList = new list < Decimal > ();
            list < Decimal > perUnitRebateList = new list < Decimal > ();
            list < Decimal > deadNetTrackList = new list < Decimal > ();
            list < Decimal > NetSalesList = new List < Decimal > ();
            list < Decimal > ZITDList = new List < Decimal > ();
            list < Decimal > RebateList = new List < Decimal > ();
            if (productCodeToNPRLineMap.keyset().contains(bidLine.Phoenix_Product__r.ProductCode)) {
                for (Phoenix_NPR_Data__c NPRLine: productCodeToNPRLineMap.get(bidLine.Phoenix_Product__r.ProductCode)) {
                    if (templateType == 'Indirect' || templateType == 'Direct and Indirect') {
                        if (NPRLine.Phoenix_Contract_Type__c == 'Indirect') {
                            bidLine.Phoenix_Current_Indirect_Selling_Unit__c += NPRLine.Phoenix_12Months_Sales_Unit__c;
                            indirectPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                            cashDiscount = NPRLine.Phoenix_CD__c;
                            currentVip = NPRLine.Phoenix_GR_TrackingTier__c;
                        }
                        perUnitRebateList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                        deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
                        NetSalesList.add(NPRLine.Phoenix_Net_Sales_Internal__c);
                        ZITDList.add(NPRLine.Phoenix_ZITD_Value__c);
                        //bidLine.Phoenix_ZITD_Value__c=NPRLine.Phoenix_ZITD_Value__c;
                        RebateList.add(NPRLine.Phoenix_Rebate__c);
                        //bidLine.Phoenix_Current_Rebate__c=NPRLine.Phoenix_Rebate__c;
                        bidLine.Phoenix_Current_Admin_Fee__c = NPRLine.Phoenix_Fee_Bonafied_Fee__c;
                        if (string.isNotBlank(NPRLine.Phoenix_Rebate_G_N_Indicator__c)) {
                            string rbInd = NPRLine.Phoenix_Rebate_G_N_Indicator__c.deleteWhitespace();
                            decimal Net = decimal.valueOf(rbInd.substringBefore('N'));
                            decimal Gross = decimal.valueOf(rbInd.substringBetween('+', 'G'));
                            bidLine.Phoenix_Rebate_G_N__c = Gross == 0 ? 'Net' : 'Gross';
                        }
                        if (string.isNotBlank(NPRLine.Phoenix_Bonafied_G_N_Indicator__c)) {
                            string bnFInd = NPRLine.Phoenix_Bonafied_G_N_Indicator__c.deleteWhitespace();
                            decimal Net = decimal.valueOf(bnFInd.substringBefore('N'));
                            decimal Gross = decimal.valueOf(bnFInd.substringBetween('+', 'G'));
                            bidLine.Phoenix_Fee_G_N__c = Gross == 0 ? 'Net' : 'Gross';
                        }
                    }
                    if (templateType == 'Direct' || templateType == 'Direct and Indirect') {
                        if (NPRLine.Phoenix_Contract_Type__c == 'Direct') {
                            bidLine.Phoenix_Current_Direct_Selling_Unit__c += NPRLine.Phoenix_12Months_Sales_Unit__c;
                            directPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                            cashDiscount = NPRLine.Phoenix_CD__c;
                            currentVip = NPRLine.Phoenix_GR_TrackingTier__c;
                        }
                        perUnitRebateList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                        deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
                        NetSalesList.add(NPRLine.Phoenix_Net_Sales_Internal__c);
                        ZITDList.add(NPRLine.Phoenix_ZITD_Value__c);
                        // bidLine.Phoenix_ZITD_Value__c=NPRLine.Phoenix_ZITD_Value__c;
                        RebateList.add(NPRLine.Phoenix_Rebate__c);
                        // bidLine.Phoenix_Current_Rebate__c=NPRLine.Phoenix_Rebate__c;
                        bidLine.Phoenix_Current_Admin_Fee__c = NPRLine.Phoenix_Fee_Bonafied_Fee__c;
                        if (string.isNotBlank(NPRLine.Phoenix_Rebate_G_N_Indicator__c)) {
                            string rbInd = NPRLine.Phoenix_Rebate_G_N_Indicator__c.deleteWhitespace();
                            decimal Net = decimal.valueOf(rbInd.substringBefore('N'));
                            decimal Gross = decimal.valueOf(rbInd.substringBetween('+', 'G'));
                            bidLine.Phoenix_Rebate_G_N__c = Gross == 0 ? 'Net' : 'Gross';
                        }
                        if (string.isNotBlank(NPRLine.Phoenix_Bonafied_G_N_Indicator__c)) {
                            string bnFInd = NPRLine.Phoenix_Bonafied_G_N_Indicator__c.deleteWhitespace();
                            decimal Net = decimal.valueOf(bnFInd.substringBefore('N'));
                            decimal Gross = decimal.valueOf(bnFInd.substringBetween('+', 'G'));
                            bidLine.Phoenix_Fee_G_N__c = Gross == 0 ? 'Net' : 'Gross';
                        }
                    }
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
                //take Max of all  NPR rebate 
                if (perUnitRebateList.size() > 0) {
                    perUnitRebateList.sort();
                    bidLine.Phoenix_Current_Per_Unit_Rebate__c = perUnitRebateList[perUnitRebateList.size() - 1];
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
                    bidLine.Phoenix_Current_Rebate__c = RebateList[RebateList.size() - 1];
                }

            } else {
                bidLine.Phoenix_Current_Admin_Fee__c = bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Fee__c;
                bidLine.Phoenix_Current_Rebate__c = bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebates__c;
                currentVip = bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_VIP__c;
                cashDiscount = bidLine.Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Cash_Discount__c;
            }
        }
        // cashDiscount = currentCd != null ? currentCd : cashDiscount;
        Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidid, Phoenix_Current_CD__c = cashDiscount, Phoenix_Current_Value_Est_VIP__c = currentVip);
        update bid;
        //system.debug('finalbidlines--'+bildLines);
        update bildLines;
    }

}