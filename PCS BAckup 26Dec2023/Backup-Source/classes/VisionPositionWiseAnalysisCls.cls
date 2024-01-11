public class VisionPositionWiseAnalysisCls{
    @AuraEnabled 
    public static finalWrapper getData(List<String> selectedBids){
        String query = 'Select Phoenix_Product__r.Product_Family__r.Name, Phoenix_Product__r.Product_Family__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Product__r.Phoenix_Throughput_cost__c, Phoenix_Product__r.Name, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, ' +Phoenix_Util.getsObjectFieds('Phoenix_Bid_Line_Item__c')+', (Select '+Phoenix_Util.getsObjectFieds('Phoenix_Customer_Response_Line__c')+' from Customer_Response_Lines__r) from Phoenix_Bid_Line_Item__c WHERE Phoenix_Customer_Response_Line__c != null AND Phoenix_Bid__c IN: selectedBids';
        List<Phoenix_Bid_Line_Item__c> bidLineItems = Database.query(query);
        List<String> positions = new List<String> {'Lost Primary', 'Primary to Backup', 'Retained Primary', 'Backup to Primary', 'Retained Backup', 'Lost Backup', 'Bid in RFP didn\'t win', 'New Backup', 'New Primary'};
        Map<String, List<Phoenix_Bid_Line_Item__c>> mapOfPositions = new Map<String, List<Phoenix_Bid_Line_Item__c>>();
        for(String position: positions){
            mapOfPositions.put(position, new List<Phoenix_Bid_Line_Item__c>());
        }
        List<Phoenix_Bid_Line_Item__c> ignoredBidLineItems = new List<Phoenix_Bid_Line_Item__c>();
        for(Phoenix_Bid_Line_Item__c bidLineItem: bidLineItems){
            if(bidLineItem.Customer_Response_Lines__r.size() > 0 && ((bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded') && (bidLineItem.Customer_Response_Lines__r[0].General_Category__c == 'Primary' || bidLineItem.Customer_Response_Lines__r[0].General_Category__c == 'primary') && bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == null)){
                if(mapOfPositions.containsKey('Lost Primary')){
                    List<Phoenix_Bid_Line_Item__c> positionItemsList = mapOfPositions.get('Lost Primary');
                    positionItemsList.add(bidLineItem);
                    mapOfPositions.put('Lost Primary', positionItemsList);
                } else{
                    List<Phoenix_Bid_Line_Item__c> positionItemsList = new List<Phoenix_Bid_Line_Item__c>();
                    positionItemsList.add(bidLineItem);
                    mapOfPositions.put('Lost Primary', positionItemsList);
                }
            } else if(bidLineItem.Customer_Response_Lines__r.size() > 0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded' && (bidLineItem.Customer_Response_Lines__r[0].General_Category__c == 'Primary' || bidLineItem.Customer_Response_Lines__r[0].General_Category__c == 'primary') && (bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == 'Primary' || bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == 'primary'))){
                if(mapOfPositions.containsKey('Retained Primary')){
                    List<Phoenix_Bid_Line_Item__c> positionItemsList = mapOfPositions.get('Retained Primary');
                    positionItemsList.add(bidLineItem);
                    mapOfPositions.put('Retained Primary', positionItemsList);
                } else{
                    List<Phoenix_Bid_Line_Item__c> positionItemsList = new List<Phoenix_Bid_Line_Item__c>();
                    positionItemsList.add(bidLineItem);
                    mapOfPositions.put('Retained Primary', positionItemsList);
                }
            } else if(bidLineItem.Customer_Response_Lines__r.size() > 0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded' && (bidLineItem.Customer_Response_Lines__r[0].General_Category__c == 'Primary' || bidLineItem.Customer_Response_Lines__r[0].General_Category__c == 'primary') && (bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == 'Backup' || bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == 'backup' || bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == 'Secondary' || bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == 'secondary'))){
                if(mapOfPositions.containsKey('Primary to Backup')){
                    List<Phoenix_Bid_Line_Item__c> positionItemsList = mapOfPositions.get('Primary to Backup');
                    positionItemsList.add(bidLineItem);
                    mapOfPositions.put('Primary to Backup', positionItemsList);
                } else{
                    List<Phoenix_Bid_Line_Item__c> positionItemsList = new List<Phoenix_Bid_Line_Item__c>();
                    positionItemsList.add(bidLineItem);
                    mapOfPositions.put('Primary to Backup', positionItemsList);
                }
            } else if(bidLineItem.Customer_Response_Lines__r.size() > 0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded' && (bidLineItem.Customer_Response_Lines__r[0].General_Category__c == 'Backup' || bidLineItem.Customer_Response_Lines__r[0].General_Category__c == 'backup' || bidLineItem.Customer_Response_Lines__r[0].General_Category__c == 'Secondary' || bidLineItem.Customer_Response_Lines__r[0].General_Category__c == 'secondary') && (bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == 'Primary' || bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == 'primary'))){
                if(mapOfPositions.containsKey('Backup to Primary')){
                    List<Phoenix_Bid_Line_Item__c> positionItemsList = mapOfPositions.get('Backup to Primary');
                    positionItemsList.add(bidLineItem);
                    mapOfPositions.put('Backup to Primary', positionItemsList);
                } else{
                    List<Phoenix_Bid_Line_Item__c> positionItemsList = new List<Phoenix_Bid_Line_Item__c>();
                    positionItemsList.add(bidLineItem);
                    mapOfPositions.put('Backup to Primary', positionItemsList);
                }
            } else if(bidLineItem.Customer_Response_Lines__r.size() > 0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded' && (bidLineItem.Customer_Response_Lines__r[0].General_Category__c == 'Backup' || bidLineItem.Customer_Response_Lines__r[0].General_Category__c == 'backup' || bidLineItem.Customer_Response_Lines__r[0].General_Category__c == 'Secondary' || bidLineItem.Customer_Response_Lines__r[0].General_Category__c == 'secondary') && (bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == 'Backup' || bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == 'backup' || bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == 'Secondary' || bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == 'secondary'))){
                if(mapOfPositions.containsKey('Retained Backup')){
                    List<Phoenix_Bid_Line_Item__c> positionItemsList = mapOfPositions.get('Retained Backup');
                    positionItemsList.add(bidLineItem);
                    mapOfPositions.put('Retained Backup', positionItemsList);
                } else{
                    List<Phoenix_Bid_Line_Item__c> positionItemsList = new List<Phoenix_Bid_Line_Item__c>();
                    positionItemsList.add(bidLineItem);
                    mapOfPositions.put('Retained Backup', positionItemsList);
                }
            } else if(bidLineItem.Customer_Response_Lines__r.size() > 0 && ((bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded') && (bidLineItem.Customer_Response_Lines__r[0].General_Category__c == 'Backup' || bidLineItem.Customer_Response_Lines__r[0].General_Category__c == 'backup'|| bidLineItem.Customer_Response_Lines__r[0].General_Category__c == 'Secondary' || bidLineItem.Customer_Response_Lines__r[0].General_Category__c == 'secondary') && bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == null)){
                if(mapOfPositions.containsKey('Lost Backup')){
                    List<Phoenix_Bid_Line_Item__c> positionItemsList = mapOfPositions.get('Lost Backup');
                    positionItemsList.add(bidLineItem);
                    mapOfPositions.put('Lost Backup', positionItemsList);
                } else{
                    List<Phoenix_Bid_Line_Item__c> positionItemsList = new List<Phoenix_Bid_Line_Item__c>();
                    positionItemsList.add(bidLineItem);
                    mapOfPositions.put('Lost Backup', positionItemsList);
                }
            } else if(bidLineItem.Customer_Response_Lines__r.size() > 0 && ((bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer' || bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'DRL Rescinded') && bidLineItem.Customer_Response_Lines__r[0].General_Category__c == null && bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == null)){
                if(mapOfPositions.containsKey('Bid in RFP didn\'t win')){
                    List<Phoenix_Bid_Line_Item__c> positionItemsList = mapOfPositions.get('Bid in RFP didn\'t win');
                    positionItemsList.add(bidLineItem);
                    mapOfPositions.put('Bid in RFP didn\'t win', positionItemsList);
                } else{
                    List<Phoenix_Bid_Line_Item__c> positionItemsList = new List<Phoenix_Bid_Line_Item__c>();
                    positionItemsList.add(bidLineItem);
                    mapOfPositions.put('Bid in RFP didn\'t win', positionItemsList);
                }
            } else if(bidLineItem.Customer_Response_Lines__r.size() > 0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded' && bidLineItem.Customer_Response_Lines__r[0].General_Category__c == null && (bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == 'Backup' || bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == 'backup' || bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == 'Secondary' || bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == 'secondary'))){
                if(mapOfPositions.containsKey('New Backup')){
                    List<Phoenix_Bid_Line_Item__c> positionItemsList = mapOfPositions.get('New Backup');
                    positionItemsList.add(bidLineItem);
                    mapOfPositions.put('New Backup', positionItemsList);
                } else{
                    List<Phoenix_Bid_Line_Item__c> positionItemsList = new List<Phoenix_Bid_Line_Item__c>();
                    positionItemsList.add(bidLineItem);
                    mapOfPositions.put('New Backup', positionItemsList);
                }
            } else if(bidLineItem.Customer_Response_Lines__r.size() > 0 && (bidLineItem.Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded' && bidLineItem.Customer_Response_Lines__r[0].General_Category__c == null && (bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == 'Primary' || bidLineItem.Customer_Response_Lines__r[0].Awarded_General_Category__c == 'primary'))){
                if(mapOfPositions.containsKey('New Primary')){
                    List<Phoenix_Bid_Line_Item__c> positionItemsList = mapOfPositions.get('New Primary');
                    positionItemsList.add(bidLineItem);
                    mapOfPositions.put('New Primary', positionItemsList);
                } else{
                    List<Phoenix_Bid_Line_Item__c> positionItemsList = new List<Phoenix_Bid_Line_Item__c>();
                    positionItemsList.add(bidLineItem);
                    mapOfPositions.put('New Primary', positionItemsList);
                }
            }
            ignoredBidLineItems.add(bidLineItem);   
        }
        
        Map<String, List<categoryWrapper>> categoryWrapperList = new Map<String, List<categoryWrapper>>();
        for(String key: mapOfPositions.keySet()){
            categoryWrapper wrap = new categoryWrapper();
            if(key == 'Lost Primary' || key == 'Retained Primary' || key == 'Primary to Backup'){
                wrap.category = 'Primary';
            } else if(key == 'Backup to Primary' || key == 'Retained Backup' || key == 'Lost Backup'){
                wrap.category = 'Backup';
            } else if(key == 'Bid in RFP didn\'t win' || key == 'New Backup' || key == 'New Primary'){
                wrap.category = 'New Opportunity';
            }
            wrap.position = key;
            wrap.bidLineItems = mapOfPositions.get(key);
            wrap.length1 = wrap.bidLineItems.size();
            if(categoryWrapperList.containsKey(wrap.category)){
                List<categoryWrapper> wrapperList = categoryWrapperList.get(wrap.category);
                wrapperList.add(wrap);
                categoryWrapperList.put(wrap.category, wrapperList);                
            } else{
                List<categoryWrapper> wrapperList = new List<categoryWrapper>();
                wrapperList.add(wrap);
                categoryWrapperList.put(wrap.category, wrapperList);
            }
        }
        List<categoryWrapper> primaryCategory = new List<categoryWrapper>();
        List<categoryWrapper> backupCategory = new List<categoryWrapper>();
        List<categoryWrapper> optyCategory = new List<categoryWrapper>();
        for(String key: categoryWrapperList.keySet()){
            if(key == 'New Opportunity'){
                optyCategory = categoryWrapperList.get(key);
            } else if(key == 'Primary'){
                primaryCategory = categoryWrapperList.get(key);
            } else if(key == 'Backup'){
                backupCategory = categoryWrapperList.get(key);
            }
        }
        finalWrapper finalWrap = new finalWrapper();
        finalWrap.primaryCategory = primaryCategory;
        finalWrap.backupCategory = backupCategory;
        finalWrap.optyCategory = optyCategory;
        finalWrap.ignoredBidLineItems = ignoredBidLineItems;
        return finalWrap;
    }
    
    @AuraEnabled
    public static List<Phoenix_Bid__c> getRFPBids(String searchText){
        String RFP = 'RFP Bids'; List<String> approvalStatus = new List<String>{'Closed', 'Vistex Update', 'Customer Rejected'};
        String query = 'SELECT Name, Phoenix_Bid_Name__c, Phoenix_Bid_Owner__r.Name, Phoenix_Bid_Submitted_Date__c, Phoenix_Bid_Type__c, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Bid_Owner__c FROM Phoenix_Bid__c WHERE (Phoenix_Bid_Type__c =:RFP AND Phoenix_Approval_Status__c IN: approvalStatus)';
        if(!String.isBlank(searchText)){
            Set<String> splittedText = new Set<String>();
            List<String> splittedTextSpace = searchText.split(' ');
            List<String> splittedTextComma = searchText.split(',');
            splittedText.addAll(splittedTextSpace);
            splittedText.addAll(splittedTextComma);
            List<String> searchBids = new List<String>();
            for(String str: splittedText){
                string searchItem='%'+str+'%';
                searchBids.add(searchItem);
            }
            query += 'AND (Name LIKE: searchBids OR Phoenix_Bid_Name__c LIKE: searchBids)';
        }
        query += ' ORDER BY Name ASC LIMIT 1000'; 
        List<Phoenix_Bid__c> bids = Database.query(query);
        return bids;
    }
    
    public class categoryWrapper{
        @AuraEnabled public String category;
        @AuraEnabled public String position;
        @AuraEnabled public List<Phoenix_Bid_Line_Item__c> bidLineItems;
        @AuraEnabled public Map<String, List<Phoenix_Bid_Line_Item__c>> mapOfPositions;
        @AuraEnabled public boolean expandCategory;
        @AuraEnabled public Integer length1;
    }
    
    public class finalWrapper{
        @AuraEnabled public List<categoryWrapper> primaryCategory;
        @AuraEnabled public List<categoryWrapper> backupCategory;
        @AuraEnabled public List<categoryWrapper> optyCategory;
        @AuraEnabled public List<Phoenix_Bid_Line_Item__c> ignoredBidLineItems;
    }
}