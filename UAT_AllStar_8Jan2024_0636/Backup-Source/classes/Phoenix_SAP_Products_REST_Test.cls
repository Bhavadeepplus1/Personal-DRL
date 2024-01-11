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
@isTest
public class Phoenix_SAP_Products_REST_Test {
    
    static testmethod void test_success(){
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SAP_Products'; 
        req.httpMethod = 'POST';
        String body ='{"ns1:MT_Material":{"ProductDetails":[{"Phoenix_Active_Discontinue__c":"","Phoenix_Case_Pack__c":"12222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222","Phoenix_Controlled_Substance_Class__c":"","Phoenix_Controlled_Substance__c":"N","Phoenix_SAP_Created_Date__c":"","Phoenix_DLS_formerly_NDC__c":"","Phoenix_Dosage_Form__c":"TABLETS","Phoenix_Imported_or_Domestic__c":"","Phoenix_Material_Description__c":"Sertraline Tablets 100mg, 500","Phoenix_Minimum_Order_Quantity__c":"0","Phoenix_Status__c":"Invalid","Phoenix_SAP_Modified_Date__c":"","Phoenix_NDC__c":"5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111111110000001111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011117505555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555","Phoenix_SAP_Molecule_Description__c":"Sertraline","Phoenix_SAP_Number__c":"300000396","Phoenix_SAP_Pack_Size__c":"500","Phoenix_Product_Family__c":"NOT REQUIRED","Phoenix_SAP_Sub_Therapy_Description__c":"SSRI","Phoenix_SAP_Therapy_Description__c":"Anti-Depressant","Phoenix_Shelf_Life__c":"690","Phoenix_Strength__c":"100mg","Phoenix_WAC__c":"0","Phoenix_GTIN_14__c":"123"},{"Phoenix_Active_Discontinue__c":"","Phoenix_Case_Pack__c":"24","Phoenix_Controlled_Substance_Class__c":"","Phoenix_Controlled_Substance__c":"N","Phoenix_SAP_Created_Date__c":"","Phoenix_DLS_formerly_NDC__c":"","Phoenix_Dosage_Form__c":"TABLETS","Phoenix_Imported_or_Domestic__c":"","Phoenix_Material_Description__c":"Sertraline Tablets 100mg, 30","Phoenix_Minimum_Order_Quantity__c":"0","Phoenix_SAP_Modified_Date__c":"","Phoenix_NDC__c":"2500040","Phoenix_SAP_Molecule_Description__c":"Sertraline","Phoenix_SAP_Number__c":"300000410","Phoenix_SAP_Pack_Size__c":"30","Phoenix_Product_Family__c":"NOT REQUIRED","Phoenix_SAP_Sub_Therapy_Description__c":"SSRI","Phoenix_SAP_Therapy_Description__c":"Anti-Depressant","Phoenix_Shelf_Life__c":"690","Phoenix_Strength__c":"100mg","Phoenix_WAC__c":"0","Phoenix_GTIN_14__c":"123"}]}}';
        req.requestBody= Blob.valueOf(body);
        RestContext.request = req;
        
        Test.startTest();
        Phoenix_SAP_Products_REST.productCreationToStaging();
        
        Test.stopTest();
    }
    
