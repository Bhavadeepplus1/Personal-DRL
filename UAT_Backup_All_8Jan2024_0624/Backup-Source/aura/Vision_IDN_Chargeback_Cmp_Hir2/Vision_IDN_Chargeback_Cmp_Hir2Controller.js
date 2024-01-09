({
    doInit: function(component, event, helper){
       
        component.set("v.isSpinnerLoad", false);
         var action33 = component.get("c.getuser");
       // action.setParams({"hospitalName" : component.get("v.selectedValues")});
        action33.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var userId = response.getReturnValue();
                console.log('userId hir2.....'+userId);
               component.set("v.selectedUserId",userId);
                console.log('responseList1. after set.hir2...'+component.get("v.selectedUserId"));   
                }
            else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
             $A.enqueueAction(action33);
        
     /*   helper.getcategoryData(component, event, helper);
        helper.gethospitalName(component, event, helper);
        helper.getProductNames(component, event, helper);
        helper.getProducts(component, event, helper);
       helper.getmembericty(component, event, helper);
       helper.getmemberstate(component, event, helper);
        helper.getsubmitters(component, event, helper);*/
      /*   var action3 = component.get("c.getcontracts");
        action3.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title3=[];
                for (var i=0; i<responseList.length; i++) {
                    title3[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.options6",title3);   
                
                //component.set("v.options2",responseList); 
                  // helper.getFullData(component, event, helper);
                
                component.set("v.isSpinnerLoad", false);
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action3);*/
       
        var optionslist=component.get("v.options2");
          //helper.getFullData(component, event, helper);
         //helper.gettwMonthsData(component, event, helper);
       
     },
    
    onchangeSalesRepTerritory:function(component,event,helper){
        
        var salesTerritory = event.getParam("value");
        var territory;
         if(salesTerritory == 'All'){
         }else{
             territory = salesTerritory;
         }
        component.set("v.salesTerritory",territory);
        component.set("v.isSpinnerLoad", true);
         helper.getFullData(component, event, helper);
        
    },
   
     searchHospital: function(component, event, helper){
        component.set("v.isSpinnerLoad", true);
        var hospitalName = event.getParam("value");
         var hospital;
         
        component.set("v.selections", []);
        //var selections = component.get("v.selections");
        if(hospitalName == 'All'){
             selections.push('Rx');
            selections.push('SRx');
            selections.push('OTC');   
        } else{
            hospital = hospitalName;
         	//selections = productType.split('+');   
        }
         console.log('hospital===>'+hospital);
         component.set("v.hospitalName",hospital);
         helper.getFullData(component, event, helper);
        //component.set("v.selections", selections);
    },
   /* searchSalesUnits:function(component,event,helper){
         var checkCmp = component.find("SalesUnits");
        //cmp.set("v.toggleValue" ,  checkCmp.get("v.value"));
       
    },*/
    searchSalesUnits: function(component, event, helper){
        console.log('uncheck')
        
        var checkCmp = component.find("SalesUnits");
       console.log('test satya->'+checkCmp.get("v.checked")); 
         component.set("v.isChecked",checkCmp.get("v.checked"));
      /*  var isIntCheck = component.get("v.isINTChecked");
        var showINT = component.get("V.ShowINT");
        var trueValue = true;
        var falsevalue = false;
        if(isIntCheck == false){
            component.set("v.isINTChecked",falsevalue);
            component.set("V.ShowINT",trueValue)
        }
      else{
    	component.set("v.isINTChecked",trueValue); 
          component.set("V.ShowINT",falsevalue)
		}
       var showInt= component.get("V.ShowINT");*/
     // helper.getData(component, event, helper,showInt);  
    },
    showHideSalesUnits:function(component, event, helper){
        console.log('showHideSalesUnits==>'+component.get("v.showHideSalesUnits"))
        component.set("v.showHideSalesUnits",component.get("v.showHideSalesUnits")?false:true);
    },
    handleChange : function(cmp, event, helper) {
        console.log('Lookup component Id: ' + event.getParam("cmpId"));
       
        var newId = cmp.get("v.selectedUserId");
         console.log('newId: ' + newId);
        cmp.set("v.selectedUserId", newId);
        helper.gethospitalName(cmp, event, helper);
       /* helper.getcategoryData(cmp, event, helper);
        helper.gethospitalName(cmp, event, helper);
        helper.getProductNames(cmp, event, helper);
         helper.getProducts(cmp, event, helper);
         helper.getmembericty(cmp, event, helper);
         helper.getmemberstate(cmp, event, helper);
        helper.getsubmitters(cmp, event, helper);
        helper.fetchContratcs(cmp, event,helper);*/
        //cmp.set("v.isSpinnerLoad", true);
       
    },
     searchHandler : function (component, event, helper) {
        const searchString = event.target.value;
        if (searchString.length >= 3) {
            //Ensure that not many function execution happens if user keeps typing
            if (component.get("v.inputSearchFunction")) {
                clearTimeout(component.get("v.inputSearchFunction"));
            }

            var inputTimer = setTimeout($A.getCallback(function () {
                helper.searchRecords(component, searchString);
            }), 1000);
            component.set("v.inputSearchFunction", inputTimer);
        } else{
            component.set("v.results", []);
            component.set("v.openDropDown", false);
        }
    },
     selectRegion:function(component,event,helper){
         var userRegion = event.getParam("value");
        component.set("v.userRegion", userRegion);
         console.log('userRegion==>' +userRegion);
    },
    selectCategory:function(component, event, helper){
        var userCategory = event.getParam("value");
        component.set("v.userCategory", userCategory);
    },
    searchHospitalName:function(component, event, helper){
         var searchHospitalKey = component.find("searchHospital").get("v.value");
        component.set("v.hospitalName",searchHospitalKey);
        console.log('searchHospitalKey:::::'+searchHospitalKey);
    },
    searchChild1Name:function(component, event, helper){
         var searchChild1Key = component.find("searchChild1").get("v.value");
        component.set("v.child1Name",searchChild1Key);
        console.log('searchChild1Key:::::'+searchChild1Key);
    },
     searchChild2Name:function(component, event, helper){
         var searchChild2Key = component.find("searchChild2").get("v.value");
        component.set("v.child2Name",searchChild2Key);
        console.log('searchChild2Key:::::'+searchChild2Key);
    },
    searchProductFamily:function(component, event, helper){
         var searchProductFamily = component.find("searchproductFamily").get("v.value");
        component.set("v.productFamily",searchProductFamily);
        console.log('searchProductFamily:::::'+searchProductFamily);
    },
    searchProductDescription:function(component, event, helper){
        var searchProductDescription = component.find("searchproductDescription").get("v.value");
        component.set("v.productDescription",searchProductDescription);
        console.log('searchProductDescription:::::'+searchProductDescription);
    },
    searchSubmitterName:function(component, event, helper){
         var searchSubmitterName = component.find("searchsubmitterName").get("v.value");
        component.set("v.submitterName",searchSubmitterName);
        console.log('searchSubmitterName:::::'+searchSubmitterName);
    },
     collectData: function(component, event, helper){
         $A.util.removeClass(component.find("LineTable"), 'summaryheaderSticky');
        helper.getFullData(component, event, helper);
         //helper.gettwMonthsData(component, event, helper);
         helper.getAllTotals(component, event, helper);
         
         //helper.getprevsixMonthsData(component, event, helper);
    },
    sortBySalesAvgof6Month: function(component, event, helper) {
        component.set('v.isSpinnerLoad', true);
        //if(component.get("v.filterName") != 'Avg of Sales')
          //  component.set("v.isAsc", true);
        //component.set("v.filterName",'Avg of Sales');
        //component.set("v.sortField",'Avg_Sales');
        //console.log('controller recordsdff-->');
        var testREc = component.get("v.chargebackList");
        //console.log('controller recordsdff-->');
        var hospitialMap = new Map();
        var SalesList = new Array();
        var listOfWrappers=[];
        testREc.forEach(function(eachRec){
            var relatedList = eachRec.idnchargebackList;
            var totalVal=0;
            relatedList.forEach(function(chargeBackRec){
                var salesPrice = (chargeBackRec.Contract_Sales_Indirect_Price__c != null && chargeBackRec.Contract_Sales_Indirect_Price__c != undefined) ? chargeBackRec.Contract_Sales_Indirect_Price__c : 0;
                totalVal= totalVal + salesPrice;
               
            });
            totalVal=Math.round(totalVal/6);
            
            //console.log('sum---->'+eachRec.hospitalName+'---Summ===>' +totalVal);
             var mainWrap = {'AverageSales':totalVal,
                        'eachHsptl':eachRec
                       	};
          listOfWrappers.push(mainWrap);
        
        });
        
        listOfWrappers.sort((a,b) => (a.AverageSales > b.AverageSales) ? -1 : ((b.AverageSales > a.AverageSales) ? 1 : 0));
        var finaList = [];
        listOfWrappers.forEach(function(eachREc){
            finaList.push(eachREc.eachHsptl);
            console.log('AvgSlaes---->'+eachREc.AverageSales)
            console.log('AvgSlaes---->'+eachREc.eachHsptl.hospitalName);
            
        });
        component.set("v.chargebackList",finaList);
        component.set('v.isSpinnerLoad', false);
        //console.log('listOfWrappers---180->'+JSON.stringify(listOfWrappers));
       // for (let [key, value] of hospitialMap) {     // get data sorted
          //  console.log('Key--->'+JSON.stringify(key) + '==== ' +value);
        //}
        //console.log('hospitialMap165-->'+hospitialMap.entries()[0].hospitalName);
        //helper.sortBySales(component, 'Avg_Sales');
       
    },
    downloadCsv : function(component,event,helper){    
        
       // var exportList = [];
        var exportList = component.get("v.chargebackList");
       // var familyTotalsMap = new Map();
       // orderComplianceObject.forEach(function(item){
          //  familyTotalsMap[item.prodFamName] = item;
          //  item.orderComplianceList.forEach(function(item1){
            //    exportList.push(item1);
           // });
      //  });
        console.log('exportList====='+JSON.stringify(exportList));
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,exportList);   
        if (csv == null){return;} 
        
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; //      
        var date = new Date(); 
        var hours = date.getHours(); 
        var minutes = date.getMinutes(); 
        var newformat = hours >= 12 ? 'PM' : 'AM';  
        hours = hours % 12;  
        hours = hours ? hours : 12;  
        minutes = minutes < 10 ? '0' + minutes : minutes;        
        var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
        hiddenElement.download = 'Charge Back Data'+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
        
    },
    getMessage : function(component, event) {
        //get method paramaters
        var params = event.getParam('arguments');
        console.log('params??==>'+params);
        if (params) {
            var param1 = params.GreetingParam;
            console.log('param1==>'+param1);
            if(param1 == 'displayChart'){
            $A.util.removeClass(component.find("LineTable"), 'summaryheaderSticky');
            }
            if(param1 =='closeChart'){
               $A.util.addClass(component.find("LineTable"), 'summaryheaderSticky');   

            }
           /* else{
             $A.util.addClass(component.find("LineTable"), 'summaryheaderSticky');   
            }*/
            //alert(param1);
        }
    },
    getMessage2 : function(component, event) {
        //get method paramaters
        var params = event.getParam('arguments');
        if (params) {
            var param1 = params.GreetingParam2;
            var param2 = params.PersonNameParam2;
            //alert(param1 + " " + param2);
            if(param1 == 'openModel' ){
             $A.util.removeClass(component.find("LineTable"), 'summaryheaderSticky');
            }
            if(param1 == 'closeModel' ){
                $A.util.addClass(component.find("LineTable"), 'summaryheaderSticky');   

            }
        }
    },
    hideModel: function(component, event, helper) {
        component.set("v.showModal", false);
         $A.util.addClass(component.find("LineTable"), 'summaryheaderSticky'); 
    }, 
    showModel: function(component, event, helper) {
         $A.util.removeClass(component.find("LineTable"), 'summaryheaderSticky');
        component.set("v.showModal", true);
        component.set('v.mycolumns', [
            {label: 'Contract Description', fieldName: 'T2_Contact_Description__c', type: 'text'},
            
        ]); 
        helper.fetchContratcs(component, event,helper);
      /*  var searchInput=component.find("cntInput").get("v.value");
        console.log('--searchInput--'+searchInput);
        var bidCustomer=component.get("v.customerId");
        console.log('--bidCustomer--'+bidCustomer);
        if(bidCustomer!=null && bidCustomer!=undefined){
            helper.fetchContratcs(component, event,helper,bidCustomer,searchInput);
        } else{
            component.set("v.contratcsList",null);
        } */     
    },
     searchContracts : function(component, event, helper) {
        var searchInput=component.find("cntInput").get("v.value");
        console.log('searchInput---'+searchInput);
        //var checkToggle=component.find("tgleCntrct").get("v.checked");            
        
         helper.fetchContratcs(component, event,helper,searchInput);
      /*   var bidCustomer=component.get("v.customerId");
        console.log('--bidCustomer--'+bidCustomer); 
        if(checkToggle==true){
            helper.fetchContratcs(component, event,helper,null,searchInput);
        }
        else{
            if(bidCustomer!=null && bidCustomer!=undefined){
                helper.fetchContratcs(component, event,helper,bidCustomer,searchInput);
            }else{
                component.set("v.contratcsList",null);
            }
        }*/
        
    },
      saveDetails : function(component, event, helper) {
        var selectrcs=component.find('linesTable').getSelectedRows(); 
         var selectedCntrcts = component.get("v.contractslist");
            console.log('selectedCntrcts==>'+JSON.stringify(selectrcs))
        for(var i=0;i<selectrcs.length;i++){
            if(!selectedCntrcts.includes(selectrcs[i].T2_Contact_Description__c))
            	selectedCntrcts.push(selectrcs[i].T2_Contact_Description__c);
        } 
   		 var count = selectedCntrcts.length;
        component.set('v.searchString', count + ' options selected');
     	component.set("v.countofselCont",count);
    	component.set("v.selcontractslist",selectedCntrcts);
        component.set("v.contractslist",selectedCntrcts);
        component.set("v.showModal", false);
            
      /*  var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
        component.set("v.showSaveCancelBtn",true);*/
        //helper.getNPRDataOfContracts(component, event, helper,selectrcs);
    }, 
	  showselectedContracts:function(component, event, helper){
       console.log('in showselectedContracts')
        component.set("v.isslctdContrctModalOpen", true);

        var showselectedIds = component.get("v.contractslist");
       component.set("v.showModal", false);
    },
    closePopup: function (component, event, helper) {
        component.set("v.isslctdContrctModalOpen", false);
        component.set("v.showModal", true);
    }, 
     deleteContracts:function (component, event, helper) {
      var allList=  component.get("v.contractslist");
        console.log('event value==>'+event.getSource().get("v.value"))
        var deletedValue = event.getSource().get("v.value");
        var index = allList.indexOf(5);
        allList.splice(index, 1);
        var count = allList.length;
        component.set('v.searchString', count + ' options selected');
        component.set("v.countofselCont",count);
        component.set("v.contractslist",allList);
        
    },
      clearCntract :function(component,event,heplper){
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.contractslist"); 
        
        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i] == selectedPillId){
                AllPillsList.splice(i, 1);
                component.set("v.contractslist", AllPillsList);
            }  
        } 
       // component.set("v.showSaveCancelBtn",true);
    },
     handleCmpEvent: function(component, event) {
        var message = event.getParam("message");
        component.set("v.messageTemp", message);
         console.log('in message==>'+message)
         if(message == "displayChildChart" || message == "displayDualChart"){
             console.log('in displayChildChart')
            $A.util.removeClass(component.find("LineTable"), 'summaryheaderSticky'); 
         }
         if(message == "closeChildChart" || message == "closeDualChart"){
             $A.util.addClass(component.find("LineTable"), 'summaryheaderSticky');
         }
         //alert(message);
    },
        handleScroll:function(component, event){
        var scrollTop = event.target.scrollTop;
         console.log('scrollTop==>'+scrollTop);
        var scrollHeight = event.target.scrollHeight
        console.log('scrollHeight==>'+scrollHeight);
        var clientHeight = event.target.clientHeight
       	console.log('clientHeight==>'+clientHeight);
        var count = component.get("v.count")
        console.log('count==>'+count);
        var allchargebackList = component.get("v.allchargebackList")
        var allAccountsLoaded = component.get("v.allAccountsLoaded")
        var chargebackList = component.get("v.chargebackList")
     // component.set("v.isSpinnerLoad", true);
        if(((scrollHeight - clientHeight) <= (scrollTop + 10)) && !allAccountsLoaded){
            //load next set of 50 records
            var nextSetOfData = allchargebackList.slice(count , count+50)
              console.log('nextSetOfData==>'+JSON.stringify(nextSetOfData))
              console.log('nextSetOfData length==>'+nextSetOfData.length)
              for(var i=0;i<nextSetOfData.length;i++){
                  chargebackList.push(nextSetOfData[i])
              }
            component.set("v.chargebackList", chargebackList)
            console.log('chargebackList==>'+JSON.stringify(component.get("v.chargebackList")))
            console.log('chargebackList length==>'+component.get("v.chargebackList").length)
            component.set("v.count",count+50);
             component.set("v.isSpinnerLoad", false);
            //logic to check if all data has been loaded
            if(chargebackList.length === allchargebackList.length){
                allAccountsLoaded = true;
                component.set("v.allAccountsLoaded", allAccountsLoaded)
                  component.set("v.isSpinnerLoad", false);
            }
        }
        
	}
})