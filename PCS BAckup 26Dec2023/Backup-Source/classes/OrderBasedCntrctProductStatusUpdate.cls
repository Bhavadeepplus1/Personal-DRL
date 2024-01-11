public class OrderBasedCntrctProductStatusUpdate implements Database.Batchable < sObject > , Database.Stateful, Schedulable{
    public void execute(SchedulableContext sc) {
        //Database.executeBatch(new OrderBasedCntrctProductStatusUpdate());
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        //String customer = '0017c00000n9vA4AAI';
        String query = 'Select Vision_Product__r.Name, ' +Phoenix_Util.getsObjectFieds('Vision_GCP_SFDC_Order_Status__c')+' from Vision_GCP_SFDC_Order_Status__c';
        //String query = 'Select Vision_Product__r.Name, ' +Phoenix_Util.getsObjectFieds('Vision_GCP_SFDC_Order_Status__c')+' from Vision_GCP_SFDC_Order_Status__c Where CreatedDate = LAST_N_DAYS:1';
        //String query = 'Select ' +Phoenix_Util.getsObjectFieds('Vision_GCP_Customer_Order_Trend__c')+' from Vision_GCP_Customer_Order_Trend__c WHERE Vision_Customer__c =:customer';
        if(Test.isRunningTest())query += ' LIMIT 1';
        return Database.getQueryLocator(query);
    }
   
    public void execute(Database.BatchableContext BC, List <Vision_GCP_SFDC_Order_Status__c> orderList) {
        try{
            if(orderList.size() > 0){
                Map<String, List<Vision_GCP_SFDC_Order_Status__c>> mapOfCustomerOrders = new Map<String, List<Vision_GCP_SFDC_Order_Status__c>>();
                for(Vision_GCP_SFDC_Order_Status__c order: orderList){
                    if(mapOfCustomerOrders.containsKey(order.Vision_Account__c)){
                        mapOfCustomerOrders.get(order.Vision_Account__c).add(order);
                        //mapOfCustomerOrders.put(order.Vision_Account__c,tempList);                        
                    } else{
                        mapOfCustomerOrders.put(order.Vision_Account__c, new List < Vision_GCP_SFDC_Order_Status__c > {
                            order
                                });
                    }
                }
                //String customer = '0017c00000n9vA4AAI';
                //List<Vision_Customer_Product_Tracker__c> trackList = [SELECT Id, Vision_Product_Code__c, Vision_Contract__r.Phoenix_Contract_Start_Date__c, Vision_Unique_Identifier__c,Vision_Current_Product_Position__c ,Vision_Contract__c, Vision_Account__c, Vision_NPR_Data__c  FROM Vision_Customer_Product_Tracker__c WHERE Vision_NPR_Data__r.Phoenix_Contract_Type__c = 'Direct' AND Vision_Account__c IN:mapOfCustomerOrders.keySet()];
                Map<String, Vision_Customer_Product_Tracker__c> mapOfRecords = new Map<String, Vision_Customer_Product_Tracker__c>();
                for(Vision_Customer_Product_Tracker__c track: [SELECT Id, Vision_Product_Code__c, Vision_Contract__r.Phoenix_Contract_Start_Date__c, Vision_Unique_Identifier__c,Vision_Current_Product_Position__c ,Vision_Contract__c, Vision_Account__c, Vision_NPR_Data__c  FROM Vision_Customer_Product_Tracker__c WHERE Vision_NPR_Data__r.Phoenix_Contract_Type__c = 'Direct' AND Vision_Account__c IN:mapOfCustomerOrders.keySet()]){
                    //List<Vision_GCP_SFDC_Order_Status__c> orders = mapOfCustomerOrders.get(track.Vision_Account__c);
                    if(mapOfCustomerOrders.containsKey(track.Vision_Account__c)){
                        for(Vision_GCP_SFDC_Order_Status__c order: mapOfCustomerOrders.get(track.Vision_Account__c)){
                            if(track.Vision_Product_Code__c == order.Vision_SKU_Code__c && track.Vision_Contract__r.Phoenix_Contract_Start_Date__c!= null && order.Vision_Order_Date__c !=null && track.Vision_Contract__r.Phoenix_Contract_Start_Date__c < order.Vision_Order_Date__c){
                                track.Is_Initial_Order__c = true;
                                track.Vision_Order_Quantity__c = order.Vision_Order_Quantity__c;
                                track.Vision_PO_Number__c = order.Vision_PO_Number__c;
                                mapOfRecords.put(track.Id, track);
                            }
                        }   
                    }
                }
                upsert mapOfRecords.values();
            }
            else{
              }
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'OrderBasedCntrctProductStatusUpdate', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
    public void finish(Database.BatchableContext BC) {
        
    }
}