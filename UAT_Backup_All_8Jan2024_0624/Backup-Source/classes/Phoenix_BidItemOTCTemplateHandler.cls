public class Phoenix_BidItemOTCTemplateHandler extends TriggerHandler {
    private list < Phoenix_Bid_Line_Item__c > triggerNew;
    private list < Phoenix_Bid_Line_Item__c > triggerOld;
    private Map < Id, Phoenix_Bid_Line_Item__c > newMap;
    private Map < Id, Phoenix_Bid_Line_Item__c > oldMap;
    
    public Phoenix_BidItemOTCTemplateHandler() {
        this.newMap = (Map < Id, Phoenix_Bid_Line_Item__c > ) Trigger.newMap;
        this.oldMap = (Map < Id, Phoenix_Bid_Line_Item__c > ) Trigger.oldMap;
        this.triggerNew = (List < Phoenix_Bid_Line_Item__c > ) Trigger.new;
        this.triggerOld = (List < Phoenix_Bid_Line_Item__c > ) Trigger.old;
    }
    public override void beforeInsert() {
        beforeUpdate();
    }
    public override void beforeUpdate() {
        Phoenix_Bid__c bidRec = [SELECT Id,Phoenix_is_OTC_Bid__c,Phoenix_Customer_Type__c, Phoenix_Customer__r.Phoenix_Rebates__c,Phoenix_Customer__r.Phoenix_Cash_Discount__c ,
                                 Phoenix_Customer__r.Phoenix_Fee__c,Phoenix_Customer__r.Phoenix_CM_Fees__c,Phoenix_Bid_Proposed_Position__c, 
                                 Phoenix_Approval_Status__c,Phoenix_Proposed_Cash_Terms__c,Phoenix_Initial_Order_Discount_Type__c, Phoenix_Custom_type__c,Phoenix_Proposed_SSA_No_of_Days__c, 
                                 Phoenix_Current_CD__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Initial_Order_Discount_of_Days__c, 
                                 Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Bid_Type__c ,Phoenix_Sales_Out_Promotion_of_Days__c,Phoenix_Proposed_Value_Admin_Fee__c 
                                 FROM Phoenix_Bid__c 
                                 WHERE Id =: triggerNew[0].Phoenix_Bid__c];
        Decimal initialOrderDays = bidRec.Phoenix_Initial_Order_Discount_of_Days__c != null? bidRec.Phoenix_Initial_Order_Discount_of_Days__c : 0 ;
        Decimal initialOrderDisc=bidRec.Phoenix_Proposed_Initial_Order_Discount__c != null? bidRec.Phoenix_Proposed_Initial_Order_Discount__c : 0 ;
        Decimal salesOutDays = bidRec.Phoenix_Sales_Out_Promotion_of_Days__c != null? bidRec.Phoenix_Sales_Out_Promotion_of_Days__c : 0 ;
        String bidType= bidRec.Phoenix_Bid_Type__c;
        Boolean otcBid = bidRec.Phoenix_is_OTC_Bid__c;
        for (Phoenix_Bid_Line_Item__c blItem: triggerNew) {
            try{
                if (otcBid){
                    
                    system.debug('OTC Handler called');
                    blItem.Phoenix_Override_Total_units__c = (blItem.Phoenix_Override_Current_Direct_Units__c != null && blItem.Phoenix_Override_Current_Direct_Units__c > 0) ? blItem.Phoenix_Override_Current_Direct_Units__c : blItem.Phoenix_Current_Direct_Selling_Unit__c;
                    Decimal totalOverride = (blItem.Phoenix_Override_Current_Direct_Units__c != null && blItem.Phoenix_Override_Current_Direct_Units__c > 0) ? blItem.Phoenix_Override_Current_Direct_Units__c : (blItem.Phoenix_Current_Direct_Selling_Unit__c!=null?blItem.Phoenix_Current_Direct_Selling_Unit__c:0);
                    Decimal sharePercent  = blItem.Phoenix_Date_Fee__c != null ? blItem.Phoenix_Date_Fee__c : 0;
                    Decimal totalUnits  = blItem.Phoenix_12_Months_IndirectSaleUnit__c != null ? blItem.Phoenix_12_Months_IndirectSaleUnit__c : 0;
                    blItem.Phoenix_Proposed_Direct_Selling_Unit__c = totalUnits>0? (totalUnits *(sharePercent/100)).setScale(0):0;//Proposed DRL Units
                    
                    if (blItem.Phoenix_SCM_Final_Approval__c == true) { 
                            decimal percenalOfQty = 0;
                            Decimal totalProposedUnits = blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null ? blItem.Phoenix_Proposed_Direct_Selling_Unit__c :0;
                            Decimal finalCalcedScmQuantity = ((((totalOverride)/12)+(((blItem.Phoenix_SCM_Approved_Quantity__c!=null?blItem.Phoenix_SCM_Approved_Quantity__c:0)/100)*((totalProposedUnits/12)-((totalOverride)/12))))*12).setScale(0);
                            if (blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null && blItem.Phoenix_Total_SCM_Approved_Qty__c != null && blItem.Phoenix_Proposed_Direct_Selling_Unit__c != 0) {
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
                            if (blItem.Phoenix_SCM_Final_Approval__c == true && (blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Only Current Monthly Demand Approved' || blItem.Phoenix_SCM_Approval_Y_N__c == 'Y- Current + Inc Demand Approved')) {
                                decimal finalDirectSellingUNitCal = 0, finalIndirectSellingUNitCal = 0;
                                finalDirectSellingUNitCal = blItem.Phoenix_SCM_Qty_Approved_Direct__c;
                                if (blItem.Phoenix_SCM_Qty_Approved_Direct__c != null && finalDirectSellingUNitCal.setScale(0) != 0) {
                                    blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = blItem.Phoenix_SCM_Qty_Approved_Direct__c;
                                } else {
                                    blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = finalCurrentSCMUnits;
                                }
                            }
                        } 
                    
                    //Decimal ProposedBaseSellingUnits = blItem.Phoenix_Proposed_Smith_Drug_Units__c != null ? blItem.Phoenix_Proposed_Smith_Drug_Units__c : BaseOverrideSalesUnits > 0 ? BaseOverrideSalesUnits : monthBaseSellingUnits > 0 ? monthBaseSellingUnits : 0;
                    
                    
                    
                    if (blItem.Phoenix_SCM_Final_Approval__c == false) {
                        blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = (blItem.Phoenix_Proposed_Direct_Selling_Unit__c!=null && blItem.Phoenix_Proposed_Direct_Selling_Unit__c!=0)? blItem.Phoenix_Proposed_Direct_Selling_Unit__c:blItem.Phoenix_Override_Current_Direct_Units__c!=null? blItem.Phoenix_Override_Current_Direct_Units__c:blItem.Phoenix_Current_Direct_Selling_Unit__c!=null? blItem.Phoenix_Current_Direct_Selling_Unit__c:0;
                        
                    }
                    
                    Decimal finalDirectPrice = blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c:blItem.Phoenix_ProposedContract_Bid_Price_Sales__c!=null?blItem.Phoenix_ProposedContract_Bid_Price_Sales__c:blItem.Phoenix_Current_Direct_Price__c!=null?blItem.Phoenix_Current_Direct_Price__c: 0;
                    //started.
                    Decimal finalApprovedPrice = blItem.Phoenix_Current_Price_Calc__c != null ? blItem.Phoenix_Current_Price_Calc__c : 0;
                    Decimal proposedPerUnitRebate = blItem.Phoenix_Proposed_Per_Unit_Rebate__c != null ? blItem.Phoenix_Proposed_Per_Unit_Rebate__c : 0;
                    Decimal adminFeeDollar = blItem.Phoenix_Admin_Fee_in__c != null ? blItem.Phoenix_Admin_Fee_in__c :0 ;
                    Decimal rebateinDollar = blItem.Phoenix_Rebate_Perc_In__c != null ? blItem.Phoenix_Rebate_Perc_In__c :0 ;
                    blItem.Phoenix_Anda_VIP__c = (finalDirectPrice)* ((blItem.Phoenix_Proposed_Est_VIP__c != null ? blItem.Phoenix_Proposed_Est_VIP__c : 0)/100);
                    Decimal vipPerDollar = blItem.Phoenix_Anda_VIP__c ;
                    blItem.Phoenix_Cash_Terms_RxSS__c  = finalDirectPrice* ((blItem.Phoenix_Cash_Terms__c != null ? blItem.Phoenix_Cash_Terms__c : 0)/100);
                    Decimal cdPerDollar = blItem.Phoenix_Cash_Terms_RxSS__c;
                    //Added By vandana***************
                    
                    //end******************
                    
                    
                    // Decimal finalDirectPrice = blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c : 0;
                    Decimal finalCurDirPrice = blItem.Phoenix_Current_Direct_Price__c != null ? blItem.Phoenix_Current_Direct_Price__c : 0;
                    system.debug('finalDirectPrice--->'+finalDirectPrice);
                    system.debug('finalCurDirPrice--->'+finalCurDirPrice);
                    
                    //added by vandana start*************
                    Decimal damagePercent = blItem.Phoenix_Reduction__c!=null ? blItem.Phoenix_Reduction__c:0;//Damages $
                    
                    blItem.Phoenix_Current_Anda_CP_Price__c = finalDirectPrice > 0 ? finalDirectPrice*(damagePercent/100):0;//Damages $
                    Decimal damagePerDollor = blItem.Phoenix_Current_Anda_CP_Price__c!=null ? blItem.Phoenix_Current_Anda_CP_Price__c:0;//Damages $
                    system.debug('damagePerDollor'+damagePerDollor);
                    //end******************
                    
                    system.debug('finalApprovedPrice---->'+finalApprovedPrice);
                    
                    blItem.Phoenix_Internal_Dead_Net_Price__c = finalApprovedPrice>0?(finalApprovedPrice -adminFeeDollar- proposedPerUnitRebate-rebateinDollar-vipPerDollar-cdPerDollar-damagePerDollor):0;
                    system.debug('Internal Dead net -->'+blItem.Phoenix_Internal_Dead_Net_Price__c);
                    blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Internal_Dead_Net_Price__c > 0 ? blItem.Phoenix_Internal_Dead_Net_Price__c :0;
                    blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Internal_Dead_Net_Price__c > 0 ? blItem.Phoenix_Internal_Dead_Net_Price__c : 0;
                    
                    Decimal currentASp = blItem.Phoenix_DeadNet_TrckGR__c != null ? blItem.Phoenix_DeadNet_TrckGR__c:0;
                    //Net Price % Change
                    blItem.Phoenix_Reduction_in_NCP_WMT__c = (currentASp>0)? (((blItem.Phoenix_Internal_Dead_Net_Price__c/currentASp)-1)*100):0;
                    Decimal finalDirectUnits = (blItem.Phoenix_Final_Direct_Selling_Units_Calc__c != null && blItem.Phoenix_SCM_Final_Approval__c) ? blItem.Phoenix_Final_Direct_Selling_Units_Calc__c : (blItem.Phoenix_Proposed_Direct_Selling_Unit__c!= null && blItem.Phoenix_Proposed_Direct_Selling_Unit__c>0) ? blItem.Phoenix_Proposed_Direct_Selling_Unit__c:blItem.Phoenix_Override_Current_Direct_Units__c != null ?  blItem.Phoenix_Override_Current_Direct_Units__c : blItem.Phoenix_Current_Direct_Selling_Unit__c!=null?blItem.Phoenix_Current_Direct_Selling_Unit__c:0;
                    Decimal estimatedReturns = blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c != null ? blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c : 0;
                    Decimal salesPerUnit = blItem.Phoenix_Sales_Out_Promotion_Per_unit_in__c != null ? blItem.Phoenix_Sales_Out_Promotion_Per_unit_in__c :0 ;
                    Decimal salesOutOverAmount = (finalDirectUnits/360)*salesPerUnit*salesOutDays;
                    Decimal iodPerUnitDollar = blItem.Phoenix_IOD_Per_Unit_in__c != null ? blItem.Phoenix_IOD_Per_Unit_in__c : 0;
                    
                    blItem.Phoenix_IOD_Total_Amount__c = (finalDirectUnits/360) * iodPerUnitDollar * (bidRec.Phoenix_Initial_Order_Discount_of_Days__c != null ? bidRec.Phoenix_Initial_Order_Discount_of_Days__c : 0);
                    // blItem.Phoenix_Net_Sales_Internal__c = blItem.Phoenix_Internal_Dead_Net_Price__c>0?(finalDirectUnits * blItem.Phoenix_Internal_Dead_Net_Price__c.setScale(4)) - (estimatedReturns*finalDirectUnits) - salesOutOverAmount - blItem.Phoenix_IOD_Total_Amount__c:0;
                    
                    Decimal thPutCost = blItem.Phoenix_Throughput_cost__c != null ? blItem.Phoenix_Throughput_cost__c : 0;
                    blItem.Proposed_TPT_Direct__c = (blItem.Phoenix_Internal_Dead_Net_Price__c > 0) ? blItem.Phoenix_Internal_Dead_Net_Price__c.setScale(4) - thPutCost : 0 ;
                    blItem.Proposed_TPT_Per_Direct__c = (blItem.Phoenix_Internal_Dead_Net_Price__c > 0) ? (blItem.Proposed_TPT_Direct__c/blItem.Phoenix_Internal_Dead_Net_Price__c)*100:0;
                    
                    //blItem.Phoenix_Proposed_Sales__c =  blItem.Phoenix_Internal_Dead_Net_Price__c  * finalDirectUnits ;
                    
                    //added by vandana start*******************************
                    blItem.Phoenix_Current_Retail_Direct_Units__c =totalOverride*(blItem.Phoenix_Pkg_Size__c!=null?blItem.Phoenix_Pkg_Size__c:0);//current 52wk
                    blItem.Phoenix_12_Months_TotalSaleUnits__c = ((blItem.Phoenix_Current_Retail_Direct_Units__c != null ? blItem.Phoenix_Current_Retail_Direct_Units__c : 0)/12).setScale(0);//(blItem.Phoenix_Doses__c/12):0;//current monthly
                  
                    Decimal drlUnits  = blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null ? blItem.Phoenix_Proposed_Direct_Selling_Unit__c : 0;
                    Decimal pkgSize  = blItem.Phoenix_Pkg_Size__c != null ? blItem.Phoenix_Pkg_Size__c : 0;
                    system.debug('drlUnits=='+drlUnits);
                     system.debug('pkgSize=='+pkgSize);
                    blItem.Phoenix_Proposed_Anda_Units__c  =  drlUnits*pkgSize; //Proposed 52WK
                    system.debug('blItem.Phoenix_Proposed_Anda_Units__c=='+blItem.Phoenix_Proposed_Anda_Units__c);
                    blItem.Phoenix_Others_Direct__c  =  finalDirectUnits*pkgSize; //Final 52WK
                    blItem.Phoenix_Proposed_OS_Units__c = blItem.Phoenix_Proposed_Anda_Units__c!=null?(blItem.Phoenix_Proposed_Anda_Units__c /12):0;
                    blItem.Phoenix_Others_Indirect__c = blItem.Phoenix_Others_Direct__c!=null?(blItem.Phoenix_Others_Direct__c /12):0; //Final montly 
                    system.debug('Proposed 52WK-->'+blItem.Phoenix_Proposed_Anda_Units__c);
                    
                    blItem.Phoenix_Reduc_in_NCP_McK_And_RAD__c = (finalDirectPrice > 0 && finalCurDirPrice>0)? ((finalDirectPrice -finalCurDirPrice)/finalCurDirPrice)*100: 0;//Sell Price% Change
                    system.debug('Sell Price% Change--->'+blItem.Phoenix_Reduc_in_NCP_McK_And_RAD__c);
                    
                    blItem.Phoenix_Net_Sales_External__c = (finalDirectPrice*finalDirectUnits).setScale(0);//Gross Sales
                    blItem.Phoenix_Net_Sales_Internal__c = blItem.Phoenix_Internal_Dead_Net_Price__c>0?(blItem.Phoenix_Internal_Dead_Net_Price__c*finalDirectUnits).setScale(0):0;//NetSales
                    blItem.Phoenix_Net_Sales_Internal__c = blItem.Phoenix_Net_Sales_Internal__c.setScale(0);
                    system.debug('Gross Sales--->'+blItem.Phoenix_Net_Sales_External__c);
                    
                    blItem.Phoenix_Current_Net_Indirect_Price__c = (((blItem.Proposed_TPT_Per_Direct__c!=null ?blItem.Proposed_TPT_Per_Direct__c:0 )/100)*blItem.Phoenix_Net_Sales_Internal__c).setScale(0);//Profit
                    blItem.Phoenix_Sales_Proposed_NCP_McK_And_RAD__c = (blItem.Phoenix_Pkg_Size__c!= null && blItem.Phoenix_Pkg_Size__c >0) ? finalDirectPrice/(blItem.Phoenix_Pkg_Size__c) : 0;//Sell Price Per Size
                     
                    Decimal SBRetailPrice = blItem.Phoenix_Current_Retail_Indirect_Price__c!=null ?blItem.Phoenix_Current_Retail_Indirect_Price__c:0;
                    system.debug('SBRetailPrice--->'+SBRetailPrice);
                    
                    blItem.Phoenix_Opening_Order_Net_sales__c = SBRetailPrice*finalDirectUnits;//Retail $
                    system.debug('Retail $--->'+blItem.Phoenix_Opening_Order_Net_sales__c);
                    
                    blItem.Phoenix_Opening_Order_TPT__c = SBRetailPrice>0 ?(SBRetailPrice-finalDirectPrice)*finalDirectUnits:0;//RM $
                    blItem.Phoenix_Opening_Order_TPT_Per__c = (SBRetailPrice>0) ? (((SBRetailPrice-finalDirectPrice)/SBRetailPrice)*100):0;//RM %     
                    system.debug('RM %--->'+blItem.Phoenix_Opening_Order_Net_sales__c);
                    
                    //added end.***************************************
                          
                     //FOR Current Sales && NDC Finance View
                     Decimal finalCurrentUnits = (blItem.Phoenix_Override_Current_Direct_Units__c >0)? blItem.Phoenix_Override_Current_Direct_Units__c : ((blItem.Phoenix_Current_Direct_Selling_Unit__c > 0) ? blItem.Phoenix_Current_Direct_Selling_Unit__c:0);
                     Decimal  indirectDeadnet = blItem.Phoenix_DeadNet_TrckGR__c > 0 ? blItem.Phoenix_DeadNet_TrckGR__c : 0;
                         blItem.Finance_Current_Sales__c = (finalCurrentUnits * indirectDeadnet );//(estimatedReturns * finalCurrentUnits)
                    //END FOR Current Sales && NDC Finance View
                    //  blItem.Phoenix_Reduc_in_NCP_McK_And_RAD__c = finalCurDirPrice > 0 ? ((finalDirectPrice/finalCurDirPrice)-1)*100 : 0;
                    blItem.Phoenix_Proposed_Sales__c = blItem.Phoenix_Net_Sales_Internal__c;
                    
                    //  blItem.Phoenix_Current_Anda_CP_Price__c = blItem.Phoenix_ProposedContractBidPriceMktng__c*blItem.Phoenix_Reduction__c;
                /*    
                    // SSA Hit Calculation 
                    Decimal directUnits = (blItem.Phoenix_Override_Current_Direct_Units__c != null && blItem.Phoenix_Override_Current_Direct_Units__c > 0) ? blItem.Phoenix_Override_Current_Direct_Units__c : (blItem.Phoenix_Current_Direct_Selling_Unit__c!=null?blItem.Phoenix_Current_Direct_Selling_Unit__c:0);
                        Decimal DiffPrice = (blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c :0) - (blItem.Phoenix_Current_Direct_Price__c!= null ? blItem.Phoenix_Current_Direct_Price__c : 0);
                    Decimal SSANoofDays = (bidRec.Phoenix_Proposed_SSA_No_of_Days__c != null ? bidRec.Phoenix_Proposed_SSA_No_of_Days__c :0)/30;
                    blItem.Phoenix_SSA_Hit_Updated__c = DiffPrice * SSANoofDays * (directUnits/12);
                    
               */     
                    
     /*               
                    //Price and Volume Variance calculations 
                    
                    Decimal currentIndirUnits = directUnits;
                    Decimal ProposedIndirectUnis = (blItem.Phoenix_SCM_Final_Approval__c == true ? finalDirectUnits : (blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null ? blItem.Phoenix_Proposed_Direct_Selling_Unit__c:0))-currentIndirUnits;
                    
                    Decimal indirectDedadnet = (blItem.Phoenix_Internal_Dead_Net_Price__c != null ? blItem.Phoenix_Internal_Dead_Net_Price__c : 0)-currentASp;
                    
                    Decimal priceVarianceIndir = indirectDedadnet *currentIndirUnits;
                    
                    Decimal volumeVarianceIndir = indirectDedadnet*ProposedIndirectUnis;
                    
                    blItem.Phoenix_Price_Variance__c = (bidType == 'OTC RFP' || bidType == 'OTC Price Change' || bidType == 'OTC Rebate Change') ? ( priceVarianceIndir):0;
                    blItem.Phoenix_Volume_Variance__c = (bidType == 'OTC Price Change' || bidType == 'OTC Rebate Change') ? 0 : ( volumeVarianceIndir) ;      
                        
                        
                        
                        
                        //new code for New Product Launch Calc
                        Decimal InternalDeadNet = blItem.Phoenix_Internal_Dead_Net_Price__c > 0 ? blItem.Phoenix_Internal_Dead_Net_Price__c : 0;   
                    Decimal brandwac =( blItem.Brand_WAC__c != null && blItem.Brand_WAC__c !=0)?blItem.Brand_WAC__c:0;
                    //blItem.Phoenix_Brand_WAC_Per__c = brandwac != 0 ? (InternalDeadNet / brandwac)*100 : 0;
                    Decimal openingorder = (blItem.Phoenix_Opening_Order__c != null && blItem.Phoenix_Opening_Order__c != 0)?blItem.Phoenix_Opening_Order__c :0;
                    //blItem.Phoenix_Opening_Order_Net_sales__c = (InternalDeadNet > 0 && openingorder > 0) ? (openingorder * InternalDeadNet) - (openingorder * estimatedReturns)-(blItem.Phoenix_IOD_Total_Amount__c!=null ? blItem.Phoenix_IOD_Total_Amount__c:0):0;
                    Decimal openingOrdernetsales = (blItem.Phoenix_Opening_Order_Net_sales__c != null && blItem.Phoenix_Opening_Order_Net_sales__c != 0) ? blItem.Phoenix_Opening_Order_Net_sales__c : 0;
                    Decimal throughputcost1 = (blItem.Phoenix_Throughput_Cost1__c != null && blItem.Phoenix_Throughput_Cost1__c != 0)? blItem.Phoenix_Throughput_Cost1__c:0;
                    //blItem.Phoenix_Opening_Order_TPT__c = (InternalDeadNet > 0 && openingorder > 0) ?  openingOrdernetsales - (openingorder * throughputcost1) : 0;
                    Decimal openingordertptdl = (blItem.Phoenix_Opening_Order_TPT__c != null &&  blItem.Phoenix_Opening_Order_TPT__c != 0) ?blItem.Phoenix_Opening_Order_TPT__c :0 ;
                    //blItem.Phoenix_Opening_Order_TPT_Per__c = openingOrdernetsales !=0 ? (openingordertptdl / openingOrdernetsales)*100 :0 ;
              */  }
            }
            Catch(Exception e) {
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_BidLineItemTrigger', Phoenix_Method_Name__c = '', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
        }
    }
    
}