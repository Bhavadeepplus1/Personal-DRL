public class Vision_Order_Status {
    @AuraEnabled
    public static wrapperClass getCustomerOrdersData(String recordId, String option,Date startDate,Date endDate,String selectedRange, List<String> selections, string searchText, string searchCustText, String selectedPageOption, String firstOrder, String lastOrder, Boolean isCancelledOrders){
        String selectedDateOn =selectedRange;
        Date startingDate = startDate;
        Date endingDate = endDate;
        String orderStatusListQuery = 'Select Vision_Product__r.Name,Vision_Product__r.Family, ' +Phoenix_Util.getsObjectFieds('Vision_GCP_SFDC_Order_Status__c')+' from Vision_GCP_SFDC_Order_Status__c WHERE ';
        String orderStatusListQuery2 = 'Select count(Id), SUM(Vision_Net_Amount__c), Vision_Order_Number__c from Vision_GCP_SFDC_Order_Status__c WHERE ';
        string conditionOrders;
        string conditionStatus;
        string selectionCondition;
        if(selectedRange == 'Vision_PO_Date__c'){
            if(startingDate != null && endingDate != null){
                conditionStatus = ' Vision_PO_Date__c >=: startingDate AND Vision_PO_Date__c <=: endingDate';
                orderStatusListQuery = orderStatusListQuery+conditionStatus;                
                orderStatusListQuery2 = orderStatusListQuery2+conditionStatus;
            }
        }
        else if(selectedRange == 'Vision_Order_Date__c'){
            if(startingDate != null && endingDate != null){
                conditionStatus = ' Vision_Order_Date__c >=: startingDate AND Vision_Order_Date__c <=: endingDate';
                orderStatusListQuery = orderStatusListQuery+conditionStatus;
                orderStatusListQuery2 = orderStatusListQuery2+conditionStatus;
            }
        }
        else if(selectedRange == 'Vision_Delivery_Date_Internal_Use__c'){
            if(startingDate != null && endingDate != null){
                conditionStatus = ' Vision_Delivery_Date_Internal_Use__c >=: startingDate AND  Vision_Delivery_Date_Internal_Use__c <=: endingDate';
                orderStatusListQuery = orderStatusListQuery+conditionStatus;
                orderStatusListQuery2 = orderStatusListQuery2+conditionStatus;
            }
        }
        else if(selectedRange == 'Vision_GCP_Ship_Date__c'){
            if(startingDate != null && endingDate != null){
                conditionStatus = ' Vision_GCP_Ship_Date__c >=: startingDate AND  Vision_GCP_Ship_Date__c <=: endingDate';
                orderStatusListQuery = orderStatusListQuery+conditionStatus;
                orderStatusListQuery2 = orderStatusListQuery2+conditionStatus;
            }
        }
        
        //List<Vision_GCP_SFDC_Order_Status__c> orderStatusList = Database.query(orderStatusListQuery);
        if(isCancelledOrders){
            String cancelled = 'CANCELLED';
            system.debug('Cancelled');
            orderStatusListQuery = orderStatusListQuery+' AND Vision_Order_Status__c =: cancelled';
            orderStatusListQuery2 = orderStatusListQuery2+' AND Vision_Order_Status__c =: cancelled';
        }
        
        String tempQuery = orderStatusListQuery2;
        
        if(String.isNotBlank(searchText)){
            String searchKey = '%' + searchText  + '%';
            system.debug('Search Text: '+searchkey);
            orderStatusListQuery = orderStatusListQuery+' AND (Vision_Product__r.Name like: searchKey OR Vision_PO_Number__c like: searchKey OR Vision_NDC_Code__c like: searchKey OR Vision_Order_Number__c like: searchKey)';
            orderStatusListQuery2 = orderStatusListQuery2+' AND (Vision_Product__r.Name like: searchKey OR Vision_PO_Number__c like: searchKey OR Vision_NDC_Code__c like: searchKey OR Vision_Order_Number__c like: searchKey)';
        }
        
        if(String.isNotBlank(searchCustText)){
            String searchCustKey = '%' + searchCustText  + '%';
            system.debug('Search Cust Text: '+searchCustKey);
            orderStatusListQuery = orderStatusListQuery+' AND (Vision_Sold_to_Customer_Name__c like: searchCustKey OR Vision_Sold_to_Customer_Code__c like: searchCustKey)';
            orderStatusListQuery2 = orderStatusListQuery2+' AND (Vision_Sold_to_Customer_Name__c like: searchCustKey OR Vision_Sold_to_Customer_Code__c like: searchCustKey)';
        }

        /*List<AggregateResult> results = new List<AggregateResult>();
        List<AggregateResult> tempResults = new List<AggregateResult>();
        Map<String, Decimal> mapOfOrders = new Map<String, Decimal>();

        tempResults = Database.query(orderStatusListQuery2 + ' GROUP BY Vision_Order_Number__c LIMIT 100');
        results.addAll(tempResults);
        while(tempResults.size() > 0){
            for(AggregateResult agg: tempResults){
                String orderNumber = String.valueOf(agg.get('Vision_Order_Number__c'));
                if(mapOfOrders.containsKey(orderNumber)){
                    Decimal count = mapOfOrders.get(orderNumber);
                    count += Decimal.valueOf(String.valueOf(agg.get('expr1')));
                    mapOfOrders.put(orderNumber, count);
                } else{
                    mapOfOrders.put(orderNumber, Decimal.valueOf(String.valueOf(agg.get('expr1'))));
                }
                totalAmount += Decimal.valueOf(String.valueOf(agg.get('expr1')));
                orderStatusList.add(orderNumber);   
            }   
            tempResults = Vision_Order_Status.getTotalCount(orderStatusListQuery2, mapOfOrders, startingDate, endingDate, conditionStatus, searchText, searchCustText);
        }*/
        
        List<Vision_GCP_SFDC_Order_Status__c> limitedOrdersList = new List<Vision_GCP_SFDC_Order_Status__c>(); 
        String stringToDisablePageButton;
        if(selectedPageOption == 'Next' && !String.isBlank(lastOrder)){
            Integer orderNumber = Integer.valueOf(lastOrder);   
            limitedOrdersList = Database.query(orderStatusListQuery+' AND Vision_Order_Number_Internal_Use__c >:orderNumber ORDER BY Vision_Order_Number__c LIMIT 1000');
            if(limitedOrdersList.size() == 0){
                limitedOrdersList = Database.query(orderStatusListQuery+' ORDER BY Vision_Order_Number__c DESC LIMIT 1000');      
                stringToDisablePageButton = 'disableNext';
            }
        } else if(selectedPageOption == 'Previous' && !String.isBlank(firstOrder)){
            Integer orderNumber = Integer.valueOf(firstOrder);   
            limitedOrdersList = Database.query(orderStatusListQuery+' AND Vision_Order_Number_Internal_Use__c <:orderNumber ORDER BY Vision_Order_Number__c LIMIT 1000');
            if(limitedOrdersList.size() == 0){
                limitedOrdersList = Database.query(orderStatusListQuery+' ORDER BY Vision_Order_Number__c LIMIT 1000');
                stringToDisablePageButton = 'disablePrevious';
            }
        } else if(selectedPageOption == 'First'){
            limitedOrdersList = Database.query(orderStatusListQuery+' ORDER BY Vision_Order_Number__c LIMIT 1000');       
        } else if(selectedPageOption == 'Last'){
            limitedOrdersList = Database.query(orderStatusListQuery+' ORDER BY Vision_Order_Number__c DESC LIMIT 1000');       
        }
        
                
        Map<String, Vision_GCP_SFDC_Order_Status__c> orderMap = new Map<String, Vision_GCP_SFDC_Order_Status__c>();
        for(Vision_GCP_SFDC_Order_Status__c order: limitedOrdersList){
            if(!orderMap.containsKey(order.Vision_Order_Number__c)){
                orderMap.put(order.Vision_Order_Number__c, order);
            }
        }
        
        
        cus_ord_trend_dates_info__c  cotdi = cus_ord_trend_dates_info__c.getInstance('Data1');
        wrapperClass wrapObj = new wrapperClass();
        
        wrapObj.orderStatusListQuery = tempQuery;
        wrapObj.stringToDisablePageButton = stringToDisablePageButton;
        if(cotdi!= null){
            system.debug('Vision Updated Datetime: '+cotdi.Vision_Updated_DateTime__c);
            wrapObj.GCPUpdateDate = cotdi.Vision_GCP_Update_DateTime__c;
            wrapObj.VisionUpdateDate = cotdi.Vision_Updated_DateTime__c;
            wrapObj.SAPUpdateDate = cotdi.SAP_Created_DateTime__c;
        }
        wrapObj.orderMap = orderMap;
        return wrapObj;
    }
    
    @AuraEnabled
    public static wrapperClass getTotalOrdersCount(String query, Decimal totalAmount, Map<String, Decimal> mapOfOrders, Date startingDate, Date endingDate, String searchKey, string searchCustKey, String tabName){
        system.debug('Query: '+query);
        system.debug('totalAmount: '+totalAmount);
        system.debug('startingDate: '+startingDate);
        system.debug('endingDate: '+endingDate);
        system.debug('searchText: '+searchKey);
        system.debug('searchCustText: '+searchCustKey);
        system.debug('Map Of Orders: '+mapOfOrders);
        List<String> orderStatusList = new List<String>();
        Map<String, Decimal> mapData = new Map<String, Decimal>();
        Boolean yes;
        String cancelled;
        String cancelledOrder;
        if(tabName == 'Delayed'){
            yes = true;
            cancelledOrder = 'CANCELLED';
        } else if(tabName == 'CANCELLED'){
            cancelled = tabName;
        }
        if(totalAmount == null){
            totalAmount = 0;
        }
        if(String.isNotBlank(searchKey)){
            String searchText = '%' + searchKey  + '%';
            system.debug('Search Text: '+searchText);
            query = query+' AND (Vision_Product__r.Name like: searchText OR Vision_PO_Number__c like: searchText OR Vision_NDC_Code__c like: searchText OR Vision_Order_Number__c like: searchText)';
            query = query+' AND (Vision_Product__r.Name like: searchText OR Vision_PO_Number__c like: searchText OR Vision_NDC_Code__c like: searchText OR Vision_Order_Number__c like: searchText)';
        }
        
        if(String.isNotBlank(searchCustKey)){
            String searchCustText = '%' + searchCustKey  + '%';
            system.debug('Search Cust Text: '+searchCustText);
            query = query+' AND (Vision_Sold_to_Customer_Name__c like: searchCustText OR Vision_Sold_to_Customer_Code__c like: searchCustText)';
            query = query+' AND (Vision_Sold_to_Customer_Name__c like: searchCustText OR Vision_Sold_to_Customer_Code__c like: searchCustText)';
        }
        
        if(mapOfOrders == null){
            system.debug('Size is 0');
            AggregateResult[] results = Database.query(query + ' GROUP BY Vision_Order_Number__c LIMIT 500');
            system.debug('Results Size: '+results.size());
            if(results.size() > 0){
                for(AggregateResult agg: results){
                    String orderNumber = String.valueOf(agg.get('Vision_Order_Number__c'));
                    mapData.put(orderNumber, Decimal.valueOf(String.valueOf(agg.get('expr1'))));
                    system.debug('agg: '+agg.get('expr1'));
                    //decimalList.add(agg.get('expr1'));
                    totalAmount += Decimal.valueOf(String.valueOf(agg.get('expr1')));
                    orderStatusList.add(orderNumber);   
                }   
                mapOfOrders = mapData;
            }
        } else{
            system.debug('Size > 0');
            List<String> keys = new List<String>();
            keys.addAll(mapOfOrders.keySet());
            AggregateResult[] results = Database.query(query + ' AND Vision_Order_Number__c NOT IN:keys GROUP BY Vision_Order_Number__c LIMIT 500');
            if(results.size() > 0){
                for(AggregateResult agg: results){
                    String orderNumber = String.valueOf(agg.get('Vision_Order_Number__c'));
                    if(mapOfOrders.containsKey(orderNumber)){
                        Decimal count = mapOfOrders.get(orderNumber);
                        count += Decimal.valueOf(String.valueOf(agg.get('expr1')));
                        mapOfOrders.put(orderNumber, count);
                    } else{
                        mapOfOrders.put(orderNumber, Decimal.valueOf(String.valueOf(agg.get('expr1'))));
                    }
                    totalAmount += Decimal.valueOf(String.valueOf(agg.get('expr1')));
                    orderStatusList.add(orderNumber);   
                }   
            }   
        }
        wrapperClass wrapObj = new wrapperClass();
        wrapObj.mapOfOrders = mapOfOrders;
        wrapObj.totalAmount = totalAmount;
        //List<AggregateResult> tempResults = Database.query(orderStatusListQuery2 + ' AND Vision_Order_Number__c NOT IN:listOfOrders GROUP BY Vision_Order_Number__c LIMIT 100');
        return wrapObj;
    }

    @AuraEnabled
    public static wrapperClass getOrderDataOutlook(string searchText){
        String orderStatusListQuery = 'Select Vision_Product__r.Name,Vision_Product__r.Family, ' +Phoenix_Util.getsObjectFieds('Vision_GCP_SFDC_Order_Status__c')+' from Vision_GCP_SFDC_Order_Status__c WHERE ';
        
        if(String.isNotBlank(searchText)){
            String searchKey = '%' + searchText  + '%';
            system.debug('Search Text: '+searchkey);
            orderStatusListQuery = orderStatusListQuery+' (Vision_PO_Number__c like: searchKey OR Vision_Order_Number__c like: searchKey)';
        }
        
        List<Vision_GCP_SFDC_Order_Status__c> limitedOrdersList = Database.query(orderStatusListQuery);
                
        Map<String, List<Vision_GCP_SFDC_Order_Status__c>> orderMap = new Map<String, List<Vision_GCP_SFDC_Order_Status__c>>();
        for(Vision_GCP_SFDC_Order_Status__c order: limitedOrdersList){
            if(!orderMap.containsKey(order.Vision_Order_Number__c)){
                orderMap.put(order.Vision_Order_Number__c, new List<Vision_GCP_SFDC_Order_Status__c> {order});
            } else{
                List<Vision_GCP_SFDC_Order_Status__c> tempList = orderMap.get(order.Vision_Order_Number__c);
                tempList.add(order);
                orderMap.put(order.Vision_Order_Number__c, tempList);
            }
        }
        
        
        cus_ord_trend_dates_info__c  cotdi = cus_ord_trend_dates_info__c.getInstance('Data1');
        wrapperClass wrapObj = new wrapperClass();
        
        //wrapObj.finalMap = finalMap;
        //wrapObj.finalMapTotal = finalMapTotal;
        //wrapObj.orderStatusList = orderStatusList;
        //wrapObj.orderStatusListFinal = orderStatusListFinal;
        wrapObj.orderStatusListQuery = orderStatusListQuery;
        if(cotdi!= null){
            wrapObj.GCPUpdateDate = cotdi.Vision_GCP_Update_DateTime__c;
            wrapObj.VisionUpdateDate = cotdi.Vision_Updated_DateTime__c;
            wrapObj.SAPUpdateDate = cotdi.SAP_Created_DateTime__c;
        }
        wrapObj.outlookOrderMap = orderMap;
        return wrapObj;
    }    
    /*@AuraEnabled
    public static wrapperClass getIntitalOrders(Boolean isAsc, string sortField, Integer lmt, Integer ofst){
        //accountId = '0011K00002RDd8EQAT'; //For testing, removing it later
        //Phoenix_Contract__c contract = [SELECT Id, Phoenix_Contract_Number__c, Phoenix_Contract_Start_Date__c, Phoenix_Contract_End_Date__c FROM Phoenix_Contract__c WHERE Id =: contractId];
        wrapperClass wrapObj = new wrapperClass();
        string ascDesc = isAsc ? 'ASC' : 'DESC';
        string awarded = 'Awarded';
        Boolean yes = true;
        Boolean no = false;
        String Direct = 'Direct';
        //List<Vision_Customer_Product_Tracker__c> trackerData = [SELECT Id, Vision_Contract_Number__c, Name, Is_Initial_Order__c, Customer_Response_Line__r.Phoenix_Awarded_Quantity__c, Vision_NPR_Data__r.Phoenix_Dead_Net_Tracking_GR__c, Vision_NPR_Data__r.Phoenix_Price_Effective_Value_From__c, Vision_NPR_Data__r.Phoenix_Price_Effective_Value_To__c, Vision_NPR_Data__r.Phoenix_Contract_Type__c, Vision_Product__r.Name, Vision_Contract__r.Name FROM Vision_Customer_Product_Tracker__c WHERE Vision_Contract__c =: contractId AND Vision_Account__c =: accountId ORDER BY Vision_Product__r.Name];
        string query1 = 'SELECT Id, Vision_Contract_Number__c, Name, Vision_PO_Number__c, Vision_Order_Quantity__c,Vision_Contract_Product_Status__c, Vision_Product__r.Phoenix_NDC_11__c, Bid_Line_Item__r.Phoenix_Initial_Stocking_Order_Volume__c, Customer_Response_Line__r.Phoenix_Supply_Effective_Date__c, Vision_Awarded_Volume__c, Vision_Awarded_Price__c, Vision_Internal_DeadNet__c, Is_Initial_Order__c, Customer_Response_Line__r.Phoenix_Awarded_Quantity__c, Vision_NPR_Data__r.Phoenix_Dead_Net_Tracking_GR__c, Vision_NPR_Data__r.Phoenix_Price_Effective_Value_From__c, Vision_NPR_Data__r.Phoenix_Price_Effective_Value_To__c, Vision_NPR_Data__r.Phoenix_Contract_Type__c, Vision_Product__r.Name, Vision_Contract__r.Name, Vision_Contract__r.Id FROM Vision_Customer_Product_Tracker__c WHERE Vision_Awarded_Date__c = LAST_N_MONTHS:12 AND Vision_Contract_Product_Status__c =:awarded AND Is_Initial_Order__c=: yes AND Vision_NPR_Data__r.Phoenix_Contract_Type__c =: Direct ORDER BY '+sortField+' '+ascDesc; // AND Vision_Contract_Product_Status__c =: awarded
        string query2 = 'SELECT Id, Vision_Contract_Number__c, Name, Vision_PO_Number__c, Vision_Order_Quantity__c,Vision_Contract_Product_Status__c, Vision_Product__r.Phoenix_NDC_11__c, Bid_Line_Item__r.Phoenix_Initial_Stocking_Order_Volume__c, Customer_Response_Line__r.Phoenix_Supply_Effective_Date__c, Vision_Awarded_Volume__c, Vision_Awarded_Price__c, Vision_Internal_DeadNet__c, Is_Initial_Order__c, Customer_Response_Line__r.Phoenix_Awarded_Quantity__c, Vision_NPR_Data__r.Phoenix_Dead_Net_Tracking_GR__c, Vision_NPR_Data__r.Phoenix_Price_Effective_Value_From__c, Vision_NPR_Data__r.Phoenix_Price_Effective_Value_To__c, Vision_NPR_Data__r.Phoenix_Contract_Type__c, Vision_Product__r.Name, Vision_Contract__r.Name, Vision_Contract__r.Id FROM Vision_Customer_Product_Tracker__c WHERE Vision_Awarded_Date__c = LAST_N_MONTHS:12 AND Vision_Contract_Product_Status__c =:awarded AND Is_Initial_Order__c=: no AND Vision_NPR_Data__r.Phoenix_Contract_Type__c =: Direct ORDER BY '+sortField+' '+ascDesc; // AND Vision_Contract_Product_Status__c =: awarded
        List<Vision_Customer_Product_Tracker__c> initialOrderList = Database.query(query1);
        List<Vision_Customer_Product_Tracker__c> nonInitialOrderList = Database.query(query2);
        List<Vision_Customer_Product_Tracker__c> limitedInitialOrderList = Database.query(query1+' LIMIT '+lmt+' OFFSET '+ofst);
        List<Vision_Customer_Product_Tracker__c> limitedNonInitialOrderList = Database.query(query2+' LIMIT '+lmt+' OFFSET '+ofst);
        wrapObj.initialOrderList = initialOrderList;
        wrapObj.nonInitialOrderList = nonInitialOrderList;
        wrapObj.limitedInitialOrderList = limitedInitialOrderList;
        wrapObj.limitedNonInitialOrderList = limitedNonInitialOrderList;
        //wrapObj.contract = contract;
        return wrapObj;
    }*/
    
    @AuraEnabled
    public static wrapperClass getOTIFData(String recordId, Date startDate,Date endDate,String selectedRange,string searchText, string searchCustText, String selectedPageOption, String firstOrder, String lastOrder){
        String selectedDateOn =selectedRange;
        Date startingDate = startDate;
        Date endingDate = endDate;
        String orderStatusListQuery = 'Select Vision_Product__r.Name,Vision_Product__r.Family, ' +Phoenix_Util.getsObjectFieds('Vision_GCP_SFDC_Order_Status__c')+' from Vision_GCP_SFDC_Order_Status__c WHERE ';
        String orderStatusListQuery2 = 'Select count(Id), SUM(Vision_Net_Amount__c), Vision_Order_Number__c from Vision_GCP_SFDC_Order_Status__c WHERE ';
        string conditionStatus;
        string selectionCondition = 'Vision_Is_OTIF__c = true';
        if(selectedRange == 'Vision_PO_Date__c'){
            if(startingDate != null && endingDate != null){
                conditionStatus = ' Vision_PO_Date__c >=: startingDate AND Vision_PO_Date__c <=: endingDate AND Vision_Delivery_Date_Internal_Use__c!=null';
                
                orderStatusListQuery = orderStatusListQuery+conditionStatus+' AND ('+selectionCondition+')'; 
                orderStatusListQuery2 = orderStatusListQuery2+conditionStatus+' AND ('+selectionCondition+')'; 
            }
        }
        else if(selectedRange == 'Vision_Order_Date__c'){
            if(startingDate != null && endingDate != null){
                conditionStatus = ' Vision_Order_Date__c >=: startingDate AND  Vision_Order_Date__c <=: endingDate AND Vision_Delivery_Date_Internal_Use__c!=null';
                orderStatusListQuery = orderStatusListQuery+conditionStatus+' AND ('+selectionCondition+')';
                orderStatusListQuery2 = orderStatusListQuery2+conditionStatus+' AND ('+selectionCondition+')'; 
            }
        }
        else if(selectedRange == 'Vision_Delivery_Date_Internal_Use__c'){
            if(startingDate != null && endingDate != null){
                conditionStatus = ' Vision_Delivery_Date_Internal_Use__c >=: startingDate AND  Vision_Delivery_Date_Internal_Use__c <=: endingDate AND Vision_Delivery_Date_Internal_Use__c!=null';
                orderStatusListQuery = orderStatusListQuery+conditionStatus+' AND ('+selectionCondition+')';
                orderStatusListQuery2 = orderStatusListQuery2+conditionStatus+' AND ('+selectionCondition+')'; 
            }
        }
        else if(selectedRange == 'Vision_GCP_Ship_Date__c'){
            if(startingDate != null && endingDate != null){
                conditionStatus = ' Vision_GCP_Ship_Date__c >=: startingDate AND  Vision_GCP_Ship_Date__c <=: endingDate AND Vision_Delivery_Date_Internal_Use__c!=null';
                orderStatusListQuery = orderStatusListQuery+conditionStatus+' AND ('+selectionCondition+')';
                orderStatusListQuery2 = orderStatusListQuery2+conditionStatus+' AND ('+selectionCondition+')'; 
            }
        }
        String tempQuery = orderStatusListQuery2;
        
        if(String.isNotBlank(searchText)){
            String searchKey = '%' + searchText  + '%';
            orderStatusListQuery = orderStatusListQuery+' AND (Vision_Product__r.Name like: searchKey OR Vision_PO_Number__c like: searchKey OR Vision_NDC_Code__c like: searchKey OR Vision_Order_Number__c like: searchKey)';
            orderStatusListQuery2 = orderStatusListQuery2+' AND (Vision_Product__r.Name like: searchKey OR Vision_PO_Number__c like: searchKey OR Vision_NDC_Code__c like: searchKey OR Vision_Order_Number__c like: searchKey)';
        }
        
        if(String.isNotBlank(searchCustText)){
            String searchCustKey = '%' + searchCustText  + '%';
            orderStatusListQuery = orderStatusListQuery+' AND (Vision_Sold_to_Customer_Name__c like: searchCustKey OR Vision_Sold_to_Customer_Code__c like: searchCustKey)';
            orderStatusListQuery2 = orderStatusListQuery2+' AND (Vision_Sold_to_Customer_Name__c like: searchCustKey OR Vision_Sold_to_Customer_Code__c like: searchCustKey)';
        }
        
        /*List<String> orderStatusList = new List<String>();
        AggregateResult[] results = Database.query(orderStatusListQuery2 + ' GROUP BY Vision_Order_Number__c LIMIT 30000');
        Decimal totalAmount = 0;
        if(results.size() > 0){
            for(AggregateResult agg: results){
                system.debug('agg: '+agg.get('expr1'));
                String orderNumber = String.valueOf(agg.get('Vision_Order_Number__c'));
                //decimalList.add(agg.get('expr1'));
                totalAmount += Decimal.valueOf(String.valueOf(agg.get('expr1')));
                orderStatusList.add(orderNumber);   
            }   
        }*/
        
        List<Vision_GCP_SFDC_Order_Status__c> limitedOrdersList = new List<Vision_GCP_SFDC_Order_Status__c>();
        String stringToDisablePageButton;
        if(selectedPageOption == 'Next' && !String.isBlank(lastOrder)){
            Integer orderNumber = Integer.valueOf(lastOrder);   
            limitedOrdersList = Database.query(orderStatusListQuery+' AND Vision_Order_Number_Internal_Use__c >:orderNumber ORDER BY Vision_Order_Number__c LIMIT 1000');
            if(limitedOrdersList.size() == 0){
                limitedOrdersList = Database.query(orderStatusListQuery+' ORDER BY Vision_Order_Number__c DESC LIMIT 1000');      
                stringToDisablePageButton = 'disableNext';
            }
        } else if(selectedPageOption == 'Previous' && !String.isBlank(firstOrder)){
            Integer orderNumber = Integer.valueOf(firstOrder);   
            limitedOrdersList = Database.query(orderStatusListQuery+' AND Vision_Order_Number_Internal_Use__c <:orderNumber ORDER BY Vision_Order_Number__c LIMIT 1000');
            if(limitedOrdersList.size() == 0){
                limitedOrdersList = Database.query(orderStatusListQuery+' ORDER BY Vision_Order_Number__c LIMIT 1000');
                stringToDisablePageButton = 'disablePrevious';
            }
        } else if(selectedPageOption == 'First'){
            limitedOrdersList = Database.query(orderStatusListQuery+' ORDER BY Vision_Order_Number__c LIMIT 1000');       
        } else if(selectedPageOption == 'Last'){
            limitedOrdersList = Database.query(orderStatusListQuery+' ORDER BY Vision_Order_Number__c DESC LIMIT 1000');       
        }
        
        Map<String, Vision_GCP_SFDC_Order_Status__c> orderMap = new Map<String, Vision_GCP_SFDC_Order_Status__c>();
        for(Vision_GCP_SFDC_Order_Status__c order: limitedOrdersList){
            if(!orderMap.containsKey(order.Vision_Order_Number__c)){
                orderMap.put(order.Vision_Order_Number__c, order);
            }
        }
        
        cus_ord_trend_dates_info__c  cotdi = cus_ord_trend_dates_info__c.getInstance('Data1');
        wrapperClass wrapObj = new wrapperClass();
        
        
        //wrapObj.finalMap = finalMap;
        //wrapObj.finalMapTotal = finalMapTotal;
        //wrapObj.orderStatusList = orderStatusList;
        //wrapObj.orderStatusListFinal = orderStatusListFinal;
        wrapObj.stringToDisablePageButton = stringToDisablePageButton;
        if(cotdi!= null){
            wrapObj.GCPUpdateDate = cotdi.Vision_GCP_Update_DateTime__c;
            wrapObj.VisionUpdateDate = cotdi.Vision_Updated_DateTime__c;
            wrapObj.SAPUpdateDate = cotdi.SAP_Created_DateTime__c;
        }
        wrapObj.orderStatusListQuery = tempQuery;
        wrapObj.orderMap = orderMap;
        /*wrapObj.totalOrders = orderStatusList.size();
        wrapObj.totalAmount = totalAmount;*/
        return wrapObj;
        
    }
    
    
    @AuraEnabled
    public static wrapperClass getDelayedOrderData(String recordId, Date startDate,Date endDate,String selectedRange,string searchText, string searchCustText, boolean openDelayed, String selectedPageOption, String firstOrder, String lastOrder){
        String selectedDateOn =selectedRange;
        Date startingDate = startDate;
        Date endingDate = endDate;
        String orderStatusListQuery = 'Select Vision_Product__r.Name,Vision_Product__r.Family, ' +Phoenix_Util.getsObjectFieds('Vision_GCP_SFDC_Order_Status__c')+' from Vision_GCP_SFDC_Order_Status__c WHERE Vision_Order_Status__c !=:cancelledOrder AND';
        String orderStatusListQuery2 = 'Select count(Id), SUM(Vision_Net_Amount__c), Vision_Order_Number__c from Vision_GCP_SFDC_Order_Status__c WHERE Vision_Order_Status__c !=:cancelledOrder AND';
        string conditionStatus;
        String cancelledOrder = 'CANCELLED';
        if(selectedRange == 'Vision_PO_Date__c'){
            if(startingDate != null && endingDate != null && openDelayed){
                conditionStatus = ' Vision_PO_Date__c >=: startingDate AND Vision_PO_Date__c <=: endingDate AND Vision_PO_Date__c!=null AND Vision_Delivery_Date_Internal_Use__c!=null';
                orderStatusListQuery = orderStatusListQuery+conditionStatus;
                orderStatusListQuery2 = orderStatusListQuery2+conditionStatus;
            }
            else if(startingDate != null && endingDate != null && !openDelayed){
                conditionStatus = ' Vision_PO_Date__c >=: startingDate AND Vision_PO_Date__c <=: endingDate AND Vision_PO_Date__c!=null AND Vision_Delivery_Date_Internal_Use__c=null';
                orderStatusListQuery = orderStatusListQuery+conditionStatus; 
                orderStatusListQuery2 = orderStatusListQuery2+conditionStatus;
            }
            
        }
        else if(selectedRange == 'Vision_Order_Date__c'){
            if(startingDate != null && endingDate != null && openDelayed){
                conditionStatus = ' Vision_Order_Date__c >=: startingDate AND  Vision_Order_Date__c <=: endingDate AND Vision_Order_Date__c!=null AND Vision_Delivery_Date_Internal_Use__c!=null';
                orderStatusListQuery = orderStatusListQuery+conditionStatus;
                orderStatusListQuery2 = orderStatusListQuery2+conditionStatus;
            }
            else if(startingDate != null && endingDate != null && !openDelayed){
                conditionStatus = ' Vision_Order_Date__c >=: startingDate AND  Vision_Order_Date__c <=: endingDate AND Vision_Order_Date__c!=null AND Vision_Delivery_Date_Internal_Use__c=null';
                orderStatusListQuery = orderStatusListQuery+conditionStatus;
                orderStatusListQuery2 = orderStatusListQuery2+conditionStatus;
            }
        }
        else if(selectedRange == 'Vision_Delivery_Date_Internal_Use__c'){
            if(startingDate != null && endingDate != null && openDelayed ){
                conditionStatus = ' Vision_Delivery_Date_Internal_Use__c >=: startingDate AND  Vision_Delivery_Date_Internal_Use__c <=: endingDate AND Vision_Delivery_Date_Internal_Use__c!=null';
                orderStatusListQuery = orderStatusListQuery+conditionStatus;
                orderStatusListQuery2 = orderStatusListQuery2+conditionStatus;
            }
            else if(startingDate != null && endingDate != null && !openDelayed){
                conditionStatus = ' Vision_Delivery_Date_Internal_Use__c >=: startingDate AND  Vision_Delivery_Date_Internal_Use__c <=: endingDate AND Vision_Delivery_Date_Internal_Use__c=null ';
                orderStatusListQuery = orderStatusListQuery+conditionStatus;
                orderStatusListQuery2 = orderStatusListQuery2+conditionStatus;
                
                
            }
        }
        else if(selectedRange == 'Vision_GCP_Ship_Date__c'){
            if(startingDate != null && endingDate != null && openDelayed){
                conditionStatus = ' Vision_GCP_Ship_Date__c >=: startingDate AND  Vision_GCP_Ship_Date__c <=: endingDate AND Vision_GCP_Ship_Date__c!=null AND Vision_Delivery_Date_Internal_Use__c!=null';
                orderStatusListQuery = orderStatusListQuery+conditionStatus;
                orderStatusListQuery2 = orderStatusListQuery2+conditionStatus;
            }
            else if(startingDate != null && endingDate != null && !openDelayed){
                conditionStatus = ' Vision_GCP_Ship_Date__c >=: startingDate AND  Vision_GCP_Ship_Date__c <=: endingDate AND Vision_GCP_Ship_Date__c!=null AND Vision_Delivery_Date_Internal_Use__c=null';
                orderStatusListQuery = orderStatusListQuery+conditionStatus;
                orderStatusListQuery2 = orderStatusListQuery2+conditionStatus;
            }
        }
                
        Boolean yes = true;
        if(openDelayed){
            orderStatusListQuery = orderStatusListQuery+' AND Vision_Is_Delivered_and_Delayed__c=:yes';
            orderStatusListQuery2 = orderStatusListQuery2+' AND Vision_Is_Delivered_and_Delayed__c=:yes';
        } else{
            orderStatusListQuery = orderStatusListQuery+' AND Vision_Is_Open_and_Delayed__c=:yes';
            orderStatusListQuery2 = orderStatusListQuery2+' AND Vision_Is_Open_and_Delayed__c=:yes';
        }
        
        String tempQuery = orderStatusListQuery2;
        
        if(String.isNotBlank(searchText)){
            String searchKey = '%' + searchText  + '%';
            orderStatusListQuery = orderStatusListQuery+' AND (Vision_Product__r.Name like: searchKey OR Vision_PO_Number__c like: searchKey OR Vision_NDC_Code__c like: searchKey OR Vision_Order_Number__c like: searchKey)';
            orderStatusListQuery2 = orderStatusListQuery2+' AND (Vision_Product__r.Name like: searchKey OR Vision_PO_Number__c like: searchKey OR Vision_NDC_Code__c like: searchKey OR Vision_Order_Number__c like: searchKey)';
        }
        
        if(String.isNotBlank(searchCustText)){
            String searchCustKey = '%' + searchCustText  + '%';
            orderStatusListQuery = orderStatusListQuery+' AND (Vision_Sold_to_Customer_Name__c like: searchCustKey OR Vision_Sold_to_Customer_Code__c like: searchCustKey)';
            orderStatusListQuery2 = orderStatusListQuery2+' AND (Vision_Sold_to_Customer_Name__c like: searchCustKey OR Vision_Sold_to_Customer_Code__c like: searchCustKey)';
        }
        /*List<String> orderStatusList = new List<String>();
        AggregateResult[] results = Database.query(orderStatusListQuery2 + ' GROUP BY Vision_Order_Number__c LIMIT 2000');
        Decimal totalAmount = 0;
        if(results.size() > 0){
            for(AggregateResult agg: results){
                system.debug('agg: '+agg.get('expr1'));
                String orderNumber = String.valueOf(agg.get('Vision_Order_Number__c'));
                //decimalList.add(agg.get('expr1'));
                totalAmount += Decimal.valueOf(String.valueOf(agg.get('expr1')));
                orderStatusList.add(orderNumber);   
            }   
        }*/
        List<Vision_GCP_SFDC_Order_Status__c> limitedOrdersList = new List<Vision_GCP_SFDC_Order_Status__c>();
        String stringToDisablePageButton;
        if(selectedPageOption == 'Next' && !String.isBlank(lastOrder)){
            Integer orderNumber = Integer.valueOf(lastOrder);   
            limitedOrdersList = Database.query(orderStatusListQuery+' AND Vision_Order_Number_Internal_Use__c >:orderNumber ORDER BY Vision_Order_Number__c LIMIT 1000');
            if(limitedOrdersList.size() == 0){
                limitedOrdersList = Database.query(orderStatusListQuery+' ORDER BY Vision_Order_Number__c DESC LIMIT 1000');      
                stringToDisablePageButton = 'disableNext';
            }
        } else if(selectedPageOption == 'Previous' && !String.isBlank(firstOrder)){
            Integer orderNumber = Integer.valueOf(firstOrder);   
            limitedOrdersList = Database.query(orderStatusListQuery+' AND Vision_Order_Number_Internal_Use__c <:orderNumber ORDER BY Vision_Order_Number__c LIMIT 1000');
            if(limitedOrdersList.size() == 0){
                limitedOrdersList = Database.query(orderStatusListQuery+' ORDER BY Vision_Order_Number__c LIMIT 1000');
                stringToDisablePageButton = 'disablePrevious';
            }
        } else if(selectedPageOption == 'First'){
            limitedOrdersList = Database.query(orderStatusListQuery+' ORDER BY Vision_Order_Number__c LIMIT 1000');       
        } else if(selectedPageOption == 'Last'){
            limitedOrdersList = Database.query(orderStatusListQuery+' ORDER BY Vision_Order_Number__c DESC LIMIT 1000');       
        }
        
        Map<String, Vision_GCP_SFDC_Order_Status__c> orderMap = new Map<String, Vision_GCP_SFDC_Order_Status__c>();
        for(Vision_GCP_SFDC_Order_Status__c order: limitedOrdersList){
            if(!orderMap.containsKey(order.Vision_Order_Number__c)){
                orderMap.put(order.Vision_Order_Number__c, order);
            }
        }
        cus_ord_trend_dates_info__c  cotdi = cus_ord_trend_dates_info__c.getInstance('Data1');
        wrapperClass wrapObj = new wrapperClass();
        
        //wrapObj.totalOrders = orderStatusList.size();
        wrapObj.stringToDisablePageButton = stringToDisablePageButton;
        //wrapObj.orderStatusListFinal = orderStatusListFinal;
        if(cotdi!= null){
            wrapObj.GCPUpdateDate = cotdi.Vision_GCP_Update_DateTime__c;
            wrapObj.VisionUpdateDate = cotdi.Vision_Updated_DateTime__c;
            wrapObj.SAPUpdateDate = cotdi.SAP_Created_DateTime__c;
        }
        wrapObj.orderStatusListQuery = tempQuery;
        wrapObj.orderMap = orderMap;
        //wrapObj.totalAmount = totalAmount;
        return wrapObj;
    }
    
    @AuraEnabled
    public static List<Vision_GCP_SFDC_Order_Status__c> getRelatedOrders(String tabName, String orderNumber, String recordId, Date startDate,Date endDate,String selectedRange,string searchText, String searchCustText, boolean openDelayed, Boolean isCancelledOrders){
        String selectedDateOn =selectedRange;
        Date startingDate = startDate; 
        Date endingDate = endDate;
        String orderStatusListQuery = 'Select Vision_Product__r.Name,Vision_Product__r.Family, ' +Phoenix_Util.getsObjectFieds('Vision_GCP_SFDC_Order_Status__c')+' from Vision_GCP_SFDC_Order_Status__c WHERE Vision_Order_Number__c=:orderNumber AND';
        string conditionStatus;
        String cancelledOrder = 'CANCELLED';
        if(tabName == 'OpenDelayed'){
            if(selectedRange == 'Vision_PO_Date__c'){
                if(startingDate != null && endingDate != null && openDelayed){
                    conditionStatus = ' Vision_Order_Status__c !=:cancelledOrder AND Vision_PO_Date__c >=: startingDate AND Vision_PO_Date__c <=: endingDate AND Vision_PO_Date__c!=null AND Vision_Delivery_Date_Internal_Use__c!=null';
                    orderStatusListQuery = orderStatusListQuery+conditionStatus;
                }
                else if(startingDate != null && endingDate != null && !openDelayed){
                    conditionStatus = ' Vision_Order_Status__c !=:cancelledOrder AND Vision_PO_Date__c >=: startingDate AND Vision_PO_Date__c <=: endingDate AND Vision_PO_Date__c!=null AND Vision_Delivery_Date_Internal_Use__c=null';
                    orderStatusListQuery = orderStatusListQuery+conditionStatus; 
                }
                
            }
            else if(selectedRange == 'Vision_Order_Date__c'){
                if(startingDate != null && endingDate != null && openDelayed){
                    conditionStatus = ' Vision_Order_Status__c !=:cancelledOrder AND Vision_Order_Date__c >=: startingDate AND  Vision_Order_Date__c <=: endingDate AND Vision_Order_Date__c!=null AND Vision_Delivery_Date_Internal_Use__c!=null';
                    orderStatusListQuery = orderStatusListQuery+conditionStatus;
                }
                else if(startingDate != null && endingDate != null && !openDelayed){
                    conditionStatus = ' Vision_Order_Status__c !=:cancelledOrder AND Vision_Order_Date__c >=: startingDate AND  Vision_Order_Date__c <=: endingDate AND Vision_Order_Date__c!=null AND Vision_Delivery_Date_Internal_Use__c=null';
                    orderStatusListQuery = orderStatusListQuery+conditionStatus;
                }
            }
            else if(selectedRange == 'Vision_Delivery_Date_Internal_Use__c'){
                if(startingDate != null && endingDate != null && openDelayed ){
                    conditionStatus = ' Vision_Order_Status__c !=:cancelledOrder AND Vision_Delivery_Date_Internal_Use__c >=: startingDate AND  Vision_Delivery_Date_Internal_Use__c <=: endingDate AND Vision_Delivery_Date_Internal_Use__c!=null';
                    orderStatusListQuery = orderStatusListQuery+conditionStatus;
                }
                else if(startingDate != null && endingDate != null && !openDelayed){
                    conditionStatus = ' Vision_Order_Status__c !=:cancelledOrder AND Vision_Delivery_Date_Internal_Use__c >=: startingDate AND  Vision_Delivery_Date_Internal_Use__c <=: endingDate AND Vision_Delivery_Date_Internal_Use__c=null ';
                    orderStatusListQuery = orderStatusListQuery+conditionStatus;
                    
                    
                }
            }
            else if(selectedRange == 'Vision_GCP_Ship_Date__c'){
                if(startingDate != null && endingDate != null && openDelayed){
                    conditionStatus = ' Vision_Order_Status__c !=:cancelledOrder AND Vision_GCP_Ship_Date__c >=: startingDate AND  Vision_GCP_Ship_Date__c <=: endingDate AND Vision_GCP_Ship_Date__c!=null AND Vision_Delivery_Date_Internal_Use__c!=null';
                    orderStatusListQuery = orderStatusListQuery+conditionStatus;
                }
                else if(startingDate != null && endingDate != null && !openDelayed){
                    conditionStatus = ' Vision_Order_Status__c !=:cancelledOrder AND Vision_GCP_Ship_Date__c >=: startingDate AND  Vision_GCP_Ship_Date__c <=: endingDate AND Vision_GCP_Ship_Date__c!=null AND Vision_Delivery_Date_Internal_Use__c=null';
                    orderStatusListQuery = orderStatusListQuery+conditionStatus;
                }
            }   
        } 
        else if (tabName == 'OTIF'){
            string selectionCondition = 'Vision_Is_OTIF__c = true';
            if(selectedRange == 'Vision_PO_Date__c'){
                if(startingDate != null && endingDate != null){
                    conditionStatus = ' Vision_PO_Date__c >=: startingDate AND Vision_PO_Date__c <=: endingDate AND Vision_Delivery_Date_Internal_Use__c!=null';
                    
                    orderStatusListQuery = orderStatusListQuery+conditionStatus+' AND ('+selectionCondition+')'; 
                }
            }
            else if(selectedRange == 'Vision_Order_Date__c'){
                if(startingDate != null && endingDate != null){
                    conditionStatus = ' Vision_Order_Date__c >=: startingDate AND  Vision_Order_Date__c <=: endingDate AND Vision_Delivery_Date_Internal_Use__c!=null';
                    orderStatusListQuery = orderStatusListQuery+conditionStatus+' AND ('+selectionCondition+')';
                }
            }
            else if(selectedRange == 'Vision_Delivery_Date_Internal_Use__c'){
                if(startingDate != null && endingDate != null){
                    conditionStatus = ' Vision_Delivery_Date_Internal_Use__c >=: startingDate AND  Vision_Delivery_Date_Internal_Use__c <=: endingDate AND Vision_Delivery_Date_Internal_Use__c!=null';
                    orderStatusListQuery = orderStatusListQuery+conditionStatus+' AND ('+selectionCondition+')';
                }
            }
            else if(selectedRange == 'Vision_GCP_Ship_Date__c'){
                if(startingDate != null && endingDate != null){
                    conditionStatus = ' Vision_GCP_Ship_Date__c >=: startingDate AND  Vision_GCP_Ship_Date__c <=: endingDate AND Vision_Delivery_Date_Internal_Use__c!=null';
                    orderStatusListQuery = orderStatusListQuery+conditionStatus+' AND ('+selectionCondition+')';
                }
            }
        } 
        else if(tabName == 'Analysis'){
            string conditionOrders;
            if(selectedRange == 'Vision_PO_Date__c'){
                if(startingDate != null && endingDate != null){
                    conditionStatus = ' Vision_PO_Date__c >=: startingDate AND Vision_PO_Date__c <=: endingDate';
                    orderStatusListQuery = orderStatusListQuery+conditionStatus;                
                }
            }
            else if(selectedRange == 'Vision_Order_Date__c'){
                if(startingDate != null && endingDate != null){
                    conditionStatus = ' Vision_Order_Date__c >=: startingDate AND  Vision_Order_Date__c <=: endingDate';
                    orderStatusListQuery = orderStatusListQuery+conditionStatus;
                }
            }
            else if(selectedRange == 'Vision_Delivery_Date_Internal_Use__c'){
                if(startingDate != null && endingDate != null){
                    conditionStatus = ' Vision_Delivery_Date_Internal_Use__c >=: startingDate AND  Vision_Delivery_Date_Internal_Use__c <=: endingDate';
                    orderStatusListQuery = orderStatusListQuery+conditionStatus;
                }
            }
            else if(selectedRange == 'Vision_GCP_Ship_Date__c'){
                if(startingDate != null && endingDate != null){
                    conditionStatus = ' Vision_GCP_Ship_Date__c >=: startingDate AND  Vision_GCP_Ship_Date__c <=: endingDate';
                    orderStatusListQuery = orderStatusListQuery+conditionStatus;
                }
            }
        }
        if(String.isNotBlank(searchText)){
            String searchKey = '%' + searchText  + '%';
            orderStatusListQuery = orderStatusListQuery+' AND (Vision_Product__r.Name like: searchKey OR Vision_PO_Number__c like: searchKey OR Vision_NDC_Code__c like: searchKey OR Vision_Order_Number__c like: searchKey)';
        }
        
        if(String.isNotBlank(searchCustText)){
            String searchCustKey = '%' + searchCustText  + '%';
            orderStatusListQuery = orderStatusListQuery+' AND (Vision_Sold_to_Customer_Name__c like: searchCustKey OR Vision_Sold_to_Customer_Code__c like: searchCustKey)';
        }
        if(isCancelledOrders){
            orderStatusListQuery = orderStatusListQuery+' AND Vision_Order_Status__c =: cancelledOrder';
        }
        List<Vision_GCP_SFDC_Order_Status__c> orderStatusList = Database.query(orderStatusListQuery+' ORDER BY Vision_NDC_Code__c');
        return orderStatusList;
    }
    @AuraEnabled
    public static List<Vision_GCP_SFDC_Order_Status__c> getRelatedOrdersOutlook(String orderNumber,string searchText){
        String orderStatusListQuery = 'Select Vision_Product__r.Name,Vision_Product__r.Family, ' +Phoenix_Util.getsObjectFieds('Vision_GCP_SFDC_Order_Status__c')+' from Vision_GCP_SFDC_Order_Status__c WHERE Vision_Order_Number__c=:orderNumber AND';

        if(String.isNotBlank(searchText)){
            String searchKey = '%' + searchText  + '%';
            orderStatusListQuery = orderStatusListQuery+' (Vision_Product__r.Name like: searchKey OR Vision_PO_Number__c like: searchKey OR Vision_NDC_Code__c like: searchKey OR Vision_Order_Number__c like: searchKey)';
        }
        List<Vision_GCP_SFDC_Order_Status__c> orderStatusList = Database.query(orderStatusListQuery+' ORDER BY Vision_NDC_Code__c');
        return orderStatusList;
    }

    
    @AuraEnabled
    public static List<GCP_Comment__c> updateInitialOrderComments(String comment, Vision_Customer_Product_Tracker__c record){
        if(comment == null || comment == ''){  
        } else{
            GCP_Comment__c gcpCommentRec = new GCP_Comment__c();
            gcpCommentRec.Vision_Contract__c = record.Vision_Contract__c;
            gcpCommentRec.Account__c = record.Vision_Account__c;
            gcpCommentRec.Product__c = record.Vision_Product__c;
            gcpCommentRec.Comment__c = comment;
            gcpCommentRec.Vision_Customer_Product_Tracker__c = record.Id;
            gcpCommentRec.Comment_Date__c = system.now();
            upsert gcpCommentRec; 
        }
        return [SELECT Comment__c, Comment_Date__c, CreatedBy.Name, CreatedBy.SmallPhotoUrl FROM GCP_Comment__c WHERE Vision_Customer_Product_Tracker__c =: record.Id ORDER BY Comment_Date__c DESC];
    }
    
    public class wrapperClass{
        @AuraEnabled public Map<String, Decimal> mapOfOrders;
        @AuraEnabled public Map<String, Map<String, List<Vision_GCP_SFDC_Order_Status__c>>> finalMap;
        @AuraEnabled public Map<String, Map<String, List<Vision_GCP_SFDC_Order_Status__c>>> finalMapTotal;
        @AuraEnabled public  List<Vision_GCP_SFDC_Order_Status__c> orderStatusListFinal;
        @AuraEnabled public  List<Vision_GCP_SFDC_Order_Status__c> orderStatusList;
        @AuraEnabled public Integer totalOrders;
        @AuraEnabled public Decimal totalAmount;
        @AuraEnabled public Integer totalCount;
        @AuraEnabled public String stringToDisablePageButton;
        @AuraEnabled public String GCPUpdateDate;
        @AuraEnabled public String VisionUpdateDate;
        @AuraEnabled public String SAPUpdateDate;
        @AuraEnabled public String orderStatusListQuery;
        @AuraEnabled public List<Vision_Customer_Product_Tracker__c> initialOrderList;
        @AuraEnabled public List<Vision_Customer_Product_Tracker__c> nonInitialOrderList;
        @AuraEnabled public List<Vision_Customer_Product_Tracker__c> limitedInitialOrderList;
        @AuraEnabled public List<Vision_Customer_Product_Tracker__c> limitedNonInitialOrderList;
        @AuraEnabled public Phoenix_Contract__c contract;
        @AuraEnabled public Map<String, Vision_GCP_SFDC_Order_Status__c> orderMap;
        @AuraEnabled public Map<String, List<Vision_GCP_SFDC_Order_Status__c>> outlookOrderMap;
    }
    
}