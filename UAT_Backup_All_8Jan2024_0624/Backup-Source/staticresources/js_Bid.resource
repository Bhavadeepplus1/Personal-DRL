// js_Bid.js

var drl = window.drl || drl || {};
window.drl = drl;

drl.bidApproval = {};

// Store the model here to better control when the UI is refreshed
drl.bidApproval.model = {};

// Prevent duplicate saves
drl.bidApproval.savingModel = false;


/**
 * This method is used to perform the initialization logic when the model is retrieved
 * from the server.
 *
 * @param component
 * @param initiativeModel
 */
drl.bidApproval.loadModel = function(component, helper, bidApprovalModel) {
    drl.lightning.consoleLog("loadModel Start");
    console.log(bidApprovalModel);
    this.model = bidApprovalModel;
};