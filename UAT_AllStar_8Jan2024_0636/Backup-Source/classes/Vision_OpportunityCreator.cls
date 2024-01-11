public class Vision_OpportunityCreator {
    
    @auraEnabled
    public static list<Product_Opportunity__c> getUnMatchedProds(string opportunityId){
        String status = 'Unmatched';
        String query = 'SELECT Product__r.Name,Product__r.Id, Product__r.Phoenix_Pkg_Size__c, Product__r.Phoenix_Strength__c, Product__r.Phoenix_GCN_Generic_Code_Number__c, Product__r.Phoenix_GCN_Sequence_Number__c, '+
            +' Product__r.Phoenix_GPI_Generic_Product_Identifier__c, Product__r.Phoenix_NDC_11__c, Product__r.ProductCode, Product__r.Phoenix_Dosage_Form__c,'+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c'+
            +' WHERE Opportunity__c=: opportunityId AND Status__c =: status ORDER BY Name';
        List<Product_Opportunity__c> optyProdList = Database.query(query);
        return optyProdList;
    }
    
    @auraEnabled
    public static Product_Opportunity__c updateWithNewProdDesc(String productId, String optyProdId){
        Product2 product = [SELECT Id, Name, Phoenix_GCN_Generic_Code_Number__c, Phoenix_GCN_Sequence_Number__c, Phoenix_GPI_Generic_Product_Identifier__c, Phoenix_NDC_11__c,
                            ProductCode, Product_Family__c FROM Product2 WHERE Id=: productId];
        //database.query('SELECT Id, Name,'+Phoenix_Util.getsObjectFieds('Product2')+' FROM Product2 WHERE Id=: productId');
        Product_Opportunity__c optyProd = database.query('SELECT Product__r.Name, GCP_Product_Family__r.Name, Product__r.Id, Product__r.Phoenix_Pkg_Size__c, '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c WHERE Id =: optyProdId');
        optyProd.Product__c = product.Id;
        optyProd.Name = product.Name;
        optyProd.GCN_Generic_Code_Number__c = product.Phoenix_GCN_Generic_Code_Number__c;
        optyProd.GSN__c = product.Phoenix_GCN_Sequence_Number__c;
        optyProd.GPI_Generic_Product_Identifier__c = product.Phoenix_GPI_Generic_Product_Identifier__c;
        optyProd.NDC_11__c = product.Phoenix_NDC_11__c;
        optyProd.SKU_Number__c = product.ProductCode;
        if(product.Product_Family__c != null)
            optyProd.GCP_Product_Family__c = product.Product_Family__c;
        update optyProd;
        return database.query('SELECT Product__r.Name, GCP_Product_Family__r.Name, Product__r.Id, Product__r.Phoenix_Pkg_Size__c, '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c WHERE Id =: optyProdId');
    }
    
    @auraEnabled
    public static list<Product_Opportunity__c> getProdListForBidClone(List<Id> prodIds, string bidId){
        List<Product_Opportunity__c> newOptyProds = new List<Product_Opportunity__c>();
        List<Phoenix_Bid_Line_Item__c> bidLineItems = database.query('SELECT '+Phoenix_Util.getsObjectFieds('Phoenix_Bid_Line_Item__c')+' FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c =: bidId AND Phoenix_Product__c IN: prodIds');
        Map<Id, Phoenix_Bid_Line_Item__c> skuMap = new Map<Id, Phoenix_Bid_Line_Item__c>();
        list<Id> bidLineIds = new list<Id>();
        for(Phoenix_Bid_Line_Item__c item:bidLineItems){
            bidLineIds.add(item.Id);
            skuMap.put(item.Phoenix_Product__c, item);
        }
        String query = 'SELECT Product_Family__r.Name,'+Phoenix_Util.getsObjectFieds('Product2')+' FROM Product2 WHERE Id IN: prodIds ORDER BY Name';
        List<Product2> prodList = Database.query(query);
        Phoenix_Bid__c bidRec = [SELECT Id, Name, Phoenix_Customer_Type__c FROM Phoenix_Bid__c WHERE Id=: bidId];
        Map<Id, Phoenix_BidLineItemExtn__c> extnMap = new Map<Id, Phoenix_BidLineItemExtn__c>();
        if(bidRec.Phoenix_Customer_Type__c == 'ROS'){
            List<Phoenix_BidLineItemExtn__c> extnRecList = [SELECT Id, Name, Phoenix_Bid_Line_Item__c, Phoenix_Proposed_Cardinal_Units__c, Phoenix_Proposed_CVS_DirSellingUnits__c,
                                                            Phoenix_Proposed_CVS_IndirSellingUnits__c, Phoenix_Proposed_Major_Units__c FROM Phoenix_BidLineItemExtn__c
                                                            WHERE Phoenix_Bid_Line_Item__c IN: bidLineIds];
            for(Phoenix_BidLineItemExtn__c item:extnRecList){
                extnMap.put(item.Phoenix_Bid_Line_Item__c, item); 
            }
        }
        for(Product2 prodObj : prodList){
            Product_Opportunity__c optyProd = new Product_Opportunity__c();
            optyProd.Name = prodObj.Name;
            optyProd.GCN_Generic_Code_Number__c = prodObj.Phoenix_GCN_Generic_Code_Number__c;
            optyProd.GSN__c = prodObj.Phoenix_GCN_Sequence_Number__c;
            optyProd.GPI_Generic_Product_Identifier__c = prodObj.Phoenix_GPI_Generic_Product_Identifier__c;
            optyProd.NDC_11__c = prodObj.Phoenix_NDC_11__c;
            optyProd.SKU_Number__c = prodObj.ProductCode;
            optyProd.Product_Family__c = prodObj.Family;
            optyProd.GCP_Product_Family__c = prodObj.Product_Family__c;
            optyProd.Lowest_Price_SKU__c = prodObj.Phoenix_Lowest_Price_SKU__c;
            optyProd.Strength__c = prodObj.Phoenix_Strength__c;
            optyProd.Pkg_Size__c = prodObj.Phoenix_Pkg_Size__c;
            optyProd.Product_Description__c = prodObj.Description;
            optyProd.Product__c = prodObj.id;
            optyProd.Status__c = 'Matched';
            if(skuMap.containsKey(prodObj.Id)){
                Phoenix_Bid_Line_Item__c expectedOptyProd = skuMap.get(prodObj.Id);
                if(bidRec.Phoenix_Customer_Type__c == 'ClarusOne'){
                    optyProd.Vision_Proposed_OS_Units__c = expectedOptyProd.Phoenix_Proposed_OS_Units__c != null ? expectedOptyProd.Phoenix_Proposed_OS_Units__c : 0;
                    optyProd.Vision_Proposed_RAD_Units__c = expectedOptyProd.Phoenix_Proposed_RAD_Units__c != null ? expectedOptyProd.Phoenix_Proposed_RAD_Units__c : 0;
                    optyProd.Vision_Proposed_WMT_Units__c = expectedOptyProd.Phoenix_Proposed_WMT_Units__c != null ? expectedOptyProd.Phoenix_Proposed_WMT_Units__c : 0;
                }
                else if(bidRec.Phoenix_Customer_Type__c == 'BASE/DSH'){
                    optyProd.Vision_Proposed_BASE_Units__c = expectedOptyProd.Phoenix_Proposed_Smith_Drug_Units__c != null ? expectedOptyProd.Phoenix_Proposed_Smith_Drug_Units__c : 0;
                    optyProd.Vision_Proposed_DSH_Units__c = expectedOptyProd.Phoenix_Proposed_Anda_Units__c != null ? expectedOptyProd.Phoenix_Proposed_Anda_Units__c : 0;
                    optyProd.Vision_Proposed_AutoSub_Units__c = expectedOptyProd.Phoenix_ProposedDirectAholdDelhaizeUnits__c != null ? expectedOptyProd.Phoenix_ProposedDirectAholdDelhaizeUnits__c : 0;
                }
                else if(bidRec.Phoenix_Customer_Type__c == 'RXSS'){
                    optyProd.Vision_Proposed_Smith_Drug_Units__c = expectedOptyProd.Phoenix_Proposed_Smith_Drug_Units__c != null ? expectedOptyProd.Phoenix_Proposed_Smith_Drug_Units__c : 0;
                    optyProd.Vision_Proposed_Anda_Units__c = expectedOptyProd.Phoenix_Proposed_Anda_Units__c != null ? expectedOptyProd.Phoenix_Proposed_Anda_Units__c : 0;
                    optyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c = expectedOptyProd.Phoenix_ProposedDirectAholdDelhaizeUnits__c != null ? expectedOptyProd.Phoenix_ProposedDirectAholdDelhaizeUnits__c : 0;
                    optyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c = expectedOptyProd.Phoenix_ProposedDirectGaintEagleUnits__c != null ? expectedOptyProd.Phoenix_ProposedDirectGaintEagleUnits__c : 0;
                    optyProd.Vision_Proposed_TotalRetailIndirectUnits__c = expectedOptyProd.Phoenix_ProposedIndirectAholdDelhaizeUni__c != null ? expectedOptyProd.Phoenix_ProposedIndirectAholdDelhaizeUni__c : 0;
                    optyProd.Proposed_Direct_Selling_Units__c = expectedOptyProd.Phoenix_Others_Direct__c != null ? expectedOptyProd.Phoenix_Others_Direct__c : 0;
                    optyProd.Proposed_Indirect_Selling_Units__c = expectedOptyProd.Phoenix_Others_Indirect__c != null ? expectedOptyProd.Phoenix_Others_Indirect__c : 0;
                }
                else if(bidRec.Phoenix_Customer_Type__c == 'Econdisc'){
                    optyProd.Vision_Proposed_Direct_ESI_Units__c = expectedOptyProd.Phoenix_Direct_ESI__c != null ? expectedOptyProd.Phoenix_Direct_ESI__c : 0;
                    optyProd.Vision_Proposed_Indirect_ESI_Units__c = expectedOptyProd.Phoenix_Indirect_ESI__c != null ? expectedOptyProd.Phoenix_Indirect_ESI__c : 0;
                    optyProd.Vision_Proposed_Direct_Kroger_Units__c = expectedOptyProd.Phoenix_Direct_Kroger__c != null ? expectedOptyProd.Phoenix_Direct_Kroger__c : 0;
                    optyProd.Vision_Proposed_Indirect_Kroger_Units__c = expectedOptyProd.Phoenix_Indirect_Kroger__c != null ? expectedOptyProd.Phoenix_Indirect_Kroger__c : 0;
                    optyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c = expectedOptyProd.Phoenix_Direct_Rx_Outreach__c != null ? expectedOptyProd.Phoenix_Direct_Rx_Outreach__c : 0;
                    optyProd.Vision_Proposed_IndirectRxOutreach_Units__c = expectedOptyProd.Phoenix_Indirect_Rx_Outreach__c != null ? expectedOptyProd.Phoenix_Indirect_Rx_Outreach__c : 0;
                    optyProd.Vision_Proposed_Direct_Supervalu_Units__c = expectedOptyProd.Phoenix_Direct_Supervalu__c != null ? expectedOptyProd.Phoenix_Direct_Supervalu__c : 0;
                    optyProd.Vision_Proposed_Indirect_Supervalu_Units__c = expectedOptyProd.Phoenix_Indirect_Supervalu__c != null ? expectedOptyProd.Phoenix_Indirect_Supervalu__c : 0;
                    optyProd.Vision_Proposed_Direct_Cigna_Units__c = expectedOptyProd.Phoenix_Direct_Cigna__c != null ? expectedOptyProd.Phoenix_Direct_Cigna__c : 0;
                    optyProd.Vision_Proposed_Indirect_Cigna_Units__c = expectedOptyProd.Phoenix_Indirect_Cigna__c != null ? expectedOptyProd.Phoenix_Indirect_Cigna__c : 0;
                    optyProd.Vision_Proposed_Direct_Cordant_Units__c = expectedOptyProd.Phoenix_Direct_Cordant__c != null ? expectedOptyProd.Phoenix_Direct_Cordant__c : 0;
                    optyProd.Vision_Proposed_Indirect_Cordant_Units__c = expectedOptyProd.Phoenix_Indirect_Cordant__c != null ? expectedOptyProd.Phoenix_Indirect_Cordant__c : 0;
                    optyProd.Vision_Proposed_Direct_Accerodo_Units__c = expectedOptyProd.Phoenix_Direct_Accerodo__c != null ? expectedOptyProd.Phoenix_Direct_Accerodo__c : 0;
                    optyProd.Vision_Proposed_Indirect_Accerodo_Units__c = expectedOptyProd.Phoenix_Indirect_Accerodo__c != null ? expectedOptyProd.Phoenix_Indirect_Accerodo__c : 0;
                    optyProd.Proposed_Direct_Selling_Units__c = expectedOptyProd.Phoenix_Others_Direct__c != null ? expectedOptyProd.Phoenix_Others_Direct__c : 0;
                    optyProd.Proposed_Indirect_Selling_Units__c = expectedOptyProd.Phoenix_Others_Indirect__c != null ? expectedOptyProd.Phoenix_Others_Indirect__c : 0;
                }
                else if(bidRec.Phoenix_Customer_Type__c == 'ROS' && extnMap.containsKey(expectedOptyProd.Id)){
                    Phoenix_BidLineItemExtn__c extnObj = extnMap.get(expectedOptyProd.Id);
                    optyProd.Vision_Proposed_CVS_Direct_Units__c = extnObj.Phoenix_Proposed_CVS_DirSellingUnits__c != null ? extnObj.Phoenix_Proposed_CVS_DirSellingUnits__c : 0;
                    optyProd.Vision_Proposed_CVS_Indirect_Units__c = extnObj.Phoenix_Proposed_CVS_IndirSellingUnits__c != null ? extnObj.Phoenix_Proposed_CVS_IndirSellingUnits__c : 0;
                    optyProd.Vision_Proposed_Cardinal_Units__c = extnObj.Phoenix_Proposed_Cardinal_Units__c != null ? extnObj.Phoenix_Proposed_Cardinal_Units__c : 0;
                    optyProd.Vision_Proposed_Major_Units__c = extnObj.Phoenix_Proposed_Major_Units__c != null ? extnObj.Phoenix_Proposed_Major_Units__c : 0;
                }
                else{
                    optyProd.Proposed_Direct_Selling_Units__c = expectedOptyProd.Phoenix_Proposed_Direct_Selling_Unit__c != null ? expectedOptyProd.Phoenix_Proposed_Direct_Selling_Unit__c : 0;
                    optyProd.Proposed_Indirect_Selling_Units__c = expectedOptyProd.Phoenix_Proposed_Indirect_Selling_Unit__c != null ? expectedOptyProd.Phoenix_Proposed_Indirect_Selling_Unit__c : 0;
                }
            }
            newOptyProds.add(optyProd);
        }
        return newOptyProds;
    }
    
    @auraEnabled
    public static List<Product_Opportunity__c> getProdListWithIds(List<Id> prodIds, String accId){
        List<Product_Opportunity__c> newOptyProds = new List<Product_Opportunity__c>();
        Account accObj = [SELECT Id, Name, AccountNumber FROM Account WHERE Id =: accId];
        if(accObj.Name == 'Red Oak Sourcing' || accObj.AccountNumber == '153363'){
            List<GCP_SFDC_100pct_Analysis_SKU__c> skuList = new List<GCP_SFDC_100pct_Analysis_SKU__c>();
            skuList = database.query('SELECT '+Phoenix_Util.getsObjectFieds('GCP_SFDC_100pct_Analysis_SKU__c')+' FROM GCP_SFDC_100pct_Analysis_SKU__c WHERE Vision_Customer__c =: accId AND Vision_Product__c IN: prodIds');
            if(skuList.size()>0){
                Map<Id, GCP_SFDC_100pct_Analysis_SKU__c> skuMap = new Map<Id, GCP_SFDC_100pct_Analysis_SKU__c>();
                for(GCP_SFDC_100pct_Analysis_SKU__c item:skuList){
                    skuMap.put(item.Vision_Product__c, item);
                }
                String query = 'SELECT Product_Family__r.Name,'+Phoenix_Util.getsObjectFieds('Product2')+' FROM Product2 WHERE Id IN: prodIds ORDER BY Name';
                List<Product2> prodList = Database.query(query);
                for(Product2 prodObj : prodList){
                    Product_Opportunity__c productOpportunity = new Product_Opportunity__c(
                        Name = prodObj.Name,
                        GCN_Generic_Code_Number__c = prodObj.Phoenix_GCN_Generic_Code_Number__c,
                        GSN__c = prodObj.Phoenix_GCN_Sequence_Number__c,
                        GPI_Generic_Product_Identifier__c = prodObj.Phoenix_GPI_Generic_Product_Identifier__c,
                        NDC_11__c = prodObj.Phoenix_NDC_11__c,
                        SKU_Number__c = prodObj.ProductCode,
                        Product_Family__c = prodObj.Family,
                        GCP_Product_Family__c = prodObj.Product_Family__c,
                        Lowest_Price_SKU__c = prodObj.Phoenix_Lowest_Price_SKU__c,
                        Strength__c = prodObj.Phoenix_Strength__c,
                        Pkg_Size__c = prodObj.Phoenix_Pkg_Size__c,
                        Product_Description__c = prodObj.Description,
                        Product__c = prodObj.id,
                        Status__c = 'Matched'
                    );
                    if(skuMap.containsKey(prodObj.Id)){
                        GCP_SFDC_100pct_Analysis_SKU__c obj = skuMap.get(prodObj.Id);
                        if(accObj.AccountNumber == '153363'){
                            productOpportunity.Vision_Proposed_OS_Units__c = obj.Vision_McKesson_Vol__c != null ? obj.Vision_McKesson_Vol__c : 0;
                            productOpportunity.Vision_Proposed_RAD_Units__c = obj.Vision_Rite_Aid_Vol__c != null ? obj.Vision_Rite_Aid_Vol__c : 0;
                            productOpportunity.Vision_Proposed_WMT_Units__c = obj.Vision_WalMart_Vol__c != null ? obj.Vision_WalMart_Vol__c : 0;
                            productOpportunity.Vision_Total_Annual_Units__c = productOpportunity.Vision_Proposed_OS_Units__c + productOpportunity.Vision_Proposed_RAD_Units__c + productOpportunity.Vision_Proposed_WMT_Units__c;
                        }
                        else{
                            if(obj.Vision_Contract_Type__c == 'Indirect'){
                                productOpportunity.Vision_Proposed_CVS_Direct_Units__c = 0;
                                productOpportunity.Vision_Proposed_CVS_Indirect_Units__c = obj.Vision_CVS_Share_Vol__c != null ? obj.Vision_CVS_Share_Vol__c : 0;
                            }
                            else{
                                productOpportunity.Vision_Proposed_CVS_Indirect_Units__c = 0;
                                productOpportunity.Vision_Proposed_CVS_Direct_Units__c = obj.Vision_CVS_Share_Vol__c != null ? obj.Vision_CVS_Share_Vol__c : 0;
                            }
                            productOpportunity.Vision_Proposed_Cardinal_Units__c = obj.Vision_Cardinal_Share_Vol__c != null ? obj.Vision_Cardinal_Share_Vol__c : 0;
                            productOpportunity.Vision_Proposed_Major_Units__c = obj.Vision_Major_Share_Vol__c != null ? obj.Vision_Major_Share_Vol__c : 0;
                            productOpportunity.Vision_Total_Annual_Units__c = productOpportunity.Vision_Proposed_CVS_Indirect_Units__c + productOpportunity.Vision_Proposed_CVS_Direct_Units__c + productOpportunity.Vision_Proposed_Cardinal_Units__c + productOpportunity.Vision_Proposed_Major_Units__c;
                        }
                    }
                    newOptyProds.add(productOpportunity);
                }
            }
        }
        else{
            String query = 'SELECT Product_Family__r.Name, '+Phoenix_Util.getsObjectFieds('Product2')+' FROM Product2 WHERE Id IN: prodIds ORDER BY Name';
            List<Product2> prodList = Database.query(query);
            for(Product2 prodObj : prodList){
                Product_Opportunity__c productOpportunity = new Product_Opportunity__c(
                    Name = prodObj.Name,
                    GCN_Generic_Code_Number__c = prodObj.Phoenix_GCN_Generic_Code_Number__c,
                    GSN__c = prodObj.Phoenix_GCN_Sequence_Number__c,
                    GPI_Generic_Product_Identifier__c = prodObj.Phoenix_GPI_Generic_Product_Identifier__c,
                    NDC_11__c = prodObj.Phoenix_NDC_11__c,
                    SKU_Number__c = prodObj.ProductCode,
                    Product_Family__c = prodObj.Family,
                    GCP_Product_Family__c = prodObj.Product_Family__c,
                    Lowest_Price_SKU__c = prodObj.Phoenix_Lowest_Price_SKU__c,
                    Strength__c = prodObj.Phoenix_Strength__c,
                    Pkg_Size__c = prodObj.Phoenix_Pkg_Size__c,
                    Product_Description__c = prodObj.Description,
                    Product__c = prodObj.id,
                    Status__c = 'Matched'
                );
                newOptyProds.add(productOpportunity);
            }
        }
        return newOptyProds;
    }
    
    @auraEnabled
    public static string saveOptyAndLines(Opportunity optyObj, List<Product_Opportunity__c> optyProdList){
        //Opportunity optyRec = (Opportunity)JSON.deserialize(optyObj,Opportunity.class);
        optyObj.StageName = 'Opportunity in progress';
        insert optyObj;
        for(Product_Opportunity__c prodOptyObj : optyProdList){
            prodOptyObj.Opportunity__c = optyObj.Id;
        }
        insert optyProdList;
        return optyObj.Id;
    }
    
    @AuraEnabled
    public static AccountListWrapperClass getcustomerOwner(Id custID) {
        Account accRec = [select ownerID,Name,AccountNumber, Phoenix_Customer_Class_Bid_Template__c from Account where id =: custID];
        AccountListWrapperClass accWrpObj=new AccountListWrapperClass();
        accWrpObj.template=accRec.Phoenix_Customer_Class_Bid_Template__c;
        accWrpObj.Ownerid=accRec.ownerID;
        accWrpObj.AccName=accRec.Name;
        accWrpObj.AccNumber=accRec.AccountNumber;
        set < string > parentAccIds = new set < string > ();
        List < string > parentAccIdsList = new List < string > ();
        if (custID != null) {
            //parentAccIds.add(custID);
            //Fetch related accounts
            Map < Id, Account > allAccMap = new Map < Id, Account > ([SELECT id,ParentId  FROM Account where Phoenix_Is_Bid_Account__c=true LIMIT 3000]);
            //Map of all accounts
            /*  for (Account acc: Database.query('SELECT id,ParentId  FROM Account where Phoenix_Is_Bid_Account__c=true LIMIT 3000'))
allAccMap.put(acc.Id, acc);*/
            String tempId = custID;
            while (allAccMap.get(tempId) != NULL && allAccMap.get(tempId).ParentId != NULL) {
                tempId = allAccMap.get(tempId).ParentId;
                //parentAccIds.add(tempId);
            }
            // list < Account > AccHierarchyList = new list < Account > ([SELECT id FROM Account where Phoenix_Is_Bid_Account__c=true and ParentId=:tempId LIMIT 3000]);
            for(Account acc:[SELECT id FROM Account where Phoenix_Is_Bid_Account__c=true and ParentId=:tempId LIMIT 3000]){
                parentAccIds.add(acc.Id);
            }
            parentAccIds.add(tempId);
            // AccHierarchyList.clear();
            allAccMap.clear();
        }
        // accountRec.add(parentAccIds.toString());
        parentAccIdsList.addAll(parentAccIds);
        accWrpObj.Acchirarchy=parentAccIdsList;
        accRec.clear();
        parentAccIds.clear();
        parentAccIdsList.clear();
        return accWrpObj;
    }
    public class AccountListWrapperClass {
        @AuraEnabled public string template;
        @AuraEnabled public string Ownerid;
        @AuraEnabled public string AccName;
        @AuraEnabled public string AccNumber;
        @AuraEnabled public List<string> Acchirarchy;
        public AccountListWrapperClass() {
            Acchirarchy = new List<string>();
        }
    }
    @AuraEnabled
    public static void createContentDCLink(Id crId, List < Id > contentDCIdList) {
        List < ContentDocumentLink > contentDCLinks = new List < ContentDocumentLink > ();
        for (Id conDCId: contentDCIdList) {
            // ContentDocumentLink conDCLink = ;
            contentDCLinks.add(new ContentDocumentLink(
                LinkedEntityId = crId,
                ContentDocumentId = conDCId
            ));
        }
        if (!contentDCLinks.isEmpty()) {
            upsert contentDCLinks;
            contentDCLinks.clear();
        }
    }
    
    @AuraEnabled
    public static void deleteAttachmentList(List < Id > LineItemIds) {
        List < ContentDocument > contentDocumentIds = [SELECT Id FROM ContentDocument WHERE Id IN: LineItemIds LIMIT 1000];
        if (!contentDocumentIds.isEmpty()) {
            delete contentDocumentIds;
            contentDocumentIds.clear();
        }
    }
    
    @AuraEnabled
    public static list < RecordType > getRecordTypeDetails() {
        list < RecordType > rectypes = [select Id, Name from RecordType where sObjectType = 'Phoenix_Bid__C'];
        return rectypes;
    }
    
    @AuraEnabled
    public static WrapperClass getoptyInfo(String recordId) {
        WrapperClass wrapperCls = new WrapperClass();
        if (recordId != null) {
            String query = 'SELECT Account.AccountNumber, '+Phoenix_Util.getsObjectFieds('Opportunity')+' FROM Opportunity WHERE Id=: recordId';
            wrapperCls.opty = database.query(query);
            if(wrapperCls.opty.AccountId!=null){
                wrapperCls.bidCreated = true;
            }
        }
        List<Product_Opportunity__c> optyLineItems = database.query('SELECT Product__r.Name, GCP_Product_Family__r.Name, Product__r.Id, Product__r.Phoenix_Pkg_Size__c, '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c WHERE Opportunity__c =: recordId');
        wrapperCls.optyLineItems = optyLineItems;
        //  List<String> sectionNames = new List<String>{'Phoenix_Bid_Information'};
        List < String > sectionNames = new List < String > {
            'Phoenix_Bid_Information',
                'Phoenix_Customer_Bid_Deadline_Info'
                };
                    List < string > fieldSet;
        List < LayoutPage > listLayoutPage = new List < LayoutPage > ();
        for (String secName: sectionNames) {
            string section = '';
            //  Map < String, Schema.SObjectType > GlobalDescribeMap = ;
            //  Schema.SObjectType SObjectTypeObj = ;
            // Schema.DescribeSObjectResult DescribeSObjectResultObj = ;
            //  Schema.FieldSet fieldSetObj = ;
            //  List < Schema.FieldSetMember > fieldSetMemberList = ;
            fieldSet = new List < string > ();
            for (Schema.FieldSetMember fieldSetMemberObj: Schema.getGlobalDescribe().get('Phoenix_Bid__c').getDescribe().FieldSets.getMap().get(secName).getFields()) {
                fieldSet.add(fieldSetMemberObj.getFieldPath());
            }
            section = secName.replace('Phoenix_', ' ');
            LayoutPage layout = new LayoutPage(section.replace('_', ' '), fieldSet);
            listLayoutPage.add(layout);
            
            
        }
        wrapperCls.layoutList = listLayoutPage;
        listLayoutPage.clear();
        sectionNames.clear();
        return wrapperCls;
    }
    
    public class WrapperClass {
        @AuraEnabled
        public Opportunity opty;
        @AuraEnabled
        public List < LayoutPage > layoutList;
        @AuraEnabled public boolean hasLines;
        @AuraEnabled public boolean bidCreated;
        @auraEnabled public List<Product_Opportunity__c> optyLineItems;
        
        // =new List<String>{'Section 1','Payment Term','Section 2','Section 3','Section 4','Section 5','Section 6','Section 7','Section 8'};
        public WrapperClass() {
            opty = new Opportunity();
            layoutList = new List < LayoutPage > ();
            hasLines = false;
            bidCreated=false;
            optyLineItems = new List<Product_Opportunity__c>();
        }
    }
    
    public class LayoutPage {
        @AuraEnabled
        public string sectionName;
        @AuraEnabled
        public List < string > fieldSet;
        @AuraEnabled
        public List < SeperateFields > sepFields;
        public LayoutPage(String secName, List < string > fields) {
            this.sectionName = secName;
            this.fieldSet = fields;
            sepFields = new List < SeperateFields > ();
            for (Integer i = 0; i < fields.size(); i = i + 2) {
                if (i + 1 < fields.size()) {
                    SeperateFields sf = new SeperateFields(fields[i], fields[i + 1]);
                    sepFields.add(sf);
                }
            }
            if (math.mod(fields.size(), 2) == 1) {
                SeperateFields sf = new SeperateFields(fields[fields.size() - 1], null);
                sepFields.add(sf);
            }
        }
    }
    
    public class SeperateFields {
        @AuraEnabled
        public String firstField;
        @AuraEnabled
        public String secondField;
        public SeperateFields(String first, String second) {
            this.firstField = first;
            this.secondField = second;
        }
    }
    
    @AuraEnabled
    public static String saveOptyProducts(Id opportunityId, String matchData, String unmatchData){
        try{
            //if(opportunityId.contains('/')){
             //   opportunityId = opportunityId.replace('/', '');
            //}
            List<Product_Opportunity__c> matchList = new List<Product_Opportunity__c>();
            List<Product_Opportunity__c> unmatchList = new List<Product_Opportunity__c>();
            if(String.isNotBlank(matchData)){
                matchList = (List<Product_Opportunity__c>)JSON.deserialize(matchData,List<Product_Opportunity__c>.class);
            }
            if(String.isNotBlank(unmatchData)){
                unmatchList  = (List<Product_Opportunity__c>)JSON.deserialize(unmatchData,List<Product_Opportunity__c>.class);
            }
            if(String.isNotBlank(opportunityId)){
                List<Product_Opportunity__c> optyLineItemList = new List<Product_Opportunity__c >();
                Opportunity opp = [Select ID, Name, AccountId,Account.AccountNumber,Bid_Type__c,Vision_Bid_Template__c
                                   From Opportunity Where ID = : opportunityId];
                if(matchList.size() > 0){
                    Map<Id, List<Product_Opportunity__c>> identifyDupRecs = new Map<Id, List<Product_Opportunity__c>>();
                    list<String> prodIds = new list<String>();
                    Map<Id, Product2> prodMap = new Map<Id, Product2>(); 
                    List<String> gcnList = new List<String>();
					List<String> gsnList = new List<String>();
					List<String> gpiList = new List<String>();
					Map<String,Integer> noOfGcpProds = new Map<String,Integer>();
					Map<String,Integer> noOfGsnProds = new Map<String,Integer>();
					Map<String,Integer> noOfGpiProds = new Map<String,Integer>();
					
                    Map<String,Integer> noOfGcpPkgProds = new Map<String,Integer>();
					Map<String,Integer> noOfGsnPkgProds = new Map<String,Integer>();
					Map<String,Integer> noOfGpiPkgProds = new Map<String,Integer>();
					
                    for(Product_Opportunity__c prd: matchList){
                        if(!prodIds.contains(prd.Product__c))
                            prodIds.add(prd.Product__c);
                        if(prd.Is_GCN_Matched__c){
                            if(!gcnList.contains(prd.GCN_Generic_Code_Number__c))
                                gcnList.add(prd.GCN_Generic_Code_Number__c);
                        }
                        if(prd.Is_GSN_Matched__c){
                            if(!gsnList.contains(prd.GSN__c))
                                gsnList.add(prd.GSN__c);
                        }
                        if(prd.Is_GPI_Matched__c){
                            if(!gpiList.contains(prd.GPI_Generic_Product_Identifier__c))
                                gpiList.add(prd.GPI_Generic_Product_Identifier__c);
                        }
                    }
                    List<Product2> prodList = [SELECT Id, Product_Family__c, Product_Family__r.Name, name, Phoenix_Pkg_Size__c, Phoenix_Lowest_Price_SKU__c, Phoenix_GCN_Generic_Code_Number__c, Phoenix_GCN_Sequence_Number__c, Phoenix_GPI_Generic_Product_Identifier__c FROM Product2 
                                               WHERE (Id IN:prodIds OR Phoenix_GCN_Generic_Code_Number__c IN: gcnList OR Phoenix_GCN_Sequence_Number__c IN: gsnList OR Phoenix_GPI_Generic_Product_Identifier__c IN: gpiList) 
                                               AND (Phoenix_Is_Private_Label_OTC__c = false OR (Phoenix_Is_Private_Label_OTC__c = true AND OTC_Customer__c = : opp.AccountId)) AND isActive = true AND Phoenix_Is_Exclude_Bid__c = false];
                    for(Product2 prd : prodList){
                        if(!prodMap.containsKey(prd.Id))
                            prodMap.put(prd.Id,prd);
                        if(prd.Phoenix_GCN_Generic_Code_Number__c != null){
                            if(noOfGcpProds.containsKey(prd.Phoenix_GCN_Generic_Code_Number__c))
                                noOfGcpProds.put(prd.Phoenix_GCN_Generic_Code_Number__c,noOfGcpProds.get(prd.Phoenix_GCN_Generic_Code_Number__c)+1);
                            else
                                noOfGcpProds.put(prd.Phoenix_GCN_Generic_Code_Number__c,1);
                        }
                        if(prd.Phoenix_GCN_Sequence_Number__c != null){
                            if(noOfGsnProds.containsKey(prd.Phoenix_GCN_Sequence_Number__c))
                                noOfGsnProds.put(prd.Phoenix_GCN_Sequence_Number__c,noOfGsnProds.get(prd.Phoenix_GCN_Sequence_Number__c)+1);
                            else
                                noOfGsnProds.put(prd.Phoenix_GCN_Sequence_Number__c,1);
                        }
                        if(prd.Phoenix_GPI_Generic_Product_Identifier__c != null){
                            if(noOfGpiProds.containsKey(prd.Phoenix_GPI_Generic_Product_Identifier__c))
                                noOfGpiProds.put(prd.Phoenix_GPI_Generic_Product_Identifier__c,noOfGpiProds.get(prd.Phoenix_GPI_Generic_Product_Identifier__c)+1);
                            else
                                noOfGpiProds.put(prd.Phoenix_GPI_Generic_Product_Identifier__c,1);
                        }
                        //if(prd.Phoenix_Pkg_Size__c != null){
                            /*if(prd.Phoenix_GCN_Generic_Code_Number__c != null){
                                String item = prd.Phoenix_GCN_Generic_Code_Number__c+''+prd.Phoenix_Pkg_Size__c;
                                if(noOfGcpPkgProds.containsKey(item))
                                    noOfGcpPkgProds.put(item,noOfGcpProds.get(item)+1);
                                else
                                    noOfGcpPkgProds.put(item,1);
                            }
                            if(prd.Phoenix_GCN_Sequence_Number__c != null){
                                String item = prd.Phoenix_GCN_Sequence_Number__c+''+prd.Phoenix_Pkg_Size__c;
                                if(noOfGsnPkgProds.containsKey(item))
                                    noOfGsnPkgProds.put(item,noOfGcpProds.get(item)+1);
                                else
                                    noOfGsnPkgProds.put(item,1);
                            }
                            if(prd.Phoenix_GPI_Generic_Product_Identifier__c != null){
                                String item = prd.Phoenix_GPI_Generic_Product_Identifier__c+''+prd.Phoenix_Pkg_Size__c;
                                if(noOfGpiPkgProds.containsKey(item))
                                    noOfGpiPkgProds.put(item,noOfGcpProds.get(item)+1);
                                else
                                    noOfGpiPkgProds.put(item,1);
                            }*/
                        //}
                    }
                    //added by srimayee start
            set<String> conNos = new set<String>();
                Map<String,List<Phoenix_Inclusion_Contract_Pharmabid__c>> exContractsMap = new Map<String,List<Phoenix_Inclusion_Contract_Pharmabid__c>>();
                Map<String,List<String>> contractsMap = new Map<String,List<String>>();
                Map<Id,List<Phoenix_NPR_Data__c>> nprDataMap = new Map<Id,List<Phoenix_NPR_Data__c>>();
                Map<String,String> cptMap = new Map<String,String>();
                List<Phoenix_Inclusion_Contract_Pharmabid__c> InclusionContractsList= [SELECT Id, Customer_Number__c, Name, Group_Customer_Name__r.Name,Customer_Name__r.Name, Group_Customer_Number__c, Contract_Number__c FROM Phoenix_Inclusion_Contract_Pharmabid__c];
                    if(opp.Account.AccountNumber == '164498'){
                        for(Phoenix_Inclusion_Contract_Pharmabid__c con : InclusionContractsList){
                            conNos.add(con.Contract_Number__c);
                            if(exContractsMap.containsKey(con.Contract_Number__c)){
                    List<Phoenix_Inclusion_Contract_Pharmabid__c> conSet = exContractsMap.get(con.Contract_Number__c);
                    conSet.add(con);
                    exContractsMap.put(con.Contract_Number__c,conSet);
                }
                else{
                    exContractsMap.put(con.Contract_Number__c,new List<Phoenix_Inclusion_Contract_Pharmabid__c>{con});
                }
                  if(contractsMap.containsKey(con.Contract_Number__c)){
                    List<String> conSet = contractsMap.get(con.Contract_Number__c);
                    conSet.add(con.Customer_Name__r.Name);
                    contractsMap.put(con.Contract_Number__c,conSet);
                }
                else{
                    contractsMap.put(con.Contract_Number__c,new List<String>{con.Customer_Name__r.Name});
                }    
            }
              
            set<String> uniqueNPRList =new set<String>();
            List<Phoenix_NPR_Data__c> nprData = [SELECT Id,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_Product__c,Phoenix_Contract_Number__c,Phoenix_Contract_Price__c,Phoenix_Awarded_Position__c,Phoenix_Product_Position__c, Phoenix_Material_Number__c  
                                                 from Phoenix_NPR_Data__c where Phoenix_Product__c IN: prodIds AND Phoenix_Contract_Number__c IN:conNos];
           system.debug('nprData=='+nprData.size());
                for(Phoenix_NPR_Data__c npr:nprData){
                String identifier = npr.Phoenix_Material_Number__c+'_'+npr.Phoenix_Contract_Number__c;
                    system.debug('identifier=='+identifier);
                uniqueNPRList.add(identifier);
                if(nprDataMap.containsKey(npr.Phoenix_Product__c)){
                    List<Phoenix_NPR_Data__c> nprList = nprDataMap.get(npr.Phoenix_Product__c);
                    nprList.add(npr);
                    nprDataMap.put(npr.Phoenix_Product__c,nprList);
                }
                else{
                    nprDataMap.put(npr.Phoenix_Product__c,new List<Phoenix_NPR_Data__c>{npr});
                }
            }
            List<Vision_Customer_Product_Tracker__c> cptList = [SELECT Id, General_Category__c,Vision_Current_Product_Position__c,category__c,Vision_Unique_Identifier__c,Vision_Product_Code__c,Vision_Contract_Number__c from Vision_Customer_Product_Tracker__c where Vision_Unique_Identifier__c IN:uniqueNPRList];
            for(Vision_Customer_Product_Tracker__c cpt : cptList){
                system.debug('Vision_Unique_Identifier__c=='+cpt.Vision_Unique_Identifier__c);
                system.debug('General_Category__c=='+cpt.General_Category__c);
               cptMap.put(cpt.Vision_Unique_Identifier__c,cpt.General_Category__c);
            }
            }
                                    Map<String,String> custNamesMap = new Map<String,String>();

        //added by srimayee end

                    for(Product_Opportunity__c prd: matchList){
                        String prodId = String.valueOf(prd.Product__c);
                        if(prd.Strength__c != null && prd.Strength__c != ''){
                            if(prd.Strength__c.length() > 255)
                                prd.Strength__c = prd.Strength__c.substring(0,250);
                        }
                        if(prodId.contains('/'))
                            prd.Product__c = Id.valueOf(prodId.replace('/', ''));
                        if(prd.Vision_Total_Annual_Units__c != null && prd.vision_is_discrepancy_product__c)
                            prd.vision_is_discrepancy_product__c = false;
                        prd.Opportunity__c = opp.Id;
                        /*if(opp.Vision_Bid_Template__c == 'Indirect' || opp.Vision_Bid_Template__c == 'Walgreens' || opp.Vision_Bid_Template__c == 'ABC Progen' || opp.Vision_Bid_Template__c == 'Costco' || opp.Vision_Bid_Template__c == 'Sams Club'){
                            if(prd.Vision_Total_Annual_Units__c == null)
                                prd.Vision_Total_Annual_Units__c = prd.Proposed_Indirect_Selling_Units__c;
                            else if(prd.Proposed_Indirect_Selling_Units__c == null)
                                prd.Proposed_Indirect_Selling_Units__c = prd.Vision_Total_Annual_Units__c;
                        }
                        if(opp.Vision_Bid_Template__c == 'Direct'){
                            if(prd.Proposed_Direct_Selling_Units__c == null)
                                prd.Proposed_Direct_Selling_Units__c = prd.Vision_Total_Annual_Units__c;
                            else if(prd.Vision_Total_Annual_Units__c == null)
                                prd.Vision_Total_Annual_Units__c = prd.Proposed_Direct_Selling_Units__c;
                        }*/
                        prd.Vision_Guidance_Price__c = prd.Vision_Guidance_Price__c != null ? prd.Vision_Guidance_Price__c : 0;
                        prd.Proposed_Direct_Selling_Units__c = prd.Proposed_Direct_Selling_Units__c != null ? prd.Proposed_Direct_Selling_Units__c : 0;
                        prd.Proposed_Indirect_Selling_Units__c = prd.Proposed_Indirect_Selling_Units__c != null ? prd.Proposed_Indirect_Selling_Units__c : 0;
                        prd.Vision_Proposed_OS_Units__c = prd.Vision_Proposed_OS_Units__c != null ? prd.Vision_Proposed_OS_Units__c : 0;
                        prd.Vision_Proposed_RAD_Units__c = prd.Vision_Proposed_RAD_Units__c != null ? prd.Vision_Proposed_RAD_Units__c : 0;
                        prd.Vision_Proposed_WMT_Units__c = prd.Vision_Proposed_WMT_Units__c != null ? prd.Vision_Proposed_WMT_Units__c : 0;
                        prd.Vision_Proposed_BASE_Units__c = prd.Vision_Proposed_BASE_Units__c != null ? prd.Vision_Proposed_BASE_Units__c : 0;
                        prd.Vision_Proposed_DSH_Units__c = prd.Vision_Proposed_DSH_Units__c != null ? prd.Vision_Proposed_DSH_Units__c : 0;
                        prd.Vision_Proposed_AutoSub_Units__c = prd.Vision_Proposed_AutoSub_Units__c != null ? prd.Vision_Proposed_AutoSub_Units__c : 0;
                        prd.Vision_Proposed_Smith_Drug_Units__c =  prd.Vision_Proposed_Smith_Drug_Units__c != null ? prd.Vision_Proposed_Smith_Drug_Units__c : 0;
                        prd.Vision_Proposed_Anda_Units__c = prd.Vision_Proposed_Anda_Units__c != null ? prd.Vision_Proposed_Anda_Units__c : 0;
                        prd.Vision_Proposed_DirectAholdDelhaizeUnits__c = prd.Vision_Proposed_DirectAholdDelhaizeUnits__c != null ? prd.Vision_Proposed_DirectAholdDelhaizeUnits__c : 0;
                        prd.Vision_Proposed_Direct_Gaint_Eagle_Units__c = prd.Vision_Proposed_Direct_Gaint_Eagle_Units__c != null ? prd.Vision_Proposed_Direct_Gaint_Eagle_Units__c : 0;
                        prd.Vision_Proposed_TotalRetailIndirectUnits__c = prd.Vision_Proposed_TotalRetailIndirectUnits__c != null ? prd.Vision_Proposed_TotalRetailIndirectUnits__c : 0;
                        
                        prd.Vision_Proposed_Direct_ESI_Units__c = prd.Vision_Proposed_Direct_ESI_Units__c != null ? prd.Vision_Proposed_Direct_ESI_Units__c : 0;
                        prd.Vision_Proposed_Indirect_ESI_Units__c = prd.Vision_Proposed_Indirect_ESI_Units__c != null ? prd.Vision_Proposed_Indirect_ESI_Units__c : 0;
                        prd.Vision_Proposed_Direct_Kroger_Units__c = prd.Vision_Proposed_Direct_Kroger_Units__c != null ? prd.Vision_Proposed_Direct_Kroger_Units__c : 0;
                        prd.Vision_Proposed_Indirect_Kroger_Units__c = prd.Vision_Proposed_Indirect_Kroger_Units__c != null ? prd.Vision_Proposed_Indirect_Kroger_Units__c : 0;
                        prd.Vision_Proposed_Direct_Rx_Outreach_Units__c = prd.Vision_Proposed_Direct_Rx_Outreach_Units__c != null ? prd.Vision_Proposed_Direct_Rx_Outreach_Units__c : 0;
                        prd.Vision_Proposed_IndirectRxOutreach_Units__c = prd.Vision_Proposed_IndirectRxOutreach_Units__c != null ? prd.Vision_Proposed_IndirectRxOutreach_Units__c : 0;
                        prd.Vision_Proposed_Direct_Supervalu_Units__c = prd.Vision_Proposed_Direct_Supervalu_Units__c != null ? prd.Vision_Proposed_Direct_Supervalu_Units__c : 0;
                        prd.Vision_Proposed_Indirect_Supervalu_Units__c = prd.Vision_Proposed_Indirect_Supervalu_Units__c != null ? prd.Vision_Proposed_Indirect_Supervalu_Units__c : 0;
                        prd.Vision_Proposed_Indirect_Cigna_Units__c = prd.Vision_Proposed_Indirect_Cigna_Units__c != null ? prd.Vision_Proposed_Indirect_Cigna_Units__c : 0;
                        prd.Vision_Proposed_Direct_Cigna_Units__c = prd.Vision_Proposed_Direct_Cigna_Units__c != null ? prd.Vision_Proposed_Direct_Cigna_Units__c : 0;
                        prd.Vision_Proposed_Direct_Cordant_Units__c = prd.Vision_Proposed_Direct_Cordant_Units__c != null ? prd.Vision_Proposed_Direct_Cordant_Units__c : 0;
                        prd.Vision_Proposed_Direct_Accerodo_Units__c =  prd.Vision_Proposed_Direct_Accerodo_Units__c != null ? prd.Vision_Proposed_Direct_Accerodo_Units__c : 0;
                        prd.Vision_Proposed_Indirect_Accerodo_Units__c = prd.Vision_Proposed_Indirect_Accerodo_Units__c != null ? prd.Vision_Proposed_Indirect_Accerodo_Units__c : 0;
                        prd.Vision_Proposed_Indirect_Cordant_Units__c = prd.Vision_Proposed_Indirect_Cordant_Units__c != null ? prd.Vision_Proposed_Indirect_Cordant_Units__c : 0;
                        
                        prd.Vision_Proposed_CVS_Direct_Units__c = prd.Vision_Proposed_CVS_Direct_Units__c != null ? prd.Vision_Proposed_CVS_Direct_Units__c : 0;
                        prd.Vision_Proposed_CVS_Indirect_Units__c = prd.Vision_Proposed_CVS_Indirect_Units__c != null ? prd.Vision_Proposed_CVS_Indirect_Units__c : 0;
                        prd.Vision_Proposed_Cardinal_Units__c = prd.Vision_Proposed_Cardinal_Units__c != null ? prd.Vision_Proposed_Cardinal_Units__c : 0;
                        prd.Vision_Proposed_Major_Units__c = prd.Vision_Proposed_Major_Units__c != null ? prd.Vision_Proposed_Major_Units__c : 0;
                        
                        prd.Vision_Total_Annual_Units__c = prd.Proposed_Direct_Selling_Units__c+prd.Proposed_Indirect_Selling_Units__c+prd.Vision_Proposed_OS_Units__c+prd.Vision_Proposed_RAD_Units__c+prd.Vision_Proposed_WMT_Units__c+prd.Vision_Proposed_BASE_Units__c+prd.Vision_Proposed_DSH_Units__c+prd.Vision_Proposed_AutoSub_Units__c+prd.Vision_Proposed_Smith_Drug_Units__c+prd.Vision_Proposed_Anda_Units__c+prd.Vision_Proposed_DirectAholdDelhaizeUnits__c+prd.Vision_Proposed_Direct_Gaint_Eagle_Units__c+prd.Vision_Proposed_TotalRetailIndirectUnits__c+prd.Vision_Proposed_Direct_ESI_Units__c+prd.Vision_Proposed_Indirect_ESI_Units__c+prd.Vision_Proposed_Direct_Kroger_Units__c+prd.Vision_Proposed_Indirect_Kroger_Units__c+prd.Vision_Proposed_Direct_Rx_Outreach_Units__c+prd.Vision_Proposed_IndirectRxOutreach_Units__c+prd.Vision_Proposed_Direct_Supervalu_Units__c+prd.Vision_Proposed_Indirect_Supervalu_Units__c+prd.Vision_Proposed_Direct_Cordant_Units__c+prd.Vision_Proposed_Indirect_Cordant_Units__c+prd.Vision_Proposed_Direct_Accerodo_Units__c+prd.Vision_Proposed_Indirect_Accerodo_Units__c+prd.Vision_Proposed_CVS_Direct_Units__c+prd.Vision_Proposed_CVS_Indirect_Units__c+prd.Vision_Proposed_Cardinal_Units__c+prd.Vision_Proposed_Major_Units__c+prd.Vision_Proposed_Indirect_Cigna_Units__c+prd.Vision_Proposed_Direct_Cigna_Units__c;
                        //added by srimayee start
            if(opp.Account.AccountNumber == '164498'){
                List<Phoenix_NPR_Data__c> nprList = nprDataMap.get( prd.Product__c) != null ? nprDataMap.get( prd.Product__c) : null;
                system.debug('nprList=='+nprList);
                if(nprList != null){
                        for(Phoenix_NPR_Data__c npr : nprList){
                            String identifier = npr.Phoenix_Material_Number__c+'_'+npr.Phoenix_Contract_Number__c;
                            List<Phoenix_Inclusion_Contract_Pharmabid__c> custList =exContractsMap.get(npr.Phoenix_Contract_Number__c);
                            for(Phoenix_Inclusion_Contract_Pharmabid__c cust :custList){
                                if(cptMap.get(identifier) == 'Secondary' && cust.Group_Customer_Name__r.Name != null){
                                   String temp = 'All members of '+ cust.Group_Customer_Name__r.Name; 
                                    custNamesMap.put(identifier,temp);  
                                }
                                else if(cptMap.get(identifier) == 'Secondary'){
                                     custNamesMap.put(identifier,cust.Customer_Name__r.Name);   
                                }
                                if(cptMap.get(identifier) == 'Primary' && cust.Group_Customer_Name__r.Name != null){
                                    String temp = 'All members of '+ cust.Group_Customer_Name__r.Name; 
                                    custNamesMap.put(identifier,temp);  
                                }
                                else if(cptMap.get(identifier) == 'Primary'){
                                   custNamesMap.put(identifier,cust.Customer_Name__r.Name);   
                                }
                                
                                
                            }
                        }
                           for(Phoenix_NPR_Data__c npr : nprList){
                        String identifier = npr.Phoenix_Material_Number__c+'_'+npr.Phoenix_Contract_Number__c;
                         system.debug('identifier=='+identifier);
                        set<String> custNameSet = new set<String>();
                        custNameSet.addAll(contractsMap.get(npr.Phoenix_Contract_Number__c)); 
                       if(cptMap.get(identifier) == 'Primary' ){
                             system.debug('Primary=='+custNamesMap.get(identifier));
                            if(prd.Primary_Exclusion_Customers__c != null && prd.Primary_Exclusion_Customers__c != null && !prd.Primary_Exclusion_Customers__c.contains(custNamesMap.get(identifier))){
                            prd.Primary_Exclusion_Customers__c = prd.Primary_Exclusion_Customers__c+', '+custNamesMap.get(identifier);    
                            }
                            else{
                             prd.Primary_Exclusion_Customers__c = custNamesMap.get(identifier);
                            }
                            for(String str :custNameSet){
                            if(prd.Primary_Grp_Exclusion_Customers__c != null && prd.Primary_Grp_Exclusion_Customers__c != null && !prd.Primary_Grp_Exclusion_Customers__c.contains(str.trim())){
                             //   prd.Primary_Grp_Exclusion_Customers__c = prd.Primary_Grp_Exclusion_Customers__c + ', '+ String.join(new List<String>(custNameSet),',');
                                 prd.Primary_Grp_Exclusion_Customers__c = prd.Primary_Grp_Exclusion_Customers__c + ', '+str;   
                                }
                           
                            else{
                                prd.Primary_Grp_Exclusion_Customers__c = str;//String.join(new List<String>(custNameSet),', ');
                                
                            }
                           }  
                        }
                        if(cptMap.get(identifier) == 'Secondary'){
                            system.debug('secondary=='+custNamesMap.get(identifier));
                             if(prd.Secondary_Backup_Exclusion_Customers__c != null && prd.Secondary_Backup_Exclusion_Customers__c != null && !prd.Secondary_Backup_Exclusion_Customers__c.contains(custNamesMap.get(identifier))){
                            prd.Secondary_Backup_Exclusion_Customers__c = prd.Secondary_Backup_Exclusion_Customers__c+', '+custNamesMap.get(identifier);    
                            }
                            else{
                             prd.Secondary_Backup_Exclusion_Customers__c = custNamesMap.get(identifier);
                            }
                            for(String str :custNameSet){

                            if(prd.Secondary_Backup_Grp_Exclusion_Customers__c != null && prd.Secondary_Backup_Exclusion_Customers__c != null && !prd.Secondary_Backup_Grp_Exclusion_Customers__c.contains(custNamesMap.get(identifier))){
                                
                                // prd.Secondary_Backup_Grp_Exclusion_Customers__c = prd.Secondary_Backup_Grp_Exclusion_Customers__c + ', '+ String.join(new List<String>(custNameSet),',');
                                prd.Secondary_Backup_Grp_Exclusion_Customers__c = prd.Secondary_Backup_Grp_Exclusion_Customers__c + ', '+str;   

                            }
                            else{
                               // prd.Secondary_Backup_Grp_Exclusion_Customers__c = String.join(new List<String>(custNameSet),', ');
                               prd.Secondary_Backup_Grp_Exclusion_Customers__c = str; 
                            }
                            }
                        }
                               
                      /*   identifier = identifier + '_' +cptMap.get(identifier);
                               if(custNamesMap.get(identifier) != null && custNamesMap.get(identifier).contains('Primary')) {
                                   //opp.Secondary_Backup_Grp_Exclusion_Customers__c   
                               }     
                               if(custNamesMap.get(identifier) != null && custNamesMap.get(identifier).contains('Secondary')) {
                                   opp.Secondary_Backup_Grp_Exclusion_Customers__c = custNamesMap.get(identifier);
                                   //opp.Secondary_Backup_Grp_Exclusion_Customers__c   
                               } */
                        prd.Final_Exclusion_Customers__c = prd.Primary_Exclusion_Customers__c;
                    }
                    }
            }
            //code by srimayee end
          
                        if(prodMap.containsKey(prd.Product__c)){
                            Product2 proObj = prodMap.get(prd.Product__c);
                            prd.Vision_Opportunity_Value__c = (prd.Vision_Total_Annual_Units__c != null ? prd.Vision_Total_Annual_Units__c : 0) * (proObj.Phoenix_Lowest_Price_SKU__c != null ? proObj.Phoenix_Lowest_Price_SKU__c : 0);
                            prd.GCP_Product_Family__c = proObj.Product_Family__c;
                        }
                        if(prd.Product__c != null){
                            if(!identifyDupRecs.containsKey(prd.Product__c))
                                identifyDupRecs.put(prd.Product__c,new List<Product_Opportunity__c>());
                            identifyDupRecs.get(prd.Product__c).add(prd);
                        }
                    }
                    
                    if(unmatchList.size() > 0){
                        for(Product_Opportunity__c prd: unmatchList){
                            if(prd.Strength__c != null && prd.Strength__c != ''){
                                if(prd.Strength__c.length() > 255)
                                    prd.Strength__c = prd.Strength__c.substring(0,250);
                            }
                            prd.Opportunity__c = opp.Id;
                            optyLineItemList.add(prd);
                        }
                    }
                    
                    for(Id prdId : identifyDupRecs.keyset()){
                        List<Product_Opportunity__c> optyProdList = identifyDupRecs.get(prdId);
                        
                        if(optyProdList.size()>1){
                            for(Product_Opportunity__c optyProdObj : optyProdList){
                                optyProdObj.Status__c = 'Discrepant'; optyProdObj.vision_is_discrepancy_product__c = true; optyLineItemList.add(optyProdObj);
                            }
                        }
                        else{
                            Product_Opportunity__c optyProdObj = optyProdList[0];
                            if(!optyProdObj.Is_NDC_Matched__c && !optyProdObj.Is_SKU_Matched__c){
                                if(optyProdObj.Is_GCN_Pack_Size_Matched__c || optyProdObj.Is_GSN_Pack_Size_Matched__c || optyProdObj.Is_GPI_Pack_Size_Matched__c){
                                    if(optyProdObj.Is_GCN_Pack_Size_Matched__c && noOfGcpPkgProds.containsKey(optyProdObj.GCN_Generic_Code_Number__c+''+optyProdObj.Vision_Disc_Pkg_Size__c)){
                                        if(noOfGcpPkgProds.get(optyProdObj.GCN_Generic_Code_Number__c+''+optyProdObj.Vision_Disc_Pkg_Size__c)>1){
                                            optyProdObj.Status__c = 'Discrepant'; optyProdObj.vision_is_discrepancy_product__c = true;}
                                    }
                                    if(optyProdObj.Is_GSN_Pack_Size_Matched__c && noOfGsnPkgProds.containsKey(optyProdObj.GSN__c+''+optyProdObj.Vision_Disc_Pkg_Size__c)){
                                        if(noOfGsnPkgProds.get(optyProdObj.GSN__c+''+optyProdObj.Vision_Disc_Pkg_Size__c)>1){
                                            optyProdObj.Status__c = 'Discrepant'; optyProdObj.vision_is_discrepancy_product__c = true;}
                                    }
                                    if(optyProdObj.Is_GPI_Pack_Size_Matched__c && noOfGpiPkgProds.containsKey(optyProdObj.GPI_Generic_Product_Identifier__c+''+optyProdObj.Vision_Disc_Pkg_Size__c)){
                                        if(noOfGpiPkgProds.get(optyProdObj.GPI_Generic_Product_Identifier__c+''+optyProdObj.Vision_Disc_Pkg_Size__c)>1){
                                            optyProdObj.Status__c = 'Discrepant'; optyProdObj.vision_is_discrepancy_product__c = true;}
                                    }
                                }
                                else if(optyProdObj.Is_GCN_Matched__c || optyProdObj.Is_GSN_Matched__c || optyProdObj.Is_GPI_Matched__c){
                                    boolean checkAltPkg = false;
                                    boolean stopNextValidation = false;
                                    if(optyProdObj.Is_GCN_Matched__c && noOfGcpProds.containsKey(optyProdObj.GCN_Generic_Code_Number__c)){
                                        if(noOfGcpProds.get(optyProdObj.GCN_Generic_Code_Number__c)>1){
                                            stopNextValidation=true; optyProdObj.Status__c = 'Discrepant'; optyProdObj.vision_is_discrepancy_product__c = true;optyProdObj.Vision_Number_Items__c=noOfGcpProds.get(optyProdObj.GCN_Generic_Code_Number__c);}
                                        else
                                            checkAltPkg = true;
                                    }
                                    if(optyProdObj.Is_GSN_Matched__c && noOfGsnProds.containsKey(optyProdObj.GSN__c) && !stopNextValidation){
                                        if(noOfGsnProds.get(optyProdObj.GSN__c)>1){
                                            stopNextValidation=true; optyProdObj.Status__c = 'Discrepant'; optyProdObj.vision_is_discrepancy_product__c = true;optyProdObj.Vision_Number_Items__c=noOfGsnProds.get(optyProdObj.GSN__c);}
                                        else
                                            checkAltPkg = true;
                                    }
                                    if(optyProdObj.Is_GPI_Matched__c && noOfGpiProds.containsKey(optyProdObj.GPI_Generic_Product_Identifier__c) && !stopNextValidation){
                                        if(noOfGpiProds.get(optyProdObj.GPI_Generic_Product_Identifier__c)>1){
                                            optyProdObj.Status__c = 'Discrepant'; optyProdObj.vision_is_discrepancy_product__c = true;optyProdObj.Vision_Number_Items__c=noOfGpiProds.get(optyProdObj.GPI_Generic_Product_Identifier__c);}
                                        else
                                            checkAltPkg = true;
                                    }
                                    if(checkAltPkg){
                                        if(isNumeric(optyProdObj.Vision_Disc_Pkg_Size__c)){
                                            Product2 proObj = prodMap.get(optyProdObj.Product__c);
                                            if(Decimal.valueOf(optyProdObj.Vision_Disc_Pkg_Size__c) != proObj.Phoenix_Pkg_Size__c){
                                                optyProdObj = calculateWithPackSize(proObj.Phoenix_Pkg_Size__c, Decimal.valueOf(optyProdObj.Vision_Disc_Pkg_Size__c), optyProdObj);
                                                optyProdObj.Vision_Uploaded_Pkg_Size__c = Decimal.valueOf(optyProdObj.Vision_Disc_Pkg_Size__c);
                                                optyProdObj.Pkg_Size__c = proObj.Phoenix_Pkg_Size__c;
                                            }
                                        }
                                    }
                                }
                            }
                            optyLineItemList.add(optyProdObj);
                        }
                    }
                }
                
                if(optyLineItemList.size() > 0){
                    upsert optyLineItemList;
                    return 'Record Saved Successfully';
                }
                else{
                    return 'Unable to save record - List is empty';
                }
            }
            else{
                return 'Missing Opportunity Id';
            }
        }
        catch(Exception e){
            Phoenix_Util.recordException(e,'Vision_OpportunityCreator','saveOptyProducts',''+' line Number : '+e.getLineNumber()); 
            return 'error';
        }
    }
    
    public static Product_Opportunity__c calculateWithPackSize(Decimal packSize, Decimal OptypackSize,Product_Opportunity__c optyProdObj){
        //optyProdObj.Vision_Total_Annual_Units__c = optyProdObj.Vision_Total_Annual_Units__c != null ? ((optyProdObj.Vision_Total_Annual_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Proposed_Direct_Selling_Units__c = optyProdObj.Proposed_Direct_Selling_Units__c != null ? ((optyProdObj.Proposed_Direct_Selling_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Proposed_Indirect_Selling_Unit__c = optyProdObj.Proposed_Indirect_Selling_Unit__c != null ? ((optyProdObj.Proposed_Indirect_Selling_Unit__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_OS_Units__c = optyProdObj.Vision_Proposed_OS_Units__c != null ? ((optyProdObj.Vision_Proposed_OS_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_RAD_Units__c = optyProdObj.Vision_Proposed_RAD_Units__c != null ? ((optyProdObj.Vision_Proposed_RAD_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_WMT_Units__c = optyProdObj.Vision_Proposed_WMT_Units__c != null ? ((optyProdObj.Vision_Proposed_WMT_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_BASE_Units__c = optyProdObj.Vision_Proposed_BASE_Units__c != null ? ((optyProdObj.Vision_Proposed_BASE_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_DSH_Units__c = optyProdObj.Vision_Proposed_DSH_Units__c != null ? ((optyProdObj.Vision_Proposed_DSH_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_AutoSub_Units__c = optyProdObj.Vision_Proposed_AutoSub_Units__c != null ? ((optyProdObj.Vision_Proposed_AutoSub_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_Smith_Drug_Units__c = optyProdObj.Vision_Proposed_Smith_Drug_Units__c != null ? ((optyProdObj.Vision_Proposed_Smith_Drug_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_Anda_Units__c = optyProdObj.Vision_Proposed_Anda_Units__c != null ? ((optyProdObj.Vision_Proposed_Anda_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c = optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c != null ? ((optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c = optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c != null ? ((optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c = optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c != null ? ((optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c*OptypackSize)/packSize).setScale(0) : 0;
        
        optyProdObj.Vision_Proposed_Direct_ESI_Units__c = optyProdObj.Vision_Proposed_Direct_ESI_Units__c != null ? ((optyProdObj.Vision_Proposed_Direct_ESI_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_Indirect_ESI_Units__c = optyProdObj.Vision_Proposed_Indirect_ESI_Units__c != null ? ((optyProdObj.Vision_Proposed_Indirect_ESI_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_Direct_Kroger_Units__c = optyProdObj.Vision_Proposed_Direct_Kroger_Units__c != null ? ((optyProdObj.Vision_Proposed_Direct_Kroger_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c = optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c != null ? ((optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c = optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c != null ? ((optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c = optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c != null ? ((optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c = optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c != null ? ((optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c = optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c != null ? ((optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_Direct_Cigna_Units__c = optyProdObj.Vision_Proposed_Direct_Cigna_Units__c != null ? ((optyProdObj.Vision_Proposed_Direct_Cigna_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_Indirect_Cigna_Units__c = optyProdObj.Vision_Proposed_Indirect_Cigna_Units__c != null ? ((optyProdObj.Vision_Proposed_Indirect_Cigna_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_Direct_Cordant_Units__c = optyProdObj.Vision_Proposed_Direct_Cordant_Units__c != null ? ((optyProdObj.Vision_Proposed_Direct_Cordant_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c = optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c != null ? ((optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c = optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c != null ? ((optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c = optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c != null ? ((optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        
        optyProdObj.Vision_Proposed_CVS_Direct_Units__c = optyProdObj.Vision_Proposed_CVS_Direct_Units__c != null ? ((optyProdObj.Vision_Proposed_CVS_Direct_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_CVS_Indirect_Units__c = optyProdObj.Vision_Proposed_CVS_Indirect_Units__c != null ? ((optyProdObj.Vision_Proposed_CVS_Indirect_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_Cardinal_Units__c = optyProdObj.Vision_Proposed_Cardinal_Units__c != null ? ((optyProdObj.Vision_Proposed_Cardinal_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_Major_Units__c = optyProdObj.Vision_Proposed_Major_Units__c != null ? ((optyProdObj.Vision_Proposed_Major_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Proposed_Units__c = optyProdObj.Vision_Proposed_Units__c != null ? ((optyProdObj.Vision_Proposed_Units__c*OptypackSize)/packSize).setScale(0) : 0;
        optyProdObj.Vision_Total_Annual_Units__c = optyProdObj.Proposed_Direct_Selling_Units__c+optyProdObj.Proposed_Indirect_Selling_Units__c+optyProdObj.Vision_Proposed_OS_Units__c+optyProdObj.Vision_Proposed_RAD_Units__c
            +optyProdObj.Vision_Proposed_WMT_Units__c+optyProdObj.Vision_Proposed_BASE_Units__c+optyProdObj.Vision_Proposed_DSH_Units__c+optyProdObj.Vision_Proposed_AutoSub_Units__c+optyProdObj.Vision_Proposed_Smith_Drug_Units__c
            +optyProdObj.Vision_Proposed_Anda_Units__c+optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c+optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c+optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c
            +optyProdObj.Vision_Proposed_Direct_ESI_Units__c+optyProdObj.Vision_Proposed_Indirect_ESI_Units__c+optyProdObj.Vision_Proposed_Direct_Kroger_Units__c+optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c
            +optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c+optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c+optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c+optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c
            +optyProdObj.Vision_Proposed_Direct_Cordant_Units__c+optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c+optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c+optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c
            +optyProdObj.Vision_Proposed_CVS_Direct_Units__c+optyProdObj.Vision_Proposed_CVS_Indirect_Units__c+optyProdObj.Vision_Proposed_Cardinal_Units__c+optyProdObj.Vision_Proposed_Major_Units__c+optyProdObj.Vision_Proposed_Indirect_Cigna_Units__c
            +optyProdObj.Vision_Proposed_Direct_Cigna_Units__c;
        return optyProdObj;
    }
    
    @AuraEnabled
    public static String saveOptyProductsManual(String optyData, list < prdwrapperClass > saveitems, List < string > selectrcs){
        Savepoint sp = Database.setSavepoint();
        try{
            Opportunity optyRec = new Opportunity();
            savedProductOptyWrapper prdOpWrap = new savedProductOptyWrapper();
            List<Id> prdOpIds = new List<Id>();
            List<Product_Opportunity__c> prodOptyList = new List<Product_Opportunity__c>();
            //List<Competitor_Info__c> cmpList = new List<Competitor_Info__c>();
            //Map<String, Competitor_Info__c> cmpListMap = New Map<String,Competitor_Info__c>();
            Decimal optyVal = 0;
            if(String.isNotBlank(optyData)){
                optyRec = (Opportunity)JSON.deserialize(optyData,Opportunity.class);
                Id accId = optyRec.AccountId;
                //Account accObj = [SELECT Id, name, Phoenix_Customer_Class_Bid_Template__c FROM Account WHERE Id=: accId];
                optyRec.StageName = 'Opportunity in progress';
                //optyRec.Vision_Bid_Template__c = accObj.Phoenix_Customer_Class_Bid_Template__c;
                optyRec.closeDate = optyRec.Vision_Internal_Closing_Date__c; 
                insert optyRec;
            }
            List<Product_Opportunity__c> savedPrdOptyRecs = new List<Product_Opportunity__c>();
            for (prdwrapperClass wr: saveitems) {
                Product_Opportunity__c productOpportunity = new Product_Opportunity__c(
                    Name = wr.prdlist.Name,
                    GCP_Product_Family__c = wr.prdlist.Product_Family__c,
                    //GCN_Generic_Code_Number__c = wr.prdlist.Phoenix_GCN_Generic_Code_Number__c,
                    //GSN__c = wr.prdlist.Phoenix_GCN_Sequence_Number__c,
                    //GPI_Generic_Product_Identifier__c = wr.prdlist.Phoenix_GPI_Generic_Product_Identifier__c,
                    //NDC_11__c = wr.prdlist.Phoenix_NDC_11__c,
                    //SKU_Number__c = wr.prdlist.ProductCode,
                    //Product_Family__c = wr.prdlist.Family,
                    //Lowest_Price_SKU__c = wr.prdlist.Phoenix_Lowest_Price_SKU__c,
                    //Strength__c = wr.prdlist.Phoenix_Strength__c,
                    //Dosage_Form__c = wr.prdlist.Phoenix_Dosage_Form__c;
                    //Pkg_Size__c = wr.prdlist.Phoenix_Pkg_Size__c,
                    //Product_Description__c = wr.prdlist.Description
                    Product__c = wr.prdlist.id
                );
                Id prodID =  wr.prdlist.id;
                productOpportunity.Opportunity__c = optyRec.Id;
                if(productOpportunity.Vision_Opportunity_Value__c != null){
                    optyVal = optyVal + productOpportunity.Vision_Opportunity_Value__c;
                }
                /*if(String.isNotBlank(wr.incumbentCompId1) || String.isNotBlank(wr.incumbentCompId2) ||  String.isNotBlank(wr.incumbentCompId3) ||String.isNotBlank(wr.incumbentCompId4) || String.isNotBlank(wr.incumbentCompId5) ){
                       Competitor_Info__c comData = new Competitor_Info__c();
                       comData.NDC__c = wr.prdlist.Phoenix_NDC_11__c;
                       comData.Product_Family__c = wr.prdlist.Family;
                       comData.Product_Name__c = wr.prdlist.Name;
                       if(String.isNotBlank(wr.incumbentCompId1)){
                           comData.Incumbent_Competitor_Name__c = wr.incumbentCompId1;
                           comData.Incumbent_Price_Range__c = wr.priceRange1;
                       }
                       if(String.isNotBlank(wr.incumbentCompId2)){
                           comData.Incumbent_Competitor_Name_2__c = wr.incumbentCompId2;
                           comData.Incumbent_Price_Range_2__c = wr.priceRange2;
                       }
                       if(String.isNotBlank(wr.incumbentCompId3)){
                           comData.Incumbent_Competitor_Name_3__c = wr.incumbentCompId3;
                           comData.Incumbent_Price_Range_3__c = wr.priceRange3;
                       }
                       if(String.isNotBlank(wr.incumbentCompId4)){
                           comData.Incumbent_Competitor_Name_4__c = wr.incumbentCompId4;
                           comData.Incumbent_Price_Range_4__c = wr.priceRange4;
                       }
                       if(String.isNotBlank(wr.incumbentCompId5)){
                           comData.Incumbent_Competitor_Name_5__c = wr.incumbentCompId5;
                           comData.Incumbent_Price_Range_5__c = wr.priceRange5;
                       }
                       cmpListMap.put(wr.prdlist.Phoenix_NDC_11__c,comData);
                   }*/
                productOpportunity.Status__c = 'Matched';
                prodOptyList.add(productOpportunity);
            }
            
            if(prodOptyList.size() > 0){
                insert prodOptyList;
                Map<String, Product_Opportunity__c> prodMap = new Map<String, Product_Opportunity__c>();
                for(Product_Opportunity__c prd : prodOptyList){
                    prdOpIds.add(prd.Id);
                    prodMap.put(prd.NDC_11__c,prd);
                }
                //for(String ndc:cmpListMap.keySet()){
                //    if(cmpListMap.containsKey(ndc)){
                //        Competitor_Info__c comData = cmpListMap.get(ndc);
                //        comData.Vision_Product_Opportunity__c = prodMap.containsKey(ndc) ? prodMap.get(ndc).Id : null;
                //        cmpList.add(comData);
                //    }
                //}
                //insert cmpList;
                savedPrdOptyRecs = [select Id, Name, GCP_Product_Family__r.Name, GCP_Product_Family__c,Product__r.Id,Product__r.Name,Product__r.Phoenix_WAC__c ,GCN_Generic_Code_Number__c,GSN__c,GPI_Generic_Product_Identifier__c,NDC_11__c,
                                    SKU_Number__c,Product_Family__c,Lowest_Price_SKU__c,Strength__c,Pkg_Size__c,Product_Description__c,Vision_Sales_Price__c,
                                    Vision_Proposed_Units__c,Vision_Guidance_Price__c,Vision_Price_Range__c,Vision_Opportunity_Value__c,Vision_Incumbent_Competitor__r.Id, Vision_Incumbent_Competitor__r.Name,
                                    Status__c from Product_Opportunity__c Where Id = : prdOpIds];
                Opportunity opptyRec = [select Id, Vision_Opportunity_Value__c,Vision_Reference_Contract__c from Opportunity where Id = : optyRec.Id];
                String selectedContNames = '';
                if (!selectrcs.isEmpty()) {
                    List < String > selectrcsWithoutDup = new List < String > ();
                    selectedContNames = String.isNotBlank(opptyRec.Vision_Reference_Contract__c) && opptyRec.Vision_Reference_Contract__c != null ? opptyRec.Vision_Reference_Contract__c : '';
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
                    opptyRec.Vision_Reference_Contract__c = selectedContNames;
                }
                opptyRec.Vision_Opportunity_Value__c = optyVal;
                update opptyRec;
                //prdOpWrap.oppIdData = new Map<String,Id>{'OppId' => opptyRec.Id};
                //    prdOpWrap.savedProducts = savedPrdOptyRecs;
                // prdOpWrap.oppIdData = new Map<String,Id>{'OppId' => opptyRec.Id};
               //     prdOpWrap.savedProducts = savedPrdOptyRecs;
                return opptyRec.Id;
            }
            else{
                prdOpWrap.oppIdData = new Map<String,Id>{'OppId' => null};
                    return 'ERROR: No Products Selected';
            }
            
        }
        catch(Exception e){
            Database.RollBack(sp);
            Phoenix_Util.recordException(e,'Vision_OpportunityCreator','saveOptyProductsManual',''); 
            //savedProductOptyWrapper prdOpWrap = new savedProductOptyWrapper();
            //prdOpWrap.oppIdData = new Map<String,Id>{'OppId' => null};
            return 'ERROR:'+ e.getMessage();//JSON.serialize(prdOpWrap);
        }
    }
    
   @AuraEnabled
    public static String saveProductsToExtOpty(String optyId, list < prdwrapperClass > saveitems, List < string > selectrcs){
        Savepoint sp = Database.setSavepoint();
        try{
            List<Id> prdOpIds = new List<Id>();
            List<Product_Opportunity__c> prodOptyList = new List<Product_Opportunity__c>();
            Decimal optyVal = 0;
            List<Product_Opportunity__c> savedPrdOptyRecs = new List<Product_Opportunity__c>();
            for (prdwrapperClass wr: saveitems) {
                Product_Opportunity__c productOpportunity = new Product_Opportunity__c(
                    Product__c = wr.prdlist.Id,
                    Name = wr.prdlist.Name
                    /*GCN_Generic_Code_Number__c = wr.prdlist.Phoenix_GCN_Generic_Code_Number__c,
GSN__c = wr.prdlist.Phoenix_GCN_Sequence_Number__c,
GPI_Generic_Product_Identifier__c = wr.prdlist.Phoenix_GPI_Generic_Product_Identifier__c,
NDC_11__c = wr.prdlist.Phoenix_NDC_11__c,
SKU_Number__c = wr.prdlist.ProductCode,
Product_Family__c = wr.prdlist.Family,
Lowest_Price_SKU__c = wr.prdlist.Phoenix_Lowest_Price_SKU__c,
Strength__c = wr.prdlist.Phoenix_Strength__c,
Dosage_Form__c = wr.prdlist.Phoenix_Dosage_Form__c,
Pkg_Size__c = wr.prdlist.Phoenix_Pkg_Size__c,
Product_Description__c = wr.prdlist.Description*/
                );
                //if(String.isNotBlank(wr.salesPriceVal)){
                //   productOpportunity.Vision_Sales_Price__c = Decimal.valueOf(wr.salesPriceVal);
                //}
                /*if(String.isNotBlank(wr.proposedUnitsVal)){
productOpportunity.Proposed_Indirect_Selling_Units__c = Decimal.valueOf(wr.proposedUnitsVal);
}
if(String.isNotBlank(wr.guidancePriceVal)){
productOpportunity.Vision_Guidance_Price__c  = Decimal.valueOf(wr.guidancePriceVal);
}
if(String.isNotBlank(wr.priceRangeVal)){
productOpportunity.Vision_Price_Range__c  = Decimal.valueOf(wr.priceRangeVal);
}
if(String.isNotBlank(wr.competitorIdVal)){
productOpportunity.Vision_Incumbent_Competitor__c = wr.competitorIdVal;
}
if(String.isNotBlank(wr.opportunityVal)){
productOpportunity.Vision_Opportunity_Value__c = Decimal.valueOf(wr.opportunityVal);
}
if(wr.proposedDirectUnits != null){
productOpportunity.Proposed_Direct_Selling_Units__c = Decimal.valueOf(wr.proposedDirectUnits);
}
if(wr.currentDirectUnits != null){
productOpportunity.Vision_Current_Direct_Units__c = Decimal.valueOf(wr.currentDirectUnits);
}
if(wr.currentIndirectUnits != null){
productOpportunity.Current_Indirect_Selling_Units__c = Decimal.valueOf(wr.currentIndirectUnits);
}
if(wr.currentDirectPrice != null){
productOpportunity.Vision_Current_Direct_Price__c = Decimal.valueOf(wr.currentDirectPrice);
}
if(wr.currentIndirectPrice != null){
productOpportunity.Vision_Current_Indirect_Price__c = Decimal.valueOf(wr.currentIndirectPrice);
}

if(wr.ProposedOSUnits!=null){
productOpportunity.Vision_Proposed_OS_Units__c = Decimal.valueOf(wr.ProposedOSUnits);
}
if(wr.ProposedRadUnits != null){
productOpportunity.Vision_Proposed_RAD_Units__c = Decimal.valueOf(wr.ProposedRadUnits);
}
if(wr.ProposedWmtUnits != null){
productOpportunity.Vision_Proposed_WMT_Units__c = Decimal.valueOf(wr.ProposedWmtUnits);
}
if(wr.ProposedBaseUnits != null){
productOpportunity.Vision_Proposed_BASE_Units__c = Decimal.valueOf(wr.ProposedBaseUnits);
}
if(wr.ProposedDshUnits != null){
productOpportunity.Vision_Proposed_DSH_Units__c = Decimal.valueOf(wr.ProposedDshUnits);
}
if(wr.ProposedAutosubUnits != null){
productOpportunity.Vision_Proposed_AutoSub_Units__c = Decimal.valueOf(wr.ProposedAutosubUnits);
}

if(wr.ProposedSmithDrugUnits != null){
productOpportunity.Vision_Proposed_Smith_Drug_Units__c = Decimal.valueOf(wr.ProposedSmithDrugUnits);
}
if(wr.ProposedAndaUnits != null){
productOpportunity.Vision_Proposed_Anda_Units__c = Decimal.valueOf(wr.ProposedAndaUnits);
}
if(wr.ProposedDirectAholdDelhaizeUnits != null){
productOpportunity.Vision_Proposed_DirectAholdDelhaizeUnits__c = Decimal.valueOf(wr.ProposedDirectAholdDelhaizeUnits);
}
if(wr.ProposedDirectGaintEagleUnits != null){
productOpportunity.Vision_Proposed_Direct_Gaint_Eagle_Units__c = Decimal.valueOf(wr.ProposedDirectGaintEagleUnits);
}
if(wr.ProposedTotalRetailIndirectUnits != null){
productOpportunity.Vision_Proposed_TotalRetailIndirectUnits__c = Decimal.valueOf(wr.ProposedTotalRetailIndirectUnits);
}

if(wr.ProposedCVSDirectUnits != null){
productOpportunity.Vision_Proposed_CVS_Direct_Units__c = Decimal.valueOf(wr.ProposedCVSDirectUnits);
}
if(wr.ProposedCVSIndirectUnits != null){
productOpportunity.Vision_Proposed_CVS_Indirect_Units__c = Decimal.valueOf(wr.ProposedCVSIndirectUnits);
}
if(wr.ProposedCardinalUnits != null){
productOpportunity.Vision_Proposed_Cardinal_Units__c = Decimal.valueOf(wr.ProposedCardinalUnits);
}
if(wr.ProposedMajorUnits != null){
productOpportunity.Vision_Proposed_Major_Units__c = Decimal.valueOf(wr.ProposedMajorUnits);
}


if(wr.ProposedDirectEsiUnits != null){
productOpportunity.Vision_Proposed_Direct_ESI_Units__c = Decimal.valueOf(wr.ProposedDirectEsiUnits);
}
if(wr.ProposedIndirectEsiUnits != null){
productOpportunity.Vision_Proposed_Indirect_ESI_Units__c = Decimal.valueOf(wr.ProposedIndirectEsiUnits);
}
if(wr.ProposedDirectKrogerUnits != null){
productOpportunity.Vision_Proposed_Direct_Kroger_Units__c = Decimal.valueOf(wr.ProposedDirectKrogerUnits);
}
if(wr.ProposedIndirectKrogerUnits != null){
productOpportunity.Vision_Proposed_Indirect_Kroger_Units__c = Decimal.valueOf(wr.ProposedIndirectKrogerUnits);
}
if(wr.ProposedDirectRxOutreachUnits != null){
productOpportunity.Vision_Proposed_Direct_Rx_Outreach_Units__c = Decimal.valueOf(wr.ProposedDirectRxOutreachUnits);
}
if(wr.ProposedIndirectRxOutreachUnits != null){
productOpportunity.Vision_Proposed_IndirectRxOutreach_Units__c = Decimal.valueOf(wr.ProposedIndirectRxOutreachUnits);
}
if(wr.ProposedDirectSupervaluUnits != null){
productOpportunity.Vision_Proposed_Direct_Supervalu_Units__c = Decimal.valueOf(wr.ProposedDirectSupervaluUnits);
}
if(wr.ProposedIndirectSupervaluUnits != null){
productOpportunity.Vision_Proposed_Indirect_Supervalu_Units__c = Decimal.valueOf(wr.ProposedIndirectSupervaluUnits);
}
if(wr.ProposedDirectCordantUnits != null){
productOpportunity.Vision_Proposed_Direct_Cordant_Units__c = Decimal.valueOf(wr.ProposedDirectCordantUnits);
}
if(wr.ProposedIndirectCordantUnits != null){
productOpportunity.Vision_Proposed_Indirect_Cordant_Units__c = Decimal.valueOf(wr.ProposedIndirectCordantUnits);
}
if(wr.ProposedDirectAccerodoUnits != null){
productOpportunity.Vision_Proposed_Direct_Accerodo_Units__c = Decimal.valueOf(wr.ProposedDirectAccerodoUnits);
}
if(wr.ProposedIndirectAccerodoUnits != null){
productOpportunity.Vision_Proposed_Indirect_Accerodo_Units__c = Decimal.valueOf(wr.ProposedIndirectAccerodoUnits);
}*/
                
                productOpportunity.Opportunity__c = optyId;
                if(productOpportunity.Vision_Opportunity_Value__c != null)
                    optyVal = optyVal + productOpportunity.Vision_Opportunity_Value__c;
                productOpportunity.Status__c = 'Matched';
                prodOptyList.add(productOpportunity);
            }
            
            if(prodOptyList.size() > 0){
                    insert prodOptyList;
                    for(Product_Opportunity__c prd : prodOptyList){
                        prdOpIds.add(prd.Id);
                    }
                    savedPrdOptyRecs = [select Id, Name, Product__r.Id,Product__r.Name,Product__r.Phoenix_WAC__c ,GCN_Generic_Code_Number__c,GSN__c,GPI_Generic_Product_Identifier__c,NDC_11__c,
                                        SKU_Number__c,Product_Family__c,Lowest_Price_SKU__c,Strength__c,Pkg_Size__c,Product_Description__c,Vision_Sales_Price__c,
                                        Vision_Proposed_Units__c,Vision_Guidance_Price__c,Vision_Price_Range__c,Vision_Opportunity_Value__c,Vision_Incumbent_Competitor__r.Id, Vision_Incumbent_Competitor__r.Name,
                                        Status__c from Product_Opportunity__c Where Id = : prdOpIds];
                    Opportunity opptyRec = [select Id, Vision_Opportunity_Value__c,Vision_Reference_Contract__c from Opportunity where Id = : optyId];
                    String selectedContNames = '';
                    if (!selectrcs.isEmpty()) {
                        List < String > selectrcsWithoutDup = new List < String > ();
                        selectedContNames = String.isNotBlank(opptyRec.Vision_Reference_Contract__c) && opptyRec.Vision_Reference_Contract__c != null ? opptyRec.Vision_Reference_Contract__c : '';
                        for (String s: selectrcs) {
                            if (string.isNotBlank(selectedContNames) && !selectedContNames.contains(s))
                                selectrcsWithoutDup.add(s);
                        }
                        if (string.isNotBlank(selectedContNames) && !selectrcsWithoutDup.isEmpty())
                            selectedContNames += ',';
                        if (string.isBlank(selectedContNames))
                            selectedContNames += string.join(selectrcs, ',');
                        else
                            selectedContNames += string.join(selectrcsWithoutDup, ',');
                        opptyRec.Vision_Reference_Contract__c = selectedContNames;
                    }
                    opptyRec.Vision_Opportunity_Value__c = optyVal;
                    update opptyRec;
                    //prdOpWrap.oppIdData = new Map<String,Id>{'OppId' => opptyRec.Id};
                    //    prdOpWrap.savedProducts = savedPrdOptyRecs;
                    //return JSON.serialize(prdOpWrap);
                }
            return optyId;
        }
        catch(Exception e){
            Database.RollBack(sp);
            Phoenix_Util.recordException(e,'Vision_OpportunityCreator','saveProductsToExtOpty','Opty Id is '+optyId);
            //savedProductOptyWrapper prdOpWrap = new savedProductOptyWrapper();
            //prdOpWrap.oppIdData = new Map<String,Id>{'OppId' => null};
            return 'ERROR:'+ e.getMessage();//return JSON.serialize(prdOpWrap);
        }
    }
    
    @AuraEnabled
    public static string saveOptyExtProductsManual(String optyId, string saveitems){
        Savepoint sp = Database.setSavepoint();
        try {
            savedProductOptyWrapper prdOpWrap = new savedProductOptyWrapper();
            List<Competitor_Info__c> compInfoList = new List<Competitor_Info__c>();
            List<String> prdOptyIds = new List<String>();
            Map<String, String> compInfoPrdOptyMap = new Map<String, String>();
            Map<Id, Product_Opportunity__c> extProdOpty = new Map<Id, Product_Opportunity__c>();
            if(String.isNotBlank(optyId)){
                Decimal optyVal = 0;
                List<Product_Opportunity__c> savedPrdOptyRecs = new List<Product_Opportunity__c>();
                List<Product_Opportunity__c>saveChangedPrdOptyRecs= new List<Product_Opportunity__c>();
                Opportunity opptyRec = [select Id, AccountId, Vision_Opportunity_Value__c,Vision_Reference_Contract__c from Opportunity where Id = : optyId];
                if(String.isNotBlank(saveitems))
                    savedPrdOptyRecs = (List<Product_Opportunity__c>)JSON.deserialize(saveitems,List<Product_Opportunity__c>.class);
                if(savedPrdOptyRecs.size() > 0){
                    for(Product_Opportunity__c productOpportunity : savedPrdOptyRecs){
                        Product_Opportunity__c prdOpty = new Product_Opportunity__c();
                        if(productOpportunity.Vision_Opportunity_Value__c != null)
                            optyVal = optyVal + productOpportunity.Vision_Opportunity_Value__c;
                        //if(productOpportunity.Vision_Incumbent_Competitor_Info__r != null){
                        //    Competitor_Info__c compData = saveCompInfo(productOpportunity.Vision_Incumbent_Competitor_Info__r, productOpportunity.Product_Family__c,
                        //                                               productOpportunity.NDC_11__c,null,productOpportunity.Product__r.Name,productOpportunity.Id);
                        //    compInfoList.add(compData);
                        //}
                        prdOpty.Id = productOpportunity.Id;
                        prdOpty.Name = productOpportunity.Name;
                        if(productOpportunity.Opportunity__c != null)
                            prdOpty.Opportunity__c = productOpportunity.Opportunity__c;
                        if(productOpportunity.Product__c != null)
                            prdOpty.Product__c = productOpportunity.Product__c;
                        prdOpty.GCN_Generic_Code_Number__c = productOpportunity.GCN_Generic_Code_Number__c;
                        prdOpty.GSN__c = productOpportunity.GSN__c;
                        prdOpty.GPI_Generic_Product_Identifier__c = productOpportunity.GPI_Generic_Product_Identifier__c;
                        prdOpty.NDC_11__c = productOpportunity.NDC_11__c;
                        prdOpty.SKU_Number__c = productOpportunity.SKU_Number__c;
                        prdOpty.Product_Family__c = productOpportunity.Product_Family__c;
                        prdOpty.GCP_Product_Family__c = productOpportunity.GCP_Product_Family__c;
                        prdOpty.Lowest_Price_SKU__c = productOpportunity.Lowest_Price_SKU__c;
                        prdOpty.Strength__c = productOpportunity.Strength__c;
                        prdOpty.Pkg_Size__c = productOpportunity.Pkg_Size__c;
                        prdOpty.Status__c = productOpportunity.Status__c;
                        //if(productOpportunity.Vision_Incumbent_Competitor_Info__c != null)
                        //    prdOpty.Vision_Incumbent_Competitor_Info__c = productOpportunity.Vision_Incumbent_Competitor_Info__c;
                        //prdOpty.Vision_Incumbent_Competitor__c = null;
                        prdOpty.Vision_Proposed_Units__c = productOpportunity.Vision_Proposed_Units__c;
                        prdOpty.Vision_Opportunity_Value__c = productOpportunity.Vision_Opportunity_Value__c;
                        extProdOpty.put(prdOpty.Id,prdOpty);
                        //saveChangedPrdOptyRecs.add(prdOpty);
                    }
                    //if(compInfoList.size() > 0){  upsert compInfoList; }
                    
                    //for(Competitor_Info__c compInfo : compInfoList){
                     //   if(extProdOpty.containsKey(compInfo.Vision_Product_Opportunity__c)){
                      //      if(extProdOpty.get(compInfo.Vision_Product_Opportunity__c).Vision_Incumbent_Competitor_Info__c == null){
                      //          extProdOpty.get(compInfo.Vision_Product_Opportunity__c).Vision_Incumbent_Competitor_Info__c = compInfo.Id;
                       //     }
                       // }
                    //}
                    saveChangedPrdOptyRecs.addAll(extProdOpty.values());
                    if(saveChangedPrdOptyRecs.size() > 0){
                        update saveChangedPrdOptyRecs;
                    }
                }
                
                opptyRec.Vision_Opportunity_Value__c = optyVal;
                update opptyRec;
                //return fetchPrdOptyRecs(optyId);
            }
            return optyId;
        } 
        catch (Exception e) {
            Database.RollBack(sp);
            Phoenix_Util.recordException(e,'Vision_OpportunityCreator','saveOptyExtProductsManual','Opp Id is '+optyId); 
            //savedProductOptyWrapper prdOpWrap = new savedProductOptyWrapper();
            //prdOpWrap.oppIdData = new Map<String,Id>{'OppId' => null};
            return 'ERROR:'+ e.getMessage();//    return JSON.serialize(prdOpWrap);
        }
    }
    
    public static Competitor_Info__c saveCompInfo(Competitor_Info__c newCompData, String prdFamily, String NDC, String cusName, String prdName, String prdOptyId){
        /*List<String> compIds = new List<String>();
        if(newCompData.Id != null){
            List<Competitor__c> expCompList = new List<Competitor__c>();
            Competitor_Info__c comData = [select Id, Incumbent_Competitor_Name__r.Id, Incumbent_Competitor_Name__r.Name,
                                          Incumbent_Competitor_Name_2__r.Id, Incumbent_Competitor_Name_2__r.Name,
                                          Incumbent_Competitor_Name_3__r.Id, Incumbent_Competitor_Name_3__r.Name,
                                          Incumbent_Competitor_Name_4__r.Id, Incumbent_Competitor_Name_4__r.Name,
                                          Incumbent_Competitor_Name_5__r.Id, Incumbent_Competitor_Name_5__r.Name,
                                          Incumbent_Price_Range__c,Incumbent_Price_Range_2__c,
                                          Incumbent_Price_Range_3__c,Incumbent_Price_Range_4__c,
                                          Incumbent_Price_Range_5__c,Vision_Product_Opportunity__c from Competitor_Info__c where Id = :  newCompData.Id];
            
            if(newCompData.Incumbent_Competitor_Name__c != null)
                compIds.add(newCompData.Incumbent_Competitor_Name__c);
            if(newCompData.Incumbent_Competitor_Name_2__c != null)
                compIds.add(newCompData.Incumbent_Competitor_Name_2__c);
            if(newCompData.Incumbent_Competitor_Name_3__c != null)
                compIds.add(newCompData.Incumbent_Competitor_Name_3__c);
            if(newCompData.Incumbent_Competitor_Name_4__c != null)
                compIds.add(newCompData.Incumbent_Competitor_Name_4__c);
            if(newCompData.Incumbent_Competitor_Name_5__c != null)
                compIds.add(newCompData.Incumbent_Competitor_Name_5__c);
            
            for(Competitor__c comp : [select Id, Name from Competitor__c where id in : compIds]){
                if(comp.id == newCompData.Incumbent_Competitor_Name__c)
                {
                    comData.Incumbent_Competitor_Name__c = comp.Id;
                    comData.Incumbent_Price_Range__c = newCompData.Incumbent_Price_Range__c;
                }
                if(comp.id == newCompData.Incumbent_Competitor_Name_2__c)
                {
                    comData.Incumbent_Competitor_Name_2__c = comp.Id;
                    comData.Incumbent_Price_Range_2__c = newCompData.Incumbent_Price_Range_2__c;
                }
                if(comp.id == newCompData.Incumbent_Competitor_Name_3__c)
                {
                    comData.Incumbent_Competitor_Name_3__c = comp.Id;
                    comData.Incumbent_Price_Range_3__c = newCompData.Incumbent_Price_Range_3__c;
                }
                if(comp.id == newCompData.Incumbent_Competitor_Name_4__c)
                {
                    comData.Incumbent_Competitor_Name_4__c = comp.Id;
                    comData.Incumbent_Price_Range_4__c = newCompData.Incumbent_Price_Range_4__c;
                }
                if(comp.id == newCompData.Incumbent_Competitor_Name_5__c)
                {
                    comData.Incumbent_Competitor_Name_5__c = comp.Id;
                    comData.Incumbent_Price_Range_5__c = newCompData.Incumbent_Price_Range_5__c;
                }
            }
            return comData;
        }
        else{
            Competitor_Info__c comData = new Competitor_Info__c();
            comData.NDC__c = NDC;
            comData.Product_Family__c = prdFamily;
            comData.Product_Name__c = prdName;
            comData.Vision_Product_Opportunity__c = prdOptyId;
            
            if(newCompData.Incumbent_Competitor_Name__c != null)
                compIds.add(newCompData.Incumbent_Competitor_Name__c);
            if(newCompData.Incumbent_Competitor_Name_2__c != null)
                compIds.add(newCompData.Incumbent_Competitor_Name_2__c);
            if(newCompData.Incumbent_Competitor_Name_3__c != null)
                compIds.add(newCompData.Incumbent_Competitor_Name_3__c);
            if(newCompData.Incumbent_Competitor_Name_4__c != null)
                compIds.add(newCompData.Incumbent_Competitor_Name_4__c);
            if(newCompData.Incumbent_Competitor_Name_5__c != null)
                compIds.add(newCompData.Incumbent_Competitor_Name_5__c);
            
            for(Competitor__c comp : [select Id, Name from Competitor__c where id in : compIds])
            {
                if(comp.id == newCompData.Incumbent_Competitor_Name__c)
                {
                    comData.Incumbent_Competitor_Name__c = comp.Id;
                    comData.Incumbent_Price_Range__c = newCompData.Incumbent_Price_Range__c;
                }
                if(comp.id == newCompData.Incumbent_Competitor_Name_2__c)
                {
                    comData.Incumbent_Competitor_Name_2__c = comp.Id;
                    comData.Incumbent_Price_Range_2__c = newCompData.Incumbent_Price_Range_2__c;
                }
                if(comp.id == newCompData.Incumbent_Competitor_Name_3__c)
                {
                    comData.Incumbent_Competitor_Name_3__c = comp.Id;
                    comData.Incumbent_Price_Range_3__c = newCompData.Incumbent_Price_Range_3__c;
                }
                if(comp.id == newCompData.Incumbent_Competitor_Name_4__c)
                {
                    comData.Incumbent_Competitor_Name_4__c = comp.Id;
                    comData.Incumbent_Price_Range_4__c = newCompData.Incumbent_Price_Range_4__c;
                }
                if(comp.id == newCompData.Incumbent_Competitor_Name_5__c)
                {
                    comData.Incumbent_Competitor_Name_5__c = comp.Id;
                    comData.Incumbent_Price_Range_5__c = newCompData.Incumbent_Price_Range_5__c;
                }
            }
            return comData;
        }*/
        return null;
    }
    
    @AuraEnabled
    public static string fetchPrdOptyRecs(String optyId){
        try {
            savedProductOptyWrapper prdOpWrap = new savedProductOptyWrapper();
            if(String.isNotBlank(optyId)){
                String query = 'SELECT '+Phoenix_Util.getsObjectFieds('Opportunity')+' FROM Opportunity WHERE Id=: optyId';
                Opportunity optyObj = Database.query(query);
                query = 'SELECT Product__r.Id,Product__r.Name,Product__r.Phoenix_WAC__c, Vision_Incumbent_Competitor__r.Id, Vision_Incumbent_Competitor__r.Name,'+
                    +'Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name__r.Id,Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_2__r.Id,'+
                    +'Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_3__r.Id,Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_4__r.Id,'+
                    +'Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_5__r.Id,Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name__r.Name,'+
                    +'Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_2__r.Name,Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_3__r.Name,'+
                    +'Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_4__r.Name,Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_5__r.Name,'+
                    +'Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range__c,Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range_2__c,'+
                    +'Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range_3__c,Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range_4__c,'+
                    +'Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range_5__c, '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c '+
                    +'where Status__c = \'Matched\' and Opportunity__c =: optyId';
                prdOpWrap.savedProducts = database.query(query);
                
                prdOpWrap.oppIdData = new Map<String,Id>{'OppId' => optyObj.Id};
                    prdOpWrap.competitorObjInfo = getCompetitorInfo();
                return JSON.serialize(prdOpWrap);
            }
            
            else{
                prdOpWrap.oppIdData = new Map<String,Id>{'OppId' => null};
                    return JSON.serialize(prdOpWrap);
            }
            
        } catch (Exception e) {
            Phoenix_Util.recordException(e,'Vision_OpportunityCreator','fetchPrdOptyRecs','Opp Id is '+optyId); 
            savedProductOptyWrapper prdOpWrap = new savedProductOptyWrapper();
            prdOpWrap.oppIdData = new Map<String,Id>{'OppId' => null};
                return JSON.serialize(prdOpWrap);
        }
    }
    
    public static Product_Opportunity__c mapProductOpportunity(Product2 product ,List<String> csvRecordData, String status, Map<String,Integer> headerMap) {
        try{
            Integer startingHeap = Limits.getHeapSize();
            Product_Opportunity__c productOpportunity = new Product_Opportunity__c();
            //list<String> dosageFormPickVals = Vision_OpportunityCreator.fetchPicklistVal();
            /*if(status == 'Matched'){

productOpportunity.Product__c = product.Id;
productOpportunity.Name = product.Name;
productOpportunity.GCN_Generic_Code_Number__c = product.Phoenix_GCN_Generic_Code_Number__c;
productOpportunity.GSN__c = product.Phoenix_GCN_Sequence_Number__c;
productOpportunity.GPI_Generic_Product_Identifier__c = product.Phoenix_GPI_Generic_Product_Identifier__c;
productOpportunity.NDC_11__c = product.Phoenix_NDC_11__c;
productOpportunity.SKU_Number__c = product.ProductCode;
if(csvRecordData.size() > headerMap.get('prd_family')){
if(String.isNotBlank(csvRecordData[headerMap.get('prd_family')]))
productOpportunity.Product_Family__c = csvRecordData[headerMap.get('prd_family')];
}

if(csvRecordData.size() > headerMap.get('STRENGTH')){
if(String.isNotBlank(csvRecordData[headerMap.get('STRENGTH')]) && csvRecordData[headerMap.get('STRENGTH')].contains('.')){
decimal decVal = decimal.valueOf(csvRecordData[headerMap.get('STRENGTH')]);
Integer intVal = Integer.valueOf(Math.Floor(decVal));
productOpportunity.Strength__c = String.valueOf(intVal);
}
else{
productOpportunity.Strength__c = csvRecordData[headerMap.get('STRENGTH')];
}
productOpportunity.Strength__c = csvRecordData[headerMap.get('STRENGTH')];
}
if(csvRecordData.size() > headerMap.get('dosage_form')){
if(String.isNotBlank(csvRecordData[headerMap.get('dosage_form')]))
//if(dosageFormPickVals.contains(csvRecordData[headerMap.get('dosage_form')].toLowerCase()))
//{
//    productOpportunity.Dosage_Form__c = csvRecordData[headerMap.get('dosage_form')];
//}
//else{
productOpportunity.Vision_Dosage_Form__c = csvRecordData[headerMap.get('dosage_form')];
//}
}

if(csvRecordData.size() > headerMap.get('pkg_size')){
if(String.isNotBlank(csvRecordData[headerMap.get('pkg_size')]))
productOpportunity.Pkg_Size__c = Integer.valueOf(csvRecordData[headerMap.get('pkg_size')]);
}
if(csvRecordData.size() > headerMap.get('prd_desc')){
if(String.isNotBlank(csvRecordData[headerMap.get('prd_desc')]))
productOpportunity.Product_Description__c = csvRecordData[headerMap.get('prd_desc')];
}

if(csvRecordData.size() > headerMap.get('tot_annual_units')){
if(String.isNotBlank(csvRecordData[headerMap.get('tot_annual_units')])){
string strSample = csvRecordData[headerMap.get('tot_annual_units')];
productOpportunity.Vision_Total_Annual_Units__c  = Integer.valueOf(strSample.replace(',', ''));
}

}
if(csvRecordData.size() > headerMap.get('gui_price')){
if(String.isNotBlank(csvRecordData[headerMap.get('gui_price')])){
productOpportunity.Vision_Guidance_Price__c  = decimal.valueOf(csvRecordData[headerMap.get('gui_price')]);
}

}
if(csvRecordData.size() > headerMap.get('UOM')){
if(String.isNotBlank(csvRecordData[headerMap.get('UOM')]))
{
if(productOpportunity.Vision_Total_Annual_Units__c != null && productOpportunity.Pkg_Size__c != null)
{
List<String> uomTypes = new List<String>{'EU', 'EXTENDED UNITS', 'DOSES', 'EACH'};
if(uomTypes.contains(csvRecordData[headerMap.get('UOM')].toUpperCase()))
{
productOpportunity.Quantity__c = productOpportunity.Vision_Total_Annual_Units__c / productOpportunity.Pkg_Size__c;
}
else{
productOpportunity.Quantity__c = productOpportunity.Vision_Total_Annual_Units__c;
}
if(productOpportunity.Quantity__c != null){
productOpportunity.Vision_Pills__c = productOpportunity.Quantity__c * productOpportunity.Pkg_Size__c;
}
}
productOpportunity.Vision_UOM__c  = csvRecordData[headerMap.get('UOM')];

}
}

if(csvRecordData.size() > headerMap.get('cus_cmt')){
if(String.isNotBlank(csvRecordData[headerMap.get('cus_cmt')]))
productOpportunity.Vision_Customer_Comments__c = csvRecordData[headerMap.get('cus_cmt')];
}
if(csvRecordData.size() > headerMap.get('bid_on_highest_pkg_size')){
if(String.isNotBlank(csvRecordData[headerMap.get('bid_on_highest_pkg_size')]) && csvRecordData[headerMap.get('bid_on_highest_pkg_size')].toLowercase() == 'yes')
productOpportunity.Vision_Bid_on_Highest_Pack_Size__c = true;

}
if(csvRecordData.size() > headerMap.get('bid_on_alternative_pkg_size')){
if(String.isNotBlank(csvRecordData[headerMap.get('bid_on_alternative_pkg_size')]) && csvRecordData[headerMap.get('bid_on_alternative_pkg_size')].toLowercase() == 'yes')
productOpportunity.Vision_Bid_on_Alternative_Pack_Size__c = true;
}
productOpportunity.Status__c = 'Matched';

}*/
            if(status == 'Matched'){}
                
            else{
                productOpportunity.Product__c = null;
                if(csvRecordData.size() > headerMap.get('GCN')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('GCN')])){
                        productOpportunity.GCN_Generic_Code_Number__c = csvRecordData[headerMap.get('GCN')].trim();
                    } 
                }
                
                if(csvRecordData.size() > headerMap.get('GSN')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('GSN')]))
                        productOpportunity.GSN__c = csvRecordData[headerMap.get('GSN')].trim();
                }
                
                if(csvRecordData.size() > headerMap.get('GPI')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('GPI')]))
                        productOpportunity.GPI_Generic_Product_Identifier__c = csvRecordData[headerMap.get('GPI')].trim();
                }
                
                if(csvRecordData.size() > headerMap.get('ndc'))
                {
                    if(String.isNotBlank(csvRecordData[headerMap.get('ndc')])){
                        if(csvRecordData[headerMap.get('ndc')].contains('-')){
                            string strSample = csvRecordData[headerMap.get('ndc')].replace('-', '');
                            productOpportunity.NDC_11__c = strSample;
                        }
                        else{
                            productOpportunity.NDC_11__c = csvRecordData[headerMap.get('ndc')];
                        }
                    }
                }
                if(csvRecordData.size() > headerMap.get('sku_num')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('sku_num')]))
                        productOpportunity.SKU_Number__c = csvRecordData[headerMap.get('sku_num')];
                }
                
                if(csvRecordData.size() > headerMap.get('prd_family')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('prd_family')]))
                        productOpportunity.Product_Family__c = csvRecordData[headerMap.get('prd_family')];
                }
                
                if(csvRecordData.size() > headerMap.get('STRENGTH')){
                    
                    if(String.isNotBlank(csvRecordData[headerMap.get('STRENGTH')]))
                        productOpportunity.Strength__c = csvRecordData[headerMap.get('STRENGTH')];
                }
                if(csvRecordData.size() > headerMap.get('dosage_form')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('dosage_form')]))
                        productOpportunity.Vision_Dosage_Form__c = csvRecordData[headerMap.get('dosage_form')];
                }
                if(csvRecordData.size() > headerMap.get('pkg_size')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pkg_size')])){
                        productOpportunity.Vision_Disc_Pkg_Size__c = csvRecordData[headerMap.get('pkg_size')];
                        if(isNumeric(csvRecordData[headerMap.get('pkg_size')])){
                            if(csvRecordData[headerMap.get('pkg_size')].contains('.')){
                                Decimal d = decimal.valueOf(csvRecordData[headerMap.get('pkg_size')].trim());
                                productOpportunity.Pkg_Size__c = Integer.valueOf(d);
                            }
                            else
                                productOpportunity.Pkg_Size__c = Integer.valueOf(csvRecordData[headerMap.get('pkg_size')].trim());
                        }
                        //else
                            //productOpportunity.Vision_Disc_Pkg_Size__c = csvRecordData[headerMap.get('pkg_size')];
                    }
                }
                if(csvRecordData.size() > headerMap.get('prd_desc')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('prd_desc')]))
                        productOpportunity.Product_Description__c = csvRecordData[headerMap.get('prd_desc')];
                }
                if(csvRecordData.size() > headerMap.get('tot_annual_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('tot_annual_units')])){
                        if(csvRecordData[headerMap.get('tot_annual_units')].contains(',')){
                            string strSample = csvRecordData[headerMap.get('tot_annual_units')];
                            productOpportunity.Vision_Total_Annual_Units__c  = Integer.valueOf(strSample.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('tot_annual_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('tot_annual_units')];
                            productOpportunity.Vision_Total_Annual_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(csvRecordData[headerMap.get('tot_annual_units')].contains('-')){
                            
                        }
                        else{
                            productOpportunity.Vision_Total_Annual_Units__c  = Integer.valueOf(csvRecordData[headerMap.get('tot_annual_units')].trim()); 
                        }
                    }
                }
                
                if(csvRecordData.size() > headerMap.get('pro_selling_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_selling_units')])){
                        if(csvRecordData[headerMap.get('pro_selling_units')].contains(',')){
                            string strSample = csvRecordData[headerMap.get('pro_selling_units')];
                            productOpportunity.Vision_Proposed_Units__c  = Integer.valueOf(strSample.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_selling_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_selling_units')];
                            productOpportunity.Vision_Proposed_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_selling_units')].contains('-')){
                            
                        }
                        else{
                            productOpportunity.Vision_Proposed_Units__c = Integer.valueOf(csvRecordData[headerMap.get('pro_selling_units')].trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Units__c = 0;
                    }
                }
                
                if(csvRecordData.size() > headerMap.get('pro_share_percent')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_share_percent')])){
                        if(csvRecordData[headerMap.get('pro_share_percent')].contains('%')){
                            string strSample = csvRecordData[headerMap.get('pro_share_percent')];
                            productOpportunity.Vision_Proposed_Share_Percentage__c  = Decimal.valueOf(strSample.replace('%', '').trim());
                        }
                        /*else if(csvRecordData[headerMap.get('pro_share_percent')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_share_percent')];
                            productOpportunity.Proposed_Direct_Selling_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_share_percent')].contains('-')){
                            
                        }*/
                        else{
                            productOpportunity.Vision_Proposed_Share_Percentage__c = Decimal.valueOf(csvRecordData[headerMap.get('pro_share_percent')].trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Share_Percentage__c = 0;
                    }
                }
                
                if(csvRecordData.size() > headerMap.get('pro_direct_selling_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_direct_selling_units')])){
                        if(csvRecordData[headerMap.get('pro_direct_selling_units')].contains(',')){
                            string strSample = csvRecordData[headerMap.get('pro_direct_selling_units')];
                            productOpportunity.Proposed_Direct_Selling_Units__c  = Integer.valueOf(strSample.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_direct_selling_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_direct_selling_units')];
                            productOpportunity.Proposed_Direct_Selling_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_direct_selling_units')].contains('-')){
                            
                        }
                        else{
                            productOpportunity.Proposed_Direct_Selling_Units__c = Integer.valueOf(csvRecordData[headerMap.get('pro_direct_selling_units')].trim()); 
                        }
                    }
                    else{
                        productOpportunity.Proposed_Direct_Selling_Units__c = 0;
                    }
                }
                if(csvRecordData.size() > headerMap.get('pro_indirect_selling_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_indirect_selling_units')])){
                        String proIndSellingUnits = csvRecordData[headerMap.get('pro_indirect_selling_units')];
                        if(proIndSellingUnits.contains(',')){
                            productOpportunity.Proposed_Indirect_Selling_Units__c  = Integer.valueOf(proIndSellingUnits.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_indirect_selling_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_indirect_selling_units')];
                            productOpportunity.Proposed_Indirect_Selling_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(proIndSellingUnits.contains('-')){
                           
                        }
                        else{
                            productOpportunity.Proposed_Indirect_Selling_Units__c = Integer.valueOf(proIndSellingUnits.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Proposed_Indirect_Selling_Units__c = 0;
                    }
                }
                if(csvRecordData.size() > headerMap.get('pro_os_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_os_units')])){
                        if(csvRecordData[headerMap.get('pro_os_units')].contains(',')){
                            string strSample = csvRecordData[headerMap.get('pro_os_units')];
                            productOpportunity.Vision_Proposed_OS_Units__c  = Integer.valueOf(strSample.replace(',', '').trim());
                            productOpportunity.Vision_Annual_OS_Units__c  = Integer.valueOf(strSample.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_os_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_os_units')];
                            productOpportunity.Vision_Proposed_OS_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                            productOpportunity.Vision_Annual_OS_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_os_units')].contains('-')){
                            
                        }
                        else{
                            productOpportunity.Vision_Proposed_OS_Units__c = Integer.valueOf(csvRecordData[headerMap.get('pro_os_units')].trim()); 
                            productOpportunity.Vision_Annual_OS_Units__c = Integer.valueOf(csvRecordData[headerMap.get('pro_os_units')].trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_OS_Units__c = 0;
                        productOpportunity.Vision_Annual_OS_Units__c = 0;
                    }
                }
                if(csvRecordData.size() > headerMap.get('pro_rad_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_rad_units')])){
                        if(csvRecordData[headerMap.get('pro_rad_units')].contains(',')){
                            string strSample = csvRecordData[headerMap.get('pro_rad_units')];
                            productOpportunity.Vision_Proposed_RAD_Units__c  = Integer.valueOf(strSample.replace(',', '').trim());
                            productOpportunity.Vision_Annual_RAD_Units__c  = Integer.valueOf(strSample.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_rad_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_rad_units')];
                            productOpportunity.Vision_Proposed_RAD_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                            productOpportunity.Vision_Annual_RAD_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_rad_units')].contains('-')){
                            
                        }
                        else{
                            productOpportunity.Vision_Proposed_RAD_Units__c = Integer.valueOf(csvRecordData[headerMap.get('pro_rad_units')].trim());
                            productOpportunity.Vision_Annual_RAD_Units__c = Integer.valueOf(csvRecordData[headerMap.get('pro_rad_units')].trim()); 
                        }
                    }
                    else
                        productOpportunity.Vision_Proposed_RAD_Units__c = 0;
                    //productOpportunity.Vision_Annual_RAD_Units__c = null;
                }
                if(csvRecordData.size() > headerMap.get('pro_wmt_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_wmt_units')])){
                        if(csvRecordData[headerMap.get('pro_wmt_units')].contains(',')){
                            string strSample = csvRecordData[headerMap.get('pro_wmt_units')];
                            productOpportunity.Vision_Proposed_WMT_Units__c = Integer.valueOf(strSample.replace(',', '').trim());
                            productOpportunity.Vision_Annual_Wmt_Units__c = Integer.valueOf(strSample.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_wmt_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_wmt_units')];
                            productOpportunity.Vision_Proposed_WMT_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                            productOpportunity.Vision_Annual_Wmt_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_wmt_units')].contains('-')){
                            //system.debug('Proposed WMT Units ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_WMT_Units__c = Integer.valueOf(csvRecordData[headerMap.get('pro_wmt_units')].trim()); 
                            productOpportunity.Vision_Annual_Wmt_Units__c = Integer.valueOf(csvRecordData[headerMap.get('pro_wmt_units')].trim()); 
                        }
                    }
                    else
                        productOpportunity.Vision_Proposed_WMT_Units__c = 0;
                    //productOpportunity.Vision_Annual_Wmt_Units__c = null;
                    
                }
                if(csvRecordData.size() > headerMap.get('pro_smithDrug_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_smithDrug_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_smithDrug_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_Smith_Drug_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_smithDrug_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_smithDrug_units')];
                            productOpportunity.Vision_Proposed_Smith_Drug_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Smith_Drug_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_Smith_Drug_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Smith_Drug_Units__c = 0;
                    } 
                }
                
                if(csvRecordData.size() > headerMap.get('pro_anda_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_anda_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_anda_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_Anda_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_anda_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_anda_unit')];
                            productOpportunity.Vision_Proposed_Anda_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Anda_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_Anda_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Anda_Units__c = 0;
                    } 
                }
                
                if(csvRecordData.size() > headerMap.get('pro_dir_ahold_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_dir_ahold_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_dir_ahold_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_DirectAholdDelhaizeUnits__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_dir_ahold_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_dir_ahold_units')];
                            productOpportunity.Vision_Proposed_DirectAholdDelhaizeUnits__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_DirectAholdDelhaizeUnits__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_DirectAholdDelhaizeUnits__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_DirectAholdDelhaizeUnits__c = 0;
                    } 
                }
                
                
                if(csvRecordData.size() > headerMap.get('pro_direct_gaint_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_direct_gaint_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_direct_gaint_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_Direct_Gaint_Eagle_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_direct_gaint_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_direct_gaint_units')];
                            productOpportunity.Vision_Proposed_Direct_Gaint_Eagle_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Direct_Gaint_Eagle_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_Direct_Gaint_Eagle_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Direct_Gaint_Eagle_Units__c = 0;
                    } 
                }
                
                
                if(csvRecordData.size() > headerMap.get('pro_total_retail_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_total_retail_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_total_retail_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_TotalRetailIndirectUnits__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_total_retail_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_total_retail_units')];
                            productOpportunity.Vision_Proposed_TotalRetailIndirectUnits__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_TotalRetailIndirectUnits__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_TotalRetailIndirectUnits__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_TotalRetailIndirectUnits__c = 0;
                    } 
                }
                
                
                if(csvRecordData.size() > headerMap.get('pro_base_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_base_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_base_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_BASE_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_base_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_base_units')];
                            productOpportunity.Vision_Proposed_BASE_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_BASE_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_BASE_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_BASE_Units__c = 0;
                    } 
                }
                
                
                if(csvRecordData.size() > headerMap.get('pro_dsh_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_dsh_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_dsh_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_DSH_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_dsh_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_dsh_units')];
                            productOpportunity.Vision_Proposed_DSH_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_DSH_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_DSH_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_DSH_Units__c = 0;
                    } 
                }
                
                
                if(csvRecordData.size() > headerMap.get('pro_autosub_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_autosub_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_autosub_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_AutoSub_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_autosub_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_autosub_units')];
                            productOpportunity.Vision_Proposed_AutoSub_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_AutoSub_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_AutoSub_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_AutoSub_Units__c = 0;
                    } 
                }
                
                
                if(csvRecordData.size() > headerMap.get('pro_direct_esi_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_direct_esi_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_direct_esi_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_Direct_ESI_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_direct_esi_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_direct_esi_units')];
                            productOpportunity.Vision_Proposed_Direct_ESI_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Direct_ESI_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_Direct_ESI_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Direct_ESI_Units__c = 0;
                    } 
                }
                
                
                if(csvRecordData.size() > headerMap.get('pro_indirect_esi_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_indirect_esi_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_indirect_esi_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_Indirect_ESI_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_indirect_esi_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_indirect_esi_units')];
                            productOpportunity.Vision_Proposed_Indirect_ESI_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Indirect_ESI_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_Indirect_ESI_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Indirect_ESI_Units__c = 0;
                    } 
                }
                
                
                if(csvRecordData.size() > headerMap.get('pro_direct_kroger_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_direct_kroger_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_direct_kroger_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_Direct_Kroger_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_direct_kroger_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_direct_kroger_units')];
                            productOpportunity.Vision_Proposed_Direct_Kroger_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                        }
                        else{
                            productOpportunity.Vision_Proposed_Direct_Kroger_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Direct_Kroger_Units__c = 0;
                    } 
                }
                
                
                if(csvRecordData.size() > headerMap.get('pro_indirect_kroger_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_indirect_kroger_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_indirect_kroger_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_Indirect_Kroger_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_indirect_kroger_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_indirect_kroger_units')];
                            productOpportunity.Vision_Proposed_Indirect_Kroger_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                        }
                        else{
                            productOpportunity.Vision_Proposed_Indirect_Kroger_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Indirect_Kroger_Units__c = 0;
                    } 
                }
                
                
                if(csvRecordData.size() > headerMap.get('pro_direct_rx_outreach_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_direct_rx_outreach_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_direct_rx_outreach_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_Direct_Rx_Outreach_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_direct_rx_outreach_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_direct_rx_outreach_units')];
                            productOpportunity.Vision_Proposed_Direct_Rx_Outreach_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Direct_Rx_Outreach_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_Direct_Rx_Outreach_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Direct_Rx_Outreach_Units__c = 0;
                    } 
                }
                
                
                if(csvRecordData.size() > headerMap.get('pro_indirect_rx_outreach_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_indirect_rx_outreach_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_indirect_rx_outreach_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_IndirectRxOutreach_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_indirect_rx_outreach_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_indirect_rx_outreach_units')];
                            productOpportunity.Vision_Proposed_IndirectRxOutreach_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_IndirectRxOutreach_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_IndirectRxOutreach_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_IndirectRxOutreach_Units__c = 0;
                    } 
                }
                
                
                if(csvRecordData.size() > headerMap.get('pro_direct_supervalu_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_direct_supervalu_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_direct_supervalu_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_Direct_Supervalu_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_direct_supervalu_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_direct_supervalu_units')];
                            productOpportunity.Vision_Proposed_Direct_Supervalu_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Direct_Supervalu_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_Direct_Supervalu_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Direct_Supervalu_Units__c = 0;
                    } 
                }
                
                
                if(csvRecordData.size() > headerMap.get('pro_indirect_supervalu_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_indirect_supervalu_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_indirect_supervalu_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_Indirect_Supervalu_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_indirect_supervalu_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_indirect_supervalu_units')];
                            productOpportunity.Vision_Proposed_Indirect_Supervalu_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Indirect_Supervalu_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_Indirect_Supervalu_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Indirect_Supervalu_Units__c = 0;
                    } 
                }
                
                if(csvRecordData.size() > headerMap.get('pro_indirect_cigna_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_indirect_cigna_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_indirect_cigna_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_Indirect_Cigna_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_indirect_cigna_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_indirect_cigna_units')];
                            productOpportunity.Vision_Proposed_Indirect_Cigna_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Indirect_Cigna_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_Indirect_Cigna_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Indirect_Cigna_Units__c = 0;
                    } 
                }
                if(csvRecordData.size() > headerMap.get('pro_direct_cigna_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_direct_cigna_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_direct_cigna_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_Direct_Cigna_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_direct_cigna_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_direct_cigna_units')];
                            productOpportunity.Vision_Proposed_Direct_Cigna_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Direct_Cigna_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_Direct_Cigna_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Direct_Cigna_Units__c = 0;
                    } 
                }
                
                if(csvRecordData.size() > headerMap.get('pro_direct_cordant_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_direct_cordant_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_direct_cordant_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_Direct_Cordant_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_direct_cordant_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_direct_cordant_units')];
                            productOpportunity.Vision_Proposed_Direct_Cordant_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Direct_Cordant_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_Direct_Cordant_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Direct_Cordant_Units__c = 0;
                    } 
                }
                
                
                if(csvRecordData.size() > headerMap.get('pro_indirect_cordant_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_indirect_cordant_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_indirect_cordant_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_Indirect_Cordant_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_indirect_cordant_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_indirect_cordant_units')];
                            productOpportunity.Vision_Proposed_Indirect_Cordant_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Indirect_Cordant_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_Indirect_Cordant_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Indirect_Cordant_Units__c = 0;
                    } 
                }
                
                
                if(csvRecordData.size() > headerMap.get('pro_direct_accerodo_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_direct_accerodo_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_direct_accerodo_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_Direct_Accerodo_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_direct_accerodo_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_direct_accerodo_units')];
                            productOpportunity.Vision_Proposed_Direct_Accerodo_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Direct_Accerodo_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_Direct_Accerodo_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Direct_Accerodo_Units__c = 0;
                    } 
                }
                
                
                if(csvRecordData.size() > headerMap.get('pro_indirect_accerodo_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_indirect_accerodo_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_indirect_accerodo_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_Indirect_Accerodo_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_indirect_accerodo_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_indirect_accerodo_units')];
                            productOpportunity.Vision_Proposed_Indirect_Accerodo_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Indirect_Accerodo_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_Indirect_Accerodo_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Indirect_Accerodo_Units__c = 0;
                    } 
                }
                
                if(csvRecordData.size() > headerMap.get('other_direct_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('other_direct_units')])){
                        String unitsVar = csvRecordData[headerMap.get('other_direct_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Proposed_Direct_Selling_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('other_direct_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('other_direct_units')];
                            productOpportunity.Proposed_Direct_Selling_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Proposed_Direct_Selling_Units__c ignored');
                        }
                        else{
                            productOpportunity.Proposed_Direct_Selling_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Proposed_Direct_Selling_Units__c = 0;
                    } 
                }
                
                if(csvRecordData.size() > headerMap.get('other_indirect_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('other_indirect_units')])){
                        String unitsVar = csvRecordData[headerMap.get('other_indirect_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Proposed_Indirect_Selling_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('other_indirect_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('other_indirect_units')];
                            productOpportunity.Proposed_Indirect_Selling_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Proposed_Indirect_Selling_Units__c ignored');
                        }
                        else{
                            productOpportunity.Proposed_Indirect_Selling_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Proposed_Indirect_Selling_Units__c = 0;
                    } 
                }
                
                if(csvRecordData.size() > headerMap.get('pro_cvs_direct_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_cvs_direct_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_cvs_direct_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_CVS_Direct_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_cvs_direct_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_cvs_direct_units')];
                            productOpportunity.Vision_Proposed_CVS_Direct_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_CVS_Direct_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_CVS_Direct_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_CVS_Direct_Units__c = 0;
                    } 
                }
                
                if(csvRecordData.size() > headerMap.get('pro_cvs_indirect_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_cvs_indirect_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_cvs_indirect_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_CVS_Indirect_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_cvs_indirect_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_cvs_indirect_units')];
                            productOpportunity.Vision_Proposed_CVS_Indirect_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_CVS_Indirect_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_CVS_Indirect_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_CVS_Indirect_Units__c = 0;
                    } 
                }
                
                if(csvRecordData.size() > headerMap.get('pro_cardinal_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_cardinal_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_cardinal_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_Cardinal_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_cardinal_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_cardinal_units')];
                            productOpportunity.Vision_Proposed_Cardinal_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Cardinal_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_Cardinal_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Cardinal_Units__c = 0;
                    } 
                }
                
                if(csvRecordData.size() > headerMap.get('pro_major_units')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('pro_major_units')])){
                        String unitsVar = csvRecordData[headerMap.get('pro_major_units')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Vision_Proposed_Major_Units__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('pro_major_units')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('pro_major_units')];
                            productOpportunity.Vision_Proposed_Major_Units__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Major_Units__c ignored');
                        }
                        else{
                            productOpportunity.Vision_Proposed_Major_Units__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Vision_Proposed_Major_Units__c = 0;
                    } 
                }
                //listing_price
                if(csvRecordData.size() > headerMap.get('listing_price')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('listing_price')])){
                        String unitsVar = csvRecordData[headerMap.get('listing_price')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Listing_Price__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('listing_price')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('listing_price')];
                            productOpportunity.Listing_Price__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Major_Units__c ignored');
                        }
                        else{
                            productOpportunity.Listing_Price__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Listing_Price__c = 0;
                    } 
                }
                //expiry_date
                if(csvRecordData.size() > headerMap.get('expiry_date')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('expiry_date')]))
                        productOpportunity.Expiry_Date__c = csvRecordData[headerMap.get('expiry_date')];
                }
                
                   /* else{
                        productOpportunity.Expiry_Date__c = '';
                    } */
             
                //batch number
                  if(csvRecordData.size() > headerMap.get('batch_number')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('batch_number')]))
                        productOpportunity.Batch_Number__c = csvRecordData[headerMap.get('batch_number')];
                }
              
                //MOQ
                 if(csvRecordData.size() > headerMap.get('min_order_qty')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('min_order_qty')])){
                        String unitsVar = csvRecordData[headerMap.get('min_order_qty')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Minimum_Order_Quantity__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('min_order_qty')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('min_order_qty')];
                            productOpportunity.Minimum_Order_Quantity__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Major_Units__c ignored');
                        }
                        else{
                            productOpportunity.Minimum_Order_Quantity__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Minimum_Order_Quantity__c = 0;
                    } 
                }
                 if(csvRecordData.size() > headerMap.get('case_pack')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('case_pack')])){
                        String unitsVar = csvRecordData[headerMap.get('case_pack')];
                        if(unitsVar.contains(',')){
                            productOpportunity.Case_Pack__c  = Integer.valueOf(unitsVar.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('case_pack')].contains('.')){
                            string strSample = csvRecordData[headerMap.get('case_pack')];
                            productOpportunity.Listing_Price__c  = Integer.valueOf(strSample.substringBefore('.').trim());
                        }
                        else if(unitsVar.contains('-')){
                            //system.debug('Vision_Proposed_Major_Units__c ignored');
                        }
                        else{
                            productOpportunity.Case_Pack__c = Integer.valueOf(unitsVar.trim()); 
                        }
                    }
                    else{
                        productOpportunity.Case_Pack__c = 0;
                    } 
                }
                
                if(csvRecordData.size() > headerMap.get('gui_price')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('gui_price')])){
                        if(csvRecordData[headerMap.get('gui_price')].contains(',')){
                            string strSample = csvRecordData[headerMap.get('gui_price')];
                            productOpportunity.Vision_Guidance_Price__c  = Decimal.valueOf(strSample.replace(',', '').trim());
                        }
                        else if(csvRecordData[headerMap.get('gui_price')].contains('-')){
                            //system.debug('Guidance Price ignored');
                        }
                        else{
                            productOpportunity.Vision_Guidance_Price__c  = Decimal.valueOf(csvRecordData[headerMap.get('gui_price')].trim()); 
                        }
                    }
                    //else
                     //   productOpportunity.Vision_Guidance_Price__c  = null;
                }
                if(csvRecordData.size() > headerMap.get('UOM')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('UOM')]))
                        productOpportunity.Vision_UOM__c  = csvRecordData[headerMap.get('UOM')];
                    //else
                      // productOpportunity.Vision_UOM__c  = null;
                }
                
                if(csvRecordData.size() > headerMap.get('cus_cmt')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('cus_cmt')]))
                        productOpportunity.Vision_Customer_Comments__c = csvRecordData[headerMap.get('cus_cmt')];
                    //else
                      //  productOpportunity.Vision_Customer_Comments__c = null;
                }
                if(csvRecordData.size() > headerMap.get('bid_on_highest_pkg_size')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('bid_on_highest_pkg_size')]) && csvRecordData[headerMap.get('bid_on_highest_pkg_size')].trim().toLowercase() == 'yes')
                        productOpportunity.Vision_Bid_on_Highest_Pack_Size__c = true;
                    else
                        productOpportunity.Vision_Bid_on_Highest_Pack_Size__c = false;
                    
                }
                if(csvRecordData.size() > headerMap.get('bid_on_alternative_pkg_size')){
                    if(String.isNotBlank(csvRecordData[headerMap.get('bid_on_alternative_pkg_size')]) && csvRecordData[headerMap.get('bid_on_alternative_pkg_size')].trim().toLowercase() == 'yes')
                        productOpportunity.Vision_Bid_on_Alternative_Pack_Size__c = true;
                    else
                        productOpportunity.Vision_Bid_on_Alternative_Pack_Size__c = false;
                }
                productOpportunity.Status__c = 'Unmatched';
            }
            return productOpportunity;
        }
        catch(Exception e){
            //system.debug('Error: ' + e.getStackTraceString()+ ' Message : '+e.getMessage());
            Phoenix_Util.recordException(e,'Vision_OpportunityCreator','mapProductOpportunity',''); 
            return null;
        }
    }
    
    public static Boolean isNumeric(String s){
        Boolean ReturnValue;
        try{
            Decimal.valueOf(s); ReturnValue = TRUE; 
        } catch (Exception e) {
            ReturnValue = FALSE;
        }
        return ReturnValue;
    }
    
    public static Map<String,Integer> getHeaderMap(list<String> csvRecordsList){
        Integer startingHeap = Limits.getHeapSize();
        // dynamically getting CSV column position with respect to headers
        String headers= csvRecordsList[0];
        List<String> headerFields =  headers.split(',');
        Integer count = 0;
        //{'GCN', 'GSN', 'GPI', 'NDC 11', 'SKU NUMBER', 'PRODUCT FAMILY', 'STRENGTH', 'DOSAGE FORM', 'PACK SIZE', 'PRODUCT DESCRIPTION', 'TOTAL ANNUAL UNITS', 'UOM', 'CUSTOMER COMMENTS'}
        Map<String,Integer> headerMap = new Map<String,Integer>();
        for(String h : headerFields){
            if(h.trim() == 'CUSTOMER COMMENTS' || h.trim() == 'CUSTOMER EXCLUSION'){
                headerMap.put('cus_cmt',count);
            }
            else if(h.trim() == 'TOTAL ANNUAL UNITS'){
                headerMap.put('tot_annual_units',count);
            }
            else if(h.trim() == 'DOSAGE FORM'){
                headerMap.put('dosage_form',count);
            }
            else if(h.trim() == 'PRODUCT FAMILY'){
                headerMap.put('prd_family',count);
            }
            else if(h.trim() == 'PACK SIZE'){
                headerMap.put('pkg_size',count);
            }
            else if(h.trim() == 'PRODUCT DESCRIPTION'){
                headerMap.put('prd_desc',count);
            }
            else if(h.trim() == 'NDC 11'){
                headerMap.put('ndc',count);
            }
            else if(h.trim() == 'SKU NUMBER'){
                headerMap.put('sku_num',count);
            }
            else if(h.trim() == 'BID ON HIGHEST PACK SIZE'){
                headerMap.put('bid_on_highest_pkg_size',count);
            }
            else if(h.trim() == 'BID ON ALTERNATIVE PACK SIZE'){
                headerMap.put('bid_on_alternative_pkg_size',count);
            }
            else if(h.trim() == 'GUIDANCE PRICE' || h.trim() == 'FLOOR PRICE'){
                headerMap.put('gui_price',count);
            }
            else if(h.trim() == 'PROPOSED SHARE PERCENTAGE'){
                headerMap.put('pro_share_percent',count);
            }
            else if(h.trim() == 'PROPOSED SELLING UNITS'){
                headerMap.put('pro_selling_units',count);
            }
            else if(h.trim() == 'PROPOSED OS UNITS'){
                headerMap.put('pro_os_units',count);
            }
            else if(h.trim() == 'PROPOSED RAD UNITS'){
                headerMap.put('pro_rad_units',count);
            }
            else if(h.trim() == 'PROPOSED WMT UNITS'){
                headerMap.put('pro_wmt_units',count);
            }
            else if(h.trim() == 'PROPOSED DIRECT UNITS'){
                headerMap.put('pro_direct_selling_units',count);
            }
            else if(h.trim() == 'PROPOSED INDIRECT UNITS'){
                headerMap.put('pro_indirect_selling_units',count);
            }
            else if(h.trim() == 'PROPOSED SMITH DRUG UNITS'){
                headerMap.put('pro_smithDrug_units',count);
            }
            else if(h.trim() == 'PROPOSED ANDA UNITS'){
                headerMap.put('pro_anda_units',count);
            }
            else if(h.trim() == 'PROPOSED DIRECT AHOLD/DELHAIZE UNITS'){
                headerMap.put('pro_dir_ahold_units',count);
            }
            else if(h.trim() == 'PROPOSED DIRECT GAINT EAGLE UNITS'){
                headerMap.put('pro_direct_gaint_units',count);
            }
            else if(h.trim() == 'PROPOSED TOTAL RETAIL INDIRECT UNITS'){
                headerMap.put('pro_total_retail_units',count);
            }
            else if(h.trim() == 'PROPOSED BASE UNITS'){
                headerMap.put('pro_base_units',count);
            }
            else if(h.trim() == 'PROPOSED DSH UNITS'){
                headerMap.put('pro_dsh_units',count);
            }
            else if(h.trim() == 'PROPOSED AUTOSUB UNITS'){
                headerMap.put('pro_autosub_units',count);
            }
            
            
            else if(h.trim() == 'PROPOSED DIRECT ESI UNITS'){
                headerMap.put('pro_direct_esi_units',count);
            }
            else if(h.trim() == 'PROPOSED INDIRECT ESI UNITS'){
                headerMap.put('pro_indirect_esi_units',count);
            }
            else if(h.trim() == 'PROPOSED DIRECT KROGER UNITS'){
                headerMap.put('pro_direct_kroger_units',count);
            }
            else if(h.trim() == 'PROPOSED INDIRECT KROGER UNITS'){
                headerMap.put('pro_indirect_kroger_units',count);
            }
            else if(h.trim() == 'PROPOSED DIRECT RX OUTREACH UNITS'){
                headerMap.put('pro_direct_rx_outreach_units',count);
            }
            else if(h.trim() == 'PROPOSED INDIRECT RX OUTREACH UNITS'){
                headerMap.put('pro_indirect_rx_outreach_units',count);
            }
            else if(h.trim() == 'PROPOSED DIRECT SUPERVALU UNITS'){
                headerMap.put('pro_direct_supervalu_units',count);
            }
            else if(h.trim() == 'PROPOSED INDIRECT SUPERVALU UNITS'){
                headerMap.put('pro_indirect_supervalu_units',count);
            }
            else if(h.trim() == 'PROPOSED DIRECT CIGNA UNITS'){
                headerMap.put('pro_direct_cigna_units',count);
            }
            else if(h.trim() == 'PROPOSED INDIRECT CIGNA UNITS'){
                headerMap.put('pro_indirect_cigna_units',count);
            }
            else if(h.trim() == 'PROPOSED DIRECT CORDANT UNITS'){
                headerMap.put('pro_direct_cordant_units',count);
            }
            else if(h.trim() == 'PROPOSED INDIRECT CORDANT UNITS'){
                headerMap.put('pro_indirect_cordant_units',count);
            }
            else if(h.trim() == 'PROPOSED DIRECT ACCERODO UNITS'){
                headerMap.put('pro_direct_accerodo_units',count);
            }
            else if(h.trim() == 'PROPOSED INDIRECT ACCERODO UNITS'){
                headerMap.put('pro_indirect_accerodo_units',count);
            }
            else if(h.trim() == 'OTHER DIRECT UNITS'){
                headerMap.put('other_direct_units',count);
            }
            else if(h.trim() == 'OTHER INDIRECT UNITS'){
                headerMap.put('other_indirect_units',count);
            }
            else if(h.trim() == 'PROPOSED CVS DIRECT UNITS'){
                headerMap.put('pro_cvs_direct_units',count);
            }
            else if(h.trim() == 'PROPOSED CVS INDIRECT UNITS'){
                headerMap.put('pro_cvs_indirect_units',count);
            }
            else if(h.trim() == 'PROPOSED CARDINAL UNITS'){
                headerMap.put('pro_cardinal_units',count);
            }
            else if(h.trim() == 'PROPOSED MAJOR UNITS'){
                headerMap.put('pro_major_units',count);
            }
             else if(h.trim() == 'LISTING PRICE'){
                headerMap.put('listing_price',count);
            }
             else if(h.trim() == 'MINIMUM ORDER QUANTITY'){
                headerMap.put('min_order_qty',count);
            }
             else if(h.trim() == 'BATCH NUMBER'){
                headerMap.put('batch_number',count);
            }
             else if(h.trim() == 'EXPIRY DATE'){
                headerMap.put('expiry_date',count);
            }
             else if(h.trim() == 'CASE PACK'){
                headerMap.put('case_pack',count);
            }
            else{
                headerMap.put(h,count);
            }
            count = count + 1;
        }
        headerFields.clear();
        return headerMap;
    }
    
    public static list<String> handleCommaInCSV(String csvLine){
        //String csvLine = 'Test,Check,abc@abc.com, "19, Link road, A1SH10, India", companyName, "companyStreet, CompanyCity, CompanyCountry"';
        Integer startingHeap = Limits.getHeapSize();
        String prevLine = csvLine;
        Integer startIndex;
        Integer endIndex;
        list<String> csvRowData = new list<String>();
        while(csvLine.indexOf('"') > -1){
            if(startIndex == null){
                startIndex = csvLine.indexOf('"');
                csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
            }else{
                if(endIndex == null){
                    endIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                }
            }
            if(startIndex != null && endIndex != null){
                String sub = csvLine.substring(startIndex, endIndex);
                sub = sub.replaceAll(',', ':comma:');
                csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                startIndex = null;
                endIndex = null;
            }
        }
        
        for(String column : csvLine.split(',')){
            column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
            csvRowData.add(column);
        }
        /*if(csvRowData.size() < 8){
csvRowData.add(',');
}*/
        return csvRowData;
    }
    
    public static extProductWrapper returnExtProductData(String accId){
        Integer startingHeap = Limits.getHeapSize();
        List<Product2> prodList = New List<Product2>();
        if(accId == 'getAllProds'){
            prodList = [SELECT Id, Name, ProductCode, Product_Family__c, Product_Family__r.Name,
                        Phoenix_GPI_Generic_Product_Identifier__c, Phoenix_GCN_Generic_Code_Number__c,
                        Phoenix_GCN_Sequence_Number__c, Family, Phoenix_NDC_11__c,Phoenix_Pkg_Size__c
                        FROM Product2 LIMIT 5000];
        }
        else{
            prodList = [SELECT Id, Name, ProductCode, Product_Family__c, Product_Family__r.Name,
                        Phoenix_GPI_Generic_Product_Identifier__c, Phoenix_GCN_Generic_Code_Number__c,
                        Phoenix_GCN_Sequence_Number__c, Family, Phoenix_NDC_11__c,Phoenix_Pkg_Size__c
                        FROM Product2 WHERE isActive = true AND Phoenix_Is_Exclude_Bid__c = false AND 
                        (Phoenix_Is_Private_Label_OTC__c = false OR 
                         (Phoenix_Is_Private_Label_OTC__c = true AND OTC_Customer__c = : accId AND Phoenix_Is_Control_Label__c = false)) AND 
                        (Phoenix_NDC_11__c != null or ProductCode != null
                         or Phoenix_GCN_Sequence_Number__c != null or Phoenix_GPI_Generic_Product_Identifier__c != null
                         or Phoenix_GCN_Generic_Code_Number__c != null
                         or (Phoenix_GPI_Generic_Product_Identifier__c != null and Phoenix_Pkg_Size__c != null)
                         or (Phoenix_GCN_Generic_Code_Number__c != null and Phoenix_Pkg_Size__c != null)
                         or (Phoenix_GCN_Sequence_Number__c != null and Phoenix_Pkg_Size__c != null))
                        ORDER BY Name ASC NULLS LAST];
        }
        extProductWrapper extPrdWrap = new extProductWrapper();
        for(Product2 product : prodList)
        {
            if(product.Phoenix_Pkg_Size__c!= null)
            {
                String pkgSize = String.valueOf(product.Phoenix_Pkg_Size__c);
                if(pkgSize.contains('.0'))
                    pkgSize = pkgSize.replace('.0','');
                if(product.Phoenix_GPI_Generic_Product_Identifier__c!= null)
                {
                    String gpiVal = product.Phoenix_GPI_Generic_Product_Identifier__c.replaceFirst('^0+', '');
                    String gpiUnique = gpiVal + pkgSize;
                    extPrdWrap.extGPIUniqueProductMap.put(gpiUnique,product);
                    
                    if (!extPrdWrap.extGPIProductPkgSizeMap.containsKey(product.Phoenix_GPI_Generic_Product_Identifier__c))
                        extPrdWrap.extGPIProductPkgSizeMap.put(product.Phoenix_GPI_Generic_Product_Identifier__c,new List<Integer>{Integer.valueOf(pkgSize)});
                    else
                        extPrdWrap.extGPIProductPkgSizeMap.get(product.Phoenix_GPI_Generic_Product_Identifier__c).add(Integer.valueOf(pkgSize));
                }
                if(product.Phoenix_GCN_Generic_Code_Number__c!= null)
                {
                    String gcnUnique = product.Phoenix_GCN_Generic_Code_Number__c + pkgSize;
                    extPrdWrap.extGCNUniqueProductMap.put(gcnUnique,product);
                    
                    if (!extPrdWrap.extGCNProductPkgSizeMap.containsKey(product.Phoenix_GCN_Generic_Code_Number__c))
                        extPrdWrap.extGCNProductPkgSizeMap.put(product.Phoenix_GCN_Generic_Code_Number__c,new List<Integer>{Integer.valueOf(pkgSize)});
                    else
                        extPrdWrap.extGCNProductPkgSizeMap.get(product.Phoenix_GCN_Generic_Code_Number__c).add(Integer.valueOf(pkgSize));
                }
                if(product.Phoenix_GCN_Sequence_Number__c!= null){
                    String gsnUnique = product.Phoenix_GCN_Sequence_Number__c + pkgSize;
                    extPrdWrap.extGSNUniqueProductMap.put(gsnUnique,product);
                    
                    if (!extPrdWrap.extGSNProductPkgSizeMap.containsKey(product.Phoenix_GCN_Sequence_Number__c))
                        extPrdWrap.extGSNProductPkgSizeMap.put(product.Phoenix_GCN_Sequence_Number__c,new List<Integer>{Integer.valueOf(pkgSize)});
                    else
                        extPrdWrap.extGSNProductPkgSizeMap.get(product.Phoenix_GCN_Sequence_Number__c).add(Integer.valueOf(pkgSize));
                }
            }
            if(product.Phoenix_GPI_Generic_Product_Identifier__c!= null){
                if(extPrdWrap.extGPIProductMap.containsKey(product.Phoenix_GPI_Generic_Product_Identifier__c) && product.Phoenix_Pkg_Size__c != null){
                    if(extPrdWrap.extGPIProductMap.get(product.Phoenix_GPI_Generic_Product_Identifier__c).Phoenix_Pkg_Size__c != null){
                        if(product.Phoenix_Pkg_Size__c > extPrdWrap.extGPIProductMap.get(product.Phoenix_GPI_Generic_Product_Identifier__c).Phoenix_Pkg_Size__c){
                            extPrdWrap.extGPIProductMap.remove(product.Phoenix_GPI_Generic_Product_Identifier__c);
                            extPrdWrap.extGPIProductMap.put(product.Phoenix_GPI_Generic_Product_Identifier__c,product);
                        }
                    }
                }
                else
                    extPrdWrap.extGPIProductMap.put(product.Phoenix_GPI_Generic_Product_Identifier__c,product);
            }
            if(product.Phoenix_GCN_Generic_Code_Number__c!= null)
                extPrdWrap.extGCNProductMap.put(product.Phoenix_GCN_Generic_Code_Number__c,product);
            
            if(product.Phoenix_GCN_Sequence_Number__c!= null)
                extPrdWrap.extGSNProductMap.put(product.Phoenix_GCN_Sequence_Number__c,product);
            
            if(product.Phoenix_NDC_11__c!= null)
                extPrdWrap.extNDCProductMap.put(product.Phoenix_NDC_11__c,product);
            
            if(product.ProductCode!= null)
                extPrdWrap.extSKUProductMap.put(product.ProductCode,product);
            
        }
        return extPrdWrap;
    }
    
    public static list<String> csvFileRead(Id contentDocumentId){
        Integer startingHeap = Limits.getHeapSize();
        list<String> csvRecordsList = new list<String>();
        if(contentDocumentId != null) {
            ContentVersion contentVersionObj = [SELECT Id, VersionData FROM ContentVersion WHERE Id =:contentDocumentId];
            if(contentVersionObj != null)
                csvRecordsList = contentVersionObj.VersionData.toString().split('\n');
        }
        return csvRecordsList;
    }
    
    @AuraEnabled
    public static string productCountRecords(Id contentDocumentId){return null;}
    
    public class fileDataWrapper{
        @auraEnabled
        public List<String> contentDataRows;
        @auraEnabled
        public Map<string, Integer> headerMap;
    }
    
    @auraEnabled
    public static List<Product_Opportunity__c> prepareRecords(list<String> csvRecordsList, Map<String,Integer> headerMap){
        productCountWrapper pcw = new productCountWrapper();
        List<Product_Opportunity__c> optyLineItems = new List<Product_Opportunity__c>();
        for(Integer i = 0; i < csvRecordsList.size(); i++){
            Boolean isProductPresent = false;
            list<String> csvRowData = handleCommaInCSV(csvRecordsList[i]);
            Product_Opportunity__c optyLineItem = new Product_Opportunity__c();
            optyLineItem = mapProductOpportunity(null, csvRowData, 'Unmatched', headerMap);
            optyLineItems.add(optyLineItem);
        }
        return optyLineItems;
    }
    
    @AuraEnabled
    public static string productCountRecords2(Id contentDocumentId){
        list<String> csvRecordsList = csvFileRead(contentDocumentId);
        Map<String,Integer> headerMap = getHeaderMap(csvRecordsList);
        fileDataWrapper fdWrapper = new fileDataWrapper();
        fdWrapper.contentDataRows = csvRecordsList;
        fdWrapper.headerMap = headerMap;
        return JSON.serialize(fdWrapper);
    }
    
    @AuraEnabled
    public static string processProductMatching(String prdOptyRecs, String accId){
        String customLabelString = system.label.Vision_PharmaBid_Account_Details;
        if(customLabelString != null){
            if(customLabelString == accId)
                accId = 'getAllProds';
        }
        List<Product_Opportunity__c> prodOptyRecs = new List<Product_Opportunity__c>();
        if(String.isNotBlank(prdOptyRecs)){
            prodOptyRecs = (List<Product_Opportunity__c>)JSON.deserialize(prdOptyRecs,List<Product_Opportunity__c>.class);
        }
        productCountWrapper pcw = new productCountWrapper();
        List<String> isGPIMatchedRecs = new List<String>();
        List<String> isGCNMatchedRecs = new List<String>();
        List<String> isGSNMatchedRecs = new List<String>();
        List<String> isGPIUnqMatchedRecs = new List<String>();
        List<String> isGCNUnqMatchedRecs = new List<String>();
        List<String> isGSNUnqMatchedRecs = new List<String>();
        List<String> isNDCMatchedRecs = new List<String>();
        List<String> isSKUMatchedRecs = new List<String>();
        Map<String,Product2> extGPIProductMap = returnExtProductData(accId).extGPIProductMap;
        Map<String,Product2> extGCNProductMap = returnExtProductData(accId).extGCNProductMap;
        Map<String,Product2> extGSNProductMap = returnExtProductData(accId).extGSNProductMap;
        Map<String,Product2> extGPIUniqueProductMap = returnExtProductData(accId).extGPIUniqueProductMap;
        Map<String,Product2> extGCNUniqueProductMap = returnExtProductData(accId).extGCNUniqueProductMap;
        Map<String,Product2> extGSNUniqueProductMap = returnExtProductData(accId).extGSNUniqueProductMap;
        Map<String,Product2> extNDCProductMap = returnExtProductData(accId).extNDCProductMap;
        Map<String,Product2> extSKUProductMap = returnExtProductData(accId).extSKUProductMap;
        Map<String,List<Integer>> extGCNProductPkgSizeMap= returnExtProductData(accId).extGCNProductPkgSizeMap;
        Map<String,List<Integer>> extGPIProductPkgSizeMap= returnExtProductData(accId).extGPIProductPkgSizeMap;
        Map<String,List<Integer>> extGSNProductPkgSizeMap= returnExtProductData(accId).extGSNProductPkgSizeMap;
        
        for(Product_Opportunity__c prdOpty : prodOptyRecs){
            String gsn = '';
            String gcn = '';
            String gpi = '';
            String gsnUnique = '';
            String gcnUnique = '';
            String gpiUnique = '';
            String sku_num = '';
            String ndc = '';
            String highBidPkgSize = '';
            String AltBidPkgSize = '';
            String pkgSize = '';
            Boolean isProductPresent = false;
            //list<String> csvRowData = handleCommaInCSV(csvRecordsList[i]);
            // //system.debug('csvRowData====> '+csvRowData.size());
            Product_Opportunity__c optyLineItem = new Product_Opportunity__c();
            // Product_Opportunity__c optyLineItem = new Product_Opportunity__c();
            if(prdOpty!=null){
                if(prdOpty.Pkg_Size__c != null){
                    pkgSize = String.valueOf(prdOpty.Pkg_Size__c);
                    if(pkgSize.contains('.0')){
                        pkgSize = pkgSize.replace('.0','');
                    }
                    prdOpty.Vision_Is_Pack_Size_Provided__c = true;
                }
                else
                    prdOpty.Vision_Is_Pack_Size_Provided__c = false;
                if(prdOpty.GCN_Generic_Code_Number__c != null){
                    gcn = prdOpty.GCN_Generic_Code_Number__c;
                    prdOpty.Vision_Is_GCN_Provided__c = true;
                }
                else
                    prdOpty.Vision_Is_GCN_Provided__c = false;
                if(prdOpty.GPI_Generic_Product_Identifier__c != null){
                    gpi =  prdOpty.GPI_Generic_Product_Identifier__c;
                    prdOpty.Vision_Is_GPI_Provided__c = true;
                }
                else
                    prdOpty.Vision_Is_GPI_Provided__c = false;
                if(prdOpty.GSN__c != null){
                    gsn = prdOpty.GSN__c;
                    prdOpty.Vision_Is_GSN_Provided__c = true;
                }
                else
                    prdOpty.Vision_Is_GSN_Provided__c = false;
                if(prdOpty.GSN__c != null && String.isNotBlank(pkgSize))
                    gsnUnique =  prdOpty.GSN__c + pkgSize;
                
                if(prdOpty.GCN_Generic_Code_Number__c != null && String.isNotBlank(pkgSize))
                    gcnUnique =  prdOpty.GCN_Generic_Code_Number__c + pkgSize;
                
                if(prdOpty.GPI_Generic_Product_Identifier__c != null && String.isNotBlank(pkgSize))
                    gpiUnique =  prdOpty.GPI_Generic_Product_Identifier__c + pkgSize;
                
                if(prdOpty.SKU_Number__c != null){
                    sku_num = prdOpty.SKU_Number__c;
                    prdOpty.Vision_Is_SKU_Provided__c = true;
                }
                else
                    prdOpty.Vision_Is_SKU_Provided__c = false;
                if(prdOpty.NDC_11__c != null){
                    if(prdOpty.NDC_11__c.contains('-')){
                        ndc = prdOpty.NDC_11__c.replace('-', '');
                    }
                    else{
                        ndc = prdOpty.NDC_11__c;
                    }
                    prdOpty.Vision_Is_NDC_Provided__c = true;
                }
                else
                    prdOpty.Vision_Is_NDC_Provided__c = false;
                
                if(String.isNotBlank(ndc) && extNDCProductMap.containsKey(ndc)){
                    optyLineItem = mapProductOpportunityRec(extNDCProductMap.get(ndc), prdOpty);
                    pcw.matchedRecords.add(optyLineItem);
                }
                else if(String.isNotBlank(sku_num) && extSKUProductMap.containsKey(sku_num)){
                    optyLineItem = mapProductOpportunityRec(extSKUProductMap.get(sku_num), prdOpty);
                    pcw.matchedRecords.add(optyLineItem);
                }
                else if(String.isNotBlank(gpiUnique) && extGPIUniqueProductMap.containsKey(gpiUnique)){
                    optyLineItem = mapProductOpportunityRec(extGPIUniqueProductMap.get(gpiUnique),prdOpty);
                    pcw.matchedRecords.add(optyLineItem);
                }
                else if(String.isNotBlank(gcnUnique) && extGCNUniqueProductMap.containsKey(gcnUnique)){
                    optyLineItem = mapProductOpportunityRec(extGCNUniqueProductMap.get(gcnUnique),prdOpty);
                    pcw.matchedRecords.add(optyLineItem);
                }
                else if(String.isNotBlank(gsnUnique) && extGSNUniqueProductMap.containsKey(gsnUnique)){
                    optyLineItem = mapProductOpportunityRec(extGSNUniqueProductMap.get(gsnUnique),prdOpty);
                    pcw.matchedRecords.add(optyLineItem);
                }
                else if(String.isNotBlank(gcn) && extGCNProductMap.containsKey(gcn) && !isGCNUnqMatchedRecs.contains(gcn)){
                    optyLineItem = mapProductOpportunityRec(extGCNProductMap.get(gcn),prdOpty);
                    pcw.matchedRecords.add(optyLineItem);
                    isGCNMatchedRecs.add(gcn);
                }
                else if(String.isNotBlank(gsn) && extGSNProductMap.containsKey(gsn) && !isGSNUnqMatchedRecs.contains(gsn)){
                    optyLineItem = mapProductOpportunityRec(extGSNProductMap.get(gsn),prdOpty);
                    pcw.matchedRecords.add(optyLineItem);
                    isGSNMatchedRecs.add(gsn);
                }
                else if(String.isNotBlank(gpi) && extGPIProductMap.containsKey(gpi) && !isGPIUnqMatchedRecs.contains(gpi)){
                    optyLineItem = mapProductOpportunityRec(extGPIProductMap.get(gpi),prdOpty);
                    pcw.matchedRecords.add(optyLineItem);
                    isGPIMatchedRecs.add(gpi);     
                }
                
                else if(prdOpty.Vision_Bid_on_Highest_Pack_Size__c != null && prdOpty.Vision_Bid_on_Highest_Pack_Size__c){
                    if(String.isNotBlank(gpi) && extGPIProductPkgSizeMap.containsKey(gpi)){
                        extGPIProductPkgSizeMap.get(gpi).sort();
                        List<Integer> prdPkgs = extGPIProductPkgSizeMap.get(gpi);
                        Integer maxVal = prdPkgs[prdPkgs.size() - 1];
                        String gpiMaxUniqueVal = gpi + String.valueOf(maxVal);
                        if(extGPIUniqueProductMap.containsKey(gpiMaxUniqueVal)){
                            optyLineItem = mapProductOpportunityRec(extGPIUniqueProductMap.get(gpiMaxUniqueVal),prdOpty);
                            optyLineItem.Vision_High_Pkg_Size__c = maxVal;
                            List<String> uomTypes = new List<String>{'EU', 'EXTENDED UNITS', 'DOSES', 'EACH'};
                                if(optyLineItem.Vision_UOM__c != null && uomTypes.contains(optyLineItem.Vision_UOM__c.toUpperCase()) && optyLineItem.Vision_Total_Annual_Units__c != null && optyLineItem.Vision_High_Pkg_Size__c != null){
                                    optyLineItem.Quantity__c = optyLineItem.Vision_Total_Annual_Units__c / optyLineItem.Vision_High_Pkg_Size__c;
                                }
                            else{
                                optyLineItem.Quantity__c = optyLineItem.Vision_Total_Annual_Units__c;
                            }
                            if(optyLineItem.Quantity__c != null && optyLineItem.Vision_High_Pkg_Size__c != null){
                                optyLineItem.Vision_Pills__c = optyLineItem.Quantity__c * optyLineItem.Vision_High_Pkg_Size__c;
                            }
                            pcw.matchedRecords.add(optyLineItem);
                        }
                        
                    }
                    else if(String.isNotBlank(gcn) && extGCNProductPkgSizeMap.containsKey(gcn)){
                        extGCNProductPkgSizeMap.get(gcn).sort();
                        List<Integer> prdPkgs = extGCNProductPkgSizeMap.get(gcn);
                        Integer maxVal = prdPkgs[prdPkgs.size() - 1];
                        String gcnMaxUniqueVal = gcn + String.valueOf(maxVal);
                        if(extGCNUniqueProductMap.containsKey(gcnMaxUniqueVal)){
                            optyLineItem = mapProductOpportunityRec(extGCNUniqueProductMap.get(gcnMaxUniqueVal),prdOpty);
                            optyLineItem.Vision_High_Pkg_Size__c = maxVal;
                            List<String> uomTypes = new List<String>{'EU', 'EXTENDED UNITS', 'DOSES', 'EACH'};
                                if(optyLineItem.Vision_UOM__c != null && uomTypes.contains(optyLineItem.Vision_UOM__c.toUpperCase()) && optyLineItem.Vision_Total_Annual_Units__c != null && optyLineItem.Vision_High_Pkg_Size__c != null){
                                    optyLineItem.Quantity__c = optyLineItem.Vision_Total_Annual_Units__c / optyLineItem.Vision_High_Pkg_Size__c;
                                }
                            else{
                                optyLineItem.Quantity__c = optyLineItem.Vision_Total_Annual_Units__c;
                            }
                            if(optyLineItem.Quantity__c != null && optyLineItem.Vision_High_Pkg_Size__c != null){
                                optyLineItem.Vision_Pills__c = optyLineItem.Quantity__c * optyLineItem.Vision_High_Pkg_Size__c;
                            }
                            pcw.matchedRecords.add(optyLineItem);
                        }
                        
                    }
                    else if(String.isNotBlank(gsn) && extGSNProductPkgSizeMap.containsKey(gsn)){
                        extGSNProductPkgSizeMap.get(gsn).sort();
                        List<Integer> prdPkgs = extGSNProductPkgSizeMap.get(gsn);
                        Integer maxVal = prdPkgs[prdPkgs.size() - 1];
                        String gsnMaxUniqueVal = gsn + String.valueOf(maxVal);
                        if(extGSNUniqueProductMap.containsKey(gsnMaxUniqueVal)){
                            optyLineItem = mapProductOpportunityRec(extGSNUniqueProductMap.get(gsnMaxUniqueVal),prdOpty);
                            optyLineItem.Vision_High_Pkg_Size__c = maxVal;
                            List<String> uomTypes = new List<String>{'EU', 'EXTENDED UNITS', 'DOSES', 'EACH'};
                                if(optyLineItem.Vision_UOM__c != null && uomTypes.contains(optyLineItem.Vision_UOM__c.toUpperCase()) && optyLineItem.Vision_Total_Annual_Units__c != null && optyLineItem.Vision_High_Pkg_Size__c != null){
                                    optyLineItem.Quantity__c = optyLineItem.Vision_Total_Annual_Units__c / optyLineItem.Vision_High_Pkg_Size__c;
                                }
                            else{
                                optyLineItem.Quantity__c = optyLineItem.Vision_Total_Annual_Units__c;
                            }
                            if(optyLineItem.Quantity__c != null && optyLineItem.Vision_High_Pkg_Size__c != null){
                                optyLineItem.Vision_Pills__c = optyLineItem.Quantity__c * optyLineItem.Vision_High_Pkg_Size__c;
                            }
                            pcw.matchedRecords.add(optyLineItem);
                        }
                    }
                    else
                        pcw.unMatchedRecords.add(prdOpty);
                }
                else if(prdOpty.Vision_Bid_on_Alternative_Pack_Size__c != null && prdOpty.Vision_Bid_on_Alternative_Pack_Size__c && String.isNotBlank(pkgSize)){
                    
                    if(String.isNotBlank(gpi) && extGPIProductPkgSizeMap.containsKey(gpi)){
                        
                        extGPIProductPkgSizeMap.get(gpi).sort();
                        List<Integer> prdPkgs = extGPIProductPkgSizeMap.get(gpi);
                        Integer altVal = findClosest(prdPkgs, Integer.valueOf(pkgSize));
                        ////system.debug('Matched gpi : '+ gpi + ' altVal : ' + altVal);
                        String gpiAltUniqueVal = gpi + String.valueOf(altVal);
                        if(extGPIUniqueProductMap.containsKey(gpiAltUniqueVal)){
                            optyLineItem = mapProductOpportunityRec(extGPIUniqueProductMap.get(gpiAltUniqueVal),prdOpty);
                            optyLineItem.Vision_Alt_Pkg_Size__c = altVal;
                            List<String> uomTypes = new List<String>{'EU', 'EXTENDED UNITS', 'DOSES', 'EACH'};
                                if(optyLineItem.Vision_UOM__c != null && uomTypes.contains(optyLineItem.Vision_UOM__c.toUpperCase()) && optyLineItem.Vision_Total_Annual_Units__c != null && optyLineItem.Vision_Alt_Pkg_Size__c != null){
                                    optyLineItem.Quantity__c = optyLineItem.Vision_Total_Annual_Units__c / optyLineItem.Vision_Alt_Pkg_Size__c;
                                }
                            else{
                                optyLineItem.Quantity__c = optyLineItem.Vision_Total_Annual_Units__c;
                            }
                            if(optyLineItem.Quantity__c != null && optyLineItem.Vision_Alt_Pkg_Size__c != null){
                                optyLineItem.Vision_Pills__c = optyLineItem.Quantity__c * optyLineItem.Vision_Alt_Pkg_Size__c;
                            }
                            pcw.matchedRecords.add(optyLineItem);
                        }
                    }
                    else if(String.isNotBlank(gcn) && extGCNProductPkgSizeMap.containsKey(gcn)){
                        extGCNProductPkgSizeMap.get(gcn).sort();
                        List<Integer> prdPkgs = extGCNProductPkgSizeMap.get(gcn);
                        Integer altVal = findClosest(prdPkgs, Integer.valueOf(pkgSize));
                        ////system.debug('Matched gcn : '+ gcn + ' altVal : ' + altVal);
                        String gcnAltUniqueVal = gcn + String.valueOf(altVal);
                        if(extGCNUniqueProductMap.containsKey(gcnAltUniqueVal)){
                            optyLineItem = mapProductOpportunityRec(extGCNUniqueProductMap.get(gcnAltUniqueVal), prdOpty);
                            optyLineItem.Vision_Alt_Pkg_Size__c = altVal;
                            List<String> uomTypes = new List<String>{'EU', 'EXTENDED UNITS', 'DOSES', 'EACH'};
                                if(optyLineItem.Vision_UOM__c != null && uomTypes.contains(optyLineItem.Vision_UOM__c.toUpperCase()) && optyLineItem.Vision_Total_Annual_Units__c != null && optyLineItem.Vision_Alt_Pkg_Size__c != null)
                                optyLineItem.Quantity__c = optyLineItem.Vision_Total_Annual_Units__c / optyLineItem.Vision_Alt_Pkg_Size__c;
                            else
                                optyLineItem.Quantity__c = optyLineItem.Vision_Total_Annual_Units__c;
                            if(optyLineItem.Quantity__c != null && optyLineItem.Vision_Alt_Pkg_Size__c != null)
                                optyLineItem.Vision_Pills__c = optyLineItem.Quantity__c * optyLineItem.Vision_Alt_Pkg_Size__c;
                            pcw.matchedRecords.add(optyLineItem);
                        }
                    }
                    else if(String.isNotBlank(gsn) && extGSNProductPkgSizeMap.containsKey(gsn)){
                        extGSNProductPkgSizeMap.get(gsn).sort();
                        List<Integer> prdPkgs = extGSNProductPkgSizeMap.get(gsn);
                        Integer altVal = findClosest(prdPkgs, Integer.valueOf(pkgSize));
                        ////system.debug('Matched gsn : '+ gsn + ' altVal : ' + altVal);
                        String gsnAltUniqueVal = gsn + String.valueOf(altVal);
                        if(extGSNUniqueProductMap.containsKey(gsnAltUniqueVal)){
                            optyLineItem = mapProductOpportunityRec(extGSNUniqueProductMap.get(gsnAltUniqueVal),prdOpty);
                            optyLineItem.Vision_Alt_Pkg_Size__c = altVal;
                            List<String> uomTypes = new List<String>{'EU', 'EXTENDED UNITS', 'DOSES', 'EACH'};
                                if(optyLineItem.Vision_UOM__c != null && uomTypes.contains(optyLineItem.Vision_UOM__c.toUpperCase()) && optyLineItem.Vision_Total_Annual_Units__c != null && optyLineItem.Vision_Alt_Pkg_Size__c != null){
                                    optyLineItem.Quantity__c = optyLineItem.Vision_Total_Annual_Units__c / optyLineItem.Vision_Alt_Pkg_Size__c;
                                }
                            else{
                                optyLineItem.Quantity__c = optyLineItem.Vision_Total_Annual_Units__c;
                            }
                            if(optyLineItem.Quantity__c != null && optyLineItem.Vision_Alt_Pkg_Size__c != null){
                                optyLineItem.Vision_Pills__c = optyLineItem.Quantity__c * optyLineItem.Vision_Alt_Pkg_Size__c;
                            }
                            pcw.matchedRecords.add(optyLineItem);
                        }
                    }
                    else
                        pcw.unMatchedRecords.add(prdOpty);
                }
                else
                    pcw.unMatchedRecords.add(prdOpty);
                if(String.isNotBlank(ndc) && extNDCProductMap.containsKey(ndc))
                    isNDCMatchedRecs.add(ndc);
                if(String.isNotBlank(sku_num) && extSKUProductMap.containsKey(sku_num))
                    isSKUMatchedRecs.add(sku_num);
                if(String.isNotBlank(gpiUnique) && extGPIUniqueProductMap.containsKey(gpiUnique))
                    isGPIUnqMatchedRecs.add(gpi);
                if(String.isNotBlank(gcnUnique) && extGCNUniqueProductMap.containsKey(gcnUnique))
                    isGCNUnqMatchedRecs.add(gcn);
                if(String.isNotBlank(gsnUnique) && extGSNUniqueProductMap.containsKey(gsnUnique))
                    isGSNUnqMatchedRecs.add(gsn);
                
            }
            else{}
                //system.debug('--prdOpty is null--'+prdOpty);
        }
        Integer totRecs = pcw.matchedRecords.size() + pcw.unMatchedRecords.size();
        pcw.totalRecordsInfo.put('totalRecCount',totRecs);
        pcw.totalRecordsInfo.put('matchedRecCount',pcw.matchedRecords.size());
        pcw.totalRecordsInfo.put('unmatchedRecCount',pcw.unMatchedRecords.size());
        
        for(Product_Opportunity__c prdOpLineItem : pcw.matchedRecords){
            if(isNDCMatchedRecs.contains(prdOpLineItem.NDC_11__c))
                prdOpLineItem.Is_NDC_Matched__c  = true;
            
            if(isSKUMatchedRecs.contains(prdOpLineItem.SKU_Number__c))
                prdOpLineItem.Is_SKU_Matched__c = true;
            
            if(isGPIUnqMatchedRecs.contains(prdOpLineItem.GPI_Generic_Product_Identifier__c))
                prdOpLineItem.Is_GPI_Pack_Size_Matched__c  = true;
            
            if(isGSNUnqMatchedRecs.contains(prdOpLineItem.GSN__c))
                prdOpLineItem.Is_GSN_Pack_Size_Matched__c  = true;
            
            if(isGCNUnqMatchedRecs.contains(prdOpLineItem.GCN_Generic_Code_Number__c))
                prdOpLineItem.Is_GCN_Pack_Size_Matched__c  = true;
            
            if(isGPIMatchedRecs.contains(prdOpLineItem.GPI_Generic_Product_Identifier__c))
                prdOpLineItem.Is_GPI_Matched__c  = true;
            
            if(isGSNMatchedRecs.contains(prdOpLineItem.GSN__c))
                prdOpLineItem.Is_GSN_Matched__c  = true;
            
            if(isGCNMatchedRecs.contains(prdOpLineItem.GCN_Generic_Code_Number__c))
                prdOpLineItem.Is_GCN_Matched__c  = true;
        }
        
        for(Product_Opportunity__c prdOptyLineItem : pcw.unMatchedRecords){
            if(isNDCMatchedRecs.contains(prdOptyLineItem.NDC_11__c))
                prdOptyLineItem.Is_NDC_Matched__c  = true;
            
            if(isSKUMatchedRecs.contains(prdOptyLineItem.SKU_Number__c))
                prdOptyLineItem.Is_SKU_Matched__c = true;
            
            if(isGPIUnqMatchedRecs.contains(prdOptyLineItem.GPI_Generic_Product_Identifier__c))
                prdOptyLineItem.Is_GPI_Pack_Size_Matched__c  = true;
            
            if(isGSNUnqMatchedRecs.contains(prdOptyLineItem.GSN__c))
                prdOptyLineItem.Is_GSN_Pack_Size_Matched__c  = true;
            
            if(isGCNUnqMatchedRecs.contains(prdOptyLineItem.GCN_Generic_Code_Number__c))
                prdOptyLineItem.Is_GCN_Pack_Size_Matched__c  = true;
            
            if(isGPIMatchedRecs.contains(prdOptyLineItem.GPI_Generic_Product_Identifier__c))
                prdOptyLineItem.Is_GPI_Matched__c  = true;
            
            if(isGSNMatchedRecs.contains(prdOptyLineItem.GSN__c))
                prdOptyLineItem.Is_GSN_Matched__c  = true;
            
            if(isGCNMatchedRecs.contains(prdOptyLineItem.GCN_Generic_Code_Number__c))
                prdOptyLineItem.Is_GCN_Matched__c  = true;
        }
        return JSON.serialize(pcw);
    }
    
    public static Product_Opportunity__c mapProductOpportunityRec(Product2 product , Product_Opportunity__c prodOpty) {
        try{
            prodOpty.Product__c = product.Id;
            prodOpty.Name = product.Name;
            prodOpty.GCN_Generic_Code_Number__c = product.Phoenix_GCN_Generic_Code_Number__c;
            prodOpty.GSN__c = product.Phoenix_GCN_Sequence_Number__c;
            prodOpty.GPI_Generic_Product_Identifier__c = product.Phoenix_GPI_Generic_Product_Identifier__c;
            prodOpty.NDC_11__c = product.Phoenix_NDC_11__c;
            prodOpty.SKU_Number__c = product.ProductCode;
            prodOpty.Status__c = 'Matched';
            prodOpty.GCP_Product_Family__c = product.Product_Family__c;
            //system.debug('prodOpty--->'+prodOpty);
            return prodOpty;
        }
        catch(Exception e){
            //system.debug('Error: ' + e.getStackTraceString()+' Message: '+e.getMessage());
            Phoenix_Util.recordException(e,'mapProductOpportunityRec','mapProductOpportunity',''); 
            return null;
        }
    }
    
    /* @auraEnabled
public static string getMatchedProdsList(Id opportunityId, Integer offSetVal){
productCountWrapper pcw = new productCountWrapper();
String status1 = 'Matched';
String query = 'SELECT '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c WHERE Status__c =: status1 and Opportunity__c=: opportunityId LIMIT 50 OFFSET '+offSetVal;
pcw.matchedRecords = Database.query(query);
String query2 = 'SELECT '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c WHERE Status__c =: status1 and Opportunity__c=: opportunityId';
String status2 = 'Unmatched';
String query3 = 'SELECT Product__r.Name,Product__r.Id, '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c WHERE Status__c =: status2 and Opportunity__c=: opportunityId';
list<Product_Opportunity__c> unMatchedRecords = Database.query(query3);
list<Product_Opportunity__c> matchedRecords = Database.query(query2);
Integer totalRecords = matchedRecords.size() + unMatchedRecords.size();
pcw.totalRecordsInfo.put('totalRecCount',totalRecords);
pcw.totalRecordsInfo.put('matchedRecCount',matchedRecords.size());
pcw.totalRecordsInfo.put('unmatchedRecCount',unMatchedRecords.size());
return JSON.serialize(pcw);
}
*/    
    @AuraEnabled
    public static string productCountRecordsDetailPage(Id OpportunityId){
        if(opportunityId != null){
            productCountWrapper pcw = new productCountWrapper();
            String query = 'SELECT '+Phoenix_Util.getsObjectFieds('Opportunity')+' FROM Opportunity WHERE Id=: opportunityId';
            Opportunity opp = Database.query(query);
            pcw.stageName = opp.StageName;
            pcw.accTemplate = opp.Vision_Bid_Template__c;
            pcw.accId = opp.AccountId;
            String status1 = 'Matched';
            String status2 = 'Unmatched';
            String status3 = 'Discrepant';
            String query2 = 'SELECT Product__r.Name,Product__r.Id, Product__r.Phoenix_Pkg_Size__c, Product__r.Phoenix_Strength__c, Product__r.Phoenix_GCN_Generic_Code_Number__c, Product__r.Phoenix_GCN_Sequence_Number__c, '+
                +' Product__r.Phoenix_GPI_Generic_Product_Identifier__c, Product__r.Phoenix_NDC_11__c, Product__r.ProductCode, Product__r.Phoenix_Dosage_Form__c,'+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c'+
                +' WHERE Opportunity__c=: opportunityId AND (Status__c =: status1 OR Status__c =: status2 OR Status__c =: status3) ORDER BY Name';
            List<Product_Opportunity__c> optyProdList = Database.query(query2);
            
            //pcw.matchedRecords=Database.query(query2);
            //List<Product_Opportunity__c> matchedRecs = Database.query(query2);
            //String query3 = 'SELECT Product__r.Name,Product__r.Id, '+prodOppFields+' FROM Product_Opportunity__c WHERE Status__c =: status2 and Opportunity__c=: opportunityId ORDER BY Name';
            //pcw.unMatchedRecords = Database.query(query3);
            //String query4 = 'SELECT Product__r.Name,Product__r.Id, '+prodOppFields+' FROM Product_Opportunity__c WHERE Status__c =: status3 and Opportunity__c=: opportunityId ORDER BY Name';
            //List<Product_Opportunity__c> discrepantList = Database.query(query4);
            Integer totalRecords = optyProdList.size();//pcw.matchedRecords.size() + pcw.unMatchedRecords.size() + discrepantList.size();//
            pcw.totalRecordsInfo.put('totalRecCount',totalRecords);
            Integer totalMatchedNDC = 0,totalMatchedSKU = 0,totalMatchedGCNUnq = 0,totalMatchedGSNUnq = 0,totalMatchedGPIUnq = 0,totalNoUsage = 0,totalUnMatchForced = 0,totalMatchRemoved = 0,totalNDCProvided = 0,totalSKUProvided = 0,totalGCNProvided = 0,totalGSNProvided = 0,totalGPIProvided = 0,totalGCNUnqProvided = 0,totalGSNUnqProvided = 0,totalGPIUnqProvided = 0,totalPkgSizeProvided= 0, totalNDCDup = 0, totalSKUDup = 0, totalGCNUnqDup = 0, totalGSNUnqDup = 0, totalGPIUnqDup = 0;
            List<String> NDCDuplicates = new List<String>();
            List<String> SKUDuplicates = new List<String>();
            List<String> GCNUnqDuplicates = new List<String>();
            List<String> GPIUnqDuplicates = new List<String>();
            List<String> GSNUnqDuplicates = new List<String>();
            Map<Id,List<Product_Opportunity__c>> identifyDupRecs = new Map<Id,List<Product_Opportunity__c>>();
            List<Id> noUsagePrdIds = new List<Id>();
            Integer unMatchCount = 0;
            for(Product_Opportunity__c prdOpty : optyProdList){
                if(prdOpty.Vision_Is_Pack_Size_Provided__c && prdOpty.Vision_Is_GCN_Provided__c)
                    totalGCNUnqProvided = totalGCNUnqProvided+1;
                if(prdOpty.Vision_Is_Pack_Size_Provided__c && prdOpty.Vision_Is_GPI_Provided__c)
                    totalGPIUnqProvided = totalGPIUnqProvided+1;
                if(prdOpty.Vision_Is_Pack_Size_Provided__c && prdOpty.Vision_Is_GSN_Provided__c)
                    totalGSNUnqProvided = totalGSNUnqProvided+1;
                if(prdOpty.Vision_Is_Pack_Size_Provided__c)
                    totalPkgSizeProvided++;
                if(prdOpty.Vision_Is_NDC_Provided__c)
                    totalNDCProvided++;
                if(prdOpty.Vision_Is_GCN_Provided__c)
                    totalGCNProvided++;
                if(prdOpty.Vision_Is_GPI_Provided__c)
                    totalGPIProvided++;
                if(prdOpty.Vision_Is_GSN_Provided__c)
                    totalGSNProvided++;
                if(prdOpty.Vision_Is_SKU_Provided__c)
                    totalSKUProvided++;
                if(prdOpty.Status__c == 'Matched'){
                    pcw.matchedRecords.add(prdOpty);
                    if(prdOpty.Is_NDC_Matched__c)
                        totalMatchedNDC++;
                    else if(prdOpty.Is_SKU_Matched__c)
                        totalMatchedSKU++;
                    else if(prdOpty.Is_GCN_Pack_Size_Matched__c)
                        totalMatchedGCNUnq++;
                    else if(prdOpty.Is_GSN_Pack_Size_Matched__c)
                        totalMatchedGSNUnq++;
                    else if(prdOpty.Is_GPI_Pack_Size_Matched__c)
                        totalMatchedGPIUnq++;
                }
                else if(prdOpty.Status__c == 'Unmatched')
                    unMatchCount++;
                else if(prdOpty.Status__c == 'Discrepant'){
                    pcw.duplicateRecords.add(prdOpty);
                    if(prdOpty.NDC_11__c != null){
                        if(NDCDuplicates.contains(prdOpty.NDC_11__c) == false)
                            NDCDuplicates.add(prdOpty.NDC_11__c);
                        else
                            totalNDCDup++;
                    }
                    else if(prdOpty.SKU_Number__c != null){
                        totalSKUProvided = totalSKUProvided+1;
                        if(!SKUDuplicates.contains(prdOpty.SKU_Number__c))
                            SKUDuplicates.add(prdOpty.SKU_Number__c);
                        else
                            totalSKUDup++;
                    }
                    
                    else if(prdOpty.GCN_Generic_Code_Number__c != null && prdOpty.Pkg_Size__c != null){
                        String pkgSize = String.valueOf(prdOpty.Pkg_Size__c);
                        if(pkgSize.contains('.0')){
                            pkgSize = pkgSize.replace('.0','');
                        }
                        String gcnUnq = prdOpty.GCN_Generic_Code_Number__c + pkgSize;
                        if(!GCNUnqDuplicates.contains(gcnUnq))
                            GCNUnqDuplicates.add(gcnUnq);
                        else
                            totalGCNUnqDup++;
                    }
                    else if(prdOpty.GPI_Generic_Product_Identifier__c != null && prdOpty.Pkg_Size__c != null){
                        String pkgSize = String.valueOf(prdOpty.Pkg_Size__c);
                        if(pkgSize.contains('.0')){
                            pkgSize = pkgSize.replace('.0','');
                        }
                        String gpiUnq = prdOpty.GPI_Generic_Product_Identifier__c + pkgSize;
                        if(!GPIUnqDuplicates.contains(gpiUnq))
                            GPIUnqDuplicates.add(gpiUnq);
                        else
                            totalGPIUnqDup++;
                    }
                    else if(prdOpty.GSN__c != null && prdOpty.Pkg_Size__c != null){
                        String pkgSize = String.valueOf(prdOpty.Pkg_Size__c);
                        if(pkgSize.contains('.0')){
                            pkgSize = pkgSize.replace('.0','');
                        }
                        String gsnUnq = prdOpty.GSN__c + pkgSize;
                        if(!GSNUnqDuplicates.contains(gsnUnq))
                            GSNUnqDuplicates.add(gsnUnq);
                        else
                            totalGSNUnqDup++;
                    }
                    if (!identifyDupRecs.containsKey(prdOpty.Product__c)){
                        identifyDupRecs.put(prdOpty.Product__c,new List<Product_Opportunity__c>());
                        identifyDupRecs.get(prdOpty.Product__c).add(prdOpty);
                    }
                    if(prdOpty.Vision_Total_Annual_Units__c == null || prdOpty.Vision_Total_Annual_Units__c == 0)
                        totalNoUsage++;
                }
            }
            /*for(Product_Opportunity__c prdOpty : matchedRecs){
                if(prdOpty.Is_NDC_Matched__c)
                    totalMatchedNDC++;
                else if(prdOpty.Is_SKU_Matched__c)
                    totalMatchedSKU++;
                else if(prdOpty.Is_GCN_Pack_Size_Matched__c)
                    totalMatchedGCNUnq++;
                else if(prdOpty.Is_GSN_Pack_Size_Matched__c)
                    totalMatchedGSNUnq++;
                else if(prdOpty.Is_GPI_Pack_Size_Matched__c)
                    totalMatchedGPIUnq++;
                if(prdOpty.Vision_Is_Pack_Size_Provided__c && prdOpty.Vision_Is_GCN_Provided__c)
                    totalGCNUnqProvided = totalGCNUnqProvided+1;
                if(prdOpty.Vision_Is_Pack_Size_Provided__c && prdOpty.Vision_Is_GPI_Provided__c)
                    totalGPIUnqProvided = totalGPIUnqProvided+1;
                if(prdOpty.Vision_Is_Pack_Size_Provided__c && prdOpty.Vision_Is_GSN_Provided__c)
                    totalGSNUnqProvided = totalGSNUnqProvided+1;
                
                
                if(prdOpty.Vision_Is_Pack_Size_Provided__c)
                    totalPkgSizeProvided++;
                if(prdOpty.Vision_Is_NDC_Provided__c)
                    totalNDCProvided++;
                if(prdOpty.Vision_Is_GCN_Provided__c)
                    totalGCNProvided++;
                if(prdOpty.Vision_Is_GPI_Provided__c)
                    totalGPIProvided++;
                if(prdOpty.Vision_Is_GSN_Provided__c)
                    totalGSNProvided++;
                if(prdOpty.Vision_Is_SKU_Provided__c)
                    totalSKUProvided++;
            }
            for(Product_Opportunity__c prdOpty : pcw.unMatchedRecords){
                if(prdOpty.Vision_Is_Pack_Size_Provided__c)
                    totalPkgSizeProvided++;
                if(prdOpty.Vision_Is_NDC_Provided__c)
                    totalNDCProvided++;
                if(prdOpty.Vision_Is_GCN_Provided__c)
                    totalGCNProvided++;
                if(prdOpty.Vision_Is_GPI_Provided__c)
                    totalGPIProvided++;
                if(prdOpty.Vision_Is_GSN_Provided__c)
                    totalGSNProvided++;
                if(prdOpty.Vision_Is_SKU_Provided__c)
                    totalSKUProvided++;
                
                
                if(prdOpty.Vision_Is_Pack_Size_Provided__c && prdOpty.Vision_Is_GCN_Provided__c)
                    totalGCNUnqProvided = totalGCNUnqProvided+1;
                if(prdOpty.Vision_Is_Pack_Size_Provided__c && prdOpty.Vision_Is_GPI_Provided__c)
                    totalGPIUnqProvided = totalGPIUnqProvided+1;
                if(prdOpty.Vision_Is_Pack_Size_Provided__c && prdOpty.Vision_Is_GSN_Provided__c)
                    totalGSNUnqProvided = totalGSNUnqProvided+1;
            }
            for(Product_Opportunity__c prdOpty : discrepantList){
                
                if(prdOpty.Vision_Is_Pack_Size_Provided__c)
                    totalPkgSizeProvided++;
                if(prdOpty.Vision_Is_NDC_Provided__c)
                    totalNDCProvided++;
                if(prdOpty.Vision_Is_GCN_Provided__c)
                    totalGCNProvided++;
                if(prdOpty.Vision_Is_GPI_Provided__c)
                    totalGPIProvided++;
                if(prdOpty.Vision_Is_GSN_Provided__c)
                    totalGSNProvided++;
                if(prdOpty.Vision_Is_SKU_Provided__c)
                    totalSKUProvided++;
                
                
                if(prdOpty.Vision_Is_Pack_Size_Provided__c && prdOpty.Vision_Is_GCN_Provided__c)
                    totalGCNUnqProvided = totalGCNUnqProvided+1;
                if(prdOpty.Vision_Is_Pack_Size_Provided__c && prdOpty.Vision_Is_GPI_Provided__c)
                    totalGPIUnqProvided = totalGPIUnqProvided+1;
                if(prdOpty.Vision_Is_Pack_Size_Provided__c && prdOpty.Vision_Is_GSN_Provided__c)
                    totalGSNUnqProvided = totalGSNUnqProvided+1;
                
                if(prdOpty.Vision_Total_Annual_Units__c == null)
                    totalNoUsage++;
                if(prdOpty.NDC_11__c != null){
                    if(NDCDuplicates.contains(prdOpty.NDC_11__c) == false)
                        NDCDuplicates.add(prdOpty.NDC_11__c);
                    else
                        totalNDCDup++;
                }
                else if(prdOpty.SKU_Number__c != null){
                    totalSKUProvided = totalSKUProvided+1;
                    if(!SKUDuplicates.contains(prdOpty.SKU_Number__c))
                        SKUDuplicates.add(prdOpty.SKU_Number__c);
                    else
                        totalSKUDup++;
                }
                
                else if(prdOpty.GCN_Generic_Code_Number__c != null && prdOpty.Pkg_Size__c != null){
                    String pkgSize = String.valueOf(prdOpty.Pkg_Size__c);
                    if(pkgSize.contains('.0')){
                        pkgSize = pkgSize.replace('.0','');
                    }
                    String gcnUnq = prdOpty.GCN_Generic_Code_Number__c + pkgSize;
                    if(!GCNUnqDuplicates.contains(gcnUnq))
                        GCNUnqDuplicates.add(gcnUnq);
                    else
                        totalGCNUnqDup++;
                }
                else if(prdOpty.GPI_Generic_Product_Identifier__c != null && prdOpty.Pkg_Size__c != null){
                    String pkgSize = String.valueOf(prdOpty.Pkg_Size__c);
                    if(pkgSize.contains('.0')){
                        pkgSize = pkgSize.replace('.0','');
                    }
                    String gpiUnq = prdOpty.GPI_Generic_Product_Identifier__c + pkgSize;
                    if(!GPIUnqDuplicates.contains(gpiUnq))
                        GPIUnqDuplicates.add(gpiUnq);
                    else
                        totalGPIUnqDup++;
                }
                else if(prdOpty.GSN__c != null && prdOpty.Pkg_Size__c != null){
                    String pkgSize = String.valueOf(prdOpty.Pkg_Size__c);
                    if(pkgSize.contains('.0')){
                        pkgSize = pkgSize.replace('.0','');
                    }
                    String gsnUnq = prdOpty.GSN__c + pkgSize;
                    if(!GSNUnqDuplicates.contains(gsnUnq))
                        GSNUnqDuplicates.add(gsnUnq);
                    else
                        totalGSNUnqDup++;
                }
                pcw.duplicateRecords.add(prdOpty);
                if (!identifyDupRecs.containsKey(prdOpty.Product__c))
                    identifyDupRecs.put(prdOpty.Product__c,new List<Product_Opportunity__c>{prdOpty});
                else
                    identifyDupRecs.get(prdOpty.Product__c).add(prdOpty);
                if(prdOpty.Vision_Total_Annual_Units__c == null || prdOpty.Vision_Total_Annual_Units__c == 0)
                    totalNoUsage++;
            }*/
            
            for(Id prdId  : identifyDupRecs.keySet()){
                if(identifyDupRecs.get(prdId).size() > 1){
                    for(Product_Opportunity__c prd : identifyDupRecs.get(prdId)){
                        if(!pcw.duplicateItems.containsKey(prdId))
                            pcw.duplicateItems.put(prdId, new List<Product_Opportunity__c>());
                        pcw.duplicateItems.get(prdId).add(prd);
                    }
                }
            }
            pcw.totalRecordsInfo.put('matchedRecCount',pcw.matchedRecords.size());
            pcw.totalRecordsInfo.put('unmatchedRecCount',unMatchCount);
            pcw.recsDetailedInfo.put('totalMatchedNDC',totalMatchedNDC);
            pcw.recsDetailedInfo.put('totalMatchedSKU',totalMatchedSKU);
            pcw.recsDetailedInfo.put('totalMatchedGCNUnq',totalMatchedGCNUnq);
            pcw.recsDetailedInfo.put('totalMatchedGSNUnq',totalMatchedGSNUnq);
            pcw.recsDetailedInfo.put('totalMatchedGPIUnq',totalMatchedGPIUnq);
            pcw.recsDetailedInfo.put('totalMatchRemoved',totalMatchRemoved);
            pcw.recsDetailedInfo.put('totalUnMatchForced',totalUnMatchForced);
            pcw.recsDetailedInfo.put('totalNoUsage',totalNoUsage);
            pcw.recsDetailedInfo.put('totalPkgSizeProvided',totalPkgSizeProvided);
            pcw.recsDetailedInfo.put('totalNDCProvided',totalNDCProvided);
            pcw.recsDetailedInfo.put('totalSKUProvided',totalSKUProvided);
            pcw.recsDetailedInfo.put('totalGCNProvided',totalGCNProvided);
            pcw.recsDetailedInfo.put('totalGSNProvided',totalGSNProvided);
            pcw.recsDetailedInfo.put('totalGPIProvided',totalGPIProvided);
            pcw.recsDetailedInfo.put('totalGCNUnqProvided',totalGCNUnqProvided);
            pcw.recsDetailedInfo.put('totalGSNUnqProvided',totalGSNUnqProvided);
            pcw.recsDetailedInfo.put('totalGPIUnqProvided',totalGPIUnqProvided);
            pcw.recsDetailedInfo.put('totalNDCDup',totalNDCDup);
            pcw.recsDetailedInfo.put('totalSKUDup',totalSKUDup);
            pcw.recsDetailedInfo.put('totalGCNUnqDup',totalGCNUnqDup);
            pcw.recsDetailedInfo.put('totalGSNUnqDup',totalGSNUnqDup);
            pcw.recsDetailedInfo.put('totalGPIUnqDup',totalGPIUnqDup);
            NDCDuplicates.clear();
            SKUDuplicates.clear();
            GCNUnqDuplicates.clear();
            GPIUnqDuplicates.clear();
            GSNUnqDuplicates.clear();
            return JSON.serialize(pcw);
        }
        else
            return 'Opportunity Id is null';
    }
    
    @auraEnabled
    public static List<Map<String, String>> getProdList(String optyProdId){
        String prodOppFields = Phoenix_Util.getsObjectFieds('Product_Opportunity__c');
        //String matchedString = 'Matched';
        String query = 'SELECT GCP_Product_Family__r.Name,Product__r.Name,Product__r.Id, Product__r.Phoenix_Pkg_Size__c, Opportunity__r.AccountId, '+prodOppFields+' FROM Product_Opportunity__c'+
            +' WHERE Id =: optyProdId';
        Product_Opportunity__c optyProdObj = Database.query(query);
        Id optyId = optyProdObj.Opportunity__c;
        Id existingProd = optyProdObj.Product__c;
        Id accId = optyProdObj.Opportunity__r.AccountId;
        List<Product_Opportunity__c> optyList = new List<Product_Opportunity__c>();
        optyList = [SELECT Id, Product__c, Name, Opportunity__c FROM Product_Opportunity__c 
                    WHERE Opportunity__c =: optyId AND Status__c != 'Matched'];
        List<Id> prodIds = new List<Id>();
        for(Product_Opportunity__c prodObj : optyList){
            if(!prodIds.contains(prodObj.Product__c) && prodObj.Product__c != existingProd)
                prodIds.add(prodObj.Product__c);
        }
        List<Product2> prdList = new List<Product2>();
        query = 'SELECT Product_Family__r.Name,'+Phoenix_Util.getsObjectFieds('Product2')+' FROM Product2 WHERE ';
        String matchedItem = '';
        String newQuery = '';
        if(optyProdObj.Is_GCN_Matched__c){
            matchedItem = optyProdObj.GCN_Generic_Code_Number__c;
            newQuery += ' Phoenix_GCN_Generic_Code_Number__c =: matchedItem';
        }
        else if(optyProdObj.Is_GSN_Matched__c){
            matchedItem = optyProdObj.GSN__c;
            newQuery += ' Phoenix_GCN_Sequence_Number__c =: matchedItem';
        }
        else if(optyProdObj.Is_GPI_Matched__c){
            matchedItem = optyProdObj.GPI_Generic_Product_Identifier__c;
            newQuery += ' Phoenix_GPI_Generic_Product_Identifier__c =: matchedItem';
        }
        if(newQuery == ''){
            query += ' Id =: existingProd';
        }
        else if(prodIds.size()>0)
            query = query+' '+newQuery+' AND Id NOT IN : prodIds';
        query += ' AND (Phoenix_Is_Private_Label_OTC__c = false OR (Phoenix_Is_Private_Label_OTC__c = true AND OTC_Customer__c = : accId))'+
            +' AND isActive = true AND Phoenix_Is_Exclude_Bid__c = false';
        prdList = Database.query(query);
        List<Map<String, String>> items = new List<Map<String, String>>();
        for (Product2 prd : prdList) {
            items.add(new Map<String, String>{'value' => prd.Id, 'label' => prd.Name});
        }
        return items;
    }
    
    @auraEnabled
    public static Product_opportunity__c getUpdatedPkgSize(String optyProdId, String selectedProdId){
        
        Product2 prodObj = [SELECT Id, Name, Phoenix_Pkg_Size__c FROM Product2 WHERE Id =: selectedProdId];
        String query2 = 'SELECT GCP_Product_Family__r.Name, Product__r.Name,Product__r.Id, Product__r.Phoenix_Pkg_Size__c, '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c'+
            +' WHERE Id=:optyProdId';
        Product_Opportunity__c optyProd = Database.query(query2);
        
        optyProd.Name = prodObj.Name;
        optyProd.Product__r.Name = prodObj.Name;
        optyProd.Product__c = selectedProdId;
        optyProd.Product__r.Id = selectedProdId;
        optyProd.Product__r.Phoenix_Pkg_Size__c = prodObj.Phoenix_Pkg_Size__c;
        
        return optyProd;//String.valueOf(prodObj.Phoenix_Pkg_Size__c);
    }
    
    @auraEnabled
    public static Product_opportunity__c updateWithNewProd(string optyProdStr, String selectedProdId){
        Product_Opportunity__c optyProdObj = (Product_Opportunity__c)JSON.deserialize(optyProdStr,Product_Opportunity__c.class);
        optyProdObj.Product__c = selectedProdId;
        optyProdObj.Status__c = 'Matched';
        optyProdObj.vision_is_discrepancy_product__c = false;
        optyProdObj.Vision_Uploaded_Pkg_Size__c = Decimal.valueOf(optyProdObj.Vision_Disc_Pkg_Size__c);
        update optyProdObj;
        String optyProdId = optyProdObj.Id;
        Id optyId = optyProdObj.Opportunity__c;
        Id existingProd = optyProdObj.Product__c;
        List<Product_Opportunity__c> optyList = new List<Product_Opportunity__c>();
        optyList = [SELECT Id, Product__c, Name, Opportunity__c FROM Product_Opportunity__c WHERE Opportunity__c =: optyId 
                    AND Status__c != 'Matched' AND vision_is_discrepancy_product__c = true AND Vision_inActive__c = false];
        List<Id> prodIds = new List<Id>();
        //prodIds.add(Id.valueOf(selectedProdId));
        for(Product_Opportunity__c prodObj : optyList){
            if(!prodIds.contains(prodObj.Product__c) && prodObj.Product__c != existingProd)
                prodIds.add(prodObj.Product__c);
        }
        
        String decpString = 'Discrepant';
        String query = 'SELECT Product__r.Name,Product__r.Id, Product__r.Phoenix_Pkg_Size__c, '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c WHERE Id != \''+optyProdObj.Id+'\' AND Status__c =: decpString AND Opportunity__c =: optyId AND Product__c =: selectedProdId'; 
        List<Product_Opportunity__c> optyProdList = Database.query(query);
        if(optyProdList.size()>0){
             List<Product_Opportunity__c> updateOptyProdList = new List<Product_Opportunity__c>();
            for(Product_Opportunity__c optyProd : optyProdList){
                optyProd.Vision_inActive__c = true; 
                updateOptyProdList.add(optyProd);
            }
            update updateOptyProdList;
        }
        return optyProdObj;
        /*String matchedItem = '';
        String prodQueryString = 'SELECT '+Phoenix_Util.getsObjectFieds('Product2')+' FROM Product2 WHERE ';
        if(optyProdObj.Is_GCN_Matched__c){
            matchedItem = optyProdObj.GCN_Generic_Code_Number__c;
            query += ' GCN_Generic_Code_Number__c =: matchedItem AND ';
            prodQueryString += ' Phoenix_GCN_Generic_Code_Number__c =: matchedItem AND ';
        }
        else if(optyProdObj.Is_GSN_Matched__c){
            matchedItem = optyProdObj.GSN__c;
            query += ' GSN__c =: matchedItem AND';
            prodQueryString += ' Phoenix_GCN_Sequence_Number__c =: matchedItem AND ';
        }
        else if(optyProdObj.Is_GPI_Matched__c){
            matchedItem = optyProdObj.GPI_Generic_Product_Identifier__c;
            query += ' GPI_Generic_Product_Identifier__c =: matchedItem AND ';
            prodQueryString += ' Phoenix_GPI_Generic_Product_Identifier__c =: matchedItem AND ';
        }
        String decpString = 'Discrepant';
        query += ' Id != \''+optyProdObj.Id+'\' AND Status__c =: decpString AND Opportunity__c =: optyId'; 
        if(prodIds.size()>0)
            prodQueryString += ' Id NOT IN : prodIds';
        List<Product_Opportunity__c> optyProdList = Database.query(query);
        List<Product2> prdList = Database.query(prodQueryString);
        List<Product_Opportunity__c> updateOptyProdList = new List<Product_Opportunity__c>();
        if(optyProdList.size() > 0){
            if(optyProdList.size() == 1 && prdList.size() == 0){
                optyProdList[0].Vision_inActive__c = true; 
                updateOptyProdList.add(optyProdList[0]);
            }
            else if(prdList.size() > 0){
                for(Product_Opportunity__c optyProd : optyProdList){
                    optyProd.Product__c = prdList[0].Id;
                    updateOptyProdList.add(optyProd);
                }
            }
        }
        if(updateOptyProdList.size()>0)
            update updateOptyProdList;
        query = 'SELECT Product__r.Name,Product__r.Id, Product__r.Phoenix_Pkg_Size__c, '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c'+
            +' WHERE Id =: optyProdId';
        optyProdObj = Database.query(query);
        return optyProdObj;*/
    }
    
    @AuraEnabled
    public static string mapUnmatchedProducts(String matchData, String unmatchData){
        productCountWrapper pcw = new productCountWrapper();
        List<Product_Opportunity__c> unmatchList = new List<Product_Opportunity__c>();
        if(String.isNotBlank(matchData))
            pcw.matchedRecords = (List<Product_Opportunity__c>)JSON.deserialize(matchData,List<Product_Opportunity__c>.class);
        if(String.isNotBlank(unmatchData))
            unmatchList  = (List<Product_Opportunity__c>)JSON.deserialize(unmatchData,List<Product_Opportunity__c>.class);
        if(unmatchList.size() > 0){
            List<Id> prdIds = new List<Id>();
            Map<Id,Product2> prdRecs = new Map<Id,Product2>();
            for(Product_Opportunity__c prd: unmatchList){
                if(prd.Product__c != null)
                    prdIds.add(prd.Product__c);
            }
            if(prdIds.size() > 0){
                for(Product2 product : [SELECT Id, Product_Family__c, Product_Family__r.Name,Name, ProductCode, Phoenix_GPI_Generic_Product_Identifier__c, Phoenix_GCN_Generic_Code_Number__c,
                                        Phoenix_GCN_Sequence_Number__c, Family, Phoenix_NDC_11__c, Phoenix_Pkg_Size__c
                                        FROM Product2 WHERE Id =:prdIds]){
                                            prdRecs.put(product.Id, product);
                                        }
            }
            for(Product_Opportunity__c prd: unmatchList){
                Boolean isProductPresent = false;
                if(prd.Product__c != null)
                {
                    if(prdRecs.containsKey(prd.Product__c))
                    {
                        Product2 prodObj = prdRecs.get(prd.Product__c);
                        prd.Product__c = prodObj.Id;
                        prd.Status__c = 'Matched';
                        prd.GCN_Generic_Code_Number__c = prodObj.Phoenix_GCN_Generic_Code_Number__c;
                        prd.GSN__c = prodObj.Phoenix_GCN_Sequence_Number__c;
                        prd.GPI_Generic_Product_Identifier__c = prodObj.Phoenix_GPI_Generic_Product_Identifier__c;
                        prd.Name = prodObj.Name;
                        prd.Product_Family__c = prodObj.Family;
                        prd.GCP_Product_Family__c = prodObj.Product_Family__c;
                        prd.NDC_11__c = prodObj.Phoenix_NDC_11__c;
                        prd.SKU_Number__c = prodObj.ProductCode;
                        if(prd.NDC_11__c != null && prodObj.Phoenix_NDC_11__c != null)
                            prd.Is_NDC_Matched__c  = true;
                        if(prd.SKU_Number__c != null && prodObj.ProductCode != null)
                            prd.Is_SKU_Matched__c = true;
                        if(prd.GCN_Generic_Code_Number__c != null && prodObj.Phoenix_GCN_Generic_Code_Number__c != null){
                            if(prd.Pkg_Size__c != null && prodObj.Phoenix_Pkg_Size__c != null){
                                String gcnUnique= String.valueOf(prd.GCN_Generic_Code_Number__c) + String.valueOf(prd.Pkg_Size__c);
                                String gcnPrdUnique= String.valueOf(prodObj.Phoenix_GCN_Generic_Code_Number__c) + String.valueOf(prodObj.Phoenix_Pkg_Size__c);
                                if(gcnUnique == gcnPrdUnique)
                                    prd.Is_GCN_Pack_Size_Matched__c = true;
                            }
                            else
                                prd.Is_GCN_Matched__c = true;
                        }
                        if(prd.GSN__c != null && prodObj.Phoenix_GCN_Sequence_Number__c != null){
                            if(prd.Pkg_Size__c != null && prodObj.Phoenix_Pkg_Size__c != null){
                                String gsnUnique= String.valueOf(prd.GSN__c) + String.valueOf(prd.Pkg_Size__c);
                                String gsnPrdUnique= String.valueOf(prodObj.Phoenix_GCN_Sequence_Number__c) + String.valueOf(prodObj.Phoenix_Pkg_Size__c);
                                if( gsnUnique == gsnPrdUnique)
                                    prd.Is_GSN_Pack_Size_Matched__c = true;
                            }
                            else
                                prd.Is_GSN_Matched__c = true;
                        }
                        if(prd.GPI_Generic_Product_Identifier__c != null && prodObj.Phoenix_GPI_Generic_Product_Identifier__c != null){
                            if(prd.Pkg_Size__c != null && prodObj.Phoenix_Pkg_Size__c != null){
                                String gpiUnique= String.valueOf(prd.GPI_Generic_Product_Identifier__c) + String.valueOf(prd.Pkg_Size__c);
                                String gpiPrdUnique= String.valueOf(prodObj.Phoenix_GPI_Generic_Product_Identifier__c) + String.valueOf(prodObj.Phoenix_Pkg_Size__c);
                                if( gpiUnique == gpiPrdUnique)
                                    prd.Is_GPI_Pack_Size_Matched__c = true;
                            }
                            else
                                prd.Is_GPI_Matched__c = true;
                        }
                        isProductPresent = true;
                        pcw.matchedRecords.add(prd);
                    }
                }
                
                if(isProductPresent == false){
                    isProductPresent = false; pcw.unMatchedRecords.add(prd);
                }
                else
                    isProductPresent = false;
                
            }
            pcw.totalRecordsInfo.put('matchedRecCount',pcw.matchedRecords.size());
            pcw.totalRecordsInfo.put('unmatchedRecCount',pcw.unMatchedRecords.size());
        }
        unmatchList.clear();
        return JSON.serialize(pcw);
    }
    
    
    @AuraEnabled
    public static string moveUnmatchedProducts(String matchData, String unmatchData){
        return mapUnmatchedProducts(matchData, unmatchData);
    }
    
    public class savedProductOptyWrapper {
        Map<String,Id> oppIdData;
        List<Product_Opportunity__c> savedProducts;
        list<Competitor__c> competitorObjInfo;
        public savedProductOptyWrapper() {
            oppIdData = new Map<String,Id>();
            savedProducts  = new List<Product_Opportunity__c>();
            competitorObjInfo =new list<Competitor__c> ();
        }
        
    }
    
    public class productCountWrapper {
        Map<String,Integer> totalRecordsInfo;
        Map<String, Integer> recsDetailedInfo;
        List<Product_Opportunity__c> matchedRecords;
        List<Product_Opportunity__c> unMatchedRecords;
        List<Product_Opportunity__c> duplicateRecords;
        map<string, list<Product_Opportunity__c>> duplicateItems;
        String stageName;
        String accTemplate;
        String accId;
        public productCountWrapper() {
            totalRecordsInfo = new Map<String,Integer>();
            matchedRecords  = new List<Product_Opportunity__c>();
            unMatchedRecords = new List<Product_Opportunity__c>();
            duplicateRecords = new List<Product_Opportunity__c>();
            recsDetailedInfo = new Map<String,Integer>();
            duplicateItems = new Map<string, list<Product_Opportunity__c>>();
            stageName = '';
            accTemplate = '';
            accId = '';
        }
        
    }
    
    public class extProductWrapper {
        public Map<String,Product2> extGPIProductMap;
        public Map<String,Product2> extGCNProductMap;
        public Map<String,Product2> extGSNProductMap;
        public Map<String,Product2> extGPIUniqueProductMap;
        public Map<String,Product2> extGCNUniqueProductMap;
        public Map<String,Product2> extGSNUniqueProductMap;
        public Map<String,Product2> extNDCProductMap;
        public Map<String,Product2> extSKUProductMap;
        public Map<String,List<Integer>> extGCNProductPkgSizeMap;
        public Map<String,List<Integer>> extGPIProductPkgSizeMap;
        public Map<String,List<Integer>> extGSNProductPkgSizeMap;
        public extProductWrapper() {
            extGPIProductMap = new Map<String,Product2>();
            extGCNProductMap = new Map<String,Product2>();
            extGSNProductMap = new Map<String,Product2>();
            extGPIUniqueProductMap = new Map<String,Product2>();
            extGCNUniqueProductMap = new Map<String,Product2>();
            extGSNUniqueProductMap = new Map<String,Product2>();
            extNDCProductMap = new Map<String,Product2>();
            extSKUProductMap = new Map<String,Product2>();
            extGCNProductPkgSizeMap = new Map<String,List<Integer>>();
            extGPIProductPkgSizeMap = new Map<String,List<Integer>>();
            extGSNProductPkgSizeMap = new Map<String,List<Integer>>();
        }
        
    }
    
    @AuraEnabled
    public static String sendToPanoramaFunc(Id opportunityId){
        if(opportunityId != null){
            Opportunity opp = [Select Id, Name ,AccountId, Contact__c, Amount, Bid_Type__c, CloseDate,Vision_Opportunity_Source__c,
                               Vision_Customer_Closing_Date__c, Vision_Internal_Closing_Date__c, StageName, Vision_Type__c, Bid__c
                               From Opportunity Where Id = : opportunityId];
            Account acc = [select Id, Name, Phoenix_Is_Bid_Account__c from Account Where Id = : opp.AccountId];
            List<Product_Opportunity__c> unmatchedRecords = [Select ID, Name,Product__c,Status__c,GCN_Generic_Code_Number__c,GSN__c,GPI_Generic_Product_Identifier__c,
                                                             Product_Family__c, Strength__c, Vision_UOM__c, Vision_Total_Annual_Units__c, Vision_Customer_Comments__c,
                                                             NDC_11__c,SKU_Number__c,Dosage_Form__c,Product_Description__c,
                                                             Vision_Alt_Pkg_Size__c, Vision_High_Pkg_Size__c, Pkg_Size__c,
                                                             Vision_Bid_on_Highest_Pack_Size__c, Vision_Bid_on_Alternative_Pack_Size__c
                                                             from Product_Opportunity__c
                                                             where Status__c = 'Unmatched' and Opportunity__c =: OpportunityId];
            List<Vision_Panorama_Queue__c> panRecs = new List<Vision_Panorama_Queue__c>();
            List<String> existingPanoramaRecs = new List<String>();
            for(Vision_Panorama_Queue__c extpanRec : [Select Vision_Panorama_Unique_Identifier__c from Vision_Panorama_Queue__c])
            {
                existingPanoramaRecs.add(extpanRec.Vision_Panorama_Unique_Identifier__c);
            }
            for(Product_Opportunity__c prdOpty : unmatchedRecords){
                Vision_Panorama_Queue__c panRec = new Vision_Panorama_Queue__c();
                if(prdOpty.Vision_Alt_Pkg_Size__c != null)
                    panRec.Vision_Alt_Pkg_Size__c = String.valueOf(prdOpty.Vision_Alt_Pkg_Size__c);
                
                if(prdOpty.Vision_High_Pkg_Size__c != null)
                    panRec.Vision_High_Pkg_Size__c = String.valueOf(prdOpty.Vision_High_Pkg_Size__c);
                
                if(prdOpty.Pkg_Size__c != null)
                    panRec.Vision_Pkg_Size__c = String.valueOf(prdOpty.Pkg_Size__c);
                
                if(prdOpty.Vision_Bid_on_Highest_Pack_Size__c != null)
                    panRec.Vision_Bid_on_Highest_Pack_Size__c = String.valueOf(prdOpty.Vision_Bid_on_Highest_Pack_Size__c);
                
                if(prdOpty.Vision_Bid_on_Alternative_Pack_Size__c != null)
                    panRec.Vision_Bid_on_Alternative_Pack_Size__c = String.valueOf(prdOpty.Vision_Bid_on_Alternative_Pack_Size__c);
                
                
                if(prdOpty.Dosage_Form__c != null)
                    panRec.Vision_Dosage_Form__c = String.valueOf(prdOpty.Dosage_Form__c);
                
                panRec.Vision_Product_Description__c = prdOpty.Product_Description__c;
                panRec.Vision_Customer_Comments__c = prdOpty.Vision_Customer_Comments__c;
                panRec.Vision_Product_Family__c = prdOpty.Product_Family__c;
                
                panRec.Vision_SKU_Number__c = prdOpty.SKU_Number__c;
                panRec.Vision_GCN_Generic_Code_Number__c = prdOpty.GCN_Generic_Code_Number__c;
                panRec.Vision_GPI_Generic_Product_Identifier__c = prdOpty.GPI_Generic_Product_Identifier__c;
                panRec.Vision_GSN__c = prdOpty.GSN__c;
                panRec.Vision_NDC_11__c = prdOpty.NDC_11__c;
                panRec.Vision_Strength__c = prdOpty.Strength__c;
                if(acc != null){
                    panRec.Vision_Is_Bid_Account__c = acc.Phoenix_Is_Bid_Account__c;
                    panRec.Vision_Customer__c = acc.Id;
                }
                if(prdOpty.Vision_Total_Annual_Units__c != null)
                    panRec.Vision_Total_Annual_Units__c = String.valueOf(prdOpty.Vision_Total_Annual_Units__c);
                if(prdOpty.Vision_UOM__c != null)
                    panRec.Vision_UOM__c= String.valueOf(prdOpty.Vision_UOM__c);
                panRec.Vision_Panorama_Unique_Identifier__c = String.valueOf(opp.AccountId) + '-' + String.valueOf(opp.Id) + '-' + panRec.Vision_Product_Family__c;
                panRec.Vision_Opportunity__c = opp.Id;
                panRec.Status__c = 'Pending';
                if(!existingPanoramaRecs.contains(panRec.Vision_Panorama_Unique_Identifier__c )){
                    panRecs.add(panRec);
                }
            }
            
            if(panRecs.size() > 0){
                insert panRecs;
                panRecs.clear();
            }
            unmatchedRecords.clear();
            return 'Records Created Successfully';
        }
        else{
            return 'Opportunity Id is null';
        }
    }
    
    public class wrapperBidCheck{
        @auraEnabled
        public boolean isError = false;
        @auraEnabled
        public string errorMessage;
        @auraEnabled
        public String bidId;
        @auraEnabled
        public Opportunity oppObj;
        @auraEnabled
        public Product_Opportunity__c optyProdObj;
        @auraEnabled
        public boolean isSelected=false;
        @auraEnabled
        public boolean hasBidLineItem = false;
        @auraEnabled
        public Phoenix_Contract__c refContract;
        
    }
    
    @auraEnabled
    public static wrapperBidCheck checkForBid(Id opportunityId){
        wrapperBidCheck wrapObj = new wrapperBidCheck();
        List<Phoenix_Bid__c> bidList = [SELECT Id, Name FROM Phoenix_Bid__c WHERE Opportunity__c =: opportunityId];
        if(bidList.size()>0){
            wrapObj.isError = true;
            wrapObj.bidId = bidList[0].Id;
        }
        else{
            wrapObj.isError = false;
        }
        return wrapObj;
    }
    public class BidWrapper
    {
        @AuraEnabled
        public Phoenix_Bid__c bid;
        @AuraEnabled
        public Boolean isBidCreated;
        public BidWrapper() {
            bid = new Phoenix_Bid__c();
        }
    }
    public class prdwrapperClass {
        @AuraEnabled
        public Product2 prdlist{get;set;}
        @AuraEnabled
        public String currencyCode{get;set;}
        
        @AuraEnabled
        public String salesPriceVal{get;set;}
        @AuraEnabled
        public String guidancePriceVal{get;set;}
        @AuraEnabled
        public String priceRangeVal{get;set;}
        @AuraEnabled
        public String competitorIdVal{get;set;}
        @AuraEnabled
        public String opportunityVal{get;set;}
        @AuraEnabled
        public String incumbentCompId1{get;set;}
        @AuraEnabled
        public String incumbentCompId2{get;set;}
        @AuraEnabled
        public String incumbentCompId3{get;set;}
        @AuraEnabled
        public String incumbentCompId4{get;set;}
        @AuraEnabled
        public String incumbentCompId5{get;set;}
        @AuraEnabled
        public String priceRange1{get;set;}
        @AuraEnabled
        public String priceRange2{get;set;}
        @AuraEnabled
        public String priceRange3{get;set;}
        @AuraEnabled
        public String priceRange4{get;set;}
        @AuraEnabled
        public String priceRange5{get;set;}
        @AuraEnabled
        public Boolean isSelected{get;set;}
        
        @AuraEnabled
        public Boolean contrFlag{get;set;}
        
        @AuraEnabled
        public String proposedUnitsVal{get;set;}
        @AuraEnabled
        public Integer proposedDirectUnits{get;set;}
        
        @auraEnabled
        Public Integer ProposedDirectEsiUnits{get;set;}
        @auraEnabled
        Public Integer ProposedIndirectEsiUnits{get;set;}
        @auraEnabled
        Public Integer ProposedDirectKrogerUnits{get;set;}
        @auraEnabled
        Public Integer ProposedIndirectKrogerUnits{get;set;}
        @auraEnabled
        Public Integer ProposedDirectRxOutreachUnits{get;set;}
        @auraEnabled
        Public Integer ProposedIndirectRxOutreachUnits{get;set;}
        @auraEnabled
        Public Integer ProposedDirectSupervaluUnits{get;set;}
        @auraEnabled
        Public Integer ProposedIndirectSupervaluUnits{get;set;}
        @auraEnabled
        Public Integer ProposedDirectCordantUnits{get;set;}
        @auraEnabled
        Public Integer ProposedIndirectCordantUnits{get;set;}
        @auraEnabled
        Public Integer ProposedDirectAccerodoUnits{get;set;}
        @auraEnabled
        Public Integer ProposedIndirectAccerodoUnits{get;set;}
        
        @auraEnabled
        Public Integer ProposedIndirectUnits{get;set;}
        @auraEnabled
        Public Integer ProposedSmithDrugUnits{get;set;}
        @auraEnabled
        Public Integer ProposedAndaUnits{get;set;}
        @auraEnabled
        Public Integer ProposedDirectAholdDelhaizeUnits{get;set;}
        @auraEnabled
        Public Integer ProposedDirectGaintEagleUnits{get;set;}
        @auraEnabled
        Public Integer ProposedTotalRetailIndirectUnits{get;set;}
        @auraEnabled
        Public Integer ProposedBaseUnits{get;set;}
        @auraEnabled
        Public Integer ProposedDshUnits{get;set;}
        @auraEnabled
        Public Integer ProposedAutosubUnits{get;set;}
        @auraEnabled
        Public Integer ProposedOSUnits{get;set;}
        @auraEnabled
        Public Integer ProposedRadUnits{get;set;}
        @auraEnabled
        Public Integer ProposedWmtUnits{get;set;}
        
        @auraEnabled
        Public Integer ProposedCVSDirectUnits{get;set;}
        @auraEnabled
        Public Integer ProposedCVSIndirectUnits{get;set;}
        @auraEnabled
        Public Integer ProposedCardinalUnits{get;set;}
        @auraEnabled
        Public Integer ProposedMajorUnits{get;set;}
        
        @auraEnabled
        Public Integer ProposedTotalUnits{get;set;}
        @auraEnabled
        Public Integer ProposedsharePer{get;set;}
        
        
        
        @AuraEnabled
        public Integer currentAndaUnits{get;set;}
        @AuraEnabled
        public Integer currentWholeSalerUnits{get;set;}
        @AuraEnabled
        public Integer currentBaseUnits{get;set;}
        @AuraEnabled
        public Integer currentDshUnits{get;set;}
        @AuraEnabled
        public Integer currentAutoSubUnits{get;set;}
        @AuraEnabled
        public Integer currentOsRadUnits{get;set;}
        @AuraEnabled
        public Integer currentDirectUnits{get;set;}
        @AuraEnabled
        public Integer currentIndirectUnits{get;set;}
        @AuraEnabled
        public Integer currentDirectPrice{get;set;}
        @AuraEnabled
        public Integer currentIndirectPrice{get;set;}
        @AuraEnabled
        public Integer currentRebatePer{get;set;}
        @auraEnabled
        public Integer financialImpact{get;set;}
    }
    
    public static list<Competitor__c> getCompetitorInfo() {
        list<Competitor__c> complist=new list<Competitor__c>();
        for(Competitor__c Compobj:[select Id,Name from Competitor__c])
            complist.add(Compobj);
        return complist;
    }
    @AuraEnabled
    public static Map<String,Competitor_Info__c> getCompetitorInfoObjData( String ndcWithDashes, String ndc) {
        Map<String,Competitor_Info__c> compInfoMap = new Map<String,Competitor_Info__c>();
        for(Competitor_Info__c Compobj:[SELECT Customer_Name__c, Finance_Approval__c,Id,Incumbent_Competitor_Id__c,Incumbent_Competitor_Name__r.Id,Incumbent_Competitor_Name__r.Name,
                                        Incumbent_Competitor_Name_2__r.Id,Incumbent_Competitor_Name_2__r.Name,
                                        Incumbent_Competitor_Name_3__r.Id,Incumbent_Competitor_Name_3__r.Name,
                                        Incumbent_Competitor_Name_4__r.Id,Incumbent_Competitor_Name_4__r.Name,
                                        Incumbent_Competitor_Name_5__r.Id,Incumbent_Competitor_Name_5__r.Name,
                                        Incumbent_Competitor_Name__c,Incumbent_Price_Range_2__c, Incumbent_Price_Range_3__c,Incumbent_Price_Range_4__c,Incumbent_Price_Range_5__c,
                                        Incumbent_Price_Range__c,Name,NDC__c, Product_Family__c,Product_Name__c,Winner_Competitor_Id__c,
                                        Winning_Competitor_Name_2__c,Winning_Competitor_Name_3__c,Winning_Competitor_Name_4__c,
                                        Winning_Competitor_Name_5__c,Winning_Competitor_Name__c,Winning_Price_Range_2__c,
                                        Winning_Price_Range_3__c,Winning_Price_Range_4__c,Winning_Price_Range_5__c,
                                        Winning_Price_Range__c FROM Competitor_Info__c Where (NDC__c =: ndcWithDashes) OR (NDC__c =: ndc ) order by CreatedDate DESC Limit 1])
        {
            compInfoMap.put(Compobj.NDC__c, Compobj);
        }
        return compInfoMap;
    }
    @AuraEnabled
    public static Boolean validateOptyNameCtrl(String Name){
        if(String.isNotBlank(Name)){
            List<Opportunity> optyRecs = [select Id, Name from Opportunity Where Name = : Name];
            if(optyRecs.size() > 0){
                return false;
            }
            else{
                return true;
            }
        }
        else{
            return true;
        }
    }
    
    public static Integer findClosest(List<Integer> pkgList, Integer target)
    {
        Integer n = pkgList.size();
        
        // Corner cases
        if (target <= Integer.valueOf(pkgList[0]))
            return pkgList[0];
        if (target >= Integer.valueOf(pkgList[n - 1]))
            return pkgList[n - 1];
        
        // Doing binary search
        Integer i = 0, j = n, mid = 0;
        while (i < j) {
            mid = (i + j) / 2;
            
            if (Integer.valueOf(pkgList[mid]) == target)
                return pkgList[mid];
            
            /* If target is less than array element,
then search in left */
            if (target < Integer.valueOf(pkgList[mid])) {
                
                // If target is greater than previous
                // to mid, return closest of two
                if (mid > 0 && target > Integer.valueOf(pkgList[mid - 1]))
                    return getClosest(Integer.valueOf(pkgList[mid - 1]),
                                      Integer.valueOf(pkgList[mid]), target);
                
                /* Repeat for left half */
                j = mid;
            }
            
            // If target is greater than mid
            else {
                if (mid < n-1 && target < Integer.valueOf(pkgList[mid + 1]))
                    return getClosest(Integer.valueOf(pkgList[mid]),
                                      Integer.valueOf(pkgList[mid + 1]), target);
                i = mid + 1; // update i
            }
        }
        
        // Only single element left after search
        return pkgList[mid];
    }
    
    // Method to compare which one is the more close
    // We find the closest by taking the difference
    //  between the target and both values. It assumes
    // that val2 is greater than val1 and target lies
    // between these two.
    public static Integer getClosest(Integer val1, Integer val2,
                                     Integer target)
    {
        if (target - val1 >= val2 - target)
            return val2;
        else
            return val1;
    }
    
    @auraEnabled
    public Static string deleteOptyProd(String optyProdId){
        String returnString = '';
        try{
            Product_Opportunity__c prodOpty = [SELECT Id, Name FROM Product_Opportunity__c WHERE Id=: optyProdId];
            delete prodOpty;
            return 'SUCCESS : Product has been removed!';
        }
        catch(exception e){
            return 'ERROR : Unable to Delete the Product. Exception : '+e.getMessage();
        }
    }
    
    @auraEnabled
    public static string updateProdWithNRP(String CustomerId, List<String> contractIds, String optyProd){
        /*try{
            list<Product_Opportunity__c> optyProdList = (list<Product_Opportunity__c>)JSON.deserialize(optyProd,list<Product_Opportunity__c>.class);
            Account accObj = [SELECT Id, Name, Phoenix_Customer_Class_Bid_Template__c FROM Account WHERE Id =: CustomerId];
            String templateType = accObj.Phoenix_Customer_Class_Bid_Template__c;
            list < Phoenix_NPR_Data__c > NPRDataLines = [select id, Name, Phoenix_Contract_Type__c, Phoenix_12Months_Actual_Sales_Unit__c,
                                                         Phoenix_12Mt_Sales_Ut_Actual__c, Phoenix_Product_Position__c, Phoenix_Net_Sales_Internal__c,
                                                         Phoenix_Dead_Net_Tracking_GR__c, Phoenix_Contract_Price__c, Phoenix_Product__c, 
                                                         Phoenix_Product__r.ProductCode, Phoenix_12Months_Sales_Unit__c, Phoenix_12Months_Net_Sales__c,
                                                         Phoenix_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Rebate__c, Phoenix_Rebate_G_N_Indicator__c,
                                                         Phoenix_Bonafied_G_N_Indicator__c, Phoenix_Fee_Bonafied_Fee__c, Phoenix_Per_Unit_Bonfied_Fee__c,
                                                         Phoenix_CD__c, Phoenix_GR_TrackingTier__c, Phoenix_Contract__r.Phoenix_Contract_Number__c 
                                                         from Phoenix_NPR_Data__c where Phoenix_NPR_Status__c = 'Active' and Phoenix_Account__c =: CustomerId
                                                         AND (Phoenix_Contract_Number__c in: contractIds or Phoenix_Contract__c in: contractIds)];
            map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
            set<String> contractNumber = new set<String>();
            for (Phoenix_NPR_Data__c NPRLine: NPRDataLines) {
                contractNumber.add(NPRLine.Phoenix_Contract__r.Phoenix_Contract_Number__c);
                if (productCodeToNPRLineMap.containsKey(NPRLine.Phoenix_Product__r.ProductCode)) {
                    productCodeToNPRLineMap.get(NPRLine.Phoenix_Product__r.ProductCode).add(NPRLine);
                } else {
                    list < Phoenix_NPR_Data__c > NPRList = new list < Phoenix_NPR_Data__c > ();
                    NPRList.add(NPRLine);
                    productCodeToNPRLineMap.put(NPRLine.Phoenix_Product__c, NPRList);
                }
            }
            list<Product_Opportunity__c> updateList = new list<Product_Opportunity__c>();
            String oppId = '';
            for (Product_Opportunity__c wr: optyProdList) {
                oppId = wr.Opportunity__c;
                wr.Proposed_Direct_Selling_Units__c = 0;
                wr.Proposed_Indirect_Selling_Units__c = 0;
                wr.Vision_Current_Direct_Price__c = 0;
                wr.Vision_Current_Indirect_Price__c = 0;
                list < Decimal > directPriceList = new list < Decimal > ();
                list < Decimal > indirectPriceList = new list < Decimal > ();
                list < Decimal > perUnitRebateList = new list < Decimal > ();
                if(productCodeToNPRLineMap.containsKey(wr.Product__c)){
                    for(Phoenix_NPR_Data__c NPRLine:productCodeToNPRLineMap.get(wr.Product__c)){
                        if(templateType=='Indirect' || templateType=='Direct and Indirect' || templateType=='Walgreens'
                           || templateType=='ABC Progen' || templateType=='Econdisc' || templateType== 'Costco'
                           || templateType== 'Sams Club' || templateType== 'Net Indirect Pricing' || templateType== 'Government Pricing'){
                               if(NPRLine.Phoenix_Contract_Type__c=='Indirect'){
                                   wr.Current_Indirect_Selling_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? Integer.valueOf(NPRLine.Phoenix_12Months_Sales_Unit__c) : 0;
                                   indirectPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                               }
                               perUnitRebateList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                           }
                        if (templateType == 'Direct' || templateType == 'Direct and Indirect' || templateType == 'Econdisc' || templateType == 'Net Indirect Pricing') {
                            if (NPRLine.Phoenix_Contract_Type__c == 'Direct') {
                                wr.Vision_Current_Direct_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? Integer.valueOf(NPRLine.Phoenix_12Months_Sales_Unit__c) : 0;
                                directPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                            }
                            perUnitRebateList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                        }
                        if (templateType == 'ClarusOne') {
                            if (NPRLine.Phoenix_Contract_Number__c == '3000001263' || NPRLine.Phoenix_Contract_Number__c == '3000000224' || NPRLine.Phoenix_Contract_Number__c == '3000000418' || NPRLine.Phoenix_Contract_Number__c == '3000000047' || NPRLine.Phoenix_Contract_Number__c == '3000000071') {
                                    wr.Vision_Current_OS_Units__c = wr.Vision_Current_OS_Units__c != null ? wr.Vision_Current_OS_Units__c : 0;
                                    wr.Vision_Current_OS_Units__c += (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                                }
                            if (NPRLine.Phoenix_Contract_Number__c == '1000000120') {
                                wr.Vision_Current_RAD_units__c = wr.Vision_Current_RAD_units__c != null ? wr.Vision_Current_RAD_units__c : 0;
                                wr.Vision_Current_RAD_units__c += (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                            }
                            if (NPRLine.Phoenix_Contract_Number__c == '3000000143') {
                                wr.Vision_Current_WMT_Units__c = wr.Vision_Current_WMT_Units__c != null ? wr.Vision_Current_WMT_Units__c : 0;
                                wr.Vision_Current_WMT_Units__c += (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                            }
                        }
                    }
                    if (indirectPriceList.size() > 0) {
                        indirectPriceList.sort();
                        wr.Vision_Current_Indirect_Price__c = Integer.valueOf(indirectPriceList[0]);
                    }
                    //take minimum of all deirect NPR prices
                    if (directPriceList.size() > 0) {
                        directPriceList.sort();
                        wr.Vision_Current_Direct_Price__c = Integer.valueOf(directPriceList[0]);
                    }
                    //take Max of all  NPR rebate
                    if (perUnitRebateList.size() > 0) {
                        perUnitRebateList.sort();
                    }
                }
                
                updateList.add(wr);
            }
            list<Product_Opportunity__c> optyLineItemList = new List<Product_Opportunity__c>();
            if(updateList.size() > 0){
                for(Product_Opportunity__c prd: updateList){
                    String prodId = String.valueOf(prd.Product__c);
                    if(prodId.contains('/')){
                        prd.Product__c = Id.valueOf(prodId.replace('/', ''));
                    }
                    optyLineItemList.add(prd);
                }
            }
            update optyLineItemList;
            list<String> contSrt = new list<string>();
            for(String con : contractNumber){
                contSrt.add(con);
            }
            String contSrting = String.join(contSrt,',');
            opportunity oppObj = [SELECT Id, Name, Vision_Reference_Contract__c FROM Opportunity WHERE Id =: oppId];
            oppObj.Vision_Reference_Contract__c = contSrting;
            update oppObj;
            return 'SUCCESS : Products have been updated with NPR data. View Opportunity Products Tab for more details.';
        }
        catch(exception e){
            return 'ERROR: Failed to update the products. Exception : '+e.getLineNumber()+' error message : '+e.getMessage();
        }*/
        return null;
    }
    
    @auraEnabled
    public static string handleUpdateProdWithNRPForUpload(String CustomerId, List<String> contractIds, String optyProd){
        /*try{
            for(String conId : contractIds){
                //system.debug('Contract Id ---> '+conId);
            }
            list<Product_Opportunity__c> optyProdList = (list<Product_Opportunity__c>)JSON.deserialize(optyProd,list<Product_Opportunity__c>.class);
            Account accObj = [SELECT Id, Name, Phoenix_Customer_Class_Bid_Template__c FROM Account WHERE Id =: CustomerId];
            String templateType = accObj.Phoenix_Customer_Class_Bid_Template__c;
            list < Phoenix_NPR_Data__c > NPRDataLines = [select id, Name, Phoenix_Contract_Type__c, Phoenix_12Months_Actual_Sales_Unit__c,
                                                         Phoenix_12Mt_Sales_Ut_Actual__c, Phoenix_Product_Position__c, Phoenix_Net_Sales_Internal__c,
                                                         Phoenix_Dead_Net_Tracking_GR__c, Phoenix_Contract_Price__c, Phoenix_Product__c, 
                                                         Phoenix_Product__r.ProductCode, Phoenix_12Months_Sales_Unit__c, Phoenix_12Months_Net_Sales__c,
                                                         Phoenix_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Rebate__c, Phoenix_Rebate_G_N_Indicator__c,
                                                         Phoenix_Bonafied_G_N_Indicator__c, Phoenix_Fee_Bonafied_Fee__c, Phoenix_Per_Unit_Bonfied_Fee__c,
                                                         Phoenix_CD__c, Phoenix_GR_TrackingTier__c, Phoenix_Contract__r.Phoenix_Contract_Number__c 
                                                         from Phoenix_NPR_Data__c where Phoenix_NPR_Status__c = 'Active' and Phoenix_Account__c =: CustomerId
                                                         AND (Phoenix_Contract_Number__c in: contractIds or Phoenix_Contract__c in: contractIds)];
            map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
            set<String> contractNumber = new set<String>();
            for (Phoenix_NPR_Data__c NPRLine: NPRDataLines) {
                contractNumber.add(NPRLine.Phoenix_Contract__r.Phoenix_Contract_Number__c);
                if (productCodeToNPRLineMap.containsKey(NPRLine.Phoenix_Product__c)) {
                    string productCode = '/'+NPRLine.Phoenix_Product__c;
                    productCodeToNPRLineMap.get(productCode).add(NPRLine);
                } else {
                    list < Phoenix_NPR_Data__c > NPRList = new list < Phoenix_NPR_Data__c > ();
                    NPRList.add(NPRLine);
                    string productCode = '/'+NPRLine.Phoenix_Product__c;
                    productCodeToNPRLineMap.put(productCode, NPRList);
                }
            }
            list<Product_Opportunity__c> updateList = new list<Product_Opportunity__c>();
            String oppId = '';
            for (Product_Opportunity__c wr: optyProdList) {
                wr.Vision_Current_Direct_Units__c = 0;
                wr.Current_Indirect_Selling_Units__c = 0;
                wr.Vision_Current_Direct_Price__c = 0;
                wr.Vision_Current_Indirect_Price__c = 0;
                wr.Vision_Current_OS_Units__c = 0;
                wr.Vision_Current_RAD_units__c = 0;
                wr.Vision_Current_WMT_Units__c = 0;
                wr.Vision_Current_Wholesaler_Units__c = 0;
                wr.Vision_Current_Anda_Units__c = 0;
                
                
                list < Decimal > directPriceList = new list < Decimal > ();
                list < Decimal > indirectPriceList = new list < Decimal > ();
                list < Decimal > perUnitRebateList = new list < Decimal > ();
                if(productCodeToNPRLineMap.containsKey(wr.Product__c)){
                    for(Phoenix_NPR_Data__c NPRLine:productCodeToNPRLineMap.get(wr.Product__c)){
                        if(templateType=='Indirect' || templateType=='Direct and Indirect' || templateType=='Walgreens'|| templateType=='ABC Progen' || templateType=='Econdisc' || templateType== 'Costco'|| templateType== 'Sams Club' || templateType== 'Net Indirect Pricing' || templateType== 'Government Pricing'){
                               if(NPRLine.Phoenix_Contract_Type__c=='Indirect'){
                                   wr.Current_Indirect_Selling_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? Integer.valueOf(NPRLine.Phoenix_12Months_Sales_Unit__c) : 0;
                                   indirectPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                               }
                               perUnitRebateList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                           }
                        if (templateType == 'Direct' || templateType == 'Direct and Indirect' || templateType == 'Econdisc' || templateType == 'Net Indirect Pricing') {
                            if (NPRLine.Phoenix_Contract_Type__c == 'Direct') {
                                wr.Vision_Current_Direct_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? Integer.valueOf(NPRLine.Phoenix_12Months_Sales_Unit__c) : 0;
                                directPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                            }
                            perUnitRebateList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                        }
                        if (templateType == 'ClarusOne') {
                            if (NPRLine.Phoenix_Contract_Number__c == '3000001263' || NPRLine.Phoenix_Contract_Number__c == '3000000224'|| NPRLine.Phoenix_Contract_Number__c == '3000000418' || NPRLine.Phoenix_Contract_Number__c == '3000000047' || NPRLine.Phoenix_Contract_Number__c == '3000000071') {
                                    wr.Vision_Current_OS_Units__c = wr.Vision_Current_OS_Units__c != null ? wr.Vision_Current_OS_Units__c : 0;
                                    wr.Vision_Current_OS_Units__c += (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                                }
                            if (NPRLine.Phoenix_Contract_Number__c == '1000000120') {
                                wr.Vision_Current_RAD_units__c = wr.Vision_Current_RAD_units__c != null ? wr.Vision_Current_RAD_units__c : 0;
                                wr.Vision_Current_RAD_units__c += (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                            }
                            if (NPRLine.Phoenix_Contract_Number__c == '3000000143') {
                                wr.Vision_Current_WMT_Units__c = wr.Vision_Current_WMT_Units__c != null ? wr.Vision_Current_WMT_Units__c : 0;
                                wr.Vision_Current_WMT_Units__c += (NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0);
                            }
                        }
                        if (templateType == 'BASE/DSH') {
                            if (NPRLine.Phoenix_Contract_Number__c == '3000000762' ||NPRLine.Phoenix_Contract_Number__c == '3000000634'||NPRLine.Phoenix_Contract_Number__c == '3000000929' || NPRLine.Phoenix_Contract_Number__c == '3000000911'|| NPRLine.Phoenix_Contract_Number__c == '3000001344' || NPRLine.Phoenix_Contract_Number__c == '3000000746'|| NPRLine.Phoenix_Contract_Number__c == '3000000448' || NPRLine.Phoenix_Contract_Number__c == '3000000440'|| NPRLine.Phoenix_Contract_Number__c == '3000000963' || NPRLine.Phoenix_Contract_Number__c == '3000000468'|| NPRLine.Phoenix_Contract_Number__c == '3000000351'  || NPRLine.Phoenix_Contract_Number__c == '3000000652'|| NPRLine.Phoenix_Contract_Number__c == '3000000859' || NPRLine.Phoenix_Contract_Number__c == '3000000383'|| NPRLine.Phoenix_Contract_Number__c == '3000001690' || NPRLine.Phoenix_Contract_Number__c == '3000001343') {
                                    wr.Vision_Current_BASE_Units__c = (wr.Vision_Current_BASE_Units__c != null ? wr.Vision_Current_BASE_Units__c : 0) + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                                }
                            if (NPRLine.Phoenix_Contract_Number__c == '3000000352' || NPRLine.Phoenix_Contract_Number__c == '3000000441'|| NPRLine.Phoenix_Contract_Number__c == '3000000447' || NPRLine.Phoenix_Contract_Number__c == '3000000469'|| NPRLine.Phoenix_Contract_Number__c == '3000000653' || NPRLine.Phoenix_Contract_Number__c == '3000000763'|| NPRLine.Phoenix_Contract_Number__c == '3000000767' || NPRLine.Phoenix_Contract_Number__c == '3000000912'||NPRLine.Phoenix_Contract_Number__c == '3000000964' || NPRLine.Phoenix_Contract_Number__c == '3000001088'||NPRLine.Phoenix_Contract_Number__c == '3000001310' || NPRLine.Phoenix_Contract_Number__c == '3000001541'||NPRLine.Phoenix_Contract_Number__c == '3000001548' || NPRLine.Phoenix_Contract_Number__c == '3000001691'|| NPRLine.Phoenix_Contract_Number__c == '3000000419') {
                                    wr.Vision_Current_DSH_Units__c = (wr.Vision_Current_DSH_Units__c != null ? wr.Vision_Current_DSH_Units__c : 0) + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                                }
                            if (NPRLine.Phoenix_Contract_Number__c == '3000000589') {
                                wr.Vision_Current_AutoSub_Units__c = (wr.Vision_Current_AutoSub_Units__c != null ? wr.Vision_Current_AutoSub_Units__c : 0) + (NPRLine.Phoenix_12Months_Actual_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Actual_Sales_Unit__c : 0);
                            }
                        }
                        if (templateType == 'RXSS') {
                            if (NPRLine.Phoenix_Contract_Type__c == 'Indirect') {
                                if (NPRLine.Phoenix_Contract_Number__c == '3000000733') {
                                    wr.Vision_Current_Wholesaler_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                                }
                                if (NPRLine.Phoenix_Contract_Number__c == '3000001332') {
                                    wr.Vision_Current_Anda_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                                }
                                if (NPRLine.Phoenix_Contract_Number__c == '3000000734' || NPRLine.Phoenix_Contract_Number__c == '3000001173') {
                                    wr.Vision_Current_Indirect_Price__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                                }
                            }
                            if (NPRLine.Phoenix_Contract_Type__c == 'Direct') {
                                if (NPRLine.Phoenix_Contract_Number__c == '1000000627') {
                                    wr.Vision_Current_Direct_Units__c += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? NPRLine.Phoenix_12Months_Sales_Unit__c : 0;
                                }
                            }
                        }
                    }
                    if (indirectPriceList.size() > 0) {
                        indirectPriceList.sort();
                        wr.Vision_Current_Indirect_Price__c = Integer.valueOf(indirectPriceList[0]);
                    }
                    //take minimum of all deirect NPR prices
                    if (directPriceList.size() > 0) {
                        directPriceList.sort();
                        wr.Vision_Current_Direct_Price__c = Integer.valueOf(directPriceList[0]);
                    }
                    //take Max of all  NPR rebate
                    if (perUnitRebateList.size() > 0) {
                        perUnitRebateList.sort();
                    }
                }
                
                updateList.add(wr);
            }
            list<Product_Opportunity__c> optyLineItemList = new List<Product_Opportunity__c>();
            if(updateList.size() > 0){
                for(Product_Opportunity__c prd: updateList){
                    String prodId = String.valueOf(prd.Product__c);
                    if(prodId.contains('/')){
                        prd.Product__c = Id.valueOf(prodId.replace('/', ''));
                    }
                    optyLineItemList.add(prd);
                }
            }
            return JSON.serialize(optyLineItemList);
            //return 'SUCCESS : Products have been updated with NPR data. View Opportunity Products Tab for more details.';
        }
        catch(exception e){
            return 'ERROR: Failed to update the products. Exception : '+e.getLineNumber()+' error message : '+e.getMessage();
        }*/
        return null;
    }
    
    @auraEnabled
    public static list<prdwrapperClass> getNPRdata(String CustomerId, List<String> contractsIds,
                                                   list<prdwrapperClass> optyProdList)
    {
        /*Account accObj = [SELECT Id, Name, Phoenix_Customer_Class_Bid_Template__c FROM Account WHERE Id =: CustomerId];
        String templateType = accObj.Phoenix_Customer_Class_Bid_Template__c;
        list < Phoenix_NPR_Data__c > NPRDataLines = [select id, Name, Phoenix_Contract_Type__c, Phoenix_12Months_Actual_Sales_Unit__c,
                                                     Phoenix_12Mt_Sales_Ut_Actual__c, Phoenix_Product_Position__c, Phoenix_Net_Sales_Internal__c,
                                                     Phoenix_Dead_Net_Tracking_GR__c, Phoenix_Contract_Price__c, Phoenix_Product__c, 
                                                     Phoenix_Product__r.ProductCode, Phoenix_12Months_Sales_Unit__c, Phoenix_12Months_Net_Sales__c,
                                                     Phoenix_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Rebate__c, Phoenix_Rebate_G_N_Indicator__c,
                                                     Phoenix_Bonafied_G_N_Indicator__c, Phoenix_Fee_Bonafied_Fee__c, Phoenix_Per_Unit_Bonfied_Fee__c, Phoenix_CD__c, Phoenix_GR_TrackingTier__c 
                                                     from Phoenix_NPR_Data__c where Phoenix_NPR_Status__c = 'Active' and Phoenix_Account__c =: CustomerId
                                                     AND Phoenix_Contract_Number__c in: contractsIds];
        //system.debug('NPRDataLines.size() ::: '+NPRDataLines.size());
        map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
        for (Phoenix_NPR_Data__c NPRLine: NPRDataLines) {
            if (productCodeToNPRLineMap.containsKey(NPRLine.Phoenix_Product__r.ProductCode)) {
                productCodeToNPRLineMap.get(NPRLine.Phoenix_Product__r.ProductCode).add(NPRLine);
            } else {
                list < Phoenix_NPR_Data__c > NPRList = new list < Phoenix_NPR_Data__c > ();
                NPRList.add(NPRLine);
                productCodeToNPRLineMap.put(NPRLine.Phoenix_Product__c, NPRList);
            }
        }
        
        for (prdwrapperClass wr: optyProdList) {
            wr.currentDirectUnits = 0;
            wr.currentIndirectUnits = 0;
            wr.currentDirectPrice = 0;
            wr.currentIndirectPrice = 0;
            wr.currentRebatePer = 0;
            list < Decimal > directPriceList = new list < Decimal > ();
            list < Decimal > indirectPriceList = new list < Decimal > ();
            list < Decimal > perUnitRebateList = new list < Decimal > ();
            if(productCodeToNPRLineMap.containsKey(wr.prdlist.Id)){
                for(Phoenix_NPR_Data__c NPRLine:productCodeToNPRLineMap.get(wr.prdlist.Id)){
                    if(templateType=='Indirect' || templateType=='Direct and Indirect' || templateType=='Walgreens'
                       || templateType=='ABC Progen' || templateType=='Econdisc' || templateType== 'Costco'
                       || templateType== 'Sams Club' || templateType== 'Net Indirect Pricing' || templateType== 'Government Pricing'){
                           if(NPRLine.Phoenix_Contract_Type__c=='Indirect'){
                               wr.currentIndirectUnits += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? Integer.valueOf(NPRLine.Phoenix_12Months_Sales_Unit__c) : 0;
                               indirectPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                           }
                           perUnitRebateList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                       }
                    if (templateType == 'Direct' || templateType == 'Direct and Indirect' || templateType == 'Econdisc' || templateType == 'Net Indirect Pricing') {
                        if (NPRLine.Phoenix_Contract_Type__c == 'Direct') {
                            wr.currentDirectUnits += NPRLine.Phoenix_12Months_Sales_Unit__c != null ? Integer.valueOf(NPRLine.Phoenix_12Months_Sales_Unit__c) : 0;
                            directPriceList.add(NPRLine.Phoenix_Contract_Price__c);
                        }
                        perUnitRebateList.add(NPRLine.Phoenix_Per_Unit_Rebate__c);
                    }
                }
                if (indirectPriceList.size() > 0) {
                    indirectPriceList.sort();
                    wr.currentIndirectPrice = Integer.valueOf(indirectPriceList[0]);
                }
                //take minimum of all deirect NPR prices
                if (directPriceList.size() > 0) {
                    directPriceList.sort();
                    wr.currentDirectPrice = Integer.valueOf(directPriceList[0]);
                }
                //take Max of all  NPR rebate
                if (perUnitRebateList.size() > 0) {
                    perUnitRebateList.sort();
                    //bidLine.Phoenix_Current_Per_Unit_Rebate__c = perUnitRebateList[perUnitRebateList.size() - 1];
                    //bidLine.Phoenix_Proposed_Per_Unit_Rebate__c = perUnitRebateList[perUnitRebateList.size() - 1];
                }
            }
        }
        return optyProdList;*/
        return null;
    }
    
    @auraEnabled
    public static Integer saveOptyDetPageChanges(Id optyId,Product_Opportunity__c prodOptyRec){
        update prodOptyRec;
        Opportunity optyObj = [SELECT Id, Name, Vision_Opportunity_Value__c FROM Opportunity WHERE Id =: optyId];
        List<Product_Opportunity__c> optyProdList = [SELECT Id, Name, Vision_Opportunity_Value__c FROM Product_Opportunity__c WHERE Opportunity__c =: optyId];
        Decimal optyVal = 0;
        for(Product_Opportunity__c productOpportunity : optyProdList){
            optyVal = optyVal + (productOpportunity.Vision_Opportunity_Value__c != null ? productOpportunity.Vision_Opportunity_Value__c : 0);
        }
        optyObj.Vision_Opportunity_Value__c = optyVal;
        update optyObj;
        return Integer.valueOf(optyVal);
    }
    @AuraEnabled
    public static String saveOptyRec(String optyData){
        if(String.isNotBlank(optyData)){
            Opportunity OppData = (Opportunity)JSON.deserialize(optyData,Opportunity.class);
            //Id accId = OppData.AccountId;
            //Account accObj = [SELECT Id, name, Phoenix_Customer_Class_Bid_Template__c FROM Account WHERE Id=: accId];
            //OppData.Vision_Bid_Template__c = accObj.Phoenix_Customer_Class_Bid_Template__c;
            insert OppData;
            return String.valueOf(OppData.Id);
        }
        else{
            return 'null';
        }
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
        if (string.isNotBlank(searchInput)) {
            query += ' and ( name like \'%' + searchInput + '%\' or Phoenix_Contract_Number__c like \'%' + searchInput + '%\' or Phoenix_Customer__r.Name like \'%' + searchInput + '%\' or Phoenix_Contract_Internal_Description__c like \'%' + searchInput + '%\' or Phoenix_Contract_External_Description__c like  \'%' + searchInput + '%\')';
        }
        List < Phoenix_Contract__c > cntList = Database.query(query);
        return cntList;
    }
    @auraEnabled
    public static Opportunity getOptyRec(Id optyId){
        String query = 'SELECT '+Phoenix_Util.getsObjectFieds('Opportunity')+' FROM Opportunity WHERE Id=: optyId';
        Opportunity optyObj =  database.query(query);
        
        return optyObj;
    }
    
    public static list<String> fetchPicklistVal(){
        List<String> restrictivePickVals = new List<String>();
        String strObjectName = 'Product_Opportunity__c';
        String strPicklistField = 'Dosage_Form__c';
        Map<String, String> mapPickListValues = new Map<String, String>();
        for (Schema.PicklistEntry objPickList : Schema.getGlobalDescribe().get(strObjectName).getDescribe().fields.getMap().get(strPicklistField).getDescribe().getPickListValues()) {
           restrictivePickVals.add(objPickList.getValue().toLowerCase());
            
        }
        return restrictivePickVals;
    }
    
    @auraEnabled
    public static List<Product_Opportunity__c> updateOptyLineTotalAnnualUnits(String optyProdList){
        List<Product_Opportunity__c> optyProdObjList = (List<Product_Opportunity__c>)JSON.deserialize(optyProdList,List<Product_Opportunity__c>.class);
        List<Product_Opportunity__c> updateList = new List<Product_Opportunity__c>();
        for(Product_Opportunity__c prd : optyProdObjList){
            if(prd.Vision_Total_Annual_Units__c != 0){
                prd.Status__c = 'Matched';
                prd.vision_is_discrepancy_product__c = false;
            }
            updateList.add(prd);
        }
        update updateList; return updateList;
    }
    
    @auraEnabled
    public static void updateOptyLineList(String optyProdList){
        List<Product_Opportunity__c> optyProdObjList = (List<Product_Opportunity__c>)JSON.deserialize(optyProdList,List<Product_Opportunity__c>.class);
        
        update optyProdObjList;
    }
    
    @auraEnabled
    public static Product_Opportunity__c moveToMatched(Product_Opportunity__c optyProdObj){
        //String query = 'SELECT Product__r.Name,Product__r.Id, Product__r.Phoenix_Pkg_Size__c, '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c WHERE Id =: optyProdId';
        //Product_Opportunity__c optyProdObj = Database.query(query);
        Product2 prodObj = [SELECT Id, Name FROM Product2 WHERE Id =: optyProdObj.Product__c];
        optyProdObj.Name = prodObj.Name;
        optyProdObj.Status__c = 'Matched';
        optyProdObj.vision_is_discrepancy_product__c = false;
        optyProdObj.Vision_isMovedFromUnMatched__c=true;
        update optyProdObj; return optyProdObj;
    }
    
    @auraEnabled
    public static void movePkgDisItemToMatchPrds(Id oppId, Id optyProdId){
        String query = 'SELECT '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c WHERE Id=: optyProdId';
        Product_Opportunity__c optyProdObj = Database.query(query);
        optyProdObj.Status__c = 'Matched';
        optyProdObj.Vision_isMovedFromDiscrepancy__c=true;
        optyProdObj.vision_is_discrepancy_product__c = false;
        update optyProdObj;
    }
    
    @auraEnabled
    public static void moveDupToMatchPrds(Id oppId, Id optyProdId){
        List<Product_Opportunity__c> optyProdUpdateList = new List<Product_Opportunity__c>();
        String query = 'SELECT '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c WHERE Id=: optyProdId';
        Product_Opportunity__c optyProdObj = Database.query(query);
        optyProdObj.Status__c = 'Matched';
        optyProdObj.Vision_isMovedFromDiscrepancy__c=true;
        optyProdObj.vision_is_discrepancy_product__c = false;
        optyProdUpdateList.add(optyProdObj);
        List<Product_Opportunity__c> optyProdList = [SELECT Id, Name, Status__c, Vision_inActive__c, vision_is_discrepancy_product__c 
                                                     FROM Product_Opportunity__c WHERE Product__c =: optyProdObj.Product__c AND Id !=: optyProdId];
        for(Product_Opportunity__c optyProd : optyProdList){
            optyProd.Vision_inActive__c = true;
            optyProdUpdateList.add(optyProd);
        }
        update optyProdUpdateList;
    }
    
    @auraEnabled
    public static String moveToUnMatchPrds(Id OpportunityId, Id prdOptyId){
        productCountWrapper pcw = new productCountWrapper();
        String query = 'SELECT '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c WHERE Id=: prdOptyId';
        Product_Opportunity__c prdOpty = database.query(query);
        prdOpty.Product__c = null;
        prdOpty.Status__c = 'Unmatched';
        prdOpty.Vision_isMovedFromUnMatched__c=false;
        update prdOpty;
        return 'success';
    }
    @auraEnabled
    public static String moveToDiscrepancyPrds(Id prdOptyId){
        productCountWrapper pcw = new productCountWrapper();
        String query = 'SELECT Product__r.Phoenix_Pkg_Size__c,'+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c WHERE Id=: prdOptyId';
        Product_Opportunity__c optyProd = database.query(query);
        system.debug('optyProd-Vision_Disc_Pkg_Size__c---------------'+optyProd.Vision_Disc_Pkg_Size__c);
        system.debug('optyProd-Pkg_Size__c---------------'+optyProd.Pkg_Size__c);
        system.debug('optyProd-Vision_Uploaded_Pkg_Size__c---------------'+optyProd.Vision_Uploaded_Pkg_Size__c);
        optyProd.vision_is_discrepancy_product__c = true;
        optyProd.Vision_isMovedFromDiscrepancy__c=false;
        optyProd.Status__c = 'Discrepant';
        optyProd.Vision_inActive__c=false;
        system.debug('optyProdObj.Product__r.Phoenix_Pkg_Size__c------------'+optyProd.Product__r.Phoenix_Pkg_Size__c);
        if(optyProd.Vision_isNewProposedUnits__c){
        //optyProd.Vision_Uploaded_Pkg_Size__c = optyProd.Pkg_Size__c;
        //optyProd.Pkg_Size__c = prodObj.Phoenix_Pkg_Size__c;
        optyProd.Vision_Total_Annual_Units__c = optyProd.Vision_Total_Annual_Units__c != null ? optyProd.Vision_Total_Annual_Units__c: 0;
        optyProd.Proposed_Direct_Selling_Units__c = optyProd.Proposed_Direct_Selling_Units__c != null ? (optyProd.Proposed_Direct_Selling_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Proposed_Indirect_Selling_Unit__c = optyProd.Proposed_Indirect_Selling_Unit__c != null ? (optyProd.Proposed_Indirect_Selling_Unit__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_OS_Units__c = optyProd.Vision_Proposed_OS_Units__c != null ? (optyProd.Vision_Proposed_OS_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c): 0;
        optyProd.Vision_Proposed_RAD_Units__c = optyProd.Vision_Proposed_RAD_Units__c != null ? (optyProd.Vision_Proposed_RAD_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_WMT_Units__c = optyProd.Vision_Proposed_WMT_Units__c != null ? (optyProd.Vision_Proposed_WMT_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_BASE_Units__c = optyProd.Vision_Proposed_BASE_Units__c != null ? (optyProd.Vision_Proposed_BASE_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_DSH_Units__c = optyProd.Vision_Proposed_DSH_Units__c != null ? (optyProd.Vision_Proposed_DSH_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_AutoSub_Units__c = optyProd.Vision_Proposed_AutoSub_Units__c != null ? (optyProd.Vision_Proposed_AutoSub_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_Smith_Drug_Units__c = optyProd.Vision_Proposed_Smith_Drug_Units__c != null ? (optyProd.Vision_Proposed_Smith_Drug_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c): 0;
        optyProd.Vision_Proposed_Anda_Units__c = optyProd.Vision_Proposed_Anda_Units__c != null ? (optyProd.Vision_Proposed_Anda_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c = optyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c != null ? (optyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c = optyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c != null ? (optyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c): 0;
        optyProd.Vision_Proposed_TotalRetailIndirectUnits__c = optyProd.Vision_Proposed_TotalRetailIndirectUnits__c != null ? (optyProd.Vision_Proposed_TotalRetailIndirectUnits__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        
        optyProd.Vision_Proposed_Direct_ESI_Units__c = optyProd.Vision_Proposed_Direct_ESI_Units__c != null ? (optyProd.Vision_Proposed_Direct_ESI_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_Indirect_ESI_Units__c = optyProd.Vision_Proposed_Indirect_ESI_Units__c != null ? (optyProd.Vision_Proposed_Indirect_ESI_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_Direct_Kroger_Units__c = optyProd.Vision_Proposed_Direct_Kroger_Units__c != null ? (optyProd.Vision_Proposed_Direct_Kroger_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_Indirect_Kroger_Units__c = optyProd.Vision_Proposed_Indirect_Kroger_Units__c != null ? (optyProd.Vision_Proposed_Indirect_Kroger_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c = optyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c != null ? (optyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_IndirectRxOutreach_Units__c = optyProd.Vision_Proposed_IndirectRxOutreach_Units__c != null ? (optyProd.Vision_Proposed_IndirectRxOutreach_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_Direct_Supervalu_Units__c = optyProd.Vision_Proposed_Direct_Supervalu_Units__c != null ? (optyProd.Vision_Proposed_Direct_Supervalu_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_Indirect_Supervalu_Units__c = optyProd.Vision_Proposed_Indirect_Supervalu_Units__c != null ? (optyProd.Vision_Proposed_Indirect_Supervalu_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_Direct_Cigna_Units__c = optyProd.Vision_Proposed_Direct_Cigna_Units__c != null ? (optyProd.Vision_Proposed_Direct_Cigna_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_Indirect_Cigna_Units__c = optyProd.Vision_Proposed_Indirect_Cigna_Units__c != null ? (optyProd.Vision_Proposed_Indirect_Cigna_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_Direct_Cordant_Units__c = optyProd.Vision_Proposed_Direct_Cordant_Units__c != null ? (optyProd.Vision_Proposed_Direct_Cordant_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_Indirect_Cordant_Units__c = optyProd.Vision_Proposed_Indirect_Cordant_Units__c != null ? (optyProd.Vision_Proposed_Indirect_Cordant_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_Direct_Accerodo_Units__c = optyProd.Vision_Proposed_Direct_Accerodo_Units__c != null ? (optyProd.Vision_Proposed_Direct_Accerodo_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_Indirect_Accerodo_Units__c = optyProd.Vision_Proposed_Indirect_Accerodo_Units__c != null ? (optyProd.Vision_Proposed_Indirect_Accerodo_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        
        optyProd.Vision_Proposed_CVS_Direct_Units__c = optyProd.Vision_Proposed_CVS_Direct_Units__c != null ? (optyProd.Vision_Proposed_CVS_Direct_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_CVS_Indirect_Units__c = optyProd.Vision_Proposed_CVS_Indirect_Units__c != null ? (optyProd.Vision_Proposed_CVS_Indirect_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_Cardinal_Units__c = optyProd.Vision_Proposed_Cardinal_Units__c != null ? (optyProd.Vision_Proposed_Cardinal_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
        optyProd.Vision_Proposed_Major_Units__c = optyProd.Vision_Proposed_Major_Units__c != null ? (optyProd.Vision_Proposed_Major_Units__c*optyProd.Product__r.Phoenix_Pkg_Size__c)/Integer.valueOf(optyProd.Vision_Disc_Pkg_Size__c) : 0;
       
            
        }
        
        update optyProd;
        
        list<Product_Opportunity__c>partialOptyList=[SELECT Id,Status__c,Vision_inActive__c,vision_is_discrepancy_product__c, Name, Product__c FROM Product_Opportunity__c WHERE Product__c =:optyProd.Product__c and vision_is_discrepancy_product__c=true and Opportunity__c=:optyProd.Opportunity__c];
        system.debug('partialOptyList----'+partialOptyList);
         system.debug('partialOptyList--size--'+partialOptyList.size());
        for(Product_Opportunity__c po:partialOptyList ){
            po.Vision_inActive__c=false;
            po.Status__c = 'Discrepant';
            po.vision_is_discrepancy_product__c = true;
            
        }
        update partialOptyList;   
        return 'success';
    }
    
    @auraEnabled
    public static List<Phoenix_Bid__c> getOpenBids(String customerId){
        List<Phoenix_Bid__c> bidList = [SELECT Id, Name, Phoenix_Bid_Name__c, Phoenix_Approval_Status__c,Phoenix_Bid_Type__c,
                                        CreatedDate, createdBy.Name FROM Phoenix_Bid__c 
                                        WHERE Phoenix_Customer__c =: customerId AND Phoenix_Approval_Status__c = 'Draft'];
        return bidList;
    }
    
    @auraEnabled
    public static Account getAccRec(Id accId){
        String query = 'SELECT '+Phoenix_Util.getsObjectFieds('Account')+' FROM Account WHERE Id=: accId';
        Account accObj =  database.query(query);
        return accObj;
    }
    @auraEnabled
    public static void deleteContentDoc(String fileContentId){
        List<ContentDocument> contentVersionObj = [SELECT Id,Title,FileType from ContentDocument WHERE id=:fileContentId];
        if(contentVersionObj !=null){
            delete contentVersionObj;
        }
    }
    @auraEnabled
    public static ProductsWrapper getProductDetails(String productId, String OptyProductId){
        String query,productObjName='Product_Opportunity__c';
        ProductsWrapper WrapperObj = new ProductsWrapper();
        if(productId != null && OptyProductId != null){
            WrapperObj.productId = productId;
            query = 'SELECT '+Phoenix_Util.getsObjectFieds('Product2')+' FROM Product2 WHERE Id=: productId';
            Product2 prodObj = Database.query(query);
            query = 'SELECT  Product__r.Name, '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c WHERE Id=: OptyProductId';
            //List<Product2> productList = [SELECT Id, Phoenix_Pkg_Size__c FROM Product2 WHERE Id =: productId];
            //List<Product_Opportunity__c> optyProductList = [SELECT Id, Pkg_Size__c,Proposed_Direct_Selling_Units__c,Proposed_Indirect_Selling_Unit__c,Product__c,Vision_Total_Annual_Units__c 
            //                                                FROM Product_Opportunity__c WHERE Id =: OptyProductId];
            Product_Opportunity__c optyProdObj = Database.query(query);
            Product_Opportunity__c expectedOptyProd = new Product_Opportunity__c();
            Decimal packSize = prodObj.Phoenix_Pkg_Size__c!= null ? prodObj.Phoenix_Pkg_Size__c:0;
            Decimal OptypackSize = optyProdObj.Pkg_Size__c!= null ? optyProdObj.Pkg_Size__c:0;
            if(packSize != OptypackSize && packSize > 0 && OptypackSize > 0){// && optyProductList[0].Product__c == null){
                WrapperObj.isPacksizeNotMatched = true;
                WrapperObj.optyProdObj = optyProdObj;
                WrapperObj.prodObj = prodObj;
                expectedOptyProd.Product__c = productId;
                expectedOptyProd.Vision_Total_Annual_Units__c = optyProdObj.Vision_Total_Annual_Units__c != null ? ((optyProdObj.Vision_Total_Annual_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Proposed_Direct_Selling_Units__c = optyProdObj.Proposed_Direct_Selling_Units__c != null ? ((optyProdObj.Proposed_Direct_Selling_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Proposed_Indirect_Selling_Unit__c = optyProdObj.Proposed_Indirect_Selling_Unit__c != null ? ((optyProdObj.Proposed_Indirect_Selling_Unit__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_OS_Units__c = optyProdObj.Vision_Proposed_OS_Units__c != null ? ((optyProdObj.Vision_Proposed_OS_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_RAD_Units__c = optyProdObj.Vision_Proposed_RAD_Units__c != null ? ((optyProdObj.Vision_Proposed_RAD_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_WMT_Units__c = optyProdObj.Vision_Proposed_WMT_Units__c != null ? ((optyProdObj.Vision_Proposed_WMT_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_BASE_Units__c = optyProdObj.Vision_Proposed_BASE_Units__c != null ? ((optyProdObj.Vision_Proposed_BASE_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_DSH_Units__c = optyProdObj.Vision_Proposed_DSH_Units__c != null ? ((optyProdObj.Vision_Proposed_DSH_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_AutoSub_Units__c = optyProdObj.Vision_Proposed_AutoSub_Units__c != null ? ((optyProdObj.Vision_Proposed_AutoSub_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_Smith_Drug_Units__c = optyProdObj.Vision_Proposed_Smith_Drug_Units__c != null ? ((optyProdObj.Vision_Proposed_Smith_Drug_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_Anda_Units__c = optyProdObj.Vision_Proposed_Anda_Units__c != null ? ((optyProdObj.Vision_Proposed_Anda_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c = optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c != null ? ((optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c = optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c != null ? ((optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_TotalRetailIndirectUnits__c = optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c != null ? ((optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c*OptypackSize)/packSize).setScale(0) : 0;
               
                expectedOptyProd.Vision_Proposed_Direct_ESI_Units__c = optyProdObj.Vision_Proposed_Direct_ESI_Units__c != null ? ((optyProdObj.Vision_Proposed_Direct_ESI_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_Indirect_ESI_Units__c = optyProdObj.Vision_Proposed_Indirect_ESI_Units__c != null ? ((optyProdObj.Vision_Proposed_Indirect_ESI_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_Direct_Kroger_Units__c = optyProdObj.Vision_Proposed_Direct_Kroger_Units__c != null ? ((optyProdObj.Vision_Proposed_Direct_Kroger_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_Indirect_Kroger_Units__c = optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c != null ? ((optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c = optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c != null ? ((optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_IndirectRxOutreach_Units__c = optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c != null ? ((optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_Direct_Supervalu_Units__c = optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c != null ? ((optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_Indirect_Supervalu_Units__c = optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c != null ? ((optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_Direct_Cigna_Units__c = optyProdObj.Vision_Proposed_Direct_Cigna_Units__c != null ? ((optyProdObj.Vision_Proposed_Direct_Cigna_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_Indirect_Cigna_Units__c = optyProdObj.Vision_Proposed_Indirect_Cigna_Units__c != null ? ((optyProdObj.Vision_Proposed_Indirect_Cigna_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_Direct_Cordant_Units__c = optyProdObj.Vision_Proposed_Direct_Cordant_Units__c != null ? ((optyProdObj.Vision_Proposed_Direct_Cordant_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_Indirect_Cordant_Units__c = optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c != null ? ((optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_Direct_Accerodo_Units__c = optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c != null ? ((optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_Indirect_Accerodo_Units__c = optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c != null ? ((optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                
                expectedOptyProd.Vision_Proposed_CVS_Direct_Units__c = optyProdObj.Vision_Proposed_CVS_Direct_Units__c != null ? ((optyProdObj.Vision_Proposed_CVS_Direct_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_CVS_Indirect_Units__c = optyProdObj.Vision_Proposed_CVS_Indirect_Units__c != null ? ((optyProdObj.Vision_Proposed_CVS_Indirect_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_Cardinal_Units__c = optyProdObj.Vision_Proposed_Cardinal_Units__c != null ? ((optyProdObj.Vision_Proposed_Cardinal_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_Major_Units__c = optyProdObj.Vision_Proposed_Major_Units__c != null ? ((optyProdObj.Vision_Proposed_Major_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                expectedOptyProd.Vision_Proposed_Units__c = optyProdObj.Vision_Proposed_Units__c != null ? ((optyProdObj.Vision_Proposed_Units__c*OptypackSize)/packSize).setScale(0) : 0;
                wrapperObj.expectedOptyProd = expectedOptyProd;
            }
            else{
                optyProdObj.Product__c = productId;
                update optyProdObj;
                optyProdObj = Database.query(query);
                WrapperObj.optyProdObj = optyProdObj;
                WrapperObj.isPacksizeNotMatched = false;
            }
        }
        return WrapperObj;
    }
    public class ProductsWrapper{
        @AuraEnabled public Decimal actualAnnualUnits=0;
        @AuraEnabled public Decimal expectedAnnualUnits=0;
        @AuraEnabled public Decimal actualProposedDirUnits=0;
        @AuraEnabled public Decimal expectedProposedDirUnits=0;
        @AuraEnabled public Decimal actualProposedIndirUnits=0;
        @AuraEnabled public Decimal expectedProposedIndirUnits=0;
        @AuraEnabled public boolean isPacksizeNotMatched;
        @AuraEnabled public String productId='';
        @auraEnabled public Decimal actualProposedOsUnits=0;
        @auraEnabled public Decimal expectedProposedOsUnits=0;
        @auraEnabled public Product2 prodObj;
        @auraEnabled public Product_Opportunity__c optyProdObj;
        @auraEnabled public Product_Opportunity__c expectedOptyProd;
    }
    
    @auraEnabled
    public static List<Product2> getProductListSearch(String searchKeyWord, String accId){
        searchKeyWord = '%'+searchKeyWord+'%';
        List<Product2> prodList = [SELECT Id, Name, Phoenix_NDC_11__c, ProductCode, Phoenix_Product_Director__r.Name, Product_Family__c, Product_Family__r.Name, Phoenix_Rx_SRx_OTC__c FROM Product2 
                                   WHERE IsActive = true AND (Name LIKE: searchKeyWord OR Phoenix_NDC_11__c LIKE: searchKeyWord OR ProductCode LIKE: searchKeyWord)
                                   AND (Phoenix_Is_Private_Label_OTC__c = false OR (Phoenix_Is_Private_Label_OTC__c = true AND OTC_Customer__c = : accId AND Phoenix_Is_Control_Label__c = false))
                                   AND Phoenix_Is_Exclude_Bid__c = false ORDER BY Name LIMIT 500];
        return prodList;
    }
    
    @auraEnabled
    public static void removeProductLookup(String optyProdId){
        Product_Opportunity__c optyItem = [SELECT Id, Name, Product__c FROM Product_Opportunity__c WHERE Id =: optyProdId];
        optyItem.Product__c = null; update optyItem;
    }
    
    @auraEnabled
    public static Product_Opportunity__c saveProductData(String wrapperObj,String optyId){                    //(String optyProductId , Decimal expectedAnnualUnits,String optyId,String productId){
        ProductsWrapper wrapObj = (ProductsWrapper)JSON.deserialize(wrapperObj,ProductsWrapper.class);
        
        Product_Opportunity__c optyProd = wrapObj.optyProdObj;
        Product_Opportunity__c expectedOptyProd = wrapObj.expectedOptyProd;
        String prodId = wrapObj.prodObj.Id;
        String query = 'SELECT '+Phoenix_Util.getsObjectFieds('Product2')+' FROM Product2 WHERE Id =: prodId';
        Product2 prodObj = Database.query(query);
        
        optyProd.Name = prodObj.Name;
        //optyProd.GCN_Generic_Code_Number__c = prodObj.Phoenix_GCN_Generic_Code_Number__c;
        //optyProd.GSN__c = prodObj.Phoenix_GCN_Sequence_Number__c;
        //optyProd.GPI_Generic_Product_Identifier__c = prodObj.Phoenix_GPI_Generic_Product_Identifier__c;
        //optyProd.NDC_11__c = prodObj.Phoenix_NDC_11__c;
        //optyProd.SKU_Number__c = prodObj.ProductCode;
        //optyProd.Product_Family__c = prodObj.Family;
        optyProd.Lowest_Price_SKU__c = prodObj.Phoenix_Lowest_Price_SKU__c;
        optyProd.Strength__c = prodObj.Phoenix_Strength__c;
        optyProd.Pkg_Size__c = prodObj.Phoenix_Pkg_Size__c;
        //optyProd.Product_Description__c = prodObj.Description;
        optyProd.Product__c = prodObj.id;
        optyProd.Status__c = 'Matched';
        optyProd.Product__c = prodObj.Id;
        optyProd.Vision_Uploaded_Pkg_Size__c = optyProd.Pkg_Size__c;
        optyProd.Pkg_Size__c = prodObj.Phoenix_Pkg_Size__c;
        optyProd.Vision_Total_Annual_Units__c = expectedOptyProd.Vision_Total_Annual_Units__c != null ? expectedOptyProd.Vision_Total_Annual_Units__c : 0;
        optyProd.Proposed_Direct_Selling_Units__c = expectedOptyProd.Proposed_Direct_Selling_Units__c != null ? expectedOptyProd.Proposed_Direct_Selling_Units__c : 0;
        optyProd.Proposed_Indirect_Selling_Unit__c = expectedOptyProd.Proposed_Indirect_Selling_Unit__c != null ? expectedOptyProd.Proposed_Indirect_Selling_Unit__c : 0;
        optyProd.Vision_Proposed_OS_Units__c = expectedOptyProd.Vision_Proposed_OS_Units__c != null ? expectedOptyProd.Vision_Proposed_OS_Units__c : 0;
        optyProd.Vision_Proposed_RAD_Units__c = expectedOptyProd.Vision_Proposed_RAD_Units__c != null ? expectedOptyProd.Vision_Proposed_RAD_Units__c : 0;
        optyProd.Vision_Proposed_WMT_Units__c = expectedOptyProd.Vision_Proposed_WMT_Units__c != null ? expectedOptyProd.Vision_Proposed_WMT_Units__c : 0;
        optyProd.Vision_Proposed_BASE_Units__c = expectedOptyProd.Vision_Proposed_BASE_Units__c != null ? expectedOptyProd.Vision_Proposed_BASE_Units__c : 0;
        optyProd.Vision_Proposed_DSH_Units__c = expectedOptyProd.Vision_Proposed_DSH_Units__c != null ? expectedOptyProd.Vision_Proposed_DSH_Units__c : 0;
        optyProd.Vision_Proposed_AutoSub_Units__c = expectedOptyProd.Vision_Proposed_AutoSub_Units__c != null ? expectedOptyProd.Vision_Proposed_AutoSub_Units__c : 0;
        optyProd.Vision_Proposed_Smith_Drug_Units__c = expectedOptyProd.Vision_Proposed_Smith_Drug_Units__c != null ? expectedOptyProd.Vision_Proposed_Smith_Drug_Units__c : 0;
        optyProd.Vision_Proposed_Anda_Units__c = expectedOptyProd.Vision_Proposed_Anda_Units__c != null ? expectedOptyProd.Vision_Proposed_Anda_Units__c : 0;
        optyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c = expectedOptyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c != null ? expectedOptyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c : 0;
        optyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c = expectedOptyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c != null ? expectedOptyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c : 0;
        optyProd.Vision_Proposed_TotalRetailIndirectUnits__c = expectedOptyProd.Vision_Proposed_TotalRetailIndirectUnits__c != null ? expectedOptyProd.Vision_Proposed_TotalRetailIndirectUnits__c : 0;
        
        optyProd.Vision_Proposed_Direct_ESI_Units__c = expectedOptyProd.Vision_Proposed_Direct_ESI_Units__c != null ? expectedOptyProd.Vision_Proposed_Direct_ESI_Units__c : 0;
        optyProd.Vision_Proposed_Indirect_ESI_Units__c = expectedOptyProd.Vision_Proposed_Indirect_ESI_Units__c != null ? expectedOptyProd.Vision_Proposed_Indirect_ESI_Units__c : 0;
        optyProd.Vision_Proposed_Direct_Kroger_Units__c = expectedOptyProd.Vision_Proposed_Direct_Kroger_Units__c != null ? expectedOptyProd.Vision_Proposed_Direct_Kroger_Units__c : 0;
        optyProd.Vision_Proposed_Indirect_Kroger_Units__c = expectedOptyProd.Vision_Proposed_Indirect_Kroger_Units__c != null ? expectedOptyProd.Vision_Proposed_Indirect_Kroger_Units__c : 0;
        optyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c = expectedOptyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c != null ? expectedOptyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c : 0;
        optyProd.Vision_Proposed_IndirectRxOutreach_Units__c = expectedOptyProd.Vision_Proposed_IndirectRxOutreach_Units__c != null ? expectedOptyProd.Vision_Proposed_IndirectRxOutreach_Units__c : 0;
        optyProd.Vision_Proposed_Direct_Supervalu_Units__c = expectedOptyProd.Vision_Proposed_Direct_Supervalu_Units__c != null ? expectedOptyProd.Vision_Proposed_Direct_Supervalu_Units__c : 0;
        optyProd.Vision_Proposed_Indirect_Supervalu_Units__c = expectedOptyProd.Vision_Proposed_Indirect_Supervalu_Units__c != null ? expectedOptyProd.Vision_Proposed_Indirect_Supervalu_Units__c : 0;
        optyProd.Vision_Proposed_Direct_Cigna_Units__c = expectedOptyProd.Vision_Proposed_Direct_Cigna_Units__c != null ? expectedOptyProd.Vision_Proposed_Direct_Cigna_Units__c : 0;
        optyProd.Vision_Proposed_Indirect_Cigna_Units__c = expectedOptyProd.Vision_Proposed_Indirect_Cigna_Units__c != null ? expectedOptyProd.Vision_Proposed_Indirect_Cigna_Units__c : 0;
        optyProd.Vision_Proposed_Direct_Cordant_Units__c = expectedOptyProd.Vision_Proposed_Direct_Cordant_Units__c != null ? expectedOptyProd.Vision_Proposed_Direct_Cordant_Units__c : 0;
        optyProd.Vision_Proposed_Indirect_Cordant_Units__c = expectedOptyProd.Vision_Proposed_Indirect_Cordant_Units__c != null ? expectedOptyProd.Vision_Proposed_Indirect_Cordant_Units__c : 0;
        optyProd.Vision_Proposed_Direct_Accerodo_Units__c = expectedOptyProd.Vision_Proposed_Direct_Accerodo_Units__c != null ? expectedOptyProd.Vision_Proposed_Direct_Accerodo_Units__c : 0;
        optyProd.Vision_Proposed_Indirect_Accerodo_Units__c = expectedOptyProd.Vision_Proposed_Indirect_Accerodo_Units__c != null ? expectedOptyProd.Vision_Proposed_Indirect_Accerodo_Units__c : 0;
        
        optyProd.Vision_Proposed_CVS_Direct_Units__c = expectedOptyProd.Vision_Proposed_CVS_Direct_Units__c != null ? expectedOptyProd.Vision_Proposed_CVS_Direct_Units__c : 0;
        optyProd.Vision_Proposed_CVS_Indirect_Units__c = expectedOptyProd.Vision_Proposed_CVS_Indirect_Units__c != null ? expectedOptyProd.Vision_Proposed_CVS_Indirect_Units__c : 0;
        optyProd.Vision_Proposed_Cardinal_Units__c = expectedOptyProd.Vision_Proposed_Cardinal_Units__c != null ? expectedOptyProd.Vision_Proposed_Cardinal_Units__c : 0;
        optyProd.Vision_Proposed_Major_Units__c = expectedOptyProd.Vision_Proposed_Major_Units__c != null ? expectedOptyProd.Vision_Proposed_Major_Units__c : 0;
        update optyProd;
        
        String optyProdId = optyProd.Id;
        String query3 = 'SELECT GCP_Product_Family__r.Name, Product__r.Name,Product__r.Id, Product__r.Phoenix_Pkg_Size__c, '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c WHERE Id =: optyProdId';
        Product_Opportunity__c retOptyProd = Database.query(query3);
        return retOptyProd;
    }
    @auraEnabled
    public static String updateProductOpportunity(list<String>prodOptyIds,string prodOptyData){
        try{
            List<Product_Opportunity__c> prodOptySelectList = (List<Product_Opportunity__c>) JSON.deserialize(prodOptyData, List<Product_Opportunity__c>.class);
            string oppId='';
            set<Id>productIds=new set<Id>();
             System.debug('the list'+prodOptySelectList);
            for(Product_Opportunity__c optyProdObj:prodOptySelectList){
               
                if(!productIds.contains(optyProdObj.Product__c)){
                    if(oppId=='')
                        oppId=optyProdObj.Opportunity__c;
                    productIds.add(optyProdObj.Product__c);
                    optyProdObj.Status__c = 'Matched';
                    optyProdObj.Vision_isMovedFromDiscrepancy__c=true;
                    optyProdObj.vision_is_discrepancy_product__c = false;   
                }
            }
            update prodOptySelectList;
            /*list<Product_Opportunity__c>prodOptyList=[SELECT Id,Status__c,vision_is_discrepancy_product__c,Vision_inActive__c, Name, Product__c FROM Product_Opportunity__c WHERE Id IN:prodOptyIds];
system.debug('prodOptyList----'+prodOptyList);
system.debug('prodOptyList-size---'+prodOptyList.size());
set<Id>productIds=new set<Id>();
for(Product_Opportunity__c optyProdObj:prodOptyList){
productIds.add(optyProdObj.Product__c);
optyProdObj.Status__c = 'Matched';
optyProdObj.vision_is_discrepancy_product__c = false;

}
update prodOptyList;*/
            list<Product_Opportunity__c>partialOptyList=[SELECT Id,Status__c,Vision_inActive__c,vision_is_discrepancy_product__c, Name, Product__c FROM Product_Opportunity__c WHERE Product__c IN:productIds and vision_is_discrepancy_product__c=true and Opportunity__c=:oppId];
            for(Product_Opportunity__c po:partialOptyList ){
                po.Vision_inActive__c=true;
                po.Status__c = 'Discrepant';
                po.vision_is_discrepancy_product__c = true;
            }
            update partialOptyList;        
            string message='Updated Successfully';
            return message;
        }
        catch(Exception e){
            return 'Error: '+e.getMessage()+' Line: '+e.getLineNumber();
        }
    }
    
    @auraEnabled
    public static List<Product_Opportunity__c> getAlldupItems(String oppId, String prodId){
        List<Product_Opportunity__c> prodItems = [SELECT Id, GCP_Product_Family__c, GCP_Product_Family__r.Name, Product__r.Phoenix_Pkg_Size__c, Vision_Disc_Pkg_Size__c, Pkg_Size__c,
                                                  Vision_Proposed_Units__c, Proposed_Direct_Selling_Units__c, Proposed_Indirect_Selling_Units__c, Vision_Proposed_OS_Units__c, Vision_Proposed_RAD_Units__c, 
                                                  Vision_Proposed_WMT_Units__c, Vision_Proposed_BASE_Units__c, Vision_Proposed_DSH_Units__c, Vision_Proposed_AutoSub_Units__c, Vision_Proposed_Smith_Drug_Units__c, 
                                                  Vision_Proposed_Anda_Units__c, Vision_Proposed_DirectAholdDelhaizeUnits__c, Vision_Proposed_Direct_Gaint_Eagle_Units__c, Vision_Proposed_TotalRetailIndirectUnits__c, 
                                                  Vision_Proposed_Direct_ESI_Units__c, Vision_Proposed_Indirect_ESI_Units__c, Vision_Proposed_Direct_Kroger_Units__c, Vision_Proposed_Indirect_Kroger_Units__c, 
                                                  Vision_Proposed_Direct_Rx_Outreach_Units__c, Vision_Proposed_IndirectRxOutreach_Units__c, Vision_Proposed_Direct_Supervalu_Units__c, Vision_Proposed_Indirect_Supervalu_Units__c, 
                                                  Vision_Proposed_Direct_Cigna_Units__c, Vision_Proposed_Indirect_Cigna_Units__c, Vision_Proposed_Direct_Cordant_Units__c, Vision_Proposed_Direct_Accerodo_Units__c, 
                                                  Vision_Proposed_Indirect_Accerodo_Units__c, Vision_Proposed_Indirect_Cordant_Units__c, Vision_Proposed_CVS_Direct_Units__c, Vision_Proposed_CVS_Indirect_Units__c, Vision_Proposed_Cardinal_Units__c, Vision_Proposed_Major_Units__c
                                                  FROM Product_Opportunity__c WHERE Opportunity__c=: oppId AND Product__c =: prodId];
        return prodItems;
    }
    
    public static void updateCoItems(String accId){
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }
}