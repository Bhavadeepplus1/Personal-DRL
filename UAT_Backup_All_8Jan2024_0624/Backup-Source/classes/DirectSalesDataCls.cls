public class DirectSalesDataCls {
    
    @AuraEnabled(Cacheable=true)
    public static list<string> getCustomerNames(string salesRepName){
        set<string> custNames = new set<string>();
        
        String searchUserKey = '%'+salesRepName+'%';
        List<Date> currentFYList= new List<Date>();
        date fyDate;date fyStartDate;date fyEndDate;
      /*  Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
        for(integer i=3;i<=14;i++){
            date currentFyscalDate = Date.newinstance(system.today().year()-1, orgFiscalMonth+i, 1);
            currentFYList.add(currentFyscalDate);
            System.debug('currentFyscalDate==>'+currentFyscalDate);
        }
        
        fyStartDate = currentFYList[0];
        fyEndDate = currentFYList[11].addMonths(1).toStartofMonth().addDays(-1);*/
        List<FiscalYearSettings>  datelist =[ Select Name,StartDate,EndDate FROM FiscalYearSettings ];
        date startDate;date endDate;
        for(FiscalYearSettings rec: datelist){
            if(System.today() >= rec.StartDate && System.today() <= rec.EndDate){
                startDate  = rec.StartDate.toStartofMonth();
                endDate  = rec.EndDate.toStartofMonth();
                break;
            }
        }
        Date tempendDate = startDate;
        while(tempendDate <= endDate ){
            currentFYList.add(tempendDate);
            tempendDate = tempendDate.addMonths(1);
        }
        fyStartDate = currentFYList[0];
        fyEndDate = currentFYList[11].addMonths(1).toStartofMonth().addDays(-1);
        list<AggregateResult > directDate = [select Customer_Name__c ,count(ID) from  SRx_DirectSales_SummaryTable__c where Sales_Rep_Name__c like:searchUserKey AND Billing_Date__c >=: fyStartDate and Billing_Date__c <=:fyEndDate Group by Customer_Name__c  ];
        
        for(AggregateResult  ss:directDate){
           custNames.add((String)ss.get('Customer_Name__c'));
       }
       
        List<String> custNameslist = new List<String>(custNames);
        return custNameslist;
    }
    
    @AuraEnabled
 	public static list<string> getProductNames(string salesRepName){
        set<string> prodNames = new set<string>();
        
        String searchUserKey = '%'+salesRepName+'%';
        List<Date> currentFYList= new List<Date>();
        date fyDate;date fyStartDate;date fyEndDate;
      
       /* Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
        for(integer i=3;i<=14;i++){
            date currentFyscalDate = Date.newinstance(system.today().year()-1, orgFiscalMonth+i, 1);
            currentFYList.add(currentFyscalDate);
            System.debug('currentFyscalDate==>'+currentFyscalDate);
        }
        fyStartDate = currentFYList[0];
        fyEndDate = currentFYList[11].addMonths(1).toStartofMonth().addDays(-1);*/
        List<FiscalYearSettings>  datelist =[ Select Name,StartDate,EndDate FROM FiscalYearSettings ];
        date startDate;date endDate;
        for(FiscalYearSettings rec: datelist){
            if(System.today() >= rec.StartDate && System.today() <= rec.EndDate){
                startDate  = rec.StartDate.toStartofMonth();
                endDate  = rec.EndDate.toStartofMonth();
                break;
            }
        }
        Date tempendDate = startDate;
        while(tempendDate <= endDate ){
            currentFYList.add(tempendDate);
            tempendDate = tempendDate.addMonths(1);
        }
        fyStartDate = currentFYList[0];
        fyEndDate = currentFYList[11].addMonths(1).toStartofMonth().addDays(-1);
        list<AggregateResult > directDate = [select Product__c ,count(ID) from  SRx_DirectSales_SummaryTable__c where Sales_Rep_Name__c like:searchUserKey AND Billing_Date__c >=: fyStartDate and Billing_Date__c <=:fyEndDate Group by Product__c  ];
        
        for(AggregateResult  ss:directDate){
           prodNames.add((String)ss.get('Product__c'));
       }
       
        List<String> prodNameslist = new List<String>(prodNames);
        return prodNameslist;
    }    
    @AuraEnabled
    Public static List<wrapperClass> getDirectSalesList(String salesRepName,List<String> customer_Name,List<String> product_List){
        List<wrapperClass> wrapperObj = new List<wrapperClass>();
        Map<String, List<SRx_DirectSales_SummaryTable__c>> maplist = new Map<String, List<SRx_DirectSales_SummaryTable__c>>();
        //List<SRx_DirectSales_SummaryTable__c> directSales = new List<SRx_DirectSales_SummaryTable__c>();
        List<Date> currentFYList= new List<Date>();
        date fyDate;date fyStartDate;date fyEndDate;
    /*   Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
      
       for(integer i=3;i<=14;i++){
            date currentFyscalDate = Date.newinstance(system.today().year()-1, orgFiscalMonth+i, 1);
            currentFYList.add(currentFyscalDate);
            System.debug('currentFyscalDate==>'+currentFyscalDate);
        }
        
        fyStartDate = currentFYList[0];
        fyEndDate = currentFYList[11].addMonths(1).toStartofMonth().addDays(-1);*/
        List<FiscalYearSettings>  datelist =[ Select Name,StartDate,EndDate FROM FiscalYearSettings ];
        date startDate;date endDate;
        for(FiscalYearSettings rec: datelist){
            if(System.today() >= rec.StartDate && System.today() <= rec.EndDate){
                startDate  = rec.StartDate.toStartofMonth();
                endDate  = rec.EndDate.toStartofMonth();
                break;
            }
        }
        Date tempendDate = startDate;
        while(tempendDate <= endDate ){
            currentFYList.add(tempendDate);
            tempendDate = tempendDate.addMonths(1);
        }
        fyStartDate = currentFYList[0];
        fyEndDate = currentFYList[11].addMonths(1).toStartofMonth().addDays(-1);
        /*for current 12 months keys*/
        //List<String> currenttwelveMonthKeys = new List<String>();
        Map<String,String> currenttwelveMonthKeys = new Map<String,String>();
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
        integer month;
        integer Year;
        String yearinTwodg;
        date FirstDateInRecent;
        String monthname;
        String month_year;
        List<Date> reversecurrentFYList = new List<Date>();
      /*  for(Integer i=12;i>=1;i--){
            date fiscDate=System.today().addMonths(-i+5).toStartOfMonth();
          
            reversecurrentFYList.add(fiscDate); 
        }*/
      /*  for(integer i=3;i<=14;i++){
            date currentFyscalDate = Date.newinstance(system.today().year()-1, orgFiscalMonth+i, 1);
            reversecurrentFYList.add(currentFyscalDate);
            System.debug('currentFyscalDate==>'+currentFyscalDate); 
        }*/
        for(Integer i=0; i <currentFYList.size();i++){
            month = currentFYList[i].Month();
            year = currentFYList[i].Year();
            yearinTwodg = String.valueOf(year).right(2);
            monthname = monthdatelist.get(month);
            month_year = monthname+'-'+yearinTwodg;
           
            currenttwelveMonthKeys.put('month_'+(i+1),month_year);
            
        }
        wrapperClass wrpObj = new wrapperClass();
        wrpObj.currenttwelveMonthKeys = currenttwelveMonthKeys;
       
        /*End for current 12 months keys*/
        //String sales_rep = salesRepName;
        //AND Region__c =: 'West' AND soldToRebatePercent__c !=:'166462' AND soldToRebatePercent__c !=:'15578'
        System.debug('salesRepName==>'+salesRepName);
         System.debug('fyStartDate==>'+fyStartDate);
        System.debug('fyEndDate==>'+fyEndDate);
//directSales = [select id,Sales_Rep_Name__c,Customer_Name__c,Product_Family__c,Product__c,Sales__c,	Units__c,Billing_Date__c,Region__c from SRx_DirectSales_SummaryTable__c where 	Billing_Date__c >=: fyStartDate AND  Billing_Date__c <=: fyEndDate AND Sales_Rep_Name__c=:salesRepName  ORDER BY  Billing_Date__c ASC];
       
        String query = '';
        query = 'select id,Sales_Rep_Name__c,Customer_Name__c,Product_Family__c,Product__c,Sales__c,	Units__c,Billing_Date__c,Region__c from SRx_DirectSales_SummaryTable__c where 	Billing_Date__c >=: fyStartDate AND  Billing_Date__c <=: fyEndDate AND Sales_Rep_Name__c=:salesRepName ' ;
		if(customer_Name.size()>0){
           
           query += ' AND Customer_Name__c IN: customer_Name ';   
         }
        if(product_List.size() > 0){
            query += ' AND Product__c IN: product_List ';   
        }
        
        list < SRx_DirectSales_SummaryTable__c > directSales = Database.query(query);
        for(SRx_DirectSales_SummaryTable__c sales : directSales){ 
            string mapKey = sales.Customer_Name__c;
            if(maplist.containsKey(mapKey)){
                List < SRx_DirectSales_SummaryTable__c > tempList = maplist.get(mapKey);
                tempList.add(sales);
                maplist.put(mapKey,tempList);
            }else if(!maplist.containsKey(mapKey)){
                maplist.put(mapKey, new List < SRx_DirectSales_SummaryTable__c > {
                    sales
                        });
            }
        }
        /*get months*/
        System.debug('maplist==>'+maplist.size());
        date month1_FirstDate;date month1_EndDate;
        month1_FirstDate = currentFYList[0];
        month1_EndDate = currentFYList[0].addMonths(1).toStartofMonth().addDays(-1);
        date month2_FirstDate;date month2_EndDate;
        month2_FirstDate = currentFYList[1];
        month2_EndDate = currentFYList[1].addMonths(1).toStartofMonth().addDays(-1);
        date month3_FirstDate;date month3_EndDate;
        month3_FirstDate = currentFYList[2];
        month3_EndDate = currentFYList[2].addMonths(1).toStartofMonth().addDays(-1);
        date month4_FirstDate;date month4_EndDate;
        month4_FirstDate = currentFYList[3];
        month4_EndDate = currentFYList[3].addMonths(1).toStartofMonth().addDays(-1);
        date month5_FirstDate;date month5_EndDate;
        month5_FirstDate = currentFYList[4];
        month5_EndDate = currentFYList[4].addMonths(1).toStartofMonth().addDays(-1);
        date month6_FirstDate;date month6_EndDate;
        month6_FirstDate = currentFYList[5];
        month6_EndDate = currentFYList[5].addMonths(1).toStartofMonth().addDays(-1);
        date month7_FirstDate;date month7_EndDate;
        month7_FirstDate = currentFYList[6];
        month7_EndDate = currentFYList[6].addMonths(1).toStartofMonth().addDays(-1);
        date month8_FirstDate;date month8_EndDate;
        month8_FirstDate = currentFYList[7];
        month8_EndDate = currentFYList[7].addMonths(1).toStartofMonth().addDays(-1);
        date month9_FirstDate;date month9_EndDate;
        month9_FirstDate = currentFYList[8];
        month9_EndDate = currentFYList[8].addMonths(1).toStartofMonth().addDays(-1);
        date month10_FirstDate;date month10_EndDate;
        month10_FirstDate = currentFYList[9];
        month10_EndDate = currentFYList[9].addMonths(1).toStartofMonth().addDays(-1);
        date month11_FirstDate;date month11_EndDate;
        month11_FirstDate = currentFYList[10];
        month11_EndDate = currentFYList[10].addMonths(1).toStartofMonth().addDays(-1);
        date month12_FirstDate;date month12_EndDate;
        month12_FirstDate = currentFYList[11];
        month12_EndDate = currentFYList[11].addMonths(1).toStartofMonth().addDays(-1);
         
        for(String customer : maplist.KeySet()){
            Decimal month1_Direct_Sales = 0;   Decimal month2_Direct_Sales = 0;    Decimal month3_Direct_Sales = 0;
            Decimal month4_Direct_Sales = 0;   Decimal month5_Direct_Sales = 0;   Decimal month6_Direct_Sales = 0;
            Decimal month7_Direct_Sales = 0;   Decimal month8_Direct_Sales = 0;   Decimal month9_Direct_Sales = 0;
            Decimal month10_Direct_Sales = 0;   Decimal month11_Direct_Sales = 0;   Decimal month12_Direct_Sales = 0;
            Decimal month1_Units = 0;Decimal month2_Units = 0;Decimal month3_Units = 0;Decimal month4_Units = 0;
            Decimal month5_Units = 0;Decimal month6_Units = 0;Decimal month7_Units = 0;Decimal month8_Units = 0;
            Decimal month9_Units = 0;Decimal month10_Units = 0;Decimal month11_Units = 0;Decimal month12_Units = 0;
            String customerName;
            for (SRx_DirectSales_SummaryTable__c sales: maplist.get(customer)) {
                System.debug('maplist innner loop==>'+maplist.size());
                if(sales.Billing_Date__c >= month1_FirstDate && sales.Billing_Date__c <= month1_EndDate ){
                    if(sales.Sales__c != null)  month1_Direct_Sales += sales.Sales__c;
                   
                    if(sales.Units__c != null)  month1_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month2_FirstDate && sales.Billing_Date__c <= month2_EndDate ){
                    if(sales.Sales__c != null)  month2_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month2_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month3_FirstDate && sales.Billing_Date__c <= month3_EndDate ){
                    if(sales.Sales__c != null)  month3_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month3_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month4_FirstDate && sales.Billing_Date__c <= month4_EndDate ){
                    if(sales.Sales__c != null)  month4_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month4_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month5_FirstDate && sales.Billing_Date__c <= month5_EndDate ){
                    if(sales.Sales__c != null)  month5_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month5_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month6_FirstDate && sales.Billing_Date__c <= month6_EndDate ){
                    if(sales.Sales__c != null)  month6_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month6_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month7_FirstDate && sales.Billing_Date__c <= month7_EndDate ){
                    if(sales.Sales__c != null)  month7_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month7_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month8_FirstDate && sales.Billing_Date__c <= month8_EndDate ){
                    if(sales.Sales__c != null)  month8_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month8_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month9_FirstDate && sales.Billing_Date__c <= month9_EndDate ){
                    if(sales.Sales__c != null)  month9_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month9_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month10_FirstDate && sales.Billing_Date__c <= month10_EndDate ){
                    if(sales.Sales__c != null)  month10_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month10_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month11_FirstDate && sales.Billing_Date__c <= month11_EndDate ){
                    if(sales.Sales__c != null)  month11_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month11_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month12_FirstDate && sales.Billing_Date__c <= month12_EndDate ){
                    if(sales.Sales__c != null)  month12_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month12_Units += sales.Units__c;
                }
               
                customerName = sales.Customer_Name__c;
            }
           
           wrapperClass obj = new wrapperClass();
            obj.customerName = customerName;
            obj.month1_Direct_Sales = String.valueOf(month1_Direct_Sales.format());
            obj.month2_Direct_Sales = String.valueOf(month2_Direct_Sales.format());
            obj.month3_Direct_Sales = String.valueOf(month3_Direct_Sales.format());
            obj.month4_Direct_Sales = String.valueOf(month4_Direct_Sales.format());
            obj.month5_Direct_Sales = String.valueOf(month5_Direct_Sales.format());
            obj.month6_Direct_Sales = String.valueOf(month6_Direct_Sales.format());
            obj.month7_Direct_Sales = String.valueOf(month7_Direct_Sales.format());
            obj.month8_Direct_Sales = String.valueOf(month8_Direct_Sales.format());
            obj.month9_Direct_Sales = String.valueOf(month9_Direct_Sales.format());
            obj.month10_Direct_Sales = String.valueOf(month10_Direct_Sales.format());
            obj.month11_Direct_Sales = String.valueOf(month11_Direct_Sales.format());
            obj.month12_Direct_Sales = String.valueOf(month12_Direct_Sales.format());
            obj.month1_Units = String.valueOf(month1_Units.format());
            obj.month2_Units = String.valueOf(month2_Units.format());
            obj.month3_Units = String.valueOf(month3_Units.format());
            obj.month4_Units = String.valueOf(month4_Units.format());
            obj.month5_Units = String.valueOf(month5_Units.format());
            obj.month6_Units = String.valueOf(month6_Units.format());
            obj.month7_Units = String.valueOf(month7_Units.format());
            obj.month8_Units = String.valueOf(month8_Units.format());
            obj.month9_Units = String.valueOf(month9_Units.format());
            obj.month10_Units = String.valueOf(month10_Units.format());
            obj.month11_Units = String.valueOf(month11_Units.format());
            obj.month12_Units = String.valueOf(month12_Units.format());
            wrapperObj.add(obj);
            
        }
        Decimal  month1_SalesSummary  = 0;Decimal month2_SalesSummary = 0;Decimal month3_SalesSummary = 0;
        Decimal month4_SalesSummary = 0;Decimal month5_SalesSummary = 0;Decimal month6_SalesSummary = 0;Decimal month7_SalesSummary = 0;
        Decimal month8_SalesSummary = 0;Decimal month9_SalesSummary = 0;Decimal month10_SalesSummary = 0;Decimal month11_SalesSummary = 0;
        Decimal month12_SalesSummary = 0;
        Decimal  month1_UnitsSummary  = 0;Decimal month2_UnitsSummary = 0;Decimal month3_UnitsSummary = 0;
        Decimal month4_UnitsSummary = 0;Decimal month5_UnitsSummary = 0;Decimal month6_UnitsSummary = 0;Decimal month7_UnitsSummary = 0;
        Decimal month8_UnitsSummary = 0;Decimal month9_UnitsSummary = 0;Decimal month10_UnitsSummary = 0;Decimal month11_UnitsSummary = 0;
        Decimal month12_UnitsSummary = 0;
        for (SRx_DirectSales_SummaryTable__c sales:directSales){
                if(sales.Billing_Date__c >= month1_FirstDate && sales.Billing_Date__c <= month1_EndDate ){
                    if(sales.Sales__c != null ) month1_SalesSummary +=sales.Sales__c;
                     if(sales.Units__c != null)  month1_UnitsSummary += sales.Units__c;
                }
               if(sales.Billing_Date__c >= month2_FirstDate && sales.Billing_Date__c <= month2_EndDate ){
                    if(sales.Sales__c != null ) month2_SalesSummary +=sales.Sales__c;
                    if(sales.Units__c != null)  month2_UnitsSummary += sales.Units__c;
               }
               if(sales.Billing_Date__c >= month3_FirstDate && sales.Billing_Date__c <= month3_EndDate ){
                   if(sales.Sales__c != null ) month3_SalesSummary +=sales.Sales__c;
                   if(sales.Units__c != null)  month3_UnitsSummary += sales.Units__c;
               }
               if(sales.Billing_Date__c >= month4_FirstDate && sales.Billing_Date__c <= month4_EndDate ){
                    if(sales.Sales__c != null ) month4_SalesSummary +=sales.Sales__c;
                    if(sales.Units__c != null)  month4_UnitsSummary += sales.Units__c;
               }
               if(sales.Billing_Date__c >= month5_FirstDate && sales.Billing_Date__c <= month5_EndDate ){
                    if(sales.Sales__c != null ) month5_SalesSummary +=sales.Sales__c;
                    if(sales.Units__c != null)  month5_UnitsSummary += sales.Units__c;
               }
               if(sales.Billing_Date__c >= month6_FirstDate && sales.Billing_Date__c <= month6_EndDate ){
                    if(sales.Sales__c != null ) month6_SalesSummary +=sales.Sales__c;
                    if(sales.Units__c != null)  month6_UnitsSummary += sales.Units__c;
               }
               if(sales.Billing_Date__c >= month7_FirstDate && sales.Billing_Date__c <= month7_EndDate ){
                    if(sales.Sales__c != null ) month7_SalesSummary +=sales.Sales__c;
                    if(sales.Units__c != null)  month7_UnitsSummary += sales.Units__c;
               }
               if(sales.Billing_Date__c >= month8_FirstDate && sales.Billing_Date__c <= month8_EndDate ){
                    if(sales.Sales__c != null ) month8_SalesSummary +=sales.Sales__c;
                    if(sales.Units__c != null)  month8_UnitsSummary += sales.Units__c;
               }
               if(sales.Billing_Date__c >= month9_FirstDate && sales.Billing_Date__c <= month9_EndDate ){
                    if(sales.Sales__c != null ) month9_SalesSummary +=sales.Sales__c;
                    if(sales.Units__c != null)  month9_UnitsSummary += sales.Units__c;
               }
               if(sales.Billing_Date__c >= month10_FirstDate && sales.Billing_Date__c <= month10_EndDate ){
                    if(sales.Sales__c != null ) month10_SalesSummary +=sales.Sales__c;
                    if(sales.Units__c != null)  month10_UnitsSummary += sales.Units__c;
               }
               if(sales.Billing_Date__c >= month11_FirstDate && sales.Billing_Date__c <= month11_EndDate ){
                    if(sales.Sales__c != null ) month11_SalesSummary +=sales.Sales__c;
                    if(sales.Units__c != null)  month11_UnitsSummary += sales.Units__c;
               }
               if(sales.Billing_Date__c >= month12_FirstDate && sales.Billing_Date__c <= month12_EndDate ){
                    if(sales.Sales__c != null ) month12_SalesSummary +=sales.Sales__c;
                    if(sales.Units__c != null)  month12_UnitsSummary += sales.Units__c;
               }
            }
        wrapperClass obj1 = new wrapperClass();
        obj1.month1_SalesSummary = String.valueOf(month1_SalesSummary.format());
        obj1.month2_SalesSummary = String.valueOf(month2_SalesSummary.format());
        obj1.month3_SalesSummary = String.valueOf(month3_SalesSummary.format());
        obj1.month4_SalesSummary = String.valueOf(month4_SalesSummary.format());
        obj1.month5_SalesSummary = String.valueOf(month5_SalesSummary.format());
        obj1.month6_SalesSummary = String.valueOf(month6_SalesSummary.format());
        obj1.month7_SalesSummary = String.valueOf(month7_SalesSummary.format());
        obj1.month8_SalesSummary= String.valueOf(month8_SalesSummary.format());
        obj1.month9_SalesSummary = String.valueOf(month9_SalesSummary.format());
        obj1.month10_SalesSummary = String.valueOf(month10_SalesSummary.format());
        obj1.month11_SalesSummary = String.valueOf(month11_SalesSummary.format());
        obj1.month12_SalesSummary = String.valueOf(month12_SalesSummary.format());
        obj1.month1_UnitsSummary = String.valueOf(month1_UnitsSummary.format());
        obj1.month2_UnitsSummary = String.valueOf(month2_UnitsSummary.format());
        obj1.month3_UnitsSummary = String.valueOf(month3_UnitsSummary.format());
        obj1.month4_UnitsSummary = String.valueOf(month4_UnitsSummary.format());
        obj1.month5_UnitsSummary = String.valueOf(month5_UnitsSummary.format());
        obj1.month6_UnitsSummary = String.valueOf(month6_UnitsSummary.format());
        obj1.month7_UnitsSummary = String.valueOf(month7_UnitsSummary.format());
        obj1.month8_UnitsSummary = String.valueOf(month8_UnitsSummary.format());
        obj1.month9_UnitsSummary = String.valueOf(month9_UnitsSummary.format());
        obj1.month10_UnitsSummary = String.valueOf(month10_UnitsSummary.format());
        obj1.month11_UnitsSummary = String.valueOf(month11_UnitsSummary.format());
        obj1.month12_UnitsSummary = String.valueOf(month12_UnitsSummary.format());
    	 wrapperObj.add(obj1);
        System.debug('wrapperObj==>'+wrapperObj);
         wrapperObj.add(wrpObj);
        return wrapperObj;
    }
    
    
   	@AuraEnabled
    Public static List<wrapperClass> CustomerSpecific_getDirectSalesList(String custName,String sales_rep,List<String> customerFromFilter,List<String> productFromFilter){
        List<wrapperClass> wrapperObj = new List<wrapperClass>();
        Map<String, List<SRx_DirectSales_SummaryTable__c>> maplist = new Map<String, List<SRx_DirectSales_SummaryTable__c>>();
        List<SRx_DirectSales_SummaryTable__c> directSales = new List<SRx_DirectSales_SummaryTable__c>();
        Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
        List<Date> currentFYList= new List<Date>();
        date fyDate;date fyStartDate;date fyEndDate;
       
     /*   for(integer i=3;i<=14;i++){
            date currentFyscalDate = Date.newinstance(system.today().year()-1, orgFiscalMonth+i, 1);
            currentFYList.add(currentFyscalDate);
        }
        
        fyStartDate = currentFYList[0];
        fyEndDate = currentFYList[11].addMonths(1).toStartofMonth().addDays(-1);*/
        List<FiscalYearSettings>  datelist =[ Select Name,StartDate,EndDate FROM FiscalYearSettings ];
        date startDate;date endDate;
        for(FiscalYearSettings rec: datelist){
            if(System.today() >= rec.StartDate && System.today() <= rec.EndDate){
                startDate  = rec.StartDate.toStartofMonth();
                endDate  = rec.EndDate.toStartofMonth();
                break;
            }
        }
        Date tempendDate = startDate;
        while(tempendDate <= endDate ){
            currentFYList.add(tempendDate);
            tempendDate = tempendDate.addMonths(1);
        }
        fyStartDate = currentFYList[0];
        fyEndDate = currentFYList[11].addMonths(1).toStartofMonth().addDays(-1);
        //String sales_rep = 'Andre White';
        //directSales = [select id,Sales_Rep_Name__c,Customer_Name__c,Product_Family__c,Product__c,Sales__c,	Units__c,Billing_Date__c,Region__c from SRx_DirectSales_SummaryTable__c where 	Billing_Date__c >=: fyStartDate AND  Billing_Date__c <=: fyEndDate  AND Sales_Rep_Name__c=:sales_rep AND Customer_Name__c=:custName ORDER BY  Billing_Date__c ASC];
        String query = '';
        query = 'select id,Sales_Rep_Name__c,Customer_Name__c,Product_Family__c,Product__c,Sales__c,	Units__c,Billing_Date__c,Region__c from SRx_DirectSales_SummaryTable__c where 	Billing_Date__c >=: fyStartDate AND  Billing_Date__c <=: fyEndDate  AND Sales_Rep_Name__c=:sales_rep ' ;
		if(custName != null && customerFromFilter.size() == 0){
            query += ' AND Customer_Name__c=:custName ';  
        }
        if(customerFromFilter.size()>0){
           query += ' AND Customer_Name__c IN: customerFromFilter ';   
         }
        if(productFromFilter.size() > 0){
            query += ' AND Product__c IN: productFromFilter  ORDER BY  Billing_Date__c ASC ';   
        }
          directSales = Database.query(query);
        System.debug('directSales==>'+directSales);
        for(SRx_DirectSales_SummaryTable__c sales : directSales){ 
            string mapKey = sales.Product_Family__c;
            if(maplist.containsKey(mapKey)){
                List < SRx_DirectSales_SummaryTable__c > tempList = maplist.get(mapKey);
                tempList.add(sales);
                maplist.put(mapKey,tempList);
            }else if(!maplist.containsKey(mapKey)){
                maplist.put(mapKey, new List < SRx_DirectSales_SummaryTable__c > {
                    sales
                        });
            }
        }
       
        System.debug('maplist==>'+maplist.size());
        date month1_FirstDate;date month1_EndDate;
        month1_FirstDate = currentFYList[0];
        month1_EndDate = currentFYList[0].addMonths(1).toStartofMonth().addDays(-1);
        date month2_FirstDate;date month2_EndDate;
        month2_FirstDate = currentFYList[1];
        month2_EndDate = currentFYList[1].addMonths(1).toStartofMonth().addDays(-1);
        date month3_FirstDate;date month3_EndDate;
        month3_FirstDate = currentFYList[2];
        month3_EndDate = currentFYList[2].addMonths(1).toStartofMonth().addDays(-1);
        date month4_FirstDate;date month4_EndDate;
        month4_FirstDate = currentFYList[3];
        month4_EndDate = currentFYList[3].addMonths(1).toStartofMonth().addDays(-1);
        date month5_FirstDate;date month5_EndDate;
        month5_FirstDate = currentFYList[4];
        month5_EndDate = currentFYList[4].addMonths(1).toStartofMonth().addDays(-1);
        date month6_FirstDate;date month6_EndDate;
        month6_FirstDate = currentFYList[5];
        month6_EndDate = currentFYList[5].addMonths(1).toStartofMonth().addDays(-1);
        date month7_FirstDate;date month7_EndDate;
        month7_FirstDate = currentFYList[6];
        month7_EndDate = currentFYList[6].addMonths(1).toStartofMonth().addDays(-1);
        date month8_FirstDate;date month8_EndDate;
        month8_FirstDate = currentFYList[7];
        month8_EndDate = currentFYList[7].addMonths(1).toStartofMonth().addDays(-1);
        date month9_FirstDate;date month9_EndDate;
        month9_FirstDate = currentFYList[8];
        month9_EndDate = currentFYList[8].addMonths(1).toStartofMonth().addDays(-1);
        date month10_FirstDate;date month10_EndDate;
        month10_FirstDate = currentFYList[9];
        month10_EndDate = currentFYList[9].addMonths(1).toStartofMonth().addDays(-1);
        date month11_FirstDate;date month11_EndDate;
        month11_FirstDate = currentFYList[10];
        month11_EndDate = currentFYList[10].addMonths(1).toStartofMonth().addDays(-1);
        date month12_FirstDate;date month12_EndDate;
        month12_FirstDate = currentFYList[11];
        month12_EndDate = currentFYList[11].addMonths(1).toStartofMonth().addDays(-1);
        for(String pFamily : maplist.KeySet()){
            Decimal month1_Direct_Sales = 0;   Decimal month2_Direct_Sales = 0;    Decimal month3_Direct_Sales = 0;
            Decimal month4_Direct_Sales = 0;   Decimal month5_Direct_Sales = 0;   Decimal month6_Direct_Sales = 0;
            Decimal month7_Direct_Sales = 0;   Decimal month8_Direct_Sales = 0;   Decimal month9_Direct_Sales = 0;
            Decimal month10_Direct_Sales = 0;   Decimal month11_Direct_Sales = 0;   Decimal month12_Direct_Sales = 0;
            Decimal month1_Units = 0;Decimal month2_Units = 0;Decimal month3_Units = 0;Decimal month4_Units = 0;
            Decimal month5_Units = 0;Decimal month6_Units = 0;Decimal month7_Units = 0;Decimal month8_Units = 0;
            Decimal month9_Units = 0;Decimal month10_Units = 0;Decimal month11_Units = 0;Decimal month12_Units = 0;
            String prodFamily;
            for (SRx_DirectSales_SummaryTable__c sales: maplist.get(pFamily)) {
                System.debug('maplist innner loop==>'+maplist.size());
                if(sales.Billing_Date__c >= month1_FirstDate && sales.Billing_Date__c <= month1_EndDate ){
                    if(sales.Sales__c != null)  month1_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month1_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month2_FirstDate && sales.Billing_Date__c <= month2_EndDate ){
                    if(sales.Sales__c != null)  month2_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month2_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month3_FirstDate && sales.Billing_Date__c <= month3_EndDate ){
                    if(sales.Sales__c != null)  month3_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month3_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month4_FirstDate && sales.Billing_Date__c <= month4_EndDate ){
                    if(sales.Sales__c != null)  month4_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month4_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month5_FirstDate && sales.Billing_Date__c <= month5_EndDate ){
                    if(sales.Sales__c != null)  month5_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month5_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month6_FirstDate && sales.Billing_Date__c <= month6_EndDate ){
                    if(sales.Sales__c != null)  month6_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month6_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month7_FirstDate && sales.Billing_Date__c <= month7_EndDate ){
                    if(sales.Sales__c != null)  month7_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month7_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month8_FirstDate && sales.Billing_Date__c <= month8_EndDate ){
                    if(sales.Sales__c != null)  month8_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month8_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month9_FirstDate && sales.Billing_Date__c <= month9_EndDate ){
                    if(sales.Sales__c != null)  month9_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month9_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month10_FirstDate && sales.Billing_Date__c <= month10_EndDate ){
                    if(sales.Sales__c != null)  month10_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month10_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month11_FirstDate && sales.Billing_Date__c <= month11_EndDate ){
                    if(sales.Sales__c != null)  month11_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month11_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month12_FirstDate && sales.Billing_Date__c <= month12_EndDate ){
                    if(sales.Sales__c != null)  month12_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month12_Units += sales.Units__c;
                }
                
                prodFamily = sales.Product_Family__c;
            }
            wrapperClass obj = new wrapperClass();
            obj.prodFamily = prodFamily;
            obj.month1_Direct_Sales = String.valueOf(month1_Direct_Sales.format());
            obj.month2_Direct_Sales = String.valueOf(month2_Direct_Sales.format());
            obj.month3_Direct_Sales = String.valueOf(month3_Direct_Sales.format());
            obj.month4_Direct_Sales = String.valueOf(month4_Direct_Sales.format());
            obj.month5_Direct_Sales = String.valueOf(month5_Direct_Sales.format());
            obj.month6_Direct_Sales = String.valueOf(month6_Direct_Sales.format());
            obj.month7_Direct_Sales = String.valueOf(month7_Direct_Sales.format());
            obj.month8_Direct_Sales = String.valueOf(month8_Direct_Sales.format());
            obj.month9_Direct_Sales = String.valueOf(month9_Direct_Sales.format());
            obj.month10_Direct_Sales = String.valueOf(month10_Direct_Sales.format());
            obj.month11_Direct_Sales = String.valueOf(month11_Direct_Sales.format());
            obj.month12_Direct_Sales = String.valueOf(month12_Direct_Sales.format());
            obj.month1_Units = String.valueOf(month1_Units.format());
            obj.month2_Units = String.valueOf(month2_Units.format());
            obj.month3_Units = String.valueOf(month3_Units.format());
            obj.month4_Units = String.valueOf(month4_Units.format());
            obj.month5_Units = String.valueOf(month5_Units.format());
            obj.month6_Units = String.valueOf(month6_Units.format());
            obj.month7_Units = String.valueOf(month7_Units.format());
            obj.month8_Units = String.valueOf(month8_Units.format());
            obj.month9_Units = String.valueOf(month9_Units.format());
            obj.month10_Units = String.valueOf(month10_Units.format());
            obj.month11_Units = String.valueOf(month11_Units.format());
            obj.month12_Units = String.valueOf(month12_Units.format());
            wrapperObj.add(obj);
            
        }
        System.debug('wrapperObj==>'+wrapperObj);
        return wrapperObj;
    }
    
     @AuraEnabled
    Public static List<wrapperClass> productFamily_getDirectSalesList(String custName,String prodFamily,String sales_rep,List<String> customerFromFilter,List<String> productFromFilter){
        List<wrapperClass> wrapperObj = new List<wrapperClass>();
        Map<String, List<SRx_DirectSales_SummaryTable__c>> maplist = new Map<String, List<SRx_DirectSales_SummaryTable__c>>();
        List<SRx_DirectSales_SummaryTable__c> directSales = new List<SRx_DirectSales_SummaryTable__c>();
      Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
        List<Date> currentFYList= new List<Date>();
        date fyDate;date fyStartDate;date fyEndDate;
       
      /*  for(integer i=3;i<=14;i++){
            date currentFyscalDate = Date.newinstance(system.today().year()-1, orgFiscalMonth+i, 1);
            currentFYList.add(currentFyscalDate);
            System.debug('currentFyscalDate==>'+currentFyscalDate);
        }
        
        fyStartDate = currentFYList[0];
        fyEndDate = currentFYList[11].addMonths(1).toStartofMonth().addDays(-1);*/
        List<FiscalYearSettings>  datelist =[ Select Name,StartDate,EndDate FROM FiscalYearSettings ];
        date startDate;date endDate;
        for(FiscalYearSettings rec: datelist){
            if(System.today() >= rec.StartDate && System.today() <= rec.EndDate){
                startDate  = rec.StartDate.toStartofMonth();
                endDate  = rec.EndDate.toStartofMonth();
                break;
            }
        }
        Date tempendDate = startDate;
        while(tempendDate <= endDate ){
            currentFYList.add(tempendDate);
            tempendDate = tempendDate.addMonths(1);
        }
        fyStartDate = currentFYList[0];
        fyEndDate = currentFYList[11].addMonths(1).toStartofMonth().addDays(-1);
        //String sales_rep = 'Andre White';
        //directSales = [select id,Sales_Rep_Name__c,Customer_Name__c,Product_Family__c,Product__c,Sales__c,	Units__c,Billing_Date__c,Region__c from SRx_DirectSales_SummaryTable__c where 	Billing_Date__c >=: fyStartDate AND  Billing_Date__c <=: fyEndDate AND Sales_Rep_Name__c=:sales_rep AND Product_Family__c=:prodFamily ORDER BY  Billing_Date__c ASC];
        String query = '';
        query = 'select id,Sales_Rep_Name__c,Customer_Name__c,Product_Family__c,Product__c,Sales__c,	Units__c,Billing_Date__c,Region__c from SRx_DirectSales_SummaryTable__c where 	Billing_Date__c >=: fyStartDate AND  Billing_Date__c <=: fyEndDate AND Sales_Rep_Name__c=:sales_rep ' ;
		
         if(custName != null && customerFromFilter.size() == 0){
            query += ' AND Customer_Name__c=:custName ';  
        }
        if(prodFamily != null && productFromFilter.size() == 0){
            query += ' AND Product_Family__c=:prodFamily ';  
        }     
      
        if(customerFromFilter.size()>0){
           query += ' AND Customer_Name__c IN: customerFromFilter ';   
         }
        if(productFromFilter.size() > 0){
            query += ' AND Product__c IN: productFromFilter  ORDER BY  Billing_Date__c ASC ';   
        }
        directSales = Database.query(query);
        System.debug('directSales==>'+directSales);
        for(SRx_DirectSales_SummaryTable__c sales : directSales){ 
            string mapKey = sales.Product__c;
            if(maplist.containsKey(mapKey)){
                List < SRx_DirectSales_SummaryTable__c > tempList = maplist.get(mapKey);
                tempList.add(sales);
                maplist.put(mapKey,tempList);
            }else if(!maplist.containsKey(mapKey)){
                maplist.put(mapKey, new List < SRx_DirectSales_SummaryTable__c > {
                    sales
                        });
            }
        }
      
        System.debug('maplist==>'+maplist.size());
        date month1_FirstDate;date month1_EndDate;
        month1_FirstDate = currentFYList[0];
        month1_EndDate = currentFYList[0].addMonths(1).toStartofMonth().addDays(-1);
        date month2_FirstDate;date month2_EndDate;
        month2_FirstDate = currentFYList[1];
        month2_EndDate = currentFYList[1].addMonths(1).toStartofMonth().addDays(-1);
        date month3_FirstDate;date month3_EndDate;
        month3_FirstDate = currentFYList[2];
        month3_EndDate = currentFYList[2].addMonths(1).toStartofMonth().addDays(-1);
        date month4_FirstDate;date month4_EndDate;
        month4_FirstDate = currentFYList[3];
        month4_EndDate = currentFYList[3].addMonths(1).toStartofMonth().addDays(-1);
        date month5_FirstDate;date month5_EndDate;
        month5_FirstDate = currentFYList[4];
        month5_EndDate = currentFYList[4].addMonths(1).toStartofMonth().addDays(-1);
        date month6_FirstDate;date month6_EndDate;
        month6_FirstDate = currentFYList[5];
        month6_EndDate = currentFYList[5].addMonths(1).toStartofMonth().addDays(-1);
        date month7_FirstDate;date month7_EndDate;
        month7_FirstDate = currentFYList[6];
        month7_EndDate = currentFYList[6].addMonths(1).toStartofMonth().addDays(-1);
        date month8_FirstDate;date month8_EndDate;
        month8_FirstDate = currentFYList[7];
        month8_EndDate = currentFYList[7].addMonths(1).toStartofMonth().addDays(-1);
        date month9_FirstDate;date month9_EndDate;
        month9_FirstDate = currentFYList[8];
        month9_EndDate = currentFYList[8].addMonths(1).toStartofMonth().addDays(-1);
        date month10_FirstDate;date month10_EndDate;
        month10_FirstDate = currentFYList[9];
        month10_EndDate = currentFYList[9].addMonths(1).toStartofMonth().addDays(-1);
        date month11_FirstDate;date month11_EndDate;
        month11_FirstDate = currentFYList[10];
        month11_EndDate = currentFYList[10].addMonths(1).toStartofMonth().addDays(-1);
        date month12_FirstDate;date month12_EndDate;
        month12_FirstDate = currentFYList[11];
        month12_EndDate = currentFYList[11].addMonths(1).toStartofMonth().addDays(-1);
        for(String prod : maplist.KeySet()){
            Decimal month1_Direct_Sales = 0;   Decimal month2_Direct_Sales = 0;    Decimal month3_Direct_Sales = 0;
            Decimal month4_Direct_Sales = 0;   Decimal month5_Direct_Sales = 0;   Decimal month6_Direct_Sales = 0;
            Decimal month7_Direct_Sales = 0;   Decimal month8_Direct_Sales = 0;   Decimal month9_Direct_Sales = 0;
            Decimal month10_Direct_Sales = 0;   Decimal month11_Direct_Sales = 0;   Decimal month12_Direct_Sales = 0;
            Decimal month1_Units = 0;Decimal month2_Units = 0;Decimal month3_Units = 0;Decimal month4_Units = 0;
            Decimal month5_Units = 0;Decimal month6_Units = 0;Decimal month7_Units = 0;Decimal month8_Units = 0;
            Decimal month9_Units = 0;Decimal month10_Units = 0;Decimal month11_Units = 0;Decimal month12_Units = 0;
            String productDesc;
            for (SRx_DirectSales_SummaryTable__c sales: maplist.get(prod)) {
                System.debug('maplist innner loop==>'+maplist.size());
                if(sales.Billing_Date__c >= month1_FirstDate && sales.Billing_Date__c <= month1_EndDate ){
                    if(sales.Sales__c != null)  month1_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month1_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month2_FirstDate && sales.Billing_Date__c <= month2_EndDate ){
                    if(sales.Sales__c != null)  month2_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month2_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month3_FirstDate && sales.Billing_Date__c <= month3_EndDate ){
                    if(sales.Sales__c != null)  month3_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month3_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month4_FirstDate && sales.Billing_Date__c <= month4_EndDate ){
                    if(sales.Sales__c != null)  month4_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month4_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month5_FirstDate && sales.Billing_Date__c <= month5_EndDate ){
                    if(sales.Sales__c != null)  month5_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month5_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month6_FirstDate && sales.Billing_Date__c <= month6_EndDate ){
                    if(sales.Sales__c != null)  month6_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month6_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month7_FirstDate && sales.Billing_Date__c <= month7_EndDate ){
                    if(sales.Sales__c != null)  month7_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month7_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month8_FirstDate && sales.Billing_Date__c <= month8_EndDate ){
                    if(sales.Sales__c != null)  month8_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month8_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month9_FirstDate && sales.Billing_Date__c <= month9_EndDate ){
                    if(sales.Sales__c != null)  month9_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month9_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month10_FirstDate && sales.Billing_Date__c <= month10_EndDate ){
                    if(sales.Sales__c != null)  month10_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month10_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month11_FirstDate && sales.Billing_Date__c <= month11_EndDate ){
                    if(sales.Sales__c != null)  month11_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month11_Units += sales.Units__c;
                }
                if(sales.Billing_Date__c >= month12_FirstDate && sales.Billing_Date__c <= month12_EndDate ){
                    if(sales.Sales__c != null)  month12_Direct_Sales += sales.Sales__c;
                    if(sales.Units__c != null)  month12_Units += sales.Units__c;
                }
                
                productDesc = sales.Product__c;
            }
            wrapperClass obj = new wrapperClass();
            obj.productDesc = productDesc;
            obj.month1_Direct_Sales = String.valueOf(month1_Direct_Sales.format());
            obj.month2_Direct_Sales = String.valueOf(month2_Direct_Sales.format());
            obj.month3_Direct_Sales = String.valueOf(month3_Direct_Sales.format());
            obj.month4_Direct_Sales = String.valueOf(month4_Direct_Sales.format());
            obj.month5_Direct_Sales = String.valueOf(month5_Direct_Sales.format());
            obj.month6_Direct_Sales = String.valueOf(month6_Direct_Sales.format());
            obj.month7_Direct_Sales = String.valueOf(month7_Direct_Sales.format());
            obj.month8_Direct_Sales = String.valueOf(month8_Direct_Sales.format());
            obj.month9_Direct_Sales = String.valueOf(month9_Direct_Sales.format());
            obj.month10_Direct_Sales = String.valueOf(month10_Direct_Sales.format());
            obj.month11_Direct_Sales = String.valueOf(month11_Direct_Sales.format());
            obj.month12_Direct_Sales = String.valueOf(month12_Direct_Sales.format());
            obj.month1_Units = String.valueOf(month1_Units.format());
            obj.month2_Units = String.valueOf(month2_Units.format());
            obj.month3_Units = String.valueOf(month3_Units.format());
            obj.month4_Units = String.valueOf(month4_Units.format());
            obj.month5_Units = String.valueOf(month5_Units.format());
            obj.month6_Units = String.valueOf(month6_Units.format());
            obj.month7_Units = String.valueOf(month7_Units.format());
            obj.month8_Units = String.valueOf(month8_Units.format());
            obj.month9_Units = String.valueOf(month9_Units.format());
            obj.month10_Units = String.valueOf(month10_Units.format());
            obj.month11_Units = String.valueOf(month11_Units.format());
            obj.month12_Units = String.valueOf(month12_Units.format());
            wrapperObj.add(obj);
            
        }
        System.debug('wrapperObj==>'+wrapperObj);
        return wrapperObj;
    }
    
     public class wrapperClass{
     @AuraEnabled public String month1_SalesSummary;
     @AuraEnabled public String month2_SalesSummary;
     @AuraEnabled public String month3_SalesSummary;
     @AuraEnabled public String month4_SalesSummary;
     @AuraEnabled public String month5_SalesSummary;
     @AuraEnabled public String month6_SalesSummary;
     @AuraEnabled public String month7_SalesSummary;
     @AuraEnabled public String month8_SalesSummary;
     @AuraEnabled public String month9_SalesSummary;
     @AuraEnabled public String month10_SalesSummary;
     @AuraEnabled public String month11_SalesSummary;
     @AuraEnabled public String month12_SalesSummary;
     @AuraEnabled public String month1_Direct_Sales;
     @AuraEnabled public String month2_Direct_Sales;
     @AuraEnabled public String month3_Direct_Sales;
     @AuraEnabled public String month4_Direct_Sales;
     @AuraEnabled public String month5_Direct_Sales;
     @AuraEnabled public String month6_Direct_Sales;
     @AuraEnabled public String month7_Direct_Sales;
     @AuraEnabled public String month8_Direct_Sales;
     @AuraEnabled public String month9_Direct_Sales;
     @AuraEnabled public String month10_Direct_Sales;
     @AuraEnabled public String month11_Direct_Sales;
     @AuraEnabled public String month12_Direct_Sales;
     @AuraEnabled public String  month1_Units;
     @AuraEnabled public String  month2_Units;
     @AuraEnabled public String  month3_Units;
     @AuraEnabled public String  month4_Units;
     @AuraEnabled public String  month5_Units;
     @AuraEnabled public String  month6_Units;
     @AuraEnabled public String  month7_Units;
     @AuraEnabled public String  month8_Units;
     @AuraEnabled public String  month9_Units;
     @AuraEnabled public String  month10_Units;
     @AuraEnabled public String  month11_Units;
     @AuraEnabled public String  month12_Units;
     @AuraEnabled public String month1_UnitsSummary;
     @AuraEnabled public String month2_UnitsSummary;
     @AuraEnabled public String month3_UnitsSummary;
     @AuraEnabled public String month4_UnitsSummary;
     @AuraEnabled public String month5_UnitsSummary;
     @AuraEnabled public String month6_UnitsSummary;
     @AuraEnabled public String month7_UnitsSummary;
     @AuraEnabled public String month8_UnitsSummary;
     @AuraEnabled public String month9_UnitsSummary;
     @AuraEnabled public String month10_UnitsSummary;
     @AuraEnabled public String month11_UnitsSummary;
     @AuraEnabled public String month12_UnitsSummary;
     @AuraEnabled public String customerName;
     @AuraEnabled public String prodFamily;
     @AuraEnabled public String productDesc;  
     @AuraEnabled public Map<String,String> currenttwelveMonthKeys;
    
    }
}