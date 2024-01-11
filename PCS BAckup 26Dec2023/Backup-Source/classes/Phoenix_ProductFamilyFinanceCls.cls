/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
public class Phoenix_ProductFamilyFinanceCls {
    @AuraEnabled
    public static List < Wrapper > getProductFamlilyRollups(String bidId) {
        List < Wrapper > wrapperList = new List < Wrapper > ();
        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for(String fieldName : fieldMap.keyset() )
        {
            if(strFields == null || strFields == '')
            {
                strFields = fieldName;
            }else{
                strFields = strFields + ' , ' + fieldName;
            }
        }
        string notApproved = 'Not Approved';
        query = 'select ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved ORDER BY Product_Family_Name__c ASC'  ;
        List<Phoenix_Bid_Line_Item__c> bidLineItemsList = Database.query(query);
        List<String> productFamilyList = new List<String>();
        List<String> financeApprovalList = new List<String>();
        List<String> financeCommentsList = new List<String>();
        List<Decimal> dataMap = new List<Decimal>();
        Decimal totalBudgtedASP = 0 ;
        Boolean isApproval = true;
        Map<String, List<Decimal>> productFamilyRollupMap = new Map<String, List<Decimal>>();
        for(Phoenix_Bid_Line_Item__c bidLineItem : bidLineItemsList){
            if(bidLineItem.Phoenix_Budgeted_ASP1__c != null)
                totalBudgtedASP += bidLineItem.Phoenix_Budgeted_ASP1__c;
        }
        for(Phoenix_Bid_Line_Item__c bidLineItem : bidLineItemsList){
            if(bidLineItem.Phoenix_Final_Finance_Approval__c == false)
                isApproval = false;
            if(bidLineItem.Product_Family_Name__c != null && !productFamilyRollupMap.containsKey(bidLineItem.Product_Family_Name__c)){
                dataMap = getData(bidLineItem);
                if(dataMap != null && dataMap.size() > 0 && dataMap[2] == 0){
                    dataMap[3] =0;
                    dataMap[4]=0; 
                }
                if(dataMap != null && dataMap.size() > 0 && dataMap[2] != 0){                     dataMap[4] = (dataMap[3] / dataMap[2] ) *100 ;
                                                                            }
                if(dataMap != null && dataMap.size() > 0 && dataMap[0] != 0){                     dataMap[5] = (dataMap[2] / dataMap[0] ) ;
                                                                             }
                if(dataMap != null && dataMap.size() > 0 && dataMap[6] != 0){                     dataMap[11] = (dataMap[8] / dataMap[6] )  ;
                                                                            }
                if(dataMap != null && dataMap.size() > 0 && dataMap[8] != 0){                    dataMap[10] = (dataMap[9] / dataMap[8] ) *100 ;
                                                                            }
                if(dataMap != null && dataMap.size() > 0 && dataMap[5] != 0){                     dataMap[20] = ((dataMap[11] / dataMap[5]) - 1 ) *100 ;
                                                                            }else{
                                                                                dataMap[20] = 0;                                                      
                                                                            }
                if(dataMap != null && dataMap.size() > 0 && dataMap[7] != 0){                    dataMap[12] = ((totalBudgtedASP * dataMap[6])/  dataMap[7] );
                                                                            }
                else{
                    dataMap[12] = 0;
                }
                if(dataMap != null && dataMap.size() > 0 && dataMap[12] != 0){                    dataMap[13] = ((dataMap[11] / dataMap[12]) - 1 ) *100 ;
                                                                             }
                else{
                    dataMap[13] =0 ;
                }
                
                
                
                productFamilyRollupMap.put(bidLineItem.Product_Family_Name__c, dataMap);
                if(bidLineItem.Phoenix_Finance_Comments__c != null)                    financeCommentsList.add(bidLineItem.Phoenix_Finance_Comments__c);
                else
                    financeCommentsList.add('');
                financeApprovalList.add(bidLineItem.Phoenix_Finance_Approval__c);
            }
            else if(bidLineItem.Product_Family_Name__c != null){
                dataMap = productFamilyRollupMap.get(bidLineItem.Product_Family_Name__c);
                List<Decimal> newDataMap = new List<Decimal>();
                newDataMap = getData(bidLineItem);
                for(Integer i=0; i<newDataMap.size();i++){
                    newDataMap[i] = dataMap[i]+ newDataMap[i];
                }
                 if(newDataMap != null && newDataMap.size() > 0 && newDataMap[2] == 0){
                    newDataMap[3] = 0 ;
                    newDataMap[4] = 0 ;
                }
                
                if(newDataMap != null && newDataMap.size() > 0 && newDataMap[2] != 0){
                    newDataMap[4] = (newDataMap[3] / newDataMap[2] ) *100 ;
                    
                }
                if(newDataMap != null && newDataMap.size() > 0 && newDataMap[0] != 0){
                    newDataMap[5] = (newDataMap[2] / newDataMap[0] )  ;
                  
                }
                if(newDataMap != null && newDataMap.size() > 0 && newDataMap[6] != 0){                     newDataMap[11] = (newDataMap[8] / newDataMap[6] ) ;
                                                                                    
                                                                                     }
                if(newDataMap != null && newDataMap.size() > 0 && newDataMap[8] != 0){
                    newDataMap[10] = (newDataMap[9] / newDataMap[8] ) *100 ;
                 }
                if(newDataMap != null && newDataMap.size() > 0 && newDataMap[5] != 0){
                    newDataMap[20] = ((newDataMap[11] / newDataMap[5]) - 1 ) *100 ;
                   }else{
                    newDataMap[20] = 0;
                }
                if(newDataMap != null && newDataMap.size() > 0 && newDataMap[7] != 0){
                    newDataMap[12] = ((totalBudgtedASP * dataMap[6])/  newDataMap[7] );
                }else{
                    newDataMap[12]  = 0;
                }
                if(newDataMap != null && newDataMap.size() > 0 && newDataMap[12] != 0){
                    newDataMap[13] = ((newDataMap[11] / newDataMap[12]) - 1 ) *100 ;
                }else{
                    newDataMap[13] = 0;
                }
                
                productFamilyRollupMap.put(bidLineItem.Product_Family_Name__c,newDataMap);
                
            }
        }
        Integer i = 0;
        Integer j = 0;
        Phoenix_Bid__c bid = [SELECT Id, Name, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE ID =: bidId];
        
        //added by hari for approval
        Map<String, String> userTeamUserIdMap = new Map<String, String>();
        for(Phoenix_User_Approval_Matrix__c matrix : [Select Id, Name,RecordType.DeveloperName,User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c,Phoenix_Approver__c,Phoenix_Approver__r.Email,Phoenix_Approver_Group_Name__c,Phoenix_Is_Active_User__c,Phoenix_Is_Approval_Process_User__c,User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]){
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c+'-'+ matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__c);
        }
        boolean isFinanceApprovePerson=false;
        
