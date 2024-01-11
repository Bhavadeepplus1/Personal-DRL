public class Bright_Configuration {
    @AuraEnabled public static void startPhoenix_NPRDataActiveChecker(){
        
        Phoenix_NPRDataActiveChecker activeCheckerBatch = new Phoenix_NPRDataActiveChecker(); 
        activeCheckerBatch.execute(null);       
        // AsyncApexJob aaj = [SELECT Status FROM AsyncApexJob WHERE ApexClass.Name = 'Phoenix_AwardedQuantityProcessor'];
        // String batchStatus = aaj.Status;
          
    }
    @AuraEnabled public static Integer countOfNPR(){
        Integer activeNPRCount = [SELECT COUNT() FROM Phoenix_NPR_Data__c WHERE Phoenix_NPR_Status__c = 'Active'];
        system.debug('Count----'+activeNPRCount);
        return activeNPRCount;
    }
    @AuraEnabled public static Integer countOfNPRStagging(){
        Integer activeNPRStaggingCount = [SELECT COUNT() FROM Phoenix_SAP_NPR_Staging__c WHERE CreatedDate = Today AND Phoenix_NPR_Report_Type__c = 'Current Active'];
       
        return activeNPRStaggingCount;
    }
}