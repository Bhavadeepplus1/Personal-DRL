({
	 sortHelper: function(component, event, sortFieldName) {
        var currentDir = component.get("v.isAsc");
        component.set("v.isAsc",!currentDir);
        /*    if (currentDir == 'arrowdown') {
            // set the arrowDirection attribute for conditionally rendred arrow sign  
            component.set("v.arrowDirection", 'arrowup');
            // set the isAsc flag to true for sort in Assending order.  
            component.set("v.isAsc", true);
        } else {
            component.set("v.arrowDirection", 'arrowdown');
            component.set("v.isAsc", false);
        }*/
        // call the onLoad function for call server side method with pass sortFieldName
        this.onSortResult(component, event, sortFieldName);
    },
    
    onSortResult: function(component, event, sortField) {
        //call apex class method
        //component.set("v.showSpinnerSelProds",true);
        var prodName = component.get("v.productName");
        //var  selectedId = component.get("v.selectedId");
        console.log('sortField: '+sortField);
        console.log('prodName: '+prodName);  
        console.log('isAsc: '+ component.get("v.isAsc"));
        var action = component.get("c.fetchSortResults");
        
        //var Allaccount = component.get("v.Allaccount");
        action.setParams({
            'sortField': sortField,
            'isAsc': component.get("v.isAsc"),
            'productList':prodName
            
        });
        action.setCallback(this, function(response) {
            //store state of response
            if (response.getState() === "SUCCESS") {
                component.set('v.loaded',false);
                console.log('successsss');
                var responseWrapper=response.getReturnValue();
                console.log('responseWrapper>>'+JSON.stringify(responseWrapper));
                //set response value in ListOfContact attribute on component.
                //component.set("v.DoHSummaryList",responseWrapper.dohSummary);
                component.set("v.accGroupList", responseWrapper); 
                var accGr=component.get("v.accGroupList");
                console.log('responseWrapper.backOrderRecordsSRx-----'+JSON.stringify(accGr));
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
     searchRx: function (component,helper) {
         component.set('v.loaded',true);
        var picliList = component.get('v.RxSrxList');        
        if(component.get("v.isRxChecked") && !picliList.includes('Rx')){
            
            picliList.push('Rx');
        }
        if(component.get("v.isSRxChecked") && !picliList.includes('SRx')){
            picliList.push('SRx');
        }
        if(component.get("v.isOtcChecked") && !picliList.includes('OTC')){
            picliList.push('OTC');
        }
        if(component.get("v.isRxChecked") == false && picliList.includes('Rx')){
            var ind = picliList.indexOf('Rx')
            picliList.splice(ind, 1);
        }
        if(component.get("v.isSRxChecked") == false && picliList.includes('SRx')){
            var ind = picliList.indexOf('SRx')
            picliList.splice(ind, 1);
        }
        if(component.get("v.isOtcChecked") == false && picliList.includes('OTC')){
            var ind = picliList.indexOf('OTC')
            picliList.splice(ind, 1);
        }
        component.set("v.RxSrxList",picliList);
        console.log('picliList--->'+picliList.length);
        console.log('picliListv--->'+picliList);
        
        //if(component.get("v.RxSrxList").length > 0 ){
            var action = component.get("c.getbackOrder");
            action.setParams({
                showAll : component.get("v.showAll"),
                "productType": component.get("v.RxSrxList"),
                
            });
            action.setCallback(this, function(a) {
                var resposeData =a.getReturnValue();
               
                       var state = a.getState();
                 if (state === "SUCCESS") {
                component.set('v.loaded',false);
                     component.set("v.accGroupList",resposeData.backOrderRecordsSRx);
                      
            
               
                console.log('backOrderRecordsSRx>>'+resposeData.backOrderRecordsSRx.length);
                            
              
                }
                else{
                    console.log('resposeData in else------'+resposeData);
                    //component.set("v.showSpinnerSelProds",false);
                    //component.set("v.noData",true);  
                }
                //component.set("v.showSpinnerSelProds",false);
            });
            $A.enqueueAction(action);
    }
})