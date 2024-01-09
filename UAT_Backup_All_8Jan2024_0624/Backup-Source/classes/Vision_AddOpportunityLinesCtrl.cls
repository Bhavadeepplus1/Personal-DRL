/**
* @description       : 
* @author            : Surender Dhruvsoft
* @group             : 
* @last modified on  : 31-05-2021
* @last modified by  : Surender Patel (Dhruvsoft)
* Modifications Log 
* Ver   Date         Author               Modification
* 1.0   25-05-2021   Surender Dhruvsoft   Initial Version
**/
public class Vision_AddOpportunityLinesCtrl {
    public static Opportunity oppty;
    
    static {
        oppty = new Opportunity();
    }
    
    @AuraEnabled
    public static Vision_OpportunityCreatorCtrl.BidWrapper getBidInfo(String bidId) {
        return Vision_OpportunityCreatorCtrl.getbidInfo(bidId);
    }
    
    @AuraEnabled
    public static list < Vision_OpportunityCreatorCtrl.wrapperClass > getSearch(List < Vision_OpportunityCreatorCtrl.wrapperClass > pItem, list < string > SearchKeyWordPD, string search, string family, list < string > RxSrxList, Vision_OpportunityCreatorCtrl.BidWrapper quotewrap) {
        return Vision_OpportunityCreatorCtrl.finalSearchResult(pItem, SearchKeyWordPD, search, family, RxSrxList, quotewrap);
    }
    @AuraEnabled
    public static list < Vision_OpportunityCreatorCtrl.wrapperClass > getsearchDirectorResult(List < Vision_OpportunityCreatorCtrl.wrapperClass > pItem, list < string > SearchKeyWordPD, string search, string family, list < string > RxSrxList, Vision_OpportunityCreatorCtrl.BidWrapper quotewrap) {
        return Vision_OpportunityCreatorCtrl.finalSearchResult(pItem, SearchKeyWordPD, search, family, RxSrxList, quotewrap);
    }
    
    @AuraEnabled
    public static list < Vision_OpportunityCreatorCtrl.wrapperClass > getSearchFamily(List < Vision_OpportunityCreatorCtrl.wrapperClass > pItem, list < string > SearchKeyWordPD, string search, string family, list < string > RxSrxList, Vision_OpportunityCreatorCtrl.BidWrapper quotewrap) {
        return Vision_OpportunityCreatorCtrl.finalSearchResult(pItem, SearchKeyWordPD, search, family, RxSrxList, quotewrap);
    }
    
    @AuraEnabled
    public static List < Vision_OpportunityCreatorCtrl.wrapperClass > getproducts1(Vision_OpportunityCreatorCtrl.BidWrapper quotewrap) {
        return Vision_OpportunityCreatorCtrl.getproducts1(quotewrap);
    }
    @AuraEnabled
    public static List < Vision_OpportunityCreatorCtrl.wrapperClass > showselectedProducts(string bidId) {
        return Vision_OpportunityCreatorCtrl.showselectedProducts(bidId);
    }
    @AuraEnabled
    public static List < string > getProductDirectorList(Vision_OpportunityCreatorCtrl.BidWrapper bidwrap) {
        return Vision_OpportunityCreatorCtrl.getProductDirectorList(bidwrap);
    }
    
    
    @AuraEnabled
    public static list < Product_Opportunity__c > savequoteitems(list < Vision_OpportunityCreatorCtrl.wrapperClass > saveitems, Vision_OpportunityCreatorCtrl.BidWrapper bidWrapper, List < string > selectrcs) {
        system.debug('calling Vision_OpportunityCreatorCtrl.savequoteitems :: List < string > selectrcs :: '+selectrcs);
        return Vision_OpportunityCreatorCtrl.savequoteitems(saveitems, bidWrapper, selectrcs);
    }
    
    @AuraEnabled
    public static list < Vision_OpportunityCreatorCtrl.wrapperClass > fetchSortResults(string sortField, boolean isAsc, List < Vision_OpportunityCreatorCtrl.wrapperClass > productList) {
        return Vision_OpportunityCreatorCtrl.fetchSortResults(sortField, isAsc, productList);
    }
    
