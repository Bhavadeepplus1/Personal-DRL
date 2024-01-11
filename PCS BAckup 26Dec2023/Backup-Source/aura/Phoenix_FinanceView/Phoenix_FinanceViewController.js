({
	doInit : function(component, event, helper) {
         component.set("v.isSpinnerLoad", true); 
        helper.getRollupData(component, event, helper);
        console.log('doInit---->')
        
	},
    onApprovalChange :  function(component, event, helper) {
        console.log('onApprovalChange-----before')
        component.set("v.isClicked", true); 
        var profamily = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        console.log('onApprovalChange-----after')
        let financeApprovalMap;
        if(component.get("v.financeApprovalMap") != null ){
            financeApprovalMap = component.get("v.financeApprovalMap");
        }else{
            financeApprovalMap = new Map();
        }
        console.log('profamily--->'+profamily)
        console.log('val--->'+val)
        if(financeApprovalMap != null && financeApprovalMap.has(profamily)){
            financeApprovalMap.delete(profamily);
        }else{
            financeApprovalMap[profamily] = val ;
        }
        component.set("v.financeApprovalMap", financeApprovalMap);
        console.log('financeApprovalMap--->'+JSON.stringify(financeApprovalMap))
	},
    onCommentChange :function(component, event, helper) {
        component.set("v.isClicked", true); 
        var productList = component.find('select');
        var profamily = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        console.log('profamily--->'+profamily)
        console.log('val--->'+val)
        let financeCommentsMap;
        if(component.get("v.financeCommentsMap") != null ){
            financeCommentsMap = component.get("v.financeCommentsMap");
        }else{
            financeCommentsMap = new Map();
        }
        if(financeCommentsMap != null && financeCommentsMap.has(profamily)){
            financeCommentsMap.delete(profamily);
        }else{
            financeCommentsMap[profamily] = val ;
        }
        component.set("v.financeCommentsMap", financeCommentsMap);
        console.log('financeCommentsMap--->'+financeCommentsMap)
	},
    onClick :function (component, event , helper){
        // component.set("v.isClicked", false); 
    },
    saveClick : function (component, event , helper){
        component.set("v.isSpinnerLoad" , true);
        var financeApproval;
        var financetApprovaltype = component.find("headerFinanceApproval");
        if(financetApprovaltype != null ){
            financeApproval = financetApprovaltype.get("v.value");
        }else{
            financeApproval = '';
        }
        console.log('financetApprovaltype--->'+financeApproval);
        console.log('financetApprovaltype--->'+component.get("v.isFinanceApproved"));
        var action = component.get("c.updateLineItems");
        action.setParams({
            bidId : component.get("v.recordId"),
            approvalMap : component.get("v.financeApprovalMap"),
            commentsMap : component.get("v.financeCommentsMap"),
            financeApproval : financeApproval,
            isFinanceApproved : component.get("v.isFinanceApproved")
            
        });
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                var dataList = response.getReturnValue();
                component.set("v.rollupData", dataList);
                var toastEvent = $A.get("e.force:showToast");
                 component.set("v.isSpinnerLoad" , false);
                 component.set("v.isClicked", false);
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Record Updated Successfully."
                });
                toastEvent.fire();
            }
            
            	
        });
        $A.enqueueAction(action);
    },
    onClose: function (component, event, helper){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),
            
        });
        navEvt.fire();
    },
    onApprovalSubmit: function(component,event,helper){
        component.set("v.isSpinnerLoad",true) 
        var listOfItems = component.get("v.rollupData");
        console.log('scmData-->'+JSON.stringify(listOfItems));
        console.log('firstApproval--->'+listOfItems[0])
        var isApproved = false;
        listOfItems.forEach(function(line){
            if(line.financeApproval == 'None' || line.financeApproval == '' || line.financeApproval == null || line.financeApproval == 'undefined'){
                isApproved = true;
                console.log("scmApproval--->"+line.scmApproval)
            }
        });
        
        if(isApproved == true){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"warning",
                "title": "Failed!",
                "message": "Please confirm each approval to proceed further"
            });
            toastEvent.fire();
        }else{
            
            var action = component.get("c.makeApprovals");
            action.setParams({
            bidId : component.get("v.recordId")
        	});
        	action.setCallback(this, function (response){
                if(response.getState() === "SUCCESS"){
                    console.log('finance approved success')
                   helper.getRollupData(component, event, helper);
                     component.set("v.isSpinnerLoad",false); 
                }else{
                    component.set("v.isSpinnerLoad",false); 
                }
            });
           $A.enqueueAction(action);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"success",
                "title": "Success",
                "message": "Your Approvals are submitted successfully."
            });
            toastEvent.fire();
        }
        
    },
    onHeaderApprovalChange : function(component,event,helper){
    	component.set("v.isClicked", true);
        component.set("v.isFinanceApproved", true);
        let approvalIds = component.find('select');
        if(approvalIds != null && approvalIds.length == 'undefined' && component.find("headerFinanceApproval") != null){
            approvalIds.set("v.value",component.find("headerFinanceApproval").get("v.value"));
        }
        if(approvalIds != null && approvalIds.length > 0 && component.find("headerFinanceApproval") != null){
            approvalIds.forEach(function(eachApprovalId){
                eachApprovalId.set("v.value", component.find("headerFinanceApproval").get("v.value"))
            });
        }
	},
    downloadCsv : function(component,event,helper){    
        
        var ResultData = component.get("v.rollupData");
        console.log('testing result--->'+JSON.stringify(ResultData));
        
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
        hiddenElement.download = 'Finance View'+'-'+title+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    }
    
})