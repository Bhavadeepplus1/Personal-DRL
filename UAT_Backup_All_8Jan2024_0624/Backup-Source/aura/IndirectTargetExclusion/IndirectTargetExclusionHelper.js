({
	GetData : function(component, event, helper) {
        component.set("v.salesRepName",component.get("v.SalesManagerselectedPdts"))
        component.set("v.customer_Name",component.get("v.selectedPicklist"))
        component.set("v.product_List",component.get("v.selectedProducts"))
        //console.log('selectedReps are -------------------------> '+JSON.stringify(component.get("v.SalesManagerselectedPdts")));
        console.log('sales reps==>'+JSON.stringify(component.get("v.SalesManagerselectedPdts")));
        console.log('customers list==>'+JSON.stringify(component.get("v.selectedPicklist")))
        console.log('product_List list==>'+JSON.stringify(component.get("v.selectedProducts")))
         console.log('contracts_List list==>'+JSON.stringify(component.get("v.selectedContracts")))
        var action = component.get("c.getIndirectSalesList");
        action.setParams({
            contracts_List: component.get("v.selectedContracts"),
            salesRepName: component.get("v.SalesManagerselectedPdts"),
            customer_Name: component.get("v.selectedPicklist"),
            product_List: component.get("v.selectedProducts"),
            
        });
        action.setCallback(this,function(response){
            
            if(response.getState()=="SUCCESS"){
                console.log('Indirect exclusion data is -->  '+JSON.stringify(response.getReturnValue()))
                var originalList = response.getReturnValue();
                component.set("v.MonthKeys",originalList[originalList.length-1].currenttwelveMonthKeys);
                var modified_list = [];
                console.log('length==>'+response.getReturnValue().length);
                for(var i=0;i<response.getReturnValue().length-2;i++){
                    modified_list.push(response.getReturnValue()[i]);
                }
                /*added by satya*/
                var uniqueList = [];
                for(var i =0;i<modified_list.length ;i++){
                    if(!uniqueList.includes(modified_list[i].contractNumber)){
                   		uniqueList.push(modified_list[i].contractNumber);
                    }
                }
              // console.log('uniqueList length==>'+uniqueList.length)
               component.set('v.uniqueCustLength',uniqueList.length)
                /*end by satya*/
                component.set("v.allIndirectExclusionList",modified_list);
                /*added by satya*/
                
                var month1salessummary = modified_list.reduce((sum, record) => sum + (parseFloat(record.month1_Direct_Sales.replace(/,/g, '') || 0)), 0).toLocaleString();
                var month2salessummary = modified_list.reduce((sum, record) => sum + (parseFloat(record.month2_Direct_Sales.replace(/,/g, '') || 0)), 0).toLocaleString();
                var month3salessummary = modified_list.reduce((sum, record) => sum + (parseFloat(record.month3_Direct_Sales.replace(/,/g, '') || 0)), 0).toLocaleString();
                var month4salessummary = modified_list.reduce((sum, record) => sum + (parseFloat(record.month4_Direct_Sales.replace(/,/g, '') || 0)), 0).toLocaleString();
                var month5salessummary = modified_list.reduce((sum, record) => sum + (parseFloat(record.month5_Direct_Sales.replace(/,/g, '') || 0)), 0).toLocaleString();
                var month6salessummary = modified_list.reduce((sum, record) => sum + (parseFloat(record.month6_Direct_Sales.replace(/,/g, '') || 0)), 0).toLocaleString();
                var month7salessummary = modified_list.reduce((sum, record) => sum + (parseFloat(record.month7_Direct_Sales.replace(/,/g, '') || 0)), 0).toLocaleString();
                var month8salessummary = modified_list.reduce((sum, record) => sum + (parseFloat(record.month8_Direct_Sales.replace(/,/g, '') || 0)), 0).toLocaleString();
                var month9salessummary = modified_list.reduce((sum, record) => sum + (parseFloat(record.month9_Direct_Sales.replace(/,/g, '') || 0)), 0).toLocaleString();
                var month10salessummary = modified_list.reduce((sum, record) => sum + (parseFloat(record.month10_Direct_Sales.replace(/,/g, '') || 0)), 0).toLocaleString();
                var month11salessummary = modified_list.reduce((sum, record) => sum + (parseFloat(record.month11_Direct_Sales.replace(/,/g, '') || 0)), 0).toLocaleString();
                var month12salessummary = modified_list.reduce((sum, record) => sum + (parseFloat(record.month12_Direct_Sales.replace(/,/g, '') || 0)), 0).toLocaleString();
                
                var month1units = modified_list.reduce((sum, record) => sum + (parseFloat(record.month1_Units.replace(/,/g, '') || 0)), 0);
                var month2units = modified_list.reduce((sum, record) => sum + (parseFloat(record.month2_Units.replace(/,/g, '') || 0)), 0);
                var month3units = modified_list.reduce((sum, record) => sum + (parseFloat(record.month3_Units.replace(/,/g, '') || 0)), 0);
                var month4units = modified_list.reduce((sum, record) => sum + (parseFloat(record.month4_Units.replace(/,/g, '') || 0)), 0);
                var month5units = modified_list.reduce((sum, record) => sum + (parseFloat(record.month5_Units.replace(/,/g, '') || 0)), 0);
                var month6units = modified_list.reduce((sum, record) => sum + (parseFloat(record.month6_Units.replace(/,/g, '') || 0)), 0);
                var month7units = modified_list.reduce((sum, record) => sum + (parseFloat(record.month7_Units.replace(/,/g, '') || 0)), 0);
                var month8units = modified_list.reduce((sum, record) => sum + (parseFloat(record.month8_Units.replace(/,/g, '') || 0)), 0);
                var month9units = modified_list.reduce((sum, record) => sum + (parseFloat(record.month9_Units.replace(/,/g, '') || 0)), 0);
                var month10units = modified_list.reduce((sum, record) => sum + (parseFloat(record.month10_Units.replace(/,/g, '') || 0)), 0);
                var month11units = modified_list.reduce((sum, record) => sum + (parseFloat(record.month11_Units.replace(/,/g, '') || 0)), 0);
                var month12units = modified_list.reduce((sum, record) => sum + (parseFloat(record.month12_Units.replace(/,/g, '') || 0)), 0);
                
                
                var summarylist = {
                    month1_sales_summary : month1salessummary,
                    month2_sales_summary : month2salessummary,
                    month3_sales_summary : month3salessummary,
                    month4_sales_summary : month4salessummary,
                    month5_sales_summary : month5salessummary,
                    month6_sales_summary : month6salessummary,
                    month7_sales_summary : month7salessummary,
                    month8_sales_summary : month8salessummary,
                    month9_sales_summary : month9salessummary,
                    month10_sales_summary : month10salessummary,
                    month11_sales_summary : month11salessummary,
                    month12_sales_summary : month12salessummary,
                    
                    month1_units : month1units,
                    month2_units : month2units,
                    month3_units : month3units,
                    month4_units : month4units,
                    month5_units : month5units,
                    month6_units : month6units,
                    month7_units : month7units,
                    month8_units : month8units,
                    month9_units : month9units,
                    month10_units : month10units,
                    month11_units : month11units,
                    month12_units : month12units
                }
                
                console.log('summary list is --> '+JSON.stringify(summarylist));
                component.set('v.summaryList',summarylist);
                
                var count = 0;
                var initialRecList =modified_list.slice(count , 50)
                component.set("v.count",count+50);
                component.set("v.IndirectExclusionList",initialRecList);
                /*end by satya*/
                console.log('indirect sales data is ---> '+modified_list[0]);
                component.set("v.isSpinnerLoad",false);
            }
            else{
                console.log('Error is --> '+JSON.stringify(response.getError()));
            }
            
        });
        $A.enqueueAction(action);
		
	},
    
   getContractsName:function(component, event, helper){
        var action = component.get("c.getContracts");
        action.setParams({
            //salesRepName : component.get("v.salesRepName"),
        })
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title=[];
                for (var i=0; i<responseList.length; i++) {
                    title[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.optionsforContracts",title);  
               
               
               
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action);
     },

     getSalesRepName:function(component, event, helper){
        var action = component.get("c.getSalesReps");
        action.setParams({
            //salesRepName : component.get("v.salesRepName"),
        })
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title=[];
                for (var i=0; i<responseList.length; i++) {
                    title[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.optionsforSalesReps",title);  
               
               
               
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action);
     },
    getCustomerName:function(component, event, helper){
        var action = component.get("c.getCustomerNames");
        action.setParams({
            //salesRepName : component.get("v.salesRepName"),
        })
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title=[];
                for (var i=0; i<responseList.length; i++) {
                    title[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.optionsforCustomers",title);  
               
               
               
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action);
     },
    
    getProducts:function(component, event, helper){
        var action = component.get("c.getProductNames");
        action.setParams({
            //salesRepName : component.get("v.salesRepName"),
        })
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title=[];
                for (var i=0; i<responseList.length; i++) {
                    title[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.optionsforProducts",title);  
               	helper.GetData(component, event, helper)
               
               
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action);
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
})