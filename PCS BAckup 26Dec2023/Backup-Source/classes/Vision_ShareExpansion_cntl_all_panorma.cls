public class Vision_ShareExpansion_cntl_all_panorma {
    

	@auraEnabled
    public static list<wrapper> getExpansionData( List<String> picliList){
         String accObjQuery = 'SELECT '+Phoenix_Util.getsObjectFieds('Account')+'FROM Account  ';
       Map<Id,Account> accObjmap = new Map<Id,Account>();//Database.query(accObjQuery)
        for(Account acc : Database.query(accObjQuery)){
            accObjmap.put(acc.id, acc);
        }
        String query = 'SELECT Vision_Customer__r.Name,Vision_Customer__r.Phoenix_Customer_Class_Bid_Template__c,Vision_Product__r.Name, Vision_Product__r.ProductCode, '+
            +'Vision_Product__r.Phoenix_GPI_Generic_Product_Identifier__c, Vision_Product__r.Phoenix_GCN_Generic_Code_Number__c,'+
            +'Vision_Product__r.Phoenix_GCN_Sequence_Number__c, Vision_Product__r.Product_Family__r.Name, Vision_Product__r.Family,Vision_Product__r.Phoenix_Strength__c,'+
            +'Vision_Product__r.Phoenix_Lowest_Price_SKU__c, Vision_Product__r.Description,ProductOpportunity__r.Opportunity__r.Name,ProductOpportunity__r.Opportunity__r.Id,'+
            +'Vision_Product__r.Phoenix_NDC_11__c, Vision_Product__r.Phoenix_Pkg_Size__c,'+Phoenix_Util.getsObjectFieds('Vision_Market_Share_Expansion__c')+' FROM Vision_Market_Share_Expansion__c'+
            +' WHERE Vision_Customer__c!=Null AND  Task_Status__c =:picliList ORDER BY Vision_Product_Family__c ';
        List<Vision_Market_Share_Expansion__c> markShareList = database.query(query);
        
        Map<String, list<Vision_Market_Share_Expansion__c>> expListMap = new Map<String, list<Vision_Market_Share_Expansion__c>>();
        for(Vision_Market_Share_Expansion__c expnObj : markShareList){
            if(!expListMap.containsKey(expnObj.Vision_Product_Family__c))
                expListMap.put(expnObj.Vision_Product_Family__c, new List<Vision_Market_Share_Expansion__c>());
            expListMap.get(expnObj.Vision_Product_Family__c).add(expnObj);
        }
        list<wrapper> wrapList = new List<wrapper>();
        for(String famName : expListMap.keySet()){
            wrapper wrapObj = new wrapper();
            wrapObj.prodFamilyName = famName;
            wrapObj.expnList = expListMap.get(famName);
            wrapObj.accObj = accObjmap.get(wrapObj.expnList[0].Vision_Customer__c);
            wrapList.add(wrapObj);
        }
        //if(wrapList.size()>0)
          //  wrapList[0].accObj = accObj;
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
    }
    
    @auraEnabled
    public static string createOptyCntl(list<Vision_Market_Share_Expansion__c> prodList, String bidType, Integer totalVol, String internalTargetDate){
        try{
            list<Opportunity> optyList = [SELECT Id, Name FROM opportunity WHERE Name Like '%-MSEmove-%'];
            
            Integer autoNum = 1;
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
            optyRec.Vision_Bid_Template__c = prodList[0].Vision_Customer__r.Phoenix_Customer_Class_Bid_Template__c;
            optyRec.Vision_Type__c = 'Proactive';
            optyRec.Vision_Opportunity_Source__c = 'Panorama-Market Share Expansion';
            optyRec.Name = prodList[0].Vision_Product_Family__c+'-MSEmove-000'+autoNum;
            optyRec.AccountId = prodList[0].Vision_Customer__c;
            optyRec.closeDate = Date.valueOf(internalTargetDate);
            optyRec.Vision_Internal_Closing_Date__c = optyRec.closeDate;
            optyRec.Bid_Type__c = 'Product Addition';//bidType;
            insert optyRec;
            list<Vision_Market_Share_Expansion__c> updateList = new list<Vision_Market_Share_Expansion__c>();
            
            List<Product_Opportunity__c> savedPrdOptyRecs = new List<Product_Opportunity__c>();
            Integer optyValue = 0;
            List<Vision_Market_Share_Expansion__c> updateListShareExp = new List<Vision_Market_Share_Expansion__c>();
            Map<Id, Vision_Market_Share_Expansion__c> updateMrtShareMap = new Map<Id, Vision_Market_Share_Expansion__c>();
            for (Vision_Market_Share_Expansion__c wr: prodList) {
                Product_Opportunity__c productOpportunity = new Product_Opportunity__c();
                productOpportunity.Name = wr.Vision_Product__r.Name;
                productOpportunity.GCN_Generic_Code_Number__c = wr.Vision_Product__r.Phoenix_GCN_Generic_Code_Number__c;
                productOpportunity.GSN__c = wr.Vision_Product__r.Phoenix_GCN_Sequence_Number__c;
                productOpportunity.GPI_Generic_Product_Identifier__c = wr.Vision_Product__r.Phoenix_GPI_Generic_Product_Identifier__c;
                productOpportunity.NDC_11__c = wr.Vision_Product__r.Phoenix_NDC_11__c;
                productOpportunity.SKU_Number__c = wr.Vision_Product__r.ProductCode;
                productOpportunity.Product_Family__c = wr.Vision_Product__r.Product_Family__r.Name;
                productOpportunity.Lowest_Price_SKU__c = wr.Vision_Product__r.Phoenix_Lowest_Price_SKU__c;
                productOpportunity.Strength__c = wr.Vision_Product__r.Phoenix_Strength__c;
                productOpportunity.Pkg_Size__c = wr.Vision_Product__r.Phoenix_Pkg_Size__c;
                productOpportunity.Product_Description__c = wr.Vision_Product__r.Description;
                //productOpportunity.Proposed_Indirect_Selling_Units__c = wr.Vision_Proposed_Volume__c;
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
                updateMrtShareMap.put(prodId, wr);
                productOpportunity.Status__c = 'Matched';
                savedPrdOptyRecs.add(productOpportunity);
                
                wr.Task_Status__c = 'Sent to OPPORTUNITY';
                updateList.add(wr);
            }
            
            if(savedPrdOptyRecs.size() > 0){
                insert savedPrdOptyRecs;
            }
            for(Product_Opportunity__c optyProd : savedPrdOptyRecs){
                Vision_Market_Share_Expansion__c mktShareObj = updateMrtShareMap.get(optyProd.Product__c);
                mktShareObj.ProductOpportunity__c = optyProd.Id;
                updateListShareExp.add(mktShareObj);
            }
            optyRec.Vision_Opportunity_Value__c = optyValue;
            update optyRec;
            update updateList;
            update updateListShareExp;
            return ''+optyRec.Id;
        }
        catch(exception e){
            return 'ERROR: Unable to Create Opportunity. Exception: '+e.getMessage();
        }
    }
    
    @auraEnabled
    public static string updateShareExpansionComment(Vision_Market_Share_Expansion__c ndcItem, String ndcComment){
        return null;
    }
    
     
    @auraEnabled
    public static list<wrapper> fetchSortResults(string sortField,boolean isAsc, List<String> picliList){
        
        String accObjQuery = 'SELECT '+Phoenix_Util.getsObjectFieds('Account')+'FROM Account  ';
        Map<Id,Account> accObjmap = new Map<Id,Account>();//Database.query(accObjQuery)
        for(Account acc : Database.query(accObjQuery)){
            accObjmap.put(acc.id, acc);
        }
         String sSoql = '';
        sSoql = 'SELECT Vision_Customer__r.Name,Vision_Customer__r.Phoenix_Customer_Class_Bid_Template__c,Vision_Product__r.Name, Vision_Product__r.ProductCode, '+
            +'Vision_Product__r.Phoenix_GPI_Generic_Product_Identifier__c, Vision_Product__r.Phoenix_GCN_Generic_Code_Number__c,'+
            +'Vision_Product__r.Phoenix_GCN_Sequence_Number__c, Vision_Product__r.Product_Family__r.Name,Vision_Product__r.Family,Vision_Product__r.Phoenix_Strength__c,'+
            +'Vision_Product__r.Phoenix_Lowest_Price_SKU__c, Vision_Product__r.Description,ProductOpportunity__r.Opportunity__r.Name,ProductOpportunity__r.Opportunity__r.Id,'+
            +'Vision_Product__r.Phoenix_NDC_11__c, Vision_Product__r.Phoenix_Pkg_Size__c,'+Phoenix_Util.getsObjectFieds('Vision_Market_Share_Expansion__c')+' FROM Vision_Market_Share_Expansion__c'+
            +' WHERE Vision_Customer__c!=Null AND  Task_Status__c =:picliList  ';
      if (sortField != null && sortField != '') {
           sSoql += ' order by ' + sortField;
            
            if (isAsc) {
                 
                sSoql += ' ASC NULLS LAST';
            } else {
                 
                 sSoql += ' DESC NULLS LAST';
            }
            
            }
        List<Vision_Market_Share_Expansion__c> markShareList = database.query(sSoql);
        
        Map<String, list<Vision_Market_Share_Expansion__c>> expListMap = new Map<String, list<Vision_Market_Share_Expansion__c>>();
        for(Vision_Market_Share_Expansion__c expnObj : markShareList){
            if(!expListMap.containsKey(expnObj.Vision_Product_Family__c))
                expListMap.put(expnObj.Vision_Product_Family__c, new List<Vision_Market_Share_Expansion__c>());
            expListMap.get(expnObj.Vision_Product_Family__c).add(expnObj);
        }
        list<wrapper> wrapList = new List<wrapper>();
        for(String famName : expListMap.keySet()){
            wrapper wrapObj = new wrapper();
            wrapObj.prodFamilyName = famName;
            wrapObj.expnList = expListMap.get(famName);
            wrapObj.accObj = accObjmap.get(wrapObj.expnList[0].Vision_Customer__c);
            wrapList.add(wrapObj);
        }
        //if(wrapList.size()>0)
          //  wrapList[0].accObj = accObj;
        return wrapList;
        
    }
}