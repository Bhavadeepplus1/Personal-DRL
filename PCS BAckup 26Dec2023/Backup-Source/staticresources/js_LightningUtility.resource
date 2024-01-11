// js_LightningUtility

var drl = window.drl || drl || {};
window.drl = drl;

drl.lightning = {};

drl.lightning.ERROR = 'error';
drl.lightning.WARNING = 'warning';
drl.lightning.SUCCESS = 'success';
drl.lightning.INFO = 'info';

// Init a timeout variable to be used below
drl.lightning.timeout = null;

// Start a time to use for logging console messages with timer
drl.lightning.timerStart = performance.now();

drl.lightning.toggleSection = function(component, event){
    console.log("--js_LightningUtility:toggleSection()--");
    var button = event.getSource();
    var buttonLocalId = button.getLocalId();
    console.log('Button LocalId: ' + buttonLocalId);
    if (buttonLocalId != null) {
        var containerLocalId = buttonLocalId.replace("Button", "Container");
        console.log('Container LocalId: ' + containerLocalId);
        var container = component.find(containerLocalId);
        $A.util.toggleClass(container, "slds-is-open");
    }
};

drl.lightning.showToastMessage = function(component, messageData, lightningMode, toastMsgId, msgType, mode) {
   try{
       console.log("-----js_LightningUtility:showToast----messageData----------"+messageData);
       console.log("--is lightningMode-----"+lightningMode+"--msgType---"+msgType);
       if(msgType == undefined || msgType == ''){
           msgType = 'other';
       }
       var msgArray = [];
       if (Array.isArray(messageData)) {
           msgArray = messageData;
       } else {
           msgArray.push(messageData);
       }
       var msgContent = "";
       for(var i=0; i < msgArray.length ; i++){
           msgContent+= msgArray[i]+"\n";
       }
       if (!mode) {
           if (msgType == this.ERROR) {
               // Default errors to sticky
               mode = 'sticky';
           } else {
               mode = 'dismissable';
           }
       }
       if(lightningMode){
           var toastEvent = $A.get("e.force:showToast");
           toastEvent.setParams({
               type : ""+msgType,
               message : msgContent,
               mode: mode
           });
           toastEvent.fire();
       }else{
           if(toastMsgId!=null){
               console.log("-container id-"+toastMsgId);
               var msgContainer = component.find(toastMsgId);
               var msgThemeContainer = component.find(toastMsgId+"Theme");
               $A.util.removeClass(msgThemeContainer, 'slds-theme_error');
               $A.util.removeClass(msgThemeContainer, 'slds-theme_info');
               $A.util.removeClass(msgThemeContainer, 'slds-theme_success');
               $A.util.removeClass(msgThemeContainer, 'slds-theme_warning');
               $A.util.removeClass(msgThemeContainer, 'slds-theme_other');
               
               $A.util.addClass(msgThemeContainer, 'slds-theme_'+msgType);

               var toastMessageLocalId = toastMsgId.replace("Toast", "ToastMessage");
               component.find(toastMessageLocalId).set("v.value", msgContent);

               $A.util.addClass(msgContainer, 'slds-show');
               $A.util.removeClass(msgContainer, 'slds-hide');
           }
       }
   }catch(ex){
       drl.lightning.logException(ex);
   }
};

drl.lightning.hideToastMessage = function(component, event){
    console.log("--js_LightningUtility:hideToastMessage()--");
    var iconBtn = event.getSource();
    var iconBtnLocalId = iconBtn.getLocalId();
    console.log('Icon Button LocalId: ' + iconBtnLocalId);
    if (iconBtnLocalId != null) {
        var toastContainerLocalId = iconBtnLocalId.replace("ToastIcon", "Toast");
        var container = component.find(toastContainerLocalId);
        
        var toastMessageLocalId = iconBtnLocalId.replace("ToastIcon", "ToastMessage");
        component.find(toastMessageLocalId).set("v.value", "");
        
        $A.util.addClass(container, "slds-hide");
    }
};

drl.lightning.handleShowSpinnerChange = function(component, event){
    var showValue = component.get('v.showSpinner');
    var spinner = component.find("spinner");
    drl.lightning.consoleLog("handleShowSpinnerChange()", showValue, spinner);

    if(showValue) {
        $A.util.removeClass(spinner, "slds-hide");
    } else {
        $A.util.addClass(spinner, "slds-hide");
    }
};

drl.lightning.getElementsArray = function(component, auraId) {
    console.log("---js_LightningUtility:getElementsArray()----");
    var returnArray = [];
    if (component != null) {
        var findResult = component.find(auraId);
        if (findResult != null) {
            if (Array.isArray(findResult)) {
                returnArray = findResult;
            } else {
                returnArray.push(findResult);
            }
        }
    }
    return returnArray;
};

