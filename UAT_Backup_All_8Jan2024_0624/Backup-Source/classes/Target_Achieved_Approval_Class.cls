public class Target_Achieved_Approval_Class {
  /*  @auraEnabled
    public static void createTarget(String financialYear, String name){
        String eastRegionName = System.Label.Eric_Sutherland;
        String westRegionName = System.Label.Dave_Smith;
        User userdetails =  [SELECT Id, Username,Name, FirstName, LastName, Email
                             FROM User
                             WHERE Id =: UserInfo.getUserId()];
        
        Target_Achieved_Approval__c targetApprovalRec = new Target_Achieved_Approval__c();
        targetApprovalRec.Financial_Year__c = financialYear;
        targetApprovalRec.Name = name;
        targetApprovalRec.Marketing_Head_Status__c = 'Not Initiated';
        targetApprovalRec.SRx_Head_Status__c = 'Not Initiated';
        targetApprovalRec.RSM_Head_Status__c = 'In Process';
        targetApprovalRec.Approval_Status__c= 'RSM Head';
        targetApprovalRec.Initiator_Status__c = 'Completed';
        targetApprovalRec.RSM_Head_Status__c = 'In Process';
        targetApprovalRec.Initiator_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
        targetApprovalRec.Initiator_Approval_Completed_Time_String__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.Initiator_Approval_Completed_Time__c, 'America/New_York');
        targetApprovalRec.Initiator_Approval_Sent_Time__c = Phoenix_Util.getNowEST();
        targetApprovalRec.Initiator_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.Initiator_Approval_Sent_Time__c, 'America/New_York');
        targetApprovalRec.RSM_Head_Approval_Sent_Time__c = Phoenix_Util.getNowEST();
        targetApprovalRec.RSM_Head_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.RSM_Head_Approval_Sent_Time__c, 'America/New_York');
        targetApprovalRec.Approval_Status__c= 'RSM Head';
        if(userdetails.Name != null)
            targetApprovalRec.Intial_Approver__c =userdetails.Name;
        if(userdetails.Name == eastRegionName){
            targetApprovalRec.RSM_Approver__c = westRegionName;
        }else {
            targetApprovalRec.RSM_Approver__c = eastRegionName;
        }
        
        insert targetApprovalRec;
        HeadAchievedSalesSummaryNotify.rsmWestHeadApprovalAchievedSalesSummaryNotify(targetApprovalRec.Id,'Eric Sutherland');
        HeadAchievedSalesSummaryNotify.rsmEastHeadApprovalAchievedSalesSummaryNotify(targetApprovalRec.Id,'Dave Smith');

        
    } */
     @AuraEnabled
    public static string getLastLoggedIn (String approverName)   {
        
        String daveCustomLabel = System.Label.Dave_Email;
        String ericCustomLabel = System.Label.Eric_Email;
        String milanCustomLabel = System.Label.Milan_Email;

     
        List<String> emails = new List<String>();
        emails.add(daveCustomLabel);
        emails.add(ericCustomLabel);
        emails.add(milanCustomLabel);
        emails.add('pradeepkumarmutyala@drreddys.com');
           //List<User> u = [SELECT Login_and_Logout__c,Last_logout__c from User where Name=:approverName limit 1];
         User u = [SELECT Last_logout__c,LastLoginDate,	Last_Logout_Format__c FROM User WHERE Name=:approverName];
         System.debug('u list==>'+u);
        if(u.LastLoginDate != null){
            String lastlogin =Phoenix_Util.getUserTimeNow(u.LastLoginDate, 'America/New_York');
            system.debug('return--->>'+lastlogin);
            return lastlogin;
        }else{
            return 'No visit';
        }
       
    }
    @auraEnabled
    public static wrapperData getRecords(){
        
        wrapperData wrap = new wrapperData();
        List<Target_Achieved_Approval__c> apprvRecList =  [SELECT Id, Target_Number__c, Target_Status__c, Name, Approval_Status__c, Financial_Year__c, LastModifiedDate, Initiator_Status__c, RSM_Head_Status__c, SRx_Head_Status__c, Marketing_Head_Status__c,Initiator_Head_Comments__c, Quarter__c, RSM_Head_Comments__c, SRx_Head_Comments__c, Marketing_Head_Comments__c FROM Target_Achieved_Approval__c where Approval_Status__c = 'Completed' ORDER BY LastModifiedDate DESC ,CreatedDate DESC ];
        List<Target_Achieved_Approval__c> allRecList =  [SELECT Id, Target_Number__c, Target_Status__c, Name, Approval_Status__c, Financial_Year__c, LastModifiedDate, Initiator_Status__c, RSM_Head_Status__c, SRx_Head_Status__c, Marketing_Head_Status__c, Initiator_Head_Comments__c, Quarter__c, RSM_Head_Comments__c, SRx_Head_Comments__c, Marketing_Head_Comments__c FROM Target_Achieved_Approval__c where Approval_Status__c != 'Draft' ORDER BY LastModifiedDate DESC ,CreatedDate DESC];
        List<Target_Achieved_Approval__c> draftRecList =  [SELECT Id, Target_Number__c, Target_Status__c, Name, Approval_Status__c, Financial_Year__c, LastModifiedDate, Initiator_Status__c, RSM_Head_Status__c, SRx_Head_Status__c, Marketing_Head_Status__c, Initiator_Head_Comments__c, Quarter__c, RSM_Head_Comments__c, SRx_Head_Comments__c, Marketing_Head_Comments__c FROM Target_Achieved_Approval__c where Approval_Status__c = 'Draft' ORDER BY LastModifiedDate DESC ,CreatedDate DESC];
        List<Target_Achieved_Approval__c> srxAndMrktRecs =  [SELECT Id, Target_Number__c, Target_Status__c, Name, Approval_Status__c, Financial_Year__c,LastModifiedDate, Initiator_Status__c ,RSM_Head_Status__c, SRx_Head_Status__c, Marketing_Head_Status__c, Initiator_Head_Comments__c, Quarter__c, RSM_Head_Comments__c, SRx_Head_Comments__c, Marketing_Head_Comments__c FROM Target_Achieved_Approval__c WHERE Approval_Status__c IN ('SRx Head', 'Marketing Head','RSM Head')  ORDER BY LastModifiedDate DESC ,CreatedDate DESC];
        
        
        String daveCustomLabel = System.Label.Dave_Email;
        String ericCustomLabel = System.Label.Eric_Email;
        String milanCustomLabel = System.Label.Milan_Email;

     
        List<String> emails = new List<String>();
        emails.add(daveCustomLabel);
        emails.add(ericCustomLabel);
        emails.add(milanCustomLabel);
       emails.add('pradeepkumarmutyala@drreddys.com');
        emails.add('rameshkanduri@drreddys.com');
        
        List<User> userActivity = [SELECT Id, Username, Name, FirstName, LastName,Last_Logout_Format__c, Email,LastLogindate,Last_logout__c,Login_and_Logout__c 
                                   FROM User WHERE Email IN : emails];
        system.debug('userActivity--'+userActivity.size() + 'userEmail--'+userActivity[0].Email + '' + userActivity[0].LastLogindate + ''+userActivity[0].Last_logout__c);
        for(User rec: userActivity){
            if(rec.Email == 'pradeepkumarmutyala@drreddys.com'){
                system.debug('inside srimayee for'+rec.LastLogindate +''+rec.Last_logout__c);
                if(rec.LastLogindate > rec.Last_logout__c){
                    system.debug('rec.LastLogindate---'+rec.LastLogindate);
                    system.debug('rec.Last_logout__c->'+rec.Last_logout__c);
                    wrap.srimayeeActivity = true;
                }
                else{
                    system.debug('Email-false->'+wrap.srimayeeActivity);
                    wrap.srimayeeActivity = false;  
                }
            }
             if(rec.Email == 'rameshkanduri@drreddys.com'){
                system.debug('inside srimayee for'+rec.LastLogindate +''+rec.Last_logout__c);
                if(rec.LastLogindate > rec.Last_logout__c){
                    system.debug('rec.LastLogindate---'+rec.LastLogindate);
                    system.debug('rec.Last_logout__c->'+rec.Last_logout__c);
                    wrap.rameshActivity = true;
                }
                else{
                    system.debug('Email-false->'+wrap.srimayeeActivity);
                    wrap.rameshActivity = false;  
                }
            }
              if(rec.Email == daveCustomLabel){
                  system.debug('daveActivity--');
                    //wrapper.daveActivity = true;
                if(rec.LastLogindate > rec.Last_logout__c){
                    system.debug('daveActivity--');
                    wrap.daveActivity = true;
                }
                else{
                    wrap.daveActivity = false;  
                }
            }
            if(rec.Email == ericCustomLabel){
                if(rec.LastLogindate > rec.Last_logout__c){
                    wrap.ericActivity = true;
                }
                else{
                    wrap.ericActivity = false;  
                }
            }
            if(rec.Email == milanCustomLabel){
                if(rec.LastLogindate > rec.Last_logout__c){
                    wrap.milanActivity = true;
                }
                else{
                    wrap.milanActivity = false;  
                }
            }
            if(rec.Email == ''){
                if(rec.LastLogindate > rec.Last_logout__c){
                    wrap.srxActivity = true;
                }
                else{
                    wrap.srxActivity = false;  
                }
            }
            
        }
        
        
        wrap.draftRecs = draftRecList;
        wrap.acceptedRecs = apprvRecList;
        wrap.historyRecs = allRecList;
        wrap.pendingRecs = srxAndMrktRecs;
        
        return wrap;
    }
    @auraEnabled
    public static wrapperData viewTarget(String recordId){
        system.debug('recordId--'+recordId);
        wrapperData wrapper = new wrapperData();
        try{
            
            wrapper.targetApp =  [SELECT Id, Name,RSM_Head_Status__c,RSM_Head_Comments__c,RSM_Head_Approval_Sent_Time_String__c,RSM_Head_Approval_Sent_Time__c,RSM_Head_Approval_Completed_Time_String__c,
                                  RSM_Head_Approval_Completed_Time__c,RSM_Approver__c, Approval_Status__c, Financial_Year__c, Marketing_Approver__c,Intial_Approver__c,SRx_Approver__c,
                                  Initiator_Status__c, SRx_Head_Status__c, Marketing_Head_Status__c, SRx_Head_Comments__c, Marketing_Head_Comments__c,
                                  Initiator_Approval_Sent_Time_String__c,Initiator_Approval_Completed_Time_String__c,Initiator_Approval_Completed_Time__c,Marketing_Head_Approval_Completed_Str__c,
                                  Marketing_Head_Approval_Completed_Time__c,Marketing_Head_Approval_Sent_Time_String__c,Marketing_Head_Approval_Sent_Time__c,SRx_Head_Approval_Completed_Time_String__c,
                                  SRx_Head_Approval_Completed_Time__c,SRx_Head_Approval_Sent_Time_String__c,SRx_Head_Approval_Sent_Time__c,
                                  RSM_West_Head_Status__c,RSM_West_Head_Comments__c,RSM_West_Head_Approval_Sent_Time__c,RSM_West_Approver__c,RSM_West_Approval_Sent_Time_String__c,RSM_West_Approval_Completed_Time_String__c,RSM_West_Approval_Completed_Time__c FROM Target_Achieved_Approval__c where Id =: recordId ]; 
            
            System.debug('westwrapData.targetApp =====>'+wrapper.targetApp);
            List<AchievementSummaryTableCls.wrapperClass> westwrapData = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
            List<AchievementSummaryTableCls.wrapperClass> eastwrapData = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
            
            if (westwrapData != null) {
                wrapper.westlist = new List<AchievementSummaryTableCls.wrapperClass>();
                wrapper.westlist.addAll(westwrapData);
                System.debug('wrapper.westlist =====>' + wrapper.westlist);
                System.debug('westlist in viewTarget: ' + JSON.serialize(wrapper.westlist));
            } else {
                System.debug('westwrapData is null');
            }
            if (eastwrapData != null) {
                wrapper.eastlist = new List<AchievementSummaryTableCls.wrapperClass>();
                wrapper.eastlist.addAll(eastwrapData);
                System.debug('wrapper.eastlist =====>' + wrapper.eastlist);
                System.debug('eastlist in viewTarget: ' + JSON.serialize(wrapper.eastlist));
            } else {
                System.debug('eastwrapData is null');
            }
            
        }
        catch(Exception e){
            system.debug('Errrrrorrr--->>>>'+e);
        }
        
        system.debug('wrapper---'+wrapper);
        return wrapper;  
    } 
    @auraEnabled
    public static wrapperData updatestatus(String recordId, String fieldName, String status, String comment){
        system.debug('recordId=='+recordId);
        system.debug('fieldName=='+fieldName);
        system.debug('status=='+status);
        User userdetails =  [SELECT Id, Username,Name, FirstName, LastName, Email
                             FROM User
                             WHERE Id =: UserInfo.getUserId()];
        Target_Achieved_Approval__c targetApprovalRec =  [SELECT Id, Target_Number__c, Name,Approval_Status__c, Financial_Year__c,RSM_Approver__c,Marketing_Approver__c,Intial_Approver__c,SRx_Approver__c,Initiator_Status__c,RSM_Head_Status__c, SRx_Head_Status__c, Marketing_Head_Status__c,Initiator_Head_Comments__c, SRx_Head_Comments__c, RSM_Head_Comments__c,Marketing_Head_Comments__c,Initiator_Approval_Sent_Time__c,Initiator_Approval_Sent_Time_String__c,Initiator_Approval_Completed_Time_String__c,Initiator_Approval_Completed_Time__c,Marketing_Head_Approval_Completed_Str__c,Marketing_Head_Approval_Completed_Time__c,Marketing_Head_Approval_Sent_Time_String__c,Marketing_Head_Approval_Sent_Time__c,SRx_Head_Approval_Completed_Time_String__c,SRx_Head_Approval_Completed_Time__c,SRx_Head_Approval_Sent_Time_String__c,SRx_Head_Approval_Sent_Time__c,RSM_Head_Approval_Sent_Time_String__c,RSM_Head_Approval_Sent_Time__c,RSM_Head_Approval_Completed_Time_String__c,RSM_Head_Approval_Completed_Time__c,RSM_West_Head_Status__c,RSM_West_Head_Comments__c,RSM_West_Head_Approval_Sent_Time__c,RSM_West_Approver__c,RSM_West_Approval_Sent_Time_String__c,RSM_West_Approval_Completed_Time_String__c,RSM_West_Approval_Completed_Time__c FROM Target_Achieved_Approval__c where Id =: recordId];
        
        if(fieldName == 'RSM_Head_Status__c' && status == 'Completed'){
            targetApprovalRec.RSM_Head_Status__c = 'Completed'; 
            if(comment != null) targetApprovalRec.RSM_Head_Comments__c = comment;
            targetApprovalRec.RSM_Head_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
            targetApprovalRec.RSM_Head_Approval_Completed_Time_String__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.RSM_Head_Approval_Completed_Time__c, 'America/New_York');
            targetApprovalRec.SRx_Head_Approval_Sent_Time__c = Phoenix_Util.getNowEST();
            targetApprovalRec.SRx_Head_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.SRx_Head_Approval_Sent_Time__c, 'America/New_York');
            targetApprovalRec.Approval_Status__c= 'RSM Head';
            if(userdetails.Name != null)
                targetApprovalRec.RSM_Approver__c = userdetails.Name;
            if(targetApprovalRec.RSM_West_Head_Status__c=='In Process'){
             //   HeadAchievedSalesSummaryNotify.rsmWestHeadApprovalAchievedSalesSummaryNotify(recordId,targetApprovalRec.RSM_Approver__c);
            }
            if(targetApprovalRec.RSM_West_Head_Status__c=='Completed'){
                targetApprovalRec.Marketing_Head_Status__c = 'In Process';
                //targetApprovalRec.Marketing_Head_Status__c = 'In Process';
                targetApprovalRec.SRx_Head_Status__c = 'Completed'; 
                targetApprovalRec.SRx_Head_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
                targetApprovalRec.SRx_Head_Approval_Completed_Time_String__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.SRx_Head_Approval_Completed_Time__c, 'America/New_York');
                targetApprovalRec.Marketing_Head_Approval_Sent_Time__c = Phoenix_Util.getNowEST();
                targetApprovalRec.Marketing_Head_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.Marketing_Head_Approval_Sent_Time__c, 'America/New_York');
                targetApprovalRec.Approval_Status__c= 'Marketing Head';
               // HeadAchievedSalesSummaryNotify.srxHeadAchievedSalesSummaryNotify(recordId);
                HeadAchievedSalesSummaryNotify.marketingHeadAchievedSalesSummaryNotify(recordId);
            }
        }
        if(fieldName == 'RSM_West_Head_Status__c' && status == 'Completed'){
            targetApprovalRec.RSM_West_Head_Status__c = 'Completed'; 
            if(comment != null) targetApprovalRec.RSM_West_Head_Comments__c = comment;
            targetApprovalRec.RSM_West_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
            targetApprovalRec.RSM_West_Approval_Completed_Time_String__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.RSM_West_Approval_Completed_Time__c, 'America/New_York');
            targetApprovalRec.SRx_Head_Approval_Sent_Time__c = Phoenix_Util.getNowEST();
            targetApprovalRec.SRx_Head_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.SRx_Head_Approval_Sent_Time__c, 'America/New_York');
            targetApprovalRec.Approval_Status__c= 'RSM Head';
            if(userdetails.Name != null)
                targetApprovalRec.RSM_West_Approver__c = userdetails.Name;
            if(targetApprovalRec.RSM_Head_Status__c=='In Process'){
              //  HeadAchievedSalesSummaryNotify.rsmEastHeadApprovalAchievedSalesSummaryNotify(recordId,targetApprovalRec.RSM_West_Approver__c);
            }
            //targetApprovalRec.Marketing_Head_Status__c = 'In Process';
            if(targetApprovalRec.RSM_Head_Status__c=='Completed'){
                targetApprovalRec.Marketing_Head_Status__c = 'In Process';
                targetApprovalRec.SRx_Head_Status__c = 'Completed'; 
                targetApprovalRec.SRx_Head_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
                targetApprovalRec.SRx_Head_Approval_Completed_Time_String__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.SRx_Head_Approval_Completed_Time__c, 'America/New_York');
                targetApprovalRec.Marketing_Head_Approval_Sent_Time__c = Phoenix_Util.getNowEST();
                targetApprovalRec.Marketing_Head_Approval_Sent_Time_String__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.Marketing_Head_Approval_Sent_Time__c, 'America/New_York');
                targetApprovalRec.Approval_Status__c= 'Marketing Head';
               // HeadAchievedSalesSummaryNotify.srxHeadAchievedSalesSummaryNotify(recordId);
                    HeadAchievedSalesSummaryNotify.marketingHeadAchievedSalesSummaryNotify(recordId);
            }
        }
        
        
        if(fieldName == 'Marketing_Head_Status__c' && status == 'Completed'){
            targetApprovalRec.Marketing_Head_Status__c = 'Completed';
            if(comment != null) targetApprovalRec.Marketing_Head_Comments__c = comment;
            targetApprovalRec.Marketing_Head_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
            targetApprovalRec.Marketing_Head_Approval_Completed_Str__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.Marketing_Head_Approval_Completed_Time__c, 'America/New_York');
            targetApprovalRec.Approval_Status__c= 'Completed';
            if(userdetails.Name != null){
                targetApprovalRec.Marketing_Approver__c = userdetails.Name;
            }
            
            AchievedSalesSummaryHREmailNotification.SendEmail(recordId);
          // HeadApprovalEmailNotification.targetAcceptedEmailNotification('a1FDL000007kM8y2AE');

        }
        if(fieldName == 'RSM_Head_Status__c' && status == 'East RSM Rejected'){
            // targetApprovalRec.Marketing_Head_Status__c = 'In Process';
            targetApprovalRec.RSM_Head_Status__c = status; 
            if(comment != null) targetApprovalRec.RSM_Head_Comments__c = comment;
            targetApprovalRec.Approval_Status__c= 'RSM Rejected';
            if(userdetails.Name != null)
                targetApprovalRec.RSM_Approver__c = userdetails.Name;
            targetApprovalRec.RSM_Head_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
            targetApprovalRec.RSM_Head_Approval_Completed_Time_String__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.RSM_Head_Approval_Completed_Time__c, 'America/New_York');
            if(targetApprovalRec.RSM_West_Head_Status__c !='Completed'){
                targetApprovalRec.RSM_West_Head_Status__c = 'Not Initiated';
            }
            HeadAchievedSalesSummaryNotify.rsmEastHeadAchievedSalesRejectionNotify(recordId,targetApprovalRec.RSM_Approver__c,comment,targetApprovalRec.RSM_Head_Approval_Completed_Time_String__c);
                }
        if(fieldName == 'RSM_West_Head_Status__c' && status == 'West RSM Rejected'){
            // targetApprovalRec.Marketing_Head_Status__c = 'In Process';
            targetApprovalRec.RSM_West_Head_Status__c = status; 
            if(comment != null) targetApprovalRec.RSM_West_Head_Comments__c = comment;
            targetApprovalRec.Approval_Status__c= 'RSM Rejected';
            if(userdetails.Name != null)
                targetApprovalRec.RSM_West_Approver__c = userdetails.Name;
            targetApprovalRec.RSM_West_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
            targetApprovalRec.RSM_West_Approval_Completed_Time_String__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.RSM_West_Approval_Completed_Time__c, 'America/New_York');
            if(targetApprovalRec.RSM_Head_Status__c !='Completed'){
                targetApprovalRec.RSM_Head_Status__c = 'Not Initiated';
            }
            HeadAchievedSalesSummaryNotify.rsmEastHeadAchievedSalesRejectionNotify(recordId,targetApprovalRec.RSM_West_Approver__c,comment,targetApprovalRec.RSM_West_Approval_Completed_Time_String__c);
            
        }
        if(fieldName == 'SRx_Head_Status__c' && status == 'SRx Head Rejected'){
            // targetApprovalRec.Marketing_Head_Status__c = 'In Process';
            targetApprovalRec.SRx_Head_Status__c = status; 
            if(comment != null) targetApprovalRec.SRx_Head_Comments__c = comment;
            targetApprovalRec.Approval_Status__c= 'SRx Head Rejected';
            if(userdetails.Name != null)
                targetApprovalRec.SRx_Approver__c = userdetails.Name;
            // SRxHeadRejectionEmailNotification.salesRepTargetData(recordId);
            HeadAchievedSalesSummaryNotify.srxHeadAchievedSalesRejectionNotify(recordId);
            
        }
        if(fieldName == 'Marketing_Head_Status__c' && status == 'Marketing Head Rejected'){
            targetApprovalRec.Marketing_Head_Status__c = status;
            if(comment != null) targetApprovalRec.Marketing_Head_Comments__c = comment;
            targetApprovalRec.Approval_Status__c= 'Marketing Head Rejected';
            if(comment != null) targetApprovalRec.Marketing_Head_Comments__c = comment;
            targetApprovalRec.Marketing_Head_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
            targetApprovalRec.Marketing_Head_Approval_Completed_Time__c = Phoenix_Util.getNowEST();
            targetApprovalRec.Marketing_Head_Approval_Completed_Str__c = Phoenix_Util.getUserTimeNow(targetApprovalRec.Marketing_Head_Approval_Completed_Time__c, 'America/New_York');
            
            HeadAchievedSalesSummaryNotify.marketingHeadAchievedSalesRejectionNotify(recordId,targetApprovalRec.Marketing_Head_Approval_Completed_Str__c,comment);
            
        }
        
        
        update targetApprovalRec;
        wrapperData wrapper = new wrapperData();
        
        wrapper.targetApp = targetApprovalRec;
        
        return wrapper;
    }
    public class wrapperData {
        @AuraEnabled public Target_Achieved_Approval__c targetApp {get; set;}
        @AuraEnabled public List<Sales_Reps_Targets__c> eastData {get; set;}
        @AuraEnabled public List<Sales_Reps_Targets__c> westData{get; set;}
        @AuraEnabled public List<Target_Achieved_Approval__c>  draftRecs {get; set;}
        @AuraEnabled public List<Target_Achieved_Approval__c>  historyRecs {get; set;}
        @AuraEnabled public List<Target_Achieved_Approval__c>  acceptedRecs {get; set;}
        @AuraEnabled public List<Target_Achieved_Approval__c>  pendingRecs {get; set;}
        @AuraEnabled public List<AchievementSummaryTableCls.wrapperClass>  eastlist {get; set;}
        @AuraEnabled public List<AchievementSummaryTableCls.wrapperClass>  westlist {get; set;}
        
        @AuraEnabled public boolean srxActivity {get; set;}
        @AuraEnabled public  boolean ericActivity {get; set;}
        @AuraEnabled public  boolean daveActivity {get; set;}
        @AuraEnabled public  boolean milanActivity {get; set;}
        @AuraEnabled public  boolean srimayeeActivity {get; set;}
        @AuraEnabled public  boolean rameshActivity {get; set;}
        
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
    }
  
}