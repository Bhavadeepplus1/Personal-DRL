public class Vision_CalenderClass {
    @auraEnabled
    public static Account getAccObj(String accId){
        String query = 'SELECT '+Phoenix_Util.getsObjectFieds('Account')+' FROM Account WHERE Id=: accId';
        Account accObj = Database.query(query);
        return accObj;
    }
    
    @AuraEnabled
    public static List<CalendarWrapper> fetchOpportunitiesAndBids(String accountId, String Comparision){
       try{
            List<Opportunity> oppList = New List<Opportunity>();
            if(Comparision == 'opps')
            {
               oppList = [Select Id, Name, Vision_Opportunity_Number__c, Vision_Internal_Closing_Date__c, Bid_Type__c,
                                         Description, Type, StageName, 	Vision_Customer_Closing_Date__c, Account.Name
                                         From Opportunity 
                                         Where AccountId = : accountId]; 
            }
            List<Phoenix_Bid__c> bidList = New List<Phoenix_Bid__c>();
            if(Comparision == 'bids')
            {
               bidList = [Select Id, Name, Phoenix_Bid_Name__c,  Phoenix_Internal_Target_Date__c,
                                            Phoenix_Bid_Type__c, Phoenix_Comments__c, Phoenix_Proactive_Reactive__c,
                                            Phoenix_Approval_Status__c, Phoenix_Bid_Submitted_Date__c, 
                                            Phoenix_Bid_Deadline_Date__c, Phoenix_Customer__r.Name
                                            From  Phoenix_Bid__c
                                            Where Phoenix_Customer__c = : accountId]; 
            }
            List<Vision_Market_Share_Expansion__c> panoramaList = New List<Vision_Market_Share_Expansion__c>();
            if(Comparision == 'panorama')
            {
                panoramaList = [Select Id, Name, GCP_Product_Family__c,Vision_Internal_Target_Date__c, Plan_End_Date__c,
                                                                   Plan_Start_Date__c,Plan_Contract_Effective_Date__c,Task_Comment__c,
                                                                   Task_Type__c, 	Task_Status__c, Task_Variant__c,Vision_Product_Family__c
                                                                   From  Vision_Market_Share_Expansion__c
                                                                   Where Vision_Customer__c = : accountId];
            }
            List<Task> taskList = New List<Task>();
            if(Comparision == 'task')
            {
               taskList = [Select Id, Subject, ActivityDate,Status
                                   From Task 
                                   Where WhatId = : accountId]; 
            }
            List<Event> eventList = New List<Event>();
            if(Comparision == 'event')
            {
              eventList = [Select Id, Subject, StartDateTime, EndDateTime
                                     From Event 
                                     Where WhatId = : accountId];  
            }
            List<Vision_Alert__c> alertsList = New List<Vision_Alert__c>();
          /*  if(Comparision == '')
            {
               alertsList = [Select Id, Name, 	Vision_Notification_Due_Date__c
                                                From Vision_Alert__c 
                                                Where Account__c = : accountId]; 
            }*/
            List<Phoenix_Contract__c> contractList = New List<Phoenix_Contract__c>();
            if(Comparision == 'contract')
            {
                contractList = [Select Id, Name, Phoenix_Contract_External_Description__c,
                                                      Phoenix_Contract_Internal_Description__c,Phoenix_Contract_Start_Date__c,
                                                      Phoenix_Contract_Status__c,Phoenix_Contract_End_Date__c
                                                      from Phoenix_Contract__c Where Phoenix_Customer__c = : accountId];
            }
            if(Comparision == 'all')
            {
                oppList = [Select Id, Name, Vision_Opportunity_Number__c, Vision_Internal_Closing_Date__c, Bid_Type__c,
                                         Description, Type, StageName, 	Vision_Customer_Closing_Date__c, Account.Name
                                         From Opportunity 
                                         Where AccountId = : accountId]; 
                bidList = [Select Id, Name, Phoenix_Bid_Name__c,  Phoenix_Internal_Target_Date__c,
                                            Phoenix_Bid_Type__c, Phoenix_Comments__c, Phoenix_Proactive_Reactive__c,
                                            Phoenix_Approval_Status__c, Phoenix_Bid_Submitted_Date__c, 
                                            Phoenix_Bid_Deadline_Date__c, Phoenix_Customer__r.Name
                                            From  Phoenix_Bid__c
                                            Where Phoenix_Customer__c = : accountId];
                panoramaList = [Select Id, Name, GCP_Product_Family__c,Vision_Internal_Target_Date__c, Plan_End_Date__c,
                                                                   Plan_Start_Date__c,Plan_Contract_Effective_Date__c,Task_Comment__c,
                                                                   Task_Type__c, 	Task_Status__c, Task_Variant__c,Vision_Product_Family__c
                                                                   From  Vision_Market_Share_Expansion__c
                                                                   Where Vision_Customer__c = : accountId];
                taskList = [Select Id, Subject, ActivityDate,Status
                                   From Task 
                                   Where WhatId = : accountId];
                eventList = [Select Id, Subject, StartDateTime, EndDateTime
                                     From Event 
                                     Where WhatId = : accountId];
                alertsList = [Select Id, Name, 	Vision_Notification_Due_Date__c
                                                From Vision_Alert__c 
                                                Where Account__c = : accountId];
                
                contractList = [Select Id, Name, Phoenix_Contract_External_Description__c,
                                                      Phoenix_Contract_Internal_Description__c,Phoenix_Contract_Start_Date__c,
                                                      Phoenix_Contract_Status__c,Phoenix_Contract_End_Date__c
                                                      from Phoenix_Contract__c Where Phoenix_Customer__c = : accountId];
            }
            
            Map<String, Vision_Market_Share_Expansion__c> mapPanoramaList = new Map<String,Vision_Market_Share_Expansion__c>();
            for(Vision_Market_Share_Expansion__c panorama : panoramaList ){
                
                if(!mapPanoramaList.containsKey(panorama.Vision_Product_Family__c)){mapPanoramaList.put(panorama.Vision_Product_Family__c, panorama);
                    
                }
                
            } 
            
            List<CalendarWrapper> calendarWrapperList = new List<CalendarWrapper>();
            if(contractList.size() > 0){
                for(Phoenix_Contract__c con : contractList){
                     CalendarWrapper cw = new CalendarWrapper();
                    cw.id = con.Id;
                    cw.name = con.Phoenix_Contract_External_Description__c;
                    cw.startDate = con.Phoenix_Contract_Start_Date__c;
                    cw.endDate = con.Phoenix_Contract_End_Date__c;//bid.Phoenix_Internal_Target_Date__c;
                    cw.status = con.Phoenix_Contract_Status__c; 
                    cw.type = 'Contract';
                    calendarWrapperList.add(cw);
                    
                }
                 for(Phoenix_Contract__c con : contractList){
                    CalendarWrapper cw = new CalendarWrapper();
                    cw.id = con.Id;
                    cw.name = con.Phoenix_Contract_External_Description__c;
                    cw.startDate = con.Phoenix_Contract_Start_Date__c;
                    cw.endDate = con.Phoenix_Contract_End_Date__c;//bid.Phoenix_Internal_Target_Date__c;
                    cw.status = con.Phoenix_Contract_Status__c; 
                    cw.type = 'Contract Start Date';
                    calendarWrapperList.add(cw);
                    
                }
            }
            if(taskList.size() > 0){
                for(Task task : taskList){
                    if(task.ActivityDate != null){
                        CalendarWrapper cw = new CalendarWrapper();
                        cw.id = task.Id;
                        cw.name = task.Subject;
                        cw.status = task.Status;
                        cw.startDate = task.ActivityDate;
                        cw.type = 'Task';
                        calendarWrapperList.add(cw);
                    }
                }
            }
           if(eventList.size() > 0){
                for(Event event : eventList){
                    if(event.StartDateTime != null){
                        CalendarWrapper cw = new CalendarWrapper();
                        cw.id = event.Id;
                        cw.name = event.Subject;
                        cw.startDateTime= event.StartDateTime;
                        cw.endDateTime= event.EndDateTime;
                        cw.startDate = Date.newinstance(event.StartDateTime.year(), event.StartDateTime.month(), event.StartDateTime.day());
                        cw.endDate = event.EndDateTime != null ? Date.newinstance(event.EndDateTime.year(), event.EndDateTime.month(), event.EndDateTime.day()) : null;
                        cw.type = 'Event';
                        calendarWrapperList.add(cw);
                    }
                }
            }
            if(alertsList.size() > 0){
                for(Vision_Alert__c alert : alertsList){
                    //if(event.StartDateTime != null){
                    CalendarWrapper cw = new CalendarWrapper();
                    cw.id = alert.Id;
                    cw.name = alert.Name;
                    cw.startDate = alert.Vision_Notification_Due_Date__c;
                    //Date.newinstance(event.StartDateTime.year(), event.StartDateTime.month(), event.StartDateTime.day());
                    cw.endDate = alert.Vision_Notification_Due_Date__c;
                    //event.EndDateTime != null ? Date.newinstance(event.EndDateTime.year(), event.EndDateTime.month(), event.EndDateTime.day()) : null;
                    cw.type = 'Alert';
                    calendarWrapperList.add(cw);
                    //}
                }
            }
            if(oppList.size() > 0){
                for(Opportunity opp : oppList){
                    if(opp.Vision_Internal_Closing_Date__c != null){
                        CalendarWrapper cw = new CalendarWrapper();
                        cw.id = opp.Id;
                        cw.name = opp.Name;
                        cw.bidOppNumber = opp.Vision_Opportunity_Number__c;
                        cw.internalClosingDate = opp.Vision_Internal_Closing_Date__c;
                        cw.startDate = opp.Vision_Internal_Closing_Date__c;
                        cw.customerClosingDate =  opp.Vision_Customer_Closing_Date__c;
                        cw.endDate = opp.Vision_Customer_Closing_Date__c;//opp.Vision_Internal_Closing_Date__c;
                        cw.status = opp.StageName;
                        cw.type = 'Opportunity';
                        calendarWrapperList.add(cw);
                    }
                }
            }
           if(bidList.size() > 0){
                for(Phoenix_Bid__c bid : bidList){
                    if(bid.Phoenix_Internal_Target_Date__c != null){
                        CalendarWrapper cw = new CalendarWrapper();
                        cw.id = bid.Id;
                        cw.name = bid.Phoenix_Bid_Name__c;
                        cw.bidOppNumber = bid.Name;
                        cw.internalClosingDate = bid.Phoenix_Internal_Target_Date__c;
                        cw.startDate = bid.Phoenix_Internal_Target_Date__c;
                        cw.endDate = bid.Phoenix_Bid_Deadline_Date__c;//bid.Phoenix_Internal_Target_Date__c;
                        cw.customerClosingDate = bid.Phoenix_Bid_Deadline_Date__c;
                        cw.status = bid.Phoenix_Approval_Status__c;
                        cw.bidType = bid.Phoenix_Bid_Type__c;
                        cw.type = 'Bid';
                        calendarWrapperList.add(cw);
                    }
                }
            }
            if(mapPanoramaList.size() > 0){
                for(Vision_Market_Share_Expansion__c panorama : mapPanoramaList.values()){
                    // if(panorama.Plan_Start_Date__c != null){
                    CalendarWrapper cw = new CalendarWrapper();
                    cw.id = panorama.Id;
                    cw.name = panorama.Vision_Product_Family__c;
                    cw.startDate = panorama.Vision_Internal_Target_Date__c;//Plan_Contract_Effective_Date__c; // panorama.Plan_Start_Date__c;
                    cw.endDate = panorama.Plan_Contract_Effective_Date__c ;//panorama.Plan_End_Date__c;
                    cw.internalClosingDate = panorama.Vision_Internal_Target_Date__c;
                    cw.status = panorama.Task_Status__c;
                    cw.type = 'Panorama Task';
                    calendarWrapperList.add(cw);
                    // }
                }
            }
            return calendarWrapperList;
            
        }
        catch(Exception ex){
           return null;
        }
    }
   /* @AuraEnabled
    public static List<CalendarWrapper> fetchContracts(String accountId){
        List<Phoenix_Contract__c> contractList = [Select Id, Name, Phoenix_Contract_External_Description__c,
                                                  Phoenix_Contract_Internal_Description__c,Phoenix_Contract_Start_Date__c,
                                                  Phoenix_Contract_Status__c,Phoenix_Contract_End_Date__c
                                                  from Phoenix_Contract__c Where Phoenix_Customer__c = : accountId];
        List<CalendarWrapper> calendarWrapperList = new List<CalendarWrapper>();
        if(contractList.size() > 0){
            for(Phoenix_Contract__c con : contractList){
                CalendarWrapper cw = new CalendarWrapper();
                cw.id = con.Id;
                cw.name = con.Phoenix_Contract_External_Description__c;
                cw.startDate = con.Phoenix_Contract_Start_Date__c;
                cw.endDate = con.Phoenix_Contract_End_Date__c;//bid.Phoenix_Internal_Target_Date__c;
                cw.status = con.Phoenix_Contract_Status__c; 
                cw.type = 'Contract';
                calendarWrapperList.add(cw);
                
            }
        }
        return calendarWrapperList;
        
    }
    @AuraEnabled
    public static List<CalendarWrapper> fetchBids(String accountId){
        try{
            List<Phoenix_Bid__c> bidList = [Select Id, Name, Phoenix_Bid_Name__c,  Phoenix_Internal_Target_Date__c,
                                            Phoenix_Bid_Type__c, Phoenix_Comments__c, Phoenix_Proactive_Reactive__c,
                                            Phoenix_Approval_Status__c, Phoenix_Bid_Submitted_Date__c, 
                                            Phoenix_Bid_Deadline_Date__c, Phoenix_Customer__r.Name
                                            From  Phoenix_Bid__c
                                            Where Phoenix_Customer__c = : accountId];
            List<CalendarWrapper> calendarWrapperList = new List<CalendarWrapper>();
            if(bidList.size() > 0){
                for(Phoenix_Bid__c bid : bidList){
                    if(bid.Phoenix_Internal_Target_Date__c != null){
                        CalendarWrapper cw = new CalendarWrapper();
                        cw.id = bid.Id;
                        cw.name = bid.Phoenix_Bid_Name__c;
                        cw.bidOppNumber = bid.Name;
                        cw.internalClosingDate = bid.Phoenix_Internal_Target_Date__c;
                        cw.startDate = bid.Phoenix_Internal_Target_Date__c;
                        cw.endDate = bid.Phoenix_Bid_Deadline_Date__c;//bid.Phoenix_Internal_Target_Date__c;
                        cw.customerClosingDate = bid.Phoenix_Bid_Deadline_Date__c;
                        cw.status = bid.Phoenix_Approval_Status__c;
                        cw.bidType = bid.Phoenix_Bid_Type__c;
                        cw.type = 'Bid';
                        calendarWrapperList.add(cw);
                    }
                }
            }
            
            
            return calendarWrapperList;
            
        }
        catch(Exception ex){
            return null;
        }
    }
    @AuraEnabled
    public static List<CalendarWrapper> fetchOpportunities(String accountId){
         try{
            
            
            List<Opportunity> oppList = [Select Id, Name, Vision_Opportunity_Number__c, Vision_Internal_Closing_Date__c, Bid_Type__c,
                                         Description, Type, StageName, 	Vision_Customer_Closing_Date__c, Account.Name
                                         From Opportunity 
                                         Where AccountId = : accountId];
            
            
            
            
            List<CalendarWrapper> calendarWrapperList = new List<CalendarWrapper>();
            
            if(oppList.size() > 0){
                for(Opportunity opp : oppList){
                    if(opp.Vision_Internal_Closing_Date__c != null){
                        CalendarWrapper cw = new CalendarWrapper();
                        cw.id = opp.Id;
                        cw.name = opp.Name;
                        cw.bidOppNumber = opp.Vision_Opportunity_Number__c;
                        cw.internalClosingDate = opp.Vision_Internal_Closing_Date__c;
                        cw.startDate = opp.Vision_Internal_Closing_Date__c;
                        cw.customerClosingDate =  opp.Vision_Customer_Closing_Date__c;
                        cw.endDate = opp.Vision_Customer_Closing_Date__c;//opp.Vision_Internal_Closing_Date__c;
                        cw.status = opp.StageName;
                        cw.type = 'Opportunity';
                        calendarWrapperList.add(cw);
                    }
                }
            }
            return calendarWrapperList;
            
        }
        catch(Exception ex){
 return null;
        }
    } @AuraEnabled
    public static List<CalendarWrapper> fetchMarketShareExpn(String accountId){
        try{
            
            
            
            List<Vision_Market_Share_Expansion__c> panoramaList = [Select Id, Name, GCP_Product_Family__c,Vision_Internal_Target_Date__c, Plan_End_Date__c,
                                                                   Plan_Start_Date__c,Plan_Contract_Effective_Date__c,Task_Comment__c,
                                                                   Task_Type__c, 	Task_Status__c, Task_Variant__c,Vision_Product_Family__c
                                                                   From  Vision_Market_Share_Expansion__c
                                                                   Where Vision_Customer__c = : accountId];
            Map<String, Vision_Market_Share_Expansion__c> mapPanoramaList = new Map<String,Vision_Market_Share_Expansion__c>();
            for(Vision_Market_Share_Expansion__c panorama : panoramaList ){
                
                if(!mapPanoramaList.containsKey(panorama.Vision_Product_Family__c)){
                    mapPanoramaList.put(panorama.Vision_Product_Family__c, 
                                        panorama);
                    
                }
                
            } 
            
            
            List<CalendarWrapper> calendarWrapperList = new List<CalendarWrapper>();
            
            if(mapPanoramaList.size() > 0){
                for(Vision_Market_Share_Expansion__c panorama : mapPanoramaList.values()){
                    // if(panorama.Plan_Start_Date__c != null){
                    CalendarWrapper cw = new CalendarWrapper();
                    cw.id = panorama.Id;
                    cw.name = panorama.Vision_Product_Family__c;
                    cw.startDate = panorama.Vision_Internal_Target_Date__c;//Plan_Contract_Effective_Date__c; // panorama.Plan_Start_Date__c;
                    cw.endDate = panorama.Plan_Contract_Effective_Date__c ;//panorama.Plan_End_Date__c;
                    cw.internalClosingDate = panorama.Vision_Internal_Target_Date__c;
                    cw.status = panorama.Task_Status__c;
                    cw.type = 'Panorama Task';
                    calendarWrapperList.add(cw);
                    // }
                }
            }
            return calendarWrapperList;
            
        }
        catch(Exception ex){
           return null;
        }
    } @AuraEnabled
    public static List<CalendarWrapper> fetchTask(String accountId, String Comparision){
         try{
            
            List<Task> taskList = [Select Id, Subject, ActivityDate,Status
                                   From Task 
                                   Where WhatId = : accountId];
            
            List<CalendarWrapper> calendarWrapperList = new List<CalendarWrapper>();
            if(taskList.size() > 0){
                for(Task task : taskList){
                    if(task.ActivityDate != null){
                        CalendarWrapper cw = new CalendarWrapper();
                        cw.id = task.Id;
                        cw.name = task.Subject;
                        cw.status = task.Status;
                        cw.startDate = task.ActivityDate;
                        cw.type = 'Task';
                        calendarWrapperList.add(cw);
                    }
                }
            }
            
            
            return calendarWrapperList;
            
        }
        catch(Exception ex){
            System.debug('Error: ' + ex.getMessage());
            return null;
        }
    } @AuraEnabled
    public static List<CalendarWrapper> fetchEvent(String accountId){
        System.debug('fetchOpportunitiesAndBids starts');
        System.debug('accountId: ' + accountId);
        try{
            
            
            
            List<Event> eventList = [Select Id, Subject, StartDateTime, EndDateTime
                                     From Event 
                                     Where WhatId = : accountId];
            
            
            
            
            List<CalendarWrapper> calendarWrapperList = new List<CalendarWrapper>();
            
            
            if(eventList.size() > 0){
                for(Event event : eventList){
                    if(event.StartDateTime != null){
                        CalendarWrapper cw = new CalendarWrapper();
                        cw.id = event.Id;
                        cw.name = event.Subject;
                        cw.startDateTime= event.StartDateTime;
                        cw.endDateTime= event.EndDateTime;
                        cw.startDate = Date.newinstance(event.StartDateTime.year(), event.StartDateTime.month(), event.StartDateTime.day());
                        cw.endDate = event.EndDateTime != null ? Date.newinstance(event.EndDateTime.year(), event.EndDateTime.month(), event.EndDateTime.day()) : null;
                        cw.type = 'Event';
                        calendarWrapperList.add(cw);
                    }
                }
            }
            
            return calendarWrapperList;
            
        }
        catch(Exception ex){
            System.debug('Error: ' + ex.getMessage());
            return null;
        }
    }
    @AuraEnabled
    public static List<Contact> getContactScores(String accountId){
        try{
            System.debug('getContactScores starts');
            System.debug('accountId: ' + accountId);
            List<Contact> contactList = [Select Id, Name, Influence_Score__c, Affinity_Score__c From Contact Where AccountId = : accountId];
            return contactList;
        }
        catch(Exception ex){
            System.debug('Error: ' + ex.getMessage());
            return null;
        }
    }*/
    
    public class CalendarWrapper{
        @AuraEnabled
        public ID id{ get; set; }
        
        @AuraEnabled
        public String name{ get; set; }
        
        @AuraEnabled
        public String bidOppNumber{ get; set; }
        
        @AuraEnabled
        public String bidType{ get; set; }
        
        @AuraEnabled
        public Date internalClosingDate{ get; set; }
        
        @AuraEnabled
        public Date customerClosingDate{ get; set; }
        
        @AuraEnabled
        public Date startDate{ get; set; }
        @AuraEnabled
        public DateTime startDateTime{ get; set; }
        @AuraEnabled
        public DateTime endDateTime{ get; set; }
        @AuraEnabled
        public Date endDate{ get; set; }
        
        @AuraEnabled
        public String status{ get; set; }
        
        @AuraEnabled
        public String type{ get; set; }
    }
    
    
    @AuraEnabled
    public static void updateEvent(string eventid,string eventdate){
       
        string eventdatelist = eventdate.replace('T',' ');
        Event e= new event(id = eventid);
        e.StartDateTime = DateTime.valueof(eventdatelist);
        update e;
        
    }
}