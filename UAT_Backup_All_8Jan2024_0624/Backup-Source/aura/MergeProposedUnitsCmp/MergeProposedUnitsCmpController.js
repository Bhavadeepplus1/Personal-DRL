({
	doInit : function(component, event, helper) {
        var dupListItems = component.get("v.dupList");
        
        var listITems = [];
        dupListItems.forEach(function(optyProd){
            optyProd = validateItems(optyProd);
            console.log('Vision_Proposed_Direct_ESI_Units__c BEFORE --> '+optyProd.Vision_Proposed_Direct_ESI_Units__c);
            console.log('Vision_Disc_Pkg_Size__c --> '+optyProd.Vision_Disc_Pkg_Size__c);
            console.log('Phoenix_Pkg_Size__c --> '+optyProd.Product__r.Phoenix_Pkg_Size__c);
            if(!isNaN(optyProd.Vision_Disc_Pkg_Size__c) && optyProd.Product__r.Phoenix_Pkg_Size__c != undefined && optyProd.Product__r.Phoenix_Pkg_Size__c != 0)
                optyProd = calculateItems(optyProd,optyProd.Vision_Disc_Pkg_Size__c,optyProd.Product__r.Phoenix_Pkg_Size__c);
            console.log('Vision_Proposed_Direct_ESI_Units__c AFTER --> '+optyProd.Vision_Proposed_Direct_ESI_Units__c);
            optyProd.isSelected = false;
            listITems.push(optyProd);
        });
        component.set("v.calcList",listITems);
        function calculateItems(optyProd,OptypackSize,packSize){
            optyProd.Vision_Proposed_Units__c = Math.round((optyProd.Vision_Proposed_Units__c*OptypackSize)/packSize);
            optyProd.Proposed_Direct_Selling_Units__c = Math.round((optyProd.Proposed_Direct_Selling_Units__c*OptypackSize)/packSize);
            optyProd.Proposed_Indirect_Selling_Units__c = Math.round((optyProd.Proposed_Indirect_Selling_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_OS_Units__c = Math.round((optyProd.Vision_Proposed_OS_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_RAD_Units__c = Math.round((optyProd.Vision_Proposed_RAD_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_WMT_Units__c = Math.round((optyProd.Vision_Proposed_WMT_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_BASE_Units__c = Math.round((optyProd.Vision_Proposed_BASE_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_DSH_Units__c = Math.round((optyProd.Vision_Proposed_DSH_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_AutoSub_Units__c = Math.round((optyProd.Vision_Proposed_AutoSub_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_Smith_Drug_Units__c = Math.round((optyProd.Vision_Proposed_Smith_Drug_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_Anda_Units__c = Math.round((optyProd.Vision_Proposed_Anda_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c = Math.round((optyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c = Math.round((optyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_TotalRetailIndirectUnits__c = Math.round((optyProd.Vision_Proposed_TotalRetailIndirectUnits__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_Direct_ESI_Units__c = Math.round((optyProd.Vision_Proposed_Direct_ESI_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_Indirect_ESI_Units__c = Math.round((optyProd.Vision_Proposed_Indirect_ESI_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_Direct_Kroger_Units__c = Math.round((optyProd.Vision_Proposed_Direct_Kroger_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_Indirect_Kroger_Units__c = Math.round((optyProd.Vision_Proposed_Indirect_Kroger_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c = Math.round((optyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_IndirectRxOutreach_Units__c = Math.round((optyProd.Vision_Proposed_IndirectRxOutreach_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_Direct_Supervalu_Units__c = Math.round((optyProd.Vision_Proposed_Direct_Supervalu_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_Indirect_Supervalu_Units__c = Math.round((optyProd.Vision_Proposed_Indirect_Supervalu_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_Direct_Cigna_Units__c = Math.round((optyProd.Vision_Proposed_Direct_Cigna_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_Indirect_Cigna_Units__c = Math.round((optyProd.Vision_Proposed_Indirect_Cigna_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_Direct_Cordant_Units__c = Math.round((optyProd.Vision_Proposed_Direct_Cordant_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_Indirect_Cordant_Units__c = Math.round((optyProd.Vision_Proposed_Indirect_Cordant_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_Direct_Accerodo_Units__c = Math.round((optyProd.Vision_Proposed_Direct_Accerodo_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_Indirect_Accerodo_Units__c = Math.round((optyProd.Vision_Proposed_Indirect_Accerodo_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_CVS_Direct_Units__c = Math.round((optyProd.Vision_Proposed_CVS_Direct_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_CVS_Indirect_Units__c = Math.round((optyProd.Vision_Proposed_CVS_Indirect_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_Cardinal_Units__c = Math.round((optyProd.Vision_Proposed_Cardinal_Units__c*OptypackSize)/packSize);
            optyProd.Vision_Proposed_Major_Units__c = Math.round((optyProd.Vision_Proposed_Major_Units__c*OptypackSize)/packSize);
            return optyProd;
        }
        function validateItems(optyProdObj){
            optyProdObj.Vision_Proposed_Units__c = (optyProdObj.Vision_Proposed_Units__c != '' && optyProdObj.Vision_Proposed_Units__c != undefined) ? optyProdObj.Vision_Proposed_Units__c : 0;
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
            
            return optyProdObj;
        }
	},
    checkBoxChangeHandler : function(component, event, helper){
        var VisionProposedVolume = 0;
        var ProposedDirectSellingUnits = 0;
        var ProposedIndirectSellingUnits = 0;
        var VisionProposedOSUnits = 0;
        var VisionProposedRADUnits = 0;
        var VisionProposedWMTUnits = 0;
        var VisionProposedBASEUnits = 0;
        var VisionProposedDSHUnits = 0;
        var VisionProposedAutoSubUnits = 0;
        var VisionProposedSmithDrugUnits = 0;
        var VisionProposedAndaUnits = 0;
        var VisionProposedDirectAholdDelhaizeUnits = 0;
        var VisionProposedDirectGaintEagleUnits = 0;
        var VisionProposedTotalRetailIndirectUnits = 0;
        var VisionProposedDirectESIUnits = 0;
        var VisionProposedIndirectESIUnits = 0;
        var VisionProposedDirectKrogerUnits = 0;
        var VisionProposedIndirectKrogerUnits = 0;
        var VisionProposedDirectRxOutreachUnits = 0;
        var VisionProposedIndirectRxOutreachUnits = 0;
        var VisionProposedDirectSupervaluUnits = 0;
        var VisionProposedIndirectSupervaluUnits = 0;
        var VisionProposedDirectCignaUnits = 0;
        var VisionProposedIndirectCignaUnits = 0;
        var VisionProposedDirectCordantUnits = 0;
        var VisionProposedDirectAccerodoUnits = 0;
        var VisionProposedIndirectAccerodoUnits = 0;
        var VisionProposedIndirectCordantUnits = 0;
        var VisionTotalProposedUnitsEU = 0;
        var VisionProposedValueEA = 0;
        var VisionProposedCVSDirectUnits = 0;
        var VisionProposedCVSIndirectUnits = 0;
        var VisionProposedCardinalUnits = 0;
        var VisionProposedMajorUnits = 0;
        
        var calcList = component.get("v.calcList");
        var i = 0;
        calcList.forEach(function(item){
            if(item.isSelected){
                i++;
                VisionProposedVolume += parseInt(item.Vision_Proposed_Units__c);
                ProposedDirectSellingUnits += parseInt(item.Proposed_Direct_Selling_Units__c);
                ProposedIndirectSellingUnits += parseInt(item.Proposed_Indirect_Selling_Units__c);
                VisionProposedOSUnits += parseInt(item.Vision_Proposed_OS_Units__c);
                VisionProposedRADUnits += parseInt(item.Vision_Proposed_RAD_Units__c);
                VisionProposedWMTUnits += parseInt(item.Vision_Proposed_WMT_Units__c);
                VisionProposedBASEUnits += parseInt(item.Vision_Proposed_BASE_Units__c);
                VisionProposedDSHUnits += parseInt(item.Vision_Proposed_DSH_Units__c);
                VisionProposedAutoSubUnits += parseInt(item.Vision_Proposed_AutoSub_Units__c);
                VisionProposedSmithDrugUnits += parseInt(item.Vision_Proposed_Smith_Drug_Units__c);
                VisionProposedAndaUnits += parseInt(item.Vision_Proposed_Anda_Units__c);
                VisionProposedDirectAholdDelhaizeUnits += parseInt(item.Vision_Proposed_DirectAholdDelhaizeUnits__c);
                VisionProposedDirectGaintEagleUnits += parseInt(item.Vision_Proposed_Direct_Gaint_Eagle_Units__c);
                VisionProposedTotalRetailIndirectUnits += parseInt(item.Vision_Proposed_TotalRetailIndirectUnits__c);
                VisionProposedDirectESIUnits += parseInt(item.Vision_Proposed_Direct_ESI_Units__c);
                VisionProposedIndirectESIUnits += parseInt(item.Vision_Proposed_Indirect_ESI_Units__c);
                VisionProposedDirectKrogerUnits += parseInt(item.Vision_Proposed_Direct_Kroger_Units__c);
                VisionProposedIndirectKrogerUnits += parseInt(item.Vision_Proposed_Indirect_Kroger_Units__c);
                VisionProposedDirectRxOutreachUnits += parseInt(item.Vision_Proposed_Direct_Rx_Outreach_Units__c);
                VisionProposedIndirectRxOutreachUnits += parseInt(item.Vision_Proposed_IndirectRxOutreach_Units__c);
                VisionProposedDirectSupervaluUnits += parseInt(item.Vision_Proposed_Direct_Supervalu_Units__c);
                VisionProposedIndirectSupervaluUnits += parseInt(item.Vision_Proposed_Indirect_Supervalu_Units__c);
                VisionProposedDirectCignaUnits += parseInt(item.Vision_Proposed_Direct_Cigna_Units__c);
                VisionProposedIndirectCignaUnits += parseInt(item.Vision_Proposed_Indirect_Cigna_Units__c);
                VisionProposedDirectCordantUnits += parseInt(item.Vision_Proposed_Direct_Cordant_Units__c);
                VisionProposedDirectAccerodoUnits += parseInt(item.Vision_Proposed_Direct_Accerodo_Units__c);
                VisionProposedIndirectAccerodoUnits += parseInt(item.Vision_Proposed_Indirect_Accerodo_Units__c);
                VisionProposedIndirectCordantUnits += parseInt(item.Vision_Proposed_Indirect_Cordant_Units__c);
                VisionTotalProposedUnitsEU += parseInt(item.Vision_Total_Proposed_Units_EU__c);
                VisionProposedValueEA += parseInt(item.Vision_Proposed_Value_EA__c);
                VisionProposedCVSDirectUnits += parseInt(item.Vision_Proposed_CVS_Direct_Units__c);
                VisionProposedCVSIndirectUnits += parseInt(item.Vision_Proposed_CVS_Indirect_Units__c);
                VisionProposedCardinalUnits += parseInt(item.Vision_Proposed_Cardinal_Units__c);
                VisionProposedMajorUnits += parseInt(item.Vision_Proposed_Major_Units__c);
            }
        });
        
        component.set("v.disableSaveButton",(i == 0) ? true : false);
        
        component.set("v.VisionProposedVolume",VisionProposedVolume);
        component.set("v.ProposedDirectSellingUnits",ProposedDirectSellingUnits);
        component.set("v.ProposedIndirectSellingUnits",ProposedIndirectSellingUnits);
        component.set("v.VisionProposedOSUnits",VisionProposedOSUnits);
        component.set("v.VisionProposedRADUnits",VisionProposedRADUnits);
        component.set("v.VisionProposedWMTUnits",VisionProposedWMTUnits);
        component.set("v.VisionProposedBASEUnits",VisionProposedBASEUnits);
        component.set("v.VisionProposedDSHUnits",VisionProposedDSHUnits);
        component.set("v.VisionProposedAutoSubUnits",VisionProposedAutoSubUnits);
        component.set("v.VisionProposedSmithDrugUnits",VisionProposedSmithDrugUnits);
        component.set("v.VisionProposedAndaUnits",VisionProposedAndaUnits);
        component.set("v.VisionProposedDirectAholdDelhaizeUnits",VisionProposedDirectAholdDelhaizeUnits);
        component.set("v.VisionProposedDirectGaintEagleUnits",VisionProposedDirectGaintEagleUnits);
        component.set("v.VisionProposedTotalRetailIndirectUnits",VisionProposedTotalRetailIndirectUnits);
        component.set("v.VisionProposedDirectESIUnits",VisionProposedDirectESIUnits);
        component.set("v.VisionProposedIndirectESIUnits",VisionProposedIndirectESIUnits);
        component.set("v.VisionProposedDirectKrogerUnits",VisionProposedDirectKrogerUnits);
        component.set("v.VisionProposedIndirectKrogerUnits",VisionProposedIndirectKrogerUnits);
        component.set("v.VisionProposedDirectRxOutreachUnits",VisionProposedDirectRxOutreachUnits);
        component.set("v.VisionProposedIndirectRxOutreachUnits",VisionProposedIndirectRxOutreachUnits);
        component.set("v.VisionProposedDirectSupervaluUnits",VisionProposedDirectSupervaluUnits);
        component.set("v.VisionProposedIndirectSupervaluUnits",VisionProposedIndirectSupervaluUnits);
        component.set("v.VisionProposedDirectCignaUnits",VisionProposedDirectCignaUnits);
        component.set("v.VisionProposedIndirectCignaUnits",VisionProposedIndirectCignaUnits);
        component.set("v.VisionProposedDirectCordantUnits",VisionProposedDirectCordantUnits);
        component.set("v.VisionProposedDirectAccerodoUnits",VisionProposedDirectAccerodoUnits);
        component.set("v.VisionProposedIndirectAccerodoUnits",VisionProposedIndirectAccerodoUnits);
        component.set("v.VisionProposedIndirectCordantUnits",VisionProposedIndirectCordantUnits);
        component.set("v.VisionTotalProposedUnitsEU",VisionTotalProposedUnitsEU);
        component.set("v.VisionProposedValueEA",VisionProposedValueEA);
        component.set("v.VisionProposedCVSDirectUnits",VisionProposedCVSDirectUnits);
        component.set("v.VisionProposedCVSIndirectUnits",VisionProposedCVSIndirectUnits);
        component.set("v.VisionProposedCardinalUnits",VisionProposedCardinalUnits);
        component.set("v.VisionProposedMajorUnits",VisionProposedMajorUnits);
    },
    saveAndMOveToMatch : function(component, event, helper){
        var optyProd = component.get("v.dupList")[0];
        optyProd.Proposed_Direct_Selling_Units__c = component.get("v.ProposedDirectSellingUnits"); 
        optyProd.Proposed_Indirect_Selling_Units__c = component.get("v.ProposedIndirectSellingUnits");   
        optyProd.Vision_Proposed_OS_Units__c = component.get("v.VisionProposedOSUnits");   
        optyProd.Vision_Proposed_RAD_Units__c = component.get("v.VisionProposedRADUnits");   
        optyProd.Vision_Proposed_WMT_Units__c = component.get("v.VisionProposedWMTUnits");   
        optyProd.Vision_Proposed_BASE_Units__c = component.get("v.VisionProposedBASEUnits");   
        optyProd.Vision_Proposed_DSH_Units__c = component.get("v.VisionProposedDSHUnits");   
        optyProd.Vision_Proposed_AutoSub_Units__c = component.get("v.VisionProposedAutoSubUnits");   
        optyProd.Vision_Proposed_Smith_Drug_Units__c = component.get("v.VisionProposedSmithDrugUnits");   
        optyProd.Vision_Proposed_Anda_Units__c = component.get("v.VisionProposedAndaUnits");   
        optyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c = component.get("v.VisionProposedDirectAholdDelhaizeUnits");   
        optyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c = component.get("v.VisionProposedDirectGaintEagleUnits");   
        optyProd.Vision_Proposed_TotalRetailIndirectUnits__c = component.get("v.VisionProposedTotalRetailIndirectUnits");   
        
        optyProd.Vision_Proposed_Direct_ESI_Units__c = component.get("v.VisionProposedDirectESIUnits");   
        optyProd.Vision_Proposed_Indirect_ESI_Units__c = component.get("v.VisionProposedIndirectESIUnits");   
        optyProd.Vision_Proposed_Direct_Kroger_Units__c = component.get("v.VisionProposedDirectKrogerUnits");   
        optyProd.Vision_Proposed_Indirect_Kroger_Units__c = component.get("v.VisionProposedIndirectKrogerUnits");   
        optyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c = component.get("v.VisionProposedDirectRxOutreachUnits");   
        optyProd.Vision_Proposed_IndirectRxOutreach_Units__c = component.get("v.VisionProposedIndirectRxOutreachUnits");   
        optyProd.Vision_Proposed_Direct_Supervalu_Units__c = component.get("v.VisionProposedDirectSupervaluUnits");   
        optyProd.Vision_Proposed_Indirect_Supervalu_Units__c = component.get("v.VisionProposedIndirectSupervaluUnits");   
        optyProd.Vision_Proposed_Direct_Cigna_Units__c = component.get("v.VisionProposedDirectCignaUnits");   
        optyProd.Vision_Proposed_Indirect_Cigna_Units__c = component.get("v.VisionProposedIndirectCignaUnits");   
        optyProd.Vision_Proposed_Direct_Cordant_Units__c = component.get("v.VisionProposedDirectCordantUnits");   
        optyProd.Vision_Proposed_Indirect_Cordant_Units__c = component.get("v.VisionProposedIndirectCordantUnits");    
        optyProd.Vision_Proposed_Direct_Accerodo_Units__c = component.get("v.VisionProposedDirectAccerodoUnits");   
        optyProd.Vision_Proposed_Indirect_Accerodo_Units__c = component.get("v.VisionProposedIndirectAccerodoUnits");   
        
        optyProd.Vision_Proposed_CVS_Direct_Units__c = component.get("v.VisionProposedCVSDirectUnits");   
        optyProd.Vision_Proposed_CVS_Indirect_Units__c = component.get("v.VisionProposedCVSIndirectUnits");   
        optyProd.Vision_Proposed_Cardinal_Units__c = component.get("v.VisionProposedCardinalUnits");    
        optyProd.Vision_Proposed_Major_Units__c = component.get("v.VisionProposedMajorUnits");
        var totalProposedUnits = 0;
        totalProposedUnits = parseInt(component.get("v.ProposedDirectSellingUnits"))+parseInt(component.get("v.ProposedIndirectSellingUnits"))
        +parseInt(component.get("v.VisionProposedOSUnits"))+parseInt(component.get("v.VisionProposedRADUnits"))+parseInt(component.get("v.VisionProposedWMTUnits"))
        +parseInt(component.get("v.VisionProposedBASEUnits"))+parseInt(component.get("v.VisionProposedDSHUnits"))+parseInt(component.get("v.VisionProposedAutoSubUnits"))
        +parseInt(component.get("v.VisionProposedSmithDrugUnits"))+parseInt(component.get("v.VisionProposedAndaUnits"))+parseInt(component.get("v.VisionProposedDirectAholdDelhaizeUnits"))
        +parseInt(component.get("v.VisionProposedDirectGaintEagleUnits"))+parseInt(component.get("v.VisionProposedTotalRetailIndirectUnits"))+parseInt(component.get("v.VisionProposedDirectESIUnits"))
        +parseInt(component.get("v.VisionProposedIndirectESIUnits"))+parseInt(component.get("v.VisionProposedDirectKrogerUnits"))+parseInt(component.get("v.VisionProposedIndirectKrogerUnits"))
        +parseInt(component.get("v.VisionProposedDirectRxOutreachUnits"))+parseInt(component.get("v.VisionProposedIndirectRxOutreachUnits"))+parseInt(component.get("v.VisionProposedDirectSupervaluUnits"))
        +parseInt(component.get("v.VisionProposedIndirectSupervaluUnits"))+parseInt(component.get("v.VisionProposedDirectCignaUnits"))+parseInt(component.get("v.VisionProposedIndirectCignaUnits"))
        +parseInt(component.get("v.VisionProposedDirectCordantUnits"))+parseInt(component.get("v.VisionProposedDirectAccerodoUnits"))+parseInt(component.get("v.VisionProposedIndirectAccerodoUnits"))
        +parseInt(component.get("v.VisionProposedIndirectCordantUnits"))+parseInt(component.get("v.VisionProposedCVSDirectUnits"))+parseInt(component.get("v.VisionProposedCVSIndirectUnits"))
        +parseInt(component.get("v.VisionProposedCardinalUnits"))+parseInt(component.get("v.VisionProposedMajorUnits"));
        optyProd.Vision_Total_Annual_Units__c = totalProposedUnits;
        
        var action = component.get("c.updateWithNewProd");
        action.setParams({optyProdStr:JSON.stringify(optyProd),
                          selectedProdId:optyProd.Product__r.Id});
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state from getProdList --> '+state);
            if(state == 'SUCCESS')
                component.set("v.refreshScreen",component.get("v.refreshScreen")?false:true);
            else
                console.log('Error--->'+JSON.stringify(response.getError()));
        });
        $A.enqueueAction(action);
    },
    closePopup  : function(component, event, helper){
        component.set("v.showMergePopup",false);
    },
    showHideUploaded : function(component, event, helper){
        component.set("v.showUploadedCols",component.get("v.showUploadedCols")?false:true);
    },
})