    /*@AuraEnabled
    public static list < Vision_OpportunityCreatorCtrl.wrapperClass > findBySrxOtc(list < string > searchKey, list < string > SearchKeyWordPD, string searchName, string family, List < Vision_OpportunityCreatorCtrl.wrapperClass > productList, Vision_OpportunityCreatorCtrl.BidWrapper quotewrap) {
        return Vision_OpportunityCreatorCtrl.findBySrxOtc(searchKey, SearchKeyWordPD, searchName, family, productList, quotewrap);
    }*/
    
    @AuraEnabled
    public static list < Vision_OpportunityCreatorCtrl.wrapperClass > findBySrxOtc(List < Vision_OpportunityCreatorCtrl.wrapperClass > pItem, list < string > SearchKeyWordPD, string search, string family, list < string > RxSrxList, Vision_OpportunityCreatorCtrl.BidWrapper quotewrap) {
        return Vision_OpportunityCreatorCtrl.finalSearchResult(pItem, SearchKeyWordPD, search, family, RxSrxList, quotewrap);
    }
    
    // Controller code for Contracts view
    @AuraEnabled
    public static List < Phoenix_Contract__c > getContracts(string customerID, string searchInput,string templateType) {
        return Vision_OpportunityCreator.getContracts(customerID, searchInput,templateType);
    }
    
