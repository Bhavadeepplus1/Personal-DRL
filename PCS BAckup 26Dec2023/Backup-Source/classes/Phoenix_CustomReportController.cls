public class Phoenix_CustomReportController {
  /*   @AuraEnabled
   public static Wrapper getRelatedList(Date startDate, Date endDate){
         
        Wrapper wrapperObject = new Wrapper();
        Integer currentYear = System.Today().year();
        Integer currentMonth = System.Today().month()-1;
        List<Integer> years = new List<Integer>{(currentYear-1), currentYear};
        List<String> months = new List<String>{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
        List<String> listOfMonths = new List<String>();
        List<Map<String, List<Phoenix_Bid__c>>> completedWithin2Days = new List<Map<String, List<Phoenix_Bid__c>>>();
        List<Map<String, List<Phoenix_Bid__c>>> completedWithin3_5Days = new List<Map<String, List<Phoenix_Bid__c>>>();
        List<Map<String, List<Phoenix_Bid__c>>> completedWithin6_10Days = new List<Map<String, List<Phoenix_Bid__c>>>();
        List<Map<String, List<Phoenix_Bid__c>>> completedMoreThan10Days = new List<Map<String, List<Phoenix_Bid__c>>>();
        Map<String, Integer> countMap = new Map<String, Integer>();
        Map<String, List<Phoenix_Bid__c>> mapOfBids =  new Map<String, List<Phoenix_Bid__c>>();
        List<Integer> listOfCounts =  new List<Integer>();
        List<Phoenix_Bid__c> bids = new List<Phoenix_Bid__c>();
        String close = 'Closed';
        //bids = Database.query('Select' + Phoenix_Util.bidFields+ 'FROM Phoenix_Bid__c where Phoenix_Bid_Submitted_Date__c > LAST_N_YEARS:1 ORDER BY Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000');   
        bids = Database.query('Select' + Phoenix_Util.bidFields+ 'FROM Phoenix_Bid__c where Phoenix_Bid_Submitted_Date__c >=: startDate AND Phoenix_Bid_Submitted_Date__c <=: endDate AND Phoenix_Approval_Status__c =: close ORDER BY Phoenix_Bid_Submitted_Date__c ASC LIMIT 20000');   
        
        if(startDate.year() == endDate.year()){
            for(Integer j=startDate.month()-1; j<endDate.month(); j++){
                listOfMonths.add(months[j]+', '+startDate.year());
            }
        } else if(endDate.year() > startDate.year()){
            Integer diff = endDate.year() - startDate.year();
            for(Integer j=startDate.month()-1; j<months.size(); j++){
                listOfMonths.add(months[j]+', '+startDate.year());
            }
            for(Integer m=1; m<=diff; m++){
                if(m == diff){
                    for(Integer i=0; i<endDate.month(); i++){
                        listOfMonths.add(months[i]+', '+endDate.year());
                    }
                } else{
                    for(Integer k=0; k<months.size(); k++){
                        listOfMonths.add(months[k]+', '+(startDate.year()+m));
                    }     
                }   
            }
        }
        for(String mon: listOfMonths){   
            List<Phoenix_Bid__c> listOfBids = new List<Phoenix_Bid__c>();
            List<Phoenix_Bid__c> twoDaysLst = new List<Phoenix_Bid__c>();
            List<Phoenix_Bid__c> in3_5DaysLst = new List<Phoenix_Bid__c>();
            List<Phoenix_Bid__c> in6_10DaysLst = new List<Phoenix_Bid__c>();
            List<Phoenix_Bid__c> moreThan10DaysLst = new List<Phoenix_Bid__c>();
            Map<String, List<Phoenix_Bid__c>> twoDays = new Map<String, List<Phoenix_Bid__c>>();
            
            Map<String, List<Phoenix_Bid__c>> in3_5Days = new  Map<String, List<Phoenix_Bid__c>>();
             Map<String, List<Phoenix_Bid__c>> in6_10Days = new  Map<String, List<Phoenix_Bid__c>>();
             Map<String, List<Phoenix_Bid__c>> moreThan10Days = new  Map<String, List<Phoenix_Bid__c>>();
            Map<String, Integer> bidMap = new Map<String, Integer>();
            for(Phoenix_Bid__c bid: bids){
                Datetime d = bid.Phoenix_Bid_Submitted_Date__c;
                Date dT = Date.newInstance(d.year(), d.month(), d.day());
                Date closed = bid.Phoenix_Sent_to_Customer_Date__c;
                
                String customKey = months[d.month()-1]+', '+d.year();
                system.debug('closed-->'+closed);
                if(customKey == mon){
                    listOfBids.add(bid);
                    if(closed != null){
                        if(dT.daysBetween(closed) >= 0 && dT.daysBetween(closed) <= 2){
                            twoDaysLst.add(bid);
                            //system.debug('mon---'+mon);
                        } else if(dT.daysBetween(closed) > 2 && dT.daysBetween(closed) <= 5){
                            in3_5DaysLst.add(bid);
                        } else if(dT.daysBetween(closed) > 5 && dT.daysBetween(closed) <= 10){
                            in6_10DaysLst.add(bid);
                        } else if(dT.daysBetween(closed) > 10){
                            moreThan10DaysLst.add(bid);
                        } else{
                            system.debug('Else');
                        }
                    }
                }
            }
            countMap.put(mon, listOfBids.size()); //Total Submitted bids for each month
            listOfCounts.add(listOfBids.size());
            mapOfBids.put(mon, listOfBids);
            
                        twoDays.put('count', twoDaysLst);

            completedWithin2Days.add(twoDays);
            
            in3_5Days.put('count', in3_5DaysLst);
            completedWithin3_5Days.add(in3_5Days);
            
            in6_10Days.put('count', in6_10DaysLst);
            completedWithin6_10Days.add(in6_10Days);
            
            moreThan10Days.put('count', moreThan10DaysLst);
            completedMoreThan10Days.add(moreThan10Days);
        }
        wrapperObject.bids = bids;
        wrapperObject.listOfMonths = listOfMonths;
        wrapperObject.countMap = countMap;
        wrapperObject.listOfCounts = listOfCounts;
        wrapperObject.completedWithin2Days = completedWithin2Days;
        wrapperObject.completedWithin3_5Days = completedWithin3_5Days;
        wrapperObject.completedWithin6_10Days = completedWithin6_10Days;
        wrapperObject.completedMoreThan10Days = completedMoreThan10Days;
       
        return wrapperObject;
    }
    
    
    public class Wrapper {
        
        @AuraEnabled public List < Phoenix_Bid__c > bids;
        @AuraEnabled public List<String> listOfMonths;
        @AuraEnabled public Map<String, Integer> countMap;
        @AuraEnabled public List<Integer> listOfCounts;
        
        
        @AuraEnabled public List<Map<String, List<Phoenix_Bid__c>>> completedWithin2Days;
        @AuraEnabled public List<Map<String, List<Phoenix_Bid__c>>>completedWithin3_5Days;
        @AuraEnabled public List<Map<String, List<Phoenix_Bid__c>>> completedWithin6_10Days;
        @AuraEnabled public List<Map<String, List<Phoenix_Bid__c>>> completedMoreThan10Days;
        
        Wrapper() {
            
            bids = new List < Phoenix_Bid__c > ();
            listOfMonths = new List<String>();
            countMap = new Map<String, Integer>();
            listOfCounts = new List<Integer>();
            completedWithin2Days = new List<Map<String, List<Phoenix_Bid__c>>>();
            completedWithin3_5Days = new List<Map<String, List<Phoenix_Bid__c>>>();
            completedWithin6_10Days = new List<Map<String, List<Phoenix_Bid__c>>>();
            completedMoreThan10Days = new List<Map<String, List<Phoenix_Bid__c>>>();
        }
    } */
}