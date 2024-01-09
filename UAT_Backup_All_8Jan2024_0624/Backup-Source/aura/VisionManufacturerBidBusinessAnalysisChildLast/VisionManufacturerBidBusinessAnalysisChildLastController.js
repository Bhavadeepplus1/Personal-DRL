({
	showDropDown : function(component, event, helper) {
        var record = component.get("v.record");
        component.set("v.record.showDropdown", !component.get("v.record.showDropdown"));
    },
    mouseOver: function(component, event, helper){
        component.set("v.record.showTooltip", true);
        console.log('Record: '+JSON.stringify(component.get("v.record")));
        var record = component.get("v.record");
        var index = component.get("v.index");
        var top = component.get("v.top");
        var size = component.get("v.size");
        if(index > 5 && (index == size || index == (size-1) || index == (size-2) || index == (size-3) || index == (size-4))){
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
        if(record.bidRecord.Phoenix_Bid_Submitted_Date__c){
            record.formattedSubmittedDate = new Date(record.bidRecord.Phoenix_Bid_Submitted_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
        }
        if(record.bidRecord.Phoenix_Bid_Closed_Date__c){
            record.formattedClosedDate = new Date(record.bidRecord.Phoenix_Bid_Closed_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
        }
        component.set("v.top", top);
    },
    mouseOut: function(component, event, helper){
      	component.set("v.record.showTooltip", false);
    },
})