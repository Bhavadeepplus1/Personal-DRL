({
	getScmData : function(component, event, helper) {
        //alert("alert1");
        var action = component.get("c.getScmData");
       /*component.set("v.isClicked", false);
        component.set("v.isSpinnerLoad", true);
        component.set("v.isSCMQtyDisadble", true);*/
        action.setParams({
            bidId : component.get("v.recordId")
        });
        action.setCallback(this, function (response){
            //alert("alert2");
            if(response.getState() === "SUCCESS"){
              
                var scmDataList = response.getReturnValue();
                console.log("scmDataList tested by satya-->"+scmDataList[0].SCMApproval);
                
                 var bidRecord = scmDataList[0].bidRecord;
               
                 console.log("response of bid-->"+bidRecord);
                //console.log("scmDataList tested by satya-->"+scmDataList);
                if(scmDataList.length>0){
                    component.set("v.isSCMApprovePerson",scmDataList[0].isSCMApprovePerson);
                }              
                component.set("v.scmData", scmDataList);
                console.log('scm dataaaa--->'+JSON.stringify(component.get("v.scmData")));
                component.set("v.templateType",bidRecord.Phoenix_Customer_Type__c);
               console.log("templateType tested by satya-->"+bidRecord.Phoenix_Customer_Type__c);
                component.set("v.isSpinnerLoad", false);
            }
        });
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
         // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        csvStringResult = '';
        var selling_unit='1';
        var myMap = new Map();
          myMap.set("NDC", "ndc");
        myMap.set("SAP Number", "sapNumber");
        myMap.set("Product Name", "productName");
         myMap.set("Pkg Size", "pkgSize");
         myMap.set("Product Family", "productFamily");
          myMap.set("Case Pack", "casePack"); 
         myMap.set("MOQ", "moq"); 
         myMap.set("Compare To (Brand Name)", "comparetobrandName"); 
         myMap.set("Product Director", "productDirector");
         myMap.set("Orange Book Rating", "orangebookRating");
         myMap.set("Throughput Cost", "throughputCost");
         myMap.set("WAC", "wac");
         myMap.set("Doses", "doses");
         myMap.set("SSA Hit", "ssahit");
         myMap.set("Latest Estimate", "latestestimate");
         myMap.set("Current Bottles	", "monthlyDemand");
         //myMap.set("Current Doses", "currentDoses");
         myMap.set("Current Sales(Finance)", "currentsalesFinance");
         myMap.set("Current TP Margin $$$", "currentTPMargin");
          myMap.set("Current TP Margin %", "currentTPMarginprecent");
         myMap.set("Current ASP", "currentASPorDose");
         myMap.set("Proposed Bottles", "proposedBottles");
        // myMap.set("Proposed Doses", "proposedDoses");
         myMap.set("Proposed Sales", "proposedSales");
         myMap.set("Proposed TP Margin $$$", "proposedTPMargin");
         myMap.set("Proposed TP Margin %", "proposedTPMarginpercent");
         myMap.set("Proposed ASP/ Selling Unit", "proposedASPorDose");
         myMap.set("Proposed Budget ASP", "proposedBudgetASP");
         myMap.set("Proposed % to Budget", "ProposedpercenttoBudget");
         myMap.set("Difference Bottles", "differenceBottles");
        // myMap.set("Difference Doses", "differenceDoses");
         myMap.set("Difference Volume", "differenceVolume");
          myMap.set("Difference Price", "differencePrice");
         myMap.set("Difference Sales", "differenceSales");
         myMap.set("Difference Margin", "differenceMargin");
          myMap.set("Difference ASP % Change", "differenceASPPercenttoChange");
         myMap.set("Finance Approval", "financeApproval");
         myMap.set("Finance Comments", "financeComments");
         myMap.set("Comm. Exps %", "commercialExpression");
          myMap.set("Commercial Cost", "commercialCost");
         myMap.set("Profit Available For Distribution", "profitavailableDistribution");
         myMap.set("PS Partner 1", "psPartner");
         myMap.set("PS % -Partner 1", "pspartnerPercent");
         myMap.set("Profit Share To Partner 1", "profitsharetoPartner");
          myMap.set("PS Partner 2", "psPartnertwo");
         myMap.set("PS % -Partner 2", "psPartnertwopercent");
         myMap.set("Profit Share To partner 2", "profitsharetoPartnertwo");
         myMap.set("Total Profit Share", "totalprofitShare");
         myMap.set("Total Value Profit Share", "valuetotalprofitShare");
         myMap.set("Royalty Partner Name", "royalitypartnerName");
          myMap.set("Royalty %", "royalitypercent");
         myMap.set("Royalty Per Unit", "royality");
          myMap.set("Total Value Royalty", "valueroyality");
         myMap.set("DRL Share Per Unit", "drlShare");
          myMap.set("Total DRL Share", "totaldrlShare");
         myMap.set("DRL Margin", "drlMargin");
         csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        //new logic start 
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                //console.log(JSON.stringify(objectRecords[i]));
                if(value=='Phoenix_Product__r.Name'){
                    csvStringResult += '"'+ objectRecords[i]["Phoenix_Product__r"]["Name"]+'"';
                }
                if(value=='Phoenix_Proposed_Direct_Selling_Unit__c'){
                    csvStringResult += '"'+selling_unit+'"';
                }
                if(value == 'latestestimate'){
                   var latestEsimate = objectRecords[i]['latestestimate'];
                   // console.log("latest estimate--->"+latestEsimate);
                    var roundeEstimate=Math.round((latestEsimate + Number.EPSILON) * 100) / 100
                    //console.log("New latest estimate---->"+roundeEstimate);
                    csvStringResult += '"'+roundeEstimate+'"';
                   
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