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
public class Phoenix_SAP_Customers_REST_Test {
    
    static testmethod void test_success(){
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SAP_Customers'; 
        req.httpMethod = 'POST';
        String body = '{"ns1:MT_Customer":{"records":[{"Phoenix_City__c":"Houston","Phoenix_Country__c":"US","Phoenix_Distribution_Channel__c":"77","Phoenix_Division__c":"31","Phoenix_Effective_From__c":"0000-00-00","Phoenix_Effective_To__c":"0000-00-00","Phoenix_Parent_SAP_Customer__c":"12","Phoenix_Parent_SAP_Customer_Code__c":"10","Phoenix_Partner_Function__c":"WE","Phoenix_Postal_Code__c":"77030","Phoenix_Region__c":"TX","Phoenix_Sales_Organization__c":"1007","Phoenix_SAP_Created_Date__c":"2020-08-04","Phoenix_SAP_Customer_Code__c":"0000149779","Phoenix_SAP_Customer_Group__c":"A1","Phoenix_SAP_Customer_Name_2__c":"Phoenix_SAP_Customer_Name_2__c","Phoenix_SAP_Modified_Date__c":"2020-08-04","Phoenix_SAP_Customer_Name__c":"University of Texas - MD Anderson","Phoenix_Street__c":"1515 Holcombe Blvad"},{"Phoenix_City__c":"Cleveland","Phoenix_Country__c":"US","Phoenix_Distribution_Channel__c":"77","Phoenix_Division__c":"31","Phoenix_Effective_From__c":"0000-00-00","Phoenix_Effective_To__c":"0000-00-00","Phoenix_Parent_SAP_Customer__c":"","Phoenix_Parent_SAP_Customer_Code__c":"10","Phoenix_Partner_Function__c":"WE","Phoenix_Postal_Code__c":"44106","Phoenix_Region__c":"OH","Phoenix_Sales_Organization__c":"1007","Phoenix_SAP_Created_Date__c":"2020-08-04","Phoenix_SAP_Customer_Code__c":"0000161410","Phoenix_SAP_Customer_Group__c":"A1","Phoenix_SAP_Customer_Name_2__c":"","Phoenix_SAP_Modified_Date__c":"","Phoenix_SAP_Customer_Name__c":"University Hospital of Cleveland","Phoenix_Street__c":"11100 Euclid Ave"}]}}';
        req.requestBody= Blob.valueOf(body);
        RestContext.request = req;
        
        Test.startTest();
        Phoenix_SAP_Customers_REST.CustomerCreationToStaging();
        Test.stopTest();
    }
    
    static testmethod void test_error(){
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SAP_Customers'; 
        req.httpMethod = 'POST';
        String body = '{"ns1:MT_Customer":{"records":[{"Phoenix_City__c":"Houston","Phoenix_Country__c":"US","Phoenix_Distribution_Channel__c":"77","Phoenix_Division__c":"31","Phoenix_Effective_From__c":"0000-00-00","Phoenix_Effective_To__c":"0000-00-00","Phoenix_Parent_SAP_Customer__c":"10","Phoenix_Parent_SAP_Customer_Code__c":"10","Phoenix_Partner_Function__c":"WEB","Phoenix_Postal_Code__c":"77030","Phoenix_Region__c":"TX","Phoenix_Sales_Organization__c":"1007","Phoenix_SAP_Created_Date__c":"2020-08-04","Phoenix_SAP_Customer_Code__c":"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000149779","Phoenix_SAP_Customer_Group__c":"A1","Phoenix_SAP_Customer_Name_2__c":"Phoenix_SAP_Customer_Name_2__c","Phoenix_SAP_Modified_Date__c":"0000-00-00","Phoenix_SAP_Customer_Name__c":"University of Texas - MD Anderson","Phoenix_Street__c":"1515 Holcombe Blvad"},{"Phoenix_City__c":"Cleveland","Phoenix_Country__c":"US","Phoenix_Distribution_Channel__c":"77","Phoenix_Division__c":"31","Phoenix_Effective_From__c":"0000-00-00","Phoenix_Effective_To__c":"0000-00-00","Phoenix_Parent_SAP_Customer__c":"Phoenix_Parent_SAP_Customer__c","Phoenix_Parent_SAP_Customer_Code__c":"10","Phoenix_Partner_Function__c":"WE","Phoenix_Postal_Code__c":"44106","Phoenix_Region__c":"OH","Phoenix_Sales_Organization__c":"1007","Phoenix_SAP_Created_Date__c":"2020-08-04","Phoenix_SAP_Customer_Code__c":"0000161410","Phoenix_SAP_Customer_Group__c":"A1","Phoenix_SAP_Customer_Name_2__c":"Phoenix_SAP_Customer_Name_2__c","Phoenix_SAP_Modified_Date__c":"2020-08-04","Phoenix_SAP_Customer_Name__c":"University Hospital of Cleveland","Phoenix_Street__c":"11100 Euclid Ave"}]}}';
        req.requestBody= Blob.valueOf(body);
        RestContext.request = req;
        
        Test.startTest();
        Phoenix_SAP_Customers_REST.CustomerCreationToStaging();
        Test.stopTest();
    }
    
