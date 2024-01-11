public class Phoenix_OTC_Lowest_Price_Batch implements Database.Batchable < sObject > , Schedulable {
    public void execute(SchedulableContext sc) {
        
        Database.executeBatch(new Phoenix_OTC_Lowest_Price_Batch(), 100);
        
        
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        //  List<Id> pross = new List<Id>();
        // pross.add('01t0m0000052I8zAAE');
        // pross.add('01t0m000005DGJSAA4'); 
        String productList = 'SELECT ' + Phoenix_Util.getsObjectFieds('Product2') + 'FROM Product2 WHERE IsActive=TRUE AND (Phoenix_Is_Private_Label_OTC__c = true OR Phoenix_Is_Control_Label__c = true)';
        
        if (Test.isRunningTest()) productList += ' Limit 1';
        return Database.getQueryLocator(productList);
    }
    public void execute(Database.BatchableContext BC, List < Product2 > productList) {
        //     try {
        Product2 p = productList[0];
        String pfamily = p.Product_Family__c;
        Decimal pPkgsize =p.Phoenix_Pkg_Size__c;
        String pStrength = p.Phoenix_Strength__c;
        List < Product2 > prodList =  Database.query('SELECT ' + Phoenix_Util.getsObjectFieds('Product2') + 'FROM Product2 WHERE IsActive=TRUE AND (Phoenix_Is_Private_Label_OTC__c = true OR Phoenix_Is_Control_Label__c = true) AND Product_Family__c =: pfamily AND Phoenix_Pkg_Size__c =: pPkgsize AND Phoenix_Strength__c =: pStrength');
        Decimal lowValue = 0.00;
        Set < String > prodIds = new Set < String > ();
        
        for (Product2 prod: prodList) {
            prodIds.add(prod.Id);
        }
        Map < String, List < Phoenix_NPR_Data__c >> productWithNPRMap = new Map < String, List < Phoenix_NPR_Data__c >> ();
        Map < String, List <Product2 >> prodMap = new Map < String, List <Product2 >> ();
        Map < String, Decimal> lowestPriceMap = new Map < String, Decimal> ();
        Map < Id, Product2 > updatedProdMap = new Map < Id, Product2 > ();
        // Set < Id > prodIdSet = new Set < Id > ();
        
        
        List < Phoenix_NPR_Data__c > nprList = [SELECT Id, Phoenix_Product__c,Phoenix_Product__r.Product_Family__c,Phoenix_Product__r.Product_Family__r.name,Phoenix_Product__r.Phoenix_Strength__c,Phoenix_Product__r.Phoenix_Pkg_Size__c,Phoenix_Product__r.Phoenix_New_Product_Lowest_Price__c,Phoenix_Product__r.Phoenix_Is_New_Product__c, Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c,Phoenix_Product__r.Phoenix_OTC_Lowest_Price__c, Phoenix_Contract__c, Phoenix_Dead_Net_Tracking_GR__c FROM Phoenix_NPR_Data__c WHERE
                                                Phoenix_NPR_Status__c = 'Active' AND
                                                Phoenix_Contract__r.Phoenix_Contract_Status__c = 'Active'
                                                AND
                                                Phoenix_Contract__r.Phoenix_Is_Exclusion_Contract__c = false 
                                                AND  Phoenix_Product__c IN: prodIds
                                               ];
        
        //NPR Map
        for (Phoenix_NPR_Data__c npr: nprList) {
            String uniqueStrNpr = npr.Phoenix_Product__r.Product_Family__r.name + '-' + npr.Phoenix_Product__r.Phoenix_Strength__c + '-' + Integer.valueOf(npr.Phoenix_Product__r.Phoenix_Pkg_Size__c);
            if (productWithNPRMap.get(uniqueStrNpr) == null) {
                productWithNPRMap.put(uniqueStrNpr, new List < Phoenix_NPR_Data__c > {
                    npr
                        });
            }
            else {
                List < Phoenix_NPR_Data__c > nprs = productWithNPRMap.get(uniqueStrNpr);
                nprs.add(npr);
                productWithNPRMap.put(uniqueStrNpr, nprs);
            }
            
        }
        
        //Product Map 
        for (Product2 pro: prodList) {
            String uniqueStrPro = pro.Family + '-' + pro.Phoenix_Strength__c + '-' + Integer.valueOf(pro.Phoenix_Pkg_Size__c);
            if (prodMap.get(uniqueStrPro) == null) {
                prodMap.put(uniqueStrPro, new List < Product2 > {
                    pro
                        });
            }
            else {
                List < Product2 > pros = prodMap.get(uniqueStrPro);
                pros.add(pro);
                prodMap.put(uniqueStrPro, pros);
            }
            
        }
        for(String nprIdentifier: productWithNPRMap.keyset()){
            for (Phoenix_NPR_Data__c npr: productWithNPRMap.get(nprIdentifier)) {
                if (lowValue == 0.00) {
                    lowValue = npr.Phoenix_Dead_Net_Tracking_GR__c;
                } 
                else if (lowValue > npr.Phoenix_Dead_Net_Tracking_GR__c) {
                    lowValue = npr.Phoenix_Dead_Net_Tracking_GR__c;
                }
                
            }
            lowestPriceMap.put(nprIdentifier,lowValue);
           }
        for(String proIdentifier:prodMap.keyset()){
            for(Product2 pro:prodMap.get(proIdentifier)){
                //updatedProdMap.put(pro.Id, new Product2(Id = pro.Id, Phoenix_Lowest_Price_SKU__c = lowestPriceMap.get(proIdentifier)));
                updatedProdMap.put(pro.Id, new Product2(Id = pro.Id, Phoenix_OTC_Lowest_Price__c = lowestPriceMap.get(proIdentifier)));
            }
        }
         if (!updatedProdMap.isEmpty()) 
         update updatedProdMap.values();
        //  }
        //   Catch(Exception e) {
        //       Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_OTC_Lowest_Price_Batch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
        //       insert exp;
        //   }
    }
    
    public void finish(Database.BatchableContext BC) {}
}