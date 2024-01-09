@isTest
public class VisionProductPipelineCls_Test {
    static testmethod void  test1(){
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
          
        Attachment attach=new Attachment();   	
    	attach.Name='Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=acc.Id;
        insert attach;
    	
    	List<Attachment> attachments=[select id, name from Attachment where parent.Id=:acc.Id];
        
        VisionProductPipelineCls.getAccountInPreview(acc.Id);
        VisionProductPipelineCls.getProductPipelines();
        VisionProductPipelineCls.fetchSortResults('Vision_Segment__c', true,new List<Product_Pipeline__c>{pipe,pipe1});
        VisionProductPipelineCls.getSearch(new List<Product_Pipeline__c>{pipe,pipe1}, 'Rx', new List<String>{'Rx','SRx'});
      VisionProductPipelineCls.getAccounts();
        VisionProductPipelineCls.getOTCData(new List<Product_Pipeline__c>{pipe,pipe1});
        Map<String , boolean> testMap = new Map<String , boolean>();
        testMap.put('alp',true);
        VisionProductPipelineCls.getFilterAccounts('alp', testMap);
         list < string > RxSrxList1 = new list < string > ();
        RxSrxList1.add('Rx');
        RxSrxList1.add('SRx');
         string search = 'Test';
      //VisionProductPipelineCls.findBySrxOtc(RxSrxList1, search, new List<Product_Pipeline__c>{pipe,pipe1});
        //VisionProductPipelineCls.generateDocument(new List<Product_Pipeline__c>{pipe,pipe1}, new List<String>{acc.Id},new List<String>{'Vision_Segment__c'});
        VisionProductPipelineCls.generateDocument(new List<Product_Pipeline__c>{pipe,pipe1});
        VisionProductPipelineCls.getOTCData(new List<Product_Pipeline__c>{pipe,pipe1});
    }
}