public class BatchToSaveBBAData implements Database.Batchable < sObject > {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query =''; String strFields = ''; String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        for(String fieldName : fieldMap.keyset())
        {
            if(strFields == null || strFields == '') strFields = fieldName;
            else strFields = strFields + ' , ' + fieldName;
        }
        String bidId = 'a0C1K00000UzjNtUAJ';
        List<String> bidTypesToBeExcluded = new List<String>{'Contracts Only', 'Initial Order Discount for WAC Customers (No-Contract Price Offering)', 'Direct Order Form Pricing Update', 'IPA Floor Pricing Update', 'IPA Member Addition', 'SRx IPA Price Change', 'SRx IPA Product Addition', 'NEW Individual Pricing Agreement (IPA)', 'RCA/IPA Member GPO or Wholesaler Change', 'RCA Member Addition', 'VIP Rebate'};
            query = 'select Phoenix_Bid__r.Phoenix_Salesperson__c, Phoenix_Product__r.Product_Family__r.Name, Phoenix_Product__r.Product_Family__c, Phoenix_Product__r.Phoenix_Finished_Goods_Supplier_Name__c, Phoenix_Product__r.Phoenix_NDC_11__c, Phoenix_ProposedDirectGaintEagleUnits__c,Phoenix_Final_Direct_Selling_Units__c,Phoenix_ProposedIndirectAholdDelhaizeUni__c,Phoenix_Final_Indirect_Selling_Units__c,Phoenix_Customer_Approval_OTC__c,Phoenix_Proposed_Anda_Units__c, Phoenix_ProposedDirectAholdDelhaizeUnits__c,Phoenix_Proposed_RAD_Units__c,Phoenix_Proposed_WMT_Units__c,Phoenix_Proposed_Indirect_Selling_Unit__c,Phoenix_Proposed_OS_Units__c,Phoenix_Proposed_Direct_Selling_Unit__c,Phoenix_Throughput_cost__c, Phoenix_Product__r.Phoenix_Throughput_cost__c, Phoenix_Bid_Status__c, Phoenix_Final_Status__c, Phoenix_Product__r.Phoenix_Product_Director__c, Phoenix_Current_Anda_CP_Price__c,  Phoenix_Current_Retail_Indirect_Net__c,Phoenix_Current_Retail_Indirect_Price__c,Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Current_Direct_Price__c, Phoenix_OS_RAD_NCP__c, Phoenix_WMT_Direct_NCP__c, Phoenix_WMT_Indirect_NCP__c,Phoenix_Current_Retail_Direct_Price__c,Phoenix_Current_Wholesaler_Price__c, Phoenix_Bid__r.Phoenix_Bid_Owner__r.Name, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_NDC_Without_Dashes__c,Phoenix_Product_Code1__c, Phoenix_Product_Family__c,Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c, Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Customer_Type__c, Phoenix_Product__r.ProductCode, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Name, Phoenix_Customer__r.Name, Phoenix_Contract__r.Name, Phoenix_Contract__r.Phoenix_Contract_Number__c, Phoenix_SCM_Final_Approval__c, Phoenix_Final_Total_Selling_Unit__c, Phoenix_Total_SCM_Approved_Qty__c, Phoenix_Proposed_Sales__c,Phoenix_Bid_Template_Refrence__c, Phoenix_Current_ASP_Dose__c,Phoenix_Proposed_ASP_Dose__c,Phoenix_Total_Selling_Unit__c,Phoenix_Current_Indirect_Price__c,Phoenix_Current_Position__c,Phoenix_Override_Current_Direct_Units__c,Phoenix_Current_Direct_Selling_Unit__c,Phoenix_Override_Current_Indirect_Units__c,Phoenix_Current_Indirect_Selling_Unit__c,Phoenix_Current_Wholesaler_Units__c,Phoenix_Override_Current_Units__c,Phoenix_Current_Retail_Direct_Units__c,Phoenix_Current_Retail_Indirect_Units__c,Phoenix_Current_Anda_Units__c,Phoenix_OS_and_RAD_Cur_Direct_Units_C__c,Phoenix_WMT_Current_Direct_Units__c,Phoenix_Proposed_Smith_Drug_Units__c,Phoenix_WMT_Current_Indirect_Units__c,Phoenix_Wholesaler_Diff_Price_Indirect__c,Phoenix_Final_Direct_Selling_Units_Calc__c, (SELECT Id, Name, Phoenix_Customer_Response_Date__c, Phoenix_Customer_Decline_Reasons__c, Final_Direct_Price__c, Final_Indirect_Price__c, Phoenix_Bid_Status__c,Phoenix_Award_Position__c,Phoenix_Supply_Effective_Date__c,Phoenix_Price_Effective_Date__c,Phoenix_Awarded_Quantity__c,Phoenix_Final_Approvd_Pricing_Contracts__c,Phoenix_Final_Total_Selling_Unit__c FROM Customer_Response_Lines__r),(SELECT Id,Phoenix_OverrideMajorUnits__c,Phoenix_3MonAnnualMajorSellingUnits__c,Phoenix_Current_Major_Contract_Price__c,Phoenix_Proposed_Major_Contract_Price__c, Phoenix_Proposed_CvsDirectContractPrice__c, Vision_Effective_Date_of_Removal__c,Phoenix_Proposed_CVS_DirSellingUnits__c,Phoenix_Proposed_CVS_IndirSellingUnits__c,Phoenix_Proposed_Cardinal_Units__c,Phoenix_Proposed_Major_Units__c FROM BidLineItemsExtn__r), Phoenix_Product__r.name from ' + SobjectApiName +' WHERE Phoenix_Bid__r.Phoenix_Bid_Type__c NOT IN: bidTypesToBeExcluded AND Phoenix_Bid__c =:bidId' ;
        if(Test.isRunningTest())query += ' LIMIT 1';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List <Phoenix_Bid_Line_Item__c> bidLineItemsList) {
        try{
            if(bidLineItemsList.size() > 0){
                VisionBidBusinessAnalysisCls.finalWrapper wrap = new VisionBidBusinessAnalysisCls.finalWrapper();
                List<VisionBidBusinessAnalysisCls.ScmWrapper> scmWrapperList = new List<VisionBidBusinessAnalysisCls.ScmWrapper>(); Set<String> productIds = new Set<String>(); Set<String> contractNos = new Set<String>();List<Phoenix_Bid_Line_Item__c> openItemsList = new List<Phoenix_Bid_Line_Item__c>();
                List<Phoenix_NPR_Data__c> nprData = new List<Phoenix_NPR_Data__c>(); Map<String, Phoenix_NPR_Data__c> nprMap = new Map<String, Phoenix_NPR_Data__c>(); Map<String, String> accountMap = new Map<String, String>(); Set<String> bids = new Set<String>();
                for(Phoenix_Bid_Line_Item__c bidLineItem : bidLineItemsList){
                    if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c != 'Product Discontinuation Process' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c != 'Mass Product Removals'){
                        bids.add(bidLineItem.Phoenix_Bid__r.Name);
                        VisionBidBusinessAnalysisCls.ScmWrapper scmWrapperObj; /*new VisionBidBusinessAnalysisCls.ScmWrapper();*/ Boolean isOTCType = false; Boolean isOpen = false;
                        
                        Date supplyEffectiveDate = (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0) ? bidLineItem.Customer_Response_Lines__r[0].Phoenix_Supply_Effective_Date__c : null;
                        Date priceEffectiveDate = (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0) ? bidLineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c : null;
                        Date customerResponseDate = (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0) ? bidLineItem.Customer_Response_Lines__r[0].Phoenix_Customer_Response_Date__c : null;
                        if(supplyEffectiveDate != null) scmWrapperObj.supplyEffectiveDate = supplyEffectiveDate.month()+'/'+supplyEffectiveDate.day()+'/'+supplyEffectiveDate.year();
                        if(priceEffectiveDate != null) scmWrapperObj.priceEffectiveDate = priceEffectiveDate.month()+'/'+priceEffectiveDate.day()+'/'+priceEffectiveDate.year();
                        if(customerResponseDate != null) scmWrapperObj.customerResponseDate = customerResponseDate.month()+'/'+customerResponseDate.day()+'/'+customerResponseDate.year();
                        scmWrapperObj.proposedBottles = (bidLineItem.Phoenix_SCM_Final_Approval__c == false) ? bidLineItem.Phoenix_Final_Total_Selling_Unit__c : (bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ;                              
                            scmWrapperObj.proposedSales = bidLineItem.Phoenix_Proposed_Sales__c ;
                        scmWrapperObj.templateType = bidLineItem.Phoenix_Bid_Template_Refrence__c;
                        scmWrapperObj.finalDirectPrice = (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0) ? bidLineItem.Customer_Response_Lines__r[0].Final_Direct_Price__c : null;
                        scmWrapperObj.finalIndirectPrice = (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0) ? bidLineItem.Customer_Response_Lines__r[0].Final_Indirect_Price__c : null;
                        scmWrapperObj.showDropdown = false;
                        scmWrapperObj.previousDeadnet = bidLineItem.Phoenix_Current_ASP_Dose__c; scmWrapperObj.currentDeadnet = bidLineItem.Phoenix_Proposed_ASP_Dose__c;
                        scmWrapperObj.bidType = bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c; scmWrapperObj.previousQty = bidLineItem.Phoenix_Total_Selling_Unit__c;
                        scmWrapperObj.previousIndirectPrice = (bidLineItem.Phoenix_Current_Indirect_Price__c != null)? bidLineItem.Phoenix_Current_Indirect_Price__c: 0;
                        scmWrapperObj.previousPosition = bidLineItem.Phoenix_Current_Position__c; scmWrapperObj.bidLineItem = bidLineItem;
                        if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC New Product' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Short Dated' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Price Change'
                           || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Product Addition' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Rebate Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Volume Review'){
                               isOTCType = true;  
                               scmWrapperObj.isOTCType = true;
                               scmWrapperObj.previousQty = (bidLineItem.Phoenix_Override_Current_Direct_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Direct_Units__c : (bidLineItem.Phoenix_Current_Direct_Selling_Unit__c != null)?bidLineItem.Phoenix_Current_Direct_Selling_Unit__c:0;
                               scmWrapperObj.proposedBottles = (bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c != null)?bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c:0;
                               if((bidLineItem.Phoenix_Customer_Approval_OTC__c == '' || bidLineItem.Phoenix_Customer_Approval_OTC__c == null || bidLineItem.Phoenix_Customer_Approval_OTC__c == 'Send Back to Marketing') || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number'))){
                                   scmWrapperObj.finalDirectSellingUnits = (bidLineItem.Phoenix_Proposed_Direct_Selling_Unit__c != null) ? bidLineItem.Phoenix_Proposed_Direct_Selling_Unit__c : 0;       
                                   scmWrapperObj.awardedQty = scmWrapperObj.finalDirectSellingUnits;
                                   if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change') scmWrapperObj.awardedQty = scmWrapperObj.previousQty;
                               }
                           }
                        else if(bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Net Indirect Pricing' || bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Direct and Indirect' || bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Econdisc' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB'){
                            scmWrapperObj.overrideCurrentDirectUnits = (bidLineItem.Phoenix_Override_Current_Direct_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Direct_Units__c : (bidLineItem.Phoenix_Current_Direct_Selling_Unit__c != null)?bidLineItem.Phoenix_Current_Direct_Selling_Unit__c:0;
                            scmWrapperObj.overrideCurrentIndirectUnits = (bidLineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Indirect_Units__c : (bidLineItem.Phoenix_Current_Indirect_Selling_Unit__c != null)?bidLineItem.Phoenix_Current_Indirect_Selling_Unit__c:0;
                            scmWrapperObj.previousQty = scmWrapperObj.overrideCurrentDirectUnits + scmWrapperObj.overrideCurrentIndirectUnits;
                            if(isOTCType == true) if(bidLineItem.Phoenix_Customer_Approval_OTC__c == '' || bidLineItem.Phoenix_Customer_Approval_OTC__c == null || bidLineItem.Phoenix_Customer_Approval_OTC__c == 'Send Back to Marketing')isOpen = true;
                            else if((bidLineItem.Phoenix_bid__r.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))) isOpen = true;
                            if((isOpen || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number')))){
                                if(bidLineItem.Phoenix_bid__r.Phoenix_Customer_Type__c == 'Net Indirect Pricing'){
                                    scmWrapperObj.finalDirectSellingUnits = (bidLineItem.Phoenix_Proposed_Direct_Selling_Unit__c != null) ? bidLineItem.Phoenix_Proposed_Direct_Selling_Unit__c : 0;
                                    scmWrapperObj.finalIndirectSellingUnits = (bidLineItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null) ? bidLineItem.Phoenix_Proposed_Indirect_Selling_Unit__c : 0;
                                    scmWrapperObj.awardedQty = scmWrapperObj.finalDirectSellingUnits + scmWrapperObj.finalIndirectSellingUnits;
                                } else{
                                    scmWrapperObj.finalDirectSellingUnits = (bidLineItem.Phoenix_Final_Direct_Selling_Units__c != null) ? bidLineItem.Phoenix_Final_Direct_Selling_Units__c : 0;
                                    scmWrapperObj.finalIndirectSellingUnits = (bidLineItem.Phoenix_Final_Indirect_Selling_Units__c != null) ? bidLineItem.Phoenix_Final_Indirect_Selling_Units__c : 0;
                                    scmWrapperObj.awardedQty = scmWrapperObj.finalDirectSellingUnits + scmWrapperObj.finalIndirectSellingUnits;
                                }
                                if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change'){
                                    scmWrapperObj.finalDirectSellingUnits = scmWrapperObj.overrideCurrentDirectUnits;
                                    scmWrapperObj.finalIndirectSellingUnits = scmWrapperObj.overrideCurrentIndirectUnits;
                                    scmWrapperObj.awardedQty = (scmWrapperObj.finalDirectSellingUnits != null ? scmWrapperObj.finalDirectSellingUnits : 0) + (scmWrapperObj.finalIndirectSellingUnits != null ? scmWrapperObj.finalIndirectSellingUnits : 0);
                                }
                            }	
                        }
                        else if(bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'BASE/DSH'){
                            scmWrapperObj.overrideCurrentDirectUnits = (bidLineItem.Phoenix_Override_Current_Direct_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Direct_Units__c : (bidLineItem.Phoenix_Current_Wholesaler_Units__c != null)?bidLineItem.Phoenix_Current_Wholesaler_Units__c:0;
                            scmWrapperObj.overrideCurrentIndirectUnits = (bidLineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Indirect_Units__c : (bidLineItem.Phoenix_Current_Anda_Units__c != null)?bidLineItem.Phoenix_Current_Anda_Units__c:0;
                            scmWrapperObj.overrideCurrentUnits = (bidLineItem.Phoenix_Override_Current_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Units__c : (bidLineItem.Phoenix_Current_Retail_Direct_Units__c != null)?bidLineItem.Phoenix_Current_Retail_Direct_Units__c:0;
                            scmWrapperObj.previousQty = scmWrapperObj.overrideCurrentDirectUnits + scmWrapperObj.overrideCurrentIndirectUnits + scmWrapperObj.overrideCurrentUnits;
                            if((bidLineItem.Phoenix_bid__r.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))) isOpen = true;
                            if((isOpen || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number')))){
                                scmWrapperObj.baseUnits = (bidLineItem.Phoenix_Proposed_Smith_Drug_Units__c != null) ? bidLineItem.Phoenix_Proposed_Smith_Drug_Units__c : 0;
                                scmWrapperObj.dshUnits = (bidLineItem.Phoenix_Proposed_Anda_Units__c != null) ? bidLineItem.Phoenix_Proposed_Anda_Units__c :0;
                                scmWrapperObj.autoSubUnits = (bidLineItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c != null) ? bidLineItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c :0;
                                if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change'){
                                    scmWrapperObj.baseUnits = scmWrapperObj.overrideCurrentDirectUnits;
                                    scmWrapperObj.dshUnits = scmWrapperObj.overrideCurrentIndirectUnits;
                                    scmWrapperObj.autoSubUnits = scmWrapperObj.overrideCurrentUnits;
                                }
                                scmWrapperObj.awardedQty = scmWrapperObj.baseUnits + scmWrapperObj.dshUnits + scmWrapperObj.autoSubUnits;
                            }
                        }
                        else if(bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'ROS'){
                            scmWrapperObj.overrideCVSDirectUnits = (bidLineItem.Phoenix_Override_Current_Direct_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Direct_Units__c : (bidLineItem.Phoenix_Current_Retail_Direct_Units__c != null)?bidLineItem.Phoenix_Current_Retail_Direct_Units__c:0;
                            scmWrapperObj.overrideCVSIndirectUnits = (bidLineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Indirect_Units__c : (bidLineItem.Phoenix_Current_Retail_Indirect_Units__c != null)?bidLineItem.Phoenix_Current_Retail_Indirect_Units__c:0;
                            scmWrapperObj.overrideCardinalUnits = (bidLineItem.Phoenix_Override_Current_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Units__c : (bidLineItem.Phoenix_Current_Wholesaler_Units__c != null)?bidLineItem.Phoenix_Current_Wholesaler_Units__c:0;
                            scmWrapperObj.overrideMajorUnits = (bidLineItem.BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c != null) ? bidLineItem.BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c : (bidLineItem.BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c != null)?bidLineItem.BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c:0;
                            scmWrapperObj.previousQty = scmWrapperObj.overrideCVSDirectUnits + scmWrapperObj.overrideCVSIndirectUnits + scmWrapperObj.overrideCardinalUnits + scmWrapperObj.overrideMajorUnits;
                            if((bidLineItem.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))) isOpen = true;
                            if((isOpen || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number')))){
                                scmWrapperObj.CVSDirectUnits = bidLineItem.BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c;
                                scmWrapperObj.CVSIndirectUnits = bidLineItem.BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c;
                                scmWrapperObj.cardinalUnits = bidLineItem.BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c;
                                scmWrapperObj.majorContractUnits = bidLineItem.BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c;
                                if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change'){
                                    scmWrapperObj.CVSDirectUnits = scmWrapperObj.overrideCVSDirectUnits;
                                    scmWrapperObj.CVSIndirectUnits = scmWrapperObj.overrideCVSIndirectUnits;
                                    scmWrapperObj.cardinalUnits = scmWrapperObj.overrideCardinalUnits;
                                    scmWrapperObj.majorContractUnits = scmWrapperObj.overrideMajorUnits;
                                }
                                scmWrapperObj.awardedQty = (scmWrapperObj.CVSDirectUnits != null ? scmWrapperObj.CVSDirectUnits : 0) + (scmWrapperObj.CVSIndirectUnits != null ? scmWrapperObj.CVSIndirectUnits : 0) + (scmWrapperObj.cardinalUnits != null ? scmWrapperObj.cardinalUnits : 0) + (scmWrapperObj.majorContractUnits != null ? scmWrapperObj.majorContractUnits : 0);
                            }
                        }
                        else if(bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'RXSS'){
                            scmWrapperObj.overrideCurrentDirectUnits = (bidLineItem.Phoenix_Override_Current_Direct_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Direct_Units__c : (bidLineItem.Phoenix_Current_Retail_Direct_Units__c != null)?bidLineItem.Phoenix_Current_Retail_Direct_Units__c:0;
                            scmWrapperObj.overrideCurrentIndirectUnits = (bidLineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Indirect_Units__c : (bidLineItem.Phoenix_Current_Wholesaler_Units__c != null)?bidLineItem.Phoenix_Current_Wholesaler_Units__c:0;
                            scmWrapperObj.currentRetailDirectUnits = (bidLineItem.Phoenix_Current_Anda_Units__c != null) ? bidLineItem.Phoenix_Current_Anda_Units__c : 0;
                            scmWrapperObj.currentRetailIndirectUnits = (bidLineItem.Phoenix_Current_Retail_Indirect_Units__c != null) ? bidLineItem.Phoenix_Current_Retail_Indirect_Units__c : 0;
                            scmWrapperObj.previousQty = scmWrapperObj.overrideCurrentDirectUnits + scmWrapperObj.overrideCurrentIndirectUnits + scmWrapperObj.currentRetailDirectUnits + scmWrapperObj.currentRetailIndirectUnits;
                            if((bidLineItem.Phoenix_bid__r.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))) isOpen = true;
                            if((isOpen || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number')))){
                                scmWrapperObj.directAholDelhaizeUnits = (bidLineItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c != null) ? bidLineItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c : 0;
                                scmWrapperObj.directGaintEagleUnits = (bidLineItem.Phoenix_ProposedDirectGaintEagleUnits__c != null) ? bidLineItem.Phoenix_ProposedDirectGaintEagleUnits__c :0;
                                scmWrapperObj.proposedSmithDrugUnits = (bidLineItem.Phoenix_Proposed_Smith_Drug_Units__c != null) ? bidLineItem.Phoenix_Proposed_Smith_Drug_Units__c :0;
                                scmWrapperObj.proposedAndaUnits = (bidLineItem.Phoenix_Proposed_Anda_Units__c != null) ? bidLineItem.Phoenix_Proposed_Anda_Units__c :0;
                                scmWrapperObj.retailIndirectUnits = (bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c != null) ? bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c :0;
                                scmWrapperObj.awardedQty = scmWrapperObj.directAholDelhaizeUnits + scmWrapperObj.directGaintEagleUnits + scmWrapperObj.proposedSmithDrugUnits + scmWrapperObj.proposedAndaUnits + scmWrapperObj.retailIndirectUnits;
                            }
                        }
                        else if(bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'ClarusOne'){
                            scmWrapperObj.overrideCurrentDirectUnits = (bidLineItem.Phoenix_Override_Current_Direct_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Direct_Units__c : (bidLineItem.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c != null)?bidLineItem.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c:0;
                            scmWrapperObj.overrideCurrentIndirectUnits = (bidLineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Indirect_Units__c : (bidLineItem.Phoenix_WMT_Current_Direct_Units__c != null)?bidLineItem.Phoenix_WMT_Current_Direct_Units__c:0;
                            scmWrapperObj.currentRetailDirectUnits = (bidLineItem.Phoenix_Proposed_Smith_Drug_Units__c != null) ? bidLineItem.Phoenix_Proposed_Smith_Drug_Units__c : (bidLineItem.Phoenix_WMT_Current_Indirect_Units__c != null)?bidLineItem.Phoenix_WMT_Current_Indirect_Units__c:0;
                            scmWrapperObj.previousQty = scmWrapperObj.overrideCurrentDirectUnits + scmWrapperObj.overrideCurrentIndirectUnits + scmWrapperObj.currentRetailDirectUnits;
                            if((bidLineItem.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))) isOpen = true;
                            if((isOpen || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number')))){
                                scmWrapperObj.osUnits = (bidLineItem.Phoenix_Proposed_OS_Units__c != null) ? bidLineItem.Phoenix_Proposed_OS_Units__c : 0;
                                scmWrapperObj.radUnits = (bidLineItem.Phoenix_Proposed_RAD_Units__c != null) ? bidLineItem.Phoenix_Proposed_RAD_Units__c : 0;
                                scmWrapperObj.wmtUnits = (bidLineItem.Phoenix_Proposed_WMT_Units__c != null) ? bidLineItem.Phoenix_Proposed_WMT_Units__c : 0;
                                if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change'){
                                    scmWrapperObj.osUnits = scmWrapperObj.overrideCurrentDirectUnits;
                                    scmWrapperObj.radUnits = scmWrapperObj.overrideCurrentIndirectUnits;
                                    scmWrapperObj.wmtUnits = scmWrapperObj.currentRetailDirectUnits;
                                }
                                scmWrapperObj.awardedQty = scmWrapperObj.osUnits + scmWrapperObj.radUnits + scmWrapperObj.wmtUnits;
                            }
                        }
                        else if(bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Humana Indirect retail'){
                            scmWrapperObj.previousQty = (bidLineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Indirect_Units__c : (bidLineItem.Phoenix_Current_Indirect_Selling_Unit__c != null)?bidLineItem.Phoenix_Current_Indirect_Selling_Unit__c:0;
                            scmWrapperObj.currentIndirectPrice = (bidLineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != null) ? bidLineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c : 0;
                            if((bidLineItem.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))) isOpen = true;
                            if((isOpen || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number')))){
                                scmWrapperObj.finalDirectSellingUnits = (bidLineItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null) ? bidLineItem.Phoenix_Proposed_Indirect_Selling_Unit__c : 0;
                                scmWrapperObj.awardedQty = scmWrapperObj.finalDirectSellingUnits;
                            }
                        }
                        else if(bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Sams Club'){
                            scmWrapperObj.awardedPrice = (bidLineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != null) ? bidLineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c : 0;
                            scmWrapperObj.previousIndirectPrice = (bidLineItem.Phoenix_Current_Indirect_Price__c != null) ? bidLineItem.Phoenix_Current_Indirect_Price__c : 0;
                            if((bidLineItem.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))) isOpen = true;
                            if((isOpen || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number')))){
                                scmWrapperObj.finalDirectSellingUnits = (bidLineItem.Phoenix_Final_Direct_Selling_Units__c != null) ? bidLineItem.Phoenix_Final_Direct_Selling_Units__c : 0;
                                scmWrapperObj.finalIndirectSellingUnits = (bidLineItem.Phoenix_Final_Indirect_Selling_Units__c != null) ? bidLineItem.Phoenix_Final_Indirect_Selling_Units__c : 0;
                                scmWrapperObj.awardedQty = scmWrapperObj.finalDirectSellingUnits + scmWrapperObj.finalIndirectSellingUnits;
                                if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change') scmWrapperObj.awardedQty = scmWrapperObj.previousQty;
                            }
                        }              
                        else if(bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Direct'){
                            if((bidLineItem.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))) isOpen = true;
                            if((isOpen || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number')))){
                                scmWrapperObj.finalDirectSellingUnits = (bidLineItem.Phoenix_Proposed_Direct_Selling_Unit__c != null) ? bidLineItem.Phoenix_Proposed_Direct_Selling_Unit__c : 0;
                                scmWrapperObj.awardedQty = scmWrapperObj.finalDirectSellingUnits;
                                if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change') scmWrapperObj.awardedQty = scmWrapperObj.previousQty;
                            }
                        }  else if(bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Walgreens' || bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'ABC Progen' || bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'ABC Pharmagen' 
                                   || bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Costco' || bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Indirect' || bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Sams Club' 
                                   || bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Government Pricing'){
                                       if((bidLineItem.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))) isOpen = true;
                                       if((isOpen || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number')))){
                                           scmWrapperObj.finalDirectSellingUnits = (bidLineItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null) ? bidLineItem.Phoenix_Proposed_Indirect_Selling_Unit__c : 0;
                                           scmWrapperObj.awardedQty = scmWrapperObj.finalDirectSellingUnits;
                                           if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change') scmWrapperObj.awardedQty = scmWrapperObj.previousQty;
                                       }
                                   }
                        if((bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer')){
                            if(scmWrapperObj.previousQty > 0){
                                scmWrapperObj.awardedQty = 0; scmWrapperObj.businessCategory = 'Business Lost';   
                            } else{
                                scmWrapperObj.businessCategory = 'No Effect';
                            }
                        }
                        else if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            if(bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Direct' || isOTCType == true){
                                if(bidLineItem.Phoenix_Current_Direct_Price__c > 0){
                                    scmWrapperObj.previousDeadnet = (bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0;
                                    scmWrapperObj.currentDeadnet = (bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0;
                                    scmWrapperObj.businessCategory = 'Business Retained';
                                } else scmWrapperObj.businessCategory = 'Business Gained';
                            } else if(bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Net Indirect Pricing' || bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Direct and Indirect' || bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Econdisc' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB'){
                                if(bidLineItem.Phoenix_Current_Direct_Price__c > 0 || bidLineItem.Phoenix_Current_Indirect_Price__c > 0){
                                    scmWrapperObj.previousDeadnet = (bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0;
                                    scmWrapperObj.currentDeadnet = (bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0;
                                    scmWrapperObj.businessCategory = 'Business Retained';
                                } else scmWrapperObj.businessCategory = 'Business Gained';
                            } else if(bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'BASE/DSH'){
                                if(bidLineItem.Phoenix_Current_Retail_Direct_Price__c > 0 || bidLineItem.Phoenix_Current_Retail_Indirect_Net__c > 0 || bidLineItem.Phoenix_Current_Retail_Indirect_Price__c > 0){
                                    scmWrapperObj.previousDeadnet = (bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0;
                                    scmWrapperObj.currentDeadnet = (bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0;
                                    scmWrapperObj.businessCategory = 'Business Retained';
                                } else scmWrapperObj.businessCategory = 'Business Gained';
                            } else if(bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Walgreens' || bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'ABC Progen' || bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'ABC Pharmagen' 
                                      || bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Costco' || bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Indirect' || bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Sams Club' 
                                      || bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Government Pricing'){
                                          if(scmWrapperObj.previousIndirectPrice > 0){
                                              scmWrapperObj.previousDeadnet = (bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0;
                                              scmWrapperObj.currentDeadnet = (bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0;
                                              scmWrapperObj.businessCategory = 'Business Retained';
                                          } else scmWrapperObj.businessCategory = 'Business Gained';
                                      } else if(bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'ROS'){
                                          if((((bidLineItem.Phoenix_Current_Direct_Price__c != null)? bidLineItem.Phoenix_Current_Direct_Price__c: 0) + ((bidLineItem.Phoenix_Current_Indirect_Price__c != null)? bidLineItem.Phoenix_Current_Indirect_Price__c: 0) + ((bidLineItem.Phoenix_Current_Wholesaler_Price__c != null)? bidLineItem.Phoenix_Current_Wholesaler_Price__c: 0)) > 0 || (bidLineItem.BidLineItemsExtn__r!=null && bidLineItem.BidLineItemsExtn__r.size() > 0 && bidLineItem.BidLineItemsExtn__r[0] != null  && bidLineItem.BidLineItemsExtn__r[0].Phoenix_Current_Major_Contract_Price__c > 0)){
                                              scmWrapperObj.previousDeadnet = (bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0;
                                              scmWrapperObj.currentDeadnet = (bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0;
                                              scmWrapperObj.businessCategory = 'Business Retained';
                                          } else scmWrapperObj.businessCategory = 'Business Gained';
                                      }  else if(bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'RXSS'){
                                          if((((bidLineItem.Phoenix_Current_Retail_Direct_Price__c != null)? bidLineItem.Phoenix_Current_Retail_Direct_Price__c: 0) + ((bidLineItem.Phoenix_Current_Retail_Indirect_Price__c != null)? bidLineItem.Phoenix_Current_Retail_Indirect_Price__c: 0) + ((bidLineItem.Phoenix_Current_Wholesaler_Price__c != null)? bidLineItem.Phoenix_Current_Wholesaler_Price__c: 0) + ((bidLineItem.Phoenix_Current_Anda_CP_Price__c != null)? bidLineItem.Phoenix_Current_Anda_CP_Price__c: 0)) > 0){
                                              scmWrapperObj.previousDeadnet = (bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0;
                                              scmWrapperObj.currentDeadnet = (bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0;
                                              scmWrapperObj.businessCategory = 'Business Retained';
                                          } else scmWrapperObj.businessCategory = 'Business Gained';
                                      }  else if(bidLineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'ClarusOne'){
                                          if((((bidLineItem.Phoenix_OS_RAD_NCP__c != null)? bidLineItem.Phoenix_OS_RAD_NCP__c: 0) + ((bidLineItem.Phoenix_WMT_Direct_NCP__c != null)? bidLineItem.Phoenix_WMT_Direct_NCP__c: 0) + ((bidLineItem.Phoenix_WMT_Indirect_NCP__c != null)? bidLineItem.Phoenix_WMT_Indirect_NCP__c: 0)) > 0){
                                              scmWrapperObj.previousDeadnet = (bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0;
                                              scmWrapperObj.currentDeadnet = (bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0;
                                              scmWrapperObj.businessCategory = 'Business Retained';
                                          } else scmWrapperObj.businessCategory = 'Business Gained';
                                      }
                        }
                        else if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c != 'Price Change' && bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c != 'OTC Price Change' && bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number')) {
                            scmWrapperObj.businessCategory = 'No Effect';  
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
                        } else if((bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Price Change') && bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded')) {
                            scmWrapperObj.awardedQty = 0;
                            scmWrapperObj.businessCategory = 'Business Lost';
                        }
                        if(scmWrapperObj.isOTCType == true){
                            if(bidLineItem.Phoenix_Customer_Approval_OTC__c == '' || bidLineItem.Phoenix_Customer_Approval_OTC__c == null || bidLineItem.Phoenix_Customer_Approval_OTC__c == 'Send Back to Marketing'){
                                scmWrapperObj.businessCategory = 'Open Status';
                                scmWrapperObj.awardedQty = ((scmWrapperObj.awardedQty != null) ? scmWrapperObj.awardedQty : 0);
                                scmWrapperObj.previousQty = ((scmWrapperObj.previousQty != null) ? scmWrapperObj.previousQty : 0);
                                scmWrapperObj.previousDeadnet = ((bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0);
                                scmWrapperObj.currentDeadnet = ((bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0);
                                scmWrapperObj.bidStatus = 'Pending';
                                openItemsList.add(bidLineItem);
                            }
                        }
                        else if((bidLineItem.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))){
                            scmWrapperObj.businessCategory = 'Open Status';
                            scmWrapperObj.awardedQty = ((scmWrapperObj.awardedQty != null) ? scmWrapperObj.awardedQty : 0);
                            scmWrapperObj.previousQty = ((scmWrapperObj.previousQty != null) ? scmWrapperObj.previousQty : 0);
                            scmWrapperObj.previousDeadnet = ((bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0);
                            scmWrapperObj.currentDeadnet = ((bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0);
                            scmWrapperObj.bidStatus = 'Pending';
                            openItemsList.add(bidLineItem);
                        }
                        else if(bidLineItem.Phoenix_Final_Status__c != 'Approved' && bidLineItem.Phoenix_Final_Status__c != 'Not Approved'){
                            scmWrapperObj.businessCategory = 'Open Status';
                            scmWrapperObj.awardedQty = ((scmWrapperObj.awardedQty != null) ? scmWrapperObj.awardedQty : 0);
                            scmWrapperObj.previousQty = ((scmWrapperObj.previousQty != null) ? scmWrapperObj.previousQty : 0);
                            scmWrapperObj.previousDeadnet = ((bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0);
                            scmWrapperObj.currentDeadnet = ((bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0);
                            scmWrapperObj.bidStatus = 'Pending';
                            openItemsList.add(bidLineItem);
                        }
                        if(scmWrapperObj.previousQty > 0 && scmWrapperObj.awardedQty > 0) scmWrapperObj.priceVariance = (((scmWrapperObj.currentDeadnet != null)? scmWrapperObj.currentDeadnet: 0) - ((scmWrapperObj.previousDeadnet != null)? scmWrapperObj.previousDeadnet: 0)) * ((scmWrapperObj.awardedQty != null)? scmWrapperObj.awardedQty: 0);
                        else scmWrapperObj.priceVariance = 0;
                        if(scmWrapperObj.previousQty > 0) scmWrapperObj.volumeVariance = (((scmWrapperObj.awardedQty != null)? scmWrapperObj.awardedQty: 0) - ((scmWrapperObj.previousQty != null)? scmWrapperObj.previousQty: 0)) * ((scmWrapperObj.previousDeadnet != null)? scmWrapperObj.previousDeadnet: 0);
                        else if(scmWrapperObj.awardedQty > 0) scmWrapperObj.volumeVariance = ((scmWrapperObj.currentDeadnet != null)? scmWrapperObj.currentDeadnet: 0) * ((scmWrapperObj.awardedQty != null)? scmWrapperObj.awardedQty: 0);
                        else scmWrapperObj.volumeVariance = 0;
                        scmWrapperObj.currentTPT = ((((bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0) * ((scmWrapperObj.awardedQty != null) ? scmWrapperObj.awardedQty : 0))-(((bidLineItem.Phoenix_Throughput_cost__c != null) ? bidLineItem.Phoenix_Throughput_cost__c : 0)) * ((scmWrapperObj.awardedQty != null) ? scmWrapperObj.awardedQty : 0));
                        scmWrapperObj.previousTPT = ((((bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0) * ((scmWrapperObj.previousQty != null) ? scmWrapperObj.previousQty : 0))-(((bidLineItem.Phoenix_Throughput_cost__c != null) ? bidLineItem.Phoenix_Throughput_cost__c : 0)) * ((scmWrapperObj.previousQty != null) ? scmWrapperObj.previousQty : 0));
                        scmWrapperObj.tptVariance = scmWrapperObj.currentTPT - scmWrapperObj.previousTPT;
                        if(scmWrapperObj.currentTPT != 0 && scmWrapperObj.currentTPT != null && scmWrapperObj.currentDeadnet != 0 && scmWrapperObj.currentDeadnet != null && scmWrapperObj.awardedQty !=0 && scmWrapperObj.awardedQty !=null) scmWrapperObj.currentTPTPercent = scmWrapperObj.currentTPT/(scmWrapperObj.currentDeadnet * scmWrapperObj.awardedQty);   
                        else scmWrapperObj.currentTPTPercent = 0;
                        if(scmWrapperObj.previousTPT != 0 && scmWrapperObj.previousTPT != null && scmWrapperObj.previousDeadnet != 0 && scmWrapperObj.previousDeadnet != null && scmWrapperObj.previousQty !=0 && scmWrapperObj.previousQty != null) scmWrapperObj.previousTPTPercent = scmWrapperObj.previousTPT/(scmWrapperObj.previousDeadnet * scmWrapperObj.previousQty);   
                        else scmWrapperObj.previousTPTPercent = 0;
                        if(scmWrapperObj.previousTPT != 0 && (scmWrapperObj.currentTPT - scmWrapperObj.previousTPT) != 0) scmWrapperObj.isTPTPercentNaN = false;
                        else scmWrapperObj.isTPTPercentNaN = true;
                        if(scmWrapperObj.businessCategory != null) {
                            system.debug('Wrapper Record: '+scmWrapperObj);
                            scmWrapperList.add(scmWrapperObj);
                        }
                    }
                }
                wrap.scmWrapperList = scmWrapperList; 
                wrap.bids = bids.size();
            }
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'BatchToSaveBBAData', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
    public void finish(Database.BatchableContext BC) {
        
    }
    
}