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
        var  selectedId = component.get("v.selectedId");
        console.log('sortField: '+sortField);
        console.log('prodName: '+prodName);
        
        console.log('isAsc: '+ component.get("v.isAsc"));
        var action = component.get("c.fetchSortResults");
        
        //var Allaccount = component.get("v.Allaccount");
        action.setParams({
            'sortField': sortField,
            'isAsc': component.get("v.isAsc"),
            'Product':prodName,
            'tradePartnerName' : selectedId
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
                component.set("v.productFamilyDetails", responseWrapper.dohRecords); 
                
                console.log('responseWrapper.dohRecords-----'+JSON.stringify(responseWrapper.dohRecords));
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
     onSortRedColor: function(component, event) {
        //call apex class method
        //component.set("v.showSpinnerSelProds",true);
         var currentDir = component.get("v.isAsc");
        component.set("v.isAsc",!currentDir);
        console.log('isAsc: '+ component.get("v.isAsc"));
      var minRxDoH=component.get("v.minRxDoH");
        var maxRxDoH=component.get("v.maxRxDoH");
        var minRxSales=component.get("v.minRxSales");
        var minSRxSales=component.get("v.minSRxSales");
        var maxSRxDoH=component.get("v.maxSRxDoH");
        var minSRxDoH=component.get("v.minSRxDoH");
                var packageDescList = component.get("v.productFamilyDetails");
                var colorList=[];
                packageDescList.forEach(function(resProd){
                    if (resProd.W8_DOH__c >minRxDoH && resProd.W8_DOH__c<maxRxDoH ||resProd.W8_DOH__c >minSRxDoH && resProd.W8_DOH__c<maxSRxDoH ){
                        colorList.push(resProd);
                    }
                    if(resProd.W8_DOH__c<=minRxDoH ||resProd.W8_DOH__c<=minSRxDoH){
                        
                        colorList.unshift(resProd);
                    }
                    if(resProd.W8_DOH__c>=maxRxDoH ||resProd.W8_DOH__c>=maxSRxDoH ){
                        colorList.unshift(resProd);
                    }  
                });
                component.set("v.productFamilyDetails",colorList);
                console.log('successsss');
               

    },
     onSortGreenColor: function(component, event) {
        //call apex class method
        //component.set("v.showSpinnerSelProds",true);
         var currentDir = component.get("v.isAsc");
        component.set("v.isAsc",!currentDir);
        console.log('isAsc: '+ component.get("v.isAsc"));
      var minRxDoH=component.get("v.minRxDoH");
        var maxRxDoH=component.get("v.maxRxDoH");
        var minRxSales=component.get("v.minRxSales");
        var minSRxSales=component.get("v.minSRxSales");
        var maxSRxDoH=component.get("v.maxSRxDoH");
        var minSRxDoH=component.get("v.minSRxDoH");
                var packageDescList = component.get("v.productFamilyDetails");
                var colorList=[];
                packageDescList.forEach(function(resProd){
                  
                    if(resProd.W8_DOH__c<=minRxDoH ||resProd.W8_DOH__c<=minSRxDoH){
                        
                        colorList.push(resProd);
                    }
                    if(resProd.W8_DOH__c>=maxRxDoH ||resProd.W8_DOH__c>=maxSRxDoH ){
                        colorList.push(resProd);
                    }  
                    if (resProd.W8_DOH__c >minRxDoH && resProd.W8_DOH__c<maxRxDoH ||resProd.W8_DOH__c >minSRxDoH && resProd.W8_DOH__c<maxSRxDoH ){
                        colorList.unshift(resProd);
                    }
                });
                component.set("v.productFamilyDetails",colorList);
                console.log('successsss');
               

    }
    
})