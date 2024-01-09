({
    initRecords : function(component, event, helper) {
        component.set('v.showSpinner',true);
          component.set("v.duplicateMsg",false);
        component.set('v.recordId', component.get("v.pageReference").state.c__recordId);
        var action = component.get("c.getRCAContracts");      
        action.setParams
        ({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var wrapperObj =  response.getReturnValue();
                                  
                                  
                                   var rcItemList=wrapperObj[0].rcItemList;
                                  
                                   console.log('rcItemList---'+JSON.stringify(rcItemList));
                                   component.set("v.rcItemList",rcItemList);
                                        var bidRecord = wrapperObj[0].bidRecord;
                                    if(bidRecord.Phoenix_Approval_Status__c != 'Draft') {
                        component.set('v.showDraftView',false);
                    }
                                   component.set("v.bidAgreement",bidRecord.Phoenix_RCA_Agreement__c)
                                   var memberList = wrapperObj;
                                   
                                  /* if(bidRecord.Phoenix_RCA_Agreement__c!=null && bidRecord.Phoenix_RCA_Agreement__c!=''&&bidRecord.Phoenix_RCA_Agreement__c!=undefined ){
                                       if(bidRecord.Phoenix_RCA_Agreement__r.Phoenix_Contract_Status__c=='Expired' || bidRecord.Phoenix_RCA_Agreement__r.Phoenix_Is_RCA_Contract__c==false){
                                          component.set("v.showRCAMsg",true);     
                                       }
                                        
                                   }
                                   else{
                                     component.set("v.showContrMsg",true);  
                                   }*/
                                   if(bidRecord.Phoenix_RCA_Agreement__c!=null && bidRecord.Phoenix_RCA_Agreement__c!=''&&bidRecord.Phoenix_RCA_Agreement__c!=undefined ){
                                    component.set("v.rcaMemberList",memberList); 
                                    component.set("v.rcaContract",bidRecord.Phoenix_RCA_Agreement__r.Phoenix_Is_RCA_Contract__c); 
                                      
                                   }
                                   
                                   component.set('v.showSpinner',false);                                  
                               }
                                   
                               
                               else{
                                   component.set('v.showSpinner',false);
                               }
                           });
        $A.enqueueAction(action);	
    },
    
    handleEvent: function(component, event, helper) {
        
        
        var message = event.getParam("message");
       var AllRowsList = component.get("v.rcaMemberList");
        for (let i = 0; i < AllRowsList.length; i++) {
            var index = message-1;
            if (index > -1) {
                console.log('index---'+index);
                
                AllRowsList.splice(index, 1);  
                break;
            }
            
        }
        if(AllRowsList.length==0){
            component.set("v.noData",true);
            
        }
        component.set("v.rcaMemberList",AllRowsList); 
    },
    
    
   
    processNewRCALine: function (component, event, helper) {
        component.set("v.showSpinner",true);
         component.set("v.noData",false);
         component.set("v.duplicateMsg",false);
        var rcaUpdateList=component.get("v.rcaMemberList");
        var getProductsAction = component.get("c.processRCALine");
        getProductsAction.setParams({"bidId":component.get("v.recordId")});
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                component.set("v.showSpinner",false);
                var resposeData = response.getReturnValue();
                rcaUpdateList.push(resposeData);
                console.log('resposeData--------'+resposeData);
                component.set("v.rcaMemberList",rcaUpdateList);
               
                
            }
            
        });
        $A.enqueueAction(getProductsAction);
        
    },
    insertRCALines: function (component, event, helper) {
        
        var wrapperList=component.get("v.rcaMemberList");
          console.log('wrapperList------'+wrapperList.length);
         component.set("v.duplicateMsg",false);
        var rcaLines=[];
        for(var i=0;i<wrapperList.length;i++){
         rcaLines.push(wrapperList[i].rcItem);   
        }
         var IPACustomers=[];
         var duplicateList=[];
        var duplicateExistingcustomers=[];
          var accountList=component.get("v.rcItemList");
        
      
        
       
        
        var existingMap=new Map();
        console.log('Hi before length');
          console.log('accountList------'+accountList);
        if(accountList!=null && accountList!=undefined && accountList!=''){
         for(var i=0;i<accountList.length;i++){
       
             existingMap.set(accountList[i].Phoenix_Customer__c,accountList[i].Phoenix_Customer__r.Name);
        }
        }
       console.log('Hi after length');
        console.log('accountList-----'+JSON.stringify(accountList));
         rcaLines.forEach(function(line){
            
             if(accountList!=''&& accountList!=undefined && accountList!=null && (existingMap.has(line['Phoenix_Customer__c']))){
              
                  duplicateExistingcustomers.push(existingMap.get(line['Phoenix_Customer__c']));
                 component.set("v.duplicateMsg",true);
             }
            
 });
                                                  
             if( component.get("v.duplicateMsg")==true){
               for(var i=0;i<duplicateExistingcustomers.length;i++){
                 console.log('Hi');
                 var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": 'error',
                    "message": "Duplicates are found for "+ duplicateExistingcustomers[i] +" .Please remove the duplicates"
                });
                toastEvent.fire();
             }
                 
             }                                      
                                              
        if(component.get("v.duplicateMsg")==false){   
            component.set("v.showSpinner",true);
        var getProductsAction = component.get("c.saveRCAMembers");
        
        console.log('rcaLines------'+JSON.stringify(rcaLines));
        getProductsAction.setParams({"memberList":rcaLines});
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            component.set("v.showSpinner",false);
            console.log('actState-----'+actState);
            if (actState === 'SUCCESS') {
                component.set("v.showSpinner",false);
                var resposeData = response.getReturnValue();
               component.find("navService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);
                
                
            }
            else if (actState === "ERROR") {
                    var errors = response.getError();
                console.log('errors-----'+JSON.stringify(errors));
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } 
                }
            
        });
        $A.enqueueAction(getProductsAction);
        }
    },
     backToBid : function(component, event, helper){
          component.set("v.duplicateMsg",false);
          component.set("v.showRCAMsg",false);
          component.set("v.showContrMsg",false);
         component.set("v.noData",false);
        
        
        component.find("navService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);
     },
})