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
            var action = component.get("c.getRxDoHData");
            action.setParams({
                "productType": component.get("v.RxSrxList"),
                "customer":component.get("v.selectedId")
                
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
                     component.set("v.DoHSummaryList",resposeData.dohSummary);
                    var accG= component.get("v.DoHSummaryList");
                    console.log('acc'+accG.length);
                    
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
    }
})