public class Phoenix_OTCMDMViewCls {
    @AuraEnabled public static MDMClsWrapper getBidActionItems(String bidId){
        MDMClsWrapper mdmWrapper = new MDMClsWrapper();
        List<Product2>  productsList = [Select Id,ProductCode FROM Product2 WHERE Phoenix_Is_Private_Label_OTC__c=true OR Phoenix_Is_Control_Label__c=true LIMIT 10000];
        String query,bidApiName = 'Phoenix_Bid_Action_Item__c';
        query = 'Select Phoenix_Account__r.Name,Phoenix_Product__r.Name,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Bid_Line_Item__r.Phoenix_Product_Family1__c, '+Phoenix_Util.bidActionItemsFields+' From '+bidApiName+' Where Phoenix_Bid__c =:bidId';
        List<Phoenix_Bid_Action_Item__c> mdmActionItemList = Database.query(query);
        Boolean canHeSumbit = false;String stepCustomer = '%Customer\'s Update';
        //added by vandana.
    /*    Phoenix_Bid__c bid;
        bid = [SELECT id, OwnerId,Owner.Name FROM Phoenix_Bid__c WHERE Id =: bidId];*/
        //end.
        //vandana added
        String groupName = 'Admin Users';Group grp = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE Type = 'Regular' and name like: groupName LIMIT 1];
        List<String> idList = new List<String>();
        for(GroupMember gm: grp.groupMembers){idList.add(gm.userOrGroupId); }
        //end.

