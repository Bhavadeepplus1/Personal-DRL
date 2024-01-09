({
    init : function(component, event, helper) {
        //console.log('selected quarter'+component.get("v.Heading"))
        const fiscalYear = helper.getCurrentFiscalYear().toString().slice(-2);
		helper.getWestSalesData(component, event, helper,fiscalYear);
        helper.showVisionUpdateDate(component, event, helper,fiscalYear);
        
        var Annuallabel = 'FY ' + fiscalYear + ' Annual';
        var Q1label = 'FY ' + fiscalYear + ' Quarter 1';
        var Q2label = 'FY ' + fiscalYear + ' Quarter 2';
        var Q3label = 'FY ' + fiscalYear + ' Quarter 3';
        var Q4label = 'FY ' + fiscalYear + ' Quarter 4';
        var opt = [
            {label:Annuallabel , value:Annuallabel },
            {label:Q1label , value:Q1label },
            {label:Q2label , value:Q2label },
            {label:Q3label , value:Q3label },
            {label:Q4label , value:Q4label },
            
        ];
        component.set('v.options',opt);
        component.set('v.selectedValue',Annuallabel);
        console.log('fiscal data is ---->'+Annuallabel+''+Q1label);
        
        
    },
    
    
    changeQuarterData : function(component, event, helper){
        const fiscalYear = helper.getCurrentFiscalYear().toString().slice(-2);
        helper.getData(component, event, helper,fiscalYear);
        helper.getWestSalesData(component, event, helper,fiscalYear);
        helper.getEastSalesData(component, event, helper,fiscalYear);
        
    },
    
   redirectToAchivementSummary : function(component, event, helper) {
      var navService = component.find("navService");
        var pageReference = {
            "type": "standard__component",
            "attributes": {
                "componentName": "c__AchievementSummaryTable"  // c__YourComponentName
            }
        }
      /*   component.set("v.pageReference", pageReference);
        const navService = component.find('navService');
        const pageRef = component.get('v.pageReference');
        const handleUrl = (url) => {
            window.open(url);
        };
            const handleError = (error) => {
            console.log(error);
        };
            navService.generateUrl(pageRef).then(handleUrl, handleError);*/
        navService.navigate(pageReference);
    },
    
    
    openModal : function(component, event, helper) {
        var navService = component.find("navService");
        var pageReference = {
            "type": "standard__component",
            "attributes": {
                "componentName": "c__directExlusionCustomersAchievementSummary"  // c__YourComponentName
            }
        }
        navService.navigate(pageReference);
    }, 
    
    hideModel : function(component, event, helper){
        
        component.set("v.isModalHidden",false);
        
    },
    
    directSalesfunc : function(component, event, helper){
        
        var SalesRepName = event.currentTarget.value;
        var SalesRepName = event.currentTarget;
        var value = SalesRepName.dataset.value;
        var quarter = component.get("v.Heading");
        console.log('SalesRepName value==>'+value);
      
        
        var pageReference = {
            type: "standard__component",
           attributes: {
                componentName: "c__DetailedViewOfDirectSalesData"  // c__YourComponentName
            },
           state: {
                c__salesRepName:value,
                c__quarter : quarter,
            }
        }
        //component.set("v.pageReference", pageReference);
         //var navService = component.find("navService");
        //navService.navigate(pageReference);
        component.set("v.pageReference", pageReference);
        var navService = component.find('navService');
        const pageRef = component.get('v.pageReference');
        const handleUrl = (url) => {
            window.open(url);
        };
            const handleError = (error) => {
            console.log(error);
        };
            navService.generateUrl(pageRef).then(handleUrl, handleError);
        
    },
     indirectSalesfunc : function(component, event, helper){
         var SalesRepName = event.currentTarget.value;
        var SalesRepName = event.currentTarget;
        var value = SalesRepName.dataset.value;
        var quarter = component.get("v.Heading");
        console.log('quarter indirect'+quarter);
        console.log('SalesRepName value==>'+value);
      
        
        var pageReference = {
            type: "standard__component",
           attributes: {
                componentName: "c__DetailedViewOfIndirectSalesData"  // c__YourComponentName
            },
           state: {
                c__salesRepName:value,
                c__quarter : quarter,
            }
        }
        //component.set("v.pageReference", pageReference);
         //var navService = component.find("navService");
        //navService.navigate(pageReference);
        component.set("v.pageReference", pageReference);
        var navService = component.find('navService');
        const pageRef = component.get('v.pageReference');
        const handleUrl = (url) => {
            window.open(url);
        };
            const handleError = (error) => {
            console.log(error);
        };
            navService.generateUrl(pageRef).then(handleUrl, handleError);
     }
})