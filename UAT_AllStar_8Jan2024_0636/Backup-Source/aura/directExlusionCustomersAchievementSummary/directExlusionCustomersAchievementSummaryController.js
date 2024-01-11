({
	init : function(component, event, helper) {
        
        helper.ExcludedEastSalesrepTargetData(component, event, helper);
        helper.ExcludedWestSalesrepTargetData(component, event, helper);
        var d =  new Date();
          console.log('current month==>'+Math.floor(d.getMonth()+1))
          var currentMonth = Math.floor(d.getMonth()+1);
          var quarter1 = [4,5,6];
          var quarter2 = [7,8,9];
          var quarter3 = [10,11,12];
          var quarter4 = [1,2,3];
          if(quarter1.includes(currentMonth)){
               component.set("v.Q1_in_Progress",true);
          }
          else if(quarter2.includes(currentMonth)){
              component.set("v.Q2_in_Progress",true);
          }
              else if(quarter3.includes(currentMonth)){
                  component.set("v.Q3_in_Progress",true);
              }
		  else if(quarter4.includes(currentMonth)){
              component.set("v.Q4_in_Progress",true);
          }
		
	},
    
    navigateToSummary : function(component, event, helper) {
        var navService = component.find("navService");
        var pageReference = {
            "type": "standard__component",
            "attributes": {
                "componentName": "c__AchievementSummaryTable"  // c__YourComponentName
            }
        }
        navService.navigate(pageReference);
    }, 
})