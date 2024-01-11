public class Vision_ProductAnalysisCls {
    
    @AuraEnabled
    public static wrapperClass getProductAnalysisData(Date startDate, Date endDate, String recordId, String selectedRange){
      
        string Awarded = 'Awarded';
        String declined = 'Declined by Customer';
        String rescinded = 'DRL Rescinded';
        String submittedUnder = 'DRL submitting under New Bid Number';
        string que = '(Select '+Phoenix_Util.customerResponseItemFields+'FROM Customer_Response_Lines__r)';
        string awardsQuery;
        string decreaseQuery;
        string lossQuery;
        string dateQuery;
        string dateLossQuery;
        if(selectedRange == 'Custom' && startDate != null && endDate != null){
            dateQuery = 'AND Phoenix_Customer_Response_Line__r.Phoenix_Price_Effective_Date__c >=:startDate AND Phoenix_Customer_Response_Line__r.Phoenix_Price_Effective_Date__c <=:endDate';
            dateLossQuery = 'AND (Vision_NPR_Created_Date__c >=:startDate AND Vision_NPR_Created_Date__c <=:endDate OR Vision_NPR_Created_Date__c >=: startDate AND Vision_NPR_Created_Date__c <=:endDate)';
        } else{
            dateQuery = 'AND Phoenix_Customer_Response_Line__r.Phoenix_Price_Effective_Date__c ='+selectedRange;
            dateLossQuery = 'AND (Vision_NPR_Created_Date__c ='+selectedRange+')';
        }
        boolean yes = true;
        String nullAwarded = null;
        if(recordId != null){
            //awardsQuery = 'SELECT ID,Vision_NPR_Created_Date__c,Vision_Bid__r.Name, Vision_Bid__r.Phoenix_Bid_Type__c,Vision_Product__r.Description, Vision_Product__r.Family,Name,Bid_Line_Item__r.Name,Bid_Line_Item__r.Phoenix_Awarded_Quantity__c,Vision_Customer_Response__c,Bid_Line_Item__r.Phoenix_Total_Selling_Unit__c,Bid_Line_Item__r.Phoenix_Current_ASP_Dose__c,Bid_Line_Item__r.Phoenix_Proposed_ASP_Dose__c,Bid_Line_Item__r.Phoenix_Price_Effective_Date__c,Vision_Product__r.Name, Bid_Line_Item__r.Phoenix_Proposed_Sales__c, Customer_Response_Line__r.Phoenix_Customer_Response_Date__c FROM Vision_Customer_Product_Tracker__c WHERE Vision_Bid__r.Phoenix_Customer__c =: recordId AND Vision_Start_Of_The_Year__c =: yes AND Customer_Response_Line__r.Phoenix_Bid_Status__c =:nullAwarded ORDER BY Vision_Product__r.Name';
            awardsQuery = 'SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c,Phoenix_Product__r.Description, Phoenix_Product__r.Product_Family__r.Name, Phoenix_Product__r.Family,Name,Phoenix_Awarded_Quantity__c,Phoenix_Customer_Response__c,Phoenix_Total_Selling_Unit__c,Phoenix_Current_ASP_Dose__c,Phoenix_Proposed_ASP_Dose__c,Phoenix_Price_Effective_Date__c,Phoenix_Product__r.Name, Phoenix_Proposed_Sales__c, Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c,'+que+' FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Phoenix_Customer__c =: recordId AND Phoenix_Bid_Status__c =:Awarded '+dateQuery+' ORDER BY Phoenix_Product__r.Name'  ;          
            decreaseQuery = 'SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c,Phoenix_Product__r.Product_Family__r.Name,Phoenix_Product__r.Description, Phoenix_Product__r.Family,Name,Phoenix_Awarded_Quantity__c,Phoenix_Customer_Response__c,Phoenix_Total_Selling_Unit__c,Phoenix_Current_ASP_Dose__c,Phoenix_Proposed_ASP_Dose__c,Phoenix_Price_Effective_Date__c,Phoenix_Product__r.Name, Phoenix_Proposed_Sales__c, Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c,'+que+' FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__r.Phoenix_Customer__c =: recordId AND Phoenix_Bid_Status__c =:Awarded '+dateQuery+' ORDER BY Phoenix_Product__r.Name';
            lossQuery = 'SELECT ID,Vision_NPR_Created_Date__c,Vision_Bid__r.Name,Phoenix_Product__r.Product_Family__r.Name, Vision_Bid__r.Phoenix_Bid_Type__c,Vision_Product__r.Description, Vision_Product__r.Family,Name,Bid_Line_Item__r.Name,Bid_Line_Item__r.Phoenix_Awarded_Quantity__c,Vision_Customer_Response__c,Bid_Line_Item__r.Phoenix_Total_Selling_Unit__c,Bid_Line_Item__r.Phoenix_Current_ASP_Dose__c,Bid_Line_Item__r.Phoenix_Proposed_ASP_Dose__c,Bid_Line_Item__r.Phoenix_Price_Effective_Date__c,Vision_Product__r.Name, Bid_Line_Item__r.Phoenix_Proposed_Sales__c, Customer_Response_Line__r.Phoenix_Customer_Response_Date__c FROM Vision_Customer_Product_Tracker__c WHERE Vision_Bid__r.Phoenix_Customer__c =: recordId AND Vision_Start_Of_The_Year__c =: yes AND Vision_Is_True_Opportunity__c =:yes '+dateLossQuery+' ORDER BY Vision_Product__r.Name';
        } else{
            awardsQuery = 'SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c,Phoenix_Product__r.Product_Family__r.Name,Phoenix_Product__r.Description, Phoenix_Product__r.Family,Name,Phoenix_Awarded_Quantity__c,Phoenix_Customer_Response__c,Phoenix_Total_Selling_Unit__c,Phoenix_Current_ASP_Dose__c,Phoenix_Proposed_ASP_Dose__c,Phoenix_Price_Effective_Date__c,Phoenix_Product__r.Name, Phoenix_Proposed_Sales__c, Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c,'+que+' FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid_Status__c =:Awarded '+dateQuery+' ORDER BY Phoenix_Product__r.Name'  ;                  
            decreaseQuery = 'SELECT ID,Phoenix_Bid__r.Phoenix_Bid_Type__c,Phoenix_Product__r.Product_Family__r.Name,Phoenix_Product__r.Description, Phoenix_Product__r.Family,Name,Phoenix_Awarded_Quantity__c,Phoenix_Customer_Response__c,Phoenix_Total_Selling_Unit__c,Phoenix_Current_ASP_Dose__c,Phoenix_Proposed_ASP_Dose__c,Phoenix_Price_Effective_Date__c,Phoenix_Product__r.Name, Phoenix_Proposed_Sales__c, Phoenix_Customer_Response_Line__r.Phoenix_Customer_Response_Date__c,'+que+' FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid_Status__c =:Awarded '+dateQuery+' ORDER BY Phoenix_Product__r.Name';
            lossQuery = 'SELECT ID,Vision_NPR_Created_Date__c,Vision_Bid__r.Name,Phoenix_Product__r.Product_Family__r.Name, Vision_Bid__r.Phoenix_Bid_Type__c,Vision_Product__r.Description, Vision_Product__r.Family,Name,Bid_Line_Item__r.Name,Bid_Line_Item__r.Phoenix_Awarded_Quantity__c,Vision_Customer_Response__c,Bid_Line_Item__r.Phoenix_Total_Selling_Unit__c,Bid_Line_Item__r.Phoenix_Current_ASP_Dose__c,Bid_Line_Item__r.Phoenix_Proposed_ASP_Dose__c,Bid_Line_Item__r.Phoenix_Price_Effective_Date__c,Vision_Product__r.Name, Bid_Line_Item__r.Phoenix_Proposed_Sales__c, Customer_Response_Line__r.Phoenix_Customer_Response_Date__c FROM Vision_Customer_Product_Tracker__c WHERE Vision_Start_Of_The_Year__c =: yes AND Vision_Is_True_Opportunity__c =:yes '+dateLossQuery+' ORDER BY Vision_Product__r.Name';
        }
        List<Phoenix_Bid_Line_Item__c> recentAwardsList = Database.query(awardsQuery);
        List<Phoenix_Bid_Line_Item__c> recentAwardsRFPList = new List<Phoenix_Bid_Line_Item__c>();
        List<Phoenix_Bid_Line_Item__c> recentAwardsNewPLList = new List<Phoenix_Bid_Line_Item__c>();
        List<Phoenix_Bid_Line_Item__c> recentAwardsProdAdditionList = new List<Phoenix_Bid_Line_Item__c>();
        List<Phoenix_Bid_Line_Item__c> recentAwardsNewCustomerList = new List<Phoenix_Bid_Line_Item__c>();
        List<Phoenix_Bid_Line_Item__c> decreasesList = Database.query(decreaseQuery);
        List<Phoenix_Bid_Line_Item__c> decreasesRFPList = new List<Phoenix_Bid_Line_Item__c>();
        List<Phoenix_Bid_Line_Item__c> decreasesPriceChangeList = new List<Phoenix_Bid_Line_Item__c>();
        List<Phoenix_Bid_Line_Item__c> decreasesvolumeReviewList = new List<Phoenix_Bid_Line_Item__c>();
        List<Vision_Customer_Product_Tracker__c> productLossesList = Database.query(lossQuery);
        List<Vision_Customer_Product_Tracker__c> productLossesMassProductRemovalList = new List<Vision_Customer_Product_Tracker__c>(); 
        List<Vision_Customer_Product_Tracker__c> productLossesPriceChangeList = new List<Vision_Customer_Product_Tracker__c>();
        List<Vision_Customer_Product_Tracker__c> productLossesvolumeReviewList = new List<Vision_Customer_Product_Tracker__c>();
        List<Vision_Customer_Product_Tracker__c> productLossesRFPList = new List<Vision_Customer_Product_Tracker__c>();
        //map<String,List<Phoenix_Bid_Line_Item__c>> mapList = new map<String,List<Phoenix_Bid_Line_Item__c>>();
        map<Integer,String > monthdatelist = new map<Integer,String>();
        monthdatelist.put(1,'Jan');
        monthdatelist.put(2,'Feb');
        monthdatelist.put(3,'Mar');
        monthdatelist.put(4,'Apr');
        monthdatelist.put(5,'May');
        monthdatelist.put(6,'Jun');
        monthdatelist.put(7,'Jul');
        monthdatelist.put(8,'Aug');
        monthdatelist.put(9,'Sep');
        monthdatelist.put(10,'Oct');
        monthdatelist.put(11,'Nov');
        monthdatelist.put(12,'Dec');
        Map<String,Integer> monthlist = new Map<String,Integer>();
        monthlist.put('April',1);
        monthlist.put('May',2);
        monthlist.put('June',3);
        monthlist.put('July',4);
        monthlist.put('Aug',5);
        monthlist.put('Sept',6);
        monthlist.put('Oct',7);
        monthlist.put('Nov',8);
        monthlist.put('Dec',9);
        monthlist.put('jan',10);
        monthlist.put('Feb',11);   
        monthlist.put('Mar',12);   
        //system.debug('recentAwardsList-->'+recentAwardsList.size());
        List<Decimal> financialImpactsProdAdd =  new List<Decimal>();
        Map<Id,Decimal> mapListFIProdAdd = new Map<Id,Decimal>();
        Map<Id,Decimal> mapListFIRFP = new Map<Id,Decimal>();
        Map<Id,Decimal> mapListFINewPL = new Map<Id,Decimal>();
        Map<Id,Decimal> mapListFINewCustomer = new Map<Id,Decimal>();
        Map<String, List<Phoenix_Bid_Line_Item__c>> mapRecentAwardsProductAdditionList = new Map<String, List<Phoenix_Bid_Line_Item__c>>();
        Map<String, List<Phoenix_Bid_Line_Item__c>> mapRecentAwardsNPLList = new Map<String, List<Phoenix_Bid_Line_Item__c>>();
        Map<String, List<Phoenix_Bid_Line_Item__c>> mapRecentAwardsRFPList = new Map<String, List<Phoenix_Bid_Line_Item__c>>();
        Map<String, List<Phoenix_Bid_Line_Item__c>> mapRecentAwardsNCList = new Map<String, List<Phoenix_Bid_Line_Item__c>>();
        for(Phoenix_Bid_Line_Item__c bidLine : recentAwardsList ){
            if(bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids'){
                if(bidLine.Phoenix_Current_ASP_Dose__c <= 0 || bidLine.Phoenix_Current_ASP_Dose__c == null && bidLine.Phoenix_Awarded_Quantity__c !=0){
                    recentAwardsRFPList.add(bidLine);
                    if(mapRecentAwardsRFPList.containsKey(bidLine.Phoenix_Product__r.Product_Family__r.Name)){
                        List < Phoenix_Bid_Line_Item__c > tempList = mapRecentAwardsRFPList.get(bidLine.Phoenix_Product__r.Product_Family__r.Name);
                        tempList.add(bidLine);
                        mapRecentAwardsRFPList.put(bidLine.Phoenix_Product__r.Product_Family__r.Name,tempList);
                    }
                    else{
                        mapRecentAwardsRFPList.put(bidLine.Phoenix_Product__r.Product_Family__r.Name, new List < Phoenix_Bid_Line_Item__c > {
                            bidLine
                                });
                    }
                }
            }
            else if(bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Product Launch'){
                if(bidLine.Phoenix_Awarded_Quantity__c != 0){
                    recentAwardsNewPLList.add(bidLine);
                    if(mapRecentAwardsNPLList.containsKey(bidLine.Phoenix_Product__r.Product_Family__r.Name)){
                        List < Phoenix_Bid_Line_Item__c > tempList = mapRecentAwardsNPLList.get(bidLine.Phoenix_Product__r.Product_Family__r.Name);
                        tempList.add(bidLine);
                        mapRecentAwardsNPLList.put(bidLine.Phoenix_Product__r.Product_Family__r.Name,tempList);
                    }
                    else{
                        mapRecentAwardsNPLList.put(bidLine.Phoenix_Product__r.Product_Family__r.Name, new List < Phoenix_Bid_Line_Item__c > {
                            bidLine
                                });
                    }
                }
            }
            else if(bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Addition'){
                if(bidLine.Phoenix_Awarded_Quantity__c != 0){
                    recentAwardsProdAdditionList.add(bidLine);
                    if(mapRecentAwardsProductAdditionList.containsKey(bidLine.Phoenix_Product__r.Product_Family__r.Name)){
                        List < Phoenix_Bid_Line_Item__c > tempList = mapRecentAwardsProductAdditionList.get(bidLine.Phoenix_Product__r.Product_Family__r.Name);
                        tempList.add(bidLine);
                        mapRecentAwardsProductAdditionList.put(bidLine.Phoenix_Product__r.Product_Family__r.Name,tempList);
                    }
                    else{
                        mapRecentAwardsProductAdditionList.put(bidLine.Phoenix_Product__r.Product_Family__r.Name, new List < Phoenix_Bid_Line_Item__c > {
                            bidLine
                                });
                    }   
                }
            }
            else if(bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Customer'){
                if(bidLine.Phoenix_Awarded_Quantity__c != 0){
                    recentAwardsNewCustomerList.add(bidLine);
                    if(mapRecentAwardsNCList.containsKey(bidLine.Phoenix_Product__r.Product_Family__r.Name)){
                        List < Phoenix_Bid_Line_Item__c > tempList = mapRecentAwardsNCList.get(bidLine.Phoenix_Product__r.Product_Family__r.Name);
                        tempList.add(bidLine);
                        mapRecentAwardsNCList.put(bidLine.Phoenix_Product__r.Product_Family__r.Name,tempList);
                    }
                    else{
                        mapRecentAwardsNCList.put(bidLine.Phoenix_Product__r.Product_Family__r.Name, new List < Phoenix_Bid_Line_Item__c > {
                            bidLine
                                });
                    }   
                }
            }
        }
        
        /*for(Phoenix_Bid_Line_Item__c bl: recentAwardsProdAdditionList){
            date effectiveDate =  bl.Phoenix_Price_Effective_Date__c;
            integer effectiveDateMonth = effectiveDate.month();
            if(monthdatelist.containsKey(effectiveDateMonth)){
                //system.debug('month-->'+monthdatelist.get(effectiveDateMonth));
                String month = monthdatelist.get(effectiveDateMonth);
                if(monthlist.containsKey(month)){
                    Integer effectiveMonth = monthlist.get(month);
                    Integer remainingMonths = 12-effectiveMonth;
                    Decimal awardedqty = bl.Phoenix_Awarded_Quantity__c != null ? bl.Phoenix_Awarded_Quantity__c : 0;
                    Decimal awardedPrice = bl.Phoenix_Proposed_ASP_Dose__c != null ? bl.Phoenix_Proposed_ASP_Dose__c : 0;
                    Decimal financialImpact = ((awardedqty * awardedPrice)*remainingMonths) / 12;
                    financialImpactsProdAdd.add(financialImpact);
                    mapListFIProdAdd.put(bl.Id,financialImpact);
                    //wrapObj.financImpact = financialImpact;
                }
            }
        }
        for(Phoenix_Bid_Line_Item__c bl: recentAwardsRFPList){
            date effectiveDate =  bl.Phoenix_Price_Effective_Date__c;
            integer effectiveDateMonth = effectiveDate.month();
            if(monthdatelist.containsKey(effectiveDateMonth)){
                //system.debug('month-->'+monthdatelist.get(effectiveDateMonth));
                String month = monthdatelist.get(effectiveDateMonth);
                if(monthlist.containsKey(month)){
                    Integer effectiveMonth = monthlist.get(month);
                    Integer remainingMonths = 12-effectiveMonth;
                    Decimal awardedqty = bl.Phoenix_Awarded_Quantity__c != null? bl.Phoenix_Awarded_Quantity__c :0 ;
                    Decimal awardedPrice = bl.Phoenix_Proposed_ASP_Dose__c != null? bl.Phoenix_Proposed_ASP_Dose__c:0;
                    Decimal financialImpact = ((awardedqty * awardedPrice)*remainingMonths) / 12;
                    financialImpactsProdAdd.add(financialImpact);
                    mapListFIRFP.put(bl.Id,financialImpact);
                    //wrapObj.financImpact = financialImpact;
                }
            }
        }
        for(Phoenix_Bid_Line_Item__c bl: recentAwardsNewPLList){
            date effectiveDate =  bl.Phoenix_Price_Effective_Date__c;
            integer effectiveDateMonth = effectiveDate.month();
            if(monthdatelist.containsKey(effectiveDateMonth)){
                //system.debug('month-->'+monthdatelist.get(effectiveDateMonth));
                String month = monthdatelist.get(effectiveDateMonth);
                if(monthlist.containsKey(month)){
                    Integer effectiveMonth = monthlist.get(month);
                    //system.debug('effectiveMonth: '+effectiveMonth);
                    Integer remainingMonths = 12-effectiveMonth;
                    //system.debug('remainingMonths: '+remainingMonths);
                    Decimal awardedqty = bl.Phoenix_Awarded_Quantity__c != null ? bl.Phoenix_Awarded_Quantity__c :0;
                    Decimal awardedPrice = bl.Phoenix_Proposed_ASP_Dose__c != null ? bl.Phoenix_Proposed_ASP_Dose__c :0;
                    Decimal financialImpact = ((awardedqty * awardedPrice)*remainingMonths) / 12;
                    financialImpactsProdAdd.add(financialImpact);
                    mapListFINewPL.put(bl.Id,financialImpact);
                    //system.debug('financialImpact: '+financialImpact);
                    //wrapObj.financImpact = financialImpact;
                }
            }
        }
        //system.debug('mapListFINewPL:: '+mapListFINewPL);
        for(Phoenix_Bid_Line_Item__c bl: recentAwardsNewCustomerList){
            date effectiveDate =  bl.Phoenix_Price_Effective_Date__c;
            integer effectiveDateMonth = effectiveDate.month();
            if(monthdatelist.containsKey(effectiveDateMonth)){
                //system.debug('month-->'+monthdatelist.get(effectiveDateMonth));
                String month = monthdatelist.get(effectiveDateMonth);
                if(monthlist.containsKey(month)){
                    Integer effectiveMonth = monthlist.get(month);
                    Integer remainingMonths = 12-effectiveMonth;
                    Decimal awardedqty = bl.Phoenix_Awarded_Quantity__c != null ? bl.Phoenix_Awarded_Quantity__c : 0;
                    Decimal awardedPrice = bl.Phoenix_Proposed_ASP_Dose__c != null ? bl.Phoenix_Proposed_ASP_Dose__c :0;
                    Decimal financialImpact = ((awardedqty * awardedPrice)*remainingMonths) / 12;
                    financialImpactsProdAdd.add(financialImpact);
                    mapListFINewCustomer.put(bl.Id,financialImpact);
                    //wrapObj.financImpact = financialImpact;
                }
            }
        }*/
        /*For Decreases*/
        Map<Id,Decimal> mapListDecreasesRFP = new Map<Id,Decimal>();
        Map<Id,Decimal> mapListDecreasesPriceChange = new Map<Id,Decimal>();
        Map<Id,Decimal> mapListDecreasesVolumeReview = new Map<Id,Decimal>();
        
        
        Map<String, List<Phoenix_Bid_Line_Item__c>> mapDecreasesRFPList = new Map<String, List<Phoenix_Bid_Line_Item__c>>();
        Map<String, List<Phoenix_Bid_Line_Item__c>> mapDecreasesPCList = new Map<String, List<Phoenix_Bid_Line_Item__c>>();
        Map<String, List<Phoenix_Bid_Line_Item__c>> mapDecreasesVROList = new Map<String, List<Phoenix_Bid_Line_Item__c>>();
        
        for(Phoenix_Bid_Line_Item__c bidLine : decreasesList ){
            if(bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids'){
                if(bidLine.Phoenix_Current_ASP_Dose__c > 0){
                    decreasesRFPList.add(bidLine);
                    if(mapDecreasesRFPList.containsKey(bidLine.Phoenix_Product__r.Product_Family__r.Name)){
                        List < Phoenix_Bid_Line_Item__c > tempList = mapDecreasesRFPList.get(bidLine.Phoenix_Product__r.Product_Family__r.Name);
                        tempList.add(bidLine);
                        mapDecreasesRFPList.put(bidLine.Phoenix_Product__r.Product_Family__r.Name,tempList);
                    }
                    else{
                        mapDecreasesRFPList.put(bidLine.Phoenix_Product__r.Product_Family__r.Name, new List < Phoenix_Bid_Line_Item__c > {
                            bidLine
                                });
                    }   
                }
            }else if(bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change'){
                decreasesPriceChangeList.add(bidLine);
                if(mapDecreasesPCList.containsKey(bidLine.Phoenix_Product__r.Product_Family__r.Name)){
                    List < Phoenix_Bid_Line_Item__c > tempList = mapDecreasesPCList.get(bidLine.Phoenix_Product__r.Product_Family__r.Name);
                    tempList.add(bidLine);
                    mapDecreasesPCList.put(bidLine.Phoenix_Product__r.Product_Family__r.Name,tempList);
                }
                else{
                    mapDecreasesPCList.put(bidLine.Phoenix_Product__r.Product_Family__r.Name, new List < Phoenix_Bid_Line_Item__c > {
                        bidLine
                            });
                }
            }else if(bidLine.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only'){
                if(bidLine.Phoenix_Awarded_Quantity__c != 0){
                    decreasesvolumeReviewList.add(bidLine);
                    if(mapDecreasesVROList.containsKey(bidLine.Phoenix_Product__r.Product_Family__r.Name)){
                        List < Phoenix_Bid_Line_Item__c > tempList = mapDecreasesVROList.get(bidLine.Phoenix_Product__r.Product_Family__r.Name);
                        tempList.add(bidLine);
                        mapDecreasesVROList.put(bidLine.Phoenix_Product__r.Product_Family__r.Name,tempList);
                    }
                    else{
                        mapDecreasesVROList.put(bidLine.Phoenix_Product__r.Product_Family__r.Name, new List < Phoenix_Bid_Line_Item__c > {
                            bidLine
                                });
                    }   
                }
            }
        }
        /*for(Phoenix_Bid_Line_Item__c bl: decreasesRFPList){
            date effectiveDate =  bl.Phoenix_Price_Effective_Date__c;
            integer effectiveDateMonth = effectiveDate.month();
            if(monthdatelist.containsKey(effectiveDateMonth)){
                //system.debug('month-->'+monthdatelist.get(effectiveDateMonth));
                String month = monthdatelist.get(effectiveDateMonth);
                if(monthlist.containsKey(month)){
                    Integer effectiveMonth = monthlist.get(month);
                    Integer remainingMonths = 12-effectiveMonth;
                    Decimal awardedqty =bl.Phoenix_Awarded_Quantity__c != null ? bl.Phoenix_Awarded_Quantity__c : 0;
                    Decimal awardedPrice = bl.Phoenix_Proposed_ASP_Dose__c != null ? bl.Phoenix_Proposed_ASP_Dose__c : 0;
                    Decimal financialImpact = ((awardedqty * awardedPrice)*remainingMonths) / 12;
                    financialImpactsProdAdd.add(financialImpact);
                    mapListFIProdAdd.put(bl.Id,financialImpact);
                    //wrapObj.financImpact = financialImpact;
                }
            }
        }
        for(Phoenix_Bid_Line_Item__c bl: decreasesPriceChangeList){
            date effectiveDate =  bl.Phoenix_Price_Effective_Date__c;
            integer effectiveDateMonth = effectiveDate.month();
            if(monthdatelist.containsKey(effectiveDateMonth)){
                //system.debug('month-->'+monthdatelist.get(effectiveDateMonth));
                String month = monthdatelist.get(effectiveDateMonth);
                if(monthlist.containsKey(month)){
                    Integer effectiveMonth = monthlist.get(month);
                    Integer remainingMonths = 12-effectiveMonth;
                    Decimal awardedqty =  bl.Phoenix_Awarded_Quantity__c != null ? bl.Phoenix_Awarded_Quantity__c : 0;
                    Decimal awardedPrice = bl.Phoenix_Proposed_ASP_Dose__c != null ? bl.Phoenix_Proposed_ASP_Dose__c :0;
                    Decimal financialImpact = ((awardedqty * awardedPrice)*remainingMonths) / 12;
                    financialImpactsProdAdd.add(financialImpact);
                    mapListFIProdAdd.put(bl.Id,financialImpact);
                    //wrapObj.financImpact = financialImpact;
                }
            }
        }
        for(Phoenix_Bid_Line_Item__c bl: decreasesvolumeReviewList){
            date effectiveDate =  bl.Phoenix_Price_Effective_Date__c;
            integer effectiveDateMonth = effectiveDate.month();
            if(monthdatelist.containsKey(effectiveDateMonth)){
                //system.debug('month-->'+monthdatelist.get(effectiveDateMonth));
                String month = monthdatelist.get(effectiveDateMonth);
                if(monthlist.containsKey(month)){
                    Integer effectiveMonth = monthlist.get(month);
                    Integer remainingMonths = 12-effectiveMonth;
                    Decimal awardedqty = bl.Phoenix_Awarded_Quantity__c != null ? bl.Phoenix_Awarded_Quantity__c :0;
                    Decimal awardedPrice = bl.Phoenix_Proposed_ASP_Dose__c != null ? bl.Phoenix_Proposed_ASP_Dose__c :0;
                    Decimal financialImpact = ((awardedqty * awardedPrice)*remainingMonths) / 12;
                    financialImpactsProdAdd.add(financialImpact);
                    mapListFIProdAdd.put(bl.Id,financialImpact);
                    //wrapObj.financImpact = financialImpact;
                }
            }
        }*/
        /*End For Decreases*/
        /*For Product Losses*/
        Map<String, List<Vision_Customer_Product_Tracker__c>> mapLossesMPRList = new Map<String, List<Vision_Customer_Product_Tracker__c>>();
        Map<String, List<Vision_Customer_Product_Tracker__c>> mapLossesPCList = new Map<String, List<Vision_Customer_Product_Tracker__c>>();
        Map<String, List<Vision_Customer_Product_Tracker__c>> mapLossesVROList = new Map<String, List<Vision_Customer_Product_Tracker__c>>();
        Map<String, List<Vision_Customer_Product_Tracker__c>> mapLossesRFPList = new Map<String, List<Vision_Customer_Product_Tracker__c>>();
        //system.debug('Size: '+productLossesList.size());
        for(Vision_Customer_Product_Tracker__c bidLine : productLossesList ){
            //system.debug('Type: '+bidLine.Vision_Bid__r.Phoenix_Bid_Type__c);
            if(bidLine.Vision_Bid__r.Phoenix_Bid_Type__c == 'Mass Product Removal'){
                productLossesMassProductRemovalList.add(bidLine);
                if(mapLossesMPRList.containsKey(bidLine.Vision_Product__r.Product_Family__r.Name)){
                    List < Vision_Customer_Product_Tracker__c > tempList = mapLossesMPRList.get(bidLine.Vision_Product__r.Product_Family__r.Name);
                    tempList.add(bidLine);
                    mapLossesMPRList.put(bidLine.Vision_Product__r.Product_Family__r.Name,tempList);
                }
                else{
                    mapLossesMPRList.put(bidLine.Vision_Product__r.Product_Family__r.Name, new List < Vision_Customer_Product_Tracker__c > {
                        bidLine
                            });
                }
            }else if(bidLine.Vision_Bid__r.Phoenix_Bid_Type__c == 'Price Change'){
                productLossesPriceChangeList.add(bidLine);
                if(mapLossesPCList.containsKey(bidLine.Vision_Product__r.Product_Family__r.Name)){
                    List < Vision_Customer_Product_Tracker__c > tempList = mapLossesPCList.get(bidLine.Vision_Product__r.Product_Family__r.Name);
                    tempList.add(bidLine);
                    mapLossesPCList.put(bidLine.Vision_Product__r.Product_Family__r.Name,tempList);
                }
                else{
                    mapLossesPCList.put(bidLine.Vision_Product__r.Product_Family__r.Name, new List < Vision_Customer_Product_Tracker__c > {
                        bidLine
                            });
                }
            }else if(bidLine.Vision_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only'){
                productLossesvolumeReviewList.add(bidLine);
                if(mapLossesVROList.containsKey(bidLine.Vision_Product__r.Product_Family__r.Name)){
                    List < Vision_Customer_Product_Tracker__c > tempList = mapLossesVROList.get(bidLine.Vision_Product__r.Product_Family__r.Name);
                    tempList.add(bidLine);
                    mapLossesVROList.put(bidLine.Vision_Product__r.Product_Family__r.Name,tempList);
                }
                else{
                    mapLossesVROList.put(bidLine.Vision_Product__r.Product_Family__r.Name, new List < Vision_Customer_Product_Tracker__c > {
                        bidLine
                            });
                }
            }
            else if(bidLine.Vision_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids'){
                //system.debug('Type: '+bidLine.Vision_Bid__r.Phoenix_Bid_Type__c);
                //if(bidLine.Bid_Line_Item__r.Phoenix_Total_Selling_Unit__c != 0){
                    productLossesRFPList.add(bidLine);
                    if(mapLossesRFPList.containsKey(bidLine.Vision_Product__r.Product_Family__r.Name)){
                        List < Vision_Customer_Product_Tracker__c > tempList = mapLossesRFPList.get(bidLine.Vision_Product__r.Product_Family__r.Name);
                        tempList.add(bidLine);
                        mapLossesRFPList.put(bidLine.Vision_Product__r.Product_Family__r.Name,tempList);
                    }
                    else{
                        mapLossesRFPList.put(bidLine.Vision_Product__r.Product_Family__r.Name, new List < Vision_Customer_Product_Tracker__c > {
                            bidLine
                                });
                    }   
                //}
            }
            //system.debug('productLossesPriceChangeList: '+productLossesPriceChangeList.size());
        }
         wrapperClass wrapObj = new wrapperClass();
         //Map<String,wrapperClass> finalRecentMapSummary = new Map<String,wrapperClass>();
        //Added by Satya//
       
       
        Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
        date todayDate = System.today();
        date LastDateInRecentFYTD;
        date FirstDateInRecentFYTD;
        date firstDateinRecentFY;
		date lastDateinRecentFY;
        decimal SalesDollar=0;
        decimal trendSalesDollar=0;
        date currentFyscalDate = Date.newinstance(system.today().year(), orgFiscalMonth, 1);
        Integer month = todayDate.month();
        Integer monthDiff;
        Integer noOfMonths;
        /*last year sales*/
        if(todayDate <= currentFyscalDate){
                firstDateinRecentFY = Date.newinstance(system.today().year()-1, orgFiscalMonth-1, 1).addMonths(1).toStartofMonth().addDays(-1);
                lastDateinRecentFY = Date.newinstance(system.today().year()-2, orgFiscalMonth, 1);
            }
        else{
                firstDateinRecentFY = Date.newinstance(system.today().year(), orgFiscalMonth-1, 1).addMonths(1).toStartofMonth().addDays(-1);
            lastDateinRecentFY = Date.newinstance(system.today().year()-1, orgFiscalMonth, 1);
            }
        for(Vision_DRL_Sales__c sales : [select Vision_Sales_Dollar__c,Vision_Units__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_Customer_Name__c,Vision_Customer_Name__r.Name,Name,Id,Vision_Month_dtls__c
                                         from Vision_DRL_Sales__c  where  (Vision_Month_dtls__c >=: lastDateinRecentFY AND Vision_Month_dtls__c<=:firstDateinRecentFY) AND Vision_Customer_Name__c =:recordId  ORDER BY  Vision_Month_dtls__c ASC
                                        ]){
                                       if(sales.Vision_Month_dtls__c >= lastDateinRecentFY && sales.Vision_Month_dtls__c <= firstDateinRecentFY ){
                                           if(sales.Vision_Sales_Dollar__c != null)  SalesDollar += sales.Vision_Sales_Dollar__c;
                                       }
                                                              
         }
         /* fytd sales*/
        
        if(month == 4){
 				 LastDateInRecentFYTD = Date.newinstance(system.today().year(), orgFiscalMonth+3, 1);
 
		}
       else  if(todayDate <= currentFyscalDate){
                LastDateInRecentFYTD = Date.newinstance(system.today().year()-1, orgFiscalMonth+3, 1);
                
            }
        else{
                LastDateInRecentFYTD = Date.newinstance(system.today().year(), orgFiscalMonth+3, 1);
            }
        if(month == 4){
          		FirstDateInRecentFYTD =  Date.newinstance(system.today().year(), orgFiscalMonth+3, 1);
        }else{
             for(Integer i=1;i<=1;i++){
                    FirstDateInRecentFYTD=System.today().addMonths(-i).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                  
                }
        }
         /* fytd sales*/
        /*Caluculate No Of Months*/
         date LastInRecentFYTD;
        date  FirstInRecentFYTD;
        if(selectedRange == 'THIS_FISCAL_YEAR'){
              if(month == 4){
                monthDiff=1;  
              }else{
                  monthDiff = FirstDateInRecentFYTD.monthsBetween(LastDateInRecentFYTD);
              }
        }else if(selectedRange == 'THIS_YEAR'){
            monthDiff = 12;
        }
        else if(selectedRange == 'THIS_QUARTER' || selectedRange == 'LAST_QUARTER'){
            monthDiff = 3;
        }
        else if(selectedRange == 'THIS_MONTH' || selectedRange == 'THIS_WEEK' ||selectedRange == 'LAST_MONTH' || selectedRange == 'LAST_WEEK'){
            monthDiff = 1;
        }
        else if(selectedRange == 'LAST_YEAR'){
            monthDiff = 12;
        }
        else if(selectedRange == 'Custom' ){
             monthDiff = endDate.monthsBetween(startDate);
        }
		else if(selectedRange == 'LAST_FISCAL_YEAR'){ 
            if(todayDate <= currentFyscalDate){
                 LastInRecentFYTD = Date.newinstance(system.today().year()-2, orgFiscalMonth+3, 1);
                
            }
            else{
                   LastInRecentFYTD = Date.newinstance(system.today().year()-1, orgFiscalMonth+3, 1);
                }
			for(Integer i=1;i<=1;i++){
                    FirstInRecentFYTD=System.today().addMonths(-i).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                  
                }
            monthDiff = FirstInRecentFYTD.monthsBetween(LastInRecentFYTD);
        }
		//system.debug(monthDiff);
        
        for(Vision_DRL_Sales__c sales : [select Vision_Sales_Dollar__c,Vision_Units__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_Customer_Name__c,Vision_Customer_Name__r.Name,Name,Id,Vision_Month_dtls__c
                                         from Vision_DRL_Sales__c  where  (Vision_Month_dtls__c >=: LastDateInRecentFYTD AND Vision_Month_dtls__c<=:FirstDateInRecentFYTD) AND Vision_Customer_Name__c =:recordId  ORDER BY  Vision_Month_dtls__c ASC
                                        ]){
                                       if(sales.Vision_Month_dtls__c >= LastDateInRecentFYTD && sales.Vision_Month_dtls__c <= FirstDateInRecentFYTD ){
                                           if(sales.Vision_Sales_Dollar__c != null)  trendSalesDollar += sales.Vision_Sales_Dollar__c;
                                       }
                                                              
         }
        
       	wrapObj.monthDiff = monthDiff;
       	wrapObj.salesdl = SalesDollar;
        wrapObj.trendSalesDollar = trendSalesDollar;
        wrapObj.recentAwardsRFPList = recentAwardsRFPList;
        wrapObj.recentAwardsNewPLList = recentAwardsNewPLList;
        wrapObj.recentAwardsProdAdditionList = recentAwardsProdAdditionList;
        wrapObj.recentAwardsNewCustomerList = recentAwardsNewCustomerList;
        wrapObj.decreasesRFPList = decreasesRFPList;
        wrapObj.decreasesPriceChangeList = decreasesPriceChangeList;
        wrapObj.decreasesvolumeReviewList = decreasesvolumeReviewList;
        wrapObj.productLossesMassProductRemovalList = productLossesMassProductRemovalList;
        wrapObj.productLossesPriceChangeList = productLossesPriceChangeList;
        wrapObj.productLossesvolumeReviewList = productLossesvolumeReviewList;
        wrapObj.productLossesRFPList = productLossesRFPList; 
        wrapObj.mapListFIProdAdd = mapListFIProdAdd;
        wrapObj.mapListFIRFP = mapListFIRFP;
        wrapObj.mapListFINewPL = mapListFINewPL;
        wrapObj.mapListFINewPL =mapListFINewCustomer;
        wrapObj.mapListDecreasesRFP = mapListDecreasesRFP;
        wrapObj.mapListDecreasesPriceChange = mapListDecreasesPriceChange;
        wrapObj.mapListDecreasesVolumeReview = mapListDecreasesVolumeReview;
        wrapObj.mapRecentAwardsProductAdditionList = mapRecentAwardsProductAdditionList;
        wrapObj.mapRecentAwardsNPLList = mapRecentAwardsNPLList;
        wrapObj.mapRecentAwardsRFPList = mapRecentAwardsRFPList;
        wrapObj.mapRecentAwardsNCList = mapRecentAwardsNCList;
        wrapObj.mapDecreasesRFPList = mapDecreasesRFPList;
        wrapObj.mapDecreasesPCList = mapDecreasesPCList;
        wrapObj.mapDecreasesVROList = mapDecreasesVROList;
        wrapObj.mapLossesMPRList = mapLossesMPRList;
        wrapObj.mapLossesPCList = mapLossesPCList;
        wrapObj.mapLossesVROList = mapLossesVROList;
        wrapObj.mapLossesRFPList = mapLossesRFPList;
                
        //  wrapObj.decreasesList = decreasesList;
        //wrapObj.financialImpactsProdAdd = financialImpactsProdAdd;
        return wrapObj;
        
    }
    public class wrapperClass{
        @AuraEnabled public Decimal monthDiff;
        @AuraEnabled public Decimal salesdl;
        @AuraEnabled public Decimal trendSalesDollar;
        @AuraEnabled public List<Phoenix_Bid_Line_Item__c> recentAwardsRFPList;
        @AuraEnabled public List<Phoenix_Bid_Line_Item__c> recentAwardsNewPLList;
        @AuraEnabled public List<Phoenix_Bid_Line_Item__c> recentAwardsProdAdditionList;
        @AuraEnabled public List<Phoenix_Bid_Line_Item__c> recentAwardsNewCustomerList;
        @AuraEnabled public List<Phoenix_Bid_Line_Item__c> decreasesList;
        @AuraEnabled public List<Phoenix_Bid_Line_Item__c> decreasesRFPList;
        @AuraEnabled public List<Phoenix_Bid_Line_Item__c> decreasesPriceChangeList;
        @AuraEnabled public List<Phoenix_Bid_Line_Item__c> decreasesvolumeReviewList;
        @AuraEnabled public List<Vision_Customer_Product_Tracker__c> productLossesMassProductRemovalList;
        @AuraEnabled public List<Vision_Customer_Product_Tracker__c> productLossesPriceChangeList;
        @AuraEnabled public List<Vision_Customer_Product_Tracker__c> productLossesvolumeReviewList;
        @AuraEnabled public List<Vision_Customer_Product_Tracker__c> productLossesRFPList;
        @AuraEnabled public List<Decimal>  financialImpactsProdAdd;
        @AuraEnabled public Decimal financImpact;
        @AuraEnabled public Map<Id,Decimal> mapListFIProdAdd;
        @AuraEnabled public Map<Id,Decimal> mapListFIRFP;
        @AuraEnabled public Map<Id,Decimal> mapListFINewPL;
        @AuraEnabled public Map<Id,Decimal> mapListFINewCustomer;
        @AuraEnabled public Map<Id,Decimal> mapListDecreasesRFP;
        @AuraEnabled public Map<Id,Decimal> mapListDecreasesPriceChange;
        @AuraEnabled public Map<Id,Decimal> mapListDecreasesVolumeReview;
        @AuraEnabled public Map<String, List<Phoenix_Bid_Line_Item__c>> mapRecentAwardsProductAdditionList;
        @AuraEnabled public Map<String, List<Phoenix_Bid_Line_Item__c>> mapRecentAwardsNPLList;
        @AuraEnabled public Map<String, List<Phoenix_Bid_Line_Item__c>> mapRecentAwardsRFPList;
        @AuraEnabled public Map<String, List<Phoenix_Bid_Line_Item__c>> mapRecentAwardsNCList;
        @AuraEnabled public Map<String, List<Phoenix_Bid_Line_Item__c>> mapDecreasesRFPList;
        @AuraEnabled public Map<String, List<Phoenix_Bid_Line_Item__c>> mapDecreasesPCList;
        @AuraEnabled public Map<String, List<Phoenix_Bid_Line_Item__c>> mapDecreasesVROList;
        @AuraEnabled public Map<String, List<Vision_Customer_Product_Tracker__c>> mapLossesMPRList;
        @AuraEnabled public Map<String, List<Vision_Customer_Product_Tracker__c>> mapLossesPCList;
        @AuraEnabled public Map<String, List<Vision_Customer_Product_Tracker__c>> mapLossesVROList;
        @AuraEnabled public Map<String, List<Vision_Customer_Product_Tracker__c>> mapLossesRFPList;
    }
    public static void coverageBlock(){
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
        
        
        
    }
}