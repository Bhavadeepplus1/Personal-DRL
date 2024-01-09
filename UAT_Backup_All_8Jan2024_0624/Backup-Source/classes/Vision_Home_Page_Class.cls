public class Vision_Home_Page_Class {
   /*  @AuraEnabled
    public static void getLoginDetailsUpdate() {
         User u = [SELECT Id,Login_and_Logout__c,Last_logout__c from User where id=:Userinfo.getUserId()];
        System.debug('current user==>'+Userinfo.getUserId());
            u.Last_logout__c = System.now();
            u.Login_and_Logout__c = true;
            update u;
    }*/
    @AuraEnabled
    public static MainWrapper getRecentOpportunities(){
        string userId = userInfo.getUserId();
        Timezone timeZone = userInfo.getTimeZone();
        String tz = String.valueOf(timeZone);
        //  DateTime userDate = DateTime.now();
        String userDate = DateTime.now().format('EEEE');
        string status = 'Customer'+ '\''+'s Update';

        List<String> approvalStaus = new List<String>();
        approvalStaus.add('Closed');
        approvalStaus.add('Closed-Draft');
        approvalStaus.add('Contracts Rejected');
        approvalStaus.add('Customer'+ '\''+'s Update');
        approvalStaus.add('Customer Rejected');
        approvalStaus.add('Vistex Update');
        approvalStaus.add('Vistex Update Rejected');
        approvalStaus.add('Vistex Customer Code Update');
        approvalStaus.add('Business Head Rejected'); //Added code by Rama
        approvalStaus.add('Customer Service Rejected');
        approvalStaus.add('Finance Rejected');
        approvalStaus.add('Marketing Head Rejected');
        approvalStaus.add('Marketing Lead Rejected');
        approvalStaus.add('Marketing Rejected');
        approvalStaus.add('Sr Director or VP Finance Rejected');
        approvalStaus.add('Supply Chain Rejected');
        
        //Added code by Rama
        List<String> approvalStatus = new List<String>();
        approvalStatus.add('Business Head');
        approvalStatus.add('Contracts');
        approvalStatus.add('Customer Service');
       // approvalStatus.add('Customer'+ '\''+'s Update');
        approvalStatus.add('Finance');
        approvalStatus.add('Marketing');
        approvalStatus.add('Marketing Head');
        approvalStatus.add('Marketing Lead');
        approvalStatus.add('SCM & Marketing');
        approvalStatus.add('Sr Director or VP Finance');
        approvalStatus.add('Supply Chain');
        //approvalStatus.add('Vistex Update');
        //approvalStatus.add('Vistex Customer Code Update');
       
        Date Date1;
        Date Date2;
        if(userDate == 'Friday'){
            Date1 = System.today();
            
            Date2 = System.today()+3;
             
        }
        else if(userDate == 'Saturday'){
            Date1 = System.today()+2;
            Date2 = System.today()+3;    
        }
        else if(userDate == 'Sunday'){
            Date1 = System.today()+1;
            Date2 = System.today()+2;    
        }
        else{
            Date1 = System.today();
            Date2 = System.today()+1;    
        }
        MainWrapper mainWrap = new MainWrapper();
        List<Opportunity> oppList = [SELECT ID,Name,CloseDate,Vision_Opportunity_Value__c,CreatedDate,Amount,StageName,Account.Name,AccountId, (SELECT Id,Name,Vision_Bid__c from Product_Opportunity__r where Product__c!=null) from Opportunity WHERE StageName = : 'Opportunity in progress' and   CreatedById =: userInfo.getUserId() order by CreatedDate DESC limit 10]; 
         mainwrap.oppList =oppList;
    
        List<Vision_Market_Share_Expansion__c> marketExpansionList = [SELECT ID,CreatedDate,Vision_Product_Family__c ,Task_Ident__c,Vision_Product__r.Phoenix_Product_Director__r.Name,Vision_Customer__c,Vision_Customer__r.Name,Vision_Customer__r.OwnerId,Vision_Product__r.Name,Task_Status__c,Vision_scm_manager__c,Vision_scm_approved_date__c,Vision_supply_requirement__c,
               Vision_confidence_level__c,Vision_customer_expectation_lead_time__c,Vision_supply_effectivedate_SCM__c,Vision_remarks_by_pm__c,Vision_remarks_by_scm__c,
               Vision_total_incremental_volume_by_scm__c,Vision_total_initial_order_quantity_by_s__c,Vision_supply_duration_scm__c,Vision_sku_split_flag__c,
               Vision_incremental_volume_by_scm__c,Vision_initialorder_volume_by_scm__c,Vision_india_scm_approved_by__c,Vision_india_scm_approved_on_date__c,
               Vision_india_scm_remarks__c,Vision_ext_mfg_scm_approved_by__c,Vision_ext_mfg_scm_approved_on_date__c,Vision_ext_mfg_scm_remarks__c
               from Vision_Market_Share_Expansion__c WHERE Vision_Customer__r.OwnerId =: userInfo.getUserId() order by CreatedDate DESC limit 10]; 
        
        Map<String, Vision_Market_Share_Expansion__c> expListMap = new Map<String, Vision_Market_Share_Expansion__c>();
        for(Vision_Market_Share_Expansion__c expnObj : marketExpansionList){
            if(!expListMap.containsKey(expnObj.Task_Ident__c))
                expListMap.put(expnObj.Task_Ident__c, expnObj);
            
        }
        mainWrap.marketExpansionList=expListMap.values();
       
        List<Phoenix_Bid__c> bidsList = [SELECT ID,Phoenix_Bid_Name__c,Name,Phoenix_Customer__c,Phoenix_Bid_Type__c,Phoenix_Customer__r.Name,Phoenix_Status__c,Phoenix_Approval_Status__c,Phoenix_Bid_Deadline_Date__c,Phoenix_Sent_to_Customer_Date__c,Phoenix_Internal_Target_Date__c  from Phoenix_Bid__c where (Phoenix_Bid_Owner__c =:userInfo.getUserId() or Phoenix_Salesperson__c =:userInfo.getUserId())  and ((Phoenix_Internal_Target_Date__c =:Date1 OR Phoenix_Internal_Target_Date__c >=: Date2) AND Phoenix_Approval_Status__c IN: approvalStatus) order by CreatedDate DESC limit 10]; 
        mainWrap.bidsList=bidsList;
        List<Phoenix_Bid__c> bidsCustomerUpdate = [SELECT ID,Phoenix_Bid_Name__c,Name,Phoenix_Customer__c,Phoenix_Bid_Type__c,Phoenix_Customer__r.Name,Phoenix_Status__c,Phoenix_Approval_Status__c,Phoenix_Bid_Deadline_Date__c,Phoenix_Sent_to_Customer_Date__c,Phoenix_Internal_Target_Date__c  from Phoenix_Bid__c where Phoenix_Approval_Status__c =: status and (Phoenix_Bid_Owner__c =:userInfo.getUserId() or Phoenix_Salesperson__c =:userInfo.getUserId()) order by CreatedDate DESC limit 10]; 
         mainWrap.bidsCustomerUpdate=bidsCustomerUpdate;
        List<Phoenix_Bid__c> bidsPastList = [SELECT ID,Phoenix_Bid_Name__c,Name,Phoenix_Customer__c,Phoenix_Bid_Type__c,Phoenix_Customer__r.Name,Phoenix_Status__c,Phoenix_Approval_Status__c,Phoenix_Bid_Deadline_Date__c,Phoenix_Sent_to_Customer_Date__c,Phoenix_Internal_Target_Date__c  from Phoenix_Bid__c where (Phoenix_Bid_Owner__c =:userInfo.getUserId() or Phoenix_Salesperson__c =:userInfo.getUserId()) and Phoenix_Internal_Target_Date__c < Today and Phoenix_Approval_Status__c NOT IN: approvalStaus order by CreatedDate DESC limit 10]; 
         mainWrap.bidsPastList=bidsPastList;
        List<Task> tasksList = [SELECT ID,Subject,WhatId,Description,Status,ActivityDate from Task where CreatedById =:userInfo.getUserId() order by CreatedDate DESC  limit 10]; 
        mainWrap.tasksList=tasksList;
        List<Event> eventList = [SELECT ID,Subject,WhatId,Type,Description,ActivityDate from Event where CreatedById =:userInfo.getUserId() order by CreatedDate DESC  limit 10]; 
        mainWrap.eventList=eventList;
        List<Vision_Alert__c> alertList = [SELECT ID,Name,Vision_Alert_Type__c,Vision_Notification_Due_Date__c from Vision_Alert__c where CreatedById =:userInfo.getUserId() order by CreatedDate DESC limit 10]; 
        mainWrap.alertList=alertList;
        return mainWrap;
        
    }
    
    
    @AuraEnabled
    public static MainWrapper getBidActions(){
        string userId = userInfo.getUserId();
        Timezone timeZone = userInfo.getTimeZone();
        String tz = String.valueOf(timeZone);
        //  DateTime userDate = DateTime.now();
        String userDate = DateTime.now().format('EEEE');
        string status = 'Customer'+ '\''+'s Update';
         
        //Added code by Rama
        List<String> approvalStatus2 = new List<String>();
        approvalStatus2.add('Business Head');
        approvalStatus2.add('Contracts');
        approvalStatus2.add('Customer Service');
        //approvalStatus2.add('Customer'+ '\''+'s Update');
        approvalStatus2.add('Finance');
        approvalStatus2.add('Marketing');
        approvalStatus2.add('Marketing Head');
        approvalStatus2.add('Marketing Lead');
        approvalStatus2.add('SCM & Marketing');
        approvalStatus2.add('Sr Director or VP Finance');
        approvalStatus2.add('Supply Chain');
       // approvalStatus2.add('Vistex Update');
        //approvalStatus2.add('Vistex Customer Code Update');
        
        Date Date1;
        Date Date2;
        if(userDate == 'Friday'){
            Date1 = System.today();
            Date2 = System.today()+3;
           }
        else if(userDate == 'Saturday'){
            Date1 = System.today()+2;
            Date2 = System.today()+3;    
        }
        else if(userDate == 'Sunday'){
            Date1 = System.today()+1;
            Date2 = System.today()+2;    
        }
        else{
            Date1 = System.today();
            Date2 = System.today()+1;    
        }
        MainWrapper mainWrap = new MainWrapper(); 
        List<BidPastActionWrapper> BidPastActionWrapperList = new List<BidPastActionWrapper>();
        List<BidUpcomingActionWrapper> BidUpcomingActionWrapperList = new List<BidUpcomingActionWrapper>();
        
        List<Phoenix_Bid__c> bidsList = [SELECT ID,Phoenix_Bid_Name__c,Name,Phoenix_Customer__c,Phoenix_Bid_Type__c,Phoenix_Customer__r.Name,Phoenix_Status__c,Phoenix_Approval_Status__c,Phoenix_Bid_Deadline_Date__c,Phoenix_Sent_to_Customer_Date__c,Phoenix_Internal_Target_Date__c  from Phoenix_Bid__c where (Phoenix_Bid_Owner__c =: userInfo.getUserId() or Phoenix_Salesperson__c =:userInfo.getUserId()) and ((Phoenix_Bid_Deadline_Date__c =:Date1 OR Phoenix_Bid_Deadline_Date__c >=:Date2) AND Phoenix_Approval_Status__c IN: approvalStatus2) order by CreatedDate DESC LIMIT 10]; 
         mainWrap.bidsList=bidsList;
        List<Phoenix_Bid__c> bidsPastList = [SELECT ID,Phoenix_Bid_Name__c,Name,Phoenix_Customer__c,Phoenix_Bid_Type__c,Phoenix_Customer__r.Name,Phoenix_Status__c,Phoenix_Approval_Status__c,Phoenix_Bid_Deadline_Date__c,Phoenix_Sent_to_Customer_Date__c,Phoenix_Internal_Target_Date__c  from Phoenix_Bid__c where (Phoenix_Bid_Owner__c =: userInfo.getUserId() or Phoenix_Salesperson__c =:userInfo.getUserId()) and Phoenix_Bid_Deadline_Date__c < Today  order by CreatedDate DESC LIMIT 10]; 
        mainWrap.bidsPastList=bidsPastList;
        if(bidsPastList.size() >0){
        for(Phoenix_Bid__c past : bidsPastList){
            BidPastActionWrapper wrap = new BidPastActionWrapper();
            wrap.NoOfDays = past.Phoenix_Internal_Target_Date__c.daysBetween(system.Today());
            wrap.bidNo = past.Name;
            wrap.bidName = past.Phoenix_Bid_Name__c;
            wrap.bidtype = past.Phoenix_Bid_Type__c;
            wrap.Customer = past.Phoenix_Customer__r.Name;
            wrap.Status = past.Phoenix_Approval_Status__c;
            wrap.bidId = past.Id;
            wrap.custId = past.Phoenix_Customer__c;
            
            BidPastActionWrapperList.add(wrap);
        }
        }
        mainWrap.BidPastActionList = BidPastActionWrapperList;
                if(bidsList.size() >0){
        for(Phoenix_Bid__c upcoming : bidsList){
            BidUpcomingActionWrapper wrap = new BidUpcomingActionWrapper();
            wrap.NoOfDays = system.Today().daysBetween(upcoming.Phoenix_Bid_Deadline_Date__c);
            wrap.bidNo = upcoming.Name;
            wrap.bidName = upcoming.Phoenix_Bid_Name__c;
            wrap.bidtype = upcoming.Phoenix_Bid_Type__c;
            wrap.Customer = upcoming.Phoenix_Customer__r.Name;
            wrap.Status = upcoming.Phoenix_Approval_Status__c;
            wrap.bidId = upcoming.Id;
            wrap.custId = upcoming.Phoenix_Customer__c;
            BidUpcomingActionWrapperList.add(wrap);
        }
                }
        mainWrap.BidUpcomingActionList = BidUpcomingActionWrapperList;
        return mainWrap;
    }
    public class MainWrapper{
        @AuraEnabled public List<Phoenix_Bid__c> bidsPastList; 
        @AuraEnabled public List<Phoenix_Bid__c> bidsCustomerUpdate;    
        @AuraEnabled public List<Vision_Market_Share_Expansion__c> marketExpansionList; 
        @AuraEnabled public List<Phoenix_Bid__c> bidsList;
        @AuraEnabled public List<Task> tasksList;   
        @AuraEnabled public List<Event> eventList;
        @AuraEnabled public List<Opportunity> oppList;
        @AuraEnabled public List<Vision_Alert__c> alertList;
        @AuraEnabled public List<BidPastActionWrapper> BidPastActionList;
        @AuraEnabled public List<BidUpcomingActionWrapper> BidUpcomingActionList;
        
        MainWrapper(){
            marketExpansionList=new List<Vision_Market_Share_Expansion__c>();
            bidsCustomerUpdate = new List<Phoenix_Bid__c>();
            bidsPastList = new List<Phoenix_Bid__c>();
            bidsList = new List<Phoenix_Bid__c>();
            tasksList = new List<Task>();
            oppList = new List<Opportunity>();
            eventList = new List<Event>();
            alertList = new List<Vision_Alert__c>();
            BidPastActionList = new List<BidPastActionWrapper>();
            BidUpcomingActionList = new List<BidUpcomingActionWrapper>();
            
        }
    }
    public class BidPastActionWrapper{
        @AuraEnabled public Integer NoOfDays; 
        @AuraEnabled public String bidNo;
        @AuraEnabled public String bidName;
        @AuraEnabled public String bidtype;
        @AuraEnabled public String Customer;
        @AuraEnabled public String Status;
        @AuraEnabled public String bidId;
        @AuraEnabled public String custId;
        
    }
    public class BidUpcomingActionWrapper{   
        @AuraEnabled public Integer NoOfDays;
        @AuraEnabled public String bidNo;
        @AuraEnabled public String bidName;
        @AuraEnabled public String bidtype;
        @AuraEnabled public String Customer;
        @AuraEnabled public String Status;
        @AuraEnabled public String bidId;
        @AuraEnabled public String custId;
        
    }
}