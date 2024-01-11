({
	getPositions: function (component, event, helper, customerRecId) {
        component.set("v.isPositionsModalOpen", true);
        component.set("v.isSpinner",true);
        var action = component.get("c.getPositions");
        action.setParams({
            customerId : customerRecId,
            gcpLineItem : component.get("v.gcpLineItem")
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                var positionList = [];
                if(responseList != ''){
                    if(responseList.includes(','))
                        positionList = responseList.split(',');
                    else
                        positionList.push(responseList);
                }
                console.log('positionList.length :: '+positionList.length);
                var gcpCurPosition = component.get("v.gcpLineItem").Phoenix_Current_Position__c != undefined ? component.get("v.gcpLineItem").Phoenix_Current_Position__c : ''; 
                var i = 0;
                var poslist = [];
                var positionObj = [];
                positionList.forEach(function(posItem){
                    console.log('posItem :: '+posItem);
                    var posName = posItem;
                    var isChecked = gcpCurPosition.includes(posItem) ? true : false;
                    poslist.push({
                        posName: posName,
                        isChecked : isChecked
                    });
                    console.log('positionObj ::: '+poslist);
                    //poslist.push(positionObj);
                });
                console.log('posList :: '+poslist);
                console.log('poslist.length :::: '+poslist.length);
                component.set("v.LinepositionsList", poslist);
                //component.set("v.PositionsEditMode",true);
        
                //component.set("v.defaultList",defaultList);
                component.set("v.isSpinner",false);
            }
        });
        $A.enqueueAction(action);
    },
    getCommentsHelper : function(component, event, helper, selectedItem){
        console.log('in getComments helper');
        
        component.set("v.showSpinnerInCommentPop",true);
        console.log('set showSpinnerInCommentPop');
        
        component.set("v.showComments",true);
        console.log('set showComments');
        var action = component.get("c.getProdBidLineItemComments");
        action.setParams({
            selectedItem : selectedItem,
            accObj : component.get("v.accObj")
        });
        action.setCallback(this, function (response) {
            console.log('response.getState() from getProdBidLineItemComments :: '+response.getState());
            if (response.getState() === "SUCCESS") {
                var doesCmntsExist = false;
                var responseList = response.getReturnValue();
                var cmnts = [];
                var brightCmnts = [];
                responseList.forEach(function(cmntObj){
                    console.log('cmntObj.cmntCat ::: '+cmntObj.cmntCat);
                    if(cmntObj.cmntCat == 'Panorama Comments')
                        doesCmntsExist = true;
                    if(cmntObj.cmntCat == 'Vision Comments')
                        doesCmntsExist = true;
                    if(cmntObj.cmntCat == 'Bright Comments'){
                        for(var key in cmntObj.cmntWrapMap){
                            if(cmntObj.cmntWrapMap[key] != undefined && cmntObj.cmntWrapMap[key].length > 0){
                                brightCmnts.push({key:key,value:cmntObj.cmntWrapMap[key], bidId:cmntObj.cmntWrapMap[key][0].bidId});
                            }
                        }
                    }
                });
                if(brightCmnts.length > 0)
                    doesCmntsExist = true;
                component.set("v.doesCmntsExist",doesCmntsExist);
                component.set("v.brightCmnts",brightCmnts);
                component.set("v.listOfCmnts", responseList);//cmnts);
                component.set("v.showSpinnerInCommentPop",false);
            }
            else{
                console.log('ERROR --- > '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    convertArrayOfObjectsToCSV: function (component, cmntType) {
        var listOfCmnts = component.get("v.listOfCmnts");
        
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        
        columnDivider = ',';
        lineDivider = '\n';
        var myMap = new Map();
        csvStringResult = '';
        
        csvStringResult += '"Account Name:"';
        csvStringResult += columnDivider;
        csvStringResult += '"'+component.get("v.accObj").Name+'"';
        csvStringResult += lineDivider;
        csvStringResult += '"Product Family:"';
        csvStringResult += columnDivider;
        csvStringResult += '"'+component.get("v.gcpLineItem").Phoenix_Product_Family__c+'"';
        csvStringResult += lineDivider;
        csvStringResult += lineDivider;
        
        if(cmntType == 'brightCmnts' || cmntType == 'allCmnts'){
            var brightCmnts = component.get("v.brightCmnts");
            if(brightCmnts.length != 0){
                myMap = new Map();
                myMap.set("Bid Number - Bid Type", "bidNumber");
                myMap.set("User", "userName");
                myMap.set("Team", "teamName");
                myMap.set("Comment Date", "cmntDateTime");
                myMap.set("Comment", "cmntText");
                
                csvStringResult += '"Bright Comments:"';
                csvStringResult += lineDivider;
                csvStringResult += lineDivider;
                csvStringResult += Array.from(myMap.keys()).join(columnDivider);
                csvStringResult += lineDivider;
                
                for (let [key, value] of myMap) {
                    var cmntList = value;
                    cmntList.forEach(function(cmntObj){
                        csvStringResult += '"'+ key +'"';
                        csvStringResult += columnDivider;
                        csvStringResult += '"'+ cmntObj.userName +'"';
                        csvStringResult += columnDivider;
                        csvStringResult += '"'+ cmntObj.cmntAprvlStage +'"';
                        csvStringResult += columnDivider;
                        csvStringResult += '"'+ cmntObj.cmntDate +'"';
                        csvStringResult += columnDivider;
                        csvStringResult += '"'+ cmntObj.cmntString +'"';
                        //csvStringResult += columnDivider;
                        csvStringResult += lineDivider;
                    });
                    //csvStringResult += lineDivider;
                }
            }
        }
        
        if(cmntType == 'visionCmnts' || cmntType == 'allCmnts'){
            
            var visionCmnts = [];
            listOfCmnts.forEach(function(allCmnts){
                if(allCmnts.cmntCat=='Vision Comments'){
                    visionCmnts = allCmnts.cmntWrapList;
                }
            });
            if(visionCmnts.length != 0){
                if(cmntType == 'allCmnts')
                    csvStringResult += lineDivider;csvStringResult += lineDivider;
                myMap = new Map();
                myMap.set("User", "userName");
                myMap.set("Comment Date", "cmntDateTime");
                myMap.set("Comment", "cmntText");
                
                csvStringResult += '"Vision Comments:"';
                csvStringResult += lineDivider;
                csvStringResult += lineDivider;
                
                csvStringResult += Array.from(myMap.keys()).join(columnDivider);
                csvStringResult += lineDivider;
                
                visionCmnts.forEach(function(cmntObj){
                    csvStringResult += '"'+ cmntObj.userName +'"';
                    csvStringResult += columnDivider;
                    csvStringResult += '"'+ cmntObj.cmntDate +'"';
                    csvStringResult += columnDivider;
                    csvStringResult += '"'+ cmntObj.cmntString +'"';
                    //csvStringResult += columnDivider;
                    csvStringResult += lineDivider;
                });
            }
        }
        
        if(cmntType == 'panoramaCmnts' || cmntType == 'allCmnts'){
            
            var panoramaCmnts = [];
            listOfCmnts.forEach(function(allCmnts){
                if(allCmnts.cmntCat=='Panorama Comments'){
                    panoramaCmnts = allCmnts.cmntWrapList;
                }
            });
            if(panoramaCmnts.length != 0){
                if(cmntType == 'allCmnts')
                    csvStringResult += lineDivider;csvStringResult += lineDivider;
                myMap = new Map();
                myMap.set("User", "userName");
                myMap.set("Comment Date", "cmntDateTime");
                myMap.set("Long Term Strategy", "cmntText");
                myMap.set("Short Term Strategy", "cmntText");
                csvStringResult += '"Panorama Comments:"';
                csvStringResult += lineDivider;
                csvStringResult += lineDivider;
                
                csvStringResult += Array.from(myMap.keys()).join(columnDivider);
                csvStringResult += lineDivider;
                
                panoramaCmnts.forEach(function(cmntObj){
                    csvStringResult += '"'+ cmntObj.userName +'"';
                    csvStringResult += columnDivider;
                    csvStringResult += '"'+ cmntObj.cmntDate +'"';
                    csvStringResult += columnDivider;
                    csvStringResult += '"'+ cmntObj.gcpCmntObj.long_term_strategy__c +'"';
                    csvStringResult += columnDivider;
                    csvStringResult += '"'+ cmntObj.gcpCmntObj.short_term_strategy__c +'"';
                    csvStringResult += lineDivider;
                });
            }
        }
        csvStringResult += lineDivider;
        return csvStringResult;
    },
    
    getAlertInfo : function(component, event, helper, recId, itemType){
        var action=component.get("c.fetchVisionAlertList");
        action.setParams({GCPRecId:recId, recType:itemType});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                console.log('RESPONSE  ---> '+JSON.stringify(response.getReturnValue()));
                var alertObj = response.getReturnValue();
                if(alertObj.Id == undefined){
                    alertObj.Vision_isActiveAlert__c = true;
                }
                if(alertObj.Vision_Notification_Repeat_Time__c == undefined)
                   alertObj.Vision_Notification_Repeat_Time__c = '14:00:00.000'; 
                component.set("v.alertObj",alertObj);
            }
        });
        $A.enqueueAction(action);
    },
    updateNdcItem : function(component, event, helper, ndcList){
        var action=component.get("c.updateNdcLineItem");
        action.setParams({ndcItem:ndcList});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                console.log('UPDATED SUCCESSFULLY!');
            }
            else{
                console.log('ERROR from updateNdcLineItem --> '+JSON.stringify(response.getErrors()));
            }
        });
        $A.enqueueAction(action);
    }
})