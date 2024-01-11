public class Vision_GCP_Short_DateCls {
    @auraEnabled
    public static MainWrapper getAccountGroups(){
        List<String> apexClassList = new List<String>();
        apexClassList.add('GoogleShortDatesFetch');
        
        
        MainWrapper mainwrap = new MainWrapper();
        mainWrap.isProcessed =  Vision_Rx_Compliance_NPR.apexJobStatus(apexClassList);
        String query = '';
        //  string customer ='CONTROL LABEL';
        query = 'select Vision_Customer__r.Name, '+Phoenix_Util.getsObjectFieds('Vision_GCP_Short_Date__c')+' from Vision_GCP_Short_Date__c ORDER BY GCP_Customer_Name__c ASC';
        List < Vision_GCP_Short_Date__c > listOfGCPShortRecords = Database.query(query); 
        set<string> accgrpsset = new set<string>();
        map<String,List<Vision_GCP_Short_Date__c>> accMap = new map<String,List<Vision_GCP_Short_Date__c>>();
        for(Vision_GCP_Short_Date__c item : listOfGCPShortRecords){
            mainwrap.totalValue3MonShowAll = mainwrap.totalValue3MonShowAll + (item.Vision_GCP_Total_Writeoff_Costs_3_Months__c != null ? item.Vision_GCP_Total_Writeoff_Costs_3_Months__c:0);                
            mainwrap.totalWrittenOffDollar3MonShowAll = mainwrap.totalWrittenOffDollar3MonShowAll + (item.Vision_Dollar_Writen_Off__c != null ? item.Vision_Dollar_Writen_Off__c :0);  
            mainwrap.totalValue9MonShowAll = mainwrap.totalValue9MonShowAll + (item.Vision_Total_value_dollar__c != null ? item.Vision_Total_value_dollar__c:0);                
            mainwrap.totalWrittenOffDollar9MonShowAll = mainwrap.totalWrittenOffDollar9MonShowAll + (item.Vision_Dollar_Writen_Off__c != null ? item.Vision_Dollar_Writen_Off__c :0);  
            if(item.Vision_Is_3_Months_PWO__c){
                mainwrap.totalValue3MonPW = mainwrap.totalValue3MonPW + (item.Vision_GCP_Total_Writeoff_Costs_3_Months__c != null ? item.Vision_GCP_Total_Writeoff_Costs_3_Months__c:0);                
                mainwrap.totalWrittenOffDollar3MonPW = mainwrap.totalWrittenOffDollar3MonPW + (item.Vision_Dollar_Writen_Off__c != null ? item.Vision_Dollar_Writen_Off__c :0);  
            }
            if(item.Vision_Is_9_months_PWO__c){
                mainwrap.totalValue9MonPW = mainwrap.totalValue9MonPW + (item.Vision_Total_value_dollar__c != null ? item.Vision_Total_value_dollar__c:0);               
                mainwrap.totalWrittenOffDollar9MonPW = mainwrap.totalWrittenOffDollar9MonPW + (item.Vision_Dollar_Writen_Off__c != null ? item.Vision_Dollar_Writen_Off__c :0);  
            }
            accgrpsset.add(item.GCP_Customer_Name__c);
            if(accMap.containsKey(item.GCP_Customer_Name__c)){
                List<Vision_GCP_Short_Date__c> sdList = accMap.get(item.GCP_Customer_Name__c);
                sdList.add(item);
                accMap.put(item.GCP_Customer_Name__c,sdList);
            }
            else{
                accMap.put(item.GCP_Customer_Name__c,new List<Vision_GCP_Short_Date__c>{item});
            }
        }
        List<AccountsWrapper> accWrapList = new List<AccountsWrapper>();
        for(string accName : accMap.keySet()){
            AccountsWrapper accWrap = new AccountsWrapper();
            accWrap.accGroupName = accName;
            List<Vision_GCP_Short_Date__c> sdList = accMap.get(accName); 
            
            for(Vision_GCP_Short_Date__c sd : sdList){  
                accWrap.totalInValue3MonthsAcc = accWrap.totalInValue3MonthsAcc + (sd.Vision_GCP_Total_Writeoff_Costs_3_Months__c != null ? sd.Vision_GCP_Total_Writeoff_Costs_3_Months__c:0);  
                accWrap.totalInValue9MonthsAcc = accWrap.totalInValue9MonthsAcc + (sd.Vision_Total_value_dollar__c != null ? sd.Vision_Total_value_dollar__c :0);  
                if(sd.Vision_Is_3_Months_PWO__c){
                    accWrap.writeOffQtyAcc3MonPW = accWrap.writeOffQtyAcc3MonPW + (sd.Vision_qty_written_off__c != null ? sd.Vision_qty_written_off__c :0);  
                    accWrap.writeOffDollarAcc3MonPW = accWrap.writeOffDollarAcc3MonPW + (sd.Vision_Dollar_Writen_Off__c != null ? sd.Vision_Dollar_Writen_Off__c :0);  
                }
                if(sd.Vision_Is_9_months_PWO__c){
                    accWrap.writeOffQtyAcc9MonPW = accWrap.writeOffQtyAcc9MonPW + (sd.Vision_qty_written_off__c != null ? sd.Vision_qty_written_off__c :0);  
                    accWrap.writeOffDollarAcc9MonPW = accWrap.writeOffDollarAcc9MonPW + (sd.Vision_Dollar_Writen_Off__c != null ? sd.Vision_Dollar_Writen_Off__c :0);  
                }
                accWrap.writeOffQtyAccShowAll = accWrap.writeOffQtyAccShowAll + (sd.Vision_qty_written_off__c != null ? sd.Vision_qty_written_off__c :0);  
                accWrap.writeOffDollarAccShowAll = accWrap.writeOffDollarAccShowAll + (sd.Vision_Dollar_Writen_Off__c != null ? sd.Vision_Dollar_Writen_Off__c :0);  
            } 
            accWrapList.add(accWrap);
        }
        
        // List<string> accgrpList = new List<string>();
        //  accgrpList.addAll(accgrpsset);
        //  system.debug('accgrpList-----'+accgrpList.size());
        //   system.debug('accgrpList-----'+accgrpList);
        string customer = accWrapList[0].accGroupName;
        mainwrap.accgrpList=accWrapList;
        mainwrap.sdRecords = listOfGCPShortRecords[0];
        mainwrap.accList = getShortDateData(customer).accList;
        return mainwrap;
    }
    @auraEnabled
    public static MainWrapper getShortDateData(String customer){
        
        Wrapper wrapperObject = new Wrapper();
        MainWrapper mainWrapper = new MainWrapper();
        String query = '';
        String SobjectApiName = 'Vision_GCP_Short_Date__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        //TRING CUSTCODE = '370171';
        query = 'select Vision_Customer__r.Name, '+strFields+' from ' + SobjectApiName + ' WHERE GCP_Customer_Name__c =:customer ORDER BY GCP_Customer_Name__c ASC';
        List < Vision_GCP_Short_Date__c > listOfGCPShortRecords = Database.query(query);
        map<String,List<Vision_GCP_Short_Date__c>> accMap = new map<String,List<Vision_GCP_Short_Date__c>>();
        map<String,List<Vision_GCP_Short_Date__c>> prodFamMap = new map<String,List<Vision_GCP_Short_Date__c>>();
        Decimal ftoCost = 0;
        set<string> accSet = new set<string>();
        set<string> prodFamilySet = new set<string>();
        for(Vision_GCP_Short_Date__c sdItem : listOfGCPShortRecords){
            accSet.add(sdItem.GCP_Customer_Name__c);
            prodFamilySet.add(sdItem.GCP_Product_Family__c);
        }
        system.debug('total records-->'+listOfGCPShortRecords.size());
        for(Vision_GCP_Short_Date__c item : listOfGCPShortRecords){
            if(accMap.containsKey(item.GCP_Customer_Name__c)){
                List<Vision_GCP_Short_Date__c> sdList = accMap.get(item.GCP_Customer_Name__c);
                sdList.add(item);
                accMap.put(item.GCP_Customer_Name__c,sdList);
            }
            else{
                accMap.put(item.GCP_Customer_Name__c,new List<Vision_GCP_Short_Date__c>{item});
            }
        }
        List<AccountsList> AccountsWrapperList = new List<AccountsList>();
        List<productFamily> listProductFamily = new List<productFamily>();
        
        for(string accName : accMap.keySet()){
            AccountsList accList = new AccountsList();
            accList.accName = accName;
            List<Vision_GCP_Short_Date__c> sdList = accMap.get(accName);
            system.debug('sdList  size--->'+sdList.size());
            for(Vision_GCP_Short_Date__c sd : sdList){  
                accList.totalInUnits3Months = accList.totalInUnits3Months + (sd.Vision_M1_Potential_Write_Off__c != null ? sd.Vision_M1_Potential_Write_Off__c : 0)+ (sd.Vision_M2_Potential_Write_Off__c != null ? sd.Vision_M2_Potential_Write_Off__c : 0)+ (sd.Vision_M3_Potential_Write_Off__c != null ? sd.Vision_M3_Potential_Write_Off__c : 0);  
                accList.totalInValue3Months = accList.totalInValue3Months + (sd.Vision_M1_Write_Off_Cost__c != null ? sd.Vision_M1_Write_Off_Cost__c : 0)+ (sd.Vision_M2_Write_Off_Cost__c != null ? sd.Vision_M2_Write_Off_Cost__c : 0)+ (sd.Vision_M3_Write_Off_Cost__c != null ? sd.Vision_M3_Write_Off_Cost__c : 0);  
                accList.ftoCost   = accList.ftoCost + (sd.Vision_FTO_Cost_dollar__c != null ? sd.Vision_FTO_Cost_dollar__c : 0);    
                accList.totalInUnits   = accList.totalInUnits + (sd.Vision_Total_in_Units__c != null ? sd.Vision_Total_in_Units__c : 0);
                accList.totalInValue   = accList.totalInValue + (sd.Vision_Total_value_dollar__c != null ? sd.Vision_Total_value_dollar__c : 0);    
                accList.currentMonthOrder   = accList.currentMonthOrder + (sd.Vision_Current_Month_Order_Quantity__c != null ? sd.Vision_Current_Month_Order_Quantity__c : 0);
                accList.writeOffQty   = accList.writeOffQty + (sd.Vision_qty_written_off__c != null ? sd.Vision_qty_written_off__c : 0);
                accList.writeOffDollar   = accList.writeOffDollar + (sd.Vision_Dollar_Writen_Off__c != null ? sd.Vision_Dollar_Writen_Off__c : 0);
                accList.LastMonthWriteOffQty = accList.LastMonthWriteOffQty + (sd.Vision_Last_Month_Written_Off_QTY__c != null ? sd.Vision_Last_Month_Written_Off_QTY__c : 0);
                accList.LastMonthWriteOffDollar = accList.LastMonthWriteOffDollar + (sd.Last_Month_Written_Off_Cost__c != null ? sd.Last_Month_Written_Off_Cost__c : 0);
                accList.shortDate1   = accList.shortDate1 + (sd.Vision_M1_Short_Date__c != null ? sd.Vision_M1_Short_Date__c : 0);    
                accList.potenialWriteOff1   = accList.potenialWriteOff1 + (sd.Vision_M1_Potential_Write_Off__c != null ? sd.Vision_M1_Potential_Write_Off__c : 0);    
                accList.writeOffCost1   = accList.writeOffCost1 + (sd.Vision_M1_Write_Off_Cost__c != null ? sd.Vision_M1_Write_Off_Cost__c : 0);    
                accList.shortDate2  = accList.shortDate2 + (sd.Vision_M2_Short_Date__c != null ? sd.Vision_M2_Short_Date__c : 0);    
                accList.potenialWriteOff2   = accList.potenialWriteOff2 + (sd.Vision_M2_Potential_Write_Off__c != null ? sd.Vision_M2_Potential_Write_Off__c : 0);    
                accList.writeOffCost2   = accList.writeOffCost2 + (sd.Vision_M2_Write_Off_Cost__c != null ? sd.Vision_M2_Write_Off_Cost__c : 0);    
                accList.shortDate3   = accList.shortDate3 + (sd.Vision_M3_Short_Date__c != null ? sd.Vision_M3_Short_Date__c : 0);    
                accList.potenialWriteOff3   = accList.potenialWriteOff3 + (sd.Vision_M3_Potential_Write_Off__c != null ? sd.Vision_M3_Potential_Write_Off__c : 0);    
                accList.writeOffCost3   = accList.writeOffCost3 + (sd.Vision_M3_Write_Off_Cost__c != null ? sd.Vision_M3_Write_Off_Cost__c : 0);    
                accList.shortDate4  = accList.shortDate4 + (sd.Vision_M4_Short_Date__c != null ? sd.Vision_M4_Short_Date__c : 0);    
                accList.potenialWriteOff4   = accList.potenialWriteOff4 + (sd.Vision_M4_Potential_Write_Off__c != null ? sd.Vision_M4_Potential_Write_Off__c : 0);    
                accList.writeOffCost4   = accList.writeOffCost4 + (sd.Vision_M4_Write_Off_Cost__c != null ? sd.Vision_M4_Write_Off_Cost__c : 0);    
                accList.shortDate5   = accList.shortDate5 + (sd.Vision_M5_Short_Date__c != null ? sd.Vision_M5_Short_Date__c : 0);    
                accList.potenialWriteOff5   = accList.potenialWriteOff5 + (sd.Vision_M5_Potential_Write_Off__c != null ? sd.Vision_M5_Potential_Write_Off__c : 0);    
                accList.writeOffCost5   = accList.writeOffCost5 + (sd.Vision_M5_Write_Off_Cost__c != null ? sd.Vision_M5_Write_Off_Cost__c : 0);    
                accList.shortDate6  = accList.shortDate6 + (sd.Vision_M6_Short_Date__c != null ? sd.Vision_M6_Short_Date__c : 0);    
                accList.potenialWriteOff6   = accList.potenialWriteOff6 + (sd.Vision_M6_Potential_Write_Off__c != null ? sd.Vision_M6_Potential_Write_Off__c : 0);    
                accList.writeOffCost6   = accList.writeOffCost6 + (sd.Vision_M6_Write_Off_Cost__c != null ? sd.Vision_M6_Write_Off_Cost__c : 0);    
                accList.shortDate7   = accList.shortDate7 + (sd.Vision_M7_Short_Date__c != null ? sd.Vision_M7_Short_Date__c : 0);    
                accList.potenialWriteOff7   = accList.potenialWriteOff7 + (sd.Vision_M7_Potential_Write_Off__c != null ? sd.Vision_M7_Potential_Write_Off__c : 0);    
                accList.writeOffCost7   = accList.writeOffCost7 + (sd.Vision_M7_Write_Off_Cost__c != null ? sd.Vision_M7_Write_Off_Cost__c : 0);    
                accList.shortDate8  = accList.shortDate8 + (sd.Vision_M8_Short_Date__c != null ? sd.Vision_M8_Short_Date__c : 0);    
                accList.potenialWriteOff8   = accList.potenialWriteOff8 + (sd.Vision_M8_Potential_Write_Off__c != null ? sd.Vision_M8_Potential_Write_Off__c : 0);    
                accList.writeOffCost8   = accList.writeOffCost8 + (sd.Vision_M8_Write_Off_Cost__c != null ? sd.Vision_M8_Write_Off_Cost__c : 0);  
                accList.shortDate9  = accList.shortDate9 + (sd.Vision_M9_Short_Date__c != null ? sd.Vision_M9_Short_Date__c : 0);    
                accList.potenialWriteOff9   = accList.potenialWriteOff9 + (sd.Vision_M9_Potential_Write_Off__c != null ? sd.Vision_M9_Potential_Write_Off__c : 0);    
                accList.writeOffCost9  = accList.writeOffCost9 + (sd.Vision_M9_Write_Off_Cost__c != null ? sd.Vision_M9_Write_Off_Cost__c : 0);    
                if(prodFamMap.containsKey(sd.GCP_Product_Family__c)){
                    List<Vision_GCP_Short_Date__c> prodList = prodFamMap.get(sd.GCP_Product_Family__c);
                    prodList.add(sd);
                    prodFamMap.put(sd.GCP_Product_Family__c,prodList);
                }
                else{
                    
                    prodFamMap.put(sd.GCP_Product_Family__c,new List<Vision_GCP_Short_Date__c>{sd});
                }
            }
            for(String prodfam : prodFamMap.keySet()){
                productFamily prodFamily = new productFamily();
                prodFamily.pfName = prodfam;
                List<Vision_GCP_Short_Date__c> pfList = prodFamMap.get(prodfam);
                for(Vision_GCP_Short_Date__c pf : pfList){               
                    prodFamily.ftoCost   = prodFamily.ftoCost + (pf.Vision_FTO_Cost_dollar__c != null ? pf.Vision_FTO_Cost_dollar__c : 0);    
                    prodFamily.totalInUnits   = prodFamily.totalInUnits + (pf.Vision_Total_in_Units__c != null ? pf.Vision_Total_in_Units__c : 0);
                    prodFamily.totalInValue   = prodFamily.totalInValue + (pf.Vision_Total_value_dollar__c != null ? pf.Vision_Total_value_dollar__c : 0);    
                    prodFamily.currentMonthOrder   = prodFamily.currentMonthOrder + (pf.Vision_Current_Month_Order_Quantity__c != null ? pf.Vision_Current_Month_Order_Quantity__c : 0);
                    prodFamily.writeOffQty   = prodFamily.writeOffQty + (pf.Vision_qty_written_off__c != null ? pf.Vision_qty_written_off__c : 0);
                    prodFamily.writeOffDollar   = prodFamily.writeOffDollar + (pf.Vision_Dollar_Writen_Off__c != null ? pf.Vision_Dollar_Writen_Off__c : 0);
                    prodFamily.LastMonthWriteOffQty   = prodFamily.LastMonthWriteOffQty + (pf.Vision_Last_Month_Written_Off_QTY__c != null ? pf.Vision_Last_Month_Written_Off_QTY__c : 0);
                    prodFamily.LastMonthWriteOffDollar = prodFamily.LastMonthWriteOffDollar + (pf.Last_Month_Written_Off_Cost__c != null ? pf.Last_Month_Written_Off_Cost__c : 0);
                    prodFamily.shortDate1   = prodFamily.shortDate1 + (pf.Vision_M1_Short_Date__c != null ? pf.Vision_M1_Short_Date__c : 0);    
                    prodFamily.potenialWriteOff1   = prodFamily.potenialWriteOff1 + (pf.Vision_M1_Potential_Write_Off__c != null ? pf.Vision_M1_Potential_Write_Off__c : 0);    
                    prodFamily.writeOffCost1   = prodFamily.writeOffCost1 + (pf.Vision_M1_Write_Off_Cost__c != null ? pf.Vision_M1_Write_Off_Cost__c : 0);    
                    prodFamily.shortDate2  = prodFamily.shortDate2 + (pf.Vision_M2_Short_Date__c != null ? pf.Vision_M2_Short_Date__c : 0);    
                    prodFamily.potenialWriteOff2   = prodFamily.potenialWriteOff2 + (pf.Vision_M2_Potential_Write_Off__c != null ? pf.Vision_M2_Potential_Write_Off__c : 0);    
                    prodFamily.writeOffCost2   = prodFamily.writeOffCost2 + (pf.Vision_M2_Write_Off_Cost__c != null ? pf.Vision_M2_Write_Off_Cost__c : 0);    
                    prodFamily.shortDate3   = prodFamily.shortDate3 + (pf.Vision_M3_Short_Date__c != null ? pf.Vision_M3_Short_Date__c : 0);    
                    prodFamily.potenialWriteOff3   = prodFamily.potenialWriteOff3 + (pf.Vision_M3_Potential_Write_Off__c != null ? pf.Vision_M3_Potential_Write_Off__c : 0);    
                    prodFamily.writeOffCost3   = prodFamily.writeOffCost3 + (pf.Vision_M3_Write_Off_Cost__c != null ? pf.Vision_M3_Write_Off_Cost__c : 0);    
                    prodFamily.shortDate4  = prodFamily.shortDate4 + (pf.Vision_M4_Short_Date__c != null ? pf.Vision_M4_Short_Date__c : 0);    
                    prodFamily.potenialWriteOff4   = prodFamily.potenialWriteOff4 + (pf.Vision_M4_Potential_Write_Off__c != null ? pf.Vision_M4_Potential_Write_Off__c : 0);    
                    prodFamily.writeOffCost4   = prodFamily.writeOffCost4 + (pf.Vision_M4_Write_Off_Cost__c != null ? pf.Vision_M4_Write_Off_Cost__c : 0);    
                    prodFamily.shortDate5   = prodFamily.shortDate5 + (pf.Vision_M5_Short_Date__c != null ? pf.Vision_M5_Short_Date__c : 0);    
                    prodFamily.potenialWriteOff5   = prodFamily.potenialWriteOff5 + (pf.Vision_M5_Potential_Write_Off__c != null ? pf.Vision_M5_Potential_Write_Off__c : 0);    
                    prodFamily.writeOffCost5   = prodFamily.writeOffCost5 + (pf.Vision_M5_Write_Off_Cost__c != null ? pf.Vision_M5_Write_Off_Cost__c : 0);    
                    prodFamily.shortDate6  = prodFamily.shortDate6 + (pf.Vision_M6_Short_Date__c != null ? pf.Vision_M6_Short_Date__c : 0);    
                    prodFamily.potenialWriteOff6   = prodFamily.potenialWriteOff6 + (pf.Vision_M6_Potential_Write_Off__c != null ? pf.Vision_M6_Potential_Write_Off__c : 0);    
                    prodFamily.writeOffCost6   = prodFamily.writeOffCost6 + (pf.Vision_M6_Write_Off_Cost__c != null ? pf.Vision_M6_Write_Off_Cost__c : 0);    
                    prodFamily.shortDate7   = prodFamily.shortDate7 + (pf.Vision_M7_Short_Date__c != null ? pf.Vision_M7_Short_Date__c : 0);    
                    prodFamily.potenialWriteOff7   = prodFamily.potenialWriteOff7 + (pf.Vision_M7_Potential_Write_Off__c != null ? pf.Vision_M7_Potential_Write_Off__c : 0);    
                    prodFamily.writeOffCost7   = prodFamily.writeOffCost7 + (pf.Vision_M7_Write_Off_Cost__c != null ? pf.Vision_M7_Write_Off_Cost__c : 0);    
                    prodFamily.shortDate8  = prodFamily.shortDate8 + (pf.Vision_M8_Short_Date__c != null ? pf.Vision_M8_Short_Date__c : 0);    
                    prodFamily.potenialWriteOff8   = prodFamily.potenialWriteOff8 + (pf.Vision_M8_Potential_Write_Off__c != null ? pf.Vision_M8_Potential_Write_Off__c : 0);    
                    prodFamily.writeOffCost8   = prodFamily.writeOffCost8 + (pf.Vision_M8_Write_Off_Cost__c != null ? pf.Vision_M8_Write_Off_Cost__c : 0);  
                    prodFamily.shortDate9  = prodFamily.shortDate9 + (pf.Vision_M9_Short_Date__c != null ? pf.Vision_M9_Short_Date__c : 0);    
                    prodFamily.potenialWriteOff9   = prodFamily.potenialWriteOff9 + (pf.Vision_M9_Potential_Write_Off__c != null ? pf.Vision_M9_Potential_Write_Off__c : 0);    
                    prodFamily.writeOffCost9  = prodFamily.writeOffCost9 + (pf.Vision_M9_Write_Off_Cost__c != null ? pf.Vision_M9_Write_Off_Cost__c : 0);
                }
                prodFamily.sdpfist = pfList;
                listProductFamily.add(prodFamily);
            }
            //system.debug('listProductFamily before size-->'+listProductFamily.size());
            accList.productFamily=listProductFamily;
            listProductFamily = new List<productFamily>();
            prodFamMap = new map<String,List<Vision_GCP_Short_Date__c>>();
            //system.debug('listProductFamily after size-->'+listProductFamily.size());
            AccountsWrapperList.add(accList);
            
        }
        system.debug('AccountsWrapperList---'+AccountsWrapperList);
        mainWrapper.accList = AccountsWrapperList;      
        mainWrapper.noOfRecords = listOfGCPShortRecords.size();    
        return mainWrapper;
    }
    @auraEnabled 
    public static MainWrapper getFiltershortDate(String searchText,String customer){
        MainWrapper mainWrapper = new MainWrapper();
        
        
        String query = '';
        String SobjectApiName = 'Vision_GCP_Short_Date__c';
        searchText = '%'+searchText+'%';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        if(searchText != null && searchText !='')
            query = 'select '+strFields+' from ' + SobjectApiName + ' WHERE GCP_Customer_Name__c =:customer AND(GCP_Customer_Name__c like : searchText OR GCP_Product_Family__c like : searchText) ORDER BY GCP_Customer_Name__c ASC';
        else
            query = 'select '+strFields+' from ' + SobjectApiName + ' WHERE GCP_Customer_Name__c =:customer ORDER BY GCP_Customer_Name__c ASC';
        List < Vision_GCP_Short_Date__c > listOfGCPShortRecords = Database.query(query);
        map<String,List<Vision_GCP_Short_Date__c>> accMap = new map<String,List<Vision_GCP_Short_Date__c>>();
        map<String,List<Vision_GCP_Short_Date__c>> prodFamMap = new map<String,List<Vision_GCP_Short_Date__c>>();
        
        set<string> accSet = new set<string>();
        set<string> prodFamilySet = new set<string>();
        
        system.debug('total records-->'+listOfGCPShortRecords.size());
        for(Vision_GCP_Short_Date__c item : listOfGCPShortRecords){
            if(accMap.containsKey(item.GCP_Customer_Name__c)){
                List<Vision_GCP_Short_Date__c> sdList = accMap.get(item.GCP_Customer_Name__c);
                sdList.add(item);
                accMap.put(item.GCP_Customer_Name__c,sdList);
            }
            else{
                accMap.put(item.GCP_Customer_Name__c,new List<Vision_GCP_Short_Date__c>{item});
            }
        }
        List<AccountsList> AccountsWrapperList = new List<AccountsList>();
        List<productFamily> listProductFamily = new List<productFamily>();
        
        for(string accName : accMap.keySet()){
            AccountsList accList = new AccountsList();
            accList.accName = accName;
            List<Vision_GCP_Short_Date__c> sdList = accMap.get(accName);
            system.debug('sdList  size--->'+sdList.size());
             for(Vision_GCP_Short_Date__c sd : sdList){  
                accList.totalInUnits3Months = accList.totalInUnits3Months + (sd.Vision_M1_Potential_Write_Off__c != null ? sd.Vision_M1_Potential_Write_Off__c : 0)+ (sd.Vision_M2_Potential_Write_Off__c != null ? sd.Vision_M2_Potential_Write_Off__c : 0)+ (sd.Vision_M3_Potential_Write_Off__c != null ? sd.Vision_M3_Potential_Write_Off__c : 0);  
                accList.totalInValue3Months = accList.totalInValue3Months + (sd.Vision_M1_Write_Off_Cost__c != null ? sd.Vision_M1_Write_Off_Cost__c : 0)+ (sd.Vision_M2_Write_Off_Cost__c != null ? sd.Vision_M2_Write_Off_Cost__c : 0)+ (sd.Vision_M3_Write_Off_Cost__c != null ? sd.Vision_M3_Write_Off_Cost__c : 0);  
                accList.ftoCost   = accList.ftoCost + (sd.Vision_FTO_Cost_dollar__c != null ? sd.Vision_FTO_Cost_dollar__c : 0);    
                accList.totalInUnits   = accList.totalInUnits + (sd.Vision_Total_in_Units__c != null ? sd.Vision_Total_in_Units__c : 0);
                accList.totalInValue   = accList.totalInValue + (sd.Vision_Total_value_dollar__c != null ? sd.Vision_Total_value_dollar__c : 0);    
                accList.currentMonthOrder   = accList.currentMonthOrder + (sd.Vision_Current_Month_Order_Quantity__c != null ? sd.Vision_Current_Month_Order_Quantity__c : 0);
                accList.writeOffQty   = accList.writeOffQty + (sd.Vision_qty_written_off__c != null ? sd.Vision_qty_written_off__c : 0);
                accList.writeOffDollar   = accList.writeOffDollar + (sd.Vision_Dollar_Writen_Off__c != null ? sd.Vision_Dollar_Writen_Off__c : 0);
                accList.LastMonthWriteOffQty = accList.LastMonthWriteOffQty + (sd.Vision_Last_Month_Written_Off_QTY__c != null ? sd.Vision_Last_Month_Written_Off_QTY__c : 0);
                accList.LastMonthWriteOffDollar = accList.LastMonthWriteOffDollar + (sd.Last_Month_Written_Off_Cost__c != null ? sd.Last_Month_Written_Off_Cost__c : 0);
                accList.shortDate1   = accList.shortDate1 + (sd.Vision_M1_Short_Date__c != null ? sd.Vision_M1_Short_Date__c : 0);    
                accList.potenialWriteOff1   = accList.potenialWriteOff1 + (sd.Vision_M1_Potential_Write_Off__c != null ? sd.Vision_M1_Potential_Write_Off__c : 0);    
                accList.writeOffCost1   = accList.writeOffCost1 + (sd.Vision_M1_Write_Off_Cost__c != null ? sd.Vision_M1_Write_Off_Cost__c : 0);    
                accList.shortDate2  = accList.shortDate2 + (sd.Vision_M2_Short_Date__c != null ? sd.Vision_M2_Short_Date__c : 0);    
                accList.potenialWriteOff2   = accList.potenialWriteOff2 + (sd.Vision_M2_Potential_Write_Off__c != null ? sd.Vision_M2_Potential_Write_Off__c : 0);    
                accList.writeOffCost2   = accList.writeOffCost2 + (sd.Vision_M2_Write_Off_Cost__c != null ? sd.Vision_M2_Write_Off_Cost__c : 0);    
                accList.shortDate3   = accList.shortDate3 + (sd.Vision_M3_Short_Date__c != null ? sd.Vision_M3_Short_Date__c : 0);    
                accList.potenialWriteOff3   = accList.potenialWriteOff3 + (sd.Vision_M3_Potential_Write_Off__c != null ? sd.Vision_M3_Potential_Write_Off__c : 0);    
                accList.writeOffCost3   = accList.writeOffCost3 + (sd.Vision_M3_Write_Off_Cost__c != null ? sd.Vision_M3_Write_Off_Cost__c : 0);    
                accList.shortDate4  = accList.shortDate4 + (sd.Vision_M4_Short_Date__c != null ? sd.Vision_M4_Short_Date__c : 0);    
                accList.potenialWriteOff4   = accList.potenialWriteOff4 + (sd.Vision_M4_Potential_Write_Off__c != null ? sd.Vision_M4_Potential_Write_Off__c : 0);    
                accList.writeOffCost4   = accList.writeOffCost4 + (sd.Vision_M4_Write_Off_Cost__c != null ? sd.Vision_M4_Write_Off_Cost__c : 0);    
                accList.shortDate5   = accList.shortDate5 + (sd.Vision_M5_Short_Date__c != null ? sd.Vision_M5_Short_Date__c : 0);    
                accList.potenialWriteOff5   = accList.potenialWriteOff5 + (sd.Vision_M5_Potential_Write_Off__c != null ? sd.Vision_M5_Potential_Write_Off__c : 0);    
                accList.writeOffCost5   = accList.writeOffCost5 + (sd.Vision_M5_Write_Off_Cost__c != null ? sd.Vision_M5_Write_Off_Cost__c : 0);    
                accList.shortDate6  = accList.shortDate6 + (sd.Vision_M6_Short_Date__c != null ? sd.Vision_M6_Short_Date__c : 0);    
                accList.potenialWriteOff6   = accList.potenialWriteOff6 + (sd.Vision_M6_Potential_Write_Off__c != null ? sd.Vision_M6_Potential_Write_Off__c : 0);    
                accList.writeOffCost6   = accList.writeOffCost6 + (sd.Vision_M6_Write_Off_Cost__c != null ? sd.Vision_M6_Write_Off_Cost__c : 0);    
                accList.shortDate7   = accList.shortDate7 + (sd.Vision_M7_Short_Date__c != null ? sd.Vision_M7_Short_Date__c : 0);    
                accList.potenialWriteOff7   = accList.potenialWriteOff7 + (sd.Vision_M7_Potential_Write_Off__c != null ? sd.Vision_M7_Potential_Write_Off__c : 0);    
                accList.writeOffCost7   = accList.writeOffCost7 + (sd.Vision_M7_Write_Off_Cost__c != null ? sd.Vision_M7_Write_Off_Cost__c : 0);    
                accList.shortDate8  = accList.shortDate8 + (sd.Vision_M8_Short_Date__c != null ? sd.Vision_M8_Short_Date__c : 0);    
                accList.potenialWriteOff8   = accList.potenialWriteOff8 + (sd.Vision_M8_Potential_Write_Off__c != null ? sd.Vision_M8_Potential_Write_Off__c : 0);    
                accList.writeOffCost8   = accList.writeOffCost8 + (sd.Vision_M8_Write_Off_Cost__c != null ? sd.Vision_M8_Write_Off_Cost__c : 0);  
                accList.shortDate9  = accList.shortDate9 + (sd.Vision_M9_Short_Date__c != null ? sd.Vision_M9_Short_Date__c : 0);    
                accList.potenialWriteOff9   = accList.potenialWriteOff9 + (sd.Vision_M9_Potential_Write_Off__c != null ? sd.Vision_M9_Potential_Write_Off__c : 0);    
                accList.writeOffCost9  = accList.writeOffCost9 + (sd.Vision_M9_Write_Off_Cost__c != null ? sd.Vision_M9_Write_Off_Cost__c : 0);    
                if(prodFamMap.containsKey(sd.GCP_Product_Family__c)){
                    List<Vision_GCP_Short_Date__c> prodList = prodFamMap.get(sd.GCP_Product_Family__c);
                    prodList.add(sd);
                    prodFamMap.put(sd.GCP_Product_Family__c,prodList);
                }
                else{
                    
                    prodFamMap.put(sd.GCP_Product_Family__c,new List<Vision_GCP_Short_Date__c>{sd});
                }
            }
            for(String prodfam : prodFamMap.keySet()){
                productFamily prodFamily = new productFamily();
                prodFamily.pfName = prodfam;
                List<Vision_GCP_Short_Date__c> pfList = prodFamMap.get(prodfam);
                for(Vision_GCP_Short_Date__c pf : pfList){               
                    prodFamily.ftoCost   = prodFamily.ftoCost + (pf.Vision_FTO_Cost_dollar__c != null ? pf.Vision_FTO_Cost_dollar__c : 0);    
                    prodFamily.totalInUnits   = prodFamily.totalInUnits + (pf.Vision_Total_in_Units__c != null ? pf.Vision_Total_in_Units__c : 0);
                    prodFamily.totalInValue   = prodFamily.totalInValue + (pf.Vision_Total_value_dollar__c != null ? pf.Vision_Total_value_dollar__c : 0);    
                    prodFamily.currentMonthOrder   = prodFamily.currentMonthOrder + (pf.Vision_Current_Month_Order_Quantity__c != null ? pf.Vision_Current_Month_Order_Quantity__c : 0);
                    prodFamily.writeOffQty   = prodFamily.writeOffQty + (pf.Vision_qty_written_off__c != null ? pf.Vision_qty_written_off__c : 0);
                    prodFamily.writeOffDollar   = prodFamily.writeOffDollar + (pf.Vision_Dollar_Writen_Off__c != null ? pf.Vision_Dollar_Writen_Off__c : 0);
                    prodFamily.LastMonthWriteOffQty   = prodFamily.LastMonthWriteOffQty + (pf.Vision_Last_Month_Written_Off_QTY__c != null ? pf.Vision_Last_Month_Written_Off_QTY__c : 0);
                    prodFamily.LastMonthWriteOffDollar = prodFamily.LastMonthWriteOffDollar + (pf.Last_Month_Written_Off_Cost__c != null ? pf.Last_Month_Written_Off_Cost__c : 0);
                    prodFamily.shortDate1   = prodFamily.shortDate1 + (pf.Vision_M1_Short_Date__c != null ? pf.Vision_M1_Short_Date__c : 0);    
                    prodFamily.potenialWriteOff1   = prodFamily.potenialWriteOff1 + (pf.Vision_M1_Potential_Write_Off__c != null ? pf.Vision_M1_Potential_Write_Off__c : 0);    
                    prodFamily.writeOffCost1   = prodFamily.writeOffCost1 + (pf.Vision_M1_Write_Off_Cost__c != null ? pf.Vision_M1_Write_Off_Cost__c : 0);    
                    prodFamily.shortDate2  = prodFamily.shortDate2 + (pf.Vision_M2_Short_Date__c != null ? pf.Vision_M2_Short_Date__c : 0);    
                    prodFamily.potenialWriteOff2   = prodFamily.potenialWriteOff2 + (pf.Vision_M2_Potential_Write_Off__c != null ? pf.Vision_M2_Potential_Write_Off__c : 0);    
                    prodFamily.writeOffCost2   = prodFamily.writeOffCost2 + (pf.Vision_M2_Write_Off_Cost__c != null ? pf.Vision_M2_Write_Off_Cost__c : 0);    
                    prodFamily.shortDate3   = prodFamily.shortDate3 + (pf.Vision_M3_Short_Date__c != null ? pf.Vision_M3_Short_Date__c : 0);    
                    prodFamily.potenialWriteOff3   = prodFamily.potenialWriteOff3 + (pf.Vision_M3_Potential_Write_Off__c != null ? pf.Vision_M3_Potential_Write_Off__c : 0);    
                    prodFamily.writeOffCost3   = prodFamily.writeOffCost3 + (pf.Vision_M3_Write_Off_Cost__c != null ? pf.Vision_M3_Write_Off_Cost__c : 0);    
                    prodFamily.shortDate4  = prodFamily.shortDate4 + (pf.Vision_M4_Short_Date__c != null ? pf.Vision_M4_Short_Date__c : 0);    
                    prodFamily.potenialWriteOff4   = prodFamily.potenialWriteOff4 + (pf.Vision_M4_Potential_Write_Off__c != null ? pf.Vision_M4_Potential_Write_Off__c : 0);    
                    prodFamily.writeOffCost4   = prodFamily.writeOffCost4 + (pf.Vision_M4_Write_Off_Cost__c != null ? pf.Vision_M4_Write_Off_Cost__c : 0);    
                    prodFamily.shortDate5   = prodFamily.shortDate5 + (pf.Vision_M5_Short_Date__c != null ? pf.Vision_M5_Short_Date__c : 0);    
                    prodFamily.potenialWriteOff5   = prodFamily.potenialWriteOff5 + (pf.Vision_M5_Potential_Write_Off__c != null ? pf.Vision_M5_Potential_Write_Off__c : 0);    
                    prodFamily.writeOffCost5   = prodFamily.writeOffCost5 + (pf.Vision_M5_Write_Off_Cost__c != null ? pf.Vision_M5_Write_Off_Cost__c : 0);    
                    prodFamily.shortDate6  = prodFamily.shortDate6 + (pf.Vision_M6_Short_Date__c != null ? pf.Vision_M6_Short_Date__c : 0);    
                    prodFamily.potenialWriteOff6   = prodFamily.potenialWriteOff6 + (pf.Vision_M6_Potential_Write_Off__c != null ? pf.Vision_M6_Potential_Write_Off__c : 0);    
                    prodFamily.writeOffCost6   = prodFamily.writeOffCost6 + (pf.Vision_M6_Write_Off_Cost__c != null ? pf.Vision_M6_Write_Off_Cost__c : 0);    
                    prodFamily.shortDate7   = prodFamily.shortDate7 + (pf.Vision_M7_Short_Date__c != null ? pf.Vision_M7_Short_Date__c : 0);    
                    prodFamily.potenialWriteOff7   = prodFamily.potenialWriteOff7 + (pf.Vision_M7_Potential_Write_Off__c != null ? pf.Vision_M7_Potential_Write_Off__c : 0);    
                    prodFamily.writeOffCost7   = prodFamily.writeOffCost7 + (pf.Vision_M7_Write_Off_Cost__c != null ? pf.Vision_M7_Write_Off_Cost__c : 0);    
                    prodFamily.shortDate8  = prodFamily.shortDate8 + (pf.Vision_M8_Short_Date__c != null ? pf.Vision_M8_Short_Date__c : 0);    
                    prodFamily.potenialWriteOff8   = prodFamily.potenialWriteOff8 + (pf.Vision_M8_Potential_Write_Off__c != null ? pf.Vision_M8_Potential_Write_Off__c : 0);    
                    prodFamily.writeOffCost8   = prodFamily.writeOffCost8 + (pf.Vision_M8_Write_Off_Cost__c != null ? pf.Vision_M8_Write_Off_Cost__c : 0);  
                    prodFamily.shortDate9  = prodFamily.shortDate9 + (pf.Vision_M9_Short_Date__c != null ? pf.Vision_M9_Short_Date__c : 0);    
                    prodFamily.potenialWriteOff9   = prodFamily.potenialWriteOff9 + (pf.Vision_M9_Potential_Write_Off__c != null ? pf.Vision_M9_Potential_Write_Off__c : 0);    
                    prodFamily.writeOffCost9  = prodFamily.writeOffCost9 + (pf.Vision_M9_Write_Off_Cost__c != null ? pf.Vision_M9_Write_Off_Cost__c : 0);
                }
                prodFamily.sdpfist = pfList;
                listProductFamily.add(prodFamily);
            }
            //system.debug('listProductFamily before size-->'+listProductFamily.size());
            accList.productFamily=listProductFamily;
            listProductFamily = new List<productFamily>();
            prodFamMap = new map<String,List<Vision_GCP_Short_Date__c>>();
            //system.debug('listProductFamily after size-->'+listProductFamily.size());
            AccountsWrapperList.add(accList);
            
        }
        system.debug('AccountsWrapperList---'+AccountsWrapperList);
        mainWrapper.accList = AccountsWrapperList;      
        mainWrapper.noOfRecords = listOfGCPShortRecords.size();               
        return mainWrapper;
    } 
    public class Wrapper {
        
        @AuraEnabled public List < Vision_GCP_Short_Date__c > gcpShortDates; 
        @AuraEnabled public List < string > accountList; 
        @AuraEnabled public List < string > prodFamilyList; 
        
        Wrapper() {
            
            gcpShortDates = new List < Vision_GCP_Short_Date__c > ();
            accountList = new List < string > ();
            prodFamilyList = new List < string > ();
            
        }
    } 
    public class MainWrapper{
        //@AuraEnabled public String headerName;
        @AuraEnabled public Boolean isProcessed;
        @AuraEnabled public Integer noOfRecords = 0;
        @AuraEnabled public Decimal totalValue3MonPW = 0;
        @AuraEnabled public Decimal totalWrittenOffDollar9MonPW = 0;
        @AuraEnabled public Decimal totalValue9MonPW = 0;
        @AuraEnabled public Decimal totalWrittenOffDollar3MonPW = 0;
        @AuraEnabled public Decimal totalValue3MonShowAll = 0;
        @AuraEnabled public Decimal totalWrittenOffDollar9MonShowAll = 0;
        @AuraEnabled public Decimal totalValue9MonShowAll = 0;
        @AuraEnabled public Decimal totalWrittenOffDollar3MonShowAll = 0;
        @AuraEnabled public List<AccountsList> accList;
        @AuraEnabled public List<AccountsWrapper> accgrpList;
        @AuraEnabled public Vision_GCP_Short_Date__c sdRecords;
        mainWrapper(){
            sdRecords = new Vision_GCP_Short_Date__c();
            accList = new List<AccountsList>();
            accgrpList = new List<AccountsWrapper>();
        }
    }
    Public Class AccountsWrapper{
        @AuraEnabled public Decimal totalInValue3MonthsAcc = 0;
        @AuraEnabled public String accGroupName;   
        @AuraEnabled public Decimal totalInValue9MonthsAcc = 0; 
        @AuraEnabled public Decimal writeOffQtyAcc3MonPW = 0;
        @AuraEnabled public Decimal writeOffDollarAcc3MonPW = 0;
        @AuraEnabled public Decimal writeOffQtyAcc9MonPW = 0;
        @AuraEnabled public Decimal writeOffDollarAcc9MonPW = 0;
        @AuraEnabled public Decimal writeOffQtyAccShowAll = 0;
        @AuraEnabled public Decimal writeOffDollarAccShowAll = 0;
    }
    Public Class AccountsList{
        @AuraEnabled public String accName;
        @AuraEnabled public Decimal ftoCost = 0;
        @AuraEnabled public Decimal totalInUnits = 0;
        @AuraEnabled public Decimal totalInValue = 0;
        @AuraEnabled public Decimal currentMonthOrder = 0; 
        @AuraEnabled public Decimal writeOffQty = 0;
        @AuraEnabled public Decimal writeOffDollar = 0;
        @AuraEnabled public Decimal LastMonthWriteOffQty = 0;
        @AuraEnabled public Decimal LastMonthWriteOffDollar = 0;
        @AuraEnabled public Decimal shortDate1 = 0;
        @AuraEnabled public Decimal potenialWriteOff1 = 0;
        @AuraEnabled public Decimal writeOffCost1 = 0;
        @AuraEnabled public Decimal shortDate2 = 0;
        @AuraEnabled public Decimal potenialWriteOff2 = 0;
        @AuraEnabled public Decimal writeOffCost2 = 0;
        @AuraEnabled public Decimal shortDate3 = 0;
        @AuraEnabled public Decimal potenialWriteOff3 = 0;
        @AuraEnabled public Decimal writeOffCost3 = 0;
        @AuraEnabled public Decimal shortDate4 = 0;
        @AuraEnabled public Decimal potenialWriteOff4 = 0;
        @AuraEnabled public Decimal writeOffCost4 = 0;
        @AuraEnabled public Decimal shortDate5 = 0;
        @AuraEnabled public Decimal potenialWriteOff5 = 0;
        @AuraEnabled public Decimal writeOffCost5 = 0;
        @AuraEnabled public Decimal shortDate6 = 0;
        @AuraEnabled public Decimal potenialWriteOff6 = 0;
        @AuraEnabled public Decimal writeOffCost6 = 0;
        @AuraEnabled public Decimal shortDate7 = 0;
        @AuraEnabled public Decimal potenialWriteOff7 = 0;
        @AuraEnabled public Decimal writeOffCost7 = 0;
        @AuraEnabled public Decimal shortDate8 = 0;
        @AuraEnabled public Decimal potenialWriteOff8 = 0;
        @AuraEnabled public Decimal writeOffCost8 = 0;
        @AuraEnabled public Decimal shortDate9 = 0;
        @AuraEnabled public Decimal potenialWriteOff9 = 0;
        @AuraEnabled public Decimal writeOffCost9 = 0;
        @AuraEnabled public Decimal totalInUnits3Months = 0;
        @AuraEnabled public Decimal totalInValue3Months = 0;
        @AuraEnabled public Boolean showAccount;
        @AuraEnabled public List<productFamily> productFamily;
        AccountsList(){
            productFamily = new List<productFamily>();
            showAccount = true;
        }
    }
    Public Class productFamily{
        @AuraEnabled public String pfName;
        @AuraEnabled public Decimal ftoCost = 0;
        @AuraEnabled public Decimal totalInUnits = 0;
        @AuraEnabled public Decimal totalInValue = 0;
        @AuraEnabled public Decimal currentMonthOrder = 0;
        @AuraEnabled public Decimal writeOffQty = 0;
        @AuraEnabled public Decimal writeOffDollar = 0;
        @AuraEnabled public Decimal LastMonthWriteOffQty = 0;
        @AuraEnabled public Decimal LastMonthWriteOffDollar = 0;
        @AuraEnabled public Decimal shortDate1 = 0;
        @AuraEnabled public Decimal potenialWriteOff1 = 0;
        @AuraEnabled public Decimal writeOffCost1 = 0;
        @AuraEnabled public Decimal shortDate2 = 0;
        @AuraEnabled public Decimal potenialWriteOff2 = 0;
        @AuraEnabled public Decimal writeOffCost2 = 0;
        @AuraEnabled public Decimal shortDate3 = 0;
        @AuraEnabled public Decimal potenialWriteOff3 = 0;
        @AuraEnabled public Decimal writeOffCost3 = 0;
        @AuraEnabled public Decimal shortDate4 = 0;
        @AuraEnabled public Decimal potenialWriteOff4 = 0;
        @AuraEnabled public Decimal writeOffCost4 = 0;
        @AuraEnabled public Decimal shortDate5 = 0;
        @AuraEnabled public Decimal potenialWriteOff5 = 0;
        @AuraEnabled public Decimal writeOffCost5 = 0;
        @AuraEnabled public Decimal shortDate6 = 0;
        @AuraEnabled public Decimal potenialWriteOff6 = 0;
        @AuraEnabled public Decimal writeOffCost6 = 0;
        @AuraEnabled public Decimal shortDate7 = 0;
        @AuraEnabled public Decimal potenialWriteOff7 = 0;
        @AuraEnabled public Decimal writeOffCost7 = 0;
        @AuraEnabled public Decimal shortDate8 = 0;
        @AuraEnabled public Decimal potenialWriteOff8 = 0;
        @AuraEnabled public Decimal writeOffCost8 = 0;
        @AuraEnabled public Decimal shortDate9 = 0;
        @AuraEnabled public Decimal potenialWriteOff9 = 0;
        @AuraEnabled public Decimal writeOffCost9 = 0;
        @AuraEnabled public Boolean showProdFam;
        @AuraEnabled public List<Vision_GCP_Short_Date__c> sdpfist;
        productFamily(){
            sdpfist = new List<Vision_GCP_Short_Date__c>();
            showProdFam = true;
        }
        
    }
    
}