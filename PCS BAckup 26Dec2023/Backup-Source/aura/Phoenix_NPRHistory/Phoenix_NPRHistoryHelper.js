({
    onLoad: function(component, event, helper) {
        component.set("v.bidsWithLines",[
            
            { label: 'Contract #', fieldName: 'contrUrl', type: 'url', sortable: true,
             
             typeAttributes: {
                 label: {
                     fieldName: 'contrName',
                     
                     target: '_self'
                 }
             }
            },
            {
                label : 'Field Name',
                fieldName : 'histFieldName',
                type : 'text',
                sortable : true
            },
            {
                label : 'Change Date',
                fieldName : 'dateProcessed',
                type : 'text',
                sortable : true
            },
            
            {
                label : 'Previous Value',
                fieldName : 'deadNetPrev',
                type : 'currency',
                sortable : true
            },
            {
                label : 'New Value',
                fieldName : 'deadNetNew',
                type : 'currency',
                sortable : true
            },
            {
                label : 'Percentage Change',
                fieldName : 'changePercent',
                type : 'percent',
                sortable : true,
                typeAttributes: {
                    maximumFractionDigits: 2}
            }
        ]);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        var rowIndex = component.get("v.bidLineItemId");
        var recId=component.get("v.recordId");
        var nprfieldName=component.find("fieldName").get("v.value");
        if(nprfieldName==undefined){
            nprfieldName='';  
        }
        var action = component.get("c.getProdNPRHistory");
        action.setParams({
            'LineItemId' : rowIndex,
            'recordId':recId,
            'fieldName':nprfieldName
        });
        action.setCallback(this, function(response) {
            let model = response.getReturnValue();
            console.log('------------model------------'+model);
            console.log('------------model-----JSON-------'+JSON.stringify(model));
            model.forEach(function(item){
                item.contrUrl = '/'+item.contrId;
                item.changePercent=(item.deadNetNew-item.deadNetPrev)/item.deadNetPrev;
                if(item.contrUrl == '/undefined'){
                    item.contrUrl = "";
                } 
            });
            component.set("v.model", model);
            component.set("v.prodNPRHistoryList",response.getReturnValue());
            if(response.getReturnValue()[0].nprHistCheck== 'noHist'){
                component.set("v.pickListOption",[]);     
            }
            else{
                component.set("v.pickListOption",response.getReturnValue()[0].pickListOptionsNPRHist);   
            }
            component.set("v.prodId",response.getReturnValue()[0].prodId);
            component.set("v.prodName",response.getReturnValue()[0].prodName);
            component.set("v.ndc",response.getReturnValue()[0].ndc);
            
        });
        $A.enqueueAction(action);
        var event = component.getEvent("lightningEvent1");
        event.setParam("message", "the message to send" );
        event.fire();
        
    },
    
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.model");
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;
        
        // to handel number/currency type fields 
        if(fieldName == 'deadNetPrev' || fieldName == 'deadNetNew' || fieldName=='changePercent'){ 
            data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            }); 
        }
        else{// to handel text type fields 
            data.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });    
        }
        //set sorted data to accountData attribute
        component.set("v.model",data);
    },
    
    onLoadFilter: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);
        component.set("v.bidsWithLines",[
            
            { label: 'Contract #', fieldName: 'contrUrl', type: 'url', sortable: true,
             
             typeAttributes: {
                 label: {
                     fieldName: 'contrName',
                     
                     target: '_self'
                 }
             }
            },
            {
                label : 'Field Name',
                fieldName : 'histFieldName',
                type : 'text',
                sortable : true
            },
            {
                label : 'Change Date',
                fieldName : 'dateProcessed',
                type : 'text',
                sortable : true
            },
            
            {
                label : 'Previous Value',
                fieldName : 'deadNetPrev',
                type : 'currency',
                sortable : true
            },
            {
                label : 'New Value',
                fieldName : 'deadNetNew',
                type : 'currency',
                sortable : true
            },
            {
                label : 'Percentage Change',
                fieldName : 'changePercent',
                type : 'percent',
                sortable : true,
                 typeAttributes: {
                    maximumFractionDigits: 2}
            }
          
        ]);
        
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        var rowIndex = component.get("v.bidLineItemId");
        var recId=component.get("v.recordId");
        var nprfieldName=component.find("fieldName").get("v.value");
        console.log('-----nprfieldName--------------'+nprfieldName);
        if(nprfieldName==undefined){
            nprfieldName='';  
        }
        var action = component.get("c.getProdNPRHistory");
        action.setParams({
            'LineItemId' : rowIndex,
            'recordId':recId,
            'fieldName':nprfieldName
        });
        action.setCallback(this, function(response) {
            let model = response.getReturnValue();
            console.log('------------model------------'+model);
            console.log('------------model-----JSON-------'+JSON.stringify(model));
            model.forEach(function(item){
                item.contrUrl = '/'+item.contrId;
                item.changePercent=(item.deadNetNew-item.deadNetPrev)/item.deadNetPrev;
                if(item.contrUrl == '/undefined'){
                    item.contrUrl = "";
                } 
            });
            component.set("v.model", model);
            component.set('v.isSpinnerLoad',false);
            component.set("v.prodNPRHistoryList",response.getReturnValue());
            if(response.getReturnValue()[0].nprHistCheck== 'noHist'){
                component.set("v.pickListOption",[]);     
            }
            else{
                component.set("v.pickListOption",response.getReturnValue()[0].pickListOptionsNPRHist);   
            }
            component.set("v.prodId",response.getReturnValue()[0].prodId);
            component.set("v.prodName",response.getReturnValue()[0].prodName);
            component.set("v.ndc",response.getReturnValue()[0].ndc);
        });
        $A.enqueueAction(action);
        var event = component.getEvent("lightningEvent1");
        event.setParam("message", "the message to send" );
        event.fire();
    },
})