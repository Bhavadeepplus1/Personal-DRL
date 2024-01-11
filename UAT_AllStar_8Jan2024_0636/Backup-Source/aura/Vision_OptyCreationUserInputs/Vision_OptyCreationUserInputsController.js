({
    doInit: function(component, event, helper){
        console.log('component.get("v.optyObj") IN userInputs----> '+component.get("v.optyObj"));
        console.log('Single Comp Info Data ::: '+JSON.stringify(component.get("v.singleCompInfoRec")));
        if(component.get("v.isRecordSaved")){
            component.set("v.proposedUnitsVal", component.get("v.singleSavedRec.Vision_Proposed_Units__c"));
            component.set("v.guidancePriceVal", component.get("v.singleSavedRec.Vision_Guidance_Price__c"));
            component.set("v.priceRangeVal", component.get("v.singleSavedRec.Vision_Price_Range__c"));
            component.set("v.salesPriceVal", component.get("v.singleSavedRec.Vision_Sales_Price__c"));
            component.set("v.selectedCompetitorId", component.get("v.singleSavedRec.Vision_Incumbent_Competitor__r.Id"));
            component.set("v.selectedCompetitorName", component.get("v.singleSavedRec.Vision_Incumbent_Competitor__r.Name"));
            component.set("v.opportunityVal", component.get("v.singleSavedRec.Vision_Opportunity_Value__c"));
            component.set("v.lowestPriceVal", component.get("v.singleSavedRec.Lowest_Price_SKU__c"));
            component.set("v.incumbentCompId1", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name__r.Id"));
            component.set("v.incumbentCompId2", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_2__r.Id"));
            component.set("v.incumbentCompId3", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_3__r.Id"));
            component.set("v.incumbentCompId4", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_4__r.Id"));
            component.set("v.incumbentCompId5", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_5__r.Id"));
            component.set("v.incumbentComp1", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name__r.Name"));
            component.set("v.incumbentComp2", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_2__r.Name"));
            component.set("v.incumbentComp3", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_3__r.Name"));
            component.set("v.incumbentComp4", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_4__r.Name"));
            component.set("v.incumbentComp5", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_5__r.Name"));
            component.set("v.priceRange1", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range__c"));
            component.set("v.priceRange2", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range_2__c"));
            component.set("v.priceRange3", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range_3__c"));
            component.set("v.priceRange4", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range_4__c"));
            component.set("v.priceRange5", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range_5__c"));
            
            console.log('Single Record:: '+JSON.stringify(component.get("v.singleSavedRec")));
            console.log('Competitors are::: '+component.get("v.listOfCompetitors"));
        } else{
            /*var actioncn = component.get("c.fetchCompetitorInfoByProd");
            actioncn.setParams({
                "prodRec" : component.get("v.singleRec.prdlist")
            });
            actioncn.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    component.set("v.AccountName", storeResponse);
                }
            });
            $A.enqueueAction(actioncn);
            
            */
            var CompInfoData = component.get("v.singleCompInfoRec");
            component.set("v.proposedUnitsVal", component.get("v.singleRec.proposedUnitsVal"));
            component.set("v.guidancePriceVal", component.get("v.singleRec.guidancePriceVal"));
            component.set("v.priceRangeVal", component.get("v.singleRec.priceRangeVal"));
            component.set("v.salesPriceVal", component.get("v.singleRec.salesPriceVal"));
            component.set("v.selectedCompetitorId", component.get("v.singleRec.competitorIdVal"));
            component.set("v.selectedCompetitorName", component.get("v.singleRec.competitorVal"));
            component.set("v.opportunityVal", component.get("v.singleRec.opportunityVal"));
            component.set("v.lowestPriceVal", component.get("v.singleRec.prdlist.Phoenix_Lowest_Price_SKU__c"));
            component.set("v.prdFamily", component.get("v.singleSavedRec.prdlist.Family"));
            if (CompInfoData){
                if (CompInfoData.hasOwnProperty('Incumbent_Competitor_Name__r') && CompInfoData["Incumbent_Competitor_Name__r"].hasOwnProperty('Id')){
                    component.set("v.incumbentCompId1", CompInfoData["Incumbent_Competitor_Name__r"]['Id']);
                }
                if (CompInfoData.hasOwnProperty('Incumbent_Competitor_Name_2__r') && CompInfoData["Incumbent_Competitor_Name_2__r"].hasOwnProperty('Id')){
                    component.set("v.incumbentCompId2", CompInfoData["Incumbent_Competitor_Name_2__r"]['Id']);
                }
                if (CompInfoData.hasOwnProperty('Incumbent_Competitor_Name_3__r') && CompInfoData["Incumbent_Competitor_Name_3__r"].hasOwnProperty('Id')){
                    component.set("v.incumbentCompId3", CompInfoData["Incumbent_Competitor_Name_3__r"]['Id']);
                }
                if (CompInfoData.hasOwnProperty('Incumbent_Competitor_Name_4__r') && CompInfoData["Incumbent_Competitor_Name_4__r"].hasOwnProperty('Id')){
                    component.set("v.incumbentCompId4", CompInfoData["Incumbent_Competitor_Name_4__r"]['Id']);
                }
                if (CompInfoData.hasOwnProperty('Incumbent_Competitor_Name_5__r') && CompInfoData["Incumbent_Competitor_Name_5__r"].hasOwnProperty('Id')){
                    component.set("v.incumbentCompId5", CompInfoData["Incumbent_Competitor_Name_5__r"]['Id']);
                }
                if (CompInfoData.hasOwnProperty('Incumbent_Competitor_Name__r') && CompInfoData["Incumbent_Competitor_Name__r"].hasOwnProperty('Name')){
                    component.set("v.incumbentComp1", CompInfoData["Incumbent_Competitor_Name__r"]['Name']);
                }
                if (CompInfoData.hasOwnProperty('Incumbent_Competitor_Name_2__r') && CompInfoData["Incumbent_Competitor_Name_2__r"].hasOwnProperty('Name')){
                    component.set("v.incumbentComp2", CompInfoData["Incumbent_Competitor_Name_2__r"]['Name']);
                }
                if (CompInfoData.hasOwnProperty('Incumbent_Competitor_Name_3__r') && CompInfoData["Incumbent_Competitor_Name_3__r"].hasOwnProperty('Name')){
                    component.set("v.incumbentComp3", CompInfoData["Incumbent_Competitor_Name_3__r"]['Name']);
                }
                if (CompInfoData.hasOwnProperty('Incumbent_Competitor_Name_4__r') && CompInfoData["Incumbent_Competitor_Name_4__r"].hasOwnProperty('Name')){
                    component.set("v.incumbentComp4", CompInfoData["Incumbent_Competitor_Name_4__r"]['Name']);
                }
                if (CompInfoData.hasOwnProperty('Incumbent_Competitor_Name_5__r') && CompInfoData["Incumbent_Competitor_Name_5__r"].hasOwnProperty('Name')){
                    component.set("v.incumbentComp5", CompInfoData["Incumbent_Competitor_Name_5__r"]['Name']);
                }
                if (CompInfoData.hasOwnProperty('Incumbent_Price_Range__c')){
                    component.set("v.priceRange1", CompInfoData["Incumbent_Price_Range__c"]);
                }
                if (CompInfoData.hasOwnProperty('Incumbent_Price_Range_2__c')){
                    component.set("v.priceRange2", CompInfoData["Incumbent_Price_Range_2__c"]);
                }
                if (CompInfoData.hasOwnProperty('Incumbent_Price_Range_3__c')){
                    component.set("v.priceRange3", CompInfoData["Incumbent_Price_Range_3__c"]);
                }
                if (CompInfoData.hasOwnProperty('Incumbent_Price_Range_4__c')){
                    component.set("v.priceRange4", CompInfoData["Incumbent_Price_Range_4__c"]);
                }
                if (CompInfoData.hasOwnProperty('Incumbent_Price_Range_5__c')){
                    component.set("v.priceRange5", CompInfoData["Incumbent_Price_Range_5__c"]);
                }
                /*
            component.set("v.incumbentCompId1", CompInfoData["Incumbent_Competitor_Name__r"]['Id']);
            component.set("v.incumbentCompId2", CompInfoData["Incumbent_Competitor_Name_2__r"]['Id']);
            component.set("v.incumbentCompId3", CompInfoData["Incumbent_Competitor_Name_3__r"]['Id']);
            component.set("v.incumbentCompId4", CompInfoData["Incumbent_Competitor_Name_4__r"]['Id']);
            component.set("v.incumbentCompId5", CompInfoData["Incumbent_Competitor_Name_5__r"]['Id']);
            component.set("v.incumbentComp1", CompInfoData["Incumbent_Competitor_Name__r"]['Name']);
            component.set("v.incumbentComp2", CompInfoData["Incumbent_Competitor_Name_2__r"]['Name']);
            component.set("v.incumbentComp3", CompInfoData["Incumbent_Competitor_Name_3__r"]['Name']);
            component.set("v.incumbentComp4", CompInfoData["Incumbent_Competitor_Name_4__r"]['Name']);
            component.set("v.incumbentComp5", CompInfoData["Incumbent_Competitor_Name_5__r"]['Name']);
            component.set("v.priceRange1", CompInfoData["Incumbent_Price_Range__c"]);
            component.set("v.priceRange2", CompInfoData["Incumbent_Price_Range_2__c"]);
            component.set("v.priceRange3", CompInfoData["Incumbent_Price_Range_3__c"]);
            component.set("v.priceRange4", CompInfoData["Incumbent_Price_Range_4__c"]);
            component.set("v.priceRange5", CompInfoData["Incumbent_Price_Range_5__c"]);*/
                //console.log('incumbentCompId1 assigned:: '+component.get("v.incumbentCompId1"));
                //console.log('incumbentCompId1 act:: '+CompInfoData["Incumbent_Competitor_Name__r"]['Id']);
                //console.log('Single Record:: '+JSON.stringify(component.get("v.singleRec")));
                //console.log('Competitors are::: '+component.get("v.listOfCompetitors"));
            }   
        }
    },
    getProUnits: function (component, event, helper) {
        console.log('Proposed Units::: '+component.get("v.proposedUnitsVal"));
        var val = component.get("v.proposedUnitsVal");
        var salesPrice = component.get("v.salesPriceVal");
        var guidancePrice = component.get("v.guidancePriceVal");
        if(val){
            component.set("v.proposedUnitsVal", val);
            //component.set("v.singleRec.proposedUnitsVal", val);
            if(guidancePrice){
                component.set("v.opportunityVal", Math.round(val * guidancePrice));
            } else if(salesPrice){
                component.set("v.opportunityVal", val * salesPrice);
            } else{
                component.set("v.opportunityVal", val * component.get("v.lowestPriceVal"));
            }
        } else{
            //component.set("v.singleRec.proposedUnitsVal", null);
            component.set("v.proposedUnitsVal", null);
        }
    },
    getGuiPrice: function (component, event, helper) {
        console.log('Guidance Price::: '+component.get("v.guidancePriceVal"));
        var salesPrice = component.get("v.salesPriceVal");
        var proposedUnitVal = component.get("v.proposedUnitsVal");
        var val = component.get("v.guidancePriceVal");
        if(val){
            component.set("v.guidancePriceVal", val);
        } else{
            component.set("v.guidancePriceVal", null);
        }
        if(proposedUnitVal){
            if(val){
                component.set("v.opportunityVal", proposedUnitVal * val);
            } else if(salesPrice){
                component.set("v.opportunityVal", proposedUnitVal * salesPrice);
            } else{
                component.set("v.opportunityVal", proposedUnitVal * component.get("v.lowestPriceVal"));
            }

        }
    },
    
    getPriceRange: function (component, event, helper) {
        console.log('Price Range::: '+component.get("v.priceRangeVal"));
        var val = component.get("v.priceRangeVal");
        if(val){
            component.set("v.priceRangeVal", val);  
        } else{
            component.set("v.priceRangeVal", null);
        }

    },
    getSalesPrice: function(component, event, helper){
        console.log('Sales Changed');
        var val = component.get("v.salesPriceVal");
        var proposedUnitVal = component.get("v.proposedUnitsVal");
        var guidancePrice = component.get("v.guidancePriceVal");
        if(val){
            component.set("v.salesPriceVal", val);
        } else{
            component.set("v.salesPriceVal", null);
        }
        if(proposedUnitVal){
            if(guidancePrice){
                component.set("v.opportunityVal", proposedUnitVal * guidancePrice);
            } else if(val){
                component.set("v.opportunityVal", proposedUnitVal * val);
            } else{
                component.set("v.opportunityVal", proposedUnitVal * component.get("v.lowestPriceVal"));
            }
        }
    },
    save: function(component, event, helper){
        if(component.get("v.isRecordSaved")){
            component.set("v.singleSavedRec.Vision_Proposed_Units__c", component.get("v.proposedUnitsVal"));
            component.set("v.singleSavedRec.Vision_Sales_Price__c",  component.get("v.salesPriceVal"));
            component.set("v.singleSavedRec.Vision_Guidance_Price__c",  component.get("v.guidancePriceVal"));
            component.set("v.singleSavedRec.Vision_Opportunity_Value__c", component.get("v.opportunityVal"));
            component.set("v.singleSavedRec.Vision_Price_Range__c", component.get("v.priceRangeVal"));
            component.set("v.singleSavedRec.Vision_Incumbent_Competitor__r.Id", component.get("v.selectedCompetitorId"));
            component.set("v.singleSavedRec.Vision_Incumbent_Competitor__r.Name", component.get("v.selectedCompetitorName"));
            component.getEvent("DeleteRowEvt").setParams({"indexVar" : 1 }).fire();
        } else{
            component.set("v.singleRec.proposedUnitsVal", component.get("v.proposedUnitsVal"));
            component.set("v.singleRec.salesPriceVal",  component.get("v.salesPriceVal"));
            component.set("v.singleRec.guidancePriceVal",  component.get("v.guidancePriceVal"));
            component.set("v.singleRec.opportunityVal", component.get("v.opportunityVal"));
            component.set("v.singleRec.priceRangeVal", component.get("v.priceRangeVal"));
            component.set("v.singleRec.competitorIdVal", component.get("v.selectedCompetitorId"));
            component.set("v.singleRec.competitorVal", component.get("v.selectedCompetitorName"));
            component.getEvent("DeleteRowEvt").setParams({"indexVar" : 1 }).fire();
        }

    },
    cancel: function(component, event, helper){
        component.getEvent("DeleteRowEvt").setParams({"indexVar" : 0 }).fire();
    },
    saveCompetitorInfo: function(component, event, helper){
        console.log('Save Competitior Info'+ component.get("v.isRecordSaved"));
        component.set("v.showCompetitorInfo",false);
        if(component.get("v.isRecordSaved")){
            
            if(component.find('CIComName').get('v.value')){
                component.set("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name__c", component.find('CIComName').get('v.value'));
                /*let callMsgResp = helper.fetchCompInfoChanges(component,helper,component.find('CIComName').get('v.value'));
                console.log('callMsgResp :'+JSON.stringify(callMsgResp));
                if(callMsgResp.Id){
                    component.set("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name__c", callMsgResp.Id);
                    //component.set("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name__r.Name", callMsgResp.Name);
                } */  
            }
            if(component.find('CIComName2').get('v.value')){
                component.set("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_2__c", component.find('CIComName2').get('v.value'));
            }
            if(component.find('CIComName3').get('v.value')){
                component.set("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_3__c", component.find('CIComName3').get('v.value'));
            }
            if(component.find('CIComName4').get('v.value')){
                component.set("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_4__c", component.find('CIComName4').get('v.value'));
           }
            if(component.find('CIComName5').get('v.value')){
                component.set("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_5__c", component.find('CIComName5').get('v.value'));
            }
            
            component.set("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range__c", component.get("v.priceRange1"));
            component.set("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range_2__c", component.get("v.priceRange2"));
            component.set("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range_3__c", component.get("v.priceRange3"));
            component.set("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range_4__c", component.get("v.priceRange4"));
            component.set("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range_5__c", component.get("v.priceRange5"));
            console.log('v.singleSavedRec :: '+JSON.stringify(component.get("v.singleSavedRec")));
        } else{
            if(component.find('CIComName').get('v.value')){
            	component.set("v.singleRec.incumbentCompId1", component.find('CIComName').get('v.value'));
            }
            component.set("v.incumbentCompId2", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_2__r.Id"));
            component.set("v.incumbentCompId3", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_3__r.Id"));
            component.set("v.incumbentCompId4", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_4__r.Id"));
            component.set("v.incumbentCompId5", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_5__r.Id"));
            component.set("v.incumbentComp1", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name__r.Name"));
            component.set("v.incumbentComp2", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_2__r.Name"));
            component.set("v.incumbentComp3", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_3__r.Name"));
            component.set("v.incumbentComp4", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_4__r.Name"));
            component.set("v.incumbentComp5", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Competitor_Name_5__r.Name"));
            component.set("v.priceRange1", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range__c"));
            component.set("v.priceRange2", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range_2__c"));
            component.set("v.priceRange3", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range_3__c"));
            component.set("v.priceRange4", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range_4__c"));
            component.set("v.priceRange5", component.get("v.singleSavedRec.Vision_Incumbent_Competitor_Info__r.Incumbent_Price_Range_5__c"));
            
            component.set("v.singleRec.proposedUnitsVal", component.get("v.proposedUnitsVal"));
            component.set("v.singleRec.salesPriceVal",  component.get("v.salesPriceVal"));
            component.set("v.singleRec.guidancePriceVal",  component.get("v.guidancePriceVal"));
            component.set("v.singleRec.opportunityVal", component.get("v.opportunityVal"));
            component.set("v.singleRec.priceRangeVal", component.get("v.priceRangeVal"));
            component.set("v.singleRec.competitorIdVal", component.get("v.selectedCompetitorId"));
            component.set("v.singleRec.competitorVal", component.get("v.selectedCompetitorName"));
        }
    },
    onSingleSelectChange: function (component, event, helper) {
        /*var val = event.getSource().get('v.value');
        console.log('Val is : '+val);*/
        //component.set("v.singleRec.Competitor", val);
        //console.log('Selected Competitor::'+component.get("v.selectedCompetitor"));
        console.log('Competitor 1: '+component.find('CIComName').get('v.value'));
        console.log('Competitor 2: '+component.find('CIComName2').get('v.value'));
        console.log('Competitor 3: '+component.find('CIComName3').get('v.value'));
        console.log('Competitor 4: '+component.find('CIComName4').get('v.value'));
        console.log('Competitor 5: '+component.find('CIComName5').get('v.value'));
        
		var listOfCompetitors = component.get("v.listOfCompetitors");
        var compName;
        for(var i=0; i<listOfCompetitors.length; i++){
            if(listOfCompetitors[i].Id == val){
				compName = listOfCompetitors[i].Name;
                break;                
            }
        }
        console.log('Competitor Name:: '+compName);
        component.set("v.selectedCompetitorName", compName);
    },
    closeCompetitorInfo: function(component, event, helper){
        component.set("v.showCompetitorInfo",false);
    },
    navigate : function(component, event, helper) 
    {
        component.set("v.showCompetitorInfo",true);
        /*var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:CompetitorInfo",
            componentAttributes: {
                bidId : component.get("v.optyId")
            }
            //You can pass attribute value from Component1 to Component2
            //componentAttributes :{ }
        });
        navigateEvent.fire();*/
    },
})