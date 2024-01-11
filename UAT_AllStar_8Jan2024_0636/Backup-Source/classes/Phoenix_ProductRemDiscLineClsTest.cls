@isTest
public class Phoenix_ProductRemDiscLineClsTest {
    
    
    static testmethod void Phoenix_ProductRemDiscLineClsMethod(){
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
        bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c=	stepsList[4].Id;
        
        bStep5.Phoenix_Status__c =  'In Process';
        bStep5.Phoenix_Approver_Team__c='Home Office';
        
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
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
        
        Phoenix_ProductRemDiscLineCls.getRelatedList(pb.Id);
        
        Phoenix_ProductRemDiscLineCls.saveLineItems(lineItemsList1);
        Phoenix_ProductRemDiscLineCls.makeApprovalsVistex(pb.Id,lineItemsList1,true);
        //Phoenix_ProductRemDiscLineCls.submitToProceddStep1(pb.Id,true,false,false,false,false);
        Phoenix_ProductRemDiscLineCls.submitToProceddStep1(pb.Id,false,true,false,false,false);
        Phoenix_ProductRemDiscLineCls.submitToProceddStep1(pb.Id,false,false,true,false,false);
        Phoenix_ProductRemDiscLineCls.makeApprovals(pb.Id,lineItemsList1,true);
        Phoenix_ProductRemDiscLineCls.makeApprovalsMarketingLead(pb.Id,lineItemsList1,true,false);
        Phoenix_ProductRemDiscLineCls.updateNextMarketingProcessSteps(pb.Id,pb.Name,bidProcessStepList,false);
        Phoenix_ProductRemDiscLineCls.updateNextMarketingLeadProcessSteps(pb.Id,pb.Name,bidProcessStepList,false);
        //Phoenix_ProductRemDiscLineCls.updateNextMarketingProcessSteps(pb.Id,pb.Name,bidProcessStepList,false);
        Phoenix_ProductRemDiscLineCls.makeApprovalsContracts(pb.Id,lineItemsList1,true,false,true);
        Phoenix_ProductRemDiscLineCls.makeApprovalsContracts(pb.Id,lineItemsList1,true,true,false);
        Phoenix_ProductRemDiscLineCls.updateNextFinanceProcessSteps(pb.Id,pb.Name,bidProcessStepList);
        Phoenix_ProductRemDiscLineCls.updateNextContractsProcessSteps(pb.Id,'Mass Product Removals',pb.Name,bidProcessStepList);
        Phoenix_ProductRemDiscLineCls.submitToProceedVistex(pb.Id);
        Phoenix_ProductRemDiscLineCls.updateNextVistexProcessSteps(pb.Id,pb.Name,bidProcessStepList,false);
        Phoenix_ProductRemDiscLineCls.getDocs(pb.Id);
        Phoenix_ProductRemDiscLineCls.deleteLineItems(lineItemsList[0].Id);
        //added by Shashirekha
        //Phoenix_ProductRemDiscLineCls.coderItems();
        
    }
    //Added by Shashirekha
    static testmethod void Phoenix_ProductRemDiscLineClsMethod1(){
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
        pb.Phoenix_is_OTC_Bid__c=true;
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
        
        Phoenix_Bid__c pb1 = new Phoenix_Bid__c();
        pb1.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb1.Phoenix_Comments__c = 'Test Comments';
        pb1.Phoenix_is_OTC_Bid__c=false;
        pb1.Phoenix_Customer__c = testAccount.Id;
        insert pb1;
        
        list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10,Phoenix_MarketingLead_Final_Approval__c=true,Phoenix_MarketingLead_Approver__c='Not Approved');
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
        bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        bStep5.Phoenix_Process_Step__c=	stepsList[4].Id;
        
        bStep5.Phoenix_Status__c =  'In Process';
        bStep5.Phoenix_Approver_Team__c='Home Office';
        
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
        Phoenix_Bid_Process_Steps__c bStep7=new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name= pb.Name+'-'+'Closed';
        bStep7.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
        insert processList;
        
        List<Phoenix_Approval_Grid__c> pagList=new List<Phoenix_Approval_Grid__c>();
        Phoenix_Approval_Grid__c pag=new Phoenix_Approval_Grid__c();
		pag.Phoenix_Product_Family__c='Product Family';
		pag.Phoenix_Is_partner_product__c=true;
		pag.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		//pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
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
       // pag.Phoenix_Is_New_Low__c=true;
        pag.Phoenix_Bid__c=pb.Id;
		insert pag;
        
