public class VisionQRMBidAnalysisCls {
    @AuraEnabled 
    public static bidListWrapper getBids(Date q1FromDate, Date q1ToDate, Date q2FromDate, Date q2ToDate, String basedOn){
        List<String> approvalStatus = new List<String>{'Customer Rejected', 'Closed'}; List<String> bidStatus = new List<String>{'Awarded', 'Declined by Customer'};    
            List<String> bidTypes = new List<String>{'New Product Launch', 'New Customer', 'Product Addition', 'Price Change', 'OTC New Product', 'OTC Price Change', 'OTC Product Addition', 'OTC RFP', 'RFP Bids', 'Good Dated OTB', 'Short Dated OTB', 'OTC OTB Good Dated', 'OTC OTB Short Dated', 'Volume Review Only', 'OTC Volume Review'};
                String selectedQ1Query = 'select Product_Family_Name__c, Phoenix_Bid__r.Phoenix_Salesperson__c,Phoenix_Current_Sales_Finance__c, Phoenix_Product__r.Family,Phoenix_Product__r.Phoenix_NDC_11__c, Phoenix_Final_Direct_Selling_Units__c,Phoenix_ProposedIndirectAholdDelhaizeUni__c,Phoenix_ProposedDirectGaintEagleUnits__c,Phoenix_Final_Indirect_Selling_Units__c,Phoenix_Customer_Approval_OTC__c,Phoenix_Proposed_Anda_Units__c,Phoenix_ProposedDirectAholdDelhaizeUnits__c, Phoenix_Proposed_RAD_Units__c,Phoenix_Proposed_WMT_Units__c,Phoenix_Proposed_Indirect_Selling_Unit__c,Phoenix_Proposed_OS_Units__c,Phoenix_Proposed_Direct_Selling_Unit__c, Phoenix_Throughput_cost__c, Phoenix_Product__r.Phoenix_Throughput_cost__c, Phoenix_Bid_Status__c, Phoenix_Final_Status__c, Phoenix_Product__r.Phoenix_Product_Director__c, Phoenix_Current_Anda_CP_Price__c,  Phoenix_Current_Retail_Indirect_Net__c,Phoenix_Current_Retail_Indirect_Price__c,Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Current_Direct_Price__c, Phoenix_OS_RAD_NCP__c, Phoenix_WMT_Direct_NCP__c, Phoenix_WMT_Indirect_NCP__c,Phoenix_Current_Retail_Direct_Price__c,Phoenix_Current_Wholesaler_Price__c, Phoenix_Bid__r.Phoenix_Bid_Owner__r.Name, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_NDC_Without_Dashes__c,Phoenix_Product_Code1__c, Phoenix_Product_Family__c,Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c, Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Customer_Type__c, Phoenix_Product__r.ProductCode, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Name, Phoenix_Customer__r.Name, Phoenix_Contract__r.Name, Phoenix_Contract__r.Phoenix_Contract_Number__c, Phoenix_SCM_Final_Approval__c, Phoenix_Final_Total_Selling_Unit__c, Phoenix_Total_SCM_Approved_Qty__c, Phoenix_Proposed_Sales__c,Phoenix_Bid_Template_Refrence__c, Phoenix_Current_ASP_Dose__c,Phoenix_Proposed_ASP_Dose__c,Phoenix_Total_Selling_Unit__c,Phoenix_Current_Indirect_Price__c,Phoenix_Current_Position__c,Phoenix_Override_Current_Direct_Units__c,Phoenix_Current_Direct_Selling_Unit__c,Phoenix_Override_Current_Indirect_Units__c,Phoenix_Current_Indirect_Selling_Unit__c,Phoenix_Current_Wholesaler_Units__c,Phoenix_Override_Current_Units__c,Phoenix_Current_Retail_Direct_Units__c,Phoenix_Current_Retail_Indirect_Units__c,Phoenix_Current_Anda_Units__c,Phoenix_OS_and_RAD_Cur_Direct_Units_C__c,Phoenix_WMT_Current_Direct_Units__c,Phoenix_Proposed_Smith_Drug_Units__c,Phoenix_WMT_Current_Indirect_Units__c,Phoenix_Wholesaler_Diff_Price_Indirect__c,Phoenix_Final_Direct_Selling_Units_Calc__c, (SELECT Id, Name, Phoenix_Customer_Response_Date__c, Phoenix_Customer_Decline_Reasons__c, Final_Direct_Price__c, Final_Indirect_Price__c, Phoenix_Bid_Status__c,Phoenix_Award_Position__c,Phoenix_Supply_Effective_Date__c,Phoenix_Price_Effective_Date__c,Phoenix_Awarded_Quantity__c,Phoenix_Final_Approvd_Pricing_Contracts__c,Phoenix_Final_Total_Selling_Unit__c FROM Customer_Response_Lines__r),(SELECT Id,Phoenix_OverrideMajorUnits__c,Phoenix_3MonAnnualMajorSellingUnits__c,Phoenix_Current_Major_Contract_Price__c,Phoenix_Proposed_Major_Contract_Price__c, Phoenix_Proposed_CvsDirectContractPrice__c, Vision_Effective_Date_of_Removal__c,Phoenix_Proposed_CVS_DirSellingUnits__c,Phoenix_Proposed_CVS_IndirSellingUnits__c,Phoenix_Proposed_Cardinal_Units__c,Phoenix_Proposed_Major_Units__c FROM BidLineItemsExtn__r), Phoenix_Product__r.name from Phoenix_Bid_Line_Item__c where Phoenix_Customer_Response_Line__c != null AND Phoenix_Customer_Response_Line__r.Phoenix_Bid_Status__c IN:bidStatus AND Phoenix_Bid__r.Phoenix_Approval_Status__c IN:approvalStatus AND Phoenix_Bid__r.Phoenix_Bid_Type__c IN:bidTypes';
        String selectedQ2Query = 'select Product_Family_Name__c,Phoenix_Bid__r.Phoenix_Salesperson__c,Phoenix_Product__r.Family, Phoenix_Current_Sales_Finance__c, Phoenix_Product__r.Phoenix_NDC_11__c, Phoenix_Final_Direct_Selling_Units__c,Phoenix_ProposedIndirectAholdDelhaizeUni__c,Phoenix_ProposedDirectGaintEagleUnits__c,Phoenix_Final_Indirect_Selling_Units__c,Phoenix_Customer_Approval_OTC__c,Phoenix_Proposed_Anda_Units__c,Phoenix_ProposedDirectAholdDelhaizeUnits__c, Phoenix_Proposed_RAD_Units__c,Phoenix_Proposed_WMT_Units__c,Phoenix_Proposed_Indirect_Selling_Unit__c,Phoenix_Proposed_OS_Units__c,Phoenix_Proposed_Direct_Selling_Unit__c, Phoenix_Throughput_cost__c, Phoenix_Product__r.Phoenix_Throughput_cost__c, Phoenix_Bid_Status__c, Phoenix_Final_Status__c, Phoenix_Product__r.Phoenix_Product_Director__c, Phoenix_Current_Anda_CP_Price__c,  Phoenix_Current_Retail_Indirect_Net__c,Phoenix_Current_Retail_Indirect_Price__c,Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Current_Direct_Price__c, Phoenix_OS_RAD_NCP__c, Phoenix_WMT_Direct_NCP__c, Phoenix_WMT_Indirect_NCP__c,Phoenix_Current_Retail_Direct_Price__c,Phoenix_Current_Wholesaler_Price__c, Phoenix_Bid__r.Phoenix_Bid_Owner__r.Name, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_NDC_Without_Dashes__c,Phoenix_Product_Code1__c, Phoenix_Product_Family__c,Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c, Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Customer_Type__c, Phoenix_Product__r.ProductCode, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Name, Phoenix_Customer__r.Name, Phoenix_Contract__r.Name, Phoenix_Contract__r.Phoenix_Contract_Number__c, Phoenix_SCM_Final_Approval__c, Phoenix_Final_Total_Selling_Unit__c, Phoenix_Total_SCM_Approved_Qty__c, Phoenix_Proposed_Sales__c,Phoenix_Bid_Template_Refrence__c, Phoenix_Current_ASP_Dose__c,Phoenix_Proposed_ASP_Dose__c,Phoenix_Total_Selling_Unit__c,Phoenix_Current_Indirect_Price__c,Phoenix_Current_Position__c,Phoenix_Override_Current_Direct_Units__c,Phoenix_Current_Direct_Selling_Unit__c,Phoenix_Override_Current_Indirect_Units__c,Phoenix_Current_Indirect_Selling_Unit__c,Phoenix_Current_Wholesaler_Units__c,Phoenix_Override_Current_Units__c,Phoenix_Current_Retail_Direct_Units__c,Phoenix_Current_Retail_Indirect_Units__c,Phoenix_Current_Anda_Units__c,Phoenix_OS_and_RAD_Cur_Direct_Units_C__c,Phoenix_WMT_Current_Direct_Units__c,Phoenix_Proposed_Smith_Drug_Units__c,Phoenix_WMT_Current_Indirect_Units__c,Phoenix_Wholesaler_Diff_Price_Indirect__c,Phoenix_Final_Direct_Selling_Units_Calc__c, (SELECT Id, Name, Phoenix_Customer_Response_Date__c, Phoenix_Customer_Decline_Reasons__c, Final_Direct_Price__c, Final_Indirect_Price__c, Phoenix_Bid_Status__c,Phoenix_Award_Position__c,Phoenix_Supply_Effective_Date__c,Phoenix_Price_Effective_Date__c,Phoenix_Awarded_Quantity__c,Phoenix_Final_Approvd_Pricing_Contracts__c,Phoenix_Final_Total_Selling_Unit__c FROM Customer_Response_Lines__r),(SELECT Id,Phoenix_OverrideMajorUnits__c,Phoenix_3MonAnnualMajorSellingUnits__c,Phoenix_Current_Major_Contract_Price__c,Phoenix_Proposed_Major_Contract_Price__c, Phoenix_Proposed_CvsDirectContractPrice__c, Vision_Effective_Date_of_Removal__c,Phoenix_Proposed_CVS_DirSellingUnits__c,Phoenix_Proposed_CVS_IndirSellingUnits__c,Phoenix_Proposed_Cardinal_Units__c,Phoenix_Proposed_Major_Units__c FROM BidLineItemsExtn__r), Phoenix_Product__r.name from Phoenix_Bid_Line_Item__c where Phoenix_Customer_Response_Line__c != null AND Phoenix_Customer_Response_Line__r.Phoenix_Bid_Status__c IN:bidStatus AND Phoenix_Bid__r.Phoenix_Approval_Status__c IN:approvalStatus AND Phoenix_Bid__r.Phoenix_Bid_Type__c IN:bidTypes';
        if(basedOn == 'Closed Date'){
            selectedQ1Query += ' AND Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c >=:q1FromDate AND Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c <=:q1ToDate';
            selectedQ2Query += ' AND Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c >=:q2FromDate AND Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c <=:q2ToDate';
        } else if(basedOn == 'Customer Response Date'){
            selectedQ1Query += ' AND Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c >=:q1FromDate AND Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c <=:q1ToDate';
            selectedQ2Query += ' AND Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c >=:q2FromDate AND Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c <=:q2ToDate';            
        } else if(basedOn == 'Submitted Date'){
            selectedQ1Query += ' AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c >=:q1FromDate AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:q1ToDate';
            selectedQ2Query += ' AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c >=:q2FromDate AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:q2ToDate';
        } else if(basedOn == 'Submitted Date/Customer Response Date'){
            selectedQ1Query += ' AND ((Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c >=:q1FromDate AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:q1ToDate) OR (Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c >=:q1FromDate AND Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c <=:q1ToDate))';
            selectedQ2Query += ' AND ((Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c >=:q2FromDate AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:q2ToDate) OR (Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c >=:q2FromDate AND Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c <=:q2ToDate))';
        } else if(basedOn == 'Submitted Date/Closed Date'){
            selectedQ1Query += ' AND ((Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c >=:q1FromDate AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:q1ToDate) OR (Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c >=:q1FromDate AND Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c <=:q1ToDate))';
            selectedQ2Query += ' AND ((Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c >=:q2FromDate AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:q2ToDate) OR (Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c >=:q2FromDate AND Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c <=:q2ToDate))';
        } else if(basedOn == 'Customer Response Date/Closed Date'){
            selectedQ1Query += ' AND ((Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c >=:q1FromDate AND Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c <=:q1ToDate) OR (Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c >=:q1FromDate AND Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c <=:q1ToDate))';
            selectedQ2Query += ' AND ((Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c >=:q2FromDate AND Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c <=:q2ToDate) OR (Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c >=:q2FromDate AND Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c <=:q2ToDate))';
        } else if(basedOn == 'Submitted Date/Customer Response Date/Closed Date'){
            selectedQ1Query += ' AND ((Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c >=:q1FromDate AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:q1ToDate) OR (Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c >=:q1FromDate AND Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c <=:q1ToDate) OR (Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c >=:q1FromDate AND Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c <=:q1ToDate))';
            selectedQ2Query += ' AND ((Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c >=:q2FromDate AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:q2ToDate) OR (Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c >=:q2FromDate AND Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c <=:q2ToDate) OR (Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c >=:q2FromDate AND Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c <=:q2ToDate))';
        }
        List<Phoenix_Bid_Line_Item__c> selectedQ1BidLineItemsList = Database.query(selectedQ1Query); List<Phoenix_Bid_Line_Item__c> selectedQ2BidLineItemsList = Database.query(selectedQ2Query);        
        bidListWrapper responseWrapper1 = VisionQRMBidAnalysisCls.calculationHelper(selectedQ1BidLineItemsList);
        bidListWrapper responseWrapper2 = VisionQRMBidAnalysisCls.calculationHelper(selectedQ2BidLineItemsList);
        
        Integer Q1NPL = 0; Integer Q2NPL = 0; Integer Q1ProActive = 0; Integer Q2ProActive = 0; Integer Q1ReActive = 0; Integer Q2ReActive = 0; Integer Q1ROFRs = 0; Integer Q2ROFRs = 0;
        Map<String, Integer> mapOfAwarded = new Map<String, Integer>();
        mapOfAwarded.put('Q1NPL', responseWrapper1.NPLAwardedCount);mapOfAwarded.put('Q2NPL', responseWrapper2.NPLAwardedCount);mapOfAwarded.put('Q1ProActive', responseWrapper1.ProActiveAwardedCount);mapOfAwarded.put('Q2ProActive', responseWrapper2.ProActiveAwardedCount);mapOfAwarded.put('Q1ReActive', responseWrapper1.ReActiveAwardedCount);mapOfAwarded.put('Q2ReActive', responseWrapper2.ReActiveAwardedCount);mapOfAwarded.put('Q1ROFRs', responseWrapper1.ROFRAwardedCount);mapOfAwarded.put('Q2ROFRs', responseWrapper2.ROFRAwardedCount);
        bidListWrapper wrapper = new bidListWrapper();
        wrapper.Q1NPLAwardedList = responseWrapper1.NPLAwardedList;
        wrapper.Q2NPLAwardedList = responseWrapper2.NPLAwardedList;
        wrapper.Q1NewProductLaunchList = responseWrapper1.NPLList;
        wrapper.Q2NewProductLaunchList = responseWrapper2.NPLList;
        wrapper.Q1ProActiveAwardedList = responseWrapper1.ProActiveAwardedList;
        wrapper.Q2ProActiveAwardedList = responseWrapper2.ProActiveAwardedList;
        wrapper.Q1ProActiveList = responseWrapper1.ProActiveList;
        wrapper.Q2ProActiveList = responseWrapper2.ProActiveList;
        wrapper.Q1ReActiveAwardedList = responseWrapper1.ReActiveAwardedList;
        wrapper.Q2ReActiveAwardedList = responseWrapper2.ReActiveAwardedList;
        wrapper.Q1ReActiveList = responseWrapper1.ReActiveList;
        wrapper.Q2ReActiveList = responseWrapper2.ReActiveList;
        wrapper.Q1ROFRsAwardedList = responseWrapper1.ROFRAwardedList;
        wrapper.Q2ROFRsAwardedList = responseWrapper2.ROFRAwardedList;
        wrapper.Q1ROFRsList = responseWrapper1.ROFRList;
        wrapper.Q2ROFRsList = responseWrapper2.ROFRList;
        wrapper.Q1SalesNPL = responseWrapper1.NPLSales;
        wrapper.Q2SalesNPL = responseWrapper2.NPLSales;
        wrapper.Q1SalesProActive = responseWrapper1.ProActiveSales;
        wrapper.Q2SalesProActive = responseWrapper2.ProActiveSales;
        wrapper.Q1SalesReActive = responseWrapper1.ReActiveSales;
        wrapper.Q2SalesReActive = responseWrapper2.ReActiveSales;
        wrapper.Q1SalesROFRs = responseWrapper1.ROFRSales;
        wrapper.Q2SalesROFRs = responseWrapper2.ROFRSales;
        wrapper.mapOfAwarded = mapOfAwarded;
        wrapper.Q1NPLBidsCount = (Integer)responseWrapper1.NPLBidsCount; wrapper.Q1ProActiveBidsCount = (Integer)responseWrapper1.ProActiveBidsCount; wrapper.Q1ReActiveBidsCount = (Integer)responseWrapper1.ReActiveBidsCount; wrapper.Q1ROFRBidsCount = (Integer)responseWrapper1.ROFRBidsCount;
        wrapper.Q2NPLBidsCount = (Integer)responseWrapper2.NPLBidsCount; wrapper.Q2ProActiveBidsCount = (Integer)responseWrapper2.ProActiveBidsCount; wrapper.Q2ReActiveBidsCount = (Integer)responseWrapper2.ReActiveBidsCount; wrapper.Q2ROFRBidsCount = (Integer)responseWrapper2.ROFRBidsCount;
        return wrapper;
    }
    
