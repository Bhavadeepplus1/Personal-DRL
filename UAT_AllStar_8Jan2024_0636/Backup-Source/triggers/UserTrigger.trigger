trigger UserTrigger on User (after update) {
    //if(!test.isRunningTest()){
        List<Phoenix_Approval_Delegation_History__c> deligationHistory = new List<Phoenix_Approval_Delegation_History__c>();
        If(Trigger.IsUpdate){   
            List<Phoenix_Approval_Delegation_History__c> existingDeligationHistory = [Select Id,Phoenix_Is_Active_delegator__c,Phoenix_Delegation_End_Time__c,Phoenix_Delegated_Approver__c,Phoenix_User__c from Phoenix_Approval_Delegation_History__c where Phoenix_User__c IN :Trigger.New];
            List<Phoenix_Approval_Delegation_History__c> updatedExistingDeligationHistory = new List<Phoenix_Approval_Delegation_History__c>();
            for(User thisUser:Trigger.New){
                if((Trigger.oldMap.get(thisUser.Id).Phoenix_Delegation_Start_Time__c !=thisUser.Phoenix_Delegation_Start_Time__c ||
                    Trigger.oldMap.get(thisUser.Id).Phoenix_Delegation_End_Time__c !=thisUser.Phoenix_Delegation_End_Time__c || 
                    Trigger.oldMap.get(thisUser.Id).Phoenix_Delegated_Approver__c !=thisUser.Phoenix_Delegated_Approver__c)&& thisUser.Phoenix_Delegation_Start_Time__c!=null && thisUser.Phoenix_Delegation_End_Time__c!=null && thisUser.Phoenix_Delegated_Approver__c!=null){
                        Phoenix_Approval_Delegation_History__c newDeligation = new Phoenix_Approval_Delegation_History__c();
                        newDeligation.Phoenix_Delegation_Start_Time__c=thisUser.Phoenix_Delegation_Start_Time__c;
                        newDeligation.Phoenix_Delegation_End_Time__c= thisUser.Phoenix_Delegation_End_Time__c;
                        newDeligation.Phoenix_Delegated_Approver__c=thisUser.Phoenix_Delegated_Approver__c;
                        newDeligation.Phoenix_User__c=thisUser.Id;
                        newDeligation.Phoenix_Is_Active_delegator__c = True;
                        deligationHistory.add(newDeligation);
                        DelegationNotificationCls.DelegationEmailAlert(thisUser.Id);
                        /*if(thisUser.Phoenix_Delegation_End_Time__c < system.now())
Phoenix_SubmitBidForApprovalCtrl.DelegationEndEmailAlert(thisUser.Id);*/
                    }
            }
            for( Phoenix_Approval_Delegation_History__c deleUser:existingDeligationHistory){
                User newUser = Trigger.NewMap.get(deleUser.Phoenix_User__c);
                User oldUser = Trigger.OldMap.get(deleUser.Phoenix_User__c);
                if(oldUser.Phoenix_Delegation_Start_Time__c !=newUser.Phoenix_Delegation_Start_Time__c ||
                   oldUser.Phoenix_Delegation_End_Time__c !=newUser.Phoenix_Delegation_End_Time__c || 
                   oldUser.Phoenix_Delegated_Approver__c !=newUser.Phoenix_Delegated_Approver__c ){
                       /* if(deleUser.Phoenix_Delegation_End_Time__c < system.now())
deleUser.Phoenix_Is_Active_delegator__c = True;
else*/
                       if(deleUser.Phoenix_Is_Active_delegator__c){
                           deleUser.Phoenix_Delegation_End_Time__c = system.now();   
                       }
                       deleUser.Phoenix_Is_Active_delegator__c = False;
                       updatedExistingDeligationHistory.add(deleUser);
                   }
            }
            if(!updatedExistingDeligationHistory.isEmpty())update updatedExistingDeligationHistory;
        }
        if(!deligationHistory.isEmpty()){
            Insert deligationHistory; 
        }
    /*}else{
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
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
    }*/
}