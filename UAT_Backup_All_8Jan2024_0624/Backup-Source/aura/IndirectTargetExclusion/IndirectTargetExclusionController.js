({
	init : function(component, event, helper) {
        
        component.set("v.isSpinnerLoad",true);
        helper.getSalesRepName(component, event, helper);
        helper.getContractsName(component, event, helper);
        helper.getCustomerName(component, event, helper);
        helper.getProducts(component, event, helper);
        //helper.GetData(component, event, helper)
		
	},
    
    redirectToAchievementSummary : function(component, event, helper) {
        
        var navService = component.find("navService");
        var pageReference = {
            "type": "standard__component",
            "attributes": {
                "componentName": "c__AchievementSummaryTable"  // c__YourComponentName
            }
        }
        navService.navigate(pageReference);
        
		
	},
    handleScroll:function(component, event, helper){
        var scrollTop = event.target.scrollTop;
         console.log('scrollTop==>'+scrollTop);
        var scrollHeight = event.target.scrollHeight
        console.log('scrollHeight==>'+scrollHeight);
        var clientHeight = event.target.clientHeight
       	console.log('clientHeight==>'+clientHeight);
        var count = component.get("v.count")
        console.log('count==>'+count);
        var allIndirectExclusionList = component.get("v.allIndirectExclusionList")
        var allAccountsLoaded = component.get("v.allAccountsLoaded")
        var IndirectExclusionList = component.get("v.IndirectExclusionList")
     // component.set("v.isSpinnerLoad", true);
        if(((scrollHeight - clientHeight) <= (scrollTop + 10)) && !allAccountsLoaded){
            //load next set of 50 records
            var nextSetOfData = allIndirectExclusionList.slice(count , count+50)
              console.log('nextSetOfData==>'+JSON.stringify(nextSetOfData))
              console.log('nextSetOfData length==>'+nextSetOfData.length)
              for(var i=0;i<nextSetOfData.length;i++){
                  IndirectExclusionList.push(nextSetOfData[i])
              }
            component.set("v.IndirectExclusionList", IndirectExclusionList)
            console.log('chargebackList==>'+JSON.stringify(component.get("v.IndirectExclusionList")))
            console.log('chargebackList length==>'+component.get("v.IndirectExclusionList").length)
            component.set("v.count",count+50);
             component.set("v.isSpinnerLoad", false);
            //logic to check if all data has been loaded
            if(IndirectExclusionList.length === allIndirectExclusionList.length){
                allAccountsLoaded = true;
                component.set("v.allAccountsLoaded", allAccountsLoaded)
                  component.set("v.isSpinnerLoad", false);
            }
        }
    },
    searchHandler:function(component, event, helper){
        component.set("v.isSpinnerLoad",true);
        component.set("v.IndirectExclusionList",null)
        helper.GetData(component, event, helper)
    }
})