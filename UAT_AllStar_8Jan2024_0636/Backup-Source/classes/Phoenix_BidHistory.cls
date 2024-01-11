/*

Created by      :      Mamatha Neela (Dhruvsoft)
Last Updated on :      12-05-2021
Purpose         :      This is to handle the Analytics Components

*/

public class Phoenix_BidHistory {
    public class Wrapper{
        
        @AuraEnabled public Phoenix_Bid__c bidRecord ;
        @AuraEnabled public Product2 prdlist{ get; set; }
        @AuraEnabled public Phoenix_NPR_Data__c nprRec{ get; set; }
        @AuraEnabled public string custResponse{ get; set; }
        @AuraEnabled public string bidName{ get; set; }
        @AuraEnabled public string accName{ get; set; }
        @AuraEnabled public Id accId{ get; set; }
        @AuraEnabled public string prodName{ get; set; }
        @AuraEnabled public string ndc{ get; set; }
        @AuraEnabled public string bidId{ get; set; }
        @AuraEnabled public string bidIds{ get; set; }
        @AuraEnabled public string bidNames{ get; set; }
        @AuraEnabled public string prodId{ get; set; }
        @AuraEnabled public string bidType{ get; set; }
        @AuraEnabled public string bidStatus{ get; set; }
        @AuraEnabled public decimal guidancePrice{ get; set; }
        @AuraEnabled public decimal contrPrice{ get; set; }
        @AuraEnabled public decimal internalDeadPrice{ get; set; }
        @AuraEnabled public Phoenix_Bid_Line_Item__c qlItem{ get; set; }
        @AuraEnabled public String contrName{ get; set; }
        @AuraEnabled public Id contrId{ get; set; }
        @AuraEnabled public List<Phoenix_NPR_Data_History__c> nprHistory{ get; set; }
        @AuraEnabled public String dateProcessed{ get; set; }
        @AuraEnabled public string deadNetPrev{ get; set; }
        @AuraEnabled public string deadNetNew{ get; set;}
        @AuraEnabled public decimal overallMark{ get; set;}
        @AuraEnabled public decimal drlMarkShare{ get; set;}
        @AuraEnabled public List<String> pickListOptions{ get; set;}
        @AuraEnabled public List<String> pickListOptionsStatus{ get; set;}
        @AuraEnabled public List<String> pickListOptionsCustResp{ get; set;}
        @AuraEnabled public List<String> pickListOptionsNPRHist{ get; set;}
        @AuraEnabled public decimal doses{ get; set;}
        @AuraEnabled public string nprHistCheck{ get; set;}
        @AuraEnabled public Map<String,Decimal> nprVolMap{ get; set;}
        @AuraEnabled public Map<String,Decimal> nprSnapCurrent{ get; set;}
        @AuraEnabled public Map<String,Decimal> nprSnapAll{ get; set;}
        @AuraEnabled public Map<String,Decimal> nprSnapBucket{ get; set;}
        @AuraEnabled public string bucketCust{ get; set;}
        @AuraEnabled public Decimal custVol{ get; set;}
        @AuraEnabled public Decimal tptPercent{ get; set;}
        @AuraEnabled public Decimal netSales{ get; set;}
        @AuraEnabled public Decimal tptDollar{ get; set;}
        @AuraEnabled public Decimal volume{ get; set;}
        @AuraEnabled public Decimal twelveMtsSales{ get; set;}
        @AuraEnabled public String histFieldName{ get; set;}
    }
    
    // This method is to retrieve the Bid History---START 
    