    @AuraEnabled 
    public static bidListWrapper getDataBasedOnQuarter(Date FromDate, Date ToDate, String basedOn, String quarter){
        List<String> approvalStatus = new List<String>{'Customer Rejected', 'Closed'};
        List<String> bidStatus = new List<String>{'Awarded', 'Declined by Customer'};    
            List<String> bidTypes = new List<String>{'New Product Launch', 'New Customer', 'Product Addition', 'Price Change', 'OTC New Product', 'OTC Price Change', 'OTC Product Addition', 'OTC RFP', 'RFP Bids', 'Good Dated OTB', 'Short Dated OTB', 'OTC OTB Good Dated', 'OTC OTB Short Dated', 'Volume Review Only', 'OTC Volume Review'};
                String query = 'select Product_Family_Name__c,Phoenix_Bid__r.Phoenix_Salesperson__c,Phoenix_Product__r.Family,Phoenix_Current_Sales_Finance__c, Phoenix_Product__r.Phoenix_NDC_11__c, Phoenix_Final_Direct_Selling_Units__c,Phoenix_ProposedIndirectAholdDelhaizeUni__c,Phoenix_ProposedDirectGaintEagleUnits__c,Phoenix_Final_Indirect_Selling_Units__c,Phoenix_Customer_Approval_OTC__c,Phoenix_Proposed_Anda_Units__c,Phoenix_ProposedDirectAholdDelhaizeUnits__c, Phoenix_Proposed_RAD_Units__c,Phoenix_Proposed_WMT_Units__c,Phoenix_Proposed_Indirect_Selling_Unit__c,Phoenix_Proposed_OS_Units__c,Phoenix_Proposed_Direct_Selling_Unit__c, Phoenix_Throughput_cost__c, Phoenix_Product__r.Phoenix_Throughput_cost__c, Phoenix_Bid_Status__c, Phoenix_Final_Status__c, Phoenix_Product__r.Phoenix_Product_Director__c, Phoenix_Current_Anda_CP_Price__c,  Phoenix_Current_Retail_Indirect_Net__c,Phoenix_Current_Retail_Indirect_Price__c,Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Current_Direct_Price__c, Phoenix_OS_RAD_NCP__c, Phoenix_WMT_Direct_NCP__c, Phoenix_WMT_Indirect_NCP__c,Phoenix_Current_Retail_Direct_Price__c,Phoenix_Current_Wholesaler_Price__c, Phoenix_Bid__r.Phoenix_Bid_Owner__r.Name, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_NDC_Without_Dashes__c,Phoenix_Product_Code1__c, Phoenix_Product_Family__c,Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c, Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Customer_Type__c, Phoenix_Product__r.ProductCode, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Name, Phoenix_Customer__r.Name, Phoenix_Contract__r.Name, Phoenix_Contract__r.Phoenix_Contract_Number__c, Phoenix_SCM_Final_Approval__c, Phoenix_Final_Total_Selling_Unit__c, Phoenix_Total_SCM_Approved_Qty__c, Phoenix_Proposed_Sales__c,Phoenix_Bid_Template_Refrence__c, Phoenix_Current_ASP_Dose__c,Phoenix_Proposed_ASP_Dose__c,Phoenix_Total_Selling_Unit__c,Phoenix_Current_Indirect_Price__c,Phoenix_Current_Position__c,Phoenix_Override_Current_Direct_Units__c,Phoenix_Current_Direct_Selling_Unit__c,Phoenix_Override_Current_Indirect_Units__c,Phoenix_Current_Indirect_Selling_Unit__c,Phoenix_Current_Wholesaler_Units__c,Phoenix_Override_Current_Units__c,Phoenix_Current_Retail_Direct_Units__c,Phoenix_Current_Retail_Indirect_Units__c,Phoenix_Current_Anda_Units__c,Phoenix_OS_and_RAD_Cur_Direct_Units_C__c,Phoenix_WMT_Current_Direct_Units__c,Phoenix_Proposed_Smith_Drug_Units__c,Phoenix_WMT_Current_Indirect_Units__c,Phoenix_Wholesaler_Diff_Price_Indirect__c,Phoenix_Final_Direct_Selling_Units_Calc__c, (SELECT Id, Name, Phoenix_Customer_Response_Date__c, Phoenix_Customer_Decline_Reasons__c, Final_Direct_Price__c, Final_Indirect_Price__c, Phoenix_Bid_Status__c,Phoenix_Award_Position__c,Phoenix_Supply_Effective_Date__c,Phoenix_Price_Effective_Date__c,Phoenix_Awarded_Quantity__c,Phoenix_Final_Approvd_Pricing_Contracts__c,Phoenix_Final_Total_Selling_Unit__c FROM Customer_Response_Lines__r),(SELECT Id,Phoenix_OverrideMajorUnits__c,Phoenix_3MonAnnualMajorSellingUnits__c,Phoenix_Current_Major_Contract_Price__c,Phoenix_Proposed_Major_Contract_Price__c, Phoenix_Proposed_CvsDirectContractPrice__c, Vision_Effective_Date_of_Removal__c,Phoenix_Proposed_CVS_DirSellingUnits__c,Phoenix_Proposed_CVS_IndirSellingUnits__c,Phoenix_Proposed_Cardinal_Units__c,Phoenix_Proposed_Major_Units__c FROM BidLineItemsExtn__r), Phoenix_Product__r.name from Phoenix_Bid_Line_Item__c where Phoenix_Customer_Response_Line__c != null AND Phoenix_Customer_Response_Line__r.Phoenix_Bid_Status__c IN:bidStatus AND Phoenix_Bid__r.Phoenix_Approval_Status__c IN:approvalStatus AND Phoenix_Bid__r.Phoenix_Bid_Type__c IN:bidTypes';
        if(basedOn == 'Closed Date'){
            query += ' AND Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c >=:FromDate AND Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c <=:ToDate';
        } else if(basedOn == 'Customer Response Date'){
            query += ' AND Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c >=:FromDate AND Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c <=:ToDate';
        } else if(basedOn == 'Submitted Date'){
            query += ' AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c >=:FromDate AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:ToDate';
        } else if(basedOn == 'Submitted Date/Customer Response Date'){
            query += ' AND ((Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c >=:FromDate AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:ToDate) OR (Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c >=:FromDate AND Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c <=:ToDate))';
        } else if(basedOn == 'Submitted Date/Closed Date'){
            query += ' AND ((Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c >=:FromDate AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:ToDate) OR (Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c >=:FromDate AND Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c <=:ToDate))';
        } else if(basedOn == 'Customer Response Date/Closed Date'){
            query += ' AND ((Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c >=:FromDate AND Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c <=:ToDate) OR (Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c >=:FromDate AND Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c <=:ToDate))';
        } else if(basedOn == 'Submitted Date/Customer Response Date/Closed Date'){
            query += ' AND ((Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c >=:FromDate AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=:ToDate) OR (Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c >=:FromDate AND Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c <=:ToDate) OR (Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c >=:FromDate AND Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c <=:ToDate))';
        }
        List<Phoenix_Bid_Line_Item__c> bidLineItemsList = Database.query(query);
        bidListWrapper responseWrapper1 = VisionQRMBidAnalysisCls.calculationHelper(bidLineItemsList);
        
        Integer Q1NPL = 0; Integer Q2NPL = 0; Integer Q1ProActive = 0; Integer Q2ProActive = 0; Integer Q1ReActive = 0; Integer Q2ReActive = 0; Integer Q1ROFRs = 0; Integer Q2ROFRs = 0;
        Map<String, Integer> mapOfAwarded = new Map<String, Integer>();
        mapOfAwarded.put('Q1NPL', responseWrapper1.NPLAwardedCount);mapOfAwarded.put('Q1ProActive', responseWrapper1.ProActiveAwardedCount);mapOfAwarded.put('Q1ReActive', responseWrapper1.ReActiveAwardedCount);mapOfAwarded.put('Q1ROFRs', responseWrapper1.ROFRAwardedCount);
        bidListWrapper wrapper = new bidListWrapper();
        wrapper.NPLList = responseWrapper1.NPLList;
        wrapper.ProActiveList = responseWrapper1.ProActiveList;
        wrapper.ReActiveList = responseWrapper1.ReActiveList;
        wrapper.ROFRList = responseWrapper1.ROFRList;
        wrapper.NPLSales = (Integer)responseWrapper1.NPLSales;
        wrapper.ProActiveSales = (Integer)responseWrapper1.ProActiveSales;
        wrapper.ReActiveSales = (Integer)responseWrapper1.ReActiveSales;
        wrapper.ROFRSales = (Integer)responseWrapper1.ROFRSales;
        wrapper.NPLAwardedCount = responseWrapper1.NPLAwardedCount;
        wrapper.ProActiveAwardedCount = responseWrapper1.ProActiveAwardedCount;
        wrapper.ReActiveAwardedCount = responseWrapper1.ReActiveAwardedCount;
        wrapper.ROFRAwardedCount = responseWrapper1.ROFRAwardedCount;
        wrapper.mapOfAwarded = mapOfAwarded;
        wrapper.quarter = quarter;
        wrapper.NPLBidsCount = responseWrapper1.NPLBidsCount;
        wrapper.ProActiveBidsCount = responseWrapper1.ProActiveBidsCount;
        wrapper.ReActiveBidsCount = responseWrapper1.ReActiveBidsCount;
        wrapper.ROFRBidsCount = responseWrapper1.ROFRBidsCount;
        wrapper.NPLAwardedList = responseWrapper1.NPLAwardedList;
        wrapper.ProActiveAwardedList = responseWrapper1.ProActiveAwardedList;
        wrapper.ReActiveAwardedList = responseWrapper1.ReActiveAwardedList;
        wrapper.ROFRAwardedList = responseWrapper1.ROFRAwardedList;
        return wrapper;
        
    }
    
