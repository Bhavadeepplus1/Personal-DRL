({
    initRecords : function(component,event,helper){
        console.log('Init My Accounts');
        
        var id = component.get("v.recordId");
        component.set('v.recId',id);
        component.set("v.showChart", true);
        var showInt= component.get("V.ShowINT");
        //component.set('v.searchText', null);
        var action = component.get("c.getCustomLabel");
        action.setParams({
            recordId:component.get("v.recId")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var response= response.getReturnValue();
                                   console.log('inside netsales===='+response.custCode);
                                   if(response.isDataExist == "true"){
                                       console.log('inside netsales');
                                       component.set('v.showNetSales',true);
                                       component.set("v.AccountNumber",response.custCode);
                                        if(response.custCode == '370337' || response.custCode == '370260' || response.custCode == '370641' || response.custCode == '151515'  || response.custCode == '147362' ||response.custCode == '370706' || response.custCode == '370617' ){
                                           component.set('v.isRxChecked',true);
                                           component.set('v.isSRxChecked',true);
                                           
                                           var selections = component.get("v.selections");
                                           selections.push('Rx');
                                           
                                           selections.push('SRx');
                                           
                                           component.set("v.selections", selections);
                                           console.log('selection if===='+selections);
                                           
                                           component.set('v.isDirect',true);
                                           component.set('v.isIndirect',true);
                                             var category = component.get("v.category");
                                           category.push('Direct');
                                            category.push('Indirect');
                                           component.set("v.category", category);
                                           
                                     
                                           component.set('v.isGenerics',true);
                                           var divisonDesc = component.get("v.divisonDesc");
                                           divisonDesc.push('Generics');
                                           component.set("v.divisonDesc", divisonDesc);
                                           
                                       }
                                        if(response.custCode == '154328' || response.custCode == '370741' ){
                                           component.set('v.isRxChecked',true);
                                           component.set('v.isSRxChecked',true);
                                           
                                           var selections = component.get("v.selections");
                                           selections.push('Rx');
                                           
                                           selections.push('SRx');
                                           
                                           component.set("v.selections", selections);
                                           console.log('selection if===='+selections);
                                           
                                           component.set('v.isDirect',true);
                                           component.set('v.isIndirect',true);
                                             var category = component.get("v.category");
                                           category.push('Direct');
                                            category.push('Indirect');
                                           component.set("v.category", category);
                                           
                                     
                                           component.set('v.isGenerics',true);
                                            component.set('v.isDivisionOTC',true);
                                           var divisonDesc = component.get("v.divisonDesc");
                                           divisonDesc.push('Generics');
                                             divisonDesc.push('OTC');
                                           component.set("v.divisonDesc", divisonDesc);
                                           
                                       }
                                       //econdisc
                                        if(response.custCode == '117866'){
                                           component.set('v.isRxChecked',true);                                           
                                           var selections = component.get("v.selections");
                                           selections.push('Rx');
                                           
                                           selections.push('SRx');
                                           
                                           component.set("v.selections", selections);
                                           console.log('selection if===='+selections);
                                           
                                           component.set('v.isIndirect',true);
                                             var category = component.get("v.category");
                                          // category.push('Direct');
                                            category.push('Indirect');
                                           component.set("v.category", category);
                                           
                                     
                                           component.set('v.isGenerics',true);
                                           // component.set('v.isDivisionOTC',true);
                                           var divisonDesc = component.get("v.divisonDesc");
                                           divisonDesc.push('Generics');
                                         //    divisonDesc.push('OTC');
                                           component.set("v.divisonDesc", divisonDesc);
                                           
                                       }
                                       //meckason
                                        if(response.custCode == '370679' ){
                                           component.set('v.isRxChecked',true);
                                           component.set('v.isSRxChecked',true);
                                           component.set('v.isOtcChecked',true);

                                           var selections = component.get("v.selections");
                                           selections.push('Rx');
                                           selections.push('SRx');
                                           selections.push('OTC');
										   component.set("v.selections", selections);
                                           console.log('selection if===='+selections);
                                           
                                           component.set('v.isDirect',true);
                                           component.set('v.isIndirect',true);
                                             var category = component.get("v.category");
                                           category.push('Direct');
                                            category.push('Indirect');
                                           component.set("v.category", category);
                                           
                                     
                                           component.set('v.isGenerics',true);
                                            component.set('v.isDivisionOTC',true);
                                           var divisonDesc = component.get("v.divisonDesc");
                                           divisonDesc.push('Generics');
                                             divisonDesc.push('OTC');
                                           component.set("v.divisonDesc", divisonDesc);
                                           
                                       }
                                        if(response.custCode == '147740'){
                                           component.set('v.isRxChecked',true);
                                         //  component.set('v.isSRxChecked',true);
                                           
                                           var selections = component.get("v.selections");
                                           selections.push('Rx');
                                            component.set("v.selections", selections);
                                           console.log('selection if===='+selections);
                                           
                                           component.set('v.isDirect',true);
                                           component.set('v.isIndirect',true);
                                             var category = component.get("v.category");
                                           category.push('Direct');
                                            category.push('Indirect');
                                           component.set("v.category", category);
                                           
                                     
                                           component.set('v.isGenerics',true);
                                        //    component.set('v.isDivisionOTC',true);
                                           var divisonDesc = component.get("v.divisonDesc");
                                           divisonDesc.push('Generics');
                                         //    divisonDesc.push('OTC');
                                           component.set("v.divisonDesc", divisonDesc);
                                           
                                       }
                                        if(response.custCode == '115596'){
                                           component.set('v.isRxChecked',true);
                                         //  component.set('v.isSRxChecked',true);
                                           
                                           var selections = component.get("v.selections");
                                           selections.push('RX');
                                            selections.push('Rx');
                                            selections.push('SRx');
                                           //  selections.push('OTC');
                                            component.set("v.selections", selections);
                                           console.log('selection if===='+selections);
                                           
                                           component.set('v.isDirect',true);
                                           component.set('v.isIndirect',true);
                                             var category = component.get("v.category");
                                           category.push('Direct');
                                            category.push('Indirect');
                                           component.set("v.category", category);
                                           
                                     
                                           component.set('v.isGenerics',true);
                                           component.set('v.isDivisionOTC',true);
                                           var divisonDesc = component.get("v.divisonDesc");
                                           divisonDesc.push('Generics');
                                            divisonDesc.push('OTC');
                                           component.set("v.divisonDesc", divisonDesc);
                                           
                                       }
                                       console.log('selection===='+component.get("v.selections"));
                                       console.log('divisonDesc===='+component.get("v.divisonDesc"));
                                       console.log('category===='+component.get("v.category"));
                                          helper.getData(component, event, helper,showInt);
                                       
                                   }
                                   
                               }
                           });
        $A.enqueueAction(action);  
        
        
    },
    handleChange: function (component, event, helper) {
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
        component.set("v.comparison", selectedOptionValue);
        component.set("v.customerId", null);
        component.set("v.customerIds", []);
        component.set("v.allCustomerIds", []);
        console.log('My accounts handle change called');
        component.set("v.chartobj5",null);
        component.set("v.chartobj6",null);
        var showInt= component.get("V.ShowINT");
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
        component.set("v.customerIds", []);
        component.set("v.allCustomerIds", []);
        var showInt= component.get("V.ShowINT");
        helper.getData(component, event, helper,showInt);
    },
    searchIntExt: function(component, event, helper){
        console.log('uncheck')
        console.log('test->'+component.get("v.isEXTChecked"));
        var isExtCheck = component.get("v.isEXTChecked");
        var showINT = component.get("V.ShowINT");
        var trueValue = true;
        var falsevalue = false;
        if(isExtCheck == true){
            component.set("v.isEXTChecked",trueValue);
            component.set("v.isINTChecked",falsevalue);
        }else{
            component.set("v.isEXTChecked",falsevalue);
            component.set("v.isINTChecked",trueValue);
        }
        /*   if(isIntCheck == false){
            component.set("v.isEXTChecked",falsevalue);
            component.set("V.ShowINT",trueValue)
        }
      else{
    	component.set("v.isEXTChecked",trueValue); 
          component.set("V.ShowINT",falsevalue)
		}*/
        component.set("v.customerId", null);
        component.set("v.customerIds", []);
        component.set("v.allCustomerIds", []);
        var showInt= component.get("V.ShowINT");
        helper.getData(component, event, helper,showInt);  
    },
    scrollToCustomerGraph : function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            console.log('Index:: '+params.Index);
            console.log('custId:: '+params.custId);
            var param1 = params.custId;
            var param2 = params.Index;
            var topHeight = 1212;
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
        var showTPTValue = component.get("v.isEXTChecked");
        
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
        console.log('All Ids-->'+component.get("v.allCustomerIds"))
        component.set("v.customerIds", component.get("v.allCustomerIds"));
        component.set("v.allcustDescList", component.get("v.custDescList"));
        component.set("v.showMoreButton", false);
        var showInt= component.get("V.ShowINT");
        var recentLastMonth = component.get("V.recentLastMonth");
        var previousLastMonth = component.get("V.previousLastMonth");
        /*var scrollOptions = {
            left: 0,
            top: 0,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);*/
        helper.getChartData(component, event, helper,showInt,recentLastMonth,previousLastMonth);
    },
    onsearch: function(component, event, helper){
        var searchText = component.get("v.searchText");
        console.log('searchText==>'+searchText);
        var showInt= component.get("V.ShowINT");
        component.set("v.customerId", null);
        component.set("v.customerIds", []);
        component.set("v.allCustomerIds", []);
        if(component.get("v.res") != null){
            component.set("v.showBoolean",true);
        }else{
            component.set("v.showBoolean",false);
        }
        helper.getData(component, event, helper,showInt);
    },
    handleClick2: function(component, event, helper){
        //component.set("v.showItem", false);
        var parentId = event.getSource().get("v.name");
        console.log('parentId-->'+parentId);
        var data =component.get("v.resList");
        for(var i=0;i<data.length;i++){
            if(parentId == data[i].parentAccName){
                console.log('parent name==>'+data[i].parentAccName)
                if(data[i].showItem){
                    data[i].showItem = false;   
                } else{
                    data[i].showItem = true;
                    
                }
            }
        }
        component.set("v.resList", data); 
        console.log('res===>'+JSON.stringify(component.get("v.resList")))
    },
    handleClick1: function(component, event, helper){
        //component.set("v.showItem", true);
        var parentId = event.getSource().get("v.name");
        console.log('parentId-->'+parentId);
        var data =component.get("v.resList");
        for(var i=0;i<data.length;i++){
            if(parentId == data[i].parentAccName){
                console.log('parent name==>'+data[i].parentAccName)
                if(data[i].showItem){
                    data[i].showItem = false;   
                } else{
                    data[i].showItem = true;
                    
                }
                
            }
        }
        component.set("v.resList", data); 
        console.log('res===>'+JSON.stringify(component.get("v.resList")))
    },
    sortByDrlRecentSalesExt : function(component, event, helper){
        component.set("v.loaded", true);
        if(component.get("v.filterName") != 'Recent Sales')
            component.set("v.isAsc", false);
        component.set("v.filterName",'Recent Sales');
        component.set("v.sortField",'salesdl');
        console.log('Calling Helper');
        helper.sortByExt(component, 'salesdl', helper);
    },
    sortByDrlRecentSalesExtData : function(component, event, helper){
        //   component.set("v.loaded", true);
        var target = event.getSource(); 
        
        var txtVal = target.get("v.name") ;
        
        if(component.get("v.filterName") != 'Recent Sales')
            component.set("v.isAscChild", false);
        component.set("v.filterName",'Recent Sales');
        component.set("v.sortField",'salesdl');
        helper.sortByExtData(component, 'salesdl', helper,txtVal);
    },
    searchDivision: function(component, event, helper){
        var generics = component.get("v.isGenerics");
        var OTC = component.get("v.isDivisionOTC");
        var divisonDesc = component.get("v.divisonDesc");
        var isAPI = component.get("v.isAPI");
        var isCPS = component.get("v.isCPS");
        var isCrossDivision = component.get("v.isCrossDivision");
                var isFormulations = component.get("v.isFormulations");
        if(generics == true && !divisonDesc.includes('Generics')){
            divisonDesc.push('Generics');
        }
        if(OTC == true && !divisonDesc.includes('OTC')){
            divisonDesc.push('OTC');
        }
        
        if(generics == false && divisonDesc.includes('Generics')){
            var ind = divisonDesc.indexOf('Generics');
            divisonDesc.splice(ind, 1);
        }
        if(OTC == false && divisonDesc.includes('OTC')){
            var ind = divisonDesc.indexOf('OTC');
            divisonDesc.splice(ind, 1);
        }
           if(isAPI == true && !divisonDesc.includes('API')){
            divisonDesc.push('API');
        }
        if(isCPS == true && !divisonDesc.includes('CPS')){
            divisonDesc.push('CPS');
        } if(isCrossDivision == true && !divisonDesc.includes('Cross Division')){
            divisonDesc.push('Cross Division');
        }
        if(isFormulations == true && !divisonDesc.includes('Formulations')){
            divisonDesc.push('Formulations');
        }
         if(isCrossDivision == false && divisonDesc.includes('Cross Division')){
            var ind = divisonDesc.indexOf('Cross Division');
            divisonDesc.splice(ind, 1);
        }
        if(isFormulations == false && divisonDesc.includes('Formulations')){
            var ind = divisonDesc.indexOf('Formulations');
            divisonDesc.splice(ind, 1);
        }
        if(isAPI == false && divisonDesc.includes('API')){
            var ind = divisonDesc.indexOf('API');
            divisonDesc.splice(ind, 1);
        }
        if(isCPS == false && divisonDesc.includes('CPS')){
            var ind = divisonDesc.indexOf('CPS');
            divisonDesc.splice(ind, 1);
        }
        component.set("v.divisonDesc", divisonDesc);
         console.log('search divisonDesc===='+component.get("v.divisonDesc"));
        component.set("v.customerId", null);
        component.set("v.customerIds", []);
        component.set("v.allCustomerIds", []);
        var showInt= component.get("V.ShowINT");
        helper.getData(component, event, helper,showInt);
    },
    searchCategory: function(component, event, helper){
        var direct = component.get("v.isDirect");
        var indirect = component.get("v.isIndirect");
        var category = component.get("v.category");  
        
        if(direct == true && !category.includes('Direct')){
            category.push('Direct');
        }
        if(indirect == true && !category.includes('Indirect')){
            category.push('Indirect');
        }
        if(direct == false && category.includes('Direct')){
            var ind = category.indexOf('Direct');
            category.splice(ind, 1);
        }
        if(indirect == false && category.includes('Indirect')){
            var ind = category.indexOf('Indirect');
            category.splice(ind, 1);
        }
        component.set("v.category", category);
       console.log('search category===='+component.get("v.category"));
        component.set("v.customerId", null);
        component.set("v.customerIds", []);
        component.set("v.allCustomerIds", []);
        var showInt= component.get("V.ShowINT");
        helper.getData(component, event, helper,showInt);
    },
})