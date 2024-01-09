public without sharing class CalenderController {
    
    @AuraEnabled
    public static List<CalendarWrapper> fetchOpportunitiesAndBids(String accountId){
        System.debug('fetchOpportunitiesAndBids starts');
        System.debug('accountId: ' + accountId);
        try{
            /*
            List<Opportunity> oppList = [Select Id, Name, Opportunity_Number__c, Internal_Closing_Date__c, Bid_Type__c,
                                         Description, Type, StageName, Customer_Closing_Date__c, Account.Name
                                         From Opportunity 
                                         Where AccountId = : accountId];
            */
            
            List<Phoenix_Bid__c> bidList = [Select Id, Name, Phoenix_Bid_Name__c,  Phoenix_Internal_Target_Date__c,
                                            Phoenix_Bid_Type__c, Phoenix_Comments__c, Phoenix_Proactive_Reactive__c,
                                            Phoenix_Approval_Status__c, Phoenix_Bid_Submitted_Date__c, 
                                            Phoenix_Bid_Deadline_Date__c, Phoenix_Customer__r.Name
                                            From Phoenix_Bid__c 
                                            Where Phoenix_Customer__c = : accountId];
            
            List<Task> taskList = [Select Id, Subject, ActivityDate
                                   From Task 
                                   Where WhatId = : accountId];
            
            List<Event> eventList = [Select Id, Subject, StartDateTime, EndDateTime
                                     From Event 
                                     Where WhatId = : accountId];
            
            //System.debug('oppList: ' + oppList);
            System.debug('bidList: ' + bidList);
            System.debug('taskList: ' + taskList);
            System.debug('eventList: ' + eventList);
            
            List<CalendarWrapper> calendarWrapperList = new List<CalendarWrapper>();
            if(taskList.size() > 0){
                for(Task task : taskList){
                    if(task.ActivityDate != null){
                        CalendarWrapper cw = new CalendarWrapper();
                        cw.id = task.Id;
                        cw.name = task.Subject;
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
                        cw.startDate =  Date.newinstance(event.StartDateTime.year(), event.StartDateTime.month(), event.StartDateTime.day());
                        cw.endDate = event.EndDateTime != null ? Date.newinstance(event.EndDateTime.year(), event.EndDateTime.month(), event.EndDateTime.day()) : null;
                        cw.type = 'Event';
                        calendarWrapperList.add(cw);
                    }
                }
            }
            
            /*
            if(oppList.size() > 0){
                for(Opportunity opp : oppList){
                    if(opp.Internal_Closing_Date__c != null){
                        CalendarWrapper cw = new CalendarWrapper();
                        cw.id = opp.Id;
                        cw.name = opp.Name;
                        cw.bidOppNumber = opp.Opportunity_Number__c;
                        cw.internalClosingDate = opp.Internal_Closing_Date__c;
                        cw.customerClosingDate = opp.Customer_Closing_Date__c;
                        cw.status = opp.StageName;
                        cw.type = 'Opportunity';
                        calendarWrapperList.add(cw);
                    }
                }
            }
			*/
            
            if(bidList.size() > 0){
                for(Phoenix_Bid__c bid : bidList){
                    if(bid.Phoenix_Internal_Target_Date__c != null){
                        CalendarWrapper cw = new CalendarWrapper();
                        cw.id = bid.Id;
                        cw.name = bid.Phoenix_Bid_Name__c;
                        cw.bidOppNumber = bid.Name;
                        cw.internalClosingDate = bid.Phoenix_Internal_Target_Date__c;
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
    }
    
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
        public Date endDate{ get; set; }
        
        @AuraEnabled
        public String status{ get; set; }
        
        @AuraEnabled
        public String type{ get; set; }
    }
}