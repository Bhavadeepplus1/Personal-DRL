public class Phoenix_NDCFinanceView {
    @AuraEnabled 
    public static list<AggregateResult> getAllTotals(Id bidId)
    {
        AggregateResult[] groupedResults=[select sum(Phoenix_Current_Sales_Finance__c)csf,sum(Phoenix_Net_Sales_External__c) currentSales, sum(Phoenix_Current_TP_Margin__c)ctpm, 
                                          sum(Phoenix_Proposed_Sales__c)prs,sum(Phoenix_Proposed_TP_Margin__c)ptpm, sum(Phoenix_DRL_Share__c) totalDrlShare, sum(Phoenix_Proposed_ASP_Dose__c) totalProposedASp,
                                          sum(Phoenix_Difference_Volume__c)vlmv, sum(Phoenix_Difference_Price__c)prv, sum(Phoenix_Difference_Sales__c)dffs, sum(Finance_Current_Sales__c) newFinSales,
                                          sum(Phoenix_Difference_Margin__c)dffm, sum(Phoenix_SSA_Hit__c)ssahit,sum(Phoenix_Total_DRL_Share__c)tdrlsh,sum(Phoenix_DRL_Share_Impact__c)drlshim, sum(Phoenix_Annualized_TP_Impact__c)tpgmb,sum(Phoenix_Annualized_GM_Impact__c)tpgma  from Phoenix_Bid_Line_Item__c where 
                                          Phoenix_Bid__c=:bidId and Phoenix_Final_Status__c!='Not Approved'];
        return groupedResults;
    }
    @AuraEnabled 
    public static List<ScmWrapper> getScmData(String bidId){
        String query ='';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for(String fieldName : fieldMap.keyset() ){
            if(strFields == null || strFields == '')
                strFields = fieldName;
            else
                strFields = strFields + ' , ' + fieldName;
        }
        string notApproved = 'Not Approved';
        query = 'select ' + strFields + ', Phoenix_Product__r.name from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved  ORDER BY Product_Family_Name__c ASC'  ;
        List<Phoenix_Bid_Line_Item__c> bidLineItemsList = Database.query(query);
        Phoenix_Bid__c bid = [SELECT Id, Name,Phoenix_is_OTC_Bid__c, Phoenix_Customer_Type__c, Phoenix_Template_Type__c , Phoenix_Bid_Type__c, Phoenix_Approval_Status__c, Phoenix_Reference_Contracts__c FROM Phoenix_Bid__c WHERE ID =: bidId];
        List<String> contractNumbers = new List<String>();
        contractNumbers = (bid.Phoenix_Reference_Contracts__c != '' && bid.Phoenix_Reference_Contracts__c != null) ? bid.Phoenix_Reference_Contracts__c.split(','):null;
        
        /*//For ROS Template logic
        List<Phoenix_BidLineItemExtn__c> bidLineItemExtnList = new List<Phoenix_BidLineItemExtn__c>();
        List<Phoenix_BidLineItemExtn__c> bidLineItemExtnUpdateList = new List<Phoenix_BidLineItemExtn__c>();
        Map <Id, Phoenix_BidLineItemExtn__c> bliExtnMap = new Map<Id, Phoenix_BidLineItemExtn__c>(); 
        if(bid.Phoenix_Customer_Type__c == 'ROS'){
            query = '';
            SobjectApiName = 'Phoenix_BidLineItemExtn__c';
            fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
            List<String> strFieldsList = new List<String>();
            for (String fieldName: fieldMap.keyset()) {
                strFieldsList.add(fieldName);
            }
            Set<Id> bidLineItemId = new Set<Id>();
            for(Phoenix_Bid_Line_Item__c bidLineItem : bidLineItemsList){
                bidLineItemId.add(bidLineItem.Id);
            }
            
            query = 'SELECT '+String.join(strFieldsList,' , ')+' FROM '+SobjectApiName+' WHERE Phoenix_Bid_Line_Item__c IN: bidLineItemId';
            bidLineItemExtnList = Database.query(query);
            if(bidLineItemExtnList.size()>0){
                for(Phoenix_BidLineItemExtn__c obj : bidLineItemExtnList){
                    bliExtnMap.put(obj.Phoenix_Bid_Line_Item__c, obj);
                }
            }
        } */
        List<ScmWrapper> scmWrapperList = new List<ScmWrapper>();
        Decimal copyofMonthlyDamand = 0;
        for(Phoenix_Bid_Line_Item__c bidLineItem : bidLineItemsList){
            if(bidLineItem.Product_Family_Name__c != null){
                ScmWrapper scmWrapperObj = new ScmWrapper();
                scmWrapperObj.bidRecord = bid;
                scmWrapperObj.ndc = bidLineItem.Phoenix_NDC__c ;
                scmWrapperObj.productName = bidLineItem.Phoenix_Product__r.Name;
                scmWrapperObj.sapNumber = bidLineItem.Phoenix_Product_Code1__c ;
                scmWrapperObj.pkgSize = bidLineItem.Phoenix_Pkg_Size1__c;
                scmWrapperObj.casePack = bidLineItem.Phoenix_Case_Pack1__c;
                scmWrapperObj.moq = bidLineItem.Phoenix_MOQ1__c;
                scmWrapperObj.productFamily = bidLineItem.Product_Family_Name__c ;
                scmWrapperObj.productFamilyId = bidLineItem.Product_Family__c ;
                scmWrapperObj.productFamilyName = bidLineItem.Product_Family_Name__c ;
                scmWrapperObj.comparetobrandName = bidLineItem.Phoenix_Compare_To_Brand_Name1__c ;
                scmWrapperObj.productDirector = bidLineItem.Phoenix_Product_Director1__c ;
                scmWrapperObj.orangebookRating = bidLineItem.Phoenix_Orange_Book_Rating1__c ;
                scmWrapperObj.throughputCost = bidLineItem.Phoenix_Throughput_Cost1__c ;
                scmWrapperObj.oldthroughputCost = bidLineItem.Phoenix_Old_Throughput_Cost__c ;
                scmWrapperObj.wac = bidLineItem.Phoenix_WAC1__c ;
                scmWrapperObj.doses = bidLineItem.Phoenix_Doses__c;
                scmWrapperObj.ssahit = bidLineItem.Phoenix_SSA_Hit__c;
                scmWrapperObj.latestestimate = bidLineItem.Phoenix_Latest_Estimate__c;
                //scmWrapperObj.casePack = bidLineItem.Phoenix_Pkg_Size__c ;
                scmWrapperObj.currentDoses = bidLineItem.Phoenix_Doses__c ;
                //scmWrapperObj.currentDoses = bidLineItem.Phoenix_Current_Sales_Finance__c ;
                if(bidLineItem.Phoenix_Bid_Template_Refrence__c == 'ClarusOne')
                    scmWrapperObj.currentsalesFinance = bidLineItem.Phoenix_Net_Sales_External__c ;
                else
                    scmWrapperObj.currentsalesFinance = (bidLineItem.Finance_Current_Sales__c != null ? bidLineItem.Finance_Current_Sales__c : bidLineItem.Phoenix_Current_Sales_Finance__c ); //
                
                scmWrapperObj.currentTPMargin = bidLineItem.Phoenix_Current_TP_Margin__c ;
                scmWrapperObj.currentTPMarginprecent = bidLineItem.Phoenix_Current_TP_MarginPercent__c ;
                if(bidLineItem.Phoenix_Current_ASP_Dose__c != null)
                    scmWrapperObj.currentASPorDose = bidLineItem.Phoenix_Current_ASP_Dose__c ;
                else
                    scmWrapperObj.currentASPorDose = 0;
               /* Phoenix_BidLineItemExtn__c bliExtObj = new Phoenix_BidLineItemExtn__c();
                if(bid.Phoenix_Customer_Type__c == 'ROS'){
                    if(bliExtnMap.containskey(bidLineItem.Id)){
                        bliExtObj = bliExtnMap.get(bidLineItem.Id);
                        system.debug('bliExtObj.Name ::'+bliExtObj.Name);
                        Decimal totalUnits = bidLineItem.Phoenix_Override_Total_units__c != null?
                            bidLineItem.Phoenix_Override_Total_units__c :(bliExtObj.Phoenix_Total3MonAnnualSellingUnits__c != null ? bliExtObj.Phoenix_Total3MonAnnualSellingUnits__c : 0);
                                
                                scmWrapperObj.monthlyDemand = totalUnits;
                        Decimal propTotalUnits = (bliExtObj.Phoenix_Proposed_CVS_DirSellingUnits__c != null ? bliExtObj.Phoenix_Proposed_CVS_DirSellingUnits__c : 0)+
                            (bliExtObj.Phoenix_Proposed_CVS_IndirSellingUnits__c != null ? bliExtObj.Phoenix_Proposed_CVS_IndirSellingUnits__c : 0)+
                            (bliExtObj.Phoenix_Proposed_Cardinal_Units__c != null ? bliExtObj.Phoenix_Proposed_Cardinal_Units__c : 0)+
                            (bliExtObj.Phoenix_Proposed_Major_Units__c != null ? bliExtObj.Phoenix_Proposed_Major_Units__c : 0);
                        Decimal propBottles = propTotalUnits != 0 ? propTotalUnits : 
                        (bidLineItem.Phoenix_Override_Total_units__c != null? bidLineItem.Phoenix_Override_Total_units__c : 
                         (bliExtObj.Phoenix_Total3MonAnnualSellingUnits__c != null ? bliExtObj.Phoenix_Total3MonAnnualSellingUnits__c : 0));
                             scmWrapperObj.proposedBottles = propBottles;
                        scmWrapperObj.differenceBottles = scmWrapperObj.proposedBottles - scmWrapperObj.monthlyDemand;//bidLineItem.Phoenix_Difference_Bottles__c;
                    }
                    system.debug('BidLineItem record does not have Extn child LineItem rec.');
                }
                else{ */
                    scmWrapperObj.proposedBottles = (bidLineItem.Phoenix_SCM_Final_Approval__c == false) ? bidLineItem.Phoenix_Final_Total_Selling_Unit__c : (bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ;
                    scmWrapperObj.monthlyDemand = bidLineItem.Phoenix_Total_Selling_Unit__c ;
                    scmWrapperObj.differenceBottles = bidLineItem.Phoenix_Difference_Bottles__c;
               // }
                
                scmWrapperObj.proposedDoses = bidLineItem.Phoenix_Final_Annual_Extended_Units__c ;
                
                scmWrapperObj.proposedTPMargin = bidLineItem.Phoenix_Proposed_TP_Margin__c;
                //if(bidLineItem.Phoenix_Proposed_ASP_Dose__c != null){
                scmWrapperObj.proposedTPMarginpercent = bidLineItem.Phoenix_Proposed_TPMargin__c;
                //}
                /* else{
scmWrapperObj.proposedTPMarginpercent = 0;
}*/
                //if(bidLineItem.Phoenix_Proposed_ASP_Dose__c != null){
                scmWrapperObj.proposedASPorDose = bidLineItem.Phoenix_Proposed_ASP_Dose__c;
                
                
                scmWrapperObj.proposedSales = bidLineItem.Phoenix_Proposed_Sales__c ;
                scmWrapperObj.proposedBudgetASP = bidLineItem.Phoenix_Proposed_Budget_ASP__c;
                if(bidLineItem.Phoenix_Proposed_to_Budget__c != null){
                    scmWrapperObj.ProposedpercenttoBudget = bidLineItem.Phoenix_Proposed_to_Budget__c;
                }
                else if(scmWrapperObj.proposedASPorDose == 0){
                    scmWrapperObj.ProposedpercenttoBudget = -100;  
                }
                else if(bidLineItem.Phoenix_Proposed_Budget_ASP__c == 0) {
                    scmWrapperObj.ProposedpercenttoBudget = 0;
                }
                //scmWrapperObj.differenceBottles = bidLineItem.Phoenix_Difference_Bottles__c;
                scmWrapperObj.differenceDoses = bidLineItem.Phoenix_Difference_Doses__c;
                scmWrapperObj.differenceVolume = bidLineItem.Phoenix_Difference_Volume__c;
                scmWrapperObj.differencePrice = bidLineItem.Phoenix_Difference_Price__c;
                scmWrapperObj.differenceSales = bidLineItem.Phoenix_Difference_Sales__c;
                scmWrapperObj.differenceMargin = bidLineItem.Phoenix_Difference_Margin__c;
                if(bidLineItem.Phoenix_Difference_ASP_Change__c != null){
                    scmWrapperObj.differenceASPPercenttoChange = bidLineItem.Phoenix_Difference_ASP_Change__c;
                }
                else if(scmWrapperObj.proposedASPorDose == 0 && scmWrapperObj.currentASPorDose == 0){
                    scmWrapperObj.differenceASPPercenttoChange = 0;
                }
                else if(scmWrapperObj.currentASPorDose ==0){
                    scmWrapperObj.differenceASPPercenttoChange=0; 
                }
                else if(scmWrapperObj.proposedASPorDose == 0 && scmWrapperObj.currentASPorDose != 0){
                    scmWrapperObj.differenceASPPercenttoChange = -100;
                }
                scmWrapperObj.financeApproval = bidLineItem.Phoenix_Finance_Approval__c;
                scmWrapperObj.financeComments = bidLineItem.Phoenix_Finance_Comments__c; 
                scmWrapperObj.commercialExpression = bidLineItem.Phoenix_Comm_Exps1__c;
                scmWrapperObj.commercialCost = bidLineItem.Phoenix_Commercial_Cost__c;
                scmWrapperObj.profitavailableDistribution = bidLineItem.Phoenix_Profit_available_fr_distribution__c;
                scmWrapperObj.psPartner = bidLineItem.Phoenix_PS_Partner_11__c;
                scmWrapperObj.pspartnerPercent = bidLineItem.Phoenix_PS_Partner_1percent__c;
                scmWrapperObj.profitsharetoPartner = bidLineItem.Phoenix_Profit_share_to_partner1__c;
                scmWrapperObj.psPartnertwo = bidLineItem.Phoenix_PS_Partner_21__c;
                scmWrapperObj.psPartnertwopercent = bidLineItem.Phoenix_PS_Partner_2percent__c;
                scmWrapperObj.profitsharetoPartnertwo = bidLineItem.Phoenix_Profit_share_to_partner2__c;
                scmWrapperObj.totalprofitShare = bidLineItem.Phoenix_Total_Profit_share__c;
                scmWrapperObj.valuetotalprofitShare = bidLineItem.Phoenix_Value_Total_Profit_Share__c;
                scmWrapperObj.royalitypartnerName = bidLineItem.Phoenix_Royalty_Partner_Name1__c;
                scmWrapperObj.royalitypercent = bidLineItem.Phoenix_Royaltypercent__c;
                scmWrapperObj.royality = bidLineItem.Phoenix_Royalty1__c;
                scmWrapperObj.valueroyality = bidLineItem.Phoenix_Value_Royalty__c;
                scmWrapperObj.drlShare = bidLineItem.Phoenix_DRL_Share__c;
                scmWrapperObj.totaldrlShare = bidLineItem.Phoenix_Total_DRL_Share__c;
                scmWrapperObj.drlMargin = bidLineItem.Phoenix_DRL_Margin_DRL__c;
                scmWrapperObj.currentRoyality = bidLineItem.Phoenix_Current_Royalty__c;
                scmWrapperObj.profitAvailability = bidLineItem.Phoenix_Current_Profit_Available_For_Dis__c;
                scmWrapperObj.currentProfitPartnerOne = bidLineItem.Phoenix_Current_Profit_Share_To_Partner1__c;
                scmWrapperObj.currentProfitPartnerTwo = bidLineItem.Phoenix_Current_Profit_Share_To_Partner2__c;
                scmWrapperObj.currentDRLShare = bidLineItem.Phoenix_Current_DRL_Share__c;
                scmWrapperObj.drlShareImpact = bidLineItem.Phoenix_DRL_Share_Impact__c;
                scmWrapperObj.annualizedTPImpact = bidLineItem.Phoenix_Annualized_TP_Impact__c;
                scmWrapperObj.annualizedGMImpact = bidLineItem.Phoenix_Annualized_GM_Impact__c;
                scmWrapperObj.lowestPriceORSKU=bidLineItem.Phoenix_Lowest_Price_SKU1__c	;
                scmWrapperObj.templateType = bidLineItem.Phoenix_Bid_Template_Refrence__c;
                scmWrapperList.add(scmWrapperObj);
            }
        }
        if(scmWrapperList != null && scmWrapperList.size()>0 && contractNumbers != null){
            scmWrapperList[0].noOfContracts = contractNumbers.size();
        }
            
        return scmWrapperList;
    }
    
    public class ScmWrapper{
        @AuraEnabled Public String ndc;
        @AuraEnabled Public String productName;
        @AuraEnabled Public String sapNumber;
        @AuraEnabled Public decimal	pkgSize;
        @AuraEnabled Public decimal casePack;
        @AuraEnabled Public decimal moq;
        @AuraEnabled Public String productFamily;
        @AuraEnabled Public String comparetobrandName;
        @AuraEnabled Public String productDirector;
        @AuraEnabled Public String orangebookRating;
        @AuraEnabled Public decimal throughputCost;
        @AuraEnabled Public decimal oldthroughputCost;
        @AuraEnabled Public decimal wac;
        @AuraEnabled Public decimal doses;
        @AuraEnabled Public decimal ssahit;
        @AuraEnabled Public decimal latestestimate;
        @AuraEnabled Public decimal monthlyDemand;
        @AuraEnabled Public decimal currentDoses;
        @AuraEnabled Public decimal currentsalesFinance;
        @AuraEnabled Public decimal currentTPMargin;
        @AuraEnabled Public decimal currentTPMarginprecent;
        @AuraEnabled Public decimal currentASPorDose;
        @AuraEnabled Public decimal proposedBottles;
        @AuraEnabled Public decimal proposedDoses;
        @AuraEnabled Public decimal proposedSales;
        @AuraEnabled Public decimal proposedTPMargin;
        @AuraEnabled Public decimal proposedTPMarginpercent;
        @AuraEnabled Public decimal proposedASPorDose;
        @AuraEnabled Public decimal proposedBudgetASP;
        @AuraEnabled Public decimal ProposedpercenttoBudget;
        @AuraEnabled Public decimal differenceBottles;
        @AuraEnabled Public decimal	differenceDoses;
        @AuraEnabled Public decimal	differenceVolume;
        @AuraEnabled Public decimal	differencePrice;
        @AuraEnabled Public decimal	differenceSales;
        @AuraEnabled Public decimal differenceMargin;
        @AuraEnabled Public decimal differenceASPPercenttoChange;
        @AuraEnabled Public String financeApproval;
        @AuraEnabled Public String financeComments;
        @AuraEnabled Public decimal commercialExpression;
        @AuraEnabled Public decimal commercialCost;
        @AuraEnabled Public decimal profitavailableDistribution;
        @AuraEnabled Public String psPartner;
        @AuraEnabled Public decimal pspartnerPercent;
        @AuraEnabled Public decimal profitsharetoPartner;
        @AuraEnabled Public String psPartnertwo;
        @AuraEnabled Public decimal psPartnertwopercent;
        @AuraEnabled Public decimal profitsharetoPartnertwo;
        @AuraEnabled Public decimal totalprofitShare;
        @AuraEnabled Public decimal valuetotalprofitShare;
        @AuraEnabled Public String royalitypartnerName;
        @AuraEnabled Public decimal royalitypercent;
        @AuraEnabled Public decimal royality;
        @AuraEnabled Public decimal valueroyality;
        @AuraEnabled Public decimal drlShare;
        @AuraEnabled Public decimal totaldrlShare;
        @AuraEnabled Public decimal drlMargin;
        @AuraEnabled Public decimal currentRoyality;
        @AuraEnabled Public decimal profitAvailability;
        @AuraEnabled Public decimal currentProfitPartnerOne;
        @AuraEnabled Public decimal currentProfitPartnerTwo;
        @AuraEnabled Public decimal currentDRLShare;
        @AuraEnabled Public decimal drlShareImpact;
        @AuraEnabled Public decimal annualizedTPImpact;
        @AuraEnabled Public decimal annualizedGMImpact;
        @AuraEnabled Public decimal lowestPriceORSKU;
        @AuraEnabled Public String templateType;
        @AuraEnabled public Integer noOfContracts;
        @AuraEnabled Public String productFamilyId;
        @AuraEnabled Public String productFamilyName;
        /* @AuraEnabled Public decimal additionalReq;
@AuraEnabled Public decimal totalRevisedReq;
@AuraEnabled Public decimal dollarValue;
@AuraEnabled Public String scmApproval;
@AuraEnabled Public decimal scmAprQtyPercent;
@AuraEnabled Public decimal scmAprQty;
@AuraEnabled Public String estimatedTime;
@AuraEnabled Public String scmrejectionReason;
@AuraEnabled Public String scmcomments;
@AuraEnabled Public String currentRecordId;
@AuraEnabled Public decimal initialStockingOrderVolume;
@AuraEnabled Public string initialStockingOrderComments;
@AuraEnabled Public boolean finalSCMApproval;*/
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        @AuraEnabled public boolean isSCMApprovePerson;
        
        
        ScmWrapper(){
            bidRecord = new Phoenix_Bid__c();
            isSCMApprovePerson=false;
        }
        
        
        
    }
    
}