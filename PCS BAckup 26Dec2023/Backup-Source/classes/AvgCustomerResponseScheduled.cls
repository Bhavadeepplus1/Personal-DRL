/**
* @description       : This class contains Avg Customer Response Date & Internal Approval values map into another Object (Response Time).create the record every day at 12AM
* @author            : Ramakrishna Y
* @Created on        : 26-10-2021
* @last modified on  : 22-11-2021
* @last modified by  : Ramakrishna Y
**/
global class AvgCustomerResponseScheduled Implements Schedulable
    {
        global void execute(SchedulableContext sc)
        {
                try{
                getGrandTotal();
                }catch(Exception e)
                {
                }
               
        }

        public static Response_Time__c getGrandTotal()
        {
        
           String cr = Label.CustomerResponse;
           String ir = Label.InternalResponse;
           String wr = Label.WinRate;

            //Lisa Dashboard
            
           String crl = Label.CustomerResponseLisa;
           String irl = Label.InternalResponseLisa;
           String wrl = Label.WinRateLisa;
        
        
           //Josh Dashboard
            
           String crj = Label.CustomerResponseJosh;
           String irj = Label.InternalResponseJosh;
           String wrj = Label.WinRateJosh;
           
           //Jennifer Dashboard
            
           String crjn = Label.CustomerResponseJennifer;
           String irjn = Label.InternalResponseJennifer;
           String wrjn = Label.WinRateJennifer;
           
           //Tricia Dashboard
            
           String crt = Label.CustomerResponseTricia;
           String irt = Label.InternalResponseTricia;
           String wrt = Label.WinRateTricia;
        
        
        // Get the report ID       
        Reports.reportResults results = Reports.ReportManager.runReport(cr,true);
        Reports.reportResults results2 = Reports.ReportManager.runReport(ir,true);
        Reports.reportResults results3 = Reports.ReportManager.runReport(wr,true);
        
        //Get the report ID
        
        Reports.reportResults resultsl = Reports.ReportManager.runReport(crl,true);
        Reports.reportResults resultsl2 = Reports.ReportManager.runReport(irl,true);
        Reports.reportResults resultsl3 = Reports.ReportManager.runReport(wrl,true);
        
        //Get the report ID
        
        Reports.reportResults resultsj = Reports.ReportManager.runReport(crj,true);
        Reports.reportResults resultsj2 = Reports.ReportManager.runReport(irj,true);
        Reports.reportResults resultsj3 = Reports.ReportManager.runReport(wrj,true);
        
        //Get the report ID
        
        Reports.reportResults resultsjn = Reports.ReportManager.runReport(crjn,true);
        Reports.reportResults resultsjn2 = Reports.ReportManager.runReport(irjn,true);
        Reports.reportResults resultsjn3 = Reports.ReportManager.runReport(wrjn,true);
        
        
        // Get the report ID       
        Reports.reportResults resultst = Reports.ReportManager.runReport(crt,true);
        Reports.reportResults resultst2 = Reports.ReportManager.runReport(irt,true);
        Reports.reportResults resultst3 = Reports.ReportManager.runReport(wrt,true);

    
        //get the reports factmap fro the report ID and select the top level fact map - (https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_analytics_fact_map.htm)
        Reports.ReportFactWithDetails factDetails1 = (Reports.ReportFactWithDetails)results.getFactMap().get('T!T');
        Reports.ReportFactWithDetails factDetails2 = (Reports.ReportFactWithDetails)results2.getFactMap().get('T!T');
        Reports.ReportFactWithDetails factDetails3 = (Reports.ReportFactWithDetails)results3.getFactMap().get('T!T');
        
        //Lisa get the reports factmap fro the report ID and select the top level fact map - (https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_analytics_fact_map.htm)
        Reports.ReportFactWithDetails factDetailsl1 = (Reports.ReportFactWithDetails)resultsl.getFactMap().get('T!T');
        Reports.ReportFactWithDetails factDetailsl2 = (Reports.ReportFactWithDetails)resultsl2.getFactMap().get('T!T');
        Reports.ReportFactWithDetails factDetailsl3 = (Reports.ReportFactWithDetails)resultsl3.getFactMap().get('T!T');
        
        //Josh get the reports factmap fro the report ID and select the top level fact map - (https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_analytics_fact_map.htm)
        Reports.ReportFactWithDetails factDetailsj1 = (Reports.ReportFactWithDetails)resultsj.getFactMap().get('T!T');
        Reports.ReportFactWithDetails factDetailsj2 = (Reports.ReportFactWithDetails)resultsj2.getFactMap().get('T!T');
        Reports.ReportFactWithDetails factDetailsj3 = (Reports.ReportFactWithDetails)resultsj3.getFactMap().get('T!T');
        
        //Jennifer get the reports factmap fro the report ID and select the top level fact map - (https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_analytics_fact_map.htm)
        Reports.ReportFactWithDetails factDetailsjn1 = (Reports.ReportFactWithDetails)resultsjn.getFactMap().get('T!T');
        Reports.ReportFactWithDetails factDetailsjn2 = (Reports.ReportFactWithDetails)resultsjn2.getFactMap().get('T!T');
        Reports.ReportFactWithDetails factDetailsjn3 = (Reports.ReportFactWithDetails)resultsjn3.getFactMap().get('T!T');
        
        //Tricai get the reports factmap fro the report ID and select the top level fact map - (https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_analytics_fact_map.htm)
        Reports.ReportFactWithDetails factDetailst1 = (Reports.ReportFactWithDetails)resultst.getFactMap().get('T!T');
        Reports.ReportFactWithDetails factDetailst2 = (Reports.ReportFactWithDetails)resultst2.getFactMap().get('T!T');
        Reports.ReportFactWithDetails factDetailst3 = (Reports.ReportFactWithDetails)resultst3.getFactMap().get('T!T');
        

        //get the aggregate values in the report, this includes the RowCount (Grand Total) and any columns that have been summarized.
        List<Reports.SummaryValue> profileCounts = factDetails1.getAggregates();
        List<Reports.SummaryValue> profileCounts2 = factDetails2.getAggregates();
        List<Reports.SummaryValue> profileCounts3 = factDetails3.getAggregates();
        
        //Lisa get the aggregate values in the report, this includes the RowCount (Grand Total) and any columns that have been summarized.
        List<Reports.SummaryValue> profileCountsl = factDetailsl1.getAggregates();
        List<Reports.SummaryValue> profileCountsl2 = factDetailsl2.getAggregates();
        List<Reports.SummaryValue> profileCountsl3 = factDetailsl3.getAggregates();
        
        
        //Josh get the aggregate values in the report, this includes the RowCount (Grand Total) and any columns that have been summarized.
        List<Reports.SummaryValue> profileCountsj = factDetailsj1.getAggregates();
        List<Reports.SummaryValue> profileCountsj2 = factDetailsj2.getAggregates();
        List<Reports.SummaryValue> profileCountsj3 = factDetailsj3.getAggregates();
        
        //Jennifer get the aggregate values in the report, this includes the RowCount (Grand Total) and any columns that have been summarized.
        List<Reports.SummaryValue> profileCountsjn = factDetailsjn1.getAggregates();
        List<Reports.SummaryValue> profileCountsjn2 = factDetailsjn2.getAggregates();
        List<Reports.SummaryValue> profileCountsjn3 = factDetailsjn3.getAggregates();
        
         //Tricai get the aggregate values in the report, this includes the RowCount (Grand Total) and any columns that have been summarized.
        List<Reports.SummaryValue> profileCountst = factDetailst1.getAggregates();
        List<Reports.SummaryValue> profileCountst2 = factDetailst2.getAggregates();
        List<Reports.SummaryValue> profileCountst3 = factDetailst3.getAggregates();

        Decimal grandTotal;
        Decimal grandTotal2;
        Decimal grandTotal3;
        
        
        Decimal grandTotall;
        Decimal grandTotall2;
        Decimal grandTotall3;
        
        Decimal grandTotalj;
        Decimal grandTotalj2;
        Decimal grandTotalj3;
        
        Decimal grandTotaljn;
        Decimal grandTotaljn2;
        Decimal grandTotaljn3;
        
        Decimal grandTotalt;
        Decimal grandTotalt2;
        Decimal grandTotalt3;
        
        
        //The row count will be the last aggregate in the list, any summaries will come first and you can loop through them in the method below.
         
         if(profileCounts != null && profileCounts.size()>1 && profileCounts.get(profileCounts.size()-2) != null)
         {
            grandTotal =  (Decimal)profileCounts.get(profileCounts.size()-2).getValue();
         }
         if(profileCounts2 != null && profileCounts2.size()>0 && (Decimal)profileCounts2.get(profileCounts2.size()-2).getValue() != null)
         {
            grandTotal2 =  (Decimal)profileCounts2.get(profileCounts2.size()-2).getValue();
         }
         if(profileCounts3 != null && profileCounts3.size()>0 && (Decimal)profileCounts3.get(profileCounts3.size()-2).getValue() != null)
         {
            grandTotal3 =  (Decimal)profileCounts3.get(profileCounts3.size()-2).getValue();
         }
         
         
         //Lisa
         
         //The row count will be the last aggregate in the list, any summaries will come first and you can loop through them in the method below.
         
         if(profileCountsl != null && profileCountsl.size()>1 && profileCountsl.get(profileCountsl.size()-2) != null)
         {
            grandTotall =  (Decimal)profileCountsl.get(profileCountsl.size()-2).getValue();
         }
         if(profileCountsl2 != null && profileCountsl2.size()>0 && (Decimal)profileCountsl2.get(profileCountsl2.size()-2).getValue() != null)
         {
            grandTotall2 =  (Decimal)profileCountsl2.get(profileCountsl2.size()-2).getValue();
         }
         if(profileCountsl3 != null && profileCountsl3.size()>0 && (Decimal)profileCountsl3.get(profileCountsl3.size()-2).getValue() != null)
         {
            grandTotall3 =  (Decimal)profileCountsl3.get(profileCountsl3.size()-2).getValue();
         }
         
         
         //Josh
         
         //The row count will be the last aggregate in the list, any summaries will come first and you can loop through them in the method below.
         
         if(profileCountsj != null && profileCountsj.size()>1 && profileCountsj.get(profileCountsj.size()-2) != null)
         {
            grandTotalj =  (Decimal)profileCountsj.get(profileCountsj.size()-2).getValue();
         }
         if(profileCountsj2 != null && profileCountsj2.size()>0 && (Decimal)profileCountsj2.get(profileCountsj2.size()-2).getValue() != null)
         {
            grandTotalj2 =  (Decimal)profileCountsj2.get(profileCountsj2.size()-2).getValue();
         }
         if(profileCountsj3 != null && profileCountsj3.size()>0 && (Decimal)profileCountsj3.get(profileCountsj3.size()-2).getValue() != null)
         {
            grandTotalj3 =  (Decimal)profileCountsj3.get(profileCountsj3.size()-2).getValue();
         }
         
         //Jennifer
         
         //The row count will be the last aggregate in the list, any summaries will come first and you can loop through them in the method below.
         
         if(profileCountsjn != null && profileCountsjn.size()>1 && profileCountsjn.get(profileCountsjn.size()-2) != null)
         {
            grandTotaljn =  (Decimal)profileCountsjn.get(profileCountsjn.size()-2).getValue();
         }
         if(profileCountsjn2 != null && profileCountsjn2.size()>0 && (Decimal)profileCountsjn2.get(profileCountsjn2.size()-2).getValue() != null)
         {
            grandTotaljn2 =  (Decimal)profileCountsjn2.get(profileCountsjn2.size()-2).getValue();
         }
         if(profileCountsjn3 != null && profileCountsjn3.size()>0 && (Decimal)profileCountsjn3.get(profileCountsjn3.size()-2).getValue() != null)
         {
            grandTotaljn3 =  (Decimal)profileCountsjn3.get(profileCountsjn3.size()-2).getValue();
         }
         
         
         //Tricai
         
         //The row count will be the last aggregate in the list, any summaries will come first and you can loop through them in the method below.
         
         if(profileCountst != null && profileCountst.size()>1 && profileCountst.get(profileCountst.size()-2) != null)
         {
            grandTotalt =  (Decimal)profileCountst.get(profileCountst.size()-2).getValue();
         }
         if(profileCountst2 != null && profileCountst2.size()>0 && (Decimal)profileCountst2.get(profileCountst2.size()-2).getValue() != null)
         {
            grandTotalt2 =  (Decimal)profileCountst2.get(profileCountst2.size()-2).getValue();
         }
         if(profileCountst3 != null && profileCountst3.size()>0 && (Decimal)profileCountst3.get(profileCountst3.size()-2).getValue() != null)
         {
            grandTotalt3 =  (Decimal)profileCountst3.get(profileCountst3.size()-2).getValue();
         }
         
         
        Response_Time__c rt=new Response_Time__c();
        
        rt.Response_Date__c=System.today();
        
        if(grandTotal != null){
        rt.Avg_Customer_Response__c = grandTotal.setScale(2);}
        rt.Benchmark_1__c=10;
        if(grandTotal2 != null){
        rt.Avg_Internal_Approval__c = grandTotal2.setScale(2);}
        rt.Benchmark_2__c=5;
        if(grandTotal3 != null){
        rt.Win_Rate__c= grandTotal3.setScale(2);}
        rt.Benchmark_3__c=70;
        
        if(grandTotall != null){
        rt.Avg_Customer_Reponse_Lisa__c = grandTotall.setScale(2);}
        if(grandTotall2 != null){
        rt.Avg_Internal_Response_Lisa__c = grandTotall2.setScale(2);}
        if(grandTotall3 != null){
        rt.Win_Rate_Lisa__c = grandTotall3.setScale(2);}
        
        if(grandTotalj != null){
        rt.Avg_Customer_Reponse_Josh__c = grandTotalj.setScale(2);}
        if(grandTotalj2 != null){
        rt.Avg_Internal_Response_Josh__c = grandTotalj2.setScale(2);}
        if(grandTotalj3 != null){
        rt.Win_Rate_Josh__c = grandTotalj3.setScale(2);}
        
        
        if(grandTotaljn != null){
        rt.Avg_Customer_Response_Jennifer__c = grandTotaljn.setScale(2);}
        if(grandTotaljn2 != null){
        rt.Avg_Internal_Response_Jennifer__c = grandTotaljn2.setScale(2);}
        if(grandTotaljn3 != null){
        rt.Win_Rate_Jennifer__c = grandTotaljn3.setScale(2);}
        
        if(grandTotalt != null){
        rt.Avg_Customer_Response_Tricia__c = grandTotalt.setScale(2);}
        if(grandTotalt2 != null){
        rt.Avg_Internal_Response_Tricia__c = grandTotalt2.setScale(2);}
        if(grandTotalt3 != null){
        rt.Win_Rate_Tricia__c = grandTotalt3.setScale(2);}
        
        insert rt;

        System.debug('Record Id: ' + rt.Id); 
        System.debug('Record Avg_Customer_Response__c : ' + grandTotal); 
        System.debug('Record Avg_Internal_Approval__c : ' + grandTotal2);
        System.debug('Record Win_Rate__c : ' + grandTotal3);        
        
        System.debug('Record Benchmark 1: ' + rt.Benchmark_1__c);        
        System.debug('Record Benchmark 2: ' + rt.Benchmark_2__c);        
        System.debug('Record Benchmark 3: ' + rt.Benchmark_3__c);        

        return rt;

        }
        global void finish(Database.BatchableContext BC)
        {
        
        }
    }