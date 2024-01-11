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
public class Phoenix_RejectedStatusCls {
    @AuraEnabled
    public static list < AggregateResult > getAllTotals(Id bidId) {
        AggregateResult[] groupedResults = [select sum(Phoenix_Current_Indirect_Selling_Unit__c) cisu, sum(Phoenix_Current_Direct_Selling_Unit__c) cdsu,
            sum(Phoenix_Proposed_Indirect_Selling_Unit__c) pisu, sum(Phoenix_Proposed_Direct_Selling_Unit__c) pdsu,
            sum(Phoenix_Net_Sales_Internal__c) netsint, sum(Phoenix_Less_Cost__c) lesscost, sum(Phoenix_Th_Put_Margin__c) thptm,
            sum(Phoenix_Internal_Dead_Net_Price__c) intdead from Phoenix_Bid_Line_Item__c where
            Phoenix_Bid__c =: bidId and Phoenix_Final_Status__c != 'Not Approved'
        ];
        return groupedResults;
    }
    
    
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
    public static Wrapper getRelatedList(Id bidId) {
        Wrapper wrapperObject = new Wrapper();
        Phoenix_Bid__c bid = [SELECT Id,Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,Phoenix_Approval_Status__c,Phoenix_Is_Re_Bid__c, Phoenix_Previous_Bid__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        
        //String query = 'SELECT Name,Phoenix_Product__c,Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Net_Price_after_RebatesbeforeVIP__c, Phoenix_Bid__c,Phoenix_Case_Pack__c,Phoenix_Pkg_Size__c,Phoenix_Product_Family__c,Phoenix_NDC_National_Drug_Code__c,Phoenix_Product_Code__c,Phoenix_Compare_to_Brand_Name__c,Phoenix_Product_Director__c,Phoenix_Orange_Book_Rating__c,Phoenix_Throughput_cost__c,Phoenix_WAC__c,Phoenix_Current_Indirect_Selling_Unit__c	,Phoenix_Current_Direct_Selling_Unit__c,Phoenix_Total_Selling_Unit__c,Phoenix_Doses__c , Phoenix_Proposed_Indirect_Selling_Unit__c,Phoenix_Proposed_Direct_Selling_Unit__c, Phoenix_Final_Indirect_Selling_Units__c,Phoenix_Final_Direct_Selling_Units__c, Phoenix_Final_Total_Selling_Unit__c, Phoenix_Final_Annual_Extended_Units__c, Phoenix_Wholesaler_Diff_Price_Indirect__c, Phoenix_Current_Direct_Price__c, Phoenix_Current_Indirect_Price__c,  Phoenix_ProposedContract_Bid_Price_Sales__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Proposed_Current_Rebate__c, Phoenix_Current_Rebate__c, Phoenix_Proposed_Per_Unit_Rebate__c,Phoenix_Current_Per_Unit_Rebate__c, Phoenix_Gross_Contract_Sales__c, Phoenix_Value_Rebate__c,Phoenix_Value_Per_Unit_Rebate__c,Phoenix_Value_Admin_Fee__c	,Phoenix_Current_Admin_Fee__c,Phoenix_Value_Est_VIP__c,Phoenix_Sales_Out_Promotion__c,Phoenix_Initial_Order_Discount__c, Phoenix_Cash_Terms_Non_Weighted__c, Phoenix_Net_Sales_External__c ,Phoenix_Net_Sales_Internal__c ,Phoenix_Cash_Terms_Weighted__c, Phoenix_Estimated_Medicaid_Returns__c,Phoenix_Contr_Management_Fee_Wholesaler__c, Phoenix_Less_Cost__c, Phoenix_Th_Put_Margin__c, Phoenix_Net_Price_afterRebates_after_VIP__c,Phoenix_Net_Price_after_Rebates_Terms__c, Phoenix_Internal_Dead_Net_Price__c,Phoenix_TP_Margin__c, Phoenix_Budgeted_ASP_Q1_FY21__c,Phoenix_Sales_Notes__c, Phoenix_SCM_Notes__c, Phoenix_Pricing_Notes__c,Phoenix_Marketing_Notes__c,Phoenix_WAC_Check__c ,Phoenix_SSA_Hit__c   FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =: bidId limit 1000';
        //System.debug('query'+query);
        String query = '';
        String bidLineStrFields = fieldApiList('Phoenix_Bid_Line_Item__c');
        String bidLineExtStrFields = fieldApiList('Phoenix_BidLineItemExtn__c');
        String bidLineItemExtObjname = 'BidLineItemsExtn__r';
        string notApproved = 'Not Approved';
        String bidLineItemObjname = 'Phoenix_Bid_Line_Item__c';

        query = 'select Phoenix_Contract__r.Name,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,Phoenix_Contract__r.Id,Phoenix_Customer__r.Name,Phoenix_Customer__r.Id,Phoenix_Bid__r.Phoenix_Is_Re_Bid__c,Phoenix_Previous_Bid__r.Name,Phoenix_Previous_LineItem__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + bidLineStrFields;
        
        if(bid.Phoenix_Customer_Type__c == 'ROS'){
            query += ',( SELECT '+bidLineExtStrFields+' FROM '+bidLineItemExtObjname+')';
        }
        query += ' from ' + bidLineItemObjname + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c =: notApproved ORDER BY Product_Family_Name__c ASC';
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
        for (Phoenix_Bid_Line_Item__c lineItem: quoteList) {
            if (!productFamilyList.contains(lineItem.Product_Family_Name__c)) {
                // Columns column = new Columns();
                // column.label = string.valueof(lineItem.Phoenix_Product_Family__c) ;
                // column.value = string.valueof(lineItem.Phoenix_Product_Family__c) + 's';
                // columnsList.add(column);
                productFamilyList.add(lineItem.Product_Family_Name__c);
                if (lineItem.Phoenix_Product_Director__c != null) {
                    productDirectorList.add(lineItem.Phoenix_Product_Director__c);
                }

            }
        }

        // system.debug('quoteList--->'+columnsList);
        //wrapperObject.columnList = columnsList;
        wrapperObject.lineItemsList = quoteList;
        wrapperObject.bidRecord = bid;
        wrapperObject.productfamilyList = productFamilyList;
        wrapperObject.productDirectorList = productDirectorList;
        return wrapperObject;

    }
    
    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > getupdatedforExport(Id bidId) {
        String bidLineStrFields = fieldApiList('Phoenix_Bid_Line_Item__c');
        String bidLineExtStrFields = fieldApiList('Phoenix_BidLineItemExtn__c');
        string notApproved = 'Not Approved';
        String bidLineItemObjname = 'Phoenix_Bid_Line_Item__c';
        String bidLineItemExtObjname = 'BidLineItemsExtn__r';//'Phoenix_BidLineItemExtn__r';
        String query = 'select Phoenix_Bid__r.Phoenix_Rebate__c, Phoenix_Previous_LineItem__r.Name,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,'+
            +'Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,'+
            +'Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,'+
            +'Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c, ' + bidLineStrFields +',( SELECT '+bidLineExtStrFields+' FROM '+bidLineItemExtObjname+') FROM '+bidLineItemObjname+' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c =: notApproved';
        
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
        }
        return quoteList;
    }
    
