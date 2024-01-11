public class Vision_Product_Tracker {
    @AuraEnabled
    public static MainWrapper getRecent(String recordId){
        Integer currentYear = system.now().year();
        string s1=string.valueof(currentYear).right(2);
        //String Year1= Integer.valueof(s1);
        //code for recent primary awards start
        List<Phoenix_Bid_Line_Item__c> bidLinesList = [SELECT ID,Phoenix_Product__r.Name, Phoenix_Proposed_Sales__c, Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Phoenix_Customer__c =: recordId AND Phoenix_Bid_Status__c = 'Awarded' AND (Phoenix_Bid__r.Phoenix_Bid_Type__c = 'Product Addition' OR Phoenix_Bid__r.Phoenix_Bid_Type__c = 'RFP Bids') ORDER BY Phoenix_Product__r.Name];
        List<Phoenix_Bid_Line_Item__c> bidLinesRecentDecreasesList = [SELECT ID,Phoenix_Product__r.Name, Phoenix_Proposed_Sales__c, Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Phoenix_Customer__c =: recordId AND Phoenix_Bid_Status__c = 'Awarded' AND Phoenix_Bid__r.Phoenix_Bid_Type__c = 'Price Change' ORDER BY Phoenix_Product__r.Name];
        List<Phoenix_Bid_Line_Item__c> bidLinesProductLosesList = [SELECT ID,Phoenix_Product__r.Name, Phoenix_Proposed_Sales__c, Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Phoenix_Customer__c =: recordId AND Phoenix_Bid_Status__c != 'Awarded' AND Phoenix_Bid_Status__c != 'In Process' AND Phoenix_Bid_Status__c !='Pending' AND Phoenix_Bid__r.Phoenix_Bid_Type__c = 'Price Change' ORDER BY Phoenix_Product__r.Name];
        List<Phoenix_Bid_Line_Item__c> bidLinesListunsuccessful = [SELECT ID,Phoenix_Product__r.Name, Phoenix_Product__r.Family,Phoenix_Proposed_Sales__c, Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c, Phoenix_Customer_Response_Line__r.Phoenix_Customer_Decline_Reasons__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Phoenix_Customer__c =: recordId AND (Phoenix_Bid_Status__c = 'Declined by Customer' OR Phoenix_Bid_Status__c = 'DRL Rescinded' OR Phoenix_Bid_Status__c = 'DRL submitting under New Bid Number') ORDER BY Phoenix_Product__r.Name];
        
        //  List<Phoenix_Bid_Line_Item__c> bidLinesProductLosesList = [SELECT ID,Phoenix_Product__r.Name, Phoenix_Proposed_Sales__c, Phoenix_Customer_Response__r.Phoenix_Sent_to_Customer_Date__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Phoenix_Customer__c =: recordId AND Phoenix_Bid_Status__c = 'Awarded' ];
        //   List<Phoenix_Bid_Line_Item__c> bidLinesRecentDecreasesList = [SELECT ID,Phoenix_Product__r.Name, Phoenix_Proposed_Sales__c, Phoenix_Customer_Response__r.Phoenix_Sent_to_Customer_Date__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Phoenix_Customer__c =: recordId AND Phoenix_Bid_Status__c = 'Awarded'];
        
       // system.debug('bidLinesList---'+bidLinesList);
        MainWrapper mainWrap = new MainWrapper();
        
        List<RecentPrimaryWrapper> wrapList = new List<RecentPrimaryWrapper>();
        
        Map<String,Phoenix_Bid_Line_Item__c> productLines = new Map<String,Phoenix_Bid_Line_Item__c>();
        
        //system.debug('Product-----'+bidLinesList);
        for(Phoenix_Bid_Line_Item__c bidLine : bidLinesList ){
           // system.debug('Month---'+bidLine.Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c);
            if(bidLine.Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c != null) {
                if(!(productLines.containsKey(bidLine.Phoenix_Product__r.Name))){
                    productLines.put(bidLine.Phoenix_Product__r.Name,bidLine);
                }else{
                    Phoenix_Bid_Line_Item__c oldBidLine = productLines.get(bidLine.Phoenix_Product__r.Name);
                    if(oldBidLine.Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c < bidLine.Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c)
                        productLines.put(bidLine.Phoenix_Product__r.Name,bidLine);
                    else
                        productLines.put(bidLine.Phoenix_Product__r.Name,oldBidLine);
                }
            }
            
        }
        for(String productName : productLines.keySet()){
            RecentPrimaryWrapper wrapperObj = new RecentPrimaryWrapper();
            wrapperObj.RecentPrimaryAwards = productName;
            wrapperObj.annualSales = (productLines.get(productName).Phoenix_Proposed_Sales__c != null ? productLines.get(productName).Phoenix_Proposed_Sales__c.setScale(2) : 0);
            
            Integer currentMon = (productLines.get(productName).Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c != null ? productLines.get(productName).Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c.month():0);
            wrapperObj.NoOfMonths = 12-currentMon+1;
            wrapperObj.FYSales =Math.round(((Decimal.valueOf(wrapperObj.NoOfMonths)/12) * wrapperObj.annualSales).setScale(2));
            wrapList.add(wrapperObj);
            
        }
        //system.debug('Wrapper Prod Name---'+wrapList);
        
        mainWrap.recentPrimaryMainWrapList = (wrapList);
        
        //code for recent primary awards end
        
        //code for recent decreases start
        List<recentDecreasesWrapper> wrapRecentDecreasesList = new List<recentDecreasesWrapper>();
        
        
        Map<String,Phoenix_Bid_Line_Item__c> productLinesRecentDec = new Map<String,Phoenix_Bid_Line_Item__c>();
        
       // system.debug('Product-----'+bidLinesRecentDecreasesList);
        for(Phoenix_Bid_Line_Item__c bidLine : bidLinesRecentDecreasesList ){
            if(bidLine.Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c != null) {   
                if(!(productLinesRecentDec.containsKey(bidLine.Phoenix_Product__r.Name))){
                    productLinesRecentDec.put(bidLine.Phoenix_Product__r.Name,bidLine);
                }
                else{
                    Phoenix_Bid_Line_Item__c oldBidLine = productLinesRecentDec.get(bidLine.Phoenix_Product__r.Name);
                    if(oldBidLine.Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c < bidLine.Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c)
                        productLinesRecentDec.put(bidLine.Phoenix_Product__r.Name,bidLine);
                    else
                        productLinesRecentDec.put(bidLine.Phoenix_Product__r.Name,oldBidLine);
                }
            }
            
        }
        for(String productName : productLinesRecentDec.keySet()){
            recentDecreasesWrapper wrapperObj = new recentDecreasesWrapper();
            wrapperObj.RecentDecreases = productName;
            wrapperObj.annualSalesrecentDec =  (productLinesRecentDec.get(productName).Phoenix_Proposed_Sales__c != null ? productLinesRecentDec.get(productName).Phoenix_Proposed_Sales__c.setScale(2) : 0);//productLinesRecentDec.get(productName).Phoenix_Proposed_Sales__c;
            Integer currentMon = productLinesRecentDec.get(productName).Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c.month();
            wrapperObj.NoOfMonthsrecentDec = 12-currentMon+1;
            wrapperObj.FYImpactrecentDec = Math.round(((Decimal.valueOf(wrapperObj.NoOfMonthsrecentDec)/12) * wrapperObj.annualSalesrecentDec).setScale(2));
            wrapRecentDecreasesList.add(wrapperObj);
            
        }
        mainWrap.recentDecreasesMainWrapList = (wrapRecentDecreasesList);
        mainWrap.currentDate = s1;
        //code for recent decreases end
        
        //code for product losses start
        List<productLossesWrapper> wrapproductLossesList = new List<productLossesWrapper>();
        
        Map<String,Phoenix_Bid_Line_Item__c> productLinesProdLoss = new Map<String,Phoenix_Bid_Line_Item__c>();
        Map<String,Decimal> FYMap = new Map<String,Decimal>();
        Map<String,Decimal> noOfMonthsMap = new Map<String,Decimal>();
       // system.debug('Product-----'+bidLinesProductLosesList);
        for(Phoenix_Bid_Line_Item__c bidLine : bidLinesProductLosesList ){
            if(bidLine.Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c != null) {
                if(!(productLinesProdLoss.containsKey(bidLine.Phoenix_Product__r.Name))){
                    productLinesProdLoss.put(bidLine.Phoenix_Product__r.Name,bidLine);
                }else{
                    Phoenix_Bid_Line_Item__c oldBidLine = productLinesProdLoss.get(bidLine.Phoenix_Product__r.Name);
                    if(oldBidLine.Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c < bidLine.Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c)
                        productLinesProdLoss.put(bidLine.Phoenix_Product__r.Name,bidLine);
                    else
                        productLinesProdLoss.put(bidLine.Phoenix_Product__r.Name,oldBidLine);
                }
            }
            
        }
        for(String productName : productLinesProdLoss.keySet()){
            productLossesWrapper wrapperObj = new productLossesWrapper();
            wrapperObj.productLosses = productName;
            wrapperObj.annualSalesProdLoss =  (productLinesProdLoss.get(productName).Phoenix_Proposed_Sales__c != null ? productLinesProdLoss.get(productName).Phoenix_Proposed_Sales__c.setScale(2) : 0);//productLinesProdLoss.get(productName).Phoenix_Proposed_Sales__c;
            Integer currentMon = productLinesProdLoss.get(productName).Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c.month();
            wrapperObj.NoOfMonthsProdLoss = 12-currentMon+1;
            wrapperObj.FYSalesImpactProdLoss = Math.round(((Decimal.valueOf(wrapperObj.NoOfMonthsProdLoss)/12) * wrapperObj.annualSalesProdLoss).setScale(2));
            wrapproductLossesList.add(wrapperObj);
            
        }
        mainWrap.productLossesMainWrapList = (wrapproductLossesList);
        //code for product losses start
        
        List<unsuccessfulBids> wrapUnsuccessfulBidsList = new List<unsuccessfulBids>();
        unsuccessfulBids wrap = new unsuccessfulBids();
        String comments = '';
        Map<String,Phoenix_Bid_Line_Item__c> productMap = new Map<String,Phoenix_Bid_Line_Item__c>();
        
        Set<String> prodFamily = new Set<String>();
        
        
        for(Phoenix_Bid_Line_Item__c bidLine : bidLinesListunsuccessful ){
            if(bidLine.Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c != null) {
                if(!(productMap.containsKey(bidLine.Phoenix_Product__r.Name))){
                    productMap.put(bidLine.Phoenix_Product__r.Name,bidLine);
                }else{
                    Phoenix_Bid_Line_Item__c oldBidLine = productMap.get(bidLine.Phoenix_Product__r.Name);
                    if(oldBidLine.Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c < bidLine.Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c)
                        productMap.put(bidLine.Phoenix_Product__r.Name,bidLine);
                    else
                        productMap.put(bidLine.Phoenix_Product__r.Name,oldBidLine);
                }
            }
            
        }
        for(String productName : productMap.keySet()){
            unsuccessfulBids wrapperObj = new unsuccessfulBids();
            wrapperObj.productFamily = productName;
            wrapperObj.comments = productMap.get(productName).Phoenix_Customer_Response_Line__r.Phoenix_Customer_Decline_Reasons__c;           
            wrapUnsuccessfulBidsList.add(wrapperObj);
            
        }
        mainWrap.unsuccessfulBidsWrapList = (wrapUnsuccessfulBidsList);
        return mainWrap;
    }
    
    public class RecentPrimaryWrapper{
        //@AuraEnabled public String headerName;
        @AuraEnabled public String RecentPrimaryAwards;
        @AuraEnabled public Decimal FYSales;
        @AuraEnabled public Decimal annualSales;
        @AuraEnabled public Integer NoOfMonths;
        @AuraEnabled public Integer currentYear;
        
    }
    
    public class recentDecreasesWrapper{
        //@AuraEnabled public String headerName;
        @AuraEnabled public String RecentDecreases;
        @AuraEnabled public Decimal FYImpactrecentDec;
        @AuraEnabled public Decimal annualSalesrecentDec;
        @AuraEnabled public Integer NoOfMonthsrecentDec;
    }
    
    public class productLossesWrapper{
        //@AuraEnabled public String headerName;
        @AuraEnabled public String productLosses;
        @AuraEnabled public Decimal FYSalesImpactProdLoss;
        @AuraEnabled public Decimal annualSalesProdLoss;
        @AuraEnabled public Integer NoOfMonthsProdLoss;
    }

    public class unsuccessfulBids{
        //@AuraEnabled public String headerName;
        @AuraEnabled public String productFamily;
        @AuraEnabled public String comments;
        
    }
    
    public class MainWrapper{
        @AuraEnabled public list<RecentPrimaryWrapper> recentPrimaryMainWrapList;
        @AuraEnabled public list<recentDecreasesWrapper> recentDecreasesMainWrapList;
        @AuraEnabled public list<productLossesWrapper> productLossesMainWrapList;
        @AuraEnabled public list<unsuccessfulBids> unsuccessfulBidsWrapList;
        @AuraEnabled public String currentDate;
    }
  
}