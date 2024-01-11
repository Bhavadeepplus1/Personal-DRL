({
	doInit : function(component, event, helper) {
	},
    handleChange: function (component, event, helper) {
        component.set("v.loadSpinner", true);
        var selectedOptionValue = event.getParam("value");
        component.set("v.defaultOption", selectedOptionValue);
        helper.getDataBasedOnFilter(component, event, selectedOptionValue);
    },
    filterData: function(component, event, helper){
        var date1 = component.get("v.startDate");
        var date2 = component.get("v.endDate");
        if(date1 == null || date2 == null || date1 == undefined || date2 == undefined || date1 == '' || date2 == ''){
            var message = 'Please choose both Start Date and End Date';
            helper.showErrorToast(component, event, message);
        } else{
            component.set("v.loadSpinner", true);
            var action = component.get("c.getRelatedList");
            action.setParams({
                'startDate': date1,
                'endDate': date2
            });
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    var resp = response.getReturnValue();
                    helper.setupData(component, event, resp);
                } else{
                    console.log("Error: "+JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action);             
        }
    },
    resetData: function(component, event, helper){
        component.set("v.months", []);
        component.set("v.totalBids", []);
        component.set("v.withIn2Days", []);
        component.set("v.withIn3_5Days", []);
        component.set("v.withIn6_10Days", []);
        component.set("v.moreThan10Days", []);
        component.set("v.startDate", '');
        component.set("v.endDate", '');
        component.set("v.showReport", false);
    },
    
    downloadCsv: function (component, event, helper) {
		var resultData = component.get("v.dataForExport");
        var csv = helper.convertArrayOfObjectsToCSV(component, resultData);
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
        hiddenElement.download = 'Bid Efficiency Report '+ '-' + Now + '.csv'; // CSV file Name* you can change it.[only name not .csv]    
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
        
    },
        onCountClick: function (component, event, helper) {
         var name = event.getSource().get('v.name');
            var arr = [] ;
        name.forEach(function(bid){
            console.log('name-->'+bid.Id)
            arr.push(bid);
            
        });
        component.set ("v.Bidsdisplaylist",arr);
    }

})