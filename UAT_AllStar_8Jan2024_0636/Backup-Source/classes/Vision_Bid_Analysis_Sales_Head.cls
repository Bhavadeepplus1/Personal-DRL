public class Vision_Bid_Analysis_Sales_Head {
     @auraEnabled
    public static void forCodeCoverage(){
        String className = 'My class';
    }
 
 /*   @auraEnabled
    public static Wrapper getTeamMembers(){
        String currentUserId = userInfo.getUserId();
        Set < string > ManagerLabelIds = new Set < string > ();
        ManagerLabelIds.addAll(Label.Sales_Head_Bid_Analysis.split(','));
        List<User> currentUserManager = [SELECT Id,ManagerId,Name FROM User WHERE ID =: currentUserId AND IsActive = true];
        Id currentUserManagerId = currentUserManager[0].ManagerId;
        system.debug('currentUserId--'+currentUserId);
        
        List<User> subOrdinatesList = new List<User>();
        List<User> ManagerDetailsList = new List<User>();
        if(ManagerLabelIds.contains(currentUserId)){
          //  ManagerDetailsList =  [SELECT Id,ManagerId,Name FROM User WHERE Id =: currentUserId AND IsActive = true order by Name];
            subOrdinatesList = [SELECT Id,ManagerId,Name FROM User WHERE ManagerId =: currentUserId AND IsActive = true order by Name];
        }
        else{
            ManagerDetailsList =  [SELECT Id,ManagerId,Name FROM User WHERE Id =: currentUserManagerId AND IsActive = true order by Name];
            subOrdinatesList = [SELECT Id,ManagerId,Name FROM User WHERE ManagerId =: currentUserManagerId AND id !=: currentUserId AND IsActive = true order by Name];
        }        system.debug('subOrdinatesList--'+subOrdinatesList.size());
        for(User manager : ManagerDetailsList){
           subOrdinatesList.add(manager);  
        }
    
        String teamfirstId = '';
        if(subOrdinatesList.size()>0){
            teamfirstId = subOrdinatesList[0].Id;   
        }
          system.debug('subOrdinatesList--'+subOrdinatesList.size());
        String selectedRange ='THIS_FISCAL_YEAR';
        String selectedDate = 'Submitted Date';
        Date startDate = null;
        Date endDate = null;
        MainWrapper wrapperObject = new MainWrapper();
        Wrapper newWrapper = new Wrapper();
        newWrapper = bidDetails(teamfirstId,selectedRange,selectedDate,startDate,endDate);
        newWrapper.picklistValues = subOrdinatesList;
        
        system.debug('wrapperObject----'+newWrapper);
        return newWrapper;
    }
    @auraEnabled
    public static Wrapper bidDetails(String teamMemberId,String selectedRange,String selectedDate,Date startDate, Date endDate){   
        system.debug('startDate---'+startDate);
        system.debug('endDate---'+endDate);
        system.debug('teamMemberId---'+teamMemberId);
        system.debug('selectedRange---'+selectedRange);
        system.debug('selectedDate---'+selectedDate);
        system.debug('Hi my Team');
        MainWrapper wrapperObject = new MainWrapper();
        MainWrapper acqWrap = new MainWrapper();
        MainWrapper retWrap = new MainWrapper();
        MainWrapper proWrap = new MainWrapper();
        MainWrapper reacWrap = new MainWrapper();
        
        Decimal InternalDuration =0;
        Decimal CRDuration =0;
        
        set<String> acqBid = new set<String>();
        set<String> retBid = new set<String>();
        set<String> proBid = new set<String>();
        set<String> reacBid = new set<String>();
        List<Phoenix_Bid__c> bidDataList =  new List<Phoenix_Bid__c>();
        
        //bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Approval_Status__c != 'Closed-Draft' ];
        
        if(selectedDate == 'Submitted Date' && selectedRange == 'Custom' && startDate != null && endDate != null){
             
            bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Approval_Status__c != 'Closed-Draft'  AND Phoenix_Bid_Submitted_Date__c >=: startDate AND Phoenix_Bid_Submitted_Date__c <=: endDate LIMIT 2000];
            
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'Custom' && startDate != null && endDate != null){
            bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Approval_Status__c != 'Closed-Draft'  AND Phoenix_Sent_to_Customer_Date__c >=: startDate AND Phoenix_Sent_to_Customer_Date__c <=: endDate LIMIT 2000];
             
        }
       else if(selectedDate == 'Submitted Date' && selectedRange == 'THIS_FISCAL_YEAR'){
             
            bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Bid_Submitted_Date__c = THIS_FISCAL_YEAR];
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'THIS_YEAR'){
            bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Bid_Submitted_Date__c = THIS_YEAR ];
           
        }
        
        else if(selectedDate == 'Submitted Date' && selectedRange == 'THIS_QUARTER'){
           bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Bid_Submitted_Date__c = THIS_QUARTER ];
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'THIS_MONTH'){   bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Bid_Submitted_Date__c = THIS_MONTH ];
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'THIS_WEEK'){             bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Bid_Submitted_Date__c = THIS_WEEK ];
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'LAST_FISCAL_YEAR'){   bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Bid_Submitted_Date__c = LAST_FISCAL_YEAR ];
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'LAST_YEAR'){  bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Bid_Submitted_Date__c = LAST_YEAR ];
        }
        
        else if(selectedDate == 'Submitted Date' && selectedRange == 'LAST_QUARTER'){ bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Bid_Submitted_Date__c = LAST_QUARTER ];
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'LAST_MONTH'){    bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Bid_Submitted_Date__c = LAST_MONTH ];
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'LAST_WEEK'){    bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Bid_Submitted_Date__c = LAST_WEEK ];
        } 
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'THIS_FISCAL_YEAR'){
                bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId  AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Sent_to_Customer_Date__c = THIS_FISCAL_YEAR ];
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'THIS_YEAR'){
            bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId  AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Sent_to_Customer_Date__c = THIS_YEAR ];
        }
        
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'THIS_QUARTER'){      bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId  AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Sent_to_Customer_Date__c = THIS_QUARTER ];
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'THIS_MONTH'){       bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId  AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Sent_to_Customer_Date__c = THIS_MONTH ];
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'THIS_WEEK'){      bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId  AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Sent_to_Customer_Date__c = THIS_WEEK ];
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'LAST_FISCAL_YEAR'){     bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId  AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Sent_to_Customer_Date__c = LAST_FISCAL_YEAR ];
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'LAST_YEAR'){     bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId  AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Sent_to_Customer_Date__c = LAST_YEAR ];
        }
        
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'LAST_QUARTER'){  bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId  AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Sent_to_Customer_Date__c = LAST_QUARTER ];
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'LAST_MONTH'){
            bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId  AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Sent_to_Customer_Date__c = LAST_MONTH ];
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'LAST_WEEK'){
            bidDataList =[SELECT ID,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(SELECT Phoenix_Proposed_Sales__c,Phoenix_Final_Status__c, Phoenix_Bid_Status__c FROM Bid_Line_Items__r ) FROM Phoenix_Bid__c WHERE  Phoenix_Customer__r.OwnerId =: teamMemberId  AND Phoenix_Approval_Status__c != 'Closed-Draft' AND Phoenix_Sent_to_Customer_Date__c = LAST_WEEK ];
        }
        
        system.debug('bidDataList-----'+bidDataList);
        wrapperObject.TotalBidIds = bidDataList.size();
        List<User> userList = [SELECT Id,ManagerId,Name FROM User WHERE Id =: teamMemberId];
        if(userList.size()>0){
            wrapperObject.userName = userList[0].Name;
            
        }
        for(Phoenix_Bid__c bid: bidDataList){
            
            for(Phoenix_Bid_Line_Item__c bidLine : bid.Bid_Line_Items__r){
                //won
                if(bidLine.Phoenix_Bid_Status__c == 'Awarded'){
                    wrapperObject.bidLinesWon = wrapperObject.bidLinesWon+1;
                    if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                        wrapperObject.bidLinesWonSum += bidLine.Phoenix_Proposed_Sales__c; 
                    }  
                    //acq 
                    if(bid.Phoenix_Bid_Type__c == 'New Customer' || bid.Phoenix_Bid_Type__c == 'New Product Launch'  || bid.Phoenix_Bid_Type__c == 'Good Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Short Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Product Addition'  || bid.Phoenix_Bid_Type__c == 'RFP Bids' || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change'   || bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Member Addition' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition' || bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'|| bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'|| bid.Phoenix_Bid_Type__c == 'RCA Member Addition' || bid.Phoenix_Bid_Type__c == 'Volume Review Only'){
                        acqBid.add(bid.Id);
                        acqWrap.bidLinesWon = acqWrap.bidLinesWon+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            acqWrap.bidLinesWonSum += bidLine.Phoenix_Proposed_Sales__c; 
                        }   
                    }
                    //retention
                    if(bid.Phoenix_Bid_Type__c == 'Price Change' || bid.Phoenix_Bid_Type__c == 'RFP Bids'  || bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update'  || bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update'  || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change'  || bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'){
                        retBid.add(bid.Id);
                        retWrap.bidLinesWon = retWrap.bidLinesWon+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            retWrap.bidLinesWonSum += bidLine.Phoenix_Proposed_Sales__c; 
                        }   
                    }
                    //Proactive
                    if(bid.Phoenix_Bid_Type__c == 'Mass Product Removals' || bid.Phoenix_Bid_Type__c == 'New Customer' || bid.Phoenix_Bid_Type__c == 'New Product Launch' || bid.Phoenix_Bid_Type__c == 'Good Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Product Addition'  || bid.Phoenix_Bid_Type__c == 'Product Discontinuation Process'  || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change'|| bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Member Addition' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition'|| bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'|| bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'|| bid.Phoenix_Bid_Type__c == 'RCA Member Addition' || bid.Phoenix_Bid_Type__c == 'Volume Review Only'){                        
                        proBid.add(bid.Id);
                        proWrap.bidLinesWon = proWrap.bidLinesWon+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            proWrap.bidLinesWonSum += bidLine.Phoenix_Proposed_Sales__c; 
                        }   
                    }
                    //Reactive
                    if(bid.Phoenix_Bid_Type__c == 'Good Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Price Change'  || bid.Phoenix_Bid_Type__c == 'Product Addition'  || bid.Phoenix_Bid_Type__c == 'RFP Bids'|| bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition' || bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'||  bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'  || bid.Phoenix_Bid_Type__c == 'Volume Review Only'){
                        reacBid.add(bid.Id);
                        reacWrap.bidLinesWon = reacWrap.bidLinesWon+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            reacWrap.bidLinesWonSum += bidLine.Phoenix_Proposed_Sales__c; 
                        } 
                    }
                }
                //Loss
                if(bidLine.Phoenix_Bid_Status__c == 'Declined by Customer' || bidLine.Phoenix_Bid_Status__c == 'DRL Rescinded'){
                    wrapperObject.bidLinesLost = wrapperObject.bidLinesLost+1;                  
                    if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                        wrapperObject.bidLinesLostSum += bidLine.Phoenix_Proposed_Sales__c; 
                    }  
                    //acq 
                    if(bid.Phoenix_Bid_Type__c == 'New Customer' || bid.Phoenix_Bid_Type__c == 'New Product Launch'  || bid.Phoenix_Bid_Type__c == 'Good Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Short Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Product Addition'  || bid.Phoenix_Bid_Type__c == 'RFP Bids' || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change'   || bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Member Addition' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition' || bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'|| bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'|| bid.Phoenix_Bid_Type__c == 'RCA Member Addition' || bid.Phoenix_Bid_Type__c == 'Volume Review Only'){
                        acqBid.add(bid.Id);
                        acqWrap.bidLinesLost = acqWrap.bidLinesLost+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            acqWrap.bidLinesLostSum += bidLine.Phoenix_Proposed_Sales__c; 
                        }   
                    }
                    //retention
                    if(bid.Phoenix_Bid_Type__c == 'Price Change' || bid.Phoenix_Bid_Type__c == 'RFP Bids'  || bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update'  || bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update'  || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change'  || bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'){
                        retBid.add(bid.Id);
                        retWrap.bidLinesLost = retWrap.bidLinesLost+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            retWrap.bidLinesLostSum += bidLine.Phoenix_Proposed_Sales__c; 
                        }   
                    }
                    //Proactive
                    if(bid.Phoenix_Bid_Type__c == 'Mass Product Removals' || bid.Phoenix_Bid_Type__c == 'New Customer' || bid.Phoenix_Bid_Type__c == 'New Product Launch' || bid.Phoenix_Bid_Type__c == 'Good Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Product Addition'  || bid.Phoenix_Bid_Type__c == 'Product Discontinuation Process'  || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change'|| bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Member Addition' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition'|| bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'|| bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'|| bid.Phoenix_Bid_Type__c == 'RCA Member Addition' || bid.Phoenix_Bid_Type__c == 'Volume Review Only'){                        
                        proBid.add(bid.Id);
                        proWrap.bidLinesLost = proWrap.bidLinesLost+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            proWrap.bidLinesLostSum += bidLine.Phoenix_Proposed_Sales__c; 
                        }   
                    }
                    //Reactive
                    if(bid.Phoenix_Bid_Type__c == 'Good Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Price Change'  || bid.Phoenix_Bid_Type__c == 'Product Addition'  || bid.Phoenix_Bid_Type__c == 'RFP Bids'|| bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition' || bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'||  bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'  || bid.Phoenix_Bid_Type__c == 'Volume Review Only'){
                        reacBid.add(bid.Id);
                        reacWrap.bidLinesLost = reacWrap.bidLinesLost+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            reacWrap.bidLinesLostSum += bidLine.Phoenix_Proposed_Sales__c; 
                        } 
                    }
                }
                //Pending Internal
                if(bidLine.Phoenix_Bid_Status__c == 'In Process' && bidLine.Phoenix_Final_Status__c != 'Not Approved' && ( bid.Phoenix_Approval_Status__c != 'Closed' || bid.Phoenix_Approval_Status__c != 'Customer'+ '\''+'s Update' || bid.Phoenix_Approval_Status__c != 'Vistex Update')){
                    wrapperObject.bidLinesPendingInternal = wrapperObject.bidLinesPendingInternal+1;
                    if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                        wrapperObject.bidLinesPendingInternalSum += bidLine.Phoenix_Proposed_Sales__c; 
                    }  
                    //acq 
                    if(bid.Phoenix_Bid_Type__c == 'New Customer' || bid.Phoenix_Bid_Type__c == 'New Product Launch'  || bid.Phoenix_Bid_Type__c == 'Good Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Short Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Product Addition'  || bid.Phoenix_Bid_Type__c == 'RFP Bids' || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change'   || bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Member Addition' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition' || bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'|| bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'|| bid.Phoenix_Bid_Type__c == 'RCA Member Addition' || bid.Phoenix_Bid_Type__c == 'Volume Review Only'){
                        acqBid.add(bid.Id);
                        acqWrap.bidLinesPendingInternal = acqWrap.bidLinesPendingInternal+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            acqWrap.bidLinesPendingInternalSum += bidLine.Phoenix_Proposed_Sales__c; 
                        }   
                    }
                    //retention
                    if(bid.Phoenix_Bid_Type__c == 'Price Change' || bid.Phoenix_Bid_Type__c == 'RFP Bids'  || bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update'  || bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update'  || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change'  || bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'){
                        retBid.add(bid.Id);
                        retWrap.bidLinesPendingInternal = retWrap.bidLinesPendingInternal+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            retWrap.bidLinesPendingInternalSum += bidLine.Phoenix_Proposed_Sales__c; 
                        }   
                    }
                    //Proactive
                    if(bid.Phoenix_Bid_Type__c == 'Mass Product Removals' || bid.Phoenix_Bid_Type__c == 'New Customer' || bid.Phoenix_Bid_Type__c == 'New Product Launch' || bid.Phoenix_Bid_Type__c == 'Good Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Product Addition'  || bid.Phoenix_Bid_Type__c == 'Product Discontinuation Process'  || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change'|| bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Member Addition' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition'|| bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'|| bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'|| bid.Phoenix_Bid_Type__c == 'RCA Member Addition' || bid.Phoenix_Bid_Type__c == 'Volume Review Only'){                        
                        proBid.add(bid.Id);
                        proWrap.bidLinesPendingInternal = proWrap.bidLinesPendingInternal+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            proWrap.bidLinesPendingInternalSum += bidLine.Phoenix_Proposed_Sales__c; 
                        }   
                    }
                    //Reactive
                    if(bid.Phoenix_Bid_Type__c == 'Good Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Price Change'  || bid.Phoenix_Bid_Type__c == 'Product Addition'  || bid.Phoenix_Bid_Type__c == 'RFP Bids'|| bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition' || bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'||  bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'  || bid.Phoenix_Bid_Type__c == 'Volume Review Only'){
                        reacBid.add(bid.Id);
                        reacWrap.bidLinesPendingInternal = reacWrap.bidLinesPendingInternal+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            reacWrap.bidLinesPendingInternalSum += bidLine.Phoenix_Proposed_Sales__c; 
                        } 
                    }
                }
                //Pending Customer Response
                if(bidLine.Phoenix_Bid_Status__c == 'Pending'){
                    wrapperObject.bidLinesPending = wrapperObject.bidLinesPending+1;
                    if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                        wrapperObject.bidLinesPendingSum += bidLine.Phoenix_Proposed_Sales__c; 
                    }  
                    //acq 
                    if(bid.Phoenix_Bid_Type__c == 'New Customer' || bid.Phoenix_Bid_Type__c == 'New Product Launch'  || bid.Phoenix_Bid_Type__c == 'Good Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Short Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Product Addition'  || bid.Phoenix_Bid_Type__c == 'RFP Bids' || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change'   || bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Member Addition' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition' || bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'|| bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'|| bid.Phoenix_Bid_Type__c == 'RCA Member Addition' || bid.Phoenix_Bid_Type__c == 'Volume Review Only'){
                        acqBid.add(bid.Id);
                        acqWrap.bidLinesPending = acqWrap.bidLinesPending+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            acqWrap.bidLinesPendingSum += bidLine.Phoenix_Proposed_Sales__c; 
                        }   
                    }
                    //retention
                    if(bid.Phoenix_Bid_Type__c == 'Price Change' || bid.Phoenix_Bid_Type__c == 'RFP Bids'  || bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update'  || bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update'  || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change'  || bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'){
                        retBid.add(bid.Id);
                        retWrap.bidLinesPending = retWrap.bidLinesPending+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            retWrap.bidLinesPendingSum += bidLine.Phoenix_Proposed_Sales__c; 
                        }   
                    }
                    //Proactive
                    if(bid.Phoenix_Bid_Type__c == 'Mass Product Removals' || bid.Phoenix_Bid_Type__c == 'New Customer' || bid.Phoenix_Bid_Type__c == 'New Product Launch' || bid.Phoenix_Bid_Type__c == 'Good Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Product Addition'  || bid.Phoenix_Bid_Type__c == 'Product Discontinuation Process'  || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change'|| bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Member Addition' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition'|| bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'|| bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'|| bid.Phoenix_Bid_Type__c == 'RCA Member Addition' || bid.Phoenix_Bid_Type__c == 'Volume Review Only'){                        
                        proBid.add(bid.Id);
                        proWrap.bidLinesPending = proWrap.bidLinesPending+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            proWrap.bidLinesPendingSum += bidLine.Phoenix_Proposed_Sales__c; 
                        }   
                    }
                    //reactive
                    if(bid.Phoenix_Bid_Type__c == 'Good Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Price Change'  || bid.Phoenix_Bid_Type__c == 'Product Addition'  || bid.Phoenix_Bid_Type__c == 'RFP Bids'|| bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition' || bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'||  bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'  || bid.Phoenix_Bid_Type__c == 'Volume Review Only'){
                        reacBid.add(bid.Id);
                        reacWrap.bidLinesPending = reacWrap.bidLinesPending+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            reacWrap.bidLinesPendingSum += bidLine.Phoenix_Proposed_Sales__c; 
                        } 
                    }
                }
                //Pending Proposals
                if((bidLine.Phoenix_Bid_Status__c != 'Awarded' || bidLine.Phoenix_Bid_Status__c != 'Declined by Customer' || bidLine.Phoenix_Bid_Status__c != 'DRL Rescinded' || bidLine.Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' || bidLine.Phoenix_Bid_Status__c != 'Pending') &&  bid.Phoenix_Approval_Status__c == 'Customer'+ '\''+'s Update' ){
                    wrapperObject.pendingProposals = wrapperObject.pendingProposals+1;
                    if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                        wrapperObject.pendingProposalsSum += bidLine.Phoenix_Proposed_Sales__c; 
                    }  
                    //acq 
                    if(bid.Phoenix_Bid_Type__c == 'New Customer' || bid.Phoenix_Bid_Type__c == 'New Product Launch'  || bid.Phoenix_Bid_Type__c == 'Good Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Short Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Product Addition'  || bid.Phoenix_Bid_Type__c == 'RFP Bids' || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change'   || bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Member Addition' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition' || bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'|| bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'|| bid.Phoenix_Bid_Type__c == 'RCA Member Addition' || bid.Phoenix_Bid_Type__c == 'Volume Review Only'){
                        acqBid.add(bid.Id);
                        acqWrap.pendingProposals = acqWrap.pendingProposals+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            acqWrap.pendingProposalsSum += bidLine.Phoenix_Proposed_Sales__c; 
                        }   
                    }
                    //retention
                    if(bid.Phoenix_Bid_Type__c == 'Price Change' || bid.Phoenix_Bid_Type__c == 'RFP Bids'  || bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update'  || bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update'  || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change'  || bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'){
                        retBid.add(bid.Id);
                        retWrap.pendingProposals = retWrap.pendingProposals+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            retWrap.pendingProposalsSum += bidLine.Phoenix_Proposed_Sales__c; 
                        }   
                    }
                    //Proactive
                    if(bid.Phoenix_Bid_Type__c == 'Mass Product Removals' || bid.Phoenix_Bid_Type__c == 'New Customer' || bid.Phoenix_Bid_Type__c == 'New Product Launch' || bid.Phoenix_Bid_Type__c == 'Good Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Product Addition'  || bid.Phoenix_Bid_Type__c == 'Product Discontinuation Process'  || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change'|| bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update' || bid.Phoenix_Bid_Type__c == 'IPA Member Addition' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition'|| bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'|| bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'|| bid.Phoenix_Bid_Type__c == 'RCA Member Addition' || bid.Phoenix_Bid_Type__c == 'Volume Review Only'){                        
                        proBid.add(bid.Id);
                        proWrap.pendingProposals = proWrap.pendingProposals+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            proWrap.pendingProposalsSum += bidLine.Phoenix_Proposed_Sales__c; 
                        }   
                    }
                    //reactive
                    if(bid.Phoenix_Bid_Type__c == 'Good Dated OTB'  || bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Price Change'  || bid.Phoenix_Bid_Type__c == 'Product Addition'  || bid.Phoenix_Bid_Type__c == 'RFP Bids'|| bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition' || bid.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'||  bid.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'  || bid.Phoenix_Bid_Type__c == 'Volume Review Only'){
                        reacBid.add(bid.Id);
                        reacWrap.pendingProposals = reacWrap.pendingProposals+1;
                        if(bidLine.Phoenix_Proposed_Sales__c != null){                             
                            reacWrap.pendingProposalsSum += bidLine.Phoenix_Proposed_Sales__c; 
                        } 
                    }
                }
                
            }
        }
        
        
        List<Phoenix_Customer_Response_Line__c> InternalTimeList = new  List<Phoenix_Customer_Response_Line__c>();
        
        
        //InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number'];      
        if(selectedDate == 'Submitted Date' && selectedRange == 'Custom' && startDate != null && endDate != null){       InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c >=: startDate AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=: endDate LIMIT 2000];      
 
            
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'Custom' && startDate != null && endDate != null){ InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c >=: startDate AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c <=: endDate LIMIT 2000];      

            
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'THIS_FISCAL_YEAR'){
            InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = THIS_FISCAL_YEAR];      
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'THIS_YEAR'){
            InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = THIS_YEAR];      
        }
        
        else if(selectedDate == 'Submitted Date' && selectedRange == 'THIS_QUARTER'){    InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = THIS_QUARTER];      
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'THIS_MONTH'){        InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = THIS_MONTH];      
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'THIS_WEEK'){     InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = THIS_WEEK];      
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'LAST_FISCAL_YEAR'){    InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = LAST_FISCAL_YEAR];      
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'LAST_YEAR'){ InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = LAST_YEAR];      
        }
        
        else if(selectedDate == 'Submitted Date' && selectedRange == 'LAST_QUARTER'){     InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = LAST_QUARTER];      
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'LAST_MONTH'){ InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = LAST_MONTH];      
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'LAST_WEEK'){   InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = LAST_WEEK];      
        }
        else  if(selectedDate == 'Sent to Customer Date' && selectedRange == 'THIS_FISCAL_YEAR'){   InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = THIS_FISCAL_YEAR];      
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'THIS_YEAR'){     InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = THIS_YEAR];      
        }
        
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'THIS_QUARTER'){  InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = THIS_QUARTER];      
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'THIS_MONTH'){      InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = THIS_MONTH];      
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'THIS_WEEK'){    InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = THIS_WEEK];      
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'LAST_FISCAL_YEAR'){    InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = LAST_FISCAL_YEAR];      
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'LAST_YEAR'){     InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = LAST_YEAR];      
        }
        
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'LAST_QUARTER'){   InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = LAST_QUARTER];      
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'LAST_MONTH'){
            InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = LAST_MONTH];      
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'LAST_WEEK'){
            InternalTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Customer_Response_Duration__c FROM Phoenix_Customer_Response_Line__c WHERE Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number' AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = LAST_WEEK];      
        }
        
        List<String> stepNameList = new List<String>(); 
        stepNameList.add('Initial Submission');
        stepNameList.add('Contract Team'+ '\''+'s Action');
        stepNameList.add('Supply Chain Approval');
        stepNameList.add('Vistex Update');
        
        List<Phoenix_Bid_Process_Steps__c> CRTimeList = new List<Phoenix_Bid_Process_Steps__c>();
        
        // CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') ];      
          if(selectedDate == 'Submitted Date' && selectedRange == 'Custom' && startDate != null && endDate != null){      CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c >=: startDate AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c <=: endDate AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId  LIMIT 2000];      

            
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'Custom' && startDate != null && endDate != null){  CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c >=: startDate AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c <=: endDate AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId LIMIT 2000];      

            
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'THIS_FISCAL_YEAR'){
            CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = THIS_FISCAL_YEAR AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'THIS_YEAR'){
            CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = THIS_YEAR AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        
        else if(selectedDate == 'Submitted Date' && selectedRange == 'THIS_QUARTER'){   CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = THIS_QUARTER AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'THIS_MONTH'){   CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = THIS_MONTH AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'THIS_WEEK'){   CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = THIS_WEEK AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'LAST_FISCAL_YEAR'){   CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = LAST_FISCAL_YEAR AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'LAST_YEAR'){  CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = LAST_YEAR AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        
        else if(selectedDate == 'Submitted Date' && selectedRange == 'LAST_QUARTER'){     CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = LAST_QUARTER AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'LAST_MONTH'){  CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = LAST_MONTH AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        else if(selectedDate == 'Submitted Date' && selectedRange == 'LAST_WEEK'){     CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Bid_Submitted_Date__c = LAST_WEEK AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        else   if(selectedDate == 'Sent to Customer Date' && selectedRange == 'THIS_FISCAL_YEAR'){      CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = THIS_FISCAL_YEAR AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'THIS_YEAR'){     CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = THIS_YEAR AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'THIS_QUARTER'){    CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = THIS_QUARTER AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'THIS_MONTH'){      CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = THIS_MONTH AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'THIS_WEEK'){ CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = THIS_WEEK AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'LAST_FISCAL_YEAR'){    CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = LAST_FISCAL_YEAR AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'LAST_YEAR'){      CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = LAST_YEAR AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'LAST_QUARTER'){   CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = LAST_QUARTER AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'LAST_MONTH'){
            CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = LAST_MONTH AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        else if(selectedDate == 'Sent to Customer Date' && selectedRange == 'LAST_WEEK'){
            CRTimeList = [SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c, Internal_Approver_Duration__c FROM Phoenix_Bid_Process_Steps__c WHERE Internal_Approver_Duration__c != Null  AND (Name LIKE '%Initial Submission%' OR Name LIKE '%Supply Chain Approval%' OR Name LIKE '%Vistex Update%' OR Name LIKE '%Contract Team%') AND Phoenix_Bid__r.Phoenix_Sent_to_Customer_Date__c = LAST_WEEK AND Phoenix_Bid__r.Phoenix_Customer__r.OwnerId =: teamMemberId];      
        }
        
        
        Integer InternalDurationAcqcount = 0;
        Decimal InternalDurationAcq = 0;
        Integer CRAcqcount = 0;
        Decimal CRAcqAcq = 0;
        Integer InternalDurationRetcount = 0;
        Decimal InternalDurationRet = 0;
        Integer CRRetcount = 0;
        Decimal CRRet = 0;
        Integer InternalDurationProcount = 0;
        Decimal InternalDurationPro = 0;
        Integer CRProcount = 0;
        Decimal CRPro = 0;
        Integer InternalDurationReaccount = 0;
        Decimal InternalDurationReac = 0;
        Integer CRReaccount = 0;
        Decimal CRReac = 0;
        if(InternalTimeList.size() != 0){
            for(Phoenix_Customer_Response_Line__c CRLine : InternalTimeList ){
                if (CRLine.Customer_Response_Duration__c != null ) {      InternalDuration += CRLine.Customer_Response_Duration__c;   
                                                                   }
                //acq             
                if(CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Customer' || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Product Launch'  || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB'  || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB'  || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Addition'  || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids'  || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update' || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'IPA Member Addition' || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'SRx IPA Product Addition' || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'|| CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'|| CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RCA Member Addition' ||  CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'SRx IPA Price Change'  ||  CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only'){  if (CRLine.Customer_Response_Duration__c != null ) {  InternalDurationAcq += CRLine.Customer_Response_Duration__c;     InternalDurationAcqcount = InternalDurationAcqcount +1;
                                                                       }   
                }   
                //retention
                if(CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids'  || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update'  || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update'  || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'SRx IPA Price Change'  || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'){   if (CRLine.Customer_Response_Duration__c != null ) {   InternalDurationRet += CRLine.Customer_Response_Duration__c;   InternalDurationRetcount = InternalDurationRetcount +1;
                                                                       } 
                }
                //Proactive
                if(CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Mass Product Removals' || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Customer' || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Product Launch' || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB'  || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB' || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Addition'  || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Discontinuation Process'  || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'SRx IPA Price Change'|| CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update' || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'IPA Member Addition' || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'SRx IPA Product Addition'|| CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'|| CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'|| CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RCA Member Addition' ||  CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only'){     if (CRLine.Customer_Response_Duration__c != null ) { InternalDurationPro += CRLine.Customer_Response_Duration__c;   InternalDurationProcount = InternalDurationProcount +1;
                                                                       }
                }                     
                //Reactive
                if(CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB'  || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB' || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change'  || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Addition'  || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids'|| CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'SRx IPA Price Change' || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'SRx IPA Product Addition' || CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'||  CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change' ||  CRLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only' ){    if (CRLine.Customer_Response_Duration__c != null) { InternalDurationReac += CRLine.Customer_Response_Duration__c;     InternalDurationReaccount = InternalDurationReaccount +1;
                                                                      } 
                }
            }
            
        }
        
        
        if(CRTimeList.size() != 0){
            for(Phoenix_Bid_Process_Steps__c step : CRTimeList ){
                if (step.Internal_Approver_Duration__c != null) {   CRDuration += step.Internal_Approver_Duration__c;      
                } 
                //acq 
                if(step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Customer' || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Product Launch'  || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB'  || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB'  || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Addition'  || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids'  || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update'  || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update' || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'IPA Member Addition' || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'SRx IPA Product Addition' || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'|| step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'|| step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RCA Member Addition' ||  step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'SRx IPA Price Change'  ||  step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only'){      if (step.Internal_Approver_Duration__c != null ) {                 CRAcqcount = CRAcqcount +1;          CRAcqAcq += step.Internal_Approver_Duration__c;  
                        
                    }   
                }    
                //ret
                if(step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids'  || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update'  || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update'  || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'SRx IPA Price Change'  || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'){     if (step.Internal_Approver_Duration__c != null ) {   CRRetcount = CRRetcount +1;            CRRet += step.Internal_Approver_Duration__c;  
                        
                    }  
                }
                //Proactive
                if(step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Mass Product Removals' || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Customer' || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Product Launch' || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB'  || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB' || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Addition'  || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Discontinuation Process'  || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'SRx IPA Price Change'|| step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update' || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'IPA Member Addition' || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'SRx IPA Product Addition'|| step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'|| step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change'|| step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RCA Member Addition'  ||  step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only'){       if (step.Internal_Approver_Duration__c != null ) {  CRPro += step.Internal_Approver_Duration__c;      CRProcount = CRProcount +1;
                    }
                }                     
                //Reactive
                if(step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB'  || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB' || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change'  || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Addition'  || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids'|| step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update' || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'SRx IPA Price Change' || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'SRx IPA Product Addition' || step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'NEW Individual Pricing Agreement (IPA)'||  step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RCA/IPA Member GPO or Wholesaler Change' ||  step.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only'){   if (step.Internal_Approver_Duration__c != null ) {    CRReac += step.Internal_Approver_Duration__c;        CRReaccount = CRReaccount +1;
                    }
                }
            }   
        }
        
        if(InternalTimeList.size() != 0){   wrapperObject.avgCRTime = InternalDuration/InternalTimeList.size(); 
                                         
                                        }
        //acq 
        if(InternalDurationAcqcount != 0){  acqWrap.avgCRTime = InternalDurationAcq/InternalDurationAcqcount;
                                         }
        //ret 
        if(InternalDurationRetcount != 0){   retWrap.avgCRTime = InternalDurationRet/InternalDurationRetcount;
                                         }
        //Proactive
        if(InternalDurationProcount != 0){   proWrap.avgCRTime = InternalDurationPro/InternalDurationProcount;
                                         }
        
        //Reactive
        if(InternalDurationReaccount != 0){   reacWrap.avgCRTime = InternalDurationReac/InternalDurationReaccount;
                                          }
        if(CRTimeList.size() != 0){   wrapperObject.avgInternalTime = CRDuration/CRTimeList.size(); 
                                  }
        //acq 
        if(CRAcqcount != 0){   acqWrap.avgInternalTime = CRAcqAcq/CRAcqcount;
                           }
        //ret 
        if(CRRetcount != 0){  retWrap.avgInternalTime = CRRet/CRRetcount;
                           }
        //Proactive
        if(CRProcount != 0){   proWrap.avgInternalTime = CRPro/CRProcount;
                           }
        //Reactive
        if(CRReaccount != 0){   reacWrap.avgInternalTime = CRReac/CRReaccount;
                            }
        //    wrapperObject.avgInternalTime = avgInternalTime;
        //   wrapperObject.avgCRTime = avgCRTime;
        
        
        if(wrapperObject.bidLinesWonSum != null && wrapperObject.bidLinesWonSum != 0 && wrapperObject.bidLinesLostSum != null && wrapperObject.bidLinesLostSum != 0){
            wrapperObject.winRate =  (wrapperObject.bidLinesWonSum)/ (wrapperObject.bidLinesWonSum+wrapperObject.bidLinesLostSum);
            wrapperObject.winRateLineItem =  Decimal.valueOf(wrapperObject.bidLinesWon)/ Decimal.valueOf(wrapperObject.bidLinesWon+wrapperObject.bidLinesLost);
            
        }
        //acq 
        if(acqWrap.bidLinesWonSum != null && acqWrap.bidLinesWonSum != 0 && acqWrap.bidLinesLostSum != null && acqWrap.bidLinesLostSum != 0){
            acqWrap.winRate =  (acqWrap.bidLinesWonSum)/(acqWrap.bidLinesWonSum+acqWrap.bidLinesLostSum);
            acqWrap.winRateLineItem =   Decimal.valueOf(acqWrap.bidLinesWon)/ Decimal.valueOf(acqWrap.bidLinesWon+acqWrap.bidLinesLost);
        }
        //retrntion 
        if(retWrap.bidLinesWonSum != null && retWrap.bidLinesWonSum != 0 && retWrap.bidLinesLostSum != null && retWrap.bidLinesLostSum != 0){    retWrap.winRate =  (retWrap.bidLinesWonSum)/ (retWrap.bidLinesWonSum+retWrap.bidLinesLostSum);  retWrap.winRateLineItem = Decimal.valueOf(retWrap.bidLinesWon)/ Decimal.valueOf(retWrap.bidLinesWon+retWrap.bidLinesLost);                                                                                                                
        }
        //proactive
        if(proWrap.bidLinesWonSum != null && proWrap.bidLinesWonSum != 0 && proWrap.bidLinesLostSum != null && proWrap.bidLinesLostSum != 0){
            proWrap.winRate =  (proWrap.bidLinesWonSum)/(proWrap.bidLinesWonSum+proWrap.bidLinesLostSum);
            proWrap.winRateLineItem =  Decimal.valueOf(proWrap.bidLinesWon)/ Decimal.valueOf(proWrap.bidLinesWon+proWrap.bidLinesLost);
        }
        //reactive 
        if(reacWrap.bidLinesWonSum != null && reacWrap.bidLinesWonSum != 0 && reacWrap.bidLinesLostSum != null && reacWrap.bidLinesLostSum != 0){
            reacWrap.winRate =  (reacWrap.bidLinesWonSum)/(reacWrap.bidLinesWonSum+reacWrap.bidLinesLostSum);
            reacWrap.winRateLineItem =  Decimal.valueOf(reacWrap.bidLinesWon)/ Decimal.valueOf(reacWrap.bidLinesWon+reacWrap.bidLinesLost);
        }
        wrapperObject.totalBidLinesSum = wrapperObject.bidLinesWonSum+wrapperObject.bidLinesLostSum+wrapperObject.bidLinesPendingSum+wrapperObject.bidLinesPendingInternalSum+wrapperObject.pendingProposalsSum;
        acqWrap.totalBidLinesSum = acqWrap.bidLinesWonSum+acqWrap.bidLinesLostSum+acqWrap.bidLinesPendingSum+acqWrap.bidLinesPendingInternalSum+acqWrap.pendingProposalsSum;
        retWrap.totalBidLinesSum = retWrap.bidLinesWonSum+retWrap.bidLinesLostSum+retWrap.bidLinesPendingSum+retWrap.bidLinesPendingInternalSum+retWrap.pendingProposalsSum;
        proWrap.totalBidLinesSum = proWrap.bidLinesWonSum+proWrap.bidLinesLostSum+proWrap.bidLinesPendingSum+proWrap.bidLinesPendingInternalSum+proWrap.pendingProposalsSum;
        reacWrap.totalBidLinesSum = reacWrap.bidLinesWonSum+reacWrap.bidLinesLostSum+reacWrap.bidLinesPendingSum+reacWrap.bidLinesPendingInternalSum+reacWrap.pendingProposalsSum;
        
        acqWrap.TotalBidIds = acqBid.size();
        retWrap.TotalBidIds = retBid.size();
        proWrap.TotalBidIds = proBid.size();
        reacWrap.TotalBidIds = reacBid.size();
        Wrapper newWrapper = new Wrapper();
        newWrapper.Summary = wrapperObject;
        newWrapper.acquisition = acqWrap;
        newWrapper.retention = retWrap;
        newWrapper.proactive = proWrap;
        newWrapper.reactive = reacWrap;
        //   newWrapper.picklistValues = subOrdinatesList;
        system.debug('wrapperObject----'+newWrapper.retention);
        system.debug('Winrate----'+newWrapper);
        return newWrapper;
        
    }
    public class Wrapper {
        @AuraEnabled public MainWrapper Summary;
        @AuraEnabled public MainWrapper acquisition;
        @AuraEnabled public MainWrapper retention;
        @AuraEnabled public MainWrapper proactive;
        @AuraEnabled public MainWrapper reactive;
        @AuraEnabled public List<User> picklistValues;
        public Wrapper(){
            Summary = new MainWrapper(); 
            acquisition = new MainWrapper();
            retention = new MainWrapper();
            proactive = new MainWrapper();
            reactive = new MainWrapper();
            picklistValues =new List<User>();
        }
        
    } 
    public class MainWrapper {
        
        @AuraEnabled public String userName = '';
        @AuraEnabled public Decimal InternalProcessTimeBenchmark;
        @AuraEnabled public Decimal CRTimeBenchmark;
        @AuraEnabled public String accountName;
        @AuraEnabled public Integer bidLinesWon =0;
        @AuraEnabled public Decimal bidLinesWonSum =0;
        @AuraEnabled public Integer bidLinesLost =0;
        @AuraEnabled public Decimal bidLinesLostSum =0;
        @AuraEnabled public Integer bidLinesPendingInternal =0;
        @AuraEnabled public Decimal bidLinesPendingInternalSum =0;
        @AuraEnabled public Integer bidLinesPending =0;
        @AuraEnabled public Decimal bidLinesPendingSum =0;
        @AuraEnabled public Integer pendingProposals =0;
        @AuraEnabled public Decimal pendingProposalsSum =0;
        @AuraEnabled public Decimal avgInternalTime =0;
        @AuraEnabled public Decimal winRate =0;
        @AuraEnabled public Decimal winRateLineItem =0;
        @AuraEnabled public Decimal avgCRTime =0;
        @AuraEnabled public Integer TotalBidIds =0;
        @AuraEnabled public Decimal totalBidLinesSum =0;  
        public MainWrapper(){
            
        }
    }*/
   
    
}