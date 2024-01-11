public class Phoenix_HumanaIndirectHandler extends TriggerHandler {
    private list < Phoenix_Bid_Line_Item__c > triggerNew;
    private list < Phoenix_Bid_Line_Item__c > triggerOld;
    private Map < Id, Phoenix_Bid_Line_Item__c > newMap;
    private Map < Id, Phoenix_Bid_Line_Item__c > oldMap;
    
    public Phoenix_HumanaIndirectHandler() {
        this.newMap = (Map < Id, Phoenix_Bid_Line_Item__c > ) Trigger.newMap;
        this.oldMap = (Map < Id, Phoenix_Bid_Line_Item__c > ) Trigger.oldMap;
        this.triggerNew = (List < Phoenix_Bid_Line_Item__c > ) Trigger.new;
        this.triggerOld = (List < Phoenix_Bid_Line_Item__c > ) Trigger.old;
    }
    public override void beforeInsert() {
        beforeUpdate();
    }
    public override void beforeUpdate() {
        system.debug('Phoenix_Util.blnNPRDone--->'+Phoenix_Util.blnNPRDone); 
        Phoenix_Bid__c bidRec = [SELECT Id,Phoenix_Customer_Type__c, Phoenix_Customer__r.Phoenix_Rebates__c,Phoenix_Customer__r.Phoenix_Cash_Discount__c ,Phoenix_Reference_Contracts__c,
                                 Phoenix_Customer__r.Phoenix_Fee__c,Phoenix_Customer__r.Phoenix_CM_Fees__c,Phoenix_Bid_Proposed_Position__c, Phoenix_REMS_Program_Fee__c,
                                 Phoenix_Approval_Status__c,Phoenix_Proposed_Cash_Terms__c,Phoenix_Initial_Order_Discount_Type__c, Phoenix_Custom_type__c, 
                                 Phoenix_Current_CD__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Initial_Order_Discount_of_Days__c, 
                                 Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Bid_Type__c ,Phoenix_Sales_Out_Promotion_of_Days__c,Phoenix_Contract_Management_Fee__c,Phoenix_Proposed_Value_Admin_Fee__c,
                                 Phoenix_Controlled_Substance__c,Phoenix_Template_Type_Humana__c,Phoenix_Required_Cold_Storage__c,Phoenix_Controlled_Distribution__c,Phoenix_Proposed_SSA_No_of_Days__c
                                 FROM Phoenix_Bid__c 
                                 WHERE Id =: triggerNew[0].Phoenix_Bid__c];
        List<Phoenix_Bid_Line_Item__c> bidlines =[select Phoenix_Product__r.ProductCode, Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Controlled_Substance__c, Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Refrigerated__c, Phoenix_Product__r.Phoenix_Limited_Distribution__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: triggerNew[0].Phoenix_Bid__c];
        /*  List<Phoenix_Bid__c> latestBid =[SELECT Id from Phoenix_Bid__c WHERE Phoenix_Customer__c =: bidRec.Phoenix_Customer__c AND Phoenix_Approval_Status__c != 'Draft' AND Phoenix_Customer_Type__c = 'Direct' AND Phoenix_Bid_Type__c = 'RFP Bids' ORDER BY CreatedDate DESC LIMIT 1];
system.debug('latest bid ' + latestBid[0].Id);*/
        List<String> productCodes = new List<String>();
         Map<Id,boolean> controllerSubstance = new Map<Id,Boolean>();
        Map<Id,boolean> requireColdStorage = new Map<Id,Boolean>();
        Map<Id,boolean> controlledDistribution = new Map<Id,Boolean>();
        for(Phoenix_Bid_Line_Item__c lne:bidlines){
            productCodes.add(lne.Phoenix_Product__r.ProductCode);
            controllerSubstance.put(lne.Id,lne.Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Controlled_Substance__c);
            requireColdStorage.put(lne.Id,lne.Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Refrigerated__c);
            controlledDistribution.put(lne.Id,lne.Phoenix_Product__r.Phoenix_Limited_Distribution__c);
        }
        Map<Id,Phoenix_Bid_Line_Item__c> latestBidLinePrices = new Map<Id,Phoenix_Bid_Line_Item__c>();
        // Added by Srimayee Start
        List<Phoenix_Bid_Line_Item__c> latestBid =[SELECT Id,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Product__c from Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Phoenix_Customer__c ='0011K00002RDd48QAD' AND Phoenix_Bid__r.Phoenix_Approval_Status__c != 'Draft' AND Phoenix_Bid__r.Phoenix_Customer_Type__c = 'Direct' AND Phoenix_Bid__r.Phoenix_Bid_Type__c = 'RFP Bids' AND Phoenix_Product__r.ProductCode IN:productCodes  ORDER BY CreatedDate DESC];
        system.debug('latestBid ====='+latestBid.size());
        Map<String,List<Phoenix_Bid_Line_Item__c>> bidLinesMap = new Map<String,List<Phoenix_Bid_Line_Item__c>>();
        
        //Map<String,Phoenix_Bid_Line_Item__c> finalMap = new Map<String,Phoenix_Bid_Line_Item__c>();
        for(Phoenix_Bid_Line_Item__c bidline :  latestBid){
            if(bidLinesMap.containsKey(bidline.Phoenix_Product__c)){
                List<Phoenix_Bid_Line_Item__c> lineList = bidLinesMap.get(bidline.Phoenix_Product__c);
                lineList.add(bidline);
                bidLinesMap.put(bidline.Phoenix_Product__c,lineList);
            }
            else{
                bidLinesMap.put(bidline.Phoenix_Product__c,new List<Phoenix_Bid_Line_Item__c>{bidline});
            }
        }
        system.debug('map===='+bidLinesMap.keySet().size());
        for(String key : bidLinesMap.keySet()){
            system.debug('keyList Size'+bidLinesMap.get(key)[0]);
            if(bidLinesMap.get(key).size() > 0){
                latestBidLinePrices.put(key,bidLinesMap.get(key)[0]);
            }
        }
        // Added by Srimayee end
        system.debug('latestBidLinePrices ' + latestBidLinePrices); 
       
        /* if(latestBid != null && latestBid.size()>0){

List<Phoenix_Bid_Line_Item__c> latestBidLines =[SELECT Id,Phoenix_ProposedContractBidPriceMktng__c, Phoenix_Product__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =:latestBid[0].Id];
for(Phoenix_Bid_Line_Item__c bidLine : latestBidLines){
latestBidLinePrices.put(bidLine.Phoenix_Product__c ,(bidLine));
//.Phoenix_ProposedContractBidPriceMktng__c!=null?bidLine.Phoenix_ProposedContractBidPriceMktng__c:0
}

}*/
        Decimal ctrlSubstPerc =   bidRec.Phoenix_Controlled_Substance__c !=null ?bidRec.Phoenix_Controlled_Substance__c:0;
        Decimal reqColdStrgPerc =   bidRec.Phoenix_Required_Cold_Storage__c !=null ?bidRec.Phoenix_Required_Cold_Storage__c:0;
        Decimal ctrlDistribution =   bidRec.Phoenix_Controlled_Distribution__c !=null ?bidRec.Phoenix_Controlled_Distribution__c:0;
        System.debug('ctrlDistribution-->'+ctrlDistribution);
        Decimal initialOrderDays = bidRec.Phoenix_Initial_Order_Discount_of_Days__c != null? bidRec.Phoenix_Initial_Order_Discount_of_Days__c : 0 ;
        Decimal initialOrderDisc=bidRec.Phoenix_Proposed_Initial_Order_Discount__c != null? bidRec.Phoenix_Proposed_Initial_Order_Discount__c : 0 ;
        Decimal salesOutDays = bidRec.Phoenix_Sales_Out_Promotion_of_Days__c != null? bidRec.Phoenix_Sales_Out_Promotion_of_Days__c : 0 ;
        String bidType= bidRec.Phoenix_Bid_Type__c;
        String ContratsaList = bidRec.Phoenix_Reference_Contracts__c; 
        Decimal RemsFee = bidRec.Phoenix_REMS_Program_Fee__c != null ? bidRec.Phoenix_REMS_Program_Fee__c : 0;
        for (Phoenix_Bid_Line_Item__c blItem: triggerNew) {
            // try{
            if (blItem.Phoenix_Bid_Template_Refrence__c == 'Humana Indirect retail'||blItem.Phoenix_Bid_Template_Refrence__c == 'Humana Indirect CII'){
                system.debug('Humana Called');
                blItem.Phoenix_Override_Total_units__c = (blItem.Phoenix_Override_Current_Indirect_Units__c != null && blItem.Phoenix_Override_Current_Indirect_Units__c > 0) ? blItem.Phoenix_Override_Current_Indirect_Units__c : blItem.Phoenix_Current_Indirect_Selling_Unit__c;
                if (blItem.Phoenix_SCM_Final_Approval__c == true) { 
                    decimal percenalOfQty = 0;
                    Decimal totalOverride = (blItem.Phoenix_Override_Current_Indirect_Units__c != null && blItem.Phoenix_Override_Current_Indirect_Units__c > 0) ? blItem.Phoenix_Override_Current_Indirect_Units__c : (blItem.Phoenix_Current_Indirect_Selling_Unit__c!=null ?blItem.Phoenix_Current_Indirect_Selling_Unit__c:0);
                        Decimal totalProposedUnits = blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c :0;
                    Decimal finalCalcedScmQuantity = ((((totalOverride)/12)+(((blItem.Phoenix_SCM_Approved_Quantity__c!=null?blItem.Phoenix_SCM_Approved_Quantity__c:0)/100)*((totalProposedUnits/12)-((totalOverride)/12))))*12).setScale(0);
                    
                    if (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null && blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null && blItem.Phoenix_Total_SCM_Approved_Qty__c != null && (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c + blItem.Phoenix_Proposed_Direct_Selling_Unit__c) != 0) {
                        percenalOfQty = (finalCalcedScmQuantity / 12) / (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c + blItem.Phoenix_Proposed_Direct_Selling_Unit__c);
                        blItem.Phoenix_Qty_Approved_By_SCM__c = percenalOfQty;
                    } 
                    else if (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null && blItem.Phoenix_Total_SCM_Approved_Qty__c != null && blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != 0) {
                        percenalOfQty = (finalCalcedScmQuantity / 12) / (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c);
                        blItem.Phoenix_Qty_Approved_By_SCM__c = percenalOfQty;
                    } else if (blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null && blItem.Phoenix_Total_SCM_Approved_Qty__c != null && blItem.Phoenix_Proposed_Direct_Selling_Unit__c != 0) {
                        percenalOfQty = (finalCalcedScmQuantity / 12) / (blItem.Phoenix_Proposed_Direct_Selling_Unit__c);
                        blItem.Phoenix_Qty_Approved_By_SCM__c = percenalOfQty;
                    }
                    
                    Decimal finalCurrentSCMUnits = blItem.Phoenix_Override_Current_Direct_Units__c != null ?  blItem.Phoenix_Override_Current_Direct_Units__c : blItem.Phoenix_Current_Direct_Selling_Unit__c != null ? blItem.Phoenix_Current_Direct_Selling_Unit__c : 0; 
                    if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Only Current Monthly Demand Approved') {
                        blItem.Phoenix_SCM_Qty_Approved_Direct__c = finalCurrentSCMUnits;
                    }
                    if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Current + Inc Demand Approved' && blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null) {
                        blItem.Phoenix_SCM_Qty_Approved_Direct__c = blItem.Phoenix_Proposed_Direct_Selling_Unit__c * percenalOfQty * 12;
                    } else if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Current + Inc Demand Approved') {
                        blItem.Phoenix_SCM_Qty_Approved_Direct__c = 0;
                    }
                    if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Only Current Monthly Demand Approved' && blItem.Phoenix_Current_Indirect_Selling_Unit__c != null) {
                        blItem.Phoenix_SCM_Qty_Approved_Indirect__c = blItem.Phoenix_Override_Current_Indirect_Units__c != null ? blItem.Phoenix_Override_Current_Indirect_Units__c :  blItem.Phoenix_Current_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Current_Indirect_Selling_Unit__c  : 0 ;
                    } else if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Only Current Monthly Demand Approved') {blItem.Phoenix_SCM_Qty_Approved_Indirect__c = 0;
                                                                                                                }
                    if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Current + Inc Demand Approved' && blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null) {
                        blItem.Phoenix_SCM_Qty_Approved_Indirect__c = blItem.Phoenix_Proposed_Indirect_Selling_Unit__c * percenalOfQty * 12;
                    } else if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Current + Inc Demand Approved') {
                        blItem.Phoenix_SCM_Qty_Approved_Indirect__c = 0;
                    }
                    if (blItem.Phoenix_SCM_Final_Approval__c == true && (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Only Current Monthly Demand Approved' || blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Current + Inc Demand Approved')) {
                        decimal finalDirectSellingUNitCal = 0, finalIndirectSellingUNitCal = 0;
                        finalDirectSellingUNitCal = blItem.Phoenix_SCM_Qty_Approved_Direct__c;
                        if (blItem.Phoenix_SCM_Qty_Approved_Direct__c != null && finalDirectSellingUNitCal.setScale(0) != 0) {
                            blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = blItem.Phoenix_SCM_Qty_Approved_Direct__c;
                        } else {
                            blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = blItem.Phoenix_Override_Current_Direct_Units__c != null ?  blItem.Phoenix_Override_Current_Direct_Units__c : blItem.Phoenix_Current_Direct_Selling_Unit__c;
                        }
                        finalIndirectSellingUNitCal = blItem.Phoenix_SCM_Qty_Approved_Indirect__c;
                        if (blItem.Phoenix_SCM_Qty_Approved_Indirect__c != null && finalIndirectSellingUNitCal.setScale(0) != 0) {
                            blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = blItem.Phoenix_SCM_Qty_Approved_Indirect__c;
                        } else {
                            blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = blItem.Phoenix_Override_Current_Indirect_Units__c !=null ? blItem.Phoenix_Override_Current_Indirect_Units__c:blItem.Phoenix_Current_Indirect_Selling_Unit__c;
                        }
                        
                    }
                } 
                if (blItem.Phoenix_SCM_Final_Approval__c == false) {
                    blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = blItem.Phoenix_Proposed_Indirect_Selling_Unit__c!=null? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c:blItem.Phoenix_Override_Current_Indirect_Units__c!=null? blItem.Phoenix_Override_Current_Indirect_Units__c:blItem.Phoenix_Current_Indirect_Selling_Unit__c!=null? blItem.Phoenix_Current_Indirect_Selling_Unit__c:0;
                }
                
                //added by Joga
                
                System.debug('latestBidLinePrices==>'+latestBidLinePrices.size());
                System.debug('Phoenix_Bid_Template_Refrence__c==>'+blItem.Phoenix_Bid_Template_Refrence__c);
                System.debug('Phoenix_Bid_Type__c==>'+bidRec.Phoenix_Bid_Type__c);
                if (blItem.Phoenix_Bid_Template_Refrence__c == 'Humana Indirect CII'&& bidRec.Phoenix_Bid_Type__c == 'RFP Bids' && latestBidLinePrices != null && latestBidLinePrices.size()>0){
                    System.debug('checking the proposed price inside if==>'+latestBidLinePrices.get(blItem.Phoenix_Product__c));
                    blItem.Phoenix_ProposedContractBidPriceMktng__c = (latestBidLinePrices.get(blItem.Phoenix_Product__c)!=null ? latestBidLinePrices.get(blItem.Phoenix_Product__c).Phoenix_ProposedContractBidPriceMktng__c:blItem.Phoenix_ProposedContractBidPriceMktng__c);
                    blItem.Latest_Line_Item__c = (latestBidLinePrices.get(blItem.Phoenix_Product__c)!=null ? latestBidLinePrices.get(blItem.Phoenix_Product__c).Id:null);
                }
                
                //Decimal finalApprovedPrice = blItem.Phoenix_Current_Price_Calc__c != null ? blItem.Phoenix_Current_Price_Calc__c : 0;
                
                Decimal finalApprovedPrice = blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != null ? blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c!=null?blItem.Phoenix_ProposedContract_Bid_Price_Sales__c:blItem.Phoenix_Current_Indirect_Price__c!=null?blItem.Phoenix_Current_Indirect_Price__c:0;
                Decimal finalApprovedPriceDirect = blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c!=null?blItem.Phoenix_ProposedContract_Bid_Price_Sales__c:blItem.Phoenix_Current_Direct_Price__c!=null?blItem.Phoenix_Current_Direct_Price__c:0;
                system.debug('current Indirect price handler-->'+blItem.Phoenix_Current_Indirect_Price__c);
                Decimal proposedPerUnitRebate = blItem.Phoenix_Proposed_Per_Unit_Rebate__c != null ? blItem.Phoenix_Proposed_Per_Unit_Rebate__c : blItem.Phoenix_Current_Per_Unit_Rebate__c != null ? blItem.Phoenix_Current_Per_Unit_Rebate__c :0;
                Decimal adminFeeDollar = blItem.Phoenix_Admin_Fee_in__c != null ? blItem.Phoenix_Admin_Fee_in__c :0 ;
                Decimal rebateinDollar = blItem.Phoenix_Rebate_Perc_In__c != null ? blItem.Phoenix_Rebate_Perc_In__c :0 ;
                Decimal vipPerDollar = blItem.Phoenix_VIP_per_unit_in__c != null ? blItem.Phoenix_VIP_per_unit_in__c : 0;
                Decimal cdPerDollar = blItem.Phoenix_INDIRECT_CD__c != null ? blItem.Phoenix_INDIRECT_CD__c : 0;
                // Decimal cmFeeDollar = blItem.Phoenix_CM_Fees_Per_Unit_in__c != null ? blItem.Phoenix_CM_Fees_Per_Unit_in__c : 0;
                Decimal cmFeeDollar = blItem.Phoenix_CM_FEE__c != null ? blItem.Phoenix_CM_FEE__c : 0;
                Decimal RDCFeeDollar = blItem.Phoenix_RDC_NLC_Per_Unit_in__c != null ? blItem.Phoenix_RDC_NLC_Per_Unit_in__c : 0;
                Decimal valueCashTerms = blItem.Phoenix_Value_Cash_Terms__c != null ? blItem.Phoenix_Value_Cash_Terms__c : 0;
                Decimal valueAdminFee = blItem.Phoenix_Value_Admin_Fee__c != null ? blItem.Phoenix_Value_Admin_Fee__c : 0;
                
                
                /* out of scope rems programme filed logc-- */
                if(blItem.Phoenix_REMS__c && ContratsaList != null && (ContratsaList.contains('3000000488') || ContratsaList.contains('3000000769'))){
                    blItem.Phoenix_OS_and_RAD_Date_Fee__c = finalApprovedPrice * (RemsFee/100);
                }else{
                    blItem.Phoenix_OS_and_RAD_Date_Fee__c=0;
                }
                Decimal remsFeePerUnit = blItem.Phoenix_OS_and_RAD_Date_Fee__c != null ? blItem.Phoenix_OS_and_RAD_Date_Fee__c : 0;
                system.debug('finalApprovedPrice---->'+finalApprovedPrice);
                /*Added by satya for Special Handling Charges*/
                //List<Phoenix_Product_Playbook__c> lines = new List<Phoenix_Product_Playbook__c>();
                //lines.addAll(blItem.Phoenix_Product__r.Phoenix_Product_Playbook__r);
                //if(blItem.Phoenix_Product__r.Phoenix_Product_Playbook__r !=null && blItem.Phoenix_Product__r.Phoenix_Product_Playbook__r.size()>0){
                
                /* Boolean isControlledSubstance = controllerSubstance.get(blItem.Id);
System.debug('isControlledSubstance-->'+isControlledSubstance);
Boolean isreqColdStorage = requireColdStorage.get(blItem.Id);
Boolean isCtrlDistribution = controlledDistribution.get(blItem.Id);
Decimal finalPrice = blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c : blItem.Phoenix_Current_Indirect_Price__c != null ? blItem.Phoenix_Current_Indirect_Price__c :0;
System.debug('isCtrlDistribution-->'+isCtrlDistribution);
if(isControlledSubstance && !isreqColdStorage ){
blItem.Controlled_Substance_Distribution_Co__c = (ctrlSubstPerc/100) *finalPrice;
}
if(isreqColdStorage && !isControlledSubstance){
blItem.Controlled_Substance_Distribution_Co__c = (reqColdStrgPerc/100) *finalPrice;
}
if(isControlledSubstance && isreqColdStorage){
Decimal sumOfTwo =  reqColdStrgPerc + ctrlSubstPerc;
blItem.Controlled_Substance_Distribution_Co__c = (sumOfTwo/100) *finalPrice;
}
if(isCtrlDistribution && !isControlledSubstance && !isreqColdStorage ){
blItem.Controlled_Substance_Distribution_Co__c = (ctrlDistribution/100) *finalPrice; 
}
*/
                Decimal contrlDistFee = blItem.Controlled_Substance_Distribution_Co__c != null ? blItem.Controlled_Substance_Distribution_Co__c : 0;
                
                /*End Special Handling Charges*/
                If(blItem.Phoenix_Bid_Template_Refrence__c == 'Humana Indirect retail'){
                    // blItem.Phoenix_Internal_Dead_Net_Price__c = finalApprovedPrice>0?finalApprovedPrice -adminFeeDollar- proposedPerUnitRebate-rebateinDollar-vipPerDollar-cdPerDollar-RDCFeeDollar-cmFeeDollar-remsFeePerUnit - contrlDistFee:0;
                    blItem.Phoenix_Internal_Dead_Net_Price__c = finalApprovedPrice>0?finalApprovedPrice-cdPerDollar-cmFeeDollar:0;
                }
                else if(blItem.Phoenix_Bid_Template_Refrence__c == 'Humana Indirect CII'){
                    blItem.Phoenix_Internal_Dead_Net_Price__c = finalApprovedPriceDirect>0?finalApprovedPriceDirect-cdPerDollar.setScale(4)-cmFeeDollar.setScale(4):0;
                    blItem.Phoenix_Net_Price_afterRebates_after_VIP__c =finalApprovedPrice-finalApprovedPriceDirect;
                }
                system.debug('Internal Dead net -->'+blItem.Phoenix_Internal_Dead_Net_Price__c);
                blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Internal_Dead_Net_Price__c > 0 ? blItem.Phoenix_Internal_Dead_Net_Price__c : 0;
                Decimal finalDirectUnits = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c != null ? blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c : blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c : blItem.Phoenix_Override_Total_units__c != null ? blItem.Phoenix_Override_Total_units__c : 0;
                Decimal estimatedReturns = blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c != null ? blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c : 0;
                Decimal salesPerUnit = blItem.Phoenix_Sales_Out_Promotion_Per_unit_in__c != null ? blItem.Phoenix_Sales_Out_Promotion_Per_unit_in__c :0 ;
                Decimal salesOutOverAmount = (finalDirectUnits/360)*salesPerUnit*salesOutDays;
                blItem.Phoenix_Retail_IOD_overall_amount__c = salesOutOverAmount;
                Decimal iodPerUnitDollar = blItem.Phoenix_IOD_Per_Unit_in__c != null ? blItem.Phoenix_IOD_Per_Unit_in__c : 0;
                blItem.Phoenix_IOD_Total_Amount__c = (finalDirectUnits/360) * iodPerUnitDollar * (bidRec.Phoenix_Initial_Order_Discount_of_Days__c != null ? bidRec.Phoenix_Initial_Order_Discount_of_Days__c : 0);
                
                // blItem.Phoenix_Net_Sales_Internal__c = (blItem.Phoenix_Internal_Dead_Net_Price__c > 0)?(finalDirectUnits * blItem.Phoenix_Internal_Dead_Net_Price__c.setScale(4)) - (estimatedReturns*finalDirectUnits) - salesOutOverAmount - blItem.Phoenix_IOD_Total_Amount__c:0;
                blItem.Phoenix_Net_Sales_Internal__c = (blItem.Phoenix_Internal_Dead_Net_Price__c > 0)?(finalDirectUnits * blItem.Phoenix_Internal_Dead_Net_Price__c.setScale(4)) - (estimatedReturns*finalDirectUnits):0;
                
                system.debug('salesOutOverAmount---'+salesOutOverAmount);
                system.debug('finalDirectUnits---'+finalDirectUnits);
                system.debug('DeadNet---'+blItem.Phoenix_Internal_Dead_Net_Price__c);
                system.debug('NetSales---'+blItem.Phoenix_Net_Sales_Internal__c);
                blItem.Phoenix_Net_Sales_Internal__c = blItem.Phoenix_Net_Sales_Internal__c.setScale(0);
                Decimal thPutCost = blItem.Phoenix_Throughput_cost__c != null ? blItem.Phoenix_Throughput_cost__c : 0;
                blItem.Proposed_TPT_Direct__c = (blItem.Phoenix_Internal_Dead_Net_Price__c > 0) ? blItem.Phoenix_Internal_Dead_Net_Price__c.setScale(4) - thPutCost : 0 ;
                blItem.Proposed_TPT_Per_Direct__c = (blItem.Phoenix_Internal_Dead_Net_Price__c > 0) ? (blItem.Proposed_TPT_Direct__c/blItem.Phoenix_Internal_Dead_Net_Price__c)*100:0;
                
                // reduction.
                if (blItem.Phoenix_Current_Indirect_Price__c > 0) {
                    blItem.Phoenix_Reduction__c = ((finalApprovedPrice / blItem.Phoenix_Current_Indirect_Price__c) - 1) * 100;
                }
                
                // SSA Hit Calculation 
                Decimal finalIndirectUnits = (blItem.Phoenix_Override_Current_Indirect_Units__c != null && blItem.Phoenix_Override_Current_Indirect_Units__c > 0) ? blItem.Phoenix_Override_Current_Indirect_Units__c : (blItem.Phoenix_Current_Indirect_Selling_Unit__c!=null ?blItem.Phoenix_Current_Indirect_Selling_Unit__c:0);
                    Decimal DiffPrice = (blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c :0) - (blItem.Phoenix_Current_Indirect_Price__c!= null ? blItem.Phoenix_Current_Indirect_Price__c : 0);
                Decimal SSANoofDays = (bidRec.Phoenix_Proposed_SSA_No_of_Days__c != null ? bidRec.Phoenix_Proposed_SSA_No_of_Days__c :0)/30;
                blItem.Phoenix_SSA_Hit_Updated__c = DiffPrice * SSANoofDays * (finalIndirectUnits/12);
                
                //Price and Volume Variance calculations 
                
                Decimal currentIndirUnits = finalIndirectUnits;
                Decimal ProposedIndirectUnis = (blItem.Phoenix_SCM_Final_Approval__c == true ? finalDirectUnits : (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c:0))-currentIndirUnits;
                
                Decimal indirectDedadnet = (blItem.Phoenix_Internal_Dead_Net_Price__c != null ? blItem.Phoenix_Internal_Dead_Net_Price__c : 0)-(blItem.Phoenix_Current_ASP_Dose__c!=null?blItem.Phoenix_Current_ASP_Dose__c:0);
                
                Decimal priceVarianceIndir = indirectDedadnet *currentIndirUnits;
                
                Decimal volumeVarianceIndir = indirectDedadnet*ProposedIndirectUnis;
                
                blItem.Phoenix_Price_Variance__c = (bidType == 'Sales Out Rebate' || bidType == 'RFP Bids' || bidType == 'Price Change' || bidType == 'Customer Rebate Change') ? ( priceVarianceIndir):0;
                blItem.Phoenix_Volume_Variance__c = (bidType == 'Sales Out Rebate' || bidType == 'Price Change' || bidType == 'Customer Rebate Change') ? 0 : ( volumeVarianceIndir) ;      
                    
                    /*if ((blItem.Phoenix_Gross_Contract_Sales__c > 0) && (blItem.Phoenix_Gross_Contract_Sales__c != null) && (blItem.Phoenix_Value_Rebate__c != null) && (blItem.Phoenix_Value_Per_Unit_Rebate__c != null) && (blItem.Phoenix_Value_Admin_Fee__c != null) && (blItem.Phoenix_Value_Est_VIP__c != null) && (blItem.Phoenix_Sales_Out_Promotion__c != null) && (blItem.Phoenix_Initial_Order_Discount__c != null) && (blItem.Phoenix_Estimated_Medicaid_Returns1__c != null) && (blItem.Phoenix_Contr_Management_Fee_Wholesaler__c != null) && (blItem.Phoenix_Value_Cash_Terms__c != null) && (blItem.Phoenix_Value_RDC_NLC__c != null)) {
blItem.Phoenix_Net_Sales_Internal__c = blItem.Phoenix_Gross_Contract_Sales__c - blItem.Phoenix_Value_Rebate__c - blItem.Phoenix_Value_Per_Unit_Rebate__c - blItem.Phoenix_Value_Admin_Fee__c - blItem.Phoenix_Value_Est_VIP__c - blItem.Phoenix_Sales_Out_Promotion__c - blItem.Phoenix_Initial_Order_Discount__c - blItem.Phoenix_Contr_Management_Fee_Wholesaler__c - blItem.Phoenix_Value_Cash_Terms__c - blItem.Phoenix_Value_RDC_NLC__c - blItem.Phoenix_Estimated_Medicaid_Returns1__c;
blItem.Phoenix_Net_Sales_Internal__c = blItem.Phoenix_Net_Sales_Internal__c.setscale(0);
}*/
                    Decimal finalIndirectPrice = blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c : 0;
                Decimal finalCurIndirPrice = blItem.Phoenix_Current_Indirect_Price__c != null ? blItem.Phoenix_Current_Indirect_Price__c : 0;
                blItem.Phoenix_Reduction_in_NCP_WMT__c = finalCurIndirPrice > 0 ? ((finalIndirectPrice/finalCurIndirPrice)-1)*100 : 0;
                blItem.Phoenix_Proposed_Sales__c =  blItem.Phoenix_Net_Sales_Internal__c;
                //new code for New Product Launch Calc
                Decimal InternalDeadNet = blItem.Phoenix_Internal_Dead_Net_Price__c >0 ? blItem.Phoenix_Internal_Dead_Net_Price__c : 0;   
                Decimal brandwac =( blItem.Brand_WAC__c != null && blItem.Brand_WAC__c !=0)?blItem.Brand_WAC__c:0;
                blItem.Phoenix_Brand_WAC_Per__c = brandwac != 0 ? (InternalDeadNet / brandwac)*100 : 0;
                Decimal openingorder = (blItem.Phoenix_Opening_Order__c != null && blItem.Phoenix_Opening_Order__c != 0)?blItem.Phoenix_Opening_Order__c :0;
                blItem.Phoenix_Opening_Order_Net_sales__c = (InternalDeadNet > 0 && openingorder > 0) ? (openingorder * InternalDeadNet) - (openingorder * estimatedReturns)-(blItem.Phoenix_IOD_Total_Amount__c!=null ? blItem.Phoenix_IOD_Total_Amount__c:0):0;
                Decimal openingOrdernetsales = (blItem.Phoenix_Opening_Order_Net_sales__c != null && blItem.Phoenix_Opening_Order_Net_sales__c != 0) ? blItem.Phoenix_Opening_Order_Net_sales__c : 0;
                Decimal throughputcost1 = (blItem.Phoenix_Throughput_Cost1__c != null && blItem.Phoenix_Throughput_Cost1__c != 0)? blItem.Phoenix_Throughput_Cost1__c:0;
                blItem.Phoenix_Opening_Order_TPT__c = (InternalDeadNet > 0 && openingorder > 0) ?  openingOrdernetsales - (openingorder * throughputcost1) : 0;
                Decimal openingordertptdl = (blItem.Phoenix_Opening_Order_TPT__c != null &&  blItem.Phoenix_Opening_Order_TPT__c != 0) ?blItem.Phoenix_Opening_Order_TPT__c :0 ;
                blItem.Phoenix_Opening_Order_TPT_Per__c = openingOrdernetsales !=0 ? (openingordertptdl / openingOrdernetsales)*100 :0 ;
                Phoenix_Util.blnAlreadyDone =true;
                
                //FOR Current Sales && NDC Finance View
                //Phoenix_DeadNet_TrckGR__c  indirectDedadnet
                Decimal finalCurrentUnits = (blItem.Phoenix_Override_Current_Indirect_Units__c >0)? blItem.Phoenix_Override_Current_Indirect_Units__c : ((blItem.Phoenix_Current_Indirect_Selling_Unit__c > 0) ? blItem.Phoenix_Current_Indirect_Selling_Unit__c:0);
                    blItem.Finance_Current_Sales__c = (finalCurrentUnits * (blItem.Phoenix_DeadNet_TrckGR__c != NULL ? blItem.Phoenix_DeadNet_TrckGR__c : 0) )-(estimatedReturns * finalCurrentUnits);
                
            }
            //}
            //Catch(Exception e) {
            //    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_BidLineItemTrigger', Phoenix_Method_Name__c = '', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            ////    insert exp;
            // }
        }
    }
    
}