/**
* @description       : 
* @author            : Surender Patel (Dhruvsoft)
* @group             :   
* @last modified on  : 25-05-2021
* @last modified by  : Surender Patel (Dhruvsoft)
* Modifications Log 
* Ver   Date         Author                       Modification
* 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
public class Phoenix_OfferGenerationInfoCls {
    public Phoenix_Bid__c bid {
        get;
        set;
    }
     public String numToWord {
        get;
        set;
    }
    public Phoenix_NDC_Change__c ndc {
        get;
        set;
    }
    public Phoenix_WAC_Change__c wac {
        get;
        set;
    }
    public List < Phoenix_Bid_Line_Item__c > lineItems {
        get;
        set;
    }
    
    public List < Phoenix_NDC_Change_Product__c > ndcLineItems {
        get;
        set;
    }
    
    public List<Phoenix_WAC_Change_Line_Item__c>waclinesrcds { // For Second Wac template
        get;
        set;
    }
        public List<Phoenix_WAC_Change_Line_Item__c>wacLineItems {
        get;
        set;
    }
    
    
    public List < String > contractsList {
        get;
        set;
    }
    
    public list < Product2 > pFamilies {
        get;
        set;
    }
    
    public list < Account > customers {
        get;
        set;
    }
    
    public user currentuser {
        get;
        set;
    }
    public String LogoId {
        get;
        set;
    }
    public string productfamilies{  // For Second Wac template
        get;
        set;   
    }
    
    public Phoenix_OfferGenerationInfoCls() {
        try {
            string BidId = Apexpages.CurrentPage().getParameters().get('bidID'); ////Apexpages.CurrentPage().getParameters().get('BidID');
            string productFamily = Apexpages.CurrentPage().getParameters().get('productFamily');
            string relatedTo = Apexpages.CurrentPage().getParameters().get('relatedTo');
            string customerId = Apexpages.CurrentPage().getParameters().get('customerId');
            bid = new Phoenix_Bid__c();
            lineItems = new List < Phoenix_Bid_Line_Item__c > ();
            wac = new Phoenix_WAC_Change__c();
            ndc = new Phoenix_NDC_Change__c();
            ndcLineItems = new List <Phoenix_NDC_Change_Product__c>();
            wacLineItems = new List <Phoenix_WAC_Change_Line_Item__c>();
             waclinesrcds  = new List<Phoenix_WAC_Change_Line_Item__c>(); // for second wac
            contractsList = new List<String>();
            currentuser = [Select Id, Name, Email, Title from User where Id =: userinfo.getuserId()];
            Map < String, Account > custMap = new Map < String, Account > ();
            List<Phoenix_WAC_Change_Line_Item__c> offerwacLineItems  = new List<Phoenix_WAC_Change_Line_Item__c>();
            List<Phoenix_WAC_Change_Line_Item__c>wacs  = new List<Phoenix_WAC_Change_Line_Item__c>();// for second wac
            List<Phoenix_WAC_Change_Line_Item__c>wacs2  = new List<Phoenix_WAC_Change_Line_Item__c>();// for second wac
            set < String > wacpfset = new set < String > ();//for concate product families
            list < String > wacpflist = new list < String > ();//for concate product families
            
            if (BidId != null) {
                if(relatedTo == 'NDC Change'){
                    ndc = [SELECT Id, Name FROM Phoenix_NDC_Change__c WHERE Id =: BidId LIMIT 1];
                    if (productFamily == 'All') {
                        set < string > pfset = new set < string > ();
                        Map < String, Product2 > pfmap = new Map < String, Product2 > ();
                        if(customerId == 'All'){
                            ndcLineItems = [SELECT Id, Phoenix_Current_NDC__c, Phoenix_Proposed_NDC__c, Phoenix_Current_Product__r.Name, Phoenix_Current_Product__r.Phoenix_WAC__c, Phoenix_Current_Product__r.Family, Phoenix_Current_Product__r.Phoenix_Pkg_Size__c, Phoenix_Proposed_Product__r.Name, Phoenix_Proposed_Product__r.Phoenix_WAC__c, Phoenix_Proposed_Product__r.Phoenix_Pkg_Size__c FROM Phoenix_NDC_Change_Product__c WHERE Phoenix_NDC_Change_Name__c =: BidId];   
                            //ndcLineItems = [SELECT Id, Phoenix_Current_Product_NDC__c, Phoenix_New_NDC_Effective_Date__c, Phoenix_Proposed_Product_NDC__c, Phoenix_Current_Product__r.Name, Phoenix_Current_Product__r.Phoenix_WAC__c, Phoenix_Current_Product__r.Family, Phoenix_Current_Product__r.Phoenix_Pkg_Size__c, Phoenix_Proposed_Product__r.Name, Phoenix_Proposed_Product__r.Phoenix_WAC__c, Phoenix_Proposed_Product__r.Phoenix_Pkg_Size__c FROM Phoenix_NDC_Change_Line_Item__c WHERE Phoenix_NDC_Change__c =: BidId AND Phoenix_Finance_Approval__c =: 'Approved'];   
                        } 
                        /*else{
                            ndcLineItems = [SELECT Id, Phoenix_Current_NDC__c, Phoenix_Proposed_NDC__c, Phoenix_Current_Product__r.Name, Phoenix_Current_Product__r.Phoenix_WAC__c, Phoenix_Current_Product__r.Family, Phoenix_Current_Product__r.Phoenix_Pkg_Size__c, Phoenix_Proposed_Product__r.Name, Phoenix_Proposed_Product__r.Phoenix_WAC__c, Phoenix_Proposed_Product__r.Phoenix_Pkg_Size__c FROM Phoenix_NDC_Change_Product__c WHERE Phoenix_NDC_Change_Name__c =: BidId AND Phoenix_Account__c =:customerId];
                            //ndcLineItems = [SELECT Id, Phoenix_Current_Product_NDC__c, Phoenix_New_NDC_Effective_Date__c, Phoenix_Proposed_Product_NDC__c, Phoenix_Current_Product__r.Name, Phoenix_Current_Product__r.Phoenix_WAC__c, Phoenix_Current_Product__r.Family, Phoenix_Current_Product__r.Phoenix_Pkg_Size__c, Phoenix_Proposed_Product__r.Name, Phoenix_Proposed_Product__r.Phoenix_WAC__c, Phoenix_Proposed_Product__r.Phoenix_Pkg_Size__c FROM Phoenix_NDC_Change_Line_Item__c WHERE Phoenix_NDC_Change__c =: BidId AND Phoenix_Finance_Approval__c =: 'Approved' AND Phoenix_Account__c =:customerId];
                        }*/
                        for (Phoenix_NDC_Change_Product__c pf: [SELECT Id, Phoenix_Current_Product__r.Product_Family__r.Name, Phoenix_Current_Product__r.Family FROM Phoenix_NDC_Change_Product__c WHERE Phoenix_NDC_Change_Name__r.Id =: BidId]) {
                            pfset.add(pf.Phoenix_Current_Product__r.Product_Family__r.Name);
                        }
                        pFamilies = [select Id, Family, Product_Family__r.Name from Product2 where Product_Family__r.Name =: pfset];
                        
                        for (Product2 p2: pFamilies) {
                            pfmap.put(p2.Product_Family__r.Name, p2);
                        }
                        for(Account acc: customers){
                            custMap.put(acc.Name, acc);
                        }
                        pFamilies = pfmap.values();
                        customers = custMap.values();
                    } else {
                        if(customerId == 'All'){
                            ndcLineItems = [SELECT Id, Phoenix_Current_NDC__c, Phoenix_Proposed_NDC__c, Phoenix_Current_Product__r.Name, Phoenix_Current_Product__r.Family, Phoenix_Current_Product__r.Product_Family__r.Name, Phoenix_Current_Product__r.Phoenix_WAC__c, Phoenix_Current_Product__r.Phoenix_Pkg_Size__c, Phoenix_Proposed_Product__r.Name, Phoenix_Proposed_Product__r.Phoenix_Pkg_Size__c, Phoenix_Proposed_Product__r.Phoenix_WAC__c FROM Phoenix_NDC_Change_Product__c WHERE Phoenix_NDC_Change_Name__c =: BidId];   
                        } 
                        /*else{
                            ndcLineItems = [SELECT Id, Phoenix_Current_NDC__c, Phoenix_Proposed_NDC__c, Phoenix_Current_Product__r.Name, Phoenix_Current_Product__r.Family, Phoenix_Current_Product__r.Phoenix_WAC__c, Phoenix_Current_Product__r.Phoenix_Pkg_Size__c, Phoenix_Proposed_Product__r.Name, Phoenix_Proposed_Product__r.Phoenix_Pkg_Size__c, Phoenix_Proposed_Product__r.Phoenix_WAC__c FROM Phoenix_NDC_Change_Product__c WHERE Phoenix_NDC_Change_Name__c =: BidId AND Phoenix_Current_Product__r.Family =: productFamily AND Phoenix_Account__c =:customerId];
                        }*/
                        pFamilies = [select Id, Family, Product_Family__r.Name from Product2 where Product_Family__r.Name =: productFamily LIMIT 1];
                        //customers = [select Id, Name from Account where Id =: accountId];
                    }
                } 
                
                
                else{
                    bid = [SELECT Id, Name, Phoenix_Bid_Type__c, Phoenix_Reference_Contracts__c, Phoenix_Salesperson__r.Name, Phoenix_Salesperson__r.Email, Phoenix_Bid_Name__c, Phoenix_Contact__r.Name, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Offer_Valid_up_to__c, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Email, Phoenix_Customer__r.City__c, Phoenix_Customer__r.State__c, Phoenix_Customer__r.Zip__c, Phoenix_Customer__r.Street_Address_1__c FROM Phoenix_Bid__c WHERE ID =: BidId LIMIT 1];
                    String refContracts = bid.Phoenix_Reference_Contracts__c;
                    numToWord = NumberToWord.convert_nn(Integer.valueOf(bid.Phoenix_Proposed_Initial_Order_Discount__c));
                    if(refContracts != null){
                        contractsList = refContracts.split(',');   
                    }
                    system.debug('Contracts::: '+contractsList);
                    if (productFamily == 'All') {
                        set < string > pfset = new set < string > ();
                        Map < String, Product2 > pfmap = new Map < String, Product2 > ();
                        if (bid.Phoenix_Bid_Type__c == 'Volume Review Only') {
                            lineItems = [SELECT Id,Product_Family_Name__c, Product_Family__c,Phoenix_Proposed_Anda_Units__c, Phoenix_IDN_Usage__c, Phoenix_Customer_Dead_net__c, Phoenix_Current_Net_Indirect_Price__c ,Phoenix_Current_Price_Calc__c,Phoenix_Final_Direct_Selling_Units__c,Phoenix_Customer_Dead_Net1__c,Phoenix_Contract__r.Phoenix_Contract_Number__c, Phoenix_Total_SCM_Approved_Qty__c, Phoenix_Case_Pack__c, Phoenix_ProposedContractBidPriceMktng__c, Phoenix_Compare_To_Brand_Name1__c, Phoenix_Pkg_Size1__c, (SELECT Id, Phoenix_Proposed_Major_Contract_Price__c, Phoenix_Proposed_CvsDirectContractPrice__c, Phoenix_Major_Rebate_per__c, Phoenix_PropMarktCvsCardinalAcquisitCost__c, Phoenix_Preferred_Cardinal_Rebate_per__c,Phoenix_Current_Major_Contract_Price__c FROM BidLineItemsExtn__r), Phoenix_Days_Notice_Product_Discontinuat__c,Phoenix_Current_Retail_Direct_Price__c,Phoenix_Current_Retail_Indirect_Price__c,Phoenix_Current_Retail_Indirect_Net__c,Phoenix_Current_Wholesaler_Price__c,Phoenix_Wholesaler_Price_RxSS__c,Phoenix_Proposed_WMT_Direct_NCP__c,Phoenix_ProposedContract_Bid_Price_Sales__c,Phoenix_ProposedIndirectAholdDelhaizeUni__c ,Phoenix_Proposed_IndirectGaintEagleUnits__c,Phoenix_Sales_Proposed_NCP_McK_And_RAD__c,Phoenix_Proposed_McK_OS_And_RAD_NCP__c,Phoenix_Retail_Indirect_Price__c,Phoenix_Proposed_Position__c,Phoenix_Retail_Direct_Price__c,Phoenix_Retail_Indirect_Net__c, Phoenix_Estimated_Lead_Time_Days__c, Name, Phoenix_NDC__c, Phoenix_Current_Direct_Price__c, Phoenix_IOD_Qty__c, Phoenix_Wholesaler_Diff_Price_Indirect__c, Phoenix_Current_Indirect_Price__c, Phoenix_Product__r.Phoenix_Minimum_Order_Quantity__c, Phoenix_WAC1__c, Phoenix_Proposed_Indirect_Selling_Unit__c, Phoenix_Final_Total_Selling_Unit__c, Phoenix_Final_Annual_Extended_Units__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Initial_Order_Discount__c, Phoenix_Awarded_Quantity__c, Phoenix_Product_Family__c, Phoenix_Product__r.Name, Phoenix_Product__r.Description, Phoenix_Bid__c, Phoenix_Product__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Id =: BidId AND(Phoenix_SCM_Approval_Y_N__c =: 'Y- Only Current Monthly Demand Approved'
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      OR Phoenix_SCM_Approval_Y_N__c =: 'Y- Current + Inc Demand Approved') ORDER BY Phoenix_Product__r.Name ASC];
                            for (Phoenix_Bid_Line_Item__c pf: [SELECT Id, Product_Family__r.Name, Phoenix_Product_Family__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Id =: BidId AND(Phoenix_SCM_Approval_Y_N__c =: 'Y- Only Current Monthly Demand Approved'
                                                                                                                                                                       OR Phoenix_SCM_Approval_Y_N__c =: 'Y- Current + Inc Demand Approved')]) {
                                                                                                                                                                           pfset.add(pf.Product_Family__r.Name);
                                                                                                                                                                       }
                        } else {
                            lineItems = [SELECT Id,Product_Family_Name__c, Product_Family__c,Phoenix_Proposed_Anda_Units__c, Phoenix_IDN_Usage__c, Phoenix_Customer_Dead_net__c, Phoenix_Current_Net_Indirect_Price__c ,Phoenix_Current_Price_Calc__c,Phoenix_Final_Direct_Selling_Units__c,Phoenix_Customer_Dead_Net1__c,Phoenix_Contract__r.Phoenix_Contract_Number__c, Phoenix_Total_SCM_Approved_Qty__c, Phoenix_Case_Pack__c, Phoenix_ProposedContractBidPriceMktng__c, Phoenix_Compare_To_Brand_Name1__c, Phoenix_Pkg_Size1__c, (SELECT Id, Phoenix_Proposed_Major_Contract_Price__c, Phoenix_Proposed_CvsDirectContractPrice__c, Phoenix_Major_Rebate_per__c, Phoenix_PropMarktCvsCardinalAcquisitCost__c, Phoenix_Preferred_Cardinal_Rebate_per__c,Phoenix_Current_Major_Contract_Price__c FROM BidLineItemsExtn__r), Phoenix_Days_Notice_Product_Discontinuat__c,Phoenix_Current_Retail_Direct_Price__c,Phoenix_Current_Retail_Indirect_Price__c,Phoenix_Current_Retail_Indirect_Net__c,Phoenix_Current_Wholesaler_Price__c,Phoenix_Wholesaler_Price_RxSS__c,Phoenix_Proposed_WMT_Direct_NCP__c,Phoenix_ProposedContract_Bid_Price_Sales__c,Phoenix_ProposedIndirectAholdDelhaizeUni__c ,Phoenix_Proposed_IndirectGaintEagleUnits__c,Phoenix_Sales_Proposed_NCP_McK_And_RAD__c,Phoenix_Proposed_McK_OS_And_RAD_NCP__c,Phoenix_Retail_Indirect_Price__c,Phoenix_Proposed_Position__c,Phoenix_Retail_Direct_Price__c,Phoenix_Retail_Indirect_Net__c, Phoenix_Estimated_Lead_Time_Days__c, Name, Phoenix_NDC__c, Phoenix_Current_Direct_Price__c, Phoenix_IOD_Qty__c, Phoenix_Wholesaler_Diff_Price_Indirect__c, Phoenix_Current_Indirect_Price__c, Phoenix_Product__r.Phoenix_Minimum_Order_Quantity__c, Phoenix_WAC1__c, Phoenix_Proposed_Indirect_Selling_Unit__c, Phoenix_Final_Total_Selling_Unit__c, Phoenix_Final_Annual_Extended_Units__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Initial_Order_Discount__c, Phoenix_Awarded_Quantity__c, Phoenix_Product_Family__c, Phoenix_Product__r.Name, Phoenix_Product__r.Description, Phoenix_Bid__c, Phoenix_Product__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Id =: BidId AND Phoenix_Finance_Approval__c =: 'Approved' ORDER BY Phoenix_Product__r.Name ASC];
                            for (Phoenix_Bid_Line_Item__c pf: [SELECT Id, Product_Family__r.Name, Phoenix_Product_Family__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Id =: BidId AND Phoenix_Finance_Approval__c =: 'Approved']) {
                                pfset.add(pf.Product_Family__r.Name);
                            }
                        }
                        pFamilies = [select Id, Product_Family__r.Name, Phoenix_FEI_of_API_Manufacturing_Site__c, Phoenix_FEI_of_Finished_Goods_MFR__c, Phoenix_API_Supplier_Name__c, Phoenix_SAP_Molecule_Description__c, Product2.Family, Phoenix_Finished_Goods_Mfactured_Country__c, Phoenix_API_Manufactured_Country__c, Phoenix_Texas_Medicaid_Coverage__c, Phoenix_NDC_Registered_with_FDA__c, Phoenix_Registered_in_Puerto_Rico__c, Phoenix_TAA_Compliant__c from Product2 where Product_Family__r.Name =: pfset];
                        for (Product2 p2: pFamilies) {
                            pfmap.put(p2.Product_Family__r.Name, p2);
                        }
                        pFamilies = pfmap.values();
                    } else {
                        if (bid.Phoenix_Bid_Type__c == 'Volume Review Only') {
                            lineItems = [SELECT Id, Product_Family__r.Name, Phoenix_IDN_Usage__c,Phoenix_Proposed_Anda_Units__c, Phoenix_Customer_Dead_net__c, Phoenix_Current_Net_Indirect_Price__c,Phoenix_Current_Price_Calc__c,Phoenix_Final_Direct_Selling_Units__c,Phoenix_Customer_Dead_Net1__c,Phoenix_Contract__r.Phoenix_Contract_Number__c, Phoenix_Total_SCM_Approved_Qty__c, Phoenix_Case_Pack__c, Phoenix_ProposedContractBidPriceMktng__c, Phoenix_Compare_To_Brand_Name1__c, Phoenix_Pkg_Size1__c, (SELECT Id, Phoenix_Proposed_Major_Contract_Price__c, Phoenix_Proposed_CvsDirectContractPrice__c, Phoenix_Major_Rebate_per__c, Phoenix_PropMarktCvsCardinalAcquisitCost__c, Phoenix_Preferred_Cardinal_Rebate_per__c,Phoenix_Current_Major_Contract_Price__c FROM BidLineItemsExtn__r), Phoenix_Days_Notice_Product_Discontinuat__c,Phoenix_Current_Retail_Direct_Price__c,Phoenix_Current_Retail_Indirect_Price__c,Phoenix_Current_Retail_Indirect_Net__c,Phoenix_Current_Wholesaler_Price__c,Phoenix_Wholesaler_Price_RxSS__c,Phoenix_Proposed_WMT_Direct_NCP__c,Phoenix_ProposedContract_Bid_Price_Sales__c,Phoenix_ProposedIndirectAholdDelhaizeUni__c ,Phoenix_Proposed_IndirectGaintEagleUnits__c,Phoenix_Sales_Proposed_NCP_McK_And_RAD__c,Phoenix_Proposed_McK_OS_And_RAD_NCP__c,Phoenix_Retail_Indirect_Price__c,Phoenix_Proposed_Position__c,Phoenix_Retail_Direct_Price__c,Phoenix_Retail_Indirect_Net__c,Phoenix_Estimated_Lead_Time_Days__c, Name, Phoenix_NDC__c, Phoenix_Current_Direct_Price__c, Phoenix_IOD_Qty__c, Phoenix_Wholesaler_Diff_Price_Indirect__c, Phoenix_Current_Indirect_Price__c, Phoenix_Product__r.Phoenix_Minimum_Order_Quantity__c, Phoenix_WAC1__c, Phoenix_Proposed_Indirect_Selling_Unit__c, Phoenix_Final_Total_Selling_Unit__c, Phoenix_Final_Annual_Extended_Units__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Initial_Order_Discount__c, Phoenix_Awarded_Quantity__c, Phoenix_Product_Family__c, Phoenix_Product__r.Name, Phoenix_Product__r.Description, Phoenix_Bid__c, Phoenix_Product__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Id =: BidId AND(Phoenix_SCM_Approval_Y_N__c =: 'Y- Only Current Monthly Demand Approved'
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    OR Phoenix_SCM_Approval_Y_N__c =: 'Y- Current + Inc Demand Approved') AND Product_Family_Name__c =: productFamily ORDER BY Phoenix_Product__r.Name ASC];
                            pFamilies = [select Id, Family, Product_Family__r.Name, Phoenix_FEI_of_API_Manufacturing_Site__c, Phoenix_FEI_of_Finished_Goods_MFR__c, Phoenix_API_Supplier_Name__c, Phoenix_SAP_Molecule_Description__c, Phoenix_Finished_Goods_Mfactured_Country__c, Phoenix_API_Manufactured_Country__c, Phoenix_Texas_Medicaid_Coverage__c, Phoenix_NDC_Registered_with_FDA__c, Phoenix_Registered_in_Puerto_Rico__c, Phoenix_TAA_Compliant__c from Product2 where Product_Family__r.Name =: productFamily LIMIT 1];
                        } else {
                            lineItems = [SELECT Id,Product_Family__r.Name, Phoenix_Proposed_Anda_Units__c, Phoenix_IDN_Usage__c, Phoenix_Customer_Dead_net__c,Phoenix_Current_Net_Indirect_Price__c,Phoenix_Current_Price_Calc__c,Phoenix_Final_Direct_Selling_Units__c,Phoenix_Customer_Dead_Net1__c,Phoenix_Contract__r.Phoenix_Contract_Number__c, Phoenix_Total_SCM_Approved_Qty__c, Phoenix_Case_Pack__c, Phoenix_ProposedContractBidPriceMktng__c, Phoenix_Compare_To_Brand_Name1__c, Phoenix_Pkg_Size1__c, (SELECT Id, Phoenix_Proposed_Major_Contract_Price__c, Phoenix_Proposed_CvsDirectContractPrice__c, Phoenix_Major_Rebate_per__c, Phoenix_PropMarktCvsCardinalAcquisitCost__c, Phoenix_Preferred_Cardinal_Rebate_per__c,Phoenix_Current_Major_Contract_Price__c FROM BidLineItemsExtn__r), Phoenix_Days_Notice_Product_Discontinuat__c,Phoenix_Current_Retail_Direct_Price__c,Phoenix_Current_Retail_Indirect_Price__c,Phoenix_Current_Retail_Indirect_Net__c,Phoenix_Current_Wholesaler_Price__c,Phoenix_Wholesaler_Price_RxSS__c,Phoenix_Proposed_WMT_Direct_NCP__c,Phoenix_ProposedContract_Bid_Price_Sales__c,Phoenix_ProposedIndirectAholdDelhaizeUni__c ,Phoenix_Proposed_IndirectGaintEagleUnits__c,Phoenix_Sales_Proposed_NCP_McK_And_RAD__c,Phoenix_Proposed_McK_OS_And_RAD_NCP__c,Phoenix_Retail_Indirect_Price__c,Phoenix_Proposed_Position__c,Phoenix_Retail_Direct_Price__c,Phoenix_Retail_Indirect_Net__c,Phoenix_Estimated_Lead_Time_Days__c, Name, Phoenix_NDC__c, Phoenix_Current_Direct_Price__c, Phoenix_IOD_Qty__c, Phoenix_Wholesaler_Diff_Price_Indirect__c, Phoenix_Current_Indirect_Price__c, Phoenix_Product__r.Phoenix_Minimum_Order_Quantity__c, Phoenix_WAC1__c, Phoenix_Proposed_Indirect_Selling_Unit__c, Phoenix_Final_Total_Selling_Unit__c, Phoenix_Final_Annual_Extended_Units__c, Phoenix_Final_Approvd_Pricing_Contracts__c, Phoenix_Initial_Order_Discount__c, Phoenix_Awarded_Quantity__c, Phoenix_Product_Family__c, Phoenix_Product__r.Name, Phoenix_Product__r.Description, Phoenix_Bid__c, Phoenix_Product__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Id =: BidId AND Phoenix_Finance_Approval__c =: 'Approved'
                                         AND Product_Family_Name__c =: productFamily ORDER BY Phoenix_Product__r.Name ASC
                                        ];
                            pFamilies = [select Id, Product_Family__r.Name, Family, Phoenix_FEI_of_API_Manufacturing_Site__c, Phoenix_FEI_of_Finished_Goods_MFR__c, Phoenix_API_Supplier_Name__c, Phoenix_SAP_Molecule_Description__c, Phoenix_Finished_Goods_Mfactured_Country__c, Phoenix_API_Manufactured_Country__c, Phoenix_Texas_Medicaid_Coverage__c, Phoenix_NDC_Registered_with_FDA__c, Phoenix_Registered_in_Puerto_Rico__c, Phoenix_TAA_Compliant__c from Product2 where Product_Family__r.Name =: productFamily LIMIT 1];
                            
                        }
                    }
                    for(Phoenix_Bid_Line_Item__c lineItems:lineItems){
                        /* monthly = lineItems.Phoenix_Total_SCM_Approved_Qty__c != null ? (lineItems.Phoenix_Total_SCM_Approved_Qty__c / 12).setScale(0):0;
system.debug('monthly ----------'+monthly);*/
                        lineItems.Phoenix_Proposed_WMT_Direct_NCP__c=lineItems.Phoenix_Proposed_WMT_Direct_NCP__c != null ?lineItems.Phoenix_Proposed_WMT_Direct_NCP__c:lineItems.Phoenix_ProposedContract_Bid_Price_Sales__c;
                        lineItems.Phoenix_ProposedIndirectAholdDelhaizeUni__c=(lineItems.Phoenix_ProposedIndirectAholdDelhaizeUni__c !=null ? lineItems.Phoenix_ProposedIndirectAholdDelhaizeUni__c:0) + (lineItems.Phoenix_Proposed_IndirectGaintEagleUnits__c !=null ? lineItems.Phoenix_Proposed_IndirectGaintEagleUnits__c:0);
                        lineItems.Phoenix_Proposed_McK_OS_And_RAD_NCP__c=lineItems.Phoenix_Proposed_McK_OS_And_RAD_NCP__c != null ?lineItems.Phoenix_Proposed_McK_OS_And_RAD_NCP__c:lineItems.Phoenix_Sales_Proposed_NCP_McK_And_RAD__c;
                        
                        lineItems.Phoenix_Proposed_WMT_Direct_NCP__c=lineItems.Phoenix_Proposed_WMT_Direct_NCP__c != null ?lineItems.Phoenix_Proposed_WMT_Direct_NCP__c:lineItems.Phoenix_ProposedContract_Bid_Price_Sales__c;
                        //for DSH GO
                        lineItems.Phoenix_IDN_Usage__c=(lineItems.Phoenix_IDN_Usage__c !=null ? lineItems.Phoenix_IDN_Usage__c:0) + (lineItems.Phoenix_Days_Notice_Product_Discontinuat__c !=null ? lineItems.Phoenix_Days_Notice_Product_Discontinuat__c:0);
                        contractsList.add(lineItems.Phoenix_Contract__r.Phoenix_Contract_Number__c);
                        //lineItems.Phoenix_PropMarktCvsCardinalAcquisitCost__c = lineItems.BidLineItemsExtn__r.Phoenix_PropMarktCvsCardinalAcquisitCost__c;
                        string estdate=lineItems.Phoenix_Estimated_Lead_Time_Days__c;
                        if(lineItems.Phoenix_Estimated_Lead_Time_Days__c != null){
                            if(lineItems.Phoenix_Estimated_Lead_Time_Days__c != '0')   {
                                lineItems.Phoenix_Estimated_Lead_Time_Days__c=estdate+' Days';
                            }
                            else{
                                lineItems.Phoenix_Estimated_Lead_Time_Days__c='Immediate';
                            }
                            
                        }else{
                            lineItems.Phoenix_Estimated_Lead_Time_Days__c='';
                        }
                    }
                    system.debug('Line Items:: '+lineItems);
                    system.debug('Contracts List:: '+contractsList);   
                }
            }
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Method_Name__c = 'calculateFinanceGrid', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
}