/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 30-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   30-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
({
    doInit: function (component, event, helper) {
        helper.getScmData(component, event, helper);
    },
    onClose: function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),

        });
        navEvt.fire();
    },
    /*  onScmApprovalChange: function (component, event, helper){
            component.set("v.isClicked", true);
           var recordId = event.getSource().get('v.name');
           var val = event.getSource().get('v.value');
           var title = event.getSource().get('v.title');
           console.log('currentRecordID---->'+recordId);
          let auraIds = component.find('comment');
          if(auraIds != null && auraIds.length > 0){
              component.find("comment").forEach(function(eachInput){
                  if(eachInput.get("v.name") == recordId){
                      if(val == 'Y- Only Current Monthly Demand Approved'){
                          eachInput.set("v.value", '0');
                      }else if(val == 'Y- Current + Inc Demand Approved'){
                          eachInput.set("v.value", '100');
                         
                      }else{
                          eachInput.set("v.value",null);
                      }
                      
                  }
               });
              var fieldList = new Map();
              var bidLinesMap = component.get("v.SCMApprovalQtyMap") != null ? component.get("v.SCMApprovalQtyMap") : new Map();
              fieldList['SCM Approved % Quantity'] = val == 'Y- Only Current Monthly Demand Approved' ? '0' : val == 'Y- Current + Inc Demand Approved' ? '100' : 'notValid';
              if(!bidLinesMap.has(recordId)){
                  bidLinesMap[recordId] = fieldList;
              }else{
                  if(fieldList.has('SCM Approved % Quantity')){
                      fieldList.delete('SCM Approved % Quantity');
                      bidLinesMap[recordId] = fieldList;
                  }else{
                      bidLinesMap[recordId] = fieldList;
                  }
              }
              component.set("v.SCMApprovalQtyMap", bidLinesMap);
              console.log('SCMApprovalQtyMap---->'+JSON.stringify(bidLinesMap));
              
          } 
          
           var fieldList = new Map();
           var bidLinesMap = component.get("v.SCMApprovalMap") != null ? component.get("v.SCMApprovalMap") : new Map();
           fieldList[title] = val;
           if(!bidLinesMap.has(recordId)){
               bidLinesMap[recordId] = fieldList;
           }else{
               if(fieldList.has(title)){
                   fieldList.delete(title);
                   bidLinesMap[recordId] = fieldList;
               }else{
                   bidLinesMap[recordId] = fieldList;
               }
           }
           component.set("v.SCMApprovalMap", bidLinesMap);
           console.log('SCMApprovalMap---->'+JSON.stringify(bidLinesMap));
          
           
       },*/
    /*  onestimatedTime: function (component, event, helper){
           component.set("v.isClicked", true);
          var recordId = event.getSource().get('v.name');
          var val = event.getSource().get('v.value');
          var title = event.getSource().get('v.title');
          console.log('currentRecordID---->'+recordId);
          var fieldList = new Map();
          var bidLinesMap = component.get("v.EstimatedDaysMap") != null ? component.get("v.EstimatedDaysMap") : new Map();
          fieldList[title] = val;
          if(!bidLinesMap.has(recordId)){
              bidLinesMap[recordId] = fieldList;
          }else{
              if(fieldList.has(title)){
                  fieldList.delete(title);
                  bidLinesMap[recordId] = fieldList;
              }else{
                  bidLinesMap[recordId] = fieldList;
              }
          }
          component.set("v.EstimatedDaysMap", bidLinesMap);
          console.log('EstimatedDaysMap---->'+JSON.stringify(bidLinesMap));
         
          
      },*/
    /* onscmrejectionReasonChange : function (component, event, helper){
          component.set("v.isClicked", true);
         var recordId = event.getSource().get('v.name');
         var val = event.getSource().get('v.value');
         var title = event.getSource().get('v.title');
         console.log('currentRecordID---->'+recordId);
         var fieldList = new Map();
         var bidLinesMap = component.get("v.SCMReJMap") != null ? component.get("v.SCMReJMap") : new Map();
         fieldList[title] = val;
         if(!bidLinesMap.has(recordId)){
             bidLinesMap[recordId] = fieldList;
         }else{
             if(fieldList.has(title)){
                 fieldList.delete(title);
                 bidLinesMap[recordId] = fieldList;
             }else{
                 bidLinesMap[recordId] = fieldList;
             }
         }
         component.set("v.SCMReJMap", bidLinesMap);
         console.log('SCMReJMap---->'+JSON.stringify(bidLinesMap));
        
         
     },*/
    /* onScmCommentChange : function (component, event, helper){
          component.set("v.isClicked", true);
         var recordId = event.getSource().get('v.name');
         var val = event.getSource().get('v.value');
         var title = event.getSource().get('v.title');
         console.log('currentRecordID---->'+recordId);
         var fieldList = new Map();
         var bidLinesMap = component.get("v.SCMCommentsMap") != null ? component.get("v.SCMCommentsMap") : new Map();
         fieldList[title] = val;
         if(!bidLinesMap.has(recordId)){
             bidLinesMap[recordId] = fieldList;
         }else{
             if(fieldList.has(title)){
                 fieldList.delete(title);
                 bidLinesMap[recordId] = fieldList;
             }else{
                 bidLinesMap[recordId] = fieldList;
             }
         }
         component.set("v.SCMCommentsMap", bidLinesMap);
         console.log('SCMCommentsMap---->'+JSON.stringify(bidLinesMap));
        
         
     },*/
    /*  onscmAprQtyPercent : function (component, event, helper){
           component.set("v.isClicked", true);
          var recordId = event.getSource().get('v.name');
          var val = event.getSource().get('v.value');
          var title = event.getSource().get('v.title');
          console.log('currentRecordID---->'+recordId);
          var fieldList = new Map();
          var bidLinesMap = component.get("v.SCMApprovalQtyMap") != null ? component.get("v.SCMApprovalQtyMap") : new Map();
          fieldList[title] = val;
          if(!bidLinesMap.has(recordId)){
              bidLinesMap[recordId] = fieldList;
          }else{
              if(fieldList.has(title)){
                  fieldList.delete(title);
                  bidLinesMap[recordId] = fieldList;
              }else{
                  bidLinesMap[recordId] = fieldList;
              }
          }
          component.set("v.SCMApprovalQtyMap", bidLinesMap);
          console.log('SCMApprovalQtyMap---->'+JSON.stringify(bidLinesMap));
         
          
      },*/
    onInitialVolumeChange: function (component, event, helper) {
        component.set("v.isClicked", true);
        var recordId = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        var title = event.getSource().get('v.title');
        console.log('currentRecordID---->' + recordId);
        var fieldList = new Map();
        var bidLinesMap = component.get("v.initailOrderVolumeMap") != null ? component.get("v.initailOrderVolumeMap") : new Map();
        fieldList[title] = val;
        if (!bidLinesMap.has(recordId)) {
            bidLinesMap[recordId] = fieldList;
        } else {
            if (fieldList.has(title)) {
                fieldList.delete(title);
                bidLinesMap[recordId] = fieldList;
            } else {
                bidLinesMap[recordId] = fieldList;
            }
        }
        component.set("v.initailOrderVolumeMap", bidLinesMap);
        console.log('SCMApprovalQtyMap---->' + JSON.stringify(bidLinesMap));


    },
    onInitialCommentChange: function (component, event, helper) {
        component.set("v.isClicked", true);
        var recordId = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        var title = event.getSource().get('v.title');
        console.log('currentRecordID---->' + recordId);
        var fieldList = new Map();
        var bidLinesMap = component.get("v.initailOrderCommentsMap") != null ? component.get("v.initailOrderCommentsMap") : new Map();
        fieldList[title] = val;
        if (!bidLinesMap.has(recordId)) {
            bidLinesMap[recordId] = fieldList;
        } else {
            if (fieldList.has(title)) {
                fieldList.delete(title);
                bidLinesMap[recordId] = fieldList;
            } else {
                bidLinesMap[recordId] = fieldList;
            }
        }
        component.set("v.initailOrderCommentsMap", bidLinesMap);
        console.log('SCMApprovalQtyMap---->' + JSON.stringify(bidLinesMap));


    },

    saveClick: function (component, event, helper) {
        component.set("v.isSpinnerLoad", true);
        var action = component.get("c.updateLineItems");
        var scmApproval;
        var scmApprovaltype = component.find("headerSCMApproval");
        if (scmApprovaltype != null) {
            scmApproval = scmApprovaltype.get("v.value");
        } else {
            scmApproval = '';
        }

        action.setParams({
            bidId: component.get("v.recordId"),
            scmApprovalMap: component.get("v.SCMApprovalMap"),
            scmApprovalQtyMap: component.get("v.SCMApprovalQtyMap"),
            estimatedDaysMap: component.get("v.EstimatedDaysMap"),
            scmRejReason: component.get("v.SCMReJMap"),
            scmCommentsMap: component.get("v.SCMCommentsMap"),
            initialVolumeMap: component.get("v.initailOrderVolumeMap"),
            initialCommentsMap: component.get("v.initailOrderCommentsMap"),
            scmApproval: scmApproval,
            isSCMApproved: component.get("v.isSCMApproved")



        });
        action.setCallback(this, function (response) {
            if (response.getState() === 'SUCCESS') {
                var dataList = response.getReturnValue();
                component.set("v.scmData", dataList);
                var toastEvent = $A.get("e.force:showToast");
                component.set("v.isSpinnerLoad", false);
                component.set("v.isClicked", false);
                component.set("v.SCMApprovalMap", null),
                    component.set("v.SCMApprovalQtyMap", null),
                    component.set("v.EstimatedDaysMap", null),
                    component.set("v.SCMReJMap", null),
                    component.set("v.SCMCommentsMap", null)
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Record Updated Successfully."
                });
                toastEvent.fire();
            }


        });
        $A.enqueueAction(action);

    },
    onApprovalSubmit: function (component, event, helper) {
        var listOfItems = component.get("v.scmData");
        console.log('scmData-->' + JSON.stringify(listOfItems));
        console.log('firstApproval--->' + listOfItems[0])
        var isApproved = false;
        listOfItems.forEach(function (line) {
            if (line.scmApproval == 'None' || line.scmApproval == '' || line.scmApproval == null) {
                isApproved = true;
                console.log("scmApproval--->" + line.scmApproval)
            }
        });

        if (isApproved == true) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "warning",
                "title": "Failed!",
                "message": "Please confirm each approval to proceed further"
            });
            toastEvent.fire();
        } else {
            var action = component.get("c.makeApprovals");
            action.setParams({
                bidId: component.get("v.recordId")
            });
            action.setCallback(this, function (response) {
                if (response.getState() === "SUCCESS") {
                    helper.getScmData(component, event, helper);
                }
            });
            $A.enqueueAction(action);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "success",
                "title": "Success",
                "message": "Your Approvals are submitted successfully."
            });
            toastEvent.fire();
        }

    },
    refreshSCM: function (component, event, helper) {
        /* component.set("v.SCMApprovalMap",null);
         component.set("v.SCMApprovalQtyMap",null);
         component.set("v.EstimatedDaysMap",null);
         component.set("v.SCMReJMap",null);
         component.set("v.SCMCommentsMap",null);
         component.set("v.initailOrderVolumeMap",null);
         component.set("v.initailOrderVolumeMap",null);*/
        helper.getScmData(component, event, helper);
    },
    onApprovalChange: function (component, event, helper) {
        component.set("v.isClicked", true);
        component.set("v.isSCMApproved", true);
        var val = event.getSource().get('v.value');
        let auraIds = [];
        auraIds = component.find('comment');
        let approvalIds = [];
        approvalIds = component.find('scmApprovalselect');
        if (component.get("v.scmData").length == 1 && auraIds.length == 'undefined') {
            if (val == 'Y- Only Current Monthly Demand Approved') {
                auraIds.set("v.value", '0');
            } else if (val == 'N- Not Approved') {
                auraIds.set("v.value", null);
            } else {
                auraIds.set("v.value", '100');

            }
            approvalIds.set("v.value", val);

        }
        if ((val == 'Y- Only Current Monthly Demand Approved' || val == 'Y- Current + Inc Demand Approved' || val == 'N- Not Approved') && auraIds != null && auraIds.length > 0) {
            console.log('inside the headerApproval')
            component.find("comment").forEach(function (eachInput) {
                if (val == 'Y- Only Current Monthly Demand Approved') {
                    eachInput.set("v.value", '0');
                } else if (val == 'N- Not Approved') {
                    eachInput.set("v.value", null);
                } else {
                    eachInput.set("v.value", '100');

                }


            });
        }
        if (approvalIds != null && approvalIds.length > 0) {
            approvalIds.forEach(function (eachInput) {
                eachInput.set("v.value", val);
            });
        }


    },

    downloadCsv: function (component, event, helper) {

        var ResultData = component.get("v.scmData");
        var template = component.get("v.templateType");
        var bid = component.get("v.bidNumber");
        /*var est=component.get("v.recordId");
        console.log("est---->"+est);*/
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component, ResultData, template);
        if (csv == null) {
            return;
        }

        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; //      
        var date = new Date();
        var hours = date.getHours();
        var minutes = date.getMinutes();
        var newformat = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12;
        hours = hours ? hours : 12;
        minutes = minutes < 10 ? '0' + minutes : minutes;
        var Now = (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear() + ' ' + hours + ':' + minutes + ' ' + newformat;
        hiddenElement.download = 'SCM Data List' + '-' + Now + '.csv'; // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    }
})