    @AuraEnabled 
    public static bidListWrapper calculationHelper(List<Phoenix_Bid_Line_Item__c> bidLineItemsList){
        List<Phoenix_Bid_Line_Item__c> NPLList =  new List<Phoenix_Bid_Line_Item__c>();
        List<Phoenix_Bid_Line_Item__c> ProActiveList =  new List<Phoenix_Bid_Line_Item__c>();
        List<Phoenix_Bid_Line_Item__c> ReActiveList =  new List<Phoenix_Bid_Line_Item__c>();
        List<Phoenix_Bid_Line_Item__c> ROFRList =  new List<Phoenix_Bid_Line_Item__c>();
        Decimal NPLSales = 0; Decimal ProActiveSales = 0; Decimal ReActiveSales = 0; Decimal ROFRSales = 0; 
        Map<String, Integer> NPLBids = new Map<String, Integer>(); Map<String, Integer> ProActiveBids = new Map<String, Integer>(); Map<String, Integer> ReActiveBids = new Map<String, Integer>(); Map<String, Integer> ROFRBids = new Map<String, Integer>();
        Map<String, Integer> NPLAwardedCount = new Map<String, Integer>(); Map<String, Integer> ProActiveAwardedCount = new Map<String, Integer>(); Map<String, Integer> ReActiveAwardedCount = new Map<String, Integer>(); Map<String, Integer> ROFRAwardedCount = new Map<String, Integer>();
        Map<String, List<Phoenix_Bid_Line_Item__c>> NPLAwardedList = new Map<String, List<Phoenix_Bid_Line_Item__c>>(); Map<String, List<Phoenix_Bid_Line_Item__c>> ProActiveAwardedList = new Map<String, List<Phoenix_Bid_Line_Item__c>>();
        Map<String, List<Phoenix_Bid_Line_Item__c>> ReActiveAwardedList = new Map<String, List<Phoenix_Bid_Line_Item__c>>(); Map<String, List<Phoenix_Bid_Line_Item__c>> ROFRAwardedList = new Map<String, List<Phoenix_Bid_Line_Item__c>>();
        for(Phoenix_Bid_Line_Item__c bidLineItem: bidLineItemsList){
            Decimal awardedQty = ((bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? bidLineItem.Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
            Decimal proposedASP = ((bidLineItem.Phoenix_Proposed_ASP_Dose__c != null) ? bidLineItem.Phoenix_Proposed_ASP_Dose__c : 0);
            Decimal currentSales = ((bidLineItem.Phoenix_Current_Sales_Finance__c != null) ? bidLineItem.Phoenix_Current_Sales_Finance__c : 0);
            Decimal proposedQty = ((bidLineItem.Phoenix_Final_Total_Selling_Unit__c != null) ? bidLineItem.Phoenix_Final_Total_Selling_Unit__c : 0);
            Decimal awardedSales = awardedQty*proposedASP; Decimal proposedSales = proposedQty*proposedASP;
            if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Product Launch' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC New Product'){
                NPLList.add(bidLineItem);
                if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    NPLSales += (awardedSales-currentSales);
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
                }
                if(NPLBids.containskey(bidLineItem.Phoenix_Bid__c)) NPLBids.put(bidLineItem.Phoenix_Bid__c, NPLBids.get(bidLineItem.Phoenix_Bid__c) + 1);
                else NPLBids.put(bidLineItem.Phoenix_Bid__c, 1);
            } else if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Customer' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Addition' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Product Addition'){
                ProActiveList.add(bidLineItem);
                if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    ProActiveSales += (awardedSales-currentSales);
                    if(ProActiveAwardedCount.containskey(bidLineItem.Phoenix_Bid__c)) ProActiveAwardedCount.put(bidLineItem.Phoenix_Bid__c, ProActiveAwardedCount.get(bidLineItem.Phoenix_Bid__c) + 1);
                    else ProActiveAwardedCount.put(bidLineItem.Phoenix_Bid__c, 1);
                } else if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    ProActiveSales += (proposedSales-currentSales);
                }
                if(ProActiveBids.containskey(bidLineItem.Phoenix_Bid__c))  ProActiveBids.put(bidLineItem.Phoenix_Bid__c, ProActiveBids.get(bidLineItem.Phoenix_Bid__c) + 1);
                else ProActiveBids.put(bidLineItem.Phoenix_Bid__c, 1);
            } else if(((bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && ((((awardedQty * proposedASP) >= currentSales)) || (((proposedSales) > currentSales)))) || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Short Dated' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Volume Review'){ 
            //else if(((bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && ((currentSales == 0 && ((awardedQty * proposedASP) > currentSales)) || (currentSales == 0 && ((proposedSales) > currentSales)))) || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Short Dated' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Volume Review'){ 
                ReActiveList.add(bidLineItem);
                if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    ReActiveSales += (awardedSales-currentSales);
                    if(ReActiveAwardedCount.containskey(bidLineItem.Phoenix_Bid__c)) ReActiveAwardedCount.put(bidLineItem.Phoenix_Bid__c, ReActiveAwardedCount.get(bidLineItem.Phoenix_Bid__c) + 1);
                    else ReActiveAwardedCount.put(bidLineItem.Phoenix_Bid__c, 1);
                } else if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    ReActiveSales += (proposedSales-currentSales);
                }
                if(ReActiveBids.containskey(bidLineItem.Phoenix_Bid__c))  ReActiveBids.put(bidLineItem.Phoenix_Bid__c, ReActiveBids.get(bidLineItem.Phoenix_Bid__c) + 1);
                else ReActiveBids.put(bidLineItem.Phoenix_Bid__c, 1);
            } else if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Price Change' || ((bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && ((((awardedQty * proposedASP) < currentSales) && currentSales > 0) || ((proposedSales <= currentSales) && currentSales > 0)))){
                ROFRList.add(bidLineItem);
                if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    ROFRSales += (awardedSales-currentSales);
                    if(ROFRAwardedCount.containskey(bidLineItem.Phoenix_Bid__c)) ROFRAwardedCount.put(bidLineItem.Phoenix_Bid__c, ROFRAwardedCount.get(bidLineItem.Phoenix_Bid__c) + 1);
                    else ROFRAwardedCount.put(bidLineItem.Phoenix_Bid__c, 1);
                } else if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    ROFRSales += (awardedSales-currentSales);
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
        wrapper.ProActiveSales = ProActiveSales;
        wrapper.ReActiveSales = ReActiveSales;
        wrapper.ROFRSales = ROFRSales;
        wrapper.NPLAwardedCount = NPLAwardedCount.keySet().size();
        wrapper.ProActiveAwardedCount = ProActiveAwardedCount.keySet().size();
        wrapper.ReActiveAwardedCount = ReActiveAwardedCount.keySet().size();
        wrapper.ROFRAwardedCount = ROFRAwardedCount.keySet().size();
        wrapper.NPLBidsCount = NPLBids.keySet().size();
        wrapper.ProActiveBidsCount = ProActiveBids.keySet().size();
        wrapper.ReActiveBidsCount = ReActiveBids.keySet().size();
        wrapper.ROFRBidsCount = ROFRBids.keySet().size();
        wrapper.NPLAwardedList = NPLAwardedList;
        wrapper.ProActiveAwardedList = ProActiveAwardedList;
        wrapper.ReActiveAwardedList = ReActiveAwardedList;
        wrapper.ROFRAwardedList = ROFRAwardedList;
        return wrapper;
    }
    
    public class bidListWrapper{
        @AuraEnabled Public List<Phoenix_Bid_Line_Item__c> NPLList;
        @AuraEnabled Public Map<String, List<Phoenix_Bid_Line_Item__c>> NPLAwardedList;
        @AuraEnabled Public List<Phoenix_Bid_Line_Item__c> ProActiveList;
        @AuraEnabled Public Map<String, List<Phoenix_Bid_Line_Item__c>> ProActiveAwardedList;
        @AuraEnabled Public List<Phoenix_Bid_Line_Item__c> ReActiveList;
        @AuraEnabled Public Map<String, List<Phoenix_Bid_Line_Item__c>> ReActiveAwardedList;
        @AuraEnabled Public List<Phoenix_Bid_Line_Item__c> ROFRList;
        @AuraEnabled Public Map<String, List<Phoenix_Bid_Line_Item__c>> ROFRAwardedList;
        @AuraEnabled Public Decimal NPLSales;
        @AuraEnabled Public Decimal ProActiveSales;
        @AuraEnabled Public Decimal ReActiveSales;
        @AuraEnabled Public Decimal ROFRSales;
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
}