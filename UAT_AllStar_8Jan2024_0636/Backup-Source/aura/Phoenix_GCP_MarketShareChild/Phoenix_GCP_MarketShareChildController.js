({
    
    doInit : function(component, event, helper) {
        if(component.get("v.indexVal")%2 == 0)
            component.set("v.showRowWhite",true);
        var gcpLineItem = component.get("v.gcpLineItem");
        var avgValue = 0;
        if(gcpLineItem.Phoenix_Cust_Act_Volume_Mat_Eu__c != undefined && gcpLineItem.Phoenix_Cust_Act_Volume_Mat_Eu__c > 0)
            avgValue = (gcpLineItem.Cust_Act_Sales_Mat__c != undefined ? gcpLineItem.Cust_Act_Sales_Mat__c : 0)/gcpLineItem.Phoenix_Cust_Act_Volume_Mat_Eu__c;
        
        component.set("v.avgValue",avgValue);
        function formatDate(forDate){
            var monthDigit = forDate.getMonth() + 1; 
            if (monthDigit <= 9) { monthDigit = '0' + monthDigit; } 
            var dayDigit = forDate.getDate(); 
            if(dayDigit <= 9){ dayDigit = '0' + dayDigit; } 
            var formattedDate = monthDigit + '/' + dayDigit+'/'+forDate.getFullYear();
            return formattedDate;
        }
        
        var prodListForExpansion = [];//['Capecitabine','Dimethyl Fumerate','Colchicine Tablets','Esomeprazole','Fondaparinux','Pantoprazole','Finasteride - 1MG','Testosterone Gel Pump','Ibuprofen Tabs DRLLC','Abiraterone Acetate Tab','Fenofibrate Tablets','Methylphenidate','Amlodipine Benazepril','Atomoxetine','Tacrolimus','Esomeprazole Naproxen'];
        
        //if(prodListForExpansion.includes(gcpLineItem.Phoenix_Product_Family__c)){
        //    component.set("v.showRedForExpan",true);
        //}
        function formatForTitle(forDate){
            var month = [];
            month[0] = "Jan";
            month[1] = "Feb";
            month[2] = "Mar";
            month[3] = "Apr";
            month[4] = "May";
            month[5] = "Jun";
            month[6] = "Jul";
            month[7] = "Aug";
            month[8] = "Sep";
            month[9] = "Oct";
            month[10] = "Nov";
            month[11] = "Dec";
            month[-1] = "Jan";
            var monthDigit = forDate.getMonth();
            var formattedDate = month[monthDigit] + ' ' +forDate.getDate() +' '+ forDate.getFullYear();
            return formattedDate;
        }
        
        component.set("v.coolingPeriodTitle",'');
        var coolingPeriodTitle = '';
        var today = new Date(); 
        var todayDate =  new Date(formatDate(today));
        
        var coolingPeriod = gcpLineItem.Phoenix_Cooling_Period__c != undefined ? gcpLineItem.Phoenix_Cooling_Period__c : 
        (component.get("v.accObj").Phoenix_Account_Cooling_Period__c!= undefined ? component.get("v.accObj").Phoenix_Account_Cooling_Period__c : 0);
        if(gcpLineItem.Phoenix_Latest_Bid_Date__c != undefined){
            var cpDate = new Date();
            var date2 = gcpLineItem.Phoenix_Latest_Bid_Date__c;
            
            date2 = date2.split('T')[0];
            date2 = new Date(formatDate(new Date(date2)));
            var diffTime = todayDate.getTime() - date2.getTime();
            var differDays = Math.floor(diffTime / (1000*60*60*24)); //Math.floor((new Date(todayDate) - new Date(date2))
            if(coolingPeriod < differDays || coolingPeriod == 0 || differDays == 0){
                component.set("v.isProdFamAvailable",true);
            }
            else{
                component.set("v.isProdFamAvailable",false);
            }
            if(coolingPeriod >= differDays){
                cpDate.setDate(today.getDate() + (coolingPeriod - differDays));
                coolingPeriodTitle = 'Last Bid: '+formatForTitle(new Date(date2))+'; CP Days: '+coolingPeriod+' Days; CP Date: '+formatForTitle(new Date(cpDate))+'; '+(coolingPeriod - differDays)+' days remaining';
            }
            else{
                var overDays = ''+(coolingPeriod - differDays);
                cpDate.setDate(today.getDate() + (coolingPeriod - differDays));
                overDays = overDays.includes('-') ? overDays.split('-')[1] : overDays;
                coolingPeriodTitle = 'Last Bid: '+formatForTitle(new Date(date2))+'; CP Days: '+coolingPeriod+' Days; CP Date: '+formatForTitle(new Date(cpDate))+'; '+overDays+' days over cooling period';
            }
            component.set("v.coolingPeriodTitle",coolingPeriodTitle);
        }
        
        if(gcpLineItem.Phoenix_Est_Acct_Mkt_Share_Method__c == 'Use User Input'){
            component.set("v.accMarketShareTitle",'Using User Input');
        }
        else if(gcpLineItem.Phoenix_Est_Acct_Mkt_Share_Method__c == 'Use Customer Feedback (Bright)'){
            component.set("v.accMarketShareTitle",'Using Customer Feedback (Bright)');
        }
            else if(gcpLineItem.Phoenix_Est_Acct_Mkt_Share_Method__c == undefined || gcpLineItem.Phoenix_Est_Acct_Mkt_Share_Method__c == 'Use Default Header'){
                component.set("v.accMarketShareTitle",'Using Default header');
            }
        
        if(gcpLineItem.Phoenix_Est_Acct_Share_of_Wallet_Method__c == 'Use User Input'){
            component.set("v.estAcctShareOfWalletTitle",'Using User Input');
        }
        else if(gcpLineItem.Phoenix_Est_Acct_Share_of_Wallet_Method__c == undefined || gcpLineItem.Phoenix_Est_Acct_Share_of_Wallet_Method__c == 'Use Default Header'){
            component.set("v.estAcctShareOfWalletTitle",'Using Default header');
        }
        
        if(gcpLineItem.Phoenix_Est_Acct_Vol_Method__c == 'Use User Input')
            component.set("v.estAcctVolTitle",'Using User Input');
        else if(gcpLineItem.Phoenix_Est_Acct_Vol_Method__c == 'Use Calculation of Est Acct Mkt Share')
            component.set("v.estAcctVolTitle",'Est Acct Share Of Wallet * Est Acct Mkt Share * Total Market Vol (MAT - EU)');
            else if(gcpLineItem.Phoenix_Est_Acct_Vol_Method__c == undefined || gcpLineItem.Phoenix_Est_Acct_Vol_Method__c == 'Use Proposed Total Selling Units (BRIGHT)')
                component.set("v.estAcctVolTitle",'Using Proposed Total Selling Units (BRIGHT)');
                else if(gcpLineItem.Phoenix_Est_Acct_Vol_Method__c == 'Use Sum of all SKUs estimate volume')
                    component.set("v.estAcctVolTitle",'Using Sum of all SKUs estimate volume');
        var actVal = Math.round((gcpLineItem.Phoenix_Est_Price_EU__c) * 100) / 100;
        var avgVal = Math.round((component.get("v.avgValue")) * 100) / 100;
        
        //if(gcpLineItem.Product_Status__c == 'Awarded' && (gcpLineItem.Phoenix_Est_Price_Method__c == undefined || gcpLineItem.Phoenix_Est_Price_Method__c == 'DRL Customer Actuals Average Price')
        //&& actVal == avgVal){
        if(gcpLineItem.Phoenix_Est_Price_Method__c == 'DRL Customer Actuals Average Price')
            component.set("v.estAcctPriceTitle",'DRL Customer Actuals Average Price');
        else if(gcpLineItem.Phoenix_Est_Price_Method__c == 'Use User Input'){
            component.set("v.estAcctPriceTitle",'Using User Input');
        }
            else if(gcpLineItem.Phoenix_Est_Price_Method__c == 'Use Lowest Price'){
                component.set("v.estAcctPriceTitle",'Using Lowest Price');
            }
                else if(gcpLineItem.Phoenix_Est_Price_Method__c == undefined || gcpLineItem.Phoenix_Est_Price_Method__c == 'Use GCP Suggested Price' || gcpLineItem.Phoenix_Est_Price_Method__c == 'Marketing (Panorama) suggested Price'){
                    component.set("v.estAcctPriceTitle",'Using Marketing (Panorama) suggested Price');
                }
        
        if(gcpLineItem.Product_Status__c == 'True Opportunity'){
            component.set("v.createOptyColor",'showGreen');
        }
        else if(gcpLineItem.Product_Status__c == 'Not An Opportunity'){
            component.set("v.createOptyColor",'showBlack');
        }
            else if(gcpLineItem.Product_Status__c == 'Price Constraint'){
                component.set("v.createOptyColor",'showRed');
            }
                else if(gcpLineItem.Product_Status__c == 'Supply Constraint' ){
                    component.set("v.createOptyColor",'showBabyPink');
                }
                    else if(gcpLineItem.Product_Status__c == 'Awarded'){
                        component.set("v.createOptyColor",'showPink');
                    }
                        else if(gcpLineItem.Product_Status__c == 'In Bid'){
                            component.set("v.createOptyColor",'showOrange');
                        }
        gcpLineItem.Vision_CVS_VolShare_Percent__c = gcpLineItem.Vision_CVS_VolShare_Percent__c != null ? gcpLineItem.Vision_CVS_VolShare_Percent__c : 0;
        gcpLineItem.Vision_Cardinal_VolShare_Percent__c = gcpLineItem.Vision_Cardinal_VolShare_Percent__c != null ? gcpLineItem.Vision_Cardinal_VolShare_Percent__c : 0;
        gcpLineItem.Vision_Major_VolShare_Percent__c = gcpLineItem.Vision_Major_VolShare_Percent__c != null ? gcpLineItem.Vision_Major_VolShare_Percent__c : 0;
        
        gcpLineItem.Vision_CVS_CustAct_Volume__c = gcpLineItem.Vision_CVS_CustAct_Volume__c != null ? gcpLineItem.Vision_CVS_CustAct_Volume__c : 0;
        gcpLineItem.Vision_Cardinal_CustAct_Volume__c = gcpLineItem.Vision_Cardinal_CustAct_Volume__c != null ? gcpLineItem.Vision_Cardinal_CustAct_Volume__c : 0;
        gcpLineItem.Vision_Major_CustAct_Volume__c = gcpLineItem.Vision_Major_CustAct_Volume__c != null ? gcpLineItem.Vision_Major_CustAct_Volume__c : 0;
        gcpLineItem.Vision_NorthStar_CustAct_Volume__c = gcpLineItem.Vision_NorthStar_CustAct_Volume__c != null ? gcpLineItem.Vision_NorthStar_CustAct_Volume__c : 0;
        
        gcpLineItem.Vision_CVS_CustAct_Sales__c = gcpLineItem.Vision_CVS_CustAct_Sales__c != null ? gcpLineItem.Vision_CVS_CustAct_Sales__c : 0;
        gcpLineItem.Vision_Cardinal_CustAct_Sales__c = gcpLineItem.Vision_Cardinal_CustAct_Sales__c != null ? gcpLineItem.Vision_Cardinal_CustAct_Sales__c : 0;
        gcpLineItem.Vision_Major_CustAct_Sales__c = gcpLineItem.Vision_Major_CustAct_Sales__c != null ? gcpLineItem.Vision_Major_CustAct_Sales__c : 0;
        gcpLineItem.Vision_NorthStar_CustAct_Sales__c = gcpLineItem.Vision_NorthStar_CustAct_Sales__c != null ? gcpLineItem.Vision_NorthStar_CustAct_Sales__c : 0;
        gcpLineItem.Vision_isZeroOptyVal__c = gcpLineItem.Vision_isZeroOptyVal__c != null ? gcpLineItem.Vision_isZeroOptyVal__c : false;
        console.log('gcpLineItem.Vision_isZeroOptyVal__c --> '+gcpLineItem.Vision_isZeroOptyVal__c);
        component.set("v.gcpLineItem", gcpLineItem);
        if(component.get("v.accObj.Name") == 'Red Oak Sourcing' || component.get("v.accObj").AccountNumber == '153363'){ //.toLocaleString('en-US')
            var CvsVolString = gcpLineItem.Vision_CVS_CustAct_Volume__c,cardinalVolString = gcpLineItem.Vision_Cardinal_CustAct_Volume__c, 
                majorVolString = gcpLineItem.Vision_Major_CustAct_Volume__c,northVolString = gcpLineItem.Vision_NorthStar_CustAct_Vol__c;  
            component.set("v.cvsVolString", CvsVolString);component.set("v.cardinalVolString",cardinalVolString);component.set("v.majorVolString",majorVolString);component.set("v.northVolString",northVolString);
            var cvsSaleString = gcpLineItem.Vision_CVS_CustAct_Sales__c, cardinalSaleString = gcpLineItem.Vision_Cardinal_CustAct_Sales__c, 
                majorSaleString = gcpLineItem.Vision_Major_CustAct_Sales__c,northSaleString = gcpLineItem.Vision_NorthStar_CustAct_Sales__c;
            component.set("v.cvsSaleString",cvsSaleString);component.set("v.cardinalSaleString",cardinalSaleString);component.set("v.majorSaleString",majorSaleString);component.set("v.northSaleString",northSaleString);
        }
    },
    
    showNdcList : function(component, event, helper){
        component.set("v.isSpinnerLoad",true);
        if(component.get("v.accObj.Name") == 'Red Oak Sourcing' || component.get("v.accObj").AccountNumber == '153363')
            var action = component.get("c.getNDCforROS");
        else 
            var action = component.get("c.getNdcListOfProdFam");
        action.setParams({prodFamilyName:component.get("v.gcpLineItem.GCP_Product_Family__c"),
                          accId : component.get("v.accObj.Id")});
        action.setCallback(this, function (response) {
            console.log('State from getNdcListOfProdFam :: '+response.getState());
            if (response.getState() == "SUCCESS") {
                var wrapper = response.getReturnValue();
                var ndcList = wrapper.updateGcpList;
                if(ndcList.length > 0){
                    var openOrders = wrapper.openOrders;
                    var RxBackOrders = wrapper.RxBackOrders;
                    var SRxBackOrders = wrapper.SRxBackOrders;
                    var OTCBackOrders = wrapper.OTCBackOrders;
                    var isOtcAccount = wrapper.isOtcAccount;
                    component.set("v.isOtcAccount",isOtcAccount);
                    var selectedNdcs = component.get("v.selectedNdcs");
                    if(ndcList.length > 0){
                        for(var i=0; i<ndcList.length; i++){
                            if(openOrders.hasOwnProperty(ndcList[i].Vision_Product__r.Phoenix_NDC_11__c)){
                                ndcList[i].isOpenOrder = true;
                            } else{
                                ndcList[i].isOpenOrder = false;
                            }
                            if(RxBackOrders.hasOwnProperty(ndcList[i].Vision_Product__r.Phoenix_NDC_11__c)){
                                ndcList[i].isRxBackOrder = true;
                                console.log('Rx: '+JSON.stringify(ndcList[i]));
                            } else{
                                ndcList[i].isRxBackOrder = false;
                            }
                            if(SRxBackOrders.hasOwnProperty(ndcList[i].Vision_Product__r.Phoenix_NDC_11__c)){
                                ndcList[i].isSRxBackOrder = true;
                            } else{
                                ndcList[i].isSRxBackOrder = false;
                            }
                            if(OTCBackOrders.hasOwnProperty(ndcList[i].Vision_Product__r.Phoenix_NDC_11__c)){
                                ndcList[i].isOTCBackOrder = true;
                            } else{
                                ndcList[i].isOTCBackOrder = false;
                            }
                            if(selectedNdcs != undefined){
                                if(selectedNdcs.includes(ndcList[i].Vision_Product__c))
                                    ndcList[i].isSelectedPrd = true;
                                else
                                    ndcList[i].isSelectedPrd = false;
                            }
                            ndcList[i].Vision_Estimate_Vol_Method__c = ndcList[i].Vision_Estimate_Vol_Method__c != undefined ? ndcList[i].Vision_Estimate_Vol_Method__c : 'Full Line Volume';
                        }
                    }
                    console.log('NDC List: '+JSON.stringify(ndcList));
                    
                }
                component.set("v.ndcList",ndcList);
                component.set("v.isSpinnerLoad",false);
                component.set("v.showProducts",true);
            }
            else {
                console.log('Error while updating line Item.');
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
    getUpdatedGcpItemMethod : function(component, event, helper){
        if(component.get("v.getUpdatedGcpItem")){
            var action = component.get("c.getUpdatedGcpItem");
            action.setParams({gcpLineItemId:component.get("v.gcpLineItem.Id")});
            action.setCallback(this, function (response) {
                console.log('State from getNdcListOfProdFam :: '+response.getState());
                if (response.getState() == "SUCCESS") {
                    component.set("v.gcpLineItem",response.getReturnValue());
                    var compEvent = component.getEvent("refreshEvent");
                    compEvent.setParams({
                        "isRefreshRecs" : 'REFRESH'
                    });
                    compEvent.fire();
                }
                else {
                    console.log('Error while getting line Item.');
                    console.log("Error "+JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action);
            component.set("v.getUpdatedGcpItem",false);
        }
    },
    
    hideNdcList : function(component, event, helper){
        component.set("v.ndcList",[]);
        component.set("v.showProducts",false);
    },
    
    createOpty : function(component, event, helper){
        if(component.get("v.gcpLineItem").Product_Status__c == 'True Opportunity'){
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:Phoenix_OpportunityEditPage",
                componentAttributes: {
                    accId : component.get("v.accObj.Id"),
                    optyType : 'Proactive',
                    prodFamName : component.get("v.gcpLineItem").Phoenix_Product_Family__c
                }
            });
            evt.fire();
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR",
                "message":'You can not create an Opportunity as the product status is not True Opportunity.',
                "type":"ERROR",
                "mode":"dismissible"
            });
            toastEvent.fire();
        }
    },
    editLineItem : function(component, event, helper) {
        component.set("v.showUserInputs",component.get("v.showUserInputs")?false:true);
    },
    inlineEditPositions : function(component, event, helper){
        var bidCustomer = component.get("v.accObj").Id;
        helper.getPositions(component, event, helper, bidCustomer);
        /*component.set("v.isPositionsModalOpen", true);
        component.set("v.isSpinner",true);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        component.set('v.LinepositionColumns', [
            {
                label: 'Name',
                fieldName: 'Name',
                type: 'text'
            },
            {
                label: 'Customer',
                fieldName: 'Phoenix_Customer__c',
                type: 'text'
            },
            {
                label: 'Group Name',
                fieldName: 'Phoenix_Group_Name__c',
                type: 'text'
            },
            {
                label: 'Position Comments',
                fieldName: 'Phoenix_Position_Comments__c',
                type: 'Text'
            }
        ]);
        var bidCustomer = component.get("v.accObj").Id;
        console.log('--bidCustomer--' + bidCustomer);
        if (bidCustomer != null && bidCustomer != undefined) {
            helper.getPositions(component, event, helper, bidCustomer);
        } else {
            component.set("v.LinepositionsList", null);
            component.set("v.isSpinner",false);
        }*/
    },
    closeinlineEditPositions : function(component, event, helper){
        component.set("v.PositionsEditMode",false);
    },
    savePositions : function(component, event, helper){
        var positions = component.get("v.LinepositionsList");
        var selectedPosition = '';
        positions.forEach(function(selectedPos){
            if(selectedPos.isChecked){
                if(selectedPosition == '')
                    selectedPosition = selectedPos.posName;
                else
                    selectedPosition = selectedPosition + ','+selectedPos.posName;
            }
        });
        if(selectedPosition == ''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "alert!",
                "message":'No Position is selected for this product family.',
                "type":"INFO",
                "mode":"dismissible"
            });
            toastEvent.fire();
        }
        var gcpLineItem = component.get("v.gcpLineItem");
        gcpLineItem.Phoenix_Current_Position__c = selectedPosition;
        var action = component.get("c.updateGcpLineItem");
        action.setParams({
            gcpLineItem : gcpLineItem
        });
        action.setCallback(this, function (response) {
            console.log('State from updateGcpLineItem :: '+response.getState());
            if (response.getState() == "SUCCESS") {
                var gcpLineItem = response.getReturnValue();
                component.set("v.gcpLineItem",gcpLineItem);
                component.set("v.showSaveComntButton",false);
                component.set("v.showComments",false);
                component.set("v.isPositionsModalOpen", false);
            }
            else {
                console.log('Error while updating line Item.');
            }
        });
        $A.enqueueAction(action);
    },
    closePositionsPopup: function (component, event, helper) {
        component.set("v.isPositionsModalOpen", false);
        component.set("v.showProducts",true);
    },
    saveUserInputs : function(component, event, helper){
        console.log('saving the GCP line item record');
    },
    onProdStatusChange : function(component, event, helper){
        var val = event.getSource().get('v.value');
        
        if(val == 'Price Constraint' || val == 'Supply Constraint'){
            component.set("v.selectedStatusVal",val);
            component.set("v.sendDataConfirm",true);
        }
        else{
            //(val == 'Not An Opportunity' || val == 'True Opportunity' || ){
            component.set("v.isSpinnerLoad",true);
            component.set("v.gcpLineItem.Product_Status__c",val);
            var action = component.get("c.updateGcpLineItem");
            action.setParams({
                gcpLineItem : component.get("v.gcpLineItem")
            });
            action.setCallback(this, function (response) {
                console.log('State from updateGcpLineItem :: '+response.getState());
                if (response.getState() == "SUCCESS") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Product Status Updated!",
                        "message":'Please Enter Your Comments.',
                        "type":"SUCCESS",
                        "mode":"dismissible"
                    });
                    toastEvent.fire();
                    var gcpLineItem = response.getReturnValue();
                    if(gcpLineItem.Product_Status__c == 'True Opportunity'){
                        component.set("v.createOptyColor",'showGreen');
                    }
                    else if(gcpLineItem.Product_Status__c == 'Not An Opportunity'){
                        component.set("v.createOptyColor",'showBlack');
                    }
                        else if(gcpLineItem.Product_Status__c == 'Price Constraint'){
                            component.set("v.createOptyColor",'showRed');
                        }
                            else if(gcpLineItem.Product_Status__c == 'Supply Constraint' ){
                                component.set("v.createOptyColor",'showBabyPink');
                            }
                                else if(gcpLineItem.Product_Status__c == 'Awarded'){
                                    component.set("v.createOptyColor",'showPink');
                                }
                                    else if(gcpLineItem.Product_Status__c == 'In Bid'){
                                        component.set("v.createOptyColor",'showOrange');
                                    }
                    component.set("v.gcpLineItem",gcpLineItem);
                    component.set("v.isSpinnerLoad",false);
                    
                    if(val == 'Not An Opportunity'){
                        helper.getCommentsHelper(component, event, helper);
                    }
                    else{
                        var compEvent = component.getEvent("refreshEvent");
                        compEvent.setParams({
                            "isRefreshRecs" : 'changeHeader',
                            "gcpRec" : gcpLineItem,
                            "indexVal" : component.get("v.indexVal")                            
                        });
                        compEvent.fire();
                    }
                }
                else {
                    console.log('Error while updating line Item.');
                }
            });
            $A.enqueueAction(action);
            
        }
        /*else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR",
                "message":'You can not select this status. It will be automatically populated.',
                "type":"ERROR",
                "mode":"dismissible"
            });
            toastEvent.fire();
        }*/
    },
    sendDataNo : function(component, event, helper){
        console.log('inside sendDataNo');
        component.set("v.isSpinnerLoad",true);
        component.set("v.sendDataConfirm",false);
        console.log('component.get("v.selectedStatusVal") :: '+component.get("v.selectedStatusVal"));
        var gcpLineItem = component.get("v.gcpLineItem");
        gcpLineItem.Product_Status__c = component.get("v.selectedStatusVal");
        gcpLineItem.Vision_isSentToPanorama__c = false;
        var action = component.get("c.updateGcpLineItem");
        action.setParams({
            gcpLineItem : gcpLineItem
        });
        action.setCallback(this, function (response) {
            console.log('State from updateGcpLineItem :: '+response.getState());
            if (response.getState() == "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Product Status Updated!",
                    "message":'Please Enter Your Comments.',
                    "type":"SUCCESS",
                    "mode":"dismissible"
                });
                toastEvent.fire();
                var gcpLineItemResp = response.getReturnValue();
                component.set("v.gcpLineItem",gcpLineItemResp);
                
                component.set("v.isSpinnerLoad",false);
                helper.getCommentsHelper(component, event, helper);
                //component.set("v.doRefresh",component.get("v.doRefresh")?false:true);
            }
            else {
                console.log('Error while updating line Item.');
            }
        });
        $A.enqueueAction(action);
    },
    sendDataYes : function(component, event, helper){
        console.log('inside sendDataYes');
        component.set("v.isSpinnerLoad",true);
        component.set("v.sendDataConfirm",false);
        console.log('component.get("v.selectedStatusVal") :: '+component.get("v.selectedStatusVal"));
        var gcpLineItem = component.get("v.gcpLineItem");
        gcpLineItem.Product_Status__c = component.get("v.selectedStatusVal");
        gcpLineItem.Vision_isSentToPanorama__c = true;
        var action = component.get("c.updateGcpLineItem");
        action.setParams({
            gcpLineItem : gcpLineItem
        });
        action.setCallback(this, function (response) {
            console.log('State from updateGcpLineItem :: '+response.getState());
            if (response.getState() == "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Product Status Updated!",
                    "message":'Please Enter Your Comments.',
                    "type":"SUCCESS",
                    "mode":"dismissible"
                });
                toastEvent.fire();
                var gcpLineItemResp = response.getReturnValue();
                component.set("v.gcpLineItem",gcpLineItemResp);
                
                component.set("v.isSpinnerLoad",false);
                helper.getCommentsHelper(component, event, helper);
                //component.set("v.doRefresh",component.get("v.doRefresh")?false:true);
            }
            else {
                console.log('Error while updating line Item.');
            }
        });
        $A.enqueueAction(action);
    },
    closeSendData : function(component, event, helper){
        component.set("v.sendDataConfirm",false);
    },
    onRecChange : function(component, event, helper){
        console.log('on record change method.. ');
        var nameofEditfield = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        console.log('nameofEditfield :: '+nameofEditfield);
        console.log('value :: '+val);
        if(nameofEditfield == 'opptyProbChange'){
            component.set("v.gcpLineItem.Phoenix_Opportunity_Probability__c",val);
        }
        if(nameofEditfield == 'prodStatusChange'){
            component.set("v.gcpLineItem.Product_Status__c",val);
        }
        
        var action = component.get("c.updateGcpLineItem");
        action.setParams({
            gcpLineItem : component.get("v.gcpLineItem")
        });
        action.setCallback(this, function (response) {
            console.log('State from updateGcpLineItem :: '+response.getState());
            if (response.getState() == "SUCCESS") {
                var gcpLineItem = response.getReturnValue();
                component.set("v.gcpLineItem",gcpLineItem);
                component.set("v.showSaveComntButton",false);
                component.set("v.showComments",false);
                if(nameofEditfield == 'prodStatusChange')
                    component.set("v.doRefresh",component.get("v.doRefresh")?false:true);
                else{
                    var a = component.get('c.doInit');
                    $A.enqueueAction(a);
                }
            }
            else {
                console.log('Error while updating line Item.');
            }
        });
        $A.enqueueAction(action);
    },
    inlineEditCoolingPeriod : function(component, event, helper){
        component.set("v.coolingPeriodEditMode",true);
    },
    closeEditCoolingPeriod : function(component, event, helper){
        component.set("v.coolingPeriodEditMode",false);
    },
    inlineEditOptyProb : function(component, event, helper){
        component.set("v.optyProbEditMode",true);
    },
    closeinlineEditOptyProb : function(component, event, helper){
        component.set("v.optyProbEditMode",false);
    },
    inlineProdStatus : function(component, event, helper){
        component.set("v.probStatusEditMode",true);
    },
    closeinlineProdStatus : function(component, event, helper){
        component.set("v.probStatusEditMode",false);
    },
    commentSelected : function(component, event, helper){
        component.set("v.showProducts",false);
        console.log('selected row number ---> '+component.get("v.commentIndex"));
        var index = component.get("v.commentIndex");
        var ndcList = component.get("v.ndcList");
        var selectedItem = ndcList[index];
        component.set("v.selectedLine",selectedItem);
        helper.getCommentsHelper(component, event, helper, selectedItem);
    },
    inlineEditComments : function(component, event, helper){
        console.log('in inlineEditComments');
        component.set("v.showSaveComntButton",false);
        var index = event.currentTarget.id;  
        
        var ndcList = component.get("v.ndcList");
        var selectedItem = ndcList[index];
        component.set("v.selectedLine",selectedItem);
        helper.getCommentsHelper(component, event, helper, selectedItem);
    },
    closeCommentPopup : function(component, event, helper){
        var compEvent = component.getEvent("refreshEvent");
        compEvent.setParams({
            "isRefreshRecs" : 'changeHeader',
            "gcpRec" : component.get("v.gcpLineItem"),
            "indexVal" : component.get("v.indexVal")
            
        });
        compEvent.fire();
        component.set("v.commentIndex",'');
        component.set("v.showComments",false);
        component.set("v.showProducts",true);
    },
    closeEditComments : function(component, event, helper){
        component.set("v.commentsEditMode",false);
    },
    onCmntChanged : function(component, event, helper){
        component.set("v.showSaveComntButton",true);
    },
    userInputChanged : function(component, event, helper){
        if(!component.get("v.showUserInputs")){
            var action = component.get("c.getUpdatedGcpLineItem");
            action.setParams({
                gcpLineObjId : component.get("v.gcpLineItem").Id
            });
            action.setCallback(this, function (response) {
                console.log('State from updateGcpLineItem :: '+response.getState());
                if (response.getState() == "SUCCESS") {
                    var gcpLineItem = response.getReturnValue();
                    component.set("v.gcpLineItem",gcpLineItem);
                    var compEvent = component.getEvent("refreshEvent");
                    compEvent.setParams({
                        "isRefreshRecs" : 'REFRESH'
                    });
                    compEvent.fire();
                }
                else {
                    console.log('Error while updating line Item.');
                }
            });
            $A.enqueueAction(action);
        }
    },
    refreshCommentsMethod : function(component, event, helper){
        if(component.get("v.refreshComments") == 'REFRESH COMMENTS')
            helper.getCommentsHelper(component, event, helper, component.get("v.selectedLine"));
    },
    onSaveCmnt : function(component, event, helper){
        var cmnt = component.get("v.visionComment");
        if(component.get("v.selectedStatusVal") == 'Price Constraint' || component.get("v.selectedStatusVal") == 'Supply Constraint'){
            cmnt = component.get("v.selectedStatusVal")+': \n'+cmnt;
        }
        if(cmnt != undefined && cmnt != ''){
            var action = component.get("c.saveComment");
            action.setParams({
                newComment : cmnt,
                selectedLineId : component.get("v.selectedLine").Id
            });
            action.setCallback(this, function (response) {
                console.log('State from saveComment :: '+response.getState());
                if (response.getState() == "SUCCESS") {
                    var respObj = response.getReturnValue();
                    if(respObj.isErrorFromServer){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "ERROR",
                            "message":''+respObj.errorMessageFromServer,
                            "type":"ERROR",
                            "mode":"dismissible"
                        });
                        toastEvent.fire();
                    }
                    else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Saved!",
                            "message":'Comment Added Successfully.',
                            "type":"SUCCESS",
                            "mode":"dismissible"
                        });
                        toastEvent.fire();
                        component.set("v.visionComment",'');
                        helper.getCommentsHelper(component, event, helper, component.get("v.selectedLine"));
                    }
                }
                else {
                    console.log('Error while storing Comment.');
                }
            });
            $A.enqueueAction(action);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR",
                "message":'Vision comments are not added.',
                "type":"ERROR",
                "mode":"dismissible"
            });
            toastEvent.fire();
        }
    },
    downloadCmnts: function (component, event, helper) {
        var cmntType = event.getSource().getLocalId();
        console.log('cmntType :: '+cmntType);
        var fileName = '';
        var csv4 = helper.convertArrayOfObjectsToCSV(component, cmntType);
        
        if (csv4 == '') {
            return;
        }
        if(cmntType == 'allCmnts')
            fileName = 'Comments and Insights';
        else if(cmntType == 'brightCmnts')
            fileName = 'Bright Comments';
            else if(cmntType == 'visionCmnts')
                fileName = 'Vision Comments';
                else if(cmntType == 'panoramaCmnts')
                    fileName = 'Panorama Comments';
        var hiddenElement1 = document.createElement('a');
        hiddenElement1.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv4);
        hiddenElement1.target = '_self'; //
        var date = new Date();
        var hours = date.getHours();
        var minutes = date.getMinutes();
        var newformat = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12;
        hours = hours ? hours : 12;
        minutes = minutes < 10 ? '0' + minutes : minutes;
        var Now = (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear() + ' ' + hours + ':' + minutes + ' ' + newformat;
        hiddenElement1.download = fileName+''+ '-' + Now + '.csv'; // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement1); // Required for FireFox browser
        hiddenElement1.click(); // using click() js function to download csv file
        
    },
    changeHoverColor : function(component, event, helper){
        component.set("v.showGrayTr",true);
    },
    closeHoverColor : function(component, event, helper){
        component.set("v.showGrayTr",false);
    },
    
    
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    
    validateDueDate : function(component, event, helper){
        var today = new Date();
        var enteredDate = component.get("v.alertObj.Vision_Notification_Due_Date__c");
        if(new Date(enteredDate) <= today){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR",
                "message":'Due date can not be less than Today.',
                "type":"ERROR",
                "mode":"dismissible"
            });
            toastEvent.fire();   
            //component.set("v.ANDueDate",today);
        }
    },
    
    checkDaysValidation : function(component, event, helper){
        var db1=component.get("v.alertObj.Vision_Repeat_Days_Before_1__c");
        var db2=component.get("v.alertObj.Vision_Repeat_Days_Before_2__c");
        var db3=component.get("v.alertObj.Vision_Repeat_Days_Before_3__c");
        var db4=component.get("v.alertObj.Vision_Repeat_Days_Before_4__c");
        var db5=component.get("v.alertObj.Vision_Repeat_Days_Before_5__c");
        
        if(Number(db1) < Number(db2)){
            console.log('in  1 2');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR",
                "message":'Repeat Days needs to be in increasing order.',
                "type":"ERROR",
                "mode":"dismissible"
            });
            toastEvent.fire();
        }
        else if(Number(db2) < Number(db3)){
            console.log('in  2 3');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR",
                "message":'Repeat Days needs to be in increasing order.',
                "type":"ERROR",
                "mode":"dismissible"
            });
            toastEvent.fire();
        }
            else if(Number(db3) < Number(db4)){
                console.log('in  3 4');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR",
                    "message":'Repeat Days needs to be in increasing order.',
                    "type":"ERROR",
                    "mode":"dismissible"
                });
                toastEvent.fire();
            }
                else if(Number(db4) < Number(db5)){
                    console.log('in  4 5');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "ERROR",
                        "message":'Repeat Days needs to be in increasing order.',
                        "type":"ERROR",
                        "mode":"dismissible"
                    });
                    toastEvent.fire();
                }
    },
    
    submitDetails: function(component, event, helper) {
        /*var cm=component.get("v.ANComment");
        var dd=component.get("v.ANDueDate");
        var sb=component.get("v.ANSubject");
        var cb1=component.get("v.checkbox1selected");
        var cb2=component.get("v.checkbox2selected");
        var cb3=component.get("v.checkbox3selected");
        var cb4=component.get("v.checkbox4selected");
        var cb5=component.get("v.checkbox5selected");
        var db1=component.get("v.daysbefore1");
        var db2=component.get("v.daysbefore2");
        var db3=component.get("v.daysbefore3");
        var db4=component.get("v.daysbefore4");
        var db5=component.get("v.daysbefore5");
        var IT=component.get("v.selectedTime");
        var selectedTime = component.get("v.selectedTime");
        */
        var alertObj = component.get("v.alertObj");
        var today = new Date();
        if(alertObj.Vision_Alert_Topic__c == undefined || alertObj.Vision_Alert_Topic__c == ''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR",
                "message":'Please Enter Alert Subject.',
                "type":"ERROR",
                "mode":"dismissible"
            });
            toastEvent.fire();
        }
        else if(alertObj.Vision_Notification_Due_Date__c == undefined || alertObj.Vision_Notification_Due_Date__c == ''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR",
                "message":'Please Enter Alert Due Date.',
                "type":"ERROR",
                "mode":"dismissible"
            });
            toastEvent.fire();
        }
            else if(new Date(alertObj.Vision_Notification_Due_Date__c) <= today){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR",
                    "message":'Due date can not be less than Today.',
                    "type":"ERROR",
                    "mode":"dismissible"
                });
                toastEvent.fire(); 
            }
        /*else if(alertObj.Vision_Notification_Repeat_Time__c == undefined || alertObj.Vision_Notification_Repeat_Time__c == ''){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR",
                    "message":'Please Enter Alert Repeat Time.',
                    "type":"ERROR",
                    "mode":"dismissible"
                });
                toastEvent.fire();
            }*/
                else
                {
                    var recId = '';
                    var acId=component.get("v.recordId");
                    var itemType = component.get("v.alertedItemType");
                    if(itemType == 'gcpItem'){
                        recId = component.get("v.gcpLineItem.Id");
                    }
                    else if(itemType == 'ndcItem'){
                        recId = component.get("v.alertedNdcId");
                    }
                    var action=component.get("c.saveAlert");
                    action.setParams({alertObj:alertObj, accObj:component.get("v.accObj"), recId : recId, itemType:itemType});
                    action.setCallback(this,function(response){
                        var state= response.getState(); 
                        if(state=='SUCCESS'){
                            var wrapperObj = response.getReturnValue();
                            if(itemType == 'gcpItem'){
                                component.set("v.gcpLineItem",wrapperObj.gcpObj);
                            }
                            else{
                                var ndcList = component.get("v.ndcList");
                                var ndcUpdateList = [];
                                ndcList.forEach(function(ndcObj){
                                    if(recId == ndcObj.Id){
                                        ndcObj = wrapperObj.ndcObj;
                                    }
                                    ndcUpdateList.push(ndcObj);
                                });
                                component.set("v.ndcList",ndcUpdateList);
                                component.set("v.selectedNdcId",'');
                                component.set("v.alertedItemType",'');
                            }
                            component.set("v.isModalOpen", false);
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "SUCCESS",
                                "message":'Alert has been created successfully.',
                                "type":"SUCCESS",
                                "mode":"dismissible"
                            });
                            toastEvent.fire();
                        }
                        
                    });
                    $A.enqueueAction(action);
                }
        
    },
    checkboxSelect1: function(component, event, helper) {
        component.set("v.checkbox1selected",false);  
        
    },
    checkboxSelect2: function(component, event, helper) {
        component.set("v.checkbox2selected",false);  
        
    },
    checkboxSelect3: function(component, event, helper) {
        component.set("v.checkbox3selected",false);  
        
    },
    checkboxSelect4: function(component, event, helper) {
        component.set("v.checkbox4selected",false);  
        
    },
    checkboxSelect5: function(component, event, helper) {
        component.set("v.checkbox5selected",false);  
    },
    
    openAlertForNdc : function(component, event, helper){
        var selectedNdcId = event.target.dataset.recordId;
        console.log('selectedNdcId ---> '+selectedNdcId);
        component.set("v.alertedItemType",'ndcItem');
        component.set("v.alertedNdcId",selectedNdcId);
        component.set("v.selectedRecIdForAlert",selectedNdcId);
        component.set("v.isModalOpen", true);
        //helper.getAlertInfo(component,event,helper, selectedNdcId, 'ndcItem');
    },
    
    alertChanged : function(component, event, helper){
        component.set("v.showProducts", component.get("v.showProducts")?false:true);
    },
    
    openModel: function(component, event, helper) {
        var recId=component.get("v.gcpLineItem.Id");
        component.set("v.alertedItemType",'gcpItem');
        component.set("v.selectedRecIdForAlert",recId);
        component.set("v.isModalOpen", true);
        // helper.getAlertInfo(component,event,helper, recId, 'gcpItem');
    },
    
    handleAlertChanges : function(component, event, helper){
        var itemType = component.get("v.alertedItemType");
        if(itemType=="gcpItem"){
            var gcpItem = event.getParam("gcpItem");
            component.set("v.gcpLineItem",gcpItem);
            component.set("v.selectedRecIdForAlert",'');
        }
        else if(itemType=="ndcItem"){
            var recObj = event.getParam("gcpNdcItem");
            var itemId = component.get("v.selectedRecIdForAlert");
            var ndcList = component.get("v.ndcList");
            var ndcUpdateList = [];
            ndcList.forEach(function(ndcObj){
                if(itemId == ndcObj.Id){
                    ndcObj = recObj;
                }
                ndcUpdateList.push(ndcObj);
            });
            component.set("v.ndcList",ndcUpdateList);
            component.set("v.selectedRecIdForAlert",'');
            component.set("v.alertedItemType",'');
        }
    },
    
    probabilityUpdated : function(component, event, helper){
        var selectedVal = event.getSource().get('v.value');
        console.log('selectedVal ---> '+selectedVal);
        if(selectedVal.includes('~')){
            var selectedNdcRow = selectedVal.split('~')[0];
            var selectedStatusValue = selectedVal.split('~')[1];
            var ndcList = component.get("v.ndcList");
            var selectedItem = ndcList[selectedNdcRow];
            selectedItem.Vision_Probability__c = selectedStatusValue;
            ndcList[selectedNdcRow] = selectedItem;
            component.set("v.ndcList",ndcList);
            helper.updateNdcItem(component, event, helper, ndcList);
        }
    },
    constraintUpdated : function(component, event, helper){
        var selectedVal = event.getSource().get('v.value');
        console.log('selectedVal ---> '+selectedVal);
        if(selectedVal.includes('~')){
            var selectedNdcRow = selectedVal.split('~')[0];
            var selectedStatusValue = selectedVal.split('~')[1];
            var ndcList = component.get("v.ndcList");
            var selectedItem = ndcList[selectedNdcRow];
            selectedItem.Vision_Product_Constraint__c = selectedStatusValue;
            ndcList[selectedNdcRow] = selectedItem;
            component.set("v.ndcList",ndcList);
            helper.updateNdcItem(component, event, helper, ndcList);
        }
    },
    coolingPeriodUpdated : function(component, event, helper){
        var ndcList = component.get("v.ndcList");
        helper.updateNdcItem(component, event, helper, ndcList);
    },
    closeAwardedPositions :  function(component, event, helper){
        component.set("v.cptList",[]);
        component.set("v.prodPositionIndex",'');
        component.set("v.showAwardedPositions",false);
        component.set("v.showProducts",true);
    },
    
    openAwardedPositions : function(component, event, helper){
        component.set("v.isSpinnerLoad",true);
        if(component.get("v.prodPositionIndex") != undefined)
            var selectedNdcId = component.get("v.prodPositionIndex");
        else
            var selectedNdcId = event.target.dataset.recordId;
        var action=component.get("c.getAwardedPositionData");
        action.setParams({ndcId:selectedNdcId, accObj: component.get("v.accObj")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                console.log('UPDATED SUCCESSFULLY!');
                console.log('Awarded Positions Response: '+JSON.stringify(response.getReturnValue()));
                component.set("v.cptList",response.getReturnValue());
                component.set("v.showProducts",false);
                component.set("v.showAwardedPositions",true);
                component.set("v.isSpinnerLoad",false);
            }
            else{
                component.set("v.isSpinnerLoad",false);
                console.log('ERROR from getAwardedPositionData --> '+JSON.stringify(response.getError()));
                component.set("v.showProducts",true);
            }
        });
        $A.enqueueAction(action);
    },
    
    prodSelected : function(component, event, helper){
        var ndcList = component.get("v.ndcList");
        var selectedProdList = component.get("v.selectedNdcs");
        //var selectedProdListSize = selectedProdList != undefined  ? selectedProdList.length : 0;
        ndcList.forEach(function(ndcObj){
            if(ndcObj.isSelectedPrd && !selectedProdList.includes(ndcObj.Vision_Product__c)){
                selectedProdList.push(ndcObj.Vision_Product__c);
                //selectedProdListSize++;
            }
            else if(selectedProdList.includes(ndcObj.Vision_Product__c) && !ndcObj.isSelectedPrd){
                var index = selectedProdList.indexOf(ndcObj.Vision_Product__c);
                selectedProdList.splice(index, 1);
            }
        });
        var appEvent = $A.get("e.c:Vision_ProdSelectionEvent100P"); 
        appEvent.setParams({"selectedNdcs" : selectedProdList}); 
        appEvent.fire(); 
    },
    updatedSelectedProds : function(component, event, helper){
        var selectedNdcs = event.getParam("selectedNdcs");
        if(selectedNdcs != undefined && selectedNdcs.length > 0){ 
            component.set("v.selectedNdcs", selectedNdcs);  
        }
        else if(selectedNdcs.length == 0)
            component.set("v.selectedNdcs", []);  
    },
    savePercentageROS : function(component, event, helper){
        component.set("v.isSpinnerLoad",true);
        var action = component.get("c.updateMemberVolShare");
        action.setParams({
            gcpLineItem : component.get("v.gcpLineItem")
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.ndcList",response.getReturnValue());
                component.set("v.isSpinnerLoad",false);
            }
            else{
                console.log('ERROR --- > '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    updateSharedVols : function(component, event, helper){
        var ndcList = component.get("v.ndcList");
        var updatedList = [];
        ndcList.forEach(function(item){
            item.Vision_Major_Share_Vol__c = (item.Vision_Major_VolShare_Percent__c*item.Phoenix_Est_Acct_Total_Vol_EU__c)/100;
            item.Vision_CVS_Share_Vol__c = (item.Vision_CVS_VolShare_Percent__c*item.Phoenix_Est_Acct_Total_Vol_EU__c)/100;
            item.Vision_Cardinal_Share_Vol__c = (item.Vision_Cardinal_VolShare_Percent__c*item.Phoenix_Est_Acct_Total_Vol_EU__c)/100;
            updatedList.push(item);
        });
        component.set("v.ndcList",updatedList);
    },
    showMemberInputs : function(component, event, helper){
        
    },
    updateMemberVolume : function(component, event, helper){
        
    },
    saveNDCvalues : function(component, event, helper){
        helper.updateNdcItem(component, event, helper, component.get("v.ndcList"));
    },
    openTakeComments : function(component, event, helper){
        document.getElementById('commentsPopup').style.display="";
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "headerOfTable");
    },
    closeComments : function(component, event, helper){
        document.getElementById('commentsPopup').style.display="None";
        component.set("v.tableRef",'showHeader');
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "headerOfTable");
    },
    conUpdated : function(component, event, helper){
        component.set("v.showSaveButton",true);
    },
    saveConToSku : function(component, event, helper){
        console.log('con value --> '+component.get("v.conValue"));
        var action = component.get("c.saveConToAllSKUs");
        action.setParams({
            conVal : component.get("v.conValue"),
            ndcList : component.get("v.ndcList")
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.ndcList",response.getReturnValue());
                component.set("v.showSaveButton",false);
            }
            else{
                console.log('ERROR from saveConToAllSKUs--- > '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    saveCommentsToSku : function(component, event, helper){
        console.log('comment --> '+component.get("v.gcpLineItem.Vision_Comments__c"));
        var action = component.get("c.saveCommentToAllSKUs");
        action.setParams({
            gcpLineItem : component.get("v.gcpLineItem"),
            gcpNdcList : component.get("v.ndcList")
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                document.getElementById('commentsPopup').style.display="None";
            }
            else{
                console.log('ERROR from saveCommentToAllSKUs--- > '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    modifyOptySalesVal : function(component, event, helper){
        var gcpLineItem = component.get("v.gcpLineItem");
        console.log('gcpLineItem.Vision_isZeroOptyVal__c --> '+gcpLineItem.Vision_isZeroOptyVal__c);
        gcpLineItem.Vision_isZeroOptyVal__c = gcpLineItem.Vision_isZeroOptyVal__c ? false : true;
        var action = component.get("c.updateGcpLineItem");
        action.setParams({
            gcpLineItem : gcpLineItem
        });
        action.setCallback(this, function (response) {
            console.log('State from updateGcpLineItem :: '+response.getState());
            if (response.getState() == "SUCCESS") {
                var gcpLineItem = response.getReturnValue();
                component.set("v.gcpLineItem",gcpLineItem);
                component.set("v.doRefresh",component.get("v.doRefresh")?false:true);
            }
            else {
                console.log('Error while updating line Item.');
            }
        });
        $A.enqueueAction(action);
    }
})