    @AuraEnabled 
    public static List<Wrapper> getBidHistory(String LineItemId, String recordId, string bidType , String bidAppStatus ,String bidCustResp ){
        List<String> custRespTempList= new List<String>();
        if(bidCustResp =='--None--' || bidCustResp ==''){
            custRespTempList.add(null);
        }
        
        List<String> typesList= new List<String>();
        List<String> bidtypesList= new List<String>();
        List<String> bidAppsList= new List<String>();
        List<String> bidCustRespList= new List<String>();
        List<Phoenix_Bid__c> bidRecList = new List<Phoenix_Bid__c>();
        Set<String> typeList = new Set<String>();
        Set<String> bidStatusSet = new Set<String>();
        Set<String> bidCustRespSet = new Set<String>();
        
        List<String> listStrings = new List<String>();
        List<String> bidStatusList = new List<String>();
        List<String> bidCustRespList1 = new List<String>();
        typesList.add(bidType);
        bidAppsList.add(bidAppStatus);
        bidCustRespList.add(bidCustResp);
        if(bidCustResp =='--None--' || bidCustResp ==''){
            custRespTempList.add('Awarded');
            custRespTempList.add('');
            custRespTempList.add('Declined by Customer');
            custRespTempList.add('Pending');
            custRespTempList.add('DRL Rescinded');
            custRespTempList.add('DRL submitting under New Bid Number');
        }
        else if(bidCustResp =='Won'){
            custRespTempList.add('Awarded');   
        }
        else if(bidCustResp =='Rejected by Customer'){
            custRespTempList.add('Declined by Customer');
            
        }
        else if(bidCustResp =='Pending'){
            if(bidAppStatus=='Customer\'s Update'|| bidAppStatus=='Vistex Update'|| bidAppStatus=='Closed')
            {
                custRespTempList.add('');     
            }
            else   if((bidAppStatus=='--None--'|| bidAppStatus=='') && (bidType=='' || bidType=='--None--'))
            {
                bidAppStatus='test';
                bidAppsList.clear();
                bidAppsList.add('Customer\'s Update');
                bidAppsList.add('Vistex Update');
                bidAppsList.add('Closed');
                custRespTempList.add('');     
            }
            else{
                
            }
            
        }
        else if(bidCustResp =='Pending')
        {
            if((bidAppStatus=='--None--'|| bidAppStatus=='') && (bidType=='' || bidType=='--None--'))
        {
            bidAppStatus='test';
            //   bidAppsList.clear();
            bidAppsList.add('Customer\'s Update');
            bidAppsList.add('Vistex Update');
            bidAppsList.add('Closed');
            custRespTempList.add('');     
        }
                                         
                                        }
        else{
            custRespTempList.add('DRL Rescinded');
            custRespTempList.add('DRL submitting under New Bid Number');  
            
        }
        
        Map<Phoenix_Bid__c,List<Phoenix_Bid_Line_Item__c>> bidWithLines= new Map<Phoenix_Bid__c,List<Phoenix_Bid_Line_Item__c>>();
        Phoenix_Bid_Line_Item__c bidItem=[select Phoenix_Bid__c,Phoenix_Bid__r.Name,Phoenix_Bid_Status__c,Phoenix_Final_Approvd_Pricing_Contracts__c,Phoenix_Final_Total_Selling_Unit__c,Phoenix_Internal_Dead_Net_Price__c,Phoenix_Guidance_Price__c,Phoenix_Product__c from Phoenix_Bid_Line_Item__c where Id=:LineItemId];
        Product2 prod=[select Id, Name, Phoenix_NDC_11__c from Product2 where Id=:bidItem.Phoenix_Product__c LIMIT 1];
        Phoenix_Bid__c bid=[select Id, Phoenix_Customer__c,Phoenix_Customer__r.Name from Phoenix_Bid__c where Id=:recordId];
        
        List<Phoenix_Bid__c> bidRecList1=[select Id, Phoenix_Customer__r.Name,Name,CreatedDate,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(select id,Phoenix_Final_Total_Selling_Unit__c,Phoenix_Th_Put_Margin__c,Phoenix_Net_Sales_Internal__c,Phoenix_Product__c,Phoenix_TP_Margin__c,Phoenix_Final_Approvd_Pricing_Contracts__c,Phoenix_Guidance_Price__c,Phoenix_Internal_Dead_Net_Price__c,Phoenix_Product__r.Name,Phoenix_NDC_Without_Dashes__c,Phoenix_Bid_Status__c from Bid_Line_Items__r WHERE Phoenix_Product__c=:bidItem.Phoenix_Product__c), 
                                          Phoenix_Customer__c from Phoenix_Bid__c where Phoenix_Customer__c=:bid.Phoenix_Customer__c AND Id!=:recordId ORDER BY Name];
        typeList.add('--None--');
        bidStatusSet.add('--None--');
        bidCustRespSet.add('--None--');
        String custRespStore;
        for(Phoenix_Bid__c bids:bidRecList1){
            if(!(bids.Bid_Line_Items__r).isEmpty() ){
                String bidWork=bids.Phoenix_Bid_Type__c;
                String bidStatus=bids.Phoenix_Approval_Status__c;
                typeList.add(bidWork);
                bidStatusSet.add(bidStatus);
                
                if(bids.Bid_Line_Items__r[0].Phoenix_Bid_Status__c=='Awarded'){custRespStore='Won';  
                                                                              }
                else if(bids.Bid_Line_Items__r[0].Phoenix_Bid_Status__c=='Pending' || bids.Bid_Line_Items__r[0].Phoenix_Bid_Status__c==null){custRespStore='Pending';  
                                                                                                                                            }
                else if(bids.Bid_Line_Items__r[0].Phoenix_Bid_Status__c=='Declined by Customer'){custRespStore='Rejected by Customer';  }else{custRespStore='Lost';    }
                bidCustRespSet.add(custRespStore);
                
            }
        }
        
        if((bidAppStatus=='--None--' || bidAppStatus=='') && (bidType=='--None--' || bidType=='')){
            
            bidRecList=[select Id, Phoenix_Customer__r.Name,Name,CreatedDate,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(select id,Phoenix_Th_Put_Margin__c,Phoenix_Final_Total_Selling_Unit__c,Phoenix_Product__c,Phoenix_TP_Margin__c,Phoenix_Net_Sales_Internal__c,Phoenix_Final_Approvd_Pricing_Contracts__c,Phoenix_Guidance_Price__c,Phoenix_Internal_Dead_Net_Price__c,Phoenix_Product__r.Name,Phoenix_NDC_Without_Dashes__c,Phoenix_Bid_Status__c from Bid_Line_Items__r WHERE Phoenix_Product__c=:bidItem.Phoenix_Product__c AND Phoenix_Bid_Status__c=:custRespTempList),
                        Phoenix_Customer__c from Phoenix_Bid__c where Phoenix_Customer__c=:bid.Phoenix_Customer__c AND Id!=:recordId ORDER BY Name];
        }
        else if((bidAppStatus!='--None--' || bidAppStatus!='') && (bidType=='--None--' || bidType=='')){
            bidRecList=[select Id, Phoenix_Customer__r.Name,Name,CreatedDate,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(select id,Phoenix_Th_Put_Margin__c,Phoenix_Final_Total_Selling_Unit__c,Phoenix_Product__c,Phoenix_Net_Sales_Internal__c,Phoenix_TP_Margin__c,Phoenix_Final_Approvd_Pricing_Contracts__c,Phoenix_Guidance_Price__c,Phoenix_Internal_Dead_Net_Price__c,Phoenix_Product__r.Name,Phoenix_NDC_Without_Dashes__c,Phoenix_Bid_Status__c from Bid_Line_Items__r WHERE Phoenix_Product__c=:bidItem.Phoenix_Product__c AND Phoenix_Bid_Status__c=:custRespTempList), 
                        Phoenix_Customer__c from Phoenix_Bid__c where Phoenix_Customer__c=:bid.Phoenix_Customer__c AND Phoenix_Approval_Status__c=:bidAppsList AND Id!=:recordId ORDER BY Name];
        }
        else if((bidAppStatus=='--None--' || bidAppStatus=='') && (bidType!='--None--' || bidType!='')){
            bidRecList=[select Id, Phoenix_Customer__r.Name,Name,CreatedDate,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(select id,Phoenix_Th_Put_Margin__c,Phoenix_Final_Total_Selling_Unit__c,Phoenix_Product__c,Phoenix_Net_Sales_Internal__c,Phoenix_TP_Margin__c,Phoenix_Final_Approvd_Pricing_Contracts__c,Phoenix_Guidance_Price__c,Phoenix_Internal_Dead_Net_Price__c,Phoenix_Product__r.Name,Phoenix_NDC_Without_Dashes__c,Phoenix_Bid_Status__c from Bid_Line_Items__r WHERE Phoenix_Product__c=:bidItem.Phoenix_Product__c AND Phoenix_Bid_Status__c=:custRespTempList), 
                        Phoenix_Customer__c from Phoenix_Bid__c where Phoenix_Customer__c=:bid.Phoenix_Customer__c AND Phoenix_Bid_Type__c=:typesList AND Id!=:recordId ORDER BY Name];
        }
        
        else{
            bidRecList=[select Id, Phoenix_Customer__r.Name,Name,CreatedDate,Phoenix_Bid_Type__c,Phoenix_Approval_Status__c,(select id,Phoenix_Th_Put_Margin__c,Phoenix_Final_Total_Selling_Unit__c,Phoenix_Product__c,Phoenix_Net_Sales_Internal__c,Phoenix_TP_Margin__c,Phoenix_Final_Approvd_Pricing_Contracts__c,Phoenix_Guidance_Price__c,Phoenix_Internal_Dead_Net_Price__c,Phoenix_Product__r.Name,Phoenix_NDC_Without_Dashes__c,Phoenix_Bid_Status__c from Bid_Line_Items__r WHERE Phoenix_Product__c=:bidItem.Phoenix_Product__c AND Phoenix_Bid_Status__c=:custRespTempList), 
                        Phoenix_Customer__c from Phoenix_Bid__c where Phoenix_Customer__c=:bid.Phoenix_Customer__c AND 
                        Phoenix_Bid_Type__c=:typesList AND Phoenix_Approval_Status__c=:bidAppsList AND Id!=:recordId ORDER BY Name];
        }
        
        listStrings = new List<String>(typeList);
        bidStatusList = new List<String>(bidStatusSet);
        bidCustRespList1 = new List<String>(bidCustRespSet);
        listStrings.sort();
        bidStatusList.sort();
        bidCustRespList1.sort();
        
        List<Wrapper> wrapList= new List<Wrapper>();
        List<Wrapper> wrapList1= new List<Wrapper>();
        Integer i=0;
        for(Phoenix_Bid__c bids:bidRecList){
            
            if(!(bids.Bid_Line_Items__r).isEmpty() ){
                i=i+1;
                Wrapper wrap= new Wrapper();
                wrap.bidType=bids.Phoenix_Bid_Type__c;
                wrap.prodId=prod.Id;
                wrap.prodName=prod.Name;
                wrap.pickListOptions=listStrings;
                wrap.pickListOptionsStatus=bidStatusList;
                wrap.pickListOptionsCustResp=bidCustRespList1;
                wrap.nprHistCheck='yesHist';
                wrap.ndc=prod.Phoenix_NDC_11__c;
                wrap.bidId=bidItem.Phoenix_Bid__c;
                wrap.bidName=bidItem.Phoenix_Bid__r.Name;
                wrap.bidIds=bids.Id;
                wrap.accId=bid.Phoenix_Customer__c;
                wrap.accName=bid.Phoenix_Customer__r.Name;
                wrap.bidNames=bids.Name;
                if(bids!= null){
                    wrap.bidRecord=bids;
                }
                wrap.bidStatus=bids.Phoenix_Approval_Status__c;
                wrap.qlItem=bids.Bid_Line_Items__r[0];
                Datetime dt3 = bids.CreatedDate; 
                String bidCreatedDt = dt3.format('MM/dd/yyyy');
                wrap.dateProcessed=bidCreatedDt;
                wrap.guidancePrice=bids.Bid_Line_Items__r[0].Phoenix_Guidance_Price__c;
                wrap.contrPrice=bids.Bid_Line_Items__r[0].Phoenix_Final_Approvd_Pricing_Contracts__c;
                wrap.internalDeadPrice=bids.Bid_Line_Items__r[0].Phoenix_Internal_Dead_Net_Price__c;
                wrap.tptPercent=bids.Bid_Line_Items__r[0].Phoenix_TP_Margin__c;
                wrap.netSales=bids.Bid_Line_Items__r[0].Phoenix_Net_Sales_Internal__c;
                wrap.tptDollar=bids.Bid_Line_Items__r[0].Phoenix_Th_Put_Margin__c;
                wrap.volume=bids.Bid_Line_Items__r[0].Phoenix_Final_Total_Selling_Unit__c;
                if(bids.Bid_Line_Items__r[0].Phoenix_Bid_Status__c=='Awarded'){wrap.custResponse='Won';  
                                                                              }
                else if(bids.Bid_Line_Items__r[0].Phoenix_Bid_Status__c=='Pending'){wrap.custResponse='Pending';  
                                                                                   }
                else if(bids.Bid_Line_Items__r[0].Phoenix_Bid_Status__c=='Declined by Customer'){wrap.custResponse='Rejected by Customer';  
                                                                                                }
                else{wrap.custResponse='Lost';    
                    }
                wrapList.add(wrap);
            } 
        }
        if(i>0){
            return  wrapList;
        }
        else{
            Wrapper wrap1= new Wrapper();
            wrap1.prodId=prod.Id;
            wrap1.prodName=prod.Name;
            wrap1.ndc=prod.Phoenix_NDC_11__c;
            wrap1.bidId=bidItem.Phoenix_Bid__c;
            wrap1.bidName=bidItem.Phoenix_Bid__r.Name;
            wrap1.accId=bid.Phoenix_Customer__c;
            wrap1.pickListOptions=listStrings;
            wrap1.pickListOptionsStatus=bidStatusList;
            wrap1.pickListOptionsCustResp=bidCustRespList1;
            wrap1.accId=bid.Phoenix_Customer__c;
            wrap1.accName=bid.Phoenix_Customer__r.Name;
            wrap1.accName=bid.Phoenix_Customer__r.Name;
            wrap1.nprHistCheck='noHist';
            wrapList1.add(wrap1);
            return  wrapList1;
        }
    }
    
