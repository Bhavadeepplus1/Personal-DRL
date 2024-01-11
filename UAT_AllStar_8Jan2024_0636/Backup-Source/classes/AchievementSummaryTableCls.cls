public class AchievementSummaryTableCls {
    public static Map<String,User> mapUserIds = new Map<String,User>();//Added by BV
    @AuraEnabled
    Public static List<wrapperClass> getWestDirectIndirectSalesList(){
        List<wrapperClass> wrapperObj = new List<wrapperClass>();
        Map<String, List<Achievement_Summary_Table__c>> maplist = new Map<String, List<Achievement_Summary_Table__c>>();
      	Map<String, Sales_Reps_Targets__c> maplistforTargets = new Map<String, Sales_Reps_Targets__c>();
        List<Achievement_Summary_Table__c> directIndirectSales = new List<Achievement_Summary_Table__c>();
        List<Sales_Reps_Targets__c> targetsList = new List<Sales_Reps_Targets__c>();
        Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
        List<Date> currentFYList= new List<Date>();
        date fyDate;date fyStartDate;date fyEndDate;
       
     /*   for(integer i=3;i<=14;i++){
            date currentFyscalDate = Date.newinstance(system.today().year()-1, orgFiscalMonth+i, 1);
            currentFYList.add(currentFyscalDate);
            System.debug('currentFyscalDate==>'+currentFyscalDate);
        }
        */
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
        String sales_rep = 'Andre White';
        //AND soldToRebatePercent__c !=:'166462' AND soldToRebatePercent__c !=:'155781'
        directIndirectSales = [select id,Sales_Rep_Email_Id__c,Employee_Id__c,Direct_Sales__c,Indirect_Sales__c,Achieved__c,DateToConsider__c,Sales_Rep_Name__c,Region__c,soldToRebatePercent__c from Achievement_Summary_Table__c where DateToConsider__c >=: fyStartDate AND  DateToConsider__c <=: fyEndDate  AND Region__c =: 'West'  AND Sales_Rep_Name__c !=:	'Dave Smith' AND  Sales_Rep_Name__c !=:	'Eric Sutherland'  ORDER BY  DateToConsider__c ASC];
        for(Achievement_Summary_Table__c sales : directIndirectSales){ 
            string mapKey = sales.Sales_Rep_Name__c;
            if(maplist.containsKey(mapKey)){
                List < Achievement_Summary_Table__c > tempList = maplist.get(mapKey);
                tempList.add(sales);
                maplist.put(mapKey,tempList);
            }else if(!maplist.containsKey(mapKey)){
                maplist.put(mapKey, new List < Achievement_Summary_Table__c > {
                    sales
                        });
            }
        }
        //targetsList = [select id,Quarter_1__c,Quarter_2__c,	Quarter_3__c,Quarter_4__c,User_Name__c,Region__c from Sales_Reps_Targets__c where User_Name__c != null AND Region__c =: 'West'];
        List<Id > parentIds = new List<Id>();
        List<SRx_Target__c> parentRec = [select id from SRx_Target__c  where Approval_Status__c =: 'Accepted' and Financial_Year__c =: 'FY24' order by CreatedDate Desc];
        for(SRx_Target__c tr : parentRec){
            parentIds.add(tr.id);
        }
        String parentId='';
        if(parentIds.size()>0){
            parentId = parentIds[0];
        }
		//	SRx_Target__c  a1FDL000007kJDI2A2
        targetsList =[select id,User_Name__c,SRx_Target__r.Approval_Status__c,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,SRx_Target__r.Financial_Year__c  from Sales_Reps_Targets__c  where   SRx_Target__r.Approval_Status__c = 'Accepted' AND Quarter_1__c != null AND SRx_Target__r.Financial_Year__c = 'FY24' AND Region__c =: 'West' AND SRx_Target__c =:parentId ORDER BY CreatedDate desc];
        //targetsList =[select id,User_Name__c,SRx_Target__r.Approval_Status__c,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,SRx_Target__r.Financial_Year__c  from Sales_Reps_Targets__c  where   SRx_Target__c ='a1FDL000007kJDI2A2' ORDER BY CreatedDate desc];

        /*  for(Achievement_Summary_Table__c sales : directIndirectSales){ 
            string mapKey = sales.Sales_Rep_Name__c;
            if(maplist.containsKey(mapKey)){
                List < Achievement_Summary_Table__c > tempList = maplist.get(mapKey);
                tempList.add(sales);
                maplist.put(mapKey,tempList);
            }else if(!maplist.containsKey(mapKey)){
                maplist.put(mapKey, new List < Achievement_Summary_Table__c > {
                    sales
                        });
            }
        }*/
        for(Sales_Reps_Targets__c target : targetsList){ 
            string mapKey = target.User_Name__c;
            if(maplistforTargets.containsKey(mapKey)){
                Sales_Reps_Targets__c  tempList = maplistforTargets.get(mapKey);
                //tempList.add(target);
                maplistforTargets.put(mapKey,tempList);
            }else if(!maplistforTargets.containsKey(mapKey)){
                maplistforTargets.put(mapKey, Target);
                       
            }
        }
        //wrapperObj.totalSalesList = maplist;
        /*quarterly wise summary*/
        date quarter1_FirstDate;date quarter1_EndDate;
        quarter1_FirstDate = currentFYList[0];
        quarter1_EndDate = currentFYList[2].addMonths(1).toStartofMonth().addDays(-1);
        date quarter2_FirstDate;date quarter2_EndDate;
        quarter2_FirstDate = currentFYList[3];
        quarter2_EndDate = currentFYList[5].addMonths(1).toStartofMonth().addDays(-1);
        date quarter3_FirstDate;date quarter3_EndDate;
        quarter3_FirstDate = currentFYList[6];
        quarter3_EndDate = currentFYList[8].addMonths(1).toStartofMonth().addDays(-1);
        date quarter4_FirstDate;date quarter4_EndDate;
        quarter4_FirstDate = currentFYList[9];
        quarter4_EndDate = currentFYList[11].addMonths(1).toStartofMonth().addDays(-1);
        System.debug('maplist.KeySet()==>'+maplist.values().size());
         //if (maplist != null) {
             for(String salesRep : maplist.KeySet()){
                 Decimal quarter_one_Achieved = 0;
                  Decimal quarter_two_Achieved = 0;
                 Decimal quarter_three_Achieved = 0;
                 Decimal quarter_four_Achieved = 0;
                 Decimal annual_Achieved = 0;
                 Decimal annual_Target = 0;
                 Decimal quarter_one_Target = 0;
                 Decimal quarter_Two_Target = 0;
                 Decimal quarter_Three_Target = 0;
                 Decimal quarter_Four_Target = 0;
                 Decimal q1_direct_sales = 0;
                 Decimal q2_direct_sales = 0;
                 Decimal q3_direct_sales = 0;
                 Decimal q4_direct_sales = 0;
                 Decimal q1_indirect_sales = 0;
                 Decimal q2_indirect_sales = 0;
                 Decimal q3_indirect_sales = 0;
                 Decimal q4_indirect_sales = 0;
                 Decimal annual_directSales = 0;
                 Decimal annual_indirectSales = 0;
                 Decimal q1_percentage = 0; //Added by BV
                 Decimal q2_percentage = 0; //Added by BV
                 Decimal q3_percentage = 0; //Added by BV
                 Decimal q4_percentage = 0; //Added by BV
                // Decimal quarter_o
                 String salesRepName = '';String empId = '';String salesRepEmailId = '';
                 System.debug('maplist size==>'+maplist.size());
                  for (Achievement_Summary_Table__c sales: maplist.get(salesRep)) {
                      //System.debug('salesRep==>'+maplist.get(salesRep).size());
                      System.debug('quarter1_FirstDate==>'+sales.DateToConsider__c);
                      System.debug('quarter1_EndDate==>'+sales.DateToConsider__c);
                      integer count = 0;
                    if(sales.DateToConsider__c >= quarter1_FirstDate && sales.DateToConsider__c <= quarter1_EndDate ){
                        if(sales.Achieved__c != null){
                            quarter_one_Achieved += sales.Achieved__c;
                          
                        }
						q1_direct_sales += sales.Direct_Sales__c != null ? sales.Direct_Sales__c : 0;
                       	q1_indirect_sales += sales.Indirect_Sales__c != null ? sales.Indirect_Sales__c : 0;

                      
                    }
                    if(sales.DateToConsider__c >= quarter2_FirstDate && sales.DateToConsider__c <= quarter2_EndDate ){
                        if(sales.Achieved__c != null){
                            quarter_two_Achieved += sales.Achieved__c;
                        }
                   		q2_direct_sales += sales.Direct_Sales__c != null ? sales.Direct_Sales__c : 0;
                        q2_indirect_sales += sales.Indirect_Sales__c != null ? sales.Indirect_Sales__c : 0;
                    }
                    if(sales.DateToConsider__c >= quarter3_FirstDate && sales.DateToConsider__c <= quarter3_EndDate ){
                        if(sales.Achieved__c != null){
                            System.debug('sales.Achieved__c q3==>'+sales.Achieved__c);
                            quarter_three_Achieved += sales.Achieved__c;
                        }
                       q3_direct_sales += sales.Direct_Sales__c != null ? sales.Direct_Sales__c : 0;
  					   q3_indirect_sales += sales.Indirect_Sales__c != null ? sales.Indirect_Sales__c : 0;
                    }
                   if(sales.DateToConsider__c >= quarter4_FirstDate && sales.DateToConsider__c <= quarter4_EndDate ){
                       if(sales.Achieved__c != null){
                           quarter_four_Achieved += sales.Achieved__c;
                       }
                      q4_direct_sales += sales.Direct_Sales__c != null ? sales.Direct_Sales__c : 0;
 					  q4_indirect_sales += sales.Indirect_Sales__c != null ? sales.Indirect_Sales__c : 0;
                    }
                      
                      //System.debug('maplistforTargets ==>'+maplistforTargets.size());
                      if(maplistforTargets.get(sales.Sales_Rep_Name__c) != null){
                      Sales_Reps_Targets__c target = maplistforTargets.get(sales.Sales_Rep_Name__c);
                      //System.debug('target==>'+target);
                     quarter_one_Target = target.Quarter_1__c != null ? target.Quarter_1__c : 0;
                     quarter_Two_Target = target.Quarter_2__c != null ? target.Quarter_2__c : 0;
                     quarter_Three_Target = target.Quarter_3__c != null ? target.Quarter_3__c : 0;
                     quarter_Four_Target = target.Quarter_4__c != null ? target.Quarter_4__c : 0;
                      }
                     salesRepName = sales.Sales_Rep_Name__c;
                     annual_Achieved = quarter_one_Achieved + quarter_two_Achieved + quarter_three_Achieved + quarter_four_Achieved;
                 	 annual_Target = quarter_one_Target + quarter_Two_Target + quarter_Three_Target + quarter_Four_Target;
                     annual_directSales = q1_direct_sales + q2_direct_sales + q3_direct_sales + q4_direct_sales ; 
                     annual_indirectSales = q1_indirect_sales + q2_indirect_sales + q3_indirect_sales + q4_indirect_sales ; 
					 //q1_percentage = AchievedSalesSummaryHREmailNotification.percentCalculate(quarter_one_Achieved,quarter_one_Target);//Added by BV
                     //q2_percentage = AchievedSalesSummaryHREmailNotification.percentCalculate(quarter_two_Achieved,quarter_Two_Target);//Added by BV
                     //q3_percentage = AchievedSalesSummaryHREmailNotification.percentCalculate(quarter_three_Achieved,quarter_Three_Target);//Added by BV
                     //q4_percentage = AchievedSalesSummaryHREmailNotification.percentCalculate(quarter_four_Achieved,quarter_Four_Target);//Added by BV
                      empId= sales.Employee_Id__c  ; 
                      salesRepEmailId = sales.Sales_Rep_Email_Id__c;
                  }
                  				
                 salesRepName = salesRepName;
                 wrapperClass obj = new wrapperClass();
                 obj.empId = empId;
                 obj.salesRepEmailId = salesRepEmailId;
                 obj.quarter_one_Achieved = quarter_one_Achieved;
                 obj.quarter_two_Achieved = quarter_two_Achieved;
                 obj.quarter_three_Achieved = quarter_three_Achieved;
                 obj.quarter_four_Achieved = quarter_four_Achieved;
                 obj.quarter_one_Target = quarter_one_Target;
                 obj.quarter_Two_Target = quarter_Two_Target;
                 obj.quarter_Three_Target = quarter_Three_Target;
                 obj.quarter_Four_Target = quarter_Four_Target;
                 obj.annual_Achieved = annual_Achieved;
                 obj.annual_Target = annual_Target;
                 obj.salesRepName = salesRepName;
                 obj.q1_direct_sales = q1_direct_sales;
                 obj.q2_direct_sales = q2_direct_sales;
                 obj.q3_direct_sales = q3_direct_sales;
                 obj.q4_direct_sales = q4_direct_sales;
                 obj.q1_indirect_sales = q1_indirect_sales;
                 obj.q2_indirect_sales = q2_indirect_sales;
                 obj.q3_indirect_sales = q3_indirect_sales;
                 obj.q4_indirect_sales = q4_indirect_sales;
                 obj.annual_directSales = annual_directSales;
                 obj.annual_indirectSales = annual_indirectSales;
                 obj.q1_percentage = q1_percentage;//Added by BV
                 obj.q2_percentage = q2_percentage;//Added by BV
                 obj.q3_percentage = q3_percentage;//Added by BV
                 obj.q4_percentage = q4_percentage;//Added by BV
                 wrapperObj.add(obj);
                
             }
         //}
       return wrapperObj;
    }
    
    @AuraEnabled
    Public static List<wrapperClass> getEastDirectIndirectSalesList(){
        List<wrapperClass> wrapperObj = new List<wrapperClass>();
        Map<String, List<Achievement_Summary_Table__c>> maplist = new Map<String, List<Achievement_Summary_Table__c>>();
      	Map<String, Sales_Reps_Targets__c> maplistforTargets = new Map<String, Sales_Reps_Targets__c>();
		
        List<Achievement_Summary_Table__c> directIndirectSales = new List<Achievement_Summary_Table__c>();
        List<Sales_Reps_Targets__c> targetsList = new List<Sales_Reps_Targets__c>();
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
        //AND soldToRebatePercent__c !=:'166462' AND soldToRebatePercent__c !=:'155781'
        directIndirectSales = [select id,Sales_Rep_Email_Id__c,Employee_Id__c,Direct_Sales__c,Indirect_Sales__c,Achieved__c,DateToConsider__c,Sales_Rep_Name__c,Region__c,soldToRebatePercent__c from Achievement_Summary_Table__c where DateToConsider__c >=: fyStartDate AND DateToConsider__c <=: fyEndDate AND Region__c =: 'East'  AND Sales_Rep_Name__c !=:	'Dave Smith' AND  Sales_Rep_Name__c !=:	'Eric Sutherland'  ORDER BY  DateToConsider__c ASC];
      //mapUserIds = [SELECT Id,Username,EmployeeNumber FROM User];
        
        for(Achievement_Summary_Table__c sales : directIndirectSales){ 
            string mapKey = sales.Sales_Rep_Name__c;
            if(maplist.containsKey(mapKey)){
                List < Achievement_Summary_Table__c > tempList = maplist.get(mapKey);
                tempList.add(sales);
                maplist.put(mapKey,tempList);
            }else if(!maplist.containsKey(mapKey)){
                maplist.put(mapKey, new List < Achievement_Summary_Table__c > {
                    sales
                        });
            }
        }
       
        //targetsList = [select id,Quarter_1__c,Quarter_2__c,	Quarter_3__c,Quarter_4__c,User_Name__c,Region__c from Sales_Reps_Targets__c where User_Name__c != null AND Region__c =: 'East'];
        List<Id > parentIds = new List<Id>();
        List<SRx_Target__c> parentRec = [select id from SRx_Target__c where Approval_Status__c =: 'Accepted' and Financial_Year__c =: 'FY24' order by CreatedDate Desc];
        for(SRx_Target__c tr : parentRec){
            parentIds.add(tr.id);
        }
        String parentId='';
        if(parentIds.size()>0){
            parentId = parentIds[0];
        }
        //a1FDL000007kJDI2A2 
     // targetsList =[select id,User_Name__c,SRx_Target__r.Approval_Status__c,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,SRx_Target__r.Financial_Year__c  from Sales_Reps_Targets__c  where   SRx_Target__c ='a1FDL000007kJDI2A2' ORDER BY CreatedDate desc];
      targetsList =[select id,User_Name__c,SRx_Target__r.Approval_Status__c,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,SRx_Target__r.Financial_Year__c  from Sales_Reps_Targets__c  where   SRx_Target__r.Approval_Status__c = 'Accepted' AND Quarter_1__c != null AND SRx_Target__r.Financial_Year__c = 'FY24' AND Region__c =: 'East' AND SRx_Target__c =:parentId ORDER BY CreatedDate desc];

      /*  for(Achievement_Summary_Table__c sales : directIndirectSales){ 
            string mapKey = sales.Sales_Rep_Name__c;
            if(maplist.containsKey(mapKey)){
                List < Achievement_Summary_Table__c > tempList = maplist.get(mapKey);
                tempList.add(sales);
                maplist.put(mapKey,tempList);
            }else if(!maplist.containsKey(mapKey)){
                maplist.put(mapKey, new List < Achievement_Summary_Table__c > {
                    sales
                        });
            }
        }*/
        for(Sales_Reps_Targets__c target : targetsList){ 
            string mapKey = target.User_Name__c;
            if(maplistforTargets.containsKey(mapKey)){
                Sales_Reps_Targets__c  tempList = maplistforTargets.get(mapKey);
                //tempList.add(target);
                maplistforTargets.put(mapKey,tempList);
            }else if(!maplistforTargets.containsKey(mapKey)){
                maplistforTargets.put(mapKey, Target);
                       
            }
        }
        //wrapperObj.totalSalesList = maplist;
        /*quarterly wise summary*/
        date quarter1_FirstDate;date quarter1_EndDate;
        quarter1_FirstDate = currentFYList[0];
        quarter1_EndDate = currentFYList[2].addMonths(1).toStartofMonth().addDays(-1);
        date quarter2_FirstDate;date quarter2_EndDate;
        quarter2_FirstDate = currentFYList[3];
        quarter2_EndDate = currentFYList[5].addMonths(1).toStartofMonth().addDays(-1);
        date quarter3_FirstDate;date quarter3_EndDate;
        quarter3_FirstDate = currentFYList[6];
        quarter3_EndDate = currentFYList[8].addMonths(1).toStartofMonth().addDays(-1);
        date quarter4_FirstDate;date quarter4_EndDate;
        quarter4_FirstDate = currentFYList[9];
        quarter4_EndDate = currentFYList[11].addMonths(1).toStartofMonth().addDays(-1);
         if (maplist != null) {
             for(String salesRep : maplist.KeySet()){
                 Decimal quarter_one_Achieved = 0;
                  Decimal quarter_two_Achieved = 0;
                 Decimal quarter_three_Achieved = 0;
                 Decimal quarter_four_Achieved = 0;
                 Decimal annual_Achieved = 0;
                 Decimal annual_Target = 0;
                 Decimal quarter_one_Target = 0;
                 Decimal quarter_Two_Target = 0;
                 Decimal quarter_Three_Target = 0;
                 Decimal quarter_Four_Target = 0;
                 Decimal q1_direct_sales = 0;
                 Decimal q2_direct_sales = 0;
                 Decimal q3_direct_sales = 0;
                 Decimal q4_direct_sales = 0;
                 Decimal q1_indirect_sales = 0;
                 Decimal q2_indirect_sales = 0;
                 Decimal q3_indirect_sales = 0;
                 Decimal q4_indirect_sales = 0;
                 Decimal annual_directSales = 0;
                 Decimal annual_indirectSales = 0;
                 Decimal q1_percentage = 0;
                 Decimal q2_percentage = 0;
                 Decimal q3_percentage = 0;
                 Decimal q4_percentage = 0;
                 
                // Decimal quarter_o
                 String salesRepName = '';String empId = ''; String salesRepEmailId = '';
                  for (Achievement_Summary_Table__c sales: maplist.get(salesRep)) {
                    if(sales.DateToConsider__c >= quarter1_FirstDate && sales.DateToConsider__c <= quarter1_EndDate ){
                         if(sales.Achieved__c != null)  quarter_one_Achieved += sales.Achieved__c;
                       	q1_direct_sales += sales.Direct_Sales__c != null ? sales.Direct_Sales__c : 0;
                       	q1_indirect_sales += sales.Indirect_Sales__c != null ? sales.Indirect_Sales__c : 0;
                    }
                    if(sales.DateToConsider__c >= quarter2_FirstDate && sales.DateToConsider__c <= quarter2_EndDate ){
                         if(sales.Achieved__c != null)  quarter_two_Achieved += sales.Achieved__c;
                        q2_direct_sales += sales.Direct_Sales__c != null ? sales.Direct_Sales__c : 0;
                       	q2_indirect_sales += sales.Indirect_Sales__c != null ? sales.Indirect_Sales__c : 0;
                    }
                    if(sales.DateToConsider__c >= quarter3_FirstDate && sales.DateToConsider__c <= quarter3_EndDate ){
                         if(sales.Achieved__c != null)  quarter_three_Achieved += sales.Achieved__c;
                        q3_direct_sales += sales.Direct_Sales__c != null ? sales.Direct_Sales__c : 0;
                       	q3_indirect_sales += sales.Indirect_Sales__c != null ? sales.Indirect_Sales__c : 0;
                    }
                   if(sales.DateToConsider__c >= quarter4_FirstDate && sales.DateToConsider__c <= quarter4_EndDate ){
                       if(sales.Achieved__c != null)  quarter_four_Achieved += sales.Achieved__c;
                       q4_direct_sales += sales.Direct_Sales__c != null ? sales.Direct_Sales__c : 0;
                       q4_indirect_sales += sales.Indirect_Sales__c != null ? sales.Indirect_Sales__c : 0;
                    }
                      System.debug('maplistforTargets ==>'+maplistforTargets);
                      if(maplistforTargets.get(sales.Sales_Rep_Name__c) != null){
                      Sales_Reps_Targets__c target = maplistforTargets.get(sales.Sales_Rep_Name__c);
                      System.debug('target==>'+target);
                     quarter_one_Target = target.Quarter_1__c != null ? target.Quarter_1__c : 0;
                     quarter_Two_Target = target.Quarter_2__c != null ? target.Quarter_2__c : 0;
                     quarter_Three_Target = target.Quarter_3__c != null ? target.Quarter_3__c : 0;
                     quarter_Four_Target = target.Quarter_4__c != null ? target.Quarter_4__c : 0;
                      }
                      salesRepName = sales.Sales_Rep_Name__c;
                      annual_Achieved = quarter_one_Achieved + quarter_two_Achieved + quarter_three_Achieved + quarter_four_Achieved;
                      annual_Target = quarter_one_Target + quarter_Two_Target + quarter_Three_Target + quarter_Four_Target;
                      annual_directSales = q1_direct_sales + q2_direct_sales + q3_direct_sales + q4_direct_sales ; 
                      annual_indirectSales = q1_indirect_sales + q2_indirect_sales + q3_indirect_sales + q4_indirect_sales ; 
                      //q1_percentage = AchievedSalesSummaryHREmailNotification.percentCalculate(quarter_one_Achieved,quarter_one_Target);//Added by BV
                      //q2_percentage = AchievedSalesSummaryHREmailNotification.percentCalculate(quarter_two_Achieved,quarter_Two_Target);//Added by BV
                      //q3_percentage = AchievedSalesSummaryHREmailNotification.percentCalculate(quarter_three_Achieved,quarter_Three_Target);//Added by BV
                      //q4_percentage = AchievedSalesSummaryHREmailNotification.percentCalculate(quarter_four_Achieved,quarter_Four_Target);//Added by BV
                       empId= sales.Employee_Id__c  ; 
                       salesRepEmailId = sales.Sales_Rep_Email_Id__c;
                     
                  }
                 salesRepName = salesRepName;
                 wrapperClass obj = new wrapperClass();
                 obj.empId = empId;
                 obj.salesRepEmailId = salesRepEmailId;
                 obj.quarter_one_Achieved = quarter_one_Achieved;
                 obj.quarter_two_Achieved = quarter_two_Achieved;
                 obj.quarter_three_Achieved = quarter_three_Achieved;
                 obj.quarter_four_Achieved = quarter_four_Achieved;
                 obj.quarter_one_Target = quarter_one_Target;
                 obj.quarter_Two_Target = quarter_Two_Target;
                 obj.quarter_Three_Target = quarter_Three_Target;
                 obj.quarter_Four_Target = quarter_Four_Target;
                 obj.annual_Achieved = annual_Achieved;
                 obj.annual_Target = annual_Target;
                 obj.salesRepName = salesRepName;
                 obj.q1_direct_sales = q1_direct_sales;
                 obj.q2_direct_sales = q2_direct_sales;
                 obj.q3_direct_sales = q3_direct_sales;
                 obj.q4_direct_sales = q4_direct_sales;
                 obj.q1_indirect_sales = q1_indirect_sales;
                 obj.q2_indirect_sales = q2_indirect_sales;
                 obj.q3_indirect_sales = q3_indirect_sales;
                 obj.q4_indirect_sales = q4_indirect_sales;
                 obj.annual_directSales = annual_directSales;
                 obj.annual_indirectSales = annual_indirectSales;
                 obj.q1_percentage = q1_percentage;//Added by BV
                 obj.q2_percentage = q2_percentage;//Added by BV
                 obj.q3_percentage = q3_percentage;//Added by BV
                 obj.q4_percentage = q4_percentage;//Added by BV
                 
                 
                 wrapperObj.add(obj);
             }
         }
       return wrapperObj;
    }
    
     @AuraEnabled
     Public static List<wrapperClass> getExcludedEastSalesrepTargetData(){
         List<wrapperClass> wrapperObj = new List<wrapperClass>();
         Map<String, List<Phoenix_SRx_Direct_Sales_Data__c>> maplist = new Map<String, List<Phoenix_SRx_Direct_Sales_Data__c>>();
         List<Phoenix_SRx_Direct_Sales_Data__c> directSales = new List<Phoenix_SRx_Direct_Sales_Data__c>();
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
         
         directSales = [select id,Sales__c,	Billing_Date__c,Phoenix_Sales_Rep__c,Phoenix_Sold_To_Rebate_Recipient__c from Phoenix_SRx_Direct_Sales_Data__c where Billing_Date__c >=: fyStartDate AND Billing_Date__c <=: fyEndDate AND 	(Phoenix_Sold_To_Rebate_Recipient__c	 =: '166462' OR Phoenix_Sold_To_Rebate_Recipient__c	 =: '155781') AND 
                         (Phoenix_Sales_Rep__c =:'Eric Sutherland' OR Phoenix_Sales_Rep__c =:'Mike Alfino' OR Phoenix_Sales_Rep__c =:'Erica Bass' OR Phoenix_Sales_Rep__c =:'Susan Belleavoine' OR Phoenix_Sales_Rep__c =:'Brenda Kern' OR Phoenix_Sales_Rep__c =:'Heather Harris' OR Phoenix_Sales_Rep__c =:'Doris Hartell') ORDER BY Billing_Date__c ASC];
         for(Phoenix_SRx_Direct_Sales_Data__c sales : directSales){ 
             string mapKey = sales.Phoenix_Sales_Rep__c;
             if(maplist.containsKey(mapKey)){
                 List < Phoenix_SRx_Direct_Sales_Data__c > tempList = maplist.get(mapKey);
                 tempList.add(sales);
                 maplist.put(mapKey,tempList);
             }else if(!maplist.containsKey(mapKey)){
                 maplist.put(mapKey, new List < Phoenix_SRx_Direct_Sales_Data__c > {
                     sales
                         });
             }
         }
         
         date quarter1_FirstDate;date quarter1_EndDate;
         quarter1_FirstDate = currentFYList[0];
         quarter1_EndDate = currentFYList[2].addMonths(1).toStartofMonth().addDays(-1);
         date quarter2_FirstDate;date quarter2_EndDate;
         quarter2_FirstDate = currentFYList[3];
         quarter2_EndDate = currentFYList[5].addMonths(1).toStartofMonth().addDays(-1);
         date quarter3_FirstDate;date quarter3_EndDate;
         quarter3_FirstDate = currentFYList[6];
         quarter3_EndDate = currentFYList[8].addMonths(1).toStartofMonth().addDays(-1);
         date quarter4_FirstDate;date quarter4_EndDate;
         quarter4_FirstDate = currentFYList[9];
         quarter4_EndDate = currentFYList[11].addMonths(1).toStartofMonth().addDays(-1);
         if (maplist != null) {
             for(String salesRep : maplist.KeySet()){
                 Decimal quarter_one_Achieved = 0;
                 Decimal quarter_two_Achieved = 0;
                 Decimal quarter_three_Achieved = 0;
                 Decimal quarter_four_Achieved = 0;
                 Decimal annual_Achieved = 0;
                 Decimal annual_Target = 0;
                 String salesRepName = '';
                 for (Phoenix_SRx_Direct_Sales_Data__c sales: maplist.get(salesRep)) {
                     if(sales.Billing_Date__c >= quarter1_FirstDate && sales.Billing_Date__c <= quarter1_EndDate ){
                         if(sales.Sales__c != null)  quarter_one_Achieved += sales.Sales__c;
                        
                     }
                     if(sales.Billing_Date__c >= quarter2_FirstDate && sales.Billing_Date__c <= quarter2_EndDate ){
                         if(sales.Sales__c != null)  quarter_two_Achieved += sales.Sales__c;
                     }
                     if(sales.Billing_Date__c >= quarter3_FirstDate && sales.Billing_Date__c <= quarter3_EndDate ){
                         if(sales.Sales__c != null)  quarter_three_Achieved += sales.Sales__c;
                     }
                     if(sales.Billing_Date__c >= quarter4_FirstDate && sales.Billing_Date__c <= quarter4_EndDate ){
                         if(sales.Sales__c != null)  quarter_four_Achieved += sales.Sales__c;
                     }
                     salesRepName = sales.Phoenix_Sales_Rep__c;
                     annual_Achieved = quarter_one_Achieved + quarter_two_Achieved + quarter_three_Achieved + quarter_four_Achieved;
                     
                 }
                 salesRepName = salesRepName;
                 wrapperClass obj = new wrapperClass();
                 obj.quarter_one_Achieved = quarter_one_Achieved;
                 obj.quarter_two_Achieved = quarter_two_Achieved;
                 obj.quarter_three_Achieved = quarter_three_Achieved;
                 obj.quarter_four_Achieved = quarter_four_Achieved;
                 obj.annual_Achieved = annual_Achieved;
                 obj.salesRepName = salesRepName;
                 wrapperObj.add(obj);
             }
         }
         return wrapperObj;
     }
    
     @AuraEnabled
     Public static List<wrapperClass> getExcludedWestSalesrepTargetData(){
         List<wrapperClass> wrapperObj = new List<wrapperClass>();
         Map<String, List<Phoenix_SRx_Direct_Sales_Data__c>> maplist = new Map<String, List<Phoenix_SRx_Direct_Sales_Data__c>>();
         List<Phoenix_SRx_Direct_Sales_Data__c> directSales = new List<Phoenix_SRx_Direct_Sales_Data__c>();
		 Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
         List<Date> currentFYList= new List<Date>();
         date fyDate;date fyStartDate;date fyEndDate;
       
    /*     for(integer i=3;i<=14;i++){
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
         
		directSales = [select id,Sales__c,	Billing_Date__c,Phoenix_Sales_Rep__c,Phoenix_Sold_To_Rebate_Recipient__c from Phoenix_SRx_Direct_Sales_Data__c where Billing_Date__c >=: fyStartDate AND Billing_Date__c <=: fyEndDate AND 	(Phoenix_Sold_To_Rebate_Recipient__c	 =: '166462' OR Phoenix_Sold_To_Rebate_Recipient__c	 =: '155781') AND 
                         (Phoenix_Sales_Rep__c =:'Nathan Cumme' OR Phoenix_Sales_Rep__c =:'Andre White' OR Phoenix_Sales_Rep__c =:'Angela Hattaway' OR Phoenix_Sales_Rep__c =:'Zack McClard' OR Phoenix_Sales_Rep__c =:'Kristi Dodge' OR Phoenix_Sales_Rep__c =:'Willi Toups' OR Phoenix_Sales_Rep__c =:'Dave Smith') ORDER BY Billing_Date__c ASC];
         system.debug('directSales'+directSales);
         for(Phoenix_SRx_Direct_Sales_Data__c sales : directSales){ 
             string mapKey = sales.Phoenix_Sales_Rep__c;
             if(maplist.containsKey(mapKey)){
                 List < Phoenix_SRx_Direct_Sales_Data__c > tempList = maplist.get(mapKey);
                 tempList.add(sales);
                 maplist.put(mapKey,tempList);
             }else if(!maplist.containsKey(mapKey)){
                 maplist.put(mapKey, new List < Phoenix_SRx_Direct_Sales_Data__c > {
                     sales
                         });
             }
         }
         
         date quarter1_FirstDate;date quarter1_EndDate;
         quarter1_FirstDate = currentFYList[0];
         quarter1_EndDate = currentFYList[2].addMonths(1).toStartofMonth().addDays(-1);
         date quarter2_FirstDate;date quarter2_EndDate;
         quarter2_FirstDate = currentFYList[3];
         quarter2_EndDate = currentFYList[5].addMonths(1).toStartofMonth().addDays(-1);
         date quarter3_FirstDate;date quarter3_EndDate;
         quarter3_FirstDate = currentFYList[6];
         quarter3_EndDate = currentFYList[8].addMonths(1).toStartofMonth().addDays(-1);
         date quarter4_FirstDate;date quarter4_EndDate;
         quarter4_FirstDate = currentFYList[9];
         quarter4_EndDate = currentFYList[11].addMonths(1).toStartofMonth().addDays(-1);
         if (maplist != null) {
             for(String salesRep : maplist.KeySet()){
                 Decimal quarter_one_Achieved = 0;
                 Decimal quarter_two_Achieved = 0;
                 Decimal quarter_three_Achieved = 0;
                 Decimal quarter_four_Achieved = 0;
                 Decimal annual_Achieved = 0;
                 Decimal annual_Target = 0;
                 String salesRepName = '';
                 for (Phoenix_SRx_Direct_Sales_Data__c sales: maplist.get(salesRep)) {
                     if(sales.Billing_Date__c >= quarter1_FirstDate && sales.Billing_Date__c <= quarter1_EndDate ){
                         if(sales.Sales__c != null)  quarter_one_Achieved += sales.Sales__c;
                        
                     }
                     if(sales.Billing_Date__c >= quarter2_FirstDate && sales.Billing_Date__c <= quarter2_EndDate ){
                         if(sales.Sales__c != null)  quarter_two_Achieved += sales.Sales__c;
                     }
                     if(sales.Billing_Date__c >= quarter3_FirstDate && sales.Billing_Date__c <= quarter3_EndDate ){
                         if(sales.Sales__c != null)  quarter_three_Achieved += sales.Sales__c;
                     }
                     if(sales.Billing_Date__c >= quarter4_FirstDate && sales.Billing_Date__c <= quarter4_EndDate ){
                         if(sales.Sales__c != null)  quarter_four_Achieved += sales.Sales__c;
                     }
                     salesRepName = sales.Phoenix_Sales_Rep__c;
                     annual_Achieved = quarter_one_Achieved + quarter_two_Achieved + quarter_three_Achieved + quarter_four_Achieved;
                     
                 }
                 salesRepName = salesRepName;
                 wrapperClass obj = new wrapperClass();
                 obj.quarter_one_Achieved = quarter_one_Achieved;
                 obj.quarter_two_Achieved = quarter_two_Achieved;
                 obj.quarter_three_Achieved = quarter_three_Achieved;
                 obj.quarter_four_Achieved = quarter_four_Achieved;
                 obj.annual_Achieved = annual_Achieved;
                 obj.salesRepName = salesRepName;
                 wrapperObj.add(obj);
             }
         }
         return wrapperObj;
     }
    
    
    @AuraEnabled 
    public static String getVisionUpdateDate()
    {
        DateTime IDNrecTime = [select CreatedDate from IDN_Charge_Back__c order by CreatedDate DESC limit 1].CreatedDate;
        DateTime DirctrecTime = [select CreatedDate from SRx_DirectSales_SummaryTable__c order by CreatedDate DESC limit 1].CreatedDate;
        
        return IDNrecTime > DirctrecTime ? IDNrecTime.format('MMM dd, yyyy')  :  DirctrecTime.format('MMM dd, yyyy');
    }
    
    public class wrapperClass{
     // @AuraEnabled public Map<String, List<Achievement_Summary_Table__c>> totalSalesList;
     @AuraEnabled public Decimal quarter_one_Achieved;
     @AuraEnabled public Decimal quarter_two_Achieved;
     @AuraEnabled public Decimal quarter_three_Achieved;
     @AuraEnabled public Decimal quarter_four_Achieved;
     @AuraEnabled public Decimal quarter_one_Target;
     @AuraEnabled public Decimal quarter_Two_Target;
     @AuraEnabled public Decimal quarter_Three_Target;
     @AuraEnabled public Decimal quarter_Four_Target;
     @AuraEnabled public Decimal annual_Achieved;
     @AuraEnabled public Decimal annual_Target;
     @AuraEnabled public String salesRepName;
     @AuraEnabled public Decimal  q1_direct_sales;
     @AuraEnabled public Decimal  q2_direct_sales;
     @AuraEnabled public Decimal  q3_direct_sales;
     @AuraEnabled public Decimal  q4_direct_sales;
     @AuraEnabled public Decimal  annual_directSales;
     @AuraEnabled public Decimal  q1_indirect_sales;
     @AuraEnabled public Decimal  q2_indirect_sales;
     @AuraEnabled public Decimal  q3_indirect_sales;
     @AuraEnabled public Decimal  q4_indirect_sales;
     @AuraEnabled public Decimal  annual_indirectSales;
     @AuraEnabled public Decimal q1_percentage;//Added by BV
     @AuraEnabled public Decimal q2_percentage;//Added by BV
     @AuraEnabled public Decimal q3_percentage;//Added by BV
     @AuraEnabled public Decimal q4_percentage;//Added by BV
     @AuraEnabled public String  empId;
     @AuraEnabled public String  salesRepEmailId;
    }
}