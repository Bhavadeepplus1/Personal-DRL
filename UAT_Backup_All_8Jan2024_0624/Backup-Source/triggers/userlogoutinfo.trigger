trigger userlogoutinfo on LogoutEventStream (after insert) {
	List<User> userList = new List<User>();
    
    for (LogoutEventStream evnt : Trigger.New) {
        try {
            List<User> userInfo = [SELECT Id, Last_Logout__c, User_Last_Logout__c, LastLoginDate FROM User WHERE Id = :evnt.UserId LIMIT 1];
            
            if (!userInfo.isEmpty()) {
                User u = userInfo[0];
                u.Last_Logout__c = System.now();
                u.User_Last_Logout__c = System.now();
                u.Last_Logout_Format__c = Phoenix_Util.getUserTimeNow(u.Last_Logout__c, 'America/New_York');
                u.Login_and_Logout__c = u.LastLoginDate > u.Last_Logout__c;
                userList.add(u);

                System.debug('Last_Logout__c from class ---' + u.Last_Logout__c);
                System.debug('User_Last_Logout__c from class ---' + u.User_Last_Logout__c);
                System.debug('LastLoginDate from class ---' + u.LastLoginDate);
                System.debug('Login_and_Logout__c from class ---' + u.Login_and_Logout__c);
            } else {
                System.debug('No matching User record found for UserId: ' + evnt.UserId);
            }
        } catch (Exception e) {
            System.debug('Error querying User records: ' + e.getMessage());
        }
    }

    System.debug('userList ----- ' + userList);
    
    if (!userList.isEmpty()) {
        update userList;
    }
}