    //----Bid History END  
    
    //  This method is to retrieve the Product NPR History---START 
    
    @AuraEnabled 
    public static List<Wrapper> getProdNPRHistory(String LineItemId, String recordId, string fieldName ){ 
        System.debug('getProdNPRHistory');
        Phoenix_Bid_Line_Item__c bidItem=[select Phoenix_Bid__c,Phoenix_Bid__r.Name,Phoenix_Product__c from Phoenix_Bid_Line_Item__c where Id=:LineItemId];
        Product2 prod=[select Id, Name, Phoenix_NDC_11__c from Product2 where Id=:bidItem.Phoenix_Product__c];
        Phoenix_Bid__c bid=[select Id, Phoenix_Customer__c,Phoenix_Customer__r.Name from Phoenix_Bid__c where Id=:bidItem.Phoenix_Bid__c];
        List<Phoenix_NPR_Data__c> nprData=[SELECT Id,CreatedDate,Phoenix_Product__c,Phoenix_Product__r.Name,Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_Contract__c,Phoenix_Contract__r.Name,(select Id,CreatedDate,Phoenix_New_Value__c,Phoenix_Previous_Value__c FROM NPR_Data_History__r WHERE Phoenix_Field_Name__c='Dead Net(Tracking GR)') FROM Phoenix_NPR_Data__c WHERE Phoenix_Product__c=:bidItem.Phoenix_Product__c AND Phoenix_Account__c=:bid.Phoenix_Customer__c];
        List<Phoenix_NPR_Data_History__c> nprHistList;
        Set<String> fieldNameSet = new Set<String>();
        List<String> fieldNameList = new List<String>();
        List<Phoenix_NPR_Data_History__c> nprHistList1 =[select Id,CreatedDate,Phoenix_Field_Name__c,
                                                         Phoenix_New_Value__c,Phoenix_NPR_Data__r.Phoenix_Contract__r.Name,Phoenix_NPR_Data__r.Phoenix_Contract__c,
                                                         Phoenix_Previous_Value__c FROM Phoenix_NPR_Data_History__c WHERE 
                                                         (Phoenix_Field_Name__c='Dead Net(Tracking GR)' OR Phoenix_Field_Name__c='Contract Price') AND Phoenix_NPR_Data__c=:nprData];   
        if(fieldName=='--None--' || fieldName==''){
            nprHistList=[select Id,CreatedDate,Phoenix_Field_Name__c,
                         Phoenix_New_Value__c,Phoenix_NPR_Data__r.Phoenix_Contract__r.Name,Phoenix_NPR_Data__r.Phoenix_Contract__c,
                         Phoenix_Previous_Value__c FROM Phoenix_NPR_Data_History__c WHERE 
                         (Phoenix_Field_Name__c='Dead Net(Tracking GR)' OR Phoenix_Field_Name__c='Contract Price') AND Phoenix_NPR_Data__c=:nprData];   
        }
        
        else{
            nprHistList=[select Id,CreatedDate,Phoenix_Field_Name__c,
                         Phoenix_New_Value__c,Phoenix_NPR_Data__r.Phoenix_Contract__r.Name,Phoenix_NPR_Data__r.Phoenix_Contract__c,
                         Phoenix_Previous_Value__c FROM Phoenix_NPR_Data_History__c WHERE 
                         Phoenix_Field_Name__c=:fieldName AND Phoenix_NPR_Data__c=:nprData];
        }
        fieldNameSet.add('--None--');
        for(Phoenix_NPR_Data_History__c npHist:nprHistList1){
            fieldNameSet.add(npHist.Phoenix_Field_Name__c); 
        }
        fieldNameList = new List<String>(fieldNameSet);
        fieldNameList.sort();
        List<Wrapper> wrapList= new List<Wrapper>();
        if(!nprHistList.isEmpty()){for(Phoenix_NPR_Data_History__c npr:nprHistList){
            Wrapper wrap= new Wrapper();
            wrap.prodId=prod.Id;
            wrap.prodName=prod.Name;
            wrap.ndc=prod.Phoenix_NDC_11__c;
            wrap.bidId=bidItem.Phoenix_Bid__c;
            wrap.bidName=bidItem.Phoenix_Bid__r.Name;
            wrap.accId=bid.Phoenix_Customer__c;
            wrap.accName=bid.Phoenix_Customer__r.Name;
            Datetime dt3 = npr.CreatedDate; 
            String nprCreatedDt = dt3.format('MM/dd/yyyy');
            wrap.dateProcessed=nprCreatedDt;
            wrap.deadNetPrev=npr.Phoenix_Previous_Value__c;
            wrap.deadNetNew=npr.Phoenix_New_Value__c;
            wrap.contrName=npr.Phoenix_NPR_Data__r.Phoenix_Contract__r.Name;
            wrap.contrId=npr.Phoenix_NPR_Data__r.Phoenix_Contract__c;
            wrap.nprHistCheck='yesHist';
            wrap.histFieldName=npr.Phoenix_Field_Name__c;
            wrap.pickListOptionsNPRHist=fieldNameList;
            wrapList.add(wrap);
        }     
                                  }
        else{
            Wrapper wrap1= new Wrapper();
            wrap1.prodId=prod.Id;
            wrap1.prodName=prod.Name;
            wrap1.ndc=prod.Phoenix_NDC_11__c;
            wrap1.bidId=bidItem.Phoenix_Bid__c;
            wrap1.bidName=bidItem.Phoenix_Bid__r.Name;
            wrap1.accId=bid.Phoenix_Customer__c;
            wrap1.accName=bid.Phoenix_Customer__r.Name;
            wrap1.nprHistCheck='noHist';
            wrapList.add(wrap1);  
        }
        return  wrapList;
    }
    
