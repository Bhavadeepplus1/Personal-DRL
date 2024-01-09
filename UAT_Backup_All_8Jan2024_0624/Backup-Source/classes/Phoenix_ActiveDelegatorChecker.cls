Public class Phoenix_ActiveDelegatorChecker implements Schedulable {
    Public void execute(SchedulableContext SC) {
        List<Phoenix_Approval_Delegation_History__c> deleHistory = [Select Id,	Phoenix_Delegated_Approver__c,Phoenix_User__c,	Phoenix_Delegation_Start_Time__c,Phoenix_Delegation_End_Time__c,Phoenix_Is_Active_delegator__c From Phoenix_Approval_Delegation_History__c ];
        List<Phoenix_Approval_Delegation_History__c> updatedDeleHistory = new  List<Phoenix_Approval_Delegation_History__c>();
       set<ID> userIds = new set<ID>();
        for(Phoenix_Approval_Delegation_History__c historyRecord : deleHistory){  if(historyRecord.Phoenix_Delegation_End_Time__c < System.now() && historyRecord.Phoenix_Is_Active_delegator__c == True )  {historyRecord.Phoenix_Is_Active_delegator__c = False; updatedDeleHistory.add(historyRecord);userIds.add(historyRecord.Phoenix_User__c); }
            
        }
        if (updatedDeleHistory.size()>0) { update updatedDeleHistory;List<User> users= new List<User>();
            for(Id uId:userIds)          {users.add(new User(Id=uId,Phoenix_Delegated_Approver__c = null,	Phoenix_Delegation_End_Time__c=null,Phoenix_Delegation_Start_Time__c=null));}update users; }
    }
  //  system.schedule('Phoenix_ActiveDelegatorChecker', '0 0 0/1 1/1 * ? *', New Phoenix_ActiveDelegatorChecker());

}