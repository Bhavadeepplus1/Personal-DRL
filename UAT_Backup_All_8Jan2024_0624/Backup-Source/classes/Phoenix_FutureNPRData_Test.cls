@isTest
public class Phoenix_FutureNPRData_Test {
    @isTest static void Test(){
        Account acc = new Account();
        acc.Name = 'Test acc';
        Insert acc;
        Phoenix_Contract__c cont = new Phoenix_Contract__c();
        cont.Name = '1234567';
        Insert cont;
        Product2 prod = new Product2();
        prod.Name ='test';
        prod.Phoenix_Pkg_Size__c=23;
        prod.Phoenix_NDC__c='2345';
        prod.Phoenix_Throughput_cost__c=45;
        insert prod;
        Phoenix_Future_NPR_Data__c fNPR = new Phoenix_Future_NPR_Data__c();
         fNPR.Phoenix_Contract__c =  cont.id;
          fNPR.Phoenix_Product__c = prod.id;
        Phoenix_FutureNPRData.futureNPR(prod.id);
    }
    
    
}