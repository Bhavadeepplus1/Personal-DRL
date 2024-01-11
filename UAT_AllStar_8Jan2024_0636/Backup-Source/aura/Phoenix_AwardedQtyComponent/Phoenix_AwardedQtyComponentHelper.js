({
    /*showWarningToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning',
            message: 'Mode is pester ,duration is 5sec and normal message',
            messageTemplate: 'Mode is sticky ,duration is 5sec and Message is overrriden because messageTemplateData is {1}',
            messageTemplateData: ['Salesforce', {
                url: 'http://www.webkul.com/',
                label: 'Click Here',
            }],
            duration:' 5000',
            key: 'info_alt',
            type: 'warning',
            mode: 'sticky'
        });
        toastEvent.fire();
    },*/
    getTotalQtyData: function (component,event,helper) {
        var custresId=component.get("v.CustResLineId");
        var action = component.get("c.getTotalQtyData");
        action.setParams({
            'custresId':custresId    
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                var iii=component.get("v.sumofAllAwardedQty");
                var remQtyToAward=responseList.awardQty - iii;
                component.set("v.remQtyToAward",remQtyToAward);
                console.log('remQtyToAward'+remQtyToAward);
                component.set("v.totallineAwaQty",responseList.awardQty);
                component.set("v.prodName",responseList.prodName);
                component.set("v.ProdId",responseList.ProdId);
            }
         });
        $A.enqueueAction(action);
        helper.getPicklistValues(component,event,helper);
    },
    getPicklistValues: function (component,event,helper) {
        var custresId=component.get("v.CustResLineId");
        var action = component.get("c.getPicklistValues");
        action.setParams({
            'custresId':custresId
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                console.log('responseListresponseList'+responseList);
                component.set("v.getPicklistValues",responseList);
                var options = [];
                if(responseList != null){
                    options[0] = {
                        'label': 'All',
                        'value': 'All'
                    }
                    for(var i=0; i<responseList.length; i++){
                        options[i+1] = {
                            'label':responseList[i],
                            'value': responseList[i]
                        }
                    }
                }
                component.set("v.positionsPicklistOptions", options);
                var respList = component.get("v.responseList");
                if(respList != null){
                    for(var i=0; i<respList.length; i++){
                        var opt = options;
                        var values = [];
                        for(var j=0; j<opt.length; j++){
                            var awardedPosition = respList[i].Phoenix_Awarded_Position__c;
                            var awardedList = awardedPosition.split(',');
                            for(var k=0; k<awardedList.length; k++){
                                if(opt[j].value == awardedList[k]){
                                    opt[j].selected = true;
                                    values.push(opt[j].value);
                                } else{
                                    opt[j].selected = false;
                                }   
                            }
                            if(opt[j].value == 'All' && awardedList.length == opt.length-1){
                                opt[j].selected = true;
                                values.push(opt[j].value);
                            }
                        }
                        respList[i].options = opt;
                        respList[i].selectedOptions = values;
                    }
                    component.set("v.responseList", respList);
                }
            }
        });
        $A.enqueueAction(action);
    },
    /*handleSaveEdition: function (component, event, helper) {
        var draftValues = component.get("v.responseList");
         
        console.log(draftValues);
        var action = component.get("c.updateAccount");
        action.setParams({"acc" : draftValues});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state="Success"){
                component.set("v.isModalOpen", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                //helper.UpdateNextSteps(component,event,helper);
                $A.get('e.force:refreshView').fire();
            }
            
        });
        $A.enqueueAction(action);
        
         }*/
})