({
    handleSubmit: function(component, event, helper) {
        console.log('called----'+component.get("v.wac"));
        var accId = component.find('accountLookup').get('v.selectedRecordId');
        var messageVal='';
        var fireToast = 'false';
        var wac;
        var contractPrice;
        var proposedPUR;  
        var parameterWrapper ={
            "accId" : component.find('accountLookup').get('v.selectedRecordId'),
            "wac" :component.get("v.wac"),
            "contractPrice" :component.get("v.contractPrice"),
            "productType":component.get("v.productType"),
            "bidTemplateStr":component.get("v.bidTemplateStr"),
            "proposedPUR":component.get("v.proposedPUR"),
            "directContractPrice":component.get("v.directContractPrice"),
            "wholesalerPriceIndirect":component.get("v.wholealerPrice"),
            "salesoutPromotionDays":component.get("v.salesoutPromotionDays"),
            "salesOutPromotionPercentage":component.get("v.salesoutPromotionPercentage"),
            "ProposedNCPforWMTIndirect":component.get("v.NCPWMTIndirectUnits"),
            "ProposedNCPforMcKOSRAD":component.get("v.osradUnits"),
            "ProposedNCPforWMTDirect":component.get("v.NCPWMTDirectUnits"),
            "mktngPrice":component.get("v.CVSMktgPrice"),
            "indirectNet":component.get("v.indirectNet"),
            "proposedBASEContractPrice":component.get("v.proposedBASEContractPrice"),
            "ProposedDSHContractPrice":component.get("v.ProposedDSHContractPrice"),
            "ProposedAutoSubContractPrice":component.get("v.ProposedAutoSubContractPrice")
            
            
        };
        console.log('directContractPrice====='+component.get("v.directContractPrice"));
        var template='';
        if(component.get("v.bidTemplateStr") == 'Humana Indirect CII' || component.get("v.bidTemplateStr") == 'Humana Indirect retail'){
            template = component.get('v.bidTemplateStr');
        }
        else{
            template = component.get('v.bidTemplate');
            
        }
      /*    if(component.get("v.bidTemplate") == null || component.get("v.bidTemplate") == '' || component.get("v.bidTemplate") == undefined){
            messageVal = "Please enter value for Bid Template";
            fireToast = 'true';
        }
        
        if(component.get("v.productType") == null || component.get("v.productType") == '' || component.get("v.productType") == undefined){
            messageVal = "Please enter value for Product Type";
            fireToast = 'true';
        }
       else if(component.get("v.wac") == null || component.get("v.wac") == '' || component.get("v.wac") == undefined){
                messageVal = "Please enter value for WAC";
                fireToast = 'true';
            }
                else if(component.get('v.contractPrice') == null ||component.get('v.contractPrice') == '' || component.get('v.contractPrice') == undefined){
                    messageVal = "Please enter value for Contract Price";
                    fireToast = 'true';
                }
        else if(component.get("v.bidTemplate")=='Direct' &&(component.get('v.proposedPUR') == null || component.get('v.proposedPUR') == '' || component.get('v.proposedPUR') == undefined)){
            messageVal = "Please enter value for Proposed PUR";
            fireToast = 'true';
        }*/
        
        if(fireToast == 'true'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": messageVal
            });
            toastEvent.fire();
            
        }
        else{
            var getBidInfoAction = component.get("c.calculateDeadNet");
            
            getBidInfoAction.setParams({
                "params" :JSON.stringify(parameterWrapper)
            });
            getBidInfoAction.setCallback(this, function (response) {
                var actState = response.getState();
                if (actState == 'SUCCESS') {
                    component.set("v.showResult",true);
                    var responseWrapper=response.getReturnValue();
                    component.set("v.responseWrapper",responseWrapper);
                    console.log('responseWrapper====='+responseWrapper);
                }
                else{
                    
                    console.log('errot---'+JSON.stringify(response.getError()));
                }
                
            });
            $A.enqueueAction(getBidInfoAction);
        } 
    },
    handleChange: function (component, event, helper) { 
        component.set("v.bidTemplateStr",'');
        component.set("v.showResult",false);
        console.log('In Process=='+component.find('accountLookup').get('v.selectedRecordId'));
        var accId = component.find('accountLookup').get('v.selectedRecordId');
        var getBidInfoAction = component.get("c.getTemplate");
        
        getBidInfoAction.setParams({
            accId : accId
            
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                console.log('Inside Sucedx')
                var responseWrapper=response.getReturnValue();
                component.set("v.bidTemplate",responseWrapper);
            }
            else{
                
                console.log('errot---'+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(getBidInfoAction);
    },  
    doSomething : function (component, event, helper) {
        //Do something with the change handler
        component.set("v.showResult",false);
        console.log('do====='+event.getSource().get("v.value"));
        var template =event.getSource().get("v.value");
        component.set("v.productType",template);
    },
    selectTemplate :function (component, event, helper) {
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
        component.set("v.showResult",false);
          alert("Option selected with value: '" + selectedOptionValue + "'");
        component.set("v.bidTemplateStr",selectedOptionValue);
        
    },
    selectTemplateStr :function (component, event, helper) {
        //Do something with the change handler
        console.log('do====='+event.getSource().get("v.value"));
        component.set("v.bidTemplateStr",event.getSource().get("v.value"));
        console.log('aBC-----'+component.get("v.bidTemplateStr"));
    },
    resetData :function (component, event, helper) {
        component.set("v.bidTemplateStr",'');
         component.set("v.bidTemplate",'');
        component.set("v.wac",'');
        component.set("v.selectedAccId",null);
        component.set("v.contractPrice",'');
        component.set("v.productType",'');
        component.set("v.bidTemplateStr",'');
        component.set("v.proposedPUR",'');
        component.set("v.directContractPrice",'');
        component.set("v.wholealerPrice",'');
        component.set("v.salesoutPromotionDays",'');
        component.set("v.salesoutPromotionPercentage",'');
        component.set("v.NCPWMTIndirectUnits",'');
        component.set("v.osradUnits",'');
        component.set("v.NCPWMTDirectUnits",'');
        component.set("v.CVSMktgPrice",'');
        component.set("v.indirectNet",'');
        component.set("v.proposedBASEContractPrice",'');
        component.set("v.ProposedDSHContractPrice",'');
        component.set("v.ProposedAutoSubContractPrice",'');
        
    },
})