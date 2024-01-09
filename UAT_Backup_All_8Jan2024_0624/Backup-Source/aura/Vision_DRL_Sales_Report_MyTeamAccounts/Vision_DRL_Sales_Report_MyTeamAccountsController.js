({
    initRecords : function(component,event,helper){
        console.log('Init My Teams Accounts');
        component.set("v.showChart", true);
        var selectedUserId = component.get("v.selectedUser");
        console.log('selectedUserId-->'+selectedUserId);
        helper.getData(component, event, helper,selectedUserId);
        
    },
    handleChange: function (component, event, helper) {
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
        component.set("v.comparison", selectedOptionValue);
        component.set("v.customerId", null);
        component.set("v.customerIds", []);
        component.set("v.allCustomerIds", []);
        var selectedUserId = component.get("v.selectedUser");
        console.log('My Teams Accounts handle change called');
        helper.getData(component, event, helper,selectedUserId);
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
        var selectedUserId = component.get("v.selectedUser");
		helper.getData(component, event, helper,selectedUserId);
    },
    searchIntExt: function(component, event, helper){
        console.log('uncheck')
        console.log('test->'+component.get("v.isINTChecked"));
        var isIntCheck = component.get("v.isINTChecked");
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
        var selectedUserId = component.get("v.selectedUser");
      helper.getData(component, event, helper,selectedUserId);  
    },
    scrollToCustomerGraph : function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            console.log('Index:: '+params.Index);
            var param1 = params.custId;
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
        var showTPTValue = component.get("v.isINTChecked");
        
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
        component.set("v.showMoreButton", false);
        /*var scrollOptions = {
            left: 0,
            top: 0,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);*/
        var selectedUserId = component.get("v.selectedUser");
        helper.getChartData(component, event, helper,selectedUserId);
    },
    onChangeUser: function(component, event, helper){
        //console.log('onChangeUser')
        var selectedUserName = event.getSource().get("v.label");
		 var resultCmp = component.find("userId");
		 component.set("v.value", selectedUserName);
        //console.log('resultCmp-->'+resultCmp);
         console.log('label value-->'+selectedUserName);
        component.set("v.selectedUser",selectedUserName);
         helper.getData(component, event, helper,selectedUserName);
        
    },
    onSelectUser : function(component, event, helper){
        console.log('Id Name---'+event.getSource().get("v.name"));
        var selectedId =  event.getSource().get("v.name");
        component.set("v.selectedUser",selectedId)
        var listOfusers = component.get("v.pickList");
        listOfusers.forEach(function(user){
            if(user.userId == selectedId){
                user.isSelected = true;
            }
            else{
                user.isSelected = false;
            }
        });
        component.set("v.pickList",listOfusers);
       
       
        component.set("v.isChangedUser",true);
        component.set("v.customerId", null);
        component.set("v.customerIds", []);
        component.set("v.allCustomerIds", []);
        helper.getData(component, event, helper,selectedId);
        
    }
})