    //----Product NPR History END    
    
    
    //  This method is to retrieve the IMS Market Share for Product---START 
    
    @AuraEnabled 
    public static List<Wrapper> getIMSMarketShare(String LineItemId, String recordId){
        List<Wrapper> wrapList= new List<Wrapper>();
        Phoenix_Bid_Line_Item__c bidItem=[select Phoenix_Bid__c, Phoenix_Final_Total_Selling_Unit__c,Phoenix_Doses__c, Phoenix_Bid__r.Name,Phoenix_Product__c from Phoenix_Bid_Line_Item__c where Id=:LineItemId];
        Phoenix_Bid__c bid=[select Id, Phoenix_Customer__c,Phoenix_Customer__r.Name from Phoenix_Bid__c where Id=:recordId];
        Decimal testDoses =0.0;
        Product2 prod=[select Id, Name,Phoenix_NDC_11__c,Product_Family__r.Name, Product_Family__c,Phoenix_Overall_market__c,Phoenix_DRL_Market_Share__c,Family from Product2 where Id=:bidItem.Phoenix_Product__c LIMIT 1];
        List<Phoenix_Bid_Line_Item__c> bidItemFamily=[select Phoenix_Doses__c,Phoenix_Pkg_Size1__c, Phoenix_Final_Total_Selling_Unit__c,Phoenix_Bid__r.Name,Phoenix_Product__c from Phoenix_Bid_Line_Item__c 
                                                      where Product_Family_Name__c=:prod.Product_Family__r.Name AND Phoenix_Bid__c=:recordId];
        Decimal famDose=0.0;
        for(Phoenix_Bid_Line_Item__c bidItemFam:bidItemFamily){
            famDose=famDose+bidItemFam.Phoenix_Doses__c;
            System.debug('-----------testDoses-----------'+testDoses);
              System.debug('-----------Phoenix_Final_Total_Selling_Unit__c-----------'+bidItemFam.Phoenix_Final_Total_Selling_Unit__c);
            System.debug('-----------bidItemFam.Phoenix_Pkg_Size1__c-----------'+bidItemFam.Phoenix_Pkg_Size1__c);
            if(bidItemFam.Phoenix_Pkg_Size1__c!=null){
                       testDoses=testDoses+(bidItemFam.Phoenix_Final_Total_Selling_Unit__c*bidItemFam.Phoenix_Pkg_Size1__c);
     
            }
        }
        Wrapper wrap= new Wrapper();
        if(prod.Phoenix_Overall_market__c!=null){
            wrap.overallMark=prod.Phoenix_Overall_market__c;
        }
        if(prod.Phoenix_DRL_Market_Share__c!=null){
            wrap.drlMarkShare=prod.Phoenix_DRL_Market_Share__c;
        }
        wrap.prodId=prod.Id;
        wrap.prodName=prod.Name;
        wrap.ndc=prod.Phoenix_NDC_11__c;
        wrap.bidId=bidItem.Phoenix_Bid__c;
        wrap.bidName=bidItem.Phoenix_Bid__r.Name;
        wrap.accId=bid.Phoenix_Customer__c;
        wrap.accName=bid.Phoenix_Customer__r.Name;
        wrap.doses=famDose;
        wrap.custVol=testDoses/12;
        wrapList.add(wrap);
        return wrapList;
    }
    
