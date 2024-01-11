({
    doInit: function(component, event, helper) {
        helper.getApprovalGrids(component, event, helper);
    },
    //Added by BV
    handleTptGrid: function (component, event, helper){
        component.set("v.isTptGrid",true);
    },
     openModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.isTptGrid", true);
   },
  
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isTptGrid", false);
   },
  
   submitDetails: function(component, event, helper) {
      // Set isModalOpen attribute to false
      //Add your code to call apex method or do some processing
      component.set("v.isTptGrid", false);
   },
    onClose: function (component, event, helper){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),
        });
        navEvt.fire();
    },
    onApprovalChange :  function(component, event, helper) {
        console.log('onApprovalChange-----before')
        component.set("v.isClicked", true);
        var approvalGridID = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        console.log('onApprovalChange-----after')
        let financeApprovalMap;
        if(component.get("v.financeApprovalMap") != null ){
            financeApprovalMap = component.get("v.financeApprovalMap");
        }else{
            financeApprovalMap = new Map();
        }
        console.log('approvalGridID--->'+approvalGridID)
        console.log('val--->'+val)
        if(financeApprovalMap != null && financeApprovalMap.has(approvalGridID)){
            financeApprovalMap.delete(approvalGridID);
        }else{
            financeApprovalMap[approvalGridID] = val ;
        }
        component.set("v.financeApprovalMap", financeApprovalMap);
        console.log('financeApprovalMap--->'+JSON.stringify(financeApprovalMap))
    },
    onCommentChange :function(component, event, helper) {
        component.set("v.isClicked", true);
        var productList = component.find('select');
        var approvalGridID = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        console.log('approvalGridID--->'+approvalGridID)
        console.log('val--->'+val)
        let financeCommentsMap;
        if(component.get("v.financeCommentsMap") != null ){
            financeCommentsMap = component.get("v.financeCommentsMap");
        }else{
            financeCommentsMap = new Map();
        }
        if(financeCommentsMap != null && financeCommentsMap.has(approvalGridID)){
            financeCommentsMap.delete(approvalGridID);
        }else{
            financeCommentsMap[approvalGridID] = val ;
        }
        component.set("v.financeCommentsMap", financeCommentsMap);
        console.log('financeCommentsMap--->'+financeCommentsMap)
    },
    onBUApprovalChange :  function(component, event, helper) {
        console.log('onApprovalChange-----before')
        component.set("v.isClicked", true);
        var approvalGridID = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        console.log('onApprovalChange-----after')
        let financeApprovalMap;
        if(component.get("v.financeBUApprovalMap") != null ){
            financeApprovalMap = component.get("v.financeBUApprovalMap");
        }else{
            financeApprovalMap = new Map();
        }
        console.log('approvalGridID--->'+approvalGridID)
        console.log('val--->'+val)
        if(financeApprovalMap != null && financeApprovalMap.has(approvalGridID)){
            financeApprovalMap.delete(approvalGridID);
        }else{
            financeApprovalMap[approvalGridID] = val ;
        }
        component.set("v.financeBUApprovalMap", financeApprovalMap);
        console.log('financeBUApprovalMap--->'+JSON.stringify(financeApprovalMap))
    },
    onMarSRXApprovalChange :  function(component, event, helper) {
        console.log('onApprovalChange-----before')
        component.set("v.isClicked", true);
        var approvalGridID = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        console.log('onApprovalChange-----after')
        let financeApprovalMap;
        if(component.get("v.SrxApprovalMap") != null ){
            financeApprovalMap = component.get("v.SrxApprovalMap");
        }else{
            financeApprovalMap = new Map();
        }
        console.log('approvalGridID--->'+approvalGridID)
        console.log('val--->'+val)
        if(financeApprovalMap != null && financeApprovalMap.has(approvalGridID)){
            financeApprovalMap.delete(approvalGridID);
        }else{
            financeApprovalMap[approvalGridID] = val ;
        }
        component.set("v.SrxApprovalMap", financeApprovalMap);
        console.log('financeBUApprovalMap--->'+JSON.stringify(financeApprovalMap))
    },
    onMarRXApprovalChange :  function(component, event, helper) {
        console.log('onApprovalChange-----before')
        component.set("v.isClicked", true);
        var approvalGridID = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        console.log('onApprovalChange-----after')
        let financeApprovalMap;
        if(component.get("v.RxApprovalMap") != null ){
            financeApprovalMap = component.get("v.RxApprovalMap");
        }else{
            financeApprovalMap = new Map();
        }
        console.log('approvalGridID--->'+approvalGridID)
        console.log('val--->'+val)
        if(financeApprovalMap != null && financeApprovalMap.has(approvalGridID)){
            financeApprovalMap.delete(approvalGridID);
        }else{
            financeApprovalMap[approvalGridID] = val ;
        }
        component.set("v.RxApprovalMap", financeApprovalMap);
        console.log('financeBUApprovalMap--->'+JSON.stringify(financeApprovalMap))
    },
    onMarOTCApprovalChange:  function(component, event, helper) {
        console.log('onApprovalChange-----before')
        component.set("v.isClicked", true);
        var approvalGridID = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        console.log('onApprovalChange-----after')
        let financeApprovalMap;
        if(component.get("v.OTCApprovalMap") != null ){
            financeApprovalMap = component.get("v.OTCApprovalMap");
        }else{
            financeApprovalMap = new Map();
        }
        console.log('approvalGridID--->'+approvalGridID)
        console.log('val--->'+val)
        if(financeApprovalMap != null && financeApprovalMap.has(approvalGridID)){
            financeApprovalMap.delete(approvalGridID);
        }else{
            financeApprovalMap[approvalGridID] = val ;
        }
        component.set("v.OTCApprovalMap", financeApprovalMap);
        console.log('financeBUApprovalMap--->'+JSON.stringify(financeApprovalMap))
    },
    onMrkLeadCommentChange :function(component, event, helper) {
        component.set("v.isClicked", true);
        var productList = component.find('select');
        var approvalGridID = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        console.log('approvalGridID--->'+approvalGridID)
        console.log('val--->'+val)
        let financeCommentsMap;
        if(component.get("v.financeBUCommentsMap") != null ){
            financeCommentsMap = component.get("v.financeBUCommentsMap");
        }else{
            financeCommentsMap = new Map();
        }
        if(financeCommentsMap != null && financeCommentsMap.has(approvalGridID)){
            financeCommentsMap.delete(approvalGridID);
        }else{
            financeCommentsMap[approvalGridID] = val ;
        }
        component.set("v.financeBUCommentsMap", financeCommentsMap);
        console.log('financeCommentsMap--->'+financeCommentsMap)
    },
    onSrDirApprovalChange :  function(component, event, helper) {
        console.log('onApprovalChange-----before')
        component.set("v.isClicked", true);
        var approvalGridID = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        console.log('onApprovalChange-----after')
        let financeApprovalMap;
        if(component.get("v.financeSrDirApprovalMap") != null ){
            financeApprovalMap = component.get("v.financeSrDirApprovalMap");
        }else{
            financeApprovalMap = new Map();
        }
        console.log('approvalGridID--->'+approvalGridID)
        console.log('val--->'+val)
        if(financeApprovalMap != null && financeApprovalMap.has(approvalGridID)){
            financeApprovalMap.delete(approvalGridID);
        }else{
            financeApprovalMap[approvalGridID] = val ;
        }
        component.set("v.financeSrDirApprovalMap", financeApprovalMap);
        console.log('financeApprovalMap--->'+JSON.stringify(financeApprovalMap))
    },
    onSrDirCommentChange :function(component, event, helper) {
        component.set("v.isClicked", true);
        var productList = component.find('select');
        var approvalGridID = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        console.log('approvalGridID--->'+approvalGridID)
        console.log('val--->'+val)
        let financeCommentsMap;
        if(component.get("v.financeSrDirCommentsMap") != null ){
            financeCommentsMap = component.get("v.financeSrDirCommentsMap");
        }else{
            financeCommentsMap = new Map();
        }
        if(financeCommentsMap != null && financeCommentsMap.has(approvalGridID)){
            financeCommentsMap.delete(approvalGridID);
        }else{
            financeCommentsMap[approvalGridID] = val ;
        }
        component.set("v.financeSrDirCommentsMap", financeCommentsMap);
        console.log('financeCommentsMap--->'+financeCommentsMap)
    },
    saveClick : function (component, event , helper){
        component.set("v.isSpinnerLoad" , true);
        /*var financeApproval;
var financetApprovaltype = component.find("headerFinanceApproval");
if(financetApprovaltype != null ){
financeApproval = financetApprovaltype.get("v.value");
}else{
financeApproval = '';
}
console.log('financetApprovaltype--->'+financeApproval);
console.log('financetApprovaltype--->'+component.get("v.isFinanceApproved"));*/
    var action = component.get("c.updateLineItems");
    action.setParams({
        bidId : component.get("v.recordId"),
        approvalMap : component.get("v.financeApprovalMap"),
        commentsMap : component.get("v.financeCommentsMap"),
        ApprovalBUMap : component.get("v.financeBUApprovalMap"),
        commentsBUMap : component.get("v.financeBUCommentsMap"),
        approvalSrDirMap : component.get("v.financeSrDirApprovalMap"),
        commentsSrDirMap : component.get("v.financeSrDirCommentsMap"),
        SrxApprovalMap : component.get("v.SrxApprovalMap"),
        RxApprovalMap : component.get("v.RxApprovalMap"),
        OTCApprovalMap : component.get("v.OTCApprovalMap"),
        /*  financeApproval : financeApproval,
isFinanceApproved : component.get("v.isFinanceApproved")*/
});
    action.setCallback(this, function(response){
        if(response.getState() === 'SUCCESS'){
            var datalist = response.getReturnValue();
            component.set("v.financeCommentsMap", null);
            component.set("v.financeApprovalMap", null);
            component.set("v.financeBUCommentsMap", null);
            component.set("v.financeBUApprovalMap", null);
            component.set("v.financeSrDirCommentsMap", null);
            component.set("v.financeSrDirApprovalMap", null);
            component.set("v.gridWrapper", datalist);
            var toastEvent = $A.get("e.force:showToast");
            component.set("v.isSpinnerLoad" , false);
            component.set("v.isClicked", false);
            toastEvent.setParams({
                "title": "Success!",
                "message": "Record Updated Successfully."
            });
            toastEvent.fire();
        }
    });
    $A.enqueueAction(action);
},
    onApprovalSubmit: function(component,event,helper){
        component.set("v.isSpinnerLoad",true); 
        var listOfItems = component.get("v.gridWrapper.approvalGridList");
        var isMarketingHead = component.get("v.gridWrapper.isMarketingHead");
        var isBusinessHead = component.get("v.gridWrapper.isBusinessHead");
        var isVPFinanceHead = component.get("v.gridWrapper.isVPFinanceHead");
        var isMarketingSRxLead = component.get("v.gridWrapper.isMarketingSRxLead");
        var isMarketingRxLead = component.get("v.gridWrapper.isMarketingRxLead");
        var isMarketingOTCLead = component.get("v.gridWrapper.isMarketingOTCLead");
        var gridIds = [];
        var isApproved = false;
        listOfItems.forEach(function(line){
            console.log('isBusinessHead--->'+isBusinessHead);
            console.log('businessApproval--->'+line.Phoenix_Business_Head_Approval__c);
            console.log('isMarketingHead---->'+isMarketingHead);
            console.log('isVPFinanceHead---->'+isVPFinanceHead);
            console.log('isMarketingRxLead==>'+isMarketingRxLead)
            console.log('Phoenix_isRx__c==>'+line.Phoenix_isRx__c)
            console.log('line.Phoenix_Marketing_Lead_Rx__c==>'+line.Phoenix_Marketing_Lead_Rx__c)
            if(isMarketingRxLead && line.Phoenix_isRx__c && (line.Phoenix_Marketing_Lead_Rx__c == 'None' || line.Phoenix_Marketing_Lead_Rx__c == '' || line.Phoenix_Marketing_Lead_Rx__c == null || line.Phoenix_Marketing_Lead_Rx__c == 'undefined')){
                isApproved = true;
                gridIds.push(line);
                console.log('inside isMarketingRxLead');
            }
            else if(isMarketingSRxLead && line.Phoenix_isSRX__c && (line.Phoenix_Marketing_Lead_SRx__c == 'None' || line.Phoenix_Marketing_Lead_SRx__c == '' || line.Phoenix_Marketing_Lead_SRx__c == null || line.Phoenix_Marketing_Lead_SRx__c == 'undefined')){
                isApproved = true;
                gridIds.push(line);
                console.log('inside isMarketingSRxLead');
            }
            else if(isMarketingOTCLead && line.Phoenix_isOTC__c && (line.Phoenix_Marketing_Lead_OTC__c == 'None' || line.Phoenix_Marketing_Lead_OTC__c == '' || line.Phoenix_Marketing_Lead_OTC__c == null || line.Phoenix_Marketing_Lead_OTC__c == 'undefined')){
                isApproved = true;
                gridIds.push(line);
                console.log('inside isMarketingOTCLead');
            }
            else if(isMarketingHead && line.Phoenix_Mkt_Head_Req__c && (line.Phoenix_Approval__c == 'None' || line.Phoenix_Approval__c == '' || line.Phoenix_Approval__c == null || line.Phoenix_Approval__c == 'undefined')){
                isApproved = true;
                gridIds.push(line);
                console.log('inside isMarketingHead');
            }
            else if(isBusinessHead && (line.Phoenix_Business_Head_Approval__c == 'None' || line.Phoenix_Business_Head_Approval__c == '' || line.Phoenix_Business_Head_Approval__c == null || line.Phoenix_Business_Head_Approval__c == 'undefined')){
                isApproved = true;
                gridIds.push(line);
                console.log('inside business');
            }
            else if(isVPFinanceHead && line.Phoenix_VP_Finance_Req__c && (line.Phoenix_Sr_Director_VP__c == 'None' || line.Phoenix_Sr_Director_VP__c == '' || line.Phoenix_Sr_Director_VP__c == null || line.Phoenix_Sr_Director_VP__c == 'undefined')){
                isApproved = true;
                gridIds.push(line);
                console.log('inside Sr Director');
            }
        });
            listOfItems.forEach(function(line){
           
            if(isMarketingRxLead && line.Phoenix_isRx__c && (line.Phoenix_Marketing_Lead_Rx__c == 'Approved' || line.Phoenix_Marketing_Lead_Rx__c == 'Not Approved')){
               // isApproved = true;
                gridIds.push(line);
                console.log('inside isMarketingRxLead');
            }
            else if(isMarketingSRxLead && line.Phoenix_isSRX__c && (line.Phoenix_Marketing_Lead_SRx__c == 'Approved' || line.Phoenix_Marketing_Lead_SRx__c == 'Not Approved')){
               // isApproved = true;
                gridIds.push(line);
                console.log('inside isMarketingSRxLead');
            }
            else if(isMarketingOTCLead && line.Phoenix_isOTC__c && (line.Phoenix_Marketing_Lead_OTC__c  == 'Approved' || line.Phoenix_Marketing_Lead_OTC__c  == 'Not Approved')){
               // isApproved = true;
                gridIds.push(line);
                console.log('inside isMarketingOTCLead');
            }
            else if(isMarketingHead && line.Phoenix_Mkt_Head_Req__c && (line.Phoenix_Approval__c  == 'Approved' || line.Phoenix_Approval__c  == 'Not Approved')){
               // isApproved = true;
                gridIds.push(line);
                console.log('inside isMarketingHead');
            }
            else if(isBusinessHead && (line.Phoenix_Business_Head_Approval__c  == 'Approved' || line.Phoenix_Business_Head_Approval__c  == 'Not Approved')){
               // isApproved = true;
                gridIds.push(line);
                console.log('inside business');
            }
            else if(isVPFinanceHead && line.Phoenix_VP_Finance_Req__c && (line.Phoenix_Sr_Director_VP__c  == 'Approved' || line.Phoenix_Sr_Director_VP__c  == 'Not Approved')){
              //  isApproved = true;
                gridIds.push(line);
                console.log('inside Sr Director');
            }
        });
        
        console.log('gridIds1=='+gridIds);
        if(isApproved == true){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"warning",
                "title": "Failed!",
                "message": "Please confirm each approval to proceed further"
            });
            toastEvent.fire();
            component.set("v.isSpinnerLoad",false); 
        }
        else{
            console.log('gridIds=='+gridIds);
            var action = component.get("c.makeApprovals");
            action.setParams({
                bidId : component.get("v.recordId"),
                approvalGrids : gridIds,
                isMarketingHead :isMarketingHead,
                isBusinessHead : isBusinessHead,
                isVPFinanceHead :isVPFinanceHead,
                isMarketingSRxLead :isMarketingSRxLead,
                isMarketingRxLead : isMarketingRxLead,
                isMarketingOTCLead :isMarketingOTCLead
            });
            action.setCallback(this, function (response){
                if(response.getState() === "SUCCESS"){
                    helper.getApprovalGrids(component, event, helper);
                    component.set("v.isSpinnerLoad",false); 
                    console.log('in success msg-->')
                }
            });
            $A.enqueueAction(action);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"success",
                "title": "Success",
                "message": "Your Approvals are submitted successfully."
            });
            toastEvent.fire();
        }
    },
    downloadCsv : function(component,event,helper){
        var ResultData = component.get("v.gridWrapper.approvalGridList");
        //console.log('gridWrapper list--->'+ResultData)
        var template=component.get("v.templateType");
        var title=component.get("v.title");
        //var bidName=component.get("v.bidName");
        // call the helper function which "return" the CSV data as a String
        var csv = helper.convertArrayOfObjectsToCSV(component,ResultData,template);
        if (csv == null){return;}
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; //
        var date = new Date();
        var hours = date.getHours();
        var minutes = date.getMinutes();
        var newformat = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12;
        hours = hours ? hours : 12;
        minutes = minutes < 10 ? '0' + minutes : minutes;
        var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
        hiddenElement.download = 'Finance Approval Grid View'+'-'+title+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv]
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
})