        Phoenix_Approval_Grid__c pag1=new Phoenix_Approval_Grid__c();
		pag1.Phoenix_Product_Family__c='Product Family';
		pag1.Phoenix_Is_partner_product__c=true;
		pag1.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		//pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag1.Phoenix_Is_SVP_Notification_Required__c=true;
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
        
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:pb.Id ];
        system.debug('---bidProcessStepList---'+bidProcessStepList.size());
        list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Vistex_Status__c,Phoenix_MarketingLead_Approver__c,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        
        Phoenix_ProductRemDiscLineCls.getRelatedList(pb.Id);
        
        
        Phoenix_ProductRemDiscLineCls.saveLineItems(lineItemsList1);
        Phoenix_ProductRemDiscLineCls.makeApprovalsVistex(pb.Id,lineItemsList1,true);
        //Phoenix_ProductRemDiscLineCls.submitToProceddStep1(pb.Id,true,false,false,false,false);
        Phoenix_ProductRemDiscLineCls.submitToProceddStep1(pb.Id,false,true,false,false,false);
        Phoenix_ProductRemDiscLineCls.submitToProceddStep1(pb.Id,false,false,true,false,false);
        Phoenix_ProductRemDiscLineCls.makeApprovals(pb.Id,lineItemsList1,true);
        Phoenix_ProductRemDiscLineCls.makeApprovalsMarketingLead(pb.Id,lineItemsList1,true,false);
        Phoenix_ProductRemDiscLineCls.makeApprovalsMarketingLead(pb.Id,lineItemsList1,true,true);
        Phoenix_ProductRemDiscLineCls.updateNextMarketingProcessSteps(pb.Id,pb.Name,bidProcessStepList,false);
        Phoenix_ProductRemDiscLineCls.updateNextMarketingLeadProcessSteps(pb.Id,pb.Name,bidProcessStepList,false);
        //Phoenix_ProductRemDiscLineCls.updateNextMarketingProcessSteps(pb.Id,pb.Name,bidProcessStepList,false);
        Phoenix_ProductRemDiscLineCls.makeApprovalsContracts(pb.Id,lineItemsList1,true,false,true);
        Phoenix_ProductRemDiscLineCls.makeApprovalsContracts(pb.Id,lineItemsList1,true,true,false);
        Phoenix_ProductRemDiscLineCls.updateNextFinanceProcessSteps(pb.Id,pb.Name,bidProcessStepList);
        Phoenix_ProductRemDiscLineCls.updateNextContractsProcessSteps(pb.Id,'Mass Product Removals',pb.Name,bidProcessStepList);
        Phoenix_ProductRemDiscLineCls.updateNextContractsProcessSteps(pb.Id,'Product Discontinuation Process',pb.Name,bidProcessStepList);
        Phoenix_ProductRemDiscLineCls.submitToProceedVistex(pb.Id);
        Phoenix_ProductRemDiscLineCls.updateNextVistexProcessSteps(pb.Id,pb.Name,bidProcessStepList,false);
        Phoenix_ProductRemDiscLineCls.getDocs(pb.Id);
        Phoenix_ProductRemDiscLineCls.deleteLineItems(lineItemsList[0].Id);
        Phoenix_ProductRemDiscLineCls.deleteAttachments(lineItemsList[0].Id,pb.Id);
        Phoenix_ProductRemDiscLineCls.getExistingDocs(pb.Id);
        //Phoenix_ProductRemDiscLineCls.coderItems();
        Phoenix_ProductRemDiscLineCls.approvalAlert(pb.Id,processList);
        //Phoenix_ProductRemDiscLineCls.approvalAlert(pb1.Id,processList);
    }
     static testmethod void Phoenix_ProductRemDiscLineClsMethod2(){
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
        pb.Phoenix_is_OTC_Bid__c=true;
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
        
        Phoenix_Bid__c pb1 = new Phoenix_Bid__c();
        pb1.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb1.Phoenix_Comments__c = 'Test Comments';
        pb1.Phoenix_is_OTC_Bid__c=false;
        pb1.Phoenix_Customer__c = testAccount.Id;
        insert pb1;
        
        list<Phoenix_Bid_Line_Item__c> lineItemsList = new list<Phoenix_Bid_Line_Item__c>();
        for (Integer i = 0; i < prodList.size(); i++){
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10,Phoenix_MarketingLead_Final_Approval__c=true,Phoenix_MarketingLead_Approver__c='Not Approved');
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
        bStep.Phoenix_Bid__c = pb1.Id;
        bStep.Phoenix_Status__c =  'Submitted';
        bStep.Phoenix_Sub_Step__c = 1;
        bStep.Phoenix_Approver_Team__c = 'Marketing Lead Rx';
        processList.add(bStep);
        
        Phoenix_Bid_Process_Steps__c bStep8=new Phoenix_Bid_Process_Steps__c();
        bStep8.Phoenix_Is_Criteria_Step__c = false;
        bStep8.Name= pb.Name+'-'+'Marketing Approval';
        bStep8.Phoenix_Approver__c = UserInfo.getUserId();
        bStep8.Phoenix_Bid__c = pb1.Id;
        bStep8.Phoenix_Process_Step__c=	stepsList[1].Id;
        bStep8.Phoenix_Approver_Team__c='Marketing Lead SRx';
        bStep8.Phoenix_Sub_Step__c = 1;
        processList.add(bStep8);
        
        Phoenix_Bid_Process_Steps__c bStep9=new Phoenix_Bid_Process_Steps__c();
        bStep9.Phoenix_Is_Criteria_Step__c = false;
        bStep9.Name= pb.Name+'-'+'Marketing Approval';
        bStep9.Phoenix_Approver__c = UserInfo.getUserId();
        bStep9.Phoenix_Bid__c = pb1.Id;
        bStep9.Phoenix_Process_Step__c=	stepsList[1].Id;        
        bStep9.Phoenix_Approver_Team__c='Marketing Lead OTC';
        bStep9.Phoenix_Sub_Step__c = 1;
        processList.add(bStep9);
        
        Phoenix_Bid_Process_Steps__c bStep2=new Phoenix_Bid_Process_Steps__c();
        bStep2.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name= pb.Name+'-'+'Marketing Approval';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb1.Id;
        bStep2.Phoenix_Process_Step__c=	stepsList[1].Id;
        
        bStep2.Phoenix_Approver_Team__c='Marketing';
        
        bStep2.Phoenix_Sub_Step__c = 1;
        processList.add(bStep2);
        Phoenix_Bid_Process_Steps__c bStep3=new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name= pb.Name+'-'+'Finance Approval';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb1.Id;
        bStep3.Phoenix_Process_Step__c=	stepsList[2].Id;
        
        bStep3.Phoenix_Approver_Team__c='Finance';
        
        bStep3.Phoenix_Sub_Step__c = 1;
        processList.add(bStep3);
        Phoenix_Bid_Process_Steps__c bStep4=new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name= pb.Name+'-'+'Contracts';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb1.Id;
        bStep4.Phoenix_Process_Step__c=	stepsList[3].Id;
        
        bStep4.Phoenix_Approver_Team__c='Contracts';
        
        bStep4.Phoenix_Sub_Step__c = 1;
        processList.add(bStep4);
        Phoenix_Bid_Process_Steps__c bStep5=new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name= pb.Name+'-'+'Vistex Update';
        bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb1.Id;
        bStep5.Phoenix_Process_Step__c=	stepsList[4].Id;
        
        bStep5.Phoenix_Status__c =  'In Process';
        bStep5.Phoenix_Approver_Team__c='Home Office';
        
        bStep5.Phoenix_Sub_Step__c = 1;
        processList.add(bStep5);
        
        Phoenix_Bid_Process_Steps__c bStep7=new Phoenix_Bid_Process_Steps__c();
        bStep7.Phoenix_Is_Criteria_Step__c = false;
        bStep7.Name= pb.Name+'-'+'Closed';
        bStep7.Phoenix_Process_Step__c=	stepsList[5].Id;
        bStep7.Phoenix_Approver__c = UserInfo.getUserId();
        bStep7.Phoenix_Bid__c = pb1.Id;
        bStep7.Phoenix_Sub_Step__c = 1;
        processList.add(bStep7);
        insert processList;
        
        List<Phoenix_Approval_Grid__c> pagList=new List<Phoenix_Approval_Grid__c>();
        Phoenix_Approval_Grid__c pag=new Phoenix_Approval_Grid__c();
		pag.Phoenix_Product_Family__c='Product Family';
		pag.Phoenix_Is_partner_product__c=false;
		pag.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		//pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
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
        pag.Phoenix_Bid__c=pb1.Id;
		insert pag;
        
        Phoenix_Approval_Grid__c pag1=new Phoenix_Approval_Grid__c();
		pag1.Phoenix_Product_Family__c='Product Family';
		pag1.Phoenix_Is_partner_product__c=false;
		pag1.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		//pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag1.Phoenix_Is_SVP_Notification_Required__c=true;
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
		pag.Phoenix_Annualized_TP__c=4;
       	pag.Phoenix_Is_New_Low__c=false;
        pag1.Phoenix_Bid__c=pb1.Id;
		insert pag1;
        pagList.add(pag1);
         
        Phoenix_Approval_Grid__c pag2=new Phoenix_Approval_Grid__c();
		pag2.Phoenix_Product_Family__c='Product Family';
		pag2.Phoenix_Is_partner_product__c=true;
		pag2.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		//pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag2.Phoenix_Is_SVP_Notification_Required__c=true;
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
        pag2.Phoenix_Annualized_GM_Impact__c=4;
		pag2.Phoenix_Annualized_TP__c=3;
		pag2.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
		pag2.Phoenix_Annualized_TP__c=4;
       	pag2.Phoenix_Is_New_Low__c=false;
        pag2.Phoenix_Bid__c=pb1.Id;
		insert pag2;
        pagList.add(pag2);
         
        
        list<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:pb.Id ];
        system.debug('---bidProcessStepList---'+bidProcessStepList.size());
        list<Phoenix_Bid_Line_Item__c> lineItemsList1=[select Id,Phoenix_Vistex_Status__c,Phoenix_MarketingLead_Approver__c,Phoenix_Finance_Approval__c,Phoenix_Product_Director1__c,Phoenix_SCM_Final_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Contract_Approval__c,Phoenix_Product_Director__c,Phoenix_Marketing_Final_Approval__c,Phoenix_Marketing_Approval__c,Phoenix_Final_Status__c,Phoenix_Proposed_IPA_Price__c,Phoenix_IDN_Usage__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:pb.Id ];
        
        Phoenix_ProductRemDiscLineCls.getRelatedList(pb.Id);
        
        
        Phoenix_ProductRemDiscLineCls.saveLineItems(lineItemsList1);
        Phoenix_ProductRemDiscLineCls.makeApprovalsVistex(pb.Id,lineItemsList1,true);
        //Phoenix_ProductRemDiscLineCls.submitToProceddStep1(pb.Id,true,false,false,false,false);
        Phoenix_ProductRemDiscLineCls.submitToProceddStep1(pb.Id,false,true,false,false,false);
        Phoenix_ProductRemDiscLineCls.submitToProceddStep1(pb.Id,false,false,true,false,false);
        Phoenix_ProductRemDiscLineCls.makeApprovals(pb.Id,lineItemsList1,true);
        Phoenix_ProductRemDiscLineCls.makeApprovalsMarketingLead(pb.Id,lineItemsList1,true,false);
        Phoenix_ProductRemDiscLineCls.makeApprovalsMarketingLead(pb.Id,lineItemsList1,true,true);
        Phoenix_ProductRemDiscLineCls.updateNextMarketingProcessSteps(pb.Id,pb.Name,bidProcessStepList,false);
        Phoenix_ProductRemDiscLineCls.updateNextMarketingLeadProcessSteps(pb.Id,pb.Name,bidProcessStepList,false);
        //Phoenix_ProductRemDiscLineCls.updateNextMarketingProcessSteps(pb.Id,pb.Name,bidProcessStepList,false);
        Phoenix_ProductRemDiscLineCls.makeApprovalsContracts(pb.Id,lineItemsList1,true,false,true);
        Phoenix_ProductRemDiscLineCls.makeApprovalsContracts(pb.Id,lineItemsList1,true,true,false);
        Phoenix_ProductRemDiscLineCls.updateNextFinanceProcessSteps(pb.Id,pb.Name,bidProcessStepList);
        Phoenix_ProductRemDiscLineCls.updateNextContractsProcessSteps(pb.Id,'Mass Product Removals',pb.Name,bidProcessStepList);
        Phoenix_ProductRemDiscLineCls.updateNextContractsProcessSteps(pb.Id,'Product Discontinuation Process',pb.Name,bidProcessStepList);
        Phoenix_ProductRemDiscLineCls.submitToProceedVistex(pb.Id);
        Phoenix_ProductRemDiscLineCls.updateNextVistexProcessSteps(pb.Id,pb.Name,bidProcessStepList,false);
        Phoenix_ProductRemDiscLineCls.getDocs(pb.Id);
        Phoenix_ProductRemDiscLineCls.deleteLineItems(lineItemsList[0].Id);
        Phoenix_ProductRemDiscLineCls.deleteAttachments(lineItemsList[0].Id,pb.Id);
        Phoenix_ProductRemDiscLineCls.getExistingDocs(pb.Id);
        //Phoenix_ProductRemDiscLineCls.coderItems();
        //Phoenix_ProductRemDiscLineCls.approvalAlert(pb.Id,processList);
        Phoenix_ProductRemDiscLineCls.approvalAlert(pb1.Id,processList);
    }
    
}