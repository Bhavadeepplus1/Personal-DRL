@isTest
public class PipelineNotificationCls_Test {
 static testmethod void test() {
     Product_Pipeline__c  productPipe= new Product_Pipeline__c ();
productPipe.Vision_Reporting_Molecule__c='test';
     insert productPipe;
     Document document;

    document = new Document();
    document.Body = Blob.valueOf('Some Text');
    document.ContentType = 'application/pdf';
    document.DeveloperName = 'Vision_Logo';
    document.IsPublic = true;
    document.Name = 'My Document';
    document.FolderId = UserInfo.getUserId();//[select id from folder where name = 'My Test Docs'].id;
    insert document;

     PipelineNotificationCls.notifyUsers(3);
}
}