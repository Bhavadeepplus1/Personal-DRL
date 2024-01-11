/**
* @description       : This will update the approval timings and parent obj closed date. 
* @author            : Surender Patel (Dhruvsoft)
* @group             : 
* @last modified on  : 26-06-2021
* @last modified by  : Surender Patel (Dhruvsoft)
* Modifications Log 
* Ver   Date         Author                       Modification
* 1.0   26-06-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
trigger Phoenix_BidProcessStepTrigger on Phoenix_Bid_Process_Steps__c(before update) {
    Set < Id > parentIds = new Set < Id > ();
    Set < Id > parentSCMIds = new Set < Id > ();
    Set < Id > parentMarketingIds = new Set < Id > ();
    Set < Id > parentMarketingRxIds = new Set < Id > ();
    Set < Id > parentMarketingSRxIds = new Set < Id > ();
    Set < Id > parentMarketingOTcIds = new Set < Id > ();
    Set < Id > parentMarketingHeadIds = new Set < Id > ();
    Set < Id > parentFinanceIds = new Set < Id > ();
    Set < Id > parentContractIds = new Set < Id > ();
    
    map < Id,Phoenix_Bid__c > updatedBidswDate = new map <Id,Phoenix_Bid__c > ();
    Integer i=0;
    Integer j=0;
    for (Phoenix_Bid_Process_Steps__c step: trigger.new) {
        if (step.Phoenix_Status__c == 'In Process' || step.Phoenix_Status__c == 'Not Processed') {
            if(step.Phoenix_Override_Dates__c == False && step.Phoenix_Approval_Sent_Time__c == null)    step.Phoenix_Approval_Sent_Time__c = Phoenix_Util.getNowEST(); //;
            if(step.Phoenix_Approval_Sent_Time__c != null)
            step.Phoenix_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(step.Phoenix_Approval_Sent_Time__c, 'America/New_York');
        }
        if (step.Phoenix_Status__c == 'Completed' || step.Phoenix_Status__c == 'Closed' || step.Phoenix_Status__c == 'Not Processed') {
            if(step.Phoenix_Override_Dates__c == False && step.Phoenix_Approval_Completed_Time__c == null)  step.Phoenix_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
             if(step.Phoenix_Approval_Completed_Time__c != null)
            step.Phoenix_Approval_Completed_Time_String__c = Phoenix_Util.getUserTimeNow(step.Phoenix_Approval_Completed_Time__c, 'America/New_York');
        }
        
        
        if ( step.Phoenix_Bid__c != null && step.Name.containsIgnoreCase('Vistex') && step.Phoenix_Status__c == 'In Process') {
            Phoenix_Bid__c bid =  updatedBidswDate.containsKey(step.Phoenix_Bid__c) ? updatedBidswDate.get(step.Phoenix_Bid__c) : new Phoenix_Bid__c(Id = step.Phoenix_Bid__c); 
            bid.Phoenix_Sent_to_Vistex_Date__c = Phoenix_Util.getTodayEST();
            updatedBidswDate.put(step.Phoenix_Bid__c,bid);
        }
        
        if ( step.Phoenix_Bid__c != null && step.Name.containsIgnoreCase('Customer Service') && step.Phoenix_Status__c == 'Completed') {
            Phoenix_Bid__c bid =  updatedBidswDate.containsKey(step.Phoenix_Bid__c) ? updatedBidswDate.get(step.Phoenix_Bid__c) : new Phoenix_Bid__c(Id = step.Phoenix_Bid__c); 
            bid.Phoenix_Customer_Service_Approved_Date__c = Phoenix_Util.getTodayEST();
            updatedBidswDate.put(step.Phoenix_Bid__c,bid);
        }
        
        if (step.Name.containsIgnoreCase('Closed') && step.Phoenix_Status__c == 'Completed' && step.Phoenix_Bid__c != null ) {
            parentIds.add(step.Phoenix_Bid__c);
        }
        else if(step.Name.containsIgnoreCase('Closed') &&  step.Phoenix_Status__c == 'Completed' && step.Phoenix_NDC_Change__c != null){
            parentIds.add(step.Phoenix_NDC_Change__c);
        }
        else if(step.Name.containsIgnoreCase('Closed') &&   step.Phoenix_Status__c == 'Completed' &&  step.Phoenix_PHS_Price_Change__c != null){
            parentIds.add(step.Phoenix_PHS_Price_Change__c);
        }
        
        if(step.Phoenix_Status__c == 'Completed' && step.Name.containsIgnoreCase('Supply Chain Approval') && step.Phoenix_Bid__c != null  ){
            parentSCMIds.add(step.Phoenix_Bid__c);
            
        }
        if(step.Phoenix_Status__c == 'Completed' && step.Name.containsIgnoreCase('Finance Approval') && step.Phoenix_Bid__c != null  ){
            parentFinanceIds.add(step.Phoenix_Bid__c);
            
        }
        if(step.Phoenix_Status__c == 'Completed' && step.Name.containsIgnoreCase('Contract') && step.Phoenix_Bid__c != null  ){
            parentContractIds.add(step.Phoenix_Bid__c);
            
        }
        //step.Name.containsIgnoreCase('Marketing Approval') ||
        if(( step.Name.containsIgnoreCase('Marketing Lead OTC') ||step.Name.containsIgnoreCase('Marketing Lead SRx') || step.Name.containsIgnoreCase('Marketing Lead Rx') || step.Name.containsIgnoreCase('Marketing Head'))&& step.Phoenix_Bid__c != null && step.Phoenix_Status__c != 'Not Applicable')  i++;
        if(step.Phoenix_Status__c == 'Completed' && ( step.Name.containsIgnoreCase('Marketing Lead OTC') ||step.Name.containsIgnoreCase('Marketing Lead SRx') || step.Name.containsIgnoreCase('Marketing Lead Rx') || step.Name.containsIgnoreCase('Marketing Head'))&& step.Phoenix_Bid__c != null  && step.Phoenix_Status__c != 'Not Applicable')   j++;
        
        if(i>0 && i==j){
            system.debug('The name is '+step.Name);
            /*if(step.Name.containsIgnoreCase('Marketing Approval'))
{
parentMarketingIds.add(step.Phoenix_Bid__c);  
}
else*/ if(step.Name.containsIgnoreCase('Marketing Lead Rx Approval'))
{
    parentMarketingRxIds.add(step.Phoenix_Bid__c);
}
            else if(step.Name.containsIgnoreCase('Marketing Lead SRx Approval'))
            {
                parentMarketingSRxIds.add(step.Phoenix_Bid__c);
            }
            else if(step.Name.containsIgnoreCase('Marketing Lead OTC Approval'))
            {
                parentMarketingOTcIds.add(step.Phoenix_Bid__c);
            }
            else if(step.Name.containsIgnoreCase('Marketing Head Approval'))
            {
                parentMarketingHeadIds.add(step.Phoenix_Bid__c);
            }
        }
        //step.Name.containsIgnoreCase('Marketing Approval') ||
        if(step.Phoenix_Status__c == 'In Process' && ( step.Name.containsIgnoreCase('Marketing Lead Rx Approval') || step.Name.containsIgnoreCase('Marketing Lead SRx Approval') || step.Name.containsIgnoreCase('Marketing Head Approval') || step.Name.containsIgnoreCase('Marketing Lead OTC Approval')) && step.Phoenix_Bid__c != null  && step.Phoenix_Status__c != 'Not Applicable')  parentMarketingIds.remove(step.Phoenix_Bid__c);  
    }
    
    
    List < Id > parentIdsList = new List < Id > ();
    parentIdsList.addAll(parentIds);
    List < Phoenix_Bid__c > updatedBids = new List < Phoenix_Bid__c > ();
    List < Phoenix_NDC_Change__c > updatedNDCs = new List < Phoenix_NDC_Change__c > ();
    List < Phoenix_PHS_Price_Change__c > updatedpHSs = new List < Phoenix_PHS_Price_Change__c > ();
    if (parentIdsList.size()>0 && String.valueOf(parentIdsList[0].getSobjectType()) == 'Phoenix_Bid__c') {
        for (Id bidId: parentIds) {
            Phoenix_Bid__c bid = new Phoenix_Bid__c(Id = bidId, Phoenix_Bid_Closed_Date__c = Phoenix_Util.getTodayEST());
            updatedBids.add(bid);
        }
        update updatedBids;
    } 
    else if (parentIds.size()>0 && String.valueOf(parentIdsList[0].getSobjectType()) == 'Phoenix_NDC_Change__c') {
        for (Id bidId: parentIds) {
            Phoenix_NDC_Change__c ndc = new Phoenix_NDC_Change__c(Id = bidId, Phoenix_NDC_Closed_Date__c = Phoenix_Util.getTodayEST());
            updatedNDCs.add(ndc);
        }
        update updatedNDCs;
    }
    else if (parentIds.size()>0 && String.valueOf(parentIdsList[0].getSobjectType()) == 'Phoenix_PHS_Price_Change__c') {
        for (Id pHSId: parentIds) {
            Phoenix_PHS_Price_Change__c phs = new Phoenix_PHS_Price_Change__c(Id = pHSId, Phoenix_PHS_Price_Closed_Date__c =  Phoenix_Util.getTodayEST());
            updatedpHSs.add(phs);
        }
        update updatedpHSs;
    }
    //Bid close completed
    
    
    
    
    
    List < Id > parentSCMIdsList = new List < Id > ();
    parentSCMIdsList.addAll(parentSCMIds);
    
    
    if (parentSCMIdsList.size()>0 && String.valueOf(parentSCMIdsList[0].getSobjectType()) == 'Phoenix_Bid__c') {
        for (Id bidId: parentSCMIds) {
            Phoenix_Bid__c bid =  updatedBidswDate.containsKey(bidId) ? updatedBidswDate.get(bidId) : new Phoenix_Bid__c(Id = bidId); 
            bid.Phoenix_Bid_SCM_Approved_Date__c = Phoenix_Util.getTodayEST();
            updatedBidswDate.put(bidId,bid);
        }
        
    } 
    
    List < Id > parentFinanceIdsList = new List < Id > ();
    parentFinanceIdsList.addAll(parentFinanceIds);
    
    if (parentFinanceIdsList.size()>0 && String.valueOf(parentFinanceIdsList[0].getSobjectType()) == 'Phoenix_Bid__c') {
        for (Id bidId: parentFinanceIds) {
            Phoenix_Bid__c bid = new Phoenix_Bid__c(Id = bidId, Phoenix_Bid_Finance_Approved_Date__c = Phoenix_Util.getTodayEST());
            updatedBidswDate.put(bidId,bid);
        }
        
    } 
    
    List < Id > parentContractIdsList = new List < Id > ();
    parentContractIdsList.addAll(parentContractIds);
    
    if (parentContractIdsList.size()>0 && String.valueOf(parentContractIdsList[0].getSobjectType()) == 'Phoenix_Bid__c') {
        for (Id bidId: parentContractIds) {
            Phoenix_Bid__c bid = new Phoenix_Bid__c(Id = bidId, Phoenix_Bid_Contracts_Approved_Date__c = Phoenix_Util.getTodayEST());
            updatedBidswDate.put(bidId,bid);
        }
        
    } 
    List < Id > parentMarketingIdsList = new List < Id > ();
    parentMarketingIdsList.addAll(parentMarketingIds);
    
    if (parentMarketingIdsList.size()>0 && String.valueOf(parentMarketingIdsList[0].getSobjectType()) == 'Phoenix_Bid__c') {
        for (Id bidId: parentMarketingIds) {
            Phoenix_Bid__c bid = new Phoenix_Bid__c(Id = bidId, Phoenix_Bid_Marketing_Approved_Date__c = Phoenix_Util.getTodayEST());
            updatedBidswDate.put(bidId,bid);
        }
        
    }
    
    List < Id > parentMarketingSRXIdsList = new List < Id > ();
    parentMarketingSRXIdsList.addAll(parentMarketingSRxIds);
    
    if (parentMarketingSRXIdsList.size()>0 && String.valueOf(parentMarketingSRXIdsList[0].getSobjectType()) == 'Phoenix_Bid__c') {
        for (Id bidId: parentMarketingSRxIds) {
            Phoenix_Bid__c bid = new Phoenix_Bid__c(Id = bidId, Bid_Marketing_Lead_SRX_Approved_Date__c = Phoenix_Util.getTodayEST());
            updatedBidswDate.put(bidId,bid);
        }
        
    }
    
    List < Id > parentMarketingRXIdsList = new List < Id > ();
    parentMarketingRXIdsList.addAll(parentMarketingRxIds);
    
    if (parentMarketingRXIdsList.size()>0 && String.valueOf(parentMarketingRXIdsList[0].getSobjectType()) == 'Phoenix_Bid__c') {
        for (Id bidId: parentMarketingRxIds) {
            Phoenix_Bid__c bid = new Phoenix_Bid__c(Id = bidId, Bid_Marketing_Lead_RX_Approved_Date__c = Phoenix_Util.getTodayEST());
            updatedBidswDate.put(bidId,bid);
        }
        
    }
    
    List < Id > parentMarketingOTCIdsList = new List < Id > ();
    parentMarketingOTCIdsList.addAll(parentMarketingOTcIds);
    
    if (parentMarketingOTCIdsList.size()>0 && String.valueOf(parentMarketingOTCIdsList[0].getSobjectType()) == 'Phoenix_Bid__c') {
        for (Id bidId: parentMarketingOTcIds) {
            Phoenix_Bid__c bid = new Phoenix_Bid__c(Id = bidId, Bid_Marketing_Lead_OTC_Approved_Date__c = Phoenix_Util.getTodayEST());
            updatedBidswDate.put(bidId,bid);
        }
        
    }
    
    List < Id > parentMarketingHeadIdsList = new List < Id > ();
    parentMarketingHeadIdsList.addAll(parentMarketingHeadIds);
    
    if (parentMarketingHeadIdsList.size()>0 && String.valueOf(parentMarketingHeadIdsList[0].getSobjectType()) == 'Phoenix_Bid__c') {
        for (Id bidId: parentMarketingHeadIds) {
            Phoenix_Bid__c bid = new Phoenix_Bid__c(Id = bidId, Bid_Marketing_Head_Approved_Date__c = Phoenix_Util.getTodayEST());
            updatedBidswDate.put(bidId,bid);
        }
    }
    if(updatedBidswDate.size()>0){
        update updatedBidswDate.values();
    }
}