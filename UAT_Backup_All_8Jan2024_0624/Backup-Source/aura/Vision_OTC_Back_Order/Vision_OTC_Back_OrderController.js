({
    doInit : function(component, event, helper) {
        var getBidInfoAction = component.get("c.getbackOrder");
        component.set('v.loaded',true); 
         getBidInfoAction.setParams({
            showAll : component.get("v.showAll"),
             productType: component.get("v.productName")
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                component.set("v.accGroupList",responseWrapper.backOrderRecordsSRx);
                component.set("v.isProcessed",responseWrapper.isProcessed); 
                console.log('respone Srx-----'+JSON.stringify(responseWrapper));
                console.log('accGroupList--'+JSON.stringify(component.get("v.accGroupList")));
                component.set('v.loaded',false);
                     component.set("v.ProdFamList",responseWrapper.prodFamList);
                component.set("v.dateList",responseWrapper.sdRecords);
                component.set("v.visionUpdateDate",responseWrapper.visionUpdateDate);
                
                console.log('dateList',+JSON.stringify(component.get("v.dateList")));
                	  var data=component.get("v.accGroupList");
                   var productName = data;
                    component.set('v.productName', productName);
                    console.log('productName-----'+JSON.stringify(productName))
                    console.log('data-----'+JSON.stringify(data))
                
                
         var week1='';
         var week2='';
                data.forEach(function(item){
                    var substr1Week1=item.Vision_Week_1__c.substr(5,11);
                    var substr2Week1=item.Vision_Week_1__c.substr(21,25);
                    var W1='';
                    week1=W1.concat(substr1Week1,substr2Week1);
                    var substr1Week2=item.Vision_Week_2__c.substr(5,11);
                    var substr2Week2=item.Vision_Week_2__c.substr(21,25);
                    var W2='';
                    week2=W2.concat(substr1Week2,substr2Week2);
                });	
                component.set('v.week1',week1);
                console.log('week1-----'+week1);
                component.set('v.week2',week2);
            }
            else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(getBidInfoAction);
        
    }, 
 
    
    onsearch: function (component, event, helper) {
        console.log('Hi search')
        console.log('Hi search-----'+component.get("v.searchText"))
        //component.set("v.noData",false);
        var searchName=component.get("v.searchText");
        var showRecords=component.get("v.showAll");
        component.set('v.loaded',true);
        
        var action = component.get("c.getFilterBackOrder");
        action.setParams({
            searchText : searchName,
            showAll: showRecords
           
            
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
             console.log('hi res'+state);
            if (state === "SUCCESS") {
                console.log('hi search');
                var responseWrapper = response.getReturnValue();
                component.set('v.loaded',false);
                 
               
                if(searchName != null && searchName != undefined){
                    console.log('responseWrapper>>'+JSON.stringify(responseWrapper)); 
                    component.set("v.accGroupList",responseWrapper.backOrderRecordsSRx); 
                var data=component.get("v.accGroupList");
                   var productName = data;
                    component.set('v.productName', productName);
                    console.log('productName-----'+JSON.stringify(productName))
                    console.log('data-----'+JSON.stringify(data))
      
                }
                else{
                  console.log('responseWrapper>>'+JSON.stringify(responseWrapper)); 
                   component.set("v.accGroupList",responseWrapper.backOrderRecordsSRx);   
                var data=component.get("v.accGroupList");
                   var productName = data;
                    component.set('v.productName', productName);
                    console.log('productName-----'+JSON.stringify(productName))
                    console.log('data-----'+JSON.stringify(data))
      
                }
              
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        
    },
    sortByprodDescription: function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
       
        helper.sortHelper(component, event, 'Vision_SKU_Description__c');
    },
    sortByOpenOrderQty: function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
       
        helper.sortHelper(component, event, 'Vision_Order_Qty__c');
    },
    sortByBackOrderQty: function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
       
        helper.sortHelper(component, event, 'Vision_Backorder_Qty__c');
    },
    sortByBackOrderValue: function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
       
        helper.sortHelper(component, event, 'Vision_Back_Order_Value__c');
    },
    sortByDemandinMn : function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
       
        helper.sortHelper(component, event, 'Vision_Demand_In_Tab_Cap__c');
    },
    sortByExpectedMonthlySales	: function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
       
        helper.sortHelper(component, event, 'Vision_Expected_Monthly_Sales__c');
    },
    sortByTotalinTransit	: function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
       
        helper.sortHelper(component, event, 'Vision_Total_in_Transit__c');
    },
    sortBynventoryAtUPS	: function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
       
        helper.sortHelper(component, event, 'Vision_Stocks_at_UPS__c');
    },
    sortByMoH	: function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
       
        helper.sortHelper(component, event, 'Vision_MoH__c');
    },
    sortByMarketingComments	: function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
       
        helper.sortHelper(component, event, 'Vision_On_Backorder__c');
    },
    searchSrxRxOttc : function(component,event,helper){
        helper.searchRx(component, helper);
    },
      sortByPrevBackOrderQty: function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
       
        helper.sortHelper(component, event, 'Vision_Past_Week_BackOrder_Quantity__c');
    },
      sortByPrevBackOrderValue: function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
       
        helper.sortHelper(component, event, 'Vision_Past_Week_Backorder_Value__c');
    },
     sortByNDC: function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
       
        helper.sortHelper(component, event, 'Vision_Product__r.Phoenix_NDC_11__c');
    },
    sortBySKUCode:  function(component, event, helper) {
        console.log('inside sortByDOh1');
         component.set('v.loaded',true);
       
        helper.sortHelper(component, event, 'Vision_SKU_Code__c');
    },
   showAllRecords : function(component,event,helper){  
       var version = component.get("v.showAll");
        console.log('test->'+component.get("v.showAll"));
        var isCheck = component.get("v.showAll");
        var trueValue = true;
        var falsevalue = false;
        if(isCheck == false){
            component.set("v.showAll",falsevalue);
        }
        else{
            component.set("v.showAll",trueValue); 
        }
         console.log('test123->'+component.get("v.showAll"));
         var data=component.get("v.accGroupList");
                   var productName = data;
                    component.set('v.productName', productName);
                    console.log('productName-----'+JSON.stringify(productName))
                    console.log('data-----'+JSON.stringify(data))
       var getBidInfoAction = component.get("c.getbackOrder");
        component.set('v.loaded',true);
        component.set('v.searchText',null);
         getBidInfoAction.setParams({
            showAll : component.get("v.showAll"),
             productType: component.get("v.RxSrxList")
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                component.set("v.accGroupList",responseWrapper.backOrderRecordsSRx);
                console.log('respone Srx-----'+JSON.stringify(responseWrapper));
                console.log('accGroupList--'+JSON.stringify(component.get("v.accGroupList")));
                component.set('v.loaded',false);
                     component.set("v.ProdFamList",responseWrapper.prodFamList);
                component.set("v.dateList",responseWrapper.sdRecords);
                component.set("v.visionUpdateDate",responseWrapper.visionUpdateDate);
                
                console.log('dateList',+JSON.stringify(component.get("v.dateList")));
                	  var data=component.get("v.accGroupList");
                   var productName = data;
                    component.set('v.productName', productName);
                    console.log('productName-----'+JSON.stringify(productName))
                    console.log('data-----'+JSON.stringify(data))
                
        
            }
            else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(getBidInfoAction);
        
   },
     closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", false);
      
    },
     openModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
      
    },
})