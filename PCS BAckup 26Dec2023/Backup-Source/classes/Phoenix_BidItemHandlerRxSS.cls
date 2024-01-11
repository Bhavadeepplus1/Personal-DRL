public class Phoenix_BidItemHandlerRxSS extends TriggerHandler {
    private list < Phoenix_Bid_Line_Item__c > triggerNew;
    private list < Phoenix_Bid_Line_Item__c > triggerOld;
    private Map < Id, Phoenix_Bid_Line_Item__c > newMap;
    private Map < Id, Phoenix_Bid_Line_Item__c > oldMap;
    
    public Phoenix_BidItemHandlerRxSS() {
        this.newMap = (Map < Id, Phoenix_Bid_Line_Item__c > ) Trigger.newMap;
        this.oldMap = (Map < Id, Phoenix_Bid_Line_Item__c > ) Trigger.oldMap;
        this.triggerNew = (List < Phoenix_Bid_Line_Item__c > ) Trigger.new;
        this.triggerOld = (List < Phoenix_Bid_Line_Item__c > ) Trigger.old;
    }
    
    
    public override void beforeInsert() {
        //Phoenix_Bid__c bidRec = [SELECT Id,Phoenix_Customer_Type__c, Phoenix_Customer__r.Phoenix_Rebates__c,Phoenix_Customer__r.Phoenix_Cash_Discount__c ,Phoenix_Customer__r.Phoenix_Fee__c,Phoenix_Customer__r.Phoenix_CM_Fees__c,Phoenix_Bid_Proposed_Position__c, Phoenix_Approval_Status__c,Phoenix_Proposed_Cash_Terms__c,Phoenix_Initial_Order_Discount_Type__c, Phoenix_Custom_type__c, Phoenix_Current_CD__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =:triggerNew[0].Phoenix_Bid__c];
        beforeUpdate();
        
    }
    
    public override void beforeUpdate() {
        Phoenix_Bid__c bidRec = [SELECT Id,Phoenix_Customer_Type__c,Phoenix_Proposed_SSA_No_of_Days__c, Phoenix_Customer__r.Phoenix_Rebates__c,Phoenix_Customer__r.Phoenix_Cash_Discount__c ,Phoenix_Customer__r.Phoenix_Fee__c,Phoenix_Customer__r.Phoenix_CM_Fees__c,Phoenix_Bid_Proposed_Position__c, Phoenix_Approval_Status__c,Phoenix_Proposed_Cash_Terms__c,Phoenix_Initial_Order_Discount_Type__c, Phoenix_Custom_type__c, Phoenix_Current_CD__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =:triggerNew[0].Phoenix_Bid__c];
        
        String bidType = bidRec.Phoenix_Bid_Type__c;
        for (Phoenix_Bid_Line_Item__c blItem: triggerNew) {
            if (blItem.Phoenix_Bid_Template_Refrence__c == 'RXSS') {
                try {
                    Decimal andaIndirectUnits;
                    Decimal smithIndirectUnits;
                    Decimal directAholdDel;
                    Decimal directGaintEagle;
                    Decimal indirectAholdDel;
                    Decimal othersDirect;
                    Decimal othersInDirect;
                    
                    
                    
                    
                    Decimal currentWholesalerunit = blItem.Phoenix_Current_Wholesaler_Units__c != null ? blItem.Phoenix_Current_Wholesaler_Units__c : 0;
                    Decimal currentAndaunit = blItem.Phoenix_Current_Anda_Units__c != null ? blItem.Phoenix_Current_Anda_Units__c : 0;
                    Decimal currentRetailDirectunit = blItem.Phoenix_Current_Retail_Direct_Units__c != null ? blItem.Phoenix_Current_Retail_Direct_Units__c : 0;
                    // Decimal  currentAndaNetModelunit= blItem.Phoenix_Current_Anda_Net_Model_Units__c != null ? blItem.Phoenix_Current_Anda_Net_Model_Units__c : 0;
                    Decimal currentRetailInDirectunit = blItem.Phoenix_Current_Retail_Indirect_Units__c != null ? blItem.Phoenix_Current_Retail_Indirect_Units__c : 0;
                    
                    Decimal OverrideDirectunit = blItem.Phoenix_Override_Current_Direct_Units__c != null ? blItem.Phoenix_Override_Current_Direct_Units__c :currentRetailDirectunit>0?currentRetailDirectunit: 0;
                    Decimal OverrideInDirectunit = blItem.Phoenix_Override_Current_Indirect_Units__c != null ? blItem.Phoenix_Override_Current_Indirect_Units__c : (currentWholesalerunit+currentAndaunit+currentRetailInDirectunit)>0? (currentWholesalerunit+currentAndaunit+currentRetailInDirectunit):0;
                    Decimal OverrideDirectunit1 = blItem.Phoenix_Override_Current_Direct_Units__c != null ? blItem.Phoenix_Override_Current_Direct_Units__c : 0;
                    Decimal OverrideInDirectunit1 = blItem.Phoenix_Override_Current_Indirect_Units__c != null ? blItem.Phoenix_Override_Current_Indirect_Units__c : 0;
                    
                    if(OverrideDirectunit1+OverrideInDirectunit1 >0){
                        blItem.Phoenix_Override_Total_units__c = OverrideDirectunit1 + OverrideInDirectunit1;
                    }
                    else{
                        blItem.Phoenix_Override_Total_units__c=0; 
                    }
                    
                    
                    blItem.Phoenix_Current_Direct_Selling_Unit__c = (OverrideDirectunit1+OverrideInDirectunit1) > 0 ? OverrideDirectunit1 : currentRetailDirectunit;
                    //blItem.Phoenix_Current_Direct_Selling_Unit__c =currentRetailDirectunit;
                    blItem.Phoenix_Current_Indirect_Selling_Unit__c = ((OverrideDirectunit1+OverrideInDirectunit1))  > 0 ? OverrideInDirectunit1 : currentWholesalerunit + currentAndaunit + currentRetailInDirectunit;
                    // blItem.Phoenix_Current_Indirect_Selling_Unit__c =currentWholesalerunit + currentAndaunit + currentRetailInDirectunit;
                    othersDirect = blItem.Phoenix_Others_Direct__c != null ? blItem.Phoenix_Others_Direct__c : 0;
                    othersInDirect = blItem.Phoenix_Others_Indirect__c != null ? blItem.Phoenix_Others_Indirect__c : 0;
                    
                    /*andaIndirectUnits = (othersDirect + othersInDirect) > 0 ? 0 : blItem.Phoenix_Proposed_Anda_Units__c != null ? blItem.Phoenix_Proposed_Anda_Units__c : (OverrideDirectunit1 + OverrideInDirectunit1) > 0 ? 0 : blItem.Phoenix_Current_Anda_Units__c != null ? blItem.Phoenix_Current_Anda_Units__c : 0;
smithIndirectUnits = othersInDirect>0?othersInDirect:blItem.Phoenix_Proposed_Smith_Drug_Units__c != null ? blItem.Phoenix_Proposed_Smith_Drug_Units__c : blItem.Phoenix_Override_Current_Indirect_Units__c != null ? blItem.Phoenix_Override_Current_Indirect_Units__c: blItem.Phoenix_Current_Wholesaler_Units__c != null ? blItem.Phoenix_Current_Wholesaler_Units__c  : 0;
directAholdDel = othersDirect>0?othersDirect/2:blItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c != null ? blItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c :blItem.Phoenix_Override_Current_Direct_Units__c != null ? (blItem.Phoenix_Override_Current_Direct_Units__c) / 2: blItem.Phoenix_Current_Retail_Direct_Units__c != null ? (blItem.Phoenix_Current_Retail_Direct_Units__c) / 2  : 0;
directGaintEagle = othersDirect>0?othersDirect/2:blItem.Phoenix_ProposedDirectGaintEagleUnits__c != null ? blItem.Phoenix_ProposedDirectGaintEagleUnits__c :blItem.Phoenix_Override_Current_Direct_Units__c != null ? (blItem.Phoenix_Override_Current_Direct_Units__c) / 2: blItem.Phoenix_Current_Retail_Direct_Units__c != null ? (blItem.Phoenix_Current_Retail_Direct_Units__c) / 2 : 0;
indirectAholdDel = (othersDirect + othersInDirect) > 0 ? 0 : blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c != null ? blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c : (OverrideDirectunit1 + OverrideInDirectunit1) > 0 ? 0 : blItem.Phoenix_Current_Retail_Indirect_Units__c != null ? blItem.Phoenix_Current_Retail_Indirect_Units__c : 0;*/
                    
                    
                    
                    Decimal direct1 = blItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c != null ? blItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c : 0;
                    Decimal direct2 = blItem.Phoenix_ProposedDirectGaintEagleUnits__c != null ? blItem.Phoenix_ProposedDirectGaintEagleUnits__c : 0;
                    
                    Decimal Indirect1 = blItem.Phoenix_Proposed_Anda_Units__c != null ? blItem.Phoenix_Proposed_Anda_Units__c : 0;
                    Decimal Indirect2 = blItem.Phoenix_Proposed_Smith_Drug_Units__c != null ? blItem.Phoenix_Proposed_Smith_Drug_Units__c : 0;
                    Decimal Indirect3 = blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c != null ? blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c : 0;
                    
                    //blItem.Phoenix_Proposed_Direct_Selling_Unit__c =  blItem.Phoenix_Others_Direct__c != null ? othersDirect : (direct1 + direct2)>0?direct1 + direct2:blItem.Phoenix_Current_Direct_Selling_Unit__c;
                      blItem.Phoenix_Proposed_Direct_Selling_Unit__c =  blItem.Phoenix_Others_Direct__c != null ? othersDirect : (direct1 + direct2)>0?direct1 + direct2:0;

                    // added by Jogarao
                    
                    Decimal totalOverride = OverrideDirectunit1+OverrideInDirectunit1 ;
                    Decimal currentTotalUnits = currentWholesalerunit + currentAndaunit + currentRetailDirectunit + currentRetailInDirectunit;
                    
                    Decimal totalUnits = 0;
                    Decimal totalDirect=blItem.Phoenix_Others_Direct__c != null?othersDirect:direct1 + direct2;
                    Decimal totalInDirect=blItem.Phoenix_Others_Indirect__c != null?othersInDirect:Indirect1 + Indirect2 +Indirect3;
                    
                    Decimal totalProposed =totalDirect+totalInDirect;
                    
                    Decimal totalCurrentUnits = totalOverride != 0 ? totalOverride : currentTotalUnits;
                    totalUnits = totalProposed != 0 ? totalProposed : totalCurrentUnits;
                    
                    if (blItem.Phoenix_SCM_Final_Approval__c != true) {
                        blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = blItem.Phoenix_Proposed_Direct_Selling_Unit__c;
                    }
                    
                   // blItem.Phoenix_Proposed_Indirect_Selling_Unit__c = blItem.Phoenix_Others_Indirect__c != null ?  othersInDirect : (Indirect1 + Indirect2 + Indirect3)>0?Indirect1 + Indirect2 + Indirect3:blItem.Phoenix_Current_Indirect_Selling_Unit__c;
                      blItem.Phoenix_Proposed_Indirect_Selling_Unit__c = blItem.Phoenix_Others_Indirect__c != null ?  othersInDirect : (Indirect1 + Indirect2 + Indirect3)>0?Indirect1 + Indirect2 + Indirect3:0;

                    if (blItem.Phoenix_SCM_Final_Approval__c != true) {
                        blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = blItem.Phoenix_Proposed_Indirect_Selling_Unit__c;
                    }
                    
                    
                    
                    /*Decimal finalDirectUnits = blItem.Phoenix_Final_Direct_Selling_Units_Calc__c	 != null ? blItem.Phoenix_Final_Direct_Selling_Units_Calc__c	 : 0;
if(blItem.Phoenix_SCM_Final_Approval__c==true){
finalDirectUnits=blItem.Phoenix_Final_Direct_Selling_Units_Calc__c;
}*/
                    
                    Decimal finalCalcedScmQuantity = 0;
                    Decimal scmApprovedSmithUnits = 0;
                    Decimal scmApprovedAndaUnits = 0;
                    Decimal scmApproveddirectAholdDelUnits = 0;
                    Decimal scmdirectGaintEagleUnits = 0;
                    Decimal scmindirectAholdDelUnits = 0;
                    
                    
                    if (blItem.Phoenix_SCM_Final_Approval__c != null && blItem.Phoenix_SCM_Final_Approval__c == true) {
                        if(blItem.Phoenix_SCM_Approval_Y_N__c=='Y- Current + Inc Demand Approved'){
                            finalCalcedScmQuantity = ((totalCurrentUnits/12)+((blItem.Phoenix_SCM_Approved_Quantity__c/100)*((totalProposed/12)-(totalCurrentUnits/12))))*12;
                            
                            /*blItem.Phoenix_IDN_Usage__c=(smithIndirectUnits/(smithIndirectUnits+andaIndirectUnits+directAholdDel+directGaintEagle+indirectAholdDel))*blItem.Phoenix_Total_SCM_Approved_Qty__c;
blItem.Phoenix_Days_Notice_Product_Discontinuat__c=(andaIndirectUnits/(smithIndirectUnits+andaIndirectUnits+directAholdDel+directGaintEagle+indirectAholdDel))*blItem.Phoenix_Total_SCM_Approved_Qty__c;
blItem.Phoenix_Day_s_Notice_Product_removal__c= (directAholdDel/(smithIndirectUnits+andaIndirectUnits+directAholdDel+directGaintEagle+indirectAholdDel))*blItem.Phoenix_Total_SCM_Approved_Qty__c;
blItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c= (directGaintEagle/(smithIndirectUnits+andaIndirectUnits+directAholdDel+directGaintEagle+indirectAholdDel))*blItem.Phoenix_Total_SCM_Approved_Qty__c;
blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c= (indirectAholdDel/(smithIndirectUnits+andaIndirectUnits+directAholdDel+directGaintEagle+indirectAholdDel))*blItem.Phoenix_Total_SCM_Approved_Qty__c;*/
                            
                            blItem.Phoenix_IDN_Usage__c=totalUnits != 0?blItem.Phoenix_Others_Indirect__c != null? (othersInDirect/totalUnits)*finalCalcedScmQuantity: (Indirect2/totalUnits)*finalCalcedScmQuantity:0;
                            blItem.Phoenix_Days_Notice_Product_Discontinuat__c=totalUnits != 0? blItem.Phoenix_Others_Indirect__c != null ?0:(Indirect1/totalUnits)*finalCalcedScmQuantity:0;
                            blItem.Phoenix_Day_s_Notice_Product_removal__c=totalUnits != 0?blItem.Phoenix_Others_Direct__c != null?((othersDirect/2)/totalUnits)*finalCalcedScmQuantity:(direct1/totalUnits)*finalCalcedScmQuantity:0;
                            blItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c=totalUnits != 0?blItem.Phoenix_Others_Direct__c != null ?((othersDirect/2)/totalUnits)*finalCalcedScmQuantity:(direct2/totalUnits)*finalCalcedScmQuantity:0;
                            blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c=totalUnits != 0? blItem.Phoenix_Others_Indirect__c != null ?0:(Indirect3/totalUnits)*finalCalcedScmQuantity:0;
                            
                        }
                        else if(blItem.Phoenix_SCM_Approval_Y_N__c=='Y- Only Current Monthly Demand Approved'){
                            blItem.Phoenix_IDN_Usage__c=(OverrideDirectunit1 + OverrideInDirectunit1) > 0 ? OverrideInDirectunit1 : blItem.Phoenix_Current_Anda_Units__c != null ? blItem.Phoenix_Current_Anda_Units__c : 0;
                            blItem.Phoenix_Days_Notice_Product_Discontinuat__c=(OverrideDirectunit1 + OverrideInDirectunit1) > 0 ? 0: blItem.Phoenix_Current_Wholesaler_Units__c != null ? blItem.Phoenix_Current_Wholesaler_Units__c  : 0;
                            blItem.Phoenix_Day_s_Notice_Product_removal__c=(OverrideDirectunit1 + OverrideInDirectunit1) > 0 ? (blItem.Phoenix_Override_Current_Direct_Units__c) / 2: blItem.Phoenix_Current_Retail_Direct_Units__c != null ? (blItem.Phoenix_Current_Retail_Direct_Units__c) / 2  : 0;
                            blItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c=(OverrideDirectunit1 + OverrideInDirectunit1) > 0 ? (blItem.Phoenix_Override_Current_Direct_Units__c) / 2: blItem.Phoenix_Current_Retail_Direct_Units__c != null ? (blItem.Phoenix_Current_Retail_Direct_Units__c) / 2 : 0;
                            blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c=(OverrideDirectunit1 + OverrideInDirectunit1) > 0 ? 0 : blItem.Phoenix_Current_Retail_Indirect_Units__c != null ? blItem.Phoenix_Current_Retail_Indirect_Units__c : 0;
                        }
                        //andaIndirectUnits = blItem.Phoenix_Days_Notice_Product_Discontinuat__c!=null ? blItem.Phoenix_Days_Notice_Product_Discontinuat__c : 0;
                        //indirectAholdDel = blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c!=null ? blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c : 0;
                        
                        
                        
                    }
                    else{
                        blItem.Phoenix_IDN_Usage__c=0;
                        blItem.Phoenix_Days_Notice_Product_Discontinuat__c=0;
                        blItem.Phoenix_Day_s_Notice_Product_removal__c=0;
                        blItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c=0;
                        blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c=0;
                    }
                    
                    
                    scmApprovedSmithUnits = blItem.Phoenix_IDN_Usage__c != null ? blItem.Phoenix_IDN_Usage__c : 0;
                    
                    scmApprovedAndaUnits =blItem.Phoenix_Days_Notice_Product_Discontinuat__c != null ? blItem.Phoenix_Days_Notice_Product_Discontinuat__c : 0;
                    scmApproveddirectAholdDelUnits = blItem.Phoenix_Day_s_Notice_Product_removal__c != null ? blItem.Phoenix_Day_s_Notice_Product_removal__c : 0;
                    scmdirectGaintEagleUnits = blItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c != null ? blItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c : 0;
                    scmindirectAholdDelUnits =blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c != null ? blItem.Phoenix_Proposed_IndirectGaintEagleUnits__c : 0;
                    
                    Decimal SmithOverallUnits = 0;
                    Decimal AndaOverallUnits = 0;
                    Decimal directAholdDelOverallUnits = 0;
                    Decimal directGaintEagleOverallUnits = 0;
                    Decimal indirectAholdDelOverallUnits = 0;
                    
                    
                    //if(finalCalcedScmQuantity != 0){    
                    if (blItem.Phoenix_SCM_Final_Approval__c != null && blItem.Phoenix_SCM_Final_Approval__c == true) {
                        SmithOverallUnits = scmApprovedSmithUnits;
                        AndaOverallUnits = scmApprovedAndaUnits;
                        directAholdDelOverallUnits = scmApproveddirectAholdDelUnits;
                        directGaintEagleOverallUnits = scmdirectGaintEagleUnits;
                        indirectAholdDelOverallUnits = scmindirectAholdDelUnits;
                        
                    }
                    else if(blItem.Phoenix_Others_Direct__c != null || blItem.Phoenix_Others_Indirect__c != null){
                        //Added by Satya
                        if(blItem.Phoenix_Others_Direct__c != null && blItem.Phoenix_Others_Direct__c != null){
                           SmithOverallUnits = othersInDirect;
                            directAholdDelOverallUnits = othersDirect/2 ;//othersDirect/2;
                            directGaintEagleOverallUnits = othersDirect/2; //Indirect3; 
                        } 
                        if(blItem.Phoenix_Others_Direct__c != null && blItem.Phoenix_Others_Indirect__c == null){
                            directAholdDelOverallUnits = othersDirect/2;
                            directGaintEagleOverallUnits = othersDirect/2;
                            SmithOverallUnits = Indirect2;
                            AndaOverallUnits = Indirect1;
                            indirectAholdDelOverallUnits = Indirect3;    
                            
                        }
                        if(blItem.Phoenix_Others_Indirect__c != null && blItem.Phoenix_Others_Direct__c == null){
                            SmithOverallUnits = othersInDirect;
                            AndaOverallUnits = 0;
                            indirectAholdDelOverallUnits = 0;
                            directAholdDelOverallUnits = direct1;
                            directGaintEagleOverallUnits = direct2;
                        }
                       
                     
                    }
                    else if(totalProposed > 0){
                        SmithOverallUnits = Indirect2;
                        AndaOverallUnits = Indirect1;
                        directAholdDelOverallUnits = direct1;
                        directGaintEagleOverallUnits = direct2;
                        indirectAholdDelOverallUnits = Indirect3;
                        
                    }
                    else if(totalOverride > 0){
                        SmithOverallUnits = OverrideInDirectunit1;
                        AndaOverallUnits = 0;
                        directAholdDelOverallUnits = OverrideDirectunit1/2;
                        directGaintEagleOverallUnits = OverrideDirectunit1/2;
                        indirectAholdDelOverallUnits = 0;
                        
                    }
                    else{
                        SmithOverallUnits = currentWholesalerunit;
                        AndaOverallUnits = currentAndaunit;
                        directAholdDelOverallUnits = currentRetailDirectunit/2;
                        directGaintEagleOverallUnits = currentRetailDirectunit/2;
                        indirectAholdDelOverallUnits = currentRetailInDirectunit;
                        
                    }
                    
                    
                    blItem.Phoenix_Final_Direct_Selling_Units_Calc__c=directAholdDelOverallUnits+directGaintEagleOverallUnits;
                    blItem.Phoenix_Proposed_Direct_Selling_Unit__c=blItem.Phoenix_Final_Direct_Selling_Units_Calc__c;
                    blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c=SmithOverallUnits+AndaOverallUnits+indirectAholdDelOverallUnits; 
                    
                    Decimal finalDirectUnits = blItem.Phoenix_Final_Direct_Selling_Units_Calc__c != null ? blItem.Phoenix_Final_Direct_Selling_Units_Calc__c : blItem.Phoenix_Proposed_Direct_Selling_Unit__c;
                    Decimal finalInDirectUnits = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c != null ? blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c : blItem.Phoenix_Proposed_Indirect_Selling_Unit__c;
                    
                    
                    
                    Decimal retailDirectPrice = blItem.Phoenix_Retail_Direct_Price__c != null ? blItem.Phoenix_Retail_Direct_Price__c : blItem.Phoenix_Retail_Direct_Sales_Price__c != null ? blItem.Phoenix_Retail_Direct_Sales_Price__c : blItem.Phoenix_Current_Retail_Direct_Price__c != null ? blItem.Phoenix_Current_Retail_Direct_Price__c : 0;
                    Decimal WAC = blItem.Phoenix_WAC1__c != null ? blItem.Phoenix_WAC1__c : 0;
                    Decimal RDCNLC = blItem.Phoenix_RDC_NLC__c != null ? blItem.Phoenix_RDC_NLC__c : 0;
                    Decimal cashTerm = bidRec.Phoenix_Current_CD__c != null ? bidRec.Phoenix_Current_CD__c : 0;
                    Decimal adminFee = blItem.Phoenix_Current_Admin_Fee__c != null ? blItem.Phoenix_Current_Admin_Fee__c : 0;
                    Decimal VIP;
                    if(blItem.Phoenix_Proposed_Est_VIP__c == null || blItem.Phoenix_Proposed_Est_VIP__c == 0){
                        VIP = bidRec.Phoenix_Proposed_Value_Est_VIP__c != null ? bidRec.Phoenix_Proposed_Value_Est_VIP__c : 0;  
                    }
                    else{
                        VIP = blItem.Phoenix_Proposed_Est_VIP__c != null ? blItem.Phoenix_Proposed_Est_VIP__c : 0;   
                    }
                    
                    //if(retailDirectPrice!=null){
                    blItem.Phoenix_Direct_CD__c = (cashTerm / 100) * retailDirectPrice;
                    //}
                    //if(blItem.Phoenix_Retail_Direct_Price__c!=null){
                    blItem.Phoenix_Retail_Direct_Admin_Fee__c = (adminFee / 100) * retailDirectPrice;
                    //}
                    Decimal retailDirectAdminFee = blItem.Phoenix_Retail_Direct_Admin_Fee__c != null ? blItem.Phoenix_Retail_Direct_Admin_Fee__c : 0;
                    blItem.Phoenix_Retail_Indirect_WAC_NLC_Fee__c = (RDCNLC / 100) * WAC;
                    blItem.Phoenix_Retail_Direct_VIP__c = (VIP / 100) * (retailDirectPrice - retailDirectAdminFee);
                    //if(blItem.Phoenix_Retail_Direct_Admin_Fee__c!=null){
                    blItem.Phoenix_Anda_Admin_Fees__c = retailDirectAdminFee;
                    // }
                    Decimal AndaAdminFee = blItem.Phoenix_Anda_Admin_Fees__c != null ? blItem.Phoenix_Anda_Admin_Fees__c : 0;
                    blItem.Phoenix_Anda_VIP__c = (retailDirectPrice - AndaAdminFee) * (VIP / 100);
                    
                    if (retailDirectPrice > 0) {
                        blItem.Phoenix_Wholesaler_Price_RxSS__c = retailDirectPrice + ((cashTerm / 100) * WAC) - ((cashTerm / 100) * retailDirectPrice);
                    } else {
                        blItem.Phoenix_Wholesaler_Price_RxSS__c = 0;
                    }
                    
                    Decimal wholesalerPrice = blItem.Phoenix_Wholesaler_Price_RxSS__c != null ? blItem.Phoenix_Wholesaler_Price_RxSS__c : 0;
                    
                    blItem.Phoenix_Wholesaler_Admin_Fee__c = (adminFee / 100) * wholesalerPrice;
                    Decimal wholesalerAdminFee = blItem.Phoenix_Wholesaler_Admin_Fee__c != null ? blItem.Phoenix_Wholesaler_Admin_Fee__c : 0;
                    
                    blItem.Phoenix_Wholesaler_VIP__c = (VIP / 100) * (wholesalerPrice - wholesalerAdminFee);
                    Decimal directCD = blItem.Phoenix_Direct_CD__c != null ? blItem.Phoenix_Direct_CD__c : 0;
                    
                    //blItem.Phoenix_Retail_Customer_Net_Price__c=retailDirectPrice-directCD;
                    Decimal IndirectCD = blItem.Phoenix_INDIRECT_CD__c != null ? blItem.Phoenix_INDIRECT_CD__c : 0;
                    
                    //blItem.Phoenix_Wholesaler_Customer_Net_Price__c=wholesalerPrice-IndirectCD;
                    
                    Decimal retailDirectVIP = blItem.Phoenix_Retail_Direct_VIP__c != null ? blItem.Phoenix_Retail_Direct_VIP__c : 0;
                    
                    blItem.Phoenix_Direct_Dead_Net__c = retailDirectPrice - directCD - retailDirectAdminFee - retailDirectVIP;
                    Decimal wholesalerVIP = blItem.Phoenix_Wholesaler_VIP__c != null ? blItem.Phoenix_Wholesaler_VIP__c : 0;
                    if (wholesalerPrice > 0) {
                        blItem.Phoenix_Wholesaler_DRL_Net_Price__c = wholesalerPrice - IndirectCD - wholesalerAdminFee - wholesalerVIP;
                    } else {
                        blItem.Phoenix_Wholesaler_DRL_Net_Price__c = 0;
                    }
                    
                    blItem.Phoenix_Cash_Terms_RxSS__c = wholesalerPrice * (cashTerm / 100);
                    
                    Decimal cashTerms = blItem.Phoenix_Cash_Terms_RxSS__c != null ? blItem.Phoenix_Cash_Terms_RxSS__c : 0;
                    Decimal andaVIP = blItem.Phoenix_Anda_VIP__c != null ? blItem.Phoenix_Anda_VIP__c : 0;
                    
                    blItem.Phoenix_Anda_DRL_Net_price__c = retailDirectPrice - cashTerms - AndaAdminFee - andaVIP;
                    blItem.Phoenix_Charge_Back__c = wholesalerPrice - retailDirectPrice;
                    Decimal chargeBack = blItem.Phoenix_Charge_Back__c != null ? blItem.Phoenix_Charge_Back__c : 0;
                    
                    blItem.Phoenix_Anda_New_Model_Acqusition_Costs__c = wholesalerPrice - cashTerms- chargeBack;
                    // blItem.Phoenix_Anda_Old_Acqusition_Costs__c=wholesalerPrice-((cashTerm/100)*WAC);
                    Decimal andaNewModelAcq = blItem.Phoenix_Anda_New_Model_Acqusition_Costs__c != null ? blItem.Phoenix_Anda_New_Model_Acqusition_Costs__c : 0;
                    //Decimal andaOldAcq = blItem.Phoenix_Anda_Old_Acqusition_Costs__c	 != null ? blItem.Phoenix_Anda_Old_Acqusition_Costs__c	 : 0;
                    
                    // blItem.Phoenix_Acquisition_Difference__c=  andaOldAcq - andaNewModelAcq;
                    Decimal directDeadNet = blItem.Phoenix_Direct_Dead_Net__c != null ? blItem.Phoenix_Direct_Dead_Net__c : 0;
                    Decimal throughputCost = blItem.Phoenix_Throughput_Cost1__c != null ? blItem.Phoenix_Throughput_Cost1__c : 0;
                    if (retailDirectPrice > 0) {
                        blItem.Phoenix_Retail_Direct_DRL_TPT__c = directDeadNet - throughputCost;
                    } else {
                        blItem.Phoenix_Retail_Direct_DRL_TPT__c = 0;
                    }
                    
                    Decimal wholesalerDRLNetPrice = blItem.Phoenix_Wholesaler_DRL_Net_Price__c != null ? blItem.Phoenix_Wholesaler_DRL_Net_Price__c : 0;
                    if (wholesalerDRLNetPrice > 0) {
                        blItem.Phoenix_Wholesaler_DRL_TPT__c = wholesalerDRLNetPrice - throughputCost;
                    } else {
                        blItem.Phoenix_Wholesaler_DRL_TPT__c = 0;
                    }
                    
                    Decimal andaDRLNetPrice = blItem.Phoenix_Anda_DRL_Net_price__c != null ? blItem.Phoenix_Anda_DRL_Net_price__c : 0;
                    if (andaDRLNetPrice > 0) {
                        blItem.Phoenix_Anda_DRL_TPT__c = andaDRLNetPrice - throughputCost;
                    } else {
                        blItem.Phoenix_Anda_DRL_TPT__c = 0;
                    }
                    
                    Decimal retailDirectDRLTPT = blItem.Phoenix_Retail_Direct_DRL_TPT__c != null ? blItem.Phoenix_Retail_Direct_DRL_TPT__c : 0;
                    if (directDeadNet > 0) {
                        blItem.Phoenix_Retail_Direct_DRL_TPT_Percent__c = (retailDirectDRLTPT / directDeadNet) * 100;
                    }
                    Decimal wholesalerDRLTPT = blItem.Phoenix_Wholesaler_DRL_TPT__c != null ? blItem.Phoenix_Wholesaler_DRL_TPT__c : 0;
                    
                    if (wholesalerDRLNetPrice > 0) {
                        blItem.Phoenix_Wholesaler_DRL_TPT_Percent__c = (wholesalerDRLTPT / wholesalerDRLNetPrice) * 100;
                    }
                    Decimal andaDRLTPT = blItem.Phoenix_Anda_DRL_TPT__c != null ? blItem.Phoenix_Anda_DRL_TPT__c : 0;
                    
                    if (andaDRLNetPrice > 0) {
                        blItem.Phoenix_Anda_DRL_TPT_Percent__c = (andaDRLTPT / andaDRLNetPrice) * 100;
                    }
                    
                    Decimal andaInvoicePrice = blItem.Phoenix_Current_Anda_Invoice_Price__c != null ? blItem.Phoenix_Current_Anda_Invoice_Price__c : 0;
                    Decimal andaCPPrice = blItem.Phoenix_Current_Anda_CP_Price__c != null ? blItem.Phoenix_Current_Anda_CP_Price__c : 0;
                    blItem.Phoenix_Current_Anda_Acquisition_Costs__c = andaInvoicePrice - (andaInvoicePrice * (cashTerm / 100)) - (andaInvoicePrice - andaCPPrice);
                    Decimal IOD = bidRec.Phoenix_Proposed_Initial_Order_Discount__c != null ? bidRec.Phoenix_Proposed_Initial_Order_Discount__c : 0;
                    blItem.Phoenix_Wholesaler_IOD_per_unit__c = (IOD / 100) * WAC;
                    
                    blItem.Phoenix_Retail_IOD_per_unit__c = (IOD / 100) * retailDirectPrice;
                    Decimal IODdays = bidRec.Phoenix_Initial_Order_Discount_of_Days__c != null ? bidRec.Phoenix_Initial_Order_Discount_of_Days__c : 0;
                    Decimal reatilIODunit = blItem.Phoenix_Retail_IOD_per_unit__c != null ? blItem.Phoenix_Retail_IOD_per_unit__c : 0;
                    
                    /* Decimal direct3 = blItem.Phoenix_SCM_Final_Approval__c == true? blItem.Phoenix_Day_s_Notice_Product_removal__c:blItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c != null ? blItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c : 0;
Decimal direct4 = blItem.Phoenix_SCM_Final_Approval__c == true? blItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c:blItem.Phoenix_ProposedDirectGaintEagleUnits__c != null ? blItem.Phoenix_ProposedDirectGaintEagleUnits__c : 0;


Decimal Indirect4 = blItem.Phoenix_SCM_Final_Approval__c == true? blItem.Phoenix_IDN_Usage__c:blItem.Phoenix_Proposed_Smith_Drug_Units__c != null ? blItem.Phoenix_Proposed_Smith_Drug_Units__c : 0;
Decimal directUnit=0;
Decimal IndirectUnit=0;
if(blItem.Phoenix_SCM_Final_Approval__c == true){
directUnit=direct3 + direct4;
}
else{
directUnit = othersDirect > 0 ? othersDirect : (direct3 + direct4) > 0 ? (direct3 + direct4) : blItem.Phoenix_Override_Current_Direct_Units__c > 0 ? blItem.Phoenix_Override_Current_Direct_Units__c : blItem.Phoenix_Current_Retail_Direct_Units__c > 0 ? blItem.Phoenix_Current_Retail_Direct_Units__c : 0;

}
if(blItem.Phoenix_SCM_Final_Approval__c == true){
IndirectUnit=Indirect4;
}
else{
IndirectUnit = othersInDirect > 0 ? othersInDirect : Indirect4 > 0 ? Indirect4 : blItem.Phoenix_Override_Current_Indirect_Units__c > 0 ? blItem.Phoenix_Override_Current_Indirect_Units__c : blItem.Phoenix_Current_Wholesaler_Units__c > 0 ? blItem.Phoenix_Current_Wholesaler_Units__c : 0;

}*/
                    blItem.Phoenix_Retail_IOD_overall_amount__c = ((directAholdDelOverallUnits+directGaintEagleOverallUnits) / 360) * IODdays * reatilIODunit;
                    
                    Decimal wholesalerIODunit = blItem.Phoenix_Wholesaler_IOD_per_unit__c != null ? blItem.Phoenix_Wholesaler_IOD_per_unit__c : 0;
                    blItem.Phoenix_Wholesaler_IOD_overall_amount__c = (SmithOverallUnits / 360) * IODdays * wholesalerIODunit;
                    
                    Decimal retailIODAmount = blItem.Phoenix_Retail_IOD_overall_amount__c != null ? blItem.Phoenix_Retail_IOD_overall_amount__c : 0;
                    Decimal MediReturnUnit = blItem.Phoenix_Estimated_Medicaid_Returns__c != null ? blItem.Phoenix_Estimated_Medicaid_Returns__c : 0;
                    
                    
                    
                    if (directDeadNet > 0) {
                        blItem.Phoenix_Retail_Direct_Net_sales__c = (directDeadNet * (directAholdDelOverallUnits+directGaintEagleOverallUnits) - retailIODAmount) - (MediReturnUnit * (directAholdDelOverallUnits+directGaintEagleOverallUnits));
                    } else {
                        blItem.Phoenix_Retail_Direct_Net_sales__c = 0;
                    }
                    
                    blItem.Phoenix_ANDA_IOD_Per_unit__c = (IOD / 100) * wholesalerPrice;
                    Decimal andaIODPerUnit = blItem.Phoenix_ANDA_IOD_Per_unit__c != null ? blItem.Phoenix_ANDA_IOD_Per_unit__c : 0;
                    blItem.Phoenix_ANDA_IOD_Overall_Amount__c = (AndaOverallUnits / 360) * IODdays * andaIODPerUnit;
                    
                    Decimal andaIODAmount = blItem.Phoenix_ANDA_IOD_Overall_Amount__c != null ? blItem.Phoenix_ANDA_IOD_Overall_Amount__c : 0;
                    
                    if (andaDRLNetPrice > 0) {
                        blItem.Phoenix_Anda_Net_Model_Sales__c = (andaDRLNetPrice * AndaOverallUnits) -andaIODAmount- (MediReturnUnit * AndaOverallUnits);
                    } else {
                        blItem.Phoenix_Anda_Net_Model_Sales__c = 0;
                    }
                    
                    Decimal wholesalerIODAmount = blItem.Phoenix_Wholesaler_IOD_overall_amount__c != null ? blItem.Phoenix_Wholesaler_IOD_overall_amount__c : 0;
                    
                    if (wholesalerDRLNetPrice > 0) {
                        blItem.Phoenix_Wholesaler_Net_Sales__c = ((wholesalerDRLNetPrice * SmithOverallUnits) - wholesalerIODAmount) - (MediReturnUnit * SmithOverallUnits);
                    } else {
                        blItem.Phoenix_Wholesaler_Net_Sales__c = 0;
                    }
                    
                    Decimal currentretaildirectPrice = blItem.Phoenix_Current_Retail_Direct_Price__c != null ? blItem.Phoenix_Current_Retail_Direct_Price__c : 0;
                    Decimal currentretailIndirectPrice = blItem.Phoenix_Current_Retail_Indirect_Price__c != null ? blItem.Phoenix_Current_Retail_Indirect_Price__c : 0;
                    Decimal PUR = blItem.Phoenix_Current_Per_Unit_Rebate__c != null ? blItem.Phoenix_Current_Per_Unit_Rebate__c : 0;
                    
                    blItem.Phoenix_Current_Retail_Indirect_Net__c = currentretailIndirectPrice - PUR;
                    blItem.Phoenix_Current_Anda_CP_Price__c=currentretaildirectPrice;
                    
                    if (currentretaildirectPrice > 0) {
                        blItem.Phoenix_Current_Wholesaler_Price__c = currentretaildirectPrice + ((cashTerm / 100) * WAC) - ((cashTerm / 100) * currentretaildirectPrice);
                    } else {
                        blItem.Phoenix_Current_Wholesaler_Price__c = 0;
                    }
                    
                    Decimal currentwholesalerPrice = blItem.Phoenix_Current_Wholesaler_Price__c != null ? blItem.Phoenix_Current_Wholesaler_Price__c : 0;
                    blItem.Phoenix_Current_Anda_Invoice_Price__c = currentwholesalerPrice;
                    
                    
                    Decimal currentAndaInvoicePrice = blItem.Phoenix_Current_Anda_Invoice_Price__c != null ? blItem.Phoenix_Current_Anda_Invoice_Price__c : 0;
                    Decimal currentAndaCP = blItem.Phoenix_Current_Anda_CP_Price__c != null ? blItem.Phoenix_Current_Anda_CP_Price__c : 0;
                    // blItem.Phoenix_Current_Direct_Selling_Unit__c=currentRetailDirectunit+currentAndaNetModelunit;
                    blItem.Phoenix_Current_Anda_Acquisition_Costs__c = currentAndaInvoicePrice - (currentAndaInvoicePrice * (cashTerm / 100)) - (currentAndaInvoicePrice - currentAndaCP);
                    
                    Decimal CMFee = blItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c != null ? blItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c : 0;
                    Decimal retailIndirectPrice = blItem.Phoenix_Retail_Indirect_Price__c != null ? blItem.Phoenix_Retail_Indirect_Price__c : blItem.Phoenix_Wholesaler_Sales_Price__c != null ? blItem.Phoenix_Wholesaler_Sales_Price__c : blItem.Phoenix_Current_Retail_Indirect_Price__c != null ? blItem.Phoenix_Current_Retail_Indirect_Price__c : 0;
                    blItem.Phoenix_Retail_Indirect_WholesalerFeeRxS__c = (CMFee / 100) * retailIndirectPrice;
                    if (retailDirectPrice > 0) {
                        blItem.Phoenix_Retail_Indirect_Net__c = retailDirectPrice + (retailIndirectPrice * (CMFee / 100)) + (((RDCNLC / 100) * WAC) - ((cashTerm / 100) * retailDirectPrice));
                    } else {
                        blItem.Phoenix_Retail_Indirect_Net__c = 0;
                    }
                    
                    
                    Decimal retailIndirectNet = blItem.Phoenix_Retail_Indirect_Net__c != null ? blItem.Phoenix_Retail_Indirect_Net__c : 0;
                    //blItem.Phoenix_Retail_Indirect_ZITD__c=retailIndirectPrice-retailIndirectNet;
                    Decimal retailIndirectZITD = retailIndirectPrice-retailIndirectNet;
                    
                    blItem.Phoenix_Retail_Indirect_Admin_Fees__c = (retailIndirectPrice-retailIndirectZITD) * (adminFee / 100);
                    Decimal retailIndirectAdminFee = blItem.Phoenix_Retail_Indirect_Admin_Fees__c != null ? blItem.Phoenix_Retail_Indirect_Admin_Fees__c : 0;
                    
                    blItem.Phoenix_Retail_Indirect_VIP__c = (retailIndirectPrice -retailIndirectZITD- retailIndirectAdminFee) * (VIP / 100);
                    Decimal retailIndirectWACNLCFee = blItem.Phoenix_Retail_Indirect_WAC_NLC_Fee__c != null ? blItem.Phoenix_Retail_Indirect_WAC_NLC_Fee__c : 0;
                    Decimal retailIndirectWHLSFee = blItem.Phoenix_Retail_Indirect_WholesalerFeeRxS__c != null ? blItem.Phoenix_Retail_Indirect_WholesalerFeeRxS__c : 0;
                    Decimal retailIndirectVIP = blItem.Phoenix_Retail_Indirect_VIP__c != null ? blItem.Phoenix_Retail_Indirect_VIP__c : 0;
                    Decimal whlsrControlSubFee = blItem.Phoenix_Whlsr_Controlled_Substance_Fee__c != null ? blItem.Phoenix_Whlsr_Controlled_Substance_Fee__c : 0;
                    if (retailIndirectPrice > 0) {
                        blItem.Phoenix_Indirect_Dead_Net__c = retailIndirectPrice -retailIndirectZITD- retailIndirectAdminFee - retailIndirectWACNLCFee - retailIndirectWHLSFee - retailIndirectVIP - whlsrControlSubFee;
                    } else {
                        blItem.Phoenix_Indirect_Dead_Net__c = 0;
                    }
                    
                    Decimal IndirectDeadNet = blItem.Phoenix_Indirect_Dead_Net__c != null ? blItem.Phoenix_Indirect_Dead_Net__c : 0;
                    if (IndirectDeadNet > 0) {
                        blItem.Phoenix_Retail_Indirect_DRL_TPT__c = IndirectDeadNet - throughputCost;
                    } else {
                        blItem.Phoenix_Retail_Indirect_DRL_TPT__c = 0;
                    }
                    
                    Decimal retailIndirectDRLTPT = blItem.Phoenix_Retail_Indirect_DRL_TPT__c != null ? blItem.Phoenix_Retail_Indirect_DRL_TPT__c : 0;
                    if (IndirectDeadNet > 0) {
                        blItem.Phoenix_Retail_Indirect_DRL_TPT_Percent__c = (retailIndirectDRLTPT / IndirectDeadNet) * 100;
                    }
                    if (IndirectDeadNet > 0) {
                        blItem.Phoenix_Retail_Indirect_Net_Sales__c = (IndirectDeadNet * (indirectAholdDelOverallUnits)) - (MediReturnUnit * (indirectAholdDelOverallUnits));
                    } else {
                        blItem.Phoenix_Retail_Indirect_Net_Sales__c = 0;
                    }
                    
                    Decimal retailDirectNetSales = blItem.Phoenix_Retail_Direct_Net_sales__c != null ? blItem.Phoenix_Retail_Direct_Net_sales__c : 0;
                    Decimal retailInDirectNetSales = blItem.Phoenix_Retail_Indirect_Net_Sales__c != null ? blItem.Phoenix_Retail_Indirect_Net_Sales__c : 0;
                    Decimal andaNetModelSales = blItem.Phoenix_Anda_Net_Model_Sales__c != null ? blItem.Phoenix_Anda_Net_Model_Sales__c : 0;
                    Decimal wholesalerModelSales = blItem.Phoenix_Wholesaler_Net_Sales__c != null ? blItem.Phoenix_Wholesaler_Net_Sales__c : 0;
                    
                    blItem.Phoenix_Net_Sales_Internal__c = retailDirectNetSales + retailInDirectNetSales + andaNetModelSales + wholesalerModelSales;
                    
                    Decimal netSalesInternal = blItem.Phoenix_Net_Sales_Internal__c != null ? blItem.Phoenix_Net_Sales_Internal__c.setscale(0) : 0;
                    Decimal finalTotalSellingUnits = blItem.Phoenix_Final_Total_Selling_Unit__c != null ? blItem.Phoenix_Final_Total_Selling_Unit__c : 0;
                    if ((finalDirectUnits + finalInDirectUnits) > 0 && netSalesInternal > 0) {
                        blItem.Phoenix_Internal_Dead_Net_Price__c = netSalesInternal / (finalDirectUnits + finalInDirectUnits);
                    } else {
                        blItem.Phoenix_Internal_Dead_Net_Price__c = 0;
                    }
                    
                    if (currentretaildirectPrice > 0) {
                        blItem.Phoenix_Reduction__c = ((retailDirectPrice / currentretaildirectPrice) - 1) * 100;
                        
                        
                        
                    }
                    
                    //Price and Volume Variance changes by jogarao
                    Decimal totalOtherUnits = othersDirect + othersInDirect;
                    Decimal volumeDiffRatailDirect =(( blItem.Phoenix_SCM_Final_Approval__c != false ? (directAholdDelOverallUnits+directGaintEagleOverallUnits):(direct1+direct2)) - (totalOverride>0 ? OverrideDirectunit1 :currentRetailDirectunit));
                    Decimal volumeDifRetailIndir = ((blItem.Phoenix_SCM_Final_Approval__c != false ? indirectAholdDelOverallUnits:Indirect3) - (totalOverride>0 ? 0 :currentRetailInDirectunit)) ;
                    Decimal volumeDifWholsaler = ((blItem.Phoenix_SCM_Final_Approval__c != false ? SmithOverallUnits : Indirect2) - (totalOverride>0 ? OverrideInDirectunit1 :currentWholesalerunit));
                    Decimal volumeDifAndaUnits = ((blItem.Phoenix_SCM_Final_Approval__c != false ? AndaOverallUnits : Indirect1) - (totalOverride>0 ? 0 : currentAndaunit)) ;
                    
                    Decimal priceDifRetailDir = (blItem.Phoenix_Direct_Dead_Net__c!=null ?blItem.Phoenix_Direct_Dead_Net__c:0) - (blItem.Phoenix_Current_ASP_Dose__c != null ? blItem.Phoenix_Current_ASP_Dose__c :0);
                    Decimal priceDifRetailIndir = (blItem.Phoenix_Indirect_Dead_Net__c!=null ?blItem.Phoenix_Indirect_Dead_Net__c:0) - (blItem.Phoenix_Current_ASP_Dose__c != null ? blItem.Phoenix_Current_ASP_Dose__c :0);
                    Decimal priceDifRetailWholSaler = (blItem.Phoenix_Wholesaler_DRL_Net_Price__c!=null ?blItem.Phoenix_Wholesaler_DRL_Net_Price__c:0) - (blItem.Phoenix_Current_ASP_Dose__c != null ? blItem.Phoenix_Current_ASP_Dose__c :0);
                    Decimal priceDifRetailAnda = (blItem.Phoenix_Anda_DRL_Net_price__c!=null ?blItem.Phoenix_Anda_DRL_Net_price__c:0) - (blItem.Phoenix_Current_ASP_Dose__c != null ? blItem.Phoenix_Current_ASP_Dose__c :0);
                    
                    Decimal priceVarianceRetailDir = priceDifRetailDir * (totalOverride>0 ? OverrideDirectunit1 :currentRetailDirectunit);
                    Decimal priceVarianceRetailIndir = priceDifRetailIndir * (totalOverride>0 ? 0 : currentRetailInDirectunit);
                    Decimal priceVarianceWholeSaler = priceDifRetailWholSaler * (totalOverride>0 ? OverrideInDirectunit1 : currentWholesalerunit);
                    Decimal priceVarianceAnda = priceDifRetailAnda * (totalOverride>0 ? 0 : currentAndaunit);
                    
                    Decimal volumeVarianceRetailDirect =  priceDifRetailDir * ((othersDirect > 0 && blItem.Phoenix_SCM_Final_Approval__c == false) ? (othersDirect-currentRetailDirectunit) : volumeDiffRatailDirect);
                    Decimal volumeVarianceRetailindirect =  priceDifRetailIndir * volumeDifRetailIndir;
                    volumeVarianceRetailindirect = (othersInDirect>0 ? 0: volumeVarianceRetailindirect);
                    Decimal volumeVarianceWholeSaler =  priceDifRetailWholSaler * volumeDifWholsaler;
                    volumeVarianceWholeSaler = (othersInDirect>0 ? 0: volumeVarianceWholeSaler);
                    Decimal volumeVarianceAnda =  priceDifRetailAnda * volumeDifAndaUnits;
                    volumeVarianceAnda = ((othersInDirect>0 && blItem.Phoenix_SCM_Final_Approval__c == false) ? (priceDifRetailAnda*(othersInDirect - (totalOverride>0 ? OverrideInDirectunit1 :currentWholesalerunit))): volumeVarianceAnda );
                    
                    blItem.Phoenix_Price_Variance__c = (bidType == 'Sales Out Rebate' || bidType == 'RFP Bids' || bidType == 'Price Change' || bidType == 'Customer Rebate Change') ? (priceVarianceRetailDir + priceVarianceRetailIndir+priceVarianceWholeSaler+priceVarianceAnda):0;
                    blItem.Phoenix_Volume_Variance__c = (bidType == 'Sales Out Rebate' || bidType == 'Price Change' || bidType == 'Customer Rebate Change') ? 0 : (volumeVarianceRetailDirect + volumeVarianceRetailindirect+volumeVarianceWholeSaler+volumeVarianceAnda) ;  
                        
                        blItem.Phoenix_Proposed_Sales__c =  netSalesInternal;
                     // SSA Hit Calculation 
                    Decimal finlaDirectUnitsRxss =(totalOverride>0 ? OverrideDirectunit1 :currentRetailDirectunit);
                    Decimal DiffPrice = (blItem.Phoenix_Retail_Direct_Price__c != null ? blItem.Phoenix_Retail_Direct_Price__c : blItem.Phoenix_Retail_Direct_Sales_Price__c != null ? blItem.Phoenix_Retail_Direct_Sales_Price__c :0) - (blItem.Phoenix_Current_Retail_Direct_Price__c!= null ? blItem.Phoenix_Current_Retail_Direct_Price__c : 0);
                    Decimal SSANoofDays = (bidRec.Phoenix_Proposed_SSA_No_of_Days__c != null ? bidRec.Phoenix_Proposed_SSA_No_of_Days__c :0)/30;
                    Decimal ssaHitforRetailDirect = DiffPrice * SSANoofDays * (finlaDirectUnitsRxss/12);    
                    Decimal finlaDirectAndaUnitsRxss = (totalOverride>0 ? OverrideInDirectunit1 : currentAndaunit) ;
                    Decimal DiffAndaPrice = (blItem.Phoenix_Retail_Direct_Price__c != null ? blItem.Phoenix_Retail_Direct_Price__c : blItem.Phoenix_Retail_Direct_Sales_Price__c != null ? blItem.Phoenix_Retail_Direct_Sales_Price__c :0) - (blItem.Phoenix_Current_Anda_CP_Price__c!= null ? blItem.Phoenix_Current_Anda_CP_Price__c : 0);
                    blItem.Phoenix_SSA_Hit_Updated__c = (ssaHitforRetailDirect + (DiffPrice * SSANoofDays * (finlaDirectAndaUnitsRxss/12)));    
                    //Current Sales Calculation Start===
                    Decimal finalWholeSalerUnits = (blItem.Phoenix_Override_Current_Indirect_Units__c!=null ? blItem.Phoenix_Override_Current_Indirect_Units__c:blItem.Phoenix_Current_Wholesaler_Units__c);
                    Decimal finalAndaUnits = (blItem.Phoenix_Current_Anda_Units__c!=null ? blItem.Phoenix_Current_Anda_Units__c:blItem.Phoenix_Current_Anda_Units__c!=null? blItem.Phoenix_Current_Anda_Units__c:0);
                    Decimal finalRetailIndirectUnits = (blItem.Phoenix_Current_Retail_Indirect_Units__c!=null ? blItem.Phoenix_Current_Retail_Indirect_Units__c:blItem.Phoenix_Current_Retail_Indirect_Units__c!=null?blItem.Phoenix_Current_Retail_Indirect_Units__c:0);
                    Decimal finalRetailDirectUnits = (blItem.Phoenix_Override_Current_Direct_Units__c !=null ? blItem.Phoenix_Override_Current_Direct_Units__c:blItem.Phoenix_Current_Retail_Direct_Units__c !=null ? blItem.Phoenix_Current_Retail_Direct_Units__c:0);
                    
                  //  Decimal currentCVSDirectSales = (((blItem.Current_CVS_DeadNet__c != null ? blItem.Current_CVS_DeadNet__c: 0)* (finalWholeSalerUnits)) -((finalWholeSalerUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c));
                  //  Decimal currentCVSIndirectSales = (((blItem.Current_CVS_Indirect_DeadNet__c != null ? blItem.Current_CVS_Indirect_DeadNet__c: 0)* (finalAndaUnits)) - ((finalAndaUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c));
                 //   Decimal currentCardinalSales = (((blItem.Current_Cardinal_DeadNet__c != null ? blItem.Current_Cardinal_DeadNet__c: 0)* (finalRetailIndirectUnits)) - ((finalRetailIndirectUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c));
                 //   Decimal currentMajorSales = (((blItem.Current_Major_DeadNet__c != null ? blItem.Current_Major_DeadNet__c: 0)* (finalRetailDirectUnits)) - ((finalRetailDirectUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c));
                    
                    Decimal currentCVSDirectSales = (blItem.Current_CVS_DeadNet__c != null ? ((blItem.Current_CVS_DeadNet__c * finalWholeSalerUnits) -(finalWholeSalerUnits * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c)): 0);
                    Decimal currentCVSIndirectSales = (blItem.Current_CVS_Indirect_DeadNet__c != null ? ((blItem.Current_CVS_Indirect_DeadNet__c * finalAndaUnits) - (finalAndaUnits * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c)): 0);
                    Decimal currentCardinalSales = (blItem.Current_Cardinal_DeadNet__c != null ? (blItem.Current_Cardinal_DeadNet__c * finalRetailIndirectUnits) - (finalRetailIndirectUnits * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c): 0);
                    Decimal currentMajorSales = (blItem.Current_Major_DeadNet__c != null ? (blItem.Current_Major_DeadNet__c * (finalRetailDirectUnits)) - ((finalRetailDirectUnits) * blItem.Phoenix_Medicaid_Returns_Per_Unit_in__c): 0);
                    
                    blItem.Finance_Current_Sales__c = currentCVSDirectSales+currentCVSIndirectSales+currentCardinalSales+currentMajorSales;
                    system.debug('Trigger Finance_Current_Sales__c--->'+blItem.Finance_Current_Sales__c);
                    //Current Sales Calculation End===
                    /*New ProductLaunch*/
                    Decimal brandwac =( blItem.Brand_WAC__c != null && blItem.Brand_WAC__c !=0)?blItem.Brand_WAC__c:0;
                    Decimal proposedASP=(blItem.Phoenix_Direct_Dead_Net__c!=null && blItem.Phoenix_Direct_Dead_Net__c!=0)?blItem.Phoenix_Direct_Dead_Net__c:0;
                    blItem.Phoenix_Brand_WAC_Per__c =(brandwac != 0 && brandwac != null)? (proposedASP / brandwac)*100 : 0;
                    Decimal andaDeadnet = (blItem.Phoenix_Anda_DRL_Net_price__c != null && blItem.Phoenix_Anda_DRL_Net_price__c != 0) ? blItem.Phoenix_Anda_DRL_Net_price__c : 0;
                    blItem.Phoenix_Invoice_Allowance__c =(brandwac != 0 && brandwac != null)? (andaDeadnet / brandwac)*100 : 0;
                    Decimal wholesalerDeadnet = (blItem.Phoenix_Wholesaler_DRL_Net_Price__c != null && blItem.Phoenix_Wholesaler_DRL_Net_Price__c != 0) ? blItem.Phoenix_Wholesaler_DRL_Net_Price__c : 0;
                    blItem.Phoenix_Sales_Out_Promotion_Proposed__c =(brandwac != 0 && brandwac != null)? (wholesalerDeadnet / brandwac)*100 : 0;
                    Decimal openingorder = (blItem.Phoenix_Opening_Order__c != null && blItem.Phoenix_Opening_Order__c != 0)?blItem.Phoenix_Opening_Order__c :0;
                    Decimal retailIodOverallAmount = (blItem.Phoenix_Retail_IOD_overall_amount__c != null && blItem.Phoenix_Retail_IOD_overall_amount__c !=0)? blItem.Phoenix_Retail_IOD_overall_amount__c :0;
                    blItem.Phoenix_Opening_Order_Net_sales__c = (proposedASP >0 && openingorder>0) ? (openingorder * proposedASP) - retailIodOverallAmount - (openingorder * MediReturnUnit) : 0;
                    Decimal openingOrdernetsales = (blItem.Phoenix_Opening_Order_Net_sales__c != null && blItem.Phoenix_Opening_Order_Net_sales__c != 0) ? blItem.Phoenix_Opening_Order_Net_sales__c : 0;
                    blItem.Phoenix_Opening_Order_TPT__c = openingOrdernetsales > 0 ? openingOrdernetsales - (openingorder * throughputCost) : 0;
                    Decimal openingordertptdl = (blItem.Phoenix_Opening_Order_TPT__c != null &&  blItem.Phoenix_Opening_Order_TPT__c != 0) ?blItem.Phoenix_Opening_Order_TPT__c :0 ;
                    blItem.Phoenix_Opening_Order_TPT_Per__c = ( openingordertptdl > 0 && openingOrdernetsales !=0) ? (openingordertptdl / openingOrdernetsales)*100 :0 ;
                    Decimal openingorderAnda = (blItem.Phoenix_Direct_Accerodo__c != null && blItem.Phoenix_Direct_Accerodo__c != 0) ? blItem.Phoenix_Direct_Accerodo__c : 0;
                    Decimal andaIODOvrAmnt = (blItem.Phoenix_ANDA_IOD_Overall_Amount__c != null && blItem.Phoenix_ANDA_IOD_Overall_Amount__c != 0) ? blItem.Phoenix_ANDA_IOD_Overall_Amount__c : 0;
                    blItem.Proposed_Net_Sales_Direct__c = (andaDeadnet>0 && openingorderAnda>0 )? (openingorderAnda *andaDeadnet ) - andaIODOvrAmnt - (openingorderAnda * MediReturnUnit) : 0;
                    Decimal openingOrdernetsalesAnda =  blItem.Proposed_Net_Sales_Direct__c != null &&  blItem.Proposed_Net_Sales_Direct__c != 0 ?  blItem.Proposed_Net_Sales_Direct__c :0;
                    blItem.Proposed_Net_Sales_Indirect__c = openingOrdernetsalesAnda > 0 ?  openingOrdernetsalesAnda - openingorderAnda * throughputCost : 0;
                    Decimal openingorderAndatptdl = blItem.Proposed_Net_Sales_Indirect__c != null && blItem.Proposed_Net_Sales_Indirect__c != 0 ? blItem.Proposed_Net_Sales_Indirect__c : 0;
                    blItem.Phoenix_Reduc_in_NCP_McK_And_RAD__c = (openingorderAndatptdl > 0 && openingOrdernetsalesAnda > 0) ? (openingorderAndatptdl / openingOrdernetsalesAnda) * 100 : 0;
                    Decimal openingOrderWholesaler = blItem.Phoenix_Current_Anda_Net_Model_Units__c !=  null && blItem.Phoenix_Current_Anda_Net_Model_Units__c != 0 ? blItem.Phoenix_Current_Anda_Net_Model_Units__c : 0;
                    Decimal wholesalerIODOverAmount = blItem.Phoenix_Wholesaler_IOD_overall_amount__c != null && blItem.Phoenix_Wholesaler_IOD_overall_amount__c != 0 ? blItem.Phoenix_Wholesaler_IOD_overall_amount__c : 0;
                    blItem.Phoenix_WMT_Indirect_Net_Sales__c = wholesalerDeadnet > 0 && openingOrderWholesaler > 0 ? (openingOrderWholesaler * wholesalerDeadnet) - wholesalerIODOverAmount - (openingOrderWholesaler * MediReturnUnit):0; 
                    Decimal openingOrderNetSalesWholesaler = blItem.Phoenix_WMT_Indirect_Net_Sales__c != null && blItem.Phoenix_WMT_Indirect_Net_Sales__c != 0 ? blItem.Phoenix_WMT_Indirect_Net_Sales__c : 0;
					blItem.Phoenix_Costco_TPT__c =   openingOrderNetSalesWholesaler > 0 ? openingOrderNetSalesWholesaler - (openingOrderWholesaler * throughputCost) : 0;               
                    Decimal openingorderWholesalertptdl= blItem.Phoenix_Costco_TPT__c != null && blItem.Phoenix_Costco_TPT__c !=0 ?blItem.Phoenix_Costco_TPT__c :0;
                    blItem.Phoenix_Costco_TPTPer__c = (openingorderWholesalertptdl > 0 && openingOrderNetSalesWholesaler > 0) ? (openingorderWholesalertptdl /openingOrderNetSalesWholesaler)*100 : 0;
                    /* End New ProductLaunch*/
                    /*Decimal finalcurWholesalerUnits =  blItem.Phoenix_Proposed_Smith_Drug_Units__c != null ? blItem.Phoenix_Proposed_Smith_Drug_Units__c : blItem.Phoenix_Current_Wholesaler_Units__c != null ? blItem.Phoenix_Current_Wholesaler_Units__c:0;
Decimal finalAndaUnits =  blItem.Phoenix_Proposed_Anda_Units__c != null ? blItem.Phoenix_Proposed_Anda_Units__c : blItem.Phoenix_Current_Anda_Units__c != null ? blItem.Phoenix_Current_Anda_Units__c:0;
Decimal finalRetailDirect =  blItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c != null ? blItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c : blItem.Phoenix_Current_Retail_Direct_Units__c != null ? blItem.Phoenix_Current_Retail_Direct_Units__c:0;
Decimal finalRetailIndirect =  blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c != null ? blItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c : blItem.Phoenix_Current_Retail_Indirect_Units__c != null ? blItem.Phoenix_Current_Retail_Indirect_Units__c:0;
if(finalcurWholesalerUnits > finalAndaUnits && finalcurWholesalerUnits > finalRetailDirect && finalcurWholesalerUnits > finalRetailIndirect){
blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Wholesaler_DRL_Net_Price__c;
blItem.Phoenix_Proposed_Sales__c =  (blItem.Phoenix_Wholesaler_DRL_Net_Price__c != null ? blItem.Phoenix_Wholesaler_DRL_Net_Price__c : 0)*(finalIndirectUnits+finalDirectUnits);
}else if(finalcurWholesalerUnits < finalAndaUnits && finalAndaUnits > finalRetailDirect && finalAndaUnits > finalRetailIndirect){
blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Anda_DRL_Net_price__c;
blItem.Phoenix_Proposed_Sales__c =  (blItem.Phoenix_Anda_DRL_Net_price__c != null ? blItem.Phoenix_Anda_DRL_Net_price__c : 0)*(finalIndirectUnits+finalDirectUnits);
}else if(finalcurWholesalerUnits < finalRetailIndirect && finalRetailIndirect > finalRetailDirect && finalAndaUnits < finalRetailIndirect){
blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Indirect_Dead_Net__c;
blItem.Phoenix_Proposed_Sales__c =  (blItem.Phoenix_Indirect_Dead_Net__c != null ? blItem.Phoenix_Indirect_Dead_Net__c : 0)*(finalIndirectUnits+finalDirectUnits);
}
else{
blItem.Phoenix_Internal_Dead_Net_Price__c = blItem.Phoenix_Direct_Dead_Net__c;
blItem.Phoenix_Proposed_Sales__c =  (blItem.Phoenix_Direct_Dead_Net__c != null ? blItem.Phoenix_Direct_Dead_Net__c : 0)*(finalIndirectUnits+finalDirectUnits);
}*/
                }
                Catch(Exception e) {
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_BidLineItemTrigger', Phoenix_Method_Name__c = '', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                    insert exp;
                }
                
            }
        }
        
    }
    
    
    
    
}