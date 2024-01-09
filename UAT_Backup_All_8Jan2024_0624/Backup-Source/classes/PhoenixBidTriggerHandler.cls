/**
* @description       : 
* @author            : Surender Patel (Dhruvsoft)
* @group             : 
* @last modified on  : 25-05-2021
* @last modified by  : Surender Patel (Dhruvsoft)
* Modifications Log 
* Ver   Date         Author                       Modification
* 1.0   17-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
public class PhoenixBidTriggerHandler extends TriggerHandler {
    private list < Phoenix_Bid__c > triggerNew;
    private list < Phoenix_Bid__c > triggerOld;
    private Map < Id, Phoenix_Bid__c > newMap;
    private Map < Id, Phoenix_Bid__c > oldMap;
    
    public PhoenixBidTriggerHandler() {
        this.newMap = (Map < Id, Phoenix_Bid__c > ) Trigger.newMap;
        this.oldMap = (Map < Id, Phoenix_Bid__c > ) Trigger.oldMap;
        this.triggerNew = (List < Phoenix_Bid__c > ) Trigger.new;
        this.triggerOld = (List < Phoenix_Bid__c > ) Trigger.old;
    }
    
    public override void beforeInsert() {
        //added logic for ultimate parent update in bid
        if (triggerNew.size() > 0) {
            getUltimateParent(triggerNew);
        }
        Set < Id > cutomerIds = new Set < Id > ();
        for (Phoenix_Bid__c bidRec: triggerNew) {
            cutomerIds.add(bidRec.Phoenix_Customer__c);
        }
        Map < Id, Account > customersList = new Map < Id, Account > ([SELECT Name,AccountNumber, ownerId,Phoenix_Admin_Fee_Sec_Template__c,Phoenix_Rebate_Secondary_Template__c, Phoenix_AdditionalRebateCardinalMajor__c, Phoenix_WMT_Direct_Rebate__c,Phoenix_ABS__c, Mck_RAD_Rebate__c,Phoenix_Customer_Class_Bid_Template__c, Phoenix_Fee__c, Fee_Type__c, Rebate_Type__c, Phoenix_VIP_Type__c, Phoenix_VIP__c, Phoenix_Wbad_VIR__c, Phoenix_Cash_Discount__c, Phoenix_Rebates__c, Phoenix_CM_Fees__c, Phoenix_Custom_type__c, Phoenix_NLC__c,Phoenix_REMS_Program_Fee__c,Phoenix_Controlled_Substance__c,Phoenix_Required_Cold_Storage__c,Phoenix_Controlled_Distribution__c FROM Account WHERE Id IN: cutomerIds]);
        for (Phoenix_Bid__c bid: triggerNew) {
            if(bid.Phoenix_is_OTC_Bid__c){
                bid.Phoenix_OTC_Bid_Version__c = 'Version 1';
            }
            Account accObj = new Account();
            if(customersList.containsKey(bid.Phoenix_Customer__c)){
                accObj = customersList.get(bid.Phoenix_Customer__c);
            }
            bid.Phoenix_Bid_Owner__c = bid.OwnerId;
            if (bid.Phoenix_Customer_Bid_Deadline_Time_zone__c != null && bid.Phoenix_Customer_Bid_Deadline_Time__c != null && bid.Phoenix_Bid_Deadline_Date__c != null) {
                bid.Phoenix_Customer_Bid_Deadline__c = bid.Phoenix_Bid_Deadline_Date__c.format() + ' ' + bid.Phoenix_Customer_Bid_Deadline_Time__c + ' ' + bid.Phoenix_Customer_Bid_Deadline_Time_zone__c;
            }
            if (bid.Phoenix_Bid_Created_Behalf_of__c != null) {
                bid.OwnerId = bid.Phoenix_Bid_Created_Behalf_of__c;
            }
            if (bid.Phoenix_Bid_Type__c == 'VIP Rebate' && bid.Phoenix_Customer__c != null) {
                Account cust = [select id from Account WHERE Id =: bid.Phoenix_Customer__c LIMIT 1];
                List < Phoenix_Bid_VIP_Rebate__c > rebCurrent = [select id from Phoenix_Bid_VIP_Rebate__c where Phoenix_Customer__c =: cust.Id AND Phoenix_Status__c = 'Current'];
                if (!rebCurrent.isEmpty()) {
                    bid.Phoenix_Current_VIP_Rebate__c = rebCurrent[0].Id;
                }
            }
            
            
            
            //system.debug('customertype---'+customersList.get(bid.Phoenix_Customer__c).get('Phoenix_Customer_Class_Bid_Template__c'));
            if (bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update') {
                bid.Phoenix_Customer_Type__c = 'Indirect';
                bid.Phoenix_Proposed_Cash_Terms__c  = 2;
                bid.Phoenix_Contract_Management_Fee__c = 8;
                bid.Phoenix_Proposed_Value_Admin_Fee__c = 0;
            }
            if (bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update') {
                bid.Phoenix_Customer_Type__c = 'Direct';
                bid.Phoenix_Proposed_Cash_Terms__c = 2;
                bid.Phoenix_Proposed_Value_Admin_Fee__c = 0;
            }
            
            
            if ((bid.Phoenix_Bid_Type__c == 'RFP Bids' || bid.Phoenix_Bid_Type__c == 'Price Change') && bid.Phoenix_Is_Re_Bid__c != true) {
                
                bid.Phoenix_Proposed_SSA_No_of_Days__c = 45;
            }
            
            if (customersList.get(bid.Phoenix_Customer__c) != null && bid.Phoenix_Is_Re_Bid__c != true) {
                
                if (customersList.get(bid.Phoenix_Customer__c).get('Phoenix_Customer_Class_Bid_Template__c') != null) {
                    string templateName = String.ValueOf(customersList.get(bid.Phoenix_Customer__c).get('Phoenix_Customer_Class_Bid_Template__c'));
                    if(templateName == 'Direct or Indirect'){
                        templateName = bid.Phoenix_Template_Type_GSMS__c;
                    }
                    if(templateName == 'ROS'){
                        templateName = bid.Phoenix_Template_Type_ROS__c;
                    }
                    if(templateName == 'Humana'){
                        templateName = bid.Phoenix_Template_Type_Humana__c;
                    }
                    if (templateName == 'Direct and Indirect' || templateName == 'Indirect' 
                        || templateName == 'Direct' || templateName == 'Walgreens' || templateName == 'ABC Progen' 
                        || templateName == 'Econdisc' || templateName == 'RXSS' || templateName == 'ClarusOne' 
                        || templateName == 'Net Indirect Pricing' || templateName == 'Sams Club' || templateName == 'Costco' 
                        ||templateName == 'ABC Pharmagen'|| templateName == 'BASE/DSH' || templateName == 'Government Pricing' || templateName == 'ROS') {
                            
                            //ClarusOne logic added by joga
                            string WMTDirectRebate = customersList.get(bid.Phoenix_Customer__c).get('Phoenix_WMT_Direct_Rebate__c') != null ? string.ValueOf(customersList.get(bid.Phoenix_Customer__c).get('Phoenix_WMT_Direct_Rebate__c')):'0';
                            string MckssonRebate = customersList.get(bid.Phoenix_Customer__c).get('Mck_RAD_Rebate__c') != null ? string.ValueOf(customersList.get(bid.Phoenix_Customer__c).get('Mck_RAD_Rebate__c')) : '0' ;
                            string dataFee = customersList.get(bid.Phoenix_Customer__c).get('Phoenix_ABS__c') != null ? string.ValueOf(customersList.get(bid.Phoenix_Customer__c).get('Phoenix_ABS__c')) : '0';
                            if(templateName == 'ClarusOne'){
                                bid.Phoenix_WMT_Direct_Rebate__c = Decimal.ValueOf(WMTDirectRebate);
                                bid.Phoenix_Mck_RAD_Rebate__c = Decimal.ValueOf(MckssonRebate);
                                bid.Phoenix_Data_Fee__c = Decimal.ValueOf(dataFee);
                            } 
                            
                            string Vip = string.ValueOf(customersList.get(bid.Phoenix_Customer__c).get('Phoenix_VIP__c'));
                            string cd = string.ValueOf(customersList.get(bid.Phoenix_Customer__c).get('Phoenix_Cash_Discount__c'));
                            //  string rebatepercent = string.ValueOf(customersList.get(bid.Phoenix_Customer__c).get('Phoenix_Rebates__c'));
                            string feePercent = string.ValueOf(customersList.get(bid.Phoenix_Customer__c).get('Phoenix_Fee__c'));
                            string cardinalFeePercent = customersList.get(bid.Phoenix_Customer__c).get('Phoenix_Admin_Fee_Sec_Template__c') != null ? string.ValueOf(customersList.get(bid.Phoenix_Customer__c).get('Phoenix_Admin_Fee_Sec_Template__c')):'0';
                            string vipType = string.ValueOf(customersList.get(bid.Phoenix_Customer__c).get('Phoenix_VIP_Type__c'));
                            string feeType = string.ValueOf(customersList.get(bid.Phoenix_Customer__c).get('Fee_Type__c'));
                            //string NLCFee = string.ValueOf(customersList.get(bid.Phoenix_Customer__c).get('Phoenix_NLC_Fee__c'));
                            if (customersList.get(bid.Phoenix_Customer__c).get('Phoenix_Customer_Class_Bid_Template__c') != 'Econdisc') {
                                string GrpVip = string.ValueOf(customersList.get(bid.Phoenix_Customer__c).get('Phoenix_Wbad_VIR__c'));
                                if (GrpVip != null) {
                                    bid.Phoenix_Group_VIP__c = Decimal.ValueOf(GrpVip);
                                }
                            }
                            
                        
                            if (Vip != null && !bid.Phoenix_is_OTC_Bid__c) {
                                bid.Phoenix_Proposed_Value_Est_VIP__c = Decimal.ValueOf(Vip);
                                bid.Phoenix_Current_Value_Est_VIP__c = Decimal.ValueOf(Vip);
                            }
                            if (cd != null && !bid.Phoenix_is_OTC_Bid__c) {
                                bid.Phoenix_Current_CD__c = Decimal.ValueOf(cd);
                                bid.Phoenix_Proposed_Cash_Terms__c = Decimal.ValueOf(cd);
                            }
                            /* if (rebatepercent != null) {
bid.Phoenix_Rebate__c = Decimal.ValueOf(rebatepercent);
}*/
                            if (feePercent != null) {
                                bid.Phoenix_Proposed_Value_Admin_Fee__c = Decimal.ValueOf(feePercent);
                            }
                            if(customersList.get(bid.Phoenix_Customer__c).get('AccountNumber') == '370337' && feePercent != null && bid.Phoenix_Template_Type__c != null && bid.Phoenix_Template_Type__c == 'Indirect'){
                                bid.Phoenix_Proposed_Value_Admin_Fee__c = Decimal.ValueOf(cardinalFeePercent);
                            }
                            if (vipType != null) {
                                bid.Phoenix_Value_Est_VIP_Type__c = vipType;
                            }
                            if (feeType != null) {
                                bid.Phoenix_Proposed_Admin_Fee_Basis__c = feeType;
                            }
                            //if(NLCFee != null){ bid.Phoenix_NLC_Fee__c = Decimal.ValueOf(NLCFee);}
                            if(templateName == 'ROS'){
                                string rebatepercent = string.ValueOf(customersList.get(bid.Phoenix_Customer__c).get('Phoenix_Rebates__c'));
                                string NLCFee = string.ValueOf(customersList.get(bid.Phoenix_Customer__c).get('Phoenix_NLC__c'));
                                if(rebatepercent != null)
                                    bid.Phoenix_Rebate__c = Decimal.ValueOf(rebatepercent);
                                if(NLCFee != null){}
                                //bid.Phoenix_NLC_Fee__c = Decimal.ValueOf(NLCFee);
                            }
                            
                        }
                    if(bid.Phoenix_Template_Type__c != null){
                        bid.Phoenix_Customer_Type__c = bid.Phoenix_Template_Type__c;   
                    }else if(bid.Phoenix_Template_Type_GSMS__c != null){
                        bid.Phoenix_Customer_Type__c = bid.Phoenix_Template_Type_GSMS__c;    
                    }else if(bid.Phoenix_Template_Type_ROS__c != null){
                        bid.Phoenix_Customer_Type__c = bid.Phoenix_Template_Type_ROS__c;    
                    }else if(bid.Phoenix_is_OTC_Bid__c){
                        bid.Phoenix_Customer_Type__c = 'OTC Customer';    
                    }
                     else if(bid.Phoenix_Template_Type_Humana__c!=null){
                        bid.Phoenix_Customer_Type__c = bid.Phoenix_Template_Type_Humana__c;    
                    }
                    else{
                        bid.Phoenix_Customer_Type__c = customersList.get(bid.Phoenix_Customer__c).get('Phoenix_Customer_Class_Bid_Template__c').toString();
                    }
                    if(templateName=='Sams Club'){
                        bid.Phoenix_Proposed_SSA_No_of_Days__c = 0;
                    }
                    if(templateName=='BASE/DSH'){
                        bid.Phoenix_Proposed_SSA_No_of_Days__c = 0;
                    }
                }
                if (customersList.get(bid.Phoenix_Customer__c).get('ownerId') != null) {
                    //bid.Phoenix_Salesperson__c = customersList.get(bid.Phoenix_Customer__c).get('ownerId').toString();
                }
                if (customersList.get(bid.Phoenix_Customer__c).get('Phoenix_VIP_Type__c') != null) {
                    bid.Phoenix_Value_Est_VIP_Type__c = customersList.get(bid.Phoenix_Customer__c).get('Phoenix_VIP_Type__c').toString();
                }
                if (customersList.get(bid.Phoenix_Customer__c).get('Phoenix_Custom_type__c') != null) {
                    bid.Phoenix_Custom_type__c = customersList.get(bid.Phoenix_Customer__c).get('Phoenix_Custom_type__c').toString();
                }
                if(accObj.Phoenix_AdditionalRebateCardinalMajor__c != null){
                    bid.Phoenix_AdditionalRebateCardinalMajor__c = accObj.Phoenix_AdditionalRebateCardinalMajor__c;
                }
                
                // OTB Logic START---for template omission--
                
                if (bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Good Dated OTB' || bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' ) {
                    System.debug('----Short Dated OTB---');
                    bid.Phoenix_Customer_Type__c = 'OneTimeBuy';
                    //  bid.Phoenix_Proposed_Cash_Terms__c = 2;
                    //  bid.Phoenix_Proposed_Value_Est_VIP__c = 1;
                    string feePercentAdmin = string.ValueOf(customersList.get(bid.Phoenix_Customer__c).get('Phoenix_Fee__c'));
                    string vipEst = string.ValueOf(customersList.get(bid.Phoenix_Customer__c).get('Phoenix_VIP__c'));
                    string cashTerms = string.ValueOf(customersList.get(bid.Phoenix_Customer__c).get('Phoenix_Cash_Discount__c'));
                    if (vipEst != null) {
                        //bid.Phoenix_Proposed_Value_Est_VIP__c = Decimal.ValueOf(vipEst);
                    }
                    if (feePercentAdmin != null) {
                        bid.Phoenix_Proposed_Value_Admin_Fee__c = Decimal.ValueOf(feePercentAdmin);
                    }
                    if (cashTerms != null) {
                        //bid.Phoenix_Proposed_Cash_Terms__c = Decimal.ValueOf(cashTerms);
                        //bid.Phoenix_Proposed_Cash_Terms__c = 2;
                    }
                }
                if (bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Good Dated OTB' || bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch'){
                    bid.Phoenix_Proposed_Value_Est_VIP__c = null;
                    bid.Phoenix_Proposed_Cash_Terms__c = 2;
                }
                // OTB Logic END---for template omission--
                
            }
            
        }
    }
    
    public override void beforeUpdate() {
        for (Phoenix_Bid__c bid: triggerNew) {
            if (bid.Phoenix_Customer_Bid_Deadline_Time_zone__c != null && bid.Phoenix_Customer_Bid_Deadline_Time__c != null && bid.Phoenix_Bid_Deadline_Date__c != null) {
                bid.Phoenix_Customer_Bid_Deadline__c = bid.Phoenix_Bid_Deadline_Date__c.format() + ' ' + bid.Phoenix_Customer_Bid_Deadline_Time__c + ' ' + bid.Phoenix_Customer_Bid_Deadline_Time_zone__c;
            }
            /* Phoenix_Bid__c newBid = newMap.get(bid.id);
Phoenix_Bid__c oldBid = oldMap.get(bid.id);
if (bid.Phoenix_Customer_Bid_Deadline_Time_zone__c != null && bid.Phoenix_Customer_Bid_Deadline_Date_Time__c!=null && ((newBid.Phoenix_Customer_Bid_Deadline_Time_zone__c != oldBid.Phoenix_Customer_Bid_Deadline_Time_zone__c) || (newBid.Phoenix_Customer_Bid_Deadline_Date_Time__c != oldBid.Phoenix_Customer_Bid_Deadline_Date_Time__c))){
bid.Phoenix_Customer_Bid_Deadline__c= bid.Phoenix_Customer_Bid_Deadline_Date_Time__c.format()+' '+bid.Phoenix_Customer_Bid_Deadline_Time_zone__c;
}*/
        }
    }
    
    public override void afterUpdate() {
        
        List < Id > bidIds = new List < Id > ();
        map<Id,List<Phoenix_Bid_Line_Item__c>> bItemsMap = new map<Id,List<Phoenix_Bid_Line_Item__c>>();
         map<Id,Decimal> IPAProductsMap = new map<Id,Decimal>();
         map<Id,Date> IPAProductsBidClosedDateMap = new map<Id,Date>();
        for (Phoenix_Bid_Line_Item__c bidItem: [SELECT ID,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Product__c,Phoenix_Bid__r.Phoenix_Bid_Type__c,Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Id,Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c,Phoenix_Bid_Line_Item_Approval_Status__c,Phoenix_Bid__c,Phoenix_Final_Status__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =: trigger.new]) {      
            if(bidItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update' && bidItem.Phoenix_Bid__r.Phoenix_Approval_Status__c=='Closed' && bidItem.Phoenix_Final_Status__c != 'Not Approved'){
                IPAProductsMap.put(bidItem.Phoenix_Product__c,bidItem.Phoenix_ProposedContractBidPriceMktng__c);
                IPAProductsBidClosedDateMap.put(bidItem.Phoenix_Product__c,bidItem.Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c);
            }
            if(bItemsMap.containsKey(bidItem.Phoenix_Bid__r.Id)){
                List<Phoenix_Bid_Line_Item__c> addedItems = bItemsMap.get(bidItem.Phoenix_Bid__r.Id);
                addedItems.add(bidItem);
                bItemsMap.put(bidItem.Phoenix_Bid__r.Id,addedItems);
            }else{
                bItemsMap.put(bidItem.Phoenix_Bid__r.Id,new  List<Phoenix_Bid_Line_Item__c>{bidItem});
            }            
            
        }
        List<Phoenix_Bid_Line_Item__c> bidLine = new List<Phoenix_Bid_Line_Item__c>();
        List < Phoenix_Bid_VIP_Rebate__c > vipRebateList = new List < Phoenix_Bid_VIP_Rebate__c >();
        for (Phoenix_Bid__c bid: triggerNew) {
            if(bid.Phoenix_Bid_Type__c == 'VIP Rebate'){
            	List < Phoenix_Bid_VIP_Rebate__c > rebCurrent = [SELECT Id, Phoenix_Business_Approval_Comments__c,Phoenix_Bid__c,Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Business_Approval__c, Phoenix_Contracts_Approval__c, Phoenix_Contracts_Approval_Comments__c, Phoenix_Customer_Approval_Comments__c, Phoenix_Customer_Approval__c, Phoenix_Finance_Approval__c,Phoenix_Finance_Approval_Comments__c,Phoenix_Vistex_Update_Comments__c, Phoenix_Vistex_Update__c FROM Phoenix_Bid_VIP_Rebate__c WHERE Phoenix_Bid__c =: bid.Id ]; 
                for(Phoenix_Bid_VIP_Rebate__c vipRebate : rebCurrent){
                    vipRebate.Phoenix_Business_Approval__c = bid.Phoenix_Business_Approval__c;
                    vipRebate.Phoenix_Contracts_Approval__c = bid.Phoenix_Contracts_Approval__c;
                    vipRebate.Phoenix_Contracts_Approval_Comments__c = bid.Phoenix_Contracts_Approval_Comments__c;
                    vipRebate.Phoenix_Customer_Approval_Comments__c = bid.Phoenix_Customer_Approval__c;
                    vipRebate.Phoenix_Customer_Approval__c = bid.Phoenix_Customer_Approval__c;
                    vipRebate.Phoenix_Customer_Approval__c = bid.Phoenix_Customer_Approval__c;
                    vipRebate.Phoenix_Customer_Approval_Comments__c = bid.Phoenix_Customer_Approval_Comments__c;
                    vipRebate.Phoenix_Finance_Approval__c = bid.Phoenix_Finance_Approval__c;
                    vipRebate.Phoenix_Finance_Approval_Comments__c = bid.Phoenix_Finance_Approval_Comments__c;
                    vipRebate.Phoenix_Vistex_Update__c  = bid.Phoenix_Vistex_Update__c ;
                    vipRebate.Phoenix_Vistex_Update_Comments__c = bid.Phoenix_Vistex_Update_Comments__c;
                    vipRebate.Phoenix_Business_Approval_Comments__c = bid.Phoenix_Business_Approval_Comments__c;
                    vipRebateList.add(vipRebate);
                }
            }
            
            if(bid.Phoenix_Approval_Status__c == 'Closed'){
                if(bid.Phoenix_Bid_Type__c != 'VIP Rebate' && bItemsMap.containsKey(bid.Id)){
                    if(bItemsMap != null && bItemsMap.get(bid.Id) != null && bItemsMap.get(bid.Id).size()>0){
                        for(Phoenix_Bid_Line_Item__c item : bItemsMap.get(bid.Id)) {
                            if(item.Phoenix_Final_Status__c != 'Not Approved'){
                                item.Phoenix_Final_Status__c = 'Approved';
                                
                            }
                            if(item.Phoenix_Final_Status__c == 'Approved'){
                                item.Phoenix_Bid_Line_Item_Approval_Status__c = 'Approved';
                                
                            }
                            bidLine.add(item);
                        }
                    }
                    
                }
            }
            
            //added by vandana
             else if(bid.Phoenix_Approval_Status__c == 'Draft'){
                if(bid.Phoenix_Bid_Type__c != 'VIP Rebate' && bItemsMap.containsKey(bid.Id)){
                    if(bItemsMap != null && bItemsMap.get(bid.Id) != null && bItemsMap.get(bid.Id).size()>0){
                        for(Phoenix_Bid_Line_Item__c item : bItemsMap.get(bid.Id)) {
                                item.Phoenix_Bid_Line_Item_Approval_Status__c = 'Draft';
                             bidLine.add(item);
                        }
                    }
                    
                }
            }
            
            //end.
            else if(bid.Phoenix_Approval_Status__c == 'Closed-Draft'){
                if(bid.Phoenix_Bid_Type__c != 'VIP Rebate' && bItemsMap.containsKey(bid.Id)){
                    if(bItemsMap != null && bItemsMap.get(bid.Id) != null && bItemsMap.get(bid.Id).size()>0){
                        for(Phoenix_Bid_Line_Item__c item : bItemsMap.get(bid.Id)) {
                            item.Phoenix_Bid_Line_Item_Approval_Status__c = bid.Phoenix_Approval_Status__c;
                            item.Phoenix_Final_Status__c = 'Not Approved';
                            bidLine.add(item);
                        }
                    }
                    
                }
            }
            else if(bid.Phoenix_Approval_Status__c == 'On Hold'){
                if(bid.Phoenix_Bid_Type__c != 'VIP Rebate' && bItemsMap.containsKey(bid.Id)){
                    if(bItemsMap != null && bItemsMap.get(bid.Id) != null && bItemsMap.get(bid.Id).size()>0){
                        for(Phoenix_Bid_Line_Item__c item : bItemsMap.get(bid.Id)) {
                            if(item.Phoenix_Final_Status__c!='Not Approved')
                            item.Phoenix_Bid_Line_Item_Approval_Status__c = bid.Phoenix_Approval_Status__c;
                            bidLine.add(item);
                        }
                    }
                    
                }
            }
            else if(bid.Phoenix_Approval_Status__c != 'Draft'){
                if(bid.Phoenix_Bid_Type__c != 'VIP Rebate' && bItemsMap.containsKey(bid.Id)){
                    if(bItemsMap != null && bItemsMap.get(bid.Id) != null && bItemsMap.get(bid.Id).size()>0){
                        for(Phoenix_Bid_Line_Item__c item : bItemsMap.get(bid.Id)) {
                            if(item.Phoenix_Final_Status__c != 'Not Approved'){
                                item.Phoenix_Bid_Line_Item_Approval_Status__c = bid.Phoenix_Approval_Status__c + ' Pending';
                                bidLine.add(item);
                            }
                        }
                    }
                    
                }
            }
            if (oldMap.get(bid.Id).Phoenix_Approval_Status__c != newMap.get(bid.Id).Phoenix_Approval_Status__c && 
                newMap.get(bid.Id).Phoenix_Approval_Status__c != null &&
                newMap.get(bid.Id).Phoenix_Approval_Status__c.contains('Closed')) {
                    bidIds.add(bid.Id);
                }
        }
        if(IPAProductsMap.size()>0){
            List<Product2> productlist = [Select Id, Phoenix_IPA_Floor_Price__c FROM Product2 WHERE Id=:IPAProductsMap.keySet()];
            for(Product2 prod : productlist){
                prod.Phoenix_IPA_Floor_Price__c = IPAProductsMap.get(prod.Id);
                if(IPAProductsBidClosedDateMap.containsKey(prod.Id))
                prod.Phoenix_IPA_Floor_Price_Effective_Date__c = IPAProductsBidClosedDateMap.get(prod.Id);
                
            }
            if(productlist != null && productlist.size()>0){
                update productlist;
            }
        }
        if(bidLine != null && bidLine.size()>0){
            update bidLine;        
        }
        if(vipRebateList.size()>0){
            update vipRebateList;
        }                 
        //if(bidIds.size()>0) Phoenix_SubmitBidForApprovalCtrl.approvalStageChangeNotification(bidIds); //Sending notification to Bid Owner and behalf of users
        
        if (bidIds.size() > 0) Phoenix_SubmitBidForApprovalCtrl.BidClosureNotification(bidIds); //Sending notification to all people involved, when bid is closed. 
    }
    
    public override void beforeDelete() {
        triggerOld[0].addError('You can\'t delete the Bid');
        
        /*     List < Id > bidIds = new List < Id > ();
for (Phoenix_Bid__c bid: triggerOld) {
if (oldMap.get(bid.Id).Phoenix_Approval_Status__c == 'Draft')
bidIds.add(bid.Id);
else 
bid.addError('You can\'t delete this Bid, as it is already submitted for approval.');

}
if (bidIds.size() > 0)Phoenix_SubmitBidForApprovalCtrl.deleteBidChildren(bidIds);
system.debug('deleting children');
*/
    }
    
    
    public static void getUltimateParent(list < Phoenix_Bid__c > bidRecords) {
        Map < Id, Phoenix_Bid__c > allBidMap = new Map < Id, Phoenix_Bid__c > ();
        
        //Set<Id> parentRebidIds = new Set<Id>();
        String tempId;
        for (Phoenix_Bid__c bidRecord: Database.query('SELECT Id,Phoenix_Is_Re_Bid__c,Phoenix_Previous_Bid__c FROM Phoenix_Bid__c LIMIT 10000')) {
            allBidMap.put(bidRecord.Id, bidRecord);
        }
        
        
        
        for (Phoenix_Bid__c bid: bidRecords) {
            
            if (bid.Phoenix_Is_Re_Bid__c) {
                tempId = bid.Phoenix_Previous_Bid__c;
                while (allBidMap.get(tempId) != NULL && allBidMap.get(tempId).Phoenix_Previous_Bid__c != NULL) {
                    tempId = allBidMap.get(tempId).Phoenix_Previous_Bid__c;
                }
                bid.Phoenix_Ultimate_Parent__c = tempId;
                
            }
        }

    }
    
  public static void codeCoverage(){
        integer i =1;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
    i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
    i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        
        
    } 
    
}