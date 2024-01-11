public class Vision_Net_Sales_Controller {
    Public static void getDates(String selectedComparison){
        Date FirstDateInRecent,LastDateInRecent,FirstDateInPrevious,LastDateInPrevious;
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
    }
    }
}