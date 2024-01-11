public class complainceCTDFTDdata implements Database.Batchable < sObject >{
    public Database.QueryLocator start(Database.BatchableContext BC) {
         String acc = '0011K00002RDd6lQAD';
        string uu='300000912_115596';
        
        String query = 'Select'+Phoenix_Util.getsObjectFieds('Compliance_Summary__c')+' from Compliance_Summary__c';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List <Compliance_Summary__c> compliancerecords) {
        try{
            List<Compliance_Summary__c> updateSummaryRec =new List<Compliance_Summary__c>();
            Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
            date todayDate =System.today();
            Date CurrentDate = Date.newInstance(todayDate.year(), 1, 1);
            Integer CTDDaysDue = CurrentDate.daysBetween(todayDate);
               list<string> quarter1=new list<string>{'Apr','May','Jun'};
                      list<string> quarter2=new list<string>{'Jul','Aug','Sep'};
            list<string> quarter3=new list<string>{'Oct','Nov','Dec'};
                   list<string> quarter4=new list<string>{'Jan','Feb','Mar'};
                
          //  system.debug('todayDate====='+todayDate);
            date currentFyscalDate = Date.newinstance(system.today().year(), 4, 1);
            Integer FTDDaysDue = currentFyscalDate.daysBetween(todayDate);
            //system.debug('currentFyscalDate ====='+currentFyscalDate );
            Date Q2Date;
            List<Integer> Q1=new List<Integer>{4,5,6}; 
                List<Integer> Q2=new List<Integer>{7,8,9}; 
                    List<Integer> Q3=new List<Integer>{10,11,12};
                        List<Integer> Q4=new List<Integer>{1,2,3}; 
                            Integer QTDDaysDue;
            if(Q1.contains(system.Today().Month())){
                Q2Date = Date.newInstance(system.Today().year(), 4, 1);
                QTDDaysDue= Q2Date.daysBetween(system.Today());
            }
            if(Q2.contains(system.Today().Month())){
                Q2Date = Date.newInstance(system.Today().year(), 7, 1);
                QTDDaysDue= Q2Date.daysBetween(system.Today());
            }
            if(Q3.contains(system.Today().Month())){
                Q2Date = Date.newInstance(system.Today().year(), 10, 1);
                QTDDaysDue= Q2Date.daysBetween(system.Today());
            }
            if(Q4.contains(system.Today().Month())){
                Q2Date = Date.newInstance(system.Today().year(), 1, 1);
                QTDDaysDue= Q2Date.daysBetween(system.Today());
            }
           // system.debug('QTDDaysDue==='+QTDDaysDue);
            List<String> FTDList = new List<String>();
            /*if(currentFyscalDate.month() < todayDate.month()){
                for(Integer i=currentFyscalDate.month();i<=todayDate.month();i++){
                    DateTime dt2 = currentFyscalDate.addmonths(i-3);
                   // system.debug(dt2);
                    Integer y2 = dt2.year();
                    String yr2 = String.valueOf(y2);
                    string M2=dt2.format('MMM')+'-'+yr2.substring(2);
                    
                    FTDList.add(M2);
                    
                }
            }
            else{
                for(Integer i=0;i<=12-(currentFyscalDate.month()-todayDate.month());i++){
                    DateTime dt2 = todayDate.addmonths(-i+1);
                    system.debug(dt2);
                    Integer y2 = dt2.year();
                    String yr2 = String.valueOf(y2);
                    string M2=dt2.format('MMM')+'-'+yr2.substring(2);
                    FTDList.add(M2);
                    system.debug('M2====='+M2);
                    
                }
            }*/
            if(currentFyscalDate.month() < todayDate.month()){
                for(Integer i=currentFyscalDate.month();i<=todayDate.month();i++){
                    DateTime dt2 = currentFyscalDate.addmonths(i-4);
                   // system.debug(dt2);
                    Integer y2 = dt2.year();
                    String yr2 = String.valueOf(y2);
                    string M2=dt2.format('MMM')+'-'+yr2.substring(2);
                    
                    FTDList.add(M2);
                    
                }
            }
            else{
                for(Integer i=0;i<=12-(currentFyscalDate.month()-todayDate.month());i++){
                    DateTime dt2 = todayDate.addmonths(-i);
                    system.debug(dt2);
                    Integer y2 = dt2.year();
                    String yr2 = String.valueOf(y2);
                    string M2=dt2.format('MMM')+'-'+yr2.substring(2);
                    FTDList.add(M2);
                    system.debug('M2====='+M2);
                    
                }
            }
            
            //datetime dtt=datetime.newInstance(Date.newinstance(system.today().year(), 4, 1),datetime.time() );
           // string ft=currentFyscalDate.format('MMM')+'-'+yr2.substring(2);
           // ftdlist.add(ft);
            system.debug('FTDList====='+FTDList);
            List<String> CTDList = new List<String>();
            for(Integer i=todayDate.month()-1;i>=0;i--){
                DateTime dt2 = DateTime.now().addmonths(-i);
                system.debug(dt2);
                Integer y2 = dt2.year();
                String yr2 = String.valueOf(y2);
                string M2=dt2.format('MMM')+'-'+yr2.substring(2);
                CTDList.add(M2);
                
            }
          string d1;
            string m1;
           // date dt1;
            system.debug('CTDList====='+CTDList);
            // system.debug('uniqueIdentifierMap=='+uniqueIdentifierMap.keySet());
          //  system.debug('compliancerecords===='+compliancerecords.size());    
            for(Compliance_Summary__c qtdrec : compliancerecords){
             //   system.debug('qtdrec====='+qtdrec);
                qtdrec.Days_Between_CTD__c = CTDDaysDue;
                qtdrec.Days_Between_FTD__c = FTDDaysDue;
                qtdrec.Days_Between_QTD__c = QTDDaysDue;
                
                //  if(qtdrec.M1_Quantity__c!=null)
                if(qtdrec.Price_Effective_Date__c!=null){
                m1=string.valueOf(qtdrec.Price_Effective_Date__c.month()).length()==2?string.valueof(qtdrec.Price_Effective_Date__c.month()):'0'+qtdrec.Price_Effective_Date__c.month();
                d1=string.valueOf(qtdrec.Price_Effective_Date__c.day()).length()==2?string.valueof(qtdrec.Price_Effective_Date__c.day()):'0'+qtdrec.Price_Effective_Date__c.day();
                }
                if(qtdrec.Is_Direct__c==true){
                    if(qtdrec.Price_Effective_Date__c!=null){
                    qtdrec.Direct_Price_Effective_Date__c=m1+ '-' + d1 + '-' + qtdrec.Price_Effective_Date__c.year();
                    }
                   
                }
                 else{
                       qtdrec.Direct_Price_Effective_Date__c='N/A';
                    }
                if(qtdrec.Is_Indirect__c==true){
                     if(qtdrec.Price_Effective_Date__c!=null){
                    qtdrec.Indirect_Price_Effective_Date__c=m1+ '-' + d1 + '-' + qtdrec.Price_Effective_Date__c.year();
                     }
                   
                    
                }
                 else{
                         qtdrec.InDirect_Price_Effective_Date__c='N/A';
                    }
                string month1=qtdrec.Month1__c!=null?qtdrec.Month1__c.substringbefore('-'):'-';
                string month2=qtdrec.Month2__c!=null?qtdrec.Month2__c.substringbefore('-'):'-';
                string month3=qtdrec.Month3__c!=null?qtdrec.Month3__c.substringbefore('-'):'-';
                if(Month1=='Oct'){
                   qtdrec.QTD_Direct_Quantity__c=qtdrec.M1_Quantity__c != null ? qtdrec.M1_Quantity__c : 0;
                   qtdrec.QTD_Indirect_Quantity__c=qtdrec.M1_Indirect_Quantity__c != null ? qtdrec.M1_Indirect_Quantity__c : 0;
                }
                else if(Month2=='Oct'){
                      qtdrec.QTD_Direct_Quantity__c=(qtdrec.M1_Quantity__c != null ? qtdrec.M1_Quantity__c : 0)+ (qtdrec.M2_Quantity__c != null ? qtdrec.M2_Quantity__c : 0 );
                     qtdrec.QTD_Indirect_Quantity__c=(qtdrec.M1_Indirect_Quantity__c != null ? qtdrec.M1_Indirect_Quantity__c : 0 ) +  (qtdrec.M2_Indirect_Quantity__c != null ? qtdrec.M2_Indirect_Quantity__c : 0);
                }
                else if(Month3=='Oct'){
                   qtdrec.QTD_Direct_Quantity__c= ( qtdrec.M1_Quantity__c != null ? qtdrec.M1_Quantity__c : 0) +  (qtdrec.M2_Quantity__c != null ? qtdrec.M2_Quantity__c : 0 ) +  (qtdrec.M3_Quantity__c != null ? qtdrec.M3_Quantity__c : 0) ; 
                     qtdrec.QTD_Indirect_Quantity__c = (qtdrec.M1_Indirect_Quantity__c != null ? qtdrec.M1_Indirect_Quantity__c : 0 ) +  (qtdrec.M2_Indirect_Quantity__c != null ? qtdrec.M2_Indirect_Quantity__c : 0)  +  (qtdrec.M3_Indirect_Quantity__c != null ? qtdrec.M3_Indirect_Quantity__c : 0 );
                }
                else if(Month1=='Apr'){
                     qtdrec.QTD_Direct_Quantity__c=qtdrec.M1_Quantity__c != null ? qtdrec.M1_Quantity__c : 0;
                   qtdrec.QTD_Indirect_Quantity__c=qtdrec.M1_Indirect_Quantity__c != null ? qtdrec.M1_Indirect_Quantity__c : 0;
                }
                else if(Month2=='Apr'){
                      qtdrec.QTD_Direct_Quantity__c=(qtdrec.M1_Quantity__c != null ? qtdrec.M1_Quantity__c : 0)+ (qtdrec.M2_Quantity__c != null ? qtdrec.M2_Quantity__c : 0 );
                     qtdrec.QTD_Indirect_Quantity__c=(qtdrec.M1_Indirect_Quantity__c != null ? qtdrec.M1_Indirect_Quantity__c : 0 ) +  (qtdrec.M2_Indirect_Quantity__c != null ? qtdrec.M2_Indirect_Quantity__c : 0);
                }
                  else if(Month3=='Apr'){
                   qtdrec.QTD_Direct_Quantity__c= ( qtdrec.M1_Quantity__c != null ? qtdrec.M1_Quantity__c : 0) +  (qtdrec.M2_Quantity__c != null ? qtdrec.M2_Quantity__c : 0 ) +  (qtdrec.M3_Quantity__c != null ? qtdrec.M3_Quantity__c : 0) ; 
                     qtdrec.QTD_Indirect_Quantity__c = (qtdrec.M1_Indirect_Quantity__c != null ? qtdrec.M1_Indirect_Quantity__c : 0 ) +  (qtdrec.M2_Indirect_Quantity__c != null ? qtdrec.M2_Indirect_Quantity__c : 0)  +  (qtdrec.M3_Indirect_Quantity__c != null ? qtdrec.M3_Indirect_Quantity__c : 0 );
                }
                 else if(Month1=='Jan'){
                     qtdrec.QTD_Direct_Quantity__c=qtdrec.M1_Quantity__c != null ? qtdrec.M1_Quantity__c : 0;
                   qtdrec.QTD_Indirect_Quantity__c=qtdrec.M1_Indirect_Quantity__c != null ? qtdrec.M1_Indirect_Quantity__c : 0;
                }
                else if(Month2=='Jan'){
                      qtdrec.QTD_Direct_Quantity__c=(qtdrec.M1_Quantity__c != null ? qtdrec.M1_Quantity__c : 0)+ (qtdrec.M2_Quantity__c != null ? qtdrec.M2_Quantity__c : 0 );
                     qtdrec.QTD_Indirect_Quantity__c=(qtdrec.M1_Indirect_Quantity__c != null ? qtdrec.M1_Indirect_Quantity__c : 0 ) +  (qtdrec.M2_Indirect_Quantity__c != null ? qtdrec.M2_Indirect_Quantity__c : 0);
                }
                  else if(Month3=='Jan'){
                   qtdrec.QTD_Direct_Quantity__c= ( qtdrec.M1_Quantity__c != null ? qtdrec.M1_Quantity__c : 0) +  (qtdrec.M2_Quantity__c != null ? qtdrec.M2_Quantity__c : 0 ) +  (qtdrec.M3_Quantity__c != null ? qtdrec.M3_Quantity__c : 0) ; 
                     qtdrec.QTD_Indirect_Quantity__c = (qtdrec.M1_Indirect_Quantity__c != null ? qtdrec.M1_Indirect_Quantity__c : 0 ) +  (qtdrec.M2_Indirect_Quantity__c != null ? qtdrec.M2_Indirect_Quantity__c : 0)  +  (qtdrec.M3_Indirect_Quantity__c != null ? qtdrec.M3_Indirect_Quantity__c : 0 );
                }
                 else if(Month1=='Jul'){
                     qtdrec.QTD_Direct_Quantity__c=qtdrec.M1_Quantity__c != null ? qtdrec.M1_Quantity__c : 0;
                   qtdrec.QTD_Indirect_Quantity__c=qtdrec.M1_Indirect_Quantity__c != null ? qtdrec.M1_Indirect_Quantity__c : 0;
                }
                else if(Month2=='Jul'){
                      qtdrec.QTD_Direct_Quantity__c=(qtdrec.M1_Quantity__c != null ? qtdrec.M1_Quantity__c : 0)+ (qtdrec.M2_Quantity__c != null ? qtdrec.M2_Quantity__c : 0 );
                     qtdrec.QTD_Indirect_Quantity__c=(qtdrec.M1_Indirect_Quantity__c != null ? qtdrec.M1_Indirect_Quantity__c : 0 ) +  (qtdrec.M2_Indirect_Quantity__c != null ? qtdrec.M2_Indirect_Quantity__c : 0);
                }
                  else if(Month3=='Jul'){
                   qtdrec.QTD_Direct_Quantity__c= ( qtdrec.M1_Quantity__c != null ? qtdrec.M1_Quantity__c : 0) +  (qtdrec.M2_Quantity__c != null ? qtdrec.M2_Quantity__c : 0 ) +  (qtdrec.M3_Quantity__c != null ? qtdrec.M3_Quantity__c : 0) ; 
                     qtdrec.QTD_Indirect_Quantity__c = (qtdrec.M1_Indirect_Quantity__c != null ? qtdrec.M1_Indirect_Quantity__c : 0 ) +  (qtdrec.M2_Indirect_Quantity__c != null ? qtdrec.M2_Indirect_Quantity__c : 0)  +  (qtdrec.M3_Indirect_Quantity__c != null ? qtdrec.M3_Indirect_Quantity__c : 0 );
                }
                else{
                    qtdrec.QTD_Direct_Quantity__c=0;
                    qtdrec.QTD_Indirect_Quantity__c=0;
                    
                }
                if(Month1=='Oct'){
                   qtdrec.QTD_Total_Quantity__c=qtdrec.M1_Total_Quantity__c != null ? qtdrec.M1_Total_Quantity__c : 0;
                
                }
                else if(Month2=='Oct'){
                   qtdrec.QTD_Total_Quantity__c=(qtdrec.M1_Total_Quantity__c != null ? qtdrec.M1_Total_Quantity__c : 0) + (qtdrec.M2_Total_Quantity__c != null ? qtdrec.M2_Total_Quantity__c : 0);
                }
                else if(Month3=='Oct'){
                         qtdrec.QTD_Total_Quantity__c = (qtdrec.M1_Total_Quantity__c != null ? qtdrec.M1_Total_Quantity__c : 0) + (qtdrec.M2_Total_Quantity__c != null ? qtdrec.M2_Total_Quantity__c : 0) +(qtdrec.M3_Total_Quantity__c != null ? qtdrec.M3_Total_Quantity__c : 0 );
                }
                else if(Month1=='Apr'){
                     qtdrec.QTD_Total_Quantity__c=qtdrec.M1_Total_Quantity__c != null ? qtdrec.M1_Total_Quantity__c : 0;
                }
                else if(Month2=='Apr'){
                       qtdrec.QTD_Total_Quantity__c=(qtdrec.M1_Total_Quantity__c != null ? qtdrec.M1_Total_Quantity__c : 0) + (qtdrec.M2_Total_Quantity__c != null ? qtdrec.M2_Total_Quantity__c : 0);
                }
                  else if(Month3=='Apr'){
                   qtdrec.QTD_Total_Quantity__c = (qtdrec.M1_Total_Quantity__c != null ? qtdrec.M1_Total_Quantity__c : 0) + (qtdrec.M2_Total_Quantity__c != null ? qtdrec.M2_Total_Quantity__c : 0) +(qtdrec.M3_Total_Quantity__c != null ? qtdrec.M3_Total_Quantity__c : 0 );
                }
                 else if(Month1=='Jan'){
                      qtdrec.QTD_Total_Quantity__c=qtdrec.M1_Total_Quantity__c != null ? qtdrec.M1_Total_Quantity__c : 0;
                }
                else if(Month2=='Jan'){
                      qtdrec.QTD_Total_Quantity__c=(qtdrec.M1_Total_Quantity__c != null ? qtdrec.M1_Total_Quantity__c : 0) + (qtdrec.M2_Total_Quantity__c != null ? qtdrec.M2_Total_Quantity__c : 0);
                }
                  else if(Month3=='Jan'){
                  
                     qtdrec.QTD_Total_Quantity__c = (qtdrec.M1_Total_Quantity__c != null ? qtdrec.M1_Total_Quantity__c : 0) + (qtdrec.M2_Total_Quantity__c != null ? qtdrec.M2_Total_Quantity__c : 0) +(qtdrec.M3_Total_Quantity__c != null ? qtdrec.M3_Total_Quantity__c : 0 );
                }
                 else if(Month1=='Jul'){
                      qtdrec.QTD_Total_Quantity__c=qtdrec.M1_Total_Quantity__c != null ? qtdrec.M1_Total_Quantity__c : 0;
                }
                else if(Month2=='Jul'){
                     qtdrec.QTD_Total_Quantity__c=(qtdrec.M1_Total_Quantity__c != null ? qtdrec.M1_Total_Quantity__c : 0) + (qtdrec.M2_Total_Quantity__c != null ? qtdrec.M2_Total_Quantity__c : 0);
                }
                  else if(Month3=='Jul'){
                     qtdrec.QTD_Total_Quantity__c = (qtdrec.M1_Total_Quantity__c != null ? qtdrec.M1_Total_Quantity__c : 0) + (qtdrec.M2_Total_Quantity__c != null ? qtdrec.M2_Total_Quantity__c : 0) +(qtdrec.M3_Total_Quantity__c != null ? qtdrec.M3_Total_Quantity__c : 0 );
                }
                else{
                  
                   qtdrec.QTD_Total_Quantity__c =0; 
                }
                
              
               // qtdrec.QTD_Direct_Quantity__c = ( qtdrec.M1_Quantity__c != null ? qtdrec.M1_Quantity__c : 0) +  (qtdrec.M2_Quantity__c != null ? qtdrec.M2_Quantity__c : 0 ) +  (qtdrec.M3_Quantity__c != null ? qtdrec.M3_Quantity__c : 0) ;         
               // qtdrec.QTD_Indirect_Quantity__c = (qtdrec.M1_Indirect_Quantity__c != null ? qtdrec.M1_Indirect_Quantity__c : 0 ) +  (qtdrec.M2_Indirect_Quantity__c != null ? qtdrec.M2_Indirect_Quantity__c : 0)  +  (qtdrec.M3_Indirect_Quantity__c != null ? qtdrec.M3_Indirect_Quantity__c : 0 );
               // qtdrec.QTD_Total_Quantity__c = (qtdrec.M1_Total_Quantity__c != null ? qtdrec.M1_Total_Quantity__c : 0) + (qtdrec.M2_Total_Quantity__c != null ? qtdrec.M2_Total_Quantity__c : 0) +(qtdrec.M3_Total_Quantity__c != null ? qtdrec.M3_Total_Quantity__c : 0 );
                if(qtdrec.QTD_Direct_Quantity__c!=null){
                qtdrec.QTD_Avg_Direct_Quantity__c =  qtdrec.QTD_Direct_Quantity__c/3;
                }
                if(qtdrec.QTD_Indirect_Quantity__c!=null){
                qtdrec.QTD_Avg_Indirect_Quantity__c = qtdrec.QTD_Indirect_Quantity__c/3;
                }
                qtdrec.QTD_Avg_Total_Quantity__c = qtdrec.QTD_Total_Quantity__c/3;
                //FTD_Direct_Quantity__c
                
                system.debug('qtdrec.CTD_Direct_Quantity__c=='+qtdrec.CTD_Direct_Quantity__c);
               // system.debug('qtdrec.FTD_Direct_Quantity__c=='+qtdrec.FTD_Direct_Quantity__c);
               
                //qtdrec.FTD_Direct_Quantity__c = qtdrec.(qtdrec.M1_Quantity__c != null ? qtdrec.M1_Quantity__c : 0)+ (qtdrec.M2_Quantity__c != null ? qtdrec.M2_Quantity__c : 0)+(qtdrec.M3_Quantity__c != null ? qtdrec.M3_Quantity__c : 0);
                 if(qtdrec.Month1__c != null && FTDList.contains(qtdrec.Month1__c)){ qtdrec.FTD_Direct_Quantity__c = (qtdrec.FTD_Direct_Quantity__c != null ? qtdrec.FTD_Direct_Quantity__c : 0)+(qtdrec.M1_Quantity__c !=null ?  qtdrec.M1_Quantity__c :0);}
                if(qtdrec.Month2__c != null && FTDList.contains(qtdrec.Month2__c)){ qtdrec.FTD_Direct_Quantity__c = (qtdrec.FTD_Direct_Quantity__c != null ? qtdrec.FTD_Direct_Quantity__c : 0)+(qtdrec.M2_Quantity__c !=null ?  qtdrec.M2_Quantity__c :0);}
                if(qtdrec.Month3__c != null && FTDList.contains(qtdrec.Month3__c)){ qtdrec.FTD_Direct_Quantity__c = (qtdrec.FTD_Direct_Quantity__c != null ? qtdrec.FTD_Direct_Quantity__c : 0)+(qtdrec.M3_Quantity__c !=null ?  qtdrec.M3_Quantity__c :0);}
                if(qtdrec.Month4__c != null && FTDList.contains(qtdrec.Month4__c)){
                    if(qtdrec.FTD_Direct_Quantity__c!=null)    {             
                    qtdrec.FTD_Direct_Quantity__c = (qtdrec.FTD_Direct_Quantity__c != null ? qtdrec.FTD_Direct_Quantity__c : 0)+(qtdrec.M4_Quantity__c !=null ?  qtdrec.M4_Quantity__c :0); 
                    }
                } 
                if(qtdrec.Month5__c != null && FTDList.contains(qtdrec.Month5__c)){
                    qtdrec.FTD_Direct_Quantity__c = (qtdrec.FTD_Direct_Quantity__c != null ? qtdrec.FTD_Direct_Quantity__c : 0)+(qtdrec.M5_Quantity__c !=null ?  qtdrec.M5_Quantity__c :0);
                } 
                
                if(qtdrec.Month6__c != null && FTDList.contains(qtdrec.Month6__c)){ 
                    qtdrec.FTD_Direct_Quantity__c = (qtdrec.FTD_Direct_Quantity__c != null ? qtdrec.FTD_Direct_Quantity__c : 0)+(qtdrec.M6_Quantity__c !=null ?  qtdrec.M6_Quantity__c :0);
                }
                if(qtdrec.Month7__c != null && FTDList.contains(qtdrec.Month7__c)){
                    qtdrec.FTD_Direct_Quantity__c = (qtdrec.FTD_Direct_Quantity__c != null ? qtdrec.FTD_Direct_Quantity__c : 0)+(qtdrec.M7_Quantity__c !=null ?  qtdrec.M7_Quantity__c :0);
                }
                if(qtdrec.Month8__c != null && FTDList.contains(qtdrec.Month8__c)){
                    qtdrec.FTD_Direct_Quantity__c = (qtdrec.FTD_Direct_Quantity__c != null ? qtdrec.FTD_Direct_Quantity__c : 0)+(qtdrec.M8_Quantity__c !=null ?  qtdrec.M8_Quantity__c :0);
                }
                if(qtdrec.Month9__c != null && FTDList.contains(qtdrec.Month9__c)){ qtdrec.FTD_Direct_Quantity__c = (qtdrec.FTD_Direct_Quantity__c != null ? qtdrec.FTD_Direct_Quantity__c : 0)+(qtdrec.M9_Quantity__c !=null ?  qtdrec.M9_Quantity__c :0);}
                if(qtdrec.Month10__c != null && FTDList.contains(qtdrec.Month10__c)){ qtdrec.FTD_Direct_Quantity__c = (qtdrec.FTD_Direct_Quantity__c != null ? qtdrec.FTD_Direct_Quantity__c : 0)+(qtdrec.M10_Quantity__c !=null ?  qtdrec.M10_Quantity__c :0);}
                if(qtdrec.Month11__c != null && FTDList.contains(qtdrec.Month11__c)){ qtdrec.FTD_Direct_Quantity__c = (qtdrec.FTD_Direct_Quantity__c != null ? qtdrec.FTD_Direct_Quantity__c : 0)+(qtdrec.M11_Quantity__c !=null ?  qtdrec.M11_Quantity__c :0);}
                if(qtdrec.Month12__c != null && FTDList.contains(qtdrec.Month12__c)){ qtdrec.FTD_Direct_Quantity__c = (qtdrec.FTD_Direct_Quantity__c != null ? qtdrec.FTD_Direct_Quantity__c : 0)+(qtdrec.M12_Quantity__c !=null ?  qtdrec.M12_Quantity__c :0);}
                //FTD_Indirect_Quantity__c
                if(qtdrec.Month1__c != null && FTDList.contains(qtdrec.Month1__c)){ qtdrec.FTD_Indirect_Quantity__c = (qtdrec.FTD_Indirect_Quantity__c != null ? qtdrec.FTD_Indirect_Quantity__c : 0)+(qtdrec.M1_Indirect_Quantity__c !=null ?  qtdrec.M1_Indirect_Quantity__c :0);}
                if(qtdrec.Month2__c != null && FTDList.contains(qtdrec.Month2__c)){ qtdrec.FTD_Indirect_Quantity__c = (qtdrec.FTD_Indirect_Quantity__c != null ? qtdrec.FTD_Indirect_Quantity__c : 0)+(qtdrec.M2_Indirect_Quantity__c !=null ?  qtdrec.M2_Indirect_Quantity__c :0);}
                if(qtdrec.Month3__c != null && FTDList.contains(qtdrec.Month3__c)){ qtdrec.FTD_Indirect_Quantity__c = (qtdrec.FTD_Indirect_Quantity__c != null ? qtdrec.FTD_Indirect_Quantity__c : 0)+(qtdrec.M3_Indirect_Quantity__c !=null ?  qtdrec.M3_Indirect_Quantity__c :0);}
                if(qtdrec.Month4__c != null && FTDList.contains(qtdrec.Month4__c)) qtdrec.FTD_Indirect_Quantity__c = (qtdrec.FTD_Indirect_Quantity__c != null ? qtdrec.FTD_Indirect_Quantity__c : 0)+(qtdrec.M4_Indirect_Quantity__c !=null ?  qtdrec.M4_Indirect_Quantity__c :0);
                if(qtdrec.Month5__c != null && FTDList.contains(qtdrec.Month5__c)) qtdrec.FTD_Indirect_Quantity__c = (qtdrec.FTD_Indirect_Quantity__c != null ? qtdrec.FTD_Indirect_Quantity__c : 0)+(qtdrec.M5_Indirect_Quantity__c !=null ?  qtdrec.M5_Indirect_Quantity__c :0);
                if(qtdrec.Month6__c != null && FTDList.contains(qtdrec.Month6__c)) qtdrec.FTD_Indirect_Quantity__c = (qtdrec.FTD_Indirect_Quantity__c != null ? qtdrec.FTD_Indirect_Quantity__c : 0)+(qtdrec.M6_Indirect_Quantity__c !=null ?  qtdrec.M6_Indirect_Quantity__c :0);
                if(qtdrec.Month7__c != null && FTDList.contains(qtdrec.Month7__c)) qtdrec.FTD_Indirect_Quantity__c = (qtdrec.FTD_Indirect_Quantity__c != null ? qtdrec.FTD_Indirect_Quantity__c : 0)+(qtdrec.M7_Indirect_Quantity__c !=null ?  qtdrec.M7_Indirect_Quantity__c :0);
                if(qtdrec.Month8__c != null && FTDList.contains(qtdrec.Month8__c)) qtdrec.FTD_Indirect_Quantity__c = (qtdrec.FTD_Indirect_Quantity__c != null ? qtdrec.FTD_Indirect_Quantity__c : 0)+(qtdrec.M8_Indirect_Quantity__c !=null ?  qtdrec.M8_Indirect_Quantity__c :0);
                if(qtdrec.Month9__c != null && FTDList.contains(qtdrec.Month9__c)) qtdrec.FTD_Indirect_Quantity__c = (qtdrec.FTD_Indirect_Quantity__c != null ? qtdrec.FTD_Indirect_Quantity__c : 0)+(qtdrec.M9_Indirect_Quantity__c !=null ?  qtdrec.M9_Indirect_Quantity__c :0);
                if(qtdrec.Month10__c != null && FTDList.contains(qtdrec.Month10__c)) qtdrec.FTD_Indirect_Quantity__c = (qtdrec.FTD_Indirect_Quantity__c != null ? qtdrec.FTD_Indirect_Quantity__c : 0)+(qtdrec.M10_Indirect_Quantity__c !=null ?  qtdrec.M10_Indirect_Quantity__c :0);
                if(qtdrec.Month11__c != null && FTDList.contains(qtdrec.Month11__c)) qtdrec.FTD_Indirect_Quantity__c = (qtdrec.FTD_Indirect_Quantity__c != null ? qtdrec.FTD_Indirect_Quantity__c : 0)+(qtdrec.M11_Indirect_Quantity__c !=null ?  qtdrec.M11_Indirect_Quantity__c :0);
                if(qtdrec.Month12__c != null && FTDList.contains(qtdrec.Month12__c)) qtdrec.FTD_Indirect_Quantity__c = (qtdrec.FTD_Indirect_Quantity__c != null ? qtdrec.FTD_Indirect_Quantity__c : 0)+(qtdrec.M12_Indirect_Quantity__c !=null ?  qtdrec.M12_Indirect_Quantity__c :0);
                //FTD_Total_Quantity__c
                qtdrec.FTD_Total_Quantity__c = (qtdrec.FTD_Indirect_Quantity__c != null ? qtdrec.FTD_Indirect_Quantity__c :0) + (qtdrec.FTD_Direct_Quantity__c != null ? qtdrec.FTD_Direct_Quantity__c :0);
                
                //CTD_Indirect_Quantity__c
                if(qtdrec.Month1__c != null && CTDList.contains(qtdrec.Month1__c)){ qtdrec.CTD_Indirect_Quantity__c = (qtdrec.CTD_Indirect_Quantity__c != null ? qtdrec.CTD_Indirect_Quantity__c : 0)+(qtdrec.M1_Indirect_Quantity__c !=null ?  qtdrec.M1_Indirect_Quantity__c :0);}
                if(qtdrec.Month2__c != null && CTDList.contains(qtdrec.Month2__c)){ 
                    qtdrec.CTD_Indirect_Quantity__c = (qtdrec.CTD_Indirect_Quantity__c != null ? qtdrec.CTD_Indirect_Quantity__c : 0)+(qtdrec.M2_Indirect_Quantity__c !=null ?  qtdrec.M2_Indirect_Quantity__c :0);
                    system.debug('qtdrec.CTD_Indirect_Quantity__c==='+qtdrec.CTD_Indirect_Quantity__c);
                }
                if(qtdrec.Month3__c != null && CTDList.contains(qtdrec.Month3__c)) qtdrec.CTD_Indirect_Quantity__c = (qtdrec.CTD_Indirect_Quantity__c != null ? qtdrec.CTD_Indirect_Quantity__c : 0)+(qtdrec.M3_Indirect_Quantity__c !=null ?  qtdrec.M3_Indirect_Quantity__c :0);
                if(qtdrec.Month4__c != null && CTDList.contains(qtdrec.Month4__c)) qtdrec.CTD_Indirect_Quantity__c = (qtdrec.CTD_Indirect_Quantity__c != null ? qtdrec.CTD_Indirect_Quantity__c : 0)+(qtdrec.M4_Indirect_Quantity__c !=null ?  qtdrec.M4_Indirect_Quantity__c :0);
                if(qtdrec.Month5__c != null && CTDList.contains(qtdrec.Month5__c)) qtdrec.CTD_Indirect_Quantity__c = (qtdrec.CTD_Indirect_Quantity__c != null ? qtdrec.CTD_Indirect_Quantity__c : 0)+(qtdrec.M5_Indirect_Quantity__c !=null ?  qtdrec.M5_Indirect_Quantity__c :0);
                if(qtdrec.Month6__c != null && CTDList.contains(qtdrec.Month6__c)) qtdrec.CTD_Indirect_Quantity__c = (qtdrec.CTD_Indirect_Quantity__c != null ? qtdrec.CTD_Indirect_Quantity__c : 0)+(qtdrec.M6_Indirect_Quantity__c !=null ?  qtdrec.M6_Indirect_Quantity__c :0);
                if(qtdrec.Month7__c != null && CTDList.contains(qtdrec.Month7__c)) qtdrec.CTD_Indirect_Quantity__c = (qtdrec.CTD_Indirect_Quantity__c != null ? qtdrec.CTD_Indirect_Quantity__c : 0)+(qtdrec.M7_Indirect_Quantity__c !=null ?  qtdrec.M7_Indirect_Quantity__c :0);
                if(qtdrec.Month8__c != null && CTDList.contains(qtdrec.Month8__c)) qtdrec.CTD_Indirect_Quantity__c = (qtdrec.CTD_Indirect_Quantity__c != null ? qtdrec.CTD_Indirect_Quantity__c : 0)+(qtdrec.M8_Indirect_Quantity__c !=null ?  qtdrec.M8_Indirect_Quantity__c :0);
                if(qtdrec.Month9__c != null && CTDList.contains(qtdrec.Month9__c)) qtdrec.CTD_Indirect_Quantity__c = (qtdrec.CTD_Indirect_Quantity__c != null ? qtdrec.CTD_Indirect_Quantity__c : 0)+(qtdrec.M9_Indirect_Quantity__c !=null ?  qtdrec.M9_Indirect_Quantity__c :0);
                if(qtdrec.Month10__c != null && CTDList.contains(qtdrec.Month10__c)) qtdrec.CTD_Indirect_Quantity__c = (qtdrec.CTD_Indirect_Quantity__c != null ? qtdrec.CTD_Indirect_Quantity__c : 0)+(qtdrec.M10_Indirect_Quantity__c !=null ?  qtdrec.M10_Indirect_Quantity__c :0);
                if(qtdrec.Month11__c != null && CTDList.contains(qtdrec.Month11__c)) qtdrec.CTD_Indirect_Quantity__c = (qtdrec.CTD_Indirect_Quantity__c != null ? qtdrec.CTD_Indirect_Quantity__c : 0)+(qtdrec.M11_Indirect_Quantity__c !=null ?  qtdrec.M11_Indirect_Quantity__c :0);
                if(qtdrec.Month12__c != null && CTDList.contains(qtdrec.Month12__c)) qtdrec.CTD_Indirect_Quantity__c = (qtdrec.CTD_Indirect_Quantity__c != null ? qtdrec.CTD_Indirect_Quantity__c : 0)+(qtdrec.M12_Indirect_Quantity__c !=null ?  qtdrec.M12_Indirect_Quantity__c :0);
                //CTD_Direct_Quantity__c
                if(qtdrec.Month1__c != null && CTDList.contains(qtdrec.Month1__c)){ qtdrec.CTD_Direct_Quantity__c = (qtdrec.CTD_Direct_Quantity__c != null ? qtdrec.CTD_Direct_Quantity__c : 0) +(qtdrec.M1_Quantity__c !=null ?  qtdrec.M1_Quantity__c :0);}
                  system.debug('qtdrec.CTD_Direct_Quantity__c..1.   '+qtdrec.CTD_Direct_Quantity__c);
                if(qtdrec.Month2__c != null && CTDList.contains(qtdrec.Month2__c)){ qtdrec.CTD_Direct_Quantity__c = (qtdrec.CTD_Direct_Quantity__c != null ? qtdrec.CTD_Direct_Quantity__c : 0)+(qtdrec.M2_Quantity__c !=null ?  qtdrec.M2_Quantity__c :0);}
                      system.debug('qtdrec.CTD_Direct_Quantity__c..2.    '+qtdrec.CTD_Direct_Quantity__c);
                if(qtdrec.Month3__c != null && CTDList.contains(qtdrec.Month3__c)){ qtdrec.CTD_Direct_Quantity__c = (qtdrec.CTD_Direct_Quantity__c != null ? qtdrec.CTD_Direct_Quantity__c : 0)+(qtdrec.M3_Quantity__c !=null ?  qtdrec.M3_Quantity__c :0);}
                      system.debug('qtdrec.CTD_Direct_Quantity__c...3     '+qtdrec.CTD_Direct_Quantity__c);
                if(qtdrec.Month4__c != null && CTDList.contains(qtdrec.Month4__c)){ qtdrec.CTD_Direct_Quantity__c = (qtdrec.CTD_Direct_Quantity__c != null ? qtdrec.CTD_Direct_Quantity__c : 0)+(qtdrec.M4_Quantity__c !=null ?  qtdrec.M4_Quantity__c :0);}
                      system.debug('qtdrec.CTD_Direct_Quantity__c...4   '+qtdrec.CTD_Direct_Quantity__c);
                if(qtdrec.Month5__c != null && CTDList.contains(qtdrec.Month5__c)){ qtdrec.CTD_Direct_Quantity__c = (qtdrec.CTD_Direct_Quantity__c != null ? qtdrec.CTD_Direct_Quantity__c : 0)+(qtdrec.M5_Quantity__c !=null ?  qtdrec.M5_Quantity__c :0);}
                      system.debug('qtdrec.CTD_Direct_Quantity__c...5  '+qtdrec.CTD_Direct_Quantity__c);
                if(qtdrec.Month6__c != null && CTDList.contains(qtdrec.Month6__c)){ qtdrec.CTD_Direct_Quantity__c = (qtdrec.CTD_Direct_Quantity__c != null ? qtdrec.CTD_Direct_Quantity__c : 0)+(qtdrec.M6_Quantity__c !=null ?  qtdrec.M6_Quantity__c :0);}
                     system.debug('qtdrec.CTD_Direct_Quantity__c...6   '+qtdrec.CTD_Direct_Quantity__c);
                if(qtdrec.Month7__c != null && CTDList.contains(qtdrec.Month7__c)){ qtdrec.CTD_Direct_Quantity__c = (qtdrec.CTD_Direct_Quantity__c != null ? qtdrec.CTD_Direct_Quantity__c : 0)+(qtdrec.M7_Quantity__c !=null ?  qtdrec.M7_Quantity__c :0);}
                     system.debug('qtdrec.CTD_Direct_Quantity__c..7.   '+qtdrec.CTD_Direct_Quantity__c);
                if(qtdrec.Month8__c != null && CTDList.contains(qtdrec.Month8__c)){ qtdrec.CTD_Direct_Quantity__c = (qtdrec.CTD_Direct_Quantity__c != null ? qtdrec.CTD_Direct_Quantity__c : 0)+(qtdrec.M8_Quantity__c !=null ?  qtdrec.M8_Quantity__c :0);}
                      system.debug('qtdrec.CTD_Direct_Quantity__c..8.   '+qtdrec.CTD_Direct_Quantity__c);
                if(qtdrec.Month9__c != null && CTDList.contains(qtdrec.Month9__c)){ qtdrec.CTD_Direct_Quantity__c = (qtdrec.CTD_Direct_Quantity__c != null ? qtdrec.CTD_Direct_Quantity__c : 0)+(qtdrec.M9_Quantity__c !=null ?  qtdrec.M9_Quantity__c :0);}
                     system.debug('qtdrec.CTD_Direct_Quantity__c..9.   '+qtdrec.CTD_Direct_Quantity__c);
                if(qtdrec.Month10__c != null && CTDList.contains(qtdrec.Month10__c)){ qtdrec.CTD_Direct_Quantity__c = (qtdrec.CTD_Direct_Quantity__c != null ? qtdrec.CTD_Direct_Quantity__c : 0)+(qtdrec.M10_Quantity__c !=null ?  qtdrec.M10_Quantity__c :0);}
                      system.debug('qtdrec.CTD_Direct_Quantity__c...10   '+qtdrec.CTD_Direct_Quantity__c);
                if(qtdrec.Month11__c != null && CTDList.contains(qtdrec.Month11__c)){ qtdrec.CTD_Direct_Quantity__c = (qtdrec.CTD_Direct_Quantity__c != null ? qtdrec.CTD_Direct_Quantity__c : 0)+(qtdrec.M11_Quantity__c !=null ?  qtdrec.M11_Quantity__c :0);}
                      system.debug('qtdrec.CTD_Direct_Quantity__c...12   '+qtdrec.CTD_Direct_Quantity__c);
                if(qtdrec.Month12__c != null && CTDList.contains(qtdrec.Month12__c)){ qtdrec.CTD_Direct_Quantity__c = (qtdrec.CTD_Direct_Quantity__c != null ? qtdrec.CTD_Direct_Quantity__c : 0)+(qtdrec.M12_Quantity__c !=null ?  qtdrec.M12_Quantity__c :0);}
                //system.debug('qtdrec.CTD_Direct_Quantity__c=='+qtdrec.CTD_Direct_Quantity__c);
               // system.debug('qtdrec.FTD_Direct_Quantity__c=='+qtdrec.FTD_Direct_Quantity__c);
                     system.debug('qtdrec.CTD_Direct_Quantity__c...13   '+qtdrec.CTD_Direct_Quantity__c);
                qtdrec.CTD_Total_Quantity__c = (qtdrec.CTD_Direct_Quantity__c != null ? qtdrec.CTD_Direct_Quantity__c :0) + (qtdrec.CTD_Indirect_Quantity__c != null ? qtdrec.CTD_Indirect_Quantity__c :0);
                
                qtdrec.QTD_Direct_Awarded_Quantity__c = ((qtdrec.Awarded_Information__c != null ? qtdrec.Awarded_Information__c :0) * (qtdrec.Days_Between_QTD__c != null ? qtdrec.Days_Between_QTD__c :0))/365;
                qtdrec.QTD_Indirect_Awarded_Quantity__c = ((qtdrec.Indirect_Awarded_Information__c != null ? qtdrec.Indirect_Awarded_Information__c :0) * (qtdrec.Days_Between_QTD__c != null ? qtdrec.Days_Between_QTD__c :0))/365;
                qtdrec.QTD_Total_Awarded_Quantity__c = ((qtdrec.Total_Awarded_Information__c != null ? qtdrec.Total_Awarded_Information__c :0) * (qtdrec.Days_Between_QTD__c != null ? qtdrec.Days_Between_QTD__c :0))/365;
                
                qtdrec.FTD_Direct_Awarded_Quantity__c = ((qtdrec.Awarded_Information__c != null ? qtdrec.Awarded_Information__c :0) * (qtdrec.Days_Between_FTD__c != null ? qtdrec.Days_Between_FTD__c :0))/365;
                qtdrec.FTD_Indirect_Awarded_Quantity__c = ((qtdrec.Indirect_Awarded_Information__c != null ? qtdrec.Indirect_Awarded_Information__c :0) * (qtdrec.Days_Between_FTD__c != null ? qtdrec.Days_Between_FTD__c :0))/365;
                qtdrec.FTD_Total_Awarded_Quantity__c = ((qtdrec.Total_Awarded_Information__c != null ? qtdrec.Total_Awarded_Information__c :0) * (qtdrec.Days_Between_FTD__c != null ? qtdrec.Days_Between_FTD__c :0))/365;
                
                qtdrec.CTD_Direct_Awarded_Quantity__c = ((qtdrec.Awarded_Information__c != null ? qtdrec.Awarded_Information__c :0) * (qtdrec.Days_Between_CTD__c != null ? qtdrec.Days_Between_CTD__c :0))/365;
                qtdrec.CTD_Indirect_Awarded_Quantity__c = ((qtdrec.Indirect_Awarded_Information__c != null ? qtdrec.Indirect_Awarded_Information__c :0) * (qtdrec.Days_Between_CTD__c != null ? qtdrec.Days_Between_CTD__c :0))/365;
                qtdrec.CTD_Total_Awarded_Quantity__c = ((qtdrec.Total_Awarded_Information__c != null ? qtdrec.Total_Awarded_Information__c :0) * (qtdrec.Days_Between_CTD__c != null ? qtdrec.Days_Between_CTD__c :0))/365;
                
                updateSummaryRec.add(qtdrec);
            }
            system.debug('updateSummaryRec===='+updateSummaryRec);    
            system.debug('updateSummaryRec===='+updateSummaryRec.size());    
            if(updateSummaryRec.size()>0){
                Database.UpsertResult[] results = Database.upsert(updateSummaryRec,true);
                system.debug('results===='+results);    
            }
        }
        catch(exception e){
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'complaincequantitydata', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp; 
        }
    }
    public void finish(Database.BatchableContext BC) {}
}