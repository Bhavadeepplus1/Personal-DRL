({
    onLoad: function(component, event, helper) {
        component.set("v.bidsWithLines",[
            { label: 'Monthly Overall Market (ea/eu)', fieldName: 'overallMark', type: 'number', sortable: false},
            {
                label : 'DRL Market Share (%)',
                fieldName : 'drlMarkShare',
                type : 'percent',
                sortable : false,
                typeAttributes: {
                    maximumFractionDigits: 2}
            },
            {
                label : 'Customer % of Market Share',
                fieldName : 'custMarkShare',
                type : 'percent',
                sortable : false,
                typeAttributes: {
                    maximumFractionDigits: 2}
            },
            {
                label : 'Customer Volume (Proposed/Current)',
                fieldName : 'custVol',
                type : 'number',
                sortable : false,
                 typeAttributes: {
                    maximumFractionDigits: 0}
            }
            
        ]);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        var rowIndex = component.get("v.bidLineItemId");
        var recId=component.get("v.recordId");
        var action = component.get("c.getIMSMarketShare");
        action.setParams({
            'LineItemId' : rowIndex,
            'recordId':recId
        });
        action.setCallback(this, function(response) {
            let model = response.getReturnValue();
            console.log('---------model----------'+model);
            console.log('---------model--JSON--------'+JSON.stringify(model));
            if(model!=undefined || model!=null){
                model.forEach(function(item){
                    console.log('item.custVol==>'+item.custVol);
                    console.log('item.overallMark==>'+item.overallMark);
                    item.custMarkShare=(item.custVol/item.overallMark);
                    console.log('item.custMarkShare==>'+item.custMarkShare);
                    item.drlMarkShare=item.drlMarkShare/100;
                });    
            }
            
            component.set("v.model", model);
            component.set("v.imsMarketShareRec",response.getReturnValue());
           if(response.getReturnValue()!=null){
                component.set("v.prodId",response.getReturnValue()[0].prodId);
            component.set("v.prodName",response.getReturnValue()[0].prodName);
            component.set("v.ndc",response.getReturnValue()[0].ndc);
                
          }
            
        });
        $A.enqueueAction(action);
        var event = component.getEvent("lightningEvent1");
        event.setParam("message", "the message to send" );
        event.fire();
        
    },
    
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.model");
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;
        
        // to handel number/currency type fields 
        if(fieldName == 'deadNetPrev' || fieldName == 'deadNetNew'){ 
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
})