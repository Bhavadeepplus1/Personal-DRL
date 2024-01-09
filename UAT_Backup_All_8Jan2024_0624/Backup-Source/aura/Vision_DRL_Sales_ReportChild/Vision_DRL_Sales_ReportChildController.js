({
    doInit : function(component, event, helper) {
            var singleRec = component.get("v.responseList");
            console.log("singleRec length==>"+singleRec.length)
            for(var i=0;i<singleRec.length;i++){ 
                  console.log("singleRec ==>"+singleRec[0].units)
                  console.log("singleRec ==>"+singleRec[0].UnitsPrev)
            if(singleRec[i].salesdl > singleRec[i].SalesDollarPrev){
                component.set("v.classS", 'green');
            } else if(singleRec[i].salesdl < singleRec[i].SalesDollarPrev){
                component.set("v.classS", 'red');
            } else{
                component.set("v.classS", 'yellow');
            }
            if(singleRec[i].units > singleRec[i].UnitsPrev){
                component.set("v.classV", 'green');
            } else if(singleRec[i].units < singleRec[i].UnitsPrev){
                component.set("v.classV", 'red');
            } else{
                component.set("v.classV", 'yellow');
            }
            if(singleRec[i].tptdollar > singleRec[i].TPTDollarPrev){
                component.set("v.classT", 'green');
            } else if(singleRec[i].tptdollar < singleRec[i].TPTDollarPrev){
                component.set("v.classT", 'red');
            } else{
                component.set("v.classT", 'yellow');
            }
            if(singleRec[i].tptpct > singleRec[i].TPTPctPrev){
                component.set("v.classP", 'green');
            } else if(singleRec[i].tptpct < singleRec[i].TPTPctPrev){
                component.set("v.classP", 'red');
            } else{
                component.set("v.classP", 'yellow');
            }
            if(singleRec[i].trendingSales < 0){
                component.set("v.isSalesLessThanZero", true);
            }
            if(singleRec[i].trendingVolume < 0){
                component.set("v.isUnitsLessThanZero", true);
            }
            if(singleRec[i].trendingTPT < 0){
                component.set("v.isTPTLessThanZero", true);
            }
            if(singleRec[i].trendingTPTPercent < 0){
                component.set("v.isTPTPercentLessThanZero", true);
            }
            }
        
    },
    handleClick: function(component, event, helper){
        console.log('Clicked..');
    },
    callParentMethod : function(component, event, helper) {
        //Call Parent aura method
        var parentComponent = component.get("v.parent");
        var clickedCell = event.currentTarget;

    // Retrieve the value from the data-value attribute
    var custId = clickedCell.dataset.value;
    var index = clickedCell.dataset.index;
    console.log('Index==>'+index);
        parentComponent.childToParentMethod(custId, index);
    },
    redirectToProducts: function(component, event, helper){
        var selectedComparision = component.get("v.comparison");
        console.log('selectedValue--->'+selectedComparision);
        console.log('showtpt-->'+component.get("v.isINTChecked"));
       var clickedCell = event.currentTarget;

    // Retrieve the value from the data-value attribute
    var custId = clickedCell.dataset.value;
 	var custName = clickedCell.dataset.name;
        var custCode = clickedCell.dataset.code;
    // Do something with the value
    console.log('custId==>'+JSON.stringify(custId));
        
 		 console.log('name==>'+custName);
 
        // var showTPT = component.get("v.isINTChecked");
        // console.log('shoe tpt page-->'+showTPT);
        var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'c__Vision_DRL_Sales_Products_Report'
            },
            state: {
                c__refAccId: custId,//component.get("v.singleRec.custId"),
                c__refAccName: custName,//component.get("v.singleRec.custName"),
                c__refAccCode: custCode,//component.get("v.singleRec.custCode"),
                c__selectedComparision : selectedComparision,
                c__isRxChecked : component.get("v.isRxChecked"),
                c__isSRxChecked : component.get("v.isSRxChecked"),
                c__isOTCChecked : component.get("v.isOtcChecked"),
                c__showTPT : component.get("v.isINTChecked"),
                c__ShowINT:component.get("v.ShowINT")
                
            }
        };
        console.log('ShowINT-->'+component.get("v.isINTChecked"));
        component.set("v.pageReference", pageReference);
        const navService = component.find('navService');
        const pageRef = component.get('v.pageReference');
        const handleUrl = (url) => {
            window.open(url);
        };
            const handleError = (error) => {
            console.log(error);
        };
            navService.generateUrl(pageRef).then(handleUrl, handleError);
        },
            
        })