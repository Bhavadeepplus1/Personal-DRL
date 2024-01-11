({
    doInit: function(component, event, helper){
         console.log('doinit');
         var data = component.get("v.accGroupList");
         console.log('data---'+JSON.stringify(data));
        console.log('data doh---'+JSON.stringify(data.dohRecords));
         for(var i=0; i<data.dohRecords.length; i++){
            if(data.dohRecords[i].QoH_Qty_Sold__c > 5 && data.dohRecords[i].QoH_Qty_Sold__c <= 11 && data.dohRecords[i].QoH_Qty_Sold_Pct__c >100){
                data.dohRecords[i].W4QtySold = true;
            }
              else if(data.dohRecords[i].QoH_Qty_Sold__c > 11 && data.dohRecords[i].QoH_Qty_Sold__c <= 21 && data.dohRecords[i].QoH_Qty_Sold_Pct__c >50){
                data.dohRecords[i].W4QtySold = true;
            }
              else if(data.dohRecords[i].QoH_Qty_Sold__c > 21 && data.dohRecords[i].QoH_Qty_Sold__c <= 100 && data.dohRecords[i].QoH_Qty_Sold_Pct__c >25){
                data.dohRecords[i].W4QtySold = true;
            }
              else if(data.dohRecords[i].QoH_Qty_Sold__c > 100 && data.dohRecords[i].QoH_Qty_Sold_Pct__c >20){
                data.dohRecords[i].W4QtySold = true;
            }
        }
        component.set("v.accGroupList",data);
    
        
                //var responseWrapper=response.getReturnValue();
                 //component.set("v.accGroupList",data.accList);
                 //component.set("v.DoHSummaryList",responseWrapper.dohSummary);
                 
       
},
    showToolTip : function(component) {
        console.log('show');
        component.set("v.tooltip" , true);
        
    },
    HideToolTip : function(component){
        component.set("v.tooltip" , false);
    },
    openModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        
        component.set('v.loaded',true);
        var recId = event.currentTarget.dataset.id;
        console.log('someVal1 --> '+event.currentTarget.dataset.name);
        //event.target.value;//event.getSource().get("v.value");//
        console.log('sku code----'+recId);
       // console.log('acc code----'+component.get("v.recordId"));
        var getBidInfoAction = component.get("c.getAwardedPositionData");
        getBidInfoAction.setParams({
            
           // customerId :component.get("v.recordId"),
            Id :recId
        });
        console.log('Hiiii');
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                console.log('success');
                component.set('v.loaded',false);
                var responseWrapper=response.getReturnValue();
                console.log('awardedPosition-->'+JSON.stringify(responseWrapper));
                component.set("v.awardedPosition",responseWrapper.awardedPositionList);
                  component.set("v.ProdName",responseWrapper.ProdName);
                  component.set("v.Ndc",responseWrapper.Ndc);
                component.set("v.isModalOpen", true);
            }
            else{
                component.set('v.loaded',false);
                console.log('errot---'+JSON.stringify(response.getError()));
            }
            
        });
        $A.enqueueAction(getBidInfoAction);
        
    },
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", false);
        
    },
    callCmp: function(component, event, helper){
      component.find("navigationService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__Vison_DOH_Low_Inventory" }, //c__Vision_GCP_Short_Date
            
        }, true);
    },
    redirectOrder: function(component, event, helper){
        component.find("navigationService").navigate({
            type: "standard__navItemPage",
            target:"_blank",
            attributes: {
                apiName: "home"
            },
         
        }, true);
    }
})