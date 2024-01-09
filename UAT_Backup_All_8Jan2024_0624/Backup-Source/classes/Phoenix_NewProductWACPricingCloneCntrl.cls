public class Phoenix_NewProductWACPricingCloneCntrl {
    @AuraEnabled
    public static List<Product2> getProducts(String productFamily) {
        List<Product2> products = new List<Product2>();
        try {
            products = [SELECT Id, Name, Phoenix_NDC_11__c, Phoenix_Pkg_Size__c, ProductCode FROM Product2 WHERE IsActive =: true AND Phoenix_Is_Exclude_Bid__c =: false AND Family=:productFamily AND Phoenix_Is_New_Product__c=:true ORDER BY Name ASC]; //Add AND Phoenix_Is_New_Product__c=:true
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Method_Name__c = 'calculateFinanceGrid', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        return products;
    }
    
    @AuraEnabled
    public static List<string> getActiveBidProductFamilies() {
        List <Product2> productFamilies = new List <Product2> ();
        productFamilies = [SELECT Family FROM Product2 WHERE IsActive =: true AND Phoenix_Is_Exclude_Bid__c =: false AND Family != null AND Phoenix_Is_New_Product__c=:true ORDER BY Family ASC];//Add AND Phoenix_Is_New_Product__c=:true
        List<string> listOfFamilies = new List<string>();
        Set<string> families = new Set<string>();
        for(Product2 item: productFamilies) {
            families.add(item.Family);
        }
        for(string item: families) {
            listOfFamilies.add(item);
        }
        return listOfFamilies;
    }
    @AuraEnabled
    public static List < String > processRebid(String bidId, List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > SelectedbidLIItem, string reBidName) {
        //String response = '';
        string isError = 'false';

        System.debug('=====SelectedbidLIItem======' + SelectedbidLIItem);
        List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > selectedrows = SelectedbidLIItem;

        System.debug('=====selected rows=======' + selectedrows.size());

        system.debug('>>>>>>>>>>>bidId>>>>>>>>>>' + bidId);
        system.debug('>>>>>>>>>>>reBidName>>>>>>>>>>' + reBidName);

        List < String > resResult = new List < String > ();

        try {
            system.debug('>>>bid Id>>' + bidId);
            New_Product_WAC_Pricing__c bid = Database.query('Select ' + Phoenix_Util.newProductWACPricingFields + ' From New_Product_WAC_Pricing__c Where Id=:bidId');
            system.debug('>>>bid Query>>' + bid);

            String NewBidId = '';
            List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > bidLineItemsList = Database.query('Select ' + Phoenix_Util.newProductWACPricingLinesFields + ' From Phoenix_NewProduct_WAC_Pricing_LineItems__c Where Phoenix_New_Product_WAC_Pricing__c=:bidId AND Phoenix_Final_Status__c=\'Approved\'');
            system.debug('>>>bidLineItemsList Query>>' + bidLineItemsList);

            New_Product_WAC_Pricing__c clonedBid = new New_Product_WAC_Pricing__c();
            //Add field assignments
            clonedBid.Phoenix_Is_Clone_New_Product_WAC_Pricing__c = true;
            clonedBid.Phoenix_Previous_New_Product_WAC_Pricing__c = bid.Id;
            clonedBid.Phoenix_Approval_Status__c = 'Draft';
            clonedBid.Phoenix_WAC_Price_for_New_Launch_Name__c = reBidName;
            clonedBid.Phoenix_GM__c = bid.Phoenix_GM__c;
            clonedBid.Phoenix_TPT__c = bid.Phoenix_TPT__c;
            clonedBid.Phoenix_Product_Family__c = bid.Phoenix_Product_Family__c;
            clonedBid.Phoenix_Product_Type__c = bid.Phoenix_Product_Type__c;
            clonedBid.Phoenix_Marketing_Head__c = bid.Phoenix_Marketing_Head__c;
            clonedBid.Phoenix_Marketing_Lead__c = bid.Phoenix_Marketing_Lead__c;
            clonedBid.Phoenix_Product_Director__c = bid.Phoenix_Product_Director__c;
            clonedBid.Phoenix_Net_sales_annualized__c = bid.Phoenix_Net_sales_annualized__c;
            insert clonedBid;

            NewBidId = clonedBid.Id;
            List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > clonedBidLineItemsList = new List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > ();
            List<string> lineItemIds = new List<String>();
            for (Phoenix_NewProduct_WAC_Pricing_LineItems__c item: selectedrows) {
                lineItemIds.add(item.Id);
                system.debug('Product: '+item);
                Phoenix_NewProduct_WAC_Pricing_LineItems__c newItem = new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
                
                newItem.Phoenix_New_Product_WAC_Pricing__c = NewBidId;
                newItem.Phoenix_Product__c = item.Phoenix_Product__c;
                newItem.Phoenix_NDC_11__c = item.Phoenix_NDC_11__c;
                newItem.Phoenix_Material_Number__c = item.Phoenix_Material_Number__c;
                newItem.Phoenix_Pkg_Size__c = item.Phoenix_Pkg_Size__c;
                newItem.Phoenix_WAC__c = item.Phoenix_WAC__c;
                newItem.Phoenix_Brand_WAC__c = item.Phoenix_Brand_WAC__c;
                newItem.Phoenix_Lowest_Price__c = item.Phoenix_Lowest_Price__c;
				newItem.Phoenix_TPT_GM__c = item.Phoenix_TPT_GM__c;
                clonedBidLineItemsList.add(newItem);
                
            }
            insert clonedBidLineItemsList;
            resResult.add(isError);
            resResult.add(NewBidId);
            //return resResult;

        }
        Catch(Exception e) {
            isError = 'true';
            resResult.add(isError);
            resResult.add('' + e.getMessage()+ ' '+e.getLineNumber());
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'BidCloneExt', Phoenix_Method_Name__c = 'processRebid', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }

        return resResult;

    }
    
    
    @AuraEnabled
    public static List < wrapperClass > getProducts1(String productFamily) {
        List < wrapperClass > wrlist = new List < wrapperClass > ();
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
        Boolean isNew = true;
        query = 'SELECT Name, ProductCode, Phoenix_NDC_11__c, Family, Phoenix_Pkg_Size__c, Phoenix_WAC__c, Phoenix_Product_Director__c, Phoenix_Product_Director__r.Name FROM Product2 WHERE Family =: productFamily AND Phoenix_Is_New_Product__c =: isNew';
        
        
        List < Product2 > prlist = Database.query(query);
        
        
        
        
        if (prlist.size() > 0) {
            for (Product2 pr: prlist) {
                wrapperClass wr = new wrapperClass();
                wr.prdlist = pr;
                wr.isSelected = false;
                wrlist.add(wr);
            }
        }
        return wrlist;
    }
    
    
    public class wrapperClass {
        @AuraEnabled
        public Product2 prdlist {
            get;
            set;
        }

        @AuraEnabled
        public Boolean isSelected {
            get;
            set;
        }

    }
}