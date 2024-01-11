/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 29-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   29-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
({
    loadModelData: function (component, helper) {
        let recordId = component.get("v.recordId");
        var loadModelAction = component.get("c.loadModel");
        loadModelAction.setParams({
            "recordId": recordId
        });
        loadModelAction.setCallback(this, function (response) {
            var status = response.getState();
            console.log("-----------status--------"+status);
            if (status === 'SUCCESS') {
                let model = response.getReturnValue();
                
                
                component.set("v.model", model);
                component.set("v.newmodel", model);//by satya
               /*added by satya*/
                var resp=component.get("v.model.bidProcessSteps");
                for(var i=0;i<resp.length;i++){
                    console.log("resp of i ==>"+JSON.stringify(resp[i]))
                    var maplist = resp[i].maplist;
                    if(maplist != null){
                 //console.log("-------model----"+JSON.stringify(maplist.values()));
                }
                    if(resp[i].bStep.Phoenix_Status__c == 'In Process'){
                        var approverTeam = JSON.stringify(resp[i].bStep.Phoenix_Approver_Team_Members__c);
                        //var usersList = resp[i].bStep.Phoenix_Approver__c;
                       
                        
                        component.set('v.approverTeam',approverTeam)
                    }
                }
               
                /*end by satya*/
                if(model.ndcChange != null)component.set("v.model.bid", model.ndcChange);
                else if(model.phsChange != null)component.set("v.model.bid", model.phsChange);
                    else if(model.newProductWACPricing != null)component.set("v.model.bid", model.newProductWACPricing);
                                   else if(model.wacChange != null)component.set("v.model.bid", model.wacChange);

                console.log(model.bid);
                //helper.getstatusforTeamMembers(component,event, helper)
            } else {
                console.log('----error---' + response.getError());
            }
        });
        $A.enqueueAction(loadModelAction);
       
    },
    getstatusforTeamMembers:function (component, helper){
        var resp=component.get("v.model.bidProcessSteps");
         for(var i=0;i<resp.length;i++){
                    var approverTeamMembers = JSON.stringify(resp[i].bStep.Phoenix_Approver_Team_Members__c)
                    
         }
    },
    lastBidVisit:function (component, event, helper,value){
        component.set('v.finalHoveMsg','')
    	let recordId = component.get("v.recordId");
        let userId = value;//component.get("v.userId");
        var action = component.get("c.getLastActivityDate");
        action.setParams
            ({
                "recordId": recordId,
                "userId" : userId,
            });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                    var resposneString =  response.getReturnValue();
                                   console.log('resposneString==>'+resposneString)
                                   var hoverMsg = 'Last visit of this Bid: '+resposneString;
                                   var lastloginTime = component.get("v.lastloginHoverMsg")
                                   var finalHoveMsg = lastloginTime +'\n' +hoverMsg;
                                   component.set('v.finalHoveMsg',finalHoveMsg)
                                   //component.set('v.lastActivityTime',hoverMsg);
                                   
                                   
                               }else{
                                   console.log('error in bidApproval')
                               }
                           });
                             $A.enqueueAction(action);
	}
   
})