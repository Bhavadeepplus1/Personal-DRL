//Added by Shashirekha
@isTest
public class approvalRequestNotificationClass_Test {

    static testmethod void approvalRequestNotification_TestMethod(){
        List<Phoenix_User_Approval_Matrix__c> approvalGroups = new List<Phoenix_User_Approval_Matrix__c>();   
        List<Phoenix_User_Approval_Matrix__c> approvalUsers = new List<Phoenix_User_Approval_Matrix__c>();
        List<User> users = new List<User>();    
        List<Phoenix_Bid__c> bidsList = new List<Phoenix_Bid__c>(); 
        List<Phoenix_Bid__c> bidItemList = new List<Phoenix_Bid__c>(); 
        List<Product2> productList = new List<Product2>();
        List<Phoenix_Approval_Matrix__c> bidMatrixList = new List<Phoenix_Approval_Matrix__c>();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list<Product2> prodList = new list<Product2>();
        Product2 prod1 = new Product2(Name = 'Test Product',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='11111',Phoenix_NDC_11__c='12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='22222',Phoenix_NDC_11__c='21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_NDC_11__c='32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Internal_Target_Date__c=Date.newInstance(2023, 04, 27);
        pb.Phoenix_Bid_Deadline_Date__c=System.Today();
        
        insert pb;
        
        list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        if(approvalGroups.size() ==0){
            Phoenix_User_Approval_Matrix__c group1= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Sales',Phoenix_Approval_Group_Behavior__c='Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Supply Chain',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Marketing',Phoenix_Approval_Group_Behavior__c='Product based');
            approvalGroups.add(group3);
            
            Phoenix_User_Approval_Matrix__c group4= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Finance',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Contracts',Phoenix_Approval_Group_Behavior__c='Account based');
            approvalGroups.add(group5);
            
            insert approvalGroups;
        }
        if(approvalUsers.size() ==0){
            if(users.size() ==0){
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                String uid = ('Phoenix'+System.now().getTime()).SubString(0,8);
                User u1 = new User(Alias = uid, Email= uid + '@phoenix.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/New_York', UserName= uid + '@phoenix.com');      
                users.add(u1);
                insert users;
            }
            Phoenix_User_Approval_Matrix__c userApp1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[0].Id);
            approvalUsers.add(userApp1);
            Phoenix_User_Approval_Matrix__c userApp2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=users[0].Id,User_Group__c =approvalGroups[2].Id );
            approvalUsers.add(userApp2);
            Phoenix_User_Approval_Matrix__c userApp3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[1].Id);
            approvalUsers.add(userApp3);
            Phoenix_User_Approval_Matrix__c userApp4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[2].Id);
            approvalUsers.add(userApp4);
            Phoenix_User_Approval_Matrix__c userApp5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[3].Id);
            approvalUsers.add(userApp5);
            Phoenix_User_Approval_Matrix__c userApp6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[4].Id);
            approvalUsers.add(userApp6);
            insert approvalUsers;
        }
        
        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c='NEW Individual Pricing Agreement (IPA)');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;
        
        List<Phoenix_Approval_Process_Step__c> stepsList = new List<Phoenix_Approval_Process_Step__c>();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for(Phoenix_Approval_Matrix__c matrix : bidMatrixList){
            Phoenix_Approval_Process_Step__c rfpStep1 = new  Phoenix_Approval_Process_Step__c(Name='Initial Submission',Phoenix_Order__c = 1,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep1);
            
            Phoenix_Approval_Process_Step__c rfpStep2 = new  Phoenix_Approval_Process_Step__c(Name='Marketing',Phoenix_Order__c = 2,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Marketing',Phoenix_Approval_Matrix__c=matrix.Id,Phoenix_Approver__c=UserInfo.getUserId());
            stepsList.add(rfpStep2);
            
            Phoenix_Approval_Process_Step__c rfpStep5 = new  Phoenix_Approval_Process_Step__c(Name='Finance',Phoenix_Order__c = 3,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Finance',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep5);
            Phoenix_Approval_Process_Step__c rfpStep6 = new  Phoenix_Approval_Process_Step__c(Name='Contracts',Phoenix_Order__c = 4,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Contracts',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep6); 
            Phoenix_Approval_Process_Step__c rfpStep7 = new  Phoenix_Approval_Process_Step__c(Name='Vistex Update',Phoenix_Order__c = 5,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Home Office',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep7);
            
            Phoenix_Approval_Process_Step__c rfpStep9 = new  Phoenix_Approval_Process_Step__c(Name='Closed',Phoenix_Order__c = 6,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep9); 
        }
        insert stepsList;
        
        list<Phoenix_Bid_Process_Steps__c> processList=new list<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c bStep=new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c=	stepsList[0].Id;
        system.debug('stepsList[0].Id---------------'+stepsList[0].Id);
        bStep.Name= pb.Name+'-'+'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        bStep.Phoenix_Status__c =  'Submitted';
        bStep.Phoenix_Sub_Step__c = 1;
        processList.add(bStep);
        
        Phoenix_Bid_Process_Steps__c bStep2=new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name= pb.Name+'-'+'Marketing Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        bStep2.Phoenix_Process_Step__c=	stepsList[1].Id;
        
        bStep2.Phoenix_Approver_Team__c='Marketing';
        
        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
        Phoenix_Bid_Process_Steps__c bStep3=new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name= pb.Name+'-'+'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb.Id;
        bStep3.Phoenix_Process_Step__c=	stepsList[2].Id;
        
        bStep3.Phoenix_Approver_Team__c='Finance';
        
        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        Phoenix_Bid_Process_Steps__c bStep4=new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name= pb.Name+'-'+'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb.Id;
        bStep4.Phoenix_Process_Step__c=	stepsList[3].Id;
        bStep4.Phoenix_Approver_Team__c='Contracts';
        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        
        Phoenix_Bid_Process_Steps__c bStep5=new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name= pb.Name+'-'+'Vistex Update';
       // bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep5.Phoenix_Status__c =  'In Process';
        bStep5.Phoenix_Approver_Team__c='Sales';
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
        Phoenix_Bid_Process_Steps__c bStep6=new Phoenix_Bid_Process_Steps__c();
        bStep6.Phoenix_Is_Criteria_Step__c = false;
        bStep6.Name= pb.Name+'-'+'Vistex Update';
       	bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep6.Phoenix_Bid__c = pb.Id;
        bStep6.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep6.Phoenix_Status__c =  'In Process';
        //bStep6.Phoenix_Approver_Team__c='Sales';
        bStep6.Phoenix_Sub_Step__c = 1;
        processList.add(bStep6);
        
        Phoenix_Bid_Process_Steps__c bStep7=new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name= pb.Name+'-'+'Closed';
        bStep7.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
        insert processList;
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:pb.Id ];
        system.debug('---bidProcessStepList---'+bidProcessStepList.size());
        list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Vistex_Status__c,Phoenix_MarketingLead_Approver__c,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        
        approvalRequestNotificationClass.approvalRequestNotification(pb.Id,processList);
    }
    
	static testmethod void approvalRequestNotification_TestMethod1(){
        
        List<Phoenix_User_Approval_Matrix__c> approvalGroups = new List<Phoenix_User_Approval_Matrix__c>();   
        List<Phoenix_User_Approval_Matrix__c> approvalUsers = new List<Phoenix_User_Approval_Matrix__c>();
        List<User> users = new List<User>();    
        List<Phoenix_Bid__c> bidsList = new List<Phoenix_Bid__c>(); 
        List<Phoenix_Bid__c> bidItemList = new List<Phoenix_Bid__c>(); 
        List<Product2> productList = new List<Product2>();
        List<Phoenix_Approval_Matrix__c> bidMatrixList = new List<Phoenix_Approval_Matrix__c>();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list<Product2> prodList = new list<Product2>();
        Product2 prod1 = new Product2(Name = 'Test Product',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='11111',Phoenix_NDC_11__c='12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='22222',Phoenix_NDC_11__c='21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_NDC_11__c='32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c='Product Discontinuation Process';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Internal_Target_Date__c=Date.newInstance(2023, 04, 27);
        pb.Phoenix_Bid_Deadline_Date__c=System.Today();
        pb.Phoenix_is_OTC_Bid__c=true;
        insert pb;
        
        list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        if(approvalGroups.size() ==0){
            Phoenix_User_Approval_Matrix__c group1= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Sales',Phoenix_Approval_Group_Behavior__c='Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Supply Chain',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Marketing',Phoenix_Approval_Group_Behavior__c='Product based');
            approvalGroups.add(group3);
            Phoenix_User_Approval_Matrix__c group4= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Finance',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Contracts',Phoenix_Approval_Group_Behavior__c='Account based');
            approvalGroups.add(group5);
            
            insert approvalGroups;
        }
        if(approvalUsers.size() ==0){
            if(users.size() ==0){
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                String uid = ('Phoenix'+System.now().getTime()).SubString(0,8);
                User u1 = new User(Alias = uid, Email= uid + '@phoenix.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/New_York', UserName= uid + '@phoenix.com');      
                users.add(u1);
                insert users;
            }
            Phoenix_User_Approval_Matrix__c userApp1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[0].Id);
            approvalUsers.add(userApp1);
            Phoenix_User_Approval_Matrix__c userApp2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=users[0].Id,User_Group__c =approvalGroups[2].Id );
            approvalUsers.add(userApp2);
            Phoenix_User_Approval_Matrix__c userApp3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[1].Id);
            approvalUsers.add(userApp3);
            Phoenix_User_Approval_Matrix__c userApp4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[2].Id);
            approvalUsers.add(userApp4);
            Phoenix_User_Approval_Matrix__c userApp5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[3].Id);
            approvalUsers.add(userApp5);
            Phoenix_User_Approval_Matrix__c userApp6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[4].Id);
            approvalUsers.add(userApp6);
            
            insert approvalUsers;
        }
        
        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c='NEW Individual Pricing Agreement (IPA)');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;
        
        List<Phoenix_Approval_Process_Step__c> stepsList = new List<Phoenix_Approval_Process_Step__c>();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for(Phoenix_Approval_Matrix__c matrix : bidMatrixList){
            Phoenix_Approval_Process_Step__c rfpStep1 = new  Phoenix_Approval_Process_Step__c(Name='Initial Submission',Phoenix_Order__c = 1,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep1);            
            Phoenix_Approval_Process_Step__c rfpStep2 = new  Phoenix_Approval_Process_Step__c(Name='Marketing',Phoenix_Order__c = 2,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Marketing',Phoenix_Approval_Matrix__c=matrix.Id,Phoenix_Approver__c=UserInfo.getUserId());
            stepsList.add(rfpStep2);
            Phoenix_Approval_Process_Step__c rfpStep5 = new  Phoenix_Approval_Process_Step__c(Name='Finance',Phoenix_Order__c = 3,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Finance',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep5);
            Phoenix_Approval_Process_Step__c rfpStep6 = new  Phoenix_Approval_Process_Step__c(Name='Contracts',Phoenix_Order__c = 4,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Contracts',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep6); 
            Phoenix_Approval_Process_Step__c rfpStep7 = new  Phoenix_Approval_Process_Step__c(Name='Vistex Update',Phoenix_Order__c = 5,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Home Office',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep7);
            Phoenix_Approval_Process_Step__c rfpStep9 = new  Phoenix_Approval_Process_Step__c(Name='Closed',Phoenix_Order__c = 6,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep9); 
        }
        insert stepsList;        
        
        list<Phoenix_Bid_Process_Steps__c>processList=new list<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c bStep=new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c=	stepsList[0].Id;
        system.debug('stepsList[0].Id---------------'+stepsList[0].Id);
        bStep.Name= pb.Name+'-'+'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        bStep.Phoenix_Status__c =  'Submitted';
        bStep.Phoenix_Sub_Step__c = 1;
        bStep.Phoenix_Approver_Team__c = 'Marketing Lead Rx';
        processList.add(bStep);
        
        Phoenix_Bid_Process_Steps__c bStep8=new Phoenix_Bid_Process_Steps__c();
        bStep8.Phoenix_Is_Criteria_Step__c = false;
        bStep8.Name= pb.Name+'-'+'Marketing Approval';
        bStep8.Phoenix_Approver__c = UserInfo.getUserId();
        bStep8.Phoenix_Bid__c = pb.Id;
        bStep8.Phoenix_Process_Step__c=	stepsList[1].Id;
        bStep8.Phoenix_Approver_Team__c='Marketing Lead SRx';
        bStep8.Phoenix_Sub_Step__c = 1;
        processList.add(bStep8);
        
        Phoenix_Bid_Process_Steps__c bStep9=new Phoenix_Bid_Process_Steps__c();
        bStep9.Phoenix_Is_Criteria_Step__c = false;
        bStep9.Name= pb.Name+'-'+'Marketing Approval';
        bStep9.Phoenix_Approver__c = UserInfo.getUserId();
        bStep9.Phoenix_Bid__c = pb.Id;
        bStep9.Phoenix_Process_Step__c=	stepsList[1].Id;        
        bStep9.Phoenix_Approver_Team__c='Marketing Lead OTC';
        bStep9.Phoenix_Sub_Step__c = 1;
        processList.add(bStep9);
        
        Phoenix_Bid_Process_Steps__c bStep2=new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name= pb.Name+'-'+'Marketing Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        bStep2.Phoenix_Process_Step__c=	stepsList[1].Id;
        bStep2.Phoenix_Approver_Team__c='Marketing';
        
        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
        Phoenix_Bid_Process_Steps__c bStep3=new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name= pb.Name+'-'+'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb.Id;
        bStep3.Phoenix_Process_Step__c=	stepsList[2].Id;
        bStep3.Phoenix_Approver_Team__c='Finance';
        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        
        Phoenix_Bid_Process_Steps__c bStep4=new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name= pb.Name+'-'+'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb.Id;
        bStep4.Phoenix_Process_Step__c=	stepsList[3].Id;
        bStep4.Phoenix_Approver_Team__c='Contracts';
        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        
        Phoenix_Bid_Process_Steps__c bStep5=new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name= pb.Name+'-'+'Vistex Update';
        //bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep5.Phoenix_Status__c =  'In Process';
        bStep5.Phoenix_Approver_Team__c='Home Office';
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
        Phoenix_Bid_Process_Steps__c bStep6=new Phoenix_Bid_Process_Steps__c();
        bStep6.Phoenix_Is_Criteria_Step__c = false;
        bStep6.Name= pb.Name+'-'+'Vistex Update';
        bStep6.Phoenix_Approver__c = UserInfo.getUserId();
        bStep6.Phoenix_Bid__c = pb.Id;
        bStep6.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep6.Phoenix_Status__c =  'In Process';
        bStep6.Phoenix_Sub_Step__c = 1;
        processList.add(bStep6);
        
        Phoenix_Bid_Process_Steps__c bStep7=new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name= pb.Name+'-'+'Closed';
        bStep7.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
               
        Phoenix_Bid_Process_Steps__c bStep10=new Phoenix_Bid_Process_Steps__c();
        bStep10.Phoenix_Is_Criteria_Step__c = false;
        bStep10.Name= pb.Name+'-'+'Customer\'s Update';
        bStep10.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep10.Phoenix_Approver__c = UserInfo.getUserId();
        bStep10.Phoenix_Bid__c = pb.Id;
        bStep10.Phoenix_Sub_Step__c = 1;
        processList.add(bStep10);
        insert processList;
        
        List<Phoenix_Approval_Grid__c> pagList=new List<Phoenix_Approval_Grid__c>();
        Phoenix_Approval_Grid__c pag=new Phoenix_Approval_Grid__c();
		pag.Phoenix_Product_Family__c='Product Family';
		pag.Phoenix_Is_partner_product__c=true;
		pag.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag.Phoenix_Sr_Director_VP__c='Approved';
		pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		pag.Phoenix_Comments__c='Noted';
		pag.Phoenix_Approval__c='Approved';
		pag.Phoenix_Business_Head_Comments__c='Noted';
		pag.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag.Phoenix_GM_Limit__c='Noted';
		pag.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag.Phoenix_GM__c=2;
		pag.Phoenix_Revenue_Limit__c='Noted';
		pag.Phoenix_Revenue__c=2;
		pag.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag.Phoenix_Annualized_TP_Impact__c=3;
        pag.Phoenix_Annualized_GM_Impact__c=4;
		pag.Phoenix_Annualized_TP__c=3;
		pag.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
		//pag.Phoenix_Annualized_TP__c=4;
       	pag.Phoenix_Is_New_Low__c=false;
        pag.Phoenix_Bid__c=pb.Id;
		insert pag;
        pagList.add(pag);
      
        Phoenix_Approval_Grid__c pag1=new Phoenix_Approval_Grid__c();
		pag1.Phoenix_Product_Family__c='Product Family';
		pag1.Phoenix_Is_partner_product__c=false;
		pag1.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag1.Phoenix_Sr_Director_VP__c='Approved';
		pag1.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag1.Phoenix_Is_SVP_Notification_Required__c=true;
		pag1.Phoenix_Sr_Director_VP__c='Approved';
		pag1.Phoenix_Comments__c='Noted';
		pag1.Phoenix_Approval__c='Approved';
		pag1.Phoenix_Business_Head_Comments__c='Noted';
		pag1.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag1.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag1.Phoenix_GM_Limit__c='Noted';
		pag1.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag1.Phoenix_GM__c=2;
		pag1.Phoenix_Revenue_Limit__c='Noted';
		pag1.Phoenix_Revenue__c=2;
		pag1.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag1.Phoenix_Annualized_TP_Impact__c=3;
        pag1.Phoenix_Annualized_GM_Impact__c=4;
		pag1.Phoenix_Annualized_TP__c=3;
		pag1.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
		pag1.Phoenix_Annualized_TP__c=4;
       	pag1.Phoenix_Is_New_Low__c=true;
        pag1.Phoenix_Bid__c=pb.Id;
		insert pag1;
        pagList.add(pag1);
        
        Phoenix_Approval_Grid__c pag3=new Phoenix_Approval_Grid__c();
		pag3.Phoenix_Product_Family__c='Product Family';
		pag3.Phoenix_Is_partner_product__c=false;
		pag3.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag3.Phoenix_Sr_Director_VP__c='Approved';
		pag3.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag3.Phoenix_Is_SVP_Notification_Required__c=true;
		pag3.Phoenix_Sr_Director_VP__c='Approved';
		pag3.Phoenix_Comments__c='Noted';
		pag3.Phoenix_Approval__c='Approved';
		pag3.Phoenix_Business_Head_Comments__c='Noted';
		pag3.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag3.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag3.Phoenix_GM_Limit__c='Noted';
		pag3.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag3.Phoenix_GM__c=2;
		pag3.Phoenix_Revenue_Limit__c='Noted';
		pag3.Phoenix_Revenue__c=2;
		pag3.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag3.Phoenix_Annualized_TP_Impact__c=3;
        pag3.Phoenix_Annualized_GM_Impact__c=4;
		pag3.Phoenix_Annualized_TP__c=3;
		pag3.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
       	pag3.Phoenix_Is_New_Low__c=false;
        pag3.Phoenix_Bid__c=pb.Id;
		insert pag3;
        pagList.add(pag3);
        
        Phoenix_Approval_Grid__c pag2=new Phoenix_Approval_Grid__c();
		pag2.Phoenix_Product_Family__c='Product Family';
		pag2.Phoenix_Is_partner_product__c=true;
		pag2.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag2.Phoenix_Sr_Director_VP__c='Approved';
		pag2.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag2.Phoenix_Is_SVP_Notification_Required__c=true;
		pag2.Phoenix_Sr_Director_VP__c='Approved';
		pag2.Phoenix_Comments__c='Noted';
		pag2.Phoenix_Approval__c='Approved';
		pag2.Phoenix_Business_Head_Comments__c='Noted';
		pag2.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag2.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag2.Phoenix_GM_Limit__c='Noted';
		pag2.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag2.Phoenix_GM__c=2;
		pag2.Phoenix_Revenue_Limit__c='Noted';
		pag2.Phoenix_Revenue__c=2;
		pag2.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag2.Phoenix_Annualized_TP_Impact__c=3;
        //pag2.Phoenix_Annualized_GM_Impact__c=4;
		pag2.Phoenix_Annualized_TP__c=3;
		pag2.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
        pag2.Phoenix_Bid__c=pb.Id;
		insert pag2;
        pagList.add(pag2);
        
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:pb.Id ];
        system.debug('---bidProcessStepList---'+bidProcessStepList.size());
        list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Vistex_Status__c,Phoenix_MarketingLead_Approver__c,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        
        approvalRequestNotificationClass.approvalRequestNotification(pb.Id,processList);
        //approvalRequestNotificationClass.BidWrapper
        //approvalRequestNotificationClass.codeCoverageBlock();
    }
        
	static testmethod void approvalRequestNotification_TestMethod2(){
        
        List<Phoenix_User_Approval_Matrix__c> approvalGroups = new List<Phoenix_User_Approval_Matrix__c>();   
        List<Phoenix_User_Approval_Matrix__c> approvalUsers = new List<Phoenix_User_Approval_Matrix__c>();
        List<User> users = new List<User>();    
        List<Phoenix_Bid__c> bidsList = new List<Phoenix_Bid__c>(); 
        List<Phoenix_Bid__c> bidItemList = new List<Phoenix_Bid__c>(); 
        List<Product2> productList = new List<Product2>();
        List<Phoenix_Approval_Matrix__c> bidMatrixList = new List<Phoenix_Approval_Matrix__c>();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list<Product2> prodList = new list<Product2>();
        Product2 prod1 = new Product2(Name = 'Test Product',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='11111',Phoenix_NDC_11__c='12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='22222',Phoenix_NDC_11__c='21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_NDC_11__c='32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c='Product Discontinuation Process';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Internal_Target_Date__c=Date.newInstance(2023, 04, 27);
        pb.Phoenix_Bid_Deadline_Date__c=System.Today();
        //pb.Phoenix_is_OTC_Bid__c=true;
        insert pb;
        
        list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        if(approvalGroups.size() ==0){
            Phoenix_User_Approval_Matrix__c group1= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Sales',Phoenix_Approval_Group_Behavior__c='Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Supply Chain',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Marketing',Phoenix_Approval_Group_Behavior__c='Product based');
            approvalGroups.add(group3);
            Phoenix_User_Approval_Matrix__c group4= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Finance',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Contracts',Phoenix_Approval_Group_Behavior__c='Account based');
            approvalGroups.add(group5);
            
            insert approvalGroups;
        }
        if(approvalUsers.size() ==0){
            if(users.size() ==0){
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                String uid = ('Phoenix'+System.now().getTime()).SubString(0,8);
                User u1 = new User(Alias = uid, Email= uid + '@phoenix.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/New_York', UserName= uid + '@phoenix.com');      
                users.add(u1);
                insert users;
            }
            Phoenix_User_Approval_Matrix__c userApp1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[0].Id);
            approvalUsers.add(userApp1);
            Phoenix_User_Approval_Matrix__c userApp2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=users[0].Id,User_Group__c =approvalGroups[2].Id );
            approvalUsers.add(userApp2);
            Phoenix_User_Approval_Matrix__c userApp3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[1].Id);
            approvalUsers.add(userApp3);
            Phoenix_User_Approval_Matrix__c userApp4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[2].Id);
            approvalUsers.add(userApp4);
            Phoenix_User_Approval_Matrix__c userApp5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[3].Id);
            approvalUsers.add(userApp5);
            Phoenix_User_Approval_Matrix__c userApp6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[4].Id);
            approvalUsers.add(userApp6);
            
            insert approvalUsers;
        }
        
        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c='NEW Individual Pricing Agreement (IPA)');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;
        
        List<Phoenix_Approval_Process_Step__c> stepsList = new List<Phoenix_Approval_Process_Step__c>();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for(Phoenix_Approval_Matrix__c matrix : bidMatrixList){
            Phoenix_Approval_Process_Step__c rfpStep1 = new  Phoenix_Approval_Process_Step__c(Name='Initial Submission',Phoenix_Order__c = 1,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep1);
            
            Phoenix_Approval_Process_Step__c rfpStep2 = new  Phoenix_Approval_Process_Step__c(Name='Marketing',Phoenix_Order__c = 2,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Marketing',Phoenix_Approval_Matrix__c=matrix.Id,Phoenix_Approver__c=UserInfo.getUserId());
            stepsList.add(rfpStep2);
            
            
            
            Phoenix_Approval_Process_Step__c rfpStep5 = new  Phoenix_Approval_Process_Step__c(Name='Finance',Phoenix_Order__c = 3,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Finance',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep5);
            Phoenix_Approval_Process_Step__c rfpStep6 = new  Phoenix_Approval_Process_Step__c(Name='Contracts',Phoenix_Order__c = 4,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Contracts',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep6); 
            Phoenix_Approval_Process_Step__c rfpStep7 = new  Phoenix_Approval_Process_Step__c(Name='Vistex Update',Phoenix_Order__c = 5,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Home Office',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep7);
            
            Phoenix_Approval_Process_Step__c rfpStep9 = new  Phoenix_Approval_Process_Step__c(Name='Closed',Phoenix_Order__c = 6,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep9); 
        }
        insert stepsList;        
        
        list<Phoenix_Bid_Process_Steps__c>processList=new list<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c bStep=new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c=	stepsList[0].Id;
        system.debug('stepsList[0].Id---------------'+stepsList[0].Id);
        bStep.Name= pb.Name+'-'+'Marketing Approval';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        bStep.Phoenix_Status__c =  'Submitted';
        bStep.Phoenix_Sub_Step__c = 1;
        bStep.Phoenix_Approver_Team__c = 'Marketing';
        processList.add(bStep);
        
        Phoenix_Bid_Process_Steps__c bStep8=new Phoenix_Bid_Process_Steps__c();
        bStep8.Phoenix_Is_Criteria_Step__c = false;
        bStep8.Name= pb.Name+'-'+'Marketing Approval';
        bStep8.Phoenix_Approver__c = UserInfo.getUserId();
        bStep8.Phoenix_Bid__c = pb.Id;
        bStep8.Phoenix_Process_Step__c=	stepsList[1].Id;
        bStep8.Phoenix_Approver_Team__c='Marketing Lead SRx';
        bStep8.Phoenix_Sub_Step__c = 1;
        processList.add(bStep8);
        
        Phoenix_Bid_Process_Steps__c bStep9=new Phoenix_Bid_Process_Steps__c();
        bStep9.Phoenix_Is_Criteria_Step__c = false;
        bStep9.Name= pb.Name+'-'+'Marketing Approval';
        bStep9.Phoenix_Approver__c = UserInfo.getUserId();
        bStep9.Phoenix_Bid__c = pb.Id;
        bStep9.Phoenix_Process_Step__c=	stepsList[1].Id;        
        bStep9.Phoenix_Approver_Team__c='Marketing Lead OTC';
        bStep9.Phoenix_Sub_Step__c = 1;
        processList.add(bStep9);
        
        Phoenix_Bid_Process_Steps__c bStep2=new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name= pb.Name+'-'+'Marketing Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        bStep2.Phoenix_Process_Step__c=	stepsList[1].Id;
        bStep2.Phoenix_Approver_Team__c='Marketing';
        
        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
        Phoenix_Bid_Process_Steps__c bStep3=new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name= pb.Name+'-'+'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb.Id;
        bStep3.Phoenix_Process_Step__c=	stepsList[2].Id;
        bStep3.Phoenix_Approver_Team__c='Finance';
        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        
        Phoenix_Bid_Process_Steps__c bStep4=new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name= pb.Name+'-'+'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb.Id;
        bStep4.Phoenix_Process_Step__c=	stepsList[3].Id;
        bStep4.Phoenix_Approver_Team__c='Contracts';
        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        
        Phoenix_Bid_Process_Steps__c bStep5=new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name= pb.Name+'-'+'Vistex Update';
        bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep5.Phoenix_Status__c =  'In Process';
        bStep5.Phoenix_Approver_Team__c='Home Office';
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
        Phoenix_Bid_Process_Steps__c bStep6=new Phoenix_Bid_Process_Steps__c();
        bStep6.Phoenix_Is_Criteria_Step__c = false;
        bStep6.Name= pb.Name+'-'+'Vistex Update';
        bStep6.Phoenix_Approver__c = UserInfo.getUserId();
        bStep6.Phoenix_Bid__c = pb.Id;
        bStep6.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep6.Phoenix_Status__c =  'In Process';
        bStep6.Phoenix_Sub_Step__c = 1;
        processList.add(bStep6);
        
        Phoenix_Bid_Process_Steps__c bStep7=new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name= pb.Name+'-'+'Closed';
        bStep7.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
               
        Phoenix_Bid_Process_Steps__c bStep10=new Phoenix_Bid_Process_Steps__c();
        bStep10.Phoenix_Is_Criteria_Step__c = false;
        bStep10.Name= pb.Name+'-'+'Customer\'s Update';
        bStep10.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep10.Phoenix_Approver__c = UserInfo.getUserId();
        bStep10.Phoenix_Bid__c = pb.Id;
        bStep10.Phoenix_Sub_Step__c = 1;
        processList.add(bStep10);
        insert processList;
        
        List<Phoenix_Approval_Grid__c> pagList=new List<Phoenix_Approval_Grid__c>();
        Phoenix_Approval_Grid__c pag=new Phoenix_Approval_Grid__c();
		pag.Phoenix_Product_Family__c='Product Family';
		pag.Phoenix_Is_partner_product__c=true;
		pag.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag.Phoenix_Sr_Director_VP__c='Approved';
		pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		//pag.Phoenix_Comments__c='Noted';
		pag.Phoenix_Approval__c='Approved';
		//pag.Phoenix_Business_Head_Comments__c='Noted';
		//pag.Phoenix_Marketing_Lead_OTC__c='Approved';
		//pag.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag.Phoenix_GM_Limit__c='Noted';
		pag.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag.Phoenix_GM__c=2;
		pag.Phoenix_Revenue_Limit__c='Noted';
		pag.Phoenix_Revenue__c=2;
		pag.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag.Phoenix_Annualized_TP_Impact__c=3;
        pag.Phoenix_Annualized_GM_Impact__c=4;
		pag.Phoenix_Annualized_TP__c=3;
		pag.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
		//pag.Phoenix_Annualized_TP__c=4;
       	pag.Phoenix_Is_New_Low__c=false;
        pag.Phoenix_Bid__c=pb.Id;
        pag.Phoenix_Annualized_GM__c=20;
		insert pag;
        
        Phoenix_Approval_Grid__c pag6=new Phoenix_Approval_Grid__c();
		pag6.Phoenix_Product_Family__c='Product Family';
		pag6.Phoenix_Is_partner_product__c=true;
		pag6.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag6.Phoenix_Sr_Director_VP__c='Approved';
		pag6.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag6.Phoenix_Is_SVP_Notification_Required__c=true;
		pag6.Phoenix_Sr_Director_VP__c='Approved';
		//pag6.Phoenix_Comments__c='Noted';
		pag6.Phoenix_Approval__c='Approved';
		//pag6.Phoenix_Business_Head_Comments__c='Noted';
		//pag6.Phoenix_Marketing_Lead_OTC__c='Approved';
		//pag6.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag6.Phoenix_GM_Limit__c='Noted';
		pag6.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag6.Phoenix_GM__c=2;
		pag6.Phoenix_Revenue_Limit__c='Noted';
		pag6.Phoenix_Revenue__c=2;
		pag6.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag6.Phoenix_Annualized_TP_Impact__c=3;
        //pag6.Phoenix_Annualized_GM_Impact__c=4;
		pag6.Phoenix_Annualized_TP__c=3;
		pag6.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
		//pag6.Phoenix_Annualized_TP__c=4;
       	pag6.Phoenix_Is_New_Low__c=false;
        pag6.Phoenix_Bid__c=pb.Id;
        pag6.Phoenix_Annualized_GM__c=20;
		insert pag6;
        
        Phoenix_Approval_Grid__c pag1=new Phoenix_Approval_Grid__c();
		pag1.Phoenix_Product_Family__c='Product Family';
		pag1.Phoenix_Is_partner_product__c=false;
		pag1.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag1.Phoenix_Sr_Director_VP__c='Approved';
		pag1.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag1.Phoenix_Is_SVP_Notification_Required__c=true;
		pag1.Phoenix_Sr_Director_VP__c='Approved';
		//pag1.Phoenix_Comments__c='Noted';
		pag1.Phoenix_Approval__c='Approved';
		//pag1.Phoenix_Business_Head_Comments__c='Noted';
		//pag1.Phoenix_Marketing_Lead_OTC__c='Approved';
		//pag1.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag1.Phoenix_GM_Limit__c='Noted';
		pag1.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag1.Phoenix_GM__c=2;
		pag1.Phoenix_Revenue_Limit__c='Noted';
		pag1.Phoenix_Revenue__c=2;
		pag1.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		//pag1.Phoenix_Annualized_TP_Impact__c=3;
        pag1.Phoenix_Annualized_GM_Impact__c=4;
		//pag1.Phoenix_Annualized_TP__c=3;
		//pag1.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
       	pag1.Phoenix_Is_New_Low__c=true;
        pag1.Phoenix_Bid__c=pb.Id;
        pag1.Phoenix_TP__c=3;
        pag1.Phoenix_TP_Limit__c='Limit';
        
		insert pag1;
        pagList.add(pag1);
        
        Phoenix_Approval_Grid__c pag4=new Phoenix_Approval_Grid__c();
		pag4.Phoenix_Product_Family__c='Product Family';
		pag4.Phoenix_Is_partner_product__c=false;
		pag4.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag4.Phoenix_Sr_Director_VP__c='Approved';
		pag4.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag4.Phoenix_Is_SVP_Notification_Required__c=true;
		pag4.Phoenix_Sr_Director_VP__c='Approved';
		//pag4.Phoenix_Comments__c='Noted';
		pag4.Phoenix_Approval__c='Approved';
		//pag4.Phoenix_Business_Head_Comments__c='Noted';
		//pag4.Phoenix_Marketing_Lead_OTC__c='Approved';
		//pag4.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag4.Phoenix_GM_Limit__c='Noted';
		pag4.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag4.Phoenix_GM__c=2;
		pag4.Phoenix_Revenue_Limit__c='Noted';
		pag4.Phoenix_Revenue__c=2;
		pag4.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		//pag1.Phoenix_Annualized_TP_Impact__c=3;
        pag4.Phoenix_Annualized_GM_Impact__c=4;
		//pag4.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
		pag4.Phoenix_Annualized_TP__c=4;
       	pag4.Phoenix_Is_New_Low__c=true;
        pag4.Phoenix_Bid__c=pb.Id;
		insert pag4;
        pagList.add(pag4);
        
        Phoenix_Approval_Grid__c pag3=new Phoenix_Approval_Grid__c();
		pag3.Phoenix_Product_Family__c='Product Family';
		pag3.Phoenix_Is_partner_product__c=false;
		pag3.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag3.Phoenix_Sr_Director_VP__c='Approved';
		pag3.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag3.Phoenix_Is_SVP_Notification_Required__c=true;
		pag3.Phoenix_Sr_Director_VP__c='Approved';
		//pag3.Phoenix_Comments__c='Noted';
		pag3.Phoenix_Approval__c='Approved';
		//pag3.Phoenix_Business_Head_Comments__c='Noted';
		//pag3.Phoenix_Marketing_Lead_OTC__c='Approved';
		//pag3.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag3.Phoenix_GM_Limit__c='Noted';
		pag3.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag3.Phoenix_GM__c=2;
		pag3.Phoenix_Revenue_Limit__c='Noted';
		pag3.Phoenix_Revenue__c=2;
		//pag3.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		//pag3.Phoenix_Annualized_TP_Impact__c=3;
        pag3.Phoenix_Annualized_GM_Impact__c=4;
		//pag3.Phoenix_Annualized_TP__c=3;
		pag3.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
       	pag3.Phoenix_Is_New_Low__c=false;
        pag3.Phoenix_Bid__c=pb.Id;
		insert pag3;
        pagList.add(pag3);
        
        Phoenix_Approval_Grid__c pag2=new Phoenix_Approval_Grid__c();
		pag2.Phoenix_Product_Family__c='Product Family';
		pag2.Phoenix_Is_partner_product__c=true;
		pag2.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag2.Phoenix_Sr_Director_VP__c='Approved';
		pag2.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag2.Phoenix_Is_SVP_Notification_Required__c=true;
		pag2.Phoenix_Sr_Director_VP__c='Approved';
		//pag2.Phoenix_Comments__c='Noted';
		pag2.Phoenix_Approval__c='Approved';
		//pag2.Phoenix_Business_Head_Comments__c='Noted';
		//pag2.Phoenix_Marketing_Lead_OTC__c='Approved';
		//pag2.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag2.Phoenix_GM_Limit__c='Noted';
		pag2.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag2.Phoenix_GM__c=2;
		pag2.Phoenix_Revenue_Limit__c='Noted';
		pag2.Phoenix_Revenue__c=2;
		//pag2.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag2.Phoenix_Annualized_TP_Impact__c=3;
        //pag2.Phoenix_Annualized_GM_Impact__c=4;
		pag2.Phoenix_Annualized_TP__c=3;
		pag2.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
        pag2.Phoenix_Bid__c=pb.Id;
        pag2.Phoenix_Annualized_GM__c=20;
		insert pag2;
        pagList.add(pag2);
        
        Phoenix_Approval_Grid__c pag5=new Phoenix_Approval_Grid__c();
		pag5.Phoenix_Product_Family__c='Product Family';
		pag5.Phoenix_Is_partner_product__c=true;
		pag5.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag5.Phoenix_Sr_Director_VP__c='Approved';
		pag5.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag5.Phoenix_Is_SVP_Notification_Required__c=true;
		pag5.Phoenix_Sr_Director_VP__c='Approved';
		//pag5.Phoenix_Comments__c='Noted';
		pag5.Phoenix_Approval__c='Approved';
		//pag5.Phoenix_Business_Head_Comments__c='Noted';
		//pag5.Phoenix_Marketing_Lead_OTC__c='Approved';
		//pag5.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag5.Phoenix_GM_Limit__c='Noted';
		pag5.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag5.Phoenix_GM__c=2;
		pag5.Phoenix_Revenue_Limit__c='Noted';
		pag5.Phoenix_Revenue__c=2;
		pag5.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag5.Phoenix_Annualized_TP_Impact__c=3;
        pag5.Phoenix_Annualized_GM_Impact__c=4;
		pag5.Phoenix_Annualized_TP__c=3;
		pag5.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
        pag5.Phoenix_Bid__c=pb.Id;
        pag2.Phoenix_Annualized_GM__c=2323;
		insert pag5;
        pagList.add(pag5);
        
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:pb.Id ];
        system.debug('---bidProcessStepList---'+bidProcessStepList.size());
        list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Vistex_Status__c,Phoenix_MarketingLead_Approver__c,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        
        approvalRequestNotificationClass.approvalRequestNotification(pb.Id,processList);
    }
    static testmethod void approvalRequestNotification_TestMethod3(){
        
        List<Phoenix_User_Approval_Matrix__c> approvalGroups = new List<Phoenix_User_Approval_Matrix__c>();   
        List<Phoenix_User_Approval_Matrix__c> approvalUsers = new List<Phoenix_User_Approval_Matrix__c>();
        List<User> users = new List<User>();    
        List<Phoenix_Bid__c> bidsList = new List<Phoenix_Bid__c>(); 
        List<Phoenix_Bid__c> bidItemList = new List<Phoenix_Bid__c>(); 
        List<Product2> productList = new List<Product2>();
        List<Phoenix_Approval_Matrix__c> bidMatrixList = new List<Phoenix_Approval_Matrix__c>();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list<Product2> prodList = new list<Product2>();
        Product2 prod1 = new Product2(Name = 'Test Product',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='11111',Phoenix_NDC_11__c='12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='22222',Phoenix_NDC_11__c='21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_NDC_11__c='32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c='Product Discontinuation Process';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Internal_Target_Date__c=Date.newInstance(2023, 04, 27);
        pb.Phoenix_Bid_Deadline_Date__c=System.Today();
        pb.Phoenix_is_OTC_Bid__c=true;
        insert pb;
        
        list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        if(approvalGroups.size() ==0){
            Phoenix_User_Approval_Matrix__c group1= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Sales',Phoenix_Approval_Group_Behavior__c='Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Supply Chain',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Marketing',Phoenix_Approval_Group_Behavior__c='Product based');
            approvalGroups.add(group3);
            Phoenix_User_Approval_Matrix__c group4= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Finance',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Contracts',Phoenix_Approval_Group_Behavior__c='Account based');
            approvalGroups.add(group5);
            
            insert approvalGroups;
        }
        if(approvalUsers.size() ==0){
            if(users.size() ==0){
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                String uid = ('Phoenix'+System.now().getTime()).SubString(0,8);
                User u1 = new User(Alias = uid, Email= uid + '@phoenix.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/New_York', UserName= uid + '@phoenix.com');      
                users.add(u1);
                insert users;
            }
            Phoenix_User_Approval_Matrix__c userApp1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[0].Id);
            approvalUsers.add(userApp1);
            Phoenix_User_Approval_Matrix__c userApp2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=users[0].Id,User_Group__c =approvalGroups[2].Id );
            approvalUsers.add(userApp2);
            Phoenix_User_Approval_Matrix__c userApp3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[1].Id);
            approvalUsers.add(userApp3);
            Phoenix_User_Approval_Matrix__c userApp4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[2].Id);
            approvalUsers.add(userApp4);
            Phoenix_User_Approval_Matrix__c userApp5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[3].Id);
            approvalUsers.add(userApp5);
            Phoenix_User_Approval_Matrix__c userApp6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[4].Id);
            approvalUsers.add(userApp6);
            
            insert approvalUsers;
        }
        
        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c='NEW Individual Pricing Agreement (IPA)');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;
        
        List<Phoenix_Approval_Process_Step__c> stepsList = new List<Phoenix_Approval_Process_Step__c>();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for(Phoenix_Approval_Matrix__c matrix : bidMatrixList){
            Phoenix_Approval_Process_Step__c rfpStep1 = new  Phoenix_Approval_Process_Step__c(Name='Initial Submission',Phoenix_Order__c = 1,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep1);
            
            Phoenix_Approval_Process_Step__c rfpStep2 = new  Phoenix_Approval_Process_Step__c(Name='Marketing',Phoenix_Order__c = 2,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Marketing',Phoenix_Approval_Matrix__c=matrix.Id,Phoenix_Approver__c=UserInfo.getUserId());
            stepsList.add(rfpStep2);
            
            
            
            Phoenix_Approval_Process_Step__c rfpStep5 = new  Phoenix_Approval_Process_Step__c(Name='Finance',Phoenix_Order__c = 3,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Finance',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep5);
            Phoenix_Approval_Process_Step__c rfpStep6 = new  Phoenix_Approval_Process_Step__c(Name='Contracts',Phoenix_Order__c = 4,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Contracts',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep6); 
            Phoenix_Approval_Process_Step__c rfpStep7 = new  Phoenix_Approval_Process_Step__c(Name='Vistex Update',Phoenix_Order__c = 5,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Home Office',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep7);
            
            Phoenix_Approval_Process_Step__c rfpStep9 = new  Phoenix_Approval_Process_Step__c(Name='Closed',Phoenix_Order__c = 6,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep9); 
        }
        insert stepsList;        
        
       
        
        List<Phoenix_Approval_Grid__c> pagList=new List<Phoenix_Approval_Grid__c>();
        Phoenix_Approval_Grid__c pag=new Phoenix_Approval_Grid__c();
		pag.Phoenix_Product_Family__c='Product Family';
		pag.Phoenix_Is_partner_product__c=true;
		pag.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag.Phoenix_Sr_Director_VP__c='Approved';
		pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		pag.Phoenix_Comments__c='Noted';
		pag.Phoenix_Approval__c='Approved';
		pag.Phoenix_Business_Head_Comments__c='Noted';
		pag.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag.Phoenix_GM_Limit__c='Noted';
		pag.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag.Phoenix_GM__c=2;
		pag.Phoenix_Revenue_Limit__c='Noted';
		pag.Phoenix_Revenue__c=2;
		pag.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag.Phoenix_Annualized_TP_Impact__c=3;
        pag.Phoenix_Annualized_GM_Impact__c=4;
		pag.Phoenix_Annualized_TP__c=3;
		pag.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
		//pag.Phoenix_Annualized_TP__c=4;
       	pag.Phoenix_Is_New_Low__c=false;
        pag.Phoenix_Bid__c=pb.Id;
		insert pag;
        pagList.add(pag);
     
        Phoenix_Approval_Grid__c pag1=new Phoenix_Approval_Grid__c();
		pag1.Phoenix_Product_Family__c='Product Family';
		pag1.Phoenix_Is_partner_product__c=false;
		pag1.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag1.Phoenix_Sr_Director_VP__c='Approved';
		pag1.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag1.Phoenix_Is_SVP_Notification_Required__c=true;
		pag1.Phoenix_Sr_Director_VP__c='Approved';
		pag1.Phoenix_Comments__c='Noted';
		pag1.Phoenix_Approval__c='Approved';
		pag1.Phoenix_Business_Head_Comments__c='Noted';
		pag1.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag1.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag1.Phoenix_GM_Limit__c='Noted';
		pag1.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag1.Phoenix_GM__c=2;
		pag1.Phoenix_Revenue_Limit__c='Noted';
		pag1.Phoenix_Revenue__c=2;
		pag1.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag1.Phoenix_Annualized_TP_Impact__c=3;
        pag1.Phoenix_Annualized_GM_Impact__c=4;
		pag1.Phoenix_Annualized_TP__c=3;
		pag1.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
		pag1.Phoenix_Annualized_TP__c=4;
       	pag1.Phoenix_Is_New_Low__c=true;
        pag1.Phoenix_Bid__c=pb.Id;
		insert pag1;
        pagList.add(pag1);
        
        Phoenix_Approval_Grid__c pag3=new Phoenix_Approval_Grid__c();
		pag3.Phoenix_Product_Family__c='Product Family';
		pag3.Phoenix_Is_partner_product__c=false;
		pag3.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag3.Phoenix_Sr_Director_VP__c='Approved';
		pag3.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag3.Phoenix_Is_SVP_Notification_Required__c=true;
		pag3.Phoenix_Sr_Director_VP__c='Approved';
		pag3.Phoenix_Comments__c='Noted';
		pag3.Phoenix_Approval__c='Approved';
		pag3.Phoenix_Business_Head_Comments__c='Noted';
		pag3.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag3.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag3.Phoenix_GM_Limit__c='Noted';
		pag3.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag3.Phoenix_GM__c=2;
		pag3.Phoenix_Revenue_Limit__c='Noted';
		pag3.Phoenix_Revenue__c=2;
		pag3.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag3.Phoenix_Annualized_TP_Impact__c=3;
        pag3.Phoenix_Annualized_GM_Impact__c=4;
		pag3.Phoenix_Annualized_TP__c=3;
		pag3.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
       	pag3.Phoenix_Is_New_Low__c=false;
        pag3.Phoenix_Bid__c=pb.Id;
		insert pag3;
        pagList.add(pag3);
        
        Phoenix_Approval_Grid__c pag2=new Phoenix_Approval_Grid__c();
		pag2.Phoenix_Product_Family__c='Product Family';
		pag2.Phoenix_Is_partner_product__c=true;
		pag2.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag2.Phoenix_Sr_Director_VP__c='Approved';
		pag2.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag2.Phoenix_Is_SVP_Notification_Required__c=true;
		pag2.Phoenix_Sr_Director_VP__c='Approved';
		pag2.Phoenix_Comments__c='Noted';
		pag2.Phoenix_Approval__c='Approved';
		pag2.Phoenix_Business_Head_Comments__c='Noted';
		pag2.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag2.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag2.Phoenix_GM_Limit__c='Noted';
		pag2.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag2.Phoenix_GM__c=2;
		pag2.Phoenix_Revenue_Limit__c='Noted';
		pag2.Phoenix_Revenue__c=2;
		pag2.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag2.Phoenix_Annualized_TP_Impact__c=3;
        //pag2.Phoenix_Annualized_GM_Impact__c=4;
		pag2.Phoenix_Annualized_TP__c=3;
		pag2.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
        pag2.Phoenix_Bid__c=pb.Id;
		insert pag2;
        pagList.add(pag2);
        Product_Family__c pf=new Product_Family__c();
        pf.Name='Product';
        insert pf;
          
        Phoenix_NDC_Change__c ndc=new Phoenix_NDC_Change__c();
       	//ndc.Proposed_Product_Family__c=pf.Id;
        ndc.Phoenix_Approval_Status__c='Closed';
        insert ndc;
       
       	Phoenix_NDC_Change_Line_Item__c phsLine=new Phoenix_NDC_Change_Line_Item__c();
       	phsLine.Phoenix_Remarks__c='Remarks';
        phsLine.Phoenix_Current_Product__c=prod1.Id;
        phsLine.Phoenix_NDC_Change__c=ndc.Id;
        phsLine.Phoenix_NDC_Change__c=ndc.Id;
        phsLine.Phoenix_Final_Status__c = 'Not Approved';
        phsLine.Phoenix_Is_Rejection_Noti_All_Sent__c = false;                                                                             
        insert phsLine;
          
         list<Phoenix_Bid_Process_Steps__c>processList=new list<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c bStep=new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c=	stepsList[0].Id;
        system.debug('stepsList[0].Id---------------'+stepsList[0].Id);
        bStep.Name= pb.Name+'-'+'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        bStep.Phoenix_Status__c =  'Submitted';
        bStep.Phoenix_Sub_Step__c = 1;
        bStep.Phoenix_Approver_Team__c = 'Marketing Lead Rx';
        processList.add(bStep);
        
        Phoenix_Bid_Process_Steps__c bStep8=new Phoenix_Bid_Process_Steps__c();
        bStep8.Phoenix_Is_Criteria_Step__c = false;
        bStep8.Name= pb.Name+'-'+'Marketing Approval';
        bStep8.Phoenix_Approver__c = UserInfo.getUserId();
        bStep8.Phoenix_Bid__c = pb.Id;
        bStep8.Phoenix_Process_Step__c=	stepsList[1].Id;
        bStep8.Phoenix_Approver_Team__c='Marketing Lead SRx';
        bStep8.Phoenix_Sub_Step__c = 1;
        processList.add(bStep8);
        
        Phoenix_Bid_Process_Steps__c bStep9=new Phoenix_Bid_Process_Steps__c();
        bStep9.Phoenix_Is_Criteria_Step__c = false;
        bStep9.Name= pb.Name+'-'+'Marketing Approval';
        bStep9.Phoenix_Approver__c = UserInfo.getUserId();
        bStep9.Phoenix_Bid__c = pb.Id;
        bStep9.Phoenix_Process_Step__c=	stepsList[1].Id;        
        bStep9.Phoenix_Approver_Team__c='Marketing Lead OTC';
        bStep9.Phoenix_Sub_Step__c = 1;
        processList.add(bStep9);
        
        Phoenix_Bid_Process_Steps__c bStep2=new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name= pb.Name+'-'+'Marketing Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        bStep2.Phoenix_Process_Step__c=	stepsList[1].Id;
        bStep2.Phoenix_Approver_Team__c='Marketing';
        
        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
        Phoenix_Bid_Process_Steps__c bStep3=new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name= pb.Name+'-'+'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb.Id;
        bStep3.Phoenix_Process_Step__c=	stepsList[2].Id;
        bStep3.Phoenix_Approver_Team__c='Finance';
        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        
        Phoenix_Bid_Process_Steps__c bStep4=new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name= pb.Name+'-'+'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb.Id;
        bStep4.Phoenix_Process_Step__c=	stepsList[3].Id;
        bStep4.Phoenix_Approver_Team__c='Contracts';
        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        
        Phoenix_Bid_Process_Steps__c bStep5=new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name= pb.Name+'-'+'Vistex Update';
        bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep5.Phoenix_Status__c =  'In Process';
        bStep5.Phoenix_Approver_Team__c='Home Office';
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
        Phoenix_Bid_Process_Steps__c bStep6=new Phoenix_Bid_Process_Steps__c();
        bStep6.Phoenix_Is_Criteria_Step__c = false;
        bStep6.Name= pb.Name+'-'+'Vistex Update';
        bStep6.Phoenix_Approver__c = UserInfo.getUserId();
        bStep6.Phoenix_Bid__c = pb.Id;
        bStep6.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep6.Phoenix_Status__c =  'In Process';
        bStep6.Phoenix_Sub_Step__c = 1;
        processList.add(bStep6);
        
        Phoenix_Bid_Process_Steps__c bStep7=new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name= pb.Name+'-'+'Closed';
        bStep7.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
               
        Phoenix_Bid_Process_Steps__c bStep10=new Phoenix_Bid_Process_Steps__c();
        bStep10.Phoenix_Is_Criteria_Step__c = false;
        bStep10.Name= pb.Name+'-'+'Customer\'s Update';
        bStep10.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep10.Phoenix_Approver__c = UserInfo.getUserId();
        bStep10.Phoenix_Bid__c = pb.Id;
        bStep10.Phoenix_Sub_Step__c = 1;
        bStep10.Phoenix_NDC_Change__c=ndc.Id;
        processList.add(bStep10);
        insert processList;
        
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:pb.Id ];
        system.debug('---bidProcessStepList---'+bidProcessStepList.size());
        list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Vistex_Status__c,Phoenix_MarketingLead_Approver__c,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        
        approvalRequestNotificationClass.approvalRequestNotification(ndc.Id,processList);
        //approvalRequestNotificationOldClass.codeCoverageBlock();
    }
    static testmethod void approvalRequestNotification_TestMethod4(){
        
        List<Phoenix_User_Approval_Matrix__c> approvalGroups = new List<Phoenix_User_Approval_Matrix__c>();   
        List<Phoenix_User_Approval_Matrix__c> approvalUsers = new List<Phoenix_User_Approval_Matrix__c>();
        List<User> users = new List<User>();    
        List<Phoenix_Bid__c> bidsList = new List<Phoenix_Bid__c>(); 
        List<Phoenix_Bid__c> bidItemList = new List<Phoenix_Bid__c>(); 
        List<Product2> productList = new List<Product2>();
        List<Phoenix_Approval_Matrix__c> bidMatrixList = new List<Phoenix_Approval_Matrix__c>();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list<Product2> prodList = new list<Product2>();
        Product2 prod1 = new Product2(Name = 'Test Product',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='11111',Phoenix_NDC_11__c='12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='22222',Phoenix_NDC_11__c='21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_NDC_11__c='32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c='Platform OTB';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Internal_Target_Date__c=Date.newInstance(2023, 04, 27);
        pb.Phoenix_Bid_Deadline_Date__c=System.Today();
        pb.Phoenix_is_OTC_Bid__c=true;
        insert pb;
        
        list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        if(approvalGroups.size() ==0){
            Phoenix_User_Approval_Matrix__c group1= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Sales',Phoenix_Approval_Group_Behavior__c='Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Supply Chain',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Marketing',Phoenix_Approval_Group_Behavior__c='Product based');
            approvalGroups.add(group3);
            Phoenix_User_Approval_Matrix__c group4= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Finance',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Contracts',Phoenix_Approval_Group_Behavior__c='Account based');
            approvalGroups.add(group5);
            
            insert approvalGroups;
        }
        if(approvalUsers.size() ==0){
            if(users.size() ==0){
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                String uid = ('Phoenix'+System.now().getTime()).SubString(0,8);
                User u1 = new User(Alias = uid, Email= uid + '@phoenix.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/New_York', UserName= uid + '@phoenix.com');      
                users.add(u1);
                insert users;
            }
            Phoenix_User_Approval_Matrix__c userApp1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[0].Id);
            approvalUsers.add(userApp1);
            Phoenix_User_Approval_Matrix__c userApp2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=users[0].Id,User_Group__c =approvalGroups[2].Id );
            approvalUsers.add(userApp2);
            Phoenix_User_Approval_Matrix__c userApp3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[1].Id);
            approvalUsers.add(userApp3);
            Phoenix_User_Approval_Matrix__c userApp4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[2].Id);
            approvalUsers.add(userApp4);
            Phoenix_User_Approval_Matrix__c userApp5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[3].Id);
            approvalUsers.add(userApp5);
            Phoenix_User_Approval_Matrix__c userApp6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[4].Id);
            approvalUsers.add(userApp6);
            
            insert approvalUsers;
        }
        
        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c='NEW Individual Pricing Agreement (IPA)');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;
        
        List<Phoenix_Approval_Process_Step__c> stepsList = new List<Phoenix_Approval_Process_Step__c>();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for(Phoenix_Approval_Matrix__c matrix : bidMatrixList){
            Phoenix_Approval_Process_Step__c rfpStep1 = new  Phoenix_Approval_Process_Step__c(Name='Initial Submission',Phoenix_Order__c = 1,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep1);
            
            Phoenix_Approval_Process_Step__c rfpStep2 = new  Phoenix_Approval_Process_Step__c(Name='Marketing',Phoenix_Order__c = 2,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Marketing',Phoenix_Approval_Matrix__c=matrix.Id,Phoenix_Approver__c=UserInfo.getUserId());
            stepsList.add(rfpStep2);            
            
            Phoenix_Approval_Process_Step__c rfpStep5 = new  Phoenix_Approval_Process_Step__c(Name='Finance',Phoenix_Order__c = 3,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Finance',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep5);
            Phoenix_Approval_Process_Step__c rfpStep6 = new  Phoenix_Approval_Process_Step__c(Name='Contracts',Phoenix_Order__c = 4,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Contracts',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep6); 
            Phoenix_Approval_Process_Step__c rfpStep7 = new  Phoenix_Approval_Process_Step__c(Name='Vistex Update',Phoenix_Order__c = 5,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Home Office',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep7);
            
            Phoenix_Approval_Process_Step__c rfpStep9 = new  Phoenix_Approval_Process_Step__c(Name='Closed',Phoenix_Order__c = 6,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep9); 
        }
        insert stepsList;        
        
       
        
        List<Phoenix_Approval_Grid__c> pagList=new List<Phoenix_Approval_Grid__c>();
        Phoenix_Approval_Grid__c pag=new Phoenix_Approval_Grid__c();
		pag.Phoenix_Product_Family__c='Product Family';
		pag.Phoenix_Is_partner_product__c=true;
		pag.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag.Phoenix_Sr_Director_VP__c='Approved';
		pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		pag.Phoenix_Comments__c='Noted';
		pag.Phoenix_Approval__c='Approved';
		pag.Phoenix_Business_Head_Comments__c='Noted';
		pag.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag.Phoenix_GM_Limit__c='Noted';
		pag.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag.Phoenix_GM__c=2;
		pag.Phoenix_Revenue_Limit__c='Noted';
		pag.Phoenix_Revenue__c=2;
		pag.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag.Phoenix_Annualized_TP_Impact__c=3;
        pag.Phoenix_Annualized_GM_Impact__c=4;
		pag.Phoenix_Annualized_TP__c=3;
		pag.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
		//pag.Phoenix_Annualized_TP__c=4;
       	pag.Phoenix_Is_New_Low__c=false;
        pag.Phoenix_Bid__c=pb.Id;
		insert pag;
        pagList.add(pag);
     
        Phoenix_Approval_Grid__c pag1=new Phoenix_Approval_Grid__c();
		pag1.Phoenix_Product_Family__c='Product Family';
		pag1.Phoenix_Is_partner_product__c=false;
		pag1.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag1.Phoenix_Sr_Director_VP__c='Approved';
		pag1.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag1.Phoenix_Is_SVP_Notification_Required__c=true;
		pag1.Phoenix_Sr_Director_VP__c='Approved';
		pag1.Phoenix_Comments__c='Noted';
		pag1.Phoenix_Approval__c='Approved';
		pag1.Phoenix_Business_Head_Comments__c='Noted';
		pag1.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag1.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag1.Phoenix_GM_Limit__c='Noted';
		pag1.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag1.Phoenix_GM__c=2;
		pag1.Phoenix_Revenue_Limit__c='Noted';
		pag1.Phoenix_Revenue__c=2;
		pag1.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		//pag1.Phoenix_Annualized_TP_Impact__c=3;
        pag1.Phoenix_Annualized_GM_Impact__c=4;
		pag1.Phoenix_Annualized_TP__c=3;
		pag1.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
		pag1.Phoenix_Annualized_TP__c=4;
       	pag1.Phoenix_Is_New_Low__c=true;
        pag1.Phoenix_Bid__c=pb.Id;
		insert pag1;
        pagList.add(pag1);
        
        Phoenix_Approval_Grid__c pag3=new Phoenix_Approval_Grid__c();
		pag3.Phoenix_Product_Family__c='Product Family';
		pag3.Phoenix_Is_partner_product__c=false;
		pag3.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag3.Phoenix_Sr_Director_VP__c='Approved';
		pag3.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag3.Phoenix_Is_SVP_Notification_Required__c=true;
		pag3.Phoenix_Sr_Director_VP__c='Approved';
		pag3.Phoenix_Comments__c='Noted';
		pag3.Phoenix_Approval__c='Approved';
		pag3.Phoenix_Business_Head_Comments__c='Noted';
		pag3.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag3.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag3.Phoenix_GM_Limit__c='Noted';
		pag3.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag3.Phoenix_GM__c=2;
		pag3.Phoenix_Revenue_Limit__c='Noted';
		pag3.Phoenix_Revenue__c=2;
		pag3.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag3.Phoenix_Annualized_TP_Impact__c=3;
        pag3.Phoenix_Annualized_GM_Impact__c=4;
		pag3.Phoenix_Annualized_TP__c=3;
		pag3.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
       	pag3.Phoenix_Is_New_Low__c=false;
        pag3.Phoenix_Bid__c=pb.Id;
		insert pag3;
        pagList.add(pag3);
        
        Phoenix_Approval_Grid__c pag2=new Phoenix_Approval_Grid__c();
		pag2.Phoenix_Product_Family__c='Product Family';
		pag2.Phoenix_Is_partner_product__c=true;
		pag2.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag2.Phoenix_Sr_Director_VP__c='Approved';
		pag2.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag2.Phoenix_Is_SVP_Notification_Required__c=true;
		pag2.Phoenix_Sr_Director_VP__c='Approved';
		pag2.Phoenix_Comments__c='Noted';
		pag2.Phoenix_Approval__c='Approved';
		pag2.Phoenix_Business_Head_Comments__c='Noted';
		pag2.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag2.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag2.Phoenix_GM_Limit__c='Noted';
		pag2.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag2.Phoenix_GM__c=2;
		pag2.Phoenix_Revenue_Limit__c='Noted';
		pag2.Phoenix_Revenue__c=2;
		pag2.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag2.Phoenix_Annualized_TP_Impact__c=3;
        //pag2.Phoenix_Annualized_GM_Impact__c=4;
		pag2.Phoenix_Annualized_TP__c=3;
		pag2.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
        pag2.Phoenix_Bid__c=pb.Id;
		insert pag2;
        pagList.add(pag2);
        
        Product_Family__c pf=new Product_Family__c();
        pf.Name='Product';
        insert pf;
        
       	Phoenix_WAC_Change__c wac=new Phoenix_WAC_Change__c();
        wac.Product_Family__c=pf.Id;
        insert wac;
        
        Phoenix_WAC_Change_Line_Item__c wacLine=new Phoenix_WAC_Change_Line_Item__c();
        wacLine.Phoenix_WAC_Change__c=wac.Id;
        wacLine.Product_Family__c=pf.id;
        wacLine.Phoenix_Product__c=prod2.Id;
        wacLine.Phoenix_Final_Status__c = 'Not Approved';
        wacLine.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
        wacLine.Phoenix_Cust_Name__c='Customer';
       	insert wacLine;        
          
         list<Phoenix_Bid_Process_Steps__c>processList=new list<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c bStep=new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c=	stepsList[0].Id;
        system.debug('stepsList[0].Id---------------'+stepsList[0].Id);
        bStep.Name= pb.Name+'-'+'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        bStep.Phoenix_Status__c =  'Submitted';
        bStep.Phoenix_Sub_Step__c = 1;
        bStep.Phoenix_Approver_Team__c = 'Marketing Lead Rx';
        processList.add(bStep);
        
        Phoenix_Bid_Process_Steps__c bStep8=new Phoenix_Bid_Process_Steps__c();
        bStep8.Phoenix_Is_Criteria_Step__c = false;
        bStep8.Name= pb.Name+'-'+'Marketing Approval';
        bStep8.Phoenix_Approver__c = UserInfo.getUserId();
        bStep8.Phoenix_Bid__c = pb.Id;
        bStep8.Phoenix_Process_Step__c=	stepsList[1].Id;
        bStep8.Phoenix_Approver_Team__c='Marketing Lead SRx';
        bStep8.Phoenix_Sub_Step__c = 1;
        processList.add(bStep8);
        
        Phoenix_Bid_Process_Steps__c bStep9=new Phoenix_Bid_Process_Steps__c();
        bStep9.Phoenix_Is_Criteria_Step__c = false;
        bStep9.Name= pb.Name+'-'+'Marketing Approval';
        bStep9.Phoenix_Approver__c = UserInfo.getUserId();
        bStep9.Phoenix_Bid__c = pb.Id;
        bStep9.Phoenix_Process_Step__c=	stepsList[1].Id;        
        bStep9.Phoenix_Approver_Team__c='Marketing Lead OTC';
        bStep9.Phoenix_Sub_Step__c = 1;
        processList.add(bStep9);
        
        Phoenix_Bid_Process_Steps__c bStep2=new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name= pb.Name+'-'+'Marketing Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        bStep2.Phoenix_Process_Step__c=	stepsList[1].Id;
        bStep2.Phoenix_Approver_Team__c='Marketing';
        
        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
        Phoenix_Bid_Process_Steps__c bStep3=new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name= pb.Name+'-'+'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb.Id;
        bStep3.Phoenix_Process_Step__c=	stepsList[2].Id;
        bStep3.Phoenix_Approver_Team__c='Finance';
        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        
        Phoenix_Bid_Process_Steps__c bStep4=new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name= pb.Name+'-'+'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb.Id;
        bStep4.Phoenix_Process_Step__c=	stepsList[3].Id;
        bStep4.Phoenix_Approver_Team__c='Contracts';
        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        
        Phoenix_Bid_Process_Steps__c bStep5=new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name= pb.Name+'-'+'Vistex Update';
        bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep5.Phoenix_Status__c =  'In Process';
        bStep5.Phoenix_Approver_Team__c='Home Office';
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
        Phoenix_Bid_Process_Steps__c bStep6=new Phoenix_Bid_Process_Steps__c();
        bStep6.Phoenix_Is_Criteria_Step__c = false;
        bStep6.Name= pb.Name+'-'+'Vistex Update';
        bStep6.Phoenix_Approver__c = UserInfo.getUserId();
        bStep6.Phoenix_Bid__c = pb.Id;
        bStep6.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep6.Phoenix_Status__c =  'In Process';
        bStep6.Phoenix_Sub_Step__c = 1;
        processList.add(bStep6);
        
        Phoenix_Bid_Process_Steps__c bStep7=new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name= pb.Name+'-'+'Closed';
        bStep7.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
               
        Phoenix_Bid_Process_Steps__c bStep10=new Phoenix_Bid_Process_Steps__c();
        bStep10.Phoenix_Is_Criteria_Step__c = false;
        bStep10.Name= pb.Name+'-'+'Customer\'s Update';
        bStep10.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep10.Phoenix_Approver__c = UserInfo.getUserId();
        bStep10.Phoenix_Bid__c = pb.Id;
        bStep10.Phoenix_Sub_Step__c = 1;
        bStep10.Phoenix_WAC_Change__c=wac.Id;
        processList.add(bStep10);
        insert processList;
        
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:pb.Id ];
        system.debug('---bidProcessStepList---'+bidProcessStepList.size());
        list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Vistex_Status__c,Phoenix_MarketingLead_Approver__c,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        
        approvalRequestNotificationClass.approvalRequestNotification(wac.Id,processList);
        //Phoenix_SubmitBidForApprovalCtrl.
        //approvalRequestNotificationOldClass.codeCoverageBlock();
    }
	static testmethod void approvalRequestNotification_TestMethod5(){
        
        List<Phoenix_User_Approval_Matrix__c> approvalGroups = new List<Phoenix_User_Approval_Matrix__c>();   
        List<Phoenix_User_Approval_Matrix__c> approvalUsers = new List<Phoenix_User_Approval_Matrix__c>();
        List<User> users = new List<User>();    
        List<Phoenix_Bid__c> bidsList = new List<Phoenix_Bid__c>(); 
        List<Phoenix_Bid__c> bidItemList = new List<Phoenix_Bid__c>(); 
        List<Product2> productList = new List<Product2>();
        List<Phoenix_Approval_Matrix__c> bidMatrixList = new List<Phoenix_Approval_Matrix__c>();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list<Product2> prodList = new list<Product2>();
        Product2 prod1 = new Product2(Name = 'Test Product',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='11111',Phoenix_NDC_11__c='12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='22222',Phoenix_NDC_11__c='21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_NDC_11__c='32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c='Product Discontinuation Process';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Internal_Target_Date__c=Date.newInstance(2023, 04, 27);
        pb.Phoenix_Bid_Deadline_Date__c=System.Today();
        pb.Phoenix_is_OTC_Bid__c=true;
        insert pb;
        
        list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        if(approvalGroups.size() ==0){
            Phoenix_User_Approval_Matrix__c group1= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Sales',Phoenix_Approval_Group_Behavior__c='Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Supply Chain',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Marketing',Phoenix_Approval_Group_Behavior__c='Product based');
            approvalGroups.add(group3);
            Phoenix_User_Approval_Matrix__c group4= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Finance',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Contracts',Phoenix_Approval_Group_Behavior__c='Account based');
            approvalGroups.add(group5);
            
            insert approvalGroups;
        }
        if(approvalUsers.size() ==0){
            if(users.size() ==0){
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                String uid = ('Phoenix'+System.now().getTime()).SubString(0,8);
                User u1 = new User(Alias = uid, Email= uid + '@phoenix.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/New_York', UserName= uid + '@phoenix.com');      
                users.add(u1);
                insert users;
            }
            Phoenix_User_Approval_Matrix__c userApp1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[0].Id);
            approvalUsers.add(userApp1);
            Phoenix_User_Approval_Matrix__c userApp2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=users[0].Id,User_Group__c =approvalGroups[2].Id );
            approvalUsers.add(userApp2);
            Phoenix_User_Approval_Matrix__c userApp3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[1].Id);
            approvalUsers.add(userApp3);
            Phoenix_User_Approval_Matrix__c userApp4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[2].Id);
            approvalUsers.add(userApp4);
            Phoenix_User_Approval_Matrix__c userApp5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[3].Id);
            approvalUsers.add(userApp5);
            Phoenix_User_Approval_Matrix__c userApp6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[4].Id);
            approvalUsers.add(userApp6);
            
            insert approvalUsers;
        }
        
        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c='NEW Individual Pricing Agreement (IPA)');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;
        
        List<Phoenix_Approval_Process_Step__c> stepsList = new List<Phoenix_Approval_Process_Step__c>();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for(Phoenix_Approval_Matrix__c matrix : bidMatrixList){
            Phoenix_Approval_Process_Step__c rfpStep1 = new  Phoenix_Approval_Process_Step__c(Name='Initial Submission',Phoenix_Order__c = 1,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep1);
            
            Phoenix_Approval_Process_Step__c rfpStep2 = new  Phoenix_Approval_Process_Step__c(Name='Marketing',Phoenix_Order__c = 2,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Marketing',Phoenix_Approval_Matrix__c=matrix.Id,Phoenix_Approver__c=UserInfo.getUserId());
            stepsList.add(rfpStep2);
            
            
            
            Phoenix_Approval_Process_Step__c rfpStep5 = new  Phoenix_Approval_Process_Step__c(Name='Finance',Phoenix_Order__c = 3,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Finance',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep5);
            Phoenix_Approval_Process_Step__c rfpStep6 = new  Phoenix_Approval_Process_Step__c(Name='Contracts',Phoenix_Order__c = 4,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Contracts',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep6); 
            Phoenix_Approval_Process_Step__c rfpStep7 = new  Phoenix_Approval_Process_Step__c(Name='Vistex Update',Phoenix_Order__c = 5,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Home Office',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep7);
            
            Phoenix_Approval_Process_Step__c rfpStep9 = new  Phoenix_Approval_Process_Step__c(Name='Closed',Phoenix_Order__c = 6,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep9); 
        }
        insert stepsList;        
        
       
        
        List<Phoenix_Approval_Grid__c> pagList=new List<Phoenix_Approval_Grid__c>();
        Phoenix_Approval_Grid__c pag=new Phoenix_Approval_Grid__c();
		pag.Phoenix_Product_Family__c='Product Family';
		pag.Phoenix_Is_partner_product__c=true;
		pag.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag.Phoenix_Sr_Director_VP__c='Approved';
		pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		pag.Phoenix_Comments__c='Noted';
		pag.Phoenix_Approval__c='Approved';
		pag.Phoenix_Business_Head_Comments__c='Noted';
		pag.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag.Phoenix_GM_Limit__c='Noted';
		pag.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag.Phoenix_GM__c=2;
		pag.Phoenix_Revenue_Limit__c='Noted';
		pag.Phoenix_Revenue__c=2;
		pag.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag.Phoenix_Annualized_TP_Impact__c=3;
        pag.Phoenix_Annualized_GM_Impact__c=4;
		pag.Phoenix_Annualized_TP__c=3;
		pag.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
		//pag.Phoenix_Annualized_TP__c=4;
       	pag.Phoenix_Is_New_Low__c=false;
        pag.Phoenix_Bid__c=pb.Id;
		insert pag;
        pagList.add(pag);
     
        Phoenix_Approval_Grid__c pag1=new Phoenix_Approval_Grid__c();
		pag1.Phoenix_Product_Family__c='Product Family';
		pag1.Phoenix_Is_partner_product__c=false;
		pag1.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag1.Phoenix_Sr_Director_VP__c='Approved';
		pag1.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag1.Phoenix_Is_SVP_Notification_Required__c=true;
		pag1.Phoenix_Sr_Director_VP__c='Approved';
		pag1.Phoenix_Comments__c='Noted';
		pag1.Phoenix_Approval__c='Approved';
		pag1.Phoenix_Business_Head_Comments__c='Noted';
		pag1.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag1.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag1.Phoenix_GM_Limit__c='Noted';
		pag1.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag1.Phoenix_GM__c=2;
		pag1.Phoenix_Revenue_Limit__c='Noted';
		pag1.Phoenix_Revenue__c=2;
		pag1.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag1.Phoenix_Annualized_TP_Impact__c=3;
        pag1.Phoenix_Annualized_GM_Impact__c=4;
		pag1.Phoenix_Annualized_TP__c=3;
		pag1.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
		pag1.Phoenix_Annualized_TP__c=4;
       	pag1.Phoenix_Is_New_Low__c=true;
        pag1.Phoenix_Bid__c=pb.Id;
		insert pag1;
        pagList.add(pag1);
        
        Phoenix_Approval_Grid__c pag3=new Phoenix_Approval_Grid__c();
		pag3.Phoenix_Product_Family__c='Product Family';
		pag3.Phoenix_Is_partner_product__c=false;
		pag3.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag3.Phoenix_Sr_Director_VP__c='Approved';
		pag3.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag3.Phoenix_Is_SVP_Notification_Required__c=true;
		pag3.Phoenix_Sr_Director_VP__c='Approved';
		pag3.Phoenix_Comments__c='Noted';
		pag3.Phoenix_Approval__c='Approved';
		pag3.Phoenix_Business_Head_Comments__c='Noted';
		pag3.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag3.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag3.Phoenix_GM_Limit__c='Noted';
		pag3.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag3.Phoenix_GM__c=2;
		pag3.Phoenix_Revenue_Limit__c='Noted';
		pag3.Phoenix_Revenue__c=2;
		pag3.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag3.Phoenix_Annualized_TP_Impact__c=3;
        pag3.Phoenix_Annualized_GM_Impact__c=4;
		pag3.Phoenix_Annualized_TP__c=3;
		pag3.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
       	pag3.Phoenix_Is_New_Low__c=false;
        pag3.Phoenix_Bid__c=pb.Id;
		insert pag3;
        pagList.add(pag3);
        
        Phoenix_Approval_Grid__c pag2=new Phoenix_Approval_Grid__c();
		pag2.Phoenix_Product_Family__c='Product Family';
		pag2.Phoenix_Is_partner_product__c=true;
		pag2.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag2.Phoenix_Sr_Director_VP__c='Approved';
		pag2.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag2.Phoenix_Is_SVP_Notification_Required__c=true;
		pag2.Phoenix_Sr_Director_VP__c='Approved';
		pag2.Phoenix_Comments__c='Noted';
		pag2.Phoenix_Approval__c='Approved';
		pag2.Phoenix_Business_Head_Comments__c='Noted';
		pag2.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag2.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag2.Phoenix_GM_Limit__c='Noted';
		pag2.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag2.Phoenix_GM__c=2;
		pag2.Phoenix_Revenue_Limit__c='Noted';
		pag2.Phoenix_Revenue__c=2;
		pag2.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag2.Phoenix_Annualized_TP_Impact__c=3;
        //pag2.Phoenix_Annualized_GM_Impact__c=4;
		pag2.Phoenix_Annualized_TP__c=3;
		pag2.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
        pag2.Phoenix_Bid__c=pb.Id;
		insert pag2;
        pagList.add(pag2);
        Product_Family__c pf=new Product_Family__c();
        pf.Name='Product';
        insert pf;
          
        Phoenix_PHS_Price_Change__c phs=new Phoenix_PHS_Price_Change__c();
       	phs.Phoenix_Account__c=testAccount.Id;
        phs.Phoenix_Approval_Status__c='Closed';
        insert phs;
       
       	Phoenix_PHS_Price_Change_Line__c phsLine=new Phoenix_PHS_Price_Change_Line__c();
       	phsLine.Phoenix_Remarks__c='Remarks';
        phsLine.Phoenix_Product_Name__c=prod1.Id;
        phsLine.Phoenix_PHS_Price_Change__c=phs.Id;
        phsLine.Phoenix_Final_Status__c = 'Not Approved';
        phsLine.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
        insert phsLine;
          
         list<Phoenix_Bid_Process_Steps__c>processList=new list<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c bStep=new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c=	stepsList[0].Id;
        system.debug('stepsList[0].Id---------------'+stepsList[0].Id);
        bStep.Name= pb.Name+'-'+'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        bStep.Phoenix_Status__c =  'Submitted';
        bStep.Phoenix_Sub_Step__c = 1;
        bStep.Phoenix_Approver_Team__c = 'Marketing Lead Rx';
        processList.add(bStep);
        
        Phoenix_Bid_Process_Steps__c bStep8=new Phoenix_Bid_Process_Steps__c();
        bStep8.Phoenix_Is_Criteria_Step__c = false;
        bStep8.Name= pb.Name+'-'+'Marketing Approval';
        bStep8.Phoenix_Approver__c = UserInfo.getUserId();
        bStep8.Phoenix_Bid__c = pb.Id;
        bStep8.Phoenix_Process_Step__c=	stepsList[1].Id;
        bStep8.Phoenix_Approver_Team__c='Marketing Lead SRx';
        bStep8.Phoenix_Sub_Step__c = 1;
        processList.add(bStep8);
        
        Phoenix_Bid_Process_Steps__c bStep9=new Phoenix_Bid_Process_Steps__c();
        bStep9.Phoenix_Is_Criteria_Step__c = false;
        bStep9.Name= pb.Name+'-'+'Marketing Approval';
        bStep9.Phoenix_Approver__c = UserInfo.getUserId();
        bStep9.Phoenix_Bid__c = pb.Id;
        bStep9.Phoenix_Process_Step__c=	stepsList[1].Id;        
        bStep9.Phoenix_Approver_Team__c='Marketing Lead OTC';
        bStep9.Phoenix_Sub_Step__c = 1;
        processList.add(bStep9);
        
        Phoenix_Bid_Process_Steps__c bStep2=new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name= pb.Name+'-'+'Marketing Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        bStep2.Phoenix_Process_Step__c=	stepsList[1].Id;
        bStep2.Phoenix_Approver_Team__c='Marketing';
        
        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
        Phoenix_Bid_Process_Steps__c bStep3=new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name= pb.Name+'-'+'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb.Id;
        bStep3.Phoenix_Process_Step__c=	stepsList[2].Id;
        bStep3.Phoenix_Approver_Team__c='Finance';
        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        
        Phoenix_Bid_Process_Steps__c bStep4=new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name= pb.Name+'-'+'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb.Id;
        bStep4.Phoenix_Process_Step__c=	stepsList[3].Id;
        bStep4.Phoenix_Approver_Team__c='Contracts';
        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        
        Phoenix_Bid_Process_Steps__c bStep5=new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name= pb.Name+'-'+'Vistex Update';
        bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep5.Phoenix_Status__c =  'In Process';
        bStep5.Phoenix_Approver_Team__c='Home Office';
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
        Phoenix_Bid_Process_Steps__c bStep6=new Phoenix_Bid_Process_Steps__c();
        bStep6.Phoenix_Is_Criteria_Step__c = false;
        bStep6.Name= pb.Name+'-'+'Customer\'s Update';
        bStep6.Phoenix_Approver__c = UserInfo.getUserId();
        bStep6.Phoenix_Bid__c = pb.Id;
        bStep6.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep6.Phoenix_Status__c =  'In Process';
        bStep6.Phoenix_Sub_Step__c = 1;
        processList.add(bStep6);
        
        Phoenix_Bid_Process_Steps__c bStep7=new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name= pb.Name+'-'+'Customer\'s Update';
        bStep7.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
               
        Phoenix_Bid_Process_Steps__c bStep10=new Phoenix_Bid_Process_Steps__c();
        bStep10.Phoenix_Is_Criteria_Step__c = false;
        bStep10.Name= pb.Name+'-'+'Customer\'s Update';
        bStep10.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep10.Phoenix_Approver__c = UserInfo.getUserId();
        bStep10.Phoenix_Bid__c = pb.Id;
        bStep10.Phoenix_Sub_Step__c = 1;
        bStep10.Phoenix_PHS_Price_Change__c=phs.Id;
        processList.add(bStep10);
        insert processList;
        
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:pb.Id ];
        system.debug('---bidProcessStepList---'+bidProcessStepList.size());
        list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Vistex_Status__c,Phoenix_MarketingLead_Approver__c,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        
        approvalRequestNotificationClass.approvalRequestNotification(phs.Id,processList);
        //approvalRequestNotificationOldClass.codeCoverageBlock();
    }
    static testmethod void approvalRequestNotification_TestMethod6(){
        
        List<Phoenix_User_Approval_Matrix__c> approvalGroups = new List<Phoenix_User_Approval_Matrix__c>();   
        List<Phoenix_User_Approval_Matrix__c> approvalUsers = new List<Phoenix_User_Approval_Matrix__c>();
        List<User> users = new List<User>();    
        List<Phoenix_Bid__c> bidsList = new List<Phoenix_Bid__c>(); 
        List<Phoenix_Bid__c> bidItemList = new List<Phoenix_Bid__c>(); 
        List<Product2> productList = new List<Product2>();
        List<Phoenix_Approval_Matrix__c> bidMatrixList = new List<Phoenix_Approval_Matrix__c>();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list<Product2> prodList = new list<Product2>();
        Product2 prod1 = new Product2(Name = 'Test Product',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='11111',Phoenix_NDC_11__c='12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='22222',Phoenix_NDC_11__c='21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_NDC_11__c='32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c='Product Discontinuation Process';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Internal_Target_Date__c=Date.newInstance(2023, 04, 27);
        pb.Phoenix_Bid_Deadline_Date__c=System.Today();
        pb.Phoenix_is_OTC_Bid__c=true;
        insert pb;
        
        list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        if(approvalGroups.size() ==0){
            Phoenix_User_Approval_Matrix__c group1= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Sales',Phoenix_Approval_Group_Behavior__c='Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Supply Chain',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Marketing',Phoenix_Approval_Group_Behavior__c='Product based');
            approvalGroups.add(group3);
            Phoenix_User_Approval_Matrix__c group4= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Finance',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Contracts',Phoenix_Approval_Group_Behavior__c='Account based');
            approvalGroups.add(group5);
            
            insert approvalGroups;
        }
        if(approvalUsers.size() ==0){
            if(users.size() ==0){
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                String uid = ('Phoenix'+System.now().getTime()).SubString(0,8);
                User u1 = new User(Alias = uid, Email= uid + '@phoenix.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/New_York', UserName= uid + '@phoenix.com');      
                users.add(u1);
                insert users;
            }
            Phoenix_User_Approval_Matrix__c userApp1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[0].Id);
            approvalUsers.add(userApp1);
            Phoenix_User_Approval_Matrix__c userApp2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=users[0].Id,User_Group__c =approvalGroups[2].Id );
            approvalUsers.add(userApp2);
            Phoenix_User_Approval_Matrix__c userApp3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[1].Id);
            approvalUsers.add(userApp3);
            Phoenix_User_Approval_Matrix__c userApp4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[2].Id);
            approvalUsers.add(userApp4);
            Phoenix_User_Approval_Matrix__c userApp5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[3].Id);
            approvalUsers.add(userApp5);
            Phoenix_User_Approval_Matrix__c userApp6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[4].Id);
            approvalUsers.add(userApp6);
            
            insert approvalUsers;
        }
        
        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c='NEW Individual Pricing Agreement (IPA)');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;
        
        List<Phoenix_Approval_Process_Step__c> stepsList = new List<Phoenix_Approval_Process_Step__c>();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for(Phoenix_Approval_Matrix__c matrix : bidMatrixList){
            Phoenix_Approval_Process_Step__c rfpStep1 = new  Phoenix_Approval_Process_Step__c(Name='Initial Submission',Phoenix_Order__c = 1,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep1);
            
            Phoenix_Approval_Process_Step__c rfpStep2 = new  Phoenix_Approval_Process_Step__c(Name='Marketing',Phoenix_Order__c = 2,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Marketing',Phoenix_Approval_Matrix__c=matrix.Id,Phoenix_Approver__c=UserInfo.getUserId());
            stepsList.add(rfpStep2);
            
            
            
            Phoenix_Approval_Process_Step__c rfpStep5 = new  Phoenix_Approval_Process_Step__c(Name='Finance',Phoenix_Order__c = 3,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Finance',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep5);
            Phoenix_Approval_Process_Step__c rfpStep6 = new  Phoenix_Approval_Process_Step__c(Name='Contracts',Phoenix_Order__c = 4,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Contracts',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep6); 
            Phoenix_Approval_Process_Step__c rfpStep7 = new  Phoenix_Approval_Process_Step__c(Name='Vistex Update',Phoenix_Order__c = 5,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Home Office',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep7);
            
            Phoenix_Approval_Process_Step__c rfpStep9 = new  Phoenix_Approval_Process_Step__c(Name='Closed',Phoenix_Order__c = 6,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep9); 
        }
        insert stepsList;        
        
       
        
        List<Phoenix_Approval_Grid__c> pagList=new List<Phoenix_Approval_Grid__c>();
        Phoenix_Approval_Grid__c pag=new Phoenix_Approval_Grid__c();
		pag.Phoenix_Product_Family__c='Product Family';
		pag.Phoenix_Is_partner_product__c=true;
		pag.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag.Phoenix_Sr_Director_VP__c='Approved';
		pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		pag.Phoenix_Comments__c='Noted';
		pag.Phoenix_Approval__c='Approved';
		pag.Phoenix_Business_Head_Comments__c='Noted';
		pag.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag.Phoenix_GM_Limit__c='Noted';
		pag.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag.Phoenix_GM__c=2;
		pag.Phoenix_Revenue_Limit__c='Noted';
		pag.Phoenix_Revenue__c=2;
		pag.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag.Phoenix_Annualized_TP_Impact__c=3;
        pag.Phoenix_Annualized_GM_Impact__c=4;
		pag.Phoenix_Annualized_TP__c=3;
		pag.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
		//pag.Phoenix_Annualized_TP__c=4;
       	pag.Phoenix_Is_New_Low__c=false;
        pag.Phoenix_Bid__c=pb.Id;
		insert pag;
        pagList.add(pag);
      
        Phoenix_Approval_Grid__c pag1=new Phoenix_Approval_Grid__c();
		pag1.Phoenix_Product_Family__c='Product Family';
		pag1.Phoenix_Is_partner_product__c=false;
		pag1.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag1.Phoenix_Sr_Director_VP__c='Approved';
		pag1.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag1.Phoenix_Is_SVP_Notification_Required__c=true;
		pag1.Phoenix_Sr_Director_VP__c='Approved';
		pag1.Phoenix_Comments__c='Noted';
		pag1.Phoenix_Approval__c='Approved';
		pag1.Phoenix_Business_Head_Comments__c='Noted';
		pag1.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag1.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag1.Phoenix_GM_Limit__c='Noted';
		pag1.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag1.Phoenix_GM__c=2;
		pag1.Phoenix_Revenue_Limit__c='Noted';
		pag1.Phoenix_Revenue__c=2;
		pag1.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag1.Phoenix_Annualized_TP_Impact__c=3;
        pag1.Phoenix_Annualized_GM_Impact__c=4;
		pag1.Phoenix_Annualized_TP__c=3;
		pag1.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
		pag1.Phoenix_Annualized_TP__c=4;
       	pag1.Phoenix_Is_New_Low__c=true;
        pag1.Phoenix_Bid__c=pb.Id;
		insert pag1;
        pagList.add(pag1);
        
        Phoenix_Approval_Grid__c pag3=new Phoenix_Approval_Grid__c();
		pag3.Phoenix_Product_Family__c='Product Family';
		pag3.Phoenix_Is_partner_product__c=false;
		pag3.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag3.Phoenix_Sr_Director_VP__c='Approved';
		pag3.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag3.Phoenix_Is_SVP_Notification_Required__c=true;
		pag3.Phoenix_Sr_Director_VP__c='Approved';
		pag3.Phoenix_Comments__c='Noted';
		pag3.Phoenix_Approval__c='Approved';
		pag3.Phoenix_Business_Head_Comments__c='Noted';
		pag3.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag3.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag3.Phoenix_GM_Limit__c='Noted';
		pag3.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag3.Phoenix_GM__c=2;
		pag3.Phoenix_Revenue_Limit__c='Noted';
		pag3.Phoenix_Revenue__c=2;
		pag3.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag3.Phoenix_Annualized_TP_Impact__c=3;
        pag3.Phoenix_Annualized_GM_Impact__c=4;
		pag3.Phoenix_Annualized_TP__c=3;
		pag3.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
       	pag3.Phoenix_Is_New_Low__c=false;
        pag3.Phoenix_Bid__c=pb.Id;
		insert pag3;
        pagList.add(pag3);
        
        Phoenix_Approval_Grid__c pag2=new Phoenix_Approval_Grid__c();
		pag2.Phoenix_Product_Family__c='Product Family';
		pag2.Phoenix_Is_partner_product__c=true;
		pag2.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag2.Phoenix_Sr_Director_VP__c='Approved';
		pag2.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag2.Phoenix_Is_SVP_Notification_Required__c=true;
		pag2.Phoenix_Sr_Director_VP__c='Approved';
		pag2.Phoenix_Comments__c='Noted';
		pag2.Phoenix_Approval__c='Approved';
		pag2.Phoenix_Business_Head_Comments__c='Noted';
		pag2.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag2.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag2.Phoenix_GM_Limit__c='Noted';
		pag2.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag2.Phoenix_GM__c=2;
		pag2.Phoenix_Revenue_Limit__c='Noted';
		pag2.Phoenix_Revenue__c=2;
		pag2.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag2.Phoenix_Annualized_TP_Impact__c=3;
        //pag2.Phoenix_Annualized_GM_Impact__c=4;
		pag2.Phoenix_Annualized_TP__c=3;
		pag2.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
        pag2.Phoenix_Bid__c=pb.Id;
		insert pag2;
        pagList.add(pag2);
        Product_Family__c pf=new Product_Family__c();
        pf.Name='Product';
        insert pf;
          
       	New_Product_WAC_Pricing__c wac=new New_Product_WAC_Pricing__c();
       // wac.Product_Family__c=pf.Id;
        wac.Phoenix_Approval_Status__c='Closed';
      
        insert wac;
        
        Phoenix_NewProduct_WAC_Pricing_LineItems__c wacLine=new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
       	wacLine.Phoenix_Final_Status__c = 'Not Approved';
       	wacLine.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
        wacLine.Phoenix_Product__c=prod2.Id;
        wacLine.Phoenix_Material_Number__c='12';
        wacLine.Phoenix_NDC_11__c='23';
        wacLine.Phoenix_Lowest_Price__c=12;
        wacLine.Phoenix_TPT_GM__c=2;
        wacLine.Phoenix_New_Product_WAC_Pricing__c=wac.Id;
       	insert wacLine;
          
         list<Phoenix_Bid_Process_Steps__c>processList=new list<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c bStep=new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c=	stepsList[0].Id;
        system.debug('stepsList[0].Id---------------'+stepsList[0].Id);
        bStep.Name= pb.Name+'-'+'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        bStep.Phoenix_Status__c =  'Submitted';
        bStep.Phoenix_Sub_Step__c = 1;
        bStep.Phoenix_Approver_Team__c = 'Marketing Lead Rx';
        processList.add(bStep);
        
        Phoenix_Bid_Process_Steps__c bStep8=new Phoenix_Bid_Process_Steps__c();
        bStep8.Phoenix_Is_Criteria_Step__c = false;
        bStep8.Name= pb.Name+'-'+'Marketing Approval';
        bStep8.Phoenix_Approver__c = UserInfo.getUserId();
        bStep8.Phoenix_Bid__c = pb.Id;
        bStep8.Phoenix_Process_Step__c=	stepsList[1].Id;
        bStep8.Phoenix_Approver_Team__c='Marketing Lead SRx';
        bStep8.Phoenix_Sub_Step__c = 1;
        processList.add(bStep8);
        
        Phoenix_Bid_Process_Steps__c bStep9=new Phoenix_Bid_Process_Steps__c();
        bStep9.Phoenix_Is_Criteria_Step__c = false;
        bStep9.Name= pb.Name+'-'+'Marketing Approval';
        bStep9.Phoenix_Approver__c = UserInfo.getUserId();
        bStep9.Phoenix_Bid__c = pb.Id;
        bStep9.Phoenix_Process_Step__c=	stepsList[1].Id;        
        bStep9.Phoenix_Approver_Team__c='Marketing Lead OTC';
        bStep9.Phoenix_Sub_Step__c = 1;
        processList.add(bStep9);
        
        Phoenix_Bid_Process_Steps__c bStep2=new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name= pb.Name+'-'+'Marketing Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        bStep2.Phoenix_Process_Step__c=	stepsList[1].Id;
        bStep2.Phoenix_Approver_Team__c='Marketing';
        
        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
        Phoenix_Bid_Process_Steps__c bStep3=new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name= pb.Name+'-'+'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb.Id;
        bStep3.Phoenix_Process_Step__c=	stepsList[2].Id;
        bStep3.Phoenix_Approver_Team__c='Finance';
        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        
        Phoenix_Bid_Process_Steps__c bStep4=new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name= pb.Name+'-'+'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb.Id;
        bStep4.Phoenix_Process_Step__c=	stepsList[3].Id;
        bStep4.Phoenix_Approver_Team__c='Contracts';
        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        
        Phoenix_Bid_Process_Steps__c bStep5=new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name= pb.Name+'-'+'Vistex Update';
        bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep5.Phoenix_Status__c =  'In Process';
        bStep5.Phoenix_Approver_Team__c='Home Office';
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
        Phoenix_Bid_Process_Steps__c bStep6=new Phoenix_Bid_Process_Steps__c();
        bStep6.Phoenix_Is_Criteria_Step__c = false;
        bStep6.Name= pb.Name+'-'+'Vistex Update';
        bStep6.Phoenix_Approver__c = UserInfo.getUserId();
        bStep6.Phoenix_Bid__c = pb.Id;
        bStep6.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep6.Phoenix_Status__c =  'In Process';
        bStep6.Phoenix_Sub_Step__c = 1;
        processList.add(bStep6);
        
        Phoenix_Bid_Process_Steps__c bStep7=new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name= pb.Name+'-'+'Closed';
        bStep7.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
               
        Phoenix_Bid_Process_Steps__c bStep10=new Phoenix_Bid_Process_Steps__c();
        bStep10.Phoenix_Is_Criteria_Step__c = false;
        bStep10.Name= pb.Name+'-'+'Customer\'s Update';
        bStep10.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep10.Phoenix_Approver__c = UserInfo.getUserId();
        bStep10.Phoenix_Bid__c = pb.Id;
        bStep10.Phoenix_Sub_Step__c = 1;
        bStep10.Phoenix_New_Product_WAC_Pricing__c=wac.Id;
        processList.add(bStep10);
        insert processList;
        
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:pb.Id ];
        system.debug('---bidProcessStepList---'+bidProcessStepList.size());
        list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Vistex_Status__c,Phoenix_MarketingLead_Approver__c,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        
        approvalRequestNotificationClass.approvalRequestNotification(wac.Id,processList);
        //approvalRequestNotificationOldClass.codeCoverageBlock();
    }
     static testmethod void approvalRequestNotification_TestMethod7(){
        List<Phoenix_User_Approval_Matrix__c> approvalGroups = new List<Phoenix_User_Approval_Matrix__c>();   
        List<Phoenix_User_Approval_Matrix__c> approvalUsers = new List<Phoenix_User_Approval_Matrix__c>();
        List<User> users = new List<User>();    
        List<Phoenix_Bid__c> bidsList = new List<Phoenix_Bid__c>(); 
        List<Phoenix_Bid__c> bidItemList = new List<Phoenix_Bid__c>(); 
        List<Product2> productList = new List<Product2>();
        List<Phoenix_Approval_Matrix__c> bidMatrixList = new List<Phoenix_Approval_Matrix__c>();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list<Product2> prodList = new list<Product2>();
        Product2 prod1 = new Product2(Name = 'Test Product',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='11111',Phoenix_NDC_11__c='12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='22222',Phoenix_NDC_11__c='21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_NDC_11__c='32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Internal_Target_Date__c=Date.newInstance(2023, 04, 27);
        pb.Phoenix_Bid_Deadline_Date__c=System.Today();
        
        insert pb;
        
        list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        if(approvalGroups.size() ==0){
            Phoenix_User_Approval_Matrix__c group1= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Sales',Phoenix_Approval_Group_Behavior__c='Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Supply Chain',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Marketing',Phoenix_Approval_Group_Behavior__c='Product based');
            approvalGroups.add(group3);
            
            Phoenix_User_Approval_Matrix__c group4= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Finance',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Contracts',Phoenix_Approval_Group_Behavior__c='Account based');
            approvalGroups.add(group5);
            
            insert approvalGroups;
        }
        if(approvalUsers.size() ==0){
            if(users.size() ==0){
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                String uid = ('Phoenix'+System.now().getTime()).SubString(0,8);
                User u1 = new User(Alias = uid, Email= uid + '@phoenix.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/New_York', UserName= uid + '@phoenix.com');      
                users.add(u1);
                insert users;
            }
            Phoenix_User_Approval_Matrix__c userApp1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[0].Id);
            approvalUsers.add(userApp1);
            Phoenix_User_Approval_Matrix__c userApp2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=users[0].Id,User_Group__c =approvalGroups[2].Id );
            approvalUsers.add(userApp2);
            Phoenix_User_Approval_Matrix__c userApp3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[1].Id);
            approvalUsers.add(userApp3);
            Phoenix_User_Approval_Matrix__c userApp4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[2].Id);
            approvalUsers.add(userApp4);
            Phoenix_User_Approval_Matrix__c userApp5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[3].Id);
            approvalUsers.add(userApp5);
            Phoenix_User_Approval_Matrix__c userApp6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[4].Id);
            approvalUsers.add(userApp6);
            insert approvalUsers;
        }
        
        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c='NEW Individual Pricing Agreement (IPA)');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;
        
        List<Phoenix_Approval_Process_Step__c> stepsList = new List<Phoenix_Approval_Process_Step__c>();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for(Phoenix_Approval_Matrix__c matrix : bidMatrixList){
            Phoenix_Approval_Process_Step__c rfpStep1 = new  Phoenix_Approval_Process_Step__c(Name='Initial Submission',Phoenix_Order__c = 1,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep1);
            
            Phoenix_Approval_Process_Step__c rfpStep2 = new  Phoenix_Approval_Process_Step__c(Name='Marketing',Phoenix_Order__c = 2,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Marketing',Phoenix_Approval_Matrix__c=matrix.Id,Phoenix_Approver__c=UserInfo.getUserId());
            stepsList.add(rfpStep2);
            
            Phoenix_Approval_Process_Step__c rfpStep5 = new  Phoenix_Approval_Process_Step__c(Name='Finance',Phoenix_Order__c = 3,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Finance',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep5);
            Phoenix_Approval_Process_Step__c rfpStep6 = new  Phoenix_Approval_Process_Step__c(Name='Contracts',Phoenix_Order__c = 4,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Contracts',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep6); 
            Phoenix_Approval_Process_Step__c rfpStep7 = new  Phoenix_Approval_Process_Step__c(Name='Customer\'s Update',Phoenix_Order__c = 5,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Home Office',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep7);
            
            Phoenix_Approval_Process_Step__c rfpStep9 = new  Phoenix_Approval_Process_Step__c(Name='Closed',Phoenix_Order__c = 6,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep9); 
        }
        insert stepsList;
        
        list<Phoenix_Bid_Process_Steps__c> processList=new list<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c bStep=new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c=	stepsList[0].Id;
        system.debug('stepsList[0].Id---------------'+stepsList[0].Id);
        bStep.Name= pb.Name+'-'+'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        bStep.Phoenix_Status__c =  'Submitted';
        bStep.Phoenix_Sub_Step__c = 1;
        processList.add(bStep);
        
        Phoenix_Bid_Process_Steps__c bStep2=new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name= pb.Name+'-'+'Marketing Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        bStep2.Phoenix_Process_Step__c=	stepsList[1].Id;
        
        bStep2.Phoenix_Approver_Team__c='Marketing';
        
        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
        Phoenix_Bid_Process_Steps__c bStep3=new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name= pb.Name+'-'+'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb.Id;
        bStep3.Phoenix_Process_Step__c=	stepsList[2].Id;
        
        bStep3.Phoenix_Approver_Team__c='Finance';
        
        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        Phoenix_Bid_Process_Steps__c bStep4=new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name= pb.Name+'-'+'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb.Id;
        bStep4.Phoenix_Process_Step__c=	stepsList[3].Id;
        bStep4.Phoenix_Approver_Team__c='Contracts';
        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        
        Phoenix_Bid_Process_Steps__c bStep5=new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name= pb.Name+'-'+'Customer\'s Update';
       // bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep5.Phoenix_Status__c =  'In Process';
        bStep5.Phoenix_Approver_Team__c='Sales';
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
        Phoenix_Bid_Process_Steps__c bStep6=new Phoenix_Bid_Process_Steps__c();
        bStep6.Phoenix_Is_Criteria_Step__c = false;
        bStep6.Name= pb.Name+'-'+'Customer\'s Update';
       	bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep6.Phoenix_Bid__c = pb.Id;
        bStep6.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep6.Phoenix_Status__c =  'Completed';
        //bStep6.Phoenix_Approver_Team__c='Sales';
        bStep6.Phoenix_Sub_Step__c = 1;
        processList.add(bStep6);
        
        Phoenix_Bid_Process_Steps__c bStep7=new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name= pb.Name+'-'+'Closed';
        bStep7.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
        insert processList;
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:pb.Id ];
        system.debug('---bidProcessStepList---'+bidProcessStepList.size());
        list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Vistex_Status__c,Phoenix_MarketingLead_Approver__c,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        
        approvalRequestNotificationClass.approvalRequestNotification(pb.Id,processList);
    }
     static testmethod void approvalRequestNotification_TestMethod8(){
        List<Phoenix_User_Approval_Matrix__c> approvalGroups = new List<Phoenix_User_Approval_Matrix__c>();   
        List<Phoenix_User_Approval_Matrix__c> approvalUsers = new List<Phoenix_User_Approval_Matrix__c>();
        List<User> users = new List<User>();    
        List<Phoenix_Bid__c> bidsList = new List<Phoenix_Bid__c>(); 
        List<Phoenix_Bid__c> bidItemList = new List<Phoenix_Bid__c>(); 
        List<Product2> productList = new List<Product2>();
        List<Phoenix_Approval_Matrix__c> bidMatrixList = new List<Phoenix_Approval_Matrix__c>();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list<Product2> prodList = new list<Product2>();
        Product2 prod1 = new Product2(Name = 'Test Product',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='11111',Phoenix_NDC_11__c='12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='22222',Phoenix_NDC_11__c='21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_NDC_11__c='32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Internal_Target_Date__c=Date.newInstance(2023, 04, 27);
        pb.Phoenix_Bid_Deadline_Date__c=System.Today();
        
        insert pb;
        
        list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        if(approvalGroups.size() ==0){
            Phoenix_User_Approval_Matrix__c group1= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Sales',Phoenix_Approval_Group_Behavior__c='Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Supply Chain',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Marketing',Phoenix_Approval_Group_Behavior__c='Product based');
            approvalGroups.add(group3);
            
            Phoenix_User_Approval_Matrix__c group4= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Finance',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Contracts',Phoenix_Approval_Group_Behavior__c='Account based');
            approvalGroups.add(group5);
            
            insert approvalGroups;
        }
        if(approvalUsers.size() ==0){
            if(users.size() ==0){
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                String uid = ('Phoenix'+System.now().getTime()).SubString(0,8);
                User u1 = new User(Alias = uid, Email= uid + '@phoenix.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/New_York', UserName= uid + '@phoenix.com');      
                users.add(u1);
                insert users;
            }
            Phoenix_User_Approval_Matrix__c userApp1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[0].Id);
            approvalUsers.add(userApp1);
            Phoenix_User_Approval_Matrix__c userApp2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=users[0].Id,User_Group__c =approvalGroups[2].Id );
            approvalUsers.add(userApp2);
            Phoenix_User_Approval_Matrix__c userApp3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[1].Id);
            approvalUsers.add(userApp3);
            Phoenix_User_Approval_Matrix__c userApp4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[2].Id);
            approvalUsers.add(userApp4);
            Phoenix_User_Approval_Matrix__c userApp5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[3].Id);
            approvalUsers.add(userApp5);
            Phoenix_User_Approval_Matrix__c userApp6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[4].Id);
            approvalUsers.add(userApp6);
            insert approvalUsers;
        }
        
        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c='NEW Individual Pricing Agreement (IPA)');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;
        
        List<Phoenix_Approval_Process_Step__c> stepsList = new List<Phoenix_Approval_Process_Step__c>();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for(Phoenix_Approval_Matrix__c matrix : bidMatrixList){
            Phoenix_Approval_Process_Step__c rfpStep1 = new  Phoenix_Approval_Process_Step__c(Name='Initial Submission',Phoenix_Order__c = 1,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep1);
            
            Phoenix_Approval_Process_Step__c rfpStep2 = new  Phoenix_Approval_Process_Step__c(Name='Marketing',Phoenix_Order__c = 2,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Marketing',Phoenix_Approval_Matrix__c=matrix.Id,Phoenix_Approver__c=UserInfo.getUserId());
            stepsList.add(rfpStep2);
            
            Phoenix_Approval_Process_Step__c rfpStep5 = new  Phoenix_Approval_Process_Step__c(Name='Finance',Phoenix_Order__c = 3,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Finance',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep5);
            Phoenix_Approval_Process_Step__c rfpStep6 = new  Phoenix_Approval_Process_Step__c(Name='Contracts',Phoenix_Order__c = 4,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Contracts',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep6); 
            Phoenix_Approval_Process_Step__c rfpStep7 = new  Phoenix_Approval_Process_Step__c(Name='Vistex Update',Phoenix_Order__c = 5,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Home Office',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep7);
            
            Phoenix_Approval_Process_Step__c rfpStep9 = new  Phoenix_Approval_Process_Step__c(Name='Closed',Phoenix_Order__c = 6,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep9); 
        }
        insert stepsList;
        
        list<Phoenix_Bid_Process_Steps__c> processList=new list<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c bStep=new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c=	stepsList[0].Id;
        system.debug('stepsList[0].Id---------------'+stepsList[0].Id);
        bStep.Name= pb.Name+'-'+'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        bStep.Phoenix_Status__c =  'Submitted';
        bStep.Phoenix_Sub_Step__c = 1;
        processList.add(bStep);
        
        Phoenix_Bid_Process_Steps__c bStep2=new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name= pb.Name+'-'+'Marketing Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        bStep2.Phoenix_Process_Step__c=	stepsList[1].Id;
        
        bStep2.Phoenix_Approver_Team__c='Marketing';
        
        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
        Phoenix_Bid_Process_Steps__c bStep3=new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name= pb.Name+'-'+'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb.Id;
        bStep3.Phoenix_Process_Step__c=	stepsList[2].Id;
        
        bStep3.Phoenix_Approver_Team__c='Finance';
        
        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        Phoenix_Bid_Process_Steps__c bStep4=new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name= pb.Name+'-'+'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb.Id;
        bStep4.Phoenix_Process_Step__c=	stepsList[3].Id;
        bStep4.Phoenix_Approver_Team__c='Contracts';
        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        
        Phoenix_Bid_Process_Steps__c bStep5=new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name= pb.Name+'-'+'Customer\'s Update';
       // bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep5.Phoenix_Status__c =  'In Process';
        bStep5.Phoenix_Approver_Team__c='Contracts';
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
        Phoenix_Bid_Process_Steps__c bStep6=new Phoenix_Bid_Process_Steps__c();
        bStep6.Phoenix_Is_Criteria_Step__c = false;
        bStep6.Name= pb.Name+'-'+'Vistex Update';
       	bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep6.Phoenix_Bid__c = pb.Id;
        bStep6.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep6.Phoenix_Status__c =  'In Process';
        //bStep6.Phoenix_Approver_Team__c='Sales';
        bStep6.Phoenix_Sub_Step__c = 1;
        processList.add(bStep6);
        
        Phoenix_Bid_Process_Steps__c bStep7=new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name= pb.Name+'-'+'Closed';
        bStep7.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
        insert processList;
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:pb.Id ];
        system.debug('---bidProcessStepList---'+bidProcessStepList.size());
        list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Vistex_Status__c,Phoenix_MarketingLead_Approver__c,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        
        approvalRequestNotificationClass.approvalRequestNotification(pb.Id,processList);
    }
    static testmethod void approvalRequestNotification_TestMethod9(){
        List<Phoenix_User_Approval_Matrix__c> approvalGroups = new List<Phoenix_User_Approval_Matrix__c>();   
        List<Phoenix_User_Approval_Matrix__c> approvalUsers = new List<Phoenix_User_Approval_Matrix__c>();
        List<User> users = new List<User>();    
        List<Phoenix_Bid__c> bidsList = new List<Phoenix_Bid__c>(); 
        List<Phoenix_Bid__c> bidItemList = new List<Phoenix_Bid__c>(); 
        List<Product2> productList = new List<Product2>();
        List<Phoenix_Approval_Matrix__c> bidMatrixList = new List<Phoenix_Approval_Matrix__c>();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list<Product2> prodList = new list<Product2>();
        Product2 prod1 = new Product2(Name = 'Test Product',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='11111',Phoenix_NDC_11__c='12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='22222',Phoenix_NDC_11__c='21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_NDC_11__c='32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c='Product Discontinuation Process';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Internal_Target_Date__c=Date.newInstance(2023, 04, 27);
        pb.Phoenix_Bid_Deadline_Date__c=System.Today();
        
        insert pb;
        
        list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        if(approvalGroups.size() ==0){
            Phoenix_User_Approval_Matrix__c group1= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Sales',Phoenix_Approval_Group_Behavior__c='Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Supply Chain',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Marketing',Phoenix_Approval_Group_Behavior__c='Product based');
            approvalGroups.add(group3);
            
            Phoenix_User_Approval_Matrix__c group4= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Finance',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Contracts',Phoenix_Approval_Group_Behavior__c='Account based');
            approvalGroups.add(group5);
            
            insert approvalGroups;
        }
        if(approvalUsers.size() ==0){
            if(users.size() ==0){
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                String uid = ('Phoenix'+System.now().getTime()).SubString(0,8);
                User u1 = new User(Alias = uid, Email= uid + '@phoenix.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/New_York', UserName= uid + '@phoenix.com');      
                users.add(u1);
                insert users;
            }
            Phoenix_User_Approval_Matrix__c userApp1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[0].Id);
            approvalUsers.add(userApp1);
            Phoenix_User_Approval_Matrix__c userApp2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=users[0].Id,User_Group__c =approvalGroups[2].Id );
            approvalUsers.add(userApp2);
            Phoenix_User_Approval_Matrix__c userApp3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[1].Id);
            approvalUsers.add(userApp3);
            Phoenix_User_Approval_Matrix__c userApp4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[2].Id);
            approvalUsers.add(userApp4);
            Phoenix_User_Approval_Matrix__c userApp5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[3].Id);
            approvalUsers.add(userApp5);
            Phoenix_User_Approval_Matrix__c userApp6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[4].Id);
            approvalUsers.add(userApp6);
            insert approvalUsers;
        }
        
        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c='NEW Individual Pricing Agreement (IPA)');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;
        
        List<Phoenix_Approval_Process_Step__c> stepsList = new List<Phoenix_Approval_Process_Step__c>();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for(Phoenix_Approval_Matrix__c matrix : bidMatrixList){
            Phoenix_Approval_Process_Step__c rfpStep1 = new  Phoenix_Approval_Process_Step__c(Name='Initial Submission',Phoenix_Order__c = 1,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep1);
            
            Phoenix_Approval_Process_Step__c rfpStep2 = new  Phoenix_Approval_Process_Step__c(Name='Marketing',Phoenix_Order__c = 2,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Marketing',Phoenix_Approval_Matrix__c=matrix.Id,Phoenix_Approver__c=UserInfo.getUserId());
            stepsList.add(rfpStep2);
            
            Phoenix_Approval_Process_Step__c rfpStep5 = new  Phoenix_Approval_Process_Step__c(Name='Finance',Phoenix_Order__c = 3,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Finance',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep5);
            Phoenix_Approval_Process_Step__c rfpStep6 = new  Phoenix_Approval_Process_Step__c(Name='Contracts',Phoenix_Order__c = 4,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Contracts',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep6); 
            Phoenix_Approval_Process_Step__c rfpStep7 = new  Phoenix_Approval_Process_Step__c(Name='Vistex Update',Phoenix_Order__c = 5,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Home Office',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep7);
            
            Phoenix_Approval_Process_Step__c rfpStep9 = new  Phoenix_Approval_Process_Step__c(Name='Closed',Phoenix_Order__c = 6,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep9); 
        }
        insert stepsList;
        
        list<Phoenix_Bid_Process_Steps__c> processList=new list<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c bStep=new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c=	stepsList[0].Id;
        system.debug('stepsList[0].Id---------------'+stepsList[0].Id);
        bStep.Name= pb.Name+'-'+'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        bStep.Phoenix_Status__c =  'Submitted';
        bStep.Phoenix_Sub_Step__c = 1;
        processList.add(bStep);
        
        Phoenix_Bid_Process_Steps__c bStep2=new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name= pb.Name+'-'+'Marketing Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        bStep2.Phoenix_Process_Step__c=	stepsList[1].Id;
        
        bStep2.Phoenix_Approver_Team__c='Marketing';
        
        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
        Phoenix_Bid_Process_Steps__c bStep3=new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name= pb.Name+'-'+'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb.Id;
        bStep3.Phoenix_Process_Step__c=	stepsList[2].Id;
        
        bStep3.Phoenix_Approver_Team__c='Finance';
        
        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        Phoenix_Bid_Process_Steps__c bStep4=new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name= pb.Name+'-'+'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb.Id;
        bStep4.Phoenix_Process_Step__c=	stepsList[3].Id;
        bStep4.Phoenix_Approver_Team__c='Contracts';
        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        
        Phoenix_Bid_Process_Steps__c bStep5=new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name= pb.Name+'-'+'Marketing Approval';
       // bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep5.Phoenix_Status__c =  'In Process';
        bStep5.Phoenix_Approver_Team__c='Marketing';
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
        Phoenix_Bid_Process_Steps__c bStep6=new Phoenix_Bid_Process_Steps__c();
        bStep6.Phoenix_Is_Criteria_Step__c = false;
        bStep6.Name= pb.Name+'-'+'Vistex Update';
       	bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep6.Phoenix_Bid__c = pb.Id;
        bStep6.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep6.Phoenix_Status__c =  'In Process';
        bStep6.Phoenix_Approver_Team__c='Supply Chain';
        bStep6.Phoenix_Sub_Step__c = 1;
        processList.add(bStep6);
        
        Phoenix_Bid_Process_Steps__c bStep7=new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name= pb.Name+'-'+'Closed';
        bStep7.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
        insert processList;
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:pb.Id ];
        system.debug('---bidProcessStepList---'+bidProcessStepList.size());
        list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Vistex_Status__c,Phoenix_MarketingLead_Approver__c,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        
        approvalRequestNotificationClass.approvalRequestNotification(pb.Id,processList);
    }
     static testmethod void approvalRequestNotification_TestMethod10(){
        List<Phoenix_User_Approval_Matrix__c> approvalGroups = new List<Phoenix_User_Approval_Matrix__c>();   
        List<Phoenix_User_Approval_Matrix__c> approvalUsers = new List<Phoenix_User_Approval_Matrix__c>();
        List<User> users = new List<User>();    
        List<Phoenix_Bid__c> bidsList = new List<Phoenix_Bid__c>(); 
        List<Phoenix_Bid__c> bidItemList = new List<Phoenix_Bid__c>(); 
        List<Product2> productList = new List<Product2>();
        List<Phoenix_Approval_Matrix__c> bidMatrixList = new List<Phoenix_Approval_Matrix__c>();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list<Product2> prodList = new list<Product2>();
        Product2 prod1 = new Product2(Name = 'Test Product',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='11111',Phoenix_NDC_11__c='12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='22222',Phoenix_NDC_11__c='21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_NDC_11__c='32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c='Platform OTB';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Internal_Target_Date__c=Date.newInstance(2023, 04, 27);
        pb.Phoenix_Bid_Deadline_Date__c=System.Today();
        
        insert pb;
        
        list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        if(approvalGroups.size() ==0){
            Phoenix_User_Approval_Matrix__c group1= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Sales',Phoenix_Approval_Group_Behavior__c='Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Supply Chain',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Marketing',Phoenix_Approval_Group_Behavior__c='Product based');
            approvalGroups.add(group3);
            
            Phoenix_User_Approval_Matrix__c group4= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Finance',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Contracts',Phoenix_Approval_Group_Behavior__c='Account based');
            approvalGroups.add(group5);
            
            insert approvalGroups;
        }
        if(approvalUsers.size() ==0){
            if(users.size() ==0){
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                String uid = ('Phoenix'+System.now().getTime()).SubString(0,8);
                User u1 = new User(Alias = uid, Email= uid + '@phoenix.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/New_York', UserName= uid + '@phoenix.com');      
                users.add(u1);
                insert users;
            }
            Phoenix_User_Approval_Matrix__c userApp1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[0].Id);
            approvalUsers.add(userApp1);
            Phoenix_User_Approval_Matrix__c userApp2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=users[0].Id,User_Group__c =approvalGroups[2].Id );
            approvalUsers.add(userApp2);
            Phoenix_User_Approval_Matrix__c userApp3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[1].Id);
            approvalUsers.add(userApp3);
            Phoenix_User_Approval_Matrix__c userApp4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[2].Id);
            approvalUsers.add(userApp4);
            Phoenix_User_Approval_Matrix__c userApp5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[3].Id);
            approvalUsers.add(userApp5);
            Phoenix_User_Approval_Matrix__c userApp6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[4].Id);
            approvalUsers.add(userApp6);
            insert approvalUsers;
        }
        
        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c='NEW Individual Pricing Agreement (IPA)');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;
        
        List<Phoenix_Approval_Process_Step__c> stepsList = new List<Phoenix_Approval_Process_Step__c>();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for(Phoenix_Approval_Matrix__c matrix : bidMatrixList){
            Phoenix_Approval_Process_Step__c rfpStep1 = new  Phoenix_Approval_Process_Step__c(Name='Initial Submission',Phoenix_Order__c = 1,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep1);
            
            Phoenix_Approval_Process_Step__c rfpStep2 = new  Phoenix_Approval_Process_Step__c(Name='Marketing',Phoenix_Order__c = 2,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Marketing',Phoenix_Approval_Matrix__c=matrix.Id,Phoenix_Approver__c=UserInfo.getUserId());
            stepsList.add(rfpStep2);
            
            Phoenix_Approval_Process_Step__c rfpStep5 = new  Phoenix_Approval_Process_Step__c(Name='Finance',Phoenix_Order__c = 3,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Finance',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep5);
            Phoenix_Approval_Process_Step__c rfpStep6 = new  Phoenix_Approval_Process_Step__c(Name='Contracts',Phoenix_Order__c = 4,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Contracts',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep6); 
            Phoenix_Approval_Process_Step__c rfpStep7 = new  Phoenix_Approval_Process_Step__c(Name='Vistex Update',Phoenix_Order__c = 5,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Home Office',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep7);
            
            Phoenix_Approval_Process_Step__c rfpStep9 = new  Phoenix_Approval_Process_Step__c(Name='Closed',Phoenix_Order__c = 6,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep9); 
        }
        insert stepsList;
        
        list<Phoenix_Bid_Process_Steps__c> processList=new list<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c bStep=new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c=	stepsList[0].Id;
        system.debug('stepsList[0].Id---------------'+stepsList[0].Id);
        bStep.Name= pb.Name+'-'+'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        bStep.Phoenix_Status__c =  'Submitted';
        bStep.Phoenix_Sub_Step__c = 1;
        processList.add(bStep);
        
        Phoenix_Bid_Process_Steps__c bStep2=new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name= pb.Name+'-'+'Marketing Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        bStep2.Phoenix_Process_Step__c=	stepsList[1].Id;
        bStep2.Phoenix_Status__c =  'In Process';
        bStep2.Phoenix_Approver_Team__c='Marketing';
        
        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
        Phoenix_Bid_Process_Steps__c bStep3=new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name= pb.Name+'-'+'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb.Id;
        bStep3.Phoenix_Process_Step__c=	stepsList[2].Id;
		bStep3.Phoenix_Status__c =  'In Process';        
        bStep3.Phoenix_Approver_Team__c='Finance';
        
        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        Phoenix_Bid_Process_Steps__c bStep4=new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name= pb.Name+'-'+'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb.Id;
        bStep4.Phoenix_Process_Step__c=	stepsList[3].Id;
        bStep4.Phoenix_Approver_Team__c='Contracts';
        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        
        Phoenix_Bid_Process_Steps__c bStep5=new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name= pb.Name+'-'+'Marketing Approval';
       // bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep5.Phoenix_Status__c =  'In Process';
        bStep5.Phoenix_Approver_Team__c='Marketing';
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
        Phoenix_Bid_Process_Steps__c bStep6=new Phoenix_Bid_Process_Steps__c();
        bStep6.Phoenix_Is_Criteria_Step__c = false;
        bStep6.Name= pb.Name+'-'+'Vistex Update';
       	bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep6.Phoenix_Bid__c = pb.Id;
        bStep6.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep6.Phoenix_Status__c =  'In Process';
        bStep6.Phoenix_Approver_Team__c='Supply Chain';
        bStep6.Phoenix_Sub_Step__c = 1;
        processList.add(bStep6);
        
        Phoenix_Bid_Process_Steps__c bStep7=new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name= pb.Name+'-'+'Closed';
        bStep7.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
        insert processList;
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:pb.Id ];
        system.debug('---bidProcessStepList---'+bidProcessStepList.size());
        list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Vistex_Status__c,Phoenix_MarketingLead_Approver__c,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        
        approvalRequestNotificationClass.approvalRequestNotification(pb.Id,processList);
    }
     static testmethod void approvalRequestNotification_TestMethod11(){
        List<Phoenix_User_Approval_Matrix__c> approvalGroups = new List<Phoenix_User_Approval_Matrix__c>();   
        List<Phoenix_User_Approval_Matrix__c> approvalUsers = new List<Phoenix_User_Approval_Matrix__c>();
        List<User> users = new List<User>();    
        List<Phoenix_Bid__c> bidsList = new List<Phoenix_Bid__c>(); 
        List<Phoenix_Bid__c> bidItemList = new List<Phoenix_Bid__c>(); 
        List<Product2> productList = new List<Product2>();
        List<Phoenix_Approval_Matrix__c> bidMatrixList = new List<Phoenix_Approval_Matrix__c>();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list<Product2> prodList = new list<Product2>();
        Product2 prod1 = new Product2(Name = 'Test Product',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='11111',Phoenix_NDC_11__c='12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='22222',Phoenix_NDC_11__c='21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_NDC_11__c='32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='Product Discontinuation Process';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Internal_Target_Date__c=Date.newInstance(2023, 04, 27);
        pb.Phoenix_Bid_Deadline_Date__c=System.Today();
        
        insert pb;
        
        list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        if(approvalGroups.size() ==0){
            Phoenix_User_Approval_Matrix__c group1= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Sales',Phoenix_Approval_Group_Behavior__c='Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Supply Chain',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Marketing',Phoenix_Approval_Group_Behavior__c='Product based');
            approvalGroups.add(group3);
            
            Phoenix_User_Approval_Matrix__c group4= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Finance',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Contracts',Phoenix_Approval_Group_Behavior__c='Account based');
            approvalGroups.add(group5);
            
            insert approvalGroups;
        }
        if(approvalUsers.size() ==0){
            if(users.size() ==0){
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                String uid = ('Phoenix'+System.now().getTime()).SubString(0,8);
                User u1 = new User(Alias = uid, Email= uid + '@phoenix.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/New_York', UserName= uid + '@phoenix.com');      
                users.add(u1);
                insert users;
            }
            Phoenix_User_Approval_Matrix__c userApp1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[0].Id);
            approvalUsers.add(userApp1);
            Phoenix_User_Approval_Matrix__c userApp2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=users[0].Id,User_Group__c =approvalGroups[2].Id );
            approvalUsers.add(userApp2);
            Phoenix_User_Approval_Matrix__c userApp3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[1].Id);
            approvalUsers.add(userApp3);
            Phoenix_User_Approval_Matrix__c userApp4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[2].Id);
            approvalUsers.add(userApp4);
            Phoenix_User_Approval_Matrix__c userApp5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[3].Id);
            approvalUsers.add(userApp5);
            Phoenix_User_Approval_Matrix__c userApp6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[4].Id);
            approvalUsers.add(userApp6);
            insert approvalUsers;
        }
        
        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c='NEW Individual Pricing Agreement (IPA)');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;
        
        List<Phoenix_Approval_Process_Step__c> stepsList = new List<Phoenix_Approval_Process_Step__c>();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for(Phoenix_Approval_Matrix__c matrix : bidMatrixList){
            Phoenix_Approval_Process_Step__c rfpStep1 = new  Phoenix_Approval_Process_Step__c(Name='Initial Submission',Phoenix_Order__c = 1,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep1);
            
            Phoenix_Approval_Process_Step__c rfpStep2 = new  Phoenix_Approval_Process_Step__c(Name='Marketing',Phoenix_Order__c = 2,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Marketing',Phoenix_Approval_Matrix__c=matrix.Id,Phoenix_Approver__c=UserInfo.getUserId());
            stepsList.add(rfpStep2);
            
            Phoenix_Approval_Process_Step__c rfpStep5 = new  Phoenix_Approval_Process_Step__c(Name='Finance',Phoenix_Order__c = 3,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Finance',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep5);
            Phoenix_Approval_Process_Step__c rfpStep6 = new  Phoenix_Approval_Process_Step__c(Name='Contracts',Phoenix_Order__c = 4,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Contracts',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep6); 
            Phoenix_Approval_Process_Step__c rfpStep7 = new  Phoenix_Approval_Process_Step__c(Name='Vistex Update',Phoenix_Order__c = 5,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Home Office',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep7);
            
            Phoenix_Approval_Process_Step__c rfpStep9 = new  Phoenix_Approval_Process_Step__c(Name='Closed',Phoenix_Order__c = 6,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep9); 
        }
        insert stepsList;
        
        list<Phoenix_Bid_Process_Steps__c> processList=new list<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c bStep=new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c=	stepsList[0].Id;
        system.debug('stepsList[0].Id---------------'+stepsList[0].Id);
        bStep.Name= pb.Name+'-'+'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        bStep.Phoenix_Status__c =  'Submitted';
        bStep.Phoenix_Sub_Step__c = 1;
        processList.add(bStep);
        
        Phoenix_Bid_Process_Steps__c bStep2=new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name= pb.Name+'-'+'Marketing Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        bStep2.Phoenix_Process_Step__c=	stepsList[1].Id;
        
        bStep2.Phoenix_Approver_Team__c='Marketing';
        
        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
        Phoenix_Bid_Process_Steps__c bStep3=new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name= pb.Name+'-'+'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb.Id;
        bStep3.Phoenix_Process_Step__c=	stepsList[2].Id;
        
        bStep3.Phoenix_Approver_Team__c='Finance';
        
        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        Phoenix_Bid_Process_Steps__c bStep4=new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name= pb.Name+'-'+'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb.Id;
        bStep4.Phoenix_Process_Step__c=	stepsList[3].Id;
        bStep4.Phoenix_Approver_Team__c='Contracts';
        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        
        Phoenix_Bid_Process_Steps__c bStep5=new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name= pb.Name+'-'+'Marketing Approval';
       // bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep5.Phoenix_Status__c =  'In Process';
        bStep5.Phoenix_Approver_Team__c='Marketing Lead OTC';
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
        Phoenix_Bid_Process_Steps__c bStep6=new Phoenix_Bid_Process_Steps__c();
        bStep6.Phoenix_Is_Criteria_Step__c = false;
        bStep6.Name= pb.Name+'-'+'Vistex Update';
       	bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep6.Phoenix_Bid__c = pb.Id;
        bStep6.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep6.Phoenix_Status__c =  'In Process';
        bStep6.Phoenix_Approver_Team__c='Supply Chain';
        bStep6.Phoenix_Sub_Step__c = 1;
        processList.add(bStep6);
        
        Phoenix_Bid_Process_Steps__c bStep7=new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name= pb.Name+'-'+'Closed';
        bStep7.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
        insert processList;
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:pb.Id ];
        system.debug('---bidProcessStepList---'+bidProcessStepList.size());
        list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Vistex_Status__c,Phoenix_MarketingLead_Approver__c,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        
        approvalRequestNotificationClass.approvalRequestNotification(pb.Id,processList);
    }
     static testmethod void approvalRequestNotification_TestMethod12(){
        List<Phoenix_User_Approval_Matrix__c> approvalGroups = new List<Phoenix_User_Approval_Matrix__c>();   
        List<Phoenix_User_Approval_Matrix__c> approvalUsers = new List<Phoenix_User_Approval_Matrix__c>();
        List<User> users = new List<User>();    
        List<Phoenix_Bid__c> bidsList = new List<Phoenix_Bid__c>(); 
        List<Phoenix_Bid__c> bidItemList = new List<Phoenix_Bid__c>(); 
        List<Product2> productList = new List<Product2>();
        List<Phoenix_Approval_Matrix__c> bidMatrixList = new List<Phoenix_Approval_Matrix__c>();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list<Product2> prodList = new list<Product2>();
        Product2 prod1 = new Product2(Name = 'Test Product',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='11111',Phoenix_NDC_11__c='12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='22222',Phoenix_NDC_11__c='21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_NDC_11__c='32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='Product Discontinuation Process';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Internal_Target_Date__c=Date.newInstance(2023, 04, 27);
        pb.Phoenix_Bid_Deadline_Date__c=System.Today();
        
        insert pb;
        
        list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        if(approvalGroups.size() ==0){
            Phoenix_User_Approval_Matrix__c group1= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Sales',Phoenix_Approval_Group_Behavior__c='Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Supply Chain',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Marketing',Phoenix_Approval_Group_Behavior__c='Product based');
            approvalGroups.add(group3);
            
            Phoenix_User_Approval_Matrix__c group4= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Finance',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Contracts',Phoenix_Approval_Group_Behavior__c='Account based');
            approvalGroups.add(group5);
            
            insert approvalGroups;
        }
        if(approvalUsers.size() ==0){
            if(users.size() ==0){
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                String uid = ('Phoenix'+System.now().getTime()).SubString(0,8);
                User u1 = new User(Alias = uid, Email= uid + '@phoenix.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/New_York', UserName= uid + '@phoenix.com');      
                users.add(u1);
                insert users;
            }
            Phoenix_User_Approval_Matrix__c userApp1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[0].Id);
            approvalUsers.add(userApp1);
            Phoenix_User_Approval_Matrix__c userApp2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=users[0].Id,User_Group__c =approvalGroups[2].Id );
            approvalUsers.add(userApp2);
            Phoenix_User_Approval_Matrix__c userApp3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[1].Id);
            approvalUsers.add(userApp3);
            Phoenix_User_Approval_Matrix__c userApp4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[2].Id);
            approvalUsers.add(userApp4);
            Phoenix_User_Approval_Matrix__c userApp5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[3].Id);
            approvalUsers.add(userApp5);
            Phoenix_User_Approval_Matrix__c userApp6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[4].Id);
            approvalUsers.add(userApp6);
            insert approvalUsers;
        }
        
        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c='NEW Individual Pricing Agreement (IPA)');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;
        
        List<Phoenix_Approval_Process_Step__c> stepsList = new List<Phoenix_Approval_Process_Step__c>();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for(Phoenix_Approval_Matrix__c matrix : bidMatrixList){
            Phoenix_Approval_Process_Step__c rfpStep1 = new  Phoenix_Approval_Process_Step__c(Name='Initial Submission',Phoenix_Order__c = 1,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep1);
            
            Phoenix_Approval_Process_Step__c rfpStep2 = new  Phoenix_Approval_Process_Step__c(Name='Marketing',Phoenix_Order__c = 2,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Marketing',Phoenix_Approval_Matrix__c=matrix.Id,Phoenix_Approver__c=UserInfo.getUserId());
            stepsList.add(rfpStep2);
            
            Phoenix_Approval_Process_Step__c rfpStep5 = new  Phoenix_Approval_Process_Step__c(Name='Finance',Phoenix_Order__c = 3,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Finance',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep5);
            Phoenix_Approval_Process_Step__c rfpStep6 = new  Phoenix_Approval_Process_Step__c(Name='Contracts',Phoenix_Order__c = 4,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Contracts',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep6); 
            Phoenix_Approval_Process_Step__c rfpStep7 = new  Phoenix_Approval_Process_Step__c(Name='Vistex Update',Phoenix_Order__c = 5,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Home Office',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep7);
            
            Phoenix_Approval_Process_Step__c rfpStep9 = new  Phoenix_Approval_Process_Step__c(Name='Closed',Phoenix_Order__c = 6,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep9); 
        }
        insert stepsList;
        
        list<Phoenix_Bid_Process_Steps__c> processList=new list<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c bStep=new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c=	stepsList[0].Id;
        system.debug('stepsList[0].Id---------------'+stepsList[0].Id);
        bStep.Name= pb.Name+'-'+'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        bStep.Phoenix_Status__c =  'Submitted';
        bStep.Phoenix_Sub_Step__c = 1;
        processList.add(bStep);
        
        Phoenix_Bid_Process_Steps__c bStep2=new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name= pb.Name+'-'+'Marketing Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        bStep2.Phoenix_Process_Step__c=	stepsList[1].Id;
        
        bStep2.Phoenix_Approver_Team__c='Marketing';
        
        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
        Phoenix_Bid_Process_Steps__c bStep3=new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name= pb.Name+'-'+'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb.Id;
        bStep3.Phoenix_Process_Step__c=	stepsList[2].Id;
        
        bStep3.Phoenix_Approver_Team__c='Finance';
        
        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        Phoenix_Bid_Process_Steps__c bStep4=new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name= pb.Name+'-'+'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb.Id;
        bStep4.Phoenix_Process_Step__c=	stepsList[3].Id;
        bStep4.Phoenix_Approver_Team__c='Contracts';
        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        
        Phoenix_Bid_Process_Steps__c bStep5=new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name= pb.Name+'-'+'Marketing Approval';
       // bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep5.Phoenix_Status__c =  'In Process';
        bStep5.Phoenix_Approver_Team__c='Marketing Head';
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
        Phoenix_Bid_Process_Steps__c bStep6=new Phoenix_Bid_Process_Steps__c();
        bStep6.Phoenix_Is_Criteria_Step__c = false;
        bStep6.Name= pb.Name+'-'+'Vistex Update';
       	bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep6.Phoenix_Bid__c = pb.Id;
        bStep6.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep6.Phoenix_Status__c =  'In Process';
        bStep6.Phoenix_Approver_Team__c='Supply Chain';
        bStep6.Phoenix_Sub_Step__c = 1;
        processList.add(bStep6);
        
        Phoenix_Bid_Process_Steps__c bStep7=new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name= pb.Name+'-'+'Closed';
        bStep7.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
        insert processList;
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:pb.Id ];
        system.debug('---bidProcessStepList---'+bidProcessStepList.size());
        list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Vistex_Status__c,Phoenix_MarketingLead_Approver__c,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        
        approvalRequestNotificationClass.approvalRequestNotification(pb.Id,processList);
    }
     static testmethod void approvalRequestNotification_TestMethod13(){
        List<Phoenix_User_Approval_Matrix__c> approvalGroups = new List<Phoenix_User_Approval_Matrix__c>();   
        List<Phoenix_User_Approval_Matrix__c> approvalUsers = new List<Phoenix_User_Approval_Matrix__c>();
        List<User> users = new List<User>();    
        List<Phoenix_Bid__c> bidsList = new List<Phoenix_Bid__c>(); 
        List<Phoenix_Bid__c> bidItemList = new List<Phoenix_Bid__c>(); 
        List<Product2> productList = new List<Product2>();
        List<Phoenix_Approval_Matrix__c> bidMatrixList = new List<Phoenix_Approval_Matrix__c>();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list<Product2> prodList = new list<Product2>();
        Product2 prod1 = new Product2(Name = 'Test Product',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='11111',Phoenix_NDC_11__c='12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='22222',Phoenix_NDC_11__c='21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_NDC_11__c='32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c='Product Discontinuation Process';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Internal_Target_Date__c=Date.newInstance(2023, 04, 27);
        pb.Phoenix_Bid_Deadline_Date__c=System.Today();
        
        insert pb;
        
        list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        if(approvalGroups.size() ==0){
            Phoenix_User_Approval_Matrix__c group1= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Sales',Phoenix_Approval_Group_Behavior__c='Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Supply Chain',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Marketing',Phoenix_Approval_Group_Behavior__c='Product based');
            approvalGroups.add(group3);
            
            Phoenix_User_Approval_Matrix__c group4= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Finance',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Contracts',Phoenix_Approval_Group_Behavior__c='Account based');
            approvalGroups.add(group5);
            
            insert approvalGroups;
        }
        if(approvalUsers.size() ==0){
            if(users.size() ==0){
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                String uid = ('Phoenix'+System.now().getTime()).SubString(0,8);
                User u1 = new User(Alias = uid, Email= uid + '@phoenix.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/New_York', UserName= uid + '@phoenix.com');      
                users.add(u1);
                insert users;
            }
            Phoenix_User_Approval_Matrix__c userApp1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[0].Id);
            approvalUsers.add(userApp1);
            Phoenix_User_Approval_Matrix__c userApp2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=users[0].Id,User_Group__c =approvalGroups[2].Id );
            approvalUsers.add(userApp2);
            Phoenix_User_Approval_Matrix__c userApp3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[1].Id);
            approvalUsers.add(userApp3);
            Phoenix_User_Approval_Matrix__c userApp4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[2].Id);
            approvalUsers.add(userApp4);
            Phoenix_User_Approval_Matrix__c userApp5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[3].Id);
            approvalUsers.add(userApp5);
            Phoenix_User_Approval_Matrix__c userApp6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[4].Id);
            approvalUsers.add(userApp6);
            insert approvalUsers;
        }
        
        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c='NEW Individual Pricing Agreement (IPA)');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;
        
        List<Phoenix_Approval_Process_Step__c> stepsList = new List<Phoenix_Approval_Process_Step__c>();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for(Phoenix_Approval_Matrix__c matrix : bidMatrixList){
            Phoenix_Approval_Process_Step__c rfpStep1 = new  Phoenix_Approval_Process_Step__c(Name='Initial Submission',Phoenix_Order__c = 1,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep1);
            
            Phoenix_Approval_Process_Step__c rfpStep2 = new  Phoenix_Approval_Process_Step__c(Name='Marketing',Phoenix_Order__c = 2,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Marketing',Phoenix_Approval_Matrix__c=matrix.Id,Phoenix_Approver__c=UserInfo.getUserId());
            stepsList.add(rfpStep2);
            
            Phoenix_Approval_Process_Step__c rfpStep5 = new  Phoenix_Approval_Process_Step__c(Name='Finance',Phoenix_Order__c = 3,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Finance',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep5);
            Phoenix_Approval_Process_Step__c rfpStep6 = new  Phoenix_Approval_Process_Step__c(Name='Contracts',Phoenix_Order__c = 4,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Contracts',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep6); 
            Phoenix_Approval_Process_Step__c rfpStep7 = new  Phoenix_Approval_Process_Step__c(Name='Vistex Update',Phoenix_Order__c = 5,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Home Office',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep7);
            
            Phoenix_Approval_Process_Step__c rfpStep9 = new  Phoenix_Approval_Process_Step__c(Name='Closed',Phoenix_Order__c = 6,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep9); 
        }
        insert stepsList;
        
        list<Phoenix_Bid_Process_Steps__c> processList=new list<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c bStep=new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c=	stepsList[0].Id;
        system.debug('stepsList[0].Id---------------'+stepsList[0].Id);
        bStep.Name= pb.Name+'-'+'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        bStep.Phoenix_Status__c =  'Submitted';
        bStep.Phoenix_Sub_Step__c = 1;
        processList.add(bStep);
        
        Phoenix_Bid_Process_Steps__c bStep2=new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name= pb.Name+'-'+'Marketing Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        bStep2.Phoenix_Process_Step__c=	stepsList[1].Id;
        
        bStep2.Phoenix_Approver_Team__c='Marketing';
        
        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
        Phoenix_Bid_Process_Steps__c bStep3=new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name= pb.Name+'-'+'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb.Id;
        bStep3.Phoenix_Process_Step__c=	stepsList[2].Id;
        
        bStep3.Phoenix_Approver_Team__c='Finance';
        
        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        Phoenix_Bid_Process_Steps__c bStep4=new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name= pb.Name+'-'+'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb.Id;
        bStep4.Phoenix_Process_Step__c=	stepsList[3].Id;
        bStep4.Phoenix_Approver_Team__c='Contracts';
        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        
        Phoenix_Bid_Process_Steps__c bStep5=new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name= pb.Name+'-'+'Marketing Approval';
       // bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep5.Phoenix_Status__c =  'In Process';
        bStep5.Phoenix_Approver_Team__c='Finance';
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
        Phoenix_Bid_Process_Steps__c bStep6=new Phoenix_Bid_Process_Steps__c();
        bStep6.Phoenix_Is_Criteria_Step__c = false;
        bStep6.Name= pb.Name+'-'+'Vistex Update';
       	bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep6.Phoenix_Bid__c = pb.Id;
        bStep6.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep6.Phoenix_Status__c =  'In Process';
        bStep6.Phoenix_Approver_Team__c='Supply Chain';
        bStep6.Phoenix_Sub_Step__c = 1;
        processList.add(bStep6);
        
        Phoenix_Bid_Process_Steps__c bStep7=new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name= pb.Name+'-'+'Closed';
        bStep7.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
        insert processList;
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:pb.Id ];
        system.debug('---bidProcessStepList---'+bidProcessStepList.size());
        list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Vistex_Status__c,Phoenix_MarketingLead_Approver__c,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        
        approvalRequestNotificationClass.approvalRequestNotification(pb.Id,processList);
    }
     static testmethod void approvalRequestNotification_TestMethod14(){
        List<Phoenix_User_Approval_Matrix__c> approvalGroups = new List<Phoenix_User_Approval_Matrix__c>();   
        List<Phoenix_User_Approval_Matrix__c> approvalUsers = new List<Phoenix_User_Approval_Matrix__c>();
        List<User> users = new List<User>();    
        List<Phoenix_Bid__c> bidsList = new List<Phoenix_Bid__c>(); 
        List<Phoenix_Bid__c> bidItemList = new List<Phoenix_Bid__c>(); 
        List<Product2> productList = new List<Product2>();
        List<Phoenix_Approval_Matrix__c> bidMatrixList = new List<Phoenix_Approval_Matrix__c>();
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list<Product2> prodList = new list<Product2>();
        Product2 prod1 = new Product2(Name = 'Test Product',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='11111',Phoenix_NDC_11__c='12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='22222',Phoenix_NDC_11__c='21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_NDC_11__c='32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c='Product Discontinuation Process';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Internal_Target_Date__c=Date.newInstance(2023, 04, 27);
        pb.Phoenix_Bid_Deadline_Date__c=System.Today();
        
        insert pb;
        
        list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        if(approvalGroups.size() ==0){
            Phoenix_User_Approval_Matrix__c group1= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Sales',Phoenix_Approval_Group_Behavior__c='Single User');
            approvalGroups.add(group1);
            Phoenix_User_Approval_Matrix__c group2= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Supply Chain',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group2);
            Phoenix_User_Approval_Matrix__c group3= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Marketing',Phoenix_Approval_Group_Behavior__c='Product based');
            approvalGroups.add(group3);
            
            Phoenix_User_Approval_Matrix__c group4= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Finance',Phoenix_Approval_Group_Behavior__c='Team');
            approvalGroups.add(group4);
            Phoenix_User_Approval_Matrix__c group5= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Contracts',Phoenix_Approval_Group_Behavior__c='Account based');
            approvalGroups.add(group5);
            
            insert approvalGroups;
        }
        if(approvalUsers.size() ==0){
            if(users.size() ==0){
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                String uid = ('Phoenix'+System.now().getTime()).SubString(0,8);
                User u1 = new User(Alias = uid, Email= uid + '@phoenix.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/New_York', UserName= uid + '@phoenix.com');      
                users.add(u1);
                insert users;
            }
            Phoenix_User_Approval_Matrix__c userApp1 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[0].Id);
            approvalUsers.add(userApp1);
            Phoenix_User_Approval_Matrix__c userApp2 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=users[0].Id,User_Group__c =approvalGroups[2].Id );
            approvalUsers.add(userApp2);
            Phoenix_User_Approval_Matrix__c userApp3 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[1].Id);
            approvalUsers.add(userApp3);
            Phoenix_User_Approval_Matrix__c userApp4 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[2].Id);
            approvalUsers.add(userApp4);
            Phoenix_User_Approval_Matrix__c userApp5 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[3].Id);
            approvalUsers.add(userApp5);
            Phoenix_User_Approval_Matrix__c userApp6 = new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_Users').getRecordTypeId(),Phoenix_Is_Approval_Process_User__c = true,Phoenix_Approver__c=UserInfo.getUserId(),User_Group__c =approvalGroups[4].Id);
            approvalUsers.add(userApp6);
            insert approvalUsers;
        }
        
        Phoenix_Approval_Matrix__c matrix5 = new Phoenix_Approval_Matrix__c(Phoenix_Bid_Type__c='NEW Individual Pricing Agreement (IPA)');
        bidMatrixList.add(matrix5);
        insert bidMatrixList;
        
        List<Phoenix_Approval_Process_Step__c> stepsList = new List<Phoenix_Approval_Process_Step__c>();
        // List<String> bidTypes = new List<String>(){'RFP Bids','VIP Rebate','Customer Requested Pricing Confirmations','RCA Member Addition','NEW Individual Pricing Agreement (IPA)'};
        for(Phoenix_Approval_Matrix__c matrix : bidMatrixList){
            Phoenix_Approval_Process_Step__c rfpStep1 = new  Phoenix_Approval_Process_Step__c(Name='Initial Submission',Phoenix_Order__c = 1,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep1);
            
            Phoenix_Approval_Process_Step__c rfpStep2 = new  Phoenix_Approval_Process_Step__c(Name='Marketing',Phoenix_Order__c = 2,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Marketing',Phoenix_Approval_Matrix__c=matrix.Id,Phoenix_Approver__c=UserInfo.getUserId());
            stepsList.add(rfpStep2);
            
            Phoenix_Approval_Process_Step__c rfpStep5 = new  Phoenix_Approval_Process_Step__c(Name='Finance',Phoenix_Order__c = 3,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Finance',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep5);
            Phoenix_Approval_Process_Step__c rfpStep6 = new  Phoenix_Approval_Process_Step__c(Name='Contracts',Phoenix_Order__c = 4,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Contracts',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep6); 
            Phoenix_Approval_Process_Step__c rfpStep7 = new  Phoenix_Approval_Process_Step__c(Name='Vistex Update',Phoenix_Order__c = 5,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Home Office',Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep7);
            
            Phoenix_Approval_Process_Step__c rfpStep9 = new  Phoenix_Approval_Process_Step__c(Name='Closed',Phoenix_Order__c = 6,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=matrix.Id);
            stepsList.add(rfpStep9); 
        }
        insert stepsList;
        
        list<Phoenix_Bid_Process_Steps__c> processList=new list<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c bStep=new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Phoenix_Process_Step__c=	stepsList[0].Id;
        system.debug('stepsList[0].Id---------------'+stepsList[0].Id);
        bStep.Name= pb.Name+'-'+'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        bStep.Phoenix_Status__c =  'Submitted';
        bStep.Phoenix_Sub_Step__c = 1;
        processList.add(bStep);
        
        Phoenix_Bid_Process_Steps__c bStep2=new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name= pb.Name+'-'+'Marketing Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        bStep2.Phoenix_Process_Step__c=	stepsList[1].Id;
        
        bStep2.Phoenix_Approver_Team__c='Marketing';
        
        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
        Phoenix_Bid_Process_Steps__c bStep3=new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name= pb.Name+'-'+'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb.Id;
        bStep3.Phoenix_Process_Step__c=	stepsList[2].Id;
        
        bStep3.Phoenix_Approver_Team__c='Finance';
        
        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        Phoenix_Bid_Process_Steps__c bStep4=new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name= pb.Name+'-'+'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb.Id;
        bStep4.Phoenix_Process_Step__c=	stepsList[3].Id;
        bStep4.Phoenix_Approver_Team__c='Contracts';
        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        
        Phoenix_Bid_Process_Steps__c bStep5=new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name= pb.Name+'-'+'Marketing Approval';
       // bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep5.Phoenix_Status__c =  'In Process';
        bStep5.Phoenix_Approver_Team__c='Marketing';
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
        Phoenix_Bid_Process_Steps__c bStep6=new Phoenix_Bid_Process_Steps__c();
        bStep6.Phoenix_Is_Criteria_Step__c = false;
        bStep6.Name= pb.Name+'-'+'Vistex Update';
       	bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep6.Phoenix_Bid__c = pb.Id;
        bStep6.Phoenix_Process_Step__c=	stepsList[4].Id;
        bStep6.Phoenix_Status__c =  'In Process';
        bStep6.Phoenix_Approver_Team__c='Sr Director or VP Finance';
        bStep6.Phoenix_Sub_Step__c = 1;
        processList.add(bStep6);
        
        Phoenix_Bid_Process_Steps__c bStep7=new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name= pb.Name+'-'+'Closed';
        bStep7.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
        insert processList;
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:pb.Id ];
        system.debug('---bidProcessStepList---'+bidProcessStepList.size());
        list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Vistex_Status__c,Phoenix_MarketingLead_Approver__c,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        
        approvalRequestNotificationClass.approvalRequestNotification(pb.Id,processList);
    }

}