public class Vision_DRL_Sales_Report_Controller {
    @auraEnabled
    Public static wrapperClass getDRLSalesRelatedList(List<String> selections,String selectedComparison, String customerId,Boolean showInt, List<String> customerIds,String searchText){
        System.debug('search text-->'+searchText);
        String searchText1 = '%'+searchText+'%';
        String currentUserId = userInfo.getUserId();
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
         integer recentLastMonth,previousLastMonth;
        List<Date> lastquarterdateList= new List<Date>();
        List<Date> previousquarterDateList = new List<Date>();
        Map<String, String> mapOfHeaders = new Map<String, String>();
        List<Date> fytdprevdatelist = new List<Date>();
        Date lastmonthfirstDatePrev,lastmonthlastDatePrevfytd;
        map<Integer,String > monthdatelist = new map<Integer,String>();
        List<String> lastyearmonthslist = new List<String>();
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
        List<Account> res= new List<Account>();
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
            List<Vision_Intrenal_DRL_Sales_Summary__c> date1 = new List<Vision_Intrenal_DRL_Sales_Summary__c>();
            List<Vision_Intrenal_DRL_Sales_Summary__c> date2 = new List<Vision_Intrenal_DRL_Sales_Summary__c>();
            List<Vision_Intrenal_DRL_Sales_Summary__c> date3 = new List<Vision_Intrenal_DRL_Sales_Summary__c>();
            List<Vision_Intrenal_DRL_Sales_Summary__c> date4 = new List<Vision_Intrenal_DRL_Sales_Summary__c>();
            List<Vision_DRL_Sales_Summary__c> date5 = new List<Vision_DRL_Sales_Summary__c>();
            List<Vision_DRL_Sales_Summary__c> date6 = new List<Vision_DRL_Sales_Summary__c>();
            List<Vision_DRL_Sales_Summary__c> date7 = new List<Vision_DRL_Sales_Summary__c>();
            List<Vision_DRL_Sales_Summary__c> date8 = new List<Vision_DRL_Sales_Summary__c>();
            //AND  Vision_Customer__r.OwnerId =: currentUserId
            if(showInt){
                date1 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_Intrenal_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections     ORDER BY  Vision_Processed_Date__c ASC Limit 1];
                date2 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_Intrenal_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections    ORDER BY  Vision_Processed_Date__c DESC Limit 1];
         
