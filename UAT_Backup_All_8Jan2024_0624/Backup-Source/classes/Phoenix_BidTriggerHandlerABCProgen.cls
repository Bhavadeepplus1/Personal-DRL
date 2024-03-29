public class Phoenix_BidTriggerHandlerABCProgen extends TriggerHandler{
    private list < Phoenix_Bid_Line_Item__c > triggerNew;
    private list < Phoenix_Bid_Line_Item__c > triggerOld;
    private Map < Id, Phoenix_Bid_Line_Item__c > newMap;
    private Map < Id, Phoenix_Bid_Line_Item__c > oldMap;
    
    public Phoenix_BidTriggerHandlerABCProgen() {
        this.newMap = (Map < Id, Phoenix_Bid_Line_Item__c > ) Trigger.newMap;
        this.oldMap = (Map < Id, Phoenix_Bid_Line_Item__c > ) Trigger.oldMap;
        this.triggerNew = (List < Phoenix_Bid_Line_Item__c > ) Trigger.new;
        this.triggerOld = (List < Phoenix_Bid_Line_Item__c > ) Trigger.old;
    }
    public override void beforeInsert() {
        beforeUpdate();
    }
    public override void beforeUpdate() {
        Phoenix_Bid__c bidRec = [SELECT Id,Phoenix_Customer_Type__c, Phoenix_Customer__r.Phoenix_Rebates__c,Phoenix_Customer__r.Phoenix_Cash_Discount__c ,
                                 Phoenix_Customer__r.Phoenix_Fee__c,Phoenix_Customer__r.Phoenix_CM_Fees__c,Phoenix_Bid_Proposed_Position__c, 
                                 Phoenix_Approval_Status__c,Phoenix_Proposed_Cash_Terms__c,Phoenix_Initial_Order_Discount_Type__c, Phoenix_Custom_type__c, 
                                 Phoenix_Current_CD__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Initial_Order_Discount_of_Days__c, 
                                 Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Bid_Type__c,Phoenix_Proposed_SSA_No_of_Days__c 
                                 FROM Phoenix_Bid__c 
                                 WHERE Id =: triggerNew[0].Phoenix_Bid__c];
        Decimal initialOrderDays = bidRec.Phoenix_Initial_Order_Discount_of_Days__c != null? bidRec.Phoenix_Initial_Order_Discount_of_Days__c : 0 ;
        Decimal initialOrderDisc=bidRec.Phoenix_Proposed_Initial_Order_Discount__c != null? bidRec.Phoenix_Proposed_Initial_Order_Discount__c : 0 ;
        String bidType = bidRec.Phoenix_Bid_Type__c;
        for (Phoenix_Bid_Line_Item__c blItem: triggerNew) {
            try{
                if (blItem.Phoenix_Bid_Template_Refrence__c == 'ABC Progen'){
                    if (blItem.Phoenix_SCM_Final_Approval__c == true) { 
                        decimal percenalOfQty = 0;
                        Decimal totalOverride = (blItem.Phoenix_Override_Current_Indirect_Units__c != null && blItem.Phoenix_Override_Current_Indirect_Units__c > 0) ? blItem.Phoenix_Override_Current_Indirect_Units__c : (blItem.Phoenix_Current_Indirect_Selling_Unit__c!=null ?blItem.Phoenix_Current_Indirect_Selling_Unit__c:0);
                        Decimal totalProposedUnits = blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c :0;
                        Decimal finalCalcedScmQuantity = ((((totalOverride)/12)+(((blItem.Phoenix_SCM_Approved_Quantity__c!=null?blItem.Phoenix_SCM_Approved_Quantity__c:0)/100)*((totalProposedUnits/12)-((totalOverride)/12))))*12).setScale(0);
                        if (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null && blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null && blItem.Phoenix_Total_SCM_Approved_Qty__c != null && (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c + blItem.Phoenix_Proposed_Direct_Selling_Unit__c) != 0) {
                            percenalOfQty = (finalCalcedScmQuantity/ 12) / (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c + blItem.Phoenix_Proposed_Direct_Selling_Unit__c);
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
                                blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = blItem.Phoenix_Current_Direct_Selling_Unit__c;
                            }
                            finalIndirectSellingUNitCal = blItem.Phoenix_SCM_Qty_Approved_Indirect__c;
                            if (blItem.Phoenix_SCM_Qty_Approved_Indirect__c != null && finalIndirectSellingUNitCal.setScale(0) != 0) {
                                blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = blItem.Phoenix_SCM_Qty_Approved_Indirect__c;
                            } else {
                                blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = blItem.Phoenix_Current_Indirect_Selling_Unit__c;
                            }
                            
                        }
                } 
                    Decimal ApprovalPricingContracts = (blItem.Phoenix_Final_Approvd_Pricing_Contracts__c != null && blItem.Phoenix_Final_Approvd_Pricing_Contracts__c != 0) ? blItem.Phoenix_Final_Approvd_Pricing_Contracts__c : blItem.Phoenix_Current_Indirect_Price__c != null ? blItem.Phoenix_Current_Indirect_Price__c : 0;
                        Decimal adminFee = blItem.Phoenix_Customer_Fees__c != null ? blItem.Phoenix_Customer_Fees__c : 0;
                        Decimal vipPerUnit = blItem.Phoenix_Local_VIP_Per_Unit__c != null ? blItem.Phoenix_Local_VIP_Per_Unit__c : 0;
                        Decimal cdPerUnit = blItem.Phoenix_Customer_Cash_Discount1__c != null ? blItem.Phoenix_Customer_Cash_Discount1__c : 0;
                        blItem.Phoenix_Customer_Dead_Net1__c = ApprovalPricingContracts > 0 ? (ApprovalPricingContracts - adminFee - vipPerUnit - cdPerUnit) :0;
                        blItem.Phoenix_Customer_Dead_Net1__c = blItem.Phoenix_Customer_Dead_Net1__c  > 0 ? blItem.Phoenix_Customer_Dead_Net1__c :0;
                        Decimal rebateInDollor = blItem.Phoenix_Customer_Rebates1__c != null ? blItem.Phoenix_Customer_Rebates1__c : 0;
                        Decimal IOdPerUnit = blItem.Phoenix_IOD_Per_Unit_in__c != null ? blItem.Phoenix_IOD_Per_Unit_in__c : 0;
                        Decimal wbadInDollor = blItem.Phoenix_Customer_Wbad_VIR1__c != null ? blItem.Phoenix_Customer_Wbad_VIR1__c : 0;
                        Decimal estReturnPerUnit = blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c != null ? blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c : 0;
                        Decimal customerVIPinDollor = blItem.Phoenix_Customer_VIP_Per_Unit__c != null ? blItem.Phoenix_Customer_VIP_Per_Unit__c : 0;
                        Decimal salesoutRebate = blItem.Phoenix_Sales_Out_Promotion_Per_unit_in__c != null ? blItem.Phoenix_Sales_Out_Promotion_Per_unit_in__c : 0;
                        blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Customer_Dead_Net1__c > 0 ? (blItem.Phoenix_Customer_Dead_Net1__c - salesoutRebate - rebateInDollor - wbadInDollor - customerVIPinDollor):0;//- IOdPerUnit 
                        blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Internal_Dead_Net_Price__c > 0 ? blItem.Phoenix_Internal_Dead_Net_Price__c  : 0;
                        blItem.Phoenix_Indirect_Dead_Net__c=blItem.Phoenix_Internal_Dead_Net_Price__c;
                        Decimal finalDirectUnits = blItem.Phoenix_Final_Direct_Selling_Units_Calc__c != null ? blItem.Phoenix_Final_Direct_Selling_Units_Calc__c : 0;
                        //Decimal finalIndirectUnits = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c != null ? blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c : 0;
                         Decimal finalIndirectUnits;
                        if (blItem.Phoenix_SCM_Final_Approval__c == true) {
                            finalIndirectUnits = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                        } else {
                            blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != 0 && blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null) ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c : (blItem.Phoenix_Override_Current_Indirect_Units__c != null && blItem.Phoenix_Override_Current_Indirect_Units__c != 0) ? blItem.Phoenix_Override_Current_Indirect_Units__c : blItem.Phoenix_Current_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Current_Indirect_Selling_Unit__c : 0;
                            finalIndirectUnits = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                        }
                        blItem.Phoenix_Override_Total_units__c = (blItem.Phoenix_Override_Current_Indirect_Units__c != null && blItem.Phoenix_Override_Current_Indirect_Units__c !=0)?blItem.Phoenix_Override_Current_Indirect_Units__c:0;
                        
                        blItem.Phoenix_IOD_Total_Amount__c = (IOdPerUnit * ((finalIndirectUnits) / 360) * (initialOrderDays != null ? initialOrderDays : 0));
                        blItem.Phoenix_Net_Sales_Internal__c = blItem.Phoenix_Internal_Dead_Net_Price__c > 0 ? (blItem.Phoenix_Internal_Dead_Net_Price__c * (finalDirectUnits + finalIndirectUnits)-blItem.Phoenix_IOD_Total_Amount__c-(estReturnPerUnit*finalIndirectUnits)).setscale(0) : 0;
                        blItem.Phoenix_Proposed_Sales__c = blItem.Phoenix_Net_Sales_Internal__c.setscale(0);
                    Decimal finalIndirectPrice = blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c : 0;
                    Decimal finalCurIndirPrice = blItem.Phoenix_Current_Indirect_Price__c != null ? blItem.Phoenix_Current_Indirect_Price__c : 0;
                    blItem.Phoenix_Reduction_in_NCP_WMT__c = (finalCurIndirPrice > 0 && finalIndirectPrice > 0) ? ((finalIndirectPrice/finalCurIndirPrice)-1)*100 : 0;
                    	
                    	// SSA Hit Calculation 
                    	Decimal finalUnits = (blItem.Phoenix_Override_Current_Indirect_Units__c != null && blItem.Phoenix_Override_Current_Indirect_Units__c > 0) ? blItem.Phoenix_Override_Current_Indirect_Units__c : (blItem.Phoenix_Current_Indirect_Selling_Unit__c!=null ?blItem.Phoenix_Current_Indirect_Selling_Unit__c:0);
                    	Decimal DiffPrice = (blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c :0) - (blItem.Phoenix_Current_Indirect_Price__c!= null ? blItem.Phoenix_Current_Indirect_Price__c : 0);
                    	Decimal SSANoofDays = (bidRec.Phoenix_Proposed_SSA_No_of_Days__c != null ? bidRec.Phoenix_Proposed_SSA_No_of_Days__c :0)/30;
                    	blItem.Phoenix_SSA_Hit_Updated__c = DiffPrice * SSANoofDays * (finalUnits/12);  
                    
                    //Price and Volume Variance calculations 
                    
                    Decimal currentIndirUnits = finalUnits;
                    Decimal ProposedIndirectUnis = (blItem.Phoenix_SCM_Final_Approval__c == true ? finalIndirectUnits : (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c:0))-currentIndirUnits;
                    
                    Decimal indirectDedadnet = (blItem.Phoenix_Internal_Dead_Net_Price__c != null ? blItem.Phoenix_Internal_Dead_Net_Price__c : 0)-(blItem.Phoenix_Current_ASP_Dose__c!=null?blItem.Phoenix_Current_ASP_Dose__c:0);
                    
                    Decimal priceVarianceIndir = indirectDedadnet *currentIndirUnits;
                    
                    Decimal volumeVarianceIndir = indirectDedadnet*ProposedIndirectUnis;
                    
                    blItem.Phoenix_Price_Variance__c = (bidType == 'Sales Out Rebate' || bidType == 'RFP Bids' || bidType == 'Price Change' || bidType == 'Customer Rebate Change') ? ( priceVarianceIndir):0;
                    blItem.Phoenix_Volume_Variance__c = (bidType == 'Sales Out Rebate' || bidType == 'Price Change' || bidType == 'Customer Rebate Change') ? 0 : ( volumeVarianceIndir) ;
                        
                    	
                    //new code for New Product Launch Calc
                    Decimal InternalDeadNet = blItem.Phoenix_Internal_Dead_Net_Price__c != null ? blItem.Phoenix_Internal_Dead_Net_Price__c : 0;
                    Decimal iodTotalAmount =  (blItem.Phoenix_IOD_Total_Amount__c != null &&  blItem.Phoenix_IOD_Total_Amount__c !=0) ?  blItem.Phoenix_IOD_Total_Amount__c :0;
                    Decimal brandwac =( blItem.Brand_WAC__c != null && blItem.Brand_WAC__c !=0)?blItem.Brand_WAC__c:0;
                    blItem.Phoenix_Brand_WAC_Per__c = brandwac != 0 ? (InternalDeadNet / brandwac)*100 : 0;
                    Decimal openingorder = (blItem.Phoenix_Opening_Order__c != null && blItem.Phoenix_Opening_Order__c != 0)?blItem.Phoenix_Opening_Order__c :0;
                    blItem.Phoenix_Opening_Order_Net_sales__c = openingorder>0 && InternalDeadNet > 0 ? (openingorder * InternalDeadNet) - iodTotalAmount - (openingorder * estReturnPerUnit):0;
                    Decimal openingOrdernetsales = (blItem.Phoenix_Opening_Order_Net_sales__c != null && blItem.Phoenix_Opening_Order_Net_sales__c != 0) ? blItem.Phoenix_Opening_Order_Net_sales__c : 0;
                    Decimal throughputcost1 = (blItem.Phoenix_Throughput_Cost1__c != null && blItem.Phoenix_Throughput_Cost1__c != 0)? blItem.Phoenix_Throughput_Cost1__c:0;
                    blItem.Phoenix_Opening_Order_TPT__c = openingorder>0 && InternalDeadNet > 0 ?  openingOrdernetsales - (openingorder * throughputcost1) : 0;
                    Decimal openingordertptdl = (blItem.Phoenix_Opening_Order_TPT__c != null &&  blItem.Phoenix_Opening_Order_TPT__c != 0) ?blItem.Phoenix_Opening_Order_TPT__c :0 ;
                    blItem.Phoenix_Opening_Order_TPT_Per__c = (openingorder>0 && InternalDeadNet > 0 && openingOrdernetsales !=0) ? (openingordertptdl / openingOrdernetsales)*100 :0 ;
                    //FOR Current Sales && NDC Finance View
                    Decimal estimadeMedicaidreturns = blItem.Phoenix_Estimated_Medicaid_Returns__c != null ? blItem.Phoenix_Estimated_Medicaid_Returns__c : 0;
                     Decimal finalCurrentUnits = (blItem.Phoenix_Override_Current_Indirect_Units__c >0)? blItem.Phoenix_Override_Current_Indirect_Units__c : ((blItem.Phoenix_Current_Indirect_Selling_Unit__c > 0) ? blItem.Phoenix_Current_Indirect_Selling_Unit__c:0);
                     blItem.Finance_Current_Sales__c = (blItem.Phoenix_DeadNet_TrckGR__c != null ? (finalCurrentUnits * blItem.Phoenix_DeadNet_TrckGR__c)-(estimadeMedicaidreturns * finalCurrentUnits):0);
                }
            }
            Catch(Exception e) {
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_BidLineItemTrigger', Phoenix_Method_Name__c = '', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
            }
    }
   
    public override void afterUpdate() {}
}