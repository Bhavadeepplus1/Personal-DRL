({
    initRecords : function(component,event,helper){
        var accountId=component.get("v.recordId");
        //component.set("v.isSpinnerLoad",true);
        var action = component.get("c.getContactScores");
        var searchValue=component.get("v.searchValue");
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                var conList = response.getReturnValue();
                component.set('v.allContactsList',conList);
                
                if(conList.length>0){
                    component.set('v.isData',true);
                    component.set("v.isSpinnerLoad",false);
                    component.set('v.isEmpty',false);
                    
                }
                else{
                    component.set("v.isSpinnerLoad",true);
                    component.set('v.isData',false);
                    component.set('v.isEmpty',true);
                    
                }
                if(conList.length==0){
                    component.set("v.isSpinnerLoad",false);
                    component.set('v.isData',false);
                    component.set('v.isEmpty',true);}
                
                //var nameList=[];
                //var roleList=[];
                var inc = 0;
                                if(conList.length>0){

                component.set("v.contactsList",conList[inc].con);
                component.set("v.Department",conList[inc].con.Department);
                component.set("v.Title",conList[inc].con.Title);
                component.set("v.contactRole",conList[inc].con.Contact_Role__c);
                 component.set("v.noOfRecords",conList.length);
console.log('length-----'+conList.length);
                                }
                /*for(var i=0; i<response.length; i++){+
                    nameList.push(response[i].Name);
                    component.set('v.contactNameList',nameList);
                    var na=component.get('v.contactNameList');
                    console.log('response na>>>'+JSON.stringify(na));
                }*/
            }
        });
        $A.enqueueAction(action);
    },
    handleClickSaveNext : function(component,event,helper){
        var inc = component.get("v.inc");
        if(inc != component.get("v.noOfRecords")){
          inc =  inc+1;
        component.set("v.inc",inc);  
        }
        
        var action = component.get("c.updateContact");
        action.setParams({contactObj : component.get("v.contactsList"),
                          Department : component.get("v.Department"),
                          Title : component.get("v.Title"),
                          contactRole : component.get("v.contactRole")});
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                var conObj = response.getReturnValue();
                component.set("v.contactsList",conObj);
                 component.set("v.Department",conObj.Department);
                component.set("v.Title",conObj.Title);
                component.set("v.contactRole",conObj.Contact_Role__c);
                var allContactsList = component.get("v.allContactsList");
                        if(inc != component.get("v.noOfRecords")){
                component.set("v.contactsList",allContactsList[inc].con);
                var contactsList = component.get('v.contactsList');
                component.set("v.Department",allContactsList[inc].con.Department);
                component.set("v.Title",allContactsList[inc].con.Title);
                component.set("v.contactRole",allContactsList[inc].con.Contact_Role__c);
                        }
            }
            else{
                console.log('ERROR : unable to Update Contact..');
                component.set("v.isSpinnerLoad",false);
               
            }
        });
        $A.enqueueAction(action);
    },
    handleClickSave : function(component,event,helper){
       var action = component.get("c.updateContact");
        action.setParams({contactObj : component.get("v.contactsList"),
                          Department : component.get("v.Department"),
                          Title : component.get("v.Title"),
                          contactRole : component.get("v.contactRole")});
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                var conObj = response.getReturnValue();
                component.set("v.contactsList",conObj);
              //  var allContactsList = component.get("v.allContactsList");
               // component.set("v.contactsList",allContactsList[inc].con);
              //  var contactsList = component.get('v.contactsList');
                component.set("v.Department",conObj.Department);
                component.set("v.Title",conObj.Title);
                component.set("v.contactRole",conObj.Contact_Role__c);
                  var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": 'success',
                        "message": "Contact Scoring is updated successfully."
                    });
                    toastEvent.fire();
            }
            else{
                console.log('ERROR : unable to Update Contact..');
                component.set("v.isSpinnerLoad",false);
               
            }
        });
        $A.enqueueAction(action);
    },
        handleClickBack : function(component,event,helper){
         var inc = component.get("v.inc");
        inc =  inc-1;
        component.set("v.inc",inc);
                var allContactsList = component.get("v.allContactsList");
                            component.set("v.contactsList",allContactsList[inc].con);
 component.set("v.Department",allContactsList[inc].con.Department);
                component.set("v.Title",allContactsList[inc].con.Title);
                component.set("v.contactRole",allContactsList[inc].con.Contact_Role__c);
        },
    changeInInfl : function(component, event, helper){
        component.set("v.isSpinnerLoad",true);
        var influenceScore = event.currentTarget.dataset.set;
        console.log('influenceNumber ---> '+influenceScore);
        var action = component.get("c.updateInfluenceScore");
        console.log('contactsList>>>>'+JSON.stringify(component.get("v.contactsList")));
        
        action.setParams({contactObj : component.get("v.contactsList"),
                          influenceScore : influenceScore});
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                var conObj = response.getReturnValue();
                console.log('updated influence score --> '+conObj.Influence_Score__c);
                component.set("v.contactsList",conObj);
                console.log('conObj>>>>'+JSON.stringify(conObj));
                
                component.set("v.isSpinnerLoad",false);
            }
            else{
                console.log('ERROR : unable to Update Contact..');
                component.set("v.isSpinnerLoad",false);
            }
        });
        $A.enqueueAction(action);
    },
    changeInAffn : function(component, event, helper){
        component.set("v.isSpinnerLoad",true);
        var affinityScore = event.currentTarget.dataset.set;
        console.log('affinityNumber ---> '+affinityScore);
        var action = component.get("c.updateAffinityScore");
        action.setParams({contactObj : component.get("v.contactsList"),
                          affinityScore : affinityScore});
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                var conObj = response.getReturnValue();
                console.log('updated affinity score --> '+conObj.Affinity_Score__c);
                component.set("v.contactsList",conObj);
                component.set("v.isSpinnerLoad",false);
            }
            else{
                console.log('ERROR : unable to Update Contact..');
                component.set("v.isSpinnerLoad",false);
            }
        });
        $A.enqueueAction(action);
    },
    changeInAuth : function(component, event, helper){
        component.set("v.isSpinnerLoad",true);
        var authScore = event.currentTarget.dataset.set;
        console.log('affinityNumber ---> '+authScore);
        var action = component.get("c.updateAuthScore");
        action.setParams({contactObj : component.get("v.contactsList"),
                          authScore : authScore});
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                var conObj = response.getReturnValue();
                console.log('updated affinity score --> '+conObj.Authority__c);
                component.set("v.contactsList",conObj);
                component.set("v.isSpinnerLoad",false);
            }
            else{
                console.log('ERROR : unable to Update Contact..');
                component.set("v.isSpinnerLoad",false);
                console.log("Error "+JSON.stringify(response.getError()));
                
            }
        });
        $A.enqueueAction(action);
    }
})