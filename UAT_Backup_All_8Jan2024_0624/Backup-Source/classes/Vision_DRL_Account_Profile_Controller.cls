public class Vision_DRL_Account_Profile_Controller {
    
    @AuraEnabled
    public static List<Account> getAccountPlanDetails(String accountId){
        try{
            
            System.debug('accountId: ' + accountId);
            
            List<Account> accountList= new List<Account>();
            
            accountList = [Select Id,Account_Overview__c,Account_Strategy__c,Risks_and_Challenges__c,Customer_s_Buying_Strategy__c,Pricing_Strategy__c,Growth_Goals__c 
                           From Account Where Id = : accountId];
            System.debug('accountList  ' +accountList );
            
            return accountList;}
        catch(Exception ex){
            //System.debug('Error: ' + ex.getMessage());
            return null;
        }
    }
    
    @auraEnabled
    public static string sendDataAndSave(String accountOverview,
                                         String pricingStrategy,
                                         String customerBuyingStrategy,
                                         String accountStrategy,
                                         String growthGoals,
                                         String risksChallenges,
                                         String accId)
    {
        try{
            List<Account> accountList= new List<Account>();
            
           /* accountList = [Select Id,Account_Overview__c,Account_Strategy__c,Risks_and_Challenges__c,Customer_s_Buying_Strategy__c,Pricing_Strategy__c,Growth_Goals__c 
                           From Account Where Id = : accId];
            System.debug('accountList  ' +accountList );
            //System.debug('daccountPlanList ' +accountPlanList);
            */
                Account accToUpdate = new Account();
                accToUpdate.id = accId;
                accToUpdate.Account_Overview__c = accountOverview;
                accToUpdate.Pricing_Strategy__c = pricingStrategy;
                accToUpdate.Customer_s_Buying_Strategy__c = customerBuyingStrategy;
                accToUpdate.Account_Strategy__c = accountStrategy;
                accToUpdate.Growth_Goals__c = growthGoals;
                accToUpdate.Risks_and_Challenges__c = risksChallenges;
                //accPlanToUpdate.Account__c = accId;
                update accToUpdate;
            
            return 'SUCCESS';
        }catch(exception e){
            return 'ERROR : Unanble to update the Account. Exception : '+e.getMessage();
        }
    }
}