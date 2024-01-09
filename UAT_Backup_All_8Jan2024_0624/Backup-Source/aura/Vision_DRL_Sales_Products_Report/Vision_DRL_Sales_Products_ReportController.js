({
    initRecords : function(component,event,helper){
        var pageReference = component.get("v.pageReference");
        component.set("v.accId", pageReference.state.c__refAccId);
        component.set("v.accName", pageReference.state.c__refAccName);
        component.set("v.accCode", pageReference.state.c__refAccCode);
        component.set("v.selectedComparision", pageReference.state.c__selectedComparision);
       //component.set("v.ShowINT",pageReference.state.c__ShowINT);
         console.log('showTPT-->'+pageReference.state.c__showTPT);
        var selections = component.get("v.selections");
        if(pageReference.state.c__showTPT == 'false'){
           component.set("v.showTPT", false);  
            //component.set("v.ShowINT", false);
        }else{
           component.set("v.showTPT", true); 
            //component.set("v.ShowINT", true);  
        }
        if(pageReference.state.c__isRxChecked == 'true'){
            console.log('Rx');
            component.set("v.isRxChecked", pageReference.state.c__isRxChecked);
        	selections.push('Rx');    
        } else{
            console.log('Rx else'+pageReference.state.c__isRxChecked);
            component.set("v.isRxChecked", false);
        }
        if(pageReference.state.c__isSRxChecked == 'true'){
            console.log('SRx');
            component.set("v.isSRxChecked", pageReference.state.c__isSRxChecked);
        	selections.push('SRx');    
        } else{
            console.log('SRx else'+pageReference.state.c__isSRxChecked);
            component.set("v.isSRxChecked", false);
        }
        if(pageReference.state.c__isOTCChecked == 'true'){
            console.log('OTC');
            component.set("v.isOtcChecked", pageReference.state.c__isOTCChecked);
        	selections.push('OTC');    
        } else{
            console.log('SRx else'+pageReference.state.c__isOTCChecked);
            component.set("v.isOtcChecked", false);
        }
        component.set("v.selections", selections);
        //component.set("v.showTPT",pageReference.state.c__showTPT)
        
        console.log('isSRxChecked-->'+component.get("v.isSRxChecked"));
		console.log('show tpt value init-->'+component.get("v.showTPT"))
        component.set("v.showChart", true);
        // var showInt= component.get("V.ShowINT");
        var showInt= component.get("v.showTPT");
        helper.getData(component, event, helper,showInt);
        
    },
    handleChange: function (component, event, helper) {
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
        component.set("v.comparison", selectedOptionValue);
        component.set("v.customerId", null);
        component.set("v.productFamilies", []);
        component.set("v.allProductFamilies", []);
         //var showInt= component.get("V.ShowINT");
        console.log('show tpt value handle change-->'+component.get("v.showTPT"))
         var showInt= component.get("v.showTPT");
        if(component.get("v.res") != null){
                                        component.set("v.showBoolean",true);
                                    }else{
                                         component.set("v.showBoolean",false);
                                    }
        helper.getData(component, event, helper,showInt);
    },
    scrollToSummaryBlock: function(component, event, helper){
        var scrollOptions = {
            left: 0,
            top: 510,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);
        /*var target = component.find("summaryBlock");
        var element = target.getElement();
        var rect = element.getBoundingClientRect();
        scrollTo({top: rect.top, behavior: "smooth"});*/
    },
   
    searchSrxRxOttc: function(component, event, helper){
        var rx = component.get("v.isRxChecked");
        var sRx = component.get("v.isSRxChecked");
        var otc = component.get("v.isOtcChecked");
        var selections = component.get("v.selections");
        if(rx == true && !selections.includes('Rx')){
            selections.push('Rx');
        }
        if(sRx == true && !selections.includes('SRx')){
            selections.push('SRx');
        }
        if(otc == true && !selections.includes('OTC')){
            selections.push('OTC');
        }
        if(rx == false && selections.includes('Rx')){
            var ind = selections.indexOf('Rx');
            selections.splice(ind, 1);
        }
        if(sRx == false && selections.includes('SRx')){
            var ind = selections.indexOf('SRx');
            selections.splice(ind, 1);
        }
        if(otc == false && selections.includes('OTC')){
            var ind = selections.indexOf('OTC');
            selections.splice(ind, 1);
        }
        component.set("v.selections", selections);
        component.set("v.customerId", null);
        component.set("v.productFamilies", []);
        component.set("v.allProductFamilies", []);
         console.log('show tpt value handle search srx-->'+component.get("v.showTPT"))
         //var showInt= component.get("V.ShowINT");
          var showInt= component.get("v.showTPT");
        if(component.get("v.res") != null){
                                        component.set("v.showBoolean",true);
                                    }else{
                                         component.set("v.showBoolean",false);
                                    }
		helper.getData(component, event, helper,showInt);
    },
    searchIntExt: function(component, event, helper){
        console.log('uncheck')
        console.log('test->'+component.get("v.isINTChecked"));
        var isIntCheck = component.get("v.isINTChecked");
        var trueValue = true;
        var falsevalue = false;
        if(isIntCheck == false){
            component.set("v.isINTChecked",falsevalue);
            component.set("V.ShowINT",trueValue);
        }
      else{
    	component.set("v.isINTChecked",trueValue); 
          component.set("V.ShowINT",falsevalue);
		}
         console.log('show tpt value search in EXT-->'+component.get("v.showTPT"))
          component.set("v.customerId", null);
        component.set("v.productFamilies", []);
        component.set("v.allProductFamilies", []);
        //var showInt= component.get("V.ShowINT");
         var showInt= component.get("v.showTPT");
      helper.getData(component, event, helper,showInt);  
    },
    scrollToCustomerGraph : function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            console.log('Index:: '+params.Index);
            var param2 = params.Index;
            var topHeight = 1038;
            var divHeight = 535;
            if(param2 == 1){
             	var height = topHeight;   
            } else{
                var height = (param2-1)*divHeight + topHeight;
            }
            var scrollOptions = {
                left: 0,
                top: height,
                behavior: 'smooth'
            }
            window.scrollTo(scrollOptions);
        }
    },
    downloadCsv: function (component, event, helper) {
        var showTPTValue = component.get("v.showTPT");
        var resultData1 = component.get("v.responseList");  
        var csv4 = helper.convertArrayOfObjectsToCSV(component, resultData1,showTPTValue);
        if (csv4 == null) {
            return;
        }
        var hiddenElement1 = document.createElement('a');
        hiddenElement1.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv4);
        hiddenElement1.target = '_self'; //
        var date = new Date();
        var hours = date.getHours();
        var minutes = date.getMinutes();
        var newformat = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12;
        hours = hours ? hours : 12;
        minutes = minutes < 10 ? '0' + minutes : minutes;
        var userName = component.get("v.responseList[0].currentUserName");
        var Now = (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear() + ' ' + hours + ':' + minutes + ' ' + newformat;
        hiddenElement1.download = 'DRL Sales Report'+ '-' + Now + '-' + userName + '.csv'; // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement1); // Required for FireFox browser
        hiddenElement1.click(); // using click() js function to download csv file
        
    },
    sortByDrlPreviousSales : function(component, event, helper){
        component.set('v.loaded', true);
        if(component.get("v.filterName") != 'Previous Sales')
            component.set("v.isAsc", false);
        component.set("v.filterName",'Previous Sales');
        component.set("v.sortField",'SalesDollarPrev');
        helper.sortBy(component, 'SalesDollarPrev', helper);
    }, 
    sortByDrlRecentSales : function(component, event, helper){
        component.set('v.loaded', true);
        if(component.get("v.filterName") != 'Recent Sales')
            component.set("v.isAsc", false);
        component.set("v.filterName",'Recent Sales');
        component.set("v.sortField",'salesdl');
        helper.sortBy(component, 'salesdl', helper);
    },
    sortByDrlPreviousUnits : function(component, event, helper){
        component.set('v.loaded', true);
        if(component.get("v.filterName") != 'Previous Units')
            component.set("v.isAsc", false);
        component.set("v.filterName",'Previous Units');
        component.set("v.sortField",'UnitsPrev');
        helper.sortBy(component, 'UnitsPrev', helper);
    }, 
    sortByDrlRecentUnits : function(component, event, helper){
        component.set('v.loaded', true);
        if(component.get("v.filterName") != 'Recent Units')
            component.set("v.isAsc", false);
        component.set("v.filterName",'Recent Units');
        component.set("v.sortField",'units');
        helper.sortBy(component, 'units', helper);
    }, 
    sortByDrlPreviousTPT : function(component, event, helper){
        component.set('v.loaded', true);
        if(component.get("v.filterName") != 'Previous TPT')
            component.set("v.isAsc", false);
        component.set("v.filterName",'Previous TPT');
        component.set("v.sortField",'TPTDollarPrev');
        helper.sortBy(component, 'TPTDollarPrev', helper);
    }, 
    sortByDrlRecentTPT : function(component, event, helper){
        component.set('v.loaded', true);
        if(component.get("v.filterName") != 'Recent TPT')
            component.set("v.isAsc", false);
        component.set("v.filterName",'Recent TPT');
        component.set("v.sortField",'tptdollar');
        helper.sortBy(component, 'tptdollar', helper);
    },
    getMoreChartsData: function(component, event, helper){
        console.log('All Ids-->'+component.get("v.allDrlSalesIds"))
        component.set("v.productFamilies", component.get("v.allProductFamilies"));
        component.set("v.showMoreButton", false);
        //var showInt= component.get("V.ShowINT");
         var showInt= component.get("v.showTPT");
        var recentLastMonth = component.get("v.recentLastMonth");
        var previousLastMonth = component.get("v.previousLastMonth");
        /*var scrollOptions = {
            left: 0,
            top: 0,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);*/
         console.log('show tpt value getmorecharts-->'+component.get("v.showTPT"))
        helper.getChartData(component, event, helper,showInt,recentLastMonth,previousLastMonth);
    },
     onsearch: function(component, event, helper){
        var searchText = component.get("v.searchText");
        console.log('searchText==>'+searchText);
          var showInt= component.get("V.ShowINT");
        component.set("v.customerId", null);
        component.set("v.productFamilies", []);
        component.set("v.allProductFamilies", []);
       // var selectedUserId = component.get("v.selectedUser");
         if(component.get("v.res") != null){
                                        component.set("v.showBoolean",true);
                                    }else{
                                         component.set("v.showBoolean",false);
                                    }
         var showInt= component.get("v.showTPT");
        helper.getData(component, event, helper,showInt);
    },
})