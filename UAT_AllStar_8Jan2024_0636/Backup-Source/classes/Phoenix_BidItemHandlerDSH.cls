public class Phoenix_BidItemHandlerDSH extends TriggerHandler {
    private list < Phoenix_Bid_Line_Item__c > triggerNew;
    private list < Phoenix_Bid_Line_Item__c > triggerOld;
    private Map < Id, Phoenix_Bid_Line_Item__c > newMap;
    private Map < Id, Phoenix_Bid_Line_Item__c > oldMap;
    
    public Phoenix_BidItemHandlerDSH() {
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
            if (blItem.Phoenix_Bid_Template_Refrence__c == 'BASE/DSH') {
                try {
                    
                    Decimal whlsrControlSubFee = blItem.Phoenix_Whlsr_Controlled_Substance_Fee__c != null ? blItem.Phoenix_Whlsr_Controlled_Substance_Fee__c : 0;
                    Decimal currentBaseUnits = blItem.Phoenix_Current_Wholesaler_Units__c != null ? blItem.Phoenix_Current_Wholesaler_Units__c : 0;
                    Decimal currentDSHUnits = blItem.Phoenix_Current_Anda_Units__c != null ? blItem.Phoenix_Current_Anda_Units__c : 0;
                    Decimal currentAutoSubUnits = blItem.Phoenix_Current_Retail_Direct_Units__c != null ? blItem.Phoenix_Current_Retail_Direct_Units__c : 0;
                    
                    Decimal overrideBaseUnits = blItem.Phoenix_Override_Current_Direct_Units__c != null ? blItem.Phoenix_Override_Current_Direct_Units__c : 0;
                    Decimal overrideDSHUnits = blItem.Phoenix_Override_Current_Indirect_Units__c != null ? blItem.Phoenix_Override_Current_Indirect_Units__c : 0;
                    Decimal overrideAutoSubUnits = blItem.Phoenix_Override_Current_Units__c != null ? blItem.Phoenix_Override_Current_Units__c : 0;
                    
                     Decimal proposedBaseUnits = blItem.Phoenix_Proposed_Smith_Drug_Units__c != null ? blItem.Phoenix_Proposed_Smith_Drug_Units__c : 0;
                    Decimal proposedDSHUnits = blItem.Phoenix_Proposed_Anda_Units__c != null ? blItem.Phoenix_Proposed_Anda_Units__c : 0;
                    Decimal proposedAutoSubUnits = blItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c != null ? blItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c : 0;
                    
                   Decimal overrideTotalUnits=   overrideBaseUnits+overrideDSHUnits+overrideAutoSubUnits;     
                     Decimal currentTotalUnits=   currentBaseUnits+currentDSHUnits+currentAutoSubUnits;     
                    
                    
                    Decimal WAC = blItem.Phoenix_WAC1__c != null ? blItem.Phoenix_WAC1__c : 0; 
                    Decimal rebate = blItem.Phoenix_Current_Rebate__c != null ? blItem.Phoenix_Current_Rebate__c : 0;
                    Decimal cashTerm = blItem.Phoenix_Indirect_CD_Per__c != null ? blItem.Phoenix_Indirect_CD_Per__c : 0; 
                    Decimal adminFee = blItem.Phoenix_Current_Admin_Fee__c != null ? blItem.Phoenix_Current_Admin_Fee__c : 0;
                    Decimal VIP = blItem.Phoenix_Local_VIP__c != null ? blItem.Phoenix_Local_VIP__c : 0; 
                    //Decimal IOD = bidRec.Phoenix_Proposed_Initial_Order_Discount__c != null ? bidRec.Phoenix_Proposed_Initial_Order_Discount__c : 0;
                    Decimal CMFee = blItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c != null ? blItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c : 0; 
                    Decimal MediReturnUnit = blItem.Phoenix_Estimated_Medicaid_Returns__c != null ? blItem.Phoenix_Estimated_Medicaid_Returns__c : 0;
                    
                    Decimal monthBaseSellingUnits = blItem.Phoenix_Current_Wholesaler_Units__c != null ? blItem.Phoenix_Current_Wholesaler_Units__c : 0; Decimal monthDSHSellingUnits = blItem.Phoenix_Current_Anda_Units__c != null ? blItem.Phoenix_Current_Anda_Units__c : 0;  Decimal monthAutoSubSellingUnits = blItem.Phoenix_Current_Retail_Direct_Units__c != null ? blItem.Phoenix_Current_Retail_Direct_Units__c : 0; blItem.Phoenix_Current_Direct_Selling_Unit__c = monthBaseSellingUnits + monthDSHSellingUnits + monthAutoSubSellingUnits;
                    
                    Decimal BaseActualSalesUnits = blItem.Phoenix_12_Months_IndirectSaleUnit__c != null ? blItem.Phoenix_12_Months_IndirectSaleUnit__c : 0; Decimal DSHActualSalesUnits = blItem.Phoenix_12_Months_Actual_Sales__c != null ? blItem.Phoenix_12_Months_Actual_Sales__c : 0; Decimal AutoSubActualSalesUnits = blItem.Phoenix_ProposedDirectGaintEagleUnits__c != null ? blItem.Phoenix_ProposedDirectGaintEagleUnits__c : 0; blItem.Phoenix_12_Months_TotalSaleUnits__c = BaseActualSalesUnits + DSHActualSalesUnits + AutoSubActualSalesUnits;
                    
                    Decimal BaseOverrideSalesUnits = blItem.Phoenix_Override_Current_Direct_Units__c != null ? blItem.Phoenix_Override_Current_Direct_Units__c : currentBaseUnits>0?currentBaseUnits:0; 
                    Decimal DSHOverrideSalesUnits = blItem.Phoenix_Override_Current_Indirect_Units__c != null ? blItem.Phoenix_Override_Current_Indirect_Units__c : currentDSHUnits>0?currentDSHUnits:0; 
                    Decimal AutoSubOverrideSalesUnits = blItem.Phoenix_Override_Current_Units__c != null ? blItem.Phoenix_Override_Current_Units__c : currentAutoSubUnits>0?currentAutoSubUnits:0; 
                    if(overrideBaseUnits+overrideDSHUnits+overrideAutoSubUnits >0){
                        blItem.Phoenix_Override_Total_units__c = overrideBaseUnits + overrideDSHUnits + overrideAutoSubUnits;
                    }
                    else{
                        blItem.Phoenix_Override_Total_units__c=0; 
                    }
                    
                    Decimal Overrideunit = blItem.Phoenix_Override_Total_units__c != null ? blItem.Phoenix_Override_Total_units__c : 0;
                    
                    
                    blItem.Phoenix_Current_Direct_Selling_Unit__c = currentBaseUnits+currentDSHUnits+currentAutoSubUnits;
                    
                    
                    blItem.Phoenix_12_Months_TotalSaleUnits__c = BaseActualSalesUnits + DSHActualSalesUnits + AutoSubActualSalesUnits; 
                    Decimal ProposedBaseSellingUnits = blItem.Phoenix_Proposed_Smith_Drug_Units__c != null ? blItem.Phoenix_Proposed_Smith_Drug_Units__c : BaseOverrideSalesUnits > 0 ? BaseOverrideSalesUnits : monthBaseSellingUnits > 0 ? monthBaseSellingUnits : 0;
                    Decimal ProposedDSHSellingUnits = blItem.Phoenix_Proposed_Anda_Units__c != null ? blItem.Phoenix_Proposed_Anda_Units__c : DSHOverrideSalesUnits > 0 ? DSHOverrideSalesUnits : monthDSHSellingUnits > 0 ? monthDSHSellingUnits : 0;    
                    Decimal ProposedAutoSubSellingUnits = blItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c != null ? blItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c : AutoSubOverrideSalesUnits > 0 ? AutoSubOverrideSalesUnits : monthAutoSubSellingUnits > 0 ? monthAutoSubSellingUnits : 0;
                    
                    //blItem.Phoenix_Proposed_Direct_Selling_Unit__c = (ProposedBaseSellingUnits + ProposedDSHSellingUnits + ProposedAutoSubSellingUnits) > 0 ? (ProposedBaseSellingUnits + ProposedDSHSellingUnits + ProposedAutoSubSellingUnits) : blItem.Phoenix_Override_Total_units__c > 0 ? blItem.Phoenix_Override_Total_units__c : blItem.Phoenix_Current_Direct_Selling_Unit__c > 0 ? blItem.Phoenix_Current_Direct_Selling_Unit__c : 0;
                    blItem.Phoenix_Proposed_Direct_Selling_Unit__c =proposedBaseUnits+proposedDSHUnits+proposedAutoSubUnits;
                     Decimal totalUnits = 0;
                    Decimal TotalProposedUnits = proposedBaseUnits+proposedDSHUnits+proposedAutoSubUnits;
                    Decimal totalCurrentUnits = overrideTotalUnits != 0 ? overrideTotalUnits : currentTotalUnits;
                    totalUnits = TotalProposedUnits != 0 ? TotalProposedUnits : totalCurrentUnits;
                   
                   if (blItem.Phoenix_SCM_Final_Approval__c != true) {
                        blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = blItem.Phoenix_Proposed_Direct_Selling_Unit__c;
                    }
                    
                     Decimal finalCalcedScmQuantity = 0;
                     Decimal scmApprovedBaseUnits = 0;
                    Decimal scmApprovedDSHUnits = 0;
                    Decimal scmAutoSubUnits = 0;
                    
                    if (blItem.Phoenix_SCM_Final_Approval__c != null && blItem.Phoenix_SCM_Final_Approval__c == true) {
                        if(blItem.Phoenix_SCM_Approval_Y_N__c=='Y- Current + Inc Demand Approved'){
                           finalCalcedScmQuantity = ((totalCurrentUnits/12)+((blItem.Phoenix_SCM_Approved_Quantity__c/100)*((TotalProposedUnits/12)-(totalCurrentUnits/12))))*12;

                            blItem.Phoenix_IDN_Usage__c=totalUnits != 0?(proposedBaseUnits/totalUnits)*finalCalcedScmQuantity:0;
                            blItem.Phoenix_Days_Notice_Product_Discontinuat__c=totalUnits != 0?(proposedDSHUnits/totalUnits)*finalCalcedScmQuantity:0;
                            blItem.Phoenix_Day_s_Notice_Product_removal__c= totalUnits != 0?(proposedAutoSubUnits/totalUnits)*finalCalcedScmQuantity:0;
                        }
                        else if(blItem.Phoenix_SCM_Approval_Y_N__c=='Y- Only Current Monthly Demand Approved'){
                            blItem.Phoenix_IDN_Usage__c=BaseOverrideSalesUnits;
                            blItem.Phoenix_Days_Notice_Product_Discontinuat__c=DSHOverrideSalesUnits;
                            blItem.Phoenix_Day_s_Notice_Product_removal__c=AutoSubOverrideSalesUnits;
                            
                        }
                    }
                    else{
                        blItem.Phoenix_IDN_Usage__c=0;
                        blItem.Phoenix_Days_Notice_Product_Discontinuat__c=0;
                        blItem.Phoenix_Day_s_Notice_Product_removal__c=0;
                    }
                    
                    
                        scmApprovedBaseUnits = blItem.Phoenix_IDN_Usage__c != null ? blItem.Phoenix_IDN_Usage__c : 0;
                     scmApprovedDSHUnits = blItem.Phoenix_Days_Notice_Product_Discontinuat__c != null ? blItem.Phoenix_Days_Notice_Product_Discontinuat__c : 0;
                     scmAutoSubUnits = blItem.Phoenix_Day_s_Notice_Product_removal__c != null ? blItem.Phoenix_Day_s_Notice_Product_removal__c : 0;
                    
                        Decimal BASEOverallUnits = 0;
                      Decimal DSHOverallUnits = 0;
                     Decimal AutoSubOverallUnits = 0;
                  
                    
                    //if(finalCalcedScmQuantity != 0){    
                    if (blItem.Phoenix_SCM_Final_Approval__c != null && blItem.Phoenix_SCM_Final_Approval__c == true) {
                        BASEOverallUnits = scmApprovedBaseUnits;
                        DSHOverallUnits = scmApprovedDSHUnits;
                        AutoSubOverallUnits = scmAutoSubUnits;
                       
                    }
                    else if(TotalProposedUnits > 0){
                        BASEOverallUnits = proposedBaseUnits;
                        DSHOverallUnits = proposedDSHUnits;
                        AutoSubOverallUnits = proposedAutoSubUnits;
                      
                    }
                    else if(overrideTotalUnits > 0){
                        BASEOverallUnits = overrideBaseUnits;
                        
                        DSHOverallUnits = overrideDSHUnits;
                        AutoSubOverallUnits = overrideAutoSubUnits;
                      
                    }
                    else{
                        BASEOverallUnits = currentBaseUnits;
                        DSHOverallUnits = currentDSHUnits;
                        AutoSubOverallUnits = currentAutoSubUnits;
                        
                    }
                     blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = BASEOverallUnits+DSHOverallUnits+AutoSubOverallUnits;
                    
                    
                    
                    
                    Decimal CurrentBaseContractPrice = blItem.Phoenix_Current_Retail_Direct_Price__c != null ? blItem.Phoenix_Current_Retail_Direct_Price__c : 0;
                    Decimal CurrentDSHContractPrice = blItem.Phoenix_Current_Retail_Indirect_Net__c != null ? blItem.Phoenix_Current_Retail_Indirect_Net__c : 0;
                    Decimal CurrentAutoSubContractPrice = blItem.Phoenix_Current_Retail_Indirect_Price__c != null ? blItem.Phoenix_Current_Retail_Indirect_Price__c : 0;
                    
                    
                    Decimal BaseSalesPrice = blItem.Phoenix_Retail_Direct_Sales_Price__c != null ? blItem.Phoenix_Retail_Direct_Sales_Price__c : 0; 
                    
                    //if( blItem.Phoenix_WMT_Indirect_Current_Sales__c!=null){
                    //blItem.Phoenix_WMT_Indirect_Current_Sales__c = BaseSalesPrice * 0.97;
                    // }
                    if (trigger.isUpdate) {
                        Phoenix_Bid_Line_Item__c oldblItem = oldMap.get(blItem.Id);
                        if(oldblItem.Phoenix_Retail_Direct_Sales_Price__c!=blItem.Phoenix_Retail_Direct_Sales_Price__c){
                            blItem.Phoenix_WMT_Indirect_Current_Sales__c = BaseSalesPrice * 0.97; 
                        }
                    }
                    else{
                        blItem.Phoenix_WMT_Indirect_Current_Sales__c = blItem.Phoenix_WMT_Indirect_Current_Sales__c; 
                    }
                    
                    
                    
                    
                    Decimal ProposedBaseContractPrice = blItem.Phoenix_Retail_Direct_Price__c != null ? blItem.Phoenix_Retail_Direct_Price__c : blItem.Phoenix_Retail_Direct_Sales_Price__c != null ? blItem.Phoenix_Retail_Direct_Sales_Price__c : CurrentBaseContractPrice > 0 ? CurrentBaseContractPrice : 0;   
                    Decimal ProposedDSHContractPrice = blItem.Phoenix_Retail_Indirect_Net__c >0 ? blItem.Phoenix_Retail_Indirect_Net__c : blItem.Phoenix_WMT_Indirect_Current_Sales__c !=null  ? blItem.Phoenix_WMT_Indirect_Current_Sales__c : CurrentDSHContractPrice > 0 ? CurrentDSHContractPrice : 0;   
                    system.debug('ProposedDSHContractPrice----'+ProposedDSHContractPrice);
                    if( trigger.isUpdate){ 
                        Phoenix_Bid_Line_Item__c oldblItem1 = oldMap.get(blItem.Id);
                        if(oldblItem1.Phoenix_Retail_Direct_Price__c!=blItem.Phoenix_Retail_Direct_Price__c ){
                            blItem.Phoenix_Retail_Indirect_Net__c = ProposedBaseContractPrice * 0.97;
                        }
                        else if(ProposedDSHContractPrice!=null && blItem.Phoenix_Retail_Direct_Price__c == null){
                            system.debug('enter in second if');
                            blItem.Phoenix_Retail_Indirect_Net__c = blItem.Phoenix_WMT_Indirect_Current_Sales__c !=null  ? blItem.Phoenix_WMT_Indirect_Current_Sales__c :0;
                        }
                    }
                    else{
                        
                        blItem.Phoenix_Retail_Indirect_Net__c = ProposedDSHContractPrice;
                        
                    }
                    
                    //Decimal ProposedDSHContractPrice = blItem.Phoenix_Retail_Indirect_Net__c != null ? blItem.Phoenix_Retail_Indirect_Net__c : CurrentDSHContractPrice > 0 ? CurrentDSHContractPrice : 0;  
                    ProposedDSHContractPrice = blItem.Phoenix_Retail_Indirect_Net__c >0 ? blItem.Phoenix_Retail_Indirect_Net__c : blItem.Phoenix_WMT_Indirect_Current_Sales__c !=null? blItem.Phoenix_WMT_Indirect_Current_Sales__c : CurrentDSHContractPrice > 0 ? CurrentDSHContractPrice : 0;
                    Decimal ProposedAutoSubContractPrice = blItem.Phoenix_Retail_Indirect_Price__c != null ? blItem.Phoenix_Retail_Indirect_Price__c : blItem.Phoenix_Wholesaler_Sales_Price__c != null ? blItem.Phoenix_Wholesaler_Sales_Price__c : CurrentAutoSubContractPrice > 0 ? CurrentAutoSubContractPrice : 0;
                    
                    if (CurrentBaseContractPrice > 0) {
                        blItem.Phoenix_Reduction__c = ((ProposedBaseContractPrice / CurrentBaseContractPrice) - 1) * 100;
                    }
                    
                    
                    
                    blItem.Phoenix_Net_Price_afterRebates_after_VIP__c = ProposedBaseContractPrice * (rebate / 100);  
                    blItem.Phoenix_Net_Price_after_Rebates_Terms__c = ProposedDSHContractPrice * (rebate / 100);   
                    blItem.Phoenix_Net_Price_after_RebatesbeforeVIP__c = ProposedAutoSubContractPrice * (rebate / 100);
                    
                    
                    
                    blItem.Phoenix_Anda_VIP__c = ProposedBaseContractPrice * (VIP / 100);  
                    blItem.Phoenix_Retail_Direct_VIP__c = ProposedDSHContractPrice * (VIP / 100);  
                    blItem.Phoenix_Retail_Indirect_VIP__c = ProposedAutoSubContractPrice * (VIP / 100);
                    
                    
                    
                    blItem.Phoenix_Anda_Admin_Fees__c = ProposedBaseContractPrice * (adminFee / 100); blItem.Phoenix_Retail_Direct_Admin_Fee__c = ProposedDSHContractPrice * (adminFee / 100);   blItem.Phoenix_Retail_Indirect_Admin_Fees__c = ProposedAutoSubContractPrice * (adminFee / 100);
                    
                    
                    
                    Decimal BaseRebate = blItem.Phoenix_Net_Price_afterRebates_after_VIP__c != null ? blItem.Phoenix_Net_Price_afterRebates_after_VIP__c : 0;  Decimal BaseVIP = blItem.Phoenix_Anda_VIP__c != null ? blItem.Phoenix_Anda_VIP__c : 0;
                    Decimal BaseBonafideFee = blItem.Phoenix_Anda_Admin_Fees__c != null ? blItem.Phoenix_Anda_Admin_Fees__c : 0;  Decimal DSHRebate = blItem.Phoenix_Net_Price_after_Rebates_Terms__c != null ? blItem.Phoenix_Net_Price_after_Rebates_Terms__c : 0;
                    Decimal DSHVIP = blItem.Phoenix_Retail_Direct_VIP__c != null ? blItem.Phoenix_Retail_Direct_VIP__c : 0; Decimal DSHBonafideFee = blItem.Phoenix_Retail_Direct_Admin_Fee__c != null ? blItem.Phoenix_Retail_Direct_Admin_Fee__c : 0;
                    Decimal AutoSubRebate = blItem.Phoenix_Net_Price_after_RebatesbeforeVIP__c != null ? blItem.Phoenix_Net_Price_after_RebatesbeforeVIP__c : 0; Decimal AutoSubVIP = blItem.Phoenix_Retail_Indirect_VIP__c != null ? blItem.Phoenix_Retail_Indirect_VIP__c : 0;
                    Decimal AutoSubBonafideFee = blItem.Phoenix_Retail_Indirect_Admin_Fees__c != null ? blItem.Phoenix_Retail_Indirect_Admin_Fees__c : 0; 
                    
                    
                    blItem.Phoenix_Retail_Indirect_DRL_TPT__c = ProposedBaseContractPrice >0?(ProposedBaseContractPrice - BaseRebate - BaseVIP - BaseBonafideFee):0;    
                    blItem.Phoenix_Retail_Direct_DRL_TPT__c = ProposedDSHContractPrice >0?(ProposedDSHContractPrice - DSHRebate - DSHVIP - DSHBonafideFee):0;   
                    blItem.Phoenix_Anda_DRL_TPT__c = ProposedAutoSubContractPrice>0?(ProposedAutoSubContractPrice - AutoSubRebate - AutoSubVIP - AutoSubBonafideFee):0;
                    
                    
                    
                    Decimal BaseCustomerNetPrice = blItem.Phoenix_Retail_Indirect_DRL_TPT__c != null ? blItem.Phoenix_Retail_Indirect_DRL_TPT__c : 0;  
                    Decimal DSHCustomerNetPrice = blItem.Phoenix_Retail_Direct_DRL_TPT__c != null ? blItem.Phoenix_Retail_Direct_DRL_TPT__c : 0;  
                    Decimal AutoSubCustomerNetPrice = blItem.Phoenix_Anda_DRL_TPT__c != null ? blItem.Phoenix_Anda_DRL_TPT__c : 0;
                    
                    
                    
                    
                    blItem.Phoenix_Cash_Terms_RxSS__c = WAC * (cashTerm / 100); 
                    blItem.Phoenix_Direct_CD__c = WAC * (cashTerm / 100); 
                    blItem.Phoenix_WMT_CD_WMT_Direct__c = WAC * (cashTerm / 100);
                    
                    Decimal BaseCD = blItem.Phoenix_Cash_Terms_RxSS__c != null ? blItem.Phoenix_Cash_Terms_RxSS__c : 0; Decimal DSHCD = blItem.Phoenix_Direct_CD__c != null ? blItem.Phoenix_Direct_CD__c : 0; Decimal AutoSubCD = blItem.Phoenix_WMT_CD_WMT_Direct__c != null ? blItem.Phoenix_WMT_CD_WMT_Direct__c : 0;
                    
                    blItem.Phoenix_Retail_Indirect_WholesalerFeeRxS__c = ProposedBaseContractPrice * (CMFee / 100); blItem.Phoenix_Current_Wholesaler_Price__c = ProposedDSHContractPrice * (CMFee / 100);  blItem.Phoenix_Current_Anda_CP_Price__c = ProposedAutoSubContractPrice * (CMFee / 100);
                    
                    
                    Decimal BaseCMfee = blItem.Phoenix_Retail_Indirect_WholesalerFeeRxS__c != null ? blItem.Phoenix_Retail_Indirect_WholesalerFeeRxS__c : 0;  
                    Decimal DSHCMfee = blItem.Phoenix_Current_Wholesaler_Price__c != null ? blItem.Phoenix_Current_Wholesaler_Price__c : 0;   
                    Decimal AutoSubCMfee = blItem.Phoenix_Current_Anda_CP_Price__c != null ? blItem.Phoenix_Current_Anda_CP_Price__c : 0;
                    
                    
                    
                    //blItem.Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c = BaseCustomerNetPrice * (2/100);  
                    //blItem.Phoenix_Indirect_Dead_Net_w_o_Med_Retrns__c = DSHCustomerNetPrice * (2/100);   
                    //blItem.Phoenix_Current_Anda_Invoice_Price__c = AutoSubCustomerNetPrice * (2/100);
                    
                    
                    
                    // Decimal BaseMediReturns = blItem.Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c != null ? blItem.Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c : 0;   
                    //Decimal DSHMediReturns = blItem.Phoenix_Indirect_Dead_Net_w_o_Med_Retrns__c != null ? blItem.Phoenix_Indirect_Dead_Net_w_o_Med_Retrns__c : 0;  
                    //Decimal AutoSubMediReturns = blItem.Phoenix_Current_Anda_Invoice_Price__c != null ? blItem.Phoenix_Current_Anda_Invoice_Price__c : 0;
                    
                    
                    
                    blItem.Phoenix_Wholesaler_DRL_Net_Price__c = BaseCustomerNetPrice>(BaseCD+BaseCMfee+MediReturnUnit)?(BaseCustomerNetPrice - BaseCD - BaseCMfee - whlsrControlSubFee):0; //- MediReturnUnit
                    
                    
                    blItem.Phoenix_Anda_DRL_Net_price__c = DSHCustomerNetPrice>(DSHCD+DSHCMfee+MediReturnUnit)?(DSHCustomerNetPrice - DSHCD - DSHCMfee - whlsrControlSubFee):0;    //- MediReturnUnit
                    
                    
                    blItem.Phoenix_Wholesaler_DRL_TPT__c = AutoSubCustomerNetPrice>(AutoSubCD+AutoSubCMfee+MediReturnUnit)?(AutoSubCustomerNetPrice - AutoSubCD - AutoSubCMfee-whlsrControlSubFee):0;//-MediReturnUnit
                    
                    
                    
                    
                    Decimal BaseDRLNetPrice = blItem.Phoenix_Wholesaler_DRL_Net_Price__c != null ? blItem.Phoenix_Wholesaler_DRL_Net_Price__c : 0;   
                    Decimal DSHDRLNetPrice = blItem.Phoenix_Anda_DRL_Net_price__c != null ? blItem.Phoenix_Anda_DRL_Net_price__c : 0;  
                    Decimal AutoSubDRLNetPrice = blItem.Phoenix_Wholesaler_DRL_TPT__c != null ? blItem.Phoenix_Wholesaler_DRL_TPT__c : 0;
                    
                   
                    //blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c = blItem.Phoenix_SCM_Final_Approval__c == true?blItem.Phoenix_IDN_Usage__c:ProposedBaseSellingUnits; 
                    //blItem.Phoenix_Current_Retail_Indirect_Units__c =blItem.Phoenix_SCM_Final_Approval__c == true?blItem.Phoenix_Days_Notice_Product_Discontinuat__c:ProposedDSHSellingUnits;
                    //blItem.Phoenix_Current_Anda_Net_Model_Units__c = blItem.Phoenix_SCM_Final_Approval__c == true?blItem.Phoenix_Day_s_Notice_Product_removal__c:ProposedAutoSubSellingUnits;
                    
                    blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c = BASEOverallUnits; 
                    blItem.Phoenix_Current_Retail_Indirect_Units__c =DSHOverallUnits;
                    blItem.Phoenix_Current_Anda_Net_Model_Units__c =AutoSubOverallUnits;
                    
                    Decimal BaseAnnualUsage = blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c != null ? blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c : 0; 
                    Decimal DSHAnnualUsage = blItem.Phoenix_Current_Retail_Indirect_Units__c != null ? blItem.Phoenix_Current_Retail_Indirect_Units__c : 0; 
                    Decimal AutoSubAnnualUsage =blItem.Phoenix_Current_Anda_Net_Model_Units__c != null ? blItem.Phoenix_Current_Anda_Net_Model_Units__c : 0;
                    
                    blItem.Phoenix_Others_Indirect__c = BaseAnnualUsage / 12;   
                    blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c = DSHAnnualUsage / 12;    
                    blItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c = AutoSubAnnualUsage / 12;
                    
                    
                    
                    //Decimal DSHIODEligibility = blItem.Phoenix_Retail_IOD_per_unit__c != null ? blItem.Phoenix_Retail_IOD_per_unit__c : 0;
                    //Decimal AutoSubIODEligibility = blItem.Phoenix_ANDA_IOD_Per_unit__c != null ? blItem.Phoenix_ANDA_IOD_Per_unit__c : 0;
                    
                    
                    blItem.Phoenix_Retail_IOD_overall_amount__c = BaseDRLNetPrice>0?(BaseAnnualUsage * BaseDRLNetPrice)-(MediReturnUnit * BaseAnnualUsage):0; 
                    blItem.Phoenix_Retail_Direct_Net_sales__c = DSHDRLNetPrice>0?(DSHAnnualUsage * DSHDRLNetPrice)-(MediReturnUnit * DSHAnnualUsage):0;   
                    blItem.Phoenix_Wholesaler_Net_Sales__c = AutoSubDRLNetPrice>0?(AutoSubAnnualUsage * AutoSubDRLNetPrice)-(MediReturnUnit * AutoSubAnnualUsage):0;
                    
                    
                    
                    Decimal BaseAnnualNetSales = blItem.Phoenix_Retail_IOD_overall_amount__c != null ? blItem.Phoenix_Retail_IOD_overall_amount__c.setscale(0) : 0; 
                    Decimal DSHAnnualNetSales = blItem.Phoenix_Retail_Direct_Net_sales__c != null ? blItem.Phoenix_Retail_Direct_Net_sales__c.setscale(0) : 0;  
                    Decimal AutoSubAnnualNetSales = blItem.Phoenix_Wholesaler_Net_Sales__c != null ? blItem.Phoenix_Wholesaler_Net_Sales__c.setscale(0) : 0;
                    
                    
                    Decimal throughput = blItem.Phoenix_Throughput_Cost1__c != null ? blItem.Phoenix_Throughput_Cost1__c : 0; 
                    blItem.Phoenix_ANDA_IOD_Overall_Amount__c = BaseAnnualUsage * throughput;                     
                    blItem.Phoenix_Retail_Indirect_Net_Sales__c = DSHAnnualUsage * throughput; 
                    blItem.Phoenix_Retail_Indirect_WAC_NLC_Fee__c = AutoSubAnnualUsage * throughput;
                    //blItem.Phoenix_Retail_Indirect_Net_Sales__c = DSHAnnualUsage * throughput;
                    //blItem.Phoenix_Retail_Indirect_WAC_NLC_Fee__c = AutoSubAnnualUsage * throughput;
                    
                    Decimal BaseCOGS = blItem.Phoenix_ANDA_IOD_Overall_Amount__c != null ? blItem.Phoenix_ANDA_IOD_Overall_Amount__c : 0;   
                    Decimal DSHCOGS = blItem.Phoenix_Retail_Indirect_Net_Sales__c != null ? blItem.Phoenix_Retail_Indirect_Net_Sales__c : 0;  
                    Decimal AutoSubCOGS = blItem.Phoenix_Retail_Indirect_WAC_NLC_Fee__c != null ? blItem.Phoenix_Retail_Indirect_WAC_NLC_Fee__c : 0;
                    
                    
                    
                    blItem.Phoenix_Wholesaler_IOD_overall_amount__c = BaseAnnualNetSales>0?(BaseAnnualNetSales - BaseCOGS):0;   
                    blItem.Phoenix_Anda_Net_Model_Sales__c = DSHAnnualNetSales>0?(DSHAnnualNetSales - DSHCOGS):0;   
                    blItem.Phoenix_Wholesaler_Guidance_Price__c =AutoSubAnnualNetSales>0?(AutoSubAnnualNetSales - AutoSubCOGS):0;   
                    blItem.Phoenix_Net_Sales_Internal__c = BaseAnnualNetSales + DSHAnnualNetSales + AutoSubAnnualNetSales;
                    
                    
                    
                    
                    Decimal netSalesInternal = blItem.Phoenix_Net_Sales_Internal__c != null ? blItem.Phoenix_Net_Sales_Internal__c.setscale(0) : 0; 
                    Decimal finalDirectUnits = blItem.Phoenix_Final_Direct_Selling_Units_Calc__c	 != null ? blItem.Phoenix_Final_Direct_Selling_Units_Calc__c	 :  blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null ? blItem.Phoenix_Proposed_Direct_Selling_Unit__c : 0;
                    Decimal finalInDirectUnits = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c	 != null ? blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c	 :  blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null ? blItem.Phoenix_Proposed_Indirect_Selling_Unit__c : 0 ;
                    Decimal proposedTotalUnits = blItem.Phoenix_Final_Total_Selling_Unit__c != null ? blItem.Phoenix_Final_Total_Selling_Unit__c : 0;
                    if (finalDirectUnits > 0) {blItem.Phoenix_Internal_Dead_Net_Price__c = netSalesInternal / finalDirectUnits;
                                              }
                    
                    /*--- added by Jogarao  for Finance view calculations ----*/
                    //Decimal finalBaseUnits = (blItem.Phoenix_IDN_Usage__c != null && blItem.Phoenix_IDN_Usage__c > 0) ? blItem.Phoenix_IDN_Usage__c : ProposedBaseSellingUnits > 0 ? ProposedBaseSellingUnits :currentBaseUnits;
                    Decimal finalBaseUnits =BASEOverallUnits;
                    //Decimal finalDSjeUnits = (blItem.Phoenix_Days_Notice_Product_Discontinuat__c != null && blItem.Phoenix_Days_Notice_Product_Discontinuat__c >0)  ? blItem.Phoenix_Days_Notice_Product_Discontinuat__c : ProposedDSHSellingUnits > 0 ? ProposedDSHSellingUnits :currentDSHUnits;
                      Decimal finalDSjeUnits =DSHOverallUnits;
                    //Decimal finalAutoSubUnits = (blItem.Phoenix_Day_s_Notice_Product_removal__c != null && blItem.Phoenix_Day_s_Notice_Product_removal__c > 0) ? blItem.Phoenix_Day_s_Notice_Product_removal__c :ProposedAutoSubSellingUnits > 0 ? ProposedAutoSubSellingUnits :currentAutoSubUnits;
                    Decimal finalAutoSubUnits =AutoSubOverallUnits;
                    Decimal finalDeadNet =  (finalBaseUnits>finalDSjeUnits && finalBaseUnits>finalAutoSubUnits) ? BaseDRLNetPrice : (finalBaseUnits<finalDSjeUnits && finalDSjeUnits>finalAutoSubUnits) ? DSHDRLNetPrice: AutoSubDRLNetPrice;
                    if((finalBaseUnits > 0 && finalDSjeUnits >0) && (finalBaseUnits == finalDSjeUnits)){
                        finalDeadNet = BaseDRLNetPrice > DSHDRLNetPrice ? BaseDRLNetPrice : DSHDRLNetPrice;
                    }else if ((finalBaseUnits > 0 && finalAutoSubUnits > 0) && (finalBaseUnits == finalAutoSubUnits)){
                        finalDeadNet = BaseDRLNetPrice > AutoSubDRLNetPrice ? BaseDRLNetPrice : AutoSubDRLNetPrice;
                    }else if((finalDSjeUnits > 0 && finalAutoSubUnits > 0) && (finalDSjeUnits == finalAutoSubUnits)){
                        finalDeadNet = DSHDRLNetPrice > AutoSubDRLNetPrice ? DSHDRLNetPrice : AutoSubDRLNetPrice;
                    }
					/*else if((finalDSjeUnits == finalAutoSubUnits) || (finalDSjeUnits== finalBaseUnits) || (finalAutoSubUnits== finalBaseUnits) ){
                        finalDeadNet = (DSHDRLNetPrice < AutoSubDRLNetPrice && BaseDRLNetPrice < AutoSubDRLNetPrice) ? AutoSubDRLNetPrice : (DSHDRLNetPrice > AutoSubDRLNetPrice && DSHDRLNetPrice > BaseDRLNetPrice) ? DSHDRLNetPrice : BaseDRLNetPrice;
                    }*/
                    
                    blItem.Phoenix_Internal_Dead_Net_Price__c = finalDeadNet;
                    blItem.Phoenix_Proposed_Sales__c = blItem.Phoenix_Internal_Dead_Net_Price__c * (finalDirectUnits + finalInDirectUnits);
                    
                    Decimal brandwac =( blItem.Brand_WAC__c != null && blItem.Brand_WAC__c !=0)?blItem.Brand_WAC__c:0;
                    Decimal drlNetPrice=blItem.Phoenix_Wholesaler_DRL_Net_Price__c!=null?blItem.Phoenix_Wholesaler_DRL_Net_Price__c:0;
                    blItem.Phoenix_Brand_WAC_Per__c = (brandwac != 0 && brandwac != null)? (drlNetPrice / brandwac)*100 : 0;
                    Decimal proposedASP=  blItem.Phoenix_Internal_Dead_Net_Price__c!=null? blItem.Phoenix_Internal_Dead_Net_Price__c:0;
                    Decimal openingorder = (blItem.Phoenix_Opening_Order__c != null && blItem.Phoenix_Opening_Order__c != 0)?blItem.Phoenix_Opening_Order__c :0;
                    blItem.Phoenix_Opening_Order_Net_sales__c =(drlNetPrice>0 && openingorder>0) ?( (openingorder * drlNetPrice) - (openingorder * MediReturnUnit)):0;
                    Decimal openingOrdernetsales = (blItem.Phoenix_Opening_Order_Net_sales__c != null && blItem.Phoenix_Opening_Order_Net_sales__c != 0) ? blItem.Phoenix_Opening_Order_Net_sales__c : 0;
                    Decimal throughputCost = blItem.Phoenix_Throughput_Cost1__c != null ? blItem.Phoenix_Throughput_Cost1__c : 0;
                    blItem.Phoenix_Opening_Order_TPT__c =openingOrdernetsales > (openingorder * throughputCost)? (openingOrdernetsales - (openingorder * throughputCost)):0;
                    Decimal openingordertptdl = (blItem.Phoenix_Opening_Order_TPT__c != null &&  blItem.Phoenix_Opening_Order_TPT__c != 0) ?blItem.Phoenix_Opening_Order_TPT__c :0 ;
                    blItem.Phoenix_Opening_Order_TPT_Per__c = (openingordertptdl >0 && openingOrdernetsales !=0 )? (openingordertptdl / openingOrdernetsales)*100 :0 ;
                    
                    //added by satya.
                    // for base.
                    Decimal tpBeforePS = (blItem.Phoenix_Wholesaler_IOD_overall_amount__c != null &&  blItem.Phoenix_Wholesaler_IOD_overall_amount__c != 0) ?blItem.Phoenix_Wholesaler_IOD_overall_amount__c :0 ;
                    blItem.Phoenix_Costco_TPTPer__c = (BaseAnnualNetSales >0 && tpBeforePS !=0 )? (tpBeforePS / BaseAnnualNetSales)*100 :0 ;
                    Decimal commExpPercent = (blItem.Phoenix_Comm_Exps1__c != null &&  blItem.Phoenix_Comm_Exps1__c != 0) ?blItem.Phoenix_Comm_Exps1__c :0 ;
                    Decimal psShare = (blItem.Phoenix_PS_Partner_1percent__c != null &&  blItem.Phoenix_PS_Partner_1percent__c != 0) ?blItem.Phoenix_PS_Partner_1percent__c :0 ;
                    blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c = (BaseAnnualNetSales >0 && commExpPercent !=0 )? (BaseAnnualNetSales*(commExpPercent/100)):0 ;
                    Decimal baseCommCredit = (blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c != null &&  blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c != 0) ?blItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c :0 ;
                    blItem.Phoenix_Admin_Fee_WMT_Direct_NCP__c = (tpBeforePS -baseCommCredit) ;
                    Decimal tpAfterComm = (blItem.Phoenix_Admin_Fee_WMT_Direct_NCP__c != null &&  blItem.Phoenix_Admin_Fee_WMT_Direct_NCP__c != 0) ?blItem.Phoenix_Admin_Fee_WMT_Direct_NCP__c :0 ;
                    blItem.Admin_Fees_WMT_Indirect__c = (tpAfterComm >0 && psShare !=0 )? (tpAfterComm * psShare/100):0 ;
                    Decimal baseProfSharToPartner = (blItem.Admin_Fees_WMT_Indirect__c != null &&  blItem.Admin_Fees_WMT_Indirect__c != 0) ?blItem.Admin_Fees_WMT_Indirect__c :0 ;
                    blItem.Phoenix_Current_WMT_Direct_Dead_net__c = (tpBeforePS -baseProfSharToPartner) ;
                    Decimal baseDRLNetProf = (blItem.Phoenix_Current_WMT_Direct_Dead_net__c != null &&  blItem.Phoenix_Current_WMT_Direct_Dead_net__c != 0) ?blItem.Phoenix_Current_WMT_Direct_Dead_net__c :0 ;
                    blItem.Phoenix_Date_Fee__c = (baseDRLNetProf >0 && BaseAnnualNetSales !=0 )? (baseDRLNetProf / BaseAnnualNetSales)*100 :0 ;
                    //base end.
                    
                     // for DSH.
                    Decimal tpBeforePSdsh = (blItem.Phoenix_Anda_Net_Model_Sales__c != null &&  blItem.Phoenix_Anda_Net_Model_Sales__c != 0) ?blItem.Phoenix_Anda_Net_Model_Sales__c :0 ;
                    blItem.Phoenix_Opening_Order_WMTTPT__c = (DSHAnnualNetSales >0 && tpBeforePSdsh !=0 )? (tpBeforePSdsh / DSHAnnualNetSales)*100 :0 ;
                    blItem.Phoenix_Charge_Back__c = (DSHAnnualNetSales >0 && commExpPercent !=0 )? (DSHAnnualNetSales*(commExpPercent/100)):0 ;
                    Decimal DSHCommCredit = (blItem.Phoenix_Charge_Back__c != null &&  blItem.Phoenix_Charge_Back__c != 0) ?blItem.Phoenix_Charge_Back__c :0 ;
                    blItem.Phoenix_IPA_Floor_Price1__c = (tpBeforePSdsh -DSHCommCredit) ;
                    Decimal tpAfterCommDSH = (blItem.Phoenix_IPA_Floor_Price1__c != null &&  blItem.Phoenix_IPA_Floor_Price1__c != 0) ?blItem.Phoenix_IPA_Floor_Price1__c :0 ;
                    blItem.Phoenix_Current_McK_RAD_Dead_net__c = (tpAfterCommDSH >0 && psShare !=0 )? ((tpAfterCommDSH * psShare/100)-whlsrControlSubFee):0;
                    Decimal dshProfSharToPartner = (blItem.Phoenix_Current_McK_RAD_Dead_net__c != null &&  blItem.Phoenix_Current_McK_RAD_Dead_net__c != 0) ?blItem.Phoenix_Current_McK_RAD_Dead_net__c :0 ;
                    blItem.Phoenix_Current_Net_Sales_Internal__c = (tpBeforePSdsh -dshProfSharToPartner) ;
                    Decimal DSHDRLNetProf = (blItem.Phoenix_Current_Net_Sales_Internal__c != null &&  blItem.Phoenix_Current_Net_Sales_Internal__c != 0) ?blItem.Phoenix_Current_Net_Sales_Internal__c :0 ;
                    blItem.Phoenix_Invoice_Allowance__c = (DSHDRLNetProf >0 && DSHAnnualNetSales !=0 )? (DSHDRLNetProf / DSHAnnualNetSales)*100 :0 ;
                    //DSH end.
                    
                      // for autoSUb.
                    Decimal tpBeforePSautoSub = (blItem.Phoenix_Wholesaler_Guidance_Price__c != null &&  blItem.Phoenix_Wholesaler_Guidance_Price__c != 0) ?blItem.Phoenix_Wholesaler_Guidance_Price__c :0 ;
                    blItem.Phoenix_Proposed_Admin_Fee__c = (AutoSubAnnualNetSales >0 && tpBeforePSautoSub !=0 )? (tpBeforePSautoSub / AutoSubAnnualNetSales)*100 :0 ;
                    blItem.Phoenix_Customer_Dead_Net_McK_RAD_Propse__c = (AutoSubAnnualNetSales >0 && commExpPercent !=0 )? (AutoSubAnnualNetSales*(commExpPercent/100)):0 ;
                    Decimal autoSubCommCredit = (blItem.Phoenix_Customer_Dead_Net_McK_RAD_Propse__c != null &&  blItem.Phoenix_Customer_Dead_Net_McK_RAD_Propse__c != 0) ?blItem.Phoenix_Customer_Dead_Net_McK_RAD_Propse__c :0 ;
                    blItem.Phoenix_Direct_Dead_Net__c = (tpBeforePSautoSub -autoSubCommCredit) ;
                    Decimal tpAfterCommautoSub = (blItem.Phoenix_Direct_Dead_Net__c != null &&  blItem.Phoenix_Direct_Dead_Net__c != 0) ?blItem.Phoenix_Direct_Dead_Net__c :0 ;
                    blItem.Phoenix_Direct_Order_Price1__c = (tpAfterCommautoSub >0 && psShare !=0 )? (tpAfterCommautoSub * psShare/100):0 ;
                    Decimal autoSubProfSharToPartner = (blItem.Phoenix_Direct_Order_Price1__c != null &&  blItem.Phoenix_Direct_Order_Price1__c != 0) ?blItem.Phoenix_Direct_Order_Price1__c :0 ;
                    blItem.Phoenix_Indirect_Dead_Net_w_o_Med_Retrns__c = (tpBeforePSautoSub -autoSubProfSharToPartner) ;
                    Decimal autoSUBDRLNetProf = (blItem.Phoenix_Indirect_Dead_Net_w_o_Med_Retrns__c != null &&  blItem.Phoenix_Indirect_Dead_Net_w_o_Med_Retrns__c != 0) ?blItem.Phoenix_Indirect_Dead_Net_w_o_Med_Retrns__c :0 ;
                    blItem.Proposed_TPT_Per_Indirect__c = (autoSUBDRLNetProf >0 && AutoSubAnnualNetSales !=0 )? (autoSUBDRLNetProf / AutoSubAnnualNetSales)*100 :0 ;
                    //autoSUb end.
                    
                    
                    //end by satya.
                     //Added for Price and Volume Variane calcularions
                    Decimal propsdBaseUnits = blItem.Phoenix_SCM_Final_Approval__c == true ? (blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c!=null ? blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c:0) : blItem.Phoenix_Proposed_Smith_Drug_Units__c != null ?blItem.Phoenix_Proposed_Smith_Drug_Units__c :0;
                    Decimal propsDSHUnits = blItem.Phoenix_SCM_Final_Approval__c == true ? (blItem.Phoenix_Current_Retail_Indirect_Units__c!=null?blItem.Phoenix_Current_Retail_Indirect_Units__c:0) : blItem.Phoenix_Proposed_Anda_Units__c != null ? blItem.Phoenix_Proposed_Anda_Units__c : 0;
                    Decimal propAutoSubUnits = blItem.Phoenix_SCM_Final_Approval__c == true ? (blItem.Phoenix_Current_Anda_Net_Model_Units__c!=null?blItem.Phoenix_Current_Anda_Net_Model_Units__c:0) : blItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c != null ? blItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c :0;
                    Decimal currtBaseUnits = (BaseOverrideSalesUnits != 0 || overrideTotalUnits > 0) ? BaseOverrideSalesUnits : blItem.Phoenix_Current_Wholesaler_Units__c != null ? blItem.Phoenix_Current_Wholesaler_Units__c :0;
                    Decimal currtDSHUnits = (DSHOverrideSalesUnits != 0 || overrideTotalUnits>0) ? DSHOverrideSalesUnits : blItem.Phoenix_Current_Anda_Units__c != null ? blItem.Phoenix_Current_Anda_Units__c : 0;
                    Decimal currtAutoSubUnits = (AutoSubOverrideSalesUnits !=0 || overrideTotalUnits>0) ? AutoSubOverrideSalesUnits : blItem.Phoenix_Current_Retail_Direct_Units__c != null ? blItem.Phoenix_Current_Retail_Direct_Units__c : 0;
                    
                    Decimal propsdBaseDeadnet = blItem.Phoenix_Wholesaler_DRL_Net_Price__c != null ? blItem.Phoenix_Wholesaler_DRL_Net_Price__c : 0;
                    Decimal propsdDSHDeadnet = blItem.Phoenix_Anda_DRL_Net_price__c != null ? blItem.Phoenix_Anda_DRL_Net_price__c : 0;
                    Decimal propsdAutoSubDeadnet = blItem.Phoenix_Wholesaler_DRL_TPT__c != null ? blItem.Phoenix_Wholesaler_DRL_TPT__c : 0;
                    Decimal currentDeadnet = blItem.Phoenix_DeadNet_TrckGR__c != null ? blItem.Phoenix_DeadNet_TrckGR__c :0;
                    
                    Decimal priceDiffBase = propsdBaseDeadnet - currentDeadnet;
                    Decimal priceDiffDSH = propsdDSHDeadnet - currentDeadnet;
                    Decimal priceDiffautoSub = propsdAutoSubDeadnet - currentDeadnet;
                    
                    Decimal priceVarianceBase = priceDiffBase * currtBaseUnits;
                    Decimal priceVarianceDSH = priceDiffDSH * currtDSHUnits;
                    Decimal priceVarianceautoSub = priceDiffautoSub * currtAutoSubUnits;
                   
                    Decimal volumeDiffBase = propsdBaseUnits - currtBaseUnits;
                    Decimal volumeDiffDSH = propsDSHUnits - currtDSHUnits;
                    Decimal volumeDiffAutoSub = propAutoSubUnits - currtAutoSubUnits;
                    
                    Decimal volumeVarianceBase = volumeDiffBase * priceDiffBase;
                    Decimal volumeVarianceDSH = volumeDiffDSH * priceDiffDSH;
                    Decimal volumeVarianceAutoSub = volumeDiffAutoSub * priceDiffautoSub;
                    
                    Decimal baseAnlNetSales = blItem.Phoenix_Retail_IOD_overall_amount__c != null ? blItem.Phoenix_Retail_IOD_overall_amount__c : 0;
                    Decimal dshAnlNetSales = blItem.Phoenix_Retail_Direct_Net_sales__c != null ? blItem.Phoenix_Retail_Direct_Net_sales__c : 0;
                    Decimal autosubAnlNetSales = blItem.Phoenix_Wholesaler_Net_Sales__c != null ? blItem.Phoenix_Wholesaler_Net_Sales__c :0;
                    
                    //Added code for new current sales calc update
                  //  Decimal baseUnits = ((blItem.Current_CVS_DeadNet__c != null ? blItem.Current_CVS_DeadNet__c: 0)* (overrideBaseUnits > 0 ? overrideBaseUnits :currentBaseUnits) - (overrideBaseUnits> 0 ? overrideBaseUnits:currentBaseUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c);
                  //  Decimal dshUnits = ((blItem.Current_Cardinal_DeadNet__c != null ? blItem.Current_Cardinal_DeadNet__c: 0)* (overrideDSHUnits > 0 ? overrideDSHUnits :currentDSHUnits ) - (overrideDSHUnits> 0 ? overrideDSHUnits:currentDSHUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c);
                  //  Decimal autoSubUnits = ((blItem.Current_Major_DeadNet__c != null ? blItem.Current_Major_DeadNet__c: 0)* (overrideAutoSubUnits> 0 ? overrideAutoSubUnits:currentAutoSubUnits ) - (overrideAutoSubUnits> 0 ? overrideAutoSubUnits:currentAutoSubUnits ) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c);
                  
                    Decimal baseUnits = (blItem.Current_CVS_DeadNet__c != null ? (blItem.Current_CVS_DeadNet__c * (overrideBaseUnits > 0 ? overrideBaseUnits :currentBaseUnits) - (overrideBaseUnits> 0 ? overrideBaseUnits:currentBaseUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c): 0);
                    Decimal dshUnits = (blItem.Current_Cardinal_DeadNet__c != null ? (blItem.Current_Cardinal_DeadNet__c * (overrideDSHUnits > 0 ? overrideDSHUnits :currentDSHUnits ) - (overrideDSHUnits> 0 ? overrideDSHUnits:currentDSHUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c): 0);
                    Decimal autoSubUnits = (blItem.Current_Major_DeadNet__c != null ? (blItem.Current_Major_DeadNet__c * (overrideAutoSubUnits> 0 ? overrideAutoSubUnits:currentAutoSubUnits ) - (overrideAutoSubUnits> 0 ? overrideAutoSubUnits:currentAutoSubUnits ) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c): 0);
                    blItem.Finance_Current_Sales__c = baseUnits+dshUnits+autoSubUnits;
                    //Ends
                   	
                    blItem.Phoenix_Price_Variance__c = (bidType == 'Sales Out Rebate' || bidType == 'RFP Bids' || bidType == 'Price Change' || bidType == 'Customer Rebate Change') ? (priceVarianceBase + priceVarianceDSH+priceVarianceautoSub):0;
                    blItem.Phoenix_Volume_Variance__c = (bidType == 'Sales Out Rebate' || bidType == 'Price Change' || bidType == 'Customer Rebate Change') ? 0 : (volumeVarianceBase + volumeVarianceDSH+volumeVarianceAutoSub) ;  
					blItem.phoenix_Proposed_Sales__c = baseAnlNetSales + dshAnlNetSales + autosubAnlNetSales; 
                   
                    
                }
                
                
                Catch(Exception e) {
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_BidLineItemTrigger', Phoenix_Method_Name__c = '', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                    insert exp;
                }
            }
            
        }
    }
    
    
}