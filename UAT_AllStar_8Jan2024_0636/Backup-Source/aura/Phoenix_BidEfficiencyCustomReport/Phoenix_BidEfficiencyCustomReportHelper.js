({
    setupData: function(component, event, response){
        var withIn2Days = response.completedWithin2Days;
        var withIn3_5Days = response.completedWithin3_5Days;
        var withIn6_10Days = response.completedWithin6_10Days;
        var moreThan10Days = response.completedMoreThan10Days;
        var twoDaysLst =response.twoDaysLst;
        var in3_5DaysLst =response.in3_5DaysLst;
        var in6_10DaysLst =response.in6_10DaysLst;
        var moreThan10DaysLst = response.moreThan10DaysLst;
        
        component.set("v.months", response.listOfMonths);
        component.set("v.withIn2Days", withIn2Days);
        component.set("v.withIn3_5Days", withIn3_5Days);
        component.set("v.withIn6_10Days", withIn6_10Days);
        component.set("v.moreThan10Days", moreThan10Days);
        this.calcHelper(component, event);
    },
    
    calcHelper : function(component, event, helper) {
        var monthsSize = component.get("v.months").length;
        var withIn2Days = component.get("v.withIn2Days");
        var withIn3_5Days = component.get("v.withIn3_5Days");
        var withIn6_10Days = component.get("v.withIn6_10Days");
        var moreThan10Days = component.get("v.moreThan10Days");
        var totalCount = [];
        for(var i=0; i<monthsSize; i++){
            var total = {};
                        var addVal = withIn2Days[i].count.length+withIn3_5Days[i].count.length+withIn6_10Days[i].count.length+moreThan10Days[i].count.length;

            total.count = addVal;
            totalCount.push(total);
        }
        component.set("v.totalBids", totalCount);
        this.calcPercent(component, event);
    },
    
    calcPercent: function(component, event){
        var monthsSize = component.get("v.months").length;
        var withIn2Days = component.get("v.withIn2Days");
        var withIn3_5Days = component.get("v.withIn3_5Days");
        var withIn6_10Days = component.get("v.withIn6_10Days");
        var moreThan10Days = component.get("v.moreThan10Days");
        var totalCount = component.get("v.totalBids");
        var totals = [];
        console.log('withIn2Days - '+JSON.stringify(withIn2Days));
        for(var i=0; i<withIn2Days.length; i++){
            if(withIn2Days[i].count.length == 0 || totalCount[i].count == 0){
                withIn2Days[i].percent = 0;   
            } else{
                var calcVal = withIn2Days[i].count.length/totalCount[i].count;
                withIn2Days[i].percent = calcVal; 
            }
        }
        for(var i=0; i<withIn3_5Days.length; i++){
            if(withIn3_5Days[i].count.length == 0 || totalCount[i].count == 0){
                withIn3_5Days[i].percent = 0;   
            } else{
                var calcVal = withIn3_5Days[i].count.length/totalCount[i].count;
                withIn3_5Days[i].percent = calcVal; 
            }
        }
        for(var i=0; i<withIn6_10Days.length; i++){
            if(withIn6_10Days[i].count.length == 0 || totalCount[i].count == 0){
                withIn6_10Days[i].percent = 0;   
            } else{
                var calcVal = withIn6_10Days[i].count.length/totalCount[i].count;
                withIn6_10Days[i].percent = calcVal; 
            }
        }
        for(var i=0; i<moreThan10Days.length; i++){
            if(moreThan10Days[i].count.length == 0 || totalCount[i].count == 0){
                moreThan10Days[i].percent = 0;   
            } else{
                var calcVal = moreThan10Days[i].count.length/totalCount[i].count;
                moreThan10Days[i].percent = calcVal; 
            }
        }
        var updatedTotalCount = [];
        for(var i=0; i<totalCount.length; i++){
            var total = {};
            var addVal = withIn2Days[i].percent+withIn3_5Days[i].percent+withIn6_10Days[i].percent+moreThan10Days[i].percent;
            total.count = totalCount[i].count;
            total.percent = addVal;
            updatedTotalCount.push(total);
        }
        component.set("v.totalBids", updatedTotalCount);
        component.set("v.withIn2Days", withIn2Days);
        component.set("v.withIn3_5Days", withIn3_5Days);
        component.set("v.withIn6_10Days", withIn6_10Days);
        component.set("v.moreThan10Days", moreThan10Days);
        component.set("v.loadSpinner", false);
        component.set("v.showReport", true);
        var months = component.get("v.months");
        
        var data = [];
        var ob = {};
        for(var i=0; i<months.length; i++){
            ob[i] = 'Bids ('+months[i]+')';
            ob['col'] = 'Efficiency Level';
            ob[i+'1'] = '% ('+months[i]+')';
        }
        data.push(ob);
        var ob1 = {};
        for(var i=0; i<months.length; i++){
            ob1[i] = withIn2Days[i].count.length;
            ob1['col'] = 'Completed within 2 days';
            ob1[i+'1'] = withIn2Days[i].percent*100;
        }
        data.push(ob1);
        var ob2 = {};
        for(var i=0; i<months.length; i++){
            ob2[i] = withIn3_5Days[i].count.length;
            ob2['col'] = 'Completed within 3-5 days';
            ob2[i+'1'] = withIn3_5Days[i].percent*100;
        }
        data.push(ob2);
        var ob3 = {};
        for(var i=0; i<months.length; i++){
            ob3[i] = withIn6_10Days[i].count.length;
            ob3['col'] = 'Completed within 6-10 days';
            ob3[i+'1'] = withIn6_10Days[i].percent*100;
        }
        data.push(ob3);
        var ob4 = {};
        for(var i=0; i<months.length; i++){
            ob4[i] = moreThan10Days[i].count.length;
            ob4['col'] = 'Completed > 10 days';
            ob4[i+'1'] = moreThan10Days[i].percent*100;
        }
        data.push(ob4);
        var ob5 = {};
        for(var i=0; i<months.length; i++){
            ob5[i] = updatedTotalCount[i].count;
            ob5['col'] = 'Total';
            ob5[i+'1'] = updatedTotalCount[i].percent*100;
        }
        data.push(ob5);
        component.set("v.dataForExport", data);
    },
    
    getDataBasedOnFilter: function(component, event, selectedOptionValue){
        var action = component.get("c.getRelatedList");
        action.setParams({
            'filterKey': selectedOptionValue
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var response = response.getReturnValue();
                this.setupData(component, event, response);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    showErrorToast : function(component, event, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning!',
            message: message,
            duration:' 5000',
            key: 'info_alt',
            type: 'error'
        });
        toastEvent.fire();
    },
    
    convertArrayOfObjectsToCSV: function (component, objectRecords) {
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider = '\n';

        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header 
        csvStringResult = '';
        var months = component.get("v.months");
        var myMap = new Map();
        myMap.set("Summary: Monthly Trend", "col");
        for(var i=0; i<months.length; i++){
            myMap.set(months[i].replace(/,/,'-'), i);
            myMap.set(months[i].replace(/,/,' '), i+'1');
        }

        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        
        //new logic start 
            for (var i = 0; i < objectRecords.length; i++) {
                counter = 0;
                for (let [key, value] of myMap) {
                    if (counter > 0) {
                        csvStringResult += columnDivider;
                    }
                    if (objectRecords[i][value] == undefined) {
                        csvStringResult += '"' + '' + '"';
                    } else {
                        csvStringResult += '"' + objectRecords[i][value] + '"';
                    }
                    
                    counter++;
                }
                csvStringResult += lineDivider;
            }   
        return csvStringResult;
    },
})