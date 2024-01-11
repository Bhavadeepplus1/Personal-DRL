@isTest
public class DocumentCls_Test {
    static testmethod void  test(){
          Account acc = new Account();
        acc.Name='Alphine Health';
        acc.Phoenix_Is_Bid_Account__c = true;
        acc.OwnerId = userInfo.getUserId();
        insert acc;
        Product_Pipeline__c pipe = new Product_Pipeline__c();
        pipe.Vision_Segment__c ='Rx';
        pipe.Account__c = acc.Id;
        insert pipe;
        Product_Pipeline__c pipe1 = new Product_Pipeline__c();
        pipe1.Vision_Segment__c ='Rx';
        pipe1.Account__c = acc.Id;
        insert pipe1;
        Product_Pipeline__c pipe2 = new Product_Pipeline__c();
        pipe2.Vision_Segment__c ='Rx';
        pipe2.Account__c = acc.Id;
        insert pipe2;
        DocumentCls controller = new DocumentCls();
        controller.DocumentCls();
        
    }
}