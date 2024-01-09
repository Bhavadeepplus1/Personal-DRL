@isTest
public class Outlook_DRL_Account_ProfileTest 
{
	static testmethod void test()
    {
         Account acc = new Account();
        acc.Name = 'Test Account';
        
        //acc.Account__c=acc.Id;
        acc.Account_Overview__c='Test';
        acc.Account_Strategy__c='Test';
        acc.Pricing_Strategy__c='Test';
        acc.Customer_s_Buying_Strategy__c='Test';
        acc.Growth_Goals__c='Test';
        acc.Risks_and_Challenges__c='Test';
        insert  acc; 
        Outlook_DRL_Account_Profile_Controller.getAccounts();
        Outlook_DRL_Account_Profile_Controller.getAccountPlanDetails(acc.Id);
        Outlook_DRL_Account_Profile_Controller.sendDataAndSave(acc.Account_Strategy__c,acc.Pricing_Strategy__c,acc.Customer_s_Buying_Strategy__c,acc.Account_Strategy__c,acc.Growth_Goals__c,acc.Risks_and_Challenges__c,acc.Id);

        
    }
}