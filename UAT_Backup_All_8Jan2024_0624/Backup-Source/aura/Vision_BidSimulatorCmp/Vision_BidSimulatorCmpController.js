({
	doInit : function(component, event, helper) {
        var action = component.get("c.getProdList");
        action.setParams({
            prodId: component.get('v.prodId'),
            accId: component.get('v.accId')
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var wrapObj = response.getReturnValue();
                component.set("v.accObj",wrapObj.accObj);
                component.set("v.prodObj",wrapObj.prodObj);
                component.set("v.scenarioList",wrapObj.scenList);
                component.set("v.actualWac",component.get("v.bidLineData.Phoenix_WAC1__c"));
                //var bidLineData = component.get("v.bidLineData");
                //if(bidLineData != undefined)
            } 
            else{
                console.log("Error IN getProdList --> "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    createNewScenario : function(component, event, helper){
        var action = component.get("c.getScenarioList");
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                let retList = response.getReturnValue();  
                console.log('pickListItems --> '+JSON.stringify(retList));
                //var rtArray = [];
                //retList.forEach(function(item){
                //    let recordType = {label: item, value: item};
                //    rtArray.push(recordType);
                //});               
                component.set("v.scenarioTypeList", retList);
                component.set("v.showList",false);
                component.set("v.showBuilder",true);
            } 
            else{
                console.log("Error IN getProdList --> "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    goBackToList : function(component, event, helper){
        component.set("v.showBuilder",false);
        component.set("v.showList",true);
    },
    pullPrecalcList : function(component, event, helper){
        component.set("v.showBuilder",false);
        helper.getProposedAffecteItems(component,event,helper);
    },
    pullScenarioDetails : function(component, event, helper){
        component.set("v.showBuilder",false);
        component.set("v.showScenarioDetails", true);
        
        helper.getAffectedItems(component, event, helper);
        
    },
    applyTheChange : function(component, event, helper){
        helper.updateProposedPrice(component, event, helper);
    },
    downTheChange : function(component, event, helper){
        component.set("v.changeVal",parseInt(component.get("v.changeVal"))-parseInt(1));
        var delay = 150;
        var timer = component.get('v.timer');
        clearTimeout(timer);
        timer = setTimeout(function(){
            helper.updateProposedPrice(component, event, helper);
            clearTimeout(timer);
            component.set('v.timer', null);
        }, delay);
        component.set('v.timer', timer);
    },
    raiseTheChange : function(component, event, helper){
        component.set("v.changeVal",parseInt(component.get("v.changeVal"))+parseInt(1));
        var delay = 150;
        var timer = component.get('v.timer');
        clearTimeout(timer);
        timer = setTimeout(function(){
            helper.updateProposedPrice(component, event, helper);
            clearTimeout(timer);
            component.set('v.timer', null);
        }, delay);
        component.set('v.timer', timer);
    },
    changeValUpdated : function(component, event, helper){
        var delay = 150;
        var timer = component.get('v.timer');
        clearTimeout(timer);
        timer = setTimeout(function(){
            helper.updateProposedPrice(component, event, helper);
            clearTimeout(timer);
            component.set('v.timer', null);
        }, delay);
        component.set('v.timer', timer);
    },
    openConstFacts :function(component, event, helper){
        component.set("v.showConstantFacts",component.get("v.showConstantFacts") ? false : true);
    },
    closeBidSim  : function (component, event, helper){
        component.set("v.showBidSimulator",false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
    updateSelectedValue : function(component, event, helper){
        var selectedRow = event.currentTarget.id;
        console.log('selectedRow --> '+selectedRow);
        component.set("v.selectedRowInPreCalc",selectedRow);
        var preCalcList = component.get("v.preCalcList");
        var countItem = 0;
        preCalcList.forEach(function(item){
            item.eachItems.forEach(function(childItem){
                if(countItem == selectedRow)
                    childItem.isSelectedButton = true;
                else
                    childItem.isSelectedButton = false;
            });
            countItem++;
        });
        component.set("v.preCalcList",preCalcList);
    },
    editSelectedPreCalc : function(component, event, helper){
        var selectedRowInPreCalc = component.get("v.selectedRowInPreCalc");
        var preCalcList = component.get("v.preCalcList");
        var proposedObj = preCalcList[selectedRowInPreCalc];
        console.log('proposedObj ---> '+JSON.stringify(proposedObj));
        var changeVal = 0;
        var proposedVal = 0;
        //preCalcList.forEach(function(item){
        proposedObj.eachItems.forEach(function(childItem){
            if(childItem.fieldVar == 'changeValuePercent')
                changeVal = childItem.value;
            if(childItem.fieldVar == 'proposedValue')
                proposedVal = childItem.value;
        });
        //});
        console.log('changeVal --> '+changeVal);
        console.log('proposedVal --> '+proposedVal);
        component.set("v.changeVal",changeVal);
        component.set("v.wifProposedValue",proposedVal);
        var wifCurrentValue = component.get("v.wifCurrentValue");
        helper.createCompleteList(component, helper, event, wifCurrentValue, proposedVal);
        component.set("v.showPreCalcs",false);
        component.set("v.showScenarioDetails", true);
    },
    goBackToPreCalcList : function(component, event, helper){
        component.set("v.showPreCalcs",true);
        component.set("v.showScenarioDetails", false);
    },
    changePercentUpdated : function(component, event, helper){
        var changeValPercent = event.getSource().get('v.value');
        component.set("v.changePercent",changeValPercent);
        helper.getProposedAffecteItems(component, event, helper);
    },
    saveScenario : function(component, event, helper){
        var selectedRowInPreCalc = component.get("v.selectedRowInPreCalc");
        var preCalcList = component.get("v.preCalcList");
        var affectedItems = [];
        
        var proposedVal = component.get("v.wifProposedValue");
        var proposedItem = helper.calcAndCreateObj(component, event, helper, proposedVal);
        
        var newList = [];
        var count = 0;
        preCalcList.forEach(function(item){
            if(count == selectedRowInPreCalc){
                var eachItem = [];
                var eachTd = {};
                eachTd.isradioButton = true;
                eachTd.isSelectedButton = true;
                eachTd.fieldVar = 'radioButton';
                eachItem.push(eachTd);
                
                var eachTd = {};
                eachTd.isCurrency = true;
                eachTd.value = proposedVal;
                eachTd.fieldVar = 'proposedValue';
                eachItem.push(eachTd);
                
                var eachTd = {};
                eachTd.isPercent = true;
                eachTd.value = component.get("v.changeVal");
                eachTd.fieldVar = 'changeValuePercent';
                eachItem.push(eachTd);
                
                
                eachTd = {};
                eachTd.value = proposedItem.vipperUnit;
                eachTd.isCurrency = true;
                eachTd.fieldVar = 'VipPerUnitProposed';
                eachItem.push(eachTd);
                
                eachTd = {};
                eachTd.value = proposedItem.cmFeePerUnit;
                eachTd.isCurrency = true;
                eachTd.fieldVar = 'cmFeePerUnitProposed';
                eachItem.push(eachTd);
                
                
                eachTd = {};
                eachTd.value = proposedItem.rebatespPerUnit;
                eachTd.isCurrency = true;
                eachTd.fieldVar = 'rebatePercentPerUnitProposed';
                eachItem.push(eachTd);
                
                eachTd = {};
                eachTd.value = proposedItem.orderanlfeeunit;
                eachTd.isCurrency = true;
                eachTd.fieldVar = 'orderAnalyticsFeePerUnitProposed';
                eachItem.push(eachTd);
                
                eachTd = {};
                eachTd.value = proposedItem.grpVIPPerUnit;
                eachTd.isCurrency = true;
                eachTd.fieldVar = 'groupVipPerUnitProposed';
                eachItem.push(eachTd);
                
                eachTd = {};
                eachTd.value = proposedItem.customerDeadnet;
                eachTd.isCurrency = true;
                eachTd.fieldVar = 'custDeadNetProposed';
                eachItem.push(eachTd);
                
                eachTd = {};
                eachTd.value = proposedItem.IndirectDeadNet;
                eachTd.isCurrency = true;
                eachTd.fieldVar = 'internalDeadNetProposed';
                eachItem.push(eachTd);
                item.eachItems = eachItem;
            }
            newList.push(item);
            count++;
        });
        
        component.set("v.preCalcList",newList);
        component.set("v.showPreCalcs",true);
        component.set("v.showScenarioDetails", false);
    },
    
    saveToBid : function(component, event, helper){
        var selectedRowInPreCalc = component.get("v.selectedRowInPreCalc");
        var preCalcList = component.get("v.preCalcList");
        var proposedObj = preCalcList[selectedRowInPreCalc];
        console.log('proposedObj ---> '+JSON.stringify(proposedObj));
        var proposedVal = 0;
        proposedObj.eachItems.forEach(function(childItem){
            if(childItem.fieldVar == 'proposedValue')
                proposedVal = childItem.value;
        });
        console.log('proposedVal --> '+proposedVal);
        var marketingItems = {};
        marketingItems.proposedVal = proposedVal;
        marketingItems.sNumber = component.get("v.sNum");
        var appEvent = $A.get("e.c:Vision_UpdateMarketingValuesInBid"); 
        appEvent.setParams({"marketingItems" : marketingItems}); 
        appEvent.fire(); 
        
    }
    
})