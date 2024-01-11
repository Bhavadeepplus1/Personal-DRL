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
public class Phoenix_Price_Change_Batch implements Database.Batchable < sObject > , Database.Stateful, Schedulable {

    public void execute(SchedulableContext sc) {
        Database.executeBatch(new Phoenix_Price_Change_Batch(), 200);
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT ProductCode, Phoenix_Tracking_Customer__c,Phoenix_Tracking_Customer_price__c,Phoenix_Notify_Tracking_Customer_price__c,Phoenix_Contract_for_Tracking_Customer__c FROM Product2 where Phoenix_Tracking_Customer__c != null and Phoenix_Contract_for_Tracking_Customer__c!=null ';
        if (Test.isRunningTest()) query += ' Limit 1';
        return Database.getQueryLocator(query);

    }
    public void execute(Database.BatchableContext BC, List < Product2 > productList) {
        try{

        List < Product2 > updateProdList = new List < Product2 > ();

        Map < String, Product2 > prodIdMap = new Map < String, Product2 > ();
        for (Product2 p: productList) prodIdMap.put(p.Id, p);

        set < String > productIds = new set < String > ();
        set < String > acccIds = new set < String > ();
        set < String > contractIds = new set < String > ();

        for (Product2 prod: productList) {
            productIds.add(prod.Id);
            if (prod.Phoenix_Tracking_Customer__c != null) acccIds.add(prod.Phoenix_Tracking_Customer__c);
            if (prod.Phoenix_Contract_for_Tracking_Customer__c != null) contractIds.add(prod.Phoenix_Contract_for_Tracking_Customer__c);
        }
        List < Phoenix_NPR_Data__c > nprData = [Select Phoenix_Net_Price_w_o_Fees__c, Phoenix_Account__c, Phoenix_Material_Number__c, Phoenix_Product__c, Phoenix_Contract__r.Phoenix_Contract_Number__c, Phoenix_Contract_Number__c, Phoenix_Contract__c
            From Phoenix_NPR_Data__c where Phoenix_Account__c IN: acccIds AND Phoenix_Product__c IN: productIds AND Phoenix_Contract__c IN: contractIds
        ];

        system.debug('npr' + nprData);

        // Map<Customer-ProdCode-contract,List<NPR>>

        Map < String, List < Phoenix_NPR_Data__c >> customerProdContractNprMap = new Map < String, List < Phoenix_NPR_Data__c >> ();


        for (Phoenix_NPR_Data__c npr: nprData) {
            String uniqueStr = npr.Phoenix_Account__c + '-' + npr.Phoenix_Product__c + '_' + npr.Phoenix_Contract__c;
            if (customerProdContractNprMap.get(uniqueStr) == null) {
                customerProdContractNprMap.put(uniqueStr, new List < Phoenix_NPR_Data__c > {
                    npr
                });
            }
            /*else{
                            List<Phoenix_NPR_Data__c> nprs = customerProdContractNprMap.get(uniqueStr);
                            nprs.add(npr);
                            customerProdContractNprMap.put(uniqueStr,nprs);
                        }*/
        }
        system.debug('npr records' + customerProdContractNprMap);


        Set < String > requiredUniques = new Set < String > ();
        for (Product2 prod: productList) requiredUniques.add(prod.Phoenix_Tracking_Customer__c + '-' + prod.Id + '_' + prod.Phoenix_Contract_for_Tracking_Customer__c);
        Map < String, List < Phoenix_NPR_Data__c >> customerProdContractNprMapfinal = new Map < String, List < Phoenix_NPR_Data__c >> ();
        for (String uniq: requiredUniques) customerProdContractNprMapfinal.put(uniq, customerProdContractNprMap.get(uniq));

        system.debug('npr records' + customerProdContractNprMapfinal);


        for (String nprUniq: customerProdContractNprMapfinal.keySet()) {
            String prodId = nprUniq.subStringAfter('-').subStringBefore('_');
            Product2 prodObj = prodIdMap.get(prodId);
            for (Phoenix_NPR_Data__c npr: customerProdContractNprMapfinal.get(nprUniq)) {
                Decimal price = npr.Phoenix_Net_Price_w_o_Fees__c;
                if (prodObj.Phoenix_Tracking_Customer_price__c != price) {
                    prodObj.Phoenix_Notify_Tracking_Customer_price__c = true;
                    prodObj.Phoenix_Previous_Tracking_Customer_price__c = prodObj.Phoenix_Tracking_Customer_price__c;
                    prodObj.Phoenix_Tracking_Customer_price__c = price;
                    updateProdList.add(prodObj);
                }

            }
        }

        system.debug('product list' + updateProdList);

        update updateProdList;
    }
       Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_Price_Change_Batch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
       }
 
    }
    public void finish(Database.BatchableContext BC) {}
}