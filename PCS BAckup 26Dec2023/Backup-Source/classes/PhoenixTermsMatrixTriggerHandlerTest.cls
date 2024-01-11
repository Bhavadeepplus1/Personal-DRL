@isTest
public class PhoenixTermsMatrixTriggerHandlerTest {
     public static testmethod void testTermsMatrixTrigger(){
		Account acc = new Account(Name = 'contract Account');
		insert acc;
        List<Phoenix_Terms_Matrix__c> termMatrixList = new List<Phoenix_Terms_Matrix__c>();
		Phoenix_Terms_Matrix__c parentTermMatrix = new Phoenix_Terms_Matrix__c(Name = 'test matrix', Phoenix_Agreement_Name__c = 'test agreeent', Phoenix_Customer_Name__c = acc.Id);
		Phoenix_Terms_Matrix__c childTermMatrix = new Phoenix_Terms_Matrix__c(Name = 'test matrix2', Phoenix_Agreement_Name__c = 'test agreeent', Phoenix_Customer_Name__c = acc.Id);
		Phoenix_Terms_Matrix__c grandchildTermMatrix = new Phoenix_Terms_Matrix__c(Name = 'test matrix3', Phoenix_Agreement_Name__c = 'test agreeent', Phoenix_Customer_Name__c = acc.Id);
		termMatrixList.add(parentTermMatrix);
		termMatrixList.add(childTermMatrix);
		termMatrixList.add(grandchildTermMatrix);
		insert termMatrixList;
        List<Phoenix_Terms_Matrix__c> newtermMatrixList = [SELECT Id, Phoenix_Agreement_Name__c
		                                                   FROM Phoenix_Terms_Matrix__c
		                                                   WHERE Id = :termMatrixList];
		for (Phoenix_Terms_Matrix__c termMatrix : newtermMatrixList){
			termMatrix.Phoenix_Agreement_Name__c = 'updated agreement';
		}
		update newtermMatrixList;
		
         
         
		
    }


}