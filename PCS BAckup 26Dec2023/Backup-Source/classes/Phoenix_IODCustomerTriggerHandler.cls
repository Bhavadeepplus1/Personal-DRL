public class Phoenix_IODCustomerTriggerHandler extends TriggerHandler {
    private list < Phoenix_Bid_Line_Item__c > triggerNew;
    private list < Phoenix_Bid_Line_Item__c > triggerOld;
    private Map < Id, Phoenix_Bid_Line_Item__c > newMap;
    private Map < Id, Phoenix_Bid_Line_Item__c > oldMap;
    
    public Phoenix_IODCustomerTriggerHandler() {
        this.newMap = (Map < Id, Phoenix_Bid_Line_Item__c > ) Trigger.newMap;
        this.oldMap = (Map < Id, Phoenix_Bid_Line_Item__c > ) Trigger.oldMap;
        this.triggerNew = (List < Phoenix_Bid_Line_Item__c > ) Trigger.new;
        this.triggerOld = (List < Phoenix_Bid_Line_Item__c > ) Trigger.old;
    }
    
    
    
    public override void beforeInsert() {
        beforeUpdate();
        
        
    }
    public override void beforeUpdate() {
        Phoenix_Bid__c bidRec = [SELECT Id,Phoenix_Customer_Type__c, Phoenix_Proposed_SSA_No_of_Days__c,Phoenix_Customer__r.Phoenix_Rebates__c,Phoenix_Customer__r.Phoenix_Cash_Discount__c ,Phoenix_Customer__r.Phoenix_Fee__c,Phoenix_Customer__r.Phoenix_CM_Fees__c,Phoenix_Bid_Proposed_Position__c, Phoenix_Approval_Status__c,Phoenix_Proposed_Cash_Terms__c,Phoenix_Initial_Order_Discount_Type__c, Phoenix_Custom_type__c, Phoenix_Current_CD__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =:triggerNew[0].Phoenix_Bid__c];
        String bidType= bidRec.Phoenix_Bid_Type__c;  
        
        for (Phoenix_Bid_Line_Item__c blItem: triggerNew) {
            if (bidType == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)') {
                try {
                
                    Decimal WAC = blItem.Phoenix_WAC1__c != null ? blItem.Phoenix_WAC1__c : 0; 
                    Decimal IndirectContractPrice = blItem.Phoenix_Retail_Direct_Price__c != null ? blItem.Phoenix_Retail_Direct_Price__c : 0;
                    Decimal rebate = blItem.Phoenix_Current_Rebate__c != null ? blItem.Phoenix_Current_Rebate__c : 0;
                    Decimal cashTerm = blItem.Phoenix_Indirect_CD_Per__c != null ? blItem.Phoenix_Indirect_CD_Per__c : 0; 
                    Decimal adminFee = blItem.Phoenix_Current_Admin_Fee__c != null ? blItem.Phoenix_Current_Admin_Fee__c : 0;
                    Decimal VIP = blItem.Phoenix_Local_VIP__c != null ? blItem.Phoenix_Local_VIP__c : 0; 
                    Decimal IODDiscount = bidRec.Phoenix_Proposed_Initial_Order_Discount__c != null ? bidRec.Phoenix_Proposed_Initial_Order_Discount__c : 0;
                    Decimal CMFee = blItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c != null ? blItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c : 0; 
                    Decimal MediReturnUnit = blItem.Phoenix_Estimated_Medicaid_Returns__c != null ? blItem.Phoenix_Estimated_Medicaid_Returns__c : 0;
                    Decimal PUR = blItem.Phoenix_Proposed_Per_Unit_Rebate__c != null ? blItem.Phoenix_Proposed_Per_Unit_Rebate__c :0;
                    Decimal TpCost = blItem.Phoenix_Throughput_Cost1__c != null ? blItem.Phoenix_Throughput_Cost1__c :0;
                    Decimal prpofitSharepercent = blItem.Phoenix_PS_Partner_1percent__c!=null ? blItem.Phoenix_PS_Partner_1percent__c :0;
                    blItem.Phoenix_Net_Price_afterRebates_after_VIP__c = IndirectContractPrice * (rebate/100);
                    blItem.Phoenix_Anda_VIP__c = IndirectContractPrice * (VIP/100);
                    blItem.Phoenix_Anda_Admin_Fees__c = IndirectContractPrice * (adminFee/100);
                    
                    //Customer Net Price 
                    blItem.Phoenix_Wholesaler_DRL_Net_Price__c = IndirectContractPrice - PUR - blItem.Phoenix_Net_Price_afterRebates_after_VIP__c - blItem.Phoenix_Anda_VIP__c -blItem.Phoenix_Anda_Admin_Fees__c;
                    blItem.Phoenix_Cash_Terms_RxSS__c = WAC*(cashTerm/100);
                    blItem.Phoenix_Retail_Indirect_WholesalerFeeRxS__c = IndirectContractPrice*(CMFee/100);
                    //DRL Net Price
                    blItem.Phoenix_Customer_Dead_Net1__c = IndirectContractPrice > 0 ? (blItem.Phoenix_Wholesaler_DRL_Net_Price__c - blItem.Phoenix_Cash_Terms_RxSS__c -blItem.Phoenix_Retail_Indirect_WholesalerFeeRxS__c -MediReturnUnit):0;
                    //Monthly Usage
                    blItem.Phoenix_Others_Indirect__c = (blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c!=null ? blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c:0)/12;
                    // IOD Per Units
                    blItem.Phoenix_ANDA_IOD_Per_unit__c = (IODDiscount/100)*WAC;
                    //IOD based on eligibility
                    blItem.Phoenix_Retail_IOD_overall_amount__c = (IODDiscount/100)*WAC* ((blItem.Phoenix_Proposed_Anda_Units__c!=null?blItem.Phoenix_Proposed_Anda_Units__c:0));
                    blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = blItem.Phoenix_Proposed_Anda_Units__c;
                    //Annual Net Sales
                    blItem.Phoenix_ANDA_IOD_Overall_Amount__c = (((blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c!=null?blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c:0)*(blItem.Phoenix_Customer_Dead_Net1__c!=null?blItem.Phoenix_Customer_Dead_Net1__c:0))- (blItem.Phoenix_Retail_IOD_overall_amount__c!=null?blItem.Phoenix_Retail_IOD_overall_amount__c:0));
                    //COGS 
                    blItem.Phoenix_Wholesaler_IOD_overall_amount__c = (blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c!=null ? blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c:0)*TpCost;
                    // GM Before PS to JM
                    blItem.Phoenix_Wholesaler_IOD_per_unit__c = (blItem.Phoenix_ANDA_IOD_Overall_Amount__c!=null?blItem.Phoenix_ANDA_IOD_Overall_Amount__c:0)-(blItem.Phoenix_Wholesaler_IOD_overall_amount__c!=null?blItem.Phoenix_Wholesaler_IOD_overall_amount__c:0);
                    //Market Share
                    blItem.Phoenix_Net_Price_after_Rebates_Terms__c = (blItem.Phoenix_Wholesaler_IOD_per_unit__c!=null?blItem.Phoenix_Wholesaler_IOD_per_unit__c:0)*(prpofitSharepercent/100);
                    //DRL net Profit
                    blItem.Phoenix_Retail_Direct_Net_sales__c = (blItem.Phoenix_Net_Price_after_Rebates_Terms__c!=null?blItem.Phoenix_Net_Price_after_Rebates_Terms__c:0)-(blItem.Phoenix_Wholesaler_IOD_per_unit__c!=null?blItem.Phoenix_Wholesaler_IOD_per_unit__c:0);
                   //TP %
                   blItem.Phoenix_Retail_Indirect_DRL_TPT_Percent__c = (blItem.Phoenix_ANDA_IOD_Overall_Amount__c!=null?blItem.Phoenix_ANDA_IOD_Overall_Amount__c:0) > 0 ? ((blItem.Phoenix_Retail_Direct_Net_sales__c!=null?blItem.Phoenix_Retail_Direct_Net_sales__c:0)/(blItem.Phoenix_ANDA_IOD_Overall_Amount__c!=null?blItem.Phoenix_ANDA_IOD_Overall_Amount__c:0)):0;
                    
                    
                    
                    
                        //Price and Volume Variance calculations 
                        
                        Decimal currentIndirUnits = 0;
                        Decimal ProposedIndirectUnis = (blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c != null ? blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c:0);
                        
                        Decimal indirectDedadnet = blItem.Phoenix_Customer_Dead_Net1__c != null ? blItem.Phoenix_Customer_Dead_Net1__c : 0;
                    
                        Decimal priceVarianceIndir = indirectDedadnet *currentIndirUnits;
                       
                        Decimal volumeVarianceIndir = indirectDedadnet*ProposedIndirectUnis;
                      
                    	//blItem.Phoenix_Price_Variance__c = (bidType == 'Sales Out Rebate' || bidType == 'RFP Bids' || bidType == 'Price Change' || bidType == 'Customer Rebate Change' || bidType == 'Volume Review Only') ? ( priceVarianceIndir):0;
                    	//blItem.Phoenix_Volume_Variance__c = (bidType == 'Sales Out Rebate' || bidType == 'Price Change' || bidType == 'Customer Rebate Change') ? 0 : ( volumeVarianceIndir) ;  
                    
                }
                
                
                Catch(Exception e) {
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_BidLineItemTrigger', Phoenix_Method_Name__c = '', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                    insert exp;
                }
            }
            
        }
    }
}