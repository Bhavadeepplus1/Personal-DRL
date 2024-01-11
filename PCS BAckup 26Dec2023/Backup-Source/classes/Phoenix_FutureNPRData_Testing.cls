@isTest
public class Phoenix_FutureNPRData_Testing{
    @isTest static void TestFutureNPRWrapper(){
        Account acc = new Account();
        acc.Name = 'Sri';
        insert acc;
        Phoenix_Contract__c	 cont=new Phoenix_Contract__c();
        cont.Name = 'ashu';
        insert cont;
        Product2 prod = new Product2();
        prod.Name = 'Alloprinol';
        prod.Phoenix_NDC__c = '123';
        prod.Phoenix_Pkg_Size__c = 1231 ;
        prod.Phoenix_Throughput_cost__c = 1564;
        insert prod;
        Phoenix_Future_NPR_Data__c testRecord = new Phoenix_Future_NPR_Data__c();
        testRecord.Phoenix_NPR_Status__c = 'Active';
        testRecord.Phoenix_Product__c= prod.Id;
        testRecord.Phoenix_Contract__c= cont.Id;
        insert testRecord;
     Phoenix_FutureNPRData.futureNPR(prod.Id);
        
    }
}