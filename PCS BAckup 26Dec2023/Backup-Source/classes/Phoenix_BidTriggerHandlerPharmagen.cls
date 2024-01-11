public class Phoenix_BidTriggerHandlerPharmagen extends TriggerHandler {
    	private list < Phoenix_Bid_Line_Item__c > triggerNew;
    	private list < Phoenix_Bid_Line_Item__c > triggerOld;
    	private Map < Id, Phoenix_Bid_Line_Item__c > newMap;
    	private Map < Id, Phoenix_Bid_Line_Item__c > oldMap;
    
    public Phoenix_BidTriggerHandlerPharmagen() {
        this.newMap = (Map < Id, Phoenix_Bid_Line_Item__c > ) Trigger.newMap;
        this.oldMap = (Map < Id, Phoenix_Bid_Line_Item__c > ) Trigger.oldMap;
        this.triggerNew = (List < Phoenix_Bid_Line_Item__c > ) Trigger.new;
        this.triggerOld = (List < Phoenix_Bid_Line_Item__c > ) Trigger.old;
    }
     public override void beforeInsert() {
          beforeUpdate();
     }
    
    public override void beforeUpdate() {
        List<Phoenix_BidLineItemExtn__c> bidLineItemExtnList = new List<Phoenix_BidLineItemExtn__c>();
        List<Phoenix_BidLineItemExtn__c> bidLineItemExtnUpdateList = new List<Phoenix_BidLineItemExtn__c>();
        Map <Id, Phoenix_BidLineItemExtn__c> bliExtnMap = new Map<Id, Phoenix_BidLineItemExtn__c>(); // we will be adding bli Id and that child to this map to reference in the cals below.
        
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
           /*  if (blItem.Phoenix_Bid_Template_Refrence__c == 'ABC Pharmagen') {
                   Decimal rebateper = blItem.Phoenix_Proposed_Current_Rebate__c != null ? blItem.Phoenix_Proposed_Current_Rebate__c : blItem.Phoenix_Current_Rebate__c != null ? blItem.Phoenix_Current_Rebate__c : 0;
                    Decimal currentindirectprice = blItem.Phoenix_Current_Indirect_Price__c != null ? blItem.Phoenix_Current_Indirect_Price__c : 0;
                    blItem.Phoenix_Net_Price_afterRebates_after_VIP__c = currentindirectprice * (rebateper / 100);
                    Decimal wac = blItem.Phoenix_WAC__c != null ? blItem.Phoenix_WAC__c : 0;
                    Decimal cashdiscountper = blItem.Phoenix_Indirect_CD_Per__c != null ? blItem.Phoenix_Indirect_CD_Per__c : 0;
                    blItem.Phoenix_WMT_CD_WMT_Indirect__c = wac * (cashdiscountper / 100);
                    Decimal PharmagenDeadnet = (currentindirectprice !=null && currentindirectprice !=0 )? currentindirectprice - blItem.Phoenix_Net_Price_afterRebates_after_VIP__c - blItem.Phoenix_WMT_CD_WMT_Indirect__c :0;
                    blItem.Phoenix_Customer_Dead_Net1__c = PharmagenDeadnet;
                    Decimal marketingprice = (blItem.Phoenix_ProposedContractBidPriceMktng__c != null && blItem.Phoenix_ProposedContractBidPriceMktng__c != 0) ?
                        blItem.Phoenix_ProposedContractBidPriceMktng__c : (blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null && blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != 0) ?
                            blItem.Phoenix_ProposedContract_Bid_Price_Sales__c : (blItem.Phoenix_Current_Indirect_Price__c != null && blItem.Phoenix_Current_Indirect_Price__c != 0) ?
                                blItem.Phoenix_Current_Indirect_Price__c : (blItem.Phoenix_Current_Wholesaler_Price__c != null && blItem.Phoenix_Current_Wholesaler_Price__c != 0) ?blItem.Phoenix_Current_Wholesaler_Price__c :0;
                    blItem.Phoenix_Net_Price_after_Rebates_Terms__c = marketingprice * (rebateper / 100);
                    Decimal rebate = blItem.Phoenix_Net_Price_after_Rebates_Terms__c != null ? blItem.Phoenix_Net_Price_after_Rebates_Terms__c :0;
                    Decimal indirectcd = blItem.Phoenix_INDIRECT_CD__c != null ? blItem.Phoenix_INDIRECT_CD__c : 0;
                    Decimal indirectDeadnet = (marketingprice !=null && marketingprice != 0)? (marketingprice - rebate - indirectcd):0;
                    System.debug('indirect deadnet --->' + indirectDeadnet);
                    blItem.Phoenix_Direct_Dead_Net__c = indirectDeadnet;
                    blItem.Phoenix_Internal_Dead_Net_Price__c = indirectDeadnet;
                    Decimal IOP_per_unit_in = wac * (initialOrderDisc/100);
                    blItem.Phoenix_Wholesaler_IOD_per_unit__c = IOP_per_unit_in;
                    Decimal finalIndirectUnits;
                    if (blItem.Phoenix_SCM_Final_Approval__c == true) {
                        finalIndirectUnits = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                    } else {
                        blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c !=0 && blItem.Phoenix_Proposed_Indirect_Selling_Unit__c !=null) ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c :(blItem.Phoenix_Override_Current_Indirect_Units__c != null && blItem.Phoenix_Override_Current_Indirect_Units__c !=0)? blItem.Phoenix_Override_Current_Indirect_Units__c: blItem.Phoenix_Current_Indirect_Selling_Unit__c!=null?blItem.Phoenix_Current_Indirect_Selling_Unit__c:0 ;
                        finalIndirectUnits = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                    }
                    blItem.Phoenix_Override_Total_units__c =blItem.Phoenix_Override_Current_Indirect_Units__c;
                    Decimal overallAmountIOD = IOP_per_unit_in * (finalIndirectUnits / 360) * (initialOrderDays != null ? initialOrderDays : 0);
                    blItem.Phoenix_Wholesaler_IOD_overall_amount__c = overallAmountIOD;
                    Decimal estimadeMedicaidreturns = blItem.Phoenix_Estimated_Medicaid_Returns__c != null ? blItem.Phoenix_Estimated_Medicaid_Returns__c : 0;
                    Decimal netSalesInternal = (indirectDeadnet * finalIndirectUnits) - overallAmountIOD - (estimadeMedicaidreturns * finalIndirectUnits);
                    blItem.Phoenix_Net_Sales_Internal__c = netSalesInternal;
                    Decimal CurrentABCProgenCP = blItem.Phoenix_Current_Wholesaler_Price__c != null ? blItem.Phoenix_Current_Wholesaler_Price__c : 0;
                    Decimal progenrebate = (rebateper/100) * CurrentABCProgenCP;
                    Decimal cashdiscountperc = (cashdiscountper) / 100;
                    Decimal progencd = wac * cashdiscountperc;
                    Decimal vir = (1/100) * CurrentABCProgenCP;
                    Decimal progenLocaldeadnet = (CurrentABCProgenCP != null && CurrentABCProgenCP !=0 ) ? CurrentABCProgenCP - progenrebate - progencd - vir :0;
                    Decimal difference_two = indirectDeadnet - progenLocaldeadnet;
                    blItem.Phoenix_Acquisition_Difference__c = difference_two;
                    blItem.Phoenix_Reduction__c = (blItem.Phoenix_Current_Indirect_Price__c != null && blItem.Phoenix_Current_Indirect_Price__c != 0) ? ((marketingprice / currentindirectprice - 1) * 100) : 0;
                    blItem.Phoenix_Proposed_Sales__c = (blItem.Phoenix_Direct_Dead_Net__c != null ? blItem.Phoenix_Direct_Dead_Net__c : 0)*(finalIndirectUnits); //added by Jogarao
                   	Decimal brandwac =( blItem.Brand_WAC__c != null && blItem.Brand_WAC__c !=0)?blItem.Brand_WAC__c:0;
                    blItem.Phoenix_Brand_WAC_Per__c = brandwac != 0 ? (indirectDeadnet / brandwac)*100 : 0;
                    Decimal openingorder = (blItem.Phoenix_Opening_Order__c != null && blItem.Phoenix_Opening_Order__c != 0)?blItem.Phoenix_Opening_Order__c :0;
                    blItem.Phoenix_Opening_Order_Net_sales__c = (openingorder * indirectDeadnet) - overallAmountIOD - (openingorder * estimadeMedicaidreturns);
                    Decimal openingOrdernetsales = (blItem.Phoenix_Opening_Order_Net_sales__c != null && blItem.Phoenix_Opening_Order_Net_sales__c != 0) ? blItem.Phoenix_Opening_Order_Net_sales__c : 0;
                    Decimal throughputcost = (blItem.Phoenix_Throughput_Cost1__c != null && blItem.Phoenix_Throughput_Cost1__c != 0)? blItem.Phoenix_Throughput_Cost1__c:0;
                    blItem.Phoenix_Opening_Order_TPT__c = openingOrdernetsales - (openingorder * throughputcost);
                    Decimal openingordertptdl = (blItem.Phoenix_Opening_Order_TPT__c != null &&  blItem.Phoenix_Opening_Order_TPT__c != 0) ?blItem.Phoenix_Opening_Order_TPT__c :0 ;
                    blItem.Phoenix_Opening_Order_TPT_Per__c = openingOrdernetsales !=0 ? (openingordertptdl / openingOrdernetsales)*100 :0 ;
                }*/
                 try{
                      if (blItem.Phoenix_Bid_Template_Refrence__c == 'ABC Pharmagen') {
                         
                    Decimal rebateper = blItem.Phoenix_Proposed_Current_Rebate__c != null ? blItem.Phoenix_Proposed_Current_Rebate__c : 0;
                    Decimal currentindirectprice = blItem.Phoenix_Current_Indirect_Price__c != null ? blItem.Phoenix_Current_Indirect_Price__c : 0;
                    blItem.Phoenix_Net_Price_afterRebates_after_VIP__c = currentindirectprice > 0 ? currentindirectprice * (rebateper / 100) :0 ;
                    
                    Decimal wac = blItem.Phoenix_WAC__c != null ? blItem.Phoenix_WAC__c : 0;
                    Decimal cashdiscountper = blItem.Phoenix_Indirect_CD_Per__c != null ? blItem.Phoenix_Indirect_CD_Per__c : 0;
                    blItem.Phoenix_WMT_CD_WMT_Indirect__c = currentindirectprice > 0 ? wac * (cashdiscountper / 100) : 0;
                    Decimal PharmagenDeadnet = (currentindirectprice > 0 ) ? currentindirectprice - blItem.Phoenix_Net_Price_afterRebates_after_VIP__c - blItem.Phoenix_WMT_CD_WMT_Indirect__c :0;
                    blItem.Phoenix_Customer_Dead_Net1__c = PharmagenDeadnet;
                    Decimal marketingprice = (blItem.Phoenix_ProposedContractBidPriceMktng__c != null && blItem.Phoenix_ProposedContractBidPriceMktng__c != 0) ?
                        blItem.Phoenix_ProposedContractBidPriceMktng__c : (blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null && blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != 0) ?
                            blItem.Phoenix_ProposedContract_Bid_Price_Sales__c : (blItem.Phoenix_Current_Indirect_Price__c != null && blItem.Phoenix_Current_Indirect_Price__c != 0) ?
                                blItem.Phoenix_Current_Indirect_Price__c :0; // : (blItem.Phoenix_Current_Wholesaler_Price__c != null && blItem.Phoenix_Current_Wholesaler_Price__c != 0) ?blItem.Phoenix_Current_Wholesaler_Price__c  removed by Jogarao
                    blItem.Phoenix_Net_Price_after_Rebates_Terms__c = marketingprice > 0 ? marketingprice * (rebateper / 100) :0;
                    Decimal rebate = blItem.Phoenix_Net_Price_after_Rebates_Terms__c != null ? blItem.Phoenix_Net_Price_after_Rebates_Terms__c :0;
                    Decimal indirectcd = blItem.Phoenix_INDIRECT_CD__c != null ? blItem.Phoenix_INDIRECT_CD__c : 0;
                    Decimal indirectDeadnet = (marketingprice > 0)?(marketingprice - rebate - indirectcd):0;
                    System.debug('indirect deadnet --->' + indirectDeadnet);
                    blItem.Phoenix_Direct_Dead_Net__c = indirectDeadnet > 0 ? indirectDeadnet : 0;
                    blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Indirect_Dead_Net__c > 0 ? blItem.Phoenix_Indirect_Dead_Net__c : 0;
                          //for additional rebate $
                          blItem.Phoenix_Additional_Rebate__c = ((1.25*marketingprice)/100).setScale(4);
                          //This is DRL Dead Net = Harmonized dead net - Additional Rebate $
                         blItem.Phoenix_Indirect_Dead_Net__c = (blItem.Phoenix_Direct_Dead_Net__c - blItem.Phoenix_Additional_Rebate__c).setScale(4);
                   /*  if(bidRec.Phoenix_Customer_Type__c == 'New Product Launch'){
                       Decimal proposedPrice = (blItem.Phoenix_ProposedContractBidPriceMktng__c != null) ?
                        blItem.Phoenix_ProposedContractBidPriceMktng__c :0;
                        blItem.Phoenix_Net_Price_after_Rebates_Terms__c = proposedPrice > 0 ? proposedPrice * (rebateper / 100) :0;
                        Decimal rebatepl =  blItem.Phoenix_Net_Price_after_Rebates_Terms__c !=null ?  blItem.Phoenix_Net_Price_after_Rebates_Terms__c:0;
                        Decimal indirectDeadnetPL = (proposedPrice > 0)?(proposedPrice - rebatepl - indirectcd):0;
                        blItem.Phoenix_Direct_Dead_Net__c = indirectDeadnetPL > 0 ? indirectDeadnetPL : 0;
                    	blItem.Phoenix_Internal_Dead_Net_Price__c = indirectDeadnetPL > 0 ? indirectDeadnetPL : 0;
                     }*/
                    // Decimal initialOrderDiscper = bidRec.Phoenix_Proposed_Initial_Order_Discount__c != null? bidRec.Phoenix_Proposed_Initial_Order_Discount__c : 0 ;
                    Decimal IOP_per_unit_in = wac * (initialOrderDisc/100);
                    blItem.Phoenix_Wholesaler_IOD_per_unit__c = IOP_per_unit_in;
                    //Decimal initialOrderdiscDays = bidRec.Phoenix_Initial_Order_Discount_of_Days__c != null? bidRec.Phoenix_Initial_Order_Discount_of_Days__c : 0 ;
                    Decimal finalIndirectUnits;
                    if (blItem.Phoenix_SCM_Final_Approval__c == true) {
                        finalIndirectUnits = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                    } else {
                        blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c !=0 && blItem.Phoenix_Proposed_Indirect_Selling_Unit__c !=null) ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c :(blItem.Phoenix_Override_Current_Indirect_Units__c != null && blItem.Phoenix_Override_Current_Indirect_Units__c !=0)? blItem.Phoenix_Override_Current_Indirect_Units__c: blItem.Phoenix_Current_Indirect_Selling_Unit__c!=null?blItem.Phoenix_Current_Indirect_Selling_Unit__c:0 ;
                        finalIndirectUnits = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                    }
                    blItem.Phoenix_Override_Total_units__c =blItem.Phoenix_Override_Current_Indirect_Units__c;
                    Decimal overallAmountIOD = IOP_per_unit_in * (finalIndirectUnits / 360) * (initialOrderDays != null ? initialOrderDays : 0);
                    blItem.Phoenix_Wholesaler_IOD_overall_amount__c = overallAmountIOD;
                    Decimal estimadeMedicaidreturns = blItem.Phoenix_Estimated_Medicaid_Returns__c != null ? blItem.Phoenix_Estimated_Medicaid_Returns__c : 0;
                    Decimal netSalesInternal = (blItem.Phoenix_Indirect_Dead_Net__c * finalIndirectUnits) - overallAmountIOD - (estimadeMedicaidreturns * finalIndirectUnits);
                    blItem.Phoenix_Net_Sales_Internal__c = blItem.Phoenix_Indirect_Dead_Net__c >0 ? netSalesInternal : 0;
                    blItem.Phoenix_Proposed_Sales__c = blItem.Phoenix_Net_Sales_Internal__c;
                    /*Difference between Dead net and ABC Progen Local Dead net*/
                    Decimal CurrentABCProgenCP = blItem.Phoenix_Current_Wholesaler_Price__c != null ? blItem.Phoenix_Current_Wholesaler_Price__c : 0;
                    blItem.Phoenix_Net_Price_after_RebatesbeforeVIP__c = CurrentABCProgenCP > 0 ? (rebateper/100) * CurrentABCProgenCP : 0;
                   	Decimal cashdiscountperc =(cashdiscountper) / 100 ;
                    blItem.Phoenix_Direct_CD__c =  CurrentABCProgenCP > 0 ? wac * cashdiscountperc :0;
                     blItem.Phoenix_Anda_VIP__c = CurrentABCProgenCP > 0 ?  0.01 * CurrentABCProgenCP : 0;
                    blItem.Phoenix_Current_McK_RAD_Dead_net__c =  CurrentABCProgenCP > 0 ?  CurrentABCProgenCP - blItem.Phoenix_Net_Price_after_RebatesbeforeVIP__c - blItem.Phoenix_Direct_CD__c - blItem.Phoenix_Anda_VIP__c : 0;
                    /*Difference between  progen deadnet and pharmagen deadnet*/
                    blItem.Phoenix_Current_WMT_Direct_Dead_net__c = blItem.Phoenix_Current_McK_RAD_Dead_net__c - blItem.Phoenix_Customer_Dead_Net1__c;
                    /* End Difference between pharmagen deadnet and progen deadnet*/
                   // Decimal progenrebate = CurrentABCProgenCP >0 ?(rebateper/100) * CurrentABCProgenCP :0;
                    //Decimal progencd = CurrentABCProgenCP > 0 ? wac * cashdiscountperc :0;
                    //Decimal vipperc = (blItem.Phoenix_Local_VIP__c)/100; 
                    //Phoenix_Proposed_Value_Est_VIP__c
                   // Decimal vipperc = (bidRec.Phoenix_Proposed_Value_Est_VIP__c != null && bidRec.Phoenix_Proposed_Value_Est_VIP__c != 0) ? (bidRec.Phoenix_Proposed_Value_Est_VIP__c) / 100 : (bidRec.Phoenix_Current_Value_Est_VIP__c != null && bidRec.Phoenix_Current_Value_Est_VIP__c != 0) ? (bidRec.Phoenix_Current_Value_Est_VIP__c) / 100 : 0;
                   // Decimal vir = (1/100) * CurrentABCProgenCP;
                   // Decimal progenLocaldeadnet = CurrentABCProgenCP > 0 ? CurrentABCProgenCP -  blItem.Phoenix_Net_Price_after_RebatesbeforeVIP__c -  blItem.Phoenix_Direct_CD__c -  blItem.Phoenix_Anda_VIP__c:0;
                    Decimal difference_two = blItem.Phoenix_Direct_Dead_Net__c - blItem.Phoenix_Current_McK_RAD_Dead_net__c;
                    blItem.Phoenix_Acquisition_Difference__c = difference_two;
                    /*End for Difference between Dead net and ABC Progen Local Dead net*/
                    blItem.Phoenix_Reduction__c = (blItem.Phoenix_Current_Indirect_Price__c != null && blItem.Phoenix_Current_Indirect_Price__c != 0) ? ((marketingprice / currentindirectprice - 1) * 100) : 0;
                     
                    // SSA Hit Calculation added by Jogarao
                    Decimal finalUnits =(blItem.Phoenix_Override_Current_Indirect_Units__c != null && blItem.Phoenix_Override_Current_Indirect_Units__c !=0)? blItem.Phoenix_Override_Current_Indirect_Units__c: (blItem.Phoenix_Current_Indirect_Selling_Unit__c!=null?blItem.Phoenix_Current_Indirect_Selling_Unit__c:0 );
                    Decimal DiffPrice = (blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c :0) - (blItem.Phoenix_Current_Indirect_Price__c != null ? blItem.Phoenix_Current_Indirect_Price__c : 0) ;
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
                    
                          
                	/* For New Product Launch */
                   	Decimal brandwac =( blItem.Brand_WAC__c != null && blItem.Brand_WAC__c !=0)?blItem.Brand_WAC__c:0;
                    blItem.Phoenix_Brand_WAC_Per__c = (brandwac != 0 && brandwac != null) ? (blItem.Phoenix_Indirect_Dead_Net__c / brandwac)*100 : 0;
                    Decimal openingorder = (blItem.Phoenix_Opening_Order__c != null && blItem.Phoenix_Opening_Order__c != 0)?blItem.Phoenix_Opening_Order__c :0;
                    blItem.Phoenix_Opening_Order_Net_sales__c = (blItem.Phoenix_Indirect_Dead_Net__c >0 && openingorder > 0)? (openingorder * blItem.Phoenix_Indirect_Dead_Net__c) - overallAmountIOD - (openingorder * estimadeMedicaidreturns) :0;
                    Decimal openingOrdernetsales = (blItem.Phoenix_Opening_Order_Net_sales__c != null && blItem.Phoenix_Opening_Order_Net_sales__c != 0) ? blItem.Phoenix_Opening_Order_Net_sales__c : 0;
                    Decimal throughputcost = (blItem.Phoenix_Throughput_Cost1__c != null && blItem.Phoenix_Throughput_Cost1__c != 0)? blItem.Phoenix_Throughput_Cost1__c:0;
                    blItem.Phoenix_Opening_Order_TPT__c = (blItem.Phoenix_Indirect_Dead_Net__c >0 && openingorder > 0) ? openingOrdernetsales - (openingorder * throughputcost) :0;
                    Decimal openingordertptdl = (blItem.Phoenix_Opening_Order_TPT__c != null &&  blItem.Phoenix_Opening_Order_TPT__c != 0) ?blItem.Phoenix_Opening_Order_TPT__c :0 ;
                    blItem.Phoenix_Opening_Order_TPT_Per__c =  ( blItem.Phoenix_Indirect_Dead_Net__c >0 && openingorder > 0 && openingOrdernetsales > 0) ? (openingordertptdl / openingOrdernetsales)*100 :0 ;
                          
                     //FOR Current Sales && NDC Finance View
                  
                     Decimal finalCurrentUnits = (blItem.Phoenix_Override_Current_Indirect_Units__c >0)? blItem.Phoenix_Override_Current_Indirect_Units__c : ((blItem.Phoenix_Current_Indirect_Selling_Unit__c > 0) ? blItem.Phoenix_Current_Indirect_Selling_Unit__c:0);
                        System.debug('final in direct units==>'+finalCurrentUnits);
                          System.debug('estimated returns==>'+estimadeMedicaidreturns);
                          System.debug('dead net track==>'+blItem.Phoenix_DeadNet_TrckGR__c);
                         blItem.Finance_Current_Sales__c = (blItem.Current_CVS_DeadNet__c != NULL ?(finalCurrentUnits * blItem.Current_CVS_DeadNet__c)-(estimadeMedicaidreturns * finalCurrentUnits):0) ;
                }
                 }
                 Catch(Exception e) {
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_BidLineItemTrigger', Phoenix_Method_Name__c = '', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                    insert exp;
                }
            
             if(bidLineItemExtnUpdateList.size() != 0){   
                Phoenix_Util.blnAlreadyDone = true;
                //RecurssionCheckForBidLineAndChild.firstRun = false;
                update bidLineItemExtnUpdateList; 
            }
          }
      }

}