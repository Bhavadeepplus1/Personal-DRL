public class Vision_ShareExpansion_cntl {
    
    @auraEnabled
    public static list<Vision_Market_Share_Expansion__c> saveNdcWithBidTemplate(list<Vision_Market_Share_Expansion__c> ndcValues, String accId){
        update ndcValues; return ndcValues;
    }
    
    @auraEnabled
    public static list<wrapper> getExpansionData(String accId, List<String> picliList, boolean showAllData){
        String accObjQuery = 'SELECT '+Phoenix_Util.getsObjectFieds('Account')+'FROM Account WHERE Id=: accId';
        Account accObj = Database.query(accObjQuery);
        List<String> accIds = new List<String>();
        accIds.add(accId);
        if(showAllData){
            List<Account> accList = [SELECT Id,Name,parentid FROM Account WHERE parentid =: accId];
            for(Account acc : accList){
                accIds.add(acc.Id);
            }
        }
        String query;
            query = 'SELECT Vision_Customer__r.Name, Vision_Customer__r.Phoenix_Customer_Class_Bid_Template__c,Vision_Product__r.Name, Vision_Product__r.ProductCode, Vision_Product__r.Phoenix_Is_Control_Label__c, '+
            +'Vision_Product__r.Phoenix_GPI_Generic_Product_Identifier__c, Vision_Product__r.Phoenix_GCN_Generic_Code_Number__c,Vision_Product__r.Phoenix_Is_Private_Label_OTC__c,'+
            +'Vision_Product__r.Phoenix_GCN_Sequence_Number__c, Vision_Product__r.Family,Vision_Product__r.Phoenix_Strength__c,Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+
            +'Vision_Product__r.Phoenix_Lowest_Price_SKU__c, Vision_Product__r.Description,ProductOpportunity__r.Opportunity__r.Name,ProductOpportunity__r.Opportunity__r.Id,'+
            +'Vision_Product__r.Phoenix_NDC_11__c, Vision_Product__r.Phoenix_Pkg_Size__c,'+Phoenix_Util.getsObjectFieds('Vision_Market_Share_Expansion__c')+' FROM Vision_Market_Share_Expansion__c'+
            +' WHERE Vision_Customer__c IN: accIds AND Vision_Product__r.Phoenix_Is_Exclude_Bid__c != true AND Vision_Product__c != null AND Task_Ident__c != null ORDER BY createdDate DESC';
        
        List<Vision_Market_Share_Expansion__c> markShareList = database.query(query);
        
        Map<String, list<Vision_Market_Share_Expansion__c>> expListMap = new Map<String, list<Vision_Market_Share_Expansion__c>>();
        for(Vision_Market_Share_Expansion__c expnObj : markShareList){
            if(!expListMap.containsKey(expnObj.Task_Ident__c))//Vision_Product_Family__c
                expListMap.put(expnObj.Task_Ident__c, new List<Vision_Market_Share_Expansion__c>());
            expListMap.get(expnObj.Task_Ident__c).add(expnObj);
        }
        list<wrapper> wrapList = new List<wrapper>();
        for(String famName : expListMap.keySet()){
            wrapper wrapObj = new wrapper();
            wrapObj.prodFamilyName = famName;
            for(Vision_Market_Share_Expansion__c shareExpObj : expListMap.get(famName)){
                if(shareExpObj.Task_Status__c != 'New'){
                    wrapObj.statusString = shareExpObj.Task_Status__c == 'dropped' ? 'Dropped' : shareExpObj.Task_Status__c;
                    wrapObj.oppName = shareExpObj.ProductOpportunity__r.Opportunity__r.Name;
                    wrapObj.oppId = shareExpObj.ProductOpportunity__r.Opportunity__r.Id;
                    break;
                }
            }
            wrapObj.expnList = expListMap.get(famName);
            wrapList.add(wrapObj);
        }
        if(wrapList.size()>0)
            wrapList[0].accObj = accObj;
        wrapList[0].doesChildAccExist = accIds.size()>1 ? true : false;
        return wrapList;
    }
    
    public class wrapper{
        @auraEnabled
        public list<Vision_Market_Share_Expansion__c> expnList;
        @auraEnabled
        public String prodFamilyName; 
        @auraEnabled
        public Vision_Market_Share_Expansion__c expnObj;
        @auraEnabled 
        public Account accObj;
        @auraEnabled
        public String oppName;
        @auraEnabled
        public String oppId;
        @auraEnabled
        public string statusString = 'New';
        @auraEnabled
        public boolean doesChildAccExist = false;
    }
    
    @auraEnabled
    public static string createOptyCntl(list<Vision_Market_Share_Expansion__c> prodList, String bidType, Integer totalVol, String internalTargetDate, List<String> selectrcs, String templateType){
        try{
            list<Opportunity> optyList = [SELECT Id, Name FROM opportunity WHERE Name Like '%-MSEmove-%'];
            integer autoNum = 0;
            if(optyList.size()>0){
                for(Opportunity optyObj : optyList){
                    String optyName = optyObj.Name;
                    Integer numberVal = Integer.valueOf(optyName.substringAfterLast('MSEmove-'));
                    if(numberVal>autoNum){
                        autoNum = numberVal;
                    }
                }
                autoNum = autoNum+1;
            }
            
            Opportunity optyRec = new Opportunity();
            
            optyRec.StageName = 'Opportunity in progress';
            optyRec.Vision_Bid_Template__c = templateType;//prodList[0].Vision_Customer_Template__c;//Vision_Customer__r.Phoenix_Customer_Class_Bid_Template__c;
            optyRec.Vision_Type__c = 'Proactive';
            optyRec.Vision_Opportunity_Source__c = 'Panorama-Market Share Expansion';
            optyRec.Name = prodList[0].Vision_Product_Family__c+'-MSEmove-000'+autoNum;
            optyRec.AccountId = prodList[0].Vision_Customer__c;
            optyRec.closeDate = Date.valueOf(internalTargetDate);
            optyRec.Vision_Internal_Closing_Date__c = Date.valueOf(internalTargetDate);
            optyRec.Vision_Reference_Contract__c = string.join(selectrcs, ',');
            optyRec.Bid_Type__c = 'Product Addition';//bidType; 
            insert optyRec;
            
            list<Vision_Market_Share_Expansion__c> updateList = new list<Vision_Market_Share_Expansion__c>();
            
            List<Product_Opportunity__c> savedPrdOptyRecs = new List<Product_Opportunity__c>();
            Integer optyValue = 0;
            List<Vision_Market_Share_Expansion__c> updateListShareExp = new List<Vision_Market_Share_Expansion__c>();
            Map<Id, Vision_Market_Share_Expansion__c> updateMrtShareMap = new Map<Id, Vision_Market_Share_Expansion__c>();
            for (Vision_Market_Share_Expansion__c wr: prodList) {
                if(wr.Vision_isAccepted__c){// && wr.ProductOpportunity__c == null){
                    Product_Opportunity__c productOpportunity = new Product_Opportunity__c();
                    productOpportunity.Name = wr.Vision_Product__r.Name;
                    productOpportunity.GCN_Generic_Code_Number__c = wr.Vision_Product__r.Phoenix_GCN_Generic_Code_Number__c;
                    productOpportunity.GSN__c = wr.Vision_Product__r.Phoenix_GCN_Sequence_Number__c;
                    productOpportunity.GPI_Generic_Product_Identifier__c = wr.Vision_Product__r.Phoenix_GPI_Generic_Product_Identifier__c;
                    productOpportunity.NDC_11__c = wr.Vision_Product__r.Phoenix_NDC_11__c;
                    productOpportunity.SKU_Number__c = wr.Vision_Product__r.ProductCode;
                    productOpportunity.Product_Family__c = wr.Vision_Product__r.Family;
                    productOpportunity.Lowest_Price_SKU__c = wr.Vision_Product__r.Phoenix_Lowest_Price_SKU__c;
                    productOpportunity.Strength__c = wr.Vision_Product__r.Phoenix_Strength__c;
                    productOpportunity.Pkg_Size__c = wr.Vision_Product__r.Phoenix_Pkg_Size__c;
                    productOpportunity.Product_Description__c = wr.Vision_Product__r.Description;
                    
                    productOpportunity.Proposed_Direct_Selling_Units__c = wr.Proposed_Direct_Selling_Units__c;
                    productOpportunity.Proposed_Indirect_Selling_Units__c = wr.Proposed_Indirect_Selling_Units__c;
                    productOpportunity.Vision_Proposed_OS_Units__c = wr.Vision_Proposed_OS_Units__c;
                    productOpportunity.Vision_Proposed_RAD_Units__c = wr.Vision_Proposed_RAD_Units__c;
                    productOpportunity.Vision_Proposed_WMT_Units__c = wr.Vision_Proposed_WMT_Units__c;
                    productOpportunity.Vision_Proposed_BASE_Units__c = wr.Vision_Proposed_BASE_Units__c;
                    productOpportunity.Vision_Proposed_DSH_Units__c = wr.Vision_Proposed_DSH_Units__c;
                    productOpportunity.Vision_Proposed_AutoSub_Units__c = wr.Vision_Proposed_AutoSub_Units__c;
                    productOpportunity.Vision_Proposed_Smith_Drug_Units__c = wr.Vision_Proposed_Smith_Drug_Units__c;
                    productOpportunity.Vision_Proposed_Anda_Units__c = wr.Vision_Proposed_Anda_Units__c;
                    productOpportunity.Vision_Proposed_DirectAholdDelhaizeUnits__c = wr.Vision_Proposed_DirectAholdDelhaizeUnits__c;
                    productOpportunity.Vision_Proposed_Direct_Gaint_Eagle_Units__c = wr.Vision_Proposed_Direct_Gaint_Eagle_Units__c;
                    productOpportunity.Vision_Proposed_TotalRetailIndirectUnits__c = wr.Vision_Proposed_TotalRetailIndirectUnits__c;
                    
                    productOpportunity.Vision_Proposed_CVS_Direct_Units__c = wr.Vision_Proposed_CVS_Direct_Units__c;
                    productOpportunity.Vision_Proposed_CVS_Indirect_Units__c = wr.Vision_Proposed_CVS_Indirect_Units__c;
                    productOpportunity.Vision_Proposed_Cardinal_Units__c = wr.Vision_Proposed_Cardinal_Units__c;
                    productOpportunity.Vision_Proposed_Major_Units__c = wr.Vision_Proposed_Major_Units__c;
                    
                    productOpportunity.Vision_Proposed_Direct_ESI_Units__c = wr.Vision_Proposed_Direct_ESI_Units__c;
                    productOpportunity.Vision_Proposed_Indirect_ESI_Units__c = wr.Vision_Proposed_Indirect_ESI_Units__c;
                    productOpportunity.Vision_Proposed_Direct_Kroger_Units__c = wr.Vision_Proposed_Direct_Kroger_Units__c;
                    productOpportunity.Vision_Proposed_Indirect_Kroger_Units__c = wr.Vision_Proposed_Indirect_Kroger_Units__c;
                    productOpportunity.Vision_Proposed_Direct_Rx_Outreach_Units__c = wr.Vision_Proposed_Direct_Rx_Outreach_Units__c;
                    productOpportunity.Vision_Proposed_IndirectRxOutreach_Units__c = wr.Vision_Proposed_IndirectRxOutreach_Units__c;
                    productOpportunity.Vision_Proposed_Direct_Supervalu_Units__c = wr.Vision_Proposed_Direct_Supervalu_Units__c;
                    productOpportunity.Vision_Proposed_Indirect_Supervalu_Units__c = wr.Vision_Proposed_Indirect_Supervalu_Units__c;
                    productOpportunity.Vision_Proposed_Direct_Cigna_Units__c = wr.Vision_Proposed_Direct_Cigna_Units__c;
                    productOpportunity.Vision_Proposed_Indirect_Cigna_Units__c = wr.Vision_Proposed_Indirect_Cigna_Units__c;
                    productOpportunity.Vision_Proposed_Direct_Cordant_Units__c = wr.Vision_Proposed_Direct_Cordant_Units__c;
                    productOpportunity.Vision_Proposed_Indirect_Cordant_Units__c = wr.Vision_Proposed_Indirect_Cordant_Units__c;
                    productOpportunity.Vision_Proposed_Direct_Accerodo_Units__c = wr.Vision_Proposed_Direct_Accerodo_Units__c;
                    productOpportunity.Vision_Proposed_Indirect_Accerodo_Units__c = wr.Vision_Proposed_Indirect_Accerodo_Units__c;
                    productOpportunity.Vision_Proposed_Units__c = wr.Vision_Proposed_Volume__c;
                    productOpportunity.Vision_Proposed_Share_Percentage__c = wr.Vision_Proposed_Share_Percentage__c;
                    productOpportunity.Vision_Panorama_Target_Price__c = wr.Target_Price__c;
                    
                    
                    //Fields Added by BV
                     productOpportunity.Vision_scm_manager__c = wr.Vision_scm_manager__c;
                     productOpportunity.Vision_scm_approved_date__c = wr.Vision_scm_approved_date__c;
                     productOpportunity.Vision_supply_requirement__c = wr.Vision_supply_requirement__c;
                     productOpportunity.Vision_confidence_level__c = wr.Vision_confidence_level__c;
                     productOpportunity.Vision_customer_expectation_lead_time__c = wr.Vision_customer_expectation_lead_time__c;
                     productOpportunity.Vision_supply_effectivedate_SCM__c = wr.Vision_supply_effectivedate_SCM__c;
                     productOpportunity.Vision_remarks_by_pm__c = wr.Vision_remarks_by_pm__c;
                     productOpportunity.Vision_remarks_by_scm__c = wr.Vision_remarks_by_scm__c;
                     productOpportunity.Vision_total_incremental_volume_by_scm__c = wr.Vision_total_incremental_volume_by_scm__c;
                     productOpportunity.Vision_total_initial_order_quantity_by_s__c = wr.Vision_total_initial_order_quantity_by_s__c;
                     productOpportunity.Vision_supply_duration_scm__c = wr.Vision_supply_duration_scm__c;
                     productOpportunity.Vision_sku_split_flag__c = wr.Vision_sku_split_flag__c;
                     productOpportunity.Vision_incremental_volume_by_scm__c = wr.Vision_incremental_volume_by_scm__c;
                     productOpportunity.Vision_initialorder_volume_by_scm__c = wr.Vision_initialorder_volume_by_scm__c;
                     productOpportunity.Vision_india_scm_approved_by__c = wr.Vision_india_scm_approved_by__c;
                     productOpportunity.Vision_india_scm_approved_on_date__c = wr.Vision_india_scm_approved_on_date__c;
                     productOpportunity.Vision_india_scm_remarks__c = wr.Vision_india_scm_remarks__c;
                     productOpportunity.Vision_ext_mfg_scm_approved_by__c = wr.Vision_ext_mfg_scm_approved_by__c;
                     productOpportunity.Vision_ext_mfg_scm_approved_on_date__c = wr.Vision_ext_mfg_scm_approved_on_date__c;
                     productOpportunity.Vision_ext_mfg_scm_remarks__c = wr.Vision_ext_mfg_scm_remarks__c;
                    //Fields Ended By BV
                    
                    /*Decimal totalPropVolume = wr.Proposed_Direct_Selling_Units__c+wr.Proposed_Indirect_Selling_Units__c+wr.Vision_Proposed_OS_Units__c
+wr.Vision_Proposed_RAD_Units__c+wr.Vision_Proposed_WMT_Units__c+wr.Vision_Proposed_BASE_Units__c+wr.Vision_Proposed_DSH_Units__c
+wr.Vision_Proposed_AutoSub_Units__c+wr.Vision_Proposed_Smith_Drug_Units__c+wr.Vision_Proposed_Anda_Units__c+wr.Vision_Proposed_DirectAholdDelhaizeUnits__c
+wr.Vision_Proposed_Direct_Gaint_Eagle_Units__c+wr.Vision_Proposed_TotalRetailIndirectUnits__c;
productOpportunity.Vision_Opportunity_Value__c = productOpportunity.Lowest_Price_SKU__c*totalPropVolume;*/
                    
                    productOpportunity.Vision_Opportunity_Value__c = wr.Vision_Proposed_Value_EA__c;
                    optyValue = optyValue + Integer.valueOf(productOpportunity.Vision_Opportunity_Value__c);
                    Id prodID =  wr.Vision_Product__c;
                    productOpportunity.Product__c = prodID;
                    productOpportunity.Market_Share_Expansion__c = wr.Id;
                    productOpportunity.Opportunity__c = optyRec.Id;
                    productOpportunity.Status__c = 'Matched';
                    savedPrdOptyRecs.add(productOpportunity);
                    
                    wr.Task_Status__c = 'Sent to OPPORTUNITY';
                    updateMrtShareMap.put(prodID, wr);
                }
                //else
                //updateList.add(wr);
            }
            
            if(savedPrdOptyRecs.size() > 0){
                insert savedPrdOptyRecs;
            }
            for(Product_Opportunity__c optyProd : savedPrdOptyRecs){
                if(updateMrtShareMap.containsKey(optyProd.Product__c)){
                    Vision_Market_Share_Expansion__c mktShareObj = updateMrtShareMap.get(optyProd.Product__c);
                    mktShareObj.ProductOpportunity__c = optyProd.Id;
                    mktShareObj.Vision_Internal_Target_Date__c = Date.valueOf(internalTargetDate);
                    mktShareObj.Task_Status__c = 'Sent to OPPORTUNITY';
                    updateListShareExp.add(mktShareObj);
                }
            }
            optyRec.Vision_Opportunity_Value__c = optyValue;
            update optyRec;
            //update updateList;
            update updateListShareExp;
            return ''+optyRec.Id;
        }
        catch(exception e){
            return 'ERROR: Unable to Create Opportunity. Exception: '+e.getMessage();
        }
    }
    
    public class commentWrapper{
        @auraEnabled
        public Vision_Market_Share_Expansion__c shareExpanObj;
        @auraEnabled
        public boolean isError = false;
        @auraEnabled
        public string errorMessage = '';
    }
    
    @AuraEnabled
    public static List < Phoenix_Contract__c > getContracts(string customerID, string searchInput,string templateType) {
        string act = 'Active';
        boolean isExcludeContract = false;
        string query = '';
        if(templateType == 'ROS' || templateType == 'ClarusOne' || templateType == 'Econdisc'){
             query  = 'select Id, name,Phoenix_Contract_Internal_Description__c,Phoenix_Contract_Number__c,Phoenix_Contract_External_Description__c, Phoenix_Customer__c, Phoenix_Customer__r.Name from Phoenix_Contract__c where Phoenix_Contract_Status__c=:act AND Phoenix_Is_Exclude_Contract__c=:isExcludeContract';
        }else{
            query  = 'select Id, name,Phoenix_Contract_Internal_Description__c,Phoenix_Contract_Number__c,Phoenix_Contract_External_Description__c, Phoenix_Customer__c, Phoenix_Customer__r.Name from Phoenix_Contract__c where Phoenix_Contract_Status__c=:act';
        }
        
        if (customerID != null) {
            Set < Id > parentAccIds = new Set < Id > ();
            parentAccIds.add(customerID);
            //Fetch related accounts
            Map < Id, Account > allAccMap = new Map < Id, Account > ();
            //Map of all accounts
            for (Account acc: Database.query('SELECT ' + Phoenix_Util.customerFields + ' FROM Account LIMIT 10000'))
                allAccMap.put(acc.Id, acc);
            String tempId = customerID;
            
            while (allAccMap.get(tempId) != NULL && allAccMap.get(tempId).ParentId != NULL) {
                tempId = allAccMap.get(tempId).ParentId;
                parentAccIds.add(tempId);
            }
            if(allAccMap != null && allAccMap.size()>0){
                for(Account acc: allAccMap.values()){
                    if(acc.ParentId != null && (acc.ParentId == tempId || (allAccMap.get(acc.ParentId) != null && allAccMap.get(acc.ParentId).ParentId != null && allAccMap.get(acc.ParentId).ParentId == tempId)) )
                        parentAccIds.add(acc.Id);
                }
            }
            query += ' and (Phoenix_Customer__c=:parentAccIds)'; // or Phoenix_Customer__r.ParentId=:parentAccIds
        }
        if (string.isNotBlank(searchInput) && searchInput != '') {
            query += ' and ( name like \'%' + searchInput + '%\' or Phoenix_Contract_Number__c like \'%' + searchInput + '%\' or Phoenix_Customer__r.Name like \'%' + searchInput + '%\' or Phoenix_Contract_Internal_Description__c like \'%' + searchInput + '%\' or Phoenix_Contract_External_Description__c like  \'%' + searchInput + '%\')';
        }
        List < Phoenix_Contract__c > cntList = Database.query(query);
        return cntList;
    }
    @auraEnabled
    public static list<Vision_Market_Share_Expansion__c> saveShareExpWithContracts(List<string> selectrcs, List<Vision_Market_Share_Expansion__c> ndcValues, String accId){
        Account accObj = [SELECT Id, Phoenix_Is_OTC_Customer__c, Phoenix_Customer_Class_Bid_Template__c FROM Account WHERE Id =: accId];
        Boolean isOtcCx = false;
        for(Vision_Market_Share_Expansion__c prodObj : ndcValues){
            if(prodObj.Vision_Product__r.Phoenix_Rx_SRx_OTC__c == 'OTC' && prodObj.Vision_Product__r.Phoenix_Is_Private_Label_OTC__c){
                isOtcCx = true;
                break;
            }
        }
        
        String templateType = isOtcCx ? 'otcCx' : accObj.Phoenix_Customer_Class_Bid_Template__c;
        
        List<Vision_Market_Share_Expansion__c> updateList = new List<Vision_Market_Share_Expansion__c>();
        List<Vision_Market_Share_Expansion__c> nonUpdateList = new List<Vision_Market_Share_Expansion__c>();
        /*String conString = String.join(selectrcs,',');
             
        List<String> cntrNumList = new List<String>();
        List<Phoenix_Contract__c> conractList = new List<Phoenix_Contract__c>();
        if(String.isNotBlank(conString)){
            for(String cntr : conString.split(',')){
                cntrNumList.add(cntr);
            }
        }
        if(cntrNumList.size() > 0){
            String query1 = 'SELECT Id,Name,Phoenix_Contract_Number__c FROM Phoenix_Contract__c WHERE Phoenix_Contract_Number__c=: cntrNumList';
            conractList = database.query(query1);
        }
        List<String> conIds = new List<String>();
        for(Phoenix_Contract__c conObj : conractList){
            conIds.add(conObj.Id);
        }*/
                                                                                  
        list < Phoenix_NPR_Data__c > NPRDataLines = [select id, Name, Phoenix_Contract_Number__c, Phoenix_Contract_Type__c, Phoenix_12Months_Actual_Sales_Unit__c, Phoenix_12Mt_Sales_Ut_Actual__c, Phoenix_Product_Position__c, Phoenix_Net_Sales_Internal__c, Phoenix_Dead_Net_Tracking_GR__c,
                                                     Phoenix_Contract_Price__c, Phoenix_Product__c, Phoenix_Product__r.ProductCode, Phoenix_12Months_Sales_Unit__c, Phoenix_12Months_Net_Sales__c, Phoenix_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Rebate__c, Phoenix_Rebate_G_N_Indicator__c,
                                                     Phoenix_Bonafied_G_N_Indicator__c, Phoenix_Fee_Bonafied_Fee__c, Phoenix_Per_Unit_Bonfied_Fee__c, Phoenix_CD__c, Phoenix_GR_TrackingTier__c
                                                     from Phoenix_NPR_Data__c where Phoenix_Contract_Number__c IN: selectrcs and Phoenix_NPR_Status__c = 'Active'];
        map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
        for (Phoenix_NPR_Data__c NPRLine: NPRDataLines) {
            if (!productCodeToNPRLineMap.containsKey(NPRLine.Phoenix_Product__c))
                productCodeToNPRLineMap.put(NPRLine.Phoenix_Product__c, new list < Phoenix_NPR_Data__c > ());
            productCodeToNPRLineMap.get(NPRLine.Phoenix_Product__c).add(NPRLine);
        }
        for(Vision_Market_Share_Expansion__c prodObj : ndcValues){
            if (!selectrcs.isEmpty() && prodObj.ProductOpportunity__c == null && prodObj.Task_Status__c == 'New') {
                List < String > selectrcsWithoutDup = new List < String > ();
                String selectedContNames = String.isNotBlank(prodObj.Vision_Reference_Contracts__c) && prodObj.Vision_Reference_Contracts__c != null ? prodObj.Vision_Reference_Contracts__c : '';
                for (String s: selectrcs) {
                    if (string.isNotBlank(selectedContNames) && !selectedContNames.contains(s)) {
                        selectrcsWithoutDup.add(s);
                    }
                }
                if (string.isNotBlank(selectedContNames) && !selectrcsWithoutDup.isEmpty())
                    selectedContNames += ',';
                if (string.isBlank(selectedContNames)) {
                    selectedContNames += string.join(selectrcs, ',');
                }
                else {
                    selectedContNames += string.join(selectrcsWithoutDup, ',');
                }
                prodObj.Vision_Reference_Contracts__c = selectedContNames;
            }
            if(productCodeToNPRLineMap.containsKey(prodObj.Vision_Product__c) && 
               prodObj.ProductOpportunity__c == null && prodObj.Task_Status__c == 'New'){
                   prodObj.X3Months_Annualized_Indirect_Selling_Uni__c = 0;
                   prodObj.X3_Months_Annualized_Direct_Selling_Unit__c = 0;
                   prodObj.X3_Months_Annualized_OS_And_RAD_Units__c = 0;
                   prodObj.X3_Months_Annualized_WMT_Direct_Units__c = 0;
                   prodObj.X3_Months_Annualized_WMT_Indirect_Units__c = 0;
                   prodObj.Current_Wholesaler_Units__c = 0;
                   prodObj.Vision_Current_Anda_Units__c = 0;
                   prodObj.Current_Retail_Indirect_Units__c = 0;
                   prodObj.Current_Retail_Direct_Units__c = 0;
                   prodObj.X3MonthAnnualCurrent_BASE_Selling_unit__c = 0;
                   prodObj.X3MonthAnnualCurrentDSHSellingUnit__c = 0;
                   prodObj.X3MonthAnnualCurrentAutoSubSellingUnit__c = 0;
                   prodObj.X3Months_AnnualizedCVS_DirectSelling_Uni__c = 0;
                   prodObj.X3MonthsAnnualizedCVSIndirectSelling_uni__c = 0;
                   prodObj.X3_Months_Annualized_Major_Selling_Unit__c = 0;
                   prodObj.X3Months_Annualized_Cardinal_Selling_Uni__c = 0;
                   
                   
                   for(Phoenix_NPR_Data__c NPRLine:productCodeToNPRLineMap.get(prodObj.Vision_Product__c)){
                       if(templateType == 'otcCx'){
                           prodObj.X3_Months_Annualized_Direct_Selling_Unit__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                       }
                       if(templateType=='Indirect' || templateType=='Direct and Indirect' || templateType=='Walgreens' || templateType=='ABC Progen' || templateType=='Econdisc' || templateType== 'Costco'  || templateType== 'Sams Club' || templateType== 'Net Indirect Pricing'|| templateType== 'Government Pricing' || templateType == 'Humana Indirect retail' || templateType == 'Humana Indirect CII'){
                           if(NPRLine.Phoenix_Contract_Type__c=='Indirect'){
                               prodObj.X3Months_Annualized_Indirect_Selling_Uni__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                           }
                       }
                       if (templateType == 'ABC Pharmagen') {
                           if (NPRLine.Phoenix_Contract_Type__c == 'Indirect') {
                               if (NPRLine.Phoenix_Contract_Number__c == '3000000957')
                                   prodObj.X3Months_Annualized_Indirect_Selling_Uni__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                           }
                       }
                       if (templateType == 'Direct' || templateType == 'Direct and Indirect' || templateType == 'Econdisc' || templateType == 'Net Indirect Pricing') {
                           if (NPRLine.Phoenix_Contract_Type__c == 'Direct') {
                               prodObj.X3_Months_Annualized_Direct_Selling_Unit__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                           }
                       }
                       if (templateType == 'ClarusOne') {
                           if (NPRLine.Phoenix_Contract_Number__c == '3000001263' || NPRLine.Phoenix_Contract_Number__c == '3000000224' || NPRLine.Phoenix_Contract_Number__c == '3000000418' || NPRLine.Phoenix_Contract_Number__c == '3000000047' || NPRLine.Phoenix_Contract_Number__c == '3000000071') {
                                   prodObj.X3_Months_Annualized_OS_And_RAD_Units__c += (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                               }
                           if (NPRLine.Phoenix_Contract_Number__c == '1000000120') {
                               prodObj.X3_Months_Annualized_WMT_Direct_Units__c += (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                           }
                           if (NPRLine.Phoenix_Contract_Number__c == '3000000143') {
                               prodObj.X3_Months_Annualized_WMT_Indirect_Units__c += (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                           }
                       }
                       if (templateType == 'RXSS') {
                           if (NPRLine.Phoenix_Contract_Type__c == 'Indirect') {
                               if (NPRLine.Phoenix_Contract_Number__c == '3000000733') {
                                   prodObj.Current_Wholesaler_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                               }
                               if (NPRLine.Phoenix_Contract_Number__c == '3000001332') {
                                   prodObj.Vision_Current_Anda_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                               }
                               if (NPRLine.Phoenix_Contract_Number__c == '3000000734' || NPRLine.Phoenix_Contract_Number__c == '3000001173') {
                                   prodObj.Current_Retail_Indirect_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                               }
                           }
                           if (NPRLine.Phoenix_Contract_Type__c == 'Direct') {
                               if (NPRLine.Phoenix_Contract_Number__c == '1000000627') {
                                   prodObj.Current_Retail_Direct_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                               }
                           }
                       }
                       if (templateType == 'BASE/DSH') {
                           String baseContracts = System.Label.Base_Contracts;
                           String DSHContracts = System.Label.DSH_Contracts;
                           String autoSubContracts = System.Label.Auto_Sub_Contracts;
                           if (baseContracts.contains(NPRLine.Phoenix_Contract_Number__c)) {
                               prodObj.X3MonthAnnualCurrent_BASE_Selling_unit__c += NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0;
                           }
                           if (DSHContracts.contains(NPRLine.Phoenix_Contract_Number__c)) {
                               prodObj.X3MonthAnnualCurrentDSHSellingUnit__c += NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0;
                           }
                           if (autoSubContracts.contains(NPRLine.Phoenix_Contract_Number__c)) {
                               prodObj.X3MonthAnnualCurrentAutoSubSellingUnit__c += NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0;
                           }
                       }
                       if (templateType == 'ROS') {
                           if (NPRLine.Phoenix_Contract_Number__c == '1000000449') {
                               prodObj.X3Months_AnnualizedCVS_DirectSelling_Uni__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                           }
                           if (NPRLine.Phoenix_Contract_Number__c == '3000000489') {
                               prodObj.X3MonthsAnnualizedCVSIndirectSelling_uni__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                           }
                           if (NPRLine.Phoenix_Contract_Number__c == '3000000753') {
                               prodObj.X3_Months_Annualized_Major_Selling_Unit__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                               
                           }
                           if (NPRLine.Phoenix_Contract_Number__c == '3000000485' 
                               || NPRLine.Phoenix_Contract_Number__c == '3000000484' 
                               || NPRLine.Phoenix_Contract_Number__c == '3000000483') {
                                   prodObj.X3Months_Annualized_Cardinal_Selling_Uni__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                               }
                       }
                   }
               }
            else if(prodObj.ProductOpportunity__c == null && prodObj.Task_Status__c == 'New'){
                prodObj.X3Months_Annualized_Indirect_Selling_Uni__c = 0;
                prodObj.X3_Months_Annualized_Direct_Selling_Unit__c = 0;
                prodObj.X3_Months_Annualized_OS_And_RAD_Units__c = 0;
                prodObj.X3_Months_Annualized_WMT_Direct_Units__c = 0;
                prodObj.X3_Months_Annualized_WMT_Indirect_Units__c = 0;
                prodObj.Current_Wholesaler_Units__c = 0;
                prodObj.Vision_Current_Anda_Units__c = 0;
                prodObj.Current_Retail_Indirect_Units__c = 0;
                prodObj.Current_Retail_Direct_Units__c = 0;
                prodObj.X3MonthAnnualCurrent_BASE_Selling_unit__c = 0;
                prodObj.X3MonthAnnualCurrentDSHSellingUnit__c = 0;
                prodObj.X3MonthAnnualCurrentAutoSubSellingUnit__c = 0;
                prodObj.X3Months_AnnualizedCVS_DirectSelling_Uni__c = 0;
                prodObj.X3MonthsAnnualizedCVSIndirectSelling_uni__c = 0;
                prodObj.X3_Months_Annualized_Major_Selling_Unit__c = 0;
                prodObj.X3Months_Annualized_Cardinal_Selling_Uni__c = 0;
            }
            if(prodObj.Task_Status__c == 'New')
                updateList.add(prodObj);
            else
                nonUpdateList.add(prodObj);
        }
        update updateList;
        updateList.addAll(nonUpdateList);
        return updateList;
    }
    
    @auraEnabled
    public static commentWrapper updateShareExpansionComment(Vision_Market_Share_Expansion__c ndcItem, String ndcComment){
        commentWrapper wrapObj = new commentWrapper();
        try{
            ndcItem.Vision_Task_Rejection_Reason__c = ndcComment;
            update ndcItem;
            //return 'SUCCESS';
            wrapObj.shareExpanObj = ndcItem;
            return wrapObj;
        }
        catch(Exception e){
            //return 'ERROR : Exception while updating the rejection reason - '+e.getMessage();
            wrapObj.isError = true;
            wrapObj.errorMessage = 'ERROR : Exception while updating the rejection reason - '+e.getMessage();
            return wrapObj;
        }
    }
    
   /* Public static void updateItems(){
        Integer i=0;
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
        
    }*/
}