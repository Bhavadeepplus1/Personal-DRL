({
	doInit : function(component, event, helper) {
        
        var opts = [
            { value: "Use User Input", label: "Use User Input" }, 
            { value: "Use Default Header", label: "Use Default Header", selected: true }, 
            { value: "Use Usage Data", label: "Use Usage Data" }];
        component.set("v.MktShareMethodList",opts);
        
        var walletopts = [
            { value: "Use User Input", label: "Use User Input" }, 
            { value: "Use Default Header", label: "Use Default Header", selected: true }];
        component.set("v.MktShareMethodWalletList",walletopts);
        
        var volopts = [
            { value: "Use User Input", label: "Use User Input"}, 
            { value: "Use Proposed Total Selling Units (BRIGHT)", label: "Use Proposed Total Selling Units (BRIGHT)"}, 
            { value: "Use Calculation of Est Acct Mkt Share", label: "Use Calculation of Est Acct Mkt Share", selected: true }
        ];
        if(component.get("v.accObj.Name") == 'Red Oak Sourcing'){
            var rosNewItem = {value: "Use Sum of all SKUs estimate volume", label: "Use Sum of all SKUs estimate volume"};
            volopts.push(rosNewItem);
        }
        component.set("v.MktShareVolumeList",volopts);
        
        
        var priceopts = [
            { value: "Use User Input", label: "Use User Input" }, 
            { value: "Use Lowest Price", label: "Use Lowest Price", selected: true }, 
            { value : "Marketing (Panorama) suggested Price", label : "Marketing (Panorama) suggested Price"},
            { value : "DRL Customer Actuals Average Price", label : "DRL Customer Actuals Average Price"}];
            //{ value: "Use GCP Suggested Price", label: "Use GCP Suggested Price" }];
        component.set("v.MktSharePriceList",priceopts);
        
		var gcpLineItem = component.get("v.gcpLineItem");
        component.set("v.estAcctMktShareUserInput",gcpLineItem.Phoenix_Est_Acct_Mkt_Share_User_Input__c);
        component.set("v.estAcctMktShareOfWalletUserInput",gcpLineItem.Phoenix_Est_AcctShareofWalletUserInput__c);
        component.set("v.estAcctVolInput",gcpLineItem.Phoenix_Est_Acct_Vol_EU_User_Input__c);
        component.set("v.estAcctPriceUserInput",gcpLineItem.Phoenix_Est_Acct_Price_EU_User_Input__c);
        //component.set("v.estAcctMktShareValue",gcpLineItem.Phoenix_Estimate_Account_Marketing_Share__c * gcpLineItem.Phoenix_Total_Market_Vol_MAT_EU__c);
        var estAcctMktShareValue = (gcpLineItem.Phoenix_Total_Market_Vol_MAT_EU__c != undefined && gcpLineItem.Phoenix_Total_Market_Vol_MAT_EU__c > 0) ? 
            (gcpLineItem.Phoenix_Est_Acct_Vol_EU_BRIGHT__c != undefined ? gcpLineItem.Phoenix_Est_Acct_Vol_EU_BRIGHT__c : 0)/(gcpLineItem.Phoenix_Total_Market_Vol_MAT_EU__c) : 0;//(gcpLineItem.Phoenix_Drl_Act_Sales__c) : 0;//
       
        component.set("v.estAcctMktShareValue",estAcctMktShareValue);
        var estAcctVolEstMktShare = (gcpLineItem.Phoenix_Estimate_Account_Marketing_Share__c/100) * gcpLineItem.Phoenix_Total_Market_Vol_MAT_EU__c;
        component.set("v.estAcctVolEstMktShare",estAcctVolEstMktShare);
        
        component.set("v.selectedInput",gcpLineItem.Phoenix_Est_Acct_Mkt_Share_Method__c != undefined ? gcpLineItem.Phoenix_Est_Acct_Mkt_Share_Method__c : 'Use Default Header');
        component.set("v.selectedWalletInput",gcpLineItem.Phoenix_Est_Acct_Share_of_Wallet_Method__c != undefined ? gcpLineItem.Phoenix_Est_Acct_Share_of_Wallet_Method__c : 'Use Default Header');
        component.set("v.selectedVolumeInput",gcpLineItem.Phoenix_Est_Acct_Vol_Method__c != undefined ? gcpLineItem.Phoenix_Est_Acct_Vol_Method__c : 'Use Proposed Total Selling Units (BRIGHT)');
        var actVal = Math.round((gcpLineItem.Phoenix_Est_Price_EU__c) * 100) / 100;
        var avgVal = Math.round((component.get("v.avgValue")) * 100) / 100;
        console.log('actVal :: '+actVal);
        console.log('avgVal :: '+avgVal);
        
        if(actVal == avgVal)
            component.set("v.selectedPriceInput",'DRL Customer Actuals Average Price');
        else
            component.set("v.selectedPriceInput",gcpLineItem.Phoenix_Est_Price_Method__c != undefined ? gcpLineItem.Phoenix_Est_Price_Method__c : 'Marketing (Panorama) suggested Price');
    },
    onMktMethodChange:function(component, event, helper) {
        console.log('component.get("v.selectedInput")' +component.get("v.selectedInput"));
        component.set("v.userInputName",'Est Acct Mkt Share');
        //component.set("v.warnUserInputChange",true);
	},
    onMktWalletChange:function(component, event, helper) {
        component.set("v.userInputName",'Est Acct Share of Wallet');
        //component.set("v.warnUserInputChange",true);
	},
    onMktVolumeChange:function(component, event, helper) {
        component.set("v.userInputName",'Est Acct Vol');
        //component.set("v.warnUserInputChange",true);
	},
    onMktPriceChange:function(component, event, helper) {
        component.set("v.userInputName",'Est Acct Price');
        //component.set("v.warnUserInputChange",true);
	},
    estAcctPriceUserInputChange : function(component, event, helper) {
        var currentRecord = component.get("v.gcpLineItem");
        currentRecord.Phoenix_Est_Acct_Price_EU_User_Input__c = component.get("v.estAcctPriceUserInput");
        component.set("v.gcpLineItem",currentRecord);
	},
    estAcctVolInputChange : function(component, event, helper) {
        var currentRecord = component.get("v.gcpLineItem");
        currentRecord.Phoenix_Est_Acct_Vol_EU_User_Input__c = component.get("v.estAcctVolInput");
        component.set("v.gcpLineItem",currentRecord);
	},
    estAcctMktShareOfWalletUserInputChange : function(component, event, helper) {
        var currentRecord = component.get("v.gcpLineItem");
        currentRecord.Phoenix_Est_AcctShareofWalletUserInput__c = component.get("v.estAcctMktShareOfWalletUserInput");
        component.set("v.gcpLineItem",currentRecord);
	},
    estAcctMktShareUserInputChange : function(component, event, helper) {
        var currentRecord = component.get("v.gcpLineItem");
        currentRecord.Phoenix_Est_Acct_Mkt_Share_User_Input__c = component.get("v.estAcctMktShareUserInput");
        component.set("v.gcpLineItem",currentRecord);
	},
    onSaveLineItem:function(component, event, helper) {
        var action = component.get("c.updateGcpLineItem");
        action.setParams({
            gcpLineItem : component.get("v.gcpLineItem")
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                component.set("v.showUserInputs",false);
                component.set("v.doRefresh",component.get("v.doRefresh")?false:true);
                //$A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },
    cancelChanges : function(component, event, helper){
        component.set("v.showUserInputs",false);
    },
    closeWarnUserInputChange : function(component, event, helper){
        var a = component.get('c.doInit');
        $A.enqueueAction(a);
        component.set("v.warnUserInputChange",false);
    },
    saveWarnUserInputChange : function(component, event, helper){
        var currentRecord = component.get("v.gcpLineItem"); 
        currentRecord.Phoenix_Est_Acct_Mkt_Share_Method__c = component.get("v.selectedInput");
        currentRecord.Phoenix_Est_Acct_Share_of_Wallet_Method__c = component.get("v.selectedWalletInput");
        currentRecord.Phoenix_Est_Acct_Vol_Method__c = component.get("v.selectedVolumeInput");
        currentRecord.Phoenix_Est_Price_Method__c = component.get("v.selectedPriceInput");
        component.set("v.gcpLineItem",currentRecord); 
        
        /*var currentRecord = component.get("v.gcpLineItem");
        var changedUserInput = component.get("v.userInputName");
        console.log('changedUserInput :: '+changedUserInput);
        if(changedUserInput == 'Est Acct Mkt Share')
            currentRecord.Phoenix_Est_Acct_Mkt_Share_Method__c = component.get("v.selectedInput");
        else if(changedUserInput == 'Est Acct Share of Wallet')
            currentRecord.Phoenix_Est_Acct_Share_of_Wallet_Method__c = component.get("v.selectedWalletInput");
            else if(changedUserInput == 'Est Acct Vol')
                currentRecord.Phoenix_Est_Acct_Vol_Method__c = component.get("v.selectedVolumeInput");
                else if(changedUserInput == 'Est Acct Price')
                    currentRecord.Phoenix_Est_Price_Method__c = component.get("v.selectedPriceInput");
        
        component.set("v.gcpLineItem",currentRecord);
        component.set("v.warnUserInputChange",false);*/
    },
})