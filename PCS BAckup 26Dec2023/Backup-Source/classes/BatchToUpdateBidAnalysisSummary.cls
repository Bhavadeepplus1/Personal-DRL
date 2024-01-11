public class BatchToUpdateBidAnalysisSummary implements Database.Batchable < sObject > , Database.Stateful,Database.AllowsCallouts {
    
    private static List<Phoenix_Bid__c> bidsListToUpdate = new List<Phoenix_Bid__c>();
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        List<String> listOfStatus = new List<String>{'Closed', 'Customer Rejected', 'Vistex Update', 'Customer\'s Update'};
            String query = 'select Id from Phoenix_Bid_Line_Item__c where Phoenix_Bid__r.Phoenix_Approval_Status__c IN:listOfStatus'  ; // AND Phoenix_Final_Status__c !=: notApproved
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List < Phoenix_Bid_Line_Item__c > bidLines) {
        /*try{
            List<String> lineItemIds = new List<String>();
            for(Phoenix_Bid_Line_Item__c lineItem: bidLines){
                lineItemIds.add(lineItem.Id);
            }
            Map<Id, List<Phoenix_Bid_Line_Item__c>> bidsMap = new Map<Id,  List<Phoenix_Bid_Line_Item__c>>();
            List<String> listOfStatus = new List<String>{'Closed', 'Customer Rejected', 'Vistex Update', 'Customer\'s Update'};
                String query = 'select Phoenix_Contract__r.Phoenix_Contract_Number__c, Phoenix_Product__r.ProductCode, Phoenix_Bid__r.Id, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Name, ' + Phoenix_Util.getsObjectFieds('Phoenix_Bid_Line_Item__c') + ', (SELECT Id, Name, Phoenix_Customer_Response_Date__c, Phoenix_Customer_Decline_Reasons__c, Final_Direct_Price__c, Final_Indirect_Price__c, Phoenix_Bid_Status__c,Phoenix_Award_Position__c,Phoenix_Supply_Effective_Date__c,Phoenix_Price_Effective_Date__c,Phoenix_Awarded_Quantity__c,Phoenix_Final_Approvd_Pricing_Contracts__c,Phoenix_Final_Total_Selling_Unit__c FROM Customer_Response_Lines__r),(SELECT Id,Phoenix_OverrideMajorUnits__c,Phoenix_3MonAnnualMajorSellingUnits__c, Vision_Effective_Date_of_Removal__c FROM BidLineItemsExtn__r), Phoenix_Product__r.name from Phoenix_Bid_Line_Item__c where Id IN: lineItemIds AND Phoenix_Bid__r.Phoenix_Approval_Status__c IN:listOfStatus'  ; // AND Phoenix_Final_Status__c !=: notApproved
            List < Phoenix_Bid_Line_Item__c > lineItemsList = Database.query(query);
            List<Phoenix_BidLineItemExtn__c> updateExtnList = new List<Phoenix_BidLineItemExtn__c>();
            for(Phoenix_Bid_Line_Item__c lineItem: lineItemsList){
                if(bidsMap.containsKey(lineItem.Phoenix_Bid__r.Id)){
                    List<Phoenix_Bid_Line_Item__c> tempList = bidsMap.get(lineItem.Phoenix_Bid__r.Id);
                    tempList.add(lineItem);
                    bidsMap.put(lineItem.Phoenix_Bid__r.Id, tempList);
                } else{
                    bidsMap.put(lineItem.Phoenix_Bid__r.Id, new List<Phoenix_Bid_Line_Item__c>{ lineItem });
                }
            }
            for(Id bidId: bidsMap.keySet()){
                Phoenix_Bid__c bid = [Select Id, Phoenix_Customer_Type__c, Phoenix_Bid_Type__c, Vision_Total_Bid_Line_Items__c, Vision_Previous_Total__c, Vision_Current_Total__c, Vision_Total_Annual_Impact__c, Vision_Total_FY_Business_Impact__c from Phoenix_Bid__c where ID =: bidId LIMIT 1];
                string notApproved = 'Not Approved';
                string query2 = '';
                List<String> listOfStatusOTC = new List<String>{'Closed', 'Vistex Update'};
                    Boolean isOTCType = false;
                if(bid.Phoenix_Bid_Type__c == 'OTC New Product' || bid.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' || bid.Phoenix_Bid_Type__c == 'OTC OTB Short Dated' || bid.Phoenix_Bid_Type__c == 'OTC Price Change'
                   || bid.Phoenix_Bid_Type__c == 'OTC Product Addition' || bid.Phoenix_Bid_Type__c == 'OTC Rebate Change' || bid.Phoenix_Bid_Type__c == 'OTC RFP' || bid.Phoenix_Bid_Type__c == 'OTC Volume Review'){
                       isOTCType = true;
                       query2 = 'select Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Product__r.ProductCode, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Name, Phoenix_Customer__r.Name, Phoenix_Contract__r.Name, Phoenix_Contract__r.Phoenix_Contract_Number__c, (SELECT Id, Name, Phoenix_Customer_Response_Date__c, Phoenix_Customer_Decline_Reasons__c, Final_Direct_Price__c, Final_Indirect_Price__c, Phoenix_Bid_Status__c,Phoenix_Award_Position__c,Phoenix_Supply_Effective_Date__c,Phoenix_Price_Effective_Date__c,Phoenix_Awarded_Quantity__c,Phoenix_Final_Approvd_Pricing_Contracts__c,Phoenix_Final_Total_Selling_Unit__c FROM Customer_Response_Lines__r),(SELECT Id,Phoenix_OverrideMajorUnits__c,Phoenix_3MonAnnualMajorSellingUnits__c,Phoenix_Current_Major_Contract_Price__c,Phoenix_Proposed_Major_Contract_Price__c, Phoenix_Proposed_CvsDirectContractPrice__c, Vision_Effective_Date_of_Removal__c FROM BidLineItemsExtn__r), Phoenix_Product__r.name from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c = : bidId AND Phoenix_Customer_Approval_OTC__c =: notApproved ORDER BY Phoenix_Product_Family__c ASC LIMIT 1 '  ; // AND Phoenix_Final_Status__c !=: notApproved
                   }
                List<Phoenix_Bid_Line_Item__c> OTCNoEffectList = new List<Phoenix_Bid_Line_Item__c>();
                if(!String.isBlank(query2)){
                    OTCNoEffectList = Database.query(query2);
                }
                List<Phoenix_Bid_Line_Item__c> lineItems = bidsMap.get(bidId);
                Decimal currentTotal = 0;
                Decimal previousTotal = 0;
                Decimal totalAnnualImpact = 0;
                Decimal totalFYBusinessImpact = 0;
                Set<Id> newAwards = new Set<Id>();
                Set<Id> priceChanges = new Set<Id>();
                Set<Id> volumeChanges = new Set<Id>();
                Set<Id> priceAndVolumeChanges = new Set<Id>();
                Set<Id> noEffects = new Set<Id>();
                Set<Id> productsLost = new Set<Id>();
                for(Phoenix_Bid_Line_Item__c lineItem: lineItems){
                    String category = '';
                    Decimal previousQty = 0;
                    Decimal previousIndirectPrice = 0;
                    Decimal awardedQty = (lineItem.Customer_Response_Lines__r != null && lineItem.Customer_Response_Lines__r.size()>0) ? lineItem.Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : null;
                    if(lineItem.Customer_Response_Lines__r != null && lineItem.Customer_Response_Lines__r.size()>0 && lineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        if(bid.Phoenix_Customer_Type__c == 'Direct'){
                            previousQty = lineItem.Phoenix_Total_Selling_Unit__c;
                            if(previousQty > 0){
                                category = 'Business Retained';
                            } else{
                                category = 'Business Gained';
                                newAwards.add(lineItem.Id);
                            }   
                        } 
                        else if(bid.Phoenix_Customer_Type__c == 'Net Indirect Pricing' || bid.Phoenix_Customer_Type__c == 'Direct and Indirect' || bid.Phoenix_Customer_Type__c == 'Econdisc' || bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Good Dated OTB'){
                            Decimal overrideCurrentDirectUnits = (lineItem.Phoenix_Override_Current_Direct_Units__c != null) ? lineItem.Phoenix_Override_Current_Direct_Units__c : (lineItem.Phoenix_Current_Direct_Selling_Unit__c != null)?lineItem.Phoenix_Current_Direct_Selling_Unit__c:0;
                            Decimal overrideCurrentIndirectUnits = (lineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? lineItem.Phoenix_Override_Current_Indirect_Units__c : (lineItem.Phoenix_Current_Indirect_Selling_Unit__c != null)?lineItem.Phoenix_Current_Indirect_Selling_Unit__c:0;
                            previousQty = overrideCurrentDirectUnits + overrideCurrentIndirectUnits;
                            if(previousQty > 0){
                                category = 'Business Retained';
                            } else{
                                category = 'Business Gained';
                                newAwards.add(lineItem.Id);
                            }
                        } 
                        else if(bid.Phoenix_Customer_Type__c == 'BASE/DSH'){
                            Decimal overrideCurrentDirectUnits = (lineItem.Phoenix_Override_Current_Direct_Units__c != null) ? lineItem.Phoenix_Override_Current_Direct_Units__c : (lineItem.Phoenix_Current_Wholesaler_Units__c != null)?lineItem.Phoenix_Current_Wholesaler_Units__c:0;
                            Decimal overrideCurrentIndirectUnits = (lineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? lineItem.Phoenix_Override_Current_Indirect_Units__c : (lineItem.Phoenix_Current_Anda_Units__c != null)?lineItem.Phoenix_Current_Anda_Units__c:0;
                            Decimal overrideCurrentUnits = (lineItem.Phoenix_Override_Current_Units__c != null) ? lineItem.Phoenix_Override_Current_Units__c : (lineItem.Phoenix_Current_Retail_Direct_Units__c != null)?lineItem.Phoenix_Current_Retail_Direct_Units__c:0;
                            previousQty = overrideCurrentDirectUnits + overrideCurrentIndirectUnits + overrideCurrentUnits;
                            if(previousQty > 0){
                                category = 'Business Retained';
                            } else{
                                category = 'Business Gained';
                                newAwards.add(lineItem.Id);
                            }
                        } 
                        else if(bid.Phoenix_Customer_Type__c == 'Walgreens' || bid.Phoenix_Customer_Type__c == 'ABC Progen' || bid.Phoenix_Customer_Type__c == 'ABC Pharmagen' || bid.Phoenix_Customer_Type__c == 'Costco' || bid.Phoenix_Customer_Type__c == 'Indirect' || bid.Phoenix_Customer_Type__c == 'Sams Club' || bid.Phoenix_Customer_Type__c == 'Government Pricing'){
                            previousQty = lineItem.Phoenix_Total_Selling_Unit__c;
                            if(previousQty > 0){
                                category = 'Business Retained';
                            } else{
                                category = 'Business Gained';
                                newAwards.add(lineItem.Id);
                            }
                        } 
                        else if(bid.Phoenix_Customer_Type__c == 'ROS'){
                            Decimal overrideCVSDirectUnits = (lineItem.Phoenix_Override_Current_Direct_Units__c != null) ? lineItem.Phoenix_Override_Current_Direct_Units__c : (lineItem.Phoenix_Current_Retail_Direct_Units__c != null)?lineItem.Phoenix_Current_Retail_Direct_Units__c:0;
                            Decimal overrideCVSIndirectUnits = (lineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? lineItem.Phoenix_Override_Current_Indirect_Units__c : (lineItem.Phoenix_Current_Retail_Indirect_Units__c != null)?lineItem.Phoenix_Current_Retail_Indirect_Units__c:0;
                            Decimal overrideCardinalUnits = (lineItem.Phoenix_Override_Current_Units__c != null) ? lineItem.Phoenix_Override_Current_Units__c : (lineItem.Phoenix_Current_Wholesaler_Units__c != null)?lineItem.Phoenix_Current_Wholesaler_Units__c:0;
                            Decimal overrideMajorUnits = (lineItem.BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c != null) ? lineItem.BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c : (lineItem.BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c != null)?lineItem.BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c:0;
                            previousQty = overrideCVSDirectUnits + overrideCVSIndirectUnits + overrideCardinalUnits + overrideMajorUnits;
                            if(previousQty > 0){
                                category = 'Business Retained';
                            } else{
                                category = 'Business Gained';
                                newAwards.add(lineItem.Id);
                            }
                        }  
                        else if(bid.Phoenix_Customer_Type__c == 'RXSS'){
                            Decimal overrideCurrentDirectUnits = (lineItem.Phoenix_Override_Current_Direct_Units__c != null) ? lineItem.Phoenix_Override_Current_Direct_Units__c : (lineItem.Phoenix_Current_Retail_Direct_Units__c != null)?lineItem.Phoenix_Current_Retail_Direct_Units__c:0;
                            Decimal overrideCurrentIndirectUnits = (lineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? lineItem.Phoenix_Override_Current_Indirect_Units__c : (lineItem.Phoenix_Current_Wholesaler_Units__c != null)?lineItem.Phoenix_Current_Wholesaler_Units__c:0;
                            Decimal currentRetailDirectUnits = (lineItem.Phoenix_Current_Anda_Units__c != null) ? lineItem.Phoenix_Current_Anda_Units__c : 0;
                            Decimal currentRetailIndirectUnits = (lineItem.Phoenix_Current_Retail_Indirect_Units__c != null) ? lineItem.Phoenix_Current_Retail_Indirect_Units__c : 0;
                            previousQty = overrideCurrentDirectUnits + overrideCurrentIndirectUnits + currentRetailDirectUnits + currentRetailIndirectUnits;
                            if(previousQty > 0){
                                category = 'Business Retained';
                            } else{
                                category = 'Business Gained';
                                newAwards.add(lineItem.Id);
                            }
                        }  
                        else if(bid.Phoenix_Customer_Type__c == 'ClarusOne'){
                            Decimal overrideCurrentDirectUnits = (lineItem.Phoenix_Override_Current_Direct_Units__c != null) ? lineItem.Phoenix_Override_Current_Direct_Units__c : (lineItem.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c != null)?lineItem.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c:0;
                            Decimal overrideCurrentIndirectUnits = (lineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? lineItem.Phoenix_Override_Current_Indirect_Units__c : (lineItem.Phoenix_WMT_Current_Direct_Units__c != null)?lineItem.Phoenix_WMT_Current_Direct_Units__c:0;
                            Decimal currentRetailDirectUnits = (lineItem.Phoenix_Proposed_Smith_Drug_Units__c != null) ? lineItem.Phoenix_Proposed_Smith_Drug_Units__c : (lineItem.Phoenix_WMT_Current_Indirect_Units__c != null)?lineItem.Phoenix_WMT_Current_Indirect_Units__c:0;
                            previousQty = overrideCurrentDirectUnits + overrideCurrentIndirectUnits + currentRetailDirectUnits;
                            if(previousQty > 0){
                                category = 'Business Retained';
                            } else{
                                category = 'Business Gained';
                                newAwards.add(lineItem.Id);
                            }
                        }  
                        else if(bid.Phoenix_Customer_Type__c == 'Sams Club'){
                            previousQty = (lineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != null) ? lineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c : 0;
                            if(previousQty > 0){
                                category = 'Business Retained';
                            } else{
                                category = 'Business Gained';
                                newAwards.add(lineItem.Id);
                            }
                        }
                    }
                    else if(lineItem.Customer_Response_Lines__r != null && lineItem.Customer_Response_Lines__r.size()>0 && (lineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || lineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || lineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number')){
                        category = 'No Effect';
                    }
                    else if(bid.Phoenix_Bid_Type__c == 'Product Discontinuation Process' || bid.Phoenix_Bid_Type__c == 'Mass Product Removals'){
                        category = 'Product Lost';
                    }
                    if(category != 'Business Gained' && category != 'No Effect' && category != 'Product Lost'){
                        if(lineItem.Phoenix_Proposed_ASP_Dose__c != lineItem.Phoenix_Current_ASP_Dose__c && awardedQty != previousQty){
                            priceAndVolumeChanges.add(lineItem.Id);
                        }
                        if(lineItem.Phoenix_Proposed_ASP_Dose__c != lineItem.Phoenix_Current_ASP_Dose__c && !priceAndVolumeChanges.contains(lineItem.Id)){
                            priceChanges.add(lineItem.Id);
                        }
                        if(awardedQty != previousQty && !priceAndVolumeChanges.contains(lineItem.Id)){
                            volumeChanges.add(lineItem.Id);
                        }
                    }
                    Date d;
                    if(lineItem.Customer_Response_Lines__r != null && lineItem.Customer_Response_Lines__r.size()>0 && lineItem.Customer_Response_Lines__r[0].Phoenix_Supply_Effective_Date__c !=null){
                        d = lineItem.Customer_Response_Lines__r[0].Phoenix_Supply_Effective_Date__c;
                    } else if(lineItem.Customer_Response_Lines__r != null && lineItem.Customer_Response_Lines__r.size()>0 && lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c !=null){
                        d = lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c;
                    } else if(lineItem.BidLineItemsExtn__r != null && lineItem.BidLineItemsExtn__r[0] != null && lineItem.BidLineItemsExtn__r[0].Vision_Effective_Date_of_Removal__c != null){
                        List<String> dateSplit = lineItem.BidLineItemsExtn__r[0].Vision_Effective_Date_of_Removal__c.split('/');
                        d = date.newinstance(Integer.valueOf(dateSplit[2]), Integer.valueOf(dateSplit[1]), Integer.valueOf(dateSplit[0]));   
                    }
                    Double monthsRemaining = 0;
                    if(d != null){
                        Integer fiscalyear = 0;
                        if ((d.month() + 1) <= 3){
                            fiscalyear = d.year();
                        }
                        else{
                            fiscalyear = d.year() + 1;
                        }
                        Integer numberOfDays = Date.daysInMonth(fiscalyear, 3);
                        Date lastDayOfMonth = Date.newInstance(fiscalyear, 3, numberOfDays);
                        Date endDateOfFiscalYear = date.newinstance(fiscalyear, 3, numberOfDays);
                        Integer days_difference = d.daysBetween(endDateOfFiscalYear);
                        monthsRemaining = (((Double) days_difference)/365)*12;
                    }
                    Decimal AnnualImpact = 0;
                    Decimal FYBusinessImpact = 0;
                    if(bid.Phoenix_Bid_Type__c == 'Product Discontinuation Process' || bid.Phoenix_Bid_Type__c == 'Mass Product Removals'){
                        String prodId = lineItem.Phoenix_Product__r.ProductCode;
                        String contNo = lineItem.Phoenix_Contract__r.Phoenix_Contract_Number__c;
                        Phoenix_NPR_Data__c nprData = [SELECT Id, Phoenix_Contract_Price__c, Phoenix_Dead_Net_Tracking_GR__c, Phoenix_12Months_Sales_Unit__c, Phoenix_Product__r.ProductCode, Phoenix_Contract__r.Phoenix_Contract_Number__c FROM Phoenix_NPR_Data__c WHERE Phoenix_Product__r.ProductCode =: prodId AND Phoenix_Contract__r.Phoenix_Contract_Number__c =: contNo LIMIT 1];
                        if(nprData != null){
                            previousQty = (nprData.Phoenix_12Months_Sales_Unit__c != null) ? nprData.Phoenix_12Months_Sales_Unit__c: 0;
                            previousIndirectPrice = (nprData.Phoenix_Dead_Net_Tracking_GR__c != null) ? nprData.Phoenix_Dead_Net_Tracking_GR__c: 0;
                        } else{
                            previousQty = 0;
                            previousIndirectPrice = 0;                
                        }
                        Decimal prevTotal = previousQty * previousIndirectPrice;
                        currentTotal += 0;
                        previousTotal += prevTotal;
                        if(previousTotal != null && previousTotal > 0)
                            AnnualImpact = previousTotal * -1;
                        else
                            AnnualImpact = previousTotal;
                        FYBusinessImpact = (AnnualImpact * monthsRemaining)/12;
                    } else{
                        Decimal curTotal = ((lineItem.Customer_Response_Lines__r != null && lineItem.Customer_Response_Lines__r.size()>0 && lineItem.Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? lineItem.Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0) * ((lineItem.Phoenix_Proposed_ASP_Dose__c != null)?lineItem.Phoenix_Proposed_ASP_Dose__c : 0);
                        currentTotal += curTotal;
                        previousTotal += (((lineItem.Phoenix_Total_Selling_Unit__c != null)?lineItem.Phoenix_Total_Selling_Unit__c: 0) * ((lineItem.Phoenix_Current_ASP_Dose__c != null)?lineItem.Phoenix_Current_ASP_Dose__c: 0));
                        AnnualImpact = (((lineItem.Customer_Response_Lines__r != null && lineItem.Customer_Response_Lines__r.size()>0 && lineItem.Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null)? lineItem.Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0) * ((lineItem.Phoenix_Proposed_ASP_Dose__c != null)?lineItem.Phoenix_Proposed_ASP_Dose__c:0)) - (((lineItem.Phoenix_Total_Selling_Unit__c != null)?lineItem.Phoenix_Total_Selling_Unit__c:0) * ((lineItem.Phoenix_Current_ASP_Dose__c != null)?lineItem.Phoenix_Current_ASP_Dose__c:0));
                        FYBusinessImpact = (AnnualImpact * monthsRemaining)/12;   
                    }
                    if(category == 'Product Lost'){
                        productsLost.add(lineItem.Id);
                    } else if(category == 'No Effect'){
                        noEffects.add(lineItem.Id);
                    }
                    if(category == 'Business Retained' && FYBusinessImpact >= 0){
                        category = 'Business Retained with Gains';
                    } else if(category == 'Business Retained' && FYBusinessImpact < 0){
                        category = 'Business Retained with Loss';
                    }
                    totalFYBusinessImpact += FYBusinessImpact;
                    if(lineItem.BidLineItemsExtn__r.size() != 0){
                        Phoenix_BidLineItemExtn__c extnObj = lineItem.BidLineItemsExtn__r[0];
                        extnObj.Vision_Category__c = category;
                        updateExtnList.add(extnObj);
                    } else{
                        Phoenix_BidLineItemExtn__c bidExtnObj = new Phoenix_BidLineItemExtn__c();
                        bidExtnObj.Phoenix_Bid_Line_Item__c = lineItem.Id;
                        bidExtnObj.Vision_Category__c = category;
                        updateExtnList.add(bidExtnObj);
                    }
                }
                if(isOTCType){
                    if(OTCNoEffectList.size() > 0){
                        for(Phoenix_Bid_Line_Item__c bidLineItem: OTCNoEffectList){
                            if(bidLineItem.BidLineItemsExtn__r.size() != 0){
                                Phoenix_BidLineItemExtn__c extnObj = bidLineItem.BidLineItemsExtn__r[0];
                                extnObj.Vision_Category__c = 'No Effect';
                                updateExtnList.add(extnObj);
                            } else{
                                Phoenix_BidLineItemExtn__c bidExtnObj = new Phoenix_BidLineItemExtn__c();
                                bidExtnObj.Phoenix_Bid_Line_Item__c = bidLineItem.Id;
                                bidExtnObj.Vision_Category__c = 'No Effect';
                                updateExtnList.add(bidExtnObj);
                            }
                        }
                    }
                }
                totalAnnualImpact = currentTotal - previousTotal;
                bid.Vision_Previous_Total__c = previousTotal;
                bid.Vision_Current_Total__c = currentTotal;
                bid.Vision_Total_Annual_Impact__c = totalAnnualImpact;
                bid.Vision_Total_FY_Business_Impact__c = totalFYBusinessImpact;
                bid.Vision_Total_Bid_Line_Items__c = lineItems.size();
                bid.Vision_Total_New_Award_s__c = newAwards.size();
                bid.Vision_Total_Price_Change_s__c = priceChanges.size();
                bid.Vision_Total_Volume_Change_s__c = volumeChanges.size();
                bid.Vision_Total_Price_Volume_Change_s__c = priceAndVolumeChanges.size();
                bid.Vision_Total_No_Effect_s__c = noEffects.size();
                bid.Vision_Total_Product_Lost_s__c = productsLost.size();
                //bidsListToUpdate.add(bid);
            }
            if(updateExtnList.size() > 0){
                Phoenix_Util.blnAlreadyDone = true;
                upsert updateExtnList;
            }
            if(bidsListToUpdate.size() > 0)
                update bidsListToUpdate;
        }
        catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'BatchToUpdateBidAnalysisSummary', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }*/
        
    }
    
    public void finish(Database.BatchableContext BC) {
        //Database.executeBatch(new BatchToUpdateBidAnalysisSummary());
    }
    
}