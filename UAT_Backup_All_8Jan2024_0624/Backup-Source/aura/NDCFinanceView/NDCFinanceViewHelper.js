({
	getScmData : function(component, event, helper) {
        //alert("alert1");
        var action = component.get("c.getScmData");
       /*component.set("v.isClicked", false);
       
        component.set("v.isSCMQtyDisadble", true);*/
        action.setParams({
            bidId : component.get("v.recordId")
        });
        action.setCallback(this, function (response){
            //alert("alert2");
            if(response.getState() === "SUCCESS"){
              
                var scmDataList = response.getReturnValue();
                if(scmDataList.length>0){
                    component.set("v.isSCMApprovePerson",scmDataList[0].isSCMApprovePerson);
                    component.set("v.bidRecord",scmDataList[0].bidRecord);
                    component.set("v.templateType",scmDataList[0].templateType);
                    component.set("v.noOfCons",scmDataList[0].noOfContracts);
                    console.log('templateType--->'+scmDataList[0].templateType);
                }              
                component.set("v.scmData", scmDataList);
                console.log('scm dataaaa--->'+JSON.stringify(component.get("v.scmData")));
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
        var bid = component.get("v.bidRecord");
         // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        csvStringResult = '';
        var selling_unit='1';
        var bidObj = component.get("v.bidRecord");
        var myMap = new Map();
          myMap.set("NDC", "ndc");
        myMap.set("SAP Number", "sapNumber");
        myMap.set("Product Name", "productName");
         myMap.set("Pkg Size", "pkgSize");
         myMap.set("Product Family", "productFamilyName");
          myMap.set("Case Pack", "casePack"); 
         myMap.set("MOQ", "moq"); 
         myMap.set("Compare To (Brand Name)", "comparetobrandName"); 
         myMap.set("Product Director", "productDirector");
        if(!bidObj.Phoenix_is_OTC_Bid__c){
         myMap.set("Orange Book Rating", "orangebookRating");
        }
         myMap.set("Old Throughput Cost", "oldthroughputCost");
         myMap.set("Throughput Cost Per Pack", "throughputCost");
         myMap.set("WAC", "wac");
         myMap.set("Doses", "doses");
         myMap.set("SSA Hit", "ssahit");
         myMap.set("LE Price Per Pack (Qtr)", "latestestimate");
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
         myMap.set("Proposed ASP", "proposedASPorDose");
         myMap.set("Budgeted ASP (Qtr)", "proposedBudgetASP");
         myMap.set("Proposed % to Budget", "ProposedpercenttoBudget");
         myMap.set("Difference Bottles", "differenceBottles");
        // myMap.set("Difference Doses", "differenceDoses");
         myMap.set("Volume Variance", "differenceVolume");
          myMap.set("Price variance", "differencePrice");
         myMap.set("Difference Sales", "differenceSales");
         myMap.set("Difference Margin", "differenceMargin");
          myMap.set("Difference ASP % Change", "differenceASPPercenttoChange");
        if(bid !=null && bid.Phoenix_Bid_Type__c != 'Volume Review Only'){
            myMap.set("Finance Approval", "financeApproval");
            myMap.set("Finance Comments", "financeComments");
        }
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
         myMap.set("DRL Margin %", "drlMargin");
         myMap.set("Current Royalty", "currentRoyality");
         myMap.set("Current Profit Available For Distribution", "profitAvailability");
         myMap.set("Current Profit Share To Partner 1", "currentProfitPartnerOne");
         myMap.set("Current Profit Share To Partner 2", "currentProfitPartnerTwo");
         myMap.set("Current DRL Share", "currentDRLShare");
         myMap.set("DRL Share Impact ", "drlShareImpact");
         myMap.set("TP/GM Impact Before PS + SSA Hit", "annualizedTPImpact");
         myMap.set("TP/GM Impact After PS + SSA Hit", "annualizedGMImpact");
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
                else if(value=='Phoenix_Proposed_Direct_Selling_Unit__c'){
                    csvStringResult += '"'+selling_unit+'"';
                }
                else if(value == 'throughputCost'){
                  var throughputCost = objectRecords[i]['throughputCost'];
                   // console.log("throughputCost--->"+throughputCost);
                    if(throughputCost != null){
                    var rounde_throughputCost=Math.round((throughputCost ) * 100) / 100
                    csvStringResult += '"'+rounde_throughputCost+'"';
                    }else{
                        csvStringResult += '"'+''+'"';
                    }      
                 }
                else if(value == 'latestestimate'){
                   var latestEsimate = objectRecords[i]['latestestimate'];
                   // console.log("latest estimate--->"+latestEsimate);
                    if(latestEsimate != null){
                    var roundeEstimate=Math.round((latestEsimate ) * 100) / 100
                    csvStringResult += '"'+roundeEstimate+'"';
                    }else{
                        csvStringResult += '"'+''+'"';
                    }
                   
                }
                else if(value == 'commercialCost' ){
                  var commercialCost = objectRecords[i]['commercialCost'];
                   // console.log("commercialCost--->"+commercialCost);
                    if(commercialCost != null){
                    var roundecc=Math.round((commercialCost ) * 100) / 100
                    csvStringResult += '"'+roundecc+'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                else if(value == 'profitavailableDistribution'){
                  var profitavailableDistribution = objectRecords[i]['profitavailableDistribution'];
                   // console.log("profitavailableDistribution--->"+profitavailableDistribution);
                    if(profitavailableDistribution != null){
                    var roundepafd=Math.round((profitavailableDistribution ) * 100) / 100
                    csvStringResult += '"'+roundepafd+'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                else if(value =='profitsharetoPartner'){
                   var profitsharetoPartner = objectRecords[i]['profitsharetoPartner'];
                   // console.log("profitsharetoPartner--->"+profitsharetoPartner);
                    if(profitsharetoPartner != null){
                    var roundepstp=Math.round((profitsharetoPartner ) * 100) / 100
                    csvStringResult += '"'+roundepstp+'"';  
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
               }
                else if(value =='profitsharetoPartner'){
                   var profitsharetoPartner = objectRecords[i]['profitsharetoPartner'];
                   // console.log("profitsharetoPartner--->"+profitsharetoPartner);
                    if(profitsharetoPartner != null){
                    var roundepstp=Math.round((profitsharetoPartner ) * 100) / 100
                    csvStringResult += '"'+roundepstp+'"'; 
                    }
                     else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                else if(value =='profitsharetoPartnertwo'){
                    var profitsharetoPartnertwo = objectRecords[i]['profitsharetoPartnertwo'];
                   // console.log("profitsharetoPartnertwo--->"+profitsharetoPartnertwo);
                    if(profitsharetoPartnertwo != null){
                    var roundepstpt=Math.round((profitsharetoPartnertwo ) * 100) / 100
                    csvStringResult += '"'+roundepstpt+'"'; 
                    }
                     else{
                        csvStringResult += '"'+''+'"';
                    }
                }
              /*  else if(value == 'drlMargin'){
                    var drlMarginper = objectRecords[i]['drlMargin'];
                   console.log("drlMarginper--->"+drlMarginper);
                    var roundedrlm=Math.round((drlMarginper ) * 100) / 100
                    csvStringResult += '"'+roundedrlm+'"';     
                }*/
                else if(value == 'currentRoyality'){
                    var currentRoyality = objectRecords[i]['currentRoyality'];
                   // console.log("currentRoyality--->"+currentRoyality);
                    if(currentRoyality != null){
                    var roundecr=Math.round((currentRoyality ) * 100) / 100
                    csvStringResult += '"'+roundecr+'"';   
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                else if(value == 'profitAvailability'){
                     var profitAvailability = objectRecords[i]['profitAvailability'];
                   // console.log("profitAvailability--->"+profitAvailability);
                    if(profitAvailability != null){
                   var roundepad=Math.round((profitAvailability )* 100) / 100
                   // var roundepad=Number(Math.round(profitAvailability+ "e2")+"e-2")
                    csvStringResult += '"'+roundepad+'"'; 
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                else if (value =='currentProfitPartnerOne'){
                   var currentProfitPartnerOne = objectRecords[i]['currentProfitPartnerOne'];
                   // console.log("currentProfitPartnerOne--->"+currentProfitPartnerOne);
                    if(currentProfitPartnerOne != null){
                    var roundecpstp=Math.round((currentProfitPartnerOne ) * 100) / 100
                    csvStringResult += '"'+roundecpstp+'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                else if (value =='currentProfitPartnerTwo'){
                   var currentProfitPartnerTwo = objectRecords[i]['currentProfitPartnerTwo'];
                   // console.log("currentProfitPartnerTwo--->"+currentProfitPartnerTwo);
                    if(currentProfitPartnerTwo != null){
                    var roundecpspt=Math.round((currentProfitPartnerTwo ) * 100) / 100
                    csvStringResult += '"'+roundecpspt+'"'; 
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                 else if(value == 'currentDRLShare'){
                   var currentDRLShare = objectRecords[i]['currentDRLShare'];
                   // console.log("currentDRLShare--->"+currentDRLShare);
                     if(currentDRLShare != null){
                    var roundecdrls=Math.round((currentDRLShare ) * 100) / 100
                    csvStringResult += '"'+roundecdrls+'"';   
                     }
                      else{
                        csvStringResult += '"'+''+'"';
                    }
                 }
                else if(value == 'totalprofitShare'){
                    var totalprofitShare=objectRecords[i]['totalprofitShare'];
                    //console.log("totalprofitShare--->"+totalprofitShare);
                    if(totalprofitShare != null){
                    var roundetps=Math.round(totalprofitShare )
                    csvStringResult += '"'+roundetps+'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                else if(value == 'valuetotalprofitShare'){
                   var valuetotalprofitShare=objectRecords[i]['valuetotalprofitShare'];
                    //console.log("valuetotalprofitShare--->"+valuetotalprofitShare);
                    if(valuetotalprofitShare != null){
                    var roundevtps=Math.round(valuetotalprofitShare )
                    csvStringResult += '"'+roundevtps+'"';   
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                else if(value == 'royality'){
                     var royality=objectRecords[i]['royality'];
                    //console.log("royality--->"+royality);
                    if(royality != null){
                    var rounderoyality=Math.round((royality )* 100) / 100
                    csvStringResult += '"'+rounderoyality+'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                
                else if(value == 'valueroyality'){
                  var valueroyality = objectRecords[i]['valueroyality'];
                   // console.log("valueroyality--->"+valueroyality);
                    if(valueroyality != null){
                    var roundetvr=Math.round(valueroyality )
                    csvStringResult += '"'+roundetvr+'"';  
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                else if( value == 'drlShare'){
                  var drlShare = objectRecords[i]['drlShare'];
                   // console.log("valueroyality--->"+valueroyality);
                    if(drlShare != null){
                    var roundedrlShare=Math.round((drlShare )* 100) / 100
                    csvStringResult += '"'+roundedrlShare+'"';  
                    }
       				else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                else if( value == 'totaldrlShare'){
                    var totaldrlShare = objectRecords[i]['totaldrlShare'];
                   // console.log("totaldrlShare--->"+totaldrlShare);
                    if(totaldrlShare != null){
                    var roundetds=Math.round(totaldrlShare )
                    csvStringResult += '"'+roundetds+'"'; 
                    }
      				else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                 else if(value == 'drlShareImpact'){
                      var drlShareImpact = objectRecords[i]['drlShareImpact'];
                   // console.log("drlShareImpact--->"+drlShareImpact);
                   if(drlShareImpact != null){
                    var roundedsi=Math.round(drlShareImpact )
                    csvStringResult += '"'+roundedsi+'"';  
                     }
                     else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                else if(value == 'annualizedTPImpact'){
                   var annualizedTPImpact = objectRecords[i]['annualizedTPImpact'];
                   // console.log("annualizedTPImpact--->"+annualizedTPImpact);
                    if(annualizedTPImpact != null){
                    var roundeatpi=Math.round(annualizedTPImpact )
                    csvStringResult += '"'+roundeatpi+'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                else if(value == 'annualizedGMImpact'){
                    var annualizedGMImpact = objectRecords[i]['annualizedGMImpact'];
                   // console.log("annualizedGMImpact--->"+annualizedGMImpact);
                    if(annualizedGMImpact != null){
                    var roundeagmi=Math.round(annualizedGMImpact )
                    csvStringResult += '"'+roundeagmi+'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }    
                }
                else if(value == 'differenceMargin'){
                      var differenceMargin = objectRecords[i]['differenceMargin'];
                   // console.log("differenceMargin--->"+differenceMargin);
                    if(differenceMargin != null){
                    var roundedifferenceMargin=Math.round(differenceMargin )
                    csvStringResult += '"'+roundedifferenceMargin+'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }    
               }
                    else if(value=='proposedSales'){
                        var differenceMargin = objectRecords[i]['proposedSales'];
                        // console.log("differenceMargin--->"+differenceMargin);
                        if(differenceMargin != null){
                            var roundedifferenceMargin=Math.round(differenceMargin)
                            csvStringResult += '"'+roundedifferenceMargin+'"';
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }    
                    }
                else if(objectRecords[i][value]==undefined){
                        csvStringResult += '"'+''+'"';
                    }
                    else{
                        csvStringResult += '"'+ objectRecords[i][value]+'"';
                    }
                               
                counter++;
            }
            csvStringResult += lineDivider;
        }
        //new logic end 
         
        return csvStringResult;     
    },
    getAllTotalValues :function(component, event, helper) {
        var action = component.get("c.getAllTotals");      
        action.setParams
        ({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var responseValue= response.getReturnValue();
                                   console.log('Currnet Sales-->'+responseValue[0].currentSales);
                                   var templateType= component.get("v.templateType");
                                   console.log('templateType NCD-->'+templateType);
                                   if(templateType == 'ClarusOne'){
                                       component.set("v.CurrenSalesTotal",responseValue[0].currentSales);
                                   }
                                   else if(responseValue[0].newFinSales != 0 && responseValue[0].newFinSales != undefined){
                                       component.set("v.CurrenSalesTotal",responseValue[0].newFinSales);
                                   }
                                   else{
                                       component.set("v.CurrenSalesTotal",responseValue[0].csf);
                                   }
                                   component.set("v.CurrentTPMarginTotal",responseValue[0].ctpm);
                                   component.set("v.ProposedSalesTotal",responseValue[0].prs);
                                   component.set("v.ProposedTPMarginTotal",responseValue[0].ptpm);
                                   component.set("v.VolumeVarianceTotal",responseValue[0].vlmv);
                                   component.set("v.PriceVarianceTotal",responseValue[0].prv);
                                   component.set("v.DifferenceSalesTotal",responseValue[0].dffs);
                                   component.set("v.DifferenceMarginTotal",responseValue[0].dffm);
								   component.set("v.ssahitTotal",responseValue[0].ssahit);    
                                   component.set("v.TotalDRLShareTotal",responseValue[0].tdrlsh);
                                   component.set("v.DRLShareImpactTotal",responseValue[0].drlshim);
                                   component.set("v.TPGMBeforeTotal",responseValue[0].tpgmb);
                                   component.set("v.TPGMAfterTotal",responseValue[0].tpgma);
                                   var totalDRlMargin = responseValue[0].totalDrlShare != null ? responseValue[0].totalDrlShare : 0;
                                   console.log("totalDRlMargin---->"+totalDRlMargin)
                                   var totalASP =  responseValue[0].totalProposedASp != null ? responseValue[0].totalProposedASp : 0;
                                   console.log("totalASP---->"+totalASP)
                                   var toalMargin = totalASP > 0 ? (totalDRlMargin/totalASP)*100 : 0 ;
                                   component.set("v.totalDRlMargin",toalMargin);
                               }
                               else{
                                   console.log('totals-errir-');
                               }
                           });
        $A.enqueueAction(action);
    },
})