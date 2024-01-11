public class Phoenix_OTCSPAHistoryCls {
    
    @AuraEnabled 
    Public static WrapperCls getSPAHistory(String bidLineId, boolean isAllCustomer,boolean isAllSPACustomer,boolean isAllNprData){
        WrapperCls wrapper = new WrapperCls();
        
        Phoenix_Bid_Line_Item__c bidLine = [SELECT Id,Product_Family_Name__c, Product_Family__c,Phoenix_Product__r.Product_Family__r.Name, Phoenix_Product__r.Product_Family__c, Phoenix_Bid__r.Phoenix_Customer__c,Phoenix_Product__r.Phoenix_Pkg_Size__c,Phoenix_Bid__r.Phoenix_Customer__r.Name, Phoenix_Product__c,Phoenix_Product__r.Family,Phoenix_Product__r.Phoenix_SAP_Pack_Size__c,Phoenix_Product__r.Phoenix_Strength__c FROM Phoenix_Bid_Line_Item__c WHERE Id=:bidLineId];
 		String  uniqueString = (bidLine.Phoenix_Product__r.Phoenix_Pkg_Size__c != null ? String.valueOf(bidLine.Phoenix_Product__r.Phoenix_Pkg_Size__c): '') + (bidLine.Phoenix_Product__r.Phoenix_Strength__c != null ? bidLine.Phoenix_Product__r.Phoenix_Strength__c: '') + (bidLine.Phoenix_Product__r.Product_Family__c != null ? bidLine.Phoenix_Product__r.Product_Family__r.Name: '')  ;
		 /*------SPA Data ----*/
        List<OTC_SPA__c> historicalData = new List<OTC_SPA__c> ();
        if(isAllSPACustomer){
            historicalData=[SELECT Id,Product__r.Name,Pipeline_or_Flow_Behind__c,Estimate_Effective_Date__c,Promo_Volume__c,Price__c,New_Annual_Volume_units__c,Current_Annual_Volume_units__c, Name, Approval_Status__c,RecordType.Name, Annual_Volume_units__c, Program_Description__c, Product__c,Product__r.Id, Promotion_Type__c, Account_Name__c, OPT__c, Current_Contract_Price__c, Price_Effective_Date__c FROM OTC_SPA__c WHERE UniqIdentifier__c LIKE : uniqueString];        
        }else{
            historicalData= [SELECT Id,Product__r.Name,Pipeline_or_Flow_Behind__c,Estimate_Effective_Date__c, Name,Promo_Volume__c,Price__c,New_Annual_Volume_units__c,Current_Annual_Volume_units__c, Approval_Status__c,RecordType.Name, Annual_Volume_units__c, Program_Description__c, Product__c,Product__r.Id, Promotion_Type__c, Account_Name__c, OPT__c, Current_Contract_Price__c, Price_Effective_Date__c FROM OTC_SPA__c WHERE UniqIdentifier__c LIKE : uniqueString AND OPT__r.AccountId=:bidLine.Phoenix_Bid__r.Phoenix_Customer__c];        
        }
        /*------- Bid Lines Data-----*/    
        List<Phoenix_Bid_Line_Item__c> bidLines = new List<Phoenix_Bid_Line_Item__c> ();
        if(isAllCustomer){
            bidLines = [SELECT Id,Name,Phoenix_Bid__r.Phoenix_Customer__c,Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c,Phoenix_Customer_Approval_OTC__c,Phoenix_Current_Direct_Price__c,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Bid_Type__c,Phoenix_Bid__r.Phoenix_Customer__r.Name,Phoenix_Current_Price_Calc__c,Phoenix_Final_Total_Selling_Unit__c,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Price_Effective_Date__c,Phoenix_Supply_Type__c FROM Phoenix_Bid_Line_Item__c WHERE Spa_Data_Identifier__c LIKE : uniqueString AND Phoenix_Bid__r.Phoenix_is_OTC_Bid__c=TRUE ORDER BY Phoenix_Bid__r.Name DESC];
        }else{
           bidLines = [SELECT Id,Name,Phoenix_Bid__r.Phoenix_Customer__c,Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c,Phoenix_Customer_Approval_OTC__c,Phoenix_Current_Direct_Price__c,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Bid_Type__c,Phoenix_Bid__r.Phoenix_Customer__r.Name,Phoenix_Current_Price_Calc__c,Phoenix_Final_Total_Selling_Unit__c,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Price_Effective_Date__c,Phoenix_Supply_Type__c FROM Phoenix_Bid_Line_Item__c WHERE Spa_Data_Identifier__c LIKE : uniqueString AND Phoenix_Bid__r.Phoenix_is_OTC_Bid__c=TRUE AND Phoenix_Bid__r.Phoenix_Customer__c=:bidLine.Phoenix_Bid__r.Phoenix_Customer__c ORDER BY Phoenix_Bid__r.Name DESC]; 
        }
        /*---- NPR Data ---*/
        List<Phoenix_NPR_Data__c> nprData = new List<Phoenix_NPR_Data__c> ();
        if(isAllNprData){
            nprData = [SELECT Id, Phoenix_Contract__c,Phoenix_Product__r.Name, Phoenix_NPR_Customer_Name__c, Phoenix_Price_Effective_Value_From__c, Phoenix_Price_Effective_Value_To__c, Phoenix_SF_Product_Family__c, Phoenix_Product__c, Phoenix_Contract_Price__c, Phoenix_Account__c,Phoenix_Account__r.Name FROM Phoenix_NPR_Data__c WHERE Phoenix_NPR_Status__c = 'Active' AND OTCSpaIdentifier__c LIKE : uniqueString];
            
        }else{
            nprData = [SELECT Id, Phoenix_Contract__c,Phoenix_Product__r.Name, Phoenix_NPR_Customer_Name__c, Phoenix_Price_Effective_Value_From__c, Phoenix_Price_Effective_Value_To__c, Phoenix_SF_Product_Family__c, Phoenix_Product__c, Phoenix_Contract_Price__c, Phoenix_Account__c,Phoenix_Account__r.Name FROM Phoenix_NPR_Data__c WHERE Phoenix_NPR_Status__c = 'Active' AND OTCSpaIdentifier__c LIKE : uniqueString AND Phoenix_Account__c =:bidLine.Phoenix_Bid__r.Phoenix_Customer__c];
        }
        wrapper.nprData=nprData;
        
        
        Product2 productRec = [SELECT Id,Name,Phoenix_Pkg_Size__c,Strength__c,Family,Product_Family__r.Name, Product_Family__c,Phoenix_Strength__c FROM Product2 WHERE Id=:bidLine.Phoenix_Product__c];
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = OTC_SPA__c.Approval_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        } 
        List<String> bidStatusOptions= new List<String>();
        Schema.DescribeFieldResult fieldResult1 = Phoenix_Bid__c.Phoenix_Approval_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple1){
            bidStatusOptions.add(pickListVal.getLabel());
        } 
        wrapper.approvalStatusOptions=pickListValuesList;
        wrapper.bidStatusOptions=bidStatusOptions;
        wrapper.spaDataRecords = historicalData;
        wrapper.bidLines = bidLines;
        wrapper.productRec=productRec;
        return wrapper;
    }
    @AuraEnabled 
    Public static WrapperCls getFilterData(String bidLineId, boolean isAllCustomer,boolean isAllSPACustomer,String spaApprStatus,string bidApprStatus,String searchText,String SearchKeyWordSPA,String SearchKeyWordNpr,boolean isAllNprData){
        WrapperCls wrapper = new WrapperCls();
        system.debug('searchText--->'+searchText);
        if(searchText != null && searchText!='')
            searchText= '%'+searchText+'%';
        if(SearchKeyWordSPA != null && SearchKeyWordSPA!='')
            SearchKeyWordSPA= '%'+SearchKeyWordSPA+'%';
        if(SearchKeyWordNpr != null && SearchKeyWordNpr!='')
            SearchKeyWordNpr= '%'+SearchKeyWordNpr+'%';
        Phoenix_Bid_Line_Item__c bidLine = [SELECT Id,Product_Family_Name__c, Product_Family__c, Phoenix_Product__r.Product_Family__r.Name, Phoenix_Product__r.Product_Family__c,Phoenix_Bid__r.Phoenix_Customer__c,Phoenix_Product__r.Phoenix_Pkg_Size__c,Phoenix_Bid__r.Phoenix_Customer__r.Name, Phoenix_Product__c,Phoenix_Product__r.Family,Phoenix_Product__r.Phoenix_SAP_Pack_Size__c,Phoenix_Product__r.Phoenix_Strength__c FROM Phoenix_Bid_Line_Item__c WHERE Id=:bidLineId];
 		String  uniqueString = (bidLine.Phoenix_Product__r.Phoenix_Pkg_Size__c != null ? String.valueOf(bidLine.Phoenix_Product__r.Phoenix_Pkg_Size__c): '') + (bidLine.Phoenix_Product__r.Phoenix_Strength__c != null ? bidLine.Phoenix_Product__r.Phoenix_Strength__c: '') + (bidLine.Phoenix_Product__r.Product_Family__c != null ? bidLine.Phoenix_Product__r.Product_Family__r.Name: '')  ;
 		String customerId=bidLine.Phoenix_Bid__r.Phoenix_Customer__c;
        String spaQuery= 'SELECT Id,Product__r.Name,Estimate_Effective_Date__c,Pipeline_or_Flow_Behind__c,Price__c,Promo_Volume__c,New_Annual_Volume_units__c,Current_Annual_Volume_units__c, Name, Approval_Status__c,RecordType.Name, Annual_Volume_units__c, Program_Description__c, Product__c,Product__r.Id, Promotion_Type__c, Account_Name__c, OPT__c, Current_Contract_Price__c, Price_Effective_Date__c FROM OTC_SPA__c WHERE UniqIdentifier__c LIKE : uniqueString';
		if(!isAllSPACustomer){
            system.debug('in Current Customer');
            spaQuery += ' AND OPT__r.AccountId=:customerId';
        }
        if(spaApprStatus !='--None--'){
            system.debug('in SPA Approval Status');
            spaQuery += ' AND Approval_Status__c=:spaApprStatus';
        }
        if(SearchKeyWordSPA!=null && SearchKeyWordSPA!=''){
            system.debug('in searchText');
            spaQuery += ' AND Account_Name__c LIKE : SearchKeyWordSPA';
        }
        List<OTC_SPA__c> historicalData = new List<OTC_SPA__c> ();
        historicalData = Database.query(spaQuery);
        /*if(isAllSPACustomer && spaApprStatus!='--None--'){
            historicalData=[SELECT Id,Product__r.Name,Estimate_Effective_Date__c,Pipeline_or_Flow_Behind__c,Price__c,Promo_Volume__c,New_Annual_Volume_units__c,Current_Annual_Volume_units__c, Name, Approval_Status__c,RecordType.Name, Annual_Volume_units__c, Program_Description__c, Product__c,Product__r.Id, Promotion_Type__c, Account_Name__c, OPT__c, Current_Contract_Price__c, Price_Effective_Date__c FROM OTC_SPA__c WHERE UniqIdentifier__c LIKE : uniqueString AND Approval_Status__c=:spaApprStatus];        
        }else if(isAllSPACustomer && spaApprStatus=='--None--'){
            historicalData=[SELECT Id,Product__r.Name, Name,Promo_Volume__c,Pipeline_or_Flow_Behind__c,New_Annual_Volume_units__c,Price__c,Current_Annual_Volume_units__c, Estimate_Effective_Date__c,Approval_Status__c,RecordType.Name, Annual_Volume_units__c, Program_Description__c, Product__c,Product__r.Id, Promotion_Type__c, Account_Name__c, OPT__c, Current_Contract_Price__c, Price_Effective_Date__c FROM OTC_SPA__c WHERE UniqIdentifier__c LIKE : uniqueString];        
        }else if(!isAllSPACustomer && spaApprStatus=='--None--'){
            historicalData= [SELECT Id,Product__r.Name, Name,Promo_Volume__c,Pipeline_or_Flow_Behind__c,New_Annual_Volume_units__c,Price__c,Current_Annual_Volume_units__c, Approval_Status__c,Estimate_Effective_Date__c,RecordType.Name, Annual_Volume_units__c, Program_Description__c, Product__c,Product__r.Id, Promotion_Type__c, Account_Name__c, OPT__c, Current_Contract_Price__c, Price_Effective_Date__c FROM OTC_SPA__c WHERE UniqIdentifier__c LIKE : uniqueString AND OPT__r.AccountId=:bidLine.Phoenix_Bid__r.Phoenix_Customer__c];        
        }else{
            historicalData= [SELECT Id,Product__r.Name, Name,Promo_Volume__c,Pipeline_or_Flow_Behind__c,New_Annual_Volume_units__c,Price__c,Current_Annual_Volume_units__c, Approval_Status__c,Estimate_Effective_Date__c,RecordType.Name, Annual_Volume_units__c, Program_Description__c, Product__c,Product__r.Id, Promotion_Type__c, Account_Name__c, OPT__c, Current_Contract_Price__c, Price_Effective_Date__c FROM OTC_SPA__c WHERE UniqIdentifier__c LIKE : uniqueString AND OPT__r.AccountId=:bidLine.Phoenix_Bid__r.Phoenix_Customer__c AND Approval_Status__c=:spaApprStatus];        
        }*/
        String lineQuery = 'SELECT Id,Name,Phoenix_Current_Direct_Price__c,Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Customer_Approval_OTC__c,Phoenix_Bid__r.Phoenix_Customer__c,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Bid_Type__c,Phoenix_Bid__r.Phoenix_Customer__r.Name,Phoenix_Current_Price_Calc__c,Phoenix_Final_Total_Selling_Unit__c,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Price_Effective_Date__c,Phoenix_Supply_Type__c FROM Phoenix_Bid_Line_Item__c WHERE Spa_Data_Identifier__c LIKE : uniqueString AND Phoenix_Bid__r.Phoenix_is_OTC_Bid__c=TRUE';    
        if(!isAllCustomer){
            lineQuery += ' AND Phoenix_Bid__r.Phoenix_Customer__c=:customerId';
        }
        if(bidApprStatus !='--None--'){
            lineQuery += ' AND Phoenix_Bid__r.Phoenix_Approval_Status__c=:bidApprStatus';
        }
        if(searchText!=null && searchText!=''){
            lineQuery += ' AND Phoenix_Bid__r.Customer_Name__c LIKE : searchText';
        }
        lineQuery += ' ORDER BY Phoenix_Bid__r.Name DESC';
        List<Phoenix_Bid_Line_Item__c> bidLines = new List<Phoenix_Bid_Line_Item__c> ();
        bidLines = Database.query(lineQuery);
        /*if(isAllCustomer && bidApprStatus =='--None--'  && searchText!=null && searchText!=''){
            system.debug('if first---');
            bidLines = [ AND Phoenix_Bid__r.Customer_Name__c LIKE : searchText ORDER BY Phoenix_Bid__r.Name DESC];
           system.debug('bidLines1-->'+bidLines);
        }else if(isAllCustomer && bidApprStatus !='--None--'){
            system.debug('if second---');
            bidLines = [SELECT Id,Name,Phoenix_Current_Direct_Price__c,Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Customer_Approval_OTC__c,Phoenix_Bid__r.Phoenix_Customer__c,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Bid_Type__c,Phoenix_Bid__r.Phoenix_Customer__r.Name,Phoenix_Current_Price_Calc__c,Phoenix_Final_Total_Selling_Unit__c,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Price_Effective_Date__c,Phoenix_Supply_Type__c FROM Phoenix_Bid_Line_Item__c WHERE Spa_Data_Identifier__c LIKE : uniqueString AND Phoenix_Bid__r.Phoenix_is_OTC_Bid__c=TRUE AND Phoenix_Bid__r.Phoenix_Approval_Status__c=:bidApprStatus AND Phoenix_Bid__r.Customer_Name__c LIKE : searchText ORDER BY Phoenix_Bid__r.Name DESC];
            system.debug('bidLines2-->'+bidLines);
        }else if(!isAllCustomer && bidApprStatus !='--None--'){
            system.debug('if third---');
            bidLines = [SELECT Id,Name,Phoenix_Current_Direct_Price__c,Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Customer_Approval_OTC__c,Phoenix_Bid__r.Phoenix_Customer__c,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Bid_Type__c,Phoenix_Bid__r.Phoenix_Customer__r.Name,Phoenix_Current_Price_Calc__c,Phoenix_Final_Total_Selling_Unit__c,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Price_Effective_Date__c,Phoenix_Supply_Type__c FROM Phoenix_Bid_Line_Item__c WHERE Spa_Data_Identifier__c LIKE : uniqueString AND Phoenix_Bid__r.Phoenix_is_OTC_Bid__c=TRUE  AND Phoenix_Bid__r.Phoenix_Approval_Status__c=:bidApprStatus AND Phoenix_Bid__r.Customer_Name__c LIKE : searchText ORDER BY Phoenix_Bid__r.Name DESC];  
        }
        else{
           bidLines = [SELECT Id,Name,Phoenix_Current_Direct_Price__c,Phoenix_Bid__r.Phoenix_Bid_Closed_Date__c,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Customer_Approval_OTC__c,Phoenix_Bid__r.Phoenix_Customer__c,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Bid_Type__c,Phoenix_Bid__r.Phoenix_Customer__r.Name,Phoenix_Current_Price_Calc__c,Phoenix_Final_Total_Selling_Unit__c,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Price_Effective_Date__c,Phoenix_Supply_Type__c FROM Phoenix_Bid_Line_Item__c WHERE Spa_Data_Identifier__c LIKE : uniqueString AND Phoenix_Bid__r.Phoenix_is_OTC_Bid__c=TRUE AND Phoenix_Bid__r.Phoenix_Customer__c=:bidLine.Phoenix_Bid__r.Phoenix_Customer__c AND Phoenix_Bid__r.Customer_Name__c LIKE : searchText ORDER BY Phoenix_Bid__r.Name DESC]; 
        }*/
        List<Phoenix_NPR_Data__c> nprData = new List<Phoenix_NPR_Data__c> ();
        if(isAllNprData && SearchKeyWordNpr!=null && SearchKeyWordNpr!=''){
            nprData = [SELECT Id, Phoenix_Contract__c,Phoenix_Product__r.Name, Phoenix_NPR_Customer_Name__c, Phoenix_Price_Effective_Value_From__c, Phoenix_Price_Effective_Value_To__c, Phoenix_SF_Product_Family__c, Phoenix_Product__c, Phoenix_Contract_Price__c, Phoenix_Account__c,Phoenix_Account__r.Name FROM Phoenix_NPR_Data__c WHERE Phoenix_NPR_Status__c = 'Active' AND OTCSpaIdentifier__c LIKE : uniqueString AND Phoenix_Account__r.Name LIKE : SearchKeyWordNpr];
            
        }else if (isAllNprData && (SearchKeyWordNpr==null || SearchKeyWordNpr=='')){
            nprData = [SELECT Id, Phoenix_Contract__c,Phoenix_Product__r.Name, Phoenix_NPR_Customer_Name__c, Phoenix_Price_Effective_Value_From__c, Phoenix_Price_Effective_Value_To__c, Phoenix_SF_Product_Family__c, Phoenix_Product__c, Phoenix_Contract_Price__c, Phoenix_Account__c,Phoenix_Account__r.Name FROM Phoenix_NPR_Data__c WHERE Phoenix_NPR_Status__c = 'Active' AND OTCSpaIdentifier__c LIKE : uniqueString];
            
        }else if(!isAllNprData && SearchKeyWordNpr!=null && SearchKeyWordNpr!=''){
            nprData = [SELECT Id, Phoenix_Contract__c,Phoenix_Product__r.Name, Phoenix_NPR_Customer_Name__c, Phoenix_Price_Effective_Value_From__c, Phoenix_Price_Effective_Value_To__c, Phoenix_SF_Product_Family__c, Phoenix_Product__c, Phoenix_Contract_Price__c, Phoenix_Account__c,Phoenix_Account__r.Name FROM Phoenix_NPR_Data__c WHERE Phoenix_NPR_Status__c = 'Active' AND OTCSpaIdentifier__c LIKE : uniqueString AND Phoenix_Account__c =:bidLine.Phoenix_Bid__r.Phoenix_Customer__c AND Phoenix_Account__r.Name LIKE : SearchKeyWordNpr];
        }else{
            nprData = [SELECT Id, Phoenix_Contract__c,Phoenix_Product__r.Name, Phoenix_NPR_Customer_Name__c, Phoenix_Price_Effective_Value_From__c, Phoenix_Price_Effective_Value_To__c, Phoenix_SF_Product_Family__c, Phoenix_Product__c, Phoenix_Contract_Price__c, Phoenix_Account__c,Phoenix_Account__r.Name FROM Phoenix_NPR_Data__c WHERE Phoenix_NPR_Status__c = 'Active' AND OTCSpaIdentifier__c LIKE : uniqueString AND Phoenix_Account__c =:bidLine.Phoenix_Bid__r.Phoenix_Customer__c];
        }
        wrapper.nprData=nprData;    
        Product2 productRec = [SELECT Id,Name,Phoenix_Pkg_Size__c,Strength__c,Family,Product_Family__r.Name, Product_Family__c, Phoenix_Strength__c FROM Product2 WHERE Id=:bidLine.Phoenix_Product__c];
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = OTC_SPA__c.Approval_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        } 
        List<String> bidStatusOptions= new List<String>();
        Schema.DescribeFieldResult fieldResult1 = Phoenix_Bid__c.Phoenix_Approval_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple1){
            bidStatusOptions.add(pickListVal.getLabel());
        } 
        wrapper.approvalStatusOptions=pickListValuesList;
        wrapper.bidStatusOptions=bidStatusOptions;
        wrapper.spaDataRecords = historicalData;
        wrapper.bidLines = bidLines;
        wrapper.productRec=productRec;
        return wrapper;
    }
    public class WrapperCls{
        @AuraEnabled public List<OTC_SPA__c> spaDataRecords;
        @AuraEnabled public List<Phoenix_Bid_Line_Item__c> bidLines;
        @AuraEnabled public List<String> approvalStatusOptions;
        @AuraEnabled public List<String> bidStatusOptions;
        @AuraEnabled public Product2 productRec;
        @AuraEnabled public List<Phoenix_NPR_Data__c> nprData; 
        WrapperCls(){
            spaDataRecords = new List<OTC_SPA__c>();
            bidLines = new List<Phoenix_Bid_Line_Item__c>();
            nprData = new List<Phoenix_NPR_Data__c>();
            approvalStatusOptions= new List<String>();
            bidStatusOptions= new List<String>();
            productRec=new Product2();
        }
    }
}