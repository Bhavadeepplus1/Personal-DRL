({
	doInit : function(component, event, helper) {
        var product = component.get("v.product");
        var productsMap = component.get("v.productsMap");
        var relatedList = productsMap[product];
        var productSummaryObj = {};
        var totalCOLO = 0; var totalTPTDollar = 0;
        if(relatedList != null){
            for(var i=0; i<relatedList.length; i++){
                totalCOLO += ((relatedList[i].grossCOLO != null && !isNaN(relatedList[i].grossCOLO)) ? parseFloat(relatedList[i].grossCOLO): 0);
                totalTPTDollar += ((relatedList[i].tptDollar != null && !isNaN(relatedList[i].tptDollar)) ? parseFloat(relatedList[i].tptDollar) : 0);
                /*console.log('Type: '+typeof relatedList[i].tptDollar);
                console.log('relatedList[i].tptDollar: '+relatedList[i].tptDollar);*/
            }
        }
        productSummaryObj.finalCOLO = parseInt(totalCOLO);
        productSummaryObj.finalTPTDollar = parseInt(totalTPTDollar);
        component.set("v.productSummaryObj", productSummaryObj);
        component.set("v.relatedList", relatedList); 
    },
    expandProductList: function(component, event, helper){
        component.set("v.expandProduct", !component.get("v.expandProduct"));
    }
})