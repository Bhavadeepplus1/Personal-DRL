({
    doInit : function(component, event, helper){
        var LineItemtable = component.find("headerTable");
        component.set("v.tableRef",LineItemtable);
        var ndcList = component.get("v.ndcList");
        var newNdcList = [];
        ndcList.forEach(function(obj){
            if(obj.Vision_Probability__c == undefined || obj.Vision_Probability__c == '')
                obj.Vision_Probability__c = 'None';
            console.log('isInclude ->'+obj.Vision_isIncludeProduct__c);
            newNdcList.push(obj);
        });
        component.set("v.ndcList",newNdcList);
        component.set("v.actualList",newNdcList);
    },
	closeSkuView : function(component, event, helper) {
		component.set("v.showProducts",false);
	},
    
    prodSelected : function(component, event, helper){
        var ndcList = component.get("v.ndcList");
        var selectedProdList = component.get("v.selectedNdcs");
        ndcList.forEach(function(ndcObj){
            if(ndcObj.isSelectedPrd && !selectedProdList.includes(ndcObj.Vision_Product__c)){
                selectedProdList.push(ndcObj.Vision_Product__c);
                //selectedProdListSize++;
            }
            else if(selectedProdList.includes(ndcObj.Vision_Product__c) && !ndcObj.isSelectedPrd){
                var index = selectedProdList.indexOf(ndcObj.Vision_Product__c);
                selectedProdList.splice(index, 1);
            }
        });
        var appEvent = $A.get("e.c:Vision_ProdSelectionEvent100P"); 
        appEvent.setParams({"selectedNdcs" : selectedProdList}); 
        appEvent.fire(); 
    },
    savePercentageROS : function(component, event, helper){
        component.set("v.disableSave",true);
        var gcpLineItem = component.get("v.gcpLineItem");
        var totalPer = parseInt(gcpLineItem.Vision_Major_VolShare_Percent__c) + parseInt(gcpLineItem.Vision_Cardinal_VolShare_Percent__c) + parseInt(gcpLineItem.Vision_CVS_VolShare_Percent__c);
        var message = '';
        if(totalPer != 100){
            if(totalPer > 100)
                message = 'Overall percentage can not be more than 100%.';
            else
                message = 'Overall percentage is less than 100%. Please check again.';
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR",
                "message": message,
                "type":"ERROR",
                "mode":"dismissible"
            });
            toastEvent.fire();
            component.set("v.disableSave",false);
        }
        else{
            var action = component.get("c.updateMemberVolShare");
            action.setParams({
                gcpLineItem : component.get("v.gcpLineItem"),
                gcpNdcList : component.get("v.ndcList")
            });
            action.setCallback(this, function (response) {
                console.log('State from updateMem --- > '+response.getState());
                if (response.getState() === "SUCCESS") {
                    component.set("v.ndcList",response.getReturnValue());
                    component.set("v.isSpinnerLoad",false);
                    component.set("v.disableSave",false);
                }
                else{
                    console.log('ERROR --- > '+JSON.stringify(response.getError()));
                    component.set("v.disableSave",false);
                }
            });
            $A.enqueueAction(action);
        }
    },
    updateSharedVols : function(component, event, helper){
        if(component.get("v.accObj").AccountNumber == '153363'){
            //var delay = 1500;
            //var timer = component.get('v.timer');
            //clearTimeout(timer);
            //timer = setTimeout(function(){
                var ndcList = component.get("v.ndcList");
                var updatedList = [];
                ndcList.forEach(function(item){
                    
                    item.Vision_McKesson_Vol__c = item.Vision_McKesson_Vol__c != undefined ? item.Vision_McKesson_Vol__c : 0;
                    item.Vision_Rite_Aid_Vol__c = item.Vision_Rite_Aid_Vol__c != undefined ? item.Vision_Rite_Aid_Vol__c : 0;
                    item.Vision_WalMart_Vol__c = item.Vision_WalMart_Vol__c != undefined ? item.Vision_WalMart_Vol__c : 0;
                    item.Vision_NorthStar_Vol__c = item.Vision_NorthStar_Vol__c != undefined ? item.Vision_NorthStar_Vol__c : 0;
                    var totalVolume = parseInt(item.Vision_McKesson_Vol__c) + parseInt(item.Vision_Rite_Aid_Vol__c) + parseInt(item.Vision_WalMart_Vol__c) + parseInt(item.Vision_NorthStar_Vol__c);
                    item.Vision_Estimate_Account_Total_Vol_EU__c = totalVolume;
                    item.Vision_McKesson_Vol_Share__c = (item.Vision_McKesson_Vol__c/totalVolume)*100;
                    item.Vision_Rite_Aid_Vol_Share__c = (item.Vision_Rite_Aid_Vol__c/totalVolume)*100;
                    item.Vision_WalMart_Vol_Share__c = (item.Vision_WalMart_Vol__c/totalVolume)*100;
                    item.Vision_NorthStar_Vol_Share__c = (item.Vision_NorthStar_Vol__c/totalVolume)*100;
                    updatedList.push(item);
                });
                component.set("v.ndcList",updatedList);
                //clearTimeout(timer);
                //component.set('v.timer', null);
            //}, delay);
            //component.set('v.timer', timer);
        }
        else if(component.get("v.accObj").Name == 'Red Oak Sourcing'){
            var delay = 1500;
            var timer = component.get('v.timer');
            clearTimeout(timer);
            timer = setTimeout(function(){
                var ndcList = component.get("v.ndcList");
                var updatedList = [];
                //var message = '';
                ndcList.forEach(function(item){
                    var totalVol = 0;
                    if(item.Vision_Estimate_Vol_Method__c != 'User Input')
                        totalVol = item.Vision_Estimate_Account_Total_Vol_EU__c;
                    else
                        totalVol = item.Vision_User_Input_Estimate_Vol__c;
                    /*var totalPer = parseInt(item.Vision_Major_VolShare_Percent__c) + parseInt(item.Vision_Cardinal_VolShare_Percent__c) + parseInt(item.Vision_CVS_VolShare_Percent__c);
            if(totalPer != 100 && totalPer != 0){
                if(totalPer > 100)
                    message = item.Vision_Product__r.Name+' percentage can not be more than 100%.';
                else
                    message = item.Vision_Product__r.Name+' percentage is less than 100%. Please check again.';
            }
            else{*/
                    item.Vision_Major_Share_Vol__c = (item.Vision_Major_VolShare_Percent__c*totalVol)/100;//*item.Vision_Product__r.Phoenix_Pkg_Size__c
                    item.Vision_CVS_Share_Vol__c = (item.Vision_CVS_VolShare_Percent__c*totalVol)/100;
                    item.Vision_Cardinal_Share_Vol__c = (item.Vision_Cardinal_VolShare_Percent__c*totalVol)/100;
                    updatedList.push(item);
                    //}
                });
                /*if(message != ''){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR",
                    "message": message,
                    "type":"ERROR",
                    "mode":"dismissible"
                });
                toastEvent.fire();
                component.set("v.disableSave",false);
            }
            else*/
                component.set("v.ndcList",updatedList);
                clearTimeout(timer);
                component.set('v.timer', null);
            }, delay);
            component.set('v.timer', timer);
        }
    },
    updateMemberVolume : function(component, event, helper){
        
    },
    saveNDCvalues : function(component, event, helper){
        component.set("v.disableSave",true);
        var ndcList = component.get("v.ndcList");
        var action=component.get("c.updateNdcLineItemForROS");
        action.setParams({ndcItem:ndcList,isModifiedDateUpdated:component.get("v.isModifiedDateUpdated")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                console.log('UPDATED SUCCESSFULLY!');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Updated!",
                    "message": 'SKUs updated successfully!',
                    "type":"SUCCESS",
                    "mode":"dismissible"
                });
                toastEvent.fire();
                component.set("v.ndcList",response.getReturnValue() );
                component.set("v.disableSave",false);
                component.set("v.getUpdatedGcpItem",true);
            }
            else{
                console.log('ERROR from updateNdcLineItem --> '+JSON.stringify(response.getError()));
                component.set("v.disableSave",false);
            }
        });
        $A.enqueueAction(action);
    },
    inlineEditComments : function(component, event, helper){
        var index = event.currentTarget.id;  
        component.set("v.commentIndex",index);
    },
    probabilityUpdated : function(component, event, helper){
        var selectedVal = event.getSource().get('v.value');
        console.log('selectedVal ---> '+selectedVal);
        if(selectedVal.includes('~')){
            var selectedNdcRow = selectedVal.split('~')[0];
            var selectedStatusValue = selectedVal.split('~')[1];
            var ndcList = component.get("v.ndcList");
            var selectedItem = ndcList[selectedNdcRow];
            selectedItem.Vision_Probability__c = selectedStatusValue;
            ndcList[selectedNdcRow] = selectedItem;
            component.set("v.ndcList",ndcList);
            //if(!component.get("v.accObj").Vision_is_SRx_Account__c)
            //helper.updateNdcItem(component, event, helper, ndcList);
        }
    },
    
    openAlertForNdc : function(component, event, helper){
        var selectedNdcId = event.target.dataset.recordId;
        console.log('selectedNdcId ---> '+selectedNdcId);
        component.set("v.alertedItemType",'ndcItem');
        component.set("v.alertedNdcId",selectedNdcId);
        component.set("v.selectedRecIdForAlert",selectedNdcId);
        component.set("v.isModalOpen", true);
    },
    
    openAwardedPositions : function(component, event, helper){
        component.set("v.isSpinnerLoad",true);
        component.set("v.showProducts",false);
        var selectedNdcId = event.target.dataset.recordId;
        component.set("v.prodPositionIndex",selectedNdcId);
    },
    
    onProdStatusChange : function(component, event, helper){
        var val = event.getSource().get('v.value');
        
        if(val == 'Price Constraint' || val == 'Supply Constraint'){
            component.set("v.selectedStatusVal",val);
            component.set("v.sendDataConfirm",true);
        }
        else{
            //(val == 'Not An Opportunity' || val == 'True Opportunity' || ){
            component.set("v.isSpinnerLoad",true);
            component.set("v.gcpLineItem.Product_Status__c",val);
            var action = component.get("c.updateGcpLineItem");
            action.setParams({
                gcpLineItem : component.get("v.gcpLineItem")
            });
            action.setCallback(this, function (response) {
                console.log('State from updateGcpLineItem :: '+response.getState());
                if (response.getState() == "SUCCESS") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Product Status Updated!",
                        "message":'Please Enter Your Comments.',
                        "type":"SUCCESS",
                        "mode":"dismissible"
                    });
                    toastEvent.fire();
                    var gcpLineItem = response.getReturnValue();
                    if(gcpLineItem.Product_Status__c == 'True Opportunity'){
                        component.set("v.createOptyColor",'showGreen');
                    }
                    else if(gcpLineItem.Product_Status__c == 'Not An Opportunity'){
                        component.set("v.createOptyColor",'showBlack');
                    }
                        else if(gcpLineItem.Product_Status__c == 'Price Constraint'){
                            component.set("v.createOptyColor",'showRed');
                        }
                            else if(gcpLineItem.Product_Status__c == 'Supply Constraint' ){
                                component.set("v.createOptyColor",'showBabyPink');
                            }
                                else if(gcpLineItem.Product_Status__c == 'Awarded'){
                                    component.set("v.createOptyColor",'showPink');
                                }
                                    else if(gcpLineItem.Product_Status__c == 'In Bid'){
                                        component.set("v.createOptyColor",'showOrange');
                                    }
                    component.set("v.gcpLineItem",gcpLineItem);
                    component.set("v.isSpinnerLoad",false);
                    
                    if(val == 'Not An Opportunity'){
                        helper.getCommentsHelper(component, event, helper);
                    }
                    else{
                        var compEvent = component.getEvent("refreshEvent");
                        compEvent.setParams({
                            "isRefreshRecs" : 'changeHeader',
                            "gcpRec" : gcpLineItem,
                            "indexVal" : component.get("v.indexVal")                            
                        });
                        compEvent.fire();
                    }
                }
                else {
                    console.log('Error while updating line Item.');
                }
            });
            $A.enqueueAction(action);
            
        }
    },
    constraintUpdated : function(component, event, helper){
        var selectedVal = event.getSource().get('v.value');
        console.log('selectedVal ---> '+selectedVal);
        if(selectedVal.includes('~')){
            var selectedNdcRow = selectedVal.split('~')[0];
            var selectedStatusValue = selectedVal.split('~')[1];
            var ndcList = component.get("v.ndcList");
            var selectedItem = ndcList[selectedNdcRow];
            //if(component.get("v.accObj").Vision_is_SRx_Account__c)
              //  selectedItem.Vision_Product_Status__c = selectedStatusValue;
              //  else
                    selectedItem.Vision_Product_Constraint__c = selectedStatusValue;
            ndcList[selectedNdcRow] = selectedItem;
            component.set("v.ndcList",ndcList);
            //if(!component.get("v.accObj").Vision_is_SRx_Account__c)
            //helper.updateNdcItem(component, event, helper, ndcList);
        }
    },
    updateSrxSharedPercent : function(component, event, helper){
        var ndcList = component.get("v.ndcList");
        var updatedList = [];
        ndcList.forEach(function(item){
            item.Vision_SRx_Opportunity_Dollar__c = (item.Vision_SRx_Opty_Share_per__c/100)*(component.get("v.gcpLineItem").Phoenix_Customer_Opp_Sales__c);
            updatedList.push(item);
        });
        component.set("v.ndcList",updatedList);
        /*var delay = 1500;
        var timer = component.get('v.timer');
        clearTimeout(timer);
        timer = setTimeout(function(){
            var ndcList = component.get("v.ndcList");
            var updatedList = [];
            ndcList.forEach(function(item){
                item.Vision_SRx_Opportunity_Dollar__c = (item.Vision_SRx_Opty_Share_per__c/100)*(component.get("v.gcpLineItem").Phoenix_Customer_Opp_Sales__c);
                updatedList.push(item);
            });
            component.set("v.ndcList",updatedList);
            helper.updateNdcItem(component, event, helper, updatedList);
            clearTimeout(timer);
            component.set('v.timer', null);
        }, delay);
        component.set('v.timer', timer);*/
    },
    coolingPeriodUpdated : function(component, event, helper){
        var ndcList = component.get("v.ndcList");
        //if(!component.get("v.accObj").Vision_is_SRx_Account__c)
        //helper.updateNdcItem(component, event, helper, ndcList);
    },
    coolingPeriodDateUpdated: function(component, event, helper){
        var ndcList = component.get("v.ndcList");
        //if(!component.get("v.accObj").Vision_is_SRx_Account__c)
        //helper.getUpdatedListWithCP(component, event, helper, ndcList);
    },
    modifiedDateUpdated : function(component, event, helper){
        component.set("v.isModifiedDateUpdated",true);
    },
    openCal : function(component, event, helper){
        document.getElementById('0OpenItem').style.display="";
    },
    closeCal : function(component, event, helper){
        
    },
    estimateVolUpdated : function(component, event, helper){
        var selectedVal = event.getSource().get('v.value');
        console.log('selectedVal ---> '+selectedVal);
        if(selectedVal.includes('~')){
            var selectedNdcRow = selectedVal.split('~')[0];
            var selectedStatusValue = selectedVal.split('~')[1];
            var ndcList = component.get("v.ndcList");
            var selectedItem = ndcList[selectedNdcRow];
            selectedItem.Vision_Estimate_Vol_Method__c = selectedStatusValue;
            ndcList[selectedNdcRow] = selectedItem;
            ndcList.forEach(function(obj){
                console.log(obj.Vision_Estimate_Vol_Method__c);
            });
            component.set("v.ndcList",ndcList);
        }
    },
    isReviewChanged : function(component, event, helper){
        var changedId = event.getSource().get('v.name');
        console.log('SELECT ID --> '+changedId);
        var ndcList = component.get("v.ndcList");
        ndcList.forEach(function(obj){
            if(changedId == obj.Id && !obj.Vision_isIncludeProduct__c && 
               (obj.GCP_Cust_Act_Volume_Mat_Eu__c != undefined && obj.GCP_Cust_Act_Volume_Mat_Eu__c > 0 || 
                obj.Vision_Cust_Act_Sales_Mat__c != undefined && obj.Vision_Cust_Act_Sales_Mat__c > 0)){
                component.set("v.excludedId",changedId);
                document.getElementById('excludePopup').style.display="";
            }
        });
    },
    closeExcludeProd : function(component, event, helper){
        var changedId = component.get("v.excludedId");
        var ndcList = component.get("v.ndcList");
        var i = 0;
        ndcList.forEach(function(obj){
            if(changedId == obj.Id)
                ndcList[i].Vision_isIncludeProduct__c = true;
            i++;
        });
        component.set("v.ndcList",ndcList);
        document.getElementById('excludePopup').style.display="none";
        component.set("v.excludedId",'');
    },
    excludeProd : function(component, event, helper){
        document.getElementById('excludePopup').style.display="none";
        component.set("v.excludedId",'');
    }
})