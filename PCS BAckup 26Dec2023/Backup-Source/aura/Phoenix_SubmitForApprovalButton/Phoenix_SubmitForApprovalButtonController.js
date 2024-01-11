({
    doInit : function(component, event, helper) {
        
    },
    
    showSubmitPanel: function (component, event, helper) {
        var wrapList = component.get("v.wrapList");
        var isError = false;
        wrapList.forEach(function(wrapObj){
            console.log('wrapObj.existingVIPrebate :: '+wrapObj.existingVIPrebate);
            if(!wrapObj.existingVIPrebate){
                console.log('setting error True');
                isError = true;
            }
        });
        console.log('isError --- '+isError);
        component.set("v.showSubmit",true);
        if(isError){
            component.set("v.isError",true);
            component.set("v.errorMessage",'Please review the "New Vip Rebate" tab before submitting the bid for Approval.')
        }
        else{
            var recordId=component.get("v.recId");
            component.set("v.recId",recordId);
            var bidId =component.get("v.recId"); 
            var getBidInfoAction = component.get("c.getBidInfo");
            getBidInfoAction.setParams({ "bidId": bidId });
            getBidInfoAction.setCallback(this, function (response) {
                var actState = response.getState();
                if (actState === 'SUCCESS') {
                    console.log('----------actState------'+actState);
                    component.set("v.wrap",response.getReturnValue());
                    component.set("v.showSpinner",false);
                }
            });
            $A.enqueueAction(getBidInfoAction);
        }
    },
    
    closeQuickActionPanel: function (component, event, helper) {
        // helper.closeActionPanel();
        component.set("v.showSubmit",false);
        // component.set("v.showSpinner",false);
    },
    
    submitTheBid : function(component, event, helper) {
        
        var wrap = component.get("v.wrap");
        component.set("v.showSpinner",true);
        console.log('wrap is '+JSON.stringify(wrap));
        var submitBidAction = component.get("c.submitBid");
        submitBidAction.setParams({ "wrap": wrap });
        submitBidAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                component.set("v.showSpinner",false);
                var res = response.getReturnValue();
                if(res == 'Success'){
                    console.log('wrap is '+JSON.stringify(wrap));
                    
                    //------------Changes by Mamatha Dhruvsoft-------START------
                    
                    //helper.closeActionPanel();
                    //window.location.reload();
                    component.set("v.showSubmit",false);
                    component.find("navService").navigate({
                        type: "standard__recordPage",
                        attributes: {
                            recordId: component.get("v.recId"),
                            actionName: "view"
                        }
                    }, false);
                    $A.get('e.force:refreshView').fire(); 
                    
                    //------------Changes by Mamatha Dhruvsoft-------END------
                }
                else{
                    console.log('see res=>'+JSON.stringify(res));
                    component.set("v.isError",true);
                    component.set("v.errorMessage",res);
                } 
            }
        });
        $A.enqueueAction(submitBidAction);
    }
    
})