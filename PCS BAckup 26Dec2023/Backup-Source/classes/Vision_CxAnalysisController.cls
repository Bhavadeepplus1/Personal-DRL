public class Vision_CxAnalysisController {
    
    public class wrapperObj{
        @auraEnabled
        public Account accObj;
        @auraEnabled
        public Integer totalCxSales = 0;
        @auraEnabled
        public Integer drlCurrentSales = 0;
        @auraEnabled
        public Integer drlOptySales = 0;
        @auraEnabled
        public Integer shareOfWalletSales = 0;
        @auraEnabled
        public Integer shareOfWalletVol = 0;
        @auraEnabled
        public String currentUser;
    }
    
    @auraEnabled
    public static wrapperObj getAccountGroups(String accId){
        wrapperObj wrapObj = new wrapperObj();
        Id currentUserId = '0051K000008f7uFQAQ';//UserInfo.getUserId();
        wrapObj.currentUser = currentUserId;
        String query = 'SELECT '+Phoenix_Util.getsObjectFieds('Account')+' FROM Account';
        if(accId == 'noAccSelected')
            query += ' WHERE Phoenix_Customer_Est_Market_Share__c = null AND ownerId =: currentUserId ORDER BY Name ASC';
        else
            query += ' WHERE Id=: accId';
        
        list<Account> accList = Database.query(query);
        Account accObj = new Account();
        if(accList.size()>0)
            accObj = accList[0];
        else{
            query = 'SELECT '+Phoenix_Util.getsObjectFieds('Account')+' FROM Account ORDER BY Name ASC LIMIT 1';
            accObj = database.query(query);
        }
        Id acctId = accObj.Id;
        if((accObj.Phoenix_Customer_Est_Market_Share__c == null || accObj.Phoenix_Customer_Est_Market_Share__c == 0) && 
           (accObj.Phoenix_Customer_Max_Est_Share_of_Wallet__c == null || accObj.Phoenix_Customer_Max_Est_Share_of_Wallet__c == 0) && 
           (accObj.Phoenix_Account_Cooling_Period__c == null || accObj.Phoenix_Account_Cooling_Period__c == 0)){
               accObj.Phoenix_Customer_Est_Market_Share__c = 20;
               accObj.Phoenix_Customer_Max_Est_Share_of_Wallet__c = 65;
               accObj.Phoenix_Account_Cooling_Period__c = 90; 
               update accObj;
           }
        String childQuery = 'SELECT '+Phoenix_Util.getsObjectFieds('Phoenix_GCP_Opportunity_Tracker__c')+' FROM Phoenix_GCP_Opportunity_Tracker__c WHERE Phoenix_Customer__c =: acctId ';// ORDER BY GCP_Product_Family__c';
        list<Phoenix_GCP_Opportunity_Tracker__c> gcpList = database.query(childQuery);
        list<Phoenix_GCP_Opportunity_Tracker__c> updateGcpList = new list<Phoenix_GCP_Opportunity_Tracker__c>();
        
        List<String> prodFamNameList = new List<String>();
        for(Phoenix_GCP_Opportunity_Tracker__c gcpObj : gcpList){
            if(gcpObj.Phoenix_Product_Family__c != null){
                prodFamNameList.add(gcpObj.Phoenix_Product_Family__c);
            }
        }
        
        Map<String,dateTime> productFamilywithCreatedDateMap = new Map<String, dateTime>();
        Map<String,Decimal> productFamilywithUnitsMap = new Map<String, Decimal>();
        Map<String,Decimal> productFamilyLowPriceMap = new Map<String, Decimal>();
        Map<String,Decimal> producFamilyTotalPropSales = new Map<String, Decimal>();
        Map<String,String> rejectedStageMap = new Map<String, String>();
        
        
        List<AggregateResult> AggregateResultList = [SELECT Product_Family_Name__c , Sum(Phoenix_Final_Direct_Selling_Units_Calc__c) proposedDirectUnits,
                                                     Sum(Phoenix_Final_Indirect_Selling_Units_Cal__c) proposedIndirectUnits,  
                                                     Sum(Phoenix_Proposed_Sales__c) proposedSales 
                                                     FROM Phoenix_Bid_Line_Item__c 
                                                     where Phoenix_Bid__r.Phoenix_Customer__c =: acctId 
                                                     AND Product_Family_Name__c =: prodFamNameList
                                                     GROUP BY Product_Family_Name__c 
                                                     LIMIT 5000];
        
        List<Product2> productList = [SELECT Id, Name, Product_Family__r.Name,Phoenix_Pkg_Size__c, Phoenix_Lowest_Price_SKU__c, Family 
                                      FROM Product2 WHERE Product_Family__r.Name =: prodFamNameList AND IsActive = true
                                      AND Phoenix_Lowest_Price_SKU__c > 0 AND Phoenix_Pkg_Size__c > 0];
        for(Product2 prodObj : productList){ 
            Decimal newCalc = prodObj.Phoenix_Lowest_Price_SKU__c/prodObj.Phoenix_Pkg_Size__c;  
            if(productFamilyLowPriceMap.containsKey(prodObj.Product_Family__r.Name)){
                Decimal lowestPrice = productFamilyLowPriceMap.get(prodObj.Product_Family__r.Name);
                if(newCalc < lowestPrice)
                    productFamilyLowPriceMap.put(prodObj.Product_Family__r.Name,newCalc);                        
            }
            else
                productFamilyLowPriceMap.put(prodObj.Product_Family__r.Name,newCalc); 
        }
        
        
        if(AggregateResultList != null && AggregateResultList.size() > 0){
            for(AggregateResult aggr:AggregateResultList){ 
                decimal totalUnits = (aggr.get('proposedDirectUnits') != null ?(decimal)aggr.get('proposedDirectUnits'):0)+(aggr.get('proposedIndirectUnits') !=null ? (decimal)aggr.get('proposedIndirectUnits'):0); 
                String productFamily = (String) aggr.get('Product_Family_Name__c');
                decimal totalPropSales = aggr.get('proposedSales') != null ?(decimal)aggr.get('proposedSales'):0;
                if(productFamily != null){
                    productFamilywithUnitsMap.put(productFamily,totalUnits);
                    producFamilyTotalPropSales.put(productFamily,totalPropSales);
                }
            } 
        }
        Decimal totalEstSales = 0;
        for(Phoenix_GCP_Opportunity_Tracker__c gcpObj : gcpList){
            String prodFamily = gcpObj.Phoenix_Product_Family__c;
            Decimal proposedTotal = 0; Decimal lowestPrice = 0; String latestBidDate = '';
            if(productFamilywithUnitsMap.containsKey(prodFamily))
                proposedTotal = productFamilywithUnitsMap.get(prodFamily); gcpObj.Phoenix_Est_Acct_Vol_EU_BRIGHT__c = proposedTotal;
            if(productFamilyLowPriceMap.containsKey(prodFamily))
                lowestPrice = productFamilyLowPriceMap.get(prodFamily);gcpObj.Phoenix_Est_Price_EU_Lowest_Price__c = lowestPrice;
            
            if(gcpObj.Phoenix_Ims_Mat_Volume_Eu__c != null)
                gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c = gcpObj.Phoenix_Ims_Mat_Volume_Eu__c;
            if(gcpObj.Phoenix_Est_Acct_Share_of_Wallet_Method__c == null || gcpObj.Phoenix_Est_Acct_Share_of_Wallet_Method__c == 'Use Default Header')
                gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c = accObj.Phoenix_Customer_Max_Est_Share_of_Wallet__c != null ? accObj.Phoenix_Customer_Max_Est_Share_of_Wallet__c : 0;
            else if(gcpObj.Phoenix_Est_Acct_Share_of_Wallet_Method__c == 'Use User Input')
                gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c = gcpObj.Phoenix_Est_AcctShareofWalletUserInput__c != null ? gcpObj.Phoenix_Est_AcctShareofWalletUserInput__c : 0;
            
            if(gcpObj.Phoenix_Est_Acct_Mkt_Share_Method__c == null || gcpObj.Phoenix_Est_Acct_Mkt_Share_Method__c == 'Use Default Header')gcpObj.Phoenix_Estimate_Account_Marketing_Share__c = accObj.Phoenix_Customer_Est_Market_Share__c != null ? accObj.Phoenix_Customer_Est_Market_Share__c :0;
            else if(gcpObj.Phoenix_Est_Acct_Mkt_Share_Method__c == 'Use User Input')
                gcpObj.Phoenix_Estimate_Account_Marketing_Share__c = gcpObj.Phoenix_Est_Acct_Mkt_Share_User_Input__c != null ? gcpObj.Phoenix_Est_Acct_Mkt_Share_User_Input__c: 0;
            else if(gcpObj.Phoenix_Est_Acct_Mkt_Share_Method__c == 'Use Usage Data'){ //'Use Customer Feedback (BRIGHT)'){
                gcpObj.Phoenix_Estimate_Account_Marketing_Share__c = (gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c !=null && gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c > 0) ? 
                    (gcpObj.Phoenix_Est_Acct_Vol_EU_BRIGHT__c != null ? gcpObj.Phoenix_Est_Acct_Vol_EU_BRIGHT__c : 0)/(gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c) : 0;
            }
            
            if(gcpObj.Phoenix_Est_Acct_Vol_Method__c == 'Use User Input')gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c = gcpObj.Phoenix_Est_Acct_Vol_EU_User_Input__c != null ? gcpObj.Phoenix_Est_Acct_Vol_EU_User_Input__c : 0;
            else if (gcpObj.Phoenix_Est_Acct_Vol_Method__c == 'Use Proposed Total Selling Units (BRIGHT)')gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c = gcpObj.Phoenix_Est_Acct_Vol_EU_BRIGHT__c != null ? gcpObj.Phoenix_Est_Acct_Vol_EU_BRIGHT__c : 0;
            else if (gcpObj.Phoenix_Est_Acct_Vol_Method__c == null || gcpObj.Phoenix_Est_Acct_Vol_Method__c == 'Use Calculation of Est Acct Mkt Share')
                gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c = (gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c/100)*(gcpObj.Phoenix_Estimate_Account_Marketing_Share__c/100)*(gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c!=null?gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c:0);
            
            if((gcpObj.Product_Status__c == 'Awarded' && gcpObj.Phoenix_Est_Price_Method__c == null) || gcpObj.Phoenix_Est_Price_Method__c == 'DRL Customer Actuals Average Price'){
                if(gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c != null && gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c > 0)
                    gcpObj.Phoenix_Est_Price_EU__c = (gcpObj.Cust_Act_Sales_Mat__c != null ? gcpObj.Cust_Act_Sales_Mat__c : 0)/gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c;
                else{ 
                    if(gcpObj.Phoenix_Est_Price_Method__c == 'Use User Input')
                        gcpObj.Phoenix_Est_Price_EU__c = gcpObj.Phoenix_Est_Acct_Price_EU_User_Input__c != null ? gcpObj.Phoenix_Est_Acct_Price_EU_User_Input__c : 0;
                    else if(gcpObj.Phoenix_Est_Price_Method__c == 'Use Lowest Price')
                        gcpObj.Phoenix_Est_Price_EU__c = gcpObj.Phoenix_Est_Price_EU_Lowest_Price__c != null ? gcpObj.Phoenix_Est_Price_EU_Lowest_Price__c : 0;
                    else if(gcpObj.Phoenix_Est_Price_Method__c == null || gcpObj.Phoenix_Est_Price_Method__c == 'Marketing (Panorama) suggested Price' || gcpObj.Phoenix_Est_Price_Method__c == 'Use GCP suggested Price')
                        gcpObj.Phoenix_Est_Price_EU__c = gcpObj.Phoenix_GCP_Suggested_Lowest_Price__c != null ? gcpObj.Phoenix_GCP_Suggested_Lowest_Price__c : 0;
                }
            }
            else{
                if(gcpObj.Phoenix_Est_Price_Method__c == 'Use User Input')
                    gcpObj.Phoenix_Est_Price_EU__c = gcpObj.Phoenix_Est_Acct_Price_EU_User_Input__c != null ? gcpObj.Phoenix_Est_Acct_Price_EU_User_Input__c : 0; else if(gcpObj.Phoenix_Est_Price_Method__c == 'Use Lowest Price')gcpObj.Phoenix_Est_Price_EU__c = gcpObj.Phoenix_Est_Price_EU_Lowest_Price__c != null ? gcpObj.Phoenix_Est_Price_EU_Lowest_Price__c : 0;
                else if(gcpObj.Phoenix_Est_Price_Method__c == null || gcpObj.Phoenix_Est_Price_Method__c == 'Marketing (Panorama) suggested Price' || gcpObj.Phoenix_Est_Price_Method__c == 'Use GCP suggested Price')
                    gcpObj.Phoenix_Est_Price_EU__c = gcpObj.Phoenix_GCP_Suggested_Lowest_Price__c != null ? gcpObj.Phoenix_GCP_Suggested_Lowest_Price__c : 0;
            }
            
            gcpObj.Phoenix_Est_Acct_Sales__c = (gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c/100) * gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c * (gcpObj.Phoenix_Est_Price_EU__c!=null?gcpObj.Phoenix_Est_Price_EU__c:0);
            if(gcpObj.Product_Status__c == 'Awarded' && (gcpObj.Phoenix_Current_Position__c == 'Formulary A Awards' || gcpObj.Phoenix_Current_Position__c == '100% Products')){
                gcpObj.Phoenix_Customer_Opp_Sales__c = null;
                gcpObj.Phoenix_Customer_Opp_TPT__c = null;
                gcpObj.Phoenix_Customer_Opp_TPT_Perc__c = null;
            }
            else{
                gcpObj.Phoenix_Customer_Opp_Sales__c = gcpObj.Phoenix_Est_Acct_Sales__c - (gcpObj.Cust_Act_Sales_Mat__c != null ? gcpObj.Cust_Act_Sales_Mat__c : 0);
                gcpObj.Phoenix_Customer_Opp_TPT__c = ((gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c/100)*(gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c)*(gcpObj.cogs_per_unit__c != null ? gcpObj.cogs_per_unit__c : 0)) - (gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c!=null ? gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c :0)* (gcpObj.cogs_per_unit__c != null ? gcpObj.cogs_per_unit__c : 0);
                gcpObj.Phoenix_Customer_Opp_TPT_Perc__c = (gcpObj.Phoenix_Customer_Opp_Sales__c != null && gcpObj.Phoenix_Customer_Opp_Sales__c > 0) ? (gcpObj.Phoenix_Customer_Opp_TPT__c/gcpObj.Phoenix_Customer_Opp_Sales__c)*100 : 0;
            }
            
            gcpObj.Phoenix_Cust_Act_Mkt_Sh__c = (gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c != null && gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c >0) ? ((gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c!= null ? gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c : 0)/gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c)*100 : 0;
            gcpObj.Phoenix_Cooling_Period__c = gcpObj.Phoenix_Cooling_Period__c != null ? gcpObj.Phoenix_Cooling_Period__c : accObj.Phoenix_Account_Cooling_Period__c;
            
            totalEstSales = totalEstSales + ((gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c != null && gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c > 0) ? (gcpObj.Phoenix_Est_Acct_Sales__c != null ? gcpObj.Phoenix_Est_Acct_Sales__c : 0)*(gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c/100): 0 );
            
            updateGcpList.add(gcpObj);
        }
        update updateGcpList; 
        AggregateResult totalAggrigates = [select sum(Phoenix_Est_Acct_Sales__c) EstAcctSales, sum(Cust_Act_Sales_Mat__c) custActualSales,
                                           sum(Phoenix_Customer_Opp_Sales__c) custOptySales,sum(Phoenix_Cust_Act_Volume_Mat_Eu__c) cxActVol,
                                           sum(Phoenix_Est_Acct_Total_Vol_EU__c) actTotal, sum(Phoenix_Est_Acct_Share_of_Wallet__c) shareOfWallet,
                                           sum(Phoenix_Drl_Act_Volume_Eu__c) drlAccVol, sum(Phoenix_Drl_Act_Sales__c) drlAccSales,
                                           sum(Phoenix_Drl_Act_Price__c) drlAccPrice, sum(Phoenix_DRL_Actual_TPT__c) drlAccTpt,
                                           sum(Phoenix_Total_Market_Vol_MAT_EU__c) totalMktVol, sum(Phoenix_Total_Market_Sales__c) totalMktShares,
                                           sum(Phoenix_Cust_Act_Volume_Mat_Eu__c) custActVol, sum(Phoenix_Cust_Act_Mkt_Sh__c) custActMktShare,
                                           sum(Phoenix_Customer_Opp_TPT__c) custActOppTpt
                                           FROM Phoenix_GCP_Opportunity_Tracker__c  WHERE Phoenix_Customer__c =: acctId 
                                           AND Phoenix_Product_Family__c =: prodFamNameList];
        accObj.Phoenix_Total_Customer_Opportunity__c = totalAggrigates.get('EstAcctSales') != null ? (Decimal)totalAggrigates.get('EstAcctSales') : 0;
        accObj.Phoenix_DRL_Current_Sales__c = totalAggrigates.get('custActualSales') != null ? (decimal)totalAggrigates.get('custActualSales') : 0;
        accObj.Phoenix_DRL_Opportunity_Sales__c = totalAggrigates.get('custOptySales') != null ? (Decimal)totalAggrigates.get('custOptySales') : 0;
        
        accObj.Phoenix_DRL_Total_Est_Account_Sales__c = totalEstSales;//accObj.Phoenix_Total_Customer_Opportunity__c*((totalAggrigates.get('shareOfWallet') != null ? (Decimal)totalAggrigates.get('shareOfWallet') : 0)/100);// + accObj.Phoenix_DRL_Opportunity_Sales__c;
        accObj.Phoenix_DRL_Share_of_Wallet__c = accObj.Phoenix_Total_Customer_Opportunity__c > 0 ? (accObj.Phoenix_DRL_Current_Sales__c/(accObj.Phoenix_Total_Customer_Opportunity__c))*100 : 0;
        accObj.Phoenix_DRL_Share_of_Wallet_Vol__c = (totalAggrigates.get('actTotal') != null && (Decimal)totalAggrigates.get('actTotal') > 0) ? ((totalAggrigates.get('cxActVol') != null ? (Decimal)totalAggrigates.get('cxActVol') : 0)/(Decimal)totalAggrigates.get('actTotal'))*100 : 0;
        
        update accObj;
        wrapObj.accObj = accObj;
        
        return wrapObj;
    }
}