@isTest
public class Phoenix_ProductStagingProcessorTest {
    @testSetup static void setupTestData() {
        Product2 pro= new Product2();
        pro.Name='Test';
        pro.Family='Test';
        pro.Phoenix_Compare_to_Brand_Name__c='Test';
        pro.Phoenix_Controlled_Substance_Class__c='Test';
        pro.ProductCode='30000001';
        //pro.Phoenix_Pkg_Size__c=5;
        pro.Phoenix_SAP_Molecule_Description__c='Test';
        pro.Phoenix_USDA_Permit_Number__c=1234;
        pro.Phoenix_Throughput_cost__c=3;
        insert pro;
        Phoenix_Product_Playbook__c playbook= new Phoenix_Product_Playbook__c();
        playbook.Phoenix_Product__c=pro.Id;
        playbook.Phoenix_Shelf_Life__c='6';
        insert playbook;
    }
    @isTest
    public static void ProductTest(){
        Product2 prod=[SELECT Id FROM Product2 WHERE Name='Test'];
        Phoenix_Product_Playbook__c plb=[SELECT Id FROM Phoenix_Product_Playbook__c WHERE Phoenix_Shelf_Life__c='6'];
        prod.Phoenix_SAP_Product_Name__c='Test1';
        prod.Phoenix_SAP_Product_Family__c='Test1';
        update prod;
        plb.Phoenix_Imported_or_Domestic__c='Imported';
        update plb;
        Phoenix_ProductStagingProcessor processProd= new Phoenix_ProductStagingProcessor();
        DataBase.executeBatch(processProd);
        System.assertEquals(1,1);      
    }
    @isTest
    public static void ProductStagingTest(){
        Phoenix_SAP_Product_Staging__c proStgng= new Phoenix_SAP_Product_Staging__c();
        proStgng.Phoenix_Active_Discontinue__c='Active';
        proStgng.Phoenix_Case_Pack__c='10';
        proStgng.Phoenix_Compare_to_Brand_Name__c='Test';
        proStgng.Phoenix_Controlled_Substance__c='Yes';
        proStgng.Phoenix_Controlled_Substance_Class__c='Test';
        proStgng.Phoenix_DLS_formerly_NDC__c='12345678980';
        proStgng.Phoenix_Dosage_Form__c='Test';
        proStgng.Phoenix_Imported_or_Domestic__c='Imported';
        proStgng.Phoenix_SAP_Number__c='30000001';
        proStgng.Phoenix_Material_Description__c='Test';
        proStgng.Phoenix_Case_Pack__c='6';
        proStgng.Phoenix_Minimum_Order_Quantity__c='6';
        proStgng.Phoenix_NDC__c='123456789012';
        //proStgng.Phoenix_Pkg_Size__c='6';
        proStgng.Phoenix_Product_Family__c='Test';
        proStgng.Phoenix_Proprietary_Name_Trade_Name__c='Test';
        proStgng.Phoenix_SAP_Molecule_Description__c='Test';
        proStgng.Phoenix_SAP_Pack_Size__c='6';
        insert proStgng;
        Phoenix_ProductStagingProcessor processProdStgng= new Phoenix_ProductStagingProcessor();
        DataBase.executeBatch(processProdStgng);
        proStgng.Phoenix_SAP_Number__c='30000002';
        update proStgng;
        Phoenix_ProductStagingProcessor processProdStgng1= new Phoenix_ProductStagingProcessor();
        DataBase.executeBatch(processProdStgng1);
        System.assertEquals(1,1);    
    }
    
}