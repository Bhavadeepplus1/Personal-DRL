({
    doInit : function(component, event, helper) {
        var id = component.get("v.recordId");
        component.set("v.NoData", true);
        var action = component.get("c.getRecent");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) { 
            if(response.getState() == "SUCCESS"){ 
                var wrapperCls=response.getReturnValue();
                
                component.set("v.recentAwards",wrapperCls.recentPrimaryMainWrapList);
                component.set("v.recentDecreases",wrapperCls.recentDecreasesMainWrapList);
                component.set("v.ProductLosses",wrapperCls.productLossesMainWrapList);
                component.set("v.unsucessBid",wrapperCls.unsuccessfulBidsWrapList);
                console.log('Prod name---'+JSON.stringify(wrapperCls.unsuccessfulBidsWrapList));
                var currentYear = wrapperCls.currentDate;
                var FYSales = 'FY' + currentYear +' ' +'Sales';
                var FYImpact = 'FY' + currentYear +' ' +'Impact';
                var FYProdLoss = 'FY' + currentYear +' ' +'Sales';
                component.set("v.FYSales",FYSales);
                component.set("v.FYImpact",FYImpact);
                component.set("v.FYProdLoss",FYProdLoss);
                var annualSalesRecent = 0;
                var FYSalesRecent = 0;
                var annualSalesrecentDec = 0;
                var FYSalesrecentDecrease = 0;
                var annualSalesProdLoss = 0;
                var FYSalesrecentProdLoss = 0;
                wrapperCls.recentPrimaryMainWrapList.forEach(function(bid){
                    console.log('pkgSize---'+JSON.stringify(bid));
                    annualSalesRecent = annualSalesRecent + bid.annualSales;
                    FYSalesRecent = FYSalesRecent + bid.FYSales;
                    
                });
                component.set("v.annualSalesRecent",annualSalesRecent);
                component.set("v.FYSalesRecent",FYSalesRecent);
                wrapperCls.recentDecreasesMainWrapList.forEach(function(bid){
                    console.log('pkgSize---'+JSON.stringify(bid));
                    annualSalesrecentDec += bid.annualSalesrecentDec;
                    FYSalesrecentDecrease += bid.FYImpactrecentDec;
                    
                });
                component.set("v.annualSalesrecentDec",annualSalesrecentDec);
                component.set("v.FYSalesrecentDec",FYSalesrecentDecrease);
                console.log('FYSalesrecentDec---'+FYSalesrecentDecrease);
                console.log('annualSalesrecentDec---'+annualSalesrecentDec);
                wrapperCls.productLossesMainWrapList.forEach(function(bid){
                    console.log('pkgSize---'+JSON.stringify(bid));
                    annualSalesProdLoss += bid.annualSalesProdLoss;
                    FYSalesrecentProdLoss += bid.FYSalesImpactProdLoss;
                    
                });
                component.set("v.annualSalesProdLossTotal",annualSalesProdLoss);
                component.set("v.FYSalesrecentProdLossTotal",FYSalesrecentProdLoss);
                console.log('FYSalesrecentProdLoss---'+FYSalesrecentProdLoss);
                console.log('annualSalesProdLoss---'+annualSalesProdLoss);
            }
            else{
                console.log('error');
            }
        });
        $A.enqueueAction(action);  
    },
    
    showReport : function(component, event, helper) {
        component.set("v.showReport", true);
    }
})