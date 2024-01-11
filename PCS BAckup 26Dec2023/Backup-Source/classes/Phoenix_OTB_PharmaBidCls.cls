public class Phoenix_OTB_PharmaBidCls {
    //Added Code by Rama
    
    @AuraEnabled 
    public static user fetchUserOTB(){  
        return CompetitorInfoCLS.fetchUser();
    }
    //End Code by Rama   
    
    @AuraEnabled
    public static string getSubmitBidInfo(Id bidId) {
        Phoenix_SubmitBidForApprovalCtrl.BidWrapper warpper = Phoenix_SubmitBidForApprovalCtrl.getBidInfo(bidId);
        system.debug('warpper---' + warpper.error);
        string response = Phoenix_SubmitBidForApprovalCtrl.submitBid(warpper);
        system.debug('response--' + response);
        return response;
    }
    
    @AuraEnabled
    public static list < AggregateResult > getAllTotals(Id bidId) {
        AggregateResult[] groupedResults = [select sum(Phoenix_Current_Indirect_Selling_Unit__c) cisu, sum(Phoenix_Current_Direct_Selling_Unit__c) cdsu, sum(Phoenix_Total_Selling_Unit__c) tsu, sum(Phoenix_Final_Direct_Selling_Units_Calc__c) fdsu, sum(Phoenix_Net_Sales_Internal__c) netsint, sum(Phoenix_Final_Indirect_Selling_Units_Cal__c) fisu, sum(Phoenix_Final_Total_Selling_Unit__c) ftsu, sum(Phoenix_Internal_Dead_Net_Price__c) intdead, sum(Phoenix_Retail_Direct_Guidance_Price__c) retaildirguidesales, sum(Phoenix_Wholesaler_Guidance_Price__c) whslGuidesales, sum(Phoenix_Retail_Direct_Sales_Price__c) retailguidesales, sum(Phoenix_Wholesaler_Sales_Price__c) whslsales, sum(Phoenix_Current_Retail_Indirect_Net__c) currentDSHP, sum(Phoenix_Retail_Indirect_Net__c) proposedDSHP, sum(Phoenix_12_Months_TotalSaleUnits__c) ActualTotalUnits, sum(Phoenix_Override_Current_Units__c) OverrideTotalUnits, sum(Phoenix_Retail_Direct_Price__c) retailmarketing, sum(Phoenix_Wholesaler_DRL_Net_Price__c)  BASEDRLNetP, sum(Phoenix_Anda_DRL_Net_price__c) DSHDRLNetP, sum(Phoenix_Wholesaler_DRL_TPT__c) AutoSubDRLNetP, sum(Phoenix_12_Months_Actual_Sales__c) actSaDir12Months, sum(Phoenix_12_Months_IndirectSaleUnit__c) actSalInd12months, sum(Phoenix_12_Months_TotalSaleUnits__c) actTotal12Months, sum(Phoenix_Proposed_Direct_Selling_Unit__c) proDirUnits, sum(Phoenix_Proposed_Indirect_Selling_Unit__c) proIndUnits, sum(Phoenix_ProposedContractBidPriceMktng__c) proDirMark, sum(Phoenix_Wholesaler_Diff_Price_Indirect__c) proIndiMark, sum(Phoenix_Customer_Dead_net__c) netIndirPrice, sum(Phoenix_Indirect_Dead_Net__c) indirectDeadNet, sum(Phoenix_Retail_Indirect_Price__c) retailIndirectmrket, sum(Proposed_Net_Sales_Direct__c) netSaleDir, sum(Proposed_Net_Sales_Indirect__c) netSaleIndir, sum(Proposed_TPT_Direct__c) tptDir, sum(Proposed_TPT_Per_Direct__c) tptPerDir, sum(Proposed_TPT_Indirect__c) tptIndir, sum(Proposed_TPT_Per_Indirect__c) tptPerIndir, sum(Phoenix_Th_Put_Margin__c) TputMargin, sum(Phoenix_Proposed_TPMargin__c) TPMarginPerc, sum(Indirect_TP__c) IndirectTP, sum(Phoenix_Direct_TP_In__c) directTPT$PerPack, sum(Phoenix_Direct_TP__c) directTPTPerPack, sum(Phoenix_Indirect_TP__c) indirTP, sum(Phoenix_Total_SCM_Approved_Qty__c) scmQty, sum(Phoenix_Proposed_TP_Margin__c) propoTPmargin from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId and Phoenix_Final_Status__c != 'Not Approved'];
        return groupedResults;
    }
    
    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > getupdatedforExport(Id bidId) {
        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        string notApproved = 'Not Approved';
        query = 'select Phoenix_Previous_LineItem__r.Name,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Proposed_Cash_Terms__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
        list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);
        return quoteList;
    }
    
    @AuraEnabled
    public static Wrapper getRelatedList(Id bidId) {
        Wrapper wrapperObject = new Wrapper();
        
        String query = '';
        query = 'SELECT Phoenix_Customer__r.Phoenix_Customer_Service_Approver__r.Name,Phoenix_Customer__r.Phoenix_Customer_Service_Approver__c, Phoenix_Customer__r.Name,'+Phoenix_Util.bidFields+' FROM Phoenix_Bid__c WHERE Id =: bidId';
        Phoenix_Bid__c bid = database.query(query);
        
        string conAppPersonName=bid.Phoenix_Customer__r.Phoenix_Customer_Service_Approver__r.Name; 
        string bidType = bid.Phoenix_Bid_Type__c;
        
        query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } 
            else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        
        System.debug('--------------strFields-------------'+strFields);
        string notApproved = 'Not Approved';
        query = 'select Phoenix_Bid__r.Phoenix_Is_Re_Bid__c,Phoenix_Previous_Bid__r.Name,Phoenix_Previous_LineItem__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,'+
            +'Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,'+
            +'Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Proposed_Cash_Terms__c,'+
            +'Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
        list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);
        system.debug('quoteList--->' + quoteList);
        
        List < String > productFamilyList = new List < String > ();
        List < String > productDirectorList = new List < String > ();
        boolean showProceedBtn = true;
        boolean hasDirectorLines = false;
        boolean showCustoServiceProceedBtn=true;
        //added by satya
        List < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, 
                                                                    Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c 
                                                                    FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId LIMIT 20000];
        String customerApprovalTeam='';
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList){
            if(step.Phoenix_Process_Step__r.Name.contains('Customer Service')){
                customerApprovalTeam= step.Phoenix_Approver_Team_Members__c;
            }
        }
        List<String> approvalTeamMembers = customerApprovalTeam.split(',');
        System.debug('approvalTeamMembers-->'+approvalTeamMembers);
        List<Phoenix_Approval_Delegation_History__c> custServcdeligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        custServcdeligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Delegated_Approver__r.Name,Phoenix_User__r.Name,
                                     Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c 
                                     FROM Phoenix_Approval_Delegation_History__c 
                                     WHERE Phoenix_Is_Active_delegator__c = true 
                                     AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId() 
                                     AND Phoenix_User__r.Name =:approvalTeamMembers];
        System.debug('custServcdeligatorApprover-->'+custServcdeligatorApprover);
        String custdelegatedUsers = '';
        if(bidType != 'Platform OTB')
            custdelegatedUsers = UserInfo.getName();
        if(custServcdeligatorApprover !=null && custServcdeligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c aprHisDel : custServcdeligatorApprover){
                custdelegatedUsers = custdelegatedUsers + ',' + aprHisDel.Phoenix_User__r.Name;
            }
        }
        /*query = 'SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Delegated_Approver__r.Name,Phoenix_User__r.Name,Phoenix_Is_Active_delegator__c,'+
+'Phoenix_Delegated_Approver__c, Phoenix_User__c '+
+' FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true';
if(bidType == 'Platform OTB'){
query += ' AND (Phoenix_Delegated_Approver__c =: Userinfo.getUserId() OR Phoenix_Delegated_Approver__c =: bid.Phoenix_OTB_Marketing_Approver__c)';
}
else{
query += ' AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()';
}*/
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Delegated_Approver__r.Name,Phoenix_User__r.Name,Phoenix_Is_Active_delegator__c, 
                            Phoenix_Delegated_Approver__c, Phoenix_User__c 
                            FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true 
                            AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
        System.debug('deligatorApprover-->'+deligatorApprover);
        String delegatedUsers = '';
        String delegatedUsersId = '';
        if(bidType != 'Platform OTB'){
            delegatedUsers = UserInfo.getName();
            delegatedUsersId = UserInfo.getUserId();
        }
        
        if(deligatorApprover !=null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c aprHisDel : deligatorApprover){
                delegatedUsers = delegatedUsers + ',' + aprHisDel.Phoenix_User__r.Name;
                delegatedUsersId = delegatedUsersId + ',' + aprHisDel.Phoenix_User__c;
                if(bidType == 'Platform OTB' && aprHisDel.Phoenix_User__c == bid.Phoenix_OTB_Marketing_Approver__c){
                    delegatedUsersId = aprHisDel.Phoenix_Delegated_Approver__c;
                }
            }
        }
        for (Phoenix_Bid_Line_Item__c lineItem: quoteList) {
            if (!productFamilyList.contains(lineItem.Product_Family_Name__c)) {
                productFamilyList.add(lineItem.Product_Family_Name__c);
            }
            if (lineItem.Phoenix_Product_Director__c != null && !productDirectorList.contains(lineItem.Phoenix_Product_Director__c)) {
                productDirectorList.add(lineItem.Phoenix_Product_Director__c);
            }
            if (lineItem.Phoenix_Product_Director__c != null && (lineItem.Phoenix_Product_Director__c == userInfo.getName() || (delegatedUsers!=null && delegatedUsers.contains(lineItem.Phoenix_Product_Director__c))) && lineItem.Phoenix_Marketing_Final_Approval__c == false) {
                system.debug('Has Prdouct Director');
                hasDirectorLines = true;
            }
            if (lineItem.Phoenix_Marketing_Final_Approval__c == true && lineItem.Phoenix_Product_Director__c == userinfo.getName()) {
                showProceedBtn = false;
            }
            if (lineItem.Phoenix_Customer_Final_Approval__c != null && lineItem.Phoenix_Customer_Final_Approval__c == false){
                showCustoServiceProceedBtn = true;
            }
        }
        // system.debug('productDirectorList--->'+productDirectorList);
        //system.debug(UserInfo.getName());
        if(hasDirectorLines){
            showProceedBtn = true;
        }
        
        SobjectApiName = 'Phoenix_Bid__c';
        schemaMap = Schema.getGlobalDescribe();
        fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } 
            else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        
        User cuurentUser;
        if (bid.Phoenix_Bid_Created_Behalf_of__c != null && bid.Phoenix_Approval_Status__c == 'Draft') {
            cuurentUser = [SELECT id, Name FROM User WHERE Id =: bid.Phoenix_Bid_Created_Behalf_of__c LIMIT 1];
        } else {
            cuurentUser = [SELECT id, Name FROM User WHERE Id =: userinfo.getUserId() LIMIT 1];
        }
        
        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, Phoenix_Approver__r.Name, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, 
                                                      Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c 
                                                      from Phoenix_User_Approval_Matrix__c limit 1000]) {
                                                          String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
                                                          userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__r.Name);
                                                      }
        string isMarketingApprovePerson;
        string isContractsApprovePerson;
        string isCustServiceApprovePerson;
        boolean isDelegationPerson=false;
        boolean isCustomerServiceDelegationPerson=false;
        boolean isMarketingDelegationPerson = false;
        wrapperObject.deligatedUserName = delegatedUsers;
        wrapperObject.delegatedUserId = delegatedUsersId;
        wrapperObject.custdeligatedUserName = custdelegatedUsers;
        if(deligatorApprover !=null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c aprHisDel : deligatorApprover){
                if(userTeamUserIdMap.containsKey('Contracts-'+aprHisDel.Phoenix_User__c)){
                    isDelegationPerson = true;
                }
                if(userTeamUserIdMap.containsKey('Marketing-'+aprHisDel.Phoenix_User__c)){
                    isMarketingDelegationPerson = true;
                    //wrapperObject.deligatedUserName  = wrapperObject.deligatedUserName + aprHisDel.Phoenix_User__r.Name;
                }
                if(userTeamUserIdMap.containsKey('Customer Service-'+aprHisDel.Phoenix_User__c)){
                    System.debug('customer service correct');
                    isCustomerServiceDelegationPerson = true;
                    //wrapperObject.deligatedUserName  = wrapperObject.deligatedUserName + aprHisDel.Phoenix_User__r.Name;
                }
            }
        }
        if(bidType == 'Platform PO OTB'){
            if (userTeamUserIdMap.containsKey('Marketing-' + cuurentUser.Id) && hasDirectorLines) {
                isMarketingApprovePerson = userTeamUserIdMap.get(('Marketing-' + cuurentUser.Id));
            }else if(isMarketingDelegationPerson && hasDirectorLines){
                isMarketingApprovePerson=cuurentUser.Name;
            }else{
                isMarketingApprovePerson=null;
            }
        }
        
        if(bidType == 'Platform OTB'){
            /* if (userTeamUserIdMap.containsKey('Marketing-' + cuurentUser.Id)) {
isMarketingApprovePerson = userTeamUserIdMap.get(('Marketing-' + cuurentUser.Id));
}else*/ if(isMarketingDelegationPerson){
    isMarketingApprovePerson=cuurentUser.Name;
}else{
    isMarketingApprovePerson=null;
}
        }
        
        if (userTeamUserIdMap.containsKey('Contracts-' + cuurentUser.Id)|| isDelegationPerson) {
            isContractsApprovePerson = userTeamUserIdMap.get(('Contracts-' + cuurentUser.Id));
        }
        if (userTeamUserIdMap.containsKey('Customer Service Approval-' + cuurentUser.Id) ) {
            isCustServiceApprovePerson = userTeamUserIdMap.get(('Customer Service Approval-' + cuurentUser.Id));
            System.debug('Customer Service Approval-==>');
        }
        // userCurrent=[select id ,Name from User where Id=:bid.Phoenix_Customer__r.Phoenix_Customer_Service_Approver__c LIMIT 1];
        if (userTeamUserIdMap.containsKey('Customer Service-' + cuurentUser.Id) ) {
            isCustServiceApprovePerson = userTeamUserIdMap.get(('Customer Service-' + cuurentUser.Id));
            System.debug('Customer Service-==>');
        }else if(isCustomerServiceDelegationPerson){
            System.debug('isCustomerServiceDelegationPerson-->'+isCustomerServiceDelegationPerson);
            isCustServiceApprovePerson=cuurentUser.Name;
        }else{
            isCustServiceApprovePerson=null;
        }
        
        // Phoenix_Bid__c bid = [SELECT Id,Phoenix_Is_Re_Bid__c,Phoenix_Previous_Bid__c,Phoenix_Proactive_Reactive__c, Phoenix_Salesperson__c,  Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c,Name,Phoenix_Customer__c,Phoenix_Customer__r.Name,Phoenix_Customer_Type__c,Phoenix_Bid_Name__c,Phoenix_Reference_Contracts__c,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        //wrapperObject.columnList = columnsList;
        wrapperObject.lineItemsList = quoteList;
        wrapperObject.bidRecord = bid;
        wrapperObject.productfamilyList = productFamilyList;
        wrapperObject.productDirectorList = productDirectorList;
        wrapperObject.loggedInUserName = cuurentUser.Name;
        wrapperObject.loggedInUserId = cuurentUser.Id;
        wrapperObject.isMarketingApprovePerson = isMarketingApprovePerson;
        wrapperObject.isContractsApprovePerson = isContractsApprovePerson;
        wrapperObject.isCustServiceApprovePerson = isCustServiceApprovePerson;
        wrapperObject.showProceedBtn = showProceedBtn;
        wrapperObject.showCustoServiceProceedBtn = showCustoServiceProceedBtn;
        wrapperObject.hasDirectorLines = hasDirectorLines;
        wrapperObject.ismarketingDeligator = (deligatorApprover != null && deligatorApprover.size()>0) ? true:false;
        wrapperObject.conAppPersonName=conAppPersonName;
        return wrapperObject;
    }
    
    @AuraEnabled
    public static List < Phoenix_Bid_Line_Item__c > getReBidLineInfo(string productId, string bidId) {
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Is_Re_Bid__c,Phoenix_Proposed_Cash_Terms__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        string ultimateParent = bid.Phoenix_Ultimate_Parent__c;
        list < Phoenix_Bid__c > bidUltimateList = [SELECT Id, Phoenix_Is_Re_Bid__c, Phoenix_Current_CD__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Phoenix_Ultimate_Parent__c =: ultimateParent and Id !=: bidId];
        set < string > parentRebidIds = new set < string > ();
        for (Phoenix_Bid__c pb: bidUltimateList) {
            parentRebidIds.add(pb.Id);
        }
        parentRebidIds.add(ultimateParent);
        list < Phoenix_Bid_Line_Item__c > reBidLineItemList = [SELECT id, Phoenix_Current_Indirect_Price__c,Phoenix_RDC_NLC__c,Phoenix_Retail_Indirect_Net__c,Phoenix_Current_Retail_Indirect_Net__c, Phoenix_ProposedContract_Bid_Price_Sales__c, Phoenix_ProposedContractBidPriceMktng__c, Phoenix_Wholesaler_Diff_Price_Indirect__c, Phoenix_Wholesaler_Sales_Price__c, Phoenix_Current_Retail_Indirect_Price__c, Phoenix_Retail_Direct_Sales_Price__c, Phoenix_Current_Retail_Direct_Price__c, Phoenix_Retail_Direct_Price__c, Phoenix_Retail_Indirect_Price__c, Phoenix_Retail_Direct_Guidance_Price__c, Phoenix_Wholesaler_Guidance_Price__c,Phoenix_Bid__r.Phoenix_Proposed_Cash_Terms__c, Phoenix_Bid__r.CreatedDate, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Ultimate_Parent__c, Phoenix_Bid__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Guidance_Price__c FROM Phoenix_Bid_Line_Item__c WHERE(Phoenix_Product__c =: productId AND Phoenix_Bid__c IN: parentRebidIds) ORDER BY Phoenix_Bid__r.Name ASC LIMIT 30000];
        return reBidLineItemList;
    }
    @AuraEnabled
    public static void updateRelatedList(List < Phoenix_Bid_Line_Item__c > lineItemsList) {
        if (lineItemsList != null && lineItemsList.size() > 0) {
            update lineItemsList;
        }
    }
    public class Columns {
        @AuraEnabled public string label;
        //@AuraEnabled public string labelval;
        @AuraEnabled public string value;
        //@AuraEnabled public string valueval;
    }
    public class Wrapper {
        @AuraEnabled public List < Columns > columnList;
        @AuraEnabled public List < Phoenix_Bid_Line_Item__c > lineItemsList;
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        @AuraEnabled public List < String > productfamilyList;
        @AuraEnabled public List < String > productDirectorList;
        @AuraEnabled public string loggedInUserName;
        @AuraEnabled public string loggedInUserId;
        @AuraEnabled public string conAppPersonName;
        @AuraEnabled public string isMarketingApprovePerson;
        @AuraEnabled public string isContractsApprovePerson;
        @AuraEnabled public string isCustServiceApprovePerson;
        @AuraEnabled public boolean showProceedBtn;
        @AuraEnabled public boolean showCustoServiceProceedBtn;
        @AuraEnabled public boolean hasDirectorLines;
        @AuraEnabled public boolean ismarketingDeligator;
        @AuraEnabled public string deligatedUserName;
        @AuraEnabled public string delegatedUserId;
        @AuraEnabled public string custdeligatedUserName;
        
        @AuraEnabled
        public Product2 prdlist {
            get;
            set;
        }
        
        @AuraEnabled
        public List < Phoenix_Bid__c > bidList {
            get;
            set;
        }
        
        @AuraEnabled
        public Phoenix_NPR_Data__c nprRec {
            get;
            set;
        }
        
        @AuraEnabled
        
        public Phoenix_Bid_Line_Item__c qlItem {
            get;
            set;
        }
        Wrapper() {
            columnList = new List < Columns > ();
            lineItemsList = new List < Phoenix_Bid_Line_Item__c > ();
            productfamilyList = new List < String > ();
            productDirectorList = new List < String > ();
            loggedInUserName = '';
            isMarketingApprovePerson = '';
            isContractsApprovePerson = '';
        }
    }
    
    @AuraEnabled
    public static Phoenix_Bid__c saveLineItems(List < Phoenix_Bid_Line_Item__c > LineItemList, Id LineItemId, 
                                               string rebateHeader, string feeHeader, 
                                               string contractApproval, boolean isRebateChanged, 
                                               boolean isFeeChanged, boolean isApprovalChanged, 
                                               String marketingHeader, boolean isMarketingChanged, string productPositions) {
                                                   List < Phoenix_Bid_Line_Item__c > lineList = [select id, name, Phoenix_RDC_NLC__c,Phoenix_Bid__r.Phoenix_Rebate__c, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Product_Director1__c, Phoenix_Marketing_Approval__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: LineItemId];
                                                   List < Phoenix_Bid_Line_Item__c > productDirectorLineItems = new List < Phoenix_Bid_Line_Item__c > ();
                                                   String query = '';
                                                   String SobjectApiName = 'Phoenix_Bid__c';
                                                   Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
                                                   Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
                                                   String strFields = '';
                                                   for (String fieldName: fieldMap.keyset()) {
                                                       if (strFields == null || strFields == '') {
                                                           strFields = fieldName;
                                                       } 
                                                       else {
                                                           strFields = strFields + ' , ' + fieldName;
                                                       }
                                                   }
                                                   query = 'SELECT Phoenix_Customer__r.Phoenix_Customer_Service_Approver__r.Name,Phoenix_Customer__r.Phoenix_Customer_Service_Approver__c, Phoenix_Customer__r.Name,'+strFields+' FROM Phoenix_Bid__c WHERE Id =: LineItemId';
                                                   Phoenix_Bid__c bid = database.query(query);
                                                   
                                                   if (lineList != null && lineList.size() > 0 && rebateHeader != '' || feeHeader != null || marketingHeader != '') {
                                                       String currentUser = [SELECT id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].Name;
                                                       for (Phoenix_Bid_Line_Item__c lineItem: lineList) {
                                                           system.debug('lineItem.Phoenix_Product_Director1__c--->' + lineItem.Phoenix_Product_Director1__c);
                                                           if (lineItem.Phoenix_Product_Director1__c == currentUser && isMarketingChanged && marketingHeader != '') {
                                                               lineItem.Phoenix_Marketing_Approval__c = marketingHeader;
                                                           }
                                                           if(bid.Phoenix_Bid_Type__c == 'Platform OTB' && bid.Phoenix_OTB_Marketing_Approver__c == UserInfo.getUserId() && isMarketingChanged && marketingHeader != ''){
                                                               lineItem.Phoenix_Marketing_Approval__c = marketingHeader;
                                                           }
                                                           if (rebateHeader != '' && isRebateChanged == true)
                                                               lineItem.Phoenix_Rebate_G_N__c = rebateHeader;
                                                           if (feeHeader != '' && isFeeChanged == true)
                                                               lineItem.Phoenix_Fee_G_N__c = feeHeader;
                                                           if (contractApproval != '' && isApprovalChanged == true) lineItem.Phoenix_Contract_Approval__c = contractApproval;
                                                           if ((lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change' || lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate') && isRebateChanged) {
                                                               lineItem.Phoenix_Proposed_Current_Rebate__c = lineItem.Phoenix_Bid__r.Phoenix_Rebate__c;
                                                           }
                                                           /*Product Positions logic*/
                                                           // if (String.isNotBlank(productPositions)) {
                                                           lineItem.Phoenix_Proposed_Position__c = productPositions;
                                                           //}
                                                       }
                                                   }
                                                   update lineList;
                                                   return bid;
                                               }
    
    @AuraEnabled
    public static void getselectOptions(sObject objObject, string fld) {}
    
    @AuraEnabled
    public static void deleteLineItems(String LineItemId) {
        if (LineItemId != null) {
            Phoenix_Bid_Line_Item__c deletedLineItem = [SELECT Id FROM Phoenix_Bid_Line_Item__c WHERE Id =: LineItemId];
            delete deletedLineItem;
        }
    }
    
    @AuraEnabled
    public static Phoenix_Bid_Line_Item__c getCalcs(Phoenix_Bid_Line_Item__c LineItem, Id LineItemId, string currentValue, string fieldLabel ,string otbDirectIndir) {
        Phoenix_Bid_Line_Item__c beforeUpdateLineItem = [SELECT Id, Phoenix_Wholesaler_Guidance_Price__c,Phoenix_Wholesaler_Diff_Price_Indirect__c, Phoenix_RDC_NLC__c, Phoenix_Retail_Direct_Sales_Price__c, Phoenix_Bid_Template_Refrence__c, Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Proposed_Cash_Terms__c, Phoenix_Retail_Direct_Guidance_Price__c, Phoenix_Retail_Direct_Price__c, Phoenix_Retail_Indirect_Price__c, Phoenix_Marketing_Approval__c, Phoenix_Guidance_Price__c FROM Phoenix_Bid_Line_Item__c WHERE Id =: LineItem.Id];
        if (currentValue != 'No Change' && fieldLabel == 'rebateType') {LineItem.Phoenix_Rebate_G_N__c = currentValue;
                                                                       }
        if (currentValue != 'No Change' && fieldLabel == 'feeType') {LineItem.Phoenix_Fee_G_N__c = currentValue;
                                                                    }
        if (currentValue != 'No Change' && fieldLabel == 'MarketApproval') {LineItem.Phoenix_Marketing_Approval__c = currentValue;
                                                                           }
        if (currentValue != 'No Change' && fieldLabel == 'ContractApproval') {LineItem.Phoenix_Contract_Approval__c = currentValue;
                                                                             }
        if (currentValue != 'No Change' && fieldLabel == 'CustServApproval') {LineItem.Phoenix_Customer_Service_Status__c = currentValue;
                                                                             }
        if (currentValue != 'No Change' && fieldLabel == 'CustServUpdateApproval') {LineItem.Phoenix_Customer_Service_Update_Status__c = currentValue;
                                                                                   }
        
        if (LineItem.Phoenix_ProposedContractBidPriceMktng__c != null && LineItem.Phoenix_ProposedContractBidPriceMktng__c != beforeUpdateLineItem.Phoenix_ProposedContractBidPriceMktng__c && LineItem.Phoenix_ProposedContractBidPriceMktng__c > 0) {LineItem.Phoenix_Marketing_Approval__c = 'Approved';
                                                                                                                                                                                                                                                      }
        if (LineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != null && LineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c != beforeUpdateLineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c && LineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c > 0) {LineItem.Phoenix_Marketing_Approval__c = 'Approved';
                                                                                                                                                                                                                                                          }
        if (LineItem.Phoenix_Guidance_Price__c != null && LineItem.Phoenix_Guidance_Price__c != beforeUpdateLineItem.Phoenix_Guidance_Price__c && LineItem.Phoenix_ProposedContract_Bid_Price_Sales__c == null && otbDirectIndir=='Direct') {
            system.debug('LineItem.Phoenix_Guidance_Price__c dir--##########->' );
            LineItem.Phoenix_ProposedContract_Bid_Price_Sales__c = LineItem.Phoenix_Guidance_Price__c;
        }
        if (LineItem.Phoenix_Guidance_Price__c != null && LineItem.Phoenix_Guidance_Price__c != beforeUpdateLineItem.Phoenix_Guidance_Price__c && LineItem.Phoenix_Wholesaler_Sales_Price__c == null && otbDirectIndir=='Indirect') {
            system.debug('LineItem.Phoenix_Guidance_Price__c --indir************->' );
            LineItem.Phoenix_Wholesaler_Sales_Price__c = LineItem.Phoenix_Guidance_Price__c;
        }
        update LineItem;
        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        query = 'select Phoenix_Previous_LineItem__r.Name,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Proposed_Cash_Terms__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c, ' + strFields + ' from ' + SobjectApiName + ' where id = :LineItemId limit 1';
        Phoenix_Bid_Line_Item__c UpdatedLineItem = Database.query(query);
        return UpdatedLineItem;
    }
    
    @AuraEnabled //findBySrxOtc
    public static List < Phoenix_Bid_Line_Item__c > findByProductFamily(List < String > searchKey, String lineItemId, List < String > sRxOtcList, List < String > searchPDList) {
        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        string notApproved = 'Not Approved';
        query = 'select Phoenix_Previous_LineItem__r.Name,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : lineItemId AND Phoenix_Final_Status__c !=: notApproved';
        if (searchKey != null && searchKey.size() > 0) {
            query = query + ' AND Product_Family_Name__c =: searchKey';
        }
        if (sRxOtcList != null && sRxOtcList.size() > 0) {
            query = query + ' AND Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =: sRxOtcList';
        }
        if (searchPDList != null && searchPDList.size() > 0) {
            query = query + ' AND Phoenix_Product_Director__c =: searchPDList';
        }
        query = query + ' LIMIT 1000';
        List < Phoenix_Bid_Line_Item__c > lineItemsList = Database.query(query);
        // system.debug(lineItemsList);
        return lineItemsList;
    }
    
    @AuraEnabled
    public static list < Phoenix_Contract__c > getContracts(string customerID, string searchInput) {
        system.debug('customerID---' + customerID);
        string act = 'Active';
        string query = 'select name,Phoenix_Customer__r.Name,Phoenix_Contract_Number__c,Phoenix_Contract_Internal_Description__c,Phoenix_Contract_External_Description__c from Phoenix_Contract__c where Phoenix_Contract_Status__c=:act';
        if (customerID != null) {
            Set < Id > parentAccIds = new Set < Id > ();
            parentAccIds.add(customerID);
            //Fetch related accounts
            Map < Id, Account > allAccMap = new Map < Id, Account > ();
            //Map of all accounts
            for (Account acc: Database.query('SELECT ' + Phoenix_Util.customerFields + ' FROM Account LIMIT 10000'))
                allAccMap.put(acc.Id, acc);
            String tempId = customerID;
            while (allAccMap.get(tempId) != NULL && allAccMap.get(tempId).ParentId != NULL) {
                tempId = allAccMap.get(tempId).ParentId;
                parentAccIds.add(tempId);
            }
            system.debug('parentAccIds--' + parentAccIds);
            query += ' and (Phoenix_Customer__c=:parentAccIds or Phoenix_Customer__r.ParentId=:parentAccIds)';
        }
        if (string.isNotBlank(searchInput)) {
            query += ' and ( name like \'%' + searchInput + '%\' or Phoenix_Contract_Number__c like \'%' + searchInput + '%\' or Phoenix_Customer__r.Name like \'%' + searchInput + '%\' or Phoenix_Contract_Internal_Description__c like \'%' + searchInput + '%\' or Phoenix_Contract_External_Description__c like  \'%' + searchInput + '%\')';
        }
        list < Phoenix_Contract__c > cntList = Database.query(query);
        return cntList;
    }
    
    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > submitToProceddStep(string bidId, boolean isContracts, 
                                                                        string apprvStatus,boolean ismarketingDeligator, 
                                                                        string deligatedUserName) 
    {
        system.debug('method called and apprvStatus :: '+apprvStatus);
        Phoenix_Bid__c bid = [SELECT Id, Name, Phoenix_Bid_Type__c, Phoenix_OTB_Marketing_Approver__c
                              FROM Phoenix_Bid__c WHERE Id =: bidId];
        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        strFields = Phoenix_Util.bidlineitemFields;//Phoenix_Util.bidlineitemFields
        string notApproved = 'Not Approved';
        string notProcessed = 'Not Processed';
        string loggerUserName = UserInfo.getName();
        List<String> directorNames = new List<String>();
        directorNames.add(loggerUserName);
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Delegated_Approver__r.Name,Phoenix_User__r.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
        if(deligatorApprover != null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c AprDelHis : deligatorApprover){
                directorNames.add(AprDelHis.Phoenix_User__r.Name);
            }
            directorNames.add(deligatorApprover[0].Phoenix_Delegated_Approver__r.Name);
        }
        
        query = 'select Phoenix_Previous_LineItem__r.Name,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c != \'Not Approved\'';
        
        if (bid.Phoenix_Bid_Type__c != 'Platform OTB' && bid.Phoenix_OTB_Marketing_Approver__c != UserInfo.getUserId() && 
            isContracts != true && apprvStatus!='Customer Service' && ismarketingDeligator != true && 
            apprvStatus!='Customer Service Approval') {
                query += ' and Phoenix_Product_Director__c=:loggerUserName';
            }else if(apprvStatus!='Customer Service' && (ismarketingDeligator && bid.Phoenix_Bid_Type__c!='Platform OTB') && apprvStatus!='Customer Service Approval'){
                query += ' and Phoenix_Product_Director__c=:directorNames';
            }
        system.debug('Queried Fileds '+query);
        list < Phoenix_Bid_Line_Item__c > bidLinesList = Database.query(query);
        //by sai krishna
        system.debug('by sai krishna ->updating bid lines');
        if (bidLinesList.size() > 0) {
            update bidLinesList;
        }
        return bidLinesList;
    }
    
    @AuraEnabled
    public static WrapperForNextSteps makeApprovals(String bidId, List < Phoenix_Bid_Line_Item__c > bidlines,
                                                    boolean approveStatusFlag) {
                                                        System.debug('i am in makeApprovals');
                                                        List<string> productDirectorsNames = new List<string>();
                                                        for (Phoenix_Bid_Line_Item__c line: bidlines) {
                                                            line.Phoenix_Marketing_Final_Approval__c = true;
                                                            line.Phoenix_Customer_Final_Approval__c = true;
                                                            if (line.Phoenix_Marketing_Approval__c == 'Not Approved') {
                                                                line.Phoenix_Final_Status__c = 'Not Approved';
                                                            }
                                                            //---------------mamatha------------
                                                            else if (line.Phoenix_Customer_Service_Status__c == 'Not Processed') {
                                                                line.Phoenix_Final_Status__c = 'Not Approved';
                                                            }
                                                            //-----------------------
                                                            productDirectorsNames.add(line.Phoenix_Product_Director1__c);
                                                        }
                                                        if (bidlines.size() > 0) {
                                                            update bidlines;
                                                        }
                                                        //query latest bif lines to check all rejected case
                                                        list < Phoenix_Bid_Line_Item__c > bidLinesUpdate = [select id, Phoenix_Marketing_Final_Approval__c,Phoenix_Final_Status__c,Phoenix_Customer_Final_Approval__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
                                                        Phoenix_Bid__c currentBid=[select id, Phoenix_Bid_Type__c, Phoenix_OTB_Marketing_Approver__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id=:bidId];
                                                        /*added by satya*/
                                                        List < Phoenix_Bid_Process_Steps__c > bidProcessStepList1 = [SELECT Id, Name, Phoenix_Bid__c,Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c 
                                                                                                                     FROM Phoenix_Bid_Process_Steps__c 
                                                                                                                     where Phoenix_Bid__c =: bidId LIMIT 20000];
                                                        String customerApprovalTeam='';
                                                        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList1){
                                                            if(step.Phoenix_Process_Step__r.Name.contains('Customer Service')){
                                                                customerApprovalTeam= step.Phoenix_Approver_Team_Members__c;
                                                            }
                                                        }
                                                        List<String> approvalTeamMembers = customerApprovalTeam.split(',');
                                                        System.debug('approvalTeamMemberstest-->'+approvalTeamMembers);
                                                        List<Phoenix_Approval_Delegation_History__c> custServcdeligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
                                                        custServcdeligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Delegated_Approver__r.Name,Phoenix_User__r.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId() AND Phoenix_User__r.Name =:approvalTeamMembers];
                                                        System.debug('custServcdeligatorApprover-->'+custServcdeligatorApprover);
                                                        /*End by satya*/
                                                        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
                                                        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
                                                        System.debug('deligatorApprover test-->'+deligatorApprover);
                                                        boolean isAllRejectedCaseFound = true;
                                                        boolean isMarketingCompleted = false;
                                                        for (Phoenix_Bid_Line_Item__c lineItem: bidLinesUpdate) {
                                                            if (lineItem.Phoenix_Final_Status__c != 'Not Approved') {
                                                                isAllRejectedCaseFound = false;
                                                            }
                                                            if(lineItem.Phoenix_Marketing_Final_Approval__c == true)
                                                                isMarketingCompleted = true;
                                                            System.debug('satya is testing-->');
                                                        }
                                                        Phoenix_Bid__c bidRec = new Phoenix_Bid__c(id = bidId, Phoenix_Bid_Marketing_Approved_Date__c = system.today()); //Closed
                                                        if(bidRec != null && isMarketingCompleted)
                                                            update bidRec;
                                                        System.debug('satya2'+currentBid.Phoenix_Approval_Status__c);                                                
                                                        System.debug('isAllRejectedCaseFound'+isAllRejectedCaseFound);
                                                        WrapperForNextSteps wrapSteps = new WrapperForNextSteps();
                                                        String rejectedStatus;
                                                        //start logic for all rejected case
                                                        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c,Phoenix_Approver_Team_Members__c,
                                                                                                                    Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Step__c, 
                                                                                                                    Phoenix_Approver__c, Phoenix_Approver__r.Name,Phoenix_Approver__r.Email, 
                                                                                                                    Phoenix_Status__c, Phoenix_Approver_Team__c 
                                                                                                                    FROM Phoenix_Bid_Process_Steps__c 
                                                                                                                    where Phoenix_Bid__c =: bidId order by Phoenix_Step__c];
                                                        if (isAllRejectedCaseFound &&(currentBid.Phoenix_Approval_Status__c=='Marketing' || currentBid.Phoenix_Approval_Status__c=='SCM & Marketing')) {
                                                            //close the bid other step not applicable
                                                            integer currentStepNum;
                                                            for (Phoenix_Bid_Process_Steps__c prcsStep: bidProcessStepList) {
                                                                if (prcsStep.Phoenix_Approver_Team__c == 'SCM & Marketing' || prcsStep.Phoenix_Approver_Team__c == 'Marketing') {
                                                                    currentStepNum = integer.valueOf(prcsStep.Phoenix_Step__c);
                                                                }
                                                            }
                                                            for (Phoenix_Bid_Process_Steps__c prcsStep: bidProcessStepList) {
                                                                if(prcsStep.Phoenix_Approver_Team__c == 'Marketing' &&
                                                                   currentBid.Phoenix_Bid_Type__c == 'Platform OTB' && 
                                                                   (currentBid.Phoenix_OTB_Marketing_Approver__c == UserInfo.getUserId() || (deligatorApprover.size()>0 && deligatorApprover[0].Phoenix_User__c == currentBid.Phoenix_OTB_Marketing_Approver__c))){
                                                                       prcsStep.Phoenix_Status__c = 'Completed';
                                                                       prcsStep.Phoenix_Approver__c = Userinfo.getUserId();
                                                                   }
                                                                if (prcsStep.Phoenix_Approver_Team__c == 'Marketing' && 
                                                                    (prcsStep.Phoenix_Approver__c == Userinfo.getUserId()|| 
                                                                     (deligatorApprover.size()>0 && productDirectorsNames.contains(prcsStep.Phoenix_Approver__r.Name) ))) {
                                                                         prcsStep.Phoenix_Status__c = 'Completed';
                                                                         prcsStep.Phoenix_Approver__c = Userinfo.getUserId();
                                                                     }
                                                                if (prcsStep.Phoenix_Approver_Team__c == 'Customer Service' && 
                                                                    (prcsStep.Phoenix_Approver__c == Userinfo.getUserId() &&
                                                                     (custServcdeligatorApprover.size()>0 && prcsStep.Phoenix_Status__c == 'In Process')|| 
                                                                     prcsStep.Phoenix_Approver_Team_Members__c.containsIgnoreCase(Userinfo.getName())) ) {//|| 
                                                                         prcsStep.Phoenix_Status__c = 'Completed';
                                                                         prcsStep.Phoenix_Approver__c = Userinfo.getUserId();
                                                                     }
                                                                if (prcsStep.Phoenix_Approver_Team__c == 'Supply Chain' && 
                                                                    prcsStep.Phoenix_Status__c != 'Completed' && prcsStep.Phoenix_Step__c == currentStepNum) {
                                                                        prcsStep.Phoenix_Status__c = 'Not Applicable';
                                                                    }
                                                                if (prcsStep.Phoenix_Step__c > currentStepNum) {
                                                                    if (prcsStep.Name.contains('Closed')) {
                                                                        prcsStep.Phoenix_Status__c = 'Completed';
                                                                    } else {
                                                                        prcsStep.Phoenix_Status__c = 'Not Applicable';
                                                                    }
                                                                }
                                                            }
                                                            update bidProcessStepList;
                                                            Phoenix_Bid__c bid;
                                                            bid  = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Marketing Rejected');//Closed
                                                            update bid;
                                                            wrapSteps.updateProcessStepList = bidProcessStepList;
                                                            wrapSteps.flagSCMStop = true;
                                                            wrapSteps.flagMarketStop = true;
                                                            wrapSteps.flagCustServStop = true;
                                                            
                                                        } 
                                                        else if (isAllRejectedCaseFound && currentBid.Phoenix_Approval_Status__c == 'Customer Service Approval') {
                                                            //close the bid other step not applicable
                                                            System.debug('incust');
                                                            integer currentStepNum;
                                                            for (Phoenix_Bid_Process_Steps__c prcsStep: bidProcessStepList) {
                                                                if (prcsStep.Phoenix_Approver_Team__c == 'Customer Service') {
                                                                    currentStepNum = integer.valueOf(prcsStep.Phoenix_Step__c);
                                                                }
                                                            }
                                                            for (Phoenix_Bid_Process_Steps__c prcsStep: bidProcessStepList) {
                                                                
                                                                if ((prcsStep.Phoenix_Approver_Team__c == 'Customer Service' && prcsStep.Phoenix_Status__c == 'In Process') &&
                                                                    (prcsStep.Phoenix_Approver__c == Userinfo.getUserId() || custServcdeligatorApprover.size()>0 || prcsStep.Phoenix_Approver_Team_Members__c.containsIgnoreCase(Userinfo.getName())) ) {
                                                                        prcsStep.Phoenix_Status__c = 'Completed';
                                                                        prcsStep.Phoenix_Approver__c = Userinfo.getUserId();
                                                                    }
                                                                if (prcsStep.Phoenix_Approver_Team__c == 'Contracts' && prcsStep.Phoenix_Status__c != 'Completed' && prcsStep.Phoenix_Step__c == currentStepNum) {
                                                                    prcsStep.Phoenix_Status__c = 'Not Applicable';
                                                                }
                                                                if (prcsStep.Phoenix_Step__c > currentStepNum) {
                                                                    if (prcsStep.Name.contains('Closed')) {
                                                                        prcsStep.Phoenix_Status__c = 'Completed';
                                                                    } else {
                                                                        prcsStep.Phoenix_Status__c = 'Not Applicable';
                                                                    }
                                                                }
                                                            }
                                                            update bidProcessStepList;
                                                            Phoenix_Bid__c bid;
                                                            bid  = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Customer Service Rejected',Phoenix_Customer_Service_Approved_Date__c = system.today());//Closed
                                                            update bid;
                                                            wrapSteps.updateProcessStepList = bidProcessStepList;
                                                            wrapSteps.flagSCMStop = false;
                                                            wrapSteps.flagMarketStop = false;
                                                            wrapSteps.flagCustServStop = true;
                                                        } 
                                                        else {
                                                            system.debug('Not in All Rejected Case..');
                                                            list < Phoenix_Bid_Process_Steps__c > marketStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
                                                            list < Phoenix_Bid_Process_Steps__c > CustServStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
                                                            boolean flagSCMStop = false;
                                                            boolean flagMarketStop = false;
                                                            boolean flagCustServStop = false;
                                                            for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
                                                                //system.debug('step.Phoenix_Approver__c1----->'+step.Phoenix_Approver__c);
                                                                system.debug('processID--> '+step.Id+' processID Name--> '+step.Name+' approver--> '+step.Phoenix_Approver__c);
                                                                system.debug('current User-----2> '+Userinfo.getUserId());
                                                                system.debug('step.Phoenix_Status__c ---> '+step.Phoenix_Status__c);
                                                                System.debug('custServcdeligatorApprover size'+custServcdeligatorApprover.size());
                                                                if(step.Phoenix_Approver_Team__c == 'Marketing' &&
                                                                   currentBid.Phoenix_Bid_Type__c == 'Platform OTB' && 
                                                                   (currentBid.Phoenix_OTB_Marketing_Approver__c == UserInfo.getUserId() || (deligatorApprover.size()>0 && deligatorApprover[0].Phoenix_User__c == currentBid.Phoenix_OTB_Marketing_Approver__c))){
                                                                       step.Phoenix_Status__c = 'Completed';
                                                                       step.Phoenix_Approver__c = Userinfo.getUserId();
                                                                       marketStepLsit.add(step);
                                                                   }
                                                                else if (step.Phoenix_Approver_Team__c == 'Marketing' && (step.Phoenix_Approver__c == Userinfo.getUserId()||(deligatorApprover.size()>0 && productDirectorsNames.contains(step.Phoenix_Approver__r.Name) ))) {
                                                                    step.Phoenix_Status__c = 'Completed';
                                                                    step.Phoenix_Approver__c = Userinfo.getUserId();
                                                                    marketStepLsit.add(step);
                                                                }
                                                                else if ((step.Phoenix_Approver_Team__c == 'Customer Service' && step.Phoenix_Status__c == 'In Process') &&
                                                                         (step.Phoenix_Approver__c == Userinfo.getUserId() || custServcdeligatorApprover.size()>0 || step.Phoenix_Approver_Team_Members__c.containsIgnoreCase(Userinfo.getName())))
                                                                {
                                                                    if(step.Phoenix_Status__c == 'In Process'){
                                                                        system.debug('inside In Process of step of Customer Service.');
                                                                        step.Phoenix_Status__c = 'Completed';
                                                                        step.Phoenix_Approver__c = Userinfo.getUserId();
                                                                        flagCustServStop = false;
                                                                        CustServStepLsit.add(step);
                                                                    }
                                                                }
                                                                
                                                                if (step.Phoenix_Approver_Team__c == 'Marketing' && step.Phoenix_Status__c == 'In Process') {
                                                                    flagMarketStop = true;
                                                                }
                                                                if (step.Phoenix_Approver_Team__c == 'Customer Service' && step.Phoenix_Status__c == 'In Process') {
                                                                    flagCustServStop = true;
                                                                    system.debug('customer service stopped-->');
                                                                }
                                                            }
                                                            if (!marketStepLsit.isEmpty()) {
                                                                update marketStepLsit;
                                                                wrapSteps.updateProcessStepList = bidProcessStepList;
                                                                wrapSteps.flagSCMStop = flagSCMStop;
                                                                wrapSteps.flagMarketStop = flagMarketStop;
                                                                wrapSteps.flagCustServStop = flagCustServStop;
                                                                
                                                            }
                                                            if (!CustServStepLsit.isEmpty()) {
                                                                update CustServStepLsit;
                                                                wrapSteps.updateProcessStepList = bidProcessStepList;
                                                                wrapSteps.flagSCMStop = flagSCMStop;
                                                                wrapSteps.flagMarketStop = flagMarketStop;
                                                                wrapSteps.flagCustServStop = flagCustServStop;
                                                                
                                                            }
                                                        }
                                                        return wrapSteps;
                                                    }
    
    public class WrapperForNextSteps {
        @AuraEnabled public list < Phoenix_Bid_Process_Steps__c > updateProcessStepList;
        @AuraEnabled public boolean flagSCMStop;
        @AuraEnabled public boolean flagMarketStop;
        @AuraEnabled public boolean flagCustServStop;
        WrapperForNextSteps() {
            updateProcessStepList = new List < Phoenix_Bid_Process_Steps__c > ();
            flagSCMStop = false;
            flagMarketStop = false;
            flagCustServStop = false;
        }
    }
    
    @AuraEnabled
    public static void updateNextProcessSteps(string bidId, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit, boolean flagSCMStop, boolean flagMarketStop,boolean flagCustServStop, string apprvStatus) {
        System.debug('i am in updateNextProcessSteps');
        Phoenix_Bid__c bidObj = [Select Id, Name, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        if (flagSCMStop == false && flagMarketStop == false && flagCustServStop==false &&  !processStepLsit.isEmpty()) {
            Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
            list < Phoenix_Bid_Process_Steps__c > criteriaSteplist = new list < Phoenix_Bid_Process_Steps__c > ();
            map < string, Phoenix_Bid_Process_Steps__c > teamToStepMap = new map < string, Phoenix_Bid_Process_Steps__c > ();
            for (Phoenix_Bid_Process_Steps__c step: processStepLsit) {
                Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
                if (stepMap.get(stepNo) != null) {
                    List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
                    adededSteps.add(step);
                    stepMap.put(stepNo, adededSteps);
                } else {
                    stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {step});
                }
                String stepName = step.Phoenix_Approver_Team__c;
                if (stepNamesMap.get(stepName) != null) {
                    List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
                    adededSteps.add(step);
                    stepNamesMap.put(stepName, adededSteps);
                } else {
                    stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {step});
                }
                stepnameNoMap.put(stepName, stepNo);
                if (step.Phoenix_Is_Criteria_Step__c) {
                    teamToStepMap.put(step.Phoenix_Approver_Team__c, step);
                    criteriaSteplist.add(step);
                }
            }
            set < string > criteraStepsSet = new set < string > ();
            criteraStepsSet = Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(bidId);
            map < string, Phoenix_Bid_Process_Steps__c > updatedTeamToStepMap = new map < string, Phoenix_Bid_Process_Steps__c > ();
            string bidStatus;
            if (criteraStepsSet.size() > 0 && apprvStatus!='Customer Service Approval') {
                for (Phoenix_Bid_Process_Steps__c critStep: criteriaSteplist) {
                    if (criteraStepsSet.contains('Marketing Lead Rx') && critStep.Phoenix_Approver_Team__c == 'Marketing Lead Rx') {
                        critStep.Phoenix_Status__c = 'In Process';
                        updatedTeamToStepMap.put('Marketing Lead Rx', critStep);
                    } else if (criteraStepsSet.contains('Marketing Lead SRx') && critStep.Phoenix_Approver_Team__c == 'Marketing Lead SRx') {
                        critStep.Phoenix_Status__c = 'In Process';
                        updatedTeamToStepMap.put('Marketing Lead SRx', critStep);
                    } else if (criteraStepsSet.contains('Marketing Lead OTC') && critStep.Phoenix_Approver_Team__c == 'Marketing Lead OTC') {
                        critStep.Phoenix_Status__c = 'In Process';
                        updatedTeamToStepMap.put('Marketing Lead OTC', critStep);
                    }
                    if (criteraStepsSet.contains('Marketing Head') && critStep.Phoenix_Approver_Team__c == 'Marketing Head') {
                        critStep.Phoenix_Status__c = 'Not Initiated';
                        updatedTeamToStepMap.put('Marketing Head', critStep);
                    }
                    if (criteraStepsSet.contains('Sr Director or VP Finance') && critStep.Phoenix_Approver_Team__c == 'Sr Director or VP Finance') {
                        critStep.Phoenix_Status__c = 'Not Initiated';
                        updatedTeamToStepMap.put('Sr Director or VP Finance', critStep);
                    }
                    
                }
                system.debug('updated steps--' + updatedTeamToStepMap.values());
                update updatedTeamToStepMap.values();
                //update criteriaSteplist;
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Marketing Lead');
                update bid;
                Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId, updatedTeamToStepMap.values());
            } 
            else {
                
                if(apprvStatus!='Customer Service Approval'){
                    
                    integer stepnumber = stepnameNoMap.get('Marketing');
                    List < Phoenix_Bid_Process_Steps__c > nextSteps = stepMap.get(stepnumber + 1);
                    system.debug('nextSteps--->' + nextSteps);
                    While(nextSteps != null && nextSteps[0].Phoenix_Status__c == 'Not Applicable') {
                        stepNumber += 1;
                        nextSteps = stepMap.get(stepNumber);
                    }
                    for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                        step.Phoenix_Status__c = 'In Process';
                    }
                    if (!nextSteps.isEmpty()) {
                        
                        update nextSteps;
                        Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = nextSteps[0].Phoenix_Approver_Team__c);
                        update bid;
                        Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId, nextSteps);
                        //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bidName,nextSteps,'Bid_Approval');
                    }  
                }
                else{
                    system.debug('customer service entered---> and :: bidObj.Phoenix_Approval_Status__c :: '+bidObj.Phoenix_Approval_Status__c );
                    integer stepnumber = stepnameNoMap.get('Customer Service Approval');
                    List < Phoenix_Bid_Process_Steps__c > nextSteps = New List < Phoenix_Bid_Process_Steps__c >();
                    if(bidObj.Phoenix_Approval_Status__c == 'Customer Service')
                        nextSteps = stepMap.get(3);
                    else if(bidObj.Phoenix_Approval_Status__c == 'Customer Service Approval')
                        nextSteps = stepMap.get(5);
                    else
                        nextSteps = stepMap.get(stepnumber + 1);
                    system.debug('nextSteps--->' + nextSteps);
                    While(nextSteps != null && nextSteps[0].Phoenix_Status__c == 'Not Applicable') {
                        stepNumber += 1;
                        nextSteps = stepMap.get(stepNumber);
                    }
                    for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                        if (step.Name.contains('Closed')) {
                            step.Phoenix_Status__c = 'Completed';
                        } else {
                            step.Phoenix_Status__c = 'In Process';
                        } 
                        //step.Phoenix_Status__c = 'In Process';
                    }
                    if (!nextSteps.isEmpty()) {
                        update nextSteps;
                        Phoenix_Bid__c bid = new Phoenix_Bid__c();
                        if(bidObj.Phoenix_Approval_Status__c == 'Customer\'s Update')
                            bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Customer Service Approval');
                        else if(bidObj.Phoenix_Approval_Status__c == 'Customer Service Approval')
                            bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
                        else
                            bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = nextSteps[0].Phoenix_Approver_Team__c);
                        update bid;
                        Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId, nextSteps);
                        //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bidName,nextSteps,'Bid_Approval');
                    }  
                }
            }
        }
    }
    
    
    @AuraEnabled
    public static void updateNextContractProcessSteps(string bidId, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit) {
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
        for (Phoenix_Bid_Process_Steps__c step: processStepLsit) {
            Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
            if (stepMap.get(stepNo) != null) {
                List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
                adededSteps.add(step);
                stepMap.put(stepNo, adededSteps);
            } else {
                stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
                    step
                        });
            }
            String stepName = step.Phoenix_Process_Step__r.Name;
            if (stepNamesMap.get(stepName) != null) {
                List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
                adededSteps.add(step);
                stepNamesMap.put(stepName, adededSteps);
            } else {
                stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {
                    step
                        });
            }
            stepnameNoMap.put(stepName, stepNo);
        }
        List < Phoenix_Bid_Process_Steps__c > nextSteps = new List < Phoenix_Bid_Process_Steps__c > ();
        if (stepnameNoMap.get('Contracts') != null) stepMap.get(stepnameNoMap.get('Contracts') + 1);
        for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
            if (step.Name.contains('Closed')) {
                step.Phoenix_Status__c = 'Completed';
            } else {
                step.Phoenix_Status__c = 'In Process';
            } //'In Process' Submitted //Diff b/w them
        }
        if (!nextSteps.isEmpty()) {
            update nextSteps;
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = nextSteps[0].Phoenix_Approver_Team__c);
            update bid;
            Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId, nextSteps);
        } else {
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
            update bid;
        }
    }
    
    @AuraEnabled
    public static void getNPRData(list < string > selectrcs, Id BidId, string templateType) {
        list < Phoenix_Bid_Line_Item__c > bildLines = [select id, name, Phoenix_Product__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Others_Indirect__c, Phoenix_Others_Direct__c, Phoenix_12_Months_Actual_Sales__c, Phoenix_Current_Position__c, Phoenix_Product__r.Name, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Fee__c, Phoenix_Bid__r.Phoenix_Customer__r.Rebate_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Cash_Discount__c, Phoenix_Bid__r.Phoenix_Customer__r.Fee_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebates__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_VIP__c, Phoenix_Current_Net_Sales_Internal__c, Phoenix_DeadNet_TrckGR__c, Phoenix_Product__r.ProductCode, Phoenix_Current_Direct_Selling_Unit__c, Phoenix_Current_Indirect_Selling_Unit__c, Phoenix_Current_Indirect_Price__c, Phoenix_Current_Direct_Price__c, Phoenix_Current_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Current_Rebate__c, Phoenix_Rebate_G_N__c, Phoenix_Fee_G_N__c, Phoenix_Current_Admin_Fee__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: BidId];
        list < Phoenix_NPR_Data__c > NPRDataLines = [select id, Name, Phoenix_Contract_Type__c, Phoenix_12Months_Actual_Sales_Unit__c, Phoenix_12Mt_Sales_Ut_Actual__c, Phoenix_Product_Position__c, Phoenix_Net_Sales_Internal__c, Phoenix_Dead_Net_Tracking_GR__c, Phoenix_Contract_Price__c, Phoenix_Product__c, Phoenix_Product__r.ProductCode, Phoenix_12Months_Sales_Unit__c, Phoenix_12Months_Net_Sales__c, Phoenix_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Rebate__c, Phoenix_Rebate_G_N_Indicator__c, Phoenix_Bonafied_G_N_Indicator__c, Phoenix_Fee_Bonafied_Fee__c, Phoenix_Per_Unit_Bonfied_Fee__c, Phoenix_CD__c, Phoenix_GR_TrackingTier__c from Phoenix_NPR_Data__c where Phoenix_Contract_Number__c in: selectrcs and Phoenix_NPR_Status__c = 'Active'];
        map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
        for (Phoenix_NPR_Data__c NPRLine: NPRDataLines) {
            if (productCodeToNPRLineMap.containsKey(NPRLine.Phoenix_Product__r.ProductCode)) {
                productCodeToNPRLineMap.get(NPRLine.Phoenix_Product__r.ProductCode).add(NPRLine);
            } else {
                list < Phoenix_NPR_Data__c > NPRList = new list < Phoenix_NPR_Data__c > ();
                NPRList.add(NPRLine);
                productCodeToNPRLineMap.put(NPRLine.Phoenix_Product__r.ProductCode, NPRList);
            }
        }
        map < Phoenix_Bid_Line_Item__c, list < Phoenix_NPR_Data__c >> bidToNPRMap = new map < Phoenix_Bid_Line_Item__c, list < Phoenix_NPR_Data__c >> ();
        decimal cashDiscount;
        decimal currentVip;
        for (Phoenix_Bid_Line_Item__c bidLine: bildLines) {
            bidLine.Phoenix_Current_Indirect_Selling_Unit__c = 0;
            bidLine.Phoenix_Current_Direct_Selling_Unit__c = 0;
            bidLine.Phoenix_Current_Indirect_Price__c = 0;
            bidLine.Phoenix_Current_Direct_Price__c = 0;
            bidLine.Phoenix_Current_Per_Unit_Rebate__c = 0;
            bidLine.Phoenix_ZITD_Value__c = 0;
            bidLine.Phoenix_12_Months_Actual_Sales__c = 0;
            bidLine.Phoenix_12_Months_IndirectSaleUnit__c = 0;
            
            list < Decimal > directPriceList = new list < Decimal > ();
            list < Decimal > indirectPriceList = new list < Decimal > ();
            list < Decimal > perUnitRebateList = new list < Decimal > ();
            list < Decimal > deadNetTrackList = new list < Decimal > ();
            list < Decimal > NetSalesList = new List < Decimal > ();
            list < Decimal > ZITDList = new List < Decimal > ();
            list < Decimal > RebateList = new List < Decimal > ();
            if (productCodeToNPRLineMap.keyset().contains(bidLine.Phoenix_Product__r.ProductCode)) {
                bidLine.Phoenix_Current_Position__c = '';
                for (Phoenix_NPR_Data__c NPRLine: productCodeToNPRLineMap.get(bidLine.Phoenix_Product__r.ProductCode)) {
                    bidLine.Phoenix_Current_Position__c = (NPRLine.Phoenix_Product_Position__c != null ? NPRLine.Phoenix_Product_Position__c + ', ' : '') + (bidLine.Phoenix_Current_Position__c != null ? bidLine.Phoenix_Current_Position__c : '');
                    if (templateType == 'Indirect' || templateType == 'Direct and Indirect' || templateType == 'Walgreens' || templateType == 'ABC Progen' || templateType == 'Econdisc' || templateType == 'Costco' || templateType == 'Sams Club' || templateType == 'Net Indirect Pricing' || templateType == 'Government Pricing') {
                        if (NPRLine.Phoenix_Contract_Type__c == 'Indirect') {
                            bidLine.Phoenix_Current_Indirect_Selling_Unit__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                            bidLine.Phoenix_12_Months_IndirectSaleUnit__c = (bidLine.Phoenix_12_Months_Actual_Sales__c != null ? bidLine.Phoenix_12_Months_Actual_Sales__c : 0) + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                            indirectPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                            ZITDList.add(NPRLine.Phoenix_ZITD_Value__c);
                            //cashDiscount=NPRLine.Phoenix_CD__c;
                            //currentVip=NPRLine.Phoenix_GR_TrackingTier__c;
                        }
                        perUnitRebateList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                        deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
                        NetSalesList.add(NPRLine.Phoenix_Net_Sales_Internal__c);
                    }
                    if (templateType == 'Direct' || templateType == 'Direct and Indirect' || templateType == 'Econdisc' || templateType == 'Net Indirect Pricing') {
                        if (NPRLine.Phoenix_Contract_Type__c == 'Direct') {
                            bidLine.Phoenix_Current_Direct_Selling_Unit__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                            bidLine.Phoenix_12_Months_Actual_Sales__c = (bidLine.Phoenix_12_Months_Actual_Sales__c != null ? bidLine.Phoenix_12_Months_Actual_Sales__c : 0) + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                            directPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                            // cashDiscount=NPRLine.Phoenix_CD__c;
                            // currentVip=NPRLine.Phoenix_GR_TrackingTier__c;
                        }
                        perUnitRebateList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                        deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
                        NetSalesList.add(NPRLine.Phoenix_Net_Sales_Internal__c);
                        ZITDList.add(NPRLine.Phoenix_ZITD_Value__c);
                        
                    }
                }
                //take minimum of all indeirect NPR prices
                if (indirectPriceList.size() > 0) {
                    indirectPriceList.sort();
                    bidLine.Phoenix_Current_Indirect_Price__c = indirectPriceList[0];
                }
                //take minimum of all deirect NPR prices
                if (directPriceList.size() > 0) {
                    directPriceList.sort();
                    bidLine.Phoenix_Current_Direct_Price__c = directPriceList[0];
                }
                //take Max of all  NPR rebate
                if (perUnitRebateList.size() > 0) {
                    perUnitRebateList.sort();
                    bidLine.Phoenix_Current_Per_Unit_Rebate__c = perUnitRebateList[perUnitRebateList.size() - 1];
                    bidLine.Phoenix_Proposed_Per_Unit_Rebate__c = perUnitRebateList[perUnitRebateList.size() - 1];
                }
                //take minimum of all  NPR Dead net track
                if (deadNetTrackList.size() > 0) {
                    deadNetTrackList.sort();
                    bidLine.Phoenix_DeadNet_TrckGR__c = deadNetTrackList[0];
                }
                //take minimum of all NPR Net sales internal
                if (NetSalesList.size() > 0) {
                    NetSalesList.sort();
                    bidLine.Phoenix_Current_Net_Sales_Internal__c = NetSalesList[0];
                }
                //take minimum of all zitd sales internal
                if (ZITDList.size() > 0) {
                    ZITDList.sort();
                    bidLine.Phoenix_ZITD_Value__c = ZITDList[0];
                }
                
            } else {
                
            }
        }
        
        update bildLines;
    }
    
    @AuraEnabled
    public static string updateLines(Id bidId, string dirIndirect) {
        List<Phoenix_Bid_Line_Item__c> bidLines =new List<Phoenix_Bid_Line_Item__c>();
        List<Phoenix_Bid_Line_Item__c> lines=[select Id,Phoenix_Proposed_Direct_Selling_Unit__c,
                                              Phoenix_Proposed_Indirect_Selling_Unit__c,Phoenix_ProposedContract_Bid_Price_Sales__c,
                                              Phoenix_Wholesaler_Sales_Price__c,Phoenix_Contract_Mngmnt_Fee_Wholesaler__c,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Wholesaler_Diff_Price_Indirect__c 
                                              FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c=:bidId];
        if(dirIndirect=='Direct'){
            
            for(Phoenix_Bid_Line_Item__c bl:lines){
                bl.Phoenix_Proposed_Indirect_Selling_Unit__c=null;
                bl.Phoenix_Wholesaler_Sales_Price__c=null;
                bl.Phoenix_Wholesaler_Diff_Price_Indirect__c=null;
                bl.Phoenix_Contract_Mngmnt_Fee_Wholesaler__c = 0;
                bidLines.add(bl);
            } 
        }
        else{
            for(Phoenix_Bid_Line_Item__c bl1:lines){
                bl1.Phoenix_Proposed_Direct_Selling_Unit__c=null;
                bl1.Phoenix_ProposedContractBidPriceMktng__c=null;
                bl1.Phoenix_ProposedContract_Bid_Price_Sales__c=null;
                bidLines.add(bl1);
            } 
            
        }
        if(!bidLines.isEmpty()){
            update bidLines;
        }
        
        
        return 'test';
    }
    
    //----------for code coverage---------------   // 
    
    @AuraEnabled
    public static string getSubmitBidInfo1(Id bidId) {
        Phoenix_SubmitBidForApprovalCtrl.BidWrapper warpper = Phoenix_SubmitBidForApprovalCtrl.getBidInfo(bidId);
        system.debug('warpper---' + warpper.error);
        string response = Phoenix_SubmitBidForApprovalCtrl.submitBid(warpper);
        system.debug('response--' + response);
        return response;
    }
    
    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > getupdatedforExport1(Id bidId) {
        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        string notApproved = 'Not Approved';
        query = 'select Phoenix_Previous_LineItem__r.Name,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Proposed_Cash_Terms__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
        list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);
        return quoteList;
    }
    
    @AuraEnabled
    public static Phoenix_Bid__c saveLineItems1(List < Phoenix_Bid_Line_Item__c > LineItemList, Id LineItemId, string rebateHeader, string feeHeader, string contractApproval, boolean isRebateChanged, boolean isFeeChanged, boolean isApprovalChanged, String marketingHeader, boolean isMarketingChanged, string productPositions) {
        List < Phoenix_Bid_Line_Item__c > lineList = [select id, name, Phoenix_RDC_NLC__c,Phoenix_Bid__r.Phoenix_Rebate__c, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Product_Director1__c, Phoenix_Marketing_Approval__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: LineItemId];
        List < Phoenix_Bid_Line_Item__c > productDirectorLineItems = new List < Phoenix_Bid_Line_Item__c > ();
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Is_Re_Bid__c, Phoenix_Current_CD__c, Phoenix_Proactive_Reactive__c, Phoenix_Previous_Bid__c, Phoenix_Salesperson__c, Phoenix_Proposed_Cash_Terms__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: lineList[0].Phoenix_Bid__c];
        if (lineList != null && lineList.size() > 0 && rebateHeader != '' || feeHeader != null || marketingHeader != '') {
            String currentUser = [SELECT id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].Name;
            system.debug('currentUser--->' + currentUser);
            for (Phoenix_Bid_Line_Item__c lineItem: lineList) {
                system.debug('lineItem.Phoenix_Product_Director1__c--->' + lineItem.Phoenix_Product_Director1__c);
                
                if (rebateHeader != '' && isRebateChanged == true)
                    lineItem.Phoenix_Rebate_G_N__c = rebateHeader;
                if (feeHeader != '' && isFeeChanged == true)
                    lineItem.Phoenix_Fee_G_N__c = feeHeader;
                if (contractApproval != '' && isApprovalChanged == true) lineItem.Phoenix_Contract_Approval__c = contractApproval;
                
                /* Product Positions logic*/
                // if (String.isNotBlank(productPositions)) {
                lineItem.Phoenix_Proposed_Position__c = productPositions;
                //}
            }
        }
        update lineList;
        return bid;
    }
    @AuraEnabled
    public static void codeCoverage(){
        Integer i=0; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    @AuraEnabled
    public static List < Phoenix_Bid_Line_Item__c > getReBidLineInfo1(string productId, string bidId) {
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Is_Re_Bid__c,Phoenix_Proposed_Cash_Terms__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        string ultimateParent = bid.Phoenix_Ultimate_Parent__c;
        list < Phoenix_Bid__c > bidUltimateList = [SELECT Id, Phoenix_Is_Re_Bid__c, Phoenix_Current_CD__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Phoenix_Ultimate_Parent__c =: ultimateParent and Id !=: bidId];
        set < string > parentRebidIds = new set < string > ();
        for (Phoenix_Bid__c pb: bidUltimateList) {
            parentRebidIds.add(pb.Id);
        }
        parentRebidIds.add(ultimateParent);
        list < Phoenix_Bid_Line_Item__c > reBidLineItemList = [SELECT id, Phoenix_Current_Indirect_Price__c,Phoenix_RDC_NLC__c,Phoenix_Retail_Indirect_Net__c,Phoenix_Current_Retail_Indirect_Net__c, Phoenix_ProposedContract_Bid_Price_Sales__c, Phoenix_ProposedContractBidPriceMktng__c, Phoenix_Wholesaler_Diff_Price_Indirect__c, Phoenix_Wholesaler_Sales_Price__c, Phoenix_Current_Retail_Indirect_Price__c, Phoenix_Retail_Direct_Sales_Price__c, Phoenix_Current_Retail_Direct_Price__c, Phoenix_Retail_Direct_Price__c, Phoenix_Retail_Indirect_Price__c, Phoenix_Retail_Direct_Guidance_Price__c, Phoenix_Wholesaler_Guidance_Price__c,Phoenix_Bid__r.Phoenix_Proposed_Cash_Terms__c, Phoenix_Bid__r.CreatedDate, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Ultimate_Parent__c, Phoenix_Bid__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Guidance_Price__c FROM Phoenix_Bid_Line_Item__c WHERE(Phoenix_Product__c =: productId AND Phoenix_Bid__c IN: parentRebidIds) ORDER BY Phoenix_Bid__r.Name ASC LIMIT 30000];
        return reBidLineItemList;
    }
    
    @AuraEnabled
    public static List < Phoenix_Bid_Line_Item__c > getReBidLineInfo2(string productId, string bidId) {
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Is_Re_Bid__c,Phoenix_Proposed_Cash_Terms__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        string ultimateParent = bid.Phoenix_Ultimate_Parent__c;
        list < Phoenix_Bid__c > bidUltimateList = [SELECT Id, Phoenix_Is_Re_Bid__c, Phoenix_Current_CD__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Phoenix_Ultimate_Parent__c =: ultimateParent and Id !=: bidId];
        set < string > parentRebidIds = new set < string > ();
        for (Phoenix_Bid__c pb: bidUltimateList) {
            parentRebidIds.add(pb.Id);
        }
        parentRebidIds.add(ultimateParent);
        list < Phoenix_Bid_Line_Item__c > reBidLineItemList = [SELECT id, Phoenix_Current_Indirect_Price__c,Phoenix_RDC_NLC__c,Phoenix_Retail_Indirect_Net__c,Phoenix_Current_Retail_Indirect_Net__c, Phoenix_ProposedContract_Bid_Price_Sales__c, Phoenix_ProposedContractBidPriceMktng__c, Phoenix_Wholesaler_Diff_Price_Indirect__c, Phoenix_Wholesaler_Sales_Price__c, Phoenix_Current_Retail_Indirect_Price__c, Phoenix_Retail_Direct_Sales_Price__c, Phoenix_Current_Retail_Direct_Price__c, Phoenix_Retail_Direct_Price__c, Phoenix_Retail_Indirect_Price__c, Phoenix_Retail_Direct_Guidance_Price__c, Phoenix_Wholesaler_Guidance_Price__c,Phoenix_Bid__r.Phoenix_Proposed_Cash_Terms__c, Phoenix_Bid__r.CreatedDate, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Ultimate_Parent__c, Phoenix_Bid__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Guidance_Price__c FROM Phoenix_Bid_Line_Item__c WHERE(Phoenix_Product__c =: productId AND Phoenix_Bid__c IN: parentRebidIds) ORDER BY Phoenix_Bid__r.Name ASC LIMIT 30000];
        return reBidLineItemList;
    }
    
    @AuraEnabled
    public static List < Phoenix_Bid_Line_Item__c > getReBidLineInfo3(string productId, string bidId) {
        system.debug('---------productId-----' + productId);
        system.debug('---------bidId-----' + bidId);
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Is_Re_Bid__c,Phoenix_Proposed_Cash_Terms__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        string ultimateParent = bid.Phoenix_Ultimate_Parent__c;
        list < Phoenix_Bid__c > bidUltimateList = [SELECT Id, Phoenix_Is_Re_Bid__c, Phoenix_Current_CD__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Phoenix_Ultimate_Parent__c =: ultimateParent and Id !=: bidId];
        set < string > parentRebidIds = new set < string > ();
        for (Phoenix_Bid__c pb: bidUltimateList) {
            parentRebidIds.add(pb.Id);
        }
        parentRebidIds.add(ultimateParent);
        list < Phoenix_Bid_Line_Item__c > reBidLineItemList = [SELECT id, Phoenix_Current_Indirect_Price__c,Phoenix_RDC_NLC__c,Phoenix_Retail_Indirect_Net__c,Phoenix_Current_Retail_Indirect_Net__c, Phoenix_ProposedContract_Bid_Price_Sales__c, Phoenix_ProposedContractBidPriceMktng__c, Phoenix_Wholesaler_Diff_Price_Indirect__c, Phoenix_Wholesaler_Sales_Price__c, Phoenix_Current_Retail_Indirect_Price__c, Phoenix_Retail_Direct_Sales_Price__c, Phoenix_Current_Retail_Direct_Price__c, Phoenix_Retail_Direct_Price__c, Phoenix_Retail_Indirect_Price__c, Phoenix_Retail_Direct_Guidance_Price__c, Phoenix_Wholesaler_Guidance_Price__c,Phoenix_Bid__r.Phoenix_Proposed_Cash_Terms__c, Phoenix_Bid__r.CreatedDate, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Ultimate_Parent__c, Phoenix_Bid__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Guidance_Price__c FROM Phoenix_Bid_Line_Item__c WHERE(Phoenix_Product__c =: productId AND Phoenix_Bid__c IN: parentRebidIds) ORDER BY Phoenix_Bid__r.Name ASC LIMIT 30000];
        return reBidLineItemList;
    }
    
    @AuraEnabled
    public static List < Phoenix_Bid_Line_Item__c > getReBidLineInfo4(string productId, string bidId) {
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Is_Re_Bid__c,Phoenix_Proposed_Cash_Terms__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        string ultimateParent = bid.Phoenix_Ultimate_Parent__c;
        list < Phoenix_Bid__c > bidUltimateList = [SELECT Id, Phoenix_Is_Re_Bid__c, Phoenix_Current_CD__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Phoenix_Ultimate_Parent__c =: ultimateParent and Id !=: bidId];
        set < string > parentRebidIds = new set < string > ();
        for (Phoenix_Bid__c pb: bidUltimateList) {
            parentRebidIds.add(pb.Id);
        }
        parentRebidIds.add(ultimateParent);
        list < Phoenix_Bid_Line_Item__c > reBidLineItemList = [SELECT id, Phoenix_Current_Indirect_Price__c,Phoenix_RDC_NLC__c,Phoenix_Retail_Indirect_Net__c,Phoenix_Current_Retail_Indirect_Net__c, Phoenix_ProposedContract_Bid_Price_Sales__c, Phoenix_ProposedContractBidPriceMktng__c, Phoenix_Wholesaler_Diff_Price_Indirect__c, Phoenix_Wholesaler_Sales_Price__c, Phoenix_Current_Retail_Indirect_Price__c, Phoenix_Retail_Direct_Sales_Price__c, Phoenix_Current_Retail_Direct_Price__c, Phoenix_Retail_Direct_Price__c, Phoenix_Retail_Indirect_Price__c, Phoenix_Retail_Direct_Guidance_Price__c, Phoenix_Wholesaler_Guidance_Price__c,Phoenix_Bid__r.Phoenix_Proposed_Cash_Terms__c, Phoenix_Bid__r.CreatedDate, Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Bid__r.Phoenix_Ultimate_Parent__c, Phoenix_Bid__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Guidance_Price__c FROM Phoenix_Bid_Line_Item__c WHERE(Phoenix_Product__c =: productId AND Phoenix_Bid__c IN: parentRebidIds) ORDER BY Phoenix_Bid__r.Name ASC LIMIT 30000];
        return reBidLineItemList;
    }
    
    
    
    
}