    @AuraEnabled
    public static List < Vision_OpportunityCreatorCtrl.wrapperClass > getContractProducts(Vision_OpportunityCreatorCtrl.BidWrapper quotewrap, List < Id > constractsIdList) {
        system.debug('constractsIdList---' + constractsIdList);
        List < Phoenix_NPR_Data__c > NPRDataLines = [select id, Name, Phoenix_Contract_Type__c, Phoenix_Net_Sales_Internal__c, Phoenix_Dead_Net_Tracking_GR__c, Phoenix_Contract_Price__c, Phoenix_Product__c, Phoenix_Product__r.ProductCode, Phoenix_12Months_Sales_Unit__c, Phoenix_12Months_Net_Sales__c, Phoenix_Per_Unit_Rebate__c, Phoenix_ZITD_Value__c, Phoenix_Rebate__c, Phoenix_Rebate_G_N_Indicator__c, Phoenix_Bonafied_G_N_Indicator__c, Phoenix_Fee_Bonafied_Fee__c, Phoenix_Per_Unit_Bonfied_Fee__c, Phoenix_CD__c, Phoenix_GR_TrackingTier__c from Phoenix_NPR_Data__c where Phoenix_Contract__c IN: constractsIdList LIMIT 20000];
        Set < Id > productsIdSet = new Set < Id > ();
        for (Phoenix_NPR_Data__c NPRLine: NPRDataLines) {
            productsIdSet.add(NPRLine.Phoenix_Product__c);
        }
        
        List < Id > productIdList = new List < Id > ();
        productIdList.addAll(productsIdSet);
        
        return Vision_OpportunityCreatorCtrl.getproductsForSelectedCnts(quotewrap, productIdList);
        
    }
    @AuraEnabled
    public static void bidcountrecords(string strfromle, string bitid, Integer totalRecords) {
       /* system.debug('method starting time----' + system.now().getTime());
        
        String returnresponse = '';
        List < fieldWrapper > datalist = (List < fieldWrapper > ) JSON.deserialize(strfromle, List < fieldWrapper > .class);
        
        list < string > NDC11LIst = new list < string > ();
        list < string > successecordslist = new list < string > ();
        //   set < string > NDC11set = new set < string > ();
        map < string, list < fieldWrapper >> Allwrpper = new map < string, list < fieldWrapper >> ();
        map < string, list < fieldWrapper >> AllDuplicates = new map < string, list < fieldWrapper >> ();
        map < string, fieldWrapper > Allsingle = new map < string, fieldWrapper > ();
        list < fieldWrapper > AllUnMatched = new list < fieldWrapper > ();
        set < fieldWrapper > AllMatched = new set < fieldWrapper > ();
        list < fieldWrapper > AllDuplicateslist = new list < fieldWrapper > ();
        
        for (fieldWrapper wrapper: datalist) {
            if (string.isNotBlank(wrapper.NDC11))
                NDC11LIst.add(wrapper.NDC11);
        }
        
        for (fieldWrapper wrapper: datalist) {
            if (NDC11LIst.size() == totalRecords) {
                // system.debug(' in ndc loop----');
                if (Allwrpper.containsKey(wrapper.NDC11)) {
                    Allwrpper.get(wrapper.NDC11).add(wrapper);
                } else {
                    Allwrpper.put(wrapper.NDC11, new List < fieldWrapper > {
                        wrapper
                            });
                }
            }
        }
        
        if (NDC11LIst.size() == totalRecords) {
            for (Product2 pro2: [select id, Phoenix_NDC_11__c from Product2 where Phoenix_NDC_11__c IN: NDC11LIst AND IsActive = true AND Phoenix_Is_Exclude_Bid__c = false]) {
                successecordslist.add(pro2.Phoenix_NDC_11__c);
            }
        }
        //
        for (string s: Allwrpper.keySet()) {// NDCs
            if (Allwrpper.containsKey(s)) {
                list < fieldWrapper > templist = Allwrpper.get(s);
                if (templist.size() > 1) {
                    Allsingle.put(s, templist[0]); //----it is collecting all key and value pair with single key,single alue i.e avoid duplicate
                    AllDuplicates.put(s, templist);
                    AllDuplicateslist.AddAll(templist);
                    AllDuplicateslist.remove(0);
                    
                } 
                else if (templist.size() == 1) {
                    Allsingle.put(s, templist[0]); //----it is collecting all key and value pair with single key,single alue i.e avoid duplicate
                }
            }
        }
        
        for (string s: Allsingle.keySet()) {
            if (successecordslist.contains(s)) {
                AllMatched.add(Allsingle.get(s)); //----it is collecting all ndc11 is match with procuct nd11 records
            } else if (!successecordslist.contains(s)) {
                AllUnMatched.add(Allsingle.get(s)); //----it is collecting all ndc11 is NOT match with procuct nd11 records
            }
        }
        
        returnWrapper retunwrp = new returnWrapper();
        
        
        retunwrp.successcount = AllMatched.size();
        retunwrp.failedreccount = AllUnMatched.size();
        retunwrp.duplicatecount = AllDuplicateslist.size();
        retunwrp.ndcListcount = NDC11LIst.size();
        //    retunwrp.upcListcount = UPClist.size();
        retunwrp.wrpsuccesslist.addAll(AllMatched);
        retunwrp.wrpUnMatchedlist.addAll(AllUnMatched);
        retunwrp.wrpDuplicateslist.addAll(AllDuplicateslist);
        
        system.debug('method ENDING time----' + system.now().getTime());
        return retunwrp;*/
        //return null;
    }
    /*public class fieldWrapper {
        @AuraEnabled public String NDC11;
        @AuraEnabled public String UPC;
        // @AuraEnabled  public String GPI;        
        @AuraEnabled public String Proposed_direct_Selling_Unit;
        @AuraEnabled public String Proposed_Indirect_Selling_Unit;
        
    }
    public class returnWrapper {
        @AuraEnabled public integer failedreccount;
        @AuraEnabled public integer duplicatecount;
        @AuraEnabled public integer successcount;
        @AuraEnabled public integer ndcListcount;
        @AuraEnabled public integer upcListcount;
        @AuraEnabled public list < fieldWrapper > wrpsuccesslist;
        @AuraEnabled public list < fieldWrapper > wrpUnMatchedlist;
        @AuraEnabled public list < fieldWrapper > wrpDuplicateslist;
        public returnWrapper() {
            wrpsuccesslist = new list < fieldWrapper > ();
            wrpUnMatchedlist = new list < fieldWrapper > ();
            wrpDuplicateslist = new list < fieldWrapper > ();
        }
        
    }*/
    
