/**
* @description       : Process NPR staging records received TODAY
* @author            : Surender Patel (Dhruvsoft)
* @group             : 
* @last modified on  : 15-07-2021
* @last modified by  : Surender Patel (Dhruvsoft)
* Modifications Log 
* Ver   Date         Author                       Modification
* 1.0   03-12-2020   Surender Patel (Dhruvsoft)   Initial Version
**/
public class Phoenix_NPRStagingProcessor implements Database.Batchable < sObject > , Database.Stateful, Schedulable {
    public Map < String, Product2 > newlyCreatedProdsMap = new Map < String, Product2 > ();
    public Decimal recordCount = 0;
    public Phoenix_NPRStagingProcessor() {}
    
    //schedule controller
    public void execute(SchedulableContext sc) {
        database.executeBatch(new Phoenix_NPRStagingProcessor(), 1);
    }
    
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT' + Phoenix_Util.sapNPRStagingFields + 'FROM Phoenix_SAP_NPR_Staging__c WHERE Phoenix_Is_Sync_Completed__c = false AND Phoenix_NPR_Report_Type__c =\'Current Active\'';
        if (Test.isRunningTest()) query += ' Limit 1';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List < Phoenix_SAP_NPR_Staging__c > nprStagingList) {
        try {
            /* 
* In case Product is not found, create the product and send information to contracts team
* Auto create contract based on NPR data
* Link the NPR Line items to contracts objects, products and customers
* In case customer is not found, create contract without customer. Put the customer name and code in 2 text fields "NPR Customer Name" and "NPR Customer Code" on the contracts object
* If Customer Code = 371033, then link the NPR record to the customer defined at the contract level.
*/
            //List<Product2> allProds = new List<Product2>();
            //List<Phoenix_Contract__c> updatedContracts = new List<Phoenix_Contract__c>();
            Map < String, Phoenix_NPR_Data__c > updatedNPRsMap = new Map < String, Phoenix_NPR_Data__c > ();
            
            Set < String > customerNos = new Set < String > ();
            Set < String > stagingProdCodes = new Set < String > ();
            Set < String > stagingContractNos = new Set < String > ();
            
            //NPRStagingMap
            Map < String, Phoenix_SAP_NPR_Staging__c > NPRStagingMap = new Map < String, Phoenix_SAP_NPR_Staging__c > ();
            for (Phoenix_SAP_NPR_Staging__c nprStaging: nprStagingList) {
                if (recordCount == 0) recordCount = nprStaging.Phoenix_Total_NPR_Lines__c;
                NPRStagingMap.put(nprStaging.Phoenix_NPR_Ref_SF__c, nprStaging);
                customerNos.add(nprStaging.Phoenix_Customer_Number__c);
                stagingProdCodes.add(nprStaging.Phoenix_Material_Number__c);
                stagingContractNos.add(nprStaging.Phoenix_Contract_Number__c);
                
            }
            
            //ExistingCustomersMap
            Map < String, Account > existingCustomersMap = new Map < String, Account > ();
            for (Account act: Database.query('SELECT' + Phoenix_Util.customerFields + 'FROM Account WHERE AccountNumber IN :customerNos'))
                existingCustomersMap.put(act.AccountNumber, act);
            
            //ExistingProdMap
            Map < String, Product2 > existingProdMap = new Map < String, Product2 > ();
            for (Product2 prod: Database.query('SELECT' + Phoenix_Util.productFields + 'FROM Product2 WHERE ProductCode IN :stagingProdCodes'))
                existingProdMap.put(prod.ProductCode, prod);
            
            //ExistingNPRMap
            Map < String, Phoenix_NPR_Data__c > existingNPRMap = new Map < String, Phoenix_NPR_Data__c > ();
            
            //ExistingContractsMap
            Map < String, Phoenix_Contract__c > existingContractsMap = new Map < String, Phoenix_Contract__c > ();
            for (Phoenix_Contract__c contr: Database.query('SELECT ' + Phoenix_Util.contractFields + ',(SELECT ' + Phoenix_Util.nprDataFields + ' FROM NPR_Master__r) FROM Phoenix_Contract__c WHERE Phoenix_Contract_Number__c IN :stagingContractNos')) {
                existingContractsMap.put(contr.Phoenix_Contract_Number__c, contr);
                for (Phoenix_NPR_Data__c npr: contr.NPR_Master__r) existingNPRMap.put(npr.Phoenix_NPR_Ref_SF__c, npr);
            }


            //Check and create products if needed
            Map < String, Product2 > proMap = new Map < String, Product2 > ();
            List < Product2 > newProds = new List < Product2 > ();
            for (Phoenix_SAP_NPR_Staging__c nprStaging: nprStagingList) {
                
                if (!ExistingProdMap.containsKey(nprStaging.Phoenix_Material_Number__c)) {
                    Product2 newProd = new Product2(
                        ProductCode = nprStaging.Phoenix_Material_Number__c,
                        Name = nprStaging.Phoenix_Vistex_Description__c,
                        Phoenix_SAP_Product_Name__c = nprStaging.Phoenix_Vistex_Description__c,
                        Phoenix_SAP_Product_Family__c = nprStaging.Phoenix_Vistex_Product_Hierarchy__c,
                        Phoenix_NDC_11__c = nprStaging.Phoenix_NDC11__c,
                        Phoenix_NDC__c = nprStaging.Phoenix_UPC_NDC10__c,
                        Phoenix_WAC__c = nprStaging.Phoenix_WAC__c,
                        IsActive = true
                    );
                    proMap.put(newProd.ProductCode, newProd);
                    newlyCreatedProdsMap.put(newProd.ProductCode, newProd);
                } else {
                    Product2 prod = ExistingProdMap.get(nprStaging.Phoenix_Material_Number__c);
                    // prod.Name=nprStaging.Phoenix_Vistex_Description__c;
                    prod.Phoenix_SAP_Product_Name__c = nprStaging.Phoenix_Vistex_Description__c;
                    prod.Phoenix_SAP_Product_Family__c = nprStaging.Phoenix_Vistex_Product_Hierarchy__c;
                   // prod.Phoenix_NDC_11__c = nprStaging.Phoenix_NDC11__c;
                   // prod.Phoenix_NDC__c = nprStaging.Phoenix_UPC_NDC10__c;
                    if(!prod.Phoenix_Is_New_Product__c)prod.Phoenix_WAC__c = nprStaging.Phoenix_WAC__c;
                    proMap.put(prod.ProductCode, prod);
                }
            }
            upsert proMap.values();
            //Process for intimating contractors team with newly created products
            
            // allProds.AddAll();
            // allProds.AddAll(ExistingProdMap.values());
            for (Product2 prod: proMap.values()) existingProdMap.put(prod.ProductCode, prod); //Rebuilding map       
            
            //Generate Contract & Fill customer Id needed and present
            Map < String, Phoenix_Contract__c > newContractsMap = new Map < String, Phoenix_Contract__c > ();
            for (Phoenix_SAP_NPR_Staging__c nprStaging: nprStagingList) {
                if (!existingContractsMap.containsKey(nprStaging.Phoenix_Contract_Number__c)) { //New contracts
                    Phoenix_Contract__c newCon = new Phoenix_Contract__c(
                        Name = nprStaging.Phoenix_Contract_Number__c + '_' + nprStaging.Phoenix_Contract_Internal_Description__c,
                        Phoenix_Contract_Number__c = nprStaging.Phoenix_Contract_Number__c,
                        Phoenix_Contract_External_Description__c = nprStaging.Phoenix_Contract_External_Description__c,
                        Phoenix_Contract_Internal_Description__c = nprStaging.Phoenix_Contract_Internal_Description__c,
                        Phoenix_Contract_Start_Date__c = nprStaging.Phoenix_Contract_Start_Date__c,
                        Phoenix_NPR_Customer_Name__c = nprStaging.Phoenix_Customer_Name__c,
                        Phoenix_NPR_Customer_Code__c = nprStaging.Phoenix_Customer_Number__c,
                        Phoenix_Contract_End_Date__c = nprStaging.Phoenix_Contract_End_Date__c
                        
                    );
                    //If Customer Code = 371033
                    newCon.Phoenix_Customer__c = nprStaging.Phoenix_Customer_Number__c != '371033' &&
                        existingCustomersMap.containsKey(nprStaging.Phoenix_Customer_Number__c) ? existingCustomersMap.get(nprStaging.Phoenix_Customer_Number__c).Id : newCon.Phoenix_Customer__c;
                    
                    newContractsMap.put(nprStaging.Phoenix_Contract_Number__c, newCon);
                } else { //existing contracts
                    //contract update logic modification by Mamatha
                    Phoenix_Contract__c existingCon = existingContractsMap.get(nprStaging.Phoenix_Contract_Number__c);
                    existingCon.Name = nprStaging.Phoenix_Contract_Number__c + '_' + nprStaging.Phoenix_Contract_Internal_Description__c;
                    existingCon.Phoenix_Contract_External_Description__c = nprStaging.Phoenix_Contract_External_Description__c;
                    existingCon.Phoenix_Contract_Internal_Description__c = nprStaging.Phoenix_Contract_Internal_Description__c;
                    existingCon.Phoenix_Contract_Start_Date__c = nprStaging.Phoenix_Contract_Start_Date__c;
                    existingCon.Phoenix_NPR_Customer_Name__c = nprStaging.Phoenix_Customer_Name__c;//Added code by rama 139 ,140 lines
                    existingCon.Phoenix_NPR_Customer_Code__c = nprStaging.Phoenix_Customer_Number__c;
                    
                  if(!existingCon.Phoenix_Is_Manual_Override__c) existingCon.Phoenix_Contract_End_Date__c = nprStaging.Phoenix_Contract_End_Date__c;
                    //If Customer Code = 371033
                    existingCon.Phoenix_Customer__c = nprStaging.Phoenix_Customer_Number__c != '371033' &&
                        existingCustomersMap.containsKey(nprStaging.Phoenix_Customer_Number__c) ? existingCustomersMap.get(nprStaging.Phoenix_Customer_Number__c).Id : existingCon.Phoenix_Customer__c;
                    newContractsMap.put(existingCon.Phoenix_Contract_Number__c, existingCon);
                }
            }
            
            //Upsert Contract
            if (!newContractsMap.isEmpty()) upsert newContractsMap.values();
            //updatedContracts.addAll(newContractsMap.values());
            // updatedContracts.addAll(existingContractsMap.values());
            for (Phoenix_Contract__c contr: newContractsMap.values()) existingContractsMap.put(contr.Phoenix_Contract_Number__c, contr);
            
            //Generate NPR Data - fill contract lookup  & Fill customer Id needed and present
            Map < String, Phoenix_NPR_Data__c > newNprMap = new Map < String, Phoenix_NPR_Data__c > ();
            for (Phoenix_SAP_NPR_Staging__c nprStaging: nprStagingList) {
                Account customer = existingCustomersMap.get(nprStaging.Phoenix_Customer_Number__c);
                Phoenix_Contract__c contract = existingContractsMap.get(nprStaging.Phoenix_Contract_Number__c);
                Product2 prod = existingProdMap.get(nprStaging.Phoenix_Material_Number__c);
                if (nprStaging.Phoenix_NPR_Ref_SF__c != null && !existingNPRMap.containsKey(nprStaging.Phoenix_NPR_Ref_SF__c)) {
                    Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c(
                        Phoenix_Contract__c = contract.Id,
                        Phoenix_Contract_Type__c = nprStaging.Phoenix_Contract_Type__c,
                        Phoenix_Product__c = prod.Id,
                        Phoenix_CD__c = nprStaging.Phoenix_CD__c,
                        Phoenix_ABS__c = nprStaging.Phoenix_ABS__c,
                        Phoenix_ABS_in__c = nprStaging.Phoenix_ABS_in_Currency__c,
                        Phoenix_Add_ABS_Value__c = nprStaging.Phoenix_Add_ABS_Value__c,
                        Phoenix_Bonafied_G_N_Indicator__c = nprStaging.Phoenix_Bonafied_G_N_Indicator__c,
                        Phoenix_CM_Fee__c = nprStaging.Phoenix_CM_Fee__c,
                        Phoenix_CM_Fee_in__c = nprStaging.Phoenix_CM_Fee_in__c,
                        Phoenix_CD_in__c = nprStaging.Phoenix_CD_in__c,
                        Phoenix_12Months_Net_Sales__c = nprStaging.Phoenix_12Months_Net_Sales__c,
                        Phoenix_CP_Units__c = nprStaging.Phoenix_CP_Units__c,
                        Phoenix_Customer_Group__c = nprStaging.Phoenix_Customer_Group__c,
                        Phoenix_Customer_Number__c = nprStaging.Phoenix_Customer_Number__c,
                        Phoenix_Contract_Price__c = nprStaging.Phoenix_Contract_Price__c,
                        Phoenix_Dead_Net_High_GR__c = nprStaging.Phoenix_Dead_Net_High_GR__c,
                        Phoenix_Dead_Net_Tracking_GR__c = nprStaging.Phoenix_Dead_Net_Tracking_GR__c,
                        Phoenix_Vistex_Description__c = nprStaging.Phoenix_Vistex_Description__c,
                        Phoenix_Vistex_Product_Hierarchy__c = nprStaging.Phoenix_Vistex_Product_Hierarchy__c,
                        Phoenix_Fee_Bonafied_Fee__c = nprStaging.Phoenix_Fee_Bonafied_Fee__c,
                        Phoenix_Fee_in_Value__c = nprStaging.Phoenix_Fee_in_Value__c,
                        Phoenix_GR_HighTier_in__c = nprStaging.Phoenix_GR_HighTier_in__c,
                        Phoenix_GR_Rebate_High_Tier__c = nprStaging.Phoenix_GR_Rebate_High_Tier__c,
                        Phoenix_GR_TrackingTier__c = nprStaging.Phoenix_GR_Tracking_Tier__c,
                        Phoenix_GR_Tracking_in__c = nprStaging.Phoenix_GR_Tracking_in__c,
                        Phoenix_Market_Share__c = nprStaging.Phoenix_Market_Share__c,
                        Phoenix_NDC_11__c = nprStaging.Phoenix_NDC11__c,
                        Phoenix_Net_Price_for_GR_basis__c = nprStaging.Phoenix_Net_Price_for_GR_basis__c,
                        Phoenix_Net_Price_w_o_Fee_CD__c = nprStaging.Phoenix_Net_Price_w_o_Fee_CD__c,
                        Phoenix_Net_Price_w_o_Fee_CD_HiGR__c = nprStaging.Phoenix_Net_Price_w_o_Fee_CD_HiGR__c,
                        Phoenix_Net_Price_w_o_Fees__c = nprStaging.Phoenix_Net_Price_w_o_Fees__c,
                        Phoenix_Net_Price_with_Fees__c = nprStaging.Phoenix_Net_Price_with_Fees__c,
                        Phoenix_Net_Price_Fees_CD__c = nprStaging.Phoenix_Net_Price_Fees_CD__c,
                        Phoenix_Net_Price_Fees_CD_HiGR__c = nprStaging.Phoenix_Net_Price_Fees_CD_HiGR__c,
                        Phoenix_Net_Sales_90__c = nprStaging.Phoenix_Net_Sales_90__c,
                        Phoenix_NPR_Customer_Name__c = nprStaging.Phoenix_Customer_Name__c,
                        Phoenix_NPR_Customer_Code__c = nprStaging.Phoenix_Customer_Number__c,
                        Phoenix_Per_Unit_Bonfied_Fee__c = nprStaging.Phoenix_Per_Unit_Bonafied_Fee__c,
                        Phoenix_Per_Unit_Rebate__c = nprStaging.Phoenix_Per_Unit_Rebate__c,
                        Phoenix_Price_Effective_Value_From__c = nprStaging.Phoenix_Price_Effective_Value_From__c,
                        Phoenix_Price_Effective_Value_To__c = nprStaging.Phoenix_Price_Effective_Value_To__c,
                        Phoenix_Product_Position__c = nprStaging.Phoenix_Product_Position__c,
                        Phoenix_RDC_NLC__c = nprStaging.Phoenix_RDC_NLC__c,
                        Phoenix_RDC_NLC_in__c = nprStaging.Phoenix_RDC_NLC_in__c,
                        Phoenix_Rebate_G_N_Indicator__c = nprStaging.Phoenix_Rebate_G_N_Indicator__c,
                        Phoenix_Rebate_in_Value__c = nprStaging.Phoenix_Rebate_in_Value__c,
                        Phoenix_Sales_From_Date_for_last_90_Days__c = nprStaging.Phoenix_Sales_From_Date_last_90_Days__c,
                        Phoenix_ZITD_Value__c = nprStaging.Phoenix_ZITD_Value__c,
                        Phoenix_ZD07_Off_InvCurrency__c = nprStaging.Phoenix_ZD07_Off_Inv_dollar__c,
                        Phoenix_ZD07_Off_Inv__c = nprStaging.Phoenix_ZD07_Off_Inv__c,
                        Phoenix_WAC_Units__c = nprStaging.Phoenix_WAC_Units__c,
                        Phoenix_WAC__c = nprStaging.Phoenix_WAC__c,
                        Phoenix_Rebate__c = nprStaging.Phoenix_Rebate__c,
                        Phoenix_WAC_Check__c = nprStaging.Phoenix_WAC_Check__c,
                        Phoenix_UPC_NDC10__c = nprStaging.Phoenix_UPC_NDC10__c,
                        Phoenix_Tracking_Gr_last_12_months_Sales__c = nprStaging.Phoenix_Tracking_Gr_last_12_months_Sales__c,
                        Phoenix_12Months_Sales_Unit__c = nprStaging.Phoenix_12Mt_Sales_Ut__c,
                        Phoenix_Contract_End_Date__c = nprStaging.Phoenix_Contract_End_Date__c,
                        Phoenix_Contract_External_Description__c = nprStaging.Phoenix_Contract_External_Description__c,
                        Phoenix_Contract_Internal_Description__c = nprStaging.Phoenix_Contract_Internal_Description__c,
                        Phoenix_Contract_Number__c = nprStaging.Phoenix_Contract_Number__c,
                        Phoenix_Contract_Start_Date__c = nprStaging.Phoenix_Contract_Start_Date__c,
                        Phoenix_Tracking_Gr_annual_usage_Sales__c = nprStaging.Phoenix_Tracking_Gr_annual_usage_Sales__c,
                        Phoenix_Material_Number__c = nprStaging.Phoenix_Material_Number__c,
                        Phoenix_12Mt_Sales_Ut_Actual__c = nprStaging.Phoenix_12Mt_Sales_Ut_Actual__c,
                        Phoenix_SalesUnit_90__c = nprStaging.Phoenix_Sales_Unit_90__c,
                        Phoenix_Sales_Group__c = nprStaging.Phoenix_Sales_Group__c,
                        Phoenix_NPR_Status__c = 'Active'
                    );
                    //If Customer Code = 371033
                if(nprStaging.Phoenix_Customer_Number__c != '371033' && existingCustomersMap.containsKey(nprStaging.Phoenix_Customer_Number__c)){
                        npr.Phoenix_Account__c = existingCustomersMap.get(nprStaging.Phoenix_Customer_Number__c).Id;
                } /*else{
                    npr.Phoenix_Account__c = null; 
                }*/
                    updatedNPRsMap.put(nprStaging.Phoenix_NPR_Ref_SF__c, npr);
                    //newNprMap
                } else if (nprStaging.Phoenix_NPR_Ref_SF__c != null && existingNPRMap.containsKey(nprStaging.Phoenix_NPR_Ref_SF__c)) { //Update existing NPR
                    Phoenix_NPR_Data__c npr = existingNPRMap.get(nprStaging.Phoenix_NPR_Ref_SF__c);
                    npr.Phoenix_Contract_Type__c = nprStaging.Phoenix_Contract_Type__c;
                    npr.Phoenix_Product__c = prod.Id;
                    npr.Phoenix_CD__c = nprStaging.Phoenix_CD__c;
                    npr.Phoenix_ABS__c = nprStaging.Phoenix_ABS__c;
                    npr.Phoenix_ABS_in__c = nprStaging.Phoenix_ABS_in_Currency__c;
                    npr.Phoenix_Add_ABS_Value__c = nprStaging.Phoenix_Add_ABS_Value__c;
                    npr.Phoenix_Bonafied_G_N_Indicator__c = nprStaging.Phoenix_Bonafied_G_N_Indicator__c;
                    npr.Phoenix_CM_Fee__c = nprStaging.Phoenix_CM_Fee__c;
                    npr.Phoenix_CM_Fee_in__c = nprStaging.Phoenix_CM_Fee_in__c;
                    npr.Phoenix_CD_in__c = nprStaging.Phoenix_CD_in__c;
                    npr.Phoenix_CP_Units__c = nprStaging.Phoenix_CP_Units__c;
                    npr.Phoenix_Customer_Group__c = nprStaging.Phoenix_Customer_Group__c;
                    npr.Phoenix_Customer_Number__c = nprStaging.Phoenix_Customer_Number__c;
                    npr.Phoenix_Contract_Price__c = nprStaging.Phoenix_Contract_Price__c;
                    npr.Phoenix_Dead_Net_High_GR__c = nprStaging.Phoenix_Dead_Net_High_GR__c;
                    npr.Phoenix_Dead_Net_Tracking_GR__c = nprStaging.Phoenix_Dead_Net_Tracking_GR__c;
                    npr.Phoenix_Fee_Bonafied_Fee__c = nprStaging.Phoenix_Fee_Bonafied_Fee__c;
                    npr.Phoenix_Fee_in_Value__c = nprStaging.Phoenix_Fee_in_Value__c;
                    npr.Phoenix_GR_HighTier_in__c = nprStaging.Phoenix_GR_HighTier_in__c;
                    npr.Phoenix_GR_Rebate_High_Tier__c = nprStaging.Phoenix_GR_Rebate_High_Tier__c;
                    npr.Phoenix_GR_TrackingTier__c = nprStaging.Phoenix_GR_Tracking_Tier__c;
                    npr.Phoenix_GR_Tracking_in__c = nprStaging.Phoenix_GR_Tracking_in__c;
                    npr.Phoenix_Market_Share__c = nprStaging.Phoenix_Market_Share__c;
                    npr.Phoenix_Rebate__c = nprStaging.Phoenix_Rebate__c;
                    npr.Phoenix_NDC_11__c = nprStaging.Phoenix_NDC11__c;
                    npr.Phoenix_Net_Price_for_GR_basis__c = nprStaging.Phoenix_Net_Price_for_GR_basis__c;
                    npr.Phoenix_Net_Price_w_o_Fee_CD__c = nprStaging.Phoenix_Net_Price_w_o_Fee_CD__c;
                    npr.Phoenix_Net_Price_w_o_Fee_CD_HiGR__c = nprStaging.Phoenix_Net_Price_w_o_Fee_CD_HiGR__c;
                    npr.Phoenix_Net_Price_w_o_Fees__c = nprStaging.Phoenix_Net_Price_w_o_Fees__c;
                    npr.Phoenix_Net_Price_with_Fees__c = nprStaging.Phoenix_Net_Price_with_Fees__c;
                    npr.Phoenix_Net_Price_Fees_CD__c = nprStaging.Phoenix_Net_Price_Fees_CD__c;
                    npr.Phoenix_Net_Price_Fees_CD_HiGR__c = nprStaging.Phoenix_Net_Price_Fees_CD_HiGR__c;
                    npr.Phoenix_Net_Sales_90__c = nprStaging.Phoenix_Net_Sales_90__c;
                    npr.Phoenix_Per_Unit_Bonfied_Fee__c = nprStaging.Phoenix_Per_Unit_Bonafied_Fee__c;
                    npr.Phoenix_Per_Unit_Rebate__c = nprStaging.Phoenix_Per_Unit_Rebate__c;
                    npr.Phoenix_Price_Effective_Value_From__c = nprStaging.Phoenix_Price_Effective_Value_From__c;
                    npr.Phoenix_Price_Effective_Value_To__c = nprStaging.Phoenix_Price_Effective_Value_To__c;
                    npr.Phoenix_Product_Position__c = nprStaging.Phoenix_Product_Position__c;
                    npr.Phoenix_RDC_NLC__c = nprStaging.Phoenix_RDC_NLC__c;
                    npr.Phoenix_RDC_NLC_in__c = nprStaging.Phoenix_RDC_NLC_in__c;
                    npr.Phoenix_Rebate_G_N_Indicator__c = nprStaging.Phoenix_Rebate_G_N_Indicator__c;
                    npr.Phoenix_Rebate_in_Value__c = nprStaging.Phoenix_Rebate_in_Value__c;
                    npr.Phoenix_Sales_From_Date_for_last_90_Days__c = nprStaging.Phoenix_Sales_From_Date_last_90_Days__c;
                    npr.Phoenix_ZITD_Value__c = nprStaging.Phoenix_ZITD_Value__c;
                    npr.Phoenix_WAC_Units__c = nprStaging.Phoenix_WAC_Units__c;
                    npr.Phoenix_WAC__c = nprStaging.Phoenix_WAC__c;
                    npr.Phoenix_NPR_Customer_Name__c = nprStaging.Phoenix_Customer_Name__c;
                    npr.Phoenix_NPR_Customer_Code__c = nprStaging.Phoenix_Customer_Number__c;
                    npr.Phoenix_WAC_Check__c = nprStaging.Phoenix_WAC_Check__c;
                    npr.Phoenix_UPC_NDC10__c = nprStaging.Phoenix_UPC_NDC10__c;
                    npr.Phoenix_Tracking_Gr_last_12_months_Sales__c = nprStaging.Phoenix_Tracking_Gr_last_12_months_Sales__c;
                    npr.Phoenix_Tracking_Gr_annual_usage_Sales__c = nprStaging.Phoenix_Tracking_Gr_annual_usage_Sales__c;
                    npr.Phoenix_Sales_Group__c = nprStaging.Phoenix_Sales_Group__c;
                    npr.Phoenix_ZD07_Off_InvCurrency__c = nprStaging.Phoenix_ZD07_Off_Inv_dollar__c;
                    npr.Phoenix_ZD07_Off_Inv__c = nprStaging.Phoenix_ZD07_Off_Inv__c;
                    npr.Phoenix_12Months_Sales_Unit__c = nprStaging.Phoenix_12Mt_Sales_Ut__c;
                    npr.Phoenix_Contract_End_Date__c = nprStaging.Phoenix_Contract_End_Date__c;
                    npr.Phoenix_Contract_External_Description__c = nprStaging.Phoenix_Contract_External_Description__c;
                    npr.Phoenix_Contract_Internal_Description__c = nprStaging.Phoenix_Contract_Internal_Description__c;
                    npr.Phoenix_Contract_Number__c = nprStaging.Phoenix_Contract_Number__c;
                    npr.Phoenix_Contract_Start_Date__c = nprStaging.Phoenix_Contract_Start_Date__c;
                    npr.Phoenix_Tracking_Gr_annual_usage_Sales__c = nprStaging.Phoenix_Tracking_Gr_annual_usage_Sales__c;
                    npr.Phoenix_Material_Number__c = nprStaging.Phoenix_Material_Number__c;
                    npr.Phoenix_Vistex_Description__c = nprStaging.Phoenix_Vistex_Description__c;
                    npr.Phoenix_Vistex_Product_Hierarchy__c = nprStaging.Phoenix_Vistex_Product_Hierarchy__c;
                    npr.Phoenix_12Months_Sales_Unit__c = nprStaging.Phoenix_12Mt_Sales_Ut__c;
                    npr.Phoenix_12Mt_Sales_Ut_Actual__c = nprStaging.Phoenix_12Mt_Sales_Ut_Actual__c;
                    npr.Phoenix_SalesUnit_90__c = nprStaging.Phoenix_Sales_Unit_90__c;
                    npr.Phoenix_NPR_Status__c = 'Active';
                    updatedNPRsMap.put(nprStaging.Phoenix_NPR_Ref_SF__c, npr);
                }
            }
            //Upsert NPR Data
            upsert updatedNPRsMap.values();
            existingNPRMap.putAll(updatedNPRsMap);
            existingCustomersMap.clear();
            existingContractsMap.clear();
            existingProdMap.clear();
            /*-------------------NPR Volume Section------START---------*/
            System.enqueueJob(new Phoenix_CreateNPRVolumeQueue(nprStagingList, existingNPRMap));
            /*-------------------NPR Volume Section------END---------*/
            
            //Update Staging objects as sync completed.
            
            List < Phoenix_SAP_NPR_Staging__c > updatedStagingObjs = new List < Phoenix_SAP_NPR_Staging__c > ();
            for (Phoenix_SAP_NPR_Staging__c stageObj: nprStagingList) {
                stageObj.Phoenix_Is_Sync_Completed__c = true;
                updatedStagingObjs.add(stageObj);
            }
            if (!updatedStagingObjs.isEmpty()) Database.update(updatedStagingObjs, false);
            //  System.debug('Total Heap Size====>'+Limits.getHeapSize());
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_NPRStagingProcessor', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
            
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        System.debug('Total Records->' + recordCount);
        
        Decimal insertedStagingRecordsToday = Database.Countquery('SELECT Count() FROM Phoenix_SAP_NPR_Staging__c  WHERE  CreatedDate = TODAY');
        
       // CronTrigger[] jobs = [SELECT CreatedById, CreatedDate, CronExpression, CronJobDetailId, CronJobDetail.Name, EndTime, Id, LastModifiedById, NextFireTime, OwnerId, PreviousFireTime, StartTime, State, TimesTriggered, TimeZoneSidKey FROM CronTrigger WHERE CronJobDetail.Name = 'Phoenix_NPRDataActiveChecker'];

        //scheduleBatch(batchable, jobName, minutesFromNow, scopeSize)
     //   if (recordCount == insertedStagingRecordsToday) { // && jobs.size() == 0
            System.scheduleBatch(new Phoenix_FutureNPRStagingProcessor(), 'Phoenix_FutureNPRStagingProcessor', 1, 1);
     //   }

    }
}