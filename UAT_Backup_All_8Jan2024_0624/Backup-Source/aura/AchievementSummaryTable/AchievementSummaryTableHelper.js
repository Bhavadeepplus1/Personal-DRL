({
	getData: function(component, event, helper){
        var action = component.get("c.getWestDirectIndirectSalesList");
        action.setParams({
        });
        action.setCallback(this, function(response) {
             if(response.getState()=="SUCCESS"){
                  var result= response.getReturnValue();
                  console.log('west sales data is result==>'+JSON.stringify(result));
				 
                 var Q1Total = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_one_Achieved || 0), 0);
                 var Q1Target = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_one_Target || 0), 0);
                 var Q1percentage = (Q1Total != null && Q1Total != 0 && Q1Target != null && Q1Target != 0)? Math.round((parseInt(Q1Total) / parseInt(Q1Target) )*100) :0;
                 
                 var Q2Total = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_two_Achieved || 0), 0);
                 var Q2Target = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_Two_Target || 0), 0);
                 var Q2percentage = (Q2Total != null && Q2Total != 0 && Q2Target != null && Q2Target != 0)? Math.round((parseInt(Q2Total) / parseInt(Q2Target) )*100) :0;
                 
                 
                 var Q3Total = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_three_Achieved || 0), 0);
                 var Q3Target = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_Three_Target || 0), 0);
                 var Q3percentage = (Q3Total != null && Q3Total != 0 && Q3Target != null && Q3Target != 0) ? Math.round((parseInt(Q3Total) / parseInt(Q3Target) )*100) :0;
                 
                 
                 var Q4Total = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_four_Achieved || 0), 0);
                 var Q4Target = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_Four_Target || 0), 0);
                 var Q4percentage = (Q4Total != null && Q4Total != 0 && Q4Target != null && Q4Target != 0)? Math.round((parseInt(Q4Total) / parseInt(Q4Target) )*100) :0;
                 
                 var AnnualTotal = response.getReturnValue().reduce((sum, record) => sum + (record.annual_Achieved || 0), 0);
                 var AnnualTarget = response.getReturnValue().reduce((sum, record) => sum + (record.annual_Target || 0), 0);
                 var Annualpercentage = (AnnualTotal != null && AnnualTotal != 0 && AnnualTarget != null && AnnualTarget != 0)? Math.round((parseInt(AnnualTotal) / parseInt(AnnualTarget) )*100) :0;
                 
                 var dave = {
                     
                     Quarter1 : helper.formatRevenue(Q1Total),
                     Quarter2 : helper.formatRevenue(Q2Total),
                     Quarter3 : helper.formatRevenue(Q3Total),
                     Quarter4 : helper.formatRevenue(Q4Total),
                     Target1 : helper.formatRevenue(Q1Target),
                     Target2 : helper.formatRevenue(Q2Target),
                     Target3 : helper.formatRevenue(Q3Target),
                     Target4 : helper.formatRevenue(Q4Target),
                     percentage1 : Q1percentage,
                     percentage2 : Q2percentage,
                     percentage3 : Q3percentage,
                     percentage4 : Q4percentage,
                     
                     AnnualAchieved : helper.formatRevenue(AnnualTotal),
                     TargetAchieved : helper.formatRevenue(AnnualTarget),
                     Annualpercentage : Annualpercentage
                     
                     
                 };
                 component.set("v.DaveSmith",dave);
                 
                 //console.log('dave smith data is ---> '+JSON.stringify(dave));
                 //console.log('dave smith data is ---> '+component.get("v.DaveSmith"));
                 
                 var customFieldList = response.getReturnValue().map(function(record) {
                     var Q1formatRevenue = helper.formatRevenue(record.quarter_one_Achieved);
                     var Q2formatRevenue = helper.formatRevenue(record.quarter_two_Achieved);
                     var Q3formatRevenue = helper.formatRevenue(record.quarter_three_Achieved);
                     var Q4formatRevenue = helper.formatRevenue(record.quarter_four_Achieved);
                     var AnnualRevenue = helper.formatRevenue(record.annual_Achieved);
                     var T1_formatAchieved = helper.formatRevenue(record.quarter_one_Target);
                     var T2_formatAchieved = helper.formatRevenue(record.quarter_Two_Target);
                     var T3_formatAchieved = helper.formatRevenue(record.quarter_Three_Target);
                     var T4_formatAchieved = helper.formatRevenue(record.quarter_Four_Target);
                     var annualtarget = helper.formatRevenue(record.annual_Target);
                     var Q1percentage = (record.quarter_one_Achieved != null && record.quarter_one_Achieved != 0 && record.quarter_one_Target != null && record.quarter_one_Target != 0)? Math.round((parseInt(record.quarter_one_Achieved) / parseInt(record.quarter_one_Target) )*100) :0;
                     var Q2percentage = (record.quarter_two_Achieved != null && record.quarter_two_Achieved != 0 && record.quarter_Two_Target != null && record.quarter_Two_Target != 0)? Math.round((parseInt(record.quarter_two_Achieved) / parseInt(record.quarter_Two_Target) )*100) :0;
                     var Q3percentage = (record.quarter_three_Achieved != null && record.quarter_three_Achieved != 0 && record.quarter_Three_Target != null && record.quarter_Three_Target != 0)? Math.round((parseInt(record.quarter_three_Achieved) / parseInt(record.quarter_Three_Target) )*100) :0;
                     var Q4percentage = (record.quarter_four_Achieved != null && record.quarter_four_Achieved != 0 && record.quarter_four_Target != null && record.quarter_four_Target != 0)? Math.round((parseInt(record.quarter_four_Achieved) / parseInt(record.quarter_four_Target) )*100) :0;
                     var annualPercentage = (record.annual_Achieved != null && record.annual_Achieved != 0 && record.annual_Target != null && record.annual_Target != 0) ? Math.round((parseInt(record.annual_Achieved) / parseInt(record.annual_Target) )*100) : 0;
                     var classQ ;
                     if(Q1percentage > 90) classQ = '#579857';
                     else if(Q1percentage >= 50 && Q1percentage < 90) classQ = '#5072F1';
                     else if(Q1percentage < 50) classQ = '#EB4747';
                     else classQ = 'black';
                     console.log('classQ=='+classQ);
                     var color = classQ.replaceAll("^\"|\"$", "");
                     console.log('color=='+color);
                     return {
                         Name : record.salesRepName,
                         Target1: T1_formatAchieved,
                         Target2: T2_formatAchieved,
                         Target3: T3_formatAchieved,
                         Target4: T4_formatAchieved,
                         Q1_Achieved: Q1formatRevenue,
                         Q2_Achieved: Q2formatRevenue,
                         Q3_Achieved: Q3formatRevenue,
                         Q4_Achieved: Q4formatRevenue,
                         percentage_for_Q1 : Q1percentage,
                         percentage_for_Q2 : Q2percentage,
                         percentage_for_Q3 : Q3percentage,
                         percentage_for_Q4 : Q4percentage,
                         annualPercent : annualPercentage,
                         Annual : AnnualRevenue,
                         annualTarget : annualtarget,
                         class1 : '#EB4747',
                         class2 : '#EB4747',
                         class3 : '#EB4747',
                         class4 : '#EB4747',
                         class5 : '#EB4747',
                     };
                 });
                 console.log('test=='+JSON.stringify(customFieldList));
                 component.set("v.WestSalesRepData",customFieldList)
                 var q1_total = 0;
                 for(var i=0;i<response.getReturnValue().length; i++){
                     
                     q1_total += i.quarter_one_Achieved;
                 }
                 component.set("v.q1_total",q1_total);
                 console.log('WestSalesRepData==>'+JSON.stringify(component.get("v.WestSalesRepData")))
                 var isasc = component.get("v.isAscAnnual");
                 component.set("v.sortField",'annualPercent');
                 console.log('result in sort by test1'+JSON.stringify(component.get("v.EastSalesRepData")))
                 var region = "West";
                 helper.initsortBy(component,'annualPercent', helper,isasc,region);
             }else{
                console.log("Error "+JSON.stringify(response.getError()));

             }
        });
             $A.enqueueAction(action);
        
        },
    
    
    
    getEastData: function(component, event, helper){
        
        
        var control = component.get("c.getEastDirectIndirectSalesList");
        control.setParams({
        });
        control.setCallback(this, function(response) {
             if(response.getState()=="SUCCESS"){
                  var result= response.getReturnValue();
                 
                 console.log('raw data with percentages is--->  '+ JSON.stringify(response.getReturnValue()));
                 
                 var Q1Total = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_one_Achieved || 0), 0);
                 var Q1Target = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_one_Target || 0), 0);
                 var Q1percentage = (Q1Total != null && Q1Total != 0 && Q1Target != null && Q1Target != 0)? Math.round((parseInt(Q1Total) / parseInt(Q1Target) )*100) :0;
                 
                 var Q2Total = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_two_Achieved || 0), 0);
                 var Q2Target = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_Two_Target || 0), 0);
                 var Q2percentage = (Q2Total != null && Q2Total != 0 && Q2Target != null && Q2Target != 0)? Math.round((parseInt(Q2Total) / parseInt(Q2Target) )*100) :0;
                 
                 
                 var Q3Total = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_three_Achieved || 0), 0);
                 var Q3Target = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_Three_Target || 0), 0);
                 var Q3percentage = (Q3Total != null && Q3Total != 0 && Q3Target != null && Q3Target !=0)? Math.round((parseInt(Q3Total) / parseInt(Q3Target) )*100) :0;
                 
                 
                 var Q4Total = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_four_Achieved || 0), 0);
                 var Q4Target = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_Four_Target || 0), 0);
                 var Q4percentage = (Q1Total != null && Q4Total != 0 && Q4Target != null && Q4Target != 0)? Math.round((parseInt(Q4Total) / parseInt(Q4Target) )*100) :0;
                 
                 var AnnualTotal = response.getReturnValue().reduce((sum, record) => sum + (record.annual_Achieved || 0), 0);
                 var AnnualTarget = response.getReturnValue().reduce((sum, record) => sum + (record.annual_Target || 0), 0);
                 var Annualpercentage = (AnnualTotal != null && AnnualTotal != 0 && AnnualTarget != null && AnnualTarget != 0)? Math.round((parseInt(AnnualTotal) / parseInt(AnnualTarget) )*100) :0;
                 
                 var eric = {
                     
                     Quarter1 : helper.formatRevenue(Q1Total),
                     Quarter2 : helper.formatRevenue(Q2Total),
                     Quarter3 : helper.formatRevenue(Q3Total),
                     Quarter4 : helper.formatRevenue(Q4Total),
                     Target1 : helper.formatRevenue(Q1Target),
                     Target2 : helper.formatRevenue(Q2Target),
                     Target3 : helper.formatRevenue(Q3Target),
                     Target4 : helper.formatRevenue(Q4Target),
                     percentage1 : Q1percentage,
                     percentage2 : Q2percentage,
                     percentage3 : Q3percentage,
                     percentage4 : Q4percentage,
                     AnnualAchieved : helper.formatRevenue(AnnualTotal),
                     TargetAchieved : helper.formatRevenue(AnnualTarget),
                     Annualpercentage : Annualpercentage
                     
                 };
				  component.set("v.EricSutherland",eric);
                  
                 
                 var customFieldList = response.getReturnValue().map(function(record) {
                     var Q1formatRevenue = helper.formatRevenue(record.quarter_one_Achieved);
                     var Q2formatRevenue = helper.formatRevenue(record.quarter_two_Achieved);
                     var Q3formatRevenue = helper.formatRevenue(record.quarter_three_Achieved);
                     var Q4formatRevenue = helper.formatRevenue(record.quarter_four_Achieved);
                     var AnnualRevenue = helper.formatRevenue(record.annual_Achieved);
                     var T1_formatAchieved = helper.formatRevenue(record.quarter_one_Target);
                     var T2_formatAchieved = helper.formatRevenue(record.quarter_Two_Target);
                     var T3_formatAchieved = helper.formatRevenue(record.quarter_Three_Target);
                     var T4_formatAchieved = helper.formatRevenue(record.quarter_Four_Target);
                     var annualtarget = helper.formatRevenue(record.annual_Target);
                     var Q1percentage = (record.quarter_one_Achieved != null && record.quarter_one_Achieved != 0 && record.quarter_one_Target != null && record.quarter_one_Target != 0)? Math.round((parseInt(record.quarter_one_Achieved) / parseInt(record.quarter_one_Target) )*100) :0;
                     var Q2percentage = (record.quarter_two_Achieved != null && record.quarter_two_Achieved != 0 && record.quarter_Two_Target != null && record.quarter_Two_Target != 0) ? Math.round((parseInt(record.quarter_two_Achieved) / parseInt(record.quarter_Two_Target) )*100) :0;
                     var Q3percentage = (record.quarter_three_Achieved != null && record.quarter_three_Achieved != 0 && record.quarter_Three_Target != null && record.quarter_Three_Target != 0)? Math.round((parseInt(record.quarter_three_Achieved) / parseInt(record.quarter_Three_Target) )*100) :0;
                     var Q4percentage = (record.quarter_four_Achieved != null && record.quarter_four_Achieved != 0 && record.quarter_four_Target != null && record.quarter_four_Target != 0)? Math.round((parseInt(record.quarter_four_Achieved) / parseInt(record.quarter_four_Target) )*100) :0;
                     var annualPercentage = (record.annual_Achieved != null && record.annual_Achieved != 0 && record.annual_Target != null && record.annual_Target != 0)? Math.round((parseInt(record.annual_Achieved) / parseInt(record.annual_Target) )*100) : 0;
                     //console.log(AnnualRevenue);
                     return {
                         Name : record.salesRepName,
                         Target1: T1_formatAchieved,
                         Target2: T2_formatAchieved,
                         Target3: T3_formatAchieved,
                         Target4: T4_formatAchieved,
                         Q1_Achieved: Q1formatRevenue,
                         Q2_Achieved: Q2formatRevenue,
                         Q3_Achieved: Q3formatRevenue,
                         Q4_Achieved: Q4formatRevenue,
                         percentage_for_Q1 : Q1percentage,
                         percentage_for_Q2 : Q2percentage,
                         percentage_for_Q3 : Q3percentage,
                         percentage_for_Q4 : Q4percentage,
                         annualPercent : annualPercentage,
                         Annual : AnnualRevenue,
                         annualTarget : annualtarget
                         
                     };
                 });
                 //console.log(customFieldList);
                 component.set("v.EastSalesRepData",customFieldList);
                 console.log('east sales list is -------->' + JSON.stringify(customFieldList));
				 var isasc = component.get("v.isAscEastAnnual");
                 component.set("v.sortField",'annualPercent');
                 var region = "East";
                 helper.initsortBy(component,'annualPercent', helper,isasc,region);
             }else{
                console.log("Error "+JSON.stringify(response.getError()));

             }
        });
             $A.enqueueAction(control);
        
        
    },
    
    
    formatRevenue: function(annualRevenue) {
        if (annualRevenue >= 1000000) {
            return (annualRevenue / 1000000).toFixed(1) + 'M';
        } else if (annualRevenue >= 1000) {
            return (annualRevenue / 1000).toFixed(1) + 'k';
        } else {
            return annualRevenue.toString();
        }
    },
    sortByWestData: function(component, field, helper,isasc) {
        var sortAsc = isasc;//component.get("v.isAsc"),
     	var sortField = component.get("v.sortField"),
        records = component.get("v.WestSalesRepData");
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        //component.set("v.isAsc", sortAsc);
        console.log('records in sort by'+JSON.stringify(records))
        component.set("v.WestSalesRepData", records);
},
    sortByEastData: function(component, field, helper,isasc) {
        var sortAsc = isasc;//component.get("v.isAsc"),
        var sortField = component.get("v.sortField"),
            records = component.get("v.EastSalesRepData");
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        //component.set("v.isAsc", sortAsc);
        console.log('records in sort by'+JSON.stringify(records))
        component.set("v.EastSalesRepData", records);
    },
    initsortBy: function(component, field, helper,isasc,region)  {
       var sortAsc = isasc;//component.get("v.isAsc"),
     	var sortField = component.get("v.sortField");
        var records;
        if(region == 'West'){
         records = component.get("v.WestSalesRepData");
        }
        if(region == 'East'){
           records = component.get("v.EastSalesRepData");
        }
        //sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        //component.set("v.isAsc", sortAsc);
       console.log('sortAsc test'+sortAsc)

         component.set("v.isAscAnnual",sortAsc);
        console.log('records in sort by'+JSON.stringify(records))
         if(region == 'West'){
        	component.set("v.WestSalesRepData", records);
         }
         if(region == 'East'){
             component.set("v.EastSalesRepData", records);
         }
    },
    
    getCurrentFiscalYear: function(component, event, helper){
    const today = new Date();
    const fiscalYearStartMonth = 3; 
    let fiscalYear = today.getFullYear();
    
    if (today.getMonth() < fiscalYearStartMonth) {
    fiscalYear--; 
	}
 
 	return fiscalYear+1;
 	},
   



  
})