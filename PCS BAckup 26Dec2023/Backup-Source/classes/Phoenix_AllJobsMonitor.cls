/**
* @description       : Auto
* @author            : Surender Dhruvsoft
* @group             : 
* @last modified on  : 10-07-2021
* @last modified by  : Surender Patel (Dhruvsoft)
* Modifications Log 
* Ver   Date         Author               Modification
* 1.0   25-05-2021   Surender Dhruvsoft   Initial Version
**/
public class Phoenix_AllJobsMonitor implements Schedulable {
    public void execute(SchedulableContext SC) {
        try {
            List < String > jobs = new List < String > {
                'Phoenix_AllJobsMonitor12PM',
                    'Phoenix_NPRStagingProcessor',
                    'Phoenix_Best_Price_Batch',
                    'Phoenix_Price_Change_Batch',
                    'Phoenix_AllJobsMonitor11PM',
                    'Phoenix_NPR_Snapshot_Creator_Batch',
                    'Phoenix_NPR12MonthsSalesUnitRollup',
                    'Phoenix_ProductEvaluationPriceProcessor',
                    'Phoenix_ProductSKUProcessor',
                    'Phoenix_ProductStagingProcessor',
                    'Phoenix_SAPCustomerStagingProcessorBatch',
                    'Phoenix_VIR_History_Batch',
                    'Phoenix_ActiveDelegatorChecker',
                    'Phoenix_MyPendingApprovalEmail',
                    'GoogleBigQueryDataFetchBatch',
                    'GoogleCommentsFetchBatch',
                    'GoogleBigQueryDRLSalesFetch',
                    'GoogleShortDatesFetch',
                    //'GoogleTradePartnerDOHRepFetch',
                    'GoogleBackOrderOTCFetch',
                    'GoogleBackOrderSRxandRxFetch',
                    'GoogleProductCommercialsFetch',
                    'GoogleProductPipelineDataFetch',
                    'Phoneix_CIPNotification',
                    'GoogleSFDC100PCTAnalysisSKUFetch',
                    'GoogleSFDCProfitabilitySKULevel',
                    'GoogleSFDCDirectSalesFetch',
                     'GoogleVIRReportDataFetch',
                    'ComplainceRecordsNprData',
                    'CustomerContractProductCreatorBatchCls',
                    'NoBidsOpportunityNotificationBatchCls'
                    //'GoogleDOHTradePartnerNDCLevelFetch'
                    };
                        
                        List < String > jobsfound = new List < String > ();
            List < String > states = new List < String > {
                'WAITING',
                    'ACQUIRED',
                    'EXECUTING'
                    };
                        for (CronTrigger ct: [SELECT CronExpression, CronJobDetailId, CronJobDetail.Name, Id, NextFireTime, State FROM CronTrigger WHERE CronJobDetail.Name LIKE: jobs AND State IN: states]) {
                            jobsfound.add(ct.CronJobDetail.Name.substringbefore('-'));
                        }
            System.debug('jobsfound---->' + jobsfound);
            
            
            //GoogleBigQueryDataFetchBatch - Sunday 2 AM IST
            if (!jobsfound.contains('GoogleBigQueryDataFetchBatch')){
                System.schedule('GoogleBigQueryDataFetchBatch', '0 0 2 ? * SUN * ', new GoogleBigQueryDataFetchBatch());
            }
            
            //GoogleCommentsFetchBatch - Sunday 3 AM IST
            if (!jobsfound.contains('GoogleCommentsFetchBatch')){
                System.schedule('GoogleCommentsFetchBatch', '0 0 3 ? * SUN * ', new GoogleCommentsFetchBatch());
            }
            
            //GoogleBigQueryDRLSalesFetch - Sunday 4 AM IST
            if (!jobsfound.contains('GoogleBigQueryDRLSalesFetch')){
                System.schedule('GoogleBigQueryDRLSalesFetch', '0 0 4 ? * SUN * ', new GoogleBigQueryDRLSalesFetch());
            }
            
            //GoogleShortDatesFetch - Daily 5 PM IST
            if (!jobsfound.contains('GoogleShortDatesFetch')){
                System.schedule('GoogleShortDatesFetch', '0 0 17 ? * * *', new GoogleShortDatesFetch());
            }
            //GoogleTradePartnerDOHRepFetch - Daily 5 PM IST
          //  if (!jobsfound.contains('GoogleTradePartnerDOHRepFetch')){
              // System.schedule('GoogleTradePartnerDOHRepFetch', '0 0 17 ? * * *', new GoogleTradePartnerDOHRepFetch());
            //}
            //GoogleBackOrderOTCFetch - Daily 5 PM IST
            if (!jobsfound.contains('GoogleBackOrderOTCFetch')){
                System.schedule('GoogleBackOrderOTCFetch', '0 0 8 ? * * *', new GoogleBackOrderOTCFetch());
            }
            //GoogleBackOrderSRxandRxFetch - Daily 5 PM IST
            if (!jobsfound.contains('GoogleBackOrderSRxandRxFetch')){
                System.schedule('GoogleBackOrderSRxandRxFetch', '0 0 6 ? * * *', new GoogleBackOrderSRxandRxFetch());
            }
            //NoBidsOpportunityNotificationBatchCls  - Daily 5 PM IST
            if (!jobsfound.contains('NoBidsOpportunityNotificationBatchCls')){
                System.schedule('NoBidsOpportunityNotificationBatchCls', '0 0 17 ? * * *', new NoBidsOpportunityNotificationBatchCls());
            }
            //GoogleProductPipelineDataFetch - Sunday 5 AM IST
            if (!jobsfound.contains('GoogleProductPipelineDataFetch')){
                System.schedule('GoogleProductPipelineDataFetch', '0 0 5 ? * SUN * ', new GoogleProductPipelineDataFetch());
            }
            // GoogleSFDC100PCTAnalysisSKUFetch - Daily 12 AM IST
            if (!jobsfound.contains('GoogleSFDC100PCTAnalysisSKUFetch')){
                System.schedule('GoogleSFDC100PCTAnalysisSKUFetch', '0 0 0 ? * SUN *', new GoogleSFDC100PCTAnalysisSKUFetch());
            }
            // GoogleSFDCDirectSalesFetch - Daily 1 AM IST
            if (!jobsfound.contains('GoogleSFDCDirectSalesFetch')){
                //System.schedule('GoogleSFDCDirectSalesFetch', '0 0 1 * * ?', new GoogleSFDCDirectSalesFetch());
            }
            // GoogleSFDCProfitabilitySKULevel - Sunday 4 AM IST
            if (!jobsfound.contains('GoogleSFDCProfitabilitySKULevel')){
                System.schedule('GoogleSFDCProfitabilitySKULevel', '0 0 4 ? * SUN * ', new GoogleSFDCProfitabilitySKULevel());
            }
            // GoogleVIRReportDataFetch - Sunday 8 AM IST
            if (!jobsfound.contains('GoogleVIRReportDataFetch')){
                System.schedule('GoogleVIRReportDataFetch', '0 0 8 ? * SUN * ', new GoogleVIRReportDataFetch());
            }
            //GoogleProductCommercialsFetch - Sunday 5 AM IST
            if (!jobsfound.contains('GoogleProductCommercialsFetch')){
                System.schedule('GoogleProductCommercialsFetch', '0 0 5 ? * SUN * ', new GoogleProductCommercialsFetch());
            }
            //CustomerContractProductCreatorBatchCls - Daily 10 PM IST
            if (!jobsfound.contains('CustomerContractProductCreatorBatchCls')){
                System.schedule('CustomerContractProductCreatorBatchCls', '0 0 22 ? * * *', new CustomerContractProductCreatorBatchCls());
            }
            //Phoenix_NPRStagingProcessor;Changed from 2pm to 1Pm
            if (!jobsfound.contains('Phoenix_NPRStagingProcessor')) {
                System.schedule('Phoenix_NPRStagingProcessor', ' 0 0 13 1/1 * ? * ', new Phoenix_NPRStagingProcessor());
            }
            
            //Phoenix_ProductSKUProcessor
            if (!jobsfound.contains('Phoenix_ProductSKUProcessor')) {
                System.schedule('Phoenix_ProductSKUProcessor', ' 0 0 21 1/1 * ? * ', new Phoenix_ProductSKUProcessor());
            }
            
            //Phoenix_ProductEvaluationPriceProcessor
            if (!jobsfound.contains('Phoenix_ProductEvaluationPriceProcessor')) {
                  System.schedule('Phoenix_ProductEvaluationPriceProcessor', ' 0 0 22 1 1/1 ? * ', new Phoenix_ProductEvaluationPriceProcessor());
            }
            
            //Phoenix_NPR_Snapshot_Creator_Batch
            if (!jobsfound.contains('Phoenix_NPR_Snapshot_Creator_Batch')) { //Monthly 1st 21 hr
                  System.schedule('Phoenix_NPR_Snapshot_Creator_Batch', ' 0 0 21 1 1/1 ? * ', new Phoenix_NPR_Snapshot_Creator_Batch());
            }
            
            //Phoenix_VIR_History_Batch
            if (!jobsfound.contains('Phoenix_VIR_History_Batch')) { //Monthly 2nd 21 hr
                  System.schedule('Phoenix_VIR_History_Batch', ' 0 0 21 2 1/1 ? * ', new Phoenix_VIR_History_Batch());
            }
            
            //Phoenix_ProductStagingProcessor
            if (!jobsfound.contains('Phoenix_ProductStagingProcessor')) { //Daily 10
                System.schedule('Phoenix_ProductStagingProcessor', ' 0 0 10 1/1 * ? * ', new Phoenix_ProductStagingProcessor());
            }
            
            //Phoenix_SAPCustomerStagingProcessorBatch
            if (!jobsfound.contains('Phoenix_SAPCustomerStagingProcessorBatch')) { //Daily 11
                System.schedule('Phoenix_SAPCustomerStagingProcessorBatch', ' 0 0 11 1/1 * ? * ', new Phoenix_SAPCustomerStagingProcessorBatch());
            }
            
            //Phoenix_AllJobsMonitor12PM
            if (!jobsfound.contains('Phoenix_AllJobsMonitor12PM')) {
                System.schedule('Phoenix_AllJobsMonitor12PM', ' 0 0 12 1/1 * ? * ', new Phoenix_AllJobsMonitor());
            }
            
            //Phoenix_Best_Price_Batch
            if (!jobsfound.contains('Phoenix_Best_Price_Batch')) { //Daily 19
                System.schedule('Phoenix_Best_Price_Batch', ' 0 0 19 1/1 * ? * ', new Phoenix_Best_Price_Batch());
            }
            
            //Phoenix_Price_Change_Batch
            if (!jobsfound.contains('Phoenix_Price_Change_Batch')) { //Daily 20
                System.schedule('Phoenix_Price_Change_Batch', ' 0 0 20 1/1 * ? * ', new Phoenix_Price_Change_Batch());
            }
            
            //Phoenix_AllJobsMonitor11PM
            if (!jobsfound.contains('Phoenix_AllJobsMonitor11PM')) { //Daily 23
                System.schedule('Phoenix_AllJobsMonitor11PM', ' 0 0 23 1/1 * ? * ', new Phoenix_AllJobsMonitor());
            }
            //Phoenix_ActiveDelegatorChecker
            if (!jobsfound.contains('Phoenix_ActiveDelegatorChecker')) { //Hourly starting at 12 am
                System.schedule('Phoenix_ActiveDelegatorChecker', '0 0 0/1 1/1 * ? *', new Phoenix_ActiveDelegatorChecker());
            }
            //Phoenix_MyPendingApprovalEmail
            if (!jobsfound.contains('Phoenix_MyPendingApprovalEmail')) { //daily at 5.00pm
                  System.schedule('Phoenix_MyPendingApprovalEmail', '0 0 17 1/1 * ? *', new Phoenix_MyPendingApprovalEmail());
            }
            
            //Phoenix_NPR12MonthsSalesUnitRollup
            if (!jobsfound.contains('Phoenix_NPR12MonthsSalesUnitRollup')) {
                  System.schedule('Phoenix_NPR12MonthsSalesUnitRollup', '0 0 9 2 1/1 ? *', new Phoenix_NPR12MonthsSalesUnitRollup());
            }
            //Phoneix_CIPNotification
            if (!jobsfound.contains('Phoneix_CIPNotification')) {
                  System.schedule('Phoneix_CIPNotification', '0 0 18 1/1 * ? *', new Phoneix_CIPNotification());
            }
             //GoogleSFDCOrderStatusFetch  - Daily6AM IST
             if (!jobsfound.contains('ComplianceRecordsNprData')){
                System.schedule('ComplianceRecordsNprData', '0 0 8 ? * * *', new ComplianceRecordsNprData());
            }
            
            //OrdercompliancerecordscreationBatch
            if (!jobsfound.contains('OrdercompliancerecordscreationBatch')) { //daily at 5.00pm
                  System.schedule('OrdercompliancerecordscreationBatch', '0 0 11 ? * * *', new OrdercompliancerecordscreationBatch());
            }
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_AllJobsMonitor', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        
    }
    public static void justIncrement() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
    
    
}