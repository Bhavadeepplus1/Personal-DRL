public class Phoenix_BidItemTriggerHandlerCostco extends TriggerHandler {
		private list < Phoenix_Bid_Line_Item__c > triggerNew;
    	private list < Phoenix_Bid_Line_Item__c > triggerOld;
    	private Map < Id, Phoenix_Bid_Line_Item__c > newMap;
    	private Map < Id, Phoenix_Bid_Line_Item__c > oldMap;
    
    public Phoenix_BidItemTriggerHandlerCostco() {
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
          /*  if (blItem.Phoenix_Bid_Template_Refrence__c == 'Costco') {
                    Decimal marketingprice = (blItem.Phoenix_ProposedContractBidPriceMktng__c != null && blItem.Phoenix_ProposedContractBidPriceMktng__c != 0) ?
                        blItem.Phoenix_ProposedContractBidPriceMktng__c : (blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null && blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != 0) ?
                            blItem.Phoenix_ProposedContract_Bid_Price_Sales__c : (blItem.Phoenix_Current_Indirect_Price__c != null && blItem.Phoenix_Current_Indirect_Price__c != 0) ?
                                blItem.Phoenix_Current_Indirect_Price__c : 0;
                    Decimal wholesalerprice = (blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != null && blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != 0) ? blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c : blItem.Phoenix_Current_Indirect_Price__c != null ? blItem.Phoenix_Current_Indirect_Price__c : 0;
                    Decimal estimadeMedicaidreturns = blItem.Phoenix_Estimated_Medicaid_Returns__c != null ? blItem.Phoenix_Estimated_Medicaid_Returns__c : 0;
                    blItem.Phoenix_Proposed_Per_Unit_Rebate__c = marketingprice - wholesalerprice;
                    Decimal rebate = blItem.Phoenix_Customer_Rebates1__c;
                    Decimal cashdiscount = blItem.Phoenix_Direct_CD_Per_Unit__c;
                    Decimal indirectDeadnet = (wholesalerprice - rebate - cashdiscount);
                    blItem.Phoenix_Indirect_Dead_Net__c = indirectDeadnet;
                    blItem.Phoenix_Internal_Dead_Net_Price__c = indirectDeadnet;
                    
                    Decimal finalIndirectUnits;
                    if(blItem.Phoenix_SCM_Final_Approval__c==true){
                        finalIndirectUnits=blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                    }else{                      
                        blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c !=0 && blItem.Phoenix_Proposed_Indirect_Selling_Unit__c !=null) ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c :(blItem.Phoenix_Override_Current_Indirect_Units__c != null && blItem.Phoenix_Override_Current_Indirect_Units__c !=0)? blItem.Phoenix_Override_Current_Indirect_Units__c: blItem.Phoenix_Current_Indirect_Selling_Unit__c!=null?blItem.Phoenix_Current_Indirect_Selling_Unit__c:0 ;
                        finalIndirectUnits=blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c; 
                    }
                    blItem.Phoenix_Override_Total_units__c =blItem.Phoenix_Override_Current_Indirect_Units__c;
                    Decimal netSalesInternal = (indirectDeadnet * finalIndirectUnits - estimadeMedicaidreturns * finalIndirectUnits);
                    blItem.Phoenix_Net_Sales_Internal__c = netSalesInternal;
                    Decimal indirectnet = (blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != null) ? blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c : (blItem.Phoenix_Current_Indirect_Price__c != null) ? blItem.Phoenix_Current_Indirect_Price__c : 0;
                    Decimal currentprice = (blItem.Phoenix_Current_Indirect_Price__c != null) ? blItem.Phoenix_Current_Indirect_Price__c : 0;
                    blItem.Phoenix_Reduction__c = (blItem.Phoenix_Current_Indirect_Price__c != null && blItem.Phoenix_Current_Indirect_Price__c != 0) ? ((indirectnet / currentprice - 1) * 100) : 0;
                    Decimal brandwac =( blItem.Brand_WAC__c != null && blItem.Brand_WAC__c !=0)?blItem.Brand_WAC__c:0;
                    blItem.Phoenix_Brand_WAC_Per__c = brandwac != 0 ? (indirectDeadnet / brandwac)*100 : 0;
                    Decimal openingorder = (blItem.Phoenix_Opening_Order__c != null && blItem.Phoenix_Opening_Order__c != 0)?blItem.Phoenix_Opening_Order__c :0;
                    blItem.Phoenix_Opening_Order_Net_sales__c = (openingorder * indirectDeadnet) - (openingorder * estimadeMedicaidreturns);
                    Decimal openingOrdernetsales = (blItem.Phoenix_Opening_Order_Net_sales__c != null && blItem.Phoenix_Opening_Order_Net_sales__c != 0) ? blItem.Phoenix_Opening_Order_Net_sales__c : 0;
                    Decimal throughputcost = (blItem.Phoenix_Throughput_Cost1__c != null && blItem.Phoenix_Throughput_Cost1__c != 0)? blItem.Phoenix_Throughput_Cost1__c:0;
                    blItem.Phoenix_Opening_Order_TPT__c = openingOrdernetsales - (openingorder * throughputcost);
                    Decimal openingordertptdl = (blItem.Phoenix_Opening_Order_TPT__c != null &&  blItem.Phoenix_Opening_Order_TPT__c != 0) ?blItem.Phoenix_Opening_Order_TPT__c :0 ;
                    blItem.Phoenix_Opening_Order_TPT_Per__c = openingOrdernetsales !=0 ? (openingordertptdl / openingOrdernetsales)*100 :0 ;
                    blItem.Phoenix_Proposed_Sales__c = (blItem.Phoenix_Indirect_Dead_Net__c != null ? blItem.Phoenix_Indirect_Dead_Net__c : 0)*(finalIndirectUnits); // added by Jogarao
                }
            */
            if (blItem.Phoenix_Bid_Template_Refrence__c == 'Costco') {
                 try {
                    
                    //Decimal marketingprice = blItem.Phoenix_ProposedContractBidPriceMktng__c !=null? blItem.Phoenix_ProposedContractBidPriceMktng__c :0;
                    Decimal marketingprice = (blItem.Phoenix_ProposedContractBidPriceMktng__c != null && blItem.Phoenix_ProposedContractBidPriceMktng__c != 0) ?
                        blItem.Phoenix_ProposedContractBidPriceMktng__c : (blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null && blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != 0) ?
                            blItem.Phoenix_ProposedContract_Bid_Price_Sales__c : (blItem.Phoenix_Current_Indirect_Price__c != null && blItem.Phoenix_Current_Indirect_Price__c != 0) ?
                                blItem.Phoenix_Current_Indirect_Price__c : 0;
                    Decimal wholesalerprice = (blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != null && blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != 0) ? blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c : blItem.Phoenix_Current_Indirect_Price__c != null ? blItem.Phoenix_Current_Indirect_Price__c : 0;
                    Decimal estimadeMedicaidreturns = blItem.Phoenix_Estimated_Medicaid_Returns__c != null ? blItem.Phoenix_Estimated_Medicaid_Returns__c : 0;
                    blItem.Phoenix_Proposed_Per_Unit_Rebate__c = (blItem.Phoenix_ProposedContractBidPriceMktng__c == null && blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c == null) ? 0 : marketingprice - wholesalerprice;
                    Decimal proposedpur = blItem.Phoenix_Proposed_Per_Unit_Rebate__c != null ? blItem.Phoenix_Proposed_Per_Unit_Rebate__c :0;
                    blItem.Phoenix_Proposed_Per_Unit_Rebate__c= proposedpur > 0 ?  proposedpur : 0;
                    Decimal rebate = blItem.Phoenix_Customer_Rebates1__c != null? blItem.Phoenix_Customer_Rebates1__c : 0;
                    //Decimal cashdiscount = blItem.Phoenix_Direct_CD_Per_Unit__c != null ?blItem.Phoenix_Direct_CD_Per_Unit__c :0;
                     Decimal cashterms = bidRec.Phoenix_Proposed_Cash_Terms__c != null && bidRec.Phoenix_Proposed_Cash_Terms__c != 0 ? (bidRec.Phoenix_Proposed_Cash_Terms__c /100):0 ;
                    blItem.Phoenix_Direct_CD__c = marketingprice != null && marketingprice != 0 ? marketingprice * cashterms : 0;
                    Decimal cashdiscount = blItem.Phoenix_Direct_CD__c != null ? blItem.Phoenix_Direct_CD__c :0;
                	Decimal CIP = blItem.Phoenix_Current_Indirect_Price__c != null && blItem.Phoenix_Current_Indirect_Price__c != 0 ? blItem.Phoenix_Current_Indirect_Price__c :0;
                    Decimal CPU = blItem.Phoenix_Current_Per_Unit_Rebate__c != null && blItem.Phoenix_Current_Per_Unit_Rebate__c != 0 ? blItem.Phoenix_Current_Per_Unit_Rebate__c :0;
                	blItem.Phoenix_Current_Net_Indirect_Price__c = CIP - CPU;
                     Decimal currentnetIndirecPrice = (blItem.Phoenix_Current_Net_Indirect_Price__c != null && blItem.Phoenix_Current_Net_Indirect_Price__c != 0) ? blItem.Phoenix_Current_Net_Indirect_Price__c : blItem.Phoenix_Current_Indirect_Price__c != null ? blItem.Phoenix_Current_Indirect_Price__c : 0;
                     Decimal currentpur= blItem.Phoenix_Current_Per_Unit_Rebate__c !=null ? blItem.Phoenix_Current_Per_Unit_Rebate__c: 0;
                     blItem.Phoenix_Current_Per_Unit_Rebate__c = currentpur > 0 ? currentpur : 0;
                    Decimal indirectDeadnet =0;
                   if(bidRec.Phoenix_Bid_Type__c != 'Volume Review Only'){
                   indirectDeadnet =  wholesalerprice > 0 ? (wholesalerprice - rebate - cashdiscount) : 0;//(wholesalerprice > 0 && proposedpur > 0)? (wholesalerprice - rebate - cashdiscount) : 0; 
                   }
                   if(bidRec.Phoenix_Bid_Type__c == 'Volume Review Only'){
                      indirectDeadnet = currentnetIndirecPrice > 0 ? (currentnetIndirecPrice - rebate - cashdiscount) : 0;//(currentnetIndirecPrice > 0 && currentpur > 0)? (currentnetIndirecPrice - rebate - cashdiscount) : 0;
                    }
                   	blItem.Phoenix_Indirect_Dead_Net__c = indirectDeadnet > 0 ? indirectDeadnet : 0 ;
                 
                    blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Indirect_Dead_Net__c != null && blItem.Phoenix_Indirect_Dead_Net__c !=0 ? blItem.Phoenix_Indirect_Dead_Net__c :0;
                    
                    Decimal finalIndirectUnits;
                    if(blItem.Phoenix_SCM_Final_Approval__c==true){
                        finalIndirectUnits=blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                    }else{                      
                        blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c !=0 && blItem.Phoenix_Proposed_Indirect_Selling_Unit__c !=null) ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c :(blItem.Phoenix_Override_Current_Indirect_Units__c != null && blItem.Phoenix_Override_Current_Indirect_Units__c !=0)? blItem.Phoenix_Override_Current_Indirect_Units__c: blItem.Phoenix_Current_Indirect_Selling_Unit__c!=null?blItem.Phoenix_Current_Indirect_Selling_Unit__c:0 ;
                        finalIndirectUnits=blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c; 
                    }
                    blItem.Phoenix_Override_Total_units__c =(blItem.Phoenix_Override_Current_Indirect_Units__c != null && blItem.Phoenix_Override_Current_Indirect_Units__c !=0)?blItem.Phoenix_Override_Current_Indirect_Units__c:0;
                    Decimal netSalesInternal = (indirectDeadnet * finalIndirectUnits - estimadeMedicaidreturns * finalIndirectUnits);
                    blItem.Phoenix_Net_Sales_Internal__c = indirectDeadnet > 0 ? netSalesInternal :0;
                    Decimal indirectnet = (blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != null) ? blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c : (blItem.Phoenix_Current_Indirect_Price__c != null) ? blItem.Phoenix_Current_Indirect_Price__c : 0;
                    Decimal currentprice = (blItem.Phoenix_Current_Indirect_Price__c != null) ? blItem.Phoenix_Current_Indirect_Price__c : 0;
                    blItem.Phoenix_Reduction__c = (blItem.Phoenix_Current_Indirect_Price__c != null && blItem.Phoenix_Current_Indirect_Price__c != 0) ? ((indirectnet / currentprice - 1) * 100) : 0;
                    Decimal brandwac =( blItem.Brand_WAC__c != null && blItem.Brand_WAC__c !=0)?blItem.Brand_WAC__c:0;
                    blItem.Phoenix_Brand_WAC_Per__c = (brandwac != null && brandwac != 0) ? (indirectDeadnet / brandwac)*100 : 0;
                    Decimal openingorder = (blItem.Phoenix_Opening_Order__c != null && blItem.Phoenix_Opening_Order__c != 0)?blItem.Phoenix_Opening_Order__c :0;
                    blItem.Phoenix_Opening_Order_Net_sales__c = (indirectDeadnet > 0 && openingorder> 0) ? (openingorder * indirectDeadnet) - (openingorder * estimadeMedicaidreturns) : 0;
                    Decimal openingOrdernetsales = (blItem.Phoenix_Opening_Order_Net_sales__c != null && blItem.Phoenix_Opening_Order_Net_sales__c != 0) ? blItem.Phoenix_Opening_Order_Net_sales__c : 0;
                    Decimal throughputcost = (blItem.Phoenix_Throughput_Cost1__c != null && blItem.Phoenix_Throughput_Cost1__c != 0)? blItem.Phoenix_Throughput_Cost1__c:0;
                    blItem.Phoenix_Opening_Order_TPT__c = (indirectDeadnet > 0 && openingorder> 0) ? openingOrdernetsales - (openingorder * throughputcost) : 0;
                    Decimal openingordertptdl = (blItem.Phoenix_Opening_Order_TPT__c != null &&  blItem.Phoenix_Opening_Order_TPT__c != 0) ?blItem.Phoenix_Opening_Order_TPT__c :0 ;
                    blItem.Phoenix_Opening_Order_TPT_Per__c = (indirectDeadnet >0 && openingorder > 0 && openingOrdernetsales > 0) ? (openingordertptdl / openingOrdernetsales)*100 :0 ;
                    blItem.Phoenix_Proposed_Sales__c = blItem.Phoenix_Net_Sales_Internal__c ; // added by Jogarao
                 	//blItem.Phoenix_Current_Per_Unit_Rebate__c = blItem.Phoenix_Current_Indirect_Price__c  -  blItem.Phoenix_Current_Per_Unit_Rebate__c;
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
                        
                     //FOR Current Sales && NDC Finance View
                     //Phoenix_DeadNet_TrckGR__c  indirectDedadnet
                     Decimal finalCurrentUnits = (blItem.Phoenix_Override_Current_Indirect_Units__c >0)? blItem.Phoenix_Override_Current_Indirect_Units__c : ((blItem.Phoenix_Current_Indirect_Selling_Unit__c > 0) ? blItem.Phoenix_Current_Indirect_Selling_Unit__c:0);
                     blItem.Finance_Current_Sales__c = (blItem.Phoenix_DeadNet_TrckGR__c != NULL ? (finalCurrentUnits * blItem.Phoenix_DeadNet_TrckGR__c)-(estimadeMedicaidreturns * finalCurrentUnits) : 0);
                     
                 }
                Catch(Exception e) {
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_BidLineItemTrigger', Phoenix_Method_Name__c = '', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                    insert exp;
                }
            }
           if(bidLineItemExtnUpdateList.size() != 0){   
                Phoenix_Util.blnAlreadyDone = true;
                //RecurssionCheckForBidLineAndChild.firstRun = false;
                update bidLineItemExtnUpdateList; 
            }
        }
    }

}