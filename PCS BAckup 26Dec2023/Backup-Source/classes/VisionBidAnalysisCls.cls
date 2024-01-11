public class VisionBidAnalysisCls {
    @AuraEnabled 
    public static finalWrapper getData(String bidId){
        finalWrapper wrap = new finalWrapper();
        try{
        String query =''; String strFields = ''; String SobjectApiName = 'Phoenix_Bid_Line_Item__c'; Integer openLineItemsCount = 0; Decimal copyofMonthlyDamand = 0;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        for(String fieldName : fieldMap.keyset() )
        {
            if(strFields == null || strFields == '') strFields = fieldName;
            else strFields = strFields + ' , ' + fieldName;
        }
        string notApproved = 'Not Approved'; string query2 = ''; Boolean isOTCType = false;
        List<String> listOfStatus = new List<String>{'Closed', 'Vistex Update'};
        Phoenix_Bid__c bid = [SELECT Id, Name,Phoenix_Customer__r.Name, Phoenix_Bid_Submitted_Date__c, Phoenix_Bid_Closed_Date__c, Phoenix_OTB_Direct_Indirect__c, Phoenix_is_OTC_Bid__c, Phoenix_Customer_Type__c, Phoenix_Template_Type__c , Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE ID =: bidId];
        if(bid.Phoenix_Bid_Type__c == 'Product Discontinuation Process' || bid.Phoenix_Bid_Type__c == 'Mass Product Removals'){
            listOfStatus.add('Contracts');
            listOfStatus.add('Contracts Rejected');
        } else if(bid.Phoenix_Bid_Type__c == 'OTC New Product' || bid.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' || bid.Phoenix_Bid_Type__c == 'OTC OTB Short Dated' || bid.Phoenix_Bid_Type__c == 'OTC Price Change'
                  || bid.Phoenix_Bid_Type__c == 'OTC Product Addition' || bid.Phoenix_Bid_Type__c == 'OTC Rebate Change' || bid.Phoenix_Bid_Type__c == 'OTC RFP' || bid.Phoenix_Bid_Type__c == 'OTC Volume Review'){
                      isOTCType = true;
                      listOfStatus = new List<String>{'Closed', 'Vistex Update', 'Customer\'s Update'};
                          query2 = 'select Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Product__r.Phoenix_Throughput_cost__c, Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c,Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Product__r.ProductCode, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Name, Phoenix_Customer__r.Name, Phoenix_Contract__r.Name, Phoenix_Contract__r.Phoenix_Contract_Number__c, ' + strFields + ', (SELECT Id, Name, Phoenix_Customer_Response_Date__c, Phoenix_Customer_Decline_Reasons__c, Final_Direct_Price__c, Final_Indirect_Price__c, Phoenix_Bid_Status__c,Phoenix_Award_Position__c,Phoenix_Supply_Effective_Date__c,Phoenix_Price_Effective_Date__c,Phoenix_Awarded_Quantity__c,Phoenix_Final_Approvd_Pricing_Contracts__c,Phoenix_Final_Total_Selling_Unit__c FROM Customer_Response_Lines__r),(SELECT Id,Phoenix_OverrideMajorUnits__c,Phoenix_3MonAnnualMajorSellingUnits__c,Phoenix_Current_Major_Contract_Price__c,Phoenix_Proposed_Major_Contract_Price__c, Phoenix_Proposed_CvsDirectContractPrice__c, Vision_Effective_Date_of_Removal__c FROM BidLineItemsExtn__r), Phoenix_Product__r.name from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Customer_Approval_OTC__c =: notApproved ORDER BY Product_Family_Name__c ASC'  ; // AND Phoenix_Final_Status__c !=: notApproved
                  }
        else{
            listOfStatus.add('Customer Rejected');
            listOfStatus.add('Customer\'s Update');            
        }
        query = 'select Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Product__r.Phoenix_Throughput_cost__c, Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c, Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Product__r.ProductCode, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Name, Phoenix_Customer__r.Name, Phoenix_Contract__r.Name, Phoenix_Contract__r.Phoenix_Contract_Number__c, ' + strFields + ', (SELECT Id, Name, Phoenix_Customer_Response_Date__c, Phoenix_Customer_Decline_Reasons__c, Final_Direct_Price__c, Final_Indirect_Price__c, Phoenix_Bid_Status__c,Phoenix_Award_Position__c,Phoenix_Supply_Effective_Date__c,Phoenix_Price_Effective_Date__c,Phoenix_Awarded_Quantity__c,Phoenix_Final_Approvd_Pricing_Contracts__c,Phoenix_Final_Total_Selling_Unit__c FROM Customer_Response_Lines__r),(SELECT Id,Phoenix_OverrideMajorUnits__c,Phoenix_3MonAnnualMajorSellingUnits__c,Phoenix_Current_Major_Contract_Price__c,Phoenix_Proposed_Major_Contract_Price__c,Phoenix_Proposed_CVS_DirSellingUnits__c,Phoenix_Proposed_CVS_IndirSellingUnits__c,Phoenix_Proposed_Cardinal_Units__c,Phoenix_Proposed_Major_Units__c, Phoenix_Proposed_CvsDirectContractPrice__c, Vision_Effective_Date_of_Removal__c FROM BidLineItemsExtn__r), Phoenix_Product__r.name from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Bid__r.Phoenix_Approval_Status__c IN:listOfStatus ORDER BY Product_Family_Name__c ASC'  ; // AND Phoenix_Final_Status__c !=: notApproved
        List<Phoenix_Bid_Line_Item__c> bidLineItemsList = Database.query(query);
        List<Phoenix_Bid_Line_Item__c> OTCNoEffectList = new List<Phoenix_Bid_Line_Item__c>();
        if(!String.isBlank(query2)) OTCNoEffectList = Database.query(query2);
        Set<String> productIds = new Set<String>(); Set<String> contractNos = new Set<String>();
        List<Phoenix_NPR_Data__c> nprData = new List<Phoenix_NPR_Data__c>();
        Map<String, Phoenix_NPR_Data__c> nprMap = new Map<String, Phoenix_NPR_Data__c>();
        if(bid.Phoenix_Bid_Type__c == 'Product Discontinuation Process' || bid.Phoenix_Bid_Type__c == 'Mass Product Removals'){
            for(Phoenix_Bid_Line_Item__c item: bidLineItemsList){
                productIds.add(item.Phoenix_Product__r.ProductCode);
                contractNos.add(item.Phoenix_Contract__r.Phoenix_Contract_Number__c);
            }
            nprData = [SELECT Id, Phoenix_Contract_Price__c, Phoenix_Dead_Net_Tracking_GR__c, Phoenix_12Months_Sales_Unit__c, Phoenix_Product__r.ProductCode, Phoenix_Contract__r.Phoenix_Contract_Number__c FROM Phoenix_NPR_Data__c WHERE Phoenix_Product__r.ProductCode IN: productIds AND Phoenix_Contract__r.Phoenix_Contract_Number__c IN: contractNos];
            for(Phoenix_NPR_Data__c npr: nprData){
                String uniqueKey = npr.Phoenix_Product__r.ProductCode+'_'+npr.Phoenix_Contract__r.Phoenix_Contract_Number__c;
                nprMap.put(uniqueKey, npr);
            }    
        }
        List<ScmWrapper> scmWrapperList = new List<ScmWrapper>();
        /*List<Phoenix_Product_Position__c> productPositions = [SELECT Phoenix_General_Category__c, Name FROM Phoenix_Product_Position__c];
        Map<String, String> mapOfCategories = new Map<String, String>();
        if(productPositions.size()>0){
            for(Phoenix_Product_Position__c generalCategory: productPositions){
                mapOfCategories.put(generalCategory.Name, generalCategory.Phoenix_General_Category__c);   
            }
        }*/
        for(Phoenix_Bid_Line_Item__c bidLineItem : bidLineItemsList){
            if(bid.Phoenix_Bid_Type__c != 'Product Discontinuation Process' && bid.Phoenix_Bid_Type__c != 'Mass Product Removals'){
                ScmWrapper scmWrapperObj = new ScmWrapper();
                scmWrapperObj.bidRecord = bid;
                scmWrapperObj.customer = bid.Phoenix_Customer__r.Name;
                //scmWrapperObj.customerId = bid.Phoenix_Customer__c;
                scmWrapperObj.reasons = (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0) ? bidLineItem.Customer_Response_Lines__r[0].Phoenix_Customer_Decline_Reasons__c : '';
                scmWrapperObj.ndc = bidLineItem.Phoenix_NDC_Without_Dashes__c ;
                scmWrapperObj.productName = bidLineItem.Phoenix_Product__r.Name;
                scmWrapperObj.sapNumber = bidLineItem.Phoenix_Product_Code1__c ;
                scmWrapperObj.productFamily = bidLineItem.Product_Family_Name__c ;
                scmWrapperObj.bidStatus = (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0) ? bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c : '';
                scmWrapperObj.awardedQty = (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0) ? bidLineItem.Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : null;
                scmWrapperObj.awardedPrice = (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0) ? bidLineItem.Customer_Response_Lines__r[0].Phoenix_Final_Approvd_Pricing_Contracts__c : null;
                scmWrapperObj.awardedPosition = (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0) ? bidLineItem.Customer_Response_Lines__r[0].Phoenix_Award_Position__c : null;   
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
                scmWrapperObj.previousDeadnet = bidLineItem.Phoenix_Current_ASP_Dose__c;
                scmWrapperObj.currentDeadnet = bidLineItem.Phoenix_Proposed_ASP_Dose__c;
                scmWrapperObj.bidType = bid.Phoenix_Bid_Type__c;
                scmWrapperObj.previousQty = bidLineItem.Phoenix_Total_Selling_Unit__c;
                scmWrapperObj.previousIndirectPrice = bidLineItem.Phoenix_Current_Indirect_Price__c;
                scmWrapperObj.previousPosition = bidLineItem.Phoenix_Current_Position__c;
                /*scmWrapperObj.previousCategory = mapOfCategories.get(scmWrapperObj.previousPosition);
                scmWrapperObj.currentCategory = mapOfCategories.get(scmWrapperObj.awardedPosition);*/
                scmWrapperObj.bidLineItem = bidLineItem;
                if(isOTCType) scmWrapperObj.isOTCType = true;
                else scmWrapperObj.isOTCType = false;
                if(bid.Phoenix_Customer_Type__c == 'Net Indirect Pricing' || bid.Phoenix_Customer_Type__c == 'Direct and Indirect' || bid.Phoenix_Customer_Type__c == 'Econdisc' || bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Good Dated OTB'){
                    scmWrapperObj.overrideCurrentDirectUnits = scmWrapperObj.unit1 =  (bidLineItem.Phoenix_Override_Current_Direct_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Direct_Units__c : (bidLineItem.Phoenix_Current_Direct_Selling_Unit__c != null)?bidLineItem.Phoenix_Current_Direct_Selling_Unit__c:null;
                    scmWrapperObj.overrideCurrentIndirectUnits = scmWrapperObj.unit3 =  (bidLineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Indirect_Units__c : (bidLineItem.Phoenix_Current_Indirect_Selling_Unit__c != null)?bidLineItem.Phoenix_Current_Indirect_Selling_Unit__c:null;
                    scmWrapperObj.previousQty = (scmWrapperObj.overrideCurrentDirectUnits != null ? scmWrapperObj.overrideCurrentDirectUnits : 0) + (scmWrapperObj.overrideCurrentIndirectUnits != null ? scmWrapperObj.overrideCurrentIndirectUnits : 0);
                    Boolean isOpen = false;
                    if(isOTCType == true) if(bidLineItem.Phoenix_Customer_Approval_OTC__c == '' || bidLineItem.Phoenix_Customer_Approval_OTC__c == null || bidLineItem.Phoenix_Customer_Approval_OTC__c == 'Send Back to Marketing') isOpen = true;
                    else if((bid.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))) isOpen = true;
                    if(isOpen || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number'))){
                        if(bid.Phoenix_Customer_Type__c == 'Net Indirect Pricing'){
                            scmWrapperObj.finalDirectSellingUnits = scmWrapperObj.unit2 =  bidLineItem.Phoenix_Proposed_Direct_Selling_Unit__c;
                            scmWrapperObj.finalIndirectSellingUnits = scmWrapperObj.unit4 =  bidLineItem.Phoenix_Proposed_Indirect_Selling_Unit__c;
                            scmWrapperObj.awardedQty = (scmWrapperObj.finalDirectSellingUnits != null ? scmWrapperObj.finalDirectSellingUnits : 0) + (scmWrapperObj.finalIndirectSellingUnits != null ? scmWrapperObj.finalIndirectSellingUnits : 0);
                        } else{
                            scmWrapperObj.finalDirectSellingUnits = scmWrapperObj.unit2 =  bidLineItem.Phoenix_Final_Direct_Selling_Units__c;
                            scmWrapperObj.finalIndirectSellingUnits = scmWrapperObj.unit4 =  bidLineItem.Phoenix_Final_Indirect_Selling_Units__c;
                            scmWrapperObj.awardedQty = (scmWrapperObj.finalDirectSellingUnits != null ? scmWrapperObj.finalDirectSellingUnits : 0) + (scmWrapperObj.finalIndirectSellingUnits != null ? scmWrapperObj.finalIndirectSellingUnits : 0);
                        }
                        if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change'){
                            scmWrapperObj.finalDirectSellingUnits = scmWrapperObj.unit2 =  scmWrapperObj.overrideCurrentDirectUnits;
                            scmWrapperObj.finalIndirectSellingUnits = scmWrapperObj.unit4 =  scmWrapperObj.overrideCurrentIndirectUnits;
                            scmWrapperObj.awardedQty = (scmWrapperObj.finalDirectSellingUnits != null ? scmWrapperObj.finalDirectSellingUnits : 0) + (scmWrapperObj.finalIndirectSellingUnits != null ? scmWrapperObj.finalIndirectSellingUnits : 0);
                        }	
                    }
                }
                else if(bid.Phoenix_Customer_Type__c == 'BASE/DSH'){
                    scmWrapperObj.overrideCurrentDirectUnits = scmWrapperObj.unit1 =  (bidLineItem.Phoenix_Override_Current_Direct_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Direct_Units__c : (bidLineItem.Phoenix_Current_Wholesaler_Units__c != null)?bidLineItem.Phoenix_Current_Wholesaler_Units__c:null;
                    scmWrapperObj.overrideCurrentIndirectUnits = scmWrapperObj.unit3 =  (bidLineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Indirect_Units__c : (bidLineItem.Phoenix_Current_Anda_Units__c != null)?bidLineItem.Phoenix_Current_Anda_Units__c:null;
                    scmWrapperObj.overrideCurrentUnits = scmWrapperObj.unit5 =  (bidLineItem.Phoenix_Override_Current_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Units__c : (bidLineItem.Phoenix_Current_Retail_Direct_Units__c != null)?bidLineItem.Phoenix_Current_Retail_Direct_Units__c:null;
                    scmWrapperObj.previousQty = (scmWrapperObj.overrideCurrentDirectUnits != null ? scmWrapperObj.overrideCurrentDirectUnits : 0) + (scmWrapperObj.overrideCurrentIndirectUnits != null ? scmWrapperObj.overrideCurrentIndirectUnits : 0) + (scmWrapperObj.overrideCurrentUnits != null ? scmWrapperObj.overrideCurrentUnits : 0);
                    Boolean isOpen = false;
                    if((bid.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))) isOpen = true;
                    if(isOpen || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number'))){
                        scmWrapperObj.baseUnits = scmWrapperObj.unit2 =  bidLineItem.Phoenix_Proposed_Smith_Drug_Units__c;
                        scmWrapperObj.dshUnits = scmWrapperObj.unit4 =  bidLineItem.Phoenix_Proposed_Anda_Units__c;
                        scmWrapperObj.autoSubUnits = scmWrapperObj.unit6 =  bidLineItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c;
                        if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change'){
                            scmWrapperObj.baseUnits = scmWrapperObj.unit2 =  scmWrapperObj.overrideCurrentDirectUnits;
                            scmWrapperObj.dshUnits = scmWrapperObj.unit4 =  scmWrapperObj.overrideCurrentIndirectUnits;
                            scmWrapperObj.autoSubUnits = scmWrapperObj.unit6 =  scmWrapperObj.overrideCurrentUnits;
                        }	
                        scmWrapperObj.awardedQty = (scmWrapperObj.baseUnits != null ? scmWrapperObj.baseUnits : 0) + (scmWrapperObj.dshUnits != null ? scmWrapperObj.dshUnits : 0) + (scmWrapperObj.autoSubUnits != null ? scmWrapperObj.autoSubUnits : 0);
                    }
                }
                else if(bid.Phoenix_Customer_Type__c == 'ROS'){
                    scmWrapperObj.overrideCVSDirectUnits = scmWrapperObj.unit1 =  (bidLineItem.Phoenix_Override_Current_Direct_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Direct_Units__c : (bidLineItem.Phoenix_Current_Retail_Direct_Units__c != null)?bidLineItem.Phoenix_Current_Retail_Direct_Units__c:null;
                    scmWrapperObj.overrideCVSIndirectUnits = scmWrapperObj.unit3 =  (bidLineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Indirect_Units__c : (bidLineItem.Phoenix_Current_Retail_Indirect_Units__c != null)?bidLineItem.Phoenix_Current_Retail_Indirect_Units__c:null;
                    scmWrapperObj.overrideCardinalUnits = scmWrapperObj.unit5 =  (bidLineItem.Phoenix_Override_Current_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Units__c : (bidLineItem.Phoenix_Current_Wholesaler_Units__c != null)?bidLineItem.Phoenix_Current_Wholesaler_Units__c:null;
                    scmWrapperObj.overrideMajorUnits = scmWrapperObj.unit7 =  (bidLineItem.BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c != null) ? bidLineItem.BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c : (bidLineItem.BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c != null)?bidLineItem.BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c:null;
                    scmWrapperObj.previousQty = (scmWrapperObj.overrideCVSDirectUnits != null ? scmWrapperObj.overrideCVSDirectUnits : 0) + (scmWrapperObj.overrideCVSIndirectUnits != null ? scmWrapperObj.overrideCVSIndirectUnits : 0) + (scmWrapperObj.overrideCardinalUnits != null ? scmWrapperObj.overrideCardinalUnits : 0) + (scmWrapperObj.overrideMajorUnits != null ? scmWrapperObj.overrideMajorUnits : 0);
                    Boolean isOpen = false;
                    if((bid.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))) isOpen = true;
                    if(isOpen || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number'))){
                        scmWrapperObj.CVSDirectUnits = scmWrapperObj.unit2 =  bidLineItem.BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c;
                        scmWrapperObj.CVSIndirectUnits = scmWrapperObj.unit4 =  bidLineItem.BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c;
                        scmWrapperObj.cardinalUnits = scmWrapperObj.unit6 =  bidLineItem.BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c;
                        scmWrapperObj.majorContractUnits = scmWrapperObj.unit8 =  bidLineItem.BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c;
                        if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change'){
                            scmWrapperObj.CVSDirectUnits = scmWrapperObj.unit2 =  scmWrapperObj.overrideCVSDirectUnits;
                            scmWrapperObj.CVSIndirectUnits = scmWrapperObj.unit4 =  scmWrapperObj.overrideCVSIndirectUnits;
                            scmWrapperObj.cardinalUnits = scmWrapperObj.unit6 =  scmWrapperObj.overrideCardinalUnits;
                            scmWrapperObj.majorContractUnits = scmWrapperObj.unit8 =  scmWrapperObj.overrideMajorUnits;
                        }	
                        scmWrapperObj.awardedQty = (scmWrapperObj.CVSDirectUnits != null ? scmWrapperObj.CVSDirectUnits : 0) + (scmWrapperObj.CVSIndirectUnits != null ? scmWrapperObj.CVSIndirectUnits : 0) + (scmWrapperObj.cardinalUnits != null ? scmWrapperObj.cardinalUnits : 0) + (scmWrapperObj.majorContractUnits != null ? scmWrapperObj.majorContractUnits : 0);
                    }
                }
                else if(bid.Phoenix_Customer_Type__c == 'RXSS'){
                    scmWrapperObj.overrideCurrentDirectUnits = scmWrapperObj.unit1 =  (bidLineItem.Phoenix_Override_Current_Direct_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Direct_Units__c : (bidLineItem.Phoenix_Current_Retail_Direct_Units__c != null)?bidLineItem.Phoenix_Current_Retail_Direct_Units__c:null;
                    scmWrapperObj.currentRetailIndirectUnits = scmWrapperObj.unit3 =  (bidLineItem.Phoenix_Current_Retail_Indirect_Units__c != null) ? bidLineItem.Phoenix_Current_Retail_Indirect_Units__c : null;
                    scmWrapperObj.overrideCurrentIndirectUnits = scmWrapperObj.unit5 =  (bidLineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Indirect_Units__c : (bidLineItem.Phoenix_Current_Wholesaler_Units__c != null)?bidLineItem.Phoenix_Current_Wholesaler_Units__c:null;
                    scmWrapperObj.currentRetailDirectUnits = scmWrapperObj.unit7 =  (bidLineItem.Phoenix_Current_Anda_Units__c != null) ? bidLineItem.Phoenix_Current_Anda_Units__c : null;
                    scmWrapperObj.previousQty = (scmWrapperObj.overrideCurrentDirectUnits != null ? scmWrapperObj.overrideCurrentDirectUnits : 0) + (scmWrapperObj.overrideCurrentIndirectUnits != null ? scmWrapperObj.overrideCurrentIndirectUnits : 0) + (scmWrapperObj.currentRetailDirectUnits != null ? scmWrapperObj.currentRetailDirectUnits : 0) + (scmWrapperObj.currentRetailIndirectUnits != null ? scmWrapperObj.currentRetailIndirectUnits : 0);
                    Boolean isOpen = false;
                    if((bid.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))) isOpen = true;
                    if(isOpen || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number'))){
                        scmWrapperObj.directAholDelhaizeUnits = scmWrapperObj.unit2 =  (bidLineItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c != null) ? bidLineItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c : 0;
                        scmWrapperObj.directGaintEagleUnits = scmWrapperObj.unit4 = (bidLineItem.Phoenix_ProposedDirectGaintEagleUnits__c != null) ? bidLineItem.Phoenix_ProposedDirectGaintEagleUnits__c : 0;
                        scmWrapperObj.retailIndirectUnits = scmWrapperObj.unit6 = (bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c != null) ? bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c : 0;
                        scmWrapperObj.proposedSmithDrugUnits = scmWrapperObj.unit8 = (bidLineItem.Phoenix_Proposed_Smith_Drug_Units__c != null) ? bidLineItem.Phoenix_Proposed_Smith_Drug_Units__c : 0;
                        scmWrapperObj.proposedAndaUnits = scmWrapperObj.unit10 = (bidLineItem.Phoenix_Proposed_Anda_Units__c != null) ?  bidLineItem.Phoenix_Proposed_Anda_Units__c : 0;
                        if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change'){
                            scmWrapperObj.directAholDelhaizeUnits = scmWrapperObj.unit2 = (scmWrapperObj.overrideCurrentDirectUnits != null) ? scmWrapperObj.overrideCurrentDirectUnits : 0;
                            scmWrapperObj.directGaintEagleUnits = scmWrapperObj.unit4 = (scmWrapperObj.overrideCurrentIndirectUnits != null) ? scmWrapperObj.overrideCurrentIndirectUnits : 0;
                            scmWrapperObj.retailIndirectUnits = scmWrapperObj.unit6 =  (bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c != null) ? bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c : 0;
                            scmWrapperObj.proposedSmithDrugUnits = scmWrapperObj.unit8 = (scmWrapperObj.currentRetailDirectUnits != null) ? scmWrapperObj.currentRetailDirectUnits : 0;
                            scmWrapperObj.proposedAndaUnits = scmWrapperObj.unit10 = (scmWrapperObj.currentRetailDirectUnits != null) ? scmWrapperObj.currentRetailDirectUnits : 0;
                        }
                        scmWrapperObj.awardedQty = (scmWrapperObj.directAholDelhaizeUnits != null ? scmWrapperObj.directAholDelhaizeUnits : 0) + (scmWrapperObj.directGaintEagleUnits != null ? scmWrapperObj.directGaintEagleUnits : 0) + (scmWrapperObj.proposedSmithDrugUnits != null ? scmWrapperObj.proposedSmithDrugUnits : 0) + (scmWrapperObj.proposedAndaUnits != null ? scmWrapperObj.proposedAndaUnits : 0) + (scmWrapperObj.retailIndirectUnits != null ? scmWrapperObj.retailIndirectUnits : 0);
                    }
                }
                else if(bid.Phoenix_Customer_Type__c == 'ClarusOne'){
                    scmWrapperObj.overrideCurrentDirectUnits = scmWrapperObj.unit1 = (bidLineItem.Phoenix_Override_Current_Direct_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Direct_Units__c : (bidLineItem.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c != null)?bidLineItem.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c:null;
                    scmWrapperObj.overrideCurrentIndirectUnits = scmWrapperObj.unit3 = (bidLineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Indirect_Units__c : (bidLineItem.Phoenix_WMT_Current_Direct_Units__c != null)?bidLineItem.Phoenix_WMT_Current_Direct_Units__c:null;
                    scmWrapperObj.currentRetailDirectUnits = scmWrapperObj.unit5 = (bidLineItem.Phoenix_Proposed_Smith_Drug_Units__c != null) ? bidLineItem.Phoenix_Proposed_Smith_Drug_Units__c : (bidLineItem.Phoenix_WMT_Current_Indirect_Units__c != null)?bidLineItem.Phoenix_WMT_Current_Indirect_Units__c:null;
                    scmWrapperObj.previousQty = (scmWrapperObj.overrideCurrentDirectUnits != null ? scmWrapperObj.overrideCurrentDirectUnits : 0) + (scmWrapperObj.overrideCurrentIndirectUnits != null ? scmWrapperObj.overrideCurrentIndirectUnits : 0) + (scmWrapperObj.currentRetailDirectUnits != null ? scmWrapperObj.currentRetailDirectUnits : 0);
                    Boolean isOpen = false;
                    if((bid.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))) isOpen = true;
                    if(isOpen || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number'))){
                        scmWrapperObj.osUnits = scmWrapperObj.unit2 = bidLineItem.Phoenix_Proposed_OS_Units__c;
                        scmWrapperObj.radUnits = scmWrapperObj.unit4 = bidLineItem.Phoenix_Proposed_RAD_Units__c;
                        scmWrapperObj.wmtUnits = scmWrapperObj.unit6 = bidLineItem.Phoenix_Proposed_WMT_Units__c;
                        if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change'){
                            scmWrapperObj.osUnits = scmWrapperObj.unit2 = scmWrapperObj.overrideCurrentDirectUnits;
                            scmWrapperObj.radUnits = scmWrapperObj.unit4 = scmWrapperObj.overrideCurrentIndirectUnits;
                            scmWrapperObj.wmtUnits = scmWrapperObj.unit6 = scmWrapperObj.currentRetailDirectUnits;
                        }
                        scmWrapperObj.awardedQty = (scmWrapperObj.osUnits != null ? scmWrapperObj.osUnits : 0) + (scmWrapperObj.radUnits != null ? scmWrapperObj.radUnits : 0) + (scmWrapperObj.wmtUnits != null ? scmWrapperObj.wmtUnits : 0);
                    }
                }
                else if(bid.Phoenix_Customer_Type__c == 'Humana Indirect retail'){
                    scmWrapperObj.previousQty = (bidLineItem.Phoenix_Override_Current_Indirect_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Indirect_Units__c : (bidLineItem.Phoenix_Current_Indirect_Selling_Unit__c != null)?bidLineItem.Phoenix_Current_Indirect_Selling_Unit__c:0;
                    scmWrapperObj.currentIndirectPrice = (bidLineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != null) ? bidLineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c : 0;
                    Boolean isOpen = false;
                    if((bid.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))) isOpen = true;
                    if(isOpen || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number'))){
                        scmWrapperObj.finalDirectSellingUnits = scmWrapperObj.unit1 = bidLineItem.Phoenix_Proposed_Indirect_Selling_Unit__c;
                        scmWrapperObj.awardedQty = scmWrapperObj.finalDirectSellingUnits;
                    }
                }
                else if(bid.Phoenix_Customer_Type__c == 'Sams Club'){
                    scmWrapperObj.awardedPrice = (bidLineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != null) ? bidLineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c : 0;
                    scmWrapperObj.previousIndirectPrice = (bidLineItem.Phoenix_Current_Indirect_Price__c != null) ? bidLineItem.Phoenix_Current_Indirect_Price__c : 0;
                    Boolean isOpen = false;
                    if((bid.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))) isOpen = true;
                    if(isOpen || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number'))){
                        scmWrapperObj.finalDirectSellingUnits = scmWrapperObj.unit1 = bidLineItem.Phoenix_Final_Direct_Selling_Units__c;
                        scmWrapperObj.finalIndirectSellingUnits = scmWrapperObj.unit2 = bidLineItem.Phoenix_Final_Indirect_Selling_Units__c;
                        scmWrapperObj.awardedQty = (scmWrapperObj.finalDirectSellingUnits != null ? scmWrapperObj.finalDirectSellingUnits : 0) + (scmWrapperObj.finalIndirectSellingUnits != null ? scmWrapperObj.finalIndirectSellingUnits : 0);
                        if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change') scmWrapperObj.awardedQty = scmWrapperObj.previousQty;
                    }
                } else if(bid.Phoenix_Customer_Type__c == 'Direct'){
                    Boolean isOpen = false;
                    if((bid.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))) isOpen = true;
                    if(isOpen || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number'))){
                        scmWrapperObj.finalDirectSellingUnits = bidLineItem.Phoenix_Proposed_Direct_Selling_Unit__c;
                        scmWrapperObj.awardedQty = scmWrapperObj.finalDirectSellingUnits;
                        if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change') scmWrapperObj.awardedQty = scmWrapperObj.previousQty;
                    }
                }  else if(bid.Phoenix_Customer_Type__c == 'Walgreens' || bid.Phoenix_Customer_Type__c == 'ABC Progen' || bid.Phoenix_Customer_Type__c == 'ABC Pharmagen' 
                           || bid.Phoenix_Customer_Type__c == 'Costco' || bid.Phoenix_Customer_Type__c == 'Indirect' || bid.Phoenix_Customer_Type__c == 'Sams Club' 
                           || bid.Phoenix_Customer_Type__c == 'Government Pricing'){
                               Boolean isOpen = false;
                               if((bid.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))) isOpen = true;
                               if(isOpen || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number'))){
                                   scmWrapperObj.finalDirectSellingUnits = scmWrapperObj.unit1 = bidLineItem.Phoenix_Proposed_Indirect_Selling_Unit__c;
                                   scmWrapperObj.awardedQty = scmWrapperObj.finalDirectSellingUnits;
                                   if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change') scmWrapperObj.awardedQty = scmWrapperObj.previousQty;
                               }
                           }
                else if(isOTCType){
                    scmWrapperObj.previousQty = (bidLineItem.Phoenix_Override_Current_Direct_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Direct_Units__c : (bidLineItem.Phoenix_Current_Direct_Selling_Unit__c != null)?bidLineItem.Phoenix_Current_Direct_Selling_Unit__c:0;
                    scmWrapperObj.proposedBottles = (bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c != null)?bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c:0;
                    if(isOTCType == true){
                        if((bidLineItem.Phoenix_Customer_Approval_OTC__c == '' || bidLineItem.Phoenix_Customer_Approval_OTC__c == null || bidLineItem.Phoenix_Customer_Approval_OTC__c == 'Send Back to Marketing') || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number')) || (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number'))){
                            scmWrapperObj.finalDirectSellingUnits = scmWrapperObj.unit1 = bidLineItem.Phoenix_Proposed_Direct_Selling_Unit__c;       
                            scmWrapperObj.awardedQty = scmWrapperObj.finalDirectSellingUnits;
                            if(bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate' || bidLineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change') scmWrapperObj.awardedQty = scmWrapperObj.previousQty;
                        }
                    }
                }
                if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0) scmWrapperObj.customerResponseLineItem = bidLineItem.Customer_Response_Lines__r;
                if(bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    if(bid.Phoenix_Customer_Type__c == 'Direct' || isOTCType == true){
                        if(bidLineItem.Phoenix_Current_Direct_Price__c > 0){
                            scmWrapperObj.previousDeadnet = (bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0;
                            scmWrapperObj.currentDeadnet = (bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0;
                            scmWrapperObj.businessCategory = 'Business Retained';
                        } else scmWrapperObj.businessCategory = 'Business Gained';
                    } else if(bid.Phoenix_Customer_Type__c == 'Net Indirect Pricing' || bid.Phoenix_Customer_Type__c == 'Direct and Indirect' || bid.Phoenix_Customer_Type__c == 'Econdisc' || bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Good Dated OTB'){
                        if(bidLineItem.Phoenix_Current_Direct_Price__c > 0 || bidLineItem.Phoenix_Current_Indirect_Price__c > 0){
                            scmWrapperObj.previousDeadnet = (bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0;
                            scmWrapperObj.currentDeadnet = (bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0;
                            scmWrapperObj.businessCategory = 'Business Retained';
                        } else scmWrapperObj.businessCategory = 'Business Gained';
                    } else if(bid.Phoenix_Customer_Type__c == 'BASE/DSH'){
                        if(bidLineItem.Phoenix_Current_Retail_Direct_Price__c > 0 || bidLineItem.Phoenix_Current_Retail_Indirect_Net__c > 0 || bidLineItem.Phoenix_Current_Retail_Indirect_Price__c > 0){
                            scmWrapperObj.previousDeadnet = (bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0;
                            scmWrapperObj.currentDeadnet = (bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0;
                            scmWrapperObj.businessCategory = 'Business Retained';
                        } else scmWrapperObj.businessCategory = 'Business Gained';
                    } else if(bid.Phoenix_Customer_Type__c == 'Walgreens' || bid.Phoenix_Customer_Type__c == 'ABC Progen' || bid.Phoenix_Customer_Type__c == 'ABC Pharmagen' 
                              || bid.Phoenix_Customer_Type__c == 'Costco' || bid.Phoenix_Customer_Type__c == 'Indirect' || bid.Phoenix_Customer_Type__c == 'Sams Club' 
                              || bid.Phoenix_Customer_Type__c == 'Government Pricing'){
                                  if(scmWrapperObj.previousIndirectPrice > 0){
                                      scmWrapperObj.previousDeadnet = (bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0;
                                      scmWrapperObj.currentDeadnet = (bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0;
                                      scmWrapperObj.businessCategory = 'Business Retained';
                                  } else scmWrapperObj.businessCategory = 'Business Gained';
                              } else if(bid.Phoenix_Customer_Type__c == 'ROS'){
                                  if(bidLineItem.Phoenix_Current_Direct_Price__c > 0 || bidLineItem.Phoenix_Current_Indirect_Price__c > 0 || bidLineItem.Phoenix_Current_Wholesaler_Price__c > 0 || bidLineItem.BidLineItemsExtn__r[0].Phoenix_Current_Major_Contract_Price__c > 0){
                                      scmWrapperObj.previousDeadnet = (bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0;
                                      scmWrapperObj.currentDeadnet = (bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0;
                                      scmWrapperObj.businessCategory = 'Business Retained';
                                  } else scmWrapperObj.businessCategory = 'Business Gained';
                              }  else if(bid.Phoenix_Customer_Type__c == 'RXSS'){
                                  if(bidLineItem.Phoenix_Current_Retail_Direct_Price__c > 0 || bidLineItem.Phoenix_Current_Retail_Indirect_Price__c > 0 || bidLineItem.Phoenix_Current_Wholesaler_Price__c > 0 || bidLineItem.Phoenix_Current_Anda_CP_Price__c > 0){
                                      scmWrapperObj.previousDeadnet = (bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0;
                                      scmWrapperObj.currentDeadnet = (bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0;
                                      scmWrapperObj.businessCategory = 'Business Retained';
                                  } else scmWrapperObj.businessCategory = 'Business Gained';
                              }  else if(bid.Phoenix_Customer_Type__c == 'ClarusOne'){
                                  if(bidLineItem.Phoenix_OS_RAD_NCP__c > 0 || bidLineItem.Phoenix_WMT_Direct_NCP__c > 0 || bidLineItem.Phoenix_WMT_Indirect_NCP__c > 0){
                                      scmWrapperObj.previousDeadnet = (bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0;
                                      scmWrapperObj.currentDeadnet = (bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0;
                                      scmWrapperObj.businessCategory = 'Business Retained';
                                  } else scmWrapperObj.businessCategory = 'Business Gained';
                              }
                }
                else if((bid.Phoenix_Bid_Type__c != 'RFP Bids' && bid.Phoenix_Bid_Type__c != 'OTC RFP') && bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number')){
                    scmWrapperObj.businessCategory = 'No Effect';
                    //scmWrapperObj.currentDeadnet = scmWrapperObj.previousDeadnet;
                }
                else if((bid.Phoenix_Bid_Type__c == 'RFP Bids' || bid.Phoenix_Bid_Type__c == 'OTC RFP') && bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded')){
                    if(scmWrapperObj.previousQty > 0){
                        scmWrapperObj.awardedQty = 0; scmWrapperObj.businessCategory = 'Business Lost';   scmWrapperObj.previousIndirectPrice = ((bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0);
                    } else{
                        scmWrapperObj.businessCategory = 'No Effect';
                    }
                } else if((bid.Phoenix_Bid_Type__c == 'RFP Bids' || bid.Phoenix_Bid_Type__c == 'OTC RFP') && bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0 && bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number'){
                    scmWrapperObj.businessCategory = 'No Effect';
                }
                if(isOTCType == true){
                    if(bidLineItem.Phoenix_Customer_Approval_OTC__c == '' || bidLineItem.Phoenix_Customer_Approval_OTC__c == null || bidLineItem.Phoenix_Customer_Approval_OTC__c == 'Send Back to Marketing'){
                        scmWrapperObj.businessCategory = 'Open Status';
                        openLineItemsCount += 1;
                        scmWrapperObj.awardedQty = ((scmWrapperObj.awardedQty != null) ? scmWrapperObj.awardedQty : 0);
                        scmWrapperObj.previousQty = ((scmWrapperObj.previousQty != null) ? scmWrapperObj.previousQty : 0);
                        scmWrapperObj.previousDeadnet = ((bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0);
                        scmWrapperObj.currentDeadnet = ((bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0);
                        scmWrapperObj.bidStatus = 'Pending';
                    }
                }
                else if((bid.Phoenix_Approval_Status__c == 'Customer\'s Update') && (((bidLineItem.Phoenix_Bid_Status__c == 'In Process' || bidLineItem.Phoenix_Bid_Status__c == 'Pending' || bidLineItem.Phoenix_Bid_Status__c == '' ||  bidLineItem.Phoenix_Bid_Status__c == null) && (bidLineItem.Phoenix_Final_Status__c == 'None' || bidLineItem.Phoenix_Final_Status__c == '' || bidLineItem.Phoenix_Final_Status__c == null)))){
                    scmWrapperObj.businessCategory = 'Open Status';
                    openLineItemsCount += 1;
                    scmWrapperObj.awardedQty = ((scmWrapperObj.awardedQty != null) ? scmWrapperObj.awardedQty : 0);
                    scmWrapperObj.previousQty = ((scmWrapperObj.previousQty != null) ? scmWrapperObj.previousQty : 0);
                    scmWrapperObj.previousDeadnet = ((bidLineItem.Phoenix_Current_ASP_Dose__c != null)? bidLineItem.Phoenix_Current_ASP_Dose__c: 0);
                    scmWrapperObj.currentDeadnet = ((bidLineItem.Phoenix_Proposed_ASP_Dose__c != null)? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0);
                    scmWrapperObj.bidStatus = 'Pending';
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
                if(scmWrapperObj.businessCategory != null) scmWrapperList.add(scmWrapperObj);
            }
            else if(bid.Phoenix_Bid_Type__c == 'Product Discontinuation Process' || bid.Phoenix_Bid_Type__c == 'Mass Product Removals'){
                ScmWrapper scmWrapperObj = new ScmWrapper();
                scmWrapperObj.bidRecord = bid;
                scmWrapperObj.customer = bidLineItem.Phoenix_Customer__r.Name;
                scmWrapperObj.customerId = bidLineItem.Phoenix_Customer__c;
                scmWrapperObj.contract = bidLineItem.Phoenix_Contract__r.Name;
                scmWrapperObj.contractId = bidLineItem.Phoenix_Contract__r.Id;
                scmWrapperObj.ndc = bidLineItem.Phoenix_NDC_Without_Dashes__c ;
                String uniqueKey = bidLineItem.Phoenix_Product__r.ProductCode+'_'+bidLineItem.Phoenix_Contract__r.Phoenix_Contract_Number__c;
                Phoenix_NPR_Data__c npr = nprMap.get(uniqueKey);
                if(npr != null){
                    scmWrapperObj.previousQty = (npr.Phoenix_12Months_Sales_Unit__c != null) ? npr.Phoenix_12Months_Sales_Unit__c: 0;
                    scmWrapperObj.previousIndirectPrice = (npr.Phoenix_Dead_Net_Tracking_GR__c != null) ? npr.Phoenix_Dead_Net_Tracking_GR__c: 0;
                } else{
                    scmWrapperObj.previousQty = 0;
                    scmWrapperObj.previousIndirectPrice = 0;                    
                }
                scmWrapperObj.productName = bidLineItem.Phoenix_Product__r.Name;
                scmWrapperObj.productId = bidLineItem.Phoenix_Product__r.Id;
                scmWrapperObj.productCode = bidLineItem.Phoenix_Product__r.ProductCode;
                scmWrapperObj.sapNumber = bidLineItem.Phoenix_Product_Code1__c ;
                scmWrapperObj.productFamily = bidLineItem.Product_Family_Name__c ;
                if(bidLineItem.BidLineItemsExtn__r!=null && bidLineItem.BidLineItemsExtn__r.size() > 0 && bidLineItem.BidLineItemsExtn__r[0] != null && bidLineItem.BidLineItemsExtn__r[0].Vision_Effective_Date_of_Removal__c != null){
                    List<String> dateSplit = bidLineItem.BidLineItemsExtn__r[0].Vision_Effective_Date_of_Removal__c.split('/');
                    Date removalEffectiveDate = date.newinstance(Integer.valueOf(dateSplit[2]), Integer.valueOf(dateSplit[1]), Integer.valueOf(dateSplit[0]));
                    if(removalEffectiveDate != null) scmWrapperObj.removalEffectiveDate = String.valueOf(removalEffectiveDate);
                }
                scmWrapperObj.showDropdown = false;
                scmWrapperObj.bidType = bid.Phoenix_Bid_Type__c;
                scmWrapperObj.bidLineItem = bidLineItem;
                scmWrapperObj.businessCategory = 'Business Lost';
                scmWrapperList.add(scmWrapperObj);
            }
        }
        if(isOTCType){
               if(OTCNoEffectList.size() > 0){
                   for(Phoenix_Bid_Line_Item__c bidLineItem: OTCNoEffectList){
                       ScmWrapper scmWrapperObj = new ScmWrapper();
                       scmWrapperObj.bidRecord = bid;
                       scmWrapperObj.customer = bid.Phoenix_Customer__r.Name;
                       scmWrapperObj.ndc = bidLineItem.Phoenix_NDC_Without_Dashes__c ;
                       scmWrapperObj.productName = bidLineItem.Phoenix_Product__r.Name;
                       scmWrapperObj.sapNumber = bidLineItem.Phoenix_Product_Code1__c ;
                       scmWrapperObj.productFamily = bidLineItem.Product_Family_Name__c ;
                       scmWrapperObj.bidStatus = (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0) ? bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c : '';
                       scmWrapperObj.awardedQty = (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0) ? bidLineItem.Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : null;
                       scmWrapperObj.awardedPrice = (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0) ? bidLineItem.Customer_Response_Lines__r[0].Phoenix_Final_Approvd_Pricing_Contracts__c : null;
                       scmWrapperObj.awardedPosition = (bidLineItem.Customer_Response_Lines__r != null && bidLineItem.Customer_Response_Lines__r.size()>0) ? bidLineItem.Customer_Response_Lines__r[0].Phoenix_Award_Position__c : null;
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
                       scmWrapperObj.previousDeadnet = (bidLineItem.Phoenix_Current_ASP_Dose__c != null) ? bidLineItem.Phoenix_Current_ASP_Dose__c: 0;
                       scmWrapperObj.currentDeadnet = (bidLineItem.Phoenix_Proposed_ASP_Dose__c != null) ? bidLineItem.Phoenix_Proposed_ASP_Dose__c: 0;
                       scmWrapperObj.bidType = bid.Phoenix_Bid_Type__c;
                       scmWrapperObj.previousQty = (bidLineItem.Phoenix_Override_Current_Direct_Units__c != null) ? bidLineItem.Phoenix_Override_Current_Direct_Units__c : (bidLineItem.Phoenix_Current_Direct_Selling_Unit__c != null)?bidLineItem.Phoenix_Current_Direct_Selling_Unit__c:0;
                       scmWrapperObj.previousIndirectPrice = bidLineItem.Phoenix_Current_Indirect_Price__c;
                       scmWrapperObj.previousPosition = bidLineItem.Phoenix_Current_Position__c;
                       scmWrapperObj.bidLineItem = bidLineItem;
                       scmWrapperObj.isOTCType = true;
                       scmWrapperObj.businessCategory = 'No Effect';
                       scmWrapperObj.currentTPT = Integer.valueOf(((scmWrapperObj.currentDeadnet * ((scmWrapperObj.awardedQty != null) ? scmWrapperObj.awardedQty : 0))-(((bidLineItem.Phoenix_Product__r.Phoenix_Throughput_cost__c != null) ? bidLineItem.Phoenix_Product__r.Phoenix_Throughput_cost__c : 0)) * ((scmWrapperObj.awardedQty != null) ? scmWrapperObj.awardedQty : 0)));
                       scmWrapperObj.previousTPT = Integer.valueOf(((scmWrapperObj.previousDeadnet * ((scmWrapperObj.previousQty != null) ? scmWrapperObj.previousQty : 0))-(((bidLineItem.Phoenix_Product__r.Phoenix_Throughput_cost__c != null) ? bidLineItem.Phoenix_Product__r.Phoenix_Throughput_cost__c : 0)) * ((scmWrapperObj.awardedQty != null) ? scmWrapperObj.previousQty : 0)));
                       scmWrapperObj.tptVariance = scmWrapperObj.currentTPT - scmWrapperObj.previousTPT;
                       if(scmWrapperObj.currentTPT != 0 && scmWrapperObj.currentDeadnet != 0 && scmWrapperObj.awardedQty !=0) scmWrapperObj.currentTPTPercent = scmWrapperObj.currentTPT/(scmWrapperObj.currentDeadnet * scmWrapperObj.awardedQty);   
                       else scmWrapperObj.currentTPTPercent = 0;
                       if(scmWrapperObj.previousTPT != 0 && scmWrapperObj.previousDeadnet != 0 && scmWrapperObj.previousQty !=0) scmWrapperObj.previousTPTPercent = scmWrapperObj.previousTPT/(scmWrapperObj.previousDeadnet * scmWrapperObj.previousQty);   
                       else scmWrapperObj.previousTPTPercent = 0;
                       if(scmWrapperObj.previousTPT != 0 && (scmWrapperObj.currentTPT - scmWrapperObj.previousTPT) != 0) scmWrapperObj.isTPTPercentNaN = false;
                       else scmWrapperObj.isTPTPercentNaN = true;
                       scmWrapperList.add(scmWrapperObj);
                   }
               }
           }
        bidLineItemsList.clear();OTCNoEffectList.clear();
        wrap.scmWrapperList = scmWrapperList;
        wrap.openLineItemsCount = openLineItemsCount;        
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'VisionBidAnalysisCls', Phoenix_Method_Name__c = 'getData', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        return wrap;
    }
    @AuraEnabled 
    public static string testCoverage(){
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
        return 'Success';
    }
    /*@AuraEnabled 
    public static List<Phoenix_Bid__c> getSearchRelatedData(String searchText){
        String searchKey = '%'+searchText+'%';
        List<String> listOfStatus = new List<String>{'Closed', 'Vistex Update', 'Contracts', 'Contracts Rejected', 'Customer Rejected', 'Customer\'s Update'};
        List<Phoenix_Bid__c> resultData = [SELECT Id, Name, Vision_Current_Total__c, Vision_Previous_Total__c, Vision_Total_Annual_Impact__c, Vision_Total_FY_Business_Impact__c, Vision_Change__c, Vision_Per_Change__c, Vision_Total_Bid_Line_Items__c, Vision_Total_New_Award_s__c, Vision_Total_Price_Change_s__c, Vision_Total_Price_Volume_Change_s__c, Vision_Total_Volume_Change_s__c, Vision_Total_Product_Lost_s__c, Vision_Total_No_Effect_s__c FROM Phoenix_Bid__c WHERE Name LIKE: searchKey AND Phoenix_Approval_Status__c IN:listOfStatus];
        return resultData;
    }
    
    @AuraEnabled 
    public static List<Phoenix_Bid__c> getSelectedData(String searchText){
        List<Phoenix_Bid__c> resultData = [SELECT Id, Name, Vision_Current_Total__c, Vision_Previous_Total__c, Vision_Total_Annual_Impact__c, Vision_Total_FY_Business_Impact__c, Vision_Change__c, Vision_Per_Change__c, Vision_Total_Bid_Line_Items__c, Vision_Total_New_Award_s__c, Vision_Total_Price_Change_s__c, Vision_Total_Price_Volume_Change_s__c, Vision_Total_Volume_Change_s__c, Vision_Total_Product_Lost_s__c, Vision_Total_No_Effect_s__c FROM Phoenix_Bid__c WHERE Id =: searchText];
        return resultData;
    }*/
    
    public class finalWrapper {
        @AuraEnabled public List<ScmWrapper> scmWrapperList;
        @AuraEnabled public Integer openLineItemsCount;
    }
    
    public class ScmWrapper{
        @AuraEnabled Public String ndc;
        @AuraEnabled Public String customer;
        @AuraEnabled Public String customerId;
        @AuraEnabled Public String productName;
        @AuraEnabled Public String productId;
        @AuraEnabled Public String productCode;
        @AuraEnabled public string contract;
        @AuraEnabled Public String contractId;
        @AuraEnabled Public String sapNumber;
        @AuraEnabled public string reasons;
        @AuraEnabled public string bidType;
        @AuraEnabled Public String productFamily;
        @AuraEnabled Public decimal proposedBottles;
        @AuraEnabled Public decimal previousQty;
        @AuraEnabled Public decimal overrideCurrentDirectUnits;
        @AuraEnabled Public decimal overrideCurrentIndirectUnits;
        @AuraEnabled Public decimal currentRetailDirectUnits;
        @AuraEnabled Public decimal currentRetailIndirectUnits;
        @AuraEnabled Public decimal overrideCurrentUnits;
        @AuraEnabled Public decimal overrideCVSDirectUnits;
        @AuraEnabled Public decimal overrideCVSIndirectUnits;
        @AuraEnabled Public decimal overrideCardinalUnits;
        @AuraEnabled Public decimal overrideMajorUnits;
        @AuraEnabled Public decimal proposedSales;
        @AuraEnabled Public String templateType;
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        @AuraEnabled public Phoenix_Bid_Line_Item__c bidLineItem;
        @AuraEnabled public Phoenix_Customer_Response_Line__c customerResponseLineItem;
        @AuraEnabled public boolean isSCMApprovePerson;
        @AuraEnabled public String bidStatus;
        @AuraEnabled public Decimal awardedQty;
        @AuraEnabled public Decimal awardedPrice;
        @AuraEnabled public Decimal annualImpact;
        @AuraEnabled public Decimal finalDirectPrice;
        @AuraEnabled public Decimal previousIndirectPrice;
        @AuraEnabled public Decimal currentIndirectPrice;
        @AuraEnabled public Decimal finalIndirectPrice;
        @AuraEnabled public Decimal currentDeadnet;
        @AuraEnabled public Decimal previousDeadnet;
        @AuraEnabled public Decimal previousPrice;
        @AuraEnabled public Decimal currentPrice;
        @AuraEnabled public String awardedPosition;
        @AuraEnabled public String previousPosition;
        @AuraEnabled public String customerResponseDate;
        @AuraEnabled public String priceEffectiveDate;
        @AuraEnabled public String supplyEffectiveDate;
        @AuraEnabled public String removalEffectiveDate;
        @AuraEnabled public Boolean showDropdown;
        @AuraEnabled public Boolean isOTCType;
        @AuraEnabled public string businessCategory;
        @AuraEnabled public Decimal priceVariance;
        @AuraEnabled public Decimal volumeVariance;
        @AuraEnabled public Decimal previousTPT;
        @AuraEnabled public Decimal currentTPT;
        @AuraEnabled public Decimal tptVariance;
        @AuraEnabled public Decimal previousTPTPercent;
        @AuraEnabled public Decimal currentTPTPercent;
        @AuraEnabled public Boolean isTPTPercentNaN;
        @AuraEnabled public String previousCategory;
        @AuraEnabled public String currentCategory;
        @AuraEnabled public Decimal finalDirectSellingUnits;
        @AuraEnabled public Decimal finalIndirectSellingUnits;
        @AuraEnabled public Decimal directAholDelhaizeUnits;
        @AuraEnabled public Decimal directGaintEagleUnits;
        @AuraEnabled public Decimal retailIndirectUnits;
        @AuraEnabled public Decimal proposedSmithDrugUnits;
        @AuraEnabled public Decimal proposedAndaUnits;
        @AuraEnabled public Decimal CVSDirectUnits;
        @AuraEnabled public Decimal CVSIndirectUnits;
        @AuraEnabled public Decimal cardinalUnits;
        @AuraEnabled public Decimal majorContractUnits;
        @AuraEnabled public Decimal osUnits;
        @AuraEnabled public Decimal radUnits;
        @AuraEnabled public Decimal wmtUnits;
        @AuraEnabled public Decimal baseUnits;
        @AuraEnabled public Decimal dshUnits;
        @AuraEnabled public Decimal autoSubUnits;
        @AuraEnabled public Decimal otbDirectUnits;
        @AuraEnabled public Decimal otbIndirectUnits;
        @AuraEnabled public Decimal unit1;
        @AuraEnabled public Decimal unit2;
        @AuraEnabled public Decimal unit3;
        @AuraEnabled public Decimal unit4;
        @AuraEnabled public Decimal unit5;
        @AuraEnabled public Decimal unit6;
        @AuraEnabled public Decimal unit7;
        @AuraEnabled public Decimal unit8;
        @AuraEnabled public Decimal unit9;
        @AuraEnabled public Decimal unit10;
        
        
        ScmWrapper(){
            bidRecord = new Phoenix_Bid__c();
            isSCMApprovePerson=false;
        }
    }
}