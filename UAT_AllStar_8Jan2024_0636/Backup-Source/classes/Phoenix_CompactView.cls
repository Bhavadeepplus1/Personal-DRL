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
public class Phoenix_CompactView {
    @AuraEnabled
    public static List < CompactWrapper > getScmData(String bidId) {
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
        query = 'select ' + strFields + ', Product_Family__r.Name, Phoenix_Product__r.name from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved  ORDER BY Product_Family_Name__c ASC';
        List < Phoenix_Bid_Line_Item__c > bidLineItemsList = Database.query(query);
        List < CompactWrapper > compactWrapperList = new List < CompactWrapper > ();
        Decimal copyofMonthlyDamand = 0;
        Phoenix_Bid__c bid = [SELECT Id, Name, Phoenix_Bid_Type__c, Phoenix_Customer_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE ID =: bidId];
        /*Wrapper wrapperObject = new Wrapper();
        wrapperObject.bidRecord = bid;
        return wrapperObject;*/
        //CompactWrapper compactWrapperObj = new CompactWrapper();
        //compactWrapperObj.bidRecord=bid;
        for (Phoenix_Bid_Line_Item__c bidLineItem: bidLineItemsList) {
            if (bidLineItem.Product_Family_Name__c != null && bidLineItem.Phoenix_Product_Code1__c != null) {
                CompactWrapper compactWrapperObj = new CompactWrapper();
                compactWrapperObj.bidRecord = bid;
                compactWrapperObj.ndc = bidLineItem.Phoenix_NDC__c;
                compactWrapperObj.productName = bidLineItem.Phoenix_Product__r.Name;
                compactWrapperObj.pkgSize = bidLineItem.Phoenix_Pkg_Size1__c;
                compactWrapperObj.productFamily = bidLineItem.Product_Family_Name__c;
                compactWrapperObj.productDirector = bidLineItem.Phoenix_Product_Director1__c;
                compactWrapperObj.throughputCost = bidLineItem.Phoenix_Throughput_cost__c;
                compactWrapperObj.currentDirectSellingUnit = bidLineItem.Phoenix_Current_Direct_Selling_Unit__c;
                compactWrapperObj.currentInDirectSellingUnit = bidLineItem.Phoenix_Current_Indirect_Selling_Unit__c;
                compactWrapperObj.totalSellingUnit = bidLineItem.Phoenix_Total_Selling_Unit__c;
                compactWrapperObj.proposedDirectSellingUnit = bidLineItem.Phoenix_Proposed_Direct_Selling_Unit__c;
                compactWrapperObj.proposedInDirectSellingUnit = bidLineItem.Phoenix_Proposed_Indirect_Selling_Unit__c;
                compactWrapperObj.finalTotalSellingUnit = bidLineItem.Phoenix_Final_Total_Selling_Unit__c;
                compactWrapperObj.guidancePrice = bidLineItem.Phoenix_Guidance_Price__c;
                compactWrapperObj.currentDirectPrice = bidLineItem.Phoenix_Current_Direct_Price__c;
                compactWrapperObj.currentDirectPrice = bidLineItem.Phoenix_Current_Direct_Price__c;
                compactWrapperObj.currentInDirectPrice = bidLineItem.Phoenix_Current_Indirect_Price__c;
                compactWrapperObj.proposedContractBidPriceSales = bidLineItem.Phoenix_ProposedContract_Bid_Price_Sales__c;
                compactWrapperObj.proposedContractBidPriceMarketing = bidLineItem.Phoenix_ProposedContractBidPriceMktng__c;
                compactWrapperObj.wholesalerDiffPriceIndirect = bidLineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c;
                compactWrapperObj.internalDeadNetPrice = bidLineItem.Phoenix_Internal_Dead_Net_Price__c;
                compactWrapperObj.netSalesInternal = bidLineItem.Phoenix_Net_Sales_Internal__c;
                compactWrapperObj.thPutMargin = bidLineItem.Phoenix_Th_Put_Margin__c;
                compactWrapperObj.tPMargin = bidLineItem.Phoenix_TP_Margin__c;
                compactWrapperObj.currentDeadNetPrice = bidLineItem.Phoenix_Current_ASP_Dose__c;
                compactWrapperObj.currentSales = bidLineItem.Phoenix_Current_Sales_Finance__c;
                compactWrapperObj.currentThPutMargin = bidLineItem.Phoenix_Current_TP_Margin__c;
                compactWrapperObj.currentTPMargin = bidLineItem.Phoenix_Current_TP_MarginPercent__c;
                compactWrapperObj.variancePrice = bidLineItem.Phoenix_Difference_Price__c;
                compactWrapperObj.varianceVolume = bidLineItem.Phoenix_Difference_Volume__c;
                compactWrapperObj.varianceSales = bidLineItem.Phoenix_Difference_Sales__c;
                compactWrapperObj.varianceMargin = bidLineItem.Phoenix_Difference_Margin__c;
                compactWrapperObj.budgetedASP = bidLineItem.Phoenix_Budgeted_ASP1__c;
                compactWrapperObj.salesNotes = bidLineItem.Phoenix_Sales_Notes__c;
                compactWrapperObj.SCMApproval = bidLineItem.Phoenix_SCM_Approval_Y_N__c;
                compactWrapperObj.totalSCMApprovedQty = bidLineItem.Phoenix_Total_SCM_Approved_Qty__c;
                compactWrapperObj.estimatedLeadTime = bidLineItem.Phoenix_Estimated_Lead_Time_Days__c;
                compactWrapperObj.marketingApproval = bidLineItem.Phoenix_Marketing_Approval__c;
                compactWrapperObj.marketingNotes = bidLineItem.Phoenix_Marketing_Notes__c;
                compactWrapperObj.ssaHit = bidLineItem.Phoenix_SSA_Hit__c;
                compactWrapperList.add(compactWrapperObj);


            }
        }
        system.debug('compactWrapperListSize----->' + compactWrapperList.size());
        system.debug('compactWrapperList----->' + compactWrapperList);
        return compactWrapperList;

    }

