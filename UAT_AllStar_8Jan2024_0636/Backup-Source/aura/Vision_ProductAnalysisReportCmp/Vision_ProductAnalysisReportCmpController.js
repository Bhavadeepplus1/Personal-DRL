({
    doInit : function(component, event, helper) {
        component.set("v.loaded", true);
        var id = component.get("v.recordId");
        component.set("v.NoData", true);
        var selectedRange = 'THIS_FISCAL_YEAR';
        var startDate = null;
        var endDate = null;
		helper.getData(component, event, helper, startDate, endDate, selectedRange);
    },
	loadCharts : function(component, event, helper) {
      //  var i = component.get("v.totalBusinessImpactNPL"); 
      //  helper.buildChartData(component, event, helper,i);
	},
    handleChange : function(component, event, helper){
        console.log('handleChange called-->');
        var selectedRange = component.find("rangeId").get("v.value");
        console.log('selectedRange-->'+selectedRange);
        component.set('v.selectedRange',selectedRange);
        if(selectedRange != 'Custom'){
            var startDate = null;
            var endDate = null;
            component.set('v.loaded', true);
            component.set("v.startDate",startDate);
            component.set("v.endDate",endDate);
            helper.getData(component, event, helper, startDate, endDate, selectedRange);
        }
    },
    filterData: function(component, event, helper){
        component.set("v.loaded", true);
        var date1 = component.get("v.startDate");
        var date2 =  new Date(component.get("v.endDate"));
        var selectedRange = component.get("v.selectedRange");
        if(date1 == null || date2 == null || date1 == undefined || date2 == undefined || date1 == '' || date2 == ''){
            component.set("v.loaded", false);
            var message = 'Please choose both Start Date and End Date';
            helper.showErrorToast(component, event, message);
        } else{
            helper.getData(component, event, helper, date1, date2, selectedRange);     
        }
    },
    resetData: function(component, event, helper){
        component.set("v.loaded", true);
        component.set("v.startDate", null);
        component.set("v.endDate", null);
        var selectedRange = 'THIS_FISCAL_YEAR';
        var startDate = null;
        var endDate = null;
		helper.getData(component, event, helper, startDate, endDate, selectedRange);
    },
    handleClick1: function(component, event, helper){
        var listName = 'v.'+event.getSource().get("v.name");
        var data = component.get(listName);
        if(data.length > 0){
            console.log('Data:: '+JSON.stringify(data));
            for(var i=0; i<data.dataList.length; i++){
                if(data.dataList[i].showItem){
                    data.dataList[i].showItem = false;   
                } else{
                    data.dataList[i].showItem = true;
                }
            }
            component.set("v.recentAwardsProdAdditionList", data);
            component.set("v.show", false);   
        }
    },
    handleClick2: function(component, event, helper){
        var listName = 'v.'+event.getSource().get("v.name");
        var data = component.get(listName);
        console.log('Data:: '+JSON.stringify(data));
        for(var i=0; i<data.dataList.length; i++){
            if(data.dataList[i].showItem){
                data.dataList[i].showItem = false;   
            } else{
                data.dataList[i].showItem = true;
            }
        }
        component.set("v.recentAwardsProdAdditionList", data);
        component.set("v.show", true);
    }
})