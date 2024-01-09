({
	updateRec : function(component, helper) {
        var templateType = component.get("v.templateType");
        var totalUnits = 0;
        var finImpact = 0;
        var totalCurrentUnits = 0;
        var currentPrice = 0;
        var optyProdObj = component.get("v.prodItem.optyProdObj");
        var optyObj = component.get("v.optyObj");
        /*if(templateType=='ClarusOne'){
            var osUnits = optyProdObj.Vision_Proposed_OS_Units__c != undefined ? optyProdObj.Vision_Proposed_OS_Units__c : 0;
            var radUnits = optyProdObj.Vision_Proposed_RAD_Units__c != undefined ? optyProdObj.Vision_Proposed_RAD_Units__c : 0;
            var wmtUnits = optyProdObj.Vision_Proposed_WMT_Units__c != undefined ? optyProdObj.Vision_Proposed_WMT_Units__c : 0;
            totalUnits = osUnits + radUnits + wmtUnits;
            component.set("v.totalProposedUnits",totalUnits);
            var currentOsUnits = optyProdObj.Vision_Current_OS_Units__c != undefined ? optyProdObj.Vision_Current_OS_Units__c :0;
            var currentRadUnits = optyProdObj.Vision_Current_RAD_units__c != undefined ? optyProdObj.Vision_Current_RAD_units__c :0;
            var currentWmtUnits = optyProdObj.Vision_Current_WMT_Units__c != undefined ? optyProdObj.Vision_Current_WMT_Units__c :0;
            totalCurrentUnits = currentOsUnits + currentRadUnits + currentWmtUnits;
        }
        else{
            var dirUnits = optyProdObj.Proposed_Direct_Selling_Units__c != undefined ? optyProdObj.Proposed_Direct_Selling_Units__c : 0;
            var indirUnits = optyProdObj.Proposed_Indirect_Selling_Units__c != undefined ? optyProdObj.Proposed_Indirect_Selling_Units__c : 0;
            totalUnits = dirUnits + indirUnits;
            
            var currentDirUnits = optyProdObj.Vision_Current_Direct_Units__c != undefined ? optyProdObj.Vision_Current_Direct_Units__c :0;
            var currentIndirUnits = optyProdObj.Current_Indirect_Selling_Units__c != undefined ? optyProdObj.Current_Indirect_Selling_Units__c :0;
            totalCurrentUnits = currentDirUnits + currentIndirUnits;
            
            var currentDirPrice = optyProdObj.Vision_Current_Direct_Price__c != undefined ? optyProdObj.Vision_Current_Direct_Price__c :0;
            var currentIndirPrice = optyProdObj.Vision_Current_Indirect_Price__c != undefined ? optyProdObj.Vision_Current_Indirect_Price__c :0;
            currentPrice = currentDirPrice +  currentIndirPrice;
            
        }
        var guidancePrice = optyProdObj.Vision_Guidance_Price__c;
        
        if(guidancePrice){
            component.set("v.prodItem.optyProdObj.Vision_Opportunity_Value__c", Math.round(totalUnits * guidancePrice));
        } 
        else if(currentPrice>0){
            component.set("v.prodItem.optyProdObj.Vision_Opportunity_Value__c", Math.round(totalUnits * currentPrice));
        } 
        else{
            component.set("v.prodItem.optyProdObj.Vision_Opportunity_Value__c", Math.round(totalUnits * optyProdObj.Lowest_Price_SKU__c));
        }
        
        if(component.get("v.optyObj.Bid_Type__c") == 'Price Change'){
            finImpact = totalCurrentUnits * (guidancePrice - currentPrice);
        }
        else{
            finImpact = currentPrice * (totalUnits - totalCurrentUnits);
        }
        component.set("v.prodItem.optyProdObj.Vision_Financial_Impact__c",finImpact);
        */
        var updatedPrice = 0;
        //if(component.get("v.isPanMove"))
        //    updatedPrice = (optyProdObj.Vision_Panorama_Target_Price__c != undefined && optyProdObj.Vision_Panorama_Target_Price__c > 0) ? optyProdObj.Vision_Panorama_Target_Price__c : (optyProdObj.Vision_Guidance_Price__c != undefined ? optyProdObj.Vision_Guidance_Price__c : (optyProdObj.Product__r.Phoenix_Lowest_Price_SKU__c != undefined ? optyProdObj.Product__r.Phoenix_Lowest_Price_SKU__c : 1));
       // else
        updatedPrice = optyProdObj.Vision_Guidance_Price__c != undefined ? optyProdObj.Vision_Guidance_Price__c : (optyProdObj.Product__r.Phoenix_Lowest_Price_SKU__c != undefined ? optyProdObj.Product__r.Phoenix_Lowest_Price_SKU__c : 1);
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
            +parseInt(optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c)+parseInt(optyProdObj.Vision_Proposed_CVS_Direct_Units__c)+parseInt(optyProdObj.Vision_Proposed_CVS_Indirect_Units__c)
            +parseInt(optyProdObj.Vision_Proposed_Cardinal_Units__c)+parseInt(optyProdObj.Vision_Proposed_Major_Units__c);
        }
        component.set("v.totalProposedUnits",totalProposedUnits);
        component.set("v.prodItem.optyProdObj.Vision_Opportunity_Value__c", Math.round(updatedPrice * totalProposedUnits));
        var action = component.get("c.saveOptyDetPageChanges");
        action.setParams({
            optyId: component.get('v.optyId'),
            prodOptyRec: component.get('v.prodItem.optyProdObj')
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log("response.getReturnValue() :: "+response.getReturnValue());
                component.set("v.optyVal",response.getReturnValue());
                } else{
                    console.log("Error "+JSON.stringify(response.getError()));
                }
            });
        $A.enqueueAction(action);
	}
})