    public class CompactWrapper {

        @AuraEnabled Public String ndc;
        @AuraEnabled Public String productName;
        @AuraEnabled Public decimal pkgSize;
        @AuraEnabled Public String productFamily;
        @AuraEnabled Public String productDirector;
        @AuraEnabled Public decimal throughputCost;
        @AuraEnabled Public decimal currentDirectSellingUnit;
        @AuraEnabled Public decimal currentInDirectSellingUnit;
        @AuraEnabled Public decimal totalSellingUnit;
        @AuraEnabled Public decimal proposedDirectSellingUnit;
        @AuraEnabled Public decimal proposedInDirectSellingUnit;
        @AuraEnabled Public decimal finalTotalSellingUnit;
        @AuraEnabled Public decimal guidancePrice;
        @AuraEnabled Public decimal currentDirectPrice;
        @AuraEnabled Public decimal currentInDirectPrice;
        @AuraEnabled Public decimal proposedContractBidPriceSales;
        @AuraEnabled Public decimal proposedContractBidPriceMarketing;
        @AuraEnabled Public decimal wholesalerDiffPriceIndirect;
        @AuraEnabled Public decimal internalDeadNetPrice;
        @AuraEnabled Public decimal netSalesInternal;
        @AuraEnabled Public decimal thPutMargin;
        @AuraEnabled Public decimal tPMargin;
        @AuraEnabled Public decimal currentDeadNetPrice;
        @AuraEnabled Public decimal currentSales;
        @AuraEnabled Public decimal currentThPutMargin;
        @AuraEnabled Public decimal currentTPMargin;
        @AuraEnabled Public decimal variancePrice;
        @AuraEnabled Public decimal varianceVolume;
        @AuraEnabled Public decimal varianceSales;
        @AuraEnabled Public decimal varianceMargin;
        @AuraEnabled Public decimal budgetedASP;
        @AuraEnabled Public String salesNotes;
        @AuraEnabled Public String SCMApproval;
        @AuraEnabled Public decimal totalSCMApprovedQty;
        @AuraEnabled Public String estimatedLeadTime;
        @AuraEnabled Public String marketingApproval;
        @AuraEnabled Public String marketingNotes;
        @AuraEnabled Public decimal ssaHit;
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        @AuraEnabled public boolean isSCMApprovePerson;


        CompactWrapper() {
            bidRecord = new Phoenix_Bid__c();
            //console.log('bid record-->'+bidRecord.Phoenix_Customer_Type__c);
            //isSCMApprovePerson=false;
        }



    }

}