({
    doInit: function(component, event, helper){
        var listPA = component.get("v.item.listOfPA");
        var listPC = component.get("v.item.listOfPC");
        var listVRO = component.get("v.item.listOfVRO");
        var listNPL = component.get("v.item.listOfNPL");
        var totalPA = 0;
        if(listPA != null){
            for(var i=0; i<listPA.length; i++){
                if(listPA[i].Customer_Response_Lines__r){
                    totalPA = totalPA+(listPA[i].Phoenix_Proposed_ASP_Dose__c * listPA[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c);
                }
            }
        }
        var totalPC = 0;
        if(listPC != null){
            for(var i=0; i<listPC.length; i++){
                if(listPC[i].Customer_Response_Lines__r){
                    totalPC = totalPC+(listPC[i].Phoenix_Proposed_ASP_Dose__c * listPC[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c);
                }
            }
        }
        var totalVRO = 0;
        if(listVRO != null){
            for(var i=0; i<listVRO.length; i++){
                if(listVRO[i].Customer_Response_Lines__r){
                    totalVRO = totalVRO+(listVRO[i].Phoenix_Proposed_ASP_Dose__c * listVRO[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c);
                }
            }
        }
        var totalNPL = 0;
        if(listNPL != null){
            for(var i=0; i<listNPL.length; i++){
                if(listNPL[i].Customer_Response_Lines__r){
                    totalNPL = totalNPL+(listNPL[i].Phoenix_Proposed_ASP_Dose__c * listNPL[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c);
                }
            }
        }
        component.set("v.item.totalPA", totalPA);
        component.set("v.item.totalPC", totalPC);
        component.set("v.item.totalVRO", totalVRO);
        component.set("v.item.totalNPL", totalNPL);
    },
    handleClick : function(component, event, helper) {
        var header = event.getSource().get("v.name");
        var compEvents = component.getEvent("componentEventFired");// getting the Instance of event
        var singleRec;
        if(header == 'Product Addition'){
            singleRec = component.get("v.item.listOfPA");
        } else if(header == 'Price Change'){
            singleRec = component.get("v.item.listOfPC");
        } else if(header == 'Volume Review Only'){
            singleRec = component.get("v.item.listOfVRO");
        } else if(header == 'New Product Launch'){
            singleRec = component.get("v.item.listOfNPL");
        } else if(header == 'Product Removal / Loss'){
            singleRec = component.get("v.item.listOfProductLoss");
        }
        compEvents.setParams({ "isProductsModalOpen" : true, 'header': header, 'singleRec': singleRec});// setting the attribute of event
        compEvents.fire();// firing the event.
    },
    highlightTier: function(component, event, helper){
        var compEvents = component.getEvent("componentTierEventFired");// getting the Instance of event
        compEvents.setParams({ "highlightTier" : component.get("v.item.tier")});// setting the attribute of event
        compEvents.fire();// firing the event.
    }
})