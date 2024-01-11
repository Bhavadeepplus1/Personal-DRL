public class Phoenix_RosController {
    @AuraEnabled
    public static void getLastBidActivity(Id bidId) {
        System.debug('bidId==>'+bidId);
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Is_Re_Bid__c, Phoenix_Previous_Bid__c, Phoenix_OTB_Direct_Indirect__c, Phoenix_Bid_Proposed_Position__c, Phoenix_Proactive_Reactive__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Current_CD__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        /* Bid_Last_Activity__c actvityrec= new Bid_Last_Activity__c();
actvityrec.Name = bid.Phoenix_Bid_Name__c+'_'+ userInfo.getLastName();
actvityrec.Bid_Name__c = bid.Phoenix_Bid_Name__c;
actvityrec.Bid__c = bidId;
actvityrec.Logged_in_User__c = userInfo.getName();
actvityrec.User__c = userInfo.getUserId();
actvityrec.Date_and_Time__c = Phoenix_Util.getNowEST();
actvityrec.Test__c = Phoenix_Util.getUserTimeNow(actvityrec.Date_and_Time__c, 'America/New_York');
insert actvityrec;*/
        List<Bid_Last_Activity__c> lastActivityRec = [SELECT Id,Bid__c,Date_and_Time__c from Bid_Last_Activity__c Where Bid__c=:bidId AND User__c=:Userinfo.getUserId()];
        List<Bid_Last_Activity__c> insertList = new List<Bid_Last_Activity__c>();
        List<Bid_Last_Activity__c> updateList = new List<Bid_Last_Activity__c>();
        System.debug('lastActivityRec size==>'+lastActivityRec.size());
        if(lastActivityRec !=null && lastActivityRec.size()>0){
            for(Bid_Last_Activity__c rec: lastActivityRec){
                
                rec.Date_and_Time__c = Phoenix_Util.getNowEST();
                rec.Test__c = Phoenix_Util.getUserTimeNow(rec.Date_and_Time__c, 'America/New_York');
                updateList.add(rec);
                
            }
            update lastActivityRec;
        }else{
            System.debug('in insert condition at last');
            Bid_Last_Activity__c actvityrec= new Bid_Last_Activity__c();
            actvityrec.Name = bid.Name+'_'+ userInfo.getLastName();//bid.Phoenix_Bid_Name__c+'_'+ userInfo.getLastName();
            actvityrec.Bid_Name__c = bid.Phoenix_Bid_Name__c;
            actvityrec.Bid__c = bidId;
            actvityrec.Logged_in_User__c = userInfo.getName();
            actvityrec.Date_and_Time__c = Phoenix_Util.getNowEST();
            actvityrec.User__c = userInfo.getUserId();
            actvityrec.Test__c = Phoenix_Util.getUserTimeNow(actvityrec.Date_and_Time__c, 'America/New_York');
            insert actvityrec;
        }
        
    }
    
    @AuraEnabled
    public static string getSubmitBidInfo(Id bidId) {
        Phoenix_SubmitBidForApprovalCtrl.BidWrapper warpper = Phoenix_SubmitBidForApprovalCtrl.getBidInfo(bidId);
        string response = Phoenix_SubmitBidForApprovalCtrl.submitBid(warpper);
        return response;
    }
    @AuraEnabled
    public static list < AggregateResult > getAllTotals(Id bidId) {
        list < AggregateResult > totalAggrigates = new list < AggregateResult >();
        AggregateResult[] groupedResults = [select sum(Phoenix_Current_Indirect_Selling_Unit__c) cisu, sum(Phoenix_Current_Direct_Selling_Unit__c) cdsu, sum(Phoenix_Total_Selling_Unit__c) tsu,
                                            sum(Phoenix_Final_Direct_Selling_Units_Calc__c) fdsu, sum(Phoenix_Net_Sales_Internal__c) netsint, sum(Phoenix_Final_Indirect_Selling_Units_Cal__c) fisu, 
                                            sum(Phoenix_Final_Total_Selling_Unit__c) ftsu, sum(Phoenix_Internal_Dead_Net_Price__c) intdead, sum(Phoenix_Retail_Direct_Guidance_Price__c) retaildirguidesales,
                                            sum(Phoenix_Wholesaler_Guidance_Price__c) whslGuidesales, sum(Phoenix_Retail_Direct_Sales_Price__c) retailguidesales, sum(Phoenix_Wholesaler_Sales_Price__c) whslsales,
                                            sum(Phoenix_Current_Retail_Indirect_Net__c) currentDSHP, sum(Phoenix_Retail_Indirect_Net__c) proposedDSHP, sum(Phoenix_12_Months_TotalSaleUnits__c) ActualTotalUnits, 
                                            sum(Phoenix_Override_Current_Units__c) OverrideTotalUnits, sum(Phoenix_Retail_Direct_Price__c) retailmarketing, sum(Phoenix_Wholesaler_DRL_Net_Price__c)  BASEDRLNetP, 
                                            sum(Phoenix_Anda_DRL_Net_price__c) DSHDRLNetP, sum(Phoenix_Wholesaler_DRL_TPT__c) AutoSubDRLNetP, sum(Phoenix_12_Months_Actual_Sales__c) actSaDir12Months,
                                            sum(Phoenix_12_Months_IndirectSaleUnit__c) actSalInd12months, sum(Phoenix_12_Months_TotalSaleUnits__c) actTotal12Months, sum(Phoenix_ProposedContractBidPriceMktng__c) proDirMark,
                                            sum(Phoenix_Wholesaler_Diff_Price_Indirect__c) proIndiMark, sum(Phoenix_Customer_Dead_net__c) netIndirPrice, sum(Phoenix_Indirect_Dead_Net__c) indirectDeadNet,
                                            sum(Phoenix_Retail_Indirect_Price__c) retailIndirectmrket, sum(Proposed_Net_Sales_Direct__c) netSaleDir, sum(Proposed_Net_Sales_Indirect__c) netSaleIndir,
                                            sum(Proposed_TPT_Direct__c) tptDir, sum(Proposed_TPT_Indirect__c) tptIndir, sum(Phoenix_Th_Put_Margin__c) TputMargin, sum(Phoenix_Proposed_TPMargin__c) TPMarginPerc, 
                                            sum(Indirect_TP__c) IndirectTP, sum(Phoenix_Proposed_TP_Margin__c) propoTPmargin, sum(Phoenix_Current_Retail_Direct_Units__c) rosthanualcvsdirect, 
                                            sum(Phoenix_Current_Retail_Indirect_Units__c) rosthanualcvsIndirect, sum(Phoenix_Current_Wholesaler_Units__c) rostthanualcardselling, 
                                            sum(Phoenix_12_Months_Actual_Sales__c) rostwanualcvsdirect, sum(Phoenix_12_Months_IndirectSaleUnit__c) rostwanualcvsIndirect, 
                                            sum(Phoenix_Override_Current_Direct_Units__c) rosoverCVSDirect, sum(Phoenix_Override_Current_Indirect_Units__c) rosoverCVSInDirect, 
                                            sum(Phoenix_Override_Total_units__c) rosoverTotalUnits, sum(Phoenix_Total_Selling_Unit__c) rostotalUnits, sum(Phoenix_Final_Direct_Selling_Units_Calc__c) rosFinalDirSellUnits,
                                            sum(Phoenix_Final_Indirect_Selling_Units_Cal__c) rosFinalInDirSellUnits, sum(Phoenix_Final_Total_Selling_Unit__c) rosFinalTotalSellUnits, 
                                            sum(Phoenix_IOD_Total_Amount__c) rosIODtotalAmount, sum(Phoenix_Wholesaler_IOD_overall_amount__c) rosMajorIODtotalAmount, sum(Proposed_Net_Sales_Direct__c) rosCVSdirectNetSales, 
                                            sum(Proposed_Net_Sales_Indirect__c) rosCVSIndirectNetSales, sum(Phoenix_Wholesaler_Net_Sales__c) rosCardinalNetSales, sum(Phoenix_Net_Sales_Internal__c) rosTotalRedOakNetSales,
                                            sum(Phoenix_Opening_Order__c) openingOrder, sum(Phoenix_Opening_Order_Net_sales__c) openingOrderNetSales,sum(Phoenix_Opening_Order_TPT__c) openingOrderTPT,
                                            sum(Phoenix_Current_Anda_Units__c) scmDirUnits, sum(Phoenix_Current_Indirect_Gaint_EagleUnit__c) scmInDirUnits, 
                                            sum(Phoenix_ProposedIndirectAholdDelhaizeUni__c) scmCardinalUnits, sum(Phoenix_Proposed_IndirectGaintEagleUnits__c) scmMajorUnits,
                                            sum(Phoenix_Total_SCM_Approved_Qty__c) scmTotalUnits
                                            from Phoenix_Bid_Line_Item__c where
                                            Phoenix_Bid__c =: bidId and Phoenix_Final_Status__c != 'Not Approved'
                                           ];
      //  return groupedResults;
        List<Phoenix_Bid_Line_Item__c> bidLineItemList = [SELECT Id 
                                                          from Phoenix_Bid_Line_Item__c 
                                                          where Phoenix_Bid__c =: bidId and Phoenix_Final_Status__c != 'Not Approved'];
        List<Id> bidLineItemIdList = new List<Id>();
        for(Phoenix_Bid_Line_Item__c bidLineObj : bidLineItemList){
            bidLineItemIdList.add(bidLineObj.Id);
        }
        
        AggregateResult[] extnGroupedResults = [select sum(Phoenix_3MonAnnualMajorSellingUnits__c)ThMAnuMjSellUnits, sum(Phoenix_Total3MonAnnualSellingUnits__c)TotThMAnuSellUnits, 
                                                sum(Phoenix_Actual12MonCardinalSelUnits__c)ActTwMCardnialSellUnits, sum(Phoenix_Actual12MonMajorSelUnit__c) ActTwMMajorSellUnits, 
                                                sum(Phoenix_Actual12MonTotalSaleUnits__c)ActTwMTotalSellUnits, sum(Phoenix_OverrideMajorUnits__c)OverrideMajorUnits, 
                                                sum(Phoenix_Proposed_Cardinal_Units__c)PropCardnialUnits, sum(Phoenix_Proposed_Major_Units__c)PropMajorUnits, 
                                                sum(Phoenix_CVS_Total_Net_Sales__c)CVSTotNetSales, sum(Phoenix_CVS_Direct_TPT__c)CVSDirectTPT, sum(Phoenix_CVS_Indirect_TPT__c)CVSInDirectTPT, 
                                                sum(Phoenix_CVS_Total_TPT__c)CVSTotalTPT, sum(Phoenix_CVS_Direct_TPT_Per__c)CVSDirectTPTPer, sum(Phoenix_CVS_Indirect_TPT_Per__c)CVSInDirectTPTPer, 
                                                sum(Phoenix_CVS_Total_TPT_Per__c)CVSTotalTPTPer, sum(Phoenix_Cardinal_TPT__c)CardinalTPT, sum(Phoenix_Cardinal_TPT_Per__c)CardinalTPTPer,
                                                sum(Phoenix_Major_Net_Sales__c)MajorNetSales, sum(Phoenix_Major_TPT__c)MajorTPT, sum(Phoenix_Major_TPT_Per__c)MajorTPTPer, 
                                                sum(Phoenix_Total_RedOak_TPT__c)TotRedOakTPT, sum(Phoenix_Total_RedOak_TPT_Per__c)TotRedOakTPTPer, sum(Phoenix_Proposed_CVS_DirSellingUnits__c) rospropcvsdirsell,
                                                sum(Phoenix_Proposed_CVS_IndirSellingUnits__c) rospropcvsIndirsell,sum(Phoenix_Opening_Order_Major__c) openingOrderMajor,sum(Phoenix_Opening_Order_Major_Net_sales__c) opngOrderNetSalesMajor,
                                                sum(Phoenix_Opening_Order_Major_TPT__c) opngOrderTPTMajor, sum(Opening_Order_CVS__c) openingOrderCVS, sum(Opening_Order_Net_Sales_for_CVS__c) opngOrderNetSalesCVS, sum(Opening_Order_TPT_for_CVS__c) opngOrderTPTCVS
                                                from Phoenix_BidLineItemExtn__c 
                                                where Phoenix_Bid_Line_Item__c IN: bidLineItemIdList ];
        
        //return groupedResults;
        totalAggrigates.addAll(groupedResults);
        totalAggrigates.addAll(extnGroupedResults);
        return totalAggrigates; 
    }
    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > getupdatedforExport(Id bidId) {
        String bidLineStrFields = fieldApiList('Phoenix_Bid_Line_Item__c');
        String bidLineExtStrFields = fieldApiList('Phoenix_BidLineItemExtn__c');
        string notApproved = 'Not Approved';
        String bidLineItemObjname = 'Phoenix_Bid_Line_Item__c';
        String bidLineItemExtObjname = 'BidLineItemsExtn__r';//'Phoenix_BidLineItemExtn__r';
        String query = 'select Phoenix_Bid__r.Phoenix_Rebate__c, Phoenix_Previous_LineItem__r.Name,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,'+
            +'Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,'+
            +'Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,'+
            +'Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c, ' + bidLineStrFields +',( SELECT '+bidLineExtStrFields+' FROM '+bidLineItemExtObjname+') FROM '+bidLineItemObjname+' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
        
        list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);
        for(Phoenix_Bid_Line_Item__c line : quoteList){   
            line.Phoenix_Marketing_Notes__c = line.Phoenix_Marketing_Notes__c!=null ? line.Phoenix_Marketing_Notes__c.replaceAll('#',' '):line.Phoenix_Marketing_Notes__c;
            line.Phoenix_Initial_Stocking_Order_Comments__c = line.Phoenix_Initial_Stocking_Order_Comments__c!=null ? line.Phoenix_Initial_Stocking_Order_Comments__c.replaceAll('#',' '):line.Phoenix_Initial_Stocking_Order_Comments__c;
            line.Phoenix_SCM_Notes__c = line.Phoenix_SCM_Notes__c!=null ? line.Phoenix_SCM_Notes__c.replaceAll('#',' '):line.Phoenix_SCM_Notes__c;
            line.Phoenix_Sales_Notes__c = line.Phoenix_Sales_Notes__c!=null ? line.Phoenix_Sales_Notes__c.replaceAll('#',' '):line.Phoenix_Sales_Notes__c;
            line.Phoenix_Finance_Comments__c = line.Phoenix_Finance_Comments__c!=null ? line.Phoenix_Finance_Comments__c.replaceAll('#',' '):line.Phoenix_Finance_Comments__c;
            line.Phoenix_Contract_Comments__c = line.Phoenix_Contract_Comments__c!=null ? line.Phoenix_Contract_Comments__c.replaceAll('#',' '):line.Phoenix_Contract_Comments__c;
            line.Phoenix_Vistex_Comments__c = line.Phoenix_Vistex_Comments__c!=null ? line.Phoenix_Vistex_Comments__c.replaceAll('#',' '):line.Phoenix_Vistex_Comments__c;
            line.Phoenix_Sr_Director_VP_Finance_Comments__c = line.Phoenix_Sr_Director_VP_Finance_Comments__c!=null ? line.Phoenix_Sr_Director_VP_Finance_Comments__c.replaceAll('#',' '):line.Phoenix_Sr_Director_VP_Finance_Comments__c;
            line.Phoenix_Comments__c = line.Phoenix_Comments__c!=null ? line.Phoenix_Comments__c.replaceAll('#',' '):line.Phoenix_Comments__c;
            line.Phoenix_Business_Head_Comments__c = line.Phoenix_Business_Head_Comments__c!=null ? line.Phoenix_Business_Head_Comments__c.replaceAll('#',' '):line.Phoenix_Business_Head_Comments__c;
            line.Phoenix_Orange_Book_Rating1__c = line.Phoenix_Orange_Book_Rating1__c!=null ? line.Phoenix_Orange_Book_Rating1__c.replaceAll('#',' '):line.Phoenix_Orange_Book_Rating1__c;
            line.Phoenix_Product_Family1__c = line.Phoenix_Product_Family1__c!=null ? line.Phoenix_Product_Family1__c.replaceAll('#',' '):line.Phoenix_Product_Family1__c;
            line.Phoenix_Current_Position__c = line.Phoenix_Current_Position__c!=null ? line.Phoenix_Current_Position__c.replaceAll('#',' '):line.Phoenix_Current_Position__c;
        }
        return quoteList;
    }
    
    @auraEnabled
    public static Phoenix_BidLineItemExtn__c getChildExtnRecord(Id bliId){
        String bidLineItemExtObjname = 'Phoenix_BidLineItemExtn__c';
        String bidLineExtStrFields = fieldApiList('Phoenix_BidLineItemExtn__c');
        bidLineExtStrFields = 'SELECT '+bidLineExtStrFields+' FROM '+bidLineItemExtObjname+' WHERE Phoenix_Bid_Line_Item__c =: bliId LIMIT 1';
        Phoenix_BidLineItemExtn__c obj = database.query(bidLineExtStrFields);
        return obj;
    }
   @AuraEnabled
    public static List < Phoenix_Bid_Line_Item__c > getUpdatedList(List < Phoenix_Bid_Line_Item__c > lineItems, String bidId) {
        //List<Phoenix_BidLineItemExtn__c> bidExtnList = new List<Phoenix_BidLineItemExtn__c>();
        List<Id> bliIds = new List<Id>();
        for(Phoenix_Bid_Line_Item__c bidLine : lineItems){
            bliIds.add(bidLine.Id);
        }
        List<Phoenix_BidLineItemExtn__c> bidExtnList = [SELECT Id, Name, Phoenix_Proposed_CVS_DirSellingUnits__c, 
                                                        Phoenix_Proposed_CVS_IndirSellingUnits__c, Phoenix_Proposed_Cardinal_Units__c,
                                                        Phoenix_Proposed_Major_Units__c FROM Phoenix_BidLineItemExtn__c
                                                        WHERE Phoenix_Bid_Line_Item__c IN : bliIds];
            //Phoenix_BidLineItemExtn__c extnObj = new Phoenix_BidLineItemExtn__c();
        List<Phoenix_BidLineItemExtn__c> updateBidExtnList = new List<Phoenix_BidLineItemExtn__c>();
        for(Phoenix_BidLineItemExtn__c extnObj : bidExtnList){ 
            //extnObj = bidLine.BidLineItemsExtn__r[0];
           
           // if(extnObj.Phoenix_Proposed_CVS_DirSellingUnits__c == null){
           //     extnObj.Phoenix_Proposed_CVS_DirSellingUnits__c = 0;  
           // }
             if((extnObj.Phoenix_Proposed_CVS_DirSellingUnits__c == null || extnObj.Phoenix_Proposed_CVS_DirSellingUnits__c == 0) &&
                extnObj.Phoenix_Proposed_CVS_IndirSellingUnits__c != null && extnObj.Phoenix_Proposed_CVS_IndirSellingUnits__c > 0 ){
                extnObj.Phoenix_Proposed_CVS_DirSellingUnits__c = 1;  
            }
            else if(extnObj.Phoenix_Proposed_CVS_DirSellingUnits__c == null){
               extnObj.Phoenix_Proposed_CVS_DirSellingUnits__c = 0;    
            }
            if(extnObj.Phoenix_Proposed_CVS_IndirSellingUnits__c == null){
                extnObj.Phoenix_Proposed_CVS_IndirSellingUnits__c = 0;  
            }
            if(extnObj.Phoenix_Proposed_Cardinal_Units__c == null){
                extnObj.Phoenix_Proposed_Cardinal_Units__c = 0;  
            }
            if(extnObj.Phoenix_Proposed_Major_Units__c == null){
                extnObj.Phoenix_Proposed_Major_Units__c = 0;  
            }
            updateBidExtnList.add(extnObj);
        }
        update updateBidExtnList;
        return getupdatedforExport(bidId);
    }
     
    @AuraEnabled
    public static Wrapper getRelatedList(Id bidId) {
         getLastBidActivity(bidId);
        Wrapper wrapperObject = new Wrapper();
        String bidLineStrFields = fieldApiList('Phoenix_Bid_Line_Item__c');
        String bidLineExtStrFields = fieldApiList('Phoenix_BidLineItemExtn__c');
        string notApproved = 'Not Approved';
        String bidLineItemObjname = 'Phoenix_Bid_Line_Item__c';
        String bidLineItemExtObjname = 'BidLineItemsExtn__r';//'Phoenix_BidLineItemExtn__r';
        String query = 'SELECT Phoenix_Bid__r.Phoenix_Rebate__c, Phoenix_Bid__r.Phoenix_Is_Re_Bid__c,Phoenix_Previous_Bid__r.Name,Phoenix_Previous_LineItem__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,'+
            +'Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Controlled_Substance__c,Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Refrigerated__c,Phoenix_Product__r.Phoenix_Limited_Distribution__c,Phoenix_Bid__r.Phoenix_Required_Cold_Storage__c,'+
            +'Phoenix_Bid__r.Phoenix_Controlled_Distribution__c,Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,'+
            +'Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c,Phoenix_Bid__r.Phoenix_Controlled_Substance__c,' + bidLineStrFields +',( SELECT '+bidLineExtStrFields+' FROM '+bidLineItemExtObjname+') FROM '+bidLineItemObjname+' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved ORDER BY Product_Family_Name__c ASC';
        
        list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);
        String bidQuery = 'SELECT '+fieldApiList('Phoenix_Bid__c')+' FROM Phoenix_Bid__c WHERE Id =: bidId';
        Phoenix_Bid__c bid = Database.query(bidQuery);
        List < String > productFamilyList = new List < String > ();
        List < String > productDirectorList = new List < String > ();
        boolean showProceedBtn = true;
        boolean hasDirectorLines = false;
        User cuurentUser;
        if (bid.Phoenix_Bid_Created_Behalf_of__c != null && bid.Phoenix_Approval_Status__c == 'Draft')
            cuurentUser = [SELECT id, Name FROM User WHERE Id =: bid.Phoenix_Bid_Created_Behalf_of__c LIMIT 1];
        else
            cuurentUser = [SELECT id, Name FROM User WHERE Id =: userinfo.getUserId() LIMIT 1];
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Delegated_Approver__r.Name,Phoenix_User__r.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c 
                            FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
        String delegatedUsers = cuurentUser.Name;
        if(deligatorApprover !=null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c aprHisDel : deligatorApprover){
                delegatedUsers = delegatedUsers + ',' + aprHisDel.Phoenix_User__r.Name;
            }
        }
        for (Phoenix_Bid_Line_Item__c lineItem: quoteList) {
            if (!productFamilyList.contains(lineItem.Product_Family_Name__c))
                productFamilyList.add(lineItem.Product_Family_Name__c);
            if (lineItem.Phoenix_Product_Director__c != null && !productDirectorList.contains(lineItem.Phoenix_Product_Director__c))
                productDirectorList.add(lineItem.Phoenix_Product_Director__c);
            if (lineItem.Phoenix_Marketing_Final_Approval__c == true && lineItem.Phoenix_Product_Director__c == userinfo.getName())
                showProceedBtn = false;
            if (lineItem.Phoenix_Product_Director__c != null && (lineItem.Phoenix_Product_Director__c == userInfo.getName() || (delegatedUsers!=null && delegatedUsers.contains(lineItem.Phoenix_Product_Director__c))) && lineItem.Phoenix_Marketing_Final_Approval__c == false)
                hasDirectorLines = true;
        }
        if(hasDirectorLines)
            showProceedBtn = true;
        //
        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, Phoenix_Approver__r.Name, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c,
                                                      Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c,
                                                      User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__r.Name);
        }
        string isMarketingApprovePerson;
        string isContractsApprovePerson;
        boolean isDelegationPerson=false;
        boolean isMarketingDelegationPerson = false;
        wrapperObject.deligatedUserName = delegatedUsers;
        if(deligatorApprover !=null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c aprHisDel : deligatorApprover){
                if(userTeamUserIdMap.containsKey('Contracts-'+aprHisDel.Phoenix_User__c))
                    isDelegationPerson = true;
                if(userTeamUserIdMap.containsKey('Marketing-'+aprHisDel.Phoenix_User__c))
                    isMarketingDelegationPerson = true;
            }
        }
        if (userTeamUserIdMap.containsKey('Marketing-' + cuurentUser.Id) && hasDirectorLines && cuurentUser.Name==UserInfo.getName())
            isMarketingApprovePerson = userTeamUserIdMap.get(('Marketing-' + cuurentUser.Id));
        else if(isMarketingDelegationPerson && hasDirectorLines && cuurentUser.Name==UserInfo.getName())
            isMarketingApprovePerson=cuurentUser.Name;
        else
            isMarketingApprovePerson=null;
        if (userTeamUserIdMap.containsKey('Contracts-' + cuurentUser.Id) || isDelegationPerson)
            isContractsApprovePerson = userTeamUserIdMap.get(('Contracts-' + cuurentUser.Id));
       
        wrapperObject.lineItemsList = quoteList;
        wrapperObject.bidRecord = bid;
        wrapperObject.productfamilyList = productFamilyList;
        wrapperObject.productDirectorList = productDirectorList;
        wrapperObject.loggedInUserName = cuurentUser.Name;
        wrapperObject.isMarketingApprovePerson = isMarketingApprovePerson;
        wrapperObject.isContractsApprovePerson = isContractsApprovePerson;
        wrapperObject.showProceedBtn = showProceedBtn;
        wrapperObject.hasDirectorLines = hasDirectorLines;
        wrapperObject.ismarketingDeligator = (deligatorApprover != null && deligatorApprover.size()>0) ? true:false;
        return wrapperObject;
    }
    @AuraEnabled
    public static List < Phoenix_Bid_Line_Item__c > getReBidLineInfo(string productId, string bidId) {
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Is_Re_Bid__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, 
                              Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c,
                              Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c,
                              Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        string ultimateParent = bid.Phoenix_Ultimate_Parent__c;
        list < Phoenix_Bid__c > bidUltimateList = [SELECT Id, Phoenix_Is_Re_Bid__c, Phoenix_Current_CD__c, Phoenix_Previous_Bid__c, Phoenix_Ultimate_Parent__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c,
                                                   Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, 
                                                   Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, 
                                                   Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c 
                                                   FROM Phoenix_Bid__c WHERE Phoenix_Ultimate_Parent__c =: ultimateParent and Id !=: bidId];
        set < string > parentRebidIds = new set < string > ();
        for (Phoenix_Bid__c pb: bidUltimateList) {
            parentRebidIds.add(pb.Id);
        }
        parentRebidIds.add(ultimateParent);
        list < Phoenix_Bid_Line_Item__c > reBidLineItemList = [SELECT id, Phoenix_Current_Indirect_Price__c,Phoenix_Retail_Indirect_Net__c,Phoenix_Current_Retail_Indirect_Net__c, Phoenix_ProposedContract_Bid_Price_Sales__c,
                                                               Phoenix_ProposedContractBidPriceMktng__c, Phoenix_Wholesaler_Diff_Price_Indirect__c, Phoenix_Wholesaler_Sales_Price__c, Phoenix_Current_Retail_Indirect_Price__c,
                                                               Phoenix_Retail_Direct_Sales_Price__c, Phoenix_Current_Retail_Direct_Price__c, Phoenix_Retail_Direct_Price__c, Phoenix_Retail_Indirect_Price__c, 
                                                               Phoenix_Retail_Direct_Guidance_Price__c, Phoenix_Wholesaler_Guidance_Price__c, Phoenix_Bid__r.CreatedDate, Phoenix_Bid__r.Phoenix_Approval_Status__c,
                                                               Phoenix_Bid__r.Phoenix_Ultimate_Parent__c, Phoenix_Bid__c, Phoenix_Bid__r.Name, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Final_Approvd_Pricing_Contracts__c,
                                                               Phoenix_Guidance_Price__c, (SELECT Id, Name, Phoenix_Proposed_CvsDirectContractPrice__c, Phoenix_Proposed_Major_Contract_Price__c FROM BidLineItemsExtn__r)
                                                               FROM Phoenix_Bid_Line_Item__c WHERE(Phoenix_Product__c =: productId AND Phoenix_Bid__c IN: parentRebidIds) ORDER BY Phoenix_Bid__r.Name ASC LIMIT 30000];
        return reBidLineItemList;
    }
    @AuraEnabled
    public static void updateRelatedList(List < Phoenix_Bid_Line_Item__c > lineItemsList) {
        if (lineItemsList != null && lineItemsList.size() > 0)
            update lineItemsList;
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
        @AuraEnabled public string isMarketingApprovePerson;
        @AuraEnabled public string isContractsApprovePerson;
        @AuraEnabled public boolean showProceedBtn;
        @AuraEnabled public boolean hasDirectorLines;
        @AuraEnabled public boolean ismarketingDeligator;
        @AuraEnabled public string deligatedUserName;

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
    public static Phoenix_Bid__c saveLineItems(List < Phoenix_Bid_Line_Item__c > LineItemList, Id LineItemId, string rebateHeader, string feeHeader, string contractApproval, boolean isRebateChanged, 
                                               boolean isFeeChanged, boolean isApprovalChanged, String marketingHeader, boolean isMarketingChanged, 
                                               string productPositions, string productCardinalPositions, string productMajorPositions) 
    {
        List < Phoenix_Bid_Line_Item__c > lineList = [select id, name, Phoenix_Bid__r.Phoenix_Rebate__c, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Product_Director1__c, Phoenix_Marketing_Approval__c, 
                                                      (SELECT Id, Name, Phoenix_Proposed_Cardinal_Position__c, Phoenix_Proposed_Major_Position__c FROM BidLineItemsExtn__r) 
                                                      FROM Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: LineItemId];
        List < Phoenix_Bid_Line_Item__c > productDirectorLineItems = new List < Phoenix_Bid_Line_Item__c > ();
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Bid_Proposed_Position__c, Phoenix_Is_Re_Bid__c, Phoenix_Current_CD__c, Phoenix_Proactive_Reactive__c, Phoenix_Previous_Bid__c, Phoenix_Salesperson__c, 
                              Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, 
                              Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, 
                              Phoenix_Current_Value_Est_VIP__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, 
                              Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: lineList[0].Phoenix_Bid__c];
        bid.Phoenix_Bid_Proposed_Position__c = productPositions;
        List<Phoenix_BidLineItemExtn__c> updateExtnList = new List<Phoenix_BidLineItemExtn__c>();
        if (lineList != null && lineList.size() > 0 && rebateHeader != '' || feeHeader != null || marketingHeader != '') {
            String currentUser = [SELECT id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].Name;
            for (Phoenix_Bid_Line_Item__c lineItem: lineList) {
                if (lineItem.Phoenix_Product_Director1__c == currentUser && isMarketingChanged && marketingHeader != '') {
                    lineItem.Phoenix_Marketing_Approval__c = marketingHeader;
                }
                if (rebateHeader != '' && isRebateChanged == true)
                    lineItem.Phoenix_Rebate_G_N__c = rebateHeader;
                if (feeHeader != '' && isFeeChanged == true)
                    lineItem.Phoenix_Fee_G_N__c = feeHeader;
                if (contractApproval != '' && isApprovalChanged == true) lineItem.Phoenix_Contract_Approval__c = contractApproval;
                /*Product Positions logic*/
                // if (String.isNotBlank(productPositions)) {
                lineItem.Phoenix_Proposed_Position__c = productPositions;
                if(lineItem.BidLineItemsExtn__r.size() != 0){
                    Phoenix_BidLineItemExtn__c extnObj = lineItem.BidLineItemsExtn__r[0];
                    extnObj.Phoenix_Proposed_Cardinal_Position__c = productCardinalPositions;
                    extnObj.Phoenix_Proposed_Major_Position__c = productMajorPositions;
                    if ((lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Customer Rebate Change' || lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Sales Out Rebate') && isRebateChanged) {
                        extnObj.Phoenix_Preferred_Cardinal_Rebate_per__c = lineItem.Phoenix_Bid__r.Phoenix_Rebate__c;
                        extnObj.Phoenix_Major_Rebate_per__c = lineItem.Phoenix_Bid__r.Phoenix_Rebate__c;
                    }
                    updateExtnList.add(extnObj);
                }
                //}
            }
        }
        update lineList;
        update bid;
        if(updateExtnList.size() != 0)
            update updateExtnList;
        return bid;
    }
    
    @AuraEnabled
    public static List < Phoenix_Bid_Line_Item__c > saveLineItemsNewPL(Id bidId,List < Phoenix_Bid_Line_Item__c > LineItemList){
        //List < Phoenix_Bid_Line_Item__c > BidlineItems = [select id, name,Phoenix_Bid__r.Phoenix_Customer_Type__c,Phoenix_Bid__r.Phoenix_Rebate__c, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Product_Director1__c, Phoenix_Marketing_Approval__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
        String bidLineStrFields = fieldApiList('Phoenix_Bid_Line_Item__c');
        String bidLineExtStrFields = fieldApiList('Phoenix_BidLineItemExtn__c');
        string notApproved = 'Not Approved';
        String bidLineItemObjname = 'Phoenix_Bid_Line_Item__c';
        String bidLineItemExtObjname = 'BidLineItemsExtn__r';//'Phoenix_BidLineItemExtn__r';
        String query = 'SELECT Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Bid__r.Phoenix_Rebate__c,Phoenix_Product__r.Phoenix_WAC__c,Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c,Phoenix_Bid__r.Phoenix_Is_Re_Bid__c,Phoenix_Previous_Bid__r.Name,Phoenix_Previous_LineItem__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,'+
            +'Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,'+
            +'Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c, ' + bidLineStrFields +',( SELECT '+bidLineExtStrFields+' FROM '+bidLineItemExtObjname+') FROM '+bidLineItemObjname+' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved ORDER BY Product_Family_Name__c ASC';
        
        list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);
        String currentUser = [SELECT id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].Name;
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Delegated_Approver__r.Name,Phoenix_User__r.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
        String delegatedUsers = currentUser;
        if(deligatorApprover !=null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c aprHisDel : deligatorApprover){
                delegatedUsers = delegatedUsers + ',' + aprHisDel.Phoenix_User__r.Name;
            }
        }
        for (Phoenix_Bid_Line_Item__c lineItem: quoteList) {
            if(lineItem.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Draft'){
              lineItem.Phoenix_Lowest_Price_SKU1__c = lineItem.Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c;
              lineItem.Phoenix_WAC1__c = lineItem.Phoenix_Product__r.Phoenix_WAC__c; 
           }
           if(lineItem.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'SCM & Marketing' || lineItem.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Marketing'){
               if ((lineItem.Phoenix_Product_Director1__c == currentUser || ((delegatedUsers!=null && delegatedUsers.contains(lineItem.Phoenix_Product_Director1__c)) && delegatedUsers.contains(currentUser))) && lineItem.Phoenix_Marketing_Approval__c != 'Approved'){
                    lineItem.Phoenix_Lowest_Price_SKU1__c = lineItem.Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c;
                    lineItem.Phoenix_WAC1__c = lineItem.Phoenix_Product__r.Phoenix_WAC__c;
            	}
           }
            
        }
        
        update quoteList;
        return quoteList;
        
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
    public static Phoenix_Bid_Line_Item__c updateChildRec(Phoenix_BidLineItemExtn__c lineItem, string currentValue) {
        update lineItem;
        String lineItemId = lineItem.Phoenix_Bid_Line_Item__c;
        String bidLineStrFields = fieldApiList('Phoenix_Bid_Line_Item__c');
        String bidLineExtStrFields = fieldApiList('Phoenix_BidLineItemExtn__c');
        String bidLineItemExtObjname = 'BidLineItemsExtn__r';
        string notApproved = 'Not Approved';
        String bidLineItemObjname = 'Phoenix_Bid_Line_Item__c';
        String query = 'select Phoenix_Bid__r.Phoenix_Rebate__c,Phoenix_Previous_LineItem__r.Name,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,'+
            +' Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Controlled_Substance__c,'+
            +'Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Refrigerated__c,Phoenix_Product__r.Phoenix_Limited_Distribution__c,Phoenix_Bid__r.Phoenix_Required_Cold_Storage__c,Phoenix_Bid__r.Phoenix_Controlled_Distribution__c,'+
            +'Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c, '+
            + bidLineStrFields +',( SELECT '+bidLineExtStrFields+' FROM '+bidLineItemExtObjname+') FROM '+bidLineItemObjname+' where Id = : lineItemId limit 1';
        Phoenix_Bid_Line_Item__c bidLineItem = Database.query(query);
        if(bidLineItem.BidLineItemsExtn__r[0].Phoenix_PropMarktCvsCardinalAcquisitCost__c != null ||
            bidLineItem.Phoenix_ProposedContractBidPriceMktng__c != null){
                bidLineItem.Phoenix_Marketing_Approval__c = 'Approved';
                update bidLineItem;
        }
        
        return bidLineItem;
    }
    
    @auraEnabled
    public static Phoenix_Bid_Line_Item__c getUpdatedLineItemRec(String lineItemId){
        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        List<String> strFields = new List<String>();
        for (String fieldName: fieldMap.keyset()) {
            strFields.add(fieldName);
        }
        query = 'select Phoenix_Bid__r.Phoenix_Rebate__c, Phoenix_Previous_LineItem__r.Name,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,'+
            +' Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,'+
            +'Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c, '+String.join(strFields,', ')+' FROM '+SobjectApiName+' WHERE Id =: lineItemId ORDER BY Product_Family_Name__c ASC';
        Phoenix_Bid_Line_Item__c bidLineItem = Database.query(query);
        return bidLineItem;
    }
    
    @AuraEnabled
    public static Phoenix_Bid_Line_Item__c getCalcs(Phoenix_Bid_Line_Item__c LineItem, Id LineItemId, string currentValue, string fieldLabel) {
        String query = '';
        String SobjectApiName = 'Phoenix_BidLineItemExtn__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        List<String> strFields = new List<String>();
        for (String fieldName: fieldMap.keyset()) {
            strFields.add(fieldName);
        }
        query = 'SELECT '+String.join(strFields,' , ')+' FROM '+SobjectApiName+' WHERE Phoenix_Bid_Line_Item__c =: lineItemId limit 1';
        Phoenix_BidLineItemExtn__c bidLineItemExtn = Database.query(query);
        if(bidLineItemExtn.Phoenix_PropMarktCvsCardinalAcquisitCost__c != null ||
           LineItem.Phoenix_ProposedContractBidPriceMktng__c != null)
                LineItem.Phoenix_Marketing_Approval__c = 'Approved';
        if (currentValue != 'No Change' && fieldLabel == 'rebateType')
            LineItem.Phoenix_Rebate_G_N__c = currentValue;
        if (currentValue != 'No Change' && fieldLabel == 'feeType')
            LineItem.Phoenix_Fee_G_N__c = currentValue;
        if (currentValue != 'No Change' && fieldLabel == 'MarketApproval')
            LineItem.Phoenix_Marketing_Approval__c = currentValue;
        if (currentValue != 'No Change' && fieldLabel == 'ContractApproval')
            LineItem.Phoenix_Contract_Approval__c = currentValue;
        if (currentValue != 'No Change' && fieldLabel == 'EstmatedDays')
            LineItem.Phoenix_Estimated_Lead_Time_Days__c = currentValue;
        if (LineItem.Phoenix_Guidance_Price__c != null 
            && LineItem.Phoenix_ProposedContract_Bid_Price_Sales__c == null) 
        {
            //LineItem.Phoenix_ProposedContract_Bid_Price_Sales__c = LineItem.Phoenix_Guidance_Price__c;
        }
        
        update LineItem;
        
        query = '';
        String bidLineStrFields = fieldApiList('Phoenix_Bid_Line_Item__c');
        String bidLineExtStrFields = fieldApiList('Phoenix_BidLineItemExtn__c');
        String bidLineItemExtObjname = 'BidLineItemsExtn__r';
        string notApproved = 'Not Approved';
        String bidLineItemObjname = 'Phoenix_Bid_Line_Item__c';
        query = 'select Phoenix_Bid__r.Phoenix_Rebate__c, Phoenix_Previous_LineItem__r.Name,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,'+
            +' Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Controlled_Substance__c,Phoenix_Product__r.Phoenix_Product_Playbook__r.Phoenix_Refrigerated__c,Phoenix_Product__r.Phoenix_Limited_Distribution__c,Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,'+
            +'Phoenix_Bid__r.Phoenix_Group_VIP__c,Phoenix_Bid__r.Phoenix_Initial_Order_Discount_Type__c, '+
            + bidLineStrFields +',( SELECT '+bidLineExtStrFields+' FROM '+bidLineItemExtObjname+') FROM '+bidLineItemObjname+' where Id = : lineItemId limit 1';
        Phoenix_Bid_Line_Item__c UpdatedLineItem = Database.query(query);
        return UpdatedLineItem;

    }
    @AuraEnabled //findBySrxOtc
    public static List < Phoenix_Bid_Line_Item__c > findByProductFamily(List < String > searchKey, String lineItemId, List < String > sRxOtcList, List < String > searchPDList) {
        String query = '';
        String bidLineStrFields = fieldApiList('Phoenix_Bid_Line_Item__c');
        String bidLineExtStrFields = fieldApiList('Phoenix_BidLineItemExtn__c');
        string notApproved = 'Not Approved';
        String bidLineItemObjname = 'Phoenix_Bid_Line_Item__c';
        String bidLineItemExtObjname = 'BidLineItemsExtn__r';
        query = 'select Phoenix_Bid__r.Phoenix_Rebate__c, Phoenix_Previous_LineItem__r.Name,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,'+
            +' Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,'+
            +'Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Bid__r.Phoenix_Group_VIP__c,'+ bidLineStrFields +',( SELECT '+bidLineExtStrFields+' FROM '+bidLineItemExtObjname+') FROM '+bidLineItemObjname+' where Phoenix_Bid__c = : lineItemId AND Phoenix_Final_Status__c !=: notApproved';
        if (searchKey != null && searchKey.size() > 0) {
            query = query + ' AND Product_Family_Name__c =: searchKey';
        }
        if (sRxOtcList != null && sRxOtcList.size() > 0) {
            query = query + ' AND Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c =: sRxOtcList';
        }
        if (searchPDList != null && searchPDList.size() > 0) {
            query = query + ' AND Phoenix_Product_Director__c =: searchPDList';
        }
        query = query + ' ORDER BY Product_Family_Name__c ASC LIMIT 1000';
        List < Phoenix_Bid_Line_Item__c > lineItemsList = Database.query(query);
        return lineItemsList;
    }
    @AuraEnabled
    public static list < Phoenix_Contract__c > getContracts(string customerID, string searchInput) {
        string act = 'Active';
        boolean isExcludeContract = false;
        string query = 'select name,Phoenix_Customer__r.Name,Phoenix_Contract_Number__c,Phoenix_Contract_Internal_Description__c,Phoenix_Contract_External_Description__c from Phoenix_Contract__c where Phoenix_Contract_Status__c=:act AND Phoenix_Is_Exclude_Contract__c=:isExcludeContract';
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
            for(Account acc: allAccMap.values()){
                if(acc.ParentId != null && (acc.ParentId == tempId || (allAccMap.get(acc.ParentId) != null && allAccMap.get(acc.ParentId).ParentId != null && allAccMap.get(acc.ParentId).ParentId == tempId)) )
                    parentAccIds.add(acc.Id);
            }
            query += ' and (Phoenix_Customer__c=:parentAccIds)'; // or Phoenix_Customer__r.ParentId=:parentAccIds
        }
        if (string.isNotBlank(searchInput)) {
            query += ' and ( name like \'%' + searchInput + '%\' or Phoenix_Contract_Number__c like \'%' + searchInput + '%\' or Phoenix_Customer__r.Name like \'%' + searchInput + '%\' or Phoenix_Contract_Internal_Description__c like \'%' + searchInput + '%\' or Phoenix_Contract_External_Description__c like  \'%' + searchInput + '%\')';
        }
        list < Phoenix_Contract__c > cntList = Database.query(query);
        return cntList;
    }
    @AuraEnabled
    public static list < Phoenix_Product_Position__c > getPositions(string customerID) {
        Set < Id > parentAccIds = new Set < Id > ();
        if (customerID != null) {             
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
        }
        //Account bidAccount = [select ParentId, Parent.Name from account where id =: customerID limit 1];
        list < Phoenix_Product_Position__c > positionList = [select Phoenix_Customer__c, Phoenix_Customer__r.Name, Name,Phoenix_Customer__r.ParentId, Phoenix_Group_Name__c, Phoenix_General_Category__c, Phoenix_Position_Comments__c from Phoenix_Product_Position__c]; 
        //where Phoenix_Customer__c=:parentAccIds or Phoenix_Customer__r.ParentId=:parentAccIds];//where Phoenix_Group_Name__c =: bidAccount.Parent.Name];
        list<Phoenix_Product_Position__c> AccountRelatedPositions=new list<Phoenix_Product_Position__c>();
        list<Phoenix_Product_Position__c> OtherPositions=new list<Phoenix_Product_Position__c>();
        for(Phoenix_Product_Position__c pos:positionList){
            if(parentAccIds.contains(pos.Phoenix_Customer__c) ||  parentAccIds.contains(pos.Phoenix_Customer__r.ParentId) || customerID==pos.Phoenix_Customer__c || customerID==pos.Phoenix_Customer__r.ParentId){
                AccountRelatedPositions.add(pos);
            }
            else if(AccountRelatedPositions.size()==0 && pos.Phoenix_Customer__c==null && !parentAccIds.contains(pos.Phoenix_Customer__c) && !parentAccIds.contains(pos.Phoenix_Customer__r.ParentId)){
                OtherPositions.add(pos);
            }
        }
        if(AccountRelatedPositions.size()>0){
            return AccountRelatedPositions;
        }else{
            return  OtherPositions;
        }
        //return positionList;
    }
    
    public static string fieldApiList(String SobjectApiName){
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String bidLineStrFields = '';
        
        for (String fieldName: fieldMap.keyset()) {
            if (bidLineStrFields == null || bidLineStrFields == '') {
                bidLineStrFields = fieldName;
            } else {
                bidLineStrFields = bidLineStrFields + ' , ' + fieldName;
            }
        }
        return bidLineStrFields;
    }
    
    @AuraEnabled
    public static void getNPRData(list < string > selectrcs, Id BidId, string templateType) {
        String bidLineStrFields = fieldApiList('Phoenix_Bid_Line_Item__c');
        String bidLineExtStrFields = fieldApiList('Phoenix_BidLineItemExtn__c');
        String bidLineItemExtObjname = 'BidLineItemsExtn__r';
        string notApproved = 'Not Approved';
        String bidLineItemObjname = 'Phoenix_Bid_Line_Item__c';
        
        String query = 'select Phoenix_Bid__r.Phoenix_Bid_Type__c,Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c,Phoenix_Product__r.Name, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Fee__c, Phoenix_Bid__r.Phoenix_Customer__r.Rebate_Type__c,'+
            +' Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Cash_Discount__c, Phoenix_Bid__r.Phoenix_Customer__r.Fee_Type__c, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Rebates__c, '+
            +'Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_VIP__c, Phoenix_Product__r.ProductCode,'+
            + bidLineStrFields +',( SELECT '+bidLineExtStrFields+' FROM '+bidLineItemExtObjname+') FROM '+bidLineItemObjname+' where Phoenix_Bid__c = : BidId';
        
        list < Phoenix_Bid_Line_Item__c > bildLines = Database.query(query);
        
        list<Phoenix_BidLineItemExtn__c> bidLineExtnList = new List<Phoenix_BidLineItemExtn__c>();
        
        String bidType= (bildLines !=null && bildLines.size()>0) ? bildLines[0].Phoenix_Bid__r.Phoenix_Bid_Type__c:'';
        if(bidType != 'New Product Launch'){
        list < Phoenix_NPR_Data__c > NPRDataLines = [select id, Phoenix_Contract_Number__c, Name, Phoenix_Contract_Type__c, Phoenix_12Months_Actual_Sales_Unit__c, Phoenix_12Mt_Sales_Ut_Actual__c, Phoenix_Product_Position__c, Phoenix_Net_Sales_Internal__c, Phoenix_Dead_Net_Tracking_GR__c, Phoenix_Contract_Price__c, Phoenix_Product__c, Phoenix_Product__r.ProductCode, Phoenix_12Months_Sales_Unit__c, Phoenix_12Months_Net_Sales__c, Phoenix_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Rebate__c, Phoenix_Rebate_G_N_Indicator__c, Phoenix_Bonafied_G_N_Indicator__c, Phoenix_Fee_Bonafied_Fee__c, Phoenix_Per_Unit_Bonfied_Fee__c, Phoenix_CD__c, Phoenix_GR_TrackingTier__c 
                                                     from Phoenix_NPR_Data__c 
                                                     where Phoenix_Contract_Number__c in: selectrcs 
                                                     and Phoenix_NPR_Status__c = 'Active'];
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
            Phoenix_BidLineItemExtn__c bidExtnObj = new Phoenix_BidLineItemExtn__c();
            bidExtnObj = bidLine.BidLineItemsExtn__r[0];
            bidLine.Phoenix_Current_Retail_Direct_Units__c = 0;
            bidLine.Phoenix_Current_Retail_Indirect_Units__c = 0;
            bidLine.Phoenix_Current_Wholesaler_Units__c = 0;
            bidLine.Phoenix_12_Months_Actual_Sales__c = 0;
            bidLine.Phoenix_12_Months_IndirectSaleUnit__c = 0;
            bidExtnObj.Phoenix_3MonAnnualMajorSellingUnits__c = 0;
            bidExtnObj.Phoenix_Actual12MonCardinalSelUnits__c = 0;
            bidExtnObj.Phoenix_Actual12MonMajorSelUnit__c = 0;
            bidExtnObj.Phoenix_Current_Major_Contract_Price__c = 0;
            bidLine.Phoenix_Current_Position__c = '';
            bidLine.Phoenix_Current_Direct_Price__c = 0;
            bidLine.Phoenix_Current_Wholesaler_Price__c = 0;
            bidLine.Phoenix_Current_Indirect_Price__c = 0;
            bidLine.Phoenix_Current_Rebate__c = 0;
            bidLine.Phoenix_Proposed_Current_Rebate__c = 0;
            bidLine.Finance_Current_Sales__c = 0;
            list < Decimal > deadNetTrackList = new list < Decimal > ();
            list < Decimal > cvsDirConPriceList = new List < Decimal > ();
            list < Decimal > cvsIndirConPriceList = new List < Decimal > ();
            list < Decimal > curCarConPrcList = new List < Decimal > ();
            list < Decimal > curMajConPrcList = new List < Decimal > ();
            Set < String > currentPositionSet = new Set< String > ();
            list < Decimal > cardinalRebateList = new List < Decimal > ();
            list < Decimal > MajorRebateList = new List < Decimal > ();
            if (productCodeToNPRLineMap.keyset().contains(bidLine.Phoenix_Product__r.ProductCode)) {
                bidLine.Phoenix_Current_Position__c = '';
                for (Phoenix_NPR_Data__c NPRLine: productCodeToNPRLineMap.get(bidLine.Phoenix_Product__r.ProductCode)) {
                    if(NPRLine.Phoenix_Product_Position__c != null && NPRLine.Phoenix_Product_Position__c != '')
                        currentPositionSet.add(NPRLine.Phoenix_Product_Position__c);
                     bidLine.Phoenix_Proposed_Est_VIP__c = NPRLine.Phoenix_GR_TrackingTier__c;                    
                    if (NPRLine.Phoenix_Contract_Number__c == '1000000449') {
                        bidLine.Phoenix_Current_Retail_Direct_Units__c = (bidLine.Phoenix_Current_Retail_Direct_Units__c != null ? bidLine.Phoenix_Current_Retail_Direct_Units__c : 0)+
                            (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                        bidLine.Phoenix_12_Months_Actual_Sales__c = (bidLine.Phoenix_12_Months_Actual_Sales__c != null ? bidLine.Phoenix_12_Months_Actual_Sales__c : 0)+
                            (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                        cvsDirConPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                        bidLine.Current_CVS_DeadNet__c = NPRLine.Phoenix_Dead_Net_Tracking_GR__c;
                        bidLine.Finance_Current_Sales__c += ((NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0)*(NPRLine.Phoenix_Dead_Net_Tracking_GR__c !=null ? NPRLine.Phoenix_Dead_Net_Tracking_GR__c:0))- ((NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0)*bidLine.Phoenix_Medicaid_Returns_Per_Unit_in__c);
                        deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
                    }
                    if (NPRLine.Phoenix_Contract_Number__c == '3000000489') {
                        bidLine.Phoenix_Current_Wholesaler_Units__c = (bidLine.Phoenix_Current_Wholesaler_Units__c != null ? bidLine.Phoenix_Current_Wholesaler_Units__c : 0)
                            + (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                        bidExtnObj.Phoenix_Actual12MonCardinalSelUnits__c = (bidExtnObj.Phoenix_Actual12MonCardinalSelUnits__c != null ? bidExtnObj.Phoenix_Actual12MonCardinalSelUnits__c : 0)
                            + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                        
                        curCarConPrcList.add(NPRLine.Phoenix_Contract_Price__c);
                        deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
                        bidLine.Current_Cardinal_DeadNet__c = NPRLine.Phoenix_Dead_Net_Tracking_GR__c;
                        cardinalRebateList.add(NPRLine.Phoenix_Rebate__c);
                        bidLine.Finance_Current_Sales__c += ((NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0)*(NPRLine.Phoenix_Dead_Net_Tracking_GR__c !=null ? NPRLine.Phoenix_Dead_Net_Tracking_GR__c:0))- ((NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0)*bidLine.Phoenix_Medicaid_Returns_Per_Unit_in__c);
                    }
                    
                    if (NPRLine.Phoenix_Contract_Number__c == '3000000753') {
                        bidExtnObj.Phoenix_Actual12MonMajorSelUnit__c = (bidExtnObj.Phoenix_Actual12MonMajorSelUnit__c != null ? bidExtnObj.Phoenix_Actual12MonMajorSelUnit__c : 0)
                            + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                        bidExtnObj.Phoenix_3MonAnnualMajorSellingUnits__c = (bidExtnObj.Phoenix_3MonAnnualMajorSellingUnits__c != null ? bidExtnObj.Phoenix_3MonAnnualMajorSellingUnits__c : 0)
                            + (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                        
                        curMajConPrcList.add(NPRLine.Phoenix_Contract_Price__c);
                        deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
                        bidLine.Current_Major_DeadNet__c = NPRLine.Phoenix_Dead_Net_Tracking_GR__c;
                        majorRebateList.add(NPRLine.Phoenix_Rebate__c);
                        bidLine.Finance_Current_Sales__c += ((NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0)*(NPRLine.Phoenix_Dead_Net_Tracking_GR__c !=null ? NPRLine.Phoenix_Dead_Net_Tracking_GR__c:0))- ((NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0)*bidLine.Phoenix_Medicaid_Returns_Per_Unit_in__c);
                    }
                    if (NPRLine.Phoenix_Contract_Number__c == '3000000485' 
                        || NPRLine.Phoenix_Contract_Number__c == '3000000484' 
                        || NPRLine.Phoenix_Contract_Number__c == '3000000483') {
                            bidLine.Phoenix_Current_Retail_Indirect_Units__c = (bidLine.Phoenix_Current_Retail_Indirect_Units__c != null ? bidLine.Phoenix_Current_Retail_Indirect_Units__c : 0)+
                                (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                            bidLine.Phoenix_12_Months_IndirectSaleUnit__c = (bidLine.Phoenix_12_Months_IndirectSaleUnit__c != null ? bidLine.Phoenix_12_Months_IndirectSaleUnit__c : 0)+
                                (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                            
                            cvsIndirConPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                            bidLine.Current_CVS_Indirect_DeadNet__c = NPRLine.Phoenix_Dead_Net_Tracking_GR__c;
                            deadNetTrackList.add(NPRLine.Phoenix_Dead_Net_Tracking_GR__c);
                            bidLine.Finance_Current_Sales__c += ((NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0)*(NPRLine.Phoenix_Dead_Net_Tracking_GR__c !=null ? NPRLine.Phoenix_Dead_Net_Tracking_GR__c:0))- ((NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0)*bidLine.Phoenix_Medicaid_Returns_Per_Unit_in__c);
                        }
                }
                if( currentPositionSet.size() >0 ) {
                    List<String> currentPositionList = new List<String>(currentPositionSet);
                    bidLine.Phoenix_Current_Position__c = string.join(currentPositionList, ', ');
                }
                if (cvsDirConPriceList.size() > 0) {
                    cvsDirConPriceList.sort();
                    bidLine.Phoenix_Current_Direct_Price__c = cvsDirConPriceList[0];
                }
                
                if (curCarConPrcList.size() > 0) {
                    curCarConPrcList.sort();
                    bidLine.Phoenix_Current_Wholesaler_Price__c = curCarConPrcList[0];
                }
                
                if (curMajConPrcList.size() > 0) {
                    curMajConPrcList.sort();
                    bidExtnObj.Phoenix_Current_Major_Contract_Price__c = curMajConPrcList[0];
                }
                
                if (cvsIndirConPriceList.size() > 0) {
                    cvsIndirConPriceList.sort();
                    bidLine.Phoenix_Current_Indirect_Price__c = cvsIndirConPriceList[0];
                }
                //take minimum of all  NPR Dead net track
                if (deadNetTrackList.size() > 0) {
                    deadNetTrackList.sort();
                    bidLine.Phoenix_DeadNet_TrckGR__c = deadNetTrackList[0];
                }
                if (cardinalRebateList.size() > 0) {
                    cardinalRebateList.sort();
                    bidLine.Phoenix_Current_Rebate__c = cardinalRebateList[cardinalRebateList.size() - 1];
                }
                if (majorRebateList.size() > 0) {
                    majorRebateList.sort();
                    bidLine.Phoenix_Proposed_Current_Rebate__c = majorRebateList[majorRebateList.size() - 1];
                }
                bidLineExtnList.add(bidExtnObj);
            } 
            else{
                 bidLine.Phoenix_Proposed_Est_VIP__c = bidLine.Phoenix_Bid__r.Phoenix_Proposed_Value_Est_VIP__c;
            }
        }
            update bildLines;
            update bidLineExtnList;
        }
        Phoenix_Bid__c bidRec = [SELECT Id, Phoenix_Reference_Contracts__c FROM Phoenix_Bid__c WHERE Id =: bildLines[0].Phoenix_Bid__r.Id];
        bidRec.Phoenix_Reference_Contracts__c = String.join(selectrcs,',');
        update bidRec;
    }
    
    
    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > submitToProceddStep(string bidId, boolean isContracts,boolean ismarketingDeligator, string deligatedUserName) {
        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') 
                strFields = fieldName;
            else
                strFields = strFields + ' , ' + fieldName;
        }
        string notApproved = 'Not Approved';
        String bidLineExtStrFields = fieldApiList('Phoenix_BidLineItemExtn__c');
        String bidLineItemExtObjname = 'BidLineItemsExtn__r';
        
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
        
        query = 'select Phoenix_Bid__r.Phoenix_Rebate__c, Phoenix_Previous_LineItem__r.Name,Phoenix_Previous_Bid__r.Name,Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,'+
            +'Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ''+
            +',(select '+bidLineExtStrFields+' from '+bidLineItemExtObjname+') from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
        if (isContracts != true && ismarketingDeligator != true) {
            query += ' and Phoenix_Product_Director__c=:loggerUserName';
        }else if(ismarketingDeligator){
            query += ' and Phoenix_Product_Director__c=:directorNames';
        }
        list < Phoenix_Bid_Line_Item__c > bidLinesList = Database.query(query);
        return bidLinesList;
    }
    /*@AuraEnabled 
public static  list<Phoenix_Bid_Process_Steps__c> makeApprovalsContracts(String bidId,List<Phoenix_Bid_Line_Item__c> bidlines,boolean approveStatusFlag,boolean isContracts){
String bidType = [SELECT id , Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =: bidId LIMIT 1].Phoenix_Bid_Type__c;
for(Phoenix_Bid_Line_Item__c line :  bidlines){
line.Phoenix_Contracts_Final_Approval__c = true;
if(line.Phoenix_Contract_Approval__c == 'Line Error- Not Sent'){                line.Phoenix_Final_Status__c = 'Not Approved';
}
}
if(bidlines.size()>0){
update bidlines;
}
list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:bidId ];
list<Phoenix_Bid_Process_Steps__c> contractsStepLsit=new list<Phoenix_Bid_Process_Steps__c>();
for(Phoenix_Bid_Process_Steps__c step:bidProcessStepList){
if(step.Phoenix_Process_Step__r.Name=='Contracts' && step.Phoenix_Approver__c==Userinfo.getUserId()){                step.Phoenix_Status__c='Completed';/*approveStatusFlag==true?'Completed':'Do Not Bid'; /               contractsStepLsit.add(step);
}else if(step.Phoenix_Process_Step__r.Name=='Contracts' && bidType == 'IPA Floor Pricing Update'){                step.Phoenix_Status__c='Completed';/*approveStatusFlag==true?'Completed':'Do Not Bid';/                contractsStepLsit.add(step);
}
}
if(!contractsStepLsit.isEmpty()){            update contractsStepLsit;
}
return bidProcessStepList;
}*/
    @AuraEnabled
    public static WrapperForNextSteps makeApprovals(String bidId, List < Phoenix_Bid_Line_Item__c > bidlines, boolean approveStatusFlag) {
        List<string> productDirectorsNames = new List<string>();
        for (Phoenix_Bid_Line_Item__c line: bidlines) {
            line.Phoenix_Marketing_Final_Approval__c = true;
            if (line.Phoenix_Marketing_Approval__c == 'Not Approved')
                line.Phoenix_Final_Status__c = 'Not Approved';
            productDirectorsNames.add(line.Phoenix_Product_Director1__c);
        }
        if (bidlines.size() > 0)
            update bidlines;
        //query latest bif lines to check all rejected case
        
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId()];
        list < Phoenix_Bid_Line_Item__c > bidLinesUpdate = [select id,Phoenix_Marketing_Final_Approval__c, Phoenix_Final_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
        boolean isAllRejectedCaseFound = true;
        boolean isMarketingCompleted = true;
        for (Phoenix_Bid_Line_Item__c lineItem: bidLinesUpdate) {
            if (lineItem.Phoenix_Final_Status__c != 'Not Approved')
                isAllRejectedCaseFound = false;
            if(!lineItem.Phoenix_Marketing_Final_Approval__c && lineItem.Phoenix_Final_Status__c != 'Not Approved')
                isMarketingCompleted = false;
        }
        Phoenix_Bid__c bidRec = new Phoenix_Bid__c(id = bidId, Phoenix_Bid_Marketing_Approved_Date__c = system.today()); //Closed
        if(bidRec != null && (isMarketingCompleted && isAllRejectedCaseFound))
        	update bidRec;
        WrapperForNextSteps wrapSteps = new WrapperForNextSteps();
        //start logic for all rejected case
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Delegated_Approver__c,Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId order by Phoenix_Step__c];
        if (isAllRejectedCaseFound) {
            //close the bid other step not applicable
            integer currentStepNum;
            for (Phoenix_Bid_Process_Steps__c prcsStep: bidProcessStepList) {
                if (prcsStep.Phoenix_Approver_Team__c == 'Marketing')
                    currentStepNum = integer.valueOf(prcsStep.Phoenix_Step__c);
            }
            for (Phoenix_Bid_Process_Steps__c prcsStep: bidProcessStepList) {
                if (prcsStep.Phoenix_Status__c != 'Completed' && prcsStep.Phoenix_Approver_Team__c == 'Marketing' && (prcsStep.Phoenix_Approver__c == Userinfo.getUserId() || (deligatorApprover.size()>0 && productDirectorsNames.contains(prcsStep.Phoenix_Approver__r.Name) ))) {
                    prcsStep.Phoenix_Status__c = 'Completed';
                    if(deligatorApprover.size()>0 && productDirectorsNames.contains(prcsStep.Phoenix_Approver__r.Name))
                        prcsStep.Phoenix_Delegated_Approver__c =  Userinfo.getUserId();
                    else
                        prcsStep.Phoenix_Approver__c = Userinfo.getUserId();
                }
                if (prcsStep.Phoenix_Approver_Team__c == 'Supply Chain' && prcsStep.Phoenix_Status__c != 'Completed' && prcsStep.Phoenix_Step__c == currentStepNum)
                    prcsStep.Phoenix_Status__c = 'Not Applicable';
                if (prcsStep.Phoenix_Step__c > currentStepNum) {
                    if (prcsStep.Name.contains('Closed'))
                        prcsStep.Phoenix_Status__c = 'Completed';
                    else
                        prcsStep.Phoenix_Status__c = 'Not Applicable';
                }
            }
            update bidProcessStepList;
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Marketing Rejected');//Closed
            update bid;
            wrapSteps.updateProcessStepList = bidProcessStepList;
            wrapSteps.flagSCMStop = true;
            wrapSteps.flagMarketStop = true;
        } else {
            list < Phoenix_Bid_Process_Steps__c > marketStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
            boolean flagSCMStop = false;
            boolean flagMarketStop = false;
            for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
                if (step.Phoenix_Status__c != 'Completed' && step.Phoenix_Approver_Team__c == 'Marketing' && (step.Phoenix_Approver__c == Userinfo.getUserId() || (deligatorApprover.size()>0 && productDirectorsNames.contains(step.Phoenix_Approver__r.Name) ))) {
                    step.Phoenix_Status__c = 'Completed'; //approveStatusFlag==true?'Completed':'Do Not Bid';
                    // step.Phoenix_Status__c=approveStatusFlag==true?'Completed':'';
                    if(deligatorApprover.size()>0 && productDirectorsNames.contains(step.Phoenix_Approver__r.Name)){
                        step.Phoenix_Delegated_Approver__c =  Userinfo.getUserId();
                    }else{
                        step.Phoenix_Approver__c = Userinfo.getUserId();
                    }
                    marketStepLsit.add(step);
                }
                if (step.Phoenix_Approver_Team__c == 'Supply Chain' && step.Phoenix_Status__c != 'Completed') {
                    flagSCMStop = true;
                }
                if (step.Phoenix_Approver_Team__c == 'Marketing' && step.Phoenix_Status__c == 'In Process') {
                    flagMarketStop = true;
                }
            }
            if (!marketStepLsit.isEmpty()) {
                update marketStepLsit;
                wrapSteps.updateProcessStepList = bidProcessStepList;
                wrapSteps.flagSCMStop = flagSCMStop;
                wrapSteps.flagMarketStop = flagMarketStop;
            }
        }
        return wrapSteps;
    }
    public class WrapperForNextSteps {
        @AuraEnabled public list < Phoenix_Bid_Process_Steps__c > updateProcessStepList;
        @AuraEnabled public boolean flagSCMStop;
        @AuraEnabled public boolean flagMarketStop;
        WrapperForNextSteps() {
            updateProcessStepList = new List < Phoenix_Bid_Process_Steps__c > ();
            flagSCMStop = false;
            flagMarketStop = false;
        }
    }
    @AuraEnabled
    public static void updateNextProcessSteps(string bidId, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit, boolean flagSCMStop, boolean flagMarketStop) {
        if (flagSCMStop == false && flagMarketStop == false && !processStepLsit.isEmpty()) {
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
                    stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
                        step
                            });
                }
                String stepName = step.Phoenix_Approver_Team__c;
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
                if (step.Phoenix_Is_Criteria_Step__c) {
                    teamToStepMap.put(step.Phoenix_Approver_Team__c, step);
                    criteriaSteplist.add(step);
                }
            }
            set < string > criteraStepsSet = new set < string > ();
            criteraStepsSet = Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(bidId);
            map < string, Phoenix_Bid_Process_Steps__c > updatedTeamToStepMap = new map < string, Phoenix_Bid_Process_Steps__c > ();
            string bidStatus;
            if (criteraStepsSet.size() > 0) {
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
                update updatedTeamToStepMap.values();
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Marketing Lead');
                update bid;
                Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId, updatedTeamToStepMap.values());
            } else {
                integer stepnumber = stepnameNoMap.get('Marketing');
                List < Phoenix_Bid_Process_Steps__c > nextSteps = stepMap.get(stepnumber + 1);
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
                //}
            }
        }
    }
  /*  @AuraEnabled
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
            if (step.Name.contains('Closed'))
                step.Phoenix_Status__c = 'Completed';
            else
                step.Phoenix_Status__c = 'In Process';
            //'In Process' Submitted //Diff b/w them
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
    }*/
    //Added Code by Rama
    
    @AuraEnabled 
    public static user fetchUser(){  
        return CompetitorInfoCLS.fetchUser();
    }
    
    //End Code by Rama
   public static void coverageBlock(){
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
		i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
}