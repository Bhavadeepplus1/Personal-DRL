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
    doInit: function (component, event, helper) {
        var getuser = component.get("c.getuser");
        getuser.setCallback(this, function (response) {
            var status = response.getState();
            if (status === 'SUCCESS') {
                let resp = response.getReturnValue();
                console.log('user id==>'+resp)
                component.set('v.userId',resp);
            }else {
                console.log('----error---' + response.getError());
            }
        });
        $A.enqueueAction(getuser);
        
        helper.loadModelData(component, helper);
    },
    toggleSection: function (component, event, helper) {
        
        // dynamically get aura:id name from 'data-auraId' attribute
        var sectionAuraId = event.target.getAttribute("data-auraId");
        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        /* The search() method searches for 'slds-is-open' class, and returns the position of the match.
         * This method returns -1 if no match is found.
         */
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        
        // -1 if 'slds-is-open' class is missing...then set 'slds-is-open' class else set slds-is-close class to element
        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
        }
    },
    mouseOver:function (component, event, helper){
        var clickedCell = event.currentTarget;
         // Retrieve the value from the data-value attribute
    var value = clickedCell.dataset.value;

    // Do something with the value
    console.log('clicked value==>'+value);
        var inProcessUsersList =[];
        for(var i=0;i<component.find("test").length;i++){
            console.log('td value==>'+ component.find("test")[i].get("v.value"))
            inProcessUsersList.push(component.find("test")[i].get("v.value"));
        }
        console.log('inProcessUsersList'+ inProcessUsersList)
        component.set("v.inProcessUsersList",inProcessUsersList);
        let recordId = component.get("v.recordId");
        let userId = value;//component.get("v.userId");
        var action = component.get("c.getLastActivityDate");
         action.setParams
            ({
                "recordId": recordId,
                "userId" : userId,
                "inProcessUsersList" : inProcessUsersList
            });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                    var resposneString =  response.getReturnValue();
                                   console.log('resposneString==>'+resposneString)
                                   var hoverMsg = 'Last Visted Time: '+resposneString;
                                   
                                   component.set('v.lastActivityTime',hoverMsg);
                                   
                                   
                               }else{
                                   console.log('error in bidApproval')
                               }
                           });
                             $A.enqueueAction(action);
    },
    mouseOveronTeam:function (component, event, helper){
         let recordId = component.get("v.recordId");
        let userId = component.get("v.userId");
        let approverTeam = component.get("v.approverTeam");
        console.log('v.model.bidProcessSteps==>'+component.get("v.approverTeam"))
        var action = component.get("c.getLastActivityDateforTeam");
         action.setParams
            ({
                "recordId": recordId,
                "userId" : userId,
                "approverTeam" :approverTeam
            });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                    var response =  response.getReturnValue();
                                   console.log('resposneString1==>'+JSON.stringify(response))
                                   var finalList=[];
                                  
                                   for(var i=0;i<response.length;i++){
                                        finalList.push(response[i].recList[0])
                                   }
                                   console.log('finalList length==>'+finalList.length)
                                    var hoverList =[];
                                   for(var i=0;i<finalList.length;i++){
                                       
                                   //finalList.forEach(function(rec){
                                      	let convertdateTime =finalList[i].Test__c;
                                         let userName = finalList[i].Logged_in_User__c;
                                         let concatstring = userName.concat(' : ');
                                          let fullString = concatstring.concat(convertdateTime);
                                       //fullString.replaceAll('"', '');  
                                     
                                       hoverList.push(fullString)
                                            //hoverList.push({User:userName} ,{ LastVisitedTime :convertdateTime})
                                             
                                       
                                   //});
                                   }
                                   console.log('hoverList length'+hoverList.length)
                                  var hoverMsg3='';
                                   for(var i=0;i<hoverList.length;i++){
                                     var  hoverMsg2 = hoverMsg3.concat(hoverList[i]);
                                       hoverMsg3 = hoverMsg2.concat(',')
                                      
                                   }
                                    console.log('each string==>'+hoverMsg2);
                                  // var hoverMsg2 = JSON.stringify(hoverList);
                                    component.set('v.lastActivityTime2',hoverMsg3);
                                  console.log('finalList'+JSON.stringify(finalList));
                                   let str = "Hello World!\nThis is my string";
                                   
                                   console.log('str'+str);
                                   
                               }else{
                                   console.log('error in bidApproval')
                               }
                           });
                             $A.enqueueAction(action);
    },
    mouseOveronTeamCustomer:function (component, event, helper){
    let recordId = component.get("v.recordId");
        let userId = component.get("v.userId");
        let approverTeam = component.get("v.approverTeam");
        console.log('v.model.bidProcessSteps==>'+component.get("v.approverTeam"))
        var action = component.get("c.getLastActivityDateforCusUpdateTeam");
         action.setParams
            ({
                "recordId": recordId,
                "userId" : userId,
                "approverTeam" :approverTeam
            });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                    var response =  response.getReturnValue();
                                   console.log('resposneString==>'+JSON.stringify(response))
                                   var finalList=[];
                                  
                                   for(var i=0;i<response.length;i++){
                                        finalList.push(response[i].recList[0])
                                   }
                                   console.log('finalList length==>'+finalList.length)
                                   var hoverList ='Approvers who visited the Bid: '+'\n'
                                   for(var i=0;i<finalList.length;i++){
                                      /*	let convertdateTime =finalList[i].Test__c;
                                         let userName = finalList[i].Logged_in_User__c;
                                         let concatstring = userName.concat(' , ');
                                          let fullString = concatstring.concat(convertdateTime);
                                       hoverList.push(fullString)*/
                                       hoverList = hoverList +finalList[i].Logged_in_User__c+'\n';
                              
                                   }
                                  
                                  // var hoverMsg2 = //JSON.stringify(hoverList);
                                    component.set('v.lastActivityTime2',hoverList);
                                  console.log('finalList'+JSON.stringify(finalList));
                                   let str = "Hello World!\nThis is my string";
                                   
                                   console.log('str'+str);
                                   
                               }else{
                                   console.log('error in bidApproval')
                               }
                           });
                             $A.enqueueAction(action);
},
    getstatusforTeamMem:function (component, event, helper){
        //console.log('testingggg')
       var clickedCell = event.currentTarget;
        // Retrieve the value from the data-value attribute
        var value = clickedCell.dataset.value;
        
        // Do something with the value
       
        var getstatusforTeamMembers = component.get("c.getstatusforTeam");
        var approverTeam = JSON.stringify(value)
        component.set('v.approverTeamMembers',approverTeam)
         console.log('approverTeamMembers'+component.get("v.approverTeamMembers"));
        getstatusforTeamMembers.setParams({
            "approverTeam": component.get("v.approverTeamMembers")
        });
       
        getstatusforTeamMembers.setCallback(this, function (response) {
            var status = response.getState();
            if (status === 'SUCCESS') {
                component.set("v.teamApprovers",'')
                let resp = response.getReturnValue();
                console.log('team members resp---' + JSON.stringify(resp));
                var onlineTeam =[];
                for(var i=0;i<resp.length;i++){
                    onlineTeam.push(resp[i].approverName)
                   
                }
                //onlineTeam.push('sri');
                // onlineTeam.push('satya');
                let  string =component.get("v.teamApprovers");
                for(var i=0;i<onlineTeam.length;i++){
                   // let string3 = string2 != undefined ? string2 : '';
                   // let string4 = string1 + '\n'+ string3;
                    string = string + '\n' + onlineTeam[i];
                      console.log('string' + JSON.stringify(string));
                    component.set("v.teamApprovers",string)
                     
                }
                
               
                   
                 
                //onlineTeam.prototype.replaceAll('[', '');
               
				
            }else{
                console.log('----error---' + response.getError());
            }
        });
          $A.enqueueAction(getstatusforTeamMembers);
       
    },
    showLastLoggedIn:function (component, event, helper){
   var clickedCell = event.currentTarget;
    // Retrieve the value from the data-value attribute
    var value = clickedCell.dataset.value;
    console.log(value);
     var showLastLoggedIn = component.get("c.getLastLoggedIn");
        showLastLoggedIn.setParams({
            "approverName": value
        });
        showLastLoggedIn.setCallback(this, function (response) {
             var status = response.getState();
            console.log('status===> in last'+status)
             if (status === 'SUCCESS') {
                 let lastloginTime = response.getReturnValue();
                 console.log('success in showLastLoggedIn==>'+lastloginTime) 
                  var lastloginHoverMsg = 'Last BRIGHT log in: '+lastloginTime;
                
                 component.set('v.lastloginHoverMsg',lastloginHoverMsg)
                 helper.lastBidVisit(component, event, helper,value);
				              
             }else{
                console.log('----error in last bright login---' + response.getError());
             }
        });
         $A.enqueueAction(showLastLoggedIn);
    
}
})