                date3 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_Intrenal_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections     ORDER BY  Vision_Processed_Date__c ASC Limit 1];
                date4 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_Intrenal_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections  ORDER BY  Vision_Processed_Date__c DESC Limit 1];
            }
            else{
               date5 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,		Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId    ORDER BY  Vision_Processed_Date__c ASC Limit 1];
                date6 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,	Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId    ORDER BY  Vision_Processed_Date__c DESC Limit 1];
         
                date7 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,	Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId    ORDER BY  Vision_Processed_Date__c ASC Limit 1];
                date8 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,	Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId    ORDER BY  Vision_Processed_Date__c DESC Limit 1];
 
            }
           
             if(showInt){
                 if(date2.size()>0 && date4.size()>0){
            	 recentLastMonth = date2[0].Vision_Processed_Date__c.month();
            	 previousLastMonth = date4[0].Vision_Processed_Date__c.month();
                 }
             }else{
                 if(date6.size()>0 && date8.size()>0){
                 recentLastMonth = date6[0].Vision_Processed_Date__c.month();
            	 previousLastMonth = date8[0].Vision_Processed_Date__c.month();
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
                date5.clear();
                date6.clear();
                date7.clear();
                date8.clear();
                if(showInt){
                date1 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_Intrenal_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections    ORDER BY  Vision_Processed_Date__c ASC Limit 1];
                date2 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_Intrenal_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections     ORDER BY  Vision_Processed_Date__c DESC Limit 1];
         
                date3 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_Intrenal_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections     ORDER BY  Vision_Processed_Date__c ASC Limit 1];
                date4 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_Intrenal_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections  ORDER BY  Vision_Processed_Date__c DESC Limit 1];
            }
            else{
               date5 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,		Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId    ORDER BY  Vision_Processed_Date__c ASC Limit 1];
                date6 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,	Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId    ORDER BY  Vision_Processed_Date__c DESC Limit 1];
         
                date7 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,	Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId    ORDER BY  Vision_Processed_Date__c ASC Limit 1];
                date8 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,	Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId    ORDER BY  Vision_Processed_Date__c DESC Limit 1];
 
            }
                
            }  	
            //System.debug('prcd month1-->'+date1[0].Vision_Processed_Date__c.month());
            //System.debug('prcd month2-->'+date2[0].Vision_Processed_Date__c.month());
            Integer firstMonthInRecent,year,lastMonthInRecent,lastYear,monthInPrevious,yearPrev,lastMonthInPrevious,lastYearPrev;
            String monthname,YearInRecent,lastmonthname,lastYearInRecent,monthnamePrev,yearInPrev,lastmonthnamePrev,lastYearInPrev;
            if(showInt){
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
            }else{
                if(date5.size()>0){
                     firstMonthInRecent = date5[0].Vision_Processed_Date__c.month();
                     monthname = monthdatelist.get(firstMonthInRecent);
                      year = date5[0].Vision_Processed_Date__c.year();
                     YearInRecent =String.valueOf(year).right(2);
                }
                if(date6.size()>0){
                     lastMonthInRecent = date6[0].Vision_Processed_Date__c.month();
                     lastmonthname = monthdatelist.get(lastMonthInRecent);
                     lastYear = date6[0].Vision_Processed_Date__c.year();
                     lastYearInRecent = String.valueOf(lastYear).right(2);
                }
            }
            //String h1;
            String h1 =monthname +' ' +YearInRecent +'-' +lastmonthname+' '+lastYearInRecent;
            if(showInt){
                 if(date3.size()>0){
                     monthInPrevious =  date3[0].Vision_Processed_Date__c.month();
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
            }else{
                if(date7.size()>0){
                     monthInPrevious =  date7[0].Vision_Processed_Date__c.month();
                     monthnamePrev = monthdatelist.get(monthInPrevious);
                      yearPrev = date7[0].Vision_Processed_Date__c.year();
                     yearInPrev =String.valueOf(yearPrev).right(2);
                 }
                if(date8.size()>0){
                     if(recentLastMonth == previousLastMonth){
                        lastMonthInPrevious = date8[0].Vision_Processed_Date__c.month();
                     }else{
                         lastMonthInPrevious = date6[0].Vision_Processed_Date__c.month();
                     }
                     lastmonthnamePrev = monthdatelist.get(lastMonthInPrevious);
                     lastYearPrev = date8[0].Vision_Processed_Date__c.year();
                     lastYearInPrev = String.valueOf(lastYearPrev).right(2);
                }
            }
            String h2 = monthnamePrev +' ' +yearInPrev +'-' +lastmonthnamePrev+' '+lastYearInPrev;//'Apr 20-Nov 20';*/
            
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
            date5.clear();
            date6.clear();
            date7.clear();
            date8.clear();
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
            List<Vision_Intrenal_DRL_Sales_Summary__c> date1 = new List<Vision_Intrenal_DRL_Sales_Summary__c>();
            List<Vision_Intrenal_DRL_Sales_Summary__c> date2 = new List<Vision_Intrenal_DRL_Sales_Summary__c>();
            List<Vision_Intrenal_DRL_Sales_Summary__c> date3 = new List<Vision_Intrenal_DRL_Sales_Summary__c>();
            List<Vision_Intrenal_DRL_Sales_Summary__c> date4 = new List<Vision_Intrenal_DRL_Sales_Summary__c>();
            List<Vision_DRL_Sales_Summary__c> date5 = new List<Vision_DRL_Sales_Summary__c>();
            List<Vision_DRL_Sales_Summary__c> date6 = new List<Vision_DRL_Sales_Summary__c>();
            List<Vision_DRL_Sales_Summary__c> date7 = new List<Vision_DRL_Sales_Summary__c>();
            List<Vision_DRL_Sales_Summary__c> date8 = new List<Vision_DRL_Sales_Summary__c>();
             if(showInt){
                 date1 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_Intrenal_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId    ORDER BY  Vision_Processed_Date__c ASC Limit 1];
                 date2 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_Intrenal_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId    ORDER BY  Vision_Processed_Date__c DESC Limit 1];
         
                 date3 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_Intrenal_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId    ORDER BY  Vision_Processed_Date__c ASC Limit 1];
                 date4 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_Intrenal_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId    ORDER BY  Vision_Processed_Date__c DESC Limit 1];
             }
            else{
                 date5 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,	Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId    ORDER BY  Vision_Processed_Date__c ASC Limit 1];
                 date6 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,	Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId    ORDER BY  Vision_Processed_Date__c DESC Limit 1];
         
                 date7 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,		Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId    ORDER BY  Vision_Processed_Date__c ASC Limit 1];
                 date8 = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,	Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId    ORDER BY  Vision_Processed_Date__c DESC Limit 1];

             }
            //System.debug('prcd month1-->'+date2[0].Vision_Processed_Date__c.month());
            //System.debug('prcd month2-->'+date4[0].Vision_Processed_Date__c.month());
            if(showInt){
             	recentLastMonth = date2[0].Vision_Processed_Date__c.month();
            	previousLastMonth = date4[0].Vision_Processed_Date__c.month();
            }else{
                if(date6.size()>0){
                recentLastMonth = date6[0].Vision_Processed_Date__c.month();
                }
                if(date8.size()>0){
            	previousLastMonth = date8[0].Vision_Processed_Date__c.month();
                }
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
            if(showInt){
            	if(date1.size()>0) {   
            	 firstdatefytd = date1[0].Vision_Processed_Date__c.month();
            	 monthname = monthdatelist.get(firstdatefytd);
            	  year = date1[0].Vision_Processed_Date__c.year();
            	 firstdate =String.valueOf(year).right(2);
            }
            	if(date2.size()>0) { 
            	 lastdatefytd = date2[0].Vision_Processed_Date__c.month();
            	 lastmonthname = monthdatelist.get(lastdatefytd);
            	 lastYear = date2[0].Vision_Processed_Date__c.year();
            	 lastdate = String.valueOf(lastYear).right(2);
            }
            	if(date3.size()>0) { 
            	 firstdatefytdPrev = date3[0].Vision_Processed_Date__c.month();
            	 monthnamePrev = monthdatelist.get(firstdatefytdPrev);
            	  yearPrev = date3[0].Vision_Processed_Date__c.year();
            	 firstdatePrev =String.valueOf(yearPrev).right(2);
            }
            	if(date4.size()>0) { 
                 if(recentLastMonth == previousLastMonth){
            	 	lastdatefytdPrev = date4[0].Vision_Processed_Date__c.month();
                 }
                else{
                     lastdatefytdPrev = date2[0].Vision_Processed_Date__c.month();
                 }
            	 lastmonthnamePrev = monthdatelist.get(lastdatefytdPrev);
            	 lastYearPrev = date4[0].Vision_Processed_Date__c.year();
            	 lastdatePrev = String.valueOf(lastYearPrev).right(2);
            }
            }else{
                if(date5.size()>0) {   
            	 firstdatefytd = date5[0].Vision_Processed_Date__c.month();
            	 monthname = monthdatelist.get(firstdatefytd);
            	  year = date5[0].Vision_Processed_Date__c.year();
            	 firstdate =String.valueOf(year).right(2);
            }
            	if(date6.size()>0) { 
            	 lastdatefytd = date6[0].Vision_Processed_Date__c.month();
            	 lastmonthname = monthdatelist.get(lastdatefytd);
            	 lastYear = date6[0].Vision_Processed_Date__c.year();
            	 lastdate = String.valueOf(lastYear).right(2);
            }
            	if(date7.size()>0) { 
            	 firstdatefytdPrev = date7[0].Vision_Processed_Date__c.month();
            	 monthnamePrev = monthdatelist.get(firstdatefytdPrev);
            	  yearPrev = date7[0].Vision_Processed_Date__c.year();
            	 firstdatePrev =String.valueOf(yearPrev).right(2);
            }
            	if(date8.size()>0) { 
                 if(recentLastMonth == previousLastMonth){
            	 	lastdatefytdPrev = date8[0].Vision_Processed_Date__c.month();
                 }
                else{
                     lastdatefytdPrev = date6[0].Vision_Processed_Date__c.month();
                 }
            	 lastmonthnamePrev = monthdatelist.get(lastdatefytdPrev);
            	 lastYearPrev = date8[0].Vision_Processed_Date__c.year();
            	 lastdatePrev = String.valueOf(lastYearPrev).right(2);
            	}
            }
            String h1 =monthname +' ' +firstdate +'-' +lastmonthname+' '+lastdate;//'Apr 21-Nov 21' ;
            String h2 = monthnamePrev +' ' +firstdatePrev +'-' +lastmonthnamePrev+' '+lastdatePrev;//'Apr 20-Nov 20';
            mapOfHeaders.put('one', h1);
            mapOfHeaders.put('two', h2);
            fytdprevdatelist.clear();
            date1.clear();
            date2.clear();
            date3.clear();
            date4.clear();
            date5.clear();
            date6.clear();
            date7.clear();
            date8.clear();
        }
        monthdatelist.clear();
      //  Map<Id, List<Vision_Intrenal_DRL_Sales_Summary__c>> maplist = new Map<Id, List<Vision_Intrenal_DRL_Sales_Summary__c>>();
        Map<String, List<Vision_Intrenal_DRL_Sales_Summary__c>> maplist = new Map<String, List<Vision_Intrenal_DRL_Sales_Summary__c>>();
        Map<Id, List<Vision_DRL_Sales_Summary__c>> maplistExt = new Map<Id, List<Vision_DRL_Sales_Summary__c>>();
        List<Vision_Intrenal_DRL_Sales_Summary__c> totalSales = new List<Vision_Intrenal_DRL_Sales_Summary__c>();
         List<Vision_DRL_Sales_Summary__c> totalSalesExt = new List<Vision_DRL_Sales_Summary__c>();
         list<Wrapper> accWrapMap = new list<Wrapper>();
         List<Vision_Intrenal_DRL_Sales_Summary__c> totalRecentSales = new List<Vision_Intrenal_DRL_Sales_Summary__c>();
         List<Vision_DRL_Sales_Summary__c> totalRecentSalesExt = new List<Vision_DRL_Sales_Summary__c>();
        List<Vision_Intrenal_DRL_Sales_Summary__c> totalPrevSales = new List<Vision_Intrenal_DRL_Sales_Summary__c>();
         List<Vision_DRL_Sales_Summary__c> totalPrevSalesExt = new List<Vision_DRL_Sales_Summary__c>();
        Map<String,wrapperClass> finalRecentMapSummary = new Map<String,wrapperClass>();
        Map<String,wrapperClass> finalPrevMapSummary = new Map<String,wrapperClass>();
        //new code for Hierarchy*/
     /*   List<Account> parentList =[Select Id, Name,ParentId,Parent.Name From Account WHERE ParentId =: null];
        Set<Id> parentIds = new Set<Id>(); 
            for(Account parentacc: parentList){
                parentIds.add(parentacc.ParentId);
            }
        System.debug('parentIds==>'+parentIds);
        List<Account> childList =[Select Id, Name,ParentId,Parent.Name From Account WHERE ParentId IN:parentIds ];
        Set<Id> childIds = new Set<Id>(); 
        for(Account childacc: childList){
                childIds.add(childacc.ParentId);
            }
        System.debug('childIds==>'+childIds);
        List<Account> subChildList =[Select Id, Name,ParentId,Parent.Name From Account WHERE ParentId IN:childIds ];
        Set<Id> subchildIds = new Set<Id>(); 
         for(Account subchildacc: subChildList){
                subchildIds.add(subchildacc.ParentId);
            }
         System.debug('subchildIds==>'+subchildIds);
        Map<Id, Account> parentMap = new Map<Id, Account>();
        Map<Id, list<Account>> subChildMap = new Map<Id, list<Account>>();
        Map<Id, list<Account>> childMap = new Map<Id, list<Account>>();
		for(Account accObj: subChildList){
            if(subChildMap.containsKey(accObj.ParentId)){
               List<Account> accList = subChildMap.get(accObj.ParentId); 
                accList.add(accObj);
                subChildMap.put(accObj.ParentId,accList);
            }
            else{
               subChildMap.put(accObj.ParentId,new List<Account>{accObj});
            }
        }
        for(Account accObj: childList){
            if(childMap.containsKey(accObj.ParentId)){
               List<Account> accList = childMap.get(accObj.ParentId); 
                accList.add(accObj);
                childMap.put(accObj.ParentId,accList);
            }
            else{
               childMap.put(accObj.ParentId,new List<Account>{accObj});
            }
             if(subChildMap.containsKey(accObj.Id))
                childMap.get(accObj.ParentId).addAll(subChildMap.get(accObj.Id));
        }
        */
        if(showInt){
        	/*totalSales =[select Vision_Sales_Dollar__c,Vision_Units__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_Customer_Number__c,Vision_Customer_Name__c,Vision_Customer_Name__r.Name,Vision_Customer_Name__r.AccountNumber,Name,Id,Vision_Month_dtls__c
                                         from Vision_DRL_Sales__c  where  ((Vision_Month_dtls__c >=: LastDateInRecent AND Vision_Month_dtls__c<=:FirstDateInRecent) OR (Vision_Month_dtls__c >=:LastDateInPrevious  AND Vision_Month_dtls__c <=:FirstDateInPrevious)) AND Vision_Segment__c IN: selections AND Vision_Customer_Name__r.OwnerId =: currentUserId  ORDER BY  Vision_Month_dtls__c ASC
                                        ];*/
           if(searchText != null && searchText !=''&& searchText != null && searchText != 'undefined'){
            totalSales = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                         from Vision_Intrenal_DRL_Sales_Summary__c where  ((Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent) OR (Vision_Processed_Date__c >=:LastDateInPrevious  AND Vision_Processed_Date__c <=:FirstDateInPrevious))  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId AND Vision_Customer__r.Name like:searchText1  ORDER BY  Vision_Processed_Date__c ASC];
           }else{
               
                totalSales = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber,
                                   Vision_Customer__r.ParentId,Vision_Customer__r.Parent.Name      from Vision_Intrenal_DRL_Sales_Summary__c where  ((Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent) OR (Vision_Processed_Date__c >=:LastDateInPrevious  AND Vision_Processed_Date__c <=:FirstDateInPrevious))  AND Vision_Segment__c IN: selections   ORDER BY  Vision_Processed_Date__c ASC];

           }
            
        }else {
            if(searchText != null && searchText !=''&& searchText != null && searchText != 'undefined'){
                totalSalesExt =[select Vision_Sales__c,Vision_Units__c,Vision_Processed_Month__c,Vision_Customer__c,Vision_Customer__r.Name,Vision_Customer__r.AccountNumber,Name,Id,Vision_Processed_Date__c
                                         from Vision_DRL_Sales_Summary__c  where  ((Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent) OR (Vision_Processed_Date__c >=:LastDateInPrevious  AND Vision_Processed_Date__c <=:FirstDateInPrevious)) AND Vision_Segment__c IN: selections AND Vision_Customer__r.OwnerId =: currentUserId  AND Vision_Customer__r.Name like:searchText1 ORDER BY  Vision_Processed_Date__c ASC
                                        ];
            }else{
             //   String parntId='0014100001TEj4SAAT';
            	totalSalesExt =[select Vision_Sales__c,Vision_Units__c,Vision_Processed_Month__c,Vision_Customer__c,Vision_Customer__r.Name,Vision_Customer__r.AccountNumber,Name,Id,Vision_Processed_Date__c,
                                     Vision_Customer__r.ParentId,Vision_Customer__r.Parent.Name from Vision_DRL_Sales_Summary__c  where  ((Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent) OR (Vision_Processed_Date__c >=:LastDateInPrevious  AND Vision_Processed_Date__c <=:FirstDateInPrevious)) AND Vision_Segment__c IN: selections AND Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                        ];
            }
        }
        //Vision_DRL_Sales_Summary__c
       //logic for Hierarchy//
       Map<String,List<Vision_DRL_Sales_Summary__c>> parentMap= new Map<String,List<Vision_DRL_Sales_Summary__c>>();
        map<String,List<Vision_DRL_Sales_Summary__c>> childMap = new map<String,List<Vision_DRL_Sales_Summary__c>>();
        for(Vision_DRL_Sales_Summary__c item: totalSalesExt){
          //  if(item.Vision_Customer__r.ParentId == null || item.Vision_Customer__r.ParentId == '')
                //String individualAcc = 'Individual Accounts';
            String parentKey = item.Vision_Customer__r.Parent.Name;
            if(parentMap.containsKey(parentKey)){
                                                List < Vision_DRL_Sales_Summary__c > tempList = parentMap.get(parentKey);
                                                tempList.add(item);
                                                parentMap.put(parentKey,tempList);
                                            }
            else if(!parentMap.containsKey(item.Vision_Customer__r.Parent.Name)){
                                                parentMap.put(parentKey, new List < Vision_DRL_Sales_Summary__c > {
                                                    item
                                                        });
                                            }
        }
           system.debug('parentMap key-----'+parentMap.keySet());
        system.debug('parentMap values-----'+parentMap.values());
           wrapperClass wrapperObj = new wrapperClass();
        List<SalesList> SalesWrapperList = new List<SalesList>();  
            List<childSalesList> childSalesWrapperList = new List<childSalesList>();
        System.debug('parent keyset==>'+parentMap.keySet());
        for(string parentId : parentMap.keySet()){
             SalesList sList = new SalesList();
            system.debug('parentId====='+parentId);
             sList.parentAccName = parentId;
            sList.currentUserName = currentUserName;
            List<Vision_DRL_Sales_Summary__c> parentSalesList = parentMap.get(parentId);
             system.debug('parentSalesList====='+parentSalesList);
            for(Vision_DRL_Sales_Summary__c cust : parentSalesList){
                            sList.parentId = cust.Vision_Customer__r.ParentId;

                if(cust.Vision_Processed_Date__c >= LastDateInRecent && cust.Vision_Processed_Date__c <= FirstDateInRecent ){
                        if(cust.Vision_Sales__c != null)  sList.salesdl += cust.Vision_Sales__c;
                        if(cust.Vision_Units__c != null)  sList.units += cust.Vision_Units__c;
 
                        
                    }
                    if(cust.Vision_Processed_Date__c >= LastDateInPrevious && cust.Vision_Processed_Date__c <= FirstDateInPrevious ){
                        if(cust.Vision_Sales__c != null)  sList.SalesDollarPrev += cust.Vision_Sales__c; 
                        if(cust.Vision_Units__c != null)  sList.UnitsPrev += cust.Vision_Units__c;

                    }
               
                 if(childMap.containsKey(cust.Vision_Customer__c)){
                    List<Vision_DRL_Sales_Summary__c> custList = childMap.get(cust.Vision_Customer__c);
                    custList.add(cust);
                    childMap.put(cust.Vision_Customer__c,custList);
                }
                else{
                    
                    childMap.put(cust.Vision_Customer__c,new List<Vision_DRL_Sales_Summary__c>{cust});
                }
            }
              sList.trendingSales = ((sList.salesdl/sList.SalesDollarPrev)-1);
                sList.trendingUnits = ((sList.units/sList.UnitsPrev)-1);
              for(Id custId : childMap.KeySet()){
               childSalesList childList = new childSalesList();
                Decimal SalesDollar = 0;
                Decimal SalesDollarPrev = 0;
                Decimal Units = 0;
                Decimal UnitsPrev = 0;
                Decimal TPTDollar =0;
                Decimal TPTDollarPrev =0;
                Decimal TPTPct = 0;
                Decimal TPTPctPrev = 0;
                String custName ='';
                String custCode ='';
                String pfamily = '';
                String parentName='';
                
                List<Vision_DRL_Sales_Summary__c> salesExtList = childMap.get(custId); 
                          system.debug('salesExtList values-----'+salesExtList);

                for (Vision_DRL_Sales_Summary__c salesExt: salesExtList) {
                    
                    
                    if(salesExt.Vision_Processed_Date__c >= LastDateInRecent && salesExt.Vision_Processed_Date__c <= FirstDateInRecent ){
                        if(salesExt.Vision_Sales__c != null)  childList.salesdl += salesExt.Vision_Sales__c;
                        if(salesExt.Vision_Units__c != null)  childList.units += salesExt.Vision_Units__c;
                        
                        
                    }
                    if(salesExt.Vision_Processed_Date__c >= LastDateInPrevious && salesExt.Vision_Processed_Date__c <= FirstDateInPrevious ){
                        if(salesExt.Vision_Sales__c != null)  childList.SalesDollarPrev += salesExt.Vision_Sales__c; 
                        if(salesExt.Vision_Units__c != null)  childList.UnitsPrev += salesExt.Vision_Units__c;
                    }
                     childList.custId = salesExt.Vision_Customer__c;
                    childList.custName = salesExt.Vision_Customer__r.Name;
                    childList.custCode = 	salesExt.Vision_Customer__r.AccountNumber;
                    childList.pfamily = salesExt.Name;
                   // childList. parentName= salesExt.Vision_Customer__r.Parent.Name;
                    
                }
              childSalesWrapperList.add(childList);
        }
            sList.childSalesList = childSalesWrapperList;
            childSalesWrapperList =  new List<childSalesList>();//by satya
            childMap = new map<String,List<Vision_DRL_Sales_Summary__c>>();
              SalesWrapperList.add(sList);  
        }
       wrapperObj.salesList = SalesWrapperList;
          
        //end hierarchy//
      if(showInt){
          for(Vision_Intrenal_DRL_Sales_Summary__c sales : totalSales){
              string mapKey = sales.Vision_Customer__r.ParentId+'@'+sales.Vision_Customer__c;
                  if(maplist.containsKey(mapKey)){
                      List < Vision_Intrenal_DRL_Sales_Summary__c > tempList = maplist.get(mapKey);
                      tempList.add(sales);
                      maplist.put(mapKey,tempList);
                  }
              else if(!maplist.containsKey(mapKey)){
                  maplist.put(mapKey, new List < Vision_Intrenal_DRL_Sales_Summary__c > {
                      sales
                          });
              }
          }
      }else{
           for(Vision_DRL_Sales_Summary__c salesExt : totalSalesExt){
                                            if(maplistExt.containsKey(salesExt.Vision_Customer__c)){
                                                List < Vision_DRL_Sales_Summary__c > tempList = maplistExt.get(salesExt.Vision_Customer__c);
                                                tempList.add(salesExt);
                                                maplistExt.put(salesExt.Vision_Customer__c,tempList);
                                            }
                                            else if(!maplistExt.containsKey(salesExt.Vision_Customer__c)){
                                                maplistExt.put(salesExt.Vision_Customer__c, new List < Vision_DRL_Sales_Summary__c > {
                                                    salesExt
                                                        });
                                            }
                                        }
      }
       
        if(showInt){
          /* totalRecentSales = [select Vision_Sales_Dollar__c,Vision_Units__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_Customer_Number__c,Vision_Customer_Name__c,Vision_Customer_Name__r.Name,Vision_Customer_Name__r.AccountNumber,Name,Id,Vision_Month_dtls__c
                                             from Vision_DRL_Sales__c  where  (Vision_Month_dtls__c >=: LastDateInRecent AND Vision_Month_dtls__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND  Vision_Customer_Name__r.OwnerId =: currentUserId ORDER BY  Vision_Month_dtls__c ASC
                                            ];*/
            totalRecentSales = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_Intrenal_DRL_Sales_Summary__c   where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                            ];
               }else{
                   totalRecentSalesExt = [select Vision_Sales__c,Vision_Units__c,Vision_Processed_Month__c,Vision_Customer__c,Vision_Customer__r.Name,Vision_Customer__r.AccountNumber,Name,Id,Vision_Processed_Date__c
                                             from Vision_DRL_Sales_Summary__c  where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                            ]; 
                   //System.debug('totalRecentSalesExt-->'+totalRecentSalesExt);
               }
        
        if(customerId == null || customerId == 'undefined'||customerId == ''){ 
            if(showInt){
                /*totalPrevSales = [select Vision_Sales_Dollar__c,Vision_Units__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_Customer_Number__c,Vision_Customer_Name__c,Vision_Customer_Name__r.Name,Vision_Customer_Name__r.AccountNumber,Name,Id,Vision_Month_dtls__c
                                             from Vision_DRL_Sales__c  where  (Vision_Month_dtls__c >=:LastDateInPrevious  AND Vision_Month_dtls__c <=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections  AND Vision_Customer_Name__r.OwnerId =: currentUserId ORDER BY  Vision_Month_dtls__c ASC
                                            ];*/
                 totalPrevSales = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                             from Vision_Intrenal_DRL_Sales_Summary__c   where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND  Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                            ];
            }else{
                totalPrevSalesExt = [select Vision_Sales__c,Vision_Units__c,Vision_Processed_Month__c,Vision_Customer__c,Vision_Customer__r.Name,Vision_Customer__r.AccountNumber,Name,Id,Vision_Processed_Date__c
                                             from Vision_DRL_Sales_Summary__c  where  (Vision_Processed_Date__c >=:LastDateInPrevious  AND Vision_Processed_Date__c <=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections  AND Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                            ];
            }
            if(showInt){
           		 for(Vision_Intrenal_DRL_Sales_Summary__c sales : totalRecentSales){
                                                decimal salesMonthlySummary=0,unitsMonthlySummary,tptdollarMonthlySummary,tptpercMonthlySummary;
                     							System.debug('finalRecentMapSummary-->'+finalRecentMapSummary);
                                                if(finalRecentMapSummary.containsKey(sales.Vision_Processed_Month__c)){
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
                                                    }else{  wrapObj.tptpercMonthlySummary=0;
                                                         }
                                                    finalRecentMapSummary.put(sales.Vision_Processed_Month__c, wrapObj);
                                                    
                                                }
                                                else{
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
           		 for(Vision_Intrenal_DRL_Sales_Summary__c sales : totalPrevSales){
                                                decimal prevsalesMonthlySummary,prevunitsMonthlySummary,prevtptdollarMonthlySummary,prevtptpercMonthlySummary;
                                                if(finalPrevMapSummary.containsKey(sales.Vision_Processed_Month__c)){
                                                    System.debug('prcdd month-->'+sales.Vision_Processed_Month__c);
                                                    wrapperClass wrapObj = finalPrevMapSummary.get(sales.Vision_Processed_Month__c);
                                                    
                                                    if(sales.Vision_Sales__c != null && wrapObj.prevsalesMonthlySummary != null){    wrapObj.prevsalesMonthlySummary = wrapObj.prevsalesMonthlySummary + sales.Vision_Sales__c;
                                                                                                                                       }
                                                    else{      wrapObj.prevsalesMonthlySummary =0;
                                                        }
                                                    if(sales.Vision_Units__c != null && wrapObj.prevunitsMonthlySummary != null){    wrapObj.prevunitsMonthlySummary = wrapObj.prevunitsMonthlySummary+sales.Vision_Units__c;
                                                                                                                                }else{ wrapObj.prevunitsMonthlySummary = 0;  
                                                                                                                                     }
                                                    if(sales.Vision_TPT_Dollar__c != null && wrapObj.prevtptdollarMonthlySummary != null){  wrapObj.prevtptdollarMonthlySummary = wrapObj.prevtptdollarMonthlySummary+sales.Vision_TPT_Dollar__c;
                                                                                                                                         }else{ wrapObj.prevtptdollarMonthlySummary = 0;
                                                                                                                                              }
                                                    if(wrapObj.prevtptdollarMonthlySummary != null && wrapObj.prevsalesMonthlySummary != null && wrapObj.prevsalesMonthlySummary !=0){ wrapObj.prevtptpercMonthlySummary = ( wrapObj.prevtptdollarMonthlySummary / wrapObj.prevsalesMonthlySummary)*100;
                                                                                                                                                                                      
                                                                                                                                                                                     }
                                                    else{   wrapObj.prevtptpercMonthlySummary=0;
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
            }else{
                for(Vision_DRL_Sales_Summary__c salesExt : totalRecentSalesExt){
                                                decimal salesMonthlySummary=0,unitsMonthlySummary,tptdollarMonthlySummary,tptpercMonthlySummary;
                    System.debug('final rec map summary-->'+finalRecentMapSummary);
                                                if(finalRecentMapSummary.containsKey(salesExt.Vision_Processed_Month__c)){
                                                    wrapperClass wrapObj = finalRecentMapSummary.get(salesExt.Vision_Processed_Month__c);
                                                    if(salesExt.Vision_Sales__c != null && wrapObj.salesMonthlySummary != null){
                                                        wrapObj.salesMonthlySummary = wrapObj.salesMonthlySummary+salesExt.Vision_Sales__c;
                                                    }
                                                    else{ 
                                                        wrapObj.salesMonthlySummary =0; 
                                                    }
                                                    if(salesExt.Vision_Units__c != null && wrapObj.unitsMonthlySummary != null){ 
                                                        wrapObj.unitsMonthlySummary = wrapObj.unitsMonthlySummary+salesExt.Vision_Units__c;
                                                    }else{ 
                                                        wrapObj.unitsMonthlySummary=0;   
                                                    }
                                                    
                                                    finalRecentMapSummary.put(salesExt.Vision_Processed_Month__c, wrapObj);
                                                    
                                                }
                                                else{
                                                    wrapperClass wrapObj = new wrapperClass();
                                                    wrapObj.salesMonthlySummary = salesExt.Vision_Sales__c;
                                                    wrapObj.unitsMonthlySummary = salesExt.Vision_Units__c;
                                                    finalRecentMapSummary.put(salesExt.Vision_Processed_Month__c,wrapObj);
                                                }
                                                
                                            }
                for(Vision_DRL_Sales_Summary__c salesExt : totalPrevSalesExt){
                                                decimal prevsalesMonthlySummary,prevunitsMonthlySummary,prevtptdollarMonthlySummary,prevtptpercMonthlySummary;
                                                if(finalPrevMapSummary.containsKey(salesExt.Vision_Processed_Month__c)){
                                                    wrapperClass wrapObj = finalPrevMapSummary.get(salesExt.Vision_Processed_Month__c);
                                                    
                                                    if(salesExt.Vision_Sales__c != null && wrapObj.prevsalesMonthlySummary != null){    wrapObj.prevsalesMonthlySummary = wrapObj.prevsalesMonthlySummary + salesExt.Vision_Sales__c;
                                                                                                                                       }
                                                    else{      wrapObj.prevsalesMonthlySummary =0;
                                                        }
                                                    if(salesExt.Vision_Units__c != null && wrapObj.prevunitsMonthlySummary != null){    wrapObj.prevunitsMonthlySummary = wrapObj.prevunitsMonthlySummary+salesExt.Vision_Units__c;
                                                                                                                                }else{ wrapObj.prevunitsMonthlySummary = 0;  
                                                                                                                                     }
                                                    
                                                    finalPrevMapSummary.put(salesExt.Vision_Processed_Month__c, wrapObj);
                                                    
                                                }
                                                else{
                                                    wrapperClass wrapObj = new wrapperClass();
                                                    wrapObj.prevsalesMonthlySummary = salesExt.Vision_Sales__c;
                                                    wrapObj.prevunitsMonthlySummary = salesExt.Vision_Units__c;
                                                    finalPrevMapSummary.put(salesExt.Vision_Processed_Month__c,wrapObj);
                                                }
                                                
                                            }
            }
        }   
        
        if(showInt){
       		 if (maplist != null) {
            for(String custId : maplist.KeySet()){
                Decimal SalesDollar = 0;
                Decimal SalesDollarPrev = 0;
                Decimal Units = 0;
                Decimal UnitsPrev = 0;
                Decimal TPTDollar =0;
                Decimal TPTDollarPrev =0;
                Decimal TPTPct = 0;
                Decimal TPTPctPrev = 0;
                String custName ='';
                String custCode ='';
                String newCustId ='';
                String pfamily = '';
                String parentName='';
                
                for (Vision_Intrenal_DRL_Sales_Summary__c sales: maplist.get(custId)) {
                    
                    
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
                    newCustId= sales.Vision_Customer__c;
                    custName = sales.Vision_Customer__r.Name;
                    custCode = 	sales.Vision_Customer__r.AccountNumber;
                    pfamily = sales.Name;
                    parentName= sales.Vision_Customer__r.Parent.Name;
                    
                }
                Wrapper wrapperObject = new Wrapper();
                wrapperObject.salesdl = SalesDollar;
                wrapperObject.units = Units;
                wrapperObject.tptdollar = TPTDollar;
                wrapperObject.tptpct = TPTPct;
                wrapperObject.custName = custName;
                wrapperObject.custCode = custCode;
                wrapperObject.pfamily = pfamily;
                wrapperObject.custId = newCustId;
                wrapperObject.currentUserName =currentUserName;
                wrapperObject.SalesDollarPrev = SalesDollarPrev;
                wrapperObject.TPTDollarPrev = TPTDollarPrev;
                wrapperObject.TPTPctPrev = TPTPctPrev;
                wrapperObject.UnitsPrev = UnitsPrev;
                wrapperObject.searchText1=searchText1;
                wrapperObject.parentName=parentName;
                
                accWrapMap.add(wrapperObject);
            }
            maplist.clear();
        }
        }else{
             if (maplistExt != null) {
            		for(Id custId : maplistExt.KeySet()){
                Decimal SalesDollar = 0;
                Decimal SalesDollarPrev = 0;
                Decimal Units = 0;
                Decimal UnitsPrev = 0;
                Decimal TPTDollar =0;
                Decimal TPTDollarPrev =0;
                Decimal TPTPct = 0;
                Decimal TPTPctPrev = 0;
                String custName ='';
                String custCode ='';
                String pfamily = '';
                String parentName='';
                
                
                for (Vision_DRL_Sales_Summary__c salesExt: maplistExt.get(custId)) {
                    
                    
                    if(salesExt.Vision_Processed_Date__c >= LastDateInRecent && salesExt.Vision_Processed_Date__c <= FirstDateInRecent ){
                        if(salesExt.Vision_Sales__c != null)  SalesDollar += salesExt.Vision_Sales__c;
                        if(salesExt.Vision_Units__c != null)  Units += salesExt.Vision_Units__c;
                        
                        
                    }
                    if(salesExt.Vision_Processed_Date__c >= LastDateInPrevious && salesExt.Vision_Processed_Date__c <= FirstDateInPrevious ){
                        if(salesExt.Vision_Sales__c != null)  SalesDollarPrev += salesExt.Vision_Sales__c; 
                        if(salesExt.Vision_Units__c != null)  UnitsPrev += salesExt.Vision_Units__c;
                    }
                    
                    custName = salesExt.Vision_Customer__r.Name;
                    custCode = 	salesExt.Vision_Customer__r.AccountNumber;
                    pfamily = salesExt.Name;
                     parentName= salesExt.Vision_Customer__r.Parent.Name;
                    
                }
                Wrapper wrapperObject = new Wrapper();
                wrapperObject.salesdl = SalesDollar;
                wrapperObject.units = Units;
                wrapperObject.tptdollar = TPTDollar;
                wrapperObject.tptpct = TPTPct;
                wrapperObject.custName = custName;
                wrapperObject.custCode = custCode;
                wrapperObject.pfamily = pfamily;
                wrapperObject.custId = custId;
                wrapperObject.currentUserName =currentUserName;
                wrapperObject.SalesDollarPrev = SalesDollarPrev;
                wrapperObject.TPTDollarPrev = TPTDollarPrev;
                wrapperObject.TPTPctPrev = TPTPctPrev;
                wrapperObject.UnitsPrev = UnitsPrev;
                wrapperObject.parentName=parentName;
                
                
                accWrapMap.add(wrapperObject);
            }
            maplistExt.clear();
        	}
        }
        drl_sales_dates_info__c cotdi = drl_sales_dates_info__c.getInstance('Data1');
     //   wrapperClass wrapperObj = new wrapperClass();
        wrapperObj.accWrapMap = accWrapMap;
        wrapperObj.dynamicHeaders = mapOfHeaders;
        wrapperObj.keySet = keySet;
        wrapperObj.keySetPrev = keySetPrev;
        wrapperObj.finalRecentMapSummary = finalRecentMapSummary;
        wrapperObj.finalPrevMapSummary = finalPrevMapSummary;
        wrapperObj.selections = selections;
         wrapperObj.recentLastMonth = recentLastMonth;
          wrapperObj.previousLastMonth = previousLastMonth;
        wrapperObj.parentMap=parentMap;
       // wrapperObj.parentlist=parentlist;
        if(cotdi!=null){
        wrapperObj.GCPUpdateDate = cotdi.Vision_GCP_Update_Date__c;
            wrapperObj.VisionUpdateDate = cotdi.Vision_Update_Date__c;
            wrapperObj.DataAvailableTill = cotdi.Vision_Data_Available_Till__c;}
        
            List<wrapperClass> AllAccounts = new List<wrapperClass>();
        List<wrapperClass> finalResult = new List<wrapperClass>();
        if(selectedComparison == 'lastquartervspreviousquarter')   {
            finalResult =Vision_DRL_Sales_Report_Controller.getLastQuarterVsPrevQuarterData(selections,selectedComparison,customerIds,showInt);
            AllAccounts.addAll(finalResult); 
        }  
        else if(selectedComparison == 'last12monthsvsprevious12months'){
            System.debug('recentLastMonth in -->'+recentLastMonth);
             System.debug('previousLastMonth in -->'+previousLastMonth);
            finalResult =Vision_DRL_Sales_Report_Controller.getLasttwmonthsVsPrevtwmonthsData(selections,selectedComparison,customerIds,showInt,recentLastMonth,previousLastMonth);
            AllAccounts.addAll(finalResult); 
        }
        else if(selectedComparison == 'fytdvspreviousfytd'){
            finalResult =Vision_DRL_Sales_Report_Controller.getfytdData(selections,selectedComparison,customerIds,showInt);
            AllAccounts.addAll(finalResult);
            
        }
        wrapperObj.AllAccountsData =finalResult;
        //AllAccounts.clear();
        
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
        @AuraEnabled public String customerName;
         @AuraEnabled public String parentName;
        @AuraEnabled public List<String> selections;
        @AuraEnabled public integer recentLastMonth;
        @AuraEnabled public integer previousLastMonth;
        @AuraEnabled public List<wrapperClass> AllAccountsData;
        @AuraEnabled public List<wrapperClass> wrapperObjList;
        @AuraEnabled public String GCPUpdateDate;
        @AuraEnabled public String VisionUpdateDate;
        @AuraEnabled public String DataAvailableTill;
        @AuraEnabled public List<String> keySet;
          @AuraEnabled public List<String> keySetPrev;
       @AuraEnabled public Map<Id, List<Vision_Intrenal_DRL_Sales_Summary__c>> parentlist;
        @AuraEnabled public Map<String,List<Vision_DRL_Sales_Summary__c>> parentMap;
   // added for hierarchy
        @AuraEnabled public String parentAccName;
         @AuraEnabled public String currentUserName;
        @AuraEnabled public List<SalesList> salesList;
        wrapperClass(){
            salesList = new List<SalesList>();
        }
    }
    Public Class SalesList{
        @AuraEnabled public String parentAccName;
        @AuraEnabled public String parentId;
        @AuraEnabled public String currentUserName;
         @AuraEnabled public List<childSalesList> childSalesList;
         @AuraEnabled public Decimal salesdl = 0;
        @AuraEnabled public Decimal SalesDollarPrev = 0;
        @AuraEnabled public Decimal units = 0;
        @AuraEnabled public Decimal UnitsPrev = 0;
        @AuraEnabled public Decimal TPTDollar =0;
        @AuraEnabled public Decimal TPTDollarPrev =0;
        @AuraEnabled public Decimal TPTPct = 0;
        @AuraEnabled public Decimal TPTPctPrev = 0;
        @AuraEnabled public Decimal trendingSales = 0;
         @AuraEnabled public Decimal trendingUnits = 0;
        SalesList(){
 childSalesList = new List<childSalesList>();            
        }
    }
     Public Class childSalesList{
        @AuraEnabled public String childAccName;
        @AuraEnabled public String custId;
        @AuraEnabled public Decimal salesdl = 0;
        @AuraEnabled public Decimal SalesDollarPrev = 0;
        @AuraEnabled public Decimal units = 0;
        @AuraEnabled public Decimal UnitsPrev = 0;
        @AuraEnabled public Decimal TPTDollar =0;
        @AuraEnabled public Decimal TPTDollarPrev =0;
        @AuraEnabled public Decimal TPTPct = 0;
        @AuraEnabled public Decimal TPTPctPrev = 0;
        @AuraEnabled public String custName;
        @AuraEnabled public String custCode;
        @AuraEnabled public String pfamily;
        @AuraEnabled public String parentName;
        childSalesList(){
            
        }
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
         @AuraEnabled public string custCode;
        @AuraEnabled public string pfamily;
        @AuraEnabled public Id custId;
        @AuraEnabled public String currentUserName;
         @AuraEnabled public String searchText1;
        @AuraEnabled public String parentName;
        
    }
    
    @auraEnabled
    public static List<wrapperClass> getLasttwmonthsVsPrevtwmonthsData(List<String> selections,String selectedComparison,List<String> customerIds,Boolean showInt,Integer recentLastMonth,Integer previousLastMonth){
        System.debug('enter into this method');
        System.debug('customerIds-->'+customerIds);
        System.debug('selections-->'+selections);
        System.debug('selectedComparison-->'+selectedComparison);
        System.debug('recentLastMonth in get-->'+recentLastMonth);
        System.debug('previousLastMonth in get-->'+previousLastMonth);
        System.debug('showInt-->'+showInt);
        List<wrapperClass> AllAccounts = new List<wrapperClass>();
        String currentUserId = userInfo.getUserId();
        Date FirstDateInRecent,LastDateInRecent,FirstDateInPrevious,LastDateInPrevious;
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
        if(recentLastMonth == previousLastMonth){
        FirstDateInRecent = lasttwmonthsdatelist[0].addMonths(1).toStartofMonth().addDays(-1);
        LastDateInRecent = lasttwmonthsdatelist[11];
        FirstDateInPrevious = prevtwmontdateList[0].addMonths(1).toStartofMonth().addDays(-1);
        LastDateInPrevious = prevtwmontdateList[11];
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
				FirstDateInRecent = lasttwmonthsdatelist[1].addMonths(1).toStartofMonth().addDays(-1);
                LastDateInRecent = lasttwmonthsdatelist[12];
                FirstDateInPrevious = prevtwmontdateList[1].addMonths(1).toStartofMonth().addDays(-1);
                LastDateInPrevious = prevtwmontdateList[12];
        }
        System.debug('FirstDateInRecent in GET-->'+FirstDateInRecent);
        System.debug('LastDateInRecent in GET-->'+LastDateInRecent);
        System.debug('FirstDateInPrevious in GET-->'+FirstDateInPrevious);
        System.debug('LastDateInPrevious in GET-->'+LastDateInPrevious);
        String customerName = '';
        Map<Id,list<Vision_Intrenal_DRL_Sales_Summary__c>> mapSalesFInalList = new Map<Id, list<Vision_Intrenal_DRL_Sales_Summary__c>>();
        Map<Id,list<Vision_DRL_Sales_Summary__c>> mapSalesFInalListExt = new Map<Id, list<	Vision_DRL_Sales_Summary__c>>();
        Map<Id,list<Vision_Intrenal_DRL_Sales_Summary__c>> mapSalesPreviousList = new Map<Id, list<Vision_Intrenal_DRL_Sales_Summary__c>>();
        Map<Id,list<Vision_DRL_Sales_Summary__c>> mapSalesPreviousListExt = new Map<Id, list<Vision_DRL_Sales_Summary__c>>();
        List<Vision_Intrenal_DRL_Sales_Summary__c> salesListInt = new List<Vision_Intrenal_DRL_Sales_Summary__c>();
         List<Vision_DRL_Sales_Summary__c> salesListExt = new List<Vision_DRL_Sales_Summary__c>();
        List<Vision_Intrenal_DRL_Sales_Summary__c> salesPreviousList = new List<Vision_Intrenal_DRL_Sales_Summary__c>();
         List<Vision_DRL_Sales_Summary__c> salesPreviousListExt = new List<Vision_DRL_Sales_Summary__c>();
        if(showInt){
        	/*salesList = [select Vision_Sales_Dollar__c,Vision_Units__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_Customer_Name__c,Vision_Customer_Name__r.Name,Vision_Customer_Name__r.AccountNumber,Name,Id,Vision_Month_dtls__c
                                               from Vision_DRL_Sales__c  where  (Vision_Month_dtls__c >=: LastDateInRecent AND Vision_Month_dtls__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND Vision_Customer_Name__c IN: customerIds AND Vision_Customer_Name__r.OwnerId =: currentUserId ORDER BY  Vision_Month_dtls__c ASC
                                              ];*/
            salesListInt = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                         from Vision_Intrenal_DRL_Sales_Summary__c  where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND Vision_Customer__c IN: customerIds AND Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                              ];
             System.debug('salesList in GET-->'+salesListInt);
        	/*salesPreviousList = [select Vision_Sales_Dollar__c,Vision_Units__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_Customer_Name__c,Vision_Customer_Name__r.Name,Vision_Customer_Name__r.AccountNumber,Name,Id,Vision_Month_dtls__c
                                                       from Vision_DRL_Sales__c  where  (Vision_Month_dtls__c >=:LastDateInPrevious  AND Vision_Month_dtls__c <=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND Vision_Customer_Name__c IN: customerIds AND Vision_Customer_Name__r.OwnerId =: currentUserId ORDER BY  Vision_Month_dtls__c ASC
                                                      ];*/
            salesPreviousList = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                         from Vision_Intrenal_DRL_Sales_Summary__c  where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND Vision_Customer__c IN: customerIds AND Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                              ];
        }else{
            salesListExt = [select Vision_Sales__c,Vision_Units__c,Vision_Processed_Month__c,Vision_Customer__c,Vision_Customer__r.Name,Vision_Customer__r.AccountNumber,Name,Id,Vision_Processed_Date__c
                                               from Vision_DRL_Sales_Summary__c  where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND Vision_Customer__c IN: customerIds AND Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                              ];
        	salesPreviousListExt = [select Vision_Sales__c,Vision_Units__c,Vision_Processed_Month__c,Vision_Customer__c,Vision_Customer__r.Name,Vision_Customer__r.AccountNumber,Name,Id,Vision_Processed_Date__c
                                                       from Vision_DRL_Sales_Summary__c  where  (Vision_Processed_Date__c >=:LastDateInPrevious  AND Vision_Processed_Date__c <=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND Vision_Customer__c IN: customerIds AND Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                                      ];
        }
        if(showInt){ 
            for(Vision_Intrenal_DRL_Sales_Summary__c sales : salesListInt){
                if(!mapSalesFInalList.containsKey(sales.Vision_Customer__c))
                    mapSalesFInalList.put(sales.Vision_Customer__c, new list<Vision_Intrenal_DRL_Sales_Summary__c>());
                mapSalesFInalList.get(sales.Vision_Customer__c).add(sales);
                
            }
            for(Vision_Intrenal_DRL_Sales_Summary__c sales : salesPreviousList){
                if(!mapSalesPreviousList.containsKey(sales.Vision_Customer__c))
                    mapSalesPreviousList.put(sales.Vision_Customer__c, new list<Vision_Intrenal_DRL_Sales_Summary__c>());
                mapSalesPreviousList.get(sales.Vision_Customer__c).add(sales);
            }	
        }else{
                for(Vision_DRL_Sales_Summary__c salesExt : salesListExt){
                    if(!mapSalesFInalListExt.containsKey(salesExt.Vision_Customer__c))
                        mapSalesFInalListExt.put(salesExt.Vision_Customer__c, new list<Vision_DRL_Sales_Summary__c>());
                    mapSalesFInalListExt.get(salesExt.Vision_Customer__c).add(salesExt);
                    
                }
                for(Vision_DRL_Sales_Summary__c salesExt : salesPreviousListExt){
                    if(!mapSalesPreviousListExt.containsKey(salesExt.Vision_Customer__c))
                        mapSalesPreviousListExt.put(salesExt.Vision_Customer__c, new list<Vision_DRL_Sales_Summary__c>());
                    mapSalesPreviousListExt.get(salesExt.Vision_Customer__c).add(salesExt);
                }	
            
        }
        String finalMapCustomerName = '';
        String finalPrevMapCustomerName = '';
        List<wrapperClass> wrapperObjList = new List<wrapperClass>();
        if(showInt){
        	for(Id accId : customerIds){
            Map<String,wrapperClass> finalMap = new Map<String,wrapperClass>();
            Map<String,wrapperClass> finalPreviousMap = new Map<String,wrapperClass>();
            
            wrapperClass wrpObj = new wrapperClass();
            list<Vision_Intrenal_DRL_Sales_Summary__c> salesFinalList = mapSalesFInalList.get(accId);
            list<Vision_Intrenal_DRL_Sales_Summary__c> salesPrevList = mapSalesPreviousList.get(accId);
            System.debug('salesPrevList-->'+salesPrevList);
            if(salesFinalList != null && !salesFinalList.isEmpty()){
                for(Vision_Intrenal_DRL_Sales_Summary__c sales : salesFinalList){
                    finalMapCustomerName = sales.Vision_Customer__r.Name;
                    decimal salesMonthly=0,unitsMonthly=0,tptdollarMonthly=0,tptpercMonthly=0;
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
                finalMapCustomerName = '';
            }
            if(salesPrevList != null && !salesPrevList.isEmpty()){
                for(Vision_Intrenal_DRL_Sales_Summary__c sales : salesPrevList){
                    finalPrevMapCustomerName = sales.Vision_Customer__r.Name;
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
                finalPrevMapCustomerName = '';
            }
            if(finalMapCustomerName == finalPrevMapCustomerName){
                customerName =finalMapCustomerName;
            }else if(finalMapCustomerName == '' && finalPrevMapCustomerName != null){
                customerName =finalPrevMapCustomerName;
            }else if(finalMapCustomerName != '' && finalPrevMapCustomerName == ''){
                customerName = finalMapCustomerName;
            }
            wrpObj.customerName = customerName;
            wrpObj.finalMap = finalMap;
            wrpObj.finalPreviousMap = finalPreviousMap;
            wrapperObjList.add(wrpObj);
            // wrapperObj.AllAccountsData =wrapperObjList;
            System.debug('response--->'+wrapperObjList);   
        }
        }
        else{
            	for(Id accId : customerIds){
            Map<String,wrapperClass> finalMap = new Map<String,wrapperClass>();
            Map<String,wrapperClass> finalPreviousMap = new Map<String,wrapperClass>();
            
            wrapperClass wrpObj = new wrapperClass();
            list<Vision_DRL_Sales_Summary__c> salesFinalListExt = mapSalesFInalListExt.get(accId);
            list<Vision_DRL_Sales_Summary__c> salesPrevListExt = mapSalesPreviousListExt.get(accId);
            System.debug('salesPrevListExt-->'+salesPrevListExt);
            if(salesFinalListExt != null && !salesFinalListExt.isEmpty()){
                for(Vision_DRL_Sales_Summary__c salesExt : salesFinalListExt){
                    finalMapCustomerName = salesExt.Vision_Customer__r.Name;
                    decimal salesMonthly=0,unitsMonthly=0,tptdollarMonthly=0,tptpercMonthly=0;
                    if(finalMap.containsKey(salesExt.Vision_Processed_Month__c)){
                        
                        wrapperClass wrapObj = finalMap.get(salesExt.Vision_Processed_Month__c);
                        if(salesExt.Vision_Sales__c != null && wrapObj.salesMonthly != null){
                            System.debug('sales dollar'+salesExt.Vision_Sales__c);
                            wrapObj.salesMonthly = wrapObj.salesMonthly+salesExt.Vision_Sales__c;
                        }else{
                            wrapObj.salesMonthly = 0;
                        }
                        if(salesExt.Vision_Units__c != null && wrapObj.unitsMonthly != null){
                            wrapObj.unitsMonthly = wrapObj.unitsMonthly+salesExt.Vision_Units__c;
                        }else{
                            wrapObj.unitsMonthly =0; 
                        }
                        finalMap.put(salesExt.Vision_Processed_Month__c, wrapObj);
                        
                    }
                    else{
                        wrapperClass wrapObj = new wrapperClass();
                        wrapObj.salesMonthly = salesExt.Vision_Sales__c;
                        wrapObj.unitsMonthly = salesExt.Vision_Units__c;
                        finalMap.put(salesExt.Vision_Processed_Month__c,wrapObj);
                    }
                    
                }
            }else{
                finalMapCustomerName = '';
            }
            if(salesPrevListExt != null && !salesPrevListExt.isEmpty()){
                for(Vision_DRL_Sales_Summary__c salesExt : salesPrevListExt){
                    System.debug('989-salesPrevListExt-->'+salesPrevListExt);
                        System.debug('990-finalprev map-->'+finalPreviousMap);
                    finalPrevMapCustomerName = salesExt.Vision_Customer__r.Name;
                    decimal salesMonthlyPrev=0,unitsMonthlyPrev=0,tptdollarMonthlyPrev=0,tptpercMonthlyPrev=0;
                    System.debug('991 prcced month-->'+salesExt.Vision_Processed_Month__c);
                    if(finalPreviousMap.containsKey(salesExt.Vision_Processed_Month__c)){
                        wrapperClass wrapObj = finalPreviousMap.get(salesExt.Vision_Processed_Month__c);
                        if(salesExt.Vision_Sales__c != null && wrapObj.salesMonthlyPrev != null){
                            wrapObj.salesMonthlyPrev = wrapObj.salesMonthlyPrev+salesExt.Vision_Sales__c;
                        }else{
                            wrapObj.salesMonthlyPrev =0; 
                        }
                        if(salesExt.Vision_Units__c != null && wrapObj.unitsMonthlyPrev != null){
                            wrapObj.unitsMonthlyPrev = wrapObj.unitsMonthlyPrev+salesExt.Vision_Units__c;
                        }else{
                            wrapObj.unitsMonthlyPrev =0;
                        }
                        finalPreviousMap.put(salesExt.Vision_Processed_Month__c, wrapObj);
                    }
                    else{
                        wrapperClass wrapObj = new wrapperClass();
                        wrapObj.salesMonthlyPrev = salesExt.Vision_Sales__c;
                        wrapObj.unitsMonthlyPrev = salesExt.Vision_Units__c;
                        finalPreviousMap.put(salesExt.Vision_Processed_Month__c,wrapObj);
                    }
                    
                }
            }else{
                finalPrevMapCustomerName = '';
            }
            if(finalMapCustomerName == finalPrevMapCustomerName){
                customerName =finalMapCustomerName;
            }else if(finalMapCustomerName == '' && finalPrevMapCustomerName != null){
                customerName =finalPrevMapCustomerName;
            }else if(finalMapCustomerName != '' && finalPrevMapCustomerName == ''){
                customerName = finalMapCustomerName;
            }
            wrpObj.customerName = customerName;
            wrpObj.finalMap = finalMap;
            wrpObj.finalPreviousMap = finalPreviousMap;
            wrapperObjList.add(wrpObj);
            // wrapperObj.AllAccountsData =wrapperObjList;
            System.debug('response--->'+wrapperObjList);   
        	}
        	}
        return wrapperObjList;
        
    }
    
    @auraEnabled
    public static List<wrapperClass> getLastQuarterVsPrevQuarterData(List<String> selections,String selectedComparison,List<String> customerIds,Boolean showInt){
        System.debug('enter into this method2');
        System.debug('customerIds2-->'+customerIds);
        System.debug('selections2-->'+selections);
        System.debug('selectedComparison2-->'+selectedComparison);
        String customerName = '';
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
        Map<Id,list<Vision_Intrenal_DRL_Sales_Summary__c>> mapSalesFInalList = new Map<Id, list<Vision_Intrenal_DRL_Sales_Summary__c>>();
         Map<Id,list<Vision_DRL_Sales_Summary__c>> mapSalesFInalListExt = new Map<Id, list<Vision_DRL_Sales_Summary__c>>();
        Map<Id,list<Vision_Intrenal_DRL_Sales_Summary__c>> mapSalesPreviousList = new Map<Id, list<Vision_Intrenal_DRL_Sales_Summary__c>>();  //09-2022
        Map<Id,list<Vision_DRL_Sales_Summary__c>> mapSalesPreviousListExt = new Map<Id, list<Vision_DRL_Sales_Summary__c>>();
        List<Vision_Intrenal_DRL_Sales_Summary__c> salesList = new List<Vision_Intrenal_DRL_Sales_Summary__c>();
        List<Vision_DRL_Sales_Summary__c> salesListExt = new List<Vision_DRL_Sales_Summary__c>();
        List<Vision_Intrenal_DRL_Sales_Summary__c> salesPreviousList = new List<Vision_Intrenal_DRL_Sales_Summary__c>();
         List<Vision_DRL_Sales_Summary__c> salesPreviousListExt = new List<Vision_DRL_Sales_Summary__c>();
        if(showInt){
        	/*salesList = [select Vision_Sales_Dollar__c,Vision_Units__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_Customer_Name__c,Vision_Customer_Name__r.Name,Vision_Customer_Name__r.AccountNumber,Name,Id,Vision_Month_dtls__c
                                               from Vision_DRL_Sales__c  where  (Vision_Month_dtls__c >=: LastDateInRecent AND Vision_Month_dtls__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND Vision_Customer_Name__c IN: customerIds AND Vision_Customer_Name__r.OwnerId =: currentUserId ORDER BY  Vision_Month_dtls__c ASC
                                              ];*/
           salesList =[select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                         from Vision_Intrenal_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND Vision_Customer__c IN: customerIds AND Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC];
        	/*salesPreviousList = [select Vision_Sales_Dollar__c,Vision_Units__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_Customer_Name__c,Vision_Customer_Name__r.Name,Vision_Customer_Name__r.AccountNumber,Name,Id,Vision_Month_dtls__c
                                                       from Vision_DRL_Sales__c  where  (Vision_Month_dtls__c >=:LastDateInPrevious  AND Vision_Month_dtls__c <=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND Vision_Customer_Name__c IN: customerIds AND Vision_Customer_Name__r.OwnerId =: currentUserId ORDER BY  Vision_Month_dtls__c ASC
                                                      ];*/
           salesPreviousList =[select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c
                                         from Vision_Intrenal_DRL_Sales_Summary__c where  (Vision_Processed_Date__c >=: LastDateInPrevious AND Vision_Processed_Date__c<=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND Vision_Customer__c IN: customerIds AND Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC];
        }else{
            salesListExt = [select Vision_Sales__c,Vision_Units__c,Vision_Processed_Month__c,Vision_Customer__c,Vision_Customer__r.Name,Vision_Customer__r.AccountNumber,Name,Id,Vision_Processed_Date__c
                                               from Vision_DRL_Sales_Summary__c  where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND Vision_Customer__c IN: customerIds AND Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                              ];
        	salesPreviousListExt = [select Vision_Sales__c,Vision_Units__c,Vision_Processed_Month__c,Vision_Customer__c,Vision_Customer__r.Name,Vision_Customer__r.AccountNumber,Name,Id,Vision_Processed_Date__c
                                                       from Vision_DRL_Sales_Summary__c  where  (Vision_Processed_Date__c >=:LastDateInPrevious  AND Vision_Processed_Date__c <=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND Vision_Customer__c IN: customerIds AND Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                                      ];
        }
        if(showInt){
        	for(Vision_Intrenal_DRL_Sales_Summary__c sales : salesList){
            if(!mapSalesFInalList.containsKey(sales.Vision_Customer__c))
                mapSalesFInalList.put(sales.Vision_Customer__c, new list<Vision_Intrenal_DRL_Sales_Summary__c>());
            mapSalesFInalList.get(sales.Vision_Customer__c).add(sales);
        }
        	for(Vision_Intrenal_DRL_Sales_Summary__c sales : salesPreviousList){
            if(!mapSalesPreviousList.containsKey(sales.Vision_Customer__c))
                mapSalesPreviousList.put(sales.Vision_Customer__c, new list<Vision_Intrenal_DRL_Sales_Summary__c>());
            mapSalesPreviousList.get(sales.Vision_Customer__c).add(sales);
        }
        }else{
            	for(Vision_DRL_Sales_Summary__c salesExt : salesListExt){
            if(!mapSalesFInalListExt.containsKey(salesExt.Vision_Customer__c))
                mapSalesFInalListExt.put(salesExt.Vision_Customer__c, new list<Vision_DRL_Sales_Summary__c>());
            mapSalesFInalListExt.get(salesExt.Vision_Customer__c).add(salesExt);
        }
        		for(Vision_DRL_Sales_Summary__c salesExt : salesPreviousListExt){
            if(!mapSalesPreviousListExt.containsKey(salesExt.Vision_Customer__c))
                mapSalesPreviousListExt.put(salesExt.Vision_Customer__c, new list<Vision_DRL_Sales_Summary__c>());
            mapSalesPreviousListExt.get(salesExt.Vision_Customer__c).add(salesExt);
        }
            
        }
        List<wrapperClass> wrapperObjList = new List<wrapperClass>();
        if(showInt){
        	for(Id accId : customerIds){
            Map<String,wrapperClass> finalMap = new Map<String,wrapperClass>();
            Map<String,wrapperClass> finalPreviousMap = new Map<String,wrapperClass>();
            wrapperClass wrpObj = new wrapperClass();
            list<Vision_Intrenal_DRL_Sales_Summary__c> salesFinalList = mapSalesFInalList.get(accId);
            list<Vision_Intrenal_DRL_Sales_Summary__c> salesPrevList = mapSalesPreviousList.get(accId);
            System.debug('salesPrevList-->'+salesPrevList);
            String finalMapCustomerName ='';
            String finalPrevMapCustomerName = '';
            if(salesFinalList != null && !salesFinalList.isEmpty()){
                for(Vision_Intrenal_DRL_Sales_Summary__c sales : salesFinalList){
                    finalMapCustomerName = sales.Vision_Customer__r.Name;
                    decimal salesMonthly=0,unitsMonthly=0,tptdollarMonthly=0,tptpercMonthly=0;
                    if(finalMap.containsKey(sales.Vision_Processed_Month__c)){
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
                finalMapCustomerName = '';  
            }
            if(salesPrevList != null && !salesPrevList.isEmpty()){
                for(Vision_Intrenal_DRL_Sales_Summary__c sales : salesPrevList){
                    finalPrevMapCustomerName = sales.Vision_Customer__r.Name;
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
                finalPrevMapCustomerName = '';
            }
            if(finalMapCustomerName == finalPrevMapCustomerName){
                customerName =finalMapCustomerName;
            }else if(finalMapCustomerName == '' && finalPrevMapCustomerName != null){
                customerName =finalPrevMapCustomerName;
            }else if(finalMapCustomerName != '' && finalPrevMapCustomerName == ''){
                customerName = finalMapCustomerName;
            }
            wrpObj.customerName = customerName;
            wrpObj.finalMap = finalMap;
            wrpObj.finalPreviousMap = finalPreviousMap;
            wrapperObjList.add(wrpObj);
            
        }
        }else{
            for(Id accId : customerIds){
            Map<String,wrapperClass> finalMap = new Map<String,wrapperClass>();
            Map<String,wrapperClass> finalPreviousMap = new Map<String,wrapperClass>();
            wrapperClass wrpObj = new wrapperClass();
            list<Vision_DRL_Sales_Summary__c> salesFinalListExt = mapSalesFInalListExt.get(accId);
            list<Vision_DRL_Sales_Summary__c> salesPrevListExt = mapSalesPreviousListExt.get(accId);
            System.debug('salesPrevListExt-->'+salesPrevListExt);
            String finalMapCustomerName ='';
            String finalPrevMapCustomerName = '';
            if(salesFinalListExt != null && !salesFinalListExt.isEmpty()){
                for(Vision_DRL_Sales_Summary__c salesExt : salesFinalListExt){
                    finalMapCustomerName = salesExt.Vision_Customer__r.Name;
                    decimal salesMonthly=0,unitsMonthly=0,tptdollarMonthly=0,tptpercMonthly=0;
                    if(finalMap.containsKey(salesExt.Vision_Processed_Month__c)){
                        //customerName = sales.Vision_Customer_Name__r.Name;
                        wrapperClass wrapObj = finalMap.get(salesExt.Vision_Processed_Month__c);
                        if(salesExt.Vision_Sales__c != null && wrapObj.salesMonthly != null){
                            wrapObj.salesMonthly = wrapObj.salesMonthly+salesExt.Vision_Sales__c;
                        }else{
                            wrapObj.salesMonthly = 0;
                        }
                        if(salesExt.Vision_Units__c != null && wrapObj.unitsMonthly != null){
                            wrapObj.unitsMonthly = wrapObj.unitsMonthly+salesExt.Vision_Units__c;
                        }else{
                            wrapObj.unitsMonthly =0; 
                        }
                        finalMap.put(salesExt.Vision_Processed_Month__c, wrapObj);
                        
                    }
                    else{
                        wrapperClass wrapObj = new wrapperClass();
                        wrapObj.salesMonthly = salesExt.Vision_Sales__c;
                        wrapObj.unitsMonthly = salesExt.Vision_Units__c;
                        finalMap.put(salesExt.Vision_Processed_Month__c,wrapObj);
                    }
                    
                }
            }else{
                finalMapCustomerName = '';  
            }
            if(salesPrevListExt != null && !salesPrevListExt.isEmpty()){
                for(Vision_DRL_Sales_Summary__c salesExt : salesPrevListExt){
                    finalPrevMapCustomerName = salesExt.Vision_Customer__r.Name;
                    decimal salesMonthlyPrev=0,unitsMonthlyPrev=0,tptdollarMonthlyPrev=0,tptpercMonthlyPrev=0;
                    if(finalPreviousMap.containsKey(salesExt.Vision_Processed_Month__c)){
                        //customerName = sales.Vision_Customer_Name__r.Name;
                        wrapperClass wrapObj = finalPreviousMap.get(salesExt.Vision_Processed_Month__c);
                        if(salesExt.Vision_Sales__c != null && wrapObj.salesMonthlyPrev != null){
                            wrapObj.salesMonthlyPrev = wrapObj.salesMonthlyPrev+salesExt.Vision_Sales__c;
                        }else{
                            wrapObj.salesMonthlyPrev =0; 
                        }
                        if(salesExt.Vision_Units__c != null && wrapObj.unitsMonthlyPrev != null){
                            wrapObj.unitsMonthlyPrev = wrapObj.unitsMonthlyPrev+salesExt.Vision_Units__c;
                        }else{
                            wrapObj.unitsMonthlyPrev =0;
                        }
                        finalPreviousMap.put(salesExt.Vision_Processed_Month__c, wrapObj);
                    }
                    else{
                        wrapperClass wrapObj = new wrapperClass();
                        wrapObj.salesMonthlyPrev = salesExt.Vision_Sales__c;
                        wrapObj.unitsMonthlyPrev = salesExt.Vision_Units__c;
                        finalPreviousMap.put(salesExt.Vision_Processed_Month__c,wrapObj);
                    }
                    
                }
            }else{
                finalPrevMapCustomerName = '';
            }
            if(finalMapCustomerName == finalPrevMapCustomerName){
                customerName =finalMapCustomerName;
            }else if(finalMapCustomerName == '' && finalPrevMapCustomerName != null){
                customerName =finalPrevMapCustomerName;
            }else if(finalMapCustomerName != '' && finalPrevMapCustomerName == ''){
                customerName = finalMapCustomerName;
            }
            wrpObj.customerName = customerName;
            wrpObj.finalMap = finalMap;
            wrpObj.finalPreviousMap = finalPreviousMap;
            wrapperObjList.add(wrpObj);
            
        }
        }
        return wrapperObjList;
    }
    
    @auraEnabled
    public static List<wrapperClass> getfytdData(List<String> selections,String selectedComparison,List<String> customerIds,Boolean showInt){
        
        String customerName = '';
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
          /*  if(todayDate <= currentFyscalDate){
                LastDateInRecent = Date.newinstance(system.today().year()-1, orgFiscalMonth+3, 1);
                LastDateInPrevious = Date.newinstance(system.today().year()-2, orgFiscalMonth+3, 1);
            }else{
                LastDateInRecent = Date.newinstance(system.today().year(), orgFiscalMonth+3, 1);
                LastDateInPrevious = Date.newinstance(system.today().year()-1, orgFiscalMonth+3, 1);
            }*/
            System.debug('LastDateInRecent-->'+LastDateInRecent);
            
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
        Map<Id,list<Vision_Intrenal_DRL_Sales_Summary__c>> mapSalesFInalList = new Map<Id, list<Vision_Intrenal_DRL_Sales_Summary__c>>();
        Map<Id,list<Vision_DRL_Sales_Summary__c>> mapSalesFInalListExt = new Map<Id, list<Vision_DRL_Sales_Summary__c>>();
        Map<Id,list<Vision_Intrenal_DRL_Sales_Summary__c>> mapSalesPreviousList = new Map<Id, list<Vision_Intrenal_DRL_Sales_Summary__c>>();
         Map<Id,list<Vision_DRL_Sales_Summary__c>> mapSalesPreviousListExt = new Map<Id, list<Vision_DRL_Sales_Summary__c>>();
         List<Vision_Intrenal_DRL_Sales_Summary__c> salesList = new List<Vision_Intrenal_DRL_Sales_Summary__c>();
        List<Vision_DRL_Sales_Summary__c> salesListExt = new List<Vision_DRL_Sales_Summary__c>();
        List<Vision_Intrenal_DRL_Sales_Summary__c> salesPreviousList = new List<Vision_Intrenal_DRL_Sales_Summary__c>();
        List<Vision_DRL_Sales_Summary__c> salesPreviousListExt = new List<Vision_DRL_Sales_Summary__c>();
        if(showInt){
        	/* salesList = [select Vision_Sales_Dollar__c,Vision_Units__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_Customer_Name__c,Vision_Customer_Name__r.Name,Vision_Customer_Name__r.AccountNumber,Name,Id,Vision_Month_dtls__c
                                               from Vision_DRL_Sales__c  where  (Vision_Month_dtls__c >=: LastDateInRecent AND Vision_Month_dtls__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND Vision_Customer_Name__c IN: customerIds AND Vision_Customer_Name__r.OwnerId =: currentUserId ORDER BY  Vision_Month_dtls__c ASC
                                              ];*/
            salesList = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                         from Vision_Intrenal_DRL_Sales_Summary__c  where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND Vision_Customer__c IN: customerIds AND Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                              ];
       		/* salesPreviousList = [select Vision_Sales_Dollar__c,Vision_Units__c,Vision_Processed_Month__c,Vision_TPT_Dollar__c,Vision_TPT_Pct__c,Vision_Customer_Name__c,Vision_Customer_Name__r.Name,Vision_Customer_Name__r.AccountNumber,Name,Id,Vision_Month_dtls__c
                                                       from Vision_DRL_Sales__c  where  (Vision_Month_dtls__c >=:LastDateInPrevious  AND Vision_Month_dtls__c <=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND Vision_Customer_Name__c IN: customerIds AND Vision_Customer_Name__r.OwnerId =: currentUserId ORDER BY  Vision_Month_dtls__c ASC
                                                      ];*/
            salesPreviousList = [select Vision_Sales__c,Vision_Customer__r.OwnerId,Vision_Processed_Date__c,Vision_TPT_Dollar__c,Vision_Units__c,Vision_Customer__c,Vision_Customer__r.Name,Name,Id,Vision_Processed_Month__c,Vision_Product_Family__c,Vision_Customer__r.AccountNumber
                                         from Vision_Intrenal_DRL_Sales_Summary__c  where  (Vision_Processed_Date__c >=:LastDateInPrevious  AND Vision_Processed_Date__c <=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND Vision_Customer__c IN: customerIds AND Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                                      ];
        }else{
          	 salesListExt = [select Vision_Sales__c,Vision_Units__c,Vision_Processed_Month__c,Vision_Customer__c,Vision_Customer__r.Name,Vision_Customer__r.AccountNumber,Name,Id,Vision_Processed_Date__c
                                               from Vision_DRL_Sales_Summary__c  where  (Vision_Processed_Date__c >=: LastDateInRecent AND Vision_Processed_Date__c<=:FirstDateInRecent)  AND Vision_Segment__c IN: selections AND Vision_Customer__c IN: customerIds AND Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                              ];
        	salesPreviousListExt = [select Vision_Sales__c,Vision_Units__c,Vision_Processed_Month__c,Vision_Customer__c,Vision_Customer__r.Name,Vision_Customer__r.AccountNumber,Name,Id,Vision_Processed_Date__c
                                                       from Vision_DRL_Sales_Summary__c  where  (Vision_Processed_Date__c >=:LastDateInPrevious  AND Vision_Processed_Date__c <=:FirstDateInPrevious)  AND Vision_Segment__c IN: selections AND Vision_Customer__c IN: customerIds AND Vision_Customer__r.OwnerId =: currentUserId ORDER BY  Vision_Processed_Date__c ASC
                                                      ];  
        }
        if(showInt){
        	for(Vision_Intrenal_DRL_Sales_Summary__c sales : salesList){
            if(!mapSalesFInalList.containsKey(sales.Vision_Customer__c))
                mapSalesFInalList.put(sales.Vision_Customer__c, new list<Vision_Intrenal_DRL_Sales_Summary__c>());
            mapSalesFInalList.get(sales.Vision_Customer__c).add(sales);
        }
        	for(Vision_Intrenal_DRL_Sales_Summary__c sales : salesPreviousList){
            if(!mapSalesPreviousList.containsKey(sales.Vision_Customer__c))
                mapSalesPreviousList.put(sales.Vision_Customer__c, new list<Vision_Intrenal_DRL_Sales_Summary__c>());
            mapSalesPreviousList.get(sales.Vision_Customer__c).add(sales);
        }
        }else{
            for(Vision_DRL_Sales_Summary__c salesExt : salesListExt){
                if(!mapSalesFInalListExt.containsKey(salesExt.Vision_Customer__c))
                    mapSalesFInalListExt.put(salesExt.Vision_Customer__c, new list<Vision_DRL_Sales_Summary__c>());
                mapSalesFInalListExt.get(salesExt.Vision_Customer__c).add(salesExt);
            }
            for(Vision_DRL_Sales_Summary__c salesExt : salesPreviousListExt){
                if(!mapSalesPreviousListExt.containsKey(salesExt.Vision_Customer__c))
                    mapSalesPreviousListExt.put(salesExt.Vision_Customer__c, new list<Vision_DRL_Sales_Summary__c>());
                mapSalesPreviousListExt.get(salesExt.Vision_Customer__c).add(salesExt);
            }
        }
        List<wrapperClass> wrapperObjList = new List<wrapperClass>();
        if(showInt){
            for(Id accId : customerIds){
                Map<String,wrapperClass> finalMap = new Map<String,wrapperClass>();
                Map<String,wrapperClass> finalPreviousMap = new Map<String,wrapperClass>();
                wrapperClass wrpObj = new wrapperClass();
                list<Vision_Intrenal_DRL_Sales_Summary__c> salesFinalList = mapSalesFInalList.get(accId);
                list<Vision_Intrenal_DRL_Sales_Summary__c> salesPrevList = mapSalesPreviousList.get(accId);
                System.debug('salesPrevList-->'+salesPrevList);
                if(salesFinalList != null && !salesFinalList.isEmpty()){
                    for(Vision_Intrenal_DRL_Sales_Summary__c sales : salesFinalList){
                        finalMapCustomerName = sales.Vision_Customer__r.Name;
                        decimal salesMonthly=0,unitsMonthly=0,tptdollarMonthly=0,tptpercMonthly=0;
                        if(finalMap.containsKey(sales.Vision_Processed_Month__c)){
                            //customerName = sales.Vision_Customer_Name__r.Name;
                            customerName = sales.Vision_Customer__r.Name;
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
                    finalMapCustomerName = '';
                }
                if(salesPrevList != null && !salesPrevList.isEmpty()){
                    for(Vision_Intrenal_DRL_Sales_Summary__c sales : salesPrevList){
                        finalPrevMapCustomerName = sales.Vision_Customer__r.Name;
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
                    finalPrevMapCustomerName = '';
                }
                
                if(finalMapCustomerName == finalPrevMapCustomerName){
                    customerName =finalMapCustomerName;
                }else if(finalMapCustomerName == '' && finalPrevMapCustomerName != null){
                    customerName =finalPrevMapCustomerName;
                }else if(finalMapCustomerName != '' && finalPrevMapCustomerName == ''){
                    customerName = finalMapCustomerName;
                }
                
                //wrapperClass wrapperObj = new wrapperClass();
                wrpObj.customerName = customerName;
                wrpObj.finalMap = finalMap;
                wrpObj.finalPreviousMap = finalPreviousMap;
                wrapperObjList.add(wrpObj);
                
            }
        }else{
            for(Id accId : customerIds){
                Map<String,wrapperClass> finalMap = new Map<String,wrapperClass>();
                Map<String,wrapperClass> finalPreviousMap = new Map<String,wrapperClass>();
                wrapperClass wrpObj = new wrapperClass();
                list<Vision_DRL_Sales_Summary__c> salesFinalListExt = mapSalesFInalListExt.get(accId);
                list<Vision_DRL_Sales_Summary__c> salesPrevListExt = mapSalesPreviousListExt.get(accId);
                System.debug('salesPrevList-->'+salesPrevListExt);
                if(salesFinalListExt != null && !salesFinalListExt.isEmpty()){
                    for(Vision_DRL_Sales_Summary__c salesExt : salesFinalListExt){
                        finalMapCustomerName = salesExt.Vision_Customer__r.Name;
                        decimal salesMonthly=0,unitsMonthly=0,tptdollarMonthly=0,tptpercMonthly=0;
                        if(finalMap.containsKey(salesExt.Vision_Processed_Month__c)){
                            //customerName = sales.Vision_Customer_Name__r.Name;
                            System.debug('Vision_Sales_Dollar__c-->'+salesExt.Vision_Sales__c);
                            customerName = salesExt.Vision_Customer__r.Name;
                            wrapperClass wrapObj = finalMap.get(salesExt.Vision_Processed_Month__c);
                            if(salesExt.Vision_Sales__c != null && wrapObj.salesMonthly != null){
                                wrapObj.salesMonthly = wrapObj.salesMonthly+salesExt.Vision_Sales__c;
                            }else{
                                wrapObj.salesMonthly = 0;
                            }
                            if(salesExt.Vision_Units__c != null && wrapObj.unitsMonthly != null){
                                wrapObj.unitsMonthly = wrapObj.unitsMonthly+salesExt.Vision_Units__c;
                            }else{
                                wrapObj.unitsMonthly =0; 
                            }
                            finalMap.put(salesExt.Vision_Processed_Month__c, wrapObj);
                            //System.debug('in if--wrap-->'+wrapObj);
                            //System.debug('finalMap in if-->'+finalMap);
                        }
                        else{
                            wrapperClass wrapObj = new wrapperClass();
                            wrapObj.salesMonthly = salesExt.Vision_Sales__c;
                            wrapObj.unitsMonthly = salesExt.Vision_Units__c;
                            //wrapObj.tptpercMonthly = sales.Vision_TPT_Pct__c;
                            //System.debug('in else--wrap-->'+wrapObj);
                            //System.debug('finalMap in else-->'+finalMap);
                            finalMap.put(salesExt.Vision_Processed_Month__c,wrapObj);
                        }
                        
                    }
                }else{
                    finalMapCustomerName = '';
                }
                if(salesPrevListExt != null && !salesPrevListExt.isEmpty()){
                    for(Vision_DRL_Sales_Summary__c salesExt : salesPrevListExt){
                        finalPrevMapCustomerName = salesExt.Vision_Customer__r.Name;
                        decimal salesMonthlyPrev=0,unitsMonthlyPrev=0,tptdollarMonthlyPrev=0,tptpercMonthlyPrev=0;
                        if(finalPreviousMap.containsKey(salesExt.Vision_Processed_Month__c)){
                            //customerName = sales.Vision_Customer_Name__r.Name;
                            wrapperClass wrapObj = finalPreviousMap.get(salesExt.Vision_Processed_Month__c);
                            if(salesExt.Vision_Sales__c != null && wrapObj.salesMonthlyPrev != null){
                                wrapObj.salesMonthlyPrev = wrapObj.salesMonthlyPrev+salesExt.Vision_Sales__c;
                            }else{
                                wrapObj.salesMonthlyPrev =0; 
                            }
                            if(salesExt.Vision_Units__c != null && wrapObj.unitsMonthlyPrev != null){
                                wrapObj.unitsMonthlyPrev = wrapObj.unitsMonthlyPrev+salesExt.Vision_Units__c;
                            }else{
                                wrapObj.unitsMonthlyPrev =0;
                            }
                            finalPreviousMap.put(salesExt.Vision_Processed_Month__c, wrapObj);
                            //System.debug('in if--wrap-->'+wrapObj);
                            //System.debug('finalPreviousMap in if-->'+finalPreviousMap);
                        }
                        else{
                            wrapperClass wrapObj = new wrapperClass();
                            wrapObj.salesMonthlyPrev = salesExt.Vision_Sales__c;
                            wrapObj.unitsMonthlyPrev = salesExt.Vision_Units__c;
                            //wrapObj.tptpercMonthlyPrev = sales.Vision_TPT_Pct__c;
                            //System.debug('in else--wrap-->'+wrapObj);
                            //System.debug('finalMap in else-->'+finalPreviousMap);
                            finalPreviousMap.put(salesExt.Vision_Processed_Month__c,wrapObj);
                        }
                        
                    }
                }else{
                    finalPrevMapCustomerName = '';
                }
                
                if(finalMapCustomerName == finalPrevMapCustomerName){
                    customerName =finalMapCustomerName;
                }else if(finalMapCustomerName == '' && finalPrevMapCustomerName != null){
                    customerName =finalPrevMapCustomerName;
                }else if(finalMapCustomerName != '' && finalPrevMapCustomerName == ''){
                    customerName = finalMapCustomerName;
                }
                
                //wrapperClass wrapperObj = new wrapperClass();
                wrpObj.customerName = customerName;
                wrpObj.finalMap = finalMap;
                wrpObj.finalPreviousMap = finalPreviousMap;
                wrapperObjList.add(wrpObj);
                
            }
        }
        
        //finalMap.clear();
        //finalPreviousMap.clear();
        return wrapperObjList;
        
    }
    
    /*public static void coverageBlock(){
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