({
    doInit : function(component, event, helper) {
        console.log('inside child comp');
        var wrapObj = component.get("v.prodItem");
        var isSentToBright = false; 
        if(wrapObj.hasBidLineItem){
            isSentToBright = true;
        }
        component.set("v.isSentToBright",isSentToBright); 
        var optyProdObj = wrapObj.optyProdObj;
        var optyObj = component.get("v.optyObj");
        var totalProposedUnits = 0;
        if(component.get("v.isOtcProdFam")){
            optyProdObj.Vision_Proposed_Units__c = (optyProdObj.Vision_Proposed_Units__c != '' && optyProdObj.Vision_Proposed_Units__c != undefined) ? optyProdObj.Vision_Proposed_Units__c : 0;
            optyProdObj.Vision_Proposed_Share_Percentage__c = (optyProdObj.Vision_Proposed_Share_Percentage__c != '' && optyProdObj.Vision_Proposed_Share_Percentage__c != undefined) ? optyProdObj.Vision_Proposed_Share_Percentage__c : 0;
            totalProposedUnits = parseInt(optyProdObj.Vision_Proposed_Units__c * (optyProdObj.Vision_Proposed_Share_Percentage__c/100));
        }
        else{
            optyProdObj.Vision_Proposed_Volume__c = (optyProdObj.Vision_Proposed_Volume__c != '' && optyProdObj.Vision_Proposed_Volume__c != undefined) ? optyProdObj.Vision_Proposed_Volume__c : 0;
            optyProdObj.Proposed_Direct_Selling_Units__c = (optyProdObj.Proposed_Direct_Selling_Units__c != '' && optyProdObj.Proposed_Direct_Selling_Units__c != undefined) ? optyProdObj.Proposed_Direct_Selling_Units__c : 0;
            optyProdObj.Proposed_Indirect_Selling_Units__c = (optyProdObj.Proposed_Indirect_Selling_Units__c != '' && optyProdObj.Proposed_Indirect_Selling_Units__c != undefined) ? optyProdObj.Proposed_Indirect_Selling_Units__c : 0;
            optyProdObj.Vision_Proposed_OS_Units__c = (optyProdObj.Vision_Proposed_OS_Units__c != '' && optyProdObj.Vision_Proposed_OS_Units__c != undefined) ? optyProdObj.Vision_Proposed_OS_Units__c : 0;
            optyProdObj.Vision_Proposed_RAD_Units__c = (optyProdObj.Vision_Proposed_RAD_Units__c != '' && optyProdObj.Vision_Proposed_RAD_Units__c != undefined) ? optyProdObj.Vision_Proposed_RAD_Units__c : 0;
            optyProdObj.Vision_Proposed_WMT_Units__c = (optyProdObj.Vision_Proposed_WMT_Units__c != '' && optyProdObj.Vision_Proposed_WMT_Units__c != undefined) ? optyProdObj.Vision_Proposed_WMT_Units__c : 0;
            optyProdObj.Vision_Proposed_BASE_Units__c = (optyProdObj.Vision_Proposed_BASE_Units__c != '' && optyProdObj.Vision_Proposed_BASE_Units__c != undefined) ? optyProdObj.Vision_Proposed_BASE_Units__c : 0;
            optyProdObj.Vision_Proposed_DSH_Units__c = (optyProdObj.Vision_Proposed_DSH_Units__c != '' && optyProdObj.Vision_Proposed_DSH_Units__c != undefined) ? optyProdObj.Vision_Proposed_DSH_Units__c : 0;
            optyProdObj.Vision_Proposed_AutoSub_Units__c = (optyProdObj.Vision_Proposed_AutoSub_Units__c != '' && optyProdObj.Vision_Proposed_AutoSub_Units__c != undefined) ? optyProdObj.Vision_Proposed_AutoSub_Units__c : 0;
            optyProdObj.Vision_Proposed_Smith_Drug_Units__c = (optyProdObj.Vision_Proposed_Smith_Drug_Units__c != '' && optyProdObj.Vision_Proposed_Smith_Drug_Units__c != undefined) ? optyProdObj.Vision_Proposed_Smith_Drug_Units__c : 0;
            optyProdObj.Vision_Proposed_Anda_Units__c = (optyProdObj.Vision_Proposed_Anda_Units__c != '' && optyProdObj.Vision_Proposed_Anda_Units__c != undefined) ? optyProdObj.Vision_Proposed_Anda_Units__c : 0;
            optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c = (optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c != '' && optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c != undefined) ? optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c : 0;
            optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c = (optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c != '' && optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c != undefined) ? optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c : 0;
            optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c = (optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c != '' && optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c != undefined) ? optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c : 0;
            
            optyProdObj.Vision_Proposed_Direct_ESI_Units__c = (optyProdObj.Vision_Proposed_Direct_ESI_Units__c != '' && optyProdObj.Vision_Proposed_Direct_ESI_Units__c != undefined) ? optyProdObj.Vision_Proposed_Direct_ESI_Units__c : 0;
            optyProdObj.Vision_Proposed_Indirect_ESI_Units__c = (optyProdObj.Vision_Proposed_Indirect_ESI_Units__c != '' && optyProdObj.Vision_Proposed_Indirect_ESI_Units__c != undefined) ? optyProdObj.Vision_Proposed_Indirect_ESI_Units__c : 0;
            optyProdObj.Vision_Proposed_Direct_Kroger_Units__c = (optyProdObj.Vision_Proposed_Direct_Kroger_Units__c != '' && optyProdObj.Vision_Proposed_Direct_Kroger_Units__c != undefined) ? optyProdObj.Vision_Proposed_Direct_Kroger_Units__c : 0;
            optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c = (optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c != '' && optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c != undefined) ? optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c : 0;
            optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c = (optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c != '' && optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c != undefined) ? optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c : 0;
            optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c = (optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c != '' && optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c != undefined) ? optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c : 0;
            optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c = (optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c != '' && optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c != undefined) ? optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c : 0;
            optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c = (optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c != '' && optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c != undefined) ? optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c : 0;
            optyProdObj.Vision_Proposed_Direct_Cigna_Units__c = (optyProdObj.Vision_Proposed_Direct_Cigna_Units__c != '' && optyProdObj.Vision_Proposed_Direct_Cigna_Units__c != undefined) ? optyProdObj.Vision_Proposed_Direct_Cigna_Units__c : 0;
            optyProdObj.Vision_Proposed_Indirect_Cigna_Units__c = (optyProdObj.Vision_Proposed_Indirect_Cigna_Units__c != '' && optyProdObj.Vision_Proposed_Indirect_Cigna_Units__c != undefined) ? optyProdObj.Vision_Proposed_Indirect_Cigna_Units__c : 0;
            optyProdObj.Vision_Proposed_Direct_Cordant_Units__c = (optyProdObj.Vision_Proposed_Direct_Cordant_Units__c != '' && optyProdObj.Vision_Proposed_Direct_Cordant_Units__c != undefined) ? optyProdObj.Vision_Proposed_Direct_Cordant_Units__c : 0;
            optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c = (optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c != '' && optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c != undefined) ? optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c : 0;
            optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c = (optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c != '' && optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c != undefined) ? optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c : 0;
            optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c = (optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c != '' && optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c != undefined) ? optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c : 0;
            optyProdObj.Vision_Total_Proposed_Units_EU__c = (optyProdObj.Vision_Total_Proposed_Units_EU__c != '' && optyProdObj.Vision_Total_Proposed_Units_EU__c != undefined) ? optyProdObj.Vision_Total_Proposed_Units_EU__c : 0;
            optyProdObj.Vision_Proposed_Value_EA__c = (optyProdObj.Vision_Proposed_Value_EA__c != '' && optyProdObj.Vision_Proposed_Value_EA__c != undefined) ? optyProdObj.Vision_Proposed_Value_EA__c : 0;
            
            optyProdObj.Vision_Proposed_CVS_Direct_Units__c = (optyProdObj.Vision_Proposed_CVS_Direct_Units__c != '' && optyProdObj.Vision_Proposed_CVS_Direct_Units__c != undefined) ? optyProdObj.Vision_Proposed_CVS_Direct_Units__c : 0;
            optyProdObj.Vision_Proposed_CVS_Indirect_Units__c = (optyProdObj.Vision_Proposed_CVS_Indirect_Units__c != '' && optyProdObj.Vision_Proposed_CVS_Indirect_Units__c != undefined) ? optyProdObj.Vision_Proposed_CVS_Indirect_Units__c : 0;
            optyProdObj.Vision_Proposed_Cardinal_Units__c = (optyProdObj.Vision_Proposed_Cardinal_Units__c != '' && optyProdObj.Vision_Proposed_Cardinal_Units__c != undefined) ? optyProdObj.Vision_Proposed_Cardinal_Units__c : 0;
            optyProdObj.Vision_Proposed_Major_Units__c = (optyProdObj.Vision_Proposed_Major_Units__c != '' && optyProdObj.Vision_Proposed_Major_Units__c != undefined) ? optyProdObj.Vision_Proposed_Major_Units__c : 0;
            
            totalProposedUnits = parseInt(optyProdObj.Proposed_Direct_Selling_Units__c)+parseInt(optyProdObj.Proposed_Indirect_Selling_Units__c)+parseInt(optyProdObj.Vision_Proposed_OS_Units__c)
            +parseInt(optyProdObj.Vision_Proposed_RAD_Units__c)+parseInt(optyProdObj.Vision_Proposed_WMT_Units__c)+parseInt(optyProdObj.Vision_Proposed_BASE_Units__c)+parseInt(optyProdObj.Vision_Proposed_DSH_Units__c)
            +parseInt(optyProdObj.Vision_Proposed_AutoSub_Units__c)+parseInt(optyProdObj.Vision_Proposed_Smith_Drug_Units__c)+parseInt(optyProdObj.Vision_Proposed_Anda_Units__c)+parseInt(optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c)
            +parseInt(optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c)+parseInt(optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c)+parseInt(optyProdObj.Vision_Proposed_Direct_ESI_Units__c)
            +parseInt(optyProdObj.Vision_Proposed_Indirect_ESI_Units__c)+parseInt(optyProdObj.Vision_Proposed_Direct_Kroger_Units__c)+parseInt(optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c)
            +parseInt(optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c)+parseInt(optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c)+parseInt(optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c)
            +parseInt(optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c)+parseInt(optyProdObj.Vision_Proposed_Direct_Cigna_Units__c)+parseInt(optyProdObj.Vision_Proposed_Indirect_Cigna_Units__c)
            +parseInt(optyProdObj.Vision_Proposed_Direct_Cordant_Units__c)+parseInt(optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c)+parseInt(optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c)
            +parseInt(optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c)+parseInt(optyProdObj.Vision_Proposed_CVS_Direct_Units__c)+parseInt(optyProdObj.Vision_Proposed_CVS_Indirect_Units__c)+parseInt(optyProdObj.Vision_Proposed_Cardinal_Units__c)+parseInt(optyProdObj.Vision_Proposed_Major_Units__c);
        }
        component.set("v.totalProposedUnits",totalProposedUnits);
        var optyProdObj = component.get("v.prodItem.optyProdObj");
        var optyObj = component.get("v.optyObj");
        if(!component.get("v.isPanMove"))
            var updatedPrice = optyProdObj.Vision_Guidance_Price__c != undefined ? optyProdObj.Vision_Guidance_Price__c : (optyProdObj.Product__r.Phoenix_Lowest_Price_SKU__c != undefined ? optyProdObj.Product__r.Phoenix_Lowest_Price_SKU__c : 1);
        else{
            var updatedPrice = (optyProdObj.Vision_Guidance_Price__c != undefined ? optyProdObj.Vision_Guidance_Price__c : (optyProdObj.Product__r.Vision_Panorama_Target_Price__c != undefined ? optyProdObj.Product__r.Vision_Panorama_Target_Price__c : 1));
        }
        component.set("v.prodItem.optyProdObj.Vision_Opportunity_Value__c", Math.round(updatedPrice * totalProposedUnits));
        //added by srimayee  Final_Exclusion_Customers__c
        var prodItem = component.get("v.prodItem");
        var finalCustlist;
        if(prodItem.optyProdObj.Secondary_Backup_Exclusion_Customers__c != null && prodItem.optyProdObj.Secondary_Backup_Exclusion_Customers__c != undefined){
            finalCustlist = prodItem.optyProdObj.Secondary_Backup_Exclusion_Customers__c.split(",");   
        }
        console.log('finalCustlist=='+finalCustlist);
        var isallCustMoved = [];
        var SuccessIcon = true;
        if(finalCustlist != null && finalCustlist != undefined){ 
            finalCustlist.forEach(function(item){
                // var bool = false;
                if(prodItem.optyProdObj.Final_Exclusion_Customers__c != null && prodItem.optyProdObj.Final_Exclusion_Customers__c != undefined){
                    if(!prodItem.optyProdObj.Final_Exclusion_Customers__c.includes(item) && SuccessIcon){
                        SuccessIcon  = false;
                    }
                }
                
            });
        }
        component.set("v.addCustIcon",SuccessIcon);
        
    },
    onBidTypeUpdate : function(component, event, helper){
        var val = event.getSource().get('v.value');
        console.log('value :: '+val);
        component.set("v.prodItem.optyProdObj.Vision_Bid_Type__c",val);
        component.set("v.isEditBidType",false);
        helper.updateRec(component, helper);
    },
    
    inlineEditBidType : function(component, event, helper){
        if(!component.get("v.isSentToBright"))
            component.set("v.isEditBidType",true);
    },
    
    closeinlineEditBidType : function(component, event, helper){
        component.set("v.isEditBidType",false);
    },
    
    handleMouseLeave : function(component, event, helper) {
        $A.util.addClass(component.find("divHelp"), 'slds-hide');
        /*var timer = component.get("v.timer");
        clearTimeout(timer);
        timer = setTimeout(function(){
            $A.util.addClass(component.find("divHelp"), 'slds-hide');
            clearTimeout(timer);
        }, 300);
        component.set("v.timer", timer);*/
    },
    addCustomers: function(component, event, helper) {
        component.set("v.showLoader",true);
      
        var ObjList = [];
        var prodItem = component.get("v.prodItem");
        /*  var secondaryList = prodItem.optyProdObj.Secondary_Backup_Exclusion_Customers__c.split(',');
        secondaryList.forEach(function(item){
            var items = {isSelected : (prodItem.optyProdObj.Final_Exclusion_Customers__c)!= null && (prodItem.optyProdObj.Final_Exclusion_Customers__c.includes(item)) ? true:false, custName: item};
            ObjList.push(items);
        });*/
        console.log('prodItem.optyProdObj.Id=='+prodItem.optyProdObj.Id)
        component.set("v.optyProdId",prodItem.optyProdObj.Id);
        var finalCustlist = prodItem.optyProdObj.Final_Exclusion_Customers__c;  
        component.set("v.addCust",true); 
        var getBidInfoAction = component.get("c.showSecondaryCustomers");
        getBidInfoAction.setParams({
            prodId: prodItem.optyProdObj.Product__c
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                 component.set("v.showLoader",false);
                console.log('responseWrapper=='+JSON.stringify(responseWrapper));
                responseWrapper.forEach(function(item){
                    var bool = false;
                    if(finalCustlist != null && finalCustlist != undefined)
                        bool = finalCustlist.includes(item.Phoenix_Account__r.Name);
                    var items = {isSelected : bool ? true:false,isDisabled : bool ? true:false, custName: item.Phoenix_Account__r.Name, units:item.Phoenix_12Months_Sales_Unit__c, contractPrice:item.Phoenix_Contract_Price__c, contractNumber:item.Phoenix_Contract_Number__c, position:item.Phoenix_Product_Position__c };
                    ObjList.push(items);
                    //  item['isSelected'] == false;
                    /* if(finalCustlist.includes(item.Phoenix_Account__r.Name)){
                        console.log('true');
                      item.isSelected == true;  
                    }*/
                });
                console.log('ObjList=='+JSON.stringify(ObjList));
                
                component.set("v.secondaryList",ObjList);
            }
            else{
                
                console.log('errot---'+JSON.stringify(response.getError()));
            }
            
        });
        $A.enqueueAction(getBidInfoAction);
    },
    showConfirmationPopup: function(component, event, helper){
        component.set("v.showConfirmation",true);
    },
    saveCustomer: function(component, event, helper) {
        var custNameList=[];
        var notSelectedcustNameList=[];
        var secondaryList = component.get("v.secondaryList");
        console.log('secondaryList=='+JSON.stringify(secondaryList));
        secondaryList.forEach(function(item){
            if(item.isSelected){
                custNameList.push(item.custName);
            }else{
                notSelectedcustNameList.push(item.custName);  
            }
        });
        var getBidInfoAction = component.get("c.saveCustomers");
        getBidInfoAction.setParams({
            custNameList : custNameList,
            notSelectedcustNameList : notSelectedcustNameList,
            optyProdId : component.get("v.optyProdId"),
            optyId: component.get("v.optyId")
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                component.set("v.showConfirmation",false);
                var prodItem = component.get("v.prodItem");
                prodItem.optyProdObj.Final_Exclusion_Customers__c = responseWrapper.Final_Exclusion_Customers__c;
                var prodItem = component.get("v.prodItem");
                var finalCustlist;
                if(prodItem.optyProdObj.Secondary_Backup_Exclusion_Customers__c != null && prodItem.optyProdObj.Secondary_Backup_Exclusion_Customers__c != undefined){
                    finalCustlist = prodItem.optyProdObj.Secondary_Backup_Exclusion_Customers__c.split(",");   
                }
                console.log('finalCustlist=='+finalCustlist);
                var isallCustMoved = [];
                var SuccessIcon = true;
                if(finalCustlist != null && finalCustlist != undefined){ 
                    finalCustlist.forEach(function(item){
                        // var bool = false;
                        if(prodItem.optyProdObj.Final_Exclusion_Customers__c != null && prodItem.optyProdObj.Final_Exclusion_Customers__c != undefined){
                            if(!prodItem.optyProdObj.Final_Exclusion_Customers__c.includes(item) && SuccessIcon){
                                SuccessIcon  = false;
                            }
                        }
                        
                    });
                }
                component.set("v.addCustIcon",SuccessIcon);
                var compEvent = component.getEvent("isCustEventMoved");
                compEvent.setParams({
                    "message" : SuccessIcon
                });
                compEvent.fire();  
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message":"These customer(s) have been successfully moved to the Final Exclusion Customer List."
                });
                toastEvent.fire();
                component.set("v.prodItem",prodItem);
                component.set("v.addCust",false); 
            }
            else{
                
                console.log('errot---'+JSON.stringify(response.getError()));
            }
            
        });
        $A.enqueueAction(getBidInfoAction);
    },
    closeModel: function(component, event, helper) {
        component.set("v.addCust",false); 
    },
    closeModelConfirmation: function(component, event, helper) {
        component.set("v.showConfirmation",false); 
    },
    handleMouseEnter : function(component, event, helper) {
        $A.util.removeClass(component.find("divHelp"), 'slds-hide');
    },
    togglePasswordHint : function(component, event, helper){
        $A.util.toggleClass(component.find("popUpHelpText"), 'slds-hide');
    },
    inlineEditGuidancePrice : function(component, event, helper){
        if(!component.get("v.isSentToBright"))
            component.set("v.GDPEditMode",true);
    },
    inlineEditComment : function(component, event, helper){
        if(!component.get("v.isSentToBright"))
            component.set("v.CommentEditMode",true);
    },
    closeGDPBox : function(component, event, helper){
        component.set("v.GDPEditMode",false);
    },
    closeCmtPBox : function(component, event, helper){
        component.set("v.CommentEditMode",false);
    },
    inlineEditProposedUnits : function(component, event, helper){
        if(!component.get("v.isSentToBright"))
            component.set("v.unitsEditMode",true);
    },
    inlineEditIndirectProposedUnits : function(component, event, helper){
        if(!component.get("v.isSentToBright"))
            component.set("v.inDirectUnitsEditMode",true);
    },
    inlineEditBaseUnits : function(component, event, helper){
        if(!component.get("v.isSentToBright"))
            component.set("v.baseUnitsEditMode",true);
    },
    closeBaseUnitsBox : function(component, event, helper){
        component.set("v.baseUnitsEditMode",false);
    },
    inlineEditdshUnits : function(component, event, helper){
        if(!component.get("v.isSentToBright"))
            component.set("v.dshUnitsEditMode",true);
    },
    closeDshUnitsBox : function(component, event, helper){
        component.set("v.dshUnitsEditMode",false);
    },
    inlineEditAutoSubUnits : function(component, event, helper){
        if(!component.get("v.isSentToBright"))
            component.set("v.autoSubUnitsEditMode",true);
    },
    closeAutoSubUnitsBox : function(component, event, helper){
        component.set("v.autoSubUnitsEditMode",false);
    },
    inlineEditSmithDrugUnits : function(component, event, helper){
        if(!component.get("v.isSentToBright"))
            component.set("v.smithDrugUnitsEditMode",true);
    },
    closeSmithDrugUnitsEditMode : function(component, event, helper){
        component.set("v.smithDrugUnitsEditMode",false);
    },
    inlineEditAndaUnits : function(component, event, helper){
        if(!component.get("v.isSentToBright"))
            component.set("v.andaUnitsEditMode",true);
    },
    closeAndaUnitsEditMode : function(component, event, helper){
        component.set("v.andaUnitsEditMode",false);
    },
    inlineEditAholdUnits : function(component, event, helper){
        if(!component.get("v.isSentToBright"))
            component.set("v.aholdUnitsEditMode",true);
    },
    closeAholdUnitsEditMode : function(component, event, helper){
        component.set("v.aholdUnitsEditMode",false);
    },
    inlineEditGaintEagleUnits : function(component, event, helper){
        if(!component.get("v.isSentToBright"))
            component.set("v.gaintEagleUnitsEditMode",true);
    },
    closeGaintEagleUnitsEditMode : function(component, event, helper){
        component.set("v.gaintEagleUnitsEditMode",false);
    },
    inlineEditTotalRetailUnits : function(component, event, helper){
        if(!component.get("v.isSentToBright"))
            component.set("v.totalRetailUnitsEditMode",true);
    },
    closeTotalRetailUnitsEditMode : function(component, event, helper){
        component.set("v.totalRetailUnitsEditMode",false);
    },
    
    closePropUnitsBox : function(component, event, helper){
        component.set("v.unitsEditMode",false);
    },
    closeIndirectPropUnitsBox : function(component, event, helper){
        component.set("v.inDirectUnitsEditMode",false);
    },
    closeOsPropUnitsBox : function(component, event, helper){
        component.set("v.osUnitsEditMode",false);
    },
    closeRadPropUnitsBox : function(component, event, helper){
        component.set("v.radUnitsEditMode",false);
    },
    closeWmtPropUnitsBox : function(component, event, helper){
        component.set("v.wmtUnitsEditMode",false);
    },
    getProDirectUnits: function (component, event, helper) {
        helper.updateRec(component, helper);
    },
    getProIndirectUnits: function (component, event, helper) {
        helper.updateRec(component, helper);
    },
    getGuiPrice: function (component, event, helper) {
        helper.updateRec(component, helper);
    },
    getComment: function (component, event, helper) {
        helper.updateRec(component, helper);
    },
    updateRecordCtrl : function (component, event, helper){
        helper.updateRec(component, helper);
    },
    inlineEditOsProposedUnits : function(component, event, helper){
        if(!component.get("v.isSentToBright"))
            component.set("v.osUnitsEditMode",true);
    },
    inlineEditRadProposedUnits : function(component, event, helper){
        if(!component.get("v.isSentToBright"))
            component.set("v.radUnitsEditMode",true);
    },
    inlineEditWmtProposedUnits : function(component, event, helper){
        if(!component.get("v.isSentToBright"))
            component.set("v.wmtUnitsEditMode",true);
    },
    getProOsUnits: function (component, event, helper) {
        helper.updateRec(component, helper);
    },
    getProRadUnits: function (component, event, helper) {
        helper.updateRec(component, helper);
    },
    getProWmtUnits: function (component, event, helper) {
        helper.updateRec(component, helper);
    },
    updateRecordFun : function(component, event, helper){
        helper.updateRec(component, helper);
    },
    removeDeletedRow: function(component, event, helper){
        component.set("v.isDeleteConfirm",true);
    },
    closeDelete:function(component, event, helper){
        component.set("v.isDeleteConfirm",false);
    },
    confirmDelete: function(component, event, helper){
        console.log('in removeDeletedRow');
        component.getEvent("DeleteRowEvt").setParams({"recordIdToDelete" : component.get("v.prodItem.optyProdObj.Id"),
                                                      "isDelete" : true}).fire();
        component.set("v.isDeleteConfirm",false);
    },
    checkBoxChangeHandler : function(component, event, helper){
        component.getEvent("DeleteRowEvt").setParams({"checkedRecordId" : component.get("v.prodItem.optyProdObj.Id"),
                                                      "isDelete" : false}).fire();
    },
    openScenarios : function(component, event, helper){
        console.log('inside openScenarios');
        var optyObj = component.get("v.optyObj");
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:Vision_BidSimulatorCmp",
            componentAttributes: {
                referenceContracts: optyObj.Vision_Reference_Contract__c,
                optyId: optyObj.Id,
                accId : optyObj.AccountId,
                prodId : component.get("v.prodItem").optyProdObj.Product__r.Id
            }
        });
        evt.fire();
    },
    showSAdetails : function(component, event, helper){
        //var listValues = event.currentTarget.id;
        //var resp = component.get("v.ndcList");
        //var scmApproved_Date = 'test';
		//component.set("v.scmApprovedDate",scmApproved_Date);
        document.getElementById(component.get("v.prodItem.optyProdObj.Id")+'contact').style.display="";
    },
    hideSAdetails : function(component, event, helper){
        document.getElementById(component.get("v.prodItem.optyProdObj.Id")+'contact').style.display="none";
        //var listValues = event.currentTarget.id;
        //document.getElementById(listValues+"contact").style.display="none";
    },
})