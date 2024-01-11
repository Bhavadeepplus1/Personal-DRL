@isTest(SeeAllData=true)
public class Phoenix_ActiveDelegatorCheckerTest {
    static testmethod void test1() {
            Test.startTest();
         Phoenix_ActiveDelegatorChecker delegationschedule = new Phoenix_ActiveDelegatorChecker();
        delegationschedule.execute(null);
        Phoenix_Approval_Delegation_History__c dele = new Phoenix_Approval_Delegation_History__c();
        dele.Phoenix_Delegation_End_Time__c =datetime.newInstance(2023, 9, 15, 12, 30, 0);
          dele.Phoenix_Delegation_Start_Time__c =datetime.newInstance(2022, 9, 15, 12, 30, 0); 
          dele.Phoenix_Is_Active_delegator__c = true;
        insert dele;
           Phoenix_Approval_Delegation_History__c dele1 = new Phoenix_Approval_Delegation_History__c();
        dele1.Phoenix_Delegation_End_Time__c =datetime.newInstance(2012, 9, 15, 12, 30, 0);
          dele1.Phoenix_Delegation_Start_Time__c =datetime.newInstance(2011, 9, 15, 12, 30, 0); 
          dele1.Phoenix_Is_Active_delegator__c = true;
        insert dele1;
        dele1.Phoenix_Delegation_Start_Time__c = datetime.newInstance(2011, 10, 15, 12, 30, 0);
        update dele1;
        
         
        Test.stopTest();
    }

}