/**
* @description       : 
* @author            : Surender Patel (Dhruvsoft)
* @group             : 
* @last modified on  : 02-06-2021
* @last modified by  : Surender Patel (Dhruvsoft)
* Modifications Log 
* Ver   Date         Author                       Modification
* 1.0   02-06-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
trigger Phoenix_BidLineItemTrigger on Phoenix_Bid_Line_Item__c(before insert, after insert, before update, after update) {
    List<Trigger_Validation__c> tv = Trigger_Validation__c.getall().values();
    boolean proceedOrNot = true;
    if(tv.size()>0){
        if(!tv[0].BidLineItem_Trigger__c)
            proceedOrNot = false;
    }
    if(proceedOrNot){
        if (trigger.isBefore && !Phoenix_Util.blnAlreadyDone){
            String bidType;
            Decimal initialOrderDays = 0;
            Decimal initialOrderDisc = 0;
            Phoenix_Bid__c bidRecord;
            
            if (trigger.isUpdate) {
                bidRecord = [SELECT Id, Phoenix_is_OTC_Bid__c,Phoenix_Customer_Type__c, Phoenix_Customer__r.Phoenix_Rebates__c,Phoenix_Customer__r.Phoenix_Cash_Discount__c ,Phoenix_Customer__r.Phoenix_Fee__c,Phoenix_Customer__r.Phoenix_CM_Fees__c,Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Current_CD__c,Phoenix_Approval_Status__c, Phoenix_Bid_Proposed_Position__c, Phoenix_Custom_type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Cash_Terms__c, Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =: Trigger.new[0].Phoenix_Bid__c];
                System.debug('----------bidRecord---------*************---'+bidRecord.Phoenix_Proposed_Cash_Terms__c);
                //bidType = [SELECT Id,Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Bid__r.Phoenix_Bid_Type__c  FROM Phoenix_Bid_Line_Item__c WHERE Id =: Trigger.new[0].Id LIMIT 1].Phoenix_Bid__r.Phoenix_Bid_Type__c ;
                bidType = bidRecord.Phoenix_Bid_Type__c;
                system.debug('*** bidRecord.Phoenix_Customer_Type__c :::: '+bidRecord.Phoenix_Customer_Type__c);
                initialOrderDays = bidRecord.Phoenix_Initial_Order_Discount_of_Days__c != null ? bidRecord.Phoenix_Initial_Order_Discount_of_Days__c : 0;
                initialOrderDisc = bidRecord.Phoenix_Proposed_Initial_Order_Discount__c != null ? bidRecord.Phoenix_Proposed_Initial_Order_Discount__c : 0;
            }
            if (trigger.isInsert || trigger.isUpdate) {
                Phoenix_Bid__c bidRec = [SELECT Id,Phoenix_is_OTC_Bid__c,Phoenix_Customer_Type__c, Phoenix_Customer__r.Phoenix_Rebates__c,Phoenix_Customer__r.Phoenix_Cash_Discount__c ,Phoenix_Customer__r.Phoenix_Fee__c,Phoenix_Customer__r.Phoenix_CM_Fees__c,Phoenix_Bid_Proposed_Position__c, Phoenix_Approval_Status__c,Phoenix_Proposed_Cash_Terms__c,Phoenix_Initial_Order_Discount_Type__c, Phoenix_Custom_type__c, Phoenix_Current_CD__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =: Trigger.new[0].Phoenix_Bid__c];
                
                // initialOrderDays = bidRec.Phoenix_Initial_Order_Discount_of_Days__c != null? bidRec.Phoenix_Initial_Order_Discount_of_Days__c : 0 ;
                // initialOrderDisc=bidRec.Phoenix_Proposed_Initial_Order_Discount__c != null? bidRec.Phoenix_Proposed_Initial_Order_Discount__c : 0 ;
                
                if (bidRec.Phoenix_Bid_Type__c == 'Short Dated OTB'|| bidRec.Phoenix_Bid_Type__c == 'Good Dated OTB' || bidRec.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' 
                    || bidRec.Phoenix_Bid_Type__c == 'Platform OTB'|| bidRec.Phoenix_Bid_Type__c == 'Platform PO OTB') {
                        new Phoenix_BidItemHandlerOTB().run();  
                    }
                else{
                    for (Phoenix_Bid_Line_Item__c blItem: Trigger.new) {
                        
                        
                        if (bidRec.Phoenix_Bid_Proposed_Position__c != null) {
                            //blItem.Phoenix_Proposed_Position__c=bidRec.Phoenix_Bid_Proposed_Position__c;
                            
                        }
                        system.debug('Phoenix_SCM_Final_Approval__c---->' + blItem.Phoenix_SCM_Final_Approval__c);
                        if (blItem.Phoenix_SCM_Final_Approval__c == true) { // added by jogarao for SCM qty calculaions
                            decimal percenalOfQty = 0;
                            if (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null && blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null && blItem.Phoenix_Total_SCM_Approved_Qty__c != null && (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c + blItem.Phoenix_Proposed_Direct_Selling_Unit__c) != 0) {
                                percenalOfQty = (blItem.Phoenix_Total_SCM_Approved_Qty__c / 12) / (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c + blItem.Phoenix_Proposed_Direct_Selling_Unit__c);
                                blItem.Phoenix_Qty_Approved_By_SCM__c = percenalOfQty;
                            } 
                            else if (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null && blItem.Phoenix_Total_SCM_Approved_Qty__c != null && blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != 0) {
                                percenalOfQty = (blItem.Phoenix_Total_SCM_Approved_Qty__c / 12) / (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c);
                                blItem.Phoenix_Qty_Approved_By_SCM__c = percenalOfQty;
                            } else if (blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null && blItem.Phoenix_Total_SCM_Approved_Qty__c != null && blItem.Phoenix_Proposed_Direct_Selling_Unit__c != 0) {
                                percenalOfQty = (blItem.Phoenix_Total_SCM_Approved_Qty__c / 12) / (blItem.Phoenix_Proposed_Direct_Selling_Unit__c);
                                blItem.Phoenix_Qty_Approved_By_SCM__c = percenalOfQty;
                            }
                            system.debug('percenalOfQty--->' + percenalOfQty);
                            if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Only Current Monthly Demand Approved') {
                                if (blItem.Phoenix_Current_Direct_Selling_Unit__c != null)
                                    blItem.Phoenix_SCM_Qty_Approved_Direct__c = blItem.Phoenix_Override_Current_Direct_Units__c != null ? blItem.Phoenix_Override_Current_Direct_Units__c : blItem.Phoenix_Current_Direct_Selling_Unit__c;
                                else
                                    blItem.Phoenix_SCM_Qty_Approved_Direct__c = 0;
                            }
                            if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Current + Inc Demand Approved' && blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null) {
                                blItem.Phoenix_SCM_Qty_Approved_Direct__c = blItem.Phoenix_Proposed_Direct_Selling_Unit__c * percenalOfQty * 12;
                            } else if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Current + Inc Demand Approved') {  blItem.Phoenix_SCM_Qty_Approved_Direct__c = 0;
                                                                                                                 }
                            if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Only Current Monthly Demand Approved' && blItem.Phoenix_Current_Indirect_Selling_Unit__c != null) {
                                blItem.Phoenix_SCM_Qty_Approved_Indirect__c =blItem.Phoenix_Override_Current_Indirect_Units__c != null ? blItem.Phoenix_Override_Current_Indirect_Units__c : blItem.Phoenix_Current_Indirect_Selling_Unit__c;
                            } else if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Only Current Monthly Demand Approved') {      blItem.Phoenix_SCM_Qty_Approved_Indirect__c = 0;
                                                                                                                        }
                            if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Current + Inc Demand Approved' && blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null) {
                                blItem.Phoenix_SCM_Qty_Approved_Indirect__c = blItem.Phoenix_Proposed_Indirect_Selling_Unit__c * percenalOfQty * 12;
                            } else if (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Current + Inc Demand Approved') { blItem.Phoenix_SCM_Qty_Approved_Indirect__c = 0;
                                                                                                                 }
                            if (blItem.Phoenix_SCM_Final_Approval__c == true && (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Only Current Monthly Demand Approved' || blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Current + Inc Demand Approved')) {
                                decimal finalDirectSellingUNitCal = 0, finalIndirectSellingUNitCal = 0;
                                finalDirectSellingUNitCal = blItem.Phoenix_SCM_Qty_Approved_Direct__c;
                                if (blItem.Phoenix_SCM_Qty_Approved_Direct__c != null && finalDirectSellingUNitCal.setScale(0) != 0) {
                                    blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = blItem.Phoenix_SCM_Qty_Approved_Direct__c;
                                } else {
                                    blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = blItem.Phoenix_Current_Direct_Selling_Unit__c;
                                }
                                system.debug('blItem.Phoenix_Final_Direct_Selling_Units_Calc__c--->' + blItem.Phoenix_Final_Direct_Selling_Units_Calc__c);
                                finalIndirectSellingUNitCal = blItem.Phoenix_SCM_Qty_Approved_Indirect__c;
                                if (blItem.Phoenix_SCM_Qty_Approved_Indirect__c != null && finalIndirectSellingUNitCal.setScale(0) != 0) {
                                    blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = blItem.Phoenix_SCM_Qty_Approved_Indirect__c;
                                    //ClarusOne Approved Units
                                    if (blItem.Phoenix_Bid_Template_Refrence__c == 'ClarusOne') {
                                        Decimal finalScmApprovedUnits = blItem.Phoenix_SCM_Qty_Approved_Indirect__c;
                                        Decimal ProsedOSUnits = blItem.Phoenix_Proposed_OS_Units__c != null ? blItem.Phoenix_Proposed_OS_Units__c : 0;
                                        Decimal ProsedRADUnits = blItem.Phoenix_Proposed_RAD_Units__c != null ? blItem.Phoenix_Proposed_RAD_Units__c : 0;
                                        Decimal proposedWMTUnits = blItem.Phoenix_Proposed_WMT_Units__c != null ? blItem.Phoenix_Proposed_WMT_Units__c : 0;
                                        Decimal totalUnits = 0;
                                        totalUnits = ProsedOSUnits + ProsedRADUnits;
                                        Decimal finalApprovedOSUnits = totalUnits != 0 ? ((ProsedOSUnits / totalUnits) * finalScmApprovedUnits) : 0;
                                        Decimal finalApprovedRADUnits = totalUnits != 0 ? ((ProsedRADUnits / totalUnits) * finalScmApprovedUnits) : 0;
                                        system.debug('finalApprovedOSUnits---->' + ProsedOSUnits);
                                        system.debug('finalApprovedOSUnits---->' + ProsedRADUnits);
                                        system.debug('finalApprovedOSUnits---->' + finalApprovedOSUnits);
                                        system.debug('finalApprovedRADUnits---->' + finalApprovedRADUnits);
                                        system.debug('finalScmApprovedUnits---->' + finalScmApprovedUnits);
                                        // Final OS Approved Units
                                        blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c = finalApprovedOSUnits;
                                        blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c = finalApprovedRADUnits;
                                        
                                    }
                                    
                                    
                                } else {
                                    blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = blItem.Phoenix_Current_Indirect_Selling_Unit__c;
                                }
                                
                            }
                        } 
                        else {
                            Decimal currentIndirectUnits = blItem.Phoenix_Current_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Current_Indirect_Selling_Unit__c : 0;
                            Decimal currentDirectUnits = blItem.Phoenix_Current_Direct_Selling_Unit__c != null ? blItem.Phoenix_Current_Direct_Selling_Unit__c : 0;
                            Decimal OverrideUnits = blItem.Phoenix_Override_Current_Units__c != null ? blItem.Phoenix_Override_Current_Units__c : 0;
                            Decimal finalDirectUnits = 0, finalIndirectUnits = 0;
                            if (currentDirectUnits + currentIndirectUnits != 0) {
                                finalDirectUnits = (currentDirectUnits / (currentDirectUnits + currentIndirectUnits)) * OverrideUnits;
                                finalIndirectUnits = (currentIndirectUnits / (currentDirectUnits + currentIndirectUnits)) * OverrideUnits;
                            } else {  finalDirectUnits = OverrideUnits / 2;
                                    finalIndirectUnits = OverrideUnits / 2;
                                   }
                            if (bidRec != null && bidRec.Phoenix_Customer_Type__c == 'Walgreens' || bidRec.Phoenix_Customer_Type__c == 'ABC Progen') {
                                blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != 0 && blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null) ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c : (finalIndirectUnits != 0) ? (finalIndirectUnits * 2) : (blItem.Phoenix_Current_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Current_Indirect_Selling_Unit__c : 0);
                                    blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = (blItem.Phoenix_Proposed_Direct_Selling_Unit__c != 0 && blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null) ? blItem.Phoenix_Proposed_Direct_Selling_Unit__c : (blItem.Phoenix_Current_Direct_Selling_Unit__c != null ? blItem.Phoenix_Current_Direct_Selling_Unit__c : 0);
                                        } else {
                                            blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != 0 && blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null) ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c : (blItem.Phoenix_Current_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Current_Indirect_Selling_Unit__c : 0);
                                                blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = (blItem.Phoenix_Proposed_Direct_Selling_Unit__c != 0 && blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null) ? blItem.Phoenix_Proposed_Direct_Selling_Unit__c : (blItem.Phoenix_Current_Direct_Selling_Unit__c != null ? blItem.Phoenix_Current_Direct_Selling_Unit__c : 0);
                                                    }
                            system.debug('blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c---->' + blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c);
                            system.debug('blItem.Phoenix_Final_Direct_Selling_Units_Calc__c---->' + blItem.Phoenix_Final_Direct_Selling_Units_Calc__c);
                            
                            //added jogarao for Total Selling Units
                            /* Decimal TotalSellingUbnits = 0;
if( blItem.Phoenix_Override_Current_Units__c  != 0 && blItem.Phoenix_Override_Current_Direct_Units__c != 0 && blItem.Phoenix_Override_Current_Units__c  != null && blItem.Phoenix_Override_Current_Direct_Units__c != null ){
blItem.Phoenix_Total_Selling_Units_Internal_Use__c = blItem.Phoenix_Override_Current_Units__c + blItem.Phoenix_Override_Current_Direct_Units__c;
}
else if(blItem.Phoenix_Override_Current_Units__c  != 0 && blItem.Phoenix_Override_Current_Units__c  != null && blItem.Phoenix_Current_Direct_Selling_Unit__c != null){
blItem.Phoenix_Total_Selling_Units_Internal_Use__c = blItem.Phoenix_Override_Current_Units__c + blItem.Phoenix_Current_Direct_Selling_Unit__c;
}else if(blItem.Phoenix_Override_Current_Direct_Units__c != 0 && blItem.Phoenix_Override_Current_Direct_Units__c != null && blItem.Phoenix_Current_Indirect_Selling_Unit__c != null) {
blItem.Phoenix_Total_Selling_Units_Internal_Use__c = blItem.Phoenix_Override_Current_Direct_Units__c + blItem.Phoenix_Current_Indirect_Selling_Unit__c;
}else if(blItem.Phoenix_Current_Indirect_Selling_Unit__c != null && blItem.Phoenix_Current_Direct_Selling_Unit__c != null){
blItem.Phoenix_Total_Selling_Units_Internal_Use__c = blItem.Phoenix_Current_Indirect_Selling_Unit__c + blItem.Phoenix_Current_Direct_Selling_Unit__c;
}else if(blItem.Phoenix_Current_Indirect_Selling_Unit__c != null){
blItem.Phoenix_Total_Selling_Units_Internal_Use__c = blItem.Phoenix_Current_Indirect_Selling_Unit__c ;
}else if(blItem.Phoenix_Current_Direct_Selling_Unit__c != null){
blItem.Phoenix_Total_Selling_Units_Internal_Use__c = blItem.Phoenix_Current_Direct_Selling_Unit__c ;
}*/
                            
                        }
                        
                        /** New logic added by Jogarao for Approval status of bid line item --*/
                        if(bidRec.Phoenix_Approval_Status__c != 'Draft' &&  bidRec.Phoenix_Approval_Status__c != 'Closed' && bidRec.Phoenix_Approval_Status__c != 'Closed-Draft' && bidRec.Phoenix_Approval_Status__c != 'On Hold' && blItem.Phoenix_Final_Status__c != 'Not Approved'){blItem.Phoenix_Bid_Line_Item_Approval_Status__c = bidRec.Phoenix_Approval_Status__c + ' Pending';
                                                                                                                                                                                                                                                                                       }
                        if(blItem.Phoenix_SCM_Approval_Y_N__c == 'N- Not Approved' && blItem.Phoenix_Final_Status__c == 'Not Approved'){blItem.Phoenix_Bid_Line_Item_Approval_Status__c = 'SCM Rejected';
                                                                                                                                       }
                        if(blItem.Phoenix_Marketing_Approval__c == 'Not Approved' && blItem.Phoenix_Final_Status__c == 'Not Approved'){blItem.Phoenix_Bid_Line_Item_Approval_Status__c = 'Marketing Rejected';
                                                                                                                                      }
                        if(blItem.Phoenix_Approval__c == 'Not Approved' && blItem.Phoenix_Final_Status__c == 'Not Approved'){ blItem.Phoenix_Bid_Line_Item_Approval_Status__c = 'Management Rejected';
                                                                                                                            }
                        if(blItem.Phoenix_Contract_Approval__c == 'Line Error- Not Sent' && blItem.Phoenix_Final_Status__c == 'Not Approved'){blItem.Phoenix_Bid_Line_Item_Approval_Status__c = 'Contracts Rejected';
                                                                                                                                             }
                        if(blItem.Phoenix_Finance_Approval__c == 'Not Approved' && blItem.Phoenix_Final_Status__c == 'Not Approved'){blItem.Phoenix_Bid_Line_Item_Approval_Status__c = 'Finance Rejected';
                                                                                                                                    }
                        if(blItem.Phoenix_Vistex_status_internal_use__c == 'Not Approved' && blItem.Phoenix_Final_Status__c == 'Not Approved'){blItem.Phoenix_Bid_Line_Item_Approval_Status__c = 'Vistex Rejected';
                                                                                                                                              } 
                        if(blItem.Phoenix_Customer_status_internal_use__c == 'Not Approved' && blItem.Phoenix_Final_Status__c == 'Not Approved'){blItem.Phoenix_Bid_Line_Item_Approval_Status__c = 'Customer Rejected';
                                                                                                                                                }
                        if(blItem.Phoenix_Marketing_Lead_Rx__c == 'Not Approved' && blItem.Phoenix_Final_Status__c == 'Not Approved'){blItem.Phoenix_Bid_Line_Item_Approval_Status__c = 'Marketing Lead Rx Rejected';
                                                                                                                                     } 
                        if(blItem.Phoenix_Marketing_Lead_SRx__c == 'Not Approved' && blItem.Phoenix_Final_Status__c == 'Not Approved'){blItem.Phoenix_Bid_Line_Item_Approval_Status__c = 'Marketing Lead SRx Rejected';
                                                                                                                                      } 
                        if(blItem.Phoenix_Marketing_Lead_OTC__c == 'Not Approved' && blItem.Phoenix_Final_Status__c == 'Not Approved'){blItem.Phoenix_Bid_Line_Item_Approval_Status__c = 'Marketing Lead OTC Rejected';
                                                                                                                                      } 
                        if(blItem.Phoenix_Sr_Director_VP_Finance_Approval__c == 'Not Approved' && blItem.Phoenix_Final_Status__c == 'Not Approved'){blItem.Phoenix_Bid_Line_Item_Approval_Status__c = 'Sr Director or VP Finance Rejected';
                                                                                                                                                   }
                        if(blItem.Phoenix_Customer_Service_Status__c == 'Not Processed' && blItem.Phoenix_Final_Status__c == 'Not Approved'){blItem.Phoenix_Bid_Line_Item_Approval_Status__c = 'Customer Service Rejected';
                                                                                                                                            } 
                        /*if (bidType == 'Volume Review Only') {blItem.Phoenix_ProposedContractBidPriceMktng__c = blItem.Phoenix_Current_Direct_Price__c;
blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c = blItem.Phoenix_Current_Indirect_Price__c;
}
*/
                        if ((blItem.Phoenix_Gross_Contract_Sales__c > 0) && (blItem.Phoenix_Gross_Contract_Sales__c != null) && (blItem.Phoenix_Value_Rebate__c != null) && (blItem.Phoenix_Value_Per_Unit_Rebate__c != null) && (blItem.Phoenix_Value_Admin_Fee__c != null) && (blItem.Phoenix_Value_Est_VIP__c != null) && (blItem.Phoenix_Sales_Out_Promotion__c != null) && (blItem.Phoenix_Initial_Order_Discount__c != null) && (blItem.Phoenix_Value_Cash_Terms__c != null)) {
                            blItem.Phoenix_Net_Sales_External__c = blItem.Phoenix_Gross_Contract_Sales__c - blItem.Phoenix_Value_Rebate__c - blItem.Phoenix_Value_Per_Unit_Rebate__c - blItem.Phoenix_Value_Admin_Fee__c - blItem.Phoenix_Value_Est_VIP__c - blItem.Phoenix_Sales_Out_Promotion__c - blItem.Phoenix_Initial_Order_Discount__c - blItem.Phoenix_Value_Cash_Terms__c;
                            blItem.Phoenix_Net_Sales_External__c = blItem.Phoenix_Net_Sales_External__c.setscale(0);
                            
                        }
                        system.debug('Netsales--84line--' + blItem.Phoenix_Net_Sales_External__c);
                        /*     if (blItem.Phoenix_Bid_Template_Refrence__c == 'Direct') {
if (blItem.Phoenix_Net_Sales_External__c != null && blItem.Phoenix_Estimated_Medicaid_Returns1__c != null) {
blItem.Phoenix_Net_Sales_Internal__c = blItem.Phoenix_Net_Sales_External__c - blItem.Phoenix_Estimated_Medicaid_Returns1__c;
blItem.Phoenix_Net_Sales_Internal__c = blItem.Phoenix_Net_Sales_Internal__c.setscale(0);
}
} else if (blItem.Phoenix_Bid_Template_Refrence__c == 'Indirect') {
if ((blItem.Phoenix_Gross_Contract_Sales__c > 0) && (blItem.Phoenix_Gross_Contract_Sales__c != null) && (blItem.Phoenix_Value_Rebate__c != null) && (blItem.Phoenix_Value_Per_Unit_Rebate__c != null) && (blItem.Phoenix_Value_Admin_Fee__c != null) && (blItem.Phoenix_Value_Est_VIP__c != null) && (blItem.Phoenix_Sales_Out_Promotion__c != null) && (blItem.Phoenix_Initial_Order_Discount__c != null) && (blItem.Phoenix_Estimated_Medicaid_Returns1__c != null) && (blItem.Phoenix_Contr_Management_Fee_Wholesaler__c != null) && (blItem.Phoenix_Value_Cash_Terms__c != null) && (blItem.Phoenix_Value_RDC_NLC__c != null)) {
blItem.Phoenix_Net_Sales_Internal__c = blItem.Phoenix_Gross_Contract_Sales__c - blItem.Phoenix_Value_Rebate__c - blItem.Phoenix_Value_Per_Unit_Rebate__c - blItem.Phoenix_Value_Admin_Fee__c - blItem.Phoenix_Value_Est_VIP__c - blItem.Phoenix_Sales_Out_Promotion__c - blItem.Phoenix_Initial_Order_Discount__c - blItem.Phoenix_Contr_Management_Fee_Wholesaler__c - blItem.Phoenix_Value_Cash_Terms__c - blItem.Phoenix_Value_RDC_NLC__c - blItem.Phoenix_Estimated_Medicaid_Returns1__c;
blItem.Phoenix_Net_Sales_Internal__c = blItem.Phoenix_Net_Sales_Internal__c.setscale(0);
}
} else {

if ((blItem.Phoenix_Gross_Contract_Sales__c > 0) && (blItem.Phoenix_Gross_Contract_Sales__c != null) && (blItem.Phoenix_Value_Rebate__c != null) && (blItem.Phoenix_Value_Per_Unit_Rebate__c != null) && (blItem.Phoenix_Value_Admin_Fee__c != null) && (blItem.Phoenix_Value_Est_VIP__c != null) && (blItem.Phoenix_Sales_Out_Promotion__c != null) && (blItem.Phoenix_Initial_Order_Discount__c != null) && (blItem.Phoenix_Estimated_Medicaid_Returns1__c != null) && (blItem.Phoenix_Value_Cash_Terms__c != null)) {

//blItem.Phoenix_Net_Sales_Internal__c=blItem.Phoenix_Gross_Contract_Sales__c - blItem.Phoenix_Value_Rebate__c - blItem.Phoenix_Value_Per_Unit_Rebate__c - blItem.Phoenix_Value_Admin_Fee__c - blItem.Phoenix_Value_Est_VIP__c - blItem.Phoenix_Sales_Out_Promotion__c - blItem.Phoenix_Initial_Order_Discount__c -blItem.Phoenix_Value_Cash_Terms__c- blItem.Phoenix_Estimated_Medicaid_Returns1__c ;
// blItem.Phoenix_Net_Sales_Internal__c=blItem.Phoenix_Net_Sales_Internal__c.setscale(0);
}
system.debug('Netsales--107line--' + blItem.Phoenix_Net_Sales_External__c);
} */
                        
                        /* if (blItem.Phoenix_Bid_Template_Refrence__c == 'Direct and Indirect') {
system.debug('fianl price---' + blItem.Phoenix_Final_Approvd_Pricing_Contracts__c);
system.debug('PUR---' + blItem.Phoenix_Proposed_Per_Unit_Rebate__c);
system.debug('rebat perc---' + blItem.Phoenix_Rebate_Perc_In__c);
system.debug('admin in d---' + blItem.Phoenix_Admin_Fee_in__c);
system.debug('vip per unit---' + blItem.Phoenix_VIP_per_unit_in__c);
system.debug('sor per unit---' + blItem.Phoenix_Sales_Out_Promotion_Per_unit_in__c);
system.debug('iod per unit---' + blItem.Phoenix_IOD_Per_Unit_in__c);
system.debug('cd per unit---' + blItem.Phoenix_CD_Per_Unit_in__c);
system.debug('md per unit---' + blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c);
if (blItem.Phoenix_Final_Approvd_Pricing_Contracts__c != null && blItem.Phoenix_Proposed_Per_Unit_Rebate__c != null && blItem.Phoenix_Rebate_Perc_In__c != null && blItem.Phoenix_Admin_Fee_in__c != null && blItem.Phoenix_VIP_per_unit_in__c != null && blItem.Phoenix_Sales_Out_Promotion_Per_unit_in__c != null && blItem.Phoenix_IOD_Per_Unit_in__c != null && blItem.Phoenix_CD_Per_Unit_in__c != null && blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c != null) {
blItem.Phoenix_Direct_Dead_Net__c = blItem.Phoenix_Final_Approvd_Pricing_Contracts__c - blItem.Phoenix_Proposed_Per_Unit_Rebate__c - blItem.Phoenix_Rebate_Perc_In__c - blItem.Phoenix_Admin_Fee_in__c - blItem.Phoenix_VIP_per_unit_in__c - blItem.Phoenix_Sales_Out_Promotion_Per_unit_in__c - blItem.Phoenix_IOD_Per_Unit_in__c - blItem.Phoenix_CD_Per_Unit_in__c - blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c;
}
if (blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != null && blItem.Phoenix_Proposed_ZITD__c != null && blItem.Phoenix_CD_Per_Unit_in__c != null && blItem.Phoenix_RDC_NLC_Per_Unit_in__c != null && blItem.Phoenix_CM_Fees_Per_Unit_in__c != null && blItem.Phoenix_Rebate__c != null && blItem.Phoenix_Admin_Fee_in__c != null && blItem.Phoenix_VIP_per_unit_in__c != null && blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c != null && blItem.Phoenix_Sales_Out_Promotion_Per_unit_in__c != null && blItem.Phoenix_IOD_Per_Unit_in__c != null && blItem.Phoenix_Proposed_Per_Unit_Rebate__c != null) {blItem.Phoenix_Indirect_Dead_Net__c = blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c - blItem.Phoenix_Proposed_ZITD__c - blItem.Phoenix_CD_Per_Unit_in__c - blItem.Phoenix_RDC_NLC_Per_Unit_in__c - blItem.Phoenix_CM_Fees_Per_Unit_in__c - blItem.Phoenix_Rebate__c - blItem.Phoenix_Admin_Fee_in__c - blItem.Phoenix_VIP_per_unit_in__c - blItem.Phoenix_Sales_Out_Promotion_Per_unit_in__c - blItem.Phoenix_IOD_Per_Unit_in__c - blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c - blItem.Phoenix_Proposed_Per_Unit_Rebate__c;
}
system.debug('directdeadnet---' + blItem.Phoenix_Direct_Dead_Net__c);
system.debug('in-directdeadnet---' + blItem.Phoenix_Indirect_Dead_Net__c);
}*/
                        Decimal finalDirectUnits2 = blItem.Phoenix_Final_Direct_Selling_Units_Calc__c != null ? blItem.Phoenix_Final_Direct_Selling_Units_Calc__c : 0;
                        Decimal finalIndirectUnits2 = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c != null ? blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c : 0;
                        if (blItem.Phoenix_Bid_Template_Refrence__c == 'Direct and Indirect') { if (blItem.Phoenix_Direct_Dead_Net__c != null && blItem.Phoenix_Indirect_Dead_Net__c != null) {    blItem.Phoenix_Net_Sales_Internal__c = (blItem.Phoenix_Direct_Dead_Net__c * finalDirectUnits2) + (blItem.Phoenix_Indirect_Dead_Net__c * (finalDirectUnits2 + finalIndirectUnits2));
                                                                                                                                                                                              }
                                                                                               system.debug('Netsales--124line--' + blItem.Phoenix_Net_Sales_External__c);
                                                                                               system.debug('Final Total Selling Units--->' + blItem.Phoenix_Final_Total_Selling_Unit__c);
                                                                                               system.debug('Final Total Selling Units--->' + blItem.Phoenix_Proposed_Direct_Selling_Unit__c);
                                                                                               system.debug('Final Total Selling Units--->' + blItem.Phoenix_Proposed_Indirect_Selling_Unit__c);
                                                                                              }
                        Decimal finalDirectUnits1 = blItem.Phoenix_Final_Direct_Selling_Units_Calc__c != null ? blItem.Phoenix_Final_Direct_Selling_Units_Calc__c : 0;
                        Decimal finalIndirectUnits1 = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c != null ? blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c : 0;
                        if (blItem.Phoenix_Final_Total_Selling_Unit__c > 0 && blItem.Phoenix_Net_Sales_Internal__c > 0 && (finalDirectUnits1 > 0 || finalIndirectUnits1 > 0)) {
                            blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Net_Sales_Internal__c / (finalDirectUnits1 + finalIndirectUnits1);
                        } else {
                            blItem.Phoenix_Internal_Dead_Net_Price__c = 0;
                        }
                    }
                    
                    
                    if(bidRec.Phoenix_Customer_Type__c == 'Direct'){  new Phoenix_BidItemDirectTemplateHandler().run();
                                                                   }
                    if(bidRec.Phoenix_Customer_Type__c == 'Indirect'){  new Phoenix_BidItemIndirectTemplateHandler().run();
                                                                     }
                    
                    if(bidRec.Phoenix_Customer_Type__c == 'Walgreens'){
                        new Phoenix_BidTriggerHandlerWalgreens().run();
                    }
                    if(bidRec.Phoenix_Customer_Type__c == 'ABC Progen'){  new Phoenix_BidTriggerHandlerABCProgen().run();
                                                                       }
                    if(bidRec.Phoenix_Customer_Type__c == 'Econdisc'){    new Phoenix_BidTriggerHandlerEcondisc().run();
                                                                     }
                    if(bidRec.Phoenix_Customer_Type__c == 'ClarusOne'){  new Phoenix_BidTriggerHandlerClarusOne().run();
                                                                      } 
                    if(bidRec.Phoenix_Customer_Type__c == 'Costco'){  new Phoenix_BidItemTriggerHandlerCostco().run();
                                                                   }
                    if(bidRec.Phoenix_Customer_Type__c == 'ABC Pharmagen'){  new Phoenix_BidTriggerHandlerPharmagen().run();
                                                                          }
                    if(bidRec.Phoenix_Customer_Type__c == 'BASE/DSH'){   new Phoenix_BidItemHandlerDSH().run();
                                                                     }
                    if(bidRec.Phoenix_Customer_Type__c == 'RXSS'){  new Phoenix_BidItemHandlerRxSS().run();
                                                                 }
                    if(bidRec.Phoenix_Customer_Type__c == 'Government Pricing'){ new Phoenix_BidItemHandlerGovernmentPricing().run();
                                                                               }
                    if(bidRec.Phoenix_Customer_Type__c == 'Sams Club'){ new Phoenix_BidItemHandlerSamsClub().run();
                                                                      }
                    if(bidRec.Phoenix_Customer_Type__c == 'Net Indirect Pricing'){  new Phoenix_BidItemHandlerNetIndirect().run();
                                                                                 }
                    if(bidRec.Phoenix_Customer_Type__c == 'ROS'){     new Phoenix_BidItemHandlerROS().run();
                                                                }
                    /* if(bidRec.Phoenix_Bid_Type__c == 'Short Dated OTB' || bidRec.Phoenix_Bid_Type__c == 'Good Dated OTB'){
new Phoenix_BidItemHandlerOTB().run();
}*/
                    if(bidRec.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)'){ new Phoenix_IODCustomerTriggerHandler().run();
                                                                                                                             }
                    if(bidRec.Phoenix_Customer_Type__c == 'Humana Indirect retail' || bidRec.Phoenix_Customer_Type__c == 'Humana Indirect CII'){
                        new Phoenix_HumanaIndirectHandler().run();
                    }
                    if(bidRec.Phoenix_is_OTC_Bid__c){  new Phoenix_BidItemOTCTemplateHandler().run();
                                                    }
                } 
            }
        }
        
        if (trigger.isAfter && trigger.isUpdate) {
            
            Set < Id > newIds = new Set < Id > ();
            String Bid_ID;
            for (Phoenix_Bid_Line_Item__c item: trigger.new) {
                Bid_ID = item.Phoenix_Bid__c;
                if(item.Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number'){
                    if (trigger.oldMap.get(item.Id).Phoenix_Final_Status__c != trigger.newMap.get(item.Id).Phoenix_Final_Status__c && trigger.newMap.get(item.Id).Phoenix_Final_Status__c == 'Not Approved') { //means status changed
                        newIds.add(item.Id);
                    }   
                }    
                
            }
            
            if (newIds.size() > 0) Phoenix_SubmitBidForApprovalCtrl.BidRejectionEmailNotificationToAll(newIds,Bid_ID); //Sending notification to all approvers
            
        }
    }
}