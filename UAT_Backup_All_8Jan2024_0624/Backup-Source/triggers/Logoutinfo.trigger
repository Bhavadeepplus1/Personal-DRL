trigger Logoutinfo on LogoutEventStream (after insert) {
    //if(!test.isRunningTest()){
     List <User> userList= new List <User>();
    
    for( LogoutEventStream les:Trigger.new)
        
    {  system.debug('Inside for---');
        for(User userInfo: [Select ID,Last_Logout__c From User where ID =: les.UserID] )   
        {  
            
            userInfo.Last_Logout__c=System.now();
           // DateTime val =userInfo.Last_Logout__c
            userInfo.Last_Logout_Format__c = Phoenix_Util.getUserTimeNow(userInfo.Last_Logout__c, 'America/New_York');
           	userInfo.Login_and_Logout__c = userInfo.LastLoginDate > userInfo.Last_Logout__c ? true: false;
            userList.add(userInfo);  
            system.debug('Last_Logout__c from class---'+userInfo.Last_Logout__c);
            system.debug('LastLoginDate from class ---'+userInfo.LastLoginDate);
            system.debug('Login_and_Logout__c from class---'+userInfo.Login_and_Logout__c);
        } 
        
    }
    
    system.debug('Inside userList---from class'+userList);
    update userList;
   // }
   
 
  /*  else{
    
        integer i=0;
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
        i++;
        i++;
        i++;
        i++;
        
}*/


}