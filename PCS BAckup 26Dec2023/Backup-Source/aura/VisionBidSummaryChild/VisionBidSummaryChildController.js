({
    mouseOver: function(component, event, helper){
        component.set("v.showTooltip", true);
        console.log('Hover');
        var record = component.get("v.record");
        console.log('Record: '+JSON.stringify(record));
        var isBidBusinessAnalysis = component.get("v.isBidBusinessAnalysis");
        console.log('isBidBusinessAnalysis: '+isBidBusinessAnalysis);
        if(isBidBusinessAnalysis){
            var index = component.get("v.index");
            console.log('Index: '+index);
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
            console.log('Top: '+top);
        }
    },
    mouseOut: function(component, event, helper){
      	component.set("v.showTooltip", false);
        console.log('Hover out');
    },
    showDropDown : function(component, event, helper) {
        var record = component.get("v.record");
        console.log('Record:::: '+JSON.stringify(record));
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
    doInit: function(component, event, helper){
        var category = component.get("v.category");
        if(category == 'Business Lost'){
            var record = component.get("v.record");
            console.log('Record: '+JSON.stringify(record));
            var totalAnnualImpact = 0;
            var totalBusinessImpact = 0;
            var totalPrice = 0;
            var totalQty = 0;
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
                /*if(record[1][i].previousIndirectPrice != null)
                    totalPrice += record[1][i].previousIndirectPrice;
                else
                    totalPrice += 0;*/
            }
            obj.totalAnnualImpact = totalAnnualImpact;
            obj.totalBusinessImpact = totalBusinessImpact;
            //obj.totalPrice = totalPrice;
            obj.totalQty = totalQty;
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
            var record = component.get("v.record");
            var tptVariance = (record.currentTPT - record.previousTPT) / record.previousTPT;
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
            record.tptVariance = tptVariance;
            if(record.businessCategory == 'Open Status' || record.businessCategory == 'No Effect'){
                record.currentTPTTitle = '(Proposed Quantity * Proposed Deadnet)-(Throughput Cost * Proposed Quantity)';
                record.previousTPTTitle = '(Previous Quantity * Previous Deadnet)-(Throughput Cost * Previous Quantity)';
                record.currentTPTPercentTitle = 'Proposed TPT/(Proposed Deadnet * Proposed Quantity)';
                record.previousTPTPercentTitle = 'Previous TPT/(Previous Deadnet * Previous Quantity)';
                record.priceVarianceTitle = 'If(Previous Quantity > 0, ((Proposed Deadnet - Previous Deadnet) * Proposed Quantity), 0)';
                record.volumeVarianceTitle = 'If(Previous Quantity > 0, ((Proposed Quantity - Previous Quantity) * Previous Deadnet), If(Proposed Quantity > 0, (Proposed Quantity * Proposed Deadnet), 0))';
                //record.volumeVarianceTitle = '(Proposed Quantity - Previous Quantity) * Proposed Deadnet';
                record.totalTitle = 'Proposed Contract Total - Previous Contract Total';
                record.tptVarianceTitle = 'Proposed TPT($) - Previous TPT($)';
            } else{
                record.currentTPTTitle = '(Awarded Quantity * Current Deadnet)-(Throughput Cost * Awarded Quantity)';
                record.previousTPTTitle = '(Previous Quantity * Previous Deadnet)-(Throughput Cost * Previous Quantity)';
                record.currentTPTPercentTitle = 'Current TPT/(Current Deadnet * Awarded Quantity)';
                record.previousTPTPercentTitle = 'Previous TPT/(Previous Deadnet * Previous Quantity)';
                record.priceVarianceTitle = 'If(Previous Quantity > 0, ((Current Deadnet - Previous Deadnet) * Awarded Quantity), 0)';
                record.volumeVarianceTitle = 'If(Previous Quantity > 0, ((Awarded Quantity - Previous Quantity) * Previous Deadnet), If(Awarded Quantity > 0, (Awarded Quantity * Current Deadnet), 0))';
                //record.volumeVarianceTitle = '(Awarded Quantity - Previous Quantity) * Current Deadnet';
                record.totalTitle = 'Current Contract Total - Previous Contract Total';
                record.tptVarianceTitle = 'Current TPT($) - Previous TPT($)';
            }
            /*if(record.businessCategory == 'Business Gained'){
                record.volumeVarianceTitle = 'Awarded Quantity * Current Deadnet';                
            }*/
        }
    },
})