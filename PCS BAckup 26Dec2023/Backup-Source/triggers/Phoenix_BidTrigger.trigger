trigger Phoenix_BidTrigger on Phoenix_Bid__c (before insert, before update) {
    /*if(Trigger.isInsert){
        for(Phoenix_Bid__c bid : trigger.new){
             if (bid.Phoenix_Customer_Bid_Deadline_Time_zone__c != null && bid.Phoenix_Customer_Bid_Deadline_Time__c!=null && bid.Phoenix_Bid_Deadline_Date__c!=null){ 
//  bid.Phoenix_Customer_Bid_Deadline__c= bid.Phoenix_Bid_Deadline_Date__c+' '+bid.Phoenix_Customer_Bid_Deadline_Time__c+' '+bid.Phoenix_Customer_Bid_Deadline_Time_zone__c;
 bid.Phoenix_Customer_Bid_Deadline__c= bid.Phoenix_Bid_Deadline_Date__c.format()+' '+bid.Phoenix_Customer_Bid_Deadline_Time__c+' '+bid.Phoenix_Customer_Bid_Deadline_Time_zone__c;

//    if (bid.Phoenix_Customer_Bid_Deadline_Time_zone__c != null && bid.Phoenix_Customer_Bid_Deadline_Date_Time__c!=null){ bid.Phoenix_Customer_Bid_Deadline__c= bid.Phoenix_Customer_Bid_Deadline_Date_Time__c.format()+' '+bid.Phoenix_Customer_Bid_Deadline_Time_zone__c;

}            
            if(bid.Phoenix_Select_Wholesaler__c!=null &&bid.Phoenix_Select_Wholesaler__c=='ABC')
                bid.Phoenix_Contract_Management_Fee__c=10.25;
            if(bid.Phoenix_Select_Wholesaler__c!=null &&bid.Phoenix_Select_Wholesaler__c=='Cardinal')
                bid.Phoenix_Contract_Management_Fee__c=8.00;
            if(bid.Phoenix_Select_Wholesaler__c!=null &&bid.Phoenix_Select_Wholesaler__c=='McKesson')
                bid.Phoenix_Contract_Management_Fee__c=5.00;
            if(bid.Phoenix_Select_Wholesaler__c!=null &&bid.Phoenix_Select_Wholesaler__c=='Other')
                bid.Phoenix_Contract_Management_Fee__c=5.00;
            if(bid.Phoenix_Select_Wholesaler__c!=null &&bid.Phoenix_Select_Wholesaler__c=='Source Program (No CM Fee Applies)')
                bid.Phoenix_Contract_Management_Fee__c=0.00;
            
           if(bid.Phoenix_Bid_Type__c=='VIP Rebate' && bid.Phoenix_Customer__c != null){
                Account cust=[select id from Account WHERE Id=:bid.Phoenix_Customer__c LIMIT 1];
                List<Phoenix_Bid_VIP_Rebate__c> rebCurrent=[select id from Phoenix_Bid_VIP_Rebate__c where Phoenix_Customer__c=:cust.Id AND Phoenix_Status__c='Current'];
                if(!rebCurrent.isEmpty()){
                    bid.Phoenix_Current_VIP_Rebate__c=rebCurrent[0].Id;
                }
            }
        }
    }
    if(Trigger.isUpdate){
        for(Phoenix_Bid__c bid : trigger.new){
            Phoenix_Bid__c newBid = trigger.newMap.get(bid.id);
            Phoenix_Bid__c oldBid = trigger.oldMap.get(bid.id);
            if (bid.Phoenix_Customer_Bid_Deadline_Time_zone__c != null && bid.Phoenix_Customer_Bid_Deadline_Time__c!=null && bid.Phoenix_Customer_Bid_Deadline_Time_zone__c!=null && ((newBid.Phoenix_Customer_Bid_Deadline_Time_zone__c != oldBid.Phoenix_Customer_Bid_Deadline_Time_zone__c) || (newBid.Phoenix_Customer_Bid_Deadline_Time__c != oldBid.Phoenix_Customer_Bid_Deadline_Time__c))){
                 bid.Phoenix_Customer_Bid_Deadline__c= bid.Phoenix_Bid_Deadline_Date__c.format()+' '+bid.Phoenix_Customer_Bid_Deadline_Time__c+' '+bid.Phoenix_Customer_Bid_Deadline_Time_zone__c;
            }  
            if(bid.Phoenix_Select_Wholesaler__c!=null &&bid.Phoenix_Select_Wholesaler__c=='ABC')
                bid.Phoenix_Contract_Management_Fee__c=10.25;
            if(bid.Phoenix_Select_Wholesaler__c!=null &&bid.Phoenix_Select_Wholesaler__c=='Cardinal')
                bid.Phoenix_Contract_Management_Fee__c=8.00;
            if(bid.Phoenix_Select_Wholesaler__c!=null &&bid.Phoenix_Select_Wholesaler__c=='McKesson')
                bid.Phoenix_Contract_Management_Fee__c=5.00;
            if(bid.Phoenix_Select_Wholesaler__c!=null &&bid.Phoenix_Select_Wholesaler__c=='Other')
                bid.Phoenix_Contract_Management_Fee__c=5.00;
            if(bid.Phoenix_Select_Wholesaler__c!=null &&bid.Phoenix_Select_Wholesaler__c=='Source Program (No CM Fee Applies)')
                bid.Phoenix_Contract_Management_Fee__c=0.00;
        }
        
    }
    */
}