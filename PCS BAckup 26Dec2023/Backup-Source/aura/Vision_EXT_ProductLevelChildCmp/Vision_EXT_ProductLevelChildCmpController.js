({
	doInit : function(component, event, helper) {
        var singleRec = component.get("v.singleRec");
        if(singleRec.salesdl > singleRec.SalesDollarPrev){
            component.set("v.classS", 'green');
        } else if(singleRec.salesdl < singleRec.SalesDollarPrev){
            component.set("v.classS", 'red');
        } else{
            component.set("v.classS", 'yellow');
        }
        if(singleRec.units > singleRec.UnitsPrev){
            component.set("v.classV", 'green');
        } else if(singleRec.units < singleRec.UnitsPrev){
            component.set("v.classV", 'red');
        } else{
            component.set("v.classV", 'yellow');
        }
        if(singleRec.tptdollar > singleRec.TPTDollarPrev){
            component.set("v.classT", 'green');
        } else if(singleRec.tptdollar < singleRec.TPTDollarPrev){
            component.set("v.classT", 'red');
        } else{
            component.set("v.classT", 'yellow');
        }
        if(singleRec.tptpct > singleRec.TPTPctPrev){
            component.set("v.classP", 'green');
        } else if(singleRec.tptpct < singleRec.TPTPctPrev){
            component.set("v.classP", 'red');
        } else{
            component.set("v.classP", 'yellow');
        }
        if(singleRec.trendingSales < 0){
            component.set("v.isSalesLessThanZero", true);
        }
        if(singleRec.trendingVolume < 0){
            component.set("v.isUnitsLessThanZero", true);
        }
        if(singleRec.trendingTPT < 0){
            component.set("v.isTPTLessThanZero", true);
        }
        if(singleRec.trendingTPTPercent < 0){
            component.set("v.isTPTPercentLessThanZero", true);
        }
	},
    handleClick: function(component, event, helper){
        console.log('Clicked..');
    },
   	callParentMethod : function(component, event, helper) {
        //Call Parent aura method
        var parentComponent = component.get("v.parent");                         
		parentComponent.childToParentMethod(component.get("v.singleRec.custId"), component.get("v.rowIndex"));
    },
    redirectToProducts: function(component, event, helper){
        var selectedComparision = component.get("v.comparison");
        console.log('selectedValue--->'+selectedComparision);
        console.log('showtpt-->'+component.get("v.isEXTChecked"));
       // var showTPT = component.get("v.isEXTChecked");
       // console.log('shoe tpt page-->'+showTPT);
        var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'c__Vision_DRLSales_Products_MyDivision'
            },
            state: {
                c__refAccId: component.get("v.singleRec.custId"),
                c__refAccName: component.get("v.singleRec.custName"),
                c__selectedComparision : selectedComparision,
                c__isRxChecked : component.get("v.isRxChecked"),
                c__isSRxChecked : component.get("v.isSRxChecked"),
                c__isOTCChecked : component.get("v.isOtcChecked"),
                c__showTPT : component.get("v.isEXTChecked")
                
            }
        };
        
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