/*   Author      :  Mamatha Neela
Created Date:  15th April, 2021.
*/


public class Phoenix_NPR12MonthsSalesUnitRollup implements Database.Batchable<sObject>,Database.Stateful,Schedulable {
    public Phoenix_NPR12MonthsSalesUnitRollup() {
    }
    
    //schedule controller
    public void execute(SchedulableContext sc) {
        database.executeBatch(new Phoenix_NPR12MonthsSalesUnitRollup(),100);
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT'+ Phoenix_Util.nprDataFields+'FROM Phoenix_NPR_Data__c WHERE Phoenix_NPR_Status__c= \'Active\'';
        if(Test.isRunningTest()) query += ' Limit 1';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Phoenix_NPR_Data__c> nprData){
        List<Phoenix_NPR_Data__c> nprListData= new List<Phoenix_NPR_Data__c>();
        List<Phoenix_NPR_Volume__c> nprVolumeList= new List<Phoenix_NPR_Volume__c>();
        List<Date> dateList= new List<Date>();
        Map<Id,Phoenix_NPR_Data__c> nprMap= new Map<Id,Phoenix_NPR_Data__c>();
        date dateBefore;
        for (Phoenix_NPR_Data__c nprDataList : nprData){
            nprMap.put(nprDataList.Id,nprDataList);
        }
        for(Integer i=1;i<=12;i++){
            dateBefore=System.today().addMonths(-i).toStartOfMonth();
            dateList.add(dateBefore);
        }
        
        Map<Id,List<Phoenix_NPR_Volume__c>> nprVolMap =new Map<Id,List<Phoenix_NPR_Volume__c>>();
        Map<Product2,List<Phoenix_NPR_Data__c>> prodNPR= new Map<Product2,List<Phoenix_NPR_Data__c>>();
        for(Phoenix_NPR_Volume__c vol : [select id, Phoenix_Volume__c, Phoenix_NPR_Data__r.Phoenix_Dead_Net_Tracking_GR__c,Phoenix_NPR_Volume__c.Actual_Throughput__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_Throughput_Cost__c,Phoenix_NPR_Data__c,Phoenix_Dead_Net_Price__c from Phoenix_NPR_Volume__c where Phoenix_Date__c>=:dateList AND Phoenix_NPR_Data__c=:nprMap.keySet()]){
            
            System.debug('---------------vol--------'+vol);
            if(nprVolMap.containsKey(vol.Phoenix_NPR_Data__c)){
                List<Phoenix_NPR_Volume__c> existingNPRs = nprVolMap.get(vol.Phoenix_NPR_Data__c);
                existingNPRs.add(vol);
                nprVolMap.put(vol.Phoenix_NPR_Data__c,existingNPRs);
            }else{
                nprVolMap.put(vol.Phoenix_NPR_Data__c,new List<Phoenix_NPR_Volume__c>{vol}); 
            }
        }
        
        //NPR Volume Calculations
        List<Phoenix_NPR_Volume__c> nprVol=[select id,Phoenix_Volume__c,Phoenix_NPR_Volume__c.Actual_Throughput__c,Phoenix_Throughput_Cost__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_Throughput_cost__c,Phoenix_NPR_Data__c,Phoenix_NPR_Data__r.Phoenix_Dead_Net_Tracking_GR__c from Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__c=:nprMap.Values()];
        for(Phoenix_NPR_Volume__c npr1:nprVol){
            if(npr1.Phoenix_NPR_Data__r.Phoenix_Dead_Net_Tracking_GR__c!=null ){
                npr1.Phoenix_Dead_Net_Price__c=npr1.Phoenix_NPR_Data__r.Phoenix_Dead_Net_Tracking_GR__c; 
                if(npr1.Phoenix_Volume__c!=null)
                    npr1.Phoenix_Actual_Sales__c=npr1.Phoenix_Dead_Net_Price__c*npr1.Phoenix_Volume__c;
                if(npr1.Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_Throughput_cost__c!=null)
                    npr1.Phoenix_Throughput_Cost__c=npr1.Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_Throughput_cost__c;
                if(npr1.Phoenix_Throughput_Cost__c!=null && npr1.Phoenix_Volume__c!=null)
                    npr1.Actual_Throughput__c=(npr1.Phoenix_Dead_Net_Price__c.setscale(2)-npr1.Phoenix_Throughput_Cost__c.setscale(2))*npr1.Phoenix_Volume__c;
                if(npr1.Phoenix_Actual_Sales__c!=0 && npr1.Phoenix_Actual_Sales__c!=null && npr1.Actual_Throughput__c!=null)
                    npr1.Actual_Throughput_per__c=(npr1.Actual_Throughput__c/npr1.Phoenix_Actual_Sales__c)*100;  
            }
            nprVolumeList.add(npr1);
        }
        
        for(Id np:nprMap.keySet()){
            Double salesUnit=0;
            if(nprVolMap.get(np)!=null){
                for(Phoenix_NPR_Volume__c  nprVolList :nprVolMap.get(np)){
                    if(nprVolList.Phoenix_Volume__c!=null ){// Processing the NPR Data which has last 12 months volume records
                        System.debug('----------1-----------');  
                        salesUnit+=nprVolList.Phoenix_Volume__c;
                    }
                }    
            }
            
            Phoenix_NPR_Data__c updatedNPR = new Phoenix_NPR_Data__c(id=np,Phoenix_12Months_Actual_Sales_Unit__c=salesUnit);
            nprListData.add(updatedNPR);
        }
        
        if(!nprListData.isEmpty()){
            update nprListData;   
        }
        if(!nprVolumeList.isEmpty()){
            update nprVolumeList;   
        }
    }
    public void finish(Database.BatchableContext BC){
        
    }
}