/*
 * @description       : To get Lowest Price/ SKU for a Product
 * It is a batch process to update lowest Price/SKU at Product Level on daily basis
* Lowest price is the least value from the related NPR Line Items of the product*/

public class Phoenix_ProductSKUProcessor implements Database.Batchable < sObject > , Schedulable {
    
    //schedule controller
    public void execute(SchedulableContext sc) {
        database.executeBatch(new Phoenix_ProductSKUProcessor(), 100);
    }
    
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String productList = 'SELECT ' + Phoenix_Util.getsObjectFieds('Product2') + ' FROM Product2 WHERE IsActive=TRUE ';
        if (Test.isRunningTest()) productList += ' Limit 1';
        
        return Database.getQueryLocator(productList);
    }
    public void execute(Database.BatchableContext BC, List < Product2 > prodList) {
        try {
            Set < String > prodIds = new Set < String > ();
            
            for (Product2 prod: prodList) {
                prodIds.add(prod.Id);
            }
            
            system.debug('prodIds---------' + prodIds);
            Map < Id, List < Phoenix_NPR_Data__c >> productWithNPRMap = new Map < Id, List < Phoenix_NPR_Data__c >> ();
            Map < Id, Product2 > prodMap = new Map < Id, Product2 > ();
            Map < Id, Product2 > prodMapFuture = new Map < Id, Product2 > ();
            Map < Id, List < Phoenix_Future_NPR_Data__c >> productWithFutureNPRMap = new Map < Id, List < Phoenix_Future_NPR_Data__c >> ();
            Map < Id, Product2 > updatedProdMap = new Map < Id, Product2 > ();
            Set < Id > prodIdSet = new Set < Id > ();
            
            
            List < Phoenix_NPR_Data__c > nprList = [SELECT Id, Phoenix_Product__c,Phoenix_Product__r.Phoenix_New_Product_Lowest_Price__c,Phoenix_Product__r.Phoenix_Is_New_Product__c, Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c, Phoenix_Contract__c, Phoenix_Dead_Net_Tracking_GR__c FROM Phoenix_NPR_Data__c WHERE
                                                    Phoenix_NPR_Status__c = 'Active' AND
                                                    Phoenix_Contract__r.Phoenix_Contract_Status__c = 'Active'
                                                    AND
                                                    Phoenix_Indirect_Customers__c = false AND
                                                     Phoenix_Contract__r.Phoenix_Is_Exclusion_Contract__c = false AND 
                                                    Phoenix_Product__c IN: prodIds
                                                   ];
            
            List < Phoenix_Future_NPR_Data__c > futureNPRList = [SELECT Id, Phoenix_Product__c,Phoenix_Product__r.Phoenix_New_Product_Lowest_Price__c,Phoenix_Product__r.Phoenix_Is_New_Product__c, Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c, Phoenix_Contract__c, Phoenix_Dead_Net_Tracking_GR__c FROM Phoenix_Future_NPR_Data__c WHERE
                                                                 Phoenix_NPR_Status__c = 'Active' AND
                                                                 Phoenix_Contract__r.Phoenix_Contract_Status__c = 'Active'
                                                                 AND
                                                                 Phoenix_Indirect_Customers__c = false AND
                                                                  Phoenix_Contract__r.Phoenix_Is_Exclusion_Contract__c = false AND 
                                                                 Phoenix_Product__c IN: prodIds
                                                                ];
            system.debug('nprList---------' + nprList);
            system.debug('futureNPRList---------' + futureNPRList);
            for (Phoenix_Future_NPR_Data__c futureNPR: futureNPRList) {
                prodMap.put(futureNPR.Phoenix_Product__c, new Product2(
                    Id = futureNPR.Phoenix_Product__c,
                    Phoenix_New_Product_Lowest_Price__c = futureNPR.Phoenix_Product__r.Phoenix_New_Product_Lowest_Price__c,
                    Phoenix_Is_New_Product__c = futureNPR.Phoenix_Product__r.Phoenix_Is_New_Product__c,
                    Phoenix_Lowest_Price_SKU__c = futureNPR.Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c
                ));
                if (String.isNotBlank(futureNPR.Phoenix_Product__c)) {
                    if (productWithFutureNPRMap.containsKey(futureNPR.Phoenix_Product__c)) {
                        List < Phoenix_Future_NPR_Data__c > existingNpr = productWithFutureNPRMap.get(futureNPR.Phoenix_Product__c);
                        existingNpr.add(futureNPR);
                        productWithFutureNPRMap.put(futureNPR.Phoenix_Product__c, existingNpr);
                    } else {
                        productWithFutureNPRMap.put(futureNPR.Phoenix_Product__c, new List < Phoenix_Future_NPR_Data__c > {
                            futureNPR
                                });
                    }
                }
            } 
            for (Phoenix_NPR_Data__c npr: nprList) {
                prodMap.put(npr.Phoenix_Product__c, new Product2(
                    Id = npr.Phoenix_Product__c,
                    Phoenix_New_Product_Lowest_Price__c = npr.Phoenix_Product__r.Phoenix_New_Product_Lowest_Price__c,
                    Phoenix_Is_New_Product__c = npr.Phoenix_Product__r.Phoenix_Is_New_Product__c,
                    Phoenix_Lowest_Price_SKU__c = npr.Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c
                ));
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
            
            system.debug('prodMap---------' + prodMap);
            system.debug('productWithNPRMap---------' + productWithNPRMap);
            system.debug('productWithFutureNPRMap---------' + productWithFutureNPRMap);
            
            prodIdSet.addAll(productWithNPRMap.keySet());
            prodIdSet.addAll(productWithFutureNPRMap.keySet());
            system.debug('prodIdSet----'+prodIdSet);
            
            for (Id prodId: prodIdSet) {
                Product2 prod = prodMap.get(prodId);
                system.debug('Product---'+prod);
                Decimal lowValue = 0.00;
                
                if(productWithNPRMap.containsKey(prodId)){
                    for (Phoenix_NPR_Data__c npr: productWithNPRMap.get(prodId)) {
                        if (lowValue == 0.00) {
                            system.debug('Phoenix_Dead_Net_Tracking_GR__c-----'+npr.Phoenix_Dead_Net_Tracking_GR__c);
                            lowValue = npr.Phoenix_Dead_Net_Tracking_GR__c;
                            system.debug('lowValue----'+lowValue);
                        } 
                        else if (lowValue > npr.Phoenix_Dead_Net_Tracking_GR__c) {
                            system.debug('Phoenix_Dead_Net_Tracking_GR__c-----'+npr.Phoenix_Dead_Net_Tracking_GR__c);
                            lowValue = npr.Phoenix_Dead_Net_Tracking_GR__c;
                            system.debug('lowValue----'+lowValue);
                        }
                        
                    } 
                }
                system.debug('productWithFutureNPRMap product---'+productWithFutureNPRMap.get(prodId));
                if(productWithFutureNPRMap.containsKey(prodId)){
                    for (Phoenix_Future_NPR_Data__c futureNPR: productWithFutureNPRMap.get(prodId)) {
                        system.debug('low');
                        if (lowValue == 0.00) {
                            lowValue = futureNPR.Phoenix_Dead_Net_Tracking_GR__c;
                            system.debug('futureLowValue----'+lowValue);
                        } else if (lowValue > futureNPR.Phoenix_Dead_Net_Tracking_GR__c) {
                            lowValue = futureNPR.Phoenix_Dead_Net_Tracking_GR__c;
                            system.debug('futureLowValue----'+lowValue);
                        }
                    }   
                }
                if (prod.Phoenix_Is_New_Product__c) updatedProdMap.put(prodId, new Product2(Id = prodId, Phoenix_Lowest_Price_SKU__c = Prod.Phoenix_New_Product_Lowest_Price__c));
                else if (!prod.Phoenix_Is_New_Product__c) updatedProdMap.put(prodId,new Product2(Id = prodId, Phoenix_Lowest_Price_SKU__c = lowValue));
                
            }             
            
            
            
            system.debug('prodMapFuture----'+prodMapFuture);
            
            
            
            if (!updatedProdMap.isEmpty()) 
                
                update updatedProdMap.values();
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_ProductSKUProcessor', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
    public void finish(Database.BatchableContext BC) {}
}