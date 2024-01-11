trigger DoHNotificationsTrigger on GCP_DOH_Trade_Partner_NDC__c (after insert,after update) {
    
    try{
    DOHNotificationHandler handler= new DOHNotificationHandler();
    handler.afterInsertUpdate();
        //if(Test.isRunningTest()){
          //  Integer a = 10/0;
        //}
    }
    catch(exception e){
          String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'DoHNotificationsTrigger', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'afterInsertUpdate', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Remarks__c ='' , Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
    }
    
        //new DOHNotificationHandler().run();
   
}