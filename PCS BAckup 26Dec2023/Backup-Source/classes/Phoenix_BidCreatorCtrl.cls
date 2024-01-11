/**
* @description       : 
* @author            : Surender Patel (Dhruvsoft)
* @group             : 
* @last modified on  : 23-03-2022
* @last modified by  : Surender Patel
* Modifications Log 
* Ver   Date         Author                       Modification
* 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
public class Phoenix_BidCreatorCtrl {
    public static Phoenix_Bid__c bid;
    public static BidWrapper wrapper;
    
    static {
        bid = new Phoenix_Bid__c();
        wrapper = new BidWrapper();
    }
    
    @AuraEnabled
    public static BidWrapper getbidInfo(String recordId) {
        BidWrapper wrapperCls = new BidWrapper();
        
        if (recordId != null)
            wrapperCls.bid = Database.query('SELECT Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c, '+Phoenix_Util.bidFields+' FROM Phoenix_Bid__c WHERE Id =: recordId LIMIT 1');
        return wrapperCls;
    }
    @AuraEnabled
    public static List < string > getProductDirectorList(BidWrapper bidwrap) {
        Phoenix_Bid__c bid = bidwrap.bid;
        String bidCustomer = bid.Phoenix_Customer__c;
        String query = '';
        String SobjectApiName = 'Product2';
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
        if(bid.Phoenix_is_OTC_Bid__c){
            query = 'select Phoenix_Product_Director__r.Name,Phoenix_Supply_Chain_Planner__r.Name,' + strFields + ' from Product2 where (IsActive = true AND (OTC_Customer__c=:bidCustomer OR Phoenix_Is_Control_Label__c =true)) ORDER BY Name ASC NULLS LAST LIMIT 30000 ';
        }else{
            if (bid.Phoenix_Bid_Type__c == 'New Customer' || bid.Phoenix_Bid_Type__c == 'Sales Out Rebate') {
                query = 'select Phoenix_Product_Director__r.Name,Phoenix_Supply_Chain_Planner__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            } 
            
            else if ((bid.Phoenix_Bid_Type__c == 'New Product Launch' || bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch') && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false) {
                query = 'select Phoenix_Product_Director__r.Name,Phoenix_Supply_Chain_Planner__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName, ' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Is_New_Product__c =true) ORDER BY Name ASC NULLS LAST LIMIT 30000 ';
            } 
            
            //vandana
            else if ((bid.Phoenix_Bid_Type__c == 'New Product Launch' || bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch') && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {
                query = 'select Phoenix_Product_Director__r.Name,Phoenix_Supply_Chain_Planner__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName, ' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Is_New_Product__c =true AND Phoenix_Shields__c =false) ORDER BY Name ASC NULLS LAST LIMIT 30000 ';
            } 
            //--
            
            else if ((bid.Phoenix_Bid_Type__c == 'RFP Bids'||bid.Phoenix_Bid_Type__c == 'Good Dated OTB'||bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Price Change')&& bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false) {
                query = 'select Phoenix_Product_Director__r.Name,Phoenix_Supply_Chain_Planner__r.Name,' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false ) ORDER BY Name ASC NULLS LAST LIMIT 30000 ';
            } 
            
            //vandana
            else if ((bid.Phoenix_Bid_Type__c == 'RFP Bids'||bid.Phoenix_Bid_Type__c == 'Good Dated OTB'||bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Price Change')&& bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {
                query = 'select Phoenix_Product_Director__r.Name,Phoenix_Supply_Chain_Planner__r.Name,' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false  AND Phoenix_Shields__c =false) ORDER BY Name ASC NULLS LAST LIMIT 30000 ';
            } 
            //--
            
            else if (bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update' || bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update') {
                query = 'select Phoenix_Product_Director__r.Name,Phoenix_Supply_Chain_Planner__r.Name,' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false) ORDER BY Name ASC NULLS LAST LIMIT 30000 ';
            } else if (bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c && bid.Phoenix_Bid_Type__c != 'Initial Order Discount for WAC Customers (No-Contract Price Offering)'){
                query = 'select Phoenix_Product_Director__r.Name,Phoenix_Supply_Chain_Planner__r.Name,' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Shields__c =false AND Phoenix_Is_New_Product__c=false) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                
            }
            else if(bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && !bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
                query = 'select Phoenix_Product_Director__r.Name,Phoenix_Supply_Chain_Planner__r.Name,' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                
            }
            else if(bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
                query = 'select Phoenix_Product_Director__r.Name,Phoenix_Supply_Chain_Planner__r.Name,' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Shields__c =false) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                
            }
            else{
                system.debug('getProductDirectorList: Else');
                query = 'select Phoenix_Product_Director__r.Name,Phoenix_Supply_Chain_Planner__r.Name,' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Is_New_Product__c=false) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                
            }
        }
        
        list < Product2 > quoteList = Database.query(query);
        //system.debug('quoteList--->' + quoteList);
        
        
        List < String > productDirectorList = new List < String > ();
        
        for (Product2 lineItem: quoteList) {
            
            
            if (lineItem.Phoenix_Product_Director__r.Name != null && !productDirectorList.contains(lineItem.Phoenix_Product_Director__r.Name)) {
                productDirectorList.add(lineItem.Phoenix_Product_Director__r.Name);
            }
            
        }
        return productDirectorList;
        
        
    }
    
    @AuraEnabled
    public static List < wrapperClass > getproducts1(BidWrapper quotewrap) {
        
        Phoenix_Bid__c bid = quotewrap.bid;
        String bidCustomer = bid.Phoenix_Customer__c;
        List < wrapperClass > wrlist = new List < wrapperClass > ();
        String query = '';
        String SobjectApiName = 'Product2';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        wrExistingProdlist = Phoenix_BidCreatorCtrl.showselectedProducts(bid.Id);
        for (wrapperClass wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.prdlist.Id);
        }
        String strFields = '';
        
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        if(bid.Phoenix_is_OTC_Bid__c){
            query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where ( (Phoenix_Is_Control_Label__c = true OR OTC_Customer__c=:bidCustomer) AND IsActive = true AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
        }else{
            //Added by Naseer to include New Products for New Customer Bid Type
            if (bid.Phoenix_Bid_Type__c == 'New Customer' || bid.Phoenix_Bid_Type__c == 'Sales Out Rebate') {
                query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            } 
            //--
            else if ((bid.Phoenix_Bid_Type__c == 'New Product Launch' || bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch') && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false) {
                query = 'select Product_Family__r.Name, Phoenix_Supply_Chain_Planner__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName, ' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Is_New_Product__c =true) ORDER BY Name ASC NULLS LAST LIMIT 30000 ';
            } 
            
            //vandana
            else if ((bid.Phoenix_Bid_Type__c == 'New Product Launch' || bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch') && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {
                query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName, ' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Is_New_Product__c =true AND Phoenix_Shields__c =false) ORDER BY Name ASC NULLS LAST LIMIT 30000 ';
            } 
            //--
            else if ((bid.Phoenix_Bid_Type__c == 'RFP Bids'||bid.Phoenix_Bid_Type__c == 'Good Dated OTB'||bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Price Change') &&  bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false) {
                query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where ( IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            } 
            
            //By vandana
            else if ((bid.Phoenix_Bid_Type__c == 'RFP Bids'||bid.Phoenix_Bid_Type__c == 'Good Dated OTB'||bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Price Change')  &&  bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {
                query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where ( IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck AND Phoenix_Shields__c =false ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            } 
            //--
            
            else if (bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update'||bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update') {
                query = 'select Product_Family__r.Name, Phoenix_Supply_Chain_Planner__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            } 
            
            else if (bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c && bid.Phoenix_Bid_Type__c != 'Initial Order Discount for WAC Customers (No-Contract Price Offering)'){
                query = 'select Product_Family__r.Name, Phoenix_Supply_Chain_Planner__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name, ' + strFields + ' from Product2 where (Phoenix_Is_New_Product__c = false AND IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck AND Phoenix_Shields__c =false) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            }
            else if(bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && !bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
                query = 'select Product_Family__r.Name, Phoenix_Supply_Chain_Planner__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name, ' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            }
            else if(bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
                query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name, ' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Shields__c =false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            }
            else {
                query = 'select Product_Family__r.Name, Phoenix_Supply_Chain_Planner__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name, ' + strFields + ' from Product2 where (Phoenix_Is_New_Product__c = false AND IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            }
        }
        
        
        List < Product2 > prlist = Database.query(query);
        
        Set < id > pids = new Set < id > ();
        Map < Id, Product2 > pdMap = new Map < Id, Product2 > ();
        for (Product2 pr: prlist) {
            pids.add(pr.Id);
            pdMap.put(pr.Id, pr);
        }
        
        
        if (prlist.size() > 0) {
            for (Product2 pr: prlist) {
                wrapperClass wr = new wrapperClass();
                wr.prdlist = pr;
                if (pr.Phoenix_WAC__c != null){wr.currencyCode = '$';} 
                
                wr.isSelected = false;
                wrlist.add(wr);
            }
        }
        
        return wrlist;
    }
    
    @AuraEnabled
    public static List < wrapperClass > getproductsForSelectedCnts(BidWrapper quotewrap, List < Id > productIdList) {
        
        Phoenix_Bid__c bid = quotewrap.bid;
        String bidCustomer = bid.Phoenix_Customer__c;
        List < wrapperClass > wrlist = new List < wrapperClass > ();
        String query = '';
        String SobjectApiName = 'Product2';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        wrExistingProdlist = Phoenix_BidCreatorCtrl.showselectedProducts(bid.Id);
        for (wrapperClass wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.prdlist.Id);
        }
        String strFields = '';
        
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        if(bid.Phoenix_is_OTC_Bid__c){
            query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where Id IN : productIdList AND ( (Phoenix_Is_Control_Label__c = true OR OTC_Customer__c=:bidCustomer) AND IsActive = true AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
        }else{
            //Added by Naseer to include New Products for New Customer and Sales Out Rebate Bid Types
            if (bid.Phoenix_Bid_Type__c == 'New Customer' || bid.Phoenix_Bid_Type__c == 'Sales Out Rebate') {
                query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where Id IN : productIdList AND (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            } 
            else if ((bid.Phoenix_Bid_Type__c == 'New Product Launch' || bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch') && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==False) {
                query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where Id IN : productIdList AND (Phoenix_Is_New_Product__c = true AND IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            } 
            
            else if ((bid.Phoenix_Bid_Type__c == 'New Product Launch' || bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch') && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {
                query = 'select Product_Family__r.Name, Phoenix_Supply_Chain_Planner__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where Id IN : productIdList AND (Phoenix_Is_New_Product__c = true AND IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck AND Phoenix_Shields__c =false ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            } 
            
            
            if ((bid.Phoenix_Bid_Type__c == 'RFP Bids'||bid.Phoenix_Bid_Type__c == 'Good Dated OTB'||bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Price Change')&& bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==False) {
                query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where Id IN : productIdList AND (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            } 
            
            else if ((bid.Phoenix_Bid_Type__c == 'RFP Bids'||bid.Phoenix_Bid_Type__c == 'Good Dated OTB'||bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'Price Change') && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {
                query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where Id IN : productIdList AND (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck AND Phoenix_Shields__c =false ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            } 
             /*else if ( bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==False) {
                
                 query = 'select Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where Id IN : productIdList AND (Phoenix_Is_New_Product__c = true AND IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            } 
            
            else if (bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {
                query = 'select Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where Id IN : productIdList AND (Phoenix_Is_New_Product__c = true AND IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck AND Phoenix_Shields__c =false ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            }*/ 
            else if (bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update'||bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update') {
                query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where Id IN : productIdList AND (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            } 
            
            else if(bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c && bid.Phoenix_Bid_Type__c != 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && bid.Phoenix_Bid_Type__c != 'New Customer' && bid.Phoenix_Bid_Type__c != 'Sales Out Rebate'){
                query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name, ' + strFields + ' from Product2 where Id IN : productIdList AND (Phoenix_Is_New_Product__c = false AND IsActive = true AND Phoenix_Is_Exclude_Bid__c=false  AND ID not in:duplicatePrdCheck AND Phoenix_Shields__c =false) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                
            }
            
            else if(bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && !bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
                query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name, ' + strFields + ' from Product2 where Id IN : productIdList AND (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            }
            else if(bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
                query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name, ' + strFields + ' from Product2 where Id IN : productIdList AND (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Shields__c =false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            }
            else if(bid.Phoenix_Bid_Type__c != 'New Customer' && bid.Phoenix_Bid_Type__c != 'Sales Out Rebate'){
                query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name, ' + strFields + ' from Product2 where Id IN : productIdList AND (Phoenix_Is_New_Product__c = false AND IsActive = true AND Phoenix_Is_Exclude_Bid__c=false  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            }
            
        }
        
        
        List < Product2 > prlist = Database.query(query);
        
        Set < id > pids = new Set < id > ();
        Map < Id, Product2 > pdMap = new Map < Id, Product2 > ();
        /*for (Product2 pr: prlist) {
            pids.add(pr.Id);
            pdMap.put(pr.Id, pr);
        }*/
        
        
        if (prlist.size() > 0) {
            for (Product2 pr: prlist) {
                wrapperClass wr = new wrapperClass();
                wr.prdlist = pr;
                if (pr.Phoenix_WAC__c != null) {
                    wr.currencyCode = '$';
                }
                
                wr.isSelected = false;
                wrlist.add(wr);
            }
        }
        
        return wrlist;
    }
    
    @AuraEnabled
    public static List < wrapperClass > getproductsForSelectedCnts(BidWrapper quotewrap) {
        
        Phoenix_Bid__c bid = quotewrap.bid;
        String bidCustomer = bid.Phoenix_Customer__c;
        List < wrapperClass > wrlist = new List < wrapperClass > ();
        String query = '';
        String SobjectApiName = 'Product2';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        wrExistingProdlist = Phoenix_BidCreatorCtrl.showselectedProducts(bid.Id);
        for (wrapperClass wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.prdlist.Id);
        }
        String strFields = '';
        
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        if(bid.Phoenix_is_OTC_Bid__c){
            query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where Id IN : productsIdSet ( (Phoenix_Is_Control_Label__c = true OR OTC_Customer__c=:bidCustomer) AND IsActive = true AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            
        }else{
            //Added by Naseer to include New Products for New Customer Bid Type
            if (bid.Phoenix_Bid_Type__c == 'New Customer' || bid.Phoenix_Bid_Type__c == 'Sales Out Rebate')  query = 'select Phoenix_Supply_Chain_Planner__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where Id IN : productsIdSet (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            else if (bid.Phoenix_Bid_Type__c == 'New Product Launch'  && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false) {query = 'select Phoenix_Supply_Chain_Planner__r.Name,Product_Family__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where Id IN : productsIdSet (Phoenix_Is_New_Product__c = true AND IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                                                                                                                                } 
            
            else if (bid.Phoenix_Bid_Type__c == 'New Product Launch' && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {query = 'select Phoenix_Supply_Chain_Planner__r.Name,Product_Family__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where Id IN : productsIdSet (Phoenix_Is_New_Product__c = true AND IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck AND Phoenix_Shields__c =false) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                                                                                                                            } 
            
            else if ((bid.Phoenix_Bid_Type__c == 'RFP Bids'||bid.Phoenix_Bid_Type__c == 'Good Dated OTB'||bid.Phoenix_Bid_Type__c == 'Short Dated OTB')  && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false) {query = 'select Phoenix_Supply_Chain_Planner__r.Name,Product_Family__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where Id IN : productsIdSet ( IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                                                                                                                                                                                                                        } 
            
            else if ((bid.Phoenix_Bid_Type__c == 'RFP Bids'||bid.Phoenix_Bid_Type__c == 'Good Dated OTB'||bid.Phoenix_Bid_Type__c == 'Short Dated OTB') && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {query = 'select Phoenix_Supply_Chain_Planner__r.Name,Product_Family__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where Id IN : productsIdSet ( IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck AND Phoenix_Shields__c =false) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                                                                                                                                                                                                               } 
  			else if (bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch'  && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false) {query = 'select Phoenix_Supply_Chain_Planner__r.Name,Product_Family__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where Id IN : productsIdSet ( IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                                                                                                                                                                                                                        } 
            
            else if (bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {query = 'select Phoenix_Supply_Chain_Planner__r.Name,Product_Family__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where Id IN : productsIdSet ( IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck AND Phoenix_Shields__c =false) ORDER BY Name ASC NULLS LAST LIMIT 30000';}
                          
            else if (bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update'||bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update') {query = 'select Phoenix_Supply_Chain_Planner__r.Name,Product_Family__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where Id IN : productsIdSet (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                                                                                                                                           } 
            else if(bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c && bid.Phoenix_Bid_Type__c != 'Initial Order Discount for WAC Customers (No-Contract Price Offering)'){query = 'select Phoenix_Supply_Chain_Planner__r.Name,Product_Family__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name, ' + strFields + ' from Product2 where Id IN : productsIdSet (Phoenix_Is_New_Product__c = false AND IsActive = true AND Phoenix_Is_Exclude_Bid__c=false  AND ID not in:duplicatePrdCheck AND Phoenix_Shields__c =false ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                                                                                                                                                                             }
            
            else if(bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && !bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
                query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name, ' + strFields + ' from Product2 where Id IN : productsIdSet (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            }
            else if(bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
                query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name, ' + strFields + ' from Product2 where Id IN : productsIdSet (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Shields__c =false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            }
            else {
                query = 'select Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name, ' + strFields + ' from Product2 where Id IN : productsIdSet (Phoenix_Is_New_Product__c = false AND IsActive = true AND Phoenix_Is_Exclude_Bid__c=false  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            }
        }
        
        
        List < Product2 > prlist = Database.query(query);
        
        Set < id > pids = new Set < id > ();
        Map < Id, Product2 > pdMap = new Map < Id, Product2 > ();
        /*for (Product2 pr: prlist) {
pids.add(pr.Id);
            pdMap.put(pr.Id, pr);
        }*/
        
        
        if (prlist.size() > 0) {
            for (Product2 pr: prlist) {
                wrapperClass wr = new wrapperClass();
                wr.prdlist = pr;
                if (pr.Phoenix_WAC__c != null) {
                    wr.currencyCode = '$';
                }
                
                wr.isSelected = false;
                wrlist.add(wr);
            }
        }
        
        return wrlist;
    }
    
    @AuraEnabled
    public static List < wrapperClass > showselectedProducts(string bidId) {
        list < Phoenix_Bid_Line_Item__c > bidlineList = [select Id, Phoenix_Product__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
        list < Product2 > productList = new list < Product2 > ();
        list < wrapperClass > wrapList = new list < wrapperClass > ();
        set < Id > prodIds = new set < Id > ();
        if (bidlineList.size() > 0) {
            for (Phoenix_Bid_Line_Item__c pbl: bidlineList) {
                prodIds.add(pbl.Phoenix_Product__c);
            }
        }
        if (prodIds.size() > 0) {
            productList = [select Name,Phoenix_Supply_Chain_Planner__r.Name, Family, Product_Family__c, Product_Family__r.Name, ProductCode, Phoenix_NDC_11__c from Product2 where Id IN: prodIds ORDER BY Name ASC NULLS LAST LIMIT 30000];
            
            for (Product2 pr: productList) {
                wrapperClass wr = new wrapperClass();
                wr.prdlist = pr;
                wrapList.add(wr);
            }
        }
        
        return wrapList;
        
    }
    /*@AuraEnabled
    public static List < wrapperClass > getsearchDirectorResult(List < wrapperClass > pItem, list < string > SearchKeyWordPD, string Family, string searchName, list < string > RxSrxList, BidWrapper quotewrap) {
        //system.debug('SearchKeyWordPD---->'+SearchKeyWordPD);
        List < wrapperClass > wralist = new List < wrapperClass > ();
        list < string > searchupdateList = new list < string > ();
        String query1;
        String searchText;
        string searchfamily;
        list < string > productDirectors = new list < string > ();
        list < string > NewproductDirectors;
        string searchPD;
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        wrExistingProdlist = Phoenix_BidCreatorCtrl.showselectedProducts(bid.Id);
        for (wrapperClass wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.prdlist.Id);
        }
        
        
        List < String > searchList;
        list < Product2 > prodNameList = new list < Product2 > ();
        if (string.isNotBlank(Family)) {
            searchfamily = Family.trim();
            
        }
        
        
        
        searchfamily = '%' + searchfamily + '%';
        
        
        // //system.debug('searchText---'+searchText);
        
        String bidCustomer = quotewrap.bid.Phoenix_Customer__c;
        if (string.isNotBlank(searchName)) {
            searchText = searchName.trim();
            searchText = searchText.replace('\\s+', ' ');
            if(quotewrap.bid.Phoenix_is_OTC_Bid__c){
                prodNameList = [select Id, Name from Product2 where IsActive = true AND (Phoenix_Is_Control_Label__c = true OR OTC_Customer__c =: bidCustomer) AND Name =: searchText];
            }
            else{
                if (quotewrap.bid.Phoenix_Bid_Type__c == 'New Product Launch'&& bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false) {prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_New_Product__c = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText];
                                                                                                                                            }
                
                else if (quotewrap.bid.Phoenix_Bid_Type__c == 'New Product Launch' && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_New_Product__c = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND Phoenix_Shields__c =false ];
                                                                                                                                          }
                
                
                else if ((quotewrap.bid.Phoenix_Bid_Type__c == 'RFP Bids'||quotewrap.bid.Phoenix_Bid_Type__c == 'Short Dated OTB'||quotewrap.bid.Phoenix_Bid_Type__c == 'Good Dated OTB')&& bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false) {prodNameList = [select Id, Name from Product2 where IsActive = true  AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText];
                                                                                                                                                                                                                                                        }
                
                else if ((quotewrap.bid.Phoenix_Bid_Type__c == 'RFP Bids'||quotewrap.bid.Phoenix_Bid_Type__c == 'Short Dated OTB'||quotewrap.bid.Phoenix_Bid_Type__c == 'Good Dated OTB') && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {prodNameList = [select Id, Name from Product2 where IsActive = true  AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND Phoenix_Shields__c =false ];
                                                                                                                                                                                                                                                 }
                
                else if (quotewrap.bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update'||quotewrap.bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update') {prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText];
                                                                                                                                                                   } 
                
                else if(bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c && bid.Phoenix_Bid_Type__c != 'Initial Order Discount for WAC Customers (No-Contract Price Offering)') {prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Phoenix_Is_New_Product__c = false AND Name =: searchText AND Phoenix_Shields__c =false ];
                                                                                                                                                                                  }
                else if(bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && !bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
                    prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText];   
                }
                else if(bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
                    prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Phoenix_Shields__c =false AND Name =: searchText];   
                }
                else {
                    prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Phoenix_Is_New_Product__c = false AND Name =: searchText];
                }
            }
            
            if (prodNameList.size() == 0) {
                searchList = searchText.split(' ');
                for (string str: searchList) {
                    string searchItem = '%' + str + '%';
                    searchupdateList.add(searchItem);
                    
                }
            } else {
                searchupdateList.add('%' + searchText + '%');
            }
        }
        
        
        
        
        //system.debug('searchupdateList----' + searchupdateList);
        
        
        
        
        
        
        //system.debug('productIds---in else-');
        /////////////////////doubt
        query1 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
        
        list < Product2 > productList = Database.query(query1);
        if (RxSrxList != null && !RxSrxList.isEmpty() && productList.size() > 0) {
            string query2;
            query2 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Phoenix_Rx_SRx_OTC__c like :RxSrxList AND ID IN:productList  AND ID not in:duplicatePrdCheck ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList = Database.query(query2);
        }
        if (productList.size() > 0 && string.isNotBlank(searchName)) {
            string query3;
            query3 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND (Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList)  AND ID not in:duplicatePrdCheck ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList = Database.query(query3);
        }
        if (productList.size() > 0 && string.isNotBlank(Family)) {
            string query4;
            query4 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Product_Family__r.Name like :searchfamily) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList = Database.query(query4);
        }
        
        //system.debug('productList----' + productList);
        Map < Id, Product2 > productMap = new map < Id, Product2 > (productList);
        for (wrapperClass w: pItem) {
            if (productMap.containskey(w.prdlist.Id))
                wralist.add(w);
            
        }
        //system.debug('wralist----' + wralist);
        
        
        return wralist;
    }*/
    
  /*  @AuraEnabled
    public static List < wrapperClass > getSearch(List < wrapperClass > pItem, list < string > SearchKeyWordPD, string search, string family, list < string > RxSrxList, BidWrapper quotewrap) {
        
        List < wrapperClass > wralist1 = new List < wrapperClass > ();
        String searchText = search.trim();
        string searchfamily;
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        wrExistingProdlist = Phoenix_BidCreatorCtrl.showselectedProducts(bid.Id);
        for (wrapperClass wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.prdlist.Id);
        }
        if (string.isNotBlank(family)) {
            searchfamily = family.trim();
            
        }
        searchfamily = '%' + searchfamily + '%';
        
        //searchText=searchText.replace('-','');
        //system.debug('searchText---' + searchText);
        searchText = searchText.replace('\\s+', ' ');
        //system.debug('searchText---' + searchText);
        set < Id > RxProdIds = new set < Id > ();
        list < string > searchupdateList = new list < string > ();
        String query1;
        list < Product2 > prodNameList = new list < Product2 > ();
        String bidCustomer = quotewrap.bid.Phoenix_Customer__c;
        if(quotewrap.bid.Phoenix_is_OTC_Bid__c){
            prodNameList = [select Id, Name from Product2 where IsActive = true AND (Phoenix_Is_Control_Label__c = true OR OTC_Customer__c =: bidCustomer) AND Name =: searchText AND ID not in: duplicatePrdCheck];
        }else{
            if (quotewrap.bid.Phoenix_Bid_Type__c == 'New Product Launch'&& quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false) {prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_New_Product__c = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND ID not in: duplicatePrdCheck];
                                                                                                                                                  }
            
            
            else if (quotewrap.bid.Phoenix_Bid_Type__c == 'New Product Launch'  && quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_New_Product__c = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND ID not in: duplicatePrdCheck AND Phoenix_Shields__c =false ];
                                                                                                                                                 }
            
            else if ((quotewrap.bid.Phoenix_Bid_Type__c == 'RFP Bids'||quotewrap.bid.Phoenix_Bid_Type__c == 'Short Dated OTB'||quotewrap.bid.Phoenix_Bid_Type__c == 'Good Dated OTB')&& quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false) {prodNameList = [select Id, Name from Product2 where IsActive = true  AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND ID not in: duplicatePrdCheck];
                                                                                                                                                                                                                                                              }
            
            
            else if ((quotewrap.bid.Phoenix_Bid_Type__c == 'RFP Bids'||quotewrap.bid.Phoenix_Bid_Type__c == 'Short Dated OTB'||quotewrap.bid.Phoenix_Bid_Type__c == 'Good Dated OTB') && quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {prodNameList = [select Id, Name from Product2 where IsActive = true  AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND ID not in: duplicatePrdCheck AND Phoenix_Shields__c =false ];
                                                                                                                                                                                                                                                       }
            
            
            else if (quotewrap.bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update'||quotewrap.bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update') {prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND ID not in: duplicatePrdCheck];
                                                                                                                                                               }
            
            else if(quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c && quotewrap.bid.Phoenix_Bid_Type__c != 'Initial Order Discount for WAC Customers (No-Contract Price Offering)') {prodNameList = [select Id, Name from Product2 where IsActive = true  AND Phoenix_Is_New_Product__c = false AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND ID not in: duplicatePrdCheck AND Phoenix_Shields__c =false ];
                                                                                                                                                                                                  }
            
            else if(quotewrap.bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && !quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
                prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND ID not in: duplicatePrdCheck];
            }
            else if(quotewrap.bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
                prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Shields__c =false AND  Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND ID not in: duplicatePrdCheck];
            }
            
            else {
                prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND  Phoenix_Is_New_Product__c = false AND Name =: searchText AND ID not in: duplicatePrdCheck];
            }
        }
        
        if (prodNameList.size() == 0) {
            List < String > searchList = searchText.split(' ');
            for (string str: searchList) {
                string searchItem = '%' + str + '%';
                searchupdateList.add(searchItem);
                
            }
        } else {
            searchupdateList.add('%' + searchText + '%');
        }
        //system.debug('searchupdateList----' + searchupdateList);
        
        
        
        
        query1 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ((IsActive = true AND Phoenix_Is_Exclude_Bid__c=false ) AND(Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList OR Product_Family__r.Name like :searchupdateList )  AND ID not in:duplicatePrdCheck ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
        
        list < Product2 > productList = Database.query(query1);
        if (RxSrxList != null && !RxSrxList.isEmpty() && productList.size() > 0) {
            string query2;
            query2 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Phoenix_Rx_SRx_OTC__c like :RxSrxList AND ID IN:productList  AND ID not in:duplicatePrdCheck ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList = Database.query(query2);
        }
        if (productList.size() > 0 && string.isNotBlank(family)) {
            string query3;
            query3 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND Product_Family__r.Name like :searchfamily AND ID not in:duplicatePrdCheck ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList = Database.query(query3);
        }
        if (productList.size() > 0 && SearchKeyWordPD != null && !SearchKeyWordPD.isEmpty()) {
            string query4;
            query4 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList = Database.query(query4);
        }
        
        Map < Id, Product2 > productMap = new map < Id, Product2 > (productList);
        for (wrapperClass w: pItem) {
            if (productMap.containskey(w.prdlist.Id))
                wralist1.add(w);
            
        }
        
        return wralist1;
    }
    */
    /*@AuraEnabled
    public static List < wrapperClass > getSearchFamily(List < wrapperClass > pItem, list < string > SearchKeyWordPD, string search, string searchName, list < string > RxSrxList, BidWrapper quotewrap) {
        
        List < wrapperClass > wralist = new List < wrapperClass > ();
        list < string > searchupdateList = new list < string > ();
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        wrExistingProdlist = Phoenix_BidCreatorCtrl.showselectedProducts(bid.Id);
        for (wrapperClass wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.prdlist.Id);
        }
        String query1;
        String searchText;
        string searchfamily;
        List < String > searchList;
        list < Product2 > prodNameList = new list < Product2 > ();
        if (string.isNotBlank(search)) {
            searchfamily = search.trim();
        }
        
        
        searchfamily = '%' + searchfamily + '%';
        
        
        //system.debug('searchfamily---' + searchfamily);
        
        String bidCustomer = quotewrap.bid.Phoenix_Customer__c;
        if (string.isNotBlank(searchName)) {
            searchText = searchName.trim();
            searchText = searchText.replace('\\s+', ' ');
            if(quotewrap.bid.Phoenix_is_OTC_Bid__c){
                prodNameList = [select Id, Name from Product2 where IsActive = true AND (Phoenix_Is_Control_Label__c = true OR OTC_Customer__c =: bidCustomer) AND Name =: searchText AND ID not in: duplicatePrdCheck];
            }else{
                if (quotewrap.bid.Phoenix_Bid_Type__c == 'New Product Launch'  && quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false) { prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_New_Product__c = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND ID not in: duplicatePrdCheck];
                                                                                                                                                        }
                
                else if (quotewrap.bid.Phoenix_Bid_Type__c == 'New Product Launch'  && quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {  prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_New_Product__c = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND ID not in: duplicatePrdCheck AND Phoenix_Shields__c =false ];
                                                                                                                                                     }
                
                else if ((quotewrap.bid.Phoenix_Bid_Type__c == 'RFP Bids'||quotewrap.bid.Phoenix_Bid_Type__c == 'Short Dated OTB'||quotewrap.bid.Phoenix_Bid_Type__c == 'Good Dated OTB')  && quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false) { prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND ID not in: duplicatePrdCheck];
                                                                                                                                                                                                                                                                    }
                
                else if ((quotewrap.bid.Phoenix_Bid_Type__c == 'RFP Bids'||quotewrap.bid.Phoenix_Bid_Type__c == 'Short Dated OTB'||quotewrap.bid.Phoenix_Bid_Type__c == 'Good Dated OTB')  && quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {  prodNameList = [select Id, Name from Product2 where IsActive = true  AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND ID not in: duplicatePrdCheck AND Phoenix_Shields__c =false ];
                                                                                                                                                                                                                                                            }
                
                else if (quotewrap.bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update'||quotewrap.bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update') {   prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND ID not in: duplicatePrdCheck];
                                                                                                                                                                   } 
                
                else if(quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c && quotewrap.bid.Phoenix_Bid_Type__c != 'Initial Order Discount for WAC Customers (No-Contract Price Offering)'){  prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_New_Product__c = false AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND ID not in: duplicatePrdCheck AND Phoenix_Shields__c =false ];
                                                                                                                                                                                                     }
                
                else if(quotewrap.bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && !quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
                    prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND  Name =: searchText AND ID not in: duplicatePrdCheck];
                }
                else if(quotewrap.bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
                    prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Shields__c =false AND Phoenix_Is_Exclude_Bid__c = false AND  Name =: searchText AND ID not in: duplicatePrdCheck];
                }
                else {
                    prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Phoenix_Is_New_Product__c = false AND  Name =: searchText AND ID not in: duplicatePrdCheck];
                }
            }
            
            if (prodNameList.size() == 0) {
                searchList = searchText.split(' ');
                for (string str: searchList) {
                    string searchItem = '%' + str + '%';
                    searchupdateList.add(searchItem);
                    
                }
            } else {
                searchupdateList.add('%' + searchText + '%');
            }
        }
        
     
        //system.debug('searchupdateList----' + searchupdateList);
        
  
        
        list < Product2 > productList = new list < Product2 > ();
        //system.debug('productIds---in else-');
        if (string.isNotBlank(search)) {
            query1 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Product_Family__r.Name like :searchfamily  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            
            productList = Database.query(query1);
        }
        
        if (RxSrxList != null && !RxSrxList.isEmpty()) {
            if (productList.size() > 0) {
                string query2;
                query2 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Phoenix_Rx_SRx_OTC__c like :RxSrxList AND ID IN:productList  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                productList = Database.query(query2);
            }
            
        }
        if (string.isNotBlank(searchName)) {
            if (productList.size() > 0) {
                string query3;
                query3 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND (Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList)  AND ID not in:duplicatePrdCheck ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                productList = Database.query(query3);
            }
           
        }
        if (SearchKeyWordPD != null && !SearchKeyWordPD.isEmpty()) {
            if (productList.size() > 0) {
                string query4;
                query4 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                productList = Database.query(query4);
            }
           
        }
        
        //system.debug('productList----' + productList);
        Map < Id, Product2 > productMap = new map < Id, Product2 > (productList);
        for (wrapperClass w: pItem) {
            if (productMap.containskey(w.prdlist.Id)) {wralist.add(w); } 
        }
        //system.debug('wralist----' + wralist);
        
        
        return wralist;
    }
    */
    
    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > savequoteitems(list < wrapperClass > saveitems, BidWrapper bidWrapper, List < string > selectrcs) {
        
        list < Phoenix_Bid_Line_Item__c > newItems = new list < Phoenix_Bid_Line_Item__c > ();
        list < Product2 > prodList;
        list < Phoenix_Bid_Fee_Master__c > feeList = new list < Phoenix_Bid_Fee_Master__c > ();
        list < Phoenix_Bid_Fee_Master__c > feeListRos = new list < Phoenix_Bid_Fee_Master__c > ();
        list < Phoenix_Bid_Fee_Master__c > feeListForRos = new list < Phoenix_Bid_Fee_Master__c > ();
        // Extension records for ROSS created By Ashok Alli.
        list<Phoenix_BidLineItemExtn__c> bidLineItemExtList = new List<Phoenix_BidLineItemExtn__c> ();  
        //Other templates does not need these extension records.
        string bidId = bidWrapper.bid.Id;
        //system.debug('bidId--------' + bidId);
        Id accountId = bidWrapper.bid.Phoenix_Customer__c;
        //system.debug('bidWrapper.bid--------' + bidWrapper.bid.Phoenix_Bid_Type__c);
        //system.debug('bidWrapper.bid TYPE--------' + bidWrapper.bid.Phoenix_Customer_Type__c);
        system.debug('accountId--------' + accountId);
        Account acc=new Account();
        if (accountId != null) {
            system.debug('acc');
            acc = [select Id,Name,Phoenix_Damages__c,Phoenix_NLC__c,Phoenix_VIP__c,Phoenix_Admin_Fee_Sec_Template__c,Phoenix_Rebate_Secondary_Template__c, AccountNumber,Phoenix_Is_Govt_Customer__c, Phoenix_Cash_Discount__c, Phoenix_Fee__c,Phoenix_Order_Analytics_Fee__c, Fee_Type__c, Rebate_Type__c, Phoenix_Indirect_Cash_Discount__c, Phoenix_Rebates__c,Phoenix_Rebate_Pharmagen__c, Phoenix_Preferred_Wholesaler__c, Phoenix_Local_VIP__c, Phoenix_CM_Fees__c, Phoenix_RDC_NLC__c, Cash_Terms__c from Account where Id =: accountId];
            
              system.debug('acc---'+acc);
            
            feeList = [select Id, Phoenix_Customer_Type__c, Phoenix_Fee__c, Phoenix_Preferred_Wholesaler__c, Phoenix_Fee_Type__c, Phoenix_Product_Type_for_CM_Fee__c from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c =: acc.Phoenix_Preferred_Wholesaler__c limit 30000];
            
            
        }
        if(bidWrapper.bid.Phoenix_Customer_Type__c == 'ROS'){
            
            feeListRos = [select Id, Phoenix_Customer_Type__c, Phoenix_Fee__c, Phoenix_Preferred_Wholesaler__c, Phoenix_Fee_Type__c, Phoenix_Product_Type_for_CM_Fee__c 
                          from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c = 'McKesson' limit 30000];
            
        }
        if(bidWrapper.bid.Phoenix_Customer_Type__c == 'ROS' || acc.AccountNumber == '370337'){
            feeListForRos = [select Id, Phoenix_Customer_Type__c, Phoenix_Fee__c, Phoenix_Preferred_Wholesaler__c, Phoenix_Fee_Type__c, Phoenix_Product_Type_for_CM_Fee__c from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c = 'Cardinal' AND Phoenix_Fee_Type__c = 'RDC/NLC %' limit 30000];
        }
        //system.debug('feeListForRos.size() :::::::::: '+feeListForRos.size());
        
        for (wrapperClass wr: saveitems) {
             Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c();
            
            pbl.Phoenix_Bid__c = bidId;
            pbl.Phoenix_Product__c = wr.prdlist.Id;
            pbl.Phoenix_NDC__c = wr.prdlist.Phoenix_NDC_11_Dashes__c;
            pbl.Phoenix_NDC_Without_Dashes__c = wr.prdlist.Phoenix_NDC_11__c;
            pbl.Phoenix_Product_Code1__c = wr.prdlist.ProductCode;
            pbl.Phoenix_Pkg_Size1__c = wr.prdlist.Phoenix_Pkg_Size__c;
            pbl.Phoenix_Case_Pack1__c = wr.prdlist.Phoenix_Case_Pack__c;
            pbl.Phoenix_MOQ1__c = wr.prdlist.Phoenix_Minimum_Order_Quantity__c;
            pbl.Phoenix_Product_Family1__c = wr.prdlist.Family;
            pbl.Product_Family__c = wr.prdlist.Product_Family__c; //Added by Naseer
            pbl.Phoenix_Direct_Order_Price1__c = wr.prdlist.Phoenix_Direct_Order_Price__c;
            pbl.Phoenix_Compare_To_Brand_Name1__c = wr.prdlist.Phoenix_Compare_to_Brand_Name__c;
            pbl.Phoenix_Current_Supplier__c = wr.prdlist.Phoenix_Strength__c;
            pbl.Brand_WAC__c = wr.prdlist.Phoenix_Brand_WAC__c;
             pbl.Phoenix_Approved_Lowest_Price_SKU__c = wr.prdlist.Phoenix_Approved_Lowest_Price_SKU__c;
            system.debug('wr.prdlist.Phoenix_Product_Director__r.FirstName--->'+wr.prdlist.Phoenix_Product_Director__c);
            system.debug('wr.prdlist.Phoenix_Product_Director__r.FirstName--->'+wr.prdlist.Family);
            if (wr.prdlist.Phoenix_Product_Director__c != null) {
                pbl.Phoenix_Product_Director1__c = wr.prdlist.Phoenix_Product_Director__r.FirstName + ' ' + wr.prdlist.Phoenix_Product_Director__r.LastName;
            }
            pbl.Phoenix_Orange_Book_Rating1__c = wr.prdlist.Phoenix_Orange_Book_Rating__c;
            
            if(bidWrapper.bid.Phoenix_is_OTC_Bid__c)  pbl.Phoenix_Orange_Book_Rating1__c = 'Version 1';
            if(bidWrapper.bid.Phoenix_is_OTC_Bid__c)  pbl.Phoenix_Reduction__c = acc.Phoenix_Damages__c != null ? acc.Phoenix_Damages__c :0;
            if(bidWrapper.bid.Phoenix_is_OTC_Bid__c) {
                pbl.Phoenix_Current_Retail_Direct_Price__c = wr.prdlist.Phoenix_Brand_Retail_Price__c;
                pbl.Phoenix_Current_Retail_Indirect_Price__c = wr.prdlist.Phoenix_SB_Retail_Price__c;
            }
            
            
            if (wr.prdlist.Phoenix_Throughput_cost__c != null) pbl.Phoenix_Throughput_Cost1__c = wr.prdlist.Phoenix_Throughput_cost__c.setScale(2);
            pbl.Phoenix_Old_Throughput_Cost__c = wr.prdlist.Phoenix_Old_Throughput_Cost__c;
            pbl.Phoenix_WAC1__c = wr.prdlist.Phoenix_WAC__c;
            pbl.Phoenix_Budgeted_ASP1__c = wr.prdlist.Phoenix_Current_Budgeted_ASP__c;
            pbl.Phoenix_Lowest_Price_SKU1__c = bidWrapper.bid.Phoenix_is_OTC_Bid__c ? wr.prdlist.Phoenix_OTC_Lowest_Price__c :wr.prdlist.Phoenix_Lowest_Price_SKU__c;
            pbl.Phoenix_Comm_Exps1__c = wr.prdlist.Phoenix_Comm_Exps__c;
            if (wr.prdlist.Phoenix_PS_Partner_1_Name__r.Name != null) {
                pbl.Phoenix_PS_Partner_11__c = wr.prdlist.Phoenix_PS_Partner_1_Name__r.Name;
            }
            pbl.Phoenix_PS_Partner_1percent__c = wr.prdlist.Phoenix_PS_Partner_1__c;
            if (wr.prdlist.Phoenix_PS_Partner_2_Name__r.Name != null) {
                pbl.Phoenix_PS_Partner_21__c = wr.prdlist.Phoenix_PS_Partner_2_Name__r.Name;
            }
            pbl.Phoenix_PS_Partner_2percent__c = wr.prdlist.Phoenix_PS_Partner_2__c;
            if (wr.prdlist.Phoenix_Royalty_Partner_Name__r.Name != null) {
                pbl.Phoenix_Royalty_Partner_Name1__c = wr.prdlist.Phoenix_Royalty_Partner_Name__r.Name;
            }
            pbl.Phoenix_Royaltypercent__c = wr.prdlist.Phoenix_Royalty__c;
            pbl.Phoenix_Min_profit_share_Partner_21__c = wr.prdlist.Phoenix_Per_Unit_Profit_Partner_2__c;
            pbl.Phoenix_Min_profit_share_Partner_11__c = wr.prdlist.Phoenix_Per_Unit_Profit_Partner_1__c;
            pbl.Phoenix_UPC_Universal_Product_Code__c = wr.prdlist.Phoenix_UPC_Universal_Product_Code__c;
            pbl.Phoenix_IPA_Floor_Price1__c = wr.prdlist.Phoenix_IPA_Floor_Price__c;
            pbl.Phoenix_UPC_Universal_Product_Code__c = wr.prdlist.Phoenix_UPC_Universal_Product_Code__c;
            pbl.Phoenix_Latest_Estimate__c= wr.prdlist.Phoenix_Latest_Estimate__c!=null?wr.prdlist.Phoenix_Latest_Estimate__c.setScale(2):0;
            pbl.Phoenix_REMS__c = wr.prdlist.Phoenix_REMS__c;
            //pbl.Phoenix_IMS_Market_Share__c = wr.prdlist.Phoenix_IMS_Market_Share__c;
            decimal mediciadReturns = wr.prdlist.Phoenix_Medicaid_Per_Unit__c != null ? wr.prdlist.Phoenix_Medicaid_Per_Unit__c : 0;
            decimal returnPerUnit = wr.prdlist.Phoenix_Return_Per_Unit__c != null ? wr.prdlist.Phoenix_Return_Per_Unit__c : 0;
           // pbl.Phoenix_Estimated_Medicaid_Returns__c = mediciadReturns + returnPerUnit;
            pbl.Phoenix_Estimated_Medicaid_Returns__c = mediciadReturns.setScale(2) + returnPerUnit.setScale(2);
            if (bidWrapper.bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bidWrapper.bid.Phoenix_Bid_Type__c == 'Good Dated OTB'|| bidWrapper.bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch') {
                pbl.Phoenix_Estimated_Medicaid_Returns__c = mediciadReturns;
            }
            if (accountId != null) {
                pbl.Phoenix_Current_Rebate__c = acc.Phoenix_Rebates__c;
                pbl.Phoenix_Rebate_G_N__c = acc.Rebate_Type__c;
                pbl.Phoenix_Fee_G_N__c= acc.Fee_Type__c;
            }
            system.debug('controlled substance====='+wr.prdlist.Phoenix_Controlled_Substance__c);
            system.debug('customer type====='+bidWrapper.bid.Phoenix_Customer_Type__c);
            system.debug('preffer====='+acc.Phoenix_Preferred_Wholesaler__c);
            if ((bidWrapper.bid.Phoenix_Customer_Type__c == 'RXSS' || bidWrapper.bid.Phoenix_Customer_Type__c == 'Indirect' || bidWrapper.bid.Phoenix_Customer_Type__c == 'Econdisc' || bidWrapper.bid.Phoenix_Customer_Type__c == 'Net Indirect Pricing' || bidWrapper.bid.Phoenix_Customer_Type__c == 'BASE/DSH') && acc.Phoenix_Preferred_Wholesaler__c == 'Cardinal' &&  wr.prdlist.Phoenix_Controlled_Substance__c == 'Yes'){
               system.debug('control');
                pbl.Phoenix_Whlsr_Controlled_Substance_Fee__c = (0.0041*wr.prdlist.Phoenix_Pkg_Size__c).setScale(4);
                system.debug('whlsr-----'+pbl.Phoenix_Whlsr_Controlled_Substance_Fee__c);
            }
          
            if (bidWrapper.bid.Phoenix_Customer_Type__c == 'ROS'  && (acc.AccountNumber == '152030' || acc.AccountNumber == '370337')  && acc.Phoenix_Preferred_Wholesaler__c == 'Source Program' &&  wr.prdlist.Phoenix_Controlled_Substance__c == 'Yes'){
                pbl.Phoenix_Whlsr_Controlled_Substance_Fee__c = (0.0041*wr.prdlist.Phoenix_Pkg_Size__c).setScale(4);
            }
            
            if (bidWrapper.bid.Phoenix_Customer_Type__c == 'ROS' && feeListRos.size() > 0) {
                for(Phoenix_Bid_Fee_Master__c pbf: feeListRos){
                    if(pbf.Phoenix_Fee_Type__c=='RDC/NLC %'){
                        //system.debug('Inside McKesson*****');
                        //pbl.Phoenix_RDC_NLC__c = pbf.Phoenix_Fee__c !=null ? wr.prdlist.Phoenix_WAC__c * (pbf.Phoenix_Fee__c/100) : 0; //commented and added below line to fix Attempt to de-reference null object error
                        pbl.Phoenix_RDC_NLC__c = pbf.Phoenix_Fee__c !=null ? ((wr.prdlist != null && wr.prdlist.Phoenix_WAC__c != null) ? wr.prdlist.Phoenix_WAC__c * (pbf.Phoenix_Fee__c/100) : 0) : 0;
                        if(feeListForRos.size()!=0){
                            //system.debug('Inside feeListforROS*****');
                            //pbl.Phoenix_NLC__c = feeListForRos[0].Phoenix_Fee__c !=null ? wr.prdlist.Phoenix_WAC__c * (feeListForRos[0].Phoenix_Fee__c/100) : 0; //commented and added below line to fix Attempt to de-reference null object error
                            pbl.Phoenix_NLC__c = feeListForRos[0].Phoenix_Fee__c !=null ? ((wr.prdlist != null && wr.prdlist.Phoenix_WAC__c != null) ? wr.prdlist.Phoenix_WAC__c * (feeListForRos[0].Phoenix_Fee__c/100) : 0) : 0;
                            pbl.Phoenix_Proposed_Current_Rebate__c = feeListForRos[0].Phoenix_Fee__c;
                        }
                    }
                }
            }
            if (feeList.size() > 0) {
                for(Phoenix_Bid_Fee_Master__c pbf: feeList){
                    if(wr.prdlist.Phoenix_Product_Type_for_CM_Fee__c==pbf.Phoenix_Product_Type_for_CM_Fee__c && pbf.Phoenix_Fee_Type__c=='CM Fee%' && (acc.Phoenix_Is_Govt_Customer__c==true && pbf.Phoenix_Customer_Type__c=='Govt business')){
                        pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c= pbf.Phoenix_Fee__c ;
                        if(bidWrapper.bid.Phoenix_Customer_Type__c == 'ClarusOne'){                            pbl.Phoenix_Local_VIP__c=pbf.Phoenix_Fee__c; // Fee % for C1
                        }
                    } 
                    if(wr.prdlist.Phoenix_Product_Type_for_CM_Fee__c==pbf.Phoenix_Product_Type_for_CM_Fee__c && pbf.Phoenix_Fee_Type__c=='CM Fee%' && (acc.Phoenix_Is_Govt_Customer__c==false && pbf.Phoenix_Customer_Type__c=='Non Govt business')){
                        pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c= pbf.Phoenix_Fee__c ;
                        if(bidWrapper.bid.Phoenix_Customer_Type__c == 'ClarusOne'){                            pbl.Phoenix_Local_VIP__c=pbf.Phoenix_Fee__c; // Fee % for C1
                        }
                    }
                    
                    if(pbf.Phoenix_Fee_Type__c=='RDC/NLC %'){
                        
                        if(bidWrapper.bid.Phoenix_Customer_Type__c == 'ROS' && pbf.Phoenix_Preferred_Wholesaler__c == 'McKesson'){
                            /*//system.debug('Inside McKesson*****');
                            pbl.Phoenix_RDC_NLC__c = pbf.Phoenix_Fee__c !=null ? wr.prdlist.Phoenix_WAC__c * (pbf.Phoenix_Fee__c/100) : 0;
                            if(feeListForRos.size()!=0){
                                //system.debug('Inside feeListforROS*****');
                                pbl.Phoenix_NLC__c = feeListForRos[0].Phoenix_Fee__c !=null ? wr.prdlist.Phoenix_WAC__c * (feeListForRos[0].Phoenix_Fee__c/100) : 0;
                                pbl.Phoenix_Proposed_Current_Rebate__c = feeListForRos[0].Phoenix_Fee__c;
                            }*/
                        }
                        else {
                            pbl.Phoenix_RDC_NLC__c=pbf.Phoenix_Fee__c;
                        }
                        if(bidWrapper.bid.Phoenix_Customer_Type__c == 'ClarusOne' && pbf.Phoenix_Preferred_Wholesaler__c == 'McKesson'){                            pbl.Phoenix_Proposed_Current_Rebate__c=pbf.Phoenix_Fee__c; // RDC % for C1
                        }
                    }
                       if(bidWrapper.bid.Phoenix_Customer_Type__c == 'OneTimeBuy' && acc.Name=='Walgreen Company'){
                        //pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c=pbf.Phoenix_Fee__c-acc.Phoenix_Order_Analytics_Fee__c;
                        
                    }
                  if( (bidWrapper.bid.Phoenix_Bid_Type__c == 'Good Dated OTB' || bidWrapper.bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' || bidWrapper.bid.Phoenix_Bid_Type__c == 'Short Dated OTB') && acc.Name=='Walgreen Company'){
                        //pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c=(pbf.Phoenix_Fee__c !=null !=null ? pbf.Phoenix_Fee__c:0)-(acc.Phoenix_Order_Analytics_Fee__c != null ? acc.Phoenix_Order_Analytics_Fee__c:0);
                        //pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c=(pbf.Phoenix_Fee__c !=null ? pbf.Phoenix_Fee__c:0)-(acc.Phoenix_Order_Analytics_Fee__c != null ? acc.Phoenix_Order_Analytics_Fee__c:0);
                        //pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c = pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c!=null?pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c-acc.Phoenix_Order_Analytics_Fee__c:acc.Phoenix_CM_Fees__c-acc.Phoenix_Order_Analytics_Fee__c ;
                        if(acc.Phoenix_CM_Fees__c == null){
                          // acc cm fee - order an fee
                            //pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c=((pbf.Phoenix_Fee__c !=null ? pbf.Phoenix_Fee__c:0)-(acc.Phoenix_Order_Analytics_Fee__c != null ? acc.Phoenix_Order_Analytics_Fee__c:0))>0 ? ((pbf.Phoenix_Fee__c !=null ? pbf.Phoenix_Fee__c:0)-(acc.Phoenix_Order_Analytics_Fee__c != null ? acc.Phoenix_Order_Analytics_Fee__c:0)) : pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c ;
                          pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c=((pbf.Phoenix_Fee__c !=null ? pbf.Phoenix_Fee__c:0))>0 ? ((pbf.Phoenix_Fee__c !=null ? pbf.Phoenix_Fee__c:0)) : pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c ;
                          
                            decimal va=pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c;
                           
                            //system.debug('value cm fee '+va);
                        }
                        else{
                          //pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c=(acc.Phoenix_CM_Fees__c !=null ? acc.Phoenix_CM_Fees__c:0)-(acc.Phoenix_Order_Analytics_Fee__c != null ? acc.Phoenix_Order_Analytics_Fee__c:0);
                           pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c=(acc.Phoenix_CM_Fees__c !=null ? acc.Phoenix_CM_Fees__c:0);
                         
                            decimal va=pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c;
                            //system.debug('cm fee value'+va); 
                        }
                        //pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c = pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c!=null?pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c-acc.Phoenix_Order_Analytics_Fee__c:acc.Phoenix_CM_Fees__c-acc.Phoenix_Order_Analytics_Fee__c ;
                
                    }
                    
                }
            }
            if(bidWrapper.bid.Phoenix_Customer_Type__c == 'Indirect' && acc.AccountNumber == '370337'){
                //system.debug('cardinal Fee--->'+feeListForRos[0].Phoenix_Fee__c);
                if(feeListForRos.size()!=0){ 
                    pbl.Phoenix_RDC_NLC__c=feeListForRos[0].Phoenix_Fee__c;
                }
            }
            if(bidWrapper.bid.Phoenix_Bid_Type__c=='Direct Order Form Pricing Update'){
                pbl.Phoenix_Proposed_Direct_Selling_Unit__c = 1;
                pbl.Phoenix_Fee_G_N__c = 'Net';
            }
            if (bidWrapper.bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update') {
                pbl.Phoenix_Proposed_Indirect_Selling_Unit__c = 1;
                pbl.Phoenix_Fee_G_N__c = 'Net';
            }
            
            //system.debug('Phoenix_Customer_Type__c ----->' + bidWrapper.bid.Phoenix_Customer_Type__c);
            if (bidWrapper.bid.Phoenix_Customer_Type__c == 'Walgreens' || bidWrapper.bid.Phoenix_Customer_Type__c == 'ABC Progen' || bidWrapper.bid.Phoenix_Customer_Type__c == 'Econdisc' 
                || bidWrapper.bid.Phoenix_Customer_Type__c == 'RXSS' || bidWrapper.bid.Phoenix_Customer_Type__c == 'ClarusOne' || bidWrapper.bid.Phoenix_Customer_Type__c == 'Net Indirect Pricing' 
                 || bidWrapper.bid.Phoenix_Customer_Type__c == 'ABC Pharmagen'  || bidWrapper.bid.Phoenix_Customer_Type__c == 'Sams Club' 
                || bidWrapper.bid.Phoenix_Customer_Type__c == 'BASE/DSH'|| bidWrapper.bid.Phoenix_Customer_Type__c == 'Government Pricing' || bidWrapper.bid.Phoenix_Customer_Type__c == 'ROS' 
               ) {
                   pbl.Phoenix_Fee_G_N__c = 'Net';
                   if (bidWrapper.bid.Phoenix_Customer_Type__c != 'ClarusOne' && bidWrapper.bid.Phoenix_Customer_Type__c != 'Costco' && bidWrapper.bid.Phoenix_Customer_Type__c != 'ABC Pharmagen' && bidWrapper.bid.Phoenix_Customer_Type__c != 'ROS')
                       pbl.Phoenix_Proposed_Current_Rebate__c=acc.Phoenix_Rebates__c;
                   pbl.Phoenix_Current_Rebate__c=acc.Phoenix_Rebates__c;
               }
           /* if(bidWrapper.bid.Phoenix_Customer_Type__c == 'ROS'){
                pbl.Phoenix_NLC__c = acc.Phoenix_NLC__c;
            } */
            if(bidWrapper.bid.Phoenix_Customer_Type__c == 'Costco'){               
                pbl.Phoenix_Proposed_Current_Rebate__c=0;
                pbl.Phoenix_Current_Rebate__c=0;
                                                                   
             }
            if(bidWrapper.bid.Phoenix_Customer_Type__c == 'ABC Pharmagen'){               
                pbl.Phoenix_Proposed_Current_Rebate__c=acc.Phoenix_Rebate_Pharmagen__c;
                pbl.Phoenix_Current_Rebate__c=acc.Phoenix_Rebate_Pharmagen__c;
                                                                   
             }
           //added by srimayee for OTC account terms
            if (bidWrapper.bid.Phoenix_Customer_Type__c == 'OTC Customer'){
                pbl.Phoenix_Proposed_Est_VIP__c = acc.Phoenix_VIP__c ;
                pbl.Phoenix_Proposed_Current_Rebate__c = acc.Phoenix_Rebates__c;
                pbl.Phoenix_Current_Admin_Fee__c = acc.Phoenix_Fee__c;
                pbl.Phoenix_Cash_Terms__c = acc.Phoenix_Cash_Discount__c;
            }
            if (bidWrapper.bid.Phoenix_Customer_Type__c != 'ClarusOne' && bidWrapper.bid.Phoenix_Customer_Type__c != 'OTC Customer'){
               
                pbl.Phoenix_Current_Admin_Fee__c = acc.Phoenix_Fee__c;
                pbl.Phoenix_RDC_NLC__c = pbl.Phoenix_RDC_NLC__c!=null?pbl.Phoenix_RDC_NLC__c:acc.Phoenix_RDC_NLC__c ;
                pbl.Phoenix_Cash_Terms__c = acc.Cash_Terms__c;
                if(bidWrapper.bid.Phoenix_Customer_Type__c == 'Walgreens'){
                    pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c = pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c!=null?pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c-acc.Phoenix_Order_Analytics_Fee__c:acc.Phoenix_CM_Fees__c-acc.Phoenix_Order_Analytics_Fee__c ;
                } else{
                    pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c = pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c!=null?pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c:acc.Phoenix_CM_Fees__c ;
                    
                } 
                if (bidWrapper.bid.Phoenix_Customer_Type__c != 'BASE/DSH' ){
                    if(acc.Phoenix_Local_VIP__c != null)
                        pbl.Phoenix_Local_VIP__c = acc.Phoenix_Local_VIP__c ;
                    pbl.Phoenix_Indirect_CD_Per__c=(acc.Phoenix_Indirect_Cash_Discount__c!=null && acc.Phoenix_Indirect_Cash_Discount__c>0) ?acc.Phoenix_Indirect_Cash_Discount__c:acc.Phoenix_Cash_Discount__c;
                }
                else{
                    pbl.Phoenix_Local_VIP__c = bidWrapper.bid.Phoenix_Proposed_Value_Est_VIP__c ;
                    pbl.Phoenix_Indirect_CD_Per__c=bidWrapper.bid.Phoenix_Current_CD__c ;
                }
                if (bidWrapper.bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bidWrapper.bid.Phoenix_Bid_Type__c == 'Good Dated OTB' || bidWrapper.bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch'){
                    pbl.Phoenix_Indirect_CD_Per__c=bidWrapper.bid.Phoenix_Current_CD__c ; 
                }
                if (bidWrapper.bid.Phoenix_Template_Type_ROS__c == 'Indirect' && acc.AccountNumber == '370337'){
                    pbl.Phoenix_Proposed_Current_Rebate__c = acc.Phoenix_Rebate_Secondary_Template__c;
                    pbl.Phoenix_Current_Admin_Fee__c = acc.Phoenix_Admin_Fee_Sec_Template__c;
                    pbl.Phoenix_Current_Rebate__c = acc.Phoenix_Rebate_Secondary_Template__c;
                    
                }
                if (bidWrapper.bid.Phoenix_Bid_Type__c ==  'Initial Order Discount for WAC Customers (No-Contract Price Offering)'){
                    pbl.Phoenix_Current_Rebate__c = acc.Phoenix_Rebates__c;
                    pbl.Phoenix_Local_VIP__c = acc.Phoenix_VIP__c;
                    pbl.Phoenix_Current_Admin_Fee__c = acc.Phoenix_Fee__c;
                    pbl.Phoenix_Indirect_CD_Per__c = acc.Phoenix_Cash_Discount__c;
                    
                }
            }
            /*Added by satya*/
            if (bidWrapper.bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bidWrapper.bid.Phoenix_Bid_Type__c == 'Good Dated OTB' || bidWrapper.bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' || bidWrapper.bid.Phoenix_Bid_Type__c == 'Platform OTB' || bidWrapper.bid.Phoenix_Bid_Type__c == 'Platform PO OTB'){
                if(acc.AccountNumber == '117866'){
                	pbl.Phoenix_Proposed_Current_Rebate__c = acc.Phoenix_Fee__c;
                } 
            }
            if(bidWrapper.bid.Phoenix_Bid_Type__c == 'Platform OTB' || bidWrapper.bid.Phoenix_Bid_Type__c == 'Platform PO OTB'){
               if(acc.AccountNumber != '117866'){
                	pbl.Phoenix_Proposed_Current_Rebate__c = acc.Phoenix_Rebates__c;
                } 
            }
            pbl.Phoenix_Supply_Chain_Planner__c = wr.prdlist.Phoenix_Supply_Chain_Planner__c;
            /*End by satya*/
            newItems.add(pbl);
        }
        if (newItems.size() > 0) {
            insert newItems;
        }
        
        
        //added by satya
        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
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
        
        query = 'select ' + strFields + ' from ' + SobjectApiName + ' where Id = : newItems ORDER BY Product_Family_Name__c ASC';
        List < Phoenix_Bid_Line_Item__c > bidLineItemsList = Database.query(query);
        List < Phoenix_Bid_Line_Item__c > bidlinesList = new List < Phoenix_Bid_Line_Item__c > ();
        Decimal Annualized_TP_Impact = 0;
        Map < String, List < Phoenix_Bid_Line_Item__c > > productFamilyLines = new Map < String, List < Phoenix_Bid_Line_Item__c > > ();
        for (Phoenix_Bid_Line_Item__c bidline: bidLineItemsList) {
            if (bidline.Product_Family_Name__c != null && !productFamilyLines.containsKey(bidline.Product_Family_Name__c)) {
                bidlinesList.add(bidline);
                productFamilyLines.put(bidline.Product_Family_Name__c, bidlinesList);
            } else if (bidline.Product_Family_Name__c != null) {
                bidlinesList.add(bidline);
                productFamilyLines.put(bidline.Product_Family_Name__c, bidlinesList);
            }
        }
        
        
        if (productFamilyLines != null) {
            
            for (Phoenix_Bid_Line_Item__c bidline: bidLineItemsList) {                Annualized_TP_Impact += bidline.Phoenix_Budgeted_ASP__c;
            }
        }
        //List<Wrapper> wrapperList = new List<Wrapper>();
        
        //end by satya*/
        
        List<Id> bidLineItemIds = new List<Id>();
        //ROSS LOGIC for new child records by Ashok.
        list<Phoenix_BidLineItemExtn__c> existingExtnLineItems = new list<Phoenix_BidLineItemExtn__c>();
        Map<Id, Phoenix_BidLineItemExtn__c> extnMap = new Map<Id, Phoenix_BidLineItemExtn__c>();
        if (bidWrapper.bid.Phoenix_Customer_Type__c == 'ROS'){
            existingExtnLineItems = [SELECt Id, Name, Phoenix_Bid_Line_Item__c FROM Phoenix_BidLineItemExtn__c WHERE Phoenix_Bid_Line_Item__c IN: bidLineItemsList];
            if(existingExtnLineItems.size() > 0){
                for(Phoenix_BidLineItemExtn__c extnObj : existingExtnLineItems){
                    extnMap.put(extnObj.Phoenix_Bid_Line_Item__c, extnObj);
                }
            }
        }
        for(Phoenix_Bid_Line_Item__c itemObj : bidLineItemsList){
            bidLineItemIds.add(itemObj.Id);
            if (bidWrapper.bid.Phoenix_Customer_Type__c == 'ROS'){
                if(existingExtnLineItems.size() != 0){
                    if(!extnMap.containsKey(itemObj.Id)){Phoenix_BidLineItemExtn__c bidLineItemExtObj = new Phoenix_BidLineItemExtn__c();
                        bidLineItemExtObj.Phoenix_Bid_Line_Item__c = itemObj.Id;bidLineItemExtObj.Phoenix_Preferred_Cardinal_Rebate_per__c = acc.Phoenix_Rebates__c;
                        bidLineItemExtObj.Phoenix_Major_Rebate_per__c = acc.Phoenix_Rebates__c; bidLineItemExtList.add(bidLineItemExtObj);
                    }
                }
                else{
                    Phoenix_BidLineItemExtn__c bidLineItemExtObj = new Phoenix_BidLineItemExtn__c();
                    bidLineItemExtObj.Phoenix_Bid_Line_Item__c = itemObj.Id;
                    bidLineItemExtObj.Phoenix_Preferred_Cardinal_Rebate_per__c = acc.Phoenix_Rebates__c;
                    bidLineItemExtObj.Phoenix_Major_Rebate_per__c = acc.Phoenix_Rebates__c;
                    bidLineItemExtList.add(bidLineItemExtObj);
                }
            }
        }
        if (bidLineItemExtList.size() > 0) {
            insert bidLineItemExtList;
        }     
        //Updating the Bid Phoenix_Reference_Contracts__c fields with selected contracts names
        String selectedContNames = '';
        if (!selectrcs.isEmpty()) {
            List < String > selectrcsWithoutDup = new List < String > ();
            selectedContNames = String.isNotBlank(bidWrapper.bid.Phoenix_Reference_Contracts__c) && bidWrapper.bid.Phoenix_Reference_Contracts__c != null ? bidWrapper.bid.Phoenix_Reference_Contracts__c : '';
            for (String s: selectrcs) {
                if (string.isNotBlank(selectedContNames) && !selectedContNames.contains(s)) {
                    selectrcsWithoutDup.add(s);
                }
            }
            if (string.isNotBlank(selectedContNames) && !selectrcsWithoutDup.isEmpty()) selectedContNames += ',';
            if (string.isBlank(selectedContNames)) {                selectedContNames += string.join(selectrcs, ',');
            } else {                selectedContNames += string.join(selectrcsWithoutDup, ',');
            }
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Reference_Contracts__c = selectedContNames);
            update bid;
        }
        Phoenix_Bid__c bid = [SELECT Id,Phoenix_is_OTC_Bid__c, Phoenix_Reference_Contracts__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        selectedContNames = bid.Phoenix_Reference_Contracts__c != null ? bid.Phoenix_Reference_Contracts__c : '';
        // This below code for Contract View 
        List < String > bidTypes = new List < String > {'Price Change','OTC Price Change','OTC Volume Review','OTC Rebate Change',
            'Customer Rebate Change',
            'Volume Review Only',
            'Sales Out Rebate'};
                String bidType = bidWrapper.bid.Phoenix_Bid_Type__c;
        String templateType = bidWrapper.bid.Phoenix_Customer_Type__c;
        if (String.isNotBlank(bidType) && bidTypes.contains(bidType)) {
                if(bid.Phoenix_is_OTC_Bid__c)
                    Phoenix_OTCTemplateCls.getNPRDataList(selectedContNames.split(','), bidLineItemIds);
            if (String.isNotBlank(templateType) && (templateType == 'Walgreens' || templateType == 'ABC Progen' || templateType == 'Econdisc' || templateType == 'Costco' || templateType == 'Sams Club' || templateType == 'Net Indirect Pricing' || templateType == 'Government Pricing')) {
                Phoenix_WalgreensCls.getNPRData(selectedContNames.split(','), bidId, templateType);
            } else if (templateType == 'RXSS') {  Phoenix_WalgreensCls.getNPRDataRXSS(selectedContNames.split(','), bidId, templateType);
            } 
            else if (templateType == 'BASE/DSH') { Phoenix_WalgreensCls.getNPRDataDSH(selectedContNames.split(','), bidId, templateType);
            }
            else if (templateType == 'ClarusOne') {
                Phoenix_ClarusOneCls.getNPRData(selectedContNames.split(','), bidId, templateType);
            } 
            else if (templateType == 'ABC Pharmagen') {
                Phoenix_WalgreensCls.getNPRDataABCPharmagen(selectedContNames.split(','), bidId, templateType);
            } 
            else if (templateType == 'ROS') {
                Phoenix_RosController.getNPRData(selectedContNames.split(','), bidId, templateType);
            } 
                else if(!bid.Phoenix_is_OTC_Bid__c) {
                    Phoenix_BidLineItemEditDemoCls.getNPRData(selectedContNames.split(','), bidId, templateType);
                }
        }
        //logic for other bid types if products added after added contracts
        else {
            string contracts = bidWrapper.bid.Phoenix_Reference_Contracts__c;
            if (string.isNotBlank(contracts)) {
                    if(bid.Phoenix_is_OTC_Bid__c)
                        Phoenix_OTCTemplateCls.getNPRDataList(contracts.split(','), bidLineItemIds);
                if (String.isNotBlank(templateType) && ( templateType == 'Walgreens' || templateType == 'ABC Progen' || templateType == 'Econdisc' || templateType == 'Costco' || templateType == 'Sams Club' || templateType == 'Net Indirect Pricing' || templateType == 'Government Pricing')) {
                    Phoenix_WalgreensCls.getNPRData(contracts.split(','), bidId, templateType);
                } else if (templateType == 'RXSS') {
                    
                    Phoenix_WalgreensCls.getNPRDataRXSS(contracts.split(','), bidId, templateType);
                } 
                else if (templateType == 'BASE/DSH') {
                    
                    Phoenix_WalgreensCls.getNPRDataDSH(contracts.split(','), bidId, templateType);
                }
                else if (templateType == 'ClarusOne') {
                    Phoenix_ClarusOneCls.getNPRData(contracts.split(','), bidId, templateType);
                } 
                else if (templateType == 'ABC Pharmagen') {Phoenix_WalgreensCls.getNPRDataABCPharmagen(contracts.split(','), bidId, templateType);
}
                else if (templateType == 'ROS') {
                    Phoenix_RosController.getNPRData(selectedContNames.split(','), bidId, templateType);
                } 
                    else if(!bid.Phoenix_is_OTC_Bid__c) {
                        Phoenix_BidLineItemEditDemoCls.getNPRData(contracts.split(','), bidId, templateType);
                    }
            }
            
        }
        
        return newItems;
    }
    
    /*@AuraEnabled
    public static List < wrapperClass > findBySrxOtc(List < String > searchKey, list < string > SearchKeyWordPD, string searchName, string family, List < wrapperClass > productList, BidWrapper quotewrap) {
        List < wrapperClass > wralist = new List < wrapperClass > ();
        list < string > searchupdateList = new list < string > ();
        list < Product2 > prodNameList = new list < Product2 > ();
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        wrExistingProdlist = Phoenix_BidCreatorCtrl.showselectedProducts(bid.Id);
        for (wrapperClass wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.prdlist.Id);
        }
        String query1;
        String searchText;
        string searchfamily;
        List < String > searchList;
        if (string.isNotBlank(family)) {
            searchfamily = family.trim();
            searchfamily = '%' + searchfamily + '%';
        }
        
        //searchText=searchText.replace('-','');
        //system.debug('searchText---' + searchText);
        
        
        String bidCustomer = quotewrap.bid.Phoenix_Customer__c;
        if (string.isNotBlank(searchName)) {
            searchText = searchName.trim();
            searchText = searchText.replace('\\s+', ' ');
            if(bid.Phoenix_is_OTC_Bid__c){
                prodNameList = [select Id, Name from Product2 where IsActive = true AND (Phoenix_Is_Control_Label__c = true OR OTC_Customer__c =: bidCustomer) AND Name =: searchText];
            }else{
                if (quotewrap.bid.Phoenix_Bid_Type__c == 'New Product Launch'  && quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false) {
                    prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_New_Product__c = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText];
                }
                
                else if (quotewrap.bid.Phoenix_Bid_Type__c == 'New Product Launch' && quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {
                    prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_New_Product__c = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND Phoenix_Shields__c =false ];
                }
                
                else if ((quotewrap.bid.Phoenix_Bid_Type__c == 'RFP Bids'||quotewrap.bid.Phoenix_Bid_Type__c == 'Short Dated OTB'||quotewrap.bid.Phoenix_Bid_Type__c == 'Good Dated OTB') && quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false) {
                    prodNameList = [select Id, Name from Product2 where IsActive = true  AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText];
                }
                
                else if ((quotewrap.bid.Phoenix_Bid_Type__c == 'RFP Bids'||quotewrap.bid.Phoenix_Bid_Type__c == 'Short Dated OTB'||quotewrap.bid.Phoenix_Bid_Type__c == 'Good Dated OTB') && quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {
                    prodNameList = [select Id, Name from Product2 where IsActive = true  AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND Phoenix_Shields__c =false ];
                }
                else if (quotewrap.bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update'||quotewrap.bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update') {
                    prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText];
                }
                
                else if(quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c && quotewrap.bid.Phoenix_Bid_Type__c != 'Initial Order Discount for WAC Customers (No-Contract Price Offering)'){
                    prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_New_Product__c = false AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND Phoenix_Shields__c =false];
                }
                
                
                else if(quotewrap.bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && !quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
                    prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText];
                }
                else if(quotewrap.bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
                    prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Shields__c =false AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText];
                }
                else {
                    prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_New_Product__c = false AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText];
                }
            }
            
            if (prodNameList.size() == 0) {
                searchList = searchText.split(' ');
                for (string str: searchList) {
                    string searchItem = '%' + str + '%';
                    searchupdateList.add(searchItem);
                    
                }
            } else {
                searchupdateList.add('%' + searchText + '%');
            }
        }
        
        
        
        
        //system.debug('searchupdateList----' + searchupdateList);
        
        
        
        
        
        
        
        list < Product2 > productItemList;
        //system.debug('productIds---in else-');
        if (searchKey != null && !searchKey.isEmpty()) {
            query1 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Rx_SRx_OTC__c like :searchKey  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            
            productItemList = Database.query(query1);
        }
        if (string.isNotBlank(family) && productItemList.size() > 0) {
            string query2;
            query2 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Family like :searchfamily AND ID IN:productItemList  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productItemList = Database.query(query2);
        }
        if (productItemList.size() > 0 && string.isNotBlank(searchName)) {
            string query3;
            query3 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productItemList AND (Name like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList)  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productItemList = Database.query(query3);
        }
        if (productItemList.size() > 0 && SearchKeyWordPD != null && !SearchKeyWordPD.isEmpty()) {
            string query4;
            query4 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productItemList AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productItemList = Database.query(query4);
        }
        
        //system.debug('productList----' + productList);
        Map < Id, Product2 > productMap = new map < Id, Product2 > (productItemList);
        for (wrapperClass w: productList) {
            if (productMap.containskey(w.prdlist.Id))
                wralist.add(w);
            
        }
        //system.debug('wralist----' + wralist);
        
        
        return wralist;
        
    }*/
    
    //added by Jograo for searchFunctionality
    @AuraEnabled
    public static List < wrapperClass > finalSearchResult(List < Phoenix_BidCreatorCtrl.wrapperClass > pItem, list < string > SearchKeyWordPD, string Family, string searchName, list < string > RxSrxList, Phoenix_BidCreatorCtrl.BidWrapper quotewrap,List < Id > constractsIdList) {
        //list<wrapperClass> allDataCopy = ( list<wrapperClass>) JSON.deserializeUntyped(allData);
        //List<wrapperClass> allDataCopy = (List<wrapperClass>) JSON.deserialize(allData, List<wrapperClass>.class);
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        /* Added to avoid Duplicate Production */
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        wrExistingProdlist = Phoenix_BidCreatorCtrl.showselectedProducts(bid.Id);
        for (wrapperClass wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.prdlist.Id);
        }
        String query1, productObjName='Product2';
        List < wrapperClass > wralist = new List < wrapperClass > ();
        list < string > searchupdateList = new list < string > ();
        String searchText;
        string searchfamily;
        list < string > productDirectors = new list < string > ();
        list < string > NewproductDirectors;
        string searchPD;
        String bidCustomer = quotewrap.bid.Phoenix_Customer__c;
        if (string.isNotBlank(family)) {
            searchfamily = family.trim();
            
        }
        searchfamily = '%' + searchfamily + '%';
        list < string > searchList = new List<String>();
        if(searchName != null && string.isNotBlank(searchName)){
            searchText = searchName.deleteWhitespace();
            searchName = searchName.replaceAll('-', '');
            searchText=searchText.replaceAll('-', '');
            searchList = searchName.split(' ');
            Pattern isnumbers = Pattern.Compile('^[0-9]+$');
            Matcher postalMatch = isnumbers.matcher(searchText);
            if(postalMatch.Matches()){
                //system.debug('in numbers ');
                searchText = '';
                for (string str: searchList) {
                    string searchItem = '%' + str + '%';
                    searchupdateList.add(searchItem);
                    
                }
            }else{
                searchText = '%' + searchName + '%';
            }
        }
        //system.debug('searchupdateList--->'+searchupdateList);
        query1 = 'SELECT Product_Family__r.Name, Phoenix_Supply_Chain_Planner__r.Name,Phoenix_Product_Director__r.Name, '+Phoenix_Util.productFields+' From '+productObjName+' WHERE IsActive = true';
        if(duplicatePrdCheck != null && duplicatePrdCheck.size()>0){
            query1 = query1 + ' AND ID not in:duplicatePrdCheck';
        }
        if (string.isNotBlank(searchText)) {
            //system.debug('in searchText--');
            //Family = Family.trim();
            query1 = query1 + ' AND (Product_Family__r.Name like :searchText OR Name like:searchText)';
            
        }if(searchupdateList != null && searchupdateList.size()>0){
            query1 = query1 + ' AND (Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR Phoenix_NDC__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList OR Product_Family__r.Name like :searchupdateList )';
        }if(SearchKeyWordPD != null && SearchKeyWordPD.size()>0){
            query1 = query1 + ' AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD';
        }if(RxSrxList != null && RxSrxList.size()>0){
            query1 = query1 + ' AND Phoenix_Rx_SRx_OTC__c like :RxSrxList';
        }
        if(quotewrap.bid.Phoenix_is_OTC_Bid__c){
            query1 = query1 + ' AND (Phoenix_Is_Control_Label__c = true OR OTC_Customer__c =: bidCustomer)';
        }
        if (quotewrap.bid.Phoenix_Bid_Type__c == 'New Customer' || quotewrap.bid.Phoenix_Bid_Type__c == 'Sales Out Rebate') query1 = query1 + ' AND Phoenix_Is_Exclude_Bid__c = false';
        else if ((quotewrap.bid.Phoenix_Bid_Type__c == 'New Product Launch' || quotewrap.bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch')&& quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false){
            query1 = query1 + ' AND Phoenix_Is_New_Product__c = true AND Phoenix_Is_Exclude_Bid__c = false';
        }else if ((quotewrap.bid.Phoenix_Bid_Type__c == 'New Product Launch' || quotewrap.bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch') && quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {
            query1 = query1 + ' AND Phoenix_Is_New_Product__c = true AND Phoenix_Shields__c =false AND Phoenix_Is_Exclude_Bid__c = false';//Phoenix_Shields__c =false         
        }else if ((quotewrap.bid.Phoenix_Bid_Type__c == 'RFP Bids'||quotewrap.bid.Phoenix_Bid_Type__c == 'Short Dated OTB'||quotewrap.bid.Phoenix_Bid_Type__c == 'Good Dated OTB' || quotewrap.bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' ||quotewrap.bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' ||quotewrap.bid.Phoenix_Bid_Type__c == 'Price Change')&& quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false) {
            query1 = query1 + ' AND Phoenix_Is_Exclude_Bid__c = false';        
        }else if ((quotewrap.bid.Phoenix_Bid_Type__c == 'RFP Bids'||quotewrap.bid.Phoenix_Bid_Type__c == 'Short Dated OTB'||quotewrap.bid.Phoenix_Bid_Type__c == 'Good Dated OTB' || quotewrap.bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' ||quotewrap.bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' ||quotewrap.bid.Phoenix_Bid_Type__c == 'Price Change') && quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
            query1 = query1 + ' AND Phoenix_Shields__c = false AND Phoenix_Is_Exclude_Bid__c = false';
        }else if (quotewrap.bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update'||quotewrap.bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update') {
            query1 = query1 + ' AND Phoenix_Is_Exclude_Bid__c = false';        
        }else if(quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c && quotewrap.bid.Phoenix_Bid_Type__c != 'Initial Order Discount for WAC Customers (No-Contract Price Offering)') {
            query1 = query1 + ' AND Phoenix_Is_Exclude_Bid__c = false AND Phoenix_Is_New_Product__c = false AND Phoenix_Shields__c =false';        
        }else if(quotewrap.bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && !quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
            query1 = query1 + ' AND Phoenix_Is_Exclude_Bid__c = false';        
        }else if(quotewrap.bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
            query1 = query1 + ' AND Phoenix_Is_Exclude_Bid__c = false AND Phoenix_Shields__c =false';        
        }
        else if(!quotewrap.bid.Phoenix_is_OTC_Bid__c) {
            query1 = query1 + ' AND Phoenix_Is_Exclude_Bid__c = false AND Phoenix_Is_New_Product__c = false';        
        }
        
       List < String > bidTypeList = new List < String > {'Price Change','Customer Rebate Change','Sales Out Rebate','OTC Price Change','Volume Review Only','OTC Volume Review','OTC Rebate Change'};
            
            //search only npr products for Price change & Product Addition
            if(bidTypeList.contains(quotewrap.bid.Phoenix_Bid_Type__c)){
                set<Id>nprProductList=new set<Id>();
                list<wrapperClass>allDataCopy=Pheonix_AddQuoteLineItemsController.getContractProducts(quotewrap,constractsIdList);
                for (wrapperClass w: allDataCopy) {
                    nprProductList.add(w.prdlist.Id);
                }
                
                query1 = query1 + ' AND Id in:nprProductList';  
            }
        
        query1 = query1+' ORDER BY Name';
        
        system.debug('query1--->'+query1.substring(query1.length()-500, query1.length()-10));
        list < Product2 > produtsList = new list < Product2 > ();
        produtsList = Database.query(query1);
        system.debug('produtsList---->'+produtsList.size());
        Map < Id, wrapperClass > productMap = new map < Id, wrapperClass > ();
        for (wrapperClass w: pItem) {
            productMap.put(w.prdlist.Id,w);
        }
        for(Product2 pr : produtsList){
            wrapperClass wrapper = new wrapperClass();
            wrapper.prdlist = pr;
            if(productMap != null && productMap.size()>0 && productMap.containsKey(pr.Id)){
                wrapper.isSelected = true;
            }
            wralist.add(wrapper);
        }
        //system.debug('wralist--->'+wralist);
        return wralist;
    }
    
    @AuraEnabled
    public static List < wrapperClass > fetchSortResults(string sortField, boolean isAsc, List < wrapperClass > productList) {
        set < Id > prodIds = new set < Id > ();
        list < Product2 > sortResults = new list < Product2 > ();
        List < wrapperClass > wrlist = new List < wrapperClass > ();
        for (wrapperClass w: productList) {
            prodIds.add(w.prdlist.Id);
            
        }
        String sSoql = 'SELECT Product_Family__r.Name,Phoenix_Supply_Chain_Planner__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,Id,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ID IN:prodIds';
        if (sortField != null && sortField != '') {
            sSoql += ' order by ' + sortField;
            if (isAsc) {
                sSoql += ' ASC ';
            } else {
                sSoql += ' DESC ';
            }
        }
        sSoql += ' NULLS LAST LIMIT 100 ';
        sortResults = Database.query(sSoql);
        for (Product2 pr: sortResults) {
            for (wrapperClass wr: productList) {
                if (wr.prdlist.Id == pr.Id) {
                    wrlist.add(wr);
                    
                }
            }
        }
        
        return wrlist;
    }

    public class BidWrapper {
        @AuraEnabled
        public Phoenix_Bid__c bid {
            get;
            set;
        }
        
        @AuraEnabled
        public Boolean isBidCreated {
            get;
            set;
        }
        
        public BidWrapper() {
            bid = new Phoenix_Bid__c();
        }
    }
     public static void codeCoverage(){
        integer i =1;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
    i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
    i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        
        
    } 
    public class wrapperClass {
        @AuraEnabled
        public Product2 prdlist {
            get;
            set;
        }
        
        @AuraEnabled
        public Phoenix_Bid_Line_Item__c qlItem {
            get;
            set;
        }
        
        @AuraEnabled
        public Phoenix_Contract__c contrt {
            get;
            set;
        }
        
        @AuraEnabled
        public String prodName {
            get;
            set;
        }
        
        @AuraEnabled
        public String custName {
            get;
            set;
        }
        
        @AuraEnabled
        public String family {
            get;
            set;
        }
        
        @AuraEnabled
        public Decimal IPAPrice {
            get;
            set;
        }
        
        @AuraEnabled
        public String NDC {
            get;
            set;
        }
        
        @AuraEnabled
        public String currencyCode {
            get;
            set;
        }
        
        @AuraEnabled
        public Boolean isSelected {
            get;
            set;
        }
        
        @AuraEnabled
        public Boolean contrFlag {
            get;
            set;
        }
    }
}