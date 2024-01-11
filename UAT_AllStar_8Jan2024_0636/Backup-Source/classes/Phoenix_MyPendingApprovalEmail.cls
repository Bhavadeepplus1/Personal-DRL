Public class Phoenix_MyPendingApprovalEmail implements Schedulable {
    Public void execute(SchedulableContext SC) {
        Phoenix_MyPendingBidApprovalsCtrl.sendEmailToAllApprovers();
        //Phoenix_MyPendingBidApprovalsCtrl.sendEmailtoVistex();
        Phoenix_MyPendingBidApprovalsCtrl.salesUsersatCustomersUpdate();
    }
}