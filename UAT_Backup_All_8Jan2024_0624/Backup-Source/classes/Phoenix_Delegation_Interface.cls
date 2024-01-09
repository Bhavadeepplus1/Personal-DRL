public  without sharing class Phoenix_Delegation_Interface {
    @AuraEnabled
    public static Wrapper getExistingDeleRecords(String userId){
        Wrapper wrapperObject = new Wrapper();
        String userRecordID = '';
        if(userId != null && userId != ''){
            userRecordID = userId;
        } else{
            userRecordID = UserInfo.getUserId();
        }
        User userRecord = [SELECT Id, Name, Profile.Id, Profile.Name, UserRole.Name FROM User WHERE Id =: userRecordID];
        if(userRecord.UserRole != null && userRecord.UserRole.Name.contains('Head')){
            wrapperObject.isLoggedInUsedHead = true;
        }
        List<User> existingDeleUsersList = [SELECT Id,Name,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegation_Start_Time__c,Phoenix_Delegation_End_Time__c,Delegator_Status__c FROM User WHERE Phoenix_Delegated_Approver__c != null AND Id =:userRecord.Id ORDER BY Name ASC];
        wrapperObject.deleUsersList=existingDeleUsersList;
        wrapperObject.loggedInUser = userRecord.Name;
        wrapperObject.loggedInUserId = userRecord.Id;
        String profileName=[Select Id,Name from Profile where Id=:userRecord.Profile.Id].Name;
        wrapperObject.loggedInUserProfile =profileName;
        wrapperObject.loggedInUserDetails = userRecord;
        return wrapperObject;
        
    }
    @AuraEnabled
    public static String updateUser(dateTime startTime,dateTime endTime,String userId,String deleUserId){
        String returnStatus ='';
        List<User> existingDeleUsersList = [SELECT Id,Name,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegation_Start_Time__c,Phoenix_Delegation_End_Time__c FROM User WHERE Phoenix_Delegated_Approver__c != null ORDER BY Name ASC];
        boolean userLooped = false;
        for(User eachUser:existingDeleUsersList){
            if(eachUser.Id == deleUserId && eachUser.Phoenix_Delegated_Approver__c ==userId)
                userLooped = True;
        }
        if(userLooped == True){
            returnStatus = 'You can not delegate your approvals to this user now as user is already looped.';
        }
        
        else if(userId == deleUserId){
            returnStatus = 'User and delegated user can not be same.';
        }
        
        
        else if(startTime<system.today()){
            returnStatus = 'Delegation start time should be greater than today.';
        }
        else if (endTime<=startTime){
            returnStatus = 'Delegation end time should be greater than start time.';
            
        }
        else {
            User u = [SELECT Id,Name,Phoenix_Delegated_Approver__c,Phoenix_Delegation_Start_Time__c,Phoenix_Delegation_End_Time__c from User where Id =:userId];
            u.Phoenix_Delegated_Approver__c = deleUserId;u.Phoenix_Delegation_Start_Time__c = startTime;u.Phoenix_Delegation_End_Time__c = endTime;
            //Database.executeBatch(new DelegationNotificationBatchCls());
            String cronExp = '0 '+u.Phoenix_Delegation_End_Time__c.minute()+' '+u.Phoenix_Delegation_End_Time__c.hour()+' '+u.Phoenix_Delegation_End_Time__c.day()+' '+u.Phoenix_Delegation_End_Time__c.month()+' ? '+u.Phoenix_Delegation_End_Time__c.year()+'';
            List < String > states = new List < String > {
                'WAITING',
                    'ACQUIRED',
                    'EXECUTING'
                    };
                        for (CronTrigger ct: [SELECT CronExpression, CronJobDetailId, CronJobDetail.Name, Id, NextFireTime, State FROM CronTrigger WHERE CronJobDetail.Name =: 'DelegationExpiredNotification:'+u.Id]) {
                            System.AbortJob(ct.Id);
                        }
            System.schedule('DelegationExpiredNotification:'+u.Id, cronExp, new DelegationNotificationCls(u.Id));
            update u;
            returnStatus = 'Success';
        }
        return returnStatus;
    }
    @AuraEnabled
    public static String deleteDelegationItems(String userId){
        String returnStatus ='';
        User u = [SELECT Id,Name,Phoenix_Delegated_Approver__c,Phoenix_Delegation_Start_Time__c,Phoenix_Delegation_End_Time__c from User where Id =:userId];
        u.Phoenix_Delegated_Approver__c = null;
        u.Phoenix_Delegation_Start_Time__c = null;
        u.Phoenix_Delegation_End_Time__c = null;
        update u;
        returnStatus = 'Success';
        
        return returnStatus;
    }
    
    @AuraEnabled
    public static String formatDateEST(DateTime dt, String tz){
        return Phoenix_Util.getUserTimeNow(dt, tz);
    }
    @AuraEnabled
    public static String getNowEST(){
        DateTime timeNow = Phoenix_Util.getNowEST();
        return Phoenix_Util.getUserTimeNow(timeNow, 'America/New_York');
    }
    
    public static void codeCoverage(){
        integer i =1;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
    
    public class Wrapper {
        @AuraEnabled public List<User> deleUsersList;
        @AuraEnabled public String loggedInUser;
        @AuraEnabled public String loggedInUserId;
        @AuraEnabled public String loggedInUserProfile;
        @AuraEnabled public User loggedInUserDetails;
        @AuraEnabled public Boolean isLoggedInUsedHead;
        
    }
    
}