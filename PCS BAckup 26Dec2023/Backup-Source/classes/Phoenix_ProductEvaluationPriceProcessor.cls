/*
 *  @description       : To get Opty Miss Evaluation Price for a Product
 * It is a batch process to update lowest Price at Product Level on monthly basis
 * Lowest price is the least value among the top 3 customers based on 12 Months Sales Unit*/

public class Phoenix_ProductEvaluationPriceProcessor implements Database.Batchable < sObject > , Schedulable {

    //schedule controller
    public void execute(SchedulableContext sc) {
        database.executeBatch(new Phoenix_ProductEvaluationPriceProcessor(), 500);
    }


    public Database.QueryLocator start(Database.BatchableContext BC) {
        String productListFromSF = 'SELECT ' + Phoenix_Util.getsObjectFieds('Product2') + ' FROM Product2 WHERE IsActive=TRUE';
        if (Test.isRunningTest()) productListFromSF += ' Limit 1';
        return Database.getQueryLocator(productListFromSF);
    }
    public void execute(Database.BatchableContext BC, List < Product2 > prodList) {
        try {
            List < Product2 > updateProdList = new List < Product2 > ();
            List < String > twelveMonthsSalesUnitList = new List < String > ();
            Map < String, String > DeadNetTrackgGrWithSalesUnitMap = new Map < String, String > ();
            Map < Id, List < Phoenix_NPR_Data__c >> productWithNPRMap = new Map < Id, List < Phoenix_NPR_Data__c >> ();
            List < Phoenix_NPR_Data__c > nprList = [SELECT Id, Phoenix_Product__c, Phoenix_Dead_Net_Tracking_GR__c, Phoenix_12Months_Sales_Unit__c FROM Phoenix_NPR_Data__c WHERE Phoenix_Indirect_Customers__c != TRUE AND Phoenix_Contract__r.Phoenix_Is_Govt_Customer__c != TRUE AND Phoenix_Contract__r.Phoenix_Contract_Status__c = 'Active'];
            //   List<Phoenix_NPR_Data__c> nprList= [SELECT Id,Phoenix_Product__c,Phoenix_Dead_Net_Tracking_GR__c,Phoenix_12Months_Sales_Unit__c FROM Phoenix_NPR_Data__c WHERE Phoenix_Contract__r.Phoenix_Contract_Status__c='Active' AND Phoenix_Indirect_Customers__c=FALSE AND Phoenix_Contract__r.Phoenix_Is_Govt_Customer__c= FALSE];

            for (Phoenix_NPR_Data__c npr: nprList) {
                if (String.isNotBlank(npr.Phoenix_Product__c)) {
                    if (productWithNPRMap.containsKey(npr.Phoenix_Product__c)) {
                        List < Phoenix_NPR_Data__c > existingNpr = productWithNPRMap.get(npr.Phoenix_Product__c);
                        existingNpr.add(npr);
                        productWithNPRMap.put(npr.Phoenix_Product__c, existingNpr);
                    } else {
                        productWithNPRMap.put(npr.Phoenix_Product__c, new List < Phoenix_NPR_Data__c > {
                            npr
                        });
                    }
                }
            }

            for (Id prodId: productWithNPRMap.keySet()) {

                for (Phoenix_NPR_Data__c npr: productWithNPRMap.get(prodId)) {
                    if (npr.Phoenix_Dead_Net_Tracking_GR__c == null) {
                        //  npr.Phoenix_12Months_Sales_Unit__c=0.00;
                        npr.Phoenix_Dead_Net_Tracking_GR__c = 0.00;
                    }
                    string twelveMonths = string.valueOf(npr.Phoenix_12Months_Sales_Unit__c);
                    string deadNet = string.valueOf(npr.Phoenix_Dead_Net_Tracking_GR__c);
                    if (npr.Phoenix_12Months_Sales_Unit__c != 0.00 || npr.Phoenix_12Months_Sales_Unit__c != 0) {
                        twelveMonthsSalesUnitList.add(twelveMonths + ',' + deadNet);
                    }

                    DeadNetTrackgGrWithSalesUnitMap.put(twelveMonths + ',' + deadNet, deadNet);

                }
                twelveMonthsSalesUnitList.sort();
                List < String > SortedtwelveMtsSalesUnitList = new List < String > ();
                List < String > TopThreeCustList = new List < String > ();
                for (Integer i = twelveMonthsSalesUnitList.size() - 1; i >= 0; i--) {
                    SortedtwelveMtsSalesUnitList.add(twelveMonthsSalesUnitList.get(i));
                }
                if (SortedtwelveMtsSalesUnitList.size() >= 3) {
                    TopThreeCustList.add(SortedtwelveMtsSalesUnitList[0]);
                    TopThreeCustList.add(SortedtwelveMtsSalesUnitList[1]);
                    TopThreeCustList.add(SortedtwelveMtsSalesUnitList[2]);
                } else if (SortedtwelveMtsSalesUnitList.size() == 2) {
                    TopThreeCustList.add(SortedtwelveMtsSalesUnitList[0]);
                    TopThreeCustList.add(SortedtwelveMtsSalesUnitList[1]);
                } else if (SortedtwelveMtsSalesUnitList.size() == 1) {
                    TopThreeCustList.add(SortedtwelveMtsSalesUnitList[0]);
                }

                if (!TopThreeCustList.isEmpty()) {
                    Decimal lowValue = 0;
                    for (String d: TopThreeCustList) {
                        String deadNetValue = DeadNetTrackgGrWithSalesUnitMap.get(d);
                        Decimal DeadNetPrice = Decimal.valueOf(deadNetValue);
                        if (lowValue == 0) {
                            lowValue = DeadNetPrice;
                        } else if (lowValue > DeadNetPrice) {
                            lowValue = DeadNetPrice;
                        }
                    }

                    updateProdList.add(new Product2(Id = prodId, Phoenix_Opty_Miss_Evaluation_Price__c = lowValue));
                    twelveMonthsSalesUnitList.clear();
                }
            }
            if (!updateProdList.isEmpty()) {
                update updateProdList;
            }
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_ProductEvaluationPriceProcessor', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;

        }
    }
    public void finish(Database.BatchableContext BC) {}
}