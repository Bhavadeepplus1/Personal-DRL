public class Vision_Tab1_IDNChargebackCls {
    @AuraEnabled(Cacheable=true)
    public static String getuser(){
        String userid = UserInfo.getUserId();
        return userid;
    }
    @AuraEnabled(Cacheable=true)
    public static List<String> getKeys(){
        List<Date> currentsixmonthsDatelist= new List<Date>();
        date currentDates;
        for(Integer i=1;i<=6;i++){
            currentDates = System.today().addMonths(-i+1).toStartOfMonth();//getting current 6 months dates
            currentsixmonthsDatelist.add(currentDates);//adding current 6 months to list
        }
        date currentDate = currentsixmonthsDatelist[0].addMonths(1).toStartofMonth().addDays(-1);
        date lastDate = currentsixmonthsDatelist[5];
         /*for current six months keys*/
        List<String> currentSixMonthKeys = new List<String>();
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
        for(Integer i=0; i <currentsixmonthsDatelist.size();i++){
            month = currentsixmonthsDatelist[i].Month();
            year = currentsixmonthsDatelist[i].Year();
            yearinTwodg = String.valueOf(year).right(2);
            monthname = monthdatelist.get(month);
            month_year = monthname+'-'+yearinTwodg;
            currentSixMonthKeys.add(month_year);
            
            
        }
        /*End for current six months keys*/
        return currentSixMonthKeys;
    }
      @AuraEnabled(Cacheable=true)
    public static list<AggregateResult> getAVG_Total(string salesTerritory){
          set<string> hospitalnames = new set<string>();
       // system.debug('hospitalname---'+hospitalname);
        //if(hospitalname == null){
          string name1  = UserInfo.getlAstName();
        String name2 = '%'+name1+'%';
        string userLastName;
        if(salesTerritory != null){
        User u = [select Id,LastName from User where Id=: salesTerritory];
        userLastName = u.LastName;
        }else{
            userLastName = userInfo.getLastName();
            system.debug('salesTerritory in else==>'+userLastName);
        }
        String searchUserKey = '%'+userLastName+'%';
         List<Date> currentsixmonthsDatelist= new List<Date>();
        date currentDates;
        for(Integer i=1;i<=6;i++){
            currentDates = System.today().addMonths(-i+1).toStartOfMonth();//getting current 6 months dates
            currentsixmonthsDatelist.add(currentDates);//adding current 6 months to list
        }
        date currentDate = currentsixmonthsDatelist[0].addMonths(1).toStartofMonth().addDays(-1);
        date lastDate = currentsixmonthsDatelist[5];
       String SobjectApiName = 'IDN_Charge_Back_Hospital_Summary__c ';
     // string groupedResults = ' select sum(Contract_Sales_Indirect_Price__c) totalsalesPrice ,sum(contract_units_paid_qty__c) totalunits,AVG(Contract_Sales_Indirect_Price__c) avgsalesPrice,AVG(contract_units_paid_qty__c) avgunits,count(ID)  from ' + SobjectApiName + ' where  Sales_Rep_Territory__c like: searchUserKey AND Settlement_Paid_Date__c >=: lastDate AND Settlement_Paid_Date__c <=: currentDate ' ;

    AggregateResult[] groupedResults = [select sum(Contract_Sales_Indirect_Price__c) totalsalesPrice ,sum(contract_units_paid_qty__c) totalunits,AVG(Contract_Sales_Indirect_Price__c) avgsalesPrice,AVG(contract_units_paid_qty__c) avgunits,count(ID) from  IDN_Charge_Back_Hospital_Summary__c where Sales_Rep_Territory__c like:searchUserKey  AND Settlement_Paid_Date__c >=: lastDate AND Settlement_Paid_Date__c <=: currentDate ];
     
         return groupedResults;//Database.query(groupedResults);
    }
    @AuraEnabled(Cacheable=true)
    public static List<wrapperClass> getData(String salesTerritory,String userRegion,list<string> userCategory,list<string> hospitalName,String child1Name,String child2Name,list<string> productFamily,list<string> productDescription,String accountId,list<string> contractDescription,List<String> selectedMemberCity,List<String> selectedMemberState,List<String> submitterName){
        system.debug('accountId==>'+accountId);
        system.debug('salesTerritory==>'+salesTerritory);
        system.debug('userRegion==>'+userRegion);
         system.debug('hospitalName==>'+hospitalName.size());
        system.debug('child1Name==>'+child1Name);
        
        string userLastName;
        if(salesTerritory != null){
        User u = [select Id,LastName from User where Id=: salesTerritory];
        userLastName = u.LastName;
        }else{
            userLastName = userInfo.getLastName();
            system.debug('salesTerritory in else==>'+userLastName);
        }
           
        //List<finalWrapper> wrapperObjectList = new List<finalWrapper>();
        
        String query = '';
        String SobjectApiName = 'IDN_Charge_Back_Hospital_Summary__c';
        List<Date> currentsixmonthsDatelist= new List<Date>();
        date currentDates;
        for(Integer i=1;i<=6;i++){
            currentDates = System.today().addMonths(-i+1).toStartOfMonth();//getting current 6 months dates
            currentsixmonthsDatelist.add(currentDates);//adding current 6 months to list
        }
        date currentDate = currentsixmonthsDatelist[0].addMonths(1).toStartofMonth().addDays(-1);
        date lastDate = currentsixmonthsDatelist[5];
        /*for current six months keys*/
        List<String> currentSixMonthKeys = new List<String>();
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
        for(Integer i=0; i <currentsixmonthsDatelist.size();i++){
            month = currentsixmonthsDatelist[i].Month();
            year = currentsixmonthsDatelist[i].Year();
            yearinTwodg = String.valueOf(year).right(2);
            monthname = monthdatelist.get(month);
            month_year = monthname+'-'+yearinTwodg;
            currentSixMonthKeys.add(month_year);
            
            
        }
        /*End for current six months keys*/
        
        
        
        string monthyear = 'Oct-22';
        string hospital_name = 'Methodist Hospitals';
     // Hospital_Name__c =:hospitalName
        //Month_Year__c =: month_year and
        String searchUserKey = '%'+userLastName+'%';
       // List<Account> accIds = [select Id,texcellency__DefHC_HospitalID__c from Account];
       List<String> definitiveIds  = new List<String>();
        String hsptlName= 'University of Wisconsin Health (AKA UW Health)';
        String hsptlName2=' Advocate Aurora Health';
        //for(Account acc:accIds){
        //  definitiveIds.add(String.valueOf(acc.texcellency__DefHC_HospitalID__c));
        //}
        // AND Hospital_Name__c =:hsptlName
        query = 'select Account__c,Account__r.Name,Sales_Rep_Territory__c,Region__c,member_city__c,Member_State__c, Submitter_Name__c,Category__c, Product__r.Name,Contact_Description__c,Hospital_Name__c,Child1_Name__c,Child2_Name__c,revised_product_family__c, material_description__c,Settlement_Paid_Date__c,Month_Year__c,Paid_Chargeback_Amount__c,Contract_Sales_Indirect_Price__c,contract_units_paid_qty__c  from ' + SobjectApiName + ' where Settlement_Paid_Date__c >=: lastDate and Settlement_Paid_Date__c <=:currentDate AND Sales_Rep_Territory__c like: searchUserKey ' ;
       
        List<String> regions = new List<String>{'East', 'West', 'White Space',''};
        if(userRegion != null){
            if(userRegion == 'All'){
                System.debug('in inside if all');
                query += ' AND Region__c IN: regions ';
            }else{
               System.debug('in inside else all');
               query += ' AND Region__c =: userRegion ';  
            }
        }
       
        if(userCategory.size()>0){
            
            query += ' AND Category__c in : userCategory ';
        }
         if(selectedMemberState.size()>0){
            
            query += ' AND Member_State__c in : selectedMemberState';
        }
       
         if(child1Name != null){
             System.debug('inside child1Name==>'+child1Name);
             String searchChild1Key = '%'+child1Name+'%';
           query += ' AND Child1_Name__c like: searchChild1Key ';   
         }
         if(child2Name != null){
             System.debug('inside child2Name==>'+child2Name);
             String searchChild2Key = '%'+child2Name+'%';
           query += ' AND Child2_Name__c like: searchChild2Key ';   
         }
      
         if(hospitalName.size()>0){
            
            query += ' AND Hospital_Name__c in : hospitalName';
        }
         if(productFamily.size()>0){
            
            query += ' AND revised_product_family__c in : productFamily ';
        }
      
        if(productDescription.size()>0){
            
            query += ' AND material_description__c in : productDescription ';
        }
      
         if(submitterName.size()>0){
            
            query += ' AND Submitter_Name__c in : submitterName ';
        }        
        if(contractDescription.size()>0){
            
            query += ' AND Contact_Description__c in : contractDescription ';
        }
        if(selectedMemberCity.size()>0){
            
            query += ' AND member_city__c in : selectedMemberCity ';
        }
         query += ' Order By Contract_Sales_Indirect_Price__c DESC ';
        Map<string,list < IDN_Charge_Back_Hospital_Summary__c >> maplist = new Map<String,list < IDN_Charge_Back_Hospital_Summary__c >>();
        list < IDN_Charge_Back_Hospital_Summary__c > idnchargebackList = Database.query(query);
        List<string> hospitallist = new List<string>();
        for(IDN_Charge_Back_Hospital_Summary__c chargebacrec : idnchargebackList){
                if(!maplist.containsKey(chargebacrec.Hospital_Name__c))
                    maplist.put(chargebacrec.Hospital_Name__c, new list<IDN_Charge_Back_Hospital_Summary__c>());
                maplist.get(chargebacrec.Hospital_Name__c).add(chargebacrec);
                hospitallist.add(chargebacrec.Hospital_Name__c);
                
            }
        List<wrapperClass> wrapperObjList = new List<wrapperClass>();
        for(string eachHos : hospitallist){
            Map<String,wrapperClass> finalMap = new Map<String,wrapperClass>();
            list<IDN_Charge_Back_Hospital_Summary__c> finalList = maplist.get(eachHos);
             if(finalList != null && !finalList.isEmpty()){
                 for(IDN_Charge_Back_Hospital_Summary__c chargebackrec : finalList){
                    /* if(finalMap.containsKey(chargebackrec.Settlement_Paid_Date__c)){
                         if(chargebackrec.Contract_Sales_Indirect_Price__c != null && wrapObj.col1sales != null){
                            wrapObj.col1sales = wrapObj.col1sales+salesExt.Contract_Sales_Indirect_Price__c;
                        }
                     }else{
                         wrapperClass wrapObj = new wrapperClass();
                         wrapObj.col1sales = chargebackrec.Contract_Sales_Indirect_Price__c;
                         wrapObj.col1units = chargebackrec.contract_units_paid_qty__c;
                         finalMap.put(chargebackrec.Settlement_Paid_Date__c,wrapObj);

                     }*/
                     //wrapperObjList.add(wrpObj);
                 }
             }
        }
        return wrapperObjList;
    }
 public class wrapperClass{
        @AuraEnabled public Decimal col1sales;
        @AuraEnabled public Decimal col1units;
       
 }
   
}