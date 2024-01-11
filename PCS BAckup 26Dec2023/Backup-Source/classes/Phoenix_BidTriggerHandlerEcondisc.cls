public class Phoenix_BidTriggerHandlerEcondisc  extends TriggerHandler{
    private list < Phoenix_Bid_Line_Item__c > triggerNew;
    private list < Phoenix_Bid_Line_Item__c > triggerOld;
    private Map < Id, Phoenix_Bid_Line_Item__c > newMap;
    private Map < Id, Phoenix_Bid_Line_Item__c > oldMap;
    
    public Phoenix_BidTriggerHandlerEcondisc () {
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
        String bidType= bidRec.Phoenix_Bid_Type__c;
        for (Phoenix_Bid_Line_Item__c blItem: triggerNew) {
            try{
                if (blItem.Phoenix_Bid_Template_Refrence__c == 'Econdisc'){
                    
                    //Final direct units
                    if (bidType == 'RFP Bids' || bidType == 'Volume Review Only' || bidType == 'Product Addition' || bidType == 'New Product Launch') {
                            Decimal directESI = blItem.Phoenix_Direct_ESI__c != null ? blItem.Phoenix_Direct_ESI__c : 0;
                            Decimal directKroger = blItem.Phoenix_Direct_Kroger__c != null ? blItem.Phoenix_Direct_Kroger__c : 0;
                            Decimal directRxOutReach = blItem.Phoenix_Direct_Rx_Outreach__c != null ? blItem.Phoenix_Direct_Rx_Outreach__c : 0;
                            Decimal directSuprVal = blItem.Phoenix_Direct_Supervalu__c != null ? blItem.Phoenix_Direct_Supervalu__c : 0;
                            Decimal directCigna = blItem.Phoenix_Direct_Cigna__c != null ? blItem.Phoenix_Direct_Cigna__c : 0;
                            Decimal directCordant = blItem.Phoenix_Direct_Cordant__c != null ? blItem.Phoenix_Direct_Cordant__c : 0;
                            Decimal directAccerodo = blItem.Phoenix_Direct_Accerodo__c != null ? blItem.Phoenix_Direct_Accerodo__c : 0;
                            Decimal othersDirect = blItem.Phoenix_Others_Direct__c != null ? blItem.Phoenix_Others_Direct__c : 0;
                            blItem.Phoenix_Proposed_Direct_Selling_Unit__c = directESI + directKroger + directRxOutReach + directSuprVal + directCigna + directCordant + directAccerodo + othersDirect;
                            //blItem.Phoenix_Proposed_Direct_Selling_Unit__c=blItem.Phoenix_Final_Direct_Selling_Units_Calc__c;
                     }
                    // Final Indirect unit totals
                    if (bidType == 'RFP Bids' || bidType == 'Volume Review Only' || bidType == 'Product Addition' ||bidType == 'New Product Launch') {
                        Decimal IndirectESI = blItem.Phoenix_Indirect_ESI__c != null ? blItem.Phoenix_Indirect_ESI__c : 0;
                        Decimal IndirectKroger = blItem.Phoenix_Indirect_Kroger__c != null ? blItem.Phoenix_Indirect_Kroger__c : 0;
                        Decimal IndirectRxOutReach = blItem.Phoenix_Indirect_Rx_Outreach__c != null ? blItem.Phoenix_Indirect_Rx_Outreach__c : 0;
                        Decimal IndirectSuprVal = blItem.Phoenix_Indirect_Supervalu__c != null ? blItem.Phoenix_Indirect_Supervalu__c : 0;
                        Decimal IndirectCigna = blItem.Phoenix_Indirect_Cigna__c != null ? blItem.Phoenix_Indirect_Cigna__c : 0;
                        Decimal IndirectCordant = blItem.Phoenix_Indirect_Cordant__c != null ? blItem.Phoenix_Indirect_Cordant__c : 0;
                        Decimal IndirectAccerodo = blItem.Phoenix_Indirect_Accerodo__c != null ? blItem.Phoenix_Indirect_Accerodo__c : 0;
                        Decimal othersIndirect = blItem.Phoenix_Others_Indirect__c != null ? blItem.Phoenix_Others_Indirect__c : 0;
                        blItem.Phoenix_Proposed_Indirect_Selling_Unit__c = IndirectESI + IndirectKroger + IndirectRxOutReach + IndirectSuprVal + IndirectCigna + IndirectCordant + IndirectAccerodo + othersIndirect;
                        //blItem.Phoenix_Proposed_Indirect_Selling_Unit__c=blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                    }
                    Decimal totalProposed = (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c!= null ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c : 0) + (blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null ? blItem.Phoenix_Proposed_Direct_Selling_Unit__c:0) ;   
                    Decimal overRideDirUnits = blItem.Phoenix_Override_Current_Direct_Units__c != null ? blItem.Phoenix_Override_Current_Direct_Units__c : 0;
                    Decimal overRideIndirectUnits = blItem.Phoenix_Override_Current_Indirect_Units__c != null ? blItem.Phoenix_Override_Current_Indirect_Units__c : 0;
                    if ((overRideDirUnits + overRideIndirectUnits) > 0) {                            
                        blItem.Phoenix_Override_Total_units__c = overRideDirUnits + overRideIndirectUnits;
                    }else {
                        blItem.Phoenix_Override_Total_units__c = 0;
                    }
                    Decimal totalCurrentUnits = (overRideDirUnits + overRideIndirectUnits) > 0 ? (overRideDirUnits + overRideIndirectUnits) : (blItem.Phoenix_Current_Direct_Selling_Unit__c != null ? blItem.Phoenix_Current_Direct_Selling_Unit__c : 0)+ (blItem.Phoenix_Current_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Current_Indirect_Selling_Unit__c : 0);
                    Decimal totalSCMApprovedUnits = 0 ;
                    Decimal directScmQy = 0 ;
                    Decimal IndirectScmQy = 0 ;
                    if (blItem.Phoenix_SCM_Final_Approval__c == true) { 
                        decimal percenalOfQty = 0;
                        Decimal finalCalcedScmQuantity = (((totalCurrentUnits/12)+((blItem.Phoenix_SCM_Approved_Quantity__c/100)*((totalProposed/12)-(totalCurrentUnits/12))))*12).setScale(0);
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
                            if ((blItem.Phoenix_SCM_Qty_Approved_Direct__c != null && finalDirectSellingUNitCal.setScale(0) != 0) || totalProposed > 0) {
                                blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = blItem.Phoenix_SCM_Qty_Approved_Direct__c;
                            } else {
                                blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = blItem.Phoenix_Current_Direct_Selling_Unit__c;
                            }
                            finalIndirectSellingUNitCal = blItem.Phoenix_SCM_Qty_Approved_Indirect__c;
                            if ((blItem.Phoenix_SCM_Qty_Approved_Indirect__c != null && finalIndirectSellingUNitCal.setScale(0) != 0) || totalProposed > 0) {
                                blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = blItem.Phoenix_SCM_Qty_Approved_Indirect__c;
                            } else {
                                blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = blItem.Phoenix_Current_Indirect_Selling_Unit__c;
                            }
                            
                        }
                        directScmQy = (blItem.Phoenix_Final_Direct_Selling_Units_Calc__c != null ? blItem.Phoenix_Final_Direct_Selling_Units_Calc__c :0);
                        IndirectScmQy = (blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c != null ? blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c :0);
                        totalSCMApprovedUnits = directScmQy + IndirectScmQy;
                } 
                                               
                        Decimal ApprovalPricingContracts = (blItem.Phoenix_Final_Approvd_Pricing_Contracts__c != null && blItem.Phoenix_Final_Approvd_Pricing_Contracts__c != 0) ? blItem.Phoenix_Final_Approvd_Pricing_Contracts__c : (blItem.Phoenix_Current_Direct_Price__c != null && blItem.Phoenix_Current_Direct_Price__c != 0) ? blItem.Phoenix_Current_Direct_Price__c : blItem.Phoenix_Current_Indirect_Price__c != null ? blItem.Phoenix_Current_Indirect_Price__c : 0;
                        Decimal currentDirectPrice = blItem.Phoenix_Current_Direct_Price__c != null ? blItem.Phoenix_Current_Direct_Price__c :0;
                        blItem.Phoenix_Reduction__c = currentDirectPrice !=0 ? ((ApprovalPricingContracts/currentDirectPrice)-1)*100 : 0 ;
                        Decimal wholsaleIndirectPrice = (blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != null && blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != 0) ? blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c : (blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null && blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != 0) ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c: blItem.Phoenix_Current_Indirect_Price__c != null ? blItem.Phoenix_Current_Indirect_Price__c : 0;
                        Decimal vipPerUnit = blItem.Direct_VIP_Per_Unit__c != null ? blItem.Direct_VIP_Per_Unit__c : 0;
                        Decimal rebateindoller = blItem.Phoenix_Customer_Rebates1__c != null ? blItem.Phoenix_Customer_Rebates1__c : 0;
                        Decimal adminFeedoller = blItem.Phoenix_Admin_Fee_in__c != null ? blItem.Phoenix_Admin_Fee_in__c : 0;
                        Decimal IOdPerUnit = blItem.Phoenix_IOD_Per_Unit_in__c != null ? blItem.Phoenix_IOD_Per_Unit_in__c : 0;
                        Decimal salesoutRebate = blItem.Phoenix_Sales_Out_Promotion_Per_unit_in__c != null ? blItem.Phoenix_Sales_Out_Promotion_Per_unit_in__c : 0;
                        Decimal cdPerUnit = blItem.Phoenix_Customer_Cash_Discount1__c != null ? blItem.Phoenix_Customer_Cash_Discount1__c : 0;
                        Decimal directCDperUnit = blItem.Phoenix_Direct_CD_Per_Unit__c != null ? blItem.Phoenix_Direct_CD_Per_Unit__c : 0;
                        Decimal estReturnPerUnit = blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c != null ? blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c : 0;
                        Decimal propsedPerRebate = blItem.Phoenix_Proposed_Per_Unit_Rebate__c != null ? blItem.Phoenix_Proposed_Per_Unit_Rebate__c : 0;
                        blItem.Phoenix_Customer_Dead_Net1__c = ApprovalPricingContracts > 0 ?  (ApprovalPricingContracts - vipPerUnit):0;
                        blItem.Phoenix_Customer_Dead_Net1__c = blItem.Phoenix_Customer_Dead_Net1__c > 0 ? blItem.Phoenix_Customer_Dead_Net1__c :0;
                    	Decimal whlsrControlSubFee = blItem.Phoenix_Whlsr_Controlled_Substance_Fee__c != null ? blItem.Phoenix_Whlsr_Controlled_Substance_Fee__c : 0;
                        blItem.Phoenix_Direct_Dead_Net__c = blItem.Phoenix_Customer_Dead_Net1__c > 0 ? (blItem.Phoenix_Customer_Dead_Net1__c - adminFeedoller  - salesoutRebate - directCDperUnit  - rebateindoller):0;// - IOdPerUnit- estReturnPerUnit
                        blItem.Phoenix_Direct_Dead_Net__c= blItem.Phoenix_Direct_Dead_Net__c > 0 ? blItem.Phoenix_Direct_Dead_Net__c:0;
                        Decimal indirectRebate = blItem.Phoenix_Rebate__c != null ? blItem.Phoenix_Rebate__c : 0;
                        Decimal indirectCdperUnit = blItem.Phoenix_INDIRECT_CD__c != null ? blItem.Phoenix_INDIRECT_CD__c : 0;
                        Decimal RDCNLCperUnit = blItem.Phoenix_RDC_NLC_Per_Unit_in__c != null ? blItem.Phoenix_RDC_NLC_Per_Unit_in__c : 0;
                        Decimal CMFeeperUnit = blItem.Phoenix_Customer_Fees__c != null ? blItem.Phoenix_Customer_Fees__c : 0;
                        Decimal propZitd = blItem.Phoenix_Proposed_ZITD__c != null ? blItem.Phoenix_Proposed_ZITD__c : 0;
                        decimal indirectVIPperUnit = blItem.Indirect_VIP_Per_Unit__c != null ? blItem.Indirect_VIP_Per_Unit__c : 0;

                        blItem.Phoenix_Indirect_Dead_Net__c= blItem.Phoenix_Indirect_Dead_Net__c > 0 ? (blItem.Phoenix_Indirect_Dead_Net__c): 0;
                        Decimal currentIndirectUnits = blItem.Phoenix_Current_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Current_Indirect_Selling_Unit__c : 0;
                        Decimal currentDirectUnits = blItem.Phoenix_Current_Direct_Selling_Unit__c != null ? blItem.Phoenix_Current_Direct_Selling_Unit__c : 0;
                        Decimal OverrideUnits = blItem.Phoenix_Override_Current_Units__c != null ? blItem.Phoenix_Override_Current_Units__c : 0;
                        //Decimal finalDirectUnits = 0, finalIndirectUnits = 0;
                        Decimal finalDirectUnits = overRideDirUnits, finalIndirectUnits = overRideIndirectUnits;
                        Decimal totalOverride = overRideDirUnits + overRideIndirectUnits ; 
                       /* if (currentDirectUnits + currentIndirectUnits != 0) {
                            finalDirectUnits = (currentDirectUnits / (currentDirectUnits + currentIndirectUnits)) * OverrideUnits;
                            finalIndirectUnits = (currentIndirectUnits / (currentDirectUnits + currentIndirectUnits)) * OverrideUnits;
                        } 
                        else {
                            finalDirectUnits = OverrideUnits / 2;
                            finalIndirectUnits = OverrideUnits / 2;
                        }*/
                        //Decimal finalDirectUnits = (blItem.Phoenix_Final_Direct_Selling_Units_Calc__c != null && blItem.Phoenix_Final_Direct_Selling_Units_Calc__c!=0) ? blItem.Phoenix_Final_Direct_Selling_Units_Calc__c :(blItem.Phoenix_Current_Direct_Selling_Unit__c!=null && blItem.Phoenix_Current_Direct_Selling_Unit__c!=0)?blItem.Phoenix_Current_Direct_Selling_Unit__c:0;
                        //blItem.Phoenix_Final_Direct_Selling_Units_Calc__c=finalDirectUnits;
                        
                        if (blItem.Phoenix_SCM_Final_Approval__c == true) {
                            finalDirectUnits = blItem.Phoenix_Final_Direct_Selling_Units_Calc__c;
                        } 
                        else {
                            blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = ((blItem.Phoenix_Proposed_Direct_Selling_Unit__c != 0 && blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null) || totalProposed != 0) ? (blItem.Phoenix_Proposed_Direct_Selling_Unit__c!= null ? blItem.Phoenix_Proposed_Direct_Selling_Unit__c:0) : (finalDirectUnits != 0 || totalOverride > 0) ? finalDirectUnits : blItem.Phoenix_Current_Direct_Selling_Unit__c != null ? blItem.Phoenix_Current_Direct_Selling_Unit__c : 0;
                            blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = totalSCMApprovedUnits > 0 ? directScmQy :blItem.Phoenix_Final_Direct_Selling_Units_Calc__c;
                            finalDirectUnits = blItem.Phoenix_Final_Direct_Selling_Units_Calc__c;
                        }
                        if (blItem.Phoenix_SCM_Final_Approval__c == true) {
                            finalIndirectUnits = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                        } else {
                            blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = ((blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != 0 && blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null) || totalProposed != 0) ? (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null ?blItem.Phoenix_Proposed_Indirect_Selling_Unit__c :0)  : (finalIndirectUnits != 0 || totalOverride > 0) ? finalIndirectUnits : blItem.Phoenix_Current_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Current_Indirect_Selling_Unit__c : 0;
                            blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = totalSCMApprovedUnits > 0 ? IndirectScmQy :blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                            finalIndirectUnits = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                        }
                        //Decimal finalIndirectUnits = (blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c != null && blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c!=0) ? blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c :(blItem.Phoenix_Current_Indirect_Selling_Unit__c!=null && blItem.Phoenix_Current_Indirect_Selling_Unit__c!=0)?blItem.Phoenix_Current_Indirect_Selling_Unit__c:0;
                        //blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c=finalIndirectUnits;
                        //blItem.Phoenix_Net_Sales_Internal__c=(blItem.Phoenix_Direct_Dead_Net__c*finalDirectUnits)+(blItem.Phoenix_Indirect_Dead_Net__c*(finalIndirectUnits));
                        //added by satya
                        Decimal tpcost = blItem.Phoenix_Throughput_Cost1__c != null ? blItem.Phoenix_Throughput_Cost1__c : 0;
                        //Decimal directdeadnet=blItem.Phoenix_Direct_Dead_Net__c!=null?blItem.Phoenix_Direct_Dead_Net__c:0;
                        Decimal indirectdeadnet = blItem.Proposed_Net_Sales_Direct__c != null ? blItem.Proposed_Net_Sales_Direct__c : 0;
                        // Decimal indirectdeadnet=blItem.Proposed_Net_Sales_Indirect__c!=null?blItem.Proposed_Net_Sales_Indirect__c:0;

                        // new fields for econdisc added by Joga
                        // (DRL Dead net W/o IOD, Medicaid & Returns * Final Direct Selling Units) - "IOD Total Amount $" - ("Estimated Medicaid and Returns per unit $" * Final Direct selling units)
                        blItem.Phoenix_IOD_Total_Amount__c = (IOdPerUnit * ((finalDirectUnits) / 360) * (initialOrderDays != null ? initialOrderDays : 0));
                        blItem.Phoenix_DRL_Dead_Net_After_IOD_w_o_MR__c = blItem.Phoenix_Direct_Dead_Net__c > 0 ? (blItem.Phoenix_Direct_Dead_Net__c != null ? blItem.Phoenix_Direct_Dead_Net__c : 0)-IOdPerUnit : 0;//+ estReturnPerUnit
                        blItem.Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c = blItem.Phoenix_Direct_Dead_Net__c != null ? blItem.Phoenix_Direct_Dead_Net__c : 0;// + estReturnPerUnit ;
                        blItem.Phoenix_Indirect_Dead_Net_w_o_Med_Retrns__c = (blItem.Phoenix_Indirect_Dead_Net__c != null ? (blItem.Phoenix_Indirect_Dead_Net__c ) : 0); //+ estReturnPerUnit;

                        blItem.Proposed_Net_Sales_Direct__c = blItem.Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c > 0 ? ((blItem.Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c * finalDirectUnits) - blItem.Phoenix_IOD_Total_Amount__c - (estReturnPerUnit * finalDirectUnits)) : 0;
                        blItem.Proposed_Net_Sales_Indirect__c = blItem.Phoenix_Indirect_Dead_Net__c > 0 ? (blItem.Phoenix_Indirect_Dead_Net__c * finalIndirectUnits)- (estReturnPerUnit * finalIndirectUnits) :0;
                        blItem.Phoenix_Net_Sales_Internal__c = (blItem.Proposed_Net_Sales_Direct__c + blItem.Proposed_Net_Sales_Indirect__c);

                        // ( ("DRL Dead net w/o IOD, Medicaid & Returns" - "Throughput cost") * "Final Direct Selling units") - ( "IOD Total Amount $") - ("Estimated Medicaid and Returns per unit" * "Final Direct Selling units")

                        blItem.Proposed_TPT_Direct__c = blItem.Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c > 0 ? (((blItem.Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c - tpcost) * finalDirectUnits) - blItem.Phoenix_IOD_Total_Amount__c - (estReturnPerUnit * finalDirectUnits)) : 0; //(blItem.Phoenix_Direct_Dead_Net__c-tpcost)*(finalDirectUnits);
                        blItem.Proposed_TPT_Indirect__c = blItem.Proposed_Net_Sales_Indirect__c > 0 ? blItem.Proposed_Net_Sales_Indirect__c -  (tpcost*finalIndirectUnits) : 0;
                        if (blItem.Proposed_Net_Sales_Direct__c > 0) {
                            blItem.Proposed_TPT_Per_Direct__c = ((blItem.Proposed_TPT_Direct__c) / (blItem.Proposed_Net_Sales_Direct__c)) * 100;
                        } else {
                            blItem.Proposed_TPT_Per_Direct__c = 0;
                        }
                        if (blItem.Proposed_Net_Sales_Indirect__c > 0) {
                            blItem.Proposed_TPT_Per_Indirect__c = ((blItem.Proposed_TPT_Indirect__c) / (blItem.Proposed_Net_Sales_Indirect__c)) * 100;
                        } else {
                            blItem.Proposed_TPT_Per_Indirect__c = 0;
                        }
                    
                       //Price and Volume Variance calculations 
                        Decimal currentDirUnits = (overRideDirUnits > 0 || totalOverride > 0) ? overRideDirUnits :(blItem.Phoenix_Current_Direct_Selling_Unit__c != null ? blItem.Phoenix_Current_Direct_Selling_Unit__c : 0);
                        Decimal currentIndirUnits = (overRideIndirectUnits > 0 || totalOverride > 0) ? overRideIndirectUnits :(blItem.Phoenix_Current_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Current_Indirect_Selling_Unit__c : 0);
                        Decimal ProposedDirectUnits = blItem.Phoenix_SCM_Final_Approval__c == true ? (blItem.Phoenix_Final_Direct_Selling_Units_Calc__c!=null ?blItem.Phoenix_Final_Direct_Selling_Units_Calc__c:0):(blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null ? blItem.Phoenix_Proposed_Direct_Selling_Unit__c:0);
                        Decimal ProposedIndirectUnis = blItem.Phoenix_SCM_Final_Approval__c == true ? (blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c!=null ?blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c:0):(blItem.Phoenix_Proposed_Indirect_Selling_Unit__c!= null ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c : 0);
                        
                        Decimal directDeadNet = blItem.Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c != null ? blItem.Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c : 0;
                        Decimal indirectDedadnet = blItem.Phoenix_Indirect_Dead_Net__c != null ? blItem.Phoenix_Indirect_Dead_Net__c : 0;
                    
                        Decimal diffinVolumeDirecet = ProposedDirectUnits-currentDirUnits;
                        Decimal diffinVolumeIndirect = ProposedIndirectUnis-currentIndirUnits;
                        
                        Decimal diffinPriceDir =  directDeadNet - (blItem.Phoenix_DeadNet_TrckGR__c != null ? blItem.Phoenix_DeadNet_TrckGR__c :0);
                        Decimal diffinPriceIndir = indirectDedadnet - (blItem.Phoenix_DeadNet_TrckGR__c != null ? blItem.Phoenix_DeadNet_TrckGR__c :0);
                    
                        Decimal priceVarianceDir = diffinPriceDir *currentDirUnits;
                        Decimal priceVarianceIndir = diffinPriceIndir *currentIndirUnits;
                       
                        Decimal volumeVarianceDir = diffinVolumeDirecet*diffinPriceDir;
                        Decimal volumeVarianceIndir = diffinPriceIndir*diffinVolumeIndirect;
                      
                    	blItem.Phoenix_Price_Variance__c = (bidType == 'Sales Out Rebate' || bidType == 'RFP Bids' || bidType == 'Price Change' || bidType == 'Customer Rebate Change') ? (priceVarianceDir + priceVarianceIndir):0;
                    	blItem.Phoenix_Volume_Variance__c = (bidType == 'Sales Out Rebate' || bidType == 'Price Change' || bidType == 'Customer Rebate Change') ? 0 : (volumeVarianceDir + volumeVarianceIndir) ;  
                        // end
                        
                         // SSA Hit Calculation 
                    	Decimal DiffPrice = (blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c :0) - (blItem.Phoenix_Current_Direct_Price__c!= null ? blItem.Phoenix_Current_Direct_Price__c : 0);
                    	Decimal SSANoofDays = (bidRec.Phoenix_Proposed_SSA_No_of_Days__c != null ? bidRec.Phoenix_Proposed_SSA_No_of_Days__c :0)/30;
                    	blItem.Phoenix_SSA_Hit_Updated__c = DiffPrice * SSANoofDays * (currentDirUnits/12);    
                            
                        blItem.Phoenix_Net_Sales_Internal__c = blItem.Phoenix_Net_Sales_Internal__c.setscale(0);
                        blItem.Phoenix_Proposed_Sales__c = blItem.Phoenix_Net_Sales_Internal__c.setscale(0);
                    
                        if (finalDirectUnits + finalIndirectUnits != 0) {
                            blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Net_Sales_Internal__c / (finalDirectUnits + finalIndirectUnits);
                        }
                    	
                        /* For New Product Launch */
                    	Decimal blendeddeadnet = blItem.Phoenix_Internal_Dead_Net_Price__c !=null ?  blItem.Phoenix_Internal_Dead_Net_Price__c :0;
                    	Decimal brandwac =( blItem.Brand_WAC__c != null && blItem.Brand_WAC__c !=0)?blItem.Brand_WAC__c:0;
                    	blItem.Phoenix_Brand_WAC_Per__c = brandwac != 0 && brandwac != null? (blendeddeadnet / brandwac)*100 : 0;
                    	Decimal estimadeMedicaidreturns = blItem.Phoenix_Estimated_Medicaid_Returns__c != null ? blItem.Phoenix_Estimated_Medicaid_Returns__c : 0;
                    	Decimal openingorder = (blItem.Phoenix_Opening_Order__c != null && blItem.Phoenix_Opening_Order__c != 0)?blItem.Phoenix_Opening_Order__c :0;
                    	Decimal iodTotalAmount = (blItem.Phoenix_IOD_Total_Amount__c != null && blItem.Phoenix_IOD_Total_Amount__c != 0 ) ? blItem.Phoenix_IOD_Total_Amount__c : 0;
                    	blItem.Phoenix_Opening_Order_Net_sales__c = (blendeddeadnet > 0 && openingorder>0)  ?(openingorder * blendeddeadnet) - iodTotalAmount - (openingorder * estimadeMedicaidreturns) : 0;
			            Decimal openingOrdernetsales = (blItem.Phoenix_Opening_Order_Net_sales__c != null && blItem.Phoenix_Opening_Order_Net_sales__c != 0) ? blItem.Phoenix_Opening_Order_Net_sales__c : 0;
                    	Decimal throughputcost = (blItem.Phoenix_Throughput_Cost1__c != null && blItem.Phoenix_Throughput_Cost1__c != 0)? blItem.Phoenix_Throughput_Cost1__c:0;
                        blItem.Phoenix_Opening_Order_TPT__c = openingOrdernetsales > (openingorder * throughputcost) ? openingOrdernetsales - (openingorder * throughputcost) : 0;
					    Decimal openingordertptdl = (blItem.Phoenix_Opening_Order_TPT__c != null &&  blItem.Phoenix_Opening_Order_TPT__c != 0) ?blItem.Phoenix_Opening_Order_TPT__c :0 ;
                        blItem.Phoenix_Opening_Order_TPT_Per__c = (openingordertptdl > 0 && openingOrdernetsales > 0) ? (openingordertptdl / openingOrdernetsales)*100 :0 ;
                    //Decimal currentCVSDirectSales = (((blItem.Current_CVS_DeadNet__c != null ? blItem.Current_CVS_DeadNet__c: 0)* (currentDirUnits)) - ((currentDirUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c));
                    //Decimal currentCVSIndirectSales = (((blItem.Current_CVS_Indirect_DeadNet__c != null ? blItem.Current_CVS_Indirect_DeadNet__c: 0)* (currentIndirUnits)) - ((currentIndirUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c));
                    Decimal currentCVSDirectSales = (blItem.Current_CVS_DeadNet__c != null ? (blItem.Current_CVS_DeadNet__c * currentDirUnits) - ((currentDirUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c): 0);
                    Decimal currentCVSIndirectSales = (blItem.Current_CVS_Indirect_DeadNet__c != null ? (blItem.Current_CVS_Indirect_DeadNet__c * (currentIndirUnits)) - ((currentIndirUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c): 0);
                    
                    blItem.Finance_Current_Sales__c = currentCVSDirectSales+currentCVSIndirectSales;
                    
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