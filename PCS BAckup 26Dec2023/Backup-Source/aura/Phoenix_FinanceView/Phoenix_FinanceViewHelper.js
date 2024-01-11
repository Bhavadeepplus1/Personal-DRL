({
	getRollupData : function(component, event, helper) {
		component.set("v.isClicked", false);
       
        component.set("v.financeApprovalMap",null);
        component.set("v.financeCommentsMap",null);
        var action = component.get("c.getProductFamlilyRollups");
        action.setParams({
            bidId : component.get("v.recordId")
        });
        console.log('recordId---->'+component.get("v.recordId"))
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var dataList = response.getReturnValue();
                if(dataList.length>0){
                    component.set("v.isFinanceApprovePerson",dataList[0].isFinanceApprovePerson);
                    component.set("v.bidRecord",dataList[0].bidRecord);
                    let totalsList = new Array();
                    dataList[0].dataList.forEach(function(eachValue){
                        totalsList.push(0);
                    });
                    dataList.forEach(function(eachWrapper){
                        var i= 0;
                        eachWrapper.dataList.forEach(function(eachValue){
                            totalsList[i++] +=eachValue;
                                                       
                        });
                    });
                    
                    component.set("v.TotalsList",totalsList)
                }
                
                component.set("v.rollupData", dataList);
                console.log('dataList-->'+JSON.stringify(dataList));
                component.set("v.isSpinnerLoad", false);
                component.set("v.isFinanceApproved", false);
            }
        })
        $A.enqueueAction(action);
		
	},
    convertArrayOfObjectsToCSV : function(component,objectRecords,template){
        // declare variables
        var csvStringResult, counter, keys,columnDivider, lineDivider;
        console.log('testing result--->'+JSON.stringify(objectRecords));
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        var bid = component.get("v.bidRecord");
         // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        csvStringResult = '';
        var selling_unit='1';
        var myMap = new Map();
        myMap.set("Product Family", "productFamilyName");
        myMap.set("Current Bottles", "currentBottles");
        myMap.set("Current Sales", "currentsalesFinance");
        myMap.set("Current TP Margin $$$", "currentTPMargin");
        myMap.set("Current TP Margin %", "currentTPMarginprecent");
        myMap.set("Current ASP", "currentASPorDose");
        myMap.set("Proposed Bottles", "proposedBottles");
        myMap.set("Proposed Sales", "proposedSales");
        myMap.set("Proposed TP Margin $$$", "proposedTPMargin");
        myMap.set("Proposed TP Margin %", "proposedTPMarginpercent");
        myMap.set("Proposed ASP", "proposedASPorDose");
        myMap.set("Difference Bottles", "differenceBottles");
        myMap.set("Volume Variance", "differenceVolume");
        myMap.set("Price Variance", "differencePrice");
        myMap.set("Difference Sales", "differenceSales");
        myMap.set("Difference Margin", "differenceMargin");
        /*myMap.set("Difference ASP % Change", "differenceASPPercenttoChange");
        myMap.set("Proposed as % of Budget", "ProposedBudgetPercent");
        myMap.set("Latest Estimate", "latestEstimate");
        myMap.set("Proposed as % of Latest Estimate", "ProposedLatestEstimate");*/
        if(bid !=null && bid.Phoenix_Bid_Type__c != 'Volume Review Only'){
            myMap.set("Finance Approval", "financeApproval");
            myMap.set("Finance Comments", "financeComments");
        }
        
         csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        //new logic start 
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
               
                if(value=='currentTPMarginprecent'){
                    var currentTPMarginprecent=objectRecords[i]['currentTPMarginprecent'];
                     if(currentTPMarginprecent != null){
                    var round_currentTPMarginprecent=Math.round(currentTPMarginprecent*100)/100;
                    csvStringResult += '"'+round_currentTPMarginprecent+'"';
                     }
                    else{
                       csvStringResult += '"'+''+'"';
  
                    }
                } else if(value=='productFamilyName'){
                    if(objectRecords[i]['productFamilyName'] != null){
                        csvStringResult += '"'+ objectRecords[i]["productFamilyName"]+'"';
                    } else{
                        csvStringResult += '"'+ objectRecords[i]["productFamilyOld"]+'"';
                    }
                }
                else if(value=='proposedSales'){
                    var proposedSales=objectRecords[i]['proposedSales'];
                     if(proposedSales != null){
                   	var rounded_proposedSales=Math.round(proposedSales);
                    csvStringResult += '"'+rounded_proposedSales+'"';
                     }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                else if(value=='proposedTPMarginpercent'){
                    var proposedTPMarginpercent =objectRecords[i]['proposedTPMarginpercent'];
                    if(proposedTPMarginpercent != null){
                    var rounded_proposedTPMarginpercent=Math.round(proposedTPMarginpercent* 100) / 100
                    csvStringResult += '"'+rounded_proposedTPMarginpercent+'"';
                    }
                    else{
                         csvStringResult += '"'+''+'"';

                    }
                }
                else if(value=='proposedASPorDose'){
                    var proposedasp =objectRecords[i]['proposedASPorDose'];
                    if(proposedasp != null){
                    var rounded_proposedasp=Math.round(proposedasp* 100) / 100
                    csvStringResult += '"'+rounded_proposedasp+'"';
                    }
                    else{
                         csvStringResult += '"'+''+'"';

                    }
                }
                else if(value=='differenceASPPercenttoChange'){
                    var differenceASPPercenttoChange = objectRecords[i]['differenceASPPercenttoChange'];
                    console.log('differenceASPPercenttoChange--->'+differenceASPPercenttoChange);
                     if(differenceASPPercenttoChange != null){
                    var rounded_differenceASPPercenttoChange=Math.round(differenceASPPercenttoChange* 100) / 100
                    csvStringResult += '"'+rounded_differenceASPPercenttoChange+'"';
                     }
                    else{
                       csvStringResult += '"'+''+'"';
                    }
                }
                else if(value=='ProposedBudgetPercent'){
                   var ProposedBudgetPercent = objectRecords[i]['ProposedBudgetPercent'];
                    if(ProposedBudgetPercent != null){
                    var rounded_ProposedBudgetPercent=Math.round(ProposedBudgetPercent* 100) / 100
                    csvStringResult += '"'+rounded_ProposedBudgetPercent+'"';
                    }
                    else{
                       csvStringResult += '"'+''+'"';

                    }
                }
                else if(value=='latestEstimate'){
                   var latestEstimate = objectRecords[i]['latestEstimate'];
                    if(latestEstimate != null){
                    var rounded_latestEstimate=Math.round(latestEstimate* 100) / 100
                    csvStringResult += '"'+rounded_latestEstimate+'"';
                    }
                    else{
                       csvStringResult += '"'+''+'"';

                    }
                }
                else if(value=='ProposedLatestEstimate'){
                   var ProposedLatestEstimate = objectRecords[i]['ProposedLatestEstimate'];
                  if(ProposedLatestEstimate != null){
                    var rounded_ProposedLatestEstimate=Math.round(ProposedLatestEstimate* 100) / 100
                    csvStringResult += '"'+rounded_ProposedLatestEstimate+'"';
                  }
                    else{
                    csvStringResult += '"'+''+'"';
                    }
                }
                    else if(value=='currentASPorDose'){
                        var ProposedLatestEstimate = objectRecords[i]['currentASPorDose'];
                        if(ProposedLatestEstimate != null){
                            var rounded_ProposedLatestEstimate=Math.round(ProposedLatestEstimate* 100) / 100
                            csvStringResult += '"'+rounded_ProposedLatestEstimate+'"';
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }
                    }
                else{
                    if(objectRecords[i][value]==undefined){
                        csvStringResult += '"'+''+'"';
                    }else{
                        csvStringResult += '"'+ objectRecords[i][value]+'"';
                    }
                }                
                counter++;
            }
            csvStringResult += lineDivider;
        }
        //new logic end 
         
        return csvStringResult;     
    }
})