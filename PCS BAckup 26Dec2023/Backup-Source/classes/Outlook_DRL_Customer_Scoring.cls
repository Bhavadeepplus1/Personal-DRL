public class Outlook_DRL_Customer_Scoring {
    @AuraEnabled
    public static List<WrapperCls> getContactScores(){
        //try{
       
        String userId = userInfo.getUserId();//'00541000005LkvBAAS';
        List<WrapperCls> wrapperList = new List<WrapperCls>();
        List<Contact> contactList= new List<Contact>();
        List<Phoenix_Bid_Line_Item__c> bidLines = new List<Phoenix_Bid_Line_Item__c>();
        Set<Id> bidIds = new Set<Id>();
        contactList = [Select Id, (Select Id, Phoenix_Bid_Type__c FROM Bids__r Where Phoenix_Approval_Status__c!='Draft' and Phoenix_Approval_Status__c!='On Hold'),AccountId,Account.Name,Affinity_Score__c,Authority__c,Contact_Role__c,Department,Influence_Score__c,Name,OwnerId,Title From Contact Where OwnerId = : userId and (Affinity_Score__c = null or Authority__c = null or Influence_Score__c = null)  order By Name Asc];
        system.debug('contactList-----'+contactList.size()); 
        for(Contact con : contactList){
            if(con.Bids__r != null && con.Bids__r.size()>0){
                for(Phoenix_Bid__c bid: con.Bids__r){
                    bidIds.add(bid.Id);
                   
                }
            }
        }
        bidLines = [Select Id,Name,Phoenix_DeadNet_TrckGR__c,Phoenix_Bid__r.Phoenix_Contact__c, Phoenix_Bid__r.Phoenix_Bid_Type__c,Phoenix_Bid_Status__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =: bidIds];
        Map<Id , Decimal> bidLinesWon = new Map<Id , Decimal>();
        Map<Id , Decimal> bidLinesLost = new Map<Id , Decimal>();
        Map<Id , Decimal> bidLinesWonNew = new Map<Id , Decimal>();
        Map<Id , Decimal> bidLinesWonRetained = new Map<Id , Decimal>();
        Map<Id , Decimal> bidLinesLostNew = new Map<Id , Decimal>();
        Map<Id , Decimal> bidLinesLostExisting = new Map<Id , Decimal>();
        for(Phoenix_Bid_Line_Item__c bidLine : bidLines){
            system.debug('test bid status--->'+bidLine.Phoenix_Bid_Status__c);
            system.debug('test bid type--->'+bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c);
            system.debug('test bid dead net tracking gr--->'+bidLine.Phoenix_DeadNet_TrckGR__c+'---test bid status--->'+bidLine.Phoenix_Bid_Status__c);
            
            if(bidLine.Phoenix_Bid_Status__c == 'Awarded'){
                
                if(bidLinesWon.containskey(bidLine.Phoenix_Bid__r.Phoenix_Contact__c)){
                    Decimal curVal = bidLinesWon.get(bidLine.Phoenix_Bid__r.Phoenix_Contact__c); String bidId=bidLine.Id; curVal +=1; bidLinesWon.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,curVal);
                }else{
                    bidLinesWon.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,1);
                }
                
                if(bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='New Customer'||bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='New Product Launch'||
                   bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Good Dated OTB'||bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Short Dated OTB'||bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Platform OTB'||bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Platform OTB')
                    
                { 
                    if(bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c!='RFP Bids'&& bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c!='Product Addition'){                        if(bidLinesWonNew.containskey(bidLine.Phoenix_Bid__r.Phoenix_Contact__c)){ Decimal curValNew = bidLinesWonNew.get(bidLine.Phoenix_Bid__r.Phoenix_Contact__c); curValNew +=1; bidLinesWonNew.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,curValNew);
                        }else{
                            bidLinesWonNew.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,1);
                        }
                        
                    }
                }
                
                
                else if(bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Price Change'||bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Volume Review Only'||bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Customer Rebate Change'||bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Sales Out Rebate')
                {
                    system.debug('bid line WOn Existing Line Item'+bidLine.Name);
                    if(bidLinesWonRetained.containskey(bidLine.Phoenix_Bid__r.Phoenix_Contact__c)){ Decimal curVal = bidLinesWonRetained.get(bidLine.Phoenix_Bid__r.Phoenix_Contact__c); String bidId=bidLine.Id; curVal +=1; bidLinesWonRetained.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,curVal);
                    }else{
                        bidLinesWonRetained.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,1);
                    }
                    
                }
                if((bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='RFP Bids'||bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Product Addition' )&&(bidLine.Phoenix_DeadNet_TrckGR__c>0 && bidLine.Phoenix_DeadNet_TrckGR__c>0)){
                    system.debug('bid line WOn Existing Line Item'+bidLine.Name);
                    if(bidLinesWonRetained.containskey(bidLine.Phoenix_Bid__r.Phoenix_Contact__c)){
                        Decimal curVal = bidLinesWonRetained.get(bidLine.Phoenix_Bid__r.Phoenix_Contact__c);
                        curVal +=1;
                        bidLinesWonRetained.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,curVal);
                    }else{
                        bidLinesWonRetained.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,1);
                    }
                }
                else if (bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='RFP Bids'||bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Product Addition'){
                    system.debug('bid line WOnnew Line Item'+bidLine.Name);
                    if(bidLinesWonNew.containskey(bidLine.Phoenix_Bid__r.Phoenix_Contact__c)){
                        Decimal curVal = bidLinesWonNew.get(bidLine.Phoenix_Bid__r.Phoenix_Contact__c);
                        curVal +=1;
                        bidLinesWonNew.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,curVal);
                    }else{
                        bidLinesWonNew.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,1);
                    }
                    
                }
                
                
                
            }
            else if(bidLine.Phoenix_Bid_Status__c ==  'Declined by Customer' || bidLine.Phoenix_Bid_Status__c == 'DRL Rescinded'){
                if(bidLinesLost.containskey(bidLine.Phoenix_Bid__r.Phoenix_Contact__c)){
                    Decimal curVal = bidLinesLost.get(bidLine.Phoenix_Bid__r.Phoenix_Contact__c);
                    curVal +=1;
                    bidLinesLost.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,curVal);
                }else{
                    bidLinesLost.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,1);
                }
                
                if(bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='New Customer'||bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='New Product Launch'||
                   bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Good Dated OTB'||bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Short Dated OTB'||bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Platform OTB'||bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Platform OTB'){
                       if(bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c!='RFP Bids'&& bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c!='Product Addition'){
                           
                           if(bidLinesLostNew.containskey(bidLine.Phoenix_Bid__r.Phoenix_Contact__c)){
                               Decimal curVal = bidLinesLostNew.get(bidLine.Phoenix_Bid__r.Phoenix_Contact__c);
                               curVal +=1;
                               bidLinesLostNew.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,curVal);
                           }else{
                               bidLinesLostNew.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,1);
                           }
                           
                           
                       }
                   }
                
                else if(bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Price Change'||bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Volume Review Only'||bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Customer Rebate Change'||bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Sales Out Rebate')
                {
                    if(bidLinesLostExisting.containskey(bidLine.Phoenix_Bid__r.Phoenix_Contact__c)){
                        Decimal curVal = bidLinesLostExisting.get(bidLine.Phoenix_Bid__r.Phoenix_Contact__c);
                        curVal +=1;
                        bidLinesLostExisting.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,curVal);
                    }else{
                        bidLinesLostExisting.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,1);
                    }
                }
                if((bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='RFP Bids'||bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Product Addition' )&&(bidLine.Phoenix_DeadNet_TrckGR__c>0 && bidLine.Phoenix_DeadNet_TrckGR__c>0)){
                    system.debug('bid line WOn Existing Line Item'+bidLine.Name);
                    if(bidLinesLostExisting.containskey(bidLine.Phoenix_Bid__r.Phoenix_Contact__c)){
                        Decimal curVal = bidLinesLostExisting.get(bidLine.Phoenix_Bid__r.Phoenix_Contact__c);
                        curVal +=1;
                        bidLinesLostExisting.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,curVal);
                    }else{
                        bidLinesLostExisting.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,1);
                    }
                }
                else if (bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='RFP Bids'||bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c=='Product Addition'){
                    system.debug('bid line WOnnew Line Item'+bidLine.Name);
                    if(bidLinesLostNew.containskey(bidLine.Phoenix_Bid__r.Phoenix_Contact__c)){
                        Decimal curVal = bidLinesLostNew.get(bidLine.Phoenix_Bid__r.Phoenix_Contact__c);
                        curVal +=1;
                        bidLinesLostNew.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,curVal);
                    }else{
                        bidLinesLostNew.put(bidLine.Phoenix_Bid__r.Phoenix_Contact__c,1);
                    }
                    
                }
                
                
                
            }
        }
       
        for(Contact con : contactList){
            WrapperCls wrObj = new WrapperCls();
            wrObj.con=con;
            Decimal wonBidLines;
            Decimal lostBidLines;
            Decimal wonBidLinesNew;
            Decimal wonBidLinesRetained;
            Decimal lostBidLinesNew;
            Decimal lostBidLinesExisting;
            if((bidLinesWon.get(con.Id))!=null){
                wonBidLines = bidLinesWon.get(con.Id);
               
            }
            else{
                wonBidLines=0;
                
            }
            if((bidLinesLost.get(con.Id))!=null){
                lostBidLines = bidLinesLost.get(con.Id);
                
            }
            else{
                lostBidLines = 0;
                
            }
            if((bidLinesWonNew.get(con.Id))!=null){
                wonBidLinesNew = bidLinesWonNew.get(con.Id);
                
            }
            else{
                wonBidLinesNew=0;
                
            }
            if((bidLinesWonRetained.get(con.Id))!=null){
                wonBidLinesRetained = bidLinesWonRetained.get(con.Id);
                
            }
            else{
                wonBidLinesRetained=0;
                
            }
            if((bidLinesLostNew.get(con.Id))!=null){
                lostBidLinesNew = bidLinesLostNew.get(con.Id);
                
            }
            else{
                lostBidLinesNew=0;
                
            }
            if((bidLinesLostExisting.get(con.Id))!=null){
                lostBidLinesExisting = bidLinesLostExisting.get(con.Id);
               
            }
            else{
                lostBidLinesExisting=0;
                
            }
            
            
            //if(con.Bids__r != null && con.Bids__r.size()>0)
            wrObj.numberofBids = con.Bids__r.size();
            wrObj.newBidsWon=wonBidLinesNew;
            
            wrObj.retainedBidsWon=wonBidLinesRetained;
            wrObj.newBidsLost=lostBidLinesNew;
            wrObj.existingsBidsLost=lostBidLinesExisting;
           
            Decimal wonLost=wonBidLines+lostBidLines;
          if(wonLost!=0){
                Decimal winRate=wonBidLines/wonLost;
                Decimal winRatePercent=winRate*100;
                Decimal roundWinrate=winRatePercent.setScale(2);
                wrObj.winRatePercent = roundWinrate;
                
            }
            wrapperList.add(wrObj);}
        
        return wrapperList;
        //}
        //catch(Exception ex){
       
        // return null;
        //}
    }
    @auraEnabled
    public static contact updateContact(contact contactObj,String Department,String Title,String contactRole){
        contactObj.Department = Department;
        contactObj.Title = Title;
        contactObj.Contact_Role__c = contactRole;
        update contactObj;
        return contactObj; 
    }
    @auraEnabled
    public static contact updateInfluenceScore(contact contactObj,Integer influenceScore){
        contactObj.Influence_Score__c = influenceScore;
        update contactObj;
        return contactObj; 
    }
    @auraEnabled
    public static contact updateAffinityScore(contact contactObj,Integer affinityScore){
        contactObj.Affinity_Score__c = affinityScore;
        update contactObj;
        return contactObj; 
    }
    @auraEnabled
    public static contact updateAuthScore(contact contactObj,Integer authScore){
        contactObj.Authority__c = authScore;
        update contactObj;
        return contactObj; 
    }
    @auraEnabled
    public static contact getBids(contact contactObj,Integer authScore){
        contactObj.Authority__c = authScore;
        update contactObj;
        return contactObj; 
    }
    public class WrapperCls{
        @auraEnabled public Contact con;
        @auraEnabled public Integer numberofBids;
        @auraEnabled public Decimal winRatePercent;
        @auraEnabled public Decimal newBidsWon;
        @auraEnabled public Decimal retainedBidsWon;
        @auraEnabled public Decimal newBidsLost;
        @auraEnabled public Decimal existingsBidsLost;
        WrapperCls(){
            con = new Contact();
            numberofBids=0;
            winRatePercent=0;
            newBidsWon=0;
            retainedBidsWon=0;
            newBidsLost=0;
            existingsBidsLost=0;
            
            
            
        }
    }
}