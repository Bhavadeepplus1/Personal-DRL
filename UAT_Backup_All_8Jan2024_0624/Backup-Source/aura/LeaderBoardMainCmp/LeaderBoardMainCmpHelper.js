({
    getData : function(component, event, helper) {
        
        
        
        
        /*var action = component.get("c.getWestDirectIndirectSalesList");
        var selectedValue = component.get("v.selectedValue");
        console.log('selectedValue is ==> '+selectedValue);
        action.setParams({
        });
        action.setCallback(this, function(response) {
            if(response.getState()=="SUCCESS"){
                if(selectedValue == 'Annual')
                {
                    var serialNumber = 1;
                    var customFieldList = response.getReturnValue().slice(0, 6).map(function(record) {
                    var formattedRevenue = helper.formatRevenue(record.annual_Achieved);
                    var formattedTarget = helper.formatRevenue(record.annual_Target);
                    //console.log(formattedRevenue);
                    return {
                        Name: record.salesRepName,
                        Achieved: formattedRevenue,
                        Target : formattedTarget,
                        serialNumber : serialNumber++,
                        percentage : percent
                        
                    };
                	});
                    component.set("v.SalesRepData",customFieldList);
                }
                if(selectedValue == 'Quarter 1')
                {
                    var serialNumber = 1;
                    var customFieldList = response.getReturnValue().slice(0, 6).map(function(record) {
                        var formattedRevenue = helper.formatRevenue(record.quarter_one_Achieved);
                        var formattedTarget = helper.formatRevenue(record.quarter_one_Target);
                    return {
                        Name: record.salesRepName,
                        Achieved: formattedRevenue,
                        Target : formattedTarget,
                        serialNumber : serialNumber++
                    };
                	});
                    component.set("v.SalesRepData",customFieldList);
                }
                
                if(selectedValue == 'Quarter 2')
                {
                    var serialNumber = 1;
                    var customFieldList = response.getReturnValue().slice(0, 6).map(function(record) {
                        var formattedRevenue = helper.formatRevenue(record.quarter_two_Achieved);
                        var formattedTarget = helper.formatRevenue(record.quarter_Two_Target);
                    return {
                        Name: record.salesRepName,
                        Achieved: formattedRevenue,
                        Target : formattedTarget,
                        serialNumber : serialNumber++
                    };
                	});
                    component.set("v.SalesRepData",customFieldList);
                }
                
                if(selectedValue == 'Quarter 3')
                {
                    var serialNumber = 1;
                    var customFieldList = response.getReturnValue().slice(0, 6).map(function(record) {
                        var formattedRevenue = helper.formatRevenue(record.quarter_three_Achieved);
                        var formattedTarget = helper.formatRevenue(record.quarter_Three_Target);
                    return {
                        Name: record.salesRepName,
                        Achieved: formattedRevenue,
                        Target : formattedTarget,
                        serialNumber : serialNumber++
                    };
                	});
                    component.set("v.SalesRepData",customFieldList);
                }
                
                if(selectedValue == 'Quarter 4')
                {
                    var serialNumber = 1;
                    var customFieldList = response.getReturnValue().slice(0, 6).map(function(record) {
                        var formattedRevenue = helper.formatRevenue(record.quarter_four_Achieved);
                        var formattedTarget = helper.formatRevenue(record.quarter_Four_Target);
                    return {
                        Name: record.salesRepName,
                        Achieved: formattedRevenue,
                        Target : formattedTarget,
                        serialNumber : serialNumber++
                    };
                	});
                    component.set("v.SalesRepData",customFieldList);
                }
                
                
            }else{
                console.log("Error "+JSON.stringify(response.getError()));
                
            }
        });
        $A.enqueueAction(action);
        */
    },
    
    
    getWestSalesData : function(component, event, helper,fiscalYear){
        
        //console.log('Inthe getWestSalesData function');
        var west = component.get("c.getWestDirectIndirectSalesList");
        var selectedValue = component.get("v.selectedValue");
        console.log('selectedValue is ==> '+selectedValue);
        west.setParams({
        });
        west.setCallback(this, function(response) {
            if(response.getState()=="SUCCESS"){
                if(selectedValue === 'FY '+ fiscalYear+' Annual')
                {
                    component.set("v.Heading",selectedValue);
                    console.log('direct sales data is ---> '+JSON.stringify(response.getReturnValue()));
                    var serialNumber = 1;
                    var customFieldList = response.getReturnValue().slice(0, 6).map(function(record) {
                        var formattedRevenue = helper.formatRevenue(record.annual_Achieved);
                        var formattedTarget = helper.formatRevenue(record.annual_Target);
                        var percent = (record.annual_Achieved != null && record.annual_Achieved != 0 && record.annual_Target != null && record.annual_Target != 0)? Math.round((parseInt(record.annual_Achieved) / parseInt(record.annual_Target) )*100) :0;
                        var directPercentage = (record.annual_directSales != null && record.annual_directSales != 0 && record.annual_Target != null && record.annual_Target !=0)? Math.round((parseInt(record.annual_directSales) / parseInt(record.annual_Target) )*100) :0;
                        var IndirectPercentage = (record.annual_indirectSales != null && record.annual_indirectSales != 0 && record.annual_Target != null && record.annual_Target != 0)? Math.round((parseInt(record.annual_indirectSales) / parseInt(record.annual_Target) )*100) :0;
                        var percentToPixel = (percent> 100) ? (Math.round((percent/100)* 340)) : Math.round((percent/100)* 340);
                        if(directPercentage > IndirectPercentage){
                            var directToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        else{
                            var directToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        
                        
                        
                        return {
                            Name: record.salesRepName,
                            Achieved: formattedRevenue,
                            Target : formattedTarget,
                            serialNumber : serialNumber++,
                            percentage : percent,
                            directSales : directPercentage,
                            inDirectSales: IndirectPercentage,
                            totalPixel : percentToPixel,
                            directPixel : directToPixel,
                            indirectPixel : indirectToPixel
                        };
                    });
                    customFieldList.sort(function(a, b) {
                        return b.percentage - a.percentage;
                    });
                    component.set("v.WestSalesRepData",customFieldList);
                    //console.log('updated pixels is : '+JSON.stringify(customFieldList));
                    //console.log('west sales data is --> '+JSON.stringify(customFieldList));
                }
                if(selectedValue === 'FY '+fiscalYear+' Quarter 1')
                {
                    component.set("v.Heading",selectedValue);
                    var serialNumber = 1;
                    var customFieldList = response.getReturnValue().slice(0, 6).map(function(record) {
                        var formattedRevenue = helper.formatRevenue(record.quarter_one_Achieved);
                        var formattedTarget = helper.formatRevenue(record.quarter_one_Target);
                        var percent = (record.quarter_one_Achieved != null && record.quarter_one_Target != 0 && record.quarter_one_Target != null && record.quarter_one_Target != 0)? Math.round((parseInt(record.quarter_one_Achieved) / parseInt(record.quarter_one_Target) )*100) :0;
                        var directPercentage = (record.q1_direct_sales != null && record.q1_direct_sales != 0 && record.quarter_one_Target != null && record.quarter_one_Target != 0)? Math.round((parseInt(record.q1_direct_sales) / parseInt(record.quarter_one_Target) )*100) :0;
                        var IndirectPercentage = (record.q1_indirect_sales != null && record.q1_indirect_sales != 0 && record.quarter_one_Target != null && record.quarter_one_Target != 0)? Math.round((parseInt(record.q1_indirect_sales) / parseInt(record.quarter_one_Target) )*100) :0;
                        var percentToPixel = (percent> 100) ? (Math.round((percent/100)* 340)) : Math.round((percent/100)* 340);
                        if(directPercentage > IndirectPercentage){
                            var directToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        else{
                            var directToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }                        
                        return {
                            Name: record.salesRepName,
                            Achieved: formattedRevenue,
                            Target : formattedTarget,
                            serialNumber : serialNumber++,
                            percentage : percent,
                            directSales : directPercentage,
                            inDirectSales: IndirectPercentage,
                            totalPixel : percentToPixel,
                            directPixel : directToPixel,
                            indirectPixel : indirectToPixel
                        };
                    });
                    customFieldList.sort(function(a, b) {
                        return b.percentage - a.percentage;
                    });
                    component.set("v.WestSalesRepData",customFieldList);
                    console.log('percentage change --> '+JSON.stringify(customFieldList));
                }
                
                if(selectedValue === 'FY '+fiscalYear+' Quarter 2')
                {
                    component.set("v.Heading",selectedValue);
                    var serialNumber = 1;
                    var customFieldList = response.getReturnValue().slice(0, 6).map(function(record) {
                        var formattedRevenue = helper.formatRevenue(record.quarter_two_Achieved);
                        var formattedTarget = helper.formatRevenue(record.quarter_Two_Target);
                        var percent = (record.quarter_two_Achieved != null && record.quarter_two_Achieved != 0 && record.quarter_Two_Target != null && record.quarter_Two_Target != 0)? Math.round((parseInt(record.quarter_two_Achieved) / parseInt(record.quarter_Two_Target) )*100) :0;
                        var directPercentage = (record.q2_direct_sales != null && record.q2_direct_sales != 0 && record.quarter_Two_Target != null && record.quarter_Two_Target != 0)? Math.round((parseInt(record.q2_direct_sales) / parseInt(record.quarter_Two_Target) )*100) :0;
                        var IndirectPercentage = (record.q2_indirect_sales != null && record.q2_indirect_sales != 0 && record.quarter_Two_Target != null && record.quarter_Two_Target != 0)? Math.round((parseInt(record.q2_indirect_sales) / parseInt(record.quarter_Two_Target) )*100) :0;
                        var percentToPixel = (percent> 100) ? ( Math.round((percent/100)* 340)) : Math.round((percent/100)* 340);
                        if(directPercentage > IndirectPercentage){
                            var directToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        else{
                            var directToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        return {
                            Name: record.salesRepName,
                            Achieved: formattedRevenue,
                            Target : formattedTarget,
                            serialNumber : serialNumber++,
                            percentage : percent,
                            directSales : directPercentage,
                            inDirectSales: IndirectPercentage,
                            totalPixel : percentToPixel,
                            directPixel : directToPixel,
                            indirectPixel : indirectToPixel
                        };
                    });
                    customFieldList.sort(function(a, b) {
                        return b.percentage - a.percentage;
                    });
                    component.set("v.WestSalesRepData",customFieldList);
                }
                
                if(selectedValue === 'FY '+fiscalYear+' Quarter 3')
                {
                    component.set("v.Heading",selectedValue);
                    var serialNumber = 1;
                    var customFieldList = response.getReturnValue().slice(0, 6).map(function(record) {
                        var formattedRevenue = helper.formatRevenue(record.quarter_three_Achieved);
                        var formattedTarget = helper.formatRevenue(record.quarter_Three_Target);
                        var percent = (record.quarter_three_Achieved != null && record.quarter_three_Achieved != 0 && record.quarter_Three_Target != null && record.quarter_Three_Target != 0)? Math.round((parseInt(record.quarter_three_Achieved) / parseInt(record.quarter_Three_Target) )*100) :0;
                        var directPercentage = (record.q3_direct_sales != null && record.q3_direct_sales != 0 && record.quarter_Three_Target != null && record.quarter_Three_Target != 0)? Math.round((parseInt(record.q3_direct_sales) / parseInt(record.quarter_Three_Target) )*100) :0;
                        var IndirectPercentage = (record.q3_indirect_sales != null && record.q3_indirect_sales != 0 && record.quarter_Three_Target != null && record.quarter_Three_Target != 0)? Math.round((parseInt(record.q3_indirect_sales) / parseInt(record.quarter_Three_Target) )*100) :0;
                        var percentToPixel = (percent> 100) ? ( Math.round((percent/100)* 340)) : Math.round((percent/100)* 340);
                        if(directPercentage > IndirectPercentage){
                            var directToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        else{
                            var directToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        return {
                            Name: record.salesRepName,
                            Achieved: formattedRevenue,
                            Target : formattedTarget,
                            serialNumber : serialNumber++,
                            percentage : percent,
                            directSales : directPercentage,
                            inDirectSales: IndirectPercentage,
                            totalPixel : percentToPixel,
                            directPixel : directToPixel,
                            indirectPixel : indirectToPixel
                        };
                    });
                    customFieldList.sort(function(a, b) {
                        return b.percentage - a.percentage;
                    });
                    component.set("v.WestSalesRepData",customFieldList);
                }
                
                if(selectedValue === 'FY '+fiscalYear+' Quarter 4')
                {
                    component.set("v.Heading",selectedValue);
                    var serialNumber = 1;
                    var customFieldList = response.getReturnValue().slice(0, 6).map(function(record) {
                        var formattedRevenue = helper.formatRevenue(record.quarter_four_Achieved);
                        var formattedTarget = helper.formatRevenue(record.quarter_Four_Target);
                        var percent = (record.quarter_four_Achieved != null && record.quarter_four_Achieved != 0 && record.quarter_Four_Target != null && record.quarter_Four_Target != 0)? Math.round((parseInt(record.quarter_four_Achieved) / parseInt(record.quarter_Four_Target) )*100) :0;
                        var directPercentage = (record.q4_direct_sales != null && record.q4_direct_sales != 0 && record.quarter_Four_Target != null && record.quarter_Four_Target != 0)? Math.round((parseInt(record.q4_direct_sales) / parseInt(record.quarter_Four_Target) )*100) :0;
                        var IndirectPercentage = (record.q4_indirect_sales != null && record.q4_indirect_sales != 0 && record.quarter_Four_Target != null && record.quarter_Four_Target != 0)? Math.round((parseInt(record.q4_indirect_sales) / parseInt(record.quarter_Four_Target) )*100) :0;
                        var percentToPixel = (percent> 100) ? ( Math.round((percent/100)* 340)) : Math.round((percent/100)* 340);
                        if(directPercentage > IndirectPercentage){
                            var directToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        else{
                            var directToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        return {
                            Name: record.salesRepName,
                            Achieved: formattedRevenue,
                            Target : formattedTarget,
                            serialNumber : serialNumber++,
                            percentage : percent,
                            directSales : directPercentage,
                            inDirectSales: IndirectPercentage,
                            totalPixel : percentToPixel,
                            directPixel : directToPixel,
                            indirectPixel : indirectToPixel
                        };
                    });
                    customFieldList.sort(function(a, b) {
                        return b.percentage - a.percentage;
                    });
                    component.set("v.WestSalesRepData",customFieldList);
                }
                helper.getEastSalesData(component, event, helper,fiscalYear); 
                
            }else{
                console.log("Error "+JSON.stringify(response.getError()));
                
            }
        });
        $A.enqueueAction(west);
        
    },
    
    getEastSalesData : function(component, event, helper,fiscalYear){
        
        var east = component.get("c.getEastDirectIndirectSalesList");
        var selectedValue = component.get("v.selectedValue");
        console.log('selectedValue is ==> '+selectedValue);
        east.setParams({
        });
        east.setCallback(this, function(response) {
            if(response.getState()=="SUCCESS"){
                if(selectedValue === 'FY '+ fiscalYear+ ' Annual')
                {
                    component.set("v.Heading",selectedValue);
                    console.log('East sales data with total data is ---> '+JSON.stringify(response.getReturnValue()));
                    var serialNumber = 1;
                    var customFieldList = response.getReturnValue().slice(0, 6).map(function(record) {
                        var formattedRevenue = helper.formatRevenue(record.annual_Achieved);
                        var formattedTarget = helper.formatRevenue(record.annual_Target);
                        var percent = (record.annual_Achieved != null && record.annual_Achieved != 0 && record.annual_Target != null && record.annual_Target != 0)? Math.round((parseInt(record.annual_Achieved) / parseInt(record.annual_Target) )*100) :0;
                        var directPercentage = (record.annual_directSales != null && record.annual_directSales != 0 && record.annual_Target != null && record.annual_Target !=0)? Math.round((parseInt(record.annual_directSales) / parseInt(record.annual_Target) )*100) :0;
                        var IndirectPercentage = (record.annual_indirectSales != null && record.annual_indirectSales != 0 && record.annual_Target != null && record.annual_Target !=0)? Math.round((parseInt(record.annual_indirectSales) / parseInt(record.annual_Target) )*100) :0;
                        var percentToPixel = (percent> 100) ? (Math.round((percent/100)* 340)) : Math.round((percent/100)* 340);
                        if(directPercentage > IndirectPercentage){
                            var directToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        else{
                            var directToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        //console.log(formattedRevenue);
                        return {
                            Name: record.salesRepName,
                            Achieved: formattedRevenue,
                            Target : formattedTarget,
                            serialNumber : serialNumber++,
                            percentage : percent,
                            directSales : directPercentage,
                            inDirectSales: IndirectPercentage,
                            totalPixel : percentToPixel,
                            directPixel : directToPixel,
                            indirectPixel : indirectToPixel
                            
                        };
                    });
                    customFieldList.sort(function(a, b) {
                        return b.percentage - a.percentage;
                    });
                    console.log('updated east pixels is : '+JSON.stringify(customFieldList));
                    component.set("v.EastSalesRepData",customFieldList);
                    console.log('East sales data with percentage is ---> '+JSON.stringify(customFieldList));
                }
                if(selectedValue === 'FY ' +fiscalYear+ ' Quarter 1')
                {
                    component.set("v.Heading",selectedValue);
                    var serialNumber = 1;
                    var customFieldList = response.getReturnValue().slice(0, 6).map(function(record) {
                        var formattedRevenue = helper.formatRevenue(record.quarter_one_Achieved);
                        var formattedTarget = helper.formatRevenue(record.quarter_one_Target);
                        var percent = (record.quarter_one_Achieved != null && record.quarter_one_Achieved != 0 && record.quarter_one_Target != null && record.quarter_one_Target != 0)? Math.round((parseInt(record.quarter_one_Achieved) / parseInt(record.quarter_one_Target) )*100) :0;
                        var directPercentage = (record.q1_direct_sales != null && record.q1_direct_sales != 0 && record.quarter_one_Target != null && record.quarter_one_Target != 0)? Math.round((parseInt(record.q1_direct_sales) / parseInt(record.quarter_one_Target) )*100) :0;
                        var IndirectPercentage = (record.q1_indirect_sales != null && record.q1_indirect_sales != 0 &&  record.quarter_one_Target != null && record.quarter_one_Target != 0)? Math.round((parseInt(record.q1_indirect_sales) / parseInt(record.quarter_one_Target) )*100) :0;
                        var percentToPixel = (percent> 100) ? (Math.round((percent/100)* 340)) : Math.round((percent/100)* 340);
                        if(directPercentage > IndirectPercentage){
                            var directToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        else{
                            var directToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        return {
                            Name: record.salesRepName,
                            Achieved: formattedRevenue,
                            Target : formattedTarget,
                            serialNumber : serialNumber++,
                            percentage : percent,
                            directSales : directPercentage,
                            inDirectSales: IndirectPercentage,
                            totalPixel : percentToPixel,
                            directPixel : directToPixel,
                            indirectPixel : indirectToPixel
                        };
                    });
                    customFieldList.sort(function(a, b) {
                        return b.percentage - a.percentage;
                    });
                    component.set("v.EastSalesRepData",customFieldList);
                    console.log('percentage in quarter 1 is ---> '+JSON.stringify(customFieldList));
                }
                
                if(selectedValue === 'FY ' +fiscalYear+ ' Quarter 2')
                {
                    component.set("v.Heading",selectedValue);
                    var serialNumber = 1;
                    var customFieldList = response.getReturnValue().slice(0, 6).map(function(record) {
                        var formattedRevenue = helper.formatRevenue(record.quarter_two_Achieved);
                        var formattedTarget = helper.formatRevenue(record.quarter_Two_Target);
                        var percent = (record.quarter_two_Achieved != null && record.quarter_two_Achieved != 0 && record.quarter_Two_Target != null && record.quarter_Two_Target != 0)? Math.round((parseInt(record.quarter_two_Achieved) / parseInt(record.quarter_Two_Target) )*100) :0;
                        var directPercentage = (record.q2_direct_sales != null && record.q2_direct_sales != 0 && record.quarter_Two_Target != null && record.quarter_Two_Target != 0)? Math.round((parseInt(record.q2_direct_sales) / parseInt(record.quarter_Two_Target) )*100) :0;
                        var IndirectPercentage = (record.q2_indirect_sales != null && record.q2_indirect_sales != 0 && record.quarter_Two_Target != null && record.quarter_Two_Target != 0)? Math.round((parseInt(record.q2_indirect_sales) / parseInt(record.quarter_Two_Target) )*100) :0;
                        var percentToPixel = (percent> 100) ? ( Math.round((percent/100)* 340)) : Math.round((percent/100)* 340);
                        if(directPercentage > IndirectPercentage){
                            var directToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        else{
                            var directToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        return {
                            Name: record.salesRepName,
                            Achieved: formattedRevenue,
                            Target : formattedTarget,
                            serialNumber : serialNumber++,
                            percentage : percent,
                            directSales : directPercentage,
                            inDirectSales: IndirectPercentage,
                            totalPixel : percentToPixel,
                            directPixel : directToPixel,
                            indirectPixel : indirectToPixel
                        };
                    });
                    customFieldList.sort(function(a, b) {
                        return b.percentage - a.percentage;
                    });
                    component.set("v.EastSalesRepData",customFieldList);
                }
                
                if(selectedValue === 'FY ' +fiscalYear+ ' Quarter 3')
                {
                    component.set("v.Heading",selectedValue);
                    var serialNumber = 1;
                    var customFieldList = response.getReturnValue().slice(0, 6).map(function(record) {
                        var formattedRevenue = helper.formatRevenue(record.quarter_three_Achieved);
                        var formattedTarget = helper.formatRevenue(record.quarter_Three_Target);
                        var percent = (record.quarter_three_Achieved != null && record.quarter_three_Achieved != 0 && record.quarter_Three_Target != null && record.quarter_Three_Target !=0 )? Math.round((parseInt(record.quarter_three_Achieved) / parseInt(record.quarter_Three_Target) )*100) :0;
                        var directPercentage = (record.q3_direct_sales != null && record.q3_direct_sales != 0 && record.quarter_Three_Target != null && record.quarter_Three_Target !=0 )? Math.round((parseInt(record.q3_direct_sales) / parseInt(record.quarter_Three_Target) )*100) :0;
                        var IndirectPercentage = (record.q3_indirect_sales != null && record.q3_indirect_sales != 0 && record.quarter_Three_Target != null && record.quarter_Three_Target !=0 )? Math.round((parseInt(record.q3_indirect_sales) / parseInt(record.quarter_Three_Target) )*100) :0;
                        var percentToPixel = (percent> 100) ? ( Math.round((percent/100)* 340)) : Math.round((percent/100)* 340);
                        if(directPercentage > IndirectPercentage){
                            var directToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        else{
                            var directToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        return {
                            Name: record.salesRepName,
                            Achieved: formattedRevenue,
                            Target : formattedTarget,
                            serialNumber : serialNumber++,
                            percentage : percent,
                            directSales : directPercentage,
                            inDirectSales: IndirectPercentage,
                            totalPixel : percentToPixel,
                            directPixel : directToPixel,
                            indirectPixel : indirectToPixel
                        };
                    });
                    customFieldList.sort(function(a, b) {
                        return b.percentage - a.percentage;
                    });
                    component.set("v.EastSalesRepData",customFieldList);
                }
                
                if(selectedValue == 'FY ' +fiscalYear+ ' Quarter 4')
                {
                    component.set("v.Heading",selectedValue);
                    var serialNumber = 1;
                    var customFieldList = response.getReturnValue().slice(0, 6).map(function(record) {
                        var formattedRevenue = helper.formatRevenue(record.quarter_four_Achieved);
                        var formattedTarget = helper.formatRevenue(record.quarter_Four_Target);
                        var percent = (record.quarter_four_Achieved != null && record.quarter_four_Achieved != 0 && record.quarter_Four_Target != null && record.quarter_Four_Target !=0) ? Math.round((parseInt(record.quarter_four_Achieved) / parseInt(record.quarter_Four_Target) )*100) :0;
                        var directPercentage = (record.q4_direct_sales != null && record.q4_direct_sales != 0 && record.quarter_Four_Target != null && record.quarter_Four_Target !=0)? Math.round((parseInt(record.q4_direct_sales) / parseInt(record.quarter_Four_Target) )*100) :0;
                        var IndirectPercentage = (record.q4_indirect_sales != null && record.q4_indirect_sales != 0  && record.quarter_Four_Target != null && record.quarter_Four_Target !=0 )? Math.round((parseInt(record.q4_indirect_sales) / parseInt(record.quarter_Four_Target) )*100) :0;
                        var percentToPixel = (percent> 100) ? (Math.round((percent/100)* 340)) : Math.round((percent/100)* 340);
                        if(directPercentage > IndirectPercentage){
                            var directToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        else{
                            var directToPixel = (percent> 120) ? ( Math.round((45/100)* 340)) : Math.round((directPercentage/100)* 340);
                            var indirectToPixel = (percent> 120) ? ( Math.round((65/100)* 340)) : Math.round((IndirectPercentage/100)* 340);
                        }
                        return {
                            Name: record.salesRepName,
                            Achieved: formattedRevenue,
                            Target : formattedTarget,
                            serialNumber : serialNumber++,
                            percentage : percent,
                            directSales : directPercentage,
                            inDirectSales: IndirectPercentage,
                            totalPixel : percentToPixel,
                            directPixel : directToPixel,
                            indirectPixel : indirectToPixel
                        };
                    });
                    customFieldList.sort(function(a, b) {
                        return b.percentage - a.percentage;
                    });
                    component.set("v.EastSalesRepData",customFieldList);
                }
                helper.getNationalData(component, event, helper);
                
            }else{
                console.log("Error "+JSON.stringify(response.getError()));
                
            }
        });
        $A.enqueueAction(east);
        
    },
    
    
    
    getNationalData : function(component, event, helper){
        
        var nationalList = [];
        //nationalList.push(component.get("v.WestSalesRepData"));
        //nationalList.push(component.get("v.EastSalesRepData"));
        //nationalList = component.get("v.WestSalesRepData").concat(component.get("v.EastSalesRepData"));        
        var EastList = component.get("v.EastSalesRepData");
        var WestList = component.get("v.WestSalesRepData");
        
        EastList.sort(function(a, b) {
            return b.percentage - a.percentage;
        });
        
        WestList.sort(function(a, b) {
            return b.percentage - a.percentage;
        });
        
        for(var i=0;i<6;i++){
            nationalList.push(EastList[i]);
        }
        for(var i=0;i<6;i++){
            nationalList.push(WestList[i]);
        }
        nationalList.sort(function(a, b) {
            return b.percentage - a.percentage;
        });
        
        component.set("v.SalesRepData",nationalList.slice(0,6));
        console.log('nationalList--->'+nationalList.length);
        const currentFiscalYear = helper.getCurrentFiscalYear();
        console.log('fiscal dynamic is --> '+currentFiscalYear.toString().slice(-2));
        
    },
    
    getExcludedSalesrepData:function(component, event, helper){
        var data = component.get("c.getExcludedSalesrepTargetData");
        data.setParams({
        });
        data.setCallback(this, function(response) {
            if(response.getState()=="SUCCESS"){
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
                component.set("v.excludedSalesRepData",customFieldList);
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
    
    
    showVisionUpdateDate : function(component, event, helper){
        
        var data = component.get("c.getVisionUpdateDate");
        data.setParams({
        });
        data.setCallback(this, function(response) {
            if(response.getState()=="SUCCESS"){
                var Visiondate = response.getReturnValue();
                console.log('date is ----> '+Visiondate);
                component.set('v.Visiondate',Visiondate);

            }else{
                console.log('error');
            }
        });
        $A.enqueueAction(data);
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
    
    getQ2Data : function(component, event, helper){
        
    },
    getQ3Data : function(component, event, helper){
        
    },
    getQ4Data : function(component, event, helper){
        
    }
    
})