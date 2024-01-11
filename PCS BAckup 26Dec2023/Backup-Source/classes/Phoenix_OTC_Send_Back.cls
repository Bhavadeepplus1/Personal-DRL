public class Phoenix_OTC_Send_Back {
    public static String sendBackToMkg(String bidId,List<Phoenix_Bid_Line_Item__c> bidLineList){
        String returnStatus = '';
        try {
            system.debug('bidLineList'+bidLineList);
            system.debug('bidLineList size'+bidLineList.size());
            //for timings.
            Map<String,Phoenix_Bid_Process_Steps__c> approverStepMap = new Map<String,Phoenix_Bid_Process_Steps__c>();
            //end.
            String mkgCompletedTime;
            String mkgSentTime;
            
            Integer updatedlineItemVersion ;
            Integer updatedbidVersion;
            String bidVersion ;
            String lineItemVersion ;
            List<String> productDirectors = new List<String>();
            List < Phoenix_Bid_Process_Steps__c > existingSteps = Database.query('SELECT ' + Phoenix_Util.bidProcessStepFields + ' FROM  Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c =:bidId');
            List < Phoenix_Bid_Process_Steps__c > nextSteps= new List < Phoenix_Bid_Process_Steps__c > ();
            Phoenix_Bid__c bid = [SELECT Id,Phoenix_OTC_Bid_Version__c, Name, Phoenix_Approval_Status__c, Phoenix_Bid_Type__c, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Is_Re_Bid__c, Contract_Status__c, Phoenix_Sent_to_Customer_Date__c, Phoenix_Offer_Valid_up_to__c,
                                  (SELECT Id, Name, Phoenix_Bid__r.Name, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Process_Step__r.Name, Phoenix_Approver_Team__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c FROM Bid_Process_Steps__r)
                                  FROM Phoenix_Bid__c WHERE Id =: bidId
                                 ];
            
            
            
            Map < String, Map < Integer, List < Phoenix_Bid_Process_Steps__c >>> bidProcessStepsMap = new Map < String, Map < Integer, List < Phoenix_Bid_Process_Steps__c >>> ();
            Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, Phoenix_Bid_Process_Steps__c > stepApproversMap = new Map < String, Phoenix_Bid_Process_Steps__c > ();
            Map < String, Integer > stepteamNoMap = new Map < String, Integer > ();
            
            List < Phoenix_Bid_Line_Item_Price_History__c > lineItemPriceHistoryList = new List < Phoenix_Bid_Line_Item_Price_History__c > ();
            List < Phoenix_Bid_Line_Item__c > bidlinesList = new List < Phoenix_Bid_Line_Item__c > ();
            
            
            
            for (Phoenix_Bid_Process_Steps__c step: bid.Bid_Process_Steps__r) {
                
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
                
                String stepName = step.Phoenix_Process_Step__r.Name; //Phoenix_Approver_Team__c;
                if (stepNamesMap.get(stepName) != null) {
                    List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
                    adededSteps.add(step);
                    stepNamesMap.put(stepName, adededSteps);
                } else {
                    stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {
                        step
                            });
                }
                stepteamNoMap.put(stepName, stepNo);
                stepApproversMap.put(step.Phoenix_Approver_Team__c + '-' + step.Phoenix_Approver__c, step);
                
            }
            
            bidProcessStepsMap.put(bid.Id, stepMap); 
            Integer mkgStepNo =  stepteamNoMap.get('Marketing Approval');
            Integer custStepNo = stepteamNoMap.get('Customer\'s Update');
            List<Integer> stepsNumbers = new List<Integer>();
            stepsNumbers.add(mkgStepNo);
            stepsNumbers.add(custStepNo);
            system.debug('mkgStepNo'+mkgStepNo);
            system.debug('custStepNo'+custStepNo);
            List < Phoenix_Bid_Process_Steps__c > stepsToUpdate = [SELECT Id, Name, Phoenix_Bid__r.Name,Phoenix_Approval_Completed_Time_String__c,Phoenix_Approval_Sent_Time_String__c, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Process_Step__r.Name, Phoenix_Approver_Team__c, Phoenix_Approver__c,Phoenix_Delegated_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Is_Notification_Only__c, Phoenix_Is_Criteria_Step__c
                                                                   FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId AND Phoenix_Step__c IN : stepsNumbers  
                                                                  ];
            
            Set < Phoenix_Bid_Process_Steps__c > updateProcessStepsSet = new Set < Phoenix_Bid_Process_Steps__c > ();
            List<Phoenix_Bid_Process_Steps__c> updateProcessStepsList = new List<Phoenix_Bid_Process_Steps__c>();
            //for capturing timings
            for(Phoenix_Bid_Process_Steps__c step: stepsToUpdate){
                approverStepMap.put(step.Phoenix_Approver__r.Name, step);
            }
            //end.
            for(Phoenix_Bid_Line_Item__c item:bidLineList){
                lineItemVersion = item.Phoenix_Orange_Book_Rating1__c;
                lineItemVersion= lineItemVersion.substringAfter(' ');
                updatedlineItemVersion = Integer.valueof(lineItemVersion);
                updatedlineItemVersion = updatedlineItemVersion+1;
                String currentVersion = item.Phoenix_Orange_Book_Rating1__c;
                item.Phoenix_Orange_Book_Rating1__c = 'Version ' + updatedlineItemVersion;
                item.Phoenix_Marketing_Approval__c = null;
                item.Phoenix_Marketing_Final_Approval__c = false;
                item.Phoenix_Customer_Final_Approval__c = false;
                item.Phoenix_Customer_Approval_OTC__c = null;
                item.Phoenix_Price_Effective_Date__c = null;
                item.Phoenix_Supply_Effective_Date__c = null;
                //for timings.
                if(approverStepMap.get(item.Phoenix_Product_Director1__c).Name!=null && approverStepMap.get(item.Phoenix_Product_Director1__c).Name.contains('Marketing Approval')){
                    system.debug('stepName'+approverStepMap.get(item.Phoenix_Product_Director1__c).Name);
                    mkgCompletedTime = approverStepMap.get(item.Phoenix_Product_Director1__c).Phoenix_Approval_Completed_Time_String__c;
                    mkgSentTime =  approverStepMap.get(item.Phoenix_Product_Director1__c).Phoenix_Approval_Sent_Time_String__c;
                }
                
                //end. 
                Phoenix_Bid_Line_Item_Price_History__c lineItemPriceHistory = new Phoenix_Bid_Line_Item_Price_History__c();
                lineItemPriceHistory.Name = currentVersion;
                lineItemPriceHistory.Pheonix_DRL_Units__c = item.Phoenix_Proposed_Direct_Selling_Unit__c;
                lineItemPriceHistory.Phoenix_Final_DRL_Units__c = item.Phoenix_Final_Direct_Selling_Units_Calc__c;
                lineItemPriceHistory.Phoenix_Current_52wk__c = item.Phoenix_Current_Retail_Direct_Units__c;
                lineItemPriceHistory.Phoenix_Brand_Retail_Price__c =item.Phoenix_Current_Retail_Direct_Price__c;
                lineItemPriceHistory.Phoenix_Net_Sales__c = item.Phoenix_Net_Sales_Internal__c;
                lineItemPriceHistory.Phoenix_Current_Monthly__c	=item.Phoenix_12_Months_TotalSaleUnits__c;
                lineItemPriceHistory.Phoenix_Proposed_Share__c = item.Phoenix_Date_Fee__c;
                lineItemPriceHistory.Phoenix_SB_Retail_Price__c = item.Phoenix_Current_Retail_Indirect_Price__c;
                lineItemPriceHistory.Phoenix_Gross_Sales__c = item.Phoenix_Net_Sales_External__c;
                lineItemPriceHistory.Phoenix_Current_Sell_Price__c =item.Phoenix_Current_Direct_Price__c;
                lineItemPriceHistory.Phoenix_Proposed_52wk__c =item.Phoenix_Proposed_Anda_Units__c;
                lineItemPriceHistory.Phoenix_Retail_Dollor__c = item.Phoenix_Opening_Order_Net_sales__c;
                lineItemPriceHistory.Phoenix_Supply_Type__c = item.Phoenix_Supply_Type__c;
                lineItemPriceHistory.Phoenix_Total_Units__c = item.Phoenix_12_Months_IndirectSaleUnit__c;
                lineItemPriceHistory.Created_Date__c = system.now();
                lineItemPriceHistory.Phoenix_Bid_Line_Item__c = item.Id;
                lineItemPriceHistory.Phoenix_Sales_Price__c = item.Phoenix_ProposedContract_Bid_Price_Sales__c;
                lineItemPriceHistory.Phoenix_Marketing_Price__c = item.Phoenix_ProposedContractBidPriceMktng__c;
                lineItemPriceHistory.Phoenix_Proposed_Monthly__c = item.Phoenix_Proposed_OS_Units__c;
                lineItemPriceHistory.Phoenix_Sell_Price_Change__c = item.Phoenix_Reduc_in_NCP_McK_And_RAD__c;
                lineItemPriceHistory.Phoenix_Net_Price__c = item.Phoenix_Internal_Dead_Net_Price__c;
                lineItemPriceHistory.Phoenix_Damages__c = item.Phoenix_Reduction__c;
                lineItemPriceHistory.Phoenix_Damages_Dollor__c = item.Phoenix_Current_Anda_CP_Price__c;
                lineItemPriceHistory.Phoenix_Direct_CD_Percent__c = item.Phoenix_Cash_Terms__c;
                lineItemPriceHistory.Phoenix_Direct_CD_Dollor__c = item.Phoenix_Cash_Terms_RxSS__c;
                lineItemPriceHistory.Phoenix_TPT_Dollor_per_pack__c = item.Proposed_TPT_Direct__c;
                lineItemPriceHistory.Phoenix_TPT_per_pack__c = item.Proposed_TPT_Per_Direct__c;
                lineItemPriceHistory.Phoenix_Total_TPT__c = item.Phoenix_Th_Put_Margin__c;
                lineItemPriceHistory.Phoenix_Profit__c = item.Phoenix_Current_Net_Indirect_Price__c;
                lineItemPriceHistory.Phoenix_Sell_Price_Per_Size__c = item.Phoenix_Reduc_in_NCP_McK_And_RAD__c;
                lineItemPriceHistory.Phoenix_RM_Dollor__c = item.Phoenix_Opening_Order_TPT__c;
                lineItemPriceHistory.Phoenix_RM_Percent__c = item.Phoenix_Opening_Order_TPT_Per__c;
                lineItemPriceHistory.Phoenix_Sales_Notes__c = item.Phoenix_Sales_Notes__c;
                lineItemPriceHistory.Phoenix_Customer_Approval__c = item.Phoenix_Customer_Approval_OTC__c;
                lineItemPriceHistory.Phoenix_Customer_Comments__c = item.Phoenix_Customer_Service_Comments__c;
                lineItemPriceHistory.Phoenix_Supply_Effective_Date__c = item.Phoenix_Supply_Effective_Date__c;
                lineItemPriceHistory.Phoenix_Price_Effective_Date__c = item.Phoenix_Price_Effective_Date__c;
                //for timings.
                lineItemPriceHistory.Phoenix_Marketing_Approval_Compld_Time__c =mkgCompletedTime;
                lineItemPriceHistory.Phoenix_Marketing_Approval_Sent_Time__c =mkgSentTime;
                //end.
                lineItemPriceHistoryList.add(lineItemPriceHistory);
                bidlinesList.add(item);
                for(Phoenix_Bid_Process_Steps__c step: stepsToUpdate){
                    String stepName = step.Name;
                    If(mkgStepNo!=null &&(!stepName.contains('Supply Chain'))&& step.Phoenix_Step__c == mkgStepNo && step.Phoenix_Approver__r.Name ==item.Phoenix_Product_Director1__c){
                        step.Phoenix_Status__c = 'In Process';
                        step.Phoenix_Approval_Sent_Time__c =null;
                        step.Phoenix_Approval_Sent_Time_String__c = null;
                        step.Phoenix_Approval_Completed_Time__c = null;
                        step.Phoenix_Approval_Completed_Time_String__c=null;
                        updateProcessStepsSet.add(step);
                        if(!nextSteps.contains(step))
                            nextSteps.add(step);
                    }
                    else If(custStepNo!=null && step.Phoenix_Step__c == custStepNo){
                        step.Phoenix_Status__c = 'Not Initiated';
                        step.Phoenix_Approval_Sent_Time__c =null;
                        step.Phoenix_Approval_Sent_Time_String__c = null;
                        step.Phoenix_Approval_Completed_Time__c = null;
                        step.Phoenix_Approval_Completed_Time_String__c=null;
                        updateProcessStepsSet.add(step);
                    }
                    
                }
            }
            updateProcessStepsList.addAll(updateProcessStepsSet);
            bid.Phoenix_Approval_Status__c = (bid.Phoenix_Bid_Type__c == 'OTC Price Change' || bid.Phoenix_Bid_Type__c == 'OTC Rebate Change' || bid.Phoenix_Bid_Type__c =='OTC OTB Good Dated' || bid.Phoenix_Bid_Type__c =='OTC OTB Short Dated') ? 'Marketing': 'SCM & Marketing';
            bidVersion = bid.Phoenix_OTC_Bid_Version__c;
            //system.debug('bidVersion '+bidVersion);
            bidVersion= bidVersion.substringAfter(' ');
            updatedbidVersion = Integer.valueof(bidVersion);
            //system.debug('updatedbidVersion '+updatedbidVersion);
            updatedbidVersion = updatedbidVersion+1;
            //system.debug('updatedbidVersion '+updatedbidVersion);
            bid.Phoenix_OTC_Bid_Version__c = 'Version ' +updatedbidVersion;
            bid.Phoenix_Sent_to_Customer_Date__c = null;
            //system.debug(' bid.Phoenix_OTC_Bid_Version__c  '+ bid.Phoenix_OTC_Bid_Version__c);
            
            
            Insert lineItemPriceHistoryList;
            Update bid;
            Update bidlinesList;
            Update updateProcessStepsList;
            Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId,nextSteps);
        }
        
        
        Catch(Exception e) {
            String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_OTC_Send_Back', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'getLowestPrice', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Remarks__c = 'Bid Id is ' + bidId, Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        return returnStatus;
    }
    public static String createCustomerResponse(String bidId){
        String query,bidApiName = 'Phoenix_Bid__c', bidLineApiName= 'Bid_Line_Items__r', finalStatus='Not Approved';
        query = 'Select Phoenix_Customer__r.Name, '+Phoenix_Util.bidFields+', (Select '+Phoenix_Util.bidlineitemFields+' From '+bidLineApiName+' Where Phoenix_Final_Status__c !=:finalStatus)'+' From '+bidApiName+' Where Id=:bidId';
        list < Phoenix_Bid__c> bidList = Database.query(query);
        List<Phoenix_Bid_Line_Item__c> bidLines=[Select Id, Name, Phoenix_Bid__c, Phoenix_Customer_Response__c FROM Phoenix_Bid_Line_Item__c Where Phoenix_Bid__c=:bidId AND Phoenix_Final_Status__c != 'Not Approved'];
        if(bidList !=null){
            
            List<Phoenix_Awarded_Quantity__c> awardedQtyList = new  List<Phoenix_Awarded_Quantity__c>();
            Phoenix_Customer_Response__c custResponse = new Phoenix_Customer_Response__c();
            custResponse.Phoenix_Bid_No__c = bidList[0].Id;
            custResponse.Phoenix_Customer__c =  bidList[0].Phoenix_Customer__c;
            custResponse.Phoenix_Affected_Contract_s__c = bidList[0].Phoenix_Reference_Contracts__c;
            custResponse.Phoenix_Sent_to_Customer_Date__c = bidList[0].Phoenix_Sent_to_Customer_Date__c;
            custResponse.Phoenix_Customer_Response_Date__c = system.today();
            custResponse.Phoenix_Contracts_for_Vistex_Update__c =  bidList[0].Phoenix_Reference_Contracts__c;
            custResponse.Phoenix_Items_Pending__c = 'All Items Settled';
            custResponse.Phoenix_Contract_Status__c = 'Completed';
            custResponse.Phoenix_Contract_Update_Date__c = system.today();
           //Added on 23-05-2023
            custResponse.Delay_Type__c='N/A';
            insert custResponse;
             
            for(Phoenix_Bid_Line_Item__c line : bidLines){
                line.Phoenix_Customer_Response__c = custResponse.Id;
            }
            update bidLines;
            //Replaced from Production by Sumanth on 3rd may 2023
            Map<Id,Phoenix_Customer_Response_Line__c> customerRespLinesMap= createCustomerLines(custResponse,bidList);
            List<Phoenix_Contract__c> contractsList= new List<Phoenix_Contract__c>();
            if(bidList.size() >0)
                contractsList= getContracts(bidList[0].Phoenix_Reference_Contracts__c);
            if(bidList[0].Bid_Line_Items__r != null && bidList[0].Bid_Line_Items__r.size()>0){
                 system.debug('CR======='+bidList[0].Bid_Line_Items__r);
                for(Phoenix_Bid_Line_Item__c bidLine : bidList[0].Bid_Line_Items__r){
                    //Creating Awarded Quantiy
                    system.debug('awrd qty bidLine======='+bidLine);
                    Phoenix_Awarded_Quantity__c awardQty = new Phoenix_Awarded_Quantity__c();
                    awardQty.Phoenix_Awarded_Quantity__c = bidLine.Phoenix_Final_Direct_Selling_Units_Calc__c;
                    awardQty.Phoenix_Bid__c = bidList[0].Id;
                    awardQty.Phoenix_Bid_Line_Item__c = bidLine.Id;
                    //awardQty.Phoenix_Contract__c = 
                    awardQty.Phoenix_Contract_Number__c = bidList[0].Phoenix_Reference_Contracts__c;
                    awardQty.Phoenix_Customer__c =  bidList[0].Phoenix_Customer__c;
                    awardQty.Customer_Name__c = bidList[0].Phoenix_Customer__r.Name;
                    awardQty.Phoenix_Customer_Response__c = custResponse.Id;
                    awardQty.Customer_Response_Line__c = customerRespLinesMap.get(bidLine.Id).Id;// custResponseLine.Id;
                    awardQty.Phoenix_Effective_Date__c = bidLine.Phoenix_Price_Effective_Date__c;
                    //awardQty.Phoenix_Internal_Contract_Description__c = contractsList != null ? contractsList[0].Phoenix_Contract_Internal_Description__c : null;
                    if(contractsList.size()>0){
                        awardQty.Contract_Internal_Description__c = contractsList != null ? contractsList[0].Phoenix_Contract_Internal_Description__c : null;
                        awardQty.Phoenix_Contract__c = contractsList != null ? contractsList[0].Id : null; 
                        awardQty.Phoenix_Contract_Number__c = contractsList != null ? contractsList[0].Phoenix_Contract_Number__c : null; 
                    }
                    awardQty.Phoenix_Product__c = bidLine.Phoenix_Product__c;
                    awardQty.Phoenix_Material_Code__c = bidLine.Phoenix_Product_Code1__c;
                    awardQty.Phoenix_Supply_Effective_Date__c = bidLine.Phoenix_Supply_Effective_Date__c;
                    //added by sumanth in UAT on 3rd may 2023
                    awardQty.Phoenix_Awarded_Position__c = bidLine.Phoenix_Proposed_Position__c;
                    
                    awardedQtyList.add(awardQty);
                }
            }
            system.debug('awrd qty size======='+awardedQtyList.size());
            if(awardedQtyList != null && awardedQtyList.size()>0){
                insert awardedQtyList;
            }
                
        }
        
        return 'success';
    }
    public static String createActionItem(String bidId, List<Phoenix_Bid_Line_Item__c> bidLineList){
        String returnStatus = '';
        List<Phoenix_Bid_Action_Item__c> existingLines = [SELECT ID FROM Phoenix_Bid_Action_Item__c where Phoenix_Bid__c=:bidId];
        If(existingLines.size()==0){
            system.debug('if called');
        List < Phoenix_Bid_Action_Item__c > actionItemsList = new List < Phoenix_Bid_Action_Item__c > ();
        for(Phoenix_Bid_Line_Item__c item:bidLineList){
            Phoenix_Bid_Action_Item__c actionItem = new Phoenix_Bid_Action_Item__c();
            actionItem.Phoenix_Account__c = item.Phoenix_Bid__r.Phoenix_Customer__c;
            actionItem.Phoenix_Bid__c = bidId;
            actionItem.Phoenix_Bid_Line_Item__c = item.Id;
            actionItem.Phoenix_Bid_Name__c = item.Phoenix_Bid__r.Phoenix_Bid_Name__c;
            actionItem.Phoenix_GCN_Generic_Code_Number__c = item.Phoenix_Product__r.Phoenix_GCN_Generic_Code_Number__c;
            actionItem.Phoenix_GCN_Sequence_Number__c = item.Phoenix_Product__r.Phoenix_GCN_Sequence_Number__c;
            actionItem.Phoenix_GPI_Generic_Product_Identifier__c = item.Phoenix_Product__r.Phoenix_GPI_Generic_Product_Identifier__c;
            //actionItem.Phoenix_NDC_11__c = item.Phoenix_Product__r.Phoenix_NDC_11_Dashes__c;
            actionItem.Phoenix_Pkg_Size__c = item.Phoenix_Pkg_Size__c;
            actionItem.Phoenix_Product__c = item.Phoenix_Product__c;
            actionItem.Phoenix_Strength__c =item.Phoenix_Current_Supplier__c;
            actionItem.Phoenix_Product_Director__c = item.Phoenix_Product_Director__c;
            actionItem.Status__c = 'Open';
            actionItemsList.add(actionItem);
            
        }
        system.debug('actionItemsList--->'+actionItemsList);
        Insert actionItemsList;
        List<Id> actionIds = new List<Id>();
        for(Phoenix_Bid_Action_Item__c item:actionItemsList){
            actionIds.add(item.id);
            
        }
        List<Phoenix_Bid_Action_Item__c> itemstosend = [SELECT Id,Phoenix_Bid__r.Name,Phoenix_Bid__c,Phoenix_Account__r.Name,Phoenix_Product__r.Name,Phoenix_Product_Director__c,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GCN_Generic_Code_Number__c FROM Phoenix_Bid_Action_Item__c where Id IN :actionIds];
        Phoenix_SubmitBidForApprovalCtrl.sendEmailToMDMTeam(bidId,itemstosend);
        }
        return returnStatus;   
    }
    public static Map<Id,Phoenix_Customer_Response_Line__c> createCustomerLines(Phoenix_Customer_Response__c custResponse,list < Phoenix_Bid__c> bidList){
        List<Phoenix_Customer_Response_Line__c> custResponseLinestoCreate = new  List<Phoenix_Customer_Response_Line__c>();
        Map<Id,Phoenix_Customer_Response_Line__c> curstomerResponseLinesMap = new Map<Id, Phoenix_Customer_Response_Line__c>();
        if(bidList[0].Bid_Line_Items__r != null && bidList[0].Bid_Line_Items__r.size()>0){
                for(Phoenix_Bid_Line_Item__c bidLine : bidList[0].Bid_Line_Items__r){
                    Phoenix_Customer_Response_Line__c custResponseLine = new Phoenix_Customer_Response_Line__c();
                    custResponseLine.Phoenix_Bid__c = bidList[0].Id;
                    custResponseLine.Phoenix_Bid_Line_Item__c = bidLine.Id;
                    custResponseLine.Phoenix_Customer_Response__c = custResponse.Id;
                    custResponseLine.Phoenix_Supply_Effective_Date__c = bidLine.Phoenix_Supply_Effective_Date__c;
                    custResponseLine.Phoenix_Supply_Effective_Date__c = bidLine.Phoenix_Supply_Effective_Date__c;
                    custResponseLine.Phoenix_Price_Effective_Date__c = bidLine.Phoenix_Price_Effective_Date__c;
                    custResponseLine.Phoenix_Bid_Status__c = 'Awarded';
                    // //added by sumanth in UAT on 3rd may 2023
                    custResponseLine.Phoenix_Award_Position__c=bidLine.Phoenix_Proposed_Position__c;
                    custResponseLine.Phoenix_OTC_Customer_Comments__c = bidLine.Phoenix_Customer_Service_Comments__c;
                    custResponseLine.Phoenix_Awarded_Quantity__c = bidLine.Phoenix_Final_Direct_Selling_Units_Calc__c;
                    custResponseLinestoCreate.add(custResponseLine);
                    
                }
        }
        if(custResponseLinestoCreate != null && custResponseLinestoCreate.size()>0){
            insert custResponseLinestoCreate;
        }
        for(Phoenix_Customer_Response_Line__c customerRespLine : custResponseLinestoCreate){
            curstomerResponseLinesMap.put(customerRespLine.Phoenix_Bid_Line_Item__c, customerRespLine);
        }
        return curstomerResponseLinesMap;
        
    }
    public static List<Phoenix_Contract__c> getContracts(String contractNumbers){
       List<String> lstContractNumbers = new List<String>();
        if(contractNumbers != null && contractNumbers != '')
       lstContractNumbers = contractNumbers.split(',');
        List<Phoenix_Contract__c> contractsList = [SELECT Id, Account_Type__c,Phoenix_Contract_Number__c, Phoenix_Contract_Internal_Description__c, Phoenix_Contract_External_Description__c FROM Phoenix_Contract__c WHERE  Phoenix_Contract_Number__c=:lstContractNumbers ];
        return contractsList;
    }
    
}