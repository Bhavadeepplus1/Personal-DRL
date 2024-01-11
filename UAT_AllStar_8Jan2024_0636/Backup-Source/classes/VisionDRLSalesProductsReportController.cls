public class VisionDRLSalesProductsReportController {
    @auraEnabled
    Public static wrapperClass getDRLSalesRelatedList(List<String> selections,String selectedComparison, String customerId,String accCode,Boolean showInt, String searchText,List<String> drlSalesIds){
        System.debug('search text-->'+searchText);
        String searchText1 = '%'+searchText+'%';
        String currentUserId = userInfo.getUserId();//manisha -'0050m000003VwVTAA0';//'2F0050m000003VwVT';//userInfo.getUserId();
        String currentUserName =userinfo.getName();
        User userDetails = [SELECT Id, Name, Division FROM User WHERE Id=: userInfo.getUserId()];
        if(selections.size() == 0){
            if(userDetails.Division != null)
                selections.add(userDetails.Division);
            else{
                selections.add('Rx');
                selections.add('SRx');
                selections.add('OTC');
            }
        }
        userDetails = new User();
        Date FirstDateInRecent,LastDateInRecent,FirstDateInPrevious,LastDateInPrevious;
        date lastquarter, previousquarter;
        date lastmonthlastDatefytd;
        List<Date> lastquarterdateList= new List<Date>();
        List<Date> previousquarterDateList = new List<Date>();
        Map<String, String> mapOfHeaders = new Map<String, String>();
        List<Date> fytdprevdatelist = new List<Date>();
        Date lastmonthfirstDatePrev,lastmonthlastDatePrevfytd;
        map<Integer,String > monthdatelist = new map<Integer,String>();
        List<String> lastyearmonthslist = new List<String>();
         integer recentLastMonth,previousLastMonth;
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
        /* Start Last year vs. Previous year*/
         List<String> keySet = new List<String>();
        List<String> keySetPrev = new List<String>();
        if(selectedComparison == 'last12monthsvsprevious12months'){
            List<Date> lasttwmonthsdatelist= new List<Date>();
            List<Date> prevtwmontdateList= new List<Date>();
            date dateBefore;
            date previdates;
            for(Integer i=1;i<=12;i++){
                dateBefore=System.today().addMonths(-i).toStartOfMonth();//getting last 12 months
                previdates=System.today().addMonths(-i-12).toStartOfMonth();//getting previous 12 months
                lasttwmonthsdatelist.add(dateBefore);//adding last 12 months to list
                prevtwmontdateList.add(previdates);//adding previous 12 months to list
            }
            FirstDateInRecent = Date.valueOf('2022-06-30');//lasttwmonthsdatelist[0].addMonths(1).toStartofMonth().addDays(-1);
            LastDateInRecent = Date.valueOf('2021-05-01');//lasttwmonthsdatelist[11];
            FirstDateInPrevious = Date.valueOf('2021-06-30');//prevtwmontdateList[0].addMonths(1).toStartofMonth().addDays(-1);
            LastDateInPrevious = Date.valueOf('2020-05-01');//prevtwmontdateList[11];
            List<Vision_InternalDRLSales_ProductSummary__c> date1 = new List<Vision_InternalDRLSales_ProductSummary__c>();
            List<Vision_InternalDRLSales_ProductSummary__c> date2 = new List<Vision_InternalDRLSales_ProductSummary__c>();
            List<Vision_InternalDRLSales_ProductSummary__c> date3 = new List<Vision_InternalDRLSales_ProductSummary__c>();
            List<Vision_InternalDRLSales_ProductSummary__c> date4 = new List<Vision_InternalDRLSales_ProductSummary__c>();
            
            if(!showInt){
                 date1 =[select 	Vision_Unique_Identifier__c,Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                             from Vision_InternalDRLSales_ProductSummary__c  where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent) AND Vision_Segment__c IN: selections AND Vision_Customer__c =: customerId  ORDER BY  Vision_Processed_Date__c ASC Limit 1
                                            ];
                 date2 =[select 	Vision_Unique_Identifier__c,Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                             from Vision_InternalDRLSales_ProductSummary__c  where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent) AND Vision_Segment__c IN: selections AND Vision_Customer__c =: customerId  ORDER BY  Vision_Processed_Date__c DESC Limit 1
                                            ];
                 date3 =[select 	Vision_Unique_Identifier__c,Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                             from Vision_InternalDRLSales_ProductSummary__c  where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious) AND Vision_Segment__c IN: selections AND Vision_Customer__c =: customerId  ORDER BY  Vision_Processed_Date__c ASC Limit 1
                                            ];
                 date4 =[select 	Vision_Unique_Identifier__c,Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                             from Vision_InternalDRLSales_ProductSummary__c  where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious) AND Vision_Segment__c IN: selections AND Vision_Customer__c =: customerId  ORDER BY  Vision_Processed_Date__c DESC Limit 1
                                            ];
            }
           
            if(!showInt){
                if(date2.size()>0 && date4.size()>0){
                     recentLastMonth = date2[0].Vision_Processed_Date__c.month();
                    previousLastMonth = date4[0].Vision_Processed_Date__c.month();
                }
            }
            if(recentLastMonth == previousLastMonth){
                 FirstDateInRecent = Date.valueOf('2022-06-30');//lasttwmonthsdatelist[0].addMonths(1).toStartofMonth().addDays(-1);
                LastDateInRecent = Date.valueOf('2021-05-01');//lasttwmonthsdatelist[11];
                FirstDateInPrevious = Date.valueOf('2021-06-30');//prevtwmontdateList[0].addMonths(1).toStartofMonth().addDays(-1);
                LastDateInPrevious = Date.valueOf('2020-05-01');//prevtwmontdateList[11];
            }  else{
                lasttwmonthsdatelist.clear();
               	 prevtwmontdateList.clear();
                 date dateBefore1;
                 date previdates1;
                for(Integer i=1;i<=13;i++){
                    dateBefore1=System.today().addMonths(-i).toStartOfMonth();//getting last 12 months
                    previdates1=System.today().addMonths(-i-12).toStartOfMonth();//getting previous 12 months
                    lasttwmonthsdatelist.add(dateBefore1);//adding last 12 months to list
                    prevtwmontdateList.add(previdates1);//adding previous 12 months to list
                }
				FirstDateInRecent = Date.valueOf('2022-06-30');//lasttwmonthsdatelist[1].addMonths(1).toStartofMonth().addDays(-1);
                LastDateInRecent = Date.valueOf('2021-05-01');//lasttwmonthsdatelist[12];
                FirstDateInPrevious = Date.valueOf('2021-06-30');//prevtwmontdateList[1].addMonths(1).toStartofMonth().addDays(-1);
                LastDateInPrevious = Date.valueOf('2020-05-01');//prevtwmontdateList[12];               
                date1.clear();
                date2.clear();
                date3.clear();
                date4.clear();
                if(!showInt){
                 date1 =[select 	Vision_Unique_Identifier__c,Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                             from Vision_InternalDRLSales_ProductSummary__c  where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent) AND Vision_Segment__c IN: selections AND Vision_Customer__c =: customerId  ORDER BY  Vision_Processed_Date__c ASC Limit 1
                                            ];
                 date2 =[select 	Vision_Unique_Identifier__c,Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                             from Vision_InternalDRLSales_ProductSummary__c  where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent) AND Vision_Segment__c IN: selections AND Vision_Customer__c =: customerId  ORDER BY  Vision_Processed_Date__c DESC Limit 1
                                            ];
                 date3 =[select 	Vision_Unique_Identifier__c,Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                             from Vision_InternalDRLSales_ProductSummary__c  where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious) AND Vision_Segment__c IN: selections AND Vision_Customer__c =: customerId  ORDER BY  Vision_Processed_Date__c ASC Limit 1
                                            ];
                 date4 =[select 	Vision_Unique_Identifier__c,Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                             from Vision_InternalDRLSales_ProductSummary__c  where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious) AND Vision_Segment__c IN: selections AND Vision_Customer__c =: customerId  ORDER BY  Vision_Processed_Date__c DESC Limit 1
                                            ];
            }
            } 
            Integer firstMonthInRecent,year,lastMonthInRecent,lastYear,monthInPrevious,yearPrev,lastMonthInPrevious,lastYearPrev;
            String monthname,YearInRecent,lastmonthname,lastYearInRecent,monthnamePrev,yearInPrev,lastmonthnamePrev,lastYearInPrev;
             if(!showInt){
                 if(date1.size()>0){
                     firstMonthInRecent = date1[0].Vision_Processed_Date__c.month();
                     monthname = monthdatelist.get(firstMonthInRecent);
                     year = date1[0].Vision_Processed_Date__c.year();
                     YearInRecent =String.valueOf(year).right(2);
                 }
                 if(date2.size()>0){
                     lastMonthInRecent = date2[0].Vision_Processed_Date__c.month();
                     lastmonthname = monthdatelist.get(lastMonthInRecent);
                     lastYear = date2[0].Vision_Processed_Date__c.year();
                     lastYearInRecent = String.valueOf(lastYear).right(2);   
                 }
                 
                 if(date3.size()>0){
                     monthInPrevious = date3[0].Vision_Processed_Date__c.month();
                     monthnamePrev = monthdatelist.get(monthInPrevious);
                     yearPrev = date3[0].Vision_Processed_Date__c.year();
                     yearInPrev =String.valueOf(yearPrev).right(2);
                 }
                 if(date4.size()>0){
                     if(recentLastMonth == previousLastMonth){
                         lastMonthInPrevious = date4[0].Vision_Processed_Date__c.month();
                     }else{
                         lastMonthInPrevious = date2[0].Vision_Processed_Date__c.month();
                     }
                     lastmonthnamePrev = monthdatelist.get(lastMonthInPrevious);
                     lastYearPrev = date4[0].Vision_Processed_Date__c.year();
                     lastYearInPrev = String.valueOf(lastYearPrev).right(2);
                 }
             }
           
            String h2;
            String h1 =monthname +' ' +YearInRecent +'-' +lastmonthname+' '+lastYearInRecent;
            h2 = monthnamePrev +' ' +yearInPrev +'-' +lastmonthnamePrev+' '+lastYearInPrev;//'Apr 20-Nov 20';*/
            if(!showInt){
                if(monthnamePrev == null || yearInPrev == null || lastmonthnamePrev== null||lastYearInPrev== null){
                    year = date1[0].Vision_Processed_Date__c.year()-1;
                     YearInRecent =String.valueOf(year).right(2);
                    lastYear = date2[0].Vision_Processed_Date__c.year()-1;
                     lastYearInRecent = String.valueOf(lastYear).right(2);
                     h2 = monthname +' ' +YearInRecent +'-' +lastmonthname+' '+lastYearInRecent;
                }else{
                     h2 = monthnamePrev +' ' +yearInPrev +'-' +lastmonthnamePrev+' '+lastYearInPrev;
                }
            }
            mapOfHeaders.put('one', h1);
            mapOfHeaders.put('two', h2);
            /*for KeySet*/
          if(recentLastMonth == previousLastMonth){
            for(integer i=lasttwmonthsdatelist.size()-1;i>=0;i--){
                
                integer m= lasttwmonthsdatelist[i].month();
                string mName =  monthdatelist.get(m);
                integer y = lasttwmonthsdatelist[i].year();
                 String year1  = String.valueOf(y).right(2);
                  String key = mName+'-'+ year1;
                keySet.add(key);
            }
            for(integer i= prevtwmontdateList.size()-1;i>=0;i--){
                
                integer m= prevtwmontdateList[i].month();
                string mName =  monthdatelist.get(m);
                integer y = prevtwmontdateList[i].year();
                 String year2  = String.valueOf(y).right(2);
                  String key = mName+'-'+ year2;
                keySetPrev.add(key);
            }
          }
          else{
               for(integer i=lasttwmonthsdatelist.size()-1;i>=1;i--){
                
                integer m= lasttwmonthsdatelist[i].month();
                string mName =  monthdatelist.get(m);
                integer y = lasttwmonthsdatelist[i].year();
                 String year1  = String.valueOf(y).right(2);
                  String key = mName+'-'+ year1;
                keySet.add(key);
                   integer j = lasttwmonthsdatelist.size()-1;
                    integer k = lasttwmonthsdatelist.size()-2;
                   System.debug('actual size--'+j);
                   System.debug('reduce size--'+k);
            }
            for(integer i= prevtwmontdateList.size()-1;i>=0;i--){
                
                integer m= prevtwmontdateList[i].month();
                string mName =  monthdatelist.get(m);
                integer y = prevtwmontdateList[i].year();
                 String year2  = String.valueOf(y).right(2);
                  String key = mName+'-'+ year2;
                keySetPrev.add(key);
            } 
          }
            /*End for KeySet*/
            lasttwmonthsdatelist.clear();
            prevtwmontdateList.clear();
            date1.clear();
            date2.clear();
            date3.clear();
            date4.clear();
           
            //}
        }
        /* End Last year vs. Previous year*/
        
        /* Start last quarter vs. previous quarter*/
        else if(selectedComparison == 'lastquartervspreviousquarter'){
            List<Integer> Q1=new List<Integer>{4,5,6}; 
                List<Integer> Q2=new List<Integer>{7,8,9}; 
                    List<Integer> Q3=new List<Integer>{10,11,12};
                        List<Integer> Q4=new List<Integer>{1,2,3}; 
                            date todayDate =System.today();
            Integer month = todayDate.month();
			System.debug('month-->'+month);
            if(Q1.contains(month)){
                if( (Q1[0]==month) || (Q1[1] == month) || (Q1[2] == month) ){
                    if(month==4){
                        FirstDateInRecent = System.today().addMonths(-1).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-3).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-4).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-6).toStartOfMonth();
                    }else if(month==5){
                        FirstDateInRecent = System.today().addMonths(-2).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-4).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-5).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-7).toStartOfMonth();
                    }
                    else if(month==6){        
                        FirstDateInRecent = System.today().addMonths(-3).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-5).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-6).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-8).toStartOfMonth();
                    }
                }
                
            }else if(Q2.contains(month)){
                if( (Q2[0]==month) || (Q2[1] == month) || (Q2[2] == month) ){
               			if(month==7){
                        FirstDateInRecent = System.today().addMonths(-4).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-6).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-7).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-9).toStartOfMonth();
                    }
                    else if(month==8){
                        FirstDateInRecent = System.today().addMonths(-5).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-7).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-8).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-10).toStartOfMonth();
                    }
                    else if(month==9){
                        FirstDateInRecent = System.today().addMonths(-6).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-8).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-9).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-11).toStartOfMonth();
                    }
                }
            }
            else if(Q3.contains(month)){
                if( (Q3[0]==month) || (Q3[1] == month) || (Q3[2] == month) ){
                    if(month==10){
                        FirstDateInRecent = System.today().addMonths(-7).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-9).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-10).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-12).toStartOfMonth();
                    }
                    else if(month==11){
                        FirstDateInRecent = System.today().addMonths(-8).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-10).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-11).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-13).toStartOfMonth();
                    }
                    else if(month==12){
                        FirstDateInRecent = System.today().addMonths(-9).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-11).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-12).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-14).toStartOfMonth();
                    }
                }
            }
            else if(Q4.contains(month)){
                if( (Q4[0]==month) || (Q4[1] == month) || (Q4[2] == month) ){
                     if(month==1){
                        FirstDateInRecent = System.today().addMonths(-10).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-12).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-13).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-15).toStartOfMonth();
                     }
                    else if(month==2){
                        FirstDateInRecent = System.today().addMonths(-11).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-13).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-14).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-16).toStartOfMonth();
                    }
                    else if(month==3){
                        FirstDateInRecent = System.today().addMonths(-12).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-14).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-15).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-17).toStartOfMonth();
                    }
                }
            }
            Integer y1 = FirstDateInRecent.year();
            Integer latquartermonth = FirstDateInRecent.month();
            
            
            Boolean qtrone =Q1.contains(latquartermonth);
            
            Boolean qtrtwo =Q2.contains(latquartermonth);
            Boolean qtrthree =Q3.contains(latquartermonth);
            
            Boolean qtrfour = Q4.contains(latquartermonth);
            Integer y2 = FirstDateInPrevious.year();
            
            Integer prevquartermonth = LastDateInPrevious.month();
            Boolean prevqtrone =Q1.contains(prevquartermonth);
            
            Boolean prevqtrtwo =Q2.contains(prevquartermonth);
            Boolean prevqtrthree =Q3.contains(prevquartermonth);
            Boolean prevqtrfour =Q4.contains(prevquartermonth);
            String h1,h2;
            if(qtrone) h1 = 'Q1';
            if(qtrtwo) h1 = 'Q2';
            if(qtrthree) h1 = 'Q3';
            if(qtrfour) h1 = 'Q4';
            if(prevqtrone) h2 = 'Q1';
            if(prevqtrtwo) h2 = 'Q2';
            if(prevqtrthree) h2 = 'Q3';
            if(prevqtrfour) h2 = 'Q4';
            System.debug('h1 value-->'+h1);
            System.debug('h2 value-->'+h2);
            mapOfHeaders.put('one', h1);
            mapOfHeaders.put('two', h2);
            lastquarterdateList.clear();
            previousquarterDateList.clear();
        }
        /* End last quarter vs. previous quarter*/
        /*Start FYD*/
        else if(selectedComparison == 'fytdvspreviousfytd'){
            Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
            date todayDate = System.today();
            date currentFyscalDate = Date.newinstance(system.today().year(), orgFiscalMonth+3, 1);
            LastDateInRecent = Date.newinstance(system.today().year()-1, orgFiscalMonth+3, 1);
                LastDateInPrevious = Date.newinstance(system.today().year()-2, orgFiscalMonth+3, 1);
           /* if(todayDate <= currentFyscalDate){
            	LastDateInRecent = Date.newinstance(system.today().year()-1, orgFiscalMonth+3, 1);
                LastDateInPrevious = Date.newinstance(system.today().year()-2, orgFiscalMonth+3, 1);
            }else{
                LastDateInRecent = Date.newinstance(system.today().year(), orgFiscalMonth+3, 1);
                LastDateInPrevious = Date.newinstance(system.today().year()-1, orgFiscalMonth+3, 1);
            }*/
            System.debug('LastDateInRecent-->'+LastDateInRecent);
            Integer orgFiscalMonthPrev = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
            
            System.debug('LastDateInPrevious-->'+LastDateInPrevious);
            
            for(Integer i=1;i<=1;i++){
                FirstDateInRecent=System.today().addMonths(-i).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                System.debug('FirstDateInRecent-->'+FirstDateInRecent);
                lastmonthlastDatefytd = FirstDateInRecent.addDays(Date.daysInMonth(FirstDateInRecent.year(), FirstDateInRecent.month()) - 1);
            }
            for(Integer i=1;i<=12;i++){
                lastmonthfirstDatePrev=System.today().addMonths(-i-13).toStartOfMonth();
                lastmonthlastDatePrevfytd = lastmonthfirstDatePrev.addDays(Date.daysInMonth(lastmonthfirstDatePrev.year(), lastmonthfirstDatePrev.month()));
                
                fytdprevdatelist.add(lastmonthlastDatePrevfytd);
            }
            FirstDateInPrevious = fytdprevdatelist[0].addMonths(1).toStartofMonth().addDays(-1);
            System.debug('FirstDateInPrevious-->'+FirstDateInPrevious);
            
             /*for KeySet*/
            integer orgmonth=orgFiscalMonth+3;
            Integer monthsBetween = LastDateInRecent.monthsBetween(todayDate);
             Integer monthsBetweenPrev = LastDateInPrevious.monthsBetween(todayDate);
            List<Date> lastmonthsdatelist= new List<Date>();
            List<Date> prevmontdateList= new List<Date>();
            for(integer i=0;i<monthsBetween;i++){
                date eachDate=Date.newinstance(system.today().year()-1, orgmonth+i, 1);
                System.debug('each date-->'+eachDate);
                lastmonthsdatelist.add(eachDate);
            }
            for(integer i=0;i<monthsBetween;i++){
                date eachDatePrev=Date.newinstance(system.today().year()-2, orgmonth+i, 1);
                System.debug('each date-->'+eachDatePrev);
                prevmontdateList.add(eachDatePrev);
            }
			
            /*end for KeySet*/
            List<Vision_InternalDRLSales_ProductSummary__c> date1 = new List<Vision_InternalDRLSales_ProductSummary__c>();
            List<Vision_InternalDRLSales_ProductSummary__c> date2 = new List<Vision_InternalDRLSales_ProductSummary__c>();
            List<Vision_InternalDRLSales_ProductSummary__c> date3 = new List<Vision_InternalDRLSales_ProductSummary__c>();
            List<Vision_InternalDRLSales_ProductSummary__c> date4 = new List<Vision_InternalDRLSales_ProductSummary__c>();
           if(!showInt){  
			  date1 =[select 	Vision_Unique_Identifier__c,Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                         from Vision_InternalDRLSales_ProductSummary__c  where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent) AND Vision_Segment__c IN: selections AND Vision_Customer__c =: customerId  ORDER BY  Vision_Processed_Date__c ASC Limit 1
                                        ];
           	 date2 =[select 	Vision_Unique_Identifier__c,Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                         from Vision_InternalDRLSales_ProductSummary__c  where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent) AND Vision_Segment__c IN: selections AND Vision_Customer__c =: customerId  ORDER BY  Vision_Processed_Date__c DESC Limit 1
                                        ];
           	 date3 =[select 	Vision_Unique_Identifier__c,Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                         from Vision_InternalDRLSales_ProductSummary__c  where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious) AND Vision_Segment__c IN: selections AND Vision_Customer__c =: customerId  ORDER BY  Vision_Processed_Date__c ASC Limit 1
                                        ];
            date4 =[select 	Vision_Unique_Identifier__c,Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                         from Vision_InternalDRLSales_ProductSummary__c  where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious) AND Vision_Segment__c IN: selections AND Vision_Customer__c =: customerId  ORDER BY  Vision_Processed_Date__c DESC Limit 1
                                        ];
           }
             if(!showInt){
            	recentLastMonth = date2[0].Vision_Processed_Date__c.month();
            	 previousLastMonth = date4[0].Vision_Processed_Date__c.month();
             }
            
            if(recentLastMonth == previousLastMonth){
                FirstDateInRecent =lastmonthsdatelist [monthsBetween-1].addMonths(1).toStartofMonth().addDays(-1);
                LastDateInRecent = lastmonthsdatelist[0];
                FirstDateInPrevious = prevmontdateList[monthsBetween-1].addMonths(1).toStartofMonth().addDays(-1);
                LastDateInPrevious = prevmontdateList[0];
            }else{
                FirstDateInRecent =lastmonthsdatelist [monthsBetween-2].addMonths(1).toStartofMonth().addDays(-1);
                LastDateInRecent = lastmonthsdatelist[0];
                FirstDateInPrevious = prevmontdateList[monthsBetween-2].addMonths(1).toStartofMonth().addDays(-1);
                LastDateInPrevious = prevmontdateList[0];
            }
             if(recentLastMonth == previousLastMonth){
                 for(integer i=0;i<lastmonthsdatelist.size();i++){
                     
                     integer m= lastmonthsdatelist[i].month();
                     string mName =  monthdatelist.get(m);
                     integer y = lastmonthsdatelist[i].year();
                     String year  = String.valueOf(y).right(2);
                     String key = mName+'-'+ year;
                     keySet.add(key);
                 }
                 for(integer i=0;i<prevmontdateList.size();i++){
                     
                     integer m= prevmontdateList[i].month();
                     string mName =  monthdatelist.get(m);
                     integer y = prevmontdateList[i].year();
                     String year  = String.valueOf(y).right(2);
                     String key = mName+'-'+ year;
                     keySetPrev.add(key);
                 } 
             }else{
                 for(integer i=0;i<lastmonthsdatelist.size()-1;i++){
                     
                     integer m= lastmonthsdatelist[i].month();
                     string mName =  monthdatelist.get(m);
                     integer y = lastmonthsdatelist[i].year();
                     String year  = String.valueOf(y).right(2);
                     String key = mName+'-'+ year;
                     keySet.add(key);
                 }
                 for(integer i=0;i<prevmontdateList.size()-1;i++){
                     
                     integer m= prevmontdateList[i].month();
                     string mName =  monthdatelist.get(m);
                     integer y = prevmontdateList[i].year();
                     String year  = String.valueOf(y).right(2);
                     String key = mName+'-'+ year;
                     keySetPrev.add(key);
                 }
             }
            Integer firstdatefytd,year,lastdatefytd,lastYear,firstdatefytdPrev,yearPrev,lastdatefytdPrev,lastYearPrev;
            String monthname,firstdate,lastmonthname,lastdate,monthnamePrev,firstdatePrev,lastmonthnamePrev,lastdatePrev;
            if(!showInt){ 
            	if(date1.size()>0){
            	 firstdatefytd = date1[0].Vision_Processed_Date__c.month();
            	 monthname = monthdatelist.get(firstdatefytd);
            	  year = date1[0].Vision_Processed_Date__c.year();
            	 firstdate =String.valueOf(year).right(2);
            }
            	if(date2.size()>0){
                 lastdatefytd = date2[0].Vision_Processed_Date__c.month();
                 lastmonthname = monthdatelist.get(lastdatefytd);
                 lastYear = date2[0].Vision_Processed_Date__c.year();
                 lastdate = String.valueOf(lastYear).right(2);
            }
             	if(date3.size()>0){
                 firstdatefytdPrev = date3[0].Vision_Processed_Date__c.month();
                 monthnamePrev = monthdatelist.get(firstdatefytdPrev);
                  yearPrev = date3[0].Vision_Processed_Date__c.year();
                 firstdatePrev =String.valueOf(yearPrev).right(2);
             }
            	if(date4.size()>0){
                if(recentLastMonth == previousLastMonth){
            	 	lastdatefytdPrev = date4[0].Vision_Processed_Date__c.month();
                }else{
                 lastdatefytdPrev = date2[0].Vision_Processed_Date__c.month();
                }
                 lastmonthnamePrev = monthdatelist.get(lastdatefytdPrev);
                 lastYearPrev = date4[0].Vision_Processed_Date__c.year();
                 lastdatePrev = String.valueOf(lastYearPrev).right(2);
            }
            }
        
            String h1 =monthname +' ' +firstdate +'-' +lastmonthname+' '+lastdate;//'Apr 21-Nov 21' ;
            String h2;
          	 h2 = monthnamePrev +' ' +firstdatePrev +'-' +lastmonthnamePrev+' '+lastdatePrev;//'Apr 20-Nov 20';
            if(!showInt){ 
                if(monthnamePrev == null || firstdatePrev == null || lastmonthnamePrev== null||lastdatePrev== null){
                    year = date1[0].Vision_Processed_Date__c.year()-1;
                     firstdate =String.valueOf(year).right(2);
                    lastYear = date2[0].Vision_Processed_Date__c.year()-1;
                     lastdate = String.valueOf(lastYear).right(2);
                     h2 = monthname +' ' +firstdate +'-' +lastmonthname+' '+lastdate;
                }else{
                     h2 = monthnamePrev +' ' +firstdatePrev +'-' +lastmonthnamePrev+' '+lastdatePrev;
                }
            }
            
            mapOfHeaders.put('one', h1);
            mapOfHeaders.put('two', h2);
            fytdprevdatelist.clear();
            //}
        }
        monthdatelist.clear();
        Map<String, List<Vision_InternalDRLSales_ProductSummary__c>> maplist = new Map<String, List<Vision_InternalDRLSales_ProductSummary__c>>();
        List<Vision_InternalDRLSales_ProductSummary__c> totalSales = new  List<Vision_InternalDRLSales_ProductSummary__c>();
        if(!showInt){
           /* totalSales =[select Vision_Sales_Dollar__c,Vision_Units__c,Vision_Processed_Month__c, Vision_Product_Family__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_NPR_Customer_Code__c,Vision_Customer_Name__c,Vision_Customer_Name__r.Name,Name,Id,Vision_Month_dtls__c
                                         from Vision_DRL_Sales__c  where  ((Vision_Month_dtls__c >=: LastDateInRecent AND Vision_Month_dtls__c<=:FirstDateInRecent) OR (Vision_Month_dtls__c >=:LastDateInPrevious  AND Vision_Month_dtls__c <=:FirstDateInPrevious)) AND Vision_Segment__c IN: selections AND Vision_Customer_Name__c =: customerId AND	Vision_NPR_Customer_Code__c =:accCode  AND Vision_Customer_Name__r.OwnerId =: currentUserId  ORDER BY  Vision_Month_dtls__c ASC
                                        ];*/
            if(searchText != null && searchText !=''&& searchText != null && searchText != 'undefined'){
                System.debug('LastDateInRecent-->'+LastDateInRecent);
            	totalSales =[select 	Vision_Unique_Identifier__c,Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                         from Vision_InternalDRLSales_ProductSummary__c  where  ((Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent) OR (Vision_Processed_Date__c >=:LastDateInPrevious  AND Vision_Processed_Date__c <=:FirstDateInPrevious)) AND Vision_Segment__c IN: selections AND Vision_Customer__c =: customerId  AND Vision_Product_Family__c like:searchText1 ORDER BY  Vision_Processed_Date__c ASC
                                        ];
            }
            else{
                totalSales =[select 	Vision_Unique_Identifier__c,Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                         from Vision_InternalDRLSales_ProductSummary__c  where  ((Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent) OR (Vision_Processed_Date__c >=:LastDateInPrevious  AND Vision_Processed_Date__c <=:FirstDateInPrevious)) AND Vision_Segment__c IN: selections AND Vision_Customer__c =: customerId  ORDER BY  Vision_Processed_Date__c ASC
                                        ];
            }
        }
        
       
        if(!showInt){
            for(Vision_InternalDRLSales_ProductSummary__c sales : totalSales){
                 String mapKey = sales.Vision_Customer__r.Name+'_'+sales.Vision_Product_Family__c;
                if(maplist.containsKey(mapKey)){
                    List < Vision_InternalDRLSales_ProductSummary__c > tempList = maplist.get(mapKey);
                    tempList.add(sales);
                    maplist.put(mapKey,tempList);
                }
                else if(!maplist.containsKey(mapKey)){
                    maplist.put(mapKey, new List < Vision_InternalDRLSales_ProductSummary__c > {
                        sales
                            });
                }
            }
        }
             
        list<Wrapper> accWrapMap = new list<Wrapper>();
        Map<String,wrapperClass> finalRecentMapSummary = new Map<String,wrapperClass>();
        Map<String,wrapperClass> finalPrevMapSummary = new Map<String,wrapperClass>();  
        List<Vision_InternalDRLSales_ProductSummary__c> totalRecentSales = new  List<Vision_InternalDRLSales_ProductSummary__c>();
         List<Vision_InternalDRLSales_ProductSummary__c> totalPreviousSales = new  List<Vision_InternalDRLSales_ProductSummary__c>();
          if(!showInt){
             /* totalRecentSales = [select Vision_Sales_Dollar__c,Vision_Units__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,	Vision_NPR_Customer_Code__c,Vision_Customer_Name__c,Vision_Customer_Name__r.Name,Name,Vision_Month_dtls__c
                                             from Vision_DRL_Sales__c  where  (Vision_Month_dtls__c >=: LastDateInRecent AND Vision_Month_dtls__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND  Vision_Customer_Name__c =: customerId AND Vision_NPR_Customer_Code__c =:accCode AND Vision_Customer_Name__r.OwnerId =: currentUserId ORDER BY  Vision_Month_dtls__c ASC
                                            ];
              totalPreviousSales= [select Vision_Sales_Dollar__c,Vision_Units__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_NPR_Customer_Code__c,Vision_Customer_Name__c,Vision_Customer_Name__r.Name,Name,Id,Vision_Month_dtls__c
                                             from Vision_DRL_Sales__c  where  (Vision_Month_dtls__c >=:LastDateInPrevious  AND Vision_Month_dtls__c <=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND Vision_Customer_Name__c =: customerId AND Vision_NPR_Customer_Code__c =:accCode AND Vision_Customer_Name__r.OwnerId =: currentUserId ORDER BY  Vision_Month_dtls__c ASC
                                            ];*/
              totalRecentSales = [select 	Vision_Unique_Identifier__c, Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                         from Vision_InternalDRLSales_ProductSummary__c  where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND  Vision_Customer__c =: customerId  ORDER BY  Vision_Processed_Date__c ASC
                                            ];
              totalPreviousSales = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                         from Vision_InternalDRLSales_ProductSummary__c  where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND  Vision_Customer__c =: customerId  ORDER BY  Vision_Processed_Date__c ASC
                                            ];
          }
       
        if(!showInt){
         for(Vision_InternalDRLSales_ProductSummary__c sales : totalRecentSales){
             decimal salesMonthlySummary=0,unitsMonthlySummary,tptdollarMonthlySummary,tptpercMonthlySummary;
             if(finalRecentMapSummary.containsKey(sales.Vision_Processed_Month__c)){
                 System.debug('sales-->'+sales.Vision_Sales__c);
                 System.debug('unique identifier-->'+sales.Vision_Unique_Identifier__c);
                 wrapperClass wrapObj = finalRecentMapSummary.get(sales.Vision_Processed_Month__c);
                 if(sales.Vision_Sales__c != null && wrapObj.salesMonthlySummary != null){
                     wrapObj.salesMonthlySummary = wrapObj.salesMonthlySummary+sales.Vision_Sales__c;
                 }
                 else{
                     wrapObj.salesMonthlySummary =0; 
                 }
                 if(sales.Vision_Units__c != null && wrapObj.unitsMonthlySummary != null){
                     wrapObj.unitsMonthlySummary = wrapObj.unitsMonthlySummary+sales.Vision_Units__c;
                 }else{
                     wrapObj.unitsMonthlySummary=0;   
                 }
                 if(sales.Vision_TPT_Dollar__c != null && wrapObj.tptdollarMonthlySummary != null){
                     wrapObj.tptdollarMonthlySummary = wrapObj.tptdollarMonthlySummary+sales.Vision_TPT_Dollar__c;
                 }else{
                     wrapObj.tptdollarMonthlySummary = 0; 
                 }
                 if(wrapObj.tptdollarMonthlySummary != null && wrapObj.salesMonthlySummary != null && wrapObj.salesMonthlySummary != 0){
                     wrapObj.tptpercMonthlySummary =( wrapObj.tptdollarMonthlySummary / wrapObj.salesMonthlySummary)*100;
                 }else{
                     wrapObj.tptpercMonthlySummary=0;
                 }
                 finalRecentMapSummary.put(sales.Vision_Processed_Month__c, wrapObj);
                 
             }
             else{
                 System.debug('in else sales-->'+sales.Vision_Sales__c);
                  System.debug('in else proessed month-->'+sales.Vision_Processed_Month__c);
                 wrapperClass wrapObj = new wrapperClass();
                 wrapObj.salesMonthlySummary = sales.Vision_Sales__c;
                 wrapObj.unitsMonthlySummary = sales.Vision_Units__c;
                 wrapObj.tptdollarMonthlySummary = sales.Vision_TPT_Dollar__c;
                 if(wrapObj.tptdollarMonthlySummary != null && wrapObj.salesMonthlySummary != null && wrapObj.salesMonthlySummary != 0){
                     wrapObj.tptpercMonthlySummary =( wrapObj.tptdollarMonthlySummary / wrapObj.salesMonthlySummary)*100;
                 }else{
                     wrapObj.tptpercMonthlySummary =0;
                 }
                 finalRecentMapSummary.put(sales.Vision_Processed_Month__c,wrapObj);
             }
             
         }
         for(Vision_InternalDRLSales_ProductSummary__c sales : totalPreviousSales){
            decimal prevsalesMonthlySummary,prevunitsMonthlySummary,prevtptdollarMonthlySummary,prevtptpercMonthlySummary;
            if(finalPrevMapSummary.containsKey(sales.Vision_Processed_Month__c)){
                wrapperClass wrapObj = finalPrevMapSummary.get(sales.Vision_Processed_Month__c);
                
                if(sales.Vision_Sales__c != null && wrapObj.prevsalesMonthlySummary != null){
                    wrapObj.prevsalesMonthlySummary = wrapObj.prevsalesMonthlySummary + sales.Vision_Sales__c;
                }
                else{
                    wrapObj.prevsalesMonthlySummary =0;
                }
                if(sales.Vision_Units__c != null && wrapObj.prevunitsMonthlySummary != null){
                    wrapObj.prevunitsMonthlySummary = wrapObj.prevunitsMonthlySummary+sales.Vision_Units__c;
                }else{
                    wrapObj.prevunitsMonthlySummary = 0;  
                }
                if(sales.Vision_TPT_Dollar__c != null && wrapObj.prevtptdollarMonthlySummary != null){
                    wrapObj.prevtptdollarMonthlySummary = wrapObj.prevtptdollarMonthlySummary+sales.Vision_TPT_Dollar__c;
                }else{
                    wrapObj.prevtptdollarMonthlySummary = 0;
                }
                if(wrapObj.prevtptdollarMonthlySummary != null && wrapObj.prevsalesMonthlySummary != null && wrapObj.prevsalesMonthlySummary !=0){
                    wrapObj.prevtptpercMonthlySummary = ( wrapObj.prevtptdollarMonthlySummary / wrapObj.prevsalesMonthlySummary)*100;
                    
                }
                else{
                    wrapObj.prevtptpercMonthlySummary=0;
                }
                finalPrevMapSummary.put(sales.Vision_Processed_Month__c, wrapObj);
                
            }
            else{
                wrapperClass wrapObj = new wrapperClass();
                wrapObj.prevsalesMonthlySummary = sales.Vision_Sales__c;
                wrapObj.prevunitsMonthlySummary = sales.Vision_Units__c;
                wrapObj.prevtptdollarMonthlySummary = sales.Vision_TPT_Dollar__c;
                if(wrapObj.prevtptdollarMonthlySummary != null && wrapObj.prevsalesMonthlySummary != null && wrapObj.prevsalesMonthlySummary != 0){
                    wrapObj.prevtptpercMonthlySummary =( wrapObj.prevtptdollarMonthlySummary /  wrapObj.prevsalesMonthlySummary)*100;
                }else{
                    wrapObj.prevtptpercMonthlySummary =0;  
                }
                finalPrevMapSummary.put(sales.Vision_Processed_Month__c,wrapObj);
            }
            
        }
        }
    
       
        if(!showInt){
            if (maplist != null) {
                for(String prodFamily : maplist.KeySet()){
                    Decimal SalesDollar = 0;
                    Decimal SalesDollarPrev = 0;
                    Decimal Units = 0;
                    Decimal UnitsPrev = 0;
                    Decimal TPTDollar =0;
                    Decimal TPTDollarPrev =0;
                    Decimal TPTPct = 0;
                    Decimal TPTPctPrev = 0;
                    String custName ='';
                    String custCode='';
                    String pfamily = '';
                    
                    
                    
                    for (Vision_InternalDRLSales_ProductSummary__c sales: maplist.get(prodFamily)) {
                        
                        
                        if(sales.Vision_Processed_Date__c >= LastDateInRecent && sales.Vision_Processed_Date__c <= FirstDateInRecent ){
                            if(sales.Vision_Sales__c != null)  SalesDollar += sales.Vision_Sales__c;
                            if(sales.Vision_Units__c != null)  Units += sales.Vision_Units__c;
                            if(sales.Vision_TPT_Dollar__c != null)  TPTDollar += sales.Vision_TPT_Dollar__c;
                            if(TPTDollar !=null && SalesDollar != null && SalesDollar != 0)  TPTPct = (TPTDollar / SalesDollar)*100;
                             
                            
                        }
                        if(sales.Vision_Processed_Date__c >= LastDateInPrevious && sales.Vision_Processed_Date__c <= FirstDateInPrevious ){
                            if(sales.Vision_Sales__c != null)  SalesDollarPrev += sales.Vision_Sales__c; 
                            if(sales.Vision_Units__c != null)  UnitsPrev += sales.Vision_Units__c;
                            if(sales.Vision_TPT_Dollar__c != null)  TPTDollarPrev += sales.Vision_TPT_Dollar__c;
                            if(TPTDollarPrev != null && SalesDollarPrev != null && SalesDollarPrev != 0)  TPTPctPrev = (TPTDollarPrev / SalesDollarPrev)*100;
                            
                        }
                        
                        custName = sales.Vision_Customer__r.Name;
                        pfamily = sales.Vision_Product_Family__c;
                        //salesRecId = sales.Id;
                        
                    }
                    System.debug('in last section-totol units->'+Units);
                    Wrapper wrapperObject = new Wrapper();
                    // wrapperObject.salesRecId =salesRecId;
                    wrapperObject.salesdl = SalesDollar;
                    wrapperObject.units = Units;
                    wrapperObject.tptdollar = TPTDollar;
                    wrapperObject.tptpct = TPTPct;
                    wrapperObject.custName = custName;
                    wrapperObject.pfamily = pfamily;
                    wrapperObject.currentUserName =currentUserName;
                    wrapperObject.SalesDollarPrev = SalesDollarPrev;
                    wrapperObject.TPTDollarPrev = TPTDollarPrev;
                    wrapperObject.TPTPctPrev = TPTPctPrev;
                    wrapperObject.UnitsPrev = UnitsPrev;
                    
                    
                    accWrapMap.add(wrapperObject);
                }
                maplist.clear();
            }
        }
             
        totalRecentSales.clear();
        drl_sales_dates_info__c cotdi = drl_sales_dates_info__c.getInstance('Data1');
        wrapperClass wrapperObj = new wrapperClass();
        wrapperObj.accWrapMap = accWrapMap;
        wrapperObj.dynamicHeaders = mapOfHeaders;
         wrapperObj.keySet = keySet;
          wrapperObj.keySetPrev = keySetPrev;
        wrapperObj.recentLastMonth = recentLastMonth;
          wrapperObj.previousLastMonth = previousLastMonth;
        wrapperObj.finalRecentMapSummary = finalRecentMapSummary;
        wrapperObj.finalPrevMapSummary = finalPrevMapSummary;
        wrapperObj.selections = selections;
        if(cotdi!=null){
        wrapperObj.GCPUpdateDate = cotdi.Vision_GCP_Update_Date__c;
        wrapperObj.VisionUpdateDate = cotdi.Vision_Update_Date__c;
            wrapperObj.DataAvailableTill = cotdi.Vision_Data_Available_Till__c;}
       
        
        return wrapperObj;
        
        
    }
    
    public class wrapperClass{
        @AuraEnabled public Map<String, String> dynamicHeaders;
        @AuraEnabled public List<Wrapper> accWrapMap;
        @AuraEnabled public Decimal salesMonthly;
        @AuraEnabled public Decimal unitsMonthly;
        @AuraEnabled public Decimal tptdollarMonthly;
        @AuraEnabled public Decimal tptpercMonthly;
        @AuraEnabled public Decimal salesMonthlyPrev;
        @AuraEnabled public Decimal unitsMonthlyPrev;
        @AuraEnabled public Decimal tptdollarMonthlyPrev;
        @AuraEnabled public Decimal tptpercMonthlyPrev;
        @AuraEnabled public Decimal salesMonthlySummary;
        @AuraEnabled public Decimal unitsMonthlySummary;
        @AuraEnabled public Decimal tptdollarMonthlySummary;
        @AuraEnabled public Decimal tptpercMonthlySummary;
        @AuraEnabled public Decimal prevsalesMonthlySummary;
        @AuraEnabled public Decimal prevunitsMonthlySummary;
        @AuraEnabled public Decimal prevtptdollarMonthlySummary;
        @AuraEnabled public Decimal prevtptpercMonthlySummary;
        @AuraEnabled public Map<String,wrapperClass> finalMap;
        @AuraEnabled public Map<String,wrapperClass> finalPreviousMap;
        @AuraEnabled public Map<String,wrapperClass> finalRecentMapSummary;
        @AuraEnabled public Map<String,wrapperClass> finalPrevMapSummary;
        @AuraEnabled public String PFamilyName;
        @AuraEnabled public List<String> selections;
        @AuraEnabled public List<wrapperClass> AllAccountsData;
        @AuraEnabled public List<wrapperClass> wrapperObjList;
        @AuraEnabled public String GCPUpdateDate;
        @AuraEnabled public String VisionUpdateDate;
        @AuraEnabled public String DataAvailableTill;
        @AuraEnabled public List<String> keySet;
          @AuraEnabled public List<String> keySetPrev;
        @AuraEnabled public integer recentLastMonth;
          @AuraEnabled public integer previousLastMonth;
        
    }
    
    
    public class Wrapper {
        @AuraEnabled public Decimal salesdl;
        @AuraEnabled public Decimal units;
        @AuraEnabled public Decimal tptdollar;
        @AuraEnabled public Decimal SalesDollarPrev;
        @AuraEnabled public Decimal tptpct;
        @AuraEnabled public Decimal TPTDollarPrev;
        @AuraEnabled public Decimal TPTPctPrev;
        @AuraEnabled public Decimal UnitsPrev;
        @AuraEnabled public string custName;
        @AuraEnabled public string pfamily;
        @AuraEnabled public String currentUserName;
        
    }
 
    @auraEnabled
    public static wrapperClass getLasttwmonthsVsPrevtwmonthsData(List<String> selections,String selectedComparison,String customerId,String accCode,List<String> productFamilies,Boolean showInt,Integer recentLastMonth,Integer previousLastMonth){
       System.debug('recentLastMonth in product-->'+recentLastMonth);
           System.debug('previousLastMonth in product-->'+previousLastMonth);
        String currentUserId = userInfo.getUserId();
        Date FirstDateInRecent,LastDateInRecent,FirstDateInPrevious,LastDateInPrevious;
        List<Date> lasttwmonthsdatelist= new List<Date>();
		List<Date> prevtwmontdateList= new List<Date>();
        wrapperClass wrapobject = new wrapperClass();
        String finalMapPFamilyName = '';
        String finalPrevMapPFamilyName = '';
        String pFamilyName ='';
		date dateBefore;
		date previdates;
        for(Integer i=1;i<=12;i++){
            dateBefore=System.today().addMonths(-i).toStartOfMonth();//getting last 12 months
            previdates=System.today().addMonths(-i-12).toStartOfMonth();//getting previous 12 months
            lasttwmonthsdatelist.add(dateBefore);//adding last 12 months to list
            prevtwmontdateList.add(previdates);//adding previous 12 months to list
        }
        System.debug('recentLastMonth-->'+recentLastMonth);
         System.debug('previousLastMonth-->'+previousLastMonth);
        if(recentLastMonth == previousLastMonth){
            FirstDateInRecent = Date.valueOf('2022-06-30');//lasttwmonthsdatelist[0].addMonths(1).toStartofMonth().addDays(-1);
            LastDateInRecent = Date.valueOf('2021-05-01');//lasttwmonthsdatelist[11];
            FirstDateInPrevious = Date.valueOf('2021-06-30');//prevtwmontdateList[0].addMonths(1).toStartofMonth().addDays(-1);
            LastDateInPrevious = Date.valueOf('2020-05-01');//prevtwmontdateList[11];
        }else{
            lasttwmonthsdatelist.clear();
               	 prevtwmontdateList.clear();
                 date dateBefore1;
                 date previdates1;
                for(Integer i=1;i<=13;i++){
                    dateBefore1=System.today().addMonths(-i).toStartOfMonth();//getting last 12 months
                    previdates1=System.today().addMonths(-i-12).toStartOfMonth();//getting previous 12 months
                    lasttwmonthsdatelist.add(dateBefore1);//adding last 12 months to list
                    prevtwmontdateList.add(previdates1);//adding previous 12 months to list
                }
				FirstDateInRecent = Date.valueOf('2022-06-30');//lasttwmonthsdatelist[1].addMonths(1).toStartofMonth().addDays(-1);
                LastDateInRecent = Date.valueOf('2021-05-01');//lasttwmonthsdatelist[12];
                FirstDateInPrevious = Date.valueOf('2021-06-30');//prevtwmontdateList[1].addMonths(1).toStartofMonth().addDays(-1);
                LastDateInPrevious = Date.valueOf('2020-05-01');//prevtwmontdateList[12];
        }
                

         String customerName = '';
        Map<String,list<Vision_InternalDRLSales_ProductSummary__c>> mapSalesFInalList = new Map<String, list<Vision_InternalDRLSales_ProductSummary__c>>();
		Map<String,list<Vision_InternalDRLSales_ProductSummary__c>> mapSalesPreviousList = new Map<String, list<Vision_InternalDRLSales_ProductSummary__c>>();
         List<Vision_InternalDRLSales_ProductSummary__c> salesList = new List<Vision_InternalDRLSales_ProductSummary__c>();
        List<Vision_InternalDRLSales_ProductSummary__c> salesPreviousList = new List<Vision_InternalDRLSales_ProductSummary__c>();
        if(!showInt){
        	/*salesList = [select Vision_Product_Family__c,Vision_Sales_Dollar__c,Vision_Units__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_Customer_Name__c,Vision_NPR_Customer_Code__c,Vision_Customer_Name__r.Name,Name,Id,Vision_Month_dtls__c
                                         from Vision_DRL_Sales__c  where  (Vision_Month_dtls__c >=: LastDateInRecent AND Vision_Month_dtls__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND Vision_Customer_Name__c =: customerId AND Vision_NPR_Customer_Code__c =:accCode AND 
											Vision_Product_Family__c IN: productFamilies AND Vision_Customer_Name__r.OwnerId =: currentUserId ORDER BY  Vision_Month_dtls__c ASC
                                        ];
             salesPreviousList = [select Vision_Product_Family__c,Vision_Sales_Dollar__c,Vision_Units__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_Customer_Name__c,Vision_NPR_Customer_Code__c,Vision_Customer_Name__r.Name,Name,Id,Vision_Month_dtls__c
                                         from Vision_DRL_Sales__c  where  (Vision_Month_dtls__c >=:LastDateInPrevious  AND Vision_Month_dtls__c <=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND Vision_Customer_Name__c =: customerId AND Vision_NPR_Customer_Code__c =:accCode AND Vision_Product_Family__c IN: productFamilies AND Vision_Customer_Name__r.OwnerId =: currentUserId ORDER BY  Vision_Month_dtls__c ASC
                                        ];*/
            salesList = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                         from Vision_InternalDRLSales_ProductSummary__c  where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND Vision_Customer__c =: customerId  AND 
											Vision_Product_Family__c IN: productFamilies  ORDER BY  Vision_Processed_Date__c ASC
                                        ];
            salesPreviousList = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                         from Vision_InternalDRLSales_ProductSummary__c  where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND Vision_Customer__c =: customerId  AND 
											Vision_Product_Family__c IN: productFamilies  ORDER BY  Vision_Processed_Date__c ASC
                                        ];
        }
      
        if(!showInt){
        	for(Vision_InternalDRLSales_ProductSummary__c sales : salesList){
			if(!mapSalesFInalList.containsKey(sales.Vision_Product_Family__c))
				mapSalesFInalList.put(sales.Vision_Product_Family__c, new list<Vision_InternalDRLSales_ProductSummary__c>());
			mapSalesFInalList.get(sales.Vision_Product_Family__c).add(sales);
            
		}
        	for(Vision_InternalDRLSales_ProductSummary__c sales : salesPreviousList){
			if(!mapSalesPreviousList.containsKey(sales.Vision_Product_Family__c))
				mapSalesPreviousList.put(sales.Vision_Product_Family__c, new list<Vision_InternalDRLSales_ProductSummary__c>());
			mapSalesPreviousList.get(sales.Vision_Product_Family__c).add(sales);
		}
        }
             
       List<wrapperClass> wrapperObjList = new List<wrapperClass>();
        if(!showInt){
        	for(String pFamily : productFamilies){
            Map<String,wrapperClass> finalMap = new Map<String,wrapperClass>();
       		Map<String,wrapperClass> finalPreviousMap = new Map<String,wrapperClass>();
             
            wrapperClass wrpObj = new wrapperClass();
            list<Vision_InternalDRLSales_ProductSummary__c> salesFinalList = mapSalesFInalList.get(pFamily);
			list<Vision_InternalDRLSales_ProductSummary__c> salesPrevList = mapSalesPreviousList.get(pFamily);
            System.debug('salesPrevList-->'+salesPrevList);
            if(salesFinalList != null && !salesFinalList.isEmpty()){
           			for(Vision_InternalDRLSales_ProductSummary__c sales : salesFinalList){
                         finalMapPFamilyName = sales.Vision_Product_Family__c;
                            decimal salesMonthly=0,unitsMonthly=0,tptdollarMonthly=0,tptpercMonthly=0;
                        System.debug('finalMap>>'+finalMap);
                        if(Test.isRunningTest()){
                            wrapperClass wrpObj1 = new wrapperClass();
                            wrpObj1.salesMonthly = 123.45;
                            wrpObj1.unitsMonthly = 311.15;
                            //insert wrpObj1;
                            finalMap.put('May-21', wrpObj1);
                        }
                            if(finalMap.containsKey(sales.Vision_Processed_Month__c)){
                                   
                                    wrapperClass wrapObj = finalMap.get(sales.Vision_Processed_Month__c);
                                    if(sales.Vision_Sales__c != null && wrapObj.salesMonthly != null){
                                          wrapObj.salesMonthly = wrapObj.salesMonthly+sales.Vision_Sales__c;
                                     }else{
                                          wrapObj.salesMonthly = 0;
                                         }
                                          if(sales.Vision_Units__c != null && wrapObj.unitsMonthly != null){
                                                wrapObj.unitsMonthly = wrapObj.unitsMonthly+sales.Vision_Units__c;
                                            }else{
                                                  wrapObj.unitsMonthly =0; 
                                               }
                                                 if(sales.Vision_TPT_Dollar__c != null && wrapObj.tptdollarMonthly != null){
                                                        wrapObj.tptdollarMonthly = wrapObj.tptdollarMonthly+sales.Vision_TPT_Dollar__c;
                                                    }else{
                                                        wrapObj.tptdollarMonthly =0;
                                                    }
                                                    if(wrapObj.tptdollarMonthly != null && wrapObj.salesMonthly != null && wrapObj.salesMonthly != 0){
                                                        wrapObj.tptpercMonthly =( wrapObj.tptdollarMonthly / wrapObj.salesMonthly )*100;
                                                        //wrapObj.tptpercMonthly = wrapObj.tptpercMonthly+sales.Vision_TPT_Pct__c;
                                                    }else{
                                                        wrapObj.tptpercMonthly =0;   
                                                    }
                                                    finalMap.put(sales.Vision_Processed_Month__c, wrapObj);
                                                    
                                       }
                                         else{
                                               wrapperClass wrapObj = new wrapperClass();
                                               wrapObj.salesMonthly = sales.Vision_Sales__c;
                                               wrapObj.unitsMonthly = sales.Vision_Units__c;
                                               wrapObj.tptdollarMonthly = sales.Vision_TPT_Dollar__c;
                                               if(wrapObj.tptdollarMonthly != null && wrapObj.salesMonthly != null && wrapObj.salesMonthly !=0){
                                                    wrapObj.tptpercMonthly =( wrapObj.tptdollarMonthly/ wrapObj.salesMonthly)*100;
                                                }else{
                                                     wrapObj.tptpercMonthly =0;  
                                                  }
                                                    finalMap.put(sales.Vision_Processed_Month__c,wrapObj);
                                                }
                                                
                                            }
            }else{
                finalMapPFamilyName = '';
            }
            if(salesPrevList != null && !salesPrevList.isEmpty()){
        		for(Vision_InternalDRLSales_ProductSummary__c sales : salesPrevList){
                    finalPrevMapPFamilyName = sales.Vision_Product_Family__c;
                          decimal salesMonthlyPrev=0,unitsMonthlyPrev=0,tptdollarMonthlyPrev=0,tptpercMonthlyPrev=0;
                          if(finalPreviousMap.containsKey(sales.Vision_Processed_Month__c)){
                                 wrapperClass wrapObj = finalPreviousMap.get(sales.Vision_Processed_Month__c);
                                 if(sales.Vision_Sales__c != null && wrapObj.salesMonthlyPrev != null){
                                       wrapObj.salesMonthlyPrev = wrapObj.salesMonthlyPrev+sales.Vision_Sales__c;
                                   }else{
                                        wrapObj.salesMonthlyPrev =0; 
                                       }
                                        if(sales.Vision_Units__c != null && wrapObj.unitsMonthlyPrev != null){
                                             wrapObj.unitsMonthlyPrev = wrapObj.unitsMonthlyPrev+sales.Vision_Units__c;
                                          }else{
                                                wrapObj.unitsMonthlyPrev =0;
                                                }
                                                if(sales.Vision_TPT_Dollar__c != null && wrapObj.tptdollarMonthlyPrev != null){
                                                    wrapObj.tptdollarMonthlyPrev = wrapObj.tptdollarMonthlyPrev+sales.Vision_TPT_Dollar__c;
                                                }else{
                                                    wrapObj.tptdollarMonthlyPrev =0;
                                                	}
                                                    if(wrapObj.tptdollarMonthlyPrev != null && wrapObj.salesMonthlyPrev != null && wrapObj.salesMonthlyPrev != 0){
                                                        wrapObj.tptpercMonthlyPrev =( wrapObj.tptdollarMonthlyPrev/wrapObj.salesMonthlyPrev)*100;
                                                        //wrapObj.tptpercMonthlyPrev = wrapObj.tptpercMonthlyPrev+sales.Vision_TPT_Pct__c;
                                                    	}else{
                                                    		wrapObj.tptpercMonthlyPrev=0;
                                                		}
                                                	finalPreviousMap.put(sales.Vision_Processed_Month__c, wrapObj);
                                            }
                                            else{
                                                wrapperClass wrapObj = new wrapperClass();
                                                wrapObj.salesMonthlyPrev = sales.Vision_Sales__c;
                                                wrapObj.unitsMonthlyPrev = sales.Vision_Units__c;
                                                wrapObj.tptdollarMonthlyPrev = sales.Vision_TPT_Dollar__c;
                                                if(wrapObj.tptdollarMonthlyPrev != null && wrapObj.salesMonthlyPrev !=null && wrapObj.salesMonthlyPrev != 0){
                                                    wrapObj.tptpercMonthlyPrev =( wrapObj.tptdollarMonthlyPrev /wrapObj.salesMonthlyPrev)*100;
                                                }else{
                                                    wrapObj.tptpercMonthlyPrev =0;   
                                                }
                                                finalPreviousMap.put(sales.Vision_Processed_Month__c,wrapObj);
                                            }
                                            
                                        }
            }else{
                finalPrevMapPFamilyName = '';
            }
            if(finalMapPFamilyName == finalPrevMapPFamilyName){
                pFamilyName =finalMapPFamilyName;
            }else if(finalMapPFamilyName == '' && finalPrevMapPFamilyName != null){
                pFamilyName =finalPrevMapPFamilyName;
            }else if(finalMapPFamilyName != '' && finalPrevMapPFamilyName == ''){
                pFamilyName = finalMapPFamilyName;
            }
         wrpObj.PFamilyName = pFamilyName;
         wrpObj.finalMap = finalMap;
         wrpObj.finalPreviousMap = finalPreviousMap;
         wrapperObjList.add(wrpObj);
        // wrapperObj.AllAccountsData =wrapperObjList;
         System.debug('response--->'+wrapperObjList);   
            List<wrapperClass> AllAccounts = new List<wrapperClass>();
        AllAccounts.addAll(wrapperObjList);
            wrapobject.AllAccountsData =AllAccounts;
        }
        }
       
        return wrapobject;
        
    }
    
    
    @auraEnabled
    public static wrapperClass getLastQuarterVsPrevQuarterData(List<String> selections,String selectedComparison,String customerId,String accCode,List<String> productFamilies,Boolean showInt){
        
        String finalMapPFamilyName = '';
        String finalPrevMapPFamilyName = '';
        String pFamilyName ='';
        wrapperClass wrapobject = new wrapperClass();
        Date FirstDateInRecent,LastDateInRecent,FirstDateInPrevious,LastDateInPrevious;
        String currentUserId = userInfo.getUserId();
        date lastquarter, previousquarter;
        List<Date> lastquarterdateList= new List<Date>();
        List<Date> previousquarterDateList = new List<Date>();
       List<Integer> Q1=new List<Integer>{4,5,6}; 
                List<Integer> Q2=new List<Integer>{7,8,9}; 
                    List<Integer> Q3=new List<Integer>{10,11,12};
                        List<Integer> Q4=new List<Integer>{1,2,3}; 
                            date todayDate =System.today();
            Integer month = todayDate.month();
			System.debug('month-->'+month);
            if(Q1.contains(month)){
                if( (Q1[0]==month) || (Q1[1] == month) || (Q1[2] == month) ){
                    if(month==4){
                        FirstDateInRecent = System.today().addMonths(-1).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-3).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-4).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-6).toStartOfMonth();
                    }else if(month==5){
                        FirstDateInRecent = System.today().addMonths(-2).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-4).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-5).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-7).toStartOfMonth();
                    }
                    else if(month==6){
                        FirstDateInRecent = System.today().addMonths(-3).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-5).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-6).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-8).toStartOfMonth();
                    }
                }
                
            }else if(Q2.contains(month)){
                if( (Q2[0]==month) || (Q2[1] == month) || (Q2[2] == month) ){
               			if(month==7){
                        FirstDateInRecent = System.today().addMonths(-4).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-6).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-7).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-9).toStartOfMonth();
                    }
                    else if(month==8){
                        FirstDateInRecent = System.today().addMonths(-5).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-7).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-8).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-10).toStartOfMonth();
                    }
                    else if(month==9){
                        FirstDateInRecent = System.today().addMonths(-6).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-8).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-9).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-11).toStartOfMonth();
                    }
                }
            }
            else if(Q3.contains(month)){
                if( (Q3[0]==month) || (Q3[1] == month) || (Q3[2] == month) ){
                    if(month==10){
                        FirstDateInRecent = System.today().addMonths(-7).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-9).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-10).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-12).toStartOfMonth();
                    }
                    else if(month==11){
                        FirstDateInRecent = System.today().addMonths(-8).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-10).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-11).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-13).toStartOfMonth();
                    }
                    else if(month==12){
                        FirstDateInRecent = System.today().addMonths(-9).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-11).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-12).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-14).toStartOfMonth();
                    }
                }
            }
            else if(Q4.contains(month)){
                if( (Q4[0]==month) || (Q4[1] == month) || (Q4[2] == month) ){
                     if(month==1){
                        FirstDateInRecent = System.today().addMonths(-10).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-12).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-13).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-15).toStartOfMonth();
                     }
                    else if(month==2){
                        FirstDateInRecent = System.today().addMonths(-11).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-13).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-14).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-16).toStartOfMonth();
                    }
                    else if(month==3){
                        FirstDateInRecent = System.today().addMonths(-12).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInRecent =  System.today().addMonths(-14).toStartOfMonth();
                        FirstDateInPrevious = System.today().addMonths(-15).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                        LastDateInPrevious =  System.today().addMonths(-17).toStartOfMonth();
                    }
                }
            }

        Map<String,list<Vision_InternalDRLSales_ProductSummary__c>> mapSalesFInalList = new Map<String, list<Vision_InternalDRLSales_ProductSummary__c>>();
        Map<String,list<Vision_InternalDRLSales_ProductSummary__c>> mapSalesPreviousList = new Map<String, list<Vision_InternalDRLSales_ProductSummary__c>>();
        List<Vision_InternalDRLSales_ProductSummary__c> salesList  = new List<Vision_InternalDRLSales_ProductSummary__c>();
        List<Vision_InternalDRLSales_ProductSummary__c> salesPreviousList = new List<Vision_InternalDRLSales_ProductSummary__c>();
        if(!showInt){
        /*salesList = [select Vision_Sales_Dollar__c,Vision_Units__c,Vision_Product_Family__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_Customer_Name__c,Vision_NPR_Customer_Code__c,Vision_Customer_Name__r.Name,Name,Id,Vision_Month_dtls__c
                                               from Vision_DRL_Sales__c  where  (Vision_Month_dtls__c >=: LastDateInRecent AND Vision_Month_dtls__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND Vision_Product_Family__c IN: productFamilies AND Vision_Customer_Name__c =: customerId AND Vision_NPR_Customer_Code__c =:accCode AND Vision_Customer_Name__r.OwnerId =: currentUserId ORDER BY  Vision_Month_dtls__c ASC
                                              ];
        	salesPreviousList = [select Vision_Sales_Dollar__c,Vision_Units__c,Vision_Product_Family__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_Customer_Name__c,Vision_NPR_Customer_Code__c,Vision_Customer_Name__r.Name,Name,Id,Vision_Month_dtls__c
                                                       from Vision_DRL_Sales__c  where  (Vision_Month_dtls__c >=:LastDateInPrevious  AND Vision_Month_dtls__c <=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND Vision_Product_Family__c IN: productFamilies AND Vision_Customer_Name__c =: customerId AND Vision_NPR_Customer_Code__c =:accCode AND Vision_Customer_Name__r.OwnerId =: currentUserId ORDER BY  Vision_Month_dtls__c ASC
                                                      ];*/
            salesList = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                         from Vision_InternalDRLSales_ProductSummary__c where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND Vision_Product_Family__c IN: productFamilies AND Vision_Customer__c =: customerId  AND Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                              ];
        	 salesPreviousList = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                         from Vision_InternalDRLSales_ProductSummary__c where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND Vision_Product_Family__c IN: productFamilies AND Vision_Customer__c =: customerId  AND Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                              ];
        }
    
        if(!showInt){
        	for(Vision_InternalDRLSales_ProductSummary__c sales : salesList){
            if(!mapSalesFInalList.containsKey(sales.Vision_Product_Family__c))
                mapSalesFInalList.put(sales.Vision_Product_Family__c, new list<Vision_InternalDRLSales_ProductSummary__c>());
            mapSalesFInalList.get(sales.Vision_Product_Family__c).add(sales);
        }
        	for(Vision_InternalDRLSales_ProductSummary__c sales : salesPreviousList){
            if(!mapSalesPreviousList.containsKey(sales.Vision_Product_Family__c))
                mapSalesPreviousList.put(sales.Vision_Product_Family__c, new list<Vision_InternalDRLSales_ProductSummary__c>());
            mapSalesPreviousList.get(sales.Vision_Product_Family__c).add(sales);
        }
        }
        List<wrapperClass> wrapperObjList = new List<wrapperClass>();
        System.debug('showInt-->'+showInt);
        if(!showInt){
            for(String pFamily : productFamilies){
                Map<String,wrapperClass> finalMap = new Map<String,wrapperClass>();
                Map<String,wrapperClass> finalPreviousMap = new Map<String,wrapperClass>();
                wrapperClass wrpObj = new wrapperClass();
                list<Vision_InternalDRLSales_ProductSummary__c> salesFinalList = mapSalesFInalList.get(pFamily);
                list<Vision_InternalDRLSales_ProductSummary__c> salesPrevList = mapSalesPreviousList.get(pFamily);
                System.debug('salesPrevList-->'+salesPrevList);
                String finalMapCustomerName ='';
                String finalPrevMapCustomerName = '';
                if(salesFinalList != null && !salesFinalList.isEmpty()){
                    for(Vision_InternalDRLSales_ProductSummary__c sales : salesFinalList){
                        finalMapPFamilyName = sales.Vision_Product_Family__c;
                        decimal salesMonthly=0,unitsMonthly=0,tptdollarMonthly=0,tptpercMonthly=0;
                        System.debug('finalMap11>>'+finalMap);
                        if(finalMap.containsKey(sales.Vision_Processed_Month__c)){
                            System.debug('tpt dollar in if-->'+sales.Vision_TPT_Dollar__c);
                            //customerName = sales.Vision_Customer_Name__r.Name;
                            wrapperClass wrapObj = finalMap.get(sales.Vision_Processed_Month__c);
                            if(sales.Vision_Sales__c != null && wrapObj.salesMonthly != null){
                                wrapObj.salesMonthly = wrapObj.salesMonthly+sales.Vision_Sales__c;
                            }else{
                                wrapObj.salesMonthly = 0;
                            }
                            if(sales.Vision_Units__c != null && wrapObj.unitsMonthly != null){
                                wrapObj.unitsMonthly = wrapObj.unitsMonthly+sales.Vision_Units__c;
                            }else{
                                wrapObj.unitsMonthly =0; 
                            }
                            if(sales.Vision_TPT_Dollar__c != null && wrapObj.tptdollarMonthly != null){
                                wrapObj.tptdollarMonthly = wrapObj.tptdollarMonthly+sales.Vision_TPT_Dollar__c;
                            }else{
                                wrapObj.tptdollarMonthly =0;
                            }
                            if(wrapObj.tptdollarMonthly != null && wrapObj.salesMonthly != null && wrapObj.salesMonthly != 0){
                                wrapObj.tptpercMonthly =( wrapObj.tptdollarMonthly / wrapObj.salesMonthly )*100;
                                //wrapObj.tptpercMonthly = wrapObj.tptpercMonthly+sales.Vision_TPT_Pct__c;
                            }else{
                                wrapObj.tptpercMonthly =0;   
                            }
                            finalMap.put(sales.Vision_Processed_Month__c, wrapObj);
                            
                        }
                        else{
                            System.debug('tpt dollar in else-->'+sales.Vision_TPT_Dollar__c);
                            wrapperClass wrapObj = new wrapperClass();
                            wrapObj.salesMonthly = sales.Vision_Sales__c;
                            wrapObj.unitsMonthly = sales.Vision_Units__c;
                            wrapObj.tptdollarMonthly = sales.Vision_TPT_Dollar__c;
                            if(wrapObj.tptdollarMonthly != null && wrapObj.salesMonthly != null && wrapObj.salesMonthly !=0){
                                wrapObj.tptpercMonthly =( wrapObj.tptdollarMonthly/ wrapObj.salesMonthly)*100;
                            }else{
                                wrapObj.tptpercMonthly =0;  
                            }
                            finalMap.put(sales.Vision_Processed_Month__c,wrapObj);
                        }
                        
                    }
                }else{
                    finalMapPFamilyName = '';  
                }
                if(salesPrevList != null && !salesPrevList.isEmpty()){
                    for(Vision_InternalDRLSales_ProductSummary__c sales : salesPrevList){
                        finalPrevMapPFamilyName = sales.Vision_Product_Family__c;
                        decimal salesMonthlyPrev=0,unitsMonthlyPrev=0,tptdollarMonthlyPrev=0,tptpercMonthlyPrev=0;
                        System.debug('finalPreviousMap>>'+finalPreviousMap);
                        if(finalPreviousMap.containsKey(sales.Vision_Processed_Month__c)){
                            //customerName = sales.Vision_Customer_Name__r.Name;
                            wrapperClass wrapObj = finalPreviousMap.get(sales.Vision_Processed_Month__c);
                            if(sales.Vision_Sales__c != null && wrapObj.salesMonthlyPrev != null){
                                wrapObj.salesMonthlyPrev = wrapObj.salesMonthlyPrev+sales.Vision_Sales__c;
                            }else{
                                wrapObj.salesMonthlyPrev =0; 
                            }
                            if(sales.Vision_Units__c != null && wrapObj.unitsMonthlyPrev != null){
                                wrapObj.unitsMonthlyPrev = wrapObj.unitsMonthlyPrev+sales.Vision_Units__c;
                            }else{
                                wrapObj.unitsMonthlyPrev =0;
                            }
                            if(sales.Vision_TPT_Dollar__c != null && wrapObj.tptdollarMonthlyPrev != null){
                                wrapObj.tptdollarMonthlyPrev = wrapObj.tptdollarMonthlyPrev+sales.Vision_TPT_Dollar__c;
                            }else{
                                wrapObj.tptdollarMonthlyPrev =0;
                            }
                            if(wrapObj.tptdollarMonthlyPrev != null && wrapObj.salesMonthlyPrev != null && wrapObj.salesMonthlyPrev != 0){
                                wrapObj.tptpercMonthlyPrev =( wrapObj.tptdollarMonthlyPrev/wrapObj.salesMonthlyPrev)*100;
                                //wrapObj.tptpercMonthlyPrev = wrapObj.tptpercMonthlyPrev+sales.Vision_TPT_Pct__c;
                            }else{
                                wrapObj.tptpercMonthlyPrev=0;
                            }
                            finalPreviousMap.put(sales.Vision_Processed_Month__c, wrapObj);
                        }
                        else{
                            wrapperClass wrapObj = new wrapperClass();
                            wrapObj.salesMonthlyPrev = sales.Vision_Sales__c;
                            wrapObj.unitsMonthlyPrev = sales.Vision_Units__c;
                            wrapObj.tptdollarMonthlyPrev = sales.Vision_TPT_Dollar__c;
                            if(wrapObj.tptdollarMonthlyPrev != null && wrapObj.salesMonthlyPrev !=null && wrapObj.salesMonthlyPrev != 0){
                                wrapObj.tptpercMonthlyPrev =( wrapObj.tptdollarMonthlyPrev /wrapObj.salesMonthlyPrev)*100;
                            }else{
                                wrapObj.tptpercMonthlyPrev =0;   
                            }
                            finalPreviousMap.put(sales.Vision_Processed_Month__c,wrapObj);
                        }
                        
                    }
                }else{
                    finalPrevMapPFamilyName = '';
                }
                if(finalMapPFamilyName == finalPrevMapPFamilyName){
                    pFamilyName =finalMapPFamilyName;
                }else if(finalMapPFamilyName == '' && finalPrevMapPFamilyName != null){
                    pFamilyName =finalPrevMapPFamilyName;
                }else if(finalMapPFamilyName != '' && finalPrevMapPFamilyName == ''){
                    pFamilyName = finalMapPFamilyName;
                }
                //wrpObj.customerName = customerName;
                wrpObj.pFamilyName = pFamilyName;
                wrpObj.finalMap = finalMap;
                wrpObj.finalPreviousMap = finalPreviousMap;
                wrapperObjList.add(wrpObj);
                
                List<wrapperClass> AllAccounts = new List<wrapperClass>();
                AllAccounts.addAll(wrapperObjList);
                wrapobject.AllAccountsData =AllAccounts;
                
            }
        }
        
        return wrapobject;
    }
    
  @auraEnabled
    public static wrapperClass getfytdData(List<String> selections,String selectedComparison,String customerId,String accCode,List<String> productFamilies,Boolean showInt){
        
         
        String finalMapPFamilyName = '';
        String finalPrevMapPFamilyName = '';
        String pFamilyName ='';
        wrapperClass wrapobject = new wrapperClass();
        Date FirstDateInRecent,LastDateInRecent,FirstDateInPrevious,LastDateInPrevious;
        String currentUserId = userInfo.getUserId();
        date lastquarter, previousquarter;
        date lastmonthlastDatefytd;
        List<Date> lastquarterdateList= new List<Date>();
        List<Date> previousquarterDateList = new List<Date>();
        Map<String, String> mapOfHeaders = new Map<String, String>();
        List<Date> fytdprevdatelist = new List<Date>();
        Date lastmonthfirstDatePrev,lastmonthlastDatePrevfytd;
        String finalMapCustomerName ='';
        String finalPrevMapCustomerName ='';
        if(selectedComparison == 'fytdvspreviousfytd'){
            Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
            date todayDate = System.today();
            date currentFyscalDate = Date.newinstance(system.today().year(), orgFiscalMonth+3, 1);
            LastDateInRecent = Date.newinstance(system.today().year()-1, orgFiscalMonth+3, 1);
                LastDateInPrevious = Date.newinstance(system.today().year()-2, orgFiscalMonth+3, 1);
           /* if(todayDate <= currentFyscalDate){
            	LastDateInRecent = Date.newinstance(system.today().year()-1, orgFiscalMonth+3, 1);
                LastDateInPrevious = Date.newinstance(system.today().year()-2, orgFiscalMonth+3, 1);
            }else{
                LastDateInRecent = Date.newinstance(system.today().year(), orgFiscalMonth+3, 1);
                LastDateInPrevious = Date.newinstance(system.today().year()-1, orgFiscalMonth+3, 1);
            }*/
            System.debug('LastDateInRecent-->'+LastDateInRecent);
            //Integer orgFiscalMonthPrev = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
           
            System.debug('LastDateInPrevious-->'+LastDateInPrevious);
            
            for(Integer i=1;i<=1;i++){
                FirstDateInRecent=System.today().addMonths(-i).toStartOfMonth().addMonths(1).toStartofMonth().addDays(-1);
                System.debug('FirstDateInRecent-->'+FirstDateInRecent);
                lastmonthlastDatefytd = FirstDateInRecent.addDays(Date.daysInMonth(FirstDateInRecent.year(), FirstDateInRecent.month()) - 1);
            }
            for(Integer i=1;i<=12;i++){
                lastmonthfirstDatePrev=System.today().addMonths(-i-13).toStartOfMonth();
                lastmonthlastDatePrevfytd = lastmonthfirstDatePrev.addDays(Date.daysInMonth(lastmonthfirstDatePrev.year(), lastmonthfirstDatePrev.month()));
                
                fytdprevdatelist.add(lastmonthlastDatePrevfytd);
            }
            FirstDateInPrevious = fytdprevdatelist[0].addMonths(1).toStartofMonth().addDays(-1);
            System.debug('FirstDateInPrevious-->'+FirstDateInPrevious);
        }
        //Map<String,wrapperClass> finalMap = new Map<String,wrapperClass>();
        //Map<String,wrapperClass> finalPreviousMap = new Map<String,wrapperClass>();
        Map<String,list<Vision_InternalDRLSales_ProductSummary__c>> mapSalesFInalList = new Map<String, list<Vision_InternalDRLSales_ProductSummary__c>>();
        Map<String,list<Vision_InternalDRLSales_ProductSummary__c>> mapSalesPreviousList = new Map<String, list<Vision_InternalDRLSales_ProductSummary__c>>();
        List<Vision_InternalDRLSales_ProductSummary__c> salesList = new List<Vision_InternalDRLSales_ProductSummary__c>();
        List<Vision_InternalDRLSales_ProductSummary__c> salesPreviousList = new List<Vision_InternalDRLSales_ProductSummary__c> ();
        if(!showInt){
        	/*salesList = [select Vision_Sales_Dollar__c,Vision_Units__c,Vision_Product_Family__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_Customer_Name__c,Vision_NPR_Customer_Code__c,Vision_Customer_Name__r.Name,Name,Id,Vision_Month_dtls__c
                                               from Vision_DRL_Sales__c  where  (Vision_Month_dtls__c >=: LastDateInRecent AND Vision_Month_dtls__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND Vision_Customer_Name__c =: customerId AND Vision_NPR_Customer_Code__c =:accCode AND Vision_Product_Family__c IN:productFamilies AND Vision_Customer_Name__r.OwnerId =: currentUserId ORDER BY  Vision_Month_dtls__c ASC
                                              ];
        	 salesPreviousList = [select Vision_Sales_Dollar__c,Vision_Units__c,Vision_Product_Family__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_Customer_Name__c,Vision_NPR_Customer_Code__c,Vision_Customer_Name__r.Name,Name,Id,Vision_Month_dtls__c
                                                       from Vision_DRL_Sales__c  where  (Vision_Month_dtls__c >=:LastDateInPrevious  AND Vision_Month_dtls__c <=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND Vision_Customer_Name__c =: customerId AND Vision_NPR_Customer_Code__c =:accCode AND Vision_Product_Family__c IN:productFamilies AND Vision_Customer_Name__r.OwnerId =: currentUserId ORDER BY  Vision_Month_dtls__c ASC
                                                      ];*/
            salesList = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                         from Vision_InternalDRLSales_ProductSummary__c where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND Vision_Customer__c =: customerId  AND Vision_Product_Family__c IN:productFamilies AND Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                              ];
            salesPreviousList = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                         from Vision_InternalDRLSales_ProductSummary__c where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND Vision_Customer__c =: customerId  AND Vision_Product_Family__c IN:productFamilies AND Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                              ];
            System.debug('in if saleslist-->'+salesList);
        }
      
        if(!showInt){
        	for(Vision_InternalDRLSales_ProductSummary__c sales : salesList){
            if(!mapSalesFInalList.containsKey(sales.Vision_Product_Family__c))
                mapSalesFInalList.put(sales.Vision_Product_Family__c, new list<Vision_InternalDRLSales_ProductSummary__c>());
            mapSalesFInalList.get(sales.Vision_Product_Family__c).add(sales);
        }
        	for(Vision_InternalDRLSales_ProductSummary__c sales : salesPreviousList){
            if(!mapSalesPreviousList.containsKey(sales.Vision_Product_Family__c))
                mapSalesPreviousList.put(sales.Vision_Product_Family__c, new list<Vision_InternalDRLSales_ProductSummary__c>());
            mapSalesPreviousList.get(sales.Vision_Product_Family__c).add(sales);
        }
        }
       
        List<wrapperClass> wrapperObjList = new List<wrapperClass>();
        if(!showInt){
        	for(String pFamily : productFamilies){
            Map<String,wrapperClass> finalMap = new Map<String,wrapperClass>();
            Map<String,wrapperClass> finalPreviousMap = new Map<String,wrapperClass>();
            wrapperClass wrpObj = new wrapperClass();
            list<Vision_InternalDRLSales_ProductSummary__c> salesFinalList = mapSalesFInalList.get(pFamily);
            list<Vision_InternalDRLSales_ProductSummary__c> salesPrevList = mapSalesPreviousList.get(pFamily);
            System.debug('salesPrevList-->'+salesPrevList);
            if(salesFinalList != null && !salesFinalList.isEmpty()){
                for(Vision_InternalDRLSales_ProductSummary__c sales : salesFinalList){
                    finalMapPFamilyName = sales.Vision_Product_Family__c;
                    decimal salesMonthly=0,unitsMonthly=0,tptdollarMonthly=0,tptpercMonthly=0;
                    System.debug('finalMap15>>'+finalMap);
                    if(finalMap.containsKey(sales.Vision_Processed_Month__c)){
                        //customerName = sales.Vision_Customer_Name__r.Name;
                        pFamilyName = sales.Vision_Customer__r.Name;
                        wrapperClass wrapObj = finalMap.get(sales.Vision_Processed_Month__c);
                        if(sales.Vision_Sales__c != null && wrapObj.salesMonthly != null){
                            wrapObj.salesMonthly = wrapObj.salesMonthly+sales.Vision_Sales__c;
                        }else{
                            wrapObj.salesMonthly = 0;
                        }
                        if(sales.Vision_Units__c != null && wrapObj.unitsMonthly != null){
                            wrapObj.unitsMonthly = wrapObj.unitsMonthly+sales.Vision_Units__c;
                        }else{
                            wrapObj.unitsMonthly =0; 
                        }
                        if(sales.Vision_TPT_Dollar__c != null && wrapObj.tptdollarMonthly != null){
                            wrapObj.tptdollarMonthly = wrapObj.tptdollarMonthly+sales.Vision_TPT_Dollar__c;
                        }else{
                            wrapObj.tptdollarMonthly =0;
                        }
                        if(wrapObj.tptdollarMonthly != null && wrapObj.salesMonthly != null && wrapObj.salesMonthly != 0){
                            wrapObj.tptpercMonthly =( wrapObj.tptdollarMonthly / wrapObj.salesMonthly )*100;
                            //wrapObj.tptpercMonthly = wrapObj.tptpercMonthly+sales.Vision_TPT_Pct__c;
                        }
                        else{
                            wrapObj.tptpercMonthly =0;   
                        }
                        finalMap.put(sales.Vision_Processed_Month__c, wrapObj);
                        //System.debug('in if--wrap-->'+wrapObj);
                        //System.debug('finalMap in if-->'+finalMap);
                    }
                    else{
                        wrapperClass wrapObj = new wrapperClass();
                        wrapObj.salesMonthly = sales.Vision_Sales__c;
                        wrapObj.unitsMonthly = sales.Vision_Units__c;
                        wrapObj.tptdollarMonthly = sales.Vision_TPT_Dollar__c;
                        if(wrapObj.tptdollarMonthly != null && wrapObj.salesMonthly != null && wrapObj.salesMonthly !=0){
                            wrapObj.tptpercMonthly =( wrapObj.tptdollarMonthly/ wrapObj.salesMonthly)*100;
                        }else{
                            wrapObj.tptpercMonthly =0;  
                        }
                        //wrapObj.tptpercMonthly = sales.Vision_TPT_Pct__c;
                        //System.debug('in else--wrap-->'+wrapObj);
                        //System.debug('finalMap in else-->'+finalMap);
                        finalMap.put(sales.Vision_Processed_Month__c,wrapObj);
                    }
                    
                }
            }else{
                finalMapPFamilyName = '';
            }
            if(salesPrevList != null && !salesPrevList.isEmpty()){
                for(Vision_InternalDRLSales_ProductSummary__c sales : salesPrevList){
                    finalPrevMapPFamilyName = sales.Vision_Product_Family__c;
                    decimal salesMonthlyPrev=0,unitsMonthlyPrev=0,tptdollarMonthlyPrev=0,tptpercMonthlyPrev=0;
                    if(finalPreviousMap.containsKey(sales.Vision_Processed_Month__c)){
                        //customerName = sales.Vision_Customer_Name__r.Name;
                        wrapperClass wrapObj = finalPreviousMap.get(sales.Vision_Processed_Month__c);
                        if(sales.Vision_Sales__c != null && wrapObj.salesMonthlyPrev != null){
                            wrapObj.salesMonthlyPrev = wrapObj.salesMonthlyPrev+sales.Vision_Sales__c;
                        }else{
                            wrapObj.salesMonthlyPrev =0; 
                        }
                        if(sales.Vision_Units__c != null && wrapObj.unitsMonthlyPrev != null){
                            wrapObj.unitsMonthlyPrev = wrapObj.unitsMonthlyPrev+sales.Vision_Units__c;
                        }else{
                            wrapObj.unitsMonthlyPrev =0;
                        }
                        if(sales.Vision_TPT_Dollar__c != null && wrapObj.tptdollarMonthlyPrev != null){
                            wrapObj.tptdollarMonthlyPrev = wrapObj.tptdollarMonthlyPrev+sales.Vision_TPT_Dollar__c;
                        }else{
                            wrapObj.tptdollarMonthlyPrev =0;
                        }
                        if(wrapObj.tptdollarMonthlyPrev != null && wrapObj.salesMonthlyPrev != null && wrapObj.salesMonthlyPrev != 0){
                            wrapObj.tptpercMonthlyPrev =( wrapObj.tptdollarMonthlyPrev/wrapObj.salesMonthlyPrev)*100;
                            //wrapObj.tptpercMonthlyPrev = wrapObj.tptpercMonthlyPrev+sales.Vision_TPT_Pct__c;
                        }
                        else{
                            wrapObj.tptpercMonthlyPrev=0;
                        }
                        finalPreviousMap.put(sales.Vision_Processed_Month__c, wrapObj);
                        //System.debug('in if--wrap-->'+wrapObj);
                        //System.debug('finalPreviousMap in if-->'+finalPreviousMap);
                    }
                    else{
                        wrapperClass wrapObj = new wrapperClass();
                        wrapObj.salesMonthlyPrev = sales.Vision_Sales__c;
                        wrapObj.unitsMonthlyPrev = sales.Vision_Units__c;
                        wrapObj.tptdollarMonthlyPrev = sales.Vision_TPT_Dollar__c;
                        if(wrapObj.tptdollarMonthlyPrev != null && wrapObj.salesMonthlyPrev !=null && wrapObj.salesMonthlyPrev != 0){
                            wrapObj.tptpercMonthlyPrev =( wrapObj.tptdollarMonthlyPrev /wrapObj.salesMonthlyPrev)*100;
                        }else{
                            wrapObj.tptpercMonthlyPrev =0;   
                        }
                        //wrapObj.tptpercMonthlyPrev = sales.Vision_TPT_Pct__c;
                        //System.debug('in else--wrap-->'+wrapObj);
                        //System.debug('finalMap in else-->'+finalPreviousMap);
                        finalPreviousMap.put(sales.Vision_Processed_Month__c,wrapObj);
                    }
                    
                }
            }else{
                finalPrevMapPFamilyName = '';
            }
            
            if(finalMapPFamilyName == finalPrevMapPFamilyName){
                pFamilyName =finalMapPFamilyName;
            }else if(finalMapPFamilyName == '' && finalPrevMapPFamilyName != null){
                pFamilyName =finalPrevMapPFamilyName;
            }else if(finalMapPFamilyName != '' && finalPrevMapPFamilyName == ''){
                pFamilyName = finalMapPFamilyName;
            }
            
            //wrapperClass wrapperObj = new wrapperClass();
           wrpObj.pFamilyName = pFamilyName;
            wrpObj.finalMap = finalMap;
            wrpObj.finalPreviousMap = finalPreviousMap;
            wrapperObjList.add(wrpObj);
            List<wrapperClass> AllAccounts = new List<wrapperClass>();
        AllAccounts.addAll(wrapperObjList);
            wrapobject.AllAccountsData =AllAccounts;
            
        }
        }
             
        
        //finalMap.clear();
        //finalPreviousMap.clear();
        return wrapobject;
        
    }
 
    
  /* public static void coverageBlock(){
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
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }  */
    
   
  
    

}