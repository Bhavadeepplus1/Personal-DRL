({
	doInit : function(component, event, helper) {
         helper.getScmData(component, event, helper);
        
	},
     onClose: function (component, event, helper){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),
            
        });
        navEvt.fire();
    },  
    refreshSCM : function (component, event, helper){
        component.set("v.SCMApprovalMap",null);
        component.set("v.SCMApprovalQtyMap",null);
        component.set("v.EstimatedDaysMap",null);
        component.set("v.SCMReJMap",null);
        component.set("v.SCMCommentsMap",null);
        component.set("v.initailOrderVolumeMap",null);
        component.set("v.initailOrderVolumeMap",null);
        component.get("v.templateType");
        helper.getScmData(component, event, helper);
        /*action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                //var bidRecord=response.getReturnValue();
                //console.log('template type-->'+bidRecord.Phoenix_Customer_Type__c);
            }
        })*/
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
    }
})