    @AuraEnabled
    public static string insersuccesslist(string strfromle, string bitid, List < string > selectrcs, Integer totalRecords, Integer totalNDC, Integer totalUPC) {
        //system.debug('strfromle222----'+strfromle);
        /*String returnresponse = '';
        List < fieldWrapper > datalist = (List < fieldWrapper > ) JSON.deserialize(strfromle, List < fieldWrapper > .class);
        map < string, string > successmapdirect_Selling = new map < string, string > ();
        map < string, string > successIndirect_Selling = new map < string, string > ();
        List < Phoenix_Bid_Line_Item__c > BidLineItemInsert = new List < Phoenix_Bid_Line_Item__c > ();
        list < Phoenix_Bid_Fee_Master__c > feeList = new list < Phoenix_Bid_Fee_Master__c > ();
        
        Phoenix_Bid__c bidRecord = [select Phoenix_Customer__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Customer_Type__c from Phoenix_Bid__c where Id =: bitid];
        Account acc;
        if (bidRecord.Phoenix_Customer__c != null) {
            acc = [select Id, Phoenix_Is_Govt_Customer__c, Phoenix_Fee__c, Fee_Type__c, Rebate_Type__c, Phoenix_Cash_Discount__c, Phoenix_Indirect_Cash_Discount__c, Phoenix_Rebates__c, Phoenix_Preferred_Wholesaler__c, Phoenix_Local_VIP__c, Phoenix_CM_Fees__c, Phoenix_RDC_NLC__c from Account where Id =: bidRecord.Phoenix_Customer__c];
            
            
            
            feeList = [select Id, Phoenix_Customer_Type__c, Phoenix_Fee__c, Phoenix_Preferred_Wholesaler__c, Phoenix_Fee_Type__c, Phoenix_Product_Type_for_CM_Fee__c from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c =: acc.Phoenix_Preferred_Wholesaler__c limit 30000];
            
            
        }
        //list<string>
        for (fieldWrapper wrapper: datalist) {
            //system.debug('wrapper----'+wrapper);
            if (totalRecords == totalNDC) {
                successmapdirect_Selling.put(wrapper.NDC11, wrapper.Proposed_direct_Selling_Unit);
                successIndirect_Selling.put(wrapper.NDC11, wrapper.Proposed_Indirect_Selling_Unit);
            } 
            //else {
             //   successmapdirect_Selling.put(wrapper.UPC, wrapper.Proposed_direct_Selling_Unit);
            //    successIndirect_Selling.put(wrapper.UPC, wrapper.Proposed_Indirect_Selling_Unit);
            //}
        }
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
        set < string > ndcList = successmapdirect_Selling.keySet();
        system.debug('-------ndcList------' + ndcList);
        //if(bid.Phoenix_Bid_Type__c=='IPA Floor Pricing Update'){
        //query = 'select Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Is_IPA_Product__c=true) ORDER BY Name ASC NULLS LAST LIMIT 30000'  ;
        // }
        // else{
        query = 'select Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name, ' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND (Phoenix_NDC_11__c IN :ndcList OR  Phoenix_UPC_Universal_Product_Code__c IN :ndcList)) ORDER BY Name ASC NULLS LAST LIMIT 30000';
        //}
        
        List < Product2 > prlist = Database.query(query);
        system.debug('-------prlist11111111------' + prlist);
        list < Phoenix_Bid_Line_Item__c > existingLines = [select Phoenix_NDC_Without_Dashes__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bitid limit 30000];
        list < string > ndcValues = new list < string > ();
        for (Phoenix_Bid_Line_Item__c pbl: existingLines) {
            ndcValues.add(pbl.Phoenix_NDC_Without_Dashes__c);
            
        }
        if (datalist.size() > 0) {
            for (Product2 pro2: prlist) {
                //system.debug('---------111----'+ pro2.Phoenix_NDC_11__c);
                system.debug('---------ndcValues-contains' + ndcValues.contains(pro2.Phoenix_NDC_11__c));
                
                if (ndcValues.contains(pro2.Phoenix_NDC_11__c) == false) {
                    Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c();
                    pbl.Phoenix_Product__c = pro2.id;
                    pbl.Phoenix_Bid__c = bitid;
                    
                    if (totalRecords == totalNDC) {
                        if (successmapdirect_Selling.containsKey(pro2.Phoenix_NDC_11__c)) {
                            //---is Proposed_direct_Selling_Unit blank or null from excel?-- if yes assign 0
                            if (successmapdirect_Selling.get(pro2.Phoenix_NDC_11__c) == '' || successmapdirect_Selling.get(pro2.Phoenix_NDC_11__c) == 'null') {
                                if (bidRecord.Phoenix_Customer_Type__c == 'Econdisc' || bidRecord.Phoenix_Customer_Type__c == 'RXSS')
                                    pbl.Phoenix_Others_Direct__c = 0;
                                
                                else
                                    pbl.Phoenix_Proposed_Direct_Selling_Unit__c = 0;
                                
                                
                            } 
                            else {
                                
                                if (bidRecord.Phoenix_Customer_Type__c == 'Econdisc' || bidRecord.Phoenix_Customer_Type__c == 'RXSS') {
                                    if (successmapdirect_Selling.get(pro2.Phoenix_NDC_11__c) != null && successmapdirect_Selling.get(pro2.Phoenix_NDC_11__c) != '') {
                                        pbl.Phoenix_Others_Direct__c = integer.valueof(successmapdirect_Selling.get(pro2.Phoenix_NDC_11__c));
                                    }
                                } else {
                                    if (successmapdirect_Selling.get(pro2.Phoenix_NDC_11__c) != null && successmapdirect_Selling.get(pro2.Phoenix_NDC_11__c) != '') {
                                        pbl.Phoenix_Proposed_Direct_Selling_Unit__c = integer.valueof(successmapdirect_Selling.get(pro2.Phoenix_NDC_11__c));
                                    }
                                }
                            }
                        }
                        if (successIndirect_Selling.containsKey(pro2.Phoenix_NDC_11__c)) {
                            //---is Phoenix_Proposed_Indirect_Selling_Unit__c blank or null from excel?-- if yes assign 0
                            if (successIndirect_Selling.get(pro2.Phoenix_NDC_11__c) == '' || successIndirect_Selling.get(pro2.Phoenix_NDC_11__c) == 'null') {
                                
                                if (bidRecord.Phoenix_Customer_Type__c == 'Econdisc' || bidRecord.Phoenix_Customer_Type__c == 'RXSS')
                                    pbl.Phoenix_Others_Indirect__c = 0;
                                else
                                    pbl.Phoenix_Proposed_Indirect_Selling_Unit__c = 0;
                                
                            } else {
                                
                                if (bidRecord.Phoenix_Customer_Type__c == 'Econdisc' || bidRecord.Phoenix_Customer_Type__c == 'RXSS') {
                                    if (successIndirect_Selling.get(pro2.Phoenix_NDC_11__c) != null && successIndirect_Selling.get(pro2.Phoenix_NDC_11__c) != '') {
                                        pbl.Phoenix_Others_Indirect__c = integer.valueof(successIndirect_Selling.get(pro2.Phoenix_NDC_11__c));
                                    }
                                } else {
                                    if (successIndirect_Selling.get(pro2.Phoenix_NDC_11__c) != null && successIndirect_Selling.get(pro2.Phoenix_NDC_11__c) != '') {
                                        pbl.Phoenix_Proposed_Indirect_Selling_Unit__c = integer.valueof(successIndirect_Selling.get(pro2.Phoenix_NDC_11__c));
                                    }
                                }
                                
                            }
                        }
                    } 
                    
                    pbl.Phoenix_NDC__c = pro2.Phoenix_NDC_11_Dashes__c;
                    pbl.Phoenix_NDC_Without_Dashes__c = pro2.Phoenix_NDC_11__c;
                    pbl.Phoenix_Product_Code1__c = pro2.ProductCode;
                    pbl.Phoenix_Pkg_Size1__c = pro2.Phoenix_Pkg_Size__c;
                    pbl.Phoenix_Case_Pack1__c = pro2.Phoenix_Case_Pack__c;
                    pbl.Phoenix_MOQ1__c = pro2.Phoenix_Minimum_Order_Quantity__c;
                    pbl.Phoenix_Product_Family1__c = pro2.Family;
                    pbl.Phoenix_Direct_Order_Price1__c = pro2.Phoenix_Direct_Order_Price__c;
                    pbl.Phoenix_Compare_To_Brand_Name1__c = pro2.Phoenix_Compare_to_Brand_Name__c;
                    if (pro2.Phoenix_Product_Director__c != null) {
                        pbl.Phoenix_Product_Director1__c = pro2.Phoenix_Product_Director__r.FirstName + ' ' + pro2.Phoenix_Product_Director__r.LastName;
                    }
                    pbl.Phoenix_Orange_Book_Rating1__c = pro2.Phoenix_Orange_Book_Rating__c;
                    pbl.Phoenix_Throughput_Cost1__c = pro2.Phoenix_Throughput_cost__c;
                    pbl.Phoenix_WAC1__c = pro2.Phoenix_WAC__c;
                    pbl.Phoenix_Budgeted_ASP1__c = pro2.Phoenix_Current_Budgeted_ASP__c;
                    pbl.Phoenix_Lowest_Price_SKU1__c = pro2.Phoenix_Lowest_Price_SKU__c;
                    pbl.Phoenix_Comm_Exps1__c = pro2.Phoenix_Comm_Exps__c;
                    if (pro2.Phoenix_PS_Partner_1_Name__r.Name != null) {
                        pbl.Phoenix_PS_Partner_11__c = pro2.Phoenix_PS_Partner_1_Name__r.Name;
                    }
                    pbl.Phoenix_PS_Partner_1percent__c = pro2.Phoenix_PS_Partner_1__c;
                    if (pro2.Phoenix_PS_Partner_2_Name__r.Name != null) {
                        pbl.Phoenix_PS_Partner_21__c = pro2.Phoenix_PS_Partner_2_Name__r.Name;
                    }
                    pbl.Phoenix_PS_Partner_2percent__c = pro2.Phoenix_PS_Partner_2__c;
                    if (pro2.Phoenix_Royalty_Partner_Name__r.Name != null) {
                        pbl.Phoenix_Royalty_Partner_Name1__c = pro2.Phoenix_Royalty_Partner_Name__r.Name;
                    }
                    pbl.Phoenix_Royaltypercent__c = pro2.Phoenix_Royalty__c;
                    pbl.Phoenix_Min_profit_share_Partner_21__c = pro2.Phoenix_Per_Unit_Profit_Partner_2__c;
                    pbl.Phoenix_Min_profit_share_Partner_11__c = pro2.Phoenix_Per_Unit_Profit_Partner_1__c;
                    pbl.Phoenix_UPC_Universal_Product_Code__c = pro2.Phoenix_UPC_Universal_Product_Code__c;
                    pbl.Phoenix_IPA_Floor_Price1__c = pro2.Phoenix_IPA_Floor_Price__c;
                    pbl.Phoenix_UPC_Universal_Product_Code__c = pro2.Phoenix_UPC_Universal_Product_Code__c;
                    pbl.Phoenix_Latest_Estimate__c = pro2.Phoenix_Latest_Estimate__c;
                    pbl.Phoenix_REMS__c = pro2.Phoenix_REMS__c;
                   // pbl.Phoenix_IMS_Market_Share__c = pro2.Phoenix_IMS_Market_Share__c;
                    decimal mediciadReturns = pro2.Phoenix_Medicaid_Per_Unit__c != null ? pro2.Phoenix_Medicaid_Per_Unit__c : 0;
                    decimal returnPerUnit = pro2.Phoenix_Return_Per_Unit__c != null ? pro2.Phoenix_Return_Per_Unit__c : 0;
                    pbl.Phoenix_Estimated_Medicaid_Returns__c = mediciadReturns + returnPerUnit;
                    if (bidRecord.Phoenix_Customer__c != null) {
                        pbl.Phoenix_Current_Rebate__c = acc.Phoenix_Rebates__c;
                        pbl.Phoenix_Rebate_G_N__c = acc.Rebate_Type__c;
                    }
                    if (feeList.size() > 0) {
                        for (Phoenix_Bid_Fee_Master__c pbf: feeList) {
                            if (pro2.Phoenix_Product_Type_for_CM_Fee__c == pbf.Phoenix_Product_Type_for_CM_Fee__c && pbf.Phoenix_Fee_Type__c == 'CM Fee%' && (acc.Phoenix_Is_Govt_Customer__c == true && pbf.Phoenix_Customer_Type__c == 'Govt business')) {
                                pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c = pbf.Phoenix_Fee__c;
                            }
                            if (pro2.Phoenix_Product_Type_for_CM_Fee__c == pbf.Phoenix_Product_Type_for_CM_Fee__c && pbf.Phoenix_Fee_Type__c == 'CM Fee%' && (acc.Phoenix_Is_Govt_Customer__c == false && pbf.Phoenix_Customer_Type__c == 'Non Govt business')) {
                                pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c = pbf.Phoenix_Fee__c;
                            }
                            if (pbf.Phoenix_Fee_Type__c == 'RDC/NLC %') {
                                pbl.Phoenix_RDC_NLC__c = pbf.Phoenix_Fee__c;
                            }
                            
                        }
                    }
                    if (bidRecord.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update') {
                        pbl.Phoenix_Proposed_Direct_Selling_Unit__c = 1;
                    }
                    if (bidRecord.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update') {
                        pbl.Phoenix_Proposed_Indirect_Selling_Unit__c = 1;
                    }
                    system.debug('Phoenix_Customer_Type__c ----->' + bidRecord.Phoenix_Customer_Type__c);
                    if (bidRecord.Phoenix_Customer_Type__c == 'Walgreens' || bidRecord.Phoenix_Customer_Type__c == 'ABC Progen' || bidRecord.Phoenix_Customer_Type__c == 'Econdisc' || bidRecord.Phoenix_Customer_Type__c == 'RXSS' || bidRecord.Phoenix_Customer_Type__c == 'ClarusOne' || bidRecord.Phoenix_Customer_Type__c == 'Net Indirect Pricing' || bidRecord.Phoenix_Customer_Type__c == 'Costco' || bidRecord.Phoenix_Customer_Type__c == 'Sams Club' || bidRecord.Phoenix_Bid_Type__c == 'Good Dated OTB' || bidRecord.Phoenix_Bid_Type__c == 'Short Dated OTB') {
                        pbl.Phoenix_Fee_G_N__c = 'Net';
                        if (bidRecord.Phoenix_Customer_Type__c != 'ClarusOne')
                            pbl.Phoenix_Proposed_Current_Rebate__c = acc.Phoenix_Rebates__c;
                        pbl.Phoenix_Current_Rebate__c = acc.Phoenix_Rebates__c;
                        pbl.Phoenix_Current_Admin_Fee__c = acc.Phoenix_Fee__c;
                        pbl.Phoenix_RDC_NLC__c = acc.Phoenix_RDC_NLC__c;
                        pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c = acc.Phoenix_CM_Fees__c;
                        pbl.Phoenix_Local_VIP__c = acc.Phoenix_Local_VIP__c;
                        pbl.Phoenix_Indirect_CD_Per__c = acc.Phoenix_Indirect_Cash_Discount__c != null ? acc.Phoenix_Indirect_Cash_Discount__c : acc.Phoenix_Cash_Discount__c;
                        
                        
                    }
                    BidLineItemInsert.add(pbl);
                }
            }
            if (BidLineItemInsert.size() > 0) {
                try {
                    insert BidLineItemInsert;
                    //returnresponse = 'SUCCESS';
                    returnresponse = string.valueOf(BidLineItemInsert.size());
                    //added by satya
                    String query1 = '';
                    String SobjectApiName1 = 'Phoenix_Bid_Line_Item__c';
                    Map < String, Schema.SObjectType > schemaMap1 = Schema.getGlobalDescribe();
                    Map < String, Schema.SObjectField > fieldMap1 = schemaMap1.get(SobjectApiName1).getDescribe().fields.getMap();
                    String strFields1 = '';
                    for (String fieldName: fieldMap1.keyset()) {
                        if (strFields1 == null || strFields1 == '') {
                            strFields1 = fieldName;
                        } else {
                            strFields1 = strFields1 + ' , ' + fieldName;
                        }
                    }
                    
                    query1 = 'select ' + strFields1 + ' from ' + SobjectApiName1 + ' where Id = : BidLineItemInsert ORDER BY Phoenix_Product_Family__c ASC';
                    List < Phoenix_Bid_Line_Item__c > bidLineItemsList = Database.query(query1);
                    List < Phoenix_Bid_Line_Item__c > bidlinesList = new List < Phoenix_Bid_Line_Item__c > ();
                    Decimal Annualized_TP_Impact = 0;
                    Map < String, List < Phoenix_Bid_Line_Item__c > > productFamilyLines = new Map < String, List < Phoenix_Bid_Line_Item__c > > ();
                    for (Phoenix_Bid_Line_Item__c bidline: bidLineItemsList) {
                        if (bidline.Phoenix_Product_Family__c != null && !productFamilyLines.containsKey(bidline.Phoenix_Product_Family__c)) {
                            bidlinesList.add(bidline);
                            productFamilyLines.put(bidline.Phoenix_Product_Family__c, bidlinesList);
                        } else if (bidline.Phoenix_Product_Family__c != null) {
                            bidlinesList.add(bidline);
                            productFamilyLines.put(bidline.Phoenix_Product_Family__c, bidlinesList);
                        }
                    }
                    if (productFamilyLines != null) {
                        
                        for (Phoenix_Bid_Line_Item__c bidline: bidLineItemsList) {
                            Annualized_TP_Impact += bidline.Phoenix_Budgeted_ASP__c;
                            
                        }
                        
                    }
                    //List<Wrapper> wrapperList = new List<Wrapper>();
                    
                    //end by satya
                    
                    //Updating the Bid Phoenix_Reference_Contracts__c fields with selected contracts names
                    String selectedContNames = '';
                    if (!selectrcs.isEmpty()) {
                        List < String > selectrcsWithoutDup = new List < String > ();
                        selectedContNames = String.isNotBlank(bidRecord.Phoenix_Reference_Contracts__c) && bidRecord.Phoenix_Reference_Contracts__c != null ? bidRecord.Phoenix_Reference_Contracts__c : '';
                        for (String s: selectrcs) {
                            if (string.isNotBlank(selectedContNames) && !selectedContNames.contains(s)) {
                                selectrcsWithoutDup.add(s);
                            }
                        }
                        if (string.isNotBlank(selectedContNames) && !selectrcsWithoutDup.isEmpty()) selectedContNames += ',';
                        if (string.isBlank(selectedContNames)) {
                            selectedContNames += string.join(selectrcs, ',');
                        } else {
                            selectedContNames += string.join(selectrcsWithoutDup, ',');
                        }
                        Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bitid, Phoenix_Reference_Contracts__c = selectedContNames);
                        update bid;
                    }
                   
                } catch (Exception ex) {
                    //returnresponse = 'ERROR';
                }
            }
        }
        return returnresponse;*/
        return null;
    }
    @AuraEnabled
    public static list<Competitor__c> getCompetitorInfo() {
        list<Competitor__c> complist=new list<Competitor__c>();
        for(Competitor__c Compobj:[select Id,Name from Competitor__c])
            complist.add(Compobj);
        return complist;
    }
    @AuraEnabled
    public static string saveOptyProductsManual(String optyData, list < Vision_OpportunityCreator.prdwrapperClass > saveitems, List < string > selectrcs) {
        system.debug('calling Vision_OpportunityCreatorCtrl.saveOptyProductsManual :: List < string > selectrcs :: '+selectrcs);
        return Vision_OpportunityCreator.saveOptyProductsManual(optyData, saveitems, selectrcs);
    }
    @AuraEnabled
    public static string saveOptyExtProductsManual(String optyId, String saveitems) {
        system.debug('calling Vision_OpportunityCreatorCtrl.saveOptyExtProductsManual ::');
        return Vision_OpportunityCreator.saveOptyExtProductsManual(optyId, saveitems);
    }
    