    @AuraEnabled
    public static List < Phoenix_Bid_Line_Item__c > getReBidLineInfo(string productId, string bidId) {
        system.debug('---------productId-----' + productId);
        system.debug('---------bidId-----' + bidId);
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Is_Re_Bid__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        string ultimateParent = bid.Phoenix_Ultimate_Parent__c;
        list < Phoenix_Bid__c > bidUltimateList = [SELECT Id, Phoenix_Is_Re_Bid__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Phoenix_Ultimate_Parent__c =: ultimateParent and Id !=: bidId];
        set < string > parentRebidIds = new set < string > ();
        for (Phoenix_Bid__c pb: bidUltimateList) {
            parentRebidIds.add(pb.Id);

        }

        parentRebidIds.add(ultimateParent);
        system.debug('-----------parentRebidIds--------------' + parentRebidIds);

        list < Phoenix_Bid_Line_Item__c > reBidLineItemList = [SELECT id, Phoenix_Wholesaler_Sales_Price__c, Phoenix_Current_Retail_Indirect_Price__c, Phoenix_Retail_Direct_Sales_Price__c, Phoenix_Current_Retail_Direct_Price__c, Phoenix_Retail_Direct_Price__c, Phoenix_Retail_Indirect_Price__c, Phoenix_Retail_Direct_Guidance_Price__c, Phoenix_Wholesaler_Guidance_Price__c, Phoenix_Bid__r.CreatedDate, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Ultimate_Parent__c, Phoenix_Bid__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Guidance_Price__c FROM Phoenix_Bid_Line_Item__c WHERE(Phoenix_Product__c =: productId AND Phoenix_Bid__c IN: parentRebidIds) ORDER BY Phoenix_Bid__r.Name ASC LIMIT 30000];
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

        Wrapper() {
            columnList = new List < Columns > ();
            lineItemsList = new List < Phoenix_Bid_Line_Item__c > ();
            productfamilyList = new List < String > ();
            productDirectorList = new List < String > ();

        }
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
        if (currentValue != 'No Change' && fieldLabel == 'ContractApproval') {
            LineItem.Phoenix_Contract_Approval__c = currentValue;
        }
        if (currentValue != 'No Change' && fieldLabel == 'MarketApproval') {
            LineItem.Phoenix_Marketing_Approval__c = currentValue;
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
        string notApproved = 'Not Approved';
        query = 'select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : lineItemId AND Phoenix_Final_Status__c =: notApproved';
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
    
    //This method is for ROS template. getting extn object details.
    @auraEnabled
    public static Phoenix_BidLineItemExtn__c getChildExtnRecord(Id bliId){
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
        String bidLineExtStrFields = 'SELECT '+strFields+' FROM '+bidLineItemExtObjname+' WHERE Phoenix_Bid_Line_Item__c =: bliId LIMIT 1';
        Phoenix_BidLineItemExtn__c obj = database.query(bidLineExtStrFields);
        return obj;
    }
}