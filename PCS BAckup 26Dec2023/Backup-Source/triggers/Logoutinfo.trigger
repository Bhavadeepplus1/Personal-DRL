trigger Logoutinfo on LogoutEventStream (after insert) {
    List <User> userList= new List <User>();
    
    for( LogoutEventStream les:Trigger.new)
        
    {
        
        for(User userInfo: [Select ID,Last_Logout__c From User where ID =: les.UserID] ) 
            
        {  
            
            userInfo.Last_Logout__c=System.now();
           // DateTime val =userInfo.Last_Logout__c
            userInfo.Last_Logout_Format__c = Phoenix_Util.getUserTimeNow(userInfo.Last_Logout__c, 'America/New_York');
           	userInfo.Login_and_Logout__c = false;
            userList.add(userInfo);  
            
        } 
        
    }
    
    update userList;
    
}