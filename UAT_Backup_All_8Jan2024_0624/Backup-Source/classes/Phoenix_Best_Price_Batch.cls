/**
 * @description       : 
 * @author            : Surender Dhruvsoft
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Dhruvsoft
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   25-05-2021   Surender Dhruvsoft   Initial Version
 **/
public class Phoenix_Best_Price_Batch implements Database.Batchable < sObject > , Database.Stateful, Schedulable {

    public void execute(SchedulableContext sc) {

        Database.executeBatch(new Phoenix_Best_Price_Batch(), 200);


    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT ProductCode, Phoenix_Customer_for_best_price__c,Phoenix_Previous_Customer_for_best_price__c,Phoenix_Best_Price__c,Phoenix_Notify_best_price_Change__c,Phoenix_Contract_for_Best_Price__c FROM Product2 where Phoenix_Type__c = \'NDA\' and Phoenix_Track_Best_price__c = True';
        if (Test.isRunningTest()) query += ' Limit 1';
        return Database.getQueryLocator(query);

    }
    public void execute(Database.BatchableContext BC, List < Product2 > productList) {
        try {
            List < Product2 > updateProdList = new List < Product2 > ();
            Map < String, Product2 > prodIdMap = new Map < String, Product2 > ();
            for (Product2 p: productList) prodIdMap.put(p.Id, p);

            set < String > productIds = new set < String > ();
            for (Product2 prod: productList) {
                productIds.add(prod.Id);
            }
            List < Phoenix_NPR_Data__c > nprData = [Select Phoenix_Net_Price_w_o_fee_CD__c, Phoenix_GR_HighTier_in__c, Phoenix_Account__c, Phoenix_Material_Number__c, Phoenix_Contract__r.Phoenix_Ignore_for_Best_price__c, Phoenix_Contract__r.Phoenix_Contract_Number__c, Phoenix_Contract_Number__c, Phoenix_Product__c, Phoenix_Account__r.Name
                From Phoenix_NPR_Data__c where Phoenix_Product__c IN: productIds and Phoenix_Contract__r.Phoenix_Ignore_for_Best_price__c = false
            ];
            Map < String, List < Phoenix_NPR_Data__c >> prodNPRAll = new Map < String, List < Phoenix_NPR_Data__c >> ();

            for (Phoenix_NPR_Data__c npr: nprData) {
                if (prodNPRAll.get(npr.Phoenix_Product__c) == null) {
                    prodNPRAll.put(npr.Phoenix_Product__c, new List < Phoenix_NPR_Data__c > {
                        npr
                    });
                } else {
                    List < Phoenix_NPR_Data__c > nprs = prodNPRAll.get(npr.Phoenix_Product__c);
                    nprs.add(npr);
                    prodNPRAll.put(npr.Phoenix_Product__c, nprs);
                }
            }

            for (String prodId: prodNPRAll.keySet()) {
                Product2 prodObj = prodIdMap.get(prodId);
                Decimal min;
                String contractNo = ' ';
                String customerName = ' ';


                for (Phoenix_NPR_Data__c npr: prodNPRAll.get(prodId)) {
                    Decimal netPrice = npr.Phoenix_Net_Price_w_o_fee_CD__c != null ? npr.Phoenix_Net_Price_w_o_fee_CD__c : 0;
                    Decimal grHigh = npr.Phoenix_GR_HighTier_in__c != null ? npr.Phoenix_GR_HighTier_in__c : 0;
                    Decimal price = netPrice - grHigh;
                    if (min == null) {
                        min = price;
                        contractNo = npr.Phoenix_Contract_Number__c;
                        customerName = npr.Phoenix_Account__r.Name;
                        system.debug('contract number' + contractNo);
                    } else if (price <= min) {
                        if (price == min) {
                            min = price;
                            contractNo += ',' + npr.Phoenix_Contract_Number__c;
                            if (npr.Phoenix_Account__c != null) customerName += ',' + npr.Phoenix_Account__r.Name;
                            system.debug('contract number' + contractNo);

                        } else {
                            min = price;
                            contractNo = npr.Phoenix_Contract_Number__c;
                            customerName = npr.Phoenix_Account__r.Name;
                            system.debug('contract number' + contractNo);


                        }
                    }

                }
                if (prodObj.Phoenix_Best_Price__c != min) {
                    prodObj.Phoenix_Notify_best_price_Change__c = true;
                    prodObj.Phoenix_Previous_Best_Price__c = prodObj.Phoenix_Best_Price__c;
                    prodObj.Phoenix_Best_Price__c = min;
                    prodObj.Phoenix_Previous_Contract_for_Best_Price__c = prodObj.Phoenix_Contract_for_Best_Price__c;
                    prodObj.Phoenix_Contract_for_Best_Price__c = contractNo;
                    prodObj.Phoenix_Previous_Customer_for_best_price__c = prodObj.Phoenix_Customer_for_best_price__c;
                    prodObj.Phoenix_Customer_for_best_price__c = customerName;

                    updateProdList.add(prodObj);
                }
            }

            system.debug('product list' + updateProdList);

            update updateProdList;
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_Best_Price_Batch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
    public void finish(Database.BatchableContext BC) {

    }

}