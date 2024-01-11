({
	doInit : function(component, event, helper) {
        console.log('Do Init');
         helper.getScmData(component, event, helper);
	},
     onClose: function (component, event, helper){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),
            
        });
        navEvt.fire();
    },  
    showPriceChangeDropDown: function(component, event, helper){
        component.set("v.showPriceChangeDropDown", !component.get("v.showPriceChangeDropDown"));
        var priceChangeDropDown = component.get("v.showPriceChangeDropDown");
        var dynamicMargin = component.get("v.dynamicMargin");
        if(priceChangeDropDown){
            dynamicMargin -= 65.78;
        } else{
            dynamicMargin += 65.78;
        }
        component.set("v.dynamicMargin", dynamicMargin);
    },
    showVolumeChangeDropDown: function(component, event, helper){
        component.set("v.showVolumeChangeDropDown", !component.get("v.showVolumeChangeDropDown"));
        var volumeChangeDropDown = component.get("v.showVolumeChangeDropDown");
        var dynamicMargin = component.get("v.dynamicMargin");
        if(volumeChangeDropDown){
            dynamicMargin -= 65.78;
        } else{
            dynamicMargin += 65.78;
        }
        component.set("v.dynamicMargin", dynamicMargin);
    },
    showBothChangeDropDown: function(component, event, helper){
        component.set("v.showBothChangeDropDown", !component.get("v.showBothChangeDropDown"));
        var bothChangeDropDown = component.get("v.showBothChangeDropDown");
        var dynamicMargin = component.get("v.dynamicMargin");
        if(bothChangeDropDown){
            dynamicMargin -= 65.78;
        } else{
            dynamicMargin += 65.78;
        }
        component.set("v.dynamicMargin", dynamicMargin);
    },
    refreshSCM : function (component, event, helper){
        component.set("v.SCMApprovalMap",null);
        component.set("v.SCMApprovalQtyMap",null);
        component.set("v.EstimatedDaysMap",null);
        component.set("v.SCMReJMap",null);
        component.set("v.SCMCommentsMap",null);
        component.set("v.initailOrderVolumeMap",null);
        component.set("v.initailOrderVolumeMap",null);
        console.log('Refresh');
        helper.getScmData(component, event, helper);
    },   
    downloadCsv : function(component,event,helper){    
        
        var ResultData = component.get("v.scmData");
        var template=component.get("v.templateType");
        var title=component.get("v.title");
        /*var est=component.get("v.recordId");
        console.log("est---->"+est);*/
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,ResultData,template);   
        if (csv == null){return;} 
        
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
        var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
        hiddenElement.download = 'NDC Finance View'+'-'+title+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
    getParams : function(component, event) {
        //get method paramaters
        var params = event.getParam('arguments');
        var totalAnnualImpact = component.get("v.totalAnnualImpact");
        var totalBusinessImpact = component.get("v.totalBusinessImpact");
        if (params) {
            var param1 = params.totalAnnualImpact;
            var param2 = params.totalBusinessImpact;
            totalAnnualImpact += param1;
            totalBusinessImpact += param2;
            component.set("v.totalAnnualImpact", totalAnnualImpact);
            component.set("v.totalBusinessImpact", totalBusinessImpact);
        }
        console.log('Total Annual Impact: '+totalAnnualImpact);
        console.log('Total Business Impact: '+totalBusinessImpact);
    }
})