        List<Phoenix_Bid_Process_Steps__c> bidCustomerStep= [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Step__c, Phoenix_Status__c FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c=:bidId AND Name LIKE :stepCustomer];
        for(Phoenix_Bid_Action_Item__c Item: mdmActionItemList){
            if((Item.Phoenix_SAP_Code__c == null || Item.Status__c == null || Item.Status__c == 'Open') || Item.Phoenix_Is_Code_Submitted__c || !idList.contains(userInfo.getUserId()))canHeSumbit= true;
        }
        system.debug('mdmActionItemList-->'+mdmActionItemList);
        mdmWrapper.mdmActionItemList = mdmActionItemList;
        mdmWrapper.canHeSubmit = canHeSumbit;
        mdmWrapper.isCustomerStepCmpltd = bidCustomerStep[0].Phoenix_Status__c == 'Completed' ? true:false;
        mdmWrapper.productList = productsList;
        mdmWrapper.loggedInUserId = UserInfo.getUserId();
        //mdmWrapper.bidOwner = bid.Owner.Name;
        mdmWrapper.admins = idList;
        system.debug('isCustomerStepCmpltd--->'+mdmWrapper.isCustomerStepCmpltd);
        return mdmWrapper;
            
    }
    @AuraEnabled public static MDMClsWrapper updateLineItem(Phoenix_Bid_Action_Item__c actionItem, String bidId){
          //added by vandana.
      /*  Phoenix_Bid__c bid;
        bid = [SELECT id, OwnerId,Owner.Name FROM Phoenix_Bid__c WHERE Id =: bidId];*/
        //end.
        //vandana added
        String groupName = 'Admin Users';
        Group grp = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE Type = 'Regular' and name like: groupName LIMIT 1];
        Set<String> idList = new Set<String>();
        for(GroupMember gm: grp.groupMembers){
            idList.add(gm.userOrGroupId);
        }
        //end.
        system.debug('bidId-->'+bidId);
        if(actionItem != null)
            update actionItem;
        MDMClsWrapper mdmWrapper = new MDMClsWrapper();
        String query,bidApiName = 'Phoenix_Bid_Action_Item__c';
        query = 'Select Phoenix_Account__r.Name,Phoenix_Product__r.Name,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Bid_Line_Item__r.Phoenix_Product_Family1__c, '+Phoenix_Util.bidActionItemsFields+' From '+bidApiName+' Where Phoenix_Bid__c =:bidId';
        List<Phoenix_Bid_Action_Item__c> mdmActionItemList = Database.query(query);
        Boolean canHeSumbit = false;
        String stepCustomer = '%Customer\'s Update';
        List<Phoenix_Bid_Process_Steps__c> bidCustomerStep= [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Step__c, Phoenix_Status__c FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c=:bidId AND Name LIKE :stepCustomer];
        for(Phoenix_Bid_Action_Item__c Item: mdmActionItemList){
            system.debug('in for loop');
            if((Item.Phoenix_SAP_Code__c == null || Item.Status__c == null || Item.Status__c == 'Open') || Item.Phoenix_Is_Code_Submitted__c ||  !idList.contains(userInfo.getUserId()))
                    canHeSumbit= true;
        }
        system.debug('canHeSumbit--.'+canHeSumbit);
        mdmWrapper.canHeSubmit = canHeSumbit;
        mdmWrapper.updatedActoinItem = actionItem;
        mdmWrapper.isCustomerStepCmpltd = bidCustomerStep[0].Phoenix_Status__c == 'Completed' ? true:false;
        return mdmWrapper;
    }
    @AuraEnabled public static MDMClsWrapper submitProductCodes(String bidId){
        MDMClsWrapper mdmWrapper = new MDMClsWrapper();
          //added by vandana.
       /* Phoenix_Bid__c bid;
        bid = [SELECT id, OwnerId,Owner.Name FROM Phoenix_Bid__c WHERE Id =: bidId];*/
        //end.
        //vandana added
        String groupName = 'Admin Users';
        Group grp = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE Type = 'Regular' and name like: groupName LIMIT 1];
        Set<String> idList = new Set<String>();
        for(GroupMember gm: grp.groupMembers){
            idList.add(gm.userOrGroupId);
        }
        //end.
        String query,bidApiName = 'Phoenix_Bid_Action_Item__c';
        query = 'Select Phoenix_Account__r.Name,Phoenix_Product__r.Name,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Bid__r.Name,Phoenix_Bid_Line_Item__r.Phoenix_Product_Family1__c, '+Phoenix_Util.bidActionItemsFields+' From '+bidApiName+' Where Phoenix_Bid__c =:bidId';
        List<Phoenix_Bid_Action_Item__c> mdmActionItemList = Database.query(query);
        List<Phoenix_Bid_Line_Item__c> bidLines = [Select Id ,Phoenix_Product__c, Phoenix_Product_Code1__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c=:bidId AND Phoenix_Final_Status__c != 'Not Approved'];
        Boolean canHeSumbit = false;
        Map<Id,String> productsWithCode = new Map<Id,String>();
        for(Phoenix_Bid_Action_Item__c Item: mdmActionItemList){
            Item.Phoenix_Is_Code_Submitted__c = true;
            if((Item.Phoenix_SAP_Code__c == null || Item.Status__c == null || Item.Status__c == 'Open') || Item.Phoenix_Is_Code_Submitted__c || !idList.contains(userInfo.getUserId()))
                    canHeSumbit= true;
            productsWithCode.put(Item.Phoenix_Product__c, Item.Phoenix_SAP_Code__c);
            
        }
        for(Phoenix_Bid_Line_Item__c line : bidLines){
            if(line.Phoenix_Product_Code1__c == null || line.Phoenix_Product_Code1__c == '')
            	line.Phoenix_Product_Code1__c = productsWithCode.get(line.Phoenix_Product__c);
        }
        List<Product2> productsList = new List<Product2>();
        if(productsWithCode != null && productsWithCode.size()>0 && productsWithCode.keySet() != null){
             productsList = [Select Id,ProductCode FROM Product2 WHERE Id=:productsWithCode.keySet()];
            for(Product2 prod : productsList){
                prod.ProductCode= productsWithCode.get(prod.Id);
            }
        }
        if(bidLines != null && bidLines.size()>0)
        	update bidLines;
        if(mdmActionItemList != null && mdmActionItemList.size()>0)
        	update mdmActionItemList;
        if(productsList != null && productsList.size()>0)
        	update productsList;
        mdmWrapper.mdmActionItemList = mdmActionItemList;
        mdmWrapper.canHeSubmit = canHeSumbit;
        mdmWrapper.isCustomerStepCmpltd  =true;
        Phoenix_SubmitBidForApprovalCtrl.sendEmailToAllApprovers(bidId,mdmActionItemList);
        return mdmWrapper;
    }
    public class MDMClsWrapper{
        @AuraEnabled public List<Phoenix_Bid_Action_Item__c> mdmActionItemList;
        @AuraEnabled public Phoenix_Bid_Action_Item__c updatedActoinItem;
        @AuraEnabled public boolean isMdmUser;
        @AuraEnabled public boolean canHeSubmit;
        @AuraEnabled public boolean isCustomerStepCmpltd;
        @AuraEnabled public string loggedInUserId;
      //  @AuraEnabled public string bidOwner;
        @AuraEnabled public List<Id> admins;
        @AuraEnabled public List<Product2> productList;
        MDMClsWrapper(){
            mdmActionItemList= new List<Phoenix_Bid_Action_Item__c>();
            isMdmUser= false;
            canHeSubmit =false;
            isCustomerStepCmpltd= false;
            updatedActoinItem = new Phoenix_Bid_Action_Item__c();
            productList = new List<Product2>();
        }
    }
    

}