    static testmethod void test_NoCusData(){
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SAP_Customers'; 
        req.httpMethod = 'POST';
        String body = '{"ns:MT_Customer":{"records":[{"Phoenix_City__c":"Houston","Phoenix_Country__c":"US","Phoenix_Distribution_Channel__c":"77","Phoenix_Division__c":"31","Phoenix_Effective_From__c":"0000-00-00","Phoenix_Effective_To__c":"0000-00-00","Phoenix_Parent_SAP_Customer__c":"","Phoenix_Parent_SAP_Customer_Code__c":"","Phoenix_Partner_Function__c":"WE","Phoenix_Postal_Code__c":"77030","Phoenix_Region__c":"TX","Phoenix_Sales_Organization__c":"1007","Phoenix_SAP_Created_Date__c":"2020-08-04","Phoenix_SAP_Customer_Code__c":"0000149779","Phoenix_SAP_Customer_Group__c":"A1","Phoenix_SAP_Customer_Name_2__c":"Phoenix_SAP_Customer_Name_2__c","Phoenix_SAP_Modified_Date__c":"2020-08-04","Phoenix_SAP_Customer_Name__c":"University of Texas - MD Anderson","Phoenix_Street__c":"1515 Holcombe Blvad"},{"Phoenix_City__c":"Cleveland","Phoenix_Country__c":"US","Phoenix_Distribution_Channel__c":"77","Phoenix_Division__c":"31","Phoenix_Effective_From__c":"0000-00-00","Phoenix_Effective_To__c":"0000-00-00","Phoenix_Parent_SAP_Customer__c":"Phoenix_Parent_SAP_Customer__c","Phoenix_Parent_SAP_Customer_Code__c":"10","Phoenix_Partner_Function__c":"WE","Phoenix_Postal_Code__c":"44106","Phoenix_Region__c":"OH","Phoenix_Sales_Organization__c":"1007","Phoenix_SAP_Created_Date__c":"2020-08-04","Phoenix_SAP_Customer_Code__c":"0000161410","Phoenix_SAP_Customer_Group__c":"A1","Phoenix_SAP_Customer_Name_2__c":"Phoenix_SAP_Customer_Name_2__c","Phoenix_SAP_Modified_Date__c":"2020-08-04","Phoenix_SAP_Customer_Name__c":"University Hospital of Cleveland","Phoenix_Street__c":"11100 Euclid Ave"}]}}';
        req.requestBody= Blob.valueOf(body);
        RestContext.request = req;
        
        Test.startTest();
        Phoenix_SAP_Customers_REST.CustomerCreationToStaging();
        Test.stopTest();
    }
    static testmethod void test_noData(){
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SAP_Customers'; 
        req.httpMethod = 'POST';
        String body = '';
        req.requestBody= Blob.valueOf(body);
        RestContext.request = req;
        
        Test.startTest();
        Phoenix_SAP_Customers_REST.CustomerCreationToStaging();
        Test.stopTest();
    }
    
}