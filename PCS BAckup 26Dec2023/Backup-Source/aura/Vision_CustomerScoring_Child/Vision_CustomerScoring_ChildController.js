({
	doInit : function(component, event, helper) {
		var contactObjWrallper = component.get("v.contactWrapper");
        component.set("v.contactObj",contactObjWrallper.con);
        //console.log('contactObj'+JSON.stringify(component.get("v.contactObj")));
        //var influenceScore = contactObj.Influence_Score__c != undefined ? contactObj.Influence_Score__c : 0;
        //var affinityScore = contactObj.Affinity_Score__c != undefined ? contactObj.Affinity_Score__c : 0;
        //var authScore = contactObj.Authority__c != undefined ? contactObj.Authority__c : 0;
        //console.log('authScore'+authScore);
        //console.log('infl'+influenceScore);
        
        
	},
    navigate:function(component){
        alert('idx');
        console.log('idx11');

var idx= event.currentTarget.id;
        
        console.log('idx',+idx);
var navEvt = $A.get("e.force:navigateToSObject");
navEvt.setParams({
"recordId": idx,
"slideDevName": "detail"

 });
  navEvt.fire(); 
},   

 
    changeInInfl : function(component, event, helper){
        component.set("v.isSpinnerLoad",true);
        var influenceScore = event.currentTarget.dataset.set;
        console.log('influenceNumber ---> '+influenceScore);
        var action = component.get("c.updateInfluenceScore");
        action.setParams({contactObj : component.get("v.contactObj"),
                          influenceScore : influenceScore});
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                var conObj = response.getReturnValue();
                console.log('updated influence score --> '+conObj.Influence_Score__c);
                component.set("v.contactObj",conObj);
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
        action.setParams({contactObj : component.get("v.contactObj"),
                          affinityScore : affinityScore});
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                var conObj = response.getReturnValue();
                console.log('updated affinity score --> '+conObj.Affinity_Score__c);
                component.set("v.contactObj",conObj);
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
        action.setParams({contactObj : component.get("v.contactObj"),
                          authScore : authScore});
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                var conObj = response.getReturnValue();
                console.log('updated affinity score --> '+conObj.Authority__c);
                component.set("v.contactObj",conObj);
                component.set("v.isSpinnerLoad",false);
            }
            else{
                console.log('ERROR : unable to Update Contact..');
                component.set("v.isSpinnerLoad",false);
            }
        });
        $A.enqueueAction(action);
    }
})