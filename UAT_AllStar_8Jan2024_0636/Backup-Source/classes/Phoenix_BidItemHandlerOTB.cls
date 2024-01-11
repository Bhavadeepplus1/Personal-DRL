public class Phoenix_BidItemHandlerOTB extends TriggerHandler {
    private list < Phoenix_Bid_Line_Item__c > triggerNew;
    private list < Phoenix_Bid_Line_Item__c > triggerOld;
    private Map < Id, Phoenix_Bid_Line_Item__c > newMap;
    private Map < Id, Phoenix_Bid_Line_Item__c > oldMap;
    
    public Phoenix_BidItemHandlerOTB() {
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
        
        Phoenix_Bid__c bidRec = [SELECT Id,Phoenix_OTB_Direct_Indirect__c,Phoenix_Customer_Type__c, Phoenix_Customer__r.Phoenix_Rebates__c,Phoenix_Customer__r.Phoenix_Cash_Discount__c ,
                                 Phoenix_Customer__r.Phoenix_Fee__c,Phoenix_Customer__r.Phoenix_CM_Fees__c,Phoenix_Bid_Proposed_Position__c, 
                                 Phoenix_Approval_Status__c,Phoenix_Proposed_Cash_Terms__c,Phoenix_Initial_Order_Discount_Type__c, Phoenix_Custom_type__c, 
                                 Phoenix_Current_CD__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Initial_Order_Discount_of_Days__c, 
                                 Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Bid_Type__c 
                                 FROM Phoenix_Bid__c 
                                 WHERE Id =: triggerNew[0].Phoenix_Bid__c];
        String bidType = bidRec.Phoenix_Bid_Type__c;
        
        Decimal initialOrderDays = bidRec.Phoenix_Initial_Order_Discount_of_Days__c != null? bidRec.Phoenix_Initial_Order_Discount_of_Days__c : 0 ;
        
        Decimal initialOrderDisc=bidRec.Phoenix_Proposed_Initial_Order_Discount__c != null? bidRec.Phoenix_Proposed_Initial_Order_Discount__c : 0 ;
        for (Phoenix_Bid_Line_Item__c blItem: triggerNew) {
            /*
//---------OTB  Calculations START----------- 

if (bidRec.Phoenix_Bid_Type__c == 'Short Dated OTB' || bidRec.Phoenix_Bid_Type__c == 'Good Dated OTB') {


//   Proposed Selling Units related variables--START----

Decimal finalDirectUnits = 0, finalIndirectUnits = 0;
if (blItem.Phoenix_SCM_Final_Approval__c == true) {
finalDirectUnits = blItem.Phoenix_Final_Direct_Selling_Units_Calc__c;
} else {
blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = 
(blItem.Phoenix_Proposed_Direct_Selling_Unit__c != 0 && blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null) ?
blItem.Phoenix_Proposed_Direct_Selling_Unit__c : (finalDirectUnits != 0) ?
finalDirectUnits : blItem.Phoenix_Current_Direct_Selling_Unit__c != null ?
blItem.Phoenix_Current_Direct_Selling_Unit__c : 0;
finalDirectUnits = blItem.Phoenix_Final_Direct_Selling_Units_Calc__c;
}
if (blItem.Phoenix_SCM_Final_Approval__c == true) {
finalIndirectUnits = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
} else {
blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != 0 && blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null) ?
blItem.Phoenix_Proposed_Indirect_Selling_Unit__c : (finalIndirectUnits != 0) ?
finalIndirectUnits : blItem.Phoenix_Current_Indirect_Selling_Unit__c != null ?
blItem.Phoenix_Current_Indirect_Selling_Unit__c : 0;
finalIndirectUnits = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
}

//   Proposed Selling Units related variables--END----.setscale(2)
Decimal proDirContrBidPrice1 = blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c!=null?blItem.Phoenix_ProposedContract_Bid_Price_Sales__c:0;
Decimal proIndirContrBidPrice2 = blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != null ? blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c : blItem.Phoenix_Wholesaler_Sales_Price__c!=null?blItem.Phoenix_Wholesaler_Sales_Price__c:0;
Decimal proDirContrBidPrice=0;
Decimal proIndirContrBidPrice=0;
Decimal internalDeadNet;
Decimal netSalesInternal;
Decimal medicaidReturns=(blItem.Phoenix_Estimated_Medicaid_Returns__c).setscale(2);

if (proDirContrBidPrice1 > 0) {
proDirContrBidPrice=proDirContrBidPrice1.setscale(2);
}
if (proIndirContrBidPrice2 > 0) {
proIndirContrBidPrice=proIndirContrBidPrice2.setscale(2);    
}
if (proDirContrBidPrice > 0) {
if(blItem.Phoenix_Proposed_Current_Rebate__c==null)
blItem.Phoenix_Proposed_Current_Rebate__c=0;
blItem.Phoenix_Net_Price_after_Rebates_Terms__c = (proDirContrBidPrice * blItem.Phoenix_Proposed_Current_Rebate__c)/100;
System.debug('---------proDirContrBidPrice----------'+proDirContrBidPrice);
System.debug('---------bidRecord.Phoenix_Proposed_Cash_Terms__c----------'+bidRec.Phoenix_Proposed_Cash_Terms__c);
blItem.Phoenix_Direct_CD__c = (proDirContrBidPrice * bidRec.Phoenix_Proposed_Cash_Terms__c)/100;
System.debug('--------blItem.Phoenix_Direct_CD__c---------'+blItem.Phoenix_Direct_CD__c);
blItem.Phoenix_Wholesaler_VIP__c = (proDirContrBidPrice* bidRec.Phoenix_Proposed_Value_Est_VIP__c)/100;
blItem.Phoenix_Direct_Dead_Net__c = proDirContrBidPrice - blItem.Phoenix_Direct_CD__c.setscale(4) - blItem.Phoenix_Net_Price_after_Rebates_Terms__c.setscale(4) - blItem.Phoenix_Proposed_Per_Unit_Rebate__c.setscale(2) - blItem.Phoenix_Wholesaler_VIP__c.setscale(4);
} 
else if (proIndirContrBidPrice >0) {
proDirContrBidPrice = 0;
blItem.Phoenix_Net_Price_after_Rebates_Terms__c = (proIndirContrBidPrice * blItem.Phoenix_Proposed_Current_Rebate__c)/100;
blItem.Phoenix_Direct_CD__c = (proIndirContrBidPrice* bidRec.Phoenix_Proposed_Cash_Terms__c)/100;
blItem.Phoenix_Wholesaler_VIP__c =(proIndirContrBidPrice* bidRec.Phoenix_Proposed_Value_Est_VIP__c)/100;
//  blItem.Phoenix_Direct_Dead_Net__c = proDirContrBidPrice - blItem.Phoenix_Direct_CD__c.setscale(4) - blItem.Phoenix_Net_Price_after_Rebates_Terms__c.setscale(4) - blItem.Phoenix_Proposed_Per_Unit_Rebate__c.setscale(2) - blItem.Phoenix_Wholesaler_VIP__c.setscale(2);
blItem.Phoenix_Direct_Dead_Net__c = 0;

}
else{
blItem.Phoenix_Net_Price_after_Rebates_Terms__c = 0;
//blItem.Phoenix_Direct_CD__c = (blItem.Phoenix_WAC__c* bidRec.Phoenix_Proposed_Cash_Terms__c)/100;
blItem.Phoenix_Direct_CD__c=((blItem.Phoenix_WAC__c != null ? blItem.Phoenix_WAC__c : 0)* (bidRec.Phoenix_Proposed_Cash_Terms__c != null ? bidRec.Phoenix_Proposed_Cash_Terms__c : 0))/100; //by Sai Krishna
blItem.Phoenix_Wholesaler_VIP__c =0;
blItem.Phoenix_Direct_Dead_Net__c =0;
}

if (blItem.Phoenix_Direct_Dead_Net__c > 0) {
//  blItem.Phoenix_Direct_TP_In__c=0; //This is Formula in the salesforce
//  blItem.Phoenix_Direct_TP__c=0; //This is Formula in the salesforce
blItem.Proposed_Net_Sales_Direct__c = ((blItem.Phoenix_Direct_Dead_Net__c.setscale(4) * finalDirectUnits) - (finalDirectUnits * medicaidReturns)).setscale(2);
} else {
blItem.Proposed_Net_Sales_Direct__c = 0;
}

// blItem.Phoenix_RDC_NLC_Per_Unit_in__c  = blItem.Phoenix_WAC__c*0.01;//This is Formula in the salesforce

if (blItem.Proposed_Net_Sales_Direct__c > 0) {
blItem.Proposed_TPT_Direct__c = blItem.Proposed_Net_Sales_Direct__c.setscale(2) - (finalDirectUnits * blItem.Phoenix_Throughput_cost__c);
blItem.Proposed_TPT_Per_Direct__c = (blItem.Proposed_TPT_Direct__c.setscale(2) / blItem.Proposed_Net_Sales_Direct__c.setscale(2))*100;
} else {
blItem.Proposed_TPT_Direct__c = 0;
blItem.Proposed_TPT_Per_Direct__c = 0;
}
decimal cmfee=blItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c!=null?blItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c:0;
if (proIndirContrBidPrice > 0) {
blItem.Phoenix_Contract_Mngmnt_Fee_Wholesaler__c = (proIndirContrBidPrice * cmfee)/100;
}
else{
blItem.Phoenix_Contract_Mngmnt_Fee_Wholesaler__c = (proDirContrBidPrice * cmfee)/100;

}
if (proIndirContrBidPrice > 0) {
blItem.Phoenix_Indirect_Dead_Net__c = proIndirContrBidPrice - blItem.Phoenix_Direct_CD__c.setscale(4) - blItem.Phoenix_RDC_NLC_Per_Unit_in__c - blItem.Phoenix_Contract_Mngmnt_Fee_Wholesaler__c.setscale(4) - blItem.Phoenix_Proposed_Per_Unit_Rebate__c.setscale(2) - blItem.Phoenix_Net_Price_after_Rebates_Terms__c - blItem.Phoenix_Wholesaler_VIP__c.setscale(4);
} else {
blItem.Phoenix_Indirect_Dead_Net__c = 0;
}

if (blItem.Phoenix_Indirect_Dead_Net__c > 0){
blItem.Proposed_Net_Sales_Indirect__c = ((blItem.Phoenix_Indirect_Dead_Net__c.setscale(4) * finalIndirectUnits) - (medicaidReturns * finalIndirectUnits)).setscale(2);
//Setting up Internal Dead Net Price for all the view to work 
internalDeadNet=blItem.Phoenix_Indirect_Dead_Net__c;
}
else {
blItem.Proposed_Net_Sales_Indirect__c = 0;
internalDeadNet=blItem.Phoenix_Direct_Dead_Net__c.setscale(4);
}
// blItem.Indirect_TP__c=0;// This is Formula in the salesforce
// blItem.Phoenix_Indirect_TP__c=0;//This is Formula in the salesforce
if (blItem.Proposed_Net_Sales_Indirect__c > 0){
blItem.Proposed_TPT_Indirect__c = blItem.Proposed_Net_Sales_Indirect__c.setscale(2) - (blItem.Phoenix_Throughput_cost__c * finalIndirectUnits);
//Setting up Net Sales Internal for all the view to work
netSalesInternal =blItem.Proposed_Net_Sales_Indirect__c.setscale(2);
}
else {
blItem.Proposed_TPT_Indirect__c = 0;
netSalesInternal =blItem.Proposed_Net_Sales_Direct__c.setscale(2);
}
if (blItem.Proposed_TPT_Indirect__c > 0)
blItem.Proposed_TPT_Per_Indirect__c = (blItem.Proposed_TPT_Indirect__c.setscale(2) / blItem.Proposed_Net_Sales_Indirect__c.setscale(2))*100;
else {
blItem.Proposed_TPT_Per_Indirect__c = 0;
}

blItem.Phoenix_Internal_Dead_Net_Price__c =internalDeadNet;  
blItem.Phoenix_Net_Sales_Internal__c =netSalesInternal;
if (proIndirContrBidPrice > 0) {
blItem.Phoenix_Proposed_Sales__c = (blItem.Phoenix_Internal_Dead_Net_Price__c != null ? blItem.Phoenix_Internal_Dead_Net_Price__c : 0)*(finalIndirectUnits); 
}
else if (proDirContrBidPrice > 0) {
blItem.Phoenix_Proposed_Sales__c = (blItem.Phoenix_Internal_Dead_Net_Price__c != null ? blItem.Phoenix_Internal_Dead_Net_Price__c : 0)*(finalDirectUnits); 
}
else{
blItem.Phoenix_Proposed_Sales__c =0; 

}

}

//----------OTB  Calculations END------------ 

*/
            
            if (bidRec.Phoenix_Bid_Type__c == 'Platform OTB' || bidRec.Phoenix_Bid_Type__c == 'Short Dated OTB' || bidRec.Phoenix_Bid_Type__c == 'Good Dated OTB' || bidRec.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch') {
                
                try { 
                    //   Proposed Selling Units related variables--START----
                    string dirORindirect=bidRec.Phoenix_OTB_Direct_Indirect__c;
                    Decimal finalDirectUnits = 0, finalIndirectUnits = 0;
                    if(dirORindirect == 'Direct'){
                        if (blItem.Phoenix_SCM_Final_Approval__c == true) {
                            finalDirectUnits = (blItem.Phoenix_Total_SCM_Approved_Qty__c != null ? blItem.Phoenix_Total_SCM_Approved_Qty__c :0); //blItem.Phoenix_Final_Direct_Selling_Units_Calc__c;
                             blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = finalDirectUnits;
                            blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = 0;
                        
                        } else {
                            blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = 
                                (blItem.Phoenix_Proposed_Direct_Selling_Unit__c != 0 && blItem.Phoenix_Proposed_Direct_Selling_Unit__c != null) ?
                                blItem.Phoenix_Proposed_Direct_Selling_Unit__c : (finalDirectUnits != 0) ?
                                    finalDirectUnits : blItem.Phoenix_Current_Direct_Selling_Unit__c != null ?
                                        blItem.Phoenix_Current_Direct_Selling_Unit__c : 0;
                            finalDirectUnits = blItem.Phoenix_Final_Direct_Selling_Units_Calc__c;
                        }
                    }
                    else{
                        if (blItem.Phoenix_SCM_Final_Approval__c == true) {
                            finalIndirectUnits = (blItem.Phoenix_Total_SCM_Approved_Qty__c != null ? blItem.Phoenix_Total_SCM_Approved_Qty__c :0);//blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                             blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c =  finalIndirectUnits; 
                            blItem.Phoenix_Final_Direct_Selling_Units_Calc__c = 0;
                        
                        } else {
                            blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = (blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != 0 && blItem.Phoenix_Proposed_Indirect_Selling_Unit__c != null) ?
                                blItem.Phoenix_Proposed_Indirect_Selling_Unit__c : (finalIndirectUnits != 0) ?
                                    finalIndirectUnits : blItem.Phoenix_Current_Indirect_Selling_Unit__c != null ?
                                        blItem.Phoenix_Current_Indirect_Selling_Unit__c : 0;
                            finalIndirectUnits = blItem.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                        }
                    }
                    
                    //   Proposed Selling Units related variables--END----.setscale(2)
                    Decimal proDirContrBidPrice1 = blItem.Phoenix_ProposedContractBidPriceMktng__c != null ? blItem.Phoenix_ProposedContractBidPriceMktng__c : blItem.Phoenix_ProposedContract_Bid_Price_Sales__c !=null? blItem.Phoenix_ProposedContract_Bid_Price_Sales__c:0;
                    Decimal proIndirContrBidPrice2 = blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != null ? blItem.Phoenix_Wholesaler_Diff_Price_Indirect__c : blItem.Phoenix_Wholesaler_Sales_Price__c !=null? blItem.Phoenix_Wholesaler_Sales_Price__c:0;
                    Decimal proDirContrBidPrice=0;
                    Decimal proIndirContrBidPrice=0;
                    Decimal internalDeadNet;
                    Decimal netSalesInternal;
                    Decimal medicaidReturns= blItem.Phoenix_Estimated_Medicaid_Returns__c;
                    
                    //by sai krishna on 07/08/2021
                    bidRec.Phoenix_Proposed_Cash_Terms__c = bidRec.Phoenix_Proposed_Cash_Terms__c != null ? bidRec.Phoenix_Proposed_Cash_Terms__c:0;
                    bidRec.Phoenix_Proposed_Value_Est_VIP__c = bidRec.Phoenix_Proposed_Value_Est_VIP__c != null ? bidRec.Phoenix_Proposed_Value_Est_VIP__c:0;
                    blItem.Phoenix_Net_Price_after_Rebates_Terms__c = blItem.Phoenix_Net_Price_after_Rebates_Terms__c != null ? blItem.Phoenix_Net_Price_after_Rebates_Terms__c:0;
                    //bidRec.Phoenix_Proposed_Value_Est_VIP__c = bidRec.Phoenix_Proposed_Value_Est_VIP__c != null ? bidRec.Phoenix_Proposed_Value_Est_VIP__c:0;
                    blItem.Phoenix_Proposed_Per_Unit_Rebate__c = blItem.Phoenix_Proposed_Per_Unit_Rebate__c != null ? blItem.Phoenix_Proposed_Per_Unit_Rebate__c:0;
                    blItem.Phoenix_Proposed_Current_Rebate__c = blItem.Phoenix_Proposed_Current_Rebate__c != null ? blItem.Phoenix_Proposed_Current_Rebate__c:0;
                    
                    
                    //
                    if (proDirContrBidPrice1 > 0) {
                        proDirContrBidPrice=proDirContrBidPrice1;
                    }
                    if (proIndirContrBidPrice2 > 0) {
                        proIndirContrBidPrice=proIndirContrBidPrice2;    
                    }
                    if (proDirContrBidPrice > 0) {
                        if(blItem.Phoenix_Proposed_Current_Rebate__c==null)
                            blItem.Phoenix_Proposed_Current_Rebate__c=0;
                        blItem.Phoenix_Net_Price_after_Rebates_Terms__c = (proDirContrBidPrice * blItem.Phoenix_Proposed_Current_Rebate__c)/100;
                        System.debug('---------proDirContrBidPrice----------'+proDirContrBidPrice);
                        System.debug('---------bidRecord.Phoenix_Proposed_Cash_Terms__c----------'+bidRec.Phoenix_Proposed_Cash_Terms__c);
                        blItem.Phoenix_Direct_CD__c = (proDirContrBidPrice * bidRec.Phoenix_Proposed_Cash_Terms__c)/100;
                        System.debug('--------blItem.Phoenix_Direct_CD__c---------'+blItem.Phoenix_Direct_CD__c);
                        blItem.Phoenix_Wholesaler_VIP__c = (proDirContrBidPrice* bidRec.Phoenix_Proposed_Value_Est_VIP__c)/100;
                        blItem.Phoenix_Direct_Dead_Net__c = proDirContrBidPrice - blItem.Phoenix_Direct_CD__c.setscale(4) - blItem.Phoenix_Net_Price_after_Rebates_Terms__c.setscale(4) - blItem.Phoenix_Proposed_Per_Unit_Rebate__c.setscale(2) - blItem.Phoenix_Wholesaler_VIP__c.setscale(4);
                    } 
                    else if (proIndirContrBidPrice >0) {
                        proDirContrBidPrice = 0;
                        blItem.Phoenix_Net_Price_after_Rebates_Terms__c = (proIndirContrBidPrice * blItem.Phoenix_Proposed_Current_Rebate__c)/100;
                        if(bidRec.Phoenix_Bid_Type__c == 'Platform OTB'){
                        blItem.Phoenix_Direct_CD__c = (proIndirContrBidPrice* bidRec.Phoenix_Proposed_Cash_Terms__c)/100;
                        }
                        blItem.Phoenix_Wholesaler_VIP__c =(proIndirContrBidPrice* bidRec.Phoenix_Proposed_Value_Est_VIP__c)/100;
                        //  blItem.Phoenix_Direct_Dead_Net__c = proDirContrBidPrice - blItem.Phoenix_Direct_CD__c.setscale(4) - blItem.Phoenix_Net_Price_after_Rebates_Terms__c.setscale(4) - blItem.Phoenix_Proposed_Per_Unit_Rebate__c.setscale(2) - blItem.Phoenix_Wholesaler_VIP__c.setscale(2);
                     
                            blItem.Phoenix_Direct_Dead_Net__c = 0;
                        
                    }
                    else{
                        blItem.Phoenix_Net_Price_after_Rebates_Terms__c = 0;
                        //blItem.Phoenix_Direct_CD__c = (blItem.Phoenix_WAC__c* bidRec.Phoenix_Proposed_Cash_Terms__c)/100;
                        if(dirORindirect == 'Indirect'){
                            blItem.Phoenix_Direct_CD__c=((blItem.Phoenix_WAC__c != null ? blItem.Phoenix_WAC__c : 0)* (bidRec.Phoenix_Proposed_Cash_Terms__c != null ? bidRec.Phoenix_Proposed_Cash_Terms__c : 0))/100; //by Sai Krishna
                        }
                        else{
                            blItem.Phoenix_Direct_CD__c = (proDirContrBidPrice * bidRec.Phoenix_Proposed_Cash_Terms__c)/100;
                            
                        }
                        blItem.Phoenix_Wholesaler_VIP__c =0;
                        blItem.Phoenix_Direct_Dead_Net__c =0;
                    }
                    
                    if (blItem.Phoenix_Direct_Dead_Net__c != null && blItem.Phoenix_Direct_Dead_Net__c > 0) {
                        //  blItem.Phoenix_Direct_TP_In__c=0; //This is Formula in the salesforce
                        //  blItem.Phoenix_Direct_TP__c=0; //This is Formula in the salesforce
                        blItem.Proposed_Net_Sales_Direct__c = ((blItem.Phoenix_Direct_Dead_Net__c.setscale(4) *
                                                                finalDirectUnits) - (finalDirectUnits
                                                                                     * medicaidReturns
                                                                                    ));
                    } else {
                        blItem.Proposed_Net_Sales_Direct__c = 0;
                    }
                    
                    // blItem.Phoenix_RDC_NLC_Per_Unit_in__c  = blItem.Phoenix_WAC__c*0.01;//This is Formula in the salesforce
                    
                    if (blItem.Proposed_Net_Sales_Direct__c > 0) {
                        blItem.Proposed_TPT_Direct__c = blItem.Proposed_Net_Sales_Direct__c - (finalDirectUnits * blItem.Phoenix_Throughput_cost__c);
                        blItem.Proposed_TPT_Per_Direct__c = (blItem.Proposed_TPT_Direct__c / blItem.Proposed_Net_Sales_Direct__c)*100;
                    } else {
                        blItem.Proposed_TPT_Direct__c = 0;
                        blItem.Proposed_TPT_Per_Direct__c = 0;
                    }
                    decimal cmfee=blItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c!=null?blItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c:0;
                    if (proIndirContrBidPrice > 0) {
                        blItem.Phoenix_Contract_Mngmnt_Fee_Wholesaler__c = (proIndirContrBidPrice * cmfee)/100;
                    }
                    else{
                        //blItem.Phoenix_Contract_Mngmnt_Fee_Wholesaler__c = (proDirContrBidPrice * cmfee)/100;
                        
                    }
                    //if(bidRec.Phoenix_OTB_Direct_Indirect__c == 'Direct'){
                    //blItem.Phoenix_Contract_Mngmnt_Fee_Wholesaler__c = 0;
                    
                    //}
                    if (proIndirContrBidPrice > 0) {
                        blItem.Phoenix_Indirect_Dead_Net__c = proIndirContrBidPrice - blItem.Phoenix_Direct_CD__c.setscale(4) - blItem.Phoenix_RDC_NLC_Per_Unit_in__c - blItem.Phoenix_Contract_Mngmnt_Fee_Wholesaler__c.setscale(4) - blItem.Phoenix_Proposed_Per_Unit_Rebate__c.setscale(2) - blItem.Phoenix_Net_Price_after_Rebates_Terms__c - blItem.Phoenix_Wholesaler_VIP__c.setscale(4);
                    } else {
                        blItem.Phoenix_Indirect_Dead_Net__c = 0;
                    }
                    
                    if (blItem.Phoenix_Indirect_Dead_Net__c > 0){
                        blItem.Proposed_Net_Sales_Indirect__c = ((blItem.Phoenix_Indirect_Dead_Net__c.setscale(4) * finalIndirectUnits) - (medicaidReturns * finalIndirectUnits));
                        //Setting up Internal Dead Net Price for all the view to work 
                        internalDeadNet=blItem.Phoenix_Indirect_Dead_Net__c;
                    }
                    else {
                        blItem.Proposed_Net_Sales_Indirect__c = 0;
                        internalDeadNet=blItem.Phoenix_Direct_Dead_Net__c.setscale(4);
                    }
                    // blItem.Indirect_TP__c=0;// This is Formula in the salesforce
                    // blItem.Phoenix_Indirect_TP__c=0;//This is Formula in the salesforce
                    if (blItem.Proposed_Net_Sales_Indirect__c > 0){
                        blItem.Proposed_TPT_Indirect__c = blItem.Proposed_Net_Sales_Indirect__c - (blItem.Phoenix_Throughput_cost__c * finalIndirectUnits);
                        //Setting up Net Sales Internal for all the view to work
                        netSalesInternal =blItem.Proposed_Net_Sales_Indirect__c;
                    }
                    else {                        blItem.Proposed_TPT_Indirect__c = 0;                        netSalesInternal =blItem.Proposed_Net_Sales_Direct__c;
                    }
                    if (blItem.Proposed_TPT_Indirect__c > 0)                        blItem.Proposed_TPT_Per_Indirect__c = (blItem.Proposed_TPT_Indirect__c / blItem.Proposed_Net_Sales_Indirect__c)*100;
                    else {                        blItem.Proposed_TPT_Per_Indirect__c = 0;
                    }
                    
                    blItem.Phoenix_Internal_Dead_Net_Price__c =internalDeadNet;  
                    blItem.Phoenix_Net_Sales_Internal__c =netSalesInternal;
                    if (proIndirContrBidPrice > 0) {                        blItem.Phoenix_Proposed_Sales__c = (blItem.Phoenix_Internal_Dead_Net_Price__c != null ? blItem.Phoenix_Internal_Dead_Net_Price__c : 0)*(finalIndirectUnits); 
                    }
                    else if (proDirContrBidPrice > 0) {                        blItem.Phoenix_Proposed_Sales__c = (blItem.Phoenix_Internal_Dead_Net_Price__c != null ? blItem.Phoenix_Internal_Dead_Net_Price__c : 0)*(finalDirectUnits); 
                    }
                    else{                        blItem.Phoenix_Proposed_Sales__c =0; 
                        
                    }
                    //by sk
                    if(blItem.Phoenix_Direct_Dead_Net__c == null || blItem.Phoenix_Direct_Dead_Net__c < 0){                 blItem.Phoenix_Direct_Dead_Net__c = 0;}
                   if(blItem.Phoenix_Indirect_Dead_Net__c == null || blItem.Phoenix_Indirect_Dead_Net__c < 0){                      blItem.Phoenix_Indirect_Dead_Net__c = 0;
                    }
                                        //Added By Srimayee for Approval status of bid line item 
                    
                    if(bidRec.Phoenix_Approval_Status__c != 'Draft' &&  bidRec.Phoenix_Approval_Status__c != 'Closed' && bidRec.Phoenix_Approval_Status__c != 'Closed-Draft' && bidRec.Phoenix_Approval_Status__c != 'On Hold' && blItem.Phoenix_Final_Status__c != 'Not Approved'){blItem.Phoenix_Bid_Line_Item_Approval_Status__c = bidRec.Phoenix_Approval_Status__c + ' Pending';
                                                                                                                                                                          }
                    if(blItem.Phoenix_SCM_Approval_Y_N__c == 'N- Not Approved' && blItem.Phoenix_Final_Status__c == 'Not Approved'){blItem.Phoenix_Bid_Line_Item_Approval_Status__c = 'SCM Rejected';
                                                                                                                                   }
                    if(blItem.Phoenix_Marketing_Approval__c == 'Not Approved' && blItem.Phoenix_Final_Status__c == 'Not Approved'){blItem.Phoenix_Bid_Line_Item_Approval_Status__c = 'Marketing Rejected';
                                                                                                                                  }
                    if(blItem.Phoenix_Approval__c == 'Not Approved' && blItem.Phoenix_Final_Status__c == 'Not Approved'){ blItem.Phoenix_Bid_Line_Item_Approval_Status__c = 'Management Rejected';
                    }
                  
                    if(blItem.Phoenix_Contract_Approval__c == 'Line Error- Not Sent' && blItem.Phoenix_Final_Status__c == 'Not Approved'){blItem.Phoenix_Bid_Line_Item_Approval_Status__c = 'Contracts Rejected';
                       system.debug('Inside Loop');                                                                                                          }
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
                }
                
                
                Catch(Exception e) {
                    Phoenix_Bright_Exceptions__c exp;
                    exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_BidLineItemTrigger', Phoenix_Method_Name__c = '', Phoenix_Error_Message__c = e.getMessage(),Phoenix_Issue_Status__c = 'Pending',Phoenix_Occurrence_Time__c = System.now(),Phoenix_Stack_Trace__c = e.getStackTraceString(),Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
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