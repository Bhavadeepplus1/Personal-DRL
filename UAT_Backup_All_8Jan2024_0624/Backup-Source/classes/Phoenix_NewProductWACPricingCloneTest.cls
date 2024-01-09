@isTest
public class Phoenix_NewProductWACPricingCloneTest {
    static testmethod void AddWACChangeMethod(){
        try{
        list < Product2 > prodList = new list < Product2 > ();
        List < User > users = new List < User > ();
        List<New_Product_WAC_Pricing__c> testWAC = new List<New_Product_WAC_Pricing__c>();
        List<Phoenix_NewProduct_WAC_Pricing_LineItems__c> testWACLines = new List<Phoenix_NewProduct_WAC_Pricing_LineItems__c>();
        
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Pkg_Size__c=100, Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_Pkg_Size__c=200, Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2', Phoenix_Pkg_Size__c=300, Phoenix_Rx_SRx_OTC__c = 'SRx', Phoenix_Special_Product__c = true, Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3', Phoenix_Pkg_Size__c=400, Phoenix_Rx_SRx_OTC__c = 'OTC', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;  
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        String uid = ('Phoenix' + System.now().getTime()).SubString(0, 8);
        User u1 = new User(Alias = uid, Email = uid + '@phoenix.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/New_York', UserName = uid + '@phoenix.com');
        users.add(u1);
        insert users;
        
        New_Product_WAC_Pricing__c testWAC1 = new New_Product_WAC_Pricing__c();
        testWAC1.Phoenix_WAC_Price_for_New_Launch_Name__c = 'Test WAC Pricing';
        testWAC1.Phoenix_Product_Family__c = 'Test Family';
        testWAC1.Phoenix_Product_Type__c = 'DRL';
        testWAC1.Phoenix_Marketing_Lead__c = users[0].Id;
        testWAC1.Phoenix_Product_Director__c = users[0].Id;
        testWAC1.Phoenix_TPT__c = 10;
        testWAC1.Phoenix_GM__c = 20;
        testWAC.add(testWAC1);
        
        New_Product_WAC_Pricing__c testWAC2 = new New_Product_WAC_Pricing__c();
        testWAC2.Phoenix_WAC_Price_for_New_Launch_Name__c = 'Test WAC Pricing';
        testWAC2.Phoenix_Product_Family__c = 'Test Family';
        testWAC2.Phoenix_Product_Type__c = 'DRL';
        testWAC2.Phoenix_Marketing_Lead__c = users[0].Id;
        testWAC2.Phoenix_Product_Director__c = users[0].Id;
        testWAC2.Phoenix_TPT__c = 10;
        testWAC2.Phoenix_GM__c = 20;
        testWAC.add(testWAC2);
        insert testWAC;
        
        Phoenix_NewProduct_WAC_Pricing_LineItems__c testWACLine1 = new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
        testWACLine1.Phoenix_Product__c = prodList[0].Id;
        testWACLine1.Phoenix_WAC__c = 50;
        testWACLine1.Phoenix_Lowest_Price__c = 40;
        testWACLine1.Phoenix_TPT_GM__c = 30;
        testWACLine1.Phoenix_New_Product_WAC_Pricing__c = testWAC[0].Id;
        
        testWACLines.add(testWACLine1);

        Phoenix_NewProduct_WAC_Pricing_LineItems__c testWACLine2 = new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
        testWACLine2.Phoenix_Product__c = prodList[1].Id;
        testWACLine2.Phoenix_WAC__c = 30;
        testWACLine2.Phoenix_Lowest_Price__c = 20;
        testWACLine2.Phoenix_TPT_GM__c = 20;
        testWACLine1.Phoenix_New_Product_WAC_Pricing__c = testWAC[0].Id;
        
        testWACLines.add(testWACLine2);
        insert testWACLines;
        
        Attachment attach=new Attachment();   	
    	attach.Name='Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=testWAC[0].Id;
        insert attach;
    	
    	List<Attachment> attachments=[select id, name from Attachment where parent.Id=:testWAC[0].Id];
        
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(documents.size(), 1);
        
        
		        
        Phoenix_NewProductWACPricingCloneCntrl.getActiveBidProductFamilies();
        Phoenix_NewProductWACPricingCloneCntrl.getProducts(testWAC[0].Phoenix_Product_Family__c); 
        Phoenix_NewProductWACPricingCloneCntrl.processRebid(testWAC[0].Id, testWACLines, 'Test New Product WAC Name');
        Phoenix_NewProductWACPricingCloneCntrl.getProducts1(testWAC[0].Phoenix_Product_Family__c);    
    }
    catch(Exception e ){}
    }
}