        if(userTeamUserIdMap.containsKey('Finance-'+UserInfo.getUserId())){            isFinanceApprovePerson=true;
                                                                          }
        
        //ended by hari
        //
        for(String productFamily : productFamilyRollupMap.keySet()){
            Wrapper wrapper = new Wrapper();
            wrapper.productFamilyName = productFamily;
            wrapper.financeApproval = financeApprovalList[i++];
            wrapper.financeComments = financeCommentsList[j++];
            wrapper.dataList = productFamilyRollupMap.get(productFamily);
            wrapper.bidRecord = bid;
            wrapper.finalApproval = isApproval;
            wrapper.isFinanceApprovePerson=isFinanceApprovePerson;
            wrapperList.add(wrapper);
        }
         return wrapperList;
        
    } 
    public static List<Decimal> getData(Phoenix_Bid_Line_Item__c bidLineItem){
        List<Decimal> dataMap = new List<Decimal>();
        if(bidLineItem.Phoenix_Total_Selling_Unit__c != null)
            dataMap.add(bidLineItem.Phoenix_Total_Selling_Unit__c);
        else                    dataMap.add(0);
        if(bidLineItem.Phoenix_Doses__c != null)
            dataMap.add(bidLineItem.Phoenix_Doses__c);
        else                    dataMap.add(0);
        if(bidLineItem.Finance_Current_Sales__c != null)
            dataMap.add(bidLineItem.Finance_Current_Sales__c);
        else if(bidLineItem.Phoenix_Current_Sales_Finance__c != null)                    
            dataMap.add(bidLineItem.Phoenix_Current_Sales_Finance__c);
        else
            dataMap.add(0);
        decimal thMargin = 0;
        if(bidLineItem.Phoenix_Throughput_cost__c != null && bidLineItem.Phoenix_Total_Selling_Unit__c != null && bidLineItem.Finance_Current_Sales__c != null && bidLineItem.Finance_Current_Sales__c != 0)   
            thMargin = (bidLineItem.Finance_Current_Sales__c - bidLineItem.Phoenix_Throughput_cost__c * bidLineItem.Phoenix_Total_Selling_Unit__c );
        else if(bidLineItem.Phoenix_Throughput_cost__c != null && bidLineItem.Phoenix_Total_Selling_Unit__c != null && bidLineItem.Phoenix_Current_Sales_Finance__c != null && bidLineItem.Phoenix_Current_Sales_Finance__c != 0)   
            thMargin = (bidLineItem.Phoenix_Current_Sales_Finance__c - bidLineItem.Phoenix_Throughput_cost__c * bidLineItem.Phoenix_Total_Selling_Unit__c );
        dataMap.add(thMargin);
        if(bidLineItem.Finance_Current_Sales__c != null && bidLineItem.Finance_Current_Sales__c > 0)                   
            dataMap.add(thMargin / bidLineItem.Finance_Current_Sales__c);
        else if(bidLineItem.Phoenix_Current_Sales_Finance__c != null && bidLineItem.Phoenix_Current_Sales_Finance__c > 0)                   
            dataMap.add(thMargin / bidLineItem.Phoenix_Current_Sales_Finance__c);
        else
            dataMap.add(0);
        if(bidLineItem.Finance_Current_Sales__c != 0 && bidLineItem.Finance_Current_Sales__c != null && bidLineItem.Phoenix_Doses__c > 0 && bidLineItem.Phoenix_Doses__c != null)
            dataMap.add(bidLineItem.Finance_Current_Sales__c / bidLineItem.Phoenix_Doses__c);
        else if(bidLineItem.Phoenix_Current_Sales_Finance__c != 0 && bidLineItem.Phoenix_Current_Sales_Finance__c != null && bidLineItem.Phoenix_Doses__c > 0 && bidLineItem.Phoenix_Doses__c != null)
            dataMap.add(bidLineItem.Phoenix_Current_Sales_Finance__c / bidLineItem.Phoenix_Doses__c);
        else
            dataMap.add(0);
        if(bidLineItem.Phoenix_Final_Total_Selling_Unit__c != null)
            dataMap.add(bidLineItem.Phoenix_Final_Total_Selling_Unit__c);
        else                    dataMap.add(0);
        if(bidLineItem.Phoenix_Final_Annual_Extended_Units__c != null)
            dataMap.add(bidLineItem.Phoenix_Final_Annual_Extended_Units__c);
        else                    dataMap.add(0);
        if(bidLineItem.Phoenix_Net_Sales_Internal__c != null)                    dataMap.add(bidLineItem.Phoenix_Net_Sales_Internal__c);
        else
            dataMap.add(0);
        if(bidLineItem.Phoenix_Th_Put_Margin__c != null)
            dataMap.add(bidLineItem.Phoenix_Th_Put_Margin__c);
        else                    dataMap.add(0);
        decimal curASPperDose = 0;
        if(bidLineItem.Phoenix_Net_Sales_Internal__c != 0 && bidLineItem.Phoenix_Net_Sales_Internal__c != null &&                   bidLineItem.Phoenix_Th_Put_Margin__c != 0 && bidLineItem.Phoenix_Th_Put_Margin__c != null
          ){                      curASPperDose = bidLineItem.Phoenix_Th_Put_Margin__c / bidLineItem.Phoenix_Net_Sales_Internal__c;                      dataMap.add(curASPperDose);
           }else{
               dataMap.add(0);
           }
        decimal ASPPerDose;
        if(bidLineItem.Phoenix_Net_Sales_Internal__c != 0 && bidLineItem.Phoenix_Net_Sales_Internal__c != null &&                   bidLineItem.Phoenix_Final_Annual_Extended_Units__c != 0 && bidLineItem.Phoenix_Final_Annual_Extended_Units__c != null
          ){
              ASPPerDose = bidLineItem.Phoenix_Net_Sales_Internal__c / bidLineItem.Phoenix_Final_Annual_Extended_Units__c ;
              dataMap.add(ASPPerDose);
          }else{
              ASPPerDose = 0;
              dataMap.add(0);
          }
        if(bidLineItem.Phoenix_Budgeted_ASP1__c != null && bidLineItem.Phoenix_Final_Total_Selling_Unit__c != null && bidLineItem.Phoenix_Final_Annual_Extended_Units__c != null && bidLineItem.Phoenix_Final_Annual_Extended_Units__c != 0)                    dataMap.add((bidLineItem.Phoenix_Budgeted_ASP1__c * bidLineItem.Phoenix_Final_Total_Selling_Unit__c) /( bidLineItem.Phoenix_Final_Annual_Extended_Units__c));
        else
            dataMap.add(0);
        if(bidLineItem.Phoenix_Dollars_based_on_Budgeted_ASP__c != 0 && bidLineItem.Phoenix_Dollars_based_on_Budgeted_ASP__c != null)
            dataMap.add((ASPPerDose / bidLineItem.Phoenix_Dollars_based_on_Budgeted_ASP__c)-1);
                else                    dataMap.add(0);
                decimal diffBottles = (bidLineItem.Phoenix_Final_Total_Selling_Unit__c != null ? bidLineItem.Phoenix_Final_Total_Selling_Unit__c : 0) - (bidLineItem.Phoenix_Total_Selling_Unit__c != null ? bidLineItem.Phoenix_Total_Selling_Unit__c:0) ;
                decimal doses = (bidLineItem.Phoenix_Final_Annual_Extended_Units__c != null ? bidLineItem.Phoenix_Final_Annual_Extended_Units__c:0) - (bidLineItem.Phoenix_Doses__c != null ? bidLineItem.Phoenix_Doses__c:0);
                decimal intdeadnetrice=bidLineItem.Phoenix_Internal_Dead_Net_Price__c != null?bidLineItem.Phoenix_Internal_Dead_Net_Price__c:0;
        		decimal deadnetTrackGr=bidLineItem.Phoenix_DeadNet_TrckGR__c != null?bidLineItem.Phoenix_DeadNet_TrckGR__c:0;
                decimal prosedDiffernce = intdeadnetrice - deadnetTrackGr;
                dataMap.add(diffBottles);
                dataMap.add(doses);
                dataMap.add(diffBottles * deadnetTrackGr);
                if(bidLineItem.Phoenix_Current_Sales_Finance__c != 0)  
                	dataMap.add((bidLineItem.Phoenix_Final_Total_Selling_Unit__c != null ? bidLineItem.Phoenix_Final_Total_Selling_Unit__c : 0) * prosedDiffernce);
        		else
            dataMap.add(0);
        decimal curntNetSales=bidLineItem.Finance_Current_Sales__c != null ? bidLineItem.Finance_Current_Sales__c :(bidLineItem.Phoenix_Current_Sales_Finance__c != null?bidLineItem.Phoenix_Current_Sales_Finance__c:0);
        decimal propsdNetsales=bidLineItem.Phoenix_Net_Sales_Internal__c != null?bidLineItem.Phoenix_Net_Sales_Internal__c:0;
        dataMap.add(propsdNetsales-curntNetSales);
        /*if(bidLineItem.Phoenix_Current_Sales_Finance__c != null && bidLineItem.Phoenix_Net_Sales_Internal__c != null)
dataMap.add(bidLineItem.Phoenix_Net_Sales_Internal__c - bidLineItem.Phoenix_Current_Sales_Finance__c );
else
dataMap.add(0);*/
        if(bidLineItem.Phoenix_Th_Put_Margin__c != null)
            dataMap.add(bidLineItem.Phoenix_Th_Put_Margin__c - thMargin);
        else
            dataMap.add(0);
        if(curASPperDose != 0)
            dataMap.add(ASPPerDose / curASPperDose );
        else
            dataMap.add(0);
        return dataMap;
    }
    @AuraEnabled
    public static List<Wrapper> updateLineItems(String bidId, Map<String,String> approvalMap , Map<String,String> commentsMap, string financeApproval, boolean isFinanceApproved ){
        string query, condition='';
        List<String> productFamilyList = new List<String>();
        if(approvalMap != null)
            productFamilyList.addAll(approvalMap.keySet());
        if(commentsMap != null)
            productFamilyList.addAll(commentsMap.keySet());
        string notApproved = 'Not Approved';
        query = 'SELECT id ,Phoenix_Finance_Comments__c, IsDeleted,Phoenix_Bid_Line_Product_Family__c ,Product_Family_Name__c,Phoenix_Finance_Approval__c,Phoenix_Bid__c,Phoenix_Product_Family__c   FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =: bidId AND Phoenix_Final_Status__c !=: notApproved';
        List<Phoenix_Bid_Line_Item__c> allLineItemList = Database.query(query);
        if(productFamilyList != null)
            query = query + ' AND Product_Family_Name__c =: productFamilyList FOR UPDATE';
        List<Phoenix_Bid_Line_Item__c> approvalLineItemList = Database.query(query);
        if(isFinanceApproved == true){
            for(Phoenix_Bid_Line_Item__c bidLineItem : allLineItemList){
                bidLineItem.Phoenix_Finance_Approval__c = financeApproval;
            }
            update allLineItemList;
        }
        List<String> listofIds = new List<String>();
        if(approvalMap != null || commentsMap != null){
            for(Phoenix_Bid_Line_Item__c bidLineItem : approvalLineItemList){
                //bidLineItem.Phoenix_Bid_Line_Product_Family__c  = bidLineProductMap.get(bidLineItem.Phoenix_Product_Family__c);
                
                if(approvalMap != null && approvalMap.keySet().contains(bidLineItem.Product_Family_Name__c)){
                   if(approvalMap.get(bidLineItem.Product_Family_Name__c) != 'None')                    bidLineItem.Phoenix_Finance_Approval__c = approvalMap.get(bidLineItem.Product_Family_Name__c);
                    else                    bidLineItem.Phoenix_Finance_Approval__c = null;
                }
                if(commentsMap != null && commentsMap.keySet().contains(bidLineItem.Product_Family_Name__c)){bidLineItem.Phoenix_Finance_Comments__c = commentsMap.get(bidLineItem.Product_Family_Name__c);
                                                                                                                
                                                                                                               }
            }
            
        }
        if(approvalLineItemList != null && approvalLineItemList.size() > 0)            update approvalLineItemList;
        
        for(Phoenix_Bid_Line_Item__c bidLineItem : approvalLineItemList){          listofIds.add(bidLineItem.Phoenix_Bid_Line_Product_Family__c);
                                                                        }
        List<Phoenix_Bid_Line_Product_Family__c> toBeDeltedBidLineProductFmly = new List<Phoenix_Bid_Line_Product_Family__c>();
        if(listofIds != null && listofIds.size() > 0)            toBeDeltedBidLineProductFmly = [SELECT Id, IsDeleted, Phoenix_Bid__c, Phoenix_Finance_Approval__c, Phoenix_Finance_Comments__c FROM Phoenix_Bid_Line_Product_Family__c WHERE Phoenix_Bid__c =:  bidId]; 
        
         
        if(toBeDeltedBidLineProductFmly != null && toBeDeltedBidLineProductFmly.size() > 0)            delete toBeDeltedBidLineProductFmly ;
        for(Phoenix_Bid_Line_Product_Family__c ProductFamilyLine : toBeDeltedBidLineProductFmly){
  }
        
        List<Wrapper> wrapperList = new List<Wrapper>();
        wrapperList =  getProductFamlilyRollups(bidId) ;
        List<Phoenix_Bid_Line_Product_Family__c> bidLineProductFamilyList = new List<Phoenix_Bid_Line_Product_Family__c>();
        for(Wrapper wrapperCls : wrapperList){
            Phoenix_Bid_Line_Product_Family__c  bidLineProductFamily = new Phoenix_Bid_Line_Product_Family__c ();
            List<decimal> bidLineProductFamilyValues = wrapperCls.dataList ;
            bidLineProductFamily.Name = wrapperCls.productFamilyName ;
            bidLineProductFamily.Phoenix_Bid__c = bidId ;
            bidLineProductFamily.Phoenix_Current_Bottles__c = bidLineProductFamilyValues[0];
            bidLineProductFamily.Phoenix_Current_Doses__c = bidLineProductFamilyValues[1];
            bidLineProductFamily.Phoenix_Current_Sales__c = bidLineProductFamilyValues[2];
            bidLineProductFamily.Phoenix_Current_TP_Margin__c = bidLineProductFamilyValues[3];
            bidLineProductFamily.Phoenix_Current_TP_Margin_Percent__c = bidLineProductFamilyValues[4];
            bidLineProductFamily.Phoenix_Current_ASP_Dose__c = bidLineProductFamilyValues[5];
            bidLineProductFamily.Phoenix_Proposed_Bottles__c = bidLineProductFamilyValues[6];
            bidLineProductFamily.Phoenix_Proposed_Doses__c = bidLineProductFamilyValues[7];
            bidLineProductFamily.Phoenix_Proposed_Sales__c = bidLineProductFamilyValues[8];
            bidLineProductFamily.Phoenix_Proposed_TP_Margin__c = bidLineProductFamilyValues[9];
            bidLineProductFamily.Phoenix_Proposed_TP_Margin_Percent__c = bidLineProductFamilyValues[10];
            bidLineProductFamily.Phoenix_Proposed_ASP_Dose__c = bidLineProductFamilyValues[11];
            bidLineProductFamily.Phoenix_Proposed_Budget_ASP__c = bidLineProductFamilyValues[12];
            bidLineProductFamily.Phoenix_Proposed_to_Budget__c = bidLineProductFamilyValues[13];
            bidLineProductFamily.Phoenix_Difference_Bottles__c = bidLineProductFamilyValues[14];
            bidLineProductFamily.Phoenix_Difference_Doses__c = bidLineProductFamilyValues[15];
            bidLineProductFamily.Phoenix_Difference_Volume__c = bidLineProductFamilyValues[16];
            bidLineProductFamily.Phoenix_Difference_Price__c = bidLineProductFamilyValues[17];
            bidLineProductFamily.Phoenix_Difference_Sales__c = bidLineProductFamilyValues[18];
            bidLineProductFamily.Phoenix_Difference_Margin__c = bidLineProductFamilyValues[19];
            bidLineProductFamily.Phoenix_Difference_ASP_Change__c = bidLineProductFamilyValues[20];
            bidLineProductFamily.Phoenix_Finance_Approval__c = wrapperCls.financeApproval;
            bidLineProductFamily.Phoenix_Finance_Comments__c = wrapperCls.financeComments;
            bidLineProductFamilyList.add(bidLineProductFamily);
           }
        if(bidLineProductFamilyList != null && bidLineProductFamilyList.size() > 0)
            insert bidLineProductFamilyList;
        Map<String , String> bidLineProductMap = new Map<String , String>();
        Integer index = 0;
        for(Wrapper wrapperCls : wrapperList){
            bidLineProductMap.put(wrapperCls.productFamilyName, bidLineProductFamilyList[index++].Id);
        }
        for(Phoenix_Bid_Line_Item__c bidLineItem : allLineItemList){
            bidLineItem.Phoenix_Bid_Line_Product_Family__c  = bidLineProductMap.get(bidLineItem.Phoenix_Product_Family__c);
            if(approvalMap != null && approvalMap.keySet().contains(bidLineItem.Product_Family_Name__c)){                if(approvalMap.get(bidLineItem.Product_Family_Name__c) != 'None')                    bidLineItem.Phoenix_Finance_Approval__c = approvalMap.get(bidLineItem.Product_Family_Name__c);
                                                                                                            else                    bidLineItem.Phoenix_Finance_Approval__c = null;
                                                                                                            /*if(approvalMap.get(bidLineItem.Phoenix_Product_Family__c) == 'Not Approved')
bidLineItem.Phoenix_Final_Status__c = 'Not Approved';*/
                                                                                                           }
            if(commentsMap != null && commentsMap.keySet().contains(bidLineItem.Product_Family_Name__c)){                bidLineItem.Phoenix_Finance_Comments__c = commentsMap.get(bidLineItem.Product_Family_Name__c);
                                                                                                           }
        }
        update allLineItemList;
        
        return  getProductFamlilyRollups(bidId) ;
        }
    
    @AuraEnabled
    public static void makeApprovals(String bidId){
        String query ='';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for(String fieldName : fieldMap.keyset() )
        {
            if(strFields == null || strFields == '')
            {
                strFields = fieldName;
            }else{
                strFields = strFields + ' , ' + fieldName;
            }
        }
        string notApproved = 'Not Approved';
        query = 'select ' + strFields + ', Phoenix_Product__r.name from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved  ORDER BY Product_Family_Name__c ASC'  ;
        List<Phoenix_Bid_Line_Item__c> bidLineItemsList = Database.query(query);
        Phoenix_Bid_Process_Steps__c updateProcessStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c,Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=: bidId AND Phoenix_Approver_Team__c  = 'Finance' LIMIT 1];
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Name,Phoenix_Approver__r.Email, Phoenix_Status__c,Phoenix_Is_Criteria_Step__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:bidId ];
        if(updateProcessStep != null){
            updateProcessStep.Phoenix_Status__c = 'Completed';
            updateProcessStep.Phoenix_Approver__c = userinfo.getuserid();
            update updateProcessStep;
        }
        
        for(Phoenix_Bid_Line_Item__c line : bidLineItemsList ){
            line.Phoenix_Final_Finance_Approval__c = true;
            if(line.Phoenix_Finance_Approval__c == 'Not Approved'){                  line.Phoenix_Final_Status__c = 'Not Approved';
                                                                  }
        }
        if(bidLineItemsList.size()>0)
            update bidLineItemsList;
        updateNextProcessSteps(bidId, bidProcessStepList);
        
    }
    @AuraEnabled 
    public static void updateNextProcessSteps(string bidId,list<Phoenix_Bid_Process_Steps__c> processStepLsit){
        Map<Integer,List<Phoenix_Bid_Process_Steps__c>> stepMap = new Map<Integer,List<Phoenix_Bid_Process_Steps__c>>();
        Map<String,List<Phoenix_Bid_Process_Steps__c>> stepNamesMap = new Map<String,List<Phoenix_Bid_Process_Steps__c>>();
        Map<String,Integer> stepnameNoMap = new Map<String,Integer>();
        for(Phoenix_Bid_Process_Steps__c step : processStepLsit){
            
            Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
            if(stepMap.get(stepNo) != null){
                List<Phoenix_Bid_Process_Steps__c> adededSteps = stepMap.get(stepNo);
                adededSteps.add(step);
                stepMap.put(stepNo,adededSteps);
            }else{
                stepMap.put(stepNo,new List<Phoenix_Bid_Process_Steps__c>{step});
            }
            
            String stepName = step.Phoenix_Approver_Team__c;
            if(stepName != null && stepNamesMap.get(stepName) != null){
                List<Phoenix_Bid_Process_Steps__c> adededSteps = stepNamesMap.get(stepName);
                adededSteps.add(step);
                stepNamesMap.put(stepName,adededSteps);
            }else if(stepName != null){
                stepNamesMap.put(stepName,new List<Phoenix_Bid_Process_Steps__c>{step});
            }
            stepnameNoMap.put(stepName, stepNo);
            
        }
       //start logic for all rejected case
        list<Phoenix_Bid_Line_Item__c> bidLinesUpdate=[select id,Phoenix_Final_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:bidId];
        boolean isAllRejectedCaseFound=true;
        for(Phoenix_Bid_Line_Item__c lineItem:bidLinesUpdate){
            if(lineItem.Phoenix_Final_Status__c!='Not Approved'){
                isAllRejectedCaseFound=false;
            }
        }
        if(isAllRejectedCaseFound){
            //close the bid other step not applicable
            integer currentStepNum=stepnameNoMap.get('Finance');
            for(Phoenix_Bid_Process_Steps__c prcsStep:processStepLsit){
                if(prcsStep.Phoenix_Approver_Team__c=='Finance' ){
                    prcsStep.Phoenix_Status__c='Completed';
                    prcsStep.Phoenix_Approver__c = userinfo.getuserid();                    
                }
                if(prcsStep.Phoenix_Step__c>currentStepNum){
                    if(prcsStep.Name.contains('Closed')){
                        prcsStep.Phoenix_Status__c='Completed';
                    }
                    else{prcsStep.Phoenix_Status__c='Not Applicable';}
                }
            }
            update processStepLsit;
            Phoenix_Bid__c bid=new Phoenix_Bid__c(id=bidId,Phoenix_Approval_Status__c='Closed');
            update bid;
        }
        else{
            List<Phoenix_Bid_Process_Steps__c> nextSteps = new List<Phoenix_Bid_Process_Steps__c>();
            if(stepnameNoMap != null && stepMap != null && stepnameNoMap.get('Finance') != null)
                nextSteps=stepMap.get(stepnameNoMap.get('Finance')+1);
            if(nextSteps != null){
               /* for(Phoenix_Bid_Process_Steps__c step : nextSteps){
                    step.Phoenix_Status__c = 'In Process';//'In Process' Submitted //Diff b/w them            
                }*/
                Integer stepNumber = stepnameNoMap.get('Finance');
                While(nextSteps != null && nextSteps[0].Phoenix_Status__c == 'Not Applicable'){
                    nextSteps=stepMap.get(++stepNumber);
                }
                nextSteps[0].Phoenix_Status__c = 'In Process';
            }
            
            if(nextSteps != null && !nextSteps.isEmpty()){
                update nextSteps;
                Phoenix_Bid__c bid=new Phoenix_Bid__c(id=bidId,Phoenix_Approval_Status__c=nextSteps[0].Phoenix_Approver_Team__c);
                update bid;
                Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId,nextSteps);
                //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bid.Name,nextSteps,'Bid_Approval');
            }
        }
    }
    
    
    public class Wrapper{
        @AuraEnabled public string productFamilyName;
        @AuraEnabled public string financeApproval;
        @AuraEnabled public string financeComments;
        @AuraEnabled public boolean finalApproval;
        @AuraEnabled public boolean isFinanceApprovePerson;        
        @AuraEnabled public List<decimal> dataList;
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        Wrapper(){
            dataList = new List<decimal>();
            bidRecord = new Phoenix_Bid__c();
            isFinanceApprovePerson=false;
        }
        
    }
}