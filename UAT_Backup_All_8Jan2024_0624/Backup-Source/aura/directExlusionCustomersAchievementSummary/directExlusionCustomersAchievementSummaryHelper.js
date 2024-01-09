({
	ExcludedEastSalesrepTargetData : function(component, event, helper) {
        
        
        var data = component.get("c.getExcludedEastSalesrepTargetData");
        data.setParams({
        });
         data.setCallback(this, function(response) {
              if(response.getState()=="SUCCESS"){
                  
                  
                  var q1_total = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_one_Achieved || 0), 0);
                  var q2_total = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_two_Achieved || 0), 0);
                  var q3_total = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_three_Achieved || 0), 0);
                  var q4_total = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_four_Achieved || 0), 0);
                  var annual_total = response.getReturnValue().reduce((sum, record) => sum + (record.annual_Achieved || 0), 0);
                  
                  var eric = {
                      
                      Quarter1 : helper.formatRevenue(q1_total),
                      Quarter2 : helper.formatRevenue(q2_total),
                      Quarter3 : helper.formatRevenue(q3_total),
                      Quarter4 : helper.formatRevenue(q4_total),
                      Annual : helper.formatRevenue(annual_total)
                      
                  }
                  
                  component.set("v.ericSutherland",eric);
                  
                  
                  console.log('medgi res==>'+response.getReturnValue())
                  var customFieldList = response.getReturnValue().slice(0, 6).map(function(record) {
                      var Q1formatRevenue = helper.formatRevenue(record.quarter_one_Achieved);
                      var Q2formatRevenue = helper.formatRevenue(record.quarter_two_Achieved);
                      var Q3formatRevenue = helper.formatRevenue(record.quarter_three_Achieved);
                      var Q4formatRevenue = helper.formatRevenue(record.quarter_four_Achieved);
                      var AnnualRevenue = helper.formatRevenue(record.annual_Achieved);
                      //var formattedTarget = helper.formatRevenue(record.annual_Target);
                      //var percent = record.annual_Achieved != null && record.annual_Achieved != 0? Math.round((parseInt(record.annual_Achieved) / parseInt(record.annual_Target) )*100) :0;
                      //console.log(formattedRevenue);
                      return {
                          Name: record.salesRepName,
                          Q1_Achieved: Q1formatRevenue,
                          Q2_Achieved: Q2formatRevenue,
                          Q3_Achieved: Q3formatRevenue,
                          Q4_Achieved: Q4formatRevenue,
                          Annual_Achieved: AnnualRevenue,
                          
                          
                      };
                    });
                  component.set("v.excludedEastSalesRepData",customFieldList);
                  console.log('excludedSalesRepData'+JSON.stringify(customFieldList[0]));
                 //var resp =  response.getReturnValue()
                 // console.log('resp==>'+JSON.stringify(resp))
                 }else{
                     console.log('error');
                 }
         });
         $A.enqueueAction(data);
        
        
		
	},
    ExcludedWestSalesrepTargetData : function(component, event, helper) {
        
        
        var data = component.get("c.getExcludedWestSalesrepTargetData");
        data.setParams({
        });
         data.setCallback(this, function(response) {
              if(response.getState()=="SUCCESS"){
                  
                  
                  var q1_total = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_one_Achieved || 0), 0);
                  var q2_total = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_two_Achieved || 0), 0);
                  var q3_total = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_three_Achieved || 0), 0);
                  var q4_total = response.getReturnValue().reduce((sum, record) => sum + (record.quarter_four_Achieved || 0), 0);
                  var annual_total = response.getReturnValue().reduce((sum, record) => sum + (record.annual_Achieved || 0), 0);
                  
                  var dave = {
                      
                      Quarter1 : helper.formatRevenue(q1_total),
                      Quarter2 : helper.formatRevenue(q2_total),
                      Quarter3 : helper.formatRevenue(q3_total),
                      Quarter4 : helper.formatRevenue(q4_total),
                      Annual : helper.formatRevenue(annual_total)
                      
                  }
                  
                  component.set("v.daveSmith",dave);
                  
                  var customFieldList = response.getReturnValue().slice(0, 6).map(function(record) {
                      var Q1formatRevenue = helper.formatRevenue(record.quarter_one_Achieved);
                      var Q2formatRevenue = helper.formatRevenue(record.quarter_two_Achieved);
                      var Q3formatRevenue = helper.formatRevenue(record.quarter_three_Achieved);
                      var Q4formatRevenue = helper.formatRevenue(record.quarter_four_Achieved);
                      var AnnualRevenue = helper.formatRevenue(record.annual_Achieved);
                      //var formattedTarget = helper.formatRevenue(record.annual_Target);
                      //var percent = record.annual_Achieved != null && record.annual_Achieved != 0? Math.round((parseInt(record.annual_Achieved) / parseInt(record.annual_Target) )*100) :0;
                      //console.log(formattedRevenue);
                      return {
                          Name: record.salesRepName,
                          Q1_Achieved: Q1formatRevenue,
                          Q2_Achieved: Q2formatRevenue,
                          Q3_Achieved: Q3formatRevenue,
                          Q4_Achieved: Q4formatRevenue,
                          Annual_Achieved: AnnualRevenue,
                          
                          
                      };
                    });
                  component.set("v.excludedWestSalesRepData",customFieldList);
                  console.log('excludedSalesRepData'+JSON.stringify(customFieldList[0]));
                 //var resp =  response.getReturnValue()
                 // console.log('resp==>'+JSON.stringify(resp))
                 }else{
                     console.log('error');
                 }
         });
         $A.enqueueAction(data);
		
	},
    formatRevenue: function(annualRevenue) {
        if (annualRevenue >= 1000000) {
            return (annualRevenue / 1000000).toFixed(1) + 'M';
        } else if (annualRevenue >= 1000) {
            return (annualRevenue / 1000).toFixed(1) + 'k';
        } else {
            return annualRevenue;
        }
    },
})