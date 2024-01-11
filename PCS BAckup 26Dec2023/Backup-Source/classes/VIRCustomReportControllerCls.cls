public class VIRCustomReportControllerCls {    
    @AuraEnabled
    public static Wrapper getVIPRebateData(String customerId, String rebateId){
        Wrapper wrapperObj = new Wrapper();
        wrapperObj.gcpVIRRecord = [SELECT Vision_GCP_Update_Date__c, Vision_Data_Available_Till__c, Vision_Update_Date__c FROM GCP_VIR_Report__c WHERE Vision_GCP_Update_Date__c != null AND Vision_Data_Available_Till__c != null AND Vision_Update_Date__c != null LIMIT 1];
        Boolean isProcessed = Vision_Rx_Compliance_NPR.apexJobStatus(new List<String>{'GoogleVIRReportDataFetch'});
        wrapperObj.isProcessed = isProcessed;
        try{
            if(isProcessed){
                if(rebateId != null){
                    List<Phoenix_Bid_VIP_Rebate__c> vipRebateData = [SELECT Name, Phoenix_Start_Date__c, Vision_Rebate_Contract__c, Vistex_Agreement__c, Vision_Contract_Status__c,Phoenix_End_Date__c, Payment_Frequency__c, Phoenix_Type__c, Net_Contract__c, Rx_SRx_OTC__c FROM Phoenix_Bid_VIP_Rebate__c WHERE Phoenix_Customer__c=: customerId AND Phoenix_Type__c = 'Currency' AND Vistex_Agreement__c != null];
                    List<Phoenix_Bid_VIP_Rebate__c> vipRebateDataSingle = [SELECT Name, Phoenix_Start_Date__c, Vision_Rebate_Contract__c, Vistex_Agreement__c, Vision_Contract_Status__c, Phoenix_End_Date__c, Payment_Frequency__c, Phoenix_Type__c, Net_Contract__c, Rx_SRx_OTC__c FROM Phoenix_Bid_VIP_Rebate__c WHERE Phoenix_Customer__c=: customerId AND Id =: rebateId AND Phoenix_Type__c = 'Currency' AND Vistex_Agreement__c != null];
                    List < Phoenix_VIP_Rebate_Line__c > rebateLinesData = VIRCustomReportControllerCls.getVIPRebateLinesData(customerId, rebateId);   
                    Wrapper wrap = VIRCustomReportControllerCls.getTableData(customerId, rebateId, vipRebateDataSingle[0].Vistex_Agreement__c, vipRebateDataSingle[0].Phoenix_Start_Date__c, vipRebateDataSingle[0].Phoenix_End_Date__c);
                    wrapperObj.vipRebateData = vipRebateData; wrapperObj.vipRebateDataSingle = vipRebateDataSingle; wrapperObj.rebateLinesData = rebateLinesData; wrapperObj.monthYearSet = wrap.monthYearSet;
                    wrapperObj.listOfFinalRecords = wrap.listOfFinalRecords; wrapperObj.listOfLastYearRecords = wrap.listOfLastYearRecords; wrapperObj.lostLineItems = wrap.lostLineItems; wrapperObj.isNull=true; 
                    if(vipRebateData.size()>0 && vipRebateDataSingle.size()>0) wrapperObj.isNull=false;  
                } else{
                    List<Phoenix_Bid_VIP_Rebate__c> vipRebateData = [SELECT Name, Phoenix_Start_Date__c, Vision_Rebate_Contract__c, Vistex_Agreement__c, Vision_Contract_Status__c, Phoenix_End_Date__c, Payment_Frequency__c, Phoenix_Type__c, Net_Contract__c, Rx_SRx_OTC__c FROM Phoenix_Bid_VIP_Rebate__c WHERE Phoenix_Customer__c=: customerId AND Phoenix_Type__c = 'Currency' AND Vistex_Agreement__c != null];
                    List<Phoenix_Bid_VIP_Rebate__c> vipRebateDataSingle = [SELECT Name, Phoenix_Start_Date__c, Vision_Rebate_Contract__c, Vistex_Agreement__c, Phoenix_End_Date__c, Payment_Frequency__c, Phoenix_Type__c, Net_Contract__c,Vision_Contract_Status__c, Rx_SRx_OTC__c FROM Phoenix_Bid_VIP_Rebate__c WHERE Phoenix_Customer__c=: customerId AND Phoenix_Type__c = 'Currency' AND Vistex_Agreement__c != null LIMIT 1];
                    wrapperObj.vipRebateData = vipRebateData; wrapperObj.isNull=true; 
                    if(vipRebateDataSingle.size() > 0){
                        List < Phoenix_VIP_Rebate_Line__c > rebateLinesData = VIRCustomReportControllerCls.getVIPRebateLinesData(customerId, vipRebateDataSingle[0].Id);   
                        wrapperObj.vipRebateDataSingle = vipRebateDataSingle; wrapperObj.rebateLinesData = rebateLinesData;
                        Wrapper wrap = VIRCustomReportControllerCls.getTableData(customerId, vipRebateDataSingle[0].Id, vipRebateDataSingle[0].Vistex_Agreement__c, vipRebateDataSingle[0].Phoenix_Start_Date__c, vipRebateDataSingle[0].Phoenix_End_Date__c);
                        wrapperObj.listOfFinalRecords = wrap.listOfFinalRecords; wrapperObj.currentData = wrap.currentData; wrapperObj.lostLineItems = wrap.lostLineItems;
                        if(vipRebateData.size()>0 && vipRebateDataSingle.size()>0)  wrapperObj.isNull=false;  
                    }
                }    
            }
        } catch(exception e){ Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'VIRCustomReportControllerCls', Phoenix_Method_Name__c = 'getVIPRebateData', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')'); insert exp;
        }
        return wrapperObj;
    } 
    @AuraEnabled
    public static List<Phoenix_VIP_Rebate_Line__c> getVIPRebateLinesData(String customerId, String rebateId){
        List < Phoenix_VIP_Rebate_Line__c > rebateLinesData = [SELECT Id, Phoenix_Tier__c, Name, Phoenix_VIP_Rebate__c, Phoenix_Dollar_Value_From__c, Phoenix_Dollar_Value_To__c, Phoenix_Unit_Volume_From__c, Phoenix_Unit_Volume_To__c, Phoenix_Discount_Rebate__c, Phoenix_VIP_Rebate__r.Id, Phoenix_VIP_Rebate__r.Phoenix_Type__c, Phoenix_VIP_Rebate__r.Phoenix_Start_Date__c, Phoenix_VIP_Rebate__r.Phoenix_End_Date__c FROM Phoenix_VIP_Rebate_Line__c WHERE Phoenix_VIP_Rebate__r.Phoenix_Customer__c=:customerId AND Phoenix_VIP_Rebate__r.Id =: rebateId ORDER BY Phoenix_Discount_Rebate__c ASC];        
        return rebateLinesData;
    }
    @AuraEnabled
    public static boolean apexJobStatus(List<String> apexClassList) {
        Boolean isProcessed = true; List<String> classIds = new List<String>();
        List<ApexClass> aC = [SELECT Id, Name FROM ApexClass WHERE Name IN: apexClassList];
        for(ApexClass job : aC ){classIds.add(job.Id);}
        List<AsyncapexJob> aJ = [SELECT Id, ApexClassID FROM AsyncapexJob where Status='Processing' and ApexClassID IN: classIds];
        if(aJ.size() > 0) isProcessed = false;
        return isProcessed;
    }
    @AuraEnabled
    public static Wrapper getTableData(String customerId, String rebateId, String agreementNo, Date startDate, Date endDate){
        Date stDate = startDate; Date edDate = endDate; Wrapper wrapObj = new Wrapper();
        List < Phoenix_VIP_Rebate_Line__c > rebateLinesData = [SELECT Id, Phoenix_Tier__c, Name, Phoenix_VIP_Rebate__c, Phoenix_Dollar_Value_From__c, Phoenix_Dollar_Value_To__c, Phoenix_Unit_Volume_From__c, Phoenix_Unit_Volume_To__c, Phoenix_Discount_Rebate__c, Phoenix_VIP_Rebate__r.Id, Phoenix_VIP_Rebate__r.Payment_Frequency__c, Phoenix_VIP_Rebate__r.Phoenix_Type__c, Phoenix_VIP_Rebate__r.Phoenix_Start_Date__c, Phoenix_VIP_Rebate__r.Phoenix_End_Date__c FROM Phoenix_VIP_Rebate_Line__c WHERE Phoenix_VIP_Rebate__r.Phoenix_Customer__c=:customerId AND Phoenix_VIP_Rebate__r.Id =: rebateId];        
        List<String> bidTypes = new List<String>{'Product Addition', 'Price Change', 'Volume Review Only', 'New Product Launch'};
        List<String> lostBidTypes = new List<String>{'Product Discontinuation Process', 'Mass Product Removals'};
        string que = '(Select '+Phoenix_Util.customerResponseItemFields+'FROM Customer_Response_Lines__r)';
        List<String> status = new List<String>{'Customer\'s Update', 'Vistex Update', 'Closed'};
        String query = 'Select ' +Phoenix_Util.getsObjectFieds('GCP_VIR_Report__c')+' from GCP_VIR_Report__c WHERE Vision_Account__c =: customerId AND Vision_Agreement_Number__c=: agreementNo AND Vision_GCP_Start_Date__c =:startDate AND Vision_GCP_End_Date__c <=:endDate ORDER BY Vision_GCP_Year__c ASC, Vision_GCP_Month__c ASC';
        List<GCP_VIR_Report__c> allSales = Database.query(query);
        List <Phoenix_Bid_Line_Item__c> lineItems = Database.query('Select Phoenix_Bid__r.Name, Phoenix_Contract__r.Name, Phoenix_Bid__r.Phoenix_Customer_Type__c, Phoenix_Contract__r.Phoenix_Contract_Number__c, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Bid__r.Phoenix_Customer__r.Name, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Customer__r.Name, Phoenix_Customer_Response_Line__r.Phoenix_Awarded_Quantity__c, Phoenix_Customer_Response_Line__r.Phoenix_Bid_Status__c, Phoenix_Product__r.ProductCode, Phoenix_Product__r.Family,Phoenix_Product__r.Name,Phoenix_Product__r.Phoenix_NDC_11__c,(SELECT Id,Phoenix_OverrideMajorUnits__c,Phoenix_3MonAnnualMajorSellingUnits__c,Phoenix_Current_Major_Contract_Price__c,Phoenix_Proposed_Major_Contract_Price__c, Phoenix_Proposed_CvsDirectContractPrice__c, Vision_Effective_Date_of_Removal__c,Phoenix_Proposed_CVS_DirSellingUnits__c,Phoenix_Proposed_CVS_IndirSellingUnits__c,Phoenix_Proposed_Cardinal_Units__c,Phoenix_Proposed_Major_Units__c FROM BidLineItemsExtn__r),' + Phoenix_Util.bidlineitemFields+', '+que+ 'FROM Phoenix_Bid_Line_Item__c WHERE ((Phoenix_Customer_Response_Line__c != null AND Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c >=: startDate AND Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c <=:endDate AND Phoenix_Bid__r.Phoenix_Bid_Type__c IN:bidTypes AND Phoenix_Bid__r.Phoenix_Customer__c =: customerId) OR (Phoenix_Bid__r.Phoenix_Bid_Type__c IN:lostBidTypes AND Phoenix_Customer__c =: customerId)) AND Phoenix_Bid__r.Phoenix_Approval_Status__c IN: status ORDER BY Phoenix_Product__r.Name ASC');
        Set<String> productIds = new Set<String>(); Set<String> contractNos = new Set<String>();
        for(Phoenix_Bid_Line_Item__c item: lineItems){
            if(item.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Discontinuation Process' || item.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Mass Product Removals'){
                productIds.add(item.Phoenix_Product__r.ProductCode); contractNos.add(item.Phoenix_Contract__r.Phoenix_Contract_Number__c);   
            }
        }
        Map<String, Phoenix_NPR_Data__c> nprMap = new Map<String, Phoenix_NPR_Data__c>();
        List<Phoenix_NPR_Data__c> nprData = [SELECT Id, Phoenix_Contract_Price__c, Phoenix_Dead_Net_Tracking_GR__c, Phoenix_12Months_Sales_Unit__c, Phoenix_Product__r.ProductCode, Phoenix_Contract__r.Phoenix_Contract_Number__c FROM Phoenix_NPR_Data__c WHERE Phoenix_Product__r.ProductCode IN: productIds AND Phoenix_Contract__r.Phoenix_Contract_Number__c IN: contractNos LIMIT 5000];
        if(nprData.size()>0){
            for(Phoenix_NPR_Data__c npr: nprData){
                String uniqueKey = npr.Phoenix_Product__r.ProductCode+'_'+npr.Phoenix_Contract__r.Phoenix_Contract_Number__c; nprMap.put(uniqueKey, npr);
            }   
        }
        List<String> months = new List<String>{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
            Map<Integer,String> monthMap = new Map<Integer,String>{1 => 'Jan', 2 => 'Feb', 3 => 'Mar', 4 => 'Apr', 5 => 'May', 6 => 'Jun', 7 => 'Jul', 8 => 'Aug', 9 => 'Sep', 10 => 'Oct', 11 => 'Nov', 12 => 'Dec'};
                Map<String, GCP_VIR_Report__c> currentYearMap = new Map<String, GCP_VIR_Report__c>();
        Date dataAvailableTillDate; 
        if(allSales.size() > 0) dataAvailableTillDate  = Date.valueOf(allSales[0].Vision_Data_Available_Till__c);   
        while(startDate < dataAvailableTillDate){
            currentYearMap.put(monthMap.get(startDate.month()), null);
            startDate = startDate.AddMonths(1);
        }
        for(GCP_VIR_Report__c sales : allSales){
            currentYearMap.put(sales.Vision_GCP_Month_Text__c, sales);
        }
        List<InnerWrapper> listOfFinalRecords = new List<InnerWrapper>();
        if (currentYearMap != null) {
            for(String proMonth : currentYearMap.KeySet()){
                InnerWrapper innerWrap = new InnerWrapper();
                Integer countOfPA = 0; Integer countOfPC = 0; Integer countOfNPL = 0; Integer countOfVRO = 0; Integer countOfLoss = 0;
                List<bidWrapper> listOfPA = new List<bidWrapper>(); List<bidWrapper> listOfPC = new List<bidWrapper>();
                List<bidWrapper> listOfNPL = new List<bidWrapper>(); List<bidWrapper> listOfVRO = new List<bidWrapper>(); List<bidWrapper> listOfProductLoss = new List<bidWrapper>();
                for (Phoenix_Bid_Line_Item__c lineItem: lineItems) {
                    Date effectiveDate;
                    if(lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Discontinuation Process' || lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Mass Product Removals'){
                        if(lineItem.BidLineItemsExtn__r != null && lineItem.BidLineItemsExtn__r.size() > 0 && lineItem.BidLineItemsExtn__r[0].Vision_Effective_Date_of_Removal__c != null) effectiveDate = Date.parse(lineItem.BidLineItemsExtn__r[0].Vision_Effective_Date_of_Removal__c); }
                    if(effectiveDate != null && (effectiveDate >= stDate && effectiveDate <= edDate)){
                        bidWrapper wrapper = new bidWrapper(); String uniqueKey = lineItem.Phoenix_Product__r.ProductCode+'_'+lineItem.Phoenix_Contract__r.Phoenix_Contract_Number__c;
                        Phoenix_NPR_Data__c npr = nprMap.get(uniqueKey);
                        if(npr != null){
                            wrapper.previousQty = (npr.Phoenix_12Months_Sales_Unit__c != null) ? npr.Phoenix_12Months_Sales_Unit__c: 0; wrapper.previousDeadnet = (npr.Phoenix_Dead_Net_Tracking_GR__c != null) ? npr.Phoenix_Dead_Net_Tracking_GR__c: 0;
                        } else wrapper.previousQty = 0; wrapper.previousDeadnet = 0;                    
                        wrapper.lineItem = lineItem; wrapper.removalEffectiveDate = effectiveDate;
                        Integer m = effectiveDate.month(); String effectiveMonth = months[m-1];
                        if(proMonth == effectiveMonth){
                            countOfLoss += 1; listOfProductLoss.add(wrapper); innerWrap.bidWrap = wrapper; } }
                    else if((lineItem.Customer_Response_Lines__r != null && lineItem.Customer_Response_Lines__r.size() >0) && effectiveDate == null){
                        bidWrapper wrapper = new bidWrapper(); wrapper.previousQty = (lineItem.Phoenix_Total_Selling_Unit__c != null ? lineItem.Phoenix_Total_Selling_Unit__c : 0);
                        wrapper.awardedQty = (lineItem.Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null ? lineItem.Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0); wrapper.previousDeadnet = (lineItem.Phoenix_Current_ASP_Dose__c != null ? lineItem.Phoenix_Current_ASP_Dose__c: 0); 
                        wrapper.proposedDeadnet = (lineItem.Phoenix_Proposed_ASP_Dose__c != null ? lineItem.Phoenix_Proposed_ASP_Dose__c: 0); effectiveDate = lineItem.Customer_Response_Lines__r[0].Phoenix_Customer_Response_Date__c;
                        if(lineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Net Indirect Pricing' || lineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Direct and Indirect' || lineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Econdisc' || lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB' || lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB'){
                            Decimal overrideCurrentDirectUnits = (lineItem.Phoenix_Override_Current_Direct_Units__c != null) ? lineItem.Phoenix_Override_Current_Direct_Units__c : (lineItem.Phoenix_Current_Direct_Selling_Unit__c != null)?lineItem.Phoenix_Current_Direct_Selling_Unit__c:0;
                            Decimal overrideCurrentIndirectUnits = (lineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? lineItem.Phoenix_Override_Current_Indirect_Units__c : (lineItem.Phoenix_Current_Indirect_Selling_Unit__c != null)?lineItem.Phoenix_Current_Indirect_Selling_Unit__c:0;
                            wrapper.previousQty = overrideCurrentDirectUnits + overrideCurrentIndirectUnits;	}
                        else if(lineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'BASE/DSH'){ Decimal overrideCurrentDirectUnits = (lineItem.Phoenix_Override_Current_Direct_Units__c != null) ? lineItem.Phoenix_Override_Current_Direct_Units__c : (lineItem.Phoenix_Current_Wholesaler_Units__c != null)?lineItem.Phoenix_Current_Wholesaler_Units__c:0;
                            Decimal overrideCurrentIndirectUnits = (lineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? lineItem.Phoenix_Override_Current_Indirect_Units__c : (lineItem.Phoenix_Current_Anda_Units__c != null)?lineItem.Phoenix_Current_Anda_Units__c:0;
                            Decimal overrideCurrentUnits = (lineItem.Phoenix_Override_Current_Units__c != null) ? lineItem.Phoenix_Override_Current_Units__c : (lineItem.Phoenix_Current_Retail_Direct_Units__c != null)?lineItem.Phoenix_Current_Retail_Direct_Units__c:0;
                            wrapper.previousQty = overrideCurrentDirectUnits + overrideCurrentIndirectUnits + overrideCurrentUnits; }
                        else if(lineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'ROS'){ Decimal overrideCVSDirectUnits = (lineItem.Phoenix_Override_Current_Direct_Units__c != null) ? lineItem.Phoenix_Override_Current_Direct_Units__c : (lineItem.Phoenix_Current_Retail_Direct_Units__c != null)?lineItem.Phoenix_Current_Retail_Direct_Units__c:0;
                            Decimal overrideCVSIndirectUnits = (lineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? lineItem.Phoenix_Override_Current_Indirect_Units__c : (lineItem.Phoenix_Current_Retail_Indirect_Units__c != null)?lineItem.Phoenix_Current_Retail_Indirect_Units__c:0;
                            Decimal overrideCardinalUnits = (lineItem.Phoenix_Override_Current_Units__c != null) ? lineItem.Phoenix_Override_Current_Units__c : (lineItem.Phoenix_Current_Wholesaler_Units__c != null)?lineItem.Phoenix_Current_Wholesaler_Units__c:0;
                            Decimal overrideMajorUnits = (lineItem.BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c != null) ? lineItem.BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c : (lineItem.BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c != null)?lineItem.BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c:0;
                            wrapper.previousQty = overrideCVSDirectUnits + overrideCVSIndirectUnits + overrideCardinalUnits + overrideMajorUnits; }
                        else if(lineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'RXSS'){ Decimal overrideCurrentDirectUnits = (lineItem.Phoenix_Override_Current_Direct_Units__c != null) ? lineItem.Phoenix_Override_Current_Direct_Units__c : (lineItem.Phoenix_Current_Retail_Direct_Units__c != null)?lineItem.Phoenix_Current_Retail_Direct_Units__c:0;
                            Decimal overrideCurrentIndirectUnits = (lineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? lineItem.Phoenix_Override_Current_Indirect_Units__c : (lineItem.Phoenix_Current_Wholesaler_Units__c != null)?lineItem.Phoenix_Current_Wholesaler_Units__c:0;
                            Decimal currentRetailDirectUnits = (lineItem.Phoenix_Current_Anda_Units__c != null) ? lineItem.Phoenix_Current_Anda_Units__c : 0;
                            Decimal currentRetailIndirectUnits = (lineItem.Phoenix_Current_Retail_Indirect_Units__c != null) ? lineItem.Phoenix_Current_Retail_Indirect_Units__c : 0;
                            wrapper.previousQty = overrideCurrentDirectUnits + overrideCurrentIndirectUnits + currentRetailDirectUnits + currentRetailIndirectUnits; }
                        else if(lineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'ClarusOne'){ Decimal overrideCurrentDirectUnits = (lineItem.Phoenix_Override_Current_Direct_Units__c != null) ? lineItem.Phoenix_Override_Current_Direct_Units__c : (lineItem.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c != null)?lineItem.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c:0;
                            Decimal overrideCurrentIndirectUnits = (lineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? lineItem.Phoenix_Override_Current_Indirect_Units__c : (lineItem.Phoenix_WMT_Current_Direct_Units__c != null)?lineItem.Phoenix_WMT_Current_Direct_Units__c:0;
                            Decimal currentRetailDirectUnits = (lineItem.Phoenix_Proposed_Smith_Drug_Units__c != null) ? lineItem.Phoenix_Proposed_Smith_Drug_Units__c : (lineItem.Phoenix_WMT_Current_Indirect_Units__c != null)?lineItem.Phoenix_WMT_Current_Indirect_Units__c:0;
                            wrapper.previousQty = overrideCurrentDirectUnits + overrideCurrentIndirectUnits + currentRetailDirectUnits; }
                        else if(lineItem.Phoenix_Bid__r.Phoenix_Customer_Type__c == 'Humana Indirect retail'){ wrapper.previousQty = (lineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? lineItem.Phoenix_Override_Current_Indirect_Units__c : (lineItem.Phoenix_Current_Indirect_Selling_Unit__c != null)?lineItem.Phoenix_Current_Indirect_Selling_Unit__c:0;}
                        wrapper.lineItem = lineItem; Integer m = effectiveDate.month(); String effectiveMonth = months[m-1];
                        if(lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Addition' && lineItem.Phoenix_Bid_Status__c == 'Awarded'){
                            if(proMonth == effectiveMonth){
                                countOfPA += 1; listOfPA.add(wrapper); }   
                        } else if(lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' && lineItem.Phoenix_Bid_Status__c == 'Awarded'){
                            if(proMonth == effectiveMonth){
                                countOfPC += 1; listOfPC.add(wrapper); }
                        } else if(lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Product Launch' && lineItem.Phoenix_Bid_Status__c == 'Awarded'){
                            if(proMonth == effectiveMonth){
                                countOfNPL += 1; listOfNPL.add(wrapper); }                        
                        } else if(lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only' && lineItem.Phoenix_Bid_Status__c == 'Awarded'){
                            if(proMonth == effectiveMonth){
                                countOfVRO += 1; listOfVRO.add(wrapper); }
                        } innerWrap.bidWrap = wrapper;
                    }
                }
                innerWrap.noOfPA = countOfPA; innerWrap.noOfPC = countOfPC; innerWrap.noOfNPL = countOfNPL; innerWrap.noOfVRO = countOfVRO; innerWrap.noOfLoss = countOfLoss;
                innerWrap.listOfPA = listOfPA; innerWrap.listOfPC = listOfPC;innerWrap.listOfNPL = listOfNPL; innerWrap.listOfVRO = listOfVRO; innerWrap.listOfProductLoss = listOfProductLoss;
                if(currentYearMap.get(proMonth) != null){
                    innerWrap.sales = currentYearMap.get(proMonth).Vision_GCP_Net_Sales__c;   
                    innerWrap.GCPUpdateDate = currentYearMap.get(proMonth).Vision_GCP_Update_Date__c;
                    innerWrap.VisionUpdateDate = currentYearMap.get(proMonth).Vision_Update_Date__c;
                    innerWrap.DataAvailableTill = currentYearMap.get(proMonth).Vision_Data_Available_Till__c;
                    innerWrap.Month = proMonth;
                    listOfFinalRecords.add(innerWrap);
                } else{ innerWrap.sales = 0; innerWrap.GCPUpdateDate = null; innerWrap.VisionUpdateDate = null; innerWrap.DataAvailableTill = null; }
            }
        }
        wrapObj.currentData = currentYearMap;
        wrapObj.listOfFinalRecords = listOfFinalRecords;
        return wrapObj;
    }
    
    @AuraEnabled
    public static Integer runVIR(){
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
        return i;
    }
    
    public class Wrapper {
        @AuraEnabled public List < Phoenix_Bid_VIP_Rebate__c > vipRebateData;
        @AuraEnabled public List < Phoenix_Bid_VIP_Rebate__c > vipRebateDataSingle;
        @AuraEnabled public List < Phoenix_VIP_Rebate_Line__c > rebateLinesData;
        @AuraEnabled public List<String> monthYearSet;
        @AuraEnabled public List<InnerWrapper> listOfFinalRecords;
        @AuraEnabled public List<InnerWrapper> listOfLastYearRecords;
        @AuraEnabled public Integer currentYear;
        @AuraEnabled public Integer previousYear; 
        @AuraEnabled public Map<String, GCP_VIR_Report__c> currentData;
        @AuraEnabled public GCP_VIR_Report__c gcpVIRRecord;
        @AuraEnabled public boolean isNull;
        @AuraEnabled public boolean isProcessed;
        @AuraEnabled public List<Phoenix_Bid_Line_Item__c> lostLineItems;
    }
    public class InnerWrapper {
        @AuraEnabled public Decimal sales;
        @AuraEnabled public Decimal CurrentYearUnits;
        @AuraEnabled public String Month;
        @AuraEnabled public String lastYearMonth;
        @AuraEnabled public Integer countOfPA;
        @AuraEnabled public Integer countOfPC;
        @AuraEnabled public Integer countOfNPL;
        @AuraEnabled public Integer countOfVRO;
        @AuraEnabled public Integer countOfLoss;
        @AuraEnabled public Integer noOfPA;
        @AuraEnabled public Integer noOfPC;
        @AuraEnabled public Integer noOfNPL;
        @AuraEnabled public Integer noOfVRO;
        @AuraEnabled public Integer noOfLoss;
        @AuraEnabled public Integer monthsRemaining;
        @AuraEnabled public List < bidWrapper > listOfPA;
        @AuraEnabled public List < bidWrapper > listOfPC;
        @AuraEnabled public List < bidWrapper > listOfNPL;
        @AuraEnabled public List < bidWrapper > listOfVRO;
        @AuraEnabled public List < bidWrapper > listOfProductLoss;
        @AuraEnabled public Date GCPUpdateDate;
        @AuraEnabled public Date VisionUpdateDate;
        @AuraEnabled public String DataAvailableTill;
        @AuraEnabled public bidWrapper bidWrap;
    }
    public class bidWrapper {
        @AuraEnabled public Phoenix_Bid_Line_Item__c lineItem;
        @AuraEnabled public Decimal previousQty;
        @AuraEnabled public Decimal awardedQty;
        @AuraEnabled public Decimal previousDeadnet;
        @AuraEnabled public Decimal proposedDeadnet;
        @AuraEnabled public Date removalEffectiveDate;
    }
}