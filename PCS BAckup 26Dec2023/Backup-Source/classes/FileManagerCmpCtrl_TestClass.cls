@isTest
public class FileManagerCmpCtrl_TestClass {
    
    @testSetup    
    private static void createTestData() {
        ContentWorkspace testWorkspace = new ContentWorkspace(Name='TEST CLASS', DeveloperName='TEST_CLASS');
        insert testWorkspace;

    }
    
    @isTest
    private static void testGetFilesList(){
        
        
        Account accrecord = New Account();
        accrecord.Name='Test account 1';
        Insert accrecord;
        
        List<Contact> conlist=new List<Contact>();
        Contact con = new Contact();
        con.LastName='testcontact';
        con.Email='test@mail.com';
        conlist.add(con);
        
        Contact con1 = new Contact();
        con1.LastName='testcontact1';
        con1.Email='test1@mail.com';
        conlist.add(con1);
        
        Contact con2 = new Contact();
        con2.LastName='testcontact2';
        con2.Email='test2@mail.com';
        conlist.add(con2);
        
        Insert conlist;
        
        ContentWorkspace testWorkspace = [Select Id from ContentWorkspace where Name = 'TEST CLASS'];
        
        ContentFolder workspaceFolder = [Select Id from ContentFolder where Name =: testWorkspace.Id];
        
        ContentFolder testFolderRecord = new ContentFolder(Name='TEST FOLDER', ParentContentFolderId=workspaceFolder.Id);
        insert testFolderRecord;
        
        ContentFolder testFolderRecord1 = new ContentFolder(Name='TEST FOLDER 1');
        insert testFolderRecord1;
        
        ContentFolder testFolderRecord2 = new ContentFolder(Name='TEST FOLDER 2', ParentContentFolderId=workspaceFolder.Id);
        insert testFolderRecord2;
        
        ContentFolder testFolderRecord3 = new ContentFolder(Name='TEST FOLDER 3', ParentContentFolderId=workspaceFolder.Id);
        insert testFolderRecord3;
        

        
        set <Id> ids = new set<Id> {testFolderRecord2.id,testFolderRecord3.id};
            
            String filesIdArrStr = json.serialize(ids);
        
        
        
        ContentVersion contentVersion_1 = new ContentVersion(
            
            Title='SampleTitle',           
            PathOnClient ='SampleTitle.jpg',       
            VersionData = Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the'), 
            origin = 'H'
        );
        insert contentVersion_1;
        ContentVersion contentVersion_2 = new ContentVersion(
            
            Title='SampleTitle',           
            PathOnClient ='SampleTitle.jpg',       
            VersionData = Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the'), 
            origin = 'H'
        );
        
        insert contentVersion_2;
        
        ContentVersion contentVersion_3 = new ContentVersion(
            
            Title='SampleTitle',           
            PathOnClient ='SampleTitle.jpg',       
            VersionData = Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the'), 
            origin = 'H'
        );
        
        insert contentVersion_3;
        
       
        
        ContentVersion contentVersion_4 = [SELECT Id, Title, ContentDocumentId  FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        ContentVersion contentVersion_5 = [SELECT Id, Title, ContentDocumentId  FROM ContentVersion WHERE Id = :contentVersion_2.Id LIMIT 1];
        ContentVersion contentVersion_6 = [SELECT Id, Title, ContentDocumentId  FROM ContentVersion WHERE Id = :contentVersion_3.Id];
        ContentVersion contentVersion_7 = [SELECT Id, Title, ContentDocumentId  FROM ContentVersion WHERE Id = :contentVersion_3.Id];
        
        set <Id> ids1 = new set<Id>{contentVersion_6.contentdocumentid,contentVersion_7.contentdocumentid};
         String filesIdArrStr1 = json.serialize(ids1);
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = accRecord.id;
        contentlink.contentdocumentid = contentVersion_4.contentdocumentid;
        contentlink.ShareType = 'V';
        
        insert contentlink;
    
        Set<String> emailSet = new Set<String>{'abc123@mail.com'};
            Set<String> emailCCSet = new Set<String>{'cde456@mail.com','fgh789@mail.com'};
                
                String toMail=json.serialize(emailSet);
        String ccMail=json.serialize(emailCCSet);
        String subject='sample testing';
        String body='This is just for testing the data';
        
        FileManagerCmpCtrl.emailPublicLink epl = new FileManagerCmpCtrl.emailPublicLink();
        epl.name='test';
        epl.publicLink='testlink';
        
        FileManagerCmpCtrl.checkLibraryAccess();
        FileManagerCmpCtrl.getRecords();
        FileManagerCmpCtrl.getRecordsUpdated(workspaceFolder.id,'My File');
        FileManagerCmpCtrl.getRecordsDeleted(workspaceFolder.id,testFolderRecord1.id);
        FileManagerCmpCtrl.getDocItemDeleted(workspaceFolder.id,contentVersion_4.contentdocumentid);
        
        FileManagerCmpCtrl.deleteFiles(filesIdArrStr1);
        FileManagerCmpCtrl.updateFolderMember(filesIdArrStr,testFolderRecord.id);
        FileManagerCmpCtrl.getFolItems(testFolderRecord.id);
        FileManagerCmpCtrl.getSearchFolItems(workspaceFolder.id,'FOLDER');
        FileManagerCmpCtrl.getSearchFolItems(workspaceFolder.id,'');
        
        FileManagerCmpCtrl.getPublicLink(contentVersion_5.contentdocumentid,toMail,ccMail,subject,body);
        FileManagerCmpCtrl.updateName(testFolderRecord.id,'My New File');
        FileManagerCmpCtrl.getEmailStatus(contentVersion_5.contentdocumentid);
        FileManagerCmpCtrl.fetchLookUpValues('test', 'Contact', conlist, conlist);
       //Delete contentVersion_2;
    }
    
    

    
}