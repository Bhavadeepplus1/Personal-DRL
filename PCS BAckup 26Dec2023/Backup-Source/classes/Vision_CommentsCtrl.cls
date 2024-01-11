public class Vision_CommentsCtrl {
    
    @auraEnabled
    public static list<Wrapper> getProdBidLineItemComments(String prodId, Account accObj){
        List<Wrapper> wrapList = new List<Wrapper>();
        Product2 prodObj = [SELECT Id, Name, Product_Family__r.Name, Family FROM Product2 WHERE Id=: prodId];
        String prodFamilyName = prodObj.Product_Family__r.Name;
        String panoramaString = 'Panorama';
        String accId = accObj.Id;
        string gcpCommentQuery = 'SELECT CreatedBy.Name, CreatedBy.SmallPhotoUrl, '+Phoenix_Util.getsObjectFieds('GCP_Comment__c')+' FROM GCP_Comment__c'+// WHERE Comment_Type__c =: panoramaString '+
            +' WHERE (Account__c =: accId AND Product__c =: prodId) OR (Comment_Type__c =: panoramaString AND Product_Family__c =: prodFamilyName) Order By Comment_Date__c DESC';// LIKE \''+prodFamilyName+'\' ORDER BY Comment_Date__c';
        List<GCP_Comment__c> cmntsList = database.query(gcpCommentQuery);
        system.debug('visionGcpCmntsList.size() :: '+cmntsList.size());
        
        
        if(cmntsList.size()>0)
        {  
            List<GCP_Comment__c> panoramaCmnts = new List<GCP_Comment__c>();
            List<GCP_Comment__c> visionCmnts = new List<GCP_Comment__c>();
            for(GCP_Comment__c gcpCmntItem : cmntsList){
                if(gcpCmntItem.Comment_Type__c == 'Panorama')
                    panoramaCmnts.add(gcpCmntItem);
                else
                    visionCmnts.add(gcpCmntItem);
            }
            if(panoramaCmnts.size()>0){
                Wrapper wrapObj = new Wrapper();
                List<cmntWrapper> cmntWrapList = new List<cmntWrapper>();
                wrapObj.cmntCat = 'Panorama Comments';
                wrapObj.cmntWrapList = new List<cmntWrapper>();
                for(GCP_Comment__c gcpCmntObj : panoramaCmnts){
                    cmntWrapper cmntObj = new cmntWrapper();
                    cmntObj.userName = gcpCmntObj.Author__c;
                    //cmntObj.userId = gcpCmntObj.CreatedById;
                    cmntObj.cmntDate = String.valueOf(gcpCmntObj.Comment_Date__c);
                    cmntObj.cmntString = gcpCmntObj.Comment__c;
                    cmntObj.profilePicUrl = '/docs/component-library/app/images/examples/avatar1.jpg';
                    cmntObj.gcpCmntObj = gcpCmntObj;
                    wrapObj.cmntWrapList.add(cmntObj);
                }
                wrapList.add(wrapObj);
            }
            if(visionCmnts.size()>0){
                Wrapper wrapObj = new Wrapper();
                List<cmntWrapper> cmntWrapList = new List<cmntWrapper>();
                wrapObj.cmntCat = 'Vision Comments';
                wrapObj.cmntWrapList = new List<cmntWrapper>();
                for(GCP_Comment__c gcpCmntObj : visionCmnts){
                    cmntWrapper cmntObj = new cmntWrapper();
                    cmntObj.userName = gcpCmntObj.CreatedBy.Name;
                    cmntObj.userId = gcpCmntObj.CreatedById;
                    cmntObj.cmntDate = String.valueOf(gcpCmntObj.createdDate);
                    cmntObj.cmntString = gcpCmntObj.Comment__c;
                    cmntObj.profilePicUrl = gcpCmntObj.CreatedBy.SmallPhotoUrl;
                    cmntObj.gcpCmntObj = gcpCmntObj;
                    wrapObj.cmntWrapList.add(cmntObj);
                }
                wrapList.add(wrapObj);
            }
        }
        
        
        String query = 'SELECT Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Customer__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, '+Phoenix_Util.getsObjectFieds('Phoenix_Bid_Line_Item__c')+' FROM Phoenix_Bid_Line_Item__c '+
            +'WHERE Phoenix_Bid__r.Phoenix_Customer__c =: accId AND Phoenix_Product__c =: prodId ORDER BY CreatedDate ASC';
        List<Phoenix_Bid_Line_Item__c> bidLineItemList = Database.query(query);
        
        
        
        List<Map<String,Map<String,String>>> commentList = new List<Map<String,Map<String,String>>>();
        Map<String,Map<String,String>> commentMap = new Map<String,Map<String,String>>();
        Map<String,String> subMap = new Map<String,String>();
        Map<String,String> considerMap = new Map<String,String>();
        
        if(bidLineItemList.size()>0){
            List<Id> bidIds = new List<Id>(); List<Id> bidLineIds = new List<Id>();
            for(Phoenix_Bid_Line_Item__c bidLineItemObj : bidLineItemList){
                bidIds.add(bidLineItemObj.Phoenix_Bid__c);bidLineIds.add(bidLineItemObj.Id); 
            }
            List<Phoenix_Bid_Process_Steps__c> bidProcessSteps = new List<Phoenix_Bid_Process_Steps__c>();
            bidProcessSteps = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, 
                               Phoenix_Status__c, Phoenix_Approver_Team__c, LastModifiedDate, LastModifiedBy.Name, 
                               LastModifiedById, LastModifiedBy.SmallPhotoUrl 
                               FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c IN: bidIds order by Phoenix_Step__c];
            Map<String, list<Phoenix_Bid_Process_Steps__c>> processStepsByBid = new Map<String, list<Phoenix_Bid_Process_Steps__c>>();
            for(Phoenix_Bid_Process_Steps__c bpObj : bidProcessSteps){
                if(!processStepsByBid.containsKey(bpObj.Phoenix_Bid__c))
                    processStepsByBid.put(bpObj.Phoenix_Bid__c,new List<Phoenix_Bid_Process_Steps__c>());
                processStepsByBid.get(bpObj.Phoenix_Bid__c).add(bpObj);
            }
            
            
            
            Wrapper wrapObj = new Wrapper();
            List<cmntWrapper> cmntWrapList = new List<cmntWrapper>();
            wrapObj.cmntCat = 'Bright Comments';
            wrapObj.cmntWrapList = new List<cmntWrapper>();
            wrapObj.cmntWrapMap = new Map<String,list<cmntWrapper>>();
            for(Phoenix_Bid_Line_Item__c bidLineItemObj : bidLineItemList){
                if(processStepsByBid.containsKey(bidLineItemObj.Phoenix_Bid__c)){
                    
                    List<cmntWrapper> cmntWrapObjList = new List<cmntWrapper>();
                    
                    List<Phoenix_Bid_Process_Steps__c> bidSteps = new List<Phoenix_Bid_Process_Steps__c>();
                    Map<string, Phoenix_Bid_Process_Steps__c> bidStageMap = new Map<String, Phoenix_Bid_Process_Steps__c>();
                    for(Phoenix_Bid_Process_Steps__c processStep : processStepsByBid.get(bidLineItemObj.Phoenix_Bid__c)){
                        if(processStep.Phoenix_Approver_Team__c == '')
                            bidStageMap.put('Sales',processStep);
                        if(processStep.Phoenix_Approver_Team__c == 'Marketing' || processStep.Phoenix_Approver_Team__c == 'Marketing Lead Rx' 
                           || processStep.Phoenix_Approver_Team__c == 'Marketing Lead SRx'
                           || processStep.Phoenix_Approver_Team__c == 'Marketing Lead OTC' || processStep.Phoenix_Approver_Team__c == 'Marketing Head')
                            bidStageMap.put('Marketing',processStep);
                        if(processStep.Phoenix_Approver_Team__c == 'Supply Chain')
                            bidStageMap.put('Supply Chain',processStep);
                        if(processStep.Phoenix_Approver_Team__c == 'Contracts')
                            bidStageMap.put('Contracts',processStep);
                        if(processStep.Phoenix_Approver_Team__c == 'Finance')
                            bidStageMap.put('Finance',processStep);
                        if(processStep.Phoenix_Approver_Team__c == 'Customer Service')
                            bidStageMap.put('Customer Service',processStep);
                        if(processStep.Phoenix_Approver_Team__c == 'Home Office')
                            bidStageMap.put('Vistex',processStep);
                    }
                    
                    if(bidLineItemObj.Phoenix_Comments__c !=  null 
                       && bidLineItemObj.Phoenix_Comments__c != '' 
                       && bidStageMap.containsKey('Sales')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Sales');
                           cmntWrapper cmntWrapObj = new cmntWrapper();
                           cmntWrapObj.userName = stepObj.LastModifiedBy.Name;
                           cmntWrapObj.userId = stepObj.LastModifiedById;
                           cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate);
                           cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Comments__c;
                           cmntWrapObj.cmntAprvlStage = 'Sales';
                           cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;
                           cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                           cmntWrapObjList.add(cmntWrapObj);
                       }
                    if(bidLineItemObj.Phoenix_Initial_Stocking_Order_Comments__c !=  null 
                       && bidLineItemObj.Phoenix_Initial_Stocking_Order_Comments__c != ''
                       && bidStageMap.containsKey('Sales')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Sales');
                           cmntWrapper cmntWrapObj = new cmntWrapper();
                           cmntWrapObj.userName = stepObj.LastModifiedBy.Name;
                           cmntWrapObj.userId = stepObj.LastModifiedById;
                           cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate);
                           cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Initial_Stocking_Order_Comments__c;
                           cmntWrapObj.cmntAprvlStage = 'Initial Stocking Order';
                           cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;
                           cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                           cmntWrapObjList.add(cmntWrapObj);                         
                       }
                    if(bidLineItemObj.Phoenix_Marketing_Notes__c !=  null 
                       && bidLineItemObj.Phoenix_Marketing_Notes__c != ''
                       && bidStageMap.containsKey('Marketing')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Marketing');
                           cmntWrapper cmntWrapObj = new cmntWrapper();
                           cmntWrapObj.userName = stepObj.LastModifiedBy.Name;
                           cmntWrapObj.userId = stepObj.LastModifiedById;
                           cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate);
                           cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Marketing_Notes__c;
                           cmntWrapObj.cmntAprvlStage = 'Marketing';
                           cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;
                           cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                           cmntWrapObjList.add(cmntWrapObj);
                           
                       }
                    if(bidLineItemObj.Phoenix_SCM_Notes__c !=  null 
                       && bidLineItemObj.Phoenix_SCM_Notes__c != ''
                       && bidStageMap.containsKey('Supply Chain')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Supply Chain');
                           cmntWrapper cmntWrapObj = new cmntWrapper();
                           cmntWrapObj.userName = stepObj.LastModifiedBy.Name;
                           cmntWrapObj.userId = stepObj.LastModifiedById;
                           cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate);
                           cmntWrapObj.cmntString = bidLineItemObj.Phoenix_SCM_Notes__c;
                           cmntWrapObj.cmntAprvlStage = 'Supply Chain';
                           cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;
                           cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                           cmntWrapObjList.add(cmntWrapObj);
                           
                       }
                    if(bidLineItemObj.Phoenix_Finance_Comments__c !=  null 
                       && bidLineItemObj.Phoenix_Finance_Comments__c != ''
                       && bidStageMap.containsKey('Finance')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Finance');
                           cmntWrapper cmntWrapObj = new cmntWrapper();
                           cmntWrapObj.userName = stepObj.LastModifiedBy.Name;
                           cmntWrapObj.userId = stepObj.LastModifiedById;
                           cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate);
                           cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Finance_Comments__c;
                           cmntWrapObj.cmntAprvlStage = 'Finance';
                           cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;
                           cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                           cmntWrapObjList.add(cmntWrapObj);
                           
                       }
                    if(bidLineItemObj.Phoenix_Contract_Comments__c !=  null 
                       && bidLineItemObj.Phoenix_Contract_Comments__c != ''
                       && bidStageMap.containsKey('Contracts')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Contracts');
                           cmntWrapper cmntWrapObj = new cmntWrapper();
                           cmntWrapObj.userName = stepObj.LastModifiedBy.Name;
                           cmntWrapObj.userId = stepObj.LastModifiedById;
                           cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate);
                           cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Contract_Comments__c;
                           cmntWrapObj.cmntAprvlStage = 'Contracts';
                           cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;
                           cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                           cmntWrapObjList.add(cmntWrapObj);
                           
                       }
                    if(bidLineItemObj.Phoenix_Vistex_Comments__c !=  null 
                       && bidLineItemObj.Phoenix_Vistex_Comments__c != ''
                       && bidStageMap.containsKey('Vistex')){
                           Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Vistex');
                           cmntWrapper cmntWrapObj = new cmntWrapper();
                           cmntWrapObj.userName = stepObj.LastModifiedBy.Name;
                           cmntWrapObj.userId = stepObj.LastModifiedById;
                           cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate);
                           cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Vistex_Comments__c;
                           cmntWrapObj.cmntAprvlStage = 'Vistex Update';
                           cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;
                           cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                           cmntWrapObjList.add(cmntWrapObj);
                       }
                    if(bidLineItemObj.Phoenix_Customer_Service_Comments__c !=  null && bidLineItemObj.Phoenix_Customer_Service_Comments__c != ''&& bidStageMap.containsKey('Customer Service')){
                        Phoenix_Bid_Process_Steps__c stepObj = bidStageMap.get('Customer Service');
                        cmntWrapper cmntWrapObj = new cmntWrapper();
                        cmntWrapObj.userName = stepObj.LastModifiedBy.Name;
                        cmntWrapObj.userId = stepObj.LastModifiedById;
                        cmntWrapObj.cmntDate = String.valueOf(stepObj.LastModifiedDate);
                        cmntWrapObj.cmntString = bidLineItemObj.Phoenix_Customer_Service_Comments__c;
                        cmntWrapObj.cmntAprvlStage = 'Customer Service';
                        cmntWrapObj.profilePicUrl = stepObj.LastModifiedBy.SmallPhotoUrl;
                        cmntWrapObj.bidId = bidLineItemObj.Phoenix_Bid__c;
                        
                        cmntWrapObjList.add(cmntWrapObj);
                        
                    }
                    if(!wrapObj.cmntWrapMap.containsKey(bidLineItemObj.Phoenix_Bid__r.Name))
                        wrapObj.cmntWrapMap.put(bidLineItemObj.Phoenix_Bid__r.Name+' - '+bidLineItemObj.Phoenix_Bid__r.Phoenix_Bid_Type__c, new List<cmntWrapper>());
                    wrapObj.cmntWrapMap.get(bidLineItemObj.Phoenix_Bid__r.Name+' - '+bidLineItemObj.Phoenix_Bid__r.Phoenix_Bid_Type__c).addAll(cmntWrapObjList);
                }
            }
            wrapList.add(wrapObj);
        }
        return wrapList;//considerMap;
    }
    
    Public class Wrapper{
        @auraEnabled
        public Decimal EstAcctSales;
        @auraEnabled
        public Decimal custActualSales;
        @auraEnabled
        public Decimal custOptySales;
        @auraEnabled
        public Decimal cxActVol;
        @auraEnabled
        public Decimal actTotal;
        @auraEnabled
        public Decimal shareOfWallet;
        @auraEnabled
        public Decimal drlAccVol;
        @auraEnabled
        public Decimal drlAccSales;
        @auraEnabled
        public Decimal drlAccPrice;
        @auraEnabled
        public Decimal drlAccTpt;
        @auraEnabled
        public Decimal totalMktVol;
        @auraEnabled
        public Decimal totalMktShares;
        @auraEnabled
        public Decimal custActVol;
        @auraEnabled
        public Decimal custActMktShare;
        @auraEnabled
        public Decimal custActOppTpt;
        @auraEnabled
        public String userSegment;
        @auraEnabled
        public List<String> segmentList;
        @auraEnabled
        public Account accObj;
        @auraEnabled
        public List<Phoenix_GCP_Opportunity_Tracker__c> gcpList;
        @auraEnabled
        public boolean isErrorFromServer = false;
        @auraEnabled 
        public string errorMessageFromServer;
        @auraEnabled
        public String cmntCat;
        @auraEnabled
        public string bidNumber;
        @auraEnabled
        public List<cmntWrapper> cmntWrapList;
        @auraEnabled
        public Map<String,List<cmntWrapper>> cmntWrapMap;
        @auraEnabled
        public Decimal awardedTotalSales = 0;
        @auraEnabled
        public Decimal inBidTotalSales = 0;
        
    }
    public class cmntWrapper{
        @auraEnabled
        public GCP_Comment__c gcpCmntObj;
        @auraEnabled
        public String userName;
        @auraEnabled
        public String userId;
        @auraEnabled
        public string bidId;
        @auraEnabled
        public String cmntDate;
        @auraEnabled
        public String cmntString;
        @auraEnabled
        public String cmntAprvlStage;
        @auraEnabled
        public string profilePicUrl;
    }
    
    @auraEnabled
    public static Wrapper saveComment(String newComment, String prodId, Account accObj){
        Wrapper wrapObj = new Wrapper();
        try{
            GCP_Comment__c gcpCmntObj = new GCP_Comment__c();
            gcpCmntObj.Comment__c = newComment;
            gcpCmntObj.Account__c = accObj.Id;
            gcpCmntObj.Product__c = prodId;
            insert gcpCmntObj;
            wrapObj.isErrorFromServer = false;
            wrapObj.errorMessageFromServer = 'SUCCESS!';
        }
        catch(exception e){
            wrapObj.isErrorFromServer = true;
            wrapObj.errorMessageFromServer = 'Exception while saving the comment. Exception : '+e.getMessage()+' Line: '+e.getLineNumber();
        }
        return wrapObj;
    }
}