public class VisionSearchSelectBidsCtrl {
    @AuraEnabled
    public static List<Phoenix_Bid__c> getBids(String searchText){
        List<String> approvalStatus = new List<String>{'Closed', 'Vistex Update', 'Contracts', 'Contracts Rejected', 'Customer Rejected', 'Customer\'s Update'};
        List<String> bidTypes = new List<String>{'Contracts Only', 'Initial Order Discount for WAC Customers (No-Contract Price Offering)', 'Direct Order Form Pricing Update', 'IPA Floor Pricing Update', 'IPA Member Addition', 'SRx IPA Price Change', 'SRx IPA Product Addition', 'NEW Individual Pricing Agreement (IPA)', 'RCA/IPA Member GPO or Wholesaler Change', 'RCA Member Addition', 'VIP Rebate'};
        String query = 'SELECT Name, Phoenix_Bid_Name__c, Phoenix_Bid_Owner__r.Name, Phoenix_Bid_Submitted_Date__c, Phoenix_Bid_Type__c, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Bid_Owner__c FROM Phoenix_Bid__c WHERE (Phoenix_Approval_Status__c IN: approvalStatus AND Phoenix_Bid_Type__c NOT IN: bidTypes)';
        if(!String.isBlank(searchText)){
            Set<String> splittedText = new Set<String>();
            List<String> splittedTextComma = searchText.split(',');
            //splittedText.addAll(splittedTextComma);
            List<String> searchBids = new List<String>();
            for(String str: splittedTextComma){
                string searchItem='%'+str+'%';
                searchBids.add(searchItem);
            }
            query += 'AND (Name LIKE: searchBids OR Phoenix_Bid_Name__c LIKE: searchBids)';
        }
        query += ' ORDER BY Name ASC LIMIT 1000';
        List<Phoenix_Bid__c> bids = Database.query(query);
        return bids;
    }
    
    @AuraEnabled
    public static List<Phoenix_Bid__c> getRFPBids(String searchText){
        List<Phoenix_Bid__c> RFPBids = VisionPositionWiseAnalysisCls.getRFPBids(searchText);
        return RFPBids;
    }
    
    @AuraEnabled
    public static List <Phoenix_Bid__c> fetchSortResults(string sortField, boolean isAsc, List < Phoenix_Bid__c > bidList) {
        set < Id > bidIds = new set < Id > ();
        list < Phoenix_Bid__c > sortResults = new list < Phoenix_Bid__c > ();
        List < Phoenix_Bid__c > bidslist = new List < Phoenix_Bid__c > ();
        for (Phoenix_Bid__c w: bidList) {
            bidIds.add(w.Id);
        }
        String sSoql = 'SELECT Name, Phoenix_Bid_Name__c, Phoenix_Bid_Owner__r.Name, Phoenix_Bid_Submitted_Date__c, Phoenix_Bid_Type__c, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Bid_Owner__c FROM Phoenix_Bid__c WHERE ID IN:bidIds';
        if (sortField != null && sortField != '') {
            sSoql += ' order by ' + sortField;
            if (isAsc) {
                sSoql += ' ASC ';
            } else {
                sSoql += ' DESC ';
            }
        }
        sSoql += ' NULLS LAST ';
        sortResults = Database.query(sSoql);
        for (Phoenix_Bid__c bid: sortResults) {
            for (Phoenix_Bid__c wr: bidList) {
                if (wr.Id == bid.Id) {
                    bidslist.add(wr);
                }
            }
        }
        
        return bidslist;
    }
}