    static testmethod void test_fail(){
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SAP_Products'; 
        req.httpMethod = 'POST';
        String body ='{"ns1:MT_Material":{"ProductDetails":[{"Phoenix_Active_Discontinue__c":"","Phoenix_Case_Pack__c":"12222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222","Phoenix_Controlled_Substance_Class__c":"","Phoenix_Controlled_Substance__c":"N","Phoenix_SAP_Created_Date__c":"","Phoenix_DLS_formerly_NDC__c":"","Phoenix_Dosage_Form__c":"TABLETS","Phoenix_Imported_or_Domestic__c":"","Phoenix_Material_Description__c":"Sertraline Tablets 100mg, 500","Phoenix_Minimum_Order_Quantity__c":"0","Phoenix_Status__c":"Invalid","Phoenix_SAP_Modified_Date__c":"","Phoenix_NDC__c":"5555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111111110000001111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011117505555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555","Phoenix_SAP_Molecule_Description__c":"Sertraline","Phoenix_SAP_Number__c":"300000396","Phoenix_SAP_Pack_Size__c":"500","Phoenix_Product_Family__c":"NOT REQUIRED","Phoenix_SAP_Sub_Therapy_Description__c":"SSRI","Phoenix_SAP_Therapy_Description__c":"Anti-Depressant","Phoenix_Shelf_Life__c":"690","Phoenix_Strength__c":"100mg","Phoenix_WAC__c":"0","Phoenix_GTIN_14__c":"123"},{"Phoenix_Active_Discontinue__c":"","Phoenix_Case_Pack__c":"24","Phoenix_Controlled_Substance_Class__c":"","Phoenix_Controlled_Substance__c":"N","Phoenix_SAP_Created_Date__c":"","Phoenix_DLS_formerly_NDC__c":"","Phoenix_Dosage_Form__c":"TABLETS","Phoenix_Imported_or_Domestic__c":"","Phoenix_Material_Description__c":"Sertraline Tablets 100mg, 30","Phoenix_Minimum_Order_Quantity__c":"0","Phoenix_SAP_Modified_Date__c":"","Phoenix_NDC__c":"2500040","Phoenix_SAP_Molecule_Description__c":"Sertraline","Phoenix_SAP_Number__c":"300000410","Phoenix_SAP_Pack_Size__c":"30","Phoenix_Product_Family__c":"NOT REQUIRED","Phoenix_SAP_Sub_Therapy_Description__c":"SSRI","Phoenix_SAP_Therapy_Description__c":"Anti-Depressant","Phoenix_Shelf_Life__c":"690","Phoenix_Strength__c":"100mg","Phoenix_WAC__c":"0","Phoenix_GTIN_14__c":"123"}]}}';
        
        req.requestBody= Blob.valueOf(body);
        RestContext.request = req;
        
        Test.startTest();
        Phoenix_SAP_Products_REST.productCreationToStaging();
        Test.stopTest();
    }
    
    static testmethod void test_NoProdData(){
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SAP_Products'; 
        req.httpMethod = 'POST';
        String body = '{"ns:MT_Material":{"ProductDetails":[{"Phoenix_Active_Discontinue__c":"","Phoenix_Case_Pack__c":"12","Phoenix_Controlled_Substance_Class__c":"","Phoenix_Controlled_Substance__c":"N","Phoenix_SAP_Created_Date__c":"","Phoenix_DLS_formerly_NDC__c":"","Phoenix_Dosage_Form__c":"TABLETS","Phoenix_Imported_or_Domestic__c":"","Phoenix_Material_Description__c":"Sertraline Tablets 100mg, 500","Phoenix_Minimum_Order_Quantity__c":"0","Phoenix_SAP_Modified_Date__c":"","Phoenix_NDC__c":"5511117505","Phoenix_SAP_Molecule_Description__c":"Sertraline","Phoenix_SAP_Number__c":"300000396","Phoenix_SAP_Pack_Size__c":"500","Phoenix_Product_Family__c":"NOT REQUIRED","Phoenix_SAP_Sub_Therapy_Description__c":"SSRI","Phoenix_SAP_Therapy_Description__c":"Anti-Depressant","Phoenix_Shelf_Life__c":"690","Phoenix_Strength__c":"100mg","Phoenix_WAC__c":"0"},{"Phoenix_Active_Discontinue__c":"","Phoenix_Case_Pack__c":"24","Phoenix_Controlled_Substance_Class__c":"","Phoenix_Controlled_Substance__c":"N","Phoenix_SAP_Created_Date__c":"","Phoenix_DLS_formerly_NDC__c":"","Phoenix_Dosage_Form__c":"TABLETS","Phoenix_Imported_or_Domestic__c":"","Phoenix_Material_Description__c":"Sertraline Tablets 100mg, 30","Phoenix_Minimum_Order_Quantity__c":"0","Phoenix_SAP_Modified_Date__c":"","Phoenix_NDC__c":"2500040","Phoenix_SAP_Molecule_Description__c":"Sertraline","Phoenix_SAP_Number__c":"300000410","Phoenix_SAP_Pack_Size__c":"30","Phoenix_Product_Family__c":"NOT REQUIRED","Phoenix_SAP_Sub_Therapy_Description__c":"SSRI","Phoenix_SAP_Therapy_Description__c":"Anti-Depressant","Phoenix_Shelf_Life__c":"690","Phoenix_Strength__c":"100mg","Phoenix_WAC__c":"0"}]}}';
        req.requestBody= Blob.valueOf(body);
        RestContext.request = req;
        
        Test.startTest();
        Phoenix_SAP_Products_REST.productCreationToStaging();
        Test.stopTest();  
    }
 
    static testmethod void test_noData(){
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SAP_Products'; 
        req.httpMethod = 'POST';
        String body = '';
        req.requestBody= Blob.valueOf(body);
        RestContext.request = req;
        
        Test.startTest();
        Phoenix_SAP_Products_REST.productCreationToStaging();
        Test.stopTest();   
        
    }
    
}