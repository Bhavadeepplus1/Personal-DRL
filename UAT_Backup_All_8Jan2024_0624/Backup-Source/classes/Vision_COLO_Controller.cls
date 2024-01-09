public class Vision_COLO_Controller {    
    @AuraEnabled 
    public static bidListWrapper getDataBasedOnQuarter(List<Integer> month, List<Integer> year, String productType, String productDirector){
        bidListWrapper wrapper = new bidListWrapper();
        try{
            List<String> approvalStatus = new List<String>{'Closed', 'Customer\'s Update', 'Customer Rejected', 'Vistex Update'};
                List<String> lackInventoryStatus = new List<String>{'Closed', 'Supply Chain Rejected'}; 
                    String notApproved = 'N- Not Approved';
                List<String> bidStatus = new List<String>{'Awarded', 'Declined by Customer'};    
                    List<String> bidTypes = new List<String>{'New Product Launch', 'New Customer', 'Product Addition', 'Price Change', 'OTC New Product', 'OTC Price Change', 'OTC Product Addition', 'OTC RFP', 'RFP Bids', 'Good Dated OTB', 'Short Dated OTB', 'OTC OTB Good Dated', 'OTC OTB Short Dated', 'Volume Review Only', 'OTC Volume Review'};
                        String query = 'select Product_Family_Name__c, Product_Family__r.Name, Phoenix_Total_DRL_Share__c, Phoenix_Product__r.Product_Family__r.Name, Phoenix_Net_Sales_External__c, CIP_Status_Internal_Use__c, Product_Family__c, Phoenix_Product_Code__c, Phoenix_Throughput_Cost1__c, Phoenix_Net_Sales_Internal__c, Finance_Current_Sales__c, Phoenix_Current_TP_Margin__c, Phoenix_Proposed_TP_Margin__c, Phoenix_Product__r.Phoenix_Is_partner_product__c, Phoenix_DRL_Margin_DRL__c, Phoenix_Bid__r.Phoenix_Salesperson__c,Phoenix_Product__r.Family,Phoenix_Current_Sales_Finance__c, Phoenix_Throughput_cost__c, Phoenix_Product__r.Phoenix_NDC_11__c, Phoenix_Final_Direct_Selling_Units__c,Phoenix_ProposedIndirectAholdDelhaizeUni__c,Phoenix_ProposedDirectGaintEagleUnits__c,Phoenix_Final_Indirect_Selling_Units__c,Phoenix_Customer_Approval_OTC__c,Phoenix_Proposed_Anda_Units__c,Phoenix_ProposedDirectAholdDelhaizeUnits__c, Phoenix_Proposed_RAD_Units__c,Phoenix_Proposed_WMT_Units__c,Phoenix_Proposed_Indirect_Selling_Unit__c,Phoenix_Proposed_OS_Units__c,Phoenix_Proposed_Direct_Selling_Unit__c, Phoenix_Product__r.Phoenix_Throughput_cost__c, Phoenix_Bid_Status__c, Phoenix_Final_Status__c, Phoenix_Product__r.Phoenix_Product_Director__c, Phoenix_Current_Anda_CP_Price__c,  Phoenix_Current_Retail_Indirect_Net__c,Phoenix_Current_Retail_Indirect_Price__c,Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Current_Direct_Price__c, Phoenix_OS_RAD_NCP__c, Phoenix_WMT_Direct_NCP__c, Phoenix_WMT_Indirect_NCP__c,Phoenix_Current_Retail_Direct_Price__c,Phoenix_Current_Wholesaler_Price__c, Phoenix_Bid__r.Phoenix_Bid_Owner__r.Name, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_NDC_Without_Dashes__c,Phoenix_Product_Code1__c, Phoenix_Product_Family__c,Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c, Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Customer_Type__c, Phoenix_Product__r.ProductCode, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Name, Phoenix_Customer__r.Name, Phoenix_Contract__r.Name, Phoenix_Contract__r.Phoenix_Contract_Number__c, Phoenix_SCM_Final_Approval__c, Phoenix_Final_Total_Selling_Unit__c, Phoenix_Total_SCM_Approved_Qty__c, Phoenix_Proposed_Sales__c,Phoenix_Bid_Template_Refrence__c, Phoenix_Current_ASP_Dose__c,Phoenix_Proposed_ASP_Dose__c,Phoenix_Total_Selling_Unit__c,Phoenix_Current_Indirect_Price__c,Phoenix_Current_Position__c,Phoenix_Override_Current_Direct_Units__c,Phoenix_Current_Direct_Selling_Unit__c,Phoenix_Override_Current_Indirect_Units__c,Phoenix_Current_Indirect_Selling_Unit__c,Phoenix_Current_Wholesaler_Units__c,Phoenix_Override_Current_Units__c,Phoenix_Current_Retail_Direct_Units__c,Phoenix_Current_Retail_Indirect_Units__c,Phoenix_Current_Anda_Units__c,Phoenix_OS_and_RAD_Cur_Direct_Units_C__c,Phoenix_WMT_Current_Direct_Units__c,Phoenix_Proposed_Smith_Drug_Units__c,Phoenix_WMT_Current_Indirect_Units__c,Phoenix_Wholesaler_Diff_Price_Indirect__c,Phoenix_Final_Direct_Selling_Units_Calc__c, (SELECT Id, Name, Phoenix_Customer_Response_Date__c, Phoenix_Customer_Decline_Reasons__c, Final_Direct_Price__c, Final_Indirect_Price__c, Phoenix_Bid_Status__c,Phoenix_Award_Position__c,Phoenix_Supply_Effective_Date__c,Phoenix_Price_Effective_Date__c,Phoenix_Awarded_Quantity__c,Phoenix_Final_Approvd_Pricing_Contracts__c,Phoenix_Final_Total_Selling_Unit__c,Phoenix_Lead_Time_Days__c FROM Customer_Response_Lines__r),(SELECT Id,Phoenix_OverrideMajorUnits__c,Phoenix_3MonAnnualMajorSellingUnits__c,Phoenix_Current_Major_Contract_Price__c,Phoenix_Proposed_Major_Contract_Price__c, Phoenix_Proposed_CvsDirectContractPrice__c, Vision_Effective_Date_of_Removal__c,Phoenix_Proposed_CVS_DirSellingUnits__c,Phoenix_Proposed_CVS_IndirSellingUnits__c,Phoenix_Proposed_Cardinal_Units__c,Phoenix_Proposed_Major_Units__c FROM BidLineItemsExtn__r), Phoenix_Product__r.name from Phoenix_Bid_Line_Item__c where Phoenix_Customer_Response_Line__c != null AND Phoenix_Customer_Response_Line__r.Phoenix_Bid_Status__c IN:bidStatus AND Phoenix_Bid__r.Phoenix_Approval_Status__c IN:approvalStatus AND Phoenix_Bid__r.Phoenix_Bid_Type__c IN:bidTypes';
            string query2 = 'select Product_Family_Name__c, Product_Family__r.Name, Phoenix_Total_DRL_Share__c, Phoenix_Product__r.Product_Family__r.Name,Phoenix_Net_Sales_External__c, CIP_Status_Internal_Use__c, Product_Family__c, Phoenix_Product_Code__c, Phoenix_Throughput_Cost1__c, Phoenix_Latest_Estimate__c, Phoenix_SCM_Rejection_Reason1__c, Phoenix_Net_Sales_Internal__c, Finance_Current_Sales__c, Phoenix_Current_TP_Margin__c, Phoenix_Proposed_TP_Margin__c, Phoenix_Product__r.Phoenix_Is_partner_product__c, Phoenix_DRL_Margin_DRL__c, Phoenix_Bid__r.Phoenix_Salesperson__c,Phoenix_Product__r.Family,Phoenix_Current_Sales_Finance__c, Phoenix_Throughput_cost__c, Phoenix_Product__r.Phoenix_NDC_11__c, Phoenix_Final_Direct_Selling_Units__c,Phoenix_ProposedIndirectAholdDelhaizeUni__c,Phoenix_ProposedDirectGaintEagleUnits__c,Phoenix_Final_Indirect_Selling_Units__c,Phoenix_Customer_Approval_OTC__c,Phoenix_Proposed_Anda_Units__c,Phoenix_ProposedDirectAholdDelhaizeUnits__c, Phoenix_Proposed_RAD_Units__c,Phoenix_Proposed_WMT_Units__c,Phoenix_Proposed_Indirect_Selling_Unit__c,Phoenix_Proposed_OS_Units__c,Phoenix_Proposed_Direct_Selling_Unit__c, Phoenix_Product__r.Phoenix_Throughput_cost__c, Phoenix_Bid_Status__c, Phoenix_Final_Status__c, Phoenix_Product__r.Phoenix_Product_Director__c, Phoenix_Current_Anda_CP_Price__c,  Phoenix_Current_Retail_Indirect_Net__c,Phoenix_Current_Retail_Indirect_Price__c,Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Current_Direct_Price__c, Phoenix_OS_RAD_NCP__c, Phoenix_WMT_Direct_NCP__c, Phoenix_WMT_Indirect_NCP__c,Phoenix_Current_Retail_Direct_Price__c,Phoenix_Current_Wholesaler_Price__c, Phoenix_Bid__r.Phoenix_Bid_Owner__r.Name, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_NDC_Without_Dashes__c,Phoenix_Product_Code1__c, Phoenix_Product_Family__c,Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c, Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Customer_Type__c, Phoenix_Product__r.ProductCode, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Name, Phoenix_Customer__r.Name, Phoenix_Contract__r.Name, Phoenix_Contract__r.Phoenix_Contract_Number__c, Phoenix_SCM_Final_Approval__c, Phoenix_Final_Total_Selling_Unit__c, Phoenix_Total_SCM_Approved_Qty__c, Phoenix_Proposed_Sales__c,Phoenix_Bid_Template_Refrence__c, Phoenix_Current_ASP_Dose__c,Phoenix_Proposed_ASP_Dose__c,Phoenix_Total_Selling_Unit__c,Phoenix_Current_Indirect_Price__c,Phoenix_Current_Position__c,Phoenix_Override_Current_Direct_Units__c,Phoenix_Current_Direct_Selling_Unit__c,Phoenix_Override_Current_Indirect_Units__c,Phoenix_Current_Indirect_Selling_Unit__c,Phoenix_Current_Wholesaler_Units__c,Phoenix_Override_Current_Units__c,Phoenix_Current_Retail_Direct_Units__c,Phoenix_Current_Retail_Indirect_Units__c,Phoenix_Current_Anda_Units__c,Phoenix_OS_and_RAD_Cur_Direct_Units_C__c,Phoenix_WMT_Current_Direct_Units__c,Phoenix_Proposed_Smith_Drug_Units__c,Phoenix_WMT_Current_Indirect_Units__c,Phoenix_Wholesaler_Diff_Price_Indirect__c,Phoenix_Final_Direct_Selling_Units_Calc__c, (SELECT Id, Name, Phoenix_Customer_Response_Date__c, Phoenix_Customer_Decline_Reasons__c, Final_Direct_Price__c, Final_Indirect_Price__c, Phoenix_Bid_Status__c,Phoenix_Award_Position__c,Phoenix_Supply_Effective_Date__c,Phoenix_Price_Effective_Date__c,Phoenix_Awarded_Quantity__c,Phoenix_Final_Approvd_Pricing_Contracts__c,Phoenix_Final_Total_Selling_Unit__c,Phoenix_Lead_Time_Days__c FROM Customer_Response_Lines__r),(SELECT Id,Phoenix_OverrideMajorUnits__c,Phoenix_3MonAnnualMajorSellingUnits__c,Phoenix_Current_Major_Contract_Price__c,Phoenix_Proposed_Major_Contract_Price__c, Phoenix_Proposed_CvsDirectContractPrice__c, Vision_Effective_Date_of_Removal__c,Phoenix_Proposed_CVS_DirSellingUnits__c,Phoenix_Proposed_CVS_IndirSellingUnits__c,Phoenix_Proposed_Cardinal_Units__c,Phoenix_Proposed_Major_Units__c FROM BidLineItemsExtn__r), Phoenix_Product__r.name from Phoenix_Bid_Line_Item__c where Phoenix_Bid__r.Phoenix_Approval_Status__c IN:lackInventoryStatus AND Phoenix_SCM_Approval_Y_N__c=:notApproved AND Phoenix_Bid__r.Phoenix_Bid_Type__c IN:bidTypes';
            query += ' AND CALENDAR_MONTH(Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c) IN:month AND CALENDAR_YEAR(Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c) IN:year';
            query2 += ' AND CALENDAR_MONTH(Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c) IN:month AND CALENDAR_YEAR(Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c) IN:year';
            if(productType != null){
                String Rx = 'Rx'; String SRx = 'SRx'; String OTC = 'OTC';
                if(productType == 'All'){
                    List<String> listOfProductTypes = new List<String> {'Rx', 'SRx', 'OTC'};
                        query += ' AND (Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =: '+Rx+' OR Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =: '+SRx+' OR Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =:'+OTC+')';
                    query2 += ' AND (Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =: '+Rx+' OR Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =: '+SRx+' OR Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =:'+OTC+')';
                } else if(productType == 'Rx+SRx'){
                    List<String> listOfProductTypes = new List<String> {'Rx', 'SRx'};
                        query += ' AND (Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =: '+Rx+' OR Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =: '+SRx+')';
                    query2 += ' AND (Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =: '+Rx+' OR Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =: '+SRx+')';
                } else if(productType == 'SRx+OTC'){
                    List<String> listOfProductTypes = new List<String> {'SRx', 'OTC'};
                        query += ' AND (Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =: '+SRx+' OR Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =:'+OTC+')';
                    query2 += ' AND (Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =: '+SRx+' OR Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =:'+OTC+')';
                } else if(productType == 'Rx+OTC'){
                    List<String> listOfProductTypes = new List<String> {'Rx', 'OTC'};
                        query += ' AND (Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =: '+Rx+' OR Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =:'+OTC+')';
                    query2 += ' AND (Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =: '+Rx+' OR Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =:'+OTC+')';
                } else{
                    query += ' AND Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =:productType';
                    query2 += ' AND Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =:productType';
                }
            }
            if(!String.isEmpty(productDirector)){
                query += ' AND Phoenix_Product__r.Phoenix_Product_Director__c =:productDirector';
                query2 += ' AND Phoenix_Product__r.Phoenix_Product_Director__c =:productDirector';
            }
            //wrapper.query = query;
            List<Phoenix_Bid_Line_Item__c> bidLineItemsList = Database.query(query);
            List<Phoenix_Bid_Line_Item__c> lackInventoryList = Database.query(query2);
            bidListWrapper responseWrapper1 = Vision_COLO_Controller.calculationHelper(bidLineItemsList);
            
            Integer Q1NPL = 0; Integer Q2NPL = 0; Integer Q1ProActive = 0; Integer Q2ProActive = 0; Integer Q1ReActive = 0; Integer Q2ReActive = 0; Integer Q1ROFRs = 0; Integer Q2ROFRs = 0;
            Map<String, Integer> mapOfAwarded = new Map<String, Integer>();
            mapOfAwarded.put('Q1NPL', responseWrapper1.NPLAwardedCount);mapOfAwarded.put('Q1ProActive', responseWrapper1.ProActiveAwardedCount);mapOfAwarded.put('Q1ReActive', responseWrapper1.ReActiveAwardedCount);mapOfAwarded.put('Q1ROFRs', responseWrapper1.ROFRAwardedCount);
            wrapper.NPLList = responseWrapper1.NPLList;
            wrapper.ProActiveList = responseWrapper1.ProActiveList;
            wrapper.ReActiveList = responseWrapper1.ReActiveList;
            wrapper.ROFRList = responseWrapper1.ROFRList;
            wrapper.NPLSales = (Integer)responseWrapper1.NPLSales;
            wrapper.NPLTPTSales = (Integer)responseWrapper1.NPLTPTSales;
            wrapper.ProActiveSales = (Integer)responseWrapper1.ProActiveSales;
            wrapper.ReActiveSales = (Integer)responseWrapper1.ReActiveSales;
            wrapper.ShareExpansionTPTSales = (Integer)responseWrapper1.ShareExpansionTPTSales;
            wrapper.ROFRSales = (Integer)responseWrapper1.ROFRSales;
            wrapper.PriceChangeTPTSales = (Integer)responseWrapper1.PriceChangeTPTSales;
            wrapper.NPLBidsCount = responseWrapper1.NPLBidsCount;
            wrapper.ProActiveBidsCount = responseWrapper1.ProActiveBidsCount;
            wrapper.ReActiveBidsCount = responseWrapper1.ReActiveBidsCount;
            wrapper.ROFRBidsCount = responseWrapper1.ROFRBidsCount;
            wrapper.lackInventoryList = lackInventoryList;
            
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Vision_COLO_Controller', Phoenix_Method_Name__c = 'getDataBasedOnQuarter', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        return wrapper;
        
    }
    
    @AuraEnabled 
    public static String getUserName(string userId){
        User userData = [Select Name from User where Id =: userId];
        return userData.Name;
    }
    
    @AuraEnabled 
    public static Supply_Issue__c upsertRecords(Supply_Issue__c supplyIssue){
        upsert supplyIssue;
        return supplyIssue;
    }
    
    @AuraEnabled 
    public static Map<String, Map<String, Supply_Issue__c>> getExistingSupplyIssues(List<String> familyList){
        String query = 'select Product_Family__r.Name,'+Phoenix_Util.getsObjectFieds('Supply_Issue__c')+' from Supply_Issue__c where Product_Family__r.Name=:familyList AND Product_Family__c != null';
        List<Supply_Issue__c> supplyIssues = database.query(query);
        Map<String, List<Supply_Issue__c>> mapOfSupplyIssues = new Map<String, List<Supply_Issue__c>>();
        for(Supply_Issue__c supplyIssue: supplyIssues){
            if(mapOfSupplyIssues.containsKey(supplyIssue.Product_Family__r.Name)){
                List<Supply_Issue__c> tempList = mapOfSupplyIssues.get(supplyIssue.Product_Family__r.Name);
                tempList.add(supplyIssue);
                mapOfSupplyIssues.put(supplyIssue.Product_Family__r.Name, tempList);
            } else{
                List<Supply_Issue__c> tempList = new List<Supply_Issue__c>();
                mapOfSupplyIssues.put(supplyIssue.Product_Family__r.Name, tempList);   
            }
        }
        Map<String, Map<String, Supply_Issue__c>> tempMap = new Map<String, Map<String, Supply_Issue__c>>();
        Map<String, Map<String, Supply_Issue__c>> finalMap = new Map<String, Map<String, Supply_Issue__c>>();
        if(mapOfSupplyIssues.keySet() != null){
            for(String key: mapOfSupplyIssues.keySet()){
                Map<String, Supply_Issue__c> monthSupplyIssueMap = new Map<String, Supply_Issue__c>();
                List<Supply_Issue__c> supplyList = mapOfSupplyIssues.get(key);
                for(Supply_Issue__c issue: supplyList){
                    monthSupplyIssueMap.put(issue.Selected_Month__c, issue);
                }
                tempMap.put(key, monthSupplyIssueMap);
            }   
        }
        List<String> sortedKeys = new List<String>(tempMap.keySet());
        if(sortedKeys != null){
            sortedKeys.sort();
            if(sortedKeys != null){
                for(String key: sortedKeys){
                    finalMap.put(key, tempMap.get(key));
                }
            }   
        }
        return finalMap;
    }
    
    @AuraEnabled 
    public static bidListWrapper calculationHelper(List<Phoenix_Bid_Line_Item__c> bidLineItemsList){
        List<Phoenix_Bid_Line_Item__c> NPLList =  new List<Phoenix_Bid_Line_Item__c>();
        List<Phoenix_Bid_Line_Item__c> ProActiveList =  new List<Phoenix_Bid_Line_Item__c>();
        List<Phoenix_Bid_Line_Item__c> ReActiveList =  new List<Phoenix_Bid_Line_Item__c>();
        List<Phoenix_Bid_Line_Item__c> ROFRList =  new List<Phoenix_Bid_Line_Item__c>();
        Decimal NPLSales = 0; Decimal ProActiveSales = 0; Decimal ReActiveSales = 0; Decimal ROFRSales = 0;
        Decimal NPLTPTSales = 0; Decimal ShareExpansionTPTSales = 0; Decimal PriceChangeTPTSales = 0; 
        Map<String, Integer> NPLBids = new Map<String, Integer>(); Map<String, Integer> ProActiveBids = new Map<String, Integer>(); Map<String, Integer> ReActiveBids = new Map<String, Integer>(); Map<String, Integer> ROFRBids = new Map<String, Integer>();
        Map<String, Integer> NPLAwardedCount = new Map<String, Integer>(); Map<String, Integer> ProActiveAwardedCount = new Map<String, Integer>(); Map<String, Integer> ReActiveAwardedCount = new Map<String, Integer>(); Map<String, Integer> ROFRAwardedCount = new Map<String, Integer>();
        Map<String, List<Phoenix_Bid_Line_Item__c>> NPLAwardedList = new Map<String, List<Phoenix_Bid_Line_Item__c>>(); 
        Map<String, List<Phoenix_Bid_Line_Item__c>> ProActiveAwardedList = new Map<String, List<Phoenix_Bid_Line_Item__c>>();
        Map<String, List<Phoenix_Bid_Line_Item__c>> ReActiveAwardedList = new Map<String, List<Phoenix_Bid_Line_Item__c>>(); 
        Map<String, List<Phoenix_Bid_Line_Item__c>> ROFRAwardedList = new Map<String, List<Phoenix_Bid_Line_Item__c>>();
        for(Phoenix_Bid_Line_Item__c bidLineItem: bidLineItemsList){
            Decimal awardedQty = ((bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? bidLineItem.Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
            Decimal proposedASP = ((bidLineItem.Phoenix_Proposed_ASP_Dose__c != null) ? bidLineItem.Phoenix_Proposed_ASP_Dose__c : 0);
            Decimal currentSales = 0;
            if(bidLineItem.Phoenix_Bid_Template_Refrence__c == 'ClarusOne')  currentSales = (bidLineItem.Phoenix_Net_Sales_External__c != null ? bidLineItem.Phoenix_Net_Sales_External__c : 0) ;
            else  currentSales = (bidLineItem.Finance_Current_Sales__c != null ? bidLineItem.Finance_Current_Sales__c : (bidLineItem.Phoenix_Current_Sales_Finance__c != null ? bidLineItem.Phoenix_Current_Sales_Finance__c: 0));
            Decimal proposedQty = ((bidLineItem.Phoenix_Final_Total_Selling_Unit__c != null) ? bidLineItem.Phoenix_Final_Total_Selling_Unit__c : 0);
            Decimal awardedSales = awardedQty*proposedASP; Decimal proposedSales = (bidLineItem.Phoenix_Proposed_Sales__c != null ? bidLineItem.Phoenix_Proposed_Sales__c : 0);
            /*Decimal awardedTPT = awardedSales - (awardedQty * ((bidLineItem.Phoenix_Throughput_Cost1__c != null) ? bidLineItem.Phoenix_Throughput_Cost1__c : 0)); 
            Decimal proposedTPT = ((bidLineItem.Phoenix_Proposed_TP_Margin__c != null) ? bidLineItem.Phoenix_Proposed_TP_Margin__c : 0);*/
            Decimal awardedTPT = ((bidLineItem.Phoenix_Total_DRL_Share__c != null) ? bidLineItem.Phoenix_Total_DRL_Share__c : 0);
            Decimal proposedTPT = ((bidLineItem.Phoenix_Total_DRL_Share__c != null) ? bidLineItem.Phoenix_Total_DRL_Share__c : 0);
            Decimal currentTPT = ((bidLineItem.Phoenix_Current_TP_Margin__c != null) ? bidLineItem.Phoenix_Current_TP_Margin__c : 0);
            
            if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Product Launch' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC New Product'){
                NPLList.add(bidLineItem);
                if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    NPLSales += (awardedSales-currentSales); 
                    NPLTPTSales += (awardedTPT - currentTPT);
                    if(NPLAwardedCount.containskey(bidLineItem.Phoenix_Bid__c)){
                        NPLAwardedCount.put(bidLineItem.Phoenix_Bid__c, NPLAwardedCount.get(bidLineItem.Phoenix_Bid__c) + 1);
                        List<Phoenix_Bid_Line_Item__c> tempList = NPLAwardedList.get(bidLineItem.Phoenix_Bid__c);tempList.add(bidLineItem);
                        NPLAwardedList.put(bidLineItem.Phoenix_Bid__c, tempList);
                    }
                    else{
                        NPLAwardedCount.put(bidLineItem.Phoenix_Bid__c, 1);
                        List<Phoenix_Bid_Line_Item__c> tempList = new List<Phoenix_Bid_Line_Item__c>();tempList.add(bidLineItem);
                        NPLAwardedList.put(bidLineItem.Phoenix_Bid__c, tempList);
                    }
                } else if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    NPLSales += (proposedSales-currentSales); 
                    NPLTPTSales += (proposedTPT - currentTPT);
                }
                if(NPLBids.containskey(bidLineItem.Phoenix_Bid__c)) NPLBids.put(bidLineItem.Phoenix_Bid__c, NPLBids.get(bidLineItem.Phoenix_Bid__c) + 1);
                else NPLBids.put(bidLineItem.Phoenix_Bid__c, 1);
            } else if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Customer' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Addition' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Product Addition'){
                ProActiveList.add(bidLineItem);
                if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    ProActiveSales += (awardedSales-currentSales); ShareExpansionTPTSales += (awardedTPT - currentTPT);
                    if(ProActiveAwardedCount.containskey(bidLineItem.Phoenix_Bid__c)) ProActiveAwardedCount.put(bidLineItem.Phoenix_Bid__c, ProActiveAwardedCount.get(bidLineItem.Phoenix_Bid__c) + 1);
                    else ProActiveAwardedCount.put(bidLineItem.Phoenix_Bid__c, 1);
                } else if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    ProActiveSales += (proposedSales-currentSales); ShareExpansionTPTSales += (proposedTPT - currentTPT);
                }
                if(ProActiveBids.containskey(bidLineItem.Phoenix_Bid__c))  ProActiveBids.put(bidLineItem.Phoenix_Bid__c, ProActiveBids.get(bidLineItem.Phoenix_Bid__c) + 1);
                else ProActiveBids.put(bidLineItem.Phoenix_Bid__c, 1);
            } else if((bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && currentSales == 0 && (awardedSales-currentSales) >= 0) {
                ReActiveList.add(bidLineItem);
                if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    ReActiveSales += (awardedSales-currentSales); ShareExpansionTPTSales += (awardedTPT - currentTPT);
                    if(ReActiveAwardedCount.containskey(bidLineItem.Phoenix_Bid__c)) ReActiveAwardedCount.put(bidLineItem.Phoenix_Bid__c, ReActiveAwardedCount.get(bidLineItem.Phoenix_Bid__c) + 1);
                    else ReActiveAwardedCount.put(bidLineItem.Phoenix_Bid__c, 1);
                } else if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    ReActiveSales += (awardedSales-currentSales); ShareExpansionTPTSales += (proposedTPT - currentTPT);
                }
                if(ReActiveBids.containskey(bidLineItem.Phoenix_Bid__c))  ReActiveBids.put(bidLineItem.Phoenix_Bid__c, ReActiveBids.get(bidLineItem.Phoenix_Bid__c) + 1);
                else ReActiveBids.put(bidLineItem.Phoenix_Bid__c, 1);
            } else if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Short Dated' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Volume Review'){ 
                //else if(((bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && ((currentSales == 0 && ((awardedQty * proposedASP) > currentSales)) || (currentSales == 0 && ((proposedSales) > currentSales)))) || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Short Dated' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Volume Review'){ 
                ReActiveList.add(bidLineItem);
                if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    ReActiveSales += (awardedSales-currentSales); ShareExpansionTPTSales += (awardedTPT - currentTPT);
                    if(ReActiveAwardedCount.containskey(bidLineItem.Phoenix_Bid__c)) ReActiveAwardedCount.put(bidLineItem.Phoenix_Bid__c, ReActiveAwardedCount.get(bidLineItem.Phoenix_Bid__c) + 1);
                    else ReActiveAwardedCount.put(bidLineItem.Phoenix_Bid__c, 1);
                } else if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    ReActiveSales += (proposedSales-currentSales); ShareExpansionTPTSales += (proposedTPT - currentTPT);
                }
                if(ReActiveBids.containskey(bidLineItem.Phoenix_Bid__c))  ReActiveBids.put(bidLineItem.Phoenix_Bid__c, ReActiveBids.get(bidLineItem.Phoenix_Bid__c) + 1);
                else ReActiveBids.put(bidLineItem.Phoenix_Bid__c, 1);
            } else if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Price Change' || ((bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && ((((awardedQty * proposedASP) < currentSales) && currentSales > 0) || ((proposedSales <= currentSales) && currentSales > 0)))){
                ROFRList.add(bidLineItem);
                if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    ROFRSales += (awardedSales-currentSales); PriceChangeTPTSales += (awardedTPT - currentTPT);
                    if(ROFRAwardedCount.containskey(bidLineItem.Phoenix_Bid__c)) ROFRAwardedCount.put(bidLineItem.Phoenix_Bid__c, ROFRAwardedCount.get(bidLineItem.Phoenix_Bid__c) + 1);
                    else ROFRAwardedCount.put(bidLineItem.Phoenix_Bid__c, 1);
                } else if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    ROFRSales += (awardedSales-currentSales); PriceChangeTPTSales += (proposedTPT - currentTPT);
                }
                if(ROFRBids.containskey(bidLineItem.Phoenix_Bid__c))  ROFRBids.put(bidLineItem.Phoenix_Bid__c, ROFRBids.get(bidLineItem.Phoenix_Bid__c) + 1);
                else ROFRBids.put(bidLineItem.Phoenix_Bid__c, 1);
            }
        }
        bidListWrapper wrapper = new bidListWrapper();
        wrapper.NPLList = NPLList; 
        wrapper.ProActiveList = ProActiveList;
        wrapper.ReActiveList = ReActiveList; 
        wrapper.ROFRList = ROFRList; 
        wrapper.NPLSales = NPLSales;
        wrapper.NPLTPTSales = NPLTPTSales; 
        wrapper.ProActiveSales = ProActiveSales; 
        wrapper.ReActiveSales = ReActiveSales; 
        wrapper.ShareExpansionTPTSales = ShareExpansionTPTSales;
        wrapper.ROFRSales = ROFRSales; 
        wrapper.PriceChangeTPTSales = PriceChangeTPTSales;
        return wrapper;
    }
    
    /*public static void codeCoverage(){
        integer i =1;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }*/
    
    public class bidListWrapper{
        @AuraEnabled public List<Phoenix_Bid_Line_Item__c> lackInventoryList;
        @AuraEnabled Public List<Phoenix_Bid_Line_Item__c> NPLList;
        @AuraEnabled Public Map<String, List<Phoenix_Bid_Line_Item__c>> NPLAwardedList;
        @AuraEnabled Public List<Phoenix_Bid_Line_Item__c> ProActiveList;
        @AuraEnabled Public Map<String, List<Phoenix_Bid_Line_Item__c>> ProActiveAwardedList;
        @AuraEnabled Public List<Phoenix_Bid_Line_Item__c> ReActiveList;
        @AuraEnabled Public Map<String, List<Phoenix_Bid_Line_Item__c>> ReActiveAwardedList;
        @AuraEnabled Public List<Phoenix_Bid_Line_Item__c> ROFRList;
        @AuraEnabled Public Map<String, List<Phoenix_Bid_Line_Item__c>> ROFRAwardedList;
        @AuraEnabled Public String query;
        @AuraEnabled Public Decimal NPLSales;
        @AuraEnabled Public Decimal NPLTPTSales;
        @AuraEnabled Public Decimal ProActiveSales;
        @AuraEnabled Public Decimal ReActiveSales;
        @AuraEnabled Public Decimal ShareExpansionTPTSales;
        @AuraEnabled Public Decimal ROFRSales;
        @AuraEnabled Public Decimal PriceChangeTPTSales;
        @AuraEnabled Public Integer NPLAwardedCount;
        @AuraEnabled Public Integer ProActiveAwardedCount;
        @AuraEnabled Public Integer ReActiveAwardedCount;
        @AuraEnabled Public Integer ROFRAwardedCount;
        @AuraEnabled public String quarter;
        @AuraEnabled public Integer NPLBidsCount;
        @AuraEnabled public Integer ProActiveBidsCount;
        @AuraEnabled public Integer ReActiveBidsCount;
        @AuraEnabled public Integer ROFRBidsCount;
        
        @AuraEnabled Public List<Phoenix_Bid_Line_Item__c> Q1NewProductLaunchList;
        @AuraEnabled Public List<Phoenix_Bid_Line_Item__c> Q2NewProductLaunchList;
        @AuraEnabled Public Map<String, List<Phoenix_Bid_Line_Item__c>> Q1NPLAwardedList;
        @AuraEnabled Public Map<String, List<Phoenix_Bid_Line_Item__c>> Q2NPLAwardedList;
        @AuraEnabled Public List<Phoenix_Bid_Line_Item__c> Q1ProActiveList;
        @AuraEnabled Public List<Phoenix_Bid_Line_Item__c> Q2ProActiveList;
        @AuraEnabled Public Map<String, List<Phoenix_Bid_Line_Item__c>> Q1ProActiveAwardedList;
        @AuraEnabled Public Map<String, List<Phoenix_Bid_Line_Item__c>> Q2ProActiveAwardedList;
        @AuraEnabled Public List<Phoenix_Bid_Line_Item__c> Q1ROFRsList;
        @AuraEnabled Public List<Phoenix_Bid_Line_Item__c> Q2ROFRsList;
        @AuraEnabled Public Map<String, List<Phoenix_Bid_Line_Item__c>> Q1ROFRsAwardedList;
        @AuraEnabled Public Map<String, List<Phoenix_Bid_Line_Item__c>> Q2ROFRsAwardedList;
        @AuraEnabled Public List<Phoenix_Bid_Line_Item__c> Q1ReActiveList;
        @AuraEnabled Public List<Phoenix_Bid_Line_Item__c> Q2ReActiveList;
        @AuraEnabled Public Map<String, List<Phoenix_Bid_Line_Item__c>> Q1ReActiveAwardedList;
        @AuraEnabled Public Map<String, List<Phoenix_Bid_Line_Item__c>> Q2ReActiveAwardedList;
        @AuraEnabled Public List<Phoenix_Bid__c> NewCustomerBids;
        @AuraEnabled Public List<Phoenix_Bid__c> ProductAdditionBids;
        @AuraEnabled Public Decimal Q1SalesNPL;
        @AuraEnabled Public Decimal Q2SalesNPL;
        @AuraEnabled Public Decimal Q1SalesProActive;
        @AuraEnabled Public Decimal Q2SalesProActive;
        @AuraEnabled Public Decimal Q1SalesReActive;
        @AuraEnabled Public Decimal Q2SalesReActive;
        @AuraEnabled Public Decimal Q1SalesROFRs;
        @AuraEnabled Public Decimal Q2SalesROFRs;
        @AuraEnabled public Integer Q1NPLBidsCount;
        @AuraEnabled public Integer Q1ProActiveBidsCount;
        @AuraEnabled public Integer Q1ReActiveBidsCount;
        @AuraEnabled public Integer Q1ROFRBidsCount;
        @AuraEnabled public Integer Q2NPLBidsCount;
        @AuraEnabled public Integer Q2ProActiveBidsCount;
        @AuraEnabled public Integer Q2ReActiveBidsCount;
        @AuraEnabled public Integer Q2ROFRBidsCount;
        @AuraEnabled public Map<String, Integer> mapOfAwarded;
    }
    
    public class wrapperObject {
        public Decimal finalCOLO;
        public Decimal finalTPTDollar;
        public Boolean capacityConstraint;
        public Date getWellDate;
        public String selectedMonth;
        public String familyId;
    }
}