({
    doInit : function(component,event,helper){  
        console.log('I am doinit');
        var singlerec = component.get("v.singlerec");
        
        if(singlerec.Quarter_1__c != null && singlerec.Quarter_2__c != null && singlerec.Quarter_3__c != null && singlerec.Quarter_4__c != null ){
            component.set("v.greenCss",true);
            console.log('I am doinit inside');
        }
        else{
            component.set("v.greenCss",false);
        }
        
      
    },
    inlineEditWestSales : function(component,event,helper){  
        component.set("v.editWestQtr", true);
        component.set("v.saveAndEdit", false); 
        component.set("v.disAbleAnnual", true);
        var rowIndex = event.getSource().get("v.name");
        console.log('rowIndex is ---'+rowIndex);
      
    },
    resetData: function (component, event, helper) {
        var rowIndex = event.getSource().get("v.name");
        component.set("v.saveAndEdit", true);
        component.set("v.editWestQtr", false);
        component.set("v.greenCss", false);
        console.log('rowIndex---'+rowIndex);
        
        
        var action = component.get("c.resetQtrSales");
        action.setParams({
            singlerec : component.get("v.singlerec")
        });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                //component.set("v.editWestQtr", true);   
                
                var responseWrapper=response.getReturnValue();
                helper.formatData(component, event, helper, responseWrapper)
            }
            else{
                console.log('errot---'+JSON.stringify(response.getError()));
            }
            
        });
        $A.enqueueAction(action);
        
    },
    close: function (component, event, helper) {
         var rowIndex = event.getSource().get("v.name");
        component.set("v.saveAndEdit", true);
        component.set("v.editWestQtr", false);
        var quarter1 = (component.get("v.singlerec.Quarter_1__c") != undefined && component.get("v.singlerec.Quarter_1__c") != null) ? component.get("v.singlerec.Quarter_1__c") : 0;
        var quarter2 = (component.get("v.singlerec.Quarter_2__c") != undefined && component.get("v.singlerec.Quarter_2__c") != null) ? component.get("v.singlerec.Quarter_2__c") : 0;
        var quarter3 = (component.get("v.singlerec.Quarter_3__c") != undefined && component.get("v.singlerec.Quarter_3__c") != null) ? component.get("v.singlerec.Quarter_3__c") : 0;
        var quarter4 = (component.get("v.singlerec.Quarter_4__c") != undefined && component.get("v.singlerec.Quarter_4__c") != null) ? component.get("v.singlerec.Quarter_4__c") : 0;
        if(!quarter1 || !quarter2 || !quarter3 || !quarter4){
             component.set("v.greenCss", false);
        }else{
             component.set("v.greenCss", true);
        }
        
        
        var action = component.get("c.getExistingData");
        action.setParams({
            singlerec : component.get("v.singlerec")
        });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                //component.set("v.editWestQtr", true);   
                
                var responseWrapper=response.getReturnValue();
                helper.formatData(component, event, helper, responseWrapper)
            }
            else{
                console.log('errot---'+JSON.stringify(response.getError()));
            }
            
        });
        $A.enqueueAction(action);
    },
    closeWestQtrTarget: function (component, event, helper) {       
        component.set("v.checkQtrdata",false);
        var quarter1 = (component.get("v.singlerec.Quarter_1__c") != undefined && component.get("v.singlerec.Quarter_1__c") != null) ? component.get("v.singlerec.Quarter_1__c") : 0;
        var quarter2 = (component.get("v.singlerec.Quarter_2__c") != undefined && component.get("v.singlerec.Quarter_2__c") != null) ? component.get("v.singlerec.Quarter_2__c") : 0;
        var quarter3 = (component.get("v.singlerec.Quarter_3__c") != undefined && component.get("v.singlerec.Quarter_3__c") != null) ? component.get("v.singlerec.Quarter_3__c") : 0;
        var quarter4 = (component.get("v.singlerec.Quarter_4__c") != undefined && component.get("v.singlerec.Quarter_4__c") != null) ? component.get("v.singlerec.Quarter_4__c") : 0;
        var totalQuarters = parseFloat(quarter1) + parseFloat(quarter2) + parseFloat(quarter3) + parseFloat(quarter4);
        
        
        var westRegion = component.get("v.targetApprovalObj.West_Region_Target__c");
        console.log('westRegion--'+westRegion);
        console.log('totalQuarters--'+totalQuarters);
        var usName = component.get("v.singlerec.User_Name__c");
        console.log('usName--'+usName);
        var daveSmith = $A.get("$Label.c.Dave_Smith");
        
        var saveVal = false;
        
        var checkQtrdata = false;
        var fireVal = false;
        var message = '';
        var action = component.get("c.validateWestQuaterData");
        action.setParams({
            singlerec : component.get("v.singlerec")
            
        });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                
                var responseWrapper=response.getReturnValue();
               // console.log('validate responseWrapper==='+responseWrapper.submitForApprovalValue);
                component.set("v.checkQtrdata",responseWrapper.checkQtrdata);
                /* if(responseWrapper.submitForApprovalValue){
                     component.set("v.disableSubmitButton",false);
                }
                else{
                     component.set("v.disableSubmitButton",true);
                }*/
               
                if(totalQuarters != westRegion  && usName == daveSmith ){
                    saveVal = true;
                    console.log('saveVal--'+saveVal);
                }
                else if(totalQuarters == westRegion){
                    saveVal = false;
                }
                if(responseWrapper.fireValidationQ1){
                    console.log('fireVal = true;');
                    fireVal = true;
                    message = 'Sum of all sales person Quarter1 should be equal to Dave Smith Quater1 sales.'
                }
                else if(responseWrapper.fireValidationQ2){
                    fireVal = true;
                    message = 'Sum of all sales person Quarter2 should be equal to Dave Smith Quater2 sales.'
                }
                    else if(responseWrapper.fireValidationQ3){
                        fireVal = true;
                        message = 'Sum of all sales person Quarter3 should be equal to Dave Smith Quater3 sales.'
                    }
                        else if(responseWrapper.fireValidationQ4){
                            fireVal = true;
                            message = 'Sum of all sales person Quarter4 should be equal to Dave Smith Quater4 sales.'
                        }
                
                
            }
            else{
                console.log('errot---'+JSON.stringify(response.getError()));
            }
             if(component.get("v.checkQtrdata") ){
            console.log('checkQtrdata===Inside');
           helper.allQuartersVAlidation(component, event, helper);
        }
        else if(saveVal){
            console.log('checkQtrdata===else if');
            helper.validateData(component, event, helper);
        }
        else if(component.get("v.singlerec.User_Name__c ") == 'Dave Smith' && !(component.get("v.checkQtrdata"))){
            component.set("v.editWestQtr",false);
            console.log('saving in eric else');
            helper.saveQtrData(component, event, helper); 
        }
              if(component.get("v.singlerec.User_Name__c ") != 'Dave Smith' && !(component.get("v.checkQtrdata")) && !saveVal){
            console.log('saving in fireValue');
            if(fireVal){  
                component.set("v.redCss",true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message":message
                });
                toastEvent.fire();
            } else{
                console.log('saving in other else');
                component.set("v.editWestQtr",false);
                helper.saveQtrData(component, event, helper);  
            }
            
        }
        
        console.log("CheckQuarter181----"+component.get("v.checkQtrdata"));
        });
        $A.enqueueAction(action);
      
      
        
    },
    
    onWestQtrChange : function(component,event,helper){
        if(component.get("v.singlerec.User_Name__c ") != 'Dave Smith'){
            var quarter1 = (component.get("v.singlerec.Quarter_1__c") != undefined && component.get("v.singlerec.Quarter_1__c") != null) ? component.get("v.singlerec.Quarter_1__c") : 0;
            var quarter2 = (component.get("v.singlerec.Quarter_2__c") != undefined && component.get("v.singlerec.Quarter_2__c") != null) ? component.get("v.singlerec.Quarter_2__c") : 0;
            var quarter3 = (component.get("v.singlerec.Quarter_3__c") != undefined && component.get("v.singlerec.Quarter_3__c") != null) ? component.get("v.singlerec.Quarter_3__c") : 0;
            var quarter4 = (component.get("v.singlerec.Quarter_4__c") != undefined && component.get("v.singlerec.Quarter_4__c") != null) ? component.get("v.singlerec.Quarter_4__c") : 0;
            var totalQuarters = parseFloat(quarter1) + parseFloat(quarter2) + parseFloat(quarter3) + parseFloat(quarter4);
            component.set("v.singlerec.Annual__c",totalQuarters);
            
            
        }
        
    },
})