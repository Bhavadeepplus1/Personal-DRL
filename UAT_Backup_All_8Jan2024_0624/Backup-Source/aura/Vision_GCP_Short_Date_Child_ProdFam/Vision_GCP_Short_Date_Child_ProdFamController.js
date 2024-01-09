({
    doInit : function(component, event, helper) {
        var data = component.get("v.accGroupList");
        var totalInUnits3Mon =0;
        var totalDollar3Mon =0;
        var currentMonthOrder3Mon=0;
        var writeOffQty3Mon=0;
        var writeOffDollar3Mon=0;
        var LastMonthWriteOffQty3Mon=0;
        var LastMonthWriteOffDollar3Mon=0;
        var shortDate13Mon =0;
        var potentialWriteOff13Mon = 0;
        var writeOff13Mon =0;
        var shortDate23Mon =0;
        var potentialWriteOff23Mon = 0;
        var writeOff23Mon =0;
        var shortDate33Mon =0;
        var potentialWriteOff33Mon = 0;
        var writeOff33Mon =0;
        
        var totalInUnits =0;
        var totalDollar =0;
        var currentMonthOrder9Mon=0;
        var writeOffQty9Mon=0;
        var writeOffDollar9Mon=0;
         var LastMonthWriteOffQty9Mon=0;
        var LastMonthWriteOffDollar9Mon=0;
        var shortDate1 =0;
        var potentialWriteOff1 = 0;
        var writeOff1 =0;
        var shortDate2 =0;
        var potentialWriteOff2 = 0;
        var writeOff2 =0;
        var shortDate3 =0;
        var potentialWriteOff3 = 0;
        var writeOff3 =0;
        var shortDate4 =0;
        var potentialWriteOff4 = 0;
        var writeOff4 =0;
        var shortDate5 =0;
        var potentialWriteOff5 = 0;
        var writeOff5 =0;
        var shortDate6 =0;
        var potentialWriteOff6 = 0;
        var writeOff6 =0;
        var shortDate7 =0;
        var potentialWriteOff7 = 0;
        var writeOff7 =0;
        var shortDate8 =0;
        var potentialWriteOff8 = 0;
        var writeOff8 =0;
        var shortDate9 =0;
        var potentialWriteOff9 = 0;
        var writeOff9 =0;
        var totalInUnitsrecord =0;
        var totalInValuerecord =0;
        //  console.log('isPWO---',isPWO);
        //  data.productFamily.forEach(function(item){
        data.sdpfist.forEach(function(pf){ 
            
            totalInValuerecord +=  parseFloat(pf.Vision_M1_Write_Off_Cost__c!= undefined ? pf.Vision_M1_Write_Off_Cost__c: 0)+parseFloat(pf.Vision_M2_Write_Off_Cost__c!= undefined ? pf.Vision_M2_Write_Off_Cost__c: 0)+parseFloat(pf.Vision_M3_Write_Off_Cost__c!= undefined ? pf.Vision_M3_Write_Off_Cost__c: 0);
            totalInUnitsrecord +=  parseFloat(pf.Vision_M1_Potential_Write_Off__c!= undefined ? pf.Vision_M1_Potential_Write_Off__c: 0)+parseFloat(pf.Vision_M2_Potential_Write_Off__c!= undefined ? pf.Vision_M2_Potential_Write_Off__c: 0)+parseFloat(pf.Vision_M3_Potential_Write_Off__c!= undefined ? pf.Vision_M3_Potential_Write_Off__c: 0);
            if(pf.Vision_M1_Potential_Write_Off__c>0 || pf.Vision_M2_Potential_Write_Off__c>0 || pf.Vision_M3_Potential_Write_Off__c>0){
                totalInUnits3Mon += parseFloat(pf.Vision_M1_Potential_Write_Off__c!= undefined ? pf.Vision_M1_Potential_Write_Off__c: 0)+parseFloat(pf.Vision_M2_Potential_Write_Off__c!= undefined ? pf.Vision_M2_Potential_Write_Off__c: 0)+parseFloat(pf.Vision_M3_Potential_Write_Off__c!= undefined ? pf.Vision_M3_Potential_Write_Off__c: 0);
                totalDollar3Mon += parseFloat(pf.Vision_M1_Write_Off_Cost__c!= undefined ? pf.Vision_M1_Write_Off_Cost__c: 0)+parseFloat(pf.Vision_M2_Write_Off_Cost__c!= undefined ? pf.Vision_M2_Write_Off_Cost__c: 0)+parseFloat(pf.Vision_M3_Write_Off_Cost__c!= undefined ? pf.Vision_M3_Write_Off_Cost__c: 0);
                currentMonthOrder3Mon += parseFloat(pf.Vision_Current_Month_Order_Quantity__c!= undefined ? pf.Vision_Current_Month_Order_Quantity__c: 0);
                writeOffQty3Mon += parseFloat(pf.Vision_qty_written_off__c!= undefined ? pf.Vision_qty_written_off__c: 0);
                writeOffDollar3Mon += parseFloat(pf.Vision_Dollar_Writen_Off__c!= undefined ? pf.Vision_Dollar_Writen_Off__c: 0);
                LastMonthWriteOffQty3Mon += parseFloat(pf.Vision_Last_Month_Written_Off_QTY__c!= undefined ? pf.Vision_Last_Month_Written_Off_QTY__c: 0);
                LastMonthWriteOffDollar3Mon += parseFloat(pf.Last_Month_Written_Off_Cost__c!= undefined ? pf.Last_Month_Written_Off_Cost__c: 0);
                shortDate13Mon += parseFloat(pf.Vision_M1_Short_Date__c!= undefined ? pf.Vision_M1_Short_Date__c: 0);
                potentialWriteOff13Mon += parseFloat(pf.Vision_M1_Potential_Write_Off__c!= undefined ? pf.Vision_M1_Potential_Write_Off__c: 0);
                writeOff13Mon += parseFloat(pf.Vision_M1_Write_Off_Cost__c!= undefined ? pf.Vision_M1_Write_Off_Cost__c: 0);
                shortDate23Mon += parseFloat(pf.Vision_M2_Short_Date__c!= undefined ? pf.Vision_M2_Short_Date__c: 0);
                potentialWriteOff23Mon += parseFloat(pf.Vision_M2_Potential_Write_Off__c!= undefined ? pf.Vision_M2_Potential_Write_Off__c: 0);
                writeOff23Mon += parseFloat(pf.Vision_M2_Write_Off_Cost__c!= undefined ? pf.Vision_M2_Write_Off_Cost__c: 0);
                shortDate33Mon += parseFloat(pf.Vision_M3_Short_Date__c!= undefined ? pf.Vision_M3_Short_Date__c: 0);
                potentialWriteOff33Mon += parseFloat(pf.Vision_M3_Potential_Write_Off__c!= undefined ? pf.Vision_M3_Potential_Write_Off__c: 0);
                writeOff33Mon += parseFloat(pf.Vision_M3_Write_Off_Cost__c!= undefined ? pf.Vision_M3_Write_Off_Cost__c: 0);                    
            }                        
            if(pf.Vision_M1_Potential_Write_Off__c>0 || pf.Vision_M2_Potential_Write_Off__c>0 || pf.Vision_M3_Potential_Write_Off__c>0 || pf.Vision_M4_Potential_Write_Off__c>0 || pf.Vision_M5_Potential_Write_Off__c>0 || pf.Vision_M6_Potential_Write_Off__c>0 || pf.Vision_M7_Potential_Write_Off__c>0 || pf.Vision_M8_Potential_Write_Off__c>0 || pf.Vision_M9_Potential_Write_Off__c>0){
                totalInUnits += parseFloat(pf.Vision_Total_in_Units__c!= undefined ? pf.Vision_Total_in_Units__c: 0);
                totalDollar += parseFloat(pf.Vision_Total_value_dollar__c!= undefined ? pf.Vision_Total_value_dollar__c: 0);
                currentMonthOrder9Mon += parseFloat(pf.Vision_Current_Month_Order_Quantity__c!= undefined ? pf.Vision_Current_Month_Order_Quantity__c: 0);
                writeOffQty9Mon += parseFloat(pf.Vision_qty_written_off__c!= undefined ? pf.Vision_qty_written_off__c: 0);
                writeOffDollar9Mon += parseFloat(pf.Vision_Dollar_Writen_Off__c!= undefined ? pf.Vision_Dollar_Writen_Off__c: 0);
                LastMonthWriteOffQty9Mon += parseFloat(pf.Vision_Last_Month_Written_Off_QTY__c!= undefined ? pf.Vision_Last_Month_Written_Off_QTY__c: 0);
                LastMonthWriteOffDollar9Mon += parseFloat(pf.Last_Month_Written_Off_Cost__c!= undefined ? pf.Last_Month_Written_Off_Cost__c: 0);
                shortDate1 += parseFloat(pf.Vision_M1_Short_Date__c!= undefined ? pf.Vision_M1_Short_Date__c: 0);
                potentialWriteOff1 += parseFloat(pf.Vision_M1_Potential_Write_Off__c!= undefined ? pf.Vision_M1_Potential_Write_Off__c: 0);
                writeOff1 += parseFloat(pf.Vision_M1_Write_Off_Cost__c!= undefined ? pf.Vision_M1_Write_Off_Cost__c: 0);
                shortDate2 += parseFloat(pf.Vision_M2_Short_Date__c!= undefined ? pf.Vision_M2_Short_Date__c: 0);
                potentialWriteOff2 += parseFloat(pf.Vision_M2_Potential_Write_Off__c!= undefined ? pf.Vision_M2_Potential_Write_Off__c: 0);
                writeOff2 += parseFloat(pf.Vision_M2_Write_Off_Cost__c!= undefined ? pf.Vision_M2_Write_Off_Cost__c: 0);
                shortDate3 += parseFloat(pf.Vision_M3_Short_Date__c!= undefined ? pf.Vision_M3_Short_Date__c: 0);
                potentialWriteOff3 += parseFloat(pf.Vision_M3_Potential_Write_Off__c!= undefined ? pf.Vision_M3_Potential_Write_Off__c: 0);
                writeOff3 += parseFloat(pf.Vision_M3_Write_Off_Cost__c!= undefined ? pf.Vision_M3_Write_Off_Cost__c: 0);
                shortDate4 += parseFloat(pf.Vision_M4_Short_Date__c!= undefined ? pf.Vision_M4_Short_Date__c: 0);
                potentialWriteOff4 += parseFloat(pf.Vision_M4_Potential_Write_Off__c!= undefined ? pf.Vision_M4_Potential_Write_Off__c: 0);
                writeOff4 += parseFloat(pf.Vision_M4_Write_Off_Cost__c!= undefined ? pf.Vision_M4_Write_Off_Cost__c: 0);
                shortDate5 += parseFloat(pf.Vision_M5_Short_Date__c!= undefined ? pf.Vision_M5_Short_Date__c: 0);
                potentialWriteOff5 += parseFloat(pf.Vision_M5_Potential_Write_Off__c!= undefined ? pf.Vision_M5_Potential_Write_Off__c: 0);
                writeOff5 += parseFloat(pf.Vision_M5_Write_Off_Cost__c!= undefined ? pf.Vision_M5_Write_Off_Cost__c: 0);
                shortDate6 += parseFloat(pf.Vision_M6_Short_Date__c!= undefined ? pf.Vision_M6_Short_Date__c: 0);
                potentialWriteOff6 += parseFloat(pf.Vision_M6_Potential_Write_Off__c!= undefined ? pf.Vision_M6_Potential_Write_Off__c: 0);
                writeOff6 += parseFloat(pf.Vision_M6_Write_Off_Cost__c!= undefined ? pf.Vision_M6_Write_Off_Cost__c: 0);
                shortDate7 += parseFloat(pf.Vision_M7_Short_Date__c!= undefined ? pf.Vision_M7_Short_Date__c: 0);
                potentialWriteOff7 += parseFloat(pf.Vision_M7_Potential_Write_Off__c!= undefined ? pf.Vision_M7_Potential_Write_Off__c: 0);
                writeOff7 += parseFloat(pf.Vision_M7_Write_Off_Cost__c!= undefined ? pf.Vision_M7_Write_Off_Cost__c: 0);
                shortDate8 += parseFloat(pf.Vision_M8_Short_Date__c!= undefined ? pf.Vision_M8_Short_Date__c: 0);
                potentialWriteOff8 += parseFloat(pf.Vision_M8_Potential_Write_Off__c!= undefined ? pf.Vision_M8_Potential_Write_Off__c: 0);
                writeOff8 += parseFloat(pf.Vision_M8_Write_Off_Cost__c!= undefined ? pf.Vision_M8_Write_Off_Cost__c: 0);
                shortDate9 += parseFloat(pf.Vision_M9_Short_Date__c!= undefined ? pf.Vision_M9_Short_Date__c: 0);
                potentialWriteOff9 += parseFloat(pf.Vision_M9_Potential_Write_Off__c!= undefined ? pf.Vision_M9_Potential_Write_Off__c: 0);
                writeOff9 += parseFloat(pf.Vision_M9_Write_Off_Cost__c!= undefined ? pf.Vision_M9_Write_Off_Cost__c: 0);
            }
            
        });
        //   });
        console.log('shortDate1 prodfam child 2---',shortDate1);
        component.set("v.totalInUnitsrecord",totalInUnitsrecord);
        component.set("v.totalInValuerecord",totalInValuerecord);
        component.set("v.totalInUnits3Mon",totalInUnits3Mon);
        component.set("v.totalDollar3Mon",totalDollar3Mon);
        component.set("v.currentMonthOrder3Mon",currentMonthOrder3Mon);
        component.set("v.writeOffQty3Mon",writeOffQty3Mon);
        component.set("v.writeOffDollar3Mon",writeOffDollar3Mon);
        component.set("v.LastMonthWriteOffQty3Mon",LastMonthWriteOffQty3Mon);
        component.set("v.LastMonthWriteOffDollar3Mon",LastMonthWriteOffDollar3Mon);
        component.set("v.shortDate13Mon",shortDate13Mon);
        component.set("v.potentialWriteOff13Mon",potentialWriteOff13Mon);
        component.set("v.writeOff13Mon",writeOff13Mon);
        component.set("v.shortDate23Mon",shortDate23Mon);
        component.set("v.potentialWriteOff23Mon",potentialWriteOff23Mon);
        component.set("v.writeOff23Mon",writeOff23Mon);
        component.set("v.shortDate33Mon",shortDate33Mon);
        component.set("v.potentialWriteOff33Mon",potentialWriteOff33Mon);
        component.set("v.writeOff33Mon",writeOff33Mon);
        
        component.set("v.totalInUnits",totalInUnits);
        component.set("v.totalDollar",totalDollar);
        component.set("v.currentMonthOrder9Mon",currentMonthOrder9Mon);  
        component.set("v.writeOffQty9Mon",writeOffQty9Mon);  
        component.set("v.writeOffDollar9Mon",writeOffDollar9Mon);
        component.set("v.LastMonthWriteOffQty9Mon",LastMonthWriteOffQty9Mon);
        component.set("v.LastMonthWriteOffDollar9Mon",LastMonthWriteOffDollar9Mon);
        component.set("v.shortDate1",shortDate1);
        component.set("v.potentialWriteOff1",potentialWriteOff1);
        component.set("v.writeOff1",writeOff1);
        component.set("v.shortDate2",shortDate2);
        component.set("v.potentialWriteOff2",potentialWriteOff2);
        component.set("v.writeOff2",writeOff2);
        component.set("v.shortDate3",shortDate3);
        component.set("v.potentialWriteOff3",potentialWriteOff3);
        component.set("v.writeOff3",writeOff3);
        component.set("v.shortDate4",shortDate4);
        component.set("v.potentialWriteOff4",potentialWriteOff4);
        component.set("v.writeOff4",writeOff4);
        component.set("v.shortDate5",shortDate5);
        component.set("v.potentialWriteOff5",potentialWriteOff5);
        component.set("v.writeOff5",writeOff5);
        component.set("v.shortDate6",shortDate6);
        component.set("v.potentialWriteOff6",potentialWriteOff6);
        component.set("v.writeOff6",writeOff6);
        component.set("v.shortDate7",shortDate7);
        component.set("v.potentialWriteOff7",potentialWriteOff7);
        component.set("v.writeOff7",writeOff7);
        component.set("v.shortDate8",shortDate8);
        component.set("v.potentialWriteOff8",potentialWriteOff8);
        component.set("v.writeOff8",writeOff8);
        component.set("v.shortDate9",shortDate9);
        component.set("v.potentialWriteOff9",potentialWriteOff9);
        component.set("v.writeOff9",writeOff9);
        
        
    },
    handleClick1: function(component, event, helper){
        var pfName = event.getSource().get("v.name");
        console.log('pfName: '+pfName);
        var data = component.get("v.accGroupList");
        console.log('Data pfName:: '+JSON.stringify(data));
        if(data.pfName == pfName && data != undefined ){
            console.log('shoe pf')
            data.showProdFam = false;
            /*  for(var i=0; i<data.productFamily.length; i++){
                if(data.productFamily.showProdFam){
                 	data.productFamily.showProdFam = false;   
                } else{
                    data.productFamily.showProdFam = true;
                }
           }*/
        }
        component.set("v.accGroupList", data);
        component.set("v.show", false);
    },
    handleClick2: function(component, event, helper){
        var pfName = event.getSource().get("v.name");
        console.log('pfName: '+pfName);
        var data = component.get("v.accGroupList");
        console.log('Data pfName:: '+JSON.stringify(data));
        if(data.pfName == pfName && data != undefined ){
            console.log('shoe pf --')       
            data.showProdFam = true;
            
        }
        component.set("v.accGroupList", data);
        component.set("v.show", true);
    }, 
    scrollToM1: function(component, event, helper){
        var scrollOptions = {
            top: 0,
            left: 368,
            behavior: 'smooth'
        }       
        window.scrollBy(scrollOptions);          
    },
    scrollToM2: function(component, event, helper){
        var scrollOptions = {
            top: 0,
            left: 672,
            behavior: 'smooth'
        }       
        window.scrollBy(scrollOptions);          
    },
    scrollToM3: function(component, event, helper){
        var scrollOptions = {
            top: 0,
            left: 1010,
            behavior: 'smooth'
        }       
        window.scrollBy(scrollOptions);          
    },
    scrollToM4: function(component, event, helper){
        var scrollOptions = {
            top: 0,
            left: 1331,
            behavior: 'smooth'
        }       
        window.scrollBy(scrollOptions);          
    },
    scrollToM5: function(component, event, helper){
        var scrollOptions = {
            top: 0,
            left: 1652,
            behavior: 'smooth'
        }       
        window.scrollBy(scrollOptions);          
    },
    scrollToM6: function(component, event, helper){
        var scrollOptions = {
            top: 0,
            left: 1972,
            behavior: 'smooth'
        }       
        window.scrollBy(scrollOptions);          
    },
    scrollToM7: function(component, event, helper){
        var scrollOptions = {
            top: 0,
            left: 2293,
            behavior: 'smooth'
        }       
        window.scrollBy(scrollOptions);          
    },
    scrollToM8: function(component, event, helper){
        var scrollOptions = {
            top: 0,
            left: 2614,
            behavior: 'smooth'
        }       
        window.scrollBy(scrollOptions);          
    },
    scrollToM9: function(component, event, helper){
        var scrollOptions = {
            top: 0,
            left: 2934,
            behavior: 'smooth'
        }       
        window.scrollBy(scrollOptions);          
    },
})