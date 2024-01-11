public class Vision_IDNChargeBackCls {
        @AuraEnabled(Cacheable=true)
    public static String getuser(){
        String userid = UserInfo.getUserId();
        return userid;
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
       // list<string> names =[select name from User where id =:userid];
        list<AggregateResult > chargebackList = [select Hospital_Name__c ,count(ID) from  IDN_Charge_Back__c where Sales_Rep_Territory__c like:searchUserKey Group by Hospital_Name__c ];
        
        for(AggregateResult  ss:chargebackList){
           hospitalnames.add((String)ss.get('Hospital_Name__c'));
       }
       // }
       // else {
    // AggregateResult[] results = [SELECT count(Id), Hospital_Name__c  FROM IDN_Charge_Back__c GROUP BY Hospital_Name__c limit 10000];
//List<String> uniqueNames = new List<String>();
//for (IDN_Charge_Back__c result : results) {
///uniqueNames.add((String)result.get('Hospital_Name__c'));
//}
//system.debug(uniqueNames);
        List<String> hospitalnameslist = new List<String>(hospitalnames);
        return hospitalnameslist;
    }
    
  

    
     @AuraEnabled(Cacheable=true)
    public static list<string> getProductNames(string salesTerritoryId){
          set<string> hospitalnames = new set<string>();
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
     list<AggregateResult > chargebackList = [select revised_product_family__c ,count(ID) from  IDN_Charge_Back__c where Sales_Rep_Territory__c like:searchUserKey Group by revised_product_family__c ];
        
        for(AggregateResult  ss:chargebackList){
           hospitalnames.add((String)ss.get('revised_product_family__c'));
       }
      List<String> hospitalnameslist = new List<String>(hospitalnames);
        return hospitalnameslist;
    }
       @AuraEnabled(Cacheable=true)
    public static list<string> getProducts(string salesTerritoryId){
          set<string> hospitalnames = new set<string>();
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
        list<AggregateResult > chargebackList = [select material_description__c ,count(ID) from  IDN_Charge_Back__c where Sales_Rep_Territory__c like:searchUserKey Group by material_description__c ];
        
        for(AggregateResult  ss:chargebackList){
           hospitalnames.add((String)ss.get('material_description__c'));
       }
      List<String> hospitalnameslist = new List<String>(hospitalnames);
        return hospitalnameslist;
    }
    
    @AuraEnabled(Cacheable=true)
    public static list<string> getcategory(string salesTerritoryId){
          set<string> hospitalnames = new set<string>();
       // system.debug('hospitalname---'+hospitalname);
        //if(hospitalname == null){
   
         string userLastName;
        if(salesTerritoryId != null){
        User u = [select Id,LastName from User where Id=: salesTerritoryId];
        userLastName = u.LastName;
        }else{
            userLastName = userInfo.getLastName();
            system.debug('salesTerritory in else==>'+userLastName);
        }
        String searchUserKey = '%'+userLastName+'%';
        list<AggregateResult > chargebackList = [select Category__c ,count(ID) from  IDN_Charge_Back__c where Sales_Rep_Territory__c like:searchUserKey Group by Category__c ];
      // list<AggregateResult > chargebackList = 'select Category__c ,count(ID) from  IDN_Charge_Back__c where Sales_Rep_Territory__c like: searchUserKey Group by Category__c ';
        for(AggregateResult  ss:chargebackList){
           hospitalnames.add((String)ss.get('Category__c'));
       }
      List<String> hospitalnameslist = new List<String>(hospitalnames);
        return hospitalnameslist;
    }
    
     /*   @AuraEnabled(Cacheable=true)
    public static list<string> getcontracts(){
          set<string> hospitalnames = new set<string>();
      
         string name1  = UserInfo.getlAstName();
        String name2 = '%'+name1+'%';
       list<AggregateResult > chargebackList = [select Contact_Description__c ,count(ID) from  IDN_Charge_Back__c where Sales_Rep_Territory__c like:name2 Group by Contact_Description__c ];
        
        for(AggregateResult  ss:chargebackList){
           hospitalnames.add((String)ss.get('Contact_Description__c'));
       }
      List<String> hospitalnameslist = new List<String>(hospitalnames);
        return hospitalnameslist;
    }
    */
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
	query = 'select Contact_Description__c,count(ID)  from IDN_Charge_Back__c  where Sales_Rep_Territory__c like:searchUserKey  ';
      if(searchInput != null){
             System.debug('searchInput==>'+searchInput);
             String searchInputKey = '%'+searchInput+'%';
           query += ' AND Contact_Description__c like: searchInputKey ';   
         }
        query += ' Group by Contact_Description__c '; 
        list < AggregateResult > cntList = Database.query(query); 
        
        return cntList;
        
    }
    @AuraEnabled(Cacheable=true)
    public static list<string> getmembericty(string salesTerritoryId){
          set<string> hospitalnames = new set<string>();
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
       list<AggregateResult > chargebackList = [select member_city__c ,count(ID) from  IDN_Charge_Back__c where Sales_Rep_Territory__c like:searchUserKey Group by member_city__c ];
        
        for(AggregateResult  ss:chargebackList){
           hospitalnames.add((String)ss.get('member_city__c'));
       }
      List<String> hospitalnameslist = new List<String>(hospitalnames);
        return hospitalnameslist;
    }
       @AuraEnabled(Cacheable=true)
    public static list<string> getmemberstate(string salesTerritoryId){
          set<string> hospitalnames = new set<string>();
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
       list<AggregateResult > chargebackList = [select Member_State__c ,count(ID) from  IDN_Charge_Back__c where Sales_Rep_Territory__c like:searchUserKey Group by Member_State__c ];
        
        for(AggregateResult  ss:chargebackList){
           hospitalnames.add((String)ss.get('Member_State__c'));
       }
      List<String> hospitalnameslist = new List<String>(hospitalnames);
        return hospitalnameslist;
    }
       @AuraEnabled(Cacheable=true)
    public static list<string> getsubmitters(string salesTerritoryId){
          set<string> hospitalnames = new set<string>();
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
        list<AggregateResult > chargebackList = [select Submitter_Name__c ,count(ID) from  IDN_Charge_Back__c where Sales_Rep_Territory__c like:searchUserKey Group by Submitter_Name__c ];
        
        for(AggregateResult  ss:chargebackList){
           hospitalnames.add((String)ss.get('Submitter_Name__c'));
       }
      List<String> hospitalnameslist = new List<String>(hospitalnames);
        return hospitalnameslist;
    }
    
 	@AuraEnabled(Cacheable=true)
    public static List<finalWrapper> getData(String salesTerritory,String userRegion,list<string> userCategory,list<string> hospitalName,String child1Name,String child2Name,list<string> productFamily,list<string> productDescription,String accountId,list<string> contractDescription,List<String> selectedMemberCity,List<String> selectedMemberState,List<String> submitterName){
        system.debug('selectedMemberCity==>'+selectedMemberCity);
        system.debug('selectedMemberState==>'+selectedMemberState);
        system.debug('submitterName==>'+submitterName);
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
        
            /*    if(accountId != null){
                    Account acc = [select Id,texcellency__DefHC_HospitalID__c from Account where id=:accountId];
                    String definitiveId =acc.texcellency__DefHC_HospitalID__c != null ? String.valueOf((acc.texcellency__DefHC_HospitalID__c).format()) : '';
                    
                    List<String> tempstr = String.valueOf(acc.texcellency__DefHC_HospitalID__c).split(',');
                  
                    String temp=' ';
                    if(acc.texcellency__DefHC_HospitalID__c != null){
                        for(string str : tempstr)
                        {
                            if(Str.trim().length() > 0){
                                temp = temp+str;
                            }
                        }
                        
                    }
                    definitiveId = temp.trim();
                    
                }*/
        List<finalWrapper> wrapperObjectList = new List<finalWrapper>();
        Map<string,finalWrapper> maplist = new Map<String,finalWrapper>();
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
        List<Account> accIds = [select Id,texcellency__DefHC_HospitalID__c from Account];
       List<String> definitiveIds  = new List<String>();
        String hsptlName= 'University of Wisconsin Health (AKA UW Health)';
        String hsptlName2=' Advocate Aurora Health';
        for(Account acc:accIds){
          definitiveIds.add(String.valueOf(acc.texcellency__DefHC_HospitalID__c));
        }
        // AND Hospital_Name__c =:hsptlName
        query = 'select Account__c,Account__r.Name,Sales_Rep_Territory__c,Region__c,member_city__c,Member_State__c, Submitter_Name__c,Category__c, Product__r.Name,Contact_Description__c,Hospital_Name__c,Child1_Name__c,Child2_Name__c,revised_product_family__c,	material_description__c,Settlement_Paid_Date__c,Month_Year__c,Paid_Chargeback_Amount__c,Contract_Sales_Indirect_Price__c,contract_units_paid_qty__c  from ' + SobjectApiName + ' where Settlement_Paid_Date__c >=: lastDate and Settlement_Paid_Date__c <=:currentDate AND Sales_Rep_Territory__c like: searchUserKey AND Hospital_Id__c IN:definitiveIds ' ;
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
        if(selectedMemberState.size()>0){
            System.debug('selectedMemberState size'+selectedMemberState.size());
            query += ' AND Member_State__c in : selectedMemberState ';
        }
        if(selectedMemberCity.size()>0){
            
            query += ' AND member_city__c in : selectedMemberCity ';
        }
		 if(submitterName.size()>0){
            
            query += ' AND Submitter_Name__c in : submitterName ';
        }        
        if(contractDescription.size()>0){
            
            query += ' AND Contact_Description__c in : contractDescription ';
        }
        
         query += ' Order By Contract_Sales_Indirect_Price__c DESC ';
        /*else{
        query = 'select Account__r.Name,	Region__c,Product__r.Name,Hospital_Name__c,Hospital_Id__c,Child1_Name__c,revised_product_family__c,	material_description__c,Settlement_Paid_Date__c,Month_Year__c,Paid_Chargeback_Amount__c,Contract_Sales_Indirect_Price__c,contract_units_paid_qty__c  from ' + SobjectApiName + ' where  Hospital_Id__c =: definitiveId and Settlement_Paid_Date__c >=: lastDate and Settlement_Paid_Date__c <=:currentDate' ;
        }*/
        list < IDN_Charge_Back__c > idnchargebackList = Database.query(query);
        for(IDN_Charge_Back__c chargebackRec : idnchargebackList){
            
            if(maplist.containsKey(chargebackRec.Hospital_Name__c) ){
                finalWrapper wrapperObjec = maplist.get(chargebackRec.Hospital_Name__c);
                
                wrapperObjec.idnchargebackList.add(chargebackRec);// = new List<IDN_Charge_Back__c>{chargebackRec};
                //List<IDN_Charge_Back__c> templist = maplist.get(chargebackRec.Hospital_Name__c);
                //templist.add(chargebackRec);
                maplist.put(chargebackRec.Hospital_Name__c,wrapperObjec);
                
            }else{
                finalWrapper wrapperObjec = new finalWrapper();
                wrapperObjec.hospitalName = chargebackRec.Hospital_Name__c;
                wrapperObjec.accountId = chargebackRec.Account__c;
                wrapperObjec.showItem = true;
                //wrapperObjec.region = chargebackRec.Region__c;
                wrapperObjec.idnchargebackList = new List<IDN_Charge_Back__c>{chargebackRec};
                wrapperObjec.currentSixMonthKeys = currentSixMonthKeys;
                maplist.put(chargebackRec.Hospital_Name__c,wrapperObjec);
            }
        }
        
        
        //wrapperObject.idnchargebackList =idnchargebackList;
        //wrapperObject.teststr = 'testString';
        //System.debug('wrap data==>'+wrapperObject.idnchargebackList);
        //System.debug('wrap data==>'+wrapperObject);
        return maplist.values();
    }
 
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
        List<Account> accIds = [select Id,texcellency__DefHC_HospitalID__c from Account];
       List<String> definitiveIds  = new List<String>();
        String hsptlName= 'University of Wisconsin Health (AKA UW Health)';
        String hsptlName2=' Advocate Aurora Health';
        for(Account acc:accIds){
          definitiveIds.add(String.valueOf(acc.texcellency__DefHC_HospitalID__c));
        }
        // AND Hospital_Name__c =:hsptlName
        query = 'select Account__c,Account__r.Name,Sales_Rep_Territory__c,Region__c,member_city__c,Member_State__c, Submitter_Name__c,Category__c, Product__r.Name,Contact_Description__c,Hospital_Name__c,Child1_Name__c,Child2_Name__c,revised_product_family__c,	material_description__c,Settlement_Paid_Date__c,Month_Year__c,Paid_Chargeback_Amount__c,Contract_Sales_Indirect_Price__c,contract_units_paid_qty__c  from ' + SobjectApiName + ' where Settlement_Paid_Date__c >=: lastDate and Settlement_Paid_Date__c <=:currentDate AND Sales_Rep_Territory__c like: searchUserKey AND Hospital_Id__c IN:definitiveIds ' ;
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

         List<String> definitiveIds  = new List<String>();
        String hsptlName= 'University of Wisconsin Health (AKA UW Health)';
        String hsptlName2=' Advocate Aurora Health';
         String searchUserKey = '%'+userLastName+'%';
        String Region = 'West';
        List<Account> accIds = [select Id,texcellency__DefHC_HospitalID__c from Account];
        for(Account acc:accIds){
          definitiveIds.add(String.valueOf(acc.texcellency__DefHC_HospitalID__c));
        }
        System.debug('definitiveIds==>'+definitiveIds);
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
        query = 'select Account__c,Account__r.Name,Sales_Rep_Territory__c,Region__c, Category__c, Product__r.Name,Contact_Description__c,Hospital_Name__c,Child1_Name__c,Child2_Name__c,revised_product_family__c,	material_description__c,Settlement_Paid_Date__c,Month_Year__c,Paid_Chargeback_Amount__c,Contract_Sales_Indirect_Price__c,contract_units_paid_qty__c  from ' + SobjectApiName + ' where Settlement_Paid_Date__c >=: lastDate and Settlement_Paid_Date__c <=:currentDate AND Sales_Rep_Territory__c like: searchUserKey AND Hospital_Id__c IN:definitiveIds ' ;
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
    public static list < AggregateResult > getAllTotals(String salesTerritory,String userRegion,list<string> userCategory,String hospitalName,String child1Name,String child2Name,list<string> productFamily,list<string> productDescription,String accountId,list<string> contractDescription,List<String> selectedMemberCity,List<String> selectedMemberState,List<String> submitterName) {
      
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
       
         List<String> definitiveIds  = new List<String>();
		 List<Account> accIds = [select Id,texcellency__DefHC_HospitalID__c from Account];
        for(Account acc:accIds){
          definitiveIds.add(String.valueOf(acc.texcellency__DefHC_HospitalID__c));
        }
        System.debug('definitiveIds==>'+definitiveIds);
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
        //Sales_Rep_Territory__c like: searchUserKey AND Region__c =: userRegion AND Category__c =:userCategory
        //AND Settlement_Paid_Date__c >=: lastDate AND Settlement_Paid_Date__c <=: currentDate
        //  //list < AggregateResult > idnchargebackList = Database.query(groupedResults);  
        string groupedResults = ' select sum(Contract_Sales_Indirect_Price__c) salesPrice, sum(contract_units_paid_qty__c) units  from ' + SobjectApiName + ' where Hospital_Name__c =: hospitalName and Sales_Rep_Territory__c like: searchUserKey AND Settlement_Paid_Date__c >=: lastDate AND Settlement_Paid_Date__c <=: currentDate AND Hospital_Id__c IN:definitiveIds ' ;
                                           
         
       
		List<String> regions = new List<String>{'East', 'West', 'White Space',''};
        if(userRegion != null){
            if(userRegion == 'All'){
                System.debug('in inside if all');
                groupedResults += ' AND Region__c IN: regions ';
            }else{
               System.debug('in inside else all');
               groupedResults += ' AND Region__c =: userRegion ';  
            }
        }
        if(userCategory.size()>0){
            
            groupedResults += ' AND Category__c in : userCategory ';
        }
		
		/*if(hospitalName != null){
         String searchHospitalKey = '%'+hospitalName+'%';   
            query += ' AND Hospital_Name__c like: searchHospitalKey '; 
        }*/
         if(child1Name != null){
             System.debug('inside child1Name==>'+child1Name);
             String searchChild1Key = '%'+child1Name+'%';
           groupedResults += ' AND Child1_Name__c like: searchChild1Key ';   
         }
         if(child2Name != null){
             System.debug('inside child2Name==>'+child2Name);
             String searchChild2Key = '%'+child2Name+'%';
           groupedResults += ' AND Child2_Name__c like: searchChild2Key';   
         }
        if(productFamily.size()>0){
            
            groupedResults += ' AND revised_product_family__c in : productFamily';
        }
        if(productDescription.size()>0){
            
            groupedResults += ' AND material_description__c in : productDescription';
        }
        if(submitterName.size()>0){
            
            groupedResults += ' AND Submitter_Name__c in : submitterName';
        } 
       
        if(contractDescription.size()>0){
            
            groupedResults += ' AND Contact_Description__c in : contractDescription ';
        }
        if(selectedMemberCity.size()>0){
            
            groupedResults += ' AND member_city__c in : selectedMemberCity ';
        }
       //  groupedResults += ' Order By Contract_Sales_Indirect_Price__c DESC ';
   
         System.debug('groupedResults===>'+Database.query(groupedResults));
       // AggregateResult[] grpResults = Database.query(groupedResults);
       
        return Database.query(groupedResults);
    }

  /*for total 12 months count main component*/
     @AuraEnabled
    public static list < AggregateResult > getAllTotalsMain(String salesTerritory,String userRegion,list<string> userCategory,String hospitalName,String child1Name,String child2Name,list<string> productFamily,list<string> productDescription,String accountId,list<string> contractDescription,List<String> selectedMemberCity,List<String> selectedMemberState,List<String> submitterName) {
		  System.debug('salesTerritory main===>'+salesTerritory);
          System.debug('userRegion mian===>'+userRegion);
         System.debug('userCategory main===>'+userCategory);
        System.debug('hospitalName main===>'+hospitalName);
        System.debug('child1Name main===>'+child1Name);
        System.debug('accountId main===>'+accountId);

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
       
         List<String> definitiveIds  = new List<String>();
		 List<Account> accIds = [select Id,texcellency__DefHC_HospitalID__c from Account];
        for(Account acc:accIds){
          definitiveIds.add(String.valueOf(acc.texcellency__DefHC_HospitalID__c));
        }
        System.debug('definitiveIds==>'+definitiveIds);
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
        string groupedResults = ' select sum(Contract_Sales_Indirect_Price__c) salesPrice, sum(contract_units_paid_qty__c) units  from ' + SobjectApiName + ' where   Sales_Rep_Territory__c like: searchUserKey AND Settlement_Paid_Date__c >=: lastDate AND Settlement_Paid_Date__c <=: currentDate AND Hospital_Id__c IN:definitiveIds ' ;
		List<String> regions = new List<String>{'East', 'West', 'White Space',''};
        if(userRegion != null){
            if(userRegion == 'All'){
                System.debug('in inside if all');
                groupedResults += ' AND Region__c IN: regions ';
            }else{
               System.debug('in inside else all');
               groupedResults += ' AND Region__c =: userRegion ';  
            }
        }
      /*  if(userCategory.size()>0){
            
            groupedResults += ' AND Category__c in : userCategory ';
        }*/
		
		/*if(hospitalName != null){
         String searchHospitalKey = '%'+hospitalName+'%';   
            query += ' AND Hospital_Name__c like: searchHospitalKey '; 
        }*/
         if(child1Name != null){
             System.debug('inside child1Name==>'+child1Name);
             String searchChild1Key = '%'+child1Name+'%';
           groupedResults += ' AND Child1_Name__c like: searchChild1Key ';   
         }
         if(child2Name != null){
             System.debug('inside child2Name==>'+child2Name);
             String searchChild2Key = '%'+child2Name+'%';
           groupedResults += ' AND Child2_Name__c like: searchChild2Key';   
         }
        if(productFamily.size()>0){
            
            groupedResults += ' AND revised_product_family__c in : productFamily';
        }
        if(productDescription.size()>0){
            
            groupedResults += ' AND material_description__c in : productDescription';
        }
        if(submitterName.size()>0){
            
            groupedResults += ' AND Submitter_Name__c in : submitterName';
        } 
       
        if(contractDescription.size()>0){
            
            groupedResults += ' AND Contact_Description__c in : contractDescription ';
        }
        if(selectedMemberCity.size()>0){
            
            groupedResults += ' AND member_city__c in : selectedMemberCity ';
        }
       //  groupedResults += ' Order By Contract_Sales_Indirect_Price__c DESC ';
   
         System.debug('groupedResults===>'+Database.query(groupedResults));
       // AggregateResult[] grpResults = Database.query(groupedResults);
       
        return Database.query(groupedResults);
    }

    
    
    /* @AuraEnabled
    public static List<String> getFamilies(String searchString){        
        String searchKey = '%'+searchString+'%';List<String> productFamiliesList = new List<String>();Set<String> productFamilies = new Set<String>();
        try{
            List<Product2> products = [SELECT Family FROM Product2 WHERE Family like: searchKey ORDER BY Family]; 
            for(Product2 prod: products) productFamilies.add(prod.Family);
            productFamiliesList.addAll(productFamilies);
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Vision_IDNChargeBackCls', Phoenix_Method_Name__c = 'getFamilies', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')'); insert exp;
        }
        return productFamiliesList;
    }*/
    
 public class finalWrapper {
     @AuraEnabled public List<IDN_Charge_Back__c> idnchargebackList;
     @AuraEnabled public String hospitalName;
     @AuraEnabled public String accountId;
      @AuraEnabled public String region;
     @AuraEnabled public boolean showItem;
     @AuraEnabled public List<String> currentSixMonthKeys;
     
     finalWrapper(){
         idnchargebackList = new List<IDN_Charge_Back__c>();
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