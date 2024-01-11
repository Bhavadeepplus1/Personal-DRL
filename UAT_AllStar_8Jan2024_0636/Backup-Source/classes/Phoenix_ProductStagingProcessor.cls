/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   03-12-2020   Surender Patel (Dhruvsoft)   Initial Version
 **/

public class Phoenix_ProductStagingProcessor implements Database.Batchable < sObject > , Database.Stateful, Schedulable {
    Map < String, String > fieldsStagingToActualObjMap = new Map < String, String > ();
    Map < String, String > fieldsStagingToPlaybookObjMap = new Map < String, String > ();
    public Phoenix_ProductStagingProcessor() {
        fieldsStagingToActualObjMap.put('Phoenix_Material_Description__c', 'Phoenix_SAP_Product_Name__c');
        fieldsStagingToActualObjMap.put('Phoenix_SAP_Number__c', 'ProductCode');
        //fieldsStagingToActualObjMap.put('Phoenix_NDC__c', 'Phoenix_NDC_11__c');//Not coming from sap
        fieldsStagingToActualObjMap.put('Phoenix_NDC__c', 'Phoenix_NDC__c'); // coming from sap
        fieldsStagingToActualObjMap.put('Phoenix_UPC__c', 'Phoenix_UPC_Universal_Product_Code__c');
        fieldsStagingToActualObjMap.put('Phoenix_Strength__c', 'Phoenix_Strength__c');
        //fieldsStagingToActualObjMap.put('Phoenix_Pkg_Size__c', 'Phoenix_Pkg_Size__c'); //not using
        fieldsStagingToActualObjMap.put('Phoenix_Case_Pack__c', 'Phoenix_Case_Pack__c');
        fieldsStagingToActualObjMap.put('Phoenix_Minimum_Order_Quantity__c', 'Phoenix_Minimum_Order_Quantity__c');
        fieldsStagingToActualObjMap.put('Phoenix_Product_Family__c', 'Phoenix_SAP_Product_Family__c');
        //fieldsStagingToActualObjMap.put('Phoenix_Compare_to_Brand_Name__c', 'Phoenix_Compare_to_Brand_Name__c');
        //fieldsStagingToActualObjMap.put('Phoenix_Th_Put_Cost__c', 'Phoenix_Throughput_cost__c');//not coming from sap
        fieldsStagingToActualObjMap.put('Phoenix_WAC__c', 'Phoenix_WAC__c');
        fieldsStagingToActualObjMap.put('Phoenix_Dosage_Form__c', 'Phoenix_Dosage_Form__c');
        fieldsStagingToActualObjMap.put('Phoenix_Controlled_Substance__c', 'Phoenix_Controlled_Substance__c');
        fieldsStagingToActualObjMap.put('Phoenix_Controlled_Substance_Class__c', 'Phoenix_Controlled_Substance_Class__c');
        fieldsStagingToActualObjMap.put('Phoenix_SAP_Molecule_Description__c', 'Phoenix_SAP_Molecule_Description__c');
        fieldsStagingToActualObjMap.put('Phoenix_SAP_Pack_Size__c', 'Phoenix_SAP_Pack_Size__c');
        fieldsStagingToActualObjMap.put('Phoenix_SAP_Sub_Therapy_Description__c', 'Phoenix_SAP_Sub_Therapy_Description__c');
        fieldsStagingToActualObjMap.put('Phoenix_SAP_Therapy_Description__c', 'Phoenix_SAP_Therapy_Description__c');
        fieldsStagingToActualObjMap.put('Phoenix_SAP_Created_Date__c', 'Phoenix_SAP_Created_Date__c');
        fieldsStagingToActualObjMap.put('Phoenix_Imported_or_Domestic__c', 'Phoenix_Imported_or_Domestic__c');
        fieldsStagingToActualObjMap.put('Phoenix_SAP_Modified_Date__c', 'Phoenix_SAP_Modified_Date__c');
        fieldsStagingToActualObjMap.put('Phoenix_Shelf_Life__c', 'Phoenix_Shelf_Life__c');
        fieldsStagingToActualObjMap.PUT('Phoenix_Active_Discontinue__c', 'Phoenix_Active_Discontinue__c');

        fieldsStagingToPlaybookObjMap.put('Phoenix_Imported_or_Domestic__c', 'Phoenix_Imported_or_Domestic__c');
        fieldsStagingToPlaybookObjMap.put('Phoenix_DLS_formerly_NDC__c', 'Phoenix_DLS_formerly_NDC__c');
        //fieldsStagingToPlaybookObjMap.put('Phoenix_Proprietary_Name_Trade_Name__c','Phoenix_Proprietary_Name__c');//not coming from sap
        fieldsStagingToPlaybookObjMap.put('Phoenix_Active_Discontinue__c', 'Phoenix_Active_Discontinue__c');
        fieldsStagingToPlaybookObjMap.put('Phoenix_Shelf_Life__c', 'Phoenix_Shelf_Life__c');
    }
    public void execute(SchedulableContext sc) {
        database.executeBatch(new Phoenix_ProductStagingProcessor(), 1);
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT' + Phoenix_Util.getsObjectFieds('Phoenix_SAP_Product_Staging__c') + 'FROM Phoenix_SAP_Product_Staging__c WHERE Phoenix_Is_Sync_Completed__c = false';
        //  String query = 'SELECT'+ Phoenix_Util.getsObjectFieds('Phoenix_SAP_Product_Staging__c')+'FROM Phoenix_SAP_Product_Staging__c WHERE Id=\'a0D8A000003pg8aUAA\'';
        if (Test.isRunningTest()) query += ' Limit 1';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List < Phoenix_SAP_Product_Staging__c > prodStagingList) {
        try{
        List < Product2 > upsertProductList = new List < Product2 > ();
        List < Phoenix_Product_Playbook__c > updatedPlaybooks = new List < Phoenix_Product_Playbook__c > ();
        String productKey;
        Map < String, Phoenix_SAP_Product_Staging__c > productStagingMap = new Map < String, Phoenix_SAP_Product_Staging__c > ();
        for (Phoenix_SAP_Product_Staging__c prod: prodStagingList) {
            productStagingMap.put(prod.Phoenix_SAP_Number__c, prod);
        }
        Map < String, Product2 > productMap = new Map < String, Product2 > ();
        List < Product2 > prodct = [SELECT Id, ProductCode, Name FROM Product2 WHERE ProductCode IN: productStagingMap.keyset()];
        for (Product2 product: prodct) {
            productMap.put(product.ProductCode, product);
        }
        for (String sapProdCode: productStagingMap.keySet()) {
            if (productMap.containsKey(sapProdCode)) {
                //Update Item
                Phoenix_SAP_Product_Staging__c productStaging = productStagingMap.get(sapProdCode);
                Product2 prod = productMap.get(sapProdCode);

                for (String field: fieldsStagingToActualObjMap.keySet()) {
                    //if(field == 'Phoenix_SAP_Pack_Size__c' && productStaging.Phoenix_SAP_Pack_Size__c!=null)prod.Phoenix_Pkg_Size__c = integer.valueof(productStaging.Phoenix_SAP_Pack_Size__c);
                    if (field == 'Phoenix_SAP_Pack_Size__c' && productStaging.Phoenix_SAP_Pack_Size__c != null) prod.Phoenix_SAP_Pack_Size__c = productStaging.Phoenix_SAP_Pack_Size__c;

                    else if (field == 'Phoenix_Case_Pack__c' && productStaging.Phoenix_Case_Pack__c != null) prod.Phoenix_Case_Pack__c = integer.valueof(productStaging.Phoenix_Case_Pack__c);

                    else if (field == 'Phoenix_Minimum_Order_Quantity__c' && productStaging.Phoenix_Minimum_Order_Quantity__c != null) prod.Phoenix_Minimum_Order_Quantity__c = integer.valueof(productStaging.Phoenix_Minimum_Order_Quantity__c);

                    
                    // added by vandana.
                    
                    else if (field == 'Phoenix_WAC__c' && !prod.Phoenix_Is_New_Product__c) prod.Phoenix_WAC__c = productStaging.Phoenix_WAC__c;
                    //end.
                    else if (field == 'Phoenix_Controlled_Substance__c') prod.Phoenix_Controlled_Substance__c = productStaging.Phoenix_Controlled_Substance__c;
                    else if (field == 'Phoenix_Imported_or_Domestic__c') {
                        if (productStaging.Phoenix_Imported_or_Domestic__c != null) {
                            prod.Phoenix_Imported_or_Domestic__c = productStaging.Phoenix_Imported_or_Domestic__c == 'Yes' ? true : false;
                        } else {
                            prod.Phoenix_Imported_or_Domestic__c = false;
                        }

                    } else if (field == 'Phoenix_Shelf_Life__c' && productStaging.Phoenix_Shelf_Life__c != null) prod.Phoenix_Shelf_Life__c = integer.valueof(productStaging.Phoenix_Shelf_Life__c);
                    else if (field == 'Phoenix_Active_Discontinue__c') {
                        if (productStaging.Phoenix_Active_Discontinue__c != null) {
                            prod.Phoenix_Active_Discontinue__c = productStaging.Phoenix_Active_Discontinue__c == 'Active' ? true : false;
                        } else {
                            prod.Phoenix_Active_Discontinue__c = false;
                        }
                    } else prod.put(fieldsStagingToActualObjMap.get(field), productStaging.get(field));
                }

                upsertProductList.add(prod);
            } else {
                //New Item
                Phoenix_SAP_Product_Staging__c productStaging = productStagingMap.get(sapProdCode);
                Product2 prod = new Product2();
                prod.Name = productStaging.Phoenix_Material_Description__c;
                prod.Description = productStaging.Phoenix_Material_Description__c;
                prod.Family = productStaging.Phoenix_Product_Family__c;

                for (String field: fieldsStagingToActualObjMap.keySet()) {
                    //if(field == 'Phoenix_SAP_Pack_Size__c' && productStaging.Phoenix_SAP_Pack_Size__c!=null)prod.Phoenix_Pkg_Size__c = integer.valueof(productStaging.Phoenix_SAP_Pack_Size__c);
                    if (field == 'Phoenix_SAP_Pack_Size__c' && productStaging.Phoenix_SAP_Pack_Size__c != null) prod.Phoenix_SAP_Pack_Size__c = productStaging.Phoenix_SAP_Pack_Size__c;
                    else if (field == 'Phoenix_Case_Pack__c' && productStaging.Phoenix_Case_Pack__c != null) prod.Phoenix_Case_Pack__c = integer.valueof(productStaging.Phoenix_Case_Pack__c);

                    else if (field == 'Phoenix_Minimum_Order_Quantity__c' && productStaging.Phoenix_Minimum_Order_Quantity__c != null) prod.Phoenix_Minimum_Order_Quantity__c = integer.valueof(productStaging.Phoenix_Minimum_Order_Quantity__c);
                    else if (field == 'Phoenix_Controlled_Substance__c') prod.Phoenix_Controlled_Substance__c = productStaging.Phoenix_Controlled_Substance__c;
                    else if (field == 'Phoenix_Imported_or_Domestic__c') {
                        if (productStaging.Phoenix_Imported_or_Domestic__c != null) {
                            prod.Phoenix_Imported_or_Domestic__c = productStaging.Phoenix_Imported_or_Domestic__c == 'Yes' ? true : false;
                        } else {
                            prod.Phoenix_Imported_or_Domestic__c = false;
                        }
                    } else if (field == 'Phoenix_Active_Discontinue__c') {
                        if (productStaging.Phoenix_Active_Discontinue__c != null) {
                            prod.Phoenix_Active_Discontinue__c = productStaging.Phoenix_Active_Discontinue__c == 'Yes' ? true : false;
                        } else {
                            prod.Phoenix_Active_Discontinue__c = false;
                        }
                    } else if (field == 'Phoenix_Shelf_Life__c' && productStaging.Phoenix_Shelf_Life__c != null) prod.Phoenix_Shelf_Life__c = integer.valueof(productStaging.Phoenix_Shelf_Life__c);
                    else prod.put(fieldsStagingToActualObjMap.get(field), productStaging.get(field));

                }
                upsertProductList.add(prod);
            }
        }
        //Upsert products        
        if (!upsertProductList.isEmpty()) {
            upsert upsertProductList;
        }
        Map < String, Phoenix_Product_Playbook__c > playbookMap = new Map < String, Phoenix_Product_Playbook__c > ();
        List < Phoenix_Product_Playbook__c > query = [SELECT Id, Phoenix_SAP_Material__c FROM Phoenix_Product_Playbook__c WHERE Phoenix_SAP_Material__c IN: productStagingMap.keyset()];
        for (Phoenix_Product_Playbook__c pb: query) {
            playbookMap.put(pb.Phoenix_SAP_Material__c, pb);
        }

        for (String sapProdCode: productStagingMap.keySet()) {

            if (playbookMap.containsKey(sapProdCode)) {
                //Update Playbook
                Phoenix_SAP_Product_Staging__c productStaging = productStagingMap.get(sapProdCode);
                Phoenix_Product_Playbook__c pb = playbookMap.get(sapProdCode);

                for (String field: fieldsStagingToPlaybookObjMap.keySet()) {
                    pb.put(fieldsStagingToPlaybookObjMap.get(field), productStaging.get(field));
                }
                updatedPlaybooks.add(pb);
            }
        }
        if (!updatedPlaybooks.isEmpty()) update updatedPlaybooks;
        List < Phoenix_SAP_Product_Staging__c > updatedStagingObjs = new List < Phoenix_SAP_Product_Staging__c > ();
        for (Phoenix_SAP_Product_Staging__c stageObj: prodStagingList) {
            stageObj.Phoenix_Is_Sync_Completed__c = true;
            updatedStagingObjs.add(stageObj);
        }
        if (!updatedStagingObjs.isEmpty()) update updatedStagingObjs;
    }
       Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_ProductStagingProcessor', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
 
    }
    }
    public void finish(Database.BatchableContext BC) {
        CronTrigger[] jobs = [SELECT CreatedById, CreatedDate, CronExpression, CronJobDetailId, CronJobDetail.Name, EndTime, Id, LastModifiedById, NextFireTime, OwnerId, PreviousFireTime, StartTime, State, TimesTriggered, TimeZoneSidKey FROM CronTrigger WHERE CronJobDetail.Name = 'Phoenix_ProductStagingProcessor'];
        if (jobs.isEmpty() && !Test.isRunningTest()) {
            // System.debug('----------Batch job is not scheduled--------');
            /*  
//  system.scheduleBatch(new Phoenix_ProductStagingProcessor(),'Phoenix_ProductStagingProcessor',2);
}*/
        } else {
            //System.debug('----------batch is scheduled--------');
        }
    }
}