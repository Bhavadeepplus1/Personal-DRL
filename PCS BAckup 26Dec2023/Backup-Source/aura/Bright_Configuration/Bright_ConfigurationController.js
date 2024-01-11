({
    doInit : function(component, event, helper){
        var runBatch = component.get("c.countOfNPR");    
        runBatch.setCallback(this, function (response) {  
            if(response.getState() === "SUCCESS"){  
                var nprCount=response.getReturnValue();
                component.set("v.nprCount",nprCount);                                    
            }
            
        });
        $A.enqueueAction(runBatch);  
    },
     nprStagging : function(component, event, helper){
        var runBatch = component.get("c.countOfNPRStagging");    
        runBatch.setCallback(this, function (response) {  
            if(response.getState() === "SUCCESS"){  
                var nprStaggingCount=response.getReturnValue();
                component.set("v.nprStaggingCount",nprStaggingCount);                                    
            }
            
        });
        $A.enqueueAction(runBatch);  
    },
    run : function(component, event, helper){
      
        var runBatch = component.get("c.startPhoenix_NPRDataActiveChecker");    
        runBatch.setCallback(this, function (response) {  
            if(response.getState() === "SUCCESS"){                
            }            
        });
        $A.enqueueAction(runBatch);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": "Batch scheduled successfully.",
            "type": "success"
        });
        toastEvent.fire();  
    }
    
})