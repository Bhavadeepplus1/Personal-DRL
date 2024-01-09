({
    fetchData: function (cmp,event,helper) {
        var action = cmp.get("c.getPositions");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                cmp.set('v.data',data);
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
        });
        $A.enqueueAction(action);
    },
    getCalculations: function (component,event,helper,responseList) {
        var list=[];
        var sumofAllAwardedQty=0;
        for(var i = 0; i < responseList.length; i++){
            var eachRecAwaQty=responseList[i].Phoenix_Awarded_Quantity__c;
            if(eachRecAwaQty == null){
                eachRecAwaQty=0;
            }
            sumofAllAwardedQty=sumofAllAwardedQty+eachRecAwaQty;
            list.push(eachRecAwaQty);
        };
        var rem=component.get("v.totallineAwaQty");
        var remValue=rem-sumofAllAwardedQty;
        console.log('sumofAllAwardedQty'+sumofAllAwardedQty);
        component.set("v.sumofAllAwardedQty",sumofAllAwardedQty);
        component.set("v.remQtyToAward",remValue);
        
        
    },
    doInitStartHelper : function(component) {
        $A.util.toggleClass(component.find('resultsDiv'),'slds-is-open');
        var value = component.get('v.value');
        var values = component.get('v.values');
        
        if( !$A.util.isEmpty(value) || !$A.util.isEmpty(values) ) {
            var searchString;
            var count = 0;
            var multiSelect = component.get('v.multiSelect');
            var options = component.get('v.options');
            options.forEach( function(element, index) {
                if(multiSelect) {
                    if(values.includes(element.value)) {
                        element.selected = true;
                        count++;
                    }  
                } else {
                    if(element.value == value) {
                        searchString = element.label;
                    }
                }
            });
            if(multiSelect)
                component.set('v.searchString', count + ' Positions selected');
            else
                component.set('v.searchString', searchString);
            component.set('v.options', options);
        }
    },
    
    filterOptionsDataHelper : function(component) {
        component.set("v.message", '');
        var searchText = component.get('v.searchString');
        var options = component.get("v.options");
        var minChar = component.get('v.minChar');
        if(searchText.length >= minChar) {
            var flag = true;
            options.forEach( function(element,index) {
                if(element.label.toLowerCase().trim().startsWith(searchText.toLowerCase().trim())) {
                    element.isVisible = true;
                    flag = false;
                } else {
                    element.isVisible = false;
                }
            });
            component.set("v.options",options);
            if(flag) {
                component.set("v.message", "No results found for '" + searchText + "'");
            }
        }
        $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
    },
     
    selectOptionHelper : function(component, event) {
        console.log('selectOptionHelper');
        var options = component.get('v.options');
        var multiSelect = component.get('v.multiSelect');
        var searchString = component.get('v.searchString');
        var values = component.get('v.values') || [];
        var value;
        var count = 0;
        if(event.currentTarget.id == 'All'){
            if(values != null && values.length != options.length){
                var allSelected = true;
                options.forEach( function(element, index) {
                    if(!element.selected){
                        allSelected = false;
                        element.selected = true;
                        values.push(element.value);
                    }
                });                
            } else if(values.length == options.length){
                values = []; 
                options.forEach( function(element, index) {
                    element.selected = false;
                });
            } else{
                options.forEach( function(element, index) {
                    element.selected = true;
                    values.push(element.value);
                });
            }
        } else{
            options.forEach( function(element, index) {
                if(element.value === event.currentTarget.id) {
                    if(multiSelect) {
                        if(values.includes(element.value)) {
                            values.splice(values.indexOf(element.value), 1);
                        } else {
                            values.push(element.value);
                        }
                        element.selected = element.selected ? false : true;   
                    } else {
                        value = element.value;
                        searchString = element.label;
                    }
                }
                if(element.selected && element.value != 'All') {
                    count++;
                }
            });   
        }
        component.set('v.value', value);
        component.set('v.values', values);
        component.set('v.options', options);
        component.set("v.prodItem.selectedOptions", values);
        if(values != null && values !=  undefined){
            var tempVal = values;
            if(values.includes('All')){
                component.set("v.selectedPositions", tempVal.toString());
                tempVal.splice(tempVal.indexOf('All'), 1);
            }
            component.set("v.selectedPositions", tempVal.toString());
            component.set("v.selectedPositionsString", tempVal.toString());
            component.set("v.prodItem.Phoenix_Awarded_Position__c", tempVal.toString());   
        }
        if(multiSelect){
         	component.set('v.searchString', count + ' Position(s) selected');   
        }
        else
            component.set('v.searchString', searchString);
        if(multiSelect)
            event.preventDefault();
        else
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
    },
     
    removeOptionPillHelper : function(component, event) {
        var value = event.getSource().get('v.name');
        var multiSelect = component.get('v.multiSelect');
        var count = 0;
        var options = component.get("v.options");
        var values = component.get('v.values') || [];
        options.forEach( function(element, index) {
            if(element.value === value) {
                element.selected = false;
                values.splice(values.indexOf(element.value), 1);
            }
            if(element.selected) {
                count++;
            }
        });
        if(multiSelect)
            component.set('v.searchString', count + ' Position(s) selected');
        component.set('v.values', values)
        component.set("v.options", options);
    },
     
    handleBlurHelper : function(component, event) {
        var selectedValue = component.get('v.value');
        var multiSelect = component.get('v.multiSelect');
        var previousLabel;
        var count = 0;
        var options = component.get("v.options");
        options.forEach( function(element, index) {
            if(element.value === selectedValue) {
                previousLabel = element.label;
            }
            if(element.selected && element.value != 'All') {
                count++;
            }
        });
        if(multiSelect)
            component.set('v.searchString', count + ' Position(s) selected');
        else
            component.set('v.searchString', previousLabel);
         
        if(multiSelect)
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
    }
})