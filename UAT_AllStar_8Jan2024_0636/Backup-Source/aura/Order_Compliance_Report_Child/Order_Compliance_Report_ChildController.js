({
        doInit : function(component, event, helper) {
            var singlerec = component.get("v.singlerec");
            console.log('singlerec====='+JSON.stringify(singlerec));
            
        },
        openModal: function(component, event, helper) {
             component.set("v.spinner",true);
            component.set("v.orderModalOpen",true);
            var ndcode = event.getSource().get("v.name");
            var soldtocustCode = event.getSource().get("v.value");
            console.log('ndcode: '+ndcode);
            console.log('soldtocustCode: '+soldtocustCode);
            
            
            var getBidInfoAction = component.get("c.getOrdersData");
            getBidInfoAction.setParams({
                customerId :component.get("v.recordId"),
                ndcCode :ndcode,
                soldtocustCode:soldtocustCode            
            });
            getBidInfoAction.setCallback(this, function (response) {
                var actState = response.getState();
                if (actState == 'SUCCESS') {
                   
                    var responseWrapper=response.getReturnValue();
                    console.log('responseWrapper.orderList====='+JSON.stringify(responseWrapper.orderList));
                    component.set('v.orderList',responseWrapper.orderList);
                    component.set('v.orderQty',responseWrapper.orderQty);
                    component.set('v.netValue',responseWrapper.netValue);
                    component.set('v.custName',responseWrapper.custName);
                     component.set('v.orderProdName',responseWrapper.orderProdName);
                    
                    component.set("v.spinner",false);
                    
                }
                else{
                    
                    console.log('errot---'+JSON.stringify(response.getError()));
                }
                
            });
            $A.enqueueAction(getBidInfoAction); 
            
        },
        closeModel: function(component, event, helper) {
            // Set isModalOpen attribute to true
            component.set("v.orderModalOpen", false);
            
        },
        handleClick1: function(component, event, helper){
            var pfName = event.getSource().get("v.name");
            console.log('pfName: '+pfName);
            var data = component.get("v.orderList");
            console.log('Data pfName:: '+JSON.stringify(data));
            data.forEach(function(item){
                console.log('soldToCustName before===='+item.soldToCustName)
                
                if(item.soldToCustName == pfName && item != undefined ){
                    console.log('soldToCustName===='+item.soldToCustName)
                    item.expandsolToCust = false;
                    //console.log('item===='+item)
                }
            });
            
            component.set("v.orderList", data);
            
        },
        handleClick2: function(component, event, helper){
            var pfName = event.getSource().get("v.name");
            console.log('pfName: '+pfName);
            var data = component.get("v.orderList");
            console.log('Data pfName:: '+JSON.stringify(data));
            data.forEach(function(item){
                console.log('soldToCustName before===='+item.soldToCustName)
                
                if(item.soldToCustName == pfName && item != undefined ){
                    console.log('soldToCustName===='+item.soldToCustName)
                    item.expandsolToCust = true;
                }
            });
            component.set("v.orderList", data);
            
        },
        handleClick3: function(component, event, helper){
            console.log('handleClick3')
            var pfName = event.getSource().get("v.name");
            var soldtocustName = event.getSource().get("v.value");
            
            console.log('pfName: '+pfName);
            var data = component.get("v.orderList");
            console.log('Data pfName:: '+JSON.stringify(data));
            data.forEach(function(item){
                var custName = item.uniqueKey;
                item.statusWrapperList.forEach(function(order){
                    console.log('custName===='+custName)
                    console.log('soldtocustName===='+soldtocustName)
                    if(custName == soldtocustName && order.status == pfName && order != undefined ){
                        order.expandStatus = false;
                        
                    }
                });
                
            });
            component.set("v.orderList", data);
            
        },
        handleClick4: function(component, event, helper){
            console.log('handleClick4')
            var pfName = event.getSource().get("v.name");
            var soldtocustName = event.getSource().get("v.value");
            console.log('pfName: '+pfName);
            var data = component.get("v.orderList");
            console.log('Data pfName:: '+JSON.stringify(data));
            data.forEach(function(item){
                var custName = item.uniqueKey;
                item.statusWrapperList.forEach(function(order){
                    console.log('custName===='+custName)
                    console.log('soldtocustName===='+soldtocustName)
                    if(custName == soldtocustName && order.status == pfName && order != undefined ){
                        order.expandStatus = true;                             
                        console.log('inside')
                        
                        
                    }
                });
                
            });
            
            component.set("v.orderList", data);
            
        },
        closeCommentPopup : function(component, event, helper){
            /* var compEvent = component.getEvent("refreshEvent");
            compEvent.setParams({
                "isRefreshRecs" : 'changeHeader',
                "gcpRec" : component.get("v.gcpLineItem"),
                "indexVal" : component.get("v.indexVal")
                
            });
            compEvent.fire();*/
              component.set("v.showComments",false);
          },
        onRecChange : function(component, event, helper){
            console.log('on record change method.. ');
            var nameofEditfield = event.getSource().get('v.name');
            var val = event.getSource().get('v.value');
            console.log('nameofEditfield :: '+nameofEditfield);
            console.log('value :: '+val);
            if(nameofEditfield == 'opptyProbChange'){
                component.set("v.gcpLineItem.Phoenix_Opportunity_Probability__c",val);
            }
            if(nameofEditfield == 'prodStatusChange'){
                component.set("v.gcpLineItem.Product_Status__c",val);
            }
            
            var action = component.get("c.updateGcpLineItem");
            action.setParams({
                gcpLineItem : component.get("v.gcpLineItem")
            });
            action.setCallback(this, function (response) {
                console.log('State from updateGcpLineItem :: '+response.getState());
                if (response.getState() == "SUCCESS") {
                    var gcpLineItem = response.getReturnValue();
                    component.set("v.gcpLineItem",gcpLineItem);
                    component.set("v.showSaveComntButton",false);
                    component.set("v.showComments",false);
                    if(nameofEditfield == 'prodStatusChange')
                        component.set("v.doRefresh",component.get("v.doRefresh")?false:true);
                    else{
                        var a = component.get('c.doInit');
                        $A.enqueueAction(a);
                    }
                }
                else {
                    console.log('Error while updating line Item.');
                }
            });
            $A.enqueueAction(action);
        },
        onSaveCmnt : function(component, event, helper){
            var cmnt = component.get("v.visionComment");
            if(component.get("v.selectedStatusVal") == 'Price Constraint' || component.get("v.selectedStatusVal") == 'Supply Constraint'){
                cmnt = component.get("v.selectedStatusVal")+': \n'+cmnt;
            }
            if(cmnt != undefined && cmnt != ''){
                var action = component.get("c.saveComment");
                action.setParams({
                    newComment : cmnt,
                    selectedLineId : component.get("v.singlerec.Id"),
                    Product : component.get("v.ProdIdForComment"),
                    Account : component.get("v.recordId")
                });
                action.setCallback(this, function (response) {
                    console.log('State from saveComment :: '+response.getState());
                    if (response.getState() == "SUCCESS") {
                        var respObj = response.getReturnValue();
                        if(respObj.isErrorFromServer){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "ERROR",
                                "message":''+respObj.errorMessageFromServer,
                                "type":"ERROR",
                                "mode":"dismissible"
                            });
                            toastEvent.fire();
                        }
                        else{
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Saved!",
                                "message":'Comment Added Successfully.',
                                "type":"SUCCESS",
                                "mode":"dismissible"
                            });
                            toastEvent.fire();
                            component.set("v.visionComment",'');
                            helper.getCommentsHelper(component, event, helper);
                        }
                    }
                    else {
                        console.log('Error while storing Comment.');
                    }
                });
                $A.enqueueAction(action);
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR",
                    "message":'Vision comments are not added.',
                    "type":"ERROR",
                    "mode":"dismissible"
                });
                toastEvent.fire();
            }
        },
        inlineEditComments : function(component, event, helper){
            //component.set("v.commentsEditMode",true);
            console.log('in inlineEditComments');
            component.set("v.showSaveComntButton",false);
            var val = event.getSource().get("v.value");
            console.log('valuee----'+val);   
            component.set("v.ProdIdForComment",val);
            helper.getCommentsHelper(component, event, helper);
        },
         showGraph: function(component, event, helper) {
             // Set isModalOpen attribute to true
              var pickList =  [];
                    var picklistValues = component.get("v.pickList");
                        component.set('v.selectedId',picklistValues[0].Id);   
                   var i = 1;
                    var newLine = 1;
                    picklistValues.forEach(function(user){
                        var isNewLine = false;
                        if(newLine == 5){
                            isNewLine = true;
                            newLine =1;
                        }
                        pickList.push({userId:''+user.value,userName:''+user.label,isSelected: i==1?true:false,isNewLine:isNewLine});
                        i++;
                        newLine++;
                    });
                    component.set("v.pickList",pickList);
             console.log("selectedId===",component.get("v.selectedId"));
             if(component.get("v.selectedId") == undefined) {
               component.set("v.selectedId",'12Month');  
             }
              console.log("selectedId===",component.get("v.selectedId"));
             component.set("v.showGraph", true);
             var ndcode = event.getSource().get("v.name");
             var soldtocustCode = event.getSource().get("v.value");
             component.set('v.graphProductCode',ndcode);
             component.set('v.graphSoldToCust',soldtocustCode);
             
        
        },
          onSelectUser : function(component, event, helper){
         
            var selectedId =  event.currentTarget.dataset.id;//event.getSource().get("v.name");
            component.set('v.selectedId',selectedId);
            var listOfusers = component.get("v.pickList");
            listOfusers.forEach(function(user){
                if(user.userId == selectedId){
                    user.isSelected = true;
                }
                else{
                    user.isSelected = false;
                }
            });
            component.set("v.pickList",listOfusers);
                       console.log("selectedId onselect===",component.get("v.selectedId"));
    
           
        },
         closegraphModel: function(component, event, helper) {
            // Set isModalOpen attribute to true
            component.set("v.showGraph", false);
             var pickList = [ {'label': '12 Months', 'value': '12Month'},
                                                            {'label': '6 Months', 'value': '6Month'},
                                                            {'label': '3 Months', 'value': '3Month'},
                                                            ];
                              component.set("v.pickList",pickList);
           component.set("v.selectedId",'12Month'); 
        },
    })