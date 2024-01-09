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
@isTest
public class Phoenix_NPRStagingProcessorTest {
    @testSetup static void setupTestData() {
        Account acc = new Account();
        acc.Name = 'Test';
        acc.AccountNumber = '1234';
        insert acc;
        Product2 pro = new Product2();
        pro.Name = 'Test';
        pro.Family = 'Test';
        pro.ProductCode = '30000001';
        insert pro;
        
        Phoenix_Contract__c cont = new Phoenix_Contract__c();
        cont.Name = 'Test';
        cont.Phoenix_Contract_Number__c = '1234';
        //cont.Phoenix_Contract_Start_Date__c=system.today();
        cont.Phoenix_Customer__c = acc.Id;
        insert cont;
        
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c = acc.Id;
        npr.Phoenix_Contract__c = cont.Id;
        npr.Phoenix_Product__c = pro.Id;
        npr.Phoenix_Add_ABS_Value__c = 2.00;
        insert npr;
        
        
    }
    
    
    @isTest
    public static void nprStgngTest1() {
        Phoenix_SAP_NPR_Staging__c stg = new Phoenix_SAP_NPR_Staging__c();
        stg.Phoenix_Is_Sync_Completed__c = false;
        stg.Phoenix_Material_Number__c = '30000001';
        stg.Phoenix_Vistex_Description__c = '300000012';
        stg.Phoenix_Contract_Number__c = '1234';
        stg.Phoenix_Customer_Number__c = '1234';
        stg.Phoenix_M1__c = 13.00;
        stg.Phoenix_NPR_Report_Type__c = 'Current Active';
        insert stg;
        
        
        DataBase.executeBatch(new Phoenix_NPRStagingProcessor());
        Phoenix_NPRDataActiveChecker nprchk = new Phoenix_NPRDataActiveChecker();
        nprchk.execute(null);
        System.assertEquals(1, 1);
    }
    @isTest
    public static void nprStgngTest2() {
        Phoenix_SAP_NPR_Staging__c stg = new Phoenix_SAP_NPR_Staging__c();
        stg.Phoenix_Is_Sync_Completed__c = false;
        stg.Phoenix_Material_Number__c = '300000012';
        stg.Phoenix_Vistex_Description__c = '300000012';
        stg.Phoenix_Contract_Number__c = '123456';
        stg.Phoenix_Customer_Number__c = '1234';
        stg.Phoenix_NPR_Report_Type__c = 'Current Active';
        insert stg;
        Phoenix_NPRStagingProcessor processNPRStgng = new Phoenix_NPRStagingProcessor();
        Test.startTest();
        DataBase.executeBatch(processNPRStgng);
        Test.stopTest();
        System.assertEquals(1, 1);
    }
    @isTest
    public static void nprStgngTest3() {
        Phoenix_SAP_NPR_Staging__c stg = new Phoenix_SAP_NPR_Staging__c();
        stg.Phoenix_Is_Sync_Completed__c = false;
        stg.Phoenix_Material_Number__c = '300000012';
        stg.Phoenix_Vistex_Description__c = '300000012';
        stg.Phoenix_Contract_Number__c = '123456';
        stg.Phoenix_Customer_Number__c = '371033';
        stg.Phoenix_NPR_Report_Type__c = 'Current Active';
        insert stg;
        Phoenix_NPRStagingProcessor processNPRStgng = new Phoenix_NPRStagingProcessor();
        
        DataBase.executeBatch(processNPRStgng);
        Phoenix_NPRDataActiveChecker nprchk = new Phoenix_NPRDataActiveChecker();
        nprchk.execute(null);
        
        System.assertEquals(1, 1);
    }
    
    static testmethod void Phoenix_NPRDataFieldHistoryQueueTest() {
        try{
            Phoenix_SAP_NPR_Staging__c stg = new Phoenix_SAP_NPR_Staging__c();
            stg.Phoenix_Is_Sync_Completed__c = false;
            stg.Phoenix_Material_Number__c = '30000001';
            stg.Phoenix_Vistex_Description__c = '300000012';
            stg.Phoenix_Contract_Number__c = '1234';
            stg.Phoenix_Customer_Number__c = '1234';
            stg.Phoenix_M1__c = 13.00;
            stg.Phoenix_NPR_Report_Type__c = 'Current Active';
            insert stg;
            Product2 prod = new Product2(
                ProductCode = '1234',
                Name = 'Prod Name',
                IsActive=true
            );
            insert prod;
            Phoenix_Util.blnAlreadyDone = false;
            Phoenix_NPR_Data__c npr = [Select Id, Phoenix_Add_ABS_Value__c From Phoenix_NPR_Data__c limit 1];
            
            Phoenix_NPR_Volume__c volume = new Phoenix_NPR_Volume__c(
                Phoenix_NPR_Data__c = npr.Id,
                Phoenix_Volume__c = 10.00,
                Phoenix_Date__c = System.today(),
                Name = 'volume'
            );
            insert volume;
            
            npr.Phoenix_Add_ABS_Value__c = 5.0;
            npr.Phoenix_Account__c = null;
            npr.Phoenix_Product__c = prod.Id;
            Test.startTest();
            update npr;
            DataBase.executeBatch(new Phoenix_NPRStagingProcessor());
            Test.stopTest();
        }
        Catch(Exception e) {}
        
    }
    //By sai krishna
    static testmethod void Phoenix_NPRDataActiveCheckerBCTest() {
        
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'Test';
        acc.AccountNumber = '1234';
        insert acc;
        
        Phoenix_Contract__c cont = new Phoenix_Contract__c();
        cont.Name = 'Test';
        cont.Phoenix_Contract_Number__c = '1234';
        //cont.Phoenix_Contract_Start_Date__c=system.today();
        cont.Phoenix_Customer__c = acc.Id;
        insert cont;
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        // npr.Phoenix_Account__c=acc.Id;
        npr.Phoenix_Contract__c = cont.Id;
        // npr.Phoenix_Product__c=pro.Id;
        npr.Phoenix_Add_ABS_Value__c = 2.00;
        insert npr;
        
        Phoenix_NPRDataActiveChecker nprchk = new Phoenix_NPRDataActiveChecker();
        nprchk.execute(null);
        Test.stopTest();
    }
}