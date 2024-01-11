({
    getData: function(component, event, helper,showInt){
        console.log('showInt value--->'+showInt);
        component.set('v.loaded', true);
        var selections = component.get("v.selections");
        if(component.get("v.selections") != undefined && component.get("v.selections").length > 0){
            selections = component.get('v.selections');
        }
        var action = component.get("c.getDRLSalesRelatedList");
        action.setParams({
            selections: selections,
            selectedComparison: component.get("v.comparison"),
            customerId: component.get("v.customerId"),
            isEXTChecked : component.get("v.isEXTChecked"),
            searchText : component.get("v.searchText"),
            custDesc: component.get("v.custDescList")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   component.set("v.loaded", false);
                                   var response= response.getReturnValue();
                                   console.log('Response in My Accounts:: '+JSON.stringify(response));
                                   console.log('search text-->'+response.searchText1);
                                   console.log('response acc wrapmap==>'+JSON.stringify(response.accWrapMap))
                                   console.log('recentLastMonth '+response.recentLastMonth);
                                   console.log('previousLastMonth '+response.previousLastMonth);
                                   
                                   //component.set("v.parentName", response.accWrapMap[0].parentName);
                                   component.set("v.recentLastMonth", response.recentLastMonth);
                                   component.set("v.previousLastMonth", response.previousLastMonth);
                                   component.set("v.GCPUpdateDate", response.GCPUpdateDate);
                                   component.set("v.VisionUpdateDate", response.VisionUpdateDate);
                                   component.set("v.DataAvailableTill", response.DataAvailableTill);
                                   console.log('keySet???==>'+response.keySet)
                                   component.set("v.keySet", response.keySet);
                                   component.set("v.keySetPrev", response.keySetPrev);
                                   
                                   if(component.get("v.isEXTChecked")){
                                       var accMap = Object.values(response.accWrapMap);
                                       if(response.salesList != undefined && response.salesList != null && $A.util.isArray(response.salesList) && response.salesList.length>0){            
                                           
                                           for(var i=0; i<response.salesList.length; i++){
                                               if(response.salesList[i].hierarchyCode == null || response.salesList[i].hierarchyCode == ''||response.salesList[i].hierarchyCode == undefined){
                                                   response.salesList[i].showItem = true;
                                               }else{
                                                   response.salesList[i].showItem = false;
                                               }
                                               if(response.salesList[i].salesdl > response.salesList[i].SalesDollarPrev){
                                                   console.log('salesdl==>'+response.salesList[i].salesdl)
                                                   console.log('SalesDollarPrev==>'+response.salesList[i].SalesDollarPrev)
                                                   component.set("v.classS", 'green');
                                                   response.salesList[i].classS = 'green';
                                               } else if(response.salesList[i].salesdl < response.salesList[i].SalesDollarPrev){
                                                   component.set("v.classS", 'red');
                                                   response.salesList[i].classS = 'red';
                                               } else{
                                                   component.set("v.classS", 'yellow');
                                                   response.salesList[i].classS = 'yellow';
                                               }
                                               if(response.salesList[i].units > response.salesList[i].UnitsPrev){
                                                   console.log('units==>'+response.salesList[i].units)
                                                   console.log('UnitsPrev==>'+response.salesList[i].UnitsPrev)
                                                   component.set("v.classV", 'green');
                                                   response.salesList[i].classV = 'green';
                                               } else if(response.salesList[i].units < response.salesList[i].UnitsPrev){
                                                   console.log('in else units==>'+response.salesList[i].units)
                                                   console.log('in else UnitsPrev==>'+response.salesList[i].UnitsPrev)
                                                   component.set("v.classV", 'red');
                                                   response.salesList[i].classV = 'red';
                                               } else{
                                                   component.set("v.classV", 'yellow');
                                                   response.salesList[i].classV = 'yellow';
                                               }
                                               if(response.salesList[i].tptdollar > response.salesList[i].TPTDollarPrev){
                                                   component.set("v.classT", 'green');
                                                   response.salesList[i].classT = 'green';
                                               } else if(response.salesList[i].tptdollar < response.salesList[i].TPTDollarPrev){
                                                   component.set("v.classT", 'red');
                                                   response.salesList[i].classT = 'red';
                                               } else{
                                                   component.set("v.classT", 'yellow');
                                                   response.salesList[i].classT = 'yellow';
                                               }
                                               if(response.salesList[i].tptpct > response.salesList[i].TPTPctPrev){
                                                   component.set("v.classP", 'green');
                                                   response.salesList[i].classP = 'green';
                                               } else if(response.salesList[i].tptpct < response.salesList[i].TPTPctPrev){
                                                   component.set("v.classP", 'red');
                                                   response.salesList[i].classP = 'red';
                                               } else{
                                                   component.set("v.classP", 'yellow');
                                                   response.salesList[i].classP = 'yellow';
                                               }
                                           }
                                       }
                                       for(var i=0; i<accMap.length; i++){
                                           accMap[i].showItem = false;
                                       }
                                       component.set("v.resList", response.salesList);
                                       console.log('salesList in My Accounts:: '+JSON.stringify(response.salesList));
                                       
                                       component.set("v.responseList",accMap);
                                   }
                                   var keySet = component.get("v.keySet");
                                   console.log('KeySet-2->'+keySet);
                                   component.set("v.res",response.accWrapMap);
                                   
                                   component.set("v.noData", false);
                                   component.set("v.showBoolean",true);
                                   var selections = response.selections;
                                   var filteredBy = '';
                                   //console.log('selections ::: '+selections);
                                   if(selections.includes('Rx')){
                                       component.set("v.isRxChecked",true);
                                       filteredBy = filteredBy != '' ? filteredBy+',Rx' : 'Rx';
                                   }
                                   else
                                       component.set("v.isRxChecked",false);
                                   if(selections.includes('SRx')){
                                       component.set("v.isSRxChecked",true);
                                       filteredBy = filteredBy != '' ? filteredBy+', SRx' : 'SRx';
                                   }
                                   else
                                       component.set("v.isSRxChecked",false);
                                   if(selections.includes('OTC')){
                                       component.set("v.isOtcChecked",true);
                                       filteredBy = filteredBy != '' ? filteredBy+', OTC' : 'OTC';
                                   }
                                   else
                                       component.set("v.isOtcChecked",false);
                                   component.set("v.selections",selections);
                                   if(!component.get("v.isEXTChecked")){
                                       
                                       var salesdlSummary =[];
                                       var unitsSummary =[];
                                       var tptSummary =[];
                                       var tptPercentSummary =[];
                                       var salesdlPrevSummary =[];
                                       var unitsPrevSummary =[];
                                       var tptPrevSummary =[];
                                       var tptPercentPrevSummary =[];
                                       var sumOfPrevSales =[];
                                       var sumOfRecentSales =[];
                                       var sumOfPrevUnits=[];
                                       var sumOfRecentUnits =[];
                                       var sumOfPrevTPTDl =[];
                                       var sumOfRecentTPTDl =[];
                                       var sumOfPrevTPTPerc =[];
                                       var sumOfRecentTPTPerc =[];
                                       var xAxisLabelsSummary = [];
                                       var comparison = component.get("v.comparison");
                                       var l1 = [];
                                       var l2 = [];
                                       var sumofSales = 0;
                                       var sumofunits = 0;
                                       var sumoftptdl = 0;
                                       var sumoftptperc = 0;
                                       var prevKeys = Object.keys(response.finalPrevMapSummary);
                                       var recentKeys = Object.keys(response.finalRecentMapSummary);
                                       console.log('recentKeys in helper-->'+recentKeys)
                                       console.log('prevKeys in helper-->'+prevKeys)
                                       /*for lables*/
                                       for(var k=0;k<response.keySet.length;k++){
                                           if(comparison != 'lastquartervspreviousquarter'){
                                               var label = keySet[k].split('-');
                                               xAxisLabelsSummary.push(label[0]);
                                           }
                                       }
                                       /*end for lables*/
                                       console.log('finalPrevMapSummary internal-->'+JSON.stringify(response.finalPrevMapSummary));
                                       for (var key in response.finalPrevMapSummary){
                                           
                                           salesdlPrevSummary.push(response.finalPrevMapSummary[key]['prevsalesMonthlySummary']);
                                           unitsPrevSummary.push(response.finalPrevMapSummary[key]['prevunitsMonthlySummary']);
                                           tptPrevSummary.push(response.finalPrevMapSummary[key]['prevtptdollarMonthlySummary']);
                                           tptPercentPrevSummary.push(response.finalPrevMapSummary[key]['prevtptpercMonthlySummary']);
                                           if(comparison != 'lastquartervspreviousquarter'){
                                               //var label = key.split('-');
                                               //xAxisLabelsSummary.push(label[0]); 
                                               
                                           } else{
                                               sumofSales += response.finalPrevMapSummary[key]['prevsalesMonthlySummary'];
                                               sumofunits += response.finalPrevMapSummary[key]['prevunitsMonthlySummary'];
                                               sumoftptdl += response.finalPrevMapSummary[key]['prevtptdollarMonthlySummary'];
                                           }
                                       }
                                       sumOfPrevSales.push(sumofSales);
                                       sumOfPrevUnits.push(sumofunits);
                                       sumOfPrevTPTDl.push(sumoftptdl);
                                       sumOfPrevTPTPerc.push((sumoftptdl/sumofSales)*100);
                                       component.set("v.sumOfPrevSales",sumOfPrevSales);
                                       component.set("v.sumOfPrevUnits",sumOfPrevUnits);
                                       console.log('sumOfPrevUnits chart====='+sumOfPrevUnits);
                                       component.set("v.sumOfPrevTPTDl",sumOfPrevTPTDl);
                                       component.set("v.sumOfPrevTPTPerc",sumOfPrevTPTPerc);
                                       var sumofSalesRecent = 0 ;
                                       var somofUnitsRecent = 0;
                                       var sumofTPTDlRecent = 0;
                                       var sumofTPTPercRecent = 0;
                                       
                                       for (var key in response.finalRecentMapSummary){
                                           console.log('key test-->'+key);
                                           
                                           
                                           salesdlSummary.push(response.finalRecentMapSummary[key]['salesMonthlySummary']);
                                           unitsSummary.push(response.finalRecentMapSummary[key]['unitsMonthlySummary']);
                                           tptSummary.push(response.finalRecentMapSummary[key]['tptdollarMonthlySummary']);
                                           tptPercentSummary.push(response.finalRecentMapSummary[key]['tptpercMonthlySummary']);
                                           
                                           
                                           if(comparison != 'lastquartervspreviousquarter'){
                                               /* var label = key.split('-');
                                               if(!xAxisLabelsSummary.includes(label[0])){
                                                   xAxisLabelsSummary.push(label[0]);
                                               }  */
                                               
                                           } else{
                                               sumofSalesRecent += Math.round(response.finalRecentMapSummary[key]['salesMonthlySummary']);
                                               somofUnitsRecent +=response.finalRecentMapSummary[key]['unitsMonthlySummary'];
                                               sumofTPTDlRecent += response.finalRecentMapSummary[key]['tptdollarMonthlySummary'];
                                           }
                                        }
                                       
                                       sumOfRecentSales.push(sumofSalesRecent);
                                       sumOfRecentUnits.push(somofUnitsRecent);
                                       sumOfRecentTPTDl.push(sumofTPTDlRecent);
                                       sumOfRecentTPTPerc.push((sumofTPTDlRecent/sumofSalesRecent)*100);
                                       component.set("v.sumOfRecentSales",sumOfRecentSales);
                                       component.set("v.sumOfRecentUnits",sumOfRecentUnits);
                                       component.set("v.sumOfRecentTPTDl",sumOfRecentTPTDl);
                                       component.set("v.sumOfRecentTPTPerc",sumOfRecentTPTPerc);
                                       component.set("v.salesdlSummary",salesdlSummary);
                                       component.set("v.unitsSummary",unitsSummary);
                                       component.set("v.tptSummary",tptSummary);
                                       component.set("v.tptPercentSummary",tptPercentSummary);                                  
                                       component.set("v.xAxisLabelsSummary", xAxisLabelsSummary);
                                       component.set("v.salesdlPrevSummary",salesdlPrevSummary);
                                       component.set("v.unitsPrevSummary",unitsPrevSummary);
                                       component.set("v.tptPrevSummary",tptPrevSummary);
                                       component.set("v.tptPercentPrevSummary",tptPercentPrevSummary);
                                       if(component.get("v.filterName") == undefined || component.get("v.filterName") == ''){
                                           component.set("v.filterName",'Recent Sales');
                                           component.set("v.isAsc", false);
                                       } 
                                       console.log('xAxisLabelsSummary present-->'+xAxisLabelsSummary);
                                       component.set("v.InternalResList", response.accWrapMap);  
                                       helper.buildData(component, event, helper, response);   
                                   }else{
                                       var salesdlSummary =[];
                                       var unitsSummary =[];
                                       var tptSummary =[];
                                       var tptPercentSummary =[];
                                       var salesdlPrevSummary =[];
                                       var unitsPrevSummary =[];
                                       var tptPrevSummary =[];
                                       var tptPercentPrevSummary =[];
                                       var sumOfPrevSales =[];
                                       var sumOfRecentSales =[];
                                       var sumOfPrevUnits=[];
                                       var sumOfRecentUnits =[];
                                       var sumOfPrevTPTDl =[];
                                       var sumOfRecentTPTDl =[];
                                       var sumOfPrevTPTPerc =[];
                                       var sumOfRecentTPTPerc =[];
                                       var xAxisLabelsSummary = [];
                                       var comparison = component.get("v.comparison");
                                       var l1 = [];
                                       var l2 = [];
                                       var sumofSales = 0;
                                       var sumofunits = 0;
                                       var sumoftptdl = 0;
                                       var sumoftptperc = 0;
                                       var prevKeys = Object.keys(response.finalPrevMapSummary);
                                       var recentKeys = Object.keys(response.finalRecentMapSummary);
                                       console.log('recentKeys in helper-->'+recentKeys)
                                       console.log('prevKeys in helper-->'+prevKeys)
                                       /*for lables*/
                                       for(var k=0;k<response.keySet.length;k++){
                                           if(comparison != 'lastquartervspreviousquarter'){
                                               var label = keySet[k].split('-');
                                               xAxisLabelsSummary.push(label[0]);
                                           }
                                       }
                                       /*end for lables*/
                                       console.log('finalPrevMapSummary-->'+JSON.stringify(response.finalPrevMapSummary));
                                       console.log('finalRecentMapSummary-->'+JSON.stringify(response.finalRecentMapSummary));
                                       for (var key in response.finalPrevMapSummary){
                                           
                                           salesdlPrevSummary.push(response.finalPrevMapSummary[key]['prevsalesMonthlySummary']);
                                           unitsPrevSummary.push(response.finalPrevMapSummary[key]['prevunitsMonthlySummary']);
                                           tptPrevSummary.push(response.finalPrevMapSummary[key]['prevtptdollarMonthlySummary']);
                                           tptPercentPrevSummary.push(response.finalPrevMapSummary[key]['prevtptpercMonthlySummary']);
                                           if(comparison != 'lastquartervspreviousquarter'){
                                               //var label = key.split('-');
                                               //xAxisLabelsSummary.push(label[0]); 
                                               
                                           } else{
                                               sumofSales += response.finalPrevMapSummary[key]['prevsalesMonthlySummary'];
                                               sumofunits += response.finalPrevMapSummary[key]['prevunitsMonthlySummary'];
                                               sumoftptdl += response.finalPrevMapSummary[key]['prevtptdollarMonthlySummary'];
                                           }
                                       }
                                       sumOfPrevSales.push(sumofSales);
                                       sumOfPrevUnits.push(sumofunits);
                                       sumOfPrevTPTDl.push(sumoftptdl);
                                       sumOfPrevTPTPerc.push((sumoftptdl/sumofSales)*100);
                                       component.set("v.sumOfPrevSales",sumOfPrevSales);
                                       component.set("v.sumOfPrevUnits",sumOfPrevUnits);
                                       component.set("v.sumOfPrevTPTDl",sumOfPrevTPTDl);
                                       component.set("v.sumOfPrevTPTPerc",sumOfPrevTPTPerc);
                                       var sumofSalesRecent = 0 ;
                                       var somofUnitsRecent = 0;
                                       var sumofTPTDlRecent = 0;
                                       var sumofTPTPercRecent = 0;
                                       for (var key in response.finalRecentMapSummary){
                                           console.log('key test-->'+key);
                                           
                                           
                                           salesdlSummary.push(response.finalRecentMapSummary[key]['salesMonthlySummary']);
                                           unitsSummary.push(response.finalRecentMapSummary[key]['unitsMonthlySummary']);
                                           tptSummary.push(response.finalRecentMapSummary[key]['tptdollarMonthlySummary']);
                                           tptPercentSummary.push(response.finalRecentMapSummary[key]['tptpercMonthlySummary']);
                                           
                                           
                                           if(comparison != 'lastquartervspreviousquarter'){
                                               /* var label = key.split('-');
                                               if(!xAxisLabelsSummary.includes(label[0])){
                                                   xAxisLabelsSummary.push(label[0]);
                                               }  */
                                               
                                           } else{
                                               sumofSalesRecent += Math.round(response.finalRecentMapSummary[key]['salesMonthlySummary']);
                                               somofUnitsRecent +=response.finalRecentMapSummary[key]['unitsMonthlySummary'];
                                               sumofTPTDlRecent += response.finalRecentMapSummary[key]['tptdollarMonthlySummary'];
                                           }
                                       }
                                       sumOfRecentSales.push(sumofSalesRecent);
                                       sumOfRecentUnits.push(somofUnitsRecent);
                                       sumOfRecentTPTDl.push(sumofTPTDlRecent);
                                       sumOfRecentTPTPerc.push((sumofTPTDlRecent/sumofSalesRecent)*100);
                                       component.set("v.sumOfRecentSales",sumOfRecentSales);
                                       component.set("v.sumOfRecentUnits",sumOfRecentUnits);
                                       component.set("v.sumOfRecentTPTDl",sumOfRecentTPTDl);
                                       component.set("v.sumOfRecentTPTPerc",sumOfRecentTPTPerc);
                                       component.set("v.salesdlSummary",salesdlSummary);
                                       component.set("v.unitsSummary",unitsSummary);
                                       component.set("v.tptSummary",tptSummary);
                                       component.set("v.tptPercentSummary",tptPercentSummary);                                  
                                       component.set("v.xAxisLabelsSummary", xAxisLabelsSummary);
                                       component.set("v.salesdlPrevSummary",salesdlPrevSummary);
                                       component.set("v.unitsPrevSummary",unitsPrevSummary);
                                       component.set("v.tptPrevSummary",tptPrevSummary);
                                       component.set("v.tptPercentPrevSummary",tptPercentPrevSummary);
                                       if(component.get("v.filterName") == undefined || component.get("v.filterName") == ''){
                                           component.set("v.filterName",'Recent Sales');
                                           component.set("v.isAsc", false);
                                       } 
                                       console.log('xAxisLabelsSummary present-->'+xAxisLabelsSummary);
                                       helper.buildData(component, event, helper, response); 
                                   }
                                   //} 
                                   /* else{
                                       component.set("v.noData", true);
                                        component.set("v.showBoolean",false);
                                   }*/
                                   
                                   /* else{
                                     component.set("v.InternalResList", response.accWrapMap);  
                                       helper.buildData(component, event, helper, response); 
                                   }*/
                               } else{
                                   component.set("v.loaded", false);
                                   console.log("Error "+JSON.stringify(response.getError()));
                               }
                           });
        $A.enqueueAction(action);  
        
    },
    
    buildData : function(component, event, helper, response) {
        console.log('isEXTChecked==>'+component.get("v.isEXTChecked"))
        var headers = response.dynamicHeaders;
        component.set("v.monthlyData", response.custmonthly);
        var headersList = [];
        component.set("v.headers", headers);
        headersList.push(headers.two);
        headersList.push(headers.one);
        component.set("v.headersList", headersList);
        if(!component.get("v.isEXTChecked")){
            var responseValue = response.accWrapMap;
            console.log('response value==>'+JSON.stringify(responseValue))
            var summaryObj = {};
            var tableData = component.get("v.tableData");
            var showOnlyTenRecords = component.get("v.showOnlyTenRecords");
            console.log('showOnlyTenRecords-->'+showOnlyTenRecords);
            var [salesPrevSummary, salesSummary, salesTrendingSummary, volumePrevSummary, volumeSummary, volumeTrendingSummary, 
                 tptPrevSummary, tptSummary, tptTrendingSummary, tptPPrevSummary, tptPSummary, tptPTrendingSummary]= [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            var sortedResponse = responseValue.sort((a, b) => {
                if (a.salesdl > b.salesdl)
                return -1;
                if (a.salesdl < b.salesdl)
                return 1;
                return 0;
            });
            var customerIds = component.get("v.customerIds");
            if(sortedResponse.length >= 10){
                for(var i=0; i<10; i++){
                    console.log(':::::: '+sortedResponse[i].custId);
                    if(!customerIds.includes(sortedResponse[i].custId)){
                        customerIds.push(sortedResponse[i].custId);
                    } 
                }   
            } else{
                for(var i=0; i<sortedResponse.length; i++){
                    if(!customerIds.includes(sortedResponse[i].custId)){
                        customerIds.push(sortedResponse[i].custId);
                    }  
                }                
            }
            var allCustomerIds = component.get("v.allCustomerIds");
            console.log('1 OK');
            for(var i=0; i<sortedResponse.length; i++){
                if(!allCustomerIds.includes(sortedResponse[i].custId)){
                    allCustomerIds.push(sortedResponse[i].custId);
                }
            }
            component.set("v.customerIds", customerIds);
            console.log('Customer Ids length::: '+customerIds.length);
            component.set("v.allCustomerIds", allCustomerIds);
            for(var i=0; i<responseValue.length; i++){
                var trendingSales;
                var trendingVolume;
                var trendingTPT;
                var trendingTPTPercent;
                if(responseValue[i].SalesDollarPrev == 0 || responseValue[i].salesdl == 0){
                    trendingSales = 0;
                } else{
                    trendingSales = (responseValue[i].salesdl/responseValue[i].SalesDollarPrev)-1;
                }
                if(responseValue[i].UnitsPrev ==0 || responseValue[i].units == 0){
                    trendingVolume = 0;
                } else{
                    trendingVolume = (responseValue[i].units/responseValue[i].UnitsPrev)-1;
                }
                if(responseValue[i].TPTDollarPrev ==0 || responseValue[i].tptdollar == 0){
                    trendingTPT = 0;
                } else{
                    trendingTPT = (responseValue[i].tptdollar/responseValue[i].TPTDollarPrev)-1;
                }
                trendingTPTPercent = (responseValue[i].tptpct - responseValue[i].TPTPctPrev);
                if(trendingTPT != null || trendingTPT != undefined) responseValue[i].trendingSales = trendingSales;
                if(trendingVolume != null || trendingVolume != undefined) responseValue[i].trendingVolume = trendingVolume;
                if(trendingTPT != null || trendingTPT != undefined) responseValue[i].trendingTPT = trendingTPT;
                if(trendingTPTPercent != null || trendingTPTPercent != undefined) responseValue[i].trendingTPTPercent = trendingTPTPercent;
                salesPrevSummary = salesPrevSummary + Math.round((responseValue[i].SalesDollarPrev)*100)/100;
                //Math.round(num * 100) / 100
                salesSummary = salesSummary + Math.round((responseValue[i].salesdl)*100)/100;
                salesTrendingSummary = (salesSummary/salesPrevSummary)-1;
                volumePrevSummary = volumePrevSummary + responseValue[i].UnitsPrev;
                volumeSummary = volumeSummary + responseValue[i].units;
                volumeTrendingSummary = (volumeSummary/volumePrevSummary)-1;
                console.log('tptPrevSummary==>'+responseValue[i].TPTDollarPrev);
                tptPrevSummary = tptPrevSummary + Math.round((responseValue[i].TPTDollarPrev)*100)/100;
                tptSummary = tptSummary + Math.round((responseValue[i].tptdollar)*100)/100;
                tptTrendingSummary = (tptSummary/tptPrevSummary)-1;
                tptPPrevSummary = (tptPrevSummary/salesPrevSummary)*100;
                tptPSummary = (tptSummary/salesSummary)*100;
                tptPTrendingSummary = (tptPSummary - tptPPrevSummary);
            }
            console.log('tptPrevSummary==>'+tptPrevSummary);
            summaryObj.salesPrevSummary = salesPrevSummary;
            summaryObj.salesSummary = salesSummary;
            summaryObj.salesTrendingSummary = salesTrendingSummary;
            summaryObj.volumePrevSummary = volumePrevSummary;
            summaryObj.volumeSummary = volumeSummary;
            summaryObj.volumeTrendingSummary = volumeTrendingSummary;
            summaryObj.tptPrevSummary = tptPrevSummary;
            summaryObj.tptSummary = tptSummary;
            summaryObj.tptTrendingSummary = tptTrendingSummary;
            summaryObj.tptPPrevSummary = tptPPrevSummary;
            summaryObj.tptPSummary = tptPSummary;
            summaryObj.tptPTrendingSummary = tptPTrendingSummary;
            if(salesSummary > salesPrevSummary){
                component.set("v.classS", 'green');
            } else if(salesSummary < salesPrevSummary){
                component.set("v.classS", 'red');
            } else{
                component.set("v.classS", 'yellow');
            }
            if(volumeSummary > volumePrevSummary){
                component.set("v.classV", 'green');
            } else if(volumeSummary < volumePrevSummary){
                component.set("v.classV", 'red');
            } else{
                component.set("v.classV", 'yellow');
            }
            if(tptSummary > tptPrevSummary){
                component.set("v.classT", 'green');
            } else if(tptSummary < tptPrevSummary){
                component.set("v.classT", 'red');
            } else{
                component.set("v.classT", 'yellow');
            }
            if(tptPSummary > tptPPrevSummary){
                component.set("v.classP", 'green');
            } else if(tptPSummary < tptPPrevSummary){
                component.set("v.classP", 'red');
            } else{
                component.set("v.classP", 'yellow');
            }
            
            if(salesTrendingSummary < 0){
                component.set("v.isSalesLessThanZero", true);
            } else{
                component.set("v.isSalesLessThanZero", false);
            }
            if(volumeTrendingSummary < 0){
                component.set("v.isUnitsLessThanZero", true);
            } else{
                component.set("v.isUnitsLessThanZero", false);
            }
            if(tptTrendingSummary < 0){
                component.set("v.isTPTLessThanZero", true);
            } else{
                component.set("v.isTPTLessThanZero", false);
            }
            if(tptPTrendingSummary < 0){
                component.set("v.isTPTPercentLessThanZero", true);
            } else{
                component.set("v.isTPTPercentLessThanZero", false);
            }
            component.set("v.summaryObj", summaryObj);
            component.set("v.responseList",sortedResponse);
            component.set("v.InternalResList",sortedResponse);
            if(sortedResponse.length > 10){
                component.set("v.showMoreButton", true);
            } else{
                component.set("v.showMoreButton", false);
            }
            component.set("v.countOfAccountsOwned", sortedResponse.length);
            console.log('showBoolean-->'+component.get("v.showBoolean"))
            var showTPT = component.get("v.isINTChecked");
            if(component.get("v.showBoolean")){
                var chartobj1 = component.get("v.chartobj1");
                console.log('chartobj1-->'+chartobj1);
                var chartobj2 = component.get("v.chartobj2");
                var chartobj3 = component.get("v.chartobj3");
                var chartobj4 = component.get("v.chartobj4");
                var chartLabels = component.get("v.headersList");
                var el1 = component.find('andeeChart1').getElement();
                console.log('el1-->'+el1)
                var el2 = component.find('andeeChart2').getElement();
                console.log('el2-->'+el2)
                var el3 = component.find('andeeChart3').getElement();
                console.log('el3-->'+el3)
                var el4 = component.find('andeeChart4').getElement(); 
                console.log('el4-->'+el4)
                var ctx1 = el1.getContext('2d'); 
                var ctx2 = el2.getContext('2d');
                var ctx3 = el3.getContext('2d'); 
                var ctx4 = el4.getContext('2d'); 
                if(chartobj1){
                    console.log('in destroy chartobj1')
                    chartobj1.destroy();
                }
                if(chartobj2){
                    chartobj2.destroy();
                }
                
                if(chartobj3){
                    chartobj3.destroy();
                }
                if(chartobj4){
                    chartobj4.destroy();
                }
                var comparison = component.get("v.comparison");
                if(comparison == 'lastquartervspreviousquarter'){
                    console.log('in last quarter vs previous quarter')
                    var QuarterLabelList = [];
                    QuarterLabelList.push(component.get("v.headers.two")+'/'+component.get("v.headers.one"));
                    component.set("v.QuarterLableList",QuarterLabelList );
                    chartobj1 = new Chart(ctx2, {
                        type: 'bar',
                        data: {
                            labels: QuarterLabelList,
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    backgroundColor:'rgba(237, 125, 49)',
                                    borderColor: 'rgba(237, 125, 49)',
                                    data: component.get("v.sumOfPrevSales"),
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor: 'rgb(63, 37, 133)',
                                    borderColor: 'rgb(63, 37, 133)',
                                    data: component.get("v.sumOfRecentSales"),
                                }
                            ]
                        },
                        options: {
                            hover: {
                                mode: "none"
                            },
                            legend: {
                                labels:{
                                    fontStyle: 'bold'
                                }
                            },
                            tooltips: {
                                callbacks: {
                                    label: function(tooltipItems) {
                                        let label = new Intl.NumberFormat('en-US', {
                                            style: 'currency',
                                            currency:"USD",
                                            minimumFractionDigits: 0,
                                            maximumFractionDigits: 0
                                        }).format(tooltipItems.yLabel);
                                        return label;
                                    },
                                }
                            },
                            title: {
                                display: true,
                                text: 'Sales ($)',
                                fontSize: 14
                            },
                            scales: {
                                yAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        callback: function(value, index, values) {
                                            return value / 1e6 + 'M';
                                        },
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Sales ($)',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }],
                                xAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Months',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }]
                                
                            }
                        }
                    });
                    chartobj2 = new Chart(ctx1, {
                        type: 'bar',
                        data: {
                            labels: QuarterLabelList,
                            //component.get("v.xAxisLabelsSummary"),
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    backgroundColor: 'rgba(237, 125, 49)',
                                    borderColor: 'rgba(237, 125, 49)',
                                    data: component.get("v.sumOfPrevUnits")
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor: 'rgb(63, 37, 133)',
                                    borderColor: 'rgb(63, 37, 133)',
                                    data: component.get("v.sumOfRecentUnits")
                                }
                            ]
                        },
                        options: {
                            hover: {
                                mode: "none"
                            },
                            tooltips: {
                                callbacks: {
                                    label: function(tooltipItems) {
                                        let label = new Intl.NumberFormat('en-US', {
                                            minimumFractionDigits: 0,
                                            maximumFractionDigits: 0
                                        }).format(tooltipItems.yLabel);
                                        return label;
                                    },
                                }
                            },
                            legend: {
                                labels:{
                                    fontStyle: 'bold'   
                                }
                            },
                            title: {
                                display: true,
                                text: 'Quantity (EU)',
                                fontSize: 14
                            },
                            scales: {
                                yAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        callback: function(value, index, values) {
                                            return value / 1e6 + 'M';
                                        },
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Quantity (EU)',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }],
                                xAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Months',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }]
                            }
                        }
                    });
                    chartobj3 = new Chart(ctx3, {
                        type: 'bar',
                        data: {
                            labels: QuarterLabelList,
                            //component.get("v.xAxisLabelsSummary"),    //[Sep, Oct]
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    backgroundColor: 'rgba(237, 125, 49)',
                                    borderColor: 'rgba(237, 125, 49)',
                                    data: component.get("v.sumOfPrevTPTDl")   //[12, 13]
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor: 'rgb(63, 37, 133)',
                                    borderColor: 'rgb(63, 37, 133)',
                                    data: component.get("v.sumOfRecentTPTDl")		  //[3lac5, 60]
                                }
                            ]
                        },
                        options: {
                            hover: {
                                mode: "none"
                            },
                            legend: {
                                labels:{
                                    fontStyle: 'bold'   
                                }
                            },
                            title: {
                                display: true,
                                text: 'TPT ($)',
                                fontSize: 14
                            },
                            tooltips: {
                                callbacks: {
                                    label: function(tooltipItems) {
                                        let label = new Intl.NumberFormat('en-US', {
                                            style: 'currency',
                                            currency:"USD",
                                            minimumFractionDigits: 0,
                                            maximumFractionDigits: 0
                                        }).format(tooltipItems.yLabel);
                                        return label;
                                    },
                                }
                            },
                            scales: {
                                yAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        callback: function(value, index, values) {
                                            return value / 1e6 + 'M';
                                        },
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'TPT ($)',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }],
                                xAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Months',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }]
                            }
                        }
                    });
                    chartobj4 = new Chart(ctx4, {
                        type: 'bar',
                        data: {
                            labels: QuarterLabelList,
                            //component.get("v.xAxisLabelsSummary"),
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    backgroundColor: 'rgba(237, 125, 49)',
                                    borderColor: 'rgba(237, 125, 49)',
                                    data: component.get("v.sumOfPrevTPTPerc")
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor: 'rgb(63, 37, 133)',
                                    borderColor: 'rgb(63, 37, 133)',
                                    data: component.get("v.sumOfRecentTPTPerc")
                                }
                            ]
                        },
                        options: {
                            hover: {
                                mode: "none"
                            },
                            tooltips: {
                                callbacks: {
                                    label: function(tooltipItems) {
                                        let label = new Intl.NumberFormat('en-US', {
                                            style: 'percent',
                                            minimumFractionDigits: 0,
                                            maximumFractionDigits: 2
                                        }).format(tooltipItems.yLabel/100);
                                        return label;
                                    },
                                }
                            },
                            legend: {
                                labels:{
                                    fontStyle: 'bold'
                                }
                            },
                            title: {
                                display: true,
                                text: 'TPT %',
                                fontSize: 14
                            },
                            scales: {
                                yAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        fontStyle: 'bold',
                                        max: 100
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'TPT %',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }],
                                xAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Months',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }]
                            }
                        }
                    }); 
                }else{
                    chartobj1 = new Chart(ctx2, {
                        type: 'line',
                        data: {
                            labels: component.get("v.xAxisLabelsSummary"),
                            //plugins:  [pluginTrendlineLinear],
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    borderColor: 'rgba(237, 125, 49)',
                                    backgroundColor:'rgba(237, 125, 49)',
                                    fill: false,
                                    data: component.get("v.salesdlPrevSummary") ,
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor:'rgba(63, 37, 133)',
                                    borderColor: 'rgb(63, 37, 133)',        
                                    fill: false,
                                    data: component.get("v.salesdlSummary"),
                                }
                            ]
                        },
                        options: {
                            hover: {
                                mode: "none"
                            },
                            legend: {
                                labels:{
                                    fontStyle: 'bold'
                                }
                            },
                            tooltips: {
                                callbacks: {
                                    label: function(tooltipItems) {
                                        let label = new Intl.NumberFormat('en-US', {
                                            style: 'currency',
                                            currency:"USD",
                                            minimumFractionDigits: 0,
                                            maximumFractionDigits: 0
                                        }).format(tooltipItems.yLabel);
                                        return label;
                                    },
                                }
                            },
                            title: {
                                display: true,
                                text: 'Sales ($)',
                                fontSize: 14
                            },
                            scales: {
                                yAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        callback: function(value, index, values) {
                                            return value / 1e6 + 'M';
                                        },
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Sales ($)',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }],
                                xAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Months',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }]
                                
                            }
                        },
                        //plugins:[pluginTrendlineLinear],
                    });
                    chartobj2 = new Chart(ctx1, {
                        type: 'line',
                        data: {
                            labels: component.get("v.xAxisLabelsSummary"),
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    borderColor: 'rgba(237, 125, 49)',  
                                    backgroundColor:'rgba(237, 125, 49)',
                                    fill: false,
                                    data: component.get("v.unitsPrevSummary")
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor:'rgba(63, 37, 133)',
                                    borderColor: 'rgba(63, 37, 133)', 
                                    fill: false,
                                    data: component.get("v.unitsSummary")
                                }
                            ]
                        },
                        options: {
                            hover: {
                                mode: "none"
                            },
                            tooltips: {
                                callbacks: {
                                    label: function(tooltipItems) {
                                        let label = new Intl.NumberFormat('en-US', {
                                            minimumFractionDigits: 0,
                                            maximumFractionDigits: 0
                                        }).format(tooltipItems.yLabel);
                                        return label;
                                    },
                                }
                            },
                            legend: {
                                labels:{
                                    fontStyle: 'bold'   
                                }
                            },
                            title: {
                                display: true,
                                text: 'Quantity (EU)',
                                fontSize: 14
                            },
                            scales: {
                                yAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        callback: function(value, index, values) {
                                            return value / 1e6 + 'M';
                                        },
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Quantity (EU)',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }],
                                xAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Months',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }]
                            }
                        }
                    });
                    chartobj3 = new Chart(ctx3, {
                        type: 'line',
                        data: {
                            labels: component.get("v.xAxisLabelsSummary"),    //[Sep, Oct]
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    backgroundColor:'rgba(237, 125, 49)',
                                    borderColor: 'rgba(237, 125, 49)',                 
                                    fill: false,
                                    data: component.get("v.tptPrevSummary")   //[12, 13]
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor:'rgba(63, 37, 133)',
                                    borderColor: 'rgba(63, 37, 133)',
                                    fill: false,
                                    data: component.get("v.tptSummary")		  //[3lac5, 60]
                                }
                            ]
                        },
                        options: {
                            hover: {
                                mode: "none"
                            },
                            legend: {
                                labels:{
                                    fontStyle: 'bold'   
                                }
                            },
                            title: {
                                display: true,
                                text: 'TPT ($)',
                                fontSize: 14
                            },
                            tooltips: {
                                callbacks: {
                                    label: function(tooltipItems) {
                                        let label = new Intl.NumberFormat('en-US', {
                                            style: 'currency',
                                            currency:"USD",
                                            minimumFractionDigits: 0,
                                            maximumFractionDigits: 0
                                        }).format(tooltipItems.yLabel);
                                        return label;
                                    },
                                }
                            },
                            scales: {
                                yAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        callback: function(value, index, values) {
                                            return value / 1e6 + 'M';
                                        },
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'TPT ($)',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }],
                                xAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Months',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }]
                            }
                        }
                    });
                    chartobj4 = new Chart(ctx4, {
                        type: 'line',
                        data: {
                            labels: component.get("v.xAxisLabelsSummary"),
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    backgroundColor:'rgba(237, 125, 49)',
                                    borderColor: 'rgba(237, 125, 49)',          
                                    fill: false,
                                    data: component.get("v.tptPercentPrevSummary")
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor:'rgba(63, 37, 133)',
                                    borderColor: 'rgba(63, 37, 133)',   
                                    fill: false,
                                    data: component.get("v.tptPercentSummary")
                                }
                            ]
                        },
                        options: {
                            hover: {
                                mode: "none"
                            },
                            tooltips: {
                                callbacks: {
                                    label: function(tooltipItems) {
                                        let label = new Intl.NumberFormat('en-US', {
                                            style: 'percent',
                                            minimumFractionDigits: 0,
                                            maximumFractionDigits: 2
                                        }).format(tooltipItems.yLabel/100);
                                        return label;
                                    },
                                }
                            },
                            legend: {
                                labels:{
                                    fontStyle: 'bold'
                                }
                            },
                            title: {
                                display: true,
                                text: 'TPT %',
                                fontSize: 14
                            },
                            scales: {
                                yAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'TPT %',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }],
                                xAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Months',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }]
                            }
                        }
                    });
                }
                component.set("v.chartobj1",chartobj1);
                component.set("v.chartobj2",chartobj2);
                component.set("v.chartobj3",chartobj3);
                component.set("v.chartobj4",chartobj4);
                var selectedUserId = component.get("v.selectedUser");
                var showInt= component.get("V.ShowINT");
                console.log('show int in build data-->'+showInt);
                var recentLastMonth = component.get("V.recentLastMonth");
                var previousLastMonth = component.get("V.previousLastMonth");
                helper.getChartData(component, event, helper,showInt,recentLastMonth,previousLastMonth); 
            }
        }
        else{
            var summaryObj = {};
            responseValue = response.salesList;
            console.log('responseValue==??'+JSON.stringify(responseValue))
            var tableData = component.get("v.tableData");
            var showOnlyTenRecords = component.get("v.showOnlyTenRecords");
            console.log('showOnlyTenRecords-->'+showOnlyTenRecords);
            var [salesPrevSummary, salesSummary, salesTrendingSummary, volumePrevSummary, volumeSummary, volumeTrendingSummary, 
                 tptPrevSummary, tptSummary, tptTrendingSummary, tptPPrevSummary, tptPSummary, tptPTrendingSummary]= [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            
            var sortedResponse = responseValue.sort((a, b) => {
                if (a.salesdl > b.salesdl)
                return -1;
                if (a.salesdl < b.salesdl)
                return 1;
                return 0;
            });
            console.log('sorted response==>'+JSON.stringify(sortedResponse));
            var customerIds = component.get("v.customerIds");
            var allcustDescList=[];
            if(component.get("v.isEXTChecked")){
                if(sortedResponse.length >= 10){
                    for(var i=0; i<10; i++){
                        console.log(':::::: '+sortedResponse[i].custId);
                        if(!customerIds.includes(sortedResponse[i].custId)){
                            customerIds.push(sortedResponse[i].custId);
                        } 
                    }   
                } else{
                    for(var i=0; i<sortedResponse.length; i++){
                        if(!customerIds.includes(sortedResponse[i].custId)){
                            customerIds.push(sortedResponse[i].custId);
                        }  
                    }                
                }
                var allCustomerIds = component.get("v.allCustomerIds");
                console.log('1 OK');
                for(var i=0; i<sortedResponse.length; i++){
                    if(!allCustomerIds.includes(sortedResponse[i].custId)){
                        allCustomerIds.push(sortedResponse[i].custId);
                    }
                }
                component.set("v.customerIds", customerIds);
                console.log('Customer Ids length::: '+customerIds.length);
                component.set("v.allCustomerIds", allCustomerIds);
            }
            else{
                if(sortedResponse.length >= 10){
                    for(var i=0; i<10; i++){
                        console.log(':::::: '+sortedResponse[i].custId);
                        if(!customerIds.includes(sortedResponse[i].custId)){
                            customerIds.push(sortedResponse[i].custId);
                        } 
                    }   
                } else{
                    for(var i=0; i<sortedResponse.length; i++){
                        if(!customerIds.includes(sortedResponse[i].custId)){
                            customerIds.push(sortedResponse[i].custId);
                        }  
                    }                
                }
                var allCustomerIds = component.get("v.allCustomerIds");
                console.log('1 OK');
                for(var i=0; i<sortedResponse.length; i++){
                    if(!allCustomerIds.includes(sortedResponse[i].custId)){
                        allCustomerIds.push(sortedResponse[i].custId);
                        
                    }
                }
                component.set("v.customerIds", customerIds);
                console.log('Customer Ids length::: '+customerIds.length);
                component.set("v.allCustomerIds", allCustomerIds);
            }
            
            for(var i=0;i<responseValue.length;i++){
                console.log('response length==>'+(responseValue[i].childSalesList).length)
            }
            var custDescList = component.get("v.custDescList");
            for(var i=0;i<responseValue.length;i++){
                for(var j=0; j<(responseValue[i].childSalesList).length; j++){
                    console.log('units 1: '+responseValue[i].childSalesList[j].units);
                    console.log('id 1: '+responseValue[i].childSalesList[j].custId);
                    customerIds.push(responseValue[i].childSalesList[j].custId);
                    custDescList.push(responseValue[i].childSalesList[j].custName)
                    var trendingSales;
                    var trendingVolume;
                    var trendingTPT;
                    var trendingTPTPercent;
                    if(parseInt(responseValue[i].childSalesList[j].SalesDollarPrev) == 0 || parseInt(responseValue[i].childSalesList[j].salesdl) == 0){
                        trendingSales = 0;
                    } else{
                        trendingSales = (parseInt(responseValue[i].childSalesList[j].salesdl)/parseInt(responseValue[i].childSalesList[j].SalesDollarPrev))-1;
                    }
                    if(parseInt(responseValue[i].childSalesList[j].UnitsPrev) ==0 || parseInt(responseValue[i].childSalesList[j].units) == 0){
                        trendingVolume = 0;
                    } else{
                        trendingVolume = (responseValue[i].childSalesList[j].units/responseValue[i].childSalesList[j].UnitsPrev)-1;
                    }
                    if(responseValue[i].childSalesList[j].TPTDollarPrev ==0 || responseValue[i].childSalesList[j].tptdollar == 0){
                        trendingTPT = 0;
                    } else{
                        trendingTPT = (responseValue[i].childSalesList[j].tptdollar/responseValue[i].childSalesList[j].TPTDollarPrev)-1;
                    }
                    trendingTPTPercent = (responseValue[i].childSalesList[j].tptpct - responseValue[i].childSalesList[j].TPTPctPrev);
                    if(trendingTPT != null || trendingTPT != undefined) responseValue[i].childSalesList[j].trendingSales = trendingSales;
                    if(trendingVolume != null || trendingVolume != undefined) responseValue[i].childSalesList[j].trendingVolume = trendingVolume;
                    if(trendingTPT != null || trendingTPT != undefined) responseValue[i].childSalesList[j].trendingTPT = trendingTPT;
                    if(trendingTPTPercent != null || trendingTPTPercent != undefined) responseValue[i].childSalesList[j].trendingTPTPercent = trendingTPTPercent;
                    salesPrevSummary = salesPrevSummary + Math.round(responseValue[i].childSalesList[j].SalesDollarPrev);
                    console.log('salesPrevSummaryyyy-->'+salesPrevSummary);
                    salesSummary = salesSummary + Math.round(responseValue[i].childSalesList[j].salesdl);
                    salesTrendingSummary = (salesSummary/salesPrevSummary)-1;
                    volumePrevSummary = volumePrevSummary + responseValue[i].childSalesList[j].UnitsPrev;
                    console.log('volumePrevSummaryyyy-->'+volumePrevSummary);
                    volumeSummary = volumeSummary + responseValue[i].childSalesList[j].units;
                    volumeTrendingSummary = (volumeSummary/volumePrevSummary)-1;
                    tptPrevSummary = tptPrevSummary + responseValue[i].childSalesList[j].TPTDollarPrev;
                    tptSummary = tptSummary + responseValue[i].childSalesList[j].tptdollar;
                    tptTrendingSummary = (tptSummary/tptPrevSummary)-1;
                    tptPPrevSummary = (tptPrevSummary/salesPrevSummary)*100;
                    tptPSummary = (tptSummary/salesSummary)*100;
                    tptPTrendingSummary = (tptPSummary - tptPPrevSummary);
                    component.set("v.salesTrendingSummary",salesTrendingSummary);
                    //for total summary indicators//
                    if(salesSummary > salesPrevSummary){
                        component.set("v.classS", 'green');
                    } else if(salesSummary < salesPrevSummary){
                        component.set("v.classS", 'red');
                    } else{
                        component.set("v.classS", 'yellow');
                    }
                    if(volumeSummary > volumePrevSummary){
                        component.set("v.classV", 'green');
                    } else if(volumeSummary < volumePrevSummary){
                        component.set("v.classV", 'red');
                    } else{
                        component.set("v.classV", 'yellow');
                    }
                    console.log('salesSummary1: '+salesSummary);
                    console.log('salesPrevSummary1: '+salesPrevSummary);
                    console.log('volumeSummary1: '+volumeSummary);
                    console.log('volumePrevSummary1: '+volumePrevSummary);
                }
            }
            //for cust id's//
            for(var i=0;i<10;i++){
                allCustomerIds.push(customerIds[i]);
                allcustDescList.push(custDescList[i]);
            }
            console.log('all cust ids==>'+allCustomerIds)
            component.set("v.customerIds", allCustomerIds);
            component.set("v.custDescList", custDescList);
            component.set("v.allcustDescList", allcustDescList);
            summaryObj.salesPrevSummary = salesPrevSummary;
            summaryObj.salesSummary = salesSummary;
            summaryObj.salesTrendingSummary = salesTrendingSummary;
            summaryObj.volumePrevSummary = volumePrevSummary;
            summaryObj.volumeSummary = volumeSummary;
            summaryObj.volumeTrendingSummary = volumeTrendingSummary;
            summaryObj.tptPrevSummary = tptPrevSummary;
            summaryObj.tptSummary = tptSummary;
            summaryObj.tptTrendingSummary = tptTrendingSummary;
            summaryObj.tptPPrevSummary = tptPPrevSummary;
            summaryObj.tptPSummary = tptPSummary;
            summaryObj.tptPTrendingSummary = tptPTrendingSummary;
            /*if(salesSummary > salesPrevSummary){
            component.set("v.classS", 'green');
        } else if(salesSummary < salesPrevSummary){
            component.set("v.classS", 'red');
        } else{
            component.set("v.classS", 'yellow');
        }
        if(volumeSummary > volumePrevSummary){
            component.set("v.classV", 'green');
        } else if(volumeSummary < volumePrevSummary){
            component.set("v.classV", 'red');
        } else{
            component.set("v.classV", 'yellow');
        }
        if(tptSummary > tptPrevSummary){
            component.set("v.classT", 'green');
        } else if(tptSummary < tptPrevSummary){
            component.set("v.classT", 'red');
        } else{
            component.set("v.classT", 'yellow');
        }
        if(tptPSummary > tptPPrevSummary){
            component.set("v.classP", 'green');
        } else if(tptPSummary < tptPPrevSummary){
            component.set("v.classP", 'red');
        } else{
            component.set("v.classP", 'yellow');
        }
        */
            if(salesTrendingSummary < 0){
                component.set("v.isSalesLessThanZero", true);
            } else{
                component.set("v.isSalesLessThanZero", false);
            }
            if(volumeTrendingSummary < 0){
                component.set("v.isUnitsLessThanZero", true);
            } else{
                component.set("v.isUnitsLessThanZero", false);
            }
            if(tptTrendingSummary < 0){
                component.set("v.isTPTLessThanZero", true);
            } else{
                component.set("v.isTPTLessThanZero", false);
            }
            if(tptPTrendingSummary < 0){
                component.set("v.isTPTPercentLessThanZero", true);
            } else{
                component.set("v.isTPTPercentLessThanZero", false);
            }
            component.set("v.summaryObj", summaryObj);
            console.log('Summary Obj: '+JSON.stringify(summaryObj));
            component.set("v.responseList",sortedResponse);
            if(sortedResponse.length > 10){
                component.set("v.showMoreButton", true);
            } else{
                component.set("v.showMoreButton", false);
            }
            component.set("v.countOfAccountsOwned", sortedResponse.length);
            console.log('testing-->'+component.get("v.showBoolean"))
            if(component.get("v.showBoolean")){
                console.log('abcccc--')
                var chartobj5 = component.get("v.chartobj5");
                console.log('chartobj5-->'+chartobj5);
                var chartobj6 = component.get("v.chartobj6");
                var chartLabels = component.get("v.headersList");
                var el5 = component.find('andeeChart5').getElement();
                var el6 = component.find('andeeChart6').getElement();
                var ctx5 = el5.getContext('2d'); 
                var ctx6 = el6.getContext('2d');
                if(chartobj5){
                    console.log('in destroy chartobj5')
                    chartobj5.destroy();
                }
                if(chartobj6){
                    chartobj6.destroy();
                }
                var comparison = component.get("v.comparison");
                if(comparison == 'lastquartervspreviousquarter'){
                    console.log('in last quarter vs previous quarter')
                    var QuarterLabelList = [];
                    QuarterLabelList.push(component.get("v.headers.two")+'/'+component.get("v.headers.one"));
                    component.set("v.QuarterLableList",QuarterLabelList );
                    chartobj5 = new Chart(ctx6, {
                        type: 'bar',
                        data: {
                            labels: QuarterLabelList,
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    backgroundColor:'rgba(237, 125, 49)',
                                    borderColor: 'rgba(237, 125, 49)',
                                    data: component.get("v.sumOfPrevSales"),
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor: 'rgb(63, 37, 133)',
                                    borderColor: 'rgb(63, 37, 133)',
                                    data: component.get("v.sumOfRecentSales"),
                                }
                            ]
                        },
                        options: {
                            hover: {
                                mode: "none"
                            },
                            legend: {
                                labels:{
                                    fontStyle: 'bold'
                                }
                            },
                            tooltips: {
                                callbacks: {
                                    label: function(tooltipItems) {
                                        let label = new Intl.NumberFormat('en-US', {
                                            style: 'currency',
                                            currency:"USD",
                                            minimumFractionDigits: 0,
                                            maximumFractionDigits: 0
                                        }).format(tooltipItems.yLabel);
                                        return label;
                                    },
                                }
                            },
                            title: {
                                display: true,
                                text: 'Sales ($)',
                                fontSize: 14
                            },
                            scales: {
                                yAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        callback: function(value, index, values) {
                                            return value / 1e6 + 'M';
                                        },
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Sales ($)',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }],
                                xAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Months',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }]
                                
                            }
                        }
                    });
                    chartobj6 = new Chart(ctx5, {
                        type: 'bar',
                        data: {
                            labels: QuarterLabelList,
                            //component.get("v.xAxisLabelsSummary"),
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    backgroundColor: 'rgba(237, 125, 49)',
                                    borderColor: 'rgba(237, 125, 49)',
                                    data: component.get("v.sumOfPrevUnits")
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor: 'rgb(63, 37, 133)',
                                    borderColor: 'rgb(63, 37, 133)',
                                    data: component.get("v.sumOfRecentUnits")
                                }
                            ]
                        },
                        options: {
                            hover: {
                                mode: "none"
                            },
                            tooltips: {
                                callbacks: {
                                    label: function(tooltipItems) {
                                        let label = new Intl.NumberFormat('en-US', {
                                            minimumFractionDigits: 0,
                                            maximumFractionDigits: 0
                                        }).format(tooltipItems.yLabel);
                                        return label;
                                    },
                                }
                            },
                            legend: {
                                labels:{
                                    fontStyle: 'bold'   
                                }
                            },
                            title: {
                                display: true,
                                text: 'Quantity (EU)',
                                fontSize: 14
                            },
                            scales: {
                                yAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        callback: function(value, index, values) {
                                            return value / 1e6 + 'M';
                                        },
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Quantity (EU)',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }],
                                xAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Months',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }]
                            }
                        }
                    });
                }
                else{
                    console.log('test1==>'+component.get("v.xAxisLabelsSummary"));
                    console.log('test2==>'+component.get("v.salesdlPrevSummary"));
                    chartobj5 = new Chart(ctx6, {
                        type: 'line',
                        data: {
                            labels: component.get("v.xAxisLabelsSummary"),
                            //plugins:  [pluginTrendlineLinear],
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    borderColor: 'rgba(237, 125, 49)',
                                    backgroundColor:'rgba(237, 125, 49)',
                                    fill: false,
                                    data: component.get("v.salesdlPrevSummary") ,
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor:'rgba(63, 37, 133)',
                                    borderColor: 'rgb(63, 37, 133)',        
                                    fill: false,
                                    data: component.get("v.salesdlSummary"),
                                }
                            ]
                        },
                        options: {
                            hover: {
                                mode: "none"
                            },
                            legend: {
                                labels:{
                                    fontStyle: 'bold'
                                }
                            },
                            tooltips: {
                                callbacks: {
                                    label: function(tooltipItems) {
                                        let label = new Intl.NumberFormat('en-US', {
                                            style: 'currency',
                                            currency:"USD",
                                            minimumFractionDigits: 0,
                                            maximumFractionDigits: 0
                                        }).format(tooltipItems.yLabel);
                                        return label;
                                    },
                                }
                            },
                            title: {
                                display: true,
                                text: 'Sales ($)',
                                fontSize: 14
                            },
                            scales: {
                                yAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        callback: function(value, index, values) {
                                            return value / 1e6 + 'M';
                                        },
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Sales ($)',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }],
                                xAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Months',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }]
                                
                            }
                        },
                        //plugins:[pluginTrendlineLinear],
                    });
                    chartobj6 = new Chart(ctx5, {
                        type: 'line',
                        data: {
                            labels: component.get("v.xAxisLabelsSummary"),
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    borderColor: 'rgba(237, 125, 49)',  
                                    backgroundColor:'rgba(237, 125, 49)',
                                    fill: false,
                                    data: component.get("v.unitsPrevSummary")
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor:'rgba(63, 37, 133)',
                                    borderColor: 'rgba(63, 37, 133)', 
                                    fill: false,
                                    data: component.get("v.unitsSummary")
                                }
                            ]
                        },
                        options: {
                            hover: {
                                mode: "none"
                            },
                            tooltips: {
                                callbacks: {
                                    label: function(tooltipItems) {
                                        let label = new Intl.NumberFormat('en-US', {
                                            minimumFractionDigits: 0,
                                            maximumFractionDigits: 0
                                        }).format(tooltipItems.yLabel);
                                        return label;
                                    },
                                }
                            },
                            legend: {
                                labels:{
                                    fontStyle: 'bold'   
                                }
                            },
                            title: {
                                display: true,
                                text: 'Quantity (EU)',
                                fontSize: 14
                            },
                            scales: {
                                yAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        callback: function(value, index, values) {
                                            return value / 1e6 + 'M';
                                        },
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Quantity (EU)',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }],
                                xAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        fontStyle: 'bold'
                                    },
                                    scaleLabel: {
                                        display: true,
                                        labelString: 'Months',
                                        fontStyle: 'bold',
                                        fontSize: 14
                                    }
                                }]
                            }
                        }
                    });
                }
            }
            var showTPT = component.get("v.isEXTChecked");
            component.set("v.chartobj1",chartobj1);
            component.set("v.chartobj2",chartobj2);
            component.set("v.chartobj3",chartobj3);
            component.set("v.chartobj4",chartobj4);
            var showInt= component.get("V.ShowINT");
            var recentLastMonth = component.get("V.recentLastMonth");
            var previousLastMonth = component.get("V.previousLastMonth");
            helper.getChartData(component, event, helper,showInt,recentLastMonth,previousLastMonth);
            
        }
    },
    
    getChartData: function(component, event, helper,showInt,recentLastMonth,previousLastMonth){
        console.log('showInt in getchartData==>'+component.get("v.isEXTChecked"));
        component.set('v.loaded', true);
        var selectedComparison = component.get("v.comparison");
        
        var action;
        if(selectedComparison == 'last12monthsvsprevious12months'){
            action = component.get("c.getLasttwmonthsVsPrevtwmonthsData");
        } else if(selectedComparison == 'lastquartervspreviousquarter'){
            action = component.get("c.getLastQuarterVsPrevQuarterData");
        } else if(selectedComparison == 'fytdvspreviousfytd'){
            action = component.get("c.getfytdData");
        }
        console.log('Customer Ids::1 '+component.get("v.customerIds"));
        console.log('Selections: '+component.get("v.selections"));
        console.log('selectedComparison: '+component.get("v.comparison"));
        console.log('custDesc List: '+component.get("v.custDescList"));
        //var action = component.get("c.getDRLSalesRelatedList");
        console.log('chart searchText====='+component.get("v.searchText"));
        action.setParams({
            selections: component.get("v.selections"),
            selectedComparison: component.get("v.comparison"),
            customerIds: component.get("v.customerIds"),
            isEXTChecked:component.get("v.isEXTChecked"),
            recentLastMonth:recentLastMonth,
            previousLastMonth:previousLastMonth,
            searchText : component.get("v.searchText"),
            custDesc :component.get("v.allcustDescList") 
            
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var response= response.getReturnValue();
                                   console.log('total response-->'+JSON.stringify(response))
                                   component.set("v.allAccountsChartData", response);
                                   console.log('Sales Records::: '+JSON.stringify(response));
                                   component.set("v.loaded", false);
                               } else{
                                   component.set("v.loaded", false);
                                   console.log("Error "+JSON.stringify(response.getError()));
                               }
                           });
        $A.enqueueAction(action); 
    },
    
    convertArrayOfObjectsToCSV: function (component, objectRecords,showTPTValue,reportName) {
        console.log("showTPTValue1--->"+showTPTValue);
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        columnDivider = ',';
        lineDivider = '\n';
        var myMap = new Map();
        csvStringResult = '';
        myMap.set("Customer Account", "custName");
        myMap.set(component.get('v.headers.two')+' '+'(Quantity (EU))', "UnitsPrev");
        myMap.set(component.get('v.headers.one')+' '+'(Quantity (EU))', "units");
        myMap.set("Trending"+' '+'(Quantity (EU))', "trendingVolume");
        myMap.set(component.get('v.headers.two')+' '+'(Sales ($))', "SalesDollarPrev");      
        myMap.set(component.get('v.headers.one')+' '+'(Sales ($))', "salesdl");
        myMap.set('Trending'+' '+'(Sales ($))', "trendingSales");
        if(!showTPTValue){
            myMap.set(component.get('v.headers.two')+' '+'(TPT ($)))', "TPTDollarPrev");
            myMap.set(component.get('v.headers.one')+' '+'(TPT ($))', "tptdollar");
            myMap.set("Trending"+' '+'(TPT ($))', "trendingTPT");
            myMap.set(component.get('v.headers.two')+' '+'(TPT %)', "TPTPctPrev");
            myMap.set(component.get('v.headers.one')+' '+'(TPT %)', "tptpct");
            myMap.set("Trending"+' '+'(TPT %)', "trendingTPTPercent");
        }
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        
        
        for (var i = 0; i < objectRecords.length; i++) {
            counter = 0;
            for (let [key, value] of myMap) {
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }
                if(value == 'trendingSales'){
                    var trending_Sales=objectRecords[i]['trendingSales'];
                    if(trending_Sales != null){
                        var sales_rounded_le=((trending_Sales) * 100).toFixed(2);
                        csvStringResult += '"'+ sales_rounded_le +'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                        
                    }
                }
                else if(value == 'trendingVolume'){
                    var trending_volume=objectRecords[i]['trendingVolume'];
                    if(trending_volume != null){
                        var volume_rounded_le=((trending_volume) * 100).toFixed(2);
                        csvStringResult += '"'+ volume_rounded_le +'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                        
                    }
                }
                    else if(value == 'trendingTPT'){
                        var trending_TPT=objectRecords[i]['trendingTPT'];
                        if(trending_TPT != null){
                            var tpt_rounded_le=((trending_TPT) * 100).toFixed(2);
                            csvStringResult += '"'+ tpt_rounded_le +'"';
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                            
                        }
                    }
                        else if(value == 'trendingTPTPercent'){
                            var trending_TPTPer=objectRecords[i]['trendingTPTPercent'];
                            if(trending_TPTPer != null){
                                var sales_rounded_le=((trending_TPTPer)).toFixed(2);
                                csvStringResult += '"'+ sales_rounded_le +'"';
                            }
                            else{
                                csvStringResult += '"'+''+'"';
                                
                            }
                        }
                            else  if (objectRecords[i][value] == undefined) {
                                csvStringResult += '"' + '' + '"';
                            } else {
                                csvStringResult += '"' + objectRecords[i][value] + '"';
                            }
                
                counter++;
            }
            csvStringResult += lineDivider;
        }   
        
        return csvStringResult;
    },
    sortBy: function(component, field, helper) {
        var sortAsc = component.get("v.isAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.responseList");
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        console.log('asc-----',+component.get("v.isAsc"));
        component.set("v.isAsc", sortAsc);
        component.set("v.InternalResList", records);
        component.set('v.loaded', false);
        component.set("v.customerId", null);
        component.set("v.customerIds", []);
        component.set("v.allCustomerIds", []);
        var customerIds = component.get("v.customerIds");
        if(records.length >= 10){
            for(var i=0; i<10; i++){
                console.log(':::::: '+records[i].custId);
                if(!customerIds.includes(records[i].custId)){
                    customerIds.push(records[i].custId);
                } 
            }   
        } else{
            for(var i=0; i<records.length; i++){
                if(!customerIds.includes(records[i].custId)){
                    customerIds.push(records[i].custId);
                }  
            }                
        }
        var allCustomerIds = component.get("v.allCustomerIds");
        console.log('1 OK');
        for(var i=0; i<records.length; i++){
            if(!allCustomerIds.includes(records[i].custId)){
                allCustomerIds.push(records[i].custId);
            }
        }
        component.set("v.customerIds", customerIds);
        console.log('Customer Ids length::: '+customerIds.length);
        component.set("v.allCustomerIds", allCustomerIds);
        if(records.length > 10){
            component.set("v.showMoreButton", true);
        } else{
            component.set("v.showMoreButton", false);
        }
        var showInt= component.get("V.ShowINT");
        this.getChartData(component, event, helper,showInt);
    },
    
    sortByExt: function(component, field, helper) {
        component.set("v.loaded", true);
        var sortAsc = component.get("v.isAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.resList");
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = parseFloat(a[field]) == parseFloat(b[field]),
                t2 = (!parseFloat(a[field]) && parseFloat(b[field])) || (parseFloat(a[field]) < parseFloat(b[field]));
            console.log('a-----',+a[field]);
            console.log('b-----',+b[field]);
            console.log('t2----',+t2);
            console.log('return----'+t1? 0: (sortAsc?-1:1)*(t2?1:-1));
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        /*    var sortAsc = component.get("v.isAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.resList");
         component.set("v.isAsc",!sortAsc);
        console.log('sortAsc-----'+sortAsc);
     //sortAsc = field == sortField? !sortAsc: true;
       var key = function(a) { return a[sortField]; }
            var reverse = sortAsc ? 1: -1;
        records.sort(function(a,b){
                    var a = key(a) ? key(a) : '';
                    var b = key(b) ? key(b) : '';
             console.log('a-----',+a);
             console.log('b-----',+b);
         return reverse * ((a>b) - (b>a));
                });*/
        component.set("v.isAsc", sortAsc);
          for(var i=0;i<records.length;i++){
         if(records[i].hierarchyCode == null){
                for(var j=0; j<(records[i].childSalesList).length; j++){
                   var key = function(a) { return a[sortField]; }
            var reverse = sortAsc ? 1: -1;
        records[i].childSalesList.sort(function(a,b){
                    var a = key(a) ? parseFloat(key(a)) : '';
                    var b = key(b) ? parseFloat(key(b)) : '';
                    return reverse * ((a>b) - (b>a));
                });  
                }
                }
       }
        component.set("v.resList", records);
        console.log('records==>'+JSON.stringify(records))
        component.set('v.loaded', false);
    },
    sortByExtData: function(component, field, helper,txtVal) {
        component.set("v.loaded", true);
        var selectedRecord=[];
        
        
        var sortAsc = component.get("v.isAscChild"),
            sortField = component.get("v.sortField"),
            records = component.get("v.resList");
        for(var i=0;i<records.length;i++){
            if(records[i].parentAccName == txtVal){
                selectedRecord.push(records[i].childSalesList);   
            }
        }
        console.log('type====='+typeof selectedRecord);
        console.log('records[i].childSalesList====='+JSON.stringify(selectedRecord));
        selectedRecord[0].forEach(function(item){
            console.log('item=====',+JSON.stringify(item));       
            
            console.log('salesdl=====',+item.salesdl);       
        });
        sortAsc = field == sortField? !sortAsc: true;
        selectedRecord[0].sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            console.log('a-----',+a[field]);
            console.log('b-----',+b[field]);
            console.log('t2----',+t2);
            console.log('return----'+t1? 0: (sortAsc?-1:1)*(t2?1:-1));
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        //console.log('records[i].childSalesList sorted====='+JSON.stringify(selectedRecord));
        if(records != undefined && records != null && $A.util.isArray(records) && records.length>0){            
            for(var i=0;i<records.length;i++){
                if(records[i].parentAccName == txtVal){
                    records[i].childSalesList = selectedRecord[0];
                }
            }
            //    console.log('records[i].childSalesList records====='+JSON.stringify(records));
            
        }
        /*    var sortAsc = component.get("v.isAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.resList");
         component.set("v.isAsc",!sortAsc);
        console.log('sortAsc-----'+sortAsc);
     //sortAsc = field == sortField? !sortAsc: true;
       var key = function(a) { return a[sortField]; }
            var reverse = sortAsc ? 1: -1;
        records.sort(function(a,b){
                    var a = key(a) ? key(a) : '';
                    var b = key(b) ? key(b) : '';
             console.log('a-----',+a);
             console.log('b-----',+b);
         return reverse * ((a>b) - (b>a));
                });*/
         component.set("v.isAscChild", sortAsc);
         /*    for(var i=0;i<records.length;i++){
                for(var j=0; j<(records[i].childSalesList).length; j++){
                   var key = function(a) { return a[sortField]; }
            var reverse = sortAsc ? 1: -1;
        records[i].childSalesList.sort(function(a,b){
                    var a = key(a) ? key(a) : '';
                    var b = key(b) ? key(b) : '';
            console.log('a chuld-----',+a);
             console.log('b child-----',+b);
            console.log('reverse-----',+reverse * ((a>b) - (b>a)));
                    return reverse * ((a>b) - (b>a));
                });  
                }
       }*/
         component.set("v.resList", records);
         console.log('records==>'+JSON.stringify(records))
         component.set('v.loaded', false);
     }
})