drl.lightning.showProgressLoading = function(component){
    console.log("js_LightningUtility:showProgressLoading()");
    var searchLoadingContainer = component.find("progressLoading");
    if(searchLoadingContainer.isValid()){
		$A.util.addClass(searchLoadingContainer, 'slds-show');
    	$A.util.removeClass(searchLoadingContainer, 'slds-hide');        
    }
};

drl.lightning.hideProgressLoading = function(component){
    console.log("js_LightningUtility:hideProgressLoading()");
    var searchLoadingContainer = component.find("progressLoading");
    if(searchLoadingContainer.isValid()){
		$A.util.addClass(searchLoadingContainer, 'slds-hide');
        $A.util.removeClass(searchLoadingContainer, 'slds-show');        
    }
};

//@param: component : lightning component
//@param: toSObject : SObject API Name like Account, Custom_Object__c
//@param: sObjectRecordId : SObject record Id
drl.lightning.navigateToRecord = function(component, toSObject, sObjectRecordId) {
    console.log("js_LightningUtility:navigateToRecord()");
    
    console.log('-------sObjectRecordId---'+sObjectRecordId);    
    if (sObjectRecordId) {
        console.log("Go to record Id "+sObjectRecordId); 
        var action = $A.get("e.force:navigateToSObject");
        action.setParams({
            "recordId": sObjectRecordId,
            "sObjectRecordId" : sObjectRecordId
        });
        action.fire();
        setTimeout(function(){
            $A.get('e.force:refreshView').fire();
        }, 500);
    } else {
        console.log("Go to Home "+sObjectRecordId);
        var action = $A.get("e.force:navigateToObjectHome");
        action.setParams({
            "scope" : ""+toSObject
        });
        action.fire();
        $A.get("e.force:refreshView").fire();
    }
}

drl.lightning.formatCurrency = function(amount, decimalCount = 2, currency="$", decimal = ".", thousands = ",") {
    try {
        decimalCount = Math.abs(decimalCount);
        decimalCount = isNaN(decimalCount) ? 2 : decimalCount;

        const negativeSign = amount < 0 ? "-" : "";

        let i = parseInt(amount = Math.abs(Number(amount) || 0).toFixed(decimalCount)).toString();
        let j = (i.length > 3) ? i.length % 3 : 0;

        return negativeSign + currency + (j ? i.substr(0, j) + thousands : '') + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + thousands) + (decimalCount ? decimal + Math.abs(amount - i).toFixed(decimalCount).slice(2) : "");
    } catch (ex) {
        drl.lightning.logException(ex);
    }
};

drl.lightning.formatInteger = function(amount, thousands = ",") {
    return drl.lightning.formatCurrency(amount, 0, "", ".", thousands);
}

drl.lightning.formatNumber = function(amount, decimalCount = 2, thousands = ",") {
    return drl.lightning.formatCurrency(amount, decimalCount, "", ".", thousands);
}

drl.lightning.formatPercent = function(amount, decimalCount = 2, thousands = ",") {
    return drl.lightning.formatCurrency(amount, decimalCount, "", ".", thousands) + '%';
}

drl.lightning.compareOptions = function(a, b) {
    console.log("---compareOptions()---");
    var compare = -1;
    if (a != null && a.label != null) {
        compare = a.label.localeCompare(b.label);
    }
    return compare;
};

drl.lightning.sendSocialCodeApplicationEvent = function(type, value, message, data) {
    console.log("---drl.lightning.sendSocialCodeApplicationEvent()----" + type + "---" + value + "---" + message + "---" + data);
    try {
        var applicationEvent = $A.get("e.c:SocialCodeApplicationEvent");
        applicationEvent.setParams({
            type : type,
            value : value,
            message : message,
            data : data
        });
        applicationEvent.fire();
    } catch (ex) {
        drl.lightning.logException(ex);
    }
}

drl.lightning.resetTimer = function() {
    drl.lightning.timerStart = performance.now();
    drl.lightning.consoleLog("Timer Reset");
}

drl.lightning.consoleLog = function() {
    let consoleLog = '';
    for (let i=0; i < arguments.length; i++) {
        consoleLog += " --- " + arguments[i];
    }
    let timerEnd = performance.now();
    consoleLog += " --- " + Math.trunc(timerEnd - drl.lightning.timerStart) + " ms";
    console.log(consoleLog);
}

drl.lightning.logException = function(ex) {
    console.log("%c-----------EXCEPTION-----------", "background-color:red;color:white;");
    console.log(ex);
}

