({
    onLoad: function(component, event, helper) {
        component.set("v.bidsWithLines",[
            { label: 'Bid #', fieldName: 'bidUrl', type: 'url', sortable: true,
             
             typeAttributes: {
                 label: {
                     fieldName: 'bidNames',
                     target: '_self'
                 }
             }
            },
            {
                label : 'Bid Type',
                fieldName : 'bidType',
                type : 'text',
                sortable : true
            },
            {
                label : 'Bid Created Date',
                fieldName : 'dateProcessed',
                type : 'text',
                sortable : true
            },
            {
                label : 'Guidance Price',
                fieldName : 'guidancePrice',
                type : 'currency',
                sortable : true
            },
            {
                label : 'Contract Price',
                fieldName : 'contrPrice',
                type : 'currency',
                sortable : true
            },
            {
                label : 'Internal Dead Net',
                fieldName : 'internalDeadPrice',
                type : 'currency',
                sortable : true
            },
            {
                label : 'TPT %',
                fieldName : 'tptPercent',
                type : 'percent',
                sortable : true,
                typeAttributes: {
                    maximumFractionDigits: 2}
            },
            {
                label : 'Net Sales $',
                fieldName : 'netSales',
                type : 'currency',
                sortable : true,
                typeAttributes: {
                    maximumFractionDigits: 0,minimumFractionDigits: 0}
            },
            {
                label : 'TPT $',
                fieldName : 'tptDollar',
                type : 'currency',
                sortable : true,
                typeAttributes: {
                    maximumFractionDigits: 0,minimumFractionDigits: 0}
            },
            {
                label : 'Volume(Quantity in Packs)',
                fieldName : 'volume',
                type : 'number',
                sortable : true
            }
            /*  {
                label : 'Bid Status',
                fieldName : 'bidStatus',
                type : 'text',
                sortable : true
            },
            {
                label : 'Customer Response Status',
                fieldName : 'custResponse',
                type : 'text',
                sortable : true
            }*/
        ]);
        
        var i=0;
        var bidWrkType=component.find("bidType").get("v.value");
        if(bidWrkType==undefined){
            bidWrkType='';  
        }
        var bidApprStatus=component.find("bidStatus").get("v.value");
        if(bidApprStatus==undefined){
            bidApprStatus='';  
        }
        var bidCustRes=component.find("custResp").get("v.value");
        console.log('-----------bidCustRes---------'+bidCustRes);
        if(bidCustRes==undefined){
            bidCustRes='';  
        }
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        var rowIndex = component.get("v.bidLineItemId");
        var recId=component.get("v.recordId");
        var action = component.get("c.getBidHistory");
        action.setParams({
            'LineItemId' : rowIndex,
            'recordId':recId,
            'bidType':bidWrkType,
            'bidAppStatus':bidApprStatus,
            'bidCustResp':bidCustRes,
        });
        action.setCallback(this, function(response) {
            let model = response.getReturnValue();
            if(model!=undefined){
                model.forEach(function(item){
                    item.tptPercent = item.tptPercent/100;
                    item.bidUrl = '/'+item.bidIds;
                    item.i=i+1;
                    if(item.bidUrl == '/undefined'){
                        item.bidUrl = "";
                    } 
                    i++;  
                });    
                
                
            }
            
            component.set("v.model", model);
            component.set("v.bidHistoryList",response.getReturnValue());
            component.set("v.isSpinnerLoad",false);
            
            if(response.getReturnValue()[0].nprHistCheck== 'noHist'){
                component.set("v.pickListOption",[]);
                component.set("v.pickListOptionStatus",[]);
                component.set("v.pickListOptionCustResp",[]);
                component.set("v.noRec",true);
            }
            else{
                component.set("v.pickListOption",response.getReturnValue()[0].pickListOptions);
                component.set("v.pickListOptionStatus",response.getReturnValue()[0].pickListOptionsStatus);
                component.set("v.pickListOptionCustResp",response.getReturnValue()[0].pickListOptionsCustResp);
                
                component.set("v.noRec",false);
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
        if(data!=null){
            
            //function to return the value stored in the field
            var key = function(a) { return a[fieldName]; }
            var reverse = sortDirection == 'asc' ? 1: -1;
            
            // to handel number/currency type fields 
            if(fieldName == 'guidancePrice' || fieldName == 'contrPrice' || fieldName == 'internalDeadPrice' || fieldName == 'netSales' || fieldName == 'volume' || fieldName == 'tptDollar' || fieldName == 'tptPercent'){ 
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
            
        }
        
    } ,
    
    
    onLoadFilter: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);
        component.set("v.bidsWithLines",[
            { label: 'Bid #', fieldName: 'bidUrl', type: 'url', sortable: true,
             
             typeAttributes: {
                 label: {
                     fieldName: 'bidNames',
                     target: '_self'
                 }
             }
            },
            {
                label : 'Bid Type',
                fieldName : 'bidType',
                type : 'text',
                sortable : true
            },
            {
                label : 'Bid Created Date',
                fieldName : 'dateProcessed',
                type : 'text',
                sortable : true
            },
            {
                label : 'Guidance Price',
                fieldName : 'guidancePrice',
                type : 'currency',
                sortable : true
            },
            {
                label : 'Contract Price',
                fieldName : 'contrPrice',
                type : 'currency',
                sortable : true
            },
            {
                label : 'Internal Dead Net',
                fieldName : 'internalDeadPrice',
                type : 'currency',
                sortable : true
            },
            {
                label : 'TPT %',
                fieldName : 'tptPercent',
                type : 'percent',
                sortable : true,
                typeAttributes: {
                    maximumFractionDigits: 2}
                
            },
      {
                label : 'Net Sales $',
                fieldName : 'netSales',
                type : 'currency',
                sortable : true,
                typeAttributes: {
                    maximumFractionDigits: 0,minimumFractionDigits: 0}
            },
            {
                label : 'TPT $',
                fieldName : 'tptDollar',
                type : 'currency',
                sortable : true,
                typeAttributes: {
                    maximumFractionDigits: 0,minimumFractionDigits: 0}
            },
            {
                label : 'Volume (Quanity in Packs)',
                fieldName : 'volume',
                type : 'number',
                sortable : true
            }
            /*  {
                label : 'Bid Status',
                fieldName : 'bidStatus',
                type : 'text',
                sortable : true
            },
            {
                label : 'Customer Response Status',
                fieldName : 'custResponse',
                type : 'text',
                sortable : true
            }*/
        ]);
        
        var i=0;
        var bidWrkType=component.find("bidType").get("v.value");
        if(bidWrkType==undefined){
            bidWrkType='';  
        }
        var bidApprStatus=component.find("bidStatus").get("v.value");
        console.log('------------bidApprStatus------------'+bidApprStatus);
        if(bidApprStatus==undefined){
            bidApprStatus='';  
        }
        var bidCustRes=component.find("custResp").get("v.value");
        console.log('-----------bidCustRes---------'+bidCustRes);
        if(bidCustRes==undefined){
            bidCustRes='';  
        }
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        var rowIndex = component.get("v.bidLineItemId");
        var recId=component.get("v.recordId");
        var action = component.get("c.getBidHistory");
        action.setParams({
            'LineItemId' : rowIndex,
            'recordId':recId,
            'bidType':bidWrkType,
            'bidAppStatus':bidApprStatus,
            'bidCustResp':bidCustRes,
        });
        action.setCallback(this, function(response) {
            let model = response.getReturnValue();
            if(model!=undefined){
                model.forEach(function(item){
                    item.tptPercent = item.tptPercent/100;
                    item.bidUrl = '/'+item.bidIds;
                    item.i=i+1;
                    if(item.bidUrl == '/undefined'){
                        item.bidUrl = "";
                    } 
                    i++;  
                });    
                
                
            }
            component.set("v.model", model);
            component.set("v.bidHistoryList",response.getReturnValue());
            component.set("v.isSpinnerLoad",false);
            
            if(response.getReturnValue()[0].nprHistCheck== 'noHist'){
                //  component.set("v.pickListOption",[]);
                //  component.set("v.pickListOptionStatus",[]);
                // component.set("v.pickListOptionCustResp",[]);
                component.set("v.noRec",true);
                component.set("v.pickListOption",response.getReturnValue()[0].pickListOptions);
                component.set("v.pickListOptionStatus",response.getReturnValue()[0].pickListOptionsStatus);
                component.set("v.pickListOptionCustResp",response.getReturnValue()[0].pickListOptionsCustResp);
            }
            else{
                component.set("v.pickListOption",response.getReturnValue()[0].pickListOptions);
                component.set("v.pickListOptionStatus",response.getReturnValue()[0].pickListOptionsStatus);
                component.set("v.pickListOptionCustResp",response.getReturnValue()[0].pickListOptionsCustResp);
                
                component.set("v.noRec",false);
            }   
            
            component.set("v.prodId",response.getReturnValue()[0].prodId);
            component.set("v.prodName",response.getReturnValue()[0].prodName);
            component.set("v.ndc",response.getReturnValue()[0].ndc);
        });
        $A.enqueueAction(action);
        var event = component.getEvent("lightningEvent1");
        event.setParam("message", "the message to send" );
        event.fire();
    }
    
})