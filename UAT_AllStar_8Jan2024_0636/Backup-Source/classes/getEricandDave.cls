public class getEricandDave {
      public static String colorStylehead;
      public static List<salesrep> daveData;
    public static string forfinaltar;
    public static string forfinalach;
     
    public static salesrep getDaveData()
    {
        
        list<AchievementSummaryTableCls.wrapperClass> westdata = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
        salesrep dave = new salesrep();
        for(AchievementSummaryTableCls.wrapperClass west : westdata)
        {
            if(west.quarter_one_Achieved != null && west.quarter_one_Achieved != 0)
            {
               dave.q1total += west.quarter_one_Achieved;
            }
            
            if(west.quarter_two_Achieved != null && west.quarter_two_Achieved != 0)
            {
               dave.q2total += west.quarter_two_Achieved;
            }
            if(west.quarter_three_Achieved != null && west.quarter_three_Achieved != 0)
            {
               dave.q3total += west.quarter_three_Achieved;
            }
            if(west.quarter_four_Achieved != null && west.quarter_four_Achieved != 0)
            {
               dave.q4total += west.quarter_four_Achieved;
            }
            
            if(west.quarter_one_Target != null && west.quarter_one_Target != 0)
            {
               dave.q1target += west.quarter_one_Target;
            }
            if(west.quarter_Two_Target != null && west.quarter_Two_Target != 0)
            {
               dave.q2target += west.quarter_Two_Target;
            }
            if(west.quarter_Three_Target != null && west.quarter_Three_Target != 0)
            {
               dave.q3target += west.quarter_Three_Target;
            }
            if(west.quarter_Four_Target != null && west.quarter_Four_Target != 0)
            {
               dave.q4target += west.quarter_Four_Target;
            }
            
            if(west.annual_Achieved != null && west.annual_Achieved != 0)
            {
               dave.annualTotal += west.annual_Achieved;
            }
            
            if(west.annual_Target != null && west.annual_Target != 0)
            {
               dave.annualTarget += west.annual_Target;
            }
        }
        
        if(dave.q1total != null && dave.q1total !=0 && dave.q1target != null && dave.q1target != 0)
        {
            dave.q1percent = (dave.q1total / dave.q1target) * 100;
        }
        if(dave.q2total != null && dave.q2total !=0 && dave.q2target != null && dave.q2target != 0)
        {
            dave.q2percent = (dave.q2total / dave.q2target) * 100;
        }
        if(dave.q3total != null && dave.q3total !=0 && dave.q3target != null && dave.q3target != 0)
        {
            dave.q3percent = (dave.q3total / dave.q3target) * 100;
        }
        if(dave.q4total != null && dave.q4total !=0 && dave.q4target != null && dave.q4target != 0)
        {
            dave.q4percent = (dave.q4total / dave.q4target) * 100;
        }
        
        return dave;
    }
    public static salesrep getEricData()
    {
        
        list<AchievementSummaryTableCls.wrapperClass> eastdata = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
        salesrep eric = new salesrep();
        for(AchievementSummaryTableCls.wrapperClass east : eastdata)
        {
            if(east.quarter_one_Achieved != null && east.quarter_one_Achieved != 0)
            {
               eric.q1total += east.quarter_one_Achieved;
            }
            if(east.quarter_two_Achieved != null && east.quarter_two_Achieved != 0)
            {
               eric.q2total += east.quarter_two_Achieved;
            }
            if(east.quarter_three_Achieved != null && east.quarter_three_Achieved != 0)
            {
               eric.q3total += east.quarter_three_Achieved;
            }
            if(east.quarter_four_Achieved != null && east.quarter_four_Achieved != 0)
            {
               eric.q4total += east.quarter_four_Achieved;
            }
            
            if(east.quarter_one_Target != null && east.quarter_one_Target != 0)
            {
               eric.q1target += east.quarter_one_Target;
            }
            if(east.quarter_Two_Target != null && east.quarter_Two_Target != 0)
            {
               eric.q2target += east.quarter_Two_Target;
            }
            if(east.quarter_Three_Target != null && east.quarter_Three_Target != 0)
            {
               eric.q3target += east.quarter_Three_Target;
            }
            if(east.quarter_Four_Target != null && east.quarter_Four_Target != 0)
            {
               eric.q4target += east.quarter_Four_Target;
            }
            
            if(east.annual_Achieved != null && east.annual_Achieved != 0)
            {
               eric.annualTotal += east.annual_Achieved;
            }
            
            if(east.annual_Target != null && east.annual_Target != 0)
            {
               eric.annualTarget += east.annual_Target;
            }
        }
        
        if(eric.q1total != null && eric.q1total !=0 && eric.q1target != null && eric.q1target != 0)
        {
            eric.q1percent = (eric.q1total / eric.q1target) * 100;
        }
        if(eric.q2total != null && eric.q2total !=0 && eric.q2target != null && eric.q2target != 0)
        {
            eric.q2percent = (eric.q2total / eric.q2target) * 100;
        }
        if(eric.q3total != null && eric.q3total !=0 && eric.q3target != null && eric.q3target != 0)
        {
            eric.q3percent = (eric.q3total / eric.q3target) * 100;
        }
        if(eric.q4total != null && eric.q4total !=0 && eric.q4target != null && eric.q4target != 0)
        {
            eric.q4percent = (eric.q4total / eric.q4target) * 100;
        }
        
        return eric;
    }
    public static List<salesrep> getCalculatedData(Decimal q2target,Decimal q2total)
    {
        daveData = new List<salesrep>();
        salesrep wrapcls = new salesrep();
        Decimal quarter_Total_Target = q2target;
        Decimal quarter_Total_Achieved = q2total;
        Decimal percentDataTotal;
        percentDataTotal =  AchievedSalesSummaryHREmailNotification.percentCalculate(quarter_Total_Achieved,quarter_Total_Target);
        percentDataTotal = percentDataTotal.setScale(0);
        if(percentDataTotal > 90){
            colorStylehead  = 'color:green;color:#579857;';  
        }
        else if(percentDataTotal > 50 && percentDataTotal < 90 ){
            colorStylehead  = 'color:blue;color:#5072F1;';  
        }
        else{
            colorStylehead  = 'color:red;color:#EB4747;';    
        }
        wrapcls.formattedQuarterfinaltarget =  HeadApprovalEmailNotification.conversion(quarter_Total_Target);
        wrapcls.formattedQuarterfinalachieved =  HeadApprovalEmailNotification.conversion(quarter_Total_Achieved);
        wrapcls.formattedQuarterfinalpercent2 = String.valueOf(percentDataTotal);
        wrapcls.formattedQuarterfinalpercent = wrapcls.formattedQuarterfinalpercent2 +'%' ;
        wrapcls.colorHead = colorStylehead;
       // forfinalach = wrapcls.formattedQuarterfinaltarget;
       // forfinaltar = wrapcls.formattedQuarterfinalachieved;
        daveData.add(wrapcls);
        return daveData;
    }
    
    
    
    public class salesrep
    {
        decimal q1total=0;
        public decimal q2total=0;
        decimal q3total=0;
        decimal q4total=0;
        public decimal annualTotal=0;
        decimal q1target=0;
        public decimal q2target=0;
        decimal q3target=0;
        decimal q4target=0;
        public decimal annualTarget=0;
        decimal q1percent=0;
        public decimal q2percent=0;
        decimal q3percent=0;
        decimal q4percent=0;
        public decimal annualpercent=0;
        public String  formattedQuarterfinaltarget;
        public String formattedQuarterfinalachieved;
        public String formattedQuarterfinalpercent;
        public String formattedQuarterfinalpercent2;
        public String colorHead;
        
        
    }
    

}