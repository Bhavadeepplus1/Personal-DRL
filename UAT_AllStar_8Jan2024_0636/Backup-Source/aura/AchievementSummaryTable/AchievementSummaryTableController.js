({
      init : function(component, event, helper) {
       
         var fiscal = helper.getCurrentFiscalYear().toString().slice(-2);
         component.set('v.fiscalYear',fiscal);
		 helper.getData(component, event, helper);
         helper.getEastData(component, event, helper);
          
          var d =  new Date();
          console.log('current month==>'+Math.floor(d.getMonth()+1))
          var currentMonth = Math.floor(d.getMonth()+1);
          var quarter1 = [4,5,6];
          var quarter2 = [7,8,9];
          var quarter3 = [10,11,12];
          var quarter4 = [1,2,3];
          if(quarter1.includes(currentMonth)){
             //component.set("v.in_Progress",true);
               component.set("v.Q1_in_Progress",true);
          }
          else if(quarter2.includes(currentMonth)){
              //component.set("v.in_Progress",true);
              component.set("v.Q2_in_Progress",true);
          }
              else if(quarter3.includes(currentMonth)){
                  //component.set("v.in_Progress",true);
                  component.set("v.Q3_in_Progress",true);
              }
		  else if(quarter4.includes(currentMonth)){
              //component.set("v.in_Progress",true);
              component.set("v.Q4_in_Progress",true);
          }
         /* if(isasc) {
              component.set("v.isAscAnnual", false);
          }else{
              component.set("v.isAscAnnual", true);
          }*/
         
      },
    
	  
   redirectToLeaderboard : function(component, event, helper) {
        component.set('v.loaded', true);
       //console.log('redirection called 58');
      var navService = component.find("navService");
       
        var pageReference = {
            "type": "standard__component",
            "attributes": {
                "componentName": "c__SRxAchievementTracker"  // c__YourComponentName
            },
            "state": {
                //"invokeFunction": "navigate",
        	}
        }
        
       
       
   /*    var urlEvent = $A.get("e.force:navigateToURL");
       urlEvent.setParams({
           "url": "https://drreddysnag--uat.sandbox.lightning.force.com/lightning/n/SRx_Achievement_Tracker?c__tabId=1"
       });
       urlEvent.fire();*/
       
     /*  var evt = $A.get("e.force:navigateToComponent");
       evt.setParams({
           componentDef : "c:SRxAchievementTracker",
           componentAttributes: {
               c_tab :1,   
           }
       });
       evt.fire();*/
       
       
       
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
           component.set('v.loaded', false);
       console.log('redirection called 58');
    } ,
     sortByQuarterOne : function(component, event, helper){
       console.log('in sortByQuarterOne');
         var isasc = component.get("v.isAscQ1");
         if(isasc) {
        component.set("v.isAscQ1", false);
         }else{
             component.set("v.isAscQ1", true);
         }
        component.set("v.sortField",'percentage_for_Q1');
        helper.sortByWestData(component,'percentage_for_Q1', helper,isasc);
    }, 
     sortByQuarterTwo : function(component, event, helper){
       console.log('in sortByQuarterTwo');
         var isasc = component.get("v.isAscQ2");
         if(isasc) {
        component.set("v.isAscQ2", false);
         }else{
             component.set("v.isAscQ2", true);
         }
        component.set("v.sortField",'percentage_for_Q2');
        helper.sortByWestData(component,'percentage_for_Q2', helper,isasc);
    }, 
    sortByQuarterThree : function(component, event, helper){
       console.log('in sortByQuarterThree');
         var isasc = component.get("v.isAscQ3");
         if(isasc) {
        component.set("v.isAscQ3", false);
         }else{
             component.set("v.isAscQ3", true);
         }
        component.set("v.sortField",'percentage_for_Q3');
        helper.sortByWestData(component,'percentage_for_Q3', helper,isasc);
    }, 
    sortByQuarterFour : function(component, event, helper){
       console.log('in sortByQuarterThree');
         var isasc = component.get("v.isAscQ4");
         if(isasc) {
        component.set("v.isAscQ4", false);
         }else{
             component.set("v.isAscQ4", true);
         }
        component.set("v.sortField",'percentage_for_Q4');
        helper.sortByWestData(component,'percentage_for_Q4', helper,isasc);
    },
    sortByAnnual : function(component, event, helper){
         var isasc = component.get("v.isAscAnnual");
         if(isasc) {
        component.set("v.isAscAnnual", false);
         }else{
             component.set("v.isAscAnnual", true);
         }
        component.set("v.sortField",'annualPercent');
        helper.sortByWestData(component,'annualPercent', helper,isasc);
    }, 
    sortByQuarterOneEast : function(component, event, helper){
         var isasc = component.get("v.isAscEastQ1");
         if(isasc) {
        component.set("v.isAscEastQ1", false);
         }else{
             component.set("v.isAscEastQ1", true);
         }
        component.set("v.sortField",'percentage_for_Q1');
        helper.sortByEastData(component,'percentage_for_Q1', helper,isasc);
    }, 
    sortByQuarterTwoEast : function(component, event, helper){
       console.log('in sortByQuarterTwo');
         var isasc = component.get("v.isAscEastQ2");
         if(isasc) {
        component.set("v.isAscEastQ2", false);
         }else{
             component.set("v.isAscEastQ2", true);
         }
        component.set("v.sortField",'percentage_for_Q2');
        helper.sortByEastData(component,'percentage_for_Q2', helper,isasc);
    }, 
    sortByQuarterThreeEast : function(component, event, helper){
       console.log('in sortByQuarterThree');
         var isasc = component.get("v.isAscEastQ3");
         if(isasc) {
        component.set("v.isAscEastQ3", false);
         }else{
             component.set("v.isAscEastQ3", true);
         }
        component.set("v.sortField",'percentage_for_Q3');
        helper.sortByEastData(component,'percentage_for_Q3', helper,isasc);
    }, 
    sortByQuarterFourEast : function(component, event, helper){
         var isasc = component.get("v.isAscEastQ4");
         if(isasc) {
        component.set("v.isAscEastQ4", false);
         }else{
             component.set("v.isAscEastQ4", true);
         }
        component.set("v.sortField",'percentage_for_Q4');
        helper.sortByEastData(component,'percentage_for_Q4', helper,isasc);
    },
    sortByAnnualEast : function(component, event, helper){
         var isasc = component.get("v.isAscEastAnnual");
         if(isasc) {
        component.set("v.isAscEastAnnual", false);
         }else{
             component.set("v.isAscEastAnnual", true);
         }
        component.set("v.sortField",'annualPercent');
        helper.sortByEastData(component,'annualPercent', helper,isasc);
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
    
    
})