    @AuraEnabled
    public static string saveProductsToExtOpty(String optyId, list < Vision_OpportunityCreator.prdwrapperClass > saveitems, List < string > selectrcs) {
        return Vision_OpportunityCreator.saveProductsToExtOpty(optyId, saveitems, selectrcs);
    }
    @AuraEnabled
    public static Map<String,Competitor_Info__c> getCompetitorInfoObjData(String ndcWithDashes, String ndc) {
        return Vision_OpportunityCreator.getCompetitorInfoObjData(ndcWithDashes,ndc);
    }
    
    
    @auraEnabled
    public static list<Vision_OpportunityCreator.prdwrapperClass> getNPRdata(String CustomerId, List<String> contractsIds,
                                                                             list<Vision_OpportunityCreator.prdwrapperClass> optyProdList)
    {return Vision_OpportunityCreator.getNPRdata(CustomerId,contractsIds,optyProdList);}
    
    @auraEnabled
    public static string getTemplateFromAcc(String accId){
        Account accObj = [SELECT Id, Name, Phoenix_Customer_Class_Bid_Template__c, Phoenix_Is_OTC_Customer__c FROM Account WHERE Id= :accId];
        return accObj.Phoenix_Is_OTC_Customer__c ? 'OTC Customer' : accObj.Phoenix_Customer_Class_Bid_Template__c;
    }
    
}