    //  IMS Market Share for Product---END 
    
    //  This method is to retrieve the Product Price Trend---START 
    
    @AuraEnabled 
    public static List<Wrapper> getHistoricalPricing(String LineItemId, String recordId, String LastMonths){
        List<Date> dateList= new List<Date>();
        Datetime dtTime=System.now();
        date dt= date.newinstance(dtTime.year(), dtTime.month(), dtTime.day());
        date dateBefore;
        if (LastMonths=='12'){
            dateBefore=dt.addMonths(-14);
            dateList.add(dateBefore);
        }
        else{
            dateBefore=dt.addMonths(-26);  
            dateList.add(dateBefore);
        }
        
        List<Wrapper> wrapList= new List<Wrapper>();
        Phoenix_Bid_Line_Item__c bidItem=[select Phoenix_Bid__c,Phoenix_Bid__r.Name, Phoenix_Product__c from Phoenix_Bid_Line_Item__c where Id=:LineItemId];
        Phoenix_Bid__c bid=[select Id, Phoenix_Customer__c,Phoenix_Customer__r.Name,Phoenix_Customer__r.Phoenix_Customer_Bucket__c from Phoenix_Bid__c where Id=:recordId];
        Product2 prod=[select Id, Name, Phoenix_NDC_11__c from Product2 where Id=:bidItem.Phoenix_Product__c LIMIT 1];
        List<Phoenix_NPR_Data__c> nprData=[SELECT Id,CreatedDate, Phoenix_Product__c FROM Phoenix_NPR_Data__c WHERE Phoenix_Product__c=:bidItem.Phoenix_Product__c AND Phoenix_Account__c=:bid.Phoenix_Customer__c];
        List<Phoenix_NPR_Data__c> nprDataAll=[SELECT Id,CreatedDate, Phoenix_Product__c FROM Phoenix_NPR_Data__c WHERE Phoenix_Product__c=:bidItem.Phoenix_Product__c];
        
        //----------------volume------START
        List<Phoenix_NPR_Volume__c> nprVol=[SELECT Id, Name, Phoenix_Month__c,Phoenix_Date__c, Phoenix_Volume__c, Phoenix_Product__c FROM Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__c=:nprData AND Phoenix_Date__c>=:dateList ORDER BY Phoenix_Date__c];
        Map<String, List<Decimal>> nprVolMap= new  Map<String, List<Decimal>>();
        Map<String, Decimal> nprVolAvgMap= new  Map<String, Decimal>();
        for(Phoenix_NPR_Volume__c npVol:nprVol)
        {
            if(nprVolMap.containsKey(npVol.Phoenix_Month__c))
            {
            List<Decimal> usersId = nprVolMap.get(npVol.Phoenix_Month__c);
            usersId.add(npVol.Phoenix_Volume__c);
            nprVolMap.put(npVol.Phoenix_Month__c, usersId);
        } else {
            nprVolMap.put(npVol.Phoenix_Month__c, new List<Decimal> { npVol.Phoenix_Volume__c });
        }
                                               } 
        for(String volMonth: nprVolMap.keySet()){Decimal volAvg = 0;
                                                 System.debug('-----volMonth-------'+volMonth);
                                                 List<Decimal> volList = nprVolMap.get(volMonth);
                                                 system.debug('--------volList----'+volList); 
                                                 if (volList.size()>0){
                                                     for(Decimal h:volList){
                                                         volAvg+= h/volList.size(); 
                                                     }
                                                 }
                                                 else{
                                                 }
                                                 nprVolAvgMap.put(volMonth,volAvg.setscale(2));
                                                }
        //----------------volume------END
        
        //----------------snapshot---for Current Customer---START
        
        List<Phoenix_NPR_Snapshot__c> nprSnap=[SELECT Id, Name, CreatedDate, Phoenix_Month__c, Phoenix_Dead_Net_Tracking_GR__c FROM Phoenix_NPR_Snapshot__c WHERE Phoenix_NPR_Data__c=:nprData AND Phoenix_Date__c>=:dateList ORDER BY Phoenix_Date__c];
        Map<String, List<Decimal>> nprSnpCurrentMap= new  Map<String, List<Decimal>>();
        Map<String, Decimal> nprSnpCurrentAvgMap= new  Map<String, Decimal>();
        for(Phoenix_NPR_Snapshot__c npSnp:nprSnap){
            if(nprSnpCurrentMap.containsKey(npSnp.Phoenix_Month__c)) {
                List<Decimal> usersId = nprSnpCurrentMap.get(npSnp.Phoenix_Month__c);
                usersId.add(npSnp.Phoenix_Dead_Net_Tracking_GR__c);
                nprSnpCurrentMap.put(npSnp.Phoenix_Month__c, usersId);
            } else {
                nprSnpCurrentMap.put(npSnp.Phoenix_Month__c, new List<Decimal> { npSnp.Phoenix_Dead_Net_Tracking_GR__c });
            }
        } 
        for(String snpMonth: nprSnpCurrentMap.keySet()){
            Decimal deadAvg = 0;
            List<Decimal> deadNetList = nprSnpCurrentMap.get(snpMonth);
            if (deadNetList.size()>0){
                for(Decimal i:deadNetList){
                    deadAvg+= i/deadNetList.size(); 
                }
            }
            nprSnpCurrentAvgMap.put(snpMonth,deadAvg.setscale(2));
        }
        
        //--------------snapshot---for Current Customer-----END
        
        //----------------snapshot---Acorss All Customers---START
        
        List<Phoenix_NPR_Snapshot__c> nprSnap1=[SELECT Id, Name,  Phoenix_Month__c,CreatedDate, Phoenix_Dead_Net_Tracking_GR__c FROM Phoenix_NPR_Snapshot__c WHERE Phoenix_NPR_Data__c=:nprDataAll AND Phoenix_Date__c>=:dateList ORDER BY Phoenix_Date__c];
        Map<String, List<Decimal>> nprSnpCurrentMap1= new  Map<String, List<Decimal>>();
        Map<String, Decimal> nprSnpCurrentAvgMap1= new  Map<String, Decimal>();
        for(Phoenix_NPR_Snapshot__c npSnp1:nprSnap1){if(nprSnpCurrentMap1.containsKey(npSnp1.Phoenix_Month__c)) {
            List<Decimal> usersId1 = nprSnpCurrentMap1.get(npSnp1.Phoenix_Month__c);
            usersId1.add(npSnp1.Phoenix_Dead_Net_Tracking_GR__c);
            nprSnpCurrentMap1.put(npSnp1.Phoenix_Month__c, usersId1);
        } else {
            nprSnpCurrentMap1.put(npSnp1.Phoenix_Month__c, new List<Decimal> { npSnp1.Phoenix_Dead_Net_Tracking_GR__c });
        }
                                                    } 
        for(String snpMonth1: nprSnpCurrentMap1.keySet()){Decimal deadAvg1 = 0;
                                                          List<Decimal> deadNetList1 = nprSnpCurrentMap1.get(snpMonth1);
                                                          if (deadNetList1.size()>0){
                                                              for(Decimal j:deadNetList1){
                                                                  deadAvg1+= j/deadNetList1.size(); 
                                                              }
                                                          }
                                                          nprSnpCurrentAvgMap1.put(snpMonth1,deadAvg1.setscale(2));
                                                         }
        
        //---------------snapshot---Acorss All Customers-----END
        
        //----------------snapshot---for Bucket Customer---START
        
        List<Phoenix_NPR_Snapshot__c> nprSnap12=[SELECT Id, Name, CreatedDate, Phoenix_Month__c, Phoenix_Dead_Net_Tracking_GR__c FROM Phoenix_NPR_Snapshot__c WHERE Phoenix_NPR_Data__c=:nprDataAll AND Phoenix_NPR_Data__r.Phoenix_Customer_Bucket__c != null AND Phoenix_NPR_Data__r.Phoenix_Customer_Bucket__c=:bid.Phoenix_Customer__r.Phoenix_Customer_Bucket__c AND Phoenix_Date__c>=:dateList ORDER BY Phoenix_Date__c];
        Map<String, List<Decimal>> nprSnpCurrentMap12= new  Map<String, List<Decimal>>();
        Map<String, Decimal> nprSnpCurrentAvgMap12= new  Map<String, Decimal>();
        for(Phoenix_NPR_Snapshot__c npSnp12:nprSnap12){if(nprSnpCurrentMap12.containsKey(npSnp12.Phoenix_Month__c)) {
            List<Decimal> usersId12 = nprSnpCurrentMap12.get(npSnp12.Phoenix_Month__c);
            usersId12.add(npSnp12.Phoenix_Dead_Net_Tracking_GR__c);
            nprSnpCurrentMap12.put(npSnp12.Phoenix_Month__c, usersId12);
        } else {
            nprSnpCurrentMap12.put(npSnp12.Phoenix_Month__c, new List<Decimal> { npSnp12.Phoenix_Dead_Net_Tracking_GR__c });
        }
                                                      } 
        for(String snpMonth12: nprSnpCurrentMap12.keySet()){
            Decimal deadAvg12 = 0;
            List<Decimal> deadNetList12 = nprSnpCurrentMap12.get(snpMonth12);
            if (deadNetList12.size()>0){
                for(Decimal k:deadNetList12){
                    deadAvg12+= k/deadNetList12.size(); 
                }
            }
            nprSnpCurrentAvgMap12.put(snpMonth12,deadAvg12.setscale(2));
        }
        
        //--------snapshot---for Bucket Customer----END
        Map<String, Decimal> nprVolAvgTemp= new  Map<String, Decimal>();
        Map<String, Decimal> nprSnpCurrentAvgMap12Temp= new  Map<String, Decimal>();
        Map<String, Decimal> nprSnpCurrentAvgMapTemp= new  Map<String, Decimal>();
        for(String key: nprSnpCurrentAvgMap1.keySet()){
            if(nprVolAvgMap.containsKey(key)){
                nprVolAvgTemp.put(key,nprVolAvgMap.get(key)); 
            }
            else{
                nprVolAvgTemp.put(key,0.00); 
            }
            if(nprSnpCurrentAvgMap12.containsKey(key)){
                nprSnpCurrentAvgMap12Temp.put(key,nprSnpCurrentAvgMap12.get(key));     
            }
            else{
                nprSnpCurrentAvgMap12Temp.put(key,0.00);
            }
            if(nprSnpCurrentAvgMap.containsKey(key)){
                nprSnpCurrentAvgMapTemp.put(key,nprSnpCurrentAvgMap.get(key));     
            }
            else{
                nprSnpCurrentAvgMapTemp.put(key,0.00);
            }
        }
        Wrapper wrap= new Wrapper();
        wrap.prodId=prod.Id;
        wrap.prodName=prod.Name;
        wrap.ndc=prod.Phoenix_NDC_11__c;
        wrap.bidId=bidItem.Phoenix_Bid__c;
        wrap.bidName=bidItem.Phoenix_Bid__r.Name;
        wrap.accId=bid.Phoenix_Customer__c;
        wrap.accName=bid.Phoenix_Customer__r.Name;
        wrap.bucketCust=bid.Phoenix_Customer__r.Phoenix_Customer_Bucket__c;
        if(nprVolAvgTemp!=null){
            wrap.nprVolMap=nprVolAvgTemp;
        }
        if(nprSnpCurrentAvgMapTemp!=null){
            wrap.nprSnapCurrent=nprSnpCurrentAvgMapTemp;
        }
        if(nprSnpCurrentAvgMap1!=null){
            wrap.nprSnapAll=nprSnpCurrentAvgMap1;
        }
        if(nprSnpCurrentAvgMap12Temp!=null){
            wrap.nprSnapBucket=nprSnpCurrentAvgMap12Temp;
        }
        wrapList.add(wrap);
        return wrapList;
    }
    
    //  Product Price Trend---END */
    
}