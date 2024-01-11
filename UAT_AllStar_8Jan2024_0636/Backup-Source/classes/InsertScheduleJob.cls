/**
* @Description       : This class contains to get the all scheduled jobs created by Integration User.
* @Author            : Ramakrishna Y
* @Created on        : 20-06-2022
* @last modified by  : Ramakrishna Y
**/
global class InsertScheduleJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String uName = 'Amol Naresh';
        String aName = 'InsertScheduleJob';
        String jobtype = 'BatchApex';
        String query = 'select ApexClassId,ApexClass.Name,CompletedDate,CreatedById,CreatedBy.Name,CreatedDate,CronTriggerId,ExtendedStatus,Id,JobItemsProcessed,JobType,LastProcessed,LastProcessedOffset,MethodName,NumberOfErrors,ParentJobId,Status,TotalJobItems FROM AsyncApexJob WHERE CreatedDate = TODAY AND JobType =:jobtype AND ApexClass.Name != NULL AND CreatedBy.Name !=: uName AND ApexClass.Name !=: aName';        
        if(Test.isRunningTest()) query += ' LIMIT 10';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<AsyncApexJob> scope){
        
        map<string, AsyncApexJob> jobmap=new map<string,AsyncApexJob>(); 
        for(AsyncApexJob  a : scope) {
            jobmap.put(a.ApexClass.Name,a);
        }
        map<string,string> descmap=new map<string,string>();
        map<string,string> namemap=new map<string,string>();
        map<string,integer> countmap=new map<string,integer>();
        map<string,string> sourcemap=new map<string,string>();
        map<string,string> destnmap=new map<string,string>();
        map<string,string> usedmap=new map<string,string>();
        map<string,integer> totaljobbatchesmap=new map<string,integer>();
        
        map<string,string> startdatemap=new map<string,string>();
        map<string,string> compdatemap=new map<string,string>();
        
        List<AsyncApexJob> apexjobs = new List<AsyncApexJob>();
        List<AsyncApexJob> apexjobst = new List<AsyncApexJob>();

        namemap.put('Phoenix_NPRStagingProcessor','NPR Staging Data');
        descmap.put('Phoenix_NPRStagingProcessor','Process NPR staging records received TODAY.');
        sourcemap.put('Phoenix_NPRStagingProcessor','Vistex'); 
        destnmap.put('Phoenix_NPRStagingProcessor','Salesforce');
        usedmap.put('Phoenix_NPRStagingProcessor','Net Price Report');
        totaljobbatchesmap.put('Phoenix_NPRStagingProcessor',[select count() from AsyncApexJob where ApexClass.Name ='Phoenix_NPRStagingProcessor']);
       // compdatemap.put('Phoenix_NPRStagingProcessor',[select CompletedDate from AsyncApexJob where ApexClass.Name ='Phoenix_NPRStagingProcessor' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1]);
      
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='Phoenix_NPRStagingProcessor' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
        if(apexjobst.size() > 0) {
        for (AsyncApexJob zcst : apexjobst) {
            startdatemap.put('Phoenix_NPRStagingProcessor',String.ValueOf(zcst.CreatedDate));   
           } 
        }   
           
        apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='Phoenix_NPRStagingProcessor' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
        if(apexjobs.size() > 0) {
        for (AsyncApexJob zc : apexjobs) {
            compdatemap.put('Phoenix_NPRStagingProcessor',String.ValueOf(zc.CompletedDate));   
           } 
        }   
      
      
        namemap.put('GoogleSFDC100PCTAnalysisSKUFetch','100 % Analysis Data');
        descmap.put('GoogleSFDC100PCTAnalysisSKUFetch','To Fetch 100CTAnaylsis SKU data.');
        countmap.put('GoogleSFDC100PCTAnalysisSKUFetch',[select count() from GCP_SFDC_100pct_Analysis_SKU__c where lastmodifieddate=TODAY]);
        sourcemap.put('GoogleSFDC100PCTAnalysisSKUFetch','GCP'); 
        destnmap.put('GoogleSFDC100PCTAnalysisSKUFetch','Salesforce');
        usedmap.put('GoogleSFDC100PCTAnalysisSKUFetch','100% Analysis');  
        totaljobbatchesmap.put('GoogleSFDC100PCTAnalysisSKUFetch',[select count() from AsyncApexJob where ApexClass.Name ='GoogleSFDC100PCTAnalysisSKUFetch' AND createddate=TODAY]);

        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='GoogleSFDC100PCTAnalysisSKUFetch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
        if(apexjobst.size() > 0) {
        for (AsyncApexJob zcst : apexjobst) {
            startdatemap.put('GoogleSFDC100PCTAnalysisSKUFetch',String.ValueOf(zcst.CreatedDate));   
           } 
        }   
           
        apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='GoogleSFDC100PCTAnalysisSKUFetch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
        if(apexjobs.size() > 0) {
        for (AsyncApexJob zc : apexjobs) {
            compdatemap.put('GoogleSFDC100PCTAnalysisSKUFetch',String.ValueOf(zc.CompletedDate));   
           } 
        }  

        namemap.put('InsertScheduleJob','InsertScheduleJob');
        descmap.put('InsertScheduleJob','Fetech all the scheduled job.');
        sourcemap.put('InsertScheduleJob','Salesforce'); 
        destnmap.put('InsertScheduleJob','Salesforce');
        usedmap.put('InsertScheduleJob','It is INternal JOb');
        totaljobbatchesmap.put('InsertScheduleJob',[select count() from AsyncApexJob where ApexClass.Name ='InsertScheduleJob' AND createddate=TODAY]);
        

        namemap.put('Phoenix_FutureNPRStagingProcessor','Future NPR Staging Data');
        descmap.put('Phoenix_FutureNPRStagingProcessor','Future Active NPR staging processor will take future.');
        sourcemap.put('Phoenix_FutureNPRStagingProcessor','SAP'); 
        destnmap.put('Phoenix_FutureNPRStagingProcessor','Salesforce');
        usedmap.put('Phoenix_FutureNPRStagingProcessor','Product Master');
        totaljobbatchesmap.put('Phoenix_FutureNPRStagingProcessor',[select count() from AsyncApexJob where ApexClass.Name ='Phoenix_FutureNPRStagingProcessor' AND createddate=TODAY]);
  
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='Phoenix_FutureNPRStagingProcessor' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
            if(apexjobst.size() > 0) {
            for (AsyncApexJob zcst : apexjobst) {
                startdatemap.put('Phoenix_FutureNPRStagingProcessor',String.ValueOf(zcst.CreatedDate));   
               } 
            }   
               
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='Phoenix_FutureNPRStagingProcessor' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {
                compdatemap.put('Phoenix_FutureNPRStagingProcessor',String.ValueOf(zc.CompletedDate));   
               } 
            }  
            
        namemap.put('Phoenix_ProductStagingProcessor','Product Staging Data');
        descmap.put('Phoenix_ProductStagingProcessor','Process product staging records received TODAY.');
        sourcemap.put('Phoenix_ProductStagingProcessor','SAP'); 
        destnmap.put('Phoenix_ProductStagingProcessor','Salesforce');
        usedmap.put('Phoenix_ProductStagingProcessor','Product Master');
        totaljobbatchesmap.put('Phoenix_ProductStagingProcessor',[select count() from AsyncApexJob where ApexClass.Name ='Phoenix_ProductStagingProcessor' AND createddate=TODAY]);
  
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='Phoenix_ProductStagingProcessor' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
            if(apexjobst.size() > 0) {
            for (AsyncApexJob zcst : apexjobst) {
                startdatemap.put('Phoenix_ProductStagingProcessor',String.ValueOf(zcst.CreatedDate));   
               } 
            }   
               
        apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='Phoenix_ProductStagingProcessor' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
        if(apexjobs.size() > 0) {
        for (AsyncApexJob zc : apexjobs) {
            compdatemap.put('Phoenix_ProductStagingProcessor',String.ValueOf(zc.CompletedDate));   
           } 
        }  
        
        namemap.put('Phoenix_SAPCustomerStagingProcessorBatch','Customer Staging Data');
        descmap.put('Phoenix_SAPCustomerStagingProcessorBatch','Process customer staging records received TODAY.');
        sourcemap.put('Phoenix_SAPCustomerStagingProcessorBatch','SAP'); 
        destnmap.put('Phoenix_SAPCustomerStagingProcessorBatch','Salesforce');
        usedmap.put('Phoenix_SAPCustomerStagingProcessorBatch','Customer Master');
        totaljobbatchesmap.put('Phoenix_SAPCustomerStagingProcessorBatch',[select count() from AsyncApexJob where ApexClass.Name ='Phoenix_SAPCustomerStagingProcessorBatch' AND createddate=TODAY]);
        
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='Phoenix_SAPCustomerStagingProcessorBatch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
            if(apexjobst.size() > 0) {
            for (AsyncApexJob zcst : apexjobst) {
                startdatemap.put('Phoenix_SAPCustomerStagingProcessorBatch',String.ValueOf(zcst.CreatedDate));   
               } 
            }   
               
        apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='Phoenix_SAPCustomerStagingProcessorBatch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
        if(apexjobs.size() > 0) {
        for (AsyncApexJob zc : apexjobs) {
            compdatemap.put('Phoenix_SAPCustomerStagingProcessorBatch',String.ValueOf(zc.CompletedDate));   
           } 
        }  
  
        
        namemap.put('GoogleTradePartnerDOHRepFetch','Trade Partner DOH Data');
        descmap.put('GoogleTradePartnerDOHRepFetch','To Fetch Trade Partner Doh Records from GCP.');      
        countmap.put('GoogleTradePartnerDOHRepFetch',[select count() from GCP_Trade_Partner_DOH_Report__c where lastmodifieddate=TODAY]);
        sourcemap.put('GoogleTradePartnerDOHRepFetch','GCP'); 
        destnmap.put('GoogleTradePartnerDOHRepFetch','Salesforce');
        usedmap.put('GoogleTradePartnerDOHRepFetch','DOH Report');
        totaljobbatchesmap.put('GoogleTradePartnerDOHRepFetch',[select count() from AsyncApexJob where ApexClass.Name ='GoogleTradePartnerDOHRepFetch' AND createddate=TODAY]);
    
    
         apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='GoogleTradePartnerDOHRepFetch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                if(apexjobst.size() > 0) {
                for (AsyncApexJob zcst : apexjobst) {
                    startdatemap.put('GoogleTradePartnerDOHRepFetch',String.ValueOf(zcst.CreatedDate));   
                   } 
                }   
                   
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='GoogleTradePartnerDOHRepFetch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {
                compdatemap.put('GoogleTradePartnerDOHRepFetch',String.ValueOf(zc.CompletedDate));   
               } 
            }  
                
        namemap.put('GoogleBackOrderOTCFetch','Back Order OTC Data');
        descmap.put('GoogleBackOrderOTCFetch','To Fetch Backorder OTC Records From GCP.');       
        countmap.put('GoogleBackOrderOTCFetch',[select count() from Vision_GCP_Backorder_OTC__c where lastmodifieddate=TODAY]);
        sourcemap.put('GoogleBackOrderOTCFetch','GCP'); 
        destnmap.put('GoogleBackOrderOTCFetch','Salesforce');
        usedmap.put('GoogleBackOrderOTCFetch','OTC Backorder Report');
        totaljobbatchesmap.put('GoogleBackOrderOTCFetch',[select count() from AsyncApexJob where ApexClass.Name ='GoogleBackOrderOTCFetch' AND createddate=TODAY]);
        
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='GoogleBackOrderOTCFetch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
        if(apexjobst.size() > 0) {
        for (AsyncApexJob zcst : apexjobst) {
            startdatemap.put('GoogleBackOrderOTCFetch',String.ValueOf(zcst.CreatedDate));   
           } 
        }   
           
        apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='GoogleBackOrderOTCFetch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
        if(apexjobs.size() > 0) {
        for (AsyncApexJob zc : apexjobs) {
            compdatemap.put('GoogleBackOrderOTCFetch',String.ValueOf(zc.CompletedDate));   
           } 
        }   
        

        namemap.put('GoogleDOHTradePartnerNDCLevelFetch','Trade Partner NDC Data');
        descmap.put('GoogleDOHTradePartnerNDCLevelFetch','To Fetch DOH Trade Partner NDC  records from GCP.');
        countmap.put('GoogleDOHTradePartnerNDCLevelFetch',[select count() from GCP_DOH_Trade_Partner_NDC__c where lastmodifieddate=TODAY]);       
        sourcemap.put('GoogleDOHTradePartnerNDCLevelFetch','GCP'); 
        destnmap.put('GoogleDOHTradePartnerNDCLevelFetch','Salesforce');
        usedmap.put('GoogleDOHTradePartnerNDCLevelFetch','DOH Report');
        totaljobbatchesmap.put('GoogleDOHTradePartnerNDCLevelFetch',[select count() from AsyncApexJob where ApexClass.Name ='GoogleDOHTradePartnerNDCLevelFetch' AND createddate=TODAY]);
        
         apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='GoogleDOHTradePartnerNDCLevelFetch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                if(apexjobst.size() > 0) {
                for (AsyncApexJob zcst : apexjobst) {
                    startdatemap.put('GoogleDOHTradePartnerNDCLevelFetch',String.ValueOf(zcst.CreatedDate));   
                   } 
                }   
                   
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='GoogleDOHTradePartnerNDCLevelFetch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {
                compdatemap.put('GoogleDOHTradePartnerNDCLevelFetch',String.ValueOf(zc.CompletedDate));   
               } 
            }
  
        
        namemap.put('NoBidsOpportunityNotificationBatchCls','No Bids Opportunity Data');
        descmap.put('NoBidsOpportunityNotificationBatchCls','To Notify users when there is No Bid for Opportunity.');       
        countmap.put('NoBidsOpportunityNotificationBatchCls',[select count() from Product_Opportunity__c where lastmodifieddate=TODAY]);
        sourcemap.put('NoBidsOpportunityNotificationBatchCls','GCP'); 
        destnmap.put('NoBidsOpportunityNotificationBatchCls','Salesforce');
        usedmap.put('NoBidsOpportunityNotificationBatchCls','100% Analysis'); 
        totaljobbatchesmap.put('NoBidsOpportunityNotificationBatchCls',[select count() from AsyncApexJob where ApexClass.Name ='NoBidsOpportunityNotificationBatchCls' AND createddate=TODAY]);
 
          apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='NoBidsOpportunityNotificationBatchCls' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) {
                            startdatemap.put('NoBidsOpportunityNotificationBatchCls',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='NoBidsOpportunityNotificationBatchCls' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {
                compdatemap.put('NoBidsOpportunityNotificationBatchCls',String.ValueOf(zc.CompletedDate));   
               } 
            }
       
        namemap.put('GoogleBackOrderSRxandRxFetch','Back Order SRx and Rx Data');
        descmap.put('GoogleBackOrderSRxandRxFetch','To Fetch backorder SRX,RX records from GCP.');       
        countmap.put('GoogleBackOrderSRxandRxFetch',[select count() from Vision_GCP_Backorder_SRx_Rx__c where lastmodifieddate=TODAY]);
        sourcemap.put('GoogleBackOrderSRxandRxFetch','GCP'); 
        destnmap.put('GoogleBackOrderSRxandRxFetch','Salesforce');
        usedmap.put('GoogleBackOrderSRxandRxFetch','Backorder SRx and Rx Report'); 
        totaljobbatchesmap.put('GoogleBackOrderSRxandRxFetch',[select count() from AsyncApexJob where ApexClass.Name ='GoogleBackOrderSRxandRxFetch' AND createddate=TODAY]);
  
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='GoogleBackOrderSRxandRxFetch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) {
                            startdatemap.put('GoogleBackOrderSRxandRxFetch',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='GoogleBackOrderSRxandRxFetch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {
                compdatemap.put('GoogleBackOrderSRxandRxFetch',String.ValueOf(zc.CompletedDate));   
               } 
            }

        namemap.put('GoogleShortDatesFetch','Short Date Data');
        descmap.put('GoogleShortDatesFetch','To Fetch Short dates records from GCP.');       
        countmap.put('GoogleShortDatesFetch',[select count() from Vision_GCP_Short_Date__c where lastmodifieddate=TODAY]);
        sourcemap.put('GoogleShortDatesFetch','GCP'); 
        destnmap.put('GoogleShortDatesFetch','Salesforce');
        usedmap.put('GoogleShortDatesFetch','Short Dates Report');
        totaljobbatchesmap.put('GoogleShortDatesFetch',[select count() from AsyncApexJob where ApexClass.Name ='GoogleShortDatesFetch' AND createddate=TODAY]);
  
         apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='GoogleShortDatesFetch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) {
                            startdatemap.put('GoogleShortDatesFetch',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='GoogleShortDatesFetch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {
                compdatemap.put('GoogleShortDatesFetch',String.ValueOf(zc.CompletedDate));   
               } 
            }

        namemap.put('Phoenix_Best_Price_Batch','Best Price Data');
        descmap.put('Phoenix_Best_Price_Batch','Checks Best Price for products and if it is not equal to min of across all NPRs then updates the value.');       
        countmap.put('Phoenix_Best_Price_Batch',[select count() from Phoenix_NPR_Data__c where lastmodifieddate=TODAY]);
        sourcemap.put('Phoenix_Best_Price_Batch','Salesforce'); 
        destnmap.put('Phoenix_Best_Price_Batch','Salesforce');
        usedmap.put('Phoenix_Best_Price_Batch','To find the best price across all NPR');
        totaljobbatchesmap.put('Phoenix_Best_Price_Batch',[select count() from AsyncApexJob where ApexClass.Name ='Phoenix_Best_Price_Batch' AND createddate=TODAY]);
        
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='Phoenix_Best_Price_Batch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) {
                            startdatemap.put('Phoenix_Best_Price_Batch',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='Phoenix_Best_Price_Batch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {
                compdatemap.put('Phoenix_Best_Price_Batch',String.ValueOf(zc.CompletedDate));   
               } 
            }
        
        
        namemap.put('Phoenix_Price_Change_Batch','Price Change Data');
        descmap.put('Phoenix_Price_Change_Batch','Checks Tracking Customer price in products and if it is not equal to Net Price without fee in NPR updates the value.');
        countmap.put('Phoenix_Price_Change_Batch',[select count() from Phoenix_NPR_Data__c where lastmodifieddate=TODAY]);
        sourcemap.put('Phoenix_Price_Change_Batch','Salesforce'); 
        destnmap.put('Phoenix_Price_Change_Batch','Salesforce');
        usedmap.put('Phoenix_Price_Change_Batch','Price change for all NPR Data');
        totaljobbatchesmap.put('Phoenix_Price_Change_Batch',[select count() from AsyncApexJob where ApexClass.Name ='Phoenix_Price_Change_Batch' AND createddate=TODAY]);
  
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='Phoenix_Price_Change_Batch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) {
                            startdatemap.put('Phoenix_Price_Change_Batch',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='Phoenix_Price_Change_Batch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {
                compdatemap.put('Phoenix_Price_Change_Batch',String.ValueOf(zc.CompletedDate));   
               } 
            }
        
        namemap.put('Vision_DoH_Summary_Batch','DoH Summary Data');
        descmap.put('Vision_DoH_Summary_Batch','Internal Batch to for Product Totals.');
        sourcemap.put('Vision_DoH_Summary_Batch','GCP'); 
        destnmap.put('Vision_DoH_Summary_Batch','Salesforce');
        usedmap.put('Vision_DoH_Summary_Batch','DOH Report');
        totaljobbatchesmap.put('Vision_DoH_Summary_Batch',[select count() from AsyncApexJob where ApexClass.Name ='Vision_DoH_Summary_Batch' AND createddate=TODAY]);
  
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='Vision_DoH_Summary_Batch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) { startdatemap.put('Vision_DoH_Summary_Batch',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='Vision_DoH_Summary_Batch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {
                compdatemap.put('Vision_DoH_Summary_Batch',String.ValueOf(zc.CompletedDate));   
               } 
            }
               
        namemap.put('Compliance_RollUP_Batch','Compliance Data Summary Data');
        descmap.put('Compliance_RollUP_Batch','To create summary for complaince Data.');
        sourcemap.put('Compliance_RollUP_Batch','Salesforce'); 
        destnmap.put('Compliance_RollUP_Batch','Salesforce');
        usedmap.put('Compliance_RollUP_Batch','Complaince Report');
        totaljobbatchesmap.put('Compliance_RollUP_Batch',[select count() from AsyncApexJob where ApexClass.Name ='Compliance_RollUP_Batch' AND createddate=TODAY]);
  
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='Compliance_RollUP_Batch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) {
                            startdatemap.put('Compliance_RollUP_Batch',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='Compliance_RollUP_Batch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {
                compdatemap.put('Compliance_RollUP_Batch',String.ValueOf(zc.CompletedDate));   
               } 
            }
        
        namemap.put('complainceCTDFTDdata','Compliance Data (CTD,QTD,FTD)');
        descmap.put('complainceCTDFTDdata','To update CTD,QTD,FTD for complaince report.');
        sourcemap.put('complainceCTDFTDdata','Salesforce'); 
        destnmap.put('complainceCTDFTDdata','Salesforce');
        usedmap.put('complainceCTDFTDdata','Complaince Report');
        totaljobbatchesmap.put('complainceCTDFTDdata',[select count() from AsyncApexJob where ApexClass.Name ='complainceCTDFTDdata' AND createddate=TODAY]);
  
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='complainceCTDFTDdata' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) {
                            startdatemap.put('complainceCTDFTDdata',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='complainceCTDFTDdata' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {
                compdatemap.put('complainceCTDFTDdata',String.ValueOf(zc.CompletedDate));   
               } 
            }
        
        namemap.put('GoogleProductPipelineDataFetch','Product Pipeline Data');
        descmap.put('GoogleProductPipelineDataFetch','To fetch productpipeline data from GCP.');  
        countmap.put('GoogleProductPipelineDataFetch',[select count() from Product_Pipeline__c where lastmodifieddate=TODAY]);
        sourcemap.put('GoogleProductPipelineDataFetch','GCP'); 
        destnmap.put('GoogleProductPipelineDataFetch','Salesforce');
        usedmap.put('GoogleProductPipelineDataFetch','Product Pipeline');
        totaljobbatchesmap.put('GoogleProductPipelineDataFetch',[select count() from AsyncApexJob where ApexClass.Name ='GoogleProductPipelineDataFetch' AND createddate=TODAY]);
  
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='GoogleProductPipelineDataFetch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) {
                            startdatemap.put('GoogleProductPipelineDataFetch',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='GoogleProductPipelineDataFetch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {
                compdatemap.put('GoogleProductPipelineDataFetch',String.ValueOf(zc.CompletedDate));   
               } 
            }
              
        namemap.put('Phoenix_ProductSKUProcessor','Lowset Price Data');
        descmap.put('Phoenix_ProductSKUProcessor','To get Lowest Price/ SKU for a Product.');
        sourcemap.put('Phoenix_ProductSKUProcessor','Salesforce'); 
        destnmap.put('Phoenix_ProductSKUProcessor','Salesforce');
        usedmap.put('Phoenix_ProductSKUProcessor','Final Lowest Price across NPR');
        totaljobbatchesmap.put('Phoenix_ProductSKUProcessor',[select count() from AsyncApexJob where ApexClass.Name ='Phoenix_ProductSKUProcessor' AND createddate=TODAY]);
  
         apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='Phoenix_ProductSKUProcessor' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) { startdatemap.put('Phoenix_ProductSKUProcessor',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='Phoenix_ProductSKUProcessor' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {
                compdatemap.put('Phoenix_ProductSKUProcessor',String.ValueOf(zc.CompletedDate));   
              } 
            }
        
        namemap.put('GoogleBigQueryDataFetchBatch','GCP Opportunity Tracker Data');
        descmap.put('GoogleBigQueryDataFetchBatch','To Fetch 100% Anaylsis Data from GCP.');       
        countmap.put('GoogleBigQueryDataFetchBatch',[select count() from Phoenix_GCP_Opportunity_Tracker__c where lastmodifieddate=TODAY]);
        sourcemap.put('GoogleBigQueryDataFetchBatch','GCP'); 
        destnmap.put('GoogleBigQueryDataFetchBatch','Salesforce');
        usedmap.put('GoogleBigQueryDataFetchBatch','100% Analysis');
        totaljobbatchesmap.put('GoogleBigQueryDataFetchBatch',[select count() from AsyncApexJob where ApexClass.Name ='GoogleBigQueryDataFetchBatch' AND createddate=TODAY]);
        
         apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='GoogleBigQueryDataFetchBatch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) {
                            startdatemap.put('GoogleBigQueryDataFetchBatch',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='GoogleBigQueryDataFetchBatch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {
                compdatemap.put('GoogleBigQueryDataFetchBatch',String.ValueOf(zc.CompletedDate));   
              } 
            }

        namemap.put('GoogleCommentsFetchBatch','GCP Comments Data');
        descmap.put('GoogleCommentsFetchBatch','To Fetch GCP Comment from GCP.');       
        countmap.put('GoogleCommentsFetchBatch',[select count() from GCP_Comment__c where lastmodifieddate=TODAY]);
        sourcemap.put('GoogleCommentsFetchBatch','GCP'); 
        destnmap.put('GoogleCommentsFetchBatch','Salesforce');
        usedmap.put('GoogleCommentsFetchBatch','100 % Analysis to show tha panoroma comments');
        totaljobbatchesmap.put('GoogleCommentsFetchBatch',[select count() from AsyncApexJob where ApexClass.Name ='GoogleCommentsFetchBatch' AND createddate=TODAY]);
        
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='GoogleCommentsFetchBatch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) {
                            startdatemap.put('GoogleCommentsFetchBatch',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='GoogleCommentsFetchBatch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {
                compdatemap.put('GoogleCommentsFetchBatch',String.ValueOf(zc.CompletedDate));   
              } 
            }

        namemap.put('ComplainceRecordsNprData','Compliance Records Data');
        descmap.put('ComplainceRecordsNprData','To Create Compliance Records from NPR.'); 
        sourcemap.put('ComplainceRecordsNprData','Salesforce'); 
        destnmap.put('ComplainceRecordsNprData','Salesforce');
        usedmap.put('ComplainceRecordsNprData','Complaince report');
        totaljobbatchesmap.put('ComplainceRecordsNprData',[select count() from AsyncApexJob where ApexClass.Name ='ComplainceRecordsNprData' AND createddate=TODAY]);
        
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='ComplainceRecordsNprData' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) {
                            startdatemap.put('ComplainceRecordsNprData',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='ComplainceRecordsNprData' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {
                compdatemap.put('ComplainceRecordsNprData',String.ValueOf(zc.CompletedDate));   
              } 
            }

               
        namemap.put('GoogleNoOppProductsFetch','No Opportunity Products Data');
        descmap.put('GoogleNoOppProductsFetch','To Fetch NoOppProducts from GCP.');       
        countmap.put('GoogleNoOppProductsFetch',[select count() from Vision_Non_Opportunity_Products__c where lastmodifieddate=TODAY]);
        sourcemap.put('GoogleNoOppProductsFetch','GCP'); 
        destnmap.put('GoogleNoOppProductsFetch','Salesforce');
        usedmap.put('GoogleNoOppProductsFetch','TBD');
        totaljobbatchesmap.put('GoogleNoOppProductsFetch',[select count() from AsyncApexJob where ApexClass.Name ='GoogleNoOppProductsFetch' AND createddate=TODAY]);
        
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='GoogleNoOppProductsFetch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) { startdatemap.put('GoogleNoOppProductsFetch',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='GoogleNoOppProductsFetch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) { compdatemap.put('GoogleNoOppProductsFetch',String.ValueOf(zc.CompletedDate));   
              } 
            }
    
        namemap.put('GoogleProductCommercialsFetch','Product Commercial Data');
        descmap.put('GoogleProductCommercialsFetch','To Fetch ProductCommercials records from GCP.');        
        countmap.put('GoogleProductCommercialsFetch',[select count() from GCP_Product_Commercials__c where lastmodifieddate=TODAY]);
        sourcemap.put('GoogleProductCommercialsFetch','GCP'); 
        destnmap.put('GoogleProductCommercialsFetch','Salesforce');
        usedmap.put('GoogleProductCommercialsFetch','To fetch the GPI GCN fields info GVP');
        totaljobbatchesmap.put('GoogleProductCommercialsFetch',[select count() from AsyncApexJob where ApexClass.Name ='GoogleProductCommercialsFetch' AND createddate=TODAY]);
   
         apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='GoogleProductCommercialsFetch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) { startdatemap.put('GoogleProductCommercialsFetch',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='GoogleProductCommercialsFetch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) { compdatemap.put('GoogleProductCommercialsFetch',String.ValueOf(zc.CompletedDate));   
              } 
            } 
      
        namemap.put('GoogleSFDCProfitabilitySKULevel','SFDCProfitabilitySKULevel Data');
        descmap.put('GoogleSFDCProfitabilitySKULevel','To fetch SFDCProfitabilitySKULevel records from GCP.'); 
        countmap.put('GoogleSFDCProfitabilitySKULevel',[select count() from Vision_GCP_SFDC_Profitability_SKU_Level__c where lastmodifieddate=TODAY]);    
        sourcemap.put('GoogleSFDCProfitabilitySKULevel','GCP'); 
        destnmap.put('GoogleSFDCProfitabilitySKULevel','Salesforce');
        usedmap.put('GoogleSFDCProfitabilitySKULevel','Profitability data from GCP');
        totaljobbatchesmap.put('GoogleSFDCProfitabilitySKULevel',[select count() from AsyncApexJob where ApexClass.Name ='GoogleSFDCProfitabilitySKULevel' AND createddate=TODAY]);
    
         apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='GoogleSFDCProfitabilitySKULevel' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) { startdatemap.put('GoogleSFDCProfitabilitySKULevel',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='GoogleSFDCProfitabilitySKULevel' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) { compdatemap.put('GoogleSFDCProfitabilitySKULevel',String.ValueOf(zc.CompletedDate));   
              } 
            } 
        
        namemap.put('GoogleVIRReportDataFetch','VIR Data');
        descmap.put('GoogleVIRReportDataFetch','To fetch VIR Report Data from GCP.');       
        countmap.put('GoogleVIRReportDataFetch',[select count() from GCP_VIR_Report__c where lastmodifieddate=TODAY]);
        sourcemap.put('GoogleVIRReportDataFetch','GCP'); 
        destnmap.put('GoogleVIRReportDataFetch','Salesforce');
        usedmap.put('GoogleVIRReportDataFetch','VIR Report');
        totaljobbatchesmap.put('GoogleVIRReportDataFetch',[select count() from AsyncApexJob where ApexClass.Name ='GoogleVIRReportDataFetch' AND createddate=TODAY]);
  
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='GoogleVIRReportDataFetch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) { startdatemap.put('GoogleVIRReportDataFetch',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='GoogleVIRReportDataFetch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) { compdatemap.put('GoogleVIRReportDataFetch',String.ValueOf(zc.CompletedDate));   
              } 
            } 
       
        namemap.put('NPRBasedContractProductUpdateBatchCls','Contract Product Data');
        descmap.put('NPRBasedContractProductUpdateBatchCls','To update Contract and Product data based on the NPR Data.');
        sourcemap.put('NPRBasedContractProductUpdateBatchCls','Salesforce'); 
        destnmap.put('NPRBasedContractProductUpdateBatchCls','Salesforce');
        usedmap.put('NPRBasedContractProductUpdateBatchCls','To update CCPT data');
        totaljobbatchesmap.put('NPRBasedContractProductUpdateBatchCls',[select count() from AsyncApexJob where ApexClass.Name ='NPRBasedContractProductUpdateBatchCls' AND createddate=TODAY]);
   
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='NPRBasedContractProductUpdateBatchCls' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) {  startdatemap.put('NPRBasedContractProductUpdateBatchCls',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='NPRBasedContractProductUpdateBatchCls' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {  compdatemap.put('NPRBasedContractProductUpdateBatchCls',String.ValueOf(zc.CompletedDate));   
              } 
            } 

        namemap.put('AwardedQtyContractPrdStatusBatchCls','Awarded Qty Data');
        descmap.put('AwardedQtyContractPrdStatusBatchCls','To update awarded Qty Data customer response line level.');
        sourcemap.put('AwardedQtyContractPrdStatusBatchCls','Salesforce'); 
        destnmap.put('AwardedQtyContractPrdStatusBatchCls','Salesforce');
        usedmap.put('AwardedQtyContractPrdStatusBatchCls','TBD');
        totaljobbatchesmap.put('AwardedQtyContractPrdStatusBatchCls',[select count() from AsyncApexJob where ApexClass.Name ='AwardedQtyContractPrdStatusBatchCls' AND createddate=TODAY]);
    
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='AwardedQtyContractPrdStatusBatchCls' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) { startdatemap.put('AwardedQtyContractPrdStatusBatchCls',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='AwardedQtyContractPrdStatusBatchCls' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) { compdatemap.put('AwardedQtyContractPrdStatusBatchCls',String.ValueOf(zc.CompletedDate));   
              } 
            } 
        
        namemap.put('Phoenix_ProductEvaluationPriceProcessor','Product Evaluation Price Data');
        descmap.put('Phoenix_ProductEvaluationPriceProcessor','To get Opty Miss Evaluation Price for a Product .It is a batch process to update lowest Price at Product Level on monthly basis.Lowest price is the least value among the top 3 customers based on 12 Months Sales Unit.');     
        sourcemap.put('Phoenix_ProductEvaluationPriceProcessor','Salesforce'); 
        destnmap.put('Phoenix_ProductEvaluationPriceProcessor','Salesforce');
        usedmap.put('Phoenix_ProductEvaluationPriceProcessor','To find the evalution price on product');
        totaljobbatchesmap.put('Phoenix_ProductEvaluationPriceProcessor',[select count() from AsyncApexJob where ApexClass.Name ='Phoenix_ProductEvaluationPriceProcessor' AND createddate=TODAY]);
  
         apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='Phoenix_ProductEvaluationPriceProcessor' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) {  startdatemap.put('Phoenix_ProductEvaluationPriceProcessor',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='Phoenix_ProductEvaluationPriceProcessor' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) { compdatemap.put('Phoenix_ProductEvaluationPriceProcessor',String.ValueOf(zc.CompletedDate));   
              } 
            } 
          
        namemap.put('Phoenix_NPR_Snapshot_Creator_Batch','NPR Snapshot Data');
        descmap.put('Phoenix_NPR_Snapshot_Creator_Batch','To creates a copy of all NPR Records every month.');
        sourcemap.put('Phoenix_NPR_Snapshot_Creator_Batch','Salesforce'); 
        destnmap.put('Phoenix_NPR_Snapshot_Creator_Batch','Salesforce');
        usedmap.put('Phoenix_NPR_Snapshot_Creator_Batch','To create Snapshot records monthly');
        totaljobbatchesmap.put('Phoenix_NPR_Snapshot_Creator_Batch',[select count() from AsyncApexJob where ApexClass.Name ='Phoenix_NPR_Snapshot_Creator_Batch' AND createddate=TODAY]);
        
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='Phoenix_NPR_Snapshot_Creator_Batch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) { startdatemap.put('Phoenix_NPR_Snapshot_Creator_Batch',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='Phoenix_NPR_Snapshot_Creator_Batch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) { compdatemap.put('Phoenix_NPR_Snapshot_Creator_Batch',String.ValueOf(zc.CompletedDate));   
              } 
            } 
   
                
        namemap.put('Phoenix_NPR12MonthsSalesUnitRollup','NPR 12Month Sales Data');
        descmap.put('Phoenix_NPR12MonthsSalesUnitRollup','To calculate the sum of last 12 Months NPR Volume records for an NPR Data .');   
        sourcemap.put('Phoenix_NPR12MonthsSalesUnitRollup','Salesforce'); 
        destnmap.put('Phoenix_NPR12MonthsSalesUnitRollup','Salesforce');
        usedmap.put('Phoenix_NPR12MonthsSalesUnitRollup','To rollup 12 months sales');
        totaljobbatchesmap.put('Phoenix_NPR12MonthsSalesUnitRollup',[select count() from AsyncApexJob where ApexClass.Name ='Phoenix_NPR12MonthsSalesUnitRollup' AND createddate=TODAY]);
  
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='Phoenix_NPR12MonthsSalesUnitRollup' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) {
                            startdatemap.put('Phoenix_NPR12MonthsSalesUnitRollup',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='Phoenix_NPR12MonthsSalesUnitRollup' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {
                compdatemap.put('Phoenix_NPR12MonthsSalesUnitRollup',String.ValueOf(zc.CompletedDate));   
              } 
            } 
         
        namemap.put('Phoenix_VIR_History_Batch','VIR History Data');
        descmap.put('Phoenix_VIR_History_Batch','To create VIR Report History Data.');
        countmap.put('Phoenix_VIR_History_Batch',[select count() from Phoenix_VIR_History__c where lastmodifieddate=TODAY]);
        sourcemap.put('Phoenix_VIR_History_Batch','Salesforce'); 
        destnmap.put('Phoenix_VIR_History_Batch','Salesforce');
        usedmap.put('Phoenix_VIR_History_Batch','VIR History Report');
        totaljobbatchesmap.put('Phoenix_VIR_History_Batch',[select count() from AsyncApexJob where ApexClass.Name ='Phoenix_VIR_History_Batch' AND createddate=TODAY]);
  
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='Phoenix_VIR_History_Batch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) { startdatemap.put('Phoenix_VIR_History_Batch',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='Phoenix_VIR_History_Batch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) { compdatemap.put('Phoenix_VIR_History_Batch',String.ValueOf(zc.CompletedDate));   
              } 
            } 

        namemap.put('GoogleBigQueryDRLSalesFetch','DRL Sales Data');
        descmap.put('GoogleBigQueryDRLSalesFetch','To fetch the DRL Sales Data from GCP.');
        sourcemap.put('GoogleBigQueryDRLSalesFetch','Google'); 
        destnmap.put('GoogleBigQueryDRLSalesFetch','Salesforce');
        usedmap.put('GoogleBigQueryDRLSalesFetch','Net Sales Data');
        totaljobbatchesmap.put('GoogleBigQueryDRLSalesFetch',[select count() from AsyncApexJob where ApexClass.Name ='GoogleBigQueryDRLSalesFetch' AND createddate=TODAY]);
        
        apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='GoogleBigQueryDRLSalesFetch' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) { startdatemap.put('GoogleBigQueryDRLSalesFetch',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='GoogleBigQueryDRLSalesFetch' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {  compdatemap.put('GoogleBigQueryDRLSalesFetch',String.ValueOf(zc.CompletedDate));   
              } 
            } 
          
        
        namemap.put('DeleteRecordsBatchCls','Delete Records Data');
        descmap.put('DeleteRecordsBatchCls','To used to delete records which are large in number.'); 
        sourcemap.put('DeleteRecordsBatchCls','Salesforce'); 
        destnmap.put('DeleteRecordsBatchCls','Salesforce');
        usedmap.put('DeleteRecordsBatchCls','Delte the records');
        totaljobbatchesmap.put('DeleteRecordsBatchCls',[select count() from AsyncApexJob where ApexClass.Name ='DeleteRecordsBatchCls' AND createddate=TODAY]);
         
         apexjobst  =[select CreatedDate from AsyncApexJob where ApexClass.Name ='DeleteRecordsBatchCls' AND CreatedDate=TODAY ORDER BY CreatedDate ASC limit 1];
                        if(apexjobst.size() > 0) {
                        for (AsyncApexJob zcst : apexjobst) { startdatemap.put('DeleteRecordsBatchCls',String.ValueOf(zcst.CreatedDate));   
                           } 
                        }   
                           
            apexjobs  =[select CompletedDate from AsyncApexJob where ApexClass.Name ='DeleteRecordsBatchCls' AND CompletedDate=TODAY ORDER BY CompletedDate DESC limit 1];
            if(apexjobs.size() > 0) {
            for (AsyncApexJob zc : apexjobs) {
                compdatemap.put('DeleteRecordsBatchCls',String.ValueOf(zc.CompletedDate));   
              } 
            }       
                      
        List<Job_Calendar__c> jcList = new List<Job_Calendar__c>();
        for(AsyncApexJob  a : jobmap.values()) {
            
            //set your schedule job values here
            Job_Calendar__c jc = new Job_Calendar__c();
           // String strclassname = a.ApexClass.Name;
            //String apxName= str.replace('',a.ApexClass.Name);
            
            jc.ApexClass_Name__c = a.ApexClass.Name;
            jc.Job_Description__c = descmap.get(a.ApexClass.Name);
            jc.Job_Name__c=namemap.get(a.ApexClass.Name);         
            jc.JobType__c=a.JobType;
            //jc.CreatedDate__c=a.CreatedDate;
            //jc.CompletedDate__c=a.CompletedDate;
            
            if(totaljobbatchesmap.containskey(a.ApexClass.Name))
            {
            jc.CreatedDate__c=Datetime.valueof(startdatemap.get(a.ApexClass.Name));
            }
            if(compdatemap.containskey(a.ApexClass.Name)) {
            jc.CompletedDate__c=Datetime.valueof(compdatemap.get(a.ApexClass.Name));
            }
            if(startdatemap.containskey(a.ApexClass.Name)){
            jc.Job_Start_Date__c=Datetime.valueof(startdatemap.get(a.ApexClass.Name)).format('MMMMM dd, yyyy hh:mm a');
            }
            if(compdatemap.containskey(a.ApexClass.Name)) {
            jc.Job_Completed_Date__c=Datetime.valueof(compdatemap.get(a.ApexClass.Name)).format('MMMMM dd, yyyy hh:mm a');
            } 
            jc.JobItemsProcessed__c=a.JobItemsProcessed;
            jc.TotalJobItems__c=a.TotalJobItems;
            
            if(countmap.containskey(a.ApexClass.Name))
            {
            jc.JobItemsProcessed__c=integer.valueof(countmap.get(a.ApexClass.Name));
            jc.TotalJobItems__c=integer.valueof(countmap.get(a.ApexClass.Name));
            jc.totaljobbatches__c=integer.valueof(totaljobbatchesmap.get(a.ApexClass.Name));   
            }         
            jc.Status__c=a.Status;
            jc.Job_Run_By__c=a.CreatedById;
            
            jc.Job_Source__c=sourcemap.get(a.ApexClass.Name);
            jc.Job_Destination__c=destnmap.get(a.ApexClass.Name);
            jc.Job_Used_For__c=usedmap.get(a.ApexClass.Name);
            jc.totaljobbatches__c=integer.valueof(totaljobbatchesmap.get(a.ApexClass.Name));
            
            
            jc.Unique_Identifier__c = a.ApexClass.Name+' '+Date.valueOf(a.CreatedDate);
            jcList.add(jc); 
        } 
                Database.UpsertResult[] results = Database.upsert(jcList, Job_Calendar__c.Unique_Identifier__c);
                for(Integer i = 0; i< results.size(); i++) {
                    if(results[i].isSuccess()) {
                        if(results[i].isCreated()) {
                            System.debug(jcList[i].Unique_Identifier__c +' was created');
                        } else {
                            System.debug(jcList[i].Unique_Identifier__c +' was updated');
                        }
                    }
                }
            //upsert jcList;
            //system.debug('------any errors----'+ jcList);
    }
    
    global void finish(Database.BatchableContext BC){
if(!Test.isRunningTest())System.scheduleBatch(new InsertScheduleJob(), 'InsertScheduleJob', 5);
        

        
    }
}