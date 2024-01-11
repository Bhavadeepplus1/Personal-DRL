({
	getUpdatedTotalPropUnits : function(component, event, helper) {
        var optyProdObj = component.get("v.prodOptyObj");
        
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
        component.set("v.prodOptyObj",optyProdObj);
        var packSize = component.get("v.prodObj").Phoenix_Pkg_Size__c;
        var OptypackSize = optyProdObj.Vision_Disc_Pkg_Size__c;
        
        helper.calculateProposedUnits(component, event, helper, optyProdObj, OptypackSize, packSize);
        
    },
    
    calculateProposedUnits : function(component, event, helper, optyProd, OptypackSize, packSize){
        /*optyProd.Proposed_Direct_Selling_Units__c = optyProd.Proposed_Direct_Selling_Units__c != undefined ? Math.round((optyProd.Proposed_Direct_Selling_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Proposed_Indirect_Selling_Units__c = optyProd.Proposed_Indirect_Selling_Units__c != undefined ? Math.round((optyProd.Proposed_Indirect_Selling_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_OS_Units__c = optyProd.Vision_Proposed_OS_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_OS_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_RAD_Units__c = optyProd.Vision_Proposed_RAD_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_RAD_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_WMT_Units__c = optyProd.Vision_Proposed_WMT_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_WMT_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_BASE_Units__c = optyProd.Vision_Proposed_BASE_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_BASE_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_DSH_Units__c = optyProd.Vision_Proposed_DSH_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_DSH_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_AutoSub_Units__c = optyProd.Vision_Proposed_AutoSub_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_AutoSub_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_Smith_Drug_Units__c = optyProd.Vision_Proposed_Smith_Drug_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Smith_Drug_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_Anda_Units__c = optyProd.Vision_Proposed_Anda_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Anda_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c = optyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c != undefined ? Math.round((optyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c = optyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_TotalRetailIndirectUnits__c = optyProd.Vision_Proposed_TotalRetailIndirectUnits__c != undefined ? Math.round((optyProd.Vision_Proposed_TotalRetailIndirectUnits__c*OptypackSize)/packSize) : 0;
        
        optyProd.Vision_Proposed_Direct_ESI_Units__c = optyProd.Vision_Proposed_Direct_ESI_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Direct_ESI_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_Indirect_ESI_Units__c = optyProd.Vision_Proposed_Indirect_ESI_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Indirect_ESI_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_Direct_Kroger_Units__c = optyProd.Vision_Proposed_Direct_Kroger_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Direct_Kroger_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_Indirect_Kroger_Units__c = optyProd.Vision_Proposed_Indirect_Kroger_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Indirect_Kroger_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c = optyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_IndirectRxOutreach_Units__c = optyProd.Vision_Proposed_IndirectRxOutreach_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_IndirectRxOutreach_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_Direct_Supervalu_Units__c = optyProd.Vision_Proposed_Direct_Supervalu_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Direct_Supervalu_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_Indirect_Supervalu_Units__c = optyProd.Vision_Proposed_Indirect_Supervalu_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Indirect_Supervalu_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_Direct_Cigna_Units__c = optyProd.Vision_Proposed_Direct_Cigna_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Direct_Cigna_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_Indirect_Cigna_Units__c = optyProd.Vision_Proposed_Indirect_Cigna_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Indirect_Cigna_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_Direct_Cordant_Units__c = optyProd.Vision_Proposed_Direct_Cordant_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Direct_Cordant_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_Indirect_Cordant_Units__c = optyProd.Vision_Proposed_Indirect_Cordant_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Indirect_Cordant_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_Direct_Accerodo_Units__c = optyProd.Vision_Proposed_Direct_Accerodo_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Direct_Accerodo_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_Indirect_Accerodo_Units__c = optyProd.Vision_Proposed_Indirect_Accerodo_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Indirect_Accerodo_Units__c*OptypackSize)/packSize) : 0;
        
        optyProd.Vision_Proposed_CVS_Direct_Units__c = optyProd.Vision_Proposed_CVS_Direct_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_CVS_Direct_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_CVS_Indirect_Units__c = optyProd.Vision_Proposed_CVS_Indirect_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_CVS_Indirect_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_Cardinal_Units__c = optyProd.Vision_Proposed_Cardinal_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Cardinal_Units__c*OptypackSize)/packSize) : 0;
        optyProd.Vision_Proposed_Major_Units__c = optyProd.Vision_Proposed_Major_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Major_Units__c*OptypackSize)/packSize) : 0;*/
        component.set("v.VisionProposedVolume",optyProd.Vision_Proposed_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.ProposedDirectSellingUnits",optyProd.Proposed_Direct_Selling_Units__c != undefined ? Math.round((optyProd.Proposed_Direct_Selling_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.ProposedIndirectSellingUnits",optyProd.Proposed_Indirect_Selling_Units__c != undefined ? Math.round((optyProd.Proposed_Indirect_Selling_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedOSUnits",optyProd.Vision_Proposed_OS_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_OS_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedRADUnits",optyProd.Vision_Proposed_RAD_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_RAD_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedWMTUnits",optyProd.Vision_Proposed_WMT_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_WMT_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedBASEUnits",optyProd.Vision_Proposed_BASE_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_BASE_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedDSHUnits",optyProd.Vision_Proposed_DSH_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_DSH_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedAutoSubUnits",optyProd.Vision_Proposed_AutoSub_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_AutoSub_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedSmithDrugUnits",optyProd.Vision_Proposed_Smith_Drug_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Smith_Drug_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedAndaUnits",optyProd.Vision_Proposed_Anda_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Anda_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedDirectAholdDelhaizeUnits",optyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c != undefined ? Math.round((optyProd.Vision_Proposed_DirectAholdDelhaizeUnits__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedDirectGaintEagleUnits",optyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Direct_Gaint_Eagle_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedTotalRetailIndirectUnits",optyProd.Vision_Proposed_TotalRetailIndirectUnits__c != undefined ? Math.round((optyProd.Vision_Proposed_TotalRetailIndirectUnits__c*OptypackSize)/packSize) : 0);
        
        component.set("v.VisionProposedDirectESIUnits",optyProd.Vision_Proposed_Direct_ESI_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Direct_ESI_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedIndirectESIUnits",optyProd.Vision_Proposed_Indirect_ESI_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Indirect_ESI_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedDirectKrogerUnits",optyProd.Vision_Proposed_Direct_Kroger_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Direct_Kroger_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedIndirectKrogerUnits",optyProd.Vision_Proposed_Indirect_Kroger_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Indirect_Kroger_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedDirectRxOutreachUnits",optyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Direct_Rx_Outreach_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedIndirectRxOutreachUnits",optyProd.Vision_Proposed_IndirectRxOutreach_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_IndirectRxOutreach_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedDirectSupervaluUnits",optyProd.Vision_Proposed_Direct_Supervalu_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Direct_Supervalu_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedIndirectSupervaluUnits",optyProd.Vision_Proposed_Indirect_Supervalu_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Indirect_Supervalu_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedDirectCignaUnits",optyProd.Vision_Proposed_Direct_Cigna_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Direct_Cigna_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedIndirectCignaUnits",optyProd.Vision_Proposed_Indirect_Cigna_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Indirect_Cigna_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedDirectCordantUnits",optyProd.Vision_Proposed_Direct_Cordant_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Direct_Cordant_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedIndirectCordantUnits", optyProd.Vision_Proposed_Indirect_Cordant_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Indirect_Cordant_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedDirectAccerodoUnits",optyProd.Vision_Proposed_Direct_Accerodo_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Direct_Accerodo_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedIndirectAccerodoUnits",optyProd.Vision_Proposed_Indirect_Accerodo_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Indirect_Accerodo_Units__c*OptypackSize)/packSize) : 0);
        
        component.set("v.VisionProposedCVSDirectUnits",optyProd.Vision_Proposed_CVS_Direct_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_CVS_Direct_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedCVSIndirectUnits",optyProd.Vision_Proposed_CVS_Indirect_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_CVS_Indirect_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedCardinalUnits", optyProd.Vision_Proposed_Cardinal_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Cardinal_Units__c*OptypackSize)/packSize) : 0);
        component.set("v.VisionProposedMajorUnits", optyProd.Vision_Proposed_Major_Units__c != undefined ? Math.round((optyProd.Vision_Proposed_Major_Units__c*OptypackSize)/packSize) : 0);
        var totalProposedUnits = 0;
        if(!component.get("v.isOtcProdFam")){
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
        }
        else{
            totalProposedUnits = (parseInt(component.get("v.VisionProposedVolume"))*optyProd.Vision_Proposed_Share_Percentage__c)/100;
        }
        component.set("v.totalProposedUnits",totalProposedUnits);
        //uploadedCalcUnits(component, optyProd);parseInt(component.get("v.VisionProposedVolume"))+
    },
    
    uploadedCalcUnits : function(component, optyProdObj){
        component.set("v.VisionProposedVolume",optyProdObj.Vision_Proposed_Units__c);
        component.set("v.ProposedDirectSellingUnits",optyProdObj.Proposed_Direct_Selling_Units__c);
        component.set("v.ProposedIndirectSellingUnits",optyProdObj.Proposed_Indirect_Selling_Units__c);
        component.set("v.VisionProposedOSUnits",optyProdObj.Vision_Proposed_OS_Units__c);
        component.set("v.VisionProposedRADUnits",optyProdObj.Vision_Proposed_RAD_Units__c);
        component.set("v.VisionProposedWMTUnits",optyProdObj.Vision_Proposed_WMT_Units__c);
        component.set("v.VisionProposedBASEUnits",optyProdObj.Vision_Proposed_BASE_Units__c);
        component.set("v.VisionProposedDSHUnits",optyProdObj.Vision_Proposed_DSH_Units__c);
        component.set("v.VisionProposedAutoSubUnits",optyProdObj.Vision_Proposed_AutoSub_Units__c);
        component.set("v.VisionProposedSmithDrugUnits",optyProdObj.Vision_Proposed_Smith_Drug_Units__c);
        component.set("v.VisionProposedAndaUnits",optyProdObj.Vision_Proposed_Anda_Units__c);
        component.set("v.VisionProposedDirectAholdDelhaizeUnits",optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c);
        component.set("v.VisionProposedDirectGaintEagleUnits",optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c);
        component.set("v.VisionProposedTotalRetailIndirectUnits",optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c);
        component.set("v.VisionProposedDirectESIUnits",optyProdObj.Vision_Proposed_Direct_ESI_Units__c);
        component.set("v.VisionProposedIndirectESIUnits",optyProdObj.Vision_Proposed_Indirect_ESI_Units__c);
        component.set("v.VisionProposedDirectKrogerUnits",optyProdObj.Vision_Proposed_Direct_Kroger_Units__c);
        component.set("v.VisionProposedIndirectKrogerUnits",optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c);
        component.set("v.VisionProposedDirectRxOutreachUnits",optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c);
        component.set("v.VisionProposedIndirectRxOutreachUnits",optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c);
        component.set("v.VisionProposedDirectSupervaluUnits",optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c);
        component.set("v.VisionProposedIndirectSupervaluUnits",optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c);
        component.set("v.VisionProposedDirectCignaUnits",optyProdObj.Vision_Proposed_Direct_Cigna_Units__c);
        component.set("v.VisionProposedIndirectCignaUnits",optyProdObj.Vision_Proposed_Indirect_Cigna_Units__c);
        component.set("v.VisionProposedDirectCordantUnits",optyProdObj.Vision_Proposed_Direct_Cordant_Units__c);
        component.set("v.VisionProposedDirectAccerodoUnits",optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c);
        component.set("v.VisionProposedIndirectAccerodoUnits",optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c);
        component.set("v.VisionProposedIndirectCordantUnits",optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c);
        
        component.set("v.VisionProposedCVSDirectUnits",optyProdObj.Vision_Proposed_CVS_Direct_Units__c);
        component.set("v.VisionProposedCVSIndirectUnits",optyProdObj.Vision_Proposed_CVS_Indirect_Units__c);
        component.set("v.VisionProposedCardinalUnits",optyProdObj.Vision_Proposed_Cardinal_Units__c);
        component.set("v.VisionProposedMajorUnits",optyProdObj.Vision_Proposed_Major_Units__c);
       
    }
    
})