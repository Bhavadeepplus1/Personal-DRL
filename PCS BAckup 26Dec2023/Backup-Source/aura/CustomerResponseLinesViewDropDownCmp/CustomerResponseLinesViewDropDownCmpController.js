({
    handleClick1: function(component, event, helper){
        var records = component.get("v.record[1]");
        component.set("v.record.showItem", true);
        component.set("v.expandFamily", true);
    },
    handleClick2: function(component, event, helper){
        component.set("v.record.showItem", false);
        component.set("v.expandFamily", false);
    },

    mouseOver: function(component, event, helper){
        component.set("v.showTooltip", true);
        var record = component.get("v.record");
        var isBidBusinessAnalysis = component.get("v.isBidBusinessAnalysis");
        if(isBidBusinessAnalysis){
            var index = component.get("v.index");
            var top = component.get("v.top");
            var size = component.get("v.size");
            if(index > 5 && (index == size || index == (size-1) || index == (size-2) || index == (size-3) || index == (size-4))){
                console.log('Last row: '+size);
                top = '-130px;';
                component.set("v.isLastRows", true);
            } else if(index == 1){
                top = '-50.5px;';
            } else if(index == 2){
                top = '-79px;';
            } else if(index == 3){
                top = '-107.5px;';
            } else if(index == 4){
                top = '-136px;';
            } else if(index == 5){
                top = '-164.5px;';
            }
            component.set("v.top", top);
        }
    },
    mouseOut: function(component, event, helper){
      	component.set("v.showTooltip", false);
        console.log('Hover out');
    },
    doInit: function(component, event, helper){
        var category = component.get("v.category");
        var summary = component.get("v.familySummaryMap");
        var record = component.get("v.record[0]");
        if(summary != null){
         	component.set("v.summaryList", summary[record]); 
            console.log('Summary List: '+JSON.stringify(summary[record]));
        }
        if(category == 'Business Lost'){
            var record = component.get("v.record");
            console.log('Record Lost: '+JSON.stringify(record));
            var totalAnnualImpact = 0;
            var totalBusinessImpact = 0;
            var totalPrice = 0;
            var totalQty = 0;
            var totalPreviousTotal = 0;
            var obj ={};
            for(var i=0; i<record[1].length; i++){
                if(record[1][i].annualImpact != null)
                    totalAnnualImpact += record[1][i].annualImpact;
                else
                    totalAnnualImpact += 0;
                if(record[1][i].businessImpact != null)
                    totalBusinessImpact += record[1][i].businessImpact;
                else
                    totalBusinessImpact += 0;
                if(record[1][i].previousQty != null)
                    totalQty += record[1][i].previousQty;
                else
                    totalQty += 0;
                if(record[1][i].previousContractTotal != null)
                    totalPreviousTotal += record[1][i].previousContractTotal;
                else
                    totalPreviousTotal += 0;
                /*if(record[1][i].previousIndirectPrice != null)
                    totalPrice += record[1][i].previousIndirectPrice;
                else
                    totalPrice += 0;*/
            }
            obj.totalAnnualImpact = totalAnnualImpact;
            obj.totalBusinessImpact = totalBusinessImpact;
            //obj.totalPrice = totalPrice;
            obj.totalQty = totalQty;
            obj.totalPreviousTotal = parseInt(totalPreviousTotal);
            component.set("v.summaryForLost", obj);   
            var record1 = component.get("v.record[1][0]");
            var formattedSubmittedDate;
            var formattedClosedDate;
            if(record1.bidRecord.Phoenix_Bid_Submitted_Date__c){
                formattedSubmittedDate = new Date(record1.bidRecord.Phoenix_Bid_Submitted_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
            }
            if(record1.bidRecord.Phoenix_Bid_Closed_Date__c){
                formattedClosedDate = new Date(record1.bidRecord.Phoenix_Bid_Closed_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
            }
            record1.formattedSubmittedDate = formattedSubmittedDate;
            record1.formattedClosedDate = formattedClosedDate;
        } else{
            console.log('Record: '+JSON.stringify(component.get("v.record[1]")));
            var record = component.get("v.record[1][0]");
            var formattedSubmittedDate;
            var formattedClosedDate;
            if(record.bidRecord.Phoenix_Bid_Submitted_Date__c){
                formattedSubmittedDate = new Date(record.bidRecord.Phoenix_Bid_Submitted_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
            }
            if(record.bidRecord.Phoenix_Bid_Closed_Date__c){
                formattedClosedDate = new Date(record.bidRecord.Phoenix_Bid_Closed_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
            }
            record.formattedSubmittedDate = formattedSubmittedDate;
            record.formattedClosedDate = formattedClosedDate;
        }
        var recordsToSort = component.get("v.record[1]");
        recordsToSort.sort(function(a, b) {
            return parseFloat(b.annualImpact) - parseFloat(a.annualImpact); 
        });
    },
    showDropDown : function(component, event, helper) {
        var record = component.get("v.record");
        var category = component.get("v.category");
        if(category == 'Business Lost'){
            if(record[1][0].showDropdown){
                record[1][0].showDropdown = false;
            } else{
                record[1][0].showDropdown = true;
            }   
        } else{
            if(record.showDropdown){
                record.showDropdown = false;
            } else{
                record.showDropdown = true;
            }
        }
        component.set("v.record", record);
    },
})