global class Phoneix_CIPNotification Implements Schedulable{
     global void execute(SchedulableContext sc)
                        {
                         Phoenix_SubmitBidForApprovalCtrl.sendCIPReminderNotification();
                        }
    
}