({
     getRegion:function(component, event, helper){
        var action7 = component.get("c.getRegion");
        action7.setParams({
            "salesTerritoryId":component.get("v.selectedUserId"),
        })
        action7.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response getRegion.....'+responseList.length);
                var title7=[];
                for (var i=0; i<responseList.length; i++) {
                    title7[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.options",title7);  
                //component.set("v.isCategory",true);
                component.set("v.isSpinnerLoad", false);
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action7);
    },
    getcategoryData:function(component, event, helper){
            console.log('multiselect userid'+component.get("v.selectedUserId"));
         var action7 = component.get("c.getcategory");
        action7.setParams({
            "salesTerritoryId":component.get("v.selectedUserId"),
        })
        action7.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response getcategoryData.....'+responseList.length);
                var title7=[];
                for (var i=0; i<responseList.length; i++) {
                    title7[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.options",title7);  
                //component.set("v.isCategory",true);
                component.set("v.isSpinnerLoad", false);
                //this.doInitStartHelper(component);
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action7);
        
    },
    gethospitalName:function(component, event, helper){
        console.log('multiselect userid'+component.get("v.selectedUserId"));
        var action = component.get("c.getHospitalNames");
        action.setParams({
            "salesTerritoryId":component.get("v.selectedUserId"),
        })
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title=[];
                for (var i=0; i<responseList.length; i++) {
                    title[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.options",title);   
                
                //component.set("v.options2",responseList); 
                // helper.getFullData(component, event, helper);
                
                component.set("v.isSpinnerLoad", false);
               // this.doInitStartHelper(component);
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action);
     },
    getProductNames:function(component, event, helper){
         var action1 = component.get("c.getProductNames");
        action1.setParams({
            "salesTerritoryId":component.get("v.selectedUserId"),
        })
        action1.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title1=[];
                for (var i=0; i<responseList.length; i++) {
                    title1[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.options",title1);   
                
                //component.set("v.options2",responseList); 
                // helper.getFullData(component, event, helper);
                
                component.set("v.isSpinnerLoad", false);
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action1);
        
    },
    getProducts:function(component, event, helper){
         var action2 = component.get("c.getProducts");
        action2.setParams({
            "salesTerritoryId":component.get("v.selectedUserId"),
        })
        action2.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title2=[];
                for (var i=0; i<responseList.length; i++) {
                    title2[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.options",title2);   
                
                //component.set("v.options2",responseList); 
                // helper.getFullData(component, event, helper);
                
                component.set("v.isSpinnerLoad", false);
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action2);
                
    },
    getmemberstate:function(component, event, helper){
        var action5 = component.get("c.getmemberstate");
        action5.setParams({
            "salesTerritoryId":component.get("v.selectedUserId"),
        })
        action5.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title5=[];
                for (var i=0; i<responseList.length; i++) {
                    title5[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.options",title5);   
                
                
                
                component.set("v.isSpinnerLoad", false);
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action5);
    },
    getmembericty:function(component, event, helper){
        var action4 = component.get("c.getmembericty");
        action4.setParams({
            "salesTerritoryId":component.get("v.selectedUserId"),
        })
        action4.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title4=[];
                for (var i=0; i<responseList.length; i++) {
                    title4[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.options",title4);   
                
                
                
                component.set("v.isSpinnerLoad", false);
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action4);
    },
    getsubmitters:function(component, event, helper){
           var action6 = component.get("c.getsubmitters");
          action6.setParams({
            "salesTerritoryId":component.get("v.selectedUserId"),
        })
        action6.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title6=[];
                for (var i=0; i<responseList.length; i++) {
                    title6[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.options",title6);   
                
                
                
                component.set("v.isSpinnerLoad", false);
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action6);
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
                component.set('v.searchString', count + ' options selected');
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
        var options = component.get('v.options');
        var multiSelect = component.get('v.multiSelect');
        var searchString = component.get('v.searchString');
        var values = component.get('v.values') || [];
        var value;
        var count = 0;
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
            if(element.selected) {
               //added by satya
                 options.splice(index, 1);
                 options.unshift(element);
             	  //end by satya
                count++;
            }
        });
        component.set('v.value', value);
        component.set('v.values', values);
        component.set('v.options', options);
        if(multiSelect)
            component.set('v.searchString', count + ' options selected');
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
            component.set('v.searchString', count + ' options selected');
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
            if(element.selected) {
                count++;
            }
        });
        if(multiSelect)
            component.set('v.searchString', count + ' options selected');
        else
            component.set('v.searchString', previousLabel);
         
        if(multiSelect)
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
         //added by satya//
        if(component.get("v.ismemberState") || component.get("v.ismemberCity") || component.get("v.isSubmitterName")){
       		var parentComponent = component.get("v.parent");
            parentComponent.greetingMethod2("closeModel")
        }
        //
    }
})