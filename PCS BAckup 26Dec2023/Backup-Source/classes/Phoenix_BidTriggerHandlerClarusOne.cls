public class Phoenix_BidTriggerHandlerClarusOne extends TriggerHandler{
    private list < Phoenix_Bid_Line_Item__c > triggerNew;
    private list < Phoenix_Bid_Line_Item__c > triggerOld;
    private Map < Id, Phoenix_Bid_Line_Item__c > newMap;
    private Map < Id, Phoenix_Bid_Line_Item__c > oldMap;
    
    public Phoenix_BidTriggerHandlerClarusOne  () {
        this.newMap = (Map < Id, Phoenix_Bid_Line_Item__c > ) Trigger.newMap;
        this.oldMap = (Map < Id, Phoenix_Bid_Line_Item__c > ) Trigger.oldMap;
        this.triggerNew = (List < Phoenix_Bid_Line_Item__c > ) Trigger.new;
        this.triggerOld = (List < Phoenix_Bid_Line_Item__c > ) Trigger.old;
    }
    public override void beforeInsert() {
        beforeUpdate();
    }
    public override void beforeUpdate() {
        Phoenix_Bid__c bidRec = [SELECT Id,Phoenix_Customer_Type__c, Phoenix_Customer__r.Phoenix_ABS__c, Phoenix_Customer__r.Phoenix_Rebates__c,Phoenix_Customer__r.Phoenix_Cash_Discount__c ,
                                 Phoenix_Customer__r.Phoenix_Fee__c,Phoenix_Customer__r.Phoenix_CM_Fees__c,Phoenix_Bid_Proposed_Position__c, 
                                 Phoenix_Approval_Status__c,Phoenix_Proposed_Cash_Terms__c,Phoenix_Initial_Order_Discount_Type__c, Phoenix_Custom_type__c, 
                                 Phoenix_Current_CD__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Initial_Order_Discount_of_Days__c, 
                                 Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Bid_Type__c,Phoenix_WMT_Direct_Rebate__c,Phoenix_Mck_RAD_Rebate__c,Phoenix_Data_Fee__c,
                                 Phoenix_Controlled_Substance__c,Phoenix_Required_Cold_Storage__c,Phoenix_Controlled_Distribution__c,Phoenix_Proposed_SSA_No_of_Days__c
                                 FROM Phoenix_Bid__c 
                                 WHERE Id =: triggerNew[0].Phoenix_Bid__c];
        Decimal initialOrderDays = bidRec.Phoenix_Initial_Order_Discount_of_Days__c != null? bidRec.Phoenix_Initial_Order_Discount_of_Days__c : 0 ;
        Decimal initialOrderDisc=bidRec.Phoenix_Proposed_Initial_Order_Discount__c != null? bidRec.Phoenix_Proposed_Initial_Order_Discount__c : 0 ;
        String bidType= bidRec.Phoenix_Bid_Type__c;
        for (Phoenix_Bid_Line_Item__c blItem: triggerNew) {
            try{
                if (blItem.Phoenix_Bid_Template_Refrence__c == 'ClarusOne'){
                    Decimal currentOSUnits = blItem.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c != null ? blItem.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c : 0;
                    Decimal curWMTDirectUnits = blItem.Phoenix_WMT_Current_Direct_Units__c != null ? blItem.Phoenix_WMT_Current_Direct_Units__c : 0;
                    Decimal currWMTIndirectUnits = blItem.Phoenix_WMT_Current_Indirect_Units__c != null ? blItem.Phoenix_WMT_Current_Indirect_Units__c : 0;
                    Decimal proposedWMTUnits = (blItem.Phoenix_Final_Direct_Selling_Units__c != null && blItem.Phoenix_Final_Direct_Selling_Units__c != 0 && blItem.Phoenix_SCM_Final_Approval__c == true) ? blItem.Phoenix_Final_Direct_Selling_Units__c : blItem.Phoenix_Proposed_WMT_Units__c != null ? blItem.Phoenix_Proposed_WMT_Units__c : 0;
                    Decimal ProsedOSUnits = (blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c != null && blItem.Phoenix_SCM_Final_Approval__c == true) ? blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c : blItem.Phoenix_Proposed_OS_Units__c != null ? blItem.Phoenix_Proposed_OS_Units__c : 0;
                    Decimal ProsedRADUnits = (blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c != null && blItem.Phoenix_SCM_Final_Approval__c == true) ? blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c : blItem.Phoenix_Proposed_RAD_Units__c != null ? blItem.Phoenix_Proposed_RAD_Units__c : 0;
                    Decimal proposedTotalUnits = (blItem.Phoenix_Proposed_WMT_Units__c != null ? blItem.Phoenix_Proposed_WMT_Units__c : 0) + (blItem.Phoenix_Proposed_OS_Units__c != null ? blItem.Phoenix_Proposed_OS_Units__c : 0) + (blItem.Phoenix_Proposed_RAD_Units__c != null ? blItem.Phoenix_Proposed_RAD_Units__c : 0);
                    //Decimal proposedTotalUnits = proposedWMTUnits+ProsedRADUnits+ProsedOSUnits;
                    Decimal overRidecurrentOSUnits = blItem.Phoenix_Override_Current_Direct_Units__c != null ? blItem.Phoenix_Override_Current_Direct_Units__c : 0;
                    Decimal overRidecurWMTDirectUnits = blItem.Phoenix_Override_Current_Indirect_Units__c != null ? blItem.Phoenix_Override_Current_Indirect_Units__c : 0;
                    Decimal overRidecurrWMTIndirectUnits = blItem.Phoenix_Proposed_Smith_Drug_Units__c != null ? blItem.Phoenix_Proposed_Smith_Drug_Units__c : 0;
                    Decimal totalOverride = overRidecurrentOSUnits + overRidecurWMTDirectUnits + overRidecurrWMTIndirectUnits;
                    Decimal finalDirectUnits = (proposedWMTUnits != 0 || proposedTotalUnits !=0) ? proposedWMTUnits : (overRidecurrentOSUnits != 0 || totalOverride != 0) ?  overRidecurrentOSUnits : curWMTDirectUnits;
                    Decimal finalIndirectUnits = ((ProsedOSUnits + ProsedRADUnits) > 0 || proposedTotalUnits !=0) ? (ProsedOSUnits + ProsedRADUnits) : ((overRidecurWMTDirectUnits+overRidecurrWMTIndirectUnits)> 0  || totalOverride != 0)? (overRidecurWMTDirectUnits+overRidecurrWMTIndirectUnits) :(currentOSUnits + currWMTIndirectUnits);
                    Decimal totalCurrentUnits = (overRidecurrentOSUnits + overRidecurWMTDirectUnits + overRidecurrWMTIndirectUnits) > 0 ? (overRidecurrentOSUnits + overRidecurWMTDirectUnits + overRidecurrWMTIndirectUnits) :(currentOSUnits +curWMTDirectUnits+currWMTIndirectUnits);
                    blItem.Phoenix_Proposed_Direct_Selling_Unit__c = blItem.Phoenix_Proposed_WMT_Units__c != null ? blItem.Phoenix_Proposed_WMT_Units__c : 0;
                    blItem.Phoenix_Proposed_Indirect_Selling_Unit__c = (blItem.Phoenix_Proposed_OS_Units__c != null ? blItem.Phoenix_Proposed_OS_Units__c : 0) + (blItem.Phoenix_Proposed_RAD_Units__c != null ? blItem.Phoenix_Proposed_RAD_Units__c : 0);
            
                    if (blItem.Phoenix_SCM_Final_Approval__c == true) { 
                        decimal percenalOfQty = 0;
                        Decimal finalCalcedScmQuantity = (((totalCurrentUnits/12)+(((blItem.Phoenix_SCM_Approved_Quantity__c != null ? blItem.Phoenix_SCM_Approved_Quantity__c : 0)/100)*((proposedTotalUnits/12)-(totalCurrentUnits/12))))*12).setScale(0);

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
                        
                        Decimal finalCurrentSCMUnits =  blItem.Phoenix_Current_Direct_Selling_Unit__c != null ? blItem.Phoenix_Current_Direct_Selling_Unit__c : 0; 
                        if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Only Current Monthly Demand Approved') {
                            blItem.Phoenix_SCM_Qty_Approved_Direct__c = finalCurrentSCMUnits;
                        }
                        if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Current + Inc Demand Approved' && blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null) {
                            blItem.Phoenix_SCM_Qty_Approved_Direct__c = blItem.Phoenix_Proposed_Direct_Selling_Unit__c * percenalOfQty * 12;
                        } else if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Current + Inc Demand Approved') {
                            blItem.Phoenix_SCM_Qty_Approved_Direct__c = 0;
                        }
                        if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Only Current Monthly Demand Approved' && blItem.Phoenix_Current_Indirect_Selling_Unit__c != null) {
                            blItem.Phoenix_SCM_Qty_Approved_Indirect__c =  blItem.Phoenix_Current_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Current_Indirect_Selling_Unit__c  : 0 ;
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
                            if ((blItem.Phoenix_SCM_Qty_Approved_Direct__c != null && finalDirectSellingUNitCal.setScale(0) != 0) || proposedTotalUnits > 0) {
                                
                                blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = blItem.Phoenix_SCM_Qty_Approved_Direct__c;
                            } else {
                                blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = totalOverride > 0 ? overRidecurWMTDirectUnits : blItem.Phoenix_Current_Direct_Selling_Unit__c;
                            }
                            
                            finalIndirectSellingUNitCal = blItem.Phoenix_SCM_Qty_Approved_Indirect__c;
                            if ((blItem.Phoenix_SCM_Qty_Approved_Indirect__c != null && finalIndirectSellingUNitCal.setScale(0) != 0) || proposedTotalUnits > 0) {
                                blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c =  blItem.Phoenix_SCM_Qty_Approved_Indirect__c;
                               
                            } else {
                                blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = totalOverride > 0 ? (overRidecurrentOSUnits + overRidecurrWMTIndirectUnits): blItem.Phoenix_Current_Indirect_Selling_Unit__c;
                            }
                            
                        }
                } 
                    
                    if (blItem.Phoenix_SCM_Final_Approval__c == false) {
                        
                        if ((overRidecurrentOSUnits + overRidecurWMTDirectUnits + overRidecurrWMTIndirectUnits) == 0) {
                            blItem.Phoenix_Current_Direct_Selling_Unit__c = curWMTDirectUnits;
                            blItem.Phoenix_Current_Indirect_Selling_Unit__c = currentOSUnits + currWMTIndirectUnits;
                        } else {
                            blItem.Phoenix_Current_Direct_Selling_Unit__c = overRidecurWMTDirectUnits;
                            blItem.Phoenix_Current_Indirect_Selling_Unit__c = overRidecurrentOSUnits + overRidecurrWMTIndirectUnits;
                        }
                        
                        // Decimal totalUnitsPrpoosed = proposedWMTUnits + ProsedOSUnits + ProsedRADUnits ;
                        //Decimal curUnitsTotals = currentOSUnits + curWMTDirectUnits + currWMTIndirectUnits ;
                        blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = finalDirectUnits;
                        blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = finalIndirectUnits;
                        blItem.Phoenix_Proposed_Direct_Selling_Unit__c = proposedWMTUnits;
                        blItem.Phoenix_Proposed_Indirect_Selling_Unit__c = ProsedOSUnits + ProsedRADUnits;
                        
                    }else{
                        if ((overRidecurrentOSUnits + overRidecurWMTDirectUnits + overRidecurrWMTIndirectUnits) == 0) {
                            blItem.Phoenix_Current_Direct_Selling_Unit__c = curWMTDirectUnits;
                            blItem.Phoenix_Current_Indirect_Selling_Unit__c = currentOSUnits + currWMTIndirectUnits;
                        } else {
                            blItem.Phoenix_Current_Direct_Selling_Unit__c = overRidecurWMTDirectUnits;
                            blItem.Phoenix_Current_Indirect_Selling_Unit__c = overRidecurrentOSUnits + overRidecurrWMTIndirectUnits;
                        }
                        blItem.Phoenix_Proposed_Direct_Selling_Unit__c = blItem.Phoenix_Proposed_WMT_Units__c != null ? blItem.Phoenix_Proposed_WMT_Units__c : 0;
                        blItem.Phoenix_Proposed_Indirect_Selling_Unit__c = (blItem.Phoenix_Proposed_OS_Units__c != null ? blItem.Phoenix_Proposed_OS_Units__c : 0) + (blItem.Phoenix_Proposed_RAD_Units__c != null ? blItem.Phoenix_Proposed_RAD_Units__c : 0);
                        Decimal finalScmApprovedUnits = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                        Decimal ProsedOSUnits1 = (proposedTotalUnits > 0) ? (blItem.Phoenix_Proposed_OS_Units__c != null ? blItem.Phoenix_Proposed_OS_Units__c : 0) : 0;
                        Decimal ProsedRADUnits1 = (proposedTotalUnits > 0) ? (blItem.Phoenix_Proposed_RAD_Units__c != null ? blItem.Phoenix_Proposed_RAD_Units__c : 0):0;
                        Decimal totalUnits = 0;
                        totalUnits = ProsedOSUnits1 + ProsedRADUnits1;
                        Decimal finalApprovedOSUnits = totalUnits != 0 ? ((ProsedOSUnits1 / totalUnits) * finalScmApprovedUnits) : 0;
                        Decimal finalApprovedRADUnits = totalUnits != 0 ? ((ProsedRADUnits1 / totalUnits) * finalScmApprovedUnits) : 0;
                        // Final OS Approved Units
                        blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c = finalApprovedOSUnits;
                        blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c = finalApprovedRADUnits;
                                
                    }
                    Decimal scmWMTUnits = (blItem.Phoenix_Final_Direct_Selling_Units_Calc__c != null ? blItem.Phoenix_Final_Direct_Selling_Units_Calc__c:0) ;
                    Decimal scmOSUnts = (blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c != null ? blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c:0);
                    Decimal scmRADUnits = (blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c != null ? blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c:0) ;
                    Decimal totalSCMApprovedUnits = (blItem.Phoenix_Final_Direct_Selling_Units_Calc__c != null ? blItem.Phoenix_Final_Direct_Selling_Units_Calc__c:0) + (blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c != null ? blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c:0) +(blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c != null ? blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c:0) ;
                    totalSCMApprovedUnits = (blItem.Phoenix_SCM_Final_Approval__c == true) ? totalSCMApprovedUnits : 0;
                    blItem.Phoenix_OS_RAD_NCP__c = (blItem.Phoenix_OS_RAD_CP__c != null ? blItem.Phoenix_OS_RAD_CP__c : 0) - (blItem.Phoenix_OS_RAD_PUR__c != null ? blItem.Phoenix_OS_RAD_PUR__c : 0);
                    blItem.Phoenix_OS_RAD_NCP__c = (blItem.Phoenix_OS_RAD_NCP__c < 0 ) ? 0 : blItem.Phoenix_OS_RAD_NCP__c;
                    blItem.Phoenix_WMT_Direct_NCP__c = (blItem.Phoenix_WMT_Direct_CP__c != null ? blItem.Phoenix_WMT_Direct_CP__c : 0) - (blItem.Phoenix_WMT_Direct_PUR__c != null ? blItem.Phoenix_WMT_Direct_PUR__c : 0);
                    blItem.Phoenix_WMT_Direct_NCP__c = (blItem.Phoenix_WMT_Direct_NCP__c < 0) ? 0 : blItem.Phoenix_WMT_Direct_NCP__c;
                    blItem.Phoenix_WMT_Indirect_NCP__c = (blItem.Phoenix_WMT_Indirect_CP__c != null ? blItem.Phoenix_WMT_Indirect_CP__c : 0) - (blItem.Phoenix_WMT_Indirect_PUR__c != null ? blItem.Phoenix_WMT_Indirect_PUR__c : 0);
                    blItem.Phoenix_WMT_Indirect_NCP__c = (blItem.Phoenix_WMT_Indirect_NCP__c < 0) ? 0 :blItem.Phoenix_WMT_Indirect_NCP__c;
                    Decimal wacPrice = blItem.Phoenix_WAC1__c != null ? blItem.Phoenix_WAC1__c:0;
                    decimal globalRebate = (blItem.Phoenix_OS_RAD_NCP__c * (blItem.Phoenix_Current_Rebate__c != null ? (blItem.Phoenix_Current_Rebate__c / 100) : 0)).setScale(4);
                    decimal adminFee = (blItem.Phoenix_OS_RAD_NCP__c * (blItem.Phoenix_Current_Admin_Fee__c != null ? (blItem.Phoenix_Current_Admin_Fee__c / 100) : 0)).setScale(4);
                    decimal cashTerms = (wacPrice * (blItem.Phoenix_Cash_Terms__c != null ? (blItem.Phoenix_Cash_Terms__c / 100) : 0)).setScale(4);
                    decimal rdcNCL = (wacPrice * (blItem.Phoenix_RDC_NLC__c != null ? (blItem.Phoenix_RDC_NLC__c / 100) : 0)).setScale(4);
                    blItem.Phoenix_Customer_Dead_Net1__c = (blItem.Phoenix_OS_RAD_NCP__c > 0) ? (blItem.Phoenix_OS_RAD_NCP__c - globalRebate - adminFee - cashTerms - rdcNCL) : 0;
                    blItem.Phoenix_Customer_Dead_Net1__c = (blItem.Phoenix_Customer_Dead_Net1__c > 0)? blItem.Phoenix_Customer_Dead_Net1__c : 0;
                    decimal dataFee = (blItem.Phoenix_OS_RAD_NCP__c * (blItem.Phoenix_Date_Fee__c != null ? (blItem.Phoenix_Date_Fee__c / 100) : 0)).setScale(4);
                    blItem.Phoenix_Current_McK_RAD_Dead_net__c = (blItem.Phoenix_Customer_Dead_Net1__c > 0) ? blItem.Phoenix_Customer_Dead_Net1__c - dataFee :0;
                    decimal globalRebateWMTDirect = blItem.Phoenix_WMT_Direct_NCP__c * (blItem.Phoenix_Invoice_Allowance__c != null ? (blItem.Phoenix_Invoice_Allowance__c / 100) : 0);
                    decimal adminFeeWMTDirect = blItem.Phoenix_WMT_Direct_NCP__c * (blItem.Phoenix_Current_Admin_Fee__c != null ? (blItem.Phoenix_Current_Admin_Fee__c / 100) : 0);
                    decimal cashTermsWMTDirect = blItem.Phoenix_WMT_Direct_NCP__c * (blItem.Phoenix_Cash_Terms__c != null ? (blItem.Phoenix_Cash_Terms__c / 100) : 0);
                    blItem.Phoenix_Current_WMT_Direct_Dead_net__c = (blItem.Phoenix_WMT_Direct_NCP__c >0) ? (blItem.Phoenix_WMT_Direct_NCP__c - globalRebateWMTDirect - adminFeeWMTDirect - cashTermsWMTDirect) : 0 ;
                    blItem.Phoenix_Current_WMT_Direct_Dead_net__c = blItem.Phoenix_Current_WMT_Direct_Dead_net__c > 0 ? blItem.Phoenix_Current_WMT_Direct_Dead_net__c :0;
                    decimal cmFeesWMTIndirect = blItem.Phoenix_WMT_Indirect_NCP__c * (blItem.Phoenix_Retail_Indirect_Wholesaler_Fee__c != null ? (blItem.Phoenix_Retail_Indirect_Wholesaler_Fee__c / 100) : 0);
                    decimal adminFeeWMTIndirect = blItem.Phoenix_WMT_Indirect_NCP__c * (blItem.Phoenix_Current_Admin_Fee__c != null ? (blItem.Phoenix_Current_Admin_Fee__c / 100) : 0);
                    decimal cashTermsWMTIndirect = wacPrice * (blItem.Phoenix_Cash_Terms__c != null ? (blItem.Phoenix_Cash_Terms__c / 100) : 0);
                    decimal indirectZITD = blItem.Phoenix_WMT_Indirect_NCP__c - blItem.Phoenix_WMT_Direct_NCP__c;
                    blItem.Phoenix_Current_WMT_Indirect_Dead_net__c = (blItem.Phoenix_WMT_Indirect_NCP__c >0) ? (blItem.Phoenix_WMT_Indirect_NCP__c - adminFeeWMTIndirect - cmFeesWMTIndirect - cashTermsWMTIndirect - indirectZITD) : 0;
                    blItem.Phoenix_Current_WMT_Indirect_Dead_net__c = blItem.Phoenix_Current_WMT_Indirect_Dead_net__c >0 ? blItem.Phoenix_Current_WMT_Indirect_Dead_net__c :0;
                    /** Anda VIP Used for Data Fee in ClarusOne **/
                    Decimal finalMacRADOSPrice = blItem.Phoenix_Proposed_McK_OS_And_RAD_NCP__c != null ? blItem.Phoenix_Proposed_McK_OS_And_RAD_NCP__c : blItem.Phoenix_Sales_Proposed_NCP_McK_And_RAD__c != null ? blItem.Phoenix_Sales_Proposed_NCP_McK_And_RAD__c : blItem.Phoenix_OS_RAD_NCP__c;
                    blItem.Phoenix_Anda_VIP__c = (finalMacRADOSPrice * (bidRec.Phoenix_Customer__r.Phoenix_ABS__c != null ? (bidRec.Phoenix_Customer__r.Phoenix_ABS__c/ 100) : 0)).setScale(4);
                    Decimal proposedAdminFee = (blItem.Phoenix_Admin_Fee_Proposed_McK_OS_RAD__c != null ? blItem.Phoenix_Admin_Fee_Proposed_McK_OS_RAD__c : 0);
                    Decimal ProposedCashterms = (blItem.Phoenix_Cash_terms_Proposed_McK_OS_RAD__c != null ? blItem.Phoenix_Cash_terms_Proposed_McK_OS_RAD__c : 0);
                    blItem.Phoenix_Customer_Dead_Net_McK_RAD_Propse__c = (finalMacRADOSPrice > 0) ? (((finalMacRADOSPrice.setScale(2) - ((blItem.Phoenix_Customer_Rebates1__c).setScale(4) + (blItem.RDC_Proposed_McK_OS_RAD__c).setScale(4) + proposedAdminFee.setScale(4) + ProposedCashterms.setScale(4)))).setScale(4) ): 0;
                    blItem.Phoenix_Customer_Dead_Net_McK_RAD_Propse__c = blItem.Phoenix_Customer_Dead_Net_McK_RAD_Propse__c >0 ? blItem.Phoenix_Customer_Dead_Net_McK_RAD_Propse__c :0;
                    /** Anda Direct Dead Used for McK + RAD Dead net in ClarusOne **/
                    blItem.Phoenix_Direct_Dead_Net__c = (blItem.Phoenix_Customer_Dead_Net_McK_RAD_Propse__c > 0)? (blItem.Phoenix_Customer_Dead_Net_McK_RAD_Propse__c - (blItem.Phoenix_Anda_VIP__c).setScale(4)).setScale(4) : 0;
                    /** Anda Indirect Dead  Used for McK + RAD TPT $ in ClarusOne **/
                    blItem.Phoenix_Indirect_Dead_Net__c = blItem.Phoenix_Direct_Dead_Net__c > 0 ? (blItem.Phoenix_Direct_Dead_Net__c - (blItem.Phoenix_Throughput_Cost1__c != null ? blItem.Phoenix_Throughput_Cost1__c : 0)).setScale(4) : 0;
                    /** Used Direct TPT % for McK + RAD TPT % in ClarusOne **/
                    blItem.Proposed_TPT_Per_Direct__c = blItem.Phoenix_Direct_Dead_Net__c != 0 ? (blItem.Phoenix_Indirect_Dead_Net__c / blItem.Phoenix_Direct_Dead_Net__c) * 100 : 0;
                    /** Used Anda Old Acq for Stocking allowance per unitin ClarusOne **/
                    blItem.Phoenix_Anda_Old_Acqusition_Costs__c = (bidRec.Phoenix_Proposed_Initial_Order_Discount__c != null ? (bidRec.Phoenix_Proposed_Initial_Order_Discount__c / 100) : 0) * finalMacRADOSPrice;
                    /** Used Direct TPT % for Stocking allowance overall amountin ClarusOne **/
                    Decimal finalProposedOSRADUnits;
                    if(bidType == 'Price Change' || bidType == 'Customer Rebate Change'){
                        finalProposedOSRADUnits = (overRidecurrentOSUnits > 0 || totalOverride > 0)? overRidecurrentOSUnits : currentOSUnits;
                    }
                    else{
                        finalProposedOSRADUnits = ((ProsedOSUnits + ProsedRADUnits) > 0 || proposedTotalUnits !=0) ? (ProsedOSUnits + ProsedRADUnits) : (overRidecurrentOSUnits > 0 || totalOverride != 0) ? overRidecurrentOSUnits : currentOSUnits;
                        finalProposedOSRADUnits= totalSCMApprovedUnits > 0 ? (scmOSUnts + scmRADUnits) : finalProposedOSRADUnits; 
                    }
                   		
                    blItem.Phoenix_ANDA_IOD_Overall_Amount__c = (finalProposedOSRADUnits / 360) * blItem.Phoenix_Anda_Old_Acqusition_Costs__c * (bidRec.Phoenix_Initial_Order_Discount_of_Days__c != null ? bidRec.Phoenix_Initial_Order_Discount_of_Days__c : 0);
                    /**-- McK And RAD Net Sale --**/
                    Decimal total = ProsedOSUnits + ProsedRADUnits;
                    blItem.Proposed_Net_Sales_Direct__c = blItem.Phoenix_Direct_Dead_Net__c > 0 ? finalProposedOSRADUnits * (blItem.Phoenix_Direct_Dead_Net__c).setScale(4) - finalProposedOSRADUnits * (blItem.Phoenix_Estimated_Medicaid_Returns__c != null ? blItem.Phoenix_Estimated_Medicaid_Returns__c : 0) - blItem.Phoenix_ANDA_IOD_Overall_Amount__c : 0;
                    /**-- McK And RAD TPT $ --**/
                    blItem.Proposed_TPT_Indirect__c = blItem.Phoenix_Direct_Dead_Net__c > 0 ? blItem.Proposed_Net_Sales_Direct__c - (blItem.Phoenix_Throughput_Cost1__c != null ? blItem.Phoenix_Throughput_Cost1__c : 0) * finalProposedOSRADUnits : 0;
                    /**-- McK And RAD TPT % Margin --**/
                    blItem.Proposed_TPT_Per_Indirect__c = blItem.Proposed_Net_Sales_Direct__c != 0 ? ((blItem.Proposed_TPT_Indirect__c / blItem.Proposed_Net_Sales_Direct__c) * 100) : 0;
                    /**-- Invoice Allowance -- **/
                    Decimal directWMTNCP = (blItem.Phoenix_Proposed_WMT_Direct_NCP__c != null ? blItem.Phoenix_Proposed_WMT_Direct_NCP__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c : blItem.Phoenix_WMT_Direct_NCP__c);
                    Decimal finalrebate = blItem.Phoenix_Opening_Order_TPT_Per__c != null ? blItem.Phoenix_Opening_Order_TPT_Per__c : bidRec.Phoenix_WMT_Direct_Rebate__c != null ? bidRec.Phoenix_WMT_Direct_Rebate__c :0 ;
                    blItem.Phoenix_Current_Anda_Invoice_Price__c = directWMTNCP * (finalrebate != null ? (finalrebate/ 100) : 0);
                    /** Cash Terms WMT Direct --*/
                    blItem.Phoenix_Cash_Terms_RxSS__c = directWMTNCP * (bidRec.Phoenix_Customer__r.Phoenix_Cash_Discount__c != null ? (bidRec.Phoenix_Customer__r.Phoenix_Cash_Discount__c / 100) : 0);
                    Decimal adminFeePerct = (bidRec.Phoenix_Customer__r.Phoenix_Fee__c != null ? bidRec.Phoenix_Customer__r.Phoenix_Fee__c : 0);
                    blItem.Phoenix_Admin_Fee_WMT_Direct_NCP__c = directWMTNCP * (adminFeePerct / 100);
                    blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c = (directWMTNCP > 0) ? (directWMTNCP - blItem.Phoenix_Current_Anda_Invoice_Price__c - blItem.Phoenix_Cash_Terms_RxSS__c - blItem.Phoenix_Admin_Fee_WMT_Direct_NCP__c ) : 0;
                    blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c = blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c > 0 ? blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c  : 0;
                    /**-- WMT Direct TPT $ -- */
                    blItem.Phoenix_Retail_Direct_DRL_TPT__c = blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c > 0 ? blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c - (blItem.Phoenix_Throughput_Cost1__c != null ? blItem.Phoenix_Throughput_Cost1__c : 0) : 0;
                    /**-- WMT Direct TPT $ -- */
                    blItem.Phoenix_Sales_Out_Promotion_Proposed__c = blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c != 0 ? (blItem.Phoenix_Retail_Direct_DRL_TPT__c / blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c) * 100 : 0;
                    /** Admin Fee for WMT Indirect **/
                    Decimal indirectWMTNCP = (blItem.Phoenix_Proposed_WMT_Indirect_NCP__c != null ? blItem.Phoenix_Proposed_WMT_Indirect_NCP__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c : blItem.Phoenix_WMT_Indirect_NCP__c);
                    blItem.Phoenix_Anda_Admin_Fees__c = indirectWMTNCP * (adminFeePerct / 100);
                    //indirect cd
                    blItem.Phoenix_Charge_Back__c = wacPrice * (bidRec.Phoenix_Customer__r.Phoenix_Cash_Discount__c != null ? (bidRec.Phoenix_Customer__r.Phoenix_Cash_Discount__c / 100) : 0);
                    blItem.Phoenix_RDC_WMT_Indirect__c = wacPrice * (blItem.Phoenix_Proposed_Current_Rebate__c != null ? (blItem.Phoenix_Proposed_Current_Rebate__c / 100) : 0);
                    blItem.Phoenix_CM_Fee_WMT_Indirect__c = indirectWMTNCP * (blItem.Phoenix_Local_VIP__c != null ? (blItem.Phoenix_Local_VIP__c / 100) : 0);
                    Decimal ZITD = (indirectWMTNCP - directWMTNCP);
                    blItem.Phoenix_Current_Retail_Indirect_Price__c = (indirectWMTNCP > 0) ? (indirectWMTNCP - blItem.Phoenix_Charge_Back__c - blItem.Phoenix_Anda_Admin_Fees__c - blItem.Phoenix_RDC_WMT_Indirect__c - blItem.Phoenix_CM_Fee_WMT_Indirect__c-ZITD) : 0;
                    blItem.Phoenix_Current_Retail_Indirect_Price__c = blItem.Phoenix_Current_Retail_Indirect_Price__c > 0 ? blItem.Phoenix_Current_Retail_Indirect_Price__c:0;
                    blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c = blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c > 0 ? blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c : 0;
                    Decimal indirectDeandNet = blItem.Phoenix_Current_Retail_Indirect_Price__c > 0 ?  blItem.Phoenix_Current_Retail_Indirect_Price__c - (blItem.Phoenix_Throughput_Cost1__c != null ? blItem.Phoenix_Throughput_Cost1__c : 0) : 0;
                    blItem.Phoenix_Costco_TPT__c = indirectDeandNet;
                    blItem.Phoenix_Retail_Direct_DRL_TPT_Percent__c = blItem.Phoenix_Current_Retail_Indirect_Price__c != 0 ? (indirectDeandNet / blItem.Phoenix_Current_Retail_Indirect_Price__c) * 100 : 0;
                    blItem.Phoenix_Stocking_Allowance_Per_Unit__c = directWMTNCP * (bidRec.Phoenix_Proposed_Initial_Order_Discount__c != null ? bidRec.Phoenix_Proposed_Initial_Order_Discount__c / 100 : 0);
                    Decimal finalDirectWMTUnits,finalIndirectWMTUnits;
                    if(bidType == 'Price Change' || bidType == 'Customer Rebate Change'){
                        finalDirectWMTUnits = (overRidecurWMTDirectUnits > 0 || totalOverride > 0) ? overRidecurWMTDirectUnits : curWMTDirectUnits;
                        
                    }
                    finalIndirectWMTUnits = (overRidecurrWMTIndirectUnits > 0 || totalOverride > 0) ? overRidecurrWMTIndirectUnits : currWMTIndirectUnits;
                    Decimal finalWMTUnits = (proposedWMTUnits > 0 || proposedTotalUnits !=0) ? proposedWMTUnits : ((overRidecurWMTDirectUnits+overRidecurrWMTIndirectUnits) > 0 || totalOverride > 0) ? (overRidecurWMTDirectUnits+overRidecurrWMTIndirectUnits) : (curWMTDirectUnits + currWMTIndirectUnits);
                    finalWMTUnits = totalSCMApprovedUnits > 0 ? scmWMTUnits : finalWMTUnits;
                        blItem.Phoenix_WMT_Stck_Allowance_Overall_Amnt__c = ((finalWMTUnits / 360) * (blItem.Phoenix_Stocking_Allowance_Per_Unit__c) * (bidRec.Phoenix_Initial_Order_Discount_of_Days__c != null ? bidRec.Phoenix_Initial_Order_Discount_of_Days__c : 0)).setScale(4);
                    /**-- WMT Direct Net sales --**/
                    blItem.Phoenix_Retail_Indirect_Net_Sales__c = blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c > 0 ? (blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c * (finalDirectWMTUnits != null ? finalDirectWMTUnits :finalWMTUnits)) - blItem.Phoenix_WMT_Stck_Allowance_Overall_Amnt__c - ((blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c != null ? blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c : 0) * (finalDirectWMTUnits != null ? finalDirectWMTUnits : finalWMTUnits)) : 0;
                    /** DIrect TPT $ WMT ** **/
                    blItem.Phoenix_Wholesaler_DRL_TPT__c = (blItem.Phoenix_Retail_Indirect_Net_Sales__c > 0) ? (blItem.Phoenix_Retail_Indirect_Net_Sales__c - ((finalDirectWMTUnits != null ? finalDirectWMTUnits :finalWMTUnits) * (blItem.Phoenix_Throughput_Cost1__c != null ? blItem.Phoenix_Throughput_Cost1__c : 0))) : 0;
                    /** DIrect TPT Margin % WMT ** **/
                    blItem.Phoenix_Wholesaler_DRL_TPT_Percent__c = (blItem.Phoenix_Retail_Indirect_Net_Sales__c != 0) ? (blItem.Phoenix_Wholesaler_DRL_TPT__c / blItem.Phoenix_Retail_Indirect_Net_Sales__c) * 100 : 0;
                    Decimal indirectWMTUnits = blItem.Phoenix_WMT_Current_Indirect_Units__c != null ? blItem.Phoenix_WMT_Current_Indirect_Units__c : 0;
                    Decimal overRideUnits = blItem.Phoenix_Override_Current_Units__c != null ? blItem.Phoenix_Override_Current_Units__c : 0;
                    blItem.Phoenix_WMT_Indirect_Net_Sales__c = blItem.Phoenix_Current_Retail_Indirect_Price__c > 0 ? ((blItem.Phoenix_Current_Retail_Indirect_Price__c != null ? blItem.Phoenix_Current_Retail_Indirect_Price__c : 0) * (finalIndirectWMTUnits )) - ((finalIndirectWMTUnits) * (blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c != null ? blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c : 0)) : 0;
                    
                    blItem.Phoenix_WMT_Indirect_TPT__c = blItem.Phoenix_Current_Retail_Indirect_Price__c > 0 ? blItem.Phoenix_WMT_Indirect_Net_Sales__c - (finalIndirectWMTUnits * (blItem.Phoenix_Throughput_Cost1__c != null ? blItem.Phoenix_Throughput_Cost1__c : 0)) : 0;
                    if(bidType == 'RFP Bids' || bidType == 'Volume Review Only' || bidType== 'Customer Rebate Change' || bidType== 'Product Addition'){
                        blItem.Phoenix_WMT_Indirect_Net_Sales__c = 0;
                        blItem.Phoenix_WMT_Indirect_TPT__c = 0;
                    }
                    /** -- Total WMT Net Sales **/
                    blItem.Phoenix_Current_Anda_Net_Model_Units__c = blItem.Phoenix_WMT_Indirect_Net_Sales__c + blItem.Phoenix_Retail_Indirect_Net_Sales__c;
                    /** -- Total WMT TPT $ **/
                    blItem.Phoenix_Current_Anda_Units__c = blItem.Phoenix_WMT_Indirect_TPT__c + blItem.Phoenix_Wholesaler_DRL_TPT__c;
                   
                    /**--Total TPT % -- **/
                    blItem.Phoenix_Anda_DRL_TPT_Percent__c = (blItem.Phoenix_Current_Anda_Net_Model_Units__c > 0) ? (blItem.Phoenix_Current_Anda_Units__c / blItem.Phoenix_Current_Anda_Net_Model_Units__c) * 100 : 0;
                    /** -- Total Net Sales Combine -- **/
                    blItem.Phoenix_ProposedDirectGaintEagleUnits__c = blItem.Proposed_Net_Sales_Direct__c + blItem.Phoenix_Current_Anda_Net_Model_Units__c;
                    
                    /**-- Total TPT $ Combined -- **/
                    blItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c = blItem.Phoenix_Wholesaler_DRL_TPT__c + blItem.Phoenix_WMT_Indirect_TPT__c + blItem.Proposed_TPT_Indirect__c ;
                    blItem.Phoenix_Retail_Indirect_DRL_TPT_Percent__c = (blItem.Phoenix_ProposedDirectGaintEagleUnits__c > 0) ? (blItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c / blItem.Phoenix_ProposedDirectGaintEagleUnits__c) * 100 : 0;
                    Decimal proposedNCPMAcRAd = blItem.Phoenix_Proposed_McK_OS_And_RAD_NCP__c != null ? blItem.Phoenix_Proposed_McK_OS_And_RAD_NCP__c : blItem.Phoenix_Sales_Proposed_NCP_McK_And_RAD__c != null ? blItem.Phoenix_Sales_Proposed_NCP_McK_And_RAD__c : 0;
                    Decimal proposedWMTDirectNCP = (blItem.Phoenix_Proposed_WMT_Direct_NCP__c != null ? blItem.Phoenix_Proposed_WMT_Direct_NCP__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c : 0);
                    blItem.Phoenix_Reduc_in_NCP_McK_And_RAD__c = (blItem.Phoenix_OS_RAD_NCP__c > 0) ? ((proposedNCPMAcRAd / blItem.Phoenix_OS_RAD_NCP__c) - 1) * 100 : 0;
                    blItem.Phoenix_Reduction_in_NCP_WMT__c = (blItem.Phoenix_WMT_Direct_NCP__c > 0) ? ((proposedWMTDirectNCP / blItem.Phoenix_WMT_Direct_NCP__c) - 1) * 100 : 0;
                    /*-- internal Deadnet Price Calculation */
                    Decimal totalNetSales = blItem.Phoenix_WMT_Indirect_Net_Sales__c + blItem.Phoenix_Retail_Indirect_Net_Sales__c + blItem.Proposed_Net_Sales_Direct__c;
                    blItem.Phoenix_Internal_Dead_Net_Price__c = (finalDirectUnits + finalIndirectUnits) > 0 ? (totalNetSales / (finalDirectUnits + finalIndirectUnits)) : 0;
                    blItem.Phoenix_Net_Sales_Internal__c = blItem.Phoenix_WMT_Indirect_Net_Sales__c + blItem.Phoenix_Retail_Indirect_Net_Sales__c + blItem.Proposed_Net_Sales_Direct__c;
                   
                    // Net sales for Mack and OS 
                    blItem.Phoenix_Wholesaler_Net_Sales__c = (blItem.Phoenix_Current_McK_RAD_Dead_net__c != null ? blItem.Phoenix_Current_McK_RAD_Dead_net__c : 0) * ((overRidecurrentOSUnits !=0 || totalOverride > 0)? overRidecurrentOSUnits :currentOSUnits);
                    blItem.Phoenix_Wholesaler_Net_Sales__c = (blItem.Phoenix_Wholesaler_Net_Sales__c > 0 ? blItem.Phoenix_Wholesaler_Net_Sales__c : 0)  - (blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c  * ((overRidecurrentOSUnits !=0 || totalOverride > 0)? overRidecurrentOSUnits :currentOSUnits));
                    blItem.Phoenix_Wholesaler_Net_Sales__c =  blItem.Phoenix_Wholesaler_Net_Sales__c.setScale(0);
                    // Net Sales WMT Direct
                    blItem.Phoenix_Retail_Direct_Net_sales__c = (blItem.Phoenix_Current_WMT_Direct_Dead_net__c != null ? blItem.Phoenix_Current_WMT_Direct_Dead_net__c : 0) * ((overRidecurWMTDirectUnits != 0 || totalOverride > 0)? overRidecurWMTDirectUnits : curWMTDirectUnits);
                    blItem.Phoenix_Retail_Direct_Net_sales__c = (blItem.Phoenix_Retail_Direct_Net_sales__c > 0 ? blItem.Phoenix_Retail_Direct_Net_sales__c : 0)  - (blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c  * ((overRidecurWMTDirectUnits != 0 || totalOverride > 0)? overRidecurWMTDirectUnits : curWMTDirectUnits));
                    blItem.Phoenix_Retail_Direct_Net_sales__c = blItem.Phoenix_Retail_Direct_Net_sales__c.setScale(0);
                    // Net Sales WMT Indirect
                    blItem.Proposed_Net_Sales_Indirect__c = (blItem.Phoenix_Current_WMT_Indirect_Dead_net__c != null ? blItem.Phoenix_Current_WMT_Indirect_Dead_net__c : 0) * ((overRidecurrWMTIndirectUnits != 0 || totalOverride > 0) ?overRidecurrWMTIndirectUnits: currWMTIndirectUnits);
                    blItem.Proposed_Net_Sales_Indirect__c = (blItem.Proposed_Net_Sales_Indirect__c > 0 ? blItem.Proposed_Net_Sales_Indirect__c : 0)  - (blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c  * ((overRidecurrWMTIndirectUnits != 0 || totalOverride > 0) ?overRidecurrWMTIndirectUnits: currWMTIndirectUnits));
                    blItem.Proposed_Net_Sales_Indirect__c = blItem.Proposed_Net_Sales_Indirect__c.setScale(0);
                    
                     /*-- Total Current Sales --*/
                    blItem.Phoenix_Net_Sales_External__c = (blItem.Phoenix_Wholesaler_Net_Sales__c != null ? blItem.Phoenix_Wholesaler_Net_Sales__c : 0) + (blItem.Phoenix_Retail_Direct_Net_sales__c != null ? blItem.Phoenix_Retail_Direct_Net_sales__c : 0) + (blItem.Proposed_Net_Sales_Indirect__c != null ? blItem.Proposed_Net_Sales_Indirect__c : 0) ;
                    blItem.Phoenix_Final_Approved_Pricing_Contracts__c = directWMTNCP;
                    blItem.Phoenix_Proposed_Sales__c = blItem.Phoenix_ProposedDirectGaintEagleUnits__c != null ? blItem.Phoenix_ProposedDirectGaintEagleUnits__c : 0;
                   /* if(bidType == 'Price Change' || bidType == 'Customer Rebate Change'){
                        Decimal finalOSRADUnits = ( overRidecurrentOSUnits > 0 || totalOverride > 0)? overRidecurrentOSUnits: currentOSUnits;
                        Decimal finalDirWMTunits = ( overRidecurWMTDirectUnits > 0 || totalOverride > 0)? overRidecurWMTDirectUnits: curWMTDirectUnits;
                        Decimal finalWMTIndirectunits = ( overRidecurrWMTIndirectUnits > 0 || totalOverride > 0)? overRidecurrWMTIndirectUnits: currWMTIndirectUnits;
                        Decimal OSAndRADSales = (blItem.Phoenix_Direct_Dead_Net__c != null ? blItem.Phoenix_Direct_Dead_Net__c : 0) * finalOSRADUnits; 
                        Decimal WMTDirectSales = (blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c != null ? blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c  : 0)*finalDirWMTunits;
                        Decimal WMTIndirectSales = (blItem.Phoenix_Current_Retail_Indirect_Price__c != null ? blItem.Phoenix_Current_Retail_Indirect_Price__c  : 0)*finalWMTIndirectunits;
                        blItem.Phoenix_Proposed_Sales__c = OSAndRADSales + WMTDirectSales + WMTIndirectSales;
                        if(finalOSRADUnits > finalDirWMTunits && finalOSRADUnits > finalWMTIndirectunits){
                            blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Direct_Dead_Net__c;
                            blItem.Phoenix_Proposed_Sales__c = (blItem.Phoenix_Direct_Dead_Net__c != null ? blItem.Phoenix_Direct_Dead_Net__c : 0) * (finalDirectUnits + finalIndirectUnits); 
                        }else if(finalOSRADUnits < finalDirWMTunits && finalDirWMTunits > finalWMTIndirectunits){
                            Decimal wmtDirect = blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c != null ? blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c  : 0;
                            blItem.Phoenix_Internal_Dead_Net_Price__c = wmtDirect;
                            blItem.Phoenix_Proposed_Sales__c = blItem.Phoenix_Internal_Dead_Net_Price__c * (finalDirectUnits + finalIndirectUnits); 
                        }else{
                            Decimal wmtIndirect = blItem.Phoenix_Current_Retail_Indirect_Price__c != null ? blItem.Phoenix_Current_Retail_Indirect_Price__c  : 0;
                            blItem.Phoenix_Internal_Dead_Net_Price__c = wmtIndirect;
                            blItem.Phoenix_Proposed_Sales__c = blItem.Phoenix_Internal_Dead_Net_Price__c * (finalDirectUnits + finalIndirectUnits); 
                        }
                        
                    } */
                   /* else{
                        Decimal finalproposedWMTUnits = blItem.Phoenix_Proposed_WMT_Units__c !=null ? blItem.Phoenix_Proposed_WMT_Units__c : ((overRidecurWMTDirectUnits+overRidecurrWMTIndirectUnits) > 0 || totalOverride > 0)? (overRidecurWMTDirectUnits+overRidecurrWMTIndirectUnits):(curWMTDirectUnits+currWMTIndirectUnits);
                            Decimal finalProsedOSUnits = blItem.Phoenix_Proposed_OS_Units__c != null ? blItem.Phoenix_Proposed_OS_Units__c  :(overRidecurrentOSUnits > 0 || totalOverride > 0)  ? overRidecurrentOSUnits :currentOSUnits;
                        Decimal finalProsedRADUnits = blItem.Phoenix_Proposed_RAD_Units__c != null ? blItem.Phoenix_Proposed_RAD_Units__c  :(overRidecurrentOSUnits > 0 || totalOverride > 0) ? overRidecurrentOSUnits : currentOSUnits;
                        finalproposedWMTUnits = totalSCMApprovedUnits > 0 ? scmWMTUnits : finalproposedWMTUnits;
                        finalProsedOSUnits = totalSCMApprovedUnits > 0 ? scmOSUnts : finalProsedOSUnits;
                        finalProsedRADUnits= totalSCMApprovedUnits > 0 ? scmRADUnits : finalProsedRADUnits;
                        Decimal OSAndRADSales = (blItem.Phoenix_Direct_Dead_Net__c != null ? blItem.Phoenix_Direct_Dead_Net__c : 0) * (finalProsedOSUnits+finalProsedRADUnits); 
                        Decimal WMTDirectSales = (blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c != null ? blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c  : 0)*finalproposedWMTUnits;
                        Decimal WMTIndirectSales = (blItem.Phoenix_Current_Retail_Indirect_Price__c != null ? blItem.Phoenix_Current_Retail_Indirect_Price__c  : 0)*finalproposedWMTUnits;
                        blItem.Phoenix_Proposed_Sales__c = OSAndRADSales + WMTDirectSales + WMTIndirectSales;
                        
                       if((finalProsedOSUnits+finalProsedRADUnits) > finalproposedWMTUnits){
                            blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Direct_Dead_Net__c;
                            blItem.Phoenix_Proposed_Sales__c = (blItem.Phoenix_Direct_Dead_Net__c != null ? blItem.Phoenix_Direct_Dead_Net__c : 0) * (finalDirectUnits + finalIndirectUnits); 
                        }else{
                            Decimal wmtDirect = blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c != null ? blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c  : 0;
                            Decimal wmtIndirect = blItem.Phoenix_Current_Retail_Indirect_Price__c != null ? blItem.Phoenix_Current_Retail_Indirect_Price__c  : 0;
                            blItem.Phoenix_Internal_Dead_Net_Price__c = (wmtDirect > wmtIndirect) ? wmtDirect : wmtIndirect;
                            blItem.Phoenix_Proposed_Sales__c = blItem.Phoenix_Internal_Dead_Net_Price__c * (finalDirectUnits + finalIndirectUnits); 
                        }
                        
                    } */
                    
                   //New Product Launch
                    Decimal McklDeadNet = blItem.Phoenix_Direct_Dead_Net__c != null ? blItem.Phoenix_Direct_Dead_Net__c : 0; 
                    Decimal WMTDeadnet = blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c != null ? blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c : 0; 
                    Decimal brandwac =( blItem.Brand_WAC__c != null && blItem.Brand_WAC__c !=0)?blItem.Brand_WAC__c:0;
                    Decimal estReturnPerUnit = blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c != null ? blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c : 0;
                    blItem.Phoenix_Brand_WAC_Per__c = (brandwac != 0 && brandwac != null)? ( McklDeadNet / brandwac)*100 : 0;
                    blItem.Phoenix_NLC__c = (brandwac != 0 && brandwac != null) ? ( WMTDeadnet / brandwac)*100 : 0;
                    /* For MCK*/
                    Decimal  mckopeningorder= (blItem.Phoenix_Opening_Order__c != null && blItem.Phoenix_Opening_Order__c != 0)?blItem.Phoenix_Opening_Order__c :0;
                    blItem.Phoenix_Anda_Net_Model_Sales__c  = mckopeningorder > 0 && McklDeadNet > 0 ? (mckopeningorder * McklDeadNet) -(blItem.Phoenix_ANDA_IOD_Overall_Amount__c!=null ? blItem.Phoenix_ANDA_IOD_Overall_Amount__c:0) - (mckopeningorder * estReturnPerUnit):0;
					Decimal throughputcost1 = (blItem.Phoenix_Throughput_Cost1__c != null && blItem.Phoenix_Throughput_Cost1__c != 0)? blItem.Phoenix_Throughput_Cost1__c:0;
                    blItem.Phoenix_Wholesaler_Customer_Net_Price__c = mckopeningorder > 0 && McklDeadNet >0 ?(blITem.Phoenix_Anda_Net_Model_Sales__c!=null ? blItem.Phoenix_Anda_Net_Model_Sales__c : 0)-(mckopeningorder * throughputcost1):0;
                    blItem.Phoenix_Opening_Order_WMTTPT__c = ( mckopeningorder > 0 && McklDeadNet > 0 && blItem.Phoenix_Anda_Net_Model_Sales__c >0)?(blItem.Phoenix_Wholesaler_Customer_Net_Price__c/blItem.Phoenix_Anda_Net_Model_Sales__c)*100 : 0;
					 /* End For MCK*/
                     /* For WMT*/
                   	Decimal  wmtopeningorder= (blItem.Phoenix_Direct_Accerodo__c != null && blItem.Phoenix_Direct_Accerodo__c != 0)?blItem.Phoenix_Direct_Accerodo__c :0;
                    blItem.Phoenix_Opening_Order_Net_sales__c = wmtopeningorder > 0 && WMTDeadnet > 0 ? (wmtopeningorder * WMTDeadnet) - (blItem.Phoenix_WMT_Stck_Allowance_Overall_Amnt__c!=null ? blItem.Phoenix_WMT_Stck_Allowance_Overall_Amnt__c:0) - (wmtopeningorder * estReturnPerUnit) : 0;
                    Decimal openingOrdernetsales = (blItem.Phoenix_Opening_Order_Net_sales__c != null && blItem.Phoenix_Opening_Order_Net_sales__c != 0) ? blItem.Phoenix_Opening_Order_Net_sales__c : 0;
				    blItem.Phoenix_Opening_Order_TPT__c =  wmtopeningorder > 0 && WMTDeadnet > 0 ? openingOrdernetsales - (wmtopeningorder * throughputcost1) : 0;
                    Decimal openingordertptdl = (blItem.Phoenix_Opening_Order_TPT__c != null &&  blItem.Phoenix_Opening_Order_TPT__c != 0) ?blItem.Phoenix_Opening_Order_TPT__c :0 ;
                    blItem.Phoenix_Costco_TPTPer__c = (wmtopeningorder > 0 && WMTDeadnet > 0 && openingOrdernetsales !=0) ? (openingordertptdl / openingOrdernetsales)*100 :0 ;
					/* END For WMT*/
                    
                    //Added for Price and Volume Variane calcularions
                    Decimal ProposedOSUnits = blItem.Phoenix_SCM_Final_Approval__c == true ? (blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c!=null?blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c:0) : blItem.Phoenix_Proposed_OS_Units__c != null ? blItem.Phoenix_Proposed_OS_Units__c:0;
                    Decimal ProposedRADUnits = blItem.Phoenix_SCM_Final_Approval__c == true ? (blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c!=null?blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c:0) :  blItem.Phoenix_Proposed_RAD_Units__c != null ? blItem.Phoenix_Proposed_RAD_Units__c:0;
                    Decimal ProposedWMTUnit = blItem.Phoenix_SCM_Final_Approval__c == true ? (blItem.Phoenix_Final_Direct_Selling_Units_Calc__c!=null?blItem.Phoenix_Final_Direct_Selling_Units_Calc__c:0) :  blItem.Phoenix_Proposed_WMT_Units__c != null ? blItem.Phoenix_Proposed_WMT_Units__c:0;
                    Decimal currentOSRADUnits = (overRidecurrentOSUnits!=0 || totalOverride>0) ? overRidecurrentOSUnits : blItem.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c != null ? blItem.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c : 0;
                    Decimal currentWMTDirUnits = (overRidecurWMTDirectUnits != 0 || totalOverride>0) ? overRidecurWMTDirectUnits : blItem.Phoenix_WMT_Current_Direct_Units__c != null ? blItem.Phoenix_WMT_Current_Direct_Units__c : 0;
                    Decimal currentWMTIndireUnits = (overRidecurrWMTIndirectUnits != 0 || totalOverride>0) ? overRidecurrWMTIndirectUnits :  blItem.Phoenix_WMT_Current_Indirect_Units__c != null ? blItem.Phoenix_WMT_Current_Indirect_Units__c : 0;
                    
                    Decimal currentOSRADDeadnet =  blItem.Phoenix_Current_McK_RAD_Dead_net__c != null ? blItem.Phoenix_Current_McK_RAD_Dead_net__c : 0;
                    Decimal currentWMTDirDeadnet=  blItem.Phoenix_Current_WMT_Direct_Dead_net__c != null ? blItem.Phoenix_Current_WMT_Direct_Dead_net__c : 0;
                    Decimal currentWMTIndireDeadnet = blItem.Phoenix_Current_WMT_Indirect_Dead_net__c != null ? blItem.Phoenix_Current_WMT_Indirect_Dead_net__c : 0;
                    Decimal ProposedOSRADDeadnet = blItem.Phoenix_Direct_Dead_Net__c  != null ? blItem.Phoenix_Direct_Dead_Net__c  : 0;
                    Decimal ProposedWMTDirDeadnet= blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c != null ? blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c : 0;
                    Decimal ProposedWMTIndireDeadnet = blItem.Phoenix_Current_Retail_Indirect_Price__c != null ? blItem.Phoenix_Current_Retail_Indirect_Price__c : 0;
                    
                    Decimal priceDiffMCkRAD = ProposedOSRADDeadnet - currentOSRADDeadnet;
                    Decimal priceDiffWMTDirect = ProposedWMTDirDeadnet-currentWMTDirDeadnet;
                    Decimal priceDiffWMTIndirect = ProposedWMTIndireDeadnet - currentWMTIndireDeadnet;
                    
                    Decimal volumeDifMackRAD = (ProposedOSUnits+ProposedRADUnits) - currentOSRADUnits;
                    Decimal volumeDifWMTDir = ProposedWMTUnit - currentWMTDirUnits;
                    Decimal volumeDifWMTIndir = -currentWMTIndireUnits;
                    
                    Decimal priceVarianceMckRAd = priceDiffMCkRAD * currentOSRADUnits;
                    Decimal priceVarianceWMTDir = priceDiffWMTDirect * currentWMTDirUnits;
                    Decimal priceVarianceWMTIndir = priceDiffWMTIndirect*currentWMTIndireUnits;
                    
                    Decimal volumeVarianceMckRAD = volumeDifMackRAD * priceDiffMCkRAD;
                    Decimal volumeVaianceWMTDir = volumeDifWMTDir * priceDiffWMTDirect;
                    Decimal volumeVarianceWMTIndir = volumeDifWMTIndir * priceDiffWMTIndirect;
                    blItem.Phoenix_Price_Variance__c = (bidType == 'Sales Out Rebate' || bidType == 'Price Change' || bidType == 'Customer Rebate Change' ||  bidType == 'RFP Bids') ? (priceVarianceMckRAd + priceVarianceWMTDir+priceVarianceWMTIndir):0;
                    blItem.Phoenix_Volume_Variance__c = (bidType == 'Sales Out Rebate' || bidType == 'Price Change' || bidType == 'Customer Rebate Change') ? 0 : (volumeVarianceMckRAD + volumeVaianceWMTDir+volumeVarianceWMTIndir) ;  
                        
                    // SSA Hit Calculation 
                    Decimal DiffPrice = (blItem.Phoenix_Proposed_WMT_Direct_NCP__c != null ? blItem.Phoenix_Proposed_WMT_Direct_NCP__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c :0) - (blItem.Phoenix_WMT_Direct_NCP__c!= null ? blItem.Phoenix_WMT_Direct_NCP__c : 0);
                    Decimal SSANoofDays = (bidRec.Phoenix_Proposed_SSA_No_of_Days__c != null ? bidRec.Phoenix_Proposed_SSA_No_of_Days__c :0)/30;
                    blItem.Phoenix_SSA_Hit_Updated__c = DiffPrice * SSANoofDays * (currentWMTDirUnits/12);
                    
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