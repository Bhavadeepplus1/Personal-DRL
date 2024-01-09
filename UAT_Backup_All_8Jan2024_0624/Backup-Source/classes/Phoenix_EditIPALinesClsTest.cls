/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
@isTest
public class Phoenix_EditIPALinesClsTest {


    static testmethod void Phoenix_EditIPALinesClsMethod() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Contracts_Approver__c = UserInfo.getUserId());
        insert testAccount;

        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
        list < Phoenix_RCA_IPA_LINE__c > lineItemsList = new list < Phoenix_RCA_IPA_LINE__c > ();
        for (Integer i = 0; i < 4; i++) {
            Phoenix_RCA_IPA_LINE__c pbl = new Phoenix_RCA_IPA_LINE__c(Phoenix_Bid__c = pb.Id, Phoenix_Contract_Status__c = 'Sent to Customer');
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        Phoenix_EditIPALinesCls.getRelatedList(pb.Id);
        Phoenix_EditIPALinesCls.deleteLineItems(lineItemsList[0].Id);
        list < Phoenix_RCA_IPA_LINE__c > lineItemsList1 = [select Id, Phoenix_New_GPO__c, Phoenix_Wholesaler__c, Phoenix_Wholesaler_Location__c, Phoenix_Contract_Status__c from Phoenix_RCA_IPA_LINE__c where Phoenix_Bid__c =: pb.Id];
        Phoenix_EditIPALinesCls.saveLineItems(lineItemsList1);
        Phoenix_EditIPALinesCls.getDependentPicklist();
        Phoenix_EditIPALinesCls.submitToProceddStep1(pb.Id);
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        testData.generateApprovalMatrix();
        //Phoenix_SubmitBidForApprovalCtrl.createBidApprovalItems(new List<Phoenix_Bid__c>{pb});
        list < Phoenix_Bid_Process_Steps__c > processList = new list < Phoenix_Bid_Process_Steps__c > ();
        Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Name = pb.Name + '-' + 'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep.Phoenix_Status__c = 'Submitted';
        bStep.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep.Phoenix_Sub_Step__c = 1;
        insert bStep;
        Phoenix_Bid_Process_Steps__c bStep1 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep1.Name = pb.Name + '-' + 'Contracts';
        bStep1.Phoenix_Approver__c = UserInfo.getUserId();
        bStep1.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep1.Phoenix_Status__c = 'In Process';
        bStep1.Phoenix_Approver_Team__c = 'Contracts';
        //stepNo : Ask and increment as per requirements
        bStep1.Phoenix_Sub_Step__c = 1;
        insert bStep1;
        Phoenix_Bid_Process_Steps__c bStep2 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name = pb.Name + '-' + 'Home Office';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        //bStep2.Phoenix_Status__c =  'Completed';
        bStep2.Phoenix_Approver_Team__c = 'Home Office';
        //stepNo : Ask and increment as per requirements
        bStep2.Phoenix_Sub_Step__c = 1;
        insert bStep2;
        processList.add(bStep);
        processList.add(bStep1);
        processList.add(bStep2);
        Phoenix_EditIPALinesCls.makeApprovalsContracts(pb.Id, lineItemsList1, true);
        Phoenix_EditIPALinesCls.updateNextContractsProcessSteps(pb.Id, pb.Name, processList, true);
    }
    
    
     /* @isTest static void Phoenix_EditIPALinesClsMethod1() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Contracts_Approver__c = UserInfo.getUserId());
        insert testAccount;

        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
        list < Phoenix_RCA_IPA_LINE__c > lineItemsList = new list < Phoenix_RCA_IPA_LINE__c > ();
        for (Integer i = 0; i < 4; i++) {
            Phoenix_RCA_IPA_LINE__c pbl = new Phoenix_RCA_IPA_LINE__c(Phoenix_Bid__c = pb.Id, Phoenix_Contract_Status__c = 'Sent to Customer');
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        Phoenix_EditIPALinesCls.getRelatedList(pb.Id);
        Phoenix_EditIPALinesCls.deleteLineItems(lineItemsList[0].Id);
        list < Phoenix_RCA_IPA_LINE__c > lineItemsList1 = [select Id, Phoenix_New_GPO__c, Phoenix_Wholesaler__c, Phoenix_Wholesaler_Location__c, Phoenix_Contract_Status__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Final_Status__c from Phoenix_RCA_IPA_LINE__c where Phoenix_Bid__c =: pb.Id];
        Phoenix_EditIPALinesCls.saveLineItems(lineItemsList1);
           
           
           
  Phoenix_EditIPALinesCls.getDependentPicklist();
        Phoenix_EditIPALinesCls.submitToProceddStep1(pb.Id);
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        testData.generateApprovalMatrix();
        //Phoenix_SubmitBidForApprovalCtrl.createBidApprovalItems(new List<Phoenix_Bid__c>{pb});
        list < Phoenix_Bid_Process_Steps__c > processList = new list < Phoenix_Bid_Process_Steps__c > ();
        Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Name = pb.Name + '-' + 'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep.Phoenix_Status__c = 'Submitted';
        bStep.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep.Phoenix_Sub_Step__c = 1;
        insert bStep;
        Phoenix_Bid_Process_Steps__c bStep1 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep1.Name = pb.Name + '-' + 'Contracts';
        bStep1.Phoenix_Approver__c = UserInfo.getUserId();
        bStep1.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep1.Phoenix_Status__c = 'In Process';
        bStep1.Phoenix_Approver_Team__c = 'Contracts';
        //stepNo : Ask and increment as per requirements
        bStep1.Phoenix_Sub_Step__c = 1;
        insert bStep1;
        Phoenix_Bid_Process_Steps__c bStep2 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name = pb.Name + '-' + 'Home Office';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        //bStep2.Phoenix_Status__c =  '';
        bStep2.Phoenix_Approver_Team__c = 'Home Office';
        //stepNo : Ask and increment as per requirements
        bStep2.Phoenix_Sub_Step__c = 1;
        insert bStep2;
        processList.add(bStep);
        processList.add(bStep1);
        processList.add(bStep2);
        Phoenix_EditIPALinesCls.makeApprovalsContracts(pb.Id, lineItemsList1, true);
        Phoenix_EditIPALinesCls.updateNextContractsProcessSteps(pb.Id, pb.Name, processList, true);
    }*/
     static testmethod void Phoenix_EditIPALinesClsMethod2() {
         Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Contracts_Approver__c = UserInfo.getUserId());
        insert testAccount;

        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
       //******************************Marketing
        
        Id devRecordTypeId = Schema.SObjectType.Phoenix_User_Approval_Matrix__c.getRecordTypeInfosByName().get('Approval User Group').getRecordTypeId();
        Phoenix_User_Approval_Matrix__c app11 = new Phoenix_User_Approval_Matrix__c();
        app11.Name = 'Marketing User Group Testing 1';
        app11.Phoenix_Approver_Group_Name__c = 'Marketing';
        app11.RecordTypeId = devRecordTypeId;
        insert app11;
        
        Phoenix_User_Approval_Matrix__c app22 = new Phoenix_User_Approval_Matrix__c();
        app22.Name = 'Marketing User Group Testing 2';
        app22.Phoenix_Approver_Group_Name__c = 'Marketing';
        app22.RecordTypeId = devRecordTypeId;
        insert app22;
        
        Phoenix_User_Approval_Matrix__c app1 = new Phoenix_User_Approval_Matrix__c();
        app1.Name = 'Testing 1';
        app1.Phoenix_Approver__c = UserInfo.getUserId();
        app1.User_Group__c = app11.id;
        insert app1;
        
        Phoenix_User_Approval_Matrix__c app2 = new Phoenix_User_Approval_Matrix__c();
        app2.Name = 'Testing 2';
        app2.User_Group__c = app22.id;
        app2.Phoenix_Approver__c = UserInfo.getUserId();
        insert app2; 
        
        //******************************Contracts
        Phoenix_User_Approval_Matrix__c app111 = new Phoenix_User_Approval_Matrix__c();
        app111.Name = 'Contracts User Group Testing 1';
        app111.Phoenix_Approver_Group_Name__c = 'Contracts';
        app111.RecordTypeId = devRecordTypeId;
        insert app111;
        
        Phoenix_User_Approval_Matrix__c app222 = new Phoenix_User_Approval_Matrix__c();
        app222.Name = 'Contracts User Group Testing 2';
        app222.Phoenix_Approver_Group_Name__c = 'Contracts';
        app222.RecordTypeId = devRecordTypeId;
        insert app222;
        
        Phoenix_User_Approval_Matrix__c app12 = new Phoenix_User_Approval_Matrix__c();
        app12.Name = 'Testing 1';
        app12.Phoenix_Approver__c = UserInfo.getUserId();
        app12.User_Group__c = app111.id;
        insert app12;
        
        Phoenix_User_Approval_Matrix__c app23 = new Phoenix_User_Approval_Matrix__c();
        app23.Name = 'Testing 2';
        app23.User_Group__c = app222.id;
        app23.Phoenix_Approver__c = UserInfo.getUserId();
        insert app23; 
         
          list < Phoenix_RCA_IPA_LINE__c > lineItemsList1 = new list < Phoenix_RCA_IPA_LINE__c > ();
        for (Integer i = 0; i < 4; i++) {
            Phoenix_RCA_IPA_LINE__c pbl = new Phoenix_RCA_IPA_LINE__c(Phoenix_Bid__c = pb.Id, Phoenix_Contract_Status__c = 'Line Error- Not Sent');
            lineItemsList1.add(pbl);
        }
        insert lineItemsList1;
         
          
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324',Phoenix_Product_Director__c = UserInfo.getUserId() ,Phoenix_Marketing_Lead__c = UserInfo.getUserId());
        insert prod1;
        
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
         //bl.Phoenix_Final_Status__c = ' Approved2';
        bl.Phoenix_Product_Family1__c = 'Habitrol';
        bl.Phoenix_Product_Director1__c = UserInfo.getUserId();
        bl.Phoenix_Marketing_Final_Approval__c = true;
        insert bl;
        Phoenix_EditIPALinesCls.getRelatedList(pb.Id);
       Phoenix_EditIPALinesCls.makeApprovalsContracts(pb.Id, lineItemsList1, true);

     }
       @istest static  void Phoenix_EditIPALinesClsMethod3() {
               Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
       
              Phoenix_Bid__c pb = new Phoenix_Bid__c();
         
        pb.Phoenix_Customer__c = testAccount.Id;
             pb.Phoenix_Approval_Status__c = 'Draft';
        insert pb;
             
             Phoenix_Approval_Matrix__c am = new Phoenix_Approval_Matrix__c();
        am.Name = 'test';
        insert am;
        Phoenix_Approval_Process_Step__c ap = new Phoenix_Approval_Process_Step__c();
        ap.Phoenix_Approval_Matrix__c = am.id;
        ap.Phoenix_Order__c = 1;
        insert ap;
        System.assertEquals(1, ap.Phoenix_Order__c);
             
        List < Phoenix_Bid_Process_Steps__c >m = new List < Phoenix_Bid_Process_Steps__c >();
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();

             for(integer i = 0 ; i < 5 ; i++)
             {
                  Phoenix_Bid_Process_Steps__c bisp3 = new Phoenix_Bid_Process_Steps__c();
        bisp3.Name = 'Closed';
        bisp3.Phoenix_Process_Step__c = ap.id;
        bisp3.Phoenix_Bid__c = pb.Id;
        bisp3.Phoenix_Approver__c = Userinfo.getUserId();
        bisp3.Phoenix_Approver_Team__c = 'Home Office';
                 m.add(bisp3);
             }
             insert m;
        for(Phoenix_Bid_Process_Steps__c c : m)
        {
           stepMap.put(Integer.valueOf(c.Phoenix_Step__c),new List<Phoenix_Bid_Process_Steps__c>{c}); 
           stepNamesMap.put(c.Phoenix_Approver_Team__c,new List<Phoenix_Bid_Process_Steps__c>{c}); 
                            stepnameNoMap.put(c.Phoenix_Approver_Team__c, Integer.valueOf(c.Phoenix_Step__c));
        }
        Phoenix_EditIPALinesCls.updateNextContractsProcessSteps(pb.Id,pb.Name ,m, false);     
         }
    
    
        @istest static  void Phoenix_EditIPALinesClsMethod4() {
              Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        testData.generateUsers();
        Account testAccount = new Account(Name = 'Test Email Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
                 
        Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
        p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        p2.Phoenix_Product_Director__c = testData.users[0].Id;
        insert p2;         
       
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'WAC Change Submissions';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Internal_Target_Date__c = Date.parse('10/12/2021');
        //User curUser = [SELECT Id, Username, Email FROM User where Username = 'manisha+phoenix+project1@dhruvsoft.com'];
        //pb.Phoenix_Sales_Person_2__c=curUser.Id;
        pb.Phoenix_Sales_Person_2__c = Userinfo.getUserId();
        //pb.Phoenix_Salesperson__c =UserInfo.getUserId();
        insert pb;
        List < Phoenix_Bid_Process_Steps__c > processSteps = new List < Phoenix_Bid_Process_Steps__c >();
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();

        Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
        ps.Phoenix_Bid__c = pb.Id;
        ps.Phoenix_Approver_Team__c = 'Contracts';
        ps.Phoenix_Approver__c = UserInfo.getUserId();
        ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
                  Phoenix_Bid_Process_Steps__c ps2 = new Phoenix_Bid_Process_Steps__c();
        ps2.Phoenix_Bid__c = pb.Id;
        ps2.Phoenix_Approver_Team__c = 'Home Office';
        ps2.Phoenix_Approver__c = UserInfo.getUserId();
        ps2.Phoenix_Approver_Team_Members__c = 'Surender Patel';
            processSteps.add(ps2);
             insert processSteps;
        for(Phoenix_Bid_Process_Steps__c c : processSteps)
        {
           stepMap.put(Integer.valueOf(c.Phoenix_Step__c),new List<Phoenix_Bid_Process_Steps__c>{c}); 
           stepNamesMap.put(c.Phoenix_Approver_Team__c,new List<Phoenix_Bid_Process_Steps__c>{c}); 
                            stepnameNoMap.put(c.Phoenix_Approver_Team__c, Integer.valueOf(c.Phoenix_Step__c));
        }
         Phoenix_EditIPALinesCls.updateNextContractsProcessSteps(pb.Id,pb.Name ,processSteps, false);     
         }

}