@isTest(seeAlldata=true)
public class Vision_DynamicPanoramaTasksTest {
    static testmethod void method1(){
        Account acc = new Account();
        acc.Name = 'testAcc';
        insert acc;
        
        product2 prod = new product2();
        prod.Name = 'test';
        prod.Phoenix_Pkg_Size__c = 10;
        insert prod;
        
        Vision_Market_Share_Expansion__c obj = new Vision_Market_Share_Expansion__c();
        obj.Vision_Customer__c =  acc.Id;
        obj.Vision_Product__c = prod.Id;
        obj.Task_Status__c = 'New';
        obj.Target_Price__c = 10;
        obj.Target_Volume__c =100;
        obj.Task_Type__c = 'testType';
        obj.Target_Dollar__c =100;
        insert obj;
        
        obj.Target_Price__c = 15;
        obj.Target_Volume__c =150;
        obj.Task_Type__c = 'testType Updated';
        obj.Target_Dollar__c =150;
        update obj;
    }
}