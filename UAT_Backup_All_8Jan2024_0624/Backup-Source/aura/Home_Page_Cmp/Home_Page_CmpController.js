({
    doInit : function(component, event, helper) {
         console.log('in home test')
        //helper.getloginDetails(component, event, helper);
        //  component.set('v.loaded',true);
        //  
        var getBidInfoAction = component.get("c.getRecentOpportunities");
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                //  component.set('v.loaded',false);
                var responseWrapper=response.getReturnValue();
                var optyList = responseWrapper.oppList;
                component.set("v.responseObj",responseWrapper);
                console.log('response---15'+JSON.stringify(responseWrapper));
                console.log('response---16'+JSON.stringify(responseWrapper));
                var oppList1=[];
                for(var i=0;i< optyList.length;i++){
                    var prodOpp = '';
                    var count = 0;
                    var totalcount = optyList[i].Product_Opportunity__r != undefined ? optyList[i].Product_Opportunity__r.length : 0;
                    if(totalcount != 0){
                        for(var j=0;j<optyList[i].Product_Opportunity__r.length;j++){
                            if(optyList[i].Product_Opportunity__r[j].Vision_Bid__c!=null)
                                count++; 
                        }
                    }
                    if(count!=totalcount){
                    var finalcount = count+"/"+totalcount;
                    
                    oppList1.push({"opp":optyList[i],"count":finalcount});
                    }
                    
                }
                component.set("v.opplist",oppList1);
            }
            else
                console.log('errot---'+JSON.stringify(response.getError()));
        });
        $A.enqueueAction(getBidInfoAction);
        
    },
    handleClick : function(component, event, helper) {
        console.log('Id Name---'+event.getSource().get('v.name')); 
        var accId = event.getSource().get('v.name');
        console.log('Id Name accid---'+accId); 
        
        /*   var event = $A.get("e.force:navigateToComponent");
        event.setParams({
            componentDef : "c:Vision_Share_Expansion",
            componentAttributes: {
                accId : event.getSource().get('v.name')
              
            }
        });
        event.fire();*/
    /*     var navService = component.find("navService");
     var pageReference = {
                         "type": "standard__component",
                         "attributes": {
                                         "componentName": "c__Vision_Share_Expansion"
                        state: {
                c__accId:accId
               
            }
        }, true);
     navService.navigate(pageReference);*/
      component.find("navigationService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__Vision_Share_Expansion" },
            state: {
                c__accId: '0011K00002RDd6lQAD'
               
            }
        }, true);
    },
    showSAdetails : function(component, event, helper){
        var listValues = event.currentTarget.id;
        document.getElementById(listValues+'contact').style.display="";
    },
    hideSAdetails : function(component, event, helper){
        var listValues = event.currentTarget.id;
        document.getElementById(listValues+"contact").style.display="none";
    },
})