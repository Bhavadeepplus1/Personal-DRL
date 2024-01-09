({
	
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
            var action = component.get("c.getDoHData");
            action.setParams({
                
                "tradePartnerName":component.get("v.selectedId"),
                "productType": component.get("v.RxSrxList"),
                "isBOProduct":component.get('v.isBOProduct'),
            "is4Weeks":component.get('v.is4Weeks')
                
            });
            action.setCallback(this, function(a) {
                var resposeData =a.getReturnValue();
                //component.set("v.noData",false);  
                //component.set("v.ProductList", resposeData);
                //component.set("v.Allaccount", resposeData);
                console.log('resposeData------'+JSON.stringify(resposeData));
                //if(resposeData!=null && resposeData!='' && resposeData!=undefined){
                       var state = a.getState();
                 if (state === "SUCCESS") {
                component.set('v.showRecords',false);
                component.set('v.loaded',false);
                    //.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                    //component.set("v.allData", resposeData);
                    //component.set("v.currentPageNumber", 1);
                    //helper.buildData(component, helper);
                    //component.set("v.accGroupList",resposeData.dohSummary);
                     component.set("v.DoHSummaryList",resposeData.accList);
                      component.set("v.noOfRecords",resposeData.noOfRecords); 
                    var accG= component.get("v.DoHSummaryList");
                    console.log('acc'+accG.length);
                     //var doh= component.get("v.DoHSummaryList");
               
                var doh= component.get("v.DoHSummaryList");
               
                console.log('doh>>'+JSON.stringify(doh.dohRecords));
                var dohData=doh[0].dohRecords;
                console.log('dohData>>'+JSON.stringify(dohData));
              
                component.set("v.ProductName",dohData);
                var prodName=component.get("v.ProductName");
                console.log('prodName>>'+JSON.stringify(prodName));
                
               component.set("v.noOfRecords",resposeData.noOfRecords); 
            
                    
                    //console.log('acclen'+acc.sdpfist[0]);
           //     component.set("v.shortDateList",resposeData.gcpShortDates);   
                }
                else{
                    console.log('resposeData in else------'+resposeData);
                    //component.set("v.showSpinnerSelProds",false);
                    //component.set("v.noData",true);  
                }
                //component.set("v.showSpinnerSelProds",false);
            });
            $A.enqueueAction(action);
    },
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
        var prodName = component.get("v.ProductName");
        var  selectedId = component.get("v.selectedId");
        var searchName=component.get("v.searchText");
        console.log('sortField: '+sortField);
        console.log('prodName: '+prodName);
        
        console.log('isAsc: '+ component.get("v.isAsc"));
        var action = component.get("c.fetchSortResults");
        
        //var Allaccount = component.get("v.Allaccount");
        action.setParams({
            'sortField': sortField,
            'isAsc': component.get("v.isAsc"),
            //'searchText' : searchName,
            'productList': prodName,
            'tradePartnerName' : selectedId,
            'productType' :component.get('v.RxSrxList'),
            'isBOProduct' :component.get('v.isBOProduct'),
            'is4Weeks' :component.get('v.is4Weeks')
        });
        action.setCallback(this, function(response) {
            //store state of response
            if (response.getState() === "SUCCESS") {
                component.set('v.loaded',false);
                console.log('successsss');
                var responseWrapper=response.getReturnValue();
                console.log('responseWrapper>>'+JSON.stringify(responseWrapper));
                //set response value in ListOfContact attribute on component.
                component.set("v.DoHSummaryList",responseWrapper.accList);
                component.set("v.productFamilyDetails", responseWrapper.accList); 
                 component.set("v.noOfRecords",responseWrapper.noOfRecords); 
     
                
                console.log('responseWrapper.dohRecords-----'+JSON.stringify(responseWrapper.accList));
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },onSortYesColor: function(component, event) {
        var dohSummary=component.get("v.DoHSummaryList");
         var currentDir = component.get("v.isAsc");
        component.set("v.isAsc",!currentDir);
        console.log('isAsc: '+ component.get("v.isAsc"));
 
        var dohRecords=dohSummary[0].dohRecords;
        console.log('dohRecords>>'+JSON.stringify(dohRecords));
         var colorList=[];
          
         dohRecords.forEach(function(doh){
             
             if(doh.GCP_Backorder_SRX__r!=undefined && doh.GCP_Backorder_SRX__r.Vision_Product__r!=undefined && doh.GCP_Backorder_SRX__r.Vision_Product__r.ProductCode != null){
                 colorList.push(doh);
           
             }
             else if(doh.GCP_Backorder_RX__r!=undefined && doh.GCP_Backorder_RX__r.Vision_Product__r!=undefined && doh.GCP_Backorder_RX__r.Vision_Product__r.ProductCode != null){
                 colorList.push(doh);
           
              }
                 else{
                     colorList.unshift(doh);
                 }
             
             
              });
             component.set("v.DoHSummaryList[0].dohRecords",colorList)
 
        
    },
    onSortNoColor: function(component, event) {
        var dohSummary=component.get("v.DoHSummaryList");
         var currentDir = component.get("v.isAsc");
        component.set("v.isAsc",!currentDir);
        console.log('isAsc: '+ component.get("v.isAsc"));
 
        var dohRecords=dohSummary[0].dohRecords;
        console.log('dohRecords>>'+JSON.stringify(dohRecords));
         var colorList=[];
          
         dohRecords.forEach(function(doh){
             
             if(doh.GCP_Backorder_SRX__r!=undefined && doh.GCP_Backorder_SRX__r.Vision_Product__r!=undefined && doh.GCP_Backorder_SRX__r.Vision_Product__r.ProductCode != null){
                 colorList.unshift(doh);
           
             }
             else if(doh.GCP_Backorder_RX__r!=undefined && doh.GCP_Backorder_RX__r.Vision_Product__r!=undefined && doh.GCP_Backorder_RX__r.Vision_Product__r.ProductCode != null){
                 colorList.unshift(doh);
           
              }
                 else{
                     colorList.push(doh);
                 }
             
             
              });
             component.set("v.DoHSummaryList[0].dohRecords",colorList)
 
        
    }
})