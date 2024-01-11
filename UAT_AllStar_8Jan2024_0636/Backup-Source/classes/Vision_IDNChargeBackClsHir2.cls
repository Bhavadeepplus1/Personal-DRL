public class Vision_IDNChargeBackClsHir2 {
         @AuraEnabled(Cacheable=true)
    public static String getuser(){
        String userid = UserInfo.getUserId();
        return userid;
    }
    
    @AuraEnabled(Cacheable=true)
    public static list<string> getRegion (string salesTerritoryId){
        System.debug('salesTerritoryId==>'+salesTerritoryId);
        set<string> regions = new set<string>();
        string userLastName;
        if(salesTerritoryId != null){
        User u = [select Id,LastName from User where Id=: salesTerritoryId];
        userLastName = u.LastName;
        }else{
            userLastName = userInfo.getLastName();
            system.debug('salesTerritory in else==>'+userLastName);
        }
        String searchUserKey = '%'+userLastName+'%';
        list<AggregateResult > chargebackList = [select T2_Region__c ,count(ID) from  IDN_Charge_Back_Hospital_Summary__c where T2_Sales_Rep_Territory__c like:searchUserKey Group by T2_Region__c ];
         System.debug('chargebackList==>'+chargebackList);
        for(AggregateResult  ss:chargebackList){
           regions.add((String)ss.get('T2_Region__c'));
       }
        List<String> regionslist = new List<String>(regions);
        System.debug('regionslist==>'+regionslist);
        return regionslist;
        
    }
    
    @AuraEnabled(Cacheable=true)
    public static list<string> getcategory(string salesTerritoryId){
        set<string> categorynames = new set<string>();
        string userLastName;
        if(salesTerritoryId != null){
            User u = [select Id,LastName from User where Id=: salesTerritoryId];
            userLastName = u.LastName;
        }else{
            userLastName = userInfo.getLastName();
            system.debug('salesTerritory in else==>'+userLastName);
        }
        String searchUserKey = '%'+userLastName+'%';
        list<AggregateResult > chargebackList = [select T2_Category__c ,count(ID) from  IDN_Charge_Back_Hospital_Summary__c where T2_Sales_Rep_Territory__c like:searchUserKey Group by T2_Category__c ];
        for(AggregateResult  ss:chargebackList){
            categorynames.add((String)ss.get('T2_Category__c'));
        }
        List<String> categorynameslist = new List<String>(categorynames);
        return categorynameslist;
    }

    @AuraEnabled(Cacheable=true)
    public static list<string> getHospitalNames(string salesTerritoryId){
        set<string> hospitalnames = new set<string>();
        string name1  = UserInfo.getlAstName();
        String name2 = '%'+name1+'%';
         string userLastName;
        if(salesTerritoryId != null){
        User u = [select Id,LastName from User where Id=: salesTerritoryId];
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
        list<AggregateResult > chargebackList = [select T2_Hospital_Name__c ,count(ID) from  IDN_Charge_Back_Hospital_Summary__c where T2_Sales_Rep_Territory__c like:searchUserKey  AND T2_Settlement_Paid_Date__c >=: lastDate and T2_Settlement_Paid_Date__c <=:currentDate Group by T2_Hospital_Name__c ];
        
        for(AggregateResult  ss:chargebackList){
           hospitalnames.add((String)ss.get('T2_Hospital_Name__c'));
       }
        List<String> hospitalnameslist = new List<String>(hospitalnames);
        return hospitalnameslist;
    }
     
     @AuraEnabled(Cacheable=true)
    public static list<string> getProductNames(string salesTerritoryId){
          set<string> productFamNames = new set<string>();
       // system.debug('hospitalname---'+hospitalname);
        //if(hospitalname == null){
          string name1  = UserInfo.getlAstName();
        String name2 = '%'+name1+'%';
        string userLastName;
        if(salesTerritoryId != null){
        User u = [select Id,LastName from User where Id=: salesTerritoryId];
        userLastName = u.LastName;
        }else{
            userLastName = userInfo.getLastName();
            system.debug('salesTerritory in else==>'+userLastName);
        }
        String searchUserKey = '%'+userLastName+'%';
     list<AggregateResult > chargebackList = [select T2_revised_product_family__c ,count(ID) from  IDN_Charge_Back_Hospital_Summary__c where T2_Sales_Rep_Territory__c like:searchUserKey Group by T2_revised_product_family__c ];
        
        for(AggregateResult  ss:chargebackList){
           productFamNames.add((String)ss.get('T2_revised_product_family__c'));
       }
      List<String> productFamNamesList = new List<String>(productFamNames);
        return productFamNamesList;
    }
      
     @AuraEnabled(Cacheable=true)
    public static list<string> getProducts(string salesTerritoryId){
          set<string> products = new set<string>();
       // system.debug('hospitalname---'+hospitalname);
        //if(hospitalname == null){
          string name1  = UserInfo.getlAstName();
        String name2 = '%'+name1+'%';
        string userLastName;
        if(salesTerritoryId != null){
        User u = [select Id,LastName from User where Id=: salesTerritoryId];
        userLastName = u.LastName;
        }else{
            userLastName = userInfo.getLastName();
            system.debug('salesTerritory in else==>'+userLastName);
        }
        String searchUserKey = '%'+userLastName+'%';
        list<AggregateResult > chargebackList = [select T2_material_description__c ,count(ID) from  IDN_Charge_Back_Hospital_Summary__c where T2_Sales_Rep_Territory__c like:searchUserKey Group by T2_material_description__c ];
        
        for(AggregateResult  ss:chargebackList){
           products.add((String)ss.get('T2_material_description__c'));
       }
      List<String> productsList = new List<String>(products);
        return productsList;
    }
    
        
   /*     @AuraEnabled(Cacheable=true)
    public static list<string> getcontracts(){
          set<string> hospitalnames = new set<string>();
       // system.debug('hospitalname---'+hospitalname);
        //if(hospitalname == null){
         string name1  = UserInfo.getlAstName();
        String name2 = '%'+name1+'%';
       list<AggregateResult > chargebackList = [select Contact_Description__c ,count(ID) from  IDN_Charge_Back__c where Sales_Rep_Territory__c like:name2 Group by Contact_Description__c ];
        
        for(AggregateResult  ss:chargebackList){
           hospitalnames.add((String)ss.get('Contact_Description__c'));
       }
      List<String> hospitalnameslist = new List<String>(hospitalnames);
        return hospitalnameslist;
    }*/
    
      @AuraEnabled(Cacheable=true)
    public static list < AggregateResult > getContrcts(string searchInput,string salesTerritoryId){
        string name1  = UserInfo.getlAstName();
        String name2 = '%'+name1+'%';
        String query;
        string userLastName;
        if(salesTerritoryId != null){
        User u = [select Id,LastName from User where Id=: salesTerritoryId];
        userLastName = u.LastName;
        }else{
            userLastName = userInfo.getLastName();
            system.debug('salesTerritory in else==>'+userLastName);
        }
        String searchUserKey = '%'+userLastName+'%';
      // list<AggregateResult > chargebackList = [select Contact_Description__c ,count(ID) from  IDN_Charge_Back__c where Sales_Rep_Territory__c like:name2 Group by Contact_Description__c ];
	query = 'select T2_Contact_Description__c,count(ID)  from IDN_Charge_Back_Hospital_Summary__c  where T2_Sales_Rep_Territory__c like:searchUserKey  ';
      if(searchInput != null){
             System.debug('searchInput==>'+searchInput);
             String searchInputKey = '%'+searchInput+'%';
           query += ' AND T2_Contact_Description__c like: searchInputKey ';   
         }
        query += ' Group by T2_Contact_Description__c '; 
        list < AggregateResult > cntList = Database.query(query); 
        
        return cntList;
        
    }
    
     
     @AuraEnabled(Cacheable=true)
    public static list<string> getmembericty(string salesTerritoryId){
          set<string> membercitynames = new set<string>();
       // system.debug('hospitalname---'+hospitalname);
        //if(hospitalname == null){
          string name1  = UserInfo.getlAstName();
        String name2 = '%'+name1+'%';
         string userLastName;
        if(salesTerritoryId != null){
        User u = [select Id,LastName from User where Id=: salesTerritoryId];
        userLastName = u.LastName;
        }else{
            userLastName = userInfo.getLastName();
            system.debug('salesTerritory in else==>'+userLastName);
        }
        String searchUserKey = '%'+userLastName+'%';
       list<AggregateResult > chargebackList = [select T2_member_city__c ,count(ID) from  IDN_Charge_Back_Hospital_Summary__c where T2_Sales_Rep_Territory__c like:searchUserKey Group by T2_member_city__c ];
        
        for(AggregateResult  ss:chargebackList){
           membercitynames.add((String)ss.get('T2_member_city__c'));
       }
      List<String> membercitieslist = new List<String>(membercitynames);
        return membercitieslist;
    }
   
    @AuraEnabled(Cacheable=true)
    public static list<string> getmemberstate(string salesTerritoryId){
          set<string> statenames = new set<string>();
       // system.debug('hospitalname---'+hospitalname);
        //if(hospitalname == null){
          string name1  = UserInfo.getlAstName();
        String name2 = '%'+name1+'%';
         string userLastName;
        if(salesTerritoryId != null){
        User u = [select Id,LastName from User where Id=: salesTerritoryId];
        userLastName = u.LastName;
        }else{
            userLastName = userInfo.getLastName();
            system.debug('salesTerritory in else==>'+userLastName);
        }
        String searchUserKey = '%'+userLastName+'%';
       list<AggregateResult > chargebackList = [select T2_Member_State__c ,count(ID) from  IDN_Charge_Back_Hospital_Summary__c where T2_Sales_Rep_Territory__c like:searchUserKey Group by T2_Member_State__c ];
        
        for(AggregateResult  ss:chargebackList){
           statenames.add((String)ss.get('T2_Member_State__c'));
       }
      List<String> statenameslist = new List<String>(statenames);
        return statenameslist;
    }
       @AuraEnabled(Cacheable=true)
    public static list<string> getsubmitters(string salesTerritoryId){
          set<string> submitternames = new set<string>();
       // system.debug('hospitalname---'+hospitalname);
        //if(hospitalname == null){
          string name1  = UserInfo.getlAstName();
        String name2 = '%'+name1+'%';
        string userLastName;
        if(salesTerritoryId != null){
        User u = [select Id,LastName from User where Id=: salesTerritoryId];
        userLastName = u.LastName;
        }else{
            userLastName = userInfo.getLastName();
            system.debug('salesTerritory in else==>'+userLastName);
        }
        String searchUserKey = '%'+userLastName+'%';
        list<AggregateResult > chargebackList = [select T2_Submitter_Name__c ,count(ID) from  IDN_Charge_Back_Hospital_Summary__c where T2_Sales_Rep_Territory__c like:searchUserKey Group by T2_Submitter_Name__c ];
        
        for(AggregateResult  ss:chargebackList){
           submitternames.add((String)ss.get('T2_Submitter_Name__c'));
       }
      List<String> submitternameslist = new List<String>(submitternames);
        return submitternameslist;
    } 
    /*using tab2 summary batch*/
    @AuraEnabled(Cacheable=true)
    public static List<finalWrapper> getDatafromTab2SummaryBatch(String salesTerritory,list<String> userRegion,list<string> userCategory,list<string> hospitalName,String child1Name,String child2Name,list<string> productFamily,list<string> productDescription,String accountId,list<string> contractDescription,List<String> selectedMemberCity,List<String> selectedMemberState,List<String> submitterName){
        
        string userLastName;
        if(salesTerritory != null){
        User u = [select Id,LastName from User where Id=: salesTerritory];
        userLastName = u.LastName;
        }else{
            userLastName = userInfo.getLastName();
            system.debug('salesTerritory in else==>'+userLastName);
        }
        List<finalWrapper> wrapperObjectList = new List<finalWrapper>();
        Map<string,finalWrapper> maplist = new Map<String,finalWrapper>();
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
        String searchUserKey = '%'+userLastName+'%';
       /* List<Account> accIds = [select Id,texcellency__DefHC_HospitalID__c from Account];
       List<String> definitiveIds  = new List<String>();
        
        for(Account acc:accIds){
          definitiveIds.add(String.valueOf(acc.texcellency__DefHC_HospitalID__c));
        }*/
        String hsptlName= 'AdventHealth (FKA Adventist Health System)';
        String hsptlName2='Advocate Aurora Health';
      //T2_Hospital_Name__c=: hsptlName2 AND
        string level = 'Middle';
        query = 'select T2_Account__c,T2_Account__r.Name,T2_Sales_Rep_Territory__c,T2_Region__c,T2_member_city__c,T2_Member_State__c, T2_Submitter_Name__c,T2_Category__c, T2_Product__r.Name,T2_Contact_Description__c,T2_Hospital_Name__c,T2_Child1_Name__c,T2_Child2_Name__c,T2_revised_product_family__c,T2_material_description__c,T2_Settlement_Paid_Date__c,T2_Month_Year__c,T2_Paid_Chargeback_Amount__c,T2_Contract_Sales_Indirect_Price__c,T2_contract_units_paid_qty__c  from ' + SobjectApiName + ' where   T2_Settlement_Paid_Date__c >=: lastDate and T2_Settlement_Paid_Date__c <=:currentDate AND T2_Sales_Rep_Territory__c like: searchUserKey  ' ;
       if(userRegion.size()>0){
            query += ' AND T2_Region__c in : userRegion ';
        }
        if(userCategory.size()>0){
            query += ' AND T2_Category__c in : userCategory ';
        }
         if(selectedMemberState.size()>0){
            query += ' AND T2_Member_State__c in : selectedMemberState ';
        }
        if(child1Name != null){
             System.debug('inside child1Name==>'+child1Name);
             String searchChild1Key = '%'+child1Name+'%';
           query += ' AND T2_Child1_Name__c like: searchChild1Key ';   
         }
         if(child2Name != null){
             System.debug('inside child2Name==>'+child2Name);
             String searchChild2Key = '%'+child2Name+'%';
           query += ' AND T2_Child2_Name__c like: searchChild2Key ';   
         }
         if(hospitalName.size()>0){
            query += ' AND T2_Hospital_Name__c in : hospitalName';
        }
         if(productFamily.size()>0){
            query += ' AND T2_revised_product_family__c in : productFamily ';
        }
        if(productDescription.size()>0){
            query += ' AND T2_material_description__c in : productDescription ';
        }
		if(submitterName.size()>0){
            query += ' AND T2_Submitter_Name__c in : submitterName ';
        }        
        if(contractDescription.size()>0){
            query += ' AND T2_Contact_Description__c in : contractDescription ';
        }
        if(selectedMemberCity.size()>0){
            query += ' AND T2_member_city__c in : selectedMemberCity ';
        }
         query += ' Order By T2_Contract_Sales_Indirect_Price__c DESC ';
        list < IDN_Charge_Back_Hospital_Summary__c > idnchargebackList = Database.query(query);
        for(IDN_Charge_Back_Hospital_Summary__c chargebackRec : idnchargebackList){
            if(maplist.containsKey(chargebackRec.T2_Hospital_Name__c) ){
                finalWrapper wrapperObjec = maplist.get(chargebackRec.T2_Hospital_Name__c);
                
                wrapperObjec.idnchargebackList.add(chargebackRec);// = new List<IDN_Charge_Back__c>{chargebackRec};
                maplist.put(chargebackRec.T2_Hospital_Name__c,wrapperObjec);
                
            }else{
                finalWrapper wrapperObjec = new finalWrapper();
                wrapperObjec.hospitalName = chargebackRec.T2_Hospital_Name__c;
                wrapperObjec.accountId = chargebackRec.T2_Account__c;
                wrapperObjec.showItem = true;
                wrapperObjec.idnchargebackList = new List<IDN_Charge_Back_Hospital_Summary__c>{chargebackRec};
                wrapperObjec.currentSixMonthKeys = currentSixMonthKeys;
                maplist.put(chargebackRec.T2_Hospital_Name__c,wrapperObjec);
            }
        }
        return maplist.values();
    }

    /*end using  tab2 summary batch*/
/*	@AuraEnabled(Cacheable=true)
    public static List<finalWrapper> getData(String salesTerritory,String userRegion,list<string> userCategory,list<string> hospitalName,String child1Name,String child2Name,list<string> productFamily,list<string> productDescription,String accountId,list<string> contractDescription,List<String> selectedMemberCity,List<String> selectedMemberState,List<String> submitterName){
        string userLastName;
        if(salesTerritory != null){
        User u = [select Id,LastName from User where Id=: salesTerritory];
        userLastName = u.LastName;
        }else{
            userLastName = userInfo.getLastName();
            system.debug('salesTerritory in else==>'+userLastName);
        }
        
        List<finalWrapper> wrapperObjectList = new List<finalWrapper>();
        Map<string,finalWrapper> maplist = new Map<String,finalWrapper>();
      
        String query = '';
        String SobjectApiName = 'IDN_Charge_Back__c';
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
        List<Date> currentsixmonthsDatelist= new List<Date>();
        date currentDates;
        for(Integer i=1;i<=6;i++){
            currentDates = System.today().addMonths(-i+1).toStartOfMonth();//getting current 6 months dates
            currentsixmonthsDatelist.add(currentDates);//adding current 6 months to list
        }
        date currentDate = currentsixmonthsDatelist[0].addMonths(1).toStartofMonth().addDays(-1);
		date lastDate = currentsixmonthsDatelist[5];
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
        string monthyear = 'Oct-22';
        string hospital_name = 'Methodist Hospitals';
        String searchUserKey = '%'+userLastName+'%';
        List<Account> accIds = [select Id,texcellency__DefHC_HospitalID__c from Account];
       List<String> definitiveIds  = new List<String>();
        String hsptlName= 'University of Wisconsin Health (AKA UW Health)';
        String hsptlName2=' Advocate Aurora Health';
        for(Account acc:accIds){
          definitiveIds.add(String.valueOf(acc.texcellency__DefHC_HospitalID__c));
        }
     
        query = 'select Account__c,Account__r.Name,Sales_Rep_Territory__c,Region__c,member_city__c,Member_State__c, Submitter_Name__c,Category__c, Product__r.Name,Contact_Description__c,Hospital_Name__c,Child1_Name__c,Child2_Name__c,revised_product_family__c,	material_description__c,Settlement_Paid_Date__c,Month_Year__c,Paid_Chargeback_Amount__c,Contract_Sales_Indirect_Price__c,contract_units_paid_qty__c  from ' + SobjectApiName + ' where Settlement_Paid_Date__c >=: lastDate and Settlement_Paid_Date__c <=:currentDate AND Sales_Rep_Territory__c like: searchUserKey AND Hospital_Id__c IN:definitiveIds ' ;
      
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
        
        list < IDN_Charge_Back__c > idnchargebackList = Database.query(query);
        for(IDN_Charge_Back__c chargebackRec : idnchargebackList){
            
            if(maplist.containsKey(chargebackRec.Hospital_Name__c) ){
                finalWrapper wrapperObjec = maplist.get(chargebackRec.Hospital_Name__c);
                
                wrapperObjec.idnchargebackList.add(chargebackRec);// = new List<IDN_Charge_Back__c>{chargebackRec};
                
                maplist.put(chargebackRec.Hospital_Name__c,wrapperObjec);
                
            }else{
                finalWrapper wrapperObjec = new finalWrapper();
                wrapperObjec.hospitalName = chargebackRec.Hospital_Name__c;
                wrapperObjec.accountId = chargebackRec.Account__c;
                wrapperObjec.showItem = true;
                wrapperObjec.idnchargebackList = new List<IDN_Charge_Back__c>{chargebackRec};
                wrapperObjec.currentSixMonthKeys = currentSixMonthKeys;
                maplist.put(chargebackRec.Hospital_Name__c,wrapperObjec);
            }
        }
        return maplist.values();
    }*/
 
/*12 months data*/
     @AuraEnabled(Cacheable=true)
    public static List<finalWrapper2> gettwmonthsFullData(String salesTerritory,String userRegion,list<string> userCategory,list<string> hospitalName,String child1Name,String child2Name,list<string> productFamily,list<string> productDescription,String accountId,list<string> contractDescription,List<String> selectedMemberCity,List<String> selectedMemberState,List<String> submitterName){
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
        List<finalWrapper2> wrapperObjectList = new List<finalWrapper2>();
        Map<string,finalWrapper2> maplist = new Map<String,finalWrapper2>();
       // String myTestString = 'NELSON COUNTY HEALTH SYSTEM (SAP)';
		//List<IDN_Charge_Back__c> idnchargebackList = Database.query('SELECT Id,Hospital_Name__c FROM IDN_Charge_Back__c where ');
        String query = '';
        String SobjectApiName = 'IDN_Charge_Back__c';
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
        date currentDates;
        List<Date> currentsixmonthsDatelist= new List<Date>();
        for(Integer i=1;i<=12;i++){
            currentDates = System.today().addMonths(-i+1).toStartOfMonth();//getting current 6 months dates
            currentsixmonthsDatelist.add(currentDates);//adding current 6 months to list
        }
        date currentDate = currentsixmonthsDatelist[0].addMonths(1).toStartofMonth().addDays(-1);
        date lastDate = currentsixmonthsDatelist[11];
        System.debug('currentDate===>'+currentDate);
        System.debug('lastDate===>'+lastDate);
        
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
       /* List<Account> accIds = [select Id,texcellency__DefHC_HospitalID__c from Account];
       List<String> definitiveIds  = new List<String>();
        
        for(Account acc:accIds){
          definitiveIds.add(String.valueOf(acc.texcellency__DefHC_HospitalID__c));
        }*/
        String hsptlName= 'University of Wisconsin Health (AKA UW Health)';
        String hsptlName2=' Advocate Aurora Health';
        // AND Hospital_Name__c =:hsptlName
        query = 'select Account__c,Account__r.Name,Sales_Rep_Territory__c,Region__c,member_city__c,Member_State__c, Submitter_Name__c,Category__c, Product__r.Name,Contact_Description__c,Hospital_Name__c,Child1_Name__c,Child2_Name__c,revised_product_family__c,	material_description__c,Settlement_Paid_Date__c,Month_Year__c,Paid_Chargeback_Amount__c,Contract_Sales_Indirect_Price__c,contract_units_paid_qty__c  from ' + SobjectApiName + ' where Settlement_Paid_Date__c >=: lastDate and Settlement_Paid_Date__c <=:currentDate AND Sales_Rep_Territory__c like: searchUserKey ' ;
       /* if(salesTerritory !=null){
           query += ' AND Sales_Rep_Territory__c like: searchUserKey ';   
        }*/
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
       /* if(userCategory != null){
            if(userCategory == 'All'){
                List<String> categories = new List<String>{'GPO', '340 B', 'IDN','OTHERS','UNDEFINED','WHL SOURCE/ SPECIALTY DIST.'};
                query += ' AND Category__c IN: categories ';
            }else{
               query += ' AND Category__c =: userCategory ';  
            }
        }*/
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
      /*  if(productFamily != null){
            String searchproductFamilyKey = '%'+productFamily+'%';
           query += ' AND revised_product_family__c like: searchproductFamilyKey ';  
        }*/
         if(hospitalName.size()>0){
            
            query += ' AND Hospital_Name__c in : hospitalName';
        }
         if(productFamily.size()>0){
            
            query += ' AND revised_product_family__c in : productFamily ';
        }
       /* if(productDescription != null){
            String searchproductDescriptionKey = '%'+productDescription+'%';
           query += ' AND material_description__c like: searchproductDescriptionKey ';  
        }*/
        if(productDescription.size()>0){
            
            query += ' AND material_description__c in : productDescription ';
        }
       /* if(submitterName != null){
            String searchsubmitterName = '%'+submitterName+'%';
           query += ' AND Submitter_Name__c like: searchsubmitterName ';  
        }*/
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
        
        list < IDN_Charge_Back__c > idnchargebackList = Database.query(query);
        for(IDN_Charge_Back__c chargebackRec : idnchargebackList){
            
            if(maplist.containsKey(chargebackRec.Hospital_Name__c) ){
                finalWrapper2 wrapperObjec = maplist.get(chargebackRec.Hospital_Name__c);
                
                wrapperObjec.idnchargebackList.add(chargebackRec);// = new List<IDN_Charge_Back__c>{chargebackRec};
                maplist.put(chargebackRec.Hospital_Name__c,wrapperObjec);
                
            }else{
                finalWrapper2 wrapperObjec = new finalWrapper2();
                wrapperObjec.hospitalName = chargebackRec.Hospital_Name__c;
                wrapperObjec.accountId = chargebackRec.Account__c;
                wrapperObjec.showItem = true;
                wrapperObjec.idnchargebackList = new List<IDN_Charge_Back__c>{chargebackRec};
                wrapperObjec.currentSixMonthKeys = currentSixMonthKeys;
                maplist.put(chargebackRec.Hospital_Name__c,wrapperObjec);
            }
        }
        
       
        return maplist.values();
    }
    /*end 12 months data*/
 @AuraEnabled
    public static List<finalWrapper2> getprevsixMonthsData(String salesTerritory,String userRegion,String userCategory,String hospitalName,String child1Name,String child2Name,String productFamily,String productDescription,String accountId,list<string> contractDescription){        
       System.debug('salesTerritory==>'+salesTerritory);
        string userLastName;
        if(salesTerritory != null){
        User u = [select Id,LastName from User where Id=: salesTerritory];
        userLastName = u.LastName;
        }else{
            userLastName = userInfo.getLastName();
            system.debug('salesTerritory in else==>'+userLastName);
        }
        List<finalWrapper2> wrapperObjectList = new List<finalWrapper2>();
        Map<string,finalWrapper2> maplist2 = new Map<String,finalWrapper2>();
        List<Date> prevsixMonthsDatelist= new List<Date>();
        date currentDates;
        for(Integer i=6;i<=12;i++){
            currentDates = System.today().addMonths(-i).toStartOfMonth();//getting current 12 months dates
            prevsixMonthsDatelist.add(currentDates);//adding current 12 months to list
        }
        date currentDate = prevsixMonthsDatelist[0].addMonths(1).toStartofMonth().addDays(-1);
        date lastDate = prevsixMonthsDatelist[5];
        System.debug('currentDate==>'+currentDate);
        System.debug('lastDate==>'+lastDate);
         /*for prev six months keys*/
        List<String> prevSixMonthKeys = new List<String>();
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
        for(Integer i=0; i <prevsixMonthsDatelist.size();i++){
            month = prevsixMonthsDatelist[i].Month();
            year = prevsixMonthsDatelist[i].Year();
            yearinTwodg = String.valueOf(year).right(2);
            monthname = monthdatelist.get(month);
            month_year = monthname+'-'+yearinTwodg;
            prevSixMonthKeys.add(month_year);
            
            
        }
        /*End for last six months keys*/

        
        String hsptlName= 'University of Wisconsin Health (AKA UW Health)';
        String hsptlName2=' Advocate Aurora Health';
         String searchUserKey = '%'+userLastName+'%';
        String Region = 'West';
        /* List<String> definitiveIds  = new List<String>();
        List<Account> accIds = [select Id,texcellency__DefHC_HospitalID__c from Account];
        for(Account acc:accIds){
          definitiveIds.add(String.valueOf(acc.texcellency__DefHC_HospitalID__c));
        }
        System.debug('definitiveIds==>'+definitiveIds);*/
        String query = '';
        String SobjectApiName = 'IDN_Charge_Back__c';
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
        query = 'select Account__c,Account__r.Name,Sales_Rep_Territory__c,Region__c, Category__c, Product__r.Name,Contact_Description__c,Hospital_Name__c,Child1_Name__c,Child2_Name__c,revised_product_family__c,	material_description__c,Settlement_Paid_Date__c,Month_Year__c,Paid_Chargeback_Amount__c,Contract_Sales_Indirect_Price__c,contract_units_paid_qty__c  from ' + SobjectApiName + ' where Settlement_Paid_Date__c >=: lastDate and Settlement_Paid_Date__c <=:currentDate AND Sales_Rep_Territory__c like: searchUserKey ' ;
         //query += ' AND Region__c =: Region ';  
        list < IDN_Charge_Back__c > idnchargebackList = Database.query(query);
        for(IDN_Charge_Back__c chargebackRec : idnchargebackList){
            
            if(maplist2.containsKey(chargebackRec.Hospital_Name__c) ){
                finalWrapper2 wrapperObjec = maplist2.get(chargebackRec.Hospital_Name__c);
                
                wrapperObjec.idnchargebackList.add(chargebackRec);// = new List<IDN_Charge_Back__c>{chargebackRec};
                //List<IDN_Charge_Back__c> templist = maplist.get(chargebackRec.Hospital_Name__c);
                //templist.add(chargebackRec);
                maplist2.put(chargebackRec.Hospital_Name__c,wrapperObjec);
                
            }else{
                finalWrapper2 wrapperObjec = new finalWrapper2();
                wrapperObjec.hospitalName = chargebackRec.Hospital_Name__c;
                wrapperObjec.accountId = chargebackRec.Account__c;
                wrapperObjec.showItem = true;
                //wrapperObjec.region = chargebackRec.Region__c;
                wrapperObjec.idnchargebackList = new List<IDN_Charge_Back__c>{chargebackRec};
                wrapperObjec.prevSixMonthKeys = prevSixMonthKeys;
                maplist2.put(chargebackRec.Hospital_Name__c,wrapperObjec);
            }
        }
       
     
        return maplist2.values();
       
    }
   
 
 /*for total 12 months*/   
     @AuraEnabled
    public static list < AggregateResult > getAllTotals(String salesTerritory,list<String> userRegion,list<string> userCategory,String hospitalName,String child1Name,String child2Name,list<string> productFamily,list<string> productDescription,String accountId,list<string> contractDescription,List<String> selectedMemberCity,List<String> selectedMemberState,List<String> submitterName) {
        string userLastName;
        if(salesTerritory != null){
        User u = [select Id,LastName from User where Id=: salesTerritory];
        userLastName = u.LastName;
        }else{
            userLastName = userInfo.getLastName();
        }
        String searchUserKey = '%'+userLastName+'%';
        date currentDates;
        List<Date> currentsixmonthsDatelist= new List<Date>();
        for(Integer i=1;i<=12;i++){
            currentDates = System.today().addMonths(-i+1).toStartOfMonth();//getting current 6 months dates
            currentsixmonthsDatelist.add(currentDates);//adding current 6 months to list
        }
        date currentDate = currentsixmonthsDatelist[0].addMonths(1).toStartofMonth().addDays(-1);
        date lastDate = currentsixmonthsDatelist[11];
        String query = '';
        String SobjectApiName = 'IDN_Charge_Back_Hospital_Summary__c';
        string groupedResults = ' select sum(T2_Contract_Sales_Indirect_Price__c) salesPrice, sum(T2_contract_units_paid_qty__c) units  from ' + SobjectApiName + ' where  T2_Sales_Rep_Territory__c like: searchUserKey AND T2_Settlement_Paid_Date__c >=: lastDate AND T2_Settlement_Paid_Date__c <=: currentDate ' ;
		//Hospital_Name__c =: hospitalName and
       /* if(userRegion.size()>0){
            groupedResults += ' AND T2_Region__c in : userRegion ';
        }
        if(userCategory.size()>0){
            groupedResults += ' AND T2_Category__c in : userCategory ';
        }
        if(child1Name != null){
           String searchChild1Key = '%'+child1Name+'%';
           groupedResults += ' AND T2_Child1_Name__c like: searchChild1Key ';   
         }
         if(child2Name != null){
             String searchChild2Key = '%'+child2Name+'%';
           groupedResults += ' AND T2_Child2_Name__c like: searchChild2Key';   
         }
        if(productFamily.size()>0){
            groupedResults += ' AND T2_revised_product_family__c in : productFamily';
        }
        if(productDescription.size()>0){
            groupedResults += ' AND T2_material_description__c in : productDescription';
        }
        if(submitterName.size()>0){
            groupedResults += ' AND T2_Submitter_Name__c in : submitterName';
        } 
        if(contractDescription.size()>0){
            groupedResults += ' AND T2_Contact_Description__c in : contractDescription ';
        }
        if(selectedMemberCity.size()>0){
            groupedResults += ' AND T2_member_city__c in : selectedMemberCity ';
        }*/
      // groupedResults += ' Order By Contract_Sales_Indirect_Price__c DESC ';
        return Database.query(groupedResults);
    }
  
  @AuraEnabled
  public static list < AggregateResult > getAllTotalsforIndividual(String salesTerritory,list<String> userRegion,list<string> userCategory,String hospitalName,String child1Name,String child2Name,list<string> productFamily,list<string> productDescription,String accountId,list<string> contractDescription,List<String> selectedMemberCity,List<String> selectedMemberState,List<String> submitterName) {
        string userLastName;
        if(salesTerritory != null){
        User u = [select Id,LastName from User where Id=: salesTerritory];
        userLastName = u.LastName;
        }else{
            userLastName = userInfo.getLastName();
            system.debug('salesTerritory in else==>'+userLastName);
        }
         String searchUserKey = '%'+userLastName+'%';
        date currentDates;
        List<Date> currentsixmonthsDatelist= new List<Date>();
        for(Integer i=1;i<=12;i++){
            currentDates = System.today().addMonths(-i+1).toStartOfMonth();//getting current 6 months dates
            currentsixmonthsDatelist.add(currentDates);//adding current 6 months to list
        }
        date currentDate = currentsixmonthsDatelist[0].addMonths(1).toStartofMonth().addDays(-1);
        date lastDate = currentsixmonthsDatelist[11];
        System.debug('currentDate===>'+currentDate);
        System.debug('lastDate===>'+lastDate);
        String query = '';
        String SobjectApiName = 'IDN_Charge_Back_Hospital_Summary__c';
        string level = 'Middle';
        string groupedResults = ' select sum(T2_Contract_Sales_Indirect_Price__c) salesPrice, sum(T2_contract_units_paid_qty__c) units  from ' + SobjectApiName + ' where T2_Hospital_Name__c = : hospitalName AND T2_Sales_Rep_Territory__c like: searchUserKey AND T2_Settlement_Paid_Date__c >=: lastDate AND T2_Settlement_Paid_Date__c <=: currentDate AND H1_Level__c =: level ' ;
       if(userRegion.size()>0){
          groupedResults += ' AND T2_Region__c in : userRegion ';
       }
        if(userCategory.size()>0){
            groupedResults += ' AND T2_Category__c in : userCategory ';
        }
         if(child1Name != null){
             String searchChild1Key = '%'+child1Name+'%';
           	groupedResults += ' AND T2_Child1_Name__c like: searchChild1Key ';   
         }
         if(child2Name != null){
             String searchChild2Key = '%'+child2Name+'%';
           groupedResults += ' AND T2_Child2_Name__c like: searchChild2Key';   
         }
        if(productFamily.size()>0){
            groupedResults += ' AND T2_revised_product_family__c in : productFamily';
        }
        if(productDescription.size()>0){
            groupedResults += ' AND T2_material_description__c in : productDescription';
        }
        if(submitterName.size()>0){
            groupedResults += ' AND T2_Submitter_Name__c in : submitterName';
        } 
        if(contractDescription.size()>0){
            groupedResults += ' AND T2_Contact_Description__c in : contractDescription ';
        }
        if(selectedMemberCity.size()>0){
            groupedResults += ' AND T2_member_city__c in : selectedMemberCity ';
        }
        return Database.query(groupedResults);
    }

    
 public class finalWrapper {
     @AuraEnabled public List<IDN_Charge_Back_Hospital_Summary__c> idnchargebackList;
     @AuraEnabled public String hospitalName;
     @AuraEnabled public String accountId;
      @AuraEnabled public String region;
     @AuraEnabled public boolean showItem;
     @AuraEnabled public List<String> currentSixMonthKeys;
     
     finalWrapper(){
         idnchargebackList = new List<IDN_Charge_Back_Hospital_Summary__c>();
     }
 }
 public class finalWrapper2 {
     @AuraEnabled public List<IDN_Charge_Back__c> idnchargebackList;
     @AuraEnabled public String hospitalName;
     @AuraEnabled public String accountId;
      @AuraEnabled public String region;
     @AuraEnabled public boolean showItem;
     @AuraEnabled public List<String> currentSixMonthKeys;
     @AuraEnabled public List<String> prevSixMonthKeys;
     finalWrapper2(){
         //idnchargebackList = new List<IDN_Charge_Back__c>();
     }
 }
}