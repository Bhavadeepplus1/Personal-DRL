({
    saveQtrData : function(component, event, helper) {
        var action = component.get("c.updateQuaterSales");
        action.setParams({
            singlerec : component.get("v.singlerec")
        });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                component.set("v.redCss",false);   
                component.set("v.saveAndEdit", true);
                var responseWrapper=response.getReturnValue();
                console.log('list-->'+JSON.stringify(responseWrapper)); 
                var testList = [];
                testList.push(responseWrapper);
                var customFieldList = testList.map(function(record) {
                    var Annual__c;
                    if(record.Annual__c !=  undefined && record.Annual__c != null){
                        Annual__c =helper.formatRevenue(record.Annual__c);
                    }
                    
                    var Quarter_1__c;
                    if(record.Quarter_1__c !=  undefined && record.Quarter_1__c != null){
                        Quarter_1__c = helper.formatRevenue(record.Quarter_1__c);
                    }
                    var Quarter_2__c;
                    if(record.Quarter_2__c !=  undefined && record.Quarter_2__c != null){
                        Quarter_2__c  = helper.formatRevenue(record.Quarter_2__c );
                    }
                    var Quarter_3__c;
                    if(record.Quarter_3__c !=  undefined && record.Quarter_3__c != null){
                        Quarter_3__c  = helper.formatRevenue(record.Quarter_3__c );
                    }
                    var Quarter_4__c;
                    if(record.Quarter_4__c !=  undefined && record.Quarter_4__c != null){
                        Quarter_4__c  = helper.formatRevenue(record.Quarter_4__c );
                    }
                    return {
                        Id : record.Id,
                        Financial_Year__c : record.Financial_Year__c,
                        Regional_Manager__c : record.Regional_Manager__c,
                        Region__c : record.Region__c,
                        SRx_Target__c : record.SRx_Target__c,
                        User_Name__c  : record.User_Name__c,
                        Quarter_1__str  : Quarter_1__c,
                        Quarter_2__str  : Quarter_2__c,
                        Quarter_3__str  : Quarter_3__c,
                        Quarter_4__str  : Quarter_4__c,
                        Quarter_1__c  : record.Quarter_1__c,
                        Quarter_2__c  : record.Quarter_2__c,
                        Quarter_3__c  : record.Quarter_3__c,
                        Quarter_4__c  : record.Quarter_4__c,
                        Annual__str  : Annual__c,
                        Annual__c  : record.Annual__c
                        
                    };
                });
               /* var message = "Hello from child component!";
                var childEvent = component.getEvent("Target_Submission_Event");
                childEvent.setParams({
                    "message": message
                });
                childEvent.fire();
                */
                component.set("v.singlerec",customFieldList[0]);
                if(responseWrapper.Quarter_1__c != null && responseWrapper.Quarter_2__c != null && responseWrapper.Quarter_3__c != null && responseWrapper.Quarter_4__c != null ){
                    component.set("v.greenCss",true);
                }
                else{
                    component.set("v.greenCss",false);
                }
            }
            else{
                console.log('errot---'+JSON.stringify(response.getError()));
            }
            
        });
        $A.enqueueAction(action);
        
    },
    formatRevenue: function(annualRevenue) {
        if (annualRevenue >= 1000000) {
            return '$'+(annualRevenue / 1000000).toFixed(1) + 'M';
        } else if (annualRevenue >= 1000) {
            return '$'+(annualRevenue / 1000).toFixed(1) + 'k';
        } else {
            return '$'+(annualRevenue);
        }
    },
    formatData: function(component, event, helper, responseWrapper) {
        var testList = [];
                testList.push(responseWrapper);
                var customFieldList = testList.map(function(record) {
                    var Annual__c;
                    if(record.Annual__c !=  undefined && record.Annual__c != null){
                        Annual__c =helper.formatRevenue(record.Annual__c);
                    }
                    
                    var Quarter_1__c;
                    if(record.Quarter_1__c !=  undefined && record.Quarter_1__c != null){
                        Quarter_1__c = helper.formatRevenue(record.Quarter_1__c);
                    }
                    var Quarter_2__c;
                    if(record.Quarter_2__c !=  undefined && record.Quarter_2__c != null){
                        Quarter_2__c  = helper.formatRevenue(record.Quarter_2__c );
                    }
                    var Quarter_3__c;
                    if(record.Quarter_3__c !=  undefined && record.Quarter_3__c != null){
                        Quarter_3__c  = helper.formatRevenue(record.Quarter_3__c );
                    }
                    var Quarter_4__c;
                    if(record.Quarter_4__c !=  undefined && record.Quarter_4__c != null){
                        Quarter_4__c  = helper.formatRevenue(record.Quarter_4__c );
                    }
                    return {
                        Id : record.Id,
                        Financial_Year__c : record.Financial_Year__c,
                        Regional_Manager__c : record.Regional_Manager__c,
                        Region__c : record.Region__c,
                        SRx_Target__c : record.SRx_Target__c,
                        User_Name__c  : record.User_Name__c,
                        Quarter_1__str  : Quarter_1__c,
                        Quarter_2__str  : Quarter_2__c,
                        Quarter_3__str  : Quarter_3__c,
                        Quarter_4__str  : Quarter_4__c,
                        Quarter_1__c  : record.Quarter_1__c,
                        Quarter_2__c  : record.Quarter_2__c,
                        Quarter_3__c  : record.Quarter_3__c,
                        Quarter_4__c  : record.Quarter_4__c,
                        Annual__str  : Annual__c,
                        Annual__c  : record.Annual__c
                        
                    };
                });
                
        component.set("v.singlerec",customFieldList[0]);
    },
    allQuartersVAlidation: function(component, event, helper) 
    {
         component.set("v.redCss",true);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message":'Please fill all quarter values.'
            });
            toastEvent.fire();
            component.set("v.targetApprovalObj",component.get("v.targetApprovalObj"));
    },
     validateData: function(component, event, helper) 
    {
         console.log('inside child else=====>>');
            component.set("v.redCss",true);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message":'Eric sutherland annual should be equals to the East Region target value'
            });
            toastEvent.fire();
        
        component.set("v.targetApprovalObj",component.get("v.targetApprovalObj"));
    },
})