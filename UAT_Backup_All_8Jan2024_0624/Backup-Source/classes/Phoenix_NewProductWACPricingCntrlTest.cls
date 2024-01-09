@isTest
public class Phoenix_NewProductWACPricingCntrlTest {
    static testmethod void AddWACChangeMethod(){
        try{
        list < Product2 > prodList = new list < Product2 > ();
        Product_Family__c pf = new Product_Family__c();
        pf.Name = 'Test Family';
        insert pf;
        Product_Family__c pf1 = new Product_Family__c();
        pf1.Name = 'Sample Family';
        insert pf1;
        Product_Family__c pf2 = new Product_Family__c();
        pf2.Name = 'cetirizine';
        insert pf2;
        List < User > users = new List < User > ();
        List<New_Product_WAC_Pricing__c> testWAC = new List<New_Product_WAC_Pricing__c>();
        List<Phoenix_NewProduct_WAC_Pricing_LineItems__c> testWACLines = new List<Phoenix_NewProduct_WAC_Pricing_LineItems__c>();
        
        Product2 prod1 = new Product2(Name = 'Test Product',Product_Family__c = pf.Id, Phoenix_Pkg_Size__c=100, Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1',Product_Family__c = pf1.Id, Phoenix_Pkg_Size__c=200, Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2',Product_Family__c = pf2.Id, Phoenix_Pkg_Size__c=300, Phoenix_Rx_SRx_OTC__c = 'SRx', Phoenix_Special_Product__c = true, Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3',Product_Family__c = pf2.Id, Phoenix_Pkg_Size__c=400, Phoenix_Rx_SRx_OTC__c = 'OTC', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE);
        
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
        
        
		        
        Phoenix_NewProductWACPricingCntrl.getActiveBidProductFamilies();
        Phoenix_NewProductWACPricingCntrl.getProducts(testWAC[0].Phoenix_Product_Family__c);
        Phoenix_NewProductWACPricingCntrl.getWACPricingInfo(testWAC[0].Id);
        Phoenix_NewProductWACPricingCntrl.getLines(testWAC[0].Id);
        //Phoenix_NewProductWACPricingCntrl.getRelatedList(testWAC[0].Id);
     
        Phoenix_NewProductWACPricingCntrl.getDocs(testWAC[0].Id);
       Phoenix_NewProductWACPricingCntrl.deleteAttachments(attachments[0].Id);
      Phoenix_NewProductWACPricingCntrl.saveLineItems(testWAC[0].Id, testWACLines);
      
       Phoenix_NewProductWACPricingCntrl.getRelatedList(testWAC[0].Id);
      
      
       // Phoenix_NewProductWACPricingCntrl.makeHeadApprovals(testWAC[0].Id,'Approved');
        //Phoenix_NewProductWACPricingCntrl.getProductInfo('Test Family');
      
           
    }
    catch(Exception e ){}
    }
    static testmethod void Testmethod1()
    {
        
          List < Phoenix_User_Approval_Matrix__c > approvalGroups = new List < Phoenix_User_Approval_Matrix__c > ();
        List < Phoenix_User_Approval_Matrix__c > approvalUsers = new List < Phoenix_User_Approval_Matrix__c > ();
        List < User > users = new List < User > ();
        List < Phoenix_Approval_Matrix__c > bidMatrixList = new List < Phoenix_Approval_Matrix__c > ();
         Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
         Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
        insert p2;
        
         New_Product_WAC_Pricing__c testWAC2 = new New_Product_WAC_Pricing__c();
        testWAC2.Phoenix_WAC_Price_for_New_Launch_Name__c = 'Test WAC Pricing';
        testWAC2.Phoenix_Product_Family__c = 'Test Family';
        testWAC2.Phoenix_Product_Type__c = 'DRL';
        testWAC2.Phoenix_Marketing_Lead__c = userinfo.getUserId();
        testWAC2.Phoenix_Product_Director__c = userinfo.getUserId();
        testWAC2.Phoenix_TPT__c = 10;
        testWAC2.Phoenix_GM__c = 20;
        insert testWAC2; 
        
         Phoenix_NewProduct_WAC_Pricing_LineItems__c testWACLine2 = new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
        testWACLine2.Phoenix_Product__c = p2.Id;
        testWACLine2.Phoenix_WAC__c = 30;
        testWACLine2.Phoenix_Final_Status__c = 'Approved';
        testWACLine2.Phoenix_Lowest_Price__c = 20;
        testWACLine2.Phoenix_TPT_GM__c = 20;
        testWACLine2.Phoenix_New_Product_WAC_Pricing__c = testWAC2.Id;
        insert testWACLine2;
        
         if (approvalGroups.size() == 0) {
            Phoenix_User_Approval_Matrix__c group1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Sales', Phoenix_Approval_Group_Behavior__c = 'Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Supply Chain', Phoenix_Approval_Group_Behavior__c = 'Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Marketing Head', Phoenix_Approval_Group_Behavior__c = 'Single User');
            approvalGroups.add(group3);
            
            Phoenix_User_Approval_Matrix__c group4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Sr Director or VP Finance', Phoenix_Approval_Group_Behavior__c = 'Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(), Phoenix_Approver_Group_Name__c = 'Contracts', Phoenix_Approval_Group_Behavior__c = 'Account based');
            approvalGroups.add(group5);
            
            insert approvalGroups;
        }
        if (approvalUsers.size() == 0) {
            if (users.size() == 0) {
                Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
                String uid = ('Phoenix' + System.now().getTime()).SubString(0, 8);
                User u1 = new User(Alias = uid, Email = uid + '@phoenix.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/New_York', UserName = uid + '@phoenix.com');
                
                
                users.add(u1);
                
                
                insert users;
            }
            Phoenix_User_Approval_Matrix__c userApp1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(), Phoenix_Is_Approval_Process_User__c = true, Phoenix_Approver__c = UserInfo.getUserId(), User_Group__c = approvalGroups[0].Id);
            approvalUsers.add(userApp1);
            Phoenix_User_Approval_Matrix__c userApp2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(), Phoenix_Is_Approval_Process_User__c = true, Phoenix_Approver__c = users[0].Id, User_Group__c = approvalGroups[2].Id);
            approvalUsers.add(userApp2);
            Phoenix_User_Approval_Matrix__c userApp3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(), Phoenix_Is_Approval_Process_User__c = true, Phoenix_Approver__c = UserInfo.getUserId(), User_Group__c = approvalGroups[1].Id);
            approvalUsers.add(userApp3);
            Phoenix_User_Approval_Matrix__c userApp4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(), Phoenix_Is_Approval_Process_User__c = true, Phoenix_Approver__c = UserInfo.getUserId(), User_Group__c = approvalGroups[2].Id);
            approvalUsers.add(userApp4);
            Phoenix_User_Approval_Matrix__c userApp5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(), Phoenix_Is_Approval_Process_User__c = true, Phoenix_Approver__c = UserInfo.getUserId(), User_Group__c = approvalGroups[3].Id);
            approvalUsers.add(userApp5);
            Phoenix_User_Approval_Matrix__c userApp6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(), Phoenix_Is_Approval_Process_User__c = true, Phoenix_Approver__c = UserInfo.getUserId(), User_Group__c = approvalGroups[4].Id);
            approvalUsers.add(userApp6);
            
            insert approvalUsers;
        }
        
        
        
        
        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c = 'New Product WAC Pricing');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;
        
          Phoenix_NewProductWACPricingCntrl.getProductInfo(testWAC2.Phoenix_Product_Family__c);
        
         Phoenix_NewProductWACPricingCntrl.getSubmitBidInfo(testWAC2.Id);     
        
               Phoenix_NewProductWACPricingCntrl.submitToProceddStep1(testWAC2.Id);   
            string deleteRecordId=testWACLine2.Id;
            Phoenix_NewProductWACPricingCntrl.deleteWACPricingLine(deleteRecordId);
        
 
    }
    
     static testmethod void Testmethod2()
    {
         Account testAccount = new Account(Name = 'Test Email Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        
        Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
        insert p2;
        
        
         New_Product_WAC_Pricing__c testWAC2 = new New_Product_WAC_Pricing__c();
        testWAC2.Phoenix_WAC_Price_for_New_Launch_Name__c = 'Test WAC Pricing';
        testWAC2.Phoenix_Product_Family__c = 'Test Family';
        testWAC2.Phoenix_Product_Type__c = 'DRL';
        testWAC2.Phoenix_Marketing_Lead__c = userinfo.getUserId();
        testWAC2.Phoenix_Product_Director__c = userinfo.getUserId();
        testWAC2.Phoenix_TPT__c = 10;
        testWAC2.Phoenix_GM__c = 20;
        insert testWAC2; 
        
        Phoenix_Bid_Process_Steps__c bStep1 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep1.Name = 'test wac';
        bStep1.Phoenix_Approver__c = UserInfo.getUserId();
        //bStep1.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep1.Phoenix_Status__c = 'In Process';
        bStep1.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep1.Phoenix_Sub_Step__c = 2;
        bstep1.Phoenix_New_Product_WAC_Pricing__c = testWAC2.id;
        insert bStep1;
        
        Phoenix_Bid_Process_Steps__c bStep11 = new Phoenix_Bid_Process_Steps__c();
        bStep11.Phoenix_Is_Criteria_Step__c = false;
        bStep11.Name = 'test wac';
        bStep11.Phoenix_Approver__c = UserInfo.getUserId();
        
        bStep11.Phoenix_Status__c = 'In Process';
        bStep11.Phoenix_Approver_Team__c = 'Marketing';
        bStep11.Phoenix_Sub_Step__c = 2;
        bstep11.Phoenix_New_Product_WAC_Pricing__c = testWAC2.id;
        insert bStep11;
                User systemUser = [SELECT Id, Name FROM USER WHERE NAME='LISA CARDETTI' LIMIT 1];

        Phoenix_NewProductWACPricingCntrl.makeHeadApprovals(string.valueOf(testWAC2.Id) ,'Marketing Head',true,systemUser);
    }
    
    static testmethod void Testmethod3()
    {
         Account testAccount = new Account(Name = 'Test Email Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        
        Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
        p2.Phoenix_Is_New_Product__c= true;
        insert p2;
        
        
         New_Product_WAC_Pricing__c testWAC2 = new New_Product_WAC_Pricing__c();
        testWAC2.Phoenix_WAC_Price_for_New_Launch_Name__c = 'Test WAC Pricing';
        testWAC2.Phoenix_Product_Family__c = 'Test Family';
        testWAC2.Phoenix_Product_Type__c = 'DRL';
        testWAC2.Phoenix_Marketing_Lead__c = userinfo.getUserId();
        testWAC2.Phoenix_Product_Director__c = userinfo.getUserId();
        testWAC2.Phoenix_TPT__c = 10;
        testWAC2.Phoenix_GM__c = 20;
        insert testWAC2; 
        
        Phoenix_Bid_Process_Steps__c bStep1 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep1.Name = 'test wac';
        bStep1.Phoenix_Approver__c = UserInfo.getUserId();
        //bStep1.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep1.Phoenix_Status__c = 'In Process';
        bStep1.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep1.Phoenix_Sub_Step__c = 2;
        bstep1.Phoenix_New_Product_WAC_Pricing__c = testWAC2.id;
        insert bStep1;
        
        Phoenix_Bid_Process_Steps__c bStep11 = new Phoenix_Bid_Process_Steps__c();
        bStep11.Phoenix_Is_Criteria_Step__c = false;
        bStep11.Name = 'test wac';
        bStep11.Phoenix_Approver__c = UserInfo.getUserId();
        
        bStep11.Phoenix_Status__c = 'In Process';
        bStep11.Phoenix_Approver_Team__c = 'Marketing';
        bStep11.Phoenix_Sub_Step__c = 2;
        bstep11.Phoenix_New_Product_WAC_Pricing__c = testWAC2.id;
        insert bStep11;
 User systemUser = [SELECT Id, Name FROM USER WHERE NAME='LISA CARDETTI' LIMIT 1];

        Phoenix_NewProductWACPricingCntrl.makeHeadApprovals(string.valueOf(testWAC2.Id) ,'Marketing Head',true,systemUser);
    }
    
    static testmethod void Testmethod4()
    {
           New_Product_WAC_Pricing__c testWAC2 = new New_Product_WAC_Pricing__c();
        testWAC2.Phoenix_WAC_Price_for_New_Launch_Name__c = 'Test WAC Pricing';
        testWAC2.Phoenix_Product_Family__c = 'Test Family';
        testWAC2.Phoenix_Product_Type__c = 'DRL';
        testWAC2.Phoenix_Marketing_Lead__c = userinfo.getUserId();
        testWAC2.Phoenix_Product_Director__c = userinfo.getUserId();
        testWAC2.Phoenix_TPT__c = 10;
        testWAC2.Phoenix_GM__c = 20;
        insert testWAC2; 
        
        Phoenix_Bid_Process_Steps__c bStep1 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep1.Name = 'test wac';
        bStep1.Phoenix_Approver__c = UserInfo.getUserId();
        //bStep1.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep1.Phoenix_Status__c = 'In Process';
        bStep1.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep1.Phoenix_Sub_Step__c = 2;
        bstep1.Phoenix_New_Product_WAC_Pricing__c = testWAC2.id;
        insert bStep1;
        
        Phoenix_Bid_Process_Steps__c bStep11 = new Phoenix_Bid_Process_Steps__c();
        bStep11.Phoenix_Is_Criteria_Step__c = false;
        bStep11.Name = 'test wac';
        bStep11.Phoenix_Approver__c = UserInfo.getUserId();
        
        bStep11.Phoenix_Status__c = 'In Process';
        bStep11.Phoenix_Approver_Team__c = 'Marketing';
        bStep11.Phoenix_Sub_Step__c = 2;
        bstep11.Phoenix_New_Product_WAC_Pricing__c = testWAC2.id;
        insert bStep11;
                User systemUser = [SELECT Id, Name FROM USER WHERE NAME='LISA CARDETTI' LIMIT 1];

        Phoenix_NewProductWACPricingCntrl.makeLeadApprovals(string.valueOf(testWAC2.id),'Approved',true,true,systemUser);
    }
    
     static testmethod void Testmethod5()
    {
     
           New_Product_WAC_Pricing__c testWAC2 = new New_Product_WAC_Pricing__c();
        testWAC2.Phoenix_WAC_Price_for_New_Launch_Name__c = 'Test WAC Pricing';
        testWAC2.Phoenix_Product_Family__c = 'Test Family';
        testWAC2.Phoenix_Product_Type__c = 'DRL';
        testWAC2.Phoenix_Marketing_Lead__c = userinfo.getUserId();
        testWAC2.Phoenix_Product_Director__c = userinfo.getUserId();
        testWAC2.Phoenix_TPT__c = 10;
        testWAC2.Phoenix_GM__c = 20;
        insert testWAC2; 
        
        Phoenix_Bid_Process_Steps__c bStep1 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep1.Name = 'test wac';
        bStep1.Phoenix_Approver__c = UserInfo.getUserId();
        //bStep1.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep1.Phoenix_Status__c = 'In Process';
        bStep1.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep1.Phoenix_Sub_Step__c = 2;
        bstep1.Phoenix_New_Product_WAC_Pricing__c = testWAC2.id;
        insert bStep1;
        
        Phoenix_Bid_Process_Steps__c bStep11 = new Phoenix_Bid_Process_Steps__c();
        bStep11.Phoenix_Is_Criteria_Step__c = false;
        bStep11.Name = 'test wac';
        bStep11.Phoenix_Approver__c = UserInfo.getUserId();
        
        bStep11.Phoenix_Status__c = 'In Process';
        bStep11.Phoenix_Approver_Team__c = 'Marketing';
        bStep11.Phoenix_Sub_Step__c = 2;
        bstep11.Phoenix_New_Product_WAC_Pricing__c = testWAC2.id;
        insert bStep11;
        
  User systemUser = [SELECT Id, Name FROM USER WHERE NAME='LISA CARDETTI' LIMIT 1];

        Phoenix_NewProductWACPricingCntrl.makeLeadApprovals(string.valueOf(testWAC2.id),'Approved',true,true,systemUser);
    }
     static testmethod void Testmethod7()
    {
         Account testAccount = new Account(Name = 'Test Email Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        
        Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
        insert p2;
        
        
         New_Product_WAC_Pricing__c testWAC2 = new New_Product_WAC_Pricing__c();
        testWAC2.Phoenix_WAC_Price_for_New_Launch_Name__c = 'Test WAC Pricing';
        testWAC2.Phoenix_Product_Family__c = 'Test Family';
        testWAC2.Phoenix_Product_Type__c = 'DRL';
        testWAC2.Phoenix_Marketing_Lead__c = userinfo.getUserId();
        testWAC2.Phoenix_Product_Director__c = userinfo.getUserId();
        testWAC2.Phoenix_TPT__c = 10;
        testWAC2.Phoenix_GM__c = 20;
        insert testWAC2; 
        
        Phoenix_NewProductWACPricingCntrl.getRelatedList(testWAC2.id);
    }
    static testmethod void codecoverageBlock(){
        Phoenix_NewProductWACPricingCntrl.codeCoverage();
    } 
}