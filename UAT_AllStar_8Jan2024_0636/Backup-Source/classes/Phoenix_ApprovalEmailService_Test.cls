@isTest
public class Phoenix_ApprovalEmailService_Test {
    @isTest static void Test(){
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEmail email1 = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test bid';
        insert bid;
        Phoenix_User_Approval_Matrix__c apprvlMtrx = new Phoenix_User_Approval_Matrix__c();
        apprvlMtrx.Name = 'Test';
        apprvlMtrx.Phoenix_Is_Approval_Process_User__c = true;
        apprvlMtrx.Phoenix_Approver__c = UserInfo.getUserId();
        insert apprvlMtrx; 
        Phoenix_Bid_Process_Steps__c bidProcessSteps = new Phoenix_Bid_Process_Steps__c();
        bidProcessSteps.Phoenix_Bid__c = bid.id;
        bidProcessSteps.Phoenix_Status__c = 'In Process';
        bidProcessSteps.Phoenix_Approver_Team__c = 'Marketing Lead Rx';
        insert bidProcessSteps; 
          Phoenix_Bid_Process_Steps__c bidProcessSteps2 = new Phoenix_Bid_Process_Steps__c();
          bidProcessSteps2.Phoenix_Bid__c = bid.id;
        bidProcessSteps.Phoenix_Status__c = 'In Process';
        bidProcessSteps.Phoenix_Approver_Team__c = 'Marketing Lead SRx';
          insert bidProcessSteps2; 
       Phoenix_Approval_Grid__c grid = new Phoenix_Approval_Grid__c();
        grid.Phoenix_Bid__c = bid.Id;
        grid.Phoenix_isRx__c = true;
          insert grid; 
         Phoenix_Approval_Grid__c grid2 = new Phoenix_Approval_Grid__c();
        grid2.Phoenix_Bid__c = bid.Id;
        grid2.Phoenix_isSRX__c = true;
          insert grid2; 
        
        String bidName = [SELECT Phoenix_Bid_Name__c, Id, Name FROM Phoenix_Bid__c WHERE Id =: bid.Id].Name;
        
        New_Product_WAC_Pricing__c wac = new New_Product_WAC_Pricing__c();
        wac.Phoenix_Summary__c = 'test';
        insert wac;
        
        string wacName = [Select Id,Name from New_Product_WAC_Pricing__c where id=:wac.Id].Name;
        email.subject = 'WAC '+ wacName +' Testing';
   //     email.fromname = 'Test Test';
        email.fromAddress = UserInfo.getUserEmail();
        email.plainTextBody = 'APPROVED';
         email.htmlBody = 'YES';
        
        email1.subject = 'WAC Price - 000096';
   //     email.fromname = 'Test Test';
        email1.fromAddress = UserInfo.getUserEmail();
        email1.plainTextBody = 'APPROVED';
         email1.htmlBody = 'YES';
        
        //Phoenix_ApprovalEmailService emailProcess = new Phoenix_ApprovalEmailService();
        //emailProcess.handleInboundEmail(email, env);
        
        Phoenix_ApprovalEmailService emailProcess1 = new Phoenix_ApprovalEmailService();
        emailProcess1.handleInboundEmail(email1, env);
    }
    
    
        @isTest static void Test2(){
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test bid';
        insert bid;
        Phoenix_User_Approval_Matrix__c apprvlMtrx = new Phoenix_User_Approval_Matrix__c();
        apprvlMtrx.Name = 'Test';
        apprvlMtrx.Phoenix_Is_Approval_Process_User__c = true;
        apprvlMtrx.Phoenix_Approver__c = UserInfo.getUserId();
        insert apprvlMtrx; 
        Phoenix_Bid_Process_Steps__c bidProcessSteps = new Phoenix_Bid_Process_Steps__c();
        bidProcessSteps.Phoenix_Bid__c = bid.id;
        bidProcessSteps.Phoenix_Status__c = 'In Process';
        bidProcessSteps.Phoenix_Approver_Team__c = 'Marketing Lead Rx';
        insert bidProcessSteps; 
          Phoenix_Bid_Process_Steps__c bidProcessSteps2 = new Phoenix_Bid_Process_Steps__c();
          bidProcessSteps2.Phoenix_Bid__c = bid.id;
        bidProcessSteps.Phoenix_Status__c = 'In Process';
        bidProcessSteps.Phoenix_Approver_Team__c = 'Marketing Lead SRx';
          insert bidProcessSteps2; 
       Phoenix_Approval_Grid__c grid = new Phoenix_Approval_Grid__c();
        grid.Phoenix_Bid__c = bid.Id;
        grid.Phoenix_isRx__c = true;
          insert grid; 
         Phoenix_Approval_Grid__c grid2 = new Phoenix_Approval_Grid__c();
        grid2.Phoenix_Bid__c = bid.Id;
        grid2.Phoenix_isSRX__c = true;
          insert grid2; 
        String bidName = [SELECT Phoenix_Bid_Name__c, Id, Name FROM Phoenix_Bid__c WHERE Id =: bid.Id].Name;
        email.subject = 'WAC '+ bidName +' Testing';
   //     email.fromname = 'Test Test';
        email.fromAddress = UserInfo.getUserEmail();
        email.plainTextBody = 'APPROVED';
          email.htmlBody = 'APPROVED';
        Phoenix_ApprovalEmailService emailProcess = new Phoenix_ApprovalEmailService();
        emailProcess.handleInboundEmail(email, env);
    }
      @isTest static void Test3(){
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test bid';
        insert bid;
        Phoenix_User_Approval_Matrix__c apprvlMtrx = new Phoenix_User_Approval_Matrix__c();
        apprvlMtrx.Name = 'Test';
        apprvlMtrx.Phoenix_Is_Approval_Process_User__c = true;
        apprvlMtrx.Phoenix_Approver__c = UserInfo.getUserId();
        insert apprvlMtrx; 
        Phoenix_Bid_Process_Steps__c bidProcessSteps = new Phoenix_Bid_Process_Steps__c();
        bidProcessSteps.Phoenix_Bid__c = bid.id;
        bidProcessSteps.Phoenix_Status__c = 'In Process';
        bidProcessSteps.Phoenix_Approver_Team__c = 'Marketing Lead Rx';
        insert bidProcessSteps; 
          Phoenix_Bid_Process_Steps__c bidProcessSteps2 = new Phoenix_Bid_Process_Steps__c();
          bidProcessSteps2.Phoenix_Bid__c = bid.id;
        bidProcessSteps.Phoenix_Status__c = 'In Process';
        bidProcessSteps.Phoenix_Approver_Team__c = 'Marketing Lead SRx';
          insert bidProcessSteps2; 
       Phoenix_Approval_Grid__c grid = new Phoenix_Approval_Grid__c();
        grid.Phoenix_Bid__c = bid.Id;
        grid.Phoenix_isRx__c = true;
          insert grid; 
         Phoenix_Approval_Grid__c grid2 = new Phoenix_Approval_Grid__c();
        grid2.Phoenix_Bid__c = bid.Id;
        grid2.Phoenix_isSRX__c = true;
          insert grid2; 
        String bidName = [SELECT Phoenix_Bid_Name__c, Id, Name FROM Phoenix_Bid__c WHERE Id =: bid.Id].Name;
        email.subject = 'WAC '+ bidName +' Testing';
   //     email.fromname = 'Test Test';
        email.fromAddress = UserInfo.getUserEmail();
        email.plainTextBody = 'No';
          email.htmlBody = 'No';
        Phoenix_ApprovalEmailService emailProcess = new Phoenix_ApprovalEmailService();
        emailProcess.handleInboundEmail(email, env);
    }
    
    @isTest static void Test4(){
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test bid';
        insert bid;
       Phoenix_Approval_Grid__c grid = new Phoenix_Approval_Grid__c();
        grid.Phoenix_Bid__c = bid.Id;
        grid.Phoenix_isRx__c = true;
          insert grid; 
         Phoenix_Approval_Grid__c grid2 = new Phoenix_Approval_Grid__c();
        grid2.Phoenix_Bid__c = bid.Id;
        grid2.Phoenix_isSRX__c = true;
          insert grid2; 
        String bidName = [SELECT Phoenix_Bid_Name__c, Id, Name FROM Phoenix_Bid__c WHERE Id =: bid.Id].Name;
        email.subject = ''+ bidName +' Testing';
   //     email.fromname = 'Test Test';
        email.fromAddress = UserInfo.getUserEmail();
        email.plainTextBody = 'test body';
          email.htmlBody = 'test bodyyy';
        Phoenix_ApprovalEmailService emailProcess = new Phoenix_ApprovalEmailService();
        emailProcess.handleInboundEmail(email, env);
    }
 
  /*static testmethod void AddWACChangeMethod(){
             Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
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
        insert testWAC2;
        
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
        
          String bidName = [SELECT Id, Name FROM New_Product_WAC_Pricing__c WHERE Id =: testWAC2.Id].Name;
        email.subject = 'Test '+ bidName +' Testing';
   //     email.fromname = 'Test Test';
        email.fromAddress = UserInfo.getUserEmail();
        email.plainTextBody = 'hgkh';
          email.htmlBody = 'jlj';
        Phoenix_ApprovalEmailService emailProcess = new Phoenix_ApprovalEmailService();
        emailProcess.handleInboundEmail(email, env);
		        
       
           
 }*/
    /*
    static testmethod void codecoverageBlock(){
      Phoenix_ApprovalEmailService.codecoverageBlock();
    } */
}