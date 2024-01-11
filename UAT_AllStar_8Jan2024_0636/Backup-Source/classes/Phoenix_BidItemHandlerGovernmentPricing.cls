public class Phoenix_BidItemHandlerGovernmentPricing extends TriggerHandler {
    private list < Phoenix_Bid_Line_Item__c > triggerNew;
    private list < Phoenix_Bid_Line_Item__c > triggerOld;
    private Map < Id, Phoenix_Bid_Line_Item__c > newMap;
    private Map < Id, Phoenix_Bid_Line_Item__c > oldMap;
    
    public Phoenix_BidItemHandlerGovernmentPricing() {
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
        String bidType = bidRec.Phoenix_Bid_Type__c;
        
        Decimal initialOrderDays = bidRec.Phoenix_Initial_Order_Discount_of_Days__c != null? bidRec.Phoenix_Initial_Order_Discount_of_Days__c : 0 ;
        
        Decimal initialOrderDisc=bidRec.Phoenix_Proposed_Initial_Order_Discount__c != null? bidRec.Phoenix_Proposed_Initial_Order_Discount__c : 0 ;
        for (Phoenix_Bid_Line_Item__c blItem: triggerNew) {
            /*if(blItem.Phoenix_Bid_Template_Refrence__c=='Government Pricing'){
try{ 
Decimal wholeDiffPrIndirect = blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c:blItem.Phoenix_ProposedContract_Bid_Price_Sales__c !=null ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c:blItem.Phoenix_Current_Indirect_Price__c != null ?blItem.Phoenix_Current_Indirect_Price__c:0 ;
Decimal CMFee = (blItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c != null ? blItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c : 0)/100;
Decimal contractMngmtWhole = wholeDiffPrIndirect * CMFee;

//Decimal ProposedDirectcontract = blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c:0;
// blItem.Phoenix_Rebate_Perc_In__c=1
Decimal IndirectCD = blItem.Phoenix_INDIRECT_CD__c != null ? blItem.Phoenix_INDIRECT_CD__c : 0;
//Decimal DirectCD = blItem.Phoenix_Direct_CD_Per_Unit__c != null ? blItem.Phoenix_Direct_CD_Per_Unit__c : 0;
//Decimal NetIndirectPrice=ProposedDirectcontract+IndirectCD+contractMngmtWhole-DirectCD;

//no need
//Decimal PUR=wholeDiffPrIndirect-NetIndirectPrice;

Decimal RDCCurrency = blItem.Phoenix_RDC_NLC_Per_Unit_in__c != null ? blItem.Phoenix_RDC_NLC_Per_Unit_in__c : 0;
Decimal RebateCurrency = blItem.Phoenix_Customer_Rebates1__c != null ? blItem.Phoenix_Customer_Rebates1__c : 0;


Decimal InternalDeadNet=wholeDiffPrIndirect-IndirectCD-RDCCurrency-contractMngmtWhole-RebateCurrency;


Decimal ThroughputCost = blItem.Phoenix_Throughput_cost__c != null ? blItem.Phoenix_Throughput_cost__c:0;
Decimal TPT=InternalDeadNet-ThroughputCost;

if(InternalDeadNet >0){
Decimal TPTPercentage=(TPT/InternalDeadNet)*100;
}
Decimal finalIndirectUnits=0;
if(blItem.Phoenix_SCM_Final_Approval__c==true){
finalIndirectUnits=blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
}else{                      
blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c !=0 && blItem.Phoenix_Proposed_Indirect_Selling_Unit__c !=null) ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c :(blItem.Phoenix_Override_Current_Units__c != null && blItem.Phoenix_Override_Current_Units__c !=0)? blItem.Phoenix_Override_Current_Units__c: blItem.Phoenix_Current_Indirect_Selling_Unit__c!=null?blItem.Phoenix_Current_Indirect_Selling_Unit__c:0 ;
finalIndirectUnits=blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c; 
}

//Decimal ProposedIndirectSellingUnits = blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c:blItem.Phoenix_Current_Indirect_Selling_Unit__c != null ?blItem.Phoenix_Current_Indirect_Selling_Unit__c:0 ;
Decimal EstimatedMedicalReturns = blItem.Phoenix_Estimated_Medicaid_Returns__c != null  ? blItem.Phoenix_Estimated_Medicaid_Returns__c : 0;
Decimal InternalDNmultProposedSeelingUnits = InternalDeadNet*finalIndirectUnits;
Decimal EstimatedMedicalReturnsmultProposedSeelingUnits = EstimatedMedicalReturns*finalIndirectUnits;
Decimal NetSales=InternalDNmultProposedSeelingUnits-EstimatedMedicalReturnsmultProposedSeelingUnits;

Decimal TPTMultISU = ThroughputCost*finalIndirectUnits;
Decimal TPTCurrency=NetSales-TPTMultISU;

if(NetSales >0){
Decimal TPTCPercentage=(TPTCurrency/NetSales)*100;
}

//V
Decimal CurrentIndirectPrice=blItem.Phoenix_Current_Indirect_Price__c != null  ? blItem.Phoenix_Current_Indirect_Price__c : 0;
Decimal PercentageRebateValue;
if(CurrentIndirectPrice > 0){
PercentageRebateValue=((wholeDiffPrIndirect / CurrentIndirectPrice) - 1)*100;
}
//new code for New Product Launch Calc
Decimal brandwac =( blItem.Brand_WAC__c != null && blItem.Brand_WAC__c !=0)?blItem.Brand_WAC__c:0;
blItem.Phoenix_Brand_WAC_Per__c = brandwac != 0 ? (InternalDeadNet / brandwac)*100 : 0;
Decimal openingorder = (blItem.Phoenix_Opening_Order__c != null && blItem.Phoenix_Opening_Order__c != 0)?blItem.Phoenix_Opening_Order__c :0;
blItem.Phoenix_Opening_Order_Net_sales__c = (openingorder * InternalDeadNet) - (openingorder * EstimatedMedicalReturns);
Decimal openingOrdernetsales = (blItem.Phoenix_Opening_Order_Net_sales__c != null && blItem.Phoenix_Opening_Order_Net_sales__c != 0) ? blItem.Phoenix_Opening_Order_Net_sales__c : 0;
Decimal throughputcost1 = (blItem.Phoenix_Throughput_Cost1__c != null && blItem.Phoenix_Throughput_Cost1__c != 0)? blItem.Phoenix_Throughput_Cost1__c:0;
blItem.Phoenix_Opening_Order_TPT__c = openingOrdernetsales - (openingorder * throughputcost1);
Decimal openingordertptdl = (blItem.Phoenix_Opening_Order_TPT__c != null &&  blItem.Phoenix_Opening_Order_TPT__c != 0) ?blItem.Phoenix_Opening_Order_TPT__c :0 ;
blItem.Phoenix_Opening_Order_TPT_Per__c = openingOrdernetsales !=0 ? (openingordertptdl / openingOrdernetsales)*100 :0 ;
//
blItem.Phoenix_Reduction__c = PercentageRebateValue; //V
//blItem.Phoenix_Customer_Dead_Net1__c = NetIndirectPrice; //y
blItem.Phoenix_Contract_Mngmnt_Fee_Wholesaler__c = contractMngmtWhole; //ab Phoenix_Contract_Mngmnt_Fee_Wholesaler__c
//blItem.Phoenix_Proposed_Per_Unit_Rebate__c = PUR;//ad
if(InternalDeadNet < 0){
blItem.Phoenix_Indirect_Dead_Net__c = 0; //ae
blItem.Phoenix_Internal_Dead_Net_Price__c = 0;
}
else{
blItem.Phoenix_Indirect_Dead_Net__c = InternalDeadNet; //ae
blItem.Phoenix_Internal_Dead_Net_Price__c = InternalDeadNet;
}
//this is we need to do for Govt Pricing
//blItem.Phoenix_Indirect_Dead_Net__c = InternalDeadNet; //ae
//
//blItem.Phoenix_Internal_Dead_Net_Price__c = InternalDeadNet;
blItem.Phoenix_Net_Sales_Internal__c = NetSales;//ai
//blItem.Phoenix_Current_Net_Indirect_Price__c=blItem.Phoenix_Current_Indirect_Price__c-blItem.Phoenix_Current_Per_Unit_Rebate__c; //curent net indirect price
blItem.Phoenix_Proposed_Sales__c = (blItem.Phoenix_Indirect_Dead_Net__c != null ? blItem.Phoenix_Indirect_Dead_Net__c : 0)*(finalIndirectUnits); //added by Jogarao
}
Catch(Exception e) {Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c='Phoenix_SubmitBidForApprovalCtrl',Phoenix_Method_Name__c='calculateFinanceGrid', Phoenix_Error_Message__c=e.getMessage(),Phoenix_Issue_Status__c='Pending',  Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c=e.getStackTraceString(),Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;}

}
*/
            if(blItem.Phoenix_Bid_Template_Refrence__c == 'Government Pricing'){
                try{ 
                    Decimal wholeDiffPrIndirect = blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c : blItem.Phoenix_Current_Indirect_Price__c != null ? blItem.Phoenix_Current_Indirect_Price__c : 0 ;
                    Decimal CMFee = (blItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c != null ? blItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c : 0)/100;
                    Decimal contractMngmtWhole = wholeDiffPrIndirect * CMFee;
                    
                    //Decimal ProposedDirectcontract = blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c:0;
                    // blItem.Phoenix_Rebate_Perc_In__c=1
                    Decimal IndirectCD = blItem.Phoenix_INDIRECT_CD__c != null ? blItem.Phoenix_INDIRECT_CD__c : 0;
                    //Decimal DirectCD = blItem.Phoenix_Direct_CD_Per_Unit__c != null ? blItem.Phoenix_Direct_CD_Per_Unit__c : 0;
                    //Decimal NetIndirectPrice=ProposedDirectcontract+IndirectCD+contractMngmtWhole-DirectCD;
                    
                    //no need
                    //Decimal PUR=wholeDiffPrIndirect-NetIndirectPrice;
                    
                    Decimal RDCCurrency = blItem.Phoenix_RDC_NLC_Per_Unit_in__c != null ? blItem.Phoenix_RDC_NLC_Per_Unit_in__c : 0;
                    Decimal RebateCurrency = blItem.Phoenix_Customer_Rebates1__c != null ? blItem.Phoenix_Customer_Rebates1__c : 0;
                    
                    
                    Decimal InternalDeadNet=wholeDiffPrIndirect-IndirectCD-RDCCurrency-contractMngmtWhole-RebateCurrency;
                    
                    system.debug('InternalDeadNet'+InternalDeadNet);
                    Decimal ThroughputCost = blItem.Phoenix_Throughput_cost__c != null ? blItem.Phoenix_Throughput_cost__c:0;
                    Decimal TPT=InternalDeadNet-ThroughputCost;
                  /*  if(bidType == 'New Product Launch')
                    {
                        blItem.Phoenix_Current_Indirect_Price__c=0;
                        blItem.Phoenix_Current_Indirect_Selling_Unit__c=0;
                        blItem.Phoenix_12_Months_IndirectSaleUnit__c=0;
                        blItem.Phoenix_Override_Current_Units__c=0;
                        //
                        blItem.Phoenix_12_Months_Actual_Sales__c=0;
                    }*/
                    if(InternalDeadNet >0){
                        Decimal TPTPercentage=(TPT/InternalDeadNet)*100;
                    }
                    Decimal finalIndirectUnits=0;
                    if(blItem.Phoenix_SCM_Final_Approval__c==true){
                        finalIndirectUnits=blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                    }else{                      
                        blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c !=0 && blItem.Phoenix_Proposed_Indirect_Selling_Unit__c !=null) ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c :(blItem.Phoenix_Override_Current_Units__c != null && blItem.Phoenix_Override_Current_Units__c !=0)? blItem.Phoenix_Override_Current_Units__c: blItem.Phoenix_Current_Indirect_Selling_Unit__c!=null?blItem.Phoenix_Current_Indirect_Selling_Unit__c:0 ;
                        finalIndirectUnits=blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c; 
                    }
                    //new code
                    blItem.Phoenix_Override_Total_units__c =blItem.Phoenix_Override_Current_Units__c;
                    
                    //
                    //Decimal ProposedIndirectSellingUnits = blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c:blItem.Phoenix_Current_Indirect_Selling_Unit__c != null ?blItem.Phoenix_Current_Indirect_Selling_Unit__c:0 ;
                    Decimal EstimatedMedicalReturns = blItem.Phoenix_Estimated_Medicaid_Returns__c != null  ? blItem.Phoenix_Estimated_Medicaid_Returns__c : 0;
                    Decimal InternalDNmultProposedSeelingUnits = InternalDeadNet*finalIndirectUnits;
                    Decimal EstimatedMedicalReturnsmultProposedSeelingUnits = EstimatedMedicalReturns*finalIndirectUnits;
                    Decimal NetSales=InternalDNmultProposedSeelingUnits-EstimatedMedicalReturnsmultProposedSeelingUnits;
                    
                    Decimal TPTMultISU = ThroughputCost*finalIndirectUnits;
                    Decimal TPTCurrency=NetSales-TPTMultISU;
                    
                    if(NetSales >0){
                        Decimal TPTCPercentage=(TPTCurrency/NetSales)*100;
                    }
                    
                    //V
                    Decimal CurrentIndirectPrice=blItem.Phoenix_Current_Indirect_Price__c != null  ? blItem.Phoenix_Current_Indirect_Price__c : 0;
                    Decimal PercentageRebateValue;
                    if(CurrentIndirectPrice > 0){
                        PercentageRebateValue=((wholeDiffPrIndirect / CurrentIndirectPrice) - 1)*100;
                    }
                    //
                    blItem.Phoenix_Reduction__c = PercentageRebateValue; //V
                    //blItem.Phoenix_Customer_Dead_Net1__c = NetIndirectPrice; //y
                    blItem.Phoenix_Contract_Mngmnt_Fee_Wholesaler__c = contractMngmtWhole; //ab Phoenix_Contract_Mngmnt_Fee_Wholesaler__c
                    //blItem.Phoenix_Proposed_Per_Unit_Rebate__c = PUR;//ad
                    /*if(InternalDeadNet < 0){
                        blItem.Phoenix_Indirect_Dead_Net__c = 0; //ae
                        blItem.Phoenix_Internal_Dead_Net_Price__c = 0;
                    }*/
                    if(InternalDeadNet < 0 || InternalDeadNet == 0){
                        blItem.Phoenix_Indirect_Dead_Net__c = 0; //ae
                        blItem.Phoenix_Internal_Dead_Net_Price__c = 0;
                        NetSales=0;//making netsales 0 if deadnet is -ve
                    }
                    else{
                        blItem.Phoenix_Indirect_Dead_Net__c = InternalDeadNet; //ae
                        blItem.Phoenix_Internal_Dead_Net_Price__c = InternalDeadNet;
                    }
                    //this is we need to do for Govt Pricing
                    //blItem.Phoenix_Indirect_Dead_Net__c = InternalDeadNet; //ae
                    //
                    //blItem.Phoenix_Internal_Dead_Net_Price__c = InternalDeadNet;
                    blItem.Phoenix_Net_Sales_Internal__c = NetSales;//ai
                    //blItem.Phoenix_Current_Net_Indirect_Price__c=blItem.Phoenix_Current_Indirect_Price__c-blItem.Phoenix_Current_Per_Unit_Rebate__c; //curent net indirect price
                    //new code for New Product Launch Calc
                    Decimal brandwac =( blItem.Brand_WAC__c != null && blItem.Brand_WAC__c !=0)?blItem.Brand_WAC__c:0;
                    blItem.Phoenix_Brand_WAC_Per__c = (brandwac != 0 && brandwac != null)? (InternalDeadNet / brandwac)*100 : 0;
                    Decimal openingorder = (blItem.Phoenix_Opening_Order__c != null && blItem.Phoenix_Opening_Order__c != 0)?blItem.Phoenix_Opening_Order__c :0;
					blItem.Phoenix_Opening_Order_Net_sales__c = (openingorder>0 && InternalDeadNet>0)?(openingorder * InternalDeadNet) - (openingorder * EstimatedMedicalReturns) : 0;
					Decimal openingOrdernetsales = (blItem.Phoenix_Opening_Order_Net_sales__c != null && blItem.Phoenix_Opening_Order_Net_sales__c != 0) ? blItem.Phoenix_Opening_Order_Net_sales__c : 0;
					Decimal throughputcost1 = (blItem.Phoenix_Throughput_Cost1__c != null && blItem.Phoenix_Throughput_Cost1__c != 0)? blItem.Phoenix_Throughput_Cost1__c:0;
					blItem.Phoenix_Opening_Order_TPT__c = (openingorder>0 && InternalDeadNet>0)? openingOrdernetsales - (openingorder * throughputcost1):0;
					Decimal openingordertptdl = (blItem.Phoenix_Opening_Order_TPT__c != null &&  blItem.Phoenix_Opening_Order_TPT__c != 0) ?blItem.Phoenix_Opening_Order_TPT__c :0 ;
					blItem.Phoenix_Opening_Order_TPT_Per__c = (openingorder>0 && InternalDeadNet>0 && openingOrdernetsales>0)? (openingordertptdl / openingOrdernetsales)*100 :0 ;
					               
                    blItem.Phoenix_Proposed_Sales__c = blItem.Phoenix_Net_Sales_Internal__c; //added by Jogarao
                    // SSA Hit Calculation 
                    Decimal finalUnits =(blItem.Phoenix_Override_Current_Units__c != null && blItem.Phoenix_Override_Current_Units__c !=0)? blItem.Phoenix_Override_Current_Units__c: (blItem.Phoenix_Current_Indirect_Selling_Unit__c!=null?blItem.Phoenix_Current_Indirect_Selling_Unit__c:0 );
                    Decimal DiffPrice = (blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c != null ? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c :0) - (blItem.Phoenix_Current_Indirect_Price__c != null ? blItem.Phoenix_Current_Indirect_Price__c : 0) ;
                    Decimal SSANoofDays = (bidRec.Phoenix_Proposed_SSA_No_of_Days__c != null ? bidRec.Phoenix_Proposed_SSA_No_of_Days__c :0)/30;
                    blItem.Phoenix_SSA_Hit_Updated__c = DiffPrice * SSANoofDays * (finalIndirectUnits/12);
                    
                    //Price and Volume Variance calculations 
                    
                    Decimal currentIndirUnits = finalUnits;
                    Decimal ProposedIndirectUnis = (blItem.Phoenix_SCM_Final_Approval__c == true ? finalIndirectUnits : (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c:0))-currentIndirUnits;
                    
                    Decimal indirectDedadnet = (blItem.Phoenix_Internal_Dead_Net_Price__c != null ? blItem.Phoenix_Internal_Dead_Net_Price__c : 0)-(blItem.Phoenix_Current_ASP_Dose__c!=null?blItem.Phoenix_Current_ASP_Dose__c:0);
                    
                    Decimal priceVarianceIndir = indirectDedadnet *currentIndirUnits;
                    
                    Decimal volumeVarianceIndir = indirectDedadnet*ProposedIndirectUnis;
                    
                    blItem.Phoenix_Price_Variance__c = (bidType == 'Sales Out Rebate' || bidType == 'RFP Bids' || bidType == 'Price Change' || bidType == 'Customer Rebate Change') ? ( priceVarianceIndir):0;
                    blItem.Phoenix_Volume_Variance__c = (bidType == 'Sales Out Rebate' || bidType == 'Price Change' || bidType == 'Customer Rebate Change') ? 0 : ( volumeVarianceIndir) ;
                    //Decimal currentCVSIndirectSales = (((blItem.Current_CVS_Indirect_DeadNet__c != null ? blItem.Current_CVS_Indirect_DeadNet__c: 0)* (finalUnits)) - ((finalUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c));
                        Decimal currentCVSIndirectSales = (blItem.Current_CVS_Indirect_DeadNet__c != null ? ((blItem.Current_CVS_Indirect_DeadNet__c* (finalUnits)) - ((finalUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c)): 0);
                        blItem.Finance_Current_Sales__c = currentCVSIndirectSales;
                    system.debug('currentCVSIndirectSales-----'+currentCVSIndirectSales);
                        }
                Catch(Exception e) {Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c='Phoenix_SubmitBidForApprovalCtrl',Phoenix_Method_Name__c='calculateFinanceGrid', Phoenix_Error_Message__c=e.getMessage(),Phoenix_Issue_Status__c='Pending',  Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c=e.getStackTraceString(),Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;}
                
            }
            if(bidLineItemExtnUpdateList.size() != 0){   
                Phoenix_Util.blnAlreadyDone = true;
                //RecurssionCheckForBidLineAndChild.firstRun = false;
                update bidLineItemExtnUpdateList; 
            } 
        }
    }    
}