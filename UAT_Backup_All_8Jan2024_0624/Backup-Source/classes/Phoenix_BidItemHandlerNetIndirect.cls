public class Phoenix_BidItemHandlerNetIndirect extends TriggerHandler {
    private list < Phoenix_Bid_Line_Item__c > triggerNew;
    private list < Phoenix_Bid_Line_Item__c > triggerOld;
    private Map < Id, Phoenix_Bid_Line_Item__c > newMap;
    private Map < Id, Phoenix_Bid_Line_Item__c > oldMap;
    
    public Phoenix_BidItemHandlerNetIndirect() {
        this.newMap = (Map < Id, Phoenix_Bid_Line_Item__c > ) Trigger.newMap;
        this.oldMap = (Map < Id, Phoenix_Bid_Line_Item__c > ) Trigger.oldMap;
        this.triggerNew = (List < Phoenix_Bid_Line_Item__c > ) Trigger.new;
        this.triggerOld = (List < Phoenix_Bid_Line_Item__c > ) Trigger.old;
    }
    
    public override void beforeInsert() {
        doTheCalcs();
    }
    
    public override void beforeUpdate() {
        doTheCalcs();
    }
    
    public override void afterUpdate() {}
    
    
    private void doTheCalcs(){
        Phoenix_Bid__c bidRec = [SELECT Id,Phoenix_Customer_Type__c, Phoenix_Customer__r.Phoenix_Rebates__c,Phoenix_Customer__r.Phoenix_Cash_Discount__c ,
                                 Phoenix_Customer__r.Phoenix_Fee__c,Phoenix_Customer__r.Phoenix_CM_Fees__c,Phoenix_Bid_Proposed_Position__c, 
                                 Phoenix_Approval_Status__c,Phoenix_Proposed_Cash_Terms__c,Phoenix_Initial_Order_Discount_Type__c, Phoenix_Custom_type__c, 
                                 Phoenix_Current_CD__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Initial_Order_Discount_of_Days__c, 
                                 Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Bid_Type__c,Phoenix_Proposed_SSA_No_of_Days__c 
                                 FROM Phoenix_Bid__c 
                                 WHERE Id =: triggerNew[0].Phoenix_Bid__c];
        
        Decimal initialOrderDays = bidRec.Phoenix_Initial_Order_Discount_of_Days__c != null? bidRec.Phoenix_Initial_Order_Discount_of_Days__c : 0 ;
        String bidType = bidRec.Phoenix_Bid_Type__c;
        Decimal initialOrderDisc=bidRec.Phoenix_Proposed_Initial_Order_Discount__c != null? bidRec.Phoenix_Proposed_Initial_Order_Discount__c : 0 ;
        for (Phoenix_Bid_Line_Item__c blItem: triggerNew) {
            if (blItem.Phoenix_Bid_Template_Refrence__c == 'Net Indirect Pricing') {
                try {
                    Decimal currentIndirectUnits = blItem.Phoenix_Current_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Current_Indirect_Selling_Unit__c : 0;
                    Decimal currentDirectUnits = blItem.Phoenix_Current_Direct_Selling_Unit__c != null ? blItem.Phoenix_Current_Direct_Selling_Unit__c : 0;
                    Decimal currentTotalUnits = currentDirectUnits + currentIndirectUnits;
                    
                    Decimal OverrideDirectUnits = blItem.Phoenix_Override_Current_Direct_Units__c != null ? blItem.Phoenix_Override_Current_Direct_Units__c : 0;
                    Decimal OverrideIndirectUnits = blItem.Phoenix_Override_Current_Indirect_Units__c != null ? blItem.Phoenix_Override_Current_Indirect_Units__c : 0;
                    Decimal overrideTotalUnits = OverrideDirectUnits + OverrideIndirectUnits;
                    
                    Decimal totalCurrentUnits = overrideTotalUnits != 0 ? overrideTotalUnits : currentTotalUnits;

                    Decimal proposedDirectUnits = blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null ? blItem.Phoenix_Proposed_Direct_Selling_Unit__c : 0;
                    Decimal proposedIndirectUnits = blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c : 0;
                    Decimal proposedTotalUnits = proposedDirectUnits + proposedIndirectUnits;
                    
                    Decimal totalUnits = proposedTotalUnits !=0 ? proposedTotalUnits : totalCurrentUnits;
                    
                    Decimal IOdPerUnit = blItem.Phoenix_IOD_Per_Unit_in__c != null ? blItem.Phoenix_IOD_Per_Unit_in__c : 0;
                    Decimal cdPerUnit = blItem.Phoenix_Customer_Cash_Discount1__c != null ? blItem.Phoenix_Customer_Cash_Discount1__c : 0;
                    Decimal directCDperUnit = blItem.Phoenix_Direct_CD_Per_Unit__c != null ? blItem.Phoenix_Direct_CD_Per_Unit__c : 0;
                    Decimal indirectCdperUnit = blItem.Phoenix_INDIRECT_CD__c != null ? blItem.Phoenix_INDIRECT_CD__c : 0;
                    Decimal last12MonthsDirect = blItem.Phoenix_12_Months_Actual_Sales__c != null ? blItem.Phoenix_12_Months_Actual_Sales__c : 0;
                    Decimal last12monthsIndirect = blItem.Phoenix_12_Months_IndirectSaleUnit__c != null ? blItem.Phoenix_12_Months_IndirectSaleUnit__c : 0;
                    Decimal proposedDirectPriceMkt = blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c : 0;
                    Decimal propIndirectPriceMKt = blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != null ? blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c : 0;
                    Decimal currentPUR = blItem.Phoenix_Current_Per_Unit_Rebate__c != null ? blItem.Phoenix_Current_Per_Unit_Rebate__c : 0;
                    
                    Decimal curDirPrice = blItem.Phoenix_Current_Direct_Price__c != null ? blItem.Phoenix_Current_Direct_Price__c : 0;
                    Decimal curIndirPrice = blItem.Phoenix_Current_Indirect_Price__c != null ? blItem.Phoenix_Current_Indirect_Price__c : 0;
                    Decimal estMedi = blItem.Phoenix_Estimated_Medicaid_Returns__c != null ? blItem.Phoenix_Estimated_Medicaid_Returns__c : 0;
                    Decimal salesPrice = blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c : 0;
                    
                    Decimal currentNetIndirectPrice = curIndirPrice != 0 ? curIndirPrice - currentPUR : 0;
                    blItem.Phoenix_Current_Net_Indirect_Price__c = currentNetIndirectPrice;
                    
                    Decimal wholeDiffPrIndirect = propIndirectPriceMKt != 0?
                        propIndirectPriceMKt : salesPrice != 0 ? 
                            salesPrice : curIndirPrice != 0 ? 
                                curIndirPrice : 0;
                    Decimal CMFee = blItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c != null ? blItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c : 0;
                    Decimal contractMngmtWhole = wholeDiffPrIndirect * CMFee / 100;
                    Decimal currentPriceCalc = proposedDirectPriceMkt != 0?
                        proposedDirectPriceMkt : salesPrice != 0 ? 
                            salesPrice : curDirPrice != 0 ? 
                                curDirPrice : 0;//blItem.Phoenix_Current_Price_Calc__c;
                    blItem.Phoenix_Contract_Mngmnt_Fee_Wholesaler__c = contractMngmtWhole != 0 ? contractMngmtWhole : 0;
                    blItem.Phoenix_12_Months_TotalSaleUnits__c = last12MonthsDirect + last12monthsIndirect;
                    blItem.Phoenix_Override_Total_units__c = OverrideDirectUnits + OverrideIndirectUnits;
                    Decimal finalDirectUnits = 0; 
                    Decimal finalIndirectUnits = 0;
                    if (blItem.Phoenix_SCM_Final_Approval__c == true) {
                        if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Only Current Monthly Demand Approved') {
                            blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = OverrideDirectUnits != 0 ? OverrideDirectUnits : currentDirectUnits;
                            blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = OverrideIndirectUnits != 0 ? OverrideIndirectUnits : currentIndirectUnits;
                        }
                        else if(blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Current + Inc Demand Approved'){
                            Decimal finalCalcedScmQuantity = ((totalCurrentUnits/12)+((blItem.Phoenix_SCM_Approved_Quantity__c/100)*((proposedTotalUnits/12)-(totalCurrentUnits/12))))*12;
                            blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = totalUnits != 0 ? ((proposedDirectUnits / totalUnits) * finalCalcedScmQuantity) : 0;
                            blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = totalUnits != 0 ? ((proposedIndirectUnits / totalUnits) * finalCalcedScmQuantity) : 0;
                        }
                    } else if(proposedTotalUnits>0){
                        blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = proposedDirectUnits;
                        blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = proposedIndirectUnits;
                    } else if(overrideTotalUnits>0){
                        blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = OverrideDirectUnits;
                        blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = OverrideIndirectUnits;
                    } else{
                        blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = currentDirectUnits;
                        blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = currentIndirectUnits;
                    }
                    finalDirectUnits = blItem.Phoenix_Final_Direct_Selling_Units_Calc__c;
                    finalIndirectUnits = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                        
                    /*if (blItem.Phoenix_SCM_Final_Approval__c == true) {
                        
                    } else {
                        blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != 0 && blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null) ?
                            blItem.Phoenix_Proposed_Indirect_Selling_Unit__c : (finalIndirectUnits != 0) ?
                                finalIndirectUnits : (blItem.Phoenix_Override_Current_Indirect_Units__c != null && blItem.Phoenix_Override_Current_Indirect_Units__c != 0) ?
                                    blItem.Phoenix_Override_Current_Indirect_Units__c : blItem.Phoenix_Current_Indirect_Selling_Unit__c != null ?
                                        blItem.Phoenix_Current_Indirect_Selling_Unit__c : 0;
                        finalIndirectUnits = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                    }*/
                    if (curDirPrice > 0)
                        blItem.Phoenix_Reduction__c = ((currentPriceCalc / curDirPrice) - 1) * 100;
                    
                    Decimal custDeadNet = 0.0; //proposedContractBidPriceMrk + contractMngmtWhole + indirectCdperUnit - directCDperUnit;
                    
                    if (bidRec.Phoenix_Custom_type__c == 'Custom Type 1') {
                        //Direct price + (Cash Discount WAC - Cash Discount Direct) + (Indirect price * Wholesaler Contract Management Fee)
                        custDeadNet = currentPriceCalc + (indirectCdperUnit - directCDperUnit) + (wholeDiffPrIndirect * (CMFee / 100));
                    } else if (bidRec.Phoenix_Custom_type__c == 'Custom Type 2') {
                        custDeadNet = currentPriceCalc + (wholeDiffPrIndirect * (CMFee / 100));
                    }
                    
                    blItem.Phoenix_Customer_Dead_Net1__c = custDeadNet;
                    Decimal PUR = (wholeDiffPrIndirect > 0 && wholeDiffPrIndirect > custDeadNet) ? wholeDiffPrIndirect - custDeadNet : 0;
                    Decimal whlsrControlSubFee = blItem.Phoenix_Whlsr_Controlled_Substance_Fee__c != null ? blItem.Phoenix_Whlsr_Controlled_Substance_Fee__c : 0;
                    //if(proposedDirectPriceMkt == 0 && propIndirectPriceMKt == 0){
                      //  PUR = 0;
                    //}
                    if(PUR < 0 || PUR == 0){
                        blItem.Phoenix_Proposed_Per_Unit_Rebate__c = 0; 
                        blItem.Phoenix_Direct_Dead_Net__c = 0;
                        blItem.Phoenix_Indirect_Dead_Net__c = 0;
                        blItem.Phoenix_Internal_Dead_Net_Price__c = 0;//making deadnet 0 if pur is -ve
                    }
                    else{
                        blItem.Phoenix_Proposed_Per_Unit_Rebate__c = PUR;
                        blItem.Phoenix_Direct_Dead_Net__c = ( currentPriceCalc > 0 && currentPriceCalc > directCDperUnit ) ? (currentPriceCalc - directCDperUnit).setscale(4) : 0;
                        blItem.Phoenix_Indirect_Dead_Net__c = custDeadNet > 0 ? (custDeadNet - indirectCdperUnit - contractMngmtWhole - whlsrControlSubFee).setscale(4) : 0;
                    }
                    blItem.Phoenix_Wholesaler_IOD_per_unit__c = (initialOrderDisc / 100) * currentPriceCalc;
                    // blItem.Phoenix_IOD_Total_Amount__c = ((finalDirectUnits/360)*IOdPerUnit)*(initialOrderDays != null ? initialOrderDays : 0) ;
                    blItem.Phoenix_IOD_Total_Amount__c = ((finalDirectUnits / 360) * blItem.Phoenix_Wholesaler_IOD_per_unit__c) * (initialOrderDays != null ? initialOrderDays : 0);
                    blItem.Proposed_Net_Sales_Direct__c = blItem.Phoenix_Direct_Dead_Net__c > 0 ? ((blItem.Phoenix_Direct_Dead_Net__c * finalDirectUnits) - blItem.Phoenix_IOD_Total_Amount__c - (estMedi * finalDirectUnits)) : 0;
                    blItem.Proposed_Net_Sales_Indirect__c = blItem.Phoenix_Indirect_Dead_Net__c > 0 ? ((blItem.Phoenix_Indirect_Dead_Net__c * finalIndirectUnits) - (estMedi * finalIndirectUnits)) : 0;
                    
                    
                    blItem.Phoenix_Net_Sales_Internal__c = blItem.Proposed_Net_Sales_Direct__c + blItem.Proposed_Net_Sales_Indirect__c;
                    if (finalDirectUnits + finalIndirectUnits != 0) {
                        blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Net_Sales_Internal__c / (finalDirectUnits + finalIndirectUnits);
                    }
                    else
                        blItem.Phoenix_Internal_Dead_Net_Price__c = 0;
                    blItem.Proposed_TPT_Direct__c = blItem.Proposed_Net_Sales_Direct__c >0 ? blItem.Proposed_Net_Sales_Direct__c - (blItem.Phoenix_Throughput_cost__c * finalDirectUnits) : 0;
                    blItem.Proposed_TPT_Indirect__c = blItem.Proposed_Net_Sales_Indirect__c > 0 ? blItem.Proposed_Net_Sales_Indirect__c - (blItem.Phoenix_Throughput_cost__c * finalIndirectUnits) : 0;
                    if (blItem.Proposed_Net_Sales_Direct__c > 0)
                        blItem.Proposed_TPT_Per_Direct__c = (blItem.Proposed_TPT_Direct__c / blItem.Proposed_Net_Sales_Direct__c) * 100;
                    else
                        blItem.Proposed_TPT_Per_Direct__c = 0;
                    if (blItem.Proposed_Net_Sales_Indirect__c > 0)
                        blItem.Proposed_TPT_Per_Indirect__c = blItem.Proposed_Net_Sales_Indirect__c > 0 ? (blItem.Proposed_TPT_Indirect__c / blItem.Proposed_Net_Sales_Indirect__c) * 100 : 0;
                    else
                        blItem.Proposed_TPT_Per_Indirect__c = 0;
                    
                    
                    //  price and volume variance calculation---- added by Jogarao
                    Decimal diffinVolumeDir = ((blItem.Phoenix_SCM_Final_Approval__c == true ? finalDirectUnits : proposedDirectUnits) - ((OverrideDirectUnits > 0 || overrideTotalUnits>0) ? OverrideDirectUnits : currentDirectUnits)) ;
                    Decimal diffinVolumeIndir = ((blItem.Phoenix_SCM_Final_Approval__c == true ? finalIndirectUnits : proposedIndirectUnits) - ((OverrideIndirectUnits > 0 || overrideTotalUnits>0) ? OverrideIndirectUnits : currentIndirectUnits)) ;
                    
                    Decimal diffinPriceDir = (blItem.Phoenix_Direct_Dead_Net__c !=null ? blItem.Phoenix_Direct_Dead_Net__c :0) - (blItem.Phoenix_DeadNet_TrckGR__c != null ? blItem.Phoenix_DeadNet_TrckGR__c :0);
                    Decimal diffinPriceIndir = (blItem.Phoenix_Indirect_Dead_Net__c !=null ? blItem.Phoenix_Indirect_Dead_Net__c :0) - (blItem.Phoenix_DeadNet_TrckGR__c != null ? blItem.Phoenix_DeadNet_TrckGR__c :0);
                    
                    Decimal priceVarianceDir =  diffinPriceDir*((OverrideDirectUnits > 0 || overrideTotalUnits > 0) ? OverrideDirectUnits : currentDirectUnits) ;
                    Decimal priceVarianceIndir =  diffinPriceIndir*((OverrideIndirectUnits > 0 || overrideTotalUnits>0) ? OverrideIndirectUnits : currentIndirectUnits) ;
                    
                    Decimal volumeVarianceDir = diffinVolumeDir * diffinPriceDir;
                    Decimal volumeVarianceIndir = diffinPriceIndir * diffinVolumeIndir;
                    
                    blItem.Phoenix_Price_Variance__c = (bidType == 'Sales Out Rebate' || bidType == 'RFP Bids' || bidType == 'Price Change' || bidType == 'Customer Rebate Change') ? (priceVarianceDir + priceVarianceIndir):0;
                    blItem.Phoenix_Volume_Variance__c = (bidType == 'Sales Out Rebate' || bidType == 'Price Change' || bidType == 'Customer Rebate Change') ? 0 : (volumeVarianceDir + volumeVarianceIndir) ;  
                    
                   // added by Jogarao
                   blItem.Phoenix_Proposed_Sales__c = (blItem.Proposed_Net_Sales_Direct__c != null ? blItem.Proposed_Net_Sales_Direct__c : 0)+ (blItem.Proposed_Net_Sales_Indirect__c != null ? blItem.Proposed_Net_Sales_Indirect__c : 0); 
                   // SSA Hit Calculation 
                    Decimal DiffPrice = (blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c :0) - (blItem.Phoenix_Current_Direct_Price__c!= null ? blItem.Phoenix_Current_Direct_Price__c : 0);
                    Decimal SSANoofDays = (bidRec.Phoenix_Proposed_SSA_No_of_Days__c != null ? bidRec.Phoenix_Proposed_SSA_No_of_Days__c :0)/30;
                    blItem.Phoenix_SSA_Hit_Updated__c = DiffPrice * SSANoofDays * (((OverrideDirectUnits > 0 || overrideTotalUnits > 0) ? OverrideDirectUnits : currentDirectUnits)/12); 
                        
                    /* New Product Launch*/
                    Decimal deadnet = blItem.Phoenix_Direct_Dead_Net__c !=null ? blItem.Phoenix_Direct_Dead_Net__c :0;
                    Decimal estimadeMedicaidreturns = blItem.Phoenix_Estimated_Medicaid_Returns__c != null ? blItem.Phoenix_Estimated_Medicaid_Returns__c : 0;
                    Decimal brandwac =( blItem.Brand_WAC__c != null && blItem.Brand_WAC__c !=0)?blItem.Brand_WAC__c:0;
                    blItem.Phoenix_Brand_WAC_Per__c = (brandwac != 0 && brandwac != null) ? (deadnet / brandwac)*100 : 0;
                    Decimal openingorder = (blItem.Phoenix_Opening_Order__c != null && blItem.Phoenix_Opening_Order__c != 0)?blItem.Phoenix_Opening_Order__c :0;
                   	Decimal iodTotal = blItem.Phoenix_IOD_Total_Amount__c != null ? blItem.Phoenix_IOD_Total_Amount__c :0;
                    blItem.Phoenix_Opening_Order_Net_sales__c = (openingorder >0 && deadnet > 0) ? (openingorder * deadnet) - iodTotal - (openingorder * estimadeMedicaidreturns) : 0;
                    Decimal openingOrdernetsales = blItem.Phoenix_Opening_Order_Net_sales__c != null ? blItem.Phoenix_Opening_Order_Net_sales__c : 0;
                    Decimal throughputcost = blItem.Phoenix_Throughput_Cost1__c != null? blItem.Phoenix_Throughput_Cost1__c:0;
                    blItem.Phoenix_Opening_Order_TPT__c = (openingorder >0 && deadnet > 0 && openingOrdernetsales >0) ? openingOrdernetsales - (openingorder * throughputcost) : 0;
                    Decimal openingordertptdl = (blItem.Phoenix_Opening_Order_TPT__c != null &&  blItem.Phoenix_Opening_Order_TPT__c != 0) ?blItem.Phoenix_Opening_Order_TPT__c :0 ;
                    blItem.Phoenix_Opening_Order_TPT_Per__c = (openingorder >0 && deadnet > 0 && openingOrdernetsales >0) ? (openingordertptdl / openingOrdernetsales)*100 :0 ;
                    /* END New Product Launch*/
                  //  Decimal currentCVSDirectSales = ((blItem.Current_CVS_DeadNet__c != null ? blItem.Current_CVS_DeadNet__c: 0) * (OverrideDirectUnits> 0 ? OverrideDirectUnits:currentDirectUnits) - (OverrideDirectUnits> 0 ? OverrideDirectUnits:currentDirectUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c);
                  //  Decimal currentCVSIndirectSales = ((blItem.Current_CVS_Indirect_DeadNet__c != null ? blItem.Current_CVS_Indirect_DeadNet__c: 0) * (OverrideIndirectUnits> 0 ? OverrideIndirectUnits:currentIndirectUnits) - (OverrideIndirectUnits> 0 ? OverrideIndirectUnits:currentIndirectUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c);
                    Decimal currentCVSDirectSales = (blItem.Current_CVS_DeadNet__c != null ? (blItem.Current_CVS_DeadNet__c  * (OverrideDirectUnits> 0 ? OverrideDirectUnits:currentDirectUnits) - (OverrideDirectUnits> 0 ? OverrideDirectUnits:currentDirectUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c): 0);
                    Decimal currentCVSIndirectSales = (blItem.Current_CVS_Indirect_DeadNet__c != null ? (blItem.Current_CVS_Indirect_DeadNet__c  * (OverrideIndirectUnits> 0 ? OverrideIndirectUnits:currentIndirectUnits) - (OverrideIndirectUnits> 0 ? OverrideIndirectUnits:currentIndirectUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c): 0);
                    blItem.Finance_Current_Sales__c = currentCVSDirectSales+currentCVSIndirectSales;
                }
                Catch(Exception e) {
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_BidLineItemTrigger', Phoenix_Method_Name__c = '', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                    insert